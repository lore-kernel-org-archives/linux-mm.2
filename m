Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF8F1EA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28F296B0005; Thu,  9 Apr 2026 08:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240456B0088; Thu,  9 Apr 2026 08:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156716B008A; Thu,  9 Apr 2026 08:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 052866B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:36:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C104A13B946
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:36:10 +0000 (UTC)
X-FDA: 84638964900.13.1ECC405
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3CFB4180007
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:36:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hf2jBI9W;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775738167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVzSeg4rWq2dmbhr6nNYnEpDs4q8e0TGKGmrSP7c2OE=;
	b=heNfMlv51tY4Tef2GsBNagVsC7IgR4k2qsR3Y6udxQZ3xk3EIDs2oDoYZbjPiRB9WnsDq3
	1iAhADgv4bB98DVpe1N6jTHzXFM3f6iApg1J6eSjeuj5kDYI1BzT1YxjlOYzKI+RkZlRDs
	+hhoweZ18lwIKPnYGkYS9qHE4YWMVUs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hf2jBI9W;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775738167; a=rsa-sha256;
	cv=none;
	b=R9i1BS9wrEYW68PCMxnxZDP662ZIy/YesrOqUc7yrBD8k2QMbGS2fpuYZDjv4u/N1SAWkG
	vQa/HG/dBKHp6u+PYrVBc05CR/PwTOjdEsdvfkdNprTzgUyX9LKbvjqlLhqYxFRqlR18TG
	WuosAvxVPbMyCJV4n0BAoGHsz8ptqT0=
Message-ID: <9f01b396-4694-4ee5-a1e6-754f9399e950@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775738165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PVzSeg4rWq2dmbhr6nNYnEpDs4q8e0TGKGmrSP7c2OE=;
	b=hf2jBI9W5G3s/L8Jj3mb2/fXzZjw1eoDaa965a9mpfeSLy1kTQmQ67GZTAqL8wiGdFpf3Q
	PwJNGfqPlAqnLPsvj97mk0brQ9890xoaeRfZz45fmHtBng3UMYbVB8USfaRwWBvrcttNbr
	p0mjUEhNv8H3WIRxgK962wz69dhN0W4=
Date: Thu, 9 Apr 2026 20:35:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 00/10] mm: thp: always enable mTHP support
Content-Language: en-US
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, ziy@nvidia.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, npache@redhat.com, dev.jain@arm.com,
 baohua@kernel.org
References: <cover.1775679721.git.luizcap@redhat.com>
 <20260409082936.50302-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260409082936.50302-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3CFB4180007
X-Stat-Signature: rj89mtt3jqydtsd3wk5bogjm9tuyzu8w
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775738167-915329
X-HE-Meta: U2FsdGVkX19oMpYGf60QX4EEU2oaNPsIeyYHjnv6GBuVz8UYS+uvYY8X/kS4WvzXScomkNx9irU3AdoXGzqwuN5L95qcAyy2MyC6rVEoYIVeQOwiupj3+xYFnSSQx384InNgpaz+mC63MmWMUauCC+KuV8JsPjrbcpuGHBdOiXrOwCLyP1i/JQmFoYxQ59GS8pvplFaIYOSnF69y9xtfRcBeAORKVmpcNRO3/QsK2gbspXBv6Mv68HTMxgE2okbP38F2fvdZKfoq7CwvGt4YjS7cyxbTPtzDrt7UXMlvKplFYXZrALkecH4Smzz3UN29FPAiPGnx6I0pXFtRHh81Wyy9zRCH+5AqXMqoTG0SW0eRc2Nh1XEkMacce4MP+S2D7+VwtJQiCpHhroeUIUWAU9D0GrdXbziWqSrIzwlDCemt5sSxLWtrkr/HI9tGvpIx08V0D1sSiVsKH2JY7IOZncBFswlTWFNh9yPvSDRlQrYQV+Qccl5YuMW28M/5KaTwkxoAd1/RpXJoaufjC2GkfUKZ+OrLznVEMjdYYBaVunb4jjx3Vdmm2+YJzKeH9rQA0viGrNJW8d/qhrdAz41CQHKvibZgO/8GoD2HvYHJeMNihigpqABsDkV6y1B/9ozcyH7ipjGOkeYIiZOJCUUAknZDUOPeuI6skj7i6sH4IFcJzcaJ8snq/MjS1DSOXO0KZ5/8dXjtsa43l7/g1qtp5EDV5qAujZpjDiKhxz1Q9a01psTqubwDi9gNoclZKHUeTJBwFCR5V0/ZXu4qiUhyqcMTqHI9oKsYyRfvL0tWsTVUXI16YBw7V9epcRTsf327iyeT+f7DIDugrCl1Simz6dFxzeW4XHaFs/gU/P18YCbIygaTSxQNbxgFRwx4nO0uW/uZHonN+prkWIjebzr5Yx49DCQogdjpbZ3WXzPdUVT8UMJdE+31vSGGQwFwRmph4W/ZzLVastM7osogEqY
 LfxqeWbF
 c3nl5ebo+RoUmTvNO4lhl+nkwAZBxAKZKzUBHl1udIqo0QnqR3Z2ZEcoA/7GXnqSgOpGVdUxY7m8Zo9s3fTjWbsbXRf8lFpDIxHvJdKhE7h9ZP9mrZPFrTr/CUpYaqUxbiTwvOWN2eCOMXe0mFMMbnmxv7AbAcQy1j4r1ouRdk2TLUgB+93i0lNx4USp9GdVYvKb0A0IReyltMQdXNdHwz2fJeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/9 16:29, Lance Yang wrote:
> +Cc THP
> 
> Some folks seem to be missing from CC for this series. Please run
> scripts/get_maintainer.pl; it's your friend :)

Ouch... just realized I missed one more. +Cc Barry.

