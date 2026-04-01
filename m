Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C6810F6FBF
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD046B0005; Wed,  1 Apr 2026 11:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E1B6B0088; Wed,  1 Apr 2026 11:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884BE6B008A; Wed,  1 Apr 2026 11:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 774426B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:21:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25AE7BB825
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:21:54 +0000 (UTC)
X-FDA: 84610352148.04.B518104
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40556120008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:21:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KO1/IbXU";
	spf=pass (imf29.hostedemail.com: domain of thorsten.blum@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775056912; a=rsa-sha256;
	cv=none;
	b=Nt1a4UJtxyDOG0cjI6oTGh8BqIUeDtQ1uiAYKLaMLmRjcoZnL7SHNzuSCLGT/Lnu8bWtA6
	jVj7kKOCCl6ZtvA5v6mkCyKr5vjdBmG1WRYUEtsTph8klNuMe3peczGalZ1ATUEnU/zqmv
	u2JyQyEoVJkse2sYgVNVYf1bUl8RMHA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775056912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7zEkV6rAlsSBEPVbyFMZ428Oys5VqsSf2SLVRMYelsA=;
	b=YrF9j+om0y4e7jRtcyvcvWCZ56I/HfyrpBHGw41FCl5SiNHJ2zCzooHyAE5xF4KPNqr9Jo
	9pwQv7tanhIepPfuaBXliC80SXB5peESTwYRa3aNB9WN5sfZC/Nz5ZcN2g4AKTCWbKIeUn
	G9R948ekkeyzvrei2VPe0GP2bFxEpaU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KO1/IbXU";
	spf=pass (imf29.hostedemail.com: domain of thorsten.blum@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775056908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7zEkV6rAlsSBEPVbyFMZ428Oys5VqsSf2SLVRMYelsA=;
	b=KO1/IbXUSAZ+YOxPEAWkfbtRL5TDn38230kQD8+4o8hbAMYXxJCijkmC+sSA85KxcCscR4
	nuvXT2sgV7BNue+XNd4kXP6gsQL5tvpidi5gfOVCpxG5etLDbUBZIdq6ofkRj04bh3QjOk
	DI2hjqqy3qwI5AAm2bCmE+HDgvR3Fj4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] exec: use strnlen() in __set_task_comm
Date: Wed,  1 Apr 2026 17:20:40 +0200
Message-ID: <20260401152039.724811-3-thorsten.blum@linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=658; i=thorsten.blum@linux.dev; h=from:subject; bh=HS4UGZQ1zzADaK78wR3NC5vUlfO80M5mYOCHTc0l3KA=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJlnzY//e/yhtna51vqq/3c3fVlTtmGD/bHuC6qpbNUtR TqsDvLCHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRz08ZGb6nzqg4Xv+Ff+V3 wZnV4rICs7Pjgjh3TVv259xhtc/Xkmcw/He4Zs6zPuGeFd+M4yZKu/3+7ngze7uJ561fcw5YrUm e8Z8TAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40556120008
X-Stat-Signature: sf4th5osbhdtt8rfwysqa3ixf6ius5d1
X-HE-Tag: 1775056911-667639
X-HE-Meta: U2FsdGVkX18CwJUeczzHZg2f70bjBQOMaftJ7VxkR2EEGLSxZT2dQpNGF3e000bS/zB7WFiruCcvUZ8waIKW7GyfwMAAvbQBvevJFSU+VhnnlyRmzTnXA1ZJDq5x36qD3AvKi2t8lLt83TqRfzf1G74ba6xSnUZksVYblIemRgW57OeQR1OykcO9ilbrGz7ekcdnBLgYkTwmNweb9wQ+4htBqpOn646myeBdWuDI4pUS0ZmxBBYq3+INCiZ7FxU/gPcr9dwSKB4hmQW4qW50yfJi+k3hdm1AXm5LDRHmhKu/iRof2Heh49xGt3033SJQOWTXnhIOD4wSKh15XqchLF0pt6Z5duE4P24SSL/2LtcLLndKwQCO+YxeDF0uSg2Ss5H9aRgB/CWdXg7kJ7AADqRmmKdd6j66hpaxi1HP/sPAxeEKT2CdCYC1hbwBUE0IF3AfMpGVpeJSIZAWRZi/3hJdag/wXXuz1EZ4myDeoYvwaXE0l/jlCFfoHkXB6TNOEx/J+ROslMQg8WZcxNcU4LurwNHjtCXrhtGlqlqrbdpOt3qnQ9DaLrStgQ5orIB/BAgkPzb0QbcglqdHfat6sIbgvKJuHMpqC6e5tHObBknhKTDgNoMU57OhKxJJcK4tlG2u97HiX9GtKFeuVWeeyiGt6AlBG26GTl3XvxMbwMk/vd0b/0VuPAJzWPmJkKICpZj+hCyyeCUZC8hLX1s3J4xNqBV1ZnCq3+cdhCTM2AxvHotFb3fpqfOGY4z+uEe7ZLnNMHlz5vSe1RPwjGE5cPHS4F8FX1VIsx4xLU42ePEMy+jD2t/7CFO48u7EZ3m8qyJ+9yL8KvFyR2g1i5wU/cByojWaMsj4u6O9m4nLZdZr8rOsTxoVp6RGMVKDU3Cjs4ml11C8DuJLpEL39+Vfoc/MyxAaCD+yvoW6I0EKOf24JoVFLx4NAH7BkT+73/Em+iTvMg5yWppaw6MLXn2
 DTYpY/56
 EIOkELzeoKRiiaii8a2Qn0k/j8dcKQDxQhg6y0b/u+Ix+I6rK+Wn6+ER4oRN2IsF8QlkBZ/lMyydrDzcxGPfRXEEe72XKipXlMN36arM9HWSObgC2jv1pe29XNYUuoSn0NNafvbxMjYF87/4UpJ+anCwvVo4RizDdpZtryhEa3k+vDg3PFMeBKJ0+tDRxoHxuY2N1Nglq6d5MW5wEPvq9m88/Ze/80lSqJddWFvpI7H6Jd80EZZoxTjqKWk3BCAFKhxontwzGCTT/H9Hl2fwdhxQLNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use strnlen() to limit source string scanning to 'TASK_COMM_LEN - 1'
bytes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 9ea3a775d51e..ba12b4c466f6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1074,7 +1074,7 @@ static int unshare_sighand(struct task_struct *me)
  */
 void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 {
-	size_t len = min(strlen(buf), sizeof(tsk->comm) - 1);
+	size_t len = strnlen(buf, sizeof(tsk->comm) - 1);
 
 	trace_task_rename(tsk, buf);
 	memcpy(tsk->comm, buf, len);

