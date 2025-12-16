Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB04CD5E36C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 13:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053126B0005; Tue, 16 Dec 2025 08:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19036B0089; Tue, 16 Dec 2025 08:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA636B008A; Tue, 16 Dec 2025 08:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA0BD6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:55:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DECD60574
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:55:49 +0000 (UTC)
X-FDA: 84225482418.21.A96DC9C
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5F2D740008
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:55:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Nmw0aPlZ;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765893347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzYsjUJdKV4iptxsf7n2b2/ebFnlruh62rQM3GVQ5qI=;
	b=I2dQs3PP2XiDG/WR7l0HMp1TRI04NTtuRvlwcjd2cX1/Xww8HrhjE3IWAwxSkmjzmBTFTk
	rv7ATVhQJmVx8KaqgsYe0JXBKvJUlEyp9/QT0mTqL+lxRBJ82/6+IX9OsiL7DZ4y3AD7JZ
	LoCffP4YWjET6LOLJmtnMzHGtBSD6HU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Nmw0aPlZ;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765893347; a=rsa-sha256;
	cv=none;
	b=DRETZKkr61FjxYJWuqWAu4FYFEPzMQzypy4xYw+iIdOEyVKC4CByZAIKlgL32NR81sf0yr
	yV1lRTW7CURJAaTXs29yEVH70Neb7L5pSkx97xldWkCGtt3iV2hwRI6b023ZFtMAJ9ZpKP
	nQSPyOwoa4QU7YGE/A45imv/beYFimI=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4779cc419b2so47725605e9.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765893346; x=1766498146; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XzYsjUJdKV4iptxsf7n2b2/ebFnlruh62rQM3GVQ5qI=;
        b=Nmw0aPlZDO7ruBUWz2pqf41p2yKWL2eMdSXb7aA1STd58ZYCUt6IY6I5BhjC88FiRi
         opotq4p7gPKP1CbU3VTVK126pQc8/ubnUUPZO2yvAXeJ9+qJ+wrvTJvmhsKgA44S55Jf
         uDvUCArkhsxy9vm3ar1+9w7MOCLSGAZuuHTx0wloIauFv7fK/r7jdnVBovBb8EDt69NA
         +ejOZZaRvTym8rbfQfsKkKsCAgnE16SE9nkz8TKGONl6XsmBKbwEfFsrIInSUbEbXq6h
         bODM+yyYLqfI0RzH5Lzq42QOZGwZ2oMGoBK03YRiPWvm/a3ct7UcdFSe+cEmDsq7OSWt
         eQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765893346; x=1766498146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XzYsjUJdKV4iptxsf7n2b2/ebFnlruh62rQM3GVQ5qI=;
        b=ABMbFVO1eG6WAt01JGYFprRzoCejNJC8zEtBXVLeJRMXthgsNeINwa6/HW+O5ROZyX
         YkL8fQdhfkv04NoFBKT5Ipe0t9dabTQ9Q5R4looCMfZ+6l2mzj54mr5sggApbprDw7eo
         beBf0t+OxWc1EMq5B+BLGGc0aIv2hOx2oZ3GBDTd08kNy2ZXTh91425ndm7tzWuhruEk
         iK9SsqjuuxF2xyAHHBQGhVlQVMxVHr1HNptmROplR/yX7u6WL3HIqPvqkGooLwKHEn9K
         K5rDRXaBHKJcGQnG8Z+tZ3Mllu4lD+0rJ9eviH5sXlF4Z6gE3TFO/hP2ltR5ygXIUMUv
         fW9A==
X-Forwarded-Encrypted: i=1; AJvYcCX9DrjoMMiro6F5ZWlO6l8UhBRmvcahiJn4Ey+1+9lcY5sk9VlmyMxh7O1QkUAHbvB5GLgCQ4Nscg==@kvack.org
X-Gm-Message-State: AOJu0Yx/ZEQThjegtZDJ5AArmU+xL2qnq6NXS2AqkxA+B9XDaWhMRIcj
	3gF1VkY6FGiHwEnjm7Fli1KP0qK1WnZL+awp8/nG49nvrkJ3wxcfFwpk4sjbY4QHK+M=
