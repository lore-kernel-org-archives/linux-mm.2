Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8A1606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YANA8zpl
Received: by kanga.kvack.org (Postfix)
	id 35B836B05B1; Tue, 10 Nov 2026 06:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333446B05B2; Tue, 10 Nov 2026 06:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270F06B05B3; Tue, 10 Nov 2026 06:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 061AE6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:03:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 813481204D2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:03:19 +0000 (UTC)
X-FDA: 85418922918.15.A8E52DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id DE7131C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:03:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YANA8zpl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794308598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJqoM5byy7t2oJnrolNTZNqtxc09Si1RLmF8E4lHkmc=;
	b=5wtK4Swx/BzL8FWEWbc3excUnCwJaa620xPG/44L28pRjOrzS3aCN1LDaEKp3hUjkiTUFc
	wcXJS/y6b+XFmg6zz0UpYfm2bA0I9XA4XsglpY1Qo+ADEXGJaRsb+N0A/Y5xVNStx0YKti
	l4QSxiGGt9kM9w/duOh8J60JCLMN/9o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YANA8zpl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794308598;
	b=gegaixi2h+RQEtCfSNM33LobDDPE/VXsvtl30qOTwkpqUvmCwD99ugUDv6QnVXgLOm/FDi
	l/CncYTnWNRpcKMANe0Aawk1h4h8haFirNQgp+RZUlXmt2JU3RZgHt2T68ZQYJw5usz7yw
	1Ya0h3NIYKxR70cUotEvl5xylZXkXuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E089634ED;
	Tue, 10 Nov 2026 11:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558691F008A1;
	Tue, 10 Nov 2026 11:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794308597;
	bh=zJqoM5byy7t2oJnrolNTZNqtxc09Si1RLmF8E4lHkmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YANA8zplr5ixeJhh0AM8kWaDEpgWrinnTQE5LawdfgLFWTMxt5ac2dOiWa2uHAMWT
	 ECRyCaV5UcHiP0DAo950O9Dmg0eiMieX5pblSLm5iCsk5XT3a9DATsrRof7z/6txrQ
	 mwJ76n3z4xZHT0rB0l8oFErQFtc54rlSYNYJ5NS5nwj6xa1ameGYDGdHgXlRk/01r8
	 bZANPsfP8Swcja4QTEWwCPFJkEUzh7Fdsp5RiafyRFQLtUGpl5OvmRJugN4TQbo7/U
	 Q/1lOVg0My+24NrLBHq5Z1LHUVmtllX3g3t3W6cC1YtpP7IgN0+ncBEq4UwiLL9fTs
	 HUPvecaa/x0jA==
Date: Tue, 10 Nov 2026 11:03:10 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Seunghyun An <san55@wisc.edu>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Suren Baghdasaryan <surenb@google.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: avoid redundant reads of the vm_refcnt cacheline
 in anonymous faults
Message-ID: <avLxcf8KaFP_XPnM@gremlin>
References: <20261110000002.1834454-1-san55@wisc.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110000002.1834454-1-san55@wisc.edu>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE7131C0004
X-Stat-Signature: tfsregq7oqxjsq1pjfpoijycmrzsgcij
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794308597-386398
X-HE-Meta: U2FsdGVkX195EYvYLVrvZvz4LXKLvVNzUMshua5ek2UTCiWutj7TsdohxoVY0LWW593g+GqVTy/7IHSELVkZBpEeuefbxs7cBRFcl06MKUOWNBeglEQ6fzlM6leX2dk9tjVZ/ZhUQ/aLM6POknMeHYEbYlxgU8fR0o3elRn2Sni4tPgSfl8hwMqt8RZUQDa+PXtF2WdmoL/cmaFa3qIg5sXyWPKDbfzA9EYJ2oX8L77r65SyXPSRxBOmMnVRXqKwhz+Viy8XVhgJ1W83n5G+MVhRF3XU1g0/tMxZDGZA8h8kRMvmTykSV7k8LBF5nTLL9Z/WSWrQ1x67KAPASW8Ybp+VwCdLFnXkokw2j74YCUTGV0poyg47jHE4+7D/LThYtydf4PNCysCBqicecJjbP+MvSwnvv/xo0BrfwCzuOWkdW8SO01F3M34W7S3eQhLZGkDQjSQDbVjxhwsFYPOezH9ZP+iHehk0/uSJ5khdfDOkBs0NXCgsd88t3e2JDQJqa9sRtwokFRDn3Y81nFx61Fwf5OJ4wvX19HjuoDa/yKrDhs2Y1TS2tjpSpaYo8Vd0psBDwPiGPCjDTXWjBHJ/rIoa8qu406wz4/wA4JUdgB8oW/5jAZ/TY6+fRXX7EAqaVxnt8URnVqLCva4KY8AENNILmeiHzWczUji0s1tKAbtAyRaDll3HdKcJ72rf4Vauz/PublULYVMF53gOxKKrHtT0aN4TgMrHcJaR8tkF6zDSaFgPh0t0V2sei3NDCTDODJeh23Cru5crpWhhR4ik0a4js0K0DKlYkb8BxJWGVJCPRRDhV5kAuuMgBskIY7Ln1wZmpgRmTnWp84hhMFt27Ym5t3fRgGnCNL0E7iCXdyxY9cypsdirA6xr7HtOd9trfFPxxao1eNHTsr8+MO+L2WOy+3xOEU0OO1R3F04q6UiEmNNKF/TE+0oEjJwq9lSjdRm+JM0zGxsu2v/SHZ5
 CHc4jORJ
 gPdmdnq5OtR7n/y4KCmJICSmOKmR/CdWlz+Pue+ebqxo8zJkk9LFsC8qKnLODh/GZcxqZ+E5ijQszbOyJ6VIoAYS1S0NSW6BFCJCjSFEX9mb7EG/nI52d+xpC3Se8r5h0QAWhaN+5RHfSSclvzR1phVfeLzFfg53Z5AuZ53i7bFSuCS5nlekWFl5RLVYwfsx/ka6B5ezDcvNnUZqWJMPc1t8d1+VDN3ZOguUSBd8hzVOZJnc9YAQw1CjNjkQGeNuBGgGRicW3lGccDfIlbR1wfr/pkhOOala8EYR8SMlAL/bEuHf+5xel6hLCy/ZT6gGe0oogV5gqbbl2sGYtwVHRCZe2xmccBP4SAg29zsEiRPbZqPQAcz7x7y/ngg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thanks for the report.

You are a complete newcomer to mm, and you are sending very subtle changes
to a core part of it, so I am not confident that you have the depth of
understanding the kernel requires for such work. See
https://docs.kernel.org/process/generated-content.html

I'll therefore take over this change and treat this as a bug report.

I will give you due credit for reporting the issue of course.

I'd like to collaborate on the perf measurements however, so if you could
re-run your test results on my series when I send it that'd be appreciated.

In general it seems that the actual issue is the debug assertion, given you
state only vma_has_anon_rmap() as a problem here.

In general in future - while we're fine with you using LLMs, newcomers
should work on small, incremental changes to mm to build up understanding
first.

--
Cheers, Lorenzo

