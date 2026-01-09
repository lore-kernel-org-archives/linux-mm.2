Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77C0D1A631
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365826B0089; Fri,  9 Jan 2026 09:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313CB6B008A; Fri,  9 Jan 2026 09:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215C66B008C; Fri,  9 Jan 2026 09:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4F36B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:16:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A79B5B832
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:16:09 +0000 (UTC)
X-FDA: 84312624858.02.2E47DF0
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 756401C0010
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:16:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EtMFqmb0;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767968167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAu865RG13YPN+TrjnkLBNTQ4kJSTvKxWZR6NpMGsoU=;
	b=78uz8jJudMVEjO0J7bwZXBVtgnTuCML6/Q91liVrWRLL9mHZ7lL/RZUs3/RsyDS9LxxsVz
	TvkImlAaCK8d6raLFxDwTok4Nb83VnH/pro6+Vpdvu13QDXN/lv2bAcsdonpilErauxsJW
	yY8BUt9J36PPHcOU/pAGdFGvEwtM/pE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EtMFqmb0;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767968167; a=rsa-sha256;
	cv=none;
	b=KG9Ffl5gpo6oYj4ycBjuQ3xQe47hLgWNCnp5JlIkjdsYc/WxnstPEsvwcLd4Ecb0h1yUzB
	o+eAg0STMvlvz9s+VSKPXDuZrkgXOTGSBfa1q1u0slX5LDXD+757qlJ+RS/WpwzX91nOOa
	In3hqrA6WeguwY8Mv4BlTw7dUpZrxnI=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a0a95200e8so26041315ad.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 06:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767968166; x=1768572966; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aAu865RG13YPN+TrjnkLBNTQ4kJSTvKxWZR6NpMGsoU=;
        b=EtMFqmb05kWRm6PXcgQOYCfPAX1wcrhi/gcECsp6OMI/RNleQAn3zZb9C6hXqDggfP
         wdzDNxJn18ylBfgzrRCi4lFruPHDBe1ZmlngdZQF3QfFdBVWirw6C6PAaDdf2ui9IRXp
         tZqFaRZj2XpyqdJk9kzkmH3eJJNHlPefi40yv2QmLrUu0hda4usz96C3jcJAJpqmd5Wl
         TYbE67QdFw4yfSbOtQMSZfnDOVudcKO7yLrhVeXI8Y2eBH+ouQntYZJa31afp78W5jVb
         kYqPp8wQzoR55vKtvvo7jtau8JCsE1SNoxHCBOdxyxDBdw41moGwQ1bS44usIwNj03OS
         UCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767968166; x=1768572966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aAu865RG13YPN+TrjnkLBNTQ4kJSTvKxWZR6NpMGsoU=;
        b=cwpyRU2k220TqOQ8AW43BlTAzEP+9Vmxf8LQS+MuDqpQvIs19De3YDnCgHViF7UoWL
         XxnhpCidWFJe1usraJsfkKrx9HH+X67PL61R1rIB6rrJ8+iL81n/4H8eRygRExajYM2B
         5V3ZxFtEtBYbrBWkZmkqJRY4bBJ8pIRuMUtzwQlgvJTjo9+IxAZBn7u0GK0WgDnlzpP2
         nYKa16nSS47vh3D7ONOEniIYYoHL5ugSoF1eZB4rsKB4onxv7hXee6Icxa7bnpogn/7M
         NG/8xC+p0QqZlt55oJ/67oi3ybr1UMrPxvHrSZybalQ+VBfrLd5rQu+UgBr/nUUa1fwE
         DmYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIhmu+RhL/1ZgGbza6Rs7q1hAn63UU0VOaIJOl6FD7LfFY0I/r85XB+ofBmx9OLC5FxpT6zAbOEA==@kvack.org
X-Gm-Message-State: AOJu0YxHYAogs3RdFr7VsjN3W1ovyzhqvqAEZuNAiYeriMbN4fSMZGka
	FEpXWxMAH8w7+aXKDImQ8Hn1dxtPvIjzdnCJvAqJuPJeBr5dQsHMRWEe
