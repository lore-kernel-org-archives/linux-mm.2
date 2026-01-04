Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0B6C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 12:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7926B0088; Sun,  4 Jan 2026 07:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454656B0093; Sun,  4 Jan 2026 07:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353DF6B0095; Sun,  4 Jan 2026 07:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25AE26B0088
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:18:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9F82140982
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:18:02 +0000 (UTC)
X-FDA: 84294183204.01.A3B155A
Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2338114000B
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:17:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=UiwiZ72E;
	spf=pass (imf23.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767529081; a=rsa-sha256;
	cv=none;
	b=6HEqb6BWZ6tYZf2hruOlXuX++rpasODOyDsUCvLdx0neE+HF1Z+5rdi8BPSgOyuzJ788Eu
	Zw479Wa6YpTmD8oYi03qXk+TPUz+V5rnb0knbDTys3fEUFznd+Cy3fip1KO5YqUDThFQi8
	J5X7FrWltPqErPYYKqVTng5Kd9qO0og=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=UiwiZ72E;
	spf=pass (imf23.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767529081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/z+V1pSSbU+lSVDgvRDlrCapTmH2Lgc2n5gwlV+Ah1o=;
	b=6OyoGrD3ZKKRClKFD0LTh6n45JpJydZKubKmPD5AkEHfc1zGjXUq15GQGI45Y8spL2Dwtf
	aWFPs/LaU4arv9/6HX58C7sQNm6JLb7iUtr6Aoh/rvjWVUuRZfuzeb3H4z2f9dL6A+e+Ac
	6KO5U7tHYGq05nXgsFw878/ue2zPES4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767529074; bh=/z+V1pSSbU+lSVDgvRDlrCapTmH2Lgc2n5gwlV+Ah1o=;
	h=From:To:Cc:Subject:Date;
	b=UiwiZ72E/k4VhTuqN7bYdYqm8/wM4i0qQ6OJzy4yvLyTroMjTydJfu+plR57C41em
	 1Jd7edVER8sX/MvlPFTfOn7/I3bUupLRpwjlLkGnic+4Akv5L99PF0HX/1YvzXCOw+
	 akBhTj1j67hYojr1g9p7AEW6fhunBBs8P2HuCiLs=
Received: from localhost.localdomain ([61.144.109.141])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 473AE06D; Sun, 04 Jan 2026 20:17:51 +0800
X-QQ-mid: xmsmtpt1767529071t89bqu975
Message-ID: <tencent_8BA7FE940453AF73CD41B2F517A52416C105@qq.com>
X-QQ-XMAILINFO: Nfa8ERPlB8vKJdyOlBY9nyc2FCh2XZqTjecMBePxFnECbSYNlqY9QAt3majMZy
	 UmWNxOQu47IH94nfm2pBjf63p/ogmspw87mVHgUtwfvqZj6iqQe6fRdsaMh2DzBELk5FfEJqvz3a
	 0FNkhOe+DIYvE9Euk+UHy93PI8/WIhQLGf7ZtGCq/8pFlpXo7zHAtfuSdftcMN+mKM+EhCrzCM15
	 2JvjS+UQ0T1LLx1QANfvisDj40I9tSeWUWn+40+QMBTUCeoir/x1BdSjA6vX5Mmjesa2NaA9Q34Q
	 5m93Fgweul5SIPOy0ihxkfIaDZ368qWiAVC7IALP/KTZvPSUNnVmKrEEdQ1Gt88r9jJB+snYswvZ
	 UMG+r4RnOI6yjFazVuW90zdpRv5KelpjT9tPGmWJEut2uQVV11nZIF1ywUsSMRzrbBKOXhqWN4wm
	 FZ18uc/j1R8Np1rCcGJ/GuKElt6ZNkZ6IPrbjIQWlTHdXxzVtvU4UHiDhgW6gg65eNCqnORoM7qg
	 mBOplRN7aLa6eGnggUNg7+Y72zXyX8BC3FXek2SEvMrRjncaHuZ2RxNhk5E+W8XjQ4/8ydO7lQTH
	 TGgTmCU5vf6JAiG1iu0zJJFPheP22/VErNZeUdPNuDjY/wU2fyGFNCmcYAZo/N0/t8+TjKy+mbsF
	 hmx6S6dVrtG5gciCecTEdVgjMCmOuiHynJ73PNf/SQWhnki56JrTymwSPGmGf4BSVwIZMRn6S8t8
	 bVNIjFqhkjx9t0rcLJ7HykpEd+wCHRswZdv928GgPY0gJvsTrInjb5CgCXGC9D/BA7tPSwSLJ8/O
	 OG3awDuhzpiaUmFyeCquiNzgZvuboAmMf5QrzJ3cLuaW4UScMQ6V1SB26XwC9YP+pON/CY0U6TNz
	 YV5WhhFu0NOZ0+9XcWVKpSZvEbZBeeylEOXz8yGPgwMc7xU3bk24YnrxKs5X1xS7765NwMOjsAgo
	 AvnVG70gO4txs4DFXwFWizDpUE7+D5BOZEsZ9Fu9V2WdQIGe54Jfgs+LFMIsoCeZqUmFP8nErjdp
	 hfQqEgX35pgjbO8q9seveXD7skS4o=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: wujing <realwujing@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	wujing <realwujing@qq.com>
Subject: [PATCH 0/1] mm/page_alloc: dynamic min_free_kbytes adjustment
Date: Sun,  4 Jan 2026 20:17:28 +0800
X-OQ-MSGID: <20260104121729.1217059-1-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2338114000B
X-Rspamd-Server: rspam04
X-Stat-Signature: hzn6jhnfkzgf7g1ocdjghpg93knxb5s5
X-HE-Tag: 1767529079-92263
X-HE-Meta: U2FsdGVkX18C7678Eu2j0DlS8s5eOnVq+G8v3vpYZcUFehge72NAzzuVwGSk7EzAjz/jLxRb1BZzsuebf4GbAk4Yt9Y8H1EPzxJGEROP8aS0JW8zGSoULG496my9KgzSEh4fzL5EisKFBy72XaM4cMupDwNlrbwICXB5cGKKU7bdYYXv3XzQYXxlEOpZGX9qWSaPl8f2FjxCM21/QNk53J6LUUkjAqmV8yUfcvR2tvjXVbDU0/trgtuc4z0XqpjZJmHkRTuLdkwkYrprpL7h59A36CbERDJBHHI7kAbKZTx85BBLXtdjqKPsGUZkmz2SQdnPDGrvu3EBOhFwKonDFGwRY/VTvDHqOd9hLaeICss1dqlDOOp1+uq4kCD7aPFhpREiaMS4LQkuE8gWhg1+gQlYSJjxt+an+9NgRTcVvo2FnwW2onzXdcMkv3zhQvGIvWTjiSsO7UiN8BC+RwyF1nVlwfdmExgay4zUjN7lpO346+fqOLILVE0KmtC3B09qP8aY+3CXapxXuVuKymRlQtXWLy4XLG610szCmBTm7LkJ57uz+T8yHQu7hs9c3iKMGfyQOCsLya32j3O9ecohDLgXThAmy7CpqUg4++SXoBwobQrIhAH03nIzlnBcQwS9nj/9qJFvJhwe9wU3Y1USPhvHCqu0YXvHSRwJhwhV2hZLnw2cNP1uMJH2XZuFV24PT0FudhT0TNO0+/QO52NbvhTJYzUlcxyhqAEguuQuG0nd5T9+fGY1jRFBJrl8HDoE8o9IzLo3QEKgn4eHLVWjCINrcUjqJkrxv8aV+JnUN5UcuJLuBxo5+TYONWFMbO6ntJwlyeqy9bX4SNQr7yo1XjpPkIFgzdqt1kAKI6z7dKujbFZtXjkBGqnLUpkkXFTFuFb63NfQFe6nBx381wxkWLkPCLLJA5C4By8gAIoxyh/lSSH1VuLa2zg2fo5Fdv/wEbgG3qm8Q00avDxs3nl
 /mT2nsKi
 6I7NJbzHWSFCNJKXyVlP2ZGhSrcmyGpPUZMQuI1h9tNF8Mfi1OudhtGGzKBvPyxGc/9Ykk0TN7xyQIMEIbQCQ3UtgRr+fc/DGNV4+jCb7MQ42JC7RdGA48gxVKkSh8HmlNAmFHH4aXgayZ5ezcDTCNLcMU+z7zqwfu8UpEJ4ZUIIjKqW7Q1Me1Lbznul9Lb5VF2xHwhT5bpJO3/+OwsmECtaPj5kfAaxu89wP8Q0DquUEG2mcOUzFDIv8TUy5Dh2zvmEXI6Ud61uT0TxyWOhOn5sAGghFf36cH99q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC), particularly in network interrupt contexts,
are prone to failure during bursts of traffic if the pre-configured 
min_free_kbytes (atomic reserve) is insufficient. These failures lead to 
packet drops and performance degradation.

Static tuning of vm.min_free_kbytes is often challenging: setting it too 
low risks drops, while setting it too high wastes valuable memory.

This patch series introduces a reactive mechanism that:
1. Detects critical order-0 GFP_ATOMIC allocation failures.
2. Automatically doubles vm.min_free_kbytes to reserve more memory for 
   future bursts.
3. Enforces a safety cap (1% of total RAM) to prevent OOM or excessive waste.

This allows the system to self-adjust to the workload's specific atomic 
memory requirements without manual intervention.

wujing (1):
  mm/page_alloc: auto-tune min_free_kbytes on atomic allocation failure

 mm/page_alloc.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

-- 
2.39.5


