Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA198E9412D
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 08:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEFAA6B0005; Tue, 30 Dec 2025 03:54:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72F96B0089; Tue, 30 Dec 2025 03:54:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E9D6B008A; Tue, 30 Dec 2025 03:54:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87F746B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 03:54:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01C6A1A8371
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:54:17 +0000 (UTC)
X-FDA: 84275525796.15.381109A
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id F280940002
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:54:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZhetyhhN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767084856; a=rsa-sha256;
	cv=none;
	b=j5yG/+bMPwOlmFuvSoHoN2wux2lbIoJ/I6y/2CYB2+zajzkythgwlP7EsSQ62FvR9yRKhU
	ClcnK6Zd7M8oAnQ2GGuJ1HsQ0vjKaYFKSF6WVQeF/4geQTsP8Z4VOn5w72+4jUIxHSfcRy
	92CRvAnuX+bhv3BS0guX5ksWiXOmer0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZhetyhhN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767084856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFQ1B7f3jdUQJv/G4p3v4Or/bwoQHErH3VgRPq8vePw=;
	b=jQ4HGpyrEPhLmmMmWjvbKo+rcgL6KN+EvseYgFWDYy8330R9z+kjoSh4nrEu7bTEVsQef1
	Du+0TTzZp9GJnApk1j9nyN98RB7sluS7Focsbin5EGNj5zCecFLgISS0B0nTDmcgYuzcAa
	8QFqZwWS6W1z/rf92alzu2GjOGP+jLE=
Date: Tue, 30 Dec 2025 16:54:03 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767084853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aFQ1B7f3jdUQJv/G4p3v4Or/bwoQHErH3VgRPq8vePw=;
	b=ZhetyhhNbz0ZQJ0nLazfs2RkkKQpHKojBVKfyKa3LJ1f7XmNJ/QA0MBasfWvWo7I/jgFLA
	vudU0RbFjHioUSoDY6EQkExJa6ttuGb/hNtMst9/A4GTs+fq+tQ2Decv8wtaoINpM6nUbu
	+rzG/WQzYg4jHhtRqf0HeQg3tq9AMh8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@gentwo.org, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, 
	surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH V4 8/8] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Message-ID: <tyc35ufouc6uskxthnnm37aatzffy3lw3qtguqjsgtkscs4d54@cupdpbhjd64y>
References: <20251222110843.980347-1-harry.yoo@oracle.com>
 <20251222110843.980347-9-harry.yoo@oracle.com>
 <l2xww4mysued3fjc2jzzy6cjrq5guygsxesmfqrhv2laxigpaq@ghj7xitfq7fh>
 <aUuKgRlI60Hw3-Et@hyeyoo>
 <hofqvftaj7ofgdvzb56hvjgk7chxkb5gfsj3324e7wal72mjll@7m4s7adnk35j>
 <aVNcTVKmz9N6bOfF@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aVNcTVKmz9N6bOfF@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F280940002
X-Stat-Signature: epemgjcorqbr1yzjjwsi6p4x6hhn6tey
X-HE-Tag: 1767084855-89656
X-HE-Meta: U2FsdGVkX19CwKy3NnRhcvHS8sb0gj+sg1QKpPvlh9otiM57GxI/GC/OY7DHTrhBbkryLBW0VVhAnDtBAD4R9cxVtwOVRNhr/4d1/JPpw7V90DYKsjnukA71hPwGwWVcsiySHmUr4vd1ySQIAYLo0geUZA1c1IX84VOmTC94gtcg3INdgEDvQTXsyl4hLTyXYe5VOmlUFdttql+gUSbWwj+1vc5ARxmu0t3YYFDeZNECUgHf0eCD3/hovdBR5m1eW4blmWk4vhRK2qOoC4Oxtq81IxdjsfRH3tg1+TTeKag0OopV8KleUJYunWNeehvjxhbF12idr1FaoPo3EIlUQBO/FyZVMvJ+AuGi/GUy8KxmsUOFyg800CO1KKrVGzK6kIIxcaaNgsKI3A5NnYhurIulQQJ2rsDpmMXwEAR57Ghy11GFFAL826Ydeom6pfTZUrnmKrjIMm026DBZUG1j2Ja0nayTij0m4rDJtSu9XKIFI76qtk+o1FQGK2JVEZ+zkMGhw2cb59+2DtarkFCKnuAXy/wBPofCkm45dIUz22VFabS/o1owRtdFVlKg4AS68mps3ECoKWRTUXN+mAdrfqsFwWe6D4zvPGyo098t3oIIBZ/4wySO9lhCM9ibRMRx3tHF0Qu7qziXnKtmHT3ONtPUZPA1pIXT/EmK56YHH+m34Svu2Eu0lTA98lyCbU6s+p5yt9VkTO2rWpDmc43YfWe2RbQgqrqskJZxNgtRLQ3fT8gbcSCdnVcndnX1oe5aOwJ2gRfWQnDaTJnNTUWAb3xEkCDQtewG15lUBCNI4WlslM8woFAyJtogX9WAh19WrXY6oSS6rFkfBBjcHHeHNQkZ1e9+Iqju1Ewv1/BGxVu7NAtsAivgtYe0wb9wawW3R8dHmFE1klznzRG8UZ9oyR1kXpNTUY3Naxx+cqbdDlW6/5q0z+zVptIMS0AUf6NSNJn+r/SqYTQ8NK4b8+5
 ImJdzjT3
 cPwkjm+FUc3LotR4BwDve0Q2khUt1maWbYY8zVk7myV0BhRXMFVot/Af/AYNKDfwWWd+HIxpIKLRJzwptzDlz63RhdwPdAQP78ReIVmCCEbkVKj017lthSHAfRnMgCFOoILZR9WSUIklmgno6+vYg7r8sJQJCKzPjddNu1Q6fPH9d4fO77USFt/HWe1lNSb0CwYDOvmU4MzowhtlVtLL4fXH0fVVwSdv1PXFu8ovgPpb1FLceUkaa0lvBqrKBn1nHADYUjnnhazybr9WDfpWkKM4p+Wo3w2QFlWH/KAEVVhg6dLZYLvwhWDtWs4R+2JP7+e4iU5BdMBudeqbspvBy434wVxjRnut36m7t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 01:59:57PM +0900, Harry Yoo wrote:
> On Wed, Dec 24, 2025 at 08:43:17PM +0800, Hao Li wrote:
> > On Wed, Dec 24, 2025 at 03:38:57PM +0900, Harry Yoo wrote:
> > > On Wed, Dec 24, 2025 at 01:33:59PM +0800, Hao Li wrote:
> > > > One more thought: in calculate_sizes() we add some extra padding when
> > > > SLAB_RED_ZONE is enabled:
> > > > 
> > > > if (flags & SLAB_RED_ZONE) {
> > > > 	/*
> > > > 	 * Add some empty padding so that we can catch
> > > > 	 * overwrites from earlier objects rather than let
> > > > 	 * tracking information or the free pointer be
> > > > 	 * corrupted if a user writes before the start
> > > > 	 * of the object.
> > > > 	 */
> > > > 	size += sizeof(void *);
> > > > 	...
> > > > }
> > > > 
> > > > 
> > > > From what I understand, this additional padding ends up being placed
> > > > after the KASAN allocation metadata.
> > > 
> > > Right.
> > > 
> > > > Since it’s only "extra" padding (i.e., it doesn’t seem strictly required
> > > > for the layout), and your patch would reuse this area — together with
> > > > the final padding introduced by `size = ALIGN(size, s->align);`
> > > 
> > > Very good point!
> > > Nah, it wasn't intentional to reuse the extra padding.
> 
> Waaaait, now I'm looking into it again to write V5...
> 
> It may reduce (or remove) the space for the final padding but not the
> mandatory padding because the mandatory padding is already included
> in the size before `aligned_size = ALIGN(size, s->align)`

Ah, right - I double-checked as well. `aligned_size - size` is exactly the
space reserved for the final padding, so slabobj_ext won't eat into the
mandatory padding.

> 
> > > > for objext, it seems like this padding may no longer provide much benefit.
> > > > Do you think it would make sense to remove this extra padding
> > > > altogether?
> > > 
> > > I think when debugging flags are enabled it'd still be useful to have,
> > 
> > Absolutely — I’m with you on this.
> > 
> > After thinking about it again, I agree it’s better to keep it.
> > 
> > Without that mandatory extra word, we could end up with "no trailing
> > padding at all" in cases where ALIGN(size, s->align) doesn’t actually
> > add any bytes.
> > 
> > > I'll try to keep the padding area after obj_ext (so that overwrites from
> > > the previous object won't overwrite the metadata).
> > 
> > Agree — we should make sure there is at least sizeof(void *) of extra
> > space after obj_exts when SLAB_RED_ZONE is enabled, so POISON_INUSE has
> > somewhere to go.
> 
> I think V4 of the patchset is already doing that, no?
> 
> The mandatory padding exists after obj_ext if SLAB_RED_ZONE is enabled
> and the final padding may or may not exist. check_pad_bytes() already knows
> that the padding(s) exist after obj_ext.

Yes, you are right, V4 already does this — I just hadn't noticed it earlier...

> 
> By the way, thanks for fixing the comment once again,
> it's easier to think about the layout now.

Glad it helped. The object layout is really subtle — missing even a
small detail was enough to throw us off. Glad we finally got it all
straightened out.

-- 
Thanks,
Hao

