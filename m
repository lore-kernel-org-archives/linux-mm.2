Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1C2C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6EE6B009B; Tue, 21 Jul 2026 12:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AC786B009D; Tue, 21 Jul 2026 12:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1CE6B009E; Tue, 21 Jul 2026 12:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 548FE6B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDF26C021A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:12 +0000 (UTC)
X-FDA: 85013305944.30.6D79D43
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id CC95640010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P50QTK1L;
	spf=pass (imf01.hostedemail.com: domain of jrhilke@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=jrhilke@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IIRL+XPWpelEfDBhGxVOXyFyatQ6xSvU7ZF4RnBpbA=;
	b=lubFD51w8Vk2n/JoiUNXPbGZ/wRTm+96IAu/143EsfrWxup4/yuS3nieHRvBLmccTTpiLu
	czfSgigWYHZezOYNqUKFEYi/RQBsr373ThNSNv2dL7839kScIRiDMjrEGvCtjyUvAWjX1M
	JaiehfkUSNjsx5UfDND5fSF2Hj/j1UE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784651050;
	b=lV9E/z2ANrwehsOGsuEYEiTgqcleCruqZOJ2S7LYiNX1UFIvKgaQDHpERvAgN9CasVM5iP
	WPy6HSI4OLnQj/R3YEbxNAvfGcfAgTM7kCnyaj2PhCgjJBr1baPWHxpLjWhAb7xphd3RbD
	8fC38DccMcqEvi9Vf9FexFJTxGMrrBo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P50QTK1L;
	spf=pass (imf01.hostedemail.com: domain of jrhilke@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=jrhilke@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so5617e87.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:24:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784651049; cv=none;
        d=google.com; s=arc-20260327;
        b=LU6W/L+FHSCMk93QVQlsh84KSahDIbaFp6dl57AcbqHnP3ukgVagk2Nm+ol5W1JWiV
         fIZrcHiA1A9iPeKsN8Wvh3cDITTKEUB4uMAq1ACqysbuZG5TL0/PgVxpCxgV6DmbeAcG
         NUzjpW8zm/KgnaELqjDqRHxBI1w+P87Eo5rqAfjKOWiYj9wDGKztDwpRSCkZFBDcPZvY
         usClxp++Nt8LbHb96ckxDe46A5FOD48uaV89t8JdSpom/J6atlFAp7WkoR3fKA66ZKGh
         k2DfBF6ToxfMqzZhW5Jck4nqNICzA87jt8NJjfjttofD6Vpbv0qcCffGlziO0ir7TRgB
         W2tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6IIRL+XPWpelEfDBhGxVOXyFyatQ6xSvU7ZF4RnBpbA=;
        fh=2SOIy/WK3Wpw2u0qpDcn8UC19H2q2pnul9HkoqIpQdA=;
        b=QJXO/BsjKEjhk1r8RkA2mbA9zzizdanT7ZHyuRegS8idwuo8N2+H2LMGaciup6rbIv
         JN1a456dhUPb/ZmwrAG52ieBxpT/pk6BY1JKTtiyi+MDTqRHPAYw0KIGf0jb7w3p4nE7
         ykcZv287MJdKclnCDxkoOzcjyvWfPD0KdgVogVE2uqS1awk1Jpe1LgQHzzSW0tEZF3p3
         RlFO1w44F4CLXXUDI8b71wwisEDz0f/4K5kMmx7KrXC4vNCdfSj5NF6W0pvJdRDVjich
         cSpwgOecGbV65SOAJySu2X5mK4/NmyEzpf5hJguz9qnQHgpoOAuxV1RugFAfzFEJNsKU
         bJIA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784651049; x=1785255849; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6IIRL+XPWpelEfDBhGxVOXyFyatQ6xSvU7ZF4RnBpbA=;
        b=P50QTK1LGnSOoaLO7lB5HycSakdQKmc40gdBrr3XKWIP1Uvv7/aIvFvMgqUPwV2YxR
         YtwJR99Dj8vPOIA0MrUiSYZ2tkK8zPitxBP/ch0NVDrVGgYiyOqYeyCr0kEbY+knBy4j
         1eAnlE3GROrqNNmR+ALh6Ielcw6ofVne8sfJX9jVvsHIkATaYYqtUcfP81eALAdaQT1b
         aJAGEjZrWHrBUxc2oavWKP1CB8G3uT/l+Un4wrBDEU3ax2ClyoSfo/CAd2dO5Sn357ow
         bltlFU8+VKII8Ako4Lf7gOVzzi4C16mol1rI7M3k9AUJRif5KCJh57Ap+PwGkpkBwO/c
         dPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784651049; x=1785255849;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6IIRL+XPWpelEfDBhGxVOXyFyatQ6xSvU7ZF4RnBpbA=;
        b=paW8GzCDvNsYfmATCw4pub/A3rF9wcHRQB3SNFBBA2nAh+0kP9k96v4RTiJZIIoHRS
         JPA8t0cIPaUAunH98aNOA+WpHz3doJ3vdx5IYf9DCffvc+HK8D3/lYVPRhyKdnvoPMCu
         vwbrrr0MBc8eLBuYFwQuTqraMH7miBbx2QSZ7ob/eYYfUdj1+bb/uu8XTiVVBhGM07rC
         RmfgxnmmOHJWHHsMZqGX03/TbnxF79etutltVak90+yM4CPglaoOo0UJb5S8oZF3rKtr
         rWY92ODLozx8vB/zN7FbpR0yKtfdCLYucY1sUQ0MBr47jEv6ZcjkV4UOKVE7GXiO2YHg
         2eTA==
X-Forwarded-Encrypted: i=1; AHgh+RoMH/QBo7XGMGUqenGh9urVkaRoEvBq947M9Io1dfNGgR120ZmSQObpkZI+FhIHCE2tBnGKJp7GdA==@kvack.org
X-Gm-Message-State: AOJu0YymxhKRx+AlpllqLaO9Kgn+Q1P+TVO4tVbaNzB1oa0yYwKsF7nQ
	pCDObG6xLCEkqGIdD395n0TzohP2nXmhN6Wn/1pbGAPgAWdhIbROZJcZV3Uga64ERMXR+GTDLRz
	kOJKw4l7Hjo0Cz/uIcVMoB7KNF9WSt3v5zA2P3Ew=
X-Gm-Gg: AR+sD11M1hYPmGOf3xrouO1tmO5HhsdPeQtV6ZFjNNiz/aJeBBXSkBmUtnvuS8o6AcF
	D0npCABDSHPZjJv9behFqjDEmHJMIRQieUczCkVpgx+uSgLngl/F2qCUVjAMvSIsQ4v9lLtua/b
	8Ys5zK+UyxuoS9f3E7U8l0X+8XSfuWd6Qv6+eKweMRjrWaCZp1LwfNm95Rt22yXe/Sjg9DDqFBH
	gIgll1VBO96F907JYCYVqvl4ytrMAVamLvAiRDDEFbQ72duYxi7/AmcBA==
X-Received: by 2002:a05:6512:ba1:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5b2a31c4862mr327591e87.9.1784651048492; Tue, 21 Jul 2026
 09:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com> <20260714151505.3466855-11-vipinsh@google.com>
In-Reply-To: <20260714151505.3466855-11-vipinsh@google.com>
From: Josh Hilke <jrhilke@google.com>
Date: Tue, 21 Jul 2026 09:23:57 -0700
X-Gm-Features: AUfX_my4kAQgnpjbhryasf2kLrfrl2S4l9xVYW8Rn_Ur_MRpX7wHXzL-Nzt7PMM
Message-ID: <CAAdrzjsEG2DQoQbNe4aeq8gNF4Td+N6_gTifU6=EzAEuySu7PQ@mail.gmail.com>
Subject: Re: [PATCH v5 10/20] vfio/pci: Retrieve preserved device files after
 Live Update
To: Vipin Sharma <vipinsh@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, ajayachandra@nvidia.com, alex@shazbot.org, 
	amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, 
	chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com, 
	jgg@nvidia.com, jgg@ziepe.ca, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vivek.kasireddy@intel.com, 
	witu@nvidia.com, yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CC95640010
X-Stat-Signature: 3rnnf7oe86qcftxwoefcj4nspuf9q65i
X-HE-Tag: 1784651050-826193
X-HE-Meta: U2FsdGVkX19zIv2mlI4zNzgrvnMTpAzJhXr4j7H6eI/w2IWpniwguSmwtgrIk2yAZFkJRojn8mz6q9RljRrdhTw91TzgBLItcegitwP31w+6q4duYJBuqGP8oUYx7W79anJl9Kk/TLDakvZGTOM5erHm+3wehpKc55MOSOkBJw/aPCkZuNcCxAxHAoqeewGG498TOdmzwUVRogWq2aUU1jRRrU/X5iwtFtAYUEj87ytVSrvWXUgabZhhuuVkY940SvXGQmXh0PyX6Xple7Th7LUbN6UMLTAVKXJwEyfDSm5upQmz6xlg7uui4K7BWjVZHfvEvBHkQ8HpNC66SOunNIYHEu0O2U205yZcrByd1q+nH2hg3ZMTfi1ITEA7prdyoUC3wobyVsIx8QpKV8tlUeeQ4+sgpi7VraLCZ7A+U/XJGDYSlgHNn1OlP0Ne6QcrOjsvgL974sO1TFENZyLEJBZRrsm7o9D8hZwFJ2E0PiFqoH/iR18dDOJQKV7L4w+JxDW2fGQG7VDf8z1BmTpox9rwRL6zz0A4qrmqjVh/QT1nuI6+PSTvUDZV2h9phnlzKHZatreR0QEQVCS/NIZKIm4BGmno4bjK+TQGIyrpnRR6rEQl2LCNkG7fD4bRFS38O12FMwj48EqTyqniFeCrsYhUcJBbkz9OC6wdNvS4DA7liYg0sv0YYFvOGRHkLeGhgv92HZ25F3RhcxOCILHtwQlcdvpkT8YHru+ecWXxKOmjoKlmqYbnv52bQG5dXK6jEyUiTrJCu3n8do7QTz6/sHN6zuv/YToVz1J1eTPr0cGnAZ5pPwxsAocT3XagSv4LbE9Ku0taOOJ/n9whrgchTrJN5jFlTjH8mRiBabJeTxm4x3fN0JvAAZqo8GgrJcgFeoa+Y705RQZVTlTde3OwcemzOkUT7HsXNl5JelT7TB1I9ORZi822DXXh1ZadeHQ+/KrLGE6hz1KKzjw5MgQ
 2oLJkQgM
 Ex6VezjMRrEPFxXCNZCtktk0rmyHhWqLLvv2q47ZGv8w4NcfWjCIfz6azHvBKzFMgOYvn9291TdT7UHzfBLPIS7raoMj0ek04TYljBcHiEx/HhEHE2T2Pl58x/DQb8AVPtq1W/9RFTHztylL2ZAwG1OE8iSuy8TLq1eVI2flhQAh+CG6PDrk/nDoGYlC6+8mpuv+7Mu8wkYorJZlRRY3U1hEUI48dlOB5CeeCGFf7cXBvOv4e/Y2Exyyz8o05WT1o8FtZbjvXA7WkEAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 8:15=E2=80=AFAM Vipin Sharma <vipinsh@google.com> w=
rote:
>  static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *=
args)
>  {
> -       return -EOPNOTSUPP;
> +       struct vfio_pci_core_device_ser *ser;
> +       struct vfio_device *device;
> +       struct file *file;
> +       int ret =3D 0;
> +
> +       ser =3D phys_to_virt(args->serialized_data);
> +
> +       device =3D vfio_find_device(ser, match_device);
> +       if (!device)
> +               return -ENODEV;
> +
> +       file =3D vfio_device_liveupdate_cdev_open(device);
> +       if (IS_ERR(file)) {
> +               ret =3D PTR_ERR(file);
> +               goto out;
> +       }
> +
> +       args->file =3D file;
> +out:
> +       /* Drop the reference from vfio_find_device() */
> +       vfio_device_put_registration(device);
> +       return ret;
> +

Remove extra newline after "return ret"

