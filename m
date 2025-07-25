Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B36C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0D26B0096; Fri, 25 Jul 2025 11:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A996B0098; Fri, 25 Jul 2025 11:38:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D217B6B0099; Fri, 25 Jul 2025 11:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C35536B0096
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:38:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7638A1A080D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:38:10 +0000 (UTC)
X-FDA: 83703193140.29.FC39CB0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2C374140005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:38:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jU63o8H6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YduZZemj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jU63o8H6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YduZZemj;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753457888; a=rsa-sha256;
	cv=none;
	b=OqEVKsmPtLp4GH9XpgtI08kXqR2c6Pvh40d3b3tWc1oyKE9ZpTtMAgMhC+WhbElKV+vh2H
	I4+jVdqOHMEhTlNQPa2yEJV+ZQ+2pe44uZbTyHa627pZwFeJmpwkUUCvt84Qe4jSyYL99J
	TzIXmTOL0BIf3rmxTl8JmBbVotFVHuk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jU63o8H6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YduZZemj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jU63o8H6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YduZZemj;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753457888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6V8dlxI5N0x3RCAaUdHAjtLVSGrpxU1om7131VAmWE=;
	b=sPfF4/ppu++4DKxTUdkmjJ2HWQ5u17UgC4R11B7pSy5dKYqfsvIPDqHL+KBYn2vhCRYZT8
	w8xrlunQHDpE6x5Bp5qGX/BlReYBnLa+gxYH1okDCeQLBSuNJ9JOUalRJEA/cxgiDKYVd4
	hgNDjuFMeGmj1zS6XY/PgrEQ76+eum0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D49021A16;
	Fri, 25 Jul 2025 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753457886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C6V8dlxI5N0x3RCAaUdHAjtLVSGrpxU1om7131VAmWE=;
	b=jU63o8H65eYOqvR5IaEhiTTYZHWrdT5bBXODEEc80wmY/RAUDbh2DxIxWr4saKQhxeH2vn
	RMkDus4UfqrFtOlv7L9Qtn6mp8N57fC0Rq8LP+8tSoAiQYKjE5tPsABC6VlyORE+l2WcQu
	t6e+KVD6IFF94MRgPxhg+fxbFYE4nfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753457886;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C6V8dlxI5N0x3RCAaUdHAjtLVSGrpxU1om7131VAmWE=;
	b=YduZZemj1T5Q4zM5L0Hz1Uy7on05op+5jS8WB1DS7nVokKtka+aElLXpTygkH8cP6REWl7
	xxAOmJPyb9Y3Q5DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753457886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C6V8dlxI5N0x3RCAaUdHAjtLVSGrpxU1om7131VAmWE=;
	b=jU63o8H65eYOqvR5IaEhiTTYZHWrdT5bBXODEEc80wmY/RAUDbh2DxIxWr4saKQhxeH2vn
	RMkDus4UfqrFtOlv7L9Qtn6mp8N57fC0Rq8LP+8tSoAiQYKjE5tPsABC6VlyORE+l2WcQu
	t6e+KVD6IFF94MRgPxhg+fxbFYE4nfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753457886;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C6V8dlxI5N0x3RCAaUdHAjtLVSGrpxU1om7131VAmWE=;
	b=YduZZemj1T5Q4zM5L0Hz1Uy7on05op+5jS8WB1DS7nVokKtka+aElLXpTygkH8cP6REWl7
	xxAOmJPyb9Y3Q5DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53F731373A;
	Fri, 25 Jul 2025 15:38:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x9MfFN6kg2itaAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 25 Jul 2025 15:38:06 +0000
Message-ID: <1a43ebfa-0c4f-4029-ad81-125aba68b764@suse.cz>
Date: Fri, 25 Jul 2025 17:38:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/rmap: Add anon_vma lifetime debug check
Content-Language: en-US
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250725-anonvma-uaf-debug-v2-1-bc3c7e5ba5b1@google.com>
 <1d849190-214e-413e-a082-d7f862b653cc@suse.cz>
 <CAG48ez23CPO-m6kPaEs8kLUfRVCN+QMbsEn7BocfaJuq=gRwaA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAG48ez23CPO-m6kPaEs8kLUfRVCN+QMbsEn7BocfaJuq=gRwaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C374140005
