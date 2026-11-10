Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A7060A260B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Bmkgb8Wb
Received: by kanga.kvack.org (Postfix)
	id 3E0B26B05B0; Tue, 10 Nov 2026 12:28:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8116B05B4; Tue, 10 Nov 2026 12:28:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF276B05C6; Tue, 10 Nov 2026 12:28:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3FD26B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:28:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85F1A809F9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:28:19 +0000 (UTC)
X-FDA: 85419893118.26.6EA3605
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf08.hostedemail.com (Postfix) with ESMTP id CACA8160003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:28:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Bmkgb8Wb;
	spf=pass (imf08.hostedemail.com: domain of 3L1TzagkKCAQxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3L1TzagkKCAQxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794331697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yZhs6ZDC6QJyZznmfCr4E8e0ia6+c834e+dfc1J9VY=;
	b=MOd6Vxv8oCEvR49zjcRwOBx2ub+7AsusREE3wSgoo4K9NhybPcZR0yv7xswRkuHo7PhGh6
	YHWvacJYN5F3cqeabd7hxIb1DKTg8G41JMe6QJbjPV+6/h3tqytbHf9/SWLrVp9K3X1/m8
	m9oA8vU0mzg+77a6xSEjH6xdM1Tf6FQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794331697;
	b=78dGLxRQDYBN1Ll3c2gYJKj1Vp5GvtVhxzLgLMv97I7Ibj61tJ53OTfp1ltd7yjwWc25RJ
	whpZU0PzEgLOcn8AJaye0bmd1WEpYiKt0nHUnry/Bopjuqn9WXipSYYAUkjcE6n4syyKKu
	WGOpXEi0jzS27CWX7d5rJLRI/Lxl9S0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Bmkgb8Wb;
	spf=pass (imf08.hostedemail.com: domain of 3L1TzagkKCAQxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3L1TzagkKCAQxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c4163a5400eso49360466b.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794331696; x=1794936496; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+yZhs6ZDC6QJyZznmfCr4E8e0ia6+c834e+dfc1J9VY=;
        b=Bmkgb8Wb2le8Ts+6frfMk6CAQJm3Ct6XyLWQRHVCGy1Kr+sMPkL59/fYlTkFj/p7GO
         tk+4+tSapJndupYlINaWrZVAKSDzeniT1Jt4bmjb6PeOSOtWJAjUGaSNDMUOo/WhL1Ne
         ymBofd6YvF6Z4cyzc8b2pYp2+Jg9PgQ6h5mp03Xk+y8SoMtr0ieuoecHTVesqiJ5n2L1
         Nor4JmkuHowAtzSQD0VqBB0eovuj9Q5VCMj+vbNrlNmcOd8TEuYbiKfYHzbMIyA1VB8V
         PdgDe8PjZBfjaoP9wvALp8ztdYq3UrhA/ybIfmV2T9X88TZdeZLkjO77E+vC/iR/HKMu
         aNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794331696; x=1794936496;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+yZhs6ZDC6QJyZznmfCr4E8e0ia6+c834e+dfc1J9VY=;
        b=J25CFHipZOnk/GpkEtnEcPkW/wglGlQ+C7CX8MkfSx0GiwIsOr5vehADU+OCqILS7T
         iVQSLeqSrhBn2Pciemjj9R14GEP2aNgnjHGo0d7IxoYTFVO0izMANflyMXjbkaqFBYnh
         2Ege481xoWv/3TvRNioQX8qtlE5ptbMRnItc52jjFGpUFx6B4/r5MXi9N1tP9FwrXerA
         TG3u4kJtC8oizF9+lDl1IjKsp+0nS0qwR0FDXL/syUxONJ6HinLSUQ0sSywAR2iK0b7m
         E7iM/jeVYxDPEF40jwCAImKQ14y6W8TXbdqBVXaFQ6hhAKc/4ZYereLN3cOQcAowgfYo
         9VkA==
X-Forwarded-Encrypted: i=1; AL+hErEiBnV1+HhW7ObKYJJpCBqEJyJQBAmPganK9MxGuseW3A08BP7aN9L0ZzyCz3iw9/7RnoacdEwPYQ==@kvack.org
X-Gm-Message-State: APuU4Z+1bQbur9wB1c5fDrgObVle95QLmn7SbUWTjjKG+2V06cNS1t3U
	kDewg/ci4lTFOnWaWM5rIHzK5ApHHayVcipQtZ8oXEMCIb36ohAqOV11MQIjtxIzYa0b9VbkM7x
	c1p/cRFvKAg+vRDDGdg==
X-Received: from ejrk24.prod.google.com ([2002:a17:906:6818:b0:c46:7e9b:6a1c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:dc91:b0:c41:1781:a2af with SMTP id a640c23a62f3a-c506338c761mr23579166b.9.1794331695882;
 Tue, 10 Nov 2026 09:28:15 -0800 (PST)
Date: Tue, 10 Nov 2026 17:28:14 +0000
In-Reply-To: <DMRJQ42LR1D3.1GZKU9EX48KZU@soleen.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-2-tarunsahu@google.com>
 <DMRJQ42LR1D3.1GZKU9EX48KZU@soleen.com>
Message-ID: <9huzbj7wtx3l.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 01/19] liveupdate, kho: Remove __packed from KHO, LUO
 and memfd ABI structures
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fq6t7kcuerih9upmkd1ikcgtm8gz1qxs
X-Rspamd-Queue-Id: CACA8160003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794331697-82572
X-HE-Meta: U2FsdGVkX19UDswyCp3vDPSbCo6yIItROoQFQ4RxpdsNVusKz7WEuqsg+TbkNBjKdtBrcQi8R+/VmnLq4n1GFF9nbNbEM1PmWWa/96AZX3xUHTXLzhaS0nk+NF52EK7dmG9yIjHqVn+g+bEIHRdqSHXaz/mRqgF5fxUjvlxpzTReWkyi03ra6Yq1oxZg4BHciCVxrpdaXjF7gej5dkxoxyJbnzJh9nxgo7EvNxp0PnuDv2j7nElRnKIqdQEA7FjqRx5CUSFACpvSBz5D3S9AuxemigPSHXhB5+GErKtwxzBlYq/6CnOo/mdHbEBIgiJHb+lWdTSV3jaUddGDe5l+ixyszX2JhG7lwQdevu0Xd7VuolFKVMNyfhJDZmhPipPiYCwtQFo8lsULd9W8xymOxADBnEWkxbuYBNrrUFPF4e+b4KNHfrAs4VSPP3jkRiAiHa5p1n3GtCvzxBVV8FlVQrrFZoJSPdNOH36W4VelLMIut/VaSy+S5Y2OhGnx6oX+ewQZFGgEUTu4XQYLdDiHQ4KBYxh7Vb5phUSuQqhJrgHk/zf5G2wepPnfRanh343vuzv5msoMLTH6Dm7hEsDjhZOmVMIZg55Z5qsFLOSiCAXPRcp1ErosbBmHHHdfCxeFT9wgbixbOAC8QCCTnzqZAz2nCzo1E8epPq2G6sczWn2shRs6nF5YfSPwVDW7VCSrLYCkacJICConnjVV0MGAGsIWhd8b+vCm2ktWDuMvPMcxYteoP0CBh8cUBSi4CqzY3FC/nDyHrt4gKX3JWhN8V+uYvxUrN7FRqzTxKSW1ryCgG5xB4VRr06qR2F5koHHdIVh2L2qHh/7xoJeUWZpdE48nyqYq0VRX2i9n0BhsJmu0sq/gifki2RRymlHiFs3izVD6Z/LjXQQcmcY3vYLLG6MQE7pVR2pEuYFe/eEXlHTxKnzRjUsbyfCh8YFnp7zWlmdoSauLf8KyusHfbxT
 C8exaW0o
 dDTQuGC4gdt2iuhf0na8LsAbzMZr227oKWiPVDQzZP1gZO+CaLt/4hgxwWJP1w5lTRb+nwy6wEKINvDCl3AUyor/NFJMJSAbbm3VOnfDWK4Kl4hKFXYVwMZG6pQike2hoqNxAwCMf59VNHYibWCiMBNtmSjhBonUlWFgGr7qZEmfnJPLMp9wIQ8oE7y1MiwEOMKLHYISVSiKf2jI7aLFJSbvXNxRpOll1J4j1p4Y3Pt2B8aOdEYJ5Uc97dNJGzP1heqy+jgmcP1YhEe0avBlVUvZ9MC/Tzr6pa9zYSVJZBvad8vgJrp69hAYU6A26vxvbILcJ5BMGa7RmpGIWSFDLB1AdwW5z8+cmltvFaJyaJ2oZdtsvn6NztfOLEbdqv5SdoQ87saH9z11RUgh3SeuEDwZeysSA/aaSlr+y3LkSGsLq+dnRdxHTlHQoz92ErjjqrY8jGCDuzuQE8xb7Ioxu1Q97SwyIRbyOyU9bP4e9jTCH8n493ttasXr2LVpsjkSTNdt+22llutXYGXMoECxNF84XCnuEvvlM2nM3YhwK3MC5SZFcoi4Xv3VR3UPk0p/4jLtiWkcrs0aLF6zhIKhXAMzYdk5jzseeihwlge9MBPqwLd8+7GBnO++XOCc/vaTt9tEABwC7lmOoa4AomUAhoDEB2vMnNgX7WusODWxpwP4toH8DvugdPKA88oz2oltmFMd1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Pasha Tatashin" <pasha.tatashin@soleen.com> writes:

> On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
>> All structures in include/linux/kho/abi/block.h (struct
>> kho_block_header_ser), include/linux/kho/abi/luo.h (struct luo_ser,
>> struct luo_file_ser, struct luo_file_set_ser, struct luo_session_ser,
>> struct luo_flb_header_ser, struct luo_flb_ser) and
>> include/linux/kho/abi/memfd.h (struct memfd_luo_folio_ser, struct
>> memfd_luo_ser) have naturally aligned fields on 64-bit architectures,
>> with no padding holes between fields or tail padding. Assert both the
>> structure size and 8-byte alignment under CONFIG_64BIT at compile time.
>> Any future unaligned field addition should come with reserved field to
>> keep the structure aligned.
>
> Just state:
>
> Remove __packed, as it may break natural alignment. Instead, ensure that 
> all padding holes are explicitly covered by reserved or similar fields, 
> as is already done for KHO/LUO serialized data, so no functional changes 
> are intended by this change.

This look good. I will update it. Thanks.

>
>>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  include/linux/kho/abi/block.h | 10 +++++++--
>>  include/linux/kho/abi/luo.h   | 38 +++++++++++++++++++++++++++++------
>>  include/linux/kho/abi/memfd.h | 16 ++++++++++++---
>>  3 files changed, 53 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
>> index d06d64b963be..36bdbaf9b3b8 100644
>> --- a/include/linux/kho/abi/block.h
>> +++ b/include/linux/kho/abi/block.h
>> @@ -12,7 +12,7 @@
>>   * pre-update kernel to a post-update kernel.
>>   *
>>   * This interface is a contract. Any modification to the structure fields,
>> - * compatible strings, or the layout of the `__packed` serialization
>> + * compatible strings, or the layout of the serialization
>>   * structures defined here constitutes a breaking change. Such changes require
>>   * incrementing the version number in the `KHO_FDT_COMPATIBLE` string to
>>   * prevent a new kernel from misinterpreting data from an old kernel.
>> @@ -26,6 +26,8 @@
>>  #define _LINUX_KHO_ABI_BLOCK_H
>>  
>>  #include <asm/page.h>
>> +#include <linux/build_bug.h>
>> +#include <linux/kconfig.h>
>>  #include <linux/types.h>
>>  
>>  /**
>> @@ -49,6 +51,10 @@
>>  struct kho_block_header_ser {
>>  	u64 next;
>>  	u64 count;
>> -} __packed;
>> +};
>> +
>> +static_assert(sizeof(struct kho_block_header_ser) == 16);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct kho_block_header_ser) == 8);
>>  
>>  #endif /* _LINUX_KHO_ABI_BLOCK_H */
>> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
>> index 288076de6d4a..721949374fa1 100644
>> --- a/include/linux/kho/abi/luo.h
>> +++ b/include/linux/kho/abi/luo.h
>> @@ -58,6 +58,8 @@
>>  #define _LINUX_KHO_ABI_LUO_H
>>  
>>  #include <linux/align.h>
>> +#include <linux/build_bug.h>
>> +#include <linux/kconfig.h>
>>  #include <linux/kho/abi/block.h>
>>  #include <uapi/linux/liveupdate.h>
>>  
>> @@ -82,7 +84,11 @@ struct luo_ser {
>>  	u64 liveupdate_num;
>>  	u64 sessions_pa;
>>  	u64 flbs_pa;
>> -} __packed;
>> +};
>> +
>> +static_assert(sizeof(struct luo_ser) == 32);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct luo_ser) == 8);
>
> Please remove the two assertions above throughout this patch, as they 
> are replaced later in the series. In general, introducing add -> remove 
> -> add churn across a patch series is discouraged, as it indicates a 
> lack of planning.

