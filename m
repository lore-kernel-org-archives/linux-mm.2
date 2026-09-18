Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 842BBC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B106B0096; Fri, 18 Sep 2026 11:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B5C6B0098; Fri, 18 Sep 2026 11:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743FE6B0099; Fri, 18 Sep 2026 11:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD3B6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:53:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FD42C0686
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:53:56 +0000 (UTC)
X-FDA: 85227328872.28.F14FD43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id F2F471C0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:53:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIEriSXV;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789746835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbVpbtgdB6gGZcR4lzgAB3myFCTkj71uHlYAh1fjtFc=;
	b=oe2Nxbjn9Gvh5aEC8ibB5XC5o6zFdwOC3IxAggqwCiKJpF5VtjS0mfZCQ1x5f8zAPiuf1D
	pMFZFeWqAz3MBlfmu3TKfZEOsZRysAShvvb9fUxOoUPn6HPSO9G7wr1zSRe51qVmL9JTNg
	ttVoP1+aVv6eGQK6WjOYlieplZB90mw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIEriSXV;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789746835;
	b=HudwvNZlp020GSNYws82hmZTgtcli18k64ypwDakdmTTIcIvyw/xxPiLCXS9NSsAX6HFMS
	xblngdf2h59VUu+t3pnX5J4XCevVcZlCDtRTNe2Vhi5rGNvn5Zcs4W9oqrUGTqygvTRiRi
	RWD7L8CSLZdna8hK+8jVUflFbQDr3O0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89B246022B;
	Fri, 18 Sep 2026 15:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5BA1F000FF;
	Fri, 18 Sep 2026 15:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746834;
	bh=lbVpbtgdB6gGZcR4lzgAB3myFCTkj71uHlYAh1fjtFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IIEriSXVzQQIbmH/FW5DBcrqsy76Yaczc0C0Ik4WHYjVQnzytaQllHxVnCbSmc/wf
	 3ip1FhCfubcWvgEFGaFqhoSBjDlBrbvhIHU25A/1RM1nk2BmIm70/Hxw8/S+DydAV0
	 3SGFaiA3XRt4FWTK9+c0V8lv5q/l4wftpnHooY14rs1ubyLM6hw2/hfF2VKKSwVh1e
	 FhOV+8MyczBeZB8UNCkeyseDoJ5Ct12tMLHGuGVDnY5b3vFJgGhlAZihGM0UyCgXsG
	 35aKDXN/yNndhmB4yIr2PssE15X1XCIQ3h0rbbmm3vNlaIAaUfJsNDydr5HXuEh6Xe
	 SOp7bD+QGVffA==
Date: Fri, 18 Sep 2026 16:53:52 +0100
From: Harry Yoo <harry@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	sashiko-reviews@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.or, 
	Borislav Petkov <bp@alien8.de>, Danilo Krummrich <dakr@kernel.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, x86@kernel.org, kas@kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, "Rafael J. Wysocki" <rafael@kernel.org>, shakeel.butt@linux.dev, 
	Johannes Weiner <hannes@cmpxchg.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rmikey@meta.com, kernel-team@meta.com, driver-core@lists.linux.dev, 
	riel@surriel.com
Subject: Re: [PATCH v5 6/9] mm/memory-failure: efi: answer whether a range is
 poisoned
Message-ID: <aq1eWgGenthqMNd7@thinkstation>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
 <20260915134535.C3FC91F00899@smtp.kernel.org>
 <edafd246-0bd8-4335-9037-77f552968b56@kernel.org>
 <aq1Xr4b7BXZForCe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1Xr4b7BXZForCe@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2F471C0009
