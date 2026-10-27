Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A554A606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rLs6rqyh
Received: by kanga.kvack.org (Postfix)
	id ADFB16B079B; Tue, 27 Oct 2026 10:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB76D6B079D; Tue, 27 Oct 2026 10:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4FB6B079E; Tue, 27 Oct 2026 10:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8061B6B079B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:52:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DD821609CC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:52:18 +0000 (UTC)
X-FDA: 85368696756.19.00965EF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id B8B1720003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:52:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rLs6rqyh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of BATV+5ddddd22d41095c15bfa+8465+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5ddddd22d41095c15bfa+8465+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793112736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6tANbXVc93T7yW6YA2N4Glo5t3dM5+cQLoI/r0aaGY=;
	b=xkYm8Eho28cDiPInj2gqftYlqMbqMLl61TzMDdh19wHYDIocCt038QYqPRhaAyVpJ547ix
	GfBvJCeiihejtj/Aa3aVjXZF+p0NbOnj5ZNCCp9lKGJv8ii0D2g21OANB91GfaGdN+N/Vw
	0a+gjigQ+V57uyCP3sRiwExwJ4aCROA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rLs6rqyh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of BATV+5ddddd22d41095c15bfa+8465+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5ddddd22d41095c15bfa+8465+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793112736;
	b=62yEnG4qG3uZsSF2T9F9q/2UJl6QpzupHZoEr1kbBn/6kp7KsCThtbWRJH9wD7LA/9KzxD
	HyA6TWrixSlge9TV1gfBJ/0QEeSFhiiNhS6g8CotN7tG8tOGS9cmjFrr73Xz6LvTagf5Ev
	XhSr+LTcMdDBbSEvk3NQYmW/gEpuE3I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P6tANbXVc93T7yW6YA2N4Glo5t3dM5+cQLoI/r0aaGY=; b=rLs6rqyhDOw/NXKF/SP8+CTSZH
	qbTYw9VIim7fajpTfrXF3sqd+fF8H4LtqmnAg88jHEqT0vuXQH2H94KKptegoPDQGeWtlIk4H4GpR
	A/r/yWyXtXeptvCA9vBFzUz6+Wi5/bso9y/RoTXSo39dN5hEmVYR9G8FfOOlWrDqbn/9co0Tlne9f
	J6cudkigt6aLVvIw/bRFeTibUUX9rzQ0EY/xNJ0RCKDS0dkcMsMySK+U+RNTFhnceuDuKRrte3jKZ
	8EyxijgDf5M2GXI+AucqdNG3ls4oDzx+UaB+6mMbi8oM5lpaVUV+q5K9ukeIZC3KKpR5SGTp6fs4f
	BZmMWIzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLiX6-0000000553s-448k;
	Tue, 27 Oct 2026 14:52:12 +0000
Date: Tue, 27 Oct 2026 07:52:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Jiale Yao <yaojiale02@163.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/5] filemap: drain in-flight DIO before buffered writes
Message-ID: <auC6nG2jSfRhyaMM@infradead.org>
References: <20261025124115.3178287-1-yaojiale02@163.com>
 <20261025124115.3178287-2-yaojiale02@163.com>
 <ddkjou5djippzkzf4euqg4wvsnjsc23fw4qldwi3hru5cxg4ul@eyts4mtzasxt>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddkjou5djippzkzf4euqg4wvsnjsc23fw4qldwi3hru5cxg4ul@eyts4mtzasxt>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: B8B1720003
