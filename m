Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBB2CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 20:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2966B0088; Sun, 21 Jun 2026 16:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82BD6B008A; Sun, 21 Jun 2026 16:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFFCD6B008C; Sun, 21 Jun 2026 16:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 877B56B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 16:49:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EADE1C546D
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 20:49:39 +0000 (UTC)
X-FDA: 84905110878.12.2F29399
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4AA4CC0009
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 20:49:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="g6iAM/3x";
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782074977;
	b=K6t5VTClf2Ahr2BikeptaCHMv3o8UFW1wmroFzHscOiSQ+G6ZcZhLH+wj1rBlfrHdafZDd
	aF/5+31gcMUV5tQ9Av83uwKcHs9HPr788djZ5OzUfdpq4Y0M4lO2wCgyxBKpTzwN8SGrfy
	TN//aQ+0ZTzVKHnRvocT5I3Kop3kS0Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="g6iAM/3x";
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782074977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8eA5erpVUaElEed48rJS2wGTR5+Yv1nLd38ESSS2Rw=;
	b=mvWIjJwJAkye8tnyPZMH9m5IbOqKHe1WsnbfiV3vU5/Vdp2iZq69P9JfPH0im0l4pp9tXO
	RX1C8kjWpa6D0WbN73CWK3k2bJMYutDbG3uuR+EFi10cnY1afYCWIeFL8OnDIuDJ8HOqsT
	EPCGh7VFM3NS34JXoRYRwSUg2vVSb6w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M8eA5erpVUaElEed48rJS2wGTR5+Yv1nLd38ESSS2Rw=; b=g6iAM/3xDdWgV5X+yh4FkmLv62
	OiHp0rJWKrS0azBEgV4lUi6tf73QIx3b1EfxkJWLE9+0vYHZwchHgBudDH0pHDxxXgTjwrWdu/mct
	Pv33b+2kvV7VjO9v7r9ZJhg42qZrzl0nH7+5lsv84CGZePPxYtNzgtc+jHFw/OqqVr5gfB6dJeyht
	Ta+Y3SqdvDLqXkzUCijftXQvtQR1xKMpDX3P8Pi4bp33DePJ+q2Ae6ol72ij7EXyHBJ2UsHVBJ0x9
	+qUBkAxK1+zVPdKdmOAH0oG08P8SIzHjxBxu4r6NIyihQBFDoDV5qvDZCRzyYtm8IkqtseF10HUAj
	vqUbW0Ug==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbP6X-00000002ysn-1JeK;
	Sun, 21 Jun 2026 20:49:21 +0000
Date: Sun, 21 Jun 2026 21:49:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org, vbabka@kernel.org, rppt@kernel.org,
	mhocko@suse.com, jack@suse.cz, pfalcato@suse.de,
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com,
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <ajhOUdbWsswgQyl2@casper.infradead.org>
References: <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
 <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
 <ag4h87CBd-gph9zX@casper.infradead.org>
 <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
 <ag4kj84EcKqamdB-@casper.infradead.org>
 <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
 <CAGsJ_4xC5LdhuoWV1=tK-RZ5rkjc8aOKOkmb1L_8BG_3gtJhDg@mail.gmail.com>
 <ahB6QyHgYq8ksj65@lucifer>
 <CAGsJ_4zxLvZ01i19vdo0xA47T1hxa1VRYvxLmiDhy5q1GDKPRg@mail.gmail.com>
 <CAJuCfpHTxaU4KdNmefU7C7cWZSLCFDLPdUrnqV6yzxzN+8RQ0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpHTxaU4KdNmefU7C7cWZSLCFDLPdUrnqV6yzxzN+8RQ0Q@mail.gmail.com>
