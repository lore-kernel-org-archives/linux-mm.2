Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D79CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 02:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C078E0005; Thu,  9 Oct 2025 22:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273768E0002; Thu,  9 Oct 2025 22:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AFEA8E0005; Thu,  9 Oct 2025 22:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4438E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:38:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C16EB3178
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:38:24 +0000 (UTC)
X-FDA: 83980645728.20.E5BCA23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B431C40004
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:38:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcFwUYce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760063902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=koOuGfTReYEJwZmNoarOtdPItzHNV5UMSp8rxF7LzXM=;
	b=OyyVxcEkwgSznGlpbwcYGxsB0t/oh7tTJNV3WVWLJV1fzQjIVcSmLt7YnRMA7HgoJOMT/S
	0cDAF6Iti6OCQ+b8iHV/I8FHo8Wv7kA2OQx6zXWCw/B/hb6UKoA6GibXoRDOca8YrDKWtt
	oDzctdm0QvBn61KHTH+VsKHLAhQ0JgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760063902; a=rsa-sha256;
	cv=none;
	b=Lx+HYEjiUkHoz1YVnO9lmYN+arFMPMYbKF0pT666M2kP68ESblL0RY3z9YMgizXXe1c8ih
	zCWiiMiDwQk71PMv5AiszOAeSx/lzefW6ruSKyc1IBK9YpwDZRkHDfCkyD/2lFVJo+wV5A
	cNpCjarlFT8gAZbhcYpnvGWggFEkaS0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcFwUYce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A723348DF5
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ECBC116C6
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760063901;
	bh=koOuGfTReYEJwZmNoarOtdPItzHNV5UMSp8rxF7LzXM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KcFwUYceSs+cBWbs1J7aBkAbATDEd4WWGpfCvfJoQIjKuR4djsZzJqqaoFzHwQd1r
	 OvN6J26fIcbK08Zn80K7+4O7tSO3P+N05tBT/hD6dXZ0FOPQ6WpTiQ7dZotBRSx6F4
	 j1/OILN2lXQGm85TuEXGeb9tLiFEhc9bpQDEWGHzG5E+KDoXdiJwUivVp1evAyiKL3
	 XJFoHi6HKhPZVVYHzLhij8fNVFux5/31cRFIaeU3iOisC+YcOdRiZd4vzA79ZSWcwC
	 0boU7yVZBii/klTs+8rPONQSrceIbJTkUpRcgNmybi/WaGRJ8e2IKDKtZUbpo8bXxH
	 mdmhltgHpNQHg==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-635fde9cd06so1715750d50.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 19:38:21 -0700 (PDT)
X-Gm-Message-State: AOJu0YwNEo6AFkwuIYCo/6kbBbDMdLINsRnS+oo4dsfVtc+LFQ5NZtHL
	En1g7XAl1aFrgxPGfZKMxz4TyWhn6nmawm42N4x47Tv1N+hUJd7KOQON4JbqVby56sFIx0uYBE1
	lU4BqJkyjnkedYqolrr7ZJlCq1cJFJCf1aj4D1QvYxA==
X-Google-Smtp-Source: AGHT+IHM0DIXHWgZ1Txeg53WIUDrF4ZwMwgnRgZqvD7JOct6wwUlL8FGTLNo+Uz4o8e7rf3CtJz3r0qWHEAF3pUrxq0=
X-Received: by 2002:a53:b705:0:b0:635:4ecd:5fd2 with SMTP id
 956f58d0204a3-63ccb918824mr7457137d50.47.1760063900815; Thu, 09 Oct 2025
 19:38:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250930063311.14126-1-bhe@redhat.com> <aN3vnTumKZTrJvNb@MiWiFi-R3L-srv>
In-Reply-To: <aN3vnTumKZTrJvNb@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 9 Oct 2025 19:38:09 -0700
X-Gmail-Original-Message-ID: <CACePvbWRA6NiiKYF=U58VHW_Q1EXBXkun=n4Oa5p16J5y8Qftw@mail.gmail.com>
X-Gm-Features: AS18NWBPOJPAXpkMm4oddiHBp_mzPOf0srhDkJpRem5nN_1ju53VcLaufLcZU-g
Message-ID: <CACePvbWRA6NiiKYF=U58VHW_Q1EXBXkun=n4Oa5p16J5y8Qftw@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] mm/swapfile.c: select the swap device with default
 priority round robin
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kasong@tencent.com, youngjun.park@lge.com, 
	aaron.lu@intel.com, baohua@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, Baoquan He <bhe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B431C40004