X-Stat-Signature: j7j9tpgtmfpzunrm4ekcjbpktsg5k9a4
X-Rspam-User: 
X-HE-Tag: 1789746834-241133
X-HE-Meta: U2FsdGVkX1/MLR2Mn0n5y+70CdACMH+6fpRMdhK4epzWfd9HQ//qCPMgdqUhIexHcJcW9MgEnQCtJ1QDJRq4VsPkjBYyO8LrDDSBOpVWYBvNN4u++8f4iuH3nwc8g/XIp5bg5e5+MvnNHhyklYDZV1h/R1ICmqrXaXhEnwk/k06J6vpFc47WgEXogl6ptq2OUD+EDdALTVqUhVFjob7sTPip9/M74pXoLqN4nkMggmLJba8GLg6fQIcpJsUYMtQPD11MAq+ycnWxY5mAj979z/VPJBvaD0ufetTcMhDeKPpUkgLtXAWwOfuSmaDKCuwGyGAA/fK/Fbe7Z+5V43FAm6bZvKPdTPjZlaBcFkACV7Y+joLBzN0szerp9lwARcCpvDB4UTnk2c0iVPjglQOeU1gKS/loH/mf2tdlPT5Xrm5RlqG1TAvUbkGZLV3t2rYnqFuTMbzjVniW8vhWPWd7ThpSyQujfY7XVIOCUjC/z3vL8G0sbQJHWXy2lKvmhwOiIJhW6LNkH5NdT6zKf1iqzW0Nl5dvbHQPUShWbgHwywQ2sO2pq7G0RitGOKtl2PfCVwa19xkVJae9XDQ/VPaXrvPLmRI7UKOgSWEZOC+JsGw1ZfTNf46IbC4GMrpVlEKRN3bsWPS2mA+/GMnmH0iT8qaOnefUV5DRJWf7L+EdFgeJFmEyAIK1ZbErVBsbT4t2va3TxKaYXJbWlJDcFpI2sgW7HQoX6cy0jsuW/DHwkJNdFHE3qlcswV/cG4GLKpWnPSQvzBgRCaGzqyIN7vaf1MpPsg/OFS7FMLyM+3Djs5WJ1mzCWR8tZqe3wK7DMhCRLkrfJx6hRH1sLv4E+gDdqGnwQE7ta5gk+XGula476+3aja0MRwck/8k5CbXDFBQfMmhR99V8nQULUla2drvTnNvLTC2UAcvhITGQc31DN0boBOZ7Efn8/JCgpdzUGdbRiDpb74bB0zlotV1/948
 mF3DpdIT
 hcmQHi0JP6mTY1vpxxmqJB1qlc4wWEpZTIqppWYcu0eU64j3/dJ+PE8C0AGxBLnm7No3k4QkqH+gu3yG6RMwluy1Oh1Bc1DOAjZh8TyDg3/jfyrz4nRtlzzqXlU/T82iH5l0/cMBlp/KS/t8HVD+K1kW4xpoVenYN3X8/6Gb1ERsbJLRCShRj0tatUJTt2KjKkUV/ALPeBFajcT/RICHmmoIIJQMrSPk7ZByQ5d9SUrvFQDNleByau/Um70iIsjApsAaYRzY9yVmNRKxk7qX0gDUj2NZwdJTTNYe8GU2PvGWC0uvPYjxlmI74avz5FNECAddaXtbIbzZahUrZQHRwr5Swg5gCkfqj014jllZXN1mVqiz/Zn2HBf1iwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 08:27:40AM -0700, Breno Leitao wrote:
> On Wed, Sep 16, 2026 at 08:44:30AM +0200, David Hildenbrand (Arm) wrote:
> > On 9/15/26 15:45, sashiko-bot@kernel.org wrote:
> > >> The bitmap an earlier kernel filled in gets in this one through EFI,
> > >> but nothing reads it back yet.
> > >>
> > >> Introduce range_contains_poisoned_memory(), which the page allocator
> > >> will use to ask about a block before handing it out.
> > >>
> > >> Signed-off-by: Breno Leitao <leitao@debian.org>
> > >
> > > Sashiko has reviewed this patch and found no issues. It looks great!
> > >
> >
> > David has reviewed this mail and it annoyed him.
> 
> Breno is curious what annoyed David here.

Harry assumed David was annoyed by Sashiko replying with
every 'LGTM' email :-)

-- 
Cheers,
Harry / Hyeonggon

