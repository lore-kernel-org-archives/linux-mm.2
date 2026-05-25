Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10EEDCD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4249B6B008C; Mon, 25 May 2026 04:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4A06B0093; Mon, 25 May 2026 04:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C40A6B0095; Mon, 25 May 2026 04:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1403C6B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:38:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BCE6E16160E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:38:25 +0000 (UTC)
X-FDA: 84805290570.16.50D2691
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id C71641A0003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:38:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bzg8SRi4;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698303; a=rsa-sha256;
	cv=none;
	b=qq1Sz/NNnPyJXSNVbrWoQltSzFwO1sznfG4QBbfI6NaJSlp7Ff+hUnS1YNkI3/nD8jXf1b
	KVCyqPBcF5KYUYvvbbJC57QMDtXAKWGbH8lBpCRjHRuVLaPVFnwe8gjwBsf3eiNpsNw5Rs
	4iQ3FsxNjwoJUI5B2udcPtf6BN0Hoto=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bzg8SRi4;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2BfGMNpnuMvRedYniqJxkS9nB2bZeh7imXHczGNU4Q=;
	b=5ytZk3GT5hSstL3wBLUce7ooCme0F83kx0724j1ab4yd7Jhwa+FdP1sOYlAR148QW/+EJ6
	jmVyjCzOUYHDdH2yk0R6ZE3twMk8+WLePgphb7QH0a74asnM8mfMg6HUe0Y6U7Ackoiqd3
	Pf35t410h98ki8wdaFAzQVqCUdmTmtM=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48fde2f2d61so13719435e9.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 01:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779698302; x=1780303102; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A2BfGMNpnuMvRedYniqJxkS9nB2bZeh7imXHczGNU4Q=;
        b=bzg8SRi4eIx5zBYOXGsJDEtIgyl55B18pPOVSjZZ/TzyrCjg/94Va9GBIpZ3FSDADV
         ogmteKzdHN8k5iAFj1VO7rjT8LwEhnLe3w6j068GFshVo/vBAJavItwAPyxw9DcIkhpq
         KTWtpv93/oK/hW0v6YN4Bp177dqdKVn7i691vXJTlguRIjJ9MbGL6LfHWabz/aWYweRA
         5a4MditIlEMC5aZgZiFLy8wXwwLysgv/hK87twUq2CFror9xUFVxXfRtZyQOTvlUTv7g
         DGJlbeASJjMV/ggcwmx2jeAGxxsrYJwwHDepYY0iGrzsYT20OfmyVHje5AT3P7MbjnHz
         Gjqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698302; x=1780303102;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2BfGMNpnuMvRedYniqJxkS9nB2bZeh7imXHczGNU4Q=;
        b=RtefeQaD/sR5iKoM0v8ffrnQabAvGqFz5ZO28xRlg48Gg6vZq3ce/O0aIhjHIPxXzj
         0TNWak82Yvc7FrlzIVI+KJJPWcRqX+QXfeqT4sNbuzLDqeXTL1Pes/YJKGlSMpOn756R
         r6ilWT2H0NolAWnrkVo/F5Xs8E7chhQLI0vq22ZkQUSyDsizvXp2BPXVY5i9YZasP4ca
         aIfcqFjqlTlG+tYWyIOY3D1wOvOUJ/f6u/XLZ5JdgUE318F4OFZotKUJeeqFmnbsG+fh
         WQX+tvMQA/jdXFDDH0adnF3FSMfZMtbyTh/QXIQ/mMJbVB6bSsSuowEtMG6YEgsI4W17
         JjNA==
X-Gm-Message-State: AOJu0Yz2pLBqfo9/nG0xgPUwA6dWJTX38uvRJIlfhSslKYO1x1e5KOsy
	qYi/R2jv2U+0ePCV8G+MajiF88VknZpzbwEFm037dORNHlOc5ZBsah89WLWw1I3q3Pc=
X-Gm-Gg: Acq92OGO2HeXmqVru1cuxwZpT+i1vUTFRJNyaon18oc5cSGzkeQt7zU6i92MVQaK+au
	qZi1yC+CwtAjXQdfm4P9jvsD1opW/ZHGffc6urd329l9sfJuBZUaJNNT/pesFZngqOtWi/r2YnH
	8Q2wseOPj+nDROLvo89nJvvRMfBcBkc6CucXxe9M0qdeDgDbR3yMDHxUf1FCgIEQTrPX0nRxYxS
	uTfYWNlefqJvwrXBvbsSdoZq826P38yb7r7V5HOSSfbNIpD0D6yN+1EluI/UdRDTSTqRKEiKxBd
	LQfxhtEOkqjOSw4DxqGqQotLfcyn4YZ+ADZpQjl4yB/2u9mqB0eT9uYJ36isdjjqSU6z3MhaaPm
	gKPhYRpTqwChCUSHrx6vyZ4PySKMQH8te2KD1vGxF+2UskasE4plwiwDZyHgZJzm8qQFLLP055p
	FY//i8qlGkQL/6vJ+xmZ0lTboys1E7+4oJUOQndxo6ny64MRLJ/ih0/bA04w==
X-Received: by 2002:a05:600c:35cf:b0:488:7e7b:dbc2 with SMTP id 5b1f17b1804b1-490426bb7f1mr124097125e9.3.1779698302250;
        Mon, 25 May 2026 01:38:22 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454a0cd5sm290509295e9.10.2026.05.25.01.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 01:38:21 -0700 (PDT)
