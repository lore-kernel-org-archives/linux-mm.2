Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9907D606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 02:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dq2Owl4T
Received: by kanga.kvack.org (Postfix)
	id 69D896B06CD; Thu, 19 Nov 2026 21:34:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673F06B06FB; Thu, 19 Nov 2026 21:34:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563746B073E; Thu, 19 Nov 2026 21:34:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3082D6B06CD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:34:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D1AD1A0D0D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:34:42 +0000 (UTC)
X-FDA: 85453929204.18.119718F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BBAAD100008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:34:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dq2Owl4T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of mkp@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mkp@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795142080;
	b=ozUekE22HztPsuPcf/aUE90DjX+ycmfDDo0l2V/ip32lgYb1N+wTU7d8WFnUSd+GZm01yN
	zhs7hwuP/+D+hQ6KimNBdK0ISDnTAbcFIkF3FtpCwfVIt23JRavibUNQw6t3g5esiVqoj6
	cymgdSMowk2Zgaw4WfSealuARNBRnjE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795142080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yLxaIFgMgiNdJ6EvHj90KmNsd7UyUa4rOHQt8MkQ4o8=;
	b=mZX0aqr+vKU10XIOUmKgsrwbOtwJ6wD617TKEexhkqTqVojK02VfA4+VdjK+12YU1UkDYu
	MFHPuL2gHBN+xfI1/zJmo8psPLVXM4Zj/qqAp/PB843unch1qD6EbWsWxqkMz0HAhoAYmV
	KWeOZpMPOMKpBTR73hg1KrkfZ//0vhE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dq2Owl4T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of mkp@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mkp@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1BBF601C9;
	Fri, 20 Nov 2026 02:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6D31F000C6;
	Fri, 20 Nov 2026 02:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795142079;
	bh=yLxaIFgMgiNdJ6EvHj90KmNsd7UyUa4rOHQt8MkQ4o8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=dq2Owl4TQH5i1O8lPJeqrs/bhVJe74UawaV8WZGOjcpXryG9VX5bBPEuofmjMl6C8
	 KEMZUEWUmofCrIT9kL1mF9sqs29c0Cyil2oxP83BwPsBQxJM3XbOQHwaj2x7OkBm3R
	 Ubt4udGPNHycSNftWKTVPyy9zKiSLnNOhFSlFIOPsiCL9/KFgmw/r+jfOmYYUs/VC/
	 SAI+QguGa/5ffH3iaZeehgrULZs3TCS3y0wcIRBQ7+1cYjuY8NOZbiPkIC9OoceHPS
	 +R5fZniZZazVx2uAAw4qgmr08ft+ySZxWB+NNVSP3BxvosYlgijyZSgy8PCf4WR5j7
	 gqEvBh4+Qs7GQ==
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org,  Jonathan Corbet <corbet@lwn.net>,  Shuah
 Khan <skhan@linuxfoundation.org>,  linux-doc@vger.kernel.org,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Gunthorpe <jgg@nvidia.com>,  Leon
 Romanovsky <leonro@nvidia.com>,  linux-mm@kvack.org,  Jaroslav Kysela
 <perex@perex.cz>,  Takashi Iwai <tiwai@suse.com>,
  linux-sound@vger.kernel.org,  Jens Axboe <axboe@kernel.dk>,
  linux-block@vger.kernel.org,  Marcel Holtmann <marcel@holtmann.org>,
  Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
  linux-bluetooth@vger.kernel.org,  Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>,  Jason Wang <jasowangio@gmail.com>,
  David Heidelberg <david@ixit.cz>,  oe-linux-nfc@lists.linux.dev,  Chas
 Williams <3chas3@gmail.com>,  "David S. Miller" <davem@davemloft.net>,
  Eric Dumazet <edumazet@kernel.org>,  Jakub Kicinski <kuba@kernel.org>,
  Paolo Abeni <pabeni@redhat.com>,  netdev@vger.kernel.org,  Helge Deller
 <deller@gmx.de>,  linux-fbdev@vger.kernel.org,
  dri-devel@lists.freedesktop.org,  MPT-FusionLinux.pdl@broadcom.com,
  "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,  Miquel Raynal
 <miquel.raynal@bootlin.com>,  Richard Weinberger <richard@nod.at>,
  Vignesh Raghavendra <vigneshr@ti.com>,  Zhihao Cheng
 <chengzhihao1@huawei.com>,  linux-mtd@lists.infradead.org,  Neill Kapron
 <nkapron@google.com>,  Andrey Konovalov <andreyknvl@gmail.com>,  Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,  linux-usb@vger.kernel.org,
  Juergen Gross <jgross@suse.com>,  Stefano Stabellini
 <sstabellini@kernel.org>,  xen-devel@lists.xenproject.org,  Hans de Goede
 <hansg@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  "Michael S. Tsirkin"
 <mst@redhat.com>,  Eugenio =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>,
  Sean
 Christopherson <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>,
  kvm@vger.kernel.org,  virtualization@lists.linux.dev,  Jan Kara
 <jack@suse.cz>,  linux-fsdevel@vger.kernel.org,  "Theodore Ts'o"
 <tytso@mit.edu>,  linux-ext4@vger.kernel.org,  Mike Marshall
 <hubcap@omnibond.com>,  devel@lists.orangefs.org,  Paulo Alcantara
 <pc@manguebit.org>,  Namjae Jeon <linkinjeon@kernel.org>,
  linux-cifs@vger.kernel.org,  Jaegeuk Kim <jaegeuk@kernel.org>,  Chao Yu
 <chao@kernel.org>,  linux-f2fs-devel@lists.sourceforge.net,  Florian
 Fainelli <florian.fainelli@broadcom.com>,  Broadcom internal kernel review
 list <bcm-kernel-feedback-list@broadcom.com>,  Tzung-Bi Shih
 <tzungbi@kernel.org>,  Benson Leung <bleung@chromium.org>,  David Airlie
 <airlied@gmail.com>,  Simona Vetter <simona@ffwll.ch>,  Alex Deucher
 <alexander.deucher@amd.com>,  Christian =?utf-8?Q?K=C3=B6nig?=
 <christian.koenig@amd.com>,
  amd-gfx@lists.freedesktop.org,  Jani Nikula
 <jani.nikula@linux.intel.com>,  Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>,  Rodrigo Vivi <rodrigo.vivi@intel.com>,
  Tvrtko Ursulin <tursulin@ursulin.net>,  intel-gfx@lists.freedesktop.org,
  Matthew Brost <matthew.brost@intel.com>,  Thomas =?utf-8?Q?Hellstr=C3=B6?=
 =?utf-8?Q?m?=
 <thomas.hellstrom@linux.intel.com>,  intel-xe@lists.freedesktop.org
