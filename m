Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47500CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D0A8E000B; Fri,  5 Sep 2025 15:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE0C8E0006; Fri,  5 Sep 2025 15:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B628E000B; Fri,  5 Sep 2025 15:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8331C8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:40:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37D4F160281
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:40:31 +0000 (UTC)
X-FDA: 83856213462.10.C4BD747
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3358640009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:40:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mbYnf52q;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757101229; a=rsa-sha256;
	cv=none;
	b=3fo8ZygdD8oauZT5fMt9Pu+MdjAKBNOTuWcsS4FLCeC+Opl7HIK1kYeRAdVNyz29cuO2J8
	h9UW05xlqIc0NH8ZBEQulJdvY6MQx0e2JYEMirmrGrVx3INZXpHr1morxVAyHRw5R/a3fB
	KCKx5ljCRXzAAG8WoaHfOmLwG358+/g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mbYnf52q;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757101229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5Leh3iWdpj35vfwfF+dKvMn8gUxkJHhmSd0V0QRap4=;
	b=diYS6MP5lPBZIv/GBi3gF7wbAICFXh8MRpxAAO2FnH2zJ6QLI+l3fE5cJ5lEKiVVl3/xgz
	CiYWcCg0byghLaVSm4nvGuftgR4RIsa9CSSbou2B1AgmOeivtS8t6Ff0WEYrjNtY3Zrgb7
	vyFG7NNKXXAN3VS6P50O0JIx3Ly+4gs=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3c46686d1e6so1782160f8f.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757101227; x=1757706027; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C5Leh3iWdpj35vfwfF+dKvMn8gUxkJHhmSd0V0QRap4=;
        b=mbYnf52qbzye3rClV/9+l0laUEphlGtl5P63NBUO+0VClbw5VFdwx9142xaGbheuTG
         xJo9e/LFobp5L+PKx5W+UMjJnSE3TBC8B27Z5mZMn696A6+t7xVrdkMM2uh4hihqMFWz
         muH+jjtsR57vVOgDlCbQB1jXodIfNFb4TF2O+/CkOjaOeI9fbAvd4L2hI9kjvGzopBIQ
         LBAk1DvFoZD9QKDDRtGYtEeYIHO77W3fk5unwV3aVorT4l09/TttBeZWs2djbA7lQsrG
         rOWdUcbYuwp3u+V34uTlk/M2TmcnxUW9s8gQbo0MYkQ2MMxSpuUvraLz3RzPCFMII5At
         Y9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757101227; x=1757706027;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C5Leh3iWdpj35vfwfF+dKvMn8gUxkJHhmSd0V0QRap4=;
        b=bhmDbP/NjPQUYJ99z3oGgjOyFjc1Nc6opl25emA7GeE6DHPI2sjCAArU6CqyKbWJfD
         8gZTPhpU72cr5RcEfPHaaz5D5OiRrVbHpDbqUmrHyt8LYn/L694wEQgIoDRyfd2FAksL
         k5ezXzLSypEIciC2sgPWveCX4j6H2FeYpREWEQ30Wt+R7kYTrBNwGQlBCC6ZvLkA0asX
         wZXPPZsq2VVHNac0Is3rGPMJJnSEnn+/vjYySzl89UtEsD4X0hQLa4sFV3Ufgg5qTs/q
         Q1vBeSDtsZ9YksNKNpccpEqqzzJ5Ckw/YvH4qU5mugQC+y0kZRpUQilRZ8SHcoaTIoYc
         sDCw==
X-Forwarded-Encrypted: i=1; AJvYcCXrBldvu/O0n6GQ87cMvaXzASrVyWa1AjeTGFksRwSlVqvXNVIPWlE8ZUffgd9whuoqe8FbrUx9SA==@kvack.org
X-Gm-Message-State: AOJu0YyeXtd02syzRjyNSOF/11+eJnJuJboVkGxErNTJbw9EhL7p4ITu
	5uWaVKHgRGjfPwtOAERRT1Y4a0Ae78KPoVLbi2zvkzBy8/hgpz4zlb3k
