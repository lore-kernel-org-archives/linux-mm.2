Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A611B606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VI99JbvX
Received: by kanga.kvack.org (Postfix)
	id C654D6B05B7; Sat, 14 Nov 2026 12:32:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C5D6B05B8; Sat, 14 Nov 2026 12:32:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B146B05B9; Sat, 14 Nov 2026 12:32:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 975276B05B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:32:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CDFF1A0472
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:32:39 +0000 (UTC)
X-FDA: 85434419238.09.296BB0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 78F09C000E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:32:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VI99JbvX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794677557;
	b=s5f4XNEt4M2Xu1C4ffL7TZf7x6YMmncdQUABwPOR/EZIh37dBvCUdQiqPr4XaAB/0Oyub4
	drQOUqpQsz8Dc8o5s27HjNWXETck6u9KG7NhKC8U0ahEOgEMoEkqmouDocbVppdMhihnGR
	FITiHooO86kZeTR4bcjN9FkbRn8s5UM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794677557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jd8/NeUBcvGVBl3/IVvk/GOuA5V+/Z06IONroCz7q6I=;
	b=j8PDzv+3LFaogvCD3rrhMHCASNYftp82qT34uB5uUrtLXLttYKaEeskj5XWnuX388FsULT
	kM3IyM2VK9ozv+3wU6R7xmZ/wsiI9vcThwKdaGgeZBYQDxe4M20gqDxoY4a/KcVpwgYANE
	rw9kPS8xiIwybRZW9Ggeoo0ZUOZjo08=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VI99JbvX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD39640A5E;
	Sat, 14 Nov 2026 17:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD491F000C4;
	Sat, 14 Nov 2026 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794677556;
	bh=jd8/NeUBcvGVBl3/IVvk/GOuA5V+/Z06IONroCz7q6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VI99JbvX5Z2NlNPLoYgkjL81q/Cig9LlU2aO3HtvyXsC7gP6GqLlha6fJSTcZdZSa
	 H7BYkxGbDyxHvTyCVvOJ3dcNsV4DDUjCPyrDMDScdjdY8lS4U0xVeqcKTnr7Jv4HgL
	 e7DzH++DgDtR7AVeINQoCXKgDM7pqg3CseeXbeV9OxIPM6AXWSjPVn734vZ4euskPp
	 z77bcLD4xUjnfzzt72HaubOIgazybGQygT11OIuMCOFVFkz/jR9JYxq34Bp3+9y3lu
	 5IAJcuMsXl+m0wiKjBlsZSig2aC6Oty8WGxu3TCdQNmHYNVrZ1nWpc5RD2zZlaD2+y
	 krFlVWDaaUBdQ==
Date: Sat, 14 Nov 2026 17:32:32 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: akpm@linux-foundation.org, rppt@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_emulation: use the real node id for leftover
 nodes
