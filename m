Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 407BCCCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9118E0011; Wed,  5 Nov 2025 03:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1358E0002; Wed,  5 Nov 2025 03:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6CC8E0011; Wed,  5 Nov 2025 03:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0A78E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:47:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1077414024A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:47:03 +0000 (UTC)
X-FDA: 84075923526.20.1E8ACA8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id B398220005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:47:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kk4KHprh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IXKiak5O;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=euIPH0f5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZKyAO6Xj;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762332421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9dQBE0EcfsLO//r4BKJJsXu3FlACWq2NYnD5EknmFU=;
	b=zrIOVBO0i5VjsAUoGUY/tsjoUkFLSaMgDuSF0jRyNxVycKEa3Q6ft/vlYa9Bv9PvIwXMF9
	P03zKCjNXFr4wtnTH1EqW8DdCLkfpxJYmzak3QMQ3p3Kqz2NVZ4bHMc2J15iJ8HL9qoACR
	2X0d84x7C3oVqldDplcSBf5YXGMpGTk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kk4KHprh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IXKiak5O;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=euIPH0f5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZKyAO6Xj;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762332421; a=rsa-sha256;
	cv=none;
	b=rBI6adw6T09Xg2SAf1MKVendIip1PXiATrn68XwOiMJUxEpnzwxb/rwfGHXRwXlMD2vhc9
	qYZqb4GFsgqqnJ+btf10UgY0m3oaZ7hws4ST6b5M45wv25q/6T/rwBVtzbYs6nPhWsC+3/
	AkAJMHOlpwP5y7T0bfV5i0azTcS2WeU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E41F02116C;
	Wed,  5 Nov 2025 08:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762332419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9dQBE0EcfsLO//r4BKJJsXu3FlACWq2NYnD5EknmFU=;
	b=kk4KHprhck1/zn51q1Nx39TLpbhJSAmN+LxDrTkrVM/YwuYV7vxJbsCOFL7XdJ5jOtc99p
	WZ9LMSS724hC5llKisRsii/KGGCc5qCmdMyCjwqBPQvGO5tTosXjUbhWI+ydof9DC8ew4j
	nhBK/K9s5K53zio57QVlCvCZAoAUmjU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762332419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9dQBE0EcfsLO//r4BKJJsXu3FlACWq2NYnD5EknmFU=;
	b=IXKiak5O3Z3v/zAQt/Ra/LWCdd7r3JgMRSLz2E4ZdpAozipAnmMMp5cwapcv5sug/zMN/o
	gtENhGWL82Z7C6AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762332418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9dQBE0EcfsLO//r4BKJJsXu3FlACWq2NYnD5EknmFU=;
	b=euIPH0f53TpCLjfWxQbTZ/9gh2D4vculj7q1qw2tHzrxTBBed+t8pN2cAhsW3EpPdMqccj
	DJfW2Y+7n2fA7Ylg76Dz6jJ1sunlM3DO0OqAoZQgAx0evy2aFpYX5a51/rd0XRM4joaXL5
	s2G/SV2bQzevcRMgity8RIylPTrr1Ks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762332418;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9dQBE0EcfsLO//r4BKJJsXu3FlACWq2NYnD5EknmFU=;
	b=ZKyAO6XjgDyXJgXv+ssrCj5nybblEulOC2A6DXH93qCa2uP1bmb+rvTHZFo8yXEd4V848d
	bhVnkz+yWuA1xDDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6BD5132DD;
	Wed,  5 Nov 2025 08:46:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UlxlNAIPC2lAcQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 08:46:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8E5FCA28C2; Wed,  5 Nov 2025 09:46:58 +0100 (CET)
Date: Wed, 5 Nov 2025 09:46:58 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 11/25] ext4: support large block size in
 ext4_mb_load_buddy_gfp()
