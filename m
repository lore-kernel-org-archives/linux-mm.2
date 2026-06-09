Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B4B0CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6111E6B0005; Tue,  9 Jun 2026 13:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8206B0088; Tue,  9 Jun 2026 13:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDE96B008A; Tue,  9 Jun 2026 13:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40E2E6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:44:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C68741406A9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:44:43 +0000 (UTC)
X-FDA: 84861099246.17.E355840
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id EBC9218000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:44:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=J3VBvaZn;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781027082;
	b=uN2AWn7q4lZc0C5Ghuca+CTjSM2o/tcRojVtwThOolIEADmv3FQCuZQXM8+5LX5Wx0M+dn
	Q5GYFIeN/3X8JMM6pmFH+ALBIT344Dh+Ttp1PqYQ6StSK/JuOjflJJXRzJegvWl6d9sHj9
	TjMtMawRu7S+f9KvCydhGZeywW9rMLg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=J3VBvaZn;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781027082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=taYzpL3NOUpJl8K0/+Ucx7wOW5hZPsWROMd3M/VgR5g=;
	b=GjaXddgnUKlnWkEEnF5YxvBjaOK8fVrP3tq7VpJr7YFPxkZAqegxK3WwpWdro9eWURNB/v
	iwmQR47ecaTUPO/HHSxSsVs3J9uUMTJBGMDP3YhL+UcOCigYySRefxeUBJkYLm1a7Wid0+
	1G9KZzP/VgQBKkJ/GDevQJs08etWcIc=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ccda0ac4fcso59412176d6.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781027081; x=1781631881; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=taYzpL3NOUpJl8K0/+Ucx7wOW5hZPsWROMd3M/VgR5g=;
        b=J3VBvaZn57ygyg5m8Iw9+bsgZVM0A4Qld0d6eyGAHrD3v71/QeuUcopKaawjp3F5FL
         Rai7FGOxgA5nG/1+RkRKq76lYzqZHZzocLrcsvyCeDG5uVxB/iF9EMBpfZuXzaxiMm0c
         uJzmAOfbBoGr4GSAWRV3oTFSgEIukoEScJlNASDF8aIZ4kJuKaTTuFMtgVjRrzl1S6Rb
         sPpeuSXKG3laY2RFfsOD0o0XfOTenEmsyOjqnTfvLXMMV2ScF0SCvxx7YpVznJCpYAPJ
         L4jhd0m6z2xj+gOnZ4BQ+7eAyFWTxP71q4KjbGbZqjvgU1ePUuOw6ogUdCdykyImKmVO
         eHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781027081; x=1781631881;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=taYzpL3NOUpJl8K0/+Ucx7wOW5hZPsWROMd3M/VgR5g=;
        b=c8x9Ng1JASze0h6rN2hjs7gAr/TCYCfDZFHe8D5tceXzdJecwJHAfRzDKrwlDCNGTs
         f8hfULwLdNabzGXiCi5gnxwFtEM9/NpoobG2OWvJ66l10ZNFQQsKqOX7UnnNkCnHn0Gi
         onPZX31ms5OOcfepDLKB9UAXUNeNNAfJfcbaPojoYVgkFms7EpIlcphQhGg+LGkTBpiA
         cYftrF2B6tsNMOQtQEtRV/0TPsdPf5cWQZ2OtOH3roPRknNJOKJ4fgloA9cEfx8ee858
         61ieMcmzG470wVgfj+cXrWzKBbtvmA/WEz32X0SbkhlK7jPlX3aZLJwEhNzs1lHHiJMo
         BWDg==
X-Forwarded-Encrypted: i=1; AFNElJ/pUQ7f8fi9l5qPX13I1m8ZLUuDplOgftpta4h1Zzyvg5pMa3eEQZABBmI8GZ3a7P7I46fH5Y7z+Q==@kvack.org
X-Gm-Message-State: AOJu0YwfoD3xvEo0VeqcYWBkhM91egugQqXMLj9UxjJxP6InbxIEflHv
	zbRIoKNsOYDAYUsgknx/zumDIj6PJQn9h/AIiRSHn4JaahTnwc/SkWIDvMXPyhb2A54=
X-Gm-Gg: Acq92OGDju1xfJNrFn/Fxqtbzx1T+uoJIpGP+rQJFf8bKXB3C0x9Vzx6wtSNxS6AMBo
	zGjibCZcsw7lHMr6Fb6qj3ImcnLCT0WogoZzcz+j5MYMUWHHpnkJIc4iAvA+XAF5Oumj/+/Mdxm
	UqPtTEPlvFZLsu3pONT6VDylGN+xb4qDwORfAH3/ChiJEYk2LRH0kxXgekLdNBxy39qaDW7CiZA
	tIH43KaXF8APJgyEl9gbyfLER44Y6vdzjNGtVG6f1El8ceatwNCBTT696TWkmPHZF1vekkxNoQx
	Vrl1yru4ooSswdZht08bwCCVRYUuXQNUEm5mXqz6pq4HOtnvciKTGLNTObyGrLYKtMFj44O38SI
	Ya146fpJo1MvMPVTOaHlL/on1vGQit/uQR4Uw2py6GbhspW4BVcd0AZT10hOBf5GcknWVeQEw4G
	APfk8+KG49O7vkglkAmD3+Zk/1DwPBdxo56RikTWh9jPRogYphZ/+U4at90edXJ5T6+1yJ7zAHa
	f91//B3FAmaAHev3g==
