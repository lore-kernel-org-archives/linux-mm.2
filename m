Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A8EDCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99FC6B00C2; Mon, 11 May 2026 12:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A3A6B00C3; Mon, 11 May 2026 12:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11626B00E2; Mon, 11 May 2026 12:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9736B00C2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:15:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 376A8401CE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:15:52 +0000 (UTC)
X-FDA: 84755640144.26.80B1739
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38AFDC000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:15:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="f1QfEE0/";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjyPQOMxfBGAFix2OI3ZEchIRFpO76FTqe+eu0C6CpQ=;
	b=ZPbubag9elWKMtTzULbFPlLl1h2f93oWZP/ULHWFipGqrrkKh5ZXP14IgowQxEqzU6HRot
	7C065TFxmUD+GiG91gsOwkUNSGJDZr2RWcixV97qEayqWFbwClZxenerHjTm+1y/CIYqXD
	56hIuqawvkSLTStwb7OLj95lXaHzaxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516150; a=rsa-sha256;
	cv=none;
	b=V6l5gOZQppWyEmfV+XLTqJ66rGx0aOi32NJcwcYF4m/AgR1i1WP7QHaRriaENBVqW/FbmQ
	qbQBPF0s2UF8BfbrcyEXnPbaGV8gWkrd/ALxL/Jvj3kqI06nMwriSigQJHarjUXRlTA/oN
	RKyefuqZ+1un9UTQL0nERWjfSUA7gI4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="f1QfEE0/";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50e63771d91so46480941cf.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778516149; x=1779120949; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TjyPQOMxfBGAFix2OI3ZEchIRFpO76FTqe+eu0C6CpQ=;
        b=f1QfEE0/sqAtB2hhA8IWsGKySTnOyq89EtMKIR3ar5aYe9D9mq2BeMUtpZMS/GqHdt
         LlXgEAZPf71AiIAhrptjmKtqYxAngsvGIrcjcMKepAWJoxC4AhJqacGbhsKpCyr9xhND
         TijZY/YfnOd1Z+wUqYVL/2wydyiFLFz8lmEzfpn2GF57xVneaqaiH5/NxYxCUUoWJZu3
         EtOJGKRM3JlvYyojQEGBfFgf/6kW2PAnLGfT/ODZ0nKslUUKcf1f4JP4KgtWGLzLy7vu
         fYov1iHpkaO7e9pTsADjCyWt1F4i9TUmPwoxLPVNEn+9qa4eLiMQAaH1cjTzomb4LSz7
         f90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778516149; x=1779120949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TjyPQOMxfBGAFix2OI3ZEchIRFpO76FTqe+eu0C6CpQ=;
        b=VjUvaXUM2Gz1dDiHDh0Zjvzs4oEKDvKD0A33PF50YLihaQ8atuSPqO73vLGxhsN11r
         BKQVasEQAR6slozT8GEuV0OnWzOJm173oIpCS06xoU4QhTN6OVQ0gl0+ASHMZ+az9a5Y
         466CdbOgfNxBbDWIIxkRd5lfV2FptSDUJf8fvfW/vw9sSpE2LFzXSCxoaSrwEphAdvqi
         FCQS/qbixL8upMQCNaclX/XmwfiEpd4SlTfg8hiwRo2GgUClF2I0+P9rcb1hacH8j4Gw
         Wrpg+qBLejt5fqq5h+JHUMQyA23gQ6o2EiT0F5DUHGm5Vqsd9DP8lcSGe9DjF9VbLUaN
         /aqw==
X-Forwarded-Encrypted: i=1; AFNElJ8aLwBZ5O1jIPL0Y99llb8vAqq91LUEbjpz3peJxfAtQW8SP+4ZXgGhl7Bog2Pd0YFZTPKJk2nGEw==@kvack.org
X-Gm-Message-State: AOJu0YzqIG+G+A7WCf49qr1Nrg3GU6HfYOgT8a//Jr1JiZzQuHhR2Kfy
	HGThlFO2X3Zw3DpuFutKMa4XuhSrSWgSdVi8fYPZd3uhQVROPzQ3C5RSitq5gCH+dVY=
X-Gm-Gg: Acq92OFM8jeLhMgC8CWsDmtwZX5u9tPR9BTpVbZ6M4rW/K5xZwJFtMopvsRACNK5ffB
	oKCzaNX3ZT4viCmlYKDF/vCvVhUFxwL1jBWl6U9K/HB7seSH8kKALp3pVX67DcExQDceKqYgh9G
	1GsSLpNILnpx2zJfSBsp9p+YmagymXnszLcNrI3M8qQb/6kLMgK7pIr/BUDXNY43r2uWMbTUMg6
	q/hqWdK6H0YcMUgsmKU9eJkuJdNcClee7vlRuEl0LEHEwCmHIUG+fweovbso+khXtgJ9Q50Ydmw
	DJPQVjwVX2M8PIOvfbFSZDAEHVWfSC/OTtm/lJz4tkMG8l0abm2+UGUtFXzQSUxDwWQPrQpJVh+
	VQwCcy6DlPXNbydkVGIEkNi9tbAJkaSloB2sc97cgUAVdiSYBNLSovuJ/Z0zLOEY4OUgDK8TvEK
	aby3OexYOrzDrnj/xXqGugZnUJV7xx/DC5MhqtKcMkJVCaj9MDpSI+zEOdjHjPqTaExIwSKOvqF
	O+dCBrYXSla
