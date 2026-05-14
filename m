Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1384CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F276B00B9; Thu, 14 May 2026 10:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF466B00BA; Thu, 14 May 2026 10:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60826B00BC; Thu, 14 May 2026 10:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFE766B00B9
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:48:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79B7DA056B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:48:44 +0000 (UTC)
X-FDA: 84766306968.08.507FDEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id B2B9F18000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:48:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hjj5LJoJ;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778770120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lq5bA9PpVd8zAdeuT9RbCrpou31meXet2f2WjOjauE=;
	b=zEshSJ+IYjLMcX8ovo5Xdx78uLr4a9ExNMEqpjkSoyU7vnGzj9kJbsv02U+TZGumVVPhb9
	BydwR0DavClS3LylwEqmy8b+qvCunniyYu2ShZbG0e9ZsNGBLqKgUWWoqSVGlPGrXWwnzG
	9b7QLuMSosNTTsBfa0cLdhKkk6xW07Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778770120; a=rsa-sha256;
	cv=none;
	b=KaliwxoGmkdvafAvH4H6hTntzVb26IR2wnED/5SLk04SyZsqfSWZ2hpbY8/evgwNwb0Z0j
	SRb3/0owLKHQ/xt/cAVCUB9PK4K9Pv8203JiiWRwt3MWn4Wf4dVB07T75ULfrwj2n9C/79
	wgtdTPQQzFt2s+gVyDRLlMOFhsuRF6M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hjj5LJoJ;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778770120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8lq5bA9PpVd8zAdeuT9RbCrpou31meXet2f2WjOjauE=;
	b=hjj5LJoJFTVfeZP3Wa6ZQfPVmbdI9q/B6FNPH1YzF5YJsr2+RWfCAEDlhKwGo5qjJ8+F0P
	D+qpX5khF5YpA9BTFgGOpjFXKPV/4hDhuqxiMd1aHv6LigXNxVfbFaOJR7NVqFUvL/OVL6
	j+q/TtsBCciZ1+gKdUIxim6KfT6g7nE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-LGlDjyFzN1euKvV5cn1IJA-1; Thu, 14 May 2026 10:48:37 -0400
X-MC-Unique: LGlDjyFzN1euKvV5cn1IJA-1
X-Mimecast-MFC-AGG-ID: LGlDjyFzN1euKvV5cn1IJA_1778770115
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44d79da8cf7so7283119f8f.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 07:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778770115; x=1779374915;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8lq5bA9PpVd8zAdeuT9RbCrpou31meXet2f2WjOjauE=;
        b=dSUrqGFyeFlgF3pGmpzH73RNHva1TD69IxuLTOopuj7qbeqBkdgyirj21HDVYVKa+W
         Jvjf36wDKKKwrZwXrSYDB9F9kEMnZO39qNszsPvD3bdgMENQQ+GLifng1hR8/Yof06b/
         0uyAGUgp//CZDOVjLWWWpAheHJLI+93FUtWcvDGU7x5fN7jlsC7FI7VfIk5sciib5Df5
         ZzzR+pu2Dr8mkJbm2JAPqCfC47qC89z11DuAmbkllQPlBGKn+fjxna5Wc+PuPzVr4C/1
         0OLpzIOelupVOsPkYc1qxLPlMd1/+grqfF4O7+hQ8Z48bQhvX6xI5bbgHiYNJodywytG
         qczg==
X-Forwarded-Encrypted: i=1; AFNElJ/I9eV1SLchLO2+93VetJZca4OZ5Jdxz3UrQjr0yAxdvoU0VuF1dnjuS/EwNAQ1Lk21yz89LW4lZA==@kvack.org
X-Gm-Message-State: AOJu0YyejRmuKDP8muinWVj78qqtWwiXHorj0o/8EfvnGiV/TLx7WgPc
	v6HaTm3D/kXPDsBYfwXNKXebLKUKxrRyl2NdusUt0z8aqAMDFc9OOFXLeRijL/zibGJR04pMOgS
	ubLsA5LnXw6/A6pg5FzIS3kSdCeK+ThPeXVLZiV6KQEw+wZsk84yT
X-Gm-Gg: Acq92OHqbmtuTQMAuNlflLRwc7VRklZtWaPkY3Ox9lqrwJhcP4hARaX/rMMzYvqJeVj
	zuq46gpib7eoZTwRBPZlTN2RxTAXeAwM0tvoPuj/yAlJNneBS2PILzKzCrhmOMJpFihatjtUK76
	jMr5ibOUB4pXtVWmYIRNMSFEMEY6DsLp/xWM/WsZrkBAWOS/BgXruL1rR9xiahvJcbnEijL+GSz
	epdYMzLoUblov/7o3nJh+a1+x4Uo859WhmJU/moagsVufxjDYTpWqDM7ilLho5PlAlfDkYksAHQ
	jXo1IwEokiJV4c004dB7wUYUhyys3DpoDQqytFSoRzB3s4GiVDy+9OQUWx6ijebGNSHOOa3KZsW
	2dPH21plZcd497g20wM2YVzGoQWevNTzzjuHp/hdi
X-Received: by 2002:a05:600c:8589:b0:48f:dfe3:dae3 with SMTP id 5b1f17b1804b1-48fdfe3dc80mr22680975e9.17.1778770114866;
        Thu, 14 May 2026 07:48:34 -0700 (PDT)
X-Received: by 2002:a05:600c:8589:b0:48f:dfe3:dae3 with SMTP id 5b1f17b1804b1-48fdfe3dc80mr22680155e9.17.1778770114350;
        Thu, 14 May 2026 07:48:34 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe46118a1sm4126555e9.10.2026.05.14.07.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:48:33 -0700 (PDT)
