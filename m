Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337FBCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6104A6B00A0; Wed,  3 Jun 2026 11:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7C26B00A1; Wed,  3 Jun 2026 11:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524BB6B00A2; Wed,  3 Jun 2026 11:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 452896B00A0
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:03:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0F8C1A03F8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:03:00 +0000 (UTC)
X-FDA: 84838918920.02.4FDB2E7
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id C21E4C001E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:02:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ha9muc9Y;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780498979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bxxSivwwydDh0iCuOp81j5cRKW09cu5s4VCNvENaBQ=;
	b=BiDtM8DaMeU1IWe5IRikVVJxWSjnkKvADssjmMTLaY8bs9pZJElZMuikKWc43VMipcQB+A
	ForWy9/YQczdu+Cw9nuqqZ16uUVleWARS0jimbINMaOTiXX3pUtuWuLCbnNG2XLLzDoiAY
	i2JYsGnzMlfeDG9DghnYtiZZKGH/Rc4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ha9muc9Y;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780498979;
	b=teGGdY91Yw09x1aq7X7YDUJCaSF1QzOeYP4UMwDHyAHEB/xB0dAPH7Y9ZMWWC5Sdep6ZdL
	97l8RQnhsrkJ7WAblEyQ9ovX3h1H6Rl29iOXmMYgq+9KgBoyt+3HAlhYMykZxD5CVRo7TK
	f3j0rWPUhQQbf5+lLRoAAU3rxundZ9g=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9157f7c1c0eso198694985a.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780498978; x=1781103778; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5bxxSivwwydDh0iCuOp81j5cRKW09cu5s4VCNvENaBQ=;
        b=Ha9muc9YJGx4fU71oMm5p6i51ljIsh67JLN9CI8sAKVVbo9Hw3etjgj1tVaNrK7mNq
         PH9X5LFQkpRgt31Sr9Za06ocuHVWJFTJw8egimw8U4NLcUbWUy6Hfc9kAiJfVgLLYZhV
         qqzpg7UdmliEANJJfQ+OLnCmF6jj4jQiwxdTOhWURO2AOVD+pfOScpW0d/v47TCLANa6
         fSeGFcsWZWn8Cn3pGMkDJ2MvC75HCADlSTq9ZLw0+txxT8yjqWdD+rN5jnACPYgKR8Dr
         DQdqd05dvjdbPToHA5wYZwt6Dg28rEf3B35COs7B1WMmSBwFKilSpzTksaQUDPrDkIuK
         Gt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780498978; x=1781103778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5bxxSivwwydDh0iCuOp81j5cRKW09cu5s4VCNvENaBQ=;
        b=Bro5GIq3D/ZfB9rlaCCut0SuuSsL0G7CAO1ofxMxuYDjU8syQyVshbcTzYcR8Qss8n
         +7uAUhxXYY/57NX2MOPVeAxOUKA4sAeooP5qSNHh6QUPwO2hz8np4BqT3bd2yVMCCMT1
         wpYZ382aZmgi8SuHv12Uvl9rPLD9ZHhGGy3jNv1bQXEPCU0aOk8/l97A2B6tzEBHgxap
         QqIezP8VVF2C0euAD5gASelVihwLvH0L451jPGQH3zX59xiYrf93KezWSjfCgKVmzSs/
         Hxde0P268z38rp5ip0/wZ69fv5VHu8PqLVt3Ym627jzmWl7D36NMbWNRa8931QdYjZcb
         i6kA==
X-Forwarded-Encrypted: i=1; AFNElJ+tblcUSQXiG/e0lEkEzOxutu8eEeHn6OSAkUGZVTa3GbgSduqvjMlbqwNeSL4Gb8XWijGUEjO46A==@kvack.org
X-Gm-Message-State: AOJu0YxHIqReIeJgs1bZXAHlSOoT+Xo+ByKXB+LVdrDa+mOjpnTS3r0A
	kVaQZvVGLiB4fmHDL5ckkCdfyB6YlKWTPRZPq/vOh7itHYzwoG5cdcSbUfempktfBqQ=
X-Gm-Gg: Acq92OF29O9bguVDPUXtk42n4ypfv+HKFl8ziQwe7Ah/4g7SbTLcN0MA82OmCdVO/Hu
	JxyoKwMZmd/TZ0oPzsxdttt72QwUE+a1A0aGkjnejr1qMP5A3avtzU+jozY0J1Q4KvkfQvC8axc
	DB1HunL0RO2KEBV9RW9RL1oa5pP6wWG0k5c0mC+Y8u7V9yyo0N2YHL3aSRAhu3fbuJl4XD13MZF
	exOE+oNQ0Q1nVx5XkxWsIRrzZ1zNMulYWTW0PqBbR3x6jfIGrJpwUK/UM45BEqQbdBkf8qyKtMB
	PRXR6mMbvQF7+4geGBjgcD8vlYgDozuIpyQiLQ6MAwzRlZP+K1fLOFOXDDM2F3RtPwSinHg064p
	yPCl0iMOA/ZCYVInD77eA26sPaQXXXAs2OKMjO1ky6yscNeZODOYUM3eg94eorNFIIratilyTTN
	ejHuXPtl71qfu3Iyt/SFSDySiJe31VqT81
