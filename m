Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC1FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 19:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFEE16B00A6; Mon,  6 Jul 2026 15:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF616B00A7; Mon,  6 Jul 2026 15:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6E26B00AA; Mon,  6 Jul 2026 15:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 739966B00A6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:36:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCF4BA01F0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:36:10 +0000 (UTC)
X-FDA: 84959357700.30.866522C
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id D380A140009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:36:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGlCqtSe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783366569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKOOB8091REAB20/dFjGniXL7whpPkyQEvMp5z3q8ug=;
	b=cM/DbgElQqTCGr/od8Qo1FL/45Ofr5d/2HVbq/3jijd6T9tIm4/jtKkjO6hBPBOCTVO1yH
	5nLWc5qrbTECjy9sPdLBD+fybx4khYuoRnuhi76xXeH9+RjC8uTBJxfAWznHvDcLapz3Wg
	DHPg1vZ/fcj33+D3GibQfvKwco2/dZ0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGlCqtSe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783366569;
	b=Lqu40uNwSsGJfq49k3xHkGhCWogHXY5ELAdT55yWHrS/nk23F5rZe0AHDsUrs37/00ZtuZ
	1YD6i6MnSXrCkH63r55MT+nF2yJ3QVbe2g8jaCJG4wcZbr1kuu7bKnGe+gkK5KhBCWhlJH
	ZwNLB/IJTDJU4lcwhmUDM/qNpkyEXm4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783366567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fKOOB8091REAB20/dFjGniXL7whpPkyQEvMp5z3q8ug=;
	b=qGlCqtSeE5ojWLjY+aTSybLJw0mxSITB3DJVnpmTfBQREA1VJLO6hMgd1zZH4szY5bDLUB
	KFeYELcFDIVt4og1yBQzL0nktIuf7HOLEvoG6OHFtqTgCipiqffKHgEkuDcKyy8D7UvTXQ
	1Ljn7pxC/4i4JdbPY/7AA3XhlxmSIX0=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 7/8] mm/khugepaged: clarify a comment regarding max_ptes_none check
Date: Mon,  6 Jul 2026 12:35:55 -0700
Message-ID: <20260706193556.876676-1-usama.arif@linux.dev>
In-Reply-To: <20260706154500.39178-8-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D380A140009
X-Stat-Signature: yhu4g36c3g7q5s8ok19i1zpf3tkpksga
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783366568-123292
X-HE-Meta: U2FsdGVkX1+Y5kOi868Hgw5gtGAjn1rZfdfmpOo+987htv93mQgRHCYjtMun5EQR00z1aP8d+b60w0VRcEm+CP0W8KX65RMUO3dJzSexzuZWpTram9dpbY9L8umlkyd5br1O8No4mqGCVx3h+vmvClZtyg9AHnsBbcMWkXukdzo0m2aLLLoVP6mqVBkF7Yq1V/rWn1EizqVTtVh2dLOEl1oZizqVD6aIYav73mR2YecGvcQnXPNnwdUf7PFkhu2tAV0c/wjhaWN40WK9TTaIf1pL6dnbkLpwlj2YC7J1naTCaJRBneVrFXwMAmDct5A8fVdq+VtxS+c9licKTIlirzQeB0kY6jd8sGCRg9tlr6lNkZ3UKdmmi1lYmyiQxUbEQn+q0tr41ivPcRUsrfiAOCDZADMbR4a5wbLLhXzJAgHUiPYfgqX/L+ElaSBGOh7diGZZ8R9xuxd7vHhRqb75AXc+hC/tEJYLWJ6nsOqL176hNzAIuo3oymPeUqBQ/Cs7pwTLvajTejEDiyVqqEtnyn9nWcgxkoXpXa/lImSRr7yGKcZLNVOT4wLoLtg7PUXu67ULvkei182ipnsJBXiTUFZpKX/HFhA1F9HXA1pqia1fm/fYfr6HMKIMbM7kXqz+ggMRP7upB6PVyGVqQ3fLQYcdCIzqdNFat49C7y0u2lmeq7Tyw63y3NTY6XuaGzMJddnMu4KbQm7nO9r4rYzoTm2efV3tS+5nPkk8zM5tFx6yiNQSx+78XD5mJ5nceY+qzAPSOxH6hneOfgbIVBsEBv5HOL+maweCYOBR5HCHaVR1GAVs6THKKhaOSFZ6KUCn8So5GnvcKIjb2a02MN3F3MNTbc6tbJwCSNYU5iUT4nd1dZVhZxdtfcnjxUzDewWmZ2ze99IfcVHemBczmfwHJI3AzZehqEJfL6DJwMgFEpr+Kd2Vh9PWRsDjw6rfOXkTAO7bxmAsUweaCH2w99j
 dO58PSl3
 RafmjqebrzFl6mI9R4gLKeihFsIGXXQrV41+oPi6EbBiJ4Sf+SmPBoKrCe50w4sT2lByZEKLHuocftu83On8n4zICLxWmYG/Oz6fuTatUflwj1IRsp2cYOy/3aiuPrzPVyv6MtNyTqc2Zstl+DPQhKrI/+sqp0q1A/7Q7ZlQrQRzkRlJt3zASj97+hPHooWkelBtTjOiKWItDbR3Mq3zmpIchcuTSTIkGE/oorzGQFZzDJaDkLvWyga1dUoISefvvPCCNbjEAA5mUw8q4fJJUH4f5u7a+5csN8c6JIquOwLU9/3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 09:44:54 -0600 Nico Pache <npache@redhat.com> wrote:

> While reading collapse_scan_pmd, one may be confused on where the deferred
> max_ptes_none check is done. Expand on this current comment by explaining
> which function the max_ptes_none check is now done.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 3c6f1254deca..388045a524a3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1728,7 +1728,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  
>  	/*
>  	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> -	 * scan all pages to populate the bitmap for mTHP collapse.
> +	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
> +	 * is then checked again in mthp_collapse() for each attempted order.

Could be combined with patch 4?

  	 */
>  	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
>  		ctx.max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
> -- 
> 2.54.0
> 
> 

