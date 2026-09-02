Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A33B3C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944F96B00A4; Wed,  2 Sep 2026 13:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C326B00A5; Wed,  2 Sep 2026 13:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8593A6B00A6; Wed,  2 Sep 2026 13:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5953B6B00A4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:38:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAD0D1201D6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:38:30 +0000 (UTC)
X-FDA: 85169531580.11.8D60E41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 429FC80002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:38:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6Uzr4pq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788370709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsI+nhzULsUUSIbVGLobSbdGnJMPqPjlO3ivoC99fNk=;
	b=44TT3VXWrmu4YtWwfJESRe43XvA4O3bOYx9GhFLP+UfpFwdk8hrp5c3pQBRxVJpvazLiHS
	24wVHvcKvx1o4Q3M9PemzXoXIMEibOYuAGOOFyAw2/hZ0LGHxHb+U7uGstGL7NJdJYHdiH
	xA6JmvQNMpFG3ZKp/LJ6TeQjEIZ0oZg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6Uzr4pq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788370709;
	b=eefEcg8rDACjy9vns4LrY8Qu0b5O7TntnMYz5JCUqLr0rzJVQlMnNL3A8tc68gQRH26o5J
	7QHWbFFOKO7syfz8aqvOS+vYvvQtX1M8noc4gA5hyVTzoxCHc9dCV7Yu0aoxzfINP1MJ+4
	6KQWeYQQU4yQvCtTDeqjaHp0jV2SniI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D79040268;
	Wed,  2 Sep 2026 17:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629A91F000E9;
	Wed,  2 Sep 2026 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788370707;
	bh=fsI+nhzULsUUSIbVGLobSbdGnJMPqPjlO3ivoC99fNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T6Uzr4pq+Kb+UO4HsQ0X42ZQMwEqrNkLYI01z+d2YhKthM8zctAHyrriDmaHx4SzQ
	 aOqXsOPVcxNp5lj/SPnwfFKiaT7ZtsWIe1KheN4h+Ml8Al4W4oHiTCGKrfaq1Bw+aG
	 /vOTnHhel0XgusHtqAAQ15PacrnKnFeT6PElkPfnrsoAI71YQMp6glvP0d2VtCRYJP
	 Ikv6Em1jxZ8eUs/xdMnZmToKnAemXxHkr13Nwl/ucjDhwipTmwTr0OSYTe8se5zH/i
	 8vow2FHxR4TAQTO0V3RML/oWzxwCcFFeozjODhkhkYxpAXcQ1Ze8iSkxqp49wtEN+c
	 iRzeRHCPdTozg==
