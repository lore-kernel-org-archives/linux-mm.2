Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCB4D26D6A
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A076B0005; Fri,  9 Jan 2026 10:32:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7E06B008A; Fri,  9 Jan 2026 10:32:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B96D6B008C; Fri,  9 Jan 2026 10:32:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 794446B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:32:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E04513938F
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:32:59 +0000 (UTC)
X-FDA: 84312818478.21.5628305
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4B5824000D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:32:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KkSdvwBq;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767972777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pi9MBBtLQ+Z6Az6ZIrDOMPEc6YOFfVuBvcpyenL6HZw=;
	b=BSwEV98W4hzPaVbEN3r7DY0rQY0qyunQ2LwbBNkLm5gNeZQBovVrUxqE2gvHv7kB/MHjzZ
	ZErXjNQB5Mgx96Q1quouz3Vy0gypIYsEQ/k/booDqFv7P4nVQ5QlOxQq26rHmglh/UxiCs
	vCRm8pIFrZXQpc8AaUq1oONquXuySyU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KkSdvwBq;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767972777; a=rsa-sha256;
	cv=none;
	b=zDa5hZnbpyApVY6bbi2URV5LupNl0hgJsviuEP9OFTWkd1Ky3/OpvgWZO+b3CkhNJLYkt4
	5Guq5LtKZkIuHosDtfSIL+LvjGW3yB7/6ESXtXVtfce5UFD34LjUAtc9tiio4eNuKBFR3q
	ZCriMarowXtCy+N33338/ospd7eBC0g=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-34c2f335681so2649404a91.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 07:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767972776; x=1768577576; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pi9MBBtLQ+Z6Az6ZIrDOMPEc6YOFfVuBvcpyenL6HZw=;
        b=KkSdvwBqjDuhoem8wpQWMqqiIJjIO8wdGUBYl81a1h1F73BptyQi4JazqJcno8bQXS
         piZJo0+28gwtXJxsMF1yhrultRcqJC2pCWd7/cN55Q1wF5vfPNBnoyHiLUW9NyYogXXA
         9/IZwYCQOycxM/V/SyMSLzP88bI33XbqAOlmGgDDQ8OXRjDg4/+QACQALlwhAQv/nzy/
         zdBsz8CC62b8HfQd+hbPzbblzZSeOU0LRdD9OwLNyyib5ud154KgHnh9T+ZR5QZ5HTT5
         0hYKsWRlsqbjGzAqhVy0bXfWdZw8N6vqNqiEa/Vw834Ujo5uoRTLXoDePvRRQJZF2EQr
         RwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767972776; x=1768577576;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pi9MBBtLQ+Z6Az6ZIrDOMPEc6YOFfVuBvcpyenL6HZw=;
        b=DCRMZZMPPDD0ejS3h1tSWZHvHaHRclQmOspPC38Tn0rxl078PqR2AJrvyeryE9TzvY
         LwrHP+bo1VNfc8BHHNLh//ofHEG50j1bEj7JjAojttIBW9EC8rv2PW+DkzDpxIGXNQWG
         aINyj14I2KpYM7Afe9CIG9c4zO9+1SwVJxJ/U5JGd/XO0BWVimsiTohv20zJf4KTy3fI
         WcvmxMBLM3cVFpD83UN1wsXBK2LpEgZYzcNgapG06mONjcAQ3WiMXi04g+GJB9cV7oXi
         R0hYFg01AACnJbHlatXl5bXWVpqFpSexepURb57vZBu3p1/pc1jeGZst23Hp/wLDeZfa
         u6OQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3R38fWHzjXp5LVyCQieVmgrm900zVb8Ldok9G7LLNy1Mpjq8CsC3ppDw5aA5hXpxTDfC4OfQ9TQ==@kvack.org
X-Gm-Message-State: AOJu0Yxh/fy/P3qDgzAnVIB1zeE6j/EsZbtRpfDluLGGwgjUHbQTr4qq
	AiEAEi0X0WosUO9B/j9AB0Zqp5YU5xQ0/fGee6MdJVIDP1uWWBFQjzY9
