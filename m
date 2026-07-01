Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21186C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 20:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93B96B00A8; Wed,  1 Jul 2026 16:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B2F6B00A9; Wed,  1 Jul 2026 16:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CD86B00AB; Wed,  1 Jul 2026 16:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF9E06B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:03:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F6B3C257F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:03:33 +0000 (UTC)
X-FDA: 84941282706.07.5E9974F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8B06912000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:03:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=imHR64ns;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782936211;
	b=VUs+8A5VpeObYNmsNj95X6aD/8jl7aSQae/DWmq/mApQzMpuKt8dyYV1W/ceBhsGEv7WVx
	CTfVYTQZo9yPgVwBn0zgWk8CqPCY3n1VkmpKUtC/ww0QNHJQi+BdLJ5Z+N+HKew8Cw8Zez
	4wtdnWOf4EX+Y2frLVBqFJtom9SjJ2s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782936211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6zp09cAbru0LBE7s3fcZYa3/iefpTqvsPd295TfbYY4=;
	b=A4eFuOjChWyLeZsOpB3mFzzxZ9DrVHW8LRXVULubAJOvhr2K+HHY6Bbb6yyFK4nNB+km4o
	/1Swx56rJAb2m5xvd/GvkJcMsiaSvkuvyj1tLGNmvXCw1Kk/WK4+LOI2h1r3jJMy4262f9
	2GoUBGq/FYrRu1xnNaMtdkTNcBMPIpU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=imHR64ns;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6F786001D;
	Wed,  1 Jul 2026 20:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317411F000E9;
	Wed,  1 Jul 2026 20:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782936210;
	bh=6zp09cAbru0LBE7s3fcZYa3/iefpTqvsPd295TfbYY4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=imHR64nsQ4Ic2E8LNQelQ0fnWppOOkbDz2FDT1MGXSEFI62xLOIFofiq4Zi+6t3Jh
	 Ak7f2+aOZEavQ9BGLAlkbg4L+LEdVbi44UvEN2sgsxd7UvgzYdUvGQTFPFLOnGfG9n
	 SPgazdzQLgJjqgk0ZOcZMuYKKCGBQNw6mcTehwnxQfHT/1ZTdeMZEbx49JvAWtSMab
	 EW/IO5o6eEWhy7yfbhQui8vBWpKCe4Ed19q1QFWEOZxG25daIQDbTQEQCJXsbEUSdo
	 GaxQ9aJnijUNz0PHGIqqb6CP6+jomvwsj91xIJoGWt1WyvN2V9stEJqKra2S13zEon
	 +h2ZeGZ3DGxWQ==
