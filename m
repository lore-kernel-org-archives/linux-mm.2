Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1653E9DE59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A1B6B0005; Thu,  9 Apr 2026 03:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B0A6B0088; Thu,  9 Apr 2026 03:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A2F6B008A; Thu,  9 Apr 2026 03:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F1CF86B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:19:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D726B8B85
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:19:22 +0000 (UTC)
X-FDA: 84638166564.12.FA441FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E175280004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:19:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KkPQXE2O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775719160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=my6LXn8xmgzajdOla0euu8Ri/1WZ4QR4CXhOVlghjT0=;
	b=ZiJ5cDwuFzN7CZykQPjfDuQvEjc8YdrfezeuuyXlSRcG3o+6viJGpZsKX4Iw6opOKJ1oQ+
	mVhfprXUB0cu83YsbjmeEuomd6Nzo0OenQs4Taw2qUAZWR89lmBj81Jda5DZQGDhZ/be4s
	/MPNvtCvLq6YA3e0zPtsv7T7CisJuQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775719160; a=rsa-sha256;
	cv=none;
	b=eSxgyuIjHCtMjBGN4eFbf/3uLV4fc6TCkapYJULDN4HnFCiKwdcn83T+TjjHaIr2z98VLs
	1rtIgWbVf9pl1U5fZc3a518l00z7N4XPQUVf015pSLRKUxcZjVFlMwGeu3MgmAJW4TEfJs
	mA6hbTUDgkWJ6R+QkbONDYyk+EiIM+c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KkPQXE2O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ADCE600AD;
	Thu,  9 Apr 2026 07:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D789AC4CEF7;
	Thu,  9 Apr 2026 07:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775719160;
	bh=my6LXn8xmgzajdOla0euu8Ri/1WZ4QR4CXhOVlghjT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KkPQXE2OV9lhdm+b7H4aSgxRaoDCoYGrSQ12jMsAv3+DSapTtrBfG+ibb6XjBr4Lj
	 iRKUx0U2FlzhVuuLSF5gYDCOWd4Zrp6t4pXODl90fgBQqoErjBWwkIVfhqzSP59mH4
	 /V5RPQitO2Ww3CqrUF6W+sUybi0mB1Kt4834r1PTqhEGI7nX5gtB9k7HPJg9nToZdN
	 DiPwFt99EAo6sAlGhgW2wviRWtMGGLfswjU9bBbfBLnJfl7/YODT8n1ui3Shj1YWAD
	 AD9Dq5hdWqIWwUKSRXg0+W96XVATFE9DpuBuLceVFcI18zIIXZwBN85m3qozzIy6uo
	 GvTroDgy7uqVA==
