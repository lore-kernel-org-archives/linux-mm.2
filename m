Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B82C1C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3396B04AD; Thu, 13 Aug 2026 07:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA49C6B04AE; Thu, 13 Aug 2026 07:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9ED6B04AF; Thu, 13 Aug 2026 07:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF1E6B04AD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:07:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39202A2CA6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:07:01 +0000 (UTC)
X-FDA: 85095969042.20.36FE554
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 253F9C0005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:06:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cDR4STOh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nqXtYE6Q;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Lisi1/bG";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mKtbXSv2;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786619219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ldjfp1RMyqVRaRD31x2B8WF9el1NG4ea1OnLuwDBLx8=;
	b=shJF9ciM3X0+yzFM1Iy0t4pJmRSuqYMTZk+8xS6gueSO6mhTLTxYmsrkT4wMYyI08+lgzM
	xwVT+OA1kvu5vcRjMsS5c+KfnPNWRXsLcwlK9bKNRma6A7dUnSu0QHx4zq+UIXCa9FBP+V
	p+41NL2CJcc1pOL8+sIh6cUD7aoVLic=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cDR4STOh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nqXtYE6Q;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Lisi1/bG";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mKtbXSv2;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786619219;
	b=a0zXFHJjvMe8cvQNIn5DooIVPY+/AUyBPRNrK1xJI28qwSqD8IxH6AbETI8XApJIp4R5Cr
	Y3isKONeZNbpogGj7tE32aDkntOVte3/2UXoiZcfmV5sylyQzRFATQwvVYt5epJCGHhmzG
	fKtr79u41edqDrEoY3ecUwngzfpb9CY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BDBFA82849;
	Thu, 13 Aug 2026 11:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ldjfp1RMyqVRaRD31x2B8WF9el1NG4ea1OnLuwDBLx8=;
	b=cDR4STOhhN0AHiUM2OTboi9tHG+DW7YM0pDY8xIJoDxfdFWIy4BPYAabpp68iYWfI/9ICn
	rdtH8F+b786wAO/A/W/2Xc1S32pAwj9FCz8D6/Zvj9RNci4g60wWtMeBJ7OTR6Wtc64Gk0
	XJ2MqMRWtIkKpntXOqdhA5LFskV9x4M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619213;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ldjfp1RMyqVRaRD31x2B8WF9el1NG4ea1OnLuwDBLx8=;
	b=nqXtYE6Q/TWKJXm1iNasWV8iMehZ8VYvEXJxrwRn7T2ynD5lGK3DFO+xpwNo7GKZu47640
	gJEI6mJnulee2+Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ldjfp1RMyqVRaRD31x2B8WF9el1NG4ea1OnLuwDBLx8=;
	b=Lisi1/bGCaX4g5r4dLOA1F0R+c61DVS7IE+1P92JLSgWQ5DZ5xzLZ74rTH6Th5GYFqLSKj
	C6xKUFwwaEhpCeq5DUiZW0sMPGufdn3ZnUdVlHhM4BQycGprgMb2155wUhbWFtgaJI8sl3
	ypCGtX8zm8RjHd6MdSshrFTJzDt64qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619209;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ldjfp1RMyqVRaRD31x2B8WF9el1NG4ea1OnLuwDBLx8=;
	b=mKtbXSv2IEh+HOEYN+JhmPQzfQ/09RSHQYl2ySekwiSdekV1GcstbLQWqk4/5+SvFJf3er
	PrEKBUZRygfNX8DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD1A577DAD;
	Thu, 13 Aug 2026 11:06:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /77MLkilfWpPBAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 13 Aug 2026 11:06:48 +0000
