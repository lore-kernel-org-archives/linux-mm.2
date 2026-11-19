Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170B5606B195
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGgKZMQu
Received: by kanga.kvack.org (Postfix)
	id 3BBB36B0644; Thu, 19 Nov 2026 08:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36CFE6B0645; Thu, 19 Nov 2026 08:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282436B0646; Thu, 19 Nov 2026 08:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 087316B0644
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:04:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F1EE120AB2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:04:51 +0000 (UTC)
X-FDA: 85451888382.19.3757289
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D2E4440008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:04:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGgKZMQu;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795093490;
	b=7DmztjmMw713jU9jz0bg4EzvJZ7z4/E1hW01DzLWKZw1vvgcxwWbdxKFd4LM4jxXAkpUUO
	QvuZYxWAMBvMsBSEYGw6o8Ezq+zP0kf6qLE04eO5kTfTCwQwwV2FLtkzr0GYBoYw6tKIEw
	r2kvLDUNDJoa0TfKjkIcnwCfmH5frIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795093490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4c8ungyxd7RexQhrWA/AoLG0CKBNNbv9BDRY26QePAo=;
	b=V580O8qRNcFcYQ3rd/yr5Rur9oBHrErsy37rANlN2s3+5ZLWyRYAw6+pLJhwnHt5iz48zg
	EcWfV45AEl6oAknykJ6qbtQeyshOMUP6RC7jmcedDlYlQxwD9kX+9qyGEtFmBA5lZ02nLR
	tcp3Xq+WVMqeHLs9DYYRTj8J3Oo0PWA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGgKZMQu;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D31BA407BC;
	Thu, 19 Nov 2026 13:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11DD1F000C4;
	Thu, 19 Nov 2026 13:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795093488;
	bh=4c8ungyxd7RexQhrWA/AoLG0CKBNNbv9BDRY26QePAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JGgKZMQuxgk09BHdmqO2j2nlgUEpHHOj1xGRM1Xotj3U8BRm4bf16g1xavHCr+G3l
	 u+mD0GxxJPxcvAmfmim3h8jcNhLxT4WkjUh9kxYYKnVhB1A1s+Li4DaabxcdWAnNbW
	 7sEihZNT/OITB118S5flqdaQbyoS1Tjoa01oF9SwpgWPcGfINtIilkA0UPNacAQVTt
	 XNxljucTL1IVkUcgSd8dy9pe5CNHC+8KFMo7DGb92Cg9ujqa2Xktu5tYPzDcqnBKgl
	 ObdtLxc6VwFuHon8akz9sj0juhx3vaer+5hNKe2nJNIOYZnws1kKyAT1khMqc3LIp/
	 vgPfH7UqzHDKA==
Date: Thu, 19 Nov 2026 14:04:44 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH] mm/mm_init: don't subtract managed CMA pages twice
Message-ID: <av7z7Im4bGE93zQ7@localhost.localdomain>
References: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
X-Stat-Signature: jxz6tac738gn8ggnwd4q5cy1fsygtkzr
X-Rspamd-Queue-Id: D2E4440008
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795093489-177983
X-HE-Meta: U2FsdGVkX1/ZmaoGIvz7HUxnWAAfDSrQxlNg7mJOEt+X4I1Cv+DXzpYRloD/yojuZ7RJyXZJbLwvD33dc7oOFHoa4h5mnBDepWvTjwW+/dNOxpPJ023MeKeU2zdlDwD+MRG1JZy9rzmFm/CTAxwGjvfKysm4zv3+lmiv7nQEjULpu9kH8EYOPjg9XrfZlDcdppn3/ulf3F12WsDGEiECNsP71Ef7X9gAO7Upe90rDNs2X2HcwzKE6bxnT6vnbRJIR4uN0drMot1fHQm59czpFnn4DIcsOoGRsmGEoKfI9269SBhf5V2wsOUPLktYBdU7Gp9A/DFzPiT0QXRbA7ShnLJZDeeDlpf/DokyaQpBqkr8rByY+qM374abhMQw58zjB/hiqxjmSHtgfOIM6hVhU4iVRbQeWNCQZ6/njlW0Cl85rfvuvY2z8cmMBszRgmO8iWIqeyNHSxzM3p7CCyvefpB1IF59EOp5kCOHarf8iBhGcMnPcoXUhUzsngeIf6lA+MQ6w5GwZpgZb6loHk5S5T7EuB+G3hx192AXKRnriQwNvIzqXdAAS8OZL0telfoQ07Zg7jlsNTBWjP9K6I69Esrz73+VTFZ8QztZk5ETSb12J4+vZxgG+XyDS6CZBzUW8ryZE963dIyW1Bj7YCFrIehyTTM5mcaEd81uIy2ipVWbt/K9wwJ5Hg1znRje+uRZjkrP+s99JcpDkXSCpIhI99LevqOhcFgvxtPP8fxKJQbWKGZ76Zw/Ag46lwBJC43mgBcL+U4AjKU+BXHNK5Yz6u8BQlzTdr9OkzVrT3SDI9/B++UUwYJ0y2SHVPV3Nn/wLlvPErXHu6ykb3nvptg8Rz+x2x7czT3omNxsqNJo0jpNSC7jq7o9lCKnrTMoHl0m6he+/scTJT/+zWuifgcwviVg9UgeLWR5Rtj7kunQiklT4/0VcoDjs25hpDi1jRqkE7aJz0cepFI1R941R23
 uVMFEWH7
 QOvKHJeaIC+sk2L5aCAp+/VubFz9sYkFdeT+pMxz46cqMiGbMrL8akKH+20U8G6WKWL9R8WcscecWkktpl2yFaoyXu3PkhMEoiqtAc4R0gRvwgnWWfOQkHnlUl9sNto9Bb/otqmqL31IFHEPzKF/QR65SpLzZ0+AE4oXSAkfJGYp0ulDeRxB044lb+f1tS3kAdDv/AqVcqoikmZ8U9AHidhJ1uSA/aoBYZP8ncoOgErT91TSrSt0rS124CwLn4lzLBdWchFau/7x+JLZ2rzrjh4veEkaL7JRXJ3XJaVzVXAXMXVEld+fF9l7jrX7hrvV+vqiNJVlJdAayULwCKI2nV6CvBVoIsIJdQwaMiVKr+zkF/9u7KQUuMaEeZlCPfTNRSA1v9SS/aY9Gs/fqQwg+H857ABc2WzuxKE3dUrqsQvGtEEmz0svHXdiDvC+3hI7Xbg9ETpDyQ8K/DQ+Q2GZyYlbYrtn9WJiLFA754ieHimN1RPobsVYx9lDwmeo7kpiyDMkImvdfMbU6W4sCf5NCPDKNlry6XgWLBE5Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 12:19:06PM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> With hugetlb_cma_only, the "reserved" value in the "Memory:" boot message
> can be wrong (small or underflowed).
> 
> When mem_init_print_info() calculates the reserved memory, it assumes that
> no CMA pages are managed yet. However, some CMA pages from hugetlb might
> already be managed at that point, so we end up subtracting them twice.
> 
> Fix it by only subtracting CMA pages that are not managed yet.
> 
> This has very low urgency, as it only affects a boot message.
> 
> Fixes: b1b7c045e808 ("mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: improve description and comment ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

