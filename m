Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F34606A33D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBD586B05B5; Mon,  9 Nov 2026 00:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46CE6B05B7; Mon,  9 Nov 2026 00:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D6C6B05B8; Mon,  9 Nov 2026 00:06:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C22B6B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:06:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 050361A05CA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:06:02 +0000 (UTC)
X-FDA: 85414393806.10.1619739
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0BCC7180004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:06:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=none (imf24.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794200761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+UmCB5muc9jAh5/NVu2M6h8Lcfrpgge2sRUuegusfl0=;
	b=22qOYa4v5MlD43rH+g2PXYcxast6TOtszOOn7Xv8M81Qyh7ytFZO0cg1USarjZx/tOUpIP
	BNudn1Vb5sd1M09xZlFWlICC3d0UyF05HEC+IfbGyc0P+ToUeE0JFot7B+o7zWTEc5gdC/
	NKIfzKiHElVlY/oAv5Fa2yF1IEW0Sl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794200761;
	b=owUUj0kmEoBVshwL4b3C5UyBDVjtuic6h6dC6JuwYxugd99dss637eYiN6NKhFUWp5iVp3
	j0ta03FOKsgwY6vboyR2WTICDd1/ryJCkmpmR9sTlrtt4UYpMlX435nZhvwCt4E0Ek3Kyi
	AJnQQGEroGyZhD+51Of9eHbNaOiZZCA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=none (imf24.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id B42DD92009C; Mon,  9 Nov 2026 06:05:57 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id B0D2992009B;
	Mon,  9 Nov 2026 05:05:57 +0000 (GMT)
Date: Mon, 9 Nov 2026 05:05:57 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: David Laight <david.laight.linux@gmail.com>
cc: Christian Brauner <brauner@kernel.org>, 
    Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
    Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
    NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
    Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
    Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
    Greg Kroah-Hartman <gregkh@suse.de>, 
    Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
    Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
    linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
    linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
    linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
    linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
    ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
    coreteam@netfilter.org, kexec@lists.infradead.org, 
    linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
    netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
    ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
    linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
    linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
    linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
    sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
    linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
    linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
    linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
    linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
    linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
In-Reply-To: <20261108185953.28054fb3@pumpkin>
Message-ID: <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org> <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com> <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner> <20261108185953.28054fb3@pumpkin>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0BCC7180004
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: 5yjo61iqsookxxkrb9pe664nk1zn5i38
X-Rspam-User: 
X-HE-Tag: 1794200760-785861
X-HE-Meta: U2FsdGVkX1/61mfSVT+1bsuI3+mu7X3avbWqSn2P3MnxXC0qfVhQd/UiLhp2XJrQrpea0rm7w5ExA2iIY7yRtY7yK3DsAyU4LKHWtHOZey+DqFZSXx1U4tRaaFUQnJ1y31bSKmCsKVIUt89clf8ILgoCbZMJClvoj2BYId22v2V9qm6saJfrkVN1zlnOH3izwdd0qn1HYB6sxzqj5B2UbIV1KgEgSjtjaYNA3jrl/DpM+3P10q+ji8buoN8AqIrHlZeeejsrx99qfQxOI1p4kUXjDr7JDU187P4jZlJRHxCZz7lKZgwulE+l5Qi4vpERNjRJtKNnjwbtWf90TH6VMwW7yLq5+tRh6zstsgPCwG9YeicWG6L2OUVm6ePqT9h/HCWKpFYz8uT/pZSNOvgEMGzq2QG6dsgSmpjME9SwZqNTW5AtaziNRQJHLow4xCtiDiuezETNiEaVLuyMJE40XcA7LKiN60jYclCLDuWuV7HmOanbPPQTO3wXu7i8kwGB3gKs6sUcEGh0gsEWtybu72FVIB4+zbvDkZicLqJD4vv6QZEWzRUea7gunksgEM1r4/zThQ4bF2QxKF+5KOtZU+Lt8MyGD7k8WG6zDxlYdhdTsM/z6H3mQwa4IMKDQ8Ea3U2p1M5EF/JtpS8Z4AiqEz3eogBWYdIz8DofisXXL0sNbBYBEVc582YEuWSjvwpenqYP/cMieTpO6u8wa+8hagEZ+3spNywecVf1CQaDZIQ1wL8V4d/KYTe921co8tt6B+VayYCSz30G5eC/YC+LLtMZeoLIFedNlfd5vH/MA+mPHUohx8Ix3IT5AFJ66GaRzPM1mL980d1ApTsKJU/26IU7COTJ16F0D+naV89g47DQr1L0d47egl7YFJ15brUAtt5uDNbgPCdQxw/wI39O5u+1m4IskR5ighu98LMdYhaS8zWC8CYmHQXE1iYm2fxxJn6L36DKzC5CRKTrBPH
 8Vi98cfh
 SE2+rg6y44hD6Fx7lZIV78F8PrsTvku9VFRXgApKOr5JM7HmgnCMmDOChJlkPMlgG9uOoBWrwYnacZTTsoPOuzirT+RmB1yrClQkeBByIXjk7o4uAdlBv75edHXFFexMp4HeIJXM9Au2gTTpYVNNsY/i60IMCnYLgocW98FecBtN3XlRZHAuH2GecaOCt6Cmhji9bk5BxNlACHnBdan33Bv1U1Y6PPxC5gmlyJY5GWRndIhMadMfy+BaNmYopfM7buP7y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 8 Nov 2026, David Laight wrote:

> > > While at it, I think it would be good to use this conversion as an
> > > opportunity to replace "char *" by "void *", which will probably let
> > > you drop several casts from users.  
> > 
> > So I tried that too. The thing is it drops exactly one u8 * cast in
> > ntfs3's label write. 
> 
> Since char is now unsigned that one isn't even needed...

 Please excuse me missing the context, but what circumstances does your 
claim refer to?

  Maciej

