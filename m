Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A53CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA25E8E0003; Mon,  8 Sep 2025 06:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E519E8E0001; Mon,  8 Sep 2025 06:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40628E0003; Mon,  8 Sep 2025 06:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAAD78E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:28:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83B2C1DF72D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:28:06 +0000 (UTC)
X-FDA: 83865707772.24.C34A304
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id ADBF44000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:28:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UMAyGG5T;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757327284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QstgO/h652tnHFsITLWw6M/Son5KgedEpVG+JcbZcbs=;
	b=3gAvdl3JsOpmBhxw8LFs9KyxLuQmLC7WS12PLJ6AQAp2VVmBzEbHYYLmXB+Ljq2miSDkZL
	tOm9jY05ie4Urd3T0iSMPum13RS0JxrhWv8/waLGM+cWV9YqJQAVeVcVaIZ6yQ71hogxPB
	ZKg4X8Bh4844/8BuBex4i2hixKNa7J0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757327284; a=rsa-sha256;
	cv=none;
	b=qvRAkD2Mm8StYcKFaCpoPIlWrjkk4J9mhFlxrCF7GjU+kBrelohTdYjHKBE+j+FY9b5we5
	ho4CbBt50HJ5oe0TAB21xWaK+6LBasVDQyTx42pu7/4t37tN0Qf+PMFOveVOHYpxyBK7xQ
	Uf2LmI+0c/rllk92AjTVs9+sBY4wezY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UMAyGG5T;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-ea0848f6244so683700276.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 03:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757327284; x=1757932084; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QstgO/h652tnHFsITLWw6M/Son5KgedEpVG+JcbZcbs=;
        b=UMAyGG5TmvRMsmGMJFZJJJTBN3tjT5zDnQFC+vpE0e19N6SxBYySmESz8PtIsRuGg9
         F7181Hay3dmnf78JfDoJNiXxZWvohbToZjWym59BptvdBkk0bnepAwL87UWNs1BwUviT
         AXOLKkXPKQ8TNMAxrMcW5l5SsTNmDtqZG7mFlMnHhvkWtLatcSwUtHvitxeLYOjXPeL0
         t+nVf8xtaQCD1dVjlR9bMLalKysAKIoDFxYR5+6UMjuleJRkHU0Ops4JDocnIMFyG2DQ
         eHIhDoq7Ih4TSNM/k2VMsjmYcIskvhI6G77erCJmk9e8724KOBQlQJOoiv7CO6x0x2AH
         R//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757327284; x=1757932084;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QstgO/h652tnHFsITLWw6M/Son5KgedEpVG+JcbZcbs=;
        b=NGzaa57Eira1B5dT9Kmm0qiXinuEUlP8XZJIgqIuI7DhhcElGY/8+/h4r/YVC+RD6a
         xMXpa8gkitcOJ+jV7ZkwtKwRoKesPS08IVVlfqjmUoKzOSr2A07fHWn6rHhCcq8Ahz4w
         qOKLZ22N0H4KjtKG3rTp0iboQW2CkSiO6afUqMi5OiUWw5aAEvzDz0bdyIv82Ar7Mih/
         mYWLnV0FIjIDAqbB/4Vc+KsJ1rF1B3yrLO4bpnrVmbkVNyP6iSsoyNeNAXpPuClNxCBq
         N0bENrDcZHECEfRDl+67U0dqTygmeHTSfP02Lo8iLATN9vKs5O/N8ehHI+z8t2KM7kcT
         u35g==
X-Forwarded-Encrypted: i=1; AJvYcCXHzqd/uMxEPCKKpfMX2LFg027u1ygrEmGtzRA9Q+7xepuKUB9dsANd/uWusvH3ESvU+xfay13XLQ==@kvack.org
X-Gm-Message-State: AOJu0YwZmDDo3CHv9Gg8STqJzHnRFPzTUrvpgPKMIF9ZYACVYDteGxqx
	4iYaC8idX6FsfEqcGSgpDhd6ICzrrvCQY3H0Zepv6GYizhVAdtSHXIAWo3AkqKbieA==
X-Gm-Gg: ASbGnctyXgBVb/l95FQzHw/7NuxHwtu58kDQRB63Fn/SN9YpPNe9yrzSxMpr1MpHXqE
	q9oDwMeSgkZC6gRMF3EBq1yxrQHdBpIKCzVl52i9xIJMemLyKhWyXJUr/HCHZwMuSZL5d0hOr92
	X6q08foDN2oWW3zFbleH76CJ6QS0AvTyZl+zvtdWZw7PWzWKvOIKVwPVv3bRdtyUi5JICCmBKb7
	u33AwmmDV97nECaHSeqfGAHKmvN3v455QMpLq2JBUqz8JMLGno8yZhjpwGP+VkOephTcViEiPi6
	eaAQRzHQ8Snj7G2p3S+I4s0gWM73f5u9Rh2nqI9oqrvFbxKQGLAiL0413t7ltaF2ouOCy/wuf1U
	COUJuIWk+kkzNsMvEUuclzVvhPDYCN3nH4u7bjNMHU0o7kkIbERqAloI4bNsGMHG8/SViml5Gh4
	zdiqjh6eOKYLE3Ng7/vrq9ezbn
