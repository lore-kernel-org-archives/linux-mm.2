Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA784C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773266B00A4; Wed,  5 Aug 2026 04:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D52D6B00A6; Wed,  5 Aug 2026 04:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5770A6B00A9; Wed,  5 Aug 2026 04:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2364C6B00A4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:30:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7B41403D3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:30:24 +0000 (UTC)
X-FDA: 85066543968.15.DF00603
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1C87C000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:30:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=p3RP2Zv5;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785918622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOBR/YIjpOqevYoPUdylhCXb2OTHUbA6kWHOmhD/jcc=;
	b=G4hOi/9p74qzNgbrQe/Tgw0csDKD5jYBvKfrOJQjQB9BAy4wmmTRaqytFy3gkKxEiSd0f4
	6g4HM8bJ+sdz+V9ZpwnsdhtWuVMEVQzUaX9jFHYiUEnMVd4PQNqKcLo2u3pkMynbdxUEYM
	wev0GIfocLqhby8F/OT9b7eVCpZv36s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785918622;
	b=U3K4T3uOJE+jODBeVHwsQzQ1A1c1vjGivvdRg9E2/7iUTlMzJ5/Ta4DYZAA5ZRHymqe0rY
	nGLf9srEFD1B8nqL4sr/AXeekB6bFc5mFABSGq+9F7QMbhOQpR6vg0zHIkKbfPkZe0Qv6t
	NR4iZ6oN2qGqKEzBo/7HLR3CWQcQcfk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=p3RP2Zv5;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-529a1ee0e62so4289831cf.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 01:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785918622; x=1786523422; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XOBR/YIjpOqevYoPUdylhCXb2OTHUbA6kWHOmhD/jcc=;
        b=p3RP2Zv5beoAoCrORbKJPDRMlSW4EHxJTOJHJJZwwQSB7HmhVsR5kVm2ta3eMI2zgM
         Jv2V6aRvxS7p1OAvbBCfcLCGo7p/xrby1QwO/VuQ7Skcv8Z3s2L3lfQYplcEDT4bxFOT
         4uwKFSWKGGm8YKa/bV5h11Gc8i4MAyL5pbsLPHNQ4hPSy1fRGRBtgcLRrn/+W/4RzkNq
         YWy20hawA2AlvnF1Roq1o2jX0ezHMzAMjNiLKFBeamjWhitDxbZDcBZghrAKIIhOBHAX
         YPxN9z1A/vgR19y7aPU+0DKB2e9yCKNJdwZt03cPlOCkAxT2XhUes8I3krI5GOeGdPqj
         jdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785918622; x=1786523422;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XOBR/YIjpOqevYoPUdylhCXb2OTHUbA6kWHOmhD/jcc=;
        b=fnJhayKwbAXwpAoacOvWf4rSHHyoo3bTF49hoH3hMvyLu/AY+Ax5Atp8DcEBBQwqvN
         +4Tg39tYFXegltWW3H7p80q+5khNDi0BJLeB/PiniEITx7uoyc+UNyV9H8CfmxyD/fKp
         iL1c/y2z3bIM8pEVUDmEe78pkY+4zoebzt3awbpctLmqFyHp+kZsfxYvlylYgd6/PBTc
         Bnqzs5saZKbfXi1nDrhbcZHhFxCZC7MWIexJjacRKMhT4BzV62dswfWsQtjX2W6nE2tk
         jO98uAkcpSFqm2HC+a/t10OGhrqMvemVYC7PSo1uxOD2zHcaPqvtK1wK1a4UPhf4BXIH
         h8vw==
X-Forwarded-Encrypted: i=1; AHgh+Rp3bLAO3C2b8rpG7bTn1b6dPdZq98WLeHKihigMvcJ5HxMrOb6Om7RvTRPmBDm1OINDSKQsEyOAjA==@kvack.org
X-Gm-Message-State: AOJu0YziV9537Y0pD3jC9KRjIM3DnK+5dFvtDMXIJrDSvjVXbBoE55at
	P3GoysWK8KYTBlesr4zRUoaT5P1HsO8fdkqTTgFJInSya1v/FnhPmQhDdTZ8lgdh16c=
X-Gm-Gg: AR+sD10GSlalyToFiSjMcfpmnhzlElZTjpiZPmBBnxRgkbwPo5g+d2rgIiP0xdXhfpA
	YZ4yZYrrCyRUSdIKz5k6f5tx9S9l3emz4LfedZ0QqAK386IQtPoQctZXYKSG0QwDConVcpg62FM
	wXtDPENkSHk90Z5XKNPld1TRaJopXuTtbpuqnPRRm4olwxYUyDDcMtM+RiOZ5fawZ7PFe4QNC0S
	6etq3fmutPdOn21OBIC+rX7dVnk1VJxkqsFLz/ejHol9igQETkvKz6MmzoMln2yLu33IXuh46Sf
	RR9QDrb+8H2sn8a1EixOSrGYW6BSrmG8VUJJEct6ZGs2n5rxCnqW6XPvPEFTQaHw6szFqVzrERS
	7vdKqCmd9x8maUUqFobvYkj6NyDtYcKeiEp0NkxyLxi4iKE+JxkbEbZx5xFmB4gSpNkTbnOn6eg
	iQ2q1IJnTuJd14MqLtalBq9n+yTXfA5gdq84sRTrne2JsLU5J2CZQ2SKx2nhoeqVKARKtqJ5IWk
	8DMjTQAAOjZZKVcHGewgHnhORr9jJxD6JgFqJcI/8YH
