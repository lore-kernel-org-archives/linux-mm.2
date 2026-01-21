Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C37C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55EAA6B00A3; Wed, 21 Jan 2026 11:35:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F526B00A6; Wed, 21 Jan 2026 11:35:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C706B00AD; Wed, 21 Jan 2026 11:35:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 392B26B00A3
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:35:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E276FBB31F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:35:30 +0000 (UTC)
X-FDA: 84356521620.24.8340685
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2806810000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:35:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2bDfcyhm;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769013329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nFleTfIFp6TWEgoOVS7v2fNHX3eqUm/9XF3W2Ekfyo=;
	b=dCYm+ZIxpDfFGnTpP83xV1tCx6h8m2ZD2PGF98H1Dp2wsXOUlvN/zagVVizQeyDKEo+GPo
	YBa9AM+//+9qX9wo+6oajXhSZNSlZEAsy3ht/DH9RZSR7pBOO6Lkh5sw4zF1AX8pWdZeO/
	jHus+idluwvaD8fqFKktmCYGAtU5JSk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2bDfcyhm;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769013329; a=rsa-sha256;
	cv=none;
	b=5eeTe9Z9TQ4ew1yBWm34AgqFEl8jkhe1eO4y6Iq1PXL+M/S4qumnr7s0fmtrUPJKD0nVir
	EZ4+ojruDHqD1tYM7u+lnhd5GI6nlqX8NMAT43jyh78nhAHQZoWCLJxmiJQI//ZwF10CLS
	EgXcKohSPgk9M0gtgOBXu947z6+qroE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D6A760134;
	Wed, 21 Jan 2026 16:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3285C4CEF1;
	Wed, 21 Jan 2026 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769013328;
	bh=3zPMWVBv7t5iAJv3hnpBDclZ49++f9lUq423MascAHA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2bDfcyhmX+KhXJ8DHt4vIF2snsRM458gDGeLB6zECJsuEbYlq1q1gowyffUhb5bUe
	 FEJDbI+5di4SdAiAnrexsRvuaySiN0wo78jIo2+/NlrO/kvjke4vk8BN2RbBe0Ycqi
	 Fl/q/E8L/79I9V94mbmL2UH/DL6T+LJYoeT0sXlo=
Date: Wed, 21 Jan 2026 08:35:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, syzbot
 <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 syzkaller-bugs@googlegroups.com, Muchun Song <muchun.song@linux.dev>,
 Minchan Kim <minchan@kernel.org>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
Message-Id: <20260121083526.81996ffd70ff4efc8484fd4d@linux-foundation.org>
In-Reply-To: <aXDponX2AQoACOaI@cmpxchg.org>
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
	<20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
	<CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
	<CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
	<20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
	<aXDponX2AQoACOaI@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2806810000C
X-Stat-Signature: mu86my4pds4tm45xdh77iuhgubtdwgjj
X-Rspamd-Server: rspam01
X-HE-Tag: 1769013328-396957
X-HE-Meta: U2FsdGVkX1+1RNq+IUg2sWX5bt3Kz97CdX58mnPE07AO3Dyss2sAYK9axXMw1PoC39m3mCd7tigsMFldaUXYx5HFlbPRRUikzfYPrqHS0r/5Ks0VOHO0Wr8zbMvo56faZ8fGlsEQdCyy2rIKkdqq9J08dFs3sLQiKdQh/Gy9MefNzxNdl1LfxwbBm1g6ZJMrcLPB3Bc73MMqkJU99xs2uHT0Qr9clDDXieys5BrBjejZaPHUy4jFqAZmVpj2PCnzSXdhrelHNaRrNl/+feA/W5+etSEYUP56AkvH3py1XFZD5Ll7EtJvLZSong8W813WnGGXvXw4JpCU7qv0frwM8U2y3MxECvGIsJBjJ82q2pjvr+auSt0AHn44k6hkCnV93H9ABnJmgqBdH4623CklCqZxLADSwXXXZ9hzOK6nISry/yYf5Gifdu0gphj4LByofPUjy91hUZ0Mqy4QBPmjyaKGkmSgPoP2UOVZVSIQm4bNwiIqzS4bz0+ZTw3LK3G63GWZc9l0ckuLMqAq6NOomeIKGlyLG9Iip1H1f4S5Spaj+/bw9PxZnBJaARdi4KwdCaRP2dvt9pWMn9NU2WJB6w25kLFX2fjUZCM/HxQBObt39SHvueSNXsFBomKIh1p24aDQzA+JEvci+ym9cQoXLKM5jNJxYoGiz+6OBaUR4fjne6hEzlK/7jI9pQAoDenQKKFSn5bvqbjL9YB/M/SqGGp579p2wEWuxVYYpY1dQUnYthMB9CSuBFwSfWUnvnv5bbmmH5RXzIYmEfmYEysG7Hrqyz2X85Z18Yz39+/yPW5IbSoPQngznprPNz8pCEHxD9mrjMi6eyeJkhIKFlbYGnzKvQn09BLCAbLXA2sjwOwKwNsChqpNd8dvIr99rJMoxycCRpVGIkSPrrV3NK2BzBzTc7CppEuqtosh6Iu0JLa25M/XVs6+piSwHnUfvBwDsOUAiR7rnoGqxfym2+D
 Ehpt/uAM
 WaykCSf3eFPCpT5TQK1130tJNubPNsVC+DOV8GiX0LY96aDXx0KI/7KuuO+u5ZmesU1cR5DCjmMJCd6Uim6rZ9/QUKbjdBpW4PsZ36kQ4Vsq8zP4is+kJb7VK+fpOHcIW6XED2/+u5QjDJShm+bi8ZGDP54nELG1TZfJ8zxLyauPt1XNCQRYmqhv2eNxv45Ee9pYogzxIHdbc5xlZvgXtWvT15YMkoSleM+ZaQ8wHRQ8YZaMNpk0ECT+GvRCODF01Jw0f449PnzlkXZTTiYKP5APihjHMGlyIbXAqQU8isvDvIHQHonrdb9VtEduvkfGcR/+ia619a1pkcCs2MJ4ECB+NCPWLt/Mkn3i6Xuk1pZ7t21zyvqkvPZPREMOt6mjiLjFp7U8lYBOyJGp/amviMnsAVVV+iBeK0Z+ymnddYX07QlHd8T9P0FPN5wJNBHGb6UmkBAPDrtqMLkUrj8pgSkiTJk3hiA/Sv3eKBSWLyuUBgShny2M47iedKkRprkChiE/tfiC68wZGbIwR0UV8oiYckAkPhENvcXAt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 09:58:42 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > > I tested with the latest linux-next in sysbot. It is working fine
> > 
> > Great, thanks.  But we still don't have review for this one.
> 
> IOW, this is not necessary anymore. Kairui's (cc'd) fix which you
> picked up fixed the syzbot reported problem.
> 
> > For some reason I don't have cc:stable on this - could people
> > make a recommendation?
> 
> So this:
> 
> > From: Deepanshu Kartikey <kartikey406@gmail.com>
> > Subject: mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
> 
> can be dropped.
> 

OK, thanks, I'll drop Deepanshu's "mm/swap_cgroup: fix kernel BUG in
swap_cgroup_record".  I understand that Kairui's
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix
(https://lkml.kernel.org/r/CAMgjq7CGUnzOVG7uSaYjzw9wD7w2dSKOHprJfaEp4CcGLgE3iw@mail.gmail.com)
has addressed this mm-unstable issue.


However Deepanshu's "mm/swap_cgroup: fix kernel BUG in
swap_cgroup_record" has

	Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")

Which I assume was mistaken?

