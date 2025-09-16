Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8815CCAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 02:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC138E0005; Mon, 15 Sep 2025 22:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3C48E0001; Mon, 15 Sep 2025 22:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0768E0005; Mon, 15 Sep 2025 22:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA838E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:00:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05F2386B48
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:00:34 +0000 (UTC)
X-FDA: 83893459188.23.75F92FD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0B9C94000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:00:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Fs8qO5nX
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757988032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vLbiGQX0AC9H7KluJOU/q9glSrJZnzHnZoclCwUWks=;
	b=u7Aokl0usX2DR9hLvP+I6oLiyO98yOFhKBGbhirDeEYS0BI/njMRovdBVsxEUcEKRKqPZH
	3rddZmqxUB6bkge4cYi9u06fm9Nyq5lHLjfUZ4QdeTtsuIVo+w4MJu3ErtQHTdslq0EXZ9
	rZoFuw85JSFK3KxuRjzNIvA+oMBKyO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757988032; a=rsa-sha256;
	cv=none;
	b=KiwrDzIYgSoh6N2Q3R0QMbqW9r+Z9VHEEon9lbc0z5Iip50co94XBiXFdIEftVAMTj2OFe
	2Gq5A3cFCXimj+5pXGFx2Ig12hqwv5mntfT9Au23CIwekNkKPUrsyxBJFttKH/dSK/VX2K
	IsOTyc568WE1Yp5lZ2c9pt6clZailNM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Fs8qO5nX;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1vLbiGQX0AC9H7KluJOU/q9glSrJZnzHnZoclCwUWks=; b=Fs8qO5nXlZ6sLXrQWKCVDzYpAb
	D8rXf2rGYfMLMaQ/39ZY+LeLb8A5U3uUT63WR2SwmCRc5OjcXtuiH9o6Q5heD/6OTRRSybgaSeXcm
	UdPI0elIYFXp4LNQNDiQwn9HKkNmdylzrAf7huSt712ThMHxInXeNNrcdrCC+MdkO++mCoFLjkLvr
	XXPtwewEvN3slr+xBJltB7k8btx2kgWhOcdRrQ5fyyfmSVjFws7nmbW/jVZzalMG5+BrTMvIzF39O
	VurlrYO7JWMpan+hRPOqON+fROn/mOP0ctcNs5l2OJRtniph+xYhlObgtQCaxN8KHHZ9cNGvnpMZr
	lNZBXHAw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyKzX-0000000BcoG-1EAX;
	Tue, 16 Sep 2025 02:00:23 +0000
Date: Tue, 16 Sep 2025 03:00:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"tabba@google.com" <tabba@google.com>,
	"vannapurve@google.com" <vannapurve@google.com>,
	"Roy, Patrick" <roypat@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [RFC PATCH v6 1/2] mm: guestmem: introduce guestmem library
Message-ID: <aMjEt1JKjf789o24@casper.infradead.org>
References: <20250915161815.40729-1-kalyazin@amazon.com>
 <20250915161815.40729-2-kalyazin@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915161815.40729-2-kalyazin@amazon.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B9C94000E
X-Stat-Signature: jdyj7idanhii35fyrop3wef9cgnxm6up
X-Rspam-User: 
X-HE-Tag: 1757988031-309971
X-HE-Meta: U2FsdGVkX1/U/do07Wl1e4J3iD9y62GwOiVGoIuA8ubZuxtf+HyO38OCR+kMyiV4gzHQNF3NzxoOqUiZ2YOcHIzRrOV2e4NmnEgnBxo90HqeYBIkG48OtZ4o6DJFD8G+TAGbJwPVTMr3ofKvS8qMSHdn8jr2/tJ8e9ajeK5XG8CTkjBN8SAwanQA4ImhluZRyMhRubJwfpMFj+Kh01grPvcSlApOSDSOca2i6RgqMQw9F4dAaITO2q2j/dm9R9gibvV3aU9JsInN0voQ9Vs1t7YLcXjsL7r54SCcjWawRMlZVjiTPbvZ/svIiaVVav/lrBTq4eH8G4ryw3vckGqg3os8LjcXpF6sUUp0jiHZhzEKKQXKnekhXw6o0W/6UuKJZ+hSnojEzob9iJ2WnwIy08K8+MdI332QiSMDpwfsYyhxufcdzSI0HGMA7xfkYO9/W123QmJQqjPYvYvZ0PKfPUQrrxxAgMeNQ8++ubhnkCkq1406D4I8P57HeWq5GcoSmXJ3F1UHcVsP7Yk9UjkAo7Sf6EhEVtK1nX4v8w80JMO82PqzIZAHmP7mwxPAfYglW5/l+1d7rr6tXmK5zSBSmhJ3CNJE01HPbmPloOQGRjfArAPNvFfAtRRHQz/ImKwffLfBPZ6SA/u8eO6VoPtMpGyEoqoUAgbMHyw78HmfmcLO/Ar0xYKOhMM/LoGsLHIYOdJaP7V2lo7XkghxXLEuus+uqGHMThoQsl1tvTDnp9uXkz5W1ZYnIKpZxi60eioPujkehRE8ISn6ntXAunpzSTd+s4xPQWuKEqVFktRgE8zyfOrYwgUHdf5UWv8pML/OlWBw1Qpk0OsL118MGabT6yh56wj76cswa1Hcj7c5iosdsfPdyIm/+/S68rbajQ4+rxQOT2bg5AIxw+O7J1nflTkpFm3iHY+HgVwYu4HeXo7Ok12JMNb9+qhR5Ah1l57xQKaa9keeTUybZKkdvWK
 mig682i5
 cR300DQ7hYbw3Bq2HruYT1tqpQ6tIxgyjlWeme7+9KGoyyeKCBS/8ItfMhjfo4JvGLauEw4R0Noj5yQ0d2YkpfkB3itDGi59PQstI/RAopa+OUn06oDXtuSBvzaaO/7jt3OI1ydvjhnoAS9kx6cyjUy7EMCRtfrzge3YudL0iGWXFl2jn5XOs/WkNm/OtaMQoQ89VSfCVjSdBgxlUNhubzCKns5vL8ztPQXuwSWwDK1/XfDK1QCeTEtDipFmuu8iiDqk9QFm8QQMtxvOpspKvnAmeb3MNfGXqJOY7MAniwx6Us82f3Zpl07JDmsZcQIPvtk/n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 04:18:27PM +0000, Kalyazin, Nikita wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> Move MM-generic parts of guest_memfd from KVM to MM.  This allows other
> hypervisors to use guestmem code and enables UserfaultFD implementation
> for guest_memfd [1].  Previously it was not possible because KVM (and
> guest_memfd code) might be built as a module.

https://lore.kernel.org/kvm/Z0DOdTRAaK3whZKW@casper.infradead.org/
remains un-addressed.

ie this entire approach is garbage.  throw it away and start again.

