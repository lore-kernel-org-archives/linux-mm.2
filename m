Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711D4606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RIVm7Hnt
Received: by kanga.kvack.org (Postfix)
	id 88E5C6B05B0; Mon, 26 Oct 2026 10:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866B16B05B3; Mon, 26 Oct 2026 10:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B976B05B4; Mon, 26 Oct 2026 10:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55B9C6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:10:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD4C5120491
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:10:43 +0000 (UTC)
X-FDA: 85364963166.18.1ACC703
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C84780007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:10:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RIVm7Hnt;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793023842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uGhooVb7WlP2KlaxqAzBvfXLtzPF00viCLXLgK+SkQ=;
	b=bSgBhsyl/WcsKgJZA8B+bK6q9VPR4sALAZRJqN0aS/Z69dl4sAzkmpCL7uDWFBrqKDxk7T
	zwoO70CcUROTaw00Kp1ARcJrJ2YJ56W6iOlUNPbkANS9aUSMRo7ZY4JzgFg/0V3RgMU6n3
	x3G9ALebbdICThg0sMglgulaCUaGvE0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RIVm7Hnt;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793023842;
	b=h99QLl2T5YY6PmPbHuopnsvdultIjsSMrJaIO+O8RiiX4GaVwdnPWVxiFFH675iFjSGxdC
	uebS3Ti1PNgtaAyEXj/b/dKuDckpxWJDN19HC8o1eJmobcSxwkz1LJtH5ULLYRk7A+MEK6
	2IN/rVB1PGsBQz9D0Os6jH4umSCHl5k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76C6E436D8;
	Mon, 26 Oct 2026 14:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1611F01825;
	Mon, 26 Oct 2026 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793023841;
	bh=1uGhooVb7WlP2KlaxqAzBvfXLtzPF00viCLXLgK+SkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIVm7HntxQq1Jf5/1cO1bg0u1npQiHUzCVIDLBjVA57QOyWohX0WEBROClmkHrs4M
	 FU5O4ajaRbq3bv/uZTaBk7zmG+fBxwntZzcp9F/f0fIImov8Wo+ySx8lnwtAIzKKUK
	 QaPfzr4F78T/ddNvo3MZe6Gqt7cf44SmPZwvdfFAOcSuT/VS2tl0GLl0f3k7JJb4YT
	 NmgAu56f2WHs5Ym93I/g0RwZUZ6gI4oYlQowiJ7/53MEvOeQLdKRqXfBmjKDP1262z
	 lBnUL+8TMBcgECQ8yX6zo3GekOjiKMGmfqHjOm+/CIlJ01WJvS3f/vhpvlXir8dPBD
	 Hjs73DoEA1Ohg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Docs/admin-guide/mm/damon/start: fix grammar
Date: Mon, 26 Oct 2026 07:10:33 -0700
Message-ID: <20261026141034.149489-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179301327249.2.1796164575094900927.damon-docs-grammar-1@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C84780007
X-Stat-Signature: 7pu7g59q1p89ieoewmi3k8dh3hg54tod
X-Rspam-User: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793023842-698156
X-HE-Meta: U2FsdGVkX1+J6HBHTHr8LiSgudXijoT4QlQrepjXOb3D4CMImq60MDWKHumeBV+goqeggeVcrbMbe+9V2oe9I7hsAuSKiVUXYUSlaeHVoZBHbkvXH5Qidcw0mXC8tGCTgkZ4lb9751YI+CwDzLBLG4UGD1LJoL3U+nCNYL0lX+NoagMZcXYqePv77/2pbx/406gQss6cY4QZpTHjWRpjkCjqG80dWaseqVvWzfkDogqrWK2by1uZ7BP3i9L1BA7kSDOWKmVXjdCtoQmeH3oAF8ZjlkW2bZSsoFaKxluyEtwAoPllgdT5WDaaz9QMGV//OxsE4CWQAyzcmW21bIpUhqg6PGRUFGZguoqU4kK8JLzmvcwoRUMOI9Ss/jvVElqsHgJXdtVXKSkFHOzQWT9s7MD2KvQhM/7XCVe9I/mIpFKp79Lgy8xZ4eA7o9DvE3c3aHth86vvxbRmhE2i3mlyjC52/JtjGFdUAsbT0uXl+M5Jx4cALuPJmXEkGnFqq8puDvxZYvKHRILVabEPY1bpeXKN81eHMPGTyqUmlBpoOa3S9C+EWKzxssR5pqYC/vEQIkrkXBvdMcPZ2W0MIXELJ5BRzDKaMoVeVBFQpa5ZXnJl58xt0NqRqgYefrRWDApKqV3ifZgw5KfNAzhEBINzae/hiekm2hOvunwrb2/l0JEXBsZBYnKcFRQakzZVeYzhKEU5QdaStOu73a+41qc81WKW1PlW5PwQLxyWBRvlFtcC4R4Cqoo+6mMAwg0ntMW5RPzX/jPsXIZG9rwSh6OVeulv44t25co7Kb/8IRk5hrCmoFI48MpRZi13Z1VToVHbtxAn1w0KBsH9CQQltaG2mYSvLpk0X0AAHJThnFqq6xAUa+fv7vTAalbPlza8IAhcEStc3bLSSFXhbYSSwGtxjVC0SoG+C7I/yHlwYDx9UeOAYW+eATCawZjFesvmp6zsGrrXcrLMJ5a8WvoUQ7V
 ZxJ3OowU
 +bHRVefsXptCtmRgVzrPWH0P4s1Zq2xMu/vnHgH8/3tAI0TWIqzNsI7HhOFP2u8Wq77NjWmSDLdjH7p8QH63WT37RdpNAxWQQ7vQN0x7dDnqe+t9tE+10UmQ1E4UyEeqEEa84qH0+hP1Tq4AvI3qBO3C4VjOJY8So4t+mBvDnpGD359BiXkAKlCqVboXFvjBJyY1FNEXevXAL/A+rUfJF2G4P3mQVe8lQ++i+bd2jGlEO6GpqIHhwZdnt4rVXNHJhuVLG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 22:14:33 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Fix a few grammar slips in the getting-started guide, like "make DAMON
> monitors" and a region "that has not accessed".
> 
> "The line of the commands" used to be "The first two lines".  With only
> one masim line left, I make it "The first line". 

Looks good to me.

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