X-Received: by 2002:a05:622a:143:b0:51c:1c2c:a8bc with SMTP id d75a77b69052e-52ce61fa747mr43158721cf.37.1785918621889;
        Wed, 05 Aug 2026 01:30:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52ce8972e90sm14423461cf.27.2026.08.05.01.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 01:30:20 -0700 (PDT)
Date: Wed, 5 Aug 2026 04:30:18 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 04/15] mm: update print_bad_page_map() to show
 anonymous page index
Message-ID: <anL0LEhb_bp_uQ1J@gourry-fedora-PF4VCD3F>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
 <amrvgjPNfKqWPUU0@gourry-fedora-PF4VCD3F>
 <fec1be38-406d-4656-95eb-048729afec40@kernel.org>
 <anBqV9z6hVLIqoIn@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anBqV9z6hVLIqoIn@lucifer>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: khzjpjo1r5iqxfb5smq568tu4nrpwrqm
X-Rspamd-Queue-Id: D1C87C000A
X-HE-Tag: 1785918622-325266
X-HE-Meta: U2FsdGVkX18ENp6XaT1AFPPoUCYx2bn4Di3XsoB5ccc3jrrHlzI4YU6PLObzQa0nA/K57ajXMF6NRoH7Xwfiu+a5OM248SD9fyWVIh0dMlHEecO6PRtRzOvJk9Xcp5jMF0QEe0+4tGJL/AAGs/spc7b0gRkkU6aWUCUfe/gCBmaw6m08mq0wigE3oDzX/hgjmtPa3YpXoZK8gfsq53fXkFEWT0FI729VPyF81AHazY8xLF+lkVNGQOQvZl/viwaGxEbfNSCa0C5S5DPlDCK3ze+5WoAsdPcOpGFTniUAPAy/0BbQlS+OSzXRb73vvyJh4rZSODTmUxkV2anC6WqAjpp8MXBayK6ae9RMH6gZ8EWQVjzhvWreeGu3zpQ3Q8udC+G9VSb+93rKCmtRtth0RcifVrVoOUNoj1YaFgXn/6qD/7HtwLQ9GOCrMCoHRAI/T6xrebzdtp+PsnejtCi9HUJz/EQOGsQxB8EoAXyiRDaZvBXeaULu7yeYllybm56bARoFZnHZJXGm3sjVyfSo02JUajG9DBXItSUxqQEwnxPm/OGe1+pEAMI7gbsjJ7C+gZwnuJYXfzoQ6ag1FiW1+nBP5CMJkoNKn+FY92V7jvGd+XzGjKrP+8eKHqvCyji//i1nmQB4iZ0JTRQhdB59kiBwQ2X+5PIr0ZaVFmMEg04YVQV3KrlrEb0aNqthdIaEEGKolZ4tBovdiKcB2g7olz8pjWZe+ebFjcGZNu5be3n4XPOjMBlxEh7wpL+iuCSH3KWi9pY3+DrfB5b3ZzCw9rSzNMsaENiTmXJq2o6ez5e7DSNKx9VzgGQGwM/RhBIUbuByMt6womHaF640OVeEOYprOgqykQdXC1nP0UsbskPfHOyAVz5z8WM5sS4IfBYMVC2xVcZ8uYi4QA93P12w6iOSveJy7zgU3fiW1FSWYDE9RrE93cn9nO0f+mxGidjv/eDOTtWgwx0iDMc5JkT
 RhGb/YWS
 qJcVAjEP8dsbt58VU91q8MyK437FXxACxRbGMSayMkdHeUzKvmEDYbFI917LyIehgrsBZfXByPNJXBKQWobxMRQKiFGAoAT00qwc/DmgNuxo1iyEUrYapZT0MtcZ3+sRivnPxHPwwDPyWiW94i/JtJeDGnNiJkTE5ypY23zzpP0YGv1tcpLyLrngh4gX6VftK+CV0YO5gJvjT1Ku7jRl3ngyMLGlbRq98JCGO8xgd/m9K/23HJ6uzFbSNGBpATVw7smIHuCSNeBL2GCbxUg71k0iRc2roHpy6sgTIhiUOKnATsWd95ba70EXWG/0Kduspsma7u8BWsXpaRmIYGx/HsgBCkqYelPcOj21BphaOQbtPBaUJiMfCtiBQDWg6KzPypisl+QG2aa6eFUaGzIR9Wr8UZMvkcZFU89h0mSQDIhgzf8Arj49owagxzIGrS9LkRpZchD0qkqcftrE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:19:17AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 11:39:11AM +0200, David Hildenbrand (Arm) wrote:
> > On 7/30/26 08:32, Gregory Price wrote:
> > > On Wed, Jul 29, 2026 at 05:48:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> > >> This is potentially useful debugging information and matches the existing
> > >> page offset provided.
> > >>
> > >> Use the raw __linear_anon_page_index() function so as to always output this
> > >> value regardless of whether the mapping is file-backed or not.
> > >>
> > >
> > > Begs the question whether we should mark the value based on whether
> > > it is file backed or not, but i suppose you can gleen that from the
> > > other printed values (anon_mem, mapping, vm_ops, etc).
> >
> > You mean something anon_pgoff_t or what did you have in mind?
> 
> I suspect he means e.g. adding a (A) suffix or something? Like page offset xxx
> (F) or yyy (A) I guess?
>

Yeah just an F/A in the print I suppose.  Sorry if that was unclear.

If it saves someone the head-scratch of whether some bug is because it's
"file" or "true anon", given the ambiguity here, seems like maybe useful
debug information.

~Gregory

