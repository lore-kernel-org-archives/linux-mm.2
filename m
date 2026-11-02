Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FAE606A330
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IOqexI+k
Received: by kanga.kvack.org (Postfix)
	id 4314E6B05B1; Mon,  2 Nov 2026 02:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408DD6B05B2; Mon,  2 Nov 2026 02:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E776B05B3; Mon,  2 Nov 2026 02:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 065AD6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:44:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EFAAD120C32
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:20 +0000 (UTC)
X-FDA: 85389391080.27.1BD5E4D
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4CB11100009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IOqexI+k;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793605459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GMp9mcTTKC9DHoWvLxRWF3MR+m0EkCxt9LMLL8huxSQ=;
	b=z/b0pGYRpI/OkyP7vQWOq0awLsmXVKrpeaJQDyD3bXay2J2A1EUlOwnkkXLahfPCNqtOYn
	Vfpv6GB5RKv4Mede7AAt6U6DyeE6V/Sn0V+B1WfG5mzS4JfMINeGlWIhhFDsh8RxieJdzm
	IAswkwFI972p4Now5dgJ23s2YoihSCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793605459;
	b=kO6GtDFM1kG8LRahiPUo+FALXTdT0KSf+bmX8SsSc1qHTc9+PT9EhE4Aj7hqwxfJD6xFFh
	ep+2SdE6/j99O7lLeSDcBkV9DvLBcyvn+OvushJRk/XINlt2dQggW/YyC/s/2pwjdn6qud
	6sfA9iW4v69KL92oRP/AKJmcFSEo4rs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IOqexI+k;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e0d885929so2155545f8f.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 23:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793605458; x=1794210258; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GMp9mcTTKC9DHoWvLxRWF3MR+m0EkCxt9LMLL8huxSQ=;
        b=IOqexI+kMEfzWP1YM6YXooO3NmwhhNf+lCIvjMu4wrGKcBpQ7bUwRTwE9Pgn2zVh63
         3EHbQILFJghaKo3Hk5AO7AWpMHlaVKE2q4cvO9vFBT5038+WANQQ9Svwa9rURF0SR8W2
         2tH3Z60cKSL/QbJJXp7tNKG6cWman9264r+5CN7zWJcKNJimjxTDR1pFD4EgbxWyzOxF
         N9dDGG070z/z95zRiDVOFNcXb24XQJMS5LcGYXo2bfUEqrmuBISgM6uHrjvjdD9EqcE4
         1lo3V4e4MgmSbe+757SsJcbjQAKS74H0IlYlyuY4KlaSBr2N4t/4ag/RHgkWWUP+dVwn
         W2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605458; x=1794210258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GMp9mcTTKC9DHoWvLxRWF3MR+m0EkCxt9LMLL8huxSQ=;
        b=QyDePmwTBMGwGxJbqQb5QLfcKYX2M1UdOivp77y6nsk/3Yz9RfCwd4pPAR71m+6esS
         ugS2AsU3Wg/3/uA2Vexmg+4e2Rq1rWKNJ2wE2QASfL0Yb2MUIW7ibV9/Yrq4Z3rqPJPF
         wvfkWvsAaqGJpLyBxQN9jeinnA9VuPtBJJX6oDvhdiWnv2YhIJ2X+5kWpWoriEA6PflA
         B2vybuBiZDpwKfWe9IVxlDPY5sRR33ReE89h6/751u52ITAloUpDndxmr9ol7gBlHXVe
         W5ACFZoMw776mmOoF3718YAYDnrS9YYjFLB9FxM5TeDelhhcoLiOrn3VoTN9GDuvPBLr
         8rLw==
X-Forwarded-Encrypted: i=1; AKwUvBwHcEUdkPPqIiVDBaIQXv974aO9DrKw523LLnrccpJF1ZBLTjE9WZ/vQK4tXwFVL+8LEjXZyI/W0w==@kvack.org
X-Gm-Message-State: APuU4Z88FJ6MPC7SpjWjDK1PtrepxkYvGCC4D+Y2d3qdS1TxuHKWy2t9
	o9cPvcgnEUJOPzWIiQpFsZYNcDpPsABKnQ33DpfFJ39+UHXA3PoPCV4S
