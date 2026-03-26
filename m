Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F6ED106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4746B0005; Thu, 26 Mar 2026 05:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555936B0088; Thu, 26 Mar 2026 05:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B486B0089; Thu, 26 Mar 2026 05:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 345856B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:16:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E494F1604F9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:16:52 +0000 (UTC)
X-FDA: 84587659464.19.D172DFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3186B10000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:16:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iLRmbczE;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774516611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evBO9OzWYgl8t0xmfGDdtDh1NFjSkMWXPDLMli3cwN4=;
	b=voTOjKpZnw0HYyMwEhrbYkS6yfNuuTcCHmKd+cY3lLaItzV74N//z/QMFSHZGvyCPB8Pix
	Vfns+flFTCnzvqPSG7vye3h29S4B1RYY4PmRSJZpiPpyG1mgbAhufCyqeXUwgNAByK61a/
	ekNTkh8Zz9RDIRZCSmWFPR67ci7mI/k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774516611; a=rsa-sha256;
	cv=none;
	b=NZ86+DuObFgnCOb0hA7yFxamSVVceWGU5KzGoIW8YyrTUVeh0hOqcvQC6Ri+yPeR3ofQB6
	7DoaWHSGc+Dzksv+WCNPY2+iwRxySat66BFDTYilQYnl/be9hsmjgyeNrxHLiLPGgka2iY
	jLLEoLrXLu355eLkolyYE026ZQ4QLZM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iLRmbczE;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2124E41B5B;
	Thu, 26 Mar 2026 09:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020AEC116C6;
	Thu, 26 Mar 2026 09:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774516610;
	bh=Ku76ii2QKchQGfJBeF725l3BRUbVjcFPuQ0rkEtPhHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iLRmbczEYUSNzKMgqjO4/Syj9peJH4QHwMp8UpOz38C2PVCC6XlbD7LdwgrdJu/BP
	 wY54YEyTrEg209MA8DRDOxQnxTj003n6nsEjclfasxeiV46VH8ZC4Br+rRbZnM1ejE
	 0faqREUGITG80AyRbMq/Jr180uEfRbVeuqSqbyTwFZaXoEEmzgjrgptB1jvwS3HYNG
	 cO8QjL2qc7x2nEKEDY5poS+G0qlpRArr9ELUn9QZ25J2JGU99Dbkawgc/4w9pI2Jpy
	 EosItldIR8MURwxui58vw6hHlsxPKw0OzXsj7EILKKDo+4krLtBodeBaG86X60BTls
	 kQpLPXTSHnZBw==
Date: Thu, 26 Mar 2026 09:16:41 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: Re: [PATCH v2 4/4] mm: memcontrol: fix unexpected massive positive
 number in memcg_state_val_in_pages()
