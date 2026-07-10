Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8F2C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D50A6B008A; Fri, 10 Jul 2026 12:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486376B008C; Fri, 10 Jul 2026 12:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375976B0092; Fri, 10 Jul 2026 12:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8F56B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:43:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C683C30AE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:43:15 +0000 (UTC)
X-FDA: 84973437150.01.354C0A2
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id A813740005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:43:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="lfvH/xIH";
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.45 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783701793;
	b=gUQZoYk3I2yEtaX6/nBm5H1WF+WR9Qf4gpdjRHI4NYniRlMKuuM6brQGOz9kcAPQvLlCUU
	pI4ZQRFY/koNODfoPzEfQBUOz9Tf4lwI1bQiWdh1l2CxxMGKCp8dKvpUqt2HFgWYEiopp/
	lDY4YaJqidddGyE9O/YcKEpyYC/TM/s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="lfvH/xIH";
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.45 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783701793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCrA5GvcNcomQ8YHAskvpnsx6mUAVwyB/JWdGkfbiJc=;
	b=P83bpLqB51/EeML7jihwpUAwMcJV4u0H/vYgCv1lCCn3yHlHQSIF2Oz5n6poDp7ns8uMdg
	nFvPNtBwUUa2VgtHjz5MlW5G2DF2h0Cq6w978oMlgHyrsSZI1vq3FIw/8s4uXgkpHtytZ1
	iKhylVPB1mtG7aSbQl3bOpy46GwjG7k=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8eeb4508f29so9057266d6.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783701793; x=1784306593; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cCrA5GvcNcomQ8YHAskvpnsx6mUAVwyB/JWdGkfbiJc=;
        b=lfvH/xIHyg9CtsHn9QBr6YFUs7XgEyYuIDtilYWbBGHTYr/rHA7ob+/2PX2/HD9tsS
         Aw9GQi3DG3Wr8sQVIC7UuEcxxBaK3KhrQXwIEqN5m8PSCw29zVisInWQ3PHPnw4dUkuY
         ywTHNZ8I+z6T6S9u/bAwMVpWFrmzXWiFx0l+dJV/G8ixNgvZmnPVQRlTkBHFVbm6rd1E
         KxS25RO0JTOub+JqRhPkXjW5cO896Kqx2lRq8YdsrrNAmL83p8MyQZt6ECUr/ST2wAO/
         DeEa+LYxtPrR4tiPcxEuxZlccDcfnATszHqygOvVWXuB54ydsT4jOwZ05O0F4mOa7k8C
         a8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701793; x=1784306593;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cCrA5GvcNcomQ8YHAskvpnsx6mUAVwyB/JWdGkfbiJc=;
        b=MCq1TNnQ9/LTT5B/pKLO7f0GNqAyoNWiZ0iqf8bRZK+D6wQl8lRIOVHFPQS9uBA31y
         UKDFtRrsxe5r63vm+/diP86Ze00VSum3laUfBrqkR1Ls9BsT1Bn7MBevCeJ/QkGgCXqf
         D82jrFE5EgUNJihK2y6Xe9EG0ISdLJdfd+vgzBZc+KB3z4UcSXGR8FdaZT32C9HHhdBy
         DXO7ZVqM9qKoMqAtMbIYj2BNAKWxdr2qLv5d9mT0vA7Qa8eZZ3dZRgzikTZFkf3sjZY+
         E3q5UMx5hZi6Tn5ixqWZA3+JABdG1RWjuG+8Gj2nUeEmBMTpMZRNUGERZI/y9ftmjzkM
         kkWA==
X-Forwarded-Encrypted: i=1; AHgh+RpdPrMO7HJzCu3CjEOVd3VTuJGJhN1yb36HqeEf6G3rIM/FWvVtuEapuulEu7P2QYa39HK646k7YQ==@kvack.org
X-Gm-Message-State: AOJu0YyqFuq44NKvEOxzw2MIyGW5PcNIVF8w2MzGc9ARgQRU4o9hBsVU
	0zLJ0T9QDkfwDLVlpzaiG4NDzaRbFrByjChbJuOV00YTpg/b/eaRKRRQSC+qLh2Ck5s=
X-Gm-Gg: AfdE7cnL9QTsfA+lCXeVCU0DlD7DZJ5kVndrbxy6iEccgxPjcE0Ou7mZN+F7hs3scFM
	LP1D6nvNZIw0B4vLJVD1vb6Q+SzdnHQbhUZLPxNi45FVhu1d1Yu1plBCH8TL0D2v9zBbWyB5oBg
	B5MO34Jx8EtQVhLxhmWEX/ndbyb/Nwwc2r6/Nl8f2iRLJjyTo9SHMdWEjAKTvtvKHIk0Bdxh6r6
	PgmDfukKl+QbGksVxT/Jny1nvqbwtyBpbwhB6BsahIqjdiHUYtRHaCQlyjc623bQj0gAKX6fC/3
	cR4qx/4iuGiTow+tgHiUwLrP76Rw9d0LpeTZUhsm9qik1b/eyJxZcHg+icpMQTmxOGT1hiquK1d
	faWMdf8DWoe714FlktkxPTAP35DG+8CSeet9+FYOtP0xC9nM/FLiI2h3fpA0D
