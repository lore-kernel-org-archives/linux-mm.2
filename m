Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE3C606A884
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=igCqbrdM
Received: by kanga.kvack.org (Postfix)
	id 7E5F86B00EF; Tue, 17 Nov 2026 19:42:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD186B05B0; Tue, 17 Nov 2026 19:42:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA4D6B05B1; Tue, 17 Nov 2026 19:42:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43C156B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:42:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A948CA8218
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:42:49 +0000 (UTC)
X-FDA: 85446389658.24.52EC15D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id ACC0214000C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:42:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=igCqbrdM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794962567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkGYeIrryqDq+inQbLWkmmEr1dkiBjnSvcr/8PVZk+Y=;
	b=YmCK8COx2a5A2Ht4XHN02DpMPsS4I8gRAfKlZXLRQSu/c/0w8MSkkoDEed3RWM3sI9gpED
	1kMAPQaYa0UPXZXbB16SOiT6JdkkGeyYhQ+XiJdCf7rj06DbyPfit3+klPna8HYXrP7OQ4
	umoFfF95cTMMoCoXkkuN87de2dOsq74=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=igCqbrdM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794962567;
	b=pIqS7B0oxN2A9GRAWpftl1sC2lyPF8zH2JlcWhMTegQmkBRhJK1QphTtLtXC7pPsNyGKcf
	fLBzm7MhkTvmpCYZLCh52oW5cn/k46t03TJ6Vjqivk5ND2CboIB1Mco1UdIiwyfjWPbBZm
	VQsLCEqrhDaGBZkG9GX/yvJvsn+Wn90=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=ZkGYeIrryqDq+inQbLWkmmEr1dkiBjnSvcr/8PVZk+Y=; b=igCqbrdMvYdH2Ll7yuVQgiWBLt
	/GjOlBhkNv3Atf058oFTC35r7J1y0Dn+izVMR4B7NTJEgzYPHyNBT/yjDLM3vKgbn4EFnLL1HvfM2
	G8HTUE2iRUo+Ako4z/l/tGbDtgdpSVnn3+sjWev4F279cv0k0FF8It0l+2omvAOvX90nrKkVMHldR
	y4SubNJLjheuSGQXijcB5uH5+COAZ+CInyJl5sc9OV63iS8Y4FJBagg/Ml+jigC5FfWN8akPbdtOp
	IW55/TtVzpAhYfHqN4Q+3n+P1FyoIpvl7F9FFouhH/iKFh+WdtjvK3wQHam39CoLFXiHmYbfepuXX
	RGWrdOyg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTTks-00000007Onb-3pzj;
	Wed, 18 Nov 2026 00:42:30 +0000
Message-ID: <8d287ebe-56cd-4429-89c7-d89c295efeca@infradead.org>
Date: Tue, 17 Nov 2026 16:42:28 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] docs: ioctl-number: update networking entries
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
 <20261114202653.3113381-5-rdunlap@infradead.org>
 <sashiko-outbox-215804@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <sashiko-outbox-215804@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ACC0214000C
