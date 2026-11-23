Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956E7606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5brb9u8
Received: by kanga.kvack.org (Postfix)
	id 766D56B05B1; Sun, 22 Nov 2026 20:14:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717F56B05B2; Sun, 22 Nov 2026 20:14:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF9A6B05B3; Sun, 22 Nov 2026 20:14:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9376B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:14:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C7E61A05FA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:14:16 +0000 (UTC)
X-FDA: 85464612912.24.6F98F4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DBBB1A000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:14:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5brb9u8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of tzungbi@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tzungbi@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795396455;
	b=NLXjcbFe+0sFLz18smwfc293hOxV4T7B0/EzIJQJNXhAmsGfLvWSDy20kCNvMa4KPGHuZ+
	02V+ByrmM0yNKVQAtBpVB3TO2EW5kk/cdQ7/BOWmw/9bEk/pkA/+yT23Ra046IMsdfiR2l
	z2O2lJkRBvkO4L51BXmT7ybV5zmvA4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795396455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nAFz1rE2Zgq0kT2UJ5pKEhQqcU8lxqQXw2MrFx+Nfc=;
	b=oaPVarl3ed4LCCZywuwKrC56G/AvycccesXVefumxQ4d8+bNLxLBdhpkHKKocvOlZ80W8c
	Gk4c3z44RGkNIRlJljpHgHlmwjaC923AcZJZSW8gWAfVpfpCpW4c5KRWXLOEubJzx19t8/
	KilgYwancfBxE98rK+4S9jIypIoQBiU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5brb9u8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of tzungbi@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tzungbi@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A90CD411F0;
	Mon, 23 Nov 2026 01:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C351F000C0;
	Mon, 23 Nov 2026 01:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795396453;
	bh=1nAFz1rE2Zgq0kT2UJ5pKEhQqcU8lxqQXw2MrFx+Nfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m5brb9u8foWKbi7SrlcdW6nE2yWIS8IEGVU5QHSZYMih+9IEkmiqaNM0lLx2EYbPE
	 Ene3Ka2hJ1BAvW2vOWqYEoxo49rMX/8KuHKgTHWJQeFE3NrlIrAf3xeYL6VLmMY+/l
	 ekFXnTI29+zSfV1Cj1JiY8g0iM3LpoM2wMrgHM/4k71UbfvjD94MuJKD4cUZLqKZBp
	 tapIlLzsw5cg25rKFRJ3Wy6OzHRx9WFNJ4Dy/E+S8IHUzJbf1ziPCMSD/LFgujVS+y
	 I6gkNfNt8+7zFmlY0xlcmT0RV+dcWLazJhMGzWNLJfBLUPxJ9MdE0Cw4N9AumibzJ+
	 +Zbi9zcgZuE0w==
Date: Mon, 23 Nov 2026 01:13:59 +0000
From: Tzung-Bi Shih <tzungbi@kernel.org>
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
	Andrey Konovalov <andreyknvl@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Juergen Gross <jgross@suse.com>,
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
Subject: Re: [PATCH v2 11/12] docs: ioctl-number: update platform entries
Message-ID: <awOTV4kbshpi_cxp@google.com>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-12-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119053514.255348-12-rdunlap@infradead.org>
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DBBB1A000B
X-Stat-Signature: ecejfxjffu1zsy86ssjmoyxo4mf1by6r
X-HE-Tag: 1795396454-648981
X-HE-Meta: U2FsdGVkX1/UYKSdXf+swI+us/J2sm6M311EjOzyJ8W3Ow7ZJjXYEbTXJq3xAs8GxnayMT4/iCK8rAPc85crallNtB3iPG8YjC6YJNQTknKrF7Lob1Nnv22CJRi2U8C0diizoyz11tmPrMBQZ7AYM2neT+eRkMW7pcLieCC+vQEW/nJcogozjyVVPAx6AqRoJNnf7aOhlyOfUqhwxUtgHYgdlin0mDn6wJqKmaerz8vihWxMivVwMG99T61Fh9uxKYxfno4lGW1oS4o3gef2k7wRD2W84joksQNSk3NB0TxOvwwb/15ff3m1QsmxsFLRjOhiCTJIcQSEhag5SqWeCLc3qepTeT2BD8cEjf0OPyGPCZS0KTs5nI2ufmeNAo5LcTgKVbAQ4zTnN2XakqQfgE1wO5c5YFW/9gS5q4nJozEheWePum/8AgFTzEASgiUQhVPwKohAPN+gV4DYYnAMksrIWZht9bAToaQY0n6x2TjtQbhUjx3noA9IFdXyZ3ofr7tqHaRKd4n34iLLIMKKHKzu47nBngLeMz/FarZxxwRVmpvcdsB+vG5sey5AFWgE3SqoHAUHpOzaiIQ/DvKfpFMTLP7Rai/3q8o/ZFbgk/AmCOAzeFTRhGqcjhBalBzO/+nRJAcnprRgOMIDxhzkZi28xw0xA1fYTRyX1p/83GQmjCXzoW0N88rYCtQXctALUlS5U9McGKuwrJq5NxxZuJnhKQ1tv8VL6v5VMO6RlSKzeGlUJcAFLTfvcJfi9K8EK93sMM50H8NbrpjrRrmcnemebbnEZ+Cxp5er0kvAhR1+392pKCillo2nGx3TzFJEbPyjLRuQir7vkjAmfYsVw+mdEBcaX0H6Wiu5p046QvIdbxoKvB0q1azBdaOjKfTGMU3PK8OW24lofOW+xftR+QJm24WKxm0TkACccvar9InF2qbY5Vp5Ys2o877yXIRBZs1eEjb6rk2OaCr5vVd
 0HE9tVOq
 vAM5SvU+w6tk2i/LE2lNGa2e8Ezn+5ccQSC/Vl6sDHkOQwSsvAL8EDX/k47GcHcc9uRAIHApBoo3Go4V1fkgQIi3DN+iYzbibq1LzcgWoL9DXQAN3DUSbd4aaqzBMQYlHnnbKV5ZLHsx1vouKnJHeDiqlwVFsid8pOoSLdWw79JLEz47uVlDDOkQJxtv0mtfdwU8oq/lKB4PfvUdYYq6ikjsyyEv1Q2J5xlnfGjau37zrcxLecvTsFEgAjjKgW94Oenu1PGpNQ15jCLd4nzQG72VNdmJ0/SIhbYgFxe/XsiQnrP8HxUAuYOZe/RF9LFiK7M2Wu/IZrEFvRFDk6301OnooJSZ3GB+Y6mOHUGVohqyYPAFCH8hszarr2ACtdBELQ0+vdgCDiLRjEDq7/tKKUvgCAcPn5p3ME2aUV1iyyE5pI1m7aKCNp4u4HJcjuP9JePpxJQwNU09gSChtCh/WrOYV54x5ek4U2eGVYu3sOZ5Zo1eVSDgjUEu1HZw7cwpBbwb+Bx4te3tS7bt1+WD6DspIdOX59u0I5XKNYMnJIH+KjOZfWM1AYatEToNx+E2cJt/SdkkD8NTGmRGzLXgJkeu5IXs5E9fFpDyyvnD0RUICmxY6g+v9GdvksTsnUt7GFekZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:35:12PM -0800, Randy Dunlap wrote:
> Update the list of platform/ files where ioctls are defined and update
> the ranges of function numbers that are used.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> v2: no change
> 
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]

Acked-by: Tzung-Bi Shih <tzungbi@kernel.org> # cros_ec

