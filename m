Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D69CCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7945A6B00D3; Thu, 21 Aug 2025 06:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745F66B00D4; Thu, 21 Aug 2025 06:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D8C6B00D5; Thu, 21 Aug 2025 06:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC416B00D3
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:22:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DFEC16037D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:20 +0000 (UTC)
X-FDA: 83800374840.21.977E0A9
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64B9FC000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=BMWp8pD7;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf10.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755771738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqG59QcNd5zcgM/48bgbCRG/bObN6shwfOiwsu1X8jM=;
	b=V5JJmlOdmH75tFTFmz5CdEeDEDG+PCC8y4rmILGlzzNj1asBcXZUEY5VkUXcX6wJkrrVjd
	J3nbBHTCwKNQTgJZEEIrOhreaKVwNjrh8NdSyBroxXoWrSe2CvvDzMcr/lhJxkZnw7OEfL
	UvqN/ZtHcicYrYynUOsxqT8If5W2Hog=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=BMWp8pD7;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf10.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755771738; a=rsa-sha256;
	cv=none;
	b=V4ERS6vv2saL19yJUbV2mBXvSV+/s16t/iPu1vs3Bk4mO1iPTHnZC/SkwGteHZ3vIZwbxk
	/8LIfF1tR1/HzXXWY7Lvpcv6YtokCvQAKCfeSB+kEzcSYe5bnDYEnXCAG9i8YdL5ufQaRO
	SXw9iuii000JIQDNIGNh4DdcdQXGgXg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SqG59QcNd5zcgM/48bgbCRG/bObN6shwfOiwsu1X8jM=; b=BMWp8pD7b9GiEYM/tFJo1TnmAV
	Vc9hHbhfmKolOyJCKbBRqSIC4CjK59oqtpEVzZ4TBBJ+lNf628BnUHtepubkcq1W7FdVmQaqxOrOo
	PDKmL9ueul+Azb2iulfgVVYyI0CboZGmrTszyAHcAKXbqXbFT50OhNwmgj4GcgQHDN6uweDRRdyLw
	z22GvTK7IQ09Rxx/TLpaVz4ESQDBCwAD5X+iWk2IG2oachNyc4j5/Pci41Yuv9C+QqHjhJJskWOdT
	iqGC5p78QFQI7QoaWRX8QAUCbNSpR4TOKMkOFqmNW/+oTxc/f8Y6YiCGeDzSW5LZChJhAvWpkLhjB
	wmokEYVQ==;
Received: from [223.233.68.152] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1up2Qv-00HBmV-UT; Thu, 21 Aug 2025 12:22:14 +0200
From: Bhupesh <bhupesh@igalia.com>
To: akpm@linux-foundation.org
Cc: bhupesh@igalia.com,
	kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	oliver.sang@intel.com,
	lkp@intel.com,
	laoar.shao@gmail.com,
	pmladek@suse.com,
	rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com,
	arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com,
	andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl,
	peterz@infradead.org,
	willy@infradead.org,
	david@redhat.com,
	viro@zeniv.linux.org.uk,
	keescook@chromium.org,
	ebiederm@xmission.com,
	brauner@kernel.org,
	jack@suse.cz,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	linux-trace-kernel@vger.kernel.org,
	kees@kernel.org,
	torvalds@linux-foundation.org
