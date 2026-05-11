Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE71CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C4A6B00A6; Mon, 11 May 2026 12:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD6A6B00A8; Mon, 11 May 2026 12:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8136C6B00AB; Mon, 11 May 2026 12:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF9F6B00A6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:25:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 130318B3B3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:25:59 +0000 (UTC)
X-FDA: 84755665638.07.862EF84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 77B102000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:25:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pUXVVVwG;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrqTfVPdTZxJRp68YocSY09APfo4bTsMDgF1qR5U+20=;
	b=2+icrWBOCvaOBprtarZbh2Nq+mcnaxWnfUx08AqrL2L4VSWE/ZOsQUsu43I42EfEyWtN2R
	jl5xaC9mNkTy9NMnZpIzGx97+/OBlKXY3iaqeOkgCFSINEN6KLoi8/NG0rFNq1XcGzUPVm
	byP8MLSewIRa0dvzTQDSaS9ON/K9OtI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pUXVVVwG;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516757; a=rsa-sha256;
	cv=none;
	b=GMnJaxWjSsAF7oQ20AV9Mgpq/wfWS3sf+Ev+NFRxAsmYhokoKhfDIjJRbfQI8dn/j5fj1j
	E6K8+oZ8ZRal7MQfgIyUGs3da+V6wFD+k+EFVGrp4Z2VF/p9ai+dUzNtF7dLB+PIkXj4Pm
	MYHQcjlkSxHp9MTRhlGpfWO3mwclJSM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C91B36001A;
	Mon, 11 May 2026 16:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C686C2BCC9;
	Mon, 11 May 2026 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516756;
	bh=qrw+cNWHzlyf8OR75OuLW8AXYM+NnLkhDwF7fpuKwm0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=pUXVVVwGAJN+u+9N0+31sblPJ4F4UWk6pPMzc+qZHLlm+J+vKIZu7kcFcW6uDlS1+
	 3r2woy3sazFt2w9ffUCV7Krk1EzPmX/B3GcNzzFK/kniGNb0eMAHWqmQfgeQhWyjul
	 X7fbOi4vvdOEUKwpqV3YvdanWBdGW9GcWhFuTOKAeLBW8EBV3S+UySWxIrykPBLokI
	 4rijrpU4jyvbO8oJDUmfCezSBrvYyh6rjhP4+Qogwjxnqg+X9rcNi4I7z7DWmoBb6I
	 jhdDXGVYZddJIbK6/63qYps2PN7hnbkJTcF/45ycA5jJsglIYnIdlofPbhc/157lc8
	 XHvOmN2BIMubw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] kho: generalize radix tree APIs
