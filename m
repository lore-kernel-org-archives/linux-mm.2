Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3232D109E535
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 02:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F5C6B0005; Wed, 25 Mar 2026 22:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F926B0088; Wed, 25 Mar 2026 22:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426086B0089; Wed, 25 Mar 2026 22:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30AC06B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 22:00:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F23615C311
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:00:01 +0000 (UTC)
X-FDA: 84586558602.09.5B3E7E6
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id DD134A0010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:59:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="EwHWqXo/";
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774490400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvWZrRCLZkYBx7RNlry+W4Vz7X6l93gflpZqKgr2VYI=;
	b=JN5y9wqR19KjDnOUX06BLaSHUHHkseACjxHCer+dPUaRf34p3CbhJbTPNMYDvtlvLtcxjr
	MpyuaumlxGmb3s7+gy3hpHSD8dR3wiy15W/gVlA/VN6lEO0swyTxqGEnQ3VcIJ+vrkHbha
	pqgi6X3SVcgRscXs25VdoFVG3oD5Dhg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="EwHWqXo/";
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774490400; a=rsa-sha256;
	cv=pass;
	b=skr/NnqLleGVNpLzsNGN+9ai2naaMiI233lvu57h9LYOiOw4RyQnpr1YLX0rBJ3/e+PEMM
	wBeTdyUqIDoUXxQjX2lwLCVnyaO+dEUPpcN/p1zl5edjwjRxbT+RUWEkJPtckbYb5UrP/Y
	tyOhb++eX+zCftVehmstaUXFjqAjohI=
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38c620f1699so611171fa.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:59:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774490398; cv=none;
        d=google.com; s=arc-20240605;
        b=fxVI0MMZFhqRK2RgkjYWEQo0KwEtqRhkA9girhIAHwa02yUZZWo0fv8gLAvKzFzul1
         K9FsGSvyn7SqPXU/u1Ym5WatKpBh7zg3wuogTeRGjzL1zDMDoKRNA9w3d3892cdzD5L6
         qcAJerVOIUSB0LyomrQQ+SIOJ4rUwwFu0O5MuX+HC1iXP2cfCNWujeF5+qyTsTu+zYuS
         /Ks6iNT51xS83pHx5aM9lUjl1aa8Uj+5whqyqaH+Js130DkHyAdIB2phGk4dbFsPcnye
         148OM5SzZjvM2V7H90F3s69PoauTTDBLx4miF/feEJVmIHms5vxdSEnGwtOh5gAp6MPh
         6NWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xvWZrRCLZkYBx7RNlry+W4Vz7X6l93gflpZqKgr2VYI=;
        fh=etAajHXysWIPznOB4tbcBqsmH5Jk/Y+qR/WIcb9MSJ4=;
        b=L6+3gnPYx2m6QINiLrpojfa+ZUXI+mA96rD7PmaSHWKyLRb4lEhhTipHbXA1R7Qf6g
         vui78TBqJU1LlKcnYG2rhOhSDwphOoeLHRjPhBVr4kxoSu8i/cR0FYBtSNE81DRupv3H
         Ubhdk7tTfGq/oImBhGuuyxu3s0a4JeS67quyy2bh1Do59PHnd984DW7HDoVUx189c4bX
         XM+31CKRH9mE2CecIuyHQ/wtBSJ2joiFuzGGkfVqy4hSlrEaSRNdRfilUAjGqB73j+92
         whAZ4rpQTKWzuH75giU7GlX6+EDPwBU7thqhUinzy7p06IH6dP9ePZrHxbu63mSSz6jq
         iO7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774490398; x=1775095198; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvWZrRCLZkYBx7RNlry+W4Vz7X6l93gflpZqKgr2VYI=;
        b=EwHWqXo/21ay1frrPgHsQ6spX4wNqOJPWxRJ36PENNlCxU+ODjijVNM2BRAlhN3XjL
         p170tarkdoOU8iYokgEZePzjzMVpPSkB5wASzl5Yiqxh5/Xw7ae0P1SlqK2Y9rPphHAp
         0sdm81rgFTmdGDaE/8gMZOY2V11i1h6lbFqywpg1tjC6PIwWMIJe4Ew8fYDNSJ3WbkRr
         UusU4P3MpUtYJtWVMSJjycwwXptmnwpNzI0OnE1cSsrRLN7ZZfnncwXVzlvvS+gxWNZP
         F7k8Uxt2ff2r6ST+hJaVUYRYHjFabEpV6oFLMHAi6ce6joZ1eTdujHrE0+8DtDNvdcMB
         GdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774490398; x=1775095198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xvWZrRCLZkYBx7RNlry+W4Vz7X6l93gflpZqKgr2VYI=;
        b=Rv+SUXhvXMSrRiR0DUSGTXaKfK+SHu0N5fxjMsoYFhsZxchQP6CP/Pfi20KeLeLoGJ
         4CLT+Jp9f/BYQjxsjpq02Zz9C7kihqn6ZCg4prgr2ukRaED2U29eiyymECkWbwL4IvnW
         BCvlszAwm1ggdpzyhxRE65Pgz7Df324JdslJ+6WACkuU3R7rwMo6LIZq3/KajrTzE2kZ
         1ZYfP8EyOJWvzR7SmkcShexGNHHc5TcQYtZzdEdkdfEVvnfzzk1FuGSK2/CSZu3Fe1Uu
         xLkMpPESC7X0QVBXiBHEJyzI7yRZBGcKe71UeQ6ujCMbG4xX/tsOfXXYKnBs8wrran/d
         NRlA==
