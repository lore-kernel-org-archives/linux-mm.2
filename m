Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFFECD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D706B00BA; Tue, 26 May 2026 08:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475AC6B00BC; Tue, 26 May 2026 08:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38B176B00BD; Tue, 26 May 2026 08:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27A8A6B00BA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:27:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0DDE120320
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:27:37 +0000 (UTC)
X-FDA: 84809496954.11.E9B33BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E296FA000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:27:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvMksGPn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779798456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7mvxq8Xrq3CqdfmGxEeg+vF6DmI+9bFFd+7wbBfzm0=;
	b=6nYfxyKSWzB5w+HJdtJgM0azVANkEfe1LwTWKyXdQYLQXyyc649XAURmBsykY0KWfAKE70
	AGvY2pH2HnXOA78I4080zoUaG1mRmw+T+VrErDhSSCGDgyLc3tpR7GvE1gULZFnMRYnuOZ
	ywTe74bhBGpsSNTrUkNlx17ZTYm6i1g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvMksGPn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779798456; a=rsa-sha256;
	cv=none;
	b=BIlLUD1lWFBCAinHL5UwiUP5hW+NT89/3d4REWZpEYVSkZtey5cVTQCFanZX2l4DvaYxSL
	GUJvD+9PIL6X3BT83RoRT/I+yVDWstnkXtMQXKVX/7x3wGs3hmyrsrqWOKNL8zRG9GDs3R
	HozWwr81B2prxeIl8RI9v2dZawj+3vg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E411540E88;
	Tue, 26 May 2026 12:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451F71F000E9;
	Tue, 26 May 2026 12:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779798454;
	bh=S7mvxq8Xrq3CqdfmGxEeg+vF6DmI+9bFFd+7wbBfzm0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jvMksGPnwc9gaA3KqJ8OWRmhh9Ncdzp5xEHPKKFdqT8vsZItR0VQj1yvMvKHHXS78
	 V5MooOxdVH5CdXqv6Xr0pWO/XBDrIBEXkU7mKIEQ/iPYLt8dKmKRLqzrDwGHBHBujT
	 cf3iwt6FksUnc1VJMvpCIi3kbRhPOmcmyEjRK1fowWZ/ji9fz90WGAIuB3PuzI75ZG
	 ugpvw/oILmdOipfsbQ0XCJiBpic+K0vX0W3okCZkHkLjI0c6cEh5B6AnEENwHurKM/
	 aYUcjM1vBt9eEOVg37CZNsrywNS8ghxPr9Pq+Q+KXhzt8+p3TpXuffDAGBjyfK0npN
	 lUzJMdj6dyMdQ==
Message-ID: <65eb2656-e25f-46c7-a82c-7478f8aa4d14@kernel.org>
Date: Tue, 26 May 2026 14:27:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] mm: shmem: refactor thpsize_shmem_enabled_store()
 with sysfs_match_string()
To: ranxiaokai627@163.com, ljs@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
Cc: leitao@debian.org, ziy@nvidia.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ran.xiaokai@zte.com.cn
References: <20260525102700.68707-1-ranxiaokai627@163.com>
 <20260525102700.68707-2-ranxiaokai627@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260525102700.68707-2-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E296FA000D
X-Stat-Signature: wq3ubsicjb53cxb1odxhptysnpornx9n
X-Rspam-User: 
X-HE-Tag: 1779798455-21514
X-HE-Meta: U2FsdGVkX19jMCLvT5b3+NoUZ3NRB1fayZGGZUX/SJK1OSa4G2BJamEB8Zo70DV2wzsg6nIBIRVtoqSYS6ab0GpdDFQVbjaTKBcqLlCcAyMxiUm3/8hWhrDTwqfdoF6bdctLVtY1tiGrUKv3EbdSykqiTlyWQgEtqJA/rn44+5Q2qCulfvlWh3orLgzA60gRqXewO1WDRTT8X1bQNDeQa/jJ5dSf2sRXM6wm2YBzIZWRt8AU4i9/akG8OT6kXVeBWmr6YfbQsOFtkM41EFSpcodGXlqdvyWQcjGpugCTpppzS6rbjEfRBD01vIP2RkY/VLacA/SU1MDEB63bge3RiflUnYNZ+4sVhtP5kMbwC/3PVYVIhlXp+9p11BVY0lWeD5H62YcBma+LbM8U6GMYIjoErixkESeSn8uOkQUgHSo04KNufyZ+fgFtOIU19Cy6xmfY+snTh3XECB5yGbWG0YRZyL940E7QrRrPk0p/hpFD3PMM94Avx9/h9wf69zQ5dinjvORRxksKGpbqzAJPAhfyoTSepI2dzRQeAWxqQ7DmsSWhIV6p3hSYiJ3qcJgF174g5T1Iypb4sMSPsRI3MF3F2JtfFYL8Vxyz8Qoq0lw4RjWxuTdXa4N7nFXSP5nJInpDL8/dF6o/DcjqTbNH4Ub6p6Tz4V3DI8TLLeHbTCv0mZiRFONddbuZZKc5rM+bVDMpYoOryXZVo1mWbQdNJqfjRaW4YKuq8kNZsGWSb71vTMELuVG77Ntfbg6qdAEkAUN9kPtQsEMxzDNNyt6FiioSEqqCiZvSHJFpfmfDemUa2niAzHC1rB6z4e9QXn671zKi7N1HgY2uwdyhHbiX0mnQkngijVsuHXDvhIaAZ1EfofGr00p+ksK0fwiZNofNXJ/YBnMOOMyricyojQ/yza87owLuenrDjv5k+Tu/IDdck3mgVsg1e70jtJMu9+Fv/5tGBomdhNkiBICHbcP
 qT6dW7Tr
 32/2id2FPFMTSY1lYZCrfA4D+jole0GNj0T7tApaH+xM6TeBEi14mc5UZVnpEvKpCB61yXXPOcqpH18gchElbDF8LsoHvRJRMSnDFpGPQluBK6UyX6V2MZrrCNoJ1ejFStJso56YGod7cUP48sTzOZIGLoEvvkuCu9W7Fhss7f3jt2ZSZ1XSIRxgGar/aM2Vm4aolr0NeQqKOVmjnJxzC7m+uW3nMuUnXmzPh9Dd0knudm89LlcoOq92YefRrI1btXz0U5SQfSAfcR+aJZs9Yek0PlMOwOqcKjgSFVOZjdGpNr2jsiZb+Iy7IsGzC4encWetEOW5tTjyOdlYASB//YBuESNmenAQhLWs+7ANPzzsA4dUx3eyZ+xDY/979iFMBunH2V8MlqFTQD9qhUFaHWUjn4fKeeZSUvoeboj5rKPctlijuXcHE/2jzcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 12:26, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> thpsize_shmem_enabled_store() using sysfs_match_string().
> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> calls across all branches, reducing code duplication.
> 
> Behavioral change:
> Call start_stop_khugepaged() only when the mode actually changes.
> If unchanged, call set_recommended_min_free_kbytes() to preserve
> legacy watermark behavior. This avoids unnecessary khugepaged restarts.
> 
> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> all test cases passed.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> ---

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

