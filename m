Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD13CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 12:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9A06B0005; Sun, 17 May 2026 08:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A8C6B0088; Sun, 17 May 2026 08:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780EA6B0092; Sun, 17 May 2026 08:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 653206B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:42:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E051C2084
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:42:29 +0000 (UTC)
X-FDA: 84776875218.08.1708010
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2C263A000B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:42:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Q6m8bZx/";
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779021747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BncCr1BHhklgYgkp0UUalpttn/IeZ5vtGECGgen9ulE=;
	b=d2H4vHv7ONhuFKKrrZRrB73EqzU/HP/i89rrWHY4GLFzSEwR/66jooLTrBLTD2mbwtZCWH
	UGnKsbNlOnswK492BGvCRIw48q+l5qg5bz4NYoTCDNlp3ZALzZrUCCwMPoi/t0usLggoAJ
	69hXz4Vi/DETOIPIXht4cuXqQxe61O0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Q6m8bZx/";
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779021747; a=rsa-sha256;
	cv=none;
	b=ypLIKn4XJEH3xTzWb1ZWSadNO0Snuvjp5DYac545EE9JNMA0Kmsce/EHnrHqmMt0M41cy7
	7FlFUfsy4f9Yqfsgk5vzyeCIBRupfCBP8S+cWr0NANas7/iBFAhtVCL2Kwl+1xHiSoUxv2
	eaOvpaartuiistK3seFe0wHOugLPxwY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779021744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BncCr1BHhklgYgkp0UUalpttn/IeZ5vtGECGgen9ulE=;
	b=Q6m8bZx/XTLt3n5y/1PdEf1Rb6GWUwbzj3M9g0nhVgZHHlHwlpCWFiz7GX+KdTF/TN7DVl
	yHsGa6rl40uKnIsO5h6PqFbdpoC8tlGcHy702XAJCkE7g+knlE3cUZwAZp9k/liQm739fh
	15BJdEMkvARdskMzkt4pRhcSv52l76s=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com,
	david@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v4 2/9] mm: introduce pgtable_has_pmd_leaves()
