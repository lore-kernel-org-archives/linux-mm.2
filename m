Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726EB606A8B8
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQQaKT6Q
Received: by kanga.kvack.org (Postfix)
	id 80D166B05B0; Sun, 15 Nov 2026 15:27:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E48B6B05B1; Sun, 15 Nov 2026 15:27:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FAE56B05B2; Sun, 15 Nov 2026 15:27:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41C3B6B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:27:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01819120807
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:27:50 +0000 (UTC)
X-FDA: 85438489542.02.D067B0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3DC25C0005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:27:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eQQaKT6Q;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774469;
	b=1OrZWx1UCtY4Kw+XxwHAhPVixywoTxU3409z1PpzZ3abnX489n/DAXzjIQZJ4Jg24H91zU
	MuO127SMrUgShDpDi0ndXo7Y6BG4tCM4rfj/Iyy9JsyejF8h8QDzSVKIewne8qVlBWY55d
	BCZTDOpPfNJiquZK2bEhOaqpMM6H10s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eQQaKT6Q;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774469;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gu33mrYXMzWB1guqs3vj2T3i7/kLEK1yfs/DV8sZmU=;
	b=myCRg+TQZn13gYl5eGGME/ZB2c0yBKOYThI31Om7fuDIWxLOC1eufhrjido4tXqnt9WrGJ
	BySwo0TugA+cUjQXAbxqwWo/qMNiFcFVfPhVAkaxnnBLU8VuVdnQh6UsnCV6ESBM7a3TA6
	/iMMel85LSGnVORQMieXGLk9YIxSop4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 559EF41E74;
	Sun, 15 Nov 2026 20:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAB51F000C4;
	Sun, 15 Nov 2026 20:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774467;
	bh=8gu33mrYXMzWB1guqs3vj2T3i7/kLEK1yfs/DV8sZmU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eQQaKT6QNia4M5fkN9vM/bS1Y/kK95Wo46QLhfi33KjcOH3lSRaIkcpl/SLpHMFrw
	 X11TMh2ra+V6g5NZEdBHr2So5k+ffsdxljUpW2UMZowoER6RAEkHJt0oc6nNYZHgio
	 OIZh2f8aULqySK74+IyVCP0a7rZpkLLcMDZn9Cs+JVVmYWVBaCNkzBO5O2JsN4cT2b
	 mVuRyIGfepUrdagbltdNOutkz4F+8m7mXRld5fg+/MwG9xiVPu3FYKoDZVNxB8e5pF
	 oUjJpYPMxLdqf3ESWBNQ2Z+E6J37XbR7aZTaJuq3dUdBkvCUkgV+gArRjgwg7l8a7a
	 ZyoDGdiR4Rfag==
Message-ID: <sashiko-outbox-215804@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/12] docs: ioctl-number: update networking entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Leon Romanovsky" <leonro@nvidia.com>, linux-mm@kvack.org, "Jaroslav
 Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.com>, linux-sound@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, "Marcel Holtmann" <marcel@holtmann.org>, "Luiz
 Augusto von Dentz" <luiz.dentz@gmail.com>, "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>, "Jason
 Wang" <jasowangio@gmail.com>, "David Heidelberg" <david@ixit.cz>, "Chas
 Williams" <3chas3@gmail.com>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Helge Deller" <deller@gmx.de>, dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, "Miquel Raynal" <miquel.raynal@bootlin.com>, "Richard
 Weinberger" <richard@nod.at>, "Vignesh Raghavendra" <vigneshr@ti.com>, "Zhihao
 Cheng" <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org, "Neill
 Kapron" <nkapron@google.com>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "Juergen
 Gross" <jgross@suse.com>, "Stefano Stabellini" <sstabellini@kernel.org>, "Hans
 de Goede" <hansg@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Michael S.
 Tsirkin" <mst@redhat.com>, =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, "Jan
 Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, linux-ext4@vger.kernel.org, "Mike
 Marshall" <hubcap@omnibond.com>, devel@lists.orangefs.org, "Paulo Alcantara" <pc@manguebit.org>, "Namjae
 Jeon" <linkinjeon@kernel.org>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Chao Yu" <chao@kernel.org>, "Florian
 Fainelli" <florian.fainelli@broadcom.com>, "Broadcom internal kernel review
 list" <bcm-kernel-feedback-list@broadcom.com>, "Tzung-Bi Shih" <tzungbi@kernel.org>, "Benson
 Leung" <bleung@chromium.org>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Alex Deucher" <alexander.deucher@amd.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, amd-gfx@lists.freedesktop.org, "Jani
 Nikula" <jani.nikula@linux.intel.com>, "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>, "Rodrigo
 Vivi" <rodrigo.vivi@intel.com>, "Tvrtko Ursulin" <tursulin@ursulin.net>, intel-gfx@lists.freedesktop.org, "Matthew
 Brost" <matthew.brost@intel.com>, =?utf-8?b?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas.hellstrom@linux.intel.com>, intel-xe@lists.freedesktop.org
