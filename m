Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2200510AB832
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8F86B00B1; Thu, 26 Mar 2026 19:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1806B00B2; Thu, 26 Mar 2026 19:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD7D6B00B3; Thu, 26 Mar 2026 19:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB516B00B1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:37:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06497140DE6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:02 +0000 (UTC)
X-FDA: 84589827084.11.32D1B3B
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4142AA000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K6fr4+03;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3GsPFaQsKCA0npxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3GsPFaQsKCA0npxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFvOjUtymmKlW6mv6haGIZI39TLsFlaNWWSpopNMudM=;
	b=QkXtJV9dDqvM3zEECnmjthvQphApXMFGH+SwHj+xf2A4t33VMImabA/EgDLeNoegd9dE3B
	231wHoplPZXMzjDLbnCawsCLAbL4/cXkz0o/zj4+VEJ5yIx5xePO74OTsDCAyyGrP4z6kg
	4pomK3cN4Cf5uxXk9vnZ9qZgHRT2Dcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568220; a=rsa-sha256;
	cv=none;
	b=cM/LNmo/n1mVM1jTBYPDKte1vm/FqCWBYbobbrvg7NJlxbjTuQQ5tsmNOCT0clSrIyemyk
	JjYWb2A2sb42Hn8UzB80wEa15pE8zYQTmpuS6LvlrpOfMX1MxfMKz8tK0LtpnqI3i0t3im
	W5ajDV3giJzx5TdJc5+yMvxhOhaH/xI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K6fr4+03;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3GsPFaQsKCA0npxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3GsPFaQsKCA0npxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35c2dc274bdso363400a91.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774568219; x=1775173019; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HFvOjUtymmKlW6mv6haGIZI39TLsFlaNWWSpopNMudM=;
        b=K6fr4+03kEVoC7I3YQpcomBWnsB5jSwW/j9uPcRfgFpGM6+uZJNcyAt3ilxNmBgjm/
         /bcu16cPpcOqdBgS5asbB4LHy1RmBW3VgFKg68ch4CGmbngG16ePP9NmEynoCQK5aquK
         aRiauscRUzNUh02aNz9bgbkIebtu5PPYD6sQvm/qFXJCxNsc4u4kkhhu4ncXudAVrp8S
         q2IvnRU7Qj54IPNEykd6LkoEv/bfBQajTu0KrPMehfFS3rSo/ViwOlz6FPuKn59gSq1e
         jWllx5iUjcH6HiVG1mrT4QrLzgRlpNUKzi6i6Bnf1Y0bllj09VQqoL2F1ZJA6EfljSb3
         COqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568219; x=1775173019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HFvOjUtymmKlW6mv6haGIZI39TLsFlaNWWSpopNMudM=;
        b=CLsYuM4OKdmn2W7PaltWAIOtXcNFGABmAW7irHhiErwQfc1boR8cHkXE5IR0xNpStU
         zFGjFKQESFxHHNpQwz8q6QGEfX/X8XKy6JTzQgBHWUnUBdoXYwNCDyVqPX+rprlRFNln
         PLCj2XTeGOgcLl8Rf74/XAxr6nDFn13NXvVqu0JUsIMVNAAZ0UfRVqg44Rg5URtBzrSt
         9tpFD8ppM2hlHgC7o3glNoIDb+czXKdVwt+h2C4jZucNXy2sqWLuvStAwwP9omwUVc3e
         kWmyvqCa+5aMtqqhlg6r+Lzm63cU4gJB7NSYmapkjyVhVd6C+yVvs6SX+b6F+1fAwaDP
         Ty/w==
X-Forwarded-Encrypted: i=1; AJvYcCWwiPp3m1cP8LlxDMPdIFHVrz1M08+9YbxpJVlSTo4eC2BFJ+8iDEmakvmpDhUvspoWRvr+nMFLBw==@kvack.org
X-Gm-Message-State: AOJu0YxKY39w/cU6qbZV6bmVlOZ5GK0KMADjr7BPLHPoy/6Fx9epg8Oe
	BQkszYsH1HfgPKgGHc9MTQyvAZgxo91iZSGJTwRyn0+NQA+4/akyPzVhW16YBMFTHFR9mXLXccO
	W0ggwuF4TbsAhQaq57XMMy5ELsQ==
X-Received: from pjbcp9.prod.google.com ([2002:a17:90a:fb89:b0:35c:1a37:ace])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e8e:b0:35c:d98:d682 with SMTP id 98e67ed59e1d1-35c2ff8b101mr403470a91.9.1774568218647;
 Thu, 26 Mar 2026 16:36:58 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:36:38 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <cover.1774568083.git.ackerleytng@google.com>
Subject: [POC PATCH 0/6] guest_memfd in-place conversion selftests for SNP
From: Ackerley Tng <ackerleytng@google.com>
To: ackerleytng@google.com
Cc: aik@amd.com, akpm@linux-foundation.org, andrew.jones@linux.dev, 
	aneesh.kumar@kernel.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, chrisl@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, forkloop@google.com, 
	hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, jmattson@google.com, 
	jroedel@suse.de, jthoughton@google.com, kasong@tencent.com, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org, 
	seanjc@google.com, shikemeng@huaweicloud.com, shivankg@amd.com, 
	shuah@kernel.org, skhan@linuxfoundation.org, steven.price@arm.com, 
	suzuki.poulose@arm.com, tabba@google.com, tglx@kernel.org, 
	vannapurve@google.com, vbabka@kernel.org, weixugc@google.com, 
	willy@infradead.org, wyihan@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4142AA000F
