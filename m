Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B90CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A416B00B1; Mon, 18 May 2026 21:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2FB86B00B2; Mon, 18 May 2026 21:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810F76B00B4; Mon, 18 May 2026 21:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68A6F6B00B1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:28:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A25BC0241
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:28:03 +0000 (UTC)
X-FDA: 84782433246.23.79C9A4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 777BB180004
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:28:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m9HtO594;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779154081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfR07fG7EpNm7kYmPbjPGqnUK/lXfjXu0eA3u/grdQg=;
	b=UGQCq00l4XGCuqtfFzrqMJWt93IXPT3KhUL814KYAO+10NM6650gvQ37WwlusQs8GdShfq
	RR0yVUFjaT7sk9Zl7ylCOpAeoAce++2etxXz0qZrXFq6haRy930EOER6yWjAaqXeX664g1
	Xuz5LmTzvIDl71/ynD0vByJotdFRVSM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m9HtO594;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779154081; a=rsa-sha256;
	cv=none;
	b=Z+JNh63wpG7E4kuH8niJjqV+1DNIB+4f5dixNivr63Z7vNvL/xk32TMum75Cchk+QwuTZM
	bljDcswdEdsHYKzJwLVrRjD2xtwEcx10tAC/rbWjKAxf0QrfvLM08Uvbxtncj2ksT0t1zU
	zNup5bj6Yp9utcsB99NfFhdoCt8S4Ps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7503F4412B;
	Tue, 19 May 2026 01:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B273CC2BD05;
	Tue, 19 May 2026 01:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779154080;
	bh=DjXNCz7wjkPFz2WXiAKd8+VZo5X/xiI3NVF+wDWE2s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9HtO594Zbm3HLKn9aIlj+5m+ubOP15FeC9sHw6SxJZQKm9yr70dhyJUTPgJqllOB
	 s0Cf/hIqoPRQ5JzUNxly+jkmbaM9FFV1W3It0w0BVqAeyWvomKHflfuMmO8OcbwIcR
	 wMM4yevotJSHREc5k0fpb0g3L69qAFXY/E8q5BE2XmFWDeYaQ/mUa9aGblCtbp4PnK
	 IJuhS+vGUh3T95sXpT6Hmskqw36v3qinWorYh1mBT9Na3/f7UDEtB/5iByd6oWTchn
	 e1mK0WtwJTjKvX2CBfWYevBx+ypsrRaL9iUf4D9rSGBM+9EbLYZORoS+9kyiuBRXK8
	 y8HqZUM2VuBVg==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 5/5] mm/damon/paddr: add time budget to migration page walk
