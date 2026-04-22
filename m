Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D10CCF9EDCB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 13:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1317B6B008A; Wed, 22 Apr 2026 09:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1386B008C; Wed, 22 Apr 2026 09:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A476B0092; Wed, 22 Apr 2026 09:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E39216B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:32:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AFC288DAA
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:32:04 +0000 (UTC)
X-FDA: 84686280168.25.97F5447
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id E4CD2C0008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:32:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vTn6Qv0m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TOumUbK5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vTn6Qv0m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TOumUbK5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776864722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HN5zu3O5NDCQecYBdAFeRk5Pdxg7tAGVVxbVQYx75NM=;
	b=SoZ8JrJA+h25VX75Df2BvRMIOCegqE6vmwADZWTEMf3uBFO+cNmIdtzHY9cy2eqXIrDIWK
	S2FxP5JpVxxfegPFIbbThLNfFY+LsvrLVhS7RPFWIPMfpDk6Cj/rMzYaob8lJagtue+0U/
	YGD3jLWjHdHPST5BU4qRU78yMVZpnno=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vTn6Qv0m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TOumUbK5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vTn6Qv0m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TOumUbK5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776864722; a=rsa-sha256;
	cv=none;
	b=dQZQJ5MbQYSXYDp4SyvRi7gadXPJ5u+C6IHkI19hzeiSQDCdasdh8i+4oKnKQbF+opK0Uy
	Kgyq2geklIBU35xIi6csI4oIUCSpf3U7H5SC2QQiEleitAWLv8sR6PoVvT78h8ieL7NqlP
	rMcukg52cByjYbn10z68l0eP9WsFrvQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7A3C65BCFD;
	Wed, 22 Apr 2026 13:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776864720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HN5zu3O5NDCQecYBdAFeRk5Pdxg7tAGVVxbVQYx75NM=;
	b=vTn6Qv0mp8OdfUcL7uE6xFLGQys4S5UwHgmui+9lNHAouwySzT6ZaHhowYIYUxVEsu9lEi
	Wwv1vAqgx95ohqjmy+nFNI+a2nnYYBitN1pCe78gqLxq9wfGx1qfG3aDiOJTHNEkI4CoFH
	yk73wPKrjdBsMfE2ZCs32iSJ8zHTFu8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776864720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HN5zu3O5NDCQecYBdAFeRk5Pdxg7tAGVVxbVQYx75NM=;
	b=TOumUbK5YxSOQ8c512vsxMH64GZYBIuHtAZX2RRR/m/AqaW2rqBvXoJ1fZLw/eQx+Ld5vJ
	2t5xh/O15ueZjnCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776864720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HN5zu3O5NDCQecYBdAFeRk5Pdxg7tAGVVxbVQYx75NM=;
	b=vTn6Qv0mp8OdfUcL7uE6xFLGQys4S5UwHgmui+9lNHAouwySzT6ZaHhowYIYUxVEsu9lEi
	Wwv1vAqgx95ohqjmy+nFNI+a2nnYYBitN1pCe78gqLxq9wfGx1qfG3aDiOJTHNEkI4CoFH
	yk73wPKrjdBsMfE2ZCs32iSJ8zHTFu8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776864720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HN5zu3O5NDCQecYBdAFeRk5Pdxg7tAGVVxbVQYx75NM=;
	b=TOumUbK5YxSOQ8c512vsxMH64GZYBIuHtAZX2RRR/m/AqaW2rqBvXoJ1fZLw/eQx+Ld5vJ
	2t5xh/O15ueZjnCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E813593AF;
	Wed, 22 Apr 2026 13:31:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C0e/E8/N6GlzKwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 22 Apr 2026 13:31:59 +0000
