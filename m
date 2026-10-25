Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F662606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 23:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X/n6M6Ga
Received: by kanga.kvack.org (Postfix)
	id 92B9F6B05B0; Sun, 25 Oct 2026 19:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DCEA6B05B1; Sun, 25 Oct 2026 19:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1886B05B2; Sun, 25 Oct 2026 19:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE826B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 19:30:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAC77A813D
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 23:30:09 +0000 (UTC)
X-FDA: 85362744138.06.29CAB65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 347A91A000A
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 23:30:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X/n6M6Ga";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792971008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWx6l1uH67lmRdxqqC1BqRd2rIEg3mHZHVhaXIsbxyw=;
	b=CGhdU55jpJeSnfPUg6pzlRx+INtB37xhX/x3FokGPEV+t45hAZSo/ulznCOzXSvmq+QPSO
	f6g5BOge4amTDIR+VPREZTR8hu4eAVT8QH/1hIO1FVmV517yEyS5aAm2tv3gaGgc7BtN1v
	SdvT/nZNvYVrvjbkTYBGSjv50lcW1Ps=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X/n6M6Ga";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792971008;
	b=VN+dTkr7A20ZMkZXm7uC9dCcxJd7ZrTUMo4IYyHNMLhcfxi4bLIpLVy8Fch//1ysDbOube
	a+2dWIVvAUIIEBGSSc6r/5xkkRQ+9UHxLpfKG75R6kVhlqeqojQuMrm25bbev9N1QsuFbB
	t5hR8Cz37JfNa0ifR+weJRt/X5IjY4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9653040A7E;
	Sun, 25 Oct 2026 23:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47DA1F031E2;
	Sun, 25 Oct 2026 23:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792971006;
	bh=sWx6l1uH67lmRdxqqC1BqRd2rIEg3mHZHVhaXIsbxyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/n6M6Gak7qTGuZ0sZGYSKvc2PxcFkoGCnKt7+53wtrwPR7J6riwEySx7xxnOK2qg
	 sApWJT9kXgrYRi4WQZGO39X5F/PkGhEpPEu6KY4J3dHQzF/mpp4OEP9hB4HmzbedBX
	 42hhQB1z0+hbyQMSlu9rzd/IjPlDIRiBwgRb910FFI9SxZk6wju/bgver+aREj5THD
	 RIaJR17CIm9/Ehdp7HcK4oYmFNV0DLxnC7+rHKnq901Ve70ycNlYpIkIB6/N2XHn1P
	 sqZYSHaCK5RASMIR3fsYzbNBaL9jp+JugYxdbGibVMPRd/D2mVpIsDdTplj3E0dl9/
	 KcmvkdkXLMg6A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	JongHyuk Kim <malhyuk97@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org
Subject: Re: Please backport aedf2efd1897 ("mm/pagewalk: fix stale walk->action escaping walk_pmd_range()") to 6.12.y
Date: Sun, 25 Oct 2026 19:29:52 -0400
Message-ID: <2026-10-25-1-daily-reply-0006-pagewalk-stale-action-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261025054505.1448278-1-malhyuk97@gmail.com>
References: <20261025054505.1448278-1-malhyuk97@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 347A91A000A
X-Stat-Signature: xu5w9fzix4h9ijucyie9em4mgsdizrj5
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792971008-569130
X-HE-Meta: U2FsdGVkX1+FENOBGPZp76lWzryZzF16t7dv28Hli4mLPpr7sQeaBByMKBMavIG4qg1MNuxBfp4Z1MPY23466tHdaQo8lXtGY4ZtkbahujMI6tf3rX7HGPlvvj9uSPmF1pVp3tLtj6sKqvWaHgGhKayS1CIwE/Ok5+gCzLHO+4k9Q6kJbjk1KgKm9dvV4HOp3/dwvYrR3P4Z3EUsW1/npLEv2zW8NfGusqGHvFI90w2Kk4Kw9JuuaOWqJWfhHtKDfqNtRdiTqJU8/3YyB163155v/eG284+L0qvNZ9UZubRjOnnhn6CUKcAk1iBxiOh5UlZjRCv5KoZkzhMl4H3+2KN3VQuaElcaPE6gg+Oi6OEWOhnZ+mWoXuKclFDd3+0B9uZVOZ6yWEC2IUdNyM4kdOLtuE0XtOZ4NH1ZK96xvcgCGksrYbecmecvzTWWc00xJCbc/Ldoa668kP/p/sJZW0xUCgkYP6KvNoupry07BiWP9thPDn/Ri7pvl3GuUy+yt0J58zmXGMA3dyj+8PFMfufQaIna0bPXwbzFpYoARecS1GPuqiGjWrSh92A7Xa8it+gYEQWmEpxURYj6pvz/tuFU6BXoZRWtMEzD7jm24GT9Gx4esT2WDCdesvEs2LiYwmJZF9hUj/akYz10Y3aYAargFwWq/K/l0NBXaty54ROLV1L24x4X52H5YJDmN1VoBrSKQq7MfDtUFnFAbzZjxj9rPHiNNf8ilBPpdG3xZedbEyN/X8L56h+Pyg9TolQNkg5bnxhQ4DUZxUr++pqM1CkSwy6piuQSUQcvZH0QgSj0WYUHAPVY17myukeFqSVlRFFq8HpPNgvpjWPrNbT9JJVnoIdT4/tEJHkZNIe9dlhkLemy0YuYZH2ac4E3sn13CDvuEjvGbcKOK1i4hF1eB6eNjDvECqrUk4c1mY0wOe7YQebTheGyfkyWmuUZX1DQb0HTEDvXS5p9NNd9zs7
 eFF5d9O7
 /zHfBGMKS2x+9ScwQDIhlZtaaJJ0XXcgiyWYDcv025EvRQ8VCLkNzuzlsMjjXPrSyypbqjlXrR5cXE7jC2PtXEuai0wX+mqjmWDe/BeHGrwAApc1nk5xbZP1gQbdyM5wty4/70k3J2BqU7M9RzKSVHbVtvNPRYhuC2gCP+sGccZZ+dTb8QrdJt809e5ILjQNkKY9ktvIRrM1hfoA5Z4jFXwz/dFMyI879UtTuItC5WpZcEzba6Sap4BGrLbyrgkJt7rxY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Please consider aedf2efd1897 ("mm/pagewalk: fix stale walk->action escaping
> walk_pmd_range()") for 6.12.y.

Queued for 6.12, thanks.

-- 
Thanks,
Sasha

