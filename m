Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BFD3606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cLtgzE2m
Received: by kanga.kvack.org (Postfix)
	id 058486B05B8; Thu, 26 Nov 2026 09:23:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0088A6B05B9; Thu, 26 Nov 2026 09:23:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60276B05BA; Thu, 26 Nov 2026 09:23:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C72C46B05B8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:23:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6773E1404A5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:23:42 +0000 (UTC)
X-FDA: 85477488684.22.4BD825B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B3CE3100008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:23:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cLtgzE2m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795703020;
	b=AN0T5RP8ULgW8kC2MhMkJMxL4RDdkT51jNghudg9v9WC3TzdhqHAIrmPfk6p0qSz6n7stz
	VfJiCTXwMgKKwW0Ns6zGJpHo0vY6lJsTywQlOmUijdK0bn9R/PLw/uEQfteiwwfXJ2JD5R
	LM6nbdg4R3MpvIqBPv5yH5N9xpCdgMQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795703020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TM3nSQU4U49T6GuNdT3oigc7kZQ4pNCPYHhbPmQrcTg=;
	b=jSpHsx/XmvKDawElMiMNbHVWa5/+ZhQA/SNJREFl+TL+Z1NF2Ur0H/KKLu934t6HJCWW8D
	+9PRFS+XsFy0oDq+Bka2w2JrH8dKKx8ijsHKSY/NotLe60xhgKCpNGxuQdPDssUgmElqcW
	82JmmiLmv7Rw3fvYfVHg8UpGyYYucIQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cLtgzE2m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFA3F40015;
	Thu, 26 Nov 2026 14:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2CE1F000C6;
	Thu, 26 Nov 2026 14:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795703019;
	bh=TM3nSQU4U49T6GuNdT3oigc7kZQ4pNCPYHhbPmQrcTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cLtgzE2m1YoJXGpueRMJ0WG9tvSKfNQlB02h6sqo7+CT8SIX7diyIjeNQZEBq+Rmt
	 c3wVUQBaScWcqNmdizx9oeZqhcQnvwkubrAnPGao9ZHg/pRNuxscJLtGFEwWhyKHZe
	 nD/eW4RvR6/G4RIOLr/J3D0i1W1bfaIVV4gV6Xo1o3NxvrDYmUXGUKIoxb5lrWYo0q
	 Xm3lS0pcjZzeAgfeDD994mnwvbbJ6Bb4w8QRSJ88kkDhfkdRtNyJf6tq4OTMhrIQma
	 cQteoWOcf297BZrDLqN31mAQGOYddmIaQKOZUGDlnYAJ1X9HJwRkWGecY/FtSID7JT
	 LyLKLX3iIqGPg==
Date: Thu, 26 Nov 2026 14:23:37 +0000
From: Harry Yoo <harry@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Robin Murphy <robin.murphy@arm.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Amir Goldstein <amir73il@gmail.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Eric Dumazet <edumazet@kernel.org>
Subject: Re: [PATCH slab/for-next v2 04/14] fs/buffer: specify
 SLAB_MAY_ACCOUNT for buffer_head cache
Message-ID: <awhA1sW94lviTsgT@thinkstation>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
 <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-4-7c680f02a734@kernel.org>
 <gmnosp2u47xewnszzrx4asmldxsyjtejyrbrng2ckrcfedymeu@evhwupv3iwhf>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gmnosp2u47xewnszzrx4asmldxsyjtejyrbrng2ckrcfedymeu@evhwupv3iwhf>
