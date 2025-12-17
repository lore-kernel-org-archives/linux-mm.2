Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE38D65C69
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 15:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2856B0005; Wed, 17 Dec 2025 10:48:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FA46B0089; Wed, 17 Dec 2025 10:48:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471866B008A; Wed, 17 Dec 2025 10:48:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36A916B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:48:15 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3502C0C3C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:48:14 +0000 (UTC)
X-FDA: 84229394508.21.E131907
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 413C6120006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:48:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fNMEuX1G;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765986493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7g6szJSc9qKXraE1vzVnFUR39QDkw3X32snO8YJ7Qo=;
	b=1cm8ww/vMr0BYqVHpyg+J1m28Q1EglWNk74tHTNj9Z6bgXtVgUUXG7F6ZtcKlAMgVpEeSr
	bYa10KBLVRZFvMen5xIba/ttkpjBpRoXWCO2rzAC9z0i1TNYUoVOOSSZ42QoRvNhN9lGmm
	x8GXmSQW1piAD6nJNiT4DAxAxH0i+1Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fNMEuX1G;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765986493; a=rsa-sha256;
	cv=none;
	b=kpdCFik96C4vr/FLc5C3FVm/kojedDjLua0m9ukL0B78sdgY0WqFf/SdVM5khz5KpATdgC
	VTmO09kc8UJgrMzr+EnzcJsHzp9rQw5N++g7EyM/q/BHwvq4hGvw3xpn5SMb7wdL6878pC
	lyzpcCnKVEykdgY7rggpJAQpz4lWG/I=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a1388cdac3so20239895ad.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765986492; x=1766591292; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=k7g6szJSc9qKXraE1vzVnFUR39QDkw3X32snO8YJ7Qo=;
        b=fNMEuX1G1hJR535iy1bqjr/W+3c8ur1CkImCKvqymtQZgVUq8pUstnzuZkNWmgdtmJ
         0+zjQmVSZpE0xHc04alyQB0uMMHRYjqbEveBpNIqbrb2oWWg5Lx3r/ad2M/vB2jg7SWY
         /R2kyCyMRD4kSwpOqiKMzTL/SU5obgo+vWm34EthBiAbwQgx5zRp7qhgkJEngfmlJ9KL
         NjoKIfAyu3jnsxlNcZ7SYvgKnnUVg3voT54ynucpnmsKNM5ybqq8wsGv6EEkh9kC0QP/
         PbDXzfKNpNS5hXt+N1InqepL+Sq+HMURkxeMN/jUaYZcgLdJgzKVdJZkagio8F3LYvBo
         0NTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765986492; x=1766591292;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k7g6szJSc9qKXraE1vzVnFUR39QDkw3X32snO8YJ7Qo=;
        b=I1E/tK59Ea/VFcgfRwSaRQXYhWsqIKdhBfk8faX5xKT9ztSPoAKUWYtRyHBmWFImJl
         MdMirhgY89X6NlrKLvg6FP4YXLMN8zDykaIKn7gra6VnTRiffpkXYIwitpxiPjSuuaEg
         tHxWDSxvDgaqg+tGHo2rJWyJ/AJ+/6u1qVyw5cogogGqhXTaBSYamMeq0GZaI+1AlVlz
         j92mfyY44KNxmXpSaBUmu9SYrHmayKo07T+lvnzxKzWs3/AQWZq5Rbh4rdBb+X/fuBP2
         AkfD2yyiDNLG7T0kCRMSDfm2OudNvABvWFJo2cjmZuzubyt1FaxzfHxv3xSfSUGS7aHn
         7HQg==
X-Gm-Message-State: AOJu0YwSF87v4l8IfImem299um1YVNj+Mvz5O+pXQbeVGeIyfRaj8wFK
	EZuZvky2r/ceAWwGBaQunOnryjrbGLw53jl5oM+yEYYOSa4a2La7MJGh
