Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A33FD3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 10:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06B1F6B0089; Mon, 29 Dec 2025 05:53:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015B76B008A; Mon, 29 Dec 2025 05:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E472F6B008C; Mon, 29 Dec 2025 05:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D72096B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:53:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65E155E980
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:53:21 +0000 (UTC)
X-FDA: 84272197002.01.6DD43B2
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 784BE1C0002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:53:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LOjXQKxl;
	spf=pass (imf21.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767005599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkwE6228mnRy5innvr4FWjSNZPYoF0wgLDMAwQ6QHo8=;
	b=7FDEEoELdnjOToXwP466djhZMkeFQyMFL2rk1SmnLyPa/nYKAr8iVbuCMLsF7w2DAO6fDe
	3Hy/mqkTrMA7/0kI26zIbUG3WncBsMKSf2+WVRGEpVn1yffTyzr7eSetZcmbFRoKHqCV+9
	tg3/5EBd7cc+vsHXzSfNIbbEDTPvMo4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LOjXQKxl;
	spf=pass (imf21.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767005599; a=rsa-sha256;
	cv=none;
	b=bcMBP4f5PolM2anR9HyUBM1yLY1pCMBf30gW5YaXNnCO/Xoh4XvsFE/qRFldUeu6De0pgL
	8IjtiPmVwWkDKlEo2knfuRD8mjx4xKbwGaZK6wyjt7c4up8NnJoI9/dstb5ga1jJjhJe8g
	xOeu4KruTfq91r5GZP+YtUI4IC0+h1A=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4308d81fdf6so4164176f8f.2
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 02:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767005598; x=1767610398; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gkwE6228mnRy5innvr4FWjSNZPYoF0wgLDMAwQ6QHo8=;
        b=LOjXQKxl9wJGkg4jU91Ty6cSVjkQ8aEezuPkKvVdRgVpZRPlJpVNyrzvMbWdnSMpP0
         2lGWBvp5aok2l9JzQFsDGopVBA7GnUg0jI/ynyyYwnIGZeCIaxZAFxUSjMAnn81zFQtH
         No9mmXtqHbefKKESMbXVJJRebxgrARHd70GYhQfBOvLOip6HQ+h8cYgWXUYRTVafiThv
         hC3qlMxFRHI7NdWXA3pzSHRdY8SJnwzhASuCPkiepHEHjq7fLJPfT6Ldnnwgg5jwGT6Q
         B2+fTLQd8wJQL2pRZ8QEN9HMO0Z/gvtt6G6J+xmEcZ6p+W6rsyNMfU2jiZgBZsibd3h5
         ERNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767005598; x=1767610398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gkwE6228mnRy5innvr4FWjSNZPYoF0wgLDMAwQ6QHo8=;
        b=D6OLjeBlZYRMA+s31YmUCPG9E9Nv1QBm7BOMqemUOP/ppnQOm9kpdAS+rNxgYJ8Iyi
         4ocGBMafno+Fm22Z6MmSd9e3GrIi132V6CyrI5i9Weu9SuGCO2vwd8dgdGILuttTb742
         sDd1MQ8eJb4HqTtc8sGWwfhekOi+NBq7PJC2X5UKdAt4Rtld4Fyfa3P1QuEMMUFGk87C
         NVRUep5bidLogUDe7/zcS2DjhkPW5w7senlTfPpCaGvbYmPMdRTLPH6YjVECvTQJ+G7y
         N67jqlssU4AL8Qixg+bC10NquM9EgIiulSOtRGyoFrwCVRqVilQTFHEP8S3cCjv60ikh
         3y5g==
X-Forwarded-Encrypted: i=1; AJvYcCWYWV/aTFwkHGKnFlN+z/G0lWF7XNPNFnh1U9YryVJUSuJ17Z5nEJ57E25Y5z7rMEw5rRUiuuVHfQ==@kvack.org
X-Gm-Message-State: AOJu0YzlZ5y4DXlCAhFGYJ8115n9tnpbMIpmPJukR/oz4ZIyAR4JbZGj
	g2KXxBwDXZVKpjH1kTtGIsR6F9AfDUQ8rvQjNTABHEFNaplnUWA7Xl+XjvBOY4PkwaA=
X-Gm-Gg: AY/fxX48bNaNNwqfC+frm8wYSyl9UaOoIptvc3zz9HCTVdZw8WOMe8OAipPO67cwWyU
	lSIbg5MRvWKiF1LvIcKO3Lz4Mf15msEjlgivakl0zmnT22vVMUkFm6ZJAE7bw5cQEw/0+S1WkrK
	VgX1XnFaCHegz3QWHhZvzS/Thn+OE7zAkS0M8LqNsOgVnfJvAoxPnD3dfGk8OpHgOs8WFGo4rY/
	z3JMT1crlMGCJ3tABtKtoYssmf9CGZPiEaBtFnUWsxlmrQf7Dwo44tnAVXu036SpXj0eBlY41j5
	Hv/hgExaPZJ7GLz8jhSc6PUBAQpw8xA9R7F0nt7UtQSbDCyf0azUqPEH/cbMk7yc3UKeMiAxu4o
	Hfmh5+YYlp14N79e0t7weK5n7uUyAhHqKLoZcdgUOuyu5NS3S8KIn0WCvdaGrhjV48odEGHznRo
	AV+TtM5lLcqWp1/icSkod1T/5x5ecE9oA=
X-Google-Smtp-Source: AGHT+IHEnj09VtCvhEI1Mnpju384PM/PFXJ6IVisB8INMmaBJgtKDDRSEQKzdcjFHiZGq8ztnAkNxw==
X-Received: by 2002:a05:6000:240d:b0:432:86f2:791b with SMTP id ffacd0b85a97d-43286f27a87mr8136274f8f.63.1767005597667;
        Mon, 29 Dec 2025 02:53:17 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea2278dsm62489855f8f.18.2025.12.29.02.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 02:53:17 -0800 (PST)
Date: Mon, 29 Dec 2025 11:53:15 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <a4fzkz4lznq5hrf3mmrhpt723rb2sl7puo6ziwg32ye6jh7rwk@baexbljj3duu>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
 <1264fd2b-e9bd-4a3b-86ad-eb919941f0a4@linux.dev>
 <aVJDuObeV2Y99em-@hyeyoo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qya2ibtxqvkulq4p"
Content-Disposition: inline
In-Reply-To: <aVJDuObeV2Y99em-@hyeyoo>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 784BE1C0002
X-Stat-Signature: 951yaud1hcza7cfr6kiwrk7cktwyo9qn
X-Rspam-User: 
X-HE-Tag: 1767005599-564003
X-HE-Meta: U2FsdGVkX18HtGx31lHAevjgVQ4oGu4X7kz25DoOMiKDBd8yuUVsYFDx7peax+1OGmWn2JcDT+o1QCGkAaTKqeSnHPlBsA8A4fYm3UsZ3eofH+2eOI3Bz+sE/K/qtRvtaxgcFD9Hl/HF3z6xrwJC0P8rs5k+rILJJjswZ5yJxvwAIVllGrQnjh4jdZduAcp39rVd0PfuFQZlcJRTKTl6Vn5gbAFlabD7y3Ik34xw8C3Jelv7DBYoq6gcMLqmD/mN0ujL4cJ9vgs22MN2Q9UqcmK5nm+f3vJjMo/2hoa2bX+R7elNkSTMvZiMaKa3YGTE7vkZ+37330gTg5XwTlgfvnRx2ltlqFPvRKRNpa/iTe5/v8NtL4vhgi6xg4GewF807OFax6NOQOreCGc3/hWez3/rq625qxlN2Tk6hHb/XrMK+Zyx1qVoRGCNmvGAIqZ2krVxCRu9am+YGIGH3ySBlpTZqCYMijqDDEYNMpinO9QUJisnr65kHx8mskw8XftXIX+Ihy1RR1FG+pdd+KuEMSoc1Ly0gRT9zo0o5NGX7zCWLvaE5qWdmcEu5dMVDEhHMIIkwUD5iQC87K2hBUDDR38EayAjgKwf+fpt0NpKFq3ngHIyFTz65aFC/2sNWb3hCoOiaxLcgqHlBRCIa0kwV6ZQyP65iwejEMkamt9a17vqo8JAjlK/9YZp1o75Crzwx1g19cU2adsJIQf1kNVu4VfnM/1ewZVqB2N13vNNjdsTQZ1I5/7v0dY5s8DtN+N5ZPn4DTExpv6Nw1zN/u+oDQfNlD6ny58oXAI0xbluYol8BD+vTjaTzoyjrcGjlRZo3LgvjLQo4SSEQnWpO8FXZnP5xa44wYJLggJzTov3ybVgytn98XgzI2pBFt2+vjDiT8f7KqmNooLKJxqaQzFm3F+s2C2oLsVfnC/O1CXSIKPCtwov6HVAJ4iwst3ln83WK/MWV0LS1CLujwkbacx
 Pxg/gYA1
 kIZGlzQERN0E88+qNhyzRKD4BNIXoPdzqqIebp2Tg9igRiAs7sphiBo0bo0/I4JirdK8pEf0JkkgItx952C3c4kWk6nLkk5AIeAwFt4QRCcYzPQOYcIGeCbvJDqXsFrXUQjyD/bmEGQs7onJzKAOajAslKcLMrRWzVkJdZ8TEN7yYahOsN7nf1f7qAbjXZY6pNk3Rtrh7L1Tr+uQoMKiNA833d7pKd4Gd/Qt9GaIOvIr2cvb/U+TTomm3lG+7qJcE6uKABFbFFuFGrAzO9QSyMv86O+Ai4YxoQJxGWAP563zTzcdvZ7tJIaUtNud5IrgaN9S3DA+j05xOK+/80s8T6oEenIZ/OXtyKpcdUtYtWuf2bmuIYLn8QLjLF97yAZrgUuhXAiw9aOifrNFkni2FJvuGXyvYzR+xq8rlhuxyE3QCLYYUQh+K8NNvSeVOuAiTN4VP8Wj60gPLiMs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--qya2ibtxqvkulq4p
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
MIME-Version: 1.0

On Mon, Dec 29, 2025 at 06:35:22PM +0900, Harry Yoo <harry.yoo@oracle.com> =
wrote:
> > The memcg-v1 was originally planned to be removed, could we skip
> > supporting v1?
>=20
> You mean not reparenting LRU pages if CONFIG_MEMCG_V1 is set?

More precisely it should be dynamic
	!cgroup_subsys_on_dfl(memory_cgrp_subsys)

> That may work,

But would it make the code actually simpler? (Keeping two versions at
multiple places vs transferring local stats at the right moment.)

Thanks,
Michal

--qya2ibtxqvkulq4p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaVJdmRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AjcmwEA40zUj0sp6cAAd3bXgrQF
sR0AqL6ydZGZfdd4i1DDccAA/0xU+vWaUPKB0gC3zq4HkdYA+8vTysTe6W9hZxPW
eCII
=A4Sk
-----END PGP SIGNATURE-----

--qya2ibtxqvkulq4p--

