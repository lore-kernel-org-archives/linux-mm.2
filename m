Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58370C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C42E6B0092; Tue,  8 Sep 2026 10:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E136B0093; Tue,  8 Sep 2026 10:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2652A6B0098; Tue,  8 Sep 2026 10:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F35C76B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:51:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67CF91206EB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:51:42 +0000 (UTC)
X-FDA: 85190884044.22.2B19DB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCF63A000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:51:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbHDg+F7;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788879100;
	b=ypzkcAFiWKGWi+S/sxoGfjdy0QNbPVs39fQf7WvYpjEAN8pfNM9K48Bgunnrtn1z1D0PvM
	orVmos54+fxUiB4Iqj6QlmxSrpzcyafoLYnJic/rDMK7x71PhmTe4FPF4ujDahHasaRGiG
	usCR8tZdvmEmDDR57BUrJLTUhb2DLo8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbHDg+F7;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788879100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HhwnTeHEt+NjdQZ0IEPNu7Xi23jc3U/hYhWJffOVLY=;
	b=X3OiM31ZSKZb5v6f5G8syUgI6vfs3RhIdrZy8MC7UEs8WkCg4R8xWDKDapYz6ShJftT/2l
	VDCkoHy/FXogVhcs5nvRNwIX5TKMZmO/f3PO3VMzi8a6+zSZVUWttcOrJGv2nw/OLWTVrl
	98MtdKexmbOnV/SLaMlT6FaCHnsTtqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 66EA4601F9;
	Tue,  8 Sep 2026 14:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2E61F00A3A;
	Tue,  8 Sep 2026 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788879100;
	bh=5HhwnTeHEt+NjdQZ0IEPNu7Xi23jc3U/hYhWJffOVLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbHDg+F7o02qr1+zS/Ce/1wGsbRYhWnb9S5/cNXzn6LUnGYfnuDTth5KZAYMF/ONO
	 /6yxAPiuddWLk5FN7T5fQ+Xh9NKmAXDohX/0mdnjjhOF5uzETeXg1dH0MjBJNpsQ7N
	 R1s2H+Uv0se7TarcsK+bV0ylmU54WH/OfiSZt3voHpMXzSkfs3hDJRXiaoMvTF2I20
	 BstKpmA9bcchQ7JWreVjAd2MO7F8jZPaB6zeBd75Y/iWJ48w6rRepNd3ErNiDmkn+Y
	 WuMn39iuoHUKlE3ExBcS68b416nm8s7bRMOcqDTrIImqBimpvzrpqLEIhqcWOXeKVJ
	 lt1JsJdC7NwoQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/damon/core: fix unconditionally skip last region
Date: Tue,  8 Sep 2026 07:51:32 -0700
Message-ID: <20260908145133.105111-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908134739.96919-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCF63A000D
X-Stat-Signature: x41xq3iiaoa9f6nd67qdfatxka3dba63
X-Rspam-User: 
X-HE-Tag: 1788879100-259677
X-HE-Meta: U2FsdGVkX19A3RlMYMXs5tMjvyoYVNS6nFOyr6pqEUM+7XOysbo1z1/uO+iwZacX0szHrMHZ+HKiD5r7k5n6D5lhHXEAjAlKykB4/uAETQQ15KUE7AaXl9WjTysAQsnCAyOOmBrj3ipEKyzLwTSsoq+MDqcwgV4jYR1CpLgvrMJRRVEr/h3i4xErq2UjhOgfDTtgZcVjRKT7VJK4rEpIr/w60sItTx4H91/VpRYR41zGqTrDTZHorrjeijjDmxSqok5Aa7xKD04J4XPdyL3KnGILAIdygEiMQEwVR48au5KsgxPyAdwpaJQro8BYGBXqjMhRIrTp8IYeSvvuq8BLZCLQZ+7t2Deu/bGnKvDVQDX7sxmbLtvF0KodU8QjWxEAETyBl4cyBA9FITDFRfJwoBBO49cy5VcP8Bf4+YIDMp+LaO5OJb6C92ZQV+kgOtRgc+1P1e9RE2MLf9AJCFosWNdvJ3x5AeO6MvCuwdFzJf6CY66L3AUBp4yaW+kqM8Kx3TqUZdUck966HyHlSLwjk5ScD/zL+IUm2fke4pA6To8Xsbpyb2i70NNgtZmCEQkhXaISJivRUDQvmtHXc28IieFYntmRvMnW7VjCxn45dBuA5trGe3tS4ef3acGb2U2kDn+bg+xghBepDH2RKuIh7zt8Td2bUeQiBATBzW2e/YS2c1HXgj6SE1Yaq/NxST4YXkQmU0GtSwPe2mnB3XtfAH15rWnuBCvMrpuk+NW9chEvxwl5vg4sHvi1brqQ1vyEBVwAZh3JM18B4QGOUwxV/mNlCw0roBzyAnJb0KMFaqxMRBMdprYA0Rd166gbpgxjVLHfXPL39K+cFUm0l96fxj4JXWFU/3lgw1IBHY7qj+UkK0yIAWbLicaU6yUzks7cFZ3n/TucDMeQpNVDt8E0thSMEhjSpD9M/LE0QkTbn7kY8u8F9bALMJYt8+y5oYlefm37WWLXLQt2VmhN6jE
 bQ2uJ7CL
 YwyuGz3QOTzzoZjG35WwxyxtUdj87L0aQAFt2WmqEIJc0mVyh0wT4GYyqOCg3rY4pv4/vnqTFt6TPymXxuRy9GTujPCNqRF44OOrr6EbCkVON0g9lBB99T4EeamRdqnP3k/VhAtQGBXsDyclYBytR6V3GrNVn+P1wzmewZajPFet3DbGFuKJF/0OJoYDPP2n+PMg6/NDZWo+k5M5LOHVqrEX9Euss1Ti3ZrnDROcGRY532Bp3Rk2NXAqUvO5+o2K2LB6g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  8 Sep 2026 06:47:38 -0700 SJ Park <sj@kernel.org> wrote:

> From: Liew Rui Yan <aethernet65535@gmail.com>
> 
> Once quota set, the charge_{target,addr}_from unconditionally skips and
> resets at the last region of the tracked target, so the last region can
> be skipped even when it has not been processed.
> 
> Example:
> 
>     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
>     2. Quota is configured to process only 100 bytes per window.
>     3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
>        addr}_from is saved at (Target, 100).
>     4. Window 2: The loop reaches R2.  Because R2 is
>        damon_last_region(t), the old code unconditionally returns true,
>        skipping R2 entirely and resetting the charge_{target,addr}_from.
> 
>     Result: R2 is permanently skipped even though it has never been
>     processed.
> 
> However, it is important to note that this is a very minor issue.  This
> is because it is triggered only when the previous window saved/kept
> charge_{target,addr}_from, and in the next window, all regions except
> the last region were skipped by damos_skip_charged_region().
> 
> Fix this by only resets the charge_{target,addr}_from when last region
> is reached, only skips when it applied or cannot split.

Sashiko found a pre-existing issue that I'm separately working on.  It is no
blocker for this patch.


Thanks,
SJ

[...]

