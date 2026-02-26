Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E0DFD45F1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA89F6B0088; Wed, 25 Feb 2026 19:46:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C5C6B0089; Wed, 25 Feb 2026 19:46:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90D816B008A; Wed, 25 Feb 2026 19:46:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79B126B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:46:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CC771C46A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:46:25 +0000 (UTC)
X-FDA: 84484766730.25.DE9382B
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 35BB9140004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:46:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RH7RMbTW;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772066783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ACpb0o7E3VaAsC1KFvr2yXYuV7ohO1EROiDs9rJDa00=;
	b=r0rM0eQzkIhQzX+6ZLBKpIvEyeXhL+mqxQp6gkXtsxvEV5g8VMT8rMPLZ7a5zZQQtOxijF
	0Xaft1Z4KhMmqL3ScRHOEcTCGIo5hUxWvdmLn7npGmt/enWvEkzZgT+SqsSjfsUkavF8J1
	7j/55rswlHTLXcEtuETBf09MOokK8lo=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RH7RMbTW;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772066783; a=rsa-sha256;
	cv=pass;
	b=PA/hIgcz01QPmWN8PZE1abrRoCT9SCqJSjpHfHnhl8jYX97cz0PMEnNetoEkxxK7BiGY45
	KKN/ql4OijVJsw/s3a2EB0pRgHI/UuBydbcYmdPBaLcSaYZMCLAH/4xqrhSO3Ys76whax+
	wi25nDM4tf913ZtKGq2eAbpdtS0Xc3E=
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-94acb3d6cceso176734241.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:46:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772066782; cv=none;
        d=google.com; s=arc-20240605;
        b=GzHoj/PMHd5PQL9tzPf6TerRqmVtpTGqUCxW8MlEEBF0qBGSHhHNaFUKiifsKiKbAb
         qCEBW2UwRLIiw+PZRWtCubimUJ6OVv5QSSpmQWz+gYj6sDXHPiIshUEsPOs6c7gTjYOd
         IJOanJ+kanZToH0/U0AUX7PpQ1rHZo8/8sLXBXfWKxzbddQaVt1Re5rwmdnAl6PBP5Aq
         52AWVKS859OvJVdGG+C1G8q2R2n42L1uYBmPoPQUM+Yzzl+xWIxdreRLp4Drc3WutYjt
         zUFqdwgHE5Fd64paw1xcuBXblGyfLmZZuXa8UDEKdw+bbCpoV09HfvsfAHAcDfSkpcps
         j4hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ACpb0o7E3VaAsC1KFvr2yXYuV7ohO1EROiDs9rJDa00=;
        fh=+XRVuKzrm56uF9+4nfZuAys7pTpDgCNXgoZ0+KPSVMQ=;
        b=canDMUl2sQjo/rnbn7C6Im6rosIj9OSEsQmOYX8R3qc3q3BqmTebbeITnn19mH9JO1
         b31PmdNEeQf52J1qtyJUh4euNpS+1REjTbJFRLsOqXVzFnrAznFjq634s+lciY8iok7g
         5axn+qYjp2hneLlaR90wi+eMw9XhTx1C0/H0m8WE+sylE6GEjSvoW9XdpClD9VyDWVwN
         VMAfLfYdaLJ554FoAWM8bXDgxBHL911ZhSQneIjXBFgUTClfc84HSmnrooz3aDtMPCOc
         hh37NY1BFIOvj6NgMzTEecxQCUTLNRKWiAp5XCFDG4qc1/YuV2ECapCSiNIF5uiBKeBT
         YJmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772066782; x=1772671582; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACpb0o7E3VaAsC1KFvr2yXYuV7ohO1EROiDs9rJDa00=;
        b=RH7RMbTWFAngt3QWurcZxhIxia5SsXJQ4ZJRS4YaUg/GnwPeXApQNcndE7EJoHj57O
         wOA3Ccv95kC6BthJdZSLk1WSoPK/CLtJeiigM1hgLq0r57EdXOTMfNK4J5wdHd3jM6lw
         cyApIIiywBwM3fWnQoUMk+gheYgHK+pcm8Xbveu6SfUn4LnIp40ZGI6MfMvFYH3OZxcs
         RIBzXjD+7aV1/KyYr2tj9WI4BxIrmm14OXlC9LTIO1qDp6sfDSSTG6Wv5sWHvywo78XZ
         62TH5B6DrQ6uOd+ghmcWglSNtq+XA0L56DHGYhl0r2cGLSSgbis+8ZbiXIemE7vZiQUq
         dvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772066782; x=1772671582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ACpb0o7E3VaAsC1KFvr2yXYuV7ohO1EROiDs9rJDa00=;
        b=gULg7EZQDXCFG8/YEtAt6QGheKhDfxN5ZOorc3iJmJ8lw02WvG8OeWUUP/7L62lrpj
         kstxeXzTZUofEvblaNzNHp0kZHN2tYKzaXF5Nb7x/UrsHfAKJjz5ojgqgL+PZP5TmGPu
         j38cykyRghZROl92ZWj2k3hgwDqru+tiE9t8j6u8MlE0pUvrAB7jfHqSS1JRLTJA0+E7
         Qv6dXZgonlFflLyhrY4CsNQZQCXXXO9Arrtl5UAH5ty0X5+9/qY734+SM2aikSlrInZf
         gbtiVInwo4dY1Us6tk/tmWudQ1Ov7wpiZfN5jskYw4kP8byb95rQ9TPRlXpGsWueqPJV
         GmXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxrGqKw404CyF8qYTBrJc8EJ5P8xTuFqdMFZ6/FVX+Eqb9Wd446v/V6a2JFL5tzw4WXKhdRGJXpQ==@kvack.org
