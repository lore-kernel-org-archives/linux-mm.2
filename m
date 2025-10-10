Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3226ECCD18A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 14:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D8E8E0017; Fri, 10 Oct 2025 10:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7455D8E0003; Fri, 10 Oct 2025 10:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65ABC8E0017; Fri, 10 Oct 2025 10:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52AA88E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:58:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE7A386DE1
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:58:40 +0000 (UTC)
X-FDA: 83982511200.25.0894045
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1FB840007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:58:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jQopEoGk;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760108319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/f5MiBij3IECEF2d6NbqhVZBoXbyknaX3YNy+v2jBg=;
	b=1Fzi/d89Ef7MjhhND4Hoi3d2zJGUhNLsd+rn20tfwofckR9t+K2kcy4/8W/NyJqBnXYMQ+
	eYEgRRijdRGmSL+JJoJZjkq+ai3WBdTESZAzQ20XngwCeGBeWoWgU8FwneFBq0R+CZl91S
	2AmhUWBXuNdlkxFimvEvTYyqQ123dVo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jQopEoGk;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760108319; a=rsa-sha256;
	cv=none;
	b=CZUbxRzU8D4ItB3GEP6/zmf7VxAUyBosIsuWP61MmvzIQ0+7QDkfXrprfKRGxL4l0s4aCC
	fqJXuaLT7n2R8QGf+arOxnJRjPgDmq4M6iuC7dxFiSQ27T0cTMh2X15dLjWxuLx75tC61q
	kWZKoUlvObZgStG6j649+RNNsk0mXnQ=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4da894db6e9so21023081cf.0
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760108318; x=1760713118; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/f5MiBij3IECEF2d6NbqhVZBoXbyknaX3YNy+v2jBg=;
        b=jQopEoGkBkJFujhtkRmwK2J/Gnwiwd5Dh5senv7zQWKtGL94+97r8kXzKQD4j3XmwO
         8uxLRaEpAWYsgMQeNgOMM6QgzsMVz83Wo6Mucp+psUSt23v3quZXgNcKY8Nu8VjrAjes
         GJXuoeaaLrU7KjN9XYLopf+TaJ4jJxxq6OawoStZYLSCLk7a0EEBbsFMxiIErZYLB/os
         JL2z66BIhadmWXmOh5LHGc+p1QnTpWgAhNedOezKV8xDnBANVuRikRkhFto4tQQEP6+S
         fLAqlMZjfuz0zVp08dCHoAlt/xcKonZjUgStMiLvYV39mkm4BZKxCqV8raoe4R/U14hL
         JfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760108318; x=1760713118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O/f5MiBij3IECEF2d6NbqhVZBoXbyknaX3YNy+v2jBg=;
        b=QUJyWLSHE4oJZWVGwqP+1PuVg0bnwWB5DYm8IdsHg9PtJclDeJ1lWQWpBnbPcg3mQA
         Z1mpaw8pLzdiiF/V6jzghDSLk8FKxuPCcxDnXaFlOUxRfiNzMg6UuaHvzIRICSZsvyL2
         XWR7adL56FjK23iF6FYGEt3I62f7mfA75joX5PUU9L8EDyJc8QWID8yBhmvSO831R4QX
         X92vRG2lP8+jWmpqLz3ZSThCfvDvoOJg1y3x3yYfPWjbodFE4W76OUqWQ/JUuXvknFUt
         TWPmOR9vKWJ9ovIt210vRSfYf6avCv0DYzdGqWUhaCrxZJ5LhA+ax6Aywlnow8x8sHoW
         tSlA==
X-Forwarded-Encrypted: i=1; AJvYcCWfIBPT/0+G6O14iTvXotMFeb7p27V5UwJv60zZY8lyZe/Gk8kKYDeS/wPlmcF91xj11vlToKf+Wg==@kvack.org
X-Gm-Message-State: AOJu0Yzd9GjaHq3BCTdO+XSkoCKm2Eiwu/2hL+IpBlBG4rdbKg6r9o+4
	WSD4NCKCti0WkpfX6FqcxxYOmyBi+b5Ah/t/V+BojMhfdpzUJYQ+L/g+yuPIyiKJedXW4MxZxr+
	XgeTcVOdScdIOXgSUp6S9RXPuXYLY3fItl/hFlyFF2A==
X-Gm-Gg: ASbGncswEsazxiY3QvWXwLbp2woSTjHDXVjBVbimKLeqXjfySbUYBfu/PkL2RWROX3T
	JY1Ex8pXkSK3mFLUGzXIKZV8bFP5+ML65MYls2ZkPcZKeRRnkwlo62yoJs9SeeQjqemxo1DQ8jT
	UzKHUPtSFadhsX3nB5Enc89eV0dGvNdnsiqOYmo6iTMntfhbfJGENZHr9pkYqH36O6iWLfRJLQA
	30vhj4SsiU8P/oswY9eSAc=
X-Google-Smtp-Source: AGHT+IE0WXDhjauHLcC2POBv0t7LgQCplfzbTEHy7h2aL8mobxzYVpt1EHLlI6ZDdZuKo41ZojriIaW0+E5fBHESUrw=
X-Received: by 2002:a05:622a:90f:b0:4b9:b915:a26f with SMTP id
 d75a77b69052e-4e6ead514a2mr181154551cf.52.1760108317513; Fri, 10 Oct 2025
 07:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <CAAywjhT_9vV-V+BBs1_=QqhCGQqHo89qWy7r5zW1ej51yHPGJA@mail.gmail.com>
 <CA+CK2bAe3yk4NocURmihcuTNPUcb2-K0JCaQQ5GJ4B58YLEwEw@mail.gmail.com> <20251010144248.GB3901471@nvidia.com>
