Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05940CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 01:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC626B008C; Tue, 26 May 2026 21:44:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3E96B0093; Tue, 26 May 2026 21:44:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5012B6B0096; Tue, 26 May 2026 21:44:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4015D6B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:44:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1913404BB
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:44:21 +0000 (UTC)
X-FDA: 84811504722.27.6789650
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 15D11C000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:44:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BhuCFQ9i;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779846260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YwMQK/K0YC5t/5LwYD8hgycOymIzyP/pOWdnzfaJDUY=;
	b=EG1crD9UPlwjCQDJJ0UUU8FFClc1HoDMdyD2i+uK41lG6CrpK66JwdGte3zdd9Mjk3oNlL
	RgIi/pakHY+ZDIyjzf6pRz17nKBMXgf04cZ0QcqeqqVSrxUbdRiMiEvfOOWFc0AWYF0qEM
	06K36fdqoYmJu9BPH/eNsOqmWnTDGPQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BhuCFQ9i;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779846260; a=rsa-sha256;
	cv=none;
	b=1Z9D+TmXUqkS85oMTl+SBkzDeSS/rHFVpmr2HlfUsDabdYAoNkpjfuuPrxnNM9M37stNKk
	0lay2mRgD6cNqUQcxl+FYc1Q722XtgBI/LaiYb5/jXw/AucUjTJ6EFsGxP8hVB6pvNPHCh
	Z4nKhV0C8Jemgd2GHK5WkKv2VewG0wE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21BAB43C12;
	Wed, 27 May 2026 01:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12211F000E9;
	Wed, 27 May 2026 01:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779846259;
	bh=YwMQK/K0YC5t/5LwYD8hgycOymIzyP/pOWdnzfaJDUY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BhuCFQ9i5RmTYcvz3+9UJKwbl9rmgW/uXmrXQKonSFXDpwnt78VzYXfK6sXWMQDvA
	 Y4Mxf+SGcRH09Jga7eYF96NTKSYVqxrVeRxmfCwFmAiDpC99kAbXharxaDWpAxgYEX
	 pflJ2eqx3w8XlmqyQ0o6jOYOwM++hWYQkWBnET4w=
Date: Tue, 26 May 2026 18:44:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Lance Yang
 <lance.yang@linux.dev>, david@kernel.org, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH 7.2 v10 1/2] mm/mmu_gather: prepare to skip redundant
 sync IPIs