Subject: [PATCH v8 2/5] include: Set tsk->comm length to 64 bytes
Date: Thu, 21 Aug 2025 15:51:49 +0530
Message-Id: <20250821102152.323367-3-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20250821102152.323367-1-bhupesh@igalia.com>
References: <20250821102152.323367-1-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64B9FC000A
X-Stat-Signature: ddkf3sktt5nhjrb3tub6k1duohek9mpo
X-Rspam-User: 
X-HE-Tag: 1755771738-339688
X-HE-Meta: U2FsdGVkX18xwQIRZWJriOUdFCwVqeIDXaio8vLs2CsIkgD7MAb2qIYbmJifFv5V+oQNJhbCTAI0viU9EnljDYOPrN/sHPHlCMl1lpREJNCW64lYKD560mA+vRgKfo5obX2rL8xSWMOgk3pwfx5tCtA5X+EafCaOKMBpJWu/KvLmxT+aR9kKHvIOvBa1RtuHlN01Yd0fpxmzyIgXbK04sx9pJiLgH7S9T2znkrzazTmCDQkpkzRz6e2fhAV9mDNJt3h2xZv7UD+FKQd581oBrgyrp3MsF8EtPlG8ycMBXSoM/c8JVTY3WlYhqHqV0WmUMdI38B0bBL1EWhs2MKZAkbRHss4KxlRPYYaadco/0JBeEzTdKGw98M69tmAdF88g2aF0wpbVRqLM448N+Ow8SyxpOAdnL8J/OVA3OWm3hGhY8GOBoQm+Cf5ptH8Mf7CYxk3uJ6YM5yKfph81LH0iwwJK9mt1Wf7OwKt2Wk1Nv6gdmQoURJWm+Ss7C7IV/DooHMeiaF/YjN5IYv0FU8G7VYbcYbXX4Z1ZJZKSGzhH3PVM4fimb5Gd65OwGw9R656nwV85Hx/wNT+C6rSdD/97WJsZZC3i0d+FR+FiZJQzDJbgR6nGLo+SDNmJr7NsrK3ua0c07DbBxUK1LY3iVIt8h7nE6bSH2tEpUOcqcW+uKBiwjB4IV+f3DT6EQ6u6kv3dtBR5YIntCuZrVRG1EExb/nrfOWgQtH6q5OJEZuG5FAbu+ExiRxLXeCxq9lfZRn4lXW7x3IWwphAXp+k3zItnI6UIFBkocV7ae/GP2P3GyomNZuvrug2JPZP4DkdJH2pzex6zGK+lhP0S+Rj0ZQAtX5dlOd+Nmtt2o103Zm0xfCw3cBEV8dPL0xen7n/wduKbYR0BrteaSLbLzkmZcsxnG8VcgQKfacJuBnXaS4cHyyXhEY7RFEla/2kJOaxPsYWSFZa1BV8yjBwR85XF0Np
 1LpcBmX+
 B9eh8Sci9RknXRkNVG5JKfUhM/WvA2Y/FbxT75k205KJ1ujZPqldzWDhnUBFVehaQxp4OzK8ry2bOaxIgbkbTp+T9UCyzJaPgtBxa2bC5FpOl2hBLcqTI7MyL2GaO5EANOIlh21XI8UVfNaeYRnhSQPoc3bEmf8cGQ0u/5e8rsNsinouEkaBNGUEozl+hjT6orP6lJxlbPTlt4UsZQ61tM0SAsvrvXBufbIsZ2qTqmnZk6azKFbsMbOp+1FRR8/HGpA0vgYIdgPGZe6ltCXpP/6IuvKcXpWLzCwGnfPyUnuCrQb5GYPdYb1m8dAj15SExMGg11Q2Y1F0ZYA0h0r+6gXhTFSQD4lRkajdWdQ8Rj5+FnNzcm1JCmXHjFo2IcR90yvvV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically due to the 16-byte length of TASK_COMM_LEN, the
users of 'tsk->comm' are restricted to use a fixed-size target
buffer also of TASK_COMM_LEN for 'memcpy()' like use-cases.

To fix the same, we now use a 64-byte TASK_COMM_EXT_LEN and
set the comm element inside 'task_struct' to the same length:
       struct task_struct {
	       .....
               char    comm[TASK_COMM_EXT_LEN];
	       .....
       };

       where TASK_COMM_EXT_LEN is 64-bytes.

Note, that the existing users have not been modified to migrate to
'TASK_COMM_EXT_LEN', in case they have hard-coded expectations of
dealing with only a 'TASK_COMM_LEN' long 'tsk->comm'.

Signed-off-by: Bhupesh <bhupesh@igalia.com>
---
 include/linux/sched.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 24216259cda4..bcebc5622e07 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -318,6 +318,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1162,7 +1163,7 @@ struct task_struct {
 	 *   - logic inside set_task_comm() will ensure it is always NUL-terminated and
 	 *     zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
@@ -1961,7 +1962,7 @@ extern void kick_process(struct task_struct *tsk);
 
 extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
 #define set_task_comm(tsk, from) ({			\
-	BUILD_BUG_ON(sizeof(from) != TASK_COMM_LEN);	\
+	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
 	__set_task_comm(tsk, from, false);		\
 })
 
-- 
2.38.1


