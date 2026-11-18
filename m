Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49622606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=NQX3gFw6
Received: by kanga.kvack.org (Postfix)
	id 6CA4B6B05B8; Tue, 17 Nov 2026 19:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653626B05B9; Tue, 17 Nov 2026 19:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD486B05BA; Tue, 17 Nov 2026 19:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24D156B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:37:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4617A817A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:37:13 +0000 (UTC)
X-FDA: 85446375546.30.214364D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E51E180009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:37:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NQX3gFw6;
	spf=pass (imf16.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794962232;
	b=4g0ESne4pW7JNpeTVgBMSaWfiztcFM4yYuuY/++BGFkxjwphT81bk+q21hVg6wNJvcf8lC
	mNbTHv/Fl6Urb0y04vsxRFmgaudUfSKCdrQvn+Bo7NSl6JPXSAN2IZWERLtHWgn1lbWWGZ
	hg3qMy+LBydCQ2zniqqMiUejcrz5QN4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794962232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmzVWCZFDR+bdD7Tn9ufN+qT1kyy1LCr5wTeQGcedQ0=;
	b=7D9T4ktn0SY42PPe6Nl+70wCPal8Rc8XOaoMN/7Wt1pEYdekD/eee5zlvEKZ+LtPnYJwE4
	tMIpanfdjjva1SsIbs+X9XTVnV30nkt0iBLEJj0JHwk3ns+53faAfQgdTuhxa8lpt2Gn5j
	D5zo99MVnfqBsW0vO2w3g9Pz9/ugLpw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NQX3gFw6;
	spf=pass (imf16.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=OmzVWCZFDR+bdD7Tn9ufN+qT1kyy1LCr5wTeQGcedQ0=; b=NQX3gFw6lRvDGC0yU8UhekA5Oy
	gFdB9ufSeWvr49UuK6RBl0r/Jkg7EEmLVXl49M1vAQmwpt4jPnwuRNUg4fH2h8EUv3+r2bfYBK+Ri
	MT3Sj71fhCK5Z8RJQv8eXlRacZYSd2tlwRiGvmip3eeMgECvucwbd4PYhOLE7fuL7fszrZVo3VcDx
	uwHTgIHvJnpG16raAq2xTMQsZV7oIgTl22DdJMeF27myk9XvpF8A+xd+gJ8H3gUv1qkWU91c745Eb
	48F7QEi5hLKC4O5f3Av2ic/qxUbKL2PeT17YmnVh2Wp8WUYXJQBrqpdMZKVhlAcf+Fied/Kv1sKDo
	dtocPIYg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTTfe-00000007NcH-2Xz4;
	Wed, 18 Nov 2026 00:37:06 +0000
Message-ID: <3fe5214e-5699-4cd6-9d5d-f529e49f4928@infradead.org>
Date: Tue, 17 Nov 2026 16:37:04 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] docs: ioctl-number: update sound entries
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
 <20261114202653.3113381-3-rdunlap@infradead.org>
 <sashiko-outbox-215802@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <sashiko-outbox-215802@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4E51E180009
X-Rspam-User:
X-Stat-Signature: 5desqqn4uo7cn9ozxosa4mz1rhy4zrod
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794962231-703142
X-HE-Meta: U2FsdGVkX19KoLiptslIB05r6OYQFbSCHub2A2Wqd45VbSMht2gVMHfFjaGgIPyNDWTe40NS3yASNWeElmBEz7fgSBVtf1jIPegghb84HpDixaziDNpsOh7anC9Cn8e8arm1bDm2IlBysCn9JrPZLJ1quglylzP2oD+qoa3xqMzRyjv1ZBMnhVdDpjIjcbFk4WfcmIQUkP9ToX3iudYh8gt8cnHBaJv5G6RO2CYvRRQZA+ExmwXfhHvcYKig9/sKuGpR/Ft2kOd9RTJqzke/S8JlIEbo7O8uC9Jyx3VMiYN1VcQ0Q6uYEa7WnObGrX+Bq3eyKcjfTBi6q7sRbCp0Y05t6FQN69uIklawxzRbgx7Mrmi45+uHqfWXYb5KPItPPMLOP3inwl/YLhOuPnOOks4dWkn53LdrR32V5XUDjJjqUqHdoyiBbDcUx08cUmM9h53+HY+saQoX1IOOYNAn2jX3lVEWakfUFaJu8z17V9VLekMkOAmptvpwaNWfPX5Gy12BRJGg8OCG92rQ3xFpq3JIKaCOPoe5jC507Hl52YhvSC6F5Z2fxHJVKn0+a6/RhMl7FpyWHZMcjptKyfpezp22CCEnQXoOulDJ4Mf8TXOYjeGMF1SCjuAAoYmMs0aqWqlCadbJPWzRdepHdpsS72Hx0Qc7nB6DvX8oFk7juu4ptUWSsGaAoxjQT7Ih1NAsPw3LzWvbuCyayLQdEI5JiCBrR7WpC/bwB5U+A+yvjrILmb8YhBHOHhaboYz0T1Zw4rgXSR7MY56GZe/LBoWMnwMHzUdcHXkjrnDYcQRGK0gb+f5XpEJ8qUSNL7qWDNiPRDd/CG448ZX1BvnBywALGRHwzqyErcfNB/j1myNSRMGicD7kky8G6jj+Z4xo19JDiKgqSP4fSpyUe8Dyehu21PViOW2MWp46d22UNklKoK+lB2eBoKCYVhcuHO7cILwpEH3SVa9KmI0Droe919F
 3z5Uhj6C
 +qC//pUAIXKqdKS/Qsp8LjXXdBZ6rUb2/80MDnsALtEjExio6n2QEIY6SdAuFkdUyKXie+p89znXzhF/LduPyjd9NtyNi4e+Cck7JmsRvl+ZBqhMuhMFk+MS6F8h1IFJiHh06XGGagjkGrpGZGmIoEVlnJ9+dJCooosIURYXmSbgMdxx4UkbGjDLrtFiC+mdCxkfgcJluBYSLiRnXtsZHrWfNsvDebvLWDg/dGl8Bd/1+VvdeaQ63LUp6/7ALdF9SYFDOzF8qtqDdMWXbBY0rK1cJZtzqnAETwAqqBJP+bw1ytC/QJTbEf80zYTZGRPkbz5BSAvEf6wpy/7TqciBgMIpcnU1LAHz9u4NbT/39KiqgxVZFy1kgDkthNYzSWsv0uvL+GiZvD8vir0/dZ46674TdCXDwQ8kG9di2V16dcZHu9ScRcrh7VLfl2uuxFXHQc3i02abmnPxD/TYfgDwpwbPo4+MweTQHAGePx+IV0JiTRLcOY79WzGq9xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/26 12:27 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential
> issues to consider:
> - [Low] docs: ioctl-number: wrong code, range, and conflict marker for
>   scarlett2.h
> - [Low] docs: ioctl-number: incomplete sequence range for sound/pcm.h
> - [Low] docs: ioctl-number: incomplete range and tab char for
>   sound/core/pcm_compat.c
> - [Low] docs: ioctl-number: incomplete sequence range for
>   sound/core/seq/seq_compat.c
> - [Low] docs: ioctl-number: missing conflict! marker on switchtec.c
>   under code 'W'
> --

All review comments correct & fixed.

-- 
~Randy


