Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09DC0C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 23:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E50E6B0088; Fri, 11 Sep 2026 19:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2DD6B008C; Fri, 11 Sep 2026 19:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA176B0092; Fri, 11 Sep 2026 19:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63E836B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:19:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A12D4A49EF
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:19:24 +0000 (UTC)
X-FDA: 85203049848.09.B99C3E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id EEAAF80005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:19:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=efyncMxM;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789168763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dCaD2vcbQEeBz2ghBZutu/cWiXceCvmimerL3kOqdI=;
	b=tNCFTe81bxEKJnRs1xX1pV0UYdCehyzNpwGHMV/maq/3n9LRSD9fHfVENfcJIp8DCrUb3j
	QLu91oqKk6JxAUCdcZbzEcgvDEQ1xYu3JElOGg4ER8EMUTS6e6A751STpvt1MZoiLHNuiQ
	8QKmzxt55qqZlIyaKp0rPDFuevj59WY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=efyncMxM;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789168763;
	b=kGcXwc/KVG+naXaY0dBZjR+NJoLYHmPG7mAcd+qLLJLLOZOI2fpCTThUByuhjuETpecizP
	M+HxzrkbQT5Pycjwu61LxjfPx3LCNB4uBX5wbDU6s1PCwY3zdq7/h7qvuD/PdkvV3y6yOn
	3FmXo5EX8Hl1iMVkblZQfftPZjaE7q8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D257600AA;
	Fri, 11 Sep 2026 23:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA421F000FF;
	Fri, 11 Sep 2026 23:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789168761;
	bh=2dCaD2vcbQEeBz2ghBZutu/cWiXceCvmimerL3kOqdI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=efyncMxMVA2gZzm7iQT0ijkIkYkV4JhN0RbqG68ZR7QV9Rm0avxF++ne4Q26ICSlu
	 GoJa42aS4qGzV2f5NkWGKw4VWQZPoILKksVe/o0qyBWJZZV5NqE5ewSY5MMNZEeRvg
	 Tq8N1mSNEYYisEk4YCeVWFn/JluVs4GHCl+nwMoo=
Date: Fri, 11 Sep 2026 16:19:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes
 <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/7] mm/damon: introduce probe_hits_wsum DAMOS core
 filter
Message-Id: <20260911161920.dab281d16d9fe9c0e3947404@linux-foundation.org>
In-Reply-To: <20260911135510.96914-1-sj@kernel.org>
References: <20260911135510.96914-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: omknpg8iu6hph7dn5j5dfudhooogy6za
X-Rspamd-Queue-Id: EEAAF80005
X-Rspamd-Server: rspam07
X-HE-Tag: 1789168762-757486
X-HE-Meta: U2FsdGVkX1/UbmHp1RW6DmVQxnZvSYyNAhvPjq9pYtC4ie+L9A7ogyThsUJimbrN15q9I8kG8XzX40gPmZXSG2T1AK6JriDi5TRhF4Xe5JdQfBPF2QKK/8JhdMnnrOqG6Smd3W9ItpGJj2At2vemygHaQSSoB/mLRGIX8E82OhOujsSU+7UVNR8HN6qWWbQGJi6XOGMlN770BxSeWHjW0VEXmj2GNpFQ/5piY3Zmi49wzrq5RuqoG/CY0Gez2ZIkKxHfVfkEvnibLKrdjFGY+A9/ASCR7YWVqVHpOCUcAMsye/9J42f2rG7Es6wCqpKC5v+RENICSvFJGEtswgniL39soRGqwNw/mSYJl5Z7RYtfVwZYHtA1E+ySJLRo3u1QGHIfR2gaW8iKZTj9R58y3rPMeQCDsv3vTJ/1mIZBxM3XzFHWeYEMd3UJX8xfHeTJqyIY66YRbSvHvIM7yD0QuHf26Q0aT9/bbKyj0/zvYE9xm6TmgyGCsxMQlKSA41MyX8kqhTLTWO5bW6KpCCP6RTX3ifzUPw9ahenO6MWIksiGDrJDyiNFGQfzYC/NBYaSqfBSg0dp7lEIoHbQdisH6JeDoe2LU5btD4HWhATE8+0Zf2OP+fe8uvsWMZdQvXfBSez37ahVoF+2B4Ynxv3MypUW4/wPcGGiD6pHFGXnjkLjGo/v/QIauYyrV3ssTH/wx4zfeawzLl+9dVshFePmLpQOy/5ZkHUNu/46MPyiczPxc0kjYq8v5q96yxP2JXGZzy0+FV4upsGnUjSIqV8uT6s7rbzQKtOcD6YwYYy/1G4r8+aoxOczwQ7wRRqZv+iakru1DfFMhYK2JXkSUs1VnYHst+Q4CPpsoSK07rsL46pk9pW+BbgZZz4rgg1bxFRnWd600AVachimZPWIq7Tgc6fWwvTh6mEqTzWEW9Sqkhi32MleS7+S6CtgR0iSlA9AIsq4OYRPSu3UvwyE8YW
 7VdXBD8c
 DNQntjnO88Eb4WGGsqWF81f8igxyqEo/wi/LWFlS4UT44AG+lN45JF8Aqf4uOOhNd1h/XmARTjdYSEGcmOwRSnVFTgc59HzEUQ/zJioBqJeV1oUWr9hKHjug6ml9A9m3GcnqqWUVCrc/pvziF7f+K+S2eHHsVsTAb2QyRhOc/FZE+liHqUKzWZOoEbLJlLKwKwYFGi3AIYFkCXx69rlCzS884A3tGlFQLq3Ejyekp8aFWnzARglFfqwofENepD2ohphXtjtJ0ap5l1IRR82dYao2se12LK5Hv/NbhIs1AqABqbXhJK+SzsJHCLVjY7dFMdg7g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 06:55:02 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON can do flexible data attributes monitoring.  The classical data
> access monitoring can also be done using the attributes monitoring.  The
> access event is just one of the data attributes that DAMON supports.
> Users do monitoring to make some actions based on it.  DAMOS is a
> feature for automating that.  However, DAMOS cannot utilize the data
> attributes monitoring results.  It is still Data "Access"
> Monitoring-based Operation Schemes.  It requires users to set the target
> "access" pattern.
> 
> DAMOS core filter is effectively the same as the target access pattern.
> It is just a more generalized and flexible way of describing the
> operation action target region.  Introduce a new DAMOS core filter type,
> probe_hits_wsum.  It specifies the filter target based on a range of the
> probe hits weighted sum.  Using this, users can apply DAMOS actions to
> regions of specific data attributes pattern.
> 
> Note that the classic target access pattern still works.  Hence the
> target nr_accesses range should still be properly configured.  The new
> filter would be used in only data attributes-only mode.  In the mode,
> classic access monitoring is just turned off, and therefore nr_accesses
> of regions are always zero.  Users could simply set the target
> nr_accesses range to include the zero nr_Accesses regions.

Thanks, added.  Along with your -fix for [1/7].

