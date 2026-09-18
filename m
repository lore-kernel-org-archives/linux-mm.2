Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E557C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053C16B0098; Fri, 18 Sep 2026 03:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A996B0099; Fri, 18 Sep 2026 03:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9F76B009B; Fri, 18 Sep 2026 03:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C74C56B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:00:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B352805D4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:00:58 +0000 (UTC)
X-FDA: 85225985796.02.9FD95D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 68CA2C000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:00:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ddEaqhLh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789714856;
	b=fRgYUOkS0dvj6h3QeCF0PNJwjqz+gqyQA5NXIQcIXxbGyu8+L24QHaVUGgS58jE2+aayXj
	E5o0M+WfrbKIpVYb1qGHNoQO3NPbxWLfrTH3QGeBiLVai/Tv9rDamyJLOPwGsm8xsf1k4p
	5BHzfPK0MX3s3Cr81Q5dONLhix9Q0qc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ddEaqhLh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789714856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoKeOk0v0E+lrs5eZG2JMMltTlaNFbdGi9KSvcSzDqE=;
	b=ziNLQQeBV4mVIaDdxGZ5hNRY13NXqv5HNd1gy7JPY1zduJ05RfXwmRPpnGBIYpr0m2qUpG
	11hC7KA9+CvXAZHZOVMQTabrmN02Y430Rg0jZzucINfYclVfnummeUUQay5mcEBvrzV4gW
	/r2sLWDbBq4fEhF7MDCzqRCPcVot97A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 353A66053E;
	Fri, 18 Sep 2026 07:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881A21F000FF;
	Fri, 18 Sep 2026 07:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789714854;
	bh=xoKeOk0v0E+lrs5eZG2JMMltTlaNFbdGi9KSvcSzDqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ddEaqhLhDpDSoBo7I/HnGD6o5TYNSCCk1vbkXYkLf2/bYgvnrydMc+ZR6x61gKESK
	 UGKv/IbSNvNPBR1vOqX+r9JgWXrjvDTCFcOrJvX6CibAfDXYyk6MiteN00P/s7B3u+
	 4zD3d4ENXshV5oFAYsQ0wtE3JwGN5yRx90fDESoEzj0+9cqfqRYDfdP6RS+BNKREuT
	 If8/BphX6k0RBR5SE1XpB9ELckQp2CWM3mcQAwcOTD/Cv/a+7A17/8AghwaLxNVQ0B
	 eUvYhxRKtRV4PGfHxJCp8USPFFWEE1cSPHIbDRVKPWKtzqf+hzV40iuv2VjMTh+sI1
	 CPFp1z3iL/qqw==
Date: Fri, 18 Sep 2026 10:00:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org,
	baoquan.he@linux.dev, pasha.tatashin@soleen.com,
	pratyush@kernel.org, m.szyprowski@samsung.com, mark.rutland@arm.com,
	kernel@xen0n.name, alex@ghiti.fr, hpa@zytor.com,
	ruirui.yang@linux.dev, robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Subject: Re: [PATCH v6 06/10] memblock: introduce MEMBLOCK_NODUMP flag
Message-ID: <aqzhnOKOq5m4klFU@kernel.org>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-7-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-7-chenwandun1@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 68CA2C000B
X-Stat-Signature: ri1if8qmem3yjq4gdgpqgeshec17eepd
X-HE-Tag: 1789714856-75686
X-HE-Meta: U2FsdGVkX18LGYsvNdN5KuCuxqW3Wzllm2ywnElHWhCJ0tIqnU5V+Z7CdkWVQkrYJ1Cp0d3RL8QM3Gniywu3qoH6zZGlsl/vxv5RPQ1siIBOp7Fbw2N8vqBb1sW4ctg4R+irSP4woclsZsVLuXhcZAWcPTL6/Y//uTyfkFVz9v+vbXW4sPhavb+3NLNV6mtOHDKAEkTrRCytQPJx4fo3to1xQk1KLMYHkIBKkNFRJfbT6xIlfVxYM0XeiKnulKuXo//6TuQU+DbI1JEdxd4vW30OvOCSH2paCvGwISQBrpy+MaiW/Icntx+yQ9/1q4xg3Z05fFZuPUEv6CzI2QfP33Yeh5SSKhr89pdgkBEXu2gmYBDXeBlm8IzfIx4hP2zPlpEMifRu3eUUlY5RV0Wz4mMbqT8y3qS5YlSHlEm7a2vXkh6yyCHcSpOjAMOaPNXycCMQKQzR8YM/fKcfzJjwlSbcS2OvlUEDM3HJut/XCXxQOCgIybD1EUc6de+mqXr0WwWFll0zu2bdnmn0eFLREOUIm9wMtKUt219kUGI+WwC5cuYl6ikpOqx9eT5fWBogjg7D1AR4wIVMkuxBIqriAlhJuJaHU8G+MlpxQajAeaifliS+LsjzsdAq06/xjMoBmdX6Q6Vd81gO48uVWUhU7hfRgC2VWWBsagJy0zczuUZEsBBNg5h9pLY+JXcG3oQG1NmnTbu3MAZ+b0YbIlbysVuDKP5w6OrrhVRjQlJjAoTdy/G3dJra5p8l1+W657pqtJL8JuI+yyFy/J+2pYwve61gScxx5sacLfoqNwjnjqZV51l3PgsO/cMyRGzvisLrmVYk0c7HdNF4YR6nCos/k4InuFzRqGf9xNx+J0tsV4TunWf8yUeVBGTDBphEPFBoB5i+z54YH6YdE5RynZGDW2ZX7ulm1oJFLATWaRVYl6E4KYwTjnFsU6+pI2XzHBFePgoQIXdK+SVyxS1SP/6
 og37meJK
 dIEXHNwC2IYzOrUnHh0VUY4ZWG1hqJ6VRefBvPB2xFw942shGLZgurzgTlOup4iybKGmGg/f+HPZcVKnkzetW0X58oDMB/sdlfYz2TgUmWj2kSuDAHXBNx5lmLsmjyQg6aBAs81CQw4bZDfI4i7r6RSCupVIPoMcbIcAag5VzZ6k2sz+oGXgh7lqotesLmcKpum03lhUes0/jQB03YUhwDt7xUSxKEZHg1lGtNcij2sVEhknGe69QnZsfTsi+6ZQQa5gn7oU2VUM5TNUpRoE/5HBzY4VBbSe8066lldPaXp7vNH1crk1eZ6mFLhegx7gKwtqqExxj+aHFgoaYlztMZGdWGsOdk+nl/HZKoUB/lBou/RTgz1HmbhQAqVVy5QzoU1n1hzQm3TFETIvwlLtMdzkUQVnbqV9jSAct
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 03:31:12PM +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Add MEMBLOCK_NODUMP to mark regions that should be excluded from
> kdump vmcores.
> 
> The flag is meant for reserved memory that carries no data useful for
> crash analysis. Reusable reserved regions such as CMA may hold useful
> data, so these regions must not be marked MEMBLOCK_NODUMP. Subsequent
> patches wire this up for /reserved-memory and /memreserve/ entries.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/memblock.h |  9 +++++++++
>  mm/memblock.c            | 16 ++++++++++++++++
>  2 files changed, 25 insertions(+)

-- 
Sincerely yours,
Mike.

