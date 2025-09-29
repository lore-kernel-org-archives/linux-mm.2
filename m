Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE6ECAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78AF8E0003; Mon, 29 Sep 2025 03:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29A08E0002; Mon, 29 Sep 2025 03:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F3F8E0003; Mon, 29 Sep 2025 03:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 924B58E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:05:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 300ED57F30
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:05:53 +0000 (UTC)
X-FDA: 83941402986.30.CE08AFB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF8131C000F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:05:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KTjatXcQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EdTVebLP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KTjatXcQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EdTVebLP;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759129551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNpRu4Z2OugfjqfNcQiZeCEO6pYjWJtUETttpSuKeCU=;
	b=jdjykF+NIqxVjKlwdoh3O6kY9g5fVogKZe69apCFOjxcrkbxY/LFA6+LWbsbp2w2ILIWKt
	hS3fnCvGrwsOIY4lZupdeoZZUM5HwQ++3aoTbxlpqY9lQyzc35CYsh9hN0hzgCGihv/5jr
	9R65wzv0FePnxcEGF85IxHzuq6llSnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759129551; a=rsa-sha256;
	cv=none;
	b=0MQq8ZgTidiA2HaL0yb0Hl12FVnQug+AO0SC8lHt4xQ1V16Ic6Rl6x7SRLMyJGZTwDBSIJ
	R/Kq/sAEY0jkJNzPRd1I+L6Qy0ywMQtwzaL6ODk3SDeUwIylW+385uI3YQfcn87KuQl9te
	EuWIxr4YMdlzRo1JAAV4nDh69+5m9IU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KTjatXcQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EdTVebLP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KTjatXcQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EdTVebLP;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F2F2B30567;
	Mon, 29 Sep 2025 07:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759129546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tNpRu4Z2OugfjqfNcQiZeCEO6pYjWJtUETttpSuKeCU=;
	b=KTjatXcQdqXr+nYbhxwh+pR/Sq08Red373ivaGssSgf2D7VDXSR0UKecI6noeSRKhSgH5u
	yZ88CEcwiXlef3yxrTP24rReS2mfq9zlEKfHlMDO/s31If0sVAD4iMfUrH/E0vlnseLfGd
	W2tVjP2By3YI8HLwulydXN4yDSN+viM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759129546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tNpRu4Z2OugfjqfNcQiZeCEO6pYjWJtUETttpSuKeCU=;
	b=EdTVebLPxPU3FldFp8y8Qqmu1iZ4BN8ljDY8UZMc+4UWvq3kTG8jVN2xqvEUVu3TdPsa8U
	aw6tM+gssYwttPBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759129546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tNpRu4Z2OugfjqfNcQiZeCEO6pYjWJtUETttpSuKeCU=;
	b=KTjatXcQdqXr+nYbhxwh+pR/Sq08Red373ivaGssSgf2D7VDXSR0UKecI6noeSRKhSgH5u
	yZ88CEcwiXlef3yxrTP24rReS2mfq9zlEKfHlMDO/s31If0sVAD4iMfUrH/E0vlnseLfGd
	W2tVjP2By3YI8HLwulydXN4yDSN+viM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759129546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tNpRu4Z2OugfjqfNcQiZeCEO6pYjWJtUETttpSuKeCU=;
	b=EdTVebLPxPU3FldFp8y8Qqmu1iZ4BN8ljDY8UZMc+4UWvq3kTG8jVN2xqvEUVu3TdPsa8U
	aw6tM+gssYwttPBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C20DB13782;
	Mon, 29 Sep 2025 07:05:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PbGhLskv2mj+FAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Sep 2025 07:05:45 +0000
Message-ID: <3d54a546-77dd-4913-bcd0-7472aec8f53c@suse.cz>
Date: Mon, 29 Sep 2025 09:05:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
To: Christoph Hellwig <hch@infradead.org>,
 syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org,
 byungchul@sk.com, cem@kernel.org, david@fromorbit.com, david@redhat.com,
 gourry@gourry.net, harry.yoo@oracle.com, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 matthew.brost@intel.com, mhocko@suse.com,
 penguin-kernel@i-love.sakura.ne.jp, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, willy@infradead.org,
 ying.huang@linux.alibaba.com, ziy@nvidia.com
References: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
 <68d973fc.a00a0220.102ee.002b.GAE@google.com>
 <aNop4ZBrfuqrX40Y@infradead.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aNop4ZBrfuqrX40Y@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BF8131C000F
