Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B019ED16814
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 11:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091786B0088; Fri,  9 Jan 2026 06:09:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F046B0089; Fri,  9 Jan 2026 06:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D376B008A; Fri,  9 Jan 2026 06:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6C656B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:09:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 90EFE1A049C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:09:26 +0000 (UTC)
X-FDA: 84312154332.22.4B3FCBC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0CAACA0015
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:09:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aKOO1ICD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767956964; a=rsa-sha256;
	cv=none;
	b=npbT2o+lmKAcPSrL8dtHe/xCpshUv4tdnBdcmPG6RFI0VbnVhLdMtdTgPZKDgyuIqQEs/s
	IOTtwgVDVvviYxnV8KdOU0ynQO8ygbIGBdeDjSbSQ+GeSLt0sfRTqu9sZ6igoztuWc1nKN
	0iWqkJw8W4rFkDGHp2Mvb/KGJJK9QiI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aKOO1ICD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767956964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WLh4YdMT4BQhhiGpX2c08r18nWKZ1SS4NAmL7UFi+k=;
	b=y7+BTn1Crbq9S5J0BHWspAYq0ZsgRWRG0ULiuXy1Ru7gPX/GNc1z4yAwcdXFRaDdpfSvqR
	t+fPOcn+cEPad82/e0qCAs7i7NGeUglJ/M0C/Mzk/QrBZvUBSeYG+k9pJKnHh+m4qL/onK
	1MU+Hw5FGeOAy0mJ147weKyNONuDbOg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767956963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+WLh4YdMT4BQhhiGpX2c08r18nWKZ1SS4NAmL7UFi+k=;
	b=aKOO1ICDaLzOW/be1m+BMMUZTPefN/5RZwFT8Z3Rhslz6wNuuZ0TsgxyokgrHGQbdCGOPw
	uZKJBfsnUalWPlwOqQqnR621LD/7M+w368DBtFlh0TiENOpLrgm0Z1LJOJ9zaIKzkbE+85
	PPlYs46Ze8+DG7ZMGs2g59ywtq0I7fo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-1NcQox6yNoCXRn4iSjj8Bw-1; Fri, 09 Jan 2026 06:09:20 -0500
X-MC-Unique: 1NcQox6yNoCXRn4iSjj8Bw-1
X-Mimecast-MFC-AGG-ID: 1NcQox6yNoCXRn4iSjj8Bw_1767956959
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59b3b255ee8so3825977e87.3
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 03:09:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767956959; x=1768561759;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+WLh4YdMT4BQhhiGpX2c08r18nWKZ1SS4NAmL7UFi+k=;
        b=n6sqBoBTb8R1pQno9YCYswlHZ3bzsDuvsFFCpDQ7s2Ds22Nj4YmSStPgE3HXWWHsTx
         0x7WHCFYxxsf9JOSqDBmllBJTObda82CA+vHiAhrXvlomU99DowAYp5+N4lQd02bdhth
         IQ/SbaLwCKX0GO7F1ghEfrDZLRQL6qN1i95GHCYwjVyj7Q7oJPAYfcBL3kWIBfRij39z
         QxfDBGktEeSwhD691QkeotovR/Cdc+e3as2vF8TQb6qrBkWf+9fo6keuPAPaeV1os/bx
         vgbqDDX8Awy2QLIRON9P8p3eMe1dYNKX9AaK19Ihfj8baKXyH8QX26fvz92KbAxLjp8I
         izqw==
X-Forwarded-Encrypted: i=1; AJvYcCXh9/MuxNISgUm68wRqMvYXL6Dr+TNTKxls3Y1IR7wEekInt42dWo4rW/1ZpCJvLgNpAjDUjMW8Cw==@kvack.org
X-Gm-Message-State: AOJu0Ywm5muOhK+qH5O2xMOJe/YKOQFLp17ljySAHrFGDXHRJMDIIc3a
	MQY0Hs2IJ2Mkyh7Zy2aAVAFzGy9/g+xsc71wnb5L3piXzCNlRL0akdc5EAaNGFonzcbaO6tyOJv
	UjupiqBl+sRtWz3xQjeWtTWBLvlcuZZ0zeEQPXCZCBXlXgr6HEJI=
