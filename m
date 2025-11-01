Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DD7CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 04:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F618E0079; Sat,  1 Nov 2025 00:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107C38E0068; Sat,  1 Nov 2025 00:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C218E0079; Sat,  1 Nov 2025 00:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2DC98E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:17:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42B60140720
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 04:17:54 +0000 (UTC)
X-FDA: 84060730068.13.E35E151
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 80C3F40006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 04:17:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tfOETtR1;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761970672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6SkfV/86eW9rmLS74bOWIDEsW+0DwWzI80P5ZTiKyY=;
	b=jxHWp+9XgkLIMVLebRAAakOKMoP8Rh3L76gYq41z3/D6/gdz8oel5iMncGOwkAHqhHI4UY
	f7kgqcQI4Pb9tBPXO90SL9kLyGPl8C/tnIwpEgzm3fYbKJF+/71yx8MqBYGUxINQcrSFbI
	W0pQjTrlRqa+ySuVYejT4ixCOjt1RNU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tfOETtR1;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761970672; a=rsa-sha256;
	cv=none;
	b=xLbTNCtY0R4FSYW4QBrZZvgcOO/c8rwE7XN/NJnYi/neFA2AY32o8s4mM0k4hBLJ580ziY
	Twqu3q5awg3J2txiwohqTPtKtOag0RNjOOrkf1I8XNlTJ3WmNi9hwJlxHhDUVWl3SHPJZ8
	IUxZKXmZ4aNKNWW08C8QlkgO/NFin5I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 476D34350A;
	Sat,  1 Nov 2025 04:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F082C4CEF1;
	Sat,  1 Nov 2025 04:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761970671;
	bh=NLL5ea2GwmpaOiH9MtZNsnU7K+1o4iuMC+0AO7ylnmw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tfOETtR1sXcY6EhAa2YKEqAJKZGK3QYaHCgEs/S4mQ7CY8b8+TerJy7pHNrXau1yl
	 9JQE1HslJhp14A8NfUPLGV6YOhOXJUaQeUkt45vBXU/g51NiO2h+IEu4xAwcj2LunE
	 FeYE9LbWGV2HGdv5ndvvOFTVdz+qGyZS9ZgTwuQM=
Date: Fri, 31 Oct 2025 21:17:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, David Hildenbrand
 <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-Id: <20251031211749.e8729676c0ca40c8d6b95166@linux-foundation.org>
In-Reply-To: <9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
References: <20251027115636.82382-1-kirill@shutemov.name>
	<20251027115636.82382-2-kirill@shutemov.name>
	<20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org>
	<hw5hjbmt65aefgfz5cqsodpduvlkc6fmlbmwemvoknuehhgml2@orbho2mz52sv>
	<9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9yixdycyap9n9wjfgmjg8aeroydo33so
X-Rspamd-Queue-Id: 80C3F40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761970672-560483
X-HE-Meta: U2FsdGVkX18uBLgTSsBsG/320/u2stjeQ3w3GduyIqJ964q3kt14vOkIKkK03QyX910EvWkKO7I7mopPdEMPMZrFR3T/CV3xUPm02GCy9dMINb+Ev6yjs2QqxTIxuzCp2F4zuZqKi7UirB/Ip9ztpH+h4mxjONbhlDH4qPWrAANFFQQ0Z1ZXhEjBDpQYxWUs7ksFLO5/gSUs1VNg+Ye8XcPZTsgTBME1z2Aac1diM+af6S0tHeUhUDTyTuevgIxPLea2Mrvf1sII0mc9JJXV9Kic0F82eS0yCUdyXT8niCNrCeNU28hs9tXD+HsaAi7CKKf+u8p5EIWQ1Hbp3BezXGaHRK/u3ERkjtxE+YEYRixlXSpzcj7m0Pze70an2uV6fjHCT2g+d1PLRaFA5XSp72pB1Eg74hxDGiY6ipjkTFGJpZE5ANwYIha0vrKHpaGiL9ATKBniPIN8dBNPUVT2qD52in+6EoWHcXdLhWnQQ63r10W/VkN3a5DM2tKopVeJN27GDYMsiIAPaV+c5ZYWF0rFDjxPU5ouilhJTNPKZf78OQNdIs7HybQ4nTZlvhUW1BTCHV7ygBsKPbLEEOlisYS2Gn5PzSGyt+MQRrGkRmH5loLLfbWGBd0wLB4WhGNybUcLw7WZb63NhhJrqOHA8tYNAAPC+BZMMJSxTzZ6kHtpV8WnGm5j65qxQSeFw9d93TGoH7ZLCVpdZwImiCJJZbKIYh1Nfbya1JZDc3WFMnOSbP3JDM5lzmdzHrnPLragdNlEH6FZw/n0RBPZ4diFIdGn0WnbqBwliBm/Mu9wI0ah0rJuLDZuglPYxfu/Ps0kd+oB8mdqVEK7WKJi2fL8zVUkABPaYvIdyiLN3pxHbZE0hpEtCOEDM86ErsJ9qAOhpOlB9otfrhANBzjcacmu3T9/qKUTZ35/s4h99rhbB86i145iEVl+7XPELOaRTOE6yc6m/BqpjTaaZDJBWN+
 4qjQD68n
 pFbIEmHSW8rzYRJWh9t3x8q4gPAQChrJFX0GW01Ba3H1EsikeTr8zQ2GCH2vR8Wbg9T3kdX0U3F23Qhkw/nfK8ZwYww5/4oWuT1IDr7IVqP3AfJj4IleWejIzMk/jzZFVLe5TB4QzmG9gZa1PaqyjV76P795grD8+cc0npPMkkK/V0AB1BYjpEd0NL8vJbOuc5V2PJwk3xGLMAGnhVItDfOW6FXQZ0r2BCmdnkeD2rkyvlE+GouMwGnR5y09ncabrwQ/ccDrTpFnvNszPYxj1uLEsSqagDuaVYtlvRYzvgnThADLujmqMmRks6txu19wwBaRc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 02:45:52 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> > Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
> 
> I agree that's the right Fixee for 2/2: the one which introduced
> splitting a large folio to non-shmem filesystems in 5.17.
> 
> But you're giving yourself too hard a time of backporting with your
> 5.10 Fixee 01c70267053d for 1/2: the only filesystem which set the
> flag then was tmpfs, which you're now excepting.  The flag got
> renamed later (in 5.16) and then in 5.17 at last there was another
> filesystem to set it.  So, this 1/2 would be
> 
> Fixes: 6795801366da ("xfs: Support large folios")

I updated the changelog in mm.git's copy of this patch, thanks.

