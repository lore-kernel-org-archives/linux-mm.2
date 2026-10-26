Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89144606A329
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYHbSZWh
Received: by kanga.kvack.org (Postfix)
	id E30A86B05B3; Mon, 26 Oct 2026 18:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1566B05B4; Mon, 26 Oct 2026 18:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0FA6B05B5; Mon, 26 Oct 2026 18:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A77B16B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:56:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DB70120592
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:12 +0000 (UTC)
X-FDA: 85366287384.18.5C83430
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8EB7580012
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYHbSZWh;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793055370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50DPD+pH2maEeR1T0q8TsL7h2F5lpY+dTHGdMvmi2aI=;
	b=yhZqzpcyggS2s5ey54iwposSGp2Yk96frB8zof9YKt0hK8E2akJs2E9osEEtOek/37mF+T
	SDtJXOmgX7IzyE0LDm4PD/804kJEbY7MzBb0/cFh71+nqI+90OFvdQGGAC+Rf+Sh649vrD
	iMoqvA6+g8eSsi1jZO8p3tSQiRzozaY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793055370;
	b=OtjaaumV/if7VmzVblONL69SNflPO7WKJq8IdgpSTgt5AtTFEwcPlwDEfQnfeplwww0peJ
	+gFKK8MUs952aC26AiFDCa4p7RhOo4Q6IG7P0qYgysocbxfrgS/hYfwM6jyeBD+wnwJW24
	vHY9F2nSwhKY/eAh1ZQcEaojTQk48C0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYHbSZWh;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 259BE601F9;
	Mon, 26 Oct 2026 22:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFEB1F031E1;
	Mon, 26 Oct 2026 22:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793055369;
	bh=50DPD+pH2maEeR1T0q8TsL7h2F5lpY+dTHGdMvmi2aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYHbSZWhlg4+NHIxV7K9kwzpQNcgvriD+3VstEKScl17ajn9TeHE7Cei8dgu48jr3
	 TQxz4drVnZ0uC8ZL806vPatRWG99uYgleUYpmRo7LmYX+5neZIYE0VlukNyUJ/wnEb
	 unJfljsH9KhzmBZrNFMnfnotHnZ0vDpn+KS9dqGiDqzEQPMv8CcLlXFYM0u1VWqHst
	 eYQXZNxrCdqMi3rWn/fTgLAjQLOER5cYg1x0HnqUXkhmyXhwyv8VsCBFuj85ulD8VM
	 skjsvD0IH4FcGFBw4wHjAu22N1ApixjX+u3+X2dvw9KLkzTMhIX48wKtx13h7f9RBn
	 PSu30cXkdkaUg==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 6.18.y v2] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 18:55:57 -0400
Message-ID: <2026-10-26-1-daily-reply-0006-damon-zero-target-value-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026134740.149027-1-sj@kernel.org>
References: <20261026134740.149027-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8EB7580012
X-Stat-Signature: 1i61izbgcf7tp199jc9mpmoby4or3h8m
X-Rspam-User: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793055370-978014
X-HE-Meta: U2FsdGVkX1/x2H3Nrlc89PiAVjQPWary2QsEEL8zY/CLHcPHcvUOPEViRN9e0yU8Dl2wJfefMyKystfSd98jMkHaYJpgqeADn/Fp7So/Jgnb0yxMBrtsqCtTOw36aXYct+rfwfenhzsMSazXeYTfmWj9yWK9jPB60QBVLQUxegj+9sGWBr9piLpG82np75wMq6m2ui9gH2KRQEHrDLGWj34+lh5jiu4jqNYz99Rjno9mtinXVrFcMnO4l1xlEVbRBS+jvG8q+HqKadUMnTmXw0SfpMeBrbLwVJRzX/1bC+MLXGOh6tq2X30HB2PVTCy5e13G2ww6RbDJ5jYbnmgJKI20FeZO8LLtrKR22Xd4GFBufGN6RWpYKBRbV6USAim4Jyv75JYbNE0juWPwx1oIsvaLJ8vGi6Y/fLLKW9GeLjKV6u2Zgd5mHkNjXBnp6VXXkroSWuivCYq9KITYwNjLaHLtmGsSnUnRQoskyy4qB6rhSfrQ4rz2lMumTuTrnnH6zYvfH02HZp4VEMnRUWx+zGcfqHEEq3EBIWAFsSkSajGXDuuCwX2UKMu8I1Oe1+M2qPILh9XI1QqTKHSSx8Mh6k56qKH3kpX7QgNPue9QK/9x5WVTkh4J7gyIRqz3GJLxoik3Ng3z87lSwdnH/FpEf5bIiUZmRtOVCYw5D57Gbju7rmmKiZGUDwkwf86oBpidZi5t/9FHLfwGdT9KTAEHCnSz4hC6Bt5gG4mQepS3ffB1UaRK8mT5WDiMMpdvB4QbdyskBWA89v7tSmRwOudJMizgKR4EhuDgMRskoKQLUoKNLD1laAPLfR1mgO2C23HjYO1UX8UnqPJZz5dwQT9DfQs7rhdy16kM03amPyPfX91hViJzUukjqSO4yHqswCJxiIx72m5z+23A8gJZUHswRSZLCO3fw14tNKZofrARvzvbMDFGSISCtJF9O71GDr6sPe6eqaaYKLwczii1VN2
 dxMLmmV9
 SKyZQr4bQofu+p7GpjWTpP0X9HMUY+LEZyafhDdipjxMAJhE+DinMSmugPysYXFeRA3NHevPeuweR7ohSZGGKGPAS3kKNOuyDGhFF7suOVpEoK42rNJLpvVYeDHQZqkDLn8rgVF4354XLdVyGwti8LfI0psJlGz5nNIUw6c1ZPitAw2sjWYLEvJLzsa6CGe6/PvxMEkgUp+1pBAAroZAhBTPux+U7RuQHPVVA9w3m5xglmmMJp4AjGQBEmMzFE8rST4yU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Also, the upstream commit on this stable kernel can fix the issue for
> parameters commit paths but DAMON start path.  That's because DAMON
> start path does not invoke damon_commit_quota_goals().  To fix the path
> with minimum change, add a new small validation of quota goal target
> value before damon_start() call.

Queued for 6.18, thanks.

-- 
Thanks,
Sasha

