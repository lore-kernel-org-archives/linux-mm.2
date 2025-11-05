Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F883CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 14:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928EC8E000D; Wed,  5 Nov 2025 09:16:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9DF8E0003; Wed,  5 Nov 2025 09:16:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816A68E000D; Wed,  5 Nov 2025 09:16:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7412D8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:16:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2851D12C0B3
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:16:24 +0000 (UTC)
X-FDA: 84076753488.18.9819FE0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id E7B394000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:16:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZAgnZp1b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jco2c2Ts;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZAgnZp1b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jco2c2Ts;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762352182; a=rsa-sha256;
	cv=none;
	b=O8iC/50FqGuhTB1i6kU5ghGlkJC9JFVGXONfWwQJyIN/uNHDlvlHxfiNLtDfnFaX21OKLv
	VZ9oQbU8nvYvY2UoKm9SlaPHzqK3gTAC+CgUR+x4xkKSoxbOeE6rpn6ol1fzZD7q8Lmc1A
	bRkhlc31AfFM7Kf33I5d6lnBYj6SLDc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZAgnZp1b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jco2c2Ts;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZAgnZp1b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jco2c2Ts;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762352182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxijTgwj4qu/PtpAhpALHtZ5gBcQ08IIOzs5scz9wAA=;
	b=7BiIKXjrjcqgzCtT0J55JWEKA+FlQH37O3Nb0y7dXuUs+XYNciYlNMh0fegbfzYAsmg65J
	8dkWGI+J7AEy9uY6IP/bB3pwkFWGtLiiU2DaRbj8c1bx7m7sTZP3Tvi0Zos3ZNgFU4/b4x
	FxUqz0gHlteqm3AqmCs/30pd/nP+PDQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4F0D11F443;
	Wed,  5 Nov 2025 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762352180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxijTgwj4qu/PtpAhpALHtZ5gBcQ08IIOzs5scz9wAA=;
	b=ZAgnZp1beMCDQuPib8hLvJz5oCykZmr6ck6Ej/Nhdxtb+z+12++QaMDxGcyG/L3DJn2yl2
	tqa/wT8kM3RDINdiMAua9A1d74/H2TpsRoLEJ3ycvxFUEqse0CnvV9W/ewuK17MdpJOgLx
	9FZykxZ9cikAYKOERiwE9l85Hw7cOR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762352180;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxijTgwj4qu/PtpAhpALHtZ5gBcQ08IIOzs5scz9wAA=;
	b=jco2c2TsE1GvQjlBUxLKyXGvVE4Ef/jz0HVJ8IitvIor3aznOWSQ7I+FaCIdZMwU43atBk
	Spa1RB0ytSTVoPDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762352180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxijTgwj4qu/PtpAhpALHtZ5gBcQ08IIOzs5scz9wAA=;
	b=ZAgnZp1beMCDQuPib8hLvJz5oCykZmr6ck6Ej/Nhdxtb+z+12++QaMDxGcyG/L3DJn2yl2
	tqa/wT8kM3RDINdiMAua9A1d74/H2TpsRoLEJ3ycvxFUEqse0CnvV9W/ewuK17MdpJOgLx
	9FZykxZ9cikAYKOERiwE9l85Hw7cOR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762352180;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxijTgwj4qu/PtpAhpALHtZ5gBcQ08IIOzs5scz9wAA=;
	b=jco2c2TsE1GvQjlBUxLKyXGvVE4Ef/jz0HVJ8IitvIor3aznOWSQ7I+FaCIdZMwU43atBk
	Spa1RB0ytSTVoPDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CEBAF13A88;
	Wed,  5 Nov 2025 14:16:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q5rPLzNcC2kzQAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 05 Nov 2025 14:16:19 +0000