X-Gm-Message-State: AOJu0Yxui/RqMJrQ37AuuR0NGDJwLLmvLQm5aZyr8YY6Ww44M7eh0nqQ
	KKgFfZlA+zcmjL/XOBVyn4Pg/+sJVs6+dW3oxHyE8e6hqve3Fa3yMkrar5X+WvI1zuW89V4Lhcr
	jPXhKAzYWy0KkwgbnbX9w9AVtdyRxf0E2nteXMT98
X-Gm-Gg: ATEYQzxdMokJVE+WusjpLPuafAz+4rfoST4zZNFZJO19jmZGivAhCG2Pfzg/qQJ6ucH
	5y1CY5LdtBoW/BRhIlvrbcjCIoZngmAgzLUGMyxXWYt5+FmIfDFPEcVwNMoOZ4pQB23ZZL49jrZ
	GKjxb6jmAEwc4+dPL1/5lpDyTZ9oy7DT0ASnzMQSS/l41i3ambpuEvqt6Cw9AvtMcmtpqTk/DvS
	zs3VqGKjelPeARjQzSCvTRCaM0z2FD60krTJ4BY/G4byF2mX4bNt7Cc6aQfpWMI50G28ptv6sDb
	ihrnyko=
X-Received: by 2002:a05:6102:94d:b0:5e5:6eee:8adb with SMTP id
 ada2fe7eead31-5feb2e8f35emr8956594137.4.1772066781725; Wed, 25 Feb 2026
 16:46:21 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-8-dmatlack@google.com>
 <aZ6rB-zmpaR3RLB_@google.com>
