Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53BE3E98FA8
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 05:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0376B0005; Thu,  9 Apr 2026 01:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1906B0088; Thu,  9 Apr 2026 01:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90136B008A; Thu,  9 Apr 2026 01:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90D946B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:52:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46F5613AAB0
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:52:13 +0000 (UTC)
X-FDA: 84637946946.21.7CC9EA6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id A83BBC0003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:52:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GjImWanb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775713931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMroIp8osf38V3IaXClZpIfCVNsX2ssW6flgtrb+9PY=;
	b=qrdhrrRrm68IejTTe0SdDuSp3dWRCTdCcPD8C6x6/oGJSY/WG+Z5+UeT4hH1Phq6fCPmq+
	CCR9Y1Y3Bx3YFf9fj41q8XTo6iXZMXoZ9t4SQtJ7Rw9oftCod5KT1aZC7Wy0SMBQljx1QP
	AK97h+uAJr1i8XlbxdIKhbK8za2jOhk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775713931; a=rsa-sha256;
	cv=none;
	b=MCm1AUN32MLklu/o0wOgMmu7nbd31wRlqZSrpFhk1FGA63p9r1iC6vhnz0h+de4zUbv1tu
	b7t3Rgy1sOZLb27VI+NijPyj4qVzHtBzuw2C3pYLNQgprdk9ie7hqLx+RwYigQOMt9EI8G
	Muux0jbJm40Cx+b4l/rBAhftP1r53QY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GjImWanb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UMroIp8osf38V3IaXClZpIfCVNsX2ssW6flgtrb+9PY=; b=GjImWanbIMK7nXuK5qKZSCtrNE
	oNnVSH3OUkvo5CX6JHlhy9ixgbdGUCQwaA1pC9QGZ4AJv+dsPYFwiIGMqEJiUqENHJ0mikyyM6Aqu
	ewutJGNUyP7Jk6QPTYBtFP0B4JXTqq0HokRr+jlOtWHGTJE9cCHVfoCU5Gw4eEz2ksWFOrEH2s388
	N0PizmOjfL4IUgBj9V9IvZAGz3iYLWoG/HiXuhrZLaq9NvNgPUO8I+vQs2+Ykiot1iQ82dTAqInPO
	mLoku86KJ3xFzEFOCO2HxlsYTVS/hZh4ayPfmdWxG3V777kCJpiLpIWSSmxHBl9MoPMye8V8MqJoH
	L7kHjjnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAiJD-00000009jZf-1UIA;
	Thu, 09 Apr 2026 05:52:07 +0000
Date: Wed, 8 Apr 2026 22:52:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Chuck Lever <chuck.lever@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] mm: kick writeback flusher instead of inline
 flush for IOCB_DONTCACHE
Message-ID: <adc-h4bhUFGqbejN@infradead.org>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
 <20260408-dontcache-v2-1-948dec1e756b@kernel.org>
 <tstklxm7.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tstklxm7.ritesh.list@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: A83BBC0003
X-Stat-Signature: cu6ot389e1du35z6mr5wrra9jbgzw6gn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775713931-410254
X-HE-Meta: U2FsdGVkX1+PvOC+VOj6ac7sdiuiRoC5Tr8H4NGaj3jvRAi3xAdnVwwaJvt3zsgWXdhISu9b0RfZtA3fJ0XlBNMGpiChQqLPO9wsB5k1CS7Hgznmj/GjW91xuBeJ9fXFlYxXU31Dnd81s2HPcU1zMZS0tyB6xTgSWgVsP0+mdUA12/LxTfp1ayIWb6AQ1xhX06jL58lMesDOtCb363pATttcOqka0Q5nik5w45N1PK2FknxAZ8hOz8PcEHzlNymu7fbe1g3DQKyP8utxEk3SU0bW9ijiH8KFN7xMfnZ53Pl+vFdDFOXTn4gRAFEOfpzvS26SyJwaycU3b9xXfYYMk5DX94QpfiGJZl04zKWJPEVbVfjU9nCPZrfyTBZNqSadL6vA0myGcTDmPR8zlnhghoAjQr7qLwxChcxJKHf+rTsJEb/LY2gqUA/Al2ec+rW9438ThU8ccylfRNmHpcZTcUKyKUnLZOmPTRjHclyd4s2nmueExMJCXym5L8bxK0hsSz81dEwhrNhayUb9SzXueaskEgBGX+Rvj/4fiaSzpOG1K3Ar2IoUTuQGEYreMtXxPa9FNzuIhqM36fdmx3T5URoFeyTDTTck8awV0aN6QFcaHCbxYLZ9QXfe9WSDPQYkFAiL9evm17wQ/RVIvSR2XWMyIvHF0F0Xe8+OAG62aCMAigxOz1Ay0Q1SigQmWH+XBktMd8s515YjSDjKG6YYpDnrhFwOf13wMZ+urvm6YaEYz0fkiXQQ7f5rAr39xH9OE5VyC92i6rKLxtzOwm0dCSW21k++f0uLb9PGjOhgEvtkMbYk+e3XvERZ7ZuK2xBB1SkbIDb2hwftqs0HwZf2V6x5PhVipCxPVjuav8HUy/LR5op9KBhHwmv1QCb3bgpYZWi5DlLrL5Rb2vO/q0N9SzdViWbY4GthGoBSRXKONWd/bjwz6CgCNmcVnkg5Gbh8chtjwW87cQGb69GH3ap
 PHWvGoU/
 su/LA3eV7uMZB9WWmtoRyRD2Qm3haRepbL5xfU/hbwoBhQiWbhZ1qVgEK3mIIZYiWhvFjvseWnGPX2q5bGFRfD8R8pDnr9ZHBRMPnBEkKt77V4/lPQF2yr2DumJPsmStaBbBkiZhz7JxKAEWWWnTnCoAnK77rn9uFAZQ/PDDCH5QMoTjaN1klEA/QCBVTLdcGzjoMC8Rs3IBJsXrnnh8O+rTxkJlnuVTt7URDklS4AoqAoW9MHB11Gn4Qu/DUYMKfTVKKh2tsHjgX2HJ8lDA9WRP85t6eZvEfvKOE5E3NukaOQZ/RgXGXwsqRWTMumE4noXPL72wRWeS/lodHwGT3Y7xsb+zlu7QvWEA8whSShaADv+P2EvwWvu+ddrVWRz7r2VTrliiEvONfzpUvt1TCn71xj60ttR3GSajoUNRz1dmFa21Id6MXuGARj8CRlqKNlReVpl+uBM58s5/z8a8Vky+UmMb1xJg07aV0e8dh95X9/AjipOgT3/t7b2YCVxBqF0CPGEU9jeAPnJggq+Kf+W3L/ViwL+pLPkMD4FqjPAScgfROJ4XZDQBVjkpNeK2ppUfH5WUgaG/E87MtkNFqreFtGSAERwyQpvXW4ZOqJ2YzOspbK2MPtAbiqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 07:10:32AM +0530, Ritesh Harjani wrote:
> > +void filemap_dontcache_kick_writeback(struct address_space *mapping)
> 
> This api gives a wrong sense that we are kicking writeback to write
> dirty pages which belongs to only this inode's address space mapping.
> But instead we are starting wb for everything on the respective bdi.
> 
> So instead why not just export symbol for wakeup_flusher_threads_bdi()
> and use it instead?

I'd rather not expose that to wide with the extra reason arguments
that's not otherwise exposed outside the core writeback code.

Btw, wakeup_flusher_threads_bdi should really be marked static in
fs-writeback.c as well.


