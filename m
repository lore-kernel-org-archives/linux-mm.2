Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72717C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C07E46B0484; Tue,  2 Jun 2026 00:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB89D6B048B; Tue,  2 Jun 2026 00:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF766B048D; Tue,  2 Jun 2026 00:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 981646B0484
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:24:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C5F51A07C2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:24:16 +0000 (UTC)
X-FDA: 84833680512.03.2E3CC11
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0101B18000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:24:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U6sEhaIM;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780374254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iyHGUuJYmgv8gJflD2sBc8RMlLF6Y8NWc96mwDPsgM=;
	b=F2PdM/D+91R8jvzRgJHA7OlR+TjmarhxALmIo314fkYZwAYJh4Vxl/yMeHvIkQ25Juebrk
	NYaSQ1uo4KHh41M30Kds1Ij6WBfzJ1wHnn6Z5nxTG3uqU59+7yDfHfESFXoLdiVg1s/Ket
	xt7kVptkaKvmQ1g32eUf505PZf83fs8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780374254;
	b=TKkGbpAjhPJt1Y16mEftSjccbEsLP8fHXCNypeOrSOW0lbRNosSFuyrXE9fggrV5ZNWcc5
	2fhtKA1q+a2F/ITjLKD5HHXpJC0bJNqKhaI+xxXrScdzQYwgkeiuob1UxBLhxmmecvtKzz
	3ZK4biAvfEp1L+G7JlVKr6/GeDMKNLc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U6sEhaIM;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2iyHGUuJYmgv8gJflD2sBc8RMlLF6Y8NWc96mwDPsgM=; b=U6sEhaIMAIyl+ik1kCikwYfrBd
	wH71Zhc/1L8FYctvNWbHR9Kf5GQ5w7VzeRGzbQkiIxxWOT6Ppaoaiv98/ed6OMjAH8e3Pup82r4RC
	jRsjYmflrX0LxTTrTcCnwxfP9oO+GWLrZ1pNcMAuIwOvRx3o2diSjGg47eHUS47uTnXefpdGjZnYN
	8XsUEaMW3VY31FzqE5gc5M38Y4iwcXc7Ww+MM6gkFeIBkr86ztZWeqS+1jxEkZ+i/XzhPmzKjFIWT
	aD7CnhSc+mSFicBU9mrUNuCQPZ9DVxKnct+9OHzZQiKnxGzn78Z6cVx6eTiI3vNON31Fnk/qLHX7a
	tAMwXTiw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUGfk-00000001Ihx-0wX5;
	Tue, 02 Jun 2026 04:24:12 +0000
Date: Tue, 2 Jun 2026 05:24:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH 3/3] mm: Remove __folio_index
Message-ID: <ah5a7PCNAcFF4l4o@casper.infradead.org>
References: <20260601192626.150804-1-willy@infradead.org>
 <20260601192626.150804-4-willy@infradead.org>
 <20260601170502.a3328023425ca85409c77957@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601170502.a3328023425ca85409c77957@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0101B18000A
