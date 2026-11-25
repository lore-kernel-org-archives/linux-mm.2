Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738F7606A33C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X3j1gI+m
Received: by kanga.kvack.org (Postfix)
	id 8EBA46B0AA7; Wed, 25 Nov 2026 14:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875E66B0AA9; Wed, 25 Nov 2026 14:24:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715CC6B0AAA; Wed, 25 Nov 2026 14:24:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48A186B0AA7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:24:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6C05141022
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:24:18 +0000 (UTC)
X-FDA: 85474617396.27.13A3C6C
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id E08464000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:24:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=X3j1gI+m;
	spf=pass (imf27.hostedemail.com: domain of bleung@google.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=bleung@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795634657;
	b=Eq/9KTYEVLHADndG/5+VM/R1bZDhISvZ9AxKjPR24+u4Wr+PrwK5niA9S1kwzZcL2vIpzp
	VasgYZL7LlpXklep/A/1J/h22S5VC7z/VBjjLBn5nVTFENtAK2SaKAXlc55aMye/Ok8Yb/
	/OECds0k0QQVoCxDbz7Hw5NFSHq3Eu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795634657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N55gjPKFtoyQEkpZ+mulBFdiGvAn3buEDUMJWwRWBLA=;
	b=HuyfAwfluML3XadD340eI7RI4mn3IfGhuRLEqIEw6BfrDmEFKmv5Jpu7lrIZqjbgtv47mZ
	Qsn1KuM3JVTICXz8CZgJSiVcrqBOmr7LnxgWALeiHHdeIFEZmMPZ+MWtl8bm/OKvMuSu9Y
	3a+Yjgtg5wp502e1Uu7xw4yRg9M3GaE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=X3j1gI+m;
	spf=pass (imf27.hostedemail.com: domain of bleung@google.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=bleung@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b3577deeb0so2858003b3a.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795634656; x=1796239456; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N55gjPKFtoyQEkpZ+mulBFdiGvAn3buEDUMJWwRWBLA=;
        b=X3j1gI+mF4j3Ip2I2c12xU9zdCWXJmVK+nrEJjOAPePEQZMGK5flm2cJF9BwMaCeo/
         3bt9a2t1mcfSR84RQK6LDhBWWKMJDDl/CrER0zicYI3lqKuHiwBewCzSEJDRDqUD/tMJ
         GXqvRy7T18dmGxIIAtlwTQaX+vtYkvBCiuNsnFW2in2QaR6mm3wcuoTdS5ZeNWPe94MV
         E/5+JVItcf73Qxxy1JkOwLX19eXRfUc0il5lObehp9IKmppJIqO7MOqx2k1PEtHHV1hP
         3VGvo/2agSixnpJ6vGBiHSL2PW6SV9DFEhYuZXcpZ/CqM1hoQ4YZcWDYOyvRy4FpvCNF
         QvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795634656; x=1796239456;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N55gjPKFtoyQEkpZ+mulBFdiGvAn3buEDUMJWwRWBLA=;
        b=Q5JqYuSv2LTBz9J/5HHaVbH+idh0EeG8Hi5tqizyjjSKTAfTxD1aIcqsLXpzWD/aNy
         CRlFCTG1QXmAJ7v/npX+/SZhjNbTNST00EFVQm6DLOjISNUKYoRG6T88/hVfuNA731bE
         zBu0svitlY+SXfr3x/b7Q+qG6CbjjKRkOu5I7P5gZ1YfdAAWCGA/gh1oMBTcxcLN+0sj
         TabeyQCer7eAtzsVlfNqjXw5hwMmuRgTVYgy8vlyS+CZbVSNscOQ/Jjkj3g1pOt10oPp
         gCST1auz/zDB5tgNQ+GX7i+mXQi2Gyxdv9+ZFmH+Meux4IERG4dJhpobsHTEbJlgpfUN
         iHig==
X-Forwarded-Encrypted: i=1; AL+hErGZM5ifMd6TGEwvsBcizGUMQVmNIHyXnjLLJ39u4anRe2tWqzu8UVGPmYA/LATN71UjkZCrE1eQ7w==@kvack.org
X-Gm-Message-State: APuU4Z8//qJ4FAFlmdYvZjoIsF2D7v/16WIvAS3N9vWY32EIuJRjbrgN
	H1EXYpRohaxruHLW9jPj86WdEhfga0AY1olOzTjS593wsLW+P+1igedSBldo5pftwg==
X-Gm-Gg: AZFdTZcVjrr2hjfz9fvvzGyk838Pb+z5qHpCu2qpcta33Zks2muIox0LTGUpIPgrTe7
	laFANhnyUpPjjzzHWvtLwuaYx98CWRZSw9rA/zNdCBCSYHth9ZrWlj49PUtvuH6jzoLFFNeLFHN
	cWd2+WtUcz3YTTrM6yej1sfLtfcuQLlwihiPETiJbS2iBlNDOxN3ZunFfnxudHl6cAAgvlaOTSS
	J6RKQJmP6uXzrsfGlmocFJg0rLrkoxDsFhNjLCZdnBp+PgBhqWtFUqcAVzcXRa/dLUO9nWAEvM3
	1dTZ3uDkyYpXc5RDz2x6UFCneElFGfHK3Ahy4FyojzQi4SiFU70c2uu8joh/pNVL/C/GDStJ76h
	jEMk+qfFnsfyoiPXs9BOakNyWq3s/1BCMdv5IY7twmnyPc5D0SpChcxLxBGtJ+3/6yQVN9XNnkn
	Mzxf+ogCHXsqYC5Z4ZqHYKrP42rIXIdIsHWmpI7lBVozPiXG3ki9j1qSbr7sgCOI2ZjKjn+Cx4V
	3kKeuX36Bk/xQ/YgLIt6gVxPd3hbNmnzYRaN7MjnJ58opz+N6x0WbR6OTFM/OLzE8Yu7x2fqhEU
	m5QMw2UjyjDFxd2+u/Nm15XSCbZktVEe7GF3H1yFO5dC6PShVMDwzX5+8Xv+iumhBUtiQEUIJ3F
	YsqsmjBUUL+bJ1sZICUXLiXWVlvNepMv5A3GFmNvHbR4HioeArEi3XhF2zytTzfa8R443OeAZuJ
	a0D7TYWVuTAw==
X-Received: by 2002:a05:6a00:a908:b0:886:773d:a6a with SMTP id d2e1a72fcca58-8c87c199463mr15925448b3a.28.1795634654761;
        Wed, 25 Nov 2026 11:24:14 -0800 (PST)
Received: from google.com (196.126.197.35.bc.googleusercontent.com. [35.197.126.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87077bc47sm9717494b3a.6.2026.11.25.11.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 11:24:13 -0800 (PST)
Date: Wed, 25 Nov 2026 11:24:10 -0800
From: Benson Leung <bleung@google.com>
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
Subject: Re: [PATCH v3 11/12] docs: ioctl-number: update platform entries
Message-ID: <awc12oWB5WDJi8XZ@google.com>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
 <20261125061340.3402300-12-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Kk3dCghKBQNrocaf"
Content-Disposition: inline
In-Reply-To: <20261125061340.3402300-12-rdunlap@infradead.org>
X-Rspam-User:
X-Rspamd-Queue-Id: E08464000A
X-Stat-Signature: qkm94coahcdppm1153jkrc5r3r5gxeub
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795634656-139068
X-HE-Meta: U2FsdGVkX1+Rf1Jh2nym5AHoY71eNL/n5PrvJWwlQygTV/xr1ibpj6G+9njGAT/ee0eKh+KnpJ+q6vyoBbcDd0MKh3qmOeQzZT4tjeY9ok8xIK20VMcNc5RRYRk8IUTrRf/DTLOjQqsEncfAetj0ajlhl/IeXUsq3G0PDISi4jtMCY+JxnrQGj9B16YUiuS61kgkDatpvjLeVnuVTDdnbtUOWstTR4vRLRQkMXNy/OeJA5DXxW/NbfFWaVgG86hxUorEyY+IagVqEqG0oqezzCOSDTqhyKh9O2oXOANqGYPWl2j0rJxRQwC5z5ZPOe2JEByEZozxKR9a/2/nsOZSDhSwVV5Yx32ST8RcfQJH4Ru82L2p+48CDv11YAgZhHWh9pfQqVu/KqSoQeOCNIrgdZP0NbagHmDCKgsLLI84uap/TzSj/A+wUerhlVDb5yUwgKdIszelttknxoZbUkWvp+sMUrWiUhBgjrJ6Bd1bPxHYGTEVc9d9A+Y+nKHmEY8EVyHkPGWA2F54w/HutnTEVrnG/kJptjpWMue7WymMilxKUYYzjl/P50/ryYrNFq3ZfM3NoFUVVhFP0CWbP4FeUfsiLGQ5NI51SHzR5Ey+CmGURmdFo9BAN5ATduNNjtYRtL72JhBbOZjYGFX2EAZ0wKsImEvgiD12/9ZCcyDoMOzJm1lci0SwcQ/2WWMkzPnPWIARWgiEgxK+mSQgrrBxzGdCuP9/fMA4m5T0yms5HE3a808Q5qrwz0w6Y4pWxenqDqZsOH0239XTBg+C+LIusgXxRzN7aj0e8AgnGXlItbg8tsBMIKMbJ13UobRxzBBqvlJWOFoOfYBzWYckSWGjL+wJq/tAxPRWUGT6sd+l1REoapVroBzPsLqHC9SKFXvkeRTTHjcNcPdNztp+mEEx1rjnO/iBorpkuYsBCBUPa2OCFpnPtoKSNS1c7fCwj88GLCMkWii0AofvWAF0coI
 2LOZk2g0
 dLxyi7xE5wmd9qCQd355xLa0AfzbvtmHyPXpoP34001EAjONI4JDgT3GeRcc8KVGp9Pjf7bQB3T13+2arQTelkzX5afz59GttsHQKMi/nF4cMu9/N+QkwZQeiF+PegL+bAs3HppC8O20vKGQdDxOW03IaulNKo46i1JOb3kUzT3wFrCcMJVBx6g9Sqv7zlHb+j8YdGOHB+xd4+zVvSogNnGMMGm7MNK8aQKtcClXW1aFKcT3OraoNb7fyx/K6Z7JIoH8Pn6POEweDuhK4Td9q1oqSyyKs1cLHmztLSjdfFl3HbFYTlOLkZ2rPC3pPedxT3hwUzzc5Qd1iBI/QyouuiIhHxMU0cHVeiDTRkagP0PHKZiLAB8ebYgKgdpoBfoYaj529uir3UQxjgPH7U1vocXpSvbx3YHySUijzT62R1Z+yUax3goCzEh23B7Xcv7xFK278guXqgqb8hmWzW72ZxD/o5iVtoluSJLKfwciiXL4a13XIZ3Vf2Ewzb4tzT1oA6NY0TrDMt+uDCJc0f5tZKggRTB82UpMLw1QKU5NKvUxC0mpaHk3N9Du0zxKs5lZZG3XpbiPv53faDyWOlKuVQj9IsBhLgnGaNsfbtArsBs+RurgDfp+YwDFN/gAuuHrf8lxgnfx29NTA94ZCsFzh/a3ph363TDlubKZuZJI65D5AyquACP7FTppz+H9gdHDPvuMxvII1YSjnf5FYsixzhovQ3KFrGl+9NR8r+wK/9IgPgKFq7nfwHHQEIBCzm7AwaMH+1FAQDBvbSgPRT/HS3DvHKxnK6qyRfQiLTTOzyeNoYPdxk4bz0EWfjC9NQ7vWjLqPF1AwDN/R6EFEm5qfnMZGTLCr0yhYl0fs/2l72416k52kxxb5sRsbBBfnitDcKvmqRJQ6QOY7uAeltZ0mad7cyc5W7Lft6PWSaA+0JO9srjfhN01miIMAYmH+bUjIHN+9XG9tiOkZ6V0fpTgYkER6DeV2
 HgEfBOiw
 QapiSp8u7QhdfPNL0IomnvTFtL81yPvWMwo//2w5fnREz1/Tz0Q0Jjb2WGgHRxol6SBUWbr6GTnAMF03wcVFCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Kk3dCghKBQNrocaf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 10:13:38PM -0800, Randy Dunlap wrote:
> Update the list of platform/ files where ioctls are defined and update
> the ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Tzung-Bi Shih <tzungbi@kernel.org> # cros_ec

For cros_ec as well:

Reviewed-by: Benson Leung <bleung@chromium.org>


> ---
> v2: no change
> v3: rebase
>=20
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]
>=20
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: Florian Fainelli <florian.fainelli@broadcom.com>
> Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadc=
om.com>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
>=20
>  Documentation/userspace-api/ioctl/ioctl-number.rst |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> --- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-numb=
er.rst
> +++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -434,6 +434,7 @@ Code  Seq#    Include File
>  0xBA  00-0F  uapi/linux/liveupdate.h                                   P=
asha Tatashin
>                                                                         <=
mailto:pasha.tatashin@soleen.com>
>  0xC0  00-0F  linux/usb/iowarrior.h
> +0xC4  00-1F  platform/raspberrypi/vchiq-interface/vchiq_ioctl.h
>  0xCA  00-0F  uapi/misc/cxl.h                                           D=
ead since 6.15
>  0xCA  10-2F  uapi/misc/ocxl.h
>  0xCA  80-BF  uapi/scsi/cxlflash_ioctl.h                                D=
ead since 6.15
> @@ -446,7 +447,7 @@ Code  Seq#    Include File
>  0xDD  00-3F                                                            Z=
FCP device driver see drivers/s390/scsi/
>                                                                         <=
mailto:aherrman@de.ibm.com>
>  0xE5  00-3F  linux/fuse.h
> -0xEC  00-01  linux/platform_data/cros_ec_chardev.h                     C=
hromeOS EC driver
> +0xEC  00-02  linux/platform_data/cros_ec_chardev.h                     C=
hromeOS EC driver
>  0xEE  00-09  uapi/linux/pfrut.h                                        P=
latform Firmware Runtime Update and Telemetry
>  0xEF  00-0F  uapi/linux/ntfs.h                                         N=
TFS
>  0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       s=
isfb

--Kk3dCghKBQNrocaf
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQCtZK6p/AktxXfkOlzbaomhzOwwgUCawc12gAKCRBzbaomhzOw
wuvSAP9FFr45oXAv5Psc3n5xsSYyPFouusI/XwRnWy3tYxQspAD+KIeOTWQfcOeC
TWeqyAANog5rg68r7xNPxeH8I/R6xAQ=
=Fk2v
-----END PGP SIGNATURE-----

--Kk3dCghKBQNrocaf--

