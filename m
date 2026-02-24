Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D82F4BB67
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654596B0088; Tue, 24 Feb 2026 12:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B8E6B0089; Tue, 24 Feb 2026 12:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D336B008A; Tue, 24 Feb 2026 12:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4996B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:37:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2F671C1AD
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:37:29 +0000 (UTC)
X-FDA: 84480057018.09.2A7E113
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 03E1AA0009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:37:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d2CWFYXU;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771954648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVyG+GjslObEPoiorlcEtEb0lbImQuwl2+xBSlYjPvU=;
	b=FTeMopM8rW+WfGvRU4NkjESN87bZQD3ac8Gog+BqGKPWxTf/+M0l3ByPSjw8RO2oWlsZ6L
	YHj4GLCLWQ3oYRQKmNwDwIUqlYxMA+M6kXaWp2pV9MlFXtRHZcLHTh3dVufEh2YwTxPVsl
	WUd3JpeUUocYEoeXqhMLqU3aBixNpdg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d2CWFYXU;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771954648; a=rsa-sha256;
	cv=pass;
	b=d5bWhynxANnLNuUYV8eiaABPiSkbKXJCSWM1cSMl463QjtDWrXxRa3mwA1dulr8wZW+/ub
	U3+UOPGpHOVjtTtnJXPC2x4XlaGVZqDMcvLmzx+JqmwuPLVzcVbSsLdSxH+SpkoQDjZp+y
	b+/9h2gZjHOlL5KU5pNjZQFq8JdI3W8=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-56641b5a471so4990191e0c.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:37:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771954647; cv=none;
        d=google.com; s=arc-20240605;
        b=ghxLRKwJy9hMiyaUGe73Pd1oNENkwHNdU9VEel5cNMr4RHiNS+SbDUpPjhtHtWX1hE
         AXWNTffO7T7iDxKZciV8EKhmxRpNZ4UwxL3YPRrp45D4za9c1X+pBSCVTHygztDUcapc
         tC+tyY86KV3Jpr+cZ0+Lq+KRu4rtkLh8aX/Oy5GkAQT+TCD5i7jtVWXbopFKxCMhRr6V
         HJ8ugaCD8MKPFqi66qGsE2wdNocHvxx/gNAvm5802edM0ueCCRwF9xa3zM+vg9OAG5gl
         BXQZ97I4MZdcib45PKBIciH2qbOstPWE1/bxG8sWYtX/fpRAjZBLCI8yMtHPhvZo8xBC
         DYxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WVyG+GjslObEPoiorlcEtEb0lbImQuwl2+xBSlYjPvU=;
        fh=9rbl/omNmj+Y9MYqhP6lmZL8Hh0v/rVsRkaMzQ+pMBQ=;
        b=LwWgTPTLzDFRff6yOAfRMDBQA7iGzP4yRRZJNi/yJLNTrhyEEwY2dZTGja70JaEfT/
         Qw73t03J84i/Aty/kR53ig6yoz4rabOIRnD/CItgUwPA1rWaiM0Ujo+t/wIyVkR9sVZ+
         93gcGUUmdHQUWbQ050/lzh4DDxsMcMytPDS+J0qlagp1GH0MJpVOhHLYltthKTnmxqiS
         JgDAtowpMFVusGowmuprNfiRpkN7I44C04g1Xiuklk6Yr+iFpm92xtlqCh5THfbsalVO
         Ilr6CML/dBpRMMIZc6fRJTkHRpjoi9dYWkKYRR8pDNgp9EghcocnIz+5iEpsrJKjVkdy
         4wCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771954647; x=1772559447; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVyG+GjslObEPoiorlcEtEb0lbImQuwl2+xBSlYjPvU=;
        b=d2CWFYXU4QwGroRVpkcqiu75oH1PX1KaOE/iYmR7mLwXEwRTLdMmQ5gAracjDtRvne
         u+Ke9bUR/UCB7hvlqS2CVVahcdPUC+jjg6sVlfDej+eocljfjLf84HsXMb7I9WOzMZWv
         rCuWGxiI+TLVBsv8hnTy1sTHuRymNhoaP6WwL8Xlk5K44vH1yW3NWamBDsIPKvG43lL3
         lsXrGNG9MkcctTLzVOa5Kh2ZUvx5nVy9YgLhnOyNNDVa41HpFk+Xrcksp80e27gy+Abx
         NUuRiPDq+W7rfDpIW1dqq9N2hPldJ93srSa717rQPfGzJCcVntVJbAusne1Ymn5cWRfB
         wfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771954647; x=1772559447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WVyG+GjslObEPoiorlcEtEb0lbImQuwl2+xBSlYjPvU=;
        b=HYjidBv3BatwYQkbw/33YCWAcDWjWADqd4e7hMpc/b+h/yqND0na5cEyWrSR97TUkm
         ZRfnv/fzRiPTUujcrVaVW9WHRRz2yIduu3ugRhIn8y+k0BiTYE5sW2tcWrXjW1FTcZyp
         EE/a0Rd290Ni3E99GGm7fchSi8wGMEysGpmmW2e1ZX6MBUFmJVahEJVC1OG2cdHwz2iY
         XY/H/+N1dF7ton6LVn1u19/uZfC17XbQ/KNYbnQI04PTY1dAiWMQOkVuL/1zQ6M+R/bz
         3Yx5hS2ben9nPFDaj3mURXAouk808toW4SnTGuWZ7xg31SgScig6k4QD6SbY+UG++AdO
         kvlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXv196NP5TRuxWXdgtPnDHLPSojz516mbIsx45rM99ubVylNpJmKW/HmZBECNrVQkgVK+2bdQbM8w==@kvack.org
