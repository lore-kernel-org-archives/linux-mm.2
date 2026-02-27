Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A611039894
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2786E6B00E8; Fri, 27 Feb 2026 15:50:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226716B00E9; Fri, 27 Feb 2026 15:50:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126026B00EA; Fri, 27 Feb 2026 15:50:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 004DC6B00E8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:50:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DFFC14094A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:50:25 +0000 (UTC)
X-FDA: 84491429610.03.901BC5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E30C0A000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:50:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4Cs8gaQ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8MK6JH8AKZhdK0e7186/PO/qqo9DiK8MLMIyKiiV54=;
	b=7ByZpGzrC03X1VSzK+BqCwkfBnLCFzab9tbE5DTs8QAHDkOSfPS8dvk1uY+/FLi0OXHAOv
	dmz0AbuzjVnZ8pXHDNgt374wBPfBeaT/xf+bol+nllhRmEPVFkFM7A1peZ9ovE/I3OBFPZ
	qPUMUlplFfWF1BLLtogL+FRkbbLjzeA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4Cs8gaQ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225424; a=rsa-sha256;
	cv=none;
	b=gkhPvF9k1KhSuoT87q6GxennLOSQSF93puzY4MtbEa8+43JRZ6JGZYGxx6ENJ1wL/l5khB
	c4yE6IIPqpx/2oqVu1YAqpKZGhv4i1dFKFqHehqQ5wZ3Ns6WbrYRD6bLKsfVR+9v7oKmXb
	FBz8AuVJJgaVYB6QAMnd+wr+6uBgFWY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBAA042E1B;
	Fri, 27 Feb 2026 20:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B652C116C6;
	Fri, 27 Feb 2026 20:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772225422;
	bh=cUD1fb6TbAnY/4XOuasu6+cw4gbQ3g0YkiWs2+T4wvc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n4Cs8gaQvD83o2GnKHcSBRyUMTmI299u5BVS369CgFHyVH0hy3awrGVyT27raqlv7
	 99XZqYrnJh0AB0L3yHawhlhEeH5EFHLYEjR96eQMVTAA0pxjE0lIqd146w0gMwVz40
	 LvJNEgWKZCUKWAEMMyl07GxSD9EXkNgBhqCzFLAhaZ5R5A5buN5MjcyZTFUtPqjZ9m
	 Ifp2L5iyHs1DaWr8fnDY7FZqY9D+cOHd6OFp5fyrhR8H6hBYNmldTsT8hodrFbL7vZ
	 7jYT2zSzLRoSdf+icjC2k64jDgU1bsg7k9BYfDJmcbxWlvdfa4rmy02vXdDe8igHZZ
	 bUdftY2rnB3XA==
Message-ID: <c618e7a4-42c1-4438-9bc2-9c41450a81a2@kernel.org>
Date: Fri, 27 Feb 2026 21:50:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] page_reporting: change
 PAGE_REPORTING_DEFAULT_ORDER to -1
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 akpm@linux-foundation.org
Cc: mst@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260227140655.360696-5-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227140655.360696-5-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E30C0A000B
X-Stat-Signature: i38cdmq937mnpy35i8pnh6ykcxuedqhq
X-Rspam-User: 
X-HE-Tag: 1772225423-362660
X-HE-Meta: U2FsdGVkX18uEaouGqmPtd4d/ilc8xUWgSSWLCgvYDntet2YgkfLSoJmyrkhxNg2Q767OhpsZYYPa0l0D8akk0lLFZhHZQyJwn8VlwL35sQkIehOqEhxqII7OrUX4ARiemqsUjoOVH1vVlaf23ddVqYhq94XBbwNh+X6V/Bk/KecAY7dkPmLxdnCKa8pUlnHBr4aKVBV6vgwz23jMqa/GeupbWI8KpLSKETl05zc2dklIJdFfZX8GIrGYg3JbRuVWQZ0P3CH78dJk8Og12DojuuldVo3t4RwaVy9QXaHXe1+e93XJBJ+Y4xlggGbXn8tQsB+lUzRmZ9hs3wPSoKGFvdn3sq4u6jhI8Kvwwjf4rU8yRbaZDp7z9t4EaBclgrzE4MxNg+RP6INzbTDsJlv02iN7I0lSMJTjq7sz73o1Z/0udWm67s7zNN2s57N3iIedKHS1rCW/uxkD5xNq30SL86L8JeVXc4W+zSDAVsWHbKV+M7FYJ9IsszVwe+TpCDobi9iUKOpGRp4Fd8/jrruXUwquIg3PwoHE6B/1+Yt6ZIQsNich5rIj/4YRnxuARgA3iq51Jh12GVoYp+WLWGz3CyY4QE+y/UYlnfq04UuN8g7M8SXUfobKnPfYjV/B2iN3JBjyHXPx1TPs1mmKVp4xDVP0wbwdmAhQEQOBxGrn1+OiRbBRX3wB83EPYN8kJkl2sgi11i+Kv9bh/zn1iK8NoiPbWW6Mm9VET/ITsFhVm+s8z+ye6Be/pIMMNSNXrnhmtNcQ/Wdx5jap7/lCL7E/kX4sV7WSqN9WCdt8/AK39lRl4Ss/PVrRBcmE9Ik1+26UUaX9vr2gO8kUhGwL0aemYzNZmzIbjuc0kB2SkHegJO5emVaaDBK+pIvhJLMT3ouA64hSXDSjMH38o2fuje58jsd83Nnio+eIpOkOQ+mFMf+3p1R1XGt64Rb2Hnu4PWw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 15:06, Yuvraj Sakshith wrote:
> PAGE_REPORTING_DEFAULT_ORDER is now set to zero. This means,
> pages of order zero cannot be reported to a client/driver -- as zero
> is used to signal a fallback to MAX_PAGE_ORDER.
> 
> Change PAGE_REPORTING_DEFAULT_ORDER to (-1),
> so that zero can be used as a valid order with which pages can
> be reported.
> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> ---
>  include/linux/page_reporting.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> index a7e3e30f2..3eb3e26d8 100644
> --- a/include/linux/page_reporting.h
> +++ b/include/linux/page_reporting.h
> @@ -7,7 +7,7 @@
>  
>  /* This value should always be a power of 2, see page_reporting_cycle() */
>  #define PAGE_REPORTING_CAPACITY		32
> -#define PAGE_REPORTING_DEFAULT_ORDER	0
> +#define PAGE_REPORTING_DEFAULT_ORDER	(-1)

No need for the ().

Wondering whether we now also want to do in this patch:


diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index f0042d5743af..d432aadf9d07 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -11,8 +11,7 @@
 #include "page_reporting.h"
 #include "internal.h"

-/* Initialize to an unsupported value */
-unsigned int page_reporting_order = -1;
+unsigned int page_reporting_order = PAGE_REPORTING_DEFAULT_ORDER;

 static int page_order_update_notify(const char *val, const struct
kernel_param *kp)
 {
@@ -369,7 +368,7 @@ int page_reporting_register(struct
page_reporting_dev_info *prdev)
         * pageblock_order.
         */

-       if (page_reporting_order == -1) {
+       if (page_reporting_order == PAGE_REPORTING_DEFAULT_ORDER) {



(and wondering whether we should have called it
PAGE_REPORTING_USE_DEFAULT_ORDER to make it clearer that it is not an
actual order. Leaving that up to you :) )

-- 
Cheers,

David