In-Reply-To: <20261114202653.3113381-5-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-5-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:43 +0000
X-Stat-Signature: ybjejcxipkmj5e81t1snraw5sdxaakug
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3DC25C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794774469-670763
X-HE-Meta: U2FsdGVkX1+srDHqXf6rKvavx3l34ns7kJLsqxhwgMuZE1YWR7+QIg43pzSI5pfcTv/GKY6LDZPwx1ZNZPtuxVImgEm5/O5tw4Rd5iW1mC91J8KAk+YWl4Fq4CBeOYqxVi0nI2N2uy94FL1ww7yWaZPJ7II+Kq/uGx22nwcCtvchqYcugTItQBJqKwaFNeR+/mJtHnSUgo9/i/1gNzYbEzB0YBHIfZtadgnAM359DuCwIaGnjythqzSNoU9nXOfuu2pANFefPchVzxiyIaejiufYHd3Qem+z8kC2efilWMSFkj6Wk67jShlhNVlM74dgNILH2oqBDyI66+AC02kE62zLbMUZiHc+7GSb8yZkA2TC3c+yBXJyc0B7Wd8VYtsLLjbS54eXcWKV+IZ6BBYHRfg1dT4QUbd8SjRBQpf0li5bKFx++KC4Ahp12uTL5qIucHhPLDPQRImiBGs2hTDgl4NvAasUqxFn836c9JnZGpm5ULYStz09rvGP0snovRIJfb0ECKbiJBRNzw0iKiBNJXXUgDLIEX65oJz5xxfk0muQ1AchdEwE6VbWOE9GuyInONy5yateFvsKUkK0KKoVx3Mb2aGjAFxGB+fhVJ8VzRwh6YSbL8B8IP7d5nVH9WEh5hJcRaJhN5hJ8epCdCyH9ObN5kkJc/DCmbAivvP3Mtu1YgOlCXHgG5SEcsNIpzAlL11mNIQts0Gog40pkILmxtQpMh0HT5gvxpQ3jn0y4EmQk2EoJyOM5oOzxkldlVbUfCsPCrgji51qJJ+AEw06Jjka9zxXy24dGbjYl8RWvputCCK7enC/MKo+57GvHABQ9H5oRLBLieMSPZZNJFRN5xCkZS3gUiyvsAghF2vg6dirQFwkgVEOeVV23lm++myIeBWIMHNm1v0Ff8XKP5DqgTlkn0wRe/qKAfANMDjazAmgYXh4+KWdxCPz9sk9FEkk23j4zOJDjbwetj7c6Dx
 /ZOOoPcX
 rpWz5hiD9x/kVTgyH4/WSkmz6u5GKdP13rphheNzbiaM3g3C/GuIx3rr2v6b+8ajOf+OC3w4i60yt7Nhezjnw0j+2DUJhBMOaCDd/kVyFwS+V580CFoWxzaPO4LLWtbbbGAOwzAhI+2M8KbjyghwTKV3TPi8oT22tw/bhNjBySDgbNcaYqWqMgABM8qdw10naAGv+MmFva3EitOpI4Zu5mnS5KAdxmyAwYbRXVnKZkaidYZd8FKk3FSBkoapMZN9U4umZt04nDhQ/OszSHbSRLz3oSN9Sp3q1gm33AcYewsw8KNR7dWMVaWFyDWVRt22WlNznAyGb3sATtxRBOxGlaY9p+e3JT+SlpVE03vA/bKQAI45/LienjBu/whLrh9UxUlHheXNiSQhdz9dXRy4LgkZaUNjMAqvQyJ8BvzMIHIZbupDZzayk2jriHB92WvfVYMhvdZYNmpG1gUeZihURiV+05gOi4G3eEk1Tl8FqywXoFNzgCUMazXERaJRk9WAB4VQKBI/nYNraHb2j1N7xikpFa9swoHc5hvjoCGqBcqEOqva+SGn/Q3NqmHBP/rmkf4JkaK4qbHr+0QyTMUffkfwFaIi/mGUEfAWW5nQy6Z8csbgj3pfTNMKt5N2QGenAs84BQobKNFfJnR5vqQl3u/ZvvbuddnFDLWfNhf8v+kmUTKHDQkw+W2tSdPnpalg16XFJ7E8UPkzw6ueEt6M43mM+vgmlwKMmicQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] docs: ioctl-number: duplicate bnep.h entry and missing conflict
  marker
