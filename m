Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B25FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154466B009F; Mon, 27 Apr 2026 14:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104226B00A3; Mon, 27 Apr 2026 14:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F359E6B00A5; Mon, 27 Apr 2026 14:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0C5E6B009F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:57:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95F6DC10E0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:57:23 +0000 (UTC)
X-FDA: 84705243966.20.92D9B5E
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7720440004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:57:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Mcjq/G+r";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777316241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wr02yN3/yZBXI2xon5jDCKdawxJYqqpUq3piVXy5yYI=;
	b=SvbyYcrXk9Jvy/cQWhW17S/uJhO9c/eIdGyYKm5Is1dG6ZWRPEEA2Y9C2oFQBDzOBS8N4g
	gfnlaqzibg5gDz0ORe6OxZZWhYTAruLS9T3WTguXaU/li9sLqdxIhG31KTJb2opyyB3ctA
	jpiLxrhUrwauxhBQ0oudbCtqTb9K8j0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777316241; a=rsa-sha256;
	cv=pass;
	b=78KesdBbYhZjsCaPjwzNfHNd0iIg7ArJeHXC3NUwZzGLrME7SNsWb/V5EA9N6zDmiQb43Z
	l/YTsBoDNsjV2CE/hJf+rl3qY8LXOL3j11BqkkvfmyiD+tbvvltGhoje+z+i8eIvNdp+EZ
	KHCvMSjFPuNrA+4Fj195FhhiaNQpLQs=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Mcjq/G+r";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-38e7d984096so116260691fa.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:57:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777316239; cv=none;
        d=google.com; s=arc-20240605;
        b=Ls7+fIoGryIKnEx6AFM9RhP2VQvc0sgCjqz4QbW/j/a8yK1mYD3ACI9ZLUQqt8xvcu
         KDyJb+V3UoIyM5ajczcwdc0jo5FwMBrEwtRI+YsRWOXzeKZjJgYDhDMbOoM/34qebxsp
         TSHWZuDWAC3OLauZR+fBq7aC5qpwyH3OflMe4CfmXpPJ8jin4dDoL6eGJ4tMHx1a1kyH
         rHZ6sYAH5K+CgqyqN1p74aDLxclYsw9Y3vTpBlAR6F65APMzP9MN3j4tBDufyPmu/2fd
         UyR9YcgTOAnl7Mc/iC7ZYB+ckiOG+xjTvKSqsWMtDehKzJcZJATjxZturfHkVMkb4ks2
         4U8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wr02yN3/yZBXI2xon5jDCKdawxJYqqpUq3piVXy5yYI=;
        fh=1Zs3yYGibNMOpYqdp01+4dIc8m3cyd4XkKjKMwdPv5o=;
        b=c6mARWvDznXxiltk+L1SMsKjJ+k+aGPtWew5mwpdUJc6sP5uIUKsmwufJd9RmZFPeY
         zI+wIE2LmOUE8q2i8fSw0ZuRpvp7m813ROVOAgvxPlaecnkm/82hOlbmGquYt8Lhpkhg
         fK0cBL+RgCi+TBfchJp2Z1VVpOrDq9LzQ6MSqqfRwwYmsAjCb1rj3bD6zd29fAeC/0/2
         JNEWL/WTzMRR1UrtbuvaZoNxPxghgKHozjs9pZEFy/OMcpHJ8wBy2Zjtlz+k1WMUM9p1
         5e/lyoEF0ANGNaGsiiBYbcIldHdzWKcKyLVw0SijovN5luqfMBZSKeK2ierAO78NSmuq
         VOJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777316239; x=1777921039; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wr02yN3/yZBXI2xon5jDCKdawxJYqqpUq3piVXy5yYI=;
        b=Mcjq/G+rCPLutQQ7/CnIhKvHhCCUns71TOVPuh4tfJr+9tnNcgMcBgbOj2dZZgexNN
         kCx+IFa+DQi9kuoN5a61BFm0wq4bdGjkeFHXty1Xj/j+HrFGHnOpsok0ImIOaCKMe1pb
         qPbjjsKvTA1RDz+taTSAAOGDrKfKxniKyE6rJ8fPixMxoeXlRcjHrLP8xaUOBigRnxhl
         eirY5OpkRwdRTqfJlrC++/eWzTp+j5ijwTBShs5UMcUY7RXfgq8lXb06KV9zQK8pcmes
         bGnErxn4pOqxKCrtCjMs4Stu7+Ca9Of66zLpcwmgdcUy+Wvt9RKA/HN5Rnz9k3TgRrPq
         U0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777316239; x=1777921039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wr02yN3/yZBXI2xon5jDCKdawxJYqqpUq3piVXy5yYI=;
        b=ja6nBISrFlt2fyaom6OPrpyNagNgyW5yWjyb9IPDQ7xlPmSfX1Rv33GmcMBpt4hgI6
         N+Q0gPW0cCRfNsGFzLx8c3NXtXlxOfS/skNJxTN7CfnLaw8K1l3eUVIXxcBNx0dXIp9f
         6DL9Jg1AZOjn028iSOqoWgKcRGDbvcRLXZI9FGua7e6FncybR5ZGvKySl9VZnUtZzUp+
         rLDErO6aRPSd6Bb4bf1mUwPBCzD5OBHoLqCvM+8fFpX9TTFjsaTL4FjlDNGKRKwTgFAr
         WhULaGQw2rtGhPyX8iycuc00bbZdkEmwIUXNAnWqbwV1bJmNQHZKI1WrY7cGymvGZ7mg
         u0+Q==