X-Gm-Gg: AYBFou1Jqw9wSeDAG92AfiJSbK/y+8I5Oz5X1EXERVxVa1W7XZaL6K6xt5DPGcf0mWd
	nMvpXd1P/r01qq0QB7m06hfWC0BQbFJdlrVCYZIU39xUZuqTkD7Y8gQKzS7Q2Nu0K+o5MlSJgGE
	8zIDRt5Rx7VbZ/+zSgk/aEAgCrxC8iOYa7HGpwP/7k2Yyz1vlrSCjTw5sQ1lU1xaGuT9wxKc9R4
	rXUtO1nxKIxHeiK8d4FlLW9Z0r2JJZlJyid8epQR32HxDHB1NRDOQJn1UHaIsz2pj2khyEvi2qZ
	l8gSxiQGh6i07nvLamsNTCx8V+tjpbgq/YPQgwltQvprzN0d3wQiq8IFWX0mGsZcdtawnK2C7M7
	9CO95oe/vW/1/VzX14A04QY7e01eHE3pbV7mqitouqXasFMiQuHf7xxn7EqklTgiwxdTDlIXffP
	if4QLUPE2eaYw2pFe1Da4vTXhs6dAgndwdmLTZ/1ZlMtpVMxiFgYWLGaln1BURF5tIYGs2qPyyh
	T5z/sOJMirQBAlLE2g2jeTf6cvtHY9vFiojEVR7W9/1upEWvhVSeZuMZFYrhIeu90yFblScHdYw
	CIGdsZeF+Hm0Uw==
X-Received: by 2002:a05:6000:2387:b0:48e:20f9:8d75 with SMTP id ffacd0b85a97d-48e6e50b79cmr21195080f8f.48.1793605457581;
        Sun, 01 Nov 2026 23:44:17 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm18050374f8f.36.2026.11.01.23.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:44:16 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	ts930@dgu.ac.kr,
	alx@kernel.org,
	linux-api@vger.kernel.org,
	linux-man@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH RESEND 0/3] mm/mlock: make zero length requests a no-op and reject wrapping ranges
