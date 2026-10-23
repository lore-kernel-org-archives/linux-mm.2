Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E56606A319
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 01:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HOImAPTl
Received: by kanga.kvack.org (Postfix)
	id 5CEE26B0A9B; Thu, 22 Oct 2026 21:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5801D6B0A9C; Thu, 22 Oct 2026 21:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E766B0A9D; Thu, 22 Oct 2026 21:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16A9C6B0A9B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:46:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CF48160335
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:46:56 +0000 (UTC)
X-FDA: 85352202432.01.9A8D2DF
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87315140005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:46:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HOImAPTl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792720014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49tlLsKwv8QYIzXZv81VYW9pKqhefGCVYLctFPyDUlk=;
	b=dAw1zDLCrg05Yhv2Ex9ayWi7YCDHqWTdQTIVTPszu6B0pMFdq6cflc05bCLmR/BBQ+WxBQ
	Ovx/Qz8vQh54a2lR4EULhWOw41idUU4PW3ZXzC85w1wDp4d/BhUfujfuxbYx8sV598RTFh
	BBOrbZV0JdnUc9TupDpl3QG5nbeNcS4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HOImAPTl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792720014;
	b=nhxezdJ6Ap6aAWfRx65l8pwQUQl6lEoKnlZSMKNUsQiEWec17f0snnNOZRns5vbOg7OvAJ
	krknvdv+e5B8acU5vyQErMAxQ70tfjM9XpJ7lIHCbNA+uXwHpre0LTD27o2qhv6ZGivQgU
	PQ5LI7yUM1VEPdtLEr8WX28mLQPSGBg=
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3adc0ac3566so66079a91.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792720013; x=1793324813; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=49tlLsKwv8QYIzXZv81VYW9pKqhefGCVYLctFPyDUlk=;
        b=HOImAPTljEeZEFqzE0Y5VkgC2kActs3vfvlQZBykCclE7iU7Jp14FYVrLz6Y2sD6LG
         7IDlJgrTJR9qUHtlW76dY8ULWD9anonBuLFZ+MbFglQHf2z87ZmNHD2fbtkLSy4yXJYR
         jnFMCi4isSr3Y5F/dPwnNBvip5qfMyNVfwZnSGpqgf97adi/j4d9TJYgU4ZngXLYADLp
         XPOh13tTCDux97yaf+HSLQld9+83rG1TanzYWd6iCCMMXt0oQlVulrHrvZOBEfyXANXP
         9ZXJgBNvMG4kpvVQ9Kr62rRHMsa9ZJdWyWwVDDJW07CS5Pz18MJDqruxzYiF/kH6MrMO
         ZeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792720013; x=1793324813;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=49tlLsKwv8QYIzXZv81VYW9pKqhefGCVYLctFPyDUlk=;
        b=1nL60mOhupqZc+saSLqYQSmR5a68p5uSIiRJqzqehmx/ZuVlr2eG1XyT4yHRy6CyUp
         KsOuDfL/kuzQTlG7+KPSLecrt8QGphyveWXdykjcDQrQ+6KhOWqwISEchH/osiQGZVaK
         /AGOuyuXGs0onn0bUcwatfrGFl088Lhj93VuMGCu3afu3y59swTneNIPFiwyP35kz7gd
         /guZwrr7mUNiGpr9/hsE5GtJdS23/9TB16D2oXEy9oC1R+x1TAJiPEDdPScpgxTWbVy3
         u6IC5s8044jDrFmKPy2w8w5jO1SBAHDBiZ+Cc5qNiL8m4cFHMWvo64Ab/fxi6EJj8mZp
         NPRQ==
X-Gm-Message-State: AFq9FYL0J7oi85nVr7FcCT2Z+0FwWMck0q3wsQbMlbi7SU3UhM1pnnhL
	7Dy9M2P6YutqOuS77kJHLrdZHdfZXCBWCo3HwU7cDZBr89CEbvAY50Cr