Date: Thu, 14 May 2026 10:48:28 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org,
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v7 02/31] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <20260514104735-mutt-send-email-mst@kernel.org>
References: <cover.1778616612.git.mst@redhat.com>
 <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
 <agW3JyLAwVsCZ2qR@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agW3JyLAwVsCZ2qR@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7JHPT-cXhVAIa0d6g3dCec89YwEe1WtV6PUxKphZ_P8_1778770115
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B2B9F18000D
X-Stat-Signature: tt8aipnmmoj7h1gkj4fsuwc3of4y1mmj
X-Rspam-User: 
X-HE-Tag: 1778770120-977019
X-HE-Meta: U2FsdGVkX1+DBy5MSe3J4xY3Qco7374iuvkmHVTXs0V2k1eR2fRlobd4obTTZHuwVPTbLQhyY6YckldnD+TH92LRw/fdAFvrH5pwnb5lHqxl//kYWbP63ohJ8h+e3Gx42BDIIQQJ2CBRhfR+05mCVgzyrdZewwo5ZGFpUjvMmahqgqv17TvwkwC/7IH0T44RF4D6WcG3UNiQTKUVM0tx0FUwaoFhLT3ZSzj1owTJaof9SMao2bYvZ2LsrqJOAaMnGUVK99zeTBVGD99YySFK3HSs/Up6xfs3yo6UJDHVq4B2Vih4QK4mP4miNYZhM3FCVv4cJno/UimGmneZ7L0Qxy+ztSJzip3cAS9el/pwR0qRy5+PE+QtoFE7ZlRn/bnoAW4GmUpTNtLxC6vIOfOc3VrQQoK1mx3/2IDJe0Zj+qFf9JjJm3/OcS6yKgo7m2ldWwvoOsJxajv+v1EZQSSLxXpsUyEsvNzvwMq/2EAUtCkF1pu8p6Q0LDlcc/184z8edf4N/JD9RGNmllSeLkqnKBw21R427nKGr2V1rYjf2yJqCsVWEncJu+MNngYuu845Gwjc8i3GuiIf7ZdECHA8fah+kMBJurdDU84rXfWrCQaVALakoEmckqYcsy9rOh1aWLsOmPJqzzpgGr9xI/LkgVcxmfgZC/brysEm3GbceFehbFRgymZsIoI9tSvanW44fP8Yg5qcukXZr10R5DzSThzIR9Nbz9Vba+qlPHKWdFa412w+PZQ+s0Oq11gnei3KOqpLpwjvcw0AP0Do8ZYT34N1hPzZWLPrTrKN5tm4IOE+v9Buyuha3UaIH32eR6/+HG/0uoQv4BaKL6cWBP0EVOPI/7C/3oSpVbCgxqfjNo7dziHTbGP9JgcUGvIrae/u/Pk1t8f1G1VuNmDCioQn5SYmBFrLiVduYyJkturuVsyJl8KOZzIaYQ2lKy4LgIk/uojzUCt/dptMUqhmMrc
 BXH47IYK
 +ffk4miMbhxiRAwUumibwSG3Q+u3+WyjEuZokEfvMzrlC+5V6+MRFpLQiJLUacghl3vY4WP3TBICajb0zlQ326aFfJZtWP7U9cRHA/MCiUKI1nwhkzPnyA2oGGG8Sy7Chrvj/MNz2maOsMLetI87yfDX6JyzSZQfg2qOmkwxZqQErolvPyRWg4v0MxAl20K2lWu6AFzz14tLpBmbtEiG7j4IwRCO4S7KOonxdPZVoGLkORGrk8kbtKV0sV9wWkUZzTM6VsaBd2pLurp32/ki5xiBryCd3Yi3VjzFdhZRMShSKFKJIhdqB5IvQtJM5J/KLUs8bLK9uIktj3uwhG/2WEu51LMuNXlHFTwuZTHFudDPETAgZZprmBmrW7xCDwHXKRTX+tDFF26gVeOTfWq20xiBF9nLboBulgEtaXYYdWaJeuw4RQ6A4ujEYFncm604D44b3CPxBNzhhvyz02DRdGYfvOGgBVxvoZmJ5sYhOFBiEXzg2e9sUjnVMS+zWuat5+3OpxFZQYOVm9Sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 07:51:03AM -0400, Gregory Price wrote:
> On Tue, May 12, 2026 at 05:05:16PM -0400, Michael S. Tsirkin wrote:
> > When a reported free page is split via expand() to satisfy a
> > smaller allocation, the sub-pages placed back on the free lists
> > lose the PageReported flag.  This means they will be unnecessarily
> > re-reported to the hypervisor in the next reporting cycle, wasting
> > work.
> > 
> > While I was unable to quantify the performance difference, it is
> > an obvious waste, even if small.
> > 
> > Propagate the PageReported flag to sub-pages during expand(),
> > both in page_del_and_expand() and try_to_claim_block(), so
> > that they are recognized as already-reported.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> ... snip ...
> > @@ -1731,9 +1740,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
> >  						int high, int migratetype)
> >  {
> >  	int nr_pages = 1 << high;
> > +	bool was_reported = page_reported(page);
> >  
> >  	__del_page_from_free_list(page, zone, high, migratetype);
> > -	nr_pages -= expand(zone, page, low, high, migratetype);
> > +	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
> >  	account_freepages(zone, -nr_pages, migratetype);
> >  }
> >  
> 
> Maybe mildly out of scope but worth asking:  Are there other flags that
> should be retained/propogated on a split?  If so, rather than pass
> was_reported, should we just take a temporary copy of the page flags and
> pass them all in?
> 
> ~Gregory


Not that I can see, no.

-- 
MST


