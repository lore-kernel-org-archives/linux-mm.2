Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7798F606A332
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pEuUYkOi
Received: by kanga.kvack.org (Postfix)
	id 753E66B06B1; Thu, 19 Nov 2026 19:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A856B06B2; Thu, 19 Nov 2026 19:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619D26B0713; Thu, 19 Nov 2026 19:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31B3F6B06B1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:19:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B497B140BE9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:19:39 +0000 (UTC)
X-FDA: 85453588878.02.59D7C07
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id D0A3540011
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:19:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pEuUYkOi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795133977;
	b=q9+0uXtdpuBXoNlrAHmzgfXLtBhTBfMjxknJiO6IgLoBaQCfJi9kBMqv+Dj5OTT+zVSL7C
	oiBUa0czc7mPmSNvwuOeKn4LNjaocTvW5pqQ5sSLdyQ7vYXJTR6dwt1AzEvz/Y8SqB7M83
	Xwf8BnrUanR/qln+lkIa1mVXeQC/Jxg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795133977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7l+AyO/cRMVQJwJa64VigJKwgCGiEZe5FhWi4AHvFM=;
	b=D8aKAXgBCciIme/Za0dnTDFYMPVXvIVHKnFPmihZmt31P/IhlOeiHM5p4pOimRD/f4fF+i
	VqXWTL4vdGD0gyK/Zd7Cfw21p3q5H/byB4eoWGhZlR3HnjkmrMij5jELrZ4jj6igZZGrsN
	IAE0Kx1VPqQDwe+0a/ELuiL3B7SIcQU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pEuUYkOi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2f0213202fdso1609195ad.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795133977; x=1795738777; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n7l+AyO/cRMVQJwJa64VigJKwgCGiEZe5FhWi4AHvFM=;
        b=pEuUYkOilBWxVzxagIUNyAjp6CvxSw6l5hf2v9qUIHW9/LAVtMpa5W3zd050uqYEKv
         fjbONHtl0nyHqorDLTAsMOTs2W6wpPUz/f68+g4aoW3sUVH1mBvCnMzND9aZBEwZLN5b
         zNE9O19bblKRDRNGdoN92ceHSGJSvXynsZaGuwSPRkZAw9ee15Uc9Xsa/X19qu33JcXr
         GiykSMLAU2R0/S7BkNoZsNzUzFHeW7BNU0cIEuJyKeAyGegHvu0rrD3ya/8KBTWKNGWq
         NLC0jpDE38FQVAnreVvW3hovaS02UbyeizuUx1wO0Ur7bEc9UCF0kgdjqf81LPqNZoua
         AFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795133977; x=1795738777;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n7l+AyO/cRMVQJwJa64VigJKwgCGiEZe5FhWi4AHvFM=;
        b=aS0g93Y94aP8SiLWfWDkhxgygqUFaH+7wFe+ykRBaXtUdXcgS9yJTrLX+xa3hrnLaW
         N7Jy3oDYLoZ+99m9OOErrxb6o0t8+8CVToSLWjVaPJCMKY/NAWF9cQ9O4cLvFE7OjEeH
         iC+pQIEmAxe1I9u+BObWuQnGPdM1/R2gXi3vwFCuSqdPvh6lRjPESblqqTTsarfxnsGo
         RSKcNsz7yVhZtj3wR1yQKtNVlNCTQDhud8+k3D56eyxGglPr0uukLmCcQwplOG8TGBGA
         0SUDm7LdoXAkQdCftHt5rXm8tzmj+CoFcYBULqAv1ZGTvpb3Bd9C9aQf79q9iA5MOvha
         rNzQ==
X-Forwarded-Encrypted: i=1; AL+hErERRoq4GQoXLGzih8PLX6q7qoaa0cbAtT4OdUNwa08vuecbG6/GmOy9vu6v5BHB6bdgIq34XJv0yw==@kvack.org
X-Gm-Message-State: APuU4Z/t3Os0vOMZmd6P+P6T5tqNOiulkVAYkI/S6OXknZ6fAHpa2fhV
	eK6dLpWL3/ZQXc/DYPE8az5KOkuU2cgS/h4q/EaPh+faVk4vXp3khI8Zdh+WN5MF2g==
