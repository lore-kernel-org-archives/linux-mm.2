Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E4AE8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 16:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073306B0005; Fri,  3 Apr 2026 12:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0237B6B0088; Fri,  3 Apr 2026 12:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54F36B008A; Fri,  3 Apr 2026 12:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D03CE6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 12:33:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 684BF160330
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 16:33:52 +0000 (UTC)
X-FDA: 84617791104.03.9D25C65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CD670180010
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 16:33:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wk6NCwYo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775234031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2pVAMkYvBsMbODmffK3psbr/BMeoaqe76EnLK9627Y=;
	b=U8+7KoyXvIYXevg/WQu51gWIsiF2fNQOMaf8WZly5FcGIkV7mOLR5P/VKUgiV6l4vETg8x
	mECo9YeHJ5tZIGCxo6wWP+a1Y9afcnoo3okOEd+95MQIMF0FiUqJlK7g5Df+YHkXipzuYd
	n67UvwyrcFufyk5Vc0SHoTx9zNW3UAc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wk6NCwYo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775234031; a=rsa-sha256;
	cv=none;
	b=GbJzrgvuf8spXUffSXOldjRJASI7NJxsZ33963wIyxy4BqgguP29bzWiIWdKNQJ6vFRsSe
	3EME5mUhtynWz5d8DhUpU2u7q/wEbKLf+TtlLjqZ5J7sh6r5L9MiNmQsc1Wf3i/j12/NzK
	0GBIXNk/Sfe+v4ncBpiottwwbEKrjHI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A551040DC0;
	Fri,  3 Apr 2026 16:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D5FC4CEF7;
	Fri,  3 Apr 2026 16:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775234029;
	bh=DS1Rt+7ONewCuR31rtB5/QdLFjYL/Z2H40VVah6e25Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wk6NCwYoQvDNWYEukm9ThqnRpRt7NMzTpGqTFB/IbvsedOs2jpsGOt9+lFfnlyxUI
	 qfhEuwehnZwRQVAJwpwQ1q2KehxaU2jSTdBwLFr/L/qyqIB9EzEYx8LVkyq1tKZ3Zi
	 s+1Oh+oRLdr0mRx13W+gP+ZXx4BU65LpACuKUx5/JGFiPa+dGwI7E5EHdYOzBVBmy7
	 z2wZnKcN3gsJhJZZuJ6mPwEUX3j9XlBdBu2D8+U33RuE12A6bPXoXnxKguV879aqXx
	 s47FrKVyrCxBAX9brlDtPvEKQSu0f67Qf2UiznHzpwTdkCd9kN0X3FG08SIv+ZMHgs
	 Q7ZtVYms6FABw==
Date: Fri, 3 Apr 2026 17:33:44 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/selftests: add merge test for partial
 msealed range
Message-ID: <ac_rv-D7ELXdx7Vj@lucifer>
References: <20260331073627.50010-1-ljs@kernel.org>
 <ac_mCIUQWRAbuH8F@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac_mCIUQWRAbuH8F@kernel.org>
X-Rspam-User: 
X-Stat-Signature: jsygrmaqfjkw36j4jsa459n5hiymtzo3
X-Rspamd-Queue-Id: CD670180010
X-Rspamd-Server: rspam09
X-HE-Tag: 1775234030-772794
X-HE-Meta: U2FsdGVkX1/7F1pGTe5K0+QKFsWdBSk7EwS2/xcOF6XUn4koDA88n56JDtBNagpswzRpXad2Ew6t8pwO79igPF2yADk2MCQ/0lTMy76uI3NBzKqjV0V0yAuFapnDtQHCOQdPsoBTtlZMp2dHaNzOwyz8NPR+B8cFFEHCHN/72mb8L2NptKnC1NWR9ib1yZS4257f/t2dMU855Mcg9O5h0zl8lkFscHH0Lf4wm479aKOZkDPJpvat6DNdMWihiiL2bAoo2ugP87810Ht2ugeAtvYX1YdQWjCyVmlZMTTIOAXHTTJ6aPY6SLWI3XMZnw2ftMgPjphuEfkxsqTA5rE/OJjVeLokE1pn/m1zOqVEUlq2XLkOnVu+dCVju5GqaawGXkE+HfR7m2wpPcGlp+uh4AvoqEqlzkG/LZBgjf+MmifR3iVTGc7GZXlnpjS6fvMxr4erkY46M+RPoazv/vx6bEVcJ6KX088zk+/9CoVp/bxowAZahAe+jjPq1fSmZrVjA2qxrqphR1Vr21330U7nEVUlUznJ4fAWYiRUORBqmYwglsEIdw7mpdG6tQSHL3dKRu90xwoWc+mGefsAy7Kshw17BPMwrrA4slZI0/BUugxy0p8rOPPUfKERIN/MJlelowxExEsAqDSl/XXV1JSWaaCq6M9tE6B0eIHK66qHoxOrNo0CNkCJ/0qfEJ/PK9qpstvLxSMQIio0Zf+Bwp3rEe3RXLc9VGMzDTbzXEh2YCYSPijyM7xhTcetVLecqwXpBVrOoVVa8NyT7gmcvfJIPdvSIZtgv0unKHwlHbgzrasgTdY+vfUydX6E67g9+4fH1Y2Hx6CF53MgScH3nwE/eKO8CAyoiKFOkBigkJjzFe3g/2E34hTY7pIhHmlHBH89Ut9P41p1TwJY0rpzjMlqpgQ9kLDZy+wuWeQgb/YoOqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 07:08:40PM +0300, Mike Rapoport wrote:
> On Tue, Mar 31, 2026 at 08:36:27AM +0100, Lorenzo Stoakes (Oracle) wrote:
> > Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
> > an issue in the loop which iterates through VMAs applying mseal, which was
> > triggered by mseal()'ing a range of VMAs where the second was mseal()'d and
> > the first mergeable with it, once mseal()'d.
> >
> > Add a regression test to assert that this behaviour is correct. We place it
> > in the merge selftests as this is strictly an issue with merging (via a
> > vma_modify() invocation).
> >
> > It also assert that mseal()'d ranges are correctly merged as you'd expect.
> >
> > The test is implemented such that it is skipped if mseal() is not
> > available on the system.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> > v2:
> > * Added tools/ based header so __NR_mseal should always be available.
> > * However, for completeness, also check to see if defined, and assume ENOSYS if
> >   not.
> > * Thanks to Mike for reporting issues in his build on this test!
>
> Unfortunately it's not the only one :)

Ugh...

>
> The header inclusion actually causes handle_uprobe_upon_merged_vma() to
> fail because of mismatch in definition of__NR_perf_event_open in
> <asm-generic/unistd.h> and the correct definition from
> /usr/include/unistd.h
>
> With the patch below handle_uprobe_upon_merged_vma() passes again and I
> think it's not needed for mseal tests as well.


>
> diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
> index efcb100fd865..519e5ac02db7 100644
> --- a/tools/testing/selftests/mm/merge.c
> +++ b/tools/testing/selftests/mm/merge.c
> @@ -2,7 +2,6 @@
>
>  #define _GNU_SOURCE
>  #include "kselftest_harness.h"
> -#include <asm-generic/unistd.h>
>  #include <linux/prctl.h>
>  #include <fcntl.h>
>  #include <stdio.h>
>

Andrew - could you apply this two please? I can respin if needed.

Cheers, Lorenzo

