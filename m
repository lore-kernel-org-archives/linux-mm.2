Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5F3FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61CA76B00A3; Wed, 29 Apr 2026 10:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F34D6B00A4; Wed, 29 Apr 2026 10:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2106B00A5; Wed, 29 Apr 2026 10:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2796B00A3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:31:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDCD8402C7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:30:59 +0000 (UTC)
X-FDA: 84711830238.20.4E1EC5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44867120017
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:30:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MpHYf61c;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CozX5yN+C/Dj7zBL7UIdfLxCtT2GdXLK3PoM/jsywcg=;
	b=g4Y/L44dLEJikH8oIyTXBacmd6N6Rae/syF55RjwBxT4tXXZ2GPYQlkbN9GuHM44odWPJl
	+TScELCSzo6FgU8cI6Ry+qnVhtTSImTTJY9PCoj1vfYSt2ObbKp/2Uq83iztqwyyLxvlYZ
	HjZVRTuNb3DcPnL59AeigDdLyKAIs0I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MpHYf61c;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473058; a=rsa-sha256;
	cv=none;
	b=D84Ks1fQpBiigt5jX9RYyPHkAMncUTiKrGqEn4XBD3lz9OFWjJ9sLX9MvmpSvgF42a2POZ
	hN21XXk+qleeqn8vVXhdibwlcW71Cc1TWkSgY0vNnh5o43jsvtNei+57OlGB4IsT7FygNo
	mTD64yJPjHGSNOZS/2f4xUguR+jppKc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7363360138;
	Wed, 29 Apr 2026 14:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC29C19425;
	Wed, 29 Apr 2026 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777473057;
	bh=25669eAlVbHfJezMpC/Kwl7iJTxvlFiobYXmEPt9Zd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpHYf61cRXlTqKuG9hB/u2iYXkA8SBvIMFOOsf3G0sfnfysZAiE5ds17hQr7DlAgS
	 HueC9gbqtEKddsPOx0JqDzRNoAr3kMIqTP5Cm3n+iiqu3itGt5OzW4sFEYYDT9fbGG
	 oyWPEswH2fz1o/FM4jKm7ZDtJeX4Cb9l7q5ty8aoGfurrUZWK2VJ8PE2dpHl7+TsAS
	 7w/p5L0lNyzhLStv2T2YtckcMYHEa52p54jioXzrnre34meVIFLc358WJ95Hy+4Kg8
	 dB66+tyPb7M1I3SJToJUdNjMGpRNVBwwQcCiPH+S+3XA4Oh+EjkQw15eFkMCURlA2b
	 lmlhFBWZVad7w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] mm/damon/reclaim,lru_sort: monitor all system rams by default
Date: Wed, 29 Apr 2026 07:30:52 -0700
Message-ID: <20260429143053.93890-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429041232.90257-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 44867120017
X-Stat-Signature: dnf6jii4x4kyrejs13z5bt53hn97nrkb
X-HE-Tag: 1777473058-779499
X-HE-Meta: U2FsdGVkX19Du6HvWMIfbQedlFK7jiVlGTormoMEEunWYQB/tkV5XkkxpGp4+ewaG9ENMXmL49nBl3nPkCYfjwhDpTMRUslDgL1NL6Yd+7Q39IJSF+YsyK/rUlXZ9jMxB7eoAHCgg/waDycaXifp7thNNutihw++vOHQC1QDgF021JLXm1hD8Uzgvc+JqXWuOmu4TdKq67EUjw/uZeAeemnrSd5WtX2qAdD4Ov2OaZWOXlXSGp/uS7OHXQmP41CIoWv+/u/Eb9vJsI9iN5xtMgosf69Z15poT6KmaI1u/wDKz8KaR3rQyUMTcsvjvdThGUu1Dj49/E4JIzpDMePD3ZVCK0B8SP0b7GV/MXvfRrwgX1m7wHdAaynh4pstRz3dERnVnhkcF6n7vFXEu0dVDTWrxGR5RVi7pa/i/xevTXYjXaYUcl2QAYSYYxhAHYmRiOZ85YRsqXIlixmzY7cs3lFxUUU2gp2GYUWDTYR2Zi3QJRoNdIRuoONMAOu98L/YNFrzVLBVZB6ziucVpe2hYE8V0JuW7UfbXpOjZrGLRVO6Ff5lig/3eenTqjcj6372BhqvfiBRLgyF4ODH58Ftq7wFq9AHm5bi9dkD9JlldVy0WXunNbxyvlvL8C+3SL22xdslHpl9P7mIAZdKvXlld1HFJ4y4C+Ll5rsoaqAG6H/c1KtsMzKxEt9b9lqsoIFL3ddVyvMqTXhHvL1kojmevXnz4s5z/C0YQWX5RBXKJNPXGbNoB7F67R41zQGwdIKV9YDOgc7gRtfY8ZFcDdRunE5ZG2av1R7q9Nf0XZpBnypol1QhEcmrq/J2EBmdEu6fErbdVEdbKsZRLgBgrrwJ8Dnp7pbBFFh6Z9cSOsSfAcbYfgxRSyGc2WH4X3ZMtNuRDjrSMPTf1JgG23PTnjRY7yCwzb0Jyzqe6YkDH7K0ae0tCN+zZQLjgoZAg067CON+QycNHWiMJs20hvkR5JU
 fLXBJqsA
 0Z/ySS0JIBHOuGYZcMBgUq3/ekNu9m3FwRIafOZ11Csrto3+rlQydHtUQBhuv1V4dHTbFTGRJhXoDF4Is64UOtUeF3wmnF0V65TXmXLYAlOcndtyU7CnOvpXCf1tY4S1PF7Qs1MBXIg2XfrPcjBwOdNxYNmcSkKtss3ES36KIXyIDJFV3z577MsuDy5Gkz808IbZJcEzouapq5pOFxYkj2f++u1CbLFKF6/w/bmxFswxXpueQ3lv9uSiUD/RBAruQ9oEyiQVVlC2TB0UEPGBAmSY1gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 21:12:22 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON_RECLAIM and DAMON_LRU_SORT set the biggest 'System RAM' resource
> of the system as the default monitoring target address range.  The main
> intention behind the design is to minimize the overhead coming from
> monitoring of non-System RAM areas.
> 
> This could result in an odd setup when there are multiple discrete
> System RAMs of considerable sizes.  For example, there are System RAMs
> each having 500 GiB size.  In this case, only the first 500 GiB will be
> set as the monitoring region by default.  This is particularly common on
> NUMA systems.  Hence the modules allow users to set the monitoring
> target address range using the module parameters if the default setup
> doesn't work for them.  In other words, the current design trades ease
> of setup for lower overhead.
> 
> However, because DAMON utilizes the sampling based access check and the
> adaptive regions adjustment mechanisms, the overhead from the monitoring
> of non-System RAM areas should be negligible in most setups.  Meanwhile,
> the setup complexity is causing real headaches for users who need to run
> those modules on various types of systems.  That is, the current
> tradeoff is not a good deal.
> 
> Set the physical address range that can cover all System RAM areas of
> the system as the default monitoring regions for DAMON_RECLAIM and
> DAMON_LRU_SORT.


FYI, Sashiko reviews and my review of the reviews are available on replies to
this thread that Cc-ing only me and damon@lists.linux.dev
(https://lore.kernel.org/20260429041232.90257-1-sj@kernel.org).  In short, no
real issue that blocks this series is found by Sashiko.


Thanks,
SJ

[...]

