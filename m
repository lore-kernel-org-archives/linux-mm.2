Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B60CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F1F6B009D; Tue,  9 Jun 2026 05:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46556B00A0; Tue,  9 Jun 2026 05:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CC46B00A2; Tue,  9 Jun 2026 05:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C44116B009D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:55:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7ED90164814
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:55:33 +0000 (UTC)
X-FDA: 84859916946.30.7B6372F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BDC881C0007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:55:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FBly/emr";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780998931;
	b=FGGrMeb+UXmmbgoyK3pBh1hCVOfpoUe0EADfiQXzBDAmIFpKrzDsAM16EiCfaOPy9vojlS
	x3UOuAIqp+6o13lMfUYHPkH+MXv8RX3qKNCZsp2n0UjLg6vwlb+RAd2WeT795QVaRvqvHk
	kw6onQOe5ekywxbrvqE+xdSUtSUINks=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FBly/emr";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780998931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fb64ERX8IQ5RCHgdgmlatnPmlzWSU7KCQUnwmM/R8Rs=;
	b=YvIH+I0be9yuJI4tC3YlALORQ1UfMg8gzqjnBkpGxXUT61LcFkRSCkNHneuhWgN5AtXb8Y
	bU9UDrPo17hRWfdPKmqU7yK5vpH71FQRjYIZyWnI//vjpiT3wrszIxj96oP/pyA0elSaNA
	ZtMsSWYlJdk6dSKufw/L1lRhYvzWv3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 548E8601E1;
	Tue,  9 Jun 2026 09:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132451F00893;
	Tue,  9 Jun 2026 09:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780998931;
	bh=fb64ERX8IQ5RCHgdgmlatnPmlzWSU7KCQUnwmM/R8Rs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FBly/emrcxyfCk+GXZrRzoiHJ0QgVUIjuPDwX+0uOFY0Y3qZPGr5C69oLvso6kSPr
	 jmMSB4TXSQO/sx25g+1CCuROqXzjgepmaDDwcciTevuHDg3OIoytUNPTXdwyyDjoSK
	 2ele79KVgfWuUPIfcTGAyKK2E+XdOgXmWmKPc8VgN40ApZliUoegw6PAYMwMAiw8sX
	 pI4vJiFAq8lwe3wOL/WaplbPe9IVlz4W25R6S/CX+G5Jwq+c0GryXS4CtmeToeak6h
	 FDp0SMwRRfZKOLxjiCoxOBdh9acmLItKBRm3O8c+/ChOL5+KluWOu2Ym4mK1SwcQT6
	 U77WkaQ9d80iQ==
Message-ID: <9361f783-5af4-4380-a901-8d330370491a@kernel.org>
Date: Tue, 9 Jun 2026 11:55:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] mm/memory_hotplug: add
 __add_memory_driver_managed() with online_type arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-5-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605211911.2160954-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BDC881C0007