X-Forwarded-Encrypted: i=1; AJvYcCW3d9lyZzpwNFgYpVpMyqWZVA2pHpk+SXm48XQnCgWY0/+ODcPz0t8yKFz/kylRbwwqpz37mqIhEg==@kvack.org
X-Gm-Message-State: AOJu0YzgMinJJIriq8ko4vKCawunQ8mhj3/3zK3G0A7HNrCSPdP+Y6Zl
	3WyF736GsKQVgyuzfjny/ko3fJgApn+E9EFb0m9B5EEz98GmzPO1ZCPmR8YRqfe14d8vEvhbWXj
	EUBfamE9fvKn/9Zxx7i9riaaeHj+NGcg=
X-Gm-Gg: ATEYQzxRoldkyhgQOssWNza2tCctHHtPpA7fMhvX7Grddg1aER6Bhbe4imB2ZUS8AFc
	g2W0iu0gJvFJlDte9Bg+0DkfT6y4VhlYl9pYGDFYqI9KAdzfBcsemlAdiLMGG+upixfy+/xJzsb
	RnRHik5WBfyTbOaV1fBbQLpl08vqiulVZ/d04B2ioFRKgBA/xbH8NhIa5VK/edUBO6ODbr9K8Yx
	rkYwx6uuWKQ1jcmAqfFPkpLYvki2hNZChTmiALQYtihhwEMOvt5c/uuavPdAmAfpUA6UcViQGNj
	8UJNhR5g
X-Received: by 2002:a05:651c:410f:b0:38a:5b91:ec34 with SMTP id
 38308e7fff4ca-38c431ea12fmr13920621fa.33.1774490397725; Wed, 25 Mar 2026
 18:59:57 -0700 (PDT)
MIME-Version: 1.0
References: <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org> <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local> <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org> <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
 <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org> <CACZaFFMb_1u7ckb5+7=wWApOx-u5kBxx-+2Y1Cjd1Qad4kgHRg@mail.gmail.com>
 <20260325115932.d2841f29f318454709fd4f21@linux-foundation.org> <65853d35-718f-4899-b4e2-e0d339e57e5a@lucifer.local>
