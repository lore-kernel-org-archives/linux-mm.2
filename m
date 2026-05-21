Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 280FCCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 05:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8BC6B0088; Thu, 21 May 2026 01:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289D16B008A; Thu, 21 May 2026 01:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F9E6B008C; Thu, 21 May 2026 01:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08A786B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:04:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8021A160FCE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:04:10 +0000 (UTC)
X-FDA: 84790235460.15.32A3E69
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 432D540002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:04:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JULoXvF9;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779339848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udD7mWlkd64piA/1uV3JoogXR6FhB2/z0dczFUqXvp4=;
	b=2EBhPycwUgBO0UiUP+qUOBLStcnINSJkiycLEcnFeu87vkh5CzgrplIEtdsvVQIp2WvkP1
	22rn/W3/P4GVl8TQClulFNaXPyOX0G3Bi/PNbCzeSO9dtlkaqD+oPqYLVKDkvoDk8+23g6
	pmqcGK/fY5FnQ821hQpfm2cTo4/otC4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JULoXvF9;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779339848; a=rsa-sha256;
	cv=none;
	b=e77VQdkUnNIx2IuO1D/CEUBNhKQtBJVUJ3Jh4BFJ5K2OCPA5ei7iJgOaZMko0lyQD45r8a
	n0U67aKXyeoIIAY+i3OA5PeL0SQtn+4Pu9duUh8uEc9f8LWsDV27r853vWZcukuPR9IhMf
	kUkZglwHKnOiPQFrwSPG5KyeD+a2SUA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779339843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=udD7mWlkd64piA/1uV3JoogXR6FhB2/z0dczFUqXvp4=;
	b=JULoXvF9rBrdxisl033+Bdt9vswxhIhpTxZDs+FlAdkNcEg3HR7Hnujny9LdUKuej4hxLJ
	iCfAds7VXyCqv+FOPxCKSMUoBQwrw59yeCxPcn5xYNCHYWFqJD7LIMlHe1JAMI794A1wmX
	BdOajcXyff9GzuTfn9ACSh0PO5UhgKo=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 6/8] mm/bootmem_info: stop marking mem_section_usage as MIX_SECTION_INFO
Date: Thu, 21 May 2026 13:03:39 +0800
Message-Id: <20260521050339.65872-1-lance.yang@linux.dev>
In-Reply-To: <20260511-bootmem_info_prep-v1-6-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-6-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4ag8dmwb1hys5a86btnunatxotsr3reo
X-Rspamd-Queue-Id: 432D540002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779339847-277473
X-HE-Meta: U2FsdGVkX19rNuVDI/rJA+m7o5hH6MGpzOFxuHk5wB0z0WxZz06zDasTwwMIaw20P1OaRfljtlcYccUU8lcxe8ru59NdKXm6zSufsXUyS7z0lipGr+FvKQuwcVzlAOjyhxxXc4P7b2rYsRHpHICu+9tbyolCF+keD8gCCePsK9p/fMF41nw/fZnzQKKxDaB3o0T0QikhtUuI08UScVjl8gcZVYLq8jPFF9rZv9dUQsdJ0p9kBD1gCadvcUFfl1T160Gq3ZESi/DC1zBUids9RIzFR6SV7J5O5EZPNUOJpcv0HQo5cODmgmKibreP8Luof+/lmsfVKvt013WcvXXX8Crssp53sJ2eee3hqMEDVFKk48bjTHMlzz5JpIMh9ZQhqrv+6rjbMfugSQzKyu2qY9iRHReGsIOMssY4e/Aq/lI8RFCjzMIwHOe6n4q+DpASuSprATtfGnOPmF8n70bS5BlqpGKnKKLVQZhhKtdH3HJbDQB0yfbExCfp+jqvtzkbz2tuinag1FgA7qtAbn+/nBvgTUPCW2cbOHjURFjBDZz/TSviIpeIm0FsVa6D9lmWu/rLlaoNg7LXON1DHA+7HBkSE7wvxjdYk8uqwjOurC69kbP6c0OAFWdINzLjuZiM45ZIseCLSK8wMjlsIp3Mwj8mW9jlwicrnUCe50M/bXkfBqy//i/vheL0iVhW6/LBJDiYv+7V8RfDdzRdK/X6hI4HyTVLloYRdwresPJ6y6wuukdI0ttLXK4edJP2NFkpYreTsBYw//JNtHzUbCxcaYwtcbOZqqXK7RrNpzXO2fvzvBC0B0PjNv2ZAtXNqBVZnXxtHfzrmsFAcx2jpr7ydf/QmhA28h90TuSNlr/zr5838BXR9q5Z7jodkiSR/5im2MCiUhBJXRt8pt+bR9ulGnVHQIO5dBOJWgJ1yPczy0Y0dTkD0H856R2ZB+75R6vsHT70xj+pCZM40wiM7Vi
 czipk9v/
 XoREOTvxh8JBeiB+fSIfGfCMF76B7dU+hk0KItatoEoysHjj7gj8WVse2G1in/xRljNTRQqXByhdSkXKHkVzA4FpZnH5rIGZWHzEYBw1t2WFWCO/N9SaT2FHmLalDZdrII6ii2z0MvPTw1V1kR1LQihV5phjAZBfOPhXIp93w9/oq+FPlaPSwQJHuIdLJL9NPLB3S2CPbDk98saHm5kYPLhG+BKpHgFs6QLqk1fdMQSSRMWytRXJ7olpPR2pSWRDCG9dQb8o2ujnRNzOYv0MeVnTBaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, May 11, 2026 at 04:05:34PM +0200, David Hildenbrand (Arm) wrote:
>We never free the ms->usage data for boot memory sections (see
>section_deactivate()). And to identify whether ms->usage was allocated
>from memblock, we simply identify it by looking at PG_reserved.

Yep, PageReserved() is already enough to tell that case apart :)

>Consequently, there is no need to mark ms->usage as MIX_SECTION_INFO.
>Let's just stop doing that.

Right, MIX_SECTION_INFO doesn't add much here. For ms->usage, removal
code doesn't use MIX_SECTION_INFO at all :)

>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

LGTM, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

