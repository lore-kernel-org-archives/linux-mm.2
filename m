Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DC3606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knozuAXc
Received: by kanga.kvack.org (Postfix)
	id DB4376B05B1; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BCD6B05B2; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8126B05B3; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA40C6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2911C1205A5
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:33:45 +0000 (UTC)
X-FDA: 85460126010.23.7450E3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 928D180007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:33:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knozuAXc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795289623;
	b=ABkHPGVRlc/BvtNW2YKCp+6gN9zFtPz1hUbFotXxowIgaJn7oiKWkCJIWkrARAEa6xUfcz
	mEv9lksec5eXBoCSS5e18n3cfN2NH6Ha/eNitprSZE+OagTwaLoaAZcioH0S2Bex3QKff8
	H7ARBBQbQzGB7mJzrHHvagoSujPoRIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795289623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xi3zTL53/C0IsEtzXdFhLsnsp6QQLU3JdQrRy1JaaPk=;
	b=7Na9HcrMrRZ7PnUWukTBV26rZiO2QNnnHq0MJ8fj+mY3IuW1e08BkNeFZeiTubyKXad2G4
	yVrR1wdz1i9ELu/xbwIPdjflpUBUqWWVU/uGYxHSnJyS6pY4hWceHYLGIY+hkM6dR6hiFu
	gjKPq/s18sO8By+n5Q3ezCOlsLSjP+E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knozuAXc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD0E345903;
	Sat, 21 Nov 2026 19:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1481F000C6;
	Sat, 21 Nov 2026 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795289622;
	bh=xi3zTL53/C0IsEtzXdFhLsnsp6QQLU3JdQrRy1JaaPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knozuAXcAd4tXwrmiaQ6EyXhjtrKKjBm7PKg55wzunpzVBgWlcgk6coXmeC735AsO
	 dk10iOkF4ac0OCuRbxmiU+a3aHnZkoWQAi81SC6ut+lhrLKxZlpZxxSGcsu8qu+Cmh
	 kOyBoompk9vWsIzX2mOeCLSVyE8aGV9eObqNZq8MmJxHNdPHXdFvgkLum1a+tqfWSL
	 ORrELJWfyypz3sYusN0iX18je/blLnGUUqDcRSbwDoq4W9QB5KBdoulhJ6NM+cpODk
	 UyvZRQxlKeA874T83VtTXfljzYBk8jSGh1Gl46DenuEhAHxXSZdHClmBKT27yhBDqv
	 8Qftah592vYUw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/4] Docs/mm/damon/maintainer-profile: drop 'SCM Trees' section
