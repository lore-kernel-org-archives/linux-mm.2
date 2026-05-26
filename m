Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CECDCD6E42
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19A96B00BB; Tue, 26 May 2026 08:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA876B00BE; Tue, 26 May 2026 08:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 907BD6B00C1; Tue, 26 May 2026 08:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB9D6B00BB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:50:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EDBA1C0224
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:50:47 +0000 (UTC)
X-FDA: 84809555334.11.0A796AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A7BCF2000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:50:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWqZVU54;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779799845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=219z+BDksYR9TcZV2QFuw4jLlAsViJqU3lt1lm7RVNw=;
	b=iYJ95VgWVnLzpJK2Mm90gCJICaa0qqOqsMv1yaFEyDhQzybZhrgHPse31DfGSVsYtoR/0Z
	EKc0q2gygBgPievCCCpl6LMZDyEbQ4JF4EisVa7A9S3GTRIUNDS2GYSSaK48HmBlzJtlgc
	Ojn0s9gono9cDUr/+s9Gh/RCjtsOPzQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779799845; a=rsa-sha256;
	cv=none;
	b=yVnQNcrtG8mZTE/Nu9MrvJyQP9fJDBU7EAYtK4AH74p1DLDL195PHJokuvoB3IfuJrndtY
	hZ/oy/syt7r0zhiqUk4INH+Iah66zA8k1ODS81Ngd3NVjJ/u+5KuyH0nW2ggvgRaC2k0uw
	6kNQ4v0THYQ8mIjgvw7G5PKWAeZRifQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWqZVU54;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D398601F3;
	Tue, 26 May 2026 12:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6C31F00A3A;
	Tue, 26 May 2026 12:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799844;
	bh=219z+BDksYR9TcZV2QFuw4jLlAsViJqU3lt1lm7RVNw=;
	h=From:Subject:Date:To:Cc;
	b=dWqZVU548wiXJRd0+EH8cd6qHs/0bKwbd4Fv5fVBTkVs88GKjnxKpyExRAWFBfmva
	 O4AK96zJ0S5b7oJl3NGp/jRshlrnLsgDjQD5+rjVFKbUrolYb8fySwu1g0QCC4F2dH
	 1HMPxqWJhILkftPX0ck/H9bW/N7NjBeYpM8mX5v6ecb8CATZQaPOs6UFRwHrd7T+xp
	 jb8p3a4/h4NGHV7VrZXATgvmZukgF4ni989Shrm3avmwdkHrwjrtd/BSm1SRi+pK1W
	 ioEz/MwxyRv5r74PICbjnG1I0BZeyVwGamHD8SFL17dS6V3abd4oTujr1T7qi9B0xE
	 SryGvoavXBX0A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/2] lib/raid: replace __get_free_pages() call with
 kvmalloc()
Date: Tue, 26 May 2026 15:50:37 +0300
Message-Id: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB2XFWoC/1WOwRKCMAxEf4XJ2WopoOjJ/3A4NCVAlClOiowOw
 79L8eTxbXY3O0MgYQpwSWYQmjjw4FcwuwRcZ31LiuuVwWhz1IXRqmdUpW3wbNIsz/QJVudTqOH
 31nKrfhxeeCc3xmh0oA2kUKx3XZQwP7DnMV46DuMgn23AlMaG/19TqrRymOm8QGpMXV4fJJ76/
 SAtVMuyfAEoTHZGwwAAAA==
X-Change-ID: 20260520-lib-8afb92134307
To: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>, 
 Xiao Ni <xiao@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: A7BCF2000C
