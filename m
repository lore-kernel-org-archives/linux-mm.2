Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44922CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 21:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB46A8E0212; Fri, 15 Aug 2025 17:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65778E020B; Fri, 15 Aug 2025 17:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A988E0212; Fri, 15 Aug 2025 17:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B98A78E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:01:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 843671173D6
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:01:18 +0000 (UTC)
X-FDA: 83780212236.22.A5357E4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2CB4614000A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:01:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d75MyhSf
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755291677; a=rsa-sha256;
	cv=none;
	b=HToyMG6JuSeF9/OjPmc/g8PZA7F9hzQas+tm7RjdTF4YQeci4zhCA5I09rTNblbAF365ya
	FgQ4ZzfkVJ4VL0QfYP+O30kNwJtSewYuHSF9PabDC6gFswlFkwvBEnxG7FQtu2zFVwbqQm
	n0M5Iruww+YCvcQkRa/NhvOC7M3KJR4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d75MyhSf;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755291677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsEgOfYReDOh4IeScG+w9uvaCMnr2rBubqG/o9UxO2E=;
	b=OWCcOMp+PhUc5sYkdCaaqUZX7xQzsZAjl0HiYwTb20kGTdLG0TzJTnefA+ell+c5hGHinB
	AyOMn6WLVZzrWMESvgqUMtKLtZR/u7VXQHhgnjjo7lyg8NLtAsquhbxELpwURrgGEVKieA
	XYHzYCAbRUyq2cGTDZTGBD6pwnTKYJg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lsEgOfYReDOh4IeScG+w9uvaCMnr2rBubqG/o9UxO2E=; b=d75MyhSfylaCxBv15mdMmnc/s+
	BC717glqDCRGangpTzifcmjgJ6cvDfemaN4bsdJGaBarD0/hLuG7j035DoQ7DppH03tZUNUqkvOUy
	4DPDDXKdtGlkr8AVjgoaxQSbY+5VBi1kj0BcvN9+772k+l3eNNSMKVCDeXU1Jy0H4096RPgFzyNRB
	BgKPqAAyQfQ5sOm4flkDa2/LD3zCTvRJQFR5uWKJahRRwJx9yttwlIjyaeV4lCUia6KyuRMpbC7AE
	aSlyRBlru8S0G1u7rz9nrAT8C0q3vnpKvXHIzpQw+qlxG4G8EkA/y8ZbAcZQiiCXpQbTdtZovSkd4
	4btEHRvw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1un1Y1-0000000HaoN-3DCg;
	Fri, 15 Aug 2025 21:01:13 +0000
Date: Fri, 15 Aug 2025 22:01:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression caused by commit 4687fdbb805a ("mm/filemap: Support
 VM_HUGEPAGE for file mappings")
Message-ID: <aJ-gGXNwOMeLBs0W@casper.infradead.org>
References: <87plcw8lyq.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87plcw8lyq.fsf@linux.dev>
X-Rspamd-Queue-Id: 2CB4614000A
X-Stat-Signature: jjj63fhdcc6y5pozn6irpy7noe1cdoc5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755291675-860768
X-HE-Meta: U2FsdGVkX198blJBQUIdBGbMvJsNBI5RWa8UkeIEeHYzQNyN+knYXHbDvegMyWuT8gXWTILde07c7Lyb+77LBRGnwO/NBUfE+n2V34Wd6mIX7DpwgxVSzJNUKYW+Yug5r1yJHqoDJMzwCMXBhvybOekq4IbVQIljfq9Y6MuXsmdWWl9Vx1YeZ4qyLPzWFJDNTMQ7To5DJDMVIKkXB7rpL+tOeswhYh+0712LWcQkigkw9LhPWH4RcDthEhiCOFXjR35sT+MUtX0GHnc0LGG8Ttx3o1SxJFzHIloXc1xow+7qIfBhGrw3nijgQfqM/mQrCPO1++R1/Man5JLvdjvdKBLvbIf7y4XbVz/YpTpXdYiCiUmarwXbZgct/nZqlPFoNkPmRiBie8BGkKcqsXIhJAyStZQ8bjd/b5hh0/uyrX7i1dIo/6b0odBGIsVfN1DYZdI9/9ccFVKxeZ5TqotXLZrumviSjYll9jqfX6RCJ/peifcAZ4v8j59xXl+/AMOa/YDXvT8X4nU5vV9DDEsIMg+mE4VgeOJxwWHQsrNCKb6T+UdgnzGic3aEWkEMa0XXypJZILwlXGIDo7r4m10ks1DVSOVpiBAEB1VJ/Tn4Ec3q3Yf6jaT8SLgZHEjfd7otnwIK176JfwkJ3Ujz2cxkFa/v0tCdxdwHUCy/5xIfYGd3yhDc/YQVoM6XXareSvOrtC9a0btIxUptVPCTdF6061i4e1tQGWCsfE9x/n/lrQjtZ+qDPKyyvwIPVK2ngmn8srUKxv992xF8vGQ0U9MKsfVMzMP/OWbfPGD/S7z63qvpateMVi2lXjROaloWVbOa14/CwjGAm4Gykqnm/Kul8TjqJ9Iq+EtKc5MJ514H4JOCJdMbhkGph6Lk2tlgdKb5Nm7MVUkL3fR42vrDp7o68fYf9UVb8S3gk0capl/LnOmDH19ZwhtVBP9OlfoZfuolOISqULKpdq2gJaio2eT
 BguxGSz3
 AFG4Gu/wmReyPoq/JpWJiVcWGdJ1ZxiHOoaw2pBUFy1MlYoE7+tglMqhw19S2ph+j0xeAclHlrJFBcVrfXeyIpIxoR5/pNbzIlqop0QYf05UrK2L8Z7APRDJrpKL5kTlvTIiOBLsIyIQNRMOc9iSFGnhOjm1zOJn2QakK6BMN8/64+1OKeL0Y53XBLMiVbV5KnnoUmDUSleh4mS/MVx4hneSK7bgPrblHmh0ypPriTovQAs2dBnBJ3c4MERb/PP3XG16vgDQSGE78qLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 11:43:25AM -0700, Roman Gushchin wrote:
> The commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file
> mappings") causes a regression in our production for containers
> which are running short on memory. In some cases they are getting
> stuck for hours in a vicious reclaim cycle. Reverting this commit
> fixes the problem.
> 
> As I understand, the intention of the commit is to allocate large folios
> whenever possible, and the idea is to ignore device-specific readahead
> settings and the mmap_miss logic to achieve that, which makes total
> sense.
> 
> However under a heavy memory pressure there must be a mechanism to
> revert to order-0 folios, otherwise the memory pressure is inevitable
> increased. Maybe mmap_miss heuristics should still be applied? Any other
> ideas how to fix it?

What's supposed to happen is that we should have logic like:

                        if (order > min_order)
                                alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;

so we try a little bit to free memory if we can't allocate an order-9
folio immediately, but we shouldn't be retrying for hours.  Maybe
that got lost somewhere along the line because I don't see it now.

> Also, a side question: I wonder if it makes sense to allocate 1-2
> PMD-sized folios if mapping_large_folio_support() is not there?

Um, we don't?

        if (!mapping_large_folio_support(mapping) || ra->size < min_ra_size)
                goto fallback;


