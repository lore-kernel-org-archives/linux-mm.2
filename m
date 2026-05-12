Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EE9CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEFD6B0088; Tue, 12 May 2026 10:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F116B008A; Tue, 12 May 2026 10:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28ABB6B008C; Tue, 12 May 2026 10:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 15A3D6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:20:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF9811A03B2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:20:06 +0000 (UTC)
X-FDA: 84758977212.03.79CC6F5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8848F20016
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:20:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="t81N7W/N";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1ZnWSPCT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MetrSyzq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sOo4epfI;
	spf=pass (imf03.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778595604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EP1faBGLN+no503thLo6n9CBiSdMnrRO0eLXY2Tv7I=;
	b=3r/GFsoXAX9OrV9dmZ/NH2CYTU6vQzU7pVmlUPthVRKmf/U2evWfgTa6c11LCOi8DS3+Yj
	y0JDL9IwUpq8s9AJkqfiscbe8BQdNaItF8Tg/WLTkd3fW+nBnTMJI4/QRtIKUZ5Zkzv8+s
	FFN2B/1mByHwF2w4M9QdPkKO8gOzlrc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="t81N7W/N";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1ZnWSPCT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MetrSyzq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sOo4epfI;
	spf=pass (imf03.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778595604; a=rsa-sha256;
	cv=none;
	b=17yvwH1IhUqQGdZAwiPgvLJnF3UmQ2hnriAYHflkmZgVodn0Yw8U1CgHIUt/C7xpwFNzxo
	8KNycvGGl/spwJQ7Mrhgs3ByVH35n7qMpOb8jypYwrNQotVERGBtt/RMiwSEcvf8gF25/Z
	0R+KMTLnnFn4r3MzdEhueb0LYx/WJ0M=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B75F775BB5;
	Tue, 12 May 2026 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778595603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3EP1faBGLN+no503thLo6n9CBiSdMnrRO0eLXY2Tv7I=;
	b=t81N7W/Nv8v0rvD1jUc+ze0GLTAUr0+ebiCY8NRvyVD072ReKjkvloxx4U7OkdRoEQ0zGK
	Uc1ZQoWjOazikndFHR4w84zAYGpdIYqD2+eV4s+n1TqFD38nflnVI+RTZcChEX0At55gfC
	drLcL8V43UizQAqY91hs8iAHs+42vQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778595603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3EP1faBGLN+no503thLo6n9CBiSdMnrRO0eLXY2Tv7I=;
	b=1ZnWSPCTE0ulbttJ5D5p1MT6QIrRfxF+4EzTeliV+7nqcWGcE93xfXPHMDBdnKLG6O+ysa
	OgeIRotsLjQzS7Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778595602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3EP1faBGLN+no503thLo6n9CBiSdMnrRO0eLXY2Tv7I=;
	b=MetrSyzqzRmF15ALI99x0FOfYG+LVv5NSyeKSsp1fmVsUQXBlW9EZpI6M5rWr2BlMe4NqM
	XV3Ubxo8H+0dPDEzfCCeuasu2JDdIi1kXn46oumn1eRCuL0kaUEk9mAwHLd+iD0XHpWU4m
	91I+1jdBGn8ji5W9GYx7LHTsH8Lt3Jg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778595602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3EP1faBGLN+no503thLo6n9CBiSdMnrRO0eLXY2Tv7I=;
	b=sOo4epfI7bN0V03WcMMc0+0wvwYdvLRapy8n5DXXujoyRA6nGGMcyk1otyobCC0j3AD1f2
	gYwqBRX7+8vmctCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A3313593A9;
	Tue, 12 May 2026 14:20:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cFX6JBE3A2rMCgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 12 May 2026 14:20:01 +0000
Message-ID: <816ac704-4f46-4f00-8e84-aed892d93187@suse.de>
Date: Tue, 12 May 2026 16:19:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] swap: remove the maxpages variable in sys_swapon
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-2-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260512053625.2950900-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8848F20016
X-Stat-Signature: fzyuk1arp81cq1jjftk4kyfhre9bz5sz
X-HE-Tag: 1778595604-610732
X-HE-Meta: U2FsdGVkX1+yiCNIU9KXSl4HzCFxFXJr4/Wres2OTkViUeoixSsniEtK2mPoY0mTBCZ4TIZZ3b6P0KJA/yo+Hsn1HpoLdrYw0fkEhD4H68v0cyKa+/HmHW3bZr8nvgVHITkRpfk+OHtR+EjPpaRh98O5lul/tp4W/tePk6y+n9S/ngC6nNGBc78rPM+mBrjDcOuQWt7ef1AWbhV5kP1HbcsoGOMRx0KTpYCgKDQoFuJdeImA71zXblPMBiX85WPoJ2FFLPBcpMZNqRKTawY39/qVzKVGSMn2Cp7iWiPxW/PASnTGot0lGqoABw2smmLd4W2o0OdGIJiaVRNwFkwGw39NNRyjyZGAB0cbzmturFVg0v447WUNUb1rdPV1wRDNFtQ4elc+4PIEMTNfybX6hHaQyTWR0HGdzbsxu/CXIAZdOO1ljePcp6ggykBKfG3cSY2/NenUQvos8iCbf2On/xMZq9gNdMvmLYYGwkIS0xtjzw7dvjsu21Gf3wLPEi6o7Bp2mEvyxouQP8AQelUPvz/HxzXgI373Yn7UqstxxfsjpGalRxVmBx7ezed5W6Qqt3hj55YIDOF5bU1q840z5+akoWfGFVyM+Nllr+p2lE2C/OU249lrLylviYtxqPeIiTq3FW94cE0f8uWh1xzW4W6MJ/xEH/GC5xL+c9m/UZlMAv7Az0+n8hmDqOw4ZZmgOYGQ76t2+wRBGFXbGTHGR5ocOkjAfZo647pPTTepFtKnJB8YJLtZKEfXIpMrbubQ+pCfX9N6/slahXrEX7iAr3WgsarHBCp1xQhta6zpSGDJEqK4pApY6pHKZIrm/8koajQ3MsZ/kEUkD2I3b565F+BAV8HlmT6fh6apaofo8bCcWHcFHuVhsjoXVNav/taCyKkr2qC2016NAGNhnjtFcStezUqum3VH/LFPqFSwXGL3JgzibMEEePz+jIgpWmuSpo/s22x206e/gGlDGsA
 XxkzWjW7
 eXaR2q505Isi9s9JpIOStP7EL4WtZIZ/aLUQVLyo3KQt+xAgvQBJ5WF3lDe/Xnl2MIueSD5C/Cd6iLexL2RUAYf6YcIlHbZfvACmVChCcZv+znAXgpRiBZuhmtyrFAK5Rmw7Y2phEjZ7JYultqOkSjHzSyJAIsI6JlZRmKafWrmAYzQiCM4o079o9eUDrkX+uWljKmMnlzooEwWKyST6LxEfw0kgzMVm1onYatgVpBkqSdv56EkV+TOWSHCU5ijIKOPAW+qqOgLFSu1V+48r9pDJ3WKnbB0w28fzncLyC5PJSvljlhRB1Tl8NdHVEdezarzcYS/8UddtQM74+/LER5xFXffDt3LmlEq263rybw50myT7mD3u3rnu5CjTU51dC0hdsuF2OZOteXCU34Bw3P0AjON7ipkAD/0Mwg8KY3+mhWGsM8Fw1Hjtx/lQukde/wq150vUGDurIzMkMaG2DsdP2zjSYcPV5P384
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 07:35, Christoph Hellwig wrote:
> Always use si->max which is updated setup_swap_extents instead of copying
> into and out of maxpages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   mm/swapfile.c | 27 +++++++++++----------------
>   1 file changed, 11 insertions(+), 16 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

