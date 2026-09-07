Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B75C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6BB6B008A; Mon,  7 Sep 2026 11:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467226B008C; Mon,  7 Sep 2026 11:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356A16B0092; Mon,  7 Sep 2026 11:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0859B6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:42:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B80A801B1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:42:21 +0000 (UTC)
X-FDA: 85187382882.09.FE9185D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E7E4A180006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:42:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P72Lc+Gp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788795739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=khvVj+XX/OG3UCUrUcO0F7VGVKQi2Jwd0FC7frDCC5E=;
	b=yINCsUQyFhDbTfApAtYxrvyAJWSXWZH+LmV1NYWZPs/4zQm3O51b4Onsnqy8+t9/Q9tkeL
	7X0xVPpcTh1Nel5/6yt0GghxCoS9zC4Tq+qlksofq/OUoPqFOmivrRjtQGSFDwO59/Peh0
	k0buP+kBSxsA1yLBVhKQ4l8kz8JMrQQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788795739;
	b=uL97OsJybdwSkSNTRHfW0JIh/cFzSYRE6g+S8zcJ3vMbM20qZkGFax8jL9jxKnNeNBbJsu
	F8qhmHanZKSqkclZnNXaTf49LXWaJVrlN4AB9FbYuQafnWTl1DHrr60kEmAqyM+8if+Gs0
	Cayr1QO/DolgqtL7+GmxSiccz6P1z+Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P72Lc+Gp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81D2E60AB5;
	Mon,  7 Sep 2026 15:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E985F1F00A3A;
	Mon,  7 Sep 2026 15:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788795739;
	bh=khvVj+XX/OG3UCUrUcO0F7VGVKQi2Jwd0FC7frDCC5E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P72Lc+Gpx5Rz3Z2oNW2bQ3V3jV6ta/7tW63kF3TL280HTWddbHCdtqTAhT4nGK9U4
	 pYJEjiP+K6gN1Rn9q2AIRnN04ktCIHB3gqMPoynLVzrNKv9yGTiIq0Nw4kltkHMasn
	 W/u9GyL2kmxNTRwy3ISlFgCj/CPvUyX98sr7qi3wdrBv0BTYiORsQjBU0UwMuYrlrP
	 K083Yw5U52cuuhyIePKNHX4yhFjtGe3rV13LyN0mToHfL9tI6nYuIpPsL/975bDTyq
	 0DrbZhYHSe+9mmZn0Pv/jPfkcBuYE2tYfRD2V1pHlZsQnducYmncL1eFjt8GObOEgX
	 uKMdRwpBat5MQ==
Message-ID: <6eb272c0-0cfa-4354-a92b-4fc270e3b1fc@kernel.org>
Date: Mon, 7 Sep 2026 17:42:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page-flags: Define HWPoison test-and-change
 helpers unconditionally
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-2-kaitao.cheng@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903053535.17611-2-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7E4A180006
X-Stat-Signature: 14fs4ru474ak3jhzi15b6sjwq4kjqhap
X-Rspam-User: 
X-HE-Tag: 1788795739-768954
X-HE-Meta: U2FsdGVkX198T95e6VyhQoxSEcfuJzY3Boa1RG8J81vV7mUQ1+PdZ5IJIURchBp8rb+WhAAz0f2SbCR4NHPamPpCt73XAlPTOTy4L1Q+h7d8ANXsq8kR+RNWkcj7A+ShuYgpJyRyXEqNXbOfQ9QdtYbqFnrftWnLodMhfvurBPnr8/3DMcROJ4CGKN4Xjtw1B3yKitKpqBWa+NIKErGj8SbD8WnSMDNx9jzi0LdGBlMUFwSg0fG/NKN0P3qNM76ffD2cJx0tOKXG5C4zVuERrc8csufo5+mLESGokKhn0g+yg2s/dX9OkN+eo58zg5WvyVS5wc4Lfz4Fm6/AGEZ8QXqmgsraV1zwz7aJJ84R7RbtjNKJxo3SUK/G3gfQXT3KN+ugX44mz2KIWuFFdEKw8zi+DNdTN5hyniCsZkzHxoEGY7rBzNtt/IyCywtGqCrQs6slvVoMDv61otq2SNYWDOhT1i31ZfzHo6dYQOhPeiA0Ckq6xmhRMpXNXQTUDp739gCRLKqQUNzx4ERheI/WskqC2q9Lik+Dla3l7TEPAxSpXfuSLlxoNQE7ROf0XuT49aqCkbUGuGr1OiRn5TtSBzeyp6AnZlpxhm/PU68O0QpaUfpWDN3kWdK55V+v9vCfS11g/uaZER0snJ9F4Z+TWNKiWK2aEVFo9r7ESdvc1YOLrmBZ7s8/SorhtrxDAV2+MR4y0BzXXe17pcj0PxyFNQugHhxJlf6mrWd6xodqyoFSa2E2CFrvan79ef3gMIdfqut6dio6ASHryzajd/OFm5cIXddFbd5tlsYC5Gw+hQ4VNY/LW1jr+EugRWO/KndwSMxmybJx7pEp8hXMxw5VKRtLqFiZpM+y1PDfzeTLF7u65Fwz4pAHsO7NMBGOS5F9ijkBlfrIF65Fg52OmQUec7nOnEsxFmAnfgETxOkUGaIUYIgwWHcuBREbDbeffEE0JPitKmNFFuSHEdTVfP4
 7DwX6EH7
 vKLcq9SnCP2DXRW19nv2z4gimsT75tFY+1XYsnGvFJi1s2T6Cgwoh2Hc31hzUHwlEbsNEWm4RAbCFd2diokttAxi+lC0bfi50k/Qm7gJpShRja+tg2E1kbQ5hQOCsieJTW9HprhdPRyom8XsHWMKxZNrq6bRBUYFTndbvFflA9q3YRPaQuNDngJguq8zVbWGRpRjWQuUBLUhG5Jsf8/NHlEViMWblLT3qT+9FX3MGPMSJQiFb9DNFsHp/dwZJ+C8qLxLA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 07:35, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Page flag helpers for configuration-dependent flags provide false or no-op
> variants so that their users can be independent of the configuration.
> 
> The HWPoison helpers do not fully follow this pattern. When
> CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
> regular, test-and-set, and test-and-clear operations. When it is disabled,
> only PAGEFLAG_FALSE() is instantiated, leaving TestSetPageHWPoison() and
> TestClearPageHWPoison() undefined.
> 
> Use TESTSCFLAG_FALSE() to provide the missing accessors when memory failure
> handling is disabled. Both accessors return false, which is consistent with
> HWPoison state being unavailable, and makes the accessor interface
> consistent across configurations.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  include/linux/page-flags.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7a863572adce..a2315ab1dd3a 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -656,6 +656,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>  #else
>  PAGEFLAG_FALSE(HWPoison, hwpoison)
> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>  #define __PG_HWPOISON 0
>  #endif
>  

Can we just squash this patch into #2 please?

-- 
Cheers,

David

