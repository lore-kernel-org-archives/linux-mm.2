Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0C1AC44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD506B008C; Thu,  9 Jul 2026 05:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AEF16B0092; Thu,  9 Jul 2026 05:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E2F6B0093; Thu,  9 Jul 2026 05:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64EE76B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:58:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7D15120468
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:58:58 +0000 (UTC)
X-FDA: 84968789556.23.5A4CE4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DC48B4000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:58:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HrBNYB+P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1It6yxyQPzIyWutbFZMgnXccx27Y4Ek4Y0tDuWVYk4=;
	b=JTls4GIKBTg5s+kbSWJ+8fS3T0iu31AvWVLaSapoXrPOdlPqfrG0xFmI9ZQfRw35+Rb4py
	sMHByapo7t0VnDwqCL+CepipN5fvrWQBKbtAFK9JBH3ZAoV5yIf1ILp96FpyHy+d/OKAhT
	shMJB7+OGgIjRf+WNcpvp5Db3KpkJzI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HrBNYB+P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591137;
	b=CjQ++Cw9ChhLIg6JMMtGn35E43yeL4s5rNkLVO3viqcDTcUByqbOn1QcfvNpHfLTV6I/zC
	QOOKim8nXFroHOVuIeE7rR2cyPHJRKe53rMcsqyLF+2xAlTbLkp3EcDXXLuZeWX2xKs8dP
	35Xodn9SIWMcZrDSL3rEI31dS6CNKUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 274984165E;
	Thu,  9 Jul 2026 09:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22511F00A3F;
	Thu,  9 Jul 2026 09:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783591136;
	bh=x1It6yxyQPzIyWutbFZMgnXccx27Y4Ek4Y0tDuWVYk4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HrBNYB+P8LIh+GTrL3Psw9XZ2FzjGe6EF988SnGYOKS3nC9RTmLcM9/JH3eQThL65
	 UkCfACLKKahoOdFQYJayD95IJldLClw8DEXgf8dmgcQmVHZA02TW4jvRCh44e0WMna
	 KqkLGpJlwUtbs7awT+gTIT/XReenN5L6hwl7eO7bHWm2oaHJdCTVe9AHkDLLlDo3b3
	 BXRqt4qbzNMVquJPCXieo//V2FKRc2a8uZ4B78YyrictwuunZjZk55C/ReIajmuLmZ
	 QxoNQN7BZSfLdXCz4OxOoBIhGrKtlsvXNGhgSaGWgfhhqaHqfZVdbbn1Zbkl+JuTh/
	 ETOKuDiMeeEtw==
Message-ID: <f1720e2f-c25a-45d2-8c51-c88bffc8f5f8@kernel.org>
Date: Thu, 9 Jul 2026 11:58:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/ksm: Initialize the addr only once in
 collect_procs_ksm
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260709173212190rZdwynySRyLr9EtPuXBRU@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260709173212190rZdwynySRyLr9EtPuXBRU@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dgaueiytubq619z7ag8qrg8jmgzgentc
X-Rspamd-Queue-Id: DC48B4000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783591136-575295
X-HE-Meta: U2FsdGVkX1/l7HT8V8Gm1LzZ7E73D8Nv4TucsivJKnZoznun5jHAgPtXQk2dnBFKpKjsWdktic4NMy4S6TwodWHNEKor50CaLyqQkLmqKuj5qt1ShYfGDHO1C+5l4xgwNzYud/eyRF5HDDv2OkYCaHaYuZo+HkS0lxDmmTEnujEUTM3Hr9RaHd4KM4OC/z3TggBbWTUKe3X/lUMm5bWc6hNCHAICuKc4qybUDksQLxdj+/vGQSl4ydjOd6KyrG9wGAyLNAnVRLMgu7Lc/A5viCQcaPzMtfsdcCkskfc72tRus70dndoJXiipcGVZ5BQ/gXjRIsWtZt20jvwtgAYLmkJFSxEXje6V/kf7Xd/WJd/20q5/HnRLxj+G8Uh6QO9s/mqyRSEhnR1nJ8llT4eDEs4atgBGLt9D8DjZXiaa+JqTvzYzOlVALraOC0eQxSjL4pUUCtY7tGaYX06m5NG0OVnPwgTNYelYEdh/LEJsgeQV7QkT2LBetXVv/kTZGy+LgFOdeuho+stumYInxZGjXDfCvmKoW8TECk6lhcBwtg3ktQSbzE2orsch/RN1ctaFKJ3NNWktnlZbciBO8TWpQiWVD2/ZciL/hIiTZgx3tYPQhOyLYyIwpZWR5ayBD5Bv2Qqm/4SxHXDFTCDUMWXNdOcVCCYBGd3mw7H6fCAkdVc3nMpPm4XLPGAOa2lZxT7mEsJdUyo9BAPt5mmaOj/CQSZg/D/+KeCmuyxd7JODXeSBErdVtikdEc6WkoScdQ6AmYYV5woE5zqkDf69BxGfb1s9sG+0mcX2xx5NidaMi8sSySjDj0g6/THj9GkBzVTq9n+55/v7N432sDyxpUGp+0ZAmRV9bIOFvIs0OFhqFcfdGRtbr1H9dD42lEkyO4ttf8UiMDvjqcszbI0vVKejBFe22ofkzQcQdPGn6gB2WJ96ZthHKL+ExFX9Udrs0JSaH7uZOOkh2NCCXNiGssi
 ASIznFVx
 sCE7GqcdXqkeYPD5NUwNt3H/7TXBMBRad/sTeIc+APXlYOAFoG2fOtF4PMRD5cylmhzPYMsCatQiWcc8Bt3NBq9rtZLz2vX3VNUmnHNjU6oMn6+tcBoNYeBiKuKU97LtejWONrIBWa7GfUazJJ+r59J8li9gisOt8oAaM1EP11G8XzR5SkjKKjj53o3NK0gwjmFAVjIxqzwC8q5KJNP63Llb+Re09V9vFxOkgtl+uX87xLfMOwoZD4CqF5+MQjuotMwDVevNf1vFUoIIRbT7BiQv4ru2FSMAQXlSi81/KA6/BEd0N3+IO8Hu7IrIXr6/hkF0VQmVIjQ7sOBdEOdpHNnyEiFYfdKP/+TI6067mxbHmQ8nmkQA9JU2VdUBlXDsPS+RG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 11:32, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Similar as 318d87b8fa7 ("ksm: initialize the addr only once in
> rmap_walk_ksm"), only initialize the addr once in rmap_walk_ksm
> because the addr variable doesn't change across iterations.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

