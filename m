Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C826ACFD315
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 01:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E52D6B00A7; Sat, 22 Nov 2025 20:53:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC726B00AC; Sat, 22 Nov 2025 20:53:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D23E6B00B4; Sat, 22 Nov 2025 20:53:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0686B00A7
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 20:53:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 946788A55B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:53:22 +0000 (UTC)
X-FDA: 84140199444.25.1032EEE
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8E897180008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:53:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MqhGvEEn;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763862800;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61f1zN5+IdmGzSxmoozO60LTdckIHSp2dJdbkwe3278=;
	b=D7nIeVB1rMDx45KErpaDeqOAJ7wc77X4s9yx8RvBDThH1ZKfJCCYfY1PZjwr+ZPfLs5Ddw
	nG4lfETLVfBlD4HqUu4WaC9YClHf698brV4ocZSX6izD8DVulW5rHPsHcFLnE4H+sYFDWL
	f4UrSG1fgxxdmTFgwkdc7E0UiZbMGtA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MqhGvEEn;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763862800; a=rsa-sha256;
	cv=none;
	b=hwvsGpZh9PGZZcMvfSBJiDk+b7DGbEjNjWLmH9XjQSq9W5A2KZd0QozqldiU2eV7cBkg7C
	2AxGm3T/9qNUpVZMuJAUF7q78fxJeHMNaz6eiJ2zHklvRBbB3h0+KmHB1bwEatsyJDwgEs
	R/7oXiE3CcSifgDgCihnLzah43Fuf6s=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b73875aa527so505190866b.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763862799; x=1764467599; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61f1zN5+IdmGzSxmoozO60LTdckIHSp2dJdbkwe3278=;
        b=MqhGvEEnGsmNuxS9TZ0VN2DyoLi9P5yqChfAOArglQ/D0nF4n9VR2K8Wzx/wvUu4zW
         TWpVqQxlC3JIlFXdU2NsfdOl0vz1DhsAXvtpliRtrWmlS/UK3wsP2Kp6TLbLIoe+sL2Y
         MdrPbWVbfGTnoKJcScYe4eemuTk8Em0Y/RdYrF59zQ+bWiTGsqre+j8tqvd9KmTQO8PW
         sfAX+bhzHt76VpC+hHPn9CgCZ9n6bwN57x78C+8SmPQSEQXRK04EZZj39+J3snr2j1VS
         0Xi/2iJrPLMtTHg+V3jmH7gxLhGuEsGveWsN2CFcK641sgBmvbE69fs97ZMi05MLA1XU
         iVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763862799; x=1764467599;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=61f1zN5+IdmGzSxmoozO60LTdckIHSp2dJdbkwe3278=;
        b=sbLnLk5Vcz4Ecgnxz/oONNKrcOZbh5OfujyDEpsxKkN/cXvfO83IqRG4HL9DrWELhv
         OzEszkeqFr56ksAGqBuOuuoD69AFlyMa3D3ZwQl6RMxFw2rPpfZHc8rJStU6ZgZvFH5o
         8Gi+9+F8UDgCHP4VnmnMQbsxxSuhNtrQc0BoVSa3jvbXJXRi1PBSI1kTzoNhAuB2Hf1e
         jXlUaOltviI/M5iRWEhfjZ7LpW6XxtMIWmZ/VmKySrUvdvpHlwlxYd+imY8VCM0f+BoV
         ysEKRV4su8Atzg38XhMkusOmbImYfN9koL01wx0P3NNIsMSRSEdLqcxwQI5mOz8sxEgY
         kEiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpFmgjZWzuQ10LpEAwohvpbGpZZg94T5wRu+n7Qj30lQ7eZ2V0OydcouhSUfPdGIo/Vh6MyWbhUw==@kvack.org
X-Gm-Message-State: AOJu0Yx1tgRmbnJh/xyTyqJZQvFfunK2iCO0Z4MD9C+B+egZfGEaBrT9
	FNrPIrl/CU3ns1jEvJdNlymfKTsyHd0+9GkYxvXTYAeI08RJRfz6L8xE
X-Gm-Gg: ASbGncs6JtoQjKpmvFMsnZh9DPHoddLbePmWqaOWz4IT9JS0/ldC3zz+xXNxDaQ7xSA
	Rh/wnf7QkKMv/a+2tAeoln3sK8RpJQQKtgkaZ78pTfWoVXxZfrcpvZuKE3OlgYMUGMNgncq7Cu5
	LDNUXxIuYNh5XcfvsxJBjez5dayPp4HbVOWgYbml+PLkGQSqZTYSyz2rSIeUYaarTVuS4nxpFUK
	x9FHb82stQDGnuw31X0LrTLY3thULlJ8rdqaQJjyLtq3A5Q9ut1QI+5bM2tC9VE428RMbJWlqfR
	LIQ/kXgu5U2HTo+RuJKoOwoJ0ws3pMxnLyMgpVIb3wn4uOzYVonw4bJ8rbxCDVtFSfSrnCy7n79
	HTfdOPFbuEhJm8wOTrjuk7vcDFm9cdnVGFvUBJlB9QM2S76RLEv2sFE6AeMDjuzzWZlc9El6WYi
	zIRNKqP0itqZB1vw==
X-Google-Smtp-Source: AGHT+IGgteEPtCFCVDHZnVsW65MCuOfGB9JQX9QyVGHeZGsz1UpMiB2lrj254YidAvxOylkmpxiJ1w==
X-Received: by 2002:a17:907:7287:b0:b73:8cea:62bb with SMTP id a640c23a62f3a-b767170cceamr817025266b.31.1763862798912;
        Sat, 22 Nov 2025 17:53:18 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdd659sm881230066b.7.2025.11.22.17.53.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 22 Nov 2025 17:53:18 -0800 (PST)
