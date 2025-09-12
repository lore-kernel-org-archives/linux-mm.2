Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94761CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 13:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C616B0022; Fri, 12 Sep 2025 09:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2D86B0026; Fri, 12 Sep 2025 09:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCAB6B0027; Fri, 12 Sep 2025 09:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 784576B0022
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:37:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DE7B85895
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:37:09 +0000 (UTC)
X-FDA: 83880699378.12.F2567D2
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 28D014000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:37:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=nzSxirlU;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757684227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMM405brjjFdnpjK1r8i1H+eFiy2IHFybvmi8f16fpw=;
	b=rEKhe+ypghyWoISYGZkgk2ZZE/qoby1zrNccEo1WVadUIyUHJmLznowuvtrfWBDE1cDPz1
	b46EeP0wJsQ9Wqx3GikqA3FThVqHsT86iA0q7F5Wv8Q2uXjlBSZWUOmAGVCpQdDxrQoJsp
	8ua4LZlJdKjo/y1dEivAeQP+Wm5g0kI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757684227; a=rsa-sha256;
	cv=none;
	b=1f+7SoTLz223ToPh/3hiVFk0pRkxTtLLTxhEa2XVEn1p1wzTl9BIINEJtJhSM8802lnzM0
	L+3cJuoVkj7xjMmq/pZRMHX/GVIdj2M0qtQ4LFEdR3bQ+TAfZC0WT5NVx64Bns34Hat/3g
	bA/hu4tMgGHCKnZUapte7ZxAy5cL608=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=nzSxirlU;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-811dc3fdc11so145227585a.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757684226; x=1758289026; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gMM405brjjFdnpjK1r8i1H+eFiy2IHFybvmi8f16fpw=;
        b=nzSxirlUSyJe2coR0THgFYTdQ7qfhgk6OhWUTcVKM4vBNZNZPp4IJKRQejrRAFchG1
         zvIgaFXAcF5rNt5U26/f/yMri7kn89ZEsYYVo7AGWpGeGt5GB/tU6CqxCFWS7jHozPfJ
         kVNayCr9A0lE3H+0Z2CK4ODPXNtHWlrjzwFZ2EpMOtdAK5DjusTzOYM/ogpTS5DOQMeA
         XZBD6mqG5CctLGJkz7Zeamv9hk90O/X4JuJWkAx0I9pbAAr0Ip/xzNBc6ox/7AgwSrS9
         43cMPeLUWSeb9nJ0y4XBIjOU6/vDejshbtRt9U0Ac2kmSUrhe5JTwLwiFPzVKADOrs7l
         tsew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757684226; x=1758289026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMM405brjjFdnpjK1r8i1H+eFiy2IHFybvmi8f16fpw=;
        b=Y0GlOcgPVZvMZuXLsbQAFeh5Qx2OPpu/bFI2MduVu96ism4IEL41h1cwNKQtYkTcju
         Ql/gnVIC7KVQ5QxsA13x8z7tFBPb0yRmmR8ZJzxYsVGt6XVg/erZUfiUhPkCg2CtAcS8
         ykcfBVRH6Fgu+l8CdLDy3oC+ZkXjyLjNZa/JwgvkM8H2UnBwpGvbZsWPDSqBeaW4SvUW
         S/8ED22lL46FTVhf1fSdRlnBprEK/xm3h3LSQ5nIJ81YAaB7uDsYq4xwJ2xzZvD647qg
         LAFI/MZB1ple0vPLZo8Z0ObPFLNvOOOjnQQP7IFcUBYAJ+Y6jfiyhyMZFp4vnisiP1dR
         rxJg==
X-Forwarded-Encrypted: i=1; AJvYcCWTKH1//aCCe525dLK2SvUzTsBKkuaxHI1XOe57B0x9+GQEkeWuN8NZFHYCZq3hbq/qdmWlzERxNg==@kvack.org
X-Gm-Message-State: AOJu0Yz/Rf0nYYeD0i0GIBY7h68Ohk6Y0DyRl3jvDyxZUY4XQ/oR/JKD
	JDPK/N7SnREWmtiEgYZ8qzlxfQKV2x2KtGhDokWbykJYOoYjFW/tb+DvnSVldI2IFAU=
