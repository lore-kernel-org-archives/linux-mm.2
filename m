Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CDA606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=vAKfrI77
Received: by kanga.kvack.org (Postfix)
	id E72F56B05B2; Fri,  6 Nov 2026 07:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29436B05B4; Fri,  6 Nov 2026 07:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74A06B05B6; Fri,  6 Nov 2026 07:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A68E76B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:28:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 47EF380D1E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:28:01 +0000 (UTC)
X-FDA: 85404621162.19.D806E26
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7295580002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:27:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vAKfrI77;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxg9YZCEig6aUovfMW9LERszjpC/Bi2+TpPnGTSoQi8=;
	b=yjS9rqmP8SLy1TSdQGszDDhB53eHd6tNfxRYvQRLR+rEHU9BAqiPNsw7061cGS3gfvE/g0
	P/KflswXNHb4X1TptCd3ziksFT6PL3NM2HYXQZeplulSMuystUl2+cFD5xdN+77cMOiuV3
	AK2dENIHxV0HPgTlWZZYyeNMQAgiGUo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968079;
	b=wYf3c85q3kldYc3TxahjzZ76A8ow6jPX+iKCfCSvVMa/U8zb20gbL0CrHzpFaTIdbLv/9B
	c3ikZqwnOCz6wu1hZcAdrhyvwXPoFbf28XSZQb97YPFeKuEY221E0r/k7mOUp0+Z5G2Y6n
	8TUPM2GA990ppZXoWXv0cpujf7eDjQY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vAKfrI77;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=jxg9YZCEig6aUovfMW9LERszjpC/Bi2+TpPnGTSoQi8=; b=vAKfrI77DsSLod+Uczrvqv0Tjm
	ULrjeHLN2Rut6XqF70F/+op1bDdDobytns5RumRz1iCQtdGynoyR9fEa0SwQv6YpKI3SC8ykaUgY0
	i/SWyGlqVkJ82lNhPWpd5emu+d8doJhm52qVWwqwPkOYijL9rLtf0ZHHkvWfBV55sJvtw9oSMrAcX
	Rtumffo1xchJf9z5Nh0Ss8d9fZ/Z2vBLbPOKULbbkIjM/mgkT8VSEgE9LtRU+FZP8uSpX5JuCjQwi
	jDC0KLUFA3h4s32VBKUrZVWcjW9Xm9be30Kv0pm+ik9KStMV3cJOIUkesKqNHuFr+1cvcdm6HUCxR
	9x7JgBMQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2i-009HTo-2N;
	Fri, 06 Nov 2026 12:27:40 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Nov 2026 04:26:31 -0800
Subject: [PATCH 1/4] writeback: add the missing newline to the slow
 writeback report
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-writeback_stall_report-v1-1-bf0c3b9023a5@debian.org>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
In-Reply-To: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1200; i=leitao@debian.org;
 h=from:subject:message-id; bh=hXkUpm8Ppkso7pz3WNB+6bMAnx3JDLSgoZdBoLm0PN0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexSsgObTcm99v2R6oLzUKT4iRNgAWjgc1wj
 fhbzzMWk4aJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 bakDD/9OwZnPzwEaVdOCOEdmjSKRtZ3e3IIMxvSigJAkuxtCwyzcXS0/DwG/czZOVV0qUdveZs1
 13hwg4K5H65DpmE5q65wdYsoBQTaaYML5y4m+wgJLeBgAWF9lPikmN5lK5BbFDRPsoxJK7zOR97
 CH9UzLEICJChYXSSEKZUO+JTsFpHoJ/ZqLB65xjW14vnQioYxDjfQXcDguoe/H5hHKzp7i3Y91x
 4jrdnA4AytGZRHzLYFZUsSbufyR49hLdd0jZ39cum0od09Clc5rU6kBTqC49ew9Pcxe9924vrya
 4ONFnDU70eSshiysy7FDIOYE53Jy/liUfU+HXGGjk+SyKC3hJmJCCpzY0fyVefXTronP3feUbgf
 DMKOJg82Fnmy4jaLsc0UcajiWoXjEG9Vd3T9zUaoeqS0jHWDhhqstaSvraMdIQv+rEfULG5gWaa
 BCP3bJujtqpJof0ZMTbAuXcEcCf61lJlDmlCNgramOPSwxPETG5XbpyCEmXIMPGFToT13MbsXDQ
 w4gXLXe+kpiPQI2ODrOoTqlbikoAQ5Tns/dr2lAIb00cHHRuTYszNX0v9PFVCFmcPqbW7jYJx8r
 G/TsCjvSmEkAQLO8nP8wTDiY5OkUHoG2/lq4njN+OJD6l1fiYjNL7s1/VfTxh86INnx8pOusu15
 /ZmM5yj+D7ZKFYg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: cqodegs5yboxjtaxif3nw31ceiuxu7ie