X-Forwarded-Encrypted: i=1; AFNElJ8FdLtFT09VG7jP80hbIAVy3HKIBfDSA/j9hi32dVqoiRUva1cakCni0BbQUUNDuYyIaGO9BJhbjg==@kvack.org
X-Gm-Message-State: AOJu0YwcdZqnchx06ln+F64RFF7nX3La1z4keiVzxOxvPW+6/dKoQWO2
	5bXH70ErhCPfo/DsdnrXAidoa2B5tGSET1yMe449Q5DN0pCKqsLHiSx3DgdynuCbia7JDM0ITsL
	dGPA8HD2hcEPB7O2Gdf7p04iM1a/cxwvY9jjanw5T
X-Gm-Gg: AeBDietx/+QhDJenZkOTfq/IDaXFWOxdJmPWm9sxIBaQYyFi47uZV18TpGFRfWjWLIi
	8SMCX/ZqHNJ6rGknCeq4fcRr+E3Uar2wx4B07HolbAvqeyrCbJkAtMBpKeHSv36m3OUg5ejS5Wi
	FcFdSQzT5T7ab4Ln4XUKNTajaoNAEQ8zWsDrrD2tmdv/3hRcqouh/qM31CYTe2z7P5RrOZGBLu5
	47SreDVfPPRgM+cK341OIpKdG0v3uVriKc0cp7DYuMpdZC8EB9b6/BBF/XoPwaA36DDupwZ+Z69
	wt6nNQAv8kij/uitT8lKAUYvcecwQA==
X-Received: by 2002:a05:6512:3c98:b0:5a4:b18:427e with SMTP id
 2adb3069b0e04-5a7466047eemr34628e87.1.1777316239065; Mon, 27 Apr 2026
 11:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com> <20260423212316.3431746-3-dmatlack@google.com>
 <20260427085725.00005283@linux.microsoft.com>
