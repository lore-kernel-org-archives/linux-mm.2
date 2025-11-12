Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63488CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 08:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A27E8E0010; Wed, 12 Nov 2025 03:05:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A388E0002; Wed, 12 Nov 2025 03:05:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6EC8E0010; Wed, 12 Nov 2025 03:05:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B60F8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:05:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19D43C03C3
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:05:14 +0000 (UTC)
X-FDA: 84101219748.27.6ECDAE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70DBDC0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:05:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KdQrzR3v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762934712; a=rsa-sha256;
	cv=none;
	b=rA8KxIpxsiH6UG4X8Rg9jjV3EGZkMTB+xpdLD5CtgF700cC8Yv77q4PdiWDzT/ezZaLKcx
	y9JUHB4V6Z+nVXptSPIg9ltQhDynu4piY49cpzPkrjb+Y/tN3xea2bqzHFiuftKgwcKt6v
	q7pgia0qh0iDcX82dUYNwlZdRviqlzk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KdQrzR3v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762934712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MChMsVRMhTqLtxBayOzGIJ9MDFtz/KXKsIAkJYDOHuk=;
	b=JvxevnG7tHBPjN39+Ct2H9nPA8gpydX1ogo1YywqK8qXRYn30WuUQdrqcYpt8VUIVmGPI3
	N6RXrUZJSi29/0ssnUuklChwRL6abNeKSk+q4tv3JHm5jzttOwP3XnBRKaky/gU44Aeo7h
	21VNvFAA3i1y8h2OLrZ5Vo5spXr6faM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF08060225;
	Wed, 12 Nov 2025 08:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89486C16AAE;
	Wed, 12 Nov 2025 08:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762934711;
	bh=SA7i33ysWzPDlrhtd68Z/egkmmkPzs0rHOKGyx4PbTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KdQrzR3vf+z1dXt8moVE4lWL0xR6YvwRPceeAI609o8bZcg0tfarInopUZdeROePM
	 MzbHN7CuSrgHjf2d6E3N34UssO7AdaZLpXc8x8qV6la0CuoHkV7BzW0wYqy9vWsEnN
	 zqrejZxeQWsmg03EZUrEmhytog3MWalbPNdPhzfB1sCQxBENXv1srgxqZQCWyq+gGd
	 r/pL0Dvss93HZcQ0j/doy+dMk09NmRk76+wCr1wofTRm5EPDthGgzViu61q2QtSpms
	 cbCmjww2cTrehhj0y7cvy1PYaAD88KbMJc1mMg61gXLcdtgzfpTs9XXtytuFksal/V
	 U26qPyjAo2dzQ==
Message-ID: <7b78c1d8-9efc-4570-8f4c-244af665a159@kernel.org>
Date: Wed, 12 Nov 2025 09:05:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix handling of zero page in follow_page_pte()
To: peng8420.li@gmail.com, linux-mm@kvack.org, akpm@linux-foundation.org
Cc: osalvador@suse.de, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com
References: <20251112072424.125514-1-peng8420.li@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251112072424.125514-1-peng8420.li@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70DBDC0011
X-Stat-Signature: utme7tm81syeej768jetcoancdx7zocx
X-HE-Tag: 1762934712-44227
X-HE-Meta: U2FsdGVkX19pVD32hv3olWuQQZKCmQMRJm4DT0MpmZHVO4Xgb0UEpURFEn1VY5tddvG9I5GAyyHMEssGwB/Iypwd/OHM4pWCDyenM1ronwpbdb/v8eTvznvwW+2ShJArPia3nIb6EP3rzD0/WTbYKgoJMtHpeebnanjAN5W2HU7nPNM4KAeMT7cwuoYh4w3Dtg3+RRjU/aGP9QBvrW2iyrKRL31nKxN6q6ZWy9xh4Zzpe5JO7J0Cp3NeCnB70Hli5UqH47wKXsuXnq9FR1FSotpKMFzP8JdRWvUEvggjTIfgrHVCgTKwfNIVmI4MwoWkVRGuFdJDRINQ7K20chbxvkpNnjdaUC503TBv7aLvTwhpXMyHZX3Fa0YHcbenasyDrACLqEj8r40YapvxAbmEXInGJRLvEies9qVm0Dvnq9GOI29QAG0Txs0m1MpF9JnPuNX7vHuYlkWBmPrJ5MzZGurmf3nRXhv3bPE83xuTG3SzD/SCvcWEawUtU+sJFLLuVtavpLNHXrFNQTx7v77AqBSn9UlDUsZAc4wMdkK6C6lWulFDmE7GP1/ZWx9c81LTsAXCP3eaQUQXEWE0uCH3H6DvN/yNVyGBAT7ganY5BBqEwtSShROzbsFByCYh1p1n1CQMn82jP8W5DiZ/P3VrWYUv9W7TERuGbkyXXbyJH1Q0lQzsVyiNEInSKE3AyQoSOMyA0ljWbujnRPuuFeZbC0IlVirvILhAcfCkVP5sECGdoE9gmfYUg4Nz9EZ61Gep6D0B1jwqE4M542RKMU2qDNOYvE3OIoAND1z4dZMy3zb6l91EEKFg3kuncW8pVgAm/Vveg3R5k52hX0dRSuiwW4CDI8toZhfvDowQGAm9dB/apzRgzk3KEVsKYI6uBbfjRgk3YE2ZfOWmRZsTypTmSzhUwr2lfwtZaxaFaahIROQSkCC/F13La7f2HWQLYnNRGR8+KFaHnRpMu307NAw
 BusnNE2U
 ObRCe2Tq4CcaZA+moK6PSxOgYWhgNEECqmbBwZ4zXIjLeyd5fPejXr2qY0L1mZPVbrK9z2ej1Gjuy0sQqRzsRaBbC0yYjpQjEvcjsoAaWauR60MIHfGZKDfpqLyeGWmIFjp0D3yRyOBFFkAwh1UewUstYVtMigfAHI86rkYU6V2tKGPpT7YUCljI3r+WX59ln0ryWtx14bSE20XHXPhSqEehX9lnq2uVGsN2J9g4xogOq7ss65dZXrtvD01woA8Qcw/iwx9U8hdvos2uolQZ6QTwBMEF5ZKrPlkt5aQVonupCQoGbYJB/hFaBZ9n9D35NKGpEvuk5MoWOK9b6ymKbHpozhYhuYTPAgs1VYRsw56nArkDuj3elS1VEo9gXAW/+e5jBISpgANhZ6LE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 08:24, peng8420.li@gmail.com wrote:
> From: "peng8420.li" <peng8420.li@gmail.com>
> 
> In some scenarios, `__vm_normal_page` might return NULL.
> In this case, if `is_zero_pfn(pte_pfn(pte))` is true, simply return `page = pte_page(pte)`;
> no further folio processing is needed.
> 
> Signed-off-by: peng8420.li <peng8420.li@gmail.com>
> ---
>   mm/gup.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 95d948c8e86c..60ae5f0c20e0 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -838,6 +838,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>   
>   		if (is_zero_pfn(pte_pfn(pte))) {
>   			page = pte_page(pte);
> +			goto out;
>   		} else {
>   			ret = follow_pfn_pte(vma, address, ptep, flags);
>   			page = ERR_PTR(ret);

I'm sorry, but that's just wrong. Observe how me might run into the 
gup_must_unshare() branch and how try_grab_folio() would grab references 
on the FOLL_GET path.

-- 
Cheers

David

