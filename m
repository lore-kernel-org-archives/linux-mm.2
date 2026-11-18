Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FC4606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipYi9E6e
Received: by kanga.kvack.org (Postfix)
	id 861F16B05B3; Wed, 18 Nov 2026 10:54:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818B66B05B6; Wed, 18 Nov 2026 10:54:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701FC6B05B8; Wed, 18 Nov 2026 10:54:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB5D6B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:54:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95343C07A4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:54:54 +0000 (UTC)
X-FDA: 85448688108.29.1E1D6A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A7D1740004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:54:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ipYi9E6e;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795017292;
	b=b+dYmGUHSWq6undATyMDi1XA3tzxHPHACzk5QCQXHxHnsDP4KUaz3Mej4w5f1E6GOVEkb7
	9STo+H/HD6TsZUyh23lz96T/J3XeCaNbsm5RebVdxz2ReKkFIO7oZtNbTxAlAFV3qGgXMr
	b9ugKw4YKeh+P9vxbQsmQ4czUNs4mZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795017292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmJfzC/sRq3TlQhBoN1iY/MRqsblNPUXimCuifUw2i4=;
	b=7vLRwga6nWHTdF4UWeFPcx/JdGkicDBXyJBJRYn7Ip+VOPmH5i7NXctI0wEBCiGHzVSvFD
	LrrnLCBU0ioMppgqoQHQ0pkzIf9m49Sf9lbq7xHwleLpigQD2TF9BVu+EkFSrSHNQPlBlc
	v2z44u8DT5pENc9vRBUUo3Etg7q6I+A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ipYi9E6e;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2AD344E39;
	Wed, 18 Nov 2026 15:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B221F000C4;
	Wed, 18 Nov 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017291;
	bh=DmJfzC/sRq3TlQhBoN1iY/MRqsblNPUXimCuifUw2i4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ipYi9E6elWAi2Wc6DUpjs2dCpCCGm6GaVIR0YbPs0dkd9x4JZMaISzryIIxxdy2ac
	 avidtPhahy4S2vbejNTSzGtufOYSUF18usCZyy9AekrJV6i0rkCSWahGdhLIAhPqv9
	 hp7lx6eTb7B6+6dgSMzCqk9ivlXNhu6vCTGrIA345xjQ5gjNBug7eJPZrMQsh+Ec2B
	 UuQ98OvAPkenUR8cN9UQVY4Jjd1hKHndHmylk/6P4MbNZKu6/YzGelhRmUiTzzurEA
	 fBGPB67h6fbliEoajzSm4zD2M1AijSSS1smbPDcw+YbOiBg29cA9TnBc+EYJqrgA5y
	 RGae54Msu6SNA==
Message-ID: <b367d98f-54fc-4d29-8e3a-2d19dc4e2603@kernel.org>
Date: Wed, 18 Nov 2026 16:54:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 3/7] mm/slab: handle SLAB_FREE_NOLOCK in
 slab_free_hook() instead of open coding
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
 <20261115-kmalloc-nolock-fixes-v3-3-9034dd4ecaab@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-3-9034dd4ecaab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A7D1740004
X-Rspam-User:
X-Stat-Signature: riyyfyjbq6y3ok5dxb9zknznqpzhihwz
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795017292-268090
X-HE-Meta: U2FsdGVkX18Ug8JvOoi3782JpIQPKS36EXE7D7Ed6o2VQpcoaj/xPZLUM9tdZksiwcwzd1f7CqLk9KdEELCMffvOugC3+ByNqPCyyNQzzba4Kq5rLRxvEmIJ/A5vfvAb58zq974yGuJgacMvZLD9XhxPXgSEEsp2Dz+wEJRZVaNGR6oR2W1Y1F3eQa3fOvSaw6ouNaLndk6AJo6TTtoRdcm+1iUpikTs8nm99ujid6+3+1Zz7jHGXTXyb6so/YleYgTdEl6HN3ARv7QyKDkh7JlM+8ItHof8qPzq3mTtpRfCP5UKFC8EYwLeiigotI9VRhKhVTLExD8///wJxxu9wG/rgnjl9C59xCX3DwuoIl+AAuo/Ei7m6P4YadFQlS8aZWZIGMUgyoZ2+7mzx9fbX6FT1lRkKx2PQL30UIrKxc/kF8Cs52rEh8CgO1SO+LKk9iXqSpEhzL/U4c/6rCVn+slBfLjBTWkDGzyGs3jDG70UKBbXmlbZdCS3vnrn1gIvqzwbuvgr2w6tvmRvahOKZtzQzpu5qYMlDNflTXuUuQE0Kiebt31Hk2dWchNUO1DgeAzukzQW5rCovM0UzbwLKmAB4823F20GP/q9icLVmwfMM9IVHkssWQZYRu0KmoGWH6hHJ8qGJONxRCjOQiss6/BGNL1c8yx9Fv43dWZi73ylFodz3r33BUGeHDEhXLMRoYlnI5AHL9RcmNjHdWxrSQr4cpjfA0IcWGAWzWhUcSPNqW/lc4//pJuzo+Gma4UDT53xXlJc+CLRGISCmfVLoZbrkCbk0riwvtE63Ghysdizk4v2oSC+Sn7GTtNaLsiq4NHU8BTDrOc5kRP9K3VPk4XNyzV2PjfRpGwZLR4fyGJMfp7bNr2X7v8bwlHB5gevRKmX13MnTgoZ+E2JvoUFD1pmOEwAcPRIBqoja75ETUhDFpZwN3X2L5KcpAt5JcmFWhY+ducvve+YUyiD5Pt
 OALYEUgW
 6zkfnHHf8iJC9aTRG73nsIuXETMSEux8nsAqb5soAt227sI97qmg9Qw2kj/fF/gJ2kqFyYphHBnqS0xsaIKzSFSkpFu9qPLHpULjQrLOraZwUO6khunlga7rTYbGzRl8z/AGIjcVTMry+PuFj+89MvIz9CmAnrOgQ71s29ARxxAjOY7MZeBldXzxBPW7jtKvDZ5i53C2QI0y19Ocv0CK9OZPNBgF62MPqCdOXfAwyFDjPrA0FwZyj9LVCIYvHi2S8OC8vXCKUKfrgg/dxYm5Z/Za/zfGOU5R/GTXuGmUOpvf4+YvL5gdnLj8kljSE/2y3IF7uH3FuSFbOzuFiKuGa/EAKCp/rEKoDjUnBSEnajzRinPAZNhvkMssffpEwaq0kd5awaz7SW4QndBzdsLPAPu4YqVo9we5Hc9/NURZZw3w6Ssc0J7YMAlEOqvdXyFeTKgXv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 16:09, Harry Yoo (Meta) wrote:
> kfree_nolock() deliberately skips slab free hooks that should not be
> called in unknown context. However, there is one more place that
> needs the same thing: memcg_alloc_abort_single().
> 
> Instead of open coding slab_free_hook(), let it handle
> SLAB_FREE_NOLOCK. This is required to correctly handle allocation
> failures due to memcg charging.
> 
> kfree_nolock() now respects init_on_free which has been ignored.
> Besides that, no functional change intended.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

The sashiko issue seems pre-existing and orthogoval. LGTM.
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


