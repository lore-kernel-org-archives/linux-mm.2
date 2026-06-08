Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DBFCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57F16B0005; Mon,  8 Jun 2026 09:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08906B0088; Mon,  8 Jun 2026 09:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6F06B008A; Mon,  8 Jun 2026 09:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4BF6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:48:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 567E71C012E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:48:48 +0000 (UTC)
X-FDA: 84856875936.13.EC9FFE7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 052BB1C000D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:48:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EVGYg7cy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780926526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoJIhnuvHMP+I5R4ZGbFyAQYvKF+rv0fOA2ZXMSfz9U=;
	b=1K4fmW9N2iapGx3NcEntRYPmazeAs8FbhFef3H6aUgRZP2KhSzHHP/DfA9iwBKq564tdGZ
	WZUGX+/pYGi9rhcCmMXEcubVq/YRJJxlIsZeliGXQLJIdklDvqf28/AhLRl/GR99HTpWVB
	5qiyawSbzkquH4KYRtpiEb0tlIMU9ho=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EVGYg7cy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780926526;
	b=bA4BdYEcXXQf9GFXpoj0ZeteF1LsFZeOYZkMa+gypiA262GibzXkXlmALACUsGQT4A7tBe
	WnrtqshUBWZTe+Mw6M+ro+ykwgIv+q6jb663LfNMR99l+5jyByPJGhzBGmN0LrUkuRzcBu
	ZO8b1LoaYCglI+hpDPh8pViremA0C94=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780926525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xoJIhnuvHMP+I5R4ZGbFyAQYvKF+rv0fOA2ZXMSfz9U=;
	b=EVGYg7cyu/iPAsmSM8+XkooC0xS7zKZ56YWvDvucfvCkkIFbdNpy4V9B/3CoKdJxJ7C4ji
	YjED0vGeapWrfi7ZOYOYtfE79Ijwf1uZMKlfLWhofB/A9V8bGjrFnXPWaINk7oyWc7oYHZ
	EddBWv9fx25OEqdU9yVVjNqoqKEIlVQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-ystF6_qmND-lnS-0ySHFjw-1; Mon, 08 Jun 2026 09:48:42 -0400
X-MC-Unique: ystF6_qmND-lnS-0ySHFjw-1
X-Mimecast-MFC-AGG-ID: ystF6_qmND-lnS-0ySHFjw_1780926521
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490a786f987so50513485e9.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 06:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780926521; x=1781531321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xoJIhnuvHMP+I5R4ZGbFyAQYvKF+rv0fOA2ZXMSfz9U=;
        b=Kczmbk5LYNdN1HiI7tSAwffb8ifMI37H6fZ+8yyFZqoA1frULp4KbMJo3njahpuezV
         v4Kv35Yfb2Q0vJjVAyYFuGqLFwmF7w9IfI/EtREcJnmTJNfzo/14+MFk9sndb8+JZvnM
         ersoBoI74G4xY3QKxL7XOQgS46Ms2XaQnLySk8Kc5PoBJWZeYMsK8YfRfEg/VWBBK/SN
         lHPbTzzgHexwsBy/UWb92GzYi6wvfQ6XoSsVyAmQAFUJR+XLIhkABloYFjqdTa8MSdkR
         E587BWfb1H3gdu4FfWj3Hduma6QDagAJ2upRAX+9wjPV40aGjE10aACuERu/R/UQucxN
         8ulg==
X-Forwarded-Encrypted: i=1; AFNElJ+ABm1xx+ApQTVAvC0uvIIYmQIcPQMg3NuOx0WOYa58D2VcScapzsV7FyvHrzFpdJY2ZOatvvUs+A==@kvack.org
X-Gm-Message-State: AOJu0YxFkJ7IZueU5G6yih1/con0Ttl5W8MxEIIGC6X8GYLI1kLZK3g+
	LHXrh+aqMLb7pdVDf/iBznRvjKuQP5iro1pLxkUJQ9AkV7A/E243bvCpu58LzScVSRKzlWjfkUM
	NEwi+z2F0CQ7IgeTA3JsKGVKBU4Sq4sLOTcQtqEdfn5VBhUr2c96s
X-Gm-Gg: Acq92OG4wf58dLkCHCuNQ5GOAuqBhb6b1wDKtT1ghXhJZVTnC0Vqje3KVxhV5qdiRSl
	Aktt5fA7YQxBHK7UATt4SJYHLv5z5uIQkT81Cd4egdDE47Qlq8itP8/MM34rdwea6U1Yhe1tEyS
	JS6hgiyp60Y09hX+ExVemospMT5W6ujn1Bizr6iu5d7AsQQtbL9Ps/cehu8WOors+xx+HBwUaez
	9V86Lahf0IcR53C4HAUfVK/y8umveDYK/K/WpWO/EK31XAqgRSCCJw1vpeEdRQ1doIcHxJ5QNAP
	srmfKxsGxIWfFGC6rvJ7Y46i1NdjqVYZ5IFZAi4MBkdFEFsdtFMXoDcneei+NgzX1plOcapPppe
	C/wgGOJPw1gUu+0fO5cAgcJE=