Message-ID: <avibII-ONCFXboWZ@gremlin>
References: <20261115004706741mYrBkIRqmj_IWsv3oh1uZ@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115004706741mYrBkIRqmj_IWsv3oh1uZ@zte.com.cn>
X-Rspamd-Queue-Id: 78F09C000E
X-Rspamd-Server: rspam12
X-Stat-Signature: senfs77uj3b7jkpn3m66bunhrnsb5tb4
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794677557-596954
X-HE-Meta: U2FsdGVkX1+pNHm/wL4R0zPNwyPVZh2Wt6tN0ixrI+bwqBsDkkGFknRxTj18MskWUTkouVbzgCB14xq8Y7TUwqNRGhHjMqfor8mO6owMdy9W6Yyd/oyWE9jVkIaYWum4YwrVnc6rycA+aZW4t1hfT1twKg8RysTEkx/AnVcCDsJViZiSkhkbF67Z5Gh7imsBKT6oM83KgpHUCT3prMzJnamOs0gQfepGP9VUf0e0WP68GuAqHFcdvf8g+YA7X27IC9xfR8T1cON0mfS3UEKvlGj2gMuTTXIIrqBwTVF2gkVnnio4+uGWvzU5j/mN6XTwg9MBukSYBVTNfT5nrNOVl6XSs1gG5/DrKHun3WlZqyWPYBcb1KyjK99SEVfAywzxC+6hBIxhQj2yzzzWwjRlbr9eFarcAfGU+UQDLURvAw9CN8gNR5V6uFcQz5pSMZdS6HTa5v54wtEq3Tx55naS+vq+ovZB4PMTRnWIKJHiQjIphiR6ozqQ9CG0LRQ1OvYWnYqfKenhi0OPrYkMyB4x8mSkTApF3VAUkBmCTWlBuLpAJf54GbKDf+kR5CnMnO2MPILKMMqANxbyHuiosxwDDuopd4HVYRnOh+wWNuB307yihBNDEraDoIg9nDiHGtqw0DslhbsejpN0kkZYiGEBDOoDXG4rRW/cLmK+l8B4AI+Bv/5XBeGF8R2OxwoPzcc71R45JeBu9A3kQ4iT2zfnxmFqdhl8XlD0rzfhdY2Ci8q3iEU6vE0bWLxbAF6gZx9m67zqd1hq3/I6Pljj4LD9gWjoBa9UkVS9v55zdZA4SuKg0bVKkKnq30b9B6Gt/ladx8Y2zK6LiqGJbV417tJo/lpGXBiPyebS0UdJolGW60EUcNj/VTmvt5tMxgXRmgviiRSGkR0qreMjxEsnpv9KpYe+AGUS2U5aLvfOsUCZp3elfTI+UqpcdWCN9nreH5E+5kexBG2//1ly6MfNam0
 VCDjV6DD
 q6xQZfX7A5Qd6YwV1vzgKX6LI9Yd08uiEBeOcLu7Zr9dnHDihyhPr9wFqc+VD0tE+gvRlQx4yQOFcZFvW2UzBD5+ILNRFPuskmaZIJA1JMD12Om7KDC++0pMZsTSilx7uj2Du5bjDvJhcc3ZZUGEgfrDMIs6F0E8NBAqVgQc3IQf+Khc5obB1hbqd1uLVtG9jsRK2Rt4b1Rmm9uEstsxD0h8ejKdDfkXYhnqmKzfFIBUl0ZKuuHAm98fs9Wsgp83/nn5Hepr3kYbw6FtFpgodiqg9AJbbrj/M6uvcLB5zILNdCaHiQ5SRr9Nc998C5wKjt3fkNxtX6ERkXaU3qkzeyWFkO0+jMO/oX6LUae5TUatJztrHE/lDdG0UUH28Tfhdb7pUPkWhSJaxxFDQjJtmMACvZXRZJVFIW62bYW8cYqHHOmjn6hxl8CDL/JhcOlD7Hxj6p/nKuJAhd3BkOL9mlFXOE8tbc2ojkagXt6BvARnkDKw7+fXxNp1enZAiXCURff/2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:47:06AM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm/numa_emulation: use the real node id for leftover nodes
>
> After assigning fake nodes, fix_pxm_node_maps() gives the remaining
> physical nodes free slots in the emulated node space. The second
> distance loop in numa_emulation() derives their physical node IDs by
> subtracting max_emu_nid from those slots. The slot assignment does not
> guarantee that this yields the original physical IDs.
>
> For example, with fake nodes 0 and 1 mapped to physical nodes 0 and 1,
> a remaining physical node 2 assigned slot 2 is read as physical node 1.
> The wrong row of the physical distance table is then installed.
>
> Record the physical ID when assigning each remaining node's slot and
> use that mapping in the distance loop. Keep the first loop's fake-node
> distances, and check the physical IDs before indexing the copied table.
>
> Fixes: 63db8170bf34 ("mm/fake-numa: allow later numa node hotplug")
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

NAK.

this is generated by some AI slopper's script, spamming the kernel. The
patches I looked at were wrong/broken, so no to anything from this person.

They've sent 300 mails in under four weeks spanniing: ata, scsi, target,
ufs, nvme/nvmet, ubifs, ublk, zloop, dm, md, mmc, virtio-blk, mfd, gpio,
pwm, spi, PCI, ASoC, ACPI, net, vfs mount, block partitions, and now mm.

and 17 series across 7 subsystems over the past 23 hours.

We need a way to ban emails from people like this...

--
Cheers, Lorenzo