X-Received: by 2002:a05:620a:7081:b0:914:7b4f:cf5b with SMTP id af79cd13be357-9158a6a84bdmr640924285a.16.1780498977286;
        Wed, 03 Jun 2026 08:02:57 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a21d2c1sm280915485a.11.2026.06.03.08.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:02:56 -0700 (PDT)
Date: Wed, 3 Jun 2026 11:02:55 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jannh@google.com,
	liam@infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de,
	vbabka@kernel.org, chrisl@kernel.org, kasong@tencent.com,
	baoquan.he@linux.dev, youngjun.park@lge.com, riel@surriel.com,
	shakeel.butt@linux.dev, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP
 guard
Message-ID: <aiBCH3EDpb56QlEa@cmpxchg.org>
References: <20260602172247.279421-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602172247.279421-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: srjbgxkd3kua7fgtb4483he59h6t1d55
X-Rspamd-Queue-Id: C21E4C001E
X-HE-Tag: 1780498978-551924
X-HE-Meta: U2FsdGVkX18Pjx6xXCsppDEV6onqc44+lx2ZXe8aGJEQtC8NzC69kY7gXDpmXZj6vEpLEuhP+gPWq0TSVi6eR57CB4l+PpMrzWKV5q+6rEAGZdCDUU1RLKs3+KvHm4tQTVLux6lxJ6yneBsivHZVJnPOGDEpZVm02I8h32mfe90KEGT0MYiopuvFsIJitIU0Dp3mHI0moqMNPkAsZLHhYelQ1/ECaAs9H91l9k9exA5BFxym+gFkDz1muOG8NT7+90I6Rpx7f/zUShcqLBwALSy4TiaDVPogFuUmDSDsbsrv/RgJ8UjBpYbq696rBDyJjWGvZ8O0uO4E4ZlPcKHIHvLHyWSmQKHIDzSyZhIcKzhjAS6tXzlpkthkI5vC+WvA0/ZUnoRYh09S3tnOrmGjMCJoxH8nqd0vItnAFOAKCLHjol7oaXSQG8pV7Fh+gt3UjNenb25ASXLTkog4/uY14iKDI3DeFlauLy/TuV6rd/o5dBa9mfmRPM83gl7bNKB3FPDR8ma+IA5byraZdVjQIRZ+bSJ3O8gfvNT0vydCbL+TlBn1Pp1L+pfD3Y/X1v5G2YVG6TRIi4gu2EQhudBI9n8o1cUboYCOs/wqi2W45hVJKkdbfMtSJV1kfvQX/kOBfJ6jJj4IeIWyl666TBKUE+dOYaq2fFb0RVEAnnuhJcTN0zqB+gFB7ofpxD3THsDDxfpy4GL++0/Uc281UQNhbS5lDicrbgKFn6BWhuQTDqyEdqtTnTrA9AtpjHkQ8Kg7sRglQ3wMJPCxiQ6fyQNlW2Qf8rMedeZ71BbaB03VJJu7MmLnhWBVnfTfwhGKHxTNiYbSoYjssu96p7oOwhEVnZdNxnrHzJCp/D51QDOY7ennLoDHx3m8NzkV4ex0aTfDD+g7q1gRL0YM8hqURQTkS6jXVXVO7CXk1QqDNUQGkD1YZJV3x3KJANBEjm29XWBggZU5+SMDT+9/evn4HOR
 WdD/AjWB
 mfRsJwUh7D8z2h6dNS2K3XXZEBK1r5tu5IlruJzs8FKu+vu8QI3sVOcgqzcGMoKY6W6MoteBzjGY7xznxAGbLiaAETFDm6CqhHOLHGGJekJpDfAe1+JPDbhWqkdrKuH7Fg13OVlIzQIMtwEJiU3lU1aGXNGb1n+boezkFQO1joWreq1s53w0ZroK660IoqR2xbVuuXbzUKy+HP9ACZXM3CTLpU6FeUuNUo59f1QQ1IjNoV3anM9CzhVRjT7sDcXRJUJshGzwwk4CvLOCV+Fj0VzqF5uJetx+cWMlYhtlIblvDzv9kNbse9FIu2W27bByZGL6p6h39ZiyZdEMRKtmAf4ANJ93Z7LDJaoSN/D7owsRkGrl+fdY+Qf2wS354CcQ9i3/LPXOm2moFoQj7reZv18fZ5nHBC6v4uINx8jccF3T5ob4BACRY7APZCt5664+n7FJMRTsGZos700BCuB44xe6TEXvZSiPIZpXOTUSO/j9Za5/TTmq2sChlopNeopoBMDgeyfdC1irXjlbNg6PzAMDGNPQNVscwrfxZsJVIMZaHibw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 10:22:47AM -0700, Usama Arif wrote:
> mincore_swap() also fields migration/hwpoison entries (and shmem
> swapin-error entries), which can exist on !CONFIG_SWAP builds when
> CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
> !IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early
> return, so mincore_pte_range() can spuriously WARN and report these
> pages nonresident on !CONFIG_SWAP kernels.
> 
> Move the guard below the non-swap-entry check so only true swap
> entries trip the WARN, and migration/hwpoison entries take the
> existing "uptodate / non-shmem" path.
> 
> Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cache")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

