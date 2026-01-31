Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995E9D46C1D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 02:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E1C6B0088; Fri, 30 Jan 2026 21:09:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F2D6B0089; Fri, 30 Jan 2026 21:09:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540C86B008A; Fri, 30 Jan 2026 21:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4331A6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:09:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0BAE160704
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 02:09:15 +0000 (UTC)
X-FDA: 84390626670.06.40C05C3
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id D26FF1C000B
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 02:09:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jrc81WUb;
	spf=pass (imf18.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769825353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXBSGIys3SzCpVetTGHBAjMTb+eZCN0LoIysZIFKUFQ=;
	b=FCTiQlQlvYFSK6ObL/E7i/3E2bahStqHKm0E113edKm6/cf/ADC8Oa65f8gHbBeXkSXCK+
	sThPQMpVt782XIglJs5O3DjFFIm/1j6nbE2WnQdyQ2XxNdXfoQ8aIsHFn3jQNDRqreQ5I7
	CbPjkd7O8TfRJA7y2LyZQ8UimXlv2Vw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jrc81WUb;
	spf=pass (imf18.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769825354; a=rsa-sha256;
	cv=pass;
	b=6aLth3aadgHSAywGxdyABuvMCnufE3quqooRfqavOJTslrVKocQF7mMxL/Cp7GsZsUl0xF
	p9CL9Rfs9ZfMh73GdWQDfMLnJj6USRH7G94n2zbNfPh9eZFK0Y6ImYubGRevoeMPAUCz1/
	PYm5jqRCRrJ639IbLWEr2PVcUfvq6iw=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b86ed375d37so380210266b.3
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:09:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769825352; cv=none;
        d=google.com; s=arc-20240605;
        b=F5mI1CC8GXtooM59TcW/Sn3UZOcmAILYUoK6bGv2u4Pj1mz05j6gwbXiobFLwDsBVQ
         EWw4XIvfb8KaVlUcbF/1koQSfjVkIgAXKnMCpgCqySlFcuvsZt1EkH8u8VdvrfDJsiF/
         dbFs1Xzhk6h0tmVRdU/Kh8dalsNmb0cZqauiVh4QMQ/NCQWjdug6KYqbntnWx7rrDba9
         cvkFBtlieCSc8ZIK3YToUlvN8DqI1HlGs/uIqqa97jgr1FmSPttC/z03/Pf7U/5niK03
         KVy7yguAII/LY5Cgvj+zmBlYpa1Z3ALyUmr+DRNMlgs3iNNjZVnZyxgZE1VxuuA/+bUb
         REew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fXBSGIys3SzCpVetTGHBAjMTb+eZCN0LoIysZIFKUFQ=;
        fh=LnflomF6m3xHTaYp3NR4hYo6HyHS2MUj9zF0CqzXL10=;
        b=XY8DmLRUaSSVQcImbai0SHPt5VP3HvUdM/M3QC4di36NwcD9E3CWr6L8wfZT+TLodN
         Fu9B1yKzDendEtnrLhqa/1lzef1CPQ9q10bwiFObQAJ2aCLhi8xaqLH6SVl5AloSpqIv
         0KlXWPar7d0ybMImrMAEs6zoRFmXQBGmAeWgATlM1cu9JYSWgsXWb9xT8v04qqUEgz67
         8BneCfCgl9VwVfkYYCPLRs01jmeVypHzvqUpbN1cGYDjQ1ZTpO73rBlf7PlEnDxvrQ5F
         QTclSf5Ob58sZkEyQwtUnqVWdwV/HHsqwuzkBHiGElBo7gE75cgXupn03P7gYUKrYCgF
         YC2g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769825352; x=1770430152; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXBSGIys3SzCpVetTGHBAjMTb+eZCN0LoIysZIFKUFQ=;
        b=jrc81WUbwz+5L+H2uGYzqEfDRM+8uu1/e1b1WygQWwj5fcY6wJ+vTyoGob7LzK2Ys2
         80ZhZ3z2f6yjv8Z/5PL+8RfAMbOhCvw7HOOmXRxed44WpKvixN6zbIjALwCGNa5aHZoJ
         IEtrOE0noN62Wwfuwh8B3PhbwOy4Cs3Md2cN+e+fneVWRZy+KeQ+d9oT197I2gVYNkXG
         TmJ0uzMF7I1chB3wD5k/D+QWpyse1I+0eCOtoH5qbFZXRWa1emcXokgddnbPGenc0vD+
         8xJ8BrDtunsyiczIW76gFsFKCIu8FUGkhjVc9a1+Lv6/pbcqRY+BbO9p73ZPJD/4JNv0
         Ti9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769825352; x=1770430152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fXBSGIys3SzCpVetTGHBAjMTb+eZCN0LoIysZIFKUFQ=;
        b=enb+IJ8IeA7mLVm7Wl1PE6/Atj/68j2yT7L3Eqv2iNuRYV0qyOWua2v/dqpX3TJwPm
         UQroKZOSc3EicNdM9Jng0LHsZ668e0dL6MaEPGnjzA6m5lAKihoJBRs5H5F+1YMa1/eX
         9Knq5keckN4TvsPUc43lKfSfyuatx+jAH3onKmgRoat6Gii4+pen79hPqEXf+3zd8YyQ
         CJ0vpn2ZBxLBXH8+eA1i6V4mQEQs3Dkj4qA+ChNf3yCw91p/BRQqdhS1zFeUJf+p8bE8
         XyzJ76hBlWUu5p2r2qGTcoeWf9Xpl6b3U5kWwwmQdJkXHBQhlkdTzsX0+x1JAkvy4/sP
         G0oA==
X-Forwarded-Encrypted: i=1; AJvYcCWm1qiepDIv3RmLaDhpxF4HhuH08yDfYs7h0RsNzIHUQdMxT7vRjy8vkchKTqi7hY8jBSX9pTcQOQ==@kvack.org
X-Gm-Message-State: AOJu0YwZe3Hvm1ZQtwDSTQGKg2O6WN2tIp4sDGfVoHvXSY277Ld9Y/ev
	fuml/DxmJ4N0aKAeaxnRh5YcfYzANtzMvXgBEFN712kASpRkCBEyTf8X7OhKYhuML3Q00Q1Gk0E
	6LgCCG7v47m+X6fDbUEtGAorsoecpMUo4c8vmPva1
X-Gm-Gg: AZuq6aIbGoY0aS110by4IwODCJn0sljo3XI1iFq+tbMMb0hHLrAkVpmBCZk/Gkq+rtn
	jrhRSqrrObKnl3ZLhdU3lhcHCUBx57M1eNl5YrsNvywJ62e1lhsnQAYcwDf5+oxNqXmO8PRE3bB
	jtz9o0ZxzqVvqZfWKnRbaNyjvxh0LXEEHCUdkIS4qF63vYn5NYrgp+rAyImB0xyYKsbts1NWvMQ
	eLFEOo9Q8KvZrKl9+Y5SAWY6N+SH1VVG74inVrg+F7PK/HCDzB88P59cncMVhLd9MMUuDyLaQk1
	YoQ=
X-Received: by 2002:a17:906:f5a8:b0:b74:984c:a3de with SMTP id
 a640c23a62f3a-b8dff5d84a1mr304116566b.28.1769825351931; Fri, 30 Jan 2026
 18:09:11 -0800 (PST)
MIME-Version: 1.0
References: <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV> <CAG2KctotL+tpHQMWWAFOQEy=3NX-7fa9YroqsjnxKmTuunJ2AQ@mail.gmail.com>
 <20260131011831.GZ3183987@ZenIV>
In-Reply-To: <20260131011831.GZ3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Fri, 30 Jan 2026 18:09:00 -0800
X-Gm-Features: AZwV_QgpcNm32QTyYTJNZ2e8MpZD_azq4tiS_evKebHi_xWHPJAAyFUDpR04HdE
Message-ID: <CAG2KctoKDsfbyopQYq3-nJBg3fG+7Nrer17S6HqQ+nCWEcHeWQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ofm6eoeysw4btwnzj1y31u3ysnt3em4e
X-Rspamd-Queue-Id: D26FF1C000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769825353-941805
X-HE-Meta: U2FsdGVkX19wBnAVL/iwmKC8J6CPiso4otXqrIK50H8oW+HNJ3+3N6o/8MizddsRVUK7DUhAwt5Hm8BABuRUo3R6jvSCxaTNhBIBphYktktwCE/X8KMw5SKDbSuiujtlhc1ZtkF5kbkJZipOv3GMU+t4xB1lC7qGF9XZ8Ijy+977/OqGHxx91FtN1TD511I/4MIxju1FwdTbwQa+9a1ghiBExRKMPKSTR35X6YTxeyL5/yxxIiiKSOL07U4EaidHFlNL8xLk1OBJT/XYN7KLP9uTYk5SH9gmKFLYP7aXWZsbky+AfjS4NRMM0MF0qQhsRTJPgws/Nym8JoRbX3ARW662oLNeU5hoTg/x8FM21YtH672vlLxbKBzjuEPkUd52aZRCKhrcRxdXOHn6tPxSGWvZbJ1kpC7CChCU2BvHSzgeX+7XS+i3ZsqS25GlJmvdrZI2Ly3AotU2a5b6Fbh0wuPzfDVMo1TaKtB/GmyYJuXTLcRJW0nGSfX0avhvi3sEcsv4ObW7lw+I0Zt3BkjK41PcxQYFxdWHgBfV88nJ96dfIA/SsqZf72mtMZ8/mDl1FjGQRyfY2dBu+rLi+NXs1VF1KwT4TEQNC3MAv8buxJ+tHwGL5jKmiQxrSt849P6sqBYEI+GbSng3wRkT6zj8nzuK+HJwKzf2EHJTB8azr1X3YaGa97HWGpq0jnq8KkIxNttWTKa1Fr6sJMye+ZN7SCbyDJe35hbVhVPsVJcyFWRR/5cS9YavQngLlOSyT6yvApRdNfInebyKo8Ekd4NjG8bEuxoGWt50fZ+N1Zs0VDc1OCQwEYw0kyGn85BFACIsUySxKWzPecm+/OQ1FF+xc1fTKEp7G/3PxvhkceZEJQ5212eu52QF04XR5kzYf8dSdI0CM+h3mp6qm3W32kespmRLSMsNfqYVJMGL8Zo+GClutWSAvjTbywPai4PGtnvEqRDPQ0HCLC68iej9sUv
 5s36ZCoG
 /iMJL2ayjq8ZQekYnrmp+kGXs66OGovT6B9EXWz1zvuowPIgV709PgoCQjR0eWeSRD5ZquyDkuOzOqG/e/ZtlI8FvoaxW4F1xAbtFZ11ZPYJCMT1hYu6qA9pGaLn25CjT/3L5ryqauPkHHAup643Bobj6UCqSfN9rF72zilVAyYoDwhLqDv3ITm0yJZ+uxfhFmb50xSlo4TWc93xysIg8YuWqBpWvG4Vem2NdgFxMsi3TAyWlfa4e9FaaEH5ptRvXx9TBrKAyTXTOgk1tKVrXa7vvT52DA2QhpkQtD3+VEgo8p7Le1jPpv5aetfhtyWQbJqjuFgG6QumA/Bq9u9ogzm25sqnSdDX0IQ6G3lVsXnVKSTwcyk38+vV5qqN85hvCiu0NZgRwjExvR65JaLThCSEL4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000299, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 5:16=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> On Fri, Jan 30, 2026 at 05:05:34PM -0800, Samuel Wu wrote:
>
> > > How lovely...  Could you slap
> > >         WARN_ON(ret =3D=3D -EAGAIN);
> > > right before that
> > >         if (ret < 0)
> > >                 return ret;
> >
> > Surprisingly ret =3D=3D 0 every time, so no difference in dmesg logs wi=
th
> > this addition.
>
> What the hell?  Other than that mutex_lock(), the only change in there
> is the order of store to file->private_data and call of ffs_data_opened()=
;
> that struct file pointer is not visible to anyone at that point...

Agree, 09e88dc22ea2 (serialize ffs_ep0_open() on ffs->mutex) in itself
is quite straightforward. Not familiar with this code path so just
speculating, but is there any interaction with previous patches (e.g.
refcounting)?

> Wait, it also brings ffs_data_reset() on that transition under ffs->mutex=
...
> For a quick check: does
> git fetch git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-=
wsamuel2
> git switch --detach FETCH_HEAD
> demonstrate the same breakage?

Had to adjust forward declaration of ffs_data_reset() to build, but
unfortunately same breakage.

