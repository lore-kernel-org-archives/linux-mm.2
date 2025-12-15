Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC117D5B84E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 16:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A46C6B0005; Mon, 15 Dec 2025 11:18:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1554B6B0006; Mon, 15 Dec 2025 11:18:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06ABB6B0007; Mon, 15 Dec 2025 11:18:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA3B26B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:18:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E7EB1602F8
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:18:56 +0000 (UTC)
X-FDA: 84222214272.05.A6EB930
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B59B16001C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:18:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AlmsLA77;
	spf=pass (imf08.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765815534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQYbuy/AGCx7oClZHTrxvnDLHD02xFmPKDiNkJdAECE=;
	b=lIuywimEsPobP9iLX4nh9DzSfvaH8xnjCipy7xDiHfD1MjGmVga1Lr7ikecrtc6CIgvSAU
	1VVWnR4tlnQGr1x3wnkkgRTN3oXfXyUpg6wjTuyqZEx59GlwnUjOZQDRX5KiWegXHn+wv0
	qR3UIw8pC9dNwIrXw4UUGO+A1g1Plwc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AlmsLA77;
	spf=pass (imf08.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765815534; a=rsa-sha256;
	cv=none;
	b=vT+GCs0viDRiMEnihYNwYull96JF5t/z93mOSWFLcteqLxYtGxynZ/12bvIwxDno3mR+we
	QAygXriCTFAnMJwJUi0F71PI60Q2Fz9dhnQX58Yh0KcntxDql7AwSl6lj9/mrqMsGN+t+e
	qstuH3gAwOzSsfrZ3OnuuM33uAbZ3J4=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779cc419b2so38533235e9.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765815533; x=1766420333; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TQYbuy/AGCx7oClZHTrxvnDLHD02xFmPKDiNkJdAECE=;
        b=AlmsLA77TbhlLZRcTdQPduiOJvZFeF8QLWGwZv1yMTv/g2Eh4OLe3PBO5ecTKa8VYD
         u0GHe02B6vfrORA+ZJV5e4U2YctUSab9mGqUHizRFLML9ZMSEPFJA/sZrNvmHTwGqC0s
         jtLRROyh2nyDYPXagMWtaiV3myJecNYW3aP8RM4HIZ8lXLst+++N6jfOlbBVXJaJl2Xm
         ggHu9fgtp6W9NgNDrigT7GLouepoPzWymKHThN61zxSvKkmv28kJcbyg1vWRnlQCR6iy
         0AAmTt7fGBfvknUbmTOr/7h2974nXDN5dtvwIdS1gtK9iIL+i1qoHHAGWJKUMQz0DmZC
         kWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765815533; x=1766420333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQYbuy/AGCx7oClZHTrxvnDLHD02xFmPKDiNkJdAECE=;
        b=lnJ2x/E1BtY9ZGX43wBOs9CUxgqBzf6YGNOxxTIejw/Erm9atkbSODTA4g07ZKZw/k
         9a9hBObcTi4FF7Czcz9F9LXe247tnjY/Lb3vhzjmBCQHlWczi06hMA9kPrfmTA84rGEY
         zlDSn9zGZ2wdpIR9funUXsA3gTtdJwvcAIh22F6yOLnyJKZuQiHUQ9WJ4NmYF8+gKkHw
         0EWEVQasbcJMJCISthjMSCPg9vhxc2HWT0zFSR1yJYDKSlb4ZAX8T/PfZQJRo4/bxGVg
         MDiYh7p5rpxaJbo88z14ltFSEd1xlXKwu8dKtSvHd/uZx+yUa+/ix7ArH/ZHb9YOTkVB
         80DA==
X-Forwarded-Encrypted: i=1; AJvYcCWa8Hl+QHpaw3qycv2eyv/PD9e/sQleeeWckrKAF7Voe7Dmsgzso9L6V70up1+J92y6O/SJVb6RgQ==@kvack.org
X-Gm-Message-State: AOJu0YwdNdSoJIjB+LCZhWF+rXP8NHj+XmhXHndh+lt6Qb6sfDBNZO5L
	4O+D9ARGoA6AJPk+axSZX9kWCnIi6/wg1Jmt7Q3tHJBhvcIVZXt0SJeBMAd+HIHm03k=
X-Gm-Gg: AY/fxX5Qk8i6dGoRgY0eZ5c+V+voX+iPYk6m1HIFzu6HDJUz1s3ueQqvQ2OM4W2pg3l
	dHeDMUrZgy6kIpaiPa4pbErMREBfVby2UwEaYTim85oIjs9Db+cURYCMoAP42XtKIUbmKABICAx
	JLcBuRLFD9sYmRjUgLR2OJAXpLdpjL70iQNWOJaqMlnGZBO9JJ38Dyj40OP4XhZSO1O2X6IrMPj
	KFZMVPvPOcmhJfAMYAQfQUHcuwzjyUnFMGxQV6pz6nYq11X415o4FLjzWkFD2TWYr2yQLNQ7GoP
	pzaU8vPMJGM0TBgQLXxrUaO3hCroqFnwMYnCaoPA/LQop7vqxtR9hsa0ZYpcM0LSM3owbkj4Pm8
	Yx9JK2ev4iIKkknEoc+XdDJ23vC5BECBp1H1hYdbCw0QYKszOXOM2sddyG2rXpXDY81fE7Ow402
	mAWH8rtYSQGjNfbDXSIqwsQX7KOfCy4ss=
X-Google-Smtp-Source: AGHT+IHz3DRccVTH0qEnEXmkQ3WMt4897kh6Ax9dU31ug0/MvMOQlOP1t29k+dTkjNzkUa4aYrlpgQ==
X-Received: by 2002:a05:6000:310f:b0:430:f704:4ef with SMTP id ffacd0b85a97d-430f70407bbmr5833954f8f.61.1765815532434;
        Mon, 15 Dec 2025 08:18:52 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-430fdcc6bbdsm6333447f8f.14.2025.12.15.08.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:18:51 -0800 (PST)
Date: Mon, 15 Dec 2025 17:18:49 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, lujialin4@huawei.com, zhongjinji@honor.com
Subject: Re: [PATCH -next 0/5] mm/mglru: remove memcg lru
Message-ID: <oa62a226nagmrqbc23kys3yw3ouxkn5spcizyqqevsuhkurbsv@tvvwqlgu5yum>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="46t23aecoxgyn33q"
Content-Disposition: inline
In-Reply-To: <20251209012557.1949239-1-chenridong@huaweicloud.com>
X-Stat-Signature: 3sdjimye9i71a4zg1wybipoiu9er46to
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6B59B16001C
X-HE-Tag: 1765815534-803044
X-HE-Meta: U2FsdGVkX18Ouvi00SFusaWixpzi3pAxEZU6uY8RlUxqrGvSj18CheewtvUme/kWwqgk/3c6/0AGitp35f5ldqT+3csRJTFu7yY3p8/M8391rvf8jx+9+K6FyVQrurO2jMuYrRqgoMsB90yeJbRitAeRTlCjCAVC0ZL0oLvHFgrI5Fqhu69NnpMLZKO1MxHCM+8k2I1NRxMXWQP+Y4dHZi3vXKxfdPaAA7ZVQ0LH79fjKsTNgfdeDiyhCFS9LRp6XeJYAJ+rBBJK1w8a51oBxrwdx+GEgiiHv0rVpkB1Pzwe4XxY1wxAJMgnmGTRGncfsl0RLuclRzzXAZ6CLwxELdGlqJUEnZl0UIF/C13pt/wytR07jMTAP2aYrC+qRC/AAPmralE2axwjIruwVTIma0cTo4y4P2vIVhOQGJO+Jda4gQoFqivNZOWbAPZ8WsTZzQU8bhMUh5hAe/m/+on6Oj7UzvAxvvpF3aqDXwoGlCPGipJbaDfOnLFExNwbcNxePuKCfSG6VuVJfTF/N9wJhlVINmEapvm2MmVDVxfTYTrRid5Wkjvr9YN5nk39LB/6tqaqpbZ9s68RM9HgpHS6qUHuLgJhRsbw/vtqP+k/7YRaSSwdAwMCLZYdMxAo5gtl7/UWXBLep3cJqAjqnXVRuhCmr+J5xtPxMnaPmhnI9QYMO02O/nMfQFZLT4N6f+Xkq/gKQxFLY8bE62o5REifQCwfuto6XDBUZDBgic0SsCvpdBeLDbiUpl80I5uf5t69w/IMCNKVfgCdXWT78yz+6EGcI4wEXKOIal3uwW0l+v0WHnuFVpuaYP6cRCgz9URpoH2d/WQvxTuTLH5cC4xOARsIwi1+ojIm1v3TA0jgCwnkEGrz8W3kIYzeE3O9dJ5R/5FHwNKHuuE8FL6+pqVUZXDXscUrRcfLSVtIojJgsTs2CE0LaPNZiKLaS2zuDoednGuVQnt/fr1vocGBgNz
 fwuD6pL9
 UHJ44rnIijJ2At0J1Sbwjm3HggYUU3yHNu+ThTV0IA1MLSvsWqye84vWaeVdD5Duk+xyyW/9f01bK2be83TriZvk17ecJud/C6970g+wsqNXXGcP5+tWfsLoDsgC4WGd39kHGT+ieLTXeQSZB94dDX629iPONQcEZqq3R4KherCCw02mDJzZmxvGZSYdSYOliVm5rCmULscfw2nDozlZJNGbkYC/8iDcpy40edyDiz/gqK2xE+5WTXoEem35uzjO81QKMGcanWvfopbnkXWEopcEODtRpMuSnZtou/OjyrSSpxoUW+cKCVfDRKegUWP5Q8NGS1lEhDJYlwwz94PHmxQxEhGZoCqAAUubm4soAGUidfL4L8HxYXdD0dXhTiCgbm3CGNUEcuVzcXXkq3lDiPm0VpTFCGSre8YToLwJayDdQQvcTQmw9hiST8GqgGLAHsPPJAWuBbL/025WdELrQycBDL1amyiZXaOoV6g7Q8+m0zJq3HI/cPvNEfTFDKRQEyaBRirl/RpN1LT/NFfI6Vz80U/vj6fJGN6xzFHDV558RD+ov40DukTwESw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--46t23aecoxgyn33q
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH -next 0/5] mm/mglru: remove memcg lru
MIME-Version: 1.0

Hi.

On Tue, Dec 09, 2025 at 01:25:52AM +0000, Chen Ridong <chenridong@huaweiclo=
ud.com> wrote:
> From: Chen Ridong <chenridong@huawei.com>
>=20
> The memcg LRU was introduced to improve scalability in global reclaim,
> but its implementation has grown complex and can cause performance
> regressions when creating many memory cgroups [1].
>=20
> This series implements mem_cgroup_iter with a reclaim cookie in
> shrink_many() for global reclaim, following the pattern already used in
> shrink_node_memcgs(), an approach suggested by Johannes [1]. The new
> design maintains good fairness across cgroups by preserving iteration
> state between reclaim passes.
>=20
> Testing was performed using the original stress test from Yu Zhao [2] on a
> 1 TB, 4-node NUMA system. The results show:

(I think the cover letter somehow lost the targets of [1],[2]. I assume
I could retrieve those from patch 1/5.)


>=20
>     pgsteal:
>                                         memcg LRU    memcg iter
>     stddev(pgsteal) / mean(pgsteal)     106.03%       93.20%
>     sum(pgsteal) / sum(requested)        98.10%       99.28%
>    =20
>     workingset_refault_anon:
>                                         memcg LRU    memcg iter
>     stddev(refault) / mean(refault)     193.97%      134.67%
>     sum(refault)                       1,963,229    2,027,567
>=20
> The new implementation shows clear fairness improvements, reducing the
> standard deviation relative to the mean by 12.8 percentage points for
> pgsteal and bringing the pgsteal ratio closer to 100%. Refault counts
> increased by 3.2% (from 1,963,229 to 2,027,567).

Just as a quick clarification -- this isn't supposed to affect regular
(CONFIG_LRU_GEN_ENABLED=3Dn) reclaim, correct?

Thanks,
Michal

--46t23aecoxgyn33q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaUA05xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AipLAEAnlYbPrFblvbBsF7840Nm
UUv9SDFSYzdEcMfrtpIpBBUA/0OUjcdXVkH5G6MDTafhw6RikY5Fc6vWy/IdPFm+
6b0B
=4hsa
-----END PGP SIGNATURE-----

--46t23aecoxgyn33q--

