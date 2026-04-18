Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CED0F99C96
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 20:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2BB86B02DF; Sat, 18 Apr 2026 16:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDA56B02E0; Sat, 18 Apr 2026 16:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F27B6B02E1; Sat, 18 Apr 2026 16:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90BE26B02DF
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:49:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16D9D1B83ED
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 20:49:57 +0000 (UTC)
X-FDA: 84672868434.13.2D93EB9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A8CF140002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 20:49:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nLjjs5DH;
	spf=pass (imf26.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776545395; a=rsa-sha256;
	cv=none;
	b=VsTARsiIlkkCKLD0wZwwu7eePm/1uboquSXKKCa/mzVc7V1tqkH6wdy+TE19iEIimY3Le5
	f2BzyYw7+/STLPmB5HxUNgyymwsUUBjyLpk/XRWE2MbuBLoizcd0QiY9vK5g/jC4Memg1A
	9zUnYmjGOz+dnz2zYEh1WZmw5G73WLs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nLjjs5DH;
	spf=pass (imf26.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776545395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lPWyzCKIBdd9deahh0XMq2c/c6Z8EIb5UdlH9Omj8rE=;
	b=HMJCwGHbhY9qZjpyc/CYVEcpiEbqHUVokw3ZyDd0siji9GcMZPmJkIsRsk89to0YLKCJx/
	D/JHMe3i1IsixFhh/jbmWA1+WLgAoeuBAQGgbmUXQQOvPNIUnUjffmn9ssg12AX2iD8BpZ
	Ht7OHfYGaZmgTK9EeSAtz+24nZH3Dks=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83585168F;
	Sat, 18 Apr 2026 13:49:48 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5822D3F7D8;
	Sat, 18 Apr 2026 13:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776545394; bh=7rRzjdaoHeUV1yvrxq1rjjB0hpgHM9ztOSPhIFTKh2s=;
	h=From:To:Cc:Subject:Date:From;
	b=nLjjs5DH0Ua5b8R4mdWyr+b4VFdGT+bybJ9kybsMGGoO5uryBV+PaoHv4UBcB887r
	 tY92Ya3mSHC4x01/6JDi9IuixEolf9Ky53ZV4xwkIYgVjnZmalKgqSWgXrS0EOmqjZ
	 bgQnB2/N2PRGUL/GBEVXDAFVKulDTTPT1Txz/cNY=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [RFC PATCH 0/2] Documentation: maple_tree: Improve statements on reserved values
Date: Sat, 18 Apr 2026 21:47:52 +0100
Message-ID: <20260418204754.120405-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A8CF140002
X-Stat-Signature: gnxw8ngqrc4xdy8wwbba6psfis6tkoqh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776545395-383417
X-HE-Meta: U2FsdGVkX18pRD3hnPX5Uva6dcRRA+e8euN/XVRVSmpPcTuiNG0lFpddgmRKH5EA3dfCYSLGVjcVqqWQSfv0NRWCo6VdbMXiujPPadoj4V6zdRioXHCScTPF74mNDDWFALd1sG1dVDQdU5KX4Gm/x6PqAJvIQToKOMQmYdvBL/9ODaNH8VsTtMRNe7cyXRHCtg6jDCIJntawXCDSXbgYfJIW4EAKhoh1kCQDcLYYzQhiqwpb1llTKqFahBfhdBoU1h7n5fZ2JDRK7VbAse3QCxwZm/2JNT39cGk6v2WD1utCrWlfifIbm/rSR/o835ChkynVN+EvZ1qR4c00E6yigWKfifEUMBSiW/0ef/NZ1lEMSlLQ8ZiZVCW4Hphnttp42vjLcabcNfw5a1XdBdCCk8WwhTcJOw/9igoFZMZwSDfCCpW6DIQw9xzh8rm37KX0AkDwDv5pn91qSMswavbhR1JSDpCZnbd7E1U6oGxZngcw9TupFMA09DKtoJDU6GqbP0r8sOC70Z43+NuPHfB7uZNQJAAkA7TRCSxmKsaHET0mZaV3FBfuoIMFi+qsF0kjJsz0aSpT35hdvzVxw3nlkszKJI1aCBxPV+8NQDDmtX6QyVcz30OK5YQikPA5MqDccCZWtcX6MpOegNQOx867lAS8hjwcJjkSTcGjTJrH4Pabqo2diIH59//tmOlXxIHxCa+PRsYjib84Njb7mpvTpUGg9k5R+Qfc/MoDLUsogCHwmiXtMd/P3/a7a2rrizCeVS4F0i928eupm+zz15Zuxrhoes82R/FTk4DBDLEzCSTOF/cz3a3LmevT0bcToDL03pWmqFyGC96wL8oMZ3JdPDunClhfsOV5B70R/HdLz2sFPZpmv14l/hvyzQ7aUgbRBFRvycu4R+5E8BPgOPGvBEbCmlMcsJgmt8jRVd5zGyIj3WhlUPgEYJQn3aUchyLnxNI0aH+2G8D41bu/krz
 Vwp4g9GL
 8pB826knKo2aMprrg9WxSH5fSilpjMy6CAUd1wuqCkNkW1owaH631BKkpSPq4ASxkML2/RRaXbLOlFcN7d0jyP9opwaHhmQghARnLxWfCaPk8XdoLnAD3SD4w5lXG4QPeBJJM/k5vvgtUt9SB4MgjeX1ZUN8VJNj7o8OuErh+ZfxfUBJr4ZOS0hyRErlTJ7EA6BKcyDvPGQX4yN2hYOM/SI9GrV5HtdFHhRXL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

While using the maple tree and reading its documentation, I found a few
bits confusing, mainly about the reserved values. So here are some
changes hoping to make things clearer.

I am not familiar with the implementation, so I might be getting things
wrong, hence this being RFC.

While looking at the code I also found that although the doc claims the
normal API blocks reserved value stores, the code checks this using
xa_is_advanced(), which only blocks values up to 1026, not up to the max
maple tree reserved value 4094. For this part I am not sure whether the
code needs to be changed or we can also improve the doc.

Any feedback is appreciated, thanks!

Wei-Lin Chang (2):
  Documentation: maple_tree: Point out constraint when using xa_{mk,
    to}_value
  Documentation: maple_tree: Clarify behavior when using reserved values

 Documentation/core-api/maple_tree.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.43.0