In-Reply-To: <agG-OuOTAg5YD-CV@kernel.org> (Mike Rapoport's message of "Mon,
	11 May 2026 14:32:10 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-2-pratyush@kernel.org>
	<agG-OuOTAg5YD-CV@kernel.org>
Date: Mon, 11 May 2026 18:25:52 +0200
Message-ID: <2vxz8q9pdib3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77B102000F
X-Rspam-User: 
X-Stat-Signature: minf8smryksmh3t3h9md3ub3jkoi39q9
X-HE-Tag: 1778516757-745982
X-HE-Meta: U2FsdGVkX18VCQN11kcapM4qh1iKjxScqqImmIvIAbOZlF+xIqHoRqI8s3eyvur9Q2OszIOVpZ7ToR+58Pi8ZcsHq9H+Bdb2r6Lxt2x1H8h5ASHqM1m4rhPt47pLYzT+zt+K9m3nBNGL/bq2Do47uMtj12K791TduVf7fwI9X3D7uLx6g4r+fKG1KEwy+jfkDjG2f1SINKqSW6G2BYF0D+hJvVycto9OcCesc6Gq+WdWHLHmZ3KjCcBLk/chGnTA7C3dXOK8d8rqBUnXU7z0wEHMJ+PQkoAIyMcm3GhsMCuuA4Xfxp1p/VC9nO3T1G45q9CP9vC4R3H7EhpqTJI2LcdKmvFDozUX/d/3mo4p4umXq2ngtsXRHPBbaZuFHa/bc6RNwhKf9EmGU8u79odCh6urOGxOmcZ/9k7fIzk6fPcC7yP5g043dROLxGRTRuIDPAwLyItqRXhgu7/GVlVa31SD5Uo252jGYnSCO0l/lsTfHt27PUlLiNRKwNfIks88q26EKHco7gkIOk5ki9iS4MRQOXrL2O9hbM/Y2ly5CyTHmLe1xbm4rJTnqVrNPfjzxFSg2B1w3Yb8BM2axfyH/xHRgJBX5fmQIK0g216UrkaLkw3wMZCxlaJulmegIwzn8R3WIZUtGSvqagaE07V+tp0Rm5HJ5NC4rTWr0MfMwJTsF9pbZPSLJbwadOgB2iXRD6272q0gJo4PGHAdRYcWuf8TkORFV7F2yXLeMAJA2JXeIB4H7a60VXeG3hXlykc2a72f2UVklWhNACfCLPmn+J9mcXWMZ07V9Dq24i2GQ4xfeT+s+95fJ/xQozdPBC6LI8/QPkMWwM8r3a0y9l5yhWjjY8NFsWxFeq2RaFVUUHVsFOBse/5Dzg8IPOC+/Nn/Qlex8Zt5D/4hA+ULkprviX5soF4itcYs5NTXhQ7Vo7sLEXVDpy2lwUovioMGroykUq4kHNVlxK6kMculaPO
 NM4qusmm
 pxvRmU5lk3ScYKPfx2XcSbxLyyWkfIAanN1FGRIm7qQUfE1Ye3yXnujnwfDuX4h+HNk9M/lbNDS0WodPJ2fU5Yq0jfdTrCYJY+8AXQisZ3xr5gQyOH1en5mJT1Bs5Ob5f6DrK5W66osp6O/FpSO2Wrh/YeVs8OtKGcRk2yrYQDAdXy6yBsjKHDv/pMXb2potHkOqz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Mike Rapoport wrote:

> On Wed, Apr 29, 2026 at 03:39:03PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> The KHO radix tree is a data structure that can track the presence or
>> absence of an arbitrary key, with nothing inherently tied to KHO memory
>> preservation tracking. This was one of the design goals of the radix
>> tree. This was done to enable it to be re-used by other users of KHO.
>> 
>> Despite that, the radix tree APIs are very closely tied to KHO memory
>> preservation tracking. Adding a key is done by kho_radix_add_page(),
>> which encodes it as a page tracking operation and takes in PFN and
>> order. kho_radix_del_page() does the same. These functions encode the
>> key internally that goes into the radix tree. kho_radix_walk_tree() does
>> the same by baking the PFN and order into the callback arguments.
>> 
>> Generalize the APIs by taking the key directly and doing the encoding at
>> the callers. Rename the functions to kho_radix_add_key() and
>> kho_radix_del_key(). In practice, this removes a line each from the
>> functions and moves the encoding function call to the callers.
>> Similarly, update kho_radix_tree_walk_callback_t to take the key
>> directly.
>> 
>> To keep the naming convention clearer, rename
>> kho_radix_{encode,decode}_key() to kho_{encode,decode}_radix_key().
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  include/linux/kho_radix_tree.h     | 18 +++----
>>  kernel/liveupdate/kexec_handover.c | 76 ++++++++++++++----------------
>>  2 files changed, 42 insertions(+), 52 deletions(-)
>> 
>> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
>> index 84e918b96e53..f368f3b9f923 100644
>> --- a/include/linux/kho_radix_tree.h
>> +++ b/include/linux/kho_radix_tree.h
>> @@ -85,7 +85,7 @@ static struct kho_out kho_out = {
>>  };
>>  
>>  /**
>> - * kho_radix_encode_key - Encodes a physical address and order into a radix key.
>> + * kho_encode_radix_key - Encodes a physical address and order into a radix key.
>
> Let's keep kho_radix_ prefix for namespasing please.
> This is the common practice these days.

I am keeping the namespacing, just moving it out of the "kho_radix"
namespace to "kho" namespace. The mental model is that this function has
nothing to do with the radix tree. It is just something KHO uses for one
of its radix tree, so it should live in the "kho" namespace not
"kho_radix".

Does that make sense? I can add this explanation to the commit message
as well.

>
>>   * @phys: The physical address of the page.
>>   * @order: The order of the page.
>>   *
>
> ...
>
>> @@ -144,24 +144,21 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
>>  }
>>  
>>  /**
>> - * kho_radix_add_page - Marks a page as preserved in the radix tree.
>> + * kho_radix_add_key - Add a key to the radix tree.
>>   * @tree: The KHO radix tree.
>> - * @pfn: The page frame number of the page to preserve.
>> - * @order: The order of the page.
>> + * @key: The key to add.
>>   *
>> - * This function traverses the radix tree based on the key derived from @pfn
>> - * and @order. It sets the corresponding bit in the leaf bitmap to mark the
>> - * page for preservation. If intermediate nodes do not exist along the path,
>> - * they are allocated and added to the tree.
>> + * This function traverses the radix tree based on the key provided. It sets the
>
> Nit:                                                     @key here and in
> the comments below.

ACK.

>
>> + * corresponding bit in the leaf bitmap to mark the key as present. If
>> + * intermediate nodes do not exist along the path, they are allocated and added
>> + * to the tree.
>>   *
>>   * Return: 0 on success, or a negative error code on failure.
>>   */

-- 
Regards,
Pratyush Yadav