Subject: Re: [PATCH v2 06/12] docs: ioctl-number: update SCSI entries
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261119053514.255348-7-rdunlap@infradead.org>
Message-ID: <yq1eccgqlhr.fsf@mail.kernel.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
	<20261119053514.255348-7-rdunlap@infradead.org>
Date: Thu, 19 Nov 2026 21:34:38 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: adf7wrfzmbbj1p4yr5ughf678c35qxqa
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BBAAD100008
X-HE-Tag: 1795142080-564658
X-HE-Meta: U2FsdGVkX19fjINFjhJ50lkY1lOFtTjcmfH9/be0c8IA5M7LrMs02N0H/Nz0mh/H8L1xc1V6A0yYLbFR4suttLMFret6k2T+ryrwEmoiRsBBoYH9oJFpW+coFObeqdBx/fCzUxDhugyOzNQqnmSzgmWWzUwoeq50nU+RTSsWuxr70osgQ9MlP6ikt0tLw74wiOPshmwmga+eUbis7P4Aar9GexUmihDAJRayWWY5PXi+9VvQx0TmZ2hipahgGdaWdvR8yn6KIP7z77+M0q654OlOMZNJHw9NLbwGgtB7J0XOJ0h6Y8hZ1WY1B40IWEHUgKwQiCbJ1IG2ficmVyY/i7GxYnXY+QtsN9gbwWSrO0mjxdVV4dLegof49Zxg1yTB/B63RQHZckWjQjoVFs7LpTp2BsBB3nMEM48wxFqwLapse1eJP8nWYOg/YWjKGJ6dFZVrx8hl6/1wTP0wP7cxp6I9VfvMwBqL7xFWPPnVcPkAvhtkUg37XdijL2w0R69cyKf+gJ9JMQ3Nzu5AAd05GSyLiL6aOc8lf5Fqe2XeQ+z2Xkn0rp3vOuYw4VGOSg97PmnP0o0Z9ACWjYMIRzSxnvuZLcRFUjZ09xTWPQrZe1ztidOc0ujnrWuMf8+zCZb2jTxkJJfdDigl8TP4AF+8UD04wQSN69+7F6h+PaS2OmgBuvszxUcVxmgs3bZgZq1h0jLgHU/rDSdvx7UqOLmkDvBxESmhhX6jHVFypL4kjHIkWABhr+plb/q3pNM9JqsJeAEseBaXjc/CkmO13XUQvL5wHPF0anH7ZmIh+O9Rh9eGemJ/qKfXJ5mQLa1+Mnc2kG3a3/EJ9JRz/Lc5yIUYQ+QHdLaGSiPoBDUmwFs50WP+Xr86xnfgQkawlypyfmX4a/P2cTL/tbsOh5Ny+OBSYLwJwTE+Ssh9l9yhakoByqKLbI+1LrmVDpinmYg3M85tpNE8Exdx4BWqNAxv0i+
 8tbtTuam
 Nu6rdFkQG6dGQ+irZm+79UfgN2V3Zg/NvOam64im0mRsoC0wT9Pf5DpAo9BD0mVR94umOfsoQ+bBZIgvWXgSOQnhHMfSuRds3Yi2dIt9tC1c8PpqRm/8faisVHr9osiKCOWOr/o8UXBK6JueQ7+1IOJaVHg5egWelKRrkJosxeRVB3uY5NI0lK/CPbuiRlDwlJztzlIm3R9UHOQy6Z4SdpsCmxaiOp5syFwwL/eOY+GuCj2ZeRf0foiOAXtA7jcf2gsYMImggzGOgSazUMBrrLbZxLT9aNQIXjztyE6g1lm9Iwp8qkVzzCtT+dcPMBKWM7Qhg/VlD0roEcPkEc+22V8v7916h+AlsJr36KjkuZkr4oyrBGwgUtPYQrFaHAasIJu59hhCjKFjgG/bQMq3COn5UCt4KmZoapBHOycfGquQY0iISDI9Gd8EyAM8CTFSyS3yW4vHbxp60zWVAoUlWjozMODKPUxHGgOsunFgmekTgKlJrnDg1UhZKYRLODA9SkflrLA0u1OoQHo3upXCyE4t7/3gsvDIzunGqMzzT6SrJ7mvTmU5aIPsqrbdyQDM1N1UxJaf3it8rVbVY+yNxeZCB5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Randy,

> Update the list of files where SCSI ioctls are defined and update the
> ranges of function numbers that are used.

Reviewed-by: Martin K. Petersen (Oracle) <mkp@kernel.org>

-- 
Martin K. Petersen