X-Stat-Signature: udjxw8xj745hcdbu8coqwsbxsjmciyy6
X-Rspamd-Server: rspam06
X-HE-Tag: 1779799845-675198
X-HE-Meta: U2FsdGVkX19gbKHZ2nkvv6UGqr9bWB5kCvQ6gCwC5E+E4cW+ZffV+icDulraB+oG7v8oKgF/jv3QHoQ4kn8oN7BaTqfs4S5+YXcnWFDx78cnfcX9ilKqjDYbANHfbLupi6/rnvbwwVjARsw/vfc1aPm2YZvmBo/Y/eHrNlkcfBpA4mDUrnivnV5ZD9Xak00LeKjTQ798Wg+AkUZ/WaNVoBtpdDp+mrHtip6wjzatKwDvKQdrap0LhbUtUiDq5gX/PuI8SzgpYpEhEyUqoJCPeAhSf7QxIK7PWOTznNSZIUf9mCJCprOfjLUGUNOKWq+sjA8CmLXokhrwbUZzKLz+ftjpWYIE7GIHGi49cCy0sK1CTpf1KFam5g49morzJ4g6zBCzsyxf7elbBAySUTeX3EA7fXxMYEewQWQdt7EDwf45L8BaZiG/6KWksacFXWyfbxDHxvWyPHUvzxSNMZpLS1y6MRrbsrpLKZaauG/sdz6j6D5C0rQqDclED+MzPrYiuJ0wqeUmNu9FS1SUoJgrXoSfvFlTqaWZDr3CMfB8oRbKlZwBW3lfkIazL+b9CUBRV4KrnIZ1AWIY0Y2wyUIr6tHSCgYcXv4wJ46BoGSEbYUEBFzHO+/p+yLsIh5ozYtBRiUiLmuc2ZOJ1xkiEQuzim0OC6vUk5cvHthxQdbhX7kPK4xOZvL6av8IJ4odXt0i3X83MYyjQOtMQmuVtdkM1cEFbuOhFrRtGSa/8a8JIkbBOWKXndIxgS7HAITY5zQkmcFTa7xUhJ8vvJLJ0jm7HZYFy9r9BiRpJW/GqhXtlod8NGVwZsBVBshTqLe7jV16uuuIOVlk91Bc1j+7pjBCwbagXrST6mIyDEdS3Lx5IczpGB05EZVpjj2j/fNVZbwZY/e6CE6l/hTWpkAWDcBV1Mm0FXFkMZvj2+CvxKlqNvochgZYyNbVqDlt3jTubmKrRAMaiIbfuP6RVlmtgXy
 vQUU7Rqq
 +ijV2gBUCQcuNB/hemb1/XxU2q/Crb1HnClZJ1SaYPXwMJRhH16Fh92OAdtTJqNZb0mvfA9B8cJFhkXJILlHoeCmJ4taKdEkhdzKqThtv2d71IdsW/z9cLrCnY72HTGMJS8rfdzkVn4qt8eHFnPwREVt3NkvHDeBocUmDsRRecC8KI3lwxZ49TjZTp9gl2nKRPBKoNjcsMCynvOmJKmZuGAaJcnxoiGx0EcuoEcQlGwIYEuoBehSwZanilvKNROTLtIA1m8I1V8faCjDVAeKMxf0XGFcuA1ohTdW56tN/A0stYvHEgDoeDCfRqRPNQzKRuD7JSsDZ2JkFguge86vNS67IFcRxOVo/MHSM180S2jyYzMl+J0DbStvmkDH1V0OlF+0mEbibU46nQ1jOSxrJzpuQpxCpNS3utQZQ7tX7s1T3TOmUnpTMMzdu990WAC/KdiFo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (tiny) part of larger work of replacing page allocator calls
with k*malloc:

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/lib

---
v2 changes:
* replace kmalloc() with kvmalloc()

v1: https://patch.msgid.link/20260520-lib-v1-0-cb3045bef2d8@kernel.org

---
Mike Rapoport (Microsoft) (2):
      lib/raid: use kvmalloc() in calibrate_xor_blocks()
      lib/raid6: use kvmalloc() in raid6_select_algo()

 lib/raid/xor/xor-core.c | 5 +++--
 lib/raid6/algos.c       | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260520-lib-8afb92134307

Best regards,
--  
Sincerely yours,
Mike.