X-Received: by 2002:a05:6214:262a:b0:8b3:fb6a:d370 with SMTP id 6a1803df08f44-8cf1dcfe9dbmr56987546d6.37.1781027080849;
        Tue, 09 Jun 2026 10:44:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccdb915csm211312426d6.14.2026.06.09.10.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 10:44:39 -0700 (PDT)
Date: Tue, 9 Jun 2026 13:44:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH splitout] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <aihRBTaTUmgYmZfX@gourry-fedora-PF4VCD3F>
References: <b25ea6c63503f24c8b5b64910a44dc03b5aa610d.1781020302.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b25ea6c63503f24c8b5b64910a44dc03b5aa610d.1781020302.git.mst@redhat.com>
X-Rspamd-Queue-Id: EBC9218000C
X-Stat-Signature: yosbgytn5jbthfe17kh914p88r1wbmpd
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781027081-694347
X-HE-Meta: U2FsdGVkX180HLm3HFMPo7i1/wMn0Zs8iVguvMlr0pwA2IAd0zJTlGuv+lm12eunGUd8ISXC4xcNNv6i8BvCKslJjObT1jdNj9u4vY9+O6irspUwJVprotFzo5q7Fi5MTa/t0mAM/5hPMeZjk+W4zZAjH1L9iGhKdR2cduncvxZH3qU1tfb/JhoS/NosuXIIfUgelTbS6N+RsYn5Q7PgddFlxpd5JdiVjOcvfsMynfqtyoauzbhyu7NUWFHS+aA6IUrsjK8bA3LE/PdexnAMlcuiiKgpihQ/gx9iAesAmqiO+eajEU7oG1KmtrK7p+OFq/VdqrH2PLgIQGFWOVI1FTfBi6up+sCoL8p8csDDWGm7YCj4PStQqJcRMBN2fo/spFEVjFO6WdBm1h94FWu9MgnaxyIEJo65F6MWwwjb773oQAXYQtO4ucKzc5fu05wsGtNGj9Zu04qTKkOoC/VYcOndHT/YxBPhkB0/U+Sii4EqpOqEo1ejRRWEDkufrPM7L//9S6eggXQNiq9Ly3ILLfvur13BYScmOErOot8TjXuKj+GZPzMk5LoawOVTqhrRBLEJZXCN+2cfA3A98PxKJSe73GPImuTCkKcddy0I9fOVgvp8pCuUQI7M0Ueyuw6O+4jOQOVL48lVeYrGOc1dyw18etNuR2Q2Xe+9TZ0VluQE8+eTXN1hvvfE1Ch+Cp/HmtDqJbpXoEJaHmLmpzLsPi005ABl5jFEHy+FX78qQjj0tt0SLnuZgY0vBy+4aFrfBVUSliSaQbCFKkiNKBJkmmxP0OUUUXgPyPVBPfOyvwG7iwoin3BowQUDBdRXNpCebbKUUHgGRd08/jR8wO05ygGqqX9pfCPovPN0AebbqkeicemgVGxI5sjggQn8Tu3xwF4Vp51C+o/Shs6iiXM7UlxA54qH1jRTVYdIBjZCIAYpDbsggQwv6wX0Co4NIBj/3bvXRO2EWI3hK1gWYqO
 KBZJtz30
 xsXIAJOBz5CSNOYhr8dpllI0Z1vgziDNG3MNA57agxnlMehf1E49NjHM/hbepmYFun/FSEklTcx+uTW4YdYP2+OI6mf+pfy6e72h75tU8OM9/C/8ti/JLjxVOOzbZRfghaZbVouc41OOvW7TzXhDgfTW7ns6QvMb8bvyzRnLnfb1skDhzS/hxG90M6DVz23mZ+lgTTZ4rPSiBoT1KPKLIB3QInhsD6j19aqvfahmK7vfKaxtzMU72+z2yqQEUlL0fiXA7yol3C8dkevyYrLvi2ZZZPJjgxpxKzlF5GR4l2Rp5KHkgUPab+2930B+P/FRSiMIE1WLG18K2MqvMhnqKNIx+xF+fQJKB0rqEuYsvVjB93Q/axLonOgsx9RW3u8heWMfMGeJuS544l8d90k9qZLsllswe3pyCjWyapFPN4saOEJbDsQoSHM2P8pAMvuF+d8J3ByOZnKfegTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 11:53:20AM -0400, Michael S. Tsirkin wrote:
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -174,10 +174,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
>  	 * list processed. This should result in us reporting all pages on
>  	 * an idle system in about 30 seconds.
>  	 *
> -	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
> -	 * should always be a power of 2.
> +	 * The division here uses integer division; capacity need
> +	 * not be a power of 2.
>  	 */
> -	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
> +	budget = DIV_ROUND_UP(area->nr_free, prdev->capacity * 16);
> 

Initial look - is there a div-by-0 here?  I noticed the old check
prevents this from being (0 * 16), but i don't see (on first pass)
the same check anywhere.

Unless this line below always forces the above to be a
PAGE_REPORTING_CAPCAITY if it's set to 0.

> +	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
> +		prdev->capacity = PAGE_REPORTING_CAPACITY;
> +

It's worth making this corner condition a little more obvious.

The code intends for 

if (capacity == 0)
  capacity = PAGE_REPORTING_CAPACITY

but that's not reflected in the changelog as a default value.

When happens if a driver sets (capacity=0) either on purpose (???) or
because there's a bug (???) and then page_reporting.c forces it up to
32?

There's something to improve here.

~Gregory

