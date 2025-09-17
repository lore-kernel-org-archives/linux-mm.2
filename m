Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E20CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59FD8E004D; Wed, 17 Sep 2025 11:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0AAD8E003B; Wed, 17 Sep 2025 11:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8C58E004D; Wed, 17 Sep 2025 11:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80F628E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:38:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40498B726C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:38:48 +0000 (UTC)
X-FDA: 83899149936.30.8785CB5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0851940005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:38:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PetwfhXR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758123526; a=rsa-sha256;
	cv=none;
	b=B8cYS49myCq24EEa3Z3onzH2+58K54Nf4+4nFR1KdsFTT7go7CXSGcIMKNNhqNLzkI8Lo5
	SkvKubB38VH3FRjTPWgTbUUoVp8ySn/rJJBwNrNXHIxRgmMAuvtAA2nGiIlADV2o0L6SYz
	3CZ61wbpCqYStrcbCp0EBQbt7cXADJQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PetwfhXR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758123526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzDrhoqrJLVBFYiFwQ2SZoCYFfAfOJ2dJ5Nixz692Nk=;
	b=qXrGKK67Wek7ZLR4Kmiq4e2RcyHhDyaa9CWZdP2wdmUtN/zq5e8KIfwL2rR400GYcKP1Lr
	VSSYnwo8mNjKryObk9QTcY+fJ+AdosdJeFbSQVuRL1J4arOPAb3O2YcXznoj5IOYDXAsMV
	cdkhBQEZZ8wHycPsteZPdlx5CwLWaD0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758123525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wzDrhoqrJLVBFYiFwQ2SZoCYFfAfOJ2dJ5Nixz692Nk=;
	b=PetwfhXR+TDzbJ3xaks7gCQOhKxZFCW1DE3hRDk5VR1gon7CNWmoPp7+tmOmCMmf5R3l67
	MpuRzZMLIFZB8Rhlo6ppCxCbBFS0KLv1xz52ytuidqNA0raD8FsKsKGw+KFam3E4M7T13f
	AMdg6D/ksYDHXnyQu5PnpR+QoSaKzhk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-6xo1XWpLN0Kk9h1PTvHz9w-1; Wed, 17 Sep 2025 11:38:38 -0400
X-MC-Unique: 6xo1XWpLN0Kk9h1PTvHz9w-1
X-Mimecast-MFC-AGG-ID: 6xo1XWpLN0Kk9h1PTvHz9w_1758123518
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4b5f112dafeso161394671cf.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758123518; x=1758728318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzDrhoqrJLVBFYiFwQ2SZoCYFfAfOJ2dJ5Nixz692Nk=;
        b=hNIXxc5AVGx7lnQRWUwc7qvzm6e8IPB9b7i4XeBq5/1z1yXs5qaCjMVyTndo96njuI
         Hc1J5iWUCcnvdtMl9QJCKd2DzFEtFhsZA46PkYfx71iL7T0jLO/O5AvcMTWyWDVgiMDp
         /OZYWgVGtvsHg2qlF2jOOjN1ntDIkKyK0TAAkjgpEa3nxIogMDG5Xeote20UowX1bS+T
         41I6lNf/EWStnXLNKW1bFoZfqsuaphZIN0Bj6WPYaSv5hmEZzdHW0RP1tcx/zrgoSn/r
         yeCuy+ymOHHI1nFQLm5eTSZkVDwwdOeDRhp7HfzTASFUn4jkux8yHP1yaOkus/CJT8gC
         VJzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4XasrtVlE08vBFSzkEUIyB2lcNSMYi11RSnETTVx4awkvbjlth/oOOmfwQt3xclU14ky7eKQPaw==@kvack.org
X-Gm-Message-State: AOJu0Yxs+bkhFUkwmqSG7HcQVn3rJpSn3Y8Ow3lXgJWiIkHCvGq+Dx9E
	ZK1AUpGFOwf+Jze/hx5YpRQxotKh/NoPR8ZUHbUzBopXOJW3O8Sdg/AFETut0WDnG2Qtl9u397x
	c6r+ihqCYBfpR7pVWQ3sFdmKQPB9S8qDcZL/2ko5jo7ER2tM+eEqMP473w9gRvqLicqCQAgV8G5
	HSMkexhe0qEBzdGOnRR2QBMGIPIoI=
X-Gm-Gg: ASbGncut8bfryC/6QQYzKZdzu1fznXEiPhLwXr7dWZsJk8+YoLqwdlDV1SO/jAAwAEQ
	gWP9UGvSLs34/qfts2k+3Zt8ulSaBnH6oeCb9tf3J03F8QrxQNkgJOAfukiblE5zkOhRCzY9otz
	Cwpiaxhvwd5id+G/CkH1Dne3E/JJzI5Et4TLgvlN008mAssViMc1VeKQ==
