Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E3BAFD45E8
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCFF06B0089; Wed, 25 Feb 2026 15:11:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A406B008A; Wed, 25 Feb 2026 15:11:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C695D6B008C; Wed, 25 Feb 2026 15:11:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B36A76B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:11:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 317E913B8BD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:44 +0000 (UTC)
X-FDA: 84484074528.01.92D54C1
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8045BA000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772050301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2MWFdKV7J70WVUzusLdwzbROOrIDq84oPID02+MRug4=;
	b=0HJKNxbre4W35dwGrTtz9kHdr41TCqsICVe/p3c0QWBfx7pnYYIsJ3SU61ZJbjc2HaU8oP
	G8cJKQveOpgK1S+vpAhWhNBnycL2h2x4tBMiXnvyefXGN3LH45NrMwDGQDt+ndhucO7NNf
	3UYgzVhFfDOGdRw1PTR/mJdtvvl1YDo=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1772050301; a=rsa-sha256;
	cv=pass;
	b=RBtFjkF7cNlzkw2+hfYl/y+D+SKRKNxTjB/wyQp/t6UThvTyBDmMPaz/nvwKBt1sJjjWd/
	sqo+AH31VIUWHI/8fK0bDZmR3p/wT4RIRXijQcssBhU6Vs9BabZdQYlR8ftFpnu67Peotl
	IOX2Ib4oY7Et9zTg6YjrM226Ek5hE2k=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00E1B1C5D2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:40 +0000 (UTC)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC8195A818
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:40 +0000 (UTC)
X-FDA: 84484074360.10.4DCA31E
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7544D40018
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:38 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772050298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2MWFdKV7J70WVUzusLdwzbROOrIDq84oPID02+MRug4=;
	b=jDWT5kiw6u6JunOi91cCtZgJWVYJRdOy1uvLmEmfAG8uC7gqLqJ3eHiSxibeEHczXY49LV
	eBZ87S0dnZX/A9y3IqjqiDIXkr6NQ4wzXaEJoBNKKdllkQY09lPp8vDc5m6dB48m/6RLxn
	ogWWkri4swIE0JY1hQjJP9u5KqCDZ1w=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772050298; a=rsa-sha256;
	cv=pass;
	b=VB+hadgy9KgXbvMD5xXWO56WVj1zIRWBaJQO0VRAMvXoZT2oRO8Z1z43WbB4n6BqFR/IKu
	1wYuIDk6fGRNAg+3JpjTyGbwOLPXDyMTTh5juLo9GSxMs8Il0qlhEJtNyG2VcIIoFaZEw7
	DoUNYh56pRVnnK3oWnyLRhewaQIIfe8=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0225A5A818
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:37 +0000 (UTC)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C764213B590
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:37 +0000 (UTC)
X-FDA: 84484074234.28.1B5A5E7
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id DD60D180012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:35 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772050295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2MWFdKV7J70WVUzusLdwzbROOrIDq84oPID02+MRug4=;
	b=KxJory149+vKsBTV4R5tHLHAg02Vhet8jywKmL46K9NXaCiNHbEGxThfa7gZgvOdk80dgQ
	XGvpgJOZRoqUToOeBDVnCHBXxNo2lSVduMORhdhffX1F+ABu3FPVw5LloP04o5YLkQ45nx
	UuonpKQbsGF1hdzbpdt5vBGIpQiLxx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772050295; a=rsa-sha256;
	cv=none;
	b=ahHgoZF7Rw+69JdAn8c7TTNob4MGJrb5qQmqMAK6vhfsqD06iJaVRUmJlB8U2PBA5mHud/
	nDStsKQj153J3KJPAX7FMZ/zV9x+8JLuV53lghbW8npU8KXVIiSksKK7l91XzRjGVN/HQ/
	cJW1CD2o2UGQNvg695FnMY7Bpfr2GYo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bLb3XecT;
	spf=pass (imf24.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ada9e4ea32so295ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772050295; x=1772655095; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2MWFdKV7J70WVUzusLdwzbROOrIDq84oPID02+MRug4=;
        b=bLb3XecT3x6TNYlGgU7kQ3jq9hCSgqANW2G5kHVHekdFQHNLzc+HYCYA2mqH8qJmnP
         dkDFf21WBDnxjxgckp9AR/8BSb4XdIXiuPwPvXjpiRz4SUXPPcsVgpZ5e1LcF92bp6cq
         77cK/5rxZ7ZnAW1VIKhpJHHnMtK9j1OmMRGJgBJ/NnyxVOjxBbkDqwqEZRqLRg4C4TPH
         OKoB5/vPTt/LFRRLIMPA/IOcGBsGMr+vS5pevL29K2m3DqHJY7sDAlsVrctDbhJJN46N
         NgafW3iCMSJCF7+q3ISSNIHMY320nmB3ioTiK5D8scE6k8pE572wMDVfWfntfvlQCSja
         Ublw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772050295; x=1772655095;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2MWFdKV7J70WVUzusLdwzbROOrIDq84oPID02+MRug4=;
        b=jNKO5Amn7Z0C2OTKv0bdA5cQZhb0/qXKLLdQgAGTohDSYAJUxXQpMe/gHJdtwob4D4
         jpGUki6Rfx/0RWTnvIO9VTB9tOcASqsc9D8/smtllmZcU7EWmFyGc6jMPBF2E/QgG9dT
         bx7CJK/tffU4e7qLmeYdKM0JWyE4KIuI7bWlwfkhhU+cs0aopLs2Gk8KRsBLfv2voh/v
         g8tuqOcCGkAFMkX/r7J1zdCo3y0NhdLoWAUmBgMYnkLVxk6sX9Rn1GOtYcAlcTt5QnBS
         bPzDqVHmtc5lfo8J+2bLo7qq0fWUSfcSEESC8TWU92hj0UDKvP1Ye+LkpTM0VPXUwPE9
         OG4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcFGkK0Z1hh9F/lvcIPHDRHtqfSjzm5GeLgVJSXxvpaCNnZcq56tDw+q38xCDOZ+Wv6WZkPQXjFg==@kvack.org
X-Gm-Message-State: AOJu0YyZJBrbWTjnUTquEOOJdLq7g5Y6M7i1i5HLvLOIs75Pe1k2prbk
	Q5mq0KvOEBimNeznnQp22lsCGlTNqkJSoMoHR0Ro36vzhv4U5FgWJ1izXYGsA7aIJQ==
X-Gm-Gg: ATEYQzyVcIeR3/lnxm5S+V8u/MUpFCfSgG2HqI6mjaKf0HdznfSqkMBZrcDlAm0XELB
	UAmM3aSZx8PJFL68249O7ClF/u3kNpFdCYPvDcHet6zKYZVqIC9Dw2L+LRbhjLhM8bI3xh0WFMO
	O2FyXDWlHFTUWeiR6hBPmQjLcZMoVrSi3CNUUGqbXrsFy/UYarDmMnvMc3oHG//AFmWMLEvmHxG
	e4lI7V2H9k4jeaHnxFq4cdSk7tRrAX+aT2zKQGpsz8FCWhLXoGCBOzamSoxIhEikbqEO4yxUmN7
	sZPV1q/kuv4ovuuD5+qXIFBG3NVCrEL2X1WNjH+qhi/Y1kcKfZRVA47cG51ub6ul2crF8+TdWu0
	9v3SGhfHsYZzyhUqmsYLyWqR2uMIpO03jN8SC27aVSk1zhNCE0GAxx0RTXqOP6ZOl/UjiEuhlcr
	gKoBzkzAAqqdnIGaq52N98IJqNgPA0o0flEe1ltJjvDqeGLl/IV6MCiL6gHpkW
X-Received: by 2002:a17:902:b688:b0:2a3:ccfa:c41f with SMTP id d9443c01a7336-2adf783d909mr135475ad.1.1772050294261;
        Wed, 25 Feb 2026 12:11:34 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3590203d3edsm3860787a91.9.2026.02.25.12.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 12:11:33 -0800 (PST)
Date: Wed, 25 Feb 2026 20:11:29 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Ashish Mhetre <amhetre@nvidia.com>, robin.murphy@arm.com,
	joro@8bytes.org, will@kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] iommu/dma: Validate page before accessing P2PDMA
 state
