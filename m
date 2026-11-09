Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 978BD606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 00:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cx99pLE7
Received: by kanga.kvack.org (Postfix)
	id 87A326B00EF; Sun,  8 Nov 2026 19:51:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803C26B05B0; Sun,  8 Nov 2026 19:51:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F28B6B05B1; Sun,  8 Nov 2026 19:51:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 477406B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94B45A6592
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:51:16 +0000 (UTC)
X-FDA: 85413751752.20.06A94BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0C3EE1A0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:51:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cx99pLE7;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794185475;
	b=U+pM+LCIJRMWdcDGJyofLw04ENba/9eQYjMr9oXf7Th2eKyva9BEmcT5tJq2Iy+wthpkx+
	lvnDy76AgE2WTZHtLDWbQWS7YzXu3cj1TMxMfHbyo9QhC8qpbsorcno8UgQgVEDfa+5fRw
	BcNsHZHvk0lBfVkFq/e2znYpFkIrxjg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cx99pLE7;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794185475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNYpZVkWRff+ctPGTKbnjtC6bk8Ke3uAIy1eqQ5b3w4=;
	b=s0z6WOGmt2gYqNBwTfw+RnTkNGC05OMYbt6IRDl9JYtr4QFBHlo89AKk8QgMWFz3/Fvp7n
	yLPPz5q8PMkpnnLVmelO8hXyuh06xt4IC/426F2I46Dj5C6lsqp+SX5WT/tzW/cEEj7wt1
	7mjaIBsFm/zEl3R3qwCKDyZHYL26SD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F28C40230;
	Mon,  9 Nov 2026 00:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CE41F0089F;
	Mon,  9 Nov 2026 00:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794185474;
	bh=vNYpZVkWRff+ctPGTKbnjtC6bk8Ke3uAIy1eqQ5b3w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cx99pLE7MNZnSiz/V0Tbf7PqC8O606hcv/R77eemET12NiNbuJcvEwfNi5Y392ske
	 Rb00uWu/d6PXLd/TjB1ipe3rFPsJTgxsOkFWujKrxiVUOOuJeEX4KDQjyMC5lzmr+b
	 zy77UvQNNqVRPOIawUAU3Emg5wmputEby140cq7NmjElo3Zi4xURVC6HFOmJBnP+d5
	 Eejm/plWqt/UucnDNHebAjOI0yBMmV6XTtxp7gjksAwr4+jhZX4j8PClZTTZa5Ch5l
	 DUo1q3n8v6jJ5OvuPVxUxgP4LenHLXoAMHKqWxUakHUM4r//xH6SxsJq55oNdqvRqG
	 zSFvJfUqTUnaw==
From: SJ Park <sj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.18.y 3/5] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Sun,  8 Nov 2026 16:51:05 -0800
Message-ID: <20261109005106.77748-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026-11-08-1-daily-reply-0006-damon-6-18-sysfs@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dzj73863dsmb5fk9fenkznq55neh7mrt
X-Rspamd-Queue-Id: 0C3EE1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794185474-56136
X-HE-Meta: U2FsdGVkX195kfRNrkthIF3PxmrYLBqbmxd3GTp6jzUXZG92dxKRR8qlkKPhyrK+ADBG6qTrrY8g0rCUPjbDT+STbMDTC85bmJWxMvWRwZs24i85deqkufhsJ0u6e4jq8jT1eOwCnS5k57Z4vtNCu0imGtcitXYqIpEOya2HFEj8Z67opTJv77C3Vr9sOpG5KQTQLPosPI97g4ydEW1XGr7WHL3jSIjWQSTVvwChaeo8dwBmXECL+BSUhxRnYjrCnahhgc5tOuLpb6yB/kONjOHsPNRNwB5x1qKxYXi5bMReOuNR8qEZ+UcZvEMh0SmbnQ0LZu9BW0+FBKChTXYtxWwMZDYGOzvFpua05Y/CILq/Mc+7BAGOAyt+r7cvl9nxLKBV50pGttLSUTJK1eDvWkR2Ak0FSNYUXbgbF0pSeJngKCg82CjT6ov8HXV0P9eCJwrGNLAkH2LL558UPCMdMszPwgtqp2+UQmg/JeZjTgmOXN7hL8tBpBjfynSkrt8EDZp7dYGmOl4t2T8ew3YAjvlm/3PT0mnoONqRjxoldRA0UwBSMKulJunWrVY9nijeLYAXF4kc+ulTyg3DtMm+KnDeFy5tCoMbdSvWsFgMNJu6PfzKozBir02kH4dVKaHaIEFXcMWPcfs/uQjCRUy8T61xdVTx+jfCcQwfF0HBk7ljXqjBx+713xNSb1iABpKhA2Sl4+yeDWvPrcLKOhjjAwRFyOeJYvc9Ew5tzLLJzpgnHanHd4HtnUNZTfFukfvVR1qtvlYSivSirg5PkYXtDdzHXSbykbWBZjvIoqWzzwlQWyK4AUclJcRGYnw4cKiMw5vzkNxpiKjGCUqAP4GWADlLpODgaBDa3aG9+XqsRzeZrevpeIIOI8u/UpNiiZZH80PPA3kLUYJX+Y40PoKtHHgKGAOSKB0oUdk0TDPdfVt5xaQnTVY/3Fw+XZn0On7oq0uOsErEKiq0TWsFxPM
 solngsbO
 v2Smvu4QlXZff9VuaTgn8cVAPg+RefhKJACkHiuFfeOztp2981bqMpR3R+q5nJFVdWjmb4+74cFV9A/uCmtqsLgq15xB9Nva3WNAI7I/B71gNebOPZwKQNtKVF32nEQlQNYBzfaubB8f9v2ODWRBGXr6GFCzD6shY0nUoNc4HddofrfhW0BzpblKL1828q3ptj36LupOVw8g48HgGbroXg4c4b2kDBUk45cHHSNIsSyGlQmQoxT4Z9nwMrBjboxtH9iTn8J+rZYvd+NqM/CZIxA/Bng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun,  8 Nov 2026 19:34:34 -0500 Sasha Levin <sashal@kernel.org> wrote:

> > DAMON sysfs interface reads the user-provided size range arguments for
> > hugepage_size type DAMOS filter twice.
> 
> Patches 1, 2, 4 and 5 are queued for 6.18.
> 
> For this one, af19aff38d6f ("mm/damon/sysfs-schemes: read
> sysfs_filter->sz_range only once") is also missing from 7.3 and doesn't
> cherry-pick there. Could you send the 7.3.y port first? I'll take it for 6.18
> once 7.3 has it.

Thank you, I will do.


Thanks,
SJ

[...]

