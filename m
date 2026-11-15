Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700F2606A8AC
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 01:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.a=rsa-sha256 header.s=fm3 header.b=pjuVmr/L;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=syy3aDEc
Received: by kanga.kvack.org (Postfix)
	id 96D456B05B0; Sat, 14 Nov 2026 20:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944E96B05B2; Sat, 14 Nov 2026 20:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CAA6B05B3; Sat, 14 Nov 2026 20:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7F66B05B0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:20:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85D1214049D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:20:12 +0000 (UTC)
X-FDA: 85435597464.20.6CA7959
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A4D01C0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:20:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=sakamocchi.jp header.s=fm3 header.b="p juVmr/";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=syy3aDEc;
	dmarc=pass (policy=none) header.from=sakamocchi.jp;
	spf=pass (imf20.hostedemail.com: domain of o-takashi@sakamocchi.jp designates 103.168.172.143 as permitted sender) smtp.mailfrom=o-takashi@sakamocchi.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794705610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIES4zNTDxRjCnYHiHcWq6p6uX7fK/EWYh7I/zXroHQ=;
	b=Y5fMOpIThhkJyCbpIATpVYKc4Hn/Pk0KocXUhJ4eSloze79LbVpFlFJg410x8RskAr+RHP
	a7N553+e644hmCRxvpCp3W/EMVL5JOFgvI05mh6Ut4tbrhY9Q/bNAvk9eEQD/f/GQFXg2b
	v+pnOKsWTTybkj9S56XkqwbWmM8mbag=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=sakamocchi.jp header.s=fm3 header.b="p juVmr/";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=syy3aDEc;
	dmarc=pass (policy=none) header.from=sakamocchi.jp;
	spf=pass (imf20.hostedemail.com: domain of o-takashi@sakamocchi.jp designates 103.168.172.143 as permitted sender) smtp.mailfrom=o-takashi@sakamocchi.jp
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794705610;
	b=oGnRI/fkXDd9nCYvVpqe+xNQDAY6cnSyZhMPKY6BB5dsv/hQ6SE65lUQk37ZHqwgY8tfV4
	q2WPWJmFfF4ytjmpu7apKAdlbgBbGf4zMVi2GyBgxdM41Kwh/Zu9pvws+Vr+cLO1M3ORn/
	cH909v5Jtu+22unSPJJu3q8iM5B6XgI=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 7F53D1381CA1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:20:09 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sat, 14 Nov 2026 20:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794705609; x=
	1794712809; bh=QIES4zNTDxRjCnYHiHcWq6p6uX7fK/EWYh7I/zXroHQ=; b=p
	juVmr/LC7nCJ0SQ2rWUhRQGDMnlVGg/71zflyfizaeCefqOj8Wyp1bv5cUdTgRb8
	7XUxKSQFA4h5chwE1lADu0vrwg8OhHP6GoQHRhO7+gqlPzaI30gfxszAJ8iBZnAq
	w6LhtavpJKSJHCgIMJ9jaiAQhtgloSfAXiebl32YH12R4n49k4Dhf+Y8W3pLV4v+
	Lk6DFTk8SpQ9jSXzpScexBSvyhdEJDbrQwMC0927YExgznJjfLZe0flh8fHQL7IO
	vj78LH6slSiU2T+/dLzxP/iDcsVNxx1fb6S0NI/BKneEKfRIjGfp58LmRDVhLSom
	qjpjx4Q11TfgHJQJAHUUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794705609; x=1794712809; bh=QIES4zNTDxRjCnYHiHcWq6p6uX7fK/EWYh7
	I/zXroHQ=; b=syy3aDEccFqwMWi7OqQgN+5WtM3ZAfMLRFvK6Ty6zA65HPirgvN
	ilcYb0Q1wBWUsxvkCfegkY1pzVtpHUOC6WAP6pTtbZPWcSU2JRmZq5bj3XtaI5mJ
	5KZK4MCZjfikGyCw8udPD79DzKX657SNeo8VKm+NBs1zDN72HR3ZemlLBm38jus1
	WDdVI20E7k3nTziG5v/jPkof/xTKUHTBh7LLvCto0jlE2c4pmQs/fxRRAq0SyBeZ
	lruY2Ddh8f3CbRk7/EsENeVrGkeN2qYTfTHHssLqQwRRARUN/edAoqWV9ygwuEYm
	jIS3U35+DcIoM5H/MAq31DLvDAGEUQlNvVA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sakamocchi.jp a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794705609; d=sakamocchi.jp;
	mf=PG8tdGFrYXNoaUBzYWthbW9jY2hpLmpwPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:EZrJtf/Ie40YNq0/mqyUGO77kFVKjRD4U5qxKYfxJ98pxVf
	kBOFq5ZC5Cy8aiULu6+JFFiWZ4CpZm8Dtm49ThxXYblKhPwh1NbwTFhBdVu+ltIy
	KvN0kkTgnUHLMRGMQ5+tLhmolspjWz4BaVm+0l9Ti1EhuFK6Kmn3tLFeDSwFl/Ez
	UEdx1no4EeCUgu6gz8Qbdvx6ndyJ5xe8wv8+zROB637FCw3lYFCfXyWnOCLQI3BD
	J6d7Z2QDYwxLHNtYU5b1+hQV42CN3FGo64NnqghSraMTo2FJzHssMksQq/FzpF85
	WU9G5CKuHLmVcTn+x+qVU1rVNGJi/YBQ+RoE3Zg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,mail-followup-to,message-id,mime-version,references,
	subject,to;
