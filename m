Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C948D35144
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61136B0092; Wed,  1 Apr 2026 03:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11876B0093; Wed,  1 Apr 2026 03:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E8A6B0095; Wed,  1 Apr 2026 03:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B84626B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:29:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 546AD13AFEB
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:29:14 +0000 (UTC)
X-FDA: 84609161028.15.508A594
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 85DA3A0008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:29:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LLod/Tfq";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775028552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ms55ZFkes3Y+kx1lD6phlNGkvL5LMzF0B7MCfjTlpfw=;
	b=CY/F+D9ZQ28leW50zEbCzRhAIQ5rl5qd049cfrVdrSgA1fDnTcfDoqMaw1qiMxA08WXxgy
	BDupKQoMx7jopgcaGF3yQqT39vV53KsR4LRjS+GHl6ncNTl80WlRHb2DMkzRyyiOLP+SHU
	dwQTtF5KjkE0Syq/s7iC7gbisjv7SoE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775028552; a=rsa-sha256;
	cv=none;
	b=KciLShb/zOUJvQA0oQBo+HhZ3zOA0esDjohxVLgIBjdEhbCCMHuPqv1LxnBrp0FEAOvwAg
	kHtRs0t9tTqak6KwiTfZdOa91XF6pOWQHe5kd95PrxyzNCTZc4s9f51WQKchcdeQC7QFAr
	zFRxMNBxGSR+PpWIBJMcnYzbkHIxowI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LLod/Tfq";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775028551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ms55ZFkes3Y+kx1lD6phlNGkvL5LMzF0B7MCfjTlpfw=;
	b=LLod/Tfq6gF9cdENfrE1ZqGU4Da6Xhz7DV9NTvyeErzj3L6ugLvZejm00vhy5wKdLy1QNA
	TaKTET2EEoLVvi6mXIrrBUzDIeJ+MjKjiXcZazOj5ESL/smM9CyafXrlSFHkMVGdfzk5Nw
	O+RjpKOcXE0rJbaaJ0nDvZ6a75L0Mj4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <1f8d0cd2-c990-4597-bf47-5a8217acc464@kernel.org>
Date: Wed, 1 Apr 2026 15:28:36 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6B06FA9A-F332-4BE8-B80A-BB869802600F@linux.dev>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
 <7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
 <1742503A-F912-4AB6-AAF6-6CDB06829024@linux.dev>
 <9fddd112-e304-4ce1-b3f0-a4b133fcb281@kernel.org>
 <EAD7BE29-7136-4A20-9CF8-1198EFB8C87D@linux.dev>
 <1f8d0cd2-c990-4597-bf47-5a8217acc464@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 85DA3A0008
X-Stat-Signature: 3gcy4c144xqyfypn4akego459ojyix6o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775028552-632824
X-HE-Meta: U2FsdGVkX1/9fRJs5pA7FcE6s/+bS3fedX06oY2ZDqjuvxlHtk4G6c4TQ6NE/CW6egNrvAFv8EgdbxH+yctzRajCPAOvVh7bMf04HYfX0iXQqY+pQkBs5slQo1/gCOC9/JqgZGQTfTzIY3qdQUYZMeeQCd6WXcseJ1t7Jwc41Ke6IaYmgHE7a5eC0Bm7cvGhXzo8KAjbiP2untXRKbIVs+HHc1MOC6wmMA3wJyWdpcnr7Z5OFg9jhiEoOSEsJ2BUPK5oD2/dCU68aX6SPa66yyRuAfztkReQ8lU00dSXE9Z5Vq6KVkXf/JLoh7L6Feif1QRIIkBzfaS+ptviktTzttOCpSA19Re3LwJ8/c8vkgiFzRKr2Pf9Hzm2w+2H5TP2enlYk37bwUfws4x020B1eTJotm3NnMXSazULHGC+FIALQkl0/tJVDWgsJiZPraFl5KTSn0Q4hm+rQkbSQ9casWWIzTLO9hP3x5SiBC2M1RIIfzYHWmA/d9xaXI8CrTpeft2+sIouwXMGxK7XtiR07mUJl/LPUDgqXNexgGfMxUsbyQ+vdU9dZ2O1Bjnzjv4S7BIGr0nj/bVDlhCV1DPEs+A5LbtTT03ivjMkq/vw5tdCmFXqAoFuc/nToaRRBk5CsHP6Fzi6BU9CVtlrFsnvYYkxzU/0J0O0Exm/gfxk+xZCFy9LCoLLLkhlWWlZhDsWEN/FntsNK60PVBLOwPtO1bQppHUC0SCMAV63xTdcB6OUrVIDbu77WdujKzPQFmPXnbqHeCUEu0cXS2726c1zzmSswAy6JoAVfxMuHH+mcNed7Ux1hBTR5kO/QA3Som5kTOxajEe01RYxCG+CLz8ZI/twZUwr47XENenvDz7kiUCSh27tAj3IbUMQErnFqEj33ITz4FB4E9kQy59L3MmhDpeagNgU285YW8cdRuRavKzAtB6emLb6vA6EoHWLeA6ctrC8IqCBjotpEW7IBGr
 HykaDu8g
 AOpTvWLCaPKkSrKuDDuRYJoE2OOAqoHOkZwOLdCUhmIiLvQBLiwex61Ri/iO/+pgDFCDrOw3Fx7vWeUPZj3wPeqUP6aTW/U/GOnjFNynYlB+AMEGSmwiBb002v0a2XLRxQcCcDTBAObzstpECKtqx0p2m4VjUZF03vR3HRrGiytdnLOQFLka0VJVOF8nNa9PvD8X1Hb3yz8d30wdYK2hsWYN0aoPXGPP+/fmSfqdvpc4oRey80U1+UvVUxH5nGlfHfB79CEF8OL/CI6MSecJW1GfXDrvSBR4Ot0oKYP6z4Z7uPKhyv03sM03yyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 15:26, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/1/26 09:23, Muchun Song wrote:
>>=20
>>=20
>>> On Apr 1, 2026, at 15:08, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>>>=20
>>> On 4/1/26 06:01, Muchun Song wrote:
>>>>=20
>>>>=20
>>>>=20
>>>> Sorry, I misread it earlier =E2=80=94 I thought it was about the =
memory
>>>> section size, but it's actually about the memmap size. Let me =
respond
>>>> again to your question. On the powerpc architecture, when =
PFN_SECTION_SHIFT
>>>> is 6 and PAGE_SHIFT is 18, it does seem that the memmap of a memory
>>>> section would be smaller than a single page.
>>>=20
>>> Right, and I am saying we don't care about that and do not support =
it.
>>>=20
>>> For example, most vmemmap code I am aware of relies on a single =
section
>>> covering full pages.
>>>=20
>>> So I don't think this patch here adds any value, except faking that =
we
>>> might be supporting something we don't?
>>=20
>> Got it.
>>=20
>> My original motivation was simply that when I read this part of the =
code,
>> the comment felt a bit off to me, so I just fixed it casually. But if =
it
>> ends up creating the impression that "we might be supporting =
something
>> we don't," as you said, then I'm fine with dropping this patch.
>=20
> Can you rework your patch to only simplify the comment, and to clarify
> that we always expect a single section to cover full pages?

No problem.

>=20
> --=20
> Cheers,
>=20
> David