X-Stat-Signature: fe9o8hptu4a537omic6qfwyo4z8mfxzo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4AA4CC0009
X-HE-Tag: 1782074976-27785
X-HE-Meta: U2FsdGVkX1/0AkHRcUvZql3vx0otVsUxrNuLWWda6UKEfKEn5rBkiZ5q/ZBH7Ov+HlQUFiFGmXyqLfXHcIPjkU4w8EW0o8C91+/z4mrqiAh+L5WJRVLffJmmciCDtk9NtUdk9WnUCPkX1t4lkYrzpQsEXfyGipRgXP7waCscf06halZbpYiXUhYOVIh7xGslhIe0RXD6riH/lAnNZRo69XJH7RJzWBCzVBdhkkj889NhyqITswAdQtN+jzvToQ8uLJyAFGhvhtIXTMCSVSxoy92PqZZ9v0fh3u0l3uGZ/upGBw+qatglR08aypYP40zvNWfcqlRAObup7sCdElHTNyPyKxicLsSE7qV2dpBOF+f6pIbstkAAXdeDKUz62Ol0a7VQ8x5wPbIAYuOLWaM0Zugym/JXPlUfsQ+s8l7vkfsLxOkypHfKsow/WnTgE3Z0sV9hFZfei0JIuies1TAWrZ/B8H7GhoRa+ioC1cTkVFWe0YuLOYli2RBq2DLKrzt+1Z/DJgRFm6KsQtCucfasV0gT859B5pHfprzROVcZZY/Zh8AozGOin/aIOO20L3okA9dQqsDawuJwq28S2Vi4oZtqZ1F+xv4yVYEAKD/Z8iyD+gYjoCYSkWs1ta+b9/u2q9f502HjP1kOXf4O3o57EUHzHrw5QLBk8GAVony+WPj20UN8vYcpPau3/GaK6tfD8/jT1Tk+oDClDWfZUb7dZ3mlpWyaiCwBs4vwlew9cizCJK55kZ8dpufUj9bmimwYQGy5w3c8+DN5Z8Kt2/Q07NicsN8g2jEg41Ga2ICvrxhfBUn5xD0ZUuG4c6WeWuuMAxxD6GIb/65+0ggn6NEcS/tG8jjh4TieCKd1TZVsuQagiuk3PhjXBwz6Vc87tQ+UxHcT50KZfg6tWo2m7jjVenHOEwleeiPJ7kC/vxQDMEWFi5RkialhsZF7mnxhXbHkwhb/bdjweS9o5jtZzK9
 X0KIKws6
 vWcoWLXdbkoUXkXMWR7tj0djDAjTXl26u86HpJENG14iZK6nToT84GGVuWNcU0ZXEgKlbk9Solfe2/pJDrrDSQokeCc6Lbg7lzsUv94LgoDMduxGBBiUeZaKCe69RO6hqrtDGjovJOtKMN5crE86rLZA8n9ZjIt6byh+4Bpcanb0ooweX+XsbKWzPaQfVm46RoUwnnx1R4yp0a7taS1WGlPio2XG3zdIpG8tEO6IQKWvN/SicditOzJB8osvbWYWUaUTzDukILMWLkwyiJNJim6U+HTaiq/tUobtNManvjdqa2d8tsMDNcczhS7jvYo26qrksDp5egrjSsjSSjf2wpv+gVZBf04znxg8jUgZiO3CYwzDELbNLOVCh/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 20, 2026 at 04:48:57PM -0700, Suren Baghdasaryan wrote:
> Just checking in on the followup plans. IIUC the RFC mentioned will
> try to implement the solution we discussed at LSFMM: splitting
> VM_FAULT_RETRY into two flags - one for retrying under per-VMA locks
> and another one to fallback to mmap_lock.

I continue to hate this idea.  I don't believe that those who were
pushing for it have ever tried to understand the whole fault path.
It's utterly byzantine.

I defy anyone to make sense of this:

        /*
         * NOTE! This will make us return with VM_FAULT_RETRY, but with
         * the fault lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
         * is supposed to work. We have way too many special cases..
         */
        if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
                return 0;

        *fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
        if (vmf->flags & FAULT_FLAG_KILLABLE) {
                if (__folio_lock_killable(folio)) {
                        /*
                         * We didn't have the right flags to drop the
                         * fault lock, but all fault_handlers only check
                         * for fatal signals if we return VM_FAULT_RETRY,
                         * so we need to drop the fault lock here and
                         * return 0 if we don't have a fpin.
                         */
                        if (*fpin == NULL)
                                release_fault_lock(vmf);
                        return 0;
                }

Wed need to simplify the fault path, not add additional complexity.
Josef has said he wouldn't've done the lock dropping had we had per-VMA
locks.  We should rip it out.

