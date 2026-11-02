Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78169606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 18:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ZTAz20uq
Received: by kanga.kvack.org (Postfix)
	id 7FB436B00EF; Mon,  2 Nov 2026 13:11:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC126B05B1; Mon,  2 Nov 2026 13:11:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69CB36B05B2; Mon,  2 Nov 2026 13:11:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 402EF6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:11:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEBD4A01EE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:11:15 +0000 (UTC)
X-FDA: 85390970910.10.89C9ED7
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id E217B2000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:11:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZTAz20uq;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793643074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQruTCC5hEy9EJEA7VtNTy/+BSL1Xc1NZBa6W4LKkR0=;
	b=xZR3NdORrmFV2Nsx4e4VSNELXbjRbLhwFUTTC3oVjgU+7t6NzePDT16J0Nisv3vsu9oVIU
	OWvK+DaJuCrAXJYMnL6qVlY+HxboZ39xta7n0DqQuJ5VkMEesgGg0T3Avcgaut1StqYAr2
	ezYbp2JgGfsJL0INKdQn2upeyL5R13g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZTAz20uq;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793643074;
	b=RbKqfA0uzyAKc+fQZqmkrE1VT5CUjrrV/75B+h0T1zjTkGfZOp/9zUAzahlUEdiBFEa7j1
	hZ/VqpffcA8Pluya08IDTZm8N1CgZ6DnV5ttzToWx5DqtDxCzgsJ8TuovXNx/pmNr44J+V
	ulKl+HAJa8+EKIKo/CR3vVNId+S4WE4=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48c5358fc28so2684899f8f.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 10:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793643072; x=1794247872; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aQruTCC5hEy9EJEA7VtNTy/+BSL1Xc1NZBa6W4LKkR0=;
        b=ZTAz20uqDpdTYhCMB1jHJTpf/QFdR9zhUItG1Osnmd3eInlxlKxt9wllq0hEtr2tZV
         6/w6LD19Mckj6i7g7IA0xz2Tu/USaXJ7zZowjcJEI+ZBAe7BtuBb/o1Vv6njc25Gs1dg
         Zpeuh4D5qaEaJZ0YXA64jyMju/UVYQfGkbdSOZZ4zEjMFnKx+qR0qqjWvcv9yMv4JYxo
         /91Kz1n8bHAlIYUIaUkFpMu0NucBvwE++egGw0ndIbPKsvGYMiTY83lRHt7Sjma4Nay9
         t8+DwFcpU99WbWz1L6ypCkLHoZo34icq3F8dpXmaTAYvJEzBXXEvggVv8H+/OY3HPiqE
         KMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793643072; x=1794247872;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aQruTCC5hEy9EJEA7VtNTy/+BSL1Xc1NZBa6W4LKkR0=;
        b=0vD1CqY5is0pDxaEmDTqKTLIZDHLvQv+E0vEnKUvUrl3MqOHoWyUlo0i/p9C/F9zIw
         3xij3FzmWTSg07HCgMIPJ7wySXg4bMaTxE8a+esF/lfj8ZpVUEdnNF/h9qM3oAXf9CoS
         KxG5mGnMA6qNF5MWX1kABfitbj2eqbw618Tfx64Dwm/8AGKNrMHQc3UJRvy4IVwsMPFK
         8aj71N6fkbML0XI3DAwg8egtadtxLMvEXAsmROGKvsg3yJKdumDPze2SyNkgGuoQ1ZUM
         qUfC2mCKlKU7uHJ85hFceNT+l5gL+/jCbOuaRV55Xu77Xm2/CBtGTHWLa4d61CZpleMy
         zL7w==
X-Forwarded-Encrypted: i=1; AKwUvBwgARWfOLwncfjCYXJuSgBHnbaUSXt0Muju5PqTPig+HeOAxg4uIUqnmAjDiWMiG+T2Sw00d1U/lA==@kvack.org
X-Gm-Message-State: AFq9FYJ6nL+PW1YPN3epKwJ4b1ZiuAkj9D2i1xZaytcRzZL385OJjwLs
	tciVx4b6B5lrP1+ap1QGG1rFFdibtQd0eacJ+yVg+ANntpCADfUn/eBMAf0AiM8vRg8=