--

commit acf95c4d46bf87ab8fab382911993f6e83864afc
Author: Randy Dunlap <rdunlap@infradead.org>

docs: ioctl-number: update networking entries

This commit updates the networking ioctl file paths and function number
ranges in Documentation/userspace-api/ioctl/ioctl-number.rst.

> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documen=
tation/userspace-api/ioctl/ioctl-number.rst
> index 2b2d3fd317158..cd4f0bf6db66a 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -132,6 +132,7 @@ Code  Seq#    Include File                           =
                  Comments
>  'B'   00-0F  include/linux/pmu.h                                       c=
onflict!
>  'B'   C0-FF  advanced bbus                                             <=
mailto:maassen@uni-freiburg.de>
>  'B'   00-0F  xen/xenbus_dev.h                                          c=
onflict!
> +'B'   C8-D4  net/bluetooth/bnep/bnep.h                                 <=
mailto:linux-bluetooth@vger.kernel.org>
>  'C'   all    linux/soundcard.h                                         c=
onflict!
>  'C'   00-68  sound/compress_offload.h                                  c=
onflict!
>  'C'   01-2F  linux/capi.h                                              c=
onflict!
> @@ -173,7 +174,7 @@ Code  Seq#    Include File                           =
                  Comments
>  'H'   FC     sound/pci/asihpi/hpios.h                                  c=
onflict!
>  'H'   00-0F  uapi/misc/habanalabs.h                                    c=
onflict!
>  'H'   A0     uapi/linux/usb/cdc-wdm.h
> -'H'   C0-F0  net/bluetooth/hci.h                                       c=
onflict!
> +'H'   C0-F0  net/bluetooth/hci_sock.h                                  c=
onflict!
>  'H'   C0-DF  net/bluetooth/hidp/hidp.h                                 c=
onflict!
>  'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 c=
onflict!
>  'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 c=
onflict!

[Severity: Low]
Should the 'H' C0-DF entry for net/bluetooth/bnep/bnep.h be removed now
that 'B' C8-D4 is added, and should the 'B' C0-FF and 'B' C8-D4 entries
be marked with conflict!?

net/bluetooth/bnep/bnep.h only defines 'B' ioctls (BNEPCONNADD through
BNEPGETSUPPFEAT, 200-212) and none with code 'H', while 'B' C8-D4
overlaps with the 'B' C0-FF range for advanced bbus.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D4