Date: Sat, 21 Nov 2026 11:33:28 -0800
Message-ID: <20261121193331.108587-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121193331.108587-1-sj@kernel.org>
References: <20261121193331.108587-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 928D180007
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: boi9a57ztu6gqsj16sj7tyreuddt3ybi
X-HE-Tag: 1795289623-175602
X-HE-Meta: U2FsdGVkX1/Gx2sH6hVG5GVS6XlS7CuAFwZBqr6SISRjG1EtMeV8JpfAlWZ2lCbKrmhjLsT5enw6g2RR8S1LxDxg8pcmYGz03EomDmgAwwTcvCl/VQRhQO5+lkwphqX7lM1VHY6PYwYVyvdFTfATzrLuZXrCeF2oUfk36Zl6/aHQi6vt1FLEQUwS+7UHDfX2X+GGMtcPJbBHJiQuvlWCmFtzMpP924uWBMU2rFfsXm3GLXin9dbYpVl34fSQgBw8SK25Dt/d8CnfZNxWkRZceg+t4n2XWwCc6theeZHuTVZ1S/vbga3SflxkVR/zaMobpJl9w2tw9sEItFqzMNKNtqIbWLJ757zgOHZJNB0Gw0amag3YPWWABdBaddfrO/PEycOGrpuxDaC03CFMeMCpJNNBVNgHbSCrzveuh2aR208R6BjxyU+jhfVeKnM9eDMD9JpdfLOdmU7UySsXBO8nIsZVxG5b4ctuD4YdmXoL9u7ajJGg82DkjQCBXuAvjm94PoMK3CqfqQT+gTXhq0SymaxUIkzjAfaEZ30onbFRX0ZPNFEyIA1fAAcTVBD6RJOD9NZcbevdb7BRZIbi5HqxpOIKlHZIEKI735J7SQa8m+cwC8RKduh8XQyx/irCR7iAp9YT8iyQD1MyDBxEOEnW7UmFN999e6SVblY8gt340UK0Wi8D+wBdC2IKMrNppn8k0L77gGs/rW//5OzQEJqqeGDr2gR3/D6R9hc+El/RMzcIwlSiJY5fnCB0hvzwPjOaCQsf124ulJQ4dnpbGu3fHSL9uciMEADCoFiPXG0LYOxvEYoTFW2LIbyIuDY5uQzlYgmOAqFxtEj6ATuPNMY1qmJYt1a3m6bPw/4/INz4H8jelcNxqjoG0g/6KxOd8Wq7PsVZjkTsgcDV4tP0rBO71dXBBossONgpVTBqRCgIXxC5pS0GmuMWHg+ww0172Ujcrd4hCxefxhjinkz3bnw
 48o0Tgvv
 TmH+REGZd5w+G3zQMlYxLMuhgt+SRhBPpW+e/i+P5SK7yLlVVeXnoqYTvYMcwIBedZGl66u8SsN7gEzEpDDFVD4TQt+9RhT9iHWOpHOxhziztqLtGIFaetdmRLYejTAniGDrVNdAO8Y/PKIAAS5HK2zxCj/YWyMO9aZ5gfE/xMt9GsX7ENRB26tqZqhCttx5k2jmp92j0Zhsp3WH6Sbqfirn24Y+wsg4jquuiGBbNgt6V30b6gKZ8ugMC977ukV6hyxdyI8q86tsaTkdcIgTkHPrpzARNkLZ149Pw6ri+ucsWPBj4+Q3BMjej3tTPVAJ/sfcMVC47k2YMqpQUL9O/xCDowOnVjvqTKWePJ2ucT0HE0KmgpsQk8xb0gVrMpmQFORJC0uIHw+gAFjpzoP5PxyU1AtrdZRoXXBPizPUR1JNGWelQ2kL5qkYwXLvwsAdvQ5hRSTiREAHKevQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Right after 7.5-rc1, DAMON will onboard the mm-next transition [1].  The
major change is that it will use damon.git [2] as its SCM tree.  'SCM
Trees' section on the maintainer profile document will be outdated.  The
updates for the new process would make the roles of the new trees clear.
Hence 'SCM Trees' section would be no more necessary.  Remove the
section.

[1] https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git/

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index cc6b79c066a64..f9a8df2b11e73 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -18,26 +18,6 @@ the reason and what baseline is used.
 
 Patches should be posted to the mailing lists whenever possible.
 
-SCM Trees
----------
-
-There are multiple Linux trees for DAMON development.  Patches under
-development or testing are queued in `damon/next
-<https://git.kernel.org/sj/h/damon/next>`_ by the DAMON maintainer.
-Sufficiently reviewed patches will be queued in `mm-new
-<https://git.kernel.org/akpm/mm/h/mm-new>`_ by the memory management subsystem
-maintainer.  As more sufficient tests are done, the patches will move to
-`mm-unstable <https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and then to
-`mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>`_.  And finally those
-will be pull-requested to the mainline by the memory management subsystem
-maintainer.
-
-Note again the patches for `mm-new tree
-<https://git.kernel.org/akpm/mm/h/mm-new>`_ are queued by the memory management
-subsystem maintainer.  If the patches require some patches in `damon/next tree
-<https://git.kernel.org/sj/h/damon/next>`_ which have not yet merged in mm-new,
-please make sure the requirement is clearly specified.
-
 Submit checklist addendum
 -------------------------
 
-- 
2.47.3

