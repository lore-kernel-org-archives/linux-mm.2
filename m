Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D53360A3817
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Qs9PPuzO
Received: by kanga.kvack.org (Postfix)
	id 2B4D26B05B1; Mon,  9 Nov 2026 20:22:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266A66B05B2; Mon,  9 Nov 2026 20:22:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156C16B05B3; Mon,  9 Nov 2026 20:22:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E19DF6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:22:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7032316039E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:22:00 +0000 (UTC)
X-FDA: 85417458000.24.E970943
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25ED3A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:21:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Qs9PPuzO;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794273718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
	b=iy/eI8nwA4kUswez+JyqA9873SM0e8PrLjkEpoP+zfO53qQlPqgqzCIN1YJbFKbZ1/p35f
	9iqUYFtMP6XOmvNAXQfajVpRHA98IX4sR6JNlH96941lf78+UiAJHyYwPjyyPo9X7plm5O
	3mzYWN4M4GR+dyvkk5pBMAOFSUrkipM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794273718;
	b=PsZouWksa3IUHZ66EhSSGu6DlnNTFBJ2DRPBkq1PgwDJnbD4PiWLy110Mp7+E5us4o8xpN
	wbuja73mrD6R+bijHAkb1LyR5A0VAhTGmNEHX6o+qQZQ0xQqxEDhMLK//GggtPo2iplrGn
	tMlK4pZ4WWL7Jy/gpTF4uQgeiJEc93k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Qs9PPuzO;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4cdc606b47so217288366b.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 17:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794273716; x=1794878516; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=Qs9PPuzOVQd93jn9U8w/fg7q+td041+8qvrcIHOFHGrpdcKDbQ69OThRbb1Qv131fk
         C8digJsq8Oqk7GsZG6FqrSAlBuOw4gZ3G+XdAG3H2C4uVXwdVCf7hGLgIHo+x6gn7XDO
         5Ri5DWnd8KZrEjBvbCbbtOeDaK/kQ+5QuxPWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794273716; x=1794878516;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=sPxaq4cyQ3IiVpLvtomFoSFad3thZkvUob4yEbAXlRSn0Z0V6PrUaG37VIlQBmiIM3
         fpvKhlwm3ALgTJYwuhl6jXk09nEqVh9AVCFXF+31iSz/dxwnBy36pLfQSPnexsHRcydP
         r+WoE/I/4gLq1mjjr16lTrd4j+ycWac+UP+g3D7S9tf9drdD16dGLRYIK/HN8ReLp2kj
         ExCWTCg7UL6aLtwieMtkOkQf1AsWsR3498B5DvxkEpY03r9vK2t0+5nbJ/0FirTQelGy
         a+xjEiGMyBsbXjOpOK1OZxkN5jmF8TCZoDDQAn4ZaLcXqRBe0QYoRQZ1QsOCaZ411Rm1
         Cabw==
X-Forwarded-Encrypted: i=1; AL+hErH4ui6zNBoCY+7Sh4Pyx7cmbnI9jt24RbVoZuoDvc3Q74Tgtm3zYuH5h6FZjGRfMVX9HoRAXWWR1w==@kvack.org
X-Gm-Message-State: APuU4Z9lBD+XW4y9GF2t8cK30ozDLEEM1vpSZVq2EGzjtOur7cSdN4UE
	bMksNrWj4K4vDSE3fJBhzF2bSK98GUoKVrqLiwnMoOXEJLKXeWQxdteHBpqzExGyPaddrf0QLvj
	yWPS7pMIS0Q==
X-Gm-Gg: AYBFou2HAt4OYGNeIuxFLx4bULi4VppEqUVEaAYSsX2Mn/53IQCNiuIqotv2zblT/cN
	cECG2XvMWw5WrYC24lJGJ4ULh/HTsHQCEbhZRX/kWKdXIzsVfZDbIl+uyT7ZktfKKZDIk0/PXuM
	YuNtHV8SpFcZnY71XfBJ5H3mtgNdU/WraAJsBf14xJwJ2N7hD//DPiMkcD13pVFZyJZRutxIQKU
	QRBQpMLbUq6RBXWAZt5ACjZ7ExWT68T00Q18oDnLo0Rfip8rEZKbmzuUzdJycMEI/CnGmGDXLfg
	dLDfOhtBW4VyrIKdGdcXi0F8qX3ozKN2fnEA5m2nqMT72LV7rD0KpPG+dYiNx0B8xdhX3K/0Ana
	ez9YDEBmdoXWnmbmppWyUbXCFYyLcO+lHLEM3wlXxI4G3elp2isUJFVkyqKGNgxAmOLxQOhGUUH
	22bdKBEOU68YyoYLzMKAleKJgEkpVI07sh4lHqmu0SjGbWJTvxt2f339dNgGlzvn4bP5JevsDNl
	x0OuiyVCnTKDlKih2Qw8j7L4BW2NhWewch9YcQmXg7H+q47npAEY50ZfxWaTuS3EmIceWrn/4cA
	C9/w6IIcWTLq7ij4Yl67F+SeMHbLO6ulP6ESoH1nHaV9iJxP0pT2TFcx+FxGGbSAcUHMOb5DJYQ
	V5A==
