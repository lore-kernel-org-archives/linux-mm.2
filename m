Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CDF606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qBXXpIpR
Received: by kanga.kvack.org (Postfix)
	id 7DFF76B05B0; Mon, 23 Nov 2026 00:16:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791376B05B1; Mon, 23 Nov 2026 00:16:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A67B6B05B2; Mon, 23 Nov 2026 00:16:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 474B36B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:16:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6142DA081A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:16:48 +0000 (UTC)
X-FDA: 85465224096.05.7B47765
Received: from mta1.migadu.com (out-11.mta1.migadu.com [95.215.58.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 43DF81C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:16:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qBXXpIpR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.11 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795411006;
	b=FIcLEX0G0twUhjqeSDsGZBqIb/uHCrh2c6nGbwHTqqT9W2iO5vUsC0sPOXBovfz51jeRFB
	u0t8TNBBEi8S3UxyUNHKCvHnuCjdofq9QVClMwlg+BujBgnYaO6Jhtl94TSGXAFolEq1Hk
	T3jpXKQHZnHemnU0nRcb9L1e9pbSU7c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795411006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ATtbdInCTfCLTMOr7GSbNivMP7bT/TsUu68gzYudVls=;
	b=fegEG/2jQsSzOIyLc5iEu6WCWw5va0vOlXevfcPbUS7vDj5RwQijXgeslXqYwuoMbKxdOx
	1ADj967vbU8UeGj0pdHhPoTUgtCXvi8G7eNL0s2dUKTnpkOuZVHKuPZmHWJZrIO47o+EtP
	z5OsDqSETV1bMSrAVY6DKOd5r2vNkc0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qBXXpIpR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.11 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4ZVQu84GIhvyCFBAaRbAzEUdagqqwSKzjRDGIZcVneQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795411004; v=1; x=1796015804;
 b=qBXXpIpRoEH0/5sLMDtF5f1T8vbxYlouvNobBVVxs9O0EtUr1qJIcw9jy0sQKCVEpsxPy1iQ
 thpP6wBcy0C/nPUTU75XaV465u8YME6O4VffO4elBkxbQGND2kAS39fblMfwib45emdsDLQIehQ
 ln4ZAzZk2gouGCM6v9+xnrxU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b4f2a7d411dd012f;
	Mon, 23 Nov 2026 05:16:44 +0000
X-Mizu-Trace-ID: b4f2a7d411dd012f
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: hughd@google.com,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com,
	andrealmeid@igalia.com,
	krisman@suse.de,
	linux-fsdevel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 0/2] tmpfs: fix casefold flag inheritance and document mount constraints
Date: Mon, 23 Nov 2026 13:16:27 +0800
Message-ID: <20261123051629.2547645-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43DF81C0006
X-Stat-Signature: k89n5zf1afuj8xi9h58j7ysneunqr454
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795411006-759558
X-HE-Meta: U2FsdGVkX1/oI6HYS0r8YEaJKrp/NEY3773IoGoKDo8Du0ubwW2LQ+qjnMEzwMLJW7GjTvWSKunkF3OhmiDD4Y37h1cjIi0TA5as5l9N7wOM4i3YlYrDtDL/FrvcKgrLOjFNJA2ilZRD7crpH0MnxTiegDPe1Ruv/cuwef58tOq56fgMuBpItwQDmmCYmU+mgGzKQvO+MG0p9unZZ28rf2Pb9rzm9345rzAj1Pv6J/OUt8SBjnfYWH1MhwAFg+wRNaH8s7+BDauQEZYmAw42UvW/yt/eEFZq6NOkNiS7OmDFLjpcWhWOzT9BQ1YzRjdTPWwEGC5j2WUNgQ/JOzhOHtXaj7F83CmCDdVB7RuwORZcuCkW62gpEWcjNdn4mOG/4fVqE00fCXVzFIt+TPb2Wg8ZPtL1prUoKVGAB3mpQd3sy8ijn3WzgP7wedhQC0xkepKYskot7i7c4qB1gWvK39q4QbX/YSrZDCv4uCWNIQDYHs+K6s4w2cGRYBQZLih9T7y0X/D+ebHsyiCOvVbKuKZCi1nUobowLCwN3RMsP02qOJtEEoIdm83t0/g2oBr7KtbG3t/bZD4JmFNUKMPc0im8YuFkCsKTSqvZSFYSJCkARP5nBwS0BXUrEKJNV1hSZ5qSKPbyjbIObb/nI1JIup50u19evNCW2ADA+i3WopLSr8uI/DCJFcm9JwYCyWqKeMQgZwvRRBhwyxbHaq5wbIQYLglTPFzx/yVsoRrrsxhRmkGb4D588TL11/4xwqidqNFT13FedZ/SVx5ZOu40HUEiQkq0JYJDRKGFBhg9+hUjon7B5aHaidJFpoJ4HKZMgQV19rpbWsHxrIwNr/htkctOeEa+6fW8iHdx9a1WB2mMnu/HDluYbRJWs0zTTVobkaOtq2mDyqDEJoqika1n43vO+2toL2CoJT2Or9zMOqLHESPnXabCFtxPNtMh7LylfeTrWudHGYpxWnHW9dR
 bpZAVEjP
 bVDZ17jietygIkWtfczbk6VkaZuXly2+byXCRhFZKbEpyhTc9xRFmc1u8YJkqKmoY7YTxYJ2xWNzTKIqQMHzc8Dd0Rf+b5AWcsbx+1Y5KFMEoGNKxZ4n7EqrpO6OF4jDJoTf/PExnJB/zKz0M3N0gjfIujs9TVG+SlqS0CDRcvHKDG5u7V3t7T2kjmHVAnp6gjm6dU5uUXgMjC+uBnBU+sjc22zCFWQg0dMXZ8sjafEYcNOA9ZrCptwzbLaepaQepVIRQ9ytoap+03mfjlgRSDkSls9HIEiV5tGBnzlRGuLcdKzLtvRbg0TXBKYphafBa5cyQSg+CceY/RhB4YjYst8hEXUH3ufXGFlJApRRflcDTCVzGPB/KabSxf6L0WxThki1AG5eo2InjeELzMbw5pXjjkkj4w+02Cu8tlQQPEZ2/F4QLcUjqaZjgLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

Files created in a casefold tmpfs directory inherit the
directory-only FS_CASEFOLD_FL flag, which shmem_set_inode_flags()
then rejects with -ENOTDIR on non-directories: the inode records a
phantom F flag, so the value FS_IOC_GETFLAGS reports can never be
written back and attribute changes via chattr fail, dropping
NOATIME/NODUMP from the same request.  The casefold mount option
constraints that commit 5cd9aecbc72c ("tmpfs: Add flag
FS_CASEFOLD_FL support for tmpfs dirs") landed with are also
undocumented.

  - P1: mask FS_CASEFOLD_FL for non-directory inodes the way
    ext4_mask_flags()/f2fs_mask_flags() do.
  - P2: document the CONFIG_UNICODE prerequisite, the
    strict_encoding pairing and that both options are ignored on
    remount.

Testing: on a VM with CONFIG_UNICODE=y, before the patch a file
created in a +F directory advertises the F flag via
FS_IOC_GETFLAGS and chattr +i on it fails with ENOTDIR; after,
the flag is not recorded and chattr works as usual.


