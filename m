Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAAE4CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0E56B00E2; Tue, 26 May 2026 09:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561276B00E4; Tue, 26 May 2026 09:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E636B00E5; Tue, 26 May 2026 09:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 386BA6B00E2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:42:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEDA01C1844
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:52 +0000 (UTC)
X-FDA: 84809686584.28.7D828D1
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf26.hostedemail.com (Postfix) with ESMTP id 42130140010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=ejesU+18;
	spf=pass (imf26.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03Ae6RWKd6EnbPpHHfvNMfYhJeKoYpqPfXah8lU8jAo=;
	b=FEVkNhcDQ9+d2/RDPntlYavL8nYc/ngfFzWQklSjeftVJ+/IG9yHY/WCwNsEx/CQsLFRme
	RPkBr6gieb6qqU8uPuSC97k8QJfrodsnb16y85PpRcx+isrfHzPYsGNBTAyt+Hme1M3v8C
	LtQa8AH5Sc1Daxz1AOrS3nBaB+v4IYg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=ejesU+18;
	spf=pass (imf26.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802971; a=rsa-sha256;
	cv=none;
	b=AVtF5/y9B7sPM/RKJ2gus+mNClbCpZNaJEs4kRoH4LTKWXs2gRAXJcG6XGFypeG7T3l7vE
	D2Tjqhnznn6sGEXdfCPPa4YisTl28sdD4UXpZ336fyELHOInvsCRMZUMMX332strmRcBrP
	aVLRkiet4soWOv7DmqIG68KoW6Lnaog=
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64QDgKbw016888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 09:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779802946; bh=03Ae6RWKd6EnbPpHHfvNMfYhJeKoYpqPfXah8lU8jAo=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=ejesU+18AVFFIEgBaVKUv1hsYDQbQOg6W/J3OH9yYwjHCIb+jpqlrXpt7KIGFvPSr
	 2ht/krbvYSvIBKP5sZEAjbhEuE7NL0QJt0YgO2g1S4v3XDL1RR7qoft1xNr7FQPzka
	 Hwo8LpmDOwrc3SQGOlv+wHY1Wps6J/GMV8xeaovvUDIbVbEF4UWSI1igFd+XnkAldn
	 PfbQ90HPxiIGNmRMH+x0KVLVvGWyDA3vJG8EknOdtJikYP3UixBrFiteufTcdEKT9w
	 wD4NduZ5RLVuaoFmZzDQYDwHkVZ/sYNwLAIREliUiPZLApHgIQO7Bf54STmkIdX8Zw
	 hZdbOvYuIOKBA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 137D16B282ED; Tue, 26 May 2026 08:42:20 -0500 (CDT)
Date: Tue, 26 May 2026 08:42:19 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Akilesh Kailash <akailash@google.com>,
        Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
References: <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahTzHyHBL8t0iNBR@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 42130140010
X-Stat-Signature: zb4m745t9guw1pct9txw1jdtxoy5hxsf
X-HE-Tag: 1779802971-272315
X-HE-Meta: U2FsdGVkX1/yVIW4JR7/VafxipzCy+z6uyy6CmtzHLB2PhfXtOaaOgjoeNAL+fo/UcE07fAGOwyY+tQ+J3AvrawwZ4K5EPKQ1BD9yn5zWEx7kxXWQQBFyRwfYyoKgufkm5T/OPF57M4jtCjLxGjA0XOOPDri0c9OanKAo+eJqAXoE4xSrhn7QlQ7QrNNKqW7cukF2CQo9WDAuMiUT4/ECd0jGaWFVGSNnNub3kbprN9q+RpSVnCaQhU4yYC3Cuu9pGssacsizuS/xAVqiO1DRaQV13243+DOFYn+zTH0X1DHmKXQ8rj6/EHkSLA82tpT8p16d1/Ugpw0ooXVqqffNbd7DNVHs1vr/UpcgOtmQynxK5PsseHPJOay5tVXvZSIVWp2P8rF6TlK1Doh4EEckVcEwADOP0OGJZI2vSsnUuUIRUT37bbrN4sBNBxP7yzRIOvUAzv8c6NLC/h5HGfyWRG9i+UdMoquQOJBEdhHU/nGyF76H2w7C9lj45BwWAvT+U5JA7TtT8Vk6g81JL89Jmg952PbmcBjXViP7eXaJ4LpOOWahLo22+XS4P+ccUT/Dyh4NVcaEO+KvuxKzwXlRQ6rTrAEkn2phro5j45qb4y/BU2xyKl2DEourTsV4skwSfruVuQDU/539gJ7Mt7reiIDmdCBVNcy0ZS5TzWzqRFj2b7xoyuan8u565phgBH7R0YXLy+4oI2MguZvLVC5J1FHCrbppV1lC52o1G2uVQYrp7ldFmQS0UOUiAUi/+/asjKkGqta0grKvkffSo7UJB9ZZ8iSvcpACOuFxVssFVEsbHaedKVNMssYZbx418YnCP2JoVL14BPR3Q2MSBKAPUowgCJmyUCOa88AQo0ivppo8GpgQk06n2FX7JC1Z37yfUqo5lcwN7Tu5xtq+iUT3QRrpNx9JMBVd4HjI/LOEWoqekYgMgUx4JLMeSOY3M7T+VWxNAm7wj4bxRR/Pge
 ZffN2Zjd
 stbagSc4fhvDvKSpCxdmUpG2F8RtrNFeO74NM/xth8dE/Dm5ZYFdDv/PHdmOuZ+Eq2Yef0MUiemH3CQmkoE/RsYVe78AxklJ3W3Ggk6urVPLk3nUuAbexp4rPV2pXKIb6/qUGCYoSkMpnqCvfGHTHJaJ8oGti6fJvyag4HdirCfn7bV9nNT0Zk0SjvPEVPuqXQqD9p9rqxWP3h5Tcj4T3LEhpkvRwMk3MWLlXuzSVJHS+QZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 01:10:55AM +0000, Jaegeuk Kim wrote:
> Background
> ----------
> The primary use case is accelerating AI model loading, which demands
> exceptionally high sequential read speeds. In our benchmarks on embedded
> systems:
>  - Using high-order page allocations allows the system to saturate the
>    Universal Flash Storage (UFS) bandwidth, reaching 4 GB/s even at
>    medium-to-low CPU frequencies.
>  - In contrast, standard small folios cap performance at 2 GB/s.

So you're interested in optimizing the I/O speeds.  And apparenty, on
your hardware, the UFS controller has limits on scatter-gather entries
--- UFS seems to call this Physical Region Description (PRD) table
entries.  Per Gemini:

    1. PRD Segment & Length Limits
	
	Maximum PRD Entries: Hardware limits typically cap the number
	    of PRD entries (or segments) to 255 or 256 per transfer
	    request.
	
	Maximum Transfer Length: Each individual PRD entry typically
	    allows a maximum transfer size of (65,535 bytes) per segment.

    2. Host Controller Hardware Limits (UFSHCI)
    
	Transfer Queue Depth: A UFS controller supports a predefined
	    number of outstanding task request entries. This is often
	    hard-capped at 32 concurrent transfer requests (slots) by the
	    doorbell register array.
	
	Descriptor Pre-fetch: Some UFS host controllers are
	   pre-configured to pre-fetch multiple PRD entries sequentially
	   before requiring main memory reads.

Is this an accurate description of the limits that you are trying to
work with?  How much data are you trying to read?  Looking at Gemma 4
models, E2B is about 10GB or 3GB for the 4-bit quantized version.  E4B
is 15GB, or 5GB for the 4-bit quantized version.  Is that about right?

It seems... surprising that the additional I/O operations are actually
throttloing UFS device bandwidth by 2x (4GB/s vs 2GB/s).  Have you dug
into why this is happening, and whether there is anything that can be
optimized below the file system?

> Problem Statement
> -----------------
> High-order pages become heavily fragmented and scarce shortly after
> device boot.  We cannot afford to deplete these limited resources on
> default filesystem operations using large folios. Instead, we need a
> mechanism to strictly prioritize and reserve high-order allocations
> for specific, critical payloads—specifically, large AI model files.

There's a fundamental assumption here, which is that the only use of
high order pages is the page cache.  This doesn't take into account
anonymous pages used by programs that isn't backed by files.  Nor does
it take into account kernel memory allocations.

But that being said, you seem to be assuming that you can reduce the
pressure on high order pages by only using large folios for these AI
model files.

But the problem with using small folios is that if you want to
actually *use* the memory, unless you want to segment out the memory
so it can't be used for anything other than the AI models (e.g., by
using somthing like hugetlbfs) it's just going to break up the memory
into smaller folios.  So that's not actually going to *help* in actual
real life use cases.  It might help for your artificial benchmarks /
experiments, but in the real life case where Android applications are
running and fragmenting all of the device memory, the large folios
won't be available *anyway*.

> 
> Q: Why is deregistering the inode number linked to inode deletion?
> A: We need the high-order allocation hint to persist even if the inode is
>  temporarily evicted from the VFS cache. To achieve this, we maintain a tracking
>  list of hinted inode numbers. When a file is permanently deleted, its hint
>  becomes obsolete, requiring us to deregister it from the list to prevent memory
>  leaks or identifier reuse conflicts.

Assuming that the high-order allocation hint is a good thing, why not
just make it persistent?  e.g., just a *real* extended attribute
(which is more wateful of space), or grab a flag in the on-disk f2fs
inode?  Then you don't need to have an in-memory list of hinted
inodes; instead, you can just have the Android package manager set
that flag indicating that you want that special treatment.  This is
all assuming that we need an explicit hint, though....

> Massive AI model loading is a long-term architectural
> paradigm. Providing a targeted VFS/filesystem hint to optimize read
> bandwidth for specific large datasets is a highly practical,
> repeatable pattern that addresses a systemic bottleneck in embedded
> AI deployments.

It's really too bad you didn't propose this as a LSF/MM topic, and
presented this at a session at Zagreb two weeks ago.  That would have
been a much more upstream-friendly way of collaborating, and it might
have allowed the mm experts to give you some more dynamic, real-time
feedback.

Cheers,

					- Ted

