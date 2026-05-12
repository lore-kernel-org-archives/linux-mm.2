Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A8E0CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391696B0092; Tue, 12 May 2026 03:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342136B0093; Tue, 12 May 2026 03:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E736B0095; Tue, 12 May 2026 03:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1881F6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:17:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F9E01203C1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:17:13 +0000 (UTC)
X-FDA: 84757911546.09.042BC44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C40A6A0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:17:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIrRBVhM;
	spf=pass (imf25.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJHclFQXF18N17dMI1WUkkOAH7zQLXcP8+f8FCNiVFI=;
	b=V0WacD1oLf2BVxgnczxvTTBV7SE//dip2aXxw6oNW6q4Jx1kE18k7C46IjdlFQAI1YxB3C
	BrRDG/1TWvBlhpjEBbZDqBfEj/EnJ85Kwe0gpqpnK0QQGAb9FFf4AKHZhGWZH6F2185NNq
	0i3FognGwQa5fYOKsAJn6h689ulELZQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIrRBVhM;
	spf=pass (imf25.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570231; a=rsa-sha256;
	cv=none;
	b=oKXpE9+ZUp71j+dWomHCoFOR8UubxZ/VUFX1Q/C8MiSfqVmTmuEaOuvFoE9x/C7g0NjUG+
	nFOCx6hHO3E/AKgnLNxxSOQz37b0AUAHW2oDcdQEXSLc2jyvuqavY9jEsQTkSGUb7UaYfL
	tQV4eCmuOTU1VT6DXxL8QC1pvuT1wNw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0860542B1E;
	Tue, 12 May 2026 07:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB1EC2BCB0;
	Tue, 12 May 2026 07:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778570230;
	bh=98mFo7pkXXhyp9+X2ioMv1DmZPs1w2tyrej7VobxKEk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iIrRBVhMsfcFd8c2S3m3a8T0kcFhIOtgvw+B1wc4Z+F9AGHqa2Q4wJLfDihSwuvKA
	 9EHcoUhMUamvE0OG5XYIdztmYfey90VXjjTFqwg3o2L6rXQ9SkypKXMe5MeYQjKCPU
	 tsvV+fBHpWRp4j166nAtQPNhdKJVpvb+lAwRMS+df1+5x7pjtjuYvfzhnW29hq2GtH
	 8o1S+/mUmIon2yUaU3SJRUwZKHtx6T6N+tJJ2t2uoihJJtq2Ym+RSFldlpzI/doRk8
	 3JxjxZkF5Srvye0Gf8WDLX0nDvfUzScbFHdd73uZu3gax6MKiiqMjCYtozBL3MMONV
	 pmRlkBWUhk5hA==
Message-ID: <44a01a39-c902-4c54-a7a6-07bc1f4d5f06@kernel.org>
Date: Tue, 12 May 2026 16:17:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] swap: restrict to regular files or block devices
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-5-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C40A6A0002
X-Stat-Signature: kd4px188j5hpbmsp7hajjppa4g4zhafs
X-HE-Tag: 1778570231-97144
X-HE-Meta: U2FsdGVkX18xnthXlpSpOsgPHN8HYLZ5VLmH8wJLFnSnkFAWq1B6WqyI2431TCWZhEhqAOcRsC9/M+VgBeGiNFLL4EP2tWmynaVLLJG+6RineUcQgUmctYB6F8w7wh9hR09XMYJBjlujeXERVmsf0f9PclDPbXdmWJXCGQEM3UJ037YEU/Yxpgdfps2tl+P+pP9SoXWru9uMKZLi2VAGLnd+J9kZMRX214SheF4HU6q3G11nnoWrp9gK6SJcaoRczLYioqqlUEU2wRoALjoDEJwPCLXXWoAoXGeEc0f3Xq7zFUxVAh3REbbDrKS7V14vq6pJjj40OGgeUTrKLUBPoeMhYwJtM6/tPLZh0lRm4LgoO7YN/IX7R2SyLExRHa+HO33owWxxesCuKMgMNgvriuRwe0ZkO7Sy2BZ5y5+lIFt20vf48l5DIgu+2buZq3KCEzo7vFI1zaf0TLqMP9GO1iyM/t2F42GubdRPFDyJBzSk+Nz4Zq7hy3nk+LSNhK8Oh6Dx0fsmLYvqqmzc0Cem21y3GonTLlzgZ8pGxxJ0qOiHJEnmaK6lS8+5yqtEq7RYq1YdUKnYJjLz3pOiyENyFjcryKkLTsFCdQiq5XypWhaRcU3OKL63VjIDFw8zZM39+WxE6T6KZjs3kHImmrMP/6J7ja57acL4tcoST7LwYxW48fhkYAFBcqztgF0HJRcCUvXkqeT59I+Vv3L/VpK6HU2e10y8wFEF3W9EwVtxZVAFMA2PFozWN0NSFoyePOVNwzvvZ0Okoa+P5x4Fkt1ZjPnHDWIy08LWksAuGGyf+mifVTUa8pFQVAeJVbLSLC1wiI/EQ6m43MUagWUfmpIE/IVBMDaxbPqXm8AIHu6QjTsijKQe3VedAtJnXCSh1+PGHeXDVyJVNd1fgoKUYI2wFRQ0Obyf+jEciwcA6cQMVal8FJY2CDPVvV01L31iWBRHHPtIz8ZTCOCVx0DxPUU
 a3zL8api
 izjtX5jRgSqvMa607reMQL3swKTbBHJja7enPB4kb4lyWRCe3jQm8VXKraGiCQBuPexoUxm3keX7haw/RyIZsh8ulFLH96gXZu2ulK3Liaq+viiLg1nBomlCXaPyye+fQw/G7wcUbGKFuiDSBDQ2xFSL8P+LWdrf6AFrf63kquTZypRL5E4RxjTLEEVCbABaiC0mLdnCcgWUE0o6iQjVgNKAEufgbx1rgplLzOF7E10KIrGHgXLDMATDNW/KknvSLa0KCUqRD9zqw6kamZyyHewFNYdcfQ5AX90WvT4ggnyjwg6E5H/S2Oo2u8jWcOQesVLVm3pUu0dH3TA4OPhCTICapYYmCpamriy1bDpx7z6mMwJ9cuepcgJ/tAdhKoO4FS4DQmrIXi6ow1GOIWSxFC0IaWcS7Xy6i8ZgOSStXSSVokjQ4B6iJiKr1+QPyx//89otC8BF0GyEores=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> Various swap code assumes it runs either on a block device or on a
> regular file.  Make this restriction explicit using checks right
> after opening the file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