In-Reply-To: <65853d35-718f-4899-b4e2-e0d339e57e5a@lucifer.local>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Thu, 26 Mar 2026 09:59:46 +0800
X-Gm-Features: AQROBzBNXFONkiewJYAiC2cc4C1is1BijW8kTftBr1N9NdeMqf4s58w6ZMXAfYg
Message-ID: <CACZaFFMXtujt89--cWr4Wnmeais1QU0afqRrNcrr6cFZp0rxAA@mail.gmail.com>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: e5pbw5kje9atye3kzck5n5tpwawhi1ri
X-Rspamd-Queue-Id: DD134A0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774490399-252697
X-HE-Meta: U2FsdGVkX1//OS5WcZ9Wnjoqd1iblVCWpGOiPif7WKjKg6PhKwoaq7o3jNqgPnPDi70oEJ9uQokXURXMZapEZJFn9cDART4DZlQgaqFkPGltAg/JM+PE6TbtINodE3JMuQJ05dFSadaZ+fMxcHgJ93dn6+YB6w9zIoPAymy/F/Ig8Bn6xHrPebzmCYRLDk5U5h5GqAwYUJCqtwHklRZkKZTOzL5sCjGFHqrJ4mrkX9b1v6Td2d9fTl077yly2K/GYJLaVcXb7R4asEp/KryOWTCdqA25Jc/G3SwgdjJL3ryfL1/dVP7OG0+P3sm4QIRRxrXF7KS/SCvZ2uvCVM7rCPVV5Ik8PkfEUHnmvQs7a4riFlFWMlPCAsGomphRw4T+OB18jSxj65UolKwinQEsP+Oz/k+IEXC4p2l7gd/fhm8B4dAwcHEcgs++A51jIHaBckMt42iikPC5cUWqvtWRXBBso7N/V7fRiVnwq6WY80s8Dq+HcTORXI3G6gvQICWOVDlcTG+ajCmKnHoSRyNRiSimJkDuOYOR2l0qur9gBLwK2w+GareAGIEk4DaQTk73AYqPynxVVi6cp9n8emTsG09/NfePvHbHfVCjvmwaHZFlPxJWxJgQtsy60Tl/Rza0+kRMZQQMdQQ3tSAgdsRIMJnKVcCNLzpi9bUNFAcsKIgBu2KoDztkpt2iJNsvkoNbzoFTDQwgBsmN5K+GSvd2sDOUZpBZhsAvJvO9KGq5c0vPVReMfLBmqXld7nTIS7yaIRQWj4xIavk+XB27haN3OrTTY3KSIILQ5fSFcJlvVJCqCHlfJHQGwdnbCxcFayX1gMKsDGO7DEuN+Od8qpOZvaxX55/vxySLnXgBGzCjnSQvIoDiJcfHsXBvEqCuU1Wy95ALGntDV4UK6XEE6q+r/L8VNP3t+2VXTjg14+jH45M40bAW1LK3z9AGJOaWzf8GK7VeEhMUe1QjETx6IHf
 HrpMkc2Z
 Ux6QvCDWTRNpO2NJEe4oQ70gJkcosKcAOyYel0rvoogC/gFiyjQZMjiiRnDcxQuUlsnoRr+XIzGAA4Cywkpg1c6+B4ARCHBRP5jlP3cbAuIaGc7gqjdYDOTwZdV1NBcw0M6RAno2nAaiXuFmfX/8s6Nlf6Lf7BM0yDmr30Vokabkia4YNM7o1vLOjIvEigu479+RY3MlZTKxoTEXZOwlYVux8gEdWAbWtuvC7FFuQNKRPOGkdTUb11R+r1YGG/ldQL2+gHc/zNs2lguIoDB/YtCmUXvAveO9oFof6n1HA8EViOVIaJe88ul/+pR0Gm3IW7m0dtth23wxbd3Z/OMGI5YnsHHBvCUeDo+OX7CReAjKfPCN7ZcFAeGRaVZFrGGP2dRHXDksJNls1pkn3XvqfqiQGCcLrTBErkZY7vh6jS75XTTumHVRdISXB2+3utkdAFpQeT2gvPm+Xp54N/h4m8nK9MfeMBuOqzEiLAJ9wuXKE5u0Gf4xvvRQUv7YpkH8faVH3UoIocZSXd28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 3:04=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
> On Wed, Mar 25, 2026 at 11:59:32AM -0700, Andrew Morton wrote:
> > On Thu, 26 Mar 2026 01:00:23 +0800 Vernon Yang <vernon2gm@gmail.com> wr=
ote:
> >
> > > Although this patchset is already in the mm-stable branch, if we want=
 to
> > > resend V9 version, I'd be happy to do so. Please let me know. Thanks!
> >
> > Depends on what changed in v9.  If it's a major change then I expect
> > I'd drop this series from mm-stable and we restart the clock on the
> > integration and review of this work.
> >
> > If it's a minor touchup then a standalone patch against mm-stable would
> > be fine, or just leave things as-is and prepare that change after
> > 7.1-rc1.
>
> I think he means just resending this for the sake of reviewability or

Yes, Just resending this for the sake of reviewability.

> whatnot?  Anyway if it's for my sake it's fine there's no need, it's
> already in mm-stable and I don't want to make a fuss, I'll just try to
> structure review more efficiently in future so I don't end up with BOTH a
> backlog AND a random-walk of what I actually review :)
>
> Thanks, Lorenzo

