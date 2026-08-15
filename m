Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5D8EC5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 15:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091A66B037E; Sat, 15 Aug 2026 11:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042566B037F; Sat, 15 Aug 2026 11:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC13A6B0380; Sat, 15 Aug 2026 11:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB21F6B037E
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 11:30:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 605011A0408
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 15:30:25 +0000 (UTC)
X-FDA: 85103890410.26.B16BB66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE0A3A000E
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 15:30:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/7mFSz7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786807823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHygruvnWfw5G8qNQHmRxC1emMqhJUV6dq/1C7tMYtE=;
	b=RuGxZT7SEncvOoJ5vcYbuFXlxllGnDvGhl41FNXHJQm66Ujc5dfELCdJKyd1+PnQAXE/2t
	SbLXAGuoT7QIs9ckWiiaC7ixHFkh4nUHq1n0fU6FOEX5zgiaw4RRA3prhbgzdCPwSdrnTf
	ceLZF+vtboLhyJqEePtnxGEq/AJmXZU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/7mFSz7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786807823;
	b=NPbfqdBp6Wesv927m1PJAoKQ6EY4DlWUnWgbL3+79LRr/neb3OcnSkzpEU24Z5MjHhnBs/
	gzYj7d5u3gZ8tf/J7kJLnmU6roRvjt27RYdGMsNu2OtaDMtvzrIUB8FPSgjLnmpo5UPt5I
	oTlp+8XDTIplcFVfTbYJ8++JYRNqEyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DC3B600B1;
	Sat, 15 Aug 2026 15:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9EE1F000E9;
	Sat, 15 Aug 2026 15:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786807822;
	bh=oHygruvnWfw5G8qNQHmRxC1emMqhJUV6dq/1C7tMYtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/7mFSz7zwhCNZu5FHYBXFRj5rNBIVRelod7uvpREfSzYxpuTqZfVkJZYDH2bXPWa
	 r8BVa3t6hGsPaZZGDcMYLn7RDhLEAfQFgFIlHJD4NAADq7x4ncGuHBG865C0BNcloY
	 82GxSUvdp41dHWbkUZuFFFJ5uz5L8mb4C4Ztn4yGsf+xYCco2fK3Q/Kjusn9iOhj/m
	 v9CcEo5RULwgEdTOWru/5h5kSliDJ0bZG/70pPjyZzraxht4q7ZIJikWZ14pjnhFFp
	 bq8I/tLbl3XJpORG4fNsSl82f/gDebhl7i8uA2IWUk8hSP+hAgkA9DEqmA8VcX8RGf
	 ZNaJSYY/WRo8A==