Message-ID: <bc96e4ee-faac-4bed-ac3d-54f1003be62d@suse.com>
Date: Mon, 25 May 2026 10:38:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Cleanup and fix tools/mm/slabinfo utility
Content-Language: en-US
To: Xuewen Wang <wangxuewen@kylinos.cn>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
References: <20260518062159.80664-1-wangxuewen@kylinos.cn>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260518062159.80664-1-wangxuewen@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C71641A0003
X-Rspamd-Server: rspam03
X-Stat-Signature: 68coiobskbkr8km87c767cayfueri4o3
X-HE-Tag: 1779698303-932282
X-HE-Meta: U2FsdGVkX1/04p2Ru7QDLQNs/2Llvle8XV4FODZncRgYqeV3qaRBaZAET/ACPrrm5YMWeBdHQarXxTR7yOiT/omPYLSksO7gUt3PdNxuaePE9WrANqgS95WAF3b06mNw0H4AvtqS9EVc1NeSZ/bSonnIufU6ADFW7HLjuIbPcoGiUJpvGNTJ2g6JRbJQ8au0cqfzZjdyV8At07/39AKQuD9e2XpRxdw6R+3Jo5pjeihdcL5rVf9z6+zsahRUOaLrPQO03aIoWaS6TZ/IsFH/odCRfQ9kwdjavJTweHIUNYM49Bw0MuHHKJhfShKHSNpCls8PPXMHB1GGaq8sywaPX5ZwwuRH3IXkQCU4H8vA7hgLfWCzpSRPfJK9BM21reHCRoOb5SpMWeQkzJu8TXc9xJfN2s+zk6DAGgtMzvN4n6Hapvy4slwvZGRl7+gNldJ7GQSdYFdvCdo9Fl0OAYIGvbnVFUGyUaT7ck5BQhqSNaqyorPVdu44//PmKWEA+V4B0SsEWLeQ4jO4KL0H/5qZX7La8jwPb/L7fZ7iIEpGar4/ANYA+PUdU3vxRk3E92cE5qzLBrCvdqWZ9NCqXWRkvDonDlBZ15Zcj+hHIHECTEtYyFjmBG2/9tuDNOsJj6XSeMZfrwNb9zvsakJ/9Z1Bd3rZYxvhIW0cCGi1KvCryTxo2tN+qhA7MGCrSg7F36ojRDbTgkwmZwnNVCDDlCytXcU32Vkq1UabGT75qX5Gb7ntmbppRjxk9BzO1pkDodExKnmk9w+pXB4crzbizK73/gkFzBUao5ommJL5c1/XTtEFH7U3sJEI12WCF+ufV6e9VCwt3BE05QQS+HegdNal3YsaOGit+sgI4Sfb/PIVsjHueTyWjerCoMdFWBvvpL1D/ih3Quhgi7rvqDburLdKG5VAoi8rJTDyCVtS1KEel8JCLkRR+KQISMfZFHe2uao7ozIuoSPkvOHcmSCX+dy
 wHMbWXFF
 B7Jn3gA5PNqzokW4EJsSijFspelmaMFAv3CiK01nW6k+0FH5T3iuQSyKo+cBtV6lr5n3fptu2BT7cSNbZ7t9GYZY830KT2MjCe4qbk/75dkE9rsXtvpulDylWvJf+3W2CRebaEH3zS4dMJA5vA2usDYr48NPoQkVgyRtx7hhl9Cc3Gyl7VY/xPiJrq6ZvdvZuiu5zSKiX+ahemTFOd33F9dEdQaLaJiAEfsIGCpw6bqxsitDWyaTMkAwHNZl2rOdUS2+5sjRFedDHX/K3WFeozpIQjFufPzMMg5P1c+RjOtWkmFRnVYPsOec/JhA8yRaKxJt1mAOSJ0XTqnh005NJOwHgBFzmnmcwE3Z1N3bVxbnW1Af3pBLMg9Vf+kID6mgpxk+DjyET7YGOEOzZN0s8y1j3fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 08:21, Xuewen Wang wrote:
> This series fixes one bug and cleans up two code quality issues in tools/mm/slabinfo:
> 
> 1. Fix trace disable logic inversion: when the user intends to disable
>    tracing (!tracing) and it is currently enabled (s->trace),
>    set_obj() was called with 1 instead of 0, which is opposite to
>    the intended behavior. All other options (sanity_checks, red_zone,
>    poison, store_user) in the same function use 0 for the disable
>    case.
> 
> 2. Remove dead assignment in get_obj_and_str(): `x = NULL` sets the
>    local parameter variable instead of `*x`, which is a no-op since
>    `*x` was already set to NULL on the line above.
> 
> 3. Remove redundant slab->partial assignment in read_slab_dir():
>    slab->partial is assigned by get_obj("partial") and then
>    immediately overwritten by get_obj_and_str("partial", &t).
> 
> Xuewen Wang (3):
>   tools/mm/slabinfo: Fix trace disable logic inversion
>   tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
>   tools/mm/slabinfo: remove redundant slab->partial assignment
> 
>  tools/mm/slabinfo.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Thanks, applied to slab/for-next

> 
> ---
> Changes in v2:
> - Fix author email mismatch
> - Add Fixes tag for the bug fix (patch 1)
> - Remove unnecessary braces in patch 2 per reviewer suggestion
> 
> Patches 1/3 and 3/3 carry Reviewed-by tag from SeongJae Park.
> 
> v1:
>     https://lore.kernel.org/all/20260515065325.4009527-1-18810879172@163.com/
> 


