Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D0DCD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 17:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0DF26B0005; Thu, 14 May 2026 13:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF516B0088; Thu, 14 May 2026 13:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD6F6B008A; Thu, 14 May 2026 13:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6C8D6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:48:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B59C160D2A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:48:42 +0000 (UTC)
X-FDA: 84766760484.29.71353A6
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 65F3914000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:48:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PlWpIOa9;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778780920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cPQd8ZpfahwERRbvKiOm18yc/xSSB5/jBy80Q6IlfE=;
	b=0wC+KhVxAC2a3GWZugf5z7K+6OaiW7gGhLxcVtCM/WJyaOFbeQlZdyFnyH7LADgTyXXa+h
	gE0GyBVemNb+iq09kbwsqde2trvoTxYrKdliWLICX07lAfxQX95LE+j+Z2oyMaq/0a0QkM
	ioxzqR8OyE2U/bZk+GJ3L/Y1OQ3r/9U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PlWpIOa9;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778780920; a=rsa-sha256;
	cv=none;
	b=Dnio5B5/bYxtCO6rY1mmhgq/n+4Lk6kjFBHrPeoP84OWOT147W3zgUfZ6Y4kUWJXhRE7c4
	f2h4d3vn9YQNh8WcnhCBtFuQgabR2GW6SRtEsuMVMLYzNYq9V/4bEZhRpPo5jhU9fU+0bc
	1a9hChE0poIYw1A+gkHEhvoI3QPHKFU=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-514ae601e01so52714181cf.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 10:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778780919; x=1779385719; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2cPQd8ZpfahwERRbvKiOm18yc/xSSB5/jBy80Q6IlfE=;
        b=PlWpIOa9PTw5/uSQBqrwCPCpWh+Ar3M4zQHgPFS9T8yATfvcuG7YwEXetymgg3pci/
         4RrZ7+KDI4gN+Ofbokm4btci3fb9ngmzYpF1iYazINwuINRJq61YjIkDcKgvlmHVqVy8
         DM1rPtg0fk5GmsoDFMeo3psbpXn6W9rfzfRm19hJMQIFFifcMhUB+qijc8B59xnYdTJy
         WnDmXLw5aDZ6AtmOKJK23CzvZMBGZp+LzIR4Ei1GJ4VHVpi+YwgMsRYQKR1Q3cbBDcOC
         NBJpbX6+2Abr4yZI6jHzmMCmxTJW27zz0H8stmFQPnMOEgrs7F9ew0un/Fpr0owJKO+g
         QCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778780919; x=1779385719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2cPQd8ZpfahwERRbvKiOm18yc/xSSB5/jBy80Q6IlfE=;
        b=Uqk1AyLMzvayjl/RmJJjbVaQM8K2Lh/zeAVKJ80v2G1CiGLl7RcLIhXrH7BCZpTf1P
         SpLTRGy0tAwIJjKUGztFE1VEllQaWgZFeNZjtzUcu2iHh5et2cZsvJ2grccXVYIQYsuF
         34mgpjf3Ma2AUwuSRE6wuHM8ppidwVGDRc1pkgy8hMBY+YBlG3e2+IpCegZ20SZMOwdf
         LIl3IbF4o7olihruT2P8PGojjDwbGTtV0kg4V1J6uRaTm7pi+saKJW4FI/s5Mi75kYZ6
         b9SCtz2ux4M1AVhDlK4pIL75h7af+VLRV3XTCZsWy93vtD8slhbi4EkLgHTpGyETd8b+
         fXDg==
X-Forwarded-Encrypted: i=1; AFNElJ/iQ+BCHEfxVErCtkq5l0qpz1fze/ObBLkyyK3g6BpBME6SExwvr7K63mN8iYYdzAo3Hag2nH6AOw==@kvack.org
X-Gm-Message-State: AOJu0YyKlJFlYfzHg7EWomthZ1oDdKnQ3CtkwJGm6Jdb9fAcpsnIYyBw
	6SWqbYafwbJV6+fZpNsvW+Sn1ruOmGgBGqVqUapbSOmhR8GAc1x4prBT3Kn+ZFNVmOU=
