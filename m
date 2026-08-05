Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49BE8C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6279D6B0092; Wed,  5 Aug 2026 05:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7D76B0093; Wed,  5 Aug 2026 05:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4786A6B0096; Wed,  5 Aug 2026 05:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 275636B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:54:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACEF71C0C86
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:54:20 +0000 (UTC)
X-FDA: 85066755480.08.2B1D9D9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 84C6F1A0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:54:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wzR+ohd4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0NO3IQ4x;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sfuHkkSY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OyGd9H2+;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785923658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CU4WpIubcpWK9hCH2PEh/5TTaHzVeki/xiz4teIymqk=;
	b=oy2RWps7eNMgKCWL+0oIbdHItMoFJjC7EVcvVmw6WMAImhY2Ic7RZCj6iivpVePcFX4rBx
	fhCm+fLtnWBFkCS0K1KOMTWMuOvletCvnMa/SnLKoaEbnxdqhiMGb9d6jVlOIAKwt8Tlq1
	i4qe8CUj6VZKm+8zTCP43R6ldXuoUTc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wzR+ohd4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0NO3IQ4x;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sfuHkkSY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OyGd9H2+;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785923658;
	b=k+FA2qpqE+h023dzk6t8HI0HxnciVBLNq+oDpg9sLJTzxhYhnXqnav0VC6WCtgFVon2cSM
	CTAgOO1HFVFGqj13FEBajpJfuGn2FhzyIPpMwPIQ8nxPQcPykKzeY6qSLadNPgR7KXvBCD
	i2vrBs9wi6rQ0l47N9AYwE0McAwkZvo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E35817FD43;
	Wed,  5 Aug 2026 09:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785923653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CU4WpIubcpWK9hCH2PEh/5TTaHzVeki/xiz4teIymqk=;
	b=wzR+ohd4v+0lgQWsYVhJoHKuZEtEb3YNwJc3v7q8zHLgDVW4LNwaXDrXwWIpNBFvtlK4Mj
	TKoKJO3eGxFZFt+KE9G87nTZpQhcrz1VGNbvP2VnMvCS7Rs9WCoI3nygsN7hvZ2XNO9V/b
	w0zcXDOVtiV3ZIsR0/uj9pv0VbIowqM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785923653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CU4WpIubcpWK9hCH2PEh/5TTaHzVeki/xiz4teIymqk=;
	b=0NO3IQ4xJEXNmoj/S5jhj6eu/u4nn6+Hww7p8Rcaf6NIkFyJHxb5+ggX0+7QrXFe3cTYaZ
	BY/vkPKrr8vVfjAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785923648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CU4WpIubcpWK9hCH2PEh/5TTaHzVeki/xiz4teIymqk=;
	b=sfuHkkSYBH/rMYK9Ymy4w/oFuE/D0G/iXwSNRfeVql/WBcnVstNmrxr04BS1enCpHmVVeM
	2t3u0+WlVHt1sG3GP4x7Yh9a4D3BVInpfVYmHLxHpBLQuBgvnFYLIAZItUdgpCmRDbP52k
	x780PSShWatmHhVTu0TKjUxoZm6GEIk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785923648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CU4WpIubcpWK9hCH2PEh/5TTaHzVeki/xiz4teIymqk=;
	b=OyGd9H2+JlMMeeivriHeQILv068qUPXI16OSZOsL+0ColwikZcoY/8I86KN0BqQvpuUhe1
	Vlk/VTgRxbyvOLDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFCEE779C2;
	Wed,  5 Aug 2026 09:54:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wl97Lz4Ic2p2TQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 05 Aug 2026 09:54:06 +0000
Date: Wed, 5 Aug 2026 10:54:05 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] mm: constify the pte_offset_map_ro_nolock()
 return value
Message-ID: <anMHQn_mBs6DTrZB@pedro-suse.lan>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-7-pfalcato@suse.de>
 <anHJ48Glq8EdHatd@lucifer>
 <anI6BEyTJFzQY-N9@pedro-suse.lan>
 <595fe323-59d3-4f4a-92a3-ac5d67b7461b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <595fe323-59d3-4f4a-92a3-ac5d67b7461b@kernel.org>
