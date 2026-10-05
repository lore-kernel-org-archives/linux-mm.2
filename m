Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56827CA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 19:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5CF6B0088; Mon,  5 Oct 2026 15:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175B66B008C; Mon,  5 Oct 2026 15:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C056B0092; Mon,  5 Oct 2026 15:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4CD36B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:03:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 634B88043A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 19:03:38 +0000 (UTC)
X-FDA: 85289496516.30.1A0B4EE
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf22.hostedemail.com (Postfix) with ESMTP id CDC66C000B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 19:03:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=tM9FntSM;
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf22.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791227016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYTefUiS8J+q/QM7CAZ/0oR8vJ+TPClAgdgMZ1CuPA4=;
	b=73MIN2SmS+GYVOZcQVxX3pXWPz7OMLC3l5nMIQ/KSge3D9qUN/95BTYKsU0NAPjU9f50g9
	eNMpFtkaiDRW25Z6T2nk2fyE0EnoT5d3mhbXDM/NVjnTVxkG/E5Q/TGTLpaQkVRYgD1W0n
	yovnG8ERh+Qco4I5YODuMQhi0j5NVR8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=tM9FntSM;
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf22.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791227016;
	b=x/vPJbgyDqUV7qsc92VYBWeC/WTNmgD4cJCzc1Z7PyIxSuVvs5rA0DXKY0IfUn0DQalP2z
	hJifhZtSi2ns+mBHrOaUjStTLnh6G0IjNY/yvJuEWKTE7AwpelDGzkU+bydEShLog0QcpR
	KlIJnVrYCNtAm/lWC2NXY5AnrZf0Lrs=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 695J31Y44189531
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Oct 2026 21:03:01 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 695J31Y44189531
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1791226982;
	bh=yYTefUiS8J+q/QM7CAZ/0oR8vJ+TPClAgdgMZ1CuPA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tM9FntSMff4WJSyjqtV0uOmUjGMvvBarDDMI89Zm53FNDbCRQClLc/SXa/gK+3LYs
	 /HGTLBdVQ5Gb21lyhopva2CUoGZ4d8wbSpbJVy3DRuvf90Ar4B2EW9oTdqsWIfGWiB
	 XWNPpBI3OKtxxGBMWZT9gyzgmRMCgIDF2/4dZONM=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 695J30C1041279
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Oct 2026 21:03:00 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 695J2w3b2386917
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 5 Oct 2026 21:03:00 +0200
Date: Mon, 5 Oct 2026 21:02:58 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Rik van Riel <riel@surriel.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        david@kernel.org, Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Borislav Petkov <bp@alien8.de>, Tal Zussman <tz2294@columbia.edu>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <asP0Yic4og6Zu11F@pcnci.linuxbox.cz>
References: <arotyz5g6LozSjb1@pcnci.linuxbox.cz>
 <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
 <arzRBv9ceJsxJppI@gremlin>
 <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
 <ar9yRqq6cBxHDWKA@gremlin>
 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
 <asAE3kLFDUx5v0Nw@gremlin>
 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Stat-Signature: rdtpa3pw3qim1n9kum9fgg7qwxs14g74
