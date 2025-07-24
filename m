Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C84FC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 12:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47638E007B; Thu, 24 Jul 2025 08:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DEE8E0074; Thu, 24 Jul 2025 08:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960D88E007B; Thu, 24 Jul 2025 08:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 850CC8E0074
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:36:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EEAF1A0341
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:36:53 +0000 (UTC)
X-FDA: 83699107506.17.EE1C278
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id A5522C0002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:36:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YmObt6aa;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf10.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753360611; a=rsa-sha256;
	cv=none;
	b=h46hEn8ENMwSVXUS9p/Y4jRTqe9fM87X3akd4pmexuanIrgf1FBUCMThISby4Qv6KHDblk
	SVY/75C9thG++l7LEPcnhBXmumsB+9tW3fRSnqp4T81dhePpH2Yayi07sSVo9pCOlJJMIH
	rDLRoo1WEGWd8ki3ndo0L7w1vy2TFeI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YmObt6aa;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf10.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753360611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ay/n4segqzBtdJcxqD3V5D84mQe9aCStMnYXrz6ny88=;
	b=U1aZ9gO81msXvDXuAaQF4ElgLxawUj+Xqf6eIKwUnfGmoFN3rQhtZS2c5rBI3WFQ0snCXD
	Vwxbl1cMqi9co/XJgl354zQVOW8Zv3iUuOter9lNEw4rKgP60HbYObmebrsuLXyKGqKDFf
	z5o+twebT9r31tKR3qw5p7En6f9nAIo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ay/n4segqzBtdJcxqD3V5D84mQe9aCStMnYXrz6ny88=; b=YmObt6aaSGJMlOElGiwShkA2s/
	x+rR+nIVtETN4fxSYbthlIKDkyjCfgR7qOqA2UrOGd6LqO9gw+PYxxgZeFBICgr7qUdtBFjLfFM7W
	Nv6FYxDlDTRkKpz7GL0fSTbio5vcycsCc4PJA8PCHRR1bHBai76XHK/b43JKemwkCIWlhbbfMAkTb
	gqSIPF5a/3ltQT2Oof/c5JVFCWpFY3GVTi9kubC7jULyNgI/FYDBiLBzkTqvdzXSqfrewsSh5ATab
	kwkzlCsK1mZ1XhkC/u2qTga8BFUrn9aoaENc/c1pPMTM8oBR6w0dtJKqrpK08kecCVUjhPzt7lpqE
	YouuGFPg==;