X-Gm-Gg: AY/fxX6QTe/MA5/2kh8mQNXr8gnBWth/DGWnjGkhHDaz9hE8d1rilyjU1Tc1SYa7gQ6
	nvDTETRedehjkKSc1RZBrr7he3mIfqe0MOroJare9DDOpogJGtQAgCATLwlGEDW8VkZqG7highK
	IS1aR3m0Qd3j/5DeZ8uxMYFPcuhPeBeTjqLg7+hGUX44jLL1Co9hppQ1SxvpiZ4cG8IxOpkpYAz
	wBGyj+yy4GMlxN7ifuzh50ab9tgLdROX88bXi0LYF2Qate6f6v/PaCfferE5BENmEWGs1ZOofuR
	ZHzCYZi7/KJTpNs4uge2dwbRbqzQDhfq+5FrdipknYU3pYCvcvr+aGB0xUxKpmlpfzk7odeSSKX
	aYOupcsVNyEqn+9powLXaKnoHi88kSM8MgUTkLpzk14Vn+bU+71YI6ch/m81eqoojyc39zdf3tS
	Nla6o=
X-Google-Smtp-Source: AGHT+IHcrtzAO+bIMCp7VJf6cVvYL7KCtM3NjFt78OIqdmkQu1Q/tiqyGp2Jn9iJI2z7jDarLLplnw==
X-Received: by 2002:a17:90b:4986:b0:330:bca5:13d9 with SMTP id 98e67ed59e1d1-34f68cee7f2mr8136123a91.32.1767972775949;
        Fri, 09 Jan 2026 07:32:55 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b9602d4sm3055529a91.12.2026.01.09.07.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 07:32:55 -0800 (PST)
Date: Fri, 9 Jan 2026 23:32:50 +0800
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
Message-ID: <aWEfjVqVpoatvOpI@ndev>
References: <20260109034723.1342798-1-wangjinchao600@gmail.com>
 <920c641e-e092-46f0-89cb-0f1c130d979a@kernel.org>
 <aWENkov0R-1nIB8M@ndev>
 <e792db5f-5ec4-4960-a2f8-fde490e0e366@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e792db5f-5ec4-4960-a2f8-fde490e0e366@kernel.org>
X-Stat-Signature: zu3k3pg17sqijzpatadd1m6xg616zsjp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B5824000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1767972777-167213
X-HE-Meta: U2FsdGVkX1/3AH0kch+3jl9lJCqjoCbleHcK7fPg9E1A9PeMSQU9Lg3jg3/Msf7WwictrwQj6i9Q6JJ9gmPSZ+bPXOT0uY5VLu/89qe0pyHZF0e/p+gFE2eahC4+3JN+zR3NRF5Sx5DWwAQ8eCU4wpg+et0lB0g3n1ODmFWiywgCRUkpW7ZJplzDTk/hLgU0JETVhQks6UuarnXLNzB+CKnfO8W6P3QgNIW6Iz4P2wDt50/StcZoUL14+iXQWnspJ4d8hszScnm2vgLa/k2hM2yBl1g0iIz5XM+2wvIyTAqLF27KDMgjhV1IUODVaAciDXOsceHA8LbkKVUBC7K/C2fLepBrU3kIInKEDNsALPPZ6dOS6n1exQ3cX3k1nz2TUWjdLqGz8Z2RGhLe9bagpIdP6m1G/OTpaM2eF3Iu3Hqee0HQh2QUWbxV7XbkIDHpJ6MlOTkzRRtICa7j3SLkbhUtGzHPOYNlOnC7UzPs2zMdJbnManWunjcXJpOWqE5aWxOUliJDzRS/zvI3uVcxZHnMdTFisSwCZbvZGpcDj4S+Qd8ohaWhScqDi0eUgMWtZgNALhyS8aOgKi+aAn40p6jh75B2RnP5iNh2/vqNoMw+2XYJHXo4Twq1ougRhBSGmXpq2ArC+Y2suJfoyRsGDjVDsAvQEyLu+DIDzUsS8+wI80JH8Qx0hTW4ldUkQG3ISzxSuKbrntEpag4/WNNQ9VRO6V9msVcOKECrrOXrGyL7R+l03I6AFhtpSnSljovfUhi63ZlJ2ezMEAShL3z9Ig7nIwbyHijAUjBuMFiEwKMik7cV+K9mjCFZUHO5tyf7E69LQJTiv55whKHlCBlguswZqvejUiQaVl7LuTgDVbEabVAkKlJ7+Kw2udBSEOVofwV/y04yA5ntRP47APVJumLf0RHaewUrSLcwJloizQa9JGI+MZ9OFiSEXPO44MjOUOJmV48aLN1Mqm6C0MW
 PBM+bSoM
 tGzImVumFT6fBefN4DWWPegq3kzMSa6k8hqp8X0LEFpgjpl/HK0NhbpgnQNvQKIiTWWaZlGPoT7bQySANYsUGdBHqS7XO990/d+OL4dzHkpUUipiX4N+I8dcmyEHm7RvoQB1Ezm+yePFP2mhmeCR5COIesqueplWKE5GwxGjQENRa7N4UV2cfHmAHjCJQs6cF0HGBqhLljyXC8ZzEHx3zyAXm7P1ptBZ5nrbjnBT7+W6jP5wRwa1XtoiKfNBwY8RAGIeU+LsOISeKZpOJxgCXvygv4NHyt5Giew3WhCzDTsyHWE6EXea7OdY/w0rxXi3vImW8CU/5yqeagXzimOY7/mHN51G4qHj3crM6OIdBp4pmx+OWma6oDmvkyUFnuKbVPwcIC3HWxW6CN0GD0akOHR0bK+2VfsczcNHM0cQkfqut2eA4E4p3ZRkOKnYmufEpEnBkkTkF6WEpX1SQd6VqxL9ZyRCDV1J046sg1SC7jSfg/uBxvYQqydVKzpw038KcnRfEouP8hDTeZTKe0gdpaz+G5YdCwWEkmuGuyK8Wzarer9KokUhDMF7guKj1TxsGFOR05YLqyVQj4jVIu+2kF/9bOLvLrIGPaoVdeoIG+EB5O1BbVxZN65Ytrd5a2YMEueW2Py6DGz2EdsbrPDzUt9zI7yA6XAkPZvBX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 03:18:37PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/9/26 15:16, Jinchao Wang wrote:
> > On Fri, Jan 09, 2026 at 02:39:08PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 1/9/26 04:47, Jinchao Wang wrote:
> > > > Fix an AB-BA deadlock between hugetlbfs_punch_hole() and page migration.
> > > > 
> > > > The deadlock occurs because migration violates the lock ordering defined
> > > > in mm/rmap.c for hugetlbfs:
> > > > 
> > > >     * hugetlbfs PageHuge() take locks in this order:
> > > >     * hugetlb_fault_mutex
> > > >     * vma_lock
> > > >     * mapping->i_mmap_rwsem
> > > >     * folio_lock
> > > > 
> > > > The following trace illustrates the inversion:
> > > > 
> > > > Task A (punch_hole):             Task B (migration):
> > > > --------------------             -------------------
> > > > 1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
> > > > 2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
> > > >      (blocks waiting for B)           (blocks waiting for A)
> > > > 
> > > > Task A is blocked in the punch-hole path:
> > > >     hugetlbfs_fallocate
> > > >       hugetlbfs_punch_hole
> > > >         hugetlbfs_zero_partial_page
> > > >           folio_lock
> > > > 
> > > > Task B is blocked in the migration path:
> > > >     migrate_pages
> > > >       unmap_and_move_huge_page
> > > >         remove_migration_ptes
> > > >           __rmap_walk_file
> > > >             i_mmap_lock_read
> > > > 
> > > > To fix this, adjust unmap_and_move_huge_page() to respect the established
> > > > hierarchy. If i_mmap_rwsem is acquired during try_to_migrate(), hold it
> > > 
> > > 
> > > I'm confused. Isn't it unmap_and_move_huge_page() that grabs the
> > > i_mmap_rwsem during hugetlb_page_mapping_lock_write() (where we do a
> > > try-lock)?
> > Yes, but the lock is released before remove_migration_ptes().
> > 
> > Task A can enter the race window between
> > 	i_mmap_unlock_write(mapping)
> > and
> > 	remove_migration_ptes() -> i_mmap_lock_read(mapping).
> > 
> > This window was introduced by the change below:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/mm/migrate.c?id=336bf30eb765
> 
> try_to_migrate() is not the problem, but remove_migration_ptes() ?
> 
> Anyhow, I saw that Willy sent out a version.
Thank you for letting me know.

> 
> -- 
> Cheers
> 
> David

