Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977C0CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882C26B008C; Thu,  1 Oct 2026 06:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833176B0092; Thu,  1 Oct 2026 06:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724596B0093; Thu,  1 Oct 2026 06:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4278E6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:34:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B35AF120384
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:34:40 +0000 (UTC)
X-FDA: 85273698720.03.8D0EBCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E340B20005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:34:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gA7+gvYM;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790850879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQaIQECuB+QV7CujPIoQXpEGrYXnLWBwF7qVAUDB8Sc=;
	b=Eg6PHfUtaO9+Ejb1RE3KwrkAsl5HgSxOg+rUWLrkxFg0G1FjpFsQiWpYEw7xv5P2l7hdDg
	LGOzByC+TgQ0H/O/ttQ2JyxijHc6xyDJn/vSrVSutPxX5BAI41OTGbnYZW4+uPxPa2LEZP
	oYY4WlxRTLtgHPBCLtCbJbnEPXHRXn0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790850879;
	b=uO+h88GI4EyMb86d4Maoc1dmnEt3A4+Q9uMI8fHF8f6GJJ+oiIvIy2ODC7JqpcTZBnyA4j
	9KW+w6w2N/Rt+wpzWNYDvozIO2lCOoB73JidMpyQPOk4QfdyQ5EwbcUOuGXWUy+o4zVGwC
	3uNrOLOK6xdcI9SfSJLxnTzH40qpFos=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gA7+gvYM;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2171A42AE4;
	Thu,  1 Oct 2026 10:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511F91F00899;
	Thu,  1 Oct 2026 10:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790850878;
	bh=gQaIQECuB+QV7CujPIoQXpEGrYXnLWBwF7qVAUDB8Sc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gA7+gvYMrSGKwkFCUCTrIFkvtraBkGuN8kUYVWNEXDC3NbKAmZYtIwGTwuO5Ih9xV
	 sIi05onQywdUtoorgbOZdpeXv7mCR7POTZ2UE4nIAS8tQgFpm289TJwPfwSP8mwVcQ
	 /2hsQvOPLkp5RzYIhr+VRyPoIMpLLImUmgW/Cb/2i+7h88+r4Q3OM7wrfsSd7vGpHG
	 nnPEqHlJqAf+Cfsbo16HRWafwnM0FUfBnbf4q+guZa8fPL0N/zfCaCzxXak2afAUgK
	 4v4Gfs/vlpIgZF3u2ubjVbOafSk5m5YgR1haai5UpIHJZ+UR/dRYa/brhmUceNrhIa
	 mbh2sVFruywtg==
Message-ID: <5e7ed934-ec0a-4383-aa85-ae384b07e752@kernel.org>
Date: Thu, 1 Oct 2026 12:34:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] mm: allow shared folios to be promoted to a fast
 tier
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, matthew.brost@intel.com, byungchul@sk.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, osalvador@suse.de, raghavendra.kt@amd.com,
 stable@vger.kernel.org
References: <20260930112206.205083-1-gourry@gourry.net>
 <20260930112206.205083-3-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260930112206.205083-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E340B20005
X-Stat-Signature: 3i4w93u76yxd9qoyuuqhdfhuegwa6kp9
X-HE-Tag: 1790850878-32769
X-HE-Meta: U2FsdGVkX19AbwUWUZm1OdpOmYQsXLqeVPl37tNWbwOLcYMBdxJ2Befazu1Nf/JLSNM+s4zwBPxpPhdwdFnu1n2io+G5UuWuACKDps7MLXLbl6HUVISUcVtpIWtY2iMgBnHFZLpa/ousatZN/OOzPaw4fBJd9s4Q28co8MGz5VWCK9oZy5nk/fDu1ukMKGKbidvKESB83voRMXoJJtLWGo3WtCpoGk4zjwXQeKZdX11hjNslHQeE9IOSxEI1FM7PnqFeyk9OLQ0C3jewAShz2RButZ5JQdbf+0HlXi7da0syWylbMWz5EC66tj/g4WuID8HCd/c3WVVY64Vg07iGv8qD+WyEjxbiJKPR2M6QaKTK06NwFZbAI0BZav0uZtNwn3h4WGuvU8pZSNz33ppN6M5lUY0/MmPuQqplJkHaA7fza0FLzuzfa3cImM4cDduIOYt7G8FN4pfYS2kBBF/DGDWT4z/isMluJc9Fn00+8qciArM/qcnVBeHPQ6iD39NNpZmEps5Bu3d3wF5TmNUs3KLVW2tsTT0PTbjvcxWthNvCLnHgZBGZn0NoPaDaWhabRNr5V6BBozHqKdlvqyD6DuFCjWOlrp/IhH6skymkWSpbJFWQO18nklSFibMIVOjQy21f2fDP7Ys4nG3RgZVpY+6H0qZMftc4pEqGvbZKX4Q7HnzPsKioZVdce/4qDwjDZMWweBXslmtOXOBd54/k7fZKfc2nldjpGJwCDWZ3Xtn/4o8MMjp9P2snbFqBwgv8MX5Lf124hHoNF9NonDqBE9FnW4EwYwK1cZdjUPtt95s++RnRbUsAPGPWhRzEGFyOsF5PBJuHYUm/yKQE573p7U8XpAlFErtvb4ZJp8BRR+L7A4VSHwAE29Zp2+PEJfQHcdT2J6nwK3HjVRZGOFaT00hP58v12cSXxSprJVELTHtNtDW/+g3Ov4mvlgNfoIblHURLdal4BNOJ0+6YvCO
 F8Py0wZG
 5Nfqj4WYdFiFgWyJ1MUn8CTLVIZgzHp4QaxWnAkTa2o90Z8pmDVJatVTNOxM8yxURG2+dX3ahpGBWkdCQPmn6E8urbFrb7OZiDpWpethgWXZelWTy+HwljCrTK05tE3JI2xQUDbtzuz6ND00lmeexxxZMatOBiTHM7kZEbUkHks/cqW9NwjFTSDai61LzPPIcCLBpB063R8Vli2n85YQjAt4hDfdF+fTsTb9l6N6UqhWmDlzEc2/u+yQg789O7PH0LGX4w4NFBdW3/pDaPTVJmjhBBJwy0LRpXrTEjA9I/rqKUsBQOVKJsyo9TorWvPu6egq7exmAj5wBK1B1FdTxLMtoTU+PQGTb5ekf/TyW3F/nnwB3GFmkzphrbQcA2M7d1MX+NKt/H+ssLgSqQnzlsmlVmL3sf540rSvF7xihnnLIfB6Y7hRRtP48BTvR+7i/OMli
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 13:22, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> NUMA balancing rejects shared copy-on-write folios and executable
> file folios mapped by multiple processes to avoid east-west
> migration bouncing. These checks break promotion from slow memory.
> 
> Allow such folios to participate when the folio being migrated is
> a low-tier folio and the destination is top-tier (south->north).
> This allows promotion, but prevents east-west or north->south
> migrations (north->south is handled by reclaim demotion).
> 
> Keep the existing restrictions for ordinary placement and for
> migrations that are not slow-to-top-tier promotions.
> 
> Rename folio_use_access_time() to folio_numab_promotable() so the name
> captures the combined memory-tiering and source-tier test. The helper
> retains its existing behavior.
> 
> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: stable@vger.kernel.org
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Link: https://lore.kernel.org/r/DLHS4KFPQ86I.1J4LN3352RI71@nvidia.com
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

