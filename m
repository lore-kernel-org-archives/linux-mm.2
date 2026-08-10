Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E7BC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 22:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338216B007B; Mon, 10 Aug 2026 18:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8B36B008A; Mon, 10 Aug 2026 18:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7E56B008C; Mon, 10 Aug 2026 18:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F29486B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:16:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 575AB802B0
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:16:46 +0000 (UTC)
X-FDA: 85086770412.28.19AC85C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 381BF140015
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:16:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i1O0I4Om;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786400204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfPD0y6Vyt+IkmC/2uT8T0rxNYXqQ/3bdmJoo9LdWMc=;
	b=FtxLx8qjf30qz9LEHlq1cm0hY0mBrgT5qE8befHARg6pxhitGEaObdWxTJQWFffsN+6U1o
	/3EDcrL0EVvcFPT6HAii2PAAS5snWnfnzoGvfSBc6wtm1eiXru7uNZ+QOqqLAZCSXIMREg
	lwtOAneFmZFPAfORlyIvvhe85e9Hhhc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786400204;
	b=ZWrB86zxO/YiOiCa+2E65LlrTh6dSqWkvgDBPRRarIZ5HzVcplxeiygIImkr1d3Pl/qr44
	CDEwZQ7tfhRbq4H5kZ5Htj3yMBbqloTKEAhQtnlDviHSfvt6EDPV79C7XIcRx8j42cqzCP
	toMRyFjc21VRrAIEac6v63B9lpiXgNE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i1O0I4Om;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6C986001D;
	Mon, 10 Aug 2026 22:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4851F000E9;
	Mon, 10 Aug 2026 22:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786400203;
	bh=mfPD0y6Vyt+IkmC/2uT8T0rxNYXqQ/3bdmJoo9LdWMc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=i1O0I4OmaU6cNpeU3DYLQ1h0VJZsd7MRb+DfGkbegHB220v8Lf83Rx2Odj8Kz/J/G
	 y3RoP/IvsG1dEIEpQru62AeaFtI13q/CB6CNf4P7hwrpSeKGeaiVvwObhy9qclXnbx
	 NgIqV1bWxe15b6VY03TjWnKyH5ohHl3P0sGHV2Mg=
Date: Mon, 10 Aug 2026 15:16:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Jianyue Wu
 <wujianyue000@gmail.com>, her0gyugyu@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm, swap: keep hibernation swap slots out of the
 swap cache
Message-Id: <20260810151642.871c9b5d9cd56f6efd45ff90@linux-foundation.org>
In-Reply-To: <20260809144559.2104856-1-youngjun.park@lge.com>
References: <20260809144559.2104856-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 381BF140015
X-Rspam-User: 
X-Stat-Signature: ymf1tzd99fkpkw3i4otdrox7pkbtui5h
X-HE-Tag: 1786400204-334488
X-HE-Meta: U2FsdGVkX19LV4Xkj9ijY44xKT7OUErry/59mMpeb19QT9s+MCUwAzaLZBsnFu4Yv26JAaQjXCJLfDe4ItCIVBLg0uiVhveqADgQmyjZdnv41iT5aiwQD+bILmAwbsq70itOOHAri5/e5oAz7dEcJaM7pmkx28+IU/DTwu3AjqKW+yCxtMcKLZ6I8Uwrj320HzSlLW3ruOBqMJCpYyMnV6LwQ7UVFEcmcOnSh17JNpD2X5N6pY//5ON4vZYqt6tTCZLV7MouhZTsMLOkX9msjsxCTjP+3FsMUWyFEiWD8Gt0mScfKrf7TaH3eCByhfY4fkNF31n/XQTtrhr9i8HzRHYkL7kayCuecf/32R4cXcOe40KFtWiUxQPIQz14i81bs4tMIGnNblybo4KENuJhWE6khTiNNf0fXCzUiAjaTwBOpBvl3EaA0cWu2eej/uFr02b8TRvmjG+mqDZOda4BHRtRA0CLmoSnXoPZ4rfpIPZiqUfHsEwdknFeTsMzi8LaFvw1XsotDDgigLGpMlE4de7aEVvSJXMEXwJu1SXeZnq+oOJlyjPK/ulRWrWdh0bu4v/uE1dJADF63feUgqwl7bXkWTLFwRiutB3cVFwwvO35EjYsN/FAjJzyh9ThW+FvUpPGo0DRPv7m/A1D7ebU3F+JNGMVDQKDziNIKICXUaEsBrbbqkZpPW5BkU026l0ClKnP0h9kPJTLiBmoMiUx5wnvooW3SUpyicsz0Rwi5A5XDQ/moZRHmFC5IlkCFiFaf6N2TrfSPGyoqyoYnkJ4sBhMtTs1jtWnDVTUD+ZpFQTaz2Fw8i9N3nBtMkCHaNqS2SNYPwzqFeLQhaTB03qQZnBqeUX5kqk7LEYU0+A/pFW1WEOhNzQpGkIIt3AcD8tlhQOMHcjj2q8J3W58OC6CMQ6VQllluu2+LZbe4nerVB01UOjhmSX0nxYBKxsrpQhaTBXAO2fDRsVoj0omeZi
 OVpn0A7y
 0VwGJoBcib+XuVetdztrlkdsnvao6xgrz5kzKhO2ilX69tW9WGJT+jE9HfpxcxxELEWfWQ6XPrtj41D97TmqZEzEUnbz4DT00HcBl9XAhBEAuCTbACudzJA7t9giDA3lwAqJukOjF+pNDzxLjTijlqmcQ7o70+g1Hha3KKVhCoZEi99Cytrju3HW7pYC4e/c4Izxjn5oradd6qKo3FznllgrNz1TWdBciHLzBq3QQOySM8cE3EagcJRH15ALxoXWcECZ52gfbp6gQ7wco/48Xfw+QTeBUW8MdNiNb1sQBWknkmgOUE0yhPPnwjUwPF6yx/AHZMJc3zASSuRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  9 Aug 2026 23:45:55 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Cluster readahead walks a raw page_cluster sized window of offsets around
> the faulting entry.  A hibernation slot looks like an ordinary swapped out
> slot, so __swap_cache_add_check() lets it in.  Readahead reads the offset
> off the device into a folio and puts that folio in the swap table where the
> hibernation entry was.  This has been possible for a long time.  It only
> wasted a folio and a read.
> 
> That changed with commit 0d6af9bcf383 ("mm, swap: use the swap table to
> track the swap count").  A slot with a folio in the swap cache should only
> be freed when the folio leaves the cache.  swap_put_entries_cluster() still
> does that, but the conversion left swap_free_hibernation_slot() freeing the
> slot either way.  Nothing points at the folio after that, and when reclaim
> drops it later, it writes to the table entry at the old offset, which
> someone else may own by then.
> 
> Patch 1 is the fix and the only patch for stable.  It puts the missing
> check back, so both free paths behave the same again.
> 
> The rest removes the cause.  Readahead should not touch these slots at all,
> so patch 2 lets only swapped out slots into the swap cache, which also puts
> back a bad slot check the swap cache rework dropped, patch 3 gives
> hibernation slots their own swap table entry type so that check covers them
> too, and patch 4 drops the guard and the reclaim, since no such folio can
> exist any more.

Thanks.  It's late and review is only partial.  I'd prefer to wait
until after 7.3-rc1 to process this series.

AI review suggests that more such fixing is needed in
__swap_cache_add_check():
	https://sashiko.dev/#/patchset/20260809144559.2104856-1-youngjun.park@lge.com