Message-Instance: m=1; h=sha256:ntV32t7KOIfGMot6swX3CNi9IkfeqivW9U6qBDwCqc8=:4RP5xhIBVdE4nHZvdVXdOxDGDwEwdGMsIHWUj8/gqfI=;
X-ME-Sender: <xms:xQj5aiop4gg9dsJ6_Vn6u45zXMYueatHm6sTqNkrPjF6p_uliIn0fA>
    <xme:xQj5ao-c0CruU-TGxTE7NFYZSaEuQncLSSmM997vVUnXnDFfvxt3Mt5vMRNmSfmhf
    34fKN--fbmH87piFvayMBFAxnjq6WHAkHe46t3SFxeylFtFg6aPnx9A>
X-ME-Received: <xmr:xQj5atXGMWjP8faJlCtXj9RrVZeBW-gqDucCpC0ZXa191cT5jnWReGYw_Z8rYiOMsAtlcaNqIM8bDcRsKH9aHiPzWCfQ_w>
X-ME-Proxy-Cause: dmFkZTGQstm6GOmXFdPQXDqZqAYG7aQouPeZUHJ4IBXrRYWFH6lFNnMWIuGsSOCFSsBuXW
    LbDJxfVrfV3cl+wc1JM2qA4EvGILGxXqZILW7GfZPYDe6vWDeehuWas6PsFLq2rp3ZCMLK
    vb2ZkQs61G65smsTsr3W8fx/U8N5II0Wva1plTCgHg5UpMnhi5PWu1EQKVr47yDlfh1UvS
    LYKjU/U9x7MTbsMHbdhB5rWUTX8pbvj9eAIRg5DGXYvFzZokg4/nvH5yq0IUoDc8xEYNrb
    hSXdXqov4GW1obuCd3P9CA8Y5vszeSouSKwogVvelkFQGttmZKq/NF5ipA4vDPXyrU1Xrm
    Zrz3WElYlhVCDcPNRnAGrD/gNAj1b7M9bHXUiJrCqgmTebsAx0cfPWnZGZ3/j9Ea2UWcPj
    qqJZ67js4v5NriJFPwSb5fBisbBQrZL2hM4YjWQCJ9uoloExIgLFI0L7sZA853RBWP4ncp
    DBuj0o8Fkgdi7cJEPrTBBMdPRnMErqVngCb+aWeUA0zKt+uaR6UB1bg9ZicNV0ayYa37yt
    I8T18lqRGBzHHbPK9Mrtu/1JSrYmpYKqgKJaY1owBZ4nprZ++3QPl5fwcLNIPsiGvSmzop
    Zbr1xrRPLyP5mMh+v5LgBzIwywaOGj2L4LIDZM+0lWqxfhjtWj2WgxvXglrg
X-ME-Proxy: <xmx:xQj5avAwgflb4ksIG5XRwHT6xxt96MMxRO3omUvuEt-3k_ppqJzgYw>
    <xmx:xQj5aka9rFrx7_oeihBM0qdilVdSsLFNvKaV60FpVwOaq7EoVM3bNQ>
    <xmx:xQj5ak3AzNFqwOx2mTfPhYibu1bQ_UDkW9NgFtUhfBWBcyXvs0uL4A>
    <xmx:xQj5aoGo_8KYcqvEjpNAxM_sotiXZsyQPcuJ_BoRuwGjdfls4pLNfg>
    <xmx:yQj5amBDENmX5NhRabHbZy5mqP0Iv6_jzPBpOZyadDNP-V1uD_qCKZw->
