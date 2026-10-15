Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9467CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45BC36B0088; Thu, 15 Oct 2026 09:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D3C6B008A; Thu, 15 Oct 2026 09:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322C96B008C; Thu, 15 Oct 2026 09:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 037E66B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:05:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70EE0C052C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:05:34 +0000 (UTC)
X-FDA: 85324882188.15.C5A1AA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9D40A000E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:05:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X11q/hux";
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792069532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Noy49yD8e/Ob4wG2MgzxDSK75qjmJvYApwzUtIvu0QU=;
	b=iJxJze0lZpZBua1jyX1rczG182wxtIHNt7vnoQAOMG1uv1nE+UjZW4QL6r7EsF6z+awWQt
	AIn6MxoAM8r4nbvBpM0iE8+VpoZzKT2lBd9gD9Tx327JhAq6bXt+ExF9mUbc8Nl78sVdrD
	vl7GdlLbV+oFZTlobDDVNSKWMFAmqw8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792069532;
	b=5+d8tYOk0ewqHSMmx7J/vqiv/h77YL14pVZn20GPMIm3HHr+nrszmf8p+9ON+fqCMYZp5B
	sU8aa+rlhaNRX1+8mM++DaAdyMwFDV4fSl/9XPw1q2sRepkJg27KtVGetqam5yk4Sp18T+
	uEs1aS1JndG0NdJC/+aVkBtr1mbsjpo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X11q/hux";
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CA41601EF;
	Thu, 15 Oct 2026 13:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916351F000C4;
	Thu, 15 Oct 2026 13:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792069532;
	bh=Noy49yD8e/Ob4wG2MgzxDSK75qjmJvYApwzUtIvu0QU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=X11q/huxrkAqwJCmxammjG0KJNkKW/HeV7vwW/AZE/pVPt4r02Y8MELs228K0/yCY
	 /+HUXERfLkTuOSjrnt/oZ0WlpjAWRdzH/0AyNkiysGhZWcD+btWG0ZGi3IgB8Y3a1s
	 +S1i6BhGLSMoxQxdZCVvgZ2iwCxrkEk9yxuIKESop73gfhNF9Y0LiK2JkwxnLmx5nm
	 e6NeKBeY8eX4MVKjA912aq4LlTWdCrk3zgICGY5v5V/GbQlkSUvYxVAe/0iq4cy/MR
	 nBu9T2bXCvWVziYbkRCLhinBob0P6L5+NrhuTkinqc1qqIkdjaEqwbttACABcjlvBN
	 w0EuAS2t5oUAw==
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
Subject: Re: [RFC PATCH 2/3] luo: Export feature support to vmlinux section
In-Reply-To: <20260903023452.721732-3-loganodell@google.com> (Logan Odell's
	message of "Wed, 2 Sep 2026 19:34:51 -0700")
References: <20260903023452.721732-1-loganodell@google.com>
	<20260903023452.721732-3-loganodell@google.com>
