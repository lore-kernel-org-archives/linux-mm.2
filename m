Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBCF606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 10:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VA7vkIli
Received: by kanga.kvack.org (Postfix)
	id CF38D6B05B2; Tue, 10 Nov 2026 05:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA30B6B05B3; Tue, 10 Nov 2026 05:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94D66B05B4; Tue, 10 Nov 2026 05:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 955486B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:38:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25C64120333
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:38:47 +0000 (UTC)
X-FDA: 85418861094.23.F210AAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2728FC0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:38:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VA7vkIli;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794307125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQ0DS0Yy8VyjCq5n0JUyQOmDm0G3x8Yvcc3go50QGK4=;
	b=x4GAo8WZg8g4rQbr+kS69akVVPiAmL7+6biW78gJaE3t62v1Ls4fKndu3Em/ThCrtE+ii6
	sK9BzC0XCMUIwc7440v1KLiY72Wj809nZeYU2WLUlePtgKl+4Ha85kVYTsGnyHdrqzHwIh
	rbSZH9KeWmEuHHpFREsUzY/XAlA+2IM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VA7vkIli;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794307125;
	b=bcNyCY145uzxPwS9VmvjMvl4ramQFfDrNMk4jhb3vBYQ1st5hw8LXUnqkOVg0lFigFWRkZ
	a0UgHxFS13x5ML7s2EDVbw5EQELXlC+3fVBPo6b10S0cNpZPpvS1bkq6KuMAML2G6jnrP3
	9cI8ZP+QCXSoS/Mx3SxBKUZziWyI4K0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6D5D6342A;
	Tue, 10 Nov 2026 10:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EEA1F008A1;
	Tue, 10 Nov 2026 10:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794307122;
	bh=mQ0DS0Yy8VyjCq5n0JUyQOmDm0G3x8Yvcc3go50QGK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VA7vkIliY0Ztaj06KemdysXY2ShPF36SA67qzn3Y7EspqalUShDr0Zvmwk4mUzgMz
	 D7C5Q/2Hy/c+aecN+TjWr5+tvgdeCtKR4ys31nRIpSBp00bi17SxrEzfvBg8t2+7Q5
	 37X1cKmCS7TZ1oJOe6dbRkV6LSoEQ+K3+rfepHMsoOn5C6awNp1BZgbnaR2VABySS7
	 Br6vIBJtDwr8oHfSFqioRNuZXZuXFB4mXtqvLeOvZpT3kUP1u+6/441mi5ksGqelmg
	 BD00h/t4pkYorNPjTOX6aHg5B+mNfAS1Dw7tlwhwH30rF6p9ndhRXd0IIDOyXupnIU
	 ub6rq0b8A892w==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id 380A4198003A;
	Tue, 10 Nov 2026 05:38:37 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Tue, 10 Nov 2026 05:38:39 -0500
X-ME-Sender: <xms:LPTyatmUbxJgSZktfPqGS2Z6OsMjabocvOi8l0b0TClsHNG3DMGmYA>
    <xme:LPTyamcR6cxXfFpfEt2X7Qmm3WeRQTS79eyALv107GPdK16udKMpLVOisTtoDXKnG
    fgrAEJuEk8maJeyseaL3ruKOunQxBLaBd22hqHuHtMJx2PGqybxke5Y>
X-ME-Received: <xmr:LPTyarCEC9F6JjYHwRFja7vpGiEzFrIsJzAuuc11hODgCnkIIuBRW2fwqVk>
X-ME-Proxy-Cause: dmFkZTFs0g82Q615OOi52Z+HeqblqOjR9pJf46YJWaxBBkrTfmDH1DT3GRc2z52s85cgSQ
    zwotZW92pknBwJZYo59uM7Lq7grvAcP0knUyDQiaUeG4F2yDycT3TYzZqh907BB00Q3GpF
    iUjtDL+bPvAwKm3xC5c+XCLhrD9yIiHSOfYa8wOM08a4FZSeRJIvm7tryb7c4cHiIK1fuD
    5z/tOkoNNNU2nKYuj816Kcl05EInBe4GR3/eKR2nKwtS5zyPwBzF/qCV2q2+N4SqsZMSFD
    nKZ/v7wQdPVe+pqRKtQ4v+i48RG7x6CX+58Kew/ntsptS3134PWiry1EVOdsL/g72ZXOH+
    85xJfZu+wxE2a+dvxCZWU6D1nLtGUmSP0M0fOmJK7HC/a428CJ3H+dEPcUxpqqQqIeLMR4
    aasmt2Q5qr6Q++FK4iQ5tBab+65qdPwlRPjXUEEXhcJ+8ojPSTB8L+jeudNQUTOS89Xv9o
    9EbmfRW3KZa76ThHIFfso/Ixbkz+sfqZqDPKLjNoBnUhzGmAy0A5u378aHgLQ1XmWiXPrj
    mBuufjwXwHs1nyyDrKFm4dhqeXtWvUfdUvCsXl0bOxwgEWMbDiYWtGI1qfnimBVH0liYKU
    Th9Zi8y7s2yjZ7EgCBzW7fRZpOLu5356tvi18a+W9oz6a7fHm/hY64v5GbzA