Date: Wed, 5 Nov 2025 15:16:18 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v4 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
Message-ID: <aQtcMkivdFHbW2lK@localhost.localdomain>
References: <cover.1762310125.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1762310125.git.zhuhui@kylinos.cn>
X-Rspamd-Queue-Id: E7B394000A
X-Rspamd-Server: rspam07
X-Stat-Signature: ycy3r3uabemszpj8j3cmukc1w75d9qcd
X-Rspam-User: 
X-HE-Tag: 1762352181-422100
X-HE-Meta: U2FsdGVkX181xqjW26xPTOXYCNcYg3FyBXsdMaWOXL3V/hJd4/uKZTNGVeRzoxVL+HnVJa4SpL12nIU2RtuAwgcyGT+L0g8ni6Z9OeecJPZ+ecmT+byRNHJqcPwRjEIH3NIVGHHt6CwP5OYaZ5SSGqBHGHU1Q10bM4TYQY5ony9avZvjBht4VrKr4ukOuX0NeELO/zokBzZqvkx5zGHNsGPPnSAscl7NpIX1RR4NmPgjz69+k3Po2cn4BOh2SQ2F7QY9J8G/wodLtkhO9Tbf8m+nm99QSGGTstltBgavBuQfISaVA0/hlyAFp7kZNfylwL6x3v5yhtTWuE641m1sQTfO2a458dQ3zHQd+W3GsyDcqFFtrDAUlqBF+wv6TQTXPB/3geotTp1Iku0OfOkEEZ4tpYXhFbieHtReftotbP0VKkTkQeQpukkU6g4t3xaErcVbKf+cIs//I5xRneGYVgQsk34BGccWbF33DcgrOJHeIHCu/b6Xqd8d0obaYEabRGWFEP0AmpkBAPCCW6FjPixJ4p0SYUWjBpGsmTCw2pdlmJCKMwttTUry/oLubRmireanKKucab40gXRvsAmqWIn0rfRMVZnV69vydiAdyD7GrUImRy9LsxlaKr5ZSHP6IX5UJPTeoD0u9DgE7bzu/MXKMZt3w5Z92N8VpG9ghAkkpq6ZBsYdPxwwN3xWsQZa8OBI+3sZ0kcctf9i/Z1t675ejnUjQ17Eyb36GkNSkJI/Jbq2J1riUzuJTT7lvRfmygMbdvO4YKKmnNIAxxp/wHQ25BtFr7wMFIxpSAzY2/Vclrf6CaLB8kdsPb6Gz5Mr3YEQhlSn0WZ9V1LbvaiwL4wSnWn71CGxNtLCPhLXVgvgqa9Sb+8JT4psjVPvfzoCNuChtjKkI/pmROdjtBnUIM2/2DrZyVYZB58r3rGlhzo7TVed3Yz/YvQ0Wh64ZyD9nfIjRduxYjf99V65lRU
 Rq5An2M0
 GgNMPn7K+JlTqXzppVO6O584O3AczzMHTkA1nzykhx4p80PH8BZbeJm/9trXHoH7wJ68KNhz4dy99yi7N6keIo9SkWWV46/1UBYzlRE4fa7MH/38nEJ+zW3FdzXQBpCgmtyUjRVk3hpiker0OiG28evY+GnfRb2i9zAQna8cF9R9B+R1GQD4i33zjM7swJdl35MNKE5RsbPFn0i/RPfRY8Lmp8SJBC7gwQEC0TCeV6TbSDiEDTRmH8KMPFpJJkks8kuzy54RW1f7LTg8xZBDudQ0mbGBt4ikQAcBdRMXn6p0T4NDM0RxuTFYHtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 10:42:42AM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> The hugetlb.c file has grown significantly and become difficult to
> maintain. This patch series extracts the sysfs and sysctl interface
> code into separate dedicated files to improve code organization.
> 
> The refactoring includes:
> - Patch 1: Extract sysfs interface into mm/hugetlb_sysfs.c
> - Patch 2: Extract sysctl interface into mm/hugetlb_sysctl.c
> 
> No functional changes are introduced in this series. The code is moved
> as-is, with only minor formatting adjustments for code style
> consistency. This should make future maintenance and enhancements to
> the hugetlb subsystem easier.
> 
> Testing: The patch series has been compile-tested and maintains the
> same functionality as the original code.
> 
> Changelog:
> v4:
> According to the comments of David Hildenbrand, add copyright of
> hugetlb.c to hugetlb_internal.h, hugetlb_sysctl.c and hugetlb_sysfs.c.
> v3:
> According to the comments of SeongJae Park, updated MAINTAINERS to
> add new files.
> Removed the wrong copyright in hugetlb_internal.h.
> v2:
> According to the comments of David Hildenbrand, removed the wrong
> copyright in the file headers.
> 
> Hui Zhu (2):
>   mm/hugetlb: extract sysfs into hugetlb_sysfs.c
>   mm/hugetlb: extract sysctl into hugetlb_sysctl.c

I am replying here as a response to https://lore.kernel.org/linux-mm/58d3c50f-2b4a-4053-a846-613434d5bcd9@redhat.com/T/#mf694af3f5a6ca56b76adf66352cbb88d022fe36c

So, taking a look at patch#1 as an example,which moves sysfs stuff into hugetlb_sysfs.c.
I have the feeling we are moving too much stuff. It is true that drawing a line
is not easy, but e.g: you mention

The following components are moved to mm/hugetlb_sysfs.c:
- hugetlb page demote functions (demote_free_hugetlb_folios,
  demote_pool_huge_page)

I __think__ that moving demote_store() into hugetlb_sysfs.c is fine, but although
demote_pool_huge_page and demote_free_hugetlb_folios are only called from there,
they look more than a sysfs interface and more like hugetlb generic code.

Again, drawing a like might be difficult, but I think that e.g: we should only move
sysfs entry points functions into hugetlb_sysfs.c

Does that make sense?
 

-- 
Oscar Salvador
SUSE Labs