Date: Sun, 17 May 2026 20:41:49 +0800
Message-Id: <20260517124149.90033-1-lance.yang@linux.dev>
In-Reply-To: <1f4bccaf-6472-4e4c-92d0-28ac05f6f838@redhat.com>
References: <1f4bccaf-6472-4e4c-92d0-28ac05f6f838@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C263A000B
X-Rspam-User: 
X-Stat-Signature: 8fcn3c6wcqrknooou65d1atgs31pb1ce
X-HE-Tag: 1779021746-519843
X-HE-Meta: U2FsdGVkX1846wCGIHWsVps7fPDvF6WJEdC2Qu2r7RmaeNK9Mp8FlTZJ49Ux0zNr/XUZoQytFxIVv/DOo3U493A181B+4sGZpc/gSAviY4FEbTvgvWlLcxd4C9fWGF36OaO7nfGWn8ZvPt1mC93r8HFnW2p2/cFWMnfx8f2OiCFZRrI/GpX5sMIfKRFl3INmiMcXfUcN5g+sX6ttCpDaMtii6RkoYCI0Rt8qNoLIEHtNrfM1C7OHljmbVsbPor70ruKBICGx0g5gWj4BD50aLEoDNjTkOTTOPc2x2N3PPrjKlkiSTuDLxy3Kokb2/LIvycpAOlI4xqi6cG8sfG7LVb2FUxlozWB3U2cQu9/M6BANzzqCF2QFzeB1Uc8TfsPpXu24voSH/4mslwUCX2C/M4czk1vzGAUNOjmHdZTumopjBLfWQOrmOGgJr7MMAtGjgR9fBCTVDFXcE+AvBoxyPbKLlw/QOzpKS9XOd+D3CRtMS4ZKr/prnySSRxXi0vuCHP3WDQimkfy1f1PqD3UHOtGoOA75g2anwbesQ/9/0vTWO5B9zZVGztal0d4DT2BtNWQuASsQ1djqwfAZN0VcCB6j7vzsUfuuvO0djjBFuiQMvSElgF3jzib1bhxyjkpH6O1mcZMBtvRNFda5v8Lmc892ntMzSOhxqHa3KEnXwUROwqWuh/eKUwhsQLjsSahTrhzhb5Z/APLfxAkjGGe63qajggQX2fVqdQhhyz8hSCh9oyODh8W0MM6Qy2HkCEjeN6JM3Oye/9FLsrgt3IVg/cJQY8MjdUgavuPhO4R1svCiM8BY+PD5mR2cAEUYSEvML/YOiiIzZIZNaSHkk9fggZAKRqX5KXHbarcsgg6c1a6SE3HsSKBlCLoNsbmnT07XY0mj5t8FJilD8UOeExZpWOY4KB9cnn1YxrkjoEXPjVOeSw/4yWlB1ElAdj/IGODg9Qs2/eR45G3HFoaLodA
 ICLIIDPF
 VvwHeWMkD78yHgyXMkf3F2Usxnev70RvLakLP5I4BoLu9NSYXL2p70eYCXTWEbN0UNghunQX/3mZDUsBRnSLV8PtlrxGOPhV/j+//spk8LOHR8mXqeW4K03bP4CPd6SLB4PoJPelQUpzZnY3Uyd3O4SQXHElxKhe3/F4cOhoV9nC8nw+uUiBUnhsqm+ul5spBV1qiOAh3oh60Cmz+Y5p5enphldWQ9YRxh5RjCovzb8Y/z3IvAKCZLqvuPcf0c5acTc50
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 13, 2026 at 10:18:48PM -0400, Luiz Capitulino wrote:
>On 2026-05-13 11:36, David Hildenbrand (Arm) wrote:
>> On 5/1/26 21:18, Luiz Capitulino wrote:
>>> Currently, we have two helpers that check for PMD-sized pages but have
>>> different names and slightly different semantics:
>>>
>>> - has_transparent_hugepage(): the name suggests it checks if THP is
>>>    enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>>>    implements this helper, it actually checks if the CPU supports
>>>    PMD-sized pages
>>>
>>> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>>>    by the hardware, but it just returns a cached value acquired with
>>>    has_transparent_hugepage(). This helper is used in fast paths
>>>
>>> This commit introduces a new helper called pgtable_has_pmd_leaves()
>>> which is intended to replace both has_transparent_hugepage() and
>>> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>>> it returns true if the CPU supports PMD-sized pages and false otherwise.
>>> It always returns a cached value, so it can be used in fast paths.
>> 
>> Oh, one more thing: what will be the semantics regarding
>> CONFIG_TRANSPARENT_HUGEPAGE?
>> 
>> I assume it will only return true if CONFIG_TRANSPARENT_HUGEPAGE is enabled,
>> correct?
>> 
>> That is, for example, relevant for patch #2.
>> 
>> We could later change these semantics, but for now we should be very clear about
>> what it means.
>
>I intended to decouple the API from CONFIG_TRANSPARENT_HUGEPAGE,so my
>goal was to return true as long as PMD-sized pages are supported[*]. If
>arch_has_pmd_leaves() is not implemented by the arch, we default to
>CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE, not CONFIG_TRANSPARENT_HUGEPAGE.

After patch #07, what still confuses me a bit is that the arch hoooks for
arch_has_pmd_leaves() still seems to be guarded by
CONFIG_TRANSPARENT_HUGEPAGE, not CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE ..

For example, x86 only define arch_has_pmd_leaves() when
CONFIG_TRANSPARENT_HUGEPAGE=y, Same for s390 and mips, unless I missed
something.

So is the intended meaning:

"this arch can support PMD leaves"

or

"this CPU actually supports PMD leaves"

?

If it's the second one, shouldn't the arch_has_pmd_leaves hooks move
out of the CONFIG_TRANSPARENT_HUGEPAGE guards as well?

>Now, do you mean to say that the API should still be tied to
>CONFIG_TRANSPARENT_HUGEPAGE? If yes, why?
>
>  * Sashiko found out that the current arch_has_pmd_leaves()
>    implementation for x86 (and possibly the other archs) is guarded by
>    CONFIG_TRANSPARENT_HUGEPAGE, so we may return true without the
>    hardware check. But that's a bug

Not sure whether that bug can actually happen ...

But decoupling them looks cleaner to me :)

CONFIG_TRANSPARENT_HUGEPAGE controls whether THP code is built, while
arch_has_pmd_leaves() is about PMD-leaf capability.

Cheers, Lance