In-Reply-To: <20260427085725.00005283@linux.microsoft.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Apr 2026 11:56:51 -0700
X-Gm-Features: AVHnY4IwEsFxMBzAHVS8KxW2Zq56dU7ADRcx7gdZfScIG7qn-IMwc1DMcXI8nOc
Message-ID: <CALzav=di-fMMPgTEzfWagRgXCWox9CB4XiRhZcVAzc3dUzzfHg@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI devices
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7720440004
X-Stat-Signature: bm1ue5cb1o4fgdaf9wryhd6utwqjwz56
X-Rspam-User: 
X-HE-Tag: 1777316241-195350
X-HE-Meta: U2FsdGVkX1/0tk5PGd1Q0+iT2hrd2EvIs/Udg+s7QgJcQkUYjoDxlH0HJaLX95Np7r9WmjEb4XVC3WxTJXcWWH9EXzDPvDVv+kDSiQFq2ReojcjEGoRU+JZDuXNLite1qaBYwJvuTx0sNEtvGb+0EbRPs6AfMNvA2Z/iBLAiKKfGp7jAYq992Vv7+QvZDzMxGB79OUxVGJiubcSple4LyvnsVQXRfO8F4OC6IJwkXiIAueiTIZALxYb6vRxClBNDBe58rDn229afkuqdJbxSXw2jB4YaJaF4+u94CAVO0B589XHJ8YcLpypQOOPD+hVZDVShVHB67jmtXEQm1hgPBAahS3F2MO2F6IXr8+z78lh4HQ86szV4zt/zD315wkY4uXMGLgZX2VD/kTq/85kLH9FbNIsDS5Ay+wdSQjhip7QwNBqA0WUEUJrNJa1wNKMS+vCpxaEFDevi5APZGD+1DKxLSgU+eenZ/XOIAy5RAsSlgoC+vC5qEU2M3sHGRBftmdWoyqiBkPZkjhlDEmlCxZ5UpQFb/4fSioikoNWImE1s5h9qbd0zGSEmWESUs3Be7InOyVrzGhd2y0+Sf2L17hHlUIv9oco9t14LUitedozwVpq2ym+erd5+rYsd199807TbEDGEP7m12o3wqrxQoUHeJguQt1J5qEJV+PsV20lYIGCpi/NPbT5IkyfIyRl043uDD4WRhxTTagqBVUDlceC9GEJXZ9iq60tGlyrmOv4Z8ZFC6t8yC/jfAYxrqqPJzCnKFCU+vOnFnS3N4djCdLIjn47zq2w9DTZA+Duo8njanG5dAG+hjwCJBtS9H9+CgJVRvMkl/7xP+Nmo5XXXTFqOlJsnr08YJ+HSdMX3PvA2tMz7WOYnPzsQWTRfltx6XIZc+pqkM/EohW/YbtwAmZPcIfVZhfxtR7cBrS6yGGp/Pcrgk0T3t6ezTjaFe8ut5tm9b89aNV6hHR1NwJ+
 c4hG5w91
 KB7jxFYWAK7bd6FBmx4jiNt7K0YU1bukE2Qq92LAbQ05TpeKQi5rLvPDZ1ezxacQAfHm1tEi9BUm690zwG9x56nibMBtuapHdF4vDb9/YDEgtOdTv3DuLOOlUFc5xkL/vfsnLCrlvcIfbxTZngFJSG2piIzpgcKLvBMBhcFbpKn45H7IaYsl7M9yeRJ0bIfaXdon7P7u6Lqf4yNeJn9ilXNFp7OwCyQdW47Attu603xKvwxDOPo1yXiiXSOiTTGnrj9oCuXma9VNj7+RDHRd6Y3MAONqb7r7c6aB+4ogGlLP/qUxkpfMJDD/Kz8k85DPolQLLlcA23tE+Etkzc/7ByUJr0NrrdON2zDZq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 8:57=E2=80=AFAM Jacob Pan <jacob.pan@linux.microsof=
t.com> wrote:

> > +int pci_liveupdate_preserve(struct pci_dev *dev)
> > +{
> > +     struct pci_ser *ser;
> > +     int i, ret;
> > +
> > +     guard(mutex)(&pci_flb_outgoing_lock);
> > +
> > +     ret =3D liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void
> > **)&ser);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (!ser)
> > +             return -ENOENT;
> > +
> > +     if (dev->is_virtfn)
> > +             return -EINVAL;
> This can be left outside the mutex?

Yes indeed. I will move it out in v5. Thanks!

