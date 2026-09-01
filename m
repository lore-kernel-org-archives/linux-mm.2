Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B914C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7C96B00A2; Tue,  1 Sep 2026 01:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FA46B00A4; Tue,  1 Sep 2026 01:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09176B00A5; Tue,  1 Sep 2026 01:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 939686B00A2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:22:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04B531602BB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:22:56 +0000 (UTC)
X-FDA: 85164049194.18.E644963
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf28.hostedemail.com (Postfix) with ESMTP id 40230C0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:22:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bY/R/fG1";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3LWGWagcKCKQaJIPMTIKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wfelipe.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3LWGWagcKCKQaJIPMTIKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wfelipe.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jqsz8r0tg3s4C+AAt1rnTrXqOx6Ok5MB9VnHnrHji0=;
	b=HU5yXDu/oVU6sF67d/2bak+AYb/JtaDHZ3rj5oWXwBxwMAC/JEJFct9jLcKDvLXnD5OtZi
	ap0wgMTx9LzU19aCBELPW86iDtL2slwfZ17IvqTlZJ3GWzdVZiwfhOI3CUNUa3KQLsY5h0
	dmVbzQVmeEDuRIDVFI4zK6q6x01V0zU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788240175;
	b=zTnA02MndcH5DRHSGc67ioXm4DKampQB7/+PilfWSOqEFLS++5GfZMhI2x6CbLiBkXktzQ
	2WIlihPZwhdIAPTjiDIEcKMV2+lSH2TBb7eJL9PL0Iy3wc5wJt7qvpgSqIwZSwYytgECMo
	Ok5sf2026jWCrAJ6g8CAoU1TVpkStlg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bY/R/fG1";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3LWGWagcKCKQaJIPMTIKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wfelipe.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3LWGWagcKCKQaJIPMTIKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wfelipe.bounces.google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc2229450b4so670007a12.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788240174; x=1788844974; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1jqsz8r0tg3s4C+AAt1rnTrXqOx6Ok5MB9VnHnrHji0=;
        b=bY/R/fG1iV+yMx0EaClAM2bZxHFkQuGISewr7wk5CkzDnzK0IhtyjPTf8l86sOjbPg
         2+F28Q2GtEkt7TPWyUmBBjjt6qKyO1H/+B7MUryCKZM5loGyYlk2ME2Kj3xAKcTu1yEM
         mHPKJArVTB6FLwbww5fJ0Bk05vja63IMSACWBtLEE5zHCEl+UgoppEtheSczVo0bk0RW
         Im7oava1PRTwjGA0nMucQu8GRlSvJFfxEpkR/kdDDOGJ8g3KMTiFMsCQIcn744imJnxt
         eP998qebYCim+ZTm3BPLi+uIFONFTHCalSzAtbnPfrlr5RaUK+hY9+iEjfc2On+DLNy6
         cAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788240174; x=1788844974;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1jqsz8r0tg3s4C+AAt1rnTrXqOx6Ok5MB9VnHnrHji0=;
        b=Nxn4EmHFjNnFRJaMGuovBepETY8AYG0BTsWWetXoFX/bpf2YC1Z4AV5jO8EzjvlyV8
         kcg+2f7c/TPancyviM9v74Q0jDXMcVE0JCCdaXRcJNxUt5fpOrvm8x8t/fooUTP+NDhs
         EOLKkc2QDBlouGSfP3qFi/oeSiTxlFEX+GQVnB0xdpYK5li5/7tNkqNmJr/yQl1uJ4gj
         uSin0pKQ8vE8tJ/8bOXI5dfjIRP38DVv4ohypRtXAP/wHMb3zn9jWFK8cy3PTgi17ppq
         VcLW47QoSsSKfGxQMJaYvZVNAYWcPftkeyS12cxBClsG0q/ux2CjhY3DBEdatDVhIk/b
         J+Jg==
X-Gm-Message-State: AFuF++ndEU4GuJKX9htVC3Sjg0+6TcNLkl3vG+RmnOgv2T70IAcqxZu4
	ARlHBdkXoU4NbvvkcvuSyBDllCPfeQk2+eLqloa7gJOuBl5dVdNxZcXLhijqhQt3ZnNPhAGy0Gf
	wDxNpsgwL2w==
X-Received: from pjpu5.prod.google.com ([2002:a17:90a:a205:b0:396:4de4:b1a3])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1811:b0:398:e86b:ce14
 with SMTP id 98e67ed59e1d1-398e86bcf08mr14606352a91.20.1788240173753; Mon, 31
 Aug 2026 22:22:53 -0700 (PDT)
