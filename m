Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21332CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7A66B00F1; Thu, 25 Jun 2026 07:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEDA6B00F2; Thu, 25 Jun 2026 07:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EA56B00F3; Thu, 25 Jun 2026 07:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68D886B00F1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:08:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F29091C60B8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:08:25 +0000 (UTC)
X-FDA: 84918161370.23.4C486B8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id DCB15A0003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:08:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iRdaiodj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xL1LFzS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iRdaiodj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xL1LFzS;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782385704;
	b=XojXIxQzDryfBueZB1lUSMTpdZZ8aJ8cypr2wwHancTI/S59RZzdRP/CFtYaWxkr7CEWOy
	lU0HqBBLvvQAu3FQi2+swtqTFxinL3zFKS8rdkZFM0DO5V//6wU4ZmYb6P8o7JFs6AXUwu
	8rVefLxIgcq2UBObqSH7psqABS7f9Ag=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782385704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwkdMTiWvugHzs6IrfwENFnQsqfzh/B/fPgY7/p+aqg=;
	b=Z6c26QQ8bqu4HQckDL4Xt1C4dAEWfK4ydYWZB/982O8vDxRnjfscAvweRRYE+nu3np4Hnp
	JYERrSjXOPoVuZn6b9foecdymQBnEH+OtUXWxKzbyTGLwJj0WnquvnfAQ4Wb/XR3TgF0Ir
	6pzqKT+2n/cu5Wfu35Dd/0mD03iozJw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iRdaiodj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xL1LFzS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iRdaiodj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xL1LFzS;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 82E8376152;
	Thu, 25 Jun 2026 11:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782385702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mwkdMTiWvugHzs6IrfwENFnQsqfzh/B/fPgY7/p+aqg=;
	b=iRdaiodj8qDBymIYoSzwBEVI61jLDNU5NLg2M+6WXFXyOEzuENdABASAeFX4wTBraZzWu1
	B35DDE5XDhG8A7DoulB8e4VYfMwXlFrGVpi4SfA9y66+ro069gR74z0jX8OaV6HzEKUsB6
	2z/h2ERdQ1AZHKRLJrQw8AjpuxkLYkc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782385702;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mwkdMTiWvugHzs6IrfwENFnQsqfzh/B/fPgY7/p+aqg=;
	b=9xL1LFzSm3A0Jjgc4VfxgObjF02/JzMB4Qp81cThxnbaR05ExOIqz/HVJHSRn45z3pYzp9
	ZmouQBHI0RZeXzBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782385702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mwkdMTiWvugHzs6IrfwENFnQsqfzh/B/fPgY7/p+aqg=;
	b=iRdaiodj8qDBymIYoSzwBEVI61jLDNU5NLg2M+6WXFXyOEzuENdABASAeFX4wTBraZzWu1
	B35DDE5XDhG8A7DoulB8e4VYfMwXlFrGVpi4SfA9y66+ro069gR74z0jX8OaV6HzEKUsB6
	2z/h2ERdQ1AZHKRLJrQw8AjpuxkLYkc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782385702;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mwkdMTiWvugHzs6IrfwENFnQsqfzh/B/fPgY7/p+aqg=;
	b=9xL1LFzSm3A0Jjgc4VfxgObjF02/JzMB4Qp81cThxnbaR05ExOIqz/HVJHSRn45z3pYzp9
	ZmouQBHI0RZeXzBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C8BA779A8;
	Thu, 25 Jun 2026 11:08:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VjL6GiUMPWrVUwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 25 Jun 2026 11:08:21 +0000
Date: Thu, 25 Jun 2026 12:08:19 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Samuel Holland <samuel.holland@sifive.com>, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: mm: opaque hardware page-table entry handles
Message-ID: <aj0JU-AzsEQBOiQ1@pedro-suse>
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
 <ajwuKpSnElvwIyhC@pedro-suse>
 <66310292-f618-4497-bcaa-2a4b1240566c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66310292-f618-4497-bcaa-2a4b1240566c@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCB15A0003
X-Stat-Signature: n91u9un1eosogj1k6745kh39nu97e9in
X-HE-Tag: 1782385703-951100
X-HE-Meta: U2FsdGVkX1+cd30/x+zYFRsfyk3eVd3VvU6/throaXF/TLNpM1st3eR3e2jMJWAchYwyWGJYpmE7y6zkm520gH2+6kxViXzBXAOj0+O+LMSrOEvizA+29grVPq1pkYW+IuYc6Ky5gWjgC8Nlm4dQlik0kaN16GK9rs4b1l4fhgtYciMPivKwjXAK3sFSBkeqgdUER+6hgQgB5V/uQkEeVnooDPJMBGKw2dGFgI90IX2zMdKDFDCb8yKUwYrSpl2CVJC37LojTvUX42ihUx+3AJNw+th+j0aS4xhTQBSAr1OrGSMcSqK2CMGiQ0/WTzdztAXkD9Ni41kTsRmu8WjwgPn0aB1w4Kd0sca6FVOl77CatyREWIHNcJdASsCnMvcNFsQJwPjDN/xIzEsa+mny1zqnneD1kdiscq5r6UTTA2oK4Tn/GElufo1LS8za+zVvefewye7GV6NR23vogSpFMvaxtEg4Ovs5bVxkyghq7Tsh0poKJyYE22ZFIx9RwRhZblF7K4bG1nqFs5FfWTZ/HCKzhhAb8uLZ6rjP8d63L8TKXCtY/kIDN6uglnOJ+OHc1z96bkz09LMUr2814NamHPaKvFrFaoAH4lhmMMocsQLQv3F27UkQomdpkgrw61P9fCgZMyOvOCI3I0UXMH8DngcMymZjNciquvxPxg9kF9vZs9m/R7X/aTwsIfbvPcuyyhZCvo0HfaflRBAWucsWk6fgDK2rwe27myBQyoyhdeJxdj2DbAd6PzuTvY04ywpOmqx3iH3Yj6LG09GbMJXl0dWO34Sa4wLoVXw7sjtpCGsaolFsLrENPVvt1ZV7SqdT9iERmeldzPDCGEcClHiqKZR/5jmI2Q7CEa2E/aA67fGToMUw55L9oSg5bqq9h37hUqqNiAg5iJMvEaHZNWihdCeJmhSlKyaDYzvadoeABaKiKu8WecxPul0sGUWVYXfykHyrk1034MQhfb9B+er
 /FEWlnpf
 ByJTxgkcY3K3Tpek74qEdzE/6JC/ePyOCIpofTETY7s+z9aWrNC8MTbT08NNSwBlxwN7CldmNkSYSpurWepIpkGd/nFYwcAjCSmaWPffmKfzhm0Sz8zqtjNjzQiBYysIX5aul79gTjDAT9jLhapWcaNx4TSW1vYHDscokjY1LFp3os6DlWE6vKR6FDFFdOKcGvageeSsVvSZPBUqyseJOnReBnSkSQUd/r2Vol3AxM/C2AtcYwKUo2b9ROKDXGKZjBqysyb8qKBXT7UQftkmRc4wrselPeDYe/0zAB40uer8mtZ5oloAdvLEK1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:50:28AM +0100, Muhammad Usama Anjum wrote:
> On 24/06/2026 8:25 pm, Pedro Falcato wrote:
> > On Wed, Jun 24, 2026 at 03:09:08PM +0100, Usama Anjum wrote:
> >> Hi all,
> >>
> >> This is a direction-check with the wider community before spending time on the
> >> development. This picks up the idea that was raised and broadly agreed in the
> >> earlier thread (Ryan Roberts, Lorenzo Stoakes, David Hildenbrand) [1].
> >>
> >> The problem
> >> -----------
> >> Core MM code reaches page-table entries by raw pointer dereference (pte_t *,
> >> pmd_t *, *pud, ...) in places, implicitly assuming a single, uniform
> >> representation. Sprinkling getters wouldn't solve the problem entirely. The
> >> problem is one level up: the *pointer type* itself is overloaded. At each level
> >> there are really three distinct things:
> >>
> >>   1. a page-table entry value (pte_t, pmd_t, ...)
> >>   2. a pointer to an entry value, e.g. a pXX_t on the stack
> >>   3. a pointer to a live entry in the hardware page table
> >>
> >> Today (2) and (3) share the same type - pte_t *, pmd_t *, and so on. Nothing
> >> distinguishes a pointer into a live table from a pointer to a stack copy.
> >>
> >> A pointer to an on-stack entry value and a pointer to a live hardware entry have
> >> the same type, so the compiler cannot distinguish them. Passing the stack
> >> pointer to an arch helper that expects a hardware-entry pointer compiles fine,
> >> but is wrong - a bug class the type system makes invisible. It also blocks
> >> evolution: an arch helper may need to read beyond the addressed entry (e.g.
> >> adjacent or contiguous entries), which only makes sense for a real page-table
> >> pointer, not a stack copy.
> >>
> >> The idea
> >> --------
> >> Give (3) its own opaque type that cannot be dereferenced:
> >>
> >>     /* opaque handle to a HW page-table entry; not dereferenceable */
> >>     typedef struct {
> >> 	pte_t *ptr;
> >>     } hw_ptep;
> > 
> > I don't love typedefs that hide pointers.
> Nobody likes them. This is the only way so that by mistake stack pointers
> don't get reintroduced. Its also hard to catch such cases during review.

That's not true, you could have:

typedef struct { pteval_t pte; } sw_pte_t;

and

/* only usable by arch code and whoever wants to interpret these
 * types */
static inline sw_to_ptep(sw_pte_t *swptep)
{
	return (pte_t *) swptep;
}

and so on... Also, see Documentation/process/coding-style.rst 5) typedefs, it
explicitly warns against pointer typedefs.

> 
> > 
> >>
> >> With this:
> >>
> >>   - a stack value can no longer masquerade as a hardware table entry,
> >>   - a hardware handle can no longer be raw-dereferenced,
> >>   - cases that genuinely operate on a value can be refactored to pass the value
> >>     and let the caller, which knows whether it holds a handle or a stack copy,
> >>     read it once.
> > 
> > Just a small passing comment: how about doing it differently? like
> > 
> > typedef struct {
> > 	pte_t *ptep;
> > } sw_ptep_t;
> > 
> > or something like that. Were I to guess, referring to a pte_t on the stack
> > is much rarer than all the pte_t references to actual page tables. But maybe
> > reality doesn't match up with my guess :)
> We want to fix the current usages and future usages as well. sw_ptep_t can work
> for current usages, but it'll not force the new code to be written using correct
> notations.

I don't understand what you mean. pte_t is a perfectly correct notation,
it's just currently maybe too ambiguously overloaded.

> Apart from different types, another benefit of hw_pXXp would be that
> it'll become an opaque object which only architecture can manipulate. Hence
> architecture can decide howeverever it wants to manage them in certain cases.

That's already the case. pte_t is fully opaque apart from the little fact
that you can declare one on your stack. Introducing a different sw_pte_t
would further reinforce that. And if you want ways to find raw derefs on
pointers, we can simply slap on __attribute__((noderef)) (available in
sparse and clang) on those types after sw_pte_t is introduced and pte_t
is unambiguously a "hardware" PTE.

I dunno, I'm not convinced that changing around ~450 files is worth it, and
_if_ we want to do something like this I would strongly prefer the way that
is less churny.

-- 
Pedro

