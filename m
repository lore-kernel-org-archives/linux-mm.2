Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED9C3C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 00:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A646B011F; Mon, 17 Aug 2026 20:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEBC16B084B; Mon, 17 Aug 2026 20:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01DE6B084C; Mon, 17 Aug 2026 20:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91B716B011F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:29:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F24D31206BE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:29:36 +0000 (UTC)
X-FDA: 85112506752.06.81CC888
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5302740003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:29:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyjBkgnM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787012975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtTQr5IlXtVj7J8XxXqZZ2zn2UeRMroo+5lXnZXov30=;
	b=dskOW+sViE5LV+Bysk0gOk5ReZj638i8OQiHVhp9tvLMjt6DhAl/T46r0cp2oRacm8eEyy
	kDJ5JmQTiLRHlqDSWERVJwdeQoQ8H6p+GM2k1GLYLlXJ7E7strXh4KgcvAL1AkNbNSMB+3
	orURBbk6RtfJYIWLLegoz/kNAa80K+8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyjBkgnM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787012975;
	b=kW8HkKfOeNRIp+XJp1wIyv3KuYQ6YHP/QrQyi1dVUwmK0ciTRVkoglDaF1UKYTIENe2pfJ
	Zoh3kGbhbh5MDF9GtgdqpVulMw98EH2pY++aQUdnWGaPZU1pU8GhqbkAA5wPmEZyXvI++a
	1Oh+rtswJdxHyLZd1e8eCeOpALIk6+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E26E43BFB;
	Tue, 18 Aug 2026 00:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DB01F00A3A;
	Tue, 18 Aug 2026 00:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787012973;
	bh=rtTQr5IlXtVj7J8XxXqZZ2zn2UeRMroo+5lXnZXov30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyjBkgnMk7z2oJKXEmooUbi6w9qUTcBWX3EoLcwL0QCTYJI7LJiTDFj9JGUUvuJGN
	 aJRwLROuUx6vtUutCI+cj62cXpkF4qE7n5SBdDBESLgygkTHO0rvQ79qIgTBEiYKd8
	 YtphffrLKKUcvsRYucdmnzxqZJqijoJhh/c+sbboBsOvbdJEPyXMyRA+tsL6Lbs3Xk
	 mvna/Of1oAYmO7tQNTh523fsU5XkKWie44puph82NVZvqK3h2HOnMPkBqOoHUiHl0X
	 zTNf0eF2Zjyo75ELRxcj1yf50mQUSEVWvVmIkm3/m97L5BZARJbx+Rig72AdcmBgP+
	 3iqMY/dUB9p2g==
From: SJ Park <sj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: Drop redundant open() in mprotect_tests()
Date: Mon, 17 Aug 2026 17:29:15 -0700
Message-ID: <20260818002916.87711-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817080616.52946-1-hongfu.li@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ph79zd6fn648qd49y8kbzexriojyg4n
X-Rspamd-Queue-Id: 5302740003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787012975-949029
X-HE-Meta: U2FsdGVkX1/o++M0/jq0Qm/gnM4ING32tnEqT4Crpi61oM0yboMAyq+oZjXaKPUrTiZ2iurHyqbHHG5RmbAvThR6Ci3SsXXIxh6UeSOcy1gDPiNeCY37mzgnBefmCIeie3BRC3Vta2kTNkHWfvPPLHIuAHNmTogxYTi/Q/hIy5Om0dBHsVQXQFMQogIaNcRoag6PrcAc4e8pbmIXT+nPVEDE82iQ3WQB+oK7N5U1H7GgAOGZ0abEBawSumfJLvsSP3V5imIJN1LecWruIy2tG93Xobi8nfFVblFHO8WNtOR6ZjJeyT8+K8g5GwUTM8Ms+zHdVhxNngoR8UgALGgXYMm9P4gCnKt1Ts14evZ0BgaOpFn1tyhbjJxefdGPVI4IUfIzyVJS+i5I6OJQGVIOKUX905WslmV7ebzCH9Egvr4ryjAC4qBs0bbpdTv4wOe7+loM/vSk3f2dnofS/qebhpSaD/NdPvRKGQ6mOWimcx/z1cgFuZ3xci7zX6uE6Rv8hKwS3FhXpxkVCLswS9XcFwLxNe7Rx0xYgY/SGJ1FgVYsksaZf/kBxEqfUjzItEHXBygzztRaTGiI0mndd+g83vqaenI7NUxeuUge+DsKJSF77DOjTBmJiQ6qsTHE8scd8JlA2LXPg0pEthYdrkWR7bkKq6vpX7HrOJge0alpV/CoqzgBeAmgC6S4qX08+9T0jls4OwcfAD8yPI55heWK+k5bvLaBgw66ECDKBlcF/5cFB2AnB/WiJ7d9HvZ227LipZZKQ8Xm2DsqB3mfMce+HfhJbL29p6XB4GsvACF+hpl/lKzV3iaUsar2kBVHR5cDhCBCXfoGu/SUihBeij2coSNr8CitIErZK9o0HcC5SCXwIDnme0kLxHqs9CySnyWkPMMds8Ita7CYtUlKzfoQuBri6lKcqTHq9R/4bGHb+n4xuTHd/sLUrK0OqVmgLjcTOjOlRb0KeO7tfoAyreK
 CQwtExGK
 JpGJwUUKfyLe463NCT7Aqe8L+jKPAblS4II9p8mg6/x7lvH4NCaHbHFZ9hAlkYwCEuHjtIyKn31inQjcdlWn92XSxB7XXTqrXHG8I+lhIcMQI47xzYCqZnalJsyUbwbckufUJFgLuPX9ZtEblJs795W4PMg9XyDHYgO5FVa+dDYwqzCz29fXdkY3cEUAJzZLUwAlSDqAurQk8nip2UZsdMfUUDIh4Q7ePk4RbM079foPrZY2yF/1ztJ+jxMW1/VYq0rsu3dJsWg4zDEHnT2KUf0db6NnXMkOtfHtWCnYxMqwZn6ddCC0n+PrzNkknEUyZIrbP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 16:06:16 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Remove duplicate open() for local pagemap_fd in mprotect_tests() that
> shadows the global pagemap_fd already opened in main(). The local fd
> is never used in the function.

Nice catch!

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

