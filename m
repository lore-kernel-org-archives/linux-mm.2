Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70BFC87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 16:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B14C6B00BB; Sun, 10 Aug 2025 12:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562176B00BC; Sun, 10 Aug 2025 12:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478226B00BD; Sun, 10 Aug 2025 12:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 321046B00BB
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:44:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6179137712
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:44:09 +0000 (UTC)
X-FDA: 83761420218.18.7F4183C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1231E140009
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:44:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xr4QrMgZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754844248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4INKBjZCoa63qIZq1qZKc4CHG1TzFT6Od2KoSqJoAU=;
	b=qWq68ZM7SrgtMhdYUxzFcrJmu3Kv/Bdryb1SgUzTcbM2jqYNBKS8HtIzxTc1ONkybL4d1A
	nebsKjna+KHHFJMB60vBqWnO8GRhPWyZ8S1Wfrx9ffc6miE9uT1A+xkhxvn6dxgZpANfrQ
	W0dlnBMitwJUmJ9bnoOGGcOsgebsnO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754844248; a=rsa-sha256;
	cv=none;
	b=BAhxVrb0ZlYpx3IGb1DgidulSDUoGtKt2dkKnd3K3mf/rP1hwCabWffx0Y/WZvojp0iwaA
	L8B3+vtIXAOzcRr6USvRilELVhOGtC1nZ8qcfvkKcNb96QWhkFHV4UezeHQmQdrb5pByy1
	qpeAnQ+lFJzDd7+k1HM5l77klaB2pOA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xr4QrMgZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A8DA61401;
	Sun, 10 Aug 2025 16:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584AAC4CEEB;
	Sun, 10 Aug 2025 16:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844246;
	bh=yv03zHw8OWUgZcj0WGN8WFz8nwwf4x0jz+fmzulm8FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xr4QrMgZsMV1cZjajPJEX44VF09NHLO6RjODWop99Rqyrt/gtNdxOxBkRzr2CRUgD
	 YynpiNmfKtIXmKy/F3UmeRrqcm/z+DX1JNAgsrjhka0ADNcTGXLZ5f95nl5A1vlSTh
	 0qClUFsfGl0YKNleRU0rqCiZKp23Q2RNn6u7uFuk9kv4pXf5OwFnGDz8FnQ09r8hP7
	 7KnjCI0lGMjKo/TRV4e20kvTcsHZlfUFRVxBQfM0E5oys26KTh+zeIg9b1bxUJRj8X
	 lGaWmswhgJlC+rOp8Iohjn79re4huEw7n6Qv8ITDVPrja6kABfQUlsJNGtR/YFO9iA
	 kMyjwDOkei5KA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] selftests/damon: test no-op commit broke DAMON status
Date: Sun, 10 Aug 2025 09:44:04 -0700
Message-Id: <20250810164404.47412-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810124354.16456-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jjxdccfi5d7ekuhztdzt14ktqj6mzhy3
X-Rspamd-Queue-Id: 1231E140009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754844247-846169
X-HE-Meta: U2FsdGVkX19FokSKYDz3VadfswM3XUoAdwZkIBJnb1zi4Yb/8uXKvrZK8oeLihPCeQfKtSbat7Kp5vIZs4QMAPJsXK+qfKPwo0U/Lu2+dk4PiSOzx1NbCs8aLNA4jfWf5s8phWNqNlqulbN8ezBf285iFOMwBXeJ0U/2Sn0nJzSQ2AFHMaT6lsC+My6jFfZsavLj/s1T95un/3H38XAuIHaWomgt9rora+z9P/475NqzGGzwo0R0genFfzJXJSxTVvGDIXtL4Lsrwg6d1mWTCK0Nn3XgbRO23BwGZ452HAjeP24kY3BIut4M/a/fh4Tch/ztpRu2CSUdJOzxNMR56tlH7If71d7KesXd/10H7nLOQkXdMTRc+SXq6s0Bvse4Uw7vcvNTYXzcKDY0KA/Im5GZucCP/N++PSsvBi7QyOAa9Ln5buEv8dILJuNBJBlf3+wvYubSvHg380oLSA2yOvBDWh066FfZmIcmRJ3oD71qIur2KWZiOIiivd+Z6zbyoWwQiW44bkyJh6f2JssI5ss28//b4TFeInmNs0BKJK5HdLpHWJRkHm3YQAvDxjvZJdlmHJn7WmJSLXmG/DpYljHlYGt5ttUug0qbzpLk38aVRii49gxAzlWPak5E6RD9xym48xVRB0evBt4iVkL1wL9OGfL2+5PE3QqlvfrPkCUPbkDuDXVdpBqwJcVxjKJqVeGQYh65nBckQqyBFPSjyyz7JWVgjIqbRt5aESBn2XhZ1+F3kkx2qrnNFayBhjVkOCvI8KkCS4Tib//UdiknjgA9bTpupXErf15xlzYe5JdcQSoNvVobvfOPjqZWcEPgOKOidbawlF+5U+gj8xmXX0WHTPlrPfmuYnHOswDr13kN/yMoRa4CkSopL8gLnoG9zCmTmktb5WPnMAKlCeQeS8b4nrxR37hngjDXqU7eqR7bp05+uyyZRHMQT28KAdU6QV+405zkSX+BzY9+pBG
 0ndUigzy
 qJvJMSaCus8h86DSEjsTA1M8XTaJXdAdIXoOpSc1Fr5ULRy5JXRMW9XL2gjP33+BTiu6pIBALSRsuHLgY9ntGu4jCJPKmPLWFHo76UFbhakRHxszGi67zjHDFs+JeUrbPAcA/RspvowA2m9D8HEwTaCXQi/6pRw1e1TUJKlQsDr0PxNOuGCR/nBsqgB2VWnxxtlB4Ipmr4jv/YWz6014Xvv/97td3/619+371uUfKS1l8ynqVKiq5AmPfRdC0fpGaHFGJUIvuid2rsk3zjL0iIR/I7Fxjpbb8XLJwaFzLuHgf/MHfea0NDU756w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Sun, 10 Aug 2025 21:43:54 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Add test to verify that DAMON status is not changed after a no-op
> commit.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

Andrew, please note that this patch should be applied _after_ Sang-Heon's other
fix[1] titled "mm/damon/core: fix commit_ops_filters by using correct nth
function".  Otherwise, selftest will fail until the fix is applied, and hence
bisections could be distracted.

[1] https://lore.kernel.org/20250810124201.15743-1-ekffu200098@gmail.com


Thanks,
SJ

[...]