X-Stat-Signature: yqbhpo1ixk5a95we9juky8dut79px6h7
X-Rspamd-Queue-Id: B3CE3100008
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795703020-296852
X-HE-Meta: U2FsdGVkX19/FJSKcxG/Jn1R1vCuQMnI27O1G3zUQIIV0kcPlq/gUbLNiHORsA9bpvrk73gW4NNchrpoDL9FL/fXzbd2Gq9/1ur784dwCk56K1ZD/UVFJ+BpSIFDmLqWkZU88XXG9DgYtMa2TOOgEKtHx6KF17ePki9w3PWu+rco618LiRdMGHWFMqRFp7XlqEdEYtp06hbazeFirix/c9DxOeMj82DsG2dr1w/zF+9Sg9wCrJQkw+z/mIDvwJIT3/9KUjQ/2xzMVkY+fBtEIRaLEOVUR1KDw8R9lC9QtFMGUGCyxiEyNj2YDCaU/8V8WgdpDff8beUd2chEaty0098Lima62H2eaKDwjqWPA78x5l0zJhdduHyiY8PBrXWnBDneEuZU0pOsrmaNr1CSuCJsgB60VdibHq5sSNhFDkq9E3su4kBRlX2Y8lo0eH/0/i01ouOrfqyFGuYnrdCQibWwVhrQh99w5dhkrHcsHlYR3Op5AtMHImPbR64ohPLEHXK+Ol71PlLvSB1g2XyNzXOO/ZHx6AZKO2qlHVlbwoSPxpqKgZFzmIIgBmSQoQEC1ora1sMte+JHPo+RSK1smueLjb1/JKQkDVzapS8MaxfPFV9dAb0ur3D8KL5qGKRXFHEsYNKG9Lwo06ODLjOS0Mpoqa2pHNCmbFhK41mDN3cRl8QGME3upgSnbxdmO+87e6CGu43W4LhNHkG17IetNzMejQhqacQVjyfXcUJQK8L65GASgiJx6Dzv/B5NNjoSvGyFflVT2OUBVmx+fV4nr+5y/8QsH75HrW3x5UMLSbQP0OOZN+DTW29gj1a5Esmjm0P0mYj4oqPI8Dk8XgDwC2dYTAw30e0dt1OP50vNkfTmu6lxWisPsLNj98REYErRSvo5uYFWr+nzjYVg4rm4GWnu/usER0fHLaaVzIlc8v87DBcU4KOElqiHHIUq8rS1Y9xUa0vHeRvLxi5a0zP
 PxBJnxji
 eFxOc0OqBMKUDgqgne3gmSkhd9DyMQfMSgcH8VEvLi9eLONP+CZ89Rc9F21CP/J85mmHRVV84Hh/zJABHFnlMEP7HOXfM6PYWgURsZKko6KzA44gRmt9obxtmwHgEXHUt20Q2LqpbSh5xZE8c2ihOyBC+MqgjJr82PjTajR9sabexqsWm2FEIrvYmNTKhcDXV6Jq5xIuZBz6/aOJMXu4VD1om5gDoM6+9Ekri0ko0+ljJ49hPCbNvS5kyo5Eu8yxArmU9O4MOYr80BcrC7fZuC9GARlLSCz2kGKUmDpjPEjBrCvfVHwiFK+zK7V9nE7D0haezFsfyVkS+sNNIeX+ChXUCGb983UuHfwjCzO3IGGZZ2e7SWoaUFHq/Cjtzo/iejLzpBdZaLisJ+niSE7r0rH98/Q7lzEySasF1Oo6ZOB8TntMtdd3EAOtwvCgOMI7UkfP+l4bsAEkbAKX2Hask5mYAIUoKj4ONkybloF1Gmdx7fD69exF2z3HD6RTyxgz0YSQFygVCork6ZiW4W1M1LvQgBeBU5FB5CZdy0OXxu4KoZE4TS7G0YdayBkgP0g6ieMa2oO4THq9RkyOm8KmvAs5PN8Euev+wzvEbuP3gZM6iWO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 10:05:35AM +0100, Jan Kara wrote:
> On Wed 25-11-26 21:37:05, Harry Yoo (Meta) wrote:
> > Buffer heads are allocated with __GFP_ACCOUNT to charge them to the
> > memcg of the folio they are attached to. Specify SLAB_MAY_ACCOUNT when
> > the object may be charged to a memcg. __GFP_ACCOUNT without
> > SLAB_MAY_ACCOUNT will not be allowed.
> > 
> > Path: ext4_getblk() -> folio_alloc_buffers(GFP_NOFS | __GFP_ACCOUNT)
> >   -> alloc_buffer_head() -> kmem_cache_zalloc(bh_cachep)
> > 
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: linux-fsdevel@vger.kernel.org
> > Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> 
> Looks good. Feel free to add:

Thank you for reviewing them, Jan!

> Acked-by: Jan Kara <jack@suse.cz>

-- 
Cheers,
Harry / Hyeonggon