In-Reply-To: <20251010144248.GB3901471@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 10 Oct 2025 10:58:00 -0400
X-Gm-Features: AS18NWBORXQFPGvPP__b4olxbKs0hTzftz4XLJRMqdjSudzyOrwIdA4I2ICtXVo
Message-ID: <CA+CK2bBxMpb=jXy3-i19PdBHqxLoLrMMg1sOnditOYwNe1Fr+w@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1FB840007
X-Stat-Signature: zmcuczy4hztzo4ip64nnfpwkji6k8bpm
X-Rspam-User: 
X-HE-Tag: 1760108318-13967
X-HE-Meta: U2FsdGVkX18+PGJK3UV5ODKE80xPZDvci6/MefNMTGBFyFjnfdPnsEIh8lIxc0ZCihyfaNivqYpS+DA5dnAapYBlSN6LRhkyy0YzEVyn4g4Ha9Z5vxHGazIVe0eWdRrLx35FIOV5SeGalbZRFkWNvkYCEyFMDRmByoRYqLo6bteoX/531eS0pQOUhDAAOpSYqYUyCyWeIpHObb6K+9lGrUQ0/WQ8Wq1MksFTtIsMewiWOdYHeaC6wV5HTwOJ/54/Nn5I8UI2kWafOb6o4I4J6PmHZqdsdxfw0sgPKrauLtTClzvU6Qdyc5FNt6S63NhXOtyvQR4lGj/qt+Q5Qf20mkPmI7OhYEdThqLM6DhO0ss7TyrCQdzTLvtk7VWF9ZDy7zQYNfldXhfg7crTN9clsaM27+s2FCKvzr5XN2ZI1nWwr0Jrrzu815wbCqgt1bbSPB79LKlUOMMjLN6TsxG9lh3gXUe3zi1xNgUkVMFdTP5BvrJMEDVHlmQQ9OIzjfa8zQb4VbwXLeiTcyAcEfIe4+SwYtlDZoKd8y76aslQOv5+fY0yJs4Ay0Co2VdL+4Epbn4VfISHV9OL1d+wxrcdLaIwbI8um/ysKB7L1bZsaFLN/r2mRfIQv8Dq6xoyDdt2hDkuRB81DDQ2Wu1bKrB5zKiNauDw/OMWl8eECr7Qt5yEZx4VjmFfDaRkhUX6O1+6EwU6TvSfmzCZeUwqV4RlnF6KF3DGiUwrenEG/JCFejXsYvdVn7ZYupAcq8hbsrNvxH2n0EfBifZwHBOTUa/8sdEzAMRascmnifQfPLeLeEXmLo/0Xpfjad9UqjKkWo83mnUBkrTuehjKxkf176b7nXrpUBlbpnvZdKE6DbHOJ9sbJh7FU+yNGWXqai/DMAKNL9IQG9Bm5IjXfiHwh6++0Y5KuHghVZbotQtujh81EJjK2qTYIVmXlR73HkwU9lrnwUayYUuSPaqL+bXKo1F
 Rsvmf1WX
 WxOkd//A0IsqWo9NkCghg4C6ZivGWlUSHvm8qtW+3WrWzB+d47wuA/OfJu0kR3lnI9UsST/vKtLRJlTAcSHxg5r/yrhhGsyfHNFNLeNWpAyldgVG25RIine7zN7Mlky1csSDMsCcU6CdvHc3md7byfrkhgSRBfVwCaOPCwZyVExzz/gC/cXOSgEGBuQvG07ZtKBbWR1rqU9MAmza38Nu+LF2G5JDFX2plXUSxf1xA+BdLjIMpj8goPyzuscyJrQ3lkPXDjPRbIkNHqJYAIFkBfouKJnpOYebODkoN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 10:42=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Thu, Oct 09, 2025 at 06:42:09PM -0400, Pasha Tatashin wrote:
> >
> > It looks like the combination of an enforced ordering:
> > Preservation: A->B->C->D
> > Un-preservation: D->C->B->A
> > Retrieval: A->B->C->D
> >
> > and the FLB Global State (where data is automatically created and
> > destroyed when a particular file type participates in a live update)
> > solves the need for this query mechanism. For example, the IOMMU
> > driver/core can add its data only when an iommufd is preserved and add
> > more data as more iommufds are added. The preserved data is also
> > automatically removed once the live update is finished or canceled.
>
> IDK I think we should try to be flexible on the restoration order.

It is easier to be inflexible at first and then relax the requirement
than the other way around. I think it is alright to enforce the order
for now, as it is driven only by userspace.

> Eg, if we project ahead to when we might need to preserve kvm and
> iommufd FDs as well, the order would likely be:
>
> Preservation: memfd -> kvm -> iommufd -> vfio
> Retrieval: iommud_domain (early boot) kvm -> iommufd -> vfio -> memfd

At some point, we will implement orphaned VMs, where a VM can run
without a VMM during the live-update period. This would allow us to
reduce the blackout time and later enable vCPUs to keep running even
during kexec.

With that, I would assume KVM itself would drive the live update and
would make LUO calls to preserve the resources in an orderly fashion
and then restore them in the same order during boot.

Pasha