X-Received: by 2002:a17:907:7f9e:b0:c46:645f:cee2 with SMTP id a640c23a62f3a-c5049451e5fmr89537266b.4.1794273716402;
        Mon, 09 Nov 2026 17:21:56 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a658fa6sm40390666b.69.2026.11.09.17.21.56
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 17:21:56 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4cdc606b47so217287166b.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 17:21:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFtzdvytJjEWuHCmMBZKxcVkxPtr/qyDFrcsEjTn1T35jjluzAKDS5+mUwHoV2nAgSznUpOunohKg==@kvack.org
X-Received: by 2002:a17:907:9451:b0:c41:1750:59a2 with SMTP id
 a640c23a62f3a-c50495dfbd5mr87253466b.12.1794273275844; Mon, 09 Nov 2026
 17:14:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
 <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
 <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner> <20261108185953.28054fb3@pumpkin>
 <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk> <20261109214558.0d9d5228@pumpkin>
In-Reply-To: <20261109214558.0d9d5228@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 17:14:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
X-Gm-Features: AclHuK-x8jcOOQUqd2amGoGEAKER9jIFGaeL4LxxWAd0cGV7dz_RR64PtDogpPU
Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
To: David Laight <david.laight.linux@gmail.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, Christian Brauner <brauner@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
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
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 25ED3A0005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: scqwzh19sfjbjap9mehpyfzsqpjobdpc
X-Rspam-User: 
X-HE-Tag: 1794273718-101531
X-HE-Meta: U2FsdGVkX19Lv182feefGoZbMy76h2m6NniKNSDdD0Zc4Rs2YW54mSvMoDsRltWFZ3ysrouvoImbjr2Ch+cFBCqajcJK0i6KxroU+WzeDyeWYNRQTfYwrwbBgxZ9Q/dDbz3ljwUZR2+dytQCMbqfp4aKcTSZXrafJgI55z3TceP2K5T6Ga4EAm7qf7tMzEKcPj4by8KZXGa8w6MwCPIuV6sskYXehaEe3+D8rovgDs7JYOueyYkNVmmpYNfZ09Ixvvr646chi9TiEAw988PJt5JlldCAkOWaMeeEmDUgZK2Q4izXXY8+IbzAKIh5RVEPz73vzK4VBblPQN8LvRkqGLovaUAdJtNzRZE3TvbcBYi5fAHlamEcKNK2K9nBGEX/2kdyepCsXr2yIxmplq35XEIuj/cdPvkFiWDIoXfO6m7tY6EDRduTx3goirD47e6KkmxCUGfiBZ1QYUEDhEIB0L7BJDrzgxZ6AwX985sKargpDvJoe9zTAT8EWGdU9PqyEM/FVZ4qv4ODqP5ITZritB3lq/aXhDzXfXM4BDnyuPhVeuj1msq39mKJtr8ZxT30wP7gg6sb7IsOlEBBpILZ05IUYp3lvau/NSKp2E25RSiZPbDVH5n/5EfxsK2x0yAwNfua1h5pA4i5sqb2LlF1rBHi+8w5w6IlNllDsjJDR4EQuUA9ByprWV9bRnUgu0N6bneGpUn9HatduxDzVwxwKrFKgR8R/RiG+NfI8llX28OrkOekeNILQuapFAjSe5xjIoE5c7ZthDBFRBIMbuayri3IyrndGBY/4wWfzCzRxn0qAy2eZmd+mLX97nArzz39dWubWuS8Z9Y7cmE8XHW4TT9facGFsR42SHoUu+1d9RmmGD0lYvZW4hXsS8M1d9ulzK3pMxCBfAE7eSIn+T6SieBkof8t7guNpqLo8qF8rPH7O1OCumtgC0zvtcTa4OtJPeM6rALX8whrk2fI4xv
 NjufpF+q
 LeE1SBhvhADIX8MzIo8Ac9ZRsOLuevUiynVsOgUHEd36p4llRLX4WvJQ7S4w2Bf8hNHwM+v45LEBbbb3qoVAsF8dwFeoHjd1EebXBtzGC1KTeqn9fq+0wVABTLhTxy11SjMBkwQwZYYCn7Zx+z1duTqpH5/pV+2KxHyJREzBsI24vYn4fCoTLmE37coZ6tZpsENyi5aJYbOf7lhu8n3hsWK1FNtQ+10VKJ/1alizIMipmbYmj1tzs1jqEEhXEN0g5ylQNZJaKiAC+63Xuu4cq9Y43ggSSY6hmaVP30u3fonaHdkElYb4MBnoHVQOulnuN4ny0NYEjWDz8ci2XSSmZd67lcHGBMqKJddNFbPIJAjVZet0aOmrzQQRZqk3jupZ8qLQ91aB0ZABqlSzfhy0N7pijx/5PfSMQx5NtbfIV3ZVsV7aZAEUqheicqTDrrQpA4vlresDGzxRpEwz26x+Ub34axudD9qr0WP6yupL1CNQGbYw9BLRjsrMe7SsNBhr01GVhc+kplD7x1XPPb6QcPCSbzWVxHhdmiVuwygKtGEZT27FF65u4gh9T4/5wOmdEg68k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 at 13:46, David Laight <david.laight.linux@gmail.com> wrote:
>
> Just that the cast would have to be:
>         u8 *foo = (u8 *)bar;
> where 'bar' is 'char *', and I don't think you need a cast there when
> char is unsigned.

.. and just to clarify: 'char' is always unsigned in the kernel on all
architectures since commit 3bc753c06dd0 ("kbuild: treat char as always
unsigned") back four years ago...

            Linus