In-Reply-To: <aZ6rB-zmpaR3RLB_@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 25 Feb 2026 16:45:52 -0800
X-Gm-Features: AaiRm53bfmGZyNFLKGENFMQ0ksttnoZ823ayheFdxpLxg9pxKiAgxb_V1e66-JA
Message-ID: <CALzav=fQtLd0DfWcVku1BDUzcvvYu7MBY+=G7rMMr-gjLUioAA@mail.gmail.com>
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
To: Pranjal Shrivastava <praan@google.com>
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
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j9buifxssyopre56izd9rbn5t6mu9yxb
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 35BB9140004
X-HE-Tag: 1772066783-231339
X-HE-Meta: U2FsdGVkX1+2H0+BquQG1OzAwJK14FCHlxOISdBmiLw9NDADUswtf/wcMdFLOMYAJvmErH7EiSCjwPEioybqvi9QyiAbi64sCb82IEIf6sAurEDqdZjSpstXa13ZqsiLdBNzJfMjq60OjUwbIv15IdMiOqom/9TIF8aG2zsTG7dbGJxF/mzk0YHH64qK7JtucY/svEZGH+orQlNADe3sDVZaR7DpkJpnibhX6GOTXJhnQ4RqkvkAn3F9PMefGyDi2ByCWeUshYHz9sxQRnQwUmCzAWtmT9+zV1kZ9O66UMcCy0UwwbDuMyaV4MMTX3UVCn8VKodkjQzU1BGfufUoVI/aU2yAm6bFBDS16rEkB2k4S85ZbUsWt6YAJ23mAHDcM6Ba2NmxhzApzW0xVYLjSTtjf7KNcK654aymwE5ZuJwI2geEV1LuSFDkqdZlrVjUKllk3MjEzi4BKF68BtW+QkR16ZNgf0xls1pCWk/3BNzPb9Rg2Y22K2pofeKB2WtDC7r8Qw2WgnbtvD5uFeFXDsLM+r9nLi6sKk0AIaZGnBwnU0cUNo5HGAFp0I5HZKqEakBjNzbtL6V5jUJ8m/HlbwovVDmnYd6bYXr2leF5XMqu7qiMEsQawJpLMYLDSjdpzeFBIGqliAuYGbgAsftVwBOhSiJ3E0sWB0ArIgZcUp24LJFdMzyvBA9PvwN5Fzye3gJ1qPi2b/AVpfmNyXRGmJf3achaAZQhDdKvngrG86hy/OmYGUIt3HSFwQUnlI79Js4jRL30cexovdORH522/wd9zozFRF01QSUaOxOVz8mADlTrbx/GXoOPwuDiB1cVa2JmTXgKNRmPkmBjnOr6jNzYYsV+6MwZdrCHemIbLnnkpz3eb/PN1l5Iqn9iC5XgP9KFNBYTSbNP9Xod3AW4IH0PNBgAS3g57ci6O3pB+2hZEGO/mHY89ZQ82TKYnr6Vfa1x/XIEOSlbFdTE+De
 D17sTy7C
 HEoOoUITKrLk/ZULqsR5i6Ag6tMtXssqBUulTSuE+NE+M/EtnSBs8UWrvuCV7PME9ASmLN7g9KVGqaQWmtdnLCq7f9ZeCqm3k7xfDjm6a/eL+kNewuGLnFw6L3R4/FTTEmFzpENXsgTJWGqL6aLlIgcOUP+hglE6CZsIvaEGQoQpVFwAJdCynG0kWEL9URVrk8+gOUsecmnTzakjgNUJor9ayLOo3szWAma0LagYcxQ+N/grbXR/67jsa4tZ1j9lNYyXui3pZUyV0O/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 11:56=E2=80=AFPM Pranjal Shrivastava <praan@google.=
com> wrote:
> On Thu, Jan 29, 2026 at 09:24:54PM +0000, David Matlack wrote:

> >  int __init vfio_pci_liveupdate_init(void)
> >  {
> > +     int ret;
> > +
> >       if (!liveupdate_enabled())
> >               return 0;
> >
> > -     return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > +     ret =3D liveupdate_register_file_handler(&vfio_pci_liveupdate_fh)=
;
> > +     if (ret)
> > +             return ret;
>
> Nit: We might need to handle the retval here if we remove the
> liveupdate_enabled() check above (as discussed in patch 2).

I think you mean for the below call to pci_liveupdate_register_fh(),
but yes agreed :).