X-Received: by 2002:a05:6214:43c8:b0:8f4:4d6:8adb with SMTP id 6a1803df08f44-8fec1d808a6mr146369176d6.22.1783701792723;
        Fri, 10 Jul 2026 09:43:12 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-900a7f8f5d6sm30725036d6.15.2026.07.10.09.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:43:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEJj-00000007Yof-1AFg;
	Fri, 10 Jul 2026 13:43:11 -0300
Date: Fri, 10 Jul 2026 13:43:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v7 6/8] RDMA/umem: Use hmm_range_fault_unlocked_timeout()
 for ODP faults
Message-ID: <20260710164311.GU118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345364975.660027.8790629832830633290.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345364975.660027.8790629832830633290.stgit@skinsburskii>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A813740005
X-Stat-Signature: 1w1a5irbfd9c8msdj4s4dadqpcnegwcw
X-HE-Tag: 1783701793-961796
X-HE-Meta: U2FsdGVkX19Zaq54wEOVo9fNEBhcsokpz+App6ddqwpsDoLLE8iIsBmXA4crnPle+7JTvlBD1Yoey49pm9A71450UeC2kq/uM+VzYerX+WiI324fZc93YTLy3vBP5c2iJcQ6wKMpcFlye+pxLNgPRo7pPEaITNVv1aZ+Nz/NBby7HsnxDM02ijZwIsXcPLjiJPDUb29dphJVOiz8mO2dQDBRymxkClK4cLwFQI7kxHiU0ptACEFZw0CBQbaSdmhORqskvt2hajmW6jKhDo/PgU92pjDUiP/W3ER8HNHAmSW3TXaofd7u2sH9sluIJitIPouHY6UNezLqoumMCd1RcL1arybQLriZ7zbCImbUAolVUokVlIk1Mz0E2kauzPjeltj325YAX/uL+gr3l1curD0wIhuWf/fDU6d0CtE6iMxaSn6P7tPYZAoAHRKJVos3mD6Wx80XiJPh/sVyvQGD6s0QocVCZgNJCjy8KKp5dl8GXZlIqhpxwGal14HDERgmtE4xRkqrxgl9LZQpxMWkMVW6GcfbGHFAOHKLDt5otTFvMZlskWvZwhmawCtTFRA6ZWoMGP/18blInmE4pdQsDWOGHTXntHI3pn0Fba6+JN8IBFNUqjZdSP+jmfZxtW4C2uXwEOcrplqyGuxJxY6su3tYhDDo77uKcNTSfaoNrQ3Hf7gQ2n9GIBXwyWLrKWcsF8Q9NdPgZT6Amjhxvwsarabdfn0XeKV9FnYqJr4Gk52cvj0Oc21KlpLj7K/AdPc4a9TncpY3RbaHCq8MwMJ3g5wgPopI1klSkPAPEJafy86MOn/GW0aXTjj9AzDAii9dZfpN5asy+mSTELOpMhgyXA+0VodmdHBUj4VvELJNSzbGxrPTcUZdiEavTQGEa3K2yU8RyXZ3XtpKICg4UXC2GIIek/ghVQMgnVTGd2gB6o5aRgec8v4enXE6ecO53qUAWHpr1V1o1Zjw6JyRHpc
 BEl6EEJ2
 bFrtGssM7Y3igWuYSSQs/72r3MvWBOpLRhVVBISyR/brM7TNo2gcRUeBWhDLx/ehBfzgLKdn00fcf91xq5s9iZf2RZsH8eYZR+zVDf0TZQ4F7N0IRdIbKKRtQw48S6JwwJlgBV4ucUzNcAGP2sZF5l6KRICePvy4ECA4AlPAZAJM/74g4H1uYqFwpdtY7xfa0qmNN8+YYfhM0qPU5oRJ5aFrqDFoDy7pwdyewebNrGoQzIpvBcoyejHjzuaolvh9IOZjhAIBEV09eT81/+29/4iQX+F6DluU0Y/F48uQPIdzfFWe8xe56A0GrCGN7rKJWruiKNOvst57v4xQamERyVWuu9Lv3JFjF/QdJCVthUhWkUoV1WooSsPDTkAPn0gdd8A7tvMMTHf0vbDDcUXPAmb5ljIMFgfQOvaBDPxKWVZNkvbHxyND7v9+z2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:47:29PM -0700, Stanislav Kinsburskii wrote:
> ib_umem_odp_map_dma_and_lock() takes mmap_read_lock() only around
> hmm_range_fault(), then retries -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT
> expires.
> 
> Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
> the mmap lock and refreshes range->notifier_seq for its internal retries.
> ODP keeps using HMM_RANGE_DEFAULT_TIMEOUT for each HMM fault attempt,
> while interval invalidation retries continue to be handled by the existing
> outer loop.
> 
> ODP still validates the interval notifier sequence while holding umem_mutex
> before DMA mapping pages.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  drivers/infiniband/core/umem_odp.c |   18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

