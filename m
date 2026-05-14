Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2931CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0329D6B008A; Wed, 13 May 2026 20:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A016B0092; Wed, 13 May 2026 20:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0C56B0093; Wed, 13 May 2026 20:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD22B6B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:57:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8911E1A0284
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:57:37 +0000 (UTC)
X-FDA: 84764212554.14.52B01FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 03C5D100007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:57:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oV8KQ0gg;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778720256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oqMosuxWngz8VOhj70tAB9p9qkjfPJFIxulZHBdaG+I=;
	b=3gHb7zfnV7sRS5suxOFYciWYIa9FF6kqaneKm/7qLrEUV+MjhfNr1pgwJKsHtywoNVM0UP
	AojfxbwglZS2+p2prRTrESKGZ2xY4SfFzEJ62gBWUzCf2ufQYZw1tiddA3Bb8Bb06uylBm
	qzr1zijjyTUK6mupZ0pCBNghHr+GIfY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oV8KQ0gg;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778720256; a=rsa-sha256;
	cv=none;
	b=qxxdcPLJyyEEYYAo6ngr87LVpOGUIiVYuFkwu6L2Dm7Qn3LK9hPWjBl8ovJP89o7juSScM
	/wFdqlfG0pRkTKlkEOH3yP/bKyX3hz5oUjKhilrbNqtq/4Z9xzGtbE/al1rKiw8y/Ictfx
	vmaM4hln6O75b9Lz+Im/rUa+CafJldU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BF0B600AE;
	Thu, 14 May 2026 00:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223C1C19425;
	Thu, 14 May 2026 00:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778720255;
	bh=MEUL49ut3jMag6a2m5/Ftkw6tFUmTjulI5P8icLY+lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV8KQ0ggrdeSsk+FUny7P3cJunlOIZnTTd00gV2a9XIenYIj0YzMLn/kcwBFcMR7D
	 RsQAT4WVLRBGXeQMRkeruCOb11Mck5LMaqo5Jr1WLgZUQby8Sp0YXLtLPvmqcoiG4A
	 UjXyJKM4mYb9YJeg1tefK1IglntR8+QFW41PW/G2V59MxgJuI64qFJjcUB/x+G2aCd
	 Gn0biD13MuiSGaYlzIOL32zJwZg4k8/6TdSrv6/5dgEcj/JEpKx4Ip/7z6H/ZC8Iyc
	 uf8loBrcqBlVdFCqSylrZevhw9QAHuay/6JT8qhHPX/S3H7X5Se0B2T9SHIBn2Isv3
	 ZbXiQf9MBLcKw==
From: SeongJae Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tools/mm/page-types: Fix kpageflags option argument in getopt_long
Date: Wed, 13 May 2026 17:57:02 -0700
Message-ID: <20260514005703.148576-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260513022120.58033-4-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03C5D100007
X-Stat-Signature: btu9sf6gft5c6c93kp5a6dse83bguqui
X-HE-Tag: 1778720255-515552
X-HE-Meta: U2FsdGVkX1/ZGrlJAmGC/iHVA+Lq2WUaTDUjmniiZaEQ3s//xpYRW87fpxMvTU1x5Gl9cD7zgqzVUZvqDf0Gog7ati1aGPLUGF8gvP9Rr2pX0CO0MdkZp2wCzZ4Fg7p9lT8oQbIrSGOjZsx2f4/CWCtAbjJd52H+wKGhOK9HD2alEs58jAaN0Ct0yrID4L2hgLbupjLLkdf+MHaZp1rzYvTtm2ROns6A24usQ9BEUNcbd1sXgjkzPTCbMoCqudHlomZDmfNh5XbVPf2IoUqk+1Z0ElAaLZOzfrJk1Xp0zeo6xXQxYQQm0y6Vs5ZfAeXbOoLhzNfWuLTbdq2u2Pr8UzZbIcLHYs9R/nF4MARBbSu7UV+5dEShQwLMg9ijhYt98J0RNON/1umFf248+kVSClHShTCgW/PdUUU8ZzZWSFtStMWWlwG83INyNHghFnZfkj29+oK0kDX4xHnxR4gJK/oR9DM/UC7tyClfXzw8Zxm6nqwD2zC0uuh01AkGDEU1yZ9ePpV1Ksi5rOSxupQYB3W+HJopfExpJLMvSljKa145THPL+rSIgCyy1PMziOJ0UXyeFYT9n169f2HUcboTbysfwyBEpZt8s5bkeZT3UmLZ8P20cIqoOiczAkuAcVjayeCY1Z/maN7dyS6h3CyXdMHC/MAaelevgflSfu4ygNXuRi1/MEJ7F4XTl0PqpgkCm2lZrSFGp8+3s7c4EcT+iFuErsseWRFOSLB9blnfezrYq+ccmQXP4Zv5i0wvHyl6GzOwWyfcWzvdNaiecZWR/31T9Jsi9W3CptGxk2jgmm2oCqyg8UGxZzPLrEFj/xIa/+R5GDlVioWbw9WQ8WZfXBVTtPdKx5+QLuQgZRp8vqAULqbhVmellpF1WdgBCNsN2JA47OjSNW5GF+TDBP+PVha9usI1eKoeTM5dcO49J9OZWvJH81/F9NvmCYxgLo4dO7HFlL5IVgehrJknMtB
 d0rLFrwE
 5ETg93QijYwKKic2hJXq4VjgzEptM5GrYZMBUXj0ik20RT1w18bzbR0YEVw3SyjgCfEnL+JkUSfzzseGxBT0Wl3fDd0Lhz/NtzdgQ6QmE+mPQToct0Ec7rLXtyVdmrQLaJHE7yb0HsbiAhhLlA7ToVzZU8+cSJfumrJiXFP725gLnK6/xP1TtBtymOHSivHATsH9U+CvlrXhj9leIhxvE8zSdosCCBuIIl5tk/Jcq+V1rpID+bySIFnNB+oSiwln2fMHUZzG/gODAvymwA88Sx/sWpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 10:21:18 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> The --kpageflags option requires an argument to specify the kpageflags
> file path, but has_arg was set to 0 (no_argument) in the long options
> table. Change it to 1 (required_argument) so getopt_long correctly
> parses the argument.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