Date: Thu, 13 Aug 2026 12:06:47 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>, 
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v9 13/15] hugetlb: Set mapping folio order
Message-ID: <an2lN6mOrZpahYhG@pedro-suse.lan>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-14-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805210557.1118966-14-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 253F9C0005
X-Stat-Signature: ao9uud9rsntxm6b9wzwwxyzkbkewyz43
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786619218-893745
X-HE-Meta: U2FsdGVkX1+f0CmcwAZeNPmlkLFshh3D4Q2G1ALz2tlM98ihxAPC040OPEV/pCpB/vid+1t4UXJjkw0yI3axLJcAkZlS0d0K1IZA3zAOAnK3MLqA+OcFh3ZMgPENhtmf0VPC4HZURfawz9CYB/y2ZZnJnfq1EzO2FtmK9f2WPOf4PDgVE4HDt7FgLYJSUJZN3RIAd9ngEqXgJM0DXuV/DuP/1D5mS5Bx+R1i8DpXxzsq2iky3LdV8Pw1vW7s1fr4zDnsleSTibgp1gWheeE+3xJBsNFoWeAsolRNWCEuxDxU5JZe/aMaZSU1Pf2ywGcZvGhkd/DQMpOy84UNOMOFuBMnRiHmDQ7qnreft2ZsdmeMth+J5BdUlu2oxSQSOBc8QmfiSp2RzODJjmWMsb97TSkluSqBO8qQHc9w4PRdxi6KXx0bhV3/NRzMPARzpNlWqA3FP0otfSRfSz5pPIsyL9OrMyVh/kYknrOUDmAMWz8KoJK6P47I9St5IIlh5F2RldI2xTr+8/EayxNtOrBgAUYLolc2A7wnm1TJgtGV+CiyKeMlKnMEqdIiOgLv0Ggp4tT/whkXkZG1EX5N9TtK+KwipQT/WPplaUvdFCJq9JqVoXUUXcZ3FrWH8pJd/nqI+qS6ljHngztKuTALdHFClAHyJ/4qMX89dKiSsu6iXodrpvJ8UVA6NehPiIgAAS+Gk/4DEx9SVEm0YvNC++npJPW04vQfBI47mFhmsuw4RMK+YOSWvdZGu6N8Z7s+ngJecWUPFIY3v13sEsKpoYoZ0fOKRgJ6Kt2eKwxmP24XC1WDy/8pczpwq5kUU49CGyLKE7TyfyDrsd/GTOHbJSIx5hXG6LDvNCAk1n7VYkAgUSMyQkWsa9UuuREZtId7YJXaguyB8ZDGtLhzRuLzYHRNvFM4msjN8q1EsBRXatYw0HBUjX+v4G0nz7OVXtDARmmu8lkS+FY5480F0l2KjeI
 Pf06hVwm
 4FGgEqrz+xhZFn27AiEz3hDzulD9jTZS397UZtkiXMFhBjveQwJpxslqKb+JI9vp2cMaO6Y5OH/4WGt+1GWgd0kCFyHfPbhTLAnkzVzZIpOJnHelc5nWxgQuv8FgxlELiKXwM6zLsCPTluq6P6cBsXx0KsHVktmXQ5fAJmx1BozfRVTtld24hS4A/yEG75BkEkL7h2AasDUmOiy9qKOez8WYmmN8i97j9RgrsPgU1W+NWXx3B9rm69CQZnsUV57IrmGJhplRJhEyO9TyIOEMF1M/TnBTKAP6Z983C4ZZd2rm4INy64DjPO0uTqiTOET18ve7O1IbLyDii01iykiK52D7vw5r5CjIbo4KOZIIGNmeSG7PWn1J55qpcD1k6N8CIn3coc3ISa/YomPj9jtkZQSnlbP3ko7mk66KMGuDLzc34l2zhDQ0F42pheIXpfsdYgNUpzGqaQm9Mriw3uXxjtScOY0lqFeGH3U+m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:05:53PM +0100, Matthew Wilcox (Oracle) wrote:
> hugetlbfs currently uses an fs-specific way to determine the size of
> the folios in its page cache.  Thanks to the support of block sizes
> larger than page sizes, we now support this as part of the page cache.
> It's somewhat more efficient as we have this information directly in the
> mapping rather than going from inode->i_sb->s_fs_info.  We can convert
> the rest of the hugetlb code to use this at our leisure; this is needed
> now so that we can use filemap_get_pages() unmodified.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