X-Gm-Gg: AYBFou2j7ZzoTqYKq6K5Gz8afAttqFvKhdZbaOEKLSSeql+JmAOVGtTarjnAnKDNLSL
	kEA9pajbnkYg0gqZ7T0Pz1fUGO2BkK7OpjFOBEzNfQBh5eyMImIu9IsdP2IKCi5ZUQN4i4HBdDN
	MD84nDs5O8ZojlOZlcsCAY1yYIQgvwwzyN3DRhNMcLRJyWGT/grW7Jfh0P7dIDao3vZBBRg1any
	TTs9ixXuuw9T9wNryshghKBkw0Ig1JbVt1Uq01tQDRvvSozG3CunrginYJVNyOROAgsuwMuGbLp
	+UxRr5U8g+lx/rRCc8kqG4xlJZ2Iv6T5WD9c5xX+iLx/tdD8jl2f+ZH2L5pAIYBivyO4OtvfGDP
	leSs1fP1eyMGXXJ42z2weWJu3+E99AMuteXYaWamX0myeyKQepSw95ZBGfJxXWaiEbgjwJDr6Nj
	sQgRcR20e254dLJIViWLxRIaWgrvTWx0vonHSnkv1mji7hFAVYpO6/1qLtCTe3DTVToi0Gv6sbw
	Iv5cRS5VFwW9tMYRQ5QhXAj3S6a4wmHkKLiaD0u9QL6UqFaFP1lNxaT2aX6rHnzmJBYt3SDzvoB
	mi+pAZqMLwS+okeqiSxY/GG8FZ049Nj0OWvSjGs=
X-Received: by 2002:a05:600c:1c0f:b0:4a2:150f:1601 with SMTP id 5b1f17b1804b1-4ac1709a7bdmr254417725e9.12.1793643072380;
        Mon, 02 Nov 2026 10:11:12 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a82cebc1sm5836795e9.1.2026.11.02.10.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 10:11:12 -0800 (PST)
Date: Mon, 2 Nov 2026 19:11:11 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <aujSP_sfbasQaKu7@tiehlicka>
References: <aui3TJqadHUv-4RW@tiehlicka>
 <20261102163014.237806-1-joshua.hahnjy@gmail.com>
 <aujCcqKKyio7oZ0x@tiehlicka>
 <CAN+CAwOwRJUDXHj0RMr4p2+sdA1V9bX-OgOH1PpER+u_cB2fAg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+CAwOwRJUDXHj0RMr4p2+sdA1V9bX-OgOH1PpER+u_cB2fAg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E217B2000A
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: cyecia1yw68rmq9h8t34zxpakkifgb8f
X-HE-Tag: 1793643073-679235
X-HE-Meta: U2FsdGVkX1+RKyknA4rMG8bzbALp1yM5u79mgjNasMxf+n1nmjgNKdF0iVMgFLsyttxlMRbPIpgwuM1GxWKps7PWSVuQ1Tk1zlhAKP1MhiL9hARgPJ2wPDjih4Q8/8jF3CRAxoSQzPqiUDW74dwVYyT9HZG7HqM+INjhgBUxME+NCldmZVO8iNJShuIITaiUYPJ4+NIbm6tXt8GL3vacrtbTb1DrOjlinrXS7SrJCHb62ClGrx9hqVybb2Kzod9CosSxxtXoEEHt39TbIt/jDKJX0by2IZza0M1RzfXHLbu0iKWM00lCVpB6LpErEp4sxl/cliErLELs+2DC91EXmYS2VytsTqZF3V5hA2Nw9/TPaL+WN3+tYuHIXmHPyXpfdqNMf6L75IKT59K0WZ1cdJ7o4Oh2wXnAwUA6zZ4vhuEfXsmbFXyFb5k45LylJunZIA5rSTi+KdixolB2qVLxBe3ZamQUIubXbzPiZQRlh3PcCXCbsYu9douuZrRCakqs6PZkNhoqSy83MMkBu/QOkMSsy/AXt4gNfZV924CCu/rEtIChTA7ZLUE/FZFoW56rg2O4xXeZ2ut0dYp+2NFaKDh4LJscK/iKumyPlKIEdBRb45nwhKmJltxrtUtootuw9Grp/dSzSOOob94ERFej9t8NdY4EbC0DINYmPwZqU6NfuQDQ92BuP9Q67IpEF7A3g9pNo0HjBpaGylPw0ld9z9gQnvRJ0uwYezXL53S30tiRMPW0ou6QnFDxJTBTFrxSsp4sWk+hp2ivDojXw1ggsSdgWxfJBYmHRasu/gFcWpe/UcOCiC5El4tRll9fgOvbum+1cPWlgdrNyXq6Jc3WGrfovK1wnNe342LIA3vZTfi8+f/s18EUhga+k8zCmyifNeQwFUOATNetdBEtGj+8J2XLy4sDZlGGhZKKEKsMT2jBWQye+CR2BfqhsS9Utb4RX9dMi+7oEA67av2ywCU
 1KZAAxrO
 7faR44/2R8YhNanSQ6azUDAJVuAAdSyfGphQCeKr9L0XIFKmDy9NeesOjoJ3m+ZBcOlHWgLWe2uOCPR8aJzpyECyDzffPA6muHZd57ZTCUvcOrq0RGwZ5a4Nq/oLbvzOte4c+qJoIeLLJeQNj/ZaAqXhi7S7ONBbWF9PcY7fjP4qBkO0qTA52wr6Y/0FtkOAgjj7R2foQQjSk5R0tlmlxAdEsZNgBNljGCHjkiBXDDHABLjHXxsjt48GkoX8E7Cy0IAMjUnBXy+zRc3lpQXTAZly+QieT1g/4obalgpbleROqxlnNPPmZO8/hPEHZ6EP2AhR6XKs2e6EDqAY+bTxAs4iCOM1gD8gIkYibEzPwN1SxRZutituD6s0pIzb453jxD7/4JXvK9zD96koq4s4HvXxeChk4xt1bx8Qbg9cLuKs6ZvWtD5d09Wjho2O30pUPyI+rI8ylTuwJ6VUDr7WXhBu1+BGWaG7VoOHd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 12:40:33, Joshua Hahn wrote:
