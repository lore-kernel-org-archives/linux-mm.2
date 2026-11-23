Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B6F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0P4iUV2
Received: by kanga.kvack.org (Postfix)
	id 52C4D6B05B4; Mon, 23 Nov 2026 12:59:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCED6B05B5; Mon, 23 Nov 2026 12:59:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2716B05B6; Mon, 23 Nov 2026 12:59:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB2A6B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:59:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A997014098A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:59:46 +0000 (UTC)
X-FDA: 85467146772.12.11C80F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1017E20002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:59:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0P4iUV2;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795456785;
	b=qHXRFi5lSNpl7D7ExWI8pkPkIhMyZJt1N28r0zKqrnP09Xdug82YnPo57MckMJ0DOx5UiT
	NjV1259ZaKUMyLHVJKbxtFPNxjT4rb6ZDXJxZb3U55YVoajd/DUFLwqvLo+T/nJsWJKCJZ
	88aFCsdnbgrV4HX3EEfJL5NshV9ORwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795456785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYC4kQeWnDYEEHA5m6wU43gM4zAFcuWO0KSFuKwmcMI=;
	b=s4i/KmNisTO0psZ1JpLt7eDQOe3pj3X/xhCxv8CS7nmrkqINQdaa17X5Vk/WRg18zqcDTm
	KxGFgOKbFf9DWXE3fMArjZcXbyg1H34aaHEnhmgA53C08gy/FmT17zZ4qYKafz3nPC8XcR
	zhiFLxs/g8Bt0NcMtTfyKX5LprK1dWg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0P4iUV2;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82C0A60DA3;
	Mon, 23 Nov 2026 17:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1192A1F000C4;
	Mon, 23 Nov 2026 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795456783;
	bh=CYC4kQeWnDYEEHA5m6wU43gM4zAFcuWO0KSFuKwmcMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m0P4iUV2f/iMGx/rU3x97aXqDW9z7wFhU5dS5rMNGuONFDedAnYHdA0M2ol6ZHE4A
	 kE+C0DNQVP+7VXwrRYVPvUjGGHSV0i4SjydTU9zPb2DHaTiHX3ljXwUEUD+G7csqFy
	 Po+aEBz7VPPKVxIo9/t0Z6VLb5OPPFFWZ3DLiB13gbcJeiqs+Zyuef6mdOTmiA330G
	 6nnJfvoI/1/m0JSlv4cCU6fakNUN9+sNa9WbFmBTb3UcbBtK5yWRxcBS/oUAvRx4P9
	 eTs2Df8AXlWk95w5p7UNYlTBCl/GApl/I1uwYq6nSdRMG6vRbLWiT9gSyYk2HaxMRB
	 YcW6mKQ5HCwqg==
Date: Mon, 23 Nov 2026 17:59:37 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, david@kernel.org, akpm@linux-foundation.org, 
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, Baoquan He <hebaoquan@kylinos.cn>, 
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <awR-0mcGnK-lM9EP@gremlin>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
 <20261123085800.981256-4-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123085800.981256-4-baoquan.he@linux.dev>
X-Stat-Signature: mwboe1dipm3q53fnzjnp1q3ao6tnkbr4
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1017E20002
X-HE-Tag: 1795456784-755385
X-HE-Meta: U2FsdGVkX1/RvpkXbgylcz6Ly5OO545LzPFkiV2NLA9ulxUwjRW2692GkUXF0jjvSUXUNUpW8GB0JFE3d//ms1X3r62JdNkMPed5fUIzN8kdxxtPH0n+sCk1FpO6Pc7ng6tAO92crEcopDECNyLEClxXp0tQbDcG+oAXZtbfNVElIfQ+2z4SDypR0Lfjc75WEiHL33kRbnPISzEZcC72KwatRP5B4V3h0EOcAZJXuMsbzeDpiGnL6qqYpHfU7FGy08MwFiYATHX+E6PWeoL6HKwz9KK+oc+g6fsbp/+s9aVjHf2GsvTd0rbFqj3OJEmd6f4FqYFz6SIE0JTOr7h8O9XtTNeaYzPnITh2G1BpJoshO+7vhoU4hyfrI7vGLBoAzqIqTLiJ22QU1QUn64Pje9JuW/qVf46SolE331VlegmC7/XKHzPa61IC9sY4kNnmqMWCbyqgmmFfFj6Eaqkm7skHSK8fLGozXj5FsQFlcqLQatARreYg+9+V1trMcZL5vkpcNXpiGdSXJgJ4VMcYD1FdTCmfceLnOjJwpQHjuOPgxH19m9Kp13TlCDE2y6gU45racKVFivfa7xtTYX8IMjSsyp9IiuXuYEUJTts8lIP6lYT5xCxIuvBUCroB3s+K/aRADA/ydKcF40GNxMSg6Iwh2veIpPs2vgVo4dVudXRWI50b7j9SZYe8lAh1Y5coS6E90FXNE5x2UzYCE83WwOanv+Zj130T5p3e897z16yOIjPQXdi4B8flLUm/lglUPTcBRFchVffARh4dZ1ULyLG/mJrJ1+eFJzFwyOo9drNDFdO5NrO7n+8vcOJTIRHV6dh/A7jwuNb3YVHK3DSGTO/8hvs4BOHG/9z+ZmDExxNB5uySiI9ai8oPUckV28SqABmQaJjhKDpJDI2+SjNlvyHVxYpXt2irKPUG5BcWd5zUoASv3+q+rRVTRB1tR3rP2kGk3C+hTVVXsGn9dvD
 Uhs4//65
 8AXXDTPXH3yM+5lgEgOeG3P+IGH0lR4urjw+N6repKt3TxqehQQnJAntlXuTw8JEn1vA5zJktwGKCUIsLPG9WcLSotVjOwmsqETOBLU37sEMWCslAh7IeuOCQGsGAcL0SD1L5jcCmQVsOnbfTU4TMfEPkYFSzeZR7rFq6UwtPEq7wGWvPz9J3/+xih83GVts6xAIEPFsvhe1Y3TyQhBp93N+3HfSVwsHZWcZhmZJzeJ3c85uGIqDP66oDhgUlQXQewtx9ItioGmCITDzO5U43LivkxBf9m2eMufmkJjR8cA5ymkfag1XotBD4SrCY6VdjrLa2rPTjRxJ08jkpgMAQVMivHnPdxgnyJIWKpV2QOw1fdB7OdN1jIy7oT0F+7GDuEoBZXcnxNgXxWXqCHMBpHU9/VIkgyJHxENWp/0+x+ADEkZCsNJBvbDmnzsidYfXAnAIPoKO2UYWS2TgsObeOzVYr3+iVRWoT/x52
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 04:57:59PM +0800, Baoquan He wrote:
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 65646ed6fc45..ea5ada45c09f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1004,8 +1004,11 @@ static bool folio_referenced_one(struct folio *folio,
>  				referenced++;
>  		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>  			if (pmdp_clear_flush_young_notify(vma, address,
> -						pvmw.pmd))
> +						pvmw.pmd)) {
>  				referenced++;
> +				if (lru_gen_enabled() && !lru_gen_switching())

Could this be abstracted a little bette? This looks to be embedding an expression
specific to lrugen in rmap?

> +					lru_gen_mark_pud(vma->vm_mm, folio, address);

--
Cheers, Lorenzo