X-Gm-Gg: Acq92OHDVSt+0vAK/+MuJwQpQORCKc3LoBeN5UUhhQMML92/M2rYLr4H4fr2dQV3DPS
	z6vVKC0gfd8t5RSqkk2rbB51lyuCNmrqhQ1knNt5p48tfK4j0U9tA2iE3EZVk0ZjZ4OjoQR/ob3
	fmCnoEUAbaECCkCWwMDkqinhq6QroQbBiFxRBbGdRDpAIuPqfHK55QUAkrvl433Qu9XI8aW17zm
	WTdXt+yP/GlJDPIzKqAgg3vm+zlSwJSUq32Ze7CP5a8wNfexnRuWzS7FsKs63ZTzY6o5AIpberU
	RfzrTnwtoEJKIRNgAgVap3hXODFLxC19DwBrtcmbnBqU/jIhO3ryQZjLZyox5vdpnynBeHqYXD+
	ZunHNb+8HzrbxJ3HyPNfyrF/fVprPnPI7vYfZS0+CtLNUmfRb5Wd9oq7ScmPV8ezEDxvVkfZfhj
	hzL5IP3O/8lQwQXYlYLQKWD7Eb7+Adf+nAcp0UQF2QrMysUZwCUNGpT9UAYLqyLg52SrnWQ0Dhi
	/6UBxRQY6uI
X-Received: by 2002:ac8:5d89:0:b0:516:4f8e:3004 with SMTP id d75a77b69052e-51659fd9682mr4733571cf.11.1778780919192;
        Thu, 14 May 2026 10:48:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c9093e62c5sm29499476d6.21.2026.05.14.10.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 10:48:38 -0700 (PDT)
Date: Thu, 14 May 2026 13:48:36 -0400
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
Message-ID: <agYK9JKFInSwKSZm@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
 <agW3JyLAwVsCZ2qR@gourry-fedora-PF4VCD3F>
 <20260514104735-mutt-send-email-mst@kernel.org>
 <agXrCinY2HmJmhT6@gourry-fedora-PF4VCD3F>
 <20260514113337-mutt-send-email-mst@kernel.org>
 <agXtOeuYNin9nYN8@gourry-fedora-PF4VCD3F>
 <20260514114637-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514114637-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65F3914000E
