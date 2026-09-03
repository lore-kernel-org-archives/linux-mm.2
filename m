Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82AB3C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1636B00B5; Thu,  3 Sep 2026 05:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B92C6B00B6; Thu,  3 Sep 2026 05:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D09E6B00B7; Thu,  3 Sep 2026 05:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6830F6B00B5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:17:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E0A71A0445
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:17:16 +0000 (UTC)
X-FDA: 85171897272.01.2667DAB
Received: from mta1.migadu.com (out-103.mta1.migadu.com [95.215.58.103])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7EF2160003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:17:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F5LwbcdB;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.103 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427034;
	b=B/cRU66DdtI/3IB9WxOrNMujMaaKnwW3d0BD1V8f0w12tkoli9bVj574JRJEUcOIbNHYSm
	cOFiLRygpy5lCmP5BdOnQ2TlMLmEoKznQzViggIURDJ3p7x+quRfhDo1VRSJ2GP8XCtkOU
	JXhqyTbEwMIR3B+g5XIg4nSfAUY6dUY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F5LwbcdB;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.103 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cbsZLCQRZEI+70S4EUo6CbbgzHeFHucS3IcC97mP4o=;
	b=cmkOAMhYpSCVNokgW4mzMuvcEVdQngM4ELwIwr3jHR3709czK38lsxxey6pt97W+tAAKNA
	Zf1n3TyA8VMWpsWmMSJinDJvSMpDDWrfZroG/SXisUbFGN7SIDIHwcQ1yX0g1Zw8IS1Zi3
	HUd5l4svqCpnqnHHqmx51JlTkPy3h98=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gZ6TEKe+uz2mOa4JtXWVQU/xuG2dYvVMCUpJ1gBLUnY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788427032; v=1; x=1789031832;
 b=F5LwbcdBRBmgoZD6y2ZmY0NxZrvr6tm8II9tejWY7TRqpneH7a3NFB4+2hLlfs/gIq75DlHC
 KO1F6l6dhwjw6mZ9Jq2VRAhx9JJmIyKQOZt5EgxZk3jNq+1dOphpy97/2FjyARvW72wFSNE+tnM
 yDCwfnJ7f1szxUew32+ce45U=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2edda1273ec6a1c8;
	Thu, 03 Sep 2026 09:17:12 +0000
X-Mizu-Trace-ID: 2edda1273ec6a1c8
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 17:17:00 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	baohua@kernel.org, youngjun.park@lge.com, hannes@cmpxchg.org,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/16] mm, swap: defer xswap shrink to workqueue to avoid
 lock recursion
Message-ID: <apk7DG-QRHMCwRDL@fedora>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <20260827094509.1016740-14-hebaoquan@kylinos.cn>
 <CAKEwX=Ovm9DTLE_8E-dQ_47SVrOQBY0hLbF7vS9MpDy2bUThCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=Ovm9DTLE_8E-dQ_47SVrOQBY0hLbF7vS9MpDy2bUThCA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D7EF2160003
X-Stat-Signature: zkn8k4dwnt6zcz5e9bb68ag5mpcjr8u8
X-HE-Tag: 1788427033-886647
X-HE-Meta: U2FsdGVkX1//iUHdX0W0ybFybZKqALVwkefpmKjePcVJIHIJpNj/CZyjFzKheAz5vtgsUjC7dnrRK4UBBiZ1dfvC55qJmU2bX5UMfp2ngEQFWCaaPSeBUqeU7BvHc1VbY5p/ns/12zET4K7VHFGHRxMDt/FdRiIlTglZwCgBLOJwQVbxiP9CS0RKCHyONLKiMTYz96P8RJnUxH7k5Q1/gjs8DIShgevNmMWvJ3ApOiC0L2VvsB+od9ownRnGwcT3bvgJ4jp2c4ZOEhrg1OEqvJWJqPaOQeSppRJUiX+n1j42hPiqIpyWR6t0IkkkUK0oLM9qqhk7cLIFfGk5lvPMv7+kArmEPf82CBHT5GMQgSjtVcMLrZGnI0L2iqVvfcmvhBBnUUWUMCynoNbTJbGKSejBVkDsHMcWIIj7zPAwE99TAFLSUJ6RUgd4vVfW+TkU0MExfonI2ka7wDWKMK+ZneLpfPR0VRUX5bVKPxmxpgFI7VN27IGyPIZ25sym8IGFspE+ZZgGe4na47pvc3HLCTuVw2ntcS0uGKhAsfcJLz4erEFaU7VuhfUBlE4sTA/i5CgD4GdnV03kJZI9j8p2c0XtFXZc9B3IVuSHLc+BxNCGtG/eKpMMIn83nvds5sYV4RYlaWSYI3nndhFDD16GR6aiLV4o4ZTOLoQ1WlrTV8Ylgg3ZbbvnJqw6wfJj5rR9KnNCqOQvPnhEbQFPjXcFiIcTdZp3DTEvPGS/b921gAqoGwKmOrB+YGw3U+DnW2Z0/iYItKKchUvpT52q8pWsCPDCNVtnvtbwhfnkdpjGF0nlmICW+lvoS0yxL8JBjI5JtC2fNlHXBaCu2y+Y+YvApbSaIYNMOXclvKyUUnGQAKiDg5BLoTc8rUMXNhnwWU4fPfNcWLcnt32qiSoq/3fvd5ww9NkZVvMiHDMWFUZUeqCSJUj/X6wTwaWRprpG9LMFxiki6GC6Apr6cnU2a0z
 e5mEKiIR
 9iuul4T/sGIK6MbZucH6Fd7kZhfBQyll7JyjZuUvQEvnf921cyHUp+w4BWeUVC3kgKOS3rwIkMAGsO3Nze79zicUZ1Bbku9FPW39STFHa3c0UIYG+qDtU1a/OCoh6Q4oHiNbb984B3W3YpiNb+tfeSIkzmWEs9qGsGKzpAB/TvmLzad17WpWo+vJMg1UDSnMQkhyWE89mLAsy5ePeD9Q0WCgwHe/LH9v2Bp339L/jmHYAT10XgO2F6xwtCqvWO/purKFHXOwMosekSX95DfIl6bJL9gOSIiJLQUDcuOUO3YsLHNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 10:50am, Nhat Pham wrote:
> On Thu, Aug 27, 2026 at 5:57 AM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > xswap_try_shrink() was called directly from __free_cluster() while
> > holding ci->lock.  The shrink path calls xswap_unmap_clusters()
> > which unmaps vmalloc pages backing cluster_info, and on return
> > swap_cache_del_folio() tries swap_cluster_unlock(ci) on the now-
> > unmapped address - crashing on a not-present page.
> 
> This reads like a bug. It would be a bisectability problem to not
> squash this to an earlier patch, no?

I intentionally keep it as an independent patch. This is a new feature,
we don't need to worry about bisectability problem. Mainly I want to
the code change explained clearer, any people can get it from the git log.
If I squash all them into one commit, it's very hard to let people know
which paragraph describes what change, esp the commit is big.

If it's a logic unit with a reason, I would separate it out as an
independent patch. People review it and ack if no objection, then go to
the next one. It's better than a big patch with which we reviewed one
round, this place is changed, next round, the other place is changed. 
Then next round, a new place mixed the 1st place is changed. We sometime
even don't know what is settled, what is not.


