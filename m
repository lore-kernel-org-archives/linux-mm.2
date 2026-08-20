Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66AC8C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 10:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246676B0095; Thu, 20 Aug 2026 06:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7D96B009B; Thu, 20 Aug 2026 06:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E676B009D; Thu, 20 Aug 2026 06:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCBFE6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:53:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64900160704
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:53:02 +0000 (UTC)
X-FDA: 85121335404.10.6D432CB
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5CECA1C0008
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:53:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="l GwToSj";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=meE7wau4;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787223180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Hm6dRu/lDSOGHkykkLzQS7nEKTBeP5xgqIC54jHG7w=;
	b=rKOQdsbaZhG5u6+CAByne03LEKcRQKSr70KtAxpXh5MgszbT/3YdlOY8IKfAu2PJ3be5o1
	Rf58NP2aV+Ty32LEi/S0pIUDmYgek2R25hjI9lLVbYnhlkuqTqW2fe5/dJeN1sw58il8oT
	vLm6iZJ6fYEfuZb5/3rOK9rGwqXg7mM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="l GwToSj";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=meE7wau4;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787223180;
	b=g/j4nK/+rSzrLVJUFfrQQCD/i3dcz1AT1ioMyQ+CJsYAsOR6MV3FUF+xWQJy1SRLDEeTeY
	vbHiY56ZcHVnkuV6kAtwo4SziDuLJZBqsvedbJ4arc8jeHBR8egKqHHKIRv0mDAxr9Dbwm
	rPrBo+LseQexN1spUBzlAObphOT82Ik=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id F2BE213000D7;
	Thu, 20 Aug 2026 06:52:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 20 Aug 2026 06:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787223177; x=
	1787230377; bh=1Hm6dRu/lDSOGHkykkLzQS7nEKTBeP5xgqIC54jHG7w=; b=l
	GwToSj8vmRVt7iD8kNLWQM3v96QhNpGsPEAIsmLFJdObYyjPTBvrw7Ujk6VQKuDp
	GCcFVbMUBnkDnKFediQ74DkjI0r5j9sygg69IGVprIeK/QZbukiszEh/8GT6zLyO
	7qOQyfHwFR2vEffF+kH1h8xR3FHtjv+JzVnshE9icj3cLJNPFGGtBS+N4sCNnKE4
	WCi+TVKbB0rs1hivSdibID+uGzDvlVf95YSq+EIS+1g1hDBgjK3hHbgyCgdpkFpo
	WArd82fv+rxaxOBasx/YlltyJmaRk38eM43LSn0HQBY+0UdJNDJT40lEgZj8Gouv
	IJwdIGvzlbFfbqpx/wLrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787223177; x=1787230377; bh=1Hm6dRu/lDSOGHkykkLzQS7nEKTBeP5xgqI
	C54jHG7w=; b=meE7wau4CKenl5UIRKtWlLbHB0nH5Rd4PKesazkis9U68OKk4Wn
	EQ3Z5R2pmVJ69WzQ6nQ9nIAaTMAoQtgsAikt3XwO+xFU7SeCwmNQenIdOf/PYzEZ
	MYw0IhPYRj0yRM/c9q3oK76xpF9/JNGoFWnHGCObkf63ugBBYvOx4tMXBVF1s+xF
	SiMSy9RmN+erVgJS/RQLTd+rESLKHl5B3vHQVPab+tLGMYhqMgeLK6h3ItmyW3vD
	5IfFWiPeyEbuUvX4ZHugoazneYVRXdqxx0ulsuh215HxrGproxrWmp5eUeOykS9V
	5kzIC+7I33DzGtBFvmvVR+/ZFpwUMopnoeg==
X-ME-Sender: <xms:iNyGat54BC7xFMs_8l708cxxc_QNa1N1KRy3lm3UYpbEGggUlgpZaA>
    <xme:iNyGarViOayqVZ8tXexJEDUOBz4FGxvlpPQEw1SI7PiuPfT9vIONKpD6EAahfXlIc
    ugsaYtQ096OKZWtsK4pFHHSpfMIZWGwSX6KgtfyIGdWztTaOIozpEE4>
