Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE47C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 06:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970B16B0108; Mon, 11 Aug 2025 02:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8839B6B0109; Mon, 11 Aug 2025 02:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799466B010A; Mon, 11 Aug 2025 02:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 685E96B0108
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:46:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D1C7819E7
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:46:44 +0000 (UTC)
X-FDA: 83763543528.28.912CC43
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 86475180006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:46:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ptqdBLk0;
	spf=pass (imf24.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754894802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkOlSlHnGVT1KRBhwKqmf727gWs6TB6cX2vkRjDeLAc=;
	b=t+5aT8Mjw3YicUchb7M2P+XUgOSpNKOlhqhwrDcqlj8l4gOL/Clwcuoz7a22h7AjbaRS9E
	lU+Bxl7xYaCQw9Jh5BOybt4d1EelYuJnuvRyKZ3JJPUfQu0gYevge0Fn+E8InFKrPeBvD/
	LactUDSYuzP+A211tMaSz62gN/hFF1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754894802; a=rsa-sha256;
	cv=none;
	b=J2iRWv/yo2F6jGqnKu/jdY/RC1I27e615038E/eA2XOS+srpp5Y3GbmUuw4BiEZza1jT2T
	vsP/vvCD84V1lymb4TlIBhxgCgUQtYt9QtO6kSiZC+Yw2VKxYGFQRPcWFHb4fLcoFP/7h7
	JVi4TE2IzanDy3+zn7bPBRsfYAw7WlE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ptqdBLk0;
	spf=pass (imf24.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AkOlSlHnGVT1KRBhwKqmf727gWs6TB6cX2vkRjDeLAc=; b=ptqdBLk0JKXdgsD1MQ7pDWNbTJ
	Yx6u6119QunQo0/L3znvKKPWvfMTw2okCRnwrEiRIRokDj1xoz/hYlOpd6xAEXBuoefl8ebPAJWfM
	a8W4kh0bCi0vufydf+xHW33x3Q/dIONhTo01K5Mh3sDrHL18fF1d6WTvbZ/IWAENhbHLW7EY+r0Cg
	GhV4G6bw1PCYjifGJuvX/EesWsCX6t4y+2t9SWGNtas36iC45P42cXDjqAlINGwf/eDK2ygbczQdR
	aj3YnkYVkBcFXcsTFgwnJxeQCrFVIvvVxF2F6+Fa9hUOmoxA1WuzkDINqs1aLpAX/ewJv9rhHknHu
	FwX5swJQ==;
Received: from [223.233.69.163] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1ulMIn-00Cdun-Li; Mon, 11 Aug 2025 08:46:38 +0200
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
Subject: [PATCH v7 2/4] include: Set tsk->comm length to 64 bytes
Date: Mon, 11 Aug 2025 12:16:07 +0530
Message-Id: <20250811064609.918593-3-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20250811064609.918593-1-bhupesh@igalia.com>
References: <20250811064609.918593-1-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 86475180006
X-Stat-Signature: rps9ki33fkqqtmn8cpkda7dss1m6hbxw
X-Rspam-User: 
X-HE-Tag: 1754894802-988357
X-HE-Meta: U2FsdGVkX1+8c87K2A3dsed4GNyZkDNyRcQHmnlUdBGmu2O8RcNDG75BuMdNuqwCxexaExL+DGnWj6U8F3ngimxubDakt2mq3YXIYCjzGOR+EkqXrf7BMki6TblSUJJGfrVbRlIdIQgxiUUANrVmviOnrNf+6mEcffjboNhI4/WjoTpNy4Ff6YfqxDOA5Y8esk+FSf6Vgl7LMsxjyEuBqvaJ5T8+1/rjQH7cOeDtdmtsAFQf8C0p0vUUjuUuhEdP5lJ+G/XSzHYLPyJxvjE59u0MVcP/+GQFjIs+Vj4R3Ud5GgtZoSEMsfan8bDlOF/QBlC4cQgzA96OPdpHTAAe2ez0CmZAmL5r8fffRPWpqIj91zOfS1IgWWETX60/sRKfuba5O2lET2cfTuVo5aYjsqa+zKarRmlPJcs1qP4kvMYbhM8udvFCQe5fABRuGN7KHw1Fdnl0CqsF8ZvRpUU8+ZlTuaXCvndrCIzPQ41ToktTS9wuI/0HNsVu0pzP+YWMUTIPCvvo8P8PIw72MDZLihpAM+CpuAnx4mLPCQ3Dgf/cKqpgZN3JoASL6E8i+uAwgEZgZ+eqAdlMwndLC4CUO9LxU5CiOP3zoHqdukCJMt9jZFzChRxaouBIk8+fXT6WleuIyHphPx+15ymM2XUa95nUpj8y+N/vltudNjKlIPfLXvn7jsHyh1BKMRBZppHI6Y1kgKHVGO9Kgw9IyTMtEcm1rgFpiKkMElszXfbt++uLtYj6D8Fug1dSLnfAVwerDy0eCi/smgOpeAw5eRgyxqnQJEG2pujDes+c6xoTtA6X9xIek+UIgt4evBi5dpJTt+npN/jEQcVowivej+RScMw/oFTx7s9CZjU/lb5CUzUxBkxedK/79QN+UPML4Niv4nOeP9v2ZrbMiwNQ66ZAmF1QpvpEhvrOATV1LNKX3WVzsn0uwTKTdCbBZvIlPvUJykfH7RqkEItyPimJivI
 vbmYQK3g
 oL6VDBStUP5GQDOhd9XKckyRK8GzVVIZCWGf7rKlUM4rVTzw/nUi8PvTrntG1wjiCpoySerp137SyTcb2HUvE1xv47+1PCYlOKPAijwdEmydC/xp8Y7xVVRjXIhhcsdcal92UiqE/5f0SWWAzjAaNGLK0wVd1izr4VaEtWfwcTH1Ai43FrPTLC8b5bcd2zcr2x12jJvhtsMMIha6UYlcKW5dkV8YMcPIIX0/6izL0U1TmlUiwDZ0Zx2DXh4FjAUJExNwI6BPf0ZbQuRgwIZiBn7do+Jdvl1su6lMeW73jfriWcn0BR6f3EFgxWVra3NaH5U5Lk4hL+xBRrYUB0wgAfJYCxAsVZP40CIK7NQwGlxcwv/1xcP/wjbYkRsBjjlOpwssl
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
index 35f1ef06eb6c..87e9dfaf61ac 100644
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