X-Gm-Gg: AZFdTZf+x874phkyuk/Tpb2jGjebPUE6ergqdM42Eol8TSLFip0L1jfTzmfP2h0tmH4
	rRNj5KGgmjAtfQzbmAgnYjJu0qNB1ZhgGin7zzdaMzgYLKmwCAf3kmcvUVuAt2T0g1x27BzTGBY
	gjFJcqiJoBSp5xIvDY3Jg850KclQMtcA8DPbJ6Zdhe6EzoRvvypN784I3jC5my8PMhCVBmxmnGn
	NVzr/GTZ0nMsOcRsGE5n2oc5xyqWLzW09VFV2sKntAfa4LOrnf4mgJ1Pl+QrFQdDaMpNOMo/DC5
	GeNDRsYId2jX1HEJQ/+J70xNtGH8701FlfsFwDaE6fqVOs7ij1GKc7Ihch9AAJoNQmmwSP7BnHh
	3S6OjY0qq9CnFnxqmsNAOigFbLLjz4IAjQH0jnjjwDTQRc0Z3wNW9PqrrNU7Uqocv8/6r9yFV2x
	7X99oiT0qdLZuC9FHt8f0UBpPWdajIvRMf9q5kWnmgQzESw+x1tWBjznKvmqSOM7kfQgfwUPBKZ
	Bxus3OupsvPKffyu4eEr2lYKqty0Y54OpQhn6opG/+w6zVMQnejfVKtJoEE2VgnTd38AXITbKbq
	oXl1IWEgWd4xHaJJQM8lS9L71zMmgJzpS8pIqhih2oVPSxqyMa0sOaXHSCPg70B0
X-Received: by 2002:a17:902:e542:b0:2e9:6b5b:3db6 with SMTP id d9443c01a7336-2f03f1a4967mr13941365ad.30.1795133975980;
        Thu, 19 Nov 2026 16:19:35 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0ddf40sm5969655ad.37.2026.11.19.16.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 16:19:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Nov 2026 16:19:34 -0800
Message-Id: <DMZLVV5YW6GW.1HMW8L8NIQ1XR@google.com>
Cc: <ajayachandra@nvidia.com>, <alex@shazbot.org>, <amastro@fb.com>,
 <ankita@nvidia.com>, <apopple@nvidia.com>, <bhelgaas@google.com>,
 <chrisl@kernel.org>, <christian.koenig@amd.com>, <corbet@lwn.net>,
 <dmatlack@google.com>, <graf@amazon.com>, <jacob.pan@linux.microsoft.com>,
 <jgg@nvidia.com>, <jgg@ziepe.ca>, <jrhilke@google.com>,
 <julianr@linux.ibm.com>, <kees@kernel.org>, <kevin.tian@intel.com>,
 <leon@kernel.org>, <leonro@nvidia.com>, <lukas@wunner.de>,
 <mattev@meta.com>, <michal.winiarski@intel.com>, <parav@nvidia.com>,
 <pasha.tatashin@soleen.com>, <praan@google.com>, <pratyush@kernel.org>,
 <rananta@google.com>, <rdunlap@infradead.org>, <rientjes@google.com>,
 <rodrigo.vivi@intel.com>, <rppt@kernel.org>, <saeedm@nvidia.com>,
 <schnelle@linux.ibm.com>, <skhan@linuxfoundation.org>,
 <skhawaja@google.com>, <vivek.kasireddy@intel.com>, <witu@nvidia.com>,
 <yanjun.zhu@linux.dev>, <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 12/27] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
