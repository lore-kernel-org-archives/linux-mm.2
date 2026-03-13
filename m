Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31DC107BCE2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 21:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9036B0089; Fri, 13 Mar 2026 17:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66B56B008A; Fri, 13 Mar 2026 17:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EF76B008C; Fri, 13 Mar 2026 17:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C377B6B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:09:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C829139550
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 21:09:19 +0000 (UTC)
X-FDA: 84542280438.07.F8C4F1A
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C6E920004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 21:09:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=cxxjJSNy;
	spf=pass (imf03.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773436157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Jx+q6YpZ4N8hFr/zvIrb5Yag5lRMSERYlpvIbJzUpk=;
	b=v9SAcrCnqzUJFrx+oxKwcBwrX1udEcothnqr4M4gQel1FuI97CZtr2PzZa044MagFpFqnX
	OismXPvpI8sCYJseSK+rR+B2to07wqfGN0j98jEFvIjsgr0Q6zqZXsoycS/SeGT8I3z9p8
	6aWXd5TreT+W9G4ENsuZaULFn80Zy6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773436157; a=rsa-sha256;
	cv=none;
	b=b+GFR3SKKUz+tFU97ADlaHU7JnAvCfhvJXADy/HctPsx3nJaT/pDQ0ci0E8MMHp5niCsHm
	wv05TPTQK1L4yXEH0lcYhY0IvbpzrkJ9+V91255yUbZ8YSTmUcydelHS9LUV6sKwryko99
	Ndu9pkTnDnT7ZMkJ9icjb3ylzfXkfJs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=cxxjJSNy;
	spf=pass (imf03.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+Jx+q6YpZ4N8hFr/zvIrb5Yag5lRMSERYlpvIbJzUpk=; b=cxxjJSNy0+YNIJ1wE3OHiJX9No
	tWOOJGCXM4BHpU2vuK+SuDmWhMUr18DiuRh1TLUlsAhyO+/K/1Vm1Mwk5VfQJDxOzCm0vdz8kpWBp
	Kw7i34uC3+N7ddDQ0qygkLVxndVavmqgbRDmzuP11WV4GNy0/8F1SmDrmqz3U7ePZ4qkWT+GlX4sH
	dRmtTx/xMMwoMDGicWlHsC5GmEMeiAy4IW4mvxuwgXQ105q/BY4obccHSWrEggYWFBgBSKBJxZ6tg
	Ctwb0sb3JJWOjuKY/8yg9l8BhPETCAPNvC2UcZxtHG+dcmLF3lZDxLYj3eQ7dUj4W/eiaUIJ/Pizz
	euBBckEQ==;
Received: from [179.93.15.111] (helo=[192.168.1.54])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1w19kw-00FRMq-LZ; Fri, 13 Mar 2026 22:09:14 +0100
Message-ID: <62b3bcca-7e4b-09ce-4996-5b67f066e123@igalia.com>
Date: Fri, 13 Mar 2026 18:09:10 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH V2 2/2] mm/memblock: Add reserve_mem debugfs info
Content-Language: en-US
To: SeongJae Park <sj@kernel.org>, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
 kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260305014430.79405-1-sj@kernel.org>
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20260305014430.79405-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wos9hbz6j7gm5cnafsog36dfty3prqwd
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C6E920004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773436157-885085
X-HE-Meta: U2FsdGVkX1/GIG6wO2SDVUSe05Otply8OApSUf5YEo+5uL4o2nr5WIRChZOprjQQUiZM9Yi0Npu5fk+vW4pmjnfZ5qi0fIsOVTsR7TwwAAOOQuzfajnuYK/O0uGsfs7wdL80Zpc5tiEshkqkOmdHdctYklic2Y0kZ1oxnYfCHBHbA+j0WcbLWmUMx4lS2mOA2lc1/5Rmsn0ITdGpm2+EMCeBuGDBP1ou77X3FxznBw5eTcwRDqZ85kPV9QKOdRCI/QJ3Oh3ZC5bfi6X9ps4WCzYfnp7+JcAkh10HpsK+5SYEf1ajLMvC0gkG4r5geOxRysiClpXiJGX6IRh3RKfLgqxVmq8QRJOUbjedukkzPG018g+sU/GVOyqsneyv12GtfYOa4ykJLxuKxucMktk3CLs6y15VEXQHEn9LcUJRJPYAJs5uIAAXuebndfPK8wcFnXtKtH6qqy1NBkEim8D8npGPbbAoNVcgLdIJyx2Klfj0t3UNVmTrnghVpGn01wZycjIpNdu97hYQMRu5LCix+0w42WbaB0WTeEYd8tzQ+JYN6GfR5WSfT3C0+jee6sD0L07/m4YG8EKS9hp/Y/PdotAW/68IDKPMpJdA8mHPdbzIvfVAcMCcrsmfy2CGEEzJJuulNKWWO1Ve8t2KuI2+mw9L+8rCX3dZdkO4ewkOw4eFot0KUZM05TH5/u4vIj7YziJXjGLcIC8Gr7xnBxpskFX+0IiclgjqvRi8c6WxcMa27RAJtL9qYXrnBZDfvZAOm9nvGpx2NPM97szmRSzzz7+udRLidRnaQKOpmtkUR8vmiY6D+F/Ppct6GJaYZFi1W+nt88HLnhjWHFycqKPqp5/wTA+qs+AhkV6xLfpH8nJ/M+0OEcQwc8P9e7U+VCdeVPPaOKuN8yw3pxPcsWzRGpAujgPQPZPUTSFmvf3tkfPQ5BWrO5s7dKYSAFxDvZuXBBhSv1yt5VTqPwy5hvC
 kQqptPjE
 yZ4/2yQ7jm2zxFt0ja3VI27Gcf+D8DvAtkcDh08pmqqL5w1L93nP9MyMJuT47n/eymJfhrcFv2SUCXanQdWY4rObNKBz/qwSQPKmZB93ddghOFoTIFzQbsc1zohsecdoSETpv3FYJsAhrhUia+LnzRD8FmMySYRxtnpZyzciJJpdhdLTFil6ofGZDNxygDQyaoSudnfJkpR2iQIOnGjip2tmimIOroRNLWMsrYPYMAUbvq1ACJehh4bYVmcqLam6Y3ZlAyUx6Mwkdg4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ and Mike, thanks for both your review! I'll respond the 2 messages
here.

First regarding Mike's concern from the other email:

>> +#include <linux/string_helpers.h>
>This will break tests in tools/testing/memblock, please add a stub there.

Sure, will do it!

On 04/03/2026 22:44, SeongJae Park wrote:
>[...]
>> There is no easy way to determine if this kernel parameter is properly
>> set though; the kernel doesn't show information about this memory in
>> memblock debugfs, neither in /proc/iomem nor dmesg. This is a relevant
>> information for tools like kdumpst[0], to determine if it's reliable
>> to use the reserved area as ramoops persistent storage; checking only
>> /proc/cmdline is not sufficient as it doesn't tell if the reservation
>> effectively succeeded or not.
> 
> Asking out of curiosity.  The previous patch has added the error log for
> failure cases.  Could checking the kernel log to see if it was failed be an
> option?
> 
> I think this debugfs approach is easier to check for the user space, though.
> If that is the reason of this patch, adding the clarity would be nice for a
> theoretical case that debugfs cannot be mounted.
>

Exactly that! Not only debugfs way is more convenient for checking that,
but it feels a bit weird for me to assume the reservation worked by
checking for errors and if none, all fine. It's valid, but as a matter
of taste, I prefer checking the file. And not only that: imagine we have
more than one setting in the cmdline, for other usages like ftrace.
Easier to have the debugfs showing the succeeding ones, by name and
size, ready to be used heheh

Do you have a suggestion on how should I mention this in the commit
message? Is that discussion enough maybe, for future reference? I feel
mentioning that userspace will use the information from the file seems
enough for a commit message; but I'm totally open for your suggestions
on how to improve the wording here


>> +	if (!(IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) || reserved_mem_count))
>> +		return 0;
> 
> One trivial comment.  I'd slightly prefer having one less parentheses level as
> a tradeoff of having one more exclamation mark, e.g.,
> 
>     if (!IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) && !reserved_mem_count)
> 

Good! Unless Mike is against that, I can easily change it.


> 
> So, we get two level of nested ifdef...  I'm wondering if returning earlier
> when CONFIG_ARCH_KEEP_MEMBLOCK is undefined is easier to read.  E.g.,
> 
> 	#ifndef CONFIG_ARCH_KEEP_MEMBLOCK
> 		return 0;
> 	#endif
> 
> 		debugfs_create_file("memory", 0444, root,
> 	[...]
> 
>>  	return 0;
> 
> Very trivial comment.  Why don't you keep the original blank line above the
> return statemtnt?
> 

About the ifdefs, as per Mike's comment, I'll rework it in a helper. And
the blank like, I have no answer heh
Likely a braino? I can certainly keep it.

Thanks again you two for the suggestions,


Guilherme

