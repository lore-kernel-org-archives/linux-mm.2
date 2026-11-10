Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82A3606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=iyixgFAg
Received: by kanga.kvack.org (Postfix)
	id C85E36B05C4; Tue, 10 Nov 2026 06:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36EF6B05C5; Tue, 10 Nov 2026 06:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D8A6B05C6; Tue, 10 Nov 2026 06:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 996866B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:47:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CEEC120534
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:47:09 +0000 (UTC)
X-FDA: 85419033378.14.D863C32
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 52ACB40004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:47:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iyixgFAg;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311227;
	b=MscUjdecD7QJASDKWaB1rVfYaojo/9NlCCjcuqAh+bPCzNSD8crbuA2zRAfyydTKBBhEG3
	Y2djWRwhkkvzlTdr93Lu38wZrsc01PVpua3Kd2rxIutcnLa1vO5lmtzLW9D7sFuEXO3opC
	bBrRYfrbdNcWd+kcipxWygoAngJiPDo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iyixgFAg;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMjTt/yM65LJnfLBEkqU4HceoGuAe/XUxe0Ej6UzqFs=;
	b=2BbB9o7OypZZd8o2lPAzdNR5gLO7X6OEhvOAp/QOiuK7y6MPKn/0Z7yzU5CE7ZkaP3cnqV
	A3nmzcN2nL4UhQpKZnBlR7BFVqJ6vw6giZe5EymnIQ3IEDGAM30cwyFjliJttyOW/ZD9rS
	WrPftuNx35h4gt0SL4v0pYULH1AqGsU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=TMjTt/yM65LJnfLBEkqU4HceoGuAe/XUxe0Ej6UzqFs=; b=iyixgFAg9qREIYke8njMawXuIx
	m+6DM4Uqz9vuRKRMNTS0WtEuw7lwrRzO+dqy61GCeyqhy/5nfW/VPdGm+Q9QyBvuQGWkMSkMK7lPI
	MGk/hYTjmx9FbtzL9vBmtflZ6A1gUpXHjVEp/jB3Na/Q4SqPsQe2m+a/oZ/sRsfzEVunoXZSzi5+o
	pmLhZuxFG16tl6QgFE9g5fn/7IfTQYgAAee5GlO/OWWUy6qbfBFppcHComW9Sb11YqYo6l3AMb0hO
	61bPtWO+VfG30QK+x/Ewx8Usbm/VHCYUwt2AZWKncW5rYsxbB9rbccgIA2dXwP5XiQvhfjCnXWzZG
	nPDYeeqw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQkJH-00CNSq-33;
	Tue, 10 Nov 2026 11:46:44 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Nov 2026 03:39:27 -0800
Subject: [PATCH v2 1/4] writeback: add the missing newline to the slow
 writeback report
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-writeback_stall_report-v2-1-9e0ed75074ca@debian.org>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
In-Reply-To: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Julian Sun <sunjunchao@bytedance.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1238; i=leitao@debian.org;
 h=from:subject:message-id; bh=NeGmKN3thvdahCzcgtVy86L0XUPUwXecQRMKsZHaZVs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq8wQYn+tO0/VLlCpKrWAiFk/NDyAXlM8rdRiIY
 5NVV3z7jQmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavMEGAAKCRA1o5Of/Hh3
 bWPjD/4+JCpUjzQC7+wpcfuUqpIQ257Du7Kdozk0zxWRhZyLexwAvUq8MrMgAjj9pnefRjX9WH3
 bWh8IdLz/x6p/emum/ddOOCpq3hS+yUpA/Nw95efr5YI8+ZvmnfA5ktJxMMv2sJz1oBmluexzFA
 nZeObq4sZfp5rXLA19Y7xnISHT2sbijtsVazm1m3J7obgvMW0MIgiKIfHB2pMEVOlxBa3i3lZQb
 SDnuQUj2GQHnRCUUSsvmSqF6vhFkp0dRey95qurL+iKwKPt9kIF5u0vXJEHWNQzLwUYEluPPYLJ
 McvMXURJb8e/B92meu65MID8Dl/2R/RkF3Qs0lUq97w9oqZzyUcGYzftDhvC/hOzGh/+mG7OWGm
 J7Z0jhZWaMpZe/VP7J8D+XYMv5uhZrw96OUGkxSc1Rr3hkq0EauSRPUszKGN/MmEJgIQ6lLqsrp
 OPVBX9zrFualqhV/iPBqMe2OpO5kM/4zZKY/FAz1VVs8WP6YrSrrCyLFblXa1cNheJiSgM0XGfi
 q+AAV7axQ6aiP1c9HaHF9cv8T5jhlpXvsFsiuBZNUQ/a3RevfIE300XwXtpANw7qu4lhGMipzqS
 8xT3Ci+znxzd8wA7nVV3xaEj+NHOdyfyPQ1QvQKO++VKHpyrwJfguFsWJpBK4+xXUaAfqZ53tx2
 GZBW8VwocVvy/9Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: sywj3r8sq4sbwhfszidkx6y3h8zxtfwi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52ACB40004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794311227-692316
