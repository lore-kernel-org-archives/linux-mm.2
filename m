Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C79C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5982B6B008A; Fri, 11 Sep 2026 05:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F576B008C; Fri, 11 Sep 2026 05:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E396B0092; Fri, 11 Sep 2026 05:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 207466B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:54:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87F5C1C0941
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:54:03 +0000 (UTC)
X-FDA: 85201020366.04.B6BADE1
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD46B1C0005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:54:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MXpGqIW2;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789120441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5M95WIaFsi2d1eZZAa7AEXfbZ9VQBY7mOxP3ywQF0g=;
	b=1+bHcyqyU+MA/ZzKYrQPSQ9g7lDcdI6onYbQR6gJeiu4br7WddLVhOYJIU2VC/1xl70+wD
	lIvNH/v2Hk+vP5F8XV9JKjrAGszk6reAuIGtAqvUBWUDwRpldVQh5csfz7fIMjfKoe8eqj
	cP9exnrbqZh9w9v764zoNOUP+nbfnko=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MXpGqIW2;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789120441;
	b=o4SFuWfazmKt1qnfwvrtBPYLHfGy1PNHvK7Rhya4mWHV+CoAqgiN3oms9IwvRKWckkaItl
	pIomrsytZFgQ2Q/nqpNQgHeepH0RR/2WKozcsGkikE3zhf1o6BLrZoGNrGpz2dxwygCjMA
	Z1FzMY5QaAAtlFCpZ1sPOBOBi+kTaW4=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8558c0b26a8so502073b3a.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789120440; x=1789725240; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R5M95WIaFsi2d1eZZAa7AEXfbZ9VQBY7mOxP3ywQF0g=;
        b=MXpGqIW2P67ecfIFpZj8CLFyFEkNn0CoKjXXP+PwI943VK8fGU0MWTcC4NLg1VcUDk
         xdhvt5QkxAAyTCGjAkv6xrdt5zgh7UnhxGQpJWVxQSkKSdlgwXGesmO5rO4z8suMQoHl
         l0J6u/gqn3sH2z4+kCV+hK0uQQOnx9YK+QZGI4nEQlHDNXt9/95UrhZMZLhOt3mOJQS2
         yMz5LHGN1009/qyO0kbG2FGYysw8gSCS4nzFdaa8JLWSDrH8qqX0KD0FHjS87+zKEMNB
         8xVVXkei+KjkhZ/jRDmcPrPHHfe0qxg+wH8mnEz9mZKldlFGBYKJ96tLt8M3mZn6hjn0
         OMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789120440; x=1789725240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R5M95WIaFsi2d1eZZAa7AEXfbZ9VQBY7mOxP3ywQF0g=;
        b=N8tPyGF+9DrlPxofdgspBZuVE5HBLcvyFrj9JaiNnnUmp5lNe2AtPapk1sFdTMAhIM
         uWU9FgV0zwGP3ih6xsN5ZZl6pYW4MHB/gL+svCLbx/gZYq96M09MvvTHcHEoNrBthbDS
         0MBAmmuPjib5V+QuysWv6QbGKNI5JO4bFqB3tQ2wj2KtaDQZJzuLKzuKKY2Yz2n4JRKl
         IZCBllAWwYI4vrT3zljtULAf9ny1XF0QTqFzN7vmkCWJzTqbJGJyIOz98ARZB04KHDor
         l8YqgAdOqcrxTOGz+ZIwGL+4tt0YibJv4HFs0J/GktMDj/EGr58KJkI/kDB3vXDJMwaj
         uKyQ==
X-Forwarded-Encrypted: i=1; AKwUvByC/s3uvK2iC2CQEPmC+JRIXbGWY/7AjdMgy0rR++kcDb0ooeJQVNp/7C3LHrXaoDnnCrUD+5iOGw==@kvack.org
X-Gm-Message-State: AFuF++k9Pq2K51ApTOtT+QEApkHNsJiWWzOcxHozbok5TcqEWHpQWfqM
	TvJYroTvclOz4ULAE7sQqC0DKMDMiCorw7Qzji2nNMSUigTSCfQhnCma
