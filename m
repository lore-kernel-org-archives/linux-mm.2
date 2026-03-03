Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33CDE67A70
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 07:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455C76B0088; Tue,  3 Mar 2026 02:05:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403866B0089; Tue,  3 Mar 2026 02:05:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5686B008A; Tue,  3 Mar 2026 02:05:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC266B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:05:13 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B31E13B5FF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:05:12 +0000 (UTC)
X-FDA: 84503865264.16.98112BC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FC874000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:05:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=b7bGWMoL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hCBv1slS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cdiT0o1t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=G6vp1Oyj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772521510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbqtGQb2uRnaIeW2MpYChMLVJcwORfI33Kj45iR5gD8=;
	b=vjVUpdaFJ+W4eEeYtsie8kIjbl7B0CWe7Fbtlc8NSBGgNN8NN+irLWu8npe64kkHD5StVo
	NVvnUF/HL9huYrJl3J7SB5YWPfUQb6/WFicDVcv8spGFyn1hcDN1b87fedtJAfKKuNbw5+
	nOEBroNmlpEneuMjhU/qUxS6STSr81Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772521510; a=rsa-sha256;
	cv=none;
	b=jt/98GPy9FGMilGJukWZB1V9/oc6Vjm9w7nkYG8JEqu5XnjDj7WR2hgaw9GjxS9Q8z+Ol/
	EbBsOrbDRKh7xRPxYOEU9/4jM9zv+fgBt1KXLRBSAfyQ/YDGiK4AtGnBAe7L4rF6AG1zhY
	V0cIQjiRmiz6gRHw0kIQ4XilEDLG7lg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=b7bGWMoL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hCBv1slS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cdiT0o1t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=G6vp1Oyj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D9CBC3F82F;
	Tue,  3 Mar 2026 07:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772521508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbqtGQb2uRnaIeW2MpYChMLVJcwORfI33Kj45iR5gD8=;
	b=b7bGWMoLOoDCZ26WjcpqihlrGzrArS2YeOhAXLEKm5snTwFGoZVqkZ8XCkQJIk3VleLja6
	dSO/ktVRHj1VHBGHNtaNsBi2SSmGDZ0FfpDJOPspMRsmvBDDTFcjgPko5UmfEEkO1kH/YO
	q3FO9HHRDUYRrnRqpo/x3UhrspaowLY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772521508;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbqtGQb2uRnaIeW2MpYChMLVJcwORfI33Kj45iR5gD8=;
	b=hCBv1slS+nbBHnG32l+Y5Nc/BsLk9YqcZV5QF+5TH+iyedtJVK7fAYvYHU3F5XuLmVW6Hg
	5ggeAEQdM+3JuAAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772521507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbqtGQb2uRnaIeW2MpYChMLVJcwORfI33Kj45iR5gD8=;
	b=cdiT0o1tQF4nCZN2lEtBxgukeo3434zDN8hmYw3dTOybk1kMrAwbpBUOzRGkpkCa29Y5IZ
	7SqnSzwY6tYvFD3Xrcro3bFLKXNykay6t5c22n2TNsPIy+2/w/unLaur3sxrquFoltJArI
	gSBLP6Sersr4fFGye5MSSvzSLNi9d9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772521507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbqtGQb2uRnaIeW2MpYChMLVJcwORfI33Kj45iR5gD8=;
	b=G6vp1Oyj0nd2IqH6dGlJSzy0/UfhTeBd3Uk6Lgm58EZK1e+QazOV8G3wPnzDf1PSSDt+Ro
	N4M+SeFm945QbBDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BF7D3EA69;
	Tue,  3 Mar 2026 07:05:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id toBfCCOIpmmDLwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Mar 2026 07:05:07 +0000