X-Gm-Gg: ASbGncsS1iLTja+Ua36qJsBQPSXNBqzXN6WQgHPcDA6fLFEaQHdkX0cHcw2IHuLraVy
	xB4ZkxggY7aBl1XVmfmvRB488ydWOeTxDagLGAjJIDcnUmNEoL3oq+GrhHyHVOsxXoMI+WzjfxO
	0JpbXpSBXLSAn/Ss8dM25Z0+TUMw7vm7b0Xmnl+guIRCQ3J0EGfTLo3MvUsdQmfEI7bYUZ81L38
	Uih5Q8zubqHoIf7oPj09rVrNCSvq4cX51stDvtYUxcw1lVb4XCYn3rqY4pz3ozlymkf7R22FYQO
	L+4Jl/W40TXMZXkNK3vYpe/dr80cgsuuB6ARqjmaau20vyPN38IIAlpjKEz8vZqYkJqdsphGz82
	EbwCfOb+3GZZzrypPuqGE1Q==
X-Google-Smtp-Source: AGHT+IH1l85hOnywb8IKpBRIwjiNyZNrQdv1GYRya5V6eeksFNDva+bovkUz+anne+WxO6cXhs6oQQ==
X-Received: by 2002:a05:6214:2429:b0:72d:8061:93fb with SMTP id 6a1803df08f44-767bb3b6516mr31641516d6.11.1757684225728;
        Fri, 12 Sep 2025 06:37:05 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-763c03a7fa1sm26881466d6.59.2025.09.12.06.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 06:37:04 -0700 (PDT)
Date: Fri, 12 Sep 2025 09:37:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
	jglisse@google.com, surenb@google.com, zokeefe@google.com,
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org,
	hughd@google.com, richard.weiyang@gmail.com, lance.yang@linux.dev,
	vbabka@suse.cz, rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <20250912133701.GA802874@cmpxchg.org>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28D014000A
X-Stat-Signature: xte8sz4cwr1wkxfhhst9xayqcrcqsg3j
X-Rspam-User: 
X-HE-Tag: 1757684226-613191
X-HE-Meta: U2FsdGVkX19e1RWzBnO/rVwR0OIoJKQCtlhUS3Kv2GJi/xknZ0FNIQ+sr45D6xJv/+AKqgnIPUo1dcUmnMSjRj6ZBrlKjvjwGmxMWQbM6bmjs/31eUS+D9H4OULE2GOpM6dOaMuDwzvCU2aooWUk32S2Q7mFKdNr+g/+GnxlaDU1FoVIHm80nxdeXWiIiJD/5QeksY+nUL2cnmDEs4SSSV94I58Ll4m40WkmhRPYoo/pg46XnjaG3Dm0cZ8TofPRCKzEcsjNYZlfZj9ql/XcPEKbuWgGyeEx8c49oTkda5YTfmZ3GiUbW/AE3xWaK+BflGgjPseffnRURNIvqV4w4+Gf5EOi8J2LBme367+OHEQIn47N7REBA0HsQpUgfUXPLHVvDjJi8r1JK3mkG72p8umB8r/37i7kyqxDbeDoUBMPI82HtnuN1eXo5gI4CPaDnzpq8bDjINBrGxo5DDmayX3Dq4VO98U2QbolVIuEU9WrdCAkJyZX14m+FoDhpl3Lh7ECcOPQzVrR7MmmhiNG3so/Qhy3WTqA7PgM286t22J+ogvfeextfzj2ac76CVBZupYvYD8feTqCh7HBr81Lam8uo+sGDPGhkRF96KWkAbelCrMhw0W2d5Kp3BFn+MbQFFC4GRrT5fsQAHxVURhKVRMFp0U/ZhNsoNhCIdWhErfJ7H7ZgMHgg51PcRARIHRO1aQiQpdduB1QY+QhRLiYWlyqs+tfUZRaSebU31PGa6jIHhBmYnPsMzwhzdohAcrSRSw7DyC0hkr5oG+BSUe9hw0526B5Wbdmb+SAwj7yHL6Y5Cn+pllmCcBPOV4v/MTVaR9y2u4dNyY8+XpyZplRaRxriTGLT681yJegpkWrGFVToRsa1JWDbb4vZCkVdzYpozUl5+vKjdPTrtz6goSxIiSZmsOm7ZafS+IgO/OFheky4hhOhxlU6wqoXR6SBg9Yw/KDD9XVamuT5YOrev6
 G5f7kK1i
 AUyDx74P527xWUIMZESookJrvR7pNeKXGWNrSd8LCrmIzb0R4DUZG77jn2pZRnn4zgmwFOnYBwSvFwfaZWB31NcF0BhnxdbLj9BFCxFD4EcGvulV6QE+cSQxSD0907lklYIl8kHd0s7WSOo0oXcwsZi+tDXa1CLmxhc8KnT/f/PKNaVU9vVYjgqxTG9OmO40QPDfhzHRsgKz3I0jjHspQzVcfEBp7ecjkWcPeGEkKoTlvsQIJw8LSRUOSR+EY8ILtgOhR8SXsXOrPpvfTwwXwKwXT39G82592WxMhTEmR1GSHEkPQH84X35fF6QVBTF7wrmDrh5676xAX4KntzqfZYjhkO7vrW2L3A2d5Eb58tWNsOkYrlZ+tBp++xl0Ekh4ERFPgsHCACnUrSR8aCiFOW2/nDVTVErKeuQ7BxoS8ycw4F/2WdcLIV/uGMS8P7JmjIaYo/xc2zipripocbi0f8vM8JlDCc6qW6ibE2zDz1Lr/qq6a6aUZWklAN5sEYVrcsL2CIbka4vStgAMEzcsFEZvbMPTQ4NaBtsITMH2dyf1BhHAoYrzrIQv40sVYvfXWfwNK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 02:25:31PM +0200, David Hildenbrand wrote:
> On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> >> The following series provides khugepaged with the capability to collapse
> >> anonymous memory regions to mTHPs.
> >>
> >> To achieve this we generalize the khugepaged functions to no longer depend
> >> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> >> pages that are occupied (!none/zero). After the PMD scan is done, we do
> >> binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> >> range. The restriction on max_ptes_none is removed during the scan, to make
> >> sure we account for the whole PMD range. When no mTHP size is enabled, the
> >> legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> >> by the attempted collapse order to determine how full a mTHP must be to be
> >> eligible for the collapse to occur. If a mTHP collapse is attempted, but
> >> contains swapped out, or shared pages, we don't perform the collapse. It is
> >> now also possible to collapse to mTHPs without requiring the PMD THP size
> >> to be enabled.
> >>
> >> When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> >> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> >> mTHP collapses to prevent collapse "creep" behavior. This prevents
> >> constantly promoting mTHPs to the next available size, which would occur
> >> because a collapse introduces more non-zero pages that would satisfy the
> >> promotion condition on subsequent scans.
> > 
> > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> > 
> 
> I am all for not adding any more ugliness on top of all the ugliness we 
> added in the past.
> 
> I will soon propose deprecating that parameter in favor of something 
> that makes a bit more sense.
> 
> In essence, we'll likely have an "eagerness" parameter that ranges from 
> 0 to 10. 10 is essentially "always collapse" and 0 "never collapse if 
> not all is populated".
> 
> In between we will have more flexibility on how to set these values.
> 
> Likely 9 will be around 50% to not even motivate the user to set 
> something that does not make sense (creep).

One observation we've had from production experiments is that the
optimal number here isn't static. If you have plenty of memory, then
even very sparse THPs are beneficial.

An extreme example: if all your THPs have 2/512 pages populated,
that's still cutting TLB pressure in half!

So in the absence of memory pressure, allocating and collapsing should
optimally be aggressive even on very sparse regions.

On the flipside, if there is memory pressure, TLB benefits are very
quickly drowned out by faults and paging events. And I mean real
memory pressure. If all that's happening is that somebody is streaming
through filesystem data, the optimal behavior is still to be greedy.

Another consideration is that if we need to break large folios, we
should start with colder ones that provide less benefit, and defer the
splitting of hotter ones as long as possible.

Maybe a good direction would be to move splitting out of the shrinker
and tie it to the (refault-aware) anon reclaim. And then instead of a
fixed population threshold, collapse on a pressure gradient that
starts with "no pressure/thrashing and at least two base pages in THP
a region" and ends with "reclaim is splitting everything, back off".

