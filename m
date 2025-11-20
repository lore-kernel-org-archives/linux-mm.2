Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04C5CF9C7B
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B73E6B0006; Thu, 20 Nov 2025 13:04:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8678A6B002B; Thu, 20 Nov 2025 13:04:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FC06B002C; Thu, 20 Nov 2025 13:04:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4EC6B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:04:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F151C02CF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:04:22 +0000 (UTC)
X-FDA: 84131759964.22.1666C4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 24D8E140008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:04:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VY3NzBAO;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763661860; a=rsa-sha256;
	cv=none;
	b=HgEisDPVd7ZZE8dxjIbwkS8v5n29ivUv37Ye8fQW+N37nhPREpkUNSACJxTY2+NaPWX6vw
	TgcTuSqJeeKx7lqCyh2UEHxlONxTtBP3faPbSsV7D1XKHxksrq7hhvWciWsCVHhXLAxrB3
	HrYC/Spyw6ALDVHtyqz9j5BpKRpy4aQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VY3NzBAO;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763661860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQ6aHardoB1Rgbi4FNugR57aHLorp6I9Jksej2qCH8Y=;
	b=qDFsBElfRMXFRzqCCtqZ5/Tv0kmt9ra9OXa06maswdHN2SoXBHOsPHiD6XHq8FO2DfvAVT
	uc/uMVypufQ0LDAbEulqx/PDSSH5N8lYUknEKR9eH28GXiTKWpRRydGb9cnjiZS+SgaG+l
	p7/8ax6JL+mwpWiYc42Ob+TfojyPU1Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECADA40612;
	Thu, 20 Nov 2025 18:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961BAC4CEF1;
	Thu, 20 Nov 2025 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763661858;
	bh=EadW+89Qrbcrtd+y7+ujksQ1tYM40RiXEDOZuCtI+M4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VY3NzBAOiH6eZCc9KPPa0MLhZqdlj+P4bYZlCQrIQ5afcx/GC81pKWXzYs7BMcStE
	 s+RCjaghyp7q5KhRRiRi1EsNrkzfeozbdD0r/cfUuZltooFQadczhnfWP8wjrWMfGG
	 GHXYIVYzrqR8I9Mc/VW6dhhEHNT2Y3MLTD1uG/XA=
Date: Thu, 20 Nov 2025 10:04:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 0/4] make vmalloc gfp flags usage more apparent
Message-Id: <20251120100418.76d173758d03fbc60a4299ba@linux-foundation.org>
In-Reply-To: <20251120010303.74537-1-sj@kernel.org>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
	<20251120010303.74537-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24D8E140008
X-Stat-Signature: wntsqgu8hzgoecrpassqh9o7fr7rc6k1
X-HE-Tag: 1763661859-412794
X-HE-Meta: U2FsdGVkX19rHjEx3fYH3mNqrGxj216dIL41jhkHryLN7YtnbryfFtzIt4FpdgrBVXjlrg8IH4RNECedcPSlN70jq/S2DJSp5ow9BECQhZ5zSy3o39l4oncEgGaxjTignFN5flGUYuz0U28WAIY2p/AuGNLrFqH/ZyY+qNQ2NP4SBHLGtPdNjvAL/qHmsusUFY1u1McIhye45EfQN/epQI3sOeU0XN8jrtQ2GkXmWJ/ypM4eisr37lQNdqP5pnxCXMsDXllG6Mw9k2deTTGLIntI7uikUF2cEd2k00K7lxJb2SCHRPjFoxOnsWsRZoefvho7V+b4sw1YTGFTkloch4yGOW0XplHwUA/Yhd7+D3Go3bG3PEXLErFIWz/doxDlde1kAj6F7C+BFuD3r6LM65+c7SPUB35/9Jg7zHOLPUkY5QoXo9CXQPImni3heA7bbLhewnQSDoeJLw8mf4+PrYPtdfMtcX1eyO6obHKQTY9+hvfxx9RhjbmozDKtUPGuBCIBH0ebojbq53RqZy2/ti44RVQgGR8YrqWTqMdg2V8KCt6OWdUFllKQJDbnVHttaDTJyjVTCC9SU6AmWjqtqLnAocRa84C56P65kzAKFr5iECLrhu56yHc8YuOaWjP/QnYiQfEkikPt4sQzv5fDMDI5WQhz3N0OC86x4z9pZDbMcYYyyXH6nIeYnQY4jozsaCOuSq+kPIgAONpOwVmYTIYBmmTIu2Ybvr7qdm8S4ocdKZJ5Pd20v0JqxO+bKkX9lvDezmLZ889HlAueNMjdLK8kqZlGucyl/SVFMafKEEldZYZxv6ZnLl3nPJHS2vC5ne9qEpXqph9G3BGhaIue0pDXJxSJrA88mmy1VPUOKIH5yfSMdDUsPCsJnh+mKESmkwJKd4Lj5XOIjJ/MXkUMCrKUV16LAEV6DLDBfu2RE0RG/7zoEIUsrEM9A/fskb2t/GQxhffldIwbPw6fEzy
 mGMxwIEQ
 P7Qquvq4LNzAd0yLV1kLKc/s0T2RXeU18BIsbvoi5sFb+rD2k6Kq7+V48Mum4Ycc0hoMZyY+u7wfOMKR+DA+iWiDK9Z5gvu5Hp7gyW/3oq181XSpm9+/mI83BXeYc+dAqJaACLom4UuTHm0vh016LNKhlNjVnFXx2ZdQQNcjaS5L1W/b3u3KZC0uAYXgZ5jGS+4HK5YrV7SEirSUFQxQ7ub04aQ96PzuiEBdxA37w9OLzvjPN/MngURKO/iLjgcVNiyQ1sxFxdIE9IEgzSdmDOCKH3Sjq2iorlO39snJ+tHLqG8VXovjNEWHTD0RmZYEwW6vmVoebagWONNOP5+k0S+ynEXJ/gQD1vS08zv6RWkmXrdo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 17:03:02 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 17 Nov 2025 09:35:26 -0800 "Vishal Moola (Oracle)" <vishal.moola@gmail.com> wrote:
> 
> > We should do a better job at enforcing gfp flags for vmalloc. Right now, we
> > have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
> > supported flags. If a caller were to pass in an unsupported flag, we may
> > BUG, silently clear it, or completely ignore it.
> > 
> > If we are more proactive about enforcing gfp flags, we can making sure
> > callers know when they may be asking for unsupported behavior.
> > 
> > This patchset lets vmalloc control the incoming gfp flags, and cleans up
> > some hard to read gfp code.
> 
> For the series,
> 
> Acked-by: SeongJae Park <sj@kernel.org>

Thanks.

> > 
> > ---
> > Linked rfc [1] and rfc v2[2] for convenience.
> > 
> > Patch v2 -> v3:
> >   Only changes the whitelist mask and comment in patch 1:
> 
> I'd suggest s/whitelist/allow-list/.

Yeah, it's the modern way.  But this was below the ^---$ separator so
it went away anyway.

