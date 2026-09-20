Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 579D5C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 20:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FF46B00DD; Sun, 20 Sep 2026 16:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7496B00DF; Sun, 20 Sep 2026 16:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D4E6B00E1; Sun, 20 Sep 2026 16:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E09BD6B00DD
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 16:04:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66B9D1A04F1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:04:37 +0000 (UTC)
X-FDA: 85235218194.10.AE511B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9BC7520009
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:04:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FDAO02Mx;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789934675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7lwH/Oayopk1bBErSILDmV08l5E3TMFEPmonG2OoWU=;
	b=uVFNMUjvnpHbmRwKKxv67NKSDpeal45GN3n2E4k4RoWPtUAVpacDQ7VAYNHzC34n0KAXBC
	krlDGpBenfmN4UzkK4a1vfu2/CfsGXU/gbrca/5+Eo5/fUSsv6JnBoODW1snCUIPYQw17+
	EYQi8oOcpkdiysnWwck7VcUpUaNGTpY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789934675;
	b=gaKdjeMIp1Iur11anHfP3mnXaleKMjpezSAzA50s7r953tYK7nElNhzlmcIi+2W9+OiMSt
	gauvucXwELpI7L1VUQftplMYKKN/aJRhmGw4LPVEMiGHp0nYN8k/e0+vSLvatLh8Q/qh7g
	f/1JaeygHKm+wWOGDXvD8vPY3laolu0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FDAO02Mx;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3535060E48;
	Sun, 20 Sep 2026 20:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FFD1F000FF;
	Sun, 20 Sep 2026 20:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789934673;
	bh=o7lwH/Oayopk1bBErSILDmV08l5E3TMFEPmonG2OoWU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FDAO02Mx0HtPRCxykwrJgCGrawrT62ethZkSD5daCtas+MWayyXsKOqrAWzJz7Axa
	 6EQLO39T6Ni5s3XCof88Rz9MRzs1kJhNr37Xx+nRCElWDvpV4tFMGRSnWP4R3VMSPG
	 07a8eUb8kI+owgL+H4a53NrGsc9z1qRfLTKGFM/s=
Date: Sun, 20 Sep 2026 13:04:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, kasong@tencent.com, bhe@redhat.com,
 chrisl@kernel.org, baohua@kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/shmem: don't release a swapin-error marker as a swap
 entry
Message-Id: <20260920130433.7c68761144a2a63e2ce32bb4@linux-foundation.org>
In-Reply-To: <20260920155002.1030454-1-devnexen@gmail.com>
References: <20260920155002.1030454-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ugyxk9f9b6k5fwpq746iyfedj9ycsawt
X-Rspamd-Queue-Id: 9BC7520009
X-HE-Tag: 1789934675-767919
X-HE-Meta: U2FsdGVkX1/+5XcUQMzMNqY/daIOa7+jeoyCD8+HdQoOLOWp0g3dxbgHPsc/uYvuGVWWrc14BoXotOER3TdWciT2FQSxMB4VWjIsja6MF+iL1TwiJGA3u1Al5uyu4m+rSR6MOHygoApUB8T7wYYQ3GGzh/s9147hJredVP9H1ZhJ85/6aShXXyzDCvENNzBqZukC4SuSSbBBcuVTrWMs63JqLlK3VmX2JjePFe/8zA4YXXFLxDTJpq2ezmW0iRJfsQcOI8ocMfPMr5Ww4rcO393UoSu1KdruekC08uk1bfZO762atjsWzVlNrdXyzpNHu7ev7exjSZ5t5zOe4oo+lI/H/nNnaeQVwTz1ZESxLHTG43uFKSnXJFP6Zgph6BDvM25iNVU0KMyTdEljCc7zVrFBLVZHMZ36meIsDudJwCyN61kWsBDFFRdB+3SN+fMo+Yoi8cWCm4jX/d3G1laiKLChjf37OaQka15Ex4Uro56sC2Jl6ipp8xwhXjr4yOTaP6DfNqBgxkAgRa7uqYsAWSwn0PZaNrR5OXGr910Py/m90B6/QqEcwtVWmM5jclxbjNf3doa+Zf4ApjqbznyGXhJl95uK1lyIjSIfeIvEBB9U3xZio+aihLuvVKKNuatOPSKUhtQ5Dt8zGQQ2ZAvexainOfQHQXpAdhk6LptWuGNWWytlfcEEA/E3wMyDUYGhj9friYb/Tv/omMhKIanUEZPZT4zmO+AvAYAV3NG/yRfX7kZoApdAe2RAAdjDGEqtHUFJ96p4O0HPzBQFeTgi3bd3jbiLRxvgCDzW9Hxl/NXHVL3ENysBGYvKZdWiG9zRHj81bRl7S/GK2bBEOB0eYBlbVOu4Y7L/2kzXNfg7QZO2jrpQxlJ0V8Pt1Cdi6jjs8fw75fI35xF3jHZgeg0pqCQ4Q3jQ1C2UWC0pvXol8a36ymGXiDS+hmus12fOxTLurftJMM6OoNGumrqpeB5
 KayWCrgR
 YStyI9vf1Axyj8BFqq3sad66g4bBJ72KeOCWWDQbfNW6F3qmvvbwWMINbFv6LwJNWSPkn1H5vkQO//GRNFiLtpRtUj97vve4b6KAcm7vRFRXo4ace/k+nCe6K9JnkweWXI0+isHIbttbBTFEotlQXUylURb7ZHXIryrufxC8mlt7CP3Jc6HEsatuy5cjLUXLefx36hZts9faMlKE81VhykjoEwOTQPLNbOoK04pM1PbkrvP/BTnOLShIEFB+TSJdXwbwCYsJ5GKRjHVVErsfYwi0aJ1gcKVsXz6Dkjt191avWt0jalPLW686orx4ZWV+/iRLMMylBgsz7YCXtaJhlwCYwb6j02wld/THDzszBasVkFI8DO+SqpkL9aEG14nn+QUbjAbmp2uBiuw3hqWaB6pecCb68ti9m9xR7Oh4oDopJZ1tY+21vH3Jvl5vLgSDTPSNcmfcHmq5IZJwuTZUFBBsQYA0DR+qrHP9CFemH6GMvYhumfsuhBw6Tvw48xXADhW0EiqqBh3nWrnEC6Ho3B07+K6STPu5BAjwymHwSwkVglrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 16:50:02 +0100 David Carlier <devnexen@gmail.com> wrote:

> A failed shmem swapin

from -EIO, for example.

> frees the swap slot and leaves a PTE_MARKER_POISONED
> entry in the page cache. On truncate or eviction shmem_free_swap() passes
> that marker to swap_put_entries_direct(), which warns because it is not a
> swap entry. There is nothing left to release either way.
> 
> Skip the release for non-swap entries, as every other caller already does.
> 
> Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
> Fixes: ac2d3268284b ("mm/swapfile.c: remove the unneeded checking")
> Signed-off-by: David Carlier <devnexen@gmail.com>

I guess we should backport - errors can happen and WARN can crash
machines.  What do others think?