Message-ID: <aZ9Xccnn7JOikudb@google.com>
References: <20260224104257.1641429-1-amhetre@nvidia.com>
 <20260224123221.GM10607@unreal>
 <aZ4Q1HA9q1ojsVYY@google.com>
 <9d01b4e3-be5b-4c9c-8088-1d10f67f1fd8@nvidia.com>
 <20260225075609.GB9541@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260225075609.GB9541@unreal>
X-HE-Meta: U2FsdGVkX19udfUZFUms6FkQzbXn9cTd9CKhnmhZF2RuQAxg2oitfe6+jbGez9AP6FaOyQka4+Jcry5EdyEyWVj0nBWPn8kLSFuRjDjVMSo0zQRobzBEXGIdGj+eaUn2KdI8qhiL4dX/f0/dRv/W4akHdb3fkZPB93PabXjDnkbVndOntrB575uaqNAmWfBTneoNOKd9ILwNQMmFszQ2LpqUReEwzl2imLmvikmF9YORmeYEQUJhxZpUc/79fwD+ArIejmjSY1ctOIadNKf1E5TL1oQzL6GJLSU0Jc6P+iaEAsItzSGgIpQY9DFUT0QoXdDbXGOY841sb75IBpM9fcBVFe1y74uXWrGtKBuNaxiN9s5TU9y0Zp42WVlNSI+z54V3C+hH2w/Lrfs7OE4QNiKs5K4Gn+HitNoDwu1pCN4Crpf+6gHd+6MR43ZQ29N9/qZk9zsKXHnTsCXgc4xj5zL3DIfZtk/yCMMKG23yhzw5OkgP3Om6j/SxErCXWY8ERXeSjQ2MDWO7/5GmFCMC2sj96oPWyXia6O45UK0/Lkrr9MAQMHBKKzDXlXV/JJlPdMq0/3wk+cX8s50tlC3/si109ocuoYwA3nPXNuFeeQwjYG66SpgwQjVnoOxjx43t9xNQyZXdVrMKGr3md/dmitmzXj9dlyQYbZ9ZBRLzTBYTuYalAeCgT7z5VgSEkyCZ+MVF80632L9eKBAAgEeVk8meTuD0dgyqCKuKlN+v44BXiWb3yAkSakzQLCKS/YKaHppsJ939tNtDXg3vxXj+iLcPkrqke9no3MQQ266hvn2Lhx5RAjosWe76Ody9vpHa8BOw5Opc8AVXwtMtuQla+qrWEOmR5AV8Orh+MbzTfjdKqt/147ujNY2f0Iqh8bB/IL0+3y6W6g2CqbCaUwd3tPVeafgSjT24clNvBNTeXLjY8qjwb1h0y4gxx9v9bx4Yg6KUeAk4OmBgQhqtDXQ
 5hEwkr9h
 1n3Wsx5O2FZdQ+z75BEkc0t6CWvbmIrOBoEcyYQIgD9AlCx5K0mU2nMYfeGyp9CkxiwGlY2TX+Rt1MgKBCalZeJ+8TUIFV3WQylDw4Lleyf0Sy2Kr1Z78ciZu93aJjgs5uI4c/Ykavy/RIc47S44I1KoKLT8nXi4eKKc8z5GRa9bJAZz+m6YBecnK4fMS4rRHtQZFzQD3x0YrAXbJwKLzMRYz9g2YsF2paBBUWne7BccFhaVVpeF42OGBp8y+4FRmdgnS65o3aNq6Vrb/vINZ4GhzYt7txdw6tEJndwP6bAqjWSb2Z39n+U4ArinxhwP8WAbjHeKQXvyiSzLzV7vMBEeZQKMYL1tA+sm8woUDgsworMij0YKkDL7A2JJLAyDHSe93
