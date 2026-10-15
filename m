Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C263DCC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 12:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C546B0088; Thu, 15 Oct 2026 08:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43B16B0092; Thu, 15 Oct 2026 08:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31F46B0095; Thu, 15 Oct 2026 08:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7EF6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:21:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20999A0A0E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:21:10 +0000 (UTC)
X-FDA: 85324770300.05.D88348E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 82C8040006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:21:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/IWRFaq";
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792066868;
	b=FMVsB6Ng4MBh9NWtt331kHbXN1gFfa1Hc3ZoJiwhIRVEkby2WvHqr0/OZcMnFSPPhSEqCa
	tx9xrz5houf7/TzM2jfGr/rTVslPS4JIrronRhlHecU7+zfeeHDJe2pLGIJrGRsVKeNOGP
	kVj+5QVrawo2ynuOP5WRbLzEdBFSJf4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/IWRFaq";
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792066868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NT2XbSQZp+cU7Cn4WzI+ruP1eafbyQ8K/6l27WXBHEs=;
	b=tmBUj6HLd4YNnS9DLy2/s3cAjrIADH7P19Kuf6NNo/tNmmT8QJfL7Y5lu555Du0Yl9ZMCn
	IPRKiHhHesVCnfHeRvRkBFwzfe7cBr1e/ysKKrNr4boShIHB66nnIJPOVEDHNtkY3q/6nd
	Bw7x6wMlSGxpuy5CjjXtz71D/ES1CqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41C446022A;
	Thu, 15 Oct 2026 12:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EC01F000C4;
	Thu, 15 Oct 2026 12:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792066867;
	bh=NT2XbSQZp+cU7Cn4WzI+ruP1eafbyQ8K/6l27WXBHEs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=h/IWRFaq4vA9PtvjP61helCdett9RPb6ElPn1qf8Rmx5VpDLIOMyGhWQAl4AqqKq+
	 pB9w4hUWwxUkgv7/VeC0aZVKq9gdMDTq1n2jzH73aVJymY1ba6j+HH3nC2w+JnRWfP
	 J/XrSzZfsKbPodI48N6DSA9Yb0XQdOJMGHYmJVkayrGuaOz3JooD3sWwdBBHavaILA
	 bKBaModR4Pm4+rMEHP/D90IGF8JbG20dewHhOZ57o9qZV+YyTHpkK9Gfbgra4+3wY7
	 2SVGgT++KvPbARS5XSpKpJnpe4RgDExOgFfx1DDZs7YOPRzn4E8/oMgNCptt+DygU9
	 3UDbtQYkvuaew==
From: Pratyush Yadav <pratyush@kernel.org>
To: Logan Odell <loganodell@google.com>
Cc: arnd@arndb.de,  pasha.tatashin@soleen.com,  rppt@kernel.org,
  pratyush@kernel.org,  graf@amazon.com,  akpm@linux-foundation.org,
  pbonzini@redhat.com,  maz@kernel.org,  oupton@kernel.org,
  seanjc@google.com,  bhelgaas@google.com,  alex@shazbot.org,
  jgg@nvidia.com,  kevin.tian@intel.com,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  joro@8bytes.org,  will@kernel.org,
  robin.murphy@arm.com,  linux-arch@vger.kernel.org,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  kvm@vger.kernel.org,
  linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  iommu@lists.linux.dev
Subject: Re: [RFC PATCH 1/3] luo: Move to feature flags instead of
 compatibility strings
In-Reply-To: <20260903023452.721732-2-loganodell@google.com> (Logan Odell's
	message of "Wed, 2 Sep 2026 19:34:50 -0700")
References: <20260903023452.721732-1-loganodell@google.com>
	<20260903023452.721732-2-loganodell@google.com>
