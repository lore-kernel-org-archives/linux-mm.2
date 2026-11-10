Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C94260A262F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Zc8Ypb8E
Received: by kanga.kvack.org (Postfix)
	id 395C26B05CA; Tue, 10 Nov 2026 07:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D5A6B05CB; Tue, 10 Nov 2026 07:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2832C6B05CC; Tue, 10 Nov 2026 07:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED7996B05CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:56:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85991A0558
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:56:46 +0000 (UTC)
X-FDA: 85419208812.11.880AB95
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 979B780005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:56:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Zc8Ypb8E;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315404;
	b=hIUlacHQlXzWz8/hY32uqpi4vmsyV/T6zKJwktcy/qrs0WLcofR1+KKjiF4hQbtyOtMTUC
	FlHPiSpj2o5pG7zTe9+gd4TzYBNhW5U/XsS9W4s5MMfF0HNvF0oQT2jr4HwF0z5mIis5+2
	94XtMw3k204JMBi/sZabG/kdznMWieY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Zc8Ypb8E;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4NCnFvaGrDIOTRc5HujFwwUmTQ2N/bdVeWHbEi7j9U=;
	b=d7Wm1jxPpvH6FRKot4JwMYKaZ2nk2fqDNdTVrHA520dZSTPSYb5cFe+u6k/5qTg6Wlh7/w
	NQn7V4QNmr8Sy/mEDn4ltpOTieF5pmnQjeNajGrXWll6NwhisuhSrfhuEj3vf7Rc5IERi9
	mDFg281zxrpzhLBbWJ8wj48pOy7MSko=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5eadf48fb2dso762305e0c.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794315404; x=1794920204; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=K4NCnFvaGrDIOTRc5HujFwwUmTQ2N/bdVeWHbEi7j9U=;
        b=Zc8Ypb8EK45nibIuiqtlNJIVee20jwqmkaiWO3R59ZhmLsWGV/0xjxCmqpFB7/ImEP
         A48BKATaH0eMhF1KkA3fDJNRauE4DnYcmxpih0w09Y+0deY786T6Gux/BVpPaZyYSNRh
         TiRSoIs9n9/qJc2rl/yiFE2jlJ5ewkt9VfaNODQNgizltDRj+lCiwADXThhHMLek5Ksm
         AaDy0NQCu/bl7ek95Ze4yiLlenEXbUXId/di9Z1S61xviO53pDRBEFFpw7YJVuABCR6I
         3jIjKfFgQwc4R/Q5IjaenNpZTIEbYCqasaw5tzLT1GOY1CmoryrdtOOqpqzoANvLpTCi
         N3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794315404; x=1794920204;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K4NCnFvaGrDIOTRc5HujFwwUmTQ2N/bdVeWHbEi7j9U=;
        b=slF5Pjiy6gl2/JVbjdc9AQDqG5F+PmadMalYJSXJDUKRIzAbnwKG4XYBqF3qc/smHF
         R60G3b+9+O7/cfflKzqXUPQOuEQuh6jaJB3GXozhRggAbpLxus9Uf+wl9F0NefQUo35K
         xCKFjVp22LWASNIxcFo6nsLHOv3EKFgU+euw9fRS7SBBdU9HqqxFw+Ej2cR3QbZvRpVx
         XuBdr5y5azTLrJalzTYUV14Lik6wB4OcAj4GfLbFKj0tIKfSGz5adk3fr2zx7+71T/QR
         /aVpn2Lpx7QulRoOUbOnWT3jPk8rmGQG7J02a7TGERsMV4y29aCn6tEto7zTNNwQTeK6
         liqA==
X-Forwarded-Encrypted: i=1; AL+hErGVEhrHPKNqqNOefejoOgpwvRuMnFTQpetFUXfRQmlBqlttB9jAOohGsWE6J6qLxInVYlHwoTeUBQ==@kvack.org
X-Gm-Message-State: APuU4Z/tIAQHCzHtBD811EMFpN9xIXVC1AlYtQ2e+GUm4c7j7+1e9yjs
	J9MXGqdLit9ncpVY/4Tm5fDQcKYtPUVrw3agkNq3wYXMLCZIMuObJgddVv5zMqPp+S0=