X-Rspamd-Queue-Id: 7295580002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793968079-927066
X-HE-Meta: U2FsdGVkX1/L/jNyIVD8Lyve5JfMjSgIxmTcdwfRSc1Yvgu94+R26TobZjQUmevhEbFyL4qwsEaC4l/+azPnXxdmaQcHpV8r6k2jEevwvZ1SolDu/dTxHFNjoyH++EXPzDC5dF0sl3kvvaASWM+hguxLzlfs1QVdZQB17GwcAH7yNfKbPYytbpNPV72//QnEDc5wxi3DxYsX6mly+GeYV90mf2tJtyCjXDewu4K/EIfP1f+d8/cVG7c6ei5H3rXGOqZcZ3mJb1z25tNZ0cQKB8M1h36h1EhdnogwjQeE9Z6hUAgUJ8ib4vVwyK573bGL/N8MATZ/zDsP5kYBIBlskZOg3fWViyb355hd7KJyucAxbj8JIbpWZPDw385eROy5X2Qo3E4AHr9ikz5NKIft0q20LkyJfCvPKakjKDq9D9N8ltqDO5A42LO+xnei68KsUUxvFiB8nvUUxTQLEap+/k0VK2zuAmvuQJdFDwzQKJtRUG6fvKqirsnYwq+ADHFPRj53HgSrTypOhougiVFVD9m/zKGtFXzMVst2w6Qk5JCulhJXqLJG5vyQ+xxJ59vYUK47xJL7W1javMtM5flcgyOJnD+kbflV2LBTzE7T1FVA6J+70S+zDxuCvnTpxEGbygVvxJ3ZcZS7ahV7Aa6ZEIrHzj6An8vXGHPnpPdU//3SnKfiLtYVCbDUavZrpD3wycUi3fmHZUpnLqAsjSTCY1HjrAiCqgYGLFLs8ov6AoWANK2w+HhKIeORt/yAxXqaXqCs+Lp0AKjFGUL3YOxuaiUC+LX4Jt3E3X6OY7YehXd9YxejcTMAts/pdM7Z7PflCo2gvhw5BP9zbUqZ+3M8qIJd9DqkkzryWCsaIog2XUcOhFiARMPPVJzSfCJNbjBcaZ12a6aYtOyksC2rFiDP9ZdM7L1DAqwowngt3F3JmU51lZXn3EsRAjT7ogc0LCBRqttSFnyv4yggz2//Zz6
 MBJkB1iy
 TAufV3u7y9O9vzQNlNU+kn3ZJr2APU8E3KqvzeuNobs6qAoe2DktzVIGJcQaC/+n5v741eL2FzI7rYME1x70U3lBVj4wWeWZZWvMCMuF+JbOai9XPkea0jaf1h2fjFomAPMLiWLKq2Fe3+xoRvDpg7nYqsK6eJKcAisVeN6fUTd80zbntSvVU6QaT4BBnFpiDwB3ydK9hqL2gYM01C0tmhUdUqy7IyhigMECRup45eoMXkOU+RSJPQJ4KDgku8m0jgD2aSecUWt4yX2wxnWgqp+WU7/ZL09MxoO/Ip4x7FULLCZykuArWHcBzaw==
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


