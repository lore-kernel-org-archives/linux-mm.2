Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652DDD41D68
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 16:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507616B0005; Thu, 11 Dec 2025 11:24:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8B56B0007; Thu, 11 Dec 2025 11:24:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6866B0008; Thu, 11 Dec 2025 11:24:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 232496B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:24:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C43391601F2
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 16:24:29 +0000 (UTC)
X-FDA: 84207713058.03.E6A245B
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id BE9764001C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 16:24:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IDHiNDyy;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765470267; a=rsa-sha256;
	cv=none;
	b=mNs7dLiWGnXlM87USK8yqcFYGn6wKY5rQy2Xro8Pa14qffjCBBv4BfVlh7VkiiUVGd9p22
	vQek87/UKkTl3y47V/Efk4NAmdW7ZMRkw52Ocf4jxuYWXwKIddbZby0jPUE/YFD+4Mz48P
	/9fzSHr2y3EBtLGbrfLLVTWPYdgOrAI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IDHiNDyy;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765470267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSLed+mBFt43RsbZF3UjGORuOaaX7SHPDtT6COozKyQ=;
	b=PmilkRdChkdAzCwtAHTKahlDeJf0f4vUAkzdH9n7AuWl0psCnob2RYDggIg5lavR0LCjly
	im+PPQMGBRNMzNyrPGzsFbU5Tq8luthvAV1WN/U6zxuCpdd4sa+GgZ3ZCtSzmS7lkLTFb7
	rJwb0/PMlEDU0Tn8CtztMW/3TwLbTuA=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5959d9a8eceso344342e87.3
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765470266; x=1766075066; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gSLed+mBFt43RsbZF3UjGORuOaaX7SHPDtT6COozKyQ=;
        b=IDHiNDyyze1ANr8NCae6O8LO0x2XzoFj8IbyXPbvsKsa31k8u6sqcszbODufUDlK87
         Gq9jYdo/J6J6/MKDYpfd3kq4ocnlCaAvVhSNDbkbZkoWL9aiP7OOXi1KBPRTQkXEAMeC
         F+DTij4kLWRmFAcboidxt55j0sWV/Aa/1qd89I0vKfApL16CVO3JJbJ6QMjWgpVA37VP
         iSDJDvClj5scskPcKL/3hdxUZ0YcsTD6FHZQhg5BvkfKJ8e4RZI0FCUp+T6cw6Xtx3Iw
         8N/H5bYTmmZjL+JJPShpW12sCkIqLKEAgZ+YVvhvpjoA68vwJth8Sxnn8WaEfoT/q2Ue
         sE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765470266; x=1766075066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gSLed+mBFt43RsbZF3UjGORuOaaX7SHPDtT6COozKyQ=;
        b=puSYlm97xmJfgMq2GNYgM8ah+8dQvW4s3yawpm/OC7HukyouSUKiZilQxcX4gHn3kB
         v1eGV/dpk7DNQUbvwGZbygXAD5ROnyzaXmT1nGRYMv1Wi8Yos4DKSLvahCk8yoQbZ4L+
         WSFs4wZOGz5tODmDRV64D5UmEZosdFEEW5eCmCmc78MD19yCdz4z1vElN7f57CAvuWX3
         lsR+T1NUVQxB2zDDfdbOrkYgn5NlV3EHqT0kBm94Wp5Se0nzvXZ8z/UnKVpz4i/U6uar
         aLZGSRXTf843rGzJXD6qafZnjyu1HnY+Qu+EaQ3hWADiu9mQ2n1PzbaRx7wk0qzaM15E
         9M6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUiMavmBx4e7Ug6Y28SZtkhZHreoQikjmpRDe+qRu/L2NlGcZp5PEqAcx+KJC16VLZ1f2JhOtX6AA==@kvack.org
X-Gm-Message-State: AOJu0YwSVI0AnxIR7GVIn68UJdgd3pQltsAMvgsqOlkdXhlaqELcAb9O
	FSDvBMhYoBm8tzOILRmlokqJ3MCWp8yiVE2ZbW9tYN0JUKaNrfy6YUrWWNdjHTsh
X-Gm-Gg: AY/fxX7Y5Ctc5Hio0A4pO6kZM5GqY2G6aeRiyVi21hL4Eiesyc0KVrOP/PonbIqBDuT
	IN6bIDoRQE1xZs/jy+dGGToe5odC03OSYtADhtQo1nPj4PGx0gxbYdw2NoC0YG3u6YUhx2CK9NG
	FWOmNcbkn6lGdVpKUqfL6jDH/QPQVnRxsVR48aXxdlAdLQNTSnVn+dtKTCn5qRsIjY29KsR3+Ge
	0Hc9t4OOPV23z2OSk1auQv+kabOweJlBNPuXqhvHd8Jj+VhBhJJJnjcTMMJSuo4NZG/KsdWhMv9
	28/lyMWRazi5LDvcy6HJw2NrKZvfcb3XpiAd3XnTZIoYsV4E+9Ac+RO2RlNh5Z+by8ScvltvxGH
	Y3oR9Up5a+nVaTpbctvzNOLtUrWdKTQwhEvh0tV2U5kmJ1l2FiK/9
