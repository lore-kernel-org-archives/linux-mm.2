Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5859DF53D78
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 17:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8494A6B0325; Mon, 16 Mar 2026 13:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773EC6B0328; Mon, 16 Mar 2026 13:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA286B0329; Mon, 16 Mar 2026 13:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42D316B0325
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:10:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C0D51A036B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:10:06 +0000 (UTC)
X-FDA: 84552564012.24.B7D2323
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id CC7E380010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:10:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ej7sX1w2;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773681003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjajILnhW/iAqqxkTb08T/Hii8IQWi4dcNUVIU2+S2M=;
	b=hNHnKHJrIcYTaIZiKp2REAfnWDFF0PyxTbCdLqbDgTXado11zuzz0nSrf5wMXdTuvxDCQL
	+aw/E3mZ7IxAnAzYLmkwTHxynxiBDIfWO83QWn6gfoks5c/0Gn7Gz1ljS/Cy32erNKL76E
	xDHATf5/OXNQTcDRACikopZ4UGgyg5s=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ej7sX1w2;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773681003; a=rsa-sha256;
	cv=pass;
	b=dQZDONMWK2CHUk02HN1GWckz/Mpqlv5xpvGS98k5ssEU5KCqAI5Ck35CwWuTq5ypkb20ot
	91Ul7HsmZrQlnR2Lr72yYvKb2+GXMNxfmH8Wx2JFOBOuF2NpJLg7qCDbIwuHDkV+BC7U0m
	SeMOy1rUHn+ZZY+vcSNrW98hOzu8nM4=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a140efd2d5so8761165e87.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:10:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773681002; cv=none;
        d=google.com; s=arc-20240605;
        b=cTmHfNbg3v5UqF7vPhU2YTOS4TlGPOdFHHM1N9LTU6zc4nS0zXRZ/hkEfYZre79kpH
         r/hfR8EUBAmm6bCa2uDJs5xhkoVSwWyvxI7ueFL0JvVvywiQGGNHrg3M/Aia82Hr0gMB
         Sh2SfoXGKiuBjBSXRRjHyWW5TEhZvJY6UtEtvReqsDyV/ZND5MZSs7jQfrc59WeaISb4
         xlddeDzZIYgNT47W2DybTYJSdHI6uR3Pzn+rTVCfqBQLbl3Pdb4RjPiy16hsuTLeCr1c
         nHChOOh6bV7RLlCKTGwCnX/L5SfRBd3ZnPFa0kuQ9yGEZOPQ3xFGpMhXhY4Us6BdIr2y
         cRTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VjajILnhW/iAqqxkTb08T/Hii8IQWi4dcNUVIU2+S2M=;
        fh=0kCQ82KDo8x72emFCXfoigD8LE7RcweG1aIadm5Qqis=;
        b=SSdnARI1WNBI4lAYfLWzljiOvbi6635zCjav/LHlmL8UItRHTsPB4Cll7AfizUIwgH
         j0Jhk2TGSdqYGwymIcGyXHDasf3aMi9tHUA+DAPIA40+B1jukiN/7EHUEfj2Zsq59K+R
         AChB+aA6ZI50WPA8N/fzWK9Zpxqtwau0NetYBNAOR97dnO+N1roFpz1iT4+g36JBAuql
         mWwEw89zGicPfYP1F8RI/yOHE0X0Q+M0vO3diuM4otE3eeQ29MrRLVT99TWf6ioBCFwj
         dtFMhjdhp2nldY7evw7hVqWOQYVpusi4T1cGGBBf874uFZ8qiLt4TeZk1Uv3JmpbZkgq
         kh4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773681002; x=1774285802; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjajILnhW/iAqqxkTb08T/Hii8IQWi4dcNUVIU2+S2M=;
        b=Ej7sX1w2m99QJgTLdNJDkAo0qD4l2gKauz3an9djR2u4U/nHBIwPJr/OZ3fvcqddi6
         /mftk6YuKi1Pl+5ETR9Ay6DHHiWA+dLeX7j9/qdFacqgmAiUs6xruLxSjQ59SphZWPB+
         EE9mCkKFFl+vXVmlWCoBS+vPPgOHMS3kgfGbt7x7g8HEMA08moYdUuZYAV+VbL41IhL7
         9QWpH7rFvEE2t1APutBj+3McqbPvQ9N66IV31xCMLgB95RtJfXimfVS0weZxYJkrgclm
         F4tgqHapT4HbRCBWVMHCry2aBYM5cYbsitLhDPjpC78A/kkl4kNwhlIyCY/Lmg2NLV/5
         nN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773681002; x=1774285802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VjajILnhW/iAqqxkTb08T/Hii8IQWi4dcNUVIU2+S2M=;
        b=RB68GIxaiXug+29KmOr50X9Yl9bQtc3Cl+3NYJ4Cc603g43P+q8bBBuhG6rf3k6DvL
         lZ2UZeBWrqsNUJ9iekhVCoGxaSuB7zfXVXad+yxMMzfhwFv29QSVd5lO2hCq/J1hYgZL
         +whe2FujFLMOyIzc1aYEy7VPp9hDttkgxYx0/xZBOzI0OqfCUAgitY4+JdajSdCIL/p3
         p47NJVQ6nu4sx1bTtztzYiAc8M6dNG+AW8S0Fef2qSrIV7SKPP7jB87PEh+4u5B1/FN8
         AMQ/dlP7j2Gs4GUeObAUo+46taThSEIbgeGFCpXGGUuQ/izKqfj/6YmlG0vUWYEAmCxw
         y74w==