X-Stat-Signature: xr99h5s5njfopcdbjqfm5u85afqh1b3e
X-HE-Tag: 1780374253-546972
X-HE-Meta: U2FsdGVkX1/p1ceVkR3UgPaoZLa6hhwGb29lk9o/hmyfC8ZKZRrjQ70KqKQm8t0uX4fYjjoYeCQWBN+sHEl+Sbgl8Z42C96lV8hRsmvpN3Gyyt0tEB2j0EAp54sVe9a6sg1n1WAwkGs/0GcW8JR+vLp7q2LfdfyUe3nt7W3QAUuEv/fv0zNhuQfle2x9zcHFxuUbRSmsrl2In1zvTJIHD+rZoChuD9t+E/B+oGCmyfcbDr217zYfDcvAyZnuZ1FJtYaGDpS6lO+F3ziXXsgQ7Btz024cd9cT9eM8DnxyTBSjq4Iy6STprsGr6vMEi03QSIl1Q0oeXOfY+faAAd7hValuvDCFb385/rI+SBoMOaAXPP/2IpaozTZLU2m1HC4t6VybWFAmWRcCnEaUZJ9sOliYC2/idsAAIlCV9xVg2Imc/sksYR4yzZHcLAuDAUNx4CltrrYrgJ/yPZsOww+gJs28WLE1MhfIgVd4/29yfd/WwNpKUg2wgkf/VI6NDv0sKc2IxcUtzYHumEoZjpQnxki8t3pDVnj4IAnvr6ZTmHo73ziLK/cQxeZx8vQQP2d7da6t7X18kh1+a8R3nWNQOK0eGnXDaKMhPEkaQqhBPkL+E5sdI5j2GoGij1JXLC+gquxzwH0+pqru8X7IQ28tkX++md5mHkV5ei3kotIZAefayi4CHTvm1e7zpzbq5ZpdqePsPmaJtYg7JsCtn/oXbJaZkDY6L+Yt+xtnWm/GC1okoV5lhxOK+PxWhh03FRvLvo3YWrxSHCh3fcPqWY/h8bSZUW+8nFR2B4h7Wq87vf1qZd/uxN2hIdRvzoVQZGS6o0MmaTGViVH89PpRfw62+svyXASiOBPij39MEfPQk+2mEv22HKyJCFlCkYUvW1w5Z6qCq2pad1wZtQW1wPNkP6Oj2iaOcClJPtAQsaTArP78lu0qVrSVaEFRRXAQXhyO9E1C8LIan3ePpzsPowS
 WX0Hp3zt
 szrQV2wejX2nrqqWkCoH4lJQhtYzYgtzZwK0WArxY/5hWEqNStCrarZqKy4EwLx7icWJkrlJE9bknIJnzuv6i/PR+9FWzUwoQ/3mvznyzllBJKk6WlCNLJhtCaOG0njenl7dtAgRVt45SS8gtcxHw+scBpt7PS3n7TWht9s5Si1ODb7gJLx1+aw9UotvPF7XC8A1Jkqi1DkbYfu/1twc5XD3etRSj3T12ku3d66b6jA0VAyXFhfutTchmNR2LQXGnpPOl8uF8tegF3WONhy6vbLqFRxFUdzechWuiM37iNYbF7hIGmxHbWAWGUTylhYeaAM/dsUP4QRRd4RIw4jCLwQ+S6SlfU54JEm5wH6f0KfkJnKqLr8NeB68IOgW2KHtKTUT46OacOZkquTs5HIB6vFCItRjH6jZbRi/yrsgG+6k/ewrM3XoECAfhdMJ7hcKc271VA6GHY5aFs3CcUBTHiHkQTtCMOggvWxZ8t0udLRpmH6csXXFayIBKDNun8NapfVVu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:05:02PM -0700, Andrew Morton wrote:
> On Mon,  1 Jun 2026 20:26:22 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:
> 
> > People have been abusing the existence of __folio_index.
> 
> Patchset is rather amusing.  Perhaps you should have called it
> __folio_index_dont_use_this_or_ill_shoot_you.

Yeah, I've got into trouble for things like that before ...

> > -			union {
> > -				pgoff_t __folio_index;		/* Our offset within mapping. */
> > -				unsigned long share;	/* share count for fsdax */
> > -			};
> 
> `share' went away?  What's up with that?  Unused?

Oh, I meant to mention that.  Yes, it's been unused for a while; all
users switched to folios.

> > +#define DO_NOT_USE(x)	x ## __LINE__
> > +			unsigned long DO_NOT_USE(_pad);
> > +#undef DO_NOT_USE
> 
> Sashiko says this doesn't do what you intended.

Bleh.  Arnd suggested:

                        struct address_space *mapping;
-                       union {
-                               pgoff_t __folio_index;          /* Our offset within mapping. */
-                               unsigned long share;    /* share count for fsdax */
-                       };
+                       unsigned long :1;       /* formerly index */

> Sashiko also might have found a few existing issues in ntfs which the
> maintainers may choose to examine:
> 	https://sashiko.dev/#/patchset/20260601192626.150804-1-willy@infradead.org

Yes, I was aware of most of them.  The kmap -> kmap_local conversion was
clearly done without any testing (and I'd suggest a lack of understanding
of how kmap() and kmap_local() differ).  I'd be tempted to revert it
until it can be done properly.

The warning about shadowing a variable is well-taken though.  I'll fix
that.  I'm not sure I'm signing up to take care of all the kmap-related
issues though.  And nor am I doing all the folio conversions still needed
in ntfs.