X-Gm-Gg: AY/fxX5tJTVvB4Jv+oU5DoD7soGvqZ2Jme9rR36LXDaF2qJqlwb0Xn8CfokqDKKwvz2
	W5KTZgz7Zbr+Fr+XAYRKs1hZCT0JNCysREniCWt06n4Ap5CQQVriN76PWFq2mVTbO2d7NaGtF5e
	Eb9x/fna+mZgBEjEVjColZC2u4EW4RbWupy2/SmwscsaIdlxP5enBepJpJ19fxQJByczsBcFBHT
	Mcg62l7m6Bgpvbk4X3upMmSgy7O0KAiaS+Lmwdlx1XOJ8+N1FPNwNIMaXS/TCzJDPUBGHSQ9kYE
	L9+1TrJwFNt1M8dY+HEZOvuplK5rUoNDyKPVF6gXzDXqnFIFJ3CMilS0HYq0I9b+NKubN7FM7yT
	uvTKFh5NgEFhVXnnwnwC902oE0h0tk+MDUElttpuA//CdjjFtxMYUpTBQ843Q+VJII8yMbN8r6F
	C8+14=
X-Google-Smtp-Source: AGHT+IHgfpYIbRK+7/j7SI5n3j1GxFGSxQj4TtSlijDDau2mONeoD91EzRj6aL24cfbEyV7b8KUfVQ==
X-Received: by 2002:a17:902:ce07:b0:2a0:a92c:2cb6 with SMTP id d9443c01a7336-2a3ee4aadb3mr97742295ad.36.1767968165898;
        Fri, 09 Jan 2026 06:16:05 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc793fsm108248585ad.72.2026.01.09.06.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 06:16:05 -0800 (PST)
Date: Fri, 9 Jan 2026 22:16:00 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/migrate: fix hugetlbfs deadlock by respecting lock
 ordering
Message-ID: <aWENkov0R-1nIB8M@ndev>
References: <20260109034723.1342798-1-wangjinchao600@gmail.com>
 <920c641e-e092-46f0-89cb-0f1c130d979a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <920c641e-e092-46f0-89cb-0f1c130d979a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 756401C0010