Date: Mon, 18 May 2026 18:27:50 -0700
Message-ID: <20260519012752.100188-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y17XTzjAK5ZyKAKZLN1cAE-+c+2DgqpmuHGWgjUAZMgkFg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 777BB180004
X-Rspamd-Server: rspam06
X-Stat-Signature: tos7iqpg1tc6bgbebgs7kbymbnhmkd6b
X-HE-Tag: 1779154081-756429
X-HE-Meta: U2FsdGVkX1+ggFkGYiszTp7eKqew7JdxnwE4xNImjGoWsPGGWU/TmOuY7rt0Q88pi5LG6dusqEg1htRLpr2fofhKhlxiEpPZ9mHqITjrZBnwU1Yvp9e69w5Isrn55YGNNIuFqCshPtfT9Lk1xhvVTVl4cZatHLiZa5nnLODpSKNGi3doESHPeRYFoQwaOPrHAp4vXwAUNtaJJEd7i4ogy5rVB20ar0ReoypEcPedF+RRh+qXkHxEI2Dy09vElZsJRhwCySROtx60AgiegGTKYhFZQD/cjhVW9NAKJtm4jy6/2ONin9wiJIyHDhG/rngPRy2f+E3RCcZizk4qRsh7c5bMcdAvykLYny+A2tMKGuxanzWdXIEAuMD0npSu57EHsjqhMz4pT80GMpB4lqPbW3LpCl4MfC0upC4glxd4m9z8LTd/TT538NKE4sJWbyi88xHSyuwIoZB1ngBid4uBrOJ5KZBBW78uopjco8wCWjTIERjOfiWvRhVRD6ZtJQKjPG6aHsaP63pqhr0XR7eZ0ZuQI/fGntDYw2sZkc7CpSnc4dZb+bL5pulvbueG7CZ6s2uDexNJ6wKotHp/YQ94dTXyhiG46JvOX3rrn8K7+1eJI6lBAqK68WypybgtWJH7GUZuBPXyszBslpQ9twMUAWpjpNEKrR9FkO+I91VlmJDjV1/HwN5fwMvEE7zYTWeUfA+EntfavS6dlTOiq1Tqfb/J3GvribztCasFsG11kxUTk5CCN68AyfCht9x/csDqxXZhDe0HVjhbty62r8kmNP+okCkCIVmTJedvyFWb4Yx2CA9NvAwZ2mgw3eHOyJuBRqiLV22LC5ic2YCrl++hPeTcrSl84CPiKf3NTWj7kgJoxG9DPsbwslx2H9EXj88z0Xm7EMococLx3/gS5TH7DAUcRBc88mXLh/rEkVGpBwJLgKVP6Zv8XMdKwT7y7u+8UOZr0oB4aiY6h15Um61
 TKQZ7pgQ
 iLUTFUNh3rLb7Q1jgC/zEL+Nvlogg3nTY5MFHfUSs/fjfLWd0eEf+QhqFiyKZwp3LCPEpKjdBbbLU9Mwef4kn2R1m2vdfeX7g5C94GxfGwXKPod1VHi4ccVARFNbmldS0y7pI7392pTXkfBGDgzj5YoNr1U3mxDeIozYwBKlV6pbOaHeHbkqD1PFb/1MQLKh07viqmiAssgTCrFr30QK3d/5M9v2iwOL4p4vf92kEMmUt/svF3E68YgPxoqzMbNm7tP4r7CvxCu1R5aF48X8dmpEurzNYe82dkT3YLTkMgDWQosgyvyWjDg14R+N4qVSfXDYY/zKU+X1m712fQSgIslsih3tPbsqBg5uDiTWvoYRYiV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 22:54:18 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Sun, May 17, 2026 at 4:43 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Sat, 16 May 2026 14:03:57 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > On populated physical address ranges the pageblock skip optimization
> > > alone is insufficient — most pageblocks contain at least one allocated
> > > page, so the walk still iterates millions of PFNs.
> >
> > So my questions to the fourth patch of this series are also applied here,
> > especially about the assumption of systems having most memory free.  I will
> > hold digging deep here until the high level discussion is completed.
> >
> Hello SJ,
> 
> Stepping back to look at this with fresh eyes, I think this
> patch is in the same bucket as patches 1 and 3 (full background
> on the patch 3 thread): it came out of the same parallel debug
> effort, where I was seeing long walks during the startup
> transient on a multi-hundred-GB monitored target -- before
> kdamond_split_regions() and damon_apply_min_nr_regions() had
> trimmed the initial regions down -- and was unsure whether
> those long walks were contributing to the NMI-side
> responsiveness issues I was chasing.
> 
> Once the actual NMI problem was fixed and the per-region work
> in steady state is bounded by DAMON's region splitting (and by
> the scheme's quota when one is set), the per-call cost in
> damon_pa_migrate() is already small enough that the budget
> isn't doing useful work.  cond_resched() after damon_migrate_pages()
> covers the preemption case.
> 
> If a real workload later shows a per-region walk long
> enough to matter, I'll re-evaluate then with concrete numbers.

Sounds good!

FYI, many parts of DAMON are designed assuming it will be used on production
environments that have long-running workload and prefer stability.  It helps
making good results in long run, but also make it difficult to understand it in
short term, especially on lab environments.

I learned that by grateful users including you, and therefore recently
developed the multiple quota tuning logics and failed regions charge ratio.  I
feel like such DAMON limitation has contributed to this case to confuse you.
Sorry if that was the case, and please feel free to share your pain points and
improvement ideas.  Every user's use case including yours does matter!


Thanks,
SJ

[...]