Date: Mon,  2 Nov 2026 08:43:58 +0100
Message-ID: <20261102074412.189554-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CB11100009
X-Stat-Signature: yoy7f8fx71pnyri76z4izjkfixjux8zh
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793605459-156644
X-HE-Meta: U2FsdGVkX18rby+xIUvF1EJBZz49o4O8yid+HjVdNR9+nibvvG56P07pQzvsJ2ALhq/abRtuAvVnAcZgCXR+wa8xNigEWDvq4Fa2BmApZ2u5W2j5tCN+/jTvh5H9jR8WB8h77BtEpudw1WgfOBQKrDAFddn/cK02XvggFyn/EeW7hH8j7PJIePFDpUiYxABNcOtnZU/bwt+pQIBLqdi6TLb253e3oOobn09ifxkPoQwuHyinXta56lueBL8VzhjRnxSWJT0UT1+v1gLuBC+4hRFuBMTi924yAXvC/26qoqtoGsOOrIrjiZlbXndemvvrZViSKPlmyMDZe/C9WLeYqvKL8cQiC64Cv+6qAqzyKzoJ55cDODML0ZuqjttcaE7GK1Ii93O39ApPAHV0HL67HHPyf3+fxkMEYGPGdxM250J9x/0M/yHHuuZKOlWasivJCU+hB6pCIw3VNIQPz4Ds0z2eyRFHur3BxKSXOOKh+4BkExWk5SjQ0yUFWwPuzvaV7lLCdXBqf77F+tL/z5iUfrx8AR6njswUu82uG0LtzLZhXbSjicwCWP8o8vnwIRDW3cNT8fWsesDMnPopHCGjvj/QhC6zDikLQiwAF8ODE/xpYGwXD1BNDVur/5iRF3U6p3UBaQxlKRwaPSYfA6HcoKlapXz3rgW44qL7N0QTRLjxqzz3FghHZ/qMnP8txUk4qEeAMcNAfFaBDu9TkJ7FOOanfVh4wLEJDC1xyDBV1gJbklNuAdMsiIvw8OsNhq5c2SROat1H/+pcXoYw5V8XXSrHK0iN9mzJXQYrvQDcMkNpmtN2+SgYdmM6BHYa88CwZOViRy4MPFTYN8nI3lQyrsgVVaoApzjxw4maZ1unAiX0gpMC2guwNoX7ZQaIjCU8xJgzLcwyqdlQTtEgfm4iqqaBr0zihAxm1A+Y192K4Jie++QgegY23nGwOokCk3uMYwj5ps7cu+aiNBUyuPY
 ak+RNmTS
 sZZKcEp6QvSbtNJgSlOnP2AEfJ2IQr8YqqFMPuYlrIu/F+iGyo9NEvEzWeJ552TxswzWn00ihkW6ELuWiB4Appm82i9rx5CGKe5cI8I/SxShvvkXzpH9/1TavgxZXuDefMRmAE9YABnTXMcBDfKmKwExwhgxyQ4+uuTDlJ587BqgakSJ5c/F36QGjmyR50JJ+B0lPx9J8o3pHpSP7oQiGsqMLHzywP5FvRXSPFv8AIKHGd21XCXSIcgyq3yd8Iy5ssPAdNyEAZ/39QCm1adUXNtoYcnMXqQxA/xJw0TCuJFfZzq2xNJewfnIfAPJn1t9BAlGeDp4bAS2aeoODWNr3j94c03U8ubkcI6dcQe3adFT+XRusRIKavJuqA01IywN0LWF/fAVwrLOT+E5Nn+rYTct9UI5LaurMgkz2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

No changes, rebased on mm-new, Cc fixed.

Follow-up to Park Tae-sun's patch [1], which was dropped. David asked
which of the cases it raised can actually be triggered, and for selftests
that show them. Two can.

Patch 1 makes a zero length mlock()/munlock() a no-op before the address
is rounded. Today mlock(addr + 5, 0) locks a page and munlock(addr + 5, 0)
unlocks one.

Patch 2 rejects ranges where start + len overflows, or where the end
overflows when rounded to a page. Today these get a silent success, act
on a single page, or get -ENOMEM/-EINVAL depending on CAP_IPC_LOCK.

Patch 3 adds both cases to mlock2-tests.

I could not find the commit that introduced either behaviour in the git
history. Both are already present in the earliest history I could find,
so they may predate the imported git history. There is therefore no
commit to use for a Fixes tag. I have not added Cc: stable since these
changes intentionally alter UAPI-visible behaviour.

The mlock-random-test failure CI reported on [1] came from that patch,
not the test: it assigned 0 to do_mlock()'s error, which has to stay
-ENOMEM for the over-limit case, so mlock() over RLIMIT_MEMLOCK without
CAP_IPC_LOCK returned 0 without locking anything. With [1] applied the
test fails 40 runs out of 40; with error set back to -ENOMEM after the
check_mlock_range() call it passes all 40, as it does with this series.

Tested on x86_64 (KASAN, lockdep) in QEMU: mlock2-tests 31/31 as root and
as nobody, 24/31 and 23/31 on mm-unstable; mlock-random-test and
on-fault-limit pass.

[1] https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/

Jose A. Perez de Azpillaga (3):
  mm/mlock: make a zero length request a no-op whatever the alignment
  mm/mlock: reject ranges that cannot be represented
  selftests/mm: test mlock() and munlock() range normalisation

 mm/mlock.c                                |  29 +++-
 tools/testing/selftests/mm/mlock2-tests.c | 191 +++++++++++++++++++++-
 2 files changed, 215 insertions(+), 5 deletions(-)


base-commit: afb4eea28037fa55c4560313ecbd8a1e1da8369a
-- 
2.56.0


