Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97520CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 22:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A648E01E7; Thu, 30 Oct 2025 18:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13758E009F; Thu, 30 Oct 2025 18:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B43E8E01E7; Thu, 30 Oct 2025 18:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84D6B8E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:29:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7E7612A9A4
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:29:06 +0000 (UTC)
X-FDA: 84056222292.18.6AEA63B
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id BD0E94000D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:29:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=epe5O20x;
	spf=pass (imf07.hostedemail.com: domain of "prvs=73982f053d=amastro@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=73982f053d=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761863345; a=rsa-sha256;
	cv=none;
	b=VQ0zpI0GPVBKNeN85gnBSWZ4c9UgTkg5aOd3/S70fuf+oRE2hbe0q4/NLYF3JPPguwQh2V
	QLogHxvYCrmEvX1PpXfanCE4RKPkWOkvqiwmw1PoBvRyiMSB6Z8CshWarJZ63jTMQG8Mf3
	Gt6/tBBY3HM0ZyxgGz3I26j6MS08OAc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=epe5O20x;
	spf=pass (imf07.hostedemail.com: domain of "prvs=73982f053d=amastro@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=73982f053d=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761863345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60MefK3DxP+BN/HIANh8ofusObRmU+P87CCGRx3MEO0=;
	b=YgiVYJAAFYewCysJULtpEuYxun7oBMefDVd5mGEJWufVfp5QNpTzXqZmAhtFJNwuoHBy2t
	9RSoTIicMaQU2GGe7Yo78R2agPYr8oaHTXeIsYsIDzXoXbwLpUNo4Xm4mcCSV2ZdgiuDqg
	2ZqdSENnY67gdefkwONanQat9V+x8xA=
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59UM3pna1895091;
	Thu, 30 Oct 2025 15:28:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=60MefK3DxP+BN/HIANh8ofusObRmU+P87CCGRx3MEO0=; b=epe5O20xyR3j
	YqdW4KFFW/hKSzMmP6zxpSgyY+iAjdoiRJ/+1fZ+wpMdqBODgMbL3NtPVqIm9fXn
	x8KD+nhge1tAFU+UM7ib57i84EfUejMrkp4ywkavIftCYdfYPL+rg5TyuM4egAxp
	v730WeuN1y8ewqJYkdxzs+vF0OKA/mBfAZff8Mdlq8EyvuSoLvqO75SdNAY16w6j
	uZbkq8Y021f4I7CD+rct0ho/uS5M6fGUedgN4CujHW513K4iArOZm0gmlsx+gPqZ
	Qi8bw00rL9JiY8406oULQSWADhgiBvzYco4K9/0e4d4uZWV47Eh97AQSmjhfQ0Yg
	vjFgzZ4jXg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a4aakbt30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 30 Oct 2025 15:28:47 -0700 (PDT)
Received: from devgpu015.cco6.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 30 Oct 2025 22:28:44 +0000
Date: Thu, 30 Oct 2025 15:28:39 -0700
From: Alex Mastro <amastro@fb.com>
To: Leon Romanovsky <leon@kernel.org>
CC: David Matlack <dmatlack@google.com>,
        Alex Williamson
	<alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <iommu@lists.linux.dev>,
        Jens Axboe
	<axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linaro-mm-sig@lists.linaro.org>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-pci@vger.kernel.org>, Logan Gunthorpe
	<logang@deltatee.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin
 Murphy <robin.murphy@arm.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Vivek
 Kasireddy <vivek.kasireddy@intel.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <aQPmlwaoqPPFeyN/@devgpu015.cco6.facebook.com>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <CALzav=cj_g8ndvbWdm=dukW+37cDh04k1n7ssFrDG+dN3D+cbw@mail.gmail.com>
 <20251028120207.GQ12554@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251028120207.GQ12554@unreal>
X-Originating-IP: [2620:10d:c0a8:1b::8e35]
X-Proofpoint-GUID: 0ZpO7X-t6Kgi2VjTgweWDl_lcxnq2iwh
X-Authority-Analysis: v=2.4 cv=MKVtWcZl c=1 sm=1 tr=0 ts=6903e69f cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=7nlfRzPPCwOAtMVn9e4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 a=nl4s5V0KI7Kw-pW0DWrs:22
 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: 0ZpO7X-t6Kgi2VjTgweWDl_lcxnq2iwh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDE5MCBTYWx0ZWRfX9llSfoX60trR
 mXbkBVBl55Urqb11S4qwjm/pObJY1X+1S60diRRsEHth5MOf7IKq4Czoup72ugb8Fl7vtg6Umws
 T0wR1zGVKO57L2GHA+0qVpD49RE7de+O2DlACYm/FDEOQ+atQFmHmE8OEvSGvK9Gg4KMjnnZt8P
 9eo89vLlcLa+5jC4ltXqN6ZnruT3+bwwmAoV+36wLcYx0ULiPIRAKmAFs3n7/cl40zFJ4huLoWi
 lhzkX2aFxuaPfA92Kwt7K+H/vFc1bREnntF0tAc+FIeWaqYsNtchscW+GO7K0feCvrH6ojQzyNc
 9LmYvsWx+Z1+kjfzugACbFQ5EapodjjO8oosw2rM7ft6LeldzwV/2j0JbuFgschcLfnZT3p4l5a
 f0vHibOGQ5TJGIf/lMEHHGx/tX27mA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_07,2025-10-29_03,2025-10-01_01
X-Rspam-User: 
X-Stat-Signature: bze1pet7w4ng6pkej1xe1fwy185goa9g
X-Rspamd-Queue-Id: BD0E94000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1761863344-532096
X-HE-Meta: U2FsdGVkX18s5rz8g6eWeWRLN25iyogmGVaPU3Pccp8la1xnAjXt65citFSEF43ZqxcmCVXLFepMFAU8Vlxi/xN6u5fDwy3l0ZY1H0e+JnQqC9p1gqNrGDPqrMlZF4BkxEMabZw+rNId5wvh6p6K7NUlV1YZSscphZ4h2wLrBBIFKAZAn/8vLlOjHZN6oNt8EzrvM9+gTsqpaLH0vTYRMGSdOMQoqhk2h+L5AuH1HJZS3d9dJuUc7/NXPg2phvZkQZAuxKCfkSTKmKMEheUjFi3qh72IbeQ2MyKE7+xe1OHrpHGy//x8EJCSFGCXfKOCV5KyRryD+A/qq6wKS1NYP8tt6pBYNHb0anUieQUnCY6o9EP9FCQoai+pH8G5FdRyIB56WnTtuWt10zWqOoxVSSDaAm3794qCLRGarbTTIo/vdgsH2rRblyfo3Zp8EkNrfVyklx2br5hx7livWyAotxjhk9X5kal2lMc2Yyi5BFYTxHcveNWuB0gCf9WfqaK4Xzju8e+PW0J3Wk5Nc9UxQZHi94qoAHLcUKm2U0iUlj6jqCLhGiT492w0GxQ7JdTGfiuLZf7L3VsZAri7DTgAXvwWmhIPimJbnxkGzXX5PtFIsN/mnLYL555FnTn5o+ZtIhNaZ1X2XTgcyMOSodrUlSS117WWdy0HItjvarRsqqDhrRK6d8hFVgILUbfQAyvVifEYzIqwx0IV63BztNCgd4Ey0o6rfhxXYOyQAuC9gBhnQrfpTyDWFsioEFLdm48kxUI7ekg6vKHrsT/EXyaq5uWCB5petx+UExWrNZTMt88BU+nk9ziR+iWGSnwCrd/oDvdbu2BXqSimP9W9ivtY3N/I9UnkFnLHkmGI5QDebXK4I+IVT+IJ8vG8LAuCAyB+KIgnt4Xx+D2s5GhtzuGtb8HI6P+AoNUJVXRacKUQWUZl0i4y4i6LkY++8iroL0kkdYpKLMrN3jRyrnsWQLJ
 A4tdJYyA
 IM7/Qx9bnD45aazZKTtNImi2ozOd4wAWyFeSNi9NWVBNDKcqcKXmG02nppub6l+DDtTrpgl0p45LyN9lYflhUMV6NHNGIsVvo5a4yfUKRsIFLb1dfbloJtllLwJ1njCCWN1qQIyqP3KlNaMXvP6UuTABFSTKVBz1331i8SXYpJ5dhfPTxwFJR+ZsXUF8m+hxGVdCg4pBOr/lxaTJFqhSACSKKDgQi46/7s1sknKeB809nto+kQNsAqr9Y8FkhLsdeikWDHT2INSIf3O3slX6m7jNCB4+1HMbL2jE7ETeJOXbCZ1qWVdG/wknqAzM7M8Tr1GpkZD22UjpOpq40blHG6TGZLOWQG3RBkcYj+eUt64sVOT1YFGf/52PpXxTuok7kwWgB7t8Tt+Ugxv0orvMXMSxvRYpZNw5evuVN3b6W89FRn8prdsezvt4PiuFK2ZDUAnMEir3WVX1pu98veht/zChrwV+B+Fvj7JyvRiGabbIksXS5XRYFctfwSljBAJFFwT5JupgeXdlu4cQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon, Oct 27, 2025 at 04:13:05PM -0700, David Matlack wrote:
> > On Mon, Oct 13, 2025 at 8:44 AM Leon Romanovsky <leon@kernel.org> wrote:
> > This uAPI would be a good candidate for a VFIO selftest. You can test
> > that it returns an error when it's supposed to, and a valid fd when
> > it's supposed to. And once the iommufd importer side is ready, we can
> > extend the test and verify that the fd can be mapped into iommufd.
> 
> No problem, I'll add such test, but let's focus on making sure that this
> series is accepted first.

Along similar lines, perhaps adding vfio as src/vfio_memory.c dmabuf provider
to perftest [1] could be useful for low-level end-to-end validation.

https://github.com/linux-rdma/perftest