Message-ID: <a8851c28-bd31-47e3-9af9-e299ed0780cb@suse.de>
Date: Tue, 3 Mar 2026 08:05:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: remove bdev_nonrot()
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
References: <20260226075448.2229655-1-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260226075448.2229655-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2FC874000B
X-Stat-Signature: haafmurxht9syziugguanpuswbn9rgrq
X-Rspam-User: 
X-HE-Tag: 1772521509-542408
X-HE-Meta: U2FsdGVkX18ziCQvMFL66VSrOhdSUtKirYEHQjeQ63jKOoL0i4X++iZKGMhIHWyAzBHKI//eWwB5oZmb/IJMlHsGGKcKt+9e83RSGdNoE4fZY4McE1AFbVnPUePMpm5vLOyCwF8D9gcMj2UzKk468xy8A/mHE97ramJYDNCqg1Qh1TV9jweJoz1vtqMcD+bvZa9IR0XijQPos7ToOxf1XymIf5XamS4p6PuQCZXLjVcDGqWZ0ceYU6pIKrxyrdHcQv/sX2fO9UR8fEEn3jPn2iBO5mrVS4waOXNJXqYapNzudE3s9zdWBJ1RisJVQMIwEzMHzByqU83nYY5G3VQWqLA7xIygumXIVVHoFqY2qhkwidwk551ONaTnV0JTO5LbWU78J7GDXls7SPZIX3pWxYWGDoEMeqspaRXtrhg4bW+yzlWUZHMIAH+GEraKGmf+ExmQXiE0pvE8nob1Tv143PYiHA7TEKoknT/p65RpxCa29ayR6ESB1H2BiDzbWXHdeb/+x5ElYHigSZrz/IpZLwR4tf5VhU4ulHdNHaRUChbTzGjLN2N12uIhzB5v2W3UpELYAv2oNogB9TeXrry53BBhhjReTbpvA1gRKkxj5ZDkGJOSIcy33YDNy7s3h94g6Ib0DMfoaFydrcG2lkg7N0D+pmRBTrgVv2+oLStpexmiEFzDLtqjoNOubnVQhNf9/Jkdf8q/LD06mAtfOvYbh+4PMVf7c/3+a4Q+WoJuX+aroBnCFM/UCX5sZjsFDhC552g0bqwGyfk76Z7cf4Bs5OVZDeJ3h/6j74a+OmaIVhBqHPTLjpV/jjDfnQnqi1sYvgFR8B8XBxo89y50wwuXDXUSjjsZ83j39SFBgUrzcovYzxhiZuxMqHMrvIeJOhDsPQo005VBFNOsqZSc94JBKkReBEVeFWzzXuOo7zIf5XtcNfN8a8jISS8SMmwJuXGDTPbBoxyWuN+ZJeqom2h
 EReosvHM
 dgh/8hcsFy9nxiGVm/Eq95lW+fJ7iNRRUQL16azwl8klQz0J4b+yvccPtF6zxAO9IM4pXfGQLH2SvAmCRk+addfK7gfJUTdAQE2YpkPDnLRkRWsX8f3VeTuKyPdXtRLP6zzFw11/z4+YwrjUIdqRYEK6EerQoiOQ11ouNWzNW2/5kXQBXbPY6fFOx/zUfu7sbaLF/cdY4O6Vzj2y5a2bLHYOBbmE4535Tx4u7dTV4kxHmZCeblLfJnpXR0ERStJC3SOpNn7/GXFFEx+uKGiSwGYM5nSnJdi95Q4l9ieYrlAVO4amPB1OYWt/Hsy6uLKjtbn6AKDKDB93qAen3GgEUr9g6prGolmOyHqnJ5sElvU+cLiDaDkuSnuMWpcpXWO3Z86q7KNGg6zOF1x0u3L4KqOZmiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 08:54, Damien Le Moal wrote:
> bdev_nonrot() is simply the negative return value of bdev_rot().
> So replace all call sites of bdev_nonrot() with calls to bdev_rot()
> and remove bdev_nonrot().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/md/raid1.c                  | 2 +-
>   drivers/md/raid10.c                 | 2 +-
>   drivers/md/raid5.c                  | 2 +-
>   drivers/target/target_core_file.c   | 2 +-
>   drivers/target/target_core_iblock.c | 2 +-
>   fs/btrfs/volumes.c                  | 4 ++--
>   fs/ext4/mballoc-test.c              | 2 +-
>   fs/ext4/mballoc.c                   | 2 +-
>   include/linux/blkdev.h              | 5 -----
>   mm/swapfile.c                       | 2 +-
>   10 files changed, 10 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

