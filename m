Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB3460A2600
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.a=rsa-sha256 header.s=dkim header.b=trPf9+9S
Received: by kanga.kvack.org (Postfix)
	id 4068A6B05D1; Thu, 19 Nov 2026 04:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE666B05EF; Thu, 19 Nov 2026 04:35:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD186B05F4; Thu, 19 Nov 2026 04:35:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05C866B05D1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:35:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EFB6A0A35
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:35:12 +0000 (UTC)
X-FDA: 85451360064.14.470EB26
Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	by imf29.hostedemail.com (Postfix) with ESMTP id 46723120003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:35:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=trPf9+9S;
	spf=pass (imf29.hostedemail.com: domain of miquel.raynal@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=miquel.raynal@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795080910;
	b=2dDWEhSdJwHMhYO+VTJG2t9eSt8fTMHZc0/Uhbi2ZYInj9MP82ylNAPa8D4gacMqxx9yqw
	I59JitFC7af3C5OyAQ0WfOqSDt0pPrCugzdkZD27bim/K6NWWOnaa3kr2SmTqtVibDvrmd
	hY6oFy8UdhY5myG5sIL0T0rGJSb14Oc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795080910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQyK9hhzQUtdCIaKwh8qFL6kiw3hBK7e02jXrxk3Q5M=;
	b=IFuNiBAOBPe47Qfur5rzO5OUniDCbOwtbRfWpcMCZoJcUpzOcUDLaCQa3Lr1yZdmOitIS5
	BWIoh3Y7t3PpLNvHAZW44TwXfUxYHLqCBBYD7aoM0K/jeGCx2ozUYwfCx4wHaSYOlkyvBf
	KiKlvZ+RqclRnZmpCtAuA2QNeRdjMxw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=trPf9+9S;
	spf=pass (imf29.hostedemail.com: domain of miquel.raynal@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=miquel.raynal@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 7829C4E415F3;
	Thu, 19 Nov 2026 09:35:08 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3D57560271;
	Thu, 19 Nov 2026 09:35:08 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 145C311BC315F;
	Thu, 19 Nov 2026 10:34:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1795080902; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=CQyK9hhzQUtdCIaKwh8qFL6kiw3hBK7e02jXrxk3Q5M=;
	b=trPf9+9SmvXq7f3i06Ocu8PXp2wkKO6ORNKTA4/AjOKcQKVFePqcO/1BhMn+K4JKXgVetW
	9Yr+85a0u4rw/+pGQPZDRSMsRMDGawEXfnQ9jCtNv2zr3C8ZQd4iUe048cU50ECPRyFurf
	rsmMLyDo3rueQxG7RuwY+EBebjyTZuhqh1PyoyvCDfGRSYoPSTyfx/hwy85QgTWFsAil0Q
	X6TU5TJA2EpRSA3/3QyU7eQBfCRlHqNmOlSA+ByZVazhopQuZSLgxPNhpRVe5QgDh43L/T
	HBMPjxwGs9avJmS68J25IgXRGZqvRkZ+RC3EyDq//xlN7GCwXICCDykv7Bhitw==
From: Miquel Raynal <miquel.raynal@bootlin.com>
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
 K. Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,  Richard
 Weinberger <richard@nod.at>,  Vignesh Raghavendra <vigneshr@ti.com>,
  Zhihao Cheng <chengzhihao1@huawei.com>,  linux-mtd@lists.infradead.org,
  Neill Kapron <nkapron@google.com>,  Andrey Konovalov
 <andreyknvl@gmail.com>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  linux-usb@vger.kernel.org,  Juergen Gross <jgross@suse.com>,  Stefano
 Stabellini <sstabellini@kernel.org>,  xen-devel@lists.xenproject.org,
  Hans de Goede <hansg@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,
  "Michael S. Tsirkin" <mst@redhat.com>,  Eugenio =?utf-8?Q?P=C3=A9rez?=
 <eperezma@redhat.com>,  Sean Christopherson <seanjc@google.com>,  Paolo
 Bonzini <pbonzini@redhat.com>,  kvm@vger.kernel.org,
  virtualization@lists.linux.dev,  Jan Kara <jack@suse.cz>,
  linux-fsdevel@vger.kernel.org,  "Theodore Ts'o" <tytso@mit.edu>,
  linux-ext4@vger.kernel.org,  Mike Marshall <hubcap@omnibond.com>,
  devel@lists.orangefs.org,  Paulo Alcantara <pc@manguebit.org>,  Namjae
 Jeon <linkinjeon@kernel.org>,  linux-cifs@vger.kernel.org,  Jaegeuk Kim
 <jaegeuk@kernel.org>,  Chao Yu <chao@kernel.org>,
  linux-f2fs-devel@lists.sourceforge.net,  Florian Fainelli
 <florian.fainelli@broadcom.com>,  Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,  Tzung-Bi Shih
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
Subject: Re: [PATCH v2 07/12] docs: ioctl-number: update MTD entries
In-Reply-To: <20261119053514.255348-8-rdunlap@infradead.org> (Randy Dunlap's
	message of "Wed, 18 Nov 2026 21:35:08 -0800")
References: <20261119053514.255348-1-rdunlap@infradead.org>
	<20261119053514.255348-8-rdunlap@infradead.org>
User-Agent: mu4e 1.12.12; emacs 30.2
Date: Thu, 19 Nov 2026 10:34:37 +0100
Message-ID: <87bj7lf9le.fsf@bootlin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46723120003
X-Rspam-User:
X-Stat-Signature: wi89nm1q41sopkss3ox5i7krt4wyx4he
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795080910-96071
X-HE-Meta: U2FsdGVkX18bYlKqLInGEN6fPyvihMXc2ApTjjBFXBKNKGhgdrVB+qFb+8YT3h6P9VmvEmkp/K1wk57A+Hgmdotwgcl1P16jrJiPa6yU45bgS0pavZ/6mxjKmyjoYP2/FlFuMvlg28mlIzZpH5Hbi5vbRnc5eKngdEsFwa6hv2+OqYPL7hZqH0d9XxDHVLHofToP08WY9oYqavd6e/gb2UFnOdQJfwbuYKNlHtfa7JsoWMRv7J77LVNHcCjJVh9vNFquHEwlpgkhbf696aA4P79lHSWYfqFfKrKwsElMGv/dUCnud9kmsofpvHp4gwJHjIXBwsjjYM0ll7R+pJBCUbriFweRdqF0f23hl/P2vv06fP0e+J1cT81xxeN8/Nu9wE2fT5icpDRqc6/B3pIcC6ugDL2D/cARWVO1aO0SyWPZJwd3TxZrB4ZTp03PwpZoUjxpHNe9FN5QRObzhuU6tn5a4dP4I24ZEguWdwPaamWkw6n3eDV7kzwRZDkY8As+rnbHhSCUSiWsAA3hlfbV6qO6VhmM21Gd35y2KLQZFjN/kOUtuFVS+KPKeaXi+79yUmPnrg2rjslxkX86SzGCJ8lWi7uur6spCO/kjtZXwUJIbk9M405XmcPxtpUqzfizDUSBpJhP8sST6olv9AySyb34LbJstUZjQO6xvzLzUVCWlFD91DPonXYrYHHlvFvAsYKUoLSHUL1EuSqds0TUh7CYdxeksjdOooXfx/+e2DAzyq88HWHdP4hYjz2w8WJ0pP4UA3kt26aQkFkImak8vF65hU8xnbpBt+df+n6m78YyhVvR4HdWtFnNLCo1DtR4clvAnZiFNKiMJd+eFIsU8RQuU7dZzV4MMQP3U1kHmBJ1IuuCVOMTEA1J6Di9U0A+nu0MPxC3Of7pnwLDbIJ7GxB1gJIHcLwYp4Z15DFfi2oP9hA1kyM3W5Co9xxzJv6Tii5KT9La1jtCd1rIKOH
 glc9l45D
 Vo7Jm9wGqv+cxpojCJ16Y/ISXkDi2xAPq8OLXzhTzzp+n+jX4KcgVXbFt622nFGvY6gewMMAklSqC7AhpKaQlp7FZrI6hc33WG1gJQWk3FASBeuKl0PbBEUjinaJU98MGQV6+C4QrgewpDE1YX7szBaE5zyI16rVIGuWcvmrbHU4Kal2xgIVa1grJPeEmCzrS7wbQzytmrAyBSECd0thpN5fQOJHTe0Htcrpf2kcK8v9H/JJcpIPEv5gFXD26evbSo03ZBYku0T/o7c4QEW/4ScNfMwGaYnpdCUWDMmEyesJUrFItTZ7uVD/at9CpVh8AJPzUJFlslW1/KH61GRdmpb2O2c4hlNORqeE4ysvwq/KOM5GS89nxCNLbROLvo7iO9ClbWCUuk1ak+/1zJ1Bv/AejFFf9Y6MUZ94RcUOfvRBq6OOKz+GI9DeS9X+TX90nvskv1EVCBgMffvWXd7hL5akd/jdK4X8Z0o1GCTm9tvzwuEHQ4L+Bvnh0XBc6/5NwZgXI87yIp8mwRsALfcHmaTN4BIbOo6eWQb7N6f7fERG70aTji6XxXRD4fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Randy,

On 18/11/2026 at 21:35:08 -08, Randy Dunlap <rdunlap@infradead.org> wrote:

> Update the list of files where MTD ioctls are defined and update
> the ranges of function numbers that are used.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>

> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]

Agreed.

Thanks,
Miqu=C3=A8l