X-Stat-Signature: n1jn7w9go9y9kysotfjyom933jsju5is
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780998931-306402
X-HE-Meta: U2FsdGVkX1+OfEk1rzBViNyN6wBnaHL4xq/5/KPUwZK6OmulZErbb/30u3Vuyz2I44Yxa8snpkopzk2REJIGKcP5Jlx8Fp2+9izQHMtekYbtePA1m+UymRcyuXmnhe9SLJQhXRpGh1HC4nZCCRzoskQgd/NQdqboCztufwdDhhfepu5sBtvKsPFOv7JSSRUHbMRiTF4fb2ow0FhmU5Hgf1HmHdii5RF5SKBeKoGz5V/LnZc5QvqJB+xzoRT0Y22vEk5ar6vEpJItatNTqCSgUJaqS66V6Z5c7gur2az/KCihLZzWNWaK63sA0pIW0e2N2GbEZc3zUlwWWiaZeVKnkfuuvpGEyQN/gENwLI3B7b18aulCGbs59hwI31N6uKB+pC28IAOAs+LDJggyA24gA990z/mAVJqZXzzFzgEj/ca09ymfWXyko7JhGIUzsCNRKYnfsS8EtWW5CJ9bRpQw3dTg08r1QAnNCkiZ7breJPC0pbUrIMPH+xgXBoUvtecng4LRCw9dhhlxv9Ppt/z+WOmVPWMdq1uDJU+PAGadi56lZC88vKBuM6OGW1A/DEywnNIc8oHujn7W3QiD1Av6ICGMt0y9PrgjfzAcyMs/2x+k0YLRvma2qDNP1EalOhxRmgM+OPRVx8pozwSuEl7IEY3V16Wj9fyAC1fTQAaVGQJH742DojVJ4zBKen4MthA1ujI/8C++sIpi9l0NEPo1b3drB5fognaZIlkKa9zVxfpv8E2MNEJ2ftoUc9PLsxjueEawPuL7e2ybCdhwErikhoRDR55Ag7NdyGZUUAGgvbRXI6X3CKn6siUr6rzjswgiZfWk4TLgZOKRQCQiIvXSED899x7liybbzHca+fx4vEYaCag8GtXLIjVxEUgo8NbG9Twar1G023k/u1rv7jTdp1au3oZ+UTgS8i76gMIMDQQ21mN1a/Oj6rDHqFxoUZY2nRmgU8V1SGktPSul3f2
 dXplo0pr
 wCfgmXBOaO06ac0pxW+ATmyAD7TaZL6NUC18l6MSsU6XxVa8cGrdVrErptkfkJRqwe/Dmrt5U5nUW1mtHToTvMnc31GM391lyDQ0zIIIeXauBqLaXrWyGc9EsVbWwNUFF12/v8Pvb+QkfyFzdMkSArgQGd9zgAQyEKc2gCSW2rODYTTWcD5YdWKOJk5D7wtht6HqpiaQr50JO6NXn5y8pzjaUmmfvAsq61dW13eELpMJQdZ8PgodVjLVGG5uDT8yDShRjpGZdThms/VQzSqs2AUSBZ/7p7Qj1mzID3jdva8Us8Hin4GpaB1ter43CULwnPOEhNtGiTviihlA4MzS+uswyLoRBXjcYxCkssYTIUQlW1M9CHV4ehFyH2XXuykck2guAKE3RGO9EDT6UK98lV4xIorn7uDENAA9wxuh8wv8xhpDSFxiLJ6gRtkmm33g9wS7j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 23:19, Gregory Price wrote:
> Existing callers of add_memory_driver_managed cannot select the
> preferred online type (ZONE_NORMAL vs ZONE_MOVABLE), requiring it to
> hot-add memory as offline blocks, and then follow up by onlining each
> memory block individually.
> 
> Most drivers prefer the system default, but the CXL driver wants to
> plumb a preferred policy through the dax kmem driver.
> 
> Refactor APIs to add a new interface which allows the dax kmem module
> to select a preferred policy.
> 
> Overriding the configured auto-online policy is only safe for known
> in-tree modules, where we know the override reflects a different,
> user-requested policy.  We do not want arbitrary out-of-tree drivers
> silently overriding the system-wide onlining policy, so restrict the
> new interface to the kmem module using EXPORT_SYMBOL_FOR_MODULES()
> rather than a plain EXPORT_SYMBOL_GPL().  Other in-tree modules (e.g.
> cxl_core) can be added to the allowed list as the need arises.
> 
> Refactor add_memory_driver_managed, extract __add_memory_driver_managed
> - Add proper kernel-doc for add_memory_driver_managed while refactoring
> - New helper accepts an explicit online_type.
> - New helper validates online_type is between OFFLINE and ONLINE_MOVABLE
> 
> Refactor: add_memory_resource, extract __add_memory_resource
> - new helper accepts an explicit online_type
> 
> Original APIs now explicitly pass the system-default to new helpers.
> 
> No functional change for existing users.
> 
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  include/linux/memory_hotplug.h |  3 ++
>  mm/memory_hotplug.c            | 61 +++++++++++++++++++++++++++++-----
>  2 files changed, 56 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index f059025f8f8b..d3edeb80aadb 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -294,6 +294,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>  extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>  extern int add_memory_resource(int nid, struct resource *resource,
>  			       mhp_t mhp_flags);
> +int __add_memory_driver_managed(int nid, u64 start, u64 size,
> +				const char *resource_name, mhp_t mhp_flags,
> +				enum mmop online_type);

We prefer two-tab indent on second parameter line while touching code / adding
new code.

Same applies to the other instances below.


Apart from that (still) LGTM.

-- 
Cheers,

David

