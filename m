Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97943FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA076B008C; Fri, 24 Apr 2026 14:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D909A6B0096; Fri, 24 Apr 2026 14:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6866B0098; Fri, 24 Apr 2026 14:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC9BF6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:37:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63C76120270
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:37:03 +0000 (UTC)
X-FDA: 84694306326.09.F56BB5A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 17A2D80003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:37:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=STTTpKqo;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EzZh79GGJvnyX3o1poX9T4TAY2qDXkiWPDaOxeNq0iQ=;
	b=ZyGqUryG6XBPdCaLonuTSJy9cjcsc6SfCaXEsfyevamecwv7I0qoV4pfiF4DZg4xv7JTTL
	10htpl7xeBb6LvJsI/sy7nvMP4GX9kwYYOsWoLeB65VYKqUO4twqxONCrARRJA2KCUyRaA
	xA5gVJ7UnXo1vWaMYquRywCgPLsIlxk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=STTTpKqo;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055821; a=rsa-sha256;
	cv=none;
	b=GZG5XZovANy80yHMqNKH1a3kqandtRk1dv0EPZ0O5znhN9yDBUQhl7UkhLCZ+PbMFQTTlh
	re6CObSGKzQsvSFx67g17ddcDoHcxXY7xknQSci6d63XtTEydZCp86+RhnLy06Vu/x0XIo
	xK/BC8iYdNaCHrTZ7Gf5yJjo1BqTUnQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777055820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EzZh79GGJvnyX3o1poX9T4TAY2qDXkiWPDaOxeNq0iQ=;
	b=STTTpKqoKX4dRxVofCHrXYi6S6AHgT+1MpsfipFKxYHl6RyznZW/BbgJiD/qGAnOmU0mST
	5iBt0fRY+3HssjowDnqF4R3mKkUnaF665MKhBNHQTZItict4AnH40H92vListX96Sgdhr2
	d7VuNMf05gv1j+HRIuNPPd1KvZa1CJc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-ExZpmczPO-yh00CrKgr2lA-1; Fri, 24 Apr 2026 14:36:59 -0400
X-MC-Unique: ExZpmczPO-yh00CrKgr2lA-1
X-Mimecast-MFC-AGG-ID: ExZpmczPO-yh00CrKgr2lA_1777055818
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488dcaf2f2fso65669695e9.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777055818; x=1777660618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EzZh79GGJvnyX3o1poX9T4TAY2qDXkiWPDaOxeNq0iQ=;
        b=UNfeKt3ozsH9e1o9bq8rlj9tno8BPQoSzTwJ4vZETfYlpnc1w7WuGnejlwPL7Syxoa
         C4p9d9sKGs/hwYuIftL+ycKnQCflzAnfuJtpMDUYQSAbLRFHvE34ciRw5b6yUKtiSQl7
         uHD+xieqkeDZ+vHwHcRfKDuTEa6VeIqQASrRrgalXbN+W/6Q7xV1y5d69VK0HIyj3hyL
         2RaWtGf7QUcsJszkwVypyi3GmDynO1/grMvhhh2Fk2NQyImWy7LipVzyyAWkiaypeIL+
         0NORp1T5WAMm5ZNbI0+AbQAo8RvKD+V9rB+6s8zHtGCmYqp8hSNlNSJmwyLX00bs/avi
         GBfQ==
X-Forwarded-Encrypted: i=1; AFNElJ8QGtlup2PujRPCIIjUNVvGvcydhdbN94WnPBh1/RpIBmBnpiMlefGQ80/22ILuQx1Jyw7VbmAIVg==@kvack.org
X-Gm-Message-State: AOJu0Ywn/bQxxhx1SmKuoWeN44JhuK98mTc/e8dG0nRtyBccYYW0eSIt
	DF4XdEzf4v/a845ATAm8xxqTcc09TCw/+zumlhE73utsxpXvMej7e4m2YH8HpaTVzzimSRpZtRe
	TUazCqRptO3Jc7kegWPFwlvfwXsARExzxzSXukGOhd0IP3kcA7HyD
X-Gm-Gg: AeBDievDd1sNH0Dh3+uqmp2cQ1yrqPIaU/DabdDg9d+T0opBMuA0CxeudPWF9YKFIP6
	8PFeWVsM2ujgZ9YqXrcxgOxzWQhkBhlIxh5+oERn+POMqN07TCgOutOFF+JhnZlDbUzVjmg2WLA
	9mKqmVPLp/xb0jaBi07cRPcCaRfTOCzrSkrBDGN+RJy5GEnn8TJorrSMmYtEznHYNHLWdFudaQw
	J7QOIz2aZFkgeWXK8Vn3zfc8M1eOlEFtndga7+mTJ3L7/iUFSScEGCwzkSHVwPLtZ558vJqrJ49
	acmF7JbeoBWFK6Plkh8LinNq4rUUyAzcIMcwnDPx7y3R8pwvvOZ+mkjZJ5UM8tc/agSrCjSW4Gu
	f4Q9KdkgUk3OGYtQ9q5sHcvqu+VRxnCYn+emdm2PeBbV7Kb/ZKBYC/u3A17an6Xw=
X-Received: by 2002:a05:600c:5295:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-488fb77facemr466165895e9.21.1777055817644;
        Fri, 24 Apr 2026 11:36:57 -0700 (PDT)
X-Received: by 2002:a05:600c:5295:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-488fb77facemr466165305e9.21.1777055817177;
        Fri, 24 Apr 2026 11:36:57 -0700 (PDT)
