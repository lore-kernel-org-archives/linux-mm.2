Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA16C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E24C6B00A1; Mon, 24 Aug 2026 08:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493686B00A6; Mon, 24 Aug 2026 08:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9426B00A7; Mon, 24 Aug 2026 08:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14AC26B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:37:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 998498011E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:37:03 +0000 (UTC)
X-FDA: 85136112726.23.E6BC0AA
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9CA61140009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:37:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LDxNX1Ik;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787575021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86o2mla0Wt4YoV7NQUB6bfRSm8bpfsWlSQQ8/iZvyTQ=;
	b=iHFRFvBenTBKu3RESjz2ghW5siG+srJYwVw5MyfxrPW2Lr0R+l8u5wKtl6PPydOtmqgY+4
	WSRvcSA5x6O4ZYmn38gro8YUhEJWqevXjHSAqqH7srocmb25xK2C8GhCGXEdHOVHK2fYS6
	o/St398iBXmh+pSRVW5gLoyJfP3+IIo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787575021;
	b=NdbRhu+Xasx/85lrC6nJ1fWWYnvc1DylaX5X8OOTi/zGCwYrW/roXImTPzDk8NmEHOJG21
	N8y4cQ9py9o/VRSFUxCsqO2f3UZBly37Qr+Gul+vHyXA151pNuxopIceA93UuQ/ETFgVzJ
	H86mQ1idW+XXRQyh3zPbsI5kNgLu1Qg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LDxNX1Ik;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a38098734bso5896581a12.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787575020; x=1788179820; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=86o2mla0Wt4YoV7NQUB6bfRSm8bpfsWlSQQ8/iZvyTQ=;
        b=LDxNX1IkQ77jjCm+G8JIya/2KDJtf+7pAprRdm1LqFYxCa/w1CNJmM7Zb/jY6dGiQL
         2szzGXrprCqle2GPm5O926nmp8jJRyo6M0B2XPTFTdzD6NFSICAtMjTG9El0EJwszNkf
         MyOyn1qVj7u0rmODg4s8oRDOE6wT8BI0hMRVxf52AnRYkxTAkLY+s8FDGEyAkX0l7926
         Ysg6LTK9ISb8ijPQNAjYbYuDy56WKPMp5UOca39OTAEtUqNL1cbeiLoMVxQ2uAeineT4
         0tmQQr9vV/taCgCAGBGuqA6tMONfAn3xVagIu27j+TTi9kJFJBkLk3BsB4HRhJDnWZCu
         C5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787575020; x=1788179820;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=86o2mla0Wt4YoV7NQUB6bfRSm8bpfsWlSQQ8/iZvyTQ=;
        b=WxYqtKd19Cyvu/iYNGCmR7IwzT5Cz120j+9dRqqUQ8SF/1eHgwBoxshlc5p1bZ6SR6
         T1Re6kcHKSLFN9R8udxWBYv1sKYzIjoSfBii2/d7Np6+BCZKWbYeuFKB9bk5EzmxM6mZ
         UbAh6U9B71VebCC65JrKvGdz0404ss8DWr6ZhKaRVj7mjvewUkRuxVaZDhA7yRLg6jt+
         z8/UImChnqnUub4uuCQPOMkGXKocnP5f3eX+cZFG+0mbCVtw+mrBwAWLDdNjP/GGj3Wb
         SWR9dtPnWjBqcuaLV5PMkB8B0/49Zf05Yl8aJt15lWy0NWoSkCUNOt7i+KZSms5qhqud
         nONA==
X-Forwarded-Encrypted: i=1; AHgh+Rrfo6hHfBC812bJBeQEahDYDmMQuTkfV00f2AsR4axVZOhDe8ZRw5fvEOhMl/MRF665Vxk5RXPzRw==@kvack.org
X-Gm-Message-State: AFuF++kde5T2CnceZ465KyaushUGmJAWTw1hvBsCgxY8jyB2Epil114/
	eiPirvK2j4BqW6EZ+/cbiGP9Xze+TC7W4c/R3b9wXHYZZookaHnJ7z1xPK8s2LMgVEw=
X-Gm-Gg: AR+sD12BpRpTV97PEa4ZHEEIK/YrvPMFJcOuW+2BAbXFjrtBWZP1zVQTq8hgh4ZwjMp
	pwALKt56ruMSI9xUk+yV+kq6Q07L4voRa0HINLDCl4hJwGR3+DrucVN8C9ICJAHl+ziBzHcTIHH
	LDkc9J8F7jSvILVrVTJRp3Y/jGuiY+aJfBnAS8r1HxKhNSe+YYA6H3EnBEf83JkkFBwpqSPH4kF
	FRNlxAdjRNZs9fO6AvXdOJr4zII+rj6u1RNNDh0wjJEEk4pbV7wpau2h5y8XJIHMzzwMDADTTmj
	0ZSrySAGCScNipD/HvRlI7htP5VIiTIUT5sZX6k3mGIyiE3IpMABoY6YiaH7jWaKpn71n48umej
	TX2kS7c3v+KBeBZFIqm1NwHY2DSLk0niWhChZ9DNsksGSnLYtq1Q6Mpgv0jloREwdIKClJHz95H
	a+XFAcQagAYGcCSFRtpXiom+QxATR5+ooCas2cZpzlV80eEsnka0XXCUXnO7fdf+Q=
X-Received: by 2002:a05:6402:52d5:b0:6a0:a644:355e with SMTP id 4fb4d7f45d1cf-6a42f1848fdmr30356559a12.2.1787575020160;
        Mon, 24 Aug 2026 05:37:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5ba19e053sm2079673a12.12.2026.08.24.05.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 05:36:59 -0700 (PDT)