X-Gm-Gg: AY/fxX7835CFx7PzxwAyTmQHG5RVHEf1jY6I2O0nl25JfpfweqM/MfScD1GbfWCpsDX
	eqgt426TFkWqbSX2u7m2yrkfcP75sW3tucHZIFDLrezQXhUiYfs6ynIJYYX6IWyadwrJ7MDlmIL
	S5jx5U0em5cvdkUU4dZyh9c1870XEGbjcxnKBG1whzS3qTBvRtwkUJp3JpzBdjAk4VGeAYKFwaC
	J4D0pGpu5tIpeXzwuy9AyL1klrFtNFPueWNdBlFakhjDHNO1OixCyJNP7UuIA/lf7ALi/b19Vvy
	pXEBcOTYOKsZLrxmYj/nlq8eOEa0ZAYbIWn3wZDqwRUq+k71hMiVB/vS4c9MVWQKG8JDd2xkage
	Yt7OsgLrJ1Iew5mI8R/H6Iw0GWJdeXNCKC3w=
X-Received: by 2002:a05:6512:138c:b0:595:840c:cdd0 with SMTP id 2adb3069b0e04-59b6ef23821mr2942328e87.2.1767956958655;
        Fri, 09 Jan 2026 03:09:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1Kdn6xqqEz7oS8njPdOYi3SCUUHgKoVYObUp3Vur8XucGkM8H4lTSJgH2gDE+3acZOyL3Ug==
X-Received: by 2002:a05:6512:138c:b0:595:840c:cdd0 with SMTP id 2adb3069b0e04-59b6ef23821mr2942314e87.2.1767956958199;
        Fri, 09 Jan 2026 03:09:18 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d0f6absm2716455e87.42.2026.01.09.03.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 03:09:17 -0800 (PST)
Message-ID: <d1d80b81-678d-4d28-9ac2-95cb74824e73@redhat.com>
Date: Fri, 9 Jan 2026 13:09:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] mm: Split device-private and coherent folios
 before freeing
