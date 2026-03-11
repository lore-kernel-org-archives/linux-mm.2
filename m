Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6C51062884
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 12:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E985A6B0005; Wed, 11 Mar 2026 08:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1BD46B0089; Wed, 11 Mar 2026 08:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27706B008A; Wed, 11 Mar 2026 08:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A89896B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:21:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 351961C013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:21:12 +0000 (UTC)
X-FDA: 84533691984.05.319B392
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf08.hostedemail.com (Postfix) with ESMTP id F2256160005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:21:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YgE9Egj1;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773231670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ee/r1vRJT9+5mrJU24WjXO3pAsTS+UTnfUyMaErY2pA=;
	b=p+Yvy5uR9cd6mpCpde0FLzykqGjmgqN6S18exsYmHQSQ5ZwtVXVpL6xTJJ1t8T1UKXC82x
	mpC0ejbIuk+unue0z6d7kx3MeMUvYhTPOwfAYJ4+Ecr5UwDKsVZDB4vvphOy4kNZTSlxnp
	Y8c/2QtHOKxZzGTr1pxt12U7EwXSObs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773231670; a=rsa-sha256;
	cv=none;
	b=GZHmZ+6u5eGskHz5yl1oZMZoz5WP4YkAdhTso5Ps23ltquGYh19Jn1fNG5fmC4rpcejC4R
	PNz+FTKMHMd9EyyGg7FokVuS/T8Bsi6GfUJXbV8U7Vgv+wi6GuQvOGrlWEkHOliKIcYd4m
	xJj+AZmqwX8otGrzEZc7kYnR2xAKu60=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YgE9Egj1;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <9d65fd6b-74a1-46ea-b6f8-20d17c5ddc68@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773231666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ee/r1vRJT9+5mrJU24WjXO3pAsTS+UTnfUyMaErY2pA=;
	b=YgE9Egj1HJYxtbIDkkh04xxk1q4I93281lGhh41lGiLT9HrHb1uWRdN9cz1G6xz3DtwzHk
	726JNfDtkVPR0NoJJDaACGTsMmj45+lAzxuyV8fqZN13tpK5qJwC2PSFT1BoE+msU9TZ5R
	jiRNTryf2gaVMsTxuo2kZ5qkXiZFzh8=
Date: Wed, 11 Mar 2026 20:20:54 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>,
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Nico Pache <npache@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: oeowkctmheq8joatcmur3c8kx17fxosz
X-Rspamd-Queue-Id: F2256160005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773231669-904460
X-HE-Meta: U2FsdGVkX1+vcxtONm+0kzOLKSXmRHjdxjRH9zYOWqDT1Xo5DUyIJsFY0RBn01hBAimonaaaua5P24ckg2E+4kOpmS0LCloOO84gcPV6Yyite3o0g8xpDRFoEag6ZfTzyAKj8vhWMW9O5B6GBCvYYmej4vN8DoERR3oHUiCT4gR7ah9jyPMKCwGE/7qhgppwxUa/q0gwHCO2UnuyMOsW2r/FfhpLdae1sM2ffRURrZ538hnizDiFVSFfNPyOClAHffG/jZeK1Ye27F9l3VuJZbgo2PwT6mvSnAbjlj+a/pwSm0wTJm08tkazp34h9U5Qujr4ZDUJfHcsKw4DaAJmj11CTd0n0dDYHEgJp/nbSyWXc0EFcAfUuXfpkNTrMt43/kiTdGjT0UheqX/2vDO6F350ETpdcVSG74UTUa+YrrWM/ggd9AAJ/AydTgRHlQS83zEV8piPZNO+q1afsoHMGQ/0TEkz1+YXfkSUHE6rbRHn+hF/26nvwT22pcmQl+eJ178D4XfP6PmepI8XA9dPR3go1piQ9bCJuejLAzE0D+hslB+L0OGvm4WfCHIMqUHEUAbYxzkz5Z1QYRMLsSoaIItdkaCWsyC90zrkuAoKOHRXh/LriIHYMOFREDsPMR7GR25nVH7qsFjKpKCdI6DNmIo1wQ0gN6wZqeN7bV113+YN5EFp74hkaFZgxohchJgcr8cgXAvXdFNVPei+UYk0V22hI7HAxwCCm9B1ghoczM3vtVcwcf3sn/q1yIqO6dgF+bjtChOT5MK8RAj+hy2uWhfMAOqb7Txj0+q/vZhY8ncokGZhyRG42xmoZH9qfhrBIkfFdK3ZKGBpqDTwbDpF87RqCA9g7HOb7n5RpKdq/hwzileulALxJVn9xoRZg7H37iBkexKwTLs08Txy3xMqHJugjkILBbrWClCdSd1LAKpvwdDn5pNpxUdPkNRHyozQydHVCOHVzb3u0Iw/z4a
 O1IxP7Pk
 yfc6oLgYf7gzMLeoASfE9vU5WdU+K6GkfWXQSdxVkhDs6hi4szHfQ29Bbdi991fua4AHUig9hyvKRdAu9WBrFwOgdEBGb43ieK5kH8fMgANjrjpR9dHM8RvEe8WRvnZDagx5fnPZmQFM60T+4LR/9TGVlT+c8AAeNbstNvInvK1A9Ap9KHkRKemDL2lyHHMIJrmwgvAydnBtDqg+qmltvJ2tOd+2Guj2PKmXE94klsGcUwEmVXbs/7RS+LwvIR8oV0vaa6aLKloBcyBr0swCnBbxzqEgPJYKDtROpdaCOYe0JBKDcb1wyblyZ7iztFSW0QWYI0HBW7KgtgBRL8Az+te5bRRywR/NqWPiSMeiAunNTBbsa+FFlw/m7V7KI07dLYW9yGcrE5D/Lf1FgfQ3FYe1urHmJB0ciZz6Y6ljQ1MKnM3WsvaHd7CYyWKbnID06EinJjBqYMSPVOF/Y4J/ZDpqUYekfcwfay4W5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/11 18:17, Breno Leitao wrote:
> Refactor enabled_store() to use a new change_enabled() helper.
> Introduce a separate enum global_enabled_mode and
> global_enabled_mode_strings[], mirroring the anon_enabled_mode
> pattern from the previous commit.
> 
> A separate enum is necessary because the global THP setting does
> not support "inherit", only "always", "madvise", and "never".
> Reusing anon_enabled_mode would leave a NULL gap in the string
> array, causing sysfs_match_string() to stop early and fail to
> match entries after the gap.
> 
> The helper uses the same loop pattern as set_anon_enabled_mode(),
> iterating over an array of flag bit positions and using
> __test_and_set_bit()/__test_and_clear_bit() to track whether the state
> actually changed.
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Thanks!

Tested-by: Lance Yang <lance.yang@linux.dev>