X-Gm-Gg: AYBFou1qmgbB2nw2D+cAZRDP3c96ujkB1eAIGVVXCJWf5o34BJVn+PwGwlmN1pUf1PY
	HBMLTw5YdVcVySwMWpQbXRcfNGT0QCTr/741H9AnQIHIp2wgi/4Xlu/biuKNFzH/wQ765ssW+pv
	Rn1uVLvbq8PmYH8vQkgZOEglkAlrfaAoCtlhv+d+fPvwcOgYO6JjeFW6eITWb0QMyTPNg+a2tu/
	EHW/EYXBaYZPpmySiX+jHej9t9JfeXxRuaLFos3HE5FDEGfymj1TVyYlsQbHR+U84vIRqLU7JHX
	uHTDZTt2P6TIBup/sTKYR+9wzpz0ad+higBMDpALhHd4hovcw3tcu2VL+QKbyTooJG7Xq+pl8jR
	r+HDYir9DFH9G7Ig+/ND2fk1EFD/y2gYD0azVD16lMJ5O0+LrXDO9Iuqv2oBEjSWlOdhh1hoJ4B
	iSOtygEPfDPG+1omXh0t71ZqMtCGNSoTP/fznlX/RRKP8Bub98zwiy+KLr25apOq27r4rQag==
X-Received: by 2002:a05:6a20:7f96:b0:3cd:9dea:2be1 with SMTP id adf61e73a8af0-3daecb20df1mr6246360637.0.1789120439682;
        Fri, 11 Sep 2026 02:53:59 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6550df9sm868437a12.16.2026.09.11.02.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 02:53:59 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 4/5] mm/damon/vaddr: extend apply_probes() for hugetlb
Date: Fri, 11 Sep 2026 17:53:51 +0800
Message-ID: <20260911095352.2803549-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909140408.104699-5-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD46B1C0005
X-Stat-Signature: yonaxjfrg7wneyf53qtegmxpfhary38u
X-Rspam-User: 
X-HE-Tag: 1789120441-386220
X-HE-Meta: U2FsdGVkX195NOmlzGMpptsh/Tp/sSlfjhg2+sQAKwNnEskLMRJcxdcH//RjRm60myW4eTzZMqBrjXdBt0ogz2kGoF6vFno7PI2wzHajP5UeeHrF8r/HUSKmGUs6eo1XV7CEr2LPVsbhWUN3NM3mFKV2OvjLGX84Grx5SiCce6tlET0XlA4fG1yCVqI2kZ5krKRqpzVuhgjhryRcYRv0T7nNYXTUPFrcySHntOyiacVv3nAxNKU+sjzMZ+pxjD0xiqVZTpS+NvUomEAnuf5hjv7kP8f3G98A4KGrIZ90jGxf1Hgxa3U6ZPJiyTNouWcB73KHpIARy6un7YsfTLx1l29fZntI9PleZRAuZjv/WWb8kURcAFzGj6V4I+0HZXwtRjwsdcj7Li0IZOtsQzltrIydDxv0bvGy+xQeLz6UUiQq4yxVywp31FsZOQL29IotVf6JTa2KHoM4zogXFJLiyBPxfWSHIfhMjvtpyP7Y3kf730Kc40lwWIB4uS7dFG49mo8ReNJ+ymQaKpajyroUIUwbpWntHepuxo5zJIGWEJrwVMpuPoDFAW8GxV9DhjsblYuLHemlQk23de3NV1fLADuRbRCUJktCXW+xv88qQ8x77NffCmNdU+7JzrkA7lz3btz2ddLweUceuk5It8Ii9ioJ/m1fqrIJJ6Z4rj4BGyae8jf31G7iXeYXlSwV4pAvYHLBp6Ycu9hLiX8HVsEogLElWtWJn+eYKGKx9hRGzbOj9SpvH1Xoo37jupkd/3J9av/re3Q+3Umfy7s3UNvyHHpC1b2qmKso0VlhXP8ZwrivjEC1Mj3S4letAtp4e9SQZHxfEpznfMcrygQDGE/NFEiwrP3NWKwQynC+bNnf8A3WhhYWa5JrquibBIBMrD2lBFl4YSxU8dp2zRpBWBq9T4G5HgMo5/RjYw9zSXwshhdR8ecM7JGdUlgBsJpmJRz/xFPnT/w8Aa6dBhD9ngU
 rvfPNX1M
 NyJ6Y+NKXd0b1uF5OqdidkDXTFTUTXZz1nUa3vgNXPKmtMpBMS8MZMcaO+kAVSneP/zcmCgV4gyL75OBaGAI1fOtPabF4j/5IKRRy5meGCiXHQ1dSaqWk1cDpHh7+C0Qets79SqyPyBzFVjLRHCE+Xnn/VwUxvvAIlZnz9TzftmHBuWwAPP5Jxoml8xMvrDepX1n/4xi+DwSHwe/Pzwa/3sCdK1D/69FY5h9Kb8pjDfOG0gurMQs0BtQcXd0v+B0MG/0qD6pIXEFMJQTLvvjVAfgKcvDvAT9m2Wg5lTeMgVkebY+kJBNlsePyYZ8pZAW/fSYvciHVAUtGoB2yjO6HQFrl4wR6WvdYP5ILb12bTJCqQJ5fO1GgZlfROUHfeoxCMn/RLGfY69ofjIpyvFplHE1VrEVgRuJuxgX9lXv6FQ1asr9fVekT2MOLG7MPPpxaO75NkV0i93RxriBM+/KYn5Zp27y+25U11uIg0+8Ebgkb6DndPu6Pi/44tvRVcITvobXg6hvt7QIA6CMJlvIflXexOoUU5ABxwOvW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 07:04:06 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON virtual address space operation set(vaddr) does not support