X-ME-Proxy: <xmx:LPTyalxrhR-fExjznWXSF6EO7BmDkdL4ho0cSRMbZ-FizOgerDLdIg>
    <xmx:LPTyajgW-xR50qn9nZkd92gK80pksCNHnC_7D8b65n2C8y5_sfXYxQ>
    <xmx:LPTyasdGDnQHo4_Ls_X4HrGcakm1JH-G_HGTHooDdfjqW5m-FU2lWA>
    <xmx:LPTyaqU3_RlwvCph_hdTkvqLTVQvNNUfuaRDsQL3_LeJpdOpDSzv3A>
    <xmx:LPTyamwLQLAdRgsDYzfnyeLGGYoh2Xrvh1Pdkdg05erRA0MI13r004gI>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 05:38:35 -0500 (EST)
Date: Tue, 10 Nov 2026 10:38:34 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after
 ->page_mkwrite()
Message-ID: <avLzpIM1VdE31a-B@thinkstation>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-2-kas@kernel.org>
 <avItd6rDqP3GB6pL@casper.infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avItd6rDqP3GB6pL@casper.infradead.org>
X-Stat-Signature: meuzu4dicn8uxfbdy9y7r9464fjceipg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2728FC0009
X-HE-Tag: 1794307124-548341
X-HE-Meta: U2FsdGVkX1/Bnpv59TUd1JkMcHi7O0eItwcXTA3mgwHEfhvoJospfMQDMzXRNdkDYHmn5FyPTz46uDXrvuLWj/66es2eXKlo0rO/I5YfsGhsANpv2ehqQriWR3P6YFM/RybprVQDGgkUYTQ2Bvy9d7yYSd2QpqkXu9TLRzfv5tRAa9NwHA5hMCRxr39AIckU8MNTLwTCREehGsanzhgi7c91GRaed4LFnRV7g/zrovnLONbhcx1o2YCNILxw6sDiJnfZE9QfPZY3Tr7LW9WOKCNcdrdizd1KhYfsxhMF6uRAI1QtpSu3St5Ve1Dz2k2eFqz85Zvw7ZzWUVhr6RT82a03NGVkuZQzWt1/LK1+DlsUYcqxP8WvVzkqQyBfemG6HkwTmg/Y9kzQ/xzmYoW54tOMylRiUr5qb63uVjJphwqxDVVpU/rER4e7fKD9xzCAMkT5/IG8Ry5GBbe16AM3BFymdFhFrKGTMr7vT3AMRwdmpoRaEk4DX3oKufM6U+A/kobSRD8hZR+hTLDso62xX4KpLp4Ohh6k68qntDUWcWkqlr6g73bR1U7FSx2IYPjgKgaK2wufhdf2a6lpNk/WvfHYDTAnWEfTV34HyxE4HyPMbkiHqbKUklUzGH3ozWSvH8ozzbRwXF50UP++A82XMKL4xzqXAneVovACh0BWqGDvICC+g6aXzpb5DlgeCF/DGJDm90os/lRCf1WcSMWGPFdJJhXwHfPXOtRApvBuvJQ0O2BjNm6lPUajudQVxP3Bgj7xcoUUBidQ7PX0q0IKJEyiQBW+XJj4CqCcUZlw4UVJv2z9OuTLgJsHjfLw2ZUXTigO5ztR8em0LJPwakknV7f+YxQ00agxUWMr/v2LK9BEsnP4sGjePW5ec3OqwZjAUGxMkJrd0Z+99D+pKffwr4xy/qYjsGgv+7FT7E1mydCnl701P7yXg5m9h7HQbc1Sg07LI4VrTtRXOoQaovz
 P2gkGx2O
 QI9HEjVv+wEhG96xjrB8g1pAxp8sOlFk9yFbkfvoF/NPf66vJfg/6lUmjMllZmvo1Pfi8KPUFWKBGwJponsuupzN3zuMFPbnPLn/L3EmccKDXC6vF+ha8xsPT2Nr15FqkpgJPRe8RTpki7/hINHrBRHWw/etRAbP9bNcOxu/GEcV2jV1krwEf4l4hzMu5JmP3VlWUceSEa1jmRRmHMusW4cRiiJxyo7o0caSgBVpTIMIS3s5GeRg18DOq7b5kdawlXnFBCen4T+LEC77SSZJMYdIT2xdB6AL7998RFPcCLIYDe4wnf47n5v49LuorpTI2ZK4bqs2EgmYA6YQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 08:30:47PM +0000, Matthew Wilcox wrote:
> On Mon, Nov 09, 2026 at 12:04:01PM +0000, Kiryl Shutsemau (Meta) wrote:
> > do_shared_fault() unlocks the folio around ->page_mkwrite(). Writeback
> > can lock it in that window, fail, and clear PG_uptodate with the folio
> > left in the page cache. ecryptfs_writepages() does this when encryption
> > fails. filemap_page_mkwrite() relocks the folio and checks only
> > ->mapping, so the fault maps a folio that is not uptodate:
> 
> Filesystems that do this are buggy.  They shuld be fixed, not worked
> around like this.

Fair. What is your take on the way out?

Is there a timeline for the filesystem fixes?

Until they land, mm should still not map a folio that is not uptodate.

Would WARN_ON_ONCE() and SIGBUS, like the other checks in 2/2, work for
you? It flags the buggy filesystem instead of hiding it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