X-Gm-Gg: AY/fxX4xZhQQ9t/8T/MVQzkP+TaDq0pojj/B+E32m8bUHblW28toFBhOJdkLLiqBnCy
	9DB7AC49et5y9rAHPL/NiqI1E0gjORCsIkqGSOsYILuejeTAC3lLEv0ypRrZRHZwI8tcwmyRb+2
	nSnqa0TPeugoF9+MK00bh0bs7Ezr4z3GRc8+d41fyB/Y9tM5SaYJQ0Hw7dFQ7fsoyMAR1gfMcCJ
	B/RpQW4cWnRjRe3ukW3yJF23Yuvirl1rTgIYu0YqKtEJ0j1+Hj9+BYVULGPCd7TydK4iOLVaAzl
	py4XF2sPGUzvUIGf/7KC3bQ3GFUiauc8qwJ5PrkJLpZsZGqcjrwEmUVeHAnPKxFEWdbm4NAqKtI
	4HuPXVNyopu4zOZYs6N2TrdjdLKhLEccNbh2bqKk7nGI2uLYi6C54rEtQhgg/ysaMx7mf18U9xT
	d6sqS7nviIbNjK3wvBbzS2KaVHnFNDF4w=
X-Google-Smtp-Source: AGHT+IFqxFK7p8nPhkFf8kGXRC04JoiftlfevY8y2VaPpe2R4CSPfjUz8W1kpkIUV32LWlyMmTP0TA==
X-Received: by 2002:a05:600c:3486:b0:477:54cd:200a with SMTP id 5b1f17b1804b1-47a8f8a71d5mr153328105e9.6.1765893345659;
        Tue, 16 Dec 2025 05:55:45 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f776898sm239716225e9.8.2025.12.16.05.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 05:55:45 -0800 (PST)
Date: Tue, 16 Dec 2025 14:55:43 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, david@kernel.org, 
	zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com
Subject: Re: [PATCH -next v3 2/2] memcg: remove mem_cgroup_size()
Message-ID: <6wm77ncacitv7fb2nc7sshpjjqshsh4xffey4qxhzu6oz4gevl@qehhysirzyhq>
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
 <20251211013019.2080004-3-chenridong@huaweicloud.com>
 <o3hmzratjkcxms3ylnjiuashclllf7mvz6ttkfrz4lybdiwhhp@yeo5my374trx>
 <476fcde5-d54d-4b15-9870-844b3b8c700a@huaweicloud.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="quczqmdvgytj5i26"
