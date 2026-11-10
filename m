Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2139F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KND9vpqb
Received: by kanga.kvack.org (Postfix)
	id 445956B05B5; Tue, 10 Nov 2026 04:54:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF986B05B6; Tue, 10 Nov 2026 04:54:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E08E6B05B7; Tue, 10 Nov 2026 04:54:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 088E76B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:54:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0AAE120323
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:54:22 +0000 (UTC)
X-FDA: 85418749164.19.48B1F41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E58920003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:54:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KND9vpqb;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794304461;
	b=BM8pnJXvBXXW/rPLVMhs2QqVLuZRzaejzOEkQzHj8K+H7yYkeAlr5kvzkcUa9faBmO68Oh
	IsQNUr1aexmsjaYVU4YsOH5HtFmtd+TB4H9UtDniSCDb6WevP2L61CV33P/mdw0Nw31yWB
	q3XKx2i8VeBdKRo76s+qmSIAxPdGfLQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KND9vpqb;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794304461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dv+juQSa5jdjyDwYyEB7CxuxwRRYVallMJB1NLgyTUA=;
	b=r5PFSFZ+PIq7dqeKvwCkHsjbKYw01AziXTtVCz0YiMmv75GSGd9nt927a/MhYMr/CciUWe
	B3iuNDwtuRZQ3LTs7GxD98gy9vZH08Dp9StDsBrp9vkn4Fz2vn8OGNosx3P4advst43QCU
	PJbkbBqwwSusTQ4kqzaYTid2peWmHuk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CE7742DDD;
	Tue, 10 Nov 2026 09:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEB61F008A6;
	Tue, 10 Nov 2026 09:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794304460;
	bh=dv+juQSa5jdjyDwYyEB7CxuxwRRYVallMJB1NLgyTUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KND9vpqbeujQxLQxxuvvJ3vk2yhiAk+oF4tUnVR8O719EClhHZ6/0kORrruacKOJD
	 XybHdysDYPpiThqt8b6zTNhKYYxU0tRWlYEz6OCVH6pzQERdNH3jvWwgwfHJhXzul7
	 8B5PK5gQ94MI43Jq02DKuQ8G1nMWlIA3S/uKLUxFiJY9KNHktT7AMD9NxNidtRzP9n
	 3kZyhWE1kv1tluEljw6Z9egYEiEUdD8xbc3pnQrJlE0rquDv9Y8YrjFu3e13m4TA/I
	 vi7z0IIrNbsHizoeoHqAX619sFiX7UlaCAIb/bz9D36dU9l7aotOp8GePcv0Ax0CpR
	 ThQ3UOdJ1/WUw==
Date: Tue, 10 Nov 2026 09:54:12 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS: remove myself from MEMORY MANAGEMENT -
 RECLAIM
Message-ID: <avLppG5vGNIOo6zQ@gremlin>
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E58920003
X-Stat-Signature: afm4rxokztngxzx8bzyf6yigtxac4ya1
X-Rspam-User: 
X-HE-Tag: 1794304460-746395
X-HE-Meta: U2FsdGVkX1+BfKcwprJfLIrnEm48jv2G8/POm0vXofAC5zdApf7hDEU7yelPubnCUGpj2vLG2n/+UikvijQ9X1OAOViSx02CoF88rBzo3UJUcT4bPNOiuu83Or7+9y6BB25P7fKyn9aZTiveARdYWRhZIj6HFw+9QGE1NTDPl9nMZ2NebsE6cNY9mCr0fsEWPS6os8d51b1KuBRy6VkEhpqaAdb2Iu1VHnlepF9ZgPn41e9HCzx35F/1PHCg0QTW178l7kZhqWoopIx73lUIiaMSeT8ZsB8g3DGz6mU5DgW8WqgdQGC5UMDWSN53viAzwKUj3L2iA/eckCvp/b6V7OTDmp3jTDeJhfziQm6H7HA/HAwJlFnvHDBqgO3lBRV6LVnIFdnTsCUy+3+k0zTZeCup7jUg32SVebEsy3FWOSBIrB5Y0HClklfxQNtOk4E6xaLO4mZA0ZmCs7cVawT8hzJFjaKHrVlS8xSXGt5fb8LWX30o+a0wrjSgEGbyvrpIXpFRkKsT+hF60gd+pYj+y92Y7MyT0u82SzFZdm7SydS2ptmR/0IMFVLKuivpbfVTpjaMHKklDG3/BswgZohr57dRRkrh0qwqGoh6ApMTQkzme5TVn6Lk2fku6msy9hUuN8klkpUfW2tF794E+tMa85fw5XMwpxp74YF3sNhA58EDHIZyd2KriHpk33nJk/2ThcnmoL1wwRsBChIGeYF6Zbi98lfCNWbrLClsA+CaNS+VYAQ7+L2OXlyBD8UomzIaCROZT83QS9ko2INzCoguaMzGsg8cdzpmSimHhlaniOOZnLGGtbnwIVjLJXRXvotkAnejYu0CyHh+fwCH6vWHdKi4C9f2bPOpxpfNIbZzhuBtQ+hwAZYumVX49rUni8ZuHpKS9dfG6jBWIKzL6LooFaijptgKCm8boqOBauvY+YcUeTvoHklzwB0BMp1xVGg37q3+Dd3DRZ0+GmiI9o3
 8DV92DBf
 YZ57aQZsdyQ/BflBUEt1K/OC2/lbZ/MCx+O54nHjK3tdCn4GLmS9COXQKsO6apITsQzxtKThYZYmTlPvw2aia72JFCVf47UOrrsNkhy199EenhrnWCWhakcRby874mhn+yQf/MggshAQJRq+zOl5R0Pb3GJczk0jdkMhm4Vms6Bv9zAskgGtmUWfxIu9Zmhcx43ru0K9FFqI1sJiPACTMqSjpzNvRsh7CYWrp4VYhT7MapP3Vn39unc1YeZb/KJ7iLmxFjC9FdTmrFzXSkomPyC3JNETbALMqoTrC01SNESSPALunzA2AVwE2HQSpU5Vz2oQNZBE9lb6WvV1r1p3xfNaEIvJt4pNYmsi14mA+b5msKzVypDHVCv+ruCgEo9dFTZPE60f4/EkgR74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 07:31:54PM +0100, David Hildenbrand (Arm) wrote:
> I don't really get to look at most reclaim related stuff. For things
> that are actually relevant for me, I'm sure people will CC me.
>
> So remove myself from the MEMORY MANAGEMENT - RECLAIM section for now
> to have a bit less noise in my inbox.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Understandable! The ML is crazy of late.

And... Hmm... maybe time for me to pare down some of my R:'s too :)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e7ac319a570c..7dc8548236b9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17808,7 +17808,6 @@ F:	tools/mm/page_owner_sort.c
>  MEMORY MANAGEMENT - RECLAIM
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Johannes Weiner <hannes@cmpxchg.org>
> -R:	David Hildenbrand <david@kernel.org>
>  R:	Michal Hocko <mhocko@kernel.org>
>  R:	Qi Zheng <qi.zheng@linux.dev>
>  R:	Shakeel Butt <shakeel.butt@linux.dev>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