Message-Id: <20260526184417.a4de7beb76bce85d7597b676@linux-foundation.org>
In-Reply-To: <f437455d-1598-483d-9dcf-1932d265ef3f@intel.com>
References: <20260424062528.71951-1-lance.yang@linux.dev>
	<20260424062528.71951-2-lance.yang@linux.dev>
	<20260424150454.GF3126523@noisy.programming.kicks-ass.net>
	<f437455d-1598-483d-9dcf-1932d265ef3f@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ocu6qzwd5k88taht9afwc78ent47i47c
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 15D11C000A
X-Rspam-User: 
X-HE-Tag: 1779846259-598410
X-HE-Meta: U2FsdGVkX18mSfaKSPbbeu1YM7z2wGmp6eWXSXoze/44IAnxsZV6S5r1kUPdlbExYSSdhShg15bkpBCMI4/nxpFSOYecy/Pc84klERn+bascgRVx5vBSF/Z6mV+qKG2kq8eco91urfjn6lPZCbQSca0/CtseMyGIrPExnXphUBFCnN/DKORhxUDMPyhFAuJmqnoOWfLUlOJdAHcwqK/OueNcbRmRHH9mLR0uBzbsm3Glb8JHFd8B0JR/V+zQumAZL4pyMTbtdPP/ZmjL8agKP3I+pL9fEcqOp27HPzdCA9zIK62o2V33u2F8bQr/q3IeZzLQhFHhhZh+2JRFmvq+6teP/LIHG45DrngG1+RYdlqPbUmNbPY2bkm47BTCm+WgpqzRJ8mGbTp7BPgfcKbx12pZUV7Vxni2wpXr6qgCt7GSocArTuoqkYxPksj/LvYuP+/37fdt8wqAVkgzWUJT9EIcL5cjok8FOn9v3+REhDKmJa6OXpq046co3Wj2Vx33T0e1rPfNgOd9ItEu22LyLj5OCdJEsfMkH/dOcfGl7pl3X/OJJ99kodELKWH9K6FxuYSm31ExmWI5DbFpuZXAoqfJt1gFiVPkH211agUV9/YDEMZmvmQKZAnHl8EzTay3rwF153RKbHB3uHj6+ASUo4+PflNYxXAAplkk8H9IZy9h5utSEOTMOiMU04Yl1WxErNeoYTaBtUZKhh8VyyE5t3dW49KcMjHvyP/xLvwyE3Txst8rnBJrNlms6iNM8IhkA+zSwFN6dHxwskl5oLPd0IoeSZjKQ6urwzAfakJJKKuarx1Bs3ooObEhpCYG5UJjofVVw/WomQbU3TLDM4fRnDw6E1DSvPPgO4te7P2lhhaYpn7UTCd4gQ5PobSBPjy8xDr+Y6HTHSDrdOVjpbzh7F8KagWWxg3pAANG2QSlR3IMElD7dLSXgcQpwdjrSs11kXo41C0ItusfWcBiUUh
 ILSU4KRt
 pKtwIbYaNCkRC5Vc1I3a9IvH4sDXIzbXYRczRDwSlE9csjotOGoEJ9IYU5OyllIjmgvvjkj1oM8MPJ6g7FBjGwbIjQqjWuVeZbDRJbrzOZcgfu5RvynNR3sWnsYop+t0vj1BEMuIXIDPUzToQTZbtsXad40LublhrkOROffmHkubEZzDrNoqiQQQRLbi4qHeXbKBs5YJn3dZN/gbaCPY+6s61Z7EcWgGvtuv4UxldmQ2mhuFBkf98mkhfUEwrTxQg4u/WDHGHXuZKH0kM1Y+Iv9qNZcB+ohmwzPdVleBqZ5bYTYkHhmbBNq+4ZUFXsy95toZL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 08:52:16 -0700 Dave Hansen <dave.hansen@intel.com> wrote:

> On 4/24/26 08:04, Peter Zijlstra wrote:
> > So I don't like this at all.... The comment says there is a preceding
> > TLB flush, but there is nothing that guarantees there is. One would have
> > to go audit all users and ensure this is always true.
> > 
> > This thing is incredibly fragile.
> 
> Yeah, this seems like an attempt to apply a code solution to a data
> structure problem.
> 
> I think I talked about this in earlier iterations. But, ideally, what
> happens here is that the things doing the table freeing or collapsing or
> whatever would note in a data structure what they did.
> 
> Then the actual flushing code can look at the data structure and figure
> out what kind of flush it needs. Things like "do I need to flush on lazy
> CPUs?" Or, "have I done an IPI since the last page table free?"
> 
> But, if I remember from earlier in this thread, some of the callers of
> this stuff didn't have a nice data structure (like an mmu_gather) passed
> in to the places where it would be needed to exfiltrate the information.
> 
> I think Lance gave up on that because it looked too invasive to him.
> 
> But, I think this boils down to the code being too fragile as-is to
> support what Lance is trying to do. It actually needs some refactoring
> love before it can support the desired optimization. I'm not sure
> there's an easy way out here.

Well this is a bummer.  Looky:

> On a 64-core Intel x86 server, the CAL interrupt count in
> /proc/interrupts dropped from 646,316 to 785 when collapsing a 20 GiB
> range with this series applied.

It would have been nice.

Oh well, it's been a month with no progress so this patchset appears to
be before its time.  Thanks all, I'll drop this from the 7.1 queue.

(otoh, "a month with no progress" == "decently tested")!


