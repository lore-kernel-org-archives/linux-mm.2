Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2FD5606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=If1yj84T
Received: by kanga.kvack.org (Postfix)
	id D9E9F6B05B6; Sun, 22 Nov 2026 11:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76216B05B7; Sun, 22 Nov 2026 11:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65606B05B8; Sun, 22 Nov 2026 11:49:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A63E6B05B6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:49:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2830C1206F7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:49:27 +0000 (UTC)
X-FDA: 85463340774.10.DDE1BCE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id D223E1C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:49:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=If1yj84T;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795366165;
	b=e/Dolsu8d+xA9hgmg0oJob3PixI85psxxkk1+zNOCP0cFG8teiA3rs3v13bGH/TzvZhhMv
	mypZIu435szB29ZBrA0ltTGAG+MF/xmdU2Kjp3QvvYFczY2GxyF98bO2fgaqIgkH/qXZ6Y
	u7NYt1UyFdelsgnlrL8kUn6vky//Vtk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795366165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1n4tlVAMD1oQEfLg7AgK6BF8JkJzQIdhcOfMal/6gZY=;
	b=0nnejK5V9SMjOh2ywV+ZeQ7jtn8v8mVoGUZrO3jElzpbyyeI35y5sxnV55Y2/umUme0tX5
	buOnLnDL5ThG9Yv4dCub/PhEQNV3b+yiTA3taUhSPYI3U1EMkgEcnwvriFgUCf+MRtYgRq
	Y4hH9XCTizwpwZ66Rgtvz2Sg3FFBTJY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=If1yj84T;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=1n4tlVAMD1oQEfLg7AgK6BF8JkJzQIdhcOfMal/6gZY=; b=If1yj84Ty+PWC5pwN3l+urBf68
	2hR0b/KbpLdHtCSDssJRGtWWNVVHcXXibwvo0e16Wu5PcF1GbzrF+0Nn/0orhZPZLp3AaUrOqCeE3
	M0g3/VZCXrSCWsLf3OJiUda66VgMdDR5zNN/JnYJhMr6Zloh8ZVpZL5T6FbjOGEGGG9pYSEFlPSo3
	xNjZ+pwXJ34Yaiph8LhnUvR+33XsPWSndNcZzF1mF1Y/Rg3p7J5onQ/FXu2y6sBr06vas2ATQ1cNu
	jo4l2Ca8g1GdoMwCPQY26/RHxrAwrwLjXqoQ1EhLUm39E6z3sHmGRuhzwWdrOJON3ct7fIVJwApAK
	GCbPEuHg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xVAkg-00000001O6v-277K;
	Sun, 22 Nov 2026 16:49:19 +0000