X-Gm-Gg: ASbGncvtWw17haOb+CMtNLIxfQAntcKPH6wMD9L5Csop/TdrjMMzqh+xyGdpaful7Fv
	eEHzO8nrzMRUgs8aO2iR8AD1vFtv2oqgO5FiGjqxmsLkx9nyJ7ZqBJ5rpwGmf17xFmALpjKg1qm
	2dnB4Xo6pQGi0xSfVxGlBpbzkrGpSY6sfn0v2CAx9MJ9HWEwMjnr6xSvdYMIZFmwdevTiHIiiSd
	uh69UFfGnHBrMu91D/c5cDTu6LTyxplSKxRoRuyA4IbUhwxXwdjSmfab/2U5mN7kwpc3aDibc2J
	xxynjb61/COnsyhAkIozQtk9QGid4ivsFxi+H9ze5PMnbEUQe1wzCnKDETS4CCQHq1pUWNifP58
	vif0xhK5BKcqSiP6uTyewX5IkPu0gPjN2hsNuFc8gCIxFsqFAJE38ypJELzJT26jo4mja6p+/hR
	8zZmTcD+vGDPdt+zr83rTtw8HslEAx
X-Google-Smtp-Source: AGHT+IGkCUtoIJmK/cXGI+fG8KbeWQpaLfWU2RtQVWVmzNIv533orfL59bVmV7MDCa5V1l6DsQsCcQ==
X-Received: by 2002:a05:6000:2012:b0:3d1:8d1e:8e9 with SMTP id ffacd0b85a97d-3d1dfcfb918mr17778240f8f.32.1757101227334;
        Fri, 05 Sep 2025 12:40:27 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d1319sm378087845e9.5.2025.09.05.12.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 12:40:26 -0700 (PDT)
Message-ID: <abe39fc3-37a3-416d-b868-345f4e577427@gmail.com>
Date: Fri, 5 Sep 2025 20:40:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
Content-Language: en-GB
To: Mark Brown <broonie@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com, Aishwarya.TCV@arm.com
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
 <c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk>
 <5F7011AF-8CC2-45E0-A226-273261856FF0@nvidia.com>
 <620a27cc-7a5f-473f-8937-5221d257c066@sirena.org.uk>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <620a27cc-7a5f-473f-8937-5221d257c066@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3358640009
