Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E642AED7BBA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29CFB6B0088; Tue, 14 Apr 2026 06:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274506B008A; Tue, 14 Apr 2026 06:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1086B0092; Tue, 14 Apr 2026 06:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0778C6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:48:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC58CE39C3
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:48:37 +0000 (UTC)
X-FDA: 84656837874.06.1215B30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 228D0A000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:48:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UeOFDlJj;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776163716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4kqHGQ1cFGIORnso1zpJlioS11Ozzc+aPpThAfOLJE=;
	b=Wpjuj/Mi/+dwkj86r4epe1LqMk3Dy+kLg/Mu5UNfBYGxZs0VkuqmNDoZzF4Tvw/P++jDmH
	RRpiENHN/uX8f+f7NiwATZVMiQCK81np8fcBQfTZZRkaeaRTIIUh+Yy0sUeMA0BV2ymstI
	3ahvbqZ3RlOW35qewkuDxRDbtuHm6yI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UeOFDlJj;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776163716; a=rsa-sha256;
	cv=none;
	b=UVm+wXyRNzgdE7CYqjvMeBinVFKOZqFXJ9KHS0Rv3h8ab9D9jEEyokfi0O2KCJCMsGk4dL
	+uTNBGqoa3SfykaPPB9ZJMyUBO9+CW3tvdOYaImig+SVglVD3+MTCNi/FD5QvzomEJ7yoA
	WRD/5iUjD1Pjd4N2mgypHOuuCGJOM5I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C090600AD;
	Tue, 14 Apr 2026 10:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE4BC19425;
	Tue, 14 Apr 2026 10:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776163715;
	bh=FcuOSY66nnyC/9KTZ8YOG6PDQjM+7tRpQL3hXqVwo/0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UeOFDlJjm5T2Bk/qNnZm6+wzFjUl6kO74MwQ8W+rF2ClMvhXSMCLaEnG8nEcEh0e8
	 7t3jJbBKOcSnpnLLB8ATQ3auwto2XRu/tV3fna6WYLFjg6mnNc3OMV1+RnFEeVjF7T
	 khyXbrBVphkeDwDcmUhxuoS61pp9yC9fnVEaMrQYRdx6T5G1qr0pWWjH8EYUlcLD4C
	 +FPiUQXt4AsQdgRtb/ud8Lyg9T0vWtYWx6sx9nZfO9N0VQ/aTU7otBrajsOBuHnvO5
	 qUoKklGcDEf8L1LUt4cgp0wKt9UgJ14tLatseFzsVuwFfErTj5oNu6dLTbFhRY/L3l
	 yCLK1/G9ifRDQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: DaeMyung Kang <charsyam@gmail.com>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  akpm@linux-foundation.org,
  pratyush@kernel.org,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memfd_luo: account restored large folios correctly
In-Reply-To: <20260413165053.164338-1-charsyam@gmail.com> (DaeMyung Kang's
	message of "Tue, 14 Apr 2026 01:50:53 +0900")
References: <20260413165053.164338-1-charsyam@gmail.com>
Date: Tue, 14 Apr 2026 10:48:32 +0000
Message-ID: <2vxzik9t95rz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 228D0A000E
X-Stat-Signature: srd95f9nfwepk5hhaqbcszwkesod7p8m
X-Rspam-User: 
X-HE-Tag: 1776163715-726300
X-HE-Meta: U2FsdGVkX19w0NNULfl+eZ6A65f7l1NQbHjDvRKWe6syQdSqGyjxrLNQR/ylY5cjOK+ouHq2asV+SRQVMWeWXxhmJlD+jVtKnH1N7KdzmxMqk/cYkkeL3NNME7hUTXKT6UJmkxatMs9GurIhsGcnI/ZNZskFpk0Fhm20LkjDm4OTHpcS6Wppo+UMdujvh/S9S0hPFFiFuULJ/mDJpKc88NegbnoEf03NCA08Rl3WLXAcbb8Phi+BrhneUKv/TxO2tBqxn5euCaAKEhZUWMNlZM7qst+OZpb0k+m6wQn3o2X69wwPIXzSyg1knubZLxs7p1TR8VqxWYFzNTI3+tYQl9shUKMs/ROi8ySDHI+n9QHnX6PIQIQCWQb7Mr4Wqvq0cLf3pWAIrIf4Il5qPcuCuZ3lGyKkNBt2l9YdvvW4fKD2Rda06kZcWs6+Cx3qEzrv+j4G+8p0YnnIjILS47sYtbyDUfLd/5vjanhwQwCBFqpacG7mc7QdLvEfHJW4AVEIIqAybFYxu3DwuUGDYSoxKVpSyywwa7vHaAKdd1ScQqZwbW8/RN4Z5wsor6RUu0d+1ILWb3OHq9TjtT8OOJrECGiURgjB/hdrrdm40iOiU0iwEOSPHrBQiK2xkG7sD7NxkYoLZ6Czki023BvBRa2LVjuYxHNs2PwXd6BtSR5Fdlv0n/A41tGmTbio/CgzMfLML+pWLGNA2MhGo0MA2O1wjKNxVaW59gwotJKH+A2xuWW4O1hdhhsM3QIZjG2C97msfGcbp8qXUs1ZxV3QftCUsomRf4c1DKRNoJx+zzbqkTRI+ZUgpGubQQzAlSAeFpOsXhBcSraMgtmKgi41xgvbEMW1HZN26UqeNh4FNBFWIBZlZyNGKoHb1wow5rTNjrM/dWzp4yY1lkBaenJEefwWlKgra2HyS9ydBi6VxqiZnkTqHagHbjjsFmKelTHox/boiElUooEsTyhAzsxsl3e
 1X184UsK
 nykrQIQ+TniwRnd1LuJILTdy6UhTT/tSfGUBwDk2y6W17XZYsDplFzFwVXApLB0gJKNd3TaBFeZWrw5Ub8Wogc5yFbTCVrkjLQ8ZDXLMpSebCAz+O3GUfA8A1atBBn4D6HQOUVNSfprJc5mSytk68dZtXBqLjiJBQyM3d8rt0w8DN/FA3RHUeAoxfkzFMhVOMeM7y7B+JCkiOfvy5GJkfBMrI7vVs8kRWpUCDYj/f0ecFd89ancZWIE9dtz2KMvNLVhyK2I6m8nC6drM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi DaeMyung,

On Tue, Apr 14 2026, DaeMyung Kang wrote:

> memfd_luo_retrieve_folios() always passes 1 to
> shmem_inode_acct_blocks() and shmem_recalc_inode(), even when the
> restored folio spans multiple pages.
>
> That mismatches the normal shmem path: shmem_add_to_page_cache()
> accounts the folio in mapping->nrpages using folio_nr_pages(folio),
> and shmem_alloc_and_add_folio() passes the same page count to
> shmem_inode_acct_blocks() and shmem_recalc_inode().
>
> As a result, restored large folios are under-accounted in shmem inode
> and block accounting.
>
> Use folio_nr_pages(folio) here as well.
>
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>

Thanks for the patch. This bug is already fixed by this patch [0].

[0] https://lore.kernel.org/linux-mm/20260326084727.118437-2-duanchenghao@kylinos.cn/

[...]

-- 
Regards,
Pratyush Yadav