Date: Tue,  1 Sep 2026 05:22:27 +0000
In-Reply-To: <20260901052250.154532-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260901052250.154532-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260901052250.154532-2-wfelipe@google.com>
Subject: [PATCH v5 1/2] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40230C0004
X-Stat-Signature: 49i7dnjoo1cq6wfroh8h5ionp4omckzg
X-Rspam-User: 
X-HE-Tag: 1788240175-875485
X-HE-Meta: U2FsdGVkX19FfcMWmq161qvvXjyMLkz/Ue0PN/mTmSjMR+Ll4WhZoTX2LKVtrUCD763yobqim6tpVo4gGEkvRHqKqaOTK9v7DRv6uOUBF3kFzKVqySFBUEaKfyOmZfwsl0dKO7tMRKZDLEYdHBh2h+ILI3WX3/sizmRqZSNdNGOaAO4ojZOK+e8ra8elNFq+WvTkyiorla++r5ZuWam38nAtjNtKGD8Fq1WLRGiD+zBFpcwGj7epk9l2fVlAx74zf4r0moGyH7maq3Ka6nlt4RhnCkPL314F9v3rpd0qSw7TEs8S6H1yDtHMIpr/KR2aK74rEXJaWnUFNFQ2fFhpsHKF0L3irWC2Y9iTB3tNa2cA10nwQL5G67qElUYBUiI027YtA1zn76JoLTOTaGEiq5hm+zf7bgfA9+ixD9ZINfLPgal1zGH/1d5NTcNfkQ8Fx/n0U90Ff7BetIci3+iDRxq4iIf/ja5O8DF5CYRbiyJqWAaHrxD33euHlLBgNQBVgPhupOa2xhfNKOalE6KuIQtP8LCR0HPxrsqU2wj3SJ7/xgSyjcGF8OUTJHoFK+jT9tQMTUvQ2P12YCJUg94TkSvgjPPsVm0iBiZTrPk0Uao8uj3Du8vlzeA1UH+3oVWwJoNDk8diIdIdeOUszg/K/u14dsnhPFMidKsVvcvgTmY3+NgYfg9+DZqZVnZxA1RJr5bkOCcTwei/tMXjvJVvIKIeh8RcwNyAKaO96UkkGMRyocrOKmR7T78qwHLCpcbohBQEezZgyYo3pBRF9QK82cjVLwUr8uoPA0jr6aZBc8HmvYQ/2xqhswJsiX2irSIUEpvRsrD7N5pOgIn0eSICLNbZbL2EC5k5w6cZQ5za86/BJARAqmMfIY+sz9FpbA+Rq8DyYNzoFGkDZecmG0fGvpFE3MhoSvWxfVWMT59YS9J4SzdF6GNcOZiADT1ClBLm7nrTDqJ+6H20nrls1uE
 YTpnsKZR
 Dqg/sTTWZHXkRhxWH5kK97dyIURYTQ7GAUgKx7yXCyn0eba0FsbJc6RhtqhDR7jlx7v+8/ZwaSB2SJrewd9vu/29zZHttWzLVVOHcOi6amwBvfCe7oYwsjltKdwB6af1UWhHzxDlqqwuILsFrmlsYurFNayE9GbviNM+7KgL7y4kJyucJKohgMh2FVYTNi9wQCSg9OJ4LJfsESDW1HoFDuKhNGFFPiLCKtKsNPOnJXQWkVJe/6PgJe+CmX5B9Uya290xxrT79RMPU/F6nMnymJUSoDH8BXdj2Ouy3H4MoQ8JswbjheEcVTXaPqZTBfEUJc+ElZ4mXUYKdZbkU6byHDkqMbqdsvPK5bQFz1YZ2CuBR8SA8AIJAEskJ4g6cKaY966QK8cK2Fcy/1A868bq06g5bqsk6Vh8l667zdknp7H1qmmtJC/Cwr0EBgYLE4KRk7q8XW45LLuAT+EdvnwcOPz/eL7h/782zRKN7sPzsuyeBHk8YnyW9lrq5r1pcpfWHzoM8tVoEHX06WM2ADg4bHlzR8DGSnIqr5w1cGC+3M8kIVT0e32GxLCNzJxRTou+fV4asg523BOsSxmeJXUk2fter48JchzduRVXGmCIOiocJfx/y8sSQGDViGD67VlmeN3fq2w/zfTu0AaR2qr8lrynopyfEF0pjwK753v0MNAgiAMi0mOmB0fW8LdgPT7GWNvSM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
test_zswap_writeback intermittently fails on the initial run after boot.

In test_zswap_writeback(), after waitpid() reaps the child process created
by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
can fail with -EBUSY. Under cgroup v2, enabling domain subtree controllers
is forbidden while any tasks remain in cgroup.procs.

When a child process exits, exit_notify() wakes the parent process,
allowing waitpid() to return immediately. However, the cgroup populated
task count (nr_populated_csets) is only decremented when the exiting
task is switched away via finish_task_switch() -> cgroup_task_dead(). On
single-core systems, the parent runs before the dead child has been
switched out, causing "+memory" to fail with -EBUSY if written immediately
after waitpid() returns.

Fix this by waiting for cgroup.events to report "populated 0\n" via
cg_read_strcmp_wait() before enabling subtree control.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index 609c48f38524..8f2c9aa4776c 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -408,6 +408,8 @@ static int test_zswap_writeback(const char *root, bool =
wb)
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
+	if (cg_read_strcmp_wait(test_group, "cgroup.events", "populated 0\n"))
+		goto out;
 	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
=20
--=20
2.55.0.970.g62bdec98f9-goog


