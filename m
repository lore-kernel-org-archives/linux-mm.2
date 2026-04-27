Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C21FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7D26B008A; Mon, 27 Apr 2026 06:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F9B6B0093; Mon, 27 Apr 2026 06:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F436B0095; Mon, 27 Apr 2026 06:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD526B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:58:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC7EF1A013B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:58:23 +0000 (UTC)
X-FDA: 84704036886.07.1642184
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B91E4180003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:58:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fPsSMVCu;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777287501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+uzZ4Mj8ZwiBYWjZvhmHYqnD9uPtTE64Ztq2V+yfjY=;
	b=2//6xfCtGaTA+pc5xxeoG0pjHe9Kdmfiep/GGHDOjZKW8fi+EFbFRAS5cEH9AXjQTmk6Pa
	y74Gw8SZ1ujUUmuIGxry85dStdDZuZE4DJlEskoqlBZ8fh5v/corAUby4b5iXZdSbrjKyQ
	sCy/ATi9AGJv3BRpJrqPKG6d866VB1U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fPsSMVCu;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777287501; a=rsa-sha256;
	cv=none;
	b=uExPwXl67qgExp1beDjXOnRgW0pLo9+KX85OZ7BnGlsD3jsM58cxRup3dSFWC4FaTjubMV
	0QJXGa3IXLvLhAQGvPve13x+zSQFGHtZzb5OP2eKAWMNlG+DQgilb35W8i6/Qe6VG8dVFp
	rnZMoyfgwr9nGOv9JRKYH40NvWwban8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EF944456E;
	Mon, 27 Apr 2026 10:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557F2C2BCB4;
	Mon, 27 Apr 2026 10:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777287500;
	bh=t2cvbxJeTDwpCmvc7MQkgIGux4ZS9uBTx03M6Wy4SuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fPsSMVCuxI5PtoZIjkgjLoKlREiZSRv8t/UUmX80SNeLScaSi+GPzoki//Za+3sJp
	 d8wrCeDf/6n+bDsJBllKJJ69G21bZDb9Z/eEbNe4LOcUX0rhYlPHMMg+vlnoiZRYOt
	 jGgalDJk00cBxzwhpQAHanvsfIj9SRQh6z6l0JVX8edw0DZ2gWURdhJMmyWvQX73Yj
	 D1y0Lo4kFcksqbqKU3/6/LqTpEgFc0c6DGLeJ2AeZF9RktAaFFbDCl+sLJBKkGDTlb
	 OxnVp7cUUIF6UMW/Td/xVC1cE6iaKIPpy/WRjILb1bV4NggZS/Eb4uFE2cHJtRI3WB
	 NhUzSkpTU01hA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 771CEF40073;
	Mon, 27 Apr 2026 06:58:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 27 Apr 2026 06:58:19 -0400
X-ME-Sender: <xms:S0HvafF4r7Tferxd0CzVeZyXBZNJSzKMd7AKMfe6v9QDuBfcXNou6Q>
    <xme:S0HvafYFAEL0PzO7IeOqfzXr_EpNuUgi2L_V5ROqK0NLuLnwbD6uyj2RoD43ulIuK
    AngytfQ9IrdLuRvJ99H5rUjsr_pl2432Sdi8yF1DwvYN6DXiFfzTg>
X-ME-Received: <xmr:S0HvabxlQ07_eWVn-0A12U7CE8XIaDAjaNxNaa_WRv3PebqteEasbb9AH1Gyuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeehudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeuieejieffkeehfeffffdtkeelfeelhefhfefhudehjeehvdffleeuvddufefgkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtohepfihilhhlhi
    esihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrdgrrhhifheslhhi
    nhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprh
    gtphhtthhopehlshhfqdhptgeslhhishhtshdrlhhinhhugidqfhhouhhnuggrthhiohhn
    rdhorhhg
X-ME-Proxy: <xmx:S0HvaZSwa4p1QDeQOOd_hZJU1Ebl6mk2o2WJeRQhnX1xQKcJ8dRQNQ>
    <xmx:S0HvaQKQr2SdxWKU35KA4ROH2UUACcbXyNouW2HPipAHxwdh3Lz0rg>
    <xmx:S0HvaYUtbNoduIyoR7x7Njd6_VvAHVKuhrV4GdtGZ3bJKn7QV9tTeQ>
    <xmx:S0HvacShCwcw0NAaGNKlA9GgxXCdX0qvXiZi3b9gFRWU7fAKx5eGxQ>
    <xmx:S0HvaYB-cu5MN6CwYh_5lF4gy17pEDhEM9H9IQgfgNFVAIEGANU7DPn2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 06:58:18 -0400 (EDT)