Message-ID: <1e62d5c8-3ca7-441d-8979-f054fb815912@infradead.org>
Date: Sun, 22 Nov 2026 08:49:16 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] docs: ioctl-number: update sound entries
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
 intel-xe@lists.freedesktop.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-3-rdunlap@infradead.org>
 <sashiko-outbox-224494@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <sashiko-outbox-224494@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D223E1C0005
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3dkf854gg7ucn1qkyzuuebywkt1phmqb
X-HE-Tag: 1795366164-37967
X-HE-Meta: U2FsdGVkX187wUa1UlNrXR8N0ZTXJsegW+3JvcLx0gZ3tXL5rcS0lwJ8ckK6T/GKqQr4JAU0uUYhqmHykjrlE4DvCJYIwxO3mTOuVGVlSANakLEuhzgCyclX+YxfIcnsOPBLLtKBXyGoilWZoqM1hoQTEM/Ob08phXkiN768+Bt1uP5ulpFslVuqfiMvkD43XuAxQdf5nhTO24NrEJR8Dc9pFk+TZ+AKNlvPFgY+hu9V++dfa5WRHEUzQM1vusAaBghxzD3YxDJwYBgp6JXbVZS7HSPsehAt0weT/iI1hTSkZYFmjUK5Y8INMA1JaafeN4b0Revslht5i8a3rUEq0OchVTuBoj84Ofz5pMapbEFA5YwVV59lx+1WyILo0OK7GX3bqnARxu7aiwTVNfwB0xBIRYvLaxTAnBCxlTSuHqpP6PmOFoF7qq1OWY4Eg3gpr2imDscrsk+W4ec2AkRfE2yRIV+JLnf2oX0nGIozeLhxddPyujI4fcQmGCjbhCJRJ7+UoUrPZA2iHz+tQo2YRUJYE02vnnaMUjHkN9jG5PyhkbpGLByKxxYEi2YAk9gcGUNnrVa71Vq49xvErUnbTnOhqleU3D4WQi5tYAEooWhVLLcR6u0w9SgxHdyuqw3BUZeiQZySNUzbvj9Zha0MpSRGi0GN9KufI+J5p9I33c4eW4sFCPcP0pJIvMG75Mpkcg/685FQ3pYOVp3/Cowpaj9xf5lEEn/OJauwZYJdoehCgR4D8ZMVpKGLTFNlrMs80rOy72IKWUW26af8fh7F0iYvQe8AqXdSRjKcE0xR/QMvZCrTyUHaROjE0xnFppX+S7KRNOaMUk3OD9a58/krJaSl49wDr4ACaQ2Di/dVWDgrpsgN3tOGDf8ZmzT672WRgL8jHemweEINPEGAf9N+Yxxybd1b1x/dHOe0mi4CSLUqezS7+JVFcb/3Q408MWqaBup80PwUrcpkiIXF8Eo
 4X902Ztk
 P74xUITRQd3bW6f4/HOAch6DK8Sezuj5SvbrhkVT73lxF6POybiZmtITYWrJPtlF2QGLNdy8LoJ6kcvqy0R7ppZJu8kMD+iOT8IE6xuRYUXU4Hvxb5Bby1yZFkQ0UTdbHtudhadEWlQoG5S50bji39ObrzulDyn2z4uhbBgC/qjntppFm2yS+X9Zj4v8xunKQPF0+CZjsh7CFLeaRsK5JqCo7uKLV1X+B6xBYOHzwn9lyF+Yt842jwwRcG4WnNaQ3/WiMf47OvTI7LGt/mKYE/yj05mdSIamSe9SkCNVqU32YjUtvMddoL5QRHnq0OU8QPP3TnjoP5AGGR87JIoXwqmI6zkQ32CzkHXDQvzQG9TwWuhR9DuEzNL2HQ06M+VI8jbzs0XGap5LNoK/0OfPouuhDQqnH40f9zkNWGdWkBVGP8BJ0dgCfyxUHECmb7DOyOMK99gG32uaMuRWSf3q325ovvLeQFxqHpZEHtevTGssXqrn4H46bYuRZwJOzsU7TQxkeZDSS0siEFnV75pNs8KqrEFzCLsBEyyenlY8hlCQ0rzBAyBjZzWO77bZQdZLYDahy1j4M/aBUzgpkEtfrDalbKYWAs+pBuiE2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/19/26 9:36 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] docs: ioctl-number: incomplete sequence range for
>   sound/scarlett2.h
> --
> 
> commit 93a4f635ed001735e939a3dc4a2526e8af9e9bd0
> Author: Randy Dunlap <rdunlap@infradead.org>
> 
> docs: ioctl-number: update sound entries
> 
> This commit updates the ioctl-number documentation table with additional
> sound subsystem files and sequence number ranges.
> 
>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> index e1d56d5cccd14..f29d2c17ca7b9 100644
>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> 
> [ ... ]
> 
>> @@ -204,6 +209,9 @@ Code  Seq#    Include File                                             Comments
>>  'S'   80-81  scsi/scsi_ioctl.h                                         conflict!
>>  'S'   82-FF  scsi/scsi.h                                               conflict!
>>  'S'   00-7F  sound/asequencer.h                                        conflict!
>> +'S'   20-52  sound/core/seq/seq_compat.c                               conflict!
>> +'S'   60-63  sound/scarlett2.h                                         conflict!
> 
> [Severity: Low]
> Should the sequence range for sound/scarlett2.h be 60-64?
> include/uapi/sound/scarlett2.h also defines
> SCARLETT2_IOCTL_GET_ERASE_PROGRESS with sequence number 0x64:
> 
> include/uapi/sound/scarlett2.h:
> #define SCARLETT2_IOCTL_GET_ERASE_PROGRESS \
> 	_IOR('S', 0x64, struct scarlett2_flash_segment_erase_progress)

Yes. Fixed now.

-- 
~Randy