X-Rspam-User: 
X-Rspamd-Queue-Id: CDC66C000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1791227015-219154
X-HE-Meta: U2FsdGVkX1+wsaFl2X+GI+V3Wusq80xhZfLz720c1W8OGA4XxtN4xPBRdX7eD4w+zEHGBdjCyvP3/BdLK0hcnO/dMyD2+DRvn6/IGlJ+KytWF1tJNGKO1gUWxiJcxeLuwm7rYhmQLCSbbn+OLeNTbW2OzALEkCPM+6NejWDxrO5mwjaojXvSB6r8eN2jqClV007Z3sUcF6Yn89Pn4PSfzOmqrWKjk2kwlPvTx47VoGRI7V4+uBTWWabRxY5quJyyATZh5cgUF19S24YhVYZEvgGV95OkUvrraNH9OLDH2uk14PysbKrvDa8CMB0vFQy6XUzZAOEgxHPuAga6iFfh5K3qWkTEV+jhjJ2g9Dj30oNh9Cd0GRL+5OdcDhmSrIHUC1ezvbIh0GJibVH47xaEikkRRLQ64sze73+i3otllMZPUGZ3LPAYwpx/H7Elcfvnb5xt46SeNVC3lDY5jek1D3RR0vGXi0xPqZwjqJErVfABynF6gD9Edal6S+lyBboo/19DczzxN31ifIVtAwmQhurkBjaLlYjtGwkJtkD1yqgqjCEphBQP19OkJjTz8RigTA1psdwWsqoR5PzGPBmhIPsur07BZ3J2pkq97Zn7xWb5UmSdWdQ/1yTIuL9LogM/ov9ljC01evniObBqqloCbPd+dRqDRZP/XvVzXLj8f4z6auWFEE1O/f+uwPE6hZgsNgDx5KMhBwHh6I7Z49BzZR81yZyblLnhA9ZQjOmh5dC0HRNccy3m6krfEOp2U3oLiiSGZAHH08hDwJZsKmU0tn3cV6qdBG9HXn6tQjbdG1KHPPPCj2pzVepRw8qwAywTwWPKqR89wuiPbE7E/BD58KS5BVEdGTS3W+uCspsHPHp1ISwg5up9Hq03BlGiRRCM6re+3pnx4bYnen19F7Y8Maq7REGH+3WC2mfbUW8AZGaTDQD+LaT50iga0iAohvALbu7k5+yAciRRNB+IDAV
 zzjl7Maa
 uY49bG8JqOdaert9lxiE1QTWWp77eoF5abEeRiOIySWdnJYM+yWVJO9hKZetPLml4MYzFUc7FpP0tggEI6wlwuzTWZ8FvXcJI3z54RavrgqzuOOrjtnGNIKPJGCvSQfh1HGrp+VdOqkBCqsGBkvHqKLfnB/GACJfU5B/VBu2nPY/OE2+5YyEEzceks/e50osevNfduOXN3g7Z3Px1Obx7UmeEUz83Uad9t3K+oqN7T8EuS9o9JSmDk13nOLM3gDEP70bdxWF+V6VG8rLELnhGMa1By2EGofcPwlzDNIsg9Dtw0EECdOTzWQyB7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Two copies of the exact address you crashed on,
> in a vmalloc area, presumably the dentry_hashtable?
> 
> Can you use vtop to check that the different occurrences
> of the 0fffffff0c930020 address in the same vmalloc
> area map to the pages you found in this crash dump?

Confirmed. Both occurrences in the vmalloc (dentry_hashtable) area map to
the same physical frame the physical search reported:

vtop 0xffffb18905f60440 -> 0x103360440
vtop 0xffffb18905f60450 -> 0x103360450 (frame 0x103360000)

(AI notes:  )

One detail that may matter: this vmalloc mapping is backed by a 2MB PSE
hugepage (phys base 0x103200000); the crash frame 0x103360000 is a 4KB
slice at offset 0x160000 within it. So a single 2MB TLB entry covers the
whole bucket region.

The other frames the value appears in (0x114c32000, 0x1ae234000,
0x24f0e2000, 0x342c40000, ...) are scattered across physical memory and are
not slices of that 2MB hashtable page. So the value is not confined to
the dentry_hashtable — the hashtable frame is just the one that got walked
and crashed.

