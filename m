Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B08D7606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oNThT0mS
Received: by kanga.kvack.org (Postfix)
	id 674EA6B05CD; Fri, 20 Nov 2026 03:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6263B6B05CE; Fri, 20 Nov 2026 03:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514B36B05CF; Fri, 20 Nov 2026 03:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7F16B05CD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:08:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF1BA1A0DCE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:08:50 +0000 (UTC)
X-FDA: 85454771220.03.DE98EE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B2A2D40007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:08:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=oNThT0mS;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795162129;
	b=QK0Mw8x2Fe6aVI62Gdg4oWVJ5Imv04WYv6Lo5/xmGgv6hRu3z82ZOQoeAyUXty7ceoPFl5
	p8edDesxIGS7cgSSSwrUAZnfjb1S79rMQNkXL4dicU3ejlmidnp2cm62SxpDjs8KTAZAmF
	/VS0pRWgHiXqH+0HQBcACm8uhiRYcV0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhWTtz/XtWf+zHzkg8QT/u7XDoQ0xAQ0UFQlVcaEpd4=;
	b=Yow6AFOvWxBvH53DQlqwjMWj4ERKtVHsALuNYyMNa5KhZ5iti9X5WBiq/Keykb7Wv5Eqzi
	6A2HqG4Bz12MBvyA5LDjOilcRcZzo5RxULau5LxCI5L55QTxDnM5ICYocGAtenCVU9d4d/
	2xZkGwuGYmrKmNduFCQSBc5xvyJY13c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=oNThT0mS;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C81B46936;
	Fri, 20 Nov 2026 08:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042371F000CA;
	Fri, 20 Nov 2026 08:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795162127;
	bh=nhWTtz/XtWf+zHzkg8QT/u7XDoQ0xAQ0UFQlVcaEpd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oNThT0mSGG6kUZAwqZsOB53nYtEkre5+BXqj2CeCW2DezGxoseqckwyiR/VE/H5rV
	 fasb29VNh/hB3PNLtjFkss79IjJ2QxSftm4LCX3QTWO6ojWb5uhH6sv3drEWCZAFZL
	 WHSdRIgt+zBwwz1WhpggeQETXK/uvYvzW9vMcVhg=
Date: Fri, 20 Nov 2026 09:08:23 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-mm@kvack.org,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
	oe-linux-nfc@lists.linux.dev, Chas Williams <3chas3@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	MPT-FusionLinux.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	linux-mtd@lists.infradead.org, Neill Kapron <nkapron@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>, linux-usb@vger.kernel.org,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org, Hans de Goede <hansg@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
	devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	intel-gfx@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org
Subject: Re: [PATCH v2 08/12] docs: ioctl-number: update USB entries
Message-ID: <2026112013-crave-ocean-6117@gregkh>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-9-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119053514.255348-9-rdunlap@infradead.org>
X-Rspam-User:
X-Stat-Signature: q3fpdwix4a5k9pe1kp3yopcogccpjks9
X-Rspamd-Queue-Id: B2A2D40007
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795162128-109341
X-HE-Meta: U2FsdGVkX1/AS6JXnIJnLRvqduN1YWMOY92nxZPKmMgIGHFSBUOola2iflqY+KMJYp4cK7P7Kad4ymOX04VDtrIGpeewyHoHc4NC2RLhhGfFFhz8ojKUWeRZElq73/yr+/Qe/EXc5ZdbyG83cd31Msp7+Wvrr3Z5+fR/9oe5SFT6C/ILHTI/LMLUW3yymr4LHHV8LPomZg3RUloWFFwupHW9FyXGUbgvCEb7zjr11+2yuPlO+/kIiBLU0kl/B3JHr3g3+rA4PqAxVZu2JLeIAA2X5LhmECxEDtLysS0GPe7sOVIQEYo7PbglXTPfL4jhn7HddVyKYRDqiTb91EsWrNVa/CPSWY1QIUy/08W8xXTsxpKgrajKxgqRUtWJCdLRLMpW9AHbm40Pzv0STkBF5K3DulXK0TLOf/J9IeUQo9ChJKs+qaQH3r2zq2ofTNosSb2APLKQ3o4k/gcbABhkGxx0pRb5g56c33gJvGF8Q+aXK9VY9Pmj0Zay3Xk4r9nJqd+VLywRRuIIjs9AQF4XpW4qqVbU+rek3AK3MhWawltCCs0/Gwi4Mhzp+IK2old7/+ss1Dp2wnmbzmxxf4iL+wt4KImEr/NmpvL4xJkEmubK1jmYh5qQ1NaXmR92V3XIgjyb4UePrW0gBOR59VZX+LltkNJKL2O5I7Z8C3h0b4iS2uptpnKm2t3NbyQP+OAy+PZBnIavVw2bXumB7gKg+9ixea7fxfJ/loCZm8WQVZsDIpmt6zOMWsZBGodeXvd2PSX6QUTkNk5x6G2xDuudpTxm4GNKQTQn8JMPcx6cKtvjVadDOv1zkO1+pKjDwkqO2NhXQE5iFtYM/0aAy7e3uByEB7u1W0tPsFxPtPzh9pctNDSA9fPTMsNIZiQoTAdFXKOhHXfzRdW4qqUdV/66LZ3Gob/oeGu3+y1gWqY0wH0Z+9Y8bciNqCzMzX6cKMAuK3cxuJQ5hflhj9mKN/W
 Gsh/8RFk
 ZvYcvZGTF3oBK4PNkwNJcfDk7WKj8SdRKv8RrWAhbiv5f0fj6zWA69aKqdTXcMy5no1a08y74vQUYyuEKS6q0H9To0sa67qyQzEu+9o9Z6xLFB1EmN9yKR1082mZPjqvs5DYSEOc3Md3G1uzyTT2+ng8zdaUWCmzs7nE7YMrKnXittWGZT7ZHxIbYhEmpwdlur0gD4mYGJOB0bV67ZP4IqZaPfD9M8J2bVGCAkH5FRLQl0CVJjb0W7YECE+UlMhASGJEB/4GqFot8t1sL6Bap4SIyEVCZR3dFrhFEjFNPu3Yq/6mMWeKgitwNuSSaFlS+EX/3sCAuLWwG4cTa6v+lFHLs6PClYC1XvDyvNJEwNUdBEC3xjQpnFPOiWhy0x2ShG2qmFPLTZwUdCTt81u0di51P5I6i1Tpg0mGeqBZv8kobKODqa3SMenmoIGevFPgJrv/ryrRMJAMUNdB5k2NEI8NwZ18kO4HUw8dzQCYEQMsow2Mqz9EONN8hHwfwNtlUp/Kr2bB//uguJVa+q69PlnSVYYBAXXDEPlttMQr7EmhSNq0PfYL1cuLWkqW6ViPOejdRZmu4aO3UZufPuKKx+rG5rqz/GfxNJ7dDBJn6edLLi0E7B4DwRl3Nmcibhvie0LDPfPIJTahs9yy9W2ZkcsKvyY47ixncgHTa+KTa7m59J4M3Pkix+WZLWUQ5S5KLCekEYK+P/P5Zm3vJOpAPeOrZqrAM+uv6+yIWhrabAwMkIHDUc0lKuVGpxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:35:09PM -0800, Randy Dunlap wrote:
> Update the list of files where USB ioctls are defined.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> v2: no change
> 
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

