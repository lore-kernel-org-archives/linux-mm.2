Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DC0CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBFB6B0096; Mon, 12 Oct 2026 14:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693836B0099; Mon, 12 Oct 2026 14:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ACAC6B009B; Mon, 12 Oct 2026 14:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE656B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:59:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B202B80D12
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:59:27 +0000 (UTC)
X-FDA: 85314887574.28.416E99E
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf19.hostedemail.com (Postfix) with ESMTP id ECBF71A0008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:59:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=XvnGkL31;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf19.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831566;
	b=rdK2ASW+V6AZzVM2Oc0U4N9xNx3Jqg23RbWJlui3GHkDiB6w1ozJhsBp4cUQpw14fGuVhu
	rKM7EYLOC5imXl40/u4hHfhVEWCu6bKmt6qLwLXPuhTDeWjQvhrAFmoeqN06w7Ds1Gza6F
	eFBbjo5ioBENhtnr7rJYRqi/A9pl2ig=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=XvnGkL31;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf19.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lQtzq/X/JU52P/nJ09kQUjdCeEAwcZHCvd7GG32U+YA=;
	b=EWIVbw5sxwPh75B9FMkyInYlgurVQp+DSvZ6aYmyXlQj1RiztaYCH8puyNXI3f7/6bOjsX
	iqRGhL0ET2UqX39kiujvrRCWSSVelMDHj93eOrlnXGt9stizd5wTZr1IMXh4WcxJEhNq5o
	Nd76xfWPq4mOmsu+uMPpq6d2qDvUwYY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=lQtzq/X/JU52P/nJ09kQUjdCeEAwcZHCvd7GG32U+YA=; b=XvnGkL317Yciiwnhlpt
	uxNU+NQYKOZJwBDHqL5/wnKbQkPeOl3Jm7fpIqqkerOUAY6yvEiJ+0ia8xhPo1sXggfXT5rZ08LhW
	eFCvSlVA7dDqhW5reGRtVhzo/7gD1nmcWFg5ZLkk+sdeaUWKFe6vm2DLkZLgDOBmVFsIMe7TYhu04
	3nOyXfpQKOEiVzb2FMwaHhAFjdKqpCS0DPracO0pOX7tRDOt1VHmgQnVHLmFdgcebNieAX7O3fcxf
	UCZRkOz5KVUcfVdfYMUAOjNJngaSwFZT0PYZuTIhhG6FGNUYVavDi+YbdhRtxzkR52FqWhSVtHFFl
	V2HTePDXmEbdkgg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xGLBa-007pPW-1Q;
	Mon, 12 Oct 2026 20:59:08 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH 0/2] selftests: cgroup: fix the flaky and vacuous
 test_memcg_sock
Date: Mon, 12 Oct 2026 20:59:04 +0200
Message-Id: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPgtzWoC/yWOQQ6CMBBFr0Jm7SQUKxGvYghpywBVoKQzEBPC3
 a24fG/x39+BKXpieGQ7RNo8+zAnUJcM3GDmntC3iaHIi1LlqkCrcYm04MYSIipd3W8aRxIUYmk
 mmlzfcHBvdGFaTCTsxpUHavGULEYYtbtW2nZ5aUoLqZQGO/85XzzrP/NqX+Tkl4bj+AKC4f09p
 wAAAA==