X-Forwarded-Encrypted: i=1; AJvYcCUTnyUn4gQod+u2Y09urjSRiQPF04N3UMtCTrUe+9mPicepeaJ4kb6aJr1OqHoaLV8++m8Y+zmE8Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2dUzUUIxz+v/cWEpNLLNQqNPA1v8iSUtSmggl8Q/jypGnoQJv
	y9urkTLBZ7VoeZZiXhoh3zwslxvHEb0iRvhdizGEpdZ+dJPXz3s5FA+5eCG4raEVraw48i63N8h
	9hr9y0OMFfgiBlB26J6hmLer/2BIkI1SEwpXoJbET
X-Gm-Gg: ATEYQzx4MKJjHS9nAZ1mbfZxQOa6X4muBCq2TgdgUq9+EG1lEt3jN3nCTp38qEZVfRt
	+A7Eao+9WOzEMBHnGRR9uuNyo8G/nuIGX1JSlEtTkm9OEY92H35ceNt5NrmbHMHk9k56j3Z/F6a
	O1aSn7iJ2R7AcfDAPW4ST2yMai+c5oS8YJID3FnTnEOhiYEF5eoJ2HqFXXQoqAdmCTxoO6wQvYp
	+CGKKBuTF5mgxmKgx/S2id3iONTHhx50mS7kL+78rekM4gpZ1RLDZDbzoXk63r/9i7ULuj/8Umt
	q+ts8pdJT3mcOyIuydM=
X-Received: by 2002:a05:6512:145c:20b0:5a1:3207:694c with SMTP id
 2adb3069b0e04-5a162b0c23emr3396226e87.29.1773681001667; Mon, 16 Mar 2026
 10:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-17-dmatlack@google.com>
 <20260314073250.GE4177610.vipinsh@google.com>
