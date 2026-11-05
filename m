Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7119B606EEB9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3f015KA
Received: by kanga.kvack.org (Postfix)
	id 7E5F56B05B0; Thu,  5 Nov 2026 10:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BCDC6B05B1; Thu,  5 Nov 2026 10:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9F76B05B2; Thu,  5 Nov 2026 10:02:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2AD6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:02:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C55421A0ABC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:02:35 +0000 (UTC)
X-FDA: 85401381870.07.07438A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C4E320018
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:02:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3f015KA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793890954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3u/QstQSJV0UAJtzHBVB+ScC/OFteWXsBLmgkvMVYeg=;
	b=ZsccMN6daeBMIqntKOjhV+Rw/xvVMaJhfCLCNCRHKhfRooP2gfT2sJTvv3vnUAImw+Eqs/
	rc09592/7xglcmUr7mOgDlGeGBg7YOzE4KQZelw1AdbtjsOfzpmVrgcIsRTy0WWlU8SjHn
	PA6Ru32W4/a9SYgeeVnjIrZNWRrsn9o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3f015KA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793890954;
	b=J2hooGNfCFlmBV8AU2eCz+1h118dtAP/iWMUJc24RQvU2tzqnSqHLF6dNX2p3raweSdEuN
	hMhC7vBtUSk+b0H/2+XxcmtXeGJXhArgtmmrkIQZvyFEtxKulyuoTTQboQU1anaAyuhvPX
	+X/c0hlt8kZKcyoQUUamqDyT/yAJo90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F6EC600E4;
	Thu,  5 Nov 2026 15:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3151F00919;
	Thu,  5 Nov 2026 15:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793890952;
	bh=3u/QstQSJV0UAJtzHBVB+ScC/OFteWXsBLmgkvMVYeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I3f015KAlphpMgxVJXHJjEj6LUkRUNl0e35EHpz7Bf+r0lLG5tpJ0rhDUpJmC2vUh
	 OgoFNWSQ23Zp3jChLiM9ItZ4AYJvFqDuPvOCQyZVIQJMi907dQsjOwuHxs6blN/ujZ
	 kKSUx+5KOd7BRdPiKZsYPXbsy25uLTdXsYxBz4OJqQbnzT28Uh7PsFMG4EoZzVyGFx
	 1T6CUjcRXNk/HshtQymxX/A5RgvQ+TMYsFplJO70khw5+qgx/7OmLUq50tTAhBXMuJ
	 Il+hnBRlB0G1Viyx2soDl9tb15sFDxcjbasPKLv/XSVlKf3ABMDet0FOdhfMmHQSsU
	 J8ttzRttzxbWA==
Date: Thu, 5 Nov 2026 15:02:30 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 04/10] mm, slab: introduce slab_debug=N
Message-ID: <auyVRU5abrWHVfgM@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-4-0484ce59eabb@kernel.org>
 <auyFYsbsMm8qGThW@thinkstation>
 <7ac409a1-fe3e-4b37-8130-4d49ecb6106a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ac409a1-fe3e-4b37-8130-4d49ecb6106a@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0C4E320018