Date: Wed, 2 Sep 2026 12:38:26 -0500
From: Rob Herring <robh@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org,
	akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, mark.rutland@arm.com, sumit.garg@kernel.org,
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 09/10] firmware: arm_ffa: Introduce ffa-lend-pool
Message-ID: <20260902173826.GC1440252-robh@kernel.org>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-10-vdonnefort@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902104712.2399797-10-vdonnefort@google.com>
X-Stat-Signature: fpaxambpmz9iiy6t9pstwiqywcgomdbz
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 429FC80002
X-Rspam-User: 
X-HE-Tag: 1788370709-112087
X-HE-Meta: U2FsdGVkX1/MoJOJfitHaejDlWVc7MKkI65tnzJbR28+wHhAijVtXarF+wBAUo7ItXzoXPkugQqO7Oq6hg/a3i6ZsoCoXOEDGINYCfhpaEsotuhZBTd0BpIrB7SRzws/1QJ410qY44HKwew+8tsAq+0XXuPsVQNRlkIkrSoNLm+TT5vtKCD5K8him71fE3knSfQP+emVfb6QDJA+Av/CgVOh/8KzGeCv9q30eB0sBU0mNzqIzCruOtxlZPJ+YFxiuq7dSG5M35+hSnxgAZ/kTLIdo4VIADQlcvhNgUdRhuMJKDTXHa3/+oPs7ay+4gE0eipjZTOvVlQW3BSaVLk168nx3Tr7ZyG9ujIJHJCM1d9F70ddp/sJqyLxDQmmGRiS9/51fczye+gu8uLsVrqXZRGY86VI7V4HVJOaNoYeMgzxHU5KHO/L1faJiZfB/R7otGQO+JWsVeXI1pbbJgr8vrZfigBqF1DMc9VxhbzS+0JIb2hLf3hkf3LBqYcI8OwOKkEIAaI4CE0cEFodfKSEiENqt52F8PhyDJ4EZOzvYCQJqMuPr3mpfW314Umg9KqLW3fLhTupQvVvGmeeRud9iU6zwM2qYTMxn7mtAdbbuqf4N3+rwIluE2WIVdk02WY0ZLI/Kd7Glv50ifaioci+atDfffIakh56mzepey12Szi54RTSvJcK1Mm/mVTDfFMcW7ngeX/JrWRPJQZ1bX2e9NflhvjXjXKo/BBneVLGmkEMRdzvsKd7CDbXUKnfYBiRftgan06ULi/hUYurrmph39wBINFFQIMMjNtkAMrM7suv8vKD+h6OSxO23DtOuwLYZE7dmBlYIFpDkaOBI23/hdiY1CM9UczsxhOim+tayEvBKYgOjQ6v2oSgWybaBkXpoWXGAZPRvpW4AISLvbOH4ItPwaysCfwvrvGJHEAhFFkL/ZHBCP7TQPJfQ3GDCvIH4INDzOyX6dWDSrVDuoO
 LSba0gLY
 nWAfbSa/qXYQjtbOLPat+87lypJhHOBbgmkAH+RRPraZyZJ1GyorAsoxfNKAu1HIs8DdVUzqSWe8W+Nwo/G8C/Nj68hqXGI/0YkNEIJVJzbikDrqGVDQkEgPWtTGPEnSJPJcNfiFoFtU5Ng8OYJQeotD5NgWrFFmyaZMjPC1Ui0z0ruisrZ5y9GTlYlP9JO4Jav4QMBEX6JwbAc8/aB16jGhRmtgUmK0XoqqezPc320Yfh5xHGb/dIK8r6BjMWqQJmoEeYaXorH9/tUENpsY+L9WQwvEPRZm4IlvhPFhF9m3Aou9ZVWSi3gm/0qxUo8lYufr6bTnyjsmy1s8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 11:47:11AM +0100, Vincent Donnefort wrote:
> When memory is lent to the Secure world via FF-A, fatal CPU speculative
> reads from Non-Secure can still occur as long as it retains a cacheable
> mapping to that memory. Introduce the "arm,ffa-lend-pool"
> reserved-memory CMA driver to unmap pages before lending
> (ffa_prepare_lend()) and restore them upon reclaim
> (ffa_lend_reclaimed()). Devices bind to the pool via the "memory-region"
> DT property or via ffa_lend_pool_attach().
> 
>   reserved-memory {
>       #address-cells = <0x2>;
>       #size-cells = <0x2>;
>       ranges;
> 
>       ffa_lend: ffa-lend-pool {
>           compatible = "arm,ffa-lend-pool";

Needs a binding schema...

>           reusable;
>           ll-map;
>           size = <0x0 0x4000000>;
>       };
>   };
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

[...]

> +static int __init ffa_lend_pool_setup(unsigned long node, struct reserved_mem *rmem)
> +{
> +	struct cma *cma;
> +	int ret;
> +
> +	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
> +	    of_get_flat_dt_prop(node, "no-map", NULL)) {
> +		pr_err("FF-A lend pool: node must be 'reusable' and not 'no-map'\n");
> +		return -EINVAL;

Your schema should enforce/check this.

[...]

> +static const struct reserved_mem_ops ffa_lend_pool_ops = {
> +	.node_init	= ffa_lend_pool_setup,
> +	.device_init	= ffa_lend_pool_device_init,
> +	.device_release = ffa_lend_pool_device_release,
> +};
> +RESERVEDMEM_OF_DECLARE(ffa_lend_pool, "arm,ffa-lend-pool", &ffa_lend_pool_ops);

Do you need this early? If not, you can create a platform driver for 
"arm,ffa-lend-pool". ramoops is implemented that way for example.

Rob

