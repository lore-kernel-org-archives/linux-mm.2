Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A9AC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2656B009E; Thu, 16 Jul 2026 10:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A25C6B009F; Thu, 16 Jul 2026 10:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644426B00A0; Thu, 16 Jul 2026 10:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2496B009E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:47:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFB611A01BC
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:32:01 +0000 (UTC)
X-FDA: 84994728042.22.D92401D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10D45C0007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:31:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KbqUptLj;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784208720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yS9bNunJIYcGp7pM+GGsfoUYEDKOWl8+J/XHzg82dRU=;
	b=FuaM9SjISHcOCyf7vqwnbn4rYfI5vWCsZInYpPUZAZK0OZgJ1V68YSZpDtZ0p35z0KG3ft
	7lz/5x2Nd3O8pyaXPf1Eq+75peYnw/0+pYqzh8fzsCH26VE3UIAhPTeBPF5b3Ersgt+IJd
	ZXG7kHG27POkZIOu06yhCKlHOBhRJvA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KbqUptLj;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784208720;
	b=6tP2XNJp96wUFdYVwyfh33+/cAz1SJ4AHPBCt725IIBWyT8BhQkF/QckKqNVS/lA3kwPID
	96cX6NB7ocW5sA0YJe3kLzBrQuqRkF3BtO+7Fd0lcYVQc2QtibYoI8VN1C3MJ/r21HdK7d
	0KwWYWtudEmra+7WJ32z/U7hVlQJYBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 432BB40743;
	Thu, 16 Jul 2026 13:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905941F000E9;
	Thu, 16 Jul 2026 13:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784208719;
	bh=yS9bNunJIYcGp7pM+GGsfoUYEDKOWl8+J/XHzg82dRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KbqUptLjSwHbPDnl6EODLgtr0+4G+Vr/GtLsN8uL1R0gJIbcJrT9INA5Bsp48xFc7
	 uBGW/ISebTiRPnsimApzUl9NclYX2xh1l1X4NXZZjnAeSSSFNYTRMypcY/rUhyl+X1
	 /7F6szx0dZdEkzpjdZXEZE5GDp4nGDRMG6wLJU1JgK7vImT0swvx9wF8O4ht7g3joe
	 kDDXkZm0rqfhR/CQny+02fMgaTBpKdu49C8Yx2xuJ87zFpVlntVhAzq2XjsDAJ5/eD
	 MgCdvius755vFAuRCD11n+E/RU74UcgR42ez7mpfqR5l5mHGTHiYGsp1W8i6LKucW6
	 B2mW+krILaKHg==
Date: Thu, 16 Jul 2026 14:31:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, iommu@lists.linux.dev, 
	kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>, Ackerley Tng <ackerleytng@google.com>, 
	Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 00/33] mm: make VMA page offset handling more
 consistent
Message-ID: <aljdJD9TNWYCQ3HL@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <c2fd5114-74d0-4996-8035-311ba976b3eb@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2fd5114-74d0-4996-8035-311ba976b3eb@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10D45C0007
X-Stat-Signature: w89mnrp1qrxfmbqxemyuwtqf6qpq5s5r
X-HE-Tag: 1784208719-449385
X-HE-Meta: U2FsdGVkX19rs97S22S5P0DP5YGY/vdQcgxXTp+6VsjYf++U4/oQQVbAfq2X3eQ5eZusv8pcpokqUZWOvoZ3HrWB3LapZNsEKlo7shCYHwBOLpixhMICgUB1f7bj6mLIjuggWw6gJ6+YcvbYJx2JMJCuGdc8nlqXx1w1Wx4pB0fHNiSoQoPpEIrHpBn4J+9BXK5e65NYiUwwprBtXfw3ffjmDvsFij/8F0Yl6xSlKbldWCCZQ6udvfQrEE0Q5jOVfyf3PcZ2dEPf4Mb4HZP9BaYjC3IPKs7f47uBx4T4T/jm25G8/mkaJbms0hNtqE6Avcn73uQTocMfIZps6hUxnS289J08VJvTHm3LIxnUKuacK0X47rDleoSF49kBLFsQPl5t/aFe3Wry/vOg6+aJlf7MgEarQt73AZUXiJRj0vP2pOmEQNyexxPUDahA8fB0PqvX0W23eQFxZTnUhVQPCWoXHkz2JHhfAVi3qvfwZ6E4fq3oAZs4bN8Hgb6Q2fAHYdXeHVsAueINsu4CurHcD9kRuLQYGgTY8nWre5apPllii7kdL7aBG6Gi7iou6kEDQA4LBBwf1yXZfQO5llwiByt1C1DPe6rIoX6bw2U+Z89jROE0cOEYPyFz6yD53yaQjhVy0cRjf1eQEiscCXyNQRusdW8Hv3DBy5KmOhOFThKRSIEGxFVaRJKTAut1NBbQdTlbl/12Doc6+nvgB0CIvFYVW+fxks7nrFlmZX45Oh59K8xcD0Uf+bsCp3TP6MNpJOeUU1pDDWcqLAjb7PHEMJvt0vrFOFKKz6oI6MDXOcsIOumfPGtDKU8eHf0dHSP11elVUNWPMRXPrFLL4V6Lj8dlHqp7yvv3F9ljrqoRKd1jAGlqI3yxG7iZZQvbqYM7PC58JtjM4gpul5rMjFj4fvivYgF+v6xptyigIVFJTO8+TtA2ush9i1PAF4r4IDcG/CSHs9oZzg4k4xw4084
 M+K6rXWR
 M7yFztgWK/uO3D5Pr1BtkIkZozG5UYt7GBsHS3Xfz6MIh7hDHPO0p1yeIr1OeIuCGUJJGPshsxujWwKrBJ1RPn5HnbyWmiy6H+gBRwSAWGrkxAGzcj83FNKfRU32UvcK4CLNHc+8r81iNH4ohLBxafXkYxIK9x8t94eRKtaEn1gJCwGUQhfGIrLIqXPVir4ukHzfYqoiNy5mBXw3JcbnRdsz/hRHIykbsySN94McB9/uojeezd1MXm0t2OXDwbviTWj4mtHMf3PjVcNaW6M8zhU6vptKbBfaNrjxmni49VMVn2V2Fw7nPQseR+XQY0mEIsBnX9o7EWWxOEFxJQSi96E5VVWP4/lKcdSDEwgOkJZdD3TVKc3Y9UjhH+6zKi+SzNySP/2CJrg3saZdrbYwa66sXgaNdoD5m5X/H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 12:03:41PM +0200, Christian König wrote:
>
> I only skimmed over the set but should there be any changes required to DMA-buf, amdgpu or radeon driver feel free to add
>
> Acked-by: Christian König <christian.koenig@amd.com>
>
> and merge upstream through any branch you feel fit.
>
> Regards,
> Christian.

Thanks :)

Cheers, Lorenzo