X-Received: by 2002:a05:622a:2612:b0:50d:9efe:97e2 with SMTP id d75a77b69052e-514a0b6ef2fmr155357011cf.44.1778516149163;
        Mon, 11 May 2026 09:15:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148fa78723sm89504691cf.3.2026.05.11.09.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 09:15:47 -0700 (PDT)
Date: Mon, 11 May 2026 12:15:45 -0400
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
Subject: Re: [PATCH resend v6 11/30] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <agIAsVO2o4_gIxHL@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <99c79224ca94e63dfcbe8523cedb2a8d658bdce1.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99c79224ca94e63dfcbe8523cedb2a8d658bdce1.1778489843.git.mst@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 38AFDC000D
X-Stat-Signature: xpjcdjwr51xnrdf11gxk3wd6wgm775cs
X-Rspam-User: 
X-HE-Tag: 1778516150-522366
X-HE-Meta: U2FsdGVkX1+j3pZKroD9t3ItvCXAAukFqp/z5OjLlI6xesv/yunlAfYxYZSKMdMn9efT/P+BfU2rvHU3r/qUyz39BXbd2UZ0ZiazsefGd2ICkZQMZSwTClVxPTQ6y2l9Z+IlcilELinnGtD8RalpCtN2YM7UcVXu7FDg5L8sVJI5spUFwO766IqFLB68cjB2X1qRHVvCUoS7VfL5zUgzrknKL/VsON0Py2a+YCvs7X1OLjWhEYvOVdle2JjzePFYaY7H/6ccPnMqyMQ4nL1my798/5F1Zvw1pOXeUIiWxojKVb9lnhdT5b6U9MQKwhLkqHkiaYf+MQ9D5E481qSlTD8wZ4lb3nLbMMHj8Z/FwMgH7bKLOK5f3J3ubesVyzQZrM9IjN0dint6SHegWO/0yejSymvs7svTtg0NF+Di5sHvdO9D/Kgks1/mOXznPoFv+hFiD8NJCKNvX65P0VkoraDDOpl1UT+WmMF2MXEVL1mzzez6/B6kufR1PRekemukLRHIq6dnj+CC18Uz+22xtLVssybPv1DaXt3QalSzPXFMECyhGZnpDasSafWsVaY80nEwNExHjuE+dMky7nwcFy0o6Saha8Yd5WoaAKORsx9SssNEFpPOqRf1gnosWMyl7wrFsy6VBkJ+6yX2pKTWZJtrQaG7hQJctTehMy3AQeTq4hnUnUy0dvD1YbcRx4VsBCLj26SVI11a28Oynt5kM1gt+MgJ4udWbZUF1qPa35PHh+sEmEfkxyCI8cLe6xs7H73mo1XUCUNcTTfS3CnFkxfTu6DJNqyyRKHAjHDZIkjhn8SiWNWGkwmcpP4Bo3OyjNaqPFSyLT76lNn8TCNlDrN7LZ1SqLlMAnemQOD//B+XuxIum/pQwUVzMPHk28UNzusFqbiZY/WcBkboZt2+1rMaiJhOMT9D46f6g4AVW37V4DeuXLcstcKsV7lGWI8fx7YbfnnVF0XY9w9kPkd
 X3JSMiAf
 oUCQVRPlukvzSNYZG2dQj4mnP4emefAPZa9/8CNk9impD2f9wXe5QUjJ3bjAL25e340j+I9aLEw/huq8LWIAD+vTZJqtnBPgCdk0SIjed5wKbhjELhDEFo/NE6Mz+MJwRo3r3RkfySwi0QImGW20bNIHHRjk2BZldS/GeWHWYvaFWMcyN0aTxv8qJhE1rqmvIfLYxZ3HE3u4aNHcTaoxKLeyxR3uIjdZeQuI/UJBcugw29qUAu5aQlo9iUkcn7gTxcLd/gx+02lFlSuc6aslx8s/iQ2BoYuyoj2EZ4VfDp+PdUsNV55EDOI6FYxMrek6bnfPxcCprZJKsy0kmXrPGjCT9tgq+MZYeNLeyEq+My4IfunFoNm9rMqdcB2Ks7pxDIYgGBFZCILZxW0az6vBUUZgdcN83eYIGHyRLfuIaorj2tJzR0V6jon9gKACL4rD4AxXAhojC3TP7r0ONviFMdaTP1wU3SZSPp3CgoBhaZvmcoiwG3JpbIAteQO1TXcXFXXlJGgUPAn92Td3rXJMEabsROd8LgY3989sJeyY0/nVfZEFVA5A86kvswY2YaJY6gPyL29Jn5WYrFZKOcw1sVW1OKYbraxJCn1pga8B8IcOB4RA0ZwD1oY1zWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:02:45AM -0400, Michael S. Tsirkin wrote:
> Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing
> at the callsite. post_alloc_hook uses the fault address passed
> through vma_alloc_folio for cache-friendly zeroing.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Gregory Price <gourry@gourry.net>

