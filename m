Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2BACA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D78A6B000E; Mon,  8 Sep 2025 05:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AEF96B0022; Mon,  8 Sep 2025 05:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4FD8E0001; Mon,  8 Sep 2025 05:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 584516B000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:30:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED0EB1A0A64
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:29:59 +0000 (UTC)
X-FDA: 83865561318.08.13B839E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id C752D40003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:29:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=byocpD6R;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="r5YFb/1O";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=byocpD6R;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="r5YFb/1O";
	spf=pass (imf07.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757323798; a=rsa-sha256;
	cv=none;
	b=LbD6O860sp1HuLfXX3NMiov196CzWsToIqbXHt0adXfqa4GIwXJ3eCERgivPa77yVX4Ac3
	VkSsuZcMoV9z2szPOXoqZ1iuMdrseEnY/tJi0K5b0kQKp1owKh5DyBFzJqMnRIFZDU9GYx
	QqTCjOexWtrOMBT46N19n6TQtDwwSJ0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=byocpD6R;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="r5YFb/1O";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=byocpD6R;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="r5YFb/1O";
	spf=pass (imf07.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757323798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9BLNtLX6VOhE4bO6+Pd6K/PJiK6GDJQ9GC/Q7kQzYA=;
	b=g4b/rPX3lfViW7k2ZCdIM5GFns2UweSSBsxHqIdkKhO3X+n7diPvcu22NqWnbAU5Z0t1J8
	8KpFNpLPpLG8Y/cGZTe2uve1tIIQKSEsokH1FXI6MWRvdiBkJDztsLn6ebUmE4Zl7/WLcq
	Lx5G1/nsJi+bPRoaYNDv414gMYLwTOk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2EB3C207B6;
	Mon,  8 Sep 2025 09:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757323796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9BLNtLX6VOhE4bO6+Pd6K/PJiK6GDJQ9GC/Q7kQzYA=;
	b=byocpD6RtubeLR2cWUbgXumnR/YmiHnLctAaoVPhf5hB7DOVHZtPCziildlD2ChatoE0as
	LvsrJGlvAi7VwKpe1Rr/xPdbaV6cQsEhqDJ+qxW4E2AHeN4/kofJlHe4+sWzCnH9RHJcNw
	jQe5RVxk3RBsdjC69DGo22gisAlPrrg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757323796;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9BLNtLX6VOhE4bO6+Pd6K/PJiK6GDJQ9GC/Q7kQzYA=;
	b=r5YFb/1OOABfuK3zpq2yHPBKVt/9+CWJCcs9v1P/UOtZKfD2SQ9586SFziqZU60EnXSwpZ
	OXSkxa3JpF8MvHAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757323796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9BLNtLX6VOhE4bO6+Pd6K/PJiK6GDJQ9GC/Q7kQzYA=;
	b=byocpD6RtubeLR2cWUbgXumnR/YmiHnLctAaoVPhf5hB7DOVHZtPCziildlD2ChatoE0as
	LvsrJGlvAi7VwKpe1Rr/xPdbaV6cQsEhqDJ+qxW4E2AHeN4/kofJlHe4+sWzCnH9RHJcNw
	jQe5RVxk3RBsdjC69DGo22gisAlPrrg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757323796;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9BLNtLX6VOhE4bO6+Pd6K/PJiK6GDJQ9GC/Q7kQzYA=;
	b=r5YFb/1OOABfuK3zpq2yHPBKVt/9+CWJCcs9v1P/UOtZKfD2SQ9586SFziqZU60EnXSwpZ
	OXSkxa3JpF8MvHAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 83B5913869;
	Mon,  8 Sep 2025 09:29:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CjJUHROivmiHaQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 08 Sep 2025 09:29:55 +0000
Date: Mon, 8 Sep 2025 11:29:53 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/9] mm: hugetlb: directly pass order when allocate a
 hugetlb folio
Message-ID: <aL6iEeAn_jxIqhKP@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-4-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-4-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C752D40003
X-Stat-Signature: so9gukszmzf5biuabcj1rwse4gqpfbe4
X-Rspam-User: 
X-HE-Tag: 1757323797-303157
X-HE-Meta: U2FsdGVkX18AdiexS23l6aV3CNcI+QQaYWMUBrZ9tQWZbu/B9jPwYSyeELY89lfbl10P+O9H8wN+7EsUAzwx5SF5a7Kf+t5xjmiIj4rilER1VbawGDu7Ie6gGM2rjNb2m/hugwFLEjU19Ig8yz8e98iFPdCr0403orlnc4WUXeRhfUqeyCc2SNIJwWjsmCO5YjuC5zaVvPagEDoSXEA1nGGlhT95FfjPyAHOI8xt+TYE8X4FlsshkWV3w/h7oLHvTnnTRWwBbV8OPrcpTq4BwigBQAoArjRKphSLV26LyXYPv5P9q5+X7yJP7sMgAEeQmB7R1VXtFmNeU2l2fdKYIWlVmeVBdajEMJyYDHJNbs/TR+1a0q2cE17+u1v4zNRhQ6R66wi5NONSMT1mnh8FCEtP2wgju4NECHotesJGerO/YDrCroErd4TKQAU6szsSHEJxqwE5oAj2vXE7c7aLbpDT+7StR19z+Z+sbUUxBvnb6jT2jsaA6nMkIMm63lVyblqY7E2rLml+mAcAdmHs8mxewpHYB2odHraFBl/08xmZgCkU4A/rh8vLPX4pOAnjxATNzJvpZc7ixWHf80ZETq9qqa5KhbZroSVc/pjcQnEBJ0vMgfrmKEK4z6xzQWMeLaFC2XB7iLM1REoeHPaYECTbOnA++MBNa0enYHmFEnOgId6VXp9PFmmFSmczVUh2pTId0vO7QZO/STENfgwUJxaozYWpaya6m15db907C1AT3+ljwJYrWATLlg+4K2Jikpd6BCxcSJHtABSmTlt6DqpFPzmYg5/l2iRVOZW/ZIoBalQQLpERoOJE9FRmPXTJn7HtwEGgEjY1DJp4USGSCAEspptv6E/lA5p3f0vUQpEypI9FV81ahhsEd7vrBwl42QMBfceQpMasshITNLx1uDvEB7dbYbCKBrhJXkO+sepVZVdAE+un/ywSAEHQbJxat8e8xsFmcAHAcA27Fro
 xQeBM+Pp
 TXAC6J5i4J5pZZC3cd11m2htKjCZf/jXRmehsMwy/XG64leZaadbdA74a/LjZFcSF18LZzwA2JlbbEMt3tc+Ru/gwKpgAnSPwdjZ0qt0c6vsrGEVJLKdGLYPq//KQoJelIT1D519/r+i6OiUk0Y4SYq0rMP3mLeUbFQ5O81UOfCnWmOiO7Y34C+xXqSjQX/eGCNf6lbxMg5n7JoH1FrIa7c2OJ/lpuUkfvqDnefxkCXsygVb2XZW+L+4o5L6Q+aoyWRuvIB+r5FkFL1k9IGeEYCBsDlJVRYmbVY1Q+bzYm2pTFkKqSIb8J3dlPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:14PM +0800, Kefeng Wang wrote:
> Use order instead of struct hstate to remove huge_page_order() call
> from all hugetlb folio allocation.
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