> > > > > Personally I am a big fan of how try_charge_memcg looks after this
> > > > > series, what do you think?
> > > > >
> > > > > > Quite honestly I am still not convinced this move
> > > > > > is the right thing but I would like to fully understand the mechanics
> > > > > > first. Having discrepancies among different counters just sounds like a
> > > > > > potential source of future problems.
> > > > >
> > > > > I hope that I can present a good argument for why this is not as
> > > > > concern as it may seem initially.
> > > > >
> > > > > My first point is that the memory usage counters were always fuzzy, as
> > > > > specified in the memcg v1 documentation too:
> > > > >
> > > > > usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
> > > > > usage, it's a fuzz value for efficient access.
> > > > >
> > > > > Secondly, the raw value of the usage is actually always accurate. It is
> > > > > just the stock portion that overcharge the memory at times, making it
> > > > > seem like there is a discrepancy. Flushing the memcg stock immediately
> > > > > bring the counters to their real values (like what happens right now).
> > > > >
> > > > > Finally, this is a change that is only limited to cgroup v1 users.
> > > >
> > > > Right but is there any actual point in adding caching for memsw charges
> > > > now? If you have a way to opt-in to caching then you can simply disabled
> > > > that for memsw counter altogether. Fewer problems to deal with, explain
> > > > etc...
> > >
> > > I think the problem actually still exists, unfortunately. In fact I
> > > think the issue becomes bigger if you remove stocking for memsw.
> >
> > Yes, you are right. We do actually cache memsw through the charging path
> > which charges both mem and memsw with the batch.
> 
> Thanks, Michal! So it seems like we are in alignment on everything
> except the cgroup v1 implications for fuzziness. FWIW I think nothing
> really changes from the userspace POV. memsw and memory usage has
> always been fuzzy due to stocking, so all this series does is to
> change "why" and "when" the stocking becomes fuzzy.

Right. The discrepancy was not so obvious but I agree that this change
doesn't fundamentally change the picture.

> What do you think about this? The other alternative would be to remove
> stocking for cgroup v1 users completely. But I am not sure that is a
> good solution either. For the record, I tried making the stock tied
> together so that they refill together, but that was a nightmare in
> terms of added complexity.

Nah, that seems overreaching without much added value. While we do not
support new features in v1 we shouldn't cripple performance for those
users unless there is no other way around.

-- 
Michal Hocko
SUSE Labs

