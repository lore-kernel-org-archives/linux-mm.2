Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58CDCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 15:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38CF56B0010; Fri, 28 Nov 2025 10:16:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D506B0011; Fri, 28 Nov 2025 10:16:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2535A6B0022; Fri, 28 Nov 2025 10:16:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12F276B0010
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:16:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C61F7131F04
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:16:56 +0000 (UTC)
X-FDA: 84160368432.14.6EC2E64
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F0531A0012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:16:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YjG4Ithc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764343015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaW/YoAvMSDe/moOCsqb0QJzpCY35I32KENZPoTiBUg=;
	b=oxonyeitZnW7BVDKi9e0PhFLBpGGOL5iF3gMiPLw2G1lg3HVIbVrrSjaOjGmBJQAT5H5JT
	hYtUzgW12PrXtVFLkS1Rz8bOIXMYRzueS9TN96SB+9FSEKCAHyvfmpiXPYl9H/rmQWUI+3
	5VUHdQJQ4oimEHnA9A1AbdQZmQuBkvE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YjG4Ithc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764343015; a=rsa-sha256;
	cv=none;
	b=NJSN0odw8RVSz1sXtUDQzt8oB/UMS2G7b7lHp8KnCRMDcODNMUJHwFLAz6nW2gtsvT4tyX
	5mLFUQHjQrxOqLXxq7FxLbMsf34mqdI2Im/FMA0FGQ2dexwtZhTsIRPLxTrDANIEUXP195
	0tpjA7KhTpDjrgRE96v0O2P7FNAVGNY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LaW/YoAvMSDe/moOCsqb0QJzpCY35I32KENZPoTiBUg=; b=YjG4Ithc1T0Ik2lhrG8fr4ojOv
	6YleouwfbfVKgMURgM8ubUHPfioizu72Z47W/+Gi6CQJIRfQWAqBsHYZNEkvxiCJ6paUudNWZMz+A
	rddV7+LQrb9ufPNv9f1f5keIPkSyn2L9OSQKpyCjXx1lswiX/TnrTkZLTsH8YWKh34MzsqCFzmQOf
	HRlKO+Un+he2XICk6+wGwfEQtLjpYkwOm12E+4tQW+zBRGdVviqU43TGabpdTg3fpuda5wS2/DE7v
	vZMWDZA02j87K/7rjEV1dNApUGSUFbaaFyg+Js7Wq9nTnhB7Yt6urQTnCWnlRncMXygodjVm2FnrK
	gylzBf2g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vP0D6-0000000DMbQ-0utI;
	Fri, 28 Nov 2025 15:16:36 +0000
Date: Fri, 28 Nov 2025 15:16:35 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
	axelrasmussen@google.com, yuanchu@google.com, mhocko@kernel.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, weixugc@google.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Message-ID: <aSm800KsCAptVZKu@casper.infradead.org>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128025315.3520689-1-wangzicheng@honor.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F0531A0012
X-Rspamd-Server: rspam11
X-Stat-Signature: qxrfk8iofp73yeshymqzt9wpmpegwzji
X-HE-Tag: 1764343014-137732
X-HE-Meta: U2FsdGVkX1/+AS5ucMr8bj0Pg695C8McyD7yc32AcjbN778b9qd3+77BqbsPBmcAzqz+xeGeo34lcNARRJlujJk104oaugIB+MvHu7ynUsQTeW5cLj8ZGPdXgG/I05KneKaf6NfPhL6Sd50hlsqnnYR8XvNQGBe472b4jw9BQPKl4NkDUHKrkK/jFg0h/izj9AcVQ6ZCVsmFV5NIYEQqh+ScVm0oWz45wK0K23xYh+tvWrShF3p7iFE90AtSnCx5XLIfuf/WwCGvgdXZcZ/3UFvWcmI+J+yQWDd/2hFlXIG43xpqH1eWOmLiD7106J8CaI5vQtbKuueX7qTTOX1Y3O4Z11+WVQUK5cIH8xHVytS6RCZDMLhlJ9IexFuqqxTF7h2tV5Bt+GBKGXiao2hwbJi5Wl/3o2dE/2RGkH1s8zjqA1JWcwG3dtVxLBgsqSjBIlexI8LFOKT2HplLVKCYYv6D+Pbji2Bl3Qx+ff/bsJm4mFu6QB5BUcZ6NbgKXny9X7YVBPHlSSmYllN0c/gyWg6ztkeMQzy5nrCEr44mj9/hmoFzHCXjhMOEwv9YjIChMNrn6HqROcEGRGe7dLh7lYm7DHfmgUZ1WcwP2nyK1m2QkGN+ZoRY9IxNdeeJWk8Ug46FSktfKmfbZMOjheWI0Cs3u/UdeV4qOj3ww6d/PHtNRPCYstoGJG0yL/cRLz19onsRKkdCM1GfpD3AVKYwZvjn6CzT1l7vQfGGIjcvAxv5Z0CGVWHrNUYeoKfxbF4dvcIx6iB2Rw6hxF9MLTPgKkIzga9JcB+EqVmvSEG9M+fbu9HYCFK0Uq/p/FAE/XwkNJeuUH4+tFEq0Yqq7IhaOTNYGcowFzVh+UiuPF+bK8S2FnUddqjUDl66jYwt/tg3UYBYYUUB1NWfIdKfo9xXyHYO4q2kbTRIPRqrb5hzFn5i/871sQklbZ/WCeDwMZD9w9BFEy1oKEx4GZIwIPI
 WJZqIf8M
 /9Ic8A3UMFCUMSDI5chi4y8G8myHMaUrNHh7Sg7khLQ/sbqQX5NkQuJYpUw8HqGja7SwSVzFTywPHiNiHeet4w9P5hoRwvleYLg4ZhENy6hkLDeQh7oG3K5R3D3phsyJBF5MR3ZQmndyR4zc4vCaRJ9polSmJ+sNaIWlCegZhsMzbR3BeuX/dFaCu3NzIitflwWxe3vHVhpqfy3372FjKD8AsjM4Vc/4adlto0VsE1T8Ftj3EwzKsnbs9MItdRIkQN/jtFMYYhXsk5YMqExJIg6aoejB/cFpwWvDiydVosk57IJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 10:53:12AM +0800, Zicheng Wang wrote:
> Case study:
> A widely observed issue on Android is that after application launch,
> the oldest anon generation often becomes empty, and file pages
> are over-reclaimed.

You should fix the bug, not move the debug interface to procfs.  NACK.