X-Rspamd-Server: rspam02
X-Stat-Signature: fjtq7iosyep5b4uecbi593nufdpdakbn
X-HE-Tag: 1760063902-941214
X-HE-Meta: U2FsdGVkX1911s73xuSBpR8+Q470AiNInlSZHLYnx6FgJn0oy3Qz5h/p8mMsBeZQJXDj13+7r56kHfSaT+xQFPG3KA5+8F24lnaNQ3NTJC8KuFbDQX53roSNpKnc2HkJfWBjo5SFamNupIp10gfWZ62zRTvbir/TmOdEqAZi9nyadytq2T1QzBBXpxiSBhLrATBzumpe4hAPmle5++yUvYYSyjcI/nzDp69ad+KOz/lvc7SxHRQkCphcAgsBtu0VRdBHCwIjc3x4KWxnjfyJqkZ37pnuzcya5nbdFtu85cH/Cjchczuo/ABFymzRs/CnIpWIRzjpYTt+3007/XHQQ9ExrT7UbrVIMH1OdBPVPLdptMa9TxVt7kj5LgEbJeeVorIieF022R7gVWN1d0QLfE2RFN/elO1Mwy5lUT801LsQmZ25josqYz7AfboNJ20eeTx6j6JbOCBl7P/9Nk3SBsgyqWLlVVocsG0mrWY7zM8tAQyGuQCJHF2Cuo6xxDt7WzUUDPe+1t2XsXCItztvrCN94aKtB0SWqyQ4lHbcFsJC+YOiBDP8o6PkrGSVzK5If4JjG7SrmqR+uYSanB3ooHx21RkHZq7AjPGyo4cM/M0Z+UtsNPliZ+DiadXe/Dyi89kSfEAclh4ATDKJkgASOOhPXFtNGO8Q0VpdqQF2GsA1FnTwyOaNF8rk/VRKaBYgRSRBFUmOjLpdKs4jA2US7RiDKnR6cwb0X5C2grK90sESsQ2hHHhWmYV0swq0eTWOURJTGf7w+Fv7kEGnWWjepoj7NImBc3XO+1OP9cOuDV0rkwQfiEZvz3ErTThCE7z1fD6iMQHJDbfXIairSlSX67C97gjcA7C4t3M4+MNFgcm0oCnhqvgZBz0yPeaIQLArpnteLA/tvNavQxtTOPDPcS71QxgTMdqoe6k2EIrueL2OLEjr1AmP2ybHN8Jt6kHimFNzGUgJr7Vwu6z5Llj
 7j3iufjk
 vIygvtzuKBGlEm8Tt8ABesn4KnmunNxiaqfwSBogG2Sran8cPB2j2AzJlKQ4Vvxtw/A16bWsGvwqSRxPPNehegtJLjTFDRxBhlFxVCPaLjWOVQ962eCElpVUiO+G8pShf8PN6tNZgf9P53edpjiU5syt7+6Vayt7R02PpjAmooOT/yQcppTlbmwUT/3vM4rfIKe47wBlPVarqaDbejQlv3vCwK/VKBpCZhKkp9R0NESPwgpYuZxcAO9fFRBfhzi7NXqenO5sY263+Y7gA3fdRXzE9wJatQqoC9/EjZJu5uzuT9cjtPKNhi3b7Ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

I have reviewed and Ack on both patches in this series.

This series cleans up the per node id complexity and gains about 18%
performance in the constructed test. Please add it to mm-unstable.

Chris

On Wed, Oct 1, 2025 at 8:21=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 09/30/25 at 02:33pm, Baoquan He wrote:
> > Currently, on system with multiple swap devices, swap allocation will
> > select one swap device according to priority. The swap device with the
> > highest priority will be chosen to allocate firstly.
>
> Oops, forgot adding Chris's Suggested-by in this v3 series. The
> Suggested-by tag was added in v1, but I forgot adding it when
> splitting v1 patch into two patches in v3.
>
> I can add it if v4 is needed, or I may need ping Andrew to help add this
> if v3 is OK for merging.
>
> Thanks
> Baoquan
>
>

