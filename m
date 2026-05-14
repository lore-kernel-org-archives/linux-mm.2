Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E68CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844A66B0088; Thu, 14 May 2026 05:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F49C6B008A; Thu, 14 May 2026 05:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3246B008C; Thu, 14 May 2026 05:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9846B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:10:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 274171C031B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:10:53 +0000 (UTC)
X-FDA: 84765455586.08.3415A2A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id E42111C0003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:10:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n7nqNzMi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sC09+8+7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n7nqNzMi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sC09+8+7;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778749851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N02BDNbIIy3mrxP163anPLxP+RFbS21R7W+6zJLh/9M=;
	b=IhJqtzcpPKuqjPqaVuIKlj/vMpmvl3xXtlYw7zrau0hVMRFRNStBaHweIDI8DrV2fI8kOv
	8YLxcSuy1NMNja+VcEEMnZGqS9Qc4rICwf0PwAfnvYbrdzCz3qAXvb9bBiuCKS0YXFc8/k
	xJmq9evUJqcKTZ12i/I9OfH57xj2zGU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n7nqNzMi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sC09+8+7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n7nqNzMi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sC09+8+7;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778749851; a=rsa-sha256;
	cv=none;
	b=MJ7ZSTFTsKldB+J8AaoQ9kN4SrEcso5r3u9OvUpKYoSByYHkYywDvv5Ecu+H6+uTOeL6/W
	TavnT6RTLwZztiyxExTpRlOFnRAf00vlMG2SPbz08NStZClXF/QLEynZhTMslwfdtCfZtC
	eCy1VcMKkG2Hscx92aFx3fAibjWPaoc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2057166D49;
	Thu, 14 May 2026 09:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778749849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N02BDNbIIy3mrxP163anPLxP+RFbS21R7W+6zJLh/9M=;
	b=n7nqNzMiQjIT87bTfbEiS50xRXvGbJ1xgcV38pSySqxfhjdoWUS6gdghzpINMGhi9Nw7ac
	rjRmQPtZNWUx/EzA0lhndCHvfPt7RRc5uGt6IKy3dsRk60KkTlNS+/xZNcslr9oo8NGOhz
	f57dBjvu1QgRB6ApXh7jn0g6q+hGHQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778749849;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N02BDNbIIy3mrxP163anPLxP+RFbS21R7W+6zJLh/9M=;
	b=sC09+8+78AN2yGLSHhLbQYS+cldn424UoaMr0t9cHTOvoN2FDU4GzTjkJ+wXWS1TusJoE7
	qPX5ejOrBpMXDNBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778749849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N02BDNbIIy3mrxP163anPLxP+RFbS21R7W+6zJLh/9M=;
	b=n7nqNzMiQjIT87bTfbEiS50xRXvGbJ1xgcV38pSySqxfhjdoWUS6gdghzpINMGhi9Nw7ac
	rjRmQPtZNWUx/EzA0lhndCHvfPt7RRc5uGt6IKy3dsRk60KkTlNS+/xZNcslr9oo8NGOhz
	f57dBjvu1QgRB6ApXh7jn0g6q+hGHQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778749849;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N02BDNbIIy3mrxP163anPLxP+RFbS21R7W+6zJLh/9M=;
	b=sC09+8+78AN2yGLSHhLbQYS+cldn424UoaMr0t9cHTOvoN2FDU4GzTjkJ+wXWS1TusJoE7
	qPX5ejOrBpMXDNBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A908D593A9;
	Thu, 14 May 2026 09:10:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cO54JpiRBWr2cwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 14 May 2026 09:10:48 +0000
Date: Thu, 14 May 2026 11:10:43 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm/memory-failure: Use zone_pcp_disable() for poison
 handling
