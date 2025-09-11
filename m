Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1640ACA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 12:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72448900004; Thu, 11 Sep 2025 08:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBE4900002; Thu, 11 Sep 2025 08:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EA56900004; Thu, 11 Sep 2025 08:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 455E4900002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:16:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE81C85CDD
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:16:00 +0000 (UTC)
X-FDA: 83876866080.07.DC4DB76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7A90C10000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:15:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JNAl9yJR;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757592958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZSC160BNjuUUAGLkXphv06qqbR9jmakoLUoFELbVgo=;
	b=TADj70w8Aasky2La2/m1iSu6sOEAZId+MjizO1Aq+SGkk4ITzGz1oV/Prq/S4dS7HlLX5z
	8RG12TUrA2VIwLZB15wIGMgbLk3HbYxX+EDnn6410gNDEth3qU1aBq13VEmkI9I6zbbZg0
	L768SFdr9V6JJlq1QERti94ZKDsyzc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757592958; a=rsa-sha256;
	cv=none;
	b=0LpGvsWajJ2lD+hEaqoiUjkKT3IUUvTKc2pb7kveWHZT98Btlif4b7P049ezzdwFhRzpGE
	FZt9JAEBJuaZMvNwVem37n59TAheqBkvJIfr54GNUxOXFlCCCwwtDbtCmd2ErZuh+W5X05
	h2kcrQGhcPbPyROgXKhITDQ6UlJJ8AM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JNAl9yJR;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757592957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LZSC160BNjuUUAGLkXphv06qqbR9jmakoLUoFELbVgo=;
	b=JNAl9yJRIkC9pIQd65H3xLzXZ1EIl7BpT0Ync6JhBfW1hxwSRvgeUz6+xBrMMbMI7f4U1v
	JVVgOGQmaVBYRBTV0rMxrfW6sONuQyWjDnywlp9lyAcfp7I/SWrqURSo3jJUCLUL9P67DH
	hSASFVrpBtIhQ7E/ly9264Bnaug0eZE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-aqQ8EmUUO1Ss3tJEuPo30g-1; Thu, 11 Sep 2025 08:15:56 -0400
X-MC-Unique: aqQ8EmUUO1Ss3tJEuPo30g-1
X-Mimecast-MFC-AGG-ID: aqQ8EmUUO1Ss3tJEuPo30g_1757592955
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e68a54dac2so322587f8f.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:15:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757592955; x=1758197755;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZSC160BNjuUUAGLkXphv06qqbR9jmakoLUoFELbVgo=;
        b=eUyNrdhGK8WFsBSCzzdQWxi7bRhthVwRcUPH9uXmNVeFmmBMzZYwbUgKRVsuKaCInb
         wbnHRyBGvVVIRqiiHUNfHIlJtNDRSOqBgN+m2B7JX21h9hGH+OCsTAIyeBpwYg11SbjM
         mzHelRLbpZf92kmaHQvBEDuw8JRC0unZ+26K0Fo4iFLgxLmgYRikGJzayTEh4fLdJC9w
         9CoKJdo4bYU83LAhx/Kqz+byo7/rfIPrC1n5IA9FqZ0dZ4s5KYNfR/jiCViS/alYuknH
         0DmomWU04cIgaVUzjYQoHEebmk1N5/VlerP80hae/DZgEVY2iaLmZoGvUMP1jYlOYu9B
         70xA==
X-Forwarded-Encrypted: i=1; AJvYcCU31OLVV3SmgPFziqkd9eStrynO/by3/QC0J6QCW6kOzSRuhecILwVL6yTT4/oeewxjjlgwDi9n+A==@kvack.org
X-Gm-Message-State: AOJu0Yy5m//ujXeDyryf+7Xgfoui/K/z4rdHmHCAswFYjhGc7xs2deMP
	9BOZak2SZt+MA8XrgAOF36Dw+grup36qC3y/nFOzr41a0yaDnIdrpjYGW96bwaUq2WOh4J3IEE3
	rZV0BrRUoYKDYOxbH7tDJYKm9rsh3CF9wUN/9IUhbn7fw9J2bRb4j
