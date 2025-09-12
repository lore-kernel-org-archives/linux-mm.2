Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA42CAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17E48E0006; Thu, 11 Sep 2025 22:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFA78E0001; Thu, 11 Sep 2025 22:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C588E0006; Thu, 11 Sep 2025 22:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEEC88E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:06:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DD1B1DF483
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:06:26 +0000 (UTC)
X-FDA: 83878958772.28.89E9190
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id D8201A0012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:06:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YCPcERYv;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757642784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oe3aU0JF6aw9oOc18cNbqUPa5Jgh6r31v4d4FRmTCTM=;
	b=7qXglzuR+XD3WGQ2nZVJw4dQhVVzMc4F3lpw0PKKslFlgm3jqthPa2L8Dc2QkJ4mFrTlp0
	lyHeoeJMBgdUQ4UVckEffBhtabwW6xt7uSYA8B8eV349uFcmaneIzFRmjO0l+4wDWb+8A0
	zhOMNyFel3MiyuxWLpZDuNfQCNSH2cU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757642784; a=rsa-sha256;
	cv=none;
	b=2j6oPKqb033vNvz/tFYy7AqanG6vQbotMfd2wrYWU7In5I0EEmbaPjR23Ig41bBSylhdnv
	+tiXlG7tuJoJUGciaadwQgd5IZ4bJ1t427NKR/yeJa2c7NjvH0lN7Jwpz+Nu6dQGjKS3/y
	TAYYgkkE+o8vZx4L+mPacz6uras1sDU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YCPcERYv;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CD5A860147;
	Fri, 12 Sep 2025 02:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FBAC4CEF0;
	Fri, 12 Sep 2025 02:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757642783;
	bh=wEWmhx5I48s/7JlI41mY1TFXvMlPvtQErgtyGu0ct2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCPcERYvQkcQ7m6OKqSUY5DTahcgVHnZj5Wu21LbySTpf/HGgKguvEpe+UxexaNV6
	 huMHYEAVWTdAaGBJ8gXRO3VfSA3IsTGdwE22SpJCNYrdqt0TQsgJiSdLjvuJUvfqmw
	 q2E11V6jLVEemLPo64N1sEE+K0L3W842PgS8TIqDMP7gssBIuQVAzXqhFtkB2LgSuA
	 pF0lemEq/lUbBL4b2J2XQxr3jlmoA5SdliEzyeToqlzttdSUYFOK7AEVWh5d8KrV8V
	 Sr7RJv+2dGPFLHFH0zPi+LHsL06Y4+R193x+APbk9avb7ZRdLN33wLyjCNNpfkQtR5
	 nfvxtPFskPMyg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/2] mm/damon/stat: expose auto-tuned intervals and non-idle ages
Date: Thu, 11 Sep 2025 19:06:19 -0700
Message-Id: <20250912020619.59642-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250910040022.168223-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D8201A0012
X-Stat-Signature: q7kk6j8ufck9r8xdnc4i6gzta9behwtq
X-Rspam-User: 
X-HE-Tag: 1757642784-561683
X-HE-Meta: U2FsdGVkX19Qbz6bx7wQuTlzaQq9HdlZ1/YC/Fbro3dqFmHdg1KjS6uzZJQoaqe4L7Tu8ug8QBx8Z4+cyEExpB91Ij7WYfjLuL5cpdNZX/3DPEkzxoHZ24lbrNjsDstLzU/CuWU1bHy0yueJ1Tg016PI1k03CFWhlzk/f5PRdpoU4wvUc9PokNjJgibSYHwtWDTjiODSIinSfzsmaEoWaWcnjYmgxx6ZS011hC4AStNhnLNpknKXrsKwtd4MaYPpGYlwPRDmuVxUQULib1EzIhbV0SCZ9zrtqi2q0PPpACeCQwyR3rl2eTMpDpxPDIb4lmtVi0tfJJ3tvJq9+ju3eiEgKhLSwgZ2NcNWQ4zLYQTf3uuuC+fQRsh+0P7r6neu/uZUqlIndb2uAFMtDy6RedgUpR1IAUdXwliE6STBvVWLuhDHmafYowndESQswSIJySMl8T7+bSreIH5nSku8n8QjF9iqehP9bzrwEWuI6h00dtIHEIJqSPYtVFdmbg7iCmc2owuBvkzJIa4YgGablkvYidsJOeqrnn/YC8OgVd3LJvWhMixCQcpXzm1mwNfXtU2uXJIh0IsaiJV8+68Eqk4bxxWzNPamYcL7+sH7Ut434315w6657LGbwoJ6dc+wrdWqpUO3/ktf59RFpmdEYJH9+OfywtzvSVj7TbpSGczY/TZLt7xo/jjiIg5EMzBktQyCjLczt9tMJRDvDyutYRwC7Yh1jDCk823ROoLoZ2TpN+Blq6Biau6hg7HHKAs8TWh0M5UfnME46rIR/W8LgBY+dTjYqlF+Vpy7B/ZHHPZzHGYcpMApjL8zfUjUTxv6Cp4noplqvpasadS8LthsN8ikz4/326vFP9IpULJQd2ELW9PEf18lZz4JeKuxsc2H+f7vj+nrSi3fBHmLwzFuXKCpboGPN5E0gEvIyAB02enSvHhIVGrcOEGFcBLnHVsncu01/d1H/Ej/l0C2yDA
 KQaQlrdy
 Pw767HfcBcxu6y2Hl/DFxeavavvQOrM0Ox1arGeAq2/vTWvBF2vW8Iguke7R7AC+5DQ+XDN1Z5VhtJvqgk5wE7Yb5L2kXrrBuyYlCO7jY5t1Hy1Uta4ZhKQyYsue8NaiGcaU+qAqwFKgSh1BBt2jOOtQO4hosZnjQkRl1FG08aJFW6q1PZkLWno1/T4s4eA4Ex3dN/2cWIclGdry4h67zIFAYoRrMa/cdvMs7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  9 Sep 2025 21:00:20 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON_STAT is intentionally providing limited information for easy
> consumption.  From production fleet level usages, below limitations are
> found, though.
> 
> The aggregation interval of DAMON_STAT represents the granularity of the
> memory_idle_ms_percentiles.  But it is auto-tuned and not exposed to
> users, so users cannot know the granularity.
> 
> All memory regions of non-zero (positive) nr_accesses are treated as
> having zero idle time.  A significant portion of production systems have
> such zero idle time.  Hence breakdown of warm and hot data is
> impossible.
> 
> To overcome the limitations, expose the auto-tuned aggregation interval
> with a new parameter named xxx and the age of non-zero nr_accesses

s/xx/aggr_interval_us/

Forgot updating that before posting, sorry.  The next version should fix it.


Thanks,
SJ

[...]