Got it. Will remove it.

~Tarun

>
>>  
>>  #define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
>>  
>> @@ -98,7 +104,11 @@ struct luo_file_ser {
>>  	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
>>  	u64 data;
>>  	u64 token;
>> -} __packed;
>> +};
>> +
>> +static_assert(sizeof(struct luo_file_ser) == 64);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct luo_file_ser) == 8);
>>  
>>  /**
>>   * struct luo_file_set_ser - Represents the serialized metadata for file set
>> @@ -113,7 +123,11 @@ struct luo_file_ser {
>>  struct luo_file_set_ser {
>>  	u64 files;
>>  	u64 count;
>> -} __packed;
>> +};
>> +
>> +static_assert(sizeof(struct luo_file_set_ser) == 16);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct luo_file_set_ser) == 8);
>>  
>>  /**
>>   * struct luo_session_ser - Represents the serialized metadata for a LUO session.
>> @@ -131,7 +145,11 @@ struct luo_file_set_ser {
>>  struct luo_session_ser {
>>  	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
>>  	struct luo_file_set_ser file_set_ser;
>> -} __packed;
>> +};
>> +
>> +static_assert(sizeof(struct luo_session_ser) == 80);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct luo_session_ser) == 8);
>>  
>>  /* The max size is set so it can be reliably used during in serialization */
>>  #define LIVEUPDATE_FLB_COMPAT_LENGTH	48
>> @@ -152,7 +170,11 @@ struct luo_session_ser {
>>  struct luo_flb_header_ser {
>>  	u64 pgcnt;
>>  	u64 count;
>> -} __packed;
>> +};
>> +
>> +static_assert(sizeof(struct luo_flb_header_ser) == 16);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct luo_flb_header_ser) == 8);
>>  
>>  /**
>>   * struct luo_flb_ser - Represents the serialized state of a single FLB object.
>> @@ -175,7 +197,11 @@ struct luo_flb_ser {
>>  	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
>>  	u64 data;
>>  	u64 count;
>> -} __packed;
>> +};
>> +
>> +static_assert(sizeof(struct luo_flb_ser) == 64);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct luo_flb_ser) == 8);
>>  
>>  /* Kernel Live Update Test ABI */
>>  #ifdef CONFIG_LIVEUPDATE_TEST
>> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
>> index 08b10fea2afc..376a724a1d8c 100644
>> --- a/include/linux/kho/abi/memfd.h
>> +++ b/include/linux/kho/abi/memfd.h
>> @@ -11,6 +11,8 @@
>>  #ifndef _LINUX_KHO_ABI_MEMFD_H
>>  #define _LINUX_KHO_ABI_MEMFD_H
>>  
>> +#include <linux/build_bug.h>
>> +#include <linux/kconfig.h>
>>  #include <linux/types.h>
>>  #include <linux/kho/abi/kexec_handover.h>
>>  
>> @@ -20,7 +22,7 @@
>>   * memfd uses the ABI defined below for preserving its state across a kexec
>>   * reboot using the LUO.
>>   *
>> - * The state is serialized into a packed structure `struct memfd_luo_ser`
>> + * The state is serialized into `struct memfd_luo_ser`
>>   * which is handed over to the next kernel via the KHO mechanism.
>>   *
>>   * This interface is a contract. Any modification to the structure layout
>> @@ -54,7 +56,11 @@ struct memfd_luo_folio_ser {
>>  	u64 pfn:52;
>>  	u64 flags:12;
>>  	u64 index;
>> -} __packed;
>> +};
>> +
>> +static_assert(sizeof(struct memfd_luo_folio_ser) == 16);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct memfd_luo_folio_ser) == 8);
>>  
>>  /*
>>   * The set of seals this version supports preserving. If support for any new
>> @@ -85,7 +91,11 @@ struct memfd_luo_ser {
>>  	u32 flags;
>>  	u64 nr_folios;
>>  	struct kho_vmalloc folios;
>> -} __packed;
>> +};
>> +
>> +static_assert(sizeof(struct memfd_luo_ser) == 48);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct memfd_luo_ser) == 8);
>>  
>>  /* The compatibility string for memfd file handler */
>>  #define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
>
> -- 
> Pasha

