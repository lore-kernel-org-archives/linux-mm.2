Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3485EE8B397
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 03:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD066B0093; Tue,  3 Feb 2026 22:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976966B0095; Tue,  3 Feb 2026 22:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3186B0096; Tue,  3 Feb 2026 22:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78CAD6B0093
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 22:41:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E7F61B23C5
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:41:18 +0000 (UTC)
X-FDA: 84405373836.15.07BBF45
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf10.hostedemail.com (Postfix) with ESMTP id 648D6C0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:41:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UoKDcIES;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770176476; a=rsa-sha256;
	cv=none;
	b=FRCU4Ajuiuaa1qTDbl/PPHIMlZ2ne9hMA4mghfLXMLqW3Os7OcxnoXwrQRUNycHP3L8PrX
	cc9LjjvuJ1IO6ajR6JDd8HbR4fHox0qzcCIfV4bA0hT2Drz2W18opbD/Fj/XPl6gdDMxML
	a0ekyDVkgIq/C7j2oR8KaxRMZRLs7yU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UoKDcIES;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770176476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=av/LVp9xwxJIyR+sVr9rZtKTvZHoc1HeKyc5uhYMiWw=;
	b=uXAn1lCZ5WWearmA7qQvUIth4fhPerUfrjgT2MXGK4MMxJugiFJryKmY+zhA2S6JJ3c7dO
	s8GeLz9k8vwJyRZ0gv2tACpIm+b+gZdobOdQYv9XB4EWBqKot8DF/EM8t3jCtqqQZS+q4I
	pRYe8w53xIvWuwnAWZb/bgKSV6vwKbU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770176474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=av/LVp9xwxJIyR+sVr9rZtKTvZHoc1HeKyc5uhYMiWw=;
	b=UoKDcIES+RABsrqsGspcjNyTH5E2HcfcoO9yvsRp3kXe/z+lkRBZiIyycQqxp54gkgqSqN
	JT5I86dCMF/pZPS6L/3HiIK91K/EaNVcawSSNzTl0YCPF3pUDQSGylLkB3JpjmeFJR+e3p
	bgF0Ie6YyD+qiWXrQ4h+pFLRhlWrMmU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260202155634.650837-9-kas@kernel.org>
Date: Wed, 4 Feb 2026 11:40:35 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <92298523-BC8E-459A-B99D-3C91D57982D0@linux.dev>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 648D6C0004
X-Stat-Signature: 1a3forzgy97zozazxa43n6qdffkmswwm
X-HE-Tag: 1770176476-306053
X-HE-Meta: U2FsdGVkX19wwMgEH4JbR1Q8qKfJtsiZ/LEchDdXHPrCF+Xr61O3B24lTtWVn0qp2LKeHeUl3Z/NsdKFQigvz2QfOfOZpsPtlm9d1EPtrQloYndZ5+X+zFWsupeBFcFJe1bL77hgg6FAa5Z+lEVOVzmVDTiuHYdqWe/Ivan4DV6PZo28JtFcEnl6NYhqH21urAfQYjZuz/lTHvz1X5WRHsitBAZKOSt6+Catvdw1yiri7U6nsZ48wRd/QzJkIr4UN/6wMc5CoriNiGOskbrfMi2UMYIHUMgp4cX5eME06eW2JrUeTXgEKmL19zMdnnzxhKSqZkryTyt19MnoUrE+OS3xgMq4UcPSNHx9UMe/hwQ9vLByJhJwBcDwR8lwdIQU8nBRx84GskNbbeDPAQR8GmxRaK9liloZ+G2J2+KMk3Ux+kwViojsCounCGB6GbzUhGr83VPXcRzSuujme5gDlXYJsTuqSK5qRBX6stlSCvmXo+mpBEbLWu42LlgxqZKnJOWdzjlNegadqR7XIK6XGq54xGPw/ky+q8AjCqrl5HWiVpQnfKiul0tyi7lAOAtZZu5s88btFPXWb7qA9gMON7SSeLVFJyj6JZfH889hUUlAHupYaueAxChN9Oo2AhnO7avxF1HId+Rh6FCLKCdr+g5k2hYb4b7ARNetvmnPBbMohlxF+FzHnVmab8jlgXCg4SskrkenlbcFL1hoAXp5QeCUlEaYMPCV4GaLKhp8rtrLpnJW/H9tZHRSoaG44hs9GbtiGuiwwEQp7KRYw7o/rQE+rUws4G+JnOV7leCz1BYdPIQ7FACjz0X6kQUfqM5Uu/OcGGmskz23YIH7traxqpcFK8BCNG5d5rusTYAJ4H8BNulqRwojqipOdc+QaskhHoLmo7hk2fjl8yAp7o0MnqOc5Nmtlf7LRdfbEKkn3y2acUZlILKfqaaZLfvPy2xV/n9oiL8mh87GlGtwTk0
 Yb4AtKGs
 gZkEyY4y0hBECWT/g0xshlv9qgmM+yALs+Bhrk1x3Yc3m+nOKCB6klVhewIBF5N7Oi2bAJVp1mG1/9pzc43Ja0Efj+oRcgSJruwkblJBMFtCJvpxU0e4n+qjBjua0OZPLztwmaEkAi+6IVuUWD6cD1XO250/HNwDt+RHbtop9LlbKNnVN+3BQnrKlWlfhWzZrrU04BpFLzMx91yVbXYeVuY5IjlOoWGgGrwxtcadDYJ6ipJIiIlYqVJ05A2q/k7RHFPUUxPoFCTDKRJKAGKFNFqKiRilRLgo0w8ilxMWEPKadiwgFLb8Vkdq5gaS8ybFiT0ghkc9YIzqBw3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 2, 2026, at 23:56, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> With the upcoming changes to HVO, a single page of tail struct pages
> will be shared across all huge pages of the same order on a node. Since
> huge pages on the same node may belong to different zones, the zone
> information stored in shared tail page flags would be incorrect.
> 
> Always fetch zone information from the head page, which has unique and
> correct zone flags for each compound page.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>

Acked-by: Muchun Song <muchun.song@linux.dev>