X-Gm-Gg: AY/fxX5pnszr/QPxo8rZu25OEYXWhjriN//k5Y4iENhQXYMBAOQHgCIQbJnmwXeXauP
	71C6c0mSYsNF/5zxN18Pj/hL125BVmuLxBwNalKC5WngCc9dt+BXekW9mu41tIGySCo7HfpdbdB
	YRLAChG55EsPXHCJe9qgdIj4PQbBNBTv4kSjEGeLcz6yvksAqS/28Snux40fxvHkxcP8/9DLjSa
	COtHmwEbmddh7qhfiKEgPAq55oxS89n7/3Pvo914fqP0fGK/nvrRUAk9lF6ebU3tZXcXrZWP8hZ
	0nHEB0zL4ftGYIwFwmH1GYZO0BO5s5WC+pbPusB8cMyc08NgA6Be9mRoHBiNB2TCYuCRJoZXtQS
	6h4r6MR32PRdUtYIa+tyrX7Eee+IkioyE8Cz8RcZmtpnPEGYBQc6qEANMZbiNkcWAGwZXDD1BVo
	5sC465+poS75bWcjbN
X-Google-Smtp-Source: AGHT+IGzrC8xHoSohluxl3TB8gicGFdkGjx48ZJyAE+fsjdi1rZJJgtl3YetY/wOPW+z2c4mkNcmfA==
X-Received: by 2002:a17:902:cf03:b0:2a0:bb05:df4f with SMTP id d9443c01a7336-2a0bb05e314mr123346515ad.44.1765986491997;
        Wed, 17 Dec 2025 07:48:11 -0800 (PST)
Received: from dw-tp ([171.76.225.126])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016ef4sm207003795ad.56.2025.12.17.07.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 07:48:11 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Subject: Re: [PATCH v6 14/14] mm: Add basic tests for lazy_mmu
In-Reply-To: <ca0da7fd-245c-4d52-8f4d-f8fce4717494@arm.com>
Date: Wed, 17 Dec 2025 21:16:14 +0530
Message-ID: <87a4zhkt6h.ritesh.list@gmail.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com> <20251215150323.2218608-15-kevin.brodsky@arm.com> <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org> <f9550d22-8810-4145-aaa8-48961f6ea35e@arm.com> <ca0da7fd-245c-4d52-8f4d-f8fce4717494@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: owr5566bnp77audjwfbxc7feqj4bfxdp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 413C6120006
X-HE-Tag: 1765986493-990213
X-HE-Meta: U2FsdGVkX1/jidC33VUnNz+pXOcoPD+4WbX1bGFx31fwqz4+/uJyp93DJ+7jJolFuBbAM6bQS/JwyT/mj20P5TqTimR0seULoP6yH3oW/b0vUK6N8eQBwzb+5OeGn3MA+i6BBx7rNMxL2sH+FJb3EyhS3alAqwBKtTf7wLpAZF3wgd4MDpHWMgmjPfjKPzvYiTHqEBX6vvtx8hL8pinYnMBZNhPdyX7VV3zEDtOC+t6SLpyRMufibYUN0cE3nL6P26/4S3rmOI+7zcUJo/Iz3B01iihBapi1xm98DgGXHrbje1IYeWF22hWR8n4nm6j4PNlrgjkT/XZQzldW8c+I7qI1S6H1tRC9EReWBiIOgzCJirVcEErHhmSlP0xQPdoVr55YFrjBCXkRxnoCypwPQficnuRJ/CT5l2bFxXKRYJ3Yh9KMn0JbnWhE2DMIybdA4blY6b6emqB8CZxxKW55fwadMr55A2BGp61kw2CaByqia3v68VeqY/HDJGAA+AqpeTgdG5uV6vRrSyVsds4KXJBjv64tootxTNu0+yN3p6d3Xc8dwOA0Es79WjOd1mKHW76mInPbS+H17uC/DjXNxe+p4roWwft/ZG7jw/OvKZ2B99axjG4ig1e1JppE3twaf006S0kMmkNTsJCOb0Idn60GGHeEdjawLDkbl3IS71RzyoPgcmuoSMWHSrO1nKyK5FcqExNMXbos9PpKaqKHYyuXyVxwZOGqBX6aAF89RSKZI/mWoVR3w4oRbIGWe2Q69MQO29wsGxe0FZc9PK8bXU8c1Ud9aqwbKA+Iycs8TlKaYUYQkvQius4S2w3RoVJnin+fkjYQRZpWxiZiYJ8vp3DviUnzveEqMs7UbOUHCttMnDeZcOXWxjqaI6SaEQZAK7BOvmk+aEKczDaDas7KI0v0NmJk5OX4zwMMyqKQHsS/KTLCj7vvQ/Q9HbO4BRu3CQN4ckb7mDFW+hkEtip
 ukc7cBC/
 FSmKaOa0cljgvgtA09J8aBjo/bdygSy/7UkIBXyfp9btSPjkgfQbfsgD2yztVyWJNt/12OyvMqFjl7GmHmEK0gRMK67rJXlDh2ps0KYGhBL8njuPJrJ4nkMMkDPIur7rMwyuk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ryan Roberts <ryan.roberts@arm.com> writes:

