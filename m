Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D94C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 02:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB0E6B0088; Wed,  8 Jul 2026 22:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D930A6B008A; Wed,  8 Jul 2026 22:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8C86B008C; Wed,  8 Jul 2026 22:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF906B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:37:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1644B120388
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:37:25 +0000 (UTC)
X-FDA: 84967676850.26.667B559
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64884160003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:37:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WajQre9O;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783564643;
	b=aIDvjDKkJZYnaMJTV3NE56i6J9IwhohAypxrFe6H7h1RWg2F4AVTj6U9E7VzbKsiw4I66u
	ryEZd/SYQuPGODwz1k53yF8htdubBC1ZuqgVzE172sryIjPmaUrh/rwNZUy0wqPhFB5k9g
	T2/HRXIXtkkjJmKqAdKP3etLpRLujrI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WajQre9O;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783564643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JX23oQxCnBnBAcGpq5NO6ntuxDExUTVnrk4WKrffy8o=;
	b=XzTkrvF/8/ssO9w9KO6jo1wIRtjfFDJ34HOSmrjwTomD4PhT8e7lucKKcHqE1Cs2yCd98q
	d+Dq8VEOlhbNn4rGq15u1bBz1b5zy2pgEZXUoKzerw3vQiMIMoK56TbeuJXFxzpghsCWQa
	Z7i7hUtMtTTz8723R8k2CjPGdKTDg48=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5ABF6001A;
	Thu,  9 Jul 2026 02:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010801F000E9;
	Thu,  9 Jul 2026 02:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783564642;
	bh=JX23oQxCnBnBAcGpq5NO6ntuxDExUTVnrk4WKrffy8o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WajQre9OLvs6mRqXfZYmVtTC4w1/Wvl3AnsS8o/+HCGyI2P6dC/xWlzvAYa83yZBN
	 gBHqZMYCxRidUbGYVHy7z591MvvbfuXU2ZmuDY9x0jbjO+W3hMp8QuhAHYHLl5JO5b
	 1DDN4kpF+eBciN33ilBDk1rPLtjCHGxgCpMKRf5w=
Date: Wed, 8 Jul 2026 19:37:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: jgg@ziepe.ca, leon@kernel.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 hongfu.li@linux.dev
Subject: Re: [PATCH] selftests/mm: Fix memleak in migration benchmark
Message-Id: <20260708193721.5aae192c95bd8c7840e9c1b0@linux-foundation.org>
In-Reply-To: <20260708103705.840679-1-lihongfu@kylinos.cn>
References: <20260708103705.840679-1-lihongfu@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 64884160003
X-Rspam-User: 
X-Stat-Signature: ybmz6eboywmfht1syr5cwqw3rcz4peyp
X-Rspamd-Server: rspam03
X-HE-Tag: 1783564643-603294
X-HE-Meta: U2FsdGVkX18BiDUKymIJDNhrcRG9DvsEAejSERsIql0ke59dTlhyvqEJHjO/eanr86Sra9+C7WALB/E4tZ3PBoMf9klV8XkxXO44iEVK4yofQuyecbGk27KO1+EeVIQeTKg6hR4BqYZGLioTvDcik2hTBjrnkMGz0LAW2fAVa/TGEtCZRtHSHsarjUgbrYf7I5Kl/6oTiUgUiXyuR5BLOVpynGz04s2U/vrdcbSCEZgFc9RUmAzYv7/U1hncuhEMfzww97w5mDA8JylNJDm7ZCtOnJblrYtjv3OJjriezdM/OORf0RNpEGKzIFRfDbB+fUzW81qjqXng65HmkChu00iq35yfJqGPbPcPVYV04I8h8A2GUVW/OKHGtAo538vqSwvbAAtAAG9xg0p1Jdt17Mj5Xgp5QcKK8KDn/jo57VrrZ9mI1mg3CNzWHAcc75ExZZLhJlcMV2R1EPh6688NhLtVgSLQ32VOP4rv8X4TcWpX1iT3KnNbBNc933BGfYuNQaRElQVp+XMLsKkuCJf1HNv2gGYjj1rOkQkDToTEyMuzaAuFXuYbc6cmyjHzO8JcopYlT/z9Y5uG24tKFF7UPlqghfRemTQeyzi8a60MEKz46Z27ljYcaXpatge2i0RcGgk2+PI2M9CKGInys61qCljauutbyuf8K/493KpofzWDeYGHzbLJ8S57Fu+7S4mLQjDkmDlft9dHc39XVd531n9OdQHPlVzO/txO6xDt7VNfoFyB98Ji430ZujMSkOMwFur8aH2T0nAjUBKvQ/tmDX3FMjv3rmtkWwfyVcJ4Q1xrZtek7ofw81y0XYZy+Rwif71+l+Y8ph8PKy3eWO+tYLA3Q7VSA7sRs8jQnYQBVl7ZuKF45fgmjO/MkUq0F4QJP3WfEl3Kn2inQZZ3Ih/M+jlxUBzqwa+RfTx39gLncntdCIy04KTOAV1DdVpFHFVzEUyOigh6k/boPsauWGB
 jk2M+jsO
 bcu2wiml/PKHs00qtCAh7kfW5EuL5dfF0GpdPZP3GNBCmgCGOPVMd87cJfD0QuNi7ju8rvdRtZZlEYreoXISm5kQJkxAMy7bm9+sofrbg4kommBTawFqWkDZoNdwR4ZX3mjYtB2fKpcsPgpYM1zyXQzou8WjxHY3WAnxMk55s45bLCu2/x/RuS8/sVvnDCZDsSJjufeu6O0+Nl2DgBZkoikDXKhjnSlAC3naO8GpRzsjQ+UHZ41QzljG6pcNKxdEwID9prcgLc2GV6vwYJJyeuPezH81P2xPJ0/PQyjz3HAXSkDHfLkVA0UoJkRvgiagbWUz428LoTUcmqHZw5XcuQTUWI3q3bv60W7wYsgVSgak/aFARq8ddfDz4tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 18:37:05 +0800 Hongfu Li <lihongfu@kylinos.cn> wrote:

> Several early return paths in run_migration_benchmark() skip
> hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
> label.

Thanks.  Sashiko found a bug:
	https://sashiko.dev/#/patchset/20260708103705.840679-1-lihongfu@kylinos.cn