To: Francois Dugast <francois.dugast@intel.com>,
 intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Balbir Singh <balbirs@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260109085605.443316-1-francois.dugast@intel.com>
 <20260109085605.443316-4-francois.dugast@intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20260109085605.443316-4-francois.dugast@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4uZV81KYpYIQ3ALwhQ3w02albYSeYurGt15lnMYUXPk_1767956959
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0CAACA0015
X-Rspamd-Server: rspam06
X-Stat-Signature: fhks417jpkc1fuidawodb71re4m4y97m
X-Rspam-User: 
X-HE-Tag: 1767956963-700019
X-HE-Meta: U2FsdGVkX1+DM27vcqxfO7j9D0VQ/cMjm8aXwJx9oBI5IJaoXH3ga+YsJejSYJSVbG7jKa+TXzMjfTVs23LxxxeozwXRp95Xao2RPDWeGhtW4Y95abar7mHerDessF5S0iG4Yk+S+fbwJEBwmfb+f1+GJsJjMbOJmyZiZc/Kzt00reP4dGKpv9NhB/mjjQKEkaEMIzztl74k2ng+Wh2B3JBYMIad8EBf1EE+FAXy/zjJTRYG4NV2hkypoF8pjqbwX9w9EHeQr+H5Z3BeZmsTjblC+J5Yckm7IrBVqSPPpoZngYxIJiXhLo8Z3XLYuxnk2FiG6cnFs37XfDrzuWqSnDkIYj8RwDh7MZ2hiKfMd1hZtW8HywW0NfexgkJbU8LHtqfIp1ehop3NeGKlKHviJJWK3rs0dMVmh3zySJ6kV7zpi2tsvd7JZ+/FPOGQ7+GMCIdG0FBZqhmvSp+0MYgNh+kI6v77Yuu+tNG7QcFZWLWenVIbClu/ptVi74DbkW8mEq2mlr/BJ46fjhH05Wld216UWzgTzbQlN2tdKXSftmMtp5Onxjpv7KToyKHPXaY1VHHYoGFnRm8ojqxNILyLJUmM+o3xviFWaIVJVxPbWzM2Ssmgd+VMBqrl6Bw7OjaSYEoCZontGxDIZq69I6+qfn1EMC30eYbfSr/CMMzVst6pbmjOC+8XfQg2zQAK/QO7N4JXw+kjrOgnYbPW/DY5X/tbDogBhhSY24XZJWAbM3BF5G/IU8omq6zhkAxOXmhNSDU0iLWodVEq2t31lyec89HAGY/qo4vX2HYhgRW4qOOlwctwewyNfxbT4DIL3MK0LOHdSQIuPOlY5i26CuGGgdKsDx3WT+buFEIgOoji7Ze+c/FnLkEXfudicMvKW4ebrpsPW9IxTGfaTz4Q5UlfApLEGX/zJ9SFD7Ia7qNa19FnzN+zWh50Ox1MG/FdCzlfZ/SuX/PafQS2wYeNxBM
 PhJtS9FK
 UVF+gPKPQ0wJpSs4yOybhBYQd9XJIPrIEqz25hHn6rfpiBYfhROqND0SIS+y9iV9bxfpnSEqErgjIzrOtZIkXQUyyhqCwJHeQIGwqlkXMviiTzHNiH7xG84saBleHcABnx/kneyMxR8bGeryVgAWF0dYMDZIUixuF7f2wOeEyEhD0Zg4YrsOhC76LNgildd4+WmM9bHsLj36Sh27vGJjGbrsi6+XKwSprIkFs57ehGTriAGrpA6dIm+7CQTNhYJgHLxGHCngF5v7o70vwfhhUnz6V6Ilo6zzCQeaWe9/tT+C5BOpa7L4cImKDG5AqgEIgU+QaMgL730SortCd/FEJW7DBAVj5dU6uxkJY2WtU0YabZEh6kK8aLdTHocRiZFVEOUMqz2TZNjjCPzlwN1kSQYMQ300KnXwjSTpHvC1ZtvShMTzfWnQUxg6S5uuyXwpyeG2sgPoz2D+lS0OTq5cFs+rzRMLB/6q69cOTsL42oHKpt3cZcXmYZiU8c7eGiQRRKOFQAzdpDSe/2CzV3xdEuTU3RxAGCladD1h1RV6g/NLUHdfawYHsajTwKDFbdqTGcuqvPg2waVVoEsRLU8nMNmv3H1BDGCYDnEEZGmjte7hY1pfkktPg8nm1BV4kjeNnhn0BWWee1xyUejo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 1/9/26 10:54, Francois Dugast wrote:

> From: Matthew Brost <matthew.brost@intel.com>
>
> Split device-private and coherent folios into individual pages before
> freeing so that any order folio can be formed upon the next use of the
> pages.
>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-cxl@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> ---
>  mm/memremap.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 63c6ab4fdf08..7289cdd6862f 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -453,6 +453,8 @@ void free_zone_device_folio(struct folio *folio)
>  	case MEMORY_DEVICE_COHERENT:
>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
>  			break;
> +
> +		folio_split_unref(folio);
>  		pgmap->ops->folio_free(folio);
>  		percpu_ref_put_many(&folio->pgmap->ref, nr);
>  		break;

This breaks folio_free implementations like nouveau_dmem_folio_free
which checks the folio order and act upon that.
Maybe add an order parameter to folio_free or let the driver handle the split?

Thanks,
Mika


