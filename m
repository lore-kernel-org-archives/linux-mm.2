Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5207BC79F82
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 01:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8E16B008A; Tue,  8 Sep 2026 21:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47ABE6B008C; Tue,  8 Sep 2026 21:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38FF56B0092; Tue,  8 Sep 2026 21:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1665C6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:32:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FB431607DF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:32:00 +0000 (UTC)
X-FDA: 85192497600.11.542A6F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BBB711C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:31:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dPeLNOU4;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788917519;
	b=D/A9/EycNk8MKM5SXcmvbdvFXi/YwyjAmQdLGFVhmKGz2/SPwHukUVlvg6k5cnx9ubzLai
	WmB6lfSFjmNl+VvPJJCvbr/ODM5xhFS2aLzHwb/WuABBbcoTleo2mYxSP87zb5B8D+CWTB
	2/elgpUI6PSynd43FBdGhurc+bkeGyU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dPeLNOU4;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788917519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6Jg5xIoexoZAriiCVovYZ0qFnPKz2yjpLiaN5i1W4w=;
	b=7nF/PMeNFsZuHpNIKtJn9d35kbFryziy0bZdCG3TZXDlZWxIaH2V1+vk7hrRclZUdEL7U3
	dIYCwP0t63NVz29ct75fe4INKJTGmNFoaQ12QkPMKTBTrh0D3iM6WlZv/Uw8AY0sd91aau
	dVhZVzdXKPVwpYLR1MNi4rmgb/TKKwo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9585842B71;
	Wed,  9 Sep 2026 01:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203B01F00A3A;
	Wed,  9 Sep 2026 01:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788917517;
	bh=E6Jg5xIoexoZAriiCVovYZ0qFnPKz2yjpLiaN5i1W4w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dPeLNOU4iXquobDjstLplfC2jXo6o18xmbbGcphLdK9D5cmpMqZS2UVuB3JOZji5d
	 OGMH4imFVETAs9tjHhLyJhip8JDjOyk4+toRqp+2LjdYyVm1j2gOt80V7JK5Vyuip7
	 4qCWDeEldXq5FBqxlV+UBvb9y6lnU6DZ5a8VOJ4Q=
Date: Tue, 8 Sep 2026 18:31:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: hannes@cmpxchg.org, baohua@kernel.org, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org,
 mhocko@kernel.org, ljs@kernel.org, ryncsn@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [PATCH v4] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache
Message-Id: <20260908183156.5f1fcd990ee847589197aac4@linux-foundation.org>
In-Reply-To: <20260908062649.1045883-1-zhangbo56@xiaomi.com>
References: <20260908062649.1045883-1-zhangbo56@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BBB711C0003
X-Stat-Signature: ck3tpdqk3yaa7rsgayd1j31ncrbngfsg
X-HE-Tag: 1788917518-331269
X-HE-Meta: U2FsdGVkX1+MTjltJOaO7EtnUB1DQbCKubpJbBrIbP3u+NbA77SUt7SjcdNrWRkwBpVf9q6JOyPJAws6Zh0Nkm+1uXGA7Fsqp2XN/f73cqhrL4LgoK4yE79XCfmZ8Ylu2WZrTK4eUUzHMeiQ0NyOwZnVTt2NOkuSbTbgZoFsq/tXTPMvARgXpPxnW/BvFwwZ56w6Vm3w/tIGqBAuK3vyRxaC0Qvpg3Yp7h6mLpzsljQnCkYZuxx25+z0nzv6ZiLBN5XslzzldsN92OV5jmHWyEpbpx5jGCxsyuCuQO7HW+jKrPMk862/OwbH+L1bwJmbOkTeiGFVarW258P1UBfBfF7K5Yj4sNGyDOK19wJ3WWzD3H3XW08BqgDo0QWBdkhqOo1bszGHg+CBivORWw1/AtDTwzeNtq5UtedKs86enknQUbOhP776DMJ0y0xFUmLf6eW+V5aeAQJbQ0psZU3WkFzi8adBzizSHefeypseOdiDsZGmxxijVVo+GbxpIC4dFpb8UyTnuPjyk+KXJhx9Cy0ex4D+0JTIl63vMH2AD1Z1zFnLGKaIQs4BDYxk3saGa2JSr9QjqsSUrkoM4SuNNHNUuHMp6G51tkseBBNjSxBjk81VNfjSH0pxriajjn2pT1niA5s75AIcuTtSXBPC/f2wb3WWzfnpNHaw3iCgfsL75ZqnLP+UbuCdcAsgr35hGY7qyvpnqlLp9GIRci6xKB/5/qg6HRB6iKo33lmUfFZqMykQiRpudqfrYPwmIwdyFcTGjkaXjvYHeUet6Ln4TsJPLwuM+6CChKf3DIU1wxgXUkddF6OvL3SUu4zhTMihU/o6VnTVvh95px8dnBh9knmR6K1ZJW6dFA0AyM7JDNSvXHRnxXHWbvUZ8fyBXmk9cVnXtW0p6EXPLXB0/uIuXtH13TrMl3OHQkfUOnygytjGtjLODiZCPkKZxmoSaz0y8J7GgbwnpLPJtRLO37N
 XdBYob9v
 faCb5+Zy+OABnjsJVmZzoXCQlzrRjG/mtOU2/2dTeHOqcaLccMznVU7FlLB1AeyLPArBnGbURecdHZJ3V8u+G4GmyU4Lprg5IU00sX4olvNy/rSox9OUjFLBKnkI8Zlum2qll0jD4KL+WzEpgzMcWOud+ODAcV0I+B7YLhvjcsRGMhR2jys0KEjsZggSbAfdV2/HKzKhSbuRuZSCvJuFD5J2nomHf8YUhJCi5/RcbG4KYkHfSDu5DU9h5x5Yn2qVQaEpvfPZAn1DjDUuQLKsVnhONVPAjxo3q/AQbbW/9yZZtLxUSlnqW7kH9r/lxtwO3LOjw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  8 Sep 2026 14:26:49 +0800 Bo Zhang <zhangbo0325@gmail.com> wrote:

> We have observed some cases where memory is allocated with GFP_NOIO, so
> we cannot reclaim any anon folios unless they are in swapcache. We can
> end up spending more than 150 ms looping in `shrink_folio_list()` scanning
> non-swapcache folios without reclaiming a single folio. This is pure
> overhead.
> 
> This is particularly true on systems using zRAM, where swapcache is
> relatively rare. So let's check whether anon reclaim is allowed by
> GFP_IO and whether there is enough swapcache to make it worthwhile. If
> the swapcache is extremely low, we're essentially searching for a
> needle in a haystack, so let's avoid scanning anon in the first place.
> 
> On Android this is triggered by dm-verity hash-block reads through
> dm-bufio, which legitimately use GFP_NOIO because they run underneath the
> IO path:
> 
> ...
>
> To stay conservative, this only skips anon when the swapcache is really
> tiny - below 1/64 of the anon LRU - i.e. when essentially no anon on the
> list can be reclaimed without IO. Whenever there is a meaningful amount of
> swapcached anon, the normal path is used and anon is scanned and aged as
> before.
> 
> ...
>

OK, thanks, I'll add this for testing and more review.

With trepidation.  It's easy to play whack-a-mole with this code:
improve one thing, worsen another.  Unfortunately the "improve" step is
apparent immediately whereas "worsen" can take years.

So, as I said, testing and more review.

