Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3401DCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71F3F6B0088; Wed, 10 Jun 2026 06:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7076B00A1; Wed, 10 Jun 2026 06:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D226B00A2; Wed, 10 Jun 2026 06:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 507B06B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:42:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F22E4C2E7D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:42:03 +0000 (UTC)
X-FDA: 84863662926.08.CC9421E
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0B118A0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:42:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sfF61J0j;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781088122;
	b=IY7G6pW/w6eeWoWzOsnGBc0OVox5DxT0Seeg9Gf7Oksy8q26R31j70+xjZ+cGopVa8VLmT
	rLG+2+GpV5c1nYJNwxFvO5+ZYiLntdsVOxYAAjbYxeX0IssCOwtiYF/B1ntiRXfMG+6twN
	nMBSpSYH35zQx/X11mbhaUt54V76Pzk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sfF61J0j;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781088122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgx1xgYrFcSjqIUoyhFqGxYUzhtvYzBpQalCqkbKQaU=;
	b=1y1EvZULf3PPjthj/2w5vLc7kOOef0hIlr6wF1frJBsgEzqBv7fZ1UfyaSg/PpsxF5J5yo
	fZw774LIGtzsdd/fTbMMIL7+k7kJUPBtw19bmSnw2UQq02IxVxjm/xaC55G0yHV+IjWPuh
	ED/G0mOAgeEETXRSa0l8y+MLYVLH3U0=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ce9ddeddefso71210716d6.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781088121; x=1781692921; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pgx1xgYrFcSjqIUoyhFqGxYUzhtvYzBpQalCqkbKQaU=;
        b=sfF61J0jF50T7oNTg0oodLrN4zxXPJC7Sf3Td8y/ZhYLES02rR7VCTOWlXfT1O+ewr
         UxLPdfmVmOYiB7Mv4NB3fNO3ISZAJ1xXuzW81x/kSp6WJMjGBPJe6WhTNLgD0WrBwb0C
         9sJSEC3BUKJOd80MUijIp7xnTO6Csm1vUDJOlUHkfJwS1bx13EJ8nCw3vZYDFosAwInA
         fvFqnQCiaN8R0hJ8BvSEzjQXIHpxdq9qZF30+c1vM0WNlQ3wVU2fhBxDZpaBVRSmFIAE
         ovFrv4OMQwNECyI4WGZGChJcEj9dMB1JmC1MYGS4RCxAEuACPIF+vB59wPBw+iTnvtFU
         QZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781088121; x=1781692921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pgx1xgYrFcSjqIUoyhFqGxYUzhtvYzBpQalCqkbKQaU=;
        b=IYY6QyeQRq+VXLt33LlxTj/qns/tdo4m79XmZrwonUGnYRNruUtx0DipEBbr/Jpj8f
         1VF4IRvxFNYNKD5c0osbHtns7qFOu2MKvIKBR+cDY3tUPK5rRXcY+udwiTu1tHV9W9Wa
         jDEr3YOTrpYILtQlegUDr+ahLVrGjwHl/gTfskRn6qizJ8kzO8EkufM5YQQszg/e86/k
         /R0COa07Qmrs1lHCuKQEN01B2nKKhG4UODuzXRBNROke+efIByNXgtfuv4k3raXb7lhu
         0ZRhpOg3+ohFAr9KS2+uJglN0N013d1s1d3dg79b0nVGiDbSEDCXFNOl8cG9Ms0W7tRw
         hJvQ==
X-Forwarded-Encrypted: i=1; AFNElJ9n8ql5fKoL0fXWrTBddMoGDRUEFgAm4KCw2HcPmYfzvIPOP/3R5w1VDIMzw40iTFwM7OEyPYVgtg==@kvack.org
X-Gm-Message-State: AOJu0YzsQuy/ZCEpjx+D8uVxNK1kaMoBXxKpu3/R28a0sqZ2z18QTL7O
	PPTwAcdfro0v4koOuyLrbmGQ865Kf4eOpX2d0POhG7cfEjfaLkI+ep45xa8eq70owCY=
X-Gm-Gg: Acq92OF714qsXD2adLgQ15gIw1ipvZjvimdgw5JU3qYiEaUG0MljC0IjgpNopbivhBu
	qkQC89ltMni/Wlxbj0OhpN7uWOw/vbIxm5GWQKhkNndum6d14BnweF8uebMliQzaSBLNs6eRj0P
	UpKPPTlPN3B4BO90YF1Qp4lf5exiLa4seag3+L0HLBbBvsDtQt/Q6R7eSiFs2YAuhFx/a8YkJEz
	M3TV3/JxYwbiIQqDkqjPwGMl0KUn7qzupdG6XSuaEpUrnoVy137jr5zKoRTX/xq+JDOJO5GBEs7
	SSMtVhsY0OSdGYhs+fUhAud+XhuwjEeidm2bYTZnwESyaRL52AkCORmYsvLdZMWZ2AxHovGsEL5
	b1QkzjECkZtqkz1OVR3m5p1lAeOyphrIke1X0GOkYZmypq8gVe/4SrKC/+IzPrhEpToR5NtbL4G
	cymL0e9eQuo0POpHzDphw4tj5+fkTXD+CnQ5T+u9Zn3R5T1p0lys1i/P5Dk4kGZeWKKysvHNqFI
	K2TeoOy5YnqQZ04mQ==