X-Stat-Signature: ar36wcxk833w1xqpeeeztrtq5e4oc4j4
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794962567-58993
X-HE-Meta: U2FsdGVkX1+WVPJ16MXJGvcbdD18vJyhPtOJ93Dd2ZgYjaauErU82EdQta2fjjvRVXJisBev632o9gM6k9lE5XlVXOhy16wICpWs078YkeDX7yQRW97MAMxNxs7mXsdn1tKKcX8aN12tnZRPYVVRBxaJNEoCLLHdwhXLS/t9Q/DxCFMrg0+JTq924lPEl0g4yR5GCyY+yxfkItfjwv3NFk0Qwd5d6I+7bXBUGTTPVGUzmUlQq4uYskwE90FSxOhtJdMrCKnVrvW4kygnKHxOLx/G9XPSz8jQXbPqaU3xoVOiyK8jTyfrR42V16RPAcdO54whstyKLdXhwn2M/KuGhKNppEKNIARbzrMyiTAwHPkwzyeQyFXalSVysgwJ6H1E3g08e+y2T3RTPfwyUIAoz6NwGtUgm6EISx1MSn+7z6AoKoIZxBzRJ/O5AhSdFGABS620UCrfE15zXUCmi+jmw6Z2bXokE8rG336frN2glwXSMK5inZlJhc4l6G5Qo+gpZSJp29VjZrkTRNwN6+RMZfSr1E22M1QQuOrhap51/bv7wu6OCUr12p/XjZ1/O3TEKM2VIJrs2MbUH45YKuP2AcsE708YvzWfbUQHMU2I3XO9v/20zRzFxVJqzxv2aQiWBnbELUX4J7BaqcUZYsqJ5LnABQ/espXHLwA3eY6mJlHHbnDSgJRSAlACfe1omDHAGbrHdJV122pJHX5xxQ11QyaSNwLzukw8TgL4xfGRy4TpjzxVnJUgEtxVXJxlQOnUw5NbA8Okr5os2gvonsgpp6Gq2tT629jv6hgIYujvJ1v8r9fYexV+ySCx5+W0KobGihOd7cV/YhTwHp59NcYR2l3UeXBGYhJnZftC6WdQPGCAAUT02Y5Qakkw6+Ys1qAN0NVvxJOq2hy63Rc/lhdR5+5mnmkFtr3j5oP3+YuAgLaCSnE6AluwiqAwlRieoZnK7aLwFXfnl8KfJP64Jza
 7DS75Pi5
 ETMJSL1BdANbg0sOFfafkqo3P4aJ76/be4F6J1UX14ou29F3oe3Ey0x4JomUTno7BghLPjFPx4UZ5vh9hpFbvV6ewVdnQsyW6xsDCY3cP2xj8plr8R3LRmj3og+oT6AeqKIk5AxQpOq6wkZnZHD/PjiJwRzMr85F1Xy6/g+Bk3S7ZO1DxEvHt5PUKvEime69zu6w9Qb960f8bUJhLxhuNfEr0S44TvVVacfvi2d3hcU8E9G5bdcaJqPuPMJ6LKCPjYwQcNDyKHwFiFjqLodMVYTqX8ccgpBdTL7G1KgGd+KpOqoUPUo6hELZ/ktZVmh0z89k7EXe1dILWJ9LnZ+tYs3O7RoR48oYkQxtx5tYpP9Fs/FeVTnJCwnDFG4zyceWrssfAzVpiVZJSfKiOHqUVdCXCrNj80GmlYxqFgmqjeIRSchz22yUJn94eaBzuclNoA+xD
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
> - [Low] docs: ioctl-number: duplicate bnep.h entry and missing conflict
>   marker
> --
> 
> commit acf95c4d46bf87ab8fab382911993f6e83864afc
> Author: Randy Dunlap <rdunlap@infradead.org>
> 
> docs: ioctl-number: update networking entries
> 
> This commit updates the networking ioctl file paths and function number
> ranges in Documentation/userspace-api/ioctl/ioctl-number.rst.
> 
>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> index 2b2d3fd317158..cd4f0bf6db66a 100644
>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> @@ -132,6 +132,7 @@ Code  Seq#    Include File                                             Comments
>>  'B'   00-0F  include/linux/pmu.h                                       conflict!
>>  'B'   C0-FF  advanced bbus                                             <mailto:maassen@uni-freiburg.de>
>>  'B'   00-0F  xen/xenbus_dev.h                                          conflict!
>> +'B'   C8-D4  net/bluetooth/bnep/bnep.h                                 <mailto:linux-bluetooth@vger.kernel.org>
>>  'C'   all    linux/soundcard.h                                         conflict!
>>  'C'   00-68  sound/compress_offload.h                                  conflict!
>>  'C'   01-2F  linux/capi.h                                              conflict!
>> @@ -173,7 +174,7 @@ Code  Seq#    Include File                                             Comments
>>  'H'   FC     sound/pci/asihpi/hpios.h                                  conflict!
>>  'H'   00-0F  uapi/misc/habanalabs.h                                    conflict!
>>  'H'   A0     uapi/linux/usb/cdc-wdm.h
>> -'H'   C0-F0  net/bluetooth/hci.h                                       conflict!
>> +'H'   C0-F0  net/bluetooth/hci_sock.h                                  conflict!
>>  'H'   C0-DF  net/bluetooth/hidp/hidp.h                                 conflict!
>>  'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 conflict!
>>  'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 conflict!
> 
> [Severity: Low]
> Should the 'H' C0-DF entry for net/bluetooth/bnep/bnep.h be removed now
> that 'B' C8-D4 is added, and should the 'B' C0-FF and 'B' C8-D4 entries
> be marked with conflict!?
> 
> net/bluetooth/bnep/bnep.h only defines 'B' ioctls (BNEPCONNADD through
> BNEPGETSUPPFEAT, 200-212) and none with code 'H', while 'B' C8-D4
> overlaps with the 'B' C0-FF range for advanced bbus.

All done (whatever advanced bbus is).

-- 
~Randy


