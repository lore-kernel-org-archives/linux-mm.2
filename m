Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606E4CD98F0
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 02:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B714F6B0088; Sun, 21 Jun 2026 22:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22836B008A; Sun, 21 Jun 2026 22:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11596B008C; Sun, 21 Jun 2026 22:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 760BC6B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 22:50:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC141166BCC
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 02:50:18 +0000 (UTC)
X-FDA: 84906019716.21.5795E55
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id DCEA2160003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 02:50:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dk1IORVO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of soolaugust@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=soolaugust@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782096616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hyww99ljWm4jab5h2ExE0M0oFPAAyg/3ek5Kzuwfymw=;
	b=r86oEsn4GQbXrkDG7RQlgh3GsJNNMYUr+fbTWBwjRj5WKgzQ1lSUzdam/+DXKzMDxPPrAF
	zxXhMcHNPKQnYVK+4mo22Nht+/t5w+O/UfkNmbnmewT/RQB3CxI4o9C5OhSVjiXwbBct5H
	lajzrITU7w7s/EQWQVbXkcMVRI8bMfg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782096616;
	b=FPl3S++Wha3Hhg9cCP5YnwviElv8wRb+QoA4giriIv8GFJSU4UzqTaRe6WsWMMH1ONza6k
	+e7syaNnRC8TFppOkec522o5IRik3kYB63uAe2mKp7eL6yQa/LkeYVA7kBjfiBKJGoHgSb
	XhKKHAkmi2RZ1RkF9DWLyynCTMSgrPM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dk1IORVO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of soolaugust@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=soolaugust@gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c6be9cd89bso16207965ad.2
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 19:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782096616; x=1782701416; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hyww99ljWm4jab5h2ExE0M0oFPAAyg/3ek5Kzuwfymw=;
        b=dk1IORVOJwucZGWIqPlEMA9fRLpUQ2YvR/9BAXLXCTkYu+V6yYuIHW5FB+SpaxElQl
         LJDO3YrxGKOm1T9lbPCX9IxvSaXDtd5O6BjttaBFCtNoZFzxQTCHKbfWndei70HIzaYb
         C+x1OfG19vdyN5fjWHcQ7kxGCFC9qqyMeiSFwxpJkrHS1cW3c8k/wh+KY2ATokRyIhFQ
         AylCJkf/w23vgsFL6ZLajo8I1LQPe+pBjf8rVnaCQY58RnoNunkWe79/48O6cK7UJHd/
         sNszYoQkgf+PQB7AnXHAfPH4VT7/JNRhbN/eQl67/FaA5IKHSRjrrsv+ShIRm2Ogoa5w
         MlvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782096616; x=1782701416;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyww99ljWm4jab5h2ExE0M0oFPAAyg/3ek5Kzuwfymw=;
        b=U3OLwB5PejZqXOAyYKOCYKNN7AduqVTbLaGkEkQeGe5lOuYHC28MKl4hoKW9R6lw28
         Bih1cn3OiFCrbbx2+WIl0lwKQjMbtlVlsKdqSFtPIUckpvnZ8hL9viCS8Hj4PnzK8ESD
         R7QfV3YeKFtJHWzIOe/DPdHn3rwUpYR2MZuz9BwkxMB38J2nvWF9xMHUHBGYCfisk7+5
         zifjyltlZuuFjeAg9elTGwAJX7WKPtRF12iBBtq+9CEvRkP7rU+2OmnXhfJ71gOsQEVC
         dENOKCZfGtaLMfCESna6P8dLU27otAvSRDWsvL+Lc68tJ97J3Zw4FavCaWMJrQzEpww4
         GT/g==