X-ME-Received: <xmr:iNyGal47XIR6C_PL9lYLPJXFMcpAeMSpoWverE2zKXbOXLBAvYBdNDx6pWk>
X-ME-Proxy-Cause: dmFkZTFWRza+tZqbwe6AvSvswwNn1vm2ouOEl3sD29XdKlxSbeb7SJ+ft0N23ZfHAXdLoD
    HmugP2x8o1qZZdYgJ6uNKnryUZdf9vJIX7yG1Wd0puBWlPtUU9+QdT2J4Dz6j/J8OsU9Lu
    cHBdXN2icIfdMLZpxUxDYeqctOT72wTuhC9gb/P4RO5svqtLV3/dQMxW07EDCY/HgRS0R5
    hIWhoRHy8caBmuUGk6MLMFA2fTWneQj91H7dazgLVy+nDRNY6KF3ioVB/SCkQrHtuzDw57
    zzT/SzyH8GGH6dfj0mKV7WEwwBQIKCfmWOLYVVVdY2G5L5TUscUlN0MnsMmOT7XGn5nqZ3
    qTusjp1bsmaQ7NxNYNGdouQ+Lzho5PCtqMOZXHY/7N8mFMRgD536Lix289uLH1lUZ5l7Bs
    0EKkfid8uPYzb8PyS0LZ5AGD6stNkDOaYLtEQ+FU4ShSANtBwfDpn7DoszKmWH82qWAlZf
    IibZn0VeyWcdksSZ6k5AMmFRba7hM1obgBOhf0ePHT8321pqVtXzXm7r6Ac9BoQcxbdoGX
    DiQyx+zJJ8bPCAxR69l9MIPqGhG3bFnUFNk13wc1BQkNJDAjeLqZCWgh8a/ngZ29YtnBdz
    5UGnWNG2Fm8ctlMT15phLBhY3M3l86Iw7muaQrld5L7QUvHK5Ib+j58n5HSQ
X-ME-Proxy: <xmx:iNyGamLi7qP7Vxx2Urm__5VWE9vtQY2VDeeZD2Ww17JIYTyID0H14g>
    <xmx:iNyGagjcASSknb_rBn_7XGrZaAw0RVIp9r9LgWWiYqMx7ZibjiT0gg>
    <xmx:iNyGaoIaZZAMY58wc3AOrGX1JTsHPReoBCi33oNnA_pSv5mWAwG5lw>
    <xmx:iNyGatEnM3ejngFdRo3f_F-khoayz0ka4TzC0oi5RkdtRfyGbUZ5QQ>
    <xmx:idyGahzkie0eSCaUoBYs-yYze10njpQW-hnyNaeDBMfy-8AIxueySSoN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 06:52:55 -0400 (EDT)
Date: Thu, 20 Aug 2026 11:52:54 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 01/57] mm: add pte_folio()
Message-ID: <aobZECx2aTUHP6n3@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-2-kirill@shutemov.name>
 <7e40cdfe-67d2-4ddf-a048-f33b2d590371@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e40cdfe-67d2-4ddf-a048-f33b2d590371@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CECA1C0008