X-Received: by 2002:a05:6214:c68:b0:8b5:6654:7556 with SMTP id 6a1803df08f44-8cee63e377emr394580386d6.42.1781088120984;
        Wed, 10 Jun 2026 03:42:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd06e4d6sm231860136d6.36.2026.06.10.03.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 03:41:59 -0700 (PDT)
Date: Wed, 10 Jun 2026 06:41:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah-0CyZurn5D1ezY@parvat>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B118A0005
X-Rspam-User: 
X-Stat-Signature: hdwg75d9puptaui4n37ri1i7qutx5msi
X-HE-Tag: 1781088121-24168
X-HE-Meta: U2FsdGVkX1/OaP6sRUJ353potUkByZGQ9QM3TqTMspsY/PR51PMhLP3S21y3emsHFfLjPbt/LbElWkmXMF94jOsP2v1b//A4wjEjsVsHdw0GGuiDPkiQ2vIif/KQNe5tghurX7CVWQEKV17bUdTkko8Iln9LrI1u6g0QfhaOj8o0KwEPujR/AvKe/71+/oE53ZVTZWydMkDwJxDcip13Sam4hdMnQqo15P7Anw8E+I35W3/6khNQuchdwvCPI27RWDP2/t1fat6wIobFqbCOVgTF/29TqVeziXuwbQ7x4Da3W9cw3D26Bzcm/4h/ZPc3W44Iep/h36eLhUb97jRQ9Rpt29nq5hypuACdXXzCVSbCCF/6bmFFmXX6NTnNb98MhpG/smOq64H1xen8aJ8m1dA/UUonWkOaN8WBBu2Tyr0jur1bexVTW/ttgogOs/ggcPmVWKKjbG545SM1aGAYp5KavnfPDdLe5oZfIA8XAG/L6wvCg/quMzAjgLJKL6/K8qUQ2vVDOjjBYBt+uWfsiLDJI4I3CbYuBO/NKwNQfrlmKNe8LPstBKLxI7GEOV9Sa/ElEa9hGPBhFN2FaFj3aJZt8fVtl/wjVocdkYM5DJuR3ffxYHb0bbPtsytxwUurp88GNCUYwjwatwRatlEPcIuE73QfhK9ddj9f2Wobp2n5gS0OQK0xRnot2n+MAuh1bXRFnhvpRbi4FH+y6CpmDbWO0oE7AZPezfbB8rTJAnEW9+S3tdY2FFIffzjbyxe87lstodM4WkOp00zlmQ/rgTBUDMomhi7FAwdnKZh2qwmEHYDTdA4ElNDQHoDN4ia4uZYgqBzUeU6C7W2YNyt/981iJj8qkkLBAWr6zTjbaH7WMqAR8VfX8VWmCdI46nODAN+ztmlUhaP/QCda8yy0tYACB76hvxcRU1Qw5IXsc8SgtmIuyv0HJt7pY+5c6TBSC5TThSGcCaV5jMQBVkh
 mVg+dxYz
 BzQRF60tQFbni6kDWKB9LE0PADJDi7hlSwr94R+ZLXZnTCpVTvxph3Cgbbfa4mTYZaehopULPVY73h2pon4sG6aPd/CgleuAuPbwOG4Kv8sMjRCq2k/O6S4B8hgvGcK9bHWDZsd3LaUI7JCrZBfwURkx7KgSh7ZURtTd/aygfXlCYMDKhlWrzmhBUi344FNagJ1/3EXLvns1AXqan0D1YfgxTJrz6nJeKNcNUVCg1jtqZUuzHg/NJd3F5WXepieifBPXEmF9RtdC1wtU0xNZhwLQhHWtkxEWiPqHAljCWArDqukoYH40sbmp9sC+I4XrSNpJJ73IEoyvwdzhOgv1kpUyVquK/uJ2L3Yg0ZHLsGFcCSqOE5pvur5vy3gsbCARo5un7YLSbKSbPBI1WdK9L+biR9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 03:00:01PM +1000, Balbir Singh wrote:
> > 
> >    __GFP_THISNODE cannot be overloaded to do anything useful here.
> 
> Let me clarify, I meant to say, let's use a nodemask for allocation
> and __GFP_THISNODE gets us to the node we desire, if that is the only
> node. My earlier comment might not have been clear.
> 

I've been tested an stripped back patch set where I drop all FALLBACK
entries for private nodes (including for itself) and only keep the
NOFALLBACK entry for private nodes.

This effectively isolates the nodes for any allocation without
__GFP_THISNODE.

This also precludes these nodes from ever using non-mbind mempolicies,
which I think is a completely reasonable compromise and something I was
already expecting we would do.

Notably: slub.c injects __GFP_THISNODE internally on behalf of kmalloc,
which causes spillage into private nodes because slub allows private
nodes in its mask.  I think this is fixable.

I have to inspect some other __GFP_THISNODE users (hugetlb, some arch
code, etc), but it seems like fully dropping the FALLBACK entries and
requiring __GFP_THISNODE might be sufficient.

~Gregory