X-Forwarded-Encrypted: i=1; AHgh+RoGJ0PzlRqBVUf+YX8wjbB0CEDrAzajCMFPQv4jbmHKjpPjiwZC8Nxxq1KYCDLGREXEs4h5v94xHQ==@kvack.org
X-Gm-Message-State: AOJu0Yz/oAkoQ0evE+0jRWib2ou6744dojHaE8k1hlpO4g7a7DjjtjK5
	B3krUMcJmlyWJ4JvSqJxnksY4RaeIv6k/j8y5FMHWu0gU655MIVWd2Ol
X-Gm-Gg: AfdE7cnL0fzvVash8P9qe5Wvt09vBwlr5Etyimd8FeYS0KZMwFOo2f6+1FTbne74Qwt
	m+j+MtQ60v7HD/yYwXZHLZF6bPdcb3WW0A56opm7wc3YoH6z+bnsCuGssWPb15oUyZL/zLq9JyU
	v08puXCRK1Fow4COrdp2MhD7OB3gxtflu5RP2Xai5FjxmERAIJfk8zeCwYLj9tuevl5Gat0hMqG
	iQDDxkhLdVAgQi2I7TIHm8mtPAiVgwftdBElot1uPHZf8LLe82LoGHoF/olVEaLmUzwop5mVYp0
	MaMwPqBgOoe/5kjRCJlV7ZuU0n2AAPgnc5VgiBdpLcmjKttS6ej4vZoDcJnpZy1EpY2lfUzwoMI
	TdvxZZm+GLdg43S/d05l6nym1ruq4QyXN76Qh3hFhWLxnuZ+1/1UrNdVSA+P5djwdIgDFPC0BvF
	5AC+/sY8l2HvqM0DBhF9UyoFHPqeWPk5g5Vjo41cmJEpYem4JDV4ON1lHJQhLa3ZozqRvVwFWKf
	fHL
X-Received: by 2002:a17:902:d545:b0:2bc:ac76:c1cf with SMTP id d9443c01a7336-2c718f1f023mr152321965ad.24.1782096615676;
        Sun, 21 Jun 2026 19:50:15 -0700 (PDT)
