Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FFF606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=YiH3SH7m
Received: by kanga.kvack.org (Postfix)
	id 751296B05B1; Tue, 17 Nov 2026 19:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9276B05B2; Tue, 17 Nov 2026 19:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CAA6B05B3; Tue, 17 Nov 2026 19:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 368FD6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:45:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B87471405A3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:45:22 +0000 (UTC)
X-FDA: 85446396084.28.CB97BE5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id CF2641C0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:45:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YiH3SH7m;
	spf=pass (imf18.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794962721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pp+O9nVlY7Dd0pOoy4hVzFxCRF9cebkPW+ntWvA2M+c=;
	b=SSXmNsZoVbHYrcVmL0uRep4Vb3JlelQG3UDfslWuljvhSTn3rSzoXa0HzAgcSSfyz/l8OU
	rRozhC2lYoXYxvFUFKJxsvlyfzdG2uh/+1aQgHNM4jzlkELHba9sLlWF1g6w1FfoM9zWVq
	fJcNCaNiCSFdMfydDv+/VvoOlBSQHrM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794962721;
	b=eTnpXzaUobMNTh++SMBzuCMeVuIdldCGJ3rXvVuTiy6B+nqpt3p11Jbet+izhcz+DuHXix
	9NKMygMBjjdORp0CVBSUf6SV2nuIsT9sJB6p+1Y+EwM1L1qLqsWSOND28R9QUcArmTmKwr
	//jFu3vdrqnwqV0Zwlo65SzkBZyBAhI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YiH3SH7m;
	spf=pass (imf18.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=pp+O9nVlY7Dd0pOoy4hVzFxCRF9cebkPW+ntWvA2M+c=; b=YiH3SH7mZh5azRjC5DVpuglYwP
	/iKE255VuIjZF8p8SUpvd+bDJi2Cbn9khM0+oh9gBkflB2X1NqwyWI7MDuZCtzN/EUiOf9ycfFb2z
	5xa6Y6leZvRCTkpPvaCO2gAGzMEnY4iuX5rAZ5iVP5TcNu5h/eq5W7oTx3KIxOrav0Swq70hRxUww
	y1dSP7oBViduGAbqBSvX6ZAkCQE6JbkGp30JRe2cikCtYqkgQ8BLnVrSXlZE7LQBsJoAZW/4cfak7
	oYHI3MtzPU5sXcifFGxWnjUZXedMZZXxQU/inZtKP1oiBda9awbGV712RoGVaCj9n6uY6jnuLXdvs
	CesOVeHw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTTna-00000007Ovq-2LYg;
	Wed, 18 Nov 2026 00:45:18 +0000
Message-ID: <2566e84f-314c-49a7-b342-0d0880aa8416@infradead.org>
Date: Tue, 17 Nov 2026 16:45:16 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] docs: ioctl-number: update MTD entries
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
 <20261114202653.3113381-8-rdunlap@infradead.org>
 <sashiko-outbox-215807@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <sashiko-outbox-215807@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF2641C0003
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qwgf4eqsgskbq7r39fzqwy87hbbrkzzz
X-HE-Tag: 1794962720-303354
X-HE-Meta: U2FsdGVkX1/i4tRRAvuirLWO0QSbOYXVgtOwBueckuwLnpYItlkK9nd3N8GMMWTlywnasLWZDkjWlaQc5Dk+jQA77BIjHnB/p+sFzcjlEwMd0qXu6vSO8YKiIa5b8uwUPye/iT8AV8IAN9GlsC4ZVwZBLhpBx398UF8K/QpZ4eaHVTY7Yeqs+ev86I8Wp2QVoSLXa2xG/J5C1XvKcdeIFiJhs/HaXpl/zlzEWz2sC+7rUmacs4GAP2GBe+gNbBoZjG0FLPUKLSJFd8+m+uik9uPwyTDUSXlaRkb1ckLQWieqAdzAHzDV2cJdtTNVYi5daOLp2xRKpPWdMffX2z+vcaB2Gqs2TLu4CIQmeFDzrn05nWkkFF3sO8iKjrG//3hDOd8viZU0EVY8RatcgLtG3uVJXgiAEmS1XS4oC6g/lhzPuhKF7ZZv6LNHnri8hKMfWELvxGdK7u1OkLMHMfoaQMWimyXH9i8myPgAO9DjZT1OuOh8Ne+CXu1630yRXg+wDW49W7VscxJhuBlt7kDNF5Yt7PmsCaCxX/MzWsss3dX9MYRwqy46FuCJXC74EsmFEN7jlee0KT/NFu7dCJ4LBEGeGT2SmWHDRrXDdPf3+pPxB6KnLWHznDGwG59OoQrY4RkhpOw5710CBtEIEwTl68FbRr1PzyD9pL98BFes837ynNiH6wDbH+zdE8d+4DizB0p4Z7YL/luvZVYI54GjmgwdDs9OyVq74OSQjmgRIiRekgkb1RQtVO8Sy2fnVVtKtPrnAoOa0QBxPk6TRl+OxijklAkjiyAgSKze/nACkjBMmM+mqbmUt5gkL3P7RzUlOy+xz6p3xn6YbwRHNb663DcOdkMnxty0si5vmdpXFoI4IivauZaGdA6r9RkE6GBAiH5pbUs/1fpu7zKYr0KQ+G77klcrB8F+nytoiTCCvBlsqSYYgVEzcz8nEXEozd1PY0DtHrf9wHXpVcdznGZ
 Oe0UcO0u
 DiAlCm9kptr0US8ixPGfwDnl/X4I8JHYrFoQHXcjxHj83xkYhsU4exHCbbZw4MAt43j2eauM8neZ8+JGVBz4DTSj2Zm36uRMoNNqkO+VsBbGInDN2uAE7gONaU58wZ5zQAOVRezOLDpsHtLZM2NqN7TOwJWLIOg1H3LP+BQlOL4Ms8cinilnCJ5fD7wSWmsg+e7n7GU5XuaNX3WNDF04kncY6NvGbm6gs1lGFqFN3sYrnIdTx1H+XIaSdvmFF6qzPDC0opsu7aS3H2uJBf3inTrOtnTZ+uESJdVjrz+bPyuRpp5+SIyvtc17zWVDmDMmPyu96V8K4UNfi2VvByeARou4tpkjH+gPzNRZVt3FKMdD1lAX5TGrEiZuovo+ggpyCkeGC+14AO1Aw5LbRFsXPFEFQnu90uYOyvgkLOb9oVMiqM6cxEKs5fmt0kBsQidJ5hr01
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
> - [Low] docs: ioctl-number: missing update of 'O' range for
>   mtd/ubi-user.h to 00-08
> --
> 
> commit ccf1b77b46484d55fbc7ee02d93a71ebab16f010
> Author: Randy Dunlap <rdunlap@infradead.org>
> 
> docs: ioctl-number: update MTD entries
> 
> This commit updates the sequence number ranges and file entries for MTD
> and UBI ioctls in Documentation/userspace-api/ioctl/ioctl-number.rst.
> 
>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> index d47f817335666..1ff4fd4bf9b5c 100644
>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> 
> [ ... ]
> 
>> @@ -306,7 +306,7 @@ Code  Seq#    Include File                                             Comments
>>  'n'   E0-FF  linux/matroxfb.h                                          matroxfb
>>  'n'   F8-FA  video/sisfb.h                                             sisfb
>>  'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       OCFS2
>> -'o'   00-03  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlaps)
>> +'o'   00-06  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlap)
> 
> [Severity: Low]
> Should the 'O' entry for mtd/ubi-user.h also be updated from 00-06 to
> 00-08?  include/uapi/mtd/ubi-user.h defines UBI_VOL_IOC_MAGIC ('O')
> ioctls up to 8 (UBI_IOCVOLCRBLK at 7 and UBI_IOCVOLRMBLK at 8).

Done.

-- 
~Randy


