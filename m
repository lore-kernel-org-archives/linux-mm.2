Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27FDC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98CD6B0088; Wed, 23 Sep 2026 18:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49C66B008A; Wed, 23 Sep 2026 18:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14826B008C; Wed, 23 Sep 2026 18:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 760716B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:26:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3F351A0152
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:26:50 +0000 (UTC)
X-FDA: 85246462980.30.1B73303
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2785E40004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:26:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nRSYytqt;
	spf=pass (imf04.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790202409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5bBPD/fgdc2g+Epb2XIUlms+kxdY9UZmRZAc6Exgfw=;
	b=24rPn7IYyzXNBecbvDGazkneCp111rTpmHC9egjLP57QcRVhlfvjTWkdzjKTvTGlwTv9iI
	hvgZfjo8qa1owKfhcXX5DSOGkXwbsZR9WL+Ut+xCGIMWKYj8PPFj/wUViYnSpCVRXtqhul
	tbqi84Fa6ShXDAAFYhuuSbDbYUGb0jI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790202409;
	b=OlrTAwIPRBfb6lbMEf9hWxlEAkk3bqYLPjpwvHoSdzemMmCMw8ae36ftgjizB3kL0O9Xy1
	xiw0xCIdOsWCVv90f/ifyz+qLtS+oLpGt1VeGf0tdbQMIngxjFV/6+8b+n5edML9wFfqHU
	/bGYdVLmPyB0ZEh956ku46+QTZgo/DI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nRSYytqt;
	spf=pass (imf04.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso10404065e9.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790202408; x=1790807208; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z5bBPD/fgdc2g+Epb2XIUlms+kxdY9UZmRZAc6Exgfw=;
        b=nRSYytqtQ3uFvEwRci8qiQuPTkWmwCIE3BokLryq/3YLAfgyvUALdKQge5YnRsQ1OR
         Q/6g/b+1cC6EOjYpmt3esq/ebOXTwn3djFVyPu5ufoLae9f8sQpEOk/u2a2mQg/yZUur
         iN3UkbR38Lj1k1baav5O16s/D2zng0tOGl6cw7QTMWilLZzsjh1IKgElwgf0qRut9m9V
         2hqfjz0+PXA3MuFL3bywfXT32r+ExkAZ6fQs8De8PeSRPpBRTEUlIB9E8bOJMYlBsxjF
         kE9R2UcCL79Jy6AuTsMWCCotekBpYS0qeuiXI8VsMzj29yh68RvvlzKLlmwjOLlelEbL
         ZDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790202408; x=1790807208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z5bBPD/fgdc2g+Epb2XIUlms+kxdY9UZmRZAc6Exgfw=;
        b=UTzdaWVTLY4DRPoUhZrbS33pOjLDM/RHNYT35HPTkU9acL7K3QMGGiTGTxbI6XR7rl
         N198IU1gPDehWFvjBp5bFnQZI+hUOHpHNfcdMUsHWxnrgYBLEE8PHHbhjACOV4GxlyHh
         1NBr+LKcIW6voYrpbwsMFJTrOfsT+O6Z1KWiASAXbsCQYItK/r2ejz1eDAwLNyEmTx2R
         f41QmIrqTItKdkNOpLhpkoavglR7TtDI9t9DkJWF7Mq+qSi+B+thbnqgPC9bChyvUT/T
         +05WDS8L15wV1FxbR0ltd+d0H3BrF3bQ2EoBhiRc7RlUvchkxKJWEN1QxqvG1CYUWzir
         q5VQ==
X-Forwarded-Encrypted: i=1; AKwUvBwxEgZ77YS8T3gbmkGmyWAxs9Y5gKwdMSy2mnwzmJSCMpZxe2K8jTCsbumScoRUuwxjclrXRaBGtg==@kvack.org
X-Gm-Message-State: AFuF++mroY3Dghtx4BL2j/xJI2ALtcGEhmRNPc4kWnDfyWTX343emVna
	r09Guj2tmrAn6xupsFa9FUBZygDLYCLQO+HyBRqpJCURGM0THuDA/fBf7IcnyWs2VhYTpJmg
X-Gm-Gg: AYBFou35xyQF7OzSBYHeL5TqPEVksqTvxi8/yq1rnRQXTpbXLXilaTyXqxi1Ho4JmTK
	ihHFyN4l1uk9d+ekiBDXvgz5q838rk4lV3dhtB7anSVvwZuK2/2pbCyz7lsLuztU/OQtnVBOP4z
	+879dxyirSV8zr2vljfu2FR9fi2nJCwTXQrG5j74tZOJnDaK4R+z+kUUie832PkfjdI4zz6gepQ
	kcv/xVodlrZCUM9bR5870JvV+VOm9PNtjpL4CVc+QFitaZEXuwS9KGqqcNTt3nYejiiBYKxRcaR
	aEgnp0H9Ww0/fX6QtUkt62j+oXAnWBrJa1EA3/3P+GUoP97IIdsDWfT4THLLhVdbHewrQ6FTsgM
	4w/m3knLXTH8f4FulqDlgKp5FrKRhgjsrGdwjxukZIuSVDBhxkOnoFe8WuWziM6XlGiJI1MOTM8
	i+JDs0VTmxeBIWErMGMX5bzaIyATfvwz9aAFiYmK9EWKWdfRfuPoHOKOdIiz6C5CJDQ7MzMccRn
	RY/8j6BlbgVORzDJ+kIie848/f5uSbQazIJNzDJ+JDesaZ3HDPJpcnxBX4LuHoYIo9vDhyrkNXq
	LWx0yg==
X-Received: by 2002:a05:600c:8b8b:b0:49c:f512:2361 with SMTP id 5b1f17b1804b1-49fe66d470emr9604715e9.14.1790202407439;
        Wed, 23 Sep 2026 15:26:47 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5ba0444sm18212535e9.2.2026.09.23.15.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 15:26:46 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Toshi Kani <toshi.kani@hpe.com>,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm: avoid a reclaiming allocation in pud_free_pmd_page()
Date: Thu, 24 Sep 2026 03:26:43 +0500
Message-ID: <20260923222643.19010-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arQbFrGiilXn7ABD@pedro-suse.lan>
References: <arQbFrGiilXn7ABD@pedro-suse.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2785E40004
X-Stat-Signature: 6ey9ez7k77nwkw1w3f8jjysthc9mo8ef
X-Rspam-User: 
X-HE-Tag: 1790202408-620753
X-HE-Meta: U2FsdGVkX18oMzLUIUDYD8H4X2T9tLMFkXMVRdUQ8ly+NbVJZKx6+Qoh0AzRvxycEx7x59YyNz4CFB37e3YT6UXq4tq00BgHn03VfEYgs/Pb6PRL3CHMIUM+ltwUvqEt7BRTLON/k7PoOHtbXSb1S1OffyjE7t4XeI6jRmHWFSRm3hF/gCybUIjfylXup3QGAbyDpleq1Z1PvKldwPsbNAyuHdA3Q0OIbjJJFAWqdvD/OhJJ7f17NxTq7COEIo7oy0GVTbD0LZQW1AEf7KGCQ6iOFvM9oUn394MQ55qOt+5PpNCT427+BOM9D8k8MTMiA/4D5vjOZNrvK3+uix80xPIWp4mHVMCAAb3BYCxKpB/CiVbOTzUfakqVqyMk4UtHij/YIU8bjuavajYIDHYz0jnqgXlfsOOY5BgCLFgQkkoW2ueI3eJAXw4S2KIN6/Fi3vwlJBzrbddEvPIo/I7oJ94Ym2zNTluN9BLxdbg2eXIsimgLwS/aWA/hxF1hpPI+6Qrg/wQbjqBbqISnitz9xFTREBxc3S74TyaVLl9sh6LUwRYFz3y5XLBRlzL7fdwOkvTDqfrr3yW4p4VHhu08jXnlRQ8QH9+QtVd97WHB+b76KKyl5iXDXdJBmdkiK1W7uC7MEsr5MfhdRZAHJ2IuCSxcrI2I3xDpY0OABpL5F0j7jTof52tQEoDh5Egb5H/aUuAZ6p1XPKW/r5yJyaRbIqBsCQh/721gcul16MIq/ZOGhU72PDsqItrF+MqZmb5ExvIZzYKdxr5pd6AH4X/Xq7SCvFwYAOlkN2j2a4+bsq2PDkLpzkpqpLfVCh0svFk5QqawtX7LKNgWk3adepErj5Ku9hjvCCLk333UiVQWBSzMyab+SPsE1sptMDrc5hRR6evrzJQCYu3OpS06haJxK5+2uohv54gDMG7Am+KX3kztxBc0T72yO4mbW19m97qEFzlLIotsL961YP0Yy8A
 FCLnOHVa
 2YQYzO8xOrZXLD6irTsaSk5tfwH9UTQLcjsw/ynGavIr4xG6Xn1h5zN1uA34v9Fsk1g84ztyPD7ff83xNzQV7P0BrSfVyeU4od7msr4PFl8O/QWYTHPPgu4ijzHzQEnY+bYEOl1SAGaKex9zuEzYmLByNX869MhpLMvV6NgV1iR8kqYdo5Sic+aANtYQnqsiWpAmcwcmdD0JxFF6HXbYFpbhxYdIfW9NszQeS7h2moTuI6qwsZIOIeKnzgsJLcXrR45/RIzqYuGRYF0iLETfxCAUKv/lw3/u1s8YV8zDEsJBjsgj4k0IA2DehB45xobplHY/OSmYwFZUZkig15syFUf1MeY2QNrPzdYVwcmZCHhNhqMnLiSoDyVDfGa/3jGD+ykOcUUd79lz/NUTCZwKWDkRydjFN0wClUMwhSHw8dVK7aOWF7XOa15yLcS9hr1U+DjlfYQPUk9i+8DgTD4zXM6VwuwwBRGmLUPX3JrbjIOSDLdmOMqV072O9/hHWlNoMt4ZKegDRjW+6j8qp/lR6gZbVXsVnfmXUPkvEpA8e06ekqM+aplyUtegBgKA7YXbF5fE0TFHgfwLuVoxel1fd+pz80+BInHBqHUBd4bt+KVDuUAZy2QUWqKyTipeKpXjTu7Z4vBc5xpPqoYNRIYap7qvWxidCkYOaLkXxjVUa0DnFfH35gJtZ8WNWairQGo607KvV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 07:38:55PM +0100, Pedro Falcato wrote:
> So, the question is: why the heck do we need a copy? PMD is still allocated
> by the time we flush the TLB. Why doesn't a simple pud_clear() + flush_tlb +
> free over the pmd Just Work? Am I missing something? The git log isn't
> clueing me in.

I don't see anything you are missing.  The copy came with 5e0fb5df2ee8
("x86/mm: Add TLB purge to free pmd/pte page interfaces").  Its changelog
explains the flush but not the copy, and the only discussion of the copy
in that thread was Joerg objecting to the allocation and suggesting a
list_head on the stack instead:

  https://lore.kernel.org/all/20180529144438.GM18595@8bytes.org/

The existing code already frees the PMD table itself after pud_clear()
and that flush, so it already relies on the table being out of reach of
the page walker at that point.  If it is safe to free it then, it is
safe to read it then; clearing the PMD entries up front buys nothing,
because nothing is freed before the flush.  Nobody else writes to the
table either: vmap_try_huge_pud() only gets here for a range covering
the whole PUD, and ptdump is kept out by the init_mm lock the caller
holds.

> All-in-all, I would much prefer not having a copy of the PMD at all. Perhaps,
> if this isn't workable, then a linked list of PTEs would work. But I would rather
> not have tricky logic at all.

Agreed.  It also removes the allocation instead of weakening it, so no
fallback path is left behind.  I'll send a v2 that does pud_clear(), the
flush, and then frees the PTE tables straight from the detached PMD
table - the same order pmd_free_pte_page() already uses one level down.

Thanks for looking at it.

-- 
Thanks,
Mikhail

