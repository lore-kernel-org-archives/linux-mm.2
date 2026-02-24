Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870FBE9B24E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 10:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE2D6B0088; Tue, 24 Feb 2026 05:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B846B0089; Tue, 24 Feb 2026 05:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7873F6B008A; Tue, 24 Feb 2026 05:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6094F6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:27:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CE8E59393
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:27:03 +0000 (UTC)
X-FDA: 84478972326.25.7A166F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62306140003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:27:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ejpxER/+";
	spf=pass (imf09.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771928821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jHsoRn8mf0kk7BSshtORn/F3LNvNF0XlphgxASSHP54=;
	b=rN485JuUnzJc3xBAHGH8WtN0O+sSv+YyaXnu5AxsPYFaMN5OC/nget67I252GJPszcAWgh
	ezJd0NYRN0o28jfkeHShsWxX9oC8G1C5NAIIdgctu0hEQGhoJ3U0wawFxzL9o5IUEjOfPr
	/ezMsd7sR6E/TfrdmdDIyeBTMrxD1X8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771928821; a=rsa-sha256;
	cv=none;
	b=PVS87uyLT6JbYMslgHbmqvRcevIk0L9ZslmI/dtzN7hwywGFyBO515QdyfaJcABKo3hnX8
	p1eIrCe0YcvV2//t8GGN7H0l4YmQHFqidx+hX0cqn1qcWCUu0Lpmlby6aUo0oGEq5HBtA4
	1oCh+jfdDjos7qUvmgyM0pDjm+jinY4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ejpxER/+";
	spf=pass (imf09.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD1956132E;
	Tue, 24 Feb 2026 10:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F631C116D0;
	Tue, 24 Feb 2026 10:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771928820;
	bh=EqK3SWnzbadzwJnZx0FShfZ4p+4sCY9R1N3ORwnDK94=;
	h=From:Date:Subject:To:Cc:From;
	b=ejpxER/+k/oyPgHcAzOqgOscY6cIE7HXwBie6jkweLEqcvV4rSFqyUY7gjPZ2hA3z
	 pDYAgZZgZ2tWeeIoibs12oVDYcBmvGZAUK2/vuv0n82W2V+Jfnvop2AL3DUvu/L9zQ
	 3hXzl3W6pId+fV/Y4q/ogo4YeNJKpJtuVDt6Cw6e36gp0srFoxIpXjqhF5HHHdN38A
	 hPmsXVxKsJ0H+AmVYuj6WBskhWcedLFm0GJlcthhFZqgHwTGq4rMzyKDCw9cAp+M2v
	 DsdBUloGhQMlzBJp1fjGuBHf5eVeZNwOBJ5O+RnGst7v3zXQAPwUZDweuD4gePof6Y
	 lUmBQwnhKOxYQ==
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 24 Feb 2026 11:26:32 +0100
Subject: [PATCH] fork: zero vmap stack using clear_pages() instead of
 memset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MOQqAQAxA0atIagMaN/QqYhHGqMGVDIgweHcHy
 1f8H8CLqXjokgAmt3o9j4g8TcAtfMyCOkYDZVRnRCXuO06nreg2YcOLZ/HI0riKxpy4LSCWl8m
 kz3/th/f9AFfW8mhlAAAA
X-Change-ID: 20260224-mm-fork-clear-pages-ae7c52d12a93
To: Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Mateusz Guzik <mjguzik@gmail.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Linus Walleij <linusw@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 62306140003
X-Stat-Signature: frjam9ap1k5emtssagyzmfcst5zmtcon
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771928821-166627
X-HE-Meta: U2FsdGVkX19lXNGjMzDvc6eH7OnzGQd9KY9+A9jki0fKb9vYyNRkHwzs82D450qVcClddliAVTO27L1bFgp0mXjcrcsAZZbdSAx9y63n+Ew8FU/xVa0ZV4B6VwKs3v0jh/3cLdcxDodZ1se2McvPGvPsTnMC96ZHZTRxp+LEarHbNWgNyb2A+IZq7JKnBjZc8CtJUI+ye5iR65XJUfDosU+OkjoX4Min5zk6SvT1F2ggPnl4Lqa2mXqjF/LQScvjkxzIJDvi9E7UY4/uznvhvRScYopFXVxizZUMp/pQGDES3Y4WPXqxv2sT/Y+V5OZHEYC+002qOba9nkqMbC/hGFlD5XAPbDtmg217rNy4+DvZg6bOGlOLNEkTgASEVolq/6HasMglutRnLeMPQuCuPE3gsvO6zW8BUjJl+apfid0dXPwx1fFki55duLxRbSq5TMzchWEYblv0l5YK2ar40YJV8TI5Xvic4gHKpxLhdRry7oW1cNAPaY4Zn4ymT/URtZnjKTj8X2iDL2PTv6Rcadk55sLCH0kDsB7crgdeDI2aGLeJmG2+28eS51reL4rpLdtt27M8VEn29GAQoB3pedgCNWTTd5diMtyj3FNEd8XtcqYtsIuB7iJOARpnd8Zmh6fnXBs28fEglHOoUXaNaJhGUMUh+DB03G7RPi7c/wg/pHr+RZFwkkgTQST01C6sFsf7sJGEYyh0Sw478V91cXABsa3VOelW3Ac2mB65Kd51d2US/NXE1JYiakizTy68nHDh6e4MzDHRrEnvtch/ITNFNBax1bPk9bu6XSwhyXEm8drGB9JlNaay8v9Y1uhuDCIr6Ys/tFMQ/mGh1U2XngJdyTzKi7lGRED6SfZ+hKJu84EqCzJ4fo5k0zZOaENcp+7IJZK1ME95ZKugQt2H/nfn3cDOC45dZ1V/TtL5afsR404eVdKCa+veyJ1BMUFWdvtgCG9Mcn0q6hqWZmS
 PANX2Eal
 F/NMqoMUzN8vx5/dstpGS7lsyoEoxgzZIIHF/tRrux1otfSVRyT4SHF+R2k6CNQFYoXaMu/3EQz2MZXF0rQ+7u4fzxKqaa7rYgJhjnNIWbtEuAx+puCM8vYh9wwPeTqyeJ3PXAqqRmr/Knm5y/pxe76Sj46TASlJzxM9qYHvUGtEVf8imUpxTpGLh0QygbX2+ZhMiAc18GcosKTqkT8+9Vhjrf8DBk4GnY6jfE2KYIpSvcfvBYkbnV+dmdKcdOT0/HydJOUVIMkQXhywY1+kMQfe5GBho8HmYbnt8g17ETTpVvFkKAAE+ItfI3sEQcfrwfGOUKCngSqxrRLVtLZ/JBPl+yZrquUG0dEfqu+no5IQxWuEbq/04acV5eJjNrmIcffQI/3iWizQefRP1NNS6H2amjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After the introduction of clear_pages() we exploit the
fact that the process vm_area is allocated in contiguous
pages to just clear them all in one swift operation.

Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/linux-mm/dpnwsp7dl4535rd7qmszanw6u5an2p74uxfex4dh53frpb7pu3@2bnjjavjrepe/
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-7-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linusw@kernel.org>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index e832da9d15a4..88d78ccef245 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -345,7 +345,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		stack = kasan_reset_tag(vm_area->addr);
 
 		/* Clear stale pointers from reused stack. */
-		memset(stack, 0, THREAD_SIZE);
+		clear_pages(vm_area->addr, vm_area->nr_pages);
 
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;

---
base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
change-id: 20260224-mm-fork-clear-pages-ae7c52d12a93

Best regards,
-- 
Linus Walleij <linusw@kernel.org>