Received: from [223.233.78.24] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1uevBm-003BPU-Nn; Thu, 24 Jul 2025 14:36:47 +0200
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
Subject: [PATCH v6 3/3] include: Set tsk->comm length to 64 bytes
Date: Thu, 24 Jul 2025 18:06:12 +0530
Message-Id: <20250724123612.206110-4-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20250724123612.206110-1-bhupesh@igalia.com>
References: <20250724123612.206110-1-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5522C0002
X-Stat-Signature: iit8g5hrg5chk8y54crppqyuzxtnq79d
X-Rspam-User: 
X-HE-Tag: 1753360611-688573
X-HE-Meta: U2FsdGVkX1+N2+iWMLg3uyFmtcO0JC8Et/hWH/g4uIrn9Liji+5oX0LZLLu9EUFe3fCD791dmEk+0e6MKP5dUyjiAzk3fkIJII0GN38U0N9T2Y765KZrmVV2T0zAY/nqQlQuFBnoR9VykEx1FCnUEOPi9N6J/p//sbc0birbsg/SdS8zBpU8qofPg1lO+VbvIrkLYZVGnH9MpC69eIEBlUpKT9G57g8QX6wAqV85eFeT0zaIhNoCK4mXh/J8m9k+W4TL77YTOwGzgmnUaqiiWoklhCbdJYbpIyenOf739f5rOxIb25c+TXtD29ckamspfOVXJ2x9ohXykLoX2jOyMaakQSL6EXqbRkLgX6bqau0k9GRWaw9Qwlv2JQFrwveVBVnYeaCawgo6R4cOPn/Tz0L/9Exidl2n+axYZUEcV8Ns0tk1mKra4yKA1sT3ld/ZsoOTj8HRaLmWZeS1XxGl8/6aKTN65CfQn2BrAKzFhXDF+9xTq7JbFAaX/UIWlsap+hKXcjVA+9HOtm6oIUldDirrFBqfGryTXaayL2iEgCU9LSvEspvnu2pnLdnSNNa7qa13u+qYvJz6wTXFk/K1nNOG3x/BHCk9ZhwBB/dEArXV9L3Dt6xx6lQIgzfETMljlblKtw0X/6mAfHIlTgOme+rZTvg4bRgy5EAx3xCzrk1ptM7D2mA32+0W5NOpgJB7VWzLM1q5aIyIAfRvQ9kP6gb5rKqZDMTAo2JWH7uQyXmukYk/bwuDPLKiKdJcmyf2AiZwyisA4lR34zOfj7NZbQlwo7sa8EC71TNOfz5DvaSIsi4AuPn+2ltUndAU03WZZ0ZTQIY6x2SfYRoJkGF4DDWt9lQJc9Z04PxaxCI/snu5sWsq93Imdv0M7IIUPA4rzcL1f4YD3HTy//sx7TQ0+4EM8+7yh5xLDgldfig+hG6aihGuxdmVlieSHlTakor2uSEEPc9nedQqWrPEKQn
 iaVTEGc6
 CU+Is9c8R21b2MIOqxB+xe9PymV9pF6IzZl+v8ZGewIDAKoZkdaVf1zFzfgW9N4+ArsPJHXix/73T4OZcejf3LcoyROr+IRu5hYAfl2T4TDXjKfagnvjPWE5CzGv0pQgc5k0aG7oIdAai/yiQnVN/HOyPCzyOIQTGAhjuGTbxbQ5AXVWjjJ0ydnj/POv6V8VT78munErcbvAqK/b3RYiGR3dwdjOwzctr6CejKltlYK4TKIDd/KjPxVlJD6SVeDz/0pnJiP8xvh7poBxtFwfm49xwEgam0p7JPCiyQutZcgmqnOBmsToE3dieNr6f8C2H+mQWZzX+gDNwx+F8yHMx91Gh5jbDdHYjB5s4S++9pbhuZxqo3SDHOiSPC4XlKpVp4Onb
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

Now, in order to maintain existing ABI, we ensure that:

- Existing users of 'get_task_comm'/ 'set_task_comm' will get 'tsk->comm'
  truncated to a maximum of 'TASK_COMM_LEN' (16-bytes) to maintain ABI,
- New / Modified users of 'get_task_comm'/ 'set_task_comm' will get
 'tsk->comm' supported up to the maximum of 'TASK_COMM_EXT_LEN' (64-bytes).

Note, that the existing users have not been modified to migrate to
'TASK_COMM_EXT_LEN', in case they have hard-coded expectations of
dealing with only a 'TASK_COMM_LEN' long 'tsk->comm'.

Signed-off-by: Bhupesh <bhupesh@igalia.com>
---
 include/linux/sched.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8bbd03f1b978..b6abb759292c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -317,6 +317,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1159,7 +1160,7 @@ struct task_struct {
 	 *   - logic inside set_task_comm() will ensure it is always NUL-terminated and
 	 *     zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
@@ -1954,7 +1955,7 @@ extern void kick_process(struct task_struct *tsk);
 
 extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
 #define set_task_comm(tsk, from) ({			\
-	BUILD_BUG_ON(sizeof(from) != TASK_COMM_LEN);	\
+	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
 	__set_task_comm(tsk, from, false);		\
 })
 
@@ -1974,6 +1975,10 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 #define get_task_comm(buf, tsk) ({			\
 	BUILD_BUG_ON(sizeof(buf) < TASK_COMM_LEN);	\
 	strscpy_pad(buf, (tsk)->comm);			\
+	if ((sizeof(buf)) == TASK_COMM_LEN)		\
+		buf[TASK_COMM_LEN - 1] = '\0';		\
+	else						\
+		buf[TASK_COMM_EXT_LEN - 1] = '\0';	\
 	buf;						\
 })
 
-- 
2.38.1