Date: Mon, 24 Aug 2026 14:36:57 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
Message-ID: <aow4qP5gj9CfiOr5@localhost.localdomain>
References: <20260824033533.2147900-1-wfelipe@google.com>
 <20260824033533.2147900-2-wfelipe@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lsaln24baban35xn"
Content-Disposition: inline
In-Reply-To: <20260824033533.2147900-2-wfelipe@google.com>
X-Rspam-User: 
X-Stat-Signature: 1jg38m38zuowmfudjhxzrrfbmz9h3t79
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9CA61140009
X-HE-Tag: 1787575021-270150
X-HE-Meta: U2FsdGVkX18KrI7s6MxtOWH+Wm9JDDXymkICEdIRqcHsAb2c8mavJmNu+xCMzgphwQrtFeWVwJmuXNJJ/TuZppoCzGSxUPvKi9vW7YeP/vh7BxVQpYY0PicK/yC/ta3UHbTWU1BnEbEm4c68UOdnCz2maWiZ53ED2BIh6WypY4qOCJXJrlArIfCIa1r/3OW1DYJW/YTHtZsnMeveVetPzMjGRtADxKSdskrYArmU+EnN/qqQExDiiVzeSzA1yExWw7cpACaCPLJsZZiJarjP1zPfPP086GONEtWSFsbbysgmZG8jLirl4/mikuIaX/W36L9lMy55VhvOcZXgK+4IcgoYKh7idsZWOKu59MGOT1aY8zeFrp0k5Jca5qUZw7qoiOQ/2Pj4EoNeMiRUjSm55G5ZHJLwxJELkTtGWv0VSX7ziyMz2wyhm5E8TfwowhuNIkw97zQxIIMK1i/N/rOsaD4G32Ka7VY1GxdBnzydd9eNez8WHFm9M7R001ggmxS9rKehJa6XGFHQkbTjSv4TfnuU/GD5T1QmYxYWy8yg1SVvVzv4s/MV6oZia875GL7eQTGOYORHtqPdgO5fdwnVpqKg2A+Bbh9sFjJKaMcS/POOCQdgsXa8a4CARnpS6Od3eBhcJJjaVxBTg3lBQ5gnjWR0IyMRzSz/UpjcyxBCZo8Tjpb6Kp21+kMrpEVHuM/VqNB7aJpUhcdvnZRg6YLZk2D9xaqfdoPTViwhpdz9kKMLdv8rGaP18pGDViGhUxnnHheRZYXNCTGMiOPNUy4ROQPVgRFGxKNgNUHJ9I4ovaDSi1ubfcsQ16unFGYVkU6zsuMySWrwcjbbNEsgD3uijih127gPeuAWP8TRYzsZ8uOyP1Va9Rlao+NmzZqEPuwJSU918tA/NLqZ8fYPlXQDuCgl9mB8aNipw6/0+s8dXU78EX7OIGgR7EM3KmfCA/MV34hUBpUZs46o1p7s76I
 znXNJCo/
 /bc3uA9uMgzhg7xqgo5mpicdjBykwWlehi9MiZYet3pYttfqKNI9dwHEkD1ET4zUYfArTJ2dt5VYvisH4oKtaH0fc5MgjaURT6vhMDaVze/CL6wK7lCmQzehWiocLimyiQZ7RafZSWxXu3+l1g/9hUWzqad3MGw0tNI7BLjoOY6OZRy64JVw7fMqM+jhN+UQUXW0zf/xEpsKLA61q0t+gzAuoxkR/B0ikZlIZrZy7v6Fo2++51Hv3xK79Os23JY6mLyz8TK1D3VdKEPcsd2burXVeX0ynG4a1tVJ4KZcSjTiPDW5Bv4886L7VDpEsQQXkrevCGkm6khE3j0VOO3uhRhqam3EgX9OITXHxXOFCzes9qeJBkRWSv/8K5StampkoQjkA0liO7PDSskZ5Ge/6Qdy1FdUDYtR0QC9ti4gZkl8W5O5QjGcK7WulAbIFFvyfFERuUTpO6mw18ov+OfqPh6S/VC0BvI7DH6jC94hqSd3raaVEm4KKHZFw/ePK77dx3JzUgvbLCkBS1PG5QiSz8yC0Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--lsaln24baban35xn
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/2] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
MIME-Version: 1.0

On Mon, Aug 24, 2026 at 03:33:57AM +0000, Wilson Felipe Pereira <wfelipe@go=
ogle.com> wrote:
> When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
> test_zswap_writeback intermittently fails on the initial run after boot.
>=20
> In test_zswap_writeback(), after waitpid() reaps the child process created
> by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
> can fail with -EBUSY. Under cgroup v2, enabling domain subtree controllers
> is forbidden while any tasks remain in cgroup.procs.
>=20
> When a child process exits, exit_notify() wakes the parent process,
> allowing waitpid() to return immediately. However, the cgroup populated
> task count (nr_populated_csets) is only decremented when the exiting
> task is switched away via finish_task_switch() -> cgroup_task_dead(). On
> single-core systems, the parent runs before the dead child has been
> switched out, causing "+memory" to fail with -EBUSY if written immediately
> after waitpid() returns.
>=20
> Fix this by waiting for cgroup.events to report "populated 0\n" via
> cg_read_strcmp_wait() before enabling subtree control.
>=20
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--lsaln24baban35xn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaow65hsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ai0QAD9GkXMc6bI0AhzKJwbSaqE
aI4XwcIv1S0SkdLiNbkxuPMA/3XaRn1ZHXQ5i2Jrq1+ppT0VNUvfWl9IlFN0Wc/x
KzEA
=DvGz
-----END PGP SIGNATURE-----

--lsaln24baban35xn--