X-Rspam-User: 
X-Stat-Signature: 7p9zdhydha3mh9jk4ysqfhcdw1qi6r9x
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793112735-56160
X-HE-Meta: U2FsdGVkX1+iyB58Z8eDNFoPV377sK8WFkJ0g2goo1GMIEevaVmdKo2q52eUCI5Y4jEWZDYatqdmcc6cFGX7x96an35JRnK6aiYvpkT/DFzOG7l6YZViPjIwxySQcZHbQvHuXC0wOBH9ZzKJ3hCcnnv/32qkLX5M7zj74rzBlViikv3DrssxRcExavFw0Y4BtqwCyPR54aq3yzk+DBG2zm6vKPrj894NAGc2C8XwrcYgbuZEZXF/sJanap0mQYo7RrxWtebNi9wN8oZjQJ1KvYq+lcfeXFEtDd6/JdMkHWonuh9x2FSLe8tJZHd7E/Zold/+C4Qd7qiouUP9fuQTzDx524ZKepjW6KiBymEKD+j5s/ptZTqb9atjWgX+UPLOWP6309KnIO5d9ac9Vil4iOteFZAQ2m8kDcXHpMuw9ZHjSMNCtSan9GmZO9yTwnq0RkkL5IzOE6kLaEvuJdHDzy6F1h6nHLW4oP+omeIo6BJbXBtwL87zsFvJSuOwLpl8JXGCiAHgTeHMecMWHW3BzD24A2CTKNYpO3/VaMMuO0khJc0onO3A2wOBe25e/HLE0yjQqlF7La2FralIUVIreke+cx7JnF/dA9kEgLCFiqpvu602oz5jZz6GHwDDJxfxiBwlOhzQq+qrEq/WD7JW/+qVqR6PDjjRuMBjzQ4wAaAALDZjk+OBM3TMJ9sTipm2tTh13CoWh9I6TrEsqzJdKAazwjUm1XxDmVpAoH8uDMN7KlJKBBzGHQlBht4+uGL+SDJi9qStkyOjl81dDe6wyqKexaCxp4C5bzPaDbcMRr/aBg25XRi9MsXrITM9XU872/W64K/WzVIr9R9i/RCsfiu+/qkNW4KdZr0HT1EhFre++s75WPHFwbhdIly2F0hFSiNcNpe4uFsA5Mgz9mkgqjGE/mQwOfzjf8IcK5+PncnfKaRzld8095Ec7IiMWKJgiSZSn3oiZl20yEK1JWV
 ybN1845N
 RyOlJEAL1p92+JHFSw7uTGUnVSY2rlc68FSxecEsCyDrRspgMa8RCNh3HzFOU+O05GpcW2JfECyFu7m/eC7E1kclanPe1SbEmH0UE+D0qYc5oUgFXsX3s7bOG2I33XpDn0sWB73DrUmU2acPuNJfFzHCnnpdcKwLIJAWzixDH3VkXuqfFu7ttX58yWLDHWQ97+kYrO/wVhGC0OhqU+7GMqTxGGz7RyByt+4AIQjSdInRhRTzLx8X2p+KV8rJmbzm3NyhuR3rl8gMyfeikbNwvONTwuTz9rfACr3G70SRrPGBAMs0Fu6vp71jn7wUxMyUwffD/lEUbHwtDn7zq4ODWx6JY6rNvgvxG4/GszsxQMWughrRMTHeIAy+9F6aJGzpsef/+lkddJr7Ue7wrLEu58DY+7jeiHAqrxxfiuLa36xYuWh0yL53hij0oDE294+IXtrA384+RFbVoeyYRQX5if/SFxoKswW2Rm0gUxAauynBfqEHOwYgebf2Tz//cuZytO8NUsP2Glr5/geEwmuGRyAL0iOdREXHtcL+s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 02:31:31PM +0100, Jan Kara wrote:
> > An asynchronous direct write can remain in flight after its submitting
> > thread releases the inode lock. A buffered write can then dirty page
> > cache before the direct write completes its post-I/O invalidation. The
> > invalidation finds dirty pages, reports a possible data corruption, and
> > records -EIO in the mapping error sequence.
> 
> Well, when you do stupid things, you get stupid results. We were always
> saying mixing buffered and direct IO in the same file isn't a good idea and
> we try to not screw users too badly but give no promises. This falls into
> that cathegory... So I don't think there's much to fix here.

We have declared it stupid, but people do it anyway.  See all the nfsd
patches floating around for in-kernel consumers doing this heavy
and fine grained mixing.  So I think we should get this right, and we
should also have test in xfstests to verify the beavior instead of just
shooting into the sky.  (related: I only see patches 1 and 5 in my
fsdevel inbox, something is messed up with the series)

> The only
> sensible exception here are simple filesystems which have only simple
> support for direct IO and fallback to buffered IO for the rest. But I think
> we should handle these on a case-by-case basis and either drop the support
> for direct IO altogether or convert them to iomap and properly handle the
> waiting in their .write_iter methods (like e.g. ext2 does it).

That's a bit too easy.  There actually is a much better option, which
unfortunately is much more invasive:  kill i_dio_wait and move to
non-owner unlocking of i_rwsem from the asynchronous completion handler.
That gets us sane locking behavior without any footguns.  I really
regret adding i_dio_wait in hindsight - yes, the PREEMPT_RT folks
hat locks that aren't bound to tasks, but we ended up with a few of
those anyway and thus have the primitives, and file read/write is a
case where they really fit.