X-HE-Meta: U2FsdGVkX1+a7hTsjZrJSROARN9UCaV+4kNWdY2/MZea5Pn0O6UE0HtyTcmDQdenYNcsHI64+WGnRfLyp+QRBF+1nK9cmaILZYDj+m9ZqPLx1f558Ua3m5NapSlfVzBosh9Gx9EyENi6Yq8YbT2/bJSKLYLr4359sl4hXXCZjX/dJSeR85AtSnlOrITVkhK+qVqo4I7qHeHu6qeTe+tB/CnopFq3aWV4cgxGLzOP0/ImKLzKdIuB/UaMTVA6I7NF6cE3Cvvg7LNgxKLuz0iZ69pnThNxT8TjsbWHs6rl+0edo0THee1flUyKcfomB1eKvjp6ll7vrbm5W854pJRVYtfcjgCk1XlwULw6NmXc2IP0bODNBgGZQKZ/hiIy7d93zBMpjhoKduMo6kFYQTXWXlWQGEGDxixFt6fuF6K9abK0l9vapR9oHE4i+OBALsCNHeMRK6R+0ubQx2hpzsYDEJSaYfaEPqIezk20s7o8PTL1f4gMKA3MYmdnlL9QkLo2laRtszOpu89sJphSSDz9ImBRrtexBHU7VZd1bz5m47N0od31qOCmaR2uO+PUqbo5sDL/Rw/K6YYxNaNCPSxdIaYmtN/1h1vLaaiLoIcouIYUPvRDQp1ckrreiEd7AyBuUP5VUtcRLZrRRK61vvCiubx8seHfmti0DVv2nyu5lmjj0sAxf2nua26wmiUKwGXxWJsKpXBzDEVhKgEjsAVecvwrdWLtsmGEmKH/RMs7G7JUAbKl1qCwDVA6BabzO1veYIlkF+WfMCcO18F4XcM2qz5ITNSMf2UmKovu4XiPopIKvIq1Uz0/QlJxc+8te+m7aBwYKkUnZhcKSNbFd0WKF2t/BTgt6V1IBuhQLO9iXP/R3hnXyxPIeIiPNykuUb8MdiNjmYgxFeijL5VunfblZ7UUYUPlRGiAa9HFYLZQjUt+9F8ghb5dakOzYY4FTzEhl6bhTABnZkDNJI9xzaO
 lqiugTlz
 8+yuL13LSRUqHx4MiLeWUdbl7lvkDmxbtYQR0Ew2i/GvLgYaErned+d1IbnNlXv0cffyl39iM/2rNgaG79kbJFdleo72/F5HtMetDgnCyr8sPm9yCPj4mQrsEkpJGPEKkr3BJa19MLb1sHFknv7qYwyX9apZ8QkLyjfD5DPCCmHTmPH/HD4ry+rVptuh9dolr7Tk+rQkGMY+XK/YJEiI2M/nbrscC8yhoESax43JMiZ0S0lMCbKQn+Qpu0Kx5CWLdUNCkPPuYPHK7P1nfyK2744XBhReev0i/0d1QRW+UHkV+R7cxA8bA/pabfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

wb_wait_for_completion_cb() reports a writeback wait that exceeds
hung_task_timeout_secs with a pr_info() that has no trailing newline.
printk() keeps such a record open for a continuation and does not
finalize it, so dmesg, the consoles and netconsole only see the report
once the next message is logged.

Terminate the message with a newline.

Fixes: d6e621590764 ("writeback: Add logging for slow writeback (exceeds sysctl_hung_task_timeout_secs)")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/fs-writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 15260cf2a29b09..01a00d7542b371 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -204,7 +204,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
 	done->progress_stamp = jiffies;
 	if (timeout && (waited_secs > timeout))
 		pr_info("INFO: The task %s:%d has been waiting for writeback "
-			"completion for more than %lu seconds.",
+			"completion for more than %lu seconds.\n",
 			current->comm, current->pid, waited_secs);
 
 	return !atomic_read(&done->cnt);

-- 
2.53.0-Meta