X-Google-Smtp-Source: AGHT+IE+/fEVCaoWW4SPnMjiZebsBFIHj+HP3TwFpHuXc8z+Tr0SNOl8KA+vkaUer4vYgV9FqFmSpQ==
X-Received: by 2002:a05:6512:23a9:b0:595:7d0c:99dc with SMTP id 2adb3069b0e04-598ee4d5a87mr2628440e87.11.1765470265674;
        Thu, 11 Dec 2025 08:24:25 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-598f2f45bbbsm978481e87.45.2025.12.11.08.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 08:24:24 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 11 Dec 2025 17:24:23 +0100
To: Dev Jain <dev.jain@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aTrwN_C0JI7BuKeV@milan>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
 <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com>
 <aTn0FZig5a_DpTJg@fedora>
 <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com>
 <aTrlwpeQyvM9_FX-@milan>
 <f5bc0a98-3ab2-4dad-bf05-917528744ef7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5bc0a98-3ab2-4dad-bf05-917528744ef7@arm.com>
X-Rspamd-Queue-Id: BE9764001C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: a3ogi77rm8a5gamh846gtwkqeqim6f94
X-HE-Tag: 1765470267-832934
X-HE-Meta: U2FsdGVkX1/XMqPtZBWPteH5QMflssKOsezNyc7ZXMDOby/yGLIGMxh1UK5c5EDTyNTd4PI0sDPLsuVIlpFQPz+Cjz/YRA/r16wKaWWmgzt3UypTdCrrRJe5pjQ0b/TNxIMxqxpESFlxme7SXR/TsnbGqSuy1wiVWKRbfn5g/pmddqm8nY05ckslLuXkRA0AvlDMsLwk6KliF61oZzxXP0WZKlpPE+CFosBlpAmWLoxCujdPchQXEVuvGLfFOobGBMo5iAvM37VhjeFsvkyxWpsbVancBWVMu3PWRJpKtb3OXLZ/JmjNktBGvKjN0xDcQasIKXK45bWLSKFe9mzTA0ehVycmL+S+Ae9o7GdZXQuY/y5LZL9VdKa4t83eapwQIimQtMPJuDWwse/KMxV4JNqcC2cCcFa8WaYmmY8K0PQKg/NAO6efgP5A3baZJT1Qoow0xrbnZKiOkY3e6EH4Xb55T1FmQ9yKd8b2qdEe36RSH05c5f1h2HQqxTcuKaXQScJPMkCcJONcMRwwkSpB5CLRfW7n60eH3w75Ha2yXM52AGQKTBkJ9hugHnPwdCetvudRQjMTnuPDbf5wgRSRsrF3hKeJyokHCfglV6WD24mQ7NYuYb7bRRiylu6JBJoBLCpgAF6xZdqiYJuDl84wF8vxz9Z1OYH3/4kBYBW+AR8RBe1yZmYDfn+ZQgGE2fEa+flx9QQd8YFFKOIIrlwQJ1dYo0GP5w6PVYc6g0ZcXHopjz2D8dMKb8xoeHzC+PdgYEtpt6beOEbvBdV5vlA0Hn9yoeLz+GcOfOzFofw2l817XQMvrCoVrc9pQKfCltxAi6/PVPaAaiBqfbr2ifcDNHVJQAmqiO5fBhsioKyXuMOSqUPMQ8Z/4FrbbtzRAjo0Fmd42GdeDBKjEjw9kSGgdRSXeErz+2ZFhuK1+wJFP1LpACAl2C4X3NRkK4gOnaB04IBzh87NyudqC8OQY3o
 LyVzpSma
 czDAswQrQA3HKI2rQust5Ke6E8efgXTsPxXpWyZoNpcG1EFHDaKn7H8GGdyJ+FOFsqRQA/b4510Q7NnpSeBTI/Ij4N0KJuHf4mteQR0Mjnk9PP0tcVKnP7eXKn0pmgGfomK4wAMRKQ2cionsTxh+1bmv+jrzQHZy7I0GN5Y/85b9De2dMvMZFWddV34N+WI0Dfc+TI7FW7VkFwkc+G4z8W2svfov5TIoVocifShGZWnxFb8uphJ1WATlkXi2dNk+65QwnYPhKABmI9kf3ul+VYMfMcaqtijLKRAlAbsnCTKJ6EhavChsJozoSYhcO12ZWs+Rw28wSmCXhSv6YOzZ1WK5tbshvohGv7B7xbdpDp8LL+k8OA6D4hNrPee3YZzR/H/0ylYkmOxKn3QolMKXG+O28w/Wpz+a2fwdzrvWEjin/tcySpyk8YwwR//qHfrSbqluNnwrsv/2diTpinCVjEYXCMMLhxG0d0Uc/JTlhCpkL9JI63rK97/AJzqiUqCwFfm9hEgRtSM7rnuUqIixxhoh1zYGdFvgMJOmp46I8X085ns0ZaPsQ6ChiZOSHo0yVMuI3DFqzpmnJpk5uUuSYVkhzc1MaTvPCnqJJxX5BTrAsJKJAYuI7P9/6nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 09:13:28PM +0530, Dev Jain wrote:
> 
> On 11/12/25 9:09 pm, Uladzislau Rezki wrote:
> > On Thu, Dec 11, 2025 at 03:28:56PM +0000, Ryan Roberts wrote:
> > > On 10/12/2025 22:28, Vishal Moola (Oracle) wrote:
> > > > On Wed, Dec 10, 2025 at 01:21:22PM +0000, Ryan Roberts wrote:
> > > > > Hi Vishal,
> > > > > 
> > > > > 
> > > > > On 21/10/2025 20:44, Vishal Moola (Oracle) wrote:
> > > > > > Sometimes, vm_area_alloc_pages() will want many pages from the buddy
> > > > > > allocator. Rather than making requests to the buddy allocator for at
> > > > > > most 100 pages at a time, we can eagerly request large order pages a
> > > > > > smaller number of times.
> > > > > > 
> > > > > > We still split the large order pages down to order-0 as the rest of the
> > > > > > vmalloc code (and some callers) depend on it. We still defer to the bulk
> > > > > > allocator and fallback path in case of order-0 pages or failure.
> > > > > > 
> > > > > > Running 1000 iterations of allocations on a small 4GB system finds:
> > > > > > 
> > > > > > 1000 2mb allocations:
> > > > > > 	[Baseline]			[This patch]
> > > > > > 	real    46.310s			real    0m34.582
> > > > > > 	user    0.001s			user    0.006s
> > > > > > 	sys     46.058s			sys     0m34.365s
> > > > > > 
> > > > > > 10000 200kb allocations:
> > > > > > 	[Baseline]			[This patch]
> > > > > > 	real    56.104s			real    0m43.696
> > > > > > 	user    0.001s			user    0.003s
> > > > > > 	sys     55.375s			sys     0m42.995s
> > > > > I'm seeing some big vmalloc micro benchmark regressions on arm64, for which
> > > > > bisect is pointing to this patch.
> > > > Ulad had similar findings/concerns[1]. Tldr: The numbers you are seeing
> > > > are expected for how the test module is currently written.
> > > Hmm... simplistically, I'd say that either the tests are bad, in which case they
> > > should be deleted, or they are good, in which case we shouldn't ignore the
> > > regressions. Having tests that we learn to ignore is the worst of both worlds.
> > > 
> > Uh.. Tests are for measure vmalloc performance and stressing. They can not be just
> > removed :) In some sense they are synthetic, from the other hand they allow to find
> > problems and bottle-necks + measure perf. You have identified regression with it :)
> > 
> > I think, the problem is in the
> > 
> > +   14.05%     0.11%  [kernel]          [k] remove_vm_area
> > +   11.85%     1.82%  [kernel]          [k] __alloc_frozen_pages_noprof
> > +   10.91%     0.36%  [kernel]          [k] __get_vm_area_node
> > +   10.60%     7.58%  [kernel]          [k] insert_vmap_area
> > +   10.02%     4.67%  [kernel]          [k] get_page_from_freelist
> > 
> > 
> > get_page_from_freelist() call. With a patch it adds 10% of cycles on
> > top whereas without patch i do not see the symbol at all, i.e. pages
> > are obtained really fast from the pcp list, not from the body.
> > 
> > The question is, why high-order pages are not end-up in the pcp-cache?
> > I think it is due to the fact, that we split such pages and freeing them
> > as order-0 one.
> 
> Please take a look at my RFC:
> 
> https://lore.kernel.org/all/20251112110807.69958-1-dev.jain@arm.com/
> 
> You are right, we allocate large folios but then split them up and free
> them as basepages. In patch 2 I have proved (not rigorously) that pcp
> draining is one of the issues.
> 
You sent out RFC 12 of NOV :-/ I have missed those two patches from you,
even though you put me into "to".

Appreciate that you point me on your work. Let me have a look at this.

Could you please resend RFC based on latest code-base?

--
Uladzislau Rezki