X-Gm-Message-State: AOJu0YwELfKuNMPu2GgFEHV5Yvn7d331cnNxoz3x1Zz8y3HEKlk1aGpM
	h4LX8RJBfANuQ5zPY0ZV3ES7Xs6ZgyrNXLC2jG6XskPXXoiHBUzbqnjB9XS4NLS4aO29VVXNrv+
	5oTq0eLAJXmu3fDt6yWmr9VrBTuFOvnIae9qhiRjy
X-Gm-Gg: ATEYQzxmUVFVmmbKFKS0ZCzjx3QaWIQSOEwPfyqDqsGilcfaG2G1g9zQflKzHmqE7yq
	5dRBExsOV2UdZsBiuBPojK1DN2KlIshCzVqkU1q26qb0MHFsvlSagrjts4WU2Z/hd4AhfXQsGnJ
	aWvnaKcn/S0KaMbmUkQ99pahLW2ARcRb1PDx6oLBr1qHQz1odhsSibbAZwgX5pHnrNsVzGnqT2Y
	kXPTdB4t9Lhfxx+tA9tmrTY7Jvgg88fqTf4vlfdvVoPDWVztkhdxhD+ePcfPYlB38j+764VSv0+
	ZpJVFW8=
X-Received: by 2002:a05:6102:e11:b0:5f5:3835:4796 with SMTP id
 ada2fe7eead31-5feb2eebe4fmr7234443137.15.1771954646379; Tue, 24 Feb 2026
 09:37:26 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-4-dmatlack@google.com>
 <aZ1xAyN0vgLWIi5y@google.com>
