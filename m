Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF09D6554D
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D7F6B0005; Wed, 17 Dec 2025 06:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE786B0089; Wed, 17 Dec 2025 06:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B5B6B008A; Wed, 17 Dec 2025 06:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7D56B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:04:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E744FC090E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:04:26 +0000 (UTC)
X-FDA: 84228679332.09.05A6360
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1509240005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:04:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q2H8YmbL;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765969465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=co5bqN6kREXERHH8TrrKVTVAstb5nlivTIfAC6X/KgY=;
	b=Fi85faN7JdX2hane7FpwE0wFXset+g3LhA7Dlux+37rMv68CD90sFkaJ9iLs/j9GRTxbmx
	BD4Uz8M5hQ7QsPqtZcZQmcEqYWhCyqbBiICeh9zSjsKbTV132iKOJ7P9lvPJqyUd7qsNXx
	5fn7X+6ST+r3zyKsVMFQeCDepp+dzVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765969465; a=rsa-sha256;
	cv=none;
	b=LoyuK7HnupZh2+B9O/aMWEFJXnC4RZ1v/Y5zjoyHVv2fUfVInPULOfJr9b62Pf95X2mZ/F
	wtHogB/uSLSTdKnJQhf4YXXbwM6fpq9fFSjfdlHLLMO2hbsUUrm6zCHAVxeEtXRYTOuakF
	NU77ZE0EWEdQSPDzxHWGWLqlxlRqxqE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q2H8YmbL;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-59911cb8c3cso1382520e87.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765969463; x=1766574263; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=co5bqN6kREXERHH8TrrKVTVAstb5nlivTIfAC6X/KgY=;
        b=Q2H8YmbLMZvMceCnAh2ZB4rrc9hLEb38SL2wdpi7FyRV8avmCMNG/drPUaxMPRkH7r
         tfKIpR0Y3awX/rU9bO3dYdvAs52SkrlHbGXZfBkuBt8PygmIAp3Td1PTAOAMqGhA3Vh7
         i5yZwaJk5Q3w2BA+UpUICz9juyJ5jNbpE9EbDdONgfiFv1VDhaGyL9E8vo/0rd+gxnS3
         iAn6qWMbZCmCJo8vPJRQz+gqARvom5koaQFX1RKBe5LDG9a7jcEsnMu6Z8H/h+BQQJ3+
         6O8YOk2hA4Nh7uQe0EWh5AZN58fpOYwtEJVUwEzGA5fGhBpTELz/s1mI5uT20HoIAVzz
         bi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765969463; x=1766574263;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=co5bqN6kREXERHH8TrrKVTVAstb5nlivTIfAC6X/KgY=;
        b=q0nLAH0JXq+DTSQOqbuh0m2/R+64tksrjBjmisQr7BZWnsacKNAOQGwAlDKeb6K3vy
         BFhUWMOnskcIAR38NRKhhtDXKJj3yQ6/3BHPojEQVKG19AhInPk1fAqW0N5fch5CA3tr
         a1iYe4/QX9hdHIOt5/ov5gY/rreJt8Qn4Qnq2Y668BDeTYNj/pA59CYVRXGS94dNwX2r
         GkAS5KXAumZTIQKoOycwZor9trfvH7lJHgngmPLlDcHLJnlfvzBvkN29p/jKLlXFvpSe
         7bt895UiQn6z3haPt1O2NoxpvbsyM4haDDytns5WSvJSwusmwGP9zSvL+6b+NJ5G8xKK
         PciQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+8OvoXRQxDKYkW1WNNhHEhIMxycshuy0EjGQXNFo7E3oGWgWbtmXobJz6hBwllw0Gq9dafgfeCA==@kvack.org
X-Gm-Message-State: AOJu0YyNDlluP8fFb+GLCYzjq/Jv7J48SHniEggCJNtgYVbMzOviWr4i
	aVAPTrH1AdoWYII1DXXJLMoBt43X/uDQxk5uGLfgktUx8b1vBI5wW5qf
