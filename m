Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F19FFA1FFE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 21:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E883E6B0088; Wed, 22 Apr 2026 17:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60096B008A; Wed, 22 Apr 2026 17:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E6D6B008C; Wed, 22 Apr 2026 17:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C99DD6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 17:30:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72DA4C1887
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:30:07 +0000 (UTC)
X-FDA: 84687484854.30.4CAA7D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7CB9E120013
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:30:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=EU0T=CV=linux-m68k.org=gerg@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=EU0T=CV=linux-m68k.org=gerg@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776893405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fEUOqr78lertNttblzfpjXxyrCB+wtYFsJGctvI76EM=;
	b=D4F6hPVCrtXdWOWl7L/GzguOFnCEGnGQbBj2h9Hz13TwRgZHMxrDIbmrobE4CUSdXxVoEY
	6rQ4ZSKm7bNrDjkujurzDRHi7a2/29d3egSImVUD0NGvUZ9pu+i56N/pRItj+g6QZNbYO2
	cxR3P+mqyCoik+1VbUOxCiuWrQqIkes=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=EU0T=CV=linux-m68k.org=gerg@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=EU0T=CV=linux-m68k.org=gerg@kernel.org";
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776893405; a=rsa-sha256;
	cv=none;
	b=UqhX76OBSUuN6IcLbM6u6MBSZFDv+hCgki1ZMzOVER0ftDdsVexWEJE5M6gI8+3v3b92HQ
	2L/PxlSLuMRuY+ANwYolkcWXB4wWxCViOfWEyrPOCUIf1EZFpriwhHKRiRodQ7E+N4lLwh
	VkptAxzbsxvPqaMymZrZYvFUmSP+Q6Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A86BE61868;
	Wed, 22 Apr 2026 21:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88EDC19425;
	Wed, 22 Apr 2026 21:29:57 +0000 (UTC)
Message-ID: <92be54eb-b28c-474d-a107-bdb8c6c69820@linux-m68k.org>
Date: Thu, 23 Apr 2026 07:29:54 +1000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 10/19] mm: remove arch
 vma_alloc_zeroed_movable_folio overrides
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Brendan Jackman <jackmanb@google.com>, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>, Jason Wang <jasowang@redhat.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-s390@vger.kernel.org
References: <cover.1776808209.git.mst@redhat.com>
 <006f9142e591ba8c340c3b354aee76aec5c285b9.1776808210.git.mst@redhat.com>
Content-Language: en-US
From: Greg Ungerer <gerg@linux-m68k.org>
In-Reply-To: <006f9142e591ba8c340c3b354aee76aec5c285b9.1776808210.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CB9E120013
X-Stat-Signature: 8uw31orqkftxes3e61h1knx96h6e6xzc
X-Rspam-User: 
X-HE-Tag: 1776893405-21868
X-HE-Meta: U2FsdGVkX18VMAHPH5RoKn8OmZRfyB03Uh//BTEhMhkoRRLspSaFXVc6rSHDxy6pF2IebtPYJOqm0oz6lJHALlWdzuI7VbtWzd9fuycNihKYZx1CAJONH31YG97lW+YvTtAK4Lyc4ziNxJTzaVmHcnlMxGO3CgUxTl4LR0UJJDXJZUdrssM8PCnQHFSwNfEN5LLyEFUwmTJVYUSFXffGmDJYZwYWkywd0VHI89SltFxeiG7BlOOL5WO+9ZKZljEsP6IDCfCFr5c82diVi7bMj4cqnXRZNr4Dm2LmRg2gpHxtQ078GEfSP7+eZceA9R38yRFpzpGnxGaK6PchoxDf2dNG1o1G8KPzX0kBlBCGkz1GR+c9kJ/56Z32dRJ2g7r8cNlcrUWm5Aj2IDsfolIX80bP+Z18bUwNkF8E5oHwkReWi89qH6pUaCaCyLqZf8KajOjr7q+Szkh9W3fH9JgFuVLINJpg/mUFAIg1N4wwp+2Uo1ecuGhNaB1ue0rYWQkcanFj8/6z4DISTO7HjREbSzpJG1j5uaA7LCusBoYVuJHtOYwW1slkKzs+RzydlLCJ/szvact0HEvi7K+LOutY7tCL9uZZ7d1vecVn4rj+Ho9SwTl4nLe68hvIc3nTVGseRahoCIMXoAt6R0nS8QPvHGf2Z2SoANmgF4aA6Nzersh5b9oRgBCHn5Uyai2qDOoG2HvJR4JScnroaDisnJd8ppLHIimGMgwsCBd6771NmR25kb5d24eRLxz6BPeIQ2Jv7QkE7VgheuKFu05PyEzZZ8McuxNScvK4pxcXDphYJ1Ov2rIny+oGTo8NLda1bnQ5Gr5R5Je4lJ84QcbyjgXU27fAu0L2f92Sw+OK2WsnO0Z71XN45IEfPib5SQKxcjmJzvBqIIHO4Jh4c673Vq+dRl98Abqu6WzYtBDwQdUloRPJAiVDNLfPLqG12psfKziEJ18YwUBNTehnjzTzxUP
 BzoY5gGs
 yqhdVCgZ595tHHT63uFasortwi4POn3nloeWkuZ87ySgWz8rMIA+rC8HuhCEQpANtmPYNZ/AVvSz68tq6JFasKnNiGNUygkWE6xsp+gh0Y48vhkDHzsaEUpYqV3DKuHrJ+1vB3z0Z6Xhrk3G5A6xizmXzEGMIPOP2kH9QW2ZfW6mtz5zaDooxpAvwAw+xBVWUWFk6nDm9gu08azdKiuOSuXiFxJIdbYuZhCRd4gXr/BiKT/61Xf3IIgXKKEDBKrVQP2gyslgAiok4mt+rJUdwjLsVd6EDHRk1niWKTeSAxavHCEMz424AEbqBwxwG7/DNVjALt4/fxHrdUwE4IY4SZywe/lIEfCyJsas5Ix2dak3GBZ+Amjyl9ED1/qMdEV7Mtzu15VoNo7PCDZVjSEIledyRET9lb3cVGkWX28tB+pokU72vufFvvIcF545Kt8gNy+8u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/4/26 08:01, Michael S. Tsirkin wrote:
> Now that the generic vma_alloc_zeroed_movable_folio() uses
> __GFP_ZERO, the arch-specific macros on alpha, m68k, s390, and
> x86 that did the same thing are redundant.  Remove them.
> 
> arm64 is not affected: it has a real function override that
> handles MTE tag zeroing, not just __GFP_ZERO.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   arch/alpha/include/asm/page.h   | 3 ---
>   arch/m68k/include/asm/page_no.h | 3 ---

For arch/m68k/include/asm/page_no.h:

Acked-by: Greg Ungerer <gerg@linux-m68k.org>