Date: Thu, 15 Oct 2026 15:05:26 +0200
Message-ID: <2vxzv773glm1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9D40A000E
X-Stat-Signature: pcikfw35du6zoae5ts35xnuf5fx7y4ts
X-HE-Tag: 1792069532-801105
X-HE-Meta: U2FsdGVkX1/k8y90TJcdnOgiVv5fhOO3ZSVBAmtGmg4A2mNQlzOLphX053ouaFB3S/YD88I0nctehTngOgcJZg2QCjVQnpFHf7yf7Tp/UMONuY8Jply8uXBR/erRrmGCQPDdRNg79HZCoo5ZuUwrA6MkPspci+awwkIZzFJ0Z/mxHtp5BkEzADtgBrzF87lbSbABv6Wa2SFgV1LUiLPcc0ifNEJVy7M7bUZBjLhJ3MU0QZlzm0KgZ1xwoNonOKO8ORG2fzOHC9pLr5Tv+k979zNf48NqBDS9bXhVBwWO9/Gi6et10n7Z9QXE0uiJKjHhbrJMwNqlydzIJj5QohsANF+c35hr5y6FBsNiXkKNxehJpG/iSL3XC7lsEdstNrccA6VQXTd5hqQrb710WMm20WzUzTmMojK3S1y3CvI/xSH9MAOdbjeLxLgqOxVGudEvuTlPDrJu+OZd7/cgq7oI+ZMp8iwg0xOyOc9w+rFvpnHrGhiyZmFhPT5GU09VavELxOlcx4VFbMaStf6p+IGM4Hy/vn/6a2mhhnyIwEnL+l+JT90hh3Uzqeth2SFb/NTPxWWuZvaLkfC0b/IdoGqufAj23oF5B9e/5dSf6beeN7GU37n0t5bUlxRiB7qJJI9KZKKzxFlWxZcjsk2aq1qSjJXz59K8RQVASt8Of+eGG2eeuX5fm46Ayltt70LU82B6XEPW8ihoMlIT+aLoZ8alUJ0du9ddHLdy9vOLpf2i3H6vcZKI5FDt9fp47aW3I39a26THYM9ASCpgs86tiKrCMqwUyFjGbrR3TDYEGCzD1eUq/FI6B43O9MaE3aL6lSKYwmwLWLq1s6TnNEg7bryqSQEGXAkEdhZIB3Lhkhnk2dkCab+tRbXj3a9pCLHSXJo+ICJ+1CvxoDPfrVSzFmTMndVznFd201baLVbc4bXAvhWsyZ+YPpf+lvUkjTL3fjIEbCub/9YBmtsvTdsT5iG
 I1gvcpDu
 njWNzj+GsoqLXW0N6nB2/8pFyeSQNBSAbK0z4bUfRugz7RSY82g4OlpEWemoiFVD81j98FuKWI9x3QpGmiXK8r0e3jdqnxJkzcndtgTuDkfoR9+uKwv6G9oIs5Eq9iKs+PRwtOt6760rqa2zMq3u4HXUcg2hX9WlpRNN/u/mGr9/GTSljmohLGnGYZ2fI/A9+ocuI3LAuIA1xHRh6y+iAdIF1DhEA0SlcMb2kl2/c+2RXt1J2iPgwfNSnW559oYYLlAw9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Logan,

On Wed, Sep 02 2026, Logan Odell wrote:

> Create a liveupdate_features section that contains the feature
> information for a given liveupdate component. Add the LUO component
> first. These can be compared between two kernels to determine live
> update compatibility. Features marked as required in the running kernel
> will need to have that feature marked as supported in the next kernel to
> be eligible for compatibility.
>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Logan Odell <loganodell@google.com>

I was thinking about this a bit more. We don't really ship the vmlinux
directly. On x86 it is a PE/COFF image, on arm64 the Image format strips
ELF information and is a raw binary file.

So this information would not be accessible to the kexec loader/luod. So
perhaps as part of the build we parse the section and output a file with
the versions? And then it can be packaged with the likes of System.map
for example?

