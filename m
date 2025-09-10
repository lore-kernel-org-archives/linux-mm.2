Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDE3FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A33A8E000C; Wed, 10 Sep 2025 18:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B128E0001; Wed, 10 Sep 2025 18:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7D28E000C; Wed, 10 Sep 2025 18:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 084308E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:27:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B17811196E5
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:27:04 +0000 (UTC)
X-FDA: 83874777168.23.58B0D32
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1CF4840006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:27:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=L2Ew3F+n;
	spf=pass (imf04.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757543223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LweZzH20cb93jaL9PP3j3utouLmpAVoAAhdnOHG0pb0=;
	b=YZSYI249wFEdSjfKP6yXsevxRS3UCWGwF7EVh5mOhcUS533MkSmXTg5nHJNANFQDBumAOy
	wu5RxxjZJ3xzV3QweHT/kSYtqAueHv1rMMNAcCzw/OA2GTDmqaEEcJPBnqnRBmDq+QI/v5
	ZitTjzUKm7cLNjXtpxUS6GoBDHPp+gY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757543223; a=rsa-sha256;
	cv=none;
	b=VNxYQk8Zbf5ftrRyLUKdUqUSk2mkiCt54t9JKWDa8K+P0129GuKmbc9wcuCYv03eHwhQqI
	FeTcipx+eJ/4WocGnivYJg9e4EtxGau2tHhHxAkXwZRKMFKmhWocsac26sEi2ostZDk+V4
	y5UVHK6W3BAeq9V/z9ulyVkuiuMFMnY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=L2Ew3F+n;
	spf=pass (imf04.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757543222;
	bh=fVdwobDQw1jpW65ZDu2Zh4lM60UVXjkNtk178nfUy/4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=L2Ew3F+nA+qAWWhH5O9Hx9C+GPBI7PFFXNWugp/gb2dxm/gIDlVW36TgfLLLX9/Fh
	 LlD/MT2rQ0NAHxoV9p42WxwRspSxJBdtTS7hkU/kR3AQD5oH9atkgEJNWjpmBh1fPB
	 VHhYTrsVlRH5oPsw276z8eQr0yMfsMbhLD9VeBvo=
Received: by gentwo.org (Postfix, from userid 1003)
	id 24F894033E; Wed, 10 Sep 2025 15:27:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 2049D4033A;
	Wed, 10 Sep 2025 15:27:02 -0700 (PDT)
Date: Wed, 10 Sep 2025 15:27:02 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 03/22] slab: Remove dead code in check_slab()
In-Reply-To: <20250910115507.1991829-4-willy@infradead.org>
Message-ID: <43cd7c19-0265-d9aa-f9b8-cab43a06a253@gentwo.org>
References: <20250910115507.1991829-1-willy@infradead.org> <20250910115507.1991829-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1CF4840006
X-Stat-Signature: qx7pgchtuh3a7n6dxccw7hxrgzjxhf1n
X-Rspam-User: 
X-HE-Tag: 1757543222-794336
X-HE-Meta: U2FsdGVkX1++m0LDmYnWtkxySUprx60bOQi9X/rBEsWI8VXwEC12tYQZoYIxN+X8U+Bh//615/bdo1qR9JEJG5uMstEj1/VRIUt7633R06bXgZOo3P0bm6fThU/+8KNjKPdU7CuEDPPkonouHP5ZXfJm89MAClfxu8N6Om3IEaF2VffTnauPSdcLQ6Mi1zP44lcfM2I0t5jjb+tzvVZOVO4DdLQmTTfBLqyJpU+54TlNNbGShwM5MnF2iB58Bhk9ibDMvWkngpJlHss6y7ViMDaEHEpDgUHy6FBfD2OvK4e30yGgxiDv0OuPd+PIfGHsttysQg/IJF3lZywCy0BVny2ueoKuTYrSIn0Jog2lDMxKlyIIx3fTeVjtyxGEwCBK9VA00Or5+I6jleF5iIeUJFwrdVKn4yICyyxGEmKA6Xlq1cZ1L0gwLM8UodVw3ZIRVIMoSul//nj9oCa91w+DYIfxgRUMNrsvjT4UxaMk27u7DXtBdwvxVsaEMMOEAb3lf8zbffQGUp1bT831BlldRxYzszBhtCHIwU2CtwnNsHVjBkMLMHy3nrB8sCKHkovVkiobGIiaS+MYR1Df23AK8mf9gsGhyfW5y7h8Y12rYyu3RZIyz7m3Fw/lfrBSwVajm9IFKquRflbrQTwRiUvJu/ib5YScaq629iHp5vDso5NQqLpYje9ePhVd6wM/mkOhlUhp2mUs/NhXM9JvkPttGJQAQ2CRUlOiisnzR6yH1dOd1jra+KmEeunj6LZBzJm1vYer/GhAp5cR0+cYokBI4Bhs5O0gJoY7TZCMHvZFN8ey+jf+3EgaZn0gAKke7GzJI8WHPxZ6QbMbgpzk8sQjBYvut3WQDlVnQpIZEQXc51hiGKBsKgAKnwC21XTk/INXXwtNFRbn5FGMZvtqLmHWvJLObId4Zj1oCvou9hj9Bt3QMz9bH9QJQlulcfMGKGlmadNFa+Cp+ldp0isSiEN
 R2SrboBo
 t6eCnn7A7kxsLoy60TNSjREqMwa7w5WyHh7DXuokE1FkhWxxH8iWlOeJy/J+DIfDh3vlzZEz308cZe/MsEV7kfqCmqxG145kmJXCybUqAG+WDxPH5WvO+Gz9IHEwhrfd7HfW7x03JC+863+VfZkiOYigJJid2dqWsWJW3YqRYMfu7/plA+adH9fU244jJePoj6uvs285rEb2CiFVfFkegsLTiV2zQ/HMWhoLjnFqAvVWVNRfPEqkT11TBU9fZ+h8d2PQx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:

> We already know the slab passed in is a valid slab.  This looks like a
> sensible check, but all callers assume or check that the page belongs
> to slab.

validate_slab_node() traverses the list of partial slabs and this test
verifies that we are actually dealing with a slab page here.

It may be better to abort the loop in validate_slab_node() if a non slab
page is encountered.


If the other callers all have verified that this is
actually a slab page then we could remove that test.

