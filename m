Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC0AF8E4A5
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 04:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041796B0005; Fri, 17 Apr 2026 00:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019036B0089; Fri, 17 Apr 2026 00:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98C96B008A; Fri, 17 Apr 2026 00:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBDBE6B0005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:11:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87FA68CA99
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:11:39 +0000 (UTC)
X-FDA: 84666723918.09.68948F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C2A9C1C0004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:11:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BfL5v/l7";
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776399097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=NYdWVY0EeXSCiaHV5ueN9KSYCeGE7ECqk0VPPopD0Io=;
	b=ZRfnz77AK0fq6C/4+IYANGb0gEGNlIFUjofu7vTsWxKu4vNoYP2KnykpSGNJ8F0pfz1hMH
	pX6UMglder/hMNdWCr4IS/vTr4d09PKQ1pk0npAytsN2hW2EoISvEt6XQTx1KiOGAJvioQ
	dxjxutms+e0DMhdPMv3eSAJSqZNUiPw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BfL5v/l7";
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776399097; a=rsa-sha256;
	cv=none;
	b=OHaQpb4ICV3bnNHyl/fY93u8oLYhrikSrs4NC3mqbyfta38Sx+X3XcHc4l+Fky5R2eLIXU
	/zxpAz+DDRdW6T0Evav2wK2XGt2pqJSOlrEogNp68rBvOag8feY7YoNqFOqiPezLEaUBB0
	MryVVZOmjxFqpa+V+6cW7y1ya9ol7pA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3484260128;
	Fri, 17 Apr 2026 04:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA27C2BCB0;
	Fri, 17 Apr 2026 04:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776399096;
	bh=0JN/9l4kgZSdkL6WdcnhCnlJrcJAjpq6Mag7wHEsClI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BfL5v/l7B47k+jVZ1kJWsv22e3uw9v7vPcro0lWW+N+3HcbGEHUjaFOStQ0GUh+yT
	 CI1Q8zzo/DpHS4o/nzXV5zGvrNkHgJFEqMmH7L189aSa00VO+C8R3MPkT4r1Ilqnum
	 LFT5rRYzQiMjymS8rR6EmW4kX0H9MWjU+VlXPIXrX10SXziOR9FgCvKmWRy/s6X12E
	 77wRwTY/B6S48W62WvT0IgxbgjziycqRqQrP/QuPTrwp/cWdCW/p84GPNFAahCB5jt
	 b6+X8wjw7w93rSxL0o6bL07Q2vXPNyCazE9R6r22mxewzyw2+nc/25jXBH30QbNcKL
	 UGoi0p0wj8rPQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3566B380AA7D;
	Fri, 17 Apr 2026 04:11:06 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260416095229.d83bcb0f00859adcd5f90853@linux-foundation.org>
References: <20260416095229.d83bcb0f00859adcd5f90853@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260416095229.d83bcb0f00859adcd5f90853@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-04-15-04-20
X-PR-Tracked-Commit-Id: 70b672833f4025341c11b22c7f83778a5cd611bc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 440d6635b20037bc9ad46b20817d7b61cef0fc1b
Message-Id: <177639906499.3519243.17342913776148686908.pr-tracker-bot@kernel.org>
Date: Fri, 17 Apr 2026 04:11:04 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: bn365w48txddrkt43kebyxki5q6jjkke
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C2A9C1C0004
X-HE-Tag: 1776399097-397514
X-HE-Meta: U2FsdGVkX18Ah/t9NrxMnnzWajEuT0bCSrAPIh64yFeo4JzgYTEBJmqVcognDdzPN++Dkiv7HPDqE3ylBHsAV9SLbFedogucqkC+uCNCuCKv7rlem5+xYGC3sZC0Qlzdgn9dFk0JMzqrIvJRXx40jI5BM7jwRM33AOXLW63gpxBYYk3/saCA/lfmDY9t8JZkPB1NJWTKQQWLtCWU7jYdsdDFH853yziywh2EmoVmECBNpclfuMpkR+rtlS3SWZCApJJCq8+axwLegX2g6ju22N4qL02/h+eUHaCNEW56Nlv45+zmEWiynImlIZ7RgFfFprgnIrNnlF1UgoyAU6i6B9CtS5oIThirrUZLNyJffyfc/0AORfJN8S2tZDBP8nSlyCm3hmoBNGQpM1k5o7Kxylq3ZebmKqa19jo7vXLaYYj5zragzAYMScBA+xpyOGFFgEC0eILtXxcKCuIAbIO2QqfD6ZDGQ9I717CCsgd2WrYE2fzPgkMJ8I2Qx9KPYAxRe/nNDJpGtaYo9iez6D3WbbhyDXXuk+mTHIb/zqib8bod1ONdNqqiSRAaoq9JE+qoYNRtRi0KDHLA+/hnpSKYhFyB6Oxuvfikvt38jPTpB6ahO7z1Ndt6dNkqVIQRz3dDTehTEki5r8X/QGcPovWoBhUHGKnxFY8MeCarnfnxEQcJzKEp0BgvVuxuaQ2O6yUW+b/oeFDuvzkHNxkPH8i0yGbfx2JWdZ8Tyo9iTyI8lMPqFYUcFay+KDAPrR0t+9N8YBJolB5L8b8dUTirkB7aEr7bFWbDeTniWWFZBo9QFi4RuUz4QSi924e9x6QIz028GuqkRXFz3UxitwZ0dYqHOCsO4uDPDJSiOteMm7qlH2UQiSFfVUhZ22rYyqbQC7Es7nieJTClL1Omx4yI/zM9RG4u+43iOf8c7QxUhNZR+ff0QoS8gOf3t8rzzyz8g6Af6oRcZOMg22q4a2wsxnI
 8bZ0dbYx
 F9YZTE+7fTJMDGsOgJ8PPh6xfO6C65ALAZvIeL+ATtQ65xBJ//IRd1i3X9yWDHm9uQ53ORr3a+boDBxxKLoNKRxFUL2gpGDmCorPXrJ2L47nzLh0xnC5Iw3LG0PJ3mMhhCSlg6JjgKolfKkVX9nlD/o6RXqlHqZzeBf6+C5hfrg05y2PYggrhplKhJtT48qY1UilwnYVH9bhBqoV6gW2r0lEGsQSm2EmS7pKZM0E8A5UflrFm1T355KM91jUwg2ziP7T0G7okqHAVELgcw9hc6M+R7m58gFHFgNcIsgOIIdJqPcPOsfY4Z3EiQhZe/kYG1TZ0R9LdeCc+ZtmTZCh6XI2Mul0rcnRm5Lbv0vAuc2XJo9uxSikYLJ9pKqa4hk0Gs3yxjxlF4K+zmXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 16 Apr 2026 09:52:29 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-04-15-04-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/440d6635b20037bc9ad46b20817d7b61cef0fc1b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