X-Received: by 2002:ac8:6f1b:0:b0:4b2:fdda:f7be with SMTP id d75a77b69052e-4ba6618b9aemr26320401cf.3.1758123517637;
        Wed, 17 Sep 2025 08:38:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPZbhJSMxuKHfrTjKxJCkJbacm2wHdKQT9Bzco4e/BiqN9eL3IFcF/vIvKnAOF3my7lb81Pi2uNb/6ZJFMKnU=
X-Received: by 2002:ac8:6f1b:0:b0:4b2:fdda:f7be with SMTP id
 d75a77b69052e-4ba6618b9aemr26320041cf.3.1758123517106; Wed, 17 Sep 2025
 08:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <20250910170000.6475-3-gpaoloni@redhat.com>
 <874it3gx2q.fsf@trenco.lwn.net>
In-Reply-To: <874it3gx2q.fsf@trenco.lwn.net>
From: Gabriele Paoloni <gpaoloni@redhat.com>
Date: Wed, 17 Sep 2025 17:38:25 +0200
X-Gm-Features: AS18NWDxjPkZ_bdK-V6Pzd1fFU51OydVEbc_fWStALboJrBYI93hRwf9Wba0uR8
Message-ID: <CA+wEVJatTLKt-3HxyExtXf4M+fmD6pXcmmCuhd+3-n2J_2Tw8A@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 2/3] /dev/mem: Add initial documentation of
 memory_open() and mem_fops
To: Jonathan Corbet <corbet@lwn.net>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	gregkh@linuxfoundation.org, linux-mm@kvack.org, 
	safety-architecture@lists.elisa.tech, acarmina@redhat.com, 
	kstewart@linuxfoundation.org, chuckwolber@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D3ag5aNQHUzTAxOTF_WLw0GPGEpGdDXDx39nzfoewAg_1758123518
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0851940005
X-Stat-Signature: 7pf7tuds6gdhjm4dji989strtw1m1591
X-Rspam-User: 
X-HE-Tag: 1758123525-976135
X-HE-Meta: U2FsdGVkX19rGyRbUYxqjaKHhEZbPH3b7GmR1HEVNJGxQTsCwuizX81At4x+SZG+rcIjnYMVmNXGAc6MPagbTTg8U2Ga0BCmWMPLqkZSrhvs3UPRRGqFPNH+/xMDVKmws+DR8t2VQiDIPOqIm4FXb4HilAGzFstqwW8d1DHKu2pN3MNgPZt65goz31KHrcC8hJIfP0DsaqOXfGN7dOxdY+Mj/bY1Q+nX47RnKuGVACgE9Ky9CLs1BppqkNXbs4UF7PiYX9Hcsxfu/v3/RTIcliqYAjO+Dm28P6mI3qOSrk4d+1nHEz2A1sbXFKuc2qdFoLi7yeptItZpTHZcvVhCoqNYEC13D/x2kgyjEadintSsmmC8JGxmodvqHf5tIPC4X7bOAhGpPPP05fg92Px3jORdzffDF4XKjSVXxvZumPoqDeyV72WTyGuDbPDWQUtHZ1/PfinOJifB9dmgCQfylTsu47yS/qhC0UCbPADTnNx2zHyCImh3mTXn03ooDQ6Fl5Lek0vt0Yviu4hCSCY9xj1lgCJmXWGw6ZEjMX16xzjawu/nSWMmW9xPgWJHlmzVs2AuwiFPhdoF0m4oyEISA8jYaPXW60uTZ+fNnYns5l9VBeZZOeTjA5z47pr8sMrPs4tamb04EApSlhWLfHCTwmoS935nqqeeORBcpPDES33kxcWa5PmAS71w1+2Y8DY041RsqB8ANweyUKc82CQZAFBiZTdodw92KyNPe8y4yTqrpV/cpsdibFTGnon6dxVSN20rUdAZOnZsY4roWcZMmtRltU4oNH3MDdJ3aidLydyVKcLJ112wukr5hqIMxyQagkMvArAOzBhXsqQjGP/YeptfTuDJwe0ZKqbY0ke0T8RPp1fsf67FbNZt+nRGqM6E3PFJ8r47wfkcUzCUnlf+uxg6XTEx12B0BuPvEqC63qMJWq32TQmtUNob0vV8qA6hoxr9mHCkvOSNW43LXf6
 WG6bXMMe
 h2+gaOrqzS2Imb1y5PkRNKbrdprysQ07jM1Gvua90ZgC/WXlNDe4kdj8yTGWa4agi7YBetHr37JjvvcQcDV31BLygXpagWSStkcyVsz2SQ9yQw2uBc2ixvQFlfHD3DT36FLiXDtxJOX599ZurEgTSgQYXLtE8LB3+7KaFdvS+Tp1f41TH9kUypN0LQpivZStPcgFeBVfP/Z6h0I1rfhbkRLY66TdV5ekSOqqSCbJdSF8ivCuu1LMywQvf6s1TlyCntjTMgHy7dEIUBZ2+L0CTJhFQELBfKcDHBJnHiMFWCcCkUBKCeoa2Y4JLrpIsDYKZ71t9jHsNBa/g9BWBFXikRAzy1HGNfXzxGURzP6ZYH6v0oTzOB9X3PjtQCk82GwwyWZraRGb+NDs4ohQGIWfrM56FRAKINuBFIPsY3RpBnUrl5bWhlNF6UArbkZ2Qlr6eTXLylBh8e4fBkeGNZe2eisOrrKt4/0z6fUVZxk3HQbHOhKbnENBBvL+ogPad0mkNoKPH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jonathan

