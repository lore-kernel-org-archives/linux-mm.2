Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2987DCA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9F706B008A; Thu,  8 Oct 2026 03:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50596B008C; Thu,  8 Oct 2026 03:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F696B0092; Thu,  8 Oct 2026 03:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9881B6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:18:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35CA1160488
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:18:32 +0000 (UTC)
X-FDA: 85298606064.20.3C1BD4B
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 420D2C0008
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:18:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TLXyvmXo;
	spf=pass (imf10.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791443910;
	b=fThnDww+pm4fvvfh0xuuXG8iw/DbFhopqLL3SuWZ3pM7+u1OZCNp6aj3J85GIE4LtME40X
	Tl+n0ytvVwcEpAmNvI2VT2Q2F0I2IswKsTkAI1ndFCQFwKIlHT0kczHsNlEqOQMp+n2+Xo
	2PZngwfxu8PIVrfRwK0t75G/9YFqUDQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TLXyvmXo;
	spf=pass (imf10.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791443910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70ywZ2AyEe7ncaX3K+b5VsGq7joUvo2qDjp4zFNieZQ=;
	b=T+rKl1FQHF+i55joBqSIW+xdCMvma4N2NCyz+SONktayN3bk3fWH91/EsVVy/hR6Q/tcNf
	agmx4wo0fVauN2VpUVvtRTB4aDqIowfODAWl8dU3xk1iz+EcTifvLvckgAKLmwfueYUm00
	31oPEDkAeDmCebBCL5WZbDGgnnyv6hs=
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6df1eeb43feso1122592eaf.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 00:18:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791443909; cv=none;
        d=google.com; s=arc-20260327;
        b=jF3G8F3XE4fr2VL4OVdt0JiNNkTWGz8nr+EN3yjxYli/mwMzipXYhnRe0z+6n7BgWI
         PypRpFZOqcqxJx8lId7yjHt8naGR5gEE/F7PNZ5Pq7CsZzCvAJdIXz0245qYTs+w4Shf
         gZEBlsSVt5FfjX3uOlt70cbPBPn9IHP9gQp60GRbO29ecH2hR3miT/LsOB7zuFCwXVNB
         E6cMjUUnDZtagni5hxxORpkTRbZA6cclQApIerpZKiIEzmtU61FYpdQgEfs2/2gooOrS
         yQ4knDorTOrICXNXZewEXa4I4jYci0Nkuzrl8AkQpvG8F3/Bg/i8fId9ErPcTiFFN65N
         sQ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=70ywZ2AyEe7ncaX3K+b5VsGq7joUvo2qDjp4zFNieZQ=;
        fh=sxHHvApfv6JaquLnoX6x5Gd7RhnQhOViAjcX+2Kbxg0=;
        b=H88d4CQqv8PN52zXr+SYx6/NJ9n2XmIffdf6NS0e+cO17coaH0dGY2Ztf+7o0G28sn
         0AEH4o66fI40SW4fE5XIRQtJ6Vu9QKrDr1PHvoY581/eAYI1Abuo2HBvUP1N+VPpJFO4
         inDw9zlUix3BYQrHkdgNlx+Ap8kYiz/hb9K3YMOq1WchAIaIKE0tNIntVDzeDJTu4bFN
         W8s8pRQBNNg6FmpSw6SZ5x3v/T+fS42GwGnebXcM3+c+qkQF/ufVra68xF/TBkl48ECA
         stqeqfghqv1SQsYgk/mTPC0DmNrjW7pOUi1xaaJ7+zeBs1RyRXZ9qY2S53VzjYda7EcJ
         8vBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791443909; x=1792048709; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=70ywZ2AyEe7ncaX3K+b5VsGq7joUvo2qDjp4zFNieZQ=;
        b=TLXyvmXosy3/ugDnq/NGvI9bK4gM/zl9E26IMIWo7AEsWfmKmOHpPP7atnggSm23QV
         N9M2CqmErDJq+iUxRXdF+8t7kKzmUefgk7SLhMAEA8ZLn0t0Wt8DKo0x83kXF5H437Qj
         hDy3TagG/gVWZMrVh1JKIYafHYcM5/lTNFyTF3xho0TAuf9Z28qM0HeKpV+43PE4oDoH
         +IACXZTCC2pjEgyYnfd9OfS/4I/fwkWgHX10hMsnFtvtbqhQ9sL5Hq/eY/MOR9vmZiOW
         Ae/CBHpgnoHsdl3S9iu1oVG1g1U6ta5YpVFdUmYGuuCWwpYXSQ7bd1QtJ8AetSy/cxhx
         Afew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791443909; x=1792048709;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=70ywZ2AyEe7ncaX3K+b5VsGq7joUvo2qDjp4zFNieZQ=;
        b=P6dBEgKDfETJvopuEeox47fXQm12BEW/vaZo0fj+1RX4iGnD1p9oOdq/3WOJWAllLc
         G/XbCV1AhHdwKGgF6fLTgT9ZVLJ3H+PDT70ju0BRKcUddLnIBexk8dm8A5xlDxSSJeOl
         0n4bv++MPf8QO8KrJs6BhYwdn7caXdXiH88Je4/mba0cY0bJVDRl53ySb55wEdDTNr/C
         ZF7rDnZ+gnmcz5kPBPA+YKMG1pX7he7qDXbA8QLiBPpCn+qpgSC/0Ud7BOzSF0byaUi9
         yMj71ot8NODAXp9n/PFWbq6ylydf6PkR6/lqOjmM3zCNyN+Yt8muQtgHwzPiwLZW3Kt3
         0uZw==
X-Forwarded-Encrypted: i=1; AKwUvByJruQiB3TlX+UaQHuITzqRscQbUKvriLXogEMWWs+I3BOyBE+W4PGW4pD17Il7GyqAw0H7g14Ywg==@kvack.org
X-Gm-Message-State: AFuF++nXc2puKU+xvj952b61UYflM7GdBAT2enPsFb9Tp6+TLTU4pIgs
	0n/9Tb2kJ92Z9S7ROLYUytXLuYp+Wq4aY5E5uNP2CR6xRx335le/0NWCXoQu2YfmcjrZOSOEeSK
	dxHWPKIANCIyH7SKg3fIw/+YPuvoJaJc=
X-Gm-Gg: AYBFou11AEZFr3GB2LVf5tfZ1lEp7WQpyA7iVwHSC/Ag+6puvBFoVmEO7zG01S70XNl
	82rnDr51zGVtCe3mcdoJJ9pf/aME/A5zeo9PUlFy2qcZWyCTvY/dn1Q9vWAVwFqBOKCSL+/oqL0
	/0ofPHLSlWikpPsw6yu+035tB+E3hoT2UgWiz9WxPdmsWbeBhIpz1928yDiQ5s2lIplebIXYWzd
	lnACaFS4jBe8X43tiNF/h6/w4uTeiRtPpCGBSPcOD4dv9CMQpjBnnUao3itmSQYqlY7mTpI3fDC
	9tgiFAjai/eJlEPdvIN3wUOTu5arriYU3OeQCYMJVB8ePYnrMlHpOo5O18LY89MKJg==
X-Received: by 2002:a05:6820:618:b0:6e4:1587:d2b9 with SMTP id
 006d021491bc7-6e7aaecda5cmr4190773eaf.35.1791443909157; Thu, 08 Oct 2026
 00:18:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com> <20261005235021.GBasQ3vXTivT3NLbBq@fat_crate.local>
 <asU7svV8g2Hb5DZl@hu-ashoraj-lv.qualcomm.com> <20261008030603.GAascImzt4cv8Gz49p@fat_crate.local>
In-Reply-To: <20261008030603.GAascImzt4cv8Gz49p@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Thu, 8 Oct 2026 08:18:14 +0100
X-Gm-Features: AclHuK_Pa4PSN7Ovd8UjVYuZheIOrKSyX750Qa13rdRkYN_uBxTlt7ZeUcurB5c
Message-ID: <CAG4KcRLhN9=6xeT4qfqKLFdukiZLUc7akGcWwXJUU1-qrfxTUQ@mail.gmail.com>
Subject: Re: [PATCH v23 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
To: Borislav Petkov <bp@alien8.de>
Cc: Ashok Raj <ashok.raj@oss.qualcomm.com>, rafael@kernel.org, 
	akpm@linux-foundation.org, rppt@kernel.org, dferguson@amperecomputing.com, 
	linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org, 
	Yazen.Ghannam@amd.com, mchehab@kernel.org, jic23@kernel.org, 
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com, 
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, 
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com, 
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com, 
	gthelen@google.com, wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com, ashoraj@qti.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 420D2C0008
X-Stat-Signature: tzwb7cjmik9fgawybfqa8zar6qaypf78
X-HE-Tag: 1791443910-17734
X-HE-Meta: U2FsdGVkX18g6r+PvxRMw2SoxrWtVjUkfv/2hpTKLYZTkXGHVQdpD33wbdAt1yziiM82yzV6N9QoMOiJrkqVza4T+DO+0pJp16SsErpOppKyx2gTAp8V1SgII+VPo0NZKRYdqnzAatQQQ2KoSg3bdBpZOCo+R6VDOvS7gtNrM7fpFG8qBxruV3NITxX08wBO131Wiz3sQMrXWGpnITIhNtAdqslLNv5WCJOK2swQInInvRG3kkm8sq5oMfdvtvBrq6OqtgQU6rglNvxDx66LhiyHpLRPhzeKjsU3YmtcKx3SdHMhk5okMXu0RVeD3DYgFz4PZkj0sMQNJ8/qADRUWGSBaatrYWYTettahzHyacrnsM2RelovUAASGbw5r3Cb4yYC1zJidUr7C3Jx19f1dZ940gAUFIhF2WhXkFyRukfW5W9K0K+Fc4NOD3UGqZjL+ksU3PVgZOpYnWzyjY4RMnArv6N07gothZhscm0wPMNZ2OXmPQWcW1NZ4EZjBa6ExdmqgmMz7P1Wb3cuB1yA611SRCRyrKl1y1aTSevn2RwlQQVv99RQ0VI1FHb02zyTIEbYekxJ2HDEcCjJ5mrPAPiifo/M+Nu4jxZf+o3+Nd3zqZsZ+KUFO+Du7GJBQGzs3mT+wutSZlHzpivoEh3p+hp+VxflMVmEpaSVb2cns2sqhvnmqvhSBH29yVVffQU26pYZvfzPuDcm6a7m3yCBokvCQE3ixTh5hVywdW4fsUS5vBD/ka8plx7T+evnM34VLMdsGBa4UnKqHz99QxnRkuEHJmknBIt6jStV1SWHRA9M515FPndU9YvyFQT0e6q1GEj0ZV2YrIxdXtfzJD5dHnBTdQBYaf89RAYmaUWn294y4n+P3W0PXFEL7LH10FghaC0hv0xKRz2+dmkqYsNs1sURkO2F4NNrzF058qtjri6vUEAfcg8bYINI7ZLfcdye/AEJn7Qk70f+ByMvLd2
 Z1w2/aNE
 Gm6pAxEZuw0nDCATYkrIT7m1mqrIPcOfueP4TfMWgL623bc4R/1WJt/gu5Ujjt4PKwy5zXd8m7c91cYpVuPwiw7cMmO5XgozUhp1flzG7mEklUC4CziWlM8O/Mq0if6/DuFg0Ua0M9qRCIOImGjpRnW5R9+MWw0wkRWo3WgRJ+iRAcqIGpHmZ6ZsbK6IA6DHVOqAQDVLF6ohi7aq0NNPWeaGTh37oDBjzbwAkVJ4JTc2MhPuyxlccPGb54yIUsi219urxjWmg3EkkUv+eJociasGwQUCep4JE9FbdFzb7ZjZDM0dLCAWOrJ6ED7klJ9ypkg7fIqhKm/T0amwpOyshLQVDXs270laWjOZpSy/YQrULkCi/ash9aV+xsR5ulyMFGzazh8uuBYUFIbDAV0qIK4SdckPbdxZHYEthPF9tLqT7WWCf6qYQSpSRkngD9tPoe2BErD89O6ATLOUENSMqmqKk0gJYW3sIvhH4arZkDb0eAcen07Qc5s968w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris, Hi Ashok,

Thanks Ashok for reporting this issue.

I debug this. nows_txdone used to set before requesting the channel
until v16 and was changed in v17
following a review comment by claude.
Found this issue occurs when txdone_poll set and  setting nows_txdone
before requesting the channel, solved.
In my test setup,  I missed this issue, because txdone_irq was set in
pcc_mbox_probe()
with the acpi pcct flag set to ACPI_PCCT_DOORBELL by the firmware.

Thanks,
Shiju


On Thu, Oct 8, 2026 at 4:06=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrote=
:
>
> On Tue, Oct 06, 2026 at 11:19:30AM -0700, Ashok Raj wrote:
> > > +static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int p=
cc_id)
> > > +{
> > > +   struct pcc_mbox_chan *pcc_chan;
> > > +   struct ras2_sspcc *sspcc;
> > > +   int ret;
> > > +
> > > +   if (pcc_id < 0)
> > > +           return -EINVAL;
> > > +
> > > +   sspcc =3D sspcc_get(pcc_id);
> > > +   if (sspcc) {
> > > +           ras2_ctx->sspcc     =3D sspcc;
> > > +           ras2_ctx->comm_addr =3D sspcc->comm_addr;
> > > +           ras2_ctx->dev       =3D sspcc->pcc_chan->mchan->mbox->dev=
;
> > > +           ras2_ctx->pcc_lock  =3D &sspcc->pcc_lock;
> > > +
> > > +           return 0;
> > > +   }
> > > +
> > > +   sspcc =3D kzalloc(sizeof(*sspcc), GFP_KERNEL);
> > > +   if (!sspcc)
> > > +           return -ENOMEM;
> > > +
> >       __mbox_bind_client() reads knows_txdone at bind time to promote t=
he
> >       channel off MBOX_TXDONE_BY_POLL. It must be set before requesting=
 the
> >       channel, otherwise the channel stays on polling and mbox_client_t=
xdone()
> >       later hits the mailbox core's "Client can't run the TX ticker" gu=
ard.
> >
> >       sspcc->mbox_client.knows_txdone =3D true;
>
> Yah, I can see that happening but I don't have the hw to even poke at thi=
s.
>
> Shiju, what's up?
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

