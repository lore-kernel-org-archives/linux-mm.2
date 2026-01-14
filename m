Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D889ED29FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4776B0005; Wed, 14 Jan 2026 06:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1722F6B0088; Wed, 14 Jan 2026 06:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07EE06B0089; Wed, 14 Jan 2026 06:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED6FA6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:24:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F80D160486
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:24:01 +0000 (UTC)
X-FDA: 84330335082.08.446C500
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB2434000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:23:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ut0P9lA9;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768389839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VphXTQuutHMotyp7zjQGuG5Th9zUZxnMkPpw6flHxpg=;
	b=Z7Qwb3KO2h21zjZkXF/cw13Om5ZZA5L41lg4iM0pu6ZpAQozCUgmvYJWVYdIFkitLDXbYm
	dBp+bLM8p6txhOqXfxJybjDhsYlKSVR2j0luU9w0EuOP9HJgxeoOimRwxoP+RGExRGxUC8
	ZUSFOHBru0IU3ApQGHYDdDse1rxKiy8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ut0P9lA9;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768389839; a=rsa-sha256;
	cv=none;
	b=5gpkZChxD0boB5iKdOh4cnhQ/5n9s+zmGu8ISiIdI6DXoJ4hdyhGz/c5lkajneGcntRlXJ
	ag3YGp09YRU9AasTJwMeuCAMMvmTQkMjfwrhvQksYbOIzT4C+7ysSg+esIh2o2oZhgCkiD
	iIJEaaov+cop6v8sOiNTRC74VKcx+cQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5C5E42D78;
	Wed, 14 Jan 2026 11:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B43C4CEF7;
	Wed, 14 Jan 2026 11:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768389838;
	bh=CU7pspqVFIVlf6unOXZ0Myd++E9+vX0pxaKf1HIeFZk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ut0P9lA9j9j7nslAaREJqvMqIcmCQ2WrQdJDns6AUp+PwTpj5uyfjtH8PTKAC4JEF
	 iwtgb+whVZRKvXr2hGy0IgSIVyRF638CXnclmy2tDVBpuXupuwQA0I+tvDzk+0Svei
	 KgJE8mXmP1Zi8+gays9nS6dBFPiW6qaLk0++Fovl0GaBROA9igGmLAJVSIp4z1VfEv
	 CwBipKKkndTXgAEGwmSxZS8cidjr9IV4x8jU1kUjS9mtW43aXiFOvZt+/5cMKaPp/g
	 KHknqIj7QGxJIDB8Yfo7FIsaO/6pGNWUqjgJDJeC44oO2h/uvYvcejz5GUV2G8Ev0O
	 oqK1LWE6GEnHg==
Message-ID: <a3d54ed9-773d-4369-801b-f9729772d6a5@kernel.org>
Date: Wed, 14 Jan 2026 12:23:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v4 2/6] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-3-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260111121909.8410-3-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AB2434000A
X-Stat-Signature: yiacuw4mhxrksn6xbayrt99jdh5mhix3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768389839-790505
X-HE-Meta: U2FsdGVkX1+qTAUba3Jzhy/HAviIgLLrqAhurNlszUoKn2bF06R8WmhPNADJa1QcSnRIZgLxNdZY/sRqvU4dGBqndxc2Un0XX2STFuL1DAiyZpDeljQcaEvfFOrWaeYVoOkmZ6ORar90aP7WT7dfjz19KJMa45RqGWz/zuRFus5ZX0dsF0Lpuweo31nDOSebhhGKdF9z3iQcQR9eS2zbTYjI4WyUZ7I8rzb5Yx55ROmaMjZA4KPvMzGpGeepPRbpFKAdccYSkNITa0IqFWD4vA5rcUShcFq987tndb7BlETPPrXI4lrLVgkbqAUzWK8MYwuFoWGMZi9qrncovgi8Z3Ld75AEOpSvsv6lyOWFqboexP53uKv6CGggoBE5qer9hbtfDNdAetvi6aQA2MJR+WDYFXN5D/rCvTSNZo864BIvtT19ePs5uTFZ1OagzpnV2Dd9tP2Co7q+1K8bdfE+fxBQ6Rb73qUHqRWIUft/qHS4Ysm24YvqKa3yItpah2UShZtfD+fp3oLRnS1/Henc2g4/oEOGoDUYuZGktrExrAcOzxgD+n35YWx5wXwQ0mozRmjq2h4HkknvEbDwG8xbZLOiHuDGcy7/LB0yABYBGAjIAIvOtg0mp5q5XGGo2Wex+sgfgB/MWZK661kbf55/BqIKDkvrYxhP7owN8tB+UJCTSDtjaTKEsY/dn6ITYsrrGgoLwyX8/NFONs8h012BQK+jPvXDoyYNP6iWD4KOMzcVmhSnj1zdJym4JVraSliYfxQFtbDK2qsOwJGst7kRb0LAGTex6ajTvNGG6XIKRFvJrIylrIuOp+aLOYIeVQBREBHXU+/ETr86jxnmvFF/YH4ayT+V0cclO/vLK0ApGl9sA3OWvf5ObLhGNoxjMMY1HF1UJ9481ckkPGTtuvj5gdJa23hWBGYVrmCSzaH74Vb/NHgLXZJc6xtC2rTc3rFrDSq50Tn5Zglw0S2LPmn
 cQrJbTEW
 Ac8Oua0gBK6ZgWh34xXGd4pYLDDXyn2mv05PDWXRWjkChbdP0EDCynZ9zHgpcFSIfmgXS0EJwyesfkBmOswJbQ/FYpLVsInByhwK64aBLBFWN+RYnxVcmLvqq08QCuFZ3Sq4lIC7va6Yo4sb8qAQiXs4qHdCDb0/StoEGcWSlkh2eQfOUciJ12IYAATlOkGaPxT2MixsKJ6OQvMegai24iHXsy5GTQGahXPnmrYd1M8fQjHgdHTMhFxrG7+vNkDlmv1Ff
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>   			mmap_locked = false;
>   			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
> -							  cc);
> +							  NULL, cc);
>   			fput(file);
>   		} else {
>   			result = hpage_collapse_scan_pmd(mm, vma, addr,
> -							 &mmap_locked, cc);
> +							 &mmap_locked, NULL, cc);
>   		}
>   		if (!mmap_locked)
>   			*lock_dropped = true;

Seeing the "NULL" tells me that this patch does effectively nothing and 
should likely get squashed into #3 ?

-- 
Cheers

David