In-Reply-To: <20260314073250.GE4177610.vipinsh@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 Mar 2026 10:09:31 -0700
X-Gm-Features: AaiRm539MAtTSlMtJ9cZiQMw7S77YkLj3Qx3YTaEKJUIvtilcVTIw0VDB1yQ5S8
Message-ID: <CALzav=fWmv_+BACzTLq2Nj2aUux575EnbLRwJTevH4aYZTXycw@mail.gmail.com>
Subject: Re: [PATCH v2 16/22] vfio: selftests: Add vfio_pci_liveupdate_uapi_test
To: Vipin Sharma <vipinsh@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CC7E380010
X-Stat-Signature: hugr15mp7d1yezacy11d8g6exrg6ny74
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773681003-426389
X-HE-Meta: U2FsdGVkX18lEeY6xc6mjxA9XU9r3CTBWtgWj8FvVc6e5kd1db0Sv27PX3+7CeDScg2TTuG8lIodVuzpQSWWfnqlmIV0QWfCkZrlFcM4UOP7VSuPAN8rjioopHZtkzBMICygDXypTiKORpZFMflYxRNiNA9wt2VH4wcHlnvCBT+duCBzwbH5CXKcP1uUz45mhqrwQM61nHk8HKEk4WDMGvkGiH6Y/DpiKVld4dU62CnG9qcqnURHFVQBQ0156wYn2bthirEDG43XFaRpYpxaglDlrMvXAGMkujb3Om4jutux19fzV+h0XE74EMBBDPaLPfZu0wjWfVlkIu23E59FvTEI+Mx9ihMaDwE2WZx5gjXmMo6Nyyb4Zbo7KbB6fKLcDgetJFb64F28nAQ2dWQEE0W30N0e9hg3z1hFpQMWlr1VNrP2dWRjBF8fm7hGKfApgcwOidnV7VYufZImLNY87uAnAwMj41JEs81a2MhbyGzlBMZbuRzwJyVz/nMBk9/81FHEyj9LXOniCBLMEgJxYve3pg+iqCf3ybjgZafSY3rwKfgMkPu3YJ+JBQtLlJRf7Y0RITrOB9qWRcgevhLa8eqLmL8+djib9SjxnylcNFgEK+I4DUTLIVt5NILmDm+D3twMYtbugAHTebWyNdejK6heEh6FF61i+Y5jokehNVSjNr3rQZEoHTetGdOqpQ/mSl+Ks0JdqwaOZWvkc8AeNWG9YZziCzHPNdXmrC1L9wKEJqZhFgwzFV6tnnYA2oDWmRuJ2mlJCnCewA496imH017ZMqIYc+FvwxPPbj5tP35u/xgMgd4LeHpWi6/koLUmfmge4Y2HTKcALxdMRoG+iPsR6uvy3pnvIDa9hYLZhd0cCHjMOon1Ih0AYSq/eAhBy6MRGjW6VSVmW/MqXHXtCt9bOLCaCXoH9Ge6gGhPzH8iGliBtQQN6l84VSxweZMLybt/TLCnaG9yM2MjrAO
 zDW8hPKk
 INRGuEOrPnCmUMuHuGHGUVudHBWr2bXCbBSl7GX12Lkq/HtFYZWmL+qH6KjC0xa0OTyP2LnqyHK0xXo2N8XapKmmZNV3CJi/GGnPBXJlF0knB5OX1ILgmpwFg/goKinbPoKUlH/oYE1KV6z94XKBXCzjRnqz9+cElIZxOFda0mdlDdlYod3MOOww8ydjKLZDvYXNUq3ZVBG19kzqNSfWDXv1jyRcrf4sa6NEpB6pFPIxPe/pbjYZla6VIoBIPUQkCIyEKtA05GN6vT/NhNrjs2JoIgyJYBq02j/KFPQ0LIgwXWF+jYptk4/G7aj17YxU8pNoWiXFkIOsQLtmgp9FftlZZQwQbssNYBp5KK+uI3xOZSSWuCEiU0D9Bmnwajvlji7cH8oNdSymLfu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 9:05=E2=80=AFAM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> On Thu, Jan 29, 2026 at 09:25:03PM +0000, David Matlack wrote:
> > +
> > +TEST_F(vfio_pci_liveupdate_uapi_test, preserve_device)
> > +{
> > +     int ret;
> > +
> > +     ret =3D luo_session_preserve_fd(self->session_fd, self->device->f=
d, 0);
> > +
> > +     /* Preservation should only be supported for VFIO cdev files. */
> > +     ASSERT_EQ(ret, self->iommu->iommufd ? 0 : -ENOENT);
> > +}
> > +
> > +TEST_F(vfio_pci_liveupdate_uapi_test, preserve_group_fails)
> > +{
> > +     int ret;
> > +
> > +     if (self->iommu->iommufd)
> > +             return;
>
> for iommufd variant, should we mark test as skipped instead of showing
> it as passed?

Will do.

> > +int main(int argc, char *argv[])
> > +{
> > +     int fd;
> > +
> > +     fd =3D luo_open_device();
> > +     if (fd < 0) {
> > +             printf("open(%s) failed: %s, skipping\n", LUO_DEVICE, str=
error(errno));
> > +             return KSFT_SKIP;
>
> Both can be combined using ksft_exit_skip()

Will do.

Thanks!

