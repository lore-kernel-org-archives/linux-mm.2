Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E58BCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 20:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536298E0006; Tue, 21 Oct 2025 16:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6078E0002; Tue, 21 Oct 2025 16:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D51A8E0006; Tue, 21 Oct 2025 16:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 276478E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:43:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C427F487FA
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:43:35 +0000 (UTC)
X-FDA: 84023297190.03.14F1708
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3CD29180006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:43:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MrHfJ5Gi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761079413; a=rsa-sha256;
	cv=none;
	b=Hn3QH91xGddfPJavb/xiA7Pi1nPh72hcizPofVFtuYNkzuXdwy5rHgSrXU4a5uA3WlOyr3
	Txj6NKhT4NV+lvt9UlKbPlDZUSWJtnLjlaFRz6/O9AmwaQ1MINuIi7zr2YUwoXL12I841n
	UOrB+7RfvvIb9xjksld1X/+PkWvw9Pw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MrHfJ5Gi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761079413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jca+iAluyvXYfcIcNG0HUymCKJQKka+3ZoKebkZZYlk=;
	b=CeS783Nl3JgFMKHhIayEVcXtTczflACHOOu3I955+XLh3019kFIz0esZrUklwZNsOFNvAW
	3Jae6DG3yKkZ6Na3E1y3VtVLSqfRxd6cPCNpDhs5lAoCJRcMvSUqI7zTJwOh7Cs0OHVDC4
	LLq2k4e0zmxiSHqAM5tDwaqOcJaIpKE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761079411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jca+iAluyvXYfcIcNG0HUymCKJQKka+3ZoKebkZZYlk=;
	b=MrHfJ5GiBUFm7KqFFr2U/9vMbz2qElSDeLF+RaXNERDjErmUR2olNmw2RDARgVli9n1AZB
	mh/Q74ssMqGfKUX8HL73OgTJhA7XLYaGsfzZtlsfqBB3eCFWeyq7L/phWaSNf7ombSaV5M
	3W4kKJjQHUMd30Eb2HGa4BuPWa/gL/M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-u7ttyavbN0qMcxOM8t__jw-1; Tue, 21 Oct 2025 16:43:28 -0400
X-MC-Unique: u7ttyavbN0qMcxOM8t__jw-1
X-Mimecast-MFC-AGG-ID: u7ttyavbN0qMcxOM8t__jw_1761079407
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47114d373d5so56889045e9.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761079407; x=1761684207;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jca+iAluyvXYfcIcNG0HUymCKJQKka+3ZoKebkZZYlk=;
        b=XlGJOAb7FRzUpSEXy1BkAdmpLTdzqUY6BIcY99sHjaaAbYGs9O0wH4LpJAV/aZSQTK
         E2bJthApDaYd6IXr/ArCHZrPEaEccpXalPSFpOcKhKKYKaaKQBWJGEJCixHEh7WVbnuC
         AxukVA+7pVWnQ4WMR/7R88xudrbZbxbsoaCBvo4B5azgGE/B8SokHpRdMJU6wySUpvtn
         tqIUnAHy7KFhy5ZbY5NTny6elMxrHL84rceeKSvs7w8po8IusneeJGDTFh8RO9TMxbw5
         6Dgu6IuIbLs1kp/pYLDm99/wCAsPD+RxEn23J3y+euFL3CE7hnV8YFFHoULs3ClTFIVs
         gOyg==
X-Forwarded-Encrypted: i=1; AJvYcCX2bvx6udUGLkwAC7rcrZFXgr8BieUEGnH849kU1UQxzpUW+0l8dO1i6exhWHoaRkLrMBuOPd3hSQ==@kvack.org
X-Gm-Message-State: AOJu0YwVgsAQUr28cr0wIGaXiYI1+vS4//ZeA2FVPBtLrKrNBuZJ8Sri
	a88F8fs8jvyWpoWEBk5c8rzklwYa4A3gGQVFkpQr9wQ63TYPWaUw6WyjoTl84yhwX8OhdzpV6mV
	PgfJmGslebTriVN7DaR7fY09msMR2XAxzdQQy84UoC9wrX9KOKo0S
