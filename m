Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB04606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dBLvVdi3
Received: by kanga.kvack.org (Postfix)
	id 761E76B05B5; Mon, 16 Nov 2026 10:51:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7385A6B05B6; Mon, 16 Nov 2026 10:51:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 652826B05B7; Mon, 16 Nov 2026 10:51:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42D096B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:51:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5EFC16017D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:51:53 +0000 (UTC)
X-FDA: 85441422906.27.1B922C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1CD7920002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:51:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dBLvVdi3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794844312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDROaneVs0bqzVQFI7ZEOO+7eA3EYyxEu0hiFdloBHw=;
	b=YtW0mIxubE9GuoO6cNS0RXOoeoDVxFLxg6YqiYka1yudyFxF8oR0hlLsonM60bN2uQP2Ok
	oF2RYN74venQrFTxNmD2kI0r8mbLAAF0jWkAwxrfb1d6RBuVfLVYE4srsyTI7UXffLoOAG
	9qO0iJeuXNlxvsxXVv48E+KAMa/4OTc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dBLvVdi3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794844312;
	b=kJnxpB34Zf/TcetxhzBCSNenEowWAPpsoex9ZkfFjC0fztQdHgrP7ZBS59hRiLCf/RuqUm
	AN/ZtVdtRSecqJ+FzTjH/rQxkNezmmTQa+FQQvEK4be7U3OI9Xf/Y1TvptO0Ro128HEIo0
	fTtKHyZQGf+U4nVI39FvFSL693nk3GM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9944F62DCE;
	Mon, 16 Nov 2026 15:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848C11F000C4;
	Mon, 16 Nov 2026 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794844311;
	bh=SDROaneVs0bqzVQFI7ZEOO+7eA3EYyxEu0hiFdloBHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dBLvVdi3aK3o7HGHTBzZvD31d0wXCw8T5/B4x6dqbU/2DUnfW7uB9wPitrgQ0TQ+6
	 ngL6yGGcoWBrAvs3WtYNPyBCAweWsVQ99H1TDCSoF6Sxj+cAeKLqqEJM6RER8SYfc6
	 YNLrb+V2FPDKF2Y/P1t9Svf/T1YtfY4LgmyCBn89sbcOurBg6QZgJj7Z+JZmBJ/cjM
	 o2uTqnkBqr0B58sswgcpheqPpW4vCZ2O48hi+lElOE9acHWu5r7/2CIdbQ2u/9Clm/
	 tjdPvssX9/0ifrVp1YOXImQ5881CBIyy1BFfIlwoR212HhjP095QQ9O7Ist5oTex4s
	 YCX0b9h4S6NfA==
Date: Mon, 16 Nov 2026 15:51:44 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun <ts930@dgu.ac.kr>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 00/12] improve mremap_test
Message-ID: <avsmKAf4MRwGdpGI@gremlin>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1CD7920002
X-Stat-Signature: oajon6g516jxxqgfhdcpu8afruxbgnqa
X-Rspam-User: 
X-HE-Tag: 1794844311-235798
X-HE-Meta: U2FsdGVkX1+Uqw79KO4+VkKwsSeAhO0TDSshlWp+7Ex4GGaXdrWHoqxVLniNskgw6dKm1BUP4EfdvjJg9/YVR69FUPamgL7ffoDNlfYfBdj11tLTBXC+EBHuych25i/bchCETdY/3bvaKPhXN0/dxLQFTEyxk1Po5ILb9G/So9CrQ24KJv1cI3U3h2rKFCQsaAPzwSZKzrOALN8SnNeH1xhUyU6TCqx9GDK+Ubh6qy0CEDEz1lwCWPnohsybA06OYqd6HIimOjIftxiAgjAoXidkbdA39IzcyqwUr5FdeTZDvgYH7/69KbCHC6wk3c2ad5weE/ZR3FpMEBdfzXuZI/D1LFzKmkalbzlt9hzaJbiWjHWTzICaZh8dpGvTCcldpv1nWkDdGwvuoxmR4maDN0MURx4CXFfscW/cIfgP2OmFIZtfTOEoghl1qLo8ye7lp41SLjd+VXhWJM1T1o9H0uezGfvX4jv+/6t97PcrVykbbbnHyfTUTt66QOPK92DgwgDj9X9t9pW6G5WGHX7f+LPUwWlnq05PtYAv547BYWPkdgJLA++2C71R0+XTEa90upA5KBhKWeqoGB1gr9QiK6TLT+6+5XxCAT83dm5rzNf53KK9qiqf9xIdzpGi13eqSBeuwmD48Wno3GkV5rH5/XgOYT9/XszwMB1+UPDBNHmrhEWw+5917ytw+r2lHkELANkgPI2lrkPYRlx2Au49kLxew1nIiFpk23YA2RCSiSeuyen/59Usa53sXwtY1qwIxjcxHlr8/WnTKYAnN1/PG1vs+dvGb1GjVF/HrS74K7p9NxwmclQ3vHSz5r1Kb32CZABr46kB64nb1jFsTBpX6GTNecf0f2SBHAO6avzduRHTXLeJN7/QuM8mDI3R1kj2No/eKFthlklwf2gPXmcvWSCvMJKuGRMjDQS78y3ZG4RqtoWTQuGOFGpJFrJQI4S+ORmHSDn7Sxpt3T/4S4H
 0lj8zd1H
 +LoZ7QblBV7640e2wXlLH7oPuGIEhDLVnqNErGnKESaLBBAZRUWYOmpFCLe9BUmYClV4Tt+lB+U3TRV4MVWy7kiYaP63jayv6YTNtV1Q1RHYtE3Gb4BcS4rEwWh7REbQ0+IVBNty6ydUwMf6PIILDH2jwrjJ5usBndXETkAUIunjFvO7bSw7IBYUNLor3oUy2jlwq/w94eo+WzaFqw7IpyrJefhNWIZRJnCi+FABz8M/YDNac9sjlevx/jPidGRVzBx9UbgJgPrE+PsKTFLgxGIoHx70XbR1UTGYtpaX2jnHSylwDgDvjKbixsNDyLBkJKzPYUxRF5OOfH6TyucnhS4CcP9amvH6xNJ0k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Sarthak,

Sorry we're being slow on this one, right now mm is really inundated with stuff
so we're in firefighting mode (see [0]), so I'm not sure if we'll have time to
get back to this this cycle, will try to if I'm able to! :)

--
Cheers, Lorenzo

[0]: https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/