X-Stat-Signature: yrfbxeqzfqpcjymmhgmi69mt7yar1a5e
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759129550-190608
X-HE-Meta: U2FsdGVkX1+MQm9vdyauiCWuREcgX6+n1T7Cj/aBw7JtDaOw0tR5b7MIUKl34XHqQcXvfAjrcKK6KnSJxEeEsERjffnWMxjcCl94xrlCLRSP7Z+Zf1GenQ+qWWgwFvlkfPd6p+kGGCpObu4Rfyhb+tKXAHAFwL1j//z3nHA+s/QW7eNrvPI+K4J1FQWa4oaW/6VOS61hgK1vqNesn2JvTyTeIOVUfX4u5FTz7JX9eLYnlyGgNswxfTtc0hajnX1Xj6tD6Pg2JWgi86tTMfrULe7xk07lUvsJjGEdm3ER2KDD+kO0FHy3w+z9pjdnnRfqHl2+XiHv4psfqRpVOpEZYFYjMYVK10TntTP0un/ceH0UqXjyeBv60LXDjVWIAeeGpJMCbhjUDB6ZEPcu8K7qAlRj+J77VF9yQYt+bPc1/CyQtXsldhyKaX0yTLHqvMOorQw5+g+AFYCQQ3ltRKt2SfpNRc2j8CSNlgjB3gnfLZkJfxZ4HjbUW8EjFnM8XibRLjziq6TFUPB1eWhcmjWrGc6gA2RD6kQpY4UymgXME3ltEjUIAuxbOs62A6Dd+Lm+ZSAGLuovm9wSOqfA9WtpdXNdZHJOTNLRkKU5VJquosBliZG08Cz/IuqA9qlc983KV3izSUzu39M5oxt5RxZnMpQGoDHpdz4yDN2POKmnwwz6bUpEK6TY6vnPZTRmyXAjshC1qSCC6hv1ymScs/v09SpOe/6uJD2ZDuzSmVRnoaGe8dPJe55oqjDXpISnn4SE/9MSqpytwFZsrh7loRM8dCQb7+W9f4AUwAkIL94dKPLS7Ovd1JnaFsV717AlToKgxqXQV+7/2MztxYUyWTjaHTZEePwLCcls9v4w/4fMNkwRIK6Mt7pc5Us2+HhK6cVeJVVqMBi2dOe/ZscBvZXdFXD3ri77e4nkC5bEM8JiAII2VjOMaswUvPTJHKrwskUn3luZNcww7Pe1yKHeWfZ
 XRpki0qU
 4jOUSgM2uhUkBtKjw6dTTcolCVjM9MjioT7BWNM+qS0Tc/l+JVdhF9YrxFiv0GhIk48lJ+ooQmkQhZ39h6LzSLLmCsJW+0DxEKgcX9p9kbnc8VQiDSmZy9uJkyUEnUw+GMdxchvjr/9hocBqbPYAUy+jr+y71dhoJu1j+p6rkdZiy4GyOT1eBhPbTq0tOuuKFEgbwioSTvrb/OO3vLyhCcTImhaNl4tCUbT7gBTtZOCDsdIPfTLrrEFpAV0rYDqjnp+EZmjBzmd0s1GsA6GLgIYRHJ9jbDvqvU6l2LUOjLIAFyb9rP/WLsAU9fVGVUm0Ds/U67vujK61qZBpIWW+hA0o87KDUJnxwzvaPuSXsv+SbmNfXlTwwY36TabGEdCpjTVvZSluhfaSnmuX9jxpjdhXMguAPh5EiivVnK2kBScX6NhvfQAiQh1EWIgMPUpuFgNgrKpRn/jKAk33sS9kfdrDC1LQ0XFFmE6Q6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/25 08:40, Christoph Hellwig wrote:
> This looks like slub turning a < PAGE_SIZE allocation into a order > 0
> folio allocation, which the page allocator then complains about.

It's order-1 to order-2 but in principle yes.

> We'll either need to make slab not propagate < PAGE_SIZE allocations
> to order > 0 page allocation

It normally doesn't, but enabling debugging stuff can do that. In this case
it seems to be KASAN, but could be also slub's own redzones etc.

, or make the page allocator handle the
> latter.

It handles it, but warns you're doing something you shouldn't, as
__GFP_NOFAIL allocations shouldn't be large. We could just silence it if
it's due to debugging. SLUB could check if page allocation is bloated due to
debugging and there's __GFP_NOFAIL, and then add an extra gfp flag to
silence the warning. We could use __GFP_NOWARN with the risk of someone else
combining __GFP_NOFAIL and __GFP_NOWARN to silence this. Or invent some
other internal flag, but there's not many bits left.

> And XFS shouldn't need the NOFAIL allocation here, but this will break
> things elsewhere as well.
> 