X-Gm-Gg: AYBFou34fQ72MDFAFHCINIuK0TDjs81905IOq5c9eAqp5SE9FPhGwBOUKqwM2oPtFku
	ilRCP5Qj7Fno3Ye0PJ1V/ydPeFXb1g7yOCK/AYtRShzdlwsmT3R9jdytIU8tcy2VR+Il54SMD5r
	9NZDY94PPOcIuXaPIV0gl2r7zwXYU7XeiYBdMuZxEpSepwn7Dcnf3ZTbz1BVYo+srdDueoi0mNi
	13FDSDp1NNVRmR1E+aU0GbGlSIxfySXPhgw8A5w2lqSjNhqkvvmeqsqE6faNb4EPf8qMOReGAwH
	GnIOPZnoRgRW9UOxa5nY9h3/1O8dCiFS7bgYcQ9qCdiDNEUKKDtVxofNz7Cw/nn5M7XkSzd3jh3
	DwzUtZlvjT9hayPeQm1P4zDpkmE3GjI0d5RS7h71AqAiqkFNnHOATTdJuVhmOxyw5Xb6ifjnCGu
	jlfiQhsO42V6ZMmU0o69BkttC9ZeBwSDt4FF79h46zPSvJ5LuJux8aogLxBP5zZjVZ+ZMb5oipl
	NYqPYGCHvKQUrQBrS8+BnWXNyXs0niq9l+yZDlVb1PkYEkrGT6OgHI6m8+LGXMkgaWxLC4Aa/Z7
	Jawz5i5WpnvEAzRLxnmkh1orIb1/UUkvH5t3c+0J06OPnoEpowrQY6/GlEwaFzKeBdn5ExIXRDS
	vcO9lQmI5CGGwpDs7lVcBOCe35uen45tygS3uKM3ZsPVxmtiRQSdM
X-Received: by 2002:a05:6122:3407:b0:5ec:3e18:a8da with SMTP id 71dfb90a1353d-5ee0d14a2e5mr823009e0c.17.1794315403552;
        Tue, 10 Nov 2026 04:56:43 -0800 (PST)
Received: from localhost (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee0c5b2233sm1547234e0c.10.2026.11.10.04.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 04:56:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 07:56:41 -0500
Message-Id: <DMRJQ42LR1D3.1GZKU9EX48KZU@soleen.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 01/19] liveupdate, kho: Remove __packed from KHO, LUO
 and memfd ABI structures
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-2-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-2-tarunsahu@google.com>
X-Stat-Signature: zgpgcy6w83rizyw3fy4sjrkzixcnqzxu
X-Rspamd-Queue-Id: 979B780005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794315404-425888
X-HE-Meta: U2FsdGVkX1/76qezWrxDfkHDnNPkAZ2ad8Pv/41MRaV0ICHNVOjaTiqdyJmPXWvYBjtSkrsF9L85CBonpd6iltjed8b6ggfxHl1udKzWPD4W1dGznqOI4PRLDgcwyAWBczf4nfw5XYJQDJS0yaFSBIzZazBVoeyhKhZhPsJoVHJ02CFCYUOydDpZQzDviaOhcAULLMeKsLospCQO0FAPbG9zK/4d9pzLwphWwnZ7NB1trgThZ3S4vFbJRepHgRsVpZbmsnj+9XE36jYeiaZna2Anizi7O3gxBgeqJ7vz4X6YrKsYRiF0fco/p+oP+ctt8WCLTV8JHucjENRmWHeUR6sYttbbRzTSj5VxT0vZE984CAdDtznByKc5D/nde5ZjSsxKsiPmHZ7dR4ZntSCp/EaaZHidpqhtRQCUOjO7m14oGla/2IuizCfmo+ZhfeEQ9xpuCBfV/4iwqdZAagoJFSBYwZKHyY/27kR9Nhtld+5emvHOJ24hwLznwLSyY91d0YwteiFDf+Lo1CJyXPEY1JLl9Zse0a3nKVdnY+X7H0NgUaIpSl2NbctOsmrdJ7WIpUXC9ZqmB0CkWLOGB0k6cnU+QNgJ44e0072oz5Kqsdwr4MZPma6+hgR4Nf+OR8RxvOzvbemuJZWKG6JV3v1dA4hR0ummSzzMVnXrj8+KTXH6B36PlVBwF4o7MdhvdLyx8mhHgTkmksyNcVCbhL6ishjCGa2x0uxVryUPlTlhWRhNMSiWWhEyxryT2ISfFNcITw9fZw1sXhqeojssfxg4ixeCa4N62PWnaw7grbV1RogKxsIl7oDfi6CJpOvnjKrxNhjo0Q6TzgCEUB6SRMd+n3op+mt2CvfER/B4BPw2XOqkw1uVBYQOG61So03uDRDZCnvgrHV+Z25yKHl1kjVTctoH6YJ2hhYgvk860EzJIKEnP0EiIupViGruJP+qiGOmBr+CHVzaR+jqyBKOFiH
 rrX8rxms
 5jeQYvIZdzoMTMPW1ngxZe6Rc7EW+PcH8hpXlnqt9WFtpfqQyY00bKwduWbzJXPjK0qxnkrXLkRhOZNplJFJfv+hGJebVx0eMKhYO7KnEQjjVQDJ15WI2jmrQhcYnvzRtU29BNXSe4DUi9C5syYRzxxyx09MOQOICAfUooLYenHs6+CGHGAg1jxbO8qdYBp/DTiuHFWdzG4OSk0Yaa2bHFfToRodI+9U08yLHCQQ/1BY04qEy82OWVtuiXxNll8InTVjIwsaqEK91aYO7X6/e5i9bNH7L6Gj33GRTuoVwb6LR6WJ6GruX7CGEBKir868xdz0BsEJNd1kGuLN1hxaKt2XkrjaEzuRQL/luMRHM2LtToRVwT4g5CExfx0NwLmlrWzxOtzq25C5B1ofvec/csytiW8ViC3O1jr/iYbcY5W9pJxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
