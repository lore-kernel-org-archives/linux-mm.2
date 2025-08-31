Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41766CA0FE8
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 23:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099418E0002; Sun, 31 Aug 2025 19:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071448E0001; Sun, 31 Aug 2025 19:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFF98E0002; Sun, 31 Aug 2025 19:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBAAA8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 19:37:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E05A1DDF8E
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:37:33 +0000 (UTC)
X-FDA: 83838666786.19.1F5CE25
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 226401C000E
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:37:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KhiP7pYP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756683451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/X6IMPWa31K/zfx8lt7hgWlCVhbr2OzJf3fLghYiYA=;
	b=jYR6A6eFjW5Qoh9yqGm1vc5qqXrYtjz7TdR0ZuhlkW4KhtJNHPlyuakSUEDhYh/6wNotq0
	NaUWLRtOoX8eCxeuz0VfwltL0vaS+9KObvmZJ1zBZegfy52k1x8PkyRrjQCOntDGonClmc
	H796drSsjYW7M/BYWRtKQRN6znr2u3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756683451; a=rsa-sha256;
	cv=none;
	b=c03e4D/FInAZV4Lq5ykJtCF6H066tCkP45XzBA8Qjtfyv6bq4Xatu8gT5f2f4YjNhWX8m8
	HmSEUrqn3lBPDUTygNHcfj91A+f0/fCX8952yC8XIQbVsY+DvZWaQ0fXTadyNMThrGeNe1
	6r96PxbGELwbVkHcmDzP7YdA7AhgWzU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KhiP7pYP;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5/X6IMPWa31K/zfx8lt7hgWlCVhbr2OzJf3fLghYiYA=; b=KhiP7pYPLLNma/iEZ0/e2s/a+D
	CYvRTBGFdpIballmC6yGqJ45tRlQU5XV7nPT0Jxt3J6XyDX7QkhlwDDgcHOZ+ASfjOpjy4wicG8li
	p8Hx3mozisdRvwWVZIRaEln/oA0dC9LLsOLnW6AqqbFTTdAAcRdjsG2SIfQnJFw7Woj92s2GYXFI8
	fmoXWNWwydZl5iJgBxDNHQiX+hL+kKfc9lK917e9vtCdMScd05eaRrU23kDIEPsOCpPRqS8fxcBWB
	HWBQgs4FsAT2MfTquTpvhyXreYXTERavKkyalH0axsHnlTDNtqC1L5b62O9qCo8OcIUipKR6SKwo6
	VGvMVuyg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1usrbs-0000000GxvR-1wBS;
	Sun, 31 Aug 2025 23:37:20 +0000
Date: Mon, 1 Sep 2025 00:37:20 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Shivank Garg <shivankg@amd.com>,
	Christoph Hellwig <hch@infradead.org>,
	Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alexander Krabler <Alexander.Krabler@kuka.com>,
	Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
	Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm: fix folio_expected_ref_count() when PG_private_2
Message-ID: <aLTcsPd4SUAAy5Xb@casper.infradead.org>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 226401C000E
X-Stat-Signature: 7yox8ejsotif1k8kjad7jy4uw819gkbe
X-HE-Tag: 1756683449-133499
X-HE-Meta: U2FsdGVkX1/hotb4gWPifXiLhaazpL52VTRR4c9J7jkWBoTgXuPMh75T0yKVX+Umh07L9N0/MBZbpUkjVg7otDaekRdehzFVnLmVNmDnIAFJbO930/VoOfjN95jbot1NtLOCJ+IyjlpZ159HTKh9KQIQCW7C7KrdWP6KruaYUCgprVd3AwyDrCaR04BkZgo8+0gpzGD/55rBVgazb96ZuzeUnqxRCVBF/enRYMM2Cc2uUBi6OGRlyRXwFkl5lHEdmPuuhe6m3KN5iHJ7TVJOirba0/ovmwYZuydN0rnhM15aY9z1jpPDE+E9UGwosLjWN9xsiGoUF3TSNUPxtkTv5Hr8GTR/kB9YharSp9Y1bzEB8ih/1KMUS+NpM4chTbVoQgg95RDA6fsQcxfIqqVv8SBTuO3n+fxz2kcme69fVO8PFqibie7yqzJi5KyFnjz3c+Vciz7ksCoPDrrVQ44jp5RkEhjeR9Us2RiY1FMscnDVB8maNm/o0GPZuWrtQ/bzw7dvAq/PoyqoHrXIafmirdBzaI4Ev2bxa1mFwT8zNcFjCt8PlOzTqUkeyzUlp2kVBQubb0n56nVQCjrDayAOqVs5UCeNSPJxV/m6TFv8+I5RyCjAUYi/rwzEh1tzpwNFTOcmZaTxyVAFpPcMRsViF5yqQcb/Q9FudA4r8zuLxf3GGVySGqZAhsLdNJyoUkO7drLY8LjL5BC0A7ykw06VykI/DamCqPq99d5Hxghd+9uN9hvR2rojz6sPts/jvL5e3V17shP/bQ6r3KXOv+pPDY7SSR3cLTISQh3ZXXH5cVenra8e5GAp+MdmQKmp2wn/UmJsojxJXhYTDFPCJjQgPGiTCOjGpuzP1WGnEprYEv1LzpSgUuv62K1DADu25RL77BhzzoghrtXKofltgRANLkHJU073opSYQXGgpUXEBhz3yPSf0nEEK5FWjOUDVEJ9pXkAY7X6WnN0a4Fc+G9
 G4D11KHy
 TxZMA/G6LsGFInZIv5soJWsUtdhyujqpY57HM3+F+syhlJgllQyS8xBPS2F9KdX/KmLcCQvLCa+y37dwEfqCf2JhodRbVMbaIFzBQ/nnSRy0yQ/+BDh1aSzh6eetqCQjxW7WtMVx5G3i+nh5S1DEEjghS/nGQO+maVKDJOxJq8Ssfb7GW0nU04VJ7yer1k0pvHG22TKrmCkchylnaBA9A0o2v9ZMV5PxNE005
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
> 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
> which (like PG_private, but not in addition to PG_private) counts for
> 1 more reference: it needs to be using folio_has_private() in place of
> folio_test_private().

No, it doesn't.  I know it used to, but no filesystem was actually doing
that.  So I changed mm to match how filesystems actually worked.
I'm not sure if there's still documentation lying around that gets
this wrong or if you're remembering how things used to be documented,
but it's never how any filesystem has ever worked.

We're achingly close to getting rid of PG_private_2.  I think it's just
ceph and nfs that still use it.


