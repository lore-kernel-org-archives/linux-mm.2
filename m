Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68524E81A2B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0F96B0005; Mon, 16 Feb 2026 09:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1EC6B0088; Mon, 16 Feb 2026 09:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8693A6B0089; Mon, 16 Feb 2026 09:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7238B6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:56:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E1A2C3FA6
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:56:19 +0000 (UTC)
X-FDA: 84450620478.09.E5D4761
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id CF9F1100005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:56:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RQjoAr5Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lge3tgWU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RQjoAr5Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lge3tgWU;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771253777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9ttW/18VYltogR+gYxUAW92HmFwpcRVs9RiGO9jQpA=;
	b=nyLT6MP76GR0R8cLm3vdM3AoWolP9L97V/wDYZTrMZcVWRvGK7qkeTI+zARJjOl/R/SkYv
	1RStptRa2hegCgKymN/Xv5XvkoSFJZGcqUuUlhu8yLhMZ5GRmrEYDRMj8pK8N31FNjBZlG
	kH/AkoWmvd0s1QZXrABhC677B7kRrKI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RQjoAr5Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lge3tgWU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RQjoAr5Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lge3tgWU;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771253777; a=rsa-sha256;
	cv=none;
	b=3t2q5dqUePcCqDv+ifcb0vRBA4/o6QgzpaRPwzdSiSAVZy9MHvpoDaHpgS0biVEcjqEN81
	X+ZDvEhygRD5JyVMFKCFNO5pkKsWKXVbLAu2Bb6n0tOw8YG69PXj67k2nvjFUcVsfDhqJl
	kJ12cya3krHQyCmGPu+Tey2vea7cfKA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 197263E8BF;
	Mon, 16 Feb 2026 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771253775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w9ttW/18VYltogR+gYxUAW92HmFwpcRVs9RiGO9jQpA=;
	b=RQjoAr5ZdIn2BkzzBrxuYlIr6WoAXonXWbM8w/ddRdVzqxr64aJRtDUS3toGgTPfMRs17j
	JD/EoiUBRtEMXuF0QZJIpCIVJLbc5dm9B+X48mqpiA/5bx1SaGz+2paoMMyO3kJi5Mupts
	Lr+Oku4unrh5/7gz25K0aSlwEEBQQTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771253775;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w9ttW/18VYltogR+gYxUAW92HmFwpcRVs9RiGO9jQpA=;
	b=lge3tgWUalLnc7OyZs//Flm7j/eL/LNlxRAFgL2xY/2XAhRviDg9w7Ax51a/V+aul0T/N7
	wsK5i0PkvXh4wSBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771253775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w9ttW/18VYltogR+gYxUAW92HmFwpcRVs9RiGO9jQpA=;
	b=RQjoAr5ZdIn2BkzzBrxuYlIr6WoAXonXWbM8w/ddRdVzqxr64aJRtDUS3toGgTPfMRs17j
	JD/EoiUBRtEMXuF0QZJIpCIVJLbc5dm9B+X48mqpiA/5bx1SaGz+2paoMMyO3kJi5Mupts
	Lr+Oku4unrh5/7gz25K0aSlwEEBQQTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771253775;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w9ttW/18VYltogR+gYxUAW92HmFwpcRVs9RiGO9jQpA=;
	b=lge3tgWUalLnc7OyZs//Flm7j/eL/LNlxRAFgL2xY/2XAhRviDg9w7Ax51a/V+aul0T/N7
	wsK5i0PkvXh4wSBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FE003EA62;
	Mon, 16 Feb 2026 14:56:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SPXoCA4wk2nbRwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 16 Feb 2026 14:56:14 +0000
Date: Mon, 16 Feb 2026 14:56:10 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, willy@infradead.org, vbabka@suse.cz, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions
 since PTE batching (cac1db8c3aad)