X-HE-Tag-Orig: 1772050295-305767
X-HE-Meta: U2FsdGVkX19/ITuGpk1IdmSmmrnHOORERQMXawRS1019MT5gjOWkmVorrsAOR5yO07koBx/FKjAVmBgkpo2VsC41hgTMsfpfYjSB8+pvtgnJ9ffEimzLcN8Kf6schN618O4S2L9ZOWLnkFYiwy/3w3NzxcaAJ1KaHzwrNdnhfC7ZvTS8yvZsOaSrseV1DKnVrJT3kZOW62euixfu73thWBqhoG+cbzkPQG9HwHK/rQ0E3IVdoETUCpMAE36i7F9RxrttDmYy3/ber38/za8cd23o03jH6n0gi5KHVxTAp3nVYnUnaLUhs0BOGvtYAj5qS0DNwDL4LsFHJC4LeVeN4gfOAeYerdURUsME7TRLKSSrovILhgo7AqZzviTWg+7v7UQxqitqHjI9RVhM1H9XF1HH4xW78WEOP3aMMhRIa6Lnync6qToH6rYu3b49RXelG5oZIMsZZ2QuIXBmL21ms1efh49kZax0g4Gu0QmfWspI78Po6RtxDtb7vnrniOS53iwoZW52VU0XvMnb6pvKsG+JOXuGrxyFqJ7Mqoshd1jFKlH7xHLaCdrQcKulMYIxbPCNhRNiWEoWL7Uf5uVvsmuNTAjnOYytBrG8rZZuFhqxEfs3Xje6L1H5PGBeGieZ/WrIpvy/8UYfhJAkVQqQvN/oOyrI6FJqqCyb20DLokrrAzDWQ0+3WyxXpU46NQRpLlw9Aw/gRCeqNcPi1t4HuaofkOKlc9QO4TIp2ksfh9c6K7RAR79fbzQ+Yqovkp3oAK8gF3PDE3uNx4GBgS0GLnKKgqAsVZ0fnwr1OHkGtNSONcnWZOffe+skbvbEdHAnFArKmWmAkHKlpaYq4gp9BQz4fBo/ngCza+J+i46bs1ujDgPgXYQoFhkYRpFlMS8yelloNs7goM8bHYNLSGPu/NXSkoCehxRrDs3KGj+pDSe8iXxgfNxx7c1VgJaUgIqZStnIMjpFKYH5uVjJQhx
 8wFxVeqp
 WxJ9gEANFJ2FCL+4gD6El2fiJBAlwtfKN96F3BkKzcjHTTYoqIYTJwdhZTeHMTJ9ENA1eV0uM1Jz4zCV3sr1h+uWInqfh+DsTYLKyS6fDfNB6VmQViD3yTWpIzhwDmC2nxObaNpts7nRGezbeCg3BjIxXHCwZRZppapd9t6CGHG/Sy+LYsmdsNTK2byq0fCDMYPyFn5LTNVMJknW3RdRHz3N7laqbBQky/AuvbG1Mi+HsSl7fIr5iYnMzmvmic8WN07X7APqOEzEVh6E=
