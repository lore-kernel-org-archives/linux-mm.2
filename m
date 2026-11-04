Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A69606B015
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c8+xsGNw
Received: by kanga.kvack.org (Postfix)
	id 413546B05CB; Wed,  4 Nov 2026 12:34:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D1C6B05CC; Wed,  4 Nov 2026 12:34:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B126B05CD; Wed,  4 Nov 2026 12:34:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 053C86B05CB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:34:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C5EDA080F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:34:28 +0000 (UTC)
X-FDA: 85398135816.18.CE8F480
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9241D180007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:34:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8+xsGNw;
	spf=pass (imf24.hostedemail.com: domain of rafael@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMOD33XmGyHm36xJWMnYgDFAfU9OylqTMFKngAIWEtA=;
	b=s9r/75F5nwmQ286mlglGWhnT4tMktTVKBxI6qQ/5KWdvA7G8DSzeimzW2lUx6OtQH7u6iE
	XgsVHE8HpsWV/mGHPn4xnUj0bk12aoX9XdfACMdmzc+tHZc0x3a/JBtV03JyA7qEdFDQTk
	7uIBwQW0NNcGsU6byqzTvCNYiV4E21E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813666;
	b=v4nlb+czl3lBDOgEuBWJmwLaCc9952eK7Nd3MxXD2MfVX4o/QIuf9MTmrJZGvz6VsQI/0f
	q4FI4m43RwdU9G6UY2NXX7XdtnOtKoGiqHndGefub/4ClQUP+KGvqIFacNJdOZE9KMcSvs
	nCrhCPXbFAwUMfQGZLlJ6ybImkZGW74=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8+xsGNw;
	spf=pass (imf24.hostedemail.com: domain of rafael@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10B68609EB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3141F00A15
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813665;
	bh=AMOD33XmGyHm36xJWMnYgDFAfU9OylqTMFKngAIWEtA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=c8+xsGNwRBct5ZUGKjk3eZtmN9gohM+NybLZwzj8cc388Jf+FuWQqNAaPFbwzicgF
	 zS2zfMb3GNkt3+o3qOH/KRvjG68CgqG8o23gRTXfw7pSsq7xlk0nEVbJSnWMEA6Vd6
	 WsQavQA+/klM4cHbpHQw7qBZ8l3tKs6OuHSy/oDVGO3ncD8J/WZPtQSd+ulSyM/Yvj
	 SBUb7y9RAQdeVkxB69uBukVLsWQpV7AE3b0Clr/+8u5fh7eWDuhsegmcTIoDomrBRZ
	 vc/4pFXDJIjiffydLU28BUqCA6oxGMiSW1cfuvO5UpTUsxXW3Go1YpNw0HVmUQhb63
	 NRPDlVWP872Tg==
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5eaefe5b523so635291e0c.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 09:34:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwT90DII3ca/WPdIzl20swAfnRsQ0tMjwwA9wjCLVyExFKo0JCZ77Lu1fPS53tWLVCRgI8uZ5B0pA==@kvack.org
X-Gm-Message-State: APuU4Z96yE4cbGQbt9dxH6pfIyEf5EOCbFQvDKbOdGUMU3IL/emHppHS
	QdFRjgcPijzPMZbkKm06tW27j7Yn6V9JDzsVSYpBFTU2027Vj1nRircGTz6EQAGHB1OTaZCShlQ
	ej7WLdwtQinIFqyVlglgN7ahdnW9ImOU=
X-Received: by 2002:a05:6122:180a:b0:5ec:5f1b:f725 with SMTP id
 71dfb90a1353d-5ec689c4d7fmr8231097e0c.23.1793813664918; Wed, 04 Nov 2026
 09:34:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org> <20261104-work-procfs-bugfixes-v2-4-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-4-bbf7d5546809@kernel.org>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Wed, 4 Nov 2026 18:34:10 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0gnefKDcBnLzxxXPLJkYRHN9pbYH9WVFAoUGuCSOPcW1A@mail.gmail.com>
X-Gm-Features: AclHuK8WGpfSf3TpV-YfKcvDlenGAnmL4yQTyeV9z6QpHJtyVq4G8L84EjJ5Q2g
Message-ID: <CAJZ5v0gnefKDcBnLzxxXPLJkYRHN9pbYH9WVFAoUGuCSOPcW1A@mail.gmail.com>
Subject: Re: [PATCH v2 04/51] PNP: isapnp: don't go on when isapnp_cfg_begin() fails
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: jarwguoe7r1ocymhjaj7a9qoogk4dpsh
X-Rspamd-Queue-Id: 9241D180007
X-Rspam-User: 
X-HE-Tag: 1793813666-139754
X-HE-Meta: U2FsdGVkX1/O6cJof+r14PJ6x8jGFMWgzEDhFaWCBPOGxsz+KneyeKLTI+2XM4wQMiAyKdneW3bJr1+4NYRs4yHhC9PSelIZHGq85uAacbilUDGGXvC62WpF7wg7osil0y0wfSuRN9TMJHPCqsSoPQ+J+vYSC8pEDBBH3zQcjIaNfzzFbhs6nGwk+VqyP7vO2D2t/RT3iDJjcp034mnSbpEV1EzF6nx2iSvSSLYQXoTg5qGpKguJILuWso0sThUc5o+TwJDTIRE3YswYXwD608kMU/CHmWI2erVRDmGxJDjlRJrMOb1E1IeLcks01FaTqgDkbjr4m9uSt7JqbMI+6yod77Aaz8FZGkFfS7MPtEMo8tFMmedrJV8MF7D/Pdaxy+g4nwoRJqldnzD72R9M0Wfit8Ye3PVa+sz9pqqLscsBDM9wk3pzzyGGEd04ybIDYnB6VO/e59BAEAc1MrYVJL3U2wfIDjL5PSh5F7rKf/vg2+GXVBrMtbYEpCjsqFXGRy43MHH/+iI9jiutzsC9bL3zszz+2G2Spw0DPrW5deEnWaJMsewXGKGx/qR2xQ/X8MszwnnlJ7PTwudIhryLP3Q7KKYKpzIQ18TaXXOTd+F9OGhGUVo7UDe1pQc77hX+62cpFmw34PDHaloByckJxPDD8V0Qmyfr6IVAZhsJQevan6jUNgtIewPjINSZCCFc/bSgeZmx44x+CkA7MzTnQD8VEKKg9+yJ8y8CgnO5vPcK3OZqeQrCjP+6ddBIP8KXsm4vxht/L4LDaLQdfFbHkIQA4XSReqCjcAQRXgKLKjq3pfTrPU2bajpAZx2+oN/T+LE1wTXvvYgYAP7twStQex5K5zpkemY81GgClSW22vudUE6nl3BaOTQlSQVyT4zPcNecVg8LpA+Le8FvmdFYZSAi7Rt4gKWKG9hxrOC1xZ4nK7GKNsXjf4n8V4vNCPYR/Pq+8krpQXyDQL44Ny0
 w7VKLiCx
 aFK79MrhTCNxvzW4o8Pn7ru0TMBXkZKR5YNqzOumiv1RYTln+Btx2Cu4ZCmaooq94KZK+HhGiB2xxTRoB55xoG2goS1p9Vj6BKvDohL1JaOiQdL1HTbIM7Q13fYGzPUbn4lAX+VIUtVN6CinnNJPncLKLeJlwHpGhBCVc6WuR5HfdJ2si1Q+EXLEktAiV50afXlidcrvBF/KqRs8B9eNivr9FV3LQawqDaDuEXTlv7Ukh3s1qAnT/meQEbwnBzrCbvlShw3/qwEQBNs13yNsr+5NaR32JFmE9tLvwS2WtJBgXf/1uWRVGIHEQAiA6Qb01fkk5brn9Gv20fte/4In5E3wUlouQFIxftDfItY0wP8R4vhAYtzy6OHrmiaF0yjQ+Usoky2zqCIwwv5Nhx5gER4Yj+TJB8uKuuzSFboGyAvAqpwFK6a90KOZV+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 6:30=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> isapnp_cfg_begin() refuses a logical device number above 10 and a bad
> card number with -EINVAL before it takes isapnp_cfg_mutex. The callers
> that read and write the device's configuration, the proc file included,
> don't look at that: they go on talking to whatever device the card
> currently has selected and then unlock a mutex they never took in
> isapnp_cfg_end(). isapnp_create_device() hands out logical device
> numbers without a bound, so a card with twelve or more logical devices
> gets there. Return the error instead.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>

> ---
>  drivers/pnp/isapnp/core.c | 16 ++++++++++++----
>  drivers/pnp/isapnp/proc.c |  5 ++++-
>  sound/isa/es18xx.c        |  6 +++++-
>  3 files changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
> index 219f96f2aaaf..3591a2791c1a 100644
> --- a/drivers/pnp/isapnp/core.c
> +++ b/drivers/pnp/isapnp/core.c
> @@ -853,7 +853,9 @@ static int isapnp_get_resources(struct pnp_dev *dev)
>
>         pnp_dbg(&dev->dev, "get resources\n");
>         pnp_init_resources(dev);
> -       isapnp_cfg_begin(dev->card->number, dev->number);
> +       ret =3D isapnp_cfg_begin(dev->card->number, dev->number);
> +       if (ret)
> +               return ret;
>         dev->active =3D isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
>         if (!dev->active)
>                 goto __end;
> @@ -887,10 +889,12 @@ __end:
>  static int isapnp_set_resources(struct pnp_dev *dev)
>  {
>         struct resource *res;
> -       int tmp;
> +       int tmp, ret;
>
>         pnp_dbg(&dev->dev, "set resources\n");
> -       isapnp_cfg_begin(dev->card->number, dev->number);
> +       ret =3D isapnp_cfg_begin(dev->card->number, dev->number);
> +       if (ret)
> +               return ret;
>         dev->active =3D 1;
>         for (tmp =3D 0; tmp < ISAPNP_MAX_PORT; tmp++) {
>                 res =3D pnp_get_resource(dev, IORESOURCE_IO, tmp);
> @@ -936,9 +940,13 @@ static int isapnp_set_resources(struct pnp_dev *dev)
>
>  static int isapnp_disable_resources(struct pnp_dev *dev)
>  {
> +       int ret;
> +
>         if (!dev->active)
>                 return -EINVAL;
> -       isapnp_cfg_begin(dev->card->number, dev->number);
> +       ret =3D isapnp_cfg_begin(dev->card->number, dev->number);
> +       if (ret)
> +               return ret;
>         isapnp_deactivate(dev->number);
>         dev->active =3D 0;
>         isapnp_cfg_end();
> diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
> index c1f6e6bd0eb2..b3abab24050b 100644
> --- a/drivers/pnp/isapnp/proc.c
> +++ b/drivers/pnp/isapnp/proc.c
> @@ -25,6 +25,7 @@ static ssize_t isapnp_proc_bus_read(struct file *file, =
char __user * buf,
>         struct pnp_dev *dev =3D pde_data(file_inode(file));
>         int pos =3D *ppos;
>         int cnt, size =3D 256;
> +       int ret;
>
>         if (pos >=3D size)
>                 return 0;
> @@ -37,7 +38,9 @@ static ssize_t isapnp_proc_bus_read(struct file *file, =
char __user * buf,
>         if (!access_ok(buf, cnt))
>                 return -EINVAL;
>
> -       isapnp_cfg_begin(dev->card->number, dev->number);
> +       ret =3D isapnp_cfg_begin(dev->card->number, dev->number);
> +       if (ret)
> +               return ret;
>         for (; pos < 256 && cnt > 0; pos++, buf++, cnt--) {
>                 unsigned char val;
>                 val =3D isapnp_read_byte(pos);
> diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
> index 3cadbf7cf238..de1eda5a0656 100644
> --- a/sound/isa/es18xx.c
> +++ b/sound/isa/es18xx.c
> @@ -1950,7 +1950,11 @@ static int snd_audiodrive_pnp_init_main(int dev, s=
truct pnp_dev *pdev)
>         /* ok. hack using Vendor-Defined Card-Level registers */
>         /* skip csn and logdev initialization - already done in isapnp_co=
nfigure */
>         if (pnp_device_is_isapnp(pdev)) {
> -               isapnp_cfg_begin(isapnp_card_number(pdev), isapnp_csn_num=
ber(pdev));
> +               int ret =3D isapnp_cfg_begin(isapnp_card_number(pdev),
> +                                          isapnp_csn_number(pdev));
> +
> +               if (ret)
> +                       return ret;
>                 isapnp_write_byte(0x27, pnp_irq(pdev, 0));      /* Hardwa=
re Volume IRQ Number */
>                 if (mpu_port[dev] !=3D SNDRV_AUTO_PORT)
>                         isapnp_write_byte(0x28, pnp_irq(pdev, 0)); /* MPU=
-401 IRQ Number */
>
> --
> 2.53.0
>
>