X-Stat-Signature: xcowqcum3c8qchphyxtdi1ha3d5m78hg
X-Rspamd-Queue-Id: 84C6F1A0007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785923658-547537
X-HE-Meta: U2FsdGVkX1/lK0pKp2G7mS6I2qbVfA6NYOxV8Ewv2gv9CkVzvakIJkVmhHmecOZaMNRQzZgPuQt+L95jjq7GUpj6cQ2l2zrXO4EVnkLDalwEwcDxUvEk/vnM6Jn59GpxSTJGNWH+jjWCT0YubdTBvJ7550b9oJaEgLmUF/rX0WT3S5OctuT3RjreMk4uwF8zXD8WSS1c4Qm/5PVtrFD4qLBS5VVGIUMqnoLqmjMASG7XqE10h3e7lWMM4YYiTz6ds/lx8k2TypSWJ+KD9mrf5gVCd2Cr+9WguRRYNJuyV28Qt+fCDQiOTEqqkcrraMMqC8mBZ4Szue5FpIZXbIn/B+oLe+WRH8SUCqT3gyw94zlmehDPeYijzGIy6bvW1OLs+wjuJPGQ9v2gerK5pr/sVUqzoIosCUmmg40DgoVjsG4pV+A/OTYb4CcjHo75hTK5c0Str2Exz8ZEjJ6HGkOZBXgKmHYbQ/fF5Fj40iNogxGXB4fKY/iylGjv7n1ShGWaH9H/esh6oDcAfncNC33CCb9dwKP8l/nTip/xlKEgCDsZFq//efRXhetynJoLePuxABEwfSnyiq2nyVAi790TdiBDsGx4Y68qzGH/t6kR+VqSE7K/aHks89nyJuG+eQRcfSXiI/jw6EZst9giIznGUBMK9pV24NfRdtGh09hmF0cHX586c1QKNn/4qWCqGBXWHhCnSWEs/Fc1wj3VS7giLYCjJbr3utZKRzaVFcUnUyxEnONs5UZ5tpvG2gvY6mzgd4LUgUGjdP1VjAYwbdZy2XdCxUtfnRk0ewlYKKv2n/9t1xN0KHy0BjPT/lVB+m2A0d1ag1z+etPTIKrXONbqyZsw7+4pIlm/hy6M5C2zN96QakPWZ4AkyG7eH/72qXRF8RzAuNW6vLKXDiUmNwhqxRXXzPbeCyw4rhkEbbI3HJi+EwSsU8DXkT0ss2HU96b6k/XQeGpqA3WwQC4a3JQ
 YeV9CR+O
 qqpL+TmDX1sIjc+gglo4L9TZjfMvxrVTCkFvQo36EnF6dr+F83SkJyMwWNo2GCS7ySzGVPorSSDUJQmxeDwa5zvPK7Peqn3UIiY8U9aG98EDv2BhSqHE5eQ1FnFX1GSFu16P2cJAZS9GIH4O5gzDzljkhhsQHvTHphLTFYDsdNfyRprVqgh/44FYoWkGR7srAVgLS5oc0nMVSASRoUlKH4Dt2Qk5tDFjlnDezDktnmhpQp0cRE7OjSFrU3op1PuAnHoJLjI7No9vHoQX9exxLqmYh771hy4VVyBSOOEywWnvotrTVLzQBQbFmlBh7ks/vs/e88csxpdUwEC1Yrn280ify9o4pziQM5H5d7o4bsCf31z7FakPKJbsm/d5nqtP/E3Trugmjwl0o98N3Uvcg+oVGFt5GEKR2vQwV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 07:58:02AM +0200, Christophe Leroy (CS GROUP) wrote:
> 
> 
> Le 04/08/2026 à 21:22, Pedro Falcato a écrit :
> > On Tue, Aug 04, 2026 at 12:22:19PM +0100, Lorenzo Stoakes (ARM) wrote:
> > 
> > > 
> > > >   			if (!pte) {
> > > >   				mmap_read_unlock(mm);
> > > >   				result = SCAN_NO_PTE_TABLE;
> > > > diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> > > > index b91b1a98029c..2cfc6e608ef4 100644
> > > > --- a/mm/pgtable-generic.c
> > > > +++ b/mm/pgtable-generic.c
> > > > @@ -308,8 +308,8 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
> > > >   	return NULL;
> > > >   }
> > > > 
> > > > -pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
> > > > -				unsigned long addr, spinlock_t **ptlp)
> > > > +const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
> > > 
> > > Can pmd be const too?
> > 
> > I was going to say "yes but then pmdp_get() also needs to be constfified" but
> > actually no, it can't:
> > 
> > pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp) {
> >          if (unlikely(pmd_bad(pmdval))) {
> >                  pmd_clear_bad(pmd);
> >                  goto nomap;
> >          }
> > }
> > 
> > so PTE mapping actually needs to write to the pmdp if the pmd looks bad.
> > Tricky stuff :)
> 
> But if pmd is const, can it be bad at all ?

Yes, you just need a stray write or a bit of memory corruption and it can
go bad. And then we need to do clear_bad() :)

(it's unclear to me whether this is actually common or useful enough these
days; the way this was explained to me, page tables can be best-effort
redundant; but it's not like we know clearing the whole range is ok, and
the way pmd_ERROR, etc work they don't even communicate to userspace what
happened, unlike normal hwpoison mechanisms)

-- 
Pedro