X-Stat-Signature: njp8tkxrrk55cw9yjq79impr3njjcwpp
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793890953-952233
X-HE-Meta: U2FsdGVkX18zsibOq7cLrfOeD0Aoe3INaDwRpLEc9mDKfO7fZzVNeDFdvs0u/E+OKep2yeKKmOMP/onM4JfZVfclbFIF3WqsvQK6dnKnOEGuKHGN8/yEu9gncxthL81PTZk/1w363SCFtaO1SPAVqSOcQjucEVZswKK/PzL4OML/GW0c7qVo3P9gZdYgGj1io6QA+305puy8iaajyDW+ECXAknLLk5Hv87ULLSd3lhxuZ8KQy5UwnJxALxhfT2TggmH/Q24doI6eQ2SRYJOfNLWJYfVh/KqrWNf2+vJvSu1rnhG/XIboDuOiJ/rcJkxAAl7IVeGjCIzUyDfA60FY4bn1MVARqLcgkYjxKW6QxE21OIHE+joYshzS9YiRosvgmkAoqtBB5/E+aEVWF/Z3XEQlb8ldhztcrtmsdCL5X6iIVhnTFVSYpCro5qQE3Og57Xk5kJtHywpuNJGDTdHcS9EI7JhaFtlLS5sy8cO/03qYZ8gLmBLZZ03UpMLV0Oe/pcJ6h+BvGsjpK11n486xiPDmgjhmH0iM+avhdh4I7KM1Ia16Dz/iHmhRyOqeQXh1yFsWJ6Ne7mSeAsWOhnDUWuhS0FyI3Gd7lF9rSo3AloBiAuuN2LmY8O6x3phb75QURFk4FgntKxF+IfYWZpiHqBQ5kpp2IGbZCym+whozQ9XxoXJizafDr7l/5r6Nv9XG/6BG/LzvC6XfT14TGRp8lkjQqptBuVXPwWyC9qQKWbzryU9XtC7K1YJntvW100jWh6aQdT/sKdVnDHrXvOhjLnWc0FzNfKsCLIHf6meCn+1z3BtIZVpb5Ac5MO5lxvkNywehBhYjw75Ee01UfRiKr3ANmuP2i2RcBkwBKkd5oEDKkB49K0+aq7EWtaA2vT+TMI/pTWPFoOIcrnQVSRXiaX6TzUAbclBh6scpTRUiK5bdUBeUpHPOKKGCv092vRwRKddUiGGz85ywne2/MRF
 kzGKtm+d
 lPcIl1p8K4Jrf12D1XV39Y9dOvObmJsSIsiX644E3bftwr7s7IHGg0DTOwOUt96AnjKVoCfxflC3IQTxSXp9S86i60phzdEE8dDH/1eFtUUgl2b5Ns8T3NBgRdH9jm2hyUhmlHKMczzt3QgO8gS8vuAJU1axIGB+wQ2SCdqrcYU3YzpHB8tPPJJENvc9dpgryy54k9MUVmc3lmWfuoauXY0GSRQZBFi7H5OdOel4shk6sP+L+Is3OfUtREWPYjvA33NjqelnXUthmdPx5Na3gxj2JLdYx0urzH5yTOHpTKNCw5T0w0j100QgGeruTWrXLzj/s+SsW3KwUT1HM4bCUxVpZIVqgR8dVclKBMKJIPqH8M4LK64QqQ8XywamqN1or7tvlphut9SaMZaHFeVgQkNpAQFRY/btalEWc6eC8HVMMGsCVsHsWnzOryZmelhOs+bBVpOW7RW5Z3c2e21N+2SvZpDI4KPqfDL60foWcLayNiaqfDDC22O59LFbRaIbDswW/i602ocopRUIxl/hF8aABnbLENJ1P0054dI2/v6klEOHshQHYtNaLOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 03:36:25PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/5/26 15:30, Harry Yoo wrote:
> > On Thu, Nov 05, 2026 at 09:43:53AM +0100, Vlastimil Babka (SUSE) wrote:
> >> Enabling slab_debug has the side-effect of disabling all percpu caching
> >> of objects (now via sheaves), which can be sometimes useful for saving
> >> memory for e.g. kdump kernels. To make this possible without the
> >> overhead (CPU or memory) of actual debugging options such as poisoning,
> >> introduce a No-op debug option that only forces the debugging slow paths
> >> and zero sheaf capacity. The new corresponding slab flag is
> >> SLAB_DEBUG_NOOP.
> >> 
> >> This will also allow reimplementing CONFIG_SLUB_TINY as a boot-time
> >> option.
> >> 
> >> Two details have to be considered, as suggested by Harry Yoo [1].
> >> 
> >> - While SLAB_DEBUG_NOOP is part of SLAB_DEBUG_FLAGS, it should not
> >>   prevent cache merging as it doesn't affect object metadata, and lack
> >>   of merging would go against the memory footprint reduction. Thus
> >>   exclude the flag from SLAB_NEVER_MERGE.
> >> 
> >>   - However add the flag to SLAB_MERGE_SAME, per sashiko.
> >> 
> >> - SLAB_DEBUG_NOOP alone should not request disabling printk pointer
> >>   hashing. Thus rework the call to hash_pointers_finalize() to not rely
> >>   on the slub_debug static key state. Instead determine whether the
> >>   global or per-cache slab_debug options include any flags that are not
> >>   SLAB_DEBUG_NOOP. This does not change the fact that caches created
> >>   with explicit debug flags (i.e. slub_kunit tests) later in boot have
> >>   no effect on pointer hashing, which is determined in
> >>   kmem_cache_init().
> >> 
> >> While documenting the new N option, remove obsolete SLAB references from
> >> the F option description.
> >> 
> >> [1] https://lore.kernel.org/all/arUx56ee_nkxYP_f@thinkstation/
> >> [2] https://sashiko.dev/#/patchset/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org?part=2
> >> 
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> > 
> > With the sashiko report to this patch fixed, this looks good to me.
> > Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> > 
> > One nit comment:
> > 
> > specifying SLAB_DEBUG_FLAGS depends on CONFIG_SLUB_DEBUG, and with this
> > patchset there is no way to minimize slab memory usage w/o SLUB_DEBUG.
> 
> Maybe not at this point, but unless I made some mistake, later slab_tiny=1
> stops depending on SLUB_DEBUG.

Ah, I see. Right.

> slab_debug=N itself does depend on it but I
> think that's acceptable

Yeah.

> > Sounds like it's time to make SLUB_DEBUG unconditional. It's enabled on
> > all distros listed in kconfigs [1].
> 
> Yes it's my plan to do that next, I did even discuss it with Christoph at LPC :)

Sounds good!

> > I built kernels w/o SLUB_DEBUG and the difference in the kernel
> > binary was about 40 KiB.
> > 
> > [1] https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=SLUB_DEBUG

-- 
Cheers,
Harry / Hyeonggon

