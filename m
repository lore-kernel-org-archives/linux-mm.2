Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5F2606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 17:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SPts2HZ2
Received: by kanga.kvack.org (Postfix)
	id 4CBA26B05B4; Fri, 27 Nov 2026 12:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47BA36B05B5; Fri, 27 Nov 2026 12:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391676B05B6; Fri, 27 Nov 2026 12:26:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 150606B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:26:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D2E0C03E5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:26:44 +0000 (UTC)
X-FDA: 85481578728.21.BD6F343
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A9D34140004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:26:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPts2HZ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795800402;
	b=2Wojqj91P28mr1pfrvPKjPkof0qWi+sVJOHUIZ+aFhSBumyPbfNbeP+sMSFSy5zyYGwN8B
	tSbholIf8Z5E7iM2gcFSM1BQPMHhHiKe6iWh+i79FGv2k214Y1y6j+y8g29uoTiF0JU8nU
	eL5BK2rC3OvLbvT595D7SPRJFmZHeqs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795800402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XHeNf6dkhJt1onpBYytmylIIsDYpini2AOV7gcbkiQ=;
	b=GDtsDWTDr7NiIXLGNt2AIIKLh8u/O03Zzp6L4QI+v8PmMLPXlKtCamwiB+/1lJAClJuIIa
	MK+K4TVUqs2SAH2wTW1o4mmV0hQX2FTY0CKZX6q0TF2l7NbSO8mSkDG6hhSVSQaZSz71hl
	EajAjnPtXKm659r3orFa8pqILJ5cUvQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPts2HZ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B621C43F36;
	Fri, 27 Nov 2026 17:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B3A1F00899;
	Fri, 27 Nov 2026 17:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795800401;
	bh=3XHeNf6dkhJt1onpBYytmylIIsDYpini2AOV7gcbkiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPts2HZ2fx9HHbsj96xKZ5JkPvbMxFMiCsuJqX40UgUB41Tk5iKcWEy88jd3gIr5G
	 PEmAXODN9mTm1Oku09ou3FReTH2j/a8GS7OlN7+UsiycXy0kDhHyuYZg9qlPOH/Zay
	 phuMzu2TLPHR8xuHYQmNplqQhlGFKdz90ajuFiTyHia48TLQZJW/e5ZoAnlrJiLetC
	 2NLN6reXqq8XxYfUFMCxLjchApqd9opVha7opkx+rEWkbh7CTD/RfL5L513spIN5xv
	 Jqsm/+5zx8hnQK+d2YDEqftTVpEAqLjcrfjPtm/dPOeEK5XSfXWhJQcMYB/FGE8OaG
	 i0GfUpAtH39ug==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/4] mm/damon/sysfs: refactor state input matching
Date: Fri, 27 Nov 2026 09:26:23 -0800
Message-ID: <20261127172623.88602-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127022945.8243-1-lianux.mm@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9D34140004
X-Stat-Signature: dydh8s8mnqaeoetdcizsuqawmhhrnpbx
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795800402-388424
X-HE-Meta: U2FsdGVkX1+ucm61Y4crCEvoURKT1N8ECD5dzc+2UHeWhds7ZtMT+Jb/yfwd1+KOTx4ZWhHpo2dNcSvtNOVutj08JFsf8glhHQDm6vtrr5jsCg2IMkwzx182fiOPHo9m1hmlSVymrN9lQefCom0/YxrZ3lKmDptjkrvQMSwUbDkw6B/p78HpZAE9+uTn6NpwBfsCEMUVv3hImKjk1DIW3anfhFZ4ReZdE/uKA50xiyhHMcrV7KwFos1HQHsinFZx/WhtpnBgjiJE0/J9XTHnHByJOL4YhNRizbxjcefBV5s2xAwANhH+GJHR89erZapsLKXld1zQ9QwcHF3XZgz0ssxkqNRmoXLC8pYQEpKxB4qfC3s6qV755xmSSFwuESZF6sX/o/2WpGhxJcj7/1vzyPqmafmYnWkNMiA9e+y+OXfGFys+/zF+qBVmUN0Dy/MKxLgp67r64wzkSSqzTe/LDfm03cy6uL4J69aywQnUaaP5hVPZNADtPn+louUqAQwj/6jcB4LMR4othF+fmr/Q7Bd8Pasc+FYzLoxo23TS0lV0jou6SIQt2kQ+9URYYjeA1JlbqqjZh7gvSdx5LCLcsnE+4zxypO2l8Y5KCYMogeaKrW5v7JZLuk8NBu8xkhnQsFmfH0Gt5mWb9ls+9Irxl6ElPADrdQHycvInIqIG+gNmgeWwkffYUbOkcA2K4+VmdVp8u4gFFiVaQkm1YM2718PqROvD2wdvAs2i+0JjDeDMhBd7IuVh0UUls96co+7G8XJgzXb6uSd+21WHC3wv7p5aeknlXeCQ3tW7PwzV6suBcn39vb9Iz8UPqyLN+FEtlTmvltbcz+b2ossfQFAYMpOg5UXwuw/tTH+uBGYZLKW1/N6Wb1Od+UMI9vrHRoejuLr3ViGOtUKMhoY7iW88tuO8hGOq2w3mHfykQ6MiVskJxNnWh+97qSuXpABlnpXhvm+tdHmwxiQpvdNyEMm
 VPzG7eHH
 82PaSJ+BJ2y5W0p+n4mKGmHXtcDSUmyab8PjDuwfD7NgqohnC/is+tjGpeX7SxJkcY+RwAKDFpAwxdjR1e45i6rG+0YPKLpvtgZ4eMeA7RjZIYQLQgAMj4Vk0Uj3rZeqSiA1viD9l0yQyhzC67S76gIkfIxo8c+GLpbmSKyBIVCdV+ufycLFdpzervKPhX7FpxwuIuaVYjWHkI03Ei0eAjaEuDr/AhTtCLS/F2fzy1ipZnFQhmqlc3c7/0UgSlk8sp/Xc6n4+F85e5vEIJ2S/9C+j9z3N01A6q18h3+iWoDtP5ogeMQxifd0PU+DTNPDrvFXTlxwG1w3nwFF5UADcuMj8HA1ve+yL2pi+bZ0ay/ZYBc7a+o73Fe9pw+Iwv2sJcA2g4i3Vy8RqxmRuQaoDq/y3SnKvNVdde6N7ms22TmjIo89vPE5lUuND2y1CiyQvnzSAuLYcSE+Qw8k7kfdspDOnxfSIbF7SjmJRoEYBAgcEmRyNnyIgOfCe1qGL1Wr6/nMjjdpI91EtKSlJC0G6ZA7tcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 10:29:21 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Hi SJ,
> 
> > It is easy to mistakenly make the order broken.
> 
> This makes sense. The explicit command/name mappings preserve the existing
> commands and state read/write behavior while removing the ordering
> dependency. LGTM.
> 
> For the series:
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thank you for reviews, Lian!


Thanks,
SJ

[...]