Message-ID: <e37df165-8de0-4924-ba19-0d43a6b7d36e@kernel.org>
Date: Wed, 1 Jul 2026 22:03:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mm: rename ARCH_ENABLE_THP_MIGRATION to
 ARCH_SUPPORTS_PMD_SOFTLEAF
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630164143.1595669-7-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630164143.1595669-7-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zo7risz6byqrrny13ntuy96njacp1nq5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8B06912000E
X-HE-Tag: 1782936211-827852
X-HE-Meta: U2FsdGVkX1/atOUIeIPwCqfwyE8JEWbUDjIWspjScvFJaknzwPdCpPwm3Ygx0H7c6BfcOwFquKhGlqnA4COSZSOCayQw6aM7EhGPV/+nQKiWafU87yf4WMd4+DYyf+tCO69z2tW+VAI6crvICmzsNYIQsFxidvHl5YDeoVmKazE+NJncq/oSnGjfyb6ZyQXLIHNtW5zy+foAe/fcWn3/cfpMQeuT/+t9QruXBVfaA7rTYSrWQpqSDMipjwFwhLXmLj+JWVG3eEmU+SwxSeqt3skl3Q4XtdolauaWTHjHpjRavohgapEV+S/Bu60sAXGpSbzJ6AiD9C+/f6vc4HloGmlFtuVNQWUrGelH3X82dtbZ8Xu6efKMepnXxPw2kOPGWe0qqCJCio/RJZxBKScCSmszfRFV2hVIJxByPhEIyo4EEgNQKGZ8X1wxN7CgzLuquWFaztpZRWqGznlpAZ1mz10jRH3QKBHWpaih7txL7C//jIbOJ4yyjCjDcwez+VB3pR2QRyOmwK2/ccssVEY6+4FZ6d+Hq2TBHpYPCaGMsA4ldt0IVMtY3nDRRzBEf7zHyKfkWIuziFA2t0276M0gED4GW4MbQjfcSfk9px0yjGeQTSCMK2Tq3fgMAzm2CtfpL5ckrgWYZkBNv13EnRwlCHCe2TFba91fxtc+kwy0Dt8KETuzG3tJp5ngiuKmVgD2w1K5iTBLBdlpFEFUNuOF0xNgzO6dlGu+ycAYhCHdmYVc8dBWQhHBFrbMs11hR3kEsnJg031euYiFqIb9S7/Ku7wMo2JdM3859QooiU3/HKv+TCcOd9c8gxSUFmNxGt5mCefaQ0YnCSiQ3UCsLXR8Pr1zfEUyCHwrNH7RbSvVaXgB2iusuPF6p3HgKdwq13JpXISHRbqZH3QoJwluMnCOL6CgsvDQu77sex9HqE9wLEBywdUmhrLnJKjByS/BawnPz6FOI0j3N6j4CY91weG
 wd3gDIUU
 rQXm3AJhKqSoWBFi/62knwXwAjrVlMhKjeYSyZWgF9bwbS5FYtXLO4VH70DHYzzErOIMvPKFi08pYR6Rrg43usWGPcvloDwIGrQ4XavKI+8BUtmSNwO/IEDVlXEXvYp1twapNyDAn1PjGeKvA3ncNDc7o1EF8Z9qCK9NH8MdkzJVmHg3mFXrilqqYT04jfukidRA+R7j7Je3g9naCglLo6jnp+h1L/sVjTkqej/rpLiMfnIhgozkbB9t3PfbGknfwDQqoUIyIpumxUP7arURZcyGXG3sYr5UaedkKExkSuF9GeLbWnyGs2ipY/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 18:34, Usama Arif wrote:
> CONFIG_ARCH_ENABLE_THP_MIGRATION started life gating just PMD-level
> migration entries, but has grown to gate the entire PMD-level softleaf
> machinery: migration entries, device-private entries, and soon swap
> entries.

device-private really relies on migration support.

See do_huge_pmd_device_private() where we migrate back to CPU memory.

The whole concept is pased on migration. So that's why it currently makes sense.

So "has grown to" is not quite accurate. It's a different story with swap
entries (that can exist even without migration support).


> Rename CONFIG_ARCH_ENABLE_THP_MIGRATION to CONFIG_ARCH_SUPPORTS_PMD
> _SOFTLEAF to make this clear.  This is a pure rename: the set of
> selecting architectures (x86, arm64, s390, riscv, loongarch, and
> powerpc on PPC_BOOK3S_64) and the gating semantics are unchanged.

Hm, that makes me wonder what it would take to make this all just be implicitly
supported by CONFIG_TRANSPARENT_HUGEPAGE.

Looks like someone would have the courage to touch stuff like arc, mips and
sparc64 (+arm and x86, but that's less of a concern :) ).

So yeah, renaming the config option makes sense. The config space is the wild west.

We have

	PGTABLE_HAS_HUGE_LEAVES

and stuff like

	HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
	HAVE_ARCH_SOFT_DIRTY
	ARCH_HAS_GIGANTIC_PAGE
	ARCH_HAS_PTE_SPECIAL

We do have a limited number of "SUPPORTS" (which is longer than HAS), but I
would either use


	ARCH_HAS_PMD_SOFTLEAVES

or

	HAVE_ARCH_PMD_SOFTLEAVES


Apart from that LGTM.

-- 
Cheers,

David