Date: Mon, 27 Apr 2026 11:58:12 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
Subject: Re: Large memory allocations at LSF/MM
Message-ID: <ae9AHWvXUTuoqlfA@thinkstation>
References: <aepANOFKoA4jn8NN@casper.infradead.org>
 <6cc83a53-4392-4925-9187-d682b60edea8@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cc83a53-4392-4925-9187-d682b60edea8@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B91E4180003
X-Stat-Signature: yy4n5qyh3dmm5863gac8ks3ecchjsmwx
X-HE-Tag: 1777287501-518301
X-HE-Meta: U2FsdGVkX1+DwRfZ8y1Kho1FyjmeMfCNveARVD2+OG//bCBNTq0McEKdtbY+Gg5/dW8aPYACDJbipEQQbSvLgJ4q1ea7HZXRSt62IZo21bcEyrDe8gvGMZuIIYKMEZmZQPHW0D7bGReb5IdpT3bW6e/MTVfANgkBJMiOYMKT2j8fid1SyE2HZSDfDyHk3qvh3Tac+inAk7jfto1QxJeG2UY6CyaDqBrGv3cw5dLy695Poi17WFVBJcmW1Hct57jyYIi9ecTCLXTOpkWIx5f/B3/7+ga1bY1osiWXfe/czkJKQaJcDwWSxYN0Gb/YNzwWOhByIZlz6YHjSxA/vT8pgKpsfNvpzUI6A8Qo/SRahXafqHlxUss4stc9a6Z870sc/BqpCj/BIQAZjzb/NdG1dHWM8C+dP+jzqU/VtXjtP92Yl09o5wQsUsli6Ix810IRktNiP9oXqSGRG8vXxu0t23FZh+F7umfsSGNknPgIZkHD6al0FJvyMATb83kZjBhv7ssCuGIOzE/k/MhVJhu5JFhv1MfY00cT3fMmO7EaHOUJ1WbhkNL8PDeUooVg+10RbhJ91r8DsUp4K/vdcJ4yl4wkWGzx9d/rGVWTgfNaACEAs74WWCW8vxRHzRXDeI84Am9v/R0ZqB6hT2N6s3g3bajqTiSoug2zjyaZPzIQo/+TAHvOARaJsZjE8NKNpQjEshy9Wgw7BvvIuV5PD2W6RR/Z73Te5pJH/m6pejDTcO1dZD/EXIeVjqtrKuZCO9/4Sa+3dhcXKxAO4W3OpGVCOYbK/hYB2nJeZb5AF6hl4ltAoSA6eU4arwetetkVyBoUzrb9H5hBsKUl8emTTSFqnjGzHmFe3doXjNAqRG3M+WtyEubl2fMjsXITH+pGntQ1eA9z3zN08xg4nR+M/vCa6LG1FBpjc/OSKfbXDPyilRoSRqdtFgbx5tnoMmCU13a6MjPCY/4JmxsFHnxaRNV
 xLhhanV2
 NjhB+sKtVYl1yq5W5KM4T5VocIvdiGt8XR88S5aMrKMTWRKnEBYMoNnMFvc+LxDup4BUXR/7kLwXIHw01hnnz1EZsfxICvy6GIacVApUdQ3Lso/mUI3kEabiLjt2lStden/iK9e2YEL7hTaiR7BRZdQmldtxgPGqZzk+lO6G3HZo4Y7J9fBopb3inKwxazqiz4UHTSwhjIblJGQjnomzVaEKVsuL5kIXCMJ+cBqj9kQCS00GfHrspqqJFFfMIk3jft6gs6qr4uklOhSqOpHD4DvA8Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 11:46:51AM +0100, Ryan Roberts wrote:
> On 23/04/2026 16:52, Matthew Wilcox wrote:
> > We've had far too many proposals for the MM track this year.  In an
> > effort to squeeze in as many topics as possible, I've currently
> > scheduled your three talks into a 1 hour timeslot.  I think there's a
> > fair amount of overlap between the topics and we probably can get a
> > decent amount of conversation going here.
> > 
> > If you feel you need the full half hour each, let me know and I'll
> > try to come up with some other way to squeeze something in.
> > 
> 
> Thanks for squeezing this in and sorry for the slow response. Yes I can make it
> work in 20 mins.

+1. We can continue discussion outside of the session if needed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

