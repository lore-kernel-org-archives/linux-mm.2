Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF613F589D4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233356B0092; Thu, 23 Apr 2026 09:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A966B0093; Thu, 23 Apr 2026 09:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9466B0095; Thu, 23 Apr 2026 09:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 032C36B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:42:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0B5B88C4C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:42:43 +0000 (UTC)
X-FDA: 84689935806.20.4B6D38E
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id B37A41C000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:42:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SN3+FxSt;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776951761; a=rsa-sha256;
	cv=none;
	b=CSSv7l+9VfZPJjfdpYvDCilrCFO9ngwapoIEeHUyBIUaId+XLw7u1b4efd3l0S6QuTEXbw
	FxuFQDTKGhcpFvnIAhUUcQdQ30yZoDrJSZS+rECgCdlcVijmbQSdfW6maoaOQhF2SjMUF4
	S6JKTi+DwVA5/8Vbf3qmGFR0fynPBFI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SN3+FxSt;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776951761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SbK7jHzK0BibVPY47BIZzJ6hwGVNdmSnj/6qVo16wg=;
	b=TD4V21CYpz1EOLFZ56QLaVbXiQLksvdL67iGSK2G5pTnQODRRGY/HwlpAVnnhIqW5CPmej
	jQCgRERWfOFcDMuSlYEQpCCDbMQeRe8GsPUauxdQg3xta0zYVjcyH5Ssv6UFEcu4VANiJP
	adLHDM7Gtlcy1fyOvtVnUiW/E05FHzI=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8e0a768331cso763209285a.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776951761; x=1777556561; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0SbK7jHzK0BibVPY47BIZzJ6hwGVNdmSnj/6qVo16wg=;
        b=SN3+FxStM+7cOmekfiDIHkmfwNhtdGU1nKKHdgomWjXYp4Yohz3QYZUCEWu+sHuFts
         QG/sg6AusaQ0fRUGDu1lqe5erRCJT+HklRYqFSXLM1XHW1HGxPKXl3OBan6lnzaoo3Tm
         M1EpGjwA/ZhR98OiG/FF9F4/0BWLOTsp7JUxQB1Zr9GWOG7rr9hz2bV5OtMHnPhIElL0
         UoJ0T2oRQ+Ti12ziIudprgf1rkNOyjqSTyqvmKxpU+6O3ILWO+30h1hyHkl1t/bIxjo1
         anx+p+XfD1gBwAzNmYs3L4Dp+YBWS1pMXbt7Bnnje/ojYr9TWdKrhy5vBxa1ir630rMY
         HQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776951761; x=1777556561;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0SbK7jHzK0BibVPY47BIZzJ6hwGVNdmSnj/6qVo16wg=;
        b=VNNjwFoaNzhnyekfUNgA6JN9TNYnX4m5qQyIvUdQAs7Bur+v/r3MpCTiOr2hTKNzp5
         ALZYJtOGt8KqxVA8NE8w7fLTJVOXQi8KVg4Z71dTtEI6zNyRIADu3mB1OOZR76XBu1e5
         JfRAs8LJVGvmUBm9xHg0pvQC1OXpO7P5zqC7J74QZ7oPME2/fc3UTH6qif3QYD4WY0NG
         wztJiCHBD7ntPPIPsSrHj3yavHydLJFCZdso4pLk1bW+wdNH2qyrv0lLLM0iqfJFNQK5
         DxCVXLpoNtm9HdlHsuZUolukT2WdYs5cV9Jxh8QaMX/DiHKtT+bYKCJA3NoY54Cl2ImP
         1yRQ==
X-Forwarded-Encrypted: i=1; AFNElJ8q3W51K27vIWw5A6osTvYixGXBPilbvSFiywG+FqZwqrwN/sICM2HBzIN82oIevkzZ1BV7PNIVgQ==@kvack.org
X-Gm-Message-State: AOJu0Yxmgg9zlo+dRFucciYmwru6FIwsMORP5pJDiSvEYGkErPz+du8M
	w5a2qB3j5Y81hjAmYh8rBkzkpmBokLyezN5vx+u1IvNUk6KGUGle7ZUR56xRdDfvnJ8=
X-Gm-Gg: AeBDieuSBdZpVPxEDYmKLClgT8XprEhnUy3b2SEIpJHEAyoqI63sE4OG1CTjL5toUwq
	lbKpW6lvv40e209Y8OW3DXnmBVW+SuH5ti3w7Da/a4KAMKieqK1J6nxxVNc9jFdvUEVb12VDLzb
	XidEXGeRkcOxJ4SGlw3zsejC5cxchclDgQMbqWOZ+FdAMZPQicoufQvYKcrttSb8/mchfd3Yj7G
	RyFmyEalTVdJDYphMI25FSE2avAS6UjMDmAaPDxF40gnTAFD3bq/rDnxFMWM/vVbuxH1w1eywaQ
	CQdJdCPtFooeFD5LFi3X5WpXJ1dPKZOuanETHH/3M9ESD6RtTPno9IyHRUYWlkj40kxWDIpMKWD
	dnqxDAb6I1uQLgkm8PtO2WFE51e7VL12tqsga1E/xZ/NWzwP5yLE499BZyfUCNOxRcotWKeKLvb
	1JvwU5RNmy1Q0O639Zo3t8clznzypfLtY6mrig6FolosJM5XGi7raPAX7Mlz2Vs46zw57+NptDr
	1xSzJWp4Xl16rB+4URK
