Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6C2CD484C
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE196B008C; Mon, 11 May 2026 12:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E626B0098; Mon, 11 May 2026 12:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D9D6B0099; Mon, 11 May 2026 12:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA8E16B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:17:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7838E401F9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:17:59 +0000 (UTC)
X-FDA: 84755645478.09.B6B5FC9
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94EE6180007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:17:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qb+9s35V;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drn3Kgf2td70TL12R8cZJsDEuW/Xzh3Ghjtpf9wzla4=;
	b=f1Tl29jO8gm3KVJ5VEKzUtzzdZRkdzXHeczenYVw4xO1+y4o0qUxowj6aZzFSmbWSf+C+d
	Fr7wfXW7PY31iGtx9dqKMgY+GKdGL7bOrIHmH6sML0EWphYuH7dOKyOKwTLPZSPva/LsUa
	543k/OcfPj8kCIHklvUiGpZLQy36yWY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516277; a=rsa-sha256;
	cv=none;
	b=Ql3n3YPyA6Y8krdvQ9sBZkJqU6gDIqP7lTKfSPro0PJmWcV1xzdoVEqqsthHlZR/svAMX0
	M6nrnjkh5J+kSrAmwnqA7gR02q1qUh4cuUTMCJw6MoDilM1SaNua2iZz7vdIlFuBp8S1tj
	gLAeJ02sMWXKZUFHpG1sto3N94e8dCE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qb+9s35V;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8d6d5e45c43so494202185a.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778516277; x=1779121077; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=drn3Kgf2td70TL12R8cZJsDEuW/Xzh3Ghjtpf9wzla4=;
        b=qb+9s35VA7caFqeJoiyxdyG+lebZQXgTt/taypUOvpOV35FF8cdAFdpYfMdbPJHHVK
         psDh9Ens5daViySPiANahw13A5N0mcsL23YGhYHxXGBSdUxErEfAivhls1gFoMgEi2Nf
         NviurZLLoYpbVc3mP4AxLPZpSKOSLXjMMTC2k39qi75k34uBkFQQPvi/Tjvb+hyty1T6
         4DqJMo6AkbFh1gVQd+E6nuINTZ1QdpiwYyHwPWuF7rLX58tbZn+MqBDgMKV8ZsV7sYGI
         esDmo2t7O1PixMQ3GOnZaDoyse3YwJgvLn1TkH0UUlkY+VqSXjV6Vm1GvEK1nD8/sE/0
         JSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778516277; x=1779121077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=drn3Kgf2td70TL12R8cZJsDEuW/Xzh3Ghjtpf9wzla4=;
        b=ABUsB8G8X4PmvO2vV4sVKZTr3Sj4EdhKotOYjze1rczaay4TUise++tIapuqb4L387
         zkWYMVF1+g4SSMZdJt34TLsvfa8dBYOVdSPNOslEAGKowXx0Mb5SbK7R1p4J/9cv7ZFf
         CBNR5KqJjrosB+QhNVIKr0xbLBhoDkodwFjwL5QJddXG8AV6ogOKj3jTykKqKd4ZFPgE
         3YV7IBEBG0sPUB6uiuucWg0C5TQpgIJkrfDPWR8bmgyRX/hviEieZeEX8oFPFqLg8OTp
         gbWYIFIKEWoQ5bEZK+LaBPx5Ik12o9I4+qJHomcI/pgkA5qR6KPXeITuyWNWPt+DGa9R
         XDFA==
X-Forwarded-Encrypted: i=1; AFNElJ8baCWroqSIfUc58dVI0gdZ0o78bn6cY95bMFWISzgkPek3TjONRvaLjLZJNyX2WXn7KwO1gNbErA==@kvack.org
X-Gm-Message-State: AOJu0YzMwK2qG0Zf78Zo8hJqkkW3vs2u5S7zCBMiIQPifXiBSSOmY1F3
	rCCHxhaFQtAuIbYDdf3OxhllWOsXf7MC8CZY6mqh1q6XMekZJFpgociLu1lIay7aPr0=
X-Gm-Gg: Acq92OHe1Z0WAoQdWvDMS89FUEzSrmCRuDAMovK5LsdvEdLjzk9B2OT5wGIbjAjMaay
	jNSd1tMaA5kVplLHnD0547XeO3MsfTt1f40OcpmCJHMAdT/F24+lXQuCSU7QPvcuxoHXt+BmgnK
	7HdSmAGY5pL15kH3zalo87Vqghvwctkz0KSJQPza4FPkpYPSyMN3GaiDwbNRTKauP1Z1G0uGjUq
	tYbEdZDJ99LuA45eqs8Zwvex8BsjIGBR4wHVTRfhXdLzvY/pkQjVkm4g8/ZVDzdyQtMgkVDF7sk
	d5rJlChLom5hJynuQ82amZVxkyyOGnshgeqJspvhaaLMaKC25Sb9x//s9/Vqxgy/McQBx1Z4rZi
	xm9JPBvehaREWBSMwGc0yO2wDbRy8w7sfDNRQpjpuKkKbSYe7wQyMEhl67bN56AOg3+TJoOKHRf
	a7Har2CQjVs0MmeJJKUBWpHdb4NJLVf8PjIoHEe/gNuqA+2xkI1redffXxdrxVIH6tzd4y9lkBG
	PhruEwIQ8JjdykM606VTs98rxHhgxUzSw==