> All structures in include/linux/kho/abi/block.h (struct
> kho_block_header_ser), include/linux/kho/abi/luo.h (struct luo_ser,
> struct luo_file_ser, struct luo_file_set_ser, struct luo_session_ser,
> struct luo_flb_header_ser, struct luo_flb_ser) and
> include/linux/kho/abi/memfd.h (struct memfd_luo_folio_ser, struct
> memfd_luo_ser) have naturally aligned fields on 64-bit architectures,
> with no padding holes between fields or tail padding. Assert both the
> structure size and 8-byte alignment under CONFIG_64BIT at compile time.
> Any future unaligned field addition should come with reserved field to
> keep the structure aligned.

Just state:

Remove __packed, as it may break natural alignment. Instead, ensure that=20
all padding holes are explicitly covered by reserved or similar fields,=20
as is already done for KHO/LUO serialized data, so no functional changes=20
are intended by this change.

>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/block.h | 10 +++++++--
>  include/linux/kho/abi/luo.h   | 38 +++++++++++++++++++++++++++++------
>  include/linux/kho/abi/memfd.h | 16 ++++++++++++---
>  3 files changed, 53 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.=
h
> index d06d64b963be..36bdbaf9b3b8 100644
> --- a/include/linux/kho/abi/block.h
> +++ b/include/linux/kho/abi/block.h
> @@ -12,7 +12,7 @@
>   * pre-update kernel to a post-update kernel.
>   *
>   * This interface is a contract. Any modification to the structure field=
s,
> - * compatible strings, or the layout of the `__packed` serialization
> + * compatible strings, or the layout of the serialization
>   * structures defined here constitutes a breaking change. Such changes r=
equire
>   * incrementing the version number in the `KHO_FDT_COMPATIBLE` string to
>   * prevent a new kernel from misinterpreting data from an old kernel.
> @@ -26,6 +26,8 @@
>  #define _LINUX_KHO_ABI_BLOCK_H
> =20
>  #include <asm/page.h>
> +#include <linux/build_bug.h>
> +#include <linux/kconfig.h>
>  #include <linux/types.h>
> =20
>  /**
> @@ -49,6 +51,10 @@
>  struct kho_block_header_ser {
>  	u64 next;
>  	u64 count;
> -} __packed;
> +};
> +
> +static_assert(sizeof(struct kho_block_header_ser) =3D=3D 16);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct kho_block_header_ser) =3D=3D 8);
> =20
>  #endif /* _LINUX_KHO_ABI_BLOCK_H */
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 288076de6d4a..721949374fa1 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -58,6 +58,8 @@
>  #define _LINUX_KHO_ABI_LUO_H
> =20
>  #include <linux/align.h>
> +#include <linux/build_bug.h>
> +#include <linux/kconfig.h>
>  #include <linux/kho/abi/block.h>
>  #include <uapi/linux/liveupdate.h>
> =20
> @@ -82,7 +84,11 @@ struct luo_ser {
>  	u64 liveupdate_num;
>  	u64 sessions_pa;
>  	u64 flbs_pa;
> -} __packed;
> +};
> +
> +static_assert(sizeof(struct luo_ser) =3D=3D 32);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct luo_ser) =3D=3D 8);

