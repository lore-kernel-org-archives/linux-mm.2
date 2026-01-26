Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04126D19501
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663DD6B0089; Mon, 26 Jan 2026 11:33:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611536B008A; Mon, 26 Jan 2026 11:33:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E026B008C; Mon, 26 Jan 2026 11:33:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 433346B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:33:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E07A516084D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:33:30 +0000 (UTC)
X-FDA: 84374660580.14.66A4DA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D854E2000C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:33:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=glECKte0;
	spf=pass (imf13.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769445209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1110P4O7LSi8WXqTz4jJ2LZI4BaN9AEgj7xeGQ57r+U=;
	b=QPDpCLBcA7DMIZMUzjWZp0Glj4LqymrcBLtBcjKCTQNSAMVxYWdsqjql2LDLnIj2msOvbk
	skb53o0DNCS++c+2oDY2ImnzqIIJ1taabO+cpFUqZKm3k8+UwnxdOUTldE8/YdFcLvef8R
	BAPmza6JmCIET2RkbCxmuiigu8tZDpY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=glECKte0;
	spf=pass (imf13.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769445209; a=rsa-sha256;
	cv=none;
	b=wPGkbR9RnOLoo9Tc+bsGXlEbC1SDGWudnaNw7atmU49YKnZgQ+8Kboqoyx008LrZkGjl+o
	bw6hnqUInMYxjB36SroSlIA3U8Oev30xjmy7McRoaaI8LTlnjkh3vtM2i5LZjsVNSWc6v8
	uz4t0IMW/WzCh3uFTq6aX31JBuIO+l4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A73F544414
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFF1C2BC87
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769445207;
	bh=1110P4O7LSi8WXqTz4jJ2LZI4BaN9AEgj7xeGQ57r+U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=glECKte0WuS1YaFZsotEBg9TsBrqPwW3Bmaqw+8bw+t94iKX8xFkDbiwMSPxOR039
	 E+LVjcee3NO/cjovpE9rIvAv89/EPdT6BuUAdDGFjpV6IbF5Rqe90jUwA0bSx93kZg
	 8Lm7QUmQlG5sdwKcN+W7s/YVREHZBDRXgcg2pcI94yqWk2ckiXayUn2fvE5V7FXxOk
	 R1rSGT7j8AGPp9x3xIyCg6gFigG90GRLLcOR6UjTljc+Wn3gx/+uRkTa3AIZ75nTri
	 gobdHZNZxddV5Px+L1FCv7Zia/QVpcCbft+oR/PAMTMmMANX1RDYURX68wXmPdETRF
	 P4cdrj3qoQrLw==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6581327d6baso7159684a12.3
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:33:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUO14MQ0sBFCyGUPuldrTCGlY/8ZulvDaAgVDdM2Jpr6fqy0Gv+ZuGngMc6KaR/fLyvT3oVwFTijA==@kvack.org
X-Gm-Message-State: AOJu0Yy7rg/8cWuVZCyX4DVc88tvMD4JA2cSrp3eUVXdV76YqCmSA/dq
	W/MOrCldjk7gqWEwtMhoJa7VUblZEuCoNi/bLD9BjyXBP9XjLld09w3Iz2YN1whDKKEwtvfbyR+
	8jjaIoRRi/s6aLNKwdPFmjYE+2PGLMA==
X-Received: by 2002:a05:6402:51c7:b0:658:330c:f9af with SMTP id
 4fb4d7f45d1cf-658706de926mr2985790a12.23.1769445205840; Mon, 26 Jan 2026
 08:33:25 -0800 (PST)
MIME-Version: 1.0
References: <CGME20251210002053eucas1p1d1408ad0fb49a49bf4371687f8df7395@eucas1p1.samsung.com>
 <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
 <X-TH#1.CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com>
 <99dc91c9-59fd-47c5-b1d9-157bda86ad59@samsung.com> <CAL_JsqK5QEZfyRTDY4z88mX_eYENibea1ZM8H_bEfCCsOOwY4A@mail.gmail.com>
 <89f8895f-436d-4a73-a2c8-d61a2f4ee41a@samsung.com>
In-Reply-To: <89f8895f-436d-4a73-a2c8-d61a2f4ee41a@samsung.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 26 Jan 2026 10:33:13 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKWd2H0bV9Z8REMBYd2hPMTjDO1T4dYehM-QvemB9zrDg@mail.gmail.com>
X-Gm-Features: AZwV_Qi4bswXzMTlSSlXlrhMA8xIhaBGN8wj5n0NOyn4w1lHAZaZH4If-414C3k
Message-ID: <CAL_JsqKWd2H0bV9Z8REMBYd2hPMTjDO1T4dYehM-QvemB9zrDg@mail.gmail.com>
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>, ye.li@oss.nxp.com, 
	kernel@oss.qualcomm.com, saravanak@google.com, akpm@linux-foundation.org, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	robin.murphy@arm.com, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev, 
	quic_c_gdjako@quicinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D854E2000C
X-Stat-Signature: yaoa7694skwk48enbnpg3xgrjjom5bk4
X-Rspam-User: 
X-HE-Tag: 1769445208-108042
X-HE-Meta: U2FsdGVkX196c1SDZ1DZ9dew2q210ee9xgIfIhVASDY/ejomYxwkety1FhKzHRC1rmbk65U2ibdWQY1gbQtS3cztRtDRbIW2LONCEXK1YK5+L8h8lgCBTqts5qBSwXSuzwWihBks+NgJnD8kTLs6Zs8afz2X9CIrdFBRsQlOqVoihq35FtPfedBvg76mxNR73D9wdLD0Gr0mS3dMkzVniIKEEc3obsW+be9j1D9xz+KHHFbNmPwfG2PI5qQEBloOf3/OBdGQLqLVkeG43SsKStGhqBdBsfxnQ2vXiqCDq57Eq6ZkIi9WRF9SFP6kwVKYtETv2KG5NEelGZ0pgp6OMZ8EfteQyRyPpmAl2U1bHf9v6BmymvRjF9pgajWPvnUoiCajBSGJoXYkB8LJ8pJeTHJ5o65ib9ZeBYY+ETe4gIvWLKnqIQjsDXzxBdwq06EAJExAB1SYEe9MEXL0JW4bilr4G/G3M2BiSA5eclO0ESvMeJ0BRvIrS+mYid2NHveNq6DvpfxCsM2PGP9OxVvJEJ2hxLo1GKG2JJ4yMavjN3LYP4+qnahZFxv4voQb2PD2FRWyaTLlY2UuYoAWdOvv+rXEg8HdG0BwXMlcc4iKvBEMfU/dqZZnY3Nab1hnEhzsbhK5cBSsqCX2W0/STGgVFGnXg+UDJiiIWkzksQPS36Pbu/hAq9zOVhhCbUQT3BhBMEi6yB/kmaJji46cV9rsuKW+OcckV+B69/NvptarnM2DrmdNjLJ2ZV4SF4Fj4M7eUacmZzZtQ9y1WRrK07esgNRwrcLjH+cpNRttXCwfpTD5OolRZSn9ufZrgEOWDhaDZf/GPcxWSq64PXv2m1FkuAJEorMUEMgsOr+57zp/B5EXspxHhOgmSBFf6c2KpSo9srS00cH1uWNb44xG1udVdYrak6xDVA9O/OOoITGIrgz3OgTtgm0YLR/m+A4ltX5FFeV1vTbA7bDyPBw8NCY
 vLJtY51w
 ssPs+G8pnWl53eR/TVc+gO5dbPhsPug2klgy/vhPBcNCqfVMg6eMLcZyegEoAXmQe9MTHo6/b8WmFpxvENktspN4/nwyR+8mtZ7BJlK9qfgUgMXAgOtKn/qkF9cbJtq4lAhMqy+9Wc6DXyLm2wl3RdEYGGMDZpY6SurxWOlQqsjlqKFYFTcvrROezpMAT1w0KJCd+CvOQg0GxZ5V3wO3IVz/+hQakSMeTCKcbfQS+LZFmcUkJyjhaFwAWyRNbGstjeA+soXNrXStHx2r+s9vLQxMkx7r1hZNR0aEQqUfaDUovJgEuh8AaUkCEtN2mC/LkPJYpberBqgP1YfdMKze8+rvJsHXMV7eXHNWpC/oEal6Ob2oHVjOkm5OA8Y2oecPHEczxLEigZ0KA7+6g3x/EeoP74A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 4:38=E2=80=AFAM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> On 18.12.2025 15:42, Rob Herring wrote:
> > On Thu, Dec 18, 2025 at 3:55=E2=80=AFAM Marek Szyprowski
> > <m.szyprowski@samsung.com> wrote:
> >> On 10.12.2025 15:07, Rob Herring wrote:
> >>> On Tue, Dec 9, 2025 at 6:20=E2=80=AFPM Oreoluwa Babatunde
> >>> <oreoluwa.babatunde@oss.qualcomm.com> wrote:
> >>>> When initializing the default cma region, the "cma=3D" kernel parame=
ter
> >>>> takes priority over a DT defined linux,cma-default region. Hence, gi=
ve
> >>>> the reserved_mem framework the ability to detect this so that the DT
> >>>> defined cma region can skip initialization accordingly.
> >>> Please explain here why this is a new problem. Presumably the
> >>> RESERVEDMEM_OF_DECLARE hook after commit xxxx gets called before the
> >>> early_param hook. And why is it now earlier?
> >>>
> >>> I don't really like the state/ordering having to be worried about in =
2 places.
> >> I also don't like this spaghetti, but it originates from
> >> commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
> >> memory regions are processed") and the first fixup for it: 2c223f7239f=
3
> >> ("of: reserved_mem: Restructure call site for
> >> dma_contiguous_early_fixup()").
> > Honestly, this code wasn't great before. Every time it is touched it
> > breaks someone.
>
> Indeed it got a bit complicated and needs some improvement, but first I
> want to fix the the reported regression. This patch does this and it
> looks that there are no ideas how to fix this in a different way. Rob,
> could I apply it via dma-mapping-fixes?

Sigh, yes.

Acked-by: Rob Herring (Arm) <robh@kernel.org>

Rob