Date: Sun, 23 Nov 2025 01:53:17 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm/huge_memory: make min_order_for_split() always
 return an order
Message-ID: <20251123015317.3pommq5h54xnau7e@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-4-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122025529.1562592-4-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8E897180008
X-Stat-Signature: md5j5cyztkm1b7xhwi93b97j6gf6g7cq
X-Rspam-User: 
X-HE-Tag: 1763862800-87007
X-HE-Meta: U2FsdGVkX18isiPVE7+mb6fd/Y2qBMeHxEgl4jVHEr6+VSwWRwusykuSTZ4TU8kOQ1n/hSfcDDrcbyrty+EevW4IyjENncfYeWCteH5JHNsMHCSbkO2nLr+JTyx0UMwkjRxVPfcXsE0fL4/TdUC6DWK5vCdGqfgDlS39LEf/7XbKRSeP3nOr0dFc7NeVaSkz+6QUuz8UVVcSwrKipGxy2lwCE7gARyXvIV77rG/Gl/eGVrWUUT30oCtvECmMsSmmbLtsbJoAtuR9gyhJwSHUTRC7Fp/KP3Aa7wRubTGGYIcI0bY7Y04TKVLtWITVNevODi0zBp4q/gCuUVrSpga+nDknxAKecIDGXEubhdH/cfHw+XbTIRYRa3ivDjXAL5rlNwJtDH9GlvtSEmfpc/kQ9XuTjcYeA/tPRvJ6agrsmeKsYDO3nnimRHYyW5M1dqIQvwB+SHNIr2b8FGmrZQ9cWiwFYSqduJkybsyKBommNXamDrwHJZmvN8K9ujfKpHwJNre+QdKbB9Ua4EPXCpSftePV6Yb5MYJRw9bn/XDnFLVpQmnG2HnNVQHGQvZNy2G+RY0qpcZQyxMA1FV6Ej7hWgGBVX7uUuFbaDXyHcxZ6vulA5EBHPSy89AzW8//yrErsXDSaNBjrWx6XX+KBO0gTfd12r5ujhSozIiXAp7GknUc0oZ/pr2GHoHhdQhu6DitpnTTwnF1PCPFTdOpuv2aqvDUJZDEpx5vcUbIcqB8rxFAOCMzYwjt+kmYZl02jSlQoOG0XV+UpmFjfozQSS92X0OXGlykYXrYAySybrBR8Iu8LLsuWae5W6l/T+JwOFSna5zJEp6rabQMyeQk8tnn9vA6GQKBSHYzxAgIDf0uMMBo8mdSxaHbtW4kgZrSTKWi41/0PQTPZDRRc1Pppzps3aklCPrtC74bUTK2KeFzK0fLdCN98aCeadZY1oFR6Q1fmTIGuLX2DAmhszjyyan
 XNsZWomt
 aQexAoBHes3uw71jAai9vp5nkC737lQIkc8+K7ppJFy5a+sBDAzX171NS2UBCZgeJku2mLxKEXevPL2clMgAmAWmUZvQw6lH3Wms/59wYATOiAiO7C6FmgIJJBZNtEIbi+ZWEA40FCiTgBx2VU1szK3xS+YkVkH7KfOp05jDzgFgDHQSzQpDVvCgxkQzqd8WqggUA1eqmxbUoCQZvH/db3PPrEvMNHk0z/AaBmTgkNxpmK8dsWkftF4RrmtmjHNKkIzqBPJtkl7oX87qEBtsVIVptXSyWnxcA0BDJMbo3T7Z9QjPPzuCZZjinz96CB7DCEYtLfP002NNtwNbIO84RKOMKp02FAhjzMxHAMDsdoX1DeNx9kIKCsT+APnChH4LllhqubW2zmyx1AVConaVhpc3dQDe0+coyT4Qv2sdw5SjxYTbcsOUFwWPbINeQGzIqGjMpoJCOY7KCho4ZkAl2HFA7Ln2ma3BIKsgN482SFKaiMTJZjIRZGuaTOJyWssMmnxb21r5oJuaVFeYW0vwfJboh4jtdzE8VtTW+wWFHkJq6+CJgdaSxg77r9cMf+NHWM7OnrggphrIRXvVXUTxBKbztPJDqpYnTfpSaSjcZISsC35L5IDs3RyLL7yfDdBt+9zA8biQgknZefBjo56TAswl8xdX2gET7aU/bS1Ukya8ZG10sU2Irrl/XMNZzco4Jytn0tSqAGIURxjPbrTUuKfYYxqxXVFcm8accMvb6Ed61t5T7sDB+pD718xcHwgRza3vdfV7cY7L4sEI/Z/wfqRiu1ViuAFwIolHXxJvnY2qTbxc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 09:55:28PM -0500, Zi Yan wrote:
>min_order_for_split() returns -EBUSY when the folio is truncated and cannot
>be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
>split_huge_page*() target order silently"), memory_failure() does not
>handle it and pass -EBUSY to try_to_split_thp_page() directly.
>try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
>new_order is unsigned int in __folio_split() and this large new_order is
>rejected as an invalid input. The code does not cause a bug.
>soft_offline_in_use_page() also uses min_order_for_split() but it always
>passes 0 as new_order for split.
>
>Fix it by making min_order_for_split() always return an order. When the
>given folio is truncated, namely folio->mapping == NULL, return 0 and let
>a subsequent split function handle the situation and return -EBUSY.
>
>Add kernel-doc to min_order_for_split() to clarify its use.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM, Thanks

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

