Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F48CF589D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870836B008A; Thu, 23 Apr 2026 09:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847BB6B008C; Thu, 23 Apr 2026 09:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7852A6B0092; Thu, 23 Apr 2026 09:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 681D86B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:14:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3D5688E8B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:14:06 +0000 (UTC)
X-FDA: 84689863692.01.FF96881
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B1DD7A0004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:14:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S03Ap+5t;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776950044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5zu17eWGJx0ZbQT3/4IhKgc7X0rd78xRrUuhl9JKjo=;
	b=mumBZdybYO+YiIejGUzSG6hw72EHRQPOQVy51mSGDemkFVUPeaYMyKLCSvHt51dAwHvCle
	f7xroXsU/jaOzoxwEuUwSvrvxYR1BNyualUeF/OIFjUpxyEv/99pYFroROwpQi/aGgqchi
	MXJPDaQOOSesqvrNXNhbzzhdMk524Dw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S03Ap+5t;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776950044; a=rsa-sha256;
	cv=none;
	b=FsXghoL34wpe30kAXj1PI3vlSVBXC2CfqR3EDfD6/V/DKQgNrVEsgKdBl0jjsbIj1bze8R
	73YDMS7WRl/0htLAbgB378GyW9I8H/vOeqiv0Kj/M/C+JhcVJSdpqWALovCMidaprGzZMs
	QuR5p3tO5Mv76RWC68vv2HFhxJKrcrU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E4EB40395;
	Thu, 23 Apr 2026 13:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3830C2BCAF;
	Thu, 23 Apr 2026 13:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776950043;
	bh=vnWoAcvGkh3LMITKH32uZE+wtK1wshJpIlS68Lsz+nA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S03Ap+5tRCZsFG/zml8CtLTb9BLLVXvGEoZoAY1RDgMQdM7wvq1yuwkIVYkAy2l2r
	 ZlbkQb1/rkCirun+/str7aimc8Ii31c13+V/2Wa9O/D1OMLHNQBv4iOL3M2YQKTfNG
	 qLoS826+ne+kj4Lz5F+ChjQSVWBhYDlhrAyzBOJ8=
Date: Thu, 23 Apr 2026 06:14:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Muchun Song
 <songmuchun@bytedance.com>, Oscar Salvador <osalvador@suse.de>, Michael
 Ellerman <mpe@ellerman.id.au>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Christophe
 Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 v5 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting
 with optimization
Message-Id: <20260423061402.71f0f37285e922f28853e5f8@linux-foundation.org>
In-Reply-To: <D642D89B-CC3C-46A0-B1D6-3DC2C4DDB874@linux.dev>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
	<20260423071911.1962859-5-songmuchun@bytedance.com>
	<1cbae635-a115-4270-bae2-64145d16f936@kernel.org>
	<1ADE7CE5-F02D-42B2-B7AC-FE0D6E86042D@linux.dev>
	<20260423053237.a44b68034673bb35a1e042cd@linux-foundation.org>
	<D642D89B-CC3C-46A0-B1D6-3DC2C4DDB874@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B1DD7A0004
X-Stat-Signature: 5m3jw8qkh5z1nrj1yfnpinhhj5b5zba4
X-Rspam-User: 
X-HE-Tag: 1776950044-44528
X-HE-Meta: U2FsdGVkX1+NzuEID53IZx8G/lUOWe2H8HvNQ5DYTc+lBnWbJz42i34AoUoUI2oDSssHhxwaSiExfCJAdzLNVK2drpc16viVCub8xCofHHyW0WC2eWQWc0bag8S4dhb8y/eRt9rU/IbdPXp/hOxJyDv2oJhYFrVZA3RL7CRTGeZjk0aLfy2YbaVUyUhAHsfmffcVs/m7jDBZPaJZtU/OZdsSR3/ncEryLIJWNCngTGloA14Lk5LXTSuHAmp2cDir6IANlFZJP06KpRaydI75kien5182ktdrHYM0RW0PCbzEskq+em4MCXmtPtpidQfFuNibHnvkbKZ8Zh2l0k1f3N5IiaQGhZaYHRnLMfkAJBnpsANRxaoK+Bb6yp3XZ0HCT4jz7PitEgpuMj3bLcJPiSvmzOfPv2ROT4gPhDIEk/wXRq/P8TTaso9ARysBLq+1li+UXr5keWz9cccZiHcA4ltOkhvHkghzeyC+8c9PX62G1j+U5HFIbbcM8Gw0spCdYwdpXQ5gN70rEzZ1B8/Z/8EO4C0Mz5f0wLE2GFqTqNddiEIRPfDCqb/oB1k16MKJA/SKxCLSPho/OOBJyJbOjKqiY1Ot7kc8wBXNLgadUsPGvTyl9KeCuwG1e6RLE3HOql/mkcXn+TeLpSs4Y2hQlRj0TbgcWhaBAIv0X6Zdbr8SMMbo+4soH9SGU/DjF9w5pLKvltauSVzqD0Gxi0Ica+glPFu0rLm37vqzD++Jm9AmJVE0YlNlNPJfqsgFHXhWajOOc3U/iXfEDHDBOF3O1D129PUgudPvDOj9oaLtOxqHKq42iKEnHL6PgVxccMzu1Bx0Z2bEn+tqBLFolk8ZsSynNc6rST08iAD/E99dtwuugCKH+XK0Oh4JdXz4/k0e3FL21SJjYm7qTaVVn91lYB0uYubPOw8PT63klN1Jo86kyQqJNMgwFWfQ+0UtcmisFVAJeC23uU+BVO/NiDp
 hYcqqGTA
 02sMN+PlJCFEGi5johSF6gMlxSKMVKRgqGMl67E+Ah6YturanGVnTsOOln3Nh9Elm8Nco1ygY6H3x+4YIRkY4kcetIzoa7LBkGvWMlzyVt1WCHXE2e5Wf/7TqKV1dYxoUgnVqi7b2Ksv8XlcTaL2OEnAXjvvOGCRptEafAqMjxj02b2GoAO2N2f4iWe6kS4d0AaeCzfdrdQVnSRw0Q/nqUUBIynngU/vc6OzmJyQj0SjNY4jbcd2ToPt6zkPxqIC3LbrL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 20:43:02 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> > 
> > Ideally, split the series up into one series for 7.1-rcX+stable, another
> > series for 7.2.rc1.
> 
> Given that these issues have existed for a long time and the trigger
> frequency is very low, I suggest we take a more conservative timing.
> 
> We can prioritize getting the series into 7.2-rc1 first. Once they have
> 'baked' in the mainline for a while without issues, we can then proceed
> with the backport to -stable (7.1.x). This avoids rushing risky changes
> into stable branches.

Good plan. thanks.