Please remove the two assertions above throughout this patch, as they=20
are replaced later in the series. In general, introducing add -> remove=20
-> add churn across a patch series is discouraged, as it indicates a=20
lack of planning.

> =20
>  #define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
> =20
> @@ -98,7 +104,11 @@ struct luo_file_ser {
>  	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
>  	u64 data;
>  	u64 token;
> -} __packed;
> +};
> +
> +static_assert(sizeof(struct luo_file_ser) =3D=3D 64);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct luo_file_ser) =3D=3D 8);
> =20
>  /**
>   * struct luo_file_set_ser - Represents the serialized metadata for file=
 set
> @@ -113,7 +123,11 @@ struct luo_file_ser {
>  struct luo_file_set_ser {
>  	u64 files;
>  	u64 count;
> -} __packed;
> +};
> +
> +static_assert(sizeof(struct luo_file_set_ser) =3D=3D 16);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct luo_file_set_ser) =3D=3D 8);
> =20
>  /**
>   * struct luo_session_ser - Represents the serialized metadata for a LUO=
 session.
> @@ -131,7 +145,11 @@ struct luo_file_set_ser {
>  struct luo_session_ser {
>  	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
>  	struct luo_file_set_ser file_set_ser;
> -} __packed;
> +};
> +
> +static_assert(sizeof(struct luo_session_ser) =3D=3D 80);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct luo_session_ser) =3D=3D 8);
> =20
>  /* The max size is set so it can be reliably used during in serializatio=
n */
>  #define LIVEUPDATE_FLB_COMPAT_LENGTH	48
> @@ -152,7 +170,11 @@ struct luo_session_ser {
>  struct luo_flb_header_ser {
>  	u64 pgcnt;
>  	u64 count;
> -} __packed;
> +};
> +
> +static_assert(sizeof(struct luo_flb_header_ser) =3D=3D 16);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct luo_flb_header_ser) =3D=3D 8);
> =20
>  /**
>   * struct luo_flb_ser - Represents the serialized state of a single FLB =
object.
> @@ -175,7 +197,11 @@ struct luo_flb_ser {
>  	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
>  	u64 data;
>  	u64 count;
> -} __packed;
> +};
> +
> +static_assert(sizeof(struct luo_flb_ser) =3D=3D 64);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct luo_flb_ser) =3D=3D 8);
> =20
>  /* Kernel Live Update Test ABI */
>  #ifdef CONFIG_LIVEUPDATE_TEST
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.=
h
> index 08b10fea2afc..376a724a1d8c 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -11,6 +11,8 @@
>  #ifndef _LINUX_KHO_ABI_MEMFD_H
>  #define _LINUX_KHO_ABI_MEMFD_H
> =20
> +#include <linux/build_bug.h>
> +#include <linux/kconfig.h>
>  #include <linux/types.h>
>  #include <linux/kho/abi/kexec_handover.h>
> =20
> @@ -20,7 +22,7 @@
>   * memfd uses the ABI defined below for preserving its state across a ke=
xec
>   * reboot using the LUO.
>   *
> - * The state is serialized into a packed structure `struct memfd_luo_ser=
`
> + * The state is serialized into `struct memfd_luo_ser`
>   * which is handed over to the next kernel via the KHO mechanism.
>   *
>   * This interface is a contract. Any modification to the structure layou=
t
> @@ -54,7 +56,11 @@ struct memfd_luo_folio_ser {
>  	u64 pfn:52;
>  	u64 flags:12;
>  	u64 index;
> -} __packed;
> +};
> +
> +static_assert(sizeof(struct memfd_luo_folio_ser) =3D=3D 16);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct memfd_luo_folio_ser) =3D=3D 8);
> =20
>  /*
>   * The set of seals this version supports preserving. If support for any=
 new
> @@ -85,7 +91,11 @@ struct memfd_luo_ser {
>  	u32 flags;
>  	u64 nr_folios;
>  	struct kho_vmalloc folios;
> -} __packed;
> +};
> +
> +static_assert(sizeof(struct memfd_luo_ser) =3D=3D 48);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct memfd_luo_ser) =3D=3D 8);
> =20
>  /* The compatibility string for memfd file handler */
>  #define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"

--=20
Pasha