Message-ID: <sesj43tzk243dgm7vmk2cvqy66gh57dd65yhebxf6pkmliblfr@6adx5sry5eog>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-12-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251025032221.2905818-12-libaokun@huaweicloud.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B398220005
X-Stat-Signature: y8ku3km6gyj56o3ap6wt6h7f9g9byiuk
X-Rspam-User: 
X-HE-Tag: 1762332420-373583
X-HE-Meta: U2FsdGVkX19ybsCnz+If74/6sO1sbaWuyguLS4Gt/lhvpVHEbXyNyGewjCOHPbYLS8wdTEeB6fqUGbKCPgELEVcWlMi7eT4cgv7rFxji4u+k0aVehmA4qcmsndbRjSr32N05bhzu3Z/DFmZBcyOYw1CooaNcA70MpjUssq6V2K6bG2MLPfgAHRSap9G7upfKoHvgf/m/EH1t++c+pcUPoK3NBPPaibam8SE5cl3YttwmShr/ROoYw4hy3cjmGgeatHFIfe+rnCZ9yMq8DZMhM9qWdYUqkZY4MGf5j0TSj8pSO0sy24UKD6aUdNjMgxfPZ643ZZfI1s6wYF1TaC6DYP2PclXjB02Kbih3iaPcEOv8lBr4ST7vIBkixZSwekmszyHf+06JOvgTMUXNFZwjdNtKC0DcgvV2Az/JPsgW+FoxcYbwX2nR64c0YV9hRZ61LhtaX89Er3Dh5OEuqJzb67g3AfppgGzKLRfHhbRBFud01OAzKnuy7UDxjsZLERDDZLgxkOS3X2xyejYWi36tzW7SZswKVIf6GA0cQYc0cyuEkO+QdPuJXyyKvGCemue4h2vmuss9ZvyBiZBc9kXJ4I/oOrQULyaO/2Rsd4W30CmrMBLSQMsGKOHgRzAx8MYROYfXd7ZcVPnhu2ceIJeqBJwmvuJKvJN7suUu6ETDnw2J9aMfNpT3DbDoS68qOEjD57eY4a40tQdfvwisSJNbKhq/8T+x0kxiXlFxwBv/8IARvY9xy3UBYzKhL9U6oTORadahIZjAGFbl3dNMakEY/T6FDhvdiL47+W38WGvNf1mspHkdSWRKnOEdQuug+2Sziu5W+WNOx9k7FdEgkiTRWWJPdWyhsSveW71GTBk3UaqAgVwAsd1I3UQ0Jnc37V68X8gDntD/XE5N0jWwRLifqPGH0bOSSI0zyNc9QPTi/vS7CDGF4mIWgcUAV/TqF2md870PHlLomG3ZR4JeNPP
 jPXq5xnQ
 b2k6Pzss2d/llLXYN1TSAFGwaltz6PNYZ0IgmCtMF7IPAkOsJO2RnIgGqmfSR1tMgTqeoABeEUoPaf32tUmRMIen6wXsphjTd/cWPJvwlQB9asCVDFJ0kAp/HPSwvB1hcsEtJRq9NBAb1W03vbLw62uPJslZWahmNuIPizURA68eL68nbDp8ZWM7zavGfHlGjrgmjDEVfZhcFjDd4sdgJsNc1dBS3Z0/4RVCPkXXyjgIOkU6ohJW44BbNZpz3ifTpdisOC4a1iD30ByqI1pP7u9VW3yg2ptu0jzL7JAvi/deng4MiIW9+d+ns/2DhzE+AKqk30LV2NbVOuVsZJiHiUzxmspvVoYsHxQy9H6PiJU8HHTfHgtBRGsMeTtbAnSXWa8bN2FI5xz9EKFjHvLCNNJjTLJKu2uagZspHwJiT/X8sIDAI+u75VOQsLEtsaSB6TygB/uDGH8Z6YSs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:07, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Currently, ext4_mb_load_buddy_gfp() uses blocks_per_page to calculate the
> folio index and offset. However, when blocksize is larger than PAGE_SIZE,
> blocks_per_page becomes zero, leading to a potential division-by-zero bug.
> 
> To support BS > PS, use bytes to compute folio index and offset within
> folio to get rid of blocks_per_page.
> 
> Also, if buddy and bitmap land in the same folio, we get that folio’s ref
> instead of looking it up again before updating the buddy.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

