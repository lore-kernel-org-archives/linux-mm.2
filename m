Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FEDECA0FF7
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 18:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1094A6B00AB; Thu, 28 Aug 2025 14:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9AE6B00AC; Thu, 28 Aug 2025 14:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2F86B00AE; Thu, 28 Aug 2025 14:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D746F6B00AB
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:53:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9027C1A0364
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:53:04 +0000 (UTC)
X-FDA: 83827063488.21.24C1D7F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 130B310000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:53:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U+89NkbQ;
	spf=pass (imf05.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756407182; a=rsa-sha256;
	cv=none;
	b=UsLvc6fJ3RP0CNcBIgTszSPoViLU4FsqeYds5f2aQ/f5NNSDMbt8REM3QvUSsiTJITAIXt
	55kkO9x+tIYIMXXsxkbv+yFInHQ0GBc8Xh10zNlK8L0x+QWziZaIZpZn/0urz4wCtT3NpI
	LXSln3kPGqiLW3xGhUuLtEnbdQ0vxVo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U+89NkbQ;
	spf=pass (imf05.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756407182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ox+fdqHLvqvHkCQcV7jSITHMPKa6EWT2tpRcTnamaBA=;
	b=FNn60VbPMzxqBi8zV+8YLqaWMHO0nUdRyWGXNsn8mxeldwHo+rnbmZSbGNB5O3Lok2yQaN
	6XDsu7hvI/PvFL1jOyPKzpmT10NTRzT6g62ADLDB1gFRRFiBlzHL9qikuHgOva+ApWTmB1
	cSL6OrrginaIcsUbmwOqwC5uFfH6yhE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756407181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ox+fdqHLvqvHkCQcV7jSITHMPKa6EWT2tpRcTnamaBA=;
	b=U+89NkbQyNI1+3Ir0lz7vt0x/cDlYrHLPPcYKX2OPv8Q1Eqe6PHr2ZkX3iGiZ1DDDgR1Yy
	FjzKu86J4Hfhmoq+rk8G83VOujQjPE90Gg2JopH3pmSqc1MWxd7HiPQqbHNr4zgWZ63K7T
	vQvyUuCtdBBMxw2eQlA/54U1EaYEtyk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-_pKUF0y2OuK3m18QYvmvyw-1; Thu, 28 Aug 2025 14:52:57 -0400
X-MC-Unique: _pKUF0y2OuK3m18QYvmvyw-1
X-Mimecast-MFC-AGG-ID: _pKUF0y2OuK3m18QYvmvyw_1756407176
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e67d83ee31so2007285ab.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407176; x=1757011976;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ox+fdqHLvqvHkCQcV7jSITHMPKa6EWT2tpRcTnamaBA=;
        b=TWAEhMhN/AEhY8NQ+g5fLtNJ1N1bXv9oCeYgGBS3zkEaZyZGxbDUcOYk89/uKpFVSd
         7ULEB0OpaSt4+sKc8VmCUrYIyKMhCVv9fBzWrb+LAlfXY+ynUAOfIQGTU9h8lKF3L2LK
         JWXtosC1IYIwAg6m0EfZc/Aa+/VcPfX6CxDOsWESToCMKAJjjnXS6OYwa/Xbe0KnHXKD
         rq0l5WYIHmGFqQ6WsaiVtKMM7p3peJc0ChhwgGAnRqfyP5sSquMbJ8LtxOQPyVzSq8OX
         xMichwbj8iElxLqPhssq8kcXeafJJtqboECGxRj8m6NslDiypEjBo/hqCgoIlDgBt9RK
         ZyAw==
X-Forwarded-Encrypted: i=1; AJvYcCWK8H3szkJz35//gHtR1qqLED1bO1trb0XeWlDzXD7vc4cE7iurbXnkgXhNu21f9Efw8Si/9XzY5A==@kvack.org
X-Gm-Message-State: AOJu0YzEIhQq37zgOCBeYtAMlZlvy4HJP9YfE6aIvkCPITDqILFJ0nh0
	2WAiKAHLQnyswiJvZr5CJwD6Mnrp37y0hBV8Y2jtaJP7cWn38qE9oMy/aaU3GECDLHwuXiLtZn2
	J372ODyzlwdUFRpf9rFiaARoW9kOByot1rUIoNeykWVYwCVXi3dG5
X-Gm-Gg: ASbGncuTQmtbmb4dR5IHggq1fMdtzlgm41cXLM3Y0gog7DENwPnvzCy6D4siTEUkdgR
	TKR628gRlCynDqc8fNBsNsYI+vJssUGQF048RS2SZvFN0dhBdsLJHujB8hRYTnnLbAecSV9Jbu3
	xUl2goQLkVJ2EvcS3xqUsquNdLsiesZJKwSxpD9zRXpbdwyJNevYRuj7HqZTVMOtkBvkPdUU6bS
	/WcMP7rl/d97cwzcbJlSONxp120fIDnPe3rD5pPVQFAF5WHv4H2m5jYQe+KWmQgHi4von76afvo
	BnyMzQAyd2dAlKb9O07Sjg6/PfLUIF+lOOxDa6cEx9k=
X-Received: by 2002:a05:6e02:1a86:b0:3ee:cb14:e90f with SMTP id e9e14a558f8ab-3eecb14ea03mr61888945ab.7.1756407176428;
        Thu, 28 Aug 2025 11:52:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEP6X5C8fKyFwSWmjzqPdfkbd7PprjZnYQm1xQXLb3Ss2KjE+y/MhfTqxlaUhO3jzRNfBiTrg==
X-Received: by 2002:a05:6e02:1a86:b0:3ee:cb14:e90f with SMTP id e9e14a558f8ab-3eecb14ea03mr61888495ab.7.1756407175934;
        Thu, 28 Aug 2025 11:52:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d78c67b4dsm47783173.7.2025.08.28.11.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 11:52:54 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:52:51 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Brett Creeley <brett.creeley@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
 <kevin.tian@intel.com>, Alexander Potapenko <glider@google.com>, Andrew
 Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>,
 Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry
 Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
 io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe
 <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, John Hubbard
 <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu
 <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, Suren
 Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 31/36] vfio/pci: drop nth_page() usage within SG
 entry
Message-ID: <20250828125251.08e4a429.alex.williamson@redhat.com>
In-Reply-To: <20250827220141.262669-32-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
	<20250827220141.262669-32-david@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 53U6F7DVDrLhFhfujjtNnwePjsHUa4pKc0zgr8kvNcE_1756407176
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 130B310000C
X-Stat-Signature: gyfxbnpekj564bhckeqpgf7j5whhz8ho
X-Rspam-User: 
X-HE-Tag: 1756407181-222509
X-HE-Meta: U2FsdGVkX18QMtxvBixQ9CleD+G+FvREdXuXaahlUwra93Hx7X/k9ysalWnA5eHegMhbszJ33Q0UkHVuVQK+aU4CGSs01Fovm6aaJq0Tk3rlF6MHDm6/nAeUhmcZiKRGC3HtX03lUOHvJlcQ3irbDfLv0o7X6CvznmShKJfZLxdr2IrkPXiy/jsX+2ynlkdrg+By54WJwTt9PvSupD9usyuj/EAfABYge6zVW0TjMR8Z5+5A7Mqq/7gUUL5ynMzpJwhE9b5rwcB+Amyqbwwb/cbZA/UM2Vj5TF4A6PkbR9Hstz5Aoan5NmRw0oS/I4B6ALQVzytaVDr4h91WemNbn0GqrekbRnc8NfbS0kJZ0H1luYD20z+l3aXDM04/gNFCmMk+x4tv9rNm8A1+gRnneawcEVoTiZFxryALOSHfO/IRF6W/ydOlXTGXd+fecdF1ZoUrJrbmmESZc3M+qbcUxQpLHgPl8lJalt7dsPqcmv+0sVuGE6roE0Pd/mX0Epa5TxdiO0LkTqXLLFyA8LAzk/2PxZbg2T9Kapq+NV9P3gKe/40kX42e+pYTOKmIHoP5trIDYUs9reAkYGm9HvebcLjbgNR9kHGGrqr5xQntr1Gz1zMoKoBcwqq2oahB6dqcOcK6B4vEZKvUrqfoxDXVDw2tM3nOEkb0yGXjYNuHiBQUO7c22CibvD7LtDpH2GXV3Uo+eIgXeoki0Ok7b7RI2hN/zvd9a0lr4pmif9dvj/S+YK8roDZ/PXcTdBRda3VqBebz1O6GJH76aG8XexegThgSo2gnPyYnkj5ATQFsJfuWUBHOtkYNKFU0zBkZAh2As7MpwhI5BKuOMZ9gbxID881W6ixP63d3Fi2r9YXpvWGzZtr32Rl/XinRn6RIFvucqKKYwW8CHUmmMbU21Pn9A/A8Tqu3SavhLCOe/TBLhvenHeGmHj5DyQvyUcQhDlHLcBkCGs2cXJhzKihaJjW
 byorDYNQ
 y3jqDcHbpqYX9ihsDH/KnnSrhim/0Q3oo6jDIc9fPofkYbqDYe9iGUQ0aH4vpmVbKtpEtRTbnl65xl3Lg7XAziO75xMbIY8+LBfB0JMavI1Ser8bTYMS+wt+zkikflwsIe8nA+c2BIpdcTurf1nHh4iNWag+KSnojzbkZZJjClRHTPfnOew/mQYL3zwmTneDW52JeHIx7+ZxSMpFcyZUS9sqAePdjIJ7g53GeGdbbzRVugj6yu8/7JemGseoh/judy65m8F+wRkvaJWtDu/XcWyf0Vhko75hP/a4Gv4bY7cksiaHuRzJC6TTjjl5qGXY4HbZc24Vh3ZUZ66Wa0/oy81xhwTLIi1MgUuAzp++P2Q/saxyRzIwqCOUq+r81L8XxtI6wa54IGoxvvAyS00G75fGaUqOdBJ5eF4TpJ2FVnrK0oZuMPSKVo+JykwnWk5al8D31FXKWxR8Bs8wyLPG0i4vdh8Omxp1t8xy9NA6gz1tqswiYQO9Q/NVIkXMu8K14T0K1q3PTnjjrO0gl09j2RK0mPfQ5lhRXaoZpCuqxrzZZHKbFxZYrLHdMDiVppGBUmDaoNXKb08DbbHe5EXld4JdRiRfX/wdUA0dUYt3L4sfLPVCy7Pqe/H1WQ2mA+vleO38a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 Aug 2025 00:01:35 +0200
David Hildenbrand <david@redhat.com> wrote:

> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
> 
> Cc: Brett Creeley <brett.creeley@amd.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/vfio/pci/pds/lm.c         | 3 +--
>  drivers/vfio/pci/virtio/migrate.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> index f2673d395236a..4d70c833fa32e 100644
> --- a/drivers/vfio/pci/pds/lm.c
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -151,8 +151,7 @@ static struct page *pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_file,
>  			lm_file->last_offset_sg = sg;
>  			lm_file->sg_last_entry += i;
>  			lm_file->last_offset = cur_offset;
> -			return nth_page(sg_page(sg),
> -					(offset - cur_offset) / PAGE_SIZE);
> +			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
>  		}
>  		cur_offset += sg->length;
>  	}
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> index ba92bb4e9af94..7dd0ac866461d 100644
> --- a/drivers/vfio/pci/virtio/migrate.c
> +++ b/drivers/vfio/pci/virtio/migrate.c
> @@ -53,8 +53,7 @@ virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
>  			buf->last_offset_sg = sg;
>  			buf->sg_last_entry += i;
>  			buf->last_offset = cur_offset;
> -			return nth_page(sg_page(sg),
> -					(offset - cur_offset) / PAGE_SIZE);
> +			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
>  		}
>  		cur_offset += sg->length;
>  	}

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>