X-Gm-Gg: AYBFou0zoiVhIEyrGSOV3UrSg5TihhdHjtivNyf1iIvUFI/WIXG12gslGfI7rG4OpQO
	9HCU5FYNd5/4VovlNReG7+tShvrGry1bvmBTqdqsOB9lmBioFu7zBm8Sju6hpgdGExGBgPMeo2w
	xSzLcxDyXVUNxL6lUvqOBdqDnIfUtT4hD+mvOgY70pE8xjZvkc9x6jVyD5qIz/+VRNejBd7IPVq
	R5SlwXaGzpuhvkdrnOiRKzeLv4v5ZbhbAHwr9wBnTULRezV9YNZ2az+vO8EcJVy6u+tzwy6FeAp
	AJEE9oGHfVKoZPBZ6396WsBQTITyePZXqgTR/RYoBl9kDKa3SKr00JL3KY20Uf0LQGAwzXP6gBt
	MhnMdEevOGYrrvbMJbIZMxQnJ/aCopBGy/vTb4SzWD10XWI3NWQ4kzIFQR3WmSr/wT9G0YPzX0o
	QBCliS020DsUY5L9kLg8/P8zt2DyrxJdEy/H6nG0Fpc2KuPFqSq0Gs7dLEmF3DCcpJmOIknBqTR
	9SKHytxPv1h1JV77WH2vaKMKz0+vckDbZHaVo+lwNH7kLCKjGrJMVzudYOHuIU=
X-Received: by 2002:a17:90b:52c7:b0:3ad:85fd:711c with SMTP id 98e67ed59e1d1-3adce03c81emr663240a91.28.1792720013195;
        Thu, 22 Oct 2026 18:46:53 -0700 (PDT)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adcb1d84fasm1155510a91.12.2026.10.22.18.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 18:46:52 -0700 (PDT)
Message-ID: <809fddf5-c4aa-4a78-acbe-c9c39da2d363@gmail.com>
Date: Fri, 23 Oct 2026 09:46:35 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] of: reserved_mem: use dynamically allocated
 reserved_mem array
To: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring <robh@kernel.org>
Cc: linux-mm@kvack.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Saravana Kannan <saravanak@kernel.org>,
 Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <CGME20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c@eucas1p2.samsung.com>
 <20261015082315.56876-1-m.szyprowski@samsung.com>
 <20261021134138.GC3667411-robh@kernel.org>
 <e42637d0-c800-48fe-b943-4ec6ac540d82@samsung.com>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <e42637d0-c800-48fe-b943-4ec6ac540d82@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87315140005
X-Rspam-User: 
X-Stat-Signature: eyw3ey15ugdgppk964qp7ihu6i3dui3h
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792720014-31847
X-HE-Meta: U2FsdGVkX18E23NRwFwA0qBs7VgfGYzSVRZv17mBoOv17UM2D/JS0M7biD0Go8l7o+gXWiT51IOkvjiXdO9K8KgSsAzhycF20pfPsuq/Pd6FjeE8yKB3zH9Nktme0ZpwmMa2XpDPTDp4PFF34SdGYNmxSneDc9Y1ANyaSYDEhuoKGFmDrL4M/IiM8bxE0LE8egMJVF59LbABLYZZZKTFEiqF9dChO6AneeVm1eikVwYCHmeuteOcZrucXiPt6F403K4NqqO98k/zw3iVrsozaybmNe6dmKtTN1czZ7jVZ2xmeBmc6PdQfe7Rw5idq1x+OrGQIArXOCfHd/3VrJhoujG3gJ44wyBvYsqyqqirl6hr7MJ7VP8Yup5nGahh+28ypMRgW1ILNmsCG8rJ7Q2ZHMhmB5od/BgVFaeEYXet8TH1YJjEpAr3M862FpNAnL1r2jubrUtoW3kDRBJGf/fm3s0pXmoI+WaaGB5ml9EbZQPStqWyRhDaecif79nE3Pm9eyJ+8tPNYIIE5CA1ycRKsuokzF+cgTAun/2d+gRmyaaPbT8bgMrXDwvVki2QKNcSm2avIeUVFx8pK/kx/58nuHaWkzGQW+WJvy2AC1a+EJWMCDiL2nyMYnjh41nqNIwYguVwJR4IqAJQKEkUh8S4IQj5EB8q5BZkLhbPXOKHGmuiB5/cARpl7J34a9+2c22IJfr/B3ncdFQcfdDkWydmoIMM/CUzTKzWDRj8WjG1+QvZnDfNLdelmtwDYSPJc6hz1QXsdiLxS8PZHaOM/lI/juxzbooH+lx8Z+Xei6uPYClKAdkC7++N4bDFNglQELfrBWHzoEUROTobL5jYif+pkbPnh437NhWewuGSZ15eNpAW/BIakL4Oyhp3FJNSAJaljSUdQIO/9suvgZCb6drgOow5xrHiKUE4LY6PoswdNi1jbW1OD0MUitZeo4asgwGYCpISFwicFwFAaR4r41a
 rCOWIeMk
 r+USFqTeC1wMPVX1WwLBFhJSq6LcCf9LTkr7nlB7nemj/wIygc+H8YiTH8YQTpE8k2XfryzXf6kuM4NlgEXohfvYHzN1yD/itT3FyY+bpytASQmDGFeAxTTprGnxW7xaRwpIbxRDw9M7P9PApQfdL4kLg0/3ay44FShlVRDf5T+YTrpgrwwAEgSPfDhxw+xcjer7AO+g4nU6eZNbvNUcjrdIkNLMos3J1IO8g2NqM9FQQ/sd9Z4KN8GjN7OtuTEavcVicHW0kRuptDOZkkNip8wnVGzlouGeQxXJKIALnzYdvoO8X8BU8TCaFU/rCVinnd9DaLi6nkhSF8v/cnvceuIfnnzGuIuGrZgbooxXSRHIxV7DjjpZvhfBZYy43PYctpnvYsSrEH7Comlc7/Nvyix7mCdH0Gzx/WK0X+fr9PBMQGn8RNksIldrBLLzdYNMuRGkVihVGlEX4ry34z2ewuQ4/UeH8wRHCHzUrDcNyEGur7S5tEBq0X2RWwjqfkMdPquu/QPfUxrjcx6eb4sWJV4hKCxL+W0GnQT3g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/22/26 17:59, Marek Szyprowski wrote:
> On 21.10.2026 15:41, Rob Herring wrote:
>> On Thu, Oct 15, 2026 at 10:23:10AM +0200, Marek Szyprowski wrote:
>>> Mike Rapoport suggested [1] how to properly use dynamically allocated
>>> arrays during early boot.
>>>
>>> Use this approach for reserved_mem array during early scan of the
>>> reserved regions. Having all the reserved regions in a single array
>>> removes the need of the two pass initialization introduced by commit
>>> 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
>>> regions are processed"), so implement it to make the code simpler,
>>> easier to understand and ready for adding proper error checking.
>>>
>>> Tested on ARM32, ARM64 and RiscV64 based boards. Arch specific issues
>>> with early mappings were discovered by LLM.
>>>
>>> [1] https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
>>>
>>>
>>> Best regards
>>> Marek Szyprowski, PhD
>>> Samsung R&D Institute Poland
>>>
>>>
>>> Changelog:
>>>
>>> v3:
>>> - allocate the reserved_mem array only after all static regions are
>>>   reserved or marked as no-map, so it cannot be placed inside any of
>>>   them
>>> - record failures of the early static reservations and print a single
>>>   message asking to fix the device-tree
>>> - restore conditional compilation of the early mapping code, because
>>>   some architectures lack support for it (C-SKY & Sparc64 as reported
>>>   by kbuild robot)
>>> - allocate the array bottom-up, to avoid allocating from highmem, what
>>>   might be an issue on Xtensa, C-SKY and MIPS32
>>> - don't use the early mapping on PPC64, where the scan is done before
>>>   early_ioremap_setup()
>>>
>>> v2: https://lore.kernel.org/all/20261008152403.766439-1-m.szyprowski@samsung.com/
>>> - removed superfluous ifdefs
>>>
>>> v1: https://lore.kernel.org/all/20261008094125.3197971-1-m.szyprowski@samsung.com/
>>> - initial version
>>>
>>>
>>> Patch summary:
>>>
>>> Marek Szyprowski (2):
>>>   of: reserved_mem: group allocation helpers together
>>>   of: reserved_mem: allocate and map the reserved_mem array early
>> Can you confirm the sashiko issues are not issues?
> 
> 
> I've replied sashiko review. That are again the preexisting issues initially
> targeted by Wandun's patchset:
> 
> https://lore.kernel.org/all/20260920092852.614973-1-chenwandun1@gmail.com/

Hi Marek, Rob,

Since this restructuring and my series touch the same code paths, my
plan is to rebase my series on top of this series once it lands, and
send a v4 then. Is that OK?


Best regards,
Wandun

> 
> 
>> I'll apply this after rc1. Are you willing to be added as reviewer or 
>> maintainer for this code? I'd prefer not to have another entry just for 
>> the reserved mem code, so you'd have to filter out the rest of the DT 
>> code (not the bindings and dts firehose) which isn't too much.
> 
> Okay, I can try to take a look at the drivers/of related code as reviewer.
> I will filter it out to reserved_mem related changes locally.
> 
> 
> Best regards