X-Google-Smtp-Source: AGHT+IEG0zC/H9tZD5Bx0cYfI7uzkElpcV9FNOtoZ7SRGcnoij3YDPgfHLSxfLTqn763yITqfrPidA==
X-Received: by 2002:a05:690c:368e:b0:722:7d35:e08d with SMTP id 00721157ae682-727f2dbf41amr79303667b3.10.1757327283278;
        Mon, 08 Sep 2025 03:28:03 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a85ae667sm51092367b3.64.2025.09.08.03.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 03:28:00 -0700 (PDT)
Date: Mon, 8 Sep 2025 03:27:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>, 
    Shivank Garg <shivankg@amd.com>, Christoph Hellwig <hch@infradead.org>, 
    Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>, 
    Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, 
    David Howells <dhowells@redhat.com>, ceph-devel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm: fix folio_expected_ref_count() when
 PG_private_2
In-Reply-To: <2e069441-0bc6-4799-9176-c7a76c51158f@redhat.com>
Message-ID: <3973ecd7-d99c-6d38-7b53-2f3fca57b48d@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com> <aLTcsPd4SUAAy5Xb@casper.infradead.org> <52da6c6a-e568-38bd-775b-eff74f87215b@google.com> <92def216-ca9c-402d-8643-226592ca1a85@redhat.com>
 <2e069441-0bc6-4799-9176-c7a76c51158f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ADBF44000E
X-Stat-Signature: q9aaqg8ftwsirg46aahxm9nkpkk4rxzn
X-Rspam-User: 
X-HE-Tag: 1757327284-30950
X-HE-Meta: U2FsdGVkX18bDVNvxphrLm9OOzUbmAn6fROhKnHN2r7NnMWYruB63LMKZ6OoNS0djXDNSfvpp1okbV12OCcPIzcWerOYS71srlzkYBe2CIaziD/hrReUjTy6rX2Z4NU052O4QncQdt+/WFQeuohUhofh1q9m4YEt+9q8iX9ELRbGwGlEJkIDi+NRaTTC6uvyF/w0nt/jGcsnfhUYKPD5k8LLL0n+osKmmyD6jKUmwYOULqiAfPX2Pfr4NA8C1ocCJpDW7f4i8Qa6dcsvHaj4xVCSYSgxcHYNf/LCcOYxqmFbd4ON4NnJ69KJ7Km0Ae3OweWsypcsp/f2Xci4KKLQfi21WnBR9vk+3FrwYqWWXLjXeGhwx74apwK5pSFV3N/jAN7wt6tJx7xRZxYtDu4dRRkFRkrxe4IyBzBBuOdPJgO5VcZdGcz68MLFKAwoqvxl/UMqfNexw0Dctea3T754WWhr2LlF1ARrKbdae3D5LqvhY/EbjiU+sl6BVK3Qf6XtRJXKM4utcutDztlvpwE0QIaAa5vDiqelGwRW9reSZUxUJTlHjq/AduxLU1NeXABevVUaV6IRxMXgmB1v9lYIx7AP3RARA0b0OHEL1NBy672qmDq5QfyE8ChiJqBnvSRW5HknRCnSOCbPcPjR7oJUYOisvV0VpzwnUHMWfHSMISlfmzVrUVEEz1lN98Wo9HoiMqHBKlYq73HRITOalnP0fArniC8KVrbeqvRlKuOnrGyPbX6BBCXN7xEgjMl5JU37hY66XH+6T6dQXJjosM+rs1f8Ndi08HZd08KycExooMMJq4VKVVnwLCxGRnLqCNmU3xQBqRfRoLZ7cvqNjoUn1mVEPF3HyvNNsvRxr0Y5ZY/y/jquyrci8bhbGZ5ouaN+LKNs2bp8+AK7MynwiI+avQ3QAAKw3Cn5dKXre8YFzHu9mrcg30vKVcKil1WGvgW5SOpQTS7o8qiRkAKeyyk
 PWf+zBTT
 vreAcYfRK+3G2OMbcwFa+Z+Pcg8aFqhIbczIqqzSDgDfc2Gi7elfbCldQXbYTdEwckBLsToGH1EM0niRcHmY3ITy+bz2XnfQltumbSa22g3xTbOJU55h5rVV/n3LEsRI0DbUxAwncr7S92AEku2lnuZh2+rh83Ou6ZBljDt7WXrE3Pxb7B2lT2T8PbGqM/lp2Yztr4wix9soE/iLFJnrxYiLOgBBj4lAK3Jf9CtwZCFSUVnLCjeKJ8H+yQcaUcj5gZzKH0+QB7tErFRhzlnJ4sUfvdfrZmezAVF3HSKXrDeOV8BkLawdXBhArsmxxZAehZlIRPZaioSuXMiBA7bVG/1M2i8oXG0R4vMDRAdi1tTd/NsdWxTC+8a7CkrZhnqWyiA7FqgEjyc+fEM5lqVlGohvQK6pt4g5tC7lkbkd3ff549dJ28NmCJYH1pSVo2sUMEIwJMDyIyDrXO9Nd86Fw7E0pNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025, David Hildenbrand wrote:
> On 01.09.25 09:52, David Hildenbrand wrote:
> > On 01.09.25 03:17, Hugh Dickins wrote:
> >> On Mon, 1 Sep 2025, Matthew Wilcox wrote:
> >>> On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
> >>>> 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
> >>>> which (like PG_private, but not in addition to PG_private) counts for
> >>>> 1 more reference: it needs to be using folio_has_private() in place of
> >>>> folio_test_private().
> >>>
> >>> No, it doesn't.  I know it used to, but no filesystem was actually doing
> >>> that.  So I changed mm to match how filesystems actually worked.

I think Matthew may be remembering how he wanted it to behave (? but he
wanted it to go away completely) rather than how it ended up behaving:
we've both found that PG_private_2 always goes with refcount increment.

(Always? Well, until 6.13, btrfs used PG_private_2 without any such
increment: that's gone, so now it's consistently with refcount increment.)

Confusing, given David Howells removed deprecated use of PG_private_2
then later reverted the removal: I've not looked up which releases those
came and went, but reverted in stable trees too, so story all the same;
but maybe some of Matthew's mods interleaved between removal and revert.

> >>> I'm not sure if there's still documentation lying around that gets
> >>> this wrong or if you're remembering how things used to be documented,
> >>> but it's never how any filesystem has ever worked.

Not how btrfs used to work, but it is how ceph and nfs work.

> >>>
> >>> We're achingly close to getting rid of PG_private_2.  I think it's just
> >>> ceph and nfs that still use it.
> >>
> >> I knew you were trying to get rid of it (hurrah! thank you), so when I
> >> tried porting my lru_add_drainage to 6.12 I was careful to check whether
> >> folio_expected_ref_count() would need to add it to the accounting there:
> >> apparently yes; but then I was surprised to find that it's still present
> >> in 6.17-rc, I'd assumed it gone long ago.
> >>
> >> I didn't try to read the filesystems (which could easily have been
> >> inconsistent about it) to understand: what convinced me amidst all
> >> the confusion was this comment and code in mm/filemap.c:
> >>
> >> /**
> >>    * folio_end_private_2 - Clear PG_private_2 and wake any waiters.
> >>    * @folio: The folio.
> >>    *
> >>    * Clear the PG_private_2 bit on a folio and wake up any sleepers waiting
> >>    for
> >>    * it.  The folio reference held for PG_private_2 being set is released.
> >>    *
> >>    * This is, for example, used when a netfs folio is being written to a
> >>    local
> >>    * disk cache, thereby allowing writes to the cache for the same folio to
> >>    be
> >>    * serialised.
> >>    */
> >> void folio_end_private_2(struct folio *folio)
> >> {
> >>  VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
> >>  clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
> >>  folio_wake_bit(folio, PG_private_2);
> >>  folio_put(folio);
> >> }
> >> EXPORT_SYMBOL(folio_end_private_2);
> >>
> >> That seems to be clear that PG_private_2 is matched by a folio reference,
> >> but perhaps you can explain it away - worth changing the comment if so.
> >>
> >> I was also anxious to work out whether PG_private with PG_private_2
> >> would mean +1 or +2: I don't think I found any decisive statement,
> >> but traditional use of page_has_private() implied +1; and I expect
> >> there's no filesystem which actually could have both on the same folio.
> > 
> > I think it's "+1", like we used to have.

I've given up worrying about that.  I'm inclined to think it's +2,
since there's no test_private when incrementing and decrementing
for private_2; but I don't need to care any more.