Date: Wed, 22 Apr 2026 14:31:57 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Frederick Mayle <fmayle@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, android-mm@google.com, kernel-team@android.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: limit filemap_fault readahead to VMA boundaries
Message-ID: <cxthb6g7tqgluwicuh7xc75i2bp27hjlrx3oreionu4duknk32@x4tmnklhvkfz>
References: <20260422005608.342028-1-fmayle@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422005608.342028-1-fmayle@google.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E4CD2C0008
X-Stat-Signature: eb8sp7hnxsjbq5orwgi78t566w8eiod5
X-Rspam-User: 
X-HE-Tag: 1776864721-685001
X-HE-Meta: U2FsdGVkX19t/qO3jcsMJpMo1Vs41Xyf9RR5DN26GHDG++zDpCCCLVfUYBFLWL88w4JhwaPO14DKAMnaNN4Aq32Mr/NGW2ff3ODntgPNgUn0xcZsd9F189Hu8Nj9H0Nq724MbRY1dqw5NY4P5bR2Wcc0euaj7FuQvhlUT0wa2ljMmSmf/9goq+1FLwCL1BMbaimtRSmYJOrP9tsnaU/f1TcB2IHiNqBA+bHziM0eX9CGkqckrhSzlloEkU9xHYf6J75cr6Uzyj8dThNpg93EXp819piJSbU/1yG58ToqjqOY7jSyVUVQ34WgCcsbS9Hgp76OlUTT/4c7LlfwWqFY3W4EQKyOsQvF3K/az46qZjedaJaACYaRU8LTQxom9xc0gq5GWDqgeqRRJDnBuALMRJaw+BtQ/8Z+IVs2oibV9tf/4JU497NQMxBO94ma/nKotSt8gENMI4/h4uVsgiUDAE2Ki7AoxUnG0ONbJ/AcvV92DVornOLf4oZNfedtdwYUCopHhxrsaPXXHq4N5jCNpJ+vVtiPde0KauFjAghw/M2VSXFIPCIYr/AAiskZ/vnD217s46VRtUO4zPsZNBqSL1PHSggxzupUykptnho5Vy56d9zvxm/qaFlGzJ9EFS+WdzTDYzmeuyjyMxfKrrHUCXuWf2oipCDYApC2C/dMQLbScI3iZgtH/yi9cQHm/IgZCMTSi3poSZSYCuM3LWb9pAXJkNNmoqRGXrL3bWq3UXMK3FFOiWuywHdQ1KfVyfB19Wk+FOm8Kjq0zWKCCfBjMdzrBWfWryhQ1jOPOPKogIHErMA6VocovaXeh1FT8WrmpbjNNX2ZPa3AmcLQ/bDyGlsFEolDfDBXXhzpiZkKgqh1onlvedECajGVKXTJvnnaOXAwBNtcl39QPrbEW+P8EZUvF3b7cQGoUmxFuigdMD7oveVmwvh/MyG2/3940wdm2Rdyl2XSe45SSmKBLO6
 oHkrw+7b
 uGlSuoqjf/NHqyqdf9893G3zqcDSd55NBzbGFrLXbdpu9G9MWIlhyO82r5pZ55ZscyQ9POsbeoXGVc0vw71ka97qAPvJued5yXjeBbfOlJVHEp+KmQDC1Q3PV1+UiJuMiZXIUsRzxGw28fAlNiTALgwwGDjNekD7pd9EjXqldOXaoaCLYLmSdYRUF/BZV0wBN9xgU//JUEUvWVGWl4JGNHHNfwsr9nXvM2tmInasNLsnY0tl09WKb2RUqunH/1JYn0tKOOxdG+sCwXUppL5CFjhkOFwG4sXSSe1JDRlrs1PLgGMxIUldzCQb7j+LKpLInc6qeuAq7t1SQHsIddqVSt9pYySjP/qfKlvzu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 05:56:07PM -0700, Frederick Mayle wrote:
> When a file mapping covers a strict subset of a file, an access to the
> mapping can trigger readahead of file pages outside the mapped region.
> Readahead is meant to prefetch pages likely to be accessed soon, but
> these pages aren't accessible via the same means, so it fair to say we
> don't have a good indicator they'll be accessed soon. Take an ELF file
> for example: An access to the end of a program's read-only segment isn't
> a sign that nearby file contents will be accessed next (they are likely
> to be mapped discontiguously, or not at all). The pressure from loading
> these pages into the cache can evict more useful pages.
> 
> To improve the behavior, make three changes:
> 
> * Introduce a new readahead_control option, max_index, as a hard limit
>   on the readahead. The existing file_ra_state->size can't be used as a
>   limit, it is more of a hint and can be increased by various
>   heuristics.
> * Set readahead_control->max_index to the end of the VMA in all of the
>   readahead paths that can be triggered from a fault on a file mapping
>   (both "sync" and "async" readahead).
> * Limit the read-around range start to the VMA's start.
> 
> Note that these changes only affect readahead triggered in the context
> of a fault, they do not affect readahead triggered by read syscalls. If
> a user mixes the two types of accesses, the behavior is expected to be
> the following: if a fault causes readahead and places a PG_readahead
> marker and then a read(2) syscall hits the PG_readahead marker, the
> resulting async readahead *will not* be limited to the VMA end.
> Conversely, if a read(2) syscall places a PG_readahead marker and then a
> fault hits the marker, the async readahead *will* be limited to the VMA
> end.
> 
> There is an edge case that the above motivation glosses over: A single
> file mapping might be backed by multiple VMAs. For example, a whole file
> could be mapped RW, then part of the mapping made RO using mprotect.
> This patch would hurt performance of a sequential read of such a
> mapping, the degree depending on how fragmented the VMAs are. A usage
> pattern like that is likely rare and already suffering from sub-optimal
> performance because, e.g., the fragmented VMAs limit the fault-around,
> so each VMA boundary in a sequential read would cause a minor fault.
> Still, this would make it worse. See a previous discussion of this topic
> at [1].
> 
> Tested by mapping and reading a small subset of a large file, then using
> the cachestat syscall to verify the number of cached pages didn't exceed
> the mapping size.
> 
> In practical scenarios, the effect depends on the specific file and
> usage. Sometimes there is no effect at all, but, for some ELF files in
> Android, we see ~20% fewer pages pull into the cache.

Didn't Android have a gigantically modified RA window? Could this be why
you're seeing such large effects? Or is this no longer the case?

-- 
Pedro