From: SJ Park <sj@kernel.org>
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/tests: use scoped_guard() for damon_test_ops_registration
Date: Sat, 15 Aug 2026 08:30:12 -0700
Message-ID: <20260815153013.93851-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260815143039.17291-1-jaeyeon.lee.dev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BE0A3A000E
X-Rspamd-Server: rspam07
X-Stat-Signature: xe1q8rqnxamzpce4jzuqbi1yesubp9rk
X-HE-Tag: 1786807823-600850
X-HE-Meta: U2FsdGVkX18+p/N4J16TaHhVWKKI37wxkM/7StztRNAfmzucCm+7vbCLBQrf/QJmdFxxn2qrrxiurLuRfUESVPuoe8VF5gB5H2UMSO4q0g6cTniGdrrt15SWYBIGqr3/3vZmubgM6Wm8Pe+jV52FlQzHQA+mDnzeGkr8MvdwG/NBiG4lskqB2N/EDNaKrR5aa+WiL0O8B9iqdRvIvDF/yPyDQmTlBhEmr+xOzXxZAidQxfd7OBG3yKil9LomUIVIYVWSpLzs14s5avnyrvibuBnZNJPLefmXD7/MlaNM1lpNl8CKaeAnXKGnrbQ2TcQ5R0uAsPItrlR7pf9G9KT/UplP/vGgV2mOD8lkbhv6ZljWV4geHtltkaOTj0Bha6hqUohkoAegQJfMBs8vgHCbPPhFrIwx3O83zqsmDYZkBze2HQ5IzklUeLxeef35HYahFfFEkwb8FKJreIipb7hHuw2Qqq34/EfZaemEnkd2+U8glW6VrFv9DClf4BUU9IHYVc8qXpBZ6HX58u/1TetdJume0nQgcGq78byyXTBwoTbVh8PL8WWIRNmA6A20YHCkWi+PbQ0pKx7hL3oAvWYxsjAqNe1fbCe/mCVBAemz5BQ5KGj2bnXrbrIx6EYSQkssAqYHGTIUVYD/LI6JzzVEqGjo3+BhyrwQgVfemb9dy4690VdvHcmXErgN/9jD3K5/0yHZqHFK/3/Nyu5YNdksrpCG1Xw2TuCUZuUK4gRs2QzP4NgLrR/klrFC0YyNvMGTcsPRyz1YwHkl82IyAmzxNSOFio8EWGhpWcE9SPIci5KluDt7mFt0S4efSE+kjw8PlFeb4biHqGUDAoKjoZ5Aesi9GZdorq4KjpdhL21Uvv6sC0qAF963YVj63fhl6K9GSOfMShVxuvtjJZv2+WvBJ9DNSf59FIT27dUhRRsIfw//piZWJofBKlOz80YmxWmLecYKrAMSICIvPPafWQJ
 m8KPxMLW
 DGyE75qlWvdDzVroPp+TuSlkeVxebOadc6h3jUAx/0yIorHiYW24pqzl4S+HtBHPX5uIxg6EtmZGH25+hN3KLqmm7K33UFYZYidC4kQ0N9H12p0W/yzqmNQ6UatBEXRWtcgt0kbxWCAeL1pG0Ft6KQSUZbwO3lXsWE2poHoTllXlBYdTLihRunLE5qkziWmllplHfIO3I3Df1q6nSEIHvCDutxcst3SY0jcXxd7xejuN7/9pWFZnJr2UhL0+nMKEwNm34XabeaXZKlcldpxgckk3mc3UvSMM/i8jFGSzmR4t4dzH+Tjd4UMkBS3TLWjdMR+9YH1md8dwzZFmtr792I1kGkMYDyCYw1/m1RQ2mGi+Ii95xV1gFwd5jeMz6mO4vgXrXwQlNa/B83StuqMC/wnJGEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jaeyeon,


Thank you for sending this patch!

On Sat, 15 Aug 2026 16:30:39 +0200 Jaeyeon Lee <jaeyeon.lee.dev@gmail.com> wrote:

> Replace manual mutex_lock() and mutex_unlock() calls with the
> scoped_guard() macro. This simplifies the code, improves readability,
> and ensures that the lock is automatically released when the scope
> ends, preventing potential lock leaks in the future.

I'm concerned if DAMON community is not familiar enough with scoped_guard()
macro to handle it well.  At least I'm not yet familiar with it.  That said, it
seems using it for one function in the unit test could be a safe and good
start.

So I want to have this change.  It is not because I want all DAMON code to use
scoped guard, though.  I want to take this change because I want to see if it
is really safe and easy to maintain.  In other words, let's not adopt scoped
guard to more parts of DAMON code, for now.

Thank you for introducing scoped guard to DAMON!

> 
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree.  We are now quite close to next
merge window.  We (mm community) want to focus on making mm.git more stabilized
and therefore ready for the next merge window, rather than adding more changes
that are not really urgent.  I understand this series is not really urgent.
Hence, Andrew might not add this patch until next -rc1 release.  In the case, I
will request adding this to mm.git after next -rc1 release.  So, no action from
your side is needed for now.  Let me know if you think this is really  urgent.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

