Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC81CC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC266B008A; Thu, 10 Sep 2026 09:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3AB6B008C; Thu, 10 Sep 2026 09:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC99F6B0095; Thu, 10 Sep 2026 09:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88A8D6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:50:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A68371C244C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:50:28 +0000 (UTC)
X-FDA: 85197987336.04.A9D6EEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1CEC618000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:50:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFQAUfDL;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789048227;
	b=TMvqAtXeOvus5R95p85hIdye11Mx4RUJi9H75dpwriV7QGw4AeEOt93CSU40CXyS8jrdVJ
	4rLO+Ny4kE59eJhg3ycbxf7p3KvFSTYA+jD7crw8P3VKZntqC+tz1vSMoYmhWIvNAnUuZW
	KAHX2eQhfMOQGIZxaVU5TJdWFUsq/AU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFQAUfDL;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789048227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Huo9AavKgYJyC3DyOPGYv+hq7OnKaq51C1pcQHDpq5g=;
	b=aZaGEppBTiUf9Zi12fDYETPyneaHXxNVO36G03/6dVU8uybGnz809o3WIxa/y7WdWT66bd
	xe6W2TltBPCLx0pkoY+Q/w8hp1Yc5IY54AAdtZ2LwrHhMA38oN+7VT2npZPqjXhdNXvCap
	we4wMJYqmGa9eBYs0IesgDCnj4jt1GY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70963600CB;
	Thu, 10 Sep 2026 13:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30A51F000FF;
	Thu, 10 Sep 2026 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789048226;
	bh=Huo9AavKgYJyC3DyOPGYv+hq7OnKaq51C1pcQHDpq5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EFQAUfDL152OTzyxXY1pgmtZj7CbgwEMnNX/gqqxzgzLdXEVOxmenctBi0IwLcnqW
	 dCBbbAMIgVwl8kmKBXwnsnDlV2hB8j4ttJ0g6Qtji1BL8YryHQeypajmRJd9xppbKn
	 QFChUqMFxP/VZgqX+jPrIPN8SJrlngJSLgW5U8fBZKNy4yRjd31fRhcAi7jDTc1ejc
	 nCf59edQlTsjNUlQez2McBcAepMIS/bokIJsA844y2K7Xvy/ssNrJpP+6TrXvqv3FL
	 7mkfUO1Uy8ohog5YCziweZ4RU3Vta/vJbUHr2Zs7OnImdA2vkhSUiwqu9ygkBQNdYZ
	 uf9Xz1DQ0QNcw==
Date: Thu, 10 Sep 2026 14:50:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/12] mm/sparse: remove pfn_in_present_section()
Message-ID: <aqK1g2AuXCFjAq7p@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-7-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-7-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1CEC618000A
X-Stat-Signature: pdt753cid981dunb6ydnk46qnkrfapkk
X-Rspam-User: 
X-HE-Tag: 1789048226-553614
X-HE-Meta: U2FsdGVkX1/wWYSHQV7HM9RhNs2gS4eWvtWgmcDDS9IFIA8VqtFQ0m8Z02fKfcnIVpu47Jjfs6lp6l2gU9ncQm8MrtaOLhXUVjxiVlHFhxC4l/Y1sDelCTYcMG/3yUC8Avm1raihRUF9vgy7S94hXsnN4Nh90xwngGnJYYbqHfV+CVCNdr4mh5+E/HDOB3zvJeFL9zBT3xh6osRfsWNvXn01iezaPsnSnhHukkCy73KrwyEgpiCspChWHzPPKaDKLSWEd5sOx5SfCNQ+8sL3YIo0gpeMca919ljKWGvuVFN/vOBCOckvfELif237nC/U9pY+gy2FEvMorkwaHb3xu35zUHOW4fwXYOQBb31VDXyLX9Qmve6GyYxpD2/+tCmwxVM77AUl7tkVXTMJZlg7VEqfIJALbph+jZV4DTendNgynRmmZa4tx4IslCeReg91VsYcpcyNLe1STWBiQZHqJhoAfonB5J2eHgPDVhRHPEyWjAYBrPdTwbpgnuORF5HYOCFoqEsan4Fz/1L/L5jt7LPMN4ILI/UNeTq3PnWogGnc/DokrwWkp9+M+mNZl/RVTEhst9ZhtStl4bpUbZVh0ZpXlF+6O+DuE+/IjPfDe5gLdtTdTalNxm83F3QXSN924dco+twFIiuVnrdQIxC4oWzK1AS+Vg5VDc7KuFDJW/S1BXhrF5MyLWtZT2b7tj81mXM2tCSqmxnNoQPN5ePvuA7Na7NPNzSsyISdJqsKveXJ3hPCJGXmNU3/2y/Egzq7YnEFH5u+lI4YHbFv842D6NCd2+hmVPQJPuUPT60k0M6l2vCMakwdYkvBGCbqskkLZKRRpA7aQfzDGtfAqL3A/cpYyghAc9mcGXxhrgAa1GuVFtp4koy6agpEFaFNz11wuUHdlrxT05ayB8Tkxa33EmjNFdw1O9HoJcscBBupGCYpFeHY58uenmtv1S2nE6/UqIDKc41GHDvxkf6JXHl
 1B/3SHDP
 ra+gLIGQFsekV7KOwvuDJKhNPp3fl9BKup586aaZnpn2RolNzPYmvY9AHyypYHnzmp9wBY0RhK6W/W+Pn/s38p4acC2tgVSlrEZl5wlcP2BU21bVv2DGZ4E/8NHwrYF+JD6XBRTf3TSNYI16upW48//0cVDG+4izeRG+ik6eOJY6mUJ7jt87KzqXYFO3pN3yC4EcRXzF2WhOadCqs0HXlkb+zBDv9TK6Q+TS3gWFy8EcaqyLWImX1yOWBunsOAkAVwRxsNSfakgf7SnK6YYpTtmtwtPpz2l1jJXAfLjxWMrXAWKQidf5mnGSePWb0VLJ2eDfFqZSNmZs8B3EQJOZdDvXrZL4gEMU3/VhKWPN+HH+aYF49MW1q/KPgBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:00PM +0200, David Hildenbrand (Arm) wrote:
> Unused, let's remove it.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mmzone.h | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 19296e8ef44f8..e0fac344f6ac2 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2315,13 +2315,6 @@ static inline unsigned long next_valid_pfn(unsigned long pfn, unsigned long end_
>
>  #endif
>
> -static inline int pfn_in_present_section(unsigned long pfn)
> -{
> -	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
> -		return 0;
> -	return present_section(__pfn_to_section(pfn));
> -}
> -
>  static inline unsigned long next_present_section_nr(unsigned long section_nr)
>  {
>  	while (++section_nr <= __highest_used_section_nr) {
> @@ -2351,9 +2344,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
>  #else
>  #define pfn_to_nid(pfn)		(0)
>  #endif
> -
> -#else
> -#define pfn_in_present_section pfn_valid
>  #endif /* CONFIG_SPARSEMEM */
>
>  /*
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

