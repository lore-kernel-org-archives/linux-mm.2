Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5FA2CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BE9D6B0092; Tue, 12 May 2026 22:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294D86B0093; Tue, 12 May 2026 22:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB0A6B0095; Tue, 12 May 2026 22:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1DC6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:15:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A818F1C1724
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:15:09 +0000 (UTC)
X-FDA: 84760779138.25.9D378DD
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id EFDE44000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:15:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=htK+tal5;
	spf=pass (imf07.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778638508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=tlu7E9a42EdO8Zb4bF9ZEOeSFpy0O6JOTEoFq9gBpMQ=;
	b=MJ749v+BzrRZnNHoEE2bGdtyezKBwv1u7cWxgTE567QMYCWySwPQg1UboLnCeJ3r9iNg4B
	JODLV5pkQpHbPBDhzfa9PPrZbVkXueO8OcmX832VjfuOin3Bw9rZO1S4USxZQ4V357Rg+6
	gk2hdTu3Xz4343l3q7z4fm3IRxPqHCI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=htK+tal5;
	spf=pass (imf07.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778638508; a=rsa-sha256;
	cv=none;
	b=qjU2/Mw5C5vUmFawSmdDumQo4c9FQAk45wSsPphdAaqDJsU6EJ3MQM3xXzHrJ0Oz5aXmIX
	QHuoovofiNmN9D/x9GQMxhzePOJyrS/1ataFUo0l69U7otkMk2rVWJTCVsQV2QnDd9g4cI
	ysh4GHL394t52wDQPyf4Zl7BG4QOwzc=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c80170db7d6so2380869a12.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 19:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778638507; x=1779243307; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tlu7E9a42EdO8Zb4bF9ZEOeSFpy0O6JOTEoFq9gBpMQ=;
        b=htK+tal5kc4Wr6nKXx48groxlGhhp9AsNbzyYLfuUqMIuFFyVNZe1PsH1ZXz6NQ7X3
         +IKySn3ZSDQNogCNDa1Ph4h9YZueh/WpZ/pjwK8e9QZAMhOcTOe7X7k1+V0IKBhyOV5W
         VLjs3otI5g4h1OHXBRnq9u/eOqUyPwMdojOOy6JS0LFF/GvSMCLx8QR+wMYjulaaLyGu
         94jVsMfWAFYz1loy2TTcz6b4Ys/HeAoDirmbxAi5XCHSkbTQKscqL79hdyUCk+HMhotS
         LvgoGaYEBako1eLpQuIowReXtpahqH0H4hd/xhd/Ph2eDIhFwTCHYYI9zyzGeww3VWEM
         t8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778638507; x=1779243307;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlu7E9a42EdO8Zb4bF9ZEOeSFpy0O6JOTEoFq9gBpMQ=;
        b=JcN/SY2uAxjkyHWr/V8kQLLP5l66JKlH04H7o4kwZuNRdYQrIMh+OjY5rCvS/i27yS
         2jNoLbnZBaISteMiZoKZoLk5jRsYEVfIti7HG6I23/WD+3m33mkj2UDOoRsa7/GA+mY9
         6XxZdddD4dIsAvPHiAxeqXkRnlu1pcohiqrzw3UapQIsGb9MKujqz8N83cC4q46itze8
         tg+5LqvZcsiLkZjcQuXAgS1JmIdITVLXdB0mNUpDfMtisR1uCU5w4wPEcb/ftORYHRN3
         TTq5A1ebMcwL/PJbR7X104VlLV+7Fts6vdVwJ8i9rp5jOsle/FGjE2f8V7DT5/zDEn1/
         w8NA==
X-Forwarded-Encrypted: i=1; AFNElJ+3VqnGlV+ZiwxCOTZeOjtRaPQGhE0LSOh2kTq94a6voMDdr4usF+xO8j5sr41WtYiBHbvzRCH06w==@kvack.org
X-Gm-Message-State: AOJu0Yw3OJiejwNYmlIl0HrtpVYH/weslg7QBhERxM6Dvt4Q9pxb9IWr
	e1U6T5Keqq32M9qkVxNHIjF1GeyUKLqRqg6WWLNvoJ0Kyjj9Hvr/7XLz
X-Gm-Gg: Acq92OGbYsropCEgtOq0/EYbcy1qL3qXutXuIyeD7SYJ7k7mZGj1Is6w6w1c1zfOXtJ
	vymO/bLWA39Sa8FaBkcPQ3Yotki4WRCwZap70xlrp8avo+jUy7Ugul4iw969GTX3hj8ymrYUrOB
	vfAHR16sBxGZmpTAHiru0pEJ3ornJp7augC+j+/feeRzObcpo4iCTUxMAUTrEGj+rQ4NjgZJfIW
	YxC8OzYyWrUENRgM01IW2UTYyEHtloAHdYGrm6CQY/1eKB7PJJ6JbAkPxjnYGWGZw9FLLRLGoS/
	M1uBF4uMfg+j2KFJSmOoxeSmiX7LGNuMqM5LSitGrFhFKhFBlJ5TAclmh3T4afGgG/jmALeztr5
	67g2cimovmbRpAWeaaFOegTzL8bhCEGF2lgBCVTDrgEJ6ZpdoRVkPjBUfYAzpJ1o6ZUS/LIXZQD
	axuVq5Z0LX+YVyM76Kgb52Tw==
X-Received: by 2002:a05:6a20:7346:b0:39e:f6bb:48f9 with SMTP id adf61e73a8af0-3af80a70ee5mr1215571637.15.1778638506562;
        Tue, 12 May 2026 19:15:06 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826767bf53sm13040829a12.6.2026.05.12.19.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 19:15:05 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v7 2/3] mm: track DONTCACHE dirty pages per bdi_writeback
In-Reply-To: <20260511-dontcache-v7-2-2848ddce8090@kernel.org>
Date: Wed, 13 May 2026 07:37:06 +0530
Message-ID: <zf24qcz9.ritesh.list@gmail.com>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org> <20260511-dontcache-v7-2-2848ddce8090@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: EFDE44000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 1obojzs9ax1hucpzsuuogc99e1yo3afy
X-HE-Tag: 1778638507-720118
X-HE-Meta: U2FsdGVkX1/z3+gf4uGg3qLzlzzNF+BapNgSvsYvfpQ2l/rvT/ZKizGtMSIXbkJcG7d2QR3WC7v3GYY/Rd/LCDrItOzFs3RRcbxu2fm6hFuzkD6IteVtVk7KmoYUKG+Cmw6BwJ1MCH3/eXdB1mFfbouO7b9Iwj+AA7x4APzZadY+Rk+1p+PUNn+WVkUtSihVzZW3RHfr/HrpOP3robqg/C7xqAnAOCGiR8J58eia7V/BzDl2JU0/noPdvCBg5fVkN/Vb5zLRBSA9lwTTue/KjqO3dPwjp7M9aLGK8OYH2SKD9RQWYJISJiRQUssJeEurRWwUoQPLRBSSM4r+9cSaOIaFI6gYZdUB9eR0g3odQUI70gUGlMqW++LPKexnuzzD3f2VIgq6dN5WhHdIwYENTwhq4xspGCLLnUiIDGTcMNgb9FyGBb21mlqq5ZqRQbfQFoGLWFC/FKz6GUDx24BPRU9gEo8VqhoSQt1Dy7Qh4YjwWoHmKFKI8K+Xrs/GA3jT04dbkZbGzEPdR2At4dvaW+j5dgTIshMg6fGU6al2s7+93Ct+DYYFkm9omO7pNjxjVFaU6D/sBIq4J2pdtzeos3RGlx7FFn+013KFrwzenZC3eZePkevbqkKJbuuoqsmLMQcuKAcIjS/4k8V+qlQMbAzhULhmJupsBg1mx02LHdIEhmBkshRBvflzMKJ2pod7l456D2qmcJ0hwBygEtJHaS0yY4vDxL34CY4Yf5lWHpWkAf7dO2pjlSG1wFUryL4CnfNCF5vk/eGYHmuBDkoUxUrFg4VYCtJvubq3KMKTr0Pc3STEqoEx/CLZvvtbfvpl3wFdNqSQTuwda6GFAH7R6fTWImcz/W1tfc179FPyk5oBuOWE8ohxuxfzymi/JYVPNsQrY3/n0DSu14O0XT/Dr/Ue2YVkDZQqRvd5O7oAZdGKPQFX5AYgcOKuro3yEon8ReBr1BA93T3Rhl4EJX2
 b+5YdEqm
 QyjJS0/U9gu+hOLXc1s/kySQBQq7TqeuiFF3EI4coQwpn4KoPQg0VuY6kExN6ib40QGs9QAehc9lVLxPYKqme2gDQ9QjquZYeQGl+bibBqDrrQDCHJbiDtqnJLvgGoNqkQCJ2JxEIqJzjwGUGMmpZpCWwQmULA5045P3BFsvL4HYlXBLlpx2K2BZWLIUE4WKobLZDe1zpSMLiIvecANGrbP7E0k5ZAHE6DI3pogYEEuyAbnwK/WXoM1XGhPCMteVVPonOqoPFDJ5H6kLW4kzlbL51JyzIlGraGe2UopecYShKcJ98ex/TMml5zV1EXibXluYj+jkb3XH8ldPJNOoIMqtUppl0DWW4kkob+l3Ev3ftAXKGMkRL2Mp6J5wV+35V+/kF/tAPZ/j9lQGcOMDkBpxc8cCPLWLaHQOGZz+xs2ANu39lSX/LCrR6EPdHzb4JFwQ3rsos7Bkze+y/scI91IGzf7IqIaLXHEJuyjqKli/+y0+QbZM0DeQEluv6d+g9dKgl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
> pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
> writes).
>
> Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
> when the folio has the dropbehind flag set, and decrement it in
> folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
> when a non-DONTCACHE lookup atomically clears the dropbehind flag on a
> dirty folio in __filemap_get_folio_mpol(), using folio_test_clear_dropbehind()
> to prevent concurrent lookups from double-decrementing the counter, and
> guarding the decrement with mapping_can_writeback() to match the increment
> path.
>
> Transfer the counter alongside WB_RECLAIMABLE in inode_do_switch_wbs() so
> that the stat is properly migrated when an inode switches cgroup writeback
> domains.
>
> The counter will be used by the writeback flusher to determine how many
> pages to write back when expediting writeback for IOCB_DONTCACHE writes,
> without flushing the entire BDI's dirty pages.
>

Using wb_stat infra was a clever thing to do for counting the number of
dontcache folios.
I see that we don't collect DONTCACHE stats in collect_wb_stats(), which
I guess, is mainly for debug purposes only. Either ways I am not sure
how useful that might be, since it only shows the approximate stats
since it doesn't do wb_stat_sum() for most of the other stats too.
If for any reason we need that in future, that could go in a separate patch.

For this patch - LGTM. Please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