Message-ID: <agWRk-x_XrzTC3qS@localhost.localdomain>
References: <20260514085754.84097-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514085754.84097-1-kaitao.cheng@linux.dev>
X-Stat-Signature: k9fasks8qud5gxx7o7gh7gf3h6ynesbe
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E42111C0003
X-Rspam-User: 
X-HE-Tag: 1778749850-186685
X-HE-Meta: U2FsdGVkX19nrB7ZyvZx4yalE4TxO1pvryGuFMTK8hIC502RhBR1SUpktsN+YNxgjs4N7hIppV7TAw5tGT9FDSLFw3+v59YOO+m215sGDBTEWYhit5vJNYqtmNTko4i7OqWFRd43s1tO6UAZc4TacIdOrOmYLmgtWBW6Rp8+T7VwBB9a47un0V8b5DfABAZxrTxwyUdWyp6IQaptd81WD9rSVKZpBe7HfxwxSxwWZMl5UlApAQvQFlJKAzIYURd9xFrLidU6lPhPsO0+Px+n04/1ud4941MEcRBj1/m8oKXVa2rJzDdcwI1hJiBZKXcljMmbxwrJa7O+E6vahbm/bJ8K29s1X+gj2QoLO4fR4xcf9OKHbvwSKh/ZynakySAFj7qaDSV5LNHx4BYzjdXorQnwp9odk2JemAjtBPR1uvZPBOkFUBUildE/+vkrqaWIehyOJ9cPXNvvmQK6BL9fH6DB22c5i7ChU5DEvbKmacUFqOpaVlzptMfH+QCnqgUfnZee4g26TWuE5TR5mubimDY7i8OtLzSht31OlOkW4kuiRbK++v4QRMtRWYcBLj9zSqrbBQsnLjXRkRgc3tf8OzO+AmyUDO7aUY6bm1h4Xgu5f0ef0V2HpaxCbVX/JK4BXZyWjt2n6kxyvOlbIO+zlyxiTK59h3s2bNu7T15XpIr0+j9kAhyBjYPzT0T+XVH+YpB/STUTq7aFbQyLSx4GcL37LNWvBYhNTWuN/xODlTdk27Gw02u5h4gPkT+FTrWABFnTHwnw82FvF1tyfnXZ2frlXCkAr7ou66yqDBNTddOrmFFIwP7WYXtPUFAZzf8lyuwE89Rj+Mg/pnNtB1oVs4fi4RWxFz1X5KCYqJTHyIVVoG2EERjZbpa5TDOWdZ8b7wM0DHfg5kj1FqF+nZ0zrFnLOM7A5umgpGQQQ7SZ/PuVafE4cWZr90AMp1vBbmZWDeo8UBcuC5QYrrsxxYU
 xqWzEhQi
 XQ/3wkhEL/TvPIWDU9JyIl2dYocie5emTqkJIg+7LhRmW+xEMvXeFH9kpRlNWOSFigUDloB2HfFH5IszzSrRUvDGfcX0CzZUx+vHiUYNR+WIQ+WhpgHeR2UQiHF7IzT6cXOwxNS/GXgHAEFOGzXNG4S8P2kwZKZ/prPRY7ByGlgpSDALYbQtSYFjjkLGeyYkTWjCuBScaijT0vbjlDrB1CL2Op3RaXzTikgZeowUmG3Edvqms+s5nCHqrYKEdzICbV39rBYR+b6ZKZsaQrnSQZ1PmiVcE5JADgqv1lym7Dzwg18wMm9RV7VIM0sP4tPjxUWtOl1otxoAbLOsUFxET9icsJrkbWmFFiPW5LXWDZgFUS56An5NBes+LsoPY8fYO7s8C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 04:57:54PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> __page_handle_poison() used drain_all_pages() instead of
> zone_pcp_disable() because dissolve_free_hugetlb_folio() could restore
> HVO vmemmap pages and decrement hugetlb_optimize_vmemmap_key. That static
> key update took cpu_hotplug_lock through static_key_slow_dec(), while
> zone_pcp_disable() holds pcp_batch_high_lock. CPU hotplug takes the locks
> in the opposite order through page_alloc_cpu_online/dead(), so the
> combination could deadlock.
> 
> That dependency no longer exists. Commit da3e2d1ca43d ("mm/hugetlb:
> remove hugetlb_optimize_vmemmap_key static key") removed the HVO static
> key and the static_branch_dec() from hugetlb_vmemmap_restore_folio().
> The dissolve_free_hugetlb_folio() path no longer reaches
> static_key_slow_dec().
> 
> Use zone_pcp_disable() again while dissolving the hugetlb folio and
> taking the target page off the buddy allocator. This prevents the drained
> PCP lists from being refilled before take_page_off_buddy() runs, making
> the page isolation deterministic.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

