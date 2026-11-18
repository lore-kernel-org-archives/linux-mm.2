Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98FA3606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dv+UlE7D
Received: by kanga.kvack.org (Postfix)
	id 66EF56B05B2; Tue, 17 Nov 2026 19:49:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6200B6B05B4; Tue, 17 Nov 2026 19:49:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E91B6B05B5; Tue, 17 Nov 2026 19:49:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4766B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:49:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96EB7C05D1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:49:52 +0000 (UTC)
X-FDA: 85446407424.19.53FC599
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id D3BA8180002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:49:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dv+UlE7D;
	spf=pass (imf06.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794962991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1mRNb9No3wdnTR/cMHZKezqf8q53Bzdh8b1/a21plE=;
	b=be4kwR0g4vT6FakNfVO4NjdFlvLH6BNIB5AlyeoHnQC5MyxQip44DoqdNebdB/t5kvtq7V
	mEO5XhN/k8rUbpA6yGFFiv3LEU+5amiMzue/nlwuxPdLgGh2v4KnG2yXfJNECBGcPzG7yo
	T0zfs2YsbNLVDYE2hNncm15llxOONFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794962991;
	b=WCbop0GGY+zuB+TbGYItCZQRECKwRxUGlGP3If6eGVhDK/hbErOs9HDJRMP5WzYHjPUf1Y
	sl9nP4CrTGKNu2sJJbdeg9iHwKzJgLl1cFspQew4lCqu+ld3jVFw6Ne2iPianO4/mMTzg2
	Rs1JkFYsyZgC7SvcexmNb4ipA71gdaQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dv+UlE7D;
	spf=pass (imf06.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=X1mRNb9No3wdnTR/cMHZKezqf8q53Bzdh8b1/a21plE=; b=dv+UlE7D0vybkp2FFYzNVNv6tm
	zuETQaw8E6xBRIiGf3XrdmMTGCImEG/hGKGwMuJ7CT58L6L1y6BHWR1FYaQve6JaIFsv0ISM2sMJx
	8jAWIyB13E0JYfbhkuwbqpTPS9B2dOpD2JlFRWg8y9c1FQiQhBb4rKxPs1Hgycu2lCiv7O43j4UPS
	7RA3u1p6jp7RnjHRo7iObXjiXdgaou2K+XNoFnLv/G+NOYOowQFgY7dqYq1ReDt5U2TnxKsVY+WD0
	8/o+99/RZuj1sQMk2r3zRJ/Xp4lmlrEtBAp5LKX9JOjA2VYJlOnSYRluHFMJFWl7bKg/+hNKg3ahe
	3rwqX+mw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTTrj-00000007PFp-2tTG;
	Wed, 18 Nov 2026 00:49:35 +0000
Message-ID: <aab3bd74-80c6-4d51-a433-140b1d27946e@infradead.org>
Date: Tue, 17 Nov 2026 16:49:32 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/12] docs: ioctl-number: update FS entries
To: sashiko-reviews@lists.linux.dev
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, linux-mm@kvack.org,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 linux-sound@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
 Chas Williams <3chas3@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Helge Deller <deller@gmx.de>,
 dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org,
 Neill Kapron <nkapron@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Hans de Goede <hansg@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, Florian Fainelli <florian.fainelli@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Tzung-Bi Shih <tzungbi@kernel.org>,
 Benson Leung <bleung@chromium.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, intel-gfx@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-11-rdunlap@infradead.org>
 <sashiko-outbox-215810@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <sashiko-outbox-215810@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cf5g4demnyzcqqz4eada68ioxnsdt9tb
X-Rspam-User: 
X-Rspamd-Queue-Id: D3BA8180002
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794962990-572168
X-HE-Meta: U2FsdGVkX1/pNEZWle5xaYSPfZHV3aVb0OGxSXpJEWke2/y+OQuJknSoREwOLyMQkPSzvHl8LpyJiDTsUdI1+9WuMIcNdEHD2cdtLssi4VFoU7SHq/lLkUDGF6gd224VqOabgenoH+Mbpmlj58vMJVT5r4rgqDTqYMdlre7bbDZtf7iz4nzRhZ6O6voVw9z0mNOs7pv0nhqhhJSCMS0PAyqAAKHBKeKHpolN5kH2z6/yjhIjtkDG0BRW1C7LklymKb9y9kQF9Fp1LaBhYbRzFRbLY3A9z/+t2JL+SAFPennrv+/klQE5ISB3KF212vyoaQR91R6VN5I26mXOJXX6pxdBBZGyuqy05azrqwZroVImZ29sT5rFZmzT/lHkQdg3PsbdUwRzW1g4xB3LZINCPLur4Wi5DWGnDQ4rXGsk1I3djaAKIHGIjSM798ZmGZXzqYAbdrbVtSCjbG+lPH2dKU9oUtlb+VYqK5LetFiikOqkrJ9R8i7sse4MpqzIGwwSs1p65BuF1/hbWxXkzXSWIu2F3xhfchGzCVrSIytb6sa000aGUJ7YRkI6aado12E0JwFoohfmRTsvZDfLGEqmwTBJCZYfGcTjuv6zzO26Q6n46NPwKZ/etCclpyv4DBhCwBc6hZOfoL1kIcmv7oKTRPmRVOSkQYGMzIxoEYVxU8qHZNu0iAH5t+lFcANmyicN5haPiJjedw9zPBO+5qEfCBYApcYB24fme5hjn1v7JJbzlpFnHAut11EtFgID62nqUV51LGfq+kZZZ/BHIFGuVBbDUEz46mHPFU4QdDK4gc6b0RGDUzmImAIdBED87nSy15yIc7iT9uYQaoV5hWDs5+D+aYV5LpA9YT1leYWxraA4A9TeBm+cRLU7H2FwAxftqGs+NQLtqlepP51kDRI6kMWjtxNt4NjtaXAMtjX858TfEFgWGUB2G6K19yvhq3TPFB0R6KVCv+iaw/wk5Us
 0lrniVNx
 nuCuc/p91bl/+o8UilCfOIK894j730ilKeDMYkc1tsd0IJLj3Woap/9m1W+4E+4C5+OY+EWNs8j65qZMy6/V8e+jTl3bX41oo4coGJBEBhu+GnDuibjTu/apT9mja9hdDbiM5D8rp6crQPMil2g1RJCoZac4yjftaNSucqdrMGRUHkF+XYoHSiTkeJiX4gINOicJO6g0i639Ih3MG4KXH8QzQzf3DkOTLe5XLO2wjMSW9SJKuULfvRskF83c7uon9F9ZdDJHL+LqJTPO6n0o9uwtJi++KMU5Oy8Y+1i0Ezsccdwk1kamjSlYKtbXwahxGBgR0H2eAxGL6+lQ0Jf2qNG7oXx6Og/srhpZo+d5fqEsLSlvWKgkZ6mM0pG8PgrSBSDz6cyab0bISr4WgDxwndqaYJu8PtoVL4g70HG4wLSl2P/UNUfs7hD7jmauDfS8ZliJ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/26 12:27 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] docs: ioctl-number: ext4 00-2F ioctl range points to
