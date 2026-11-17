Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59320606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 14:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwWoKNgX
Received: by kanga.kvack.org (Postfix)
	id 695E66B05B2; Tue, 17 Nov 2026 09:44:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646D36B05B3; Tue, 17 Nov 2026 09:44:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CC86B05B4; Tue, 17 Nov 2026 09:44:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3679C6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:44:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 444C81A0438
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:44:24 +0000 (UTC)
X-FDA: 85444881648.01.8ECE7ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B6B5AC0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:44:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwWoKNgX;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794926662;
	b=L4B+Pr5+RwJgJ9nA4qLrPJBZ50JlO3tK2i9gbdx8lWb7Kw5Xl9gi4dWVHd5yx4pLM9thri
	TwuIVlaNXUnT+SHThyCYhsdhL+kY+javsjGCR1FMMsa1Dp6tBX4X876lEnokFsaEeUMiVX
	7V7rTnyNAP2K+VLJQhCBdybx8D2A00A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794926662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKqHwWb9Vsr0EE7nC7sU59WB0WtXzppmSDtlUQX6DHw=;
	b=Kz+Dz/ZRk/dVuQz0j+SZzxDnQ+HogwM2f4IKHnwbK/SxpH29Vay+EbSk6AKniI7LFR8kHq
	g4V8WpfeG5BPoE4FF3J1lF0hgEw3uN2VsN0/7evY7Eb6t8E/tMOiidpHI29I6Ru2HoMquV
	3F5VRUxuHbHXwthZletiuM7OdHgIsoU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwWoKNgX;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E585D628F0;
	Tue, 17 Nov 2026 14:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F17B1F000C5;
	Tue, 17 Nov 2026 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794926661;
	bh=FKqHwWb9Vsr0EE7nC7sU59WB0WtXzppmSDtlUQX6DHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwWoKNgX1hhUHyAJHu6ZAUg0po2rNn5Ux+/PNtpD9E+Bm2OyodrDrYc1FiMDBwj5P
	 3wTqUYx3VFocEq2/1uLd/Ki/UDxJDlvHQz98fYmx0GoxnvMkourBD1EwgUgkMZj1Wk
	 p1T6fznV4uQutSDBID4xmBpZE19FNvn4JF05aX3vFYafTW0phXv0F6NtrEIRSLeORd
	 swC6mgJA+HsX2iEaegyisXuBHItMjdR9iyVH2RZbjVRPljcoJwrX5xYMhyFvadVnwU
	 a++BTmpqMH+47Bs10RamSl5pQIYon42x8i8s238NGgd915kykkxtxwnAb4VvdhRTNB
	 TiX8AmCX7s6sQ==
From: SJ Park <sj@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Aveline Noir <jm5905938@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/stat: avoid 32-bit overflow in idle time milliseconds
Date: Tue, 17 Nov 2026 06:44:14 -0800
Message-ID: <20261117144414.124589-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117094339.30978-1-devnexen@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6B5AC0006
X-Rspam-User:
X-Stat-Signature: ara6jtpfpphejcnh4r3xscceieqyjckd
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794926662-547749
X-HE-Meta: U2FsdGVkX18tkzs60UkXqlcvaZmMqsNo3CFgzAgH1alzz40KhtV6hz+b1pxQTJ82dJthgJnn2Y7ceKVz4XDC3K1apXdXhZGrtv7QXeIDhRB6wo+x3TkZ7UCVpQfwxZQk8nioKsmcdPUicq3hucx4c/phCjvThGT790ZK7xIEcdm03dO5/CcM2sAOYwvIYyVTR6/RwFaQwLo8Z6UTyKHRvwNmpG2Z3RX76MSLfgIaimH5uw1+jtnukIXLeDOgQMOT/sImY1+aAWg/YrRC6GXK+oA63BqbkB7MhCJiSu+QzJ2DQE07pMem+XleMIJPtMj8F4sBMP9xbs38Hm326pnHZjmhHPuk5K+NMV5Lj5WiUnLOiv+vjj1m2Phnze7V9GqxJRGsvE2krlxWHNoeACAmr0aKcGNWdnWVtN6gHgtFrHvMVlHjGRgYIQlwgHLJYockAotWGEqTnA3bofu1zuCGNEMMLSD96881KmkXOnslk63g4zTRnbGJELmdOQa33ydVybacCJJWk11+fuQLeHXd35/YjXNf7kaSSRfOsF8GyA/qBU+LEIfXJtg6fBzDWtuxWx9/kP5ykKcmXtfzhuJCF5JN19FOjRP1uNsR0tlPgvTeFcHNLQRI0+WOpc5/aaNk+462Pjud0hLwiWReaDEN0Xa5vAFyebh8qOsMUlVpQK2uvpKq7uZ1Syw2tdzFMpTXdAlmKJgzgqHk3LwegKuTVLeMBK0nRIqYI/t3l3aJS8oE7YGPf/1nsh4XbjvzeQPu/670TaMeZgW7O7r6LxhxKEb2nOnWKoxCVHQ1KErUtghdsfYowdX4E4Q9dNtRTAtveH84TxF2cnBa2N/kYuVfHRZoRbwaE+rKcCN4nrxedtB1eLjQVjZpwFYsFqAppThsEiNbGfh87w1l9HQTHADjk/XIPq0FZzOkCxAy8UUeu/9a0BHr+kGWvM/rPPkWdOsIXTh5FyYyicXwjEkNGZv
 AVm1e0sc
 YTl+cotu0WZlskN3o+KUtkKcguqP616QP24sWDens+2+Drg/v07PCT/ng915a/fHH9radzkE4pTfzbYF3vwdYuM7bPPdxIoFr8DZiX/G4xrAleV35AjVLa5Za4i1NBfXZklAYds5G5g6Qmb7XI6ovDxn/vKLlQ+fYqdmIM/RnROUPCDb3EKVkKGqxEn1BjrpAgDnFOk3PAlhEzcNTQi5+BhX1CmAeSQ1Yyjmj+Vsgi964mtSI9MmQh+z+PnCeIPi3KaYGiZIBW4dya1jN9jtaKlILkBZ41n6SswJkWhsKaNZ8fHQc1iveDFyDfeUll85GIAHOuvJwHb8zTDh6asWXYYs+NZXpm8Wf3EnoPDnyUiaXRD9OQXv0xXX9husr8ngjoE4ZZsMhmB13QB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello David,

On Tue, 17 Nov 2026 09:43:22 +0000 David Carlier <devnexen@gmail.com> wrote:

> On 32-bit, the region idle time in microseconds is computed in a long
> before the division to milliseconds. It wraps once a region has been
> idle for about 36 minutes regardless of the intervals, so the cold end
> of memory_idle_ms_percentiles reports wrong values with flipped signs.
> 
> Do the multiplication in 64 bits and divide with div_s64() so the sign
> of recently accessed regions is kept.

Thank you for this patch.  Looks good to me.

> 
> Fixes: e5d2585d9e85 ("mm/damon/stat: calculate and expose idle time percentiles")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Carlier <devnexen@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