On Tue, Sep 16, 2025 at 12:39=E2=80=AFAM Jonathan Corbet <corbet@lwn.net> w=
rote:
>
> Gabriele Paoloni <gpaoloni@redhat.com> writes:
>
> > This patch proposes initial kernel-doc documentation for memory_open()
> > and most of the functions in the mem_fops structure.
> > The format used for the specifications follows the guidelines
> > defined in Documentation/doc-guide/code-specifications.rst
>
> I'll repeat my obnoxious question from the first patch: what does that
> buy for us?

I tried to explain my reply on patch 1

>
> > Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
> > ---
> >  drivers/char/mem.c | 231 +++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 225 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 48839958b0b1..e69c164e9465 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -75,9 +75,54 @@ static inline bool should_stop_iteration(void)
> >       return signal_pending(current);
> >  }
> >
> > -/*
> > - * This funcion reads the *physical* memory. The f_pos points directly=
 to the
> > - * memory location.
> > +/**
> > + * read_mem - read from physical memory (/dev/mem).
> > + * @file: struct file associated with /dev/mem.
> > + * @buf: user-space buffer to copy data to.
> > + * @count: number of bytes to read.
> > + * @ppos: pointer to the current file position, representing the physi=
cal
> > + *        address to read from.
> > + *
> > + * This function checks if the requested physical memory range is vali=
d
> > + * and accessible by the user, then it copies data to the input
> > + * user-space buffer up to the requested number of bytes.
> > + *
> > + * Function's expectations:
> > + *
> > + * 1. This function shall check if the value pointed by ppos exceeds t=
he
> > + *    maximum addressable physical address;
> > + *
> > + * 2. This function shall check if the physical address range to be re=
ad
> > + *    is valid (i.e. it falls within a memory block and if it can be m=
apped
> > + *    to the kernel address space);
> > + *
> > + * 3. For each memory page falling in the requested physical range
> > + *    [ppos, ppos + count - 1]:
> > + *   3.1. this function shall check if user space access is allowed (i=
f
> > + *        config STRICT_DEVMEM is not set, access is always granted);
> > + *
> > + *   3.2. if access is allowed, the memory content from the page range=
 falling
> > + *        within the requested physical range shall be copied to the u=
ser space
> > + *        buffer;
> > + *
> > + *   3.3. zeros shall be copied to the user space buffer (for the page=
 range
> > + *        falling within the requested physical range):
> > + *     3.3.1. if access to the memory page is restricted or,
> > + *     3.2.2. if the current page is page 0 on HW architectures where =
page 0 is
> > + *            not mapped.
> > + *
> > + * 4. The file position '*ppos' shall be advanced by the number of byt=
es
> > + *    successfully copied to user space (including zeros).
>
> My kneejerk first reaction is: you are repeating the code of the
> function in a different language.  If we are not convinced that the code
> is correct, how can we be more confident that this set of specifications
> is correct?  And again, what will consume this text?  How does going
> through this effort get us to a better kernel?

In summary specifications provide the criteria to be used in verifying the
code (both when reviewing and testing).
Otherwise:
1) Developers and reviewers have no criteria to evaluate the code, other
than their expertise and judgement when they read it;
2) Testers would write test cases based on the code itself (so it is more
likely that a wrong code is not detected due to wrong test cases).

WRT your first point, if specifications are wrong, a reviewer or a test
would detect a gap between code and associated specs, hence leading
to process of scrutiny of both code and specs where such a gap must
be resolved. This is the reason why the duality of specification and tests
VS the code being verified lead to confidence in code becoming more
dependable (also from a user point of view that can now clearly see
the assumptions to be met when invoking the code)

Thanks
Gab

>
> Despite having been to a couple of your talks, I'm not fully
> understanding how this comes together; people who haven't been to the
> talks are not going to have an easier time getting the full picture.
>
> Thanks,
>
> jon
>


