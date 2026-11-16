Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D611606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 00:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Ov44YrtP
Received: by kanga.kvack.org (Postfix)
	id D20CB6B00EF; Sun, 15 Nov 2026 19:45:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0C46B05B0; Sun, 15 Nov 2026 19:45:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98DD6B05B1; Sun, 15 Nov 2026 19:45:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85A406B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:45:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC61280820
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:45:20 +0000 (UTC)
X-FDA: 85439138400.17.2E70567
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5177640006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:45:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ov44YrtP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794789919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEPXf1cG5J+Lghgn3UQeDfptX1Hk+zVJPSj0Zk2IzFQ=;
	b=rRD6wS7D72dQKzvEs3GlZDbsCGp9uUmfa35yRZ9yK50oI5zURNdZYzaISTuIy3p0j8qa8d
	/w14L/WAhT4PRAwHpWt89juDVJF9oUZeMNpwhAFUqCyaGyNKwBQux3+xRjGoTxTdDbyoaQ
	KNBAFd5glY7MOV6as55XOPjGLwWGOI0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794789919;
	b=i9V+X8B0aNPARyM/U6L+uhaRiSreTatZK+AMzhqnOR4RMipoG/K9d0HY+ISK98cWCPwE8E
	RkkL5V4Llit+LOIKwiHmPwNBo7Bn/HhvjUEMqVbhzFhYIVFRsKqlXJ63wUgb7h2Y+e3agj
	+YTJ9HjGtuaI/5EEI801k5HxA5Cz4eM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ov44YrtP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=nEPXf1cG5J+Lghgn3UQeDfptX1Hk+zVJPSj0Zk2IzFQ=; b=Ov44YrtPxUC++hYRNDHSdmdpGW
	JaxLbFR1NnGayLi7FHLtyTi+He4ZYSfoC7yWmGobJ7E/AIaLAiwDiqmK+og7vdQvnP4EzvIpr462x
	EDmrhZM3u/N2SWbcqZV+o7jR7R+AN7ZLDYmWxP5FpNx3G+I1qCrQflyake80HiJ9rMKVM/x4eT782
	9JEn4jhTrQPKUH9n7ugwPApkYe7cQrElzRWPUKP8gRVT9cQSw9rpPJq9AX3iS6GqmzfQn0wqcsM7f
	leTLxbzdojuK+f/LSdN/KzQKSZ97Y6xYotP0eKRTTUizqT5t8J7W/n/cd6b1FIlVQIvCGZw4VHm9P
	KD0dlVWg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSkqM-00000000pP7-2dPd;
	Mon, 16 Nov 2026 00:45:10 +0000
Message-ID: <bbdb3140-dc5f-4ae1-a5a9-c2e25387409a@infradead.org>
Date: Sun, 15 Nov 2026 16:45:07 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] docs: ioctl-number: update MM entries
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 linux-mm@kvack.org, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>, linux-sound@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 linux-bluetooth@vger.kernel.org,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
 oe-linux-nfc@lists.linux.dev, Chas Williams <3chas3@gmail.com>,
 linux-atm-general@lists.sourceforge.net,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 MPT-FusionLinux.pdl@broadcom.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org,
 Neill Kapron <nkapron@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Hans de Goede <hansg@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 Tzung-Bi Shih <tzungbi@kernel.org>, Benson Leung <bleung@chromium.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, intel-gfx@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-2-rdunlap@infradead.org>
 <f37ccd71-8e1d-4dd4-b11a-e22b9e617dea@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <f37ccd71-8e1d-4dd4-b11a-e22b9e617dea@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zrks9ncuz7p5h46bpar7fr87xtyghkrh
X-Rspam-User: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5177640006
X-HE-Tag: 1794789918-507497
X-HE-Meta: U2FsdGVkX1/rRArntia4tFWH1KW5Re+ahVjBi/o5r8Pm5L1Opq0hgzmJJZfuDvWYLMfrShQH3LRJf1ODz45r6HxgP2Dc7/4PuADux8K8oYtehXufnX7pxr7yLZYYhcy8r/F4iTBocodgcmFnSH8cbXh52EsDKLMGTThMTuPxyd1o6thf4o7u8MSdnhawF3r+J51mi6zUlBYfTxZar92vMbQlwGYe8+0syJy7yc7kQolWxWx2kwTW+dk/InwkbDXtPr4g2BzVk3kaJmgoc13Qizn5FPW/3vmUbFS3i9pjWY51o3etcvZWxzU/Br0Mx8eCBojccUcoaSQhHylnuh5vIyBLJJIKbV3aS+oSXjlUWLatU2XTh7rrIY/pwoY26BP1aBMX8XZuHis8FGa/7GUb3cikvohf4JIJFptGnzqjCfisfiEErgVwJy5+pRxenRS8liiMKHYLNXNkXU8sjUbjmY2DHm3E7T1kIBk8IEHwpQoyzACOdCkH3dAQ3CvPNRaMlhIrjNh1z4pK9TwR3Ofa95E4xxILSsXMQbJs6mN2Y9RC9Frck7tKljDp2P2bGatPep77/Htw3M366WC/t+YWpqcQcy8JI329u1FbW6WqH69vYPmhLEzDa3z3ypULT+1PVDhuWmgYJ1ETe372zIjF6JdnWHS5BfblPJmMcOVgzkOvcXeOzai1EDkaFOSLJfCY/Xy79PiMa0VA9T8O+TKODWht0Hpv6SU6X/iqv8m5zbtXWwl2OpF/kNj2aK8hzPD1bqtp7ezBcZoSCyZCqOhGD2VoRqJfGthhjQSmAYfImn3laJj4WDhSHdHvdy+o6qnVir18kdnqY1hiw18u8qxS+CTpLvZT6IbxwFWQHBieDHIhuG4PYokICBMEoRSC5ajh6iTAoWYl+/xqfEuSnRoYceRW3NEJA1r1ZnyzCHKPlmoJRu+EQz/PBQhkAL1uxPrx/IU2NMwosfnZnBu4m7U
 kXJVTUvB
 FMNAKDKRYbYJAShQq3A9tbbWbM0bGxcDPsymc1UQVLSbZQlqc5oKHv1YwPXsd1C/tRicQMB+cYo2JwgYs/JZKAKexzTJnDsIBmmtEZnPwCR4yR8NIfBx9SKcNgmkJEeCkzG3pFy5mIwH2+Jjh+u6g9NJtYvNoOv0qKf0kf0WX0Khoie+O8CSzHqEQ3LmWOqgzRe8FjoaenGXnqXTVPn7RznVnoS3wMxRLAACyQt0iO8yEjt95fnv5WHFPd+cb5lw9rNRfkTrDP2juPDdx3k7ypyEJpFnaG1V5ft9+/gNWJSRTMUCgjUihGREYFCm0T88JkdenKzuenxFmBJ+JE2bKDlI0hS+BW6Mf9t9JpWhuGXZgn+9/gxoXPiz9bAXGoYyV9Drh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/26 8:58 AM, David Hildenbrand (Arm) wrote:
> On 11/14/26 21:26, Randy Dunlap wrote:
>> Add ioctl number entries for test_hmm_uapi and gup_test.
> 
> Just curious, why do we care about uapi for test interfaces that never see the
> light of day in production kernels and their sole purpose is to go a long a
> dedicated selftest?

a. We don't control who builds/runs these tests.
b. There might be some USB gadget or HID driver running at the same time
   as these tests.
c. It's preferable not to have conflicts, so any additions to this file
   should try to avoid these documented ioctls.

-- 
~Randy