Date: Thu, 15 Oct 2026 14:21:01 +0200
Message-ID: <2vxzzewfgno2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82C8040006
X-Rspam-User: 
X-Stat-Signature: j4sx3rudwaxitbnamfhd4ygsx5sh51e4
X-HE-Tag: 1792066868-441281
X-HE-Meta: U2FsdGVkX1/g3DUxZykNdsPn+eIVLwGXC6h7h75e4RS1b4R53DjypUrJVio+7D76dBpV/3N6oKLcGcTo+sJ/uNXOZmJlmVJFrd49+SwWC1sFSxFZIh3VEw+exdWX9Duftzoz1LL2SP+7C8/+QKLqlW4JGbNwBw5Y9Q76fc4XuZpY0elR3WRmXZ3LgsO5fuzZT6yFNcgQSvxK+CJuwPELDY7MbbPrtjw0RW+2M3S2eDQkmGseLU6XEYZzjwtYEtD1u6PjDn2m7TcUVB8uQpWn5Lucq3R0sJVlNGh5tPTt87+oxbZhb+VRRP5LyESdU8NT1u+TFmR/F1vs8lwCephvo7LZMJQq8J+mJOF6b6K7H1eYba5Qdmgs83itii817g7Nhwx8W7RGbdQF6FG6sF3vj0PshAPAylAHLW4+IItWEb3CAUy9AAUBb89OK/PDnt8Lxknld1slVfR4DaHxVqgJvRK4CGXiejDBzVPjBIoc0P++eUAhB6WK88VrCYbn3qg02qfJkS1nvkH74owEYGlVP7ZLlrxEpT65r2zvMRaiO1XJcQS8zez0jFXYKtUB/cLr+U0vnYWXYamEmfgrViJQ3AY4ryNwuuJuE6RtFIabQ6XGuJXVt7xVDQJDNFtXaQxM7ZEccbt/pk/MKFGLaqbLlzw/+1OMIXzNNTk7biAKPmYeUN0D0lKdoBBErijkMLwYIfJKb5b+dDq++x1mDHk17+0dVPxJSpFSdwFkYDCbQjsMaGseNWbvci7OHqCWNFLFN+pfgQeOJuX0RqTR0XB7gpVB42GDq+0SwI5vlrRdrZc7zYp7pSU4tvnLaVRWpsPjk1Xn9xnQN8o3uAOFvlomt0/nRMSRn2SjFnHjas0hggenCwNsLujsEBzkZJ0r/dPW0/OK3TAoqLvITmxXAF6YfpZN5EXsVPUUBCpx1FkqKGQCA33f/W71Lud3gaiIuODslwrUP066Fs90d65Xopm
 svSP8E19
 gKL1GO3LRaJf6pn3upEW2uQPErlOK8Dbk2k4Vmyfm7kTocAoiqgu3wyuHsd7/dXg/HwcEI4Fk9hHSlg6OX7YLliKqeQAJuygTvoewDdz0ALAl3AJlZHozzKTy+L+2TL92mrFpQWrrkH6fV1tyrKou9BR6aeWHEPkA3JcQLb9dy7TliTaCnjesjy3P3h4c9teDqIRN6Fr0ZwsjUs3kD1a5FMNhpxclPjHIqEqxpdGpCWLXOms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Logan,

On Wed, Sep 02 2026, Logan Odell wrote:

> Define a 128 byte header that can be used by all live update serialized
> structures. In this header, we reserve room for 64 features with
> supported, active, and required bits. Update the top level luo struct to
> use this instead of compatibility strings. Previous versions of the
> struct had smaller sizes, so add a minimum size check to avoid
> collisions with older kernels.
>
> Signed-off-by: Logan Odell <loganodell@google.com>
> ---
>  include/linux/kho/abi/luo.h  | 74 +++++++++++++++++++++++++++++-------
>  kernel/liveupdate/luo_core.c | 44 +++++++++++++--------
>  2 files changed, 90 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 288076de6d4a..0a7662a0cf9a 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -13,15 +13,17 @@
>   * kernel. The ABI is built upon the Kexec HandOver framework and registers
>   * the central `struct luo_ser` via the KHO raw subtree API.
>   *
> - * This interface is a contract. Any modification to the structure fields,
> - * compatible strings, or the layout of the `__packed` serialization
> - * structures defined here constitutes a breaking change. Such changes require
> - * incrementing the version number in the relevant `_COMPATIBLE` string to
> - * prevent a new kernel from misinterpreting data from an old kernel.
> + * This interface is a contract. To ensure the stability of moving between
> + * kernel versions, any changes to the structures should only be additive
> + * and should utilize the feature flags to denote the supported, active, and
> + * required status of the feature.
> + *
> + * Features that are entirely optional can be added with the supported and
> + * active flags both asserted, and the required flag cleared. Features that
> + * require that the next kernel supports the feature should only be added as
> + * supported to allow compatible transition kernels. At a later time, the
> + * active and required flag should be asserted.
>   *
> - * Changes are allowed provided the compatibility version is incremented;
> - * however, backward/forward compatibility is only guaranteed for kernels
> - * supporting the same ABI version.
>   *
>   * KHO Structure Overview:
>   *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
> @@ -30,7 +32,7 @@
>   * Serialization Structures:
>   *   - struct luo_ser:
>   *     The central ABI structure that contains the overall state of the LUO.
> - *     It includes the compatibility string, the liveupdate-number, and pointers
> + *     It includes the feature flags, the liveupdate-number, and pointers
>   *     to sessions and FLBs.
>   *
>   *   - struct luo_session_ser:
> @@ -58,19 +60,65 @@
>  #define _LINUX_KHO_ABI_LUO_H
>  
>  #include <linux/align.h>
> +#include <linux/bits.h>
>  #include <linux/kho/abi/block.h>
>  #include <uapi/linux/liveupdate.h>
>  
> +/**
> + * struct luo_feature_hdr - Feature negotiation and versioning header.
> + * @supp:     Bitmask of features supported by the producing subsystem.
> + * @req:      Bitmask of features required for safe deserialization by the
> + *            receiving subsystem.

I think you are mixing two things here: description of the payload and
description of the file handler capability.

The payload that is handed over via KHO should have the active and
required bitmasks only. It doesn't need the supported bitmask, because
it doesn't matter what the handler that produced the payload supports.
It only matters what fields it populated and which ones are mandatory to
understand.

Similarly, the description of the file handler can't really describe
"active". Because the capabilities are static and the active bits will
depend on a specific file.

So I reckon we should separate these two. These should be the same bits
of course, but expressed in two ways in two different places.

> + * @active:   Bitmask of features actually active/used in the serialized payload.
> + * @reserved: Reserved for future use.
> + *
> + * This header can be embedded at the beginning of any serialized structure to
> + * provide forward and backward compatibility via feature negotiation across
> + * live update.
> + */
> +struct luo_feature_hdr {
> +	u64 supp;
> +	u64 req;
> +	u64 active;
> +	u64 reserved[13];

How do you plan to ever use this? Say I want to extend my bitmaps so I do:

    struct luo_feature_hdr {
    	u64 supp;
    	u64 req;
    	u64 active;
    	u64 supp2;
    	u64 req2;
    	u64 active2;
    	u64 reserved[10];

But when I go back to a kernel that doesn't know about supp2, req2,
etc., how does it know how to interpret these? How does it know what the
values mean?

Is your goal only to be able to extend the three types of flags we have?
If so, perhaps something like "if bit 63 is set, the flags continue to
the next u64"? It is certainly harder for the parser, but seems to at
least be extensible. What do you think?

> +} __packed;
> +
> +#define LUO_FEATURE_ACTIVE(s, f)		\
> +	do {					\
> +		(s)->features.supp |= (u64)(f);	\
> +		(s)->features.active |= (u64)(f);	\
> +	} while (0)
> +#define LUO_FEATURE_SUPPORTED(s, f)	((s)->features.supp |= (u64)(f))
> +#define LUO_FEATURE_REQUIRED(s, f)	((s)->features.req |= (u64)(f))
> +#define LUO_FEATURE_IS_ACTIVE(s, f)	(!!((s)->features.active & (u64)(f)))
> +#define LUO_FEATURE_IS_SUPPORTED(s, f)	(!!((s)->features.supp & (u64)(f)))
> +#define LUO_FEATURE_IS_REQUIRED(s, f)	(!!((s)->features.req & (u64)(f)))
> +
>  /*
>   * The LUO state is registered under this KHO entry name.
>   */
>  #define LUO_KHO_ENTRY_NAME	"LUO"
> -#define LUO_ABI_COMPATIBLE	"luo-v5"
> -#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
> +
> +/*
> + * Bits associated with the luo_feature_hdr values.
> + */
> +#define LUO_FEATURE_NUMBER    BIT_ULL(0)
> +#define LUO_FEATURE_SESSIONS  BIT_ULL(1)
> +#define LUO_FEATURE_FLBS      BIT_ULL(2)

Nit: please give the flags full documentation on their semantics.

> +
> +#define LUO_CORE_FEATURES_SUPP		(LUO_FEATURE_NUMBER | \
> +					 LUO_FEATURE_SESSIONS | \
> +					 LUO_FEATURE_FLBS)
> +#define LUO_CORE_FEATURES_REQ		(LUO_FEATURE_NUMBER | \
> +					 LUO_FEATURE_SESSIONS | \
> +					 LUO_FEATURE_FLBS)
> +#define LUO_CORE_FEATURES_ACTIVE	(LUO_FEATURE_NUMBER | \
> +					 LUO_FEATURE_SESSIONS | \
> +					 LUO_FEATURE_FLBS)
>  
>  /**
>   * struct luo_ser - Centralized LUO ABI header.
> - * @compatible:     Compatibility string identifying the LUO ABI version.
> + * @features:       Bit mask of supported and active features.
>   * @liveupdate_num: A counter tracking the number of successful live updates.
>   * @sessions_pa:    Physical address of the first session block header.
>   * @flbs_pa:        Physical address of the FLB header.
> @@ -78,7 +126,7 @@
>   * This structure is the root of all preserved LUO state.
>   */
>  struct luo_ser {
> -	char compatible[LUO_ABI_COMPAT_LEN];
> +	struct luo_feature_hdr features;

Do we still need compatible here? How will we ever do breaking changes
if we really need to?

>  	u64 liveupdate_num;
>  	u64 sessions_pa;
>  	u64 flbs_pa;
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index 1b2bda22902d..6add1ecc463f 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -107,26 +107,37 @@ static int __init luo_early_startup(void)
>  		return 0;
>  	}
>  
> -	if (len < sizeof(*luo_ser)) {
> -		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
> -		return -EINVAL;
> +	luo_ser = phys_to_virt(luo_ser_phys);
> +
> +	if (len < sizeof(struct luo_feature_hdr)) {
> +		pr_err("LUO state is too small (%zu < %zu)\n",
> +		       len, sizeof(struct luo_feature_hdr));
> +		err = -EINVAL;
> +		goto out_free_ser;
>  	}
>  
> -	luo_ser = phys_to_virt(luo_ser_phys);
> -	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
> -		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
> -		return -EINVAL;
> +	if (luo_ser->features.req & ~LUO_CORE_FEATURES_SUPP) {
> +		pr_err("Unsupported required LUO feature (req: 0x%llx, supp: 0x%llx)\n",
> +		       luo_ser->features.req, (u64)LUO_CORE_FEATURES_SUPP);
> +		err = -EOPNOTSUPP;
> +		goto out_free_ser;
>  	}
>  
> -	luo_global.liveupdate_num = luo_ser->liveupdate_num;
> -	pr_info("Retrieved live update data, liveupdate number: %lld\n",
> -		luo_global.liveupdate_num);
> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_NUMBER)) {
> +		luo_global.liveupdate_num = luo_ser->liveupdate_num;
> +		pr_info("Retrieved live update data, liveupdate number: %lld\n",
> +			luo_global.liveupdate_num);
> +	}
>  
> -	err = luo_session_setup_incoming(luo_ser->sessions_pa);
> -	if (err)
> -		goto out_free_ser;
>  
> -	luo_flb_setup_incoming(luo_ser->flbs_pa);
> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_SESSIONS)) {
> +		err = luo_session_setup_incoming(luo_ser->sessions_pa);
> +		if (err)
> +			goto out_free_ser;
> +	}
> +
> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_FLBS))
> +		luo_flb_setup_incoming(luo_ser->flbs_pa);
>  
>  	err = 0;
>  
> @@ -162,7 +173,10 @@ static int __init luo_state_setup(void)
>  		return PTR_ERR(luo_ser);
>  	}
>  
> -	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
> +	luo_ser->features.supp = LUO_CORE_FEATURES_SUPP;
> +	luo_ser->features.req = LUO_CORE_FEATURES_REQ;
> +	luo_ser->features.active = LUO_CORE_FEATURES_ACTIVE;
> +
>  	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
>  
>  	luo_session_setup_outgoing(&luo_ser->sessions_pa);

-- 
Regards,
Pratyush Yadav

