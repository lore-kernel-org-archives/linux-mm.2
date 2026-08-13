Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8DD4C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF496B024E; Thu, 13 Aug 2026 04:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB08D6B0250; Thu, 13 Aug 2026 04:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8526B0251; Thu, 13 Aug 2026 04:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 855976B024E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:57:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB02480507
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:57:49 +0000 (UTC)
X-FDA: 85095643458.22.2AE3DA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4BA34C0004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:57:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQU9J7BE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CS/uFeZNXN1O+lOQ2w4NSPq2ALuka/C4I2LZRJhnRdE=;
	b=P2N0qwtS5IS4H2grG4GG3gdc7GyjR6oi/qV2CVsgicorqIB8kCJhDLGpaT3LfxzxILDI8o
	ov6BN2q8yA9Nj8/PHBzsjInnGNbNRLEsHwGciTm/jztajGnqub/Zr7y3O3qb/x60XnPzHS
	P3xYJC6AJD+If4aORfqn3u2eqe0iECs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQU9J7BE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611468;
	b=LCpmdiLJynVq081jokxf6WVgTAoWYJcsEmucdMRHB1Ds8P3oeTu3WP/lnd0JV5P32/nRE8
	eUT36jmomega1jqMRHR/iDdsy0NZkVbAqxKBrp4GM5sefYz1hbJ2mIYtihxW6A9m1ULypv
	uU8hwXQfpPlwLPJ98I3hfEgd/ZB4Tzk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAF1D600AD;
	Thu, 13 Aug 2026 08:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C862E1F000E9;
	Thu, 13 Aug 2026 08:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786611467;
	bh=CS/uFeZNXN1O+lOQ2w4NSPq2ALuka/C4I2LZRJhnRdE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XQU9J7BEex3WMosE+FwvoP5nSRkBg19PfE5WoUhr6AMneIaF1tAQSjGKnuT1ChOSW
	 7ZkptBhLgO7+hStx/PvVSK9zJCNOJCJEbT11Ehsx0nnLwfvL/9luP3t437TJ3eF8iS
	 5gJ6ZZIiUNppiROaOoKOXRHlSURiV6on64c25KUu/WakdmKzl1C8Y2b/180KBBBFMS
	 OjK7HtIGSEJ49/38v3NnJiGYEc5+tuWSFaBU9ltlEYAkl4+BVAHpzEmnaRpWOyqtYd
	 l521NxcYLpcRvgdifVmul6IYu1FGY5mGoEaCkyF2knRgoYIWaVn/g9hlCLLz9kwER1
	 DqVuRxKVXPiNw==
Date: Thu, 13 Aug 2026 09:57:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, David CARLIER <devnexen@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>, 
	Vishal Moola <vishal.moola@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org, 
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <an2GkrW35R5reoeC@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <anCwUb9lV18v6mfN@kernel.org>
 <anXp--mLLEE2Qo0g@lucifer>
 <90c2be6e-fe03-4da9-88d2-fe4d4f745cf2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90c2be6e-fe03-4da9-88d2-fe4d4f745cf2@intel.com>
X-Stat-Signature: z1i4c4njyynpihhckhfdpnuhagqcpofr
X-Rspamd-Queue-Id: 4BA34C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786611468-280648
X-HE-Meta: U2FsdGVkX19d9whl9DoGR+EZVk+jyQgcKr/eVNLy7nIRifmlrL0dsY7b+K8ICC7chK0Ck1fFqqzprESgYNeAvpvNG7vG/blS7OkBWx+zlUTGZwhTSuxBZJ6O76EHv7DL1qNHV7luhBDoja+o3WedRtzHvSh7njUCagmdA2MSDdrPcxuGDS7D9Q4oqeViCcZ/gFaJKal2fr6rwNAtbqo2S7/BKgVquI7k0WOnJsZUdZsWMG3XR1jaaAsYcfiuTepS3ZmOBQwJZeb3IczkLJMr8EEM2B8nPJmPLWB057+Al56RXSAUdVLCKJxVdY65P8JSWHzvjY9oYIriZBFLBna0JMbg2RZybSdPiBVv1iqweZhmHks2fpOsUv8aj/sguyZlNySw1EcIZTAUbnBZ/FZFh2fkW/h/rsFncqvdutnN8q34AmYvF/gGn5RUBH9vNincPDafFfH7CqeSNPGS5wmuQSXrtR3eBWghAHW1237o11XvhPhr7NphkuUQubBkLsxaqWTvnafJ/7KJBbrHeWmPrJ9zglDFJKQWO59O90rAhEsbPOguhPLESN4x16/h9biTopN/m0MCsY9SjXQS44vqVTBEOp/+YHHbzcuDydU649gwi+4oADqfEccrUZfZCjTG6pCvU3IWcvMFlOvYw7v2OTKIAdj/DyIMWNbScZJwNgUtjfbkIxlZp/WyCKZXNCG0t77+r0icj4N8vpSuHkbhPLhnqbY7ngrsK3LDJ+T4/0tUUNMsDHbWrHobuILZU2aYJwDPQ62OtykaJ5A3vUH5vwmNExOgEvHJkCjVLrmUKY27OlKbgO0lyLw6q1NC/Ty7zOEA4RBLHRl2ruZPrQSSVMUAXydluoKu8csG1sX2tv1qj8Kl8WRTz0/qMzO+lo5fGvWsE3rCZ/NJJOnlnoYHbGgKXHGzcDApPuHl+MQ3QNga8sDg8vAbpQIWM0cbhvaMM4TyxgqOI6by7fwtLrf
 9Nq+69Va
 TTKbHUFMeWuWmnvxUeyV0Aqu99dMC0wn+XXGD4c9wu9nV6j+GrKV+cwZc8gkdfJBwod1JJtj14QjNKb2OAMhK+kUvTy+hacxWyJQTFw8fGII9UrlLMhDGYBMhbOS6ao0pzLoRIbU2vDY/w+NwM2LrzXp/0lZkzDuAzwVQ5LI6PrNOEivWW7QWUCeSs0TUpPbQ1fOe9CA5wVrEDoLFxpQ18y+QfEYLQoyCOu5FyFM1SJhzGQP61aIqdYB9W43IgkWXy3oAkzDpohsMh5w2ErgglFfPrYpGKfzsaWAR1oQj8rERUTCOb97PYuFmhOdiQEWltfuQoeEusGSc6A4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 03:20:23PM -0700, Dave Hansen wrote:
> On 8/7/26 07:34, Lorenzo Stoakes (ARM) wrote:
> > In any case - Mike - I think you probably need to respin this on tip
> > x86/mm anyway?
> >
> > Maybe worth doing that and seeing if that makes life a little easier for
> > the x86 folks.
>
> Yes, please. If it interacts with things in there, a rebase would be
> much appreciated.

Thanks, Mike is already working on one I think he should get a rebased respin
out shortly :)

>
> Also, please do send things separately if they are fixing active
> regressions or bugs that folks are hitting in the real world. We'll send
> those urgently and not through the normal tip/x86/mm process.

By separately how do you mean, as individual patches? There are some ordering
requirements here I think, is it OK as a series on that basis?

--
Cheers, Lorenzo