X-Received: by 2002:a05:622a:1f93:b0:50e:5819:d7e7 with SMTP id d75a77b69052e-5148e7ca3cdmr210623261cf.3.1778516276480;
        Mon, 11 May 2026 09:17:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e7e97c8sm93404711cf.22.2026.05.11.09.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 09:17:54 -0700 (PDT)
Date: Mon, 11 May 2026 12:17:52 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH resend v6 12/30] mm: vma_alloc_anon_folio_pmd: pass raw
 fault address to vma_alloc_folio
Message-ID: <agIBMCYTKsFXYhCt@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <20ce2bd8227c0149fb205d293b47348c3ef49974.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20ce2bd8227c0149fb205d293b47348c3ef49974.1778489843.git.mst@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 94EE6180007
X-Stat-Signature: tiwf48ghgu3hkprbob1efgcuwf3yyooc
X-Rspam-User: 
X-HE-Tag: 1778516277-493648
X-HE-Meta: U2FsdGVkX186a9JcEiXn5Vjq1jzarSjpYBXWnSAwGBiHaUxYTDOghZAIZLvopiB4VzJiCD+G5gEkGQERDNOmI8+tzR+RH6iy57Ag8jwS/Ku7RMNY9jUswOxk5kcvBehtkb5ePn5cHRmI785fN8fVadpu6lCm8XqzEuIe/ry9XSm4dE1DbMI8Ka3HW5KO+WrPjhV0TNXsc5SylKlVK5qJNB+Ff6VUhIz14/O+lrEBmQff8EeltHD8w251zIGWMF0wINekkVjIM8EbYMnzZHsnDAuP3OVAsJeapPcVasKEuJ/tOAWA9tA94bbnSQVa4UfHOqxqds603yLUn5gda5F749iZe6C8482PZfqmDQFBLr9fnsxIPkudGu5znVwHDPEkUQnl3LJkmwbKXqWGJXeiYLi6iDKy7RMyHYHRlojgDlvtS11fz5zPnIFNoW1Zw/7ft0oavyBocRInTn3ZpxfpcoFnM7O/hw2hLhaLz9blaV1bhGi+k5qJQLLlydtgg8WrRgKgP9huO86THggCY3Zami32Vy/XR9INhA40VHpisim1lougGemn/Gqu3jPb/h1oftZ7dM5+6X/3NcResfVYIWVwoREsd8cxEns7Ug8gCMi08rBPTARKeUHcj+meFzWPhoYpHUPJ1XLPMK2PyA68ULeek1GDVyO0nID3FHxy04aufzUWhALioEvB/bjdaKpIfDfrwzNXgHS25djiaXwJpvDm67ojqfL8f1Ep2J+o+W2FmLoo3DQ8TlyF+6KQQxjY0SGMHpeuV2SBeeugCPXyGo1WUqA4FHioTsBIz76KeCO0eRAG8grrlFxkB/HJj03tVg3QD7rLRK6vumAnwy/CeQYs09vHSM/iutWIbSLyYzOLiapmyw5Jp73aPf5wYBk9GLlSO8TIsqWgrOpfX9dU41XegRWAF2VIySJ4t4UqPYAPUVDdGgoPmLvzBmw8wV2LXd6Xu3k9tA0BB+2fKHW
 gGNMDxYG
 QimSM4EFSvLAQs4efyeU6R9rlsTdbl/DDsfQDYtwMjJDEHwEMhcZigLb/m44OGwJNPpiy5dGdmTKz3FvHxNyI8VvpmrZb544OXfqr9DiiLWCS6S9clpm0Zg3S2W62ye3RESkmYYJjftWKB8O4GVlI4JEjmnR+YhPQT5TM+u+WeD3aOFUbIgmATueTAIqFUPdVGWLK8KPWyvxzhPGTJ+gwPc89q8zVd1KYO5ebyPrGPKcu8y5uEKwoSn1HvOQaHN8PbNidDzfZ2SK1oWFPt++EqhheWV40FlAep85Qnj9LJbBc/6nq59ytUX9y/V9FLAjGsAP7LYoUSIMLhgigLiFoYRT7peadzOhuZk5px2Vi820Peffm3RkoFbxHuELDpAEDMJAsmV+AAArEEGA9b7yGxGHKu+BTaugh4bsZ7q+POibzIjoJIkldef5v16ThyjNQT18O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:02:51AM -0400, Michael S. Tsirkin wrote:
> Now that vma_alloc_folio aligns the address internally, drop the
> redundant HPAGE_PMD_MASK alignment at the callsite.
>

Same with prior alignment patches, seems like these should be moved
ahead.