X-Rspamd-Server: rspam07
X-Stat-Signature: kiw844696pizccbmcek53764yzty1jp1
X-HE-Tag: 1787223180-161322
X-HE-Meta: U2FsdGVkX1/GMgGA4aaYAK843Mc6YxbSPsr8CYdZ/+6wVTqVeGiBZkxk4q8iRbJUCg+cf8VViQHuk9pqqhu1jX6ZMo1bmqHMVk5+gjkK558mpBzItxkSlIWUlboleQwH11qfzwt1mYl+rie6g7hNkEQo/buYKzyFy5e12NTCk/psFahUp5FxJKOfoFTDJY5jb1wGWzZ8NkMk34jjJFg0NPdArHkFPvf7ZtU0kVG3IgjKB0fNObXTWE87ullTo+MoVu9W1sEB7Wn17qoMS4l5QLXxnNAKnhoChaGW+GXkpuAF43OWrw51CZwyQHiGfmYX+HCs9EXq4KRnvfX4aeul/6GYcJsZRF08waeXZO9jzM65H6EBl7m9hmMMCfnnxPPQlWRJnOJlVZWIvWwcyGWPOea0Frhpi+SaNVzuFwfDp6R9SDDLUlzvHyTCY0JPTM748eHmNbVpoH0wdqcI4rCdWTKX+15/tAFAkaj/MpxQ60tdPui/rnOu4iLrzUsDF/EecpnCi1mTbOHLGjySxBkZ3lvokBeIZVoKkudfwLGDKWMn8+KuJkHTwBLY/mB9NFmPJy2otm6Y20QazWLWdzaS/3egmtPseKjT/ThdYqe8o5cZrv3ULkpDxxkHHps2HcDsuuLaIOlXwgEBOciin+rrw0KruM8zFa1ejGqn7z7wmAcOoYEX9gNHca+57aOVYnuoRgE6UvHJ4kKcd4vTgmD6Kj1yDgSfhm0xlC0P2zdIFfd4wKmaEmegbwR4fyHrKIhyIxIYCzjMQJsJOVD1sxqbyZU2liRLog6qjLMIRvHQyugDvClrl/tG19coqnUh9P+BLybBM19PqQ6qL//iFoq30MH5su1f6Mq/i0NDJxbVMixWta0nD80DG9U9Q/Bh7izSVnzCBiGmMo1jxgDKyIJE35YLPSGXO7Eq99aU3PloHKm+7D57fCHZPL/U9yM6DZ+SO6CCyOtRQ5tvOV6rwsk
 rblVxCq0
 XxT0o7KByXkAFVRZFDDv3Eowk2lDfJNzVeiwI1K2NYis0lL4C9wer9h6i1gtiYRxeZR9cLbVqXGrRm4vEcLQgbyR8DzSF3nPaXhfbcBaAkK4kcE+T+W4F646Wd180fbxLGSowkXIe2gB1RF+zgkuLdRiQmC60gk1J40kEXwfA6ZBuxO466iOEVITF3clYTMWDl1ojR2KNWEjSzqV2u3xwkFC5qi6CogOIMUCUnE0BRgmsyGlg7Hoo7jX1Pbu1VE8NH4+0CZB5Fi+4YCmVDqW1WulYr8G+XnQVqy6D5Cg8a3NQu34ViF6E7fgxuw2JE2m0hioa1h22XcP/k/r9HmzD4mB+AkORu69jIhSzB2AcpLGNhctAJvxQk+im5CJxxnXCaQMz1WCt3w4D3kMaqDHX4rOz4hjNvBfX+Vj/QdCBSOL1meeP2/tbtqjqc51ytrcDXJQ3E4qZi5B/+SJMRc8ahCL21WM1IUVd9SnCSaVkWyfA0m/6PD8hAejer27aB9vThU/8gvH/q9cdvh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 07:09:48PM +0200, David Hildenbrand (Arm) wrote:
> On 8/17/26 00:45, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > Callers that want the folio behind a present PTE spell it out as
> > page_folio(pte_page(pte)).
> > 
> > Add pte_folio() as the folio companion to pte_page(), and convert the
> > callers in fs/proc/task_mmu.c and mm/hugetlb.c.
> > 
> > Preparation for the anonymous collapse engine, which reads the folio
> > behind a PTE in several places.
> 
> [...]
> 
> >  
> > +/**
> > + * pte_folio - Return the folio mapped by a present PTE.
> > + * @pte: A present page table entry.
> > + *
> > + * The folio companion to pte_page(); only meaningful for a present PTE
> > + * that maps a struct-page-backed folio.
> > + *
> > + * Return: The folio containing the page @pte maps.
> > + */
> > +static inline struct folio *pte_folio(pte_t pte)
> > +{
> > +	return page_folio(pte_page(pte));
> > +}
> 
> There is a reason why most code doesn't need that: because they should be using
> vm_normal_page() / vm_normal_folio(), or need the exact page and handle special
> ptes differently (see gup.c that uses pte_page()).
> 
> And other code that uses pte_page() doesn't really operate on folios AFAIKs.

Fair.  pte_folio() does not fit the abstraction as it stands, so I will
drop it.

I thought that maybe we can rework vm_normal_*() to be a predicate on a
page table entry, so if it returns true the caller can safely use
pxx_folio(). It would be a cleaner interface in my opinion.

vm_ops->find_normal_page() breaks the idea, though.  Xen (being the single
user of the vm_op) wants the special bit to indicate a custom translation
to the page here.  A bool cannot describe this.

Ugh..

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