Message-ID: <k52hjeeisjage5yhbacv7z6yai6baigvkwj2vdd5nhdlypli2t@3fm2ebb5s2yk>
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CF9F1100005
X-Stat-Signature: x8718m8g8d3uwygyxfn9k58cnh1s7687
X-Rspam-User: 
X-HE-Tag: 1771253776-489687
X-HE-Meta: U2FsdGVkX19rxQ4LW9Dy55V/rkvoe9c2YxI8WEg2ebi1Unoby/5vG+SKjnw8nIXZzuxT3DQgqYso1la5SDGbYOl5iDeedYkaOGpunMxh55ySUzZoZIp4Ja2OB9eJ13EpXNvEq1TbNgIleBqBBA0ze5bJeVZk/haEaLITFrHudZSXY3C7Rhe3NdqXSOWbUOKwnkrx9iV+Dt/p9ElhIRdSW3qxVhFc09prBzJ2QPcGTvSRsnV2r80UEcQnJyNDX2aragEsKwuKyNvkIZYhoBcS4qhDIgG/a6weywGbey1cL6vgQfS9RMd8dv8p7GkrpEHyieBTeDh4k1YZWcf3a+CT4TiRR+CbuYD/37NMro0mDwfOIaE9gHWbF/mVa1ZDV1gPkitY4ajlX68N6iQ5rSBxAzpamADgNGo8Mgbd9eM6Qof4ckoP2JfIDPNTM50dT2ZJLYE909geYMhOO3mGObhnPTCcWv9L25ABelnkr3v5cp7fVystNiWwt7nbm1Z7cXpJIydKGbgfBxea2/UNW+mWdb8FqxYeYGiQpW5e52hXpkdsKin05Z1m+VD6dath+wxbxy00F4iAXbQH5K4tcmtfZCPCyv91gfvSLbgTx5Elps75rX6VttZbo0rPwrpd2RSw0Iky0eQC/OBogXECknr5LqQRbcfXHOK79Vj9qlCrQI1oiDds2awktKnYJJ9BIOcZUy3d1uESFjLIW1DwFfenaro4ETNxVAiHyjgG3i5CGRlDgNrHs2JzH2uNgIEuxPNEXpL3egT6DAcvh2Co36sNl7YF94b609hv7pvSS2FqJzDbZNcJ8aR8jZM3dC+9nEShXgLBFg+3dUAGsW4lJPFXWMuJ0sMrZiO0ueAio7kwJZDxigBRdvfq/TyN5EmtH6BlkTkwoAwb1yVi8hFOwdu/z5zuA3BjW1vgEGmYjXPYKfNubbgf3XFSah7s9ZirxTfsbCaJKVGiMLNfsMUvDpn
 jQxDl+OW
 isnG7uITDG04+4dG4GhZt4UKlODrK4WxHFwrdZIdo66c6ROastwK9zZ8Y8pq/CkEjewcac/Z3AvE+5lWjWKOzHybmiA6EnfZlnTE7fd7ieY+gRGE2B+N894iIwXRZYeyJxkewsMr51hNErdYdhVYG05y1oUy9UCqvjWmzLeIFtRNo2LU8/FFHm2ELqYaO2oUUMzQeErYyAD6ZizpyG4i5GZ19htH6/7z1vhx0bI0cCIREPU5+xcc0uLOHOujVlGoUThXiafC5bj3Wqcpj7WjrX+5DGlL8QTM2jqsVSpyw4Ag5YmHXwe+h/D1G2A/hGgpBPbYdViFUrHf+qzK35Ogms0pCkk0/bbr8pA1nJQFHsR5T6bAZmJV2H213zd42ofZvtqoR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 03:42:08PM +0530, Dev Jain wrote:
> 
> On 13/02/26 10:56 pm, David Hildenbrand (Arm) wrote:
> > On 2/13/26 18:16, Suren Baghdasaryan wrote:
> >> On Fri, Feb 13, 2026 at 4:24 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >>>
> >>> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
> >>>>
> >>>> Hi!
> >>>>
> >>>>
> >>>> Micro-benchmark results are nice. But what is the real word impact?
> >>>> IOW, why
> >>>> should we care?
> >>>
> >>> Well, mprotect is widely used in thread spawning, code JITting,
> >>> and even process startup. And we don't want to pay for a feature we can't
> >>> even use (on x86).
> >>
> >> I agree. When I straced Android's zygote a while ago, mprotect() came
> >> up #30 in the list of most frequently used syscalls and one of the
> >> most used mm-related syscalls due to its use during process creation.
> >> However, I don't know how often it's used on VMAs of size >=400KiB.
> >
> > See my point? :) If this is apparently so widespread then finding a real
> > reproducer is likely not a problem. Otherwise it's just speculation.
> >
> > It would also be interesting to know whether the reproducer ran with any
> > sort of mTHP enabled or not. 
> 
> Yes. Luke, can you experiment with the following microbenchmark:
> 
> https://pastebin.com/3hNtYirT
> 
> and see if there is an optimization for pte-mapped 2M folios, before and
> after the commit?
> 
> (set transparent_hugepages/enabled=always, hugepages-2048Kb/enabled=always)
> 
> 
> >
> >>
> >>>
> >>> In any case, I think I see the problem. Namely, that we now need to call
> >>> vm_normal_folio() for every single PTE (this seems similar to the mremap
> >>> problem caught in 0b5be138ce00f421bd7cc5a226061bd62c4ab850). I'll try to
> >>> draft up a patch over the weekend if I can.
> >
> > I think we excessively discussed that during review and fixups of the
> > commit in question. You might want to dig through that because I could
> > have sworn we might already have discussed how to optimize this. 
> 
> I have written a patch to call vm_normal_folio only when required, and use
> pte_batch_hint
> 
> instead of vm_normal_folio + folio_pte_batch. The results, testing with 
> 
> https://pastebin.com/3hNtYirT on Apple M3:
> 
> without-thp (small 4K folio case): patched beats vanilla by 6.89% (patched
> avoids vm_normal_folio overhead)
>

For what it's worth, I tried to avoid vm_normal_page() as much as possible
and realized that the code is extremely timing sensitive (perhaps due to
being in a hot loop), thus even a small attempt at writing something that
doesn't offend the eyes (and the soul) will get it much slower.

FWIW my benchmark was something of the sort:
int i = 0;
mmap(400MiB, MAP_POPULATE);
while (do_benchmark()) {
	if (i & 1)
		mprotect(buf, size, PROT_NONE);
	else
		mprotect(buf, size, PROT_READ | PROT_WRITE);
	i++;
}

probably worth chucking a few "do not thp" calls, which i totally
forgot about. though it didn't seem to be relevant in my testing, somehow.

-- 
Pedro