X-Received: by 2002:a05:600c:c0d3:b0:490:53b0:9e53 with SMTP id 5b1f17b1804b1-490c265c107mr216680255e9.1.1780926521302;
        Mon, 08 Jun 2026 06:48:41 -0700 (PDT)
X-Received: by 2002:a05:600c:c0d3:b0:490:53b0:9e53 with SMTP id 5b1f17b1804b1-490c265c107mr216679675e9.1.1780926520756;
        Mon, 08 Jun 2026 06:48:40 -0700 (PDT)
Received: from redhat.com ([185.16.164.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3918fcsm451375885e9.3.2026.06.08.06.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 06:48:40 -0700 (PDT)
Date: Mon, 8 Jun 2026 09:48:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Gregory Price <gourry@gourry.net>,
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
	Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH v10 02/37] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-ID: <20260608094153-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <df06b66fe4ff8e925ee0714955abc2183a727b90.1780906288.git.mst@redhat.com>
 <aiaOZoa2vSCz_0wY@lucifer>
MIME-Version: 1.0
In-Reply-To: <aiaOZoa2vSCz_0wY@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WCW0GDDOIDBkSqhhNm0waCGLuKNLWZwwasWH0L-KQPI_1780926521
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 052BB1C000D
X-Rspam-User: 
X-Stat-Signature: n6jtipsfzjuceo1a8daqys8jf3f3smdy
X-Rspamd-Server: rspam09
X-HE-Tag: 1780926525-155797
X-HE-Meta: U2FsdGVkX1/RWchk71r9QQ+EuaFLwXDocOeXdAm4gp0s357lXC042GipinfyXVBu4wcfLuQBJdoNY8cjSg4RaIggicsDKl86yWLNnCh4gRpn0ZFGZoXfW291aoOQD7ZYYpxViIUhVvvFbGXjzatpg7cmXHyaH1Odx7J1Mskpqcx5NEHV1wGVvvT8xhC7xmzfKayI47Ws1lK5XlsCAe6A1P8XcdD9KvaZbpWwfG1qUnUVcvinsdsPtRJopb42LU2ZCuZYVPtNfXSfM2raBgLxbauPHymSXMN9ueEXWtllYfLhpkIhgPsJCH5Cu4W1NuLhRoB52E3GGxho7VHVxBGTLEWq7Z1FIA6VMJC4VvqZ+IrtbFaAZn2tJpJr09LqhEhAq3tM61+8wLhkeQYOBz5CUrq/zLLYDfVsIEI0qrDDjuOc/SvyGHspndVEuKDyXLFI82Zs3tU2/oTMM5UNwySvWEwYnAZJaEK0zhOnqPdvdJECS9jdRbhElX6UclrI5Ozu1Peli1OeWP9kXc5rtLyoqiPDJ/jpcF+iPc0/WfDHabnKkPPfYBSBtXOeXdWEVnizApwmyVdDUjumYDJCufISLjxUC6DASF3O/7CUSb1xdMMu+8gUARR3J62DHqJqEW2NfWcnQYsfnjhl9QIXNC3LNYwvJzOeogokNvX+wI1iXfBinRgdNDnlYAjHUlBgDWQuhwf0IUo4awg30SmtL7tjnTtHRf+DH508tvqbwVpT+iRLt1YrzCRzSTJ/CIcQEbbescffQLIGYa2SUkG1QRWULkeiTaNg9Uf6Y3VcrG9ZVx8VxGadaW7i0PBjwKpmZ8QYKRVagZY6saur1IR8X6XQmyOsLwlYqNsDHcgGMuEd0SmtJ/SdjDKJyPI5kGM27wXfFrheZ1i92gKszZIA6mjTem0VTfrlHME5dj5KrUrz37E/MmemX/IEMuydJGPYJ1o6SE8r2gm/mWYJ/IMEeji
 AoEEo2yh
 MYa61QiiNhiL1Rxbb88NQQOnwYjYzQSZXMsNV1X1z8Go3/iFxrqILw43E78ZJnkFdD76KZlMbEXzRMrLV51L7GooWzPRAtPkkrQZ2n//AXbpDXAXS4Eugy+y8dZxVjfuG1r+y73qxLiGK66j03WWne1Wb+H1XYIsbEiEheWO/7LH4ZHu0Qwbsg1W0e1FLNbaBxTZuz4/zAH1tKbWQv/emZQpvIeTZzXl/I/mv4HifgM2yTI8j8EVT4nM5SRyicAdQY3D9POQUxMbrBfMfV0T1OCID0ER1rAW2JqcStFa3rd0Q343p/LdmvMOX3I2UhnLymzenuYWk6jPBYOdBWYLjOxvBYtHxxlK6jl251AEbejCmfoDANGnN873PR3NG/e53LKJ4zfyt8GngKaNmXazuFOnj0wrN3w/qEA9IEx9zrZJXxdpPJl1Fs7830g7GwiiUIH4wH+Zl2pzlBVTsIws46vchz2R1tFnGnTh7Gnn97q266j12iozb0AoSvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 10:43:21AM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 04:34:23AM -0400, Michael S. Tsirkin wrote:
> > TestSetPageHWPoison() is called without zone->lock, so its atomic
> > update to page->flags can race with non-atomic flag operations
> > that run under zone->lock in the buddy allocator.
> >
> > In particular, __free_pages_prepare() does:
> >
> >     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >
> > This non-atomic read-modify-write, while correctly excluding
> > __PG_HWPOISON from the mask, can still lose a concurrent
> > TestSetPageHWPoison if the read happens before the poison bit
> > is set and the write happens after.  Follow-up patches in this
> > series add similar non-atomic flag operations as well.
> >
> > Fix by acquiring zone->lock around TestSetPageHWPoison and
> > around ClearPageHWPoison in the retry path.  This
> > serializes with all buddy flag manipulation.  The cost is
> > negligible: one lock/unlock in an extremely rare path
> > (hardware memory errors).
> >
> > Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> > in this file operate on pages already removed from the buddy
> > allocator or on non-buddy pages (DAX, hugetlb), so they do not
> > need zone->lock protection.
> >
> > Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Can we have Fixes: and Cc: stable and also send this separately please?
> 
> These patches seem like unrelated fixups that you've discovered along the way,
> and don't belong as part of the already rather large series, unless I'm missing
> something here.
> 
> Thanks, Lorenzo

I think you are mising that they are a dependency, not unrelated.
For example, this issue gets worse with the patchset as there are more
places that manipulate flags without atomics. No?


You are welcome to send this to stable, but I think stable rules
preclude theoretical bugfixes.

As for Fixes: the issue has been there for decades. I wouldn't know
what to attribute it for.


I guess I could send these separately, too, why not. Not sure
what this accomplishes, but hey.  But is that an ack? You want
this fix merged even before the feature?



> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  mm/memory-failure.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index ee42d4361309..3880486028a1 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2348,6 +2348,8 @@ int memory_failure(unsigned long pfn, int flags)
> >  	unsigned long page_flags;
> >  	bool retry = true;
> >  	int hugetlb = 0;
> > +	struct zone *zone;
> > +	unsigned long mf_flags;
> >
> >  	if (!sysctl_memory_failure_recovery)
> >  		panic("Memory failure on page %lx", pfn);
> > @@ -2390,7 +2392,11 @@ int memory_failure(unsigned long pfn, int flags)
> >  	if (hugetlb)
> >  		goto unlock_mutex;
> >
> > +	/* Serialize with non-atomic buddy flag operations */
> > +	zone = page_zone(p);
> > +	spin_lock_irqsave(&zone->lock, mf_flags);
> >  	if (TestSetPageHWPoison(p)) {
> > +		spin_unlock_irqrestore(&zone->lock, mf_flags);
> >  		res = -EHWPOISON;
> >  		if (flags & MF_ACTION_REQUIRED)
> >  			res = kill_accessing_process(current, pfn, flags);
> > @@ -2399,6 +2405,7 @@ int memory_failure(unsigned long pfn, int flags)
> >  		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> >  		goto unlock_mutex;
> >  	}
> > +	spin_unlock_irqrestore(&zone->lock, mf_flags);
> >
> >  	/*
> >  	 * We need/can do nothing about count=0 pages.
> > @@ -2420,7 +2427,10 @@ int memory_failure(unsigned long pfn, int flags)
> >  			} else {
> >  				/* We lost the race, try again */
> >  				if (retry) {
> > +					/* Serialize with non-atomic buddy flag operations */
> > +					spin_lock_irqsave(&zone->lock, mf_flags);
> >  					ClearPageHWPoison(p);
> > +					spin_unlock_irqrestore(&zone->lock, mf_flags);
> >  					retry = false;
> >  					goto try_again;
> >  				}
> > --
> > MST
> >