> ---
>  include/asm-generic/vmlinux.lds.h | 12 +++++++++++
>  include/linux/kho/abi/luo.h       | 34 +++++++++++++++++++++++++++++++
>  include/linux/liveupdate.h        | 12 +++++++++++
>  kernel/liveupdate/luo_core.c      | 16 +++++++++++++++
>  4 files changed, 74 insertions(+)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 5659f4b5a125..aed4e282a78c 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -359,6 +359,17 @@
>  #define THERMAL_TABLE(name)
>  #endif
>  
> +#ifdef CONFIG_LIVEUPDATE
> +#define LIVEUPDATE_FEATURES						\
> +	. = ALIGN(8);							\
> +	.liveupdate_features : AT(ADDR(.liveupdate_features) - LOAD_OFFSET) {	\
> +		KEEP(*(.liveupdate_sec_hdr))				\
> +		KEEP(*(.liveupdate_features))				\
> +	}
> +#else
> +#define LIVEUPDATE_FEATURES
> +#endif
> +
>  #define KERNEL_DTB()							\
>  	STRUCT_ALIGN();							\
>  	__dtb_start = .;						\
> @@ -554,6 +565,7 @@
>  	RO_EXCEPTION_TABLE						\
>  	NOTES								\
>  	BTF								\
> +	LIVEUPDATE_FEATURES						\
>  									\
>  	. = ALIGN((align));						\
>  	__end_rodata = .;
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 0a7662a0cf9a..5b25e1b48cf5 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -230,4 +230,38 @@ struct luo_flb_ser {
>  #define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
>  #endif
>  
> +#define LIVEUPDATE_VER_HDR_MAGIC	0x4c565550 /* 'LVUP' */
> +#define LIVEUPDATE_VER_HDR_VER		1
> +
> +/**
> + * struct liveupdate_ver_hdr - Header of vmlinux section with version lists
> + * @magic:     Magic number ('LVUP').
> + * @version:   Version of the header format.
> + *
> + * This struct is the header for the vmlinux section ".liveupdate_features". The
> + * section contains the list of feature/version entries that the kernel supports.
> + */
> +struct liveupdate_ver_hdr {
> +	u32 magic;
> +	u32 version;

Should we do feature flags along with the version to extend in
backwards-compatible way?

> +} __packed;
> +
> +/**
> + * struct liveupdate_feature_entry - Live update feature/version entry
> + * @name:       Name of the subsystem or feature ("luo" for core).
> + * @feat_bytes: Number of bytes covered by supp, req, and active bitmaps (e.g. 8).
> + * @reserved:   Reserved / padding for alignment.
> + * @supp:       Bitmask of supported features.
> + * @req:        Bitmask of required features.
> + * @active:     Bitmask of active features.
> + */

How should we model FLB dependencies here? And how do we export FLB
capabilities?

> +struct liveupdate_feature_entry {
> +	char name[LIVEUPDATE_HNDL_COMPAT_LENGTH];
> +	u32 feat_bytes;
> +	u32 reserved;
> +	u64 supp;
> +	u64 req;
> +	u64 active;
> +} __packed;
> +
>  #endif /* _LINUX_KHO_ABI_LUO_H */
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 6051abc0612c..e058df23fed1 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -229,6 +229,16 @@ struct liveupdate_flb {
>  
>  #ifdef CONFIG_LIVEUPDATE
>  
> +#define LIVEUPDATE_FEATURE_ENTRY(_id, _name, _supp, _req, _active)	\
> +	static const struct liveupdate_feature_entry __lu_feat_##_id	\
> +	__used __section(".liveupdate_features") __aligned(8) = {	\
> +		.name       = _name,					\
> +		.feat_bytes = sizeof(u64),				\
> +		.supp       = (_supp),					\
> +		.req        = (_req),					\
> +		.active     = (_active),				\
> +	}
> +
>  /* Return true if live update orchestrator is enabled */
>  bool liveupdate_enabled(void);
>  
> @@ -259,6 +269,8 @@ int liveupdate_get_token_outgoing(struct liveupdate_session *s,
>  
>  #else /* CONFIG_LIVEUPDATE */
>  
> +#define LIVEUPDATE_FEATURE_ENTRY(_id, _name, _supp, _req, _active)
> +
>  static inline bool liveupdate_enabled(void)
>  {
>  	return false;
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index 6add1ecc463f..27413f895174 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -64,6 +64,22 @@
>  #include "kexec_handover_internal.h"
>  #include "luo_internal.h"
>  
> +/*
> + * This is the header for the ".liveupdate_features" section in vmlinux.
> + * The linker makes sure that this header precedes the entries.
> + */
> +static const struct liveupdate_ver_hdr ver_hdr
> +	__used __section(".liveupdate_sec_hdr") __aligned(8) = {
> +	.magic   = LIVEUPDATE_VER_HDR_MAGIC,
> +	.version = LIVEUPDATE_VER_HDR_VER,
> +};
> +
> +/* Core LUO features */
> +LIVEUPDATE_FEATURE_ENTRY(luo_core, "luo",
> +			 LUO_CORE_FEATURES_SUPP,
> +			 LUO_CORE_FEATURES_REQ,
> +			 LUO_CORE_FEATURES_ACTIVE);
> +
>  static struct {
>  	bool enabled;
>  	struct luo_ser *luo_ser_out;

-- 
Regards,
Pratyush Yadav