X-Received: by 2002:a05:620a:414b:b0:8d9:26ca:7e3 with SMTP id af79cd13be357-8e78d0a865emr3247854085a.41.1776951760527;
        Thu, 23 Apr 2026 06:42:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-246-228-50.washdc.fios.verizon.net. [71.246.228.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac81a9dsm157783036d6.21.2026.04.23.06.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 06:42:40 -0700 (PDT)
Date: Thu, 23 Apr 2026 09:42:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
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
Message-ID: <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423074433-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: f6hotfs7ifxsmndc1td7xmi83wutwcsg
X-Rspam-User: 
X-Rspamd-Queue-Id: B37A41C000A
X-HE-Tag: 1776951761-400402
X-HE-Meta: U2FsdGVkX190yJTalMkJnmLYUnU6qLRvsm2Eggn7InVS4m/wR6MUyQvIo5IncZELQiudFqr28S+JqpRaTVmQaYup3FLfwRzZj3eXjEl3LmKaSq8ZfFIqoPjmH8ZG2BqcL8yl6ctjyZG1ALjUW1ZgBBPg9NnObwnXQNDZCVxgdYrWfqMgndNxQibaB1gLlOdlePTf/W61NbXZh25/RJf5dXKRimySrzzSXrdy6m43HnUOt1wfz30dZJNaSTBBs77YbhOJMS0221f4eHHsHaC9EofDkN4+L+Dg9bPhxbtwaibyfjEvej/JUYZ7JRLLk2SBtFuqd1dTNk9NMDj3ZK0uJhmPnV6DEdT2GNUpx5vGTYVty3vjBz5G6djpTjbvfuRSCZRyICRCo3qAL/qSybo16AQRe6DE8WWkdImD/3Ct/aHJ/tnTX88VB8Q7M/0iZaA56anWoT1XZdw+EtC4NGTd7kVLwfWMme1p0N+bHFicymwKOcqLzVzMmtdekcpjOsWq+h5WHRwVMaWTLxgd6xaPrRiaVIw0EMYoFFdTOuLhlti16vsASW+fIaclhkGf2YLgJn1oLOeM7vzki/Q3enWMV0EsTvLZCTR8KlcKTG67YgQHvJl8kDgPKO7gYIWjGL/0b9aJqT7q3mmmhJLJ89emCn2rQCs2/l83J7EiRiI5GtKLuao4DGYOzwiVRpzugRe5iltfAEVN4xoxYSk0FQjdYkVWXuRX/xSnWgVdPc/9aFYTl7c71Epdv9XExBIXkBK+j0RC7wx2iV5i96ayPPA66MqBN7rgNtpk+Bw//XPqcToIQPurTzBDeIRg/TV08HVHy+IZbUoiQ3RueFXFgemeJ8HSx86Tj3VC+tPJaKpF7BuVCmdaEQmJ6mZGYMXW+CjXzF4hD+fqXCjEgf/4h21p9Vjk85Z9tJG/D/eptlfyDDCdtdBea99MXdk6umLBtY+b6U+xFN3jyYuXcj/rsqp
 BX+Hq0Nt
 8QJf6rNBO8rn2O13yx708qQEM1svcgj+dY7IvoGGg0PMIxz8bfSsD1IMiFaSfHTFxIPcPcKA+lR9EaSAN+NhbMCfbfVaTroXsZnGJzqKkGH43wmZr0xmkS7GlVq9Do9OAbII0eiYBVXG17r2jFdbJZ2LAbV82OBEgVw47bJktWVZjjar0MBxLiLCVfNDrYlwoXmoTWUsf3J5Kd/3LPhsYw6KsN9hk+BEF0U9STocAeePmqw6Rx82j+kl9TY4018o4hVNRXkrKWMyPwTpBOo2lYAWlFjYsWuikHkv+vNaycZC2WeHpgTGD2xI7iyNalaWZVO08HWp407Kx4I5zdZSfMjmpfuhWzQWgIOrnrCeFXHAeHxZwCsBW3Kq+umVwJYkGP2bTx3vN7RfeHxA5793dE7kIjV4DFhPu/bPLCt66R1ARH3J7zzdYFbdyY7VifZT/X3K9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 07:57:01AM -0400, Michael S. Tsirkin wrote:
> On Thu, Apr 23, 2026 at 11:46:56AM +0200, David Hildenbrand (Arm) wrote:
> > On 4/23/26 06:31, Gregory Price wrote:
> 
> Changes we have to add: 8 changes
> Rename 4 existing APIs adding _user: __alloc_pages,
> __folio_alloc, folio_alloc_mpol, __alloc_frozen_pages + add
> 4 wrapper macros/inlines in gfp.h that forward to the _user variants with
> USER_ADDR_NONE. Roughly 6-8 lines of boilerplate per API.
>

This is essentially what i was proposing.

The result would be more external surface to the buddy (at least 2 maybe
more functions, plus all the _noprof stuff and a bunch of other things).

And then all the callers have to be updated anywhere, and not make it
any harder to mess up.  You either have

    old_interface(..., user_addr);
    /* Churn everything using the old interface */

or

    __internal(..., user_addr) { }

    old_interface(...) {
       __internal(..., NO_USER_ADDR);
    }

    new_interface(..., user_addr) {
       __internal(..., user_addr);
    }

    /* 
     * Update some callsites to use new_interface()
     * mostly a bunch of _mpol() functions but some others
     */

but someone could still just as easily do

    old_interface();
    /* don't fall folio_zero_user() - Bug! */

So it's not like this makes things any harder to mess up.

There is no elegant fix here if we want to do this all inside the buddy.

If the performance increase weren't so blatantly dramatic we could also
consider just not doing this at all.

There's maybe an alternative here in considering a change to the way the
buddy manages zeroed pages - but there's no guarantees we find a pattern
there either.

~Gregory

