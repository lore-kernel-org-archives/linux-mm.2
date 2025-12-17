Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1117ED65C7C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 17:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758746B0005; Wed, 17 Dec 2025 12:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7300A6B0089; Wed, 17 Dec 2025 12:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63BF76B008A; Wed, 17 Dec 2025 12:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54B316B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:19:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FC9F13711D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:19:32 +0000 (UTC)
X-FDA: 84229624584.13.3A2ABD0
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 246F31C0014
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:19:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4i37pxLt;
	spf=pass (imf21.hostedemail.com: domain of 3H-ZCaQgKCEgtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3H-ZCaQgKCEgtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765991970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmH64XmJ0F0IHGr/hDAMtzC5HIceqcOPcSCpGBeY+GU=;
	b=jBiFSAJY8yQkrygpj8dqxg1TLECgP8UqVjb3eHk5AlQqQOr7GNN+QB04/YGTGB1tlwbiYx
	oQuZGsxayLi5x5pFQQVq0zqEtlaipnjVbTjLafC2l1O4f01ONa8vG2ncdsvzNlXtDUbGY1
	nksiLsCY/teIhssx6t7OnUkygzra6BY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765991970; a=rsa-sha256;
	cv=none;
	b=qJAC/hJ1HsEOsmylZ6paZL+d/yqadhBa1dThk52ILd27vz1Cmjep5VULDs8fYPGguf8V1K
	YMNHP+gi0+d6HUVXQLQ32T5P01TEFDjzqGB/a4KHK9AhVhMHc97syuITt91gmxXZtLTo3Y
	sZ/EaFVsHIb27q5hh7bxhpO7z8wRpn0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4i37pxLt;
	spf=pass (imf21.hostedemail.com: domain of 3H-ZCaQgKCEgtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3H-ZCaQgKCEgtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430fcf10280so2519241f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765991968; x=1766596768; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fmH64XmJ0F0IHGr/hDAMtzC5HIceqcOPcSCpGBeY+GU=;
        b=4i37pxLt3NyVioT/FQ7zBHixE4FifbHIrgeoSbJi7YtyShvF3EnUSTI5msGOoynRgs
         TwGj+rRyyTHj/LvI5wYJDGI8Y7Xq2zCKC6MY0V7L+h1PveehB1l4h9RUiKINAELaLa+W
         8hR096DmsIjLBmhXKwF+B4Ckp4LMteb29vm3FcBU09HscbOflF0Za4ePHeRoWCZQqTcy
         gX82bZXKV59UD41P4iFsi4hIXxWgPtefOW7JLKsqt+pgdb0jDSbr0BfdoOG3qTZNZUsl
         f3VROcyPVu9+VyY5fKgHaix0np3/Cwqfm1b+NdvhURhVXLdYB04OLPF71dWNJTrI6BSX
         bnkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765991968; x=1766596768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fmH64XmJ0F0IHGr/hDAMtzC5HIceqcOPcSCpGBeY+GU=;
        b=iMX1h6aE2/JpyRLmZgbq4NJ2tATR7TyCwzcntYunCSK5uWloroT+UF4Kzjy0fdqa2+
         9RaKaKqvmGXiulnTQb5eoiSSWAp59h4u/0G8+d8jNG11RVoOk/Avfk/EiV8PzNu3+/73
         Xo6id7ulkz2tPj8MI37Qo7Mf7cYkPzbGJbTTA1BS/yAyMWLeGjLt5tGd0ptCt2G6z/DS
         2WNIHBIhg+6h+igBnjODyO6Z2LX1UXy828vQxnVrO6WBF7Xnfmci5lXooNYUE03ucWYp
         gKlA7CY2dY+gKQ1zgMKrkBjH9Pl5i7IhzAc9RIra2EKHrwJZemHjsgF3Ge0QMbJCXqFU
         DWbw==
X-Forwarded-Encrypted: i=1; AJvYcCVWOvNYXPeA+m7Fx+FUhK8gTGS0nNjj9+cdNoVbqWb7ilNeSrphF6vXNa23RPmxqPxe0hLfRlcj6g==@kvack.org
X-Gm-Message-State: AOJu0Yz+DoqmmRz9dLQGulqlxjGUJ6YlFg5PY1777GL2mTln+UZRXEsf
	SMNTfPREiFWHf4Nr517q96nKEt3VoOMIt9SwZWm8oTI13oVQTOkmNk1cz4lBP8w5tkJEnBvEDcl
	QnltjaFoylv0DwQ==
X-Google-Smtp-Source: AGHT+IHT10heBTKc0la75zjUcdcWeKQLxIjteE6wN3WG7RYWYRpvl3lG55/6zSe2LENPLJF5rOBhHUOFskHNYw==
X-Received: from wrbfo17.prod.google.com ([2002:a05:6000:2911:b0:430:fdbe:cc61])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2404:b0:431:864:d492 with SMTP id ffacd0b85a97d-4310864d73emr6566925f8f.36.1765991967910;
 Wed, 17 Dec 2025 09:19:27 -0800 (PST)
Date: Wed, 17 Dec 2025 17:19:27 +0000
In-Reply-To: <d5354d96-6f28-41d7-9f66-64c254d9477b@suse.cz>
Mime-Version: 1.0
References: <20251212161832.2067134-1-yeoreum.yun@arm.com> <916c17ba-22b1-456e-a184-cb3f60249af7@arm.com>
 <aUGOPd7gNRf1xHEc@e129823.arm.com> <100cc8da-b826-4fc2-a624-746bf6fb049d@arm.com>
 <aUKKZR0u22KOPfd7@e129823.arm.com> <d96ac977-222e-4e8d-9487-da1306198419@arm.com>
 <aUKnfU/3FREY13g1@e129823.arm.com> <d912480a-5229-4efe-9336-b31acded30f5@suse.cz>
 <DF0J58HOVLL4.2E16Q87D2UXRW@google.com> <d5354d96-6f28-41d7-9f66-64c254d9477b@suse.cz>
X-Mailer: aerc 0.21.0
Message-ID: <DF0NWLWKRKYI.3PLY78UGGG2PD@google.com>
Subject: Re: [PATCH 0/2] introduce pagetable_alloc_nolock()
From: Brendan Jackman <jackmanb@google.com>
To: Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <ast@kernel.org>, 
	<daniel@iogearbox.net>, <andrii@kernel.org>, <martin.lau@linux.dev>, 
	<eddyz87@gmail.com>, <song@kernel.org>, <yonghong.song@linux.dev>, 
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@fomichev.me>, 
	<haoluo@google.com>, <jolsa@kernel.org>, <hannes@cmpxchg.org>, 
	<ziy@nvidia.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>, 
	<rostedt@goodmis.org>, <catalin.marinas@arm.com>, <will@kernel.org>, 
	<kevin.brodsky@arm.com>, <dev.jain@arm.com>, <yang@os.amperecomputing.com>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>, 
	<linux-rt-devel@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3atpqddic9j1dfgbgo95k846heaper7q
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 246F31C0014
X-Rspam-User: 
X-HE-Tag: 1765991969-288166
X-HE-Meta: U2FsdGVkX1+irIJuk4K17javExJLjx5YOg4yHFYKKBTm8J+7So8XIBN96CxcMzxVGKH3Ks/qECok0GK/J2N8x2OS6NVOZ48yXu7i4LuBlTr39tHxamLkS1XLnGeY/6gUBi/tZqO7Zxcs81C3sXgSn3hulzp42t+VItK7oY1iR+QWzYBi4z4KlaAt8qJ/LSlmYkh8K8sB24Fa3TMTXesed5qNrd/dWnJ6UMO46vQyhZjyT+AOiD3q/rounYSY6GX8YXnvbZWCmYGNxxpnZdS8c0oRyLnlwQc10SmGl6rhvxzhrMwklnb4PBkM5gg+ZdSZbUle1084O/HutKrhZEGgxBr17aE3B4idGg8sqSlLqo8otpoUG+HyqPPSN17UZiAfNjMymvKT14wzDERL0SX8kDjrc6JeK9azCiTreBApxOOT1htERDK4wfhdf2mClgYDN2BDZuZ51t2WF11wl2kLDh4NC2jAE7Nc84fJcO8TpeW+re69g0lTA+fw4sbeS7TV4+eKgGQsMZbQ69F9QQB6LJBtNmdvyTPby2DbTV4VBhzjBsGrDO7BYiyCAxhGtICUUtl02YxCqcfVyBiNeIxtHsquUxseCnFeAMi0uUnVaZnvZ4s1DUyEo15bBHSKUPuHfgR25hC1DtyanlhBoCOzTeJx93u/xS165QlmTA5d2N0AVtNmli8hBmKIlH/quoyElhWOrHhxWuYmt/xYcWudwdEZvxctUcAJNKom4J84BYOa6n6dl3PQNJwdgom569L8JlZW98rChIUy4DI3NpIDO1UOsZ2Ad2VSGWIRMEldWNe9L50AVIHGt/e/Y2DhenyTyyvVij+UcR0CHk6YcNpiMBcJyQg/vJ2ScyQSTnj8Iaw81bk+Qyy+eFHqVKpJ1tOtTsxCTrkwk9kNjkFa64pJDbXV3qjb7ffCY/xXebtyEZQCilrEDBZPm1jjcALS0ZMriUFWBRkfeNc0LewimFI
 +NzlWAAB
 2ky7cPS3GN3LV4i+EwIGT81VPzTnV90AvU93ZpH4CQBouTsMWJtGrJSxPyLxidUzKdrGiUhwuJ4881Yxk/1rhiza1Pdtm0j9OTDNq87mGSNey/staX+N/lOrN6y5ylzpFPjAWTs6S04/uZU/3jTZ+LBmPD4H7ylP2Ejj8pG6A6kNpYCw1NpImPvkGQpfoq+cFbVRGiLrnTwhTSWsEooJUYnlqjeKo3OwBJh3cbxbxV5o3peb/D/UshWtd1rDEvzEvJl1AL3fBW5Z8BS8oqWtIxp3Hgmwrz+bELvtl9rAqbZPejeUktuRlXuX6eCrrN8zJIRGOSQvruAw+qxMhpFedb2eJycmyLneFV+WnzM8KJED/8ybIFtuXhRXV9vx9vTkWlq8JobIZw1bIz3d9OiEsq5CbujuziTKR4UUev4UTH2kTbi/XqqwJ+irYu9d06dwCZypNuDovwBFVCjQL2lJXVTcuGxZXw/wU3biv46YL0u/dRwt4J857Il0HAQPdEtPcWffQ0LkomuDqi2Evu50sJ+cGWRhDiMg6dAPf4yW15X5UWrdI8dL4HntcsZq9CX1CRUvUeKQDyHzLG8C23PKBwojzov8spa7fx+eh/9p98Ta8WhxG10n5W4mrdg/KCcxLT+XSg0cL3v+6uRGNqUPH2BkzKJhdpUrM/RTHlibmQ37b/bA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> From 4c6b4d4cb08aee9559d02a348b9ecf799142c96f Mon Sep 17 00:00:00 2001
>> From: Brendan Jackman <jackmanb@google.com>
>> Date: Wed, 17 Dec 2025 13:26:28 +0000
>> Subject: [PATCH] mm: clarify GFP_ATOMIC/GFP_NOWAIT doc-comment
>> 
>> The current description of contexts where it's invalid to make
>> GFP_ATOMIC and GFP_NOWAIT calls is rather vague.
>> 
>> Replace this with a direct description of the actual contexts of concern
>> and refer to the RT docs where this is explained more discursively.
>> 
>> While rejigging this prose, also move the documentation of GFP_NOWAIT to
>> the GFP_NOWAIT section.
>
> There doesn't seem to be any move?

This is referring to [0] and [1].

>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>> index 3de43b12209ee..07a378542caf2 100644
>> --- a/include/linux/gfp_types.h
>> +++ b/include/linux/gfp_types.h
>> @@ -309,8 +309,10 @@ enum {
>>   *
>>   * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
>>   * watermark is applied to allow access to "atomic reserves".
>> - * The current implementation doesn't support NMI and few other strict
>> - * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
[0]                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^
>> + * The current implementation doesn't support NMI, nor contexts that disable
>> + * preemption under PREEMPT_RT. This includes raw_spin_lock() and plain
>> + * preempt_disable() - see Documentation/core-api/real-time/differences.rst for
>> + * more info.
>
> Can we reference the "Memory allocation" section directly?

Yeah good point. I will send this as a standalone [PATCH] mail tomorrow.

>>   *
>>   * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
>>   * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
>> @@ -321,6 +323,7 @@ enum {
>>   * %GFP_NOWAIT is for kernel allocations that should not stall for direct
>>   * reclaim, start physical IO or use any filesystem callback.  It is very
>>   * likely to fail to allocate memory, even for very small allocations.
>> + * The same restrictions on calling contexts apply as for %GFP_ATOMIC.
[1]     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