X-Stat-Signature: bgkpmii7gjongzpjbs99hmytea9139kc
X-HE-Tag: 1767968167-318258
X-HE-Meta: U2FsdGVkX18SkeVXRjpA7jhlhbr2anokm8O+iW45vCiUnrxpVpWXsnwu7HiqfNJSsYYLU5cMM1rtXjlXirny0+PdfIe/WVlChKhurpLq/5z2I6d/BH6oPKwrlg8F0DLEnJEVYra0A7fELka42aaFuA4BkYEdslt1D+ns1ZQU+GuAN6SL4hAi7tVqklPoCZ833tIgxNkHTVHQWekoGL+8yQm55iGW5QmlgnMEbWl7qXTBp/q0amfgoBNttDrWuhdD6PtasyzQQ/mVwE6Yn0RVM+2zE76fWQFa/F7bZxx0pOxC+MB5DvFoJEUyhlPg9hX6FoK4lx+USN33bPBeE349sv1DM9sf3XNl9JgHAO986e3yKa5SwPmMgroLIy8wWZN6ni5G81ckGtbpMDvjKOi+vzvl2O4ScLOrPGyI3RNlGIh0VNCt7Lbpppknhzm8BECRTPUjs1+5E7Q+3lzcANuau6U7+/03O/7XgAn3EwjbGln9/LOt1oL6EbVL18I7eXqPRqxCdVXveR7iIzyeIlHlI7HGJrb4ItsYl23Q5KuG5uLqkxoxrafqA0fzj/N02u1WUAOC52+z/6HFjqqBqqhA/v96/dcmWG/ih00sP00OzLQsjlVYkhLiKJjnCoxX/a+RysDqD8p1EkrQ5IykrCCfOtqcVNbpi86qITebJLQ/WJuitHP9VMdN/oZf7ClyAtH5mkt1W8LECeMEuN0eV6RrkjEcQbJtm3qmD9Cwx2UgJNJhpEfoKtswhQi3qPSOpRtdFPYmAuP6QtlOV4U8u3YLhBrP+VCtuKxA3lrsmExoaQpRQhmUB+5tOVtGnhEmO7vpfyPwryPcg5P3DJfGCtcDc7HsArRps2ZM2Pmr2xzf5EK3FgGUw9Kfatq+a1gdh17/kRaj+SGoKrIW95Tw0xWzLlYQKXvkd9byPJLv/F1L1yZ0RDTgCz82+Z45eBBy5VTKk0B8I/5gTzSbRMmyPFy
 TZ8s0KZB
 cU8zS3bv+6iVan7M13zaVmtUvhSapg103mCyazerFVpexn8rsPJMfYarBmkzQvL7boKD/GBMmbI8Iia+MQcesxrb5ScetTerFKWPICcVHYbYDj0bmP3c9WhfFaVIC1ixdKVbxGsylzJvAXlHGSLPkyQXlGNLLZRbhovRIJD/9G6aPyqS7cNAEi7ZWlrMUBmoVX44phA2n5cq/A7mXVjIYgvvdgEPTAIKgNrec5FqDGEGuIhTGOxm9El4YmHcQ2vtoz/CrgdsNdPPIphb6/xXQpjRLVPMD40lXc92MQkD9yA5Fo2U6T0XaVCFY5m4ndLQ7KcrIieITnC3u8GSRBOQBlOe2R01cU2jx25A9B4j/XsyimN+Jz1TYkEEh0cebXLXOfGzJAd3lmb/j0rhjevIwfiwkKtLCMG07LNvtHipvUvbHaC2BSp7D7FQzSMy2reWaeBPFvhZePzffM//GaZNLoAc5i/Ac5GTK/dAd+Abe3jQWxd4lQktFkkHWkOnDZFPfDGcT6thK9Xl5DgKCcdQkYyOF/kzwLv3TuE0ODPQZ3CJlpgxdAuNW2Bm0ED1DqBlv/cLrI69oQgvOhU8lN9BSXVZbmMwgCmwBqN08Qa7MR7jYAo187uRgxdQsFy908P3a3Ai3hnk04FNIVB/++TQAf3by9HiV36Tjb0Tt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 02:39:08PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/9/26 04:47, Jinchao Wang wrote:
> > Fix an AB-BA deadlock between hugetlbfs_punch_hole() and page migration.
> > 
> > The deadlock occurs because migration violates the lock ordering defined
> > in mm/rmap.c for hugetlbfs:
> > 
> >    * hugetlbfs PageHuge() take locks in this order:
> >    * hugetlb_fault_mutex
> >    * vma_lock
> >    * mapping->i_mmap_rwsem
> >    * folio_lock
> > 
> > The following trace illustrates the inversion:
> > 
> > Task A (punch_hole):             Task B (migration):
> > --------------------             -------------------
> > 1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
> > 2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
> >     (blocks waiting for B)           (blocks waiting for A)
> > 
> > Task A is blocked in the punch-hole path:
> >    hugetlbfs_fallocate
> >      hugetlbfs_punch_hole
> >        hugetlbfs_zero_partial_page
> >          folio_lock
> > 
> > Task B is blocked in the migration path:
> >    migrate_pages
> >      unmap_and_move_huge_page
> >        remove_migration_ptes
> >          __rmap_walk_file
> >            i_mmap_lock_read
> > 
> > To fix this, adjust unmap_and_move_huge_page() to respect the established
> > hierarchy. If i_mmap_rwsem is acquired during try_to_migrate(), hold it
> 
> 
> I'm confused. Isn't it unmap_and_move_huge_page() that grabs the
> i_mmap_rwsem during hugetlb_page_mapping_lock_write() (where we do a
> try-lock)?
Yes, but the lock is released before remove_migration_ptes().

Task A can enter the race window between
	i_mmap_unlock_write(mapping)
and
	remove_migration_ptes() -> i_mmap_lock_read(mapping).

This window was introduced by the change below:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/mm/migrate.c?id=336bf30eb765

> 
> 
> We now handle file-backed folios correctly I think. Could we somehow also be
> in trouble for anon folios? Because there, we'd still take the rmap lock
> after grabbing the folio lock.
> 
> 
> -- 
> Cheers
> 
> David

