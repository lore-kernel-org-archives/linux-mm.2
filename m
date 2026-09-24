Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D44AC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61706B0088; Thu, 24 Sep 2026 16:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11BD6B008C; Thu, 24 Sep 2026 16:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00FC6B0093; Thu, 24 Sep 2026 16:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 999876B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:08:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27EC28048F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:08:41 +0000 (UTC)
X-FDA: 85249743642.05.267341F
Received: from mta1.migadu.com (out-253.mta1.migadu.com [95.215.58.253])
	by imf02.hostedemail.com (Postfix) with ESMTP id 068A880011
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:08:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OguHXzKT;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790280519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGJYFUOg31pfAnFHUX4g4eTIYSBjUUowe1OrUh3mgn8=;
	b=YGNOkGICs3sWh/3Eiwm8QtNMJB9Gt7ap5+3u1qE+MZMlTKb3+Ef5V1bPDpRaLS7uQcRpJU
	hOwkmNYipkFr1hMHHrvyjqmCvE8eT5zBu3DJVlK5W8MArfLQYNrAvJO3FF7xfa87OsTPKb
	lGG9izJEUsTC9P6Uqxc/CcTgK60E1DQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790280519;
	b=RxeSC5vkGdexU3s0bQFvxYpE62ZVNAHbPft7AqwuaQ6x1p66v1l1n9Fp3roVKDG4BFAWiZ
	nSfan14FX+nF/OzRQJ0l89NfcYb2wbhGAEa0Pz3+Ifug7ErY75XdkT5RNzuJ6ObibMPBL6
	FdBmn3uIrOZzzS4AjAFqwOZ1d0M4SK8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OguHXzKT;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VnpDTS14tLqQ4Jw3vNMwhP5cW5pyfsrnEwAGStbJ+II=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790280517; v=1; x=1790885317;
 b=OguHXzKTGLoSvFuNcHoD5zZ1DCyfbaY8iG/oTKiOAfQ0LQbiY1G14Lp6UMa7qRWPULdijipY
 aJtBgBHyiBqFloVBd+XUpfGmscFzHZT+WpjITtt3gKjGd6X6oWh7MSxRNixhVokNdlWDW++nvQA
 GBiiFd+XnCxrYiNW4DcuKghE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ac9eebf04bba0dba;
	Thu, 24 Sep 2026 20:08:37 +0000
X-Mizu-Trace-ID: ac9eebf04bba0dba
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 13:08:35 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, axelrasmussen@google.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	david@kernel.org, kasong@tencent.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, 
	qi.zheng@linux.dev, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	weixugc@google.com, yuanchu@google.com, hannes@cmpxchg.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: remove the unused zone->unaccepted_cleanup
Message-ID: <arWDLhfBmd1UuUHD@linux.dev>
References: <20260924191103.3475117-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924191103.3475117-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Stat-Signature: brp1xax4ik7s9tckrmjp3mb9s8defrsu
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 068A880011
X-HE-Tag: 1790280518-768889
X-HE-Meta: U2FsdGVkX1+O76DPRwj5G2utg0CfBpa9a84lQsGEPy75Yfv1ADjQevZS2ZsGAJTqkNiWt4H4GxTPfUAQveLs3Rcx8pKHse+7iVGDzK0V8HdQDm3ucVlf22Z9lsVqJZ8b0fawlHNwnnlOip+bE69CPRFapds2UGvyNFCP+HcH7u2Yh5qJFb082rnYFk0/IwvjE6uSxUQgFg2QnUXCLsqbpZV9E90WNJvQ5c0T+JPaLhaZfclm5CjWm3VwKGaj40jIiWFXKuc3pvFmKbribm3lP/hl1+Wajg4vFwzbWQlhx5TtWK267HJC/gFesX1Tz1EuAONNOOzaDivf4xkkiNjVCz9mPglKwRXO/3OficGyi3YEKudgk6nzV8CZS/KJ1G5150je/VnAmqzRET8P6kppk1cuJwtC5Y0K7g/zH+odqOUaC8Wg5m5dKs2di9c+UiwatDCZsMOik3XeZ7zOyzkShqerkkDQs3adQMEBV2P4aw5WxzaoM180Tpa94oseWuQQ/kjslz550kXVxc7e/2tInZAWRG4qphlPddcIfQiQiF1TqukPRc9Y6JHhggpElI1Pk+YBzDjpYOaDsajd2H1KIRVttzU+jIdkJlTGtljCY3qE+gMmq0PRR9F8KiU77Wl+tHDCTnqvvCORD5xHf39PjNfr3aJO0/Hnna8Lq2yygmmvcGv3KewCR2sAdtRTKiHNnXpYD0T6ZhKWCh9eA0sXTuPThqhbC7iCjD2ut4pOQ06SBAMc9T+FUFYe96UtyiSGJwHK9DV99tU8+lnxwgt/wVfZdVOO1wmqpZtmp/UGuKjZHIFbcSs9xz8YjVufg6uiANSwBy3uDEsksvcfPhU2pk4fCjSaFXPUAPFBh9XhB2P+wJqAO2iDzQdtTScGFjpbW65SQcRrakampk1I8ol5fWWuauMd78dUmXQZtzS7x/ygXW++4rIRVKMNqeduJXSdncI99OgYDHhU0J34aHn
 S3TUADJe
 WqKSqI9Rr01SDSnmQor+kyXFdrzg5/ub6Q5vkeQJCjy3qUx8NG2CKSZgylXDiUFT3NJmeegLzcjBIVMQDXLaCpLLK99Ug07W0B1t3PASqdEMjAn2wPg7ugcd604fZMd32gNox7P/ZOTBoABgFNAi/PiD93D2m/BF5MfqFVMIy1kZjyGdwJoguFx2DC/Xaj1SbC38hxiyE8cPEXYdtvoP6Zx2HcUkGBEREKYrtKWihdIzf4AQaKii8EqeeKJM4j5N0Dla/fY3DhWeUN16dmpG8a+fckKQj3S7mkOAfyu98OW4xo6AnkIcL+B2FpqqynaCi3/px
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:11:03PM -0700, Usama Arif wrote:
> Commit fefc07518227 ("mm/page_alloc: fix race condition in unaccepted
> memory handling") removed the zones_with_unaccepted_pages static key and
> the work that decremented it, but left the work_struct behind in struct
> zone. Nothing uses it anymore, so let's remove it.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

