Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C6ED13C00
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 13:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C45A6B0089; Mon, 26 Jan 2026 08:45:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172416B008A; Mon, 26 Jan 2026 08:45:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06ABE6B008C; Mon, 26 Jan 2026 08:45:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA1CF6B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:45:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F444C27E2
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:45:15 +0000 (UTC)
X-FDA: 84374236590.01.A7FB1C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CEBCC14000A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:45:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TkAdyOGK;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769435114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xMCDXBK98svIEGqHcH03JamawrF+kxK5yFNzprmhnA=;
	b=Auj1xc9XwwXedj0h5FL9f27h5dGGp3ehwWWCIT7s5UsjRwJVNOZutrK7dRQAWd0HNU0IDu
	I7ZLFSFAx6TENTLHxkPKTl0QH9vfiCVOCK0yy80NJlaRzGJpc4n3lOJvs3L+clNPUuK28P
	k5jFO0a3uSqFSRtplCJdfrCEp7wew6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769435114; a=rsa-sha256;
	cv=none;
	b=5e0bl5xreRFAGq+NjgwJXUrAxNZzZFhEQWe1kPvtW9qqnh4w3ZKf8ZWrDtD4JOjQ5hViu5
	g/BrfAX3HV5eKPiSnch4jpGrzVi/f81BvEW9cllAz7sLUDmj/NpZUFGgYiD3/uFewUqxiE
	9f0CBDwmV9buTncWWbXsFMNVp2n3cz4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TkAdyOGK;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF5B543F3E;
	Mon, 26 Jan 2026 13:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4B5C116C6;
	Mon, 26 Jan 2026 13:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769435112;
	bh=xw/pUvk0u6PtIzlKi8yZZbG6CWAdPi59b0ZTMCQ7GRk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TkAdyOGKRNfLrHFPNYnuEp0JpEW6/EaLKUJQJBigmpBHdQAGGppWEQnDahgzi2aM9
	 uXJJxPso/zn9Ve99t7pA9o8rSjNLOKFJB0jMkdkaqpjzrP9OV/9gAxNYVjF7EXeDTo
	 a95nQc92RLuYffzFjH0sj98HsI71PudpADIrTXuENU5arMt2gn5NasA7Xdk75IgSAH
	 iaSQ98xzLIRTRR5KoXrUqdTWiTzFTO1EYz+N14ywCdwb76dNzpaeMa3pFmPZ2Bt0VB
	 qOjfbtaJshhAiDiUtxiFKhvuQO57iNsft+yN35w+UoTSl01UK4ZsqpS0wTJ11n5EJO
	 2Du5t4HtuADxw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,  Alexander Graf <graf@amazon.com>,
  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  kernel-team@meta.com,
  SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4] kho: kexec-metadata: track previous kernel chain