X-Stat-Signature: mgkff8c5jjeqkp3ncs8qakkc5puz43zq
X-Rspam-User: 
X-HE-Tag: 1757101228-397033
X-HE-Meta: U2FsdGVkX19Gebr1CMxnHTpyc4NNvykxI0TGkqX9Y4JMJjTJqQevLTfO4Ire67yBUurWEIgn9TG7TljNj8GKCybdRaoi00quc2WWLBEyC9sCri3uKlcqXa/fwOqVr51AkNn9odJMM1QtHG+hUCoRxwaA1CUoBxmyIvv51g3iavnrtcUySACzB2oyr0aIMJaDDXPY6pjYql+PD93fVbOBmPXNKIuVUw3ghw5iCguHWd9yiOUsrHB+vQTnmd8MUT6Z8JwjHaSUtzckOnj63REAQqRSHCrfFJLmb6C6mJ7Vt7JyfAJvC6d7tECD/XndgRtENxZ/ilsxGepCklimAhw1mnHZ439dect0gdb5sxCT9EH1uyWedOQ2WAtyzFKASCPdTM9UdEbciybQ206SfZ/XTg87YclP7jz4uzNx9hXHSd4hOAvZjoBjsLIOCzoX4QPGUfWwZ1j4/pmBtOqZmiAJtd1ls9fbS8SwsGcIK3M9o3GI0CRT+uR0PmBHAjXsBmXj6J4CZVNoUZsSoxZnb7X/zsNRLKizW5m95NbO99DHCmXy1xj/sYix7ZA78sVuQ5M0jOdOLVCWYoR2ERK5pfMZTTsy91716UhRzUidu9m7mDIm8vHs9LxO57E2xZ/t7GaZhDRBcWPSW1bOh5xCipjj1TY+yRaF1iNUz51TRzrPgPbiIulBtzi+E4KPOhb25ZyVfawc2vbiP9THRjPgdIp0E8ACDkwzFSsDCPPRY35kciDjGARy8lAYDJ0D3kn+viIeYWKxHTe40RRDr5cKSIPdHBoT41qkkHvS1FKljawhVfWHf0oKQMookeR20a2emqNHo62/d+bab5JowDWg0gcZfYwplg56dTqqkkMNBd6EJEZ17mCXzAbfsN39T09Fy+6uesOYkLKQi/9082isNmrwdpBIB678rKkDO7AbJTltfS3ppDxrcQVNvNKyuFKigIsgaPSIvRt+saDU93Nonxf
 8Apcy+f1
 Uq4+gQ8C0mLR7Sj8KLWTxsuvjm16O+rrVXEzoJ1FB9oj4XcuP4hGi2gyxmEaWgTsbrlVUEJwoR5OJs+kFtvcuxn1EaR/DLml7b05pFAjb/7QES2fUw5rFTRn79YP/IEt19x/IJ/lyBf+hEXfiqTeSDw2ayfhQW4LFMgC5NlTnM69z8mCB+OL9XPxMcUEzNNetzjh0fTO/z/D7dYFLIznIddioeZCiQ0194jzKldVgNYGW/LJfqzMDt9ccQKRR6w1IP24UBWVxEvehk8+iyGguQwZhBbBpksC6yB4O3/WmLTtKFa7EpMQyOM/lTZLeR5l5S0sozXDKHSFtsN9oIkoeTahxwR3/z0kjEP+IcMnvuyhHMGAIeNkczJDzObNv3tAJZJ5+uvgPEk5Zuk7CFnuM3hahtolbenhfIL5oUgpL4k2i2T7NF4HuuH7YTtbL7GphhtwFZIBDGVxUk9abTlAES2C8rP9KFZeYDS2R3Zmwm7Srm810VXOVQ2sDd8IPcFJdzAtHrFcl/laL3GzcYOJWws0CnIsAihCHs7sfNzl8ZG/3AYRW5XumgV34NB2Pvax6xPDbcRnebHymdZKtq6nrZyJ/3lqHHPEMCkxA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 19:02, Mark Brown wrote:
> On Fri, Sep 05, 2025 at 01:55:53PM -0400, Zi Yan wrote:
>> On 5 Sep 2025, at 13:43, Mark Brown wrote:
> 
>>> but the header there is getting ignored AFAICT.  Probably the problem is
>>> fairly obvious and I'm just being slow - I'm not quite 100% at the
>>> minute.
> 
>> prctl_thp_disable.c uses “#include <sys/mman.h>” but asm-generic/mman-common.h
>> is included in asm/mman.h. And sys/mman.h gets MADV_COLLAPSE from
>> bits/mman-linux.h. Maybe that is why?
> 
> Ah, of course - if glibc is reproducing the kernel definitions rather
> than including the kernel headers to get them then that'd do it.
> Probably the test needs to locally define the new MADV_COLLAPSE for
> glibc compatibility, IME trying to directly include the kernel headers
> when glibc doesn't normally use them tends to blow up on you sooner or
> later.
> 
> I knew it'd be something simple, thanks.

Hi Mark,

Thanks for raising this. I think doing 

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 89ed0d7db1c16..0afcdbad94f3d 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <sys/prctl.h>
 #include <sys/wait.h>


should fix this issue?

Thanks
Usama