X-Gm-Gg: AY/fxX4LtvpxUBLUvgfG/MWtz3aPR/FtgfKPdqBIF2Pcu0icJ8UnAbGMP5YrZ4EnuoJ
	zqStNI5E43AFeVn6HeVX6tNrQZT4L0BdExGwQUKbSbNKYYzstvvg/dGn2EMThKngxwbwjkPAnMx
	VZbdwsb+6yPzjie6yWw2FnW804nx99e+IjIRQf7CqKifJqaP/Vq/flRvp370aa8wK1TgXIt1CMr
	gSqwy/wN+5Ehp46/YqTfqK2FA7DJkzgpcMulk2eeq8kSkUXztUJ+i+czYGS2AXFpYPSUQ704e93
	tWK4yvGvmt5g5Td6p4FTZnOhRdjdNaUqnbHLBAJWT1MkWgSLodn7grb9+wDTuzpKI7ZKK3YbVfv
	FNcmydAIXKgpbXUacd4COu7WeYZj89jfj5dmj5TgX/1hI0tZScMRwXRwj5epIe6k=
X-Google-Smtp-Source: AGHT+IGwmBTrcaUkgLgTqFamHpZt37FpUgqWXiF0Z9Bu9X6OCslunvuq7V7Di81hDIqdtVK1vASruQ==
X-Received: by 2002:a05:6512:3da3:b0:594:2dbb:723a with SMTP id 2adb3069b0e04-598faa886f3mr6420599e87.39.1765969462791;
        Wed, 17 Dec 2025 03:04:22 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5990da78be6sm2290460e87.98.2025.12.17.03.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 03:04:22 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 17 Dec 2025 12:04:20 +0100
To: Oliver Sang <oliver.sang@intel.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm/vmalloc]  9c47753167:
 stress-ng.bigheap.realloc_calls_per_sec 21.3% regression
Message-ID: <aUKONAP3CZn1kZw6@milan>
References: <202512121138.986f6a6b-lkp@intel.com>
 <aT_8woTbtklin3Bh@milan>
 <aUI/MZ8sGDt8toOC@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUI/MZ8sGDt8toOC@xsang-OptiPlex-9020>
X-Stat-Signature: 4mtbz4qypg8btwcf83xjwt19mcgpykdt
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1509240005
X-Rspam-User: 
X-HE-Tag: 1765969464-766556
X-HE-Meta: U2FsdGVkX19h9r3p48G0m6V5OqbtRrSHuVcfQO0KDN/A0yugifw8sgKwv1NkS2+6Sgd9UG2jK6dFjN9kA+h7wOmAU0nfsW0ezEX8mR4wZud6eGt2BZXpov/yW9NJwyNs9IcuJrD4HczSZ0wwuOsDeVEZzTrdkannwzMbAhbWFXe/mKdSM9QsTXsZRwhLmZvBUmY8ieUvfReUKJGdfSAP7pSuQp18r5PeBFuB1WYIYFHuaGU1kGaHbyU6vMTCshzwjg/pg8R/gufJLupl7kjMpOhBqc6TX6JE65HZLcfQtc0gJ3gT01z5O9oUwkxwyshMMjs7fXr9iY+in8hnlI/Bbnev7xtBh53uYlIiVK9CW5NSmnwTzO63D4BKnyb95QWyxAUVGDpFGpsjyni76pqc74hvh1Pni3hy4irEuiBxvGXnYYtc/4/c86k5CXLOI4+AE2TRLDdOBeSOnGxIlAvEHCCGCN7w7C5grkpsJOHUdvDxLtvw7ooROXqvxXYcLTRYUL/ExY7wB5GjORob4g45zhkMS26b0sAKY3V+HTG3OkA/uoc0Efq8BCGXDUOEL2imdrv3TGC/D10BJFmMBl3J4iJsOoE4max6WwI7SP6fPzSrsNzPJwYVpKzBKv0ra9EYQqZuc+DOgDfU0ZwXw9rPRaEmr4qXd9ZzXWqwZbCFN+jiZVTYHDIcdRev2xWtFrddZ84t0oXTc2PMPaZtLWQPNQ7n89wE+w6e7JfgG3+ahijw4pGmlVgIfCgF1EYLQHk6z7FWUrSDlgwFG2r+lIbkSzXSULuDFl5BWiZqOfcwyi45Dn1GkftZ4BcEzsOxK/Ul8nU2UO3i17Hb/K1iQbd+WLSmugDjcpq8xe7v0kJRaVZs/tcbdqBQnB1rrXy56+GGahcTMoJBQ+zT/Lkk0Ws8QmkZKY6gzQGeQaa4l6uNdPQ2cAxiwBdNsCN8RnXz5kJzLOyOQP2z6vw5eoCVy92
 9QiEiG5G
 /yzKclEIQKmJQ0+3rrDqVj2UnDlTpkbPoZiV5W3/blgweSvHXt1Az5t6mli085V3sooUGYWG4ewwuR+yVsHPtmFs2n1svnPitlC3APAH3j49Dv9go4AIZD6h79lLP43e6F6KdB2megxVuZUYkVrefWZsp94XcmYLdLw5Z/bYjoG6pqYk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Oliver.