X-Stat-Signature: sjk5k4ko4p7838qdttmhyzea7aab7ico
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774568220-759961
X-HE-Meta: U2FsdGVkX18VasHEfZTWYUBZomD+1kb7ni3y8UpD1465JQ0D3YhyfMw8Hkp/1oaR3nuNKTyelPqHkBsN50wSwpSZEWt/FM8o7iWF3KB81PrCf7bPEArvS/J7ObOZ+gK1NwTYPPmWFi57gFVYWysQZmfOcRV6HPy/Ry1pk1+K79FJwI0VovF5kW3GNWCePpSxhWvtpPRDycSTHt+V9EZkR5LvAslQibjbHm341Ly6RyEJkU+4/kiUqAJQ2pCyg7mwFRx5WrRwdKVj0rt2bEHAoXu29XHwYU/9AZwfM7x81CWLqf0rfRb6zWjSoGC6EKdoTLuMllyxyg7fX67pShjUYu9axUrxNxpm5eGJdgfn+D2KKUJYvcbyUL6FWUgw6/rjDg+LugXs/f5aAkpm9sK0HRjWOavIOUTJvM1xf4S2A0dt1EIKBnTEmE1GCcR4FEFCovpcp0wwiJtCglmtQoeJcwfuIn9QGvoVq90uQHtASsRh+JTsIvLTDToc6uNtXxLqUXsMEqC1K6RgRREk3u+Kl0fFnlyP3h5708s9UL0gHdP267Ip39BprfLmINQUNp7HNo7Ctwh2/6phJx+M0jpBYULmTx3jCD9cNDxT4a0Kz9HAfIbW/jhSj+c/+loeyt6mKeof88wMemKmXJrlX11snjkneYevI5qlUMlqDVGV9vGpiZNwfWRrh/pnAFz58iPkRXoHkmps9kfvJFDXJtrmQ3pthwyvlkGwCr2vDI3eTwcJKsS0R43ybjuYvNBP6b/2PQIIzgsB1IsXgH6qrfaDATpbFFCZ13sxFiqOftXNMWdMmnpSilqMaG8QRFouYcy2sFYlAoscQ2q1pCKREM4VSdxQ3xEaz7dUpuoYW5+AnMnPLbmjIGpJVRJgZs6eynJ/Nfze7RJmXlUNudfpl5C7SnHaSx/4cLz9OTktBos7IAZGicunUC9tJ5JFuPWT34qlEhaBBViPQiYEqtqN175
 fz1JV7Z4
 buoRajxk+T7SLpFF7ZC7x5/AFCybvG8AoJWHgPYFDF4/QRUGtipnTjKevuEugkhzYSptzpOFRowxm7b58LGjnjUkHkj4THgCKUJGW9RKIRCeelPQ14Iylfe6tAc5nDtdHA3F/i+noyoOZbNaBGC4g1Y2iab+ZB3+QgcCb5ZvNkF8w/PomQ5i0BjqVzdLcU2+VLRy4iYquHgAnlTahRaqRn/AhrFMQc4TX7wJhvEb88+ik7nbnQxBh1Q/tz2z1gj3Qq2qlG48m/WPpGPkH9QfxykuXuWwnDCmWQfo7pJrgaBzcdADIqMdSpXN+vmaRRHTa/O7o+9cMwIBSKFVTVJRVfIvO1Hngpgc3UhKicG8f05tpC8XpuRW9+coj7ftCRbilGcdE27HbYrctSo0MzoztMpc9Orw2/SB3SPE7zLoW+DsVUdONo8Mujxl0yH2cD3A/yI2Q8VTKagv8WCagBoe654+gdceXNiEt5L5DbpYkcKW2q23FJamBuO6E+UqXBBUnpkoiP2Uq6x0i2+WErlYBwDXKea9UabHhFPRIDtPANlAQdOn2B1Js2pkxbijBgQLqZmiYLNncmAABwslP1EI0hL/58yOxH2H6apa3MxWQZaBrszisGdGAUTLvIPeR50vNPi+Zk+PGbSJlFyC4siPtnrRc0GUkJ8LBfkEcjXfsd6snjYZVWn/QuCT5cd/A9DqiLoGyt9MHzX0TSTf62Qs/3wAJ5Wb6I5QIqKqF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With these POC patches, I was able to test the set memory
attributes/conversion ioctls with SNP. The content policies work :)

Ackerley Tng (6):
  KVM: selftests: Initialize guest_memfd with INIT_SHARED
  KVM: selftests: Call snp_launch_update_data() providing copy of memory
  KVM: selftests: Make guest_code_xsave more friendly
  KVM: selftests: Allow specifying CoCo-privateness while mapping a page
  KVM: selftests: Test conversions for SNP
  KVM: selftests: Test content modes ZERO and PRESERVE for SNP

 .../selftests/kvm/include/x86/processor.h     |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  13 +-
 tools/testing/selftests/kvm/lib/x86/sev.c     |  35 ++-
 .../selftests/kvm/x86/sev_smoke_test.c        | 255 +++++++++++++++++-
 5 files changed, 295 insertions(+), 22 deletions(-)

--
2.53.0.1018.g2bb0e51243-goog

