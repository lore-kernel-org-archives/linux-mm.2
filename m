Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E589606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QzEjei9C
Received: by kanga.kvack.org (Postfix)
	id 5AD816B00EF; Mon, 16 Nov 2026 10:05:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E336B05B0; Mon, 16 Nov 2026 10:05:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BD06B05B1; Mon, 16 Nov 2026 10:05:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27ECC6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:05:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF51A140140
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:05:52 +0000 (UTC)
X-FDA: 85441306944.04.D1DC383
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0AA2540015
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:05:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QzEjei9C;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794841551;
	b=sC0jWDbPXP/xGkEVdI5rP3bVIyPV83jslHFUJ9pjh6EMSwgUbU8jfP7hit/5EGVnfpF4q5
	CcASDMJEtgfurEkLqSay59sxEDkfIxFjDcxuMW1iEO/bKfZRWsUZpmS8UOQMEfTd7zgi4v
	nKSPTTejf2gb8HiiuSAiaYYuV6FAPns=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794841551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWLDU4EWfngmSrcCkbKdVTyatFJ0OqjQckEYPqGngkI=;
	b=J/Wxqgj3F4Jhyqegm5T1xOm6IVHkUEoOPcwMNb6bv/wNA5cMqH3cOEPkGiN28fv5xXcLfz
	fD4D+6pfolmJyaW+/5OZvwwTR+0o6vFCb0jmQfvnf1tWu1HN+IxArg0Ze+nnZT/MO+8wNj
	Jse+PrE0Dfc6T65WNhv2pBgeGr9c9Xk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QzEjei9C;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 430E543C0B;
	Mon, 16 Nov 2026 15:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84921F000C5;
	Mon, 16 Nov 2026 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794841550;
	bh=RWLDU4EWfngmSrcCkbKdVTyatFJ0OqjQckEYPqGngkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzEjei9C39bx/30fiWMJo3u/F0Eq3Uvo01kc85HuJz/fp0oiWeQJN9WJmLneGSbB4
	 JhADs6kxenLsjsEL2WN4qqLDkNZ2uvBsFHxm7xwrAc5+vhpAFHyO6TmkxjSMahmTSs
	 SCfr491ibmKagCRmtUKAZCNPUsN8vuxLw5eWgcVnCRkRFouDn9yphQK7NheS5iCUW6
	 cH5+DtbGmjFPqbBkltdlHReX2VhFskhdZTrFwzMwa2hreaGIhGcsoRm6qKufflW09c
	 oLhVcGmBh9P91Ok+9cBl7ulFynGy4ShKnKgO9zfiErOyIj8FKDGBhzkaFQMljejseN
	 YDRykM5cIFyMg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [RFC PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Mon, 16 Nov 2026 07:05:42 -0800
Message-ID: <20261116150543.80514-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179481501691.2405628.8067144236288202449.b4-reply@b4>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0AA2540015
X-Stat-Signature: izgenbk99aw7xmg4a71jn6zux8zrzqfi
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794841550-430705
X-HE-Meta: U2FsdGVkX19zihlchkwC1E/yzcJuyMAIWzNtE0LTWNMHDbOWK8t6wrW/gXYTIcndkDS98/5+y6tJQ/+jngrM4ig8/h0P0M+8xN/iGA1XGMrozePgFW7HA/T0UBO+Q7ZDwvY+xyosT8B0loJuhswZmwei2/xp4NAkv4jVo2X3GlAT4evIRmitrnAMCUhl+0BcrN/xvbgBd7j+9TkF9ByQPaLuQfo2WMoQhVWmgBUqtaLC2C92xb6B3E0BZ2M0u8fMxLhgPjG0jd1uBlSQQeOmyrNgWfadaPjw9beztDdS9cbzLIy5q1mqZZggoN+hqTlA+7sEEe+wltbkr+NbnT5yf23q2HWEqke4sSHJvWbs69Kn3WAoty0v3/0Q16Pti/pGf+iHVLKoRU/VIFqrz58nkWDz/yYlGNTJaR2VN16T+2cK1u8cWM23ba8v+0RLZgo93kWDeMaGLeUWjxRQJTfekRaKhyZ6+Nh3NeVlIbrpnP9/rbWzMYFTCw15Y9yXhRr5aRC3wR3IgMVRcmzuZX85bQZ+Z2qYm8wlX6+pxhaeqvfAI4R5upb/WDOWgZ5SahnTlcMeuZI4dVfnMnkv6funy3an1+Q8zhOnyW4uIjmarXYMDaBV1IIaQtz6pKscTvuM4L8ucYBw/LWEW4RIrM5C0exavK6cBz8Dtc89mcL3TdCqzdHM1BtoGL9E4DuIHlUIedI0BssXKU73b2BPzzgK0q4uLM+q/tgapVdsfew/tNur/MCcsjrCbHW9h3fOJs5MKHitX+Jh0QC7cni/USDZvSuK6cTxETluaI9a3sDc1hRsihTNZ/T4+shYQMUZOL6957HH9zZk39rWTooCGO8uZZmYJzI2CpmSvbns/wnzJ50XVOx/bDxCku8VAKTDfiTSQ477ZhcngFb8JFfU2Wn0PpXit8FZvmM3ZfXTtlCxi3T8MT7saynfVlMbh0x5fbdX/dF2db99ykXn3D/7mb0
 dzG3EQXn
 xf6qMup1VjZLSuD7S4jBsNIRCUaNibWTozuEB/zbZXvFI+KROtzmjsbp069kQYZ0Nf7OtFt8b1DEUPHKnehmQW5MUxysKKfT2L0lZ7Hz/yTrqXT6TC7i6XkbRM0GQNdYZSZaKX4711rMA+LAN+cXmhUdEVVuJQygK493Kse1VUSdlhix9g6s2Qutsl6DeRxg1ru28lFnwJYAMDdZ28v5NUpJ0ArODiGL7p+Myg6G+VSGSI0Ep1KNsHRTePfKzgq+456/xB4EM/r2bRnQwN5e5sFajrZDoo0gVxGjcRHXNfif6YjxCde0ouKcPBcatQyWrn0236QMu51jytMQY/m26NxUQdQVzYr+GJFqSqSvPhEBuZk/Pu71VSIwBn3/8RxsQhYTOOiZi4RMvJVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Aveline,


On Mon, 16 Nov 2026 18:43:36 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Sun, 15 Nov 2026 12:28:32 -0800 SJ Park wrote:
> 
> > +	case DAMON_FILTER_TYPE_REPORT_MADE:
> > +		addr_range.start = pa;
> > +		addr_range.end = pa + 1;
> > +		matched = damon_report_exist(filter->report_type, &addr_range,
> > +				jiffies -
> > +				usecs_to_jiffies(ctx->attrs.sample_interval));
> 
> Since the window is counted in jiffies and rounded up, how many samples
> see a given report depends on HZ.  With the default 5 ms sampling
> interval, the window is 2 jiffies at HZ=250, i.e. 8 to 12 ms, so a
> report is usually seen by two consecutive samples.  At HZ=1000 the
> window is 5 jiffies, but kdamond_usleep() sleeps via
> schedule_timeout_idle() there, and samples end up about 6 ms apart, so
> a report made right after a sample can fall out of the window before
> the next one.
> 
> With the queue indexing fixed, user reports submitted every 50 or
> 250 ms and covering the whole physical address range were counted
> about 2.0 times each on an x86_64 guest at HZ=250, and about 0.84
> times at HZ=1000.

Thank you for sharing your thought and test results.

> 
> Is this approximation intended?

Kind of intended.  DAMON uses many approximations for low overhead and easy
maintenance, as long as the results are practical.

For this case, I'm not that scared about such over-counting.  Users ain't
really care about the report counted just one more time.  I'd rather expect
users repeatedly submit reports to make sure DAMON shows the memory as hot.

Also I believe users could tune intervals, manually or using the auto-tuning
feature.

> If each report is meant to be counted
> once, maybe we could keep a per-context report sequence cursor and
> check only the reports enqueued since the previous probe run.  A quick
> local hack of that counted each report once on both HZ values.  If
> reports are rather meant to stay valid for a while, like a user saying
> a range is hot, a validity period separate from the sampling interval
> might fit better.

If it turns out the approximation is real problem for users, we could consider
this kind of improvements.


Thanks,
SJ

[...]

