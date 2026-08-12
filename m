Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DB6C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7BC66B0102; Wed, 12 Aug 2026 08:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5266B0104; Wed, 12 Aug 2026 08:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D3C6B0105; Wed, 12 Aug 2026 08:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 745196B0102
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:11:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1665D1C0FBD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:11:06 +0000 (UTC)
X-FDA: 85092501732.22.8AE4A18
Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	by imf16.hostedemail.com (Postfix) with ESMTP id D9364180003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:11:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=Z0GoJT6o;
	spf=pass (imf16.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786536664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mfqQYpJG4Z8J2l9JjdOqW1TWeahmTbum2iA6ehX2+g=;
	b=fMteOlUj677Pt/b2hWf3nuMISsIygknlBqrhfQ6+qu4rY7aYm4u3loC3wuqh9Y1lzyXNC7
	xhyD5VQJ/SsGR3n4gQJWn15jU4xnq9X4AHV0agFTPxZdBtg0cnzWwaK+GjT0BRuGQUKSLy
	wipQcRa51luHzgF6Ht8l2h3upt7ysJw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=Z0GoJT6o;
	spf=pass (imf16.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786536664;
	b=EfL1LL+iNm7SLLgl+kF/5hTWPknbxVdorbH10Zx5MtTrKVF2ILIVf2VlRu376fen6VAOVW
	dEvHypiXuZ0RdreYNigclpdO6Iln4KYYyElUI9w3W3wjTWOs80MAHiNnOprUF1EQsM/kpt
	35w6Q1vUYAhkC/9OJx6qk2bvAVuyO6M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786536660;
	bh=8mfqQYpJG4Z8J2l9JjdOqW1TWeahmTbum2iA6ehX2+g=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Z0GoJT6oZ2E7z/tP/DLMI9/1CiRr+s7B5Brw9oseXNCOERPWQYVvmqIZHeWudRXwM
	 XsvorshiurXHZeIbeTL8CJqvCfP51lTXWY46QVWJiX0Z6NfhS/R5kKR1V7DqgYNZDR
	 mHNZV+tP+WHCnEA5yagYxH7As2SvnkP7tJmeddzU=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4hKnQD4gJ4z10yH;
	Wed, 12 Aug 2026 12:11:00 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4hKnQD1X4Tz10yG;
	Wed, 12 Aug 2026 12:11:00 +0000 (UTC)
Date: Wed, 12 Aug 2026 13:11:00 +0100
From: Bradley Morgan <include@grrlz.net>
To: Breno Leitao <leitao@debian.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com,
 riel@surriel.com, kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6_0/2=5D_kexec=3A_keep_the_ne?=
 =?US-ASCII?Q?xt_kernel_off_hardware-poisoned_pages?=
In-Reply-To: <anxhWTKwMvkVHBPs@gmail.com>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org> <6D17A62B-3124-492F-9593-63F857DD475F@grrlz.net> <anxhWTKwMvkVHBPs@gmail.com>
Message-ID: <960FB52E-6229-42DA-B01C-B61878E75D2E@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9364180003
X-Stat-Signature: m7saqwm33iwbiwom5bddb7qri99qsc14
X-Rspam-User: 
X-HE-Tag: 1786536663-613413
X-HE-Meta: U2FsdGVkX1+qLUP4diigCUhcjdHJvFTdSvfLuXauuGDR9cbIZsudTBB5TO0t+9GyeQ4/WYJNKVtZ2V3fG9dMVZwpJX/EXJQFnr75iLKdBJ1XQFnVYh3+gWkHuO09y8XtxdMi6r7U9fgOocHkVf4FzLd7fcosjYmO3rsLqYhv4WgGLq6tFvt8OeXjUKNa60wk1NQ0dwWeVqAezGTOAJa4Tv6IrzbFKK6wlOJIjqK/iDtmRVDT4uxescAZX3ZAuEvSFO+W9HJ8Fa93h2G2qi3bmgCuy5eDgav3cvet5YnU1ytcNlVGyfpW5y7yOIKV4Zp5qmRIv1HuI6QZAHroqNMF2oextXb8NyfZhl59KyGJA7wWE134s4Za96dr5NrvdaBkq8fvQ7quidbFHfbdkUK6dyWZXtt7xtE1VDZO+2zphk1QCGvJhGHPJetCvkfXsimN7cSmInn4+4/fCGl5Aq7EtUrMX+1JM5gjU7XuWmdOs854/n9rIXiz04OS40lOV3M4s9UVhHoQdeMS93XyCBIe5ARWIg18iBf/psUOsS0lvl4BSewfJaDpc9dsoFTw/JDsllFshOHUJl/73xKZZCJ89OOnpa2lHHFfIvbHHGf6Rku95jWeAzM1xnHvp5jLDTGfIKTdBVSyKWVf9z9NJ8I/86hTV6A2OmZP8IRgSfTd5CnfMe7L+3ofOLWd5euAlmC2G0hhjUOdcd0/xZFogDwLPOOs11/j7KW2N8cseBH6BuFdPU9iIjrnGTN2fvAXlLCkITJ0+rtnJggRClQSny374GPpujlx4jFXs9jC3AUkAeVObE9E2igweyZcbv+SIXzQ+9ywGqO9Rv/vg0xBVTGSmoKUMidpswHut80jdQ4ALndEtIKEMeiweO8GQCldwQDGg7KWMLj4ByGBzaJZI/fmqejBgtW/336kYNS6w8b3QncTg/0Js/0jR+etKN42xtiOvrfH+tkEa+mOF42a8jt
 51ECmLMG
 mf58EPjtWl8PWZ60zua5pYqcPGMnwAbct7PSwLjkUiPR9bVj4WfCIW2ZqJWJxLFvx/JAQ7XSVrVKRO06sNkNdLdXwgY8OyPIcr2D0XdNVfpktj4UvAymgbZ+TLhtq1UDp2yKJVifJ7Ro9FNVjAFi1a+2stuXQhjfOUuh31oOSnjwyqOo4F8bj5a2wiZeiUCrr9Nf8nda9BRHrw1sI0sOSG28jX2bE2jv7w6nomQ39dGNiYBvnq8pqNG9YXULMw3gt7o5ZG4ZB/bsqrWDsS8UZNGGx093dHp4PD72dDJMt8xLHhxnOx4k5/pmbnve/TBJ6aPRtjQppne86qBEYBeGffU5Bkv8M0cAIP+LYGlAd4yCs0zoc6M5bp5M2OW2WoS7L8MTWqK07WrB5pu5f2ZAYcxqMiSjLaIMoDQh+RKfPLE8Qkt3WPUELQLKc2Y7z4hGMz/uUZfSQctykNptRvfpGf3lwv+XMA0EIOG4UFT2TaJBimJ6e/wZ3wPdkAFJ88G5TbqcqFWgFedFyCcrNDyT+XwjQmrfmuhFhg5sZD0dbEhvLfcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 August 2026 13:07:49 BST, Breno Leitao <leitao@debian.org> wrote:
>Hello Bradley,
>
>On Wed, Aug 12, 2026 at 12:36:59PM +0100, Bradley Morgan wrote:
>> On 12 August 2026 12:31:50 BST, Breno Leitao <leitao@debian.org> wrote:
>> >Changes in v6:
>> >- Split the pre-existing top-down underflow out into its own patch, and
>> >  drop the "if (poison < kbuf->memsz)" guard from the hwpoison hunk now
>> >  that the loop bail-out covers it. (Mike Rapoport, Sashiko)
>
><snip>
>
>> >- Link to v5:
>https://patch.msgid.link/20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org
>> 
>> This is a two patch series with one patch, why?
>
>This is a patch series with _two_ patches, isn't it?
>
>	[PATCH v6 1/2] kexec_file: stop the top-down search before it underflows
>	[PATCH v6 2/2] kexec: keep the next kernel off hardware-poisoned pages
>
>If you asking why it was split, we decided to split the fix into
>a separate patch, and keep the "feature" in separate patch. The
>discussion happened in
>

I'm only CCed in 2/2 :(


>https://lore.kernel.org/all/anskyrEVUlnTVEgF@kernel.org/
>

Thanks!