Content-Disposition: inline
In-Reply-To: <476fcde5-d54d-4b15-9870-844b3b8c700a@huaweicloud.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: 56hm84iidmgwjhgfne654q7xkpjueamn
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F2D740008
X-HE-Tag: 1765893347-632631
X-HE-Meta: U2FsdGVkX1+edyJVKkihemyr0RteYCTrxlNR3NGTraQMdMx9m6RS2AnOfGoNhyfgwm/m1qAhU1LV/WSaWG9lK4GJ8otmK0dnzl1OtaoqeBBcvmB1xmS6fgIthjEtOjF3f1/nPo53qs0STom6NQANMWknoaRHcggxPVUgDPNqVmjXPbVV9xSHru2tjekOboSHocdYf/w1pPHO6GO+HenQJ+BKuYZ4GFpkDy7SzmEGyDgOq9qZv4DciJL1mxQVKrqdMCpwkc95TvZZTdxmVig7qTyxcoZhOhfKAYWmD8kz6IGn9b3y/mmaOgJHF0ptfVSkaLsPB2KU8QyFGy+ppLrxAhbOPd/z5+k2lMpuzDHeK8AVKnMHAPEO4061M4RwKPvZBEAAn4a1oChSRT1w903Fp1b1X/0faGR2/+J0IG6ZuG5PI4iMD99Mz91K0j+6XhWZC3kO2w9ftXetcieqcCRuMkmn09uT5vly9x8M6OYgRFocI5hj/w03QetkdOVsMLXLosv8FLprOFOgoxH9noBvQY7yKl7sAm3otjjOjiz1uTzPhc/3zHXh//TVayRd+lWP+g24f7Q8w9OSZkVZyot02lcWDgYFlKxYNjZQ0UTdtxk/q86UyxwhhZYdk390YLVH2beLF7IKuGgzUTC1OUKwn9WZNK1F9WJpGBK5pkpwbYX/PDwDOH0aD+bqhu4bzVEcnIx2P9Ttp7q9ZmvwrrRnh9k6G2oMrTWEgwUKjUkYbfF1qnhgP2PxrvVDoj+QmLIwgr/h0C5aADlWR1qyV4uVNzqQVxvL00xaZIJ4fdQXrMptKM/iUIUTkMUhQ5zu8/scZCJS1rsEtm8jhlJkoGG1zBpqOONo0VQTnNTDRNXnfNptVHyKuQ0fF8a8L4/7dTLwJy029h63/9jJrLIKN4icyyfTytq6S1zr9lpwWWz5LGkNF7OW5O7E2mx5dT1mtKzxYJUucD2i8WrCf7bmK75
 lwD8vmWs
 UA3HpbG22q6rqZuJPA9D24tqBBUMhYQq03kQDkaL4AOv+zwSQcEFywRJ9q6shY82AjGwe/cVw/hMNKD6we5GExRk2r0V5DDBiKxymARj/h2hxnqE6zkhe7gJtAoSD8LIFbEwotsiXP9MHDKeRnTzlAOyERIX09kUage7KG4sMp4mEPlOVuMo3xsiW3sSMBKBvrgXSzA+dH2BAIX4TrYLTtCn5s7qe5mZzRK8Ze/cGUZ3cXilw6vmJUJ683bh4VItvnxTKzqLXziMIzQbPVX0NlBFRupDFRjBkU85rHpT7q1fTU7IKXiXbatl4EXPv5NgwnUQC/wQ33sXsEEC97I0jjrwxhlOjIE8TJVACsFFMATefNeIgBK8YpvqTDWkAL3fZ5E5C0RYSgrq6WP2Vyn6ch0eUnQQgxOmHshbsdGT4WvBVs5pZ7xlcKMitvOE2qCJ0bk36rEycs9ja2GFwaHJvip5HmXotf60UpdojO24UUGyXU0uOzqwDVTCLbeutLM1VZS0ybycUjy0+jrQv/UMdKsgL9beS0qGLcL+zMj8faGfoA18o4RI7ncj2sYkW4dSHruoxkGtq8yAHGKX0ZsBbTUNoQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--quczqmdvgytj5i26
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH -next v3 2/2] memcg: remove mem_cgroup_size()
MIME-Version: 1.0

On Tue, Dec 16, 2025 at 08:34:40PM +0800, Chen Ridong <chenridong@huaweiclo=
ud.com> wrote:
> In my v2 patch, I was reading the usage directly:
>=20
> +		unsigned long usage =3D page_counter_read(&memcg->memory);
>=20
> This works fine when CONFIG_MEMCG=3Dy, but fails to compile when memory c=
groups are disabled. To
> handle this, I initially added #ifdef CONFIG_MEMCG guards.

Ah, !CONFIG_MEMCG, I get it now. Sorry for the noise.

Michal

--quczqmdvgytj5i26
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaUFk3RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Aj0BgEAw0NnDYAA+WDjuxM3/TVn
opuo2yRw987m7508sfF+PIcBAK7RvrijKISFtNPcv9YGtBI8gig6H/uVplSoaYwa
bc0D
=MChq
-----END PGP SIGNATURE-----

--quczqmdvgytj5i26--