Message-ID: <54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: 3186B10000F
X-Stat-Signature: wy3jubxi9ikw346opis3krjx5ntdkr3q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774516610-966819
X-HE-Meta: U2FsdGVkX19oWLGQ0ubjUZZ48Lbwy9FmdWvzJjkrtFrHcGq/OF3R2edJusDw/enTCRwzjPv9mLbGc0IbkqFoIpnpVLMTtt6maSmJAs4JHBJ5iYxbCIRcUOLA6R15FSabnv9PyPGWfkTiIp5ER8StSQWdSvMcvk1oLuEYIKtGnCeDSMJXwhEWtYmCrzOwnMVu30XsnRgTyAiJZrJxOQO7OvGwYB7f5uiuZMmiDhy/woddrHHxvwRkVng9GxxPx2n9Y5RbYfwjI8cZH7XKmWb4KlWXtsIBIuwWMDl80IHx9DNFv1ALHfxnmFp6AcnEmubim8+TRmMKKyt1Uc0wRoNueAlj7ewxEdmIJgznwtu1JwdTtCDjbLxyv0u0PuUs1douJmNRTKv5hbzQWIU8obCPFURxRHYmSXaAE+Mvv0/pXDf7hujvcexnFKDdrf4KCYB4GFpO3lqpx6yP3yVcB9sm0UVZHbTcjJNjmwg5rjufROFLAwuvyyukAqo9e2t+oogxUqa2Hj0FnI2FmMplnhsaZfWv0Mo1JbQdXkjbrayz0XgskImZh6bJIZtn9P/eB2ibhWfHns1ufkgoT9yGDZkDtYz4lHKFg82Olx6WM8i1pRvMO4xRy335RoLbIPe6U+sHQYTu851ht++kjgWkOceaNWHE/WqBU6usNnibjIsI7nhCHtoY1KkyGJdlvORmhlSp7jbV2Rh0N6qQmRzHPxikJ6s64ArMhUEXkK/uK10FChIteYBLEgzAWsIFDy6qG3OalnOnMNxCNGCEk1+blhtVkZ9OAhJdK8kdZadmEbsVCiqMNqxDxTA5qda+AISaRE6W0mjM2ESx90fy3wdFTu717QASiFa65HV0aqOf0OEEY1WUKkmTu+t03NFysPyuPq60trirN6SG41gOTgIFCdObCLUwlg0csDlWeSCDTA5lRigxLOv4szp+5rNBZpAHc3NCOhdwRNa13do2OknLn9n
 3YKlVlx9
 qjUaDliWAt8Xr5le8q6WJeVe0Wb4eV0SCgcijOMg70ALor/xCuWDobDuqQ50bQmda4+uA4VwJXPy1rDveNxrT61pRB4RdJgV2PlSTnmiD2NudEfmu+WwwIWUc+Ic5vl5+/VQdGQj30aGAI4OSxECJUES755uWNbcKkN4eHL83y0rIaW7WxUdqPqVTx4nuU4raQwu7rupv2xqT21cGz/Rdx1t6yMyqLGptCaGDegVmQkJqfrYnkRKv0WpvuL4/YpeeaMrK0Vih4ttz3ErHj1o3gWkNXFqBHI+URLCOMQlpusmycW8rvbQFJKH8ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:13:25PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> In memcg_state_val_in_pages(), if the passed val is negative, the
> expression val * unit / PAGE_SIZE could be implicitly converted to a
> massive positive number when compared with 1UL in the max() macro.
> This leads to returning an incorrect massive positive value.
>
> Fix this by using abs(val) to calculate the magnitude first, and then
> restoring the sign of the value before returning the result. Additionally,
> use mult_frac() to prevent potential overflow during the multiplication of
> val and unit.
>
> Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

The logic is correct, but I think this needs rework for better
understanding, and obviously this should be squashed into 2/4 as per
Andrew.

With the below change applied:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/memcontrol.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 04076a139dbe3..0c249255ebefb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -787,11 +787,14 @@ static int memcg_page_state_unit(int item);
>  static long memcg_state_val_in_pages(int idx, long val)
>  {
>  	int unit = memcg_page_state_unit(idx);
> +	long res;
>
>  	if (!val || unit == PAGE_SIZE)
>  		return val;
> -	else
> -		return max(val * unit / PAGE_SIZE, 1UL);

Hm this was already fairly horrid, because we're comparing an unsigned long
value of 1 vs. a ULONG_MAX - abs(val) so this was intended to make 0 -> 1UL
but not what you'd mathematically think this was which was to make negative
values (logically < 1) -> 1.

Of course before it was just broken and would promote (val * unit /
PAGE_SIZE) to unsigned long first (thus massive number) and return that :)

> +
> +	res = max(mult_frac(abs(val), unit, PAGE_SIZE), 1UL);

This is way too compressed into one line and retains the confusing
behaviour.

Could we split this out and explain what we're doing (sign-extension,
integer promotion and all of this stuff is confusing - so let's just accept
that and spell it out):

	/* Get the absolute value of (val * unit / PAGE_SIZE). */
	res = mult_frac(abs(val), unit, PAGE_SIZE);
	/* Round up zero values. */
	res = res ?: 1;
	/* Retain sign. */
	return val < 0 ? -res : res;

This is functionally identical, but a lot more readable, I think.

> +
> +	return val < 0 ? -res : res;
>  }
>
>  #ifdef CONFIG_MEMCG_V1
> --
> 2.20.1
>

Cheers, Lorenzo