X-Gm-Gg: ASbGnctvQqHm6U3xYrIb+QJuFdqAdrI3asr2q8L18CTMK5VJJYirMDvXAET/64wnkfY
	/uDtVZx0YE5IDXa2pFWMvwRqT4pGbyDEiVdHmADnq+vS93t82jdTjsGBjcXydzF5QfleOpj8/CJ
	g4oLZ4IUawuee5gBn90KvRZ4RVaUKsTgq4dIFb3aO4gmNSCTY1maeZTJ0sssTLj44VzpAQLcQHj
	AWiqoYLJuqS/vOtCJRe9HwhKoGJOEl1SrO4jXRgKT5H9KeLcntYFDkmzjcHW9PtAX0tKWNjUfCA
	23CoyINi6ytbxG/g3946Ov+YI2MhoieWKxqU3DTN59MIm5iIvgHdHvp9k0jnwlcIeUKK
X-Received: by 2002:a05:600c:4fd4:b0:471:13dd:bae7 with SMTP id 5b1f17b1804b1-4711791c5dfmr155489225e9.30.1761079407243;
        Tue, 21 Oct 2025 13:43:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3tqHiyIT27d9/w9pV3Cihx1kc1ZDJQnIJKiIuWuTpURVwED00bfMi5FBVB40yx0uQLffj0A==
X-Received: by 2002:a05:600c:4fd4:b0:471:13dd:bae7 with SMTP id 5b1f17b1804b1-4711791c5dfmr155488865e9.30.1761079406669;
        Tue, 21 Oct 2025 13:43:26 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:152d:b200:2a90:8f13:7c1e:f479])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c429e82dsm9612815e9.11.2025.10.21.13.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 13:43:26 -0700 (PDT)
Date: Tue, 21 Oct 2025 16:43:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 03/23] powerpc/pseries/cmm: remove
 cmm_balloon_compaction_init()
Message-ID: <20251021164220-mutt-send-email-mst@kernel.org>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-4-david@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20251021125929.377194-4-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MA__FNqAg-yxEkq-sWNxtnoNjoZgsbmKDLgOAN_muW8_1761079407
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3CD29180006
X-Stat-Signature: qssqxsjobmieixo5ptigxismt81y1nin
X-HE-Tag: 1761079413-609043
X-HE-Meta: U2FsdGVkX183v3kKe7QU/Ir3jTCzbki4o31diGwIx8QXTzIYuxxXgf9iW9CbklTMr7Wsc/aVYIXkc2ecAuoGDQDGCRWxfyGgLSZcRRi7E02cF9Dcmwr0/kbJjSPdX3p2p1tLkhzotxlg7h4i45yO/B1DMj/jIYWyKnwkfNhfmvBQGqEdTD6KnHJZL474AwRZR/GCH24/qn3EO6/qchaZY6QXqDlrSi8z3GoyelpzPv/odidbbFXXlp0plxxdlbfkEpBnc6LbTL9dG9w6xpB3mEELluLCKkLNY9p+xSE5sels0psVHOX9mqLXNtHYg+OJxmnEkdKbu6llq7MheF3VMiU5r9kno3xqDBGtvg9VOIEUgv+/MvTCLuBdbsEmPo4fXp0UAH4NfEahBTqsC8ETxGqIF+s26du/mJdD/FQvs7L8IsRPlnDAemzeqyNDWorYGFHwp+QeAYLLbxEP7i3RUQch1xPugkU8DDdkCa3unav/uLmaVhkh/rMxblCokCa98feMrRSeSQ3Ay7ISNDZPxm1AGG62IRbeI++fXY20z+HZTGwje80Lio8M8L0xtxx7Mj9vb9U+wjRfuzfAiistYsNzByGBwwsTOLQVWhkv+MUmj44sAMCnblvORqENQtDYnBvrG3KHScsXqlgep2bB7bi4uTOM+yJqt2yErYMyYsvIQ/uRCC0qpCosMbs0hBJBYJ/KxPlyj6fRzVWaR7t1Diuw5zTEyV0F0/AaOaX7h0smNV5nE89OQV+90DM0xhBSbvt3vaR0P6hdhsvoPXhQpAkYpD4Hp4nhmddz7BM936Ibb5N3vxHy9dfcZeQ7PP9Ku7Gb4prZklrOqcYfsFATzvnCi7yso9OAgE3cPZbP0ePO3TO7MKxN1ox/1OViD7sd5IVYTkfXUeWB1P9pY+RMwonzKM3CZDjNe8rH1/67YcotuOZ/bTgSLuYRzPVUpsitN7sBAfQTNEK+4/ENGZh
 Kh8ST3C/
 Z+KzRTNTlM0rVoFWVkZJMtwU5sjfwutm0JXck3fbe4SIECfqrSWJhIEyhu3lvSg6rpeMiaHPC8roMfOiXH0OavB8qmERhS3vMdzYHHlFbkfBJbh4jKL+Ekr8lXMTT0NN4zbuPymJSS7xRw1qpYI7T7qQtbtaT/aYy8IsexL+clLdvqVY3YEYJvG8lhDXHJyjiCVQ5sGX/cTunpMaC7SCnh9joNyOV8Is6Kyjvlps7M9PSvjQUiJYWaFWUZrhoCDdW1r2pj6I3ApC9jAIVAmgtkl/Jt/Lav8cB96TEeR1spljgQD71N2WlqkkHUoHNRfEOcM8DQUjiWY94RzmMrWphjwr0R6qWopediufvk6on7n/J1Nak5TOiFx1G+Ge5i0GM5edRGItvZoL+PiBCUlSgnljKpEKFjs4R5GBPKNWDhuFvMl64oj4mxmXKus9iXeEupX/u5B5zPyPR+gxsu6TJ3MFYjru0wI3zJn+s3etCeFaehZiEPEdQc9+Ywfksm39uM3Vh1/Eyyo3zcOTSNkPfbCv2MSgaEOJBB4TYcEjLFxeJlqHNR+YZwQV+IYZZiccnJstoIZkjh9eq1AQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:59:08PM +0200, David Hildenbrand wrote:
> Now that there is not a lot of logic left, let's just inline setting up
> the migration function.
> 
> To avoid #ifdef in the caller we can instead use IS_ENABLED() and make
> the compiler happy by only providing the function declaration.
> 
> Now that the function is gone, drop the "out_balloon_compaction" label.
> Note that before commit 68f2736a8583 ("mm: Convert all PageMovable users
> to movable_operations"), now not anymore.

What does this sentence mean?

> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/powerpc/platforms/pseries/cmm.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
> index 310dab4bc8679..67c7309c36147 100644
> --- a/arch/powerpc/platforms/pseries/cmm.c
> +++ b/arch/powerpc/platforms/pseries/cmm.c
> @@ -548,15 +548,9 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
>  
>  	return 0;
>  }
> -
> -static void cmm_balloon_compaction_init(void)
> -{
> -	b_dev_info.migratepage = cmm_migratepage;
> -}
>  #else /* CONFIG_BALLOON_COMPACTION */
> -static void cmm_balloon_compaction_init(void)
> -{
> -}
> +int cmm_migratepage(struct balloon_dev_info *b_dev_info, struct page *newpage,
> +		    struct page *page, enum migrate_mode mode);
>  #endif /* CONFIG_BALLOON_COMPACTION */
>  
>  /**
> @@ -573,11 +567,12 @@ static int cmm_init(void)
>  		return -EOPNOTSUPP;
>  
>  	balloon_devinfo_init(&b_dev_info);
> -	cmm_balloon_compaction_init();
> +	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
> +		b_dev_info.migratepage = cmm_migratepage;
>  
>  	rc = register_oom_notifier(&cmm_oom_nb);
>  	if (rc < 0)
> -		goto out_balloon_compaction;
> +		return rc;
>  
>  	if ((rc = register_reboot_notifier(&cmm_reboot_nb)))
>  		goto out_oom_notifier;
> @@ -606,7 +601,6 @@ static int cmm_init(void)
>  	unregister_reboot_notifier(&cmm_reboot_nb);
>  out_oom_notifier:
>  	unregister_oom_notifier(&cmm_oom_nb);
> -out_balloon_compaction:
>  	return rc;
>  }
>  
> -- 
> 2.51.0


