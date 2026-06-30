Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403C6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 00:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBDFF6B00A6; Mon, 29 Jun 2026 20:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3AE56B00A8; Mon, 29 Jun 2026 20:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C1E6B00A6; Mon, 29 Jun 2026 20:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 856E16B00A4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:07:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D55DA1C68D5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:06:59 +0000 (UTC)
X-FDA: 84934638558.10.A0D2BBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3B10FA0008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:06:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=USBc7FPR;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782778018;
	b=hsK1XDvAiBVVfXFjax9CsPj0XRxNPtCgXIze80HxExT1o6gm01jxvu3iBumG1ayG2yV5tc
	icwv+NshmWXngUmxbJrak4y52L3qhsEx74lzclQMD8Jgj9YzZdVxOI9u/+LGFStl3BdA+q
	TE2/rzqyXi2bC+3brbIrNYftA8dwCP0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782778018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rdd22wUNJeSeBAxSgra0m8c0OqrzMGZhMBav1VBCRnc=;
	b=hNm0W0U8X5WmVwgwZvwg6Zq+sBbj6A0nzeJGGzfANQCISuZwhcLGmOs2TkUfgDurig+ZN3
	g2N9GESgd+v/QRlPWnphysxSJ+upHLb6IK4wp5T+CXMbys0G0iZFNdmtnrAdgnMqBKQPro
	DpikUU9q0EoaLLzXLneyAQjCvEAWHy0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=USBc7FPR;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C088560008;
	Tue, 30 Jun 2026 00:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5CF1F000E9;
	Tue, 30 Jun 2026 00:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782778017;
	bh=rdd22wUNJeSeBAxSgra0m8c0OqrzMGZhMBav1VBCRnc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=USBc7FPRZ4xTMksC0a8oiz0gtczsa03CQCr+LaeTXZRgKQg1YL3akDHAahGCayirK
	 /f2zbntvoZgUM0IFuSk2fmhGxdo90Dt3eiy6ZxvPWye4xWuOD1IpviHb+mKH+lMh/p
	 tdObjw8zl6tfmXlNW7ntBRHnM3HoGBxOiWqFvOCg=
Date: Mon, 29 Jun 2026 17:06:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Alistair Popple <apopple@nvidia.com>, Balbir Singh
 <balbirs@nvidia.com>, Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Subject: Re: [PATCH] lib: test_hmm: use device devt for coherent device
 range selection
Message-Id: <20260629170656.2c5408b46b1ce53183f672dd@linux-foundation.org>
In-Reply-To: <178277581197.172200.16265155329935822153.stgit@skinsburskii>
References: <178277581197.172200.16265155329935822153.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d7bcq6p1jnjc1xtso53i9oxybd697pth
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B10FA0008
X-HE-Tag: 1782778018-883975
X-HE-Meta: U2FsdGVkX1+Ldwf7RqE3DlROGAwrHknYYi+sG0mwjF+sw1qxfcK4idbhkV6J3h0ldKEOWFSWW9n1eHpqV/V4luqlhLkNencabkz1jkBs9VOUTmxqV+akgWqaXXhdk7hwsjH/4b5hAih+9sgpAnjz9fuKBd/P0BnCkMwv/GI0wleV1n+l10SYv0ZaHCt27wlJzAPqf45AXh25/Hugn/HocRgWR7k0bdwp34/GpBr1+nMiyKOKh0CDZg1whw0e/RjrF95I8yiwlpAhkBszMdgxrAXh95nS5mI+MWO1AubnLClMOSxe/fdUmNWwOpk6BsZhdQxxwMK/Z+FMjUGS4ZRQVw/a/oQ8e7w640zYqNI0t7D6eOtvVfoBhvDcsvxKGClNEG0pbwVhLFG49h/a4QcADli9JFudH+DzNdfBuAN+JtcGCj5UdvrNwvk0WJLwGJ+lgcKbh54zeJOrpAQCeNB680ZBmP2amIoHQnxgMlvAkgGCMtsp3R6yhktxTzyqxuHDdV2l2bXqtu1ao37HWLC1o5U2ZRS+IAEYCKIPy7vZ6uYUtd2lpCVNBQnZv9Ts7amlpGR6w2Mj8lrPomNgtiH5H8mNtEWHhwMttbJSpyp9iJ5LjupC8U3Ult4doQnBDmfJaXEpHCqanAbh36MeUvPDqkzaZF3xvWEiQ7wT6e9uqDbcWSIL/o6cZ30Vw3fYdL8cH1/FMwx3QhuHcYap8M8SfP+fMrPcz0qczh4fruM7pSUcvGLdjYPxJwaD/XrVzE0txXk9isO8kx0cMWCVfa4/Z4tV28KuUsmEwBW2ehiBIC/U93HDUBWYm+AzOa0tsXJ4Wt6cdOj8Y+8C2cVmzlLcSXs9KmpyxippwvFL1fmMHvZeZBjTvr3yi/D2jRu5+uRA5MNWQtPBhboqn9mqT7CbyOW838pJ2y+2Pf3TtxGGAspGkSZJXkMSU1cQPy2HWfTe/iXJf+Ox37RLxb/Nreo
 nNujT/12
 5CK8ot5KRpGw5CIiw1VlTdeqA1k6YFxa7dJp3MOxhHJkczmkrBbPoXo1zEnT2Wx+tTwhDAFBViPX/0c6/sdZdiT7FEaEme8mrOaqdIEPkGlaeVDhLrcLe5nJgfrCFKFv65aEYb2eIA2G5ZfsnEh4R32pV+khoE2jO+EQbOtZ6q13PHqN+UuMWhwt5ePyfzwPZ/APf30ZYPjvQ7enhX32y6kpTsw1pmXwP3ktnvv+cLTYg8DUEkOM0+xI4psbeRQyA03MjQbE3Gx2q3qicBBAoIPQyB9rCkJuWFoPD7AcP8L+pbVoRWW/OjfoTfRA80sT/04B6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 16:30:14 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> Commit af69016dab96 ("lib: test_hmm: implement a device release method")
> moved the initial dmirror_allocate_chunk() call before cdev_device_add().
> That means the struct cdev has not been added yet, so cdev_add() has not
> initialized mdevice->cdevice.dev.
> 
> The coherent-device range selection uses the device minor to choose between
> spm_addr_dev0 and spm_addr_dev1. Reading MINOR(mdevice->cdevice.dev) before
> cdev_add() therefore always sees an uninitialized dev_t. As a result, both
> coherent devices select the same physical range, and adding the second
> device fails due to the overlapping dev_pagemap range.
> 
> Use mdevice->device.devt instead. It is initialized in
> dmirror_device_init() before dmirror_allocate_chunk() is called and is the
> same dev_t later passed to cdev_device_add().

Thanks.

> Fixes: af69016dab96 ("lib: test_hmm: implement a device release method")

We should cc the people involved with that commit.  Added.

> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -581,7 +581,7 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
>  		devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
>  		break;
>  	case HMM_DMIRROR_MEMORY_DEVICE_COHERENT:
> -		devmem->pagemap.range.start = (MINOR(mdevice->cdevice.dev) - 2) ?
> +		devmem->pagemap.range.start = (MINOR(mdevice->device.devt) - 2) ?
>  							spm_addr_dev0 :
>  							spm_addr_dev1;
>  		devmem->pagemap.range.end = devmem->pagemap.range.start +
> 

af69016dab96 had cc:stable, so I'll add cc:stable to this patch, to
help ensure that it lands in the appropriate places.