X-Change-ID: 20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-4c394bf06a6b
To: Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2062;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=Z2VvVLAnbjtCkzf0kYPUOKm4DAlSPjDPhPZN1aphmow=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqzS4CKF4EbIAivMcZSWEvRAa98vfn3KI6iASoG
 7PNPCwpWJqJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas0uAgAKCRBRlgpH+WFc
 KhFlD/9pWcEXyix7CRTAaXzW8kmtJ/hGZysy4hFvGY2ZCzBLD8HJKSV28swbdEFjOBm43mSu4MM
 nEDz+wjGhPqRvaN5kdIn/5wnTfw5q0Uoow5SM/aj6jTVFs3YL9+aWzfroyM1drnkngXfAHU6Nm5
 5rNLaLRMl6+KTUDtj+B4l9yQFtJuuY+tCxFYVX8QZ2EE31kUTOmXy0beTRBEb7dZ3Em58yXvlIU
 2HOSTqXA2JMzIWaVoahMwdq1aNm3QAb1lU4B74s7rLgRopcpsLK7DCbCbTXiEJly22Tf3K/L1Nh
 VfN184A95DOvv9hgxA91nm1y+gqq67e0dbsmrTCrhpZQo/c60dg77ZmXxrRwMSCNFbGXeekoXS8
 6RleJR4BObU7CokbrOlba2eJr1YKnUzIIvNF6b1HjlRKdPkzIIpxCGp22jqn8r7jTFAKDT6xwJX
 bf+QZVbAH/kLT97IhG2/13JIi3qbvAgC8S+VE1/05NRnAgjkrjExXpFH1rVDSSdEsJyJfHrQ3ns
 ZK5foNFuTC2H0TlJEBaIrHSNE4ThLD4SH1P4JvpJORk13UCTkZZdMmobrZ42hjMIiIXL/yKHIVG
 MjXjVtPby3FvN+ZzBccE+Tk/vFS9CKmPdxx0Qr0JX/f0baiLUDCoGCnIE0VMQp+FakdxqisZAoL
 XBo3u8XhuwtNuzg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Stat-Signature: 6mrog7inp13qqyamrqbhst8gmizxse1b
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ECBF71A0008
X-HE-Tag: 1791831565-287913
X-HE-Meta: U2FsdGVkX1+w8sjRcscw1JKXJ8vvWq0BbmsG21h/7YmhexWaQwQHvNPyywvTwtpatCNIm0HOEx9zIYUb/LEVh5m8UA5aXWSnmac+wzuyzy0pmtU/AI3OAPuqNk3ETq0PN+IkyJwcuW7bLOKRWYpUAsR+CkYfkKrpUElsUWT5LVjmGllZG7e3TjUmU2hPng7FMPvN1B0u7jc+BHe/sysf/VRiVODfSCKCK2xsbw6GLrpSx/ZI1QlQnZhPmddubT6tppwnPnYmKIjif1aNpV8PsPrKpbn7gkHEmLbgFgAcWKNHLbwQIAuIt0YT3sORsgzt2AOMyFwS5pnYhHsPVev8jXue60/tF8cVbuoGwV3Qaszgf7dOTxn7OBx2iSeKlKmsE1jutpluM8bAcy+OTABRwKcmd5Q5lMGE6FRDU/fK3KY/ICNUAN+z1nRZOxU06TPnTl7I8V8SFwoecRGdKJgn/2vBKSP4t3kr689eEOrf8+qZrJC52nwU43PXB3EKtfqQyR2PsISb/FRj+fKFTlby+SIL2TMB6cY4VbgF3G5OQxmlOmmdLRri2TRfPVjBLLmeVJEeIYooLlof9EuJ4ri/qHHZZD+cUVgWvjpLLtWayP5CBNDRXdmpXdCM/EMnyh8BgNP/Q+SikIEVWwpB05rIdUpoBRLw1Wraayl+EHFawabsFv5hZ2fkboTwdlydwyofViLvkJAmWeocnxoznHB5w8FtYDyRAi3lblED56A9BYiK6VSVnCJ9ZnmSFM0V4kHZU/RYWhTWT+XiJi/tTeMKF/jA8crMMJGdJWoe5zewD/ZbY03zAfOgOIV5cLh8fEbo+1FAdxLa+3GXyrrgQ3obi7eKKwYHC/wvKj0Tgi0wLyOukapQ3bIdDXX/20CnvBMh5fYFJIqgv6oLLMPVxevoln5CpgtgQeL3lOe5j0Y9BvspjLFaQYMlC+57W5dS3U3t4iACZebxBxgP9DvcGAH
 Vxi/RFn4
 q3R43E+RiFIRFsvK4EQ46sK3UflS2AIjrY9FS8S7yUjSRYAzusKwKZjzZvNVxECYvSd1F9AMqFGeLqemCh1cFWJSdhraOzJJlvOkGVAvzybR5WrGA7sqoMzXjtw7fhTe7GkIlb2PKJvoYKtwKMP01PwqvWqsaTRlaNbTVO5j/e+iH2L8rFDetps2gQoAMRyPwa63tlZDayP1s2KANHq1dReZDxZkNzNk6LvMiHKHPsrIU2CL+DEc8Zbg5unD+3PmkItlwwgUSNAXEeqPgDC/YnzabsBxAqrelmPrX46MebbFp/uCfq9ONkP/8kZRTitc44eTbS4pCtrGkLdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_memcg_sock fails now and then, and many of the other runs pass
without having compared anything: tcp_client() checks memory.current
against the "sock " entry of memory.stat before the stats get flushed,
and values_close() accepts 0 against 0, so the test passes without
having compared anything.

The patch series
 * skips the test where cgroup.memory=nosocket leaves sockets
   uncharged
 * makes the test cause the stats flushes it needs instead of waiting
   for them: the client keeps the data in the server's socket with a
   small receive buffer and reads until enough socket memory has moved
   through the cgroup that a memory.stat read must flush, and the final
   check allocates and frees anonymous memory in the cgroup before it
   reads "sock ". No sleep or poll is left in the test.

Measured on a 48-CPU x86_64 machine, mainline a5ebb76233b79 built with
the Fedora rawhide config
 * as is (release)
 * with KASAN, lockdep and DEBUG_VM (debug)

test_memcg_sock in 30 runs of test_memcontrol per kernel; "fake" counts
the passes that compared 0 with 0:

                     unpatched          patched
                     passed   fake      passed   fake
  debug kernel       23/30    19        30/30    0
  release kernel     30/30    12        30/30    0

With only CPUs 0 and 1 online, the patched test passed 30 of 30 runs on
each kernel.

---
Konstantin Khorenko (2):
      selftests: cgroup: skip test_memcg_sock under cgroup.memory=nosocket
      selftests: cgroup: make test_memcg_sock check flushed sock stats

 .../selftests/cgroup/lib/include/cgroup_util.h     |  3 +
 tools/testing/selftests/cgroup/test_kmem.c         |  2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 68 +++++++++++++++-------
 3 files changed, 52 insertions(+), 21 deletions(-)
---
base-commit: a5ebb76233b79db01e82e061173cb73c6d2b5c6b
change-id: 20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-4c394bf06a6b

Best regards,
--  
Konstantin Khorenko <khorenko@virtuozzo.com>