Date: Thu, 9 Apr 2026 08:19:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-ID: <addRr9Vn_LNiXp11@lucifer>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <addP4MKmA8zfSN1o@tiehlicka>
X-Rspamd-Queue-Id: E175280004
X-Stat-Signature: 9add8fbc7ktff43no6swdiddx9cmn74m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775719160-597895
X-HE-Meta: U2FsdGVkX1/Noo+XuTAqGoxnaQpXYV0XpUK5MXnH+W6lB8riPNLYjVv6/p6YzxKfcSZZv/GUbsE0xIfvUBBanw9bBB/E8TmMMdB9UvQyGoS8tkD5u51tW2UOFsOvFrwTMM6dEHWDV9oZ7ZTTc0oEu7R+exDE4+N3mNjSHfrH/Ei+B6cR4glA/Hl1QNbqG52LD/pTNn3zc6iiDyzKqS1GfUgNrWFaV6TPgvX7m2Mva52OeCtPu9XXm0+7plxmM5Ydg+qiqCLYLKmz7i6hbHhLGI7OWqrR+p87vKNbpIGDx7WspdfGySBG/Heu/rxEW4Hi4BwN+Nofsi19TZ3T6wJCvzR4usfSibNg4bb0RI16Dv9JO3DURjJ6cGkZtIjS2VUhAGcjtVYg0VihUJCrc3yHvuamtsgPMjcvD7mdVG2kZdd7qiAdChPzN/4USd2l0ohvU+rsqBxlxvU14al/cQ4TVzO0XOb4gA1PRBaEqKYl7okW2qJuHfuVpqM2sKeA0npSniyCT0ezNFv/uvSLZRW/Z+P8LhdTcyx0qQIYvDGvzYQq0QEs+3Pj5XOzyfy9Pu6cxi3yXWr/VDQ+mLIdi3YG/nMR9fM1MO3w/ZKH2HqHht26MuBlgN8T6eXtEBAyM2PR6CIuAbjDTIPXYeXXphT6eJeKy2gRajtohTd5Ak26U8uML11dsCff3psmBHZ5/kONg7+nCMF5oA268QmxFgEb09tmIzpw0SRaSZZq0HgR3fG3SbA1UFk6Laq8M+cQ+T893ig8fNskd7AOXVxb4snznKmDI7c8eil0GsAD6LHd8iOiZ8p0gcfyEJ1mRKLBhZuf9r1wqqJRGQPD3LKCLy6SjNORYsF/L35sQU7wBGpm/AOTX2jC10mYCBTB/1+mCg8IMP15mPEoUt0sLaNtClZT1TqCVbWLEBILf/zOSNiEZ2hra1K3MNiPEKBJLDif8eOkNy8FdYjXrXvFVH8G0OD
 z/A+0GV4
 muFW86CiDZ0SvHIvfuIy6acTyzJ0Rt0GR80OgqH+sW1yl9p8XYqa7YVZim/zCfB4iV/YuQtPbrU0JI0LA6wQb621idpoZnH088Zz5VixqIgOlvWhnz/8jRWdzExFOJ3q2/f+/0AF+3uQyKMrxPbl/PwMNSEfuLTCTVNuxQCc825N+c7dpRe5Sbobxk/wknujtiqlWoAGseuRP03P2uWweuyryoRrGn3tMK079hUhMK8fu5ETj0TWKHHB3g2KaIwnNrheVMoj5+ED15aR4X21YqcaKCQtd8hPK3Uo3xpCzvIU6Bok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 09:06:08AM +0200, Michal Hocko wrote:
> On Thu 09-04-26 14:35:03, Kefeng Wang wrote:
> > Add a sysfs interface at /sys/devices/system/node/nodeX/drop_caches
> > to allow dropping caches on a specific NUMA node.
> >
> > The existing global drop_caches mechanism (/proc/sys/vm/drop_caches)
> > operates across all NUMA nodes indiscriminately, causing,
> > - Unnecessary eviction of hot cache on some nodes
> > - Performance degradation for applications with NUMA affinity
> > - Long times spent on large systems with lots of memory
> >
> > By exposing a per-node interface, admistrator can,
> > - Target specific nodes experiencing memory pressure
> > - Preserve cache on unaffected nodes
> > - Perform reclamation with finer granularity
>
> Quite honestly drop_caches is not the best interface to build any new
> functionality on top of. It has backfired a lot in the past and we have
> tried to make it extra clear that this should be used for debugging
> purposes only. Extending it further sounds like a bad step.

Agreed, there is still _huge_ confusion out there as to what this is for.

(If I hear another person tell me this is a way to 'free up memory' I'll scream
:)

Really I think it should be seen as a legacy thing for, as Michal says,
debug purposes (it would have been a good idea to put this in debugfs tbh).

And adding something to sysfs as a permanent, maintained interface for this
purpose seems problematic.

What is the use-case for this? Why are you dropping the caches? Presumably
for debugging/perf measuring/etc. purposes? The cover letter is lacking
that.

I wonder, if this is something we should move forward with, whether we
might be better off putting it in debugfs as a result?

>
> > One use cases is hot-pluggable NUMA nodes, during hot-remove, simply
> > dropping pagecache is far more efficient than migrating large amounts
> > of pages to other nodes, which also eliminating the risk of accessing
> > potentially faulty memory.
>
> Does the per-node reclaim interface can help with this by
> any means?
>
> --
> Michal Hocko
> SUSE Labs

Thanks, Lorenzo