> On 17/12/2025 09:26, Kevin Brodsky wrote:
>> On 17/12/2025 05:14, Andrew Morton wrote:
>>> On Mon, 15 Dec 2025 15:03:23 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:
>>>
>>>> Add basic KUnit tests for the generic aspects of the lazy MMU mode:
>>>> ensure that it appears active when it should, depending on how
>>>> enable/disable and pause/resume pairs are nested.
>>> I needed this for powerpc allmodconfig;
>>>
>>> --- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-add-basic-tests-for-lazy_mmu-fix
>>> +++ a/arch/powerpc/mm/book3s64/hash_tlb.c
>>> @@ -30,6 +30,7 @@
>>>  #include <trace/events/thp.h>
>>>  
>>>  DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
>>> +EXPORT_SYMBOL_GPL(ppc64_tlb_batch);
>>>  
>>>  /*
>>>   * A linux PTE was changed and the corresponding hash table entry
>>> @@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
>>>  		flush_hash_range(i, local);
>>>  	batch->index = 0;
>>>  }
>>> +EXPORT_SYMBOL_GPL(__flush_tlb_pending);
>>>  
>>>  void hash__tlb_flush(struct mmu_gather *tlb)
>>>  {
>>> _
>> 
>> Oh indeed I hadn't considered that arch_{enter,leave}_lazy_mmu_mode()
>> refer to those symbols on powerpc... Maybe a bit overkill to export
>> those just for a test module, but I'm not sure there's a good
>> alternative. Forcing LAZY_MMU_MODE_KUNIT_TEST=y is ugly as it would also
>> force KUNIT=y. Alternatively we could depend on !PPC, not pretty either.
>
> Does EXPORT_SYMBOL_IF_KUNIT() help?
>

yes, that make sense. Thanks for the suggestion!
I guess we will need a diff like this in that case -


diff --git a/arch/powerpc/mm/book3s64/hash_tlb.c b/arch/powerpc/mm/book3s64/hash_tlb.c
index fbdeb8981ae7..ec2941cec815 100644
--- a/arch/powerpc/mm/book3s64/hash_tlb.c
+++ b/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -25,11 +25,12 @@
 #include <asm/tlb.h>
 #include <asm/bug.h>
 #include <asm/pte-walk.h>
-
+#include <kunit/visibility.h>
 
 #include <trace/events/thp.h>
 
 DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
+EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch);
 
 /*
  * A linux PTE was changed and the corresponding hash table entry
@@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tlb_batch *batch)
                flush_hash_range(i, local);
        batch->index = 0;
 }
+EXPORT_SYMBOL_IF_KUNIT(__flush_tlb_pending);
 
 void hash__tlb_flush(struct mmu_gather *tlb)
 {
diff --git a/mm/tests/lazy_mmu_mode_kunit.c b/mm/tests/lazy_mmu_mode_kunit.c
index 2720eb995714..340d7cda9096 100644
--- a/mm/tests/lazy_mmu_mode_kunit.c
+++ b/mm/tests/lazy_mmu_mode_kunit.c
@@ -69,3 +69,4 @@ kunit_test_suite(lazy_mmu_mode_test_suite);
 
 MODULE_DESCRIPTION("Tests for the lazy MMU mode");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");


-ritesh

