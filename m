Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987AFCD6E64
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5426B0095; Tue,  2 Jun 2026 11:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BC7F6B0096; Tue,  2 Jun 2026 11:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C896B0098; Tue,  2 Jun 2026 11:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E75DB6B0095
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:41:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91DA51409DA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:41:53 +0000 (UTC)
X-FDA: 84835388106.15.72D5C3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id CB7CD1C0010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:41:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dq/fgWqG";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780414911;
	b=0AUK+MyQ+n4eJwqpiGlO95OgX5O/Kfdyh3275lN+1mhHYCLz/eFyLM0v81Z8rL3qOaR+9W
	5KPpHw/Yeo/TUHDB05wz0fRBICmBd9/Hkt4vgTOtmUGFz8dNi3r59QdKUsYa0mhg50Exv3
	WhEIUBHcuisJ6NNTCOW6k6c2qn4bNyI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dq/fgWqG";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780414911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQZZGZ6EMTnUv6b/A0cJocwVFTUpYX1eLweF/8Sul1Y=;
	b=62NXjgOUyGSXr+GtDOMDoshxoM5+HEW0RsoX+ZJBnyLUB98SA0WZ5ZwOYepmG1cwooNusw
	vVE2pVxjYGtMzi6ZQ4ZgugskOR+OLc5IYUdT6FPyo3MCyYQ1WnRqexIzW62Uc1y9LOnGV2
	Gw0NBLfwJNqXPGCxIBHuXEs8rCSKjvg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02FED40627;
	Tue,  2 Jun 2026 15:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD131F00899;
	Tue,  2 Jun 2026 15:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414910;
	bh=zQZZGZ6EMTnUv6b/A0cJocwVFTUpYX1eLweF/8Sul1Y=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Dq/fgWqGarmZFFHRBdUyYH3SxTuACE5PWIOGXebWLtT+Jz3aNaHvvhPQNEzTtnZJv
	 YrZsqEb75xpMlIzGphpk7jNqD4E9qqNpKg1Z3UmvtmoG03S2x0sU6Iz5XoSYHb+LLS
	 eJf4R7DRfm1x5KdKR9k7pR+nuGxrAcNh17oF29hvI1BTUyL3TDXk3neZ+W39hxQcMy
	 ZtKdKMaxoKjJsiWyVhCuvc+A3zLMciVDFXKQ5ZUAip9ohOeIRSyQRqIAHpaKhkRnDU
	 BgMmV5JJ5eWXsRdDQrMe+lkcjxzMNP/G3U/1sV9IVcJvnP/vmp7GEpoNyxqmBN71B8
	 LcV0HPDXsFjHw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 16/19] mm/hugetlb: Remove obsolete bootmem
 cross-zone checks
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 linuxppc-dev@lists.ozlabs.org, Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <20260602101039.1867613-17-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-17-songmuchun@bytedance.com>
Date: Tue, 02 Jun 2026 18:41:33 +0300
Message-Id: <178041489398.457517.8355446246116786091.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: CB7CD1C0010
X-Stat-Signature: ia4zaue5j6oyw9ekwg6hck6wxbjxhmr6
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780414911-521680
X-HE-Meta: U2FsdGVkX1/38fXhuOSDRbcDIRfqxIK6SZUfbah7AbnvrJMFd+ggHiNe/ANPkMHLsPTrM4wWSSjh0AfvBm6Mplly5qZRkvhJ8bt6UUQpTRTTSX1HrmOzNl6SreRCbICgEkRDrmkYMnnBhALn9INAhpIW65+VKZJRqv98YwS/ljpzG+rLaSUS0+q2+r90YYhVhL6v1A2Fl2NrmLiledsVcXPD382DnE0Vdz6tYmaorJ9wCXC+kXsOLwqDR3LSpSnxeIy68UOS/iEacXmCfNgKbKnL+YLp78kCIqV8Zmr57UzHNtM5GadZkyXN62EtYouqcxxTx9RXmKWNNwP2ykj/lyzUpvJWGj4obnz4ZIeeAjDQXsjQF/c4XOKhGIV9l5TYMhEvW4PTVpenI01Z2eERAHCyNbFXo4kmzQsMPZRDWwSYWaXsHEXGfwwrMfd0M95fqzHA19SSjmAXfUBPiHCTDcmb28QXIvf+YCanDwZH4ip8zCRDx47dRuOytt3knSWM30qLZk/Xyuo93PFXWM5rG89czaaHwY5fPdYc2avAkqAUYwCfyjoknWoTxSBbTvFcv2i3q86+vlL/BioWZ2nKq0ErFU+pd0VP6l4dFPI0so0aZHABaTz29ukRWJbniM22eZUILV0cBUOkRfHHyOeb33JtnGIoD2Pfy2wctWzVAX8f9EkhPviFyIVlAKmI9EmWr8Gx7KueZ3bBksY/Dmz6bViZdC1VSUjcpZ54SAYbH2Zzh8DWF79vJUi31lromf+kBTj3RVjCQKHeTuCieJdGQEoc2K7+k55KGrO1jqlKXuWs/uOfoYmhr4emiJdkE8ENXzsnQLjy3jLW/BnjHW+aXgAEXBmDJcrTj6UXpBmiUFCfSDx2ncWvdiLQKPgtIMFkHZVJOwipbbCkKww+gU5k17U8t+dCOiR+UWzAK39LgoYGb4SI3J10zRCXtxVfh/fDnGn3vjsUpuvX6aowmLJ
 q+uiDCl6
 1doy5Gul8ACA8P9Fd99Dq0dQfhzBSQkrt4X5POcMcVlqlnny4rLNYZ+d3A0ZaU8EAabCCxslwwBDgDh3AjBhEy/+TP+pflq2LtrbUtnooP7YLaZhk0zFaB10S2KP9u/LiA8sEsGrmTdBvgbru9sGKHnnRGuNxVVpN0yCKX3/rF8rea+tmmd9BmrnUFKVQ5+FngyqSx84hpk0Nl4FWbNqcfxtSJzijZoflzi8PzFZqKhvAEPhPBpO7W4bUAUecNkEQCGQP4SvkE6LiL9Pp88s8akdC0+KO+m/k6s54b47wyRRTmiFZXubrwj4uxQhrqkUBx36Qe1fgpG7x2pvhMylgoeN5Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Jun 2026 18:10:36 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Bootmem gigantic HugeTLB pages used to be validated again during
> gather_bootmem_prealloc_node() and any cross-zone pages were discarded
> there.
> 
> That validation is no longer needed. Cross-zone bootmem gigantic pages
> are now detected during allocation and freed before they reach the later
> bootmem gathering path, so the remaining pages are already zone-valid.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