> > 
> > I was seriously confused when discovering (iow, concerned about false
> > positives):
> > 
> >  PG_fscache = PG_private_2,
> > 
> > But in the end PG_fscache is only used in comments and e.g.,
> > __fscache_clear_page_bits() calls folio_end_private_2(). So both are
> > really just aliases.
> > 
> > [Either PG_fscache should be dropped and referred to as PG_private_2, or
> > PG_private_2 should be dropped and PG_fscache used instead. It's even
> > inconsistently used in that fscache. file.
> > 
> > Or both should be dropped, of course, once we can actually get rid of it
> > ...]
> > 
> > So PG_private_2 should not be used for any other purpose.

Yes, ghastly the hiding of one behind the other; that, and the
PageFlags versus folio_flags, made it all tiresome to track down.

I have considered adding PG_Spanish_Inquisition = PG_private_2
since folio_expect_ref_count() ignoring PG_private_2 implies that
no-one expects the PG_private_2.

> > 
> > folio_start_private_2() / folio_end_private_2() indeed pair the flag
> > with a reference. There are no other callers that would set/clear the
> > flag without involving a reference.
> > 
> > The usage of private_2 is declared deprecated all over the place. So the
> > question is if we really still care.
> > 
> > The ceph usage is guarded by CONFIG_CEPH_FSCACHE, the NFS one by
> > NFS_FSCACHE, nothing really seems to prevent it from getting configured
> > in easily.
> > 
> > Now, one problem would be if migration / splitting / ... code where we
> > use folio_expected_ref_count() cannot deal with that additional
> > reference properly, in which case this patch would indeed cause harm.

Yes, that appears to be why Matthew said NAK and "dangerously wrong".

So far as I could tell, there is no problem with nfs, it has, and has
all along had, the appropriate release_folio and migrate_folio methods.

ceph used to have what's needed, but 6.0's changes from page_has_private()
to folio_test_private() (the change from "has" either bit to "test" just
the one bit really should have been highlighted) broke the migration of
ceph's PG_private_2 folios.

(I think it may have got re-enabled in intervening releases: David
Howells reinstated folio_has_private() inside fallback_migrate_folio()'s
filemap_release_folio(), which may have been enough to get ceph's
PG_private_2s migratable again; but then 6.15's ceph .migrate_folio =
filemap_migrate_folio will have broken it again.)

Folio migration does not and never has copied over PG_private_2 from
src to dst; so my 1/7 patch would have permitted migration of a ceph
PG_private_2 src folio to a dst folio left with refcount 1 more than
it should be (plus whatever the consequences of migrating such a
folio which should have waited for the flag to be cleared first).

Earlier, I did intend to add protection against PG_private_2 into
folio_migrate_mapping() and/or whatever else needs it in mm/migrate.c,
as part of the 1/7 patch; and later submit a ceph patch to give it
back the release_folio wait on PG_private_2 it wants.

But (a) I ran out of steam, and (b) I couldn't test it or advise
ceph folks how to test it, and (c) guessed that Matthew would hate
me populating the codebase with further references to PG_private_2,
and (d) realized that this PG_private_2 thing is a transient
condition (more like writeback than private) which probably nobody
cares too much about (its lack of migration has gone unnoticed).

I'm just going to drop this 1/7, and add a (briefer than this!)
paragraph to 2/7 == 1/6's commit message in v2 later today.

> > 
> > If all folio_expected_ref_count() callers can deal with updating that
> > reference, all good.
> > 
> > nfs_migrate_folio(), for example, has folio_test_private_2() handling in
> > there (just wait until it is gone). ceph handles it during
> > ceph_writepages_start(), but uses ordinary filemap_migrate_folio.
> > 
> > Long story short: this patch is problematic if one
> > folio_expected_ref_count() users is not aware of how to handle that
> > additional reference.
> > 
> 
> Case in point, I just stumbled over
> 
> commit 682a71a1b6b363bff71440f4eca6498f827a839d
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Fri Sep 2 20:46:46 2022 +0100
> 
>     migrate: convert __unmap_and_move() to use folios
> 
> and
> 
> commit 8faa8ef5dd11abe119ad0c8ccd39f2064ca7ed0e
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Mon Jun 6 09:34:36 2022 -0400
> 
>     mm/migrate: Convert fallback_migrate_page() to fallback_migrate_folio()
>     
>     Use a folio throughout.  migrate_page() will be converted to
>     migrate_folio() later.
> 
> 
> where we converted from page_has_private() to folio_test_private(). Maybe
> that's all sane, but it raises the question if migration (and maybe splitting)
> as a whole is no incompatible with PG_private_2

The commit I blamed in my notes was 108ca835, I think that's the one
that changes "has" to "test" in the "expected" calculaton; but yes,
8faa8ef5 is significant for skipping the call to folio_release.

Hugh

