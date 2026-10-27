Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573B2606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wa7KetCc;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=956mM1Hh;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wa7KetCc;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=956mM1Hh
Received: by kanga.kvack.org (Postfix)
	id 60F4F6B073A; Tue, 27 Oct 2026 10:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BFC56B073B; Tue, 27 Oct 2026 10:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487966B074E; Tue, 27 Oct 2026 10:00:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C12E6B073A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:00:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 434C740A23
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:00:08 +0000 (UTC)
X-FDA: 85368565296.19.B492159
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2BE454000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:00:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wa7KetCc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=956mM1Hh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wa7KetCc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=956mM1Hh;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=QX7OgTpYTBf1OEMDa6oSEkjCSpVkQxvJsoqRTZUhieWIyq3fvPh+BAUUGT+uWkuPRtVKvf
	OM2FKuCwTG/WfqsH8pcBYBYnuqQl/rAqLwPE0AkFULXpUeIz1NWXNRRp9baSxt7IxqEbIQ
	WjupgDaqag77pZ6n13yEEUEUP6C81ec=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wa7KetCc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=956mM1Hh;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wa7KetCc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=956mM1Hh;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109606;
	b=qA1mzdV66j14J6w4Dv/XtYW95ZAPrOMgJQ3PmkGm6Z7SafECqYOaggIlrgRxqbdXFLnMK7
	z1bvms2cLLzw2V9fHy9VN3pOy3rB+juEgRVdSePvz2n1yiqKWnabVU+08ButobiF8sPdSV
	sKXn+PTJ0CBsbJiwBr8usvZCNMZpLfI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 84B1F21E61;
	Tue, 27 Oct 2026 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793109604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=wa7KetCcAaJiubuHT9myBcZvkmhrVgro9A1fdapN9oYrkcQLCIHxC+WJV/2L0wql/HkN+A
	9DrGzp9hQR7/nDSOV6fDwiXXSeoTdKz93Ai+moQcyyTgcFLaeGsaeTUVo/rDpmX5D9WNzk
	6lS9BKqcTy1tQjNHwe/i3I/5/fi07Io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793109604;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=956mM1Hhfx26MGleRkCZBYBnmuUGWBKItOp21Bg4WzpVyauT/hY8Z+TSVbV0Bq6OSOaWV3
	D6v0EguQnGAnF3Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793109604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=wa7KetCcAaJiubuHT9myBcZvkmhrVgro9A1fdapN9oYrkcQLCIHxC+WJV/2L0wql/HkN+A
	9DrGzp9hQR7/nDSOV6fDwiXXSeoTdKz93Ai+moQcyyTgcFLaeGsaeTUVo/rDpmX5D9WNzk
	6lS9BKqcTy1tQjNHwe/i3I/5/fi07Io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793109604;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=956mM1Hhfx26MGleRkCZBYBnmuUGWBKItOp21Bg4WzpVyauT/hY8Z+TSVbV0Bq6OSOaWV3
	D6v0EguQnGAnF3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57C1F1321C;
	Tue, 27 Oct 2026 14:00:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QziECmGu4GqdawAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 14:00:01 +0000
Date: Tue, 27 Oct 2026 13:59:59 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, ryan.roberts@arm.com, 
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com, 
	dipietro.salvatore@gmail.com, rvvandan@amazon.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, linkinjeon@kernel.org, sj1557.seo@samsung.com, 
	yuezhang.mo@sony.com, miklos@szeredi.hu, agruenba@redhat.com, djwong@kernel.org, 
	hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com, cem@kernel.org, 
	dlemoal@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, willy@infradead.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	exfat@lists.linux.dev, fuse-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-xfs@vger.kernel.org, ntfs@lists.linux.dev, ntfs3@lists.linux.dev
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for
 per-block dirty folios
