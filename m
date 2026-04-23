Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA66FC0342
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623056B008A; Thu, 23 Apr 2026 10:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2976B008C; Thu, 23 Apr 2026 10:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49AE16B0092; Thu, 23 Apr 2026 10:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 390366B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:57:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9134C1222
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:57:15 +0000 (UTC)
X-FDA: 84690123630.26.9D62614
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 138FB40018
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:57:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=f8af09Df;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776956234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAoC6Cd2m8uJEAdJCqdAkQcG7d/SgM3iZ532Fzycwn4=;
	b=pUdGyNScc3oDN3uovN0TXC9fTlxVNrE218YbuS7fmxEr1RNH3U6bGW/mMokkCO7M9YMjNO
	Z/AWzRcxAcDdvrP7fcBgSSMspgs8IFD+gszmx8rVYAiR1ZgzdlJurRNI/+NwVvXba4I30Y
	nkbf7xiCB2pW0zRjrlG3TWhgh1LGdFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776956234; a=rsa-sha256;
	cv=none;
	b=TgVtblcytGrkymrULbxr5TxBzxPUT29tyXrw08XqYggDXFVGEC1ClbdS9UK1PZxjsCGE0Z
	b/4AgJ/6yfWryAXRsAvc54WgJD9/SAt+dkomAbosyiAeGjBG3DSFAX77umFatzn5DOrvmn
	c2gf6ZUvXLRcHt1DTPqYQLOfJwCMvBc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=f8af09Df;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8aca6bd57cfso64342486d6.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776956233; x=1777561033; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nAoC6Cd2m8uJEAdJCqdAkQcG7d/SgM3iZ532Fzycwn4=;
        b=f8af09DfPGsjwd5aeDnzw0CgwsxjGngJBZtRoW0NDjZzpGRD5o2P2ymJYRQaIiCs3R
         6uRx9mE2A3m6EdCPKm0U/wt9oNMokqJciBEmZlkQB1sVg1H67GAYEcFXe0wK7ewc3OVQ
         8jU8KyaANNOa3G8PPEYe2Y+zU6I7dGaXem3wO1DDRL/FKt6iejVzt1bRLPLyD5lvelGM
         IwCWBuTpPhjJVqQnIMZywRdH19NPooWPZBfnQ+bTkP+TcEHEuYxXPOXldf2q6uyOsiXs
         /vzLSs0kx9t3ab8rkzPybL+aLxWVoXroEyIc2AVYesZtu2plmMGZFCrVEAxHTgrRUEy2
         HOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776956233; x=1777561033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nAoC6Cd2m8uJEAdJCqdAkQcG7d/SgM3iZ532Fzycwn4=;
        b=mXXY7FVf7+4JKGCSl4fLapuhBQoJ12B4UtOBiJ/SPJfHtuO0Phi4nj2WlRf+vWgzJn
         wTPuilqur9KLJnSyEC3XLokoxvEZKZ3vKcSzk5g9AWLn+8JNlETO0LNlianpnfx4tjxy
         XZ/g5XfVczWUaBSxIv2rTVdfaAVZQj81jD/jOvIAI2g86NPEXK4wEuO/Ypgwi59qjanW
         +PDgH3mE7LHZofjkKWTB+W3q3LGaRP4Nv2O9R8LiWKBhkn+7WVfQQ3P6njdaZn7JW6PU
         OD2cS6QWQBPz4hWBBoyXPO8UAsJTuby/982aQ8UvvkOvcCnS98HnGD5RTH3EiIvhm/LD
         zWRw==
X-Forwarded-Encrypted: i=1; AFNElJ+1Acx0liJvReeWF61McZMycaswAMGmlZo19/FqTAaiNiiYm0ZMzmkREIpwRaKT7oebbbJT7Sly1Q==@kvack.org
X-Gm-Message-State: AOJu0Yz7adka9uzJhh8TwUha+OywyNzKWJ6mykRSn0VMoQowqSDoWpFK
	3mAuAb3ch8RiT8H47zL0BxNd/oq3fLgy9RkRJO6NKMkiw6vDb0q9P/r2qq2yC2IyQag=
X-Gm-Gg: AeBDievVK2aGrHGid8Rl3yduE1VOktfd6eJNzSqnDqxu+eACdw1N3XXJiotMZQxiqXh
	ZBvrB1tGjyFwrivyTjEzfw0BcZ1Cl5ry/PCo27L3W7Z9ULTu9wUfyMPe0QJtqRM021NIY/TOcRD
	DXVfKSEbfrXUjO4aDvCueIpLNROhU0l9qqVyGgSF58Elaa1m4qhO42wmx31u+XGBZALFahJFs6m
	SfgKDa4tAWEKUx79nD0cEtwKuF3yiXjuuZ7Hs5Xq8zd4ElukbWuEhNpQNM2kQP36sikD+4aG2Hz
	jsSwPgLcaTn3jk3T3L977TO/3BkBbP0c9Pu3fEmm3xq6jJRXa6mPYqa9WFg0MbCtHKCPvfLJxhQ
	AmR54jegJlSLf1OxFu07KIN47e3cwZOpDic0IXnj3p4n/9i7urrvJz4Jgz54IcJ5bGAz1OuLpXO
	O1Mc/c7LkRoku6GFX7hzVmZbyn92sFSokFqFtq7XqI7FQLDBaTTta1dphlO6tL5wH/NFXV/erdF
	3O7/u7ehIDkQULcXHdP