>   fs/ext4/ext4.h instead of uapi/linux/ext4.h
> --
> 
> commit 9072a8199d2be085dc5ab2567392180faf810c6d
> Author: Randy Dunlap <rdunlap@infradead.org>
> 
> docs: ioctl-number: update FS entries
> 
> This commit updates the header file paths and sequence number ranges for
> filesystem ioctls in Documentation/userspace-api/ioctl/ioctl-number.rst.
> 
>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> index 87e547be9e2ac..abc89b6288ba3 100644
>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> 
> [ ... ]
> 
>> @@ -275,7 +276,7 @@ Code  Seq#    Include File                                             Comments
>>  'f'   00-1F  linux/ext2_fs.h                                           conflict!
>>  'f'   00-1F  linux/ext3_fs.h                                           conflict!
>>  'f'   00-0F  fs/jfs/jfs_dinode.h                                       conflict!
>> -'f'   00-0F  fs/ext4/ext4.h                                            conflict!
>> +'f'   00-2F  fs/ext4/ext4.h                                            conflict!
> 
> [Severity: Low]
> Should this entry point to uapi/linux/ext4.h (or both headers) instead of
> only fs/ext4/ext4.h?
> 
> Commit 519fe1bae7e2 ("ext4: Add a uapi header for ext4 userspace APIs")
> moved the EXT4_IOC_* definitions spanning 0x03 through 0x2E into
> include/uapi/linux/ext4.h, leaving only the compat EXT4_IOC32_* definitions
> (0x03 through 0x08) in fs/ext4/ext4.h.

Done.

-- 
~Randy


