Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB728CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3D76B0088; Thu, 14 May 2026 04:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B3B6B008A; Thu, 14 May 2026 04:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A206B0093; Thu, 14 May 2026 04:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B3A3A6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:20:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4018DC1CC1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:20:03 +0000 (UTC)
X-FDA: 84765327486.24.EC4E1F8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3610E40006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:20:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lp26RfimiH9EO0O3E3LH9GxPaxPsme0J/FuhGIJOEZs=;
	b=2fcvzp+Pnge4948VKW5SYekYlJ+uX3PjyfiugmJatHsTVaFI+eHZty1WSokz/X2ylyMnsU
	mD1N2zkFTsO0M8EOKvvryyxAejxvKUhIgqxkqPisjUsoWboewXo8yCzhAdhfPAUWJWjuBO
	v0vl6fLUG9JFFYxejeRLP2Rc7l+XiIA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746801; a=rsa-sha256;
	cv=none;
	b=uTngqwHTtg3VWBrs3c5j+LOBbipPwEEOR35Pmwb3QhkUrIKXQylGUKvYeORSq+igms61gz
	5q5CQAIbbYGvM1HwjI08KNJsRQn3vW8Fyk106v9nSVsQtybS/92qIltEPy1rfo2PwKJ9Rg
	PUyM76Rj/C7ILAqjqWq+gDSJjNWrtxY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C349966E63;
	Thu, 14 May 2026 08:19:59 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1482593A9;
	Thu, 14 May 2026 08:19:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6mLZNK6FBWrTIQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 14 May 2026 08:19:58 +0000
Date: Thu, 14 May 2026 10:19:57 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/69] mm/sparse: Move subsection_map_init() into
 sparse_init()
Message-ID: <agWFrcHSciEtp5g3@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-8-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-8-songmuchun@bytedance.com>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3610E40006
X-Stat-Signature: chxgzw46bsbg9pgx46jw4ppm9bj9xyho
X-HE-Tag: 1778746800-84592
X-HE-Meta: U2FsdGVkX19u1DTbqJXkFgcQV0dOA1hckgQXKWmyrFgER6EBjwzrVGlNyPlAYpR3cgeCsZkFlA3uJnn8Ky2jJb1yny6snrKLzSeqFckH2elrcUwh3kDVuf7q0xfM7O9AnH9zqv7hHM2hdqeCMkii79ppo5zFF8mjCD6bApmkj2gEhjlGvRDqzKfVoPqALfAysicwJS2RGNZo4jF1C7bbbHQdKVrtHhNQF5nkTWmFd/Lq77xjruWX0eOf9F0CAF7eojoRmTD2U8rYhn1G89lQRHUbjrHuunc4pbk4R2nlUuD9gEFA26vOuU4Zu9XL3ho80BH6JE7GANMbTbi1gbPUkGBvESy98P49FLXHdfCmFNKgkZok+RppWPKC4D6RF5GbiblVnVY/U33ECx0ahp/5+fO/4CvQgQE/Vywp0Ecvr016HZua4R800Z/z+x5nI2q8cHXiYncJR8ig09C3ON6a/rbqBtUvtfyluzczZHQ8/szOeATQz7OLsX5kqhnVeXwPlAgJj5O6fn5mDpIh40Gi9g4pQDFTcgThKOm7+RH5Sso8RsKkDLD2ySV/7bBSAKLsjODcSp6qlwEoXTfynKbMHQzMM6oGJPLHxtw0nR5lpsM2TqtxmIn30ssa7qqDXRLCwoJgncklZj4l/fuRQ9aVFJkn/TRBGl36Xtkugc74+cXskxUpk/GLdMAb5WVnSj1DHXd0PyvgAoy9H577xU0b9BA3lBjh5Gj0kdcuMC2z7Ig0hQKWMVvdM9KrDg6UJljg0/7REeHsAo3zmp2n8RSuHJTjh/GVxPnO0IwNDocASJHbldXbTktP8xhPSxcwSJaAsjh+cvRmbYmPqViu9s8ZGOYA2ik60B/gnoMl8CQXE5OGEmDCDwYt7uUHO9dMMd7nEZYKEj1lcjrd8gAJTGLaK63TwCdVgXEDu7BCjV68syjK5J2WayTY6qjuNkU/Pp//GzcS1SfFGpGhsOZ59FJ
 HTf1Xren
 0cRQRJHnsHxqQIJkLiqaB+pyiFpx6ZdaVZSIJYizY6MQxWTAL/K2m3qCCA4sJA6UQqN8pCBZAcR7PsnWqbT8FK9AtKar2tvnrL8R4VEoJ9G+8nUSkbCyXm6e6r/mgGqBlFoaEQ8c9AHAy5vgQ4Wm0DRbj3fP6RYuoIeKYCrN90rd9O9nvRx2PdHyn+cAP3nTVftl8Dr3PRNzmQBreqCscvG1MpRSTHxo7pI+X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:35PM +0800, Muchun Song wrote:
> subsection_map_init() is part of sparse memory initialization, but it is
> currently called from free_area_init().
> 
> Move it into sparse_init() so the sparse-specific setup stays together
> instead of being split across the generic free_area_init() path.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