In-Reply-To: <2vxzikcoa4g1.fsf@kernel.org> (Pratyush Yadav's message of "Mon,
	26 Jan 2026 14:28:30 +0100")
References: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
	<aXdTEzsm88JKu9zY@gmail.com> <2vxzikcoa4g1.fsf@kernel.org>
Date: Mon, 26 Jan 2026 14:45:08 +0100
Message-ID: <2vxza4y0a3ob.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: CEBCC14000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5phpnzey4zuz6ddx3b9we8up98e8hzk4
X-HE-Tag: 1769435113-253401
X-HE-Meta: U2FsdGVkX18hIYAMNnFcNJOYME7cx0vrkRSswvFsXhhTNpQX9t2cKZqAAjZ/Bc+sBl+ckttym155yrSTm01m9dtKjC/zkD6p/2xBEnTDzQ0c34JfJlRYCHd+atW9K2fb/9sow/mcJZO9Y5yZ8eXt3b0eoFyqvDgEXqkt3uMKVfV2iq/J6EsHffOjRY7E2N8VAiEOz98tTWZ8sU7XPLgCQ4TjxN0ceUOssUvOW4oDFQ8m0E532Us6So4V3e43W9aUM7l72F5PwGy0Ol/QVJsBehXkBQ2kqR7WR6V5I3QGw32HDIH+FbMU1WtvhzJ6fLcgslOuvBbN1vziuhPshQjF9gFMQFVBsEN85sdRLcIU44/rXp/H12E+X3GxvT/0gr6oFKjtohsjOR21GWirpEkkZhTdWWjjP4g6WXbgk1hsAtvwUxJdRBiLMYAf6eyijxOSduvXVPSae6EEeBEphJQAnoaGZaiMVXupbGqMVZFBMOw9kzWOR7DWf4dleH/lK1bfibWt7A4MxjUuFp6z82I+SvpScZRKsE/3FZULmsI6vvtzjTEYp3S2U/FKcgysBy+AbKNZSNFINs7fWo2CgSwzqrrX6VQ3BjVrpc9j3XWRdxCVVh3LVKC+r8lraXsL1hIyUS3jyGhC/W3M8H0sooIdzQvCr3N14/YfChe/Sod+I5oJ8J+tqch71rwfbVETLO9lId+QlfQY3hQJM+3FdW3ySlF/GYFk+5eyGROpPRSQ5sE4Ewm9umB94okrJNTp0/Hpy1ZYEpb2zW8+glqDPLurPgYTwTo0SV95MsSxcBDklXzYsYqIBgfxCPNBz9qahy1VM3NeMacLO3UHSpqXLpM5a3HWVxe/aGBJ8fkvPc+e9JN+hoek7gpYokj2WYFl8aU43UmgjOtDjdPJj1AELNQEAoXXE0twyBHRr0Ht5e9uNDhW2HXaJCjuhCuxDUx7w34GZC1EWduaRUeZI1xA8Bo
 ytsvHV3H
 fdkdfgD4C4bwWPHQsDXFdA5y0StD2F30tXI6WfPQl3gpcptn8YUu9O149j+EBoDtNeA1T6v9jl3YL9wsUAGfNTwYKCyvfvCLBj0zVtSo1F5hjDNFOK1W/EAXkfhNJkTmQH/sgNZxPviM3RVLTzOAIMPCWZ8jRkkcRhuj1xx6afMmXndY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26 2026, Pratyush Yadav wrote:

> Hi Breno,
>
> On Mon, Jan 26 2026, Breno Leitao wrote:
>
>> On Wed, Jan 21, 2026 at 06:50:38AM -0800, Breno Leitao wrote:
>>> +static __init int kho_populate_kexec_metadata(void)
>>> +{
>>> +	struct kho_kexec_metadata *metadata;
>>> +	int err;
>>> +
>>> +	metadata = kho_alloc_preserve(sizeof(*metadata));
>>> +	if (IS_ERR(metadata))
>>> +		return PTR_ERR(metadata);
>>> +
>>> +	strscpy(metadata->previous_release, init_uts_ns.name.release,
>>> +		sizeof(metadata->previous_release));
>>> +	/* kho_in.kexec_count is set to 0 on cold boot */
>>> +	metadata->kexec_count = kho_in.kexec_count + 1;
>>> +
>>> +	err = kho_add_subtree(KHO_METADATA_NODE_NAME, metadata);
>>
>> There is a hidden bug in here when CONFIG_KEXEC_HANDOVER_DEBUGFS is set.
>
> Good catch!
>
>>
>> kho_add_subtree() expects a fdt as the second argument, and we are
>> passing a pure C struct. That works fine, except for debugfs, which
>> does:
>>
>>  1. kho_add_subtree() calls kho_debugfs_fdt_add()
>>  2. kho_debugfs_fdt_add() calls __kho_debugfs_fdt_add()
>>  3. __kho_debugfs_fdt_add() executes fdt_totalsize(fdt)
>>
>> The fdt_totalsize() macro reads bytes 4-7 of the input as a big-endian u32, and
>> this will hit struct kho_kexec_metadata, given I am passing a C struct instead
>> of a FDT.
>>
>>   struct kho_kexec_metadata {
>>       char previous_release[__NEW_UTS_LEN + 1];  // 65 bytes
>>       u32 kexec_count;
>>   } __packed;
>>
>> Bytes 4-7 would be characters from previous_release (e.g., "0-rc" from
>> "6.19.0-rc4..."). Interpreted as big-endian u32, this gives a garbage size
>> value.
>>
>> The alternatives I see here are:
>>
>>  1) Come back to FDT instead of plain C struct, similarly to the previous
>>     version [1]
>>  2) Created some helpers to treat C struct fields specially just for this
>>     feature, and we can do it later if we have more users.
>>  3) Move this kexec_metadata to work on top of LUO (similarly to memfd), but
>>     that would be an unnecessary dependency just to have this kexec_metadata.
>>
>> That said, for the next version, I am coming back to to FDT.
>
> Please, no. Don't go back to it just for the sake of this bug.
>
> I think KHO's assumption that the subtree will always point to an FDT is
> broken, and we should fix that. I think KHO should expose the blob of
> serialized data and let userspace figure out what the format is and how
> to decode it.
>
> To do that, we would need to update kho_add_subtree() to take a size
> parameter from callers, and pass that down to debugfs code. I count 3
> callers of kho_add_subtree() - memblock, LUO, and test_kho. I think all
> 3 should be fairly easy to update, but I am happy to help out if you
> need.

As an example, I'd do something along the lines of:

diff --git a/mm/memblock.c b/mm/memblock.c
index 905d06b16348..c06d6b9e390b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2512,7 +2512,7 @@ static int __init prepare_kho_fdt(void)
 	if (err)
 		goto err_unpreserve_fdt;
 
-	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt, fdt_totalsize(fdt));
 	if (err)
 		goto err_unpreserve_fdt;

-- 
Regards,
Pratyush Yadav