> > > 
> > > Hello,
> > > 
> > > kernel test robot noticed a 21.3% regression of stress-ng.bigheap.realloc_calls_per_sec on:
> > > 
> > > 
> > > commit: 9c47753167a6a585d0305663c6912f042e131c2d ("mm/vmalloc: defer freeing partly initialized vm_struct")
> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > 
> > > [still regression on linus/master      c9b47175e9131118e6f221cc8fb81397d62e7c91]
> > > [still regression on linux-next/master 008d3547aae5bc86fac3eda317489169c3fda112]
> > > 
> > > testcase: stress-ng
> > > config: x86_64-rhel-9.4
> > > compiler: gcc-14
> > > test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6767P  CPU @ 2.4GHz (Granite Rapids) with 256G memory
> > > parameters:
> > > 
> > > 	nr_threads: 100%
> > > 	testtime: 60s
> > > 	test: bigheap
> > > 	cpufreq_governor: performance
> > > 
> > > 
> > > 
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > > | Closes: https://lore.kernel.org/oe-lkp/202512121138.986f6a6b-lkp@intel.com
> > > 
> > > 
> 
> [...]
> 
> > > 
> > Could you please test below patch and confirm if it solves regression:
> 
> we directly apply the patch upon 9c47753167, so our test branch looks like below
> 
> * f7991e8a0136cb <---- below patch from you
> * 9c47753167a6a5 mm/vmalloc: defer freeing partly initialized vm_struct
> * 86e968d8ca6dc8 mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()
> 
> but found it has little performance impacts
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp3/bigheap/stress-ng/60s
> 
> 86e968d8ca6dc823 9c47753167a6a585d0305663c69 f7991e8a0136cb0fdf35f11e28a
> ---------------- --------------------------- ---------------------------
>          %stddev     %change         %stddev     %change         %stddev
>              \          |                \          |                \
>   48320196           -10.9%   43072080           -10.8%   43116499        stress-ng.bigheap.ops
>     785159            -9.8%     708390            -9.7%     708644        stress-ng.bigheap.ops_per_sec
>     879805           -21.3%     692805           -20.7%     697312        stress-ng.bigheap.realloc_calls_per_sec
> 
Thank you for testing. I had same expectations. No difference.
Honestly i can not figure out how: 

* 9c47753167a6a5 mm/vmalloc: defer freeing partly initialized vm_struct
* 86e968d8ca6dc8 mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()

can effect performance. I am not doing anything related to performance.
I would like to ask you if you could test one more thing. I see that

[still regression on linus/master      c9b47175e9131118e6f221cc8fb81397d62e7c91]

contains also below patch:

<snip>
commit a0615780439938e8e61343f1f92a4c54a71dc6a5
    mm/vmalloc: request large order pages from buddy allocator
<snip>

where we try to use larger order for vmalloc. Could you please revert
it and rerun same tests?

Thank you in advance!

--
Uladzislau Rezki

