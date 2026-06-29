Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B5BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 04:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40B16B0088; Mon, 29 Jun 2026 00:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF09A6B008A; Mon, 29 Jun 2026 00:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B366B0092; Mon, 29 Jun 2026 00:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 874CE6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:43:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEBE31A058B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:43:26 +0000 (UTC)
X-FDA: 84931706412.03.BB21307
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 93ADB40007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:43:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nNDA8CB9;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782708205;
	b=3iB1KKysLbAkPwsLZd/gx14JQ6pA2aC1x8uNXcZrLFcn26U2YCKqcNBhxL/1XJ+CVOVSSG
	WXsYTRcXLTwZgJZ9t9sC+HcpmuPU/zgbBHg2JYAi4O4pGIi65och1mowDw7DREVGB8le34
	JHZjJIXhoVP/HqSbF1tYWmSSQqmtUB0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782708205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejAiWdMEnIVX/zERdGSuovRm+wQyGi2KlnG+GaTgKh4=;
	b=GSAxsVqfbH4CQZN1o3kiOdiq3qlg8R5KolhOHGieayyO8rx9HaWM+Wv48YMwFMHRDozMyp
	aA1z2/3e2A3kxFbAtFAdLSkru6szTO/7saUad2/bR/D1LWGMXOj44T0kuQswqTTFH6WPoO
	W1bJaZmuS+JgtCrDjrj/wHaRBfAos9U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nNDA8CB9;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ejAiWdMEnIVX/zERdGSuovRm+wQyGi2KlnG+GaTgKh4=; b=nNDA8CB9pf/u0o69aoat+9xEjK
	UsBg6eeiuDg1NqebWfVELKGI14y9YEGNg0EYgKlkndkXi0HWw80EKssucIj3VYsNe6IAPGi/faXV4
	JDhhS+7O1tZPXM7tsWaZnhu4885fEiZlmdIeyAJvSaUStolJcXo9ZYl33KS39HPeh0anYdPz530jF
	PVCD/lD0L69DXCt1syA5FvaUWuHKR2BfA/GT/v8h3CIJgoM0rpMtQ12Eix3Yyoe93X184Go9Z9HfE
	h2SsOCXFUnWxIF+tjC6pX8VGV3lD3GAiYHZnXotYm1IeHd7YF3QTc1vaRYo4gXXHODPZFOUBrJEqR
	QfX5J9Uw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1we3pz-00000002bfS-0vuJ;
	Mon, 29 Jun 2026 04:43:15 +0000
Date: Mon, 29 Jun 2026 05:43:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xiang Mei <xmei5@asu.edu>, Pedro Falcato <pfalcato@suse.de>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-hardening@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
	Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <akH34ycu5-q2Yc_D@casper.infradead.org>
References: <20260626173444.2252041-1-xmei5@asu.edu>
 <aj7UNceukU9zYeGH@pedro-suse.lan>
 <CAPpSM+RVFDOYJFT2iwgNYdjbwqF-MmrbYizpLYksd1SLb5bT9g@mail.gmail.com>
 <499a4e15-34a4-421b-946a-c855199fdbf9@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499a4e15-34a4-421b-946a-c855199fdbf9@zytor.com>
X-Rspamd-Queue-Id: 93ADB40007
X-Stat-Signature: mzsqzmasa395s4st1hxo9icb8cxgx36w
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782708204-697665
X-HE-Meta: U2FsdGVkX1/bmfFC1awlrEPV76wuXk7KMd2PXgGVj3whyKAb7GmKffjKCHrL4SEUk5Pi+hx7Nf7VdeeVn0nyByt1t1XcoRVSAPnJO/BSzz/8oNCw8IVvjW21UC3snywAlZi+t2CQ+DkeA+tM3ItT5+QTvfefqq10X+t1exJfqaYCYO+JXoB/6IRxmVl81dy/AwEwxW3GDbayKoXwesecEcoRGZ3igroyqUrqemqHoSX+gFYt4bmSItd7i8xnyHN2kpBrpPBLj17k1SInSQvLQEnn84oupJr3/ED4YJNbkD/2GuEpnu6jH+KfInD96hoyWma7sBtHQJv+DfbwVmer8s0Z2wRfgESrVJw52WJqOzjya6JzR+rRJn4DgrUGfvW/g9D4/d7z+lDAdeIojbbZjYx1t6ljeyxd2UVnaDUCRc2O2MpkFbcbaPnhTk7HkFwDYSpg6edXVmbIFWXCvo5UgMwd3IY0UR5io2oQccIX/TQ/v82wTgQmYKUit/My/Kmb5/wCjnWMoY4ufQdrB0V/90oZNrvTwWRNFJV481u9uj8Hs1JaFBigZ30TzripwaRlHVLf5fp24v2uRSsPse0xysd7tOhl6Qo/XCawe5YEKD+QyV1tzHWX5smrti5gP4xtS/kdsNURj+mlTnACMCYKgfkOfEFXBqiP0GYua6rj3Ak8cJEP2jq+UMOwG5NfrNQu9NVmNX3kfG88sFH0KEBgGnTy608yEBUSDs/sqh2/aBA1UB4g7pfAxqQpTqYcLVHdN6hrYwJb1WEtmtZxCVzcZVZer2GkfWvOKpK0G94L0eoTmKVuxgGv3Q2athrEiNTTvqbUtsF4yxkMp//6DPnWizG52eIVNZ7yE0aMf1s8LWrEA0V0UhhQZ/HFe8smtEB8RVRMA/49MnO6MHED3Vw3kCLrvlqexA//NEOhrH6zO0R8lxWcivJ+o5KB+JbwOdMO2Emi71s//8SP2HuKpne
 5ItulF0d
 /w4lJ40g5ohEySXmTElUbIfXrq9XpPpkCUqGkZ/Rxe8ivkLeJwTHvebIIMTPTx6im+T2P27rcDM3xcded7LbqraNPUYzV2vukz+cA9cESzRcZXjdqdfHlprdTdCJXdiRxDSrktwY63hnLjtt30HZSF2B1A3IwwtHHolEPBoo17nY2LrQRy6UfHA+O96uCeKrbO9R/Gb8rVsIT0/JaE0OqD6D3CavVC5G3tp3veoi7gduCAMpsAGVSzKuFmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026 at 07:09:37PM -0700, H. Peter Anvin wrote:
> On 2026-06-26 13:05, Xiang Mei wrote:
> > 
> > Thanks for your questions and attention.
> > 
> > 1) `enter` can do big enough stack pivoting (where we can't find many
> > `add/sub/adc/sbb rsp, ` doing so)
> 
> Say what?
> 
> Using add/sub/lea on %rsp is probably more common than enter, because enter is
> considered kind of slow.
> 
> gcc, I believe, will generate "leave" but not "enter" as a result.
> 
> 
> > 2) `enter` is not rare since we can take part in the instruction.
> 
> This sentence doesn't parse.

They mean that we can jump into the middle of an instruction, and it is
not rare to see a 'c8' byte in the instruction stream.

