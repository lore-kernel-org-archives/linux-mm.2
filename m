Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E78FBEB7EBC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E2906B0092; Wed,  4 Mar 2026 05:36:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27EE06B0089; Wed,  4 Mar 2026 05:36:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15AB96B0089; Wed,  4 Mar 2026 05:36:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F169D6B0092
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:36:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B98EB9A6E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:36:38 +0000 (UTC)
X-FDA: 84508026876.07.B2B66BB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 45C60A0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:36:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zbilbouA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h6UD410H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zbilbouA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h6UD410H;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772620596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZTAUHAF9UTKpf13oP8jFEeNlGDpWhHrwgG4ztNisMz0=;
	b=6gdwcSC/a0T9v3uxs96i0dZc6SHmeOTEmENmKmES989Kfw9KpmslFRaSklgSAzpA8A4vze
	GnspHkEgnYx5JTwac+DC87SpUOIvvLCI4xHtwO1MRjdlLDy1oeLtrU+WagRlzlEjiEAIWH
	5PEUr2Oo93FHrIKu/D3SIsor9PdvOa4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zbilbouA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h6UD410H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zbilbouA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h6UD410H;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772620596; a=rsa-sha256;
	cv=none;
	b=wQZmUpzoKTkedJgVWvZsPvekZqAtFuTg3OJUQ/49wmUzDK50FFHeFy3J9JoMfLXv7D+LX2
	7Sp0yjY4kMvL9VR3klWP3XBUtm3dzsXT+GWyPnPzt5IpMAsMnntfJrtPDOcUzDTwta1Zca
	9PSVk+l2mVU/nqK+sragNrow5eRCYIE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 850D15BDA8;
	Wed,  4 Mar 2026 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTAUHAF9UTKpf13oP8jFEeNlGDpWhHrwgG4ztNisMz0=;
	b=zbilbouAi79PwtHlicoiF+7RqOe6qooQ/oBnE6AcOXE57Iq4/Mxaib3jR1vkNMRVfByT+f
	Xy+Yd4bB21cuWG6QB0LPHgvEm/j8DtsQSmNqI1wMF+q83LGdxpttBEYgZi8QBGuVOKdOyq
	iDRS5bOHFNQkmyRCYw+1Jdp96SCXUuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620593;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTAUHAF9UTKpf13oP8jFEeNlGDpWhHrwgG4ztNisMz0=;
	b=h6UD410HcIUj3J3y8gxiaHvPXQMrHZhLCPf0xqLb6Nblr+uNgkP5hvUXfcUoIeUrS6IWvu
	kHQj933123o5X9Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTAUHAF9UTKpf13oP8jFEeNlGDpWhHrwgG4ztNisMz0=;
	b=zbilbouAi79PwtHlicoiF+7RqOe6qooQ/oBnE6AcOXE57Iq4/Mxaib3jR1vkNMRVfByT+f
	Xy+Yd4bB21cuWG6QB0LPHgvEm/j8DtsQSmNqI1wMF+q83LGdxpttBEYgZi8QBGuVOKdOyq
	iDRS5bOHFNQkmyRCYw+1Jdp96SCXUuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620593;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTAUHAF9UTKpf13oP8jFEeNlGDpWhHrwgG4ztNisMz0=;
	b=h6UD410HcIUj3J3y8gxiaHvPXQMrHZhLCPf0xqLb6Nblr+uNgkP5hvUXfcUoIeUrS6IWvu
	kHQj933123o5X9Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 77EB33EA69;
	Wed,  4 Mar 2026 10:36:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yNI+HTELqGkjFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Mar 2026 10:36:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 379CAA0A1B; Wed,  4 Mar 2026 11:36:29 +0100 (CET)
Date: Wed, 4 Mar 2026 11:36:29 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <n3anrkzfguzbn5sfwsom472cx4uzejyfemz3d5jm7c4rt3qr6z@ez2cgwzmbfyi>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
 <aabrf4YhPJ2X7n9q@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabrf4YhPJ2X7n9q@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 45C60A0005
