Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A1A606A323
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=RWB/ouch
Received: by kanga.kvack.org (Postfix)
	id C16526B05B4; Fri, 30 Oct 2026 20:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF116B05B5; Fri, 30 Oct 2026 20:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B016B05B6; Fri, 30 Oct 2026 20:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C30C6B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:56:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC5441208C4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:56:11 +0000 (UTC)
X-FDA: 85381104942.28.C908A4B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id CAE2BA0006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:56:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="RWB/ouch";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793408170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNZ0jWpXyvTAI1fGB9HbbXYilWwVTrHzAZcnT/C24Ac=;
	b=pPJenSU/cKmecwd5KHvmXSinCl5zHFSwnF3A9n3gntGau8MfFpfBHoQlk6C1S6YJ5DxZj4
	qZX9EScRsVucOw8GnVBOYnq53C2P+R4UYc5/5LfA8Ju+vRgx4Xt3GUrP+P1j7GQ7hoAxA3
	7Cccq0E6Tv33/dSSViDigtyuIfPwhY4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="RWB/ouch";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793408170;
	b=mTtsTQIa5wMx3OK9I/xi7e4NYGam8/ZDGJ8A8EiWlZ7+pHyPyR/GGtusqT96jPE3r6xRkO
	IF3D/PSELtikVjqT000gFz+5AzGuzPOPLtgT5pDN1R83W7UNyHVcMYPAdSGeRvekNATb7h
	vgqnE1VQcvGxhbc4nNEvc1nQrv7MSu0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NNZ0jWpXyvTAI1fGB9HbbXYilWwVTrHzAZcnT/C24Ac=; b=RWB/ouchWeYcNlfYevA/mj7l9N
	cXBd9jmS0mL/cCVzaorN/VcfjaeExVPwuO0LbceCUiGeqGCEij0CLT5Ovi8h501hFGB70Kh2Ggi3P
	aapHxvhOQ4B7J0PQn97CMaQwoJZgYWp8wBUwVrAmTxrE5Z9COzjOnpUNnV8NyWpBgpCTCOCnTr6bN
	6AZsN6OCZl32yis0lLPscYGyMJ5nm3vo+sKP+SvRto8LQam2FWXxXJeERxnAgMQL4AoooO1tIyQFF
	AXZAU8gYN4FMtVGGhRLtmvP+HZTHXiVAoY5Efs/iYK0KQXINtj/+co/ipfhw5exzZJKYAxdZkhpdy
	1OlossLw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMxOA-0000000CoBp-1cwP;
	Sat, 31 Oct 2026 00:56:06 +0000
Date: Fri, 30 Oct 2026 20:56:03 -0400
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
X-Rspamd-Queue-Id: CAE2BA0006
X-Stat-Signature: d7mp3ud6ipu9tuumpwtmywwb8naupnu5
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793408169-758245
X-HE-Meta: U2FsdGVkX19K0+xeV+8pZ2wpdW7JNBtcRzV2xTjSO5c5CnTsSIvt5jeHNYa4pKhlgUG/pIs3ue8b2qBJJdZpPdoX0KTQGLw6/4/eO1PC1AWZLjLFVQAA0JqiqpKmWE3RKhAlmLT4VDzioLH/mrWWpzqCDOWiC8blC5Ns5tUH/2lF7ylIZ+pk7hhfVMLqGBaAeoK6MyNBaTHiRgbXqARlv59Tlrz82ewYKUNWmPI0vFlBOZBJbVkfuzj0RBxzfONAvQP22/2YyS6XBmcsZYRBlUx1ORySQz8RNFgfnWEAKkXL2vgFnk0MALk+ZBzUZVKTxY/7ppjQwkDXRgWiNYCOuiL6ls2LnuQJihy0Hz4Y9ahF+7KyEmQ89TcJL3U7j+6oKPZrhl9tvmMDIqXGc7n3M7A0Hp4C/Kmp7fFpchqofyJzHcKTMsDG/k8go7YJWfh41mGkqQ9TkyIoya3ZX6ECKKYP+rHQahwz80Nja8pzM6geQf/PUw99IxMEqJLDHK34ZHWn7m1L8VLYpDrGgiOCKTpcpSTSdaE/9jh46AvxUC/OLgO23wSwWLXafFORh3H3SUXc2e6Jy+gI2gjhTNliJJiOLonc1eED0hAj8zVrY1vL9JW0dSkCeMeh63+pYkL1WgSUN83hqbC6qeVpr0cCoopHQsGUl589HjUYnBW557LYvHFfgaMeKQd7g4yFtdGY0FoB19yOHbQHzAHV2NpbQbZ1tbKOcn3HkwrjSjmdN1iWDzskxp4Zhr62B1kKx+vPSsi71t1x63vBgufiLWU0Vnt/d0FLOTpbNbhaU0NoEdpOerYZzMOrR3FPerW/BnwxOxUXDMjVu3LofDlbX763KDt/5fHg8MGg7+nuQKWvr/tltH05qBcJjxVcd1xmOsyAkrVaYUnce1DlN2+aoAdR/84BFDXH1PXUcfpVfhjK7RDCFR0rNCqvQv4z9SisYbQO/npkn7zKZsjMvVXm1ov
 4dOF5TFr
 sgmMm4TMC4ArSx0d6IUYUgbjPkDPI2FdAT7t5p+xre3MvDa34DIM5Cj1GQvzojGtTNiAbDbyiapaHI6VdvO4EfbvqMJdOgZQUw7X3z7DEeI4yLHpRTHb3N7mFWr/6QmhSDNoVjnE9aafG1QETrXKgSXLIhoAbevuirA016eVFTf0oApxSfJ+z3K05E4sn9h25srFbfvmN452P5pmMl0QOCSHnraeFgEZpuFl2YJygki92msclLF/KIjnqlMac4EOPznIACcyASJVVxj+Oih3/OXi7YVcoYICYsSJ9qG0dPhZy1f/9/+4H+XR6Vs+8iK2w5WDFL/FSohlh4DMoB5Izo7pglRdrOv4JgGhInQ3Tm8VfgU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/10/29 10:54AM, Liam R. Howlett (Google) wrote:
> 
> Sorry for missing the ML in my initial email, I missed it from
> get_maintainers.  I should have really clued in with such a small cc
> list ;)
> 
> On 26/10/29 11:08AM, Uladzislau Rezki wrote:
> > On Thu, Oct 29, 2026 at 10:16:36AM +0800, Herbert Xu wrote:
> > > On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
> > > >
> > > > Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> > > > while another CPU is inside vmalloc() or vfree():
> > > > 
> > > >     RTM_NEWNEIGH                      vmalloc() or vfree()
> > > >     ============                      ====================
> > > >     spin_lock_bh(&br->hash_lock)
> > > >                                       spin_lock(&vn->busy.lock)
> > > >     rhashtable_insert_rehash()
> > > >       kvmalloc(GFP_ATOMIC)
> > > >         vmalloc()
> > > >           spin_lock(&vn->busy.lock)
> > > >             waits for the other CPU
> > > >                                       softirq: a frame for the bridge
> > > >                                         spin_lock(&br->hash_lock)
> > > >                                           waits for RTM_NEWNEIGH
> > > 
> > > I think this is a fundamental bug in the kvmalloc non-blocking
> > > support patch.  How can it be used at all if it is susceptible
> > > to such dead-locks?
> > > 
> > > And if you can't use it safely why don't we just get rid of the
> > > broken kvmalloc non-block path and have it always go to kmalloc
> > > like it did before?
> > >  
> > If we have a look at this as we did not have vmalloc() here:
> > 
> > 
> >      RTM_NEWNEIGH                      foo() or ...
> >      ============                      ====================
> >      lock_bh(&br->hash_lock)
> >                                        foo()
> >                                         lock(B)
> >      rhashtable_insert_rehash()
> >          foo()
> >            lock(B)
> >              waits for the other CPU
> >                                        softirq: a frame for the bridge
> >                                          lock(&br->hash_lock)
> >                                            waits for RTM_NEWNEIGH
> > 
> > Same issue?
> 
> Looks like it to me.
> 
> > 
> > I have a question:
> > 
> > GFP_ATOMIC/GFP_NOWAIT guarantee they do not sleep. Do they guarantee
> > not hitting ABBA dead-locks or they are not interrupted?
> 
> GFP_ATOMIC and GFP_NOWAIT can be interrupted.  It's more about not
> waiting for reclaim (kswapd might still run) and GFP_ATOMIC might dip
> into reserves.
> 
> The issue is that kvmalloc() now falls back to vmalloc() for
> non-blocking flags (I am restating this to make sure I'm not missing
> something here, please correct me).
> 
> So this changes what is called internal to rhastable so it doesn't reach
> vmalloc(), like before, if the caller cannot block - they go to
> kmalloc() with the old fall back.
> 
> I *think* the question is if the change should be here in the caller,
> internal to mm, or a new call to opt-in.
> 
> Considering this is the only kvmalloc() caller that forwards
> non-blocking gfp from BH lock + softirq context, I think that it makes
> sense to do it in the caller.
> 
> Given where we are in the release, this fixes a real issue that can
> happen so maybe we take this now and settle the general handling later?

Hubert, I have another version of this patch set to send out, but this
particular patch remains the same.

Are you okay with keeping it the way it is for this release?

I don't want to force your hand but I also don't want to keep a valid
deadlock scenario in-tree.

Thanks,
Liam