> 
> > 
> > crash> rd -p 0x103360000 512
> > 
> >        103360440:  0fffffff0c930020 0000000000000000   
> > ...............
> >        103360450:  0fffffff0c930020 fffff86eb0c30000   
> > ...........n...
> > 
> The same thing when reading the page directly.
> 
> So the invalid value the CPU reads is being read from
> memory, and not hallucinated by the CPU.
> 
> > crash> search -p 0x0fffffff0c930020
> > 103360440: fffffff0c930020
> > 103360450: fffffff0c930020
> > 114c32440: fffffff0c930020
> > 114c32450: fffffff0c930020
> > 1ae234400: fffffff0c930020
> > 1ae234420: fffffff0c930020
> > 1ae234430: fffffff0c930020
> > 1ae234450: fffffff0c930020
> > 24f0e2400: fffffff0c930020
> > 24f0e2420: fffffff0c930020
> > 24f0e2430: fffffff0c930020
> > 24f0e2450: fffffff0c930020
> > 342c40400: fffffff0c930020
> > 342c40420: fffffff0c930020
> > 342c40430: fffffff0c930020
> > 342c40450: fffffff0c930020
> > 77475b400: fffffff0c930020
> > 77475b420: fffffff0c930020
> > 77475b430: fffffff0c930020
> > 77475b450: fffffff0c930020
> > b2fabe400: fffffff0c930020
> > b2fabe420: fffffff0c930020
> > b2fabe430: fffffff0c930020
> > b2fabe450: fffffff0c930020
> > ea2d7c400: fffffff0c930020
> > ea2d7c420: fffffff0c930020
> > ea2d7c430: fffffff0c930020
> > ea2d7c450: fffffff0c930020
> > ef7a2d400: fffffff0c930020
> > ef7a2d420: fffffff0c930020
> > ef7a2d430: fffffff0c930020
> > ef7a2d450: fffffff0c930020
> > ef7a90400: fffffff0c930020
> > ef7a90420: fffffff0c930020
> > ef7a90430: fffffff0c930020
> > ef7a90450: fffffff0c930020
> > 10371fa400: fffffff0c930020
> > 10371fa420: fffffff0c930020
> > 10371fa430: fffffff0c930020
> > 10371fa450: fffffff0c930020
> 
> These are not random offsets in the page,
> either.
> 
> These all seem to be at offsets 0, 0x20,
> 0x30, 0x40, or 0x50 into the page.
> 
> If you look at the other addresses, are
> there any that are not at one of these
> offsets?

I checked all 40 occurrences. Every one is at page offset 0x400, 0x420,
0x430, 0x440, or 0x450 — nothing elsewhere, and nothing at 0x410 (so the
hypothetical sixth slot at +0x10 is not populated in this dump).

Relative to a 0x400 base, the counts are:
+0x00 : 9
+0x10 : 0
+0x20 : 9
+0x30 : 9
+0x40 : 2
+0x50 : 11

There are two distinct per-frame patterns:
 9 frames carry the value at {+0x00, +0x20, +0x30, +0x50}
 2 frames (incl. the crash frame 0x103360000, and 0x114c32000) carry it
 only at {+0x40, +0x50}

The value-holding frames are a consistent class: kmem reports them as
non-slab, no mapping, page flags 0x2ffff800000000 — the same as the crash
frame. For the crash frame I dumped the struct page earlier: pp_magic set,
pp_ref_count = 0 (i.e. stale page_pool metadata on a page now in use by the
hashtable). I have not dumped struct page for the other frames yet; happy to
if it helps.

Two observations for the code search, offered as observations only:

The offset signature (base 0x400, entries at +0x00/+0x20/+0x30/+0x40/
+0x50) looks like an array of 16- or 32-byte-stride objects starting
0x400 into a page, with ~5-6 slots — in case that narrows "writes into
one of 6 slots."
The value 0x0fffffff0c930020 may be a legitimate pointer with a sheared
top byte: 0xffffffff0c930020 -> 0x0fffffff0c930020 (ff -> 0f). If so it
would be a partial/torn write of a real address rather than a constructed
constant — might be worth having the code search consider both.

I can dump struct page for the other value-holding frames, or pull the
surrounding bytes of one of the 4-offset frames (they may show more context
than the sparse crash frame) if either is useful.

BR

nik


> 
> If this is a case of "system writes
> fffffff0c930020 into one of 6 slots",
> there could be some at offset 0x10
> too.
> 
> I'm having AI comb the kernel now for
> places where we could conceivably
> construct this value, and write it
> into one out of 6 slots.
> 
> > 
> -- 
> All Rights Reversed.
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