X-Rspamd-Server: rspam07
X-Stat-Signature: xjaehbrtncbc6afccwjmrqhzx58w7fj6
X-Rspam-User: 
X-HE-Tag: 1772620596-21437
X-HE-Meta: U2FsdGVkX18zp7c2F7zoIgSxtvRwbACsI4EmKzj0JNSwXfgt14KVUPvwN6PPGAKL37g/1NR1mxKvy1Qr7c25jPUKCgGEUTsZsgVelKvHfCtqGFWkraE6sJoeFJNcYqekaDDtsumO5vHDcEDTlWuu2BPuT1luY3280RAhfVTwA0L8aVylqMd5w73nBE7q7kzzXv+b/fZKLrQw8UkzX+nVkD6knZfnm+XE+zRlLqrRrhDH5qKAm8G25SAVu+cloc4UT3FEfZ+qiUs5Kl+65bw2p8sFvJAVH9drs6sf60NIAtBn0u0yPYHlHgIEwhgi7+9xSNGwWhmaOQSm6uHmi8Ohr9FFxTIlcZSajtfB7bkuWY93DBnTrHsmy0gakrDBACssIy47u6qR5yMagSSE5YM793Fq8DvGjxT5VkOx1eLudOtNzsR3f0jmw6feVBfn+JkyQW0cDphFbKsK5TZGabp7UHFpm6T2pMZ9G5La56j+lC9q+i4TOgyws0gJt/ELtWM8J0b6DuFcWbCY04mSTDtkSPiCMFIAWbLRNvDApW3QttGmGdfRxNPBCSHJloQxAPJwk+hT8ZnCcT8c5tBwLVv/BOcK/3nLLcXROj5BlyCm9JCRxQp6qutUvhqJx4gBQDYoappM2bPfFUzGpVUN6wdtmPWbAjyJgkrUIti6UGaipJiRFXHWpneYaODdRe+01xZbwm8MYuMI7Tim8uAKiSgw+0292eORlkLhltO591728Fj+/5VNTfkbeJZeL+0L9fEavExUaq8eOkKxJ1lHKP6Rz3GAN/+S3XPbvS/tyO4HIZKGcnqFmDN9XidoavGEwzip6DVA8I2kpBViWb+CJL9fYVgoUBTqqCba8I5Yjd7nyyoffpFXE/d1EMgi0GlbqnISZUTRoV3o3fHrTmMb+15GHQOiKyA58ozb2gLbaz3XaHhDOkKqJ7SbHomHK59NncpoYnXX2BPqFEF2BWySHmJ
 TxAV87vg
 u79W7lfYIjI7E8N3IekEF551xkBKjApXxUAaFkvrqwvbIyBe6DTIqrMt5O+UQEls5+fFWWQmL1UqF6AUHg/QBnnVY73yUTECZlBM3TuAtMqppGQMze81WacSoBEYcQWywfAr84Y/LczRC6JMZACil5EycKyWxzDMxdSBdTxGPtf1GmWUnPfP78XQxTM63f+PwyGIIxODhJ+CaduSB+d7J4beDR/+eT1JV49b9aqVSvYORVlngJS44mz+x5nFpIlvTfWC1BdDP+JPNZB5wSMN5anZXKrJwG1H068do4StcV1wbHlKYxJ8tixWDvOCL00vMR6lPVoe6j1Jkymn5eCIkFfpsQNMCQ6NtidH1XxlQV+pWyOQtYF7qKXTgQrT9bR0OCqnnSMlO6FyOLmm2Xc7FkiV9lQJGOcv8all4TRDzk49+aE694a1iOfVNmgAkCNkhA59m4LvAaiu29DM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 03-03-26 06:09:03, Christoph Hellwig wrote:
> FYI, linux-block only got this patch which is totally messed up.
> Please always send all patches to every list and person, otherwise
> you fill peoples inboxes with unreviewable junk.

Well, I've CCed on the whole series everybody who was non-trivially
impacted. But there are couple of these trivial "remove effectively dead
code" patches which stand on their own and a lot of people actually prefer
to only get individual patches in such cases. So I don't plan on changing
that but I guess I could have CCed linux-block on the whole series as
buffer_heads are tangentially related to block layer anyway.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

