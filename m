Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AEA0C55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C24B6B00AF; Tue,  4 Aug 2026 00:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5989D6B00B9; Tue,  4 Aug 2026 00:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5C26B00BA; Tue,  4 Aug 2026 00:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2372E6B00AF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:21:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22B24A230D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:21:18 +0000 (UTC)
X-FDA: 85062287436.28.BA54C15
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D66940009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:21:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CWiwLOck;
	spf=pass (imf01.hostedemail.com: domain of 3u2hxagcKCKwiRQXUbQSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--wfelipe.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3u2hxagcKCKwiRQXUbQSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817276;
	b=2J0EMd4gXcuhguABQeEfcY7Ht5EWBBxONCfXZskEDWTlAdPPdKM+bAhTwcEG+LOJDdZH/B
	RN2vCSLJ7Z1LiuqlfWlv+W6/NDg2/zlXMpLZb41J8oROPeSC6vq6rsBRL6S8Akn7aUnR2H
	DGQJtr8HTrkk1DGZ8xvvTqTSwucV2/M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CWiwLOck;
	spf=pass (imf01.hostedemail.com: domain of 3u2hxagcKCKwiRQXUbQSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--wfelipe.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3u2hxagcKCKwiRQXUbQSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1EHxIenGghG1qcflV4x5EPNN6hTPv19+mMdXwN3odLs=;
	b=IYbU1qC2LX0MT+U4eWzk0xbUshD82bc8pcI7i1U0Ut1ich5pm7W4mB9tDCmDY75eYuTsJF
	1wfOMkA9pJ5lD/6F5ptfaTjHs8mw+GTa9STKvHfVeSuW4nF2i05nrmqC2ukiKzofZt8aO/
	U7fRlJKGgaWnWCPtFi7e44ytrNoGLaw=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so4243293a91.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785817275; x=1786422075; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1EHxIenGghG1qcflV4x5EPNN6hTPv19+mMdXwN3odLs=;
        b=CWiwLOckLuCjCngOQ3BVLHar5XUbyjwpBBb1reepFDILBqxxCkgDr/764GFp/KOAuH
         bPINb/uRHYr4PFwjdpuBdMtzjdgX1RfB76ZkNp3eJOEvFPpDYd2w2xCCfRD4cRdIlpyL
         nEPOZQ+ysL1SoMxU3BacH+4//zGCLraI90gge7Q8AQHJldVCJGMWriH5PLPGxqMicEcm
         IDBdHMC4OEFffSDeU51wi9l/+J9rlaR+tI++Gn5q+Q2+GUhUChFNDiQ0BMxdYrzI6MI1
         GGXr9dy6XkrElnfDu4PZYQ+g3HWHxxS3FfSEhqfyz/tLw1ve2gVsjIWaSXg7q9J8T9QQ
         iSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817275; x=1786422075;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1EHxIenGghG1qcflV4x5EPNN6hTPv19+mMdXwN3odLs=;
        b=dnVnpFc5irlC2JFrWCT0JNu+sbOwID1ouVvqEkk8am3eTj3EQGwsfXSVyJoAQUPE1o
         HjvbQrqsqLmaW8xuFpQPZdjZcD1GNfWBKocZari0PFo3Mp/U2SEePw/yClNoR8hekJbM
         hkHPD7Iagy2tqM6MnnAW/5MiNPfgcJhePnclEq77QGzwY+Z4a9erBHQOSn5Ufp+aieYS
         goWFTgGUzL5xBvmZYuViiWu0gObVRQij4b4G9AG/gqG0SqkKFtTpKubEVB/7KWZUMdj7
         6CyuGzWK8f8Nz9Qi9VNK5yXtaXwE8wRln/Nskvo/Cu53RkrLlSuyfc1LbOHhKxoZ5bXf
         DE5A==
X-Gm-Message-State: AOJu0Yzylf4TImflhGihkzn6yTfGywyM7wnKogdvJDEWe4gHcoTGUsHt
	LxJv5ECLmIKxlpbS5ihDmBwTxny9MkSDV5A3NkocY82RFfvePyCELNExmCbmGPtntIW/tCxcNpE
	pS2LJeeFAIw==
X-Received: from pjot9.prod.google.com ([2002:a17:90a:9509:b0:38e:1db:751c])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17c5:b0:38e:7168:281
 with SMTP id 98e67ed59e1d1-38fbc424a3dmr10661157a91.10.1785817275127; Mon, 03
 Aug 2026 21:21:15 -0700 (PDT)
Date: Tue,  4 Aug 2026 04:20:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260804042053.56940-1-wfelipe@google.com>
Subject: [PATCH 0/2] selftests/cgroup: test_zswap: fix single-core flakes
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: axgyaitekn4d5ignjt6i5x5qjgc96b7u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D66940009
X-HE-Tag: 1785817276-175911
X-HE-Meta: U2FsdGVkX1+qha7381kl1bq2Yq2t2+v2opE+Z1j1oVua66rgafh2Qz2yC+lQDP79wh9AEQSk7Rj45GO+W2Vz5b8+CNhJPMG+Xd2oO1huvuUEnElNrUXeBgCoWMHJEEwEacpx+o+39YKTqM/hTlwOXWVM6/Lj9WIsEmUMi9GruNg7vATY06VAE2P6mrTqnm1cTXfVUXM4vTqfF/nDXwYyAE5Oh7OFGOW2RrV6ssSNOEHfGuBTGxcvgs7BhX2OGa1B+0JuDx+NKaeCZyLil3fhaRLVPY6bJ8TR8dRbNT70qwIM1lVjZRbf+yB0P7bcvBIBtrE7pfWW7s9s6yJn7td+HaiehEfRSjctt7JiPTfrhTW6NAZ5+0wTgS+AVOze1y35LiRpF8ffgbf8GdTAhHKuQZRjlGCRad2d1twURaJxznnPpA6yVmhhiCJwDfDutQgactqjqXZLIhbFjnJ0zLPkWW3hfB5tYCj31PGca3rMifuhZiuta4h0iiCSPanFEWm4RDbsx3yr9c/N/iLt4CDmlOiOPyAzIzlZaVh1VADJEOOuTEQjCTXiuBOxZJKPFBRBoGFFjDTer1hoS2jlobVaVUEeu1W8OooGLSWaCDFr+v868hL0hC8+TtcabzoZDgpbXCEcKQvmUI7PrQ4O2l9wBdsjgVUX0UzybkoirAHV2Z1vqt4JycilqrNavx/HVapkhtVvRR6ohZ6Dy8YXMgqeWTmoZxh3WNp23zy9dgslViFA8/i7vBcqD0w6JocLSvjaGkC03wGDdxN/R6PlNleC0aOuznplItBn6zDYxpr6C0bMr3WH4tknTayyr7xc9+M5oqlRAQhpVpzDgS6eueuwWRGHKrpUETkFdzeIlkKadrZan4jgU+pt4aCNVt5ZaIVVFOTkLdAN+W9jIEExgGPJ8FRac98NsJMQj/Ol89n4TQgFxRIbkJmAwuljm/NHKJ2gabFJYfVVrP3kRD2noBy
 MHP6e/jD
 eal6kBtiHwKDW4E4u46LQQkfDpJH+6SadRotQLsv3OCnqnOGP/LdT5tjGsnrbgXQjVwEt+KLilwnTO3UvOqdRfvMGpOrpbZ03r470YhVmzeH5T0GYGh/+Khe0cdjV4Gq8WZLFcxidmwSasRnxdVplodsRgovBpn7iPMlp2h5acXbpmNvP9wGiuL1MmgZ+igroGUHK1eip6rnkYJ3IEdSxgDosVxQ0SKepkgBE7KJoUdlhHEBc3SSUnm9H/lOHTY+hNvYSD+JTN8IaLlYrEa2bOTppIArnjKAUyPWjZP5kDW/rzyA6v3sa4wBJ7vK6GUptRTNseMe2Kp7vucS5/FufVPdEDu7KOwCdu/iEPJzv7P9p82O1ZdnYz92JKH/TJ4rnM/a6zQJ+BwXqmztMbrxhn/WJe0R0GgguAPyUq+QrRrR0pUKx7RrST61vQup7c8r+azulDrHrm08oZhegtNbTpnOjT0+HCxF9XrKON2g5z2iO2EG62j4yFjWPynvj/Le5oflR8jq0zK2tasRi2bkWZT9Keb7RKgYMS1LSa6Mn34b32gUpFhqbPzbCw8cML4WtVflHtITmF1exmyRCMwOdwFn2xI0gFl38DaxUwOsW0EO34u0SUenhbrUzmAVJoZpWmbFn6fXRRcg9BD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running the cgroup zswap selftests on a single-core VM (-smp 1) with
4GB of RAM, test_zswap_writeback and test_no_kmem_bypass reliably fail on
the initial run after boot due to timing and asynchronous tasks not
completed.

This 2-patch series fixes both initial-run failures:

  * Patch 1 fixes an EBUSY race in test_zswap_writeback() where writing
    "+memory" to cgroup.subtree_control collides with the kernel's
    asynchronous RCU removal of dead child tasks from cgroup.procs.

  * Patch 2 fixes an implicit unsigned integer promotion bug in
    test_no_kmem_bypass() where a small negative delta becomes large when
    compared to an unsigned size_t threshold.

Both tests now reliably pass on the initial run after cold boot on -smp 1
VMs.


Wilson Felipe Pereira (2):
  selftests/cgroup: test_zswap: retry subtree_control write on EBUSY in
    test_zswap_writeback
  selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in
    test_no_kmem_bypass

 tools/testing/selftests/cgroup/test_zswap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--
2.55.0.571.g244d577d93-goog