Message-ID: <auCrqvae2tm4a8PV@pedro-suse.tail5790ac.ts.net>
References: <20261027112702.3747009-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027112702.3747009-1-dipiets@amazon.it>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2BE454000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: gymzsrtjgdnmkhow3wk7mkf4scjsc9ka
X-HE-Tag: 1793109606-441696
X-HE-Meta: U2FsdGVkX1/07NsScHLbFH6JBFo1jAyekF44bTWsT/UGIzVZq9pRiYfmx+g5SCICLwoYbvy7X8vTaIwO0otbmemP6vgY81Oefu42PbLgs/kRNvn03k6ALUZxiy/NIiGIaoaxIdq2oM7GELBA6EJFKr12JsqJnWcWLT9zyliokt03LFzHtBhfoD5sK+PoDun7q+TRh3ItoFFQUP21kqGu5wdHpRyuhgiTUDPDe+V2h3Slz2WGsZMz/x0SWLe0KtK42a6rjd1waVgUSnfPAHmZ3KpIMDpiqNi9/oya8CUHLSlyYosryVJlZYlYrYpRJxLHAfTCpD3fgC8OJMARLb7rrBm5KGdwlnnjkXNXDuA7tdLses4pl470O2QxLQm70tOb8PNo/5yCrh5QScXu2gG/iv9I3gr/G/DCFvjtXOSBuyjCOg2wZYA5f9FmmS2YqttDlZnl/NcE+YHggxEL3BARY1hShsVDN1bgLOytnfzVrDGpEBoqhagYNPp7Yp+usXz83SjhcCWc2pGi+Uzz/qHvgr58UvL/Fwod6NfXJIe3DP79ZJKx5OTIzYHa+Qc4t9++db+RciSpjfcpTc/sUh9NmMI/36EB0ggUAPxfE34I9xKVHtVImJ8tcFGkwu86Kozzg4p+dLAiaTXtHeSwmzvFeBJ/jfLNenwOCrf/YKRX3QmLki+7WCbKJ+veympiaOd+Hc4Kp6b2sPzypOnDblJqA9wl30qNngaG/iAGk2+ZQI6yieobjOPg8scCqxjzixCKKGbOpb8bPm3P3sgpZfuuvHKMDjJ49CebfPd4l2XBujf4CheGepB9ZfMSUba1LrgBtXWJ+6+KNajttztsXswiIje/5Ie1BjNvITHXlNLSZvDHvLOMVP3de8gceIYYhfodwn7Tb/cv7JbcvHOusqnP6yxFtxktRkWeAFoTA3R0bEDF6VKWJLRFTSKlTXrkvVnCf0+yEScQxWdS6TpWJGQ
 QagkIYHz
 fXAYX5SkZEQx3YrZwzJi9aYdNXj0pnEW6SPofepAIZr3QG3KrmBioW3mdBTFKY+q17V3cSKG+ifXX01F6VXEfoAiX8QTM7EuL3ytcZ34GB8LvETfSZaWDTTL/XacktX5QCuXAtyaSCL6627SkwEPLA2hzXsrL39EGVZWLsamq351ofTG9Xno2U103GeWYlA0Mrs1L6tw8Zm05fxKN+St6VYCyx0L7QTCGK3c/EH6FUQGVN+rpTaVtAhtEB+xSFxzW/eOTpIqtrqJsO0VdQHBmQIqwkNdjaU4+/L31MY8qGhMf1e/3V2tYVRdBGswkDDKJAb3D/Q/DJXzC0ckpYh5x+7sLeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 11:27:00AM +0000, Salvatore Dipietro wrote:
> Since iomap gained per-block dirty tracking, a large folio can be
> partially dirty: struct iomap_folio_state records exactly which
> blocks are dirty, and writeback only writes those ranges.  The mm
> dirty accounting, however, still charges the whole folio even if a
> single block is dirty (up to 512x over-accounting for a 2 MB folio
> over 4 KB blocks).
> 
> balance_dirty_pages() then throttles writers against a number that
> is unrelated to how much data actually needs writing back.  On
> workloads that repeatedly dirty small ranges of large folios --
> e.g. PostgreSQL, which writes mostly 8/16 KB pages -- dirty_thresh
> is crossed and writers are throttled long before the real dirty data
> justifies it.  On the benchmark below, run on v7.3-rc7, the
> unpatched kernel charges ~159 TB of dirtied pages while writing
> ~6 TB to the array, a factor of 27; with this series the dirtied
> pages charged match the data actually written.
> 
> This series makes iomap charge and discharge the mm dirty counters
> per dirty page for folios that carry per-block dirty state, so a
> partially dirty large folio is accounted for the dirty part only:

Why? This looks wrong. Yes, you may only have dirtied e.g 4K out of a 2MB
folio, but the whole 2MB folio is still effectively pinned by the VM, awaiting
cleaning + writeback. And that's precisely what we want to measure and
throttle in certain cases, so that e.g the VM system never finds itself
short of clean pages it can reclaim, and no easy way to start writeback
on them.

-- 
Pedro