From: "David Matlack" <dmatlack@google.com>
To: "Vipin Sharma" <vipinsh@google.com>, <kexec@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-pci@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-13-vipinsh@google.com>
In-Reply-To: <20261102153656.1431701-13-vipinsh@google.com>
X-Rspam-User:
X-Rspamd-Queue-Id: D0A3540011
X-Stat-Signature: 73hrdg33o8canw44hu7oqn6iyx6ni8ne
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795133977-184177
X-HE-Meta: U2FsdGVkX1+XyYqEM6SRC2D41RsNHKus57F8XRqKtfKtwvXVf8wIzsOzv/+D8x2ztVRAoO699tC+qcwIsxm9K7QcbZ5E2ivTg3WS5ZJb6oTPbGtZiPQ7RF/qYk4VPVu6HF7EC0alCCyiGfMWgun6FwLvJ5skVC4pNPnmCM3luoYmOWnuWAmM5u/5IMwIRDXS48zUu8nhi7dliUIxgJjVsum+Bq5kt5RB+UWq6nWtCLWy3Cu4tZPmOXYRMBgNzz9Zj6IR2HAgLi/U9QhOEaug+emxlEGGs1TcG8gcdv+4ytXKBuuHw1e1khHDrcXePr/MivqHXKWKgTPILz8TgGGuqb1CD9BK2jtkIDQjGCyASQf/g9z8m+czxat2p59IoR29x3AafIutq/cq8EREEcuJEw/eJruGUA8OPASPrXGYtrviNjCObq/hQFqPT6qhPZtPOFwjLFTEQd3kKNGLhmPkPd0ng2wK9DO7kEGjhdDbRyq2M20xd65gXJWpUha7pDq2Xkhiycj56W5Qd44Ct2avjYM6LByhYP3yMpR4tHYOkoPyim51P4dMWroQN0R6b0b5W0BN9+tB/8mb6Cjp1xlderrz+49GfeSvzytTkHYoT7iIGVeR6A8jBbxjveG2KBsPtYQcT8AMjCbK8C79Byj3jF6BxE3LyvvfUEbZ1dsuKIGyBqLXs5zq7q9PcBRtdfSIMaMcAdd7S9Au0VvxopcN4VkunPvTNzaS2CHchyGwR1JuDlfgY5cPMKmKTqlsTZSMWlFFPhs5a9jgT8QHNlXnW82XLx/OYT0A8HNJroyaW/rewRHnd9D/8KlbwtKXGFD3QTte2EB5zUA8fViyT5DGyTi0osoXBbFRU1nxeNHYa8RwLuAh6oUrWsUGtQ6NLRJ08kaSf/9pPCPKd+IlXLT6hqBCorGyW4maUQcyMQuMbNTbvQlqRu62smtgRDr7Am/huF8A264+cRNfwKPiTRy
 sPmpaH/K
 dWZXbQOVQTtwSrbfppvoDbZEXZpkPy7G1loIJL+qtCaUxk9e9GRtRVlwsIIPJPyktCDyhqBPoc1yA9zk5wCygiWoDV1f4BT+t/KHBNefe6NQ+ngCSJjd/dwvWSOMowEbmJjqCRzRKR+/pnppCPWy/bHa3fZhJHykXCw/w735xuxCrfNDALWHGALk1AwQ22mPPoOAOg7ta7EmHV8ceR7iWl2Ovoz8ajIznkXzVzCG8UbsV82+thfyhgUT1YwohwTpqhGeoYD8RpRF4Sbvd9Nk5VBBUTYU/kNbqGokcV2UktnyAzKwaRiu0ZB7r0vIGWR133lmOh7YLL+lzSlqrDKZb3RlJ1GJsews2xCs8oiZOgqSDb+6IxuEjiAeBdfij/kPX/0UPYL6aZT9kNUToVrZCpMWJUzZ6kdrod0RD/J8ctgMG+cDtYdtANwk4Q1aTGOk/1SXbl0aAzY8T2Mzq0JEepPHzdRxyEfwXjXIuv4UfXUXuY9RG0nGaaPBpXbOLSj92YfvPC/qFXqHhwN4ZeO/Ab7MP+JWBi9IzO0f807teYNFj86oZfK9pQ4bzH0B5AsTBPWif5GjE9Y/f4jCgVX3qK9+C6MSHBPD43EOD+RVDq+akqZlgXUaCUq1QrrpB9FZqPi/t09DBOQJgb2Q02A8LVv4rW/Zw+SPLYAxYSZQ+rVXLMKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 7:36 AM PST, Vipin Sharma wrote:
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 12557d45dfee..e6ca4c3fda06 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -11,6 +11,7 @@
>  #include <linux/cdev.h>
>  #include <linux/module.h>
>  #include <linux/vfio.h>
> +#include <linux/pci.h>
> =20
>  struct iommufd_ctx;
>  struct iommu_group;
> @@ -446,4 +447,21 @@ static inline void vfio_device_debugfs_init(struct v=
fio_device *vdev) { }
>  static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { =
}
>  #endif /* CONFIG_VFIO_DEBUGFS */
> =20
> +#ifdef CONFIG_VFIO_PCI_LIVEUPDATE
> +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_dev=
ice *device)
> +{
> +	struct device *d =3D device->dev;
> +
> +	if (dev_is_pci(d))
> +		return pci_liveupdate_is_incoming(to_pci_dev(d));
> +
> +	return false;
> +}
> +#else
> +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_dev=
ice *device)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_VFIO_PCI_LIVEUPDATE */

No need for the ifdef here and 2 definitions here. If
CONFIG_PCI_LIVEUPDATE is not enabled then the compiler should be able to
optimize vfio_liveupdate_incoming_is_preserved() to false.