X-Stat-Signature: zbqugfqsabnai86rc567hoz1ckeewnj4
X-Rspam-User: 
X-HE-Tag: 1753457887-248823
X-HE-Meta: U2FsdGVkX1/2tdKmEnM2NfCsaggkJz85U/Npi6h9tIVTkpqGcuKc1LBx/zI9l0zHYR9vvZyZ9IBpRGj3nv4nkXDjCuqKQkILdZauj04IUTp+lLYv0W3HtphHG2K/UNwWuH2b+CaG5aJwSlSR0mvFbTNPkN6IR5aB77IEeS3+p52H7pEPJ5rggmAOElM1g73GBB6KtCOANOZBGWm/1vaLRoCVKJQoFpab7DRp29zOvFlsZi0qdD7XH4rfy2AlFAn0+hgzn9iM6e0zASxZr7enoXoK8ggbCjvE+V4uThCl6EMRidZve6oi3w/lzHbSV9e0NLVIIYifz8qSwvPXOIj6sJCw85tVilZ2b18hergFf5pPar0DNsOfp+JO9uoNcnE1U5+SsRxPE0+3BGbEFYVIvU70QBYe8hVX7xZFJky6O8824iTJOeOpadDJ5I/qn9gF7NB69SCx5JM6Eh+U56eQXLrp96zRsoqwH07ByeIvhTQ0dDpnyNP/fgSYapvLFcYVKEqxTwcuUWCk2MR/66dJ5DNAgC3gU5Y75MA+KNItE+AAF2+GPBYyQP83+qZh9fOEx7k4hDCapkxt8+QwC6pPAhR6oWiq2xjtzUTfr+NCTL1t3NUlfRd6ZmjzkjSbURzU29U3LmIlSk4/W0SxTYhtDt1suQCpapEGRs8GJZ5hcVuJRkPRHRlWPgU7gsXLzJirwica82JC95EWOOHVX9WSlfxEn1BhLGdZAWyoNPi4OJLliMeDMo3XdlmgpPMwSSn5R8wW4XAaALgCibEDSeXzIZcvejE7TpS5rgXt+wPV5c+Lxn2QTtE1VPj4Mv6Q76n6x6JlGxwqznXpEYKXQ0B0zG4UrwSEtGwrnrE8V0PkVYp/RioVHe/HqrMftFWIvKv06PhGpwQcPXKFnUs29f8v0QUBR/UccAqiy5FB7/PzXG15Mqm5W0PiKyosUIXze/py
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/25 16:44, Jann Horn wrote:
> On Fri, Jul 25, 2025 at 4:11 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>> On 7/25/25 14:16, Jann Horn wrote:
>> > If an anon folio is mapped into userspace, its anon_vma must be alive,
>> > otherwise rmap walks can hit UAF.
>> >
>> > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
>> > walks that seems to indicate that there can be pages with elevated mapcount
>> > whose anon_vma has already been freed, but I think we never figured out
>> > what the cause is; and syzkaller only hit these UAFs when memory pressure
>> > randomly caused reclaim to rmap-walk the affected pages, so it of course
>> > didn't manage to create a reproducer.
>> >
>> > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios to
>> > hopefully catch such issues more reliably.
>> >
>> > [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com
>> > [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com
>> >
>> > Acked-by: David Hildenbrand <david@redhat.com>
>> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> > Signed-off-by: Jann Horn <jannh@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

>> > ---
>> > Changes in v2:
>> > - applied akpm's fixup (use FOLIO_MAPPING_ANON, ...)
>> > - remove CONFIG_DEBUG_VM check and use folio_test_* helpers (David)
>> > - more verbose comment (Lorenzo)
>> > - replaced "page" mentions with "folio" in commit message
>> > - Link to v1: https://lore.kernel.org/r/20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com
>> > ---
>> >  include/linux/rmap.h | 22 ++++++++++++++++++++++
>> >  1 file changed, 22 insertions(+)
>> >
>> > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> > index 20803fcb49a7..6cd020eea37a 100644
>> > --- a/include/linux/rmap.h
>> > +++ b/include/linux/rmap.h
>> > @@ -449,6 +449,28 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
>> >       default:
>> >               VM_WARN_ON_ONCE(true);
>> >       }
>> > +
>> > +     /*
>> > +      * Anon folios must have an associated live anon_vma as long as they're
>> > +      * mapped into userspace.
>> > +      * Note that the atomic_read() mainly does two things:
>> > +      *
>> > +      * 1. In KASAN builds with CONFIG_SLUB_RCU_DEBUG, it causes KASAN to
>> > +      *    check that the associated anon_vma has not yet been freed (subject
>>
>> I think more precisely it checks that the slab folio hosting the anon_vma
>> could not have been yet freed, IIUC? If the anon_vma itself has been freed
>> then this will not trigger.
> 
> The point of CONFIG_SLUB_RCU_DEBUG, which I'm talking about here, is
> that it allows KASAN to catch UAF once the anon_vma has been freed and
> an RCU grace period has passed; it is not necessary that the slab
> folio has been freed.
> 
> You can see that working in the linked syzkaller reports - KASAN
> tracked the object as freed after slab_free_after_rcu_debug(), which
> is an RCU callback scheduled from kmem_cache_free().
> 
>> > +      *    to KASAN's usual limitations). This check will pass if the
>> > +      *    anon_vma's refcount has already dropped to 0 but an RCU grace
>> > +      *    period hasn't passed since then.
>>
>> AFAIU this says it more accurately and matches my interpretation above?
>>
>> > +      * 2. If the anon_vma has not yet been freed, it checks that the
>> > +      *    anon_vma still has a nonzero refcount (as opposed to being in the
>> > +      *    middle of an RCU delay for getting freed).
>>
>> Again the RCU delay would apply to the slab page, unless you talk about the
>> CONFIG_SLUB_RCU_DEBUG specific path (IIRC).
> 
> Yes, right, the "RCU delay" in the second bullet point refers to
> CONFIG_SLUB_RCU_DEBUG.

OK I misunderstood that while bullet 1 notes the check only happens with
CONFIG_SLUB_RCU_DEBUG, I assumed the description is still meant semantically
from the point of anon_vma users (particularly what "freed" means - moment
of kfree() vs KASAN quarantine). Once considered from the point of what
happens with the object under CONFIG_SLUB_RCU_DEBUG, it all makes sense.

> Here I'm saying "If the anon_vma has not yet been freed" because
> that's the only case in which I can reliably say what will happen, and
> this is the main case that isn't already covered by the first bullet
> point in a CONFIG_SLUB_RCU_DEBUG build.
> 
>> That said, I wonder if here in __folio_rmap_sanity_checks() we are even in a
>> situation where we rely on SLAB_TYPESAFE_BY_RCU in order to not touch
>> something that's not anon_vma anymore? I think we expect it to exist?
> 
> Yes, we expect it to exist. That's why I'm not just asserting that the
> anon_vma is still considered live by KASAN, but also that its refcount
> is non-zero.
> 
>> Can we
>> thus invent a CONFIG_SLUB_RCU_DEBUG-specific assert that assert the anon_vma
>> itself has not been freed yet (i.e. even if within a grace period?).
> 
> That is essentially what I'm doing - checking that the count is
> nonzero verifies that it's not within a grace period, and the implicit
> KASAN check verifies it can't be in a KASAN quarantine after the grace
> period is over.

OK I guess that's sufficient and we'd be unlikely to find a bug scenario
where anon_vma was kfree'd() and thus KASAN with CONFIG_SLUB_RCU_DEBUG is
waiting for the grace period, yet it doesn't have a zero refcount.