Received: from redhat.com (bzq-79-177-155-147.red.bezeqint.net. [79.177.155.147])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a55dc9f58sm607291535e9.6.2026.04.24.11.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 11:36:56 -0700 (PDT)
Date: Fri, 24 Apr 2026 14:36:51 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260424143541-mutt-send-email-mst@kernel.org>
References: <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
 <20260423104120-mutt-send-email-mst@kernel.org>
 <1ab6e58f-d984-4bae-a343-1b0d3c973ad0@kernel.org>
 <20260423121222-mutt-send-email-mst@kernel.org>
 <4e12d67b-60e3-4bf5-a229-43c0d2c62cfb@kernel.org>
MIME-Version: 1.0
In-Reply-To: <4e12d67b-60e3-4bf5-a229-43c0d2c62cfb@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qg5caadfgHQEv7x_e3AQR7bn5SAaMTy2Ph7QXM0h-U8_1777055818
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 17A2D80003
X-Rspamd-Server: rspam06
X-Stat-Signature: 6qwzzjn8fdj49for1yho8eyp736m7p5n
X-HE-Tag: 1777055820-999655
X-HE-Meta: U2FsdGVkX1/1BV83EdqptlpOTw7l8lgHmdbP4xLFBInnPFfJxnLz4/hj/D/3L28SUK+PuREU7AIG8tPdiZc3ZBIqduB7aM1OPcsvKVYuZ4OoMsiHT8FhdGEFF+BiUL28xPVafc4dC/NeGnlZjZwN5Sw5gfYsif8bEUeDFwkdax/TEaG69nsUQ9jju6H8ZYEYH8BSpAqxzsM1BVylIViR/AD1fA2MqF59iaVtx3cGZDX62CwFQnDdd1M0WyY42C8WmXmWLFpsh0wl8LTjxAc4g2wEw4zepuLiMPtTdeqYFWHwXJpFnfKSwt/faB+/CvJzwoW3G08q7qVyD5b4/OMKvTTMcT0/Qqso1GOIQZ1UmSaUlaDXG+A0rZ3vzmik8/dJU+KxXgFJnurFEB/YmeepXAkX05TUhbO7D4y/qCoYC98Bck5/XgFzNLlMN0l/zch4HVui1iFWfsACsQ/i67vgSlFw+wOMcZ0rqWtiu2NBCdnC0SbHBwsQG5f1gpg0+mHhWQUBZqYaLvV88HBpt0oOxL07lh7cLIFOilfU4Z/jca8l1Z6+ZNiUQkYg6cATvb0MMFr1G9RQglqX6WI4MFSc1IE2Syd+nWeEdalSb/mG28kfZRS70Nic03jG8Ls9LddKSIJoDVeAmOHzrCU1Vvw7x5me10n6SqP0a3kaQyVVSBrohTxDW+2deWVq2eCqCdlNsZS/xc72kcVJcH9BJkvVNO6EAXIl6xJF8+iREZyolsYL6BDyMoJeSI65VZlH4jOVHAKCkEIjU9htUOZ+KdTyjB0c5LY+bcayFBkq97DAlfCcdLnOhus5q+7DLDimiia+VoL5jIaSgzB02qDPx3lKAvOJXoJLKDVwIErDsX/I8/r305mT4oGQIYSR/nJE3/o3RFdpZOPAYITPuKuX0YlfX3t7Z/WkD/g797BQqmSZdVNc4FyYyavFLLH8U3q+M8a2ufbUJdFfBUAKxXf6398
 QyccjMeR
 GGdHuHJpHKfB9IVAVlq0fyZsfL56fy4quajrA7O1W/bhRkuiiBSij2CPJpAICoyi0r2MBC4miCI/l7lDrkwqYv8dWRaJ8z1ZR7FbXXpgZXo4a+urO8HjW0vYlNpwyIbb5VYtspDlpsCmJY8sxMg7Zntli67+s39nByt931ORx5hdAUoQbDvMe4mAohYycL6QdbM6vD5ANYwRRw1YvwDxERmNhtXKBRjjAqMtTAa9lijY69a0m+H8i7yVs8LJ61skUNBsFKByskmhNl8ah54VeNrw+sLHkFf9D0ap1+iDTQ057I9JG38NwTzOieWVylOzTi3QOrgvlHe8SN/BIcftoX1h98YwHP7kgwOocQLwvOyAv85x6NfPsYWj8dRgZnR1QZbEOjH5SIrnou9QUdq+4SV/ls9SWk8JJ1CZxLm1BXfRk/pa7pfKNBmDlzmph05P4OjF12rQeCjEMlnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 08:33:45PM +0200, David Hildenbrand (Arm) wrote:
> On 4/23/26 18:13, Michael S. Tsirkin wrote:
> > On Thu, Apr 23, 2026 at 05:54:26PM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/23/26 16:46, Michael S. Tsirkin wrote:
> >>>
> >>> I just dislike it when things are non orthogonal.
> >>> People are used to: hugetlb = same perf as THP but more predictable at the cost
> >>> of being harder to use and using more resources.
> >>> Here, suddenly, we have an optimization but only for THP.
> >>
> >> Note that we also didn't care about user_alloc_needs_zeroing() with hugetlb so far.
> > 
> > 
> > You mean, that it stays because of the reserved pool?
> 
> I meant, that if we are running with init_on_free or init_on_alloc, that we end
> up double-zeroing right now upstream. So nobody cared to optimize that part so far.

on the aliasing arches you mean? that double zeroing?


> -- 
> Cheers,
> 
> David


