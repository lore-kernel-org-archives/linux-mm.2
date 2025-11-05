Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8DECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01EEA8E000A; Wed,  5 Nov 2025 03:27:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F118E8E0002; Wed,  5 Nov 2025 03:27:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8FE8E000A; Wed,  5 Nov 2025 03:27:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA9BD8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:27:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57AF8872FC
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:27:51 +0000 (UTC)
X-FDA: 84075875142.11.4252AC1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 24499140004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:27:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oB3Qq8e5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zXP3FhaJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oB3Qq8e5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zXP3FhaJ;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762331269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTfiJrekzapOg1bZIHfQgyPTVye8NZAS7/4c8g+TPSo=;
	b=mH7BNS71aJVwmWiyxWAz/sxPm4pIQYllBiHFM2kdLFnPRPS8I0HwudxTKs0BfOJCK6CTEr
	haJXmgnExa4r69wwmyhxdUZQ7/wRx9PkRjuuxVBaEt5D9aZd8JyD0pJUxjc/DmA8+WYcih
	x75XY8/DPg69i0Tj5xWWbVpJlaVS+n4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762331269; a=rsa-sha256;
	cv=none;
	b=aphK3Uc6uqH9M+vVkwjFl1eqzT3msh1TjrHjlVRxHXWOiDzRp0n+CA/p/8a3UnL4P76yeE
	ObemO3HzATTPN84LVcsULYIJ9Mb6x74Cd+A8E6EMafZQWGz/u50VoMTL+viRNLA6phoMp5
	v/1HtDo83jkJipsgqwZxRhQr0u42niw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oB3Qq8e5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zXP3FhaJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oB3Qq8e5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zXP3FhaJ;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 71D2621190;
	Wed,  5 Nov 2025 08:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762331267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yTfiJrekzapOg1bZIHfQgyPTVye8NZAS7/4c8g+TPSo=;
	b=oB3Qq8e5dZDDu6AGv8sAkWx95yrxGEHymjjNRPu5z/0Jh1M9ngWkstHKeRJnB5pzFzWHrD
	AD97vONGGdAiWmVtrxXjEkNqovKhXOxMEE2Lnr/VcV0DLHW1KIDEKdXG+BAY8PjV01eavY
	sixW1OQcfMHlyQ4HE4IT0PqjNYxrADA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762331267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yTfiJrekzapOg1bZIHfQgyPTVye8NZAS7/4c8g+TPSo=;
	b=zXP3FhaJy5ge00Nbc8cVKnvJMZAL6hrWiBWPzldFoOk7L2XvQIj+kOZHapmMgS9HNO27h0
	daKCRK6aOx4lRzBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762331267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yTfiJrekzapOg1bZIHfQgyPTVye8NZAS7/4c8g+TPSo=;
	b=oB3Qq8e5dZDDu6AGv8sAkWx95yrxGEHymjjNRPu5z/0Jh1M9ngWkstHKeRJnB5pzFzWHrD
	AD97vONGGdAiWmVtrxXjEkNqovKhXOxMEE2Lnr/VcV0DLHW1KIDEKdXG+BAY8PjV01eavY
	sixW1OQcfMHlyQ4HE4IT0PqjNYxrADA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762331267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yTfiJrekzapOg1bZIHfQgyPTVye8NZAS7/4c8g+TPSo=;
	b=zXP3FhaJy5ge00Nbc8cVKnvJMZAL6hrWiBWPzldFoOk7L2XvQIj+kOZHapmMgS9HNO27h0
	daKCRK6aOx4lRzBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 663CA13699;
	Wed,  5 Nov 2025 08:27:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id twbyGIMKC2noXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 08:27:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1329BA28C2; Wed,  5 Nov 2025 09:27:43 +0100 (CET)
Date: Wed, 5 Nov 2025 09:27:43 +0100
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun1@huawei.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu, 
	adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	Baokun Li <libaokun@huaweicloud.com>
Subject: Re: [PATCH 10/25] ext4: add EXT4_LBLK_TO_P and EXT4_P_TO_LBLK for
 block/page conversion
Message-ID: <at4bgovycfr2djhu74dx6vjjr4r5rh7lhggxilpnkqt37jnmdt@nbk463hqeia7>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-11-libaokun@huaweicloud.com>
 <pgrk2x54egzxcvmfi4rra3exooxe3yxuvug6yvbtrgxm2oppym@fy52xh4weeww>
 <761b447d-6e34-4a6d-b1d8-9f744ab548db@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <761b447d-6e34-4a6d-b1d8-9f744ab548db@huawei.com>
X-Stat-Signature: n9mdb7u9sp9ruh5x7zdsp86uufxtz1ya
X-Rspam-User: 
X-Rspamd-Queue-Id: 24499140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762331268-410427
X-HE-Meta: U2FsdGVkX19cPAY+T5WfQt/oF5Hc5Y5YxeFxBG/lhrwecGZUkQr+KiKRi1DVY92mRbLTYZ8NDk0B/shzumFeY15tZmgdFaIKM8cTIUcsPjxqVEWj0xyeImHwELAqu34ioS0b2bWWMJ80Z+AzDW3keVo2URedIyN2cSOB23hHdWnx/QgL0gUK6GjbhaqMgyG/iemINklnILl6zU2KCefGt4nCwcN1x0D+1vLT4GHgpFUXWabGHOt5s6NMajD2kPZbKgNeVlAzmw4sR2nRB6MYm+t2GmELsaHBrPEMf9Fl40xrsaL+TREojAYxbqaMCJo/AFOC7KoqDc9egWLoCah5a3XAJJSixzwgzn/mvGUbQi1a7fnvsAi3OHbH618dBt4iRXjsWhuplb+XBGFz7puosPvnYwYrpfg5NaCaCKuk+ZkviyeF7UnzVUL1pMvpmkRy9NB0X5UQB9rRvAikh/Swz5d6Y28PlzwlDoKiVin8oc4r5sfU2XHdehvFEvVW5jy1AM7wvou/QCd8MRvF7M6gEy++DGllY0qALuv0pJ3Vd7QV9Is+1AFCoM/usFTf7YvgUY3oH3ufpXFKkR450+RVyVKOEYjTEes4ps8HJ5+H8dhMD5rtcX37PAo+vUqAuVItuxbsLcyJ1XxlT0CQ1CFGHPOnK4YQX8ArYyV6/54CMZkXCqIHbK9/upi9epKgPI7Z7691yTSuH6JOW1y5lVwRZs3nJS2r/ZZQAD1OqOPd5u4DmeNqCXIQw/rh3bnrUHICuHqUWVorEvGZu9bDHo8/tN8kQOhataQPOSOPL/wa9KnwJ9UqHD6xrWqtB6KbRM3uzUX2uW3Lzzzb9Ox4BofTb1fXPHW2XWj1VpvVqaMywFAcr/KgWvK6V3rIUi9rjQwqWQ4XnvSEmBq9nJHji1ZuqLbfHI6NJ580BpJ8sz5VYR1kc3O/9izYBi13j1jmSbn90bvr0aqFSLp4Lp9rioB
 N20HHrGS
 6L7o7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 03-11-25 22:45:45, Baokun Li wrote:
> On 2025-11-03 16:26, Jan Kara wrote:
> > On Sat 25-10-25 11:22:06, libaokun@huaweicloud.com wrote:
> > BTW, patch 8 could already use these macros...
> >
> > 								Honza
> 
> In Patch 8, the conversion is for a physical block number, which has a
> different variable type than lblk. Since this is the only location where
> this conversion is used in the code, I made a dedicated modification there.

Ok, fair.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