X-Received: by 2002:a05:6214:4e03:b0:89c:5289:4be6 with SMTP id 6a1803df08f44-8b02805a894mr389230206d6.13.1776956233021;
        Thu, 23 Apr 2026 07:57:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-246-228-50.washdc.fios.verizon.net. [71.246.228.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae5c26csm164285926d6.31.2026.04.23.07.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 07:57:12 -0700 (PDT)
Date: Thu, 23 Apr 2026 10:57:09 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <aeozRZ9AvW2jTQkX@gourry-fedora-PF4VCD3F>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
X-Rspamd-Queue-Id: 138FB40018
X-Rspamd-Server: rspam07
X-Stat-Signature: 9d6khs7aw98im8nro9guwmr6q7m6rffp
X-Rspam-User: 
X-HE-Tag: 1776956233-545351
X-HE-Meta: U2FsdGVkX1/GiAks2W1HT+CWJ1xQQyJ0WlBbgxc1vXdlx7FqUGm07tVTNJMfce4nb68qK/b8bADFLH3VBovlj1jZJxOyi7G7caLJhyQ4yDsA1ApyAEiBS1mUXlZnbDy/Bg+4G7SlnCVbV7LVhyAWxz2yE/g58QrXcCU8QW5kL9tKKIotUWFvhtZMen7BLqo1KGqeOxrjcJt80C5qia1I5CD7sjRn0VYhCv2UDOTokcZCzaRwpL2i6NenKdOuhy3ji7Vr17vPZ1Ttt5sxkqy8tdpniW7axrZERbsljfCkrxvRM1re6ZvluFkQpiGxQwaFlevc/Pf+qvoyf5JycC+A3dcAXZjnkkLa1i3tJhy1EEgGMTQl66JbPd39N7hmDmle/45ju/EDU2nvDCR0bwqKI7OU1SGiJ+dKrV7jG1LdzWtQ+LEhJTNy8N4ZdcKwiPUJQI52dT3r9sVHbdOlHXL4a1JOiT0XPB++ncn/38+mr2xMKKN81CwRPEeSpSwSovW4szY1jCfORIEGeUNkSYr/sCK1iCxJV6OSxFEG4eX22rQU/uWVZFY+19kTPehlmIbZXQ4aqf+tgZXICD27pAwz8/CfZAO5Ee3pB4W+tm0uDgrtsNh14Ma320shz1015HTX1g2VfCZtujERqOCXSwPOM0241zYwSiQL5xZicqOWaVje6t8lF/a1cPqJwevv658cK5ejroyQ7E8QFUs511PhTkeg0HQoXND0KU34fcyPpEgGi5qVcBZ9Kw1Ve/8RmFMCNXZbstG47mMsZnjWTL6wfp/a7Asol3yify053EN9kkwl2ltqnkcp3UmWnqCoXvG46U6IszA62jM9piLwjX95LmHVJd02zQ0fc0O/sNjYZWU4A4kUbybTLntZB08PzDr6FLVGM8a9HVhnLQp4O90MpYhUMgZruSl1tkO7JY0NTmO3RLOOi/Z8ddCOd1Yvw1TsiCaP/0odduaiSs2WXgt
 MST6fF4B
 FY3JkfO9u7+ItniNJSL0DAKZ78guWU9PZ00fUjJ34xFpPAfTbI2KehzwZmomhqekRQivzN5EMrmiMbBhB1OsxCHFf4Vz8iaUgJrLfhrBrEplq/5VBAlCcjTzuDSRJTwq1s8ArRk8YmddKtnNF2s2hZimaF9wj1ncbA7j0JpYBRklN85gisfr97W6lM3+XXGBaxPQKqc4UP24L7oKw77smpnnzCOMeetfYJ4QxWayn0lsxhI4H2zH/DgES9Fcs/WvztBXAIx+6qqgQAfWk/Z54jKFVYF0HaCvI/nbNYNmZOmXrJXU5kqwuQmiZwOs104/qr7xaQhY9TBcunWmqo8N3yGW1FlalGjQ0ds2V5z1m7BSUrYp5ATtINVYSy4e92sO6ainq3EHnPy6KH3RmMfrKyUeiRxKesoNqw8LI25zClJ0iqEXo2OXRpY8jYr9rvzORJYEx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 04:13:50PM +0200, David Hildenbrand (Arm) wrote:
> On 4/23/26 15:42, Gregory Price wrote:
> 
> Maybe we could forward the vma+addr here and call a vma_alloc_froze_folio() if
> we have a VMA+addr to have a clean interface.
> 
> But really, that hugetlb code is rather messy. I'd vote for leaving hugetlb
> alone on a v1, and focusing on non-hugetlb first.
> 

If we're ok increasing the buddy surface this way, then I'd vote for
only updating the exact interfaces that MST needs to update for his use
case in a base set of patches, and then have each additional updated
location (or logical set of locations) updated in follow-ups.

My initial go around with this - the patch was hard to read at best.

But I also think we should also seriously consider not increasing the
surface of the buddy.  We already have two patterns (either you need to
call folio_zero_user() or you don't) and adding the wrappers to handle
this internally means we have 3.

It's a nice to have, but i'm not sure it decreases maintenance issues.

Just my 2-cents for what it's worth.

~Gregory