X-Stat-Signature: z78oj1ipntajwjjtt8kcqxyi1iurmtcr
X-Rspam-User: 
X-Rspamd-Queue-Id: 8045BA000E
X-HE-Tag-Orig: 1772050298-256427
X-Rspamd-Server: rspam01
X-HE-Tag: 1772050301-370963
X-HE-Meta: U2FsdGVkX19xXsaeOQvD6vKV1BS0zgTzWvQsanx9MlENCGMjM9ZO374aPgzY0NvZrXV+PYNaTPd3YO3xU0zJUnU6qquaU/gTzagnMj2dyPSzFtw92YL+lrep3vRezPMyAz0CyBXO9e+6Uc6nQxpVsQfusvsbZqvm1E/qgUujvCNvQYpfGIeTfht9z8LSEgB2dhtTrql8/hiLj60+wLIfY5m8Qka9zsfs+927itfjd/B2Cw8OTaqaEPhtW9q7B9DXgdT1SZbov3wtWO3HNV9XYLfQgZ58+oXZWaZYpp1ekKdCyi5VouaqV5SfbiNdB2oWBuQtmdT0M6RT76S5W5sq7JHyxBOAcRLoPI58xaYoTvTFOSJNug5+jgHwKviON3PlORtf+jKDNZIc3Fvkr2jim+SGbeCEY4p9cDYHzlTwnjEs0xoI83K25+YmQfyLR3qZwa846Wur72nOkwzS2RDlqW8rVjQ/RGpkTHU4Eo28kZTxgV82VzksOAeUI1K5LcA2Kkh/DYNIQjXSy05ohtx/QeZXfRwREIMGQOorWy+Fih6VGS73hLSpr9Fjkk61Oo5lp4MOXU+gsL2DBNagnGBx0MYSHS8jvMs6GaFWw7Z9lTGiIhYPXblNgegueiwKBw2V6yczefTzeIsEfCwJQsGSJGwd8dIHa3FP5nwX6otaRFEcLfNr2/60l5xvgBrNtzyHjDiKbIXOrVcphrTXJJ3RgqnbxztnLdThhBstsv8hvM4+l99JRyOtup3mC3HHXGfebKQsEe61Gvo3Oi/4eYolAurjfvNGKWQSVGz2XzR6y5FZSnM7DlQs7jzaEUrlnAW6aO995OWBkIMsnxaScTBca5ELQKZdbBykmKyi6yrKK7+a07Nj/QquJ9yuDSZdQwPEtDp3r1r7zqX6jRewtadpkIP4LczgvE4gro5USzLkjHUdf3LG+3zSL+tnoc5NkbhthQvX+8QjO/g+zv96Bcl
 IPRC7iV1
 GqfWXe0qHC5VwODZeqrAVzs4kBnG7tlRXHPW8HguhUqLbcwJHezY60160M+OFPfqS9KsUTsJBqVoXWif1GqX34U1adr1BCRtcLTN8ei+gbKkkX1yCE97C/+nwnH6Tkc4d6PaX8RiS38YaCTXg2A8CdVpbuineoQ77sKSPI3Dv/CPs99qQ62q/uPE60Ft4Gl7rZGCka4BNIEMqISyO18AaNFc0hYQV5X1nOi60ZmO2NPI96U+96rSGqK5iRxiLwMmHSDdT/qQsJOBVccw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 09:56:09AM +0200, Leon Romanovsky wrote:
> On Wed, Feb 25, 2026 at 10:19:41AM +0530, Ashish Mhetre wrote:
> > 
> > 
> > On 2/25/2026 2:27 AM, Pranjal Shrivastava wrote:
> > > External email: Use caution opening links or attachments
> > > 
> > > 
> > > On Tue, Feb 24, 2026 at 02:32:21PM +0200, Leon Romanovsky wrote:
> > > > On Tue, Feb 24, 2026 at 10:42:57AM +0000, Ashish Mhetre wrote:
> > > > > When mapping scatter-gather entries that reference reserved
> > > > > memory regions without struct page backing (e.g., bootloader created
> > > > > carveouts), is_pci_p2pdma_page() dereferences the page pointer
> > > > > returned by sg_page() without first verifying its validity.
> > > > I believe this behavior started after commit 88df6ab2f34b
> > > > ("mm: add folio_is_pci_p2pdma()"). Prior to that change, the
> > > > is_zone_device_page(page) check would return false when given a
> > > > non‑existent page pointer.
> > > > 
> > 
> > Thanks Leon for the review. This crash started after commit 30280eee2db1
> > ("iommu/dma: support PCI P2PDMA pages in dma-iommu map_sg").
> > 
> > > Doesn't folio_is_pci_p2pdma() also check for zone device?
> > > I see[1] that it does:
> > > 
> > > static inline bool folio_is_pci_p2pdma(const struct folio *folio)
> > > {
> > >          return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> > >                  folio_is_zone_device(folio) &&
> > >                  folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
> > > }
> > > 
> > > I believe the problem arises due to the page_folio() call in
> > > folio_is_pci_p2pdma(page_folio(page)); within is_pci_p2pdma_page().
> > > page_folio() assumes it has a valid struct page to work with. For these
> > > carveouts, that isn't true.
> > > 
> > > Potentially something like the following would stop the crash:
> > > 
> > > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > > index e3c2ccf872a8..e47876021afa 100644
> > > --- a/include/linux/memremap.h
> > > +++ b/include/linux/memremap.h
> > > @@ -197,7 +197,8 @@ static inline void folio_set_zone_device_data(struct folio *folio, void *data)
> > > 
> > >   static inline bool is_pci_p2pdma_page(const struct page *page)
> > >   {
> > > -       return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> > > +       return IS_ENABLED(CONFIG_PCI_P2PDMA) && page &&
> > > +               pfn_valid(page_to_pfn(page)) &&
> > >                  folio_is_pci_p2pdma(page_folio(page));
> > >   }
> > > 
> > 
> > Yes, this will also fix the crash.
> > 
> > > But my broader question is: why are we calling a page-based API like
> > > is_pci_p2pdma_page() on non-struct-page memory in the first place?
> > > Could we instead add a helper to verify if the sg_page() return value
> > > is actually backed by a struct page? If it isn't, we should arguably
> > > skip the P2PDMA logic entirely and fall back to a dma_map_phys style
> > > path. Isn't handling these "pageless" physical ranges the primary reason
> > > dma_map_phys exists?
> > 
> > Thanks for the feedback, Pranjal.
> > 
> > To clarify: are you suggesting we handle non-page-backed mappings inside
> > iommu_dma_map_sg (within dma-iommu), or that callers should detect
> > non-page-backed memory and use dma_map_phys instead of dma_map_sg?
> 
> The latter one.
> 

Yup, I meant the latter.

> > Former approach sounds better so that existing iommu_dma_map_sg callers
> > don't need changes, but I'd like to confirm your preference.
> 
> The bug is in callers which used wrong API, they need to be adapted.

Yes, the thing is, if the caller already knows that the region to be
mapped is NOT struct page-backed, then why does it use dma_map_sg
variants?

Thanks
Praan