Received: from mi-HP-ProDesk-680-G6-PCI-Microtower-PC.mioffice.cn ([43.224.245.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7439f8e51sm65579495ad.39.2026.06.21.19.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 19:50:15 -0700 (PDT)
From: "zhidao su (Xiaomi)" <soolaugust@gmail.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kees Cook <kees@kernel.org>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"zhidao su (Xiaomi)" <soolaugust@gmail.com>
Subject: [PATCH] sched: Preserve timer slack default across RT reset-on-fork
Date: Mon, 22 Jun 2026 10:50:06 +0800
Message-ID: <20260622025006.614695-1-soolaugust@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DCEA2160003
X-Rspam-User: 
X-Stat-Signature: b5ahixipaeuydqcs67mw9tjpucwphhoa
X-HE-Tag: 1782096616-630705
X-HE-Meta: U2FsdGVkX18hU1dlNaBSkVkRdAFjFxHPbUfK5PubB4+QPLwsVlJOHomXvdgvUitfLM5+SYAiWRtxsQMa7cSx+GUscfqxR5Ho5mpks0yPvoAEsx9mxQJxtyKBBoUipPzTK/yXZouaK6DtVwpFMK3cp0+0E0J7yOFGqTinFiyvIfnG22/Uwt2wKYGw82p6RyY02hcwrEd9NgyOAMGBq9vNZSiPdRHk6LOISxtvc20bV1Z5577fQ4hIuSQOj6hZLNnjwTmfZjvIR+MeSDjmiG91QubWOgBkbOiOCm8ftVdY3WdxY9WnLt9zri5LNOJRwocL74969kQci8OWHZV94Izc7XeDBpOyxAvEItmMOg5pgiFlay1qGss7HBtDAedC89opeRw1kzf+Ted2ZnpfgHNu5hIAUjeQN38mNx/5fmhIAA5YpY8WBNbgD/rTFjpTrdEjed5BToPbeXTxa4W0GeJ9Tu/rvz8sqPggik90w4QMuatJWm5VTmDOf8R3CnGovj1OZ+12OPdAFdWuLRQL7Jixq98gJ5o1AFCyxpIevFLoTCJoombASloQQZ6unlAiRDy7tpwGSRDWO7wNFEb2D0OzJ3Q7IbptOH2KB/DUoYEpzMqOcvC56ZjN7XKVoBoG5EKhiQZPBRBN7TFxJHxBytQsIWqQ841FcJTxUcyR9h2QU89AQBkgpzySQ4XVw981Z/lJNYO5VJEFWhGi0Zhsqp/pseZHydGn7BI5S2Vrjn1Z7ROjaFg9M3E9amiK0C9abHzpIW0MsUHSQWzVhTT65NAkm878Eng/e1fMnZNcDJVY5KVnsLRPGy+Px/arfxWCNxnk96XSjho3XjL5HEN4Ae4F/T9/rE/Ps/OrxBE0A9/hBr9BRLw7+pUTNDkbORmKUGdtCO9trvqabx9caowo1hTxEtRwBkq/1Z+vcvC6GwOs/FC44E51YhH6JBJXIsLugKt7mQpRUJxndTfxmsTmYOr
 pOwzNSN5
 r1uB99pGh+PmSnhwacfygXhLSohMIwPWw3e78SzBRjEeQfium7k4ll4PjnfFKWnSqg5hQ3fRYyDRkna5mxNvxhiqC4c68SO8L+nXg9A7KpUo/QvODOCLHdD587RQ6bVyIqfo56E97Djc7xgMiq1MJnQlNB9Yfw/5Rb/QLOeiZamwxzRsji5I+nJGneMU+I1rfZ4urmn7WslVaRVCdOrum6Z7ibGWxlRTjVoO1L4oKi2KTaJAvzj737vTQOKeNZIdrXUN5+L47m4CoxdeEOEM0YHOu86F8oSJ6E36VRpslhJ+pQ4uD2hRNt/ZsvyR7NkVpRFkwsFKsH/mPLuKjofVUfl0WKgjg3sBWLbVRc88ZCvAQswU93wN1I+cmKila6PW57WVNCTI0BfLmdp2qFxE8C7j5ib0R8IDvYWaT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RT and deadline policies force timer_slack_ns to zero while a task runs
under the realtime policy. The original slack value is kept in
default_timer_slack_ns so it can be restored when the task returns to a
normal policy.

copy_process() initializes the child's default_timer_slack_ns from
current->timer_slack_ns. For an RT/DL parent this copies the temporary
zero value into the child's default. If the parent also uses
SCHED_RESET_ON_FORK, sched_fork() resets the child to SCHED_NORMAL and
restores timer_slack_ns from that already-poisoned default, leaving the
child with zero slack.

Preserve current->default_timer_slack_ns when current->timer_slack_ns is
zero so reset-on-fork children can restore a real default slack value.

Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")
Signed-off-by: zhidao su (Xiaomi) <soolaugust@gmail.com>
---
 kernel/fork.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index addc555a1077..39db7502379b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2196,7 +2196,14 @@ __latent_entropy struct task_struct *copy_process(
 	retval = -EAGAIN;
 #endif
 
-	p->default_timer_slack_ns = current->timer_slack_ns;
+	/*
+	 * RT/DL tasks run with timer_slack_ns forced to zero, but their
+	 * default_timer_slack_ns still carries the value to restore when
+	 * returning to a normal policy. Preserve that default across fork so
+	 * SCHED_RESET_ON_FORK children can restore a real slack value.
+	 */
+	p->default_timer_slack_ns = current->timer_slack_ns ?:
+				    current->default_timer_slack_ns;
 
 #ifdef CONFIG_PSI
 	p->psi_flags = 0;

base-commit: e771677c937da5808f7b6c1f0e4a97ec1a84f8a8
-- 
2.43.0