In-Reply-To: <aZ1xAyN0vgLWIi5y@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Feb 2026 09:36:50 -0800
X-Gm-Features: AaiRm51zYRUGqNlquBQBjZ_Ao68Y3fgUdHKViouV8m9qg-AcIptaKIFOE6taQzc
Message-ID: <CALzav=cMsDyUrOPgkr5ouROPmsEAN2icsL266M4FxY3P6BNd1w@mail.gmail.com>
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
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
X-Stat-Signature: rc31putd6g4i4g88zdck1xn1ag6rf6h3
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 03E1AA0009
X-HE-Tag: 1771954647-270191
X-HE-Meta: U2FsdGVkX1/v3RB25ykH0f2+NMswDc8rwVfNVNEs73f2xG/bUat+bL5ly2GC4pA3AGQ1e2MgXt/pCgt7jUJERzsWa7hGjUJAI66pSRydW5cSoLuuDt0LawfqoAZbEXroaVxc6gy2Fqhs97EsLxcXVOoeExN4Bol9RJF/erR7bauFKfPhGo7P9dyW+yg8MNE+XFK00yO9nc5fGanPPx+Vti97DuWSla2W8avnHKaFv0P6wOzALgczTMfiQo32VFukNRPQrjTOd+hTJO4elAI/i6DVC9E9FIALOYutzyOjXxZUlHbe9OK7nrVNN+nUCZiJrof6+7n3SXwFafDFLw8FTNT6LZzK8qPlmX+D4aqPfRGEj+9kIeQznxPSJZLYlyXVGG5Dpd6VlTeU/tsfy2ytb6O0CyQd/0IL3Rt20g7La2UZQljf51+YBn4g9A6Fnx93vwiq/6FUEdcf2q/xPKND9Htu37xE+EStiNLtHagp8xDtyxDv+8ADZCkQmwZBWfQurj+px6k17MYGKo9Kqut4r8S9IS4qHLF6DvjmT3VC0Qc5gC0JUBWyYpUGVhJbBOqQMwTyBYXi2L44Rpo0cXlHbPGg/Q2V2PbMpPz6VSdNRJ/lcEJYSGPYXstqw5GZfHmHntvOnk/4fnNY0uy2y4bhrXGadRnD/qPUEAvJ4Eke/r3kbJ5FyBvN7yYHZSHoLLu+rGfNYWXFbVvmzTWM+CqMX7bav5r5+ZrN4HqPEh2HBt+c+j9yCVfVs62F3wCPnYUZcr87RM5ckDPQeQpA2M9l19uD6DSdm1Mrq2tn4jWcl5ejR2wIKwDhhD3dQ4nsv8DO22OkBjo+SqoA4M2w9weBkCsQQSMxl805hE1a/w8cFe95eBFmEWTdQ7udixNs0aChYFGnCTm0RDUIDYJZVQ/THlRUEIc0J4Foo0YScjsvTRExF/CtlCg2eNQuTcbwG/49Xj6AeHBYiU2uyY5m7XI
 dsshvuOW
 FI0Z4mkgJeZqViu+nw9JU5ipio1RFA2YfiDfuejXT2gPVqRJR1DYeAnH+m+0JXCIEDxGL3/B9BH/rpdFFPpm79Xz80e5C0VIpHssNlFNOhkdAyJ8VzMlUdfkB0hHXB6VXapc68VuKc3VcW1R6elSd/0leO2r1UO4vI2w34dw1O9ww2aHe5OpFJOiUQpIB1YdVILdOjCdPelNrYtin+Cw4Xj5JiEPtJE6U0bBNq7tkzweKEPjyC8HZA9KVBnjmJes/S5/0MOo2ZUuvTLU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 1:36=E2=80=AFAM Pranjal Shrivastava <praan@google.c=
om> wrote:
> On Thu, Jan 29, 2026 at 09:24:50PM +0000, David Matlack wrote:

> > +     if (pci_liveupdate_incoming_nr_devices())
> > +             return false;
>
> Following the comment on Patch 2 regarding propagating errors, the check
> if (pci_liveupdate_incoming_nr_devices()) should be made explicit to
> distinguish between "Preservation Active" and "Retrieval Failed".

As mentioned in the previous patch, the errors mean "no incoming
devices" rather than "retrieval failed".

> >                               while (parent->parent) {
> > -                                     if ((!pcibios_assign_all_busses()=
) &&
> > +                                     if (!assign_all_busses &&
> >                                           (parent->busn_res.end > max) =
&&
> >                                           (parent->busn_res.end <=3D ma=
x+i)) {
> >                                               j =3D 1;
>
> Looks like we over-ride the pci=3Dassign-busses boot param here.
> We should document how this change affects the pci=3Dassign-busses kernel
> command line. If both are present, the inheritance required by LUO would
> likely take precedence to prevent DMA corruption, but a doc update & a
> warning to the user would be nice.

Good call, I'll add a log message and update kernel-parameters.txt in v3.