> hugetlb pages in apply_probes.  Extend it for hugetlb pages.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/vaddr.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 7c548ec0cf6b5..45239f05e113b 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -598,6 +598,34 @@ static int damon_va_probe_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE
> +static int damon_va_probe_hugetlb_entry(pte_t *pte, unsigned long hmask,
> +		unsigned long addr, unsigned long end, struct mm_walk *walk)
> +{
> +	struct damon_va_probe_walk_private *priv = walk->private;
> +	struct hstate *h = hstate_vma(walk->vma);
> +	struct folio *folio;
> +	spinlock_t *ptl;
> +	pte_t entry;
> +
> +	ptl = huge_pte_lock(h, walk->mm, pte);
> +	entry = huge_ptep_get(walk->mm, addr, pte);
> +	if (!pte_present(entry))
> +		goto out;
> +
> +	folio = pfn_folio(pte_pfn(entry));
> +	folio_get(folio);
> +	damon_va_probe_folio(priv->ctx, priv->r, folio);
> +	folio_put(folio);
> +
> +out:
> +	spin_unlock(ptl);
> +	return 0;
> +}
> +#else
> +#define damon_va_probe_hugetlb_entry NULL
> +#endif /* CONFIG_HUGETLB_PAGE */
> +
>  static void __damon_va_apply_probes(struct damon_ctx *ctx,
>  		struct mm_struct *mm,  struct damon_region *r)
>  {
> @@ -607,7 +635,7 @@ static void __damon_va_apply_probes(struct damon_ctx *ctx,
>  	};
>  	struct mm_walk_ops damon_probe_walk_ops = {
>  		.pmd_entry = damon_va_probe_pmd_entry,
> -		.hugetlb_entry = NULL,
> +		.hugetlb_entry = damon_va_probe_hugetlb_entry,
>  	};
>  	unsigned long addr = r->sampling_addr;
>  
> -- 
> 2.47.3
> 

Hi SJ,

Reviewed patches 1-4, with particular attention to the vaddr prep/apply flow, 
the filter handling shared with paddr, and the hugetlb page-walk path. 
The changes look consistent with the existing DAMON interfaces 
and page-walk semantics. 

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com> 

Thanks,
Kunwu

Sent using hkml (https://github.com/sjp38/hackermail)