X-Rspam-User: 
X-Stat-Signature: 47sh6ihwbukc3tch8kwqbjj3y7jsgq11
X-HE-Tag: 1778780920-880683
X-HE-Meta: U2FsdGVkX192Cr8G2+j4AqT+E4gFUL0+CB4JluA0x8V11mgEemSKkzlrxZLAVVJ+/GQxbYisx4yqPt3Bz7K1a8N+plrgQ+lfx/Id7lLOef97q/5wnsMPVU+N7mAW4ujGs5+axR+OuQAAlo5TMHz8+Nt6qLPT6wk5uH75nxUtX0QF6iEgt7aELqt+HAnpWui0uxrHei3YXh1NNT2Nq4ItSPqjYRJuxhy3KhdlOg/MjyQvmShj85smoEdLzhey6cJSNYkBhPLd9vw3w1pgMrRaevYvD32TT6JsN7E6RH/xBGAYdGXcbYUGuhtNxvGBRZTHx5Yy89cznWbKF8f0APKJVBxpQ3bEq2OkNa9EZXLVOr5+b1SBZZ++/8EbYvxbqXrXXL3Uh8+w9w7jJ6kyn0Zw5cI9bbAp7Y27/wyWX/S3fQUaWQSMOIh8XZgLoc4yKg4wHMvhMuNyMthxOHuJI8J08RNYZ5TzyZeI7EXUmtTT8EAmejViUTER+Te1K7LHVlUBmUPJM33cM8Df8x/ZpXNBiZUUBit8Rd95qv/u3szPr/Pp2aOOEJtMU1YBfAnY2+9LRH5yCzkTKeHMKP05mYy2bYohPV1Qjt2B6uFPoMEtKM4OMNUTakO1CwnB2OEXOqpJ5ZoPLvToXE78hyFKcpEyFgYiZhOyguGkjSHecp84igBKSkyGD2gM8xxJ/kmbMSRIke653mMKUmsP+WlUGgBUn/Z7oqSN6N+XtlRQ9Y4qowjMnz2bK/sIJKr8guTl7nMgIb+Px6aeODMNtAWli4kEtUTD2Hn51Jtz+5xABvro7oOO4wG6i6qVG1wyBeRzTNkWAthI4cKnEjyjlwmKmaScto5SWFh8MsWl4ZzwVpBbXMraH5yTpJaNGCzDniD5tIujbMTK7pF14IoMYd61xkdQSmKnb74RW7dM54SVpd3xRsOOpq0PWfAAuvShK+LehsbzgVI+2ObDKaHvCCQBLRx
 +bfkac9q
 7q2MfKjrLiO8clBPZKmaFv3DiSK6A2O3f/sr1lIPI5TV3QPQbzgJ8JJ4XTQe+tnm50i9qjdh7xpSl9nztOLgFtbxI9vhiFjDSMp3o/L5HkjJQQr132gec0OOtns1cmMKi2XQYxajeaUl1FLcoyW1qy8T89CGg7A7bCLkEce1MBYxB/X0j454ZSwzjtkN00h34I93ZQ4Jes0MHq2dfE3BsfdG4QrfilYodqx4sEptcmgZxwxGW6KmWHGFic7st0w/tYqy9Cnf83D8bvcnA20/WOJj8/pd6LzR2uRaHCEMWcPQG6RC4Bu0cb15QeBJX8/C4pFU89MadLXFBSgxi53p3YjMHyg47JXj6c7dKmCYxHvCBmLowJppso9ZBb1vNORlq+5m8Cb3E03nYd5NMzrIhb4WMIaI3+5xtxSQN8vHDPWDDas7Pdf9FQ3+Cri7sVBqYU25wcQZ6NpxBTqbR9cEf8hdCHUvSCpgy9EXqRhJYfN4UfcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 11:47:19AM -0400, Michael S. Tsirkin wrote:
> On Thu, May 14, 2026 at 11:41:45AM -0400, Gregory Price wrote:
> > On Thu, May 14, 2026 at 11:34:14AM -0400, Michael S. Tsirkin wrote:
> > > On Thu, May 14, 2026 at 11:32:26AM -0400, Gregory Price wrote:
> > > > > > 
> > > > > > Maybe mildly out of scope but worth asking:  Are there other flags that
> > > > > > should be retained/propogated on a split?  If so, rather than pass
> > > > > > was_reported, should we just take a temporary copy of the page flags and
> > > > > > pass them all in?
> > > > > > 
> > > > > > ~Gregory
> > > > > 
> > > > > 
> > > > > Not that I can see, no.
> > > > > 
> > > > 
> > > > You do this exact thing again later :]
> > > > 
> > > > https://lore.kernel.org/linux-mm/9a22e0f9bbe1278913754db6df76e291a006181a.1778616612.git.mst@redhat.com/
> > > > 
> > > > ~Gregory
> > > 
> > > I mean yes, reported and zeroed) Just zeroed does not exist at this
> > > stage in the series.
> > >
> > 
> > More of a forward looking question: if we already know we're adding
> > was_reported and was_zeroed, maybe we should just pass the page flags
> > through entirely and let expand() check them instead of passing it
> > through individually.
> > 
> > We end up doing something similar with post_alloc_hook later as well, so
> > I'm wondering if there's a general improvement that can be made here.
> > 
> > ~Gregory
> 
> sure, will do. do you want a bitwise thing for type safety? or just a
> long?
>

Can probably just do like:

flags = stable_page_flags(page);

plumbing...

expand(..., buddy_flags) {
	if (test_bit(PG_reported, buddy_flags))
		...
	if (test_bit(PG_zeroed, buddy_flags))
		...
}

or whatever makes sense.

~Gregory

