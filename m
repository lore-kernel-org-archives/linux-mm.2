Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1288C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 10:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8896B00AB; Mon, 27 Jul 2026 06:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91B8A6B00AD; Mon, 27 Jul 2026 06:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796096B00AE; Mon, 27 Jul 2026 06:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 463096B00AB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:22:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0237A1833
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:22:25 +0000 (UTC)
X-FDA: 85034167050.16.4CFC033
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44B05120005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:22:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsYY3yMs;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785147744;
	b=GAV/8Ur57/s12DKSJtokOuiUAxsrlLMfiNlrF9SmB91H1lvhuXXrvW3UhRnOSG5j2hawJi
	tzzPfFqTNEbuATLvNZdgaFSRgUiam7hjXCUSg0jSJN2NRAKPsN5y9pyx3j8aNw0zrgK8CV
	kNu1wXapHJPp2S8djIMgcypxw/QNnwk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsYY3yMs;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785147744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JnmBgXxFDtCMN2wDB2IoufqkaTKn0f8mfPW/klL5BI=;
	b=xD+Ic8pHio45bnRRuBCmy1w1rjOH/YBKKwp2TN8vdBU/CbCsmThdVzp1yvJ4n0WmY6Mts8
	cDtgpM60OhJPzPuZCffByfJe1bM1D3YBFgIm1YdlKKQyzqcAKIXiXi0XBlNBNLJ7Hvz/7q
	euU8DtUZPw1hTM+Hl9fE0s/7OxCVLII=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0081601EC;
	Mon, 27 Jul 2026 10:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E151F000E9;
	Mon, 27 Jul 2026 10:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785147743;
	bh=/JnmBgXxFDtCMN2wDB2IoufqkaTKn0f8mfPW/klL5BI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gsYY3yMsnWmKGvnXvXG4cAJ9uYD/g70GCEZQyJYYALUaBP30DL0mK8UiL1pB/EbhK
	 nc+d8D//BvpV+fsOKUHm9FDZGks+LTCZNNnpygfauGfGDeviZ7a4Gqo4kdtWxeck/h
	 N5qCMmAK1Dz1wbvXTixVEc38OGcBuCgNrMt0sN0dX9WpHNIOzTARNfgEcid/hOxfeT
	 3z4xkHMzT2u5IB1Guj2HJz8xjNhJ7A/m+YluYaX2fPMRcTaMbRpym80eUIvDHQmf4G
	 ID4MUbBHhJPHP/6PWnOj7KYtY4zzJo2RU/OQ8P+F7MVjo8Q1DldhHmb47Hgfz1kxZd
	 WoAIbmR4uVBoA==
Date: Mon, 27 Jul 2026 13:22:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-mm@kvack.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	x86@kernel.org, Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH RFC 00/18] arch, mm: create a generic
 set_memory/change_page_attr core
Message-ID: <amcxUS95HBsQhvWn@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
 <20260721171943.GEal-qLx4p5YbocQNV@fat_crate.local>
 <fa75382e-878a-4064-a9b1-43bd2c9dedce@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa75382e-878a-4064-a9b1-43bd2c9dedce@intel.com>
X-Stat-Signature: ea7c37rmppoyhho9x744ha8nt196984n
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 44B05120005
X-Rspam-User: 
X-HE-Tag: 1785147744-501387
X-HE-Meta: U2FsdGVkX1+LMJBMk+AfuOuJeox4jEkAMbrSvldpGnrABJciKfwIUvDCdl+KNKif0aeWqccux3Pkth+0reSeRkOK2ZSBQOzTH7w9+8DTHENX5OKOfqniGqN1Otx+WnK5LxDxI5ZwwS6jrQFy+IbCRAoFE+IslBr/PuZR8R3mzSXignEvb4+k69hTK91jjl52Wgxz+jptl8u7KvuClaSaTm+AsNdq208Zx7/8v5VzloNImVDpRDCrhW4c/5hy2/Hbizna8nvl/wbXOK8w0QgyeBXX8QttrCSQNU7bWnn77h9JdsgHaLeqUbzkzfuvj8gHyfmqHhNgHTZKkxirgzWMujU+zfdwhGVzBpvCE4eZigkx/uiVErgZtDVv+N22jV+I18Mnb3vmk0qf3+RQl1/8LHNiN8rE0Y8EJCf50LBvni57tckMR6n6C4HnIlMamigssfrlJ7oPKlKILw0AKlg8b2wvy5KziqQUnlwBoYLlsuO/vNVUd7OndyVWNxHalEXNmnfEiDRh3lxGkFYUhBvYj043GlHMmdEGfU1aVHIw4/h8uzUTf8xQMp+dtSgcfyagIocxuqKYYmJWGlVCKb37FCOBUY53BxksTJGtbbJC3uH7VzRylqW9fkl6iKcfKquZCovbx43Am+BU83nPFkUm2IqC/Xcw1fuwMCOsXDEkHda4ImOeMlF7CaEItcOo3WbNYL90EoVB/TckQ+6fQUNMM2AEEdN5a4adRDjosJc/GyVZrshiJ8rANc0KiIsFWr3cqx0Friout8OsVJyRwr7qnBkpT4fkKaf9NdqM/QJGPDYeBVt+8Ro3NhadRyTGNHZWsHZQxtAbY4lRkioNso2aCZnZUHMDVpGA+IBtZJFaF0Ufp6OkexYfb2DYm5exag8aXy5vKe2JTELvyEKOyzCQ4dIeTfyojnBBQRpnwW9MkiOjSYvq5+/ZYacsMv0ZmHRVcqJSeI+DqXDe8l66upb
 PxTUivE7
 6p4WLxjJ2ZfB9AXPrKMI5T92AeKj+wnE0gOiQJd1QSzAs5fVmiyEjHWEsDQM7TwQ72NFNt3rIx4/iy6x0y3FKQNtxnuh/1qLp6IdzinLajR2aHA5dAFSvYZStlQkuN4Mkeu7OwYlxVUIsFmM8nnDKKm15kBwhT1f6JUEjA73/dvQfEBE6nMqRgM8FjbIjnObH46bWQ6eClZK5LB090n6Eb0baFkq6aTnbyorE3oFa1pIOcdSa/KRWPwBkcHB2ZGnIfdrhA2WA+/wFib4WLqC5h7i3sHxQx/hnN8zTDsplWjYeyqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 10:03:03AM -0700, Dave Hansen wrote:
> On 7/21/26 10:19, Borislav Petkov wrote:
> > On Tue, Jul 21, 2026 at 07:23:23PM +0300, Mike Rapoport (Microsoft) wrote:
> >> Currently there are 6 independent implementations for set_memory and
> >> set_direct_map APIs.
> > So with all mm/x86/CPA patches flying around, can we first agree on which tree
> > is going to collect everything?
> > 
> > And if I want to review patches in that area, what am I applying it ontop?
> > linux-next perhaps...
> > 
> > Let's sort out the workflow first so that we don't get lost on fruitless bug
> > chases and fingerpointing.
> 
> Just practically, I think this series needs to be ignored for a bit. Bug
> fixes first, features and cleanups second.

Ignored is a bit strong, I'd still love to get feedback on the concept.
 
> When the time is right, it probably needs to get get acks from all the
> affected architectures and go through mm. Folks can ack it now, but I
> don't think anyone should even consider merging it until ~7.3-rc1.

FWIF, I didn't plan to send non-RFC version before 7.3-rc1.

-- 
Sincerely yours,
Mike.

