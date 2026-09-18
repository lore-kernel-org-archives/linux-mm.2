Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4784C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15A16B008A; Thu, 17 Sep 2026 23:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC3B6B008C; Thu, 17 Sep 2026 23:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902E36B0092; Thu, 17 Sep 2026 23:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70E146B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:49:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB978A056B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:49:05 +0000 (UTC)
X-FDA: 85225502250.01.937CD73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 194FBC0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:49:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Gp+wsNqp;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4q08ERpIGjLGCf1CNdAlc+T9V2LICMNbsbDVrMf148=;
	b=qiRQDoTgrh3lSBTyLLckaqgEHgLB/WA7YSf4JoXNdBCn8T3p9BDG+Ax96l17+o7cIaLwmv
	1ZM+9x0bil7vtNl5RNaqx0nvWOdTeLW1J7N6zKRIDvyjxP84lEHjrlgmcjnfE6D5TQpEgJ
	208vctt4nIEk9rI+Q/B1ZsrLmrKsZP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703344;
	b=xXZB0vUKiZDSVLZxxHJEV5qVBv9z0I9mizTuNtuQGUg2HQc0gTZ8RH39kI9YQ/QEGigsab
	UizL3X/f2VCIsC1CEvjvwO1XIpzbRoeu9OL7yKdpXLG+fJ/eDwgpks6hCQsIKtJnEdArfC
	1ReqWpjsPTSoBCxMo+7fRGYglFg5Z7Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Gp+wsNqp;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7B17600AA;
	Fri, 18 Sep 2026 03:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3D21F000FF;
	Fri, 18 Sep 2026 03:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789703342;
	bh=R4q08ERpIGjLGCf1CNdAlc+T9V2LICMNbsbDVrMf148=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Gp+wsNqpXSHoQgyqaAiMkwFieo3u6guFDNRHvmB2pdaa7h4DoXupHH121rpO462Hp
	 4hT/7JdNNOOsujTnobpCQ061+0AHRj9EiwC7L+WL7b00jqY40azeolORSh7Pqyup35
	 /+x0IhbEDxQ8WgK9jgR28vSQFDR1GhOIDP+OuOMk=
Date: Thu, 17 Sep 2026 20:49:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Colin
 Ian King <colin.i.king@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Mina Almasry <almasrymina@google.com>, Mike Kravetz
 <mike.kravetz@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/hugetlb_cgroup: move the per-node usage along
 with the folio
Message-Id: <20260917204901.efd6e6908c85c104467fdeff@linux-foundation.org>
In-Reply-To: <20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn>
References: <20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: y3si8qefe1sdr3rkec977nktccsjryko
X-Rspamd-Queue-Id: 194FBC0004
X-HE-Tag: 1789703343-813967
X-HE-Meta: U2FsdGVkX1/pSkBJ8m2mUlgOE24d6HwCSznHk7C+lI/XukSxGJlnxxED3w1o+QYcl95JKxzX1AOzTIZaNyN6FtwaWQYL91H80JvTFpKdeRd7fTx1U6A1W8dMtLupFqkHxZZgLVTqbzB+77dGIxzYsDFspDwEYRaDPKxJM8kziyNyI1vRF/S5eSbZoCNZXUSNQoTtjTY1TyJ6JlbnGooFIzuVycGlJpQ2ic7F8ooAiUt29CmHvx9Klj/WwKMnAMwRMIhxmErWgT0QRWXZp0FttZDFXVWVUV+qTMCErFHgSrhqzIqnUUSE2pHeDvKiE2/o21hRhRd1AeUrnEPHsIbiXpCgBgZySicBBWDaptK8CIo/X3gBYs/amc2cOL0MisCb+plJalN5KH3XCfLqv1UPqzpuyLyAUOw9BAcbRTBut5fHA8+QTwn7SS34F8kEfR8Ymht38EoqWu3EvjuMAfHkZBuY1v+QEDFHuzWdkeVvAsLjF3cBJU/FJYx2KEGjsNKRSziYiiHH9qnQJrOsIBeyyZHLWKLZFiBNSWxoKoX3LI3Nnoge75fhpvSvuekgDuGVcFHIivCaGOpHJasuU7vVqbNFcw3sOCg7EmM6vvC11+Gs83DKpoOTk4barCFj8YEflozmsOE/sL6PafjaTgyvnQw0bmL47H8hN2bm1SaSTnzvkAhsVz4/GdA2oHz9bXOuu0cFtuPcRxyVQhsD7U0XWdrzL38v2x9inEnMBekUg8ctYskFoS/jqpltdB4I8CPXybtxFZVid2ZRjnKeMNzGBGVLkfIgK9x4PzJiWcNEEMRbm+S42dd+69+e49gFgiHqos49LJv8yfWixpMEhR1zXtJCaxvTWKGjiMg25Ai0qMzmrrLZTXOW8D9Flhqww05yEi7GbjHiczfCOtQlFc/mt54T6gP2jnuRaiZTGrOw3xaGkGd9nOfUKccTRF/A0RaCM7B3jhii3Wgo9FIuVve
 lz0o4bNs
 yAIS1Nzj/JVvp9dA2yEwSLn/zofeGmd0rNucKQ6iZQdBXiW38fx21N3Ml1V7uC8cZqEqAU9XR4nRtqnzWRcLfisTFUeHwfecryhYkaJ5RLbXtR3oz+XhyEBgAKnlg6oatPSCGZ5FkwsLSYS9UNk26oMl7Vs4l3zKdhykFVCslt2YP+dQ8OfHl5eTfRzZCTWFxw7Uk7rdAvgR8aRDBuguoyq2fBta3IPB2g2WaOah9nAnHY4ZSFTYIcETtPpAzaOMUC5KugErESMwqlNulPhsREOYugLiSMBQjQ+UoBEUpB3lPAit+n9Oh5FxPuQ8VG1vcYrrH7bjOvWJbK8Xjy62VkqNZ1UhdogeaRYW0fa3pXayZ+98fKpXafDxQW0SLe9DzSb0JpUhhzUPvHcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 10:56:09 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> The per-node usage reported by hugetlb.<size>.numa_stat is accounted
> against folio_nid() in __hugetlb_cgroup_commit_charge() and
> __hugetlb_cgroup_uncharge_folio(), so it is only correct while a folio
> stays charged on the same node and in the same hugetlb_cgroup.
> 
> Two paths move a folio which stays charged, and neither moves the usage
> with it. hugetlb_cgroup_migrate() only moves the hugetlb_cgroup pointers
> of a folio migrated to another node, and hugetlb_cgroup_move_parent()
> only moves the page_counter charges and the hugetlb_cgroup pointer of
> the folios of a dying cgroup. In both cases the node (or cgroup) which
> was charged keeps a usage which never goes away, while the node
> (or cgroup) which ends up uncharging the folio underflows as soon as
> the folio is freed.

Thanks.

> Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
> Cc: stable@vger.kernel.org

I'll queue these for the next merge window, with cc:stable.  I don't
see a hurry to fix a four year old bug.