X-Gm-Gg: ASbGncvmKPzn/92qAospKY7F0q0psXwoHQGIlmg/mh7fXCBR64ijN28OrgiBs47eNqW
	OHi9iVKsCzBruy6D3aAW6oNLOcWRYZDtGxxQpDdLPd8Bp1YIcFl+Ay50Uo4FjdU3xYaBcfSTMPh
	PjHfrOe3XI3N6k0YxzAfhRrJqkP+6QwtCvlkPaOiCVlLVO4f4rrGHn+R5P/t4D/reAUygCzzFDI
	ReuzDhC1Jig834EJThI7FpVZT1emkTKjubwyVhA5dsWj6OZfhMI4zIEu7K0va172N/oDfDK9uri
	cLhCpisveQmULVrMVMDh4M0yAnXg50Lsa1YYmMJOaMkfRQq6tU2emg/Fd4rO4CtLWPgsSfmmlHR
	6Mz1UiMF5TCyj40p3RICH6PMfVDbcEMrEyj5wz2j5S+gkDT1RkVYvPtIT4pv3+ZP4JIc=
X-Received: by 2002:a05:6000:26c4:b0:3ce:7673:bb30 with SMTP id ffacd0b85a97d-3e75e13cae4mr2820245f8f.14.1757592955136;
        Thu, 11 Sep 2025 05:15:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFguV4xqw7F+/FuyOrWlJOAk5WiiJK6C2irThfGhJhUviXccwRkqmzT0qljmwNeg5bEqGRHFw==
X-Received: by 2002:a05:6000:26c4:b0:3ce:7673:bb30 with SMTP id ffacd0b85a97d-3e75e13cae4mr2820217f8f.14.1757592954536;
        Thu, 11 Sep 2025 05:15:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0157d68esm12986065e9.6.2025.09.11.05.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 05:15:53 -0700 (PDT)
Message-ID: <17e3c19e-0719-4643-8db8-cf8c5b5aa022@redhat.com>
Date: Thu, 11 Sep 2025 14:15:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 02/15] mm/huge_memory: add device-private THP support to PMD
 operations
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-3-balbirs@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908000448.180088-3-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5vyg7WtnJBNxTDp8vDWP53s60LGYYtfBKFNS7pciFPs_1757592955
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ye8moo4qo994ow9g53u7oa4og66b7b6e
X-Rspamd-Queue-Id: 7A90C10000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757592958-481254
X-HE-Meta: U2FsdGVkX19aFva/oOivSDXgnrO1Mo2MTxovwrAsA8fNB7Z4hACri7CeluwALrFPv7cdyG+1GRQo0Nji21KKsI4pcVjXHYhaLwijVifdcjasTOjtiIgxiv3/Wucog7Z6SBvite1k7aXxHivB8Qr+ZGXAg2HJdlJr/vOM0C9vTtr4bSUcRaUdx6JIKVCrTQC5Vx6KsecsDzUbnWdgMoVWl8j4JAiOx/LA46jxSGlLcsr1cgXAfo7KGOddZc2SGI/jsQtHjWV0L6RUO49BzPANGz7zQtqstjjCBs3iMiFlh/brsGeVNibZAUMFiPzhKOCbi9Q5MR0li6Qu2MY7B7VgxrSatbOSo7bk+DV5jBw6Bl47+y7YT4T31TNuQhKTL8gDaglzW7W7a4oOUMWASuNU7JAs4nulR97L+70X0c9p0G/mXZaXZMJdiCk8MwHOLMPE1IKKHyNbyX9N5op4BvdP7UvN7+v0ZUIUaLqDnVoQxwHOAoztkRa8Yo7pBp4TrykO44a0D43G+eRmURKyDKK83nYd3NJBMON400QVXChYLNxUhsjYoJVN1IQhFPPSfphCMtH4wg2kHiIB0GLxQ0Ywmz+k1nm2l7DRcoWz4pdNGf1HsSWfmdozc57lPjfkU1sbSLhSMWyR/3T1XSteqeh7Yxz0/5f3d8WtATCwwIrCyDKFaRrkforAh3YsIIPNax1avyV1oYSjo9RfkKDSfYVT3B5kHRRdl+Tx8kmlfoUV0k8UBPMqp1aV6fYIuMEDlvmsu7QY5XI+0Z+bDi9tJaIBvVsdaD3KHpZwJ2dnlrOF96wuFVAbW9RpLZx2qkDetfGKS6p0SgBoSNcGJKzPUcqI+7mL27pObEzB8ES4Nc2kQUvNUBFWsVy6FP7r3cZa58k+fmI1nO8rRsoIezJXX6i4dG6ZB9Sed6o36gxWcdj0ybA4115gK+7dI5KtsbXPPkNh6RwMfLDzz4vMW7qYVMv
 lmjerHvK
 B1kMSQmnS+cEPJHi3zWWQ/Ii5vKnjgyaF+dvYM5eFhG7JucbKpE/XpacvW6XwU2f+wXgkKHydA8UXm2O0SPya8i1I8UXnKp1NTWvf6ePwS2rQ3JO+QbLHJoUlOSiIL2EWoZlZocOSSDcI0YOKaHwHP2XFNrjkZlh91DMoh1NqeNE+NjpILcWzh7Nx2jHwNUXH1xTmxCSCgZ6gaIwnIq0KtPy8pLR65ZqzWV4AlZgiWCVzpd05q3gRrEDmKvHIkpzSZTJfJYS+RT3tA5wupbK/8HvD+MnsWrR+PwNl6LZawC0BwQmkogmtZ5HVvpHP2aL/SYCojiFw2TOOPnzXWU9NaZNlhub2527ixL1L4wS1TzqhVIeLQOrR9gTHgEP8RXQse2vnqOuuyoesdJBEuHBu0MSQnOw2dw3zA5LEtB73oPsL70xqstS2t2uINW19pjhL32EJDP0pW0DZEL74q4Pe9dVhPwhFvJ0xdcKQAm+eYxNdnPIaDdhK2Md+EOS8pQq8Y93wJv3z4zxMw5+8EZlc63thEn3+kzX3ulPB0BV/CDq28p+/9RzOXmeir24jUtn4ep72TIEkqeDFcKOnK2z6AOmS9zNEtlGl2Gh7DEIovtHfM2WnxqSx7KrhbXwYiNrqCJFTTc+foOs3UBHTGp9qIBfHB2DgwqyE4/dzO//QpXvF2FW+FghaWeutSaW0IxkuiuNjoTDBc+5VtD1lJSYfQeGbfQrYiGg16H5J/keFM4zZ35CPE5/NrjFEpg4nMA+7Ja3K8e1CLqZj2/Gd0KhHaEWwJ6Ib0G+QL+yoPpMwYzRWbdeoEL5NNBMdKJ4kK+HrjKqPqv0dYZY4IUtUyOcLMjK/0BfZNoTioOb9u/pBKOnyw+2LCBG+033ius1wqGxmvUlELDYtooa1rQD1ZGV6efpQzzs/pj7SUMyY8UToDDWdE1C96HwApNJbrtmrQoJhbOcxmLc82KHqvtq0t37gMBKdrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 02:04, Balbir Singh wrote:
> Extend core huge page management functions to handle device-private THP
> entries. This enables proper handling of large device-private folios in
> fundamental MM operations.
> 
> The following functions have been updated:
> 
> - copy_huge_pmd(): Handle device-private entries during fork/clone
> - zap_huge_pmd(): Properly free device-private THP during munmap
> - change_huge_pmd(): Support protection changes on device-private THP
> - __pte_offset_map(): Add device-private entry awareness
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>   include/linux/swapops.h | 27 +++++++++++++++++++
>   mm/huge_memory.c        | 60 ++++++++++++++++++++++++++++++++++++-----
>   mm/pgtable-generic.c    |  6 +++++
>   3 files changed, 86 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 64ea151a7ae3..59c5889a4d54 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -594,6 +594,33 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>   }
>   #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>   
> +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> +
> +/**
> + * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
> + * @pmd: The PMD to check
> + *
> + * Returns true if the PMD contains a swap entry that represents a device private
> + * page mapping. This is used for zone device private pages that have been
> + * swapped out but still need special handling during various memory management
> + * operations.
> + *
> + * Return: 1 if PMD contains device private entry, 0 otherwise
> + */
> +static inline int is_pmd_device_private_entry(pmd_t pmd)
> +{
> +	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
> +}
> +
> +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +
> +static inline int is_pmd_device_private_entry(pmd_t pmd)
> +{
> +	return 0;
> +}
> +
> +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +
>   static inline int non_swap_entry(swp_entry_t entry)
>   {
>   	return swp_type(entry) >= MAX_SWAPFILES;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 26cedfcd7418..2af74e09b279 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1703,8 +1703,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>   	if (unlikely(is_swap_pmd(pmd))) {
>   		swp_entry_t entry = pmd_to_swp_entry(pmd);
>   
> -		VM_BUG_ON(!is_pmd_migration_entry(pmd));
> -		if (!is_readable_migration_entry(entry)) {
> +		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
> +				!is_pmd_device_private_entry(pmd));
> +

Wrong indentation.

> +		if (is_migration_entry(entry) &&
> +			!is_readable_migration_entry(entry)) {

Dito.

Wonder if we want to be more explicit.

if (is_readable_migration_entry(enrty) ||
     is_readable_exclusive_migration_entry)) {


>   			entry = make_readable_migration_entry(
>   							swp_offset(entry));
>   			pmd = swp_entry_to_pmd(entry);
> @@ -1713,7 +1716,37 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>   			if (pmd_swp_uffd_wp(*src_pmd))
>   				pmd = pmd_swp_mkuffd_wp(pmd);
>   			set_pmd_at(src_mm, addr, src_pmd, pmd);
> +		} else if (is_device_private_entry(entry)) {
> +			/*
> +			 * For device private entries, since there are no
> +			 * read exclusive entries, writable = !readable
> +			 */
> +			if (is_writable_device_private_entry(entry)) {
> +				entry = make_readable_device_private_entry(
> +					swp_offset(entry));

Put this on a single line.

> +				pmd = swp_entry_to_pmd(entry);
> +
> +				if (pmd_swp_soft_dirty(*src_pmd))
> +					pmd = pmd_swp_mksoft_dirty(pmd);
> +				if (pmd_swp_uffd_wp(*src_pmd))
> +					pmd = pmd_swp_mkuffd_wp(pmd);
> +				set_pmd_at(src_mm, addr, src_pmd, pmd);
> +			}
> +
> +			src_folio = pfn_swap_entry_folio(entry);
> +			VM_WARN_ON(!folio_test_large(src_folio));
> +
> +			folio_get(src_folio);
> +			/*
> +			 * folio_try_dup_anon_rmap_pmd does not fail for
> +			 * device private entries.
> +			 */
> +			ret = folio_try_dup_anon_rmap_pmd(src_folio,
> +							  &src_folio->page,
> +							  dst_vma, src_vma);
> +			VM_WARN_ON(ret);

Please just drop the ret + VM_WARN_ON here, like we did in the PTE case.

>   		}
> +
>   		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>   		mm_inc_nr_ptes(dst_mm);
>   		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> @@ -2211,15 +2244,17 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   			folio_remove_rmap_pmd(folio, page, vma);
>   			WARN_ON_ONCE(folio_mapcount(folio) < 0);
>   			VM_BUG_ON_PAGE(!PageHead(page), page);
> -		} else if (thp_migration_supported()) {
> +		} else if (is_pmd_migration_entry(orig_pmd) ||
> +				is_pmd_device_private_entry(orig_pmd)) {


Indentation ...

>   			swp_entry_t entry;
>   
> -			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
>   			entry = pmd_to_swp_entry(orig_pmd);
>   			folio = pfn_swap_entry_folio(entry);
>   			flush_needed = 0;
> -		} else
> -			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> +
> +			if (!thp_migration_supported())
> +				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> +		}
>   
>   		if (folio_test_anon(folio)) {
>   			zap_deposited_table(tlb->mm, pmd);
> @@ -2239,6 +2274,12 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   				folio_mark_accessed(folio);
>   		}
>   
> +		if (folio_is_device_private(folio)) {
> +			folio_remove_rmap_pmd(folio, &folio->page, vma);
> +			WARN_ON_ONCE(folio_mapcount(folio) < 0);
> +			folio_put(folio);
> +		}
> +
>   		spin_unlock(ptl);
>   		if (flush_needed)
>   			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
> @@ -2367,7 +2408,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		struct folio *folio = pfn_swap_entry_folio(entry);
>   		pmd_t newpmd;
>   
> -		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
> +		VM_WARN_ON(!is_pmd_migration_entry(*pmd) &&
> +			   !folio_is_device_private(folio));
>   		if (is_writable_migration_entry(entry)) {
>   			/*
>   			 * A protection check is difficult so
> @@ -2380,6 +2422,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   			newpmd = swp_entry_to_pmd(entry);
>   			if (pmd_swp_soft_dirty(*pmd))
>   				newpmd = pmd_swp_mksoft_dirty(newpmd);
> +		} else if (is_writable_device_private_entry(entry)) {
> +			entry = make_readable_device_private_entry(
> +							swp_offset(entry));
> +			newpmd = swp_entry_to_pmd(entry);
>   		} else {
>   			newpmd = *pmd;
>   		}
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 567e2d084071..604e8206a2ec 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -292,6 +292,12 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>   		*pmdvalp = pmdval;
>   	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
>   		goto nomap;
> +	if (is_swap_pmd(pmdval)) {
> +		swp_entry_t entry = pmd_to_swp_entry(pmdval);
> +
> +		if (is_device_private_entry(entry))
> +			goto nomap;
> +	}

Couldn't we do here

if (!pmd_present(pmdval))
	goto nomap;

To replace the original pmd_none() .. check.

A page table must always be present IIRC.

-- 
Cheers

David / dhildenb