Feedback-ID: ie8e14432:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 14 Nov 2026 20:19:47 -0500 (EST)
Date: Sun, 15 Nov 2026 10:19:45 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
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
	linux-atm-general@lists.sourceforge.net,
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
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
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
Subject: Re: [PATCH 02/12] docs: ioctl-number: update sound entries
Message-ID: <20261115011945.GA238787@sakamocchi.jp>
Mail-Followup-To: Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
	linux-atm-general@lists.sourceforge.net,
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
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
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
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-3-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114202653.3113381-3-rdunlap@infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A4D01C0004
X-Stat-Signature: ibcb8kx1qweu3hz8r7uw4an7ckcyb35s
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794705610-433965
X-HE-Meta: U2FsdGVkX1+8O5veWag9oXM1uk3gyYt9SEGKLsB+05UsSZoU95103s1PbTHpnZt7imcddjAfvgzdBojku/Kt983GW6f+0cqy5V0hXyLx7TGLkRZSyi5KiZ7pfVTbCi0rfGfcbVzbu1z9YjL5aVohjoKygSrWuGjFDZvpCfnMsqDyrcsOAYnM9h3ymPMdvWFRof/TaYVEnTjbf008R56GwbLguIIsJRqSObRXjOHezndHnWqkOu7guysikoE00wcPpj2lGywvUq9gWHDMgQ7PLLUbAEaEsSPNil9ma4sXlSNS28OmhixKUmIwb7BWzHW/EaVLv4Yc40qnLomMJPcF1W2w67InOBhCHNQhhqE7NkgkapzGv4p9CqIZTewXbtVZa3N/nm/T2XX6srFXNrwmQHfbtzpsOmVZVhwnmLxAk6GOrxvN50NvrbOp24lTluuCOC6u1MuCbe9KhQuzlVk0Swnj8cE1AEb6obX1CBRYufkrSCA9/y3SZ/Eo0nj3e6QtecdemsN4nlU34IcJ7Vu6geMGxtR95iNzS/j/u+d+4tsCy6Wpz0Ap9lnoeilfioCMn4aYR03+7veeL/o8jdPDXiKu/FCwyYhOk3gJTzvklprbAneUwPKR4HUIIHE37ERjTBC/ZR7H9x9UsGt2fS5bHP5PTK84jMZF8l9MwRmvSan+tzz7MHRtEIS9memUnUJAd+GxD++BxoaoWhjeBDwMBhBJnuaWqp0Fw/oz2KDVmjzT9EGuuyJErPJwVKjg5iCwSIuxsQ40CVBXsp+up0l7NiW7RLew8f5Kptwi72qAEjTgYmd1QsGiyBm79EYtT/kh+xg6aXq+ib2WTX16xKa8yIYywna2+uI85jvknk4P6yxm1SITZzqpxgiVblP9vi/65gw0/5D7uCbrGuKwjUrDVHfAUCTmGQHdp0fXHff+VIob176+3/ZgoDRBFRfdPreNgCGA3wJ7Cc0WqI+2pJs
 WKH8JWtl
 bVrujrHGcLSD6nSr/3FdoPLreTXQXrbz7r5iUMinDC35+w73nUQxitRzoLY995i6RmWQrATpQABHLH9nNX04tZqIKObXSr/+si8WFMW7nHByUFCh0CWlHUPoOikemIXwTKnB8kCEtUsiRLUXStIcV6HtCo7aP4uFOqPxZs+MIzFC8BiqtpYCl9pt7oletBskCY+3XpaNq5DZbeJVqDf+eSwI4B6vUxKaJ6y+qV1rM1QFPMTdGlTBMePlrQsgjebD9xhWVl4sV1xuerqGn6KeiVWqQR2jSvTa4ZlR51DjrYRKmyhoIu1vxv+8mbRlF/ND/s79iDIZ3GSIJ0QyawJ7tDKzqFMJRhqbR0vLfReJUKtGFyVPX32Ir92KCWSHY61NmvyIB4jmCO0+jvUK1ZvrhaewWYLSOMDcJrCquXtcSvyz9ig/AeyUYgOP0BJrcXwyhQV+Lm3ovWsdrV5Yv+TXXPOGur1Y7AhWD5QywYY1BETh1xuOgImKvlj5fe1bmiiYL3Mhw1yUbwBHYLjkAj+Rog3prcq7E2tAo0uTl14VWBnqpxGswsQo9kPNoOm8BhPY3Sgs3rqJm1RdWb0Rb9HGuI97WglUZV0PIpZFBY1MBU2bjdJUDO81XQ1mqZ7ZV3ilSHEW3PbXayw4oJr5xOZ9VqLTR4xOugJQCRh+iXyaOPLQKBOGlh9kjkMXkLYZK9oUiFhyqz/UJ/+/NzGqINU5YP7dewgUMJq8xzys6aChUGhS3pFuhszVfjs28lQcl3eQonX7xTyVAmiyaxwUO35ZUwuVchavJnvsBzkBT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Sat, Nov 14, 2026 at 12:26:40PM -0800, Randy Dunlap wrote:
> Update the list of files where sound ioctls are defined and update
> the ranges of function numbers that are used.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.com>
> Cc: linux-sound@vger.kernel.org
> 
>  Documentation/userspace-api/ioctl/ioctl-number.rst |   12 +++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> --- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
> ...(snip)...
> @@ -168,7 +174,7 @@ Code  Seq#    Include File
>  'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 conflict!
>  'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 conflict!
>  'H'   F1     linux/hid-roccat.h                                        <mailto:erazor_de@users.sourceforge.net>
> -'H'   F8-FA  sound/firewire.h
> +'H'   F8-FE  sound/firewire.h                                          conflict!
> ...(snip)...

I overlooked this entry when inserting the additional ioctl commands in
the following commits:

* 90e8ac5c9d446 ("ALSA: firewire-tascam: add new hwdep ioctl command to get state image")
* 58b62ab702591 ("ALSA: firewire-motu: add ioctl command to read cached hardware meter")
* ca15a09ccc5bd ("ALSA: firewire-motu: add ioctl command to read cached parameters in register DSP model")

Thank you for catching and correcting this.

Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>


Thanks

Takashi Sakamoto

