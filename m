Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6D3606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Au1x/Qfi
Received: by kanga.kvack.org (Postfix)
	id 7BE9A6B0A71; Wed, 25 Nov 2026 11:20:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F746B0A73; Wed, 25 Nov 2026 11:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E906B0A74; Wed, 25 Nov 2026 11:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEF26B0A71
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:20:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C684040FE1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:20:51 +0000 (UTC)
X-FDA: 85474155102.09.B687424
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 22B1012000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:20:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b="Au1x/Qfi";
	dmarc=pass (policy=quarantine) header.from=manguebit.org;
	spf=pass (imf29.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795623650;
	b=t5ZaAKvB0QN6EF6xJF5gLVM+V2B4eT53u4VQWRlf6XzvwgS8DzLX4eEHcD/vXSoFkyjBDi
	HBmco16cj4eTWBe6MwXY84k3ZmzsH07IH/YIZ0Bu7ftKqYqDQhYkWud8R81e9b1xTb4Q/i
	zpmIqZ9VQjt1ZmPB6QMQ5MS7Vfq92gc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795623650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFjp1Epxvbzt1A9g4t7Y/jDE3CxQAavGU4RMdlNgNPA=;
	b=7PnwfpSzlU8904ye1g/a0eQhkRRkydvPc6kPl3cuWllMlVhqkXru/3X8y+cNcd/dQVsv7V
	bHRo1YPgeAvUaHewD9dEc2+5SEBwAFaC8+vn9BjbB6Ep6JNpNxIYdHiZuzOZcYnq0wrHi3
	niks7HbpS+9Hc9ClyEXHBmWjM8VLN28=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b="Au1x/Qfi";
	dmarc=pass (policy=quarantine) header.from=manguebit.org;
	spf=pass (imf29.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MFjp1Epxvbzt1A9g4t7Y/jDE3CxQAavGU4RMdlNgNPA=; b=Au1x/Qfixdt8Oeg5ELWQmTzZ7d
	wr1MiZso849kQQI90RjKYgtWlHvOsL4sUODQa+yJU/QJtei3+nwrCl8XPzyxSYVWxD0jEkv9ZHfHG
	OmNUZEcDaNBk4Nn1E9cP7BuRGcZNEM6J6xtS4Ket7/m79g97o7hU8kn2wKyFBLeu8gwPpXcQdviQ+
	Hln2JCas14QUSmhfJsWIjqhstDco/PUWJlhmY/+248fQXkeCIGO5O9nEwcb7Q1W2v+0HrcyzdyrIT
	XwITUgiGSX5J7ehQY0B1lclNs46kSXv1DsiPlzDA2AP0RSCXykcJrKqmOyVKoOLO8j21CyIPiZYaT
	T4+/q8fw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWFjN-00000000vNZ-3XTu;
	Wed, 25 Nov 2026 13:20:25 -0300
Message-ID: <9afd33b0951849b9a48c5a0783d76fde@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, David
 Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 linux-mm@kvack.org, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, linux-sound@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, linux-block@vger.kernel.org, Marcel Holtmann
 <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 linux-bluetooth@vger.kernel.org, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowangio@gmail.com>,
 David Heidelberg <david@ixit.cz>, oe-linux-nfc@lists.linux.dev, Chas
 Williams <3chas3@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, Miquel Raynal
 <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, Vignesh
 Raghavendra <vigneshr@ti.com>, Zhihao Cheng <chengzhihao1@huawei.com>,
 linux-mtd@lists.infradead.org, Neill Kapron <nkapron@google.com>, Andrey
 Konovalov <andreyknvl@gmail.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 xen-devel@lists.xenproject.org, Hans de Goede <hansg@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>, Eugenio
 =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Sean Christopherson
 <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 devel@lists.orangefs.org, Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
 <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, Florian
 Fainelli <florian.fainelli@broadcom.com>, Broadcom internal kernel review
 list <bcm-kernel-feedback-list@broadcom.com>, Tzung-Bi Shih
 <tzungbi@kernel.org>, Benson Leung <bleung@chromium.org>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?utf-8?Q?K=C3=B6nig?=
 <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 intel-gfx@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Subject: Re: [PATCH v2 10/12] docs: ioctl-number: update FS entries
In-Reply-To: <20261119053514.255348-11-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-11-rdunlap@infradead.org>
Date: Wed, 25 Nov 2026 13:20:25 -0300
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Stat-Signature: us54dts5xwihruemftgebqtsbpecahe6
X-Rspamd-Queue-Id: 22B1012000E
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795623649-855782
X-HE-Meta: U2FsdGVkX1+Xw68DNBeudfH3XYw0gUHssl22BmlIY85XUSBsSOPZZvX2okHDFDL+QNdkB/jou9kYOOLw9lwryX3WHSnn8R1TkKgY/Ww2h09XOZhocuNDfwriB2jDTiFB7yEKgzulMiv1TpmLvGnJBisFFXO4yhtjRJLrJ2jBeJ1V2X2meYJEsqvi8SFgLp9A21D6doXhg2zfxReWKHkqn9Fs9uL9773CVEWP4kKS27TqJTqCULmSjurW71GTWBCj3ZVnHt1KZAc8fskFvKao/U7w/RMCbajDVDuaaxy9veZJuWh+jzyYoMotxIhzIrNcjvQ1URYS6/0YXeZwvvUUTBIlGrdO3A8SeTEOCdtxHjZce73HYx9vLIVIjw2ucb4rNtBA7WVePkNLdRIiVcAOCfs571L7SDLSHeSjNK5FoZzHKNZnhrSHIlc6AZJXwe/bXMcTkpUcWoiJ1BniMEOUg+fXPbVXGFwAULslXmGdSJTwgJNgKgRk51BcXG8f7vCtgncVSl8k8TLYFK85aVNt8FcZdyRnKDpg4D4a+6OEvM3QKCiCefZxaZM+dOtHn7Chwv9CCvfnFCaMJNSPnfcuUP2kkfm3Khhlthdy4L9fG/RHM0Zp/1Eiv87LGwIVkhZpgE/GuTfUX+hoBHWiea+Vrzh6JJaussSOVkY1E6c2UnqAwOrcDMv2DI1EPbqq0RuYsIlR+NMAQZS4R9pNvn6pt9KC3G+Uc0ZlQNKXcr6RKn0eRVnj8+2/461kwiOhHMBJdEPcQ7L+q893sVTnZbRCTPOjumzZtoPvcI+6UfH4nNjWbebURxQEapzQSnRI3s40XY1lRVipdsFRO1UBY+G31GlTSFCwpXs4sd7ZjfIujUgknaamImskdWjjqyLkoyJmB/D8jCXfMF5FfP9DnIQ75Rs7/iwYGpqRVEtkFlrNJFTcHf2kqTphYRSi+UKAc1kW2Cx6wiTgr+7WRDLJKm/
 d8ddYO2J
 HSWFNVo2aBY0XMUMPUqx7+1IRAyy+ihhpB2Fo0eaEUVVGw9Gx2LP8jWjoogIEqcIeCPnp8X3P+bnyWaxNO1DIjHZjCUgXnUUT4n25gcFSRVy6o2HXj+TwAbymW3SS+rKmamJ4iytsl/7Y3Lj7U62Jhd18Yqwt9TnUupWsu9y+h0EsWs+AcxqQbkw2NAP89SrkGadiZPoPZcwD0eFTR6JHmEN4/weIo+WZ06FxuVNRFFw0V3jP5asdfbHky+aoYBc1BgT46XwWKWVNfnvEDTXrivrOJZZWO/R49nIx0exPxjd5dE0Gu++N00wKo7pxq1kfPJ25Zb/BoY3xApvOlZDAkynaA4jDAZGa5UH5SOhf61TpdlKdyoQdr5B6HziOs5Xhl65aUQ898qXWHP3xDpVeaZ4ImLyybsPWHYxrwVVvfz7Qc4Xyj3nnsqLq0ghuaTibsKuJiny94CGQ5YIe7ITk0ItiiG3F2S7tL8+pnRJaBN4VkP3jjmHivfRXfkKzlb+1qI4FWsEOOs5jzJPe0ScDbfoVkjgYxY/i2ZReILaetV5UAxcQ1VkrWiLO7tPKx6HSxDyey5xhw1iRL+k/8tTtb9yahA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Randy Dunlap <rdunlap@infradead.org> writes:

> Update the list of files where filesystem ioctls are defined and update
> the ranges of function numbers that are used.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> v2: address sashiko review comment (ext4 00-2F range referred to
>     the wrong file name)

Reviewed-by: Paulo Alcantara <pc@manguebit.org>

