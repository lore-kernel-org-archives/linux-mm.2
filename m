Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE24F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m2Y1P68o
Received: by kanga.kvack.org (Postfix)
	id 1EE2B6B05CA; Tue, 17 Nov 2026 00:09:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19ECD6B05CC; Tue, 17 Nov 2026 00:09:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5266B05CD; Tue, 17 Nov 2026 00:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C51AA6B05CA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:09:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CD8C1402F2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:42 +0000 (UTC)
X-FDA: 85443433404.15.79BDAF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BC667C0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2Y1P68o;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892180;
	b=FxG7Idx1XZwd1shW5eL4pnTJGTc46L01+PZh5QiGRnCBXHY9/msCsBaDsGKoyxDlM3AmeX
	yZzUMD18NjGVsPCI1fJaCCYFq1FYagqUwZDrRgzFLLCb4p36+T9Av/+x0FCuCUkhYOfH6H
	qMQKQH9uyvmK4WGThTWDMtHqPHdT8ZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBuq7agc2LJ6hWE7imheP/OC6f3LlJfwcnXlMy2Xfu8=;
	b=NT30KrSRy1PIKNe9a6VdVsokD7KLoEbiQ3ct46S9lWfs3U7uenYVgLa4zIp5UfRQE732dC
	EW//apkjdvL+Vnpa/nMqe9vqCsZq9Ookk0Rth36WohSTFOWvS+aQCAFMvs8Iv8U/Wk7hFV
	g+ouKOiA9cUS25MCBTtgZ6AlgAc8bkY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2Y1P68o;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 3A2DA43AC6;
	Tue, 17 Nov 2026 05:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6AEF51F000C9;
	Tue, 17 Nov 2026 05:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892180;
	bh=sBuq7agc2LJ6hWE7imheP/OC6f3LlJfwcnXlMy2Xfu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2Y1P68oF3q8KRZXuY1dLQyCw7Xuffv8OmSRl/XRANK/TJRucEcvKZ7ML40C9WIT0
	 2QSfuZcJpGeTlHq+kA/FndpXIuAZ4/3IXJ8L4y/OEa7LznWrwu48E9xD0mykdM9fFO
	 tDPfqB26b7brXwbYtUkwUSptl5IZRMT3T2K5LcWWhbIiGUgWlt80bOOqg+3i4AaMHT
	 UD9v8ntxI8rcuw6SzeqpkMe2yhb3NtfpAVtK73/KsvfyLGBqCC5hZBuk5nU7J23Ca0
	 ZTLJ06fyDF7PqeD6U5CQnM7LbniWVBmO6Pr5VN367BVf723Hm2KNrL10kIac9yrhZA
	 1QYYVTl3wgyRA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 13/13] MAINTAINERS: Add entry for ROOT NAMESPACE
Date: Tue, 17 Nov 2026 07:08:41 +0200
Message-ID: <20261117050841.3289652-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BC667C0003
X-Rspam-User:
X-Stat-Signature: kh4g3nzs3wuqs3s68wddza7gmriymn65
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794892180-492473
X-HE-Meta: U2FsdGVkX1+A58876cixcd4D/e5oHUPL//q0xYVMNKKhGAI67CVZT6v2jmUyuQOVC/dy5fqeGNJPPmhs/VDKvy4K352b/Ul5EDjU6OiwMB+XqwguWgDfVydqW/JGGSE1NSyaHkIhmYF7dUL7KfdAHo7Br+YzZfHXLSZ83lo4bM4a6FTxDzR423Mgjp8B7OazljvV8zryrFZMcw1S+y2xS0V7lZz+XQ/pScYlxZ+ZoR6Lb3RJMSfwnbb9glrXCZ5V/iNScfBa3KvIZG0ii2mzgvXdcfepeYr9XWEph6QxgPRC1oKXhYUnH6+xzi3uSqUnyOcCxZPi3QLVkR8wyvBtgdf0WPV8qn1mgYGr5+ve89l10btlGxIXoNSVM4AwBYqTtO9xNOQZr9vxfgtOwBhQiroQuaVzaD4HYjXZoLDcg5bY9JuD04AsAKSUlMMycahhMxoriI7fLNavUuCWy8VVVJdNJzSwWnXZmBkldV2e8rWNzomkTvOxkStPdkVoFw8IB71zFM7e2RyhCBtOAiTmqDZNU/tUm7YdaDBeZhOE67KS1+GsMCwBNHn6cw/YSSangjoRcsbBOBIcuZpfhU7jP2Soajde2GZvIXYpZjfnNdHJKfwfxWdfLxWIALnt36IMYsBctwBxBR+hZyZtdypB4J4ugulIZJHCKinjOv6S3/4Fx1BcQzDha+VDRnA7tYzN/z9qR7o0+/o5TzbLTtC62ndedEUNsklnrNgRBXgNXpHNu/lJlb/EuUBDSn3guYkGpEyoIrqlXUaI3cHzXJp5Lr6JD1Ruk6W7uyJSjHk8tHjUHrbV+yvL60YE5R+kjpSEoELidjqrxIU0JWw9Eg3yZ6vAKfHKsne7iN7S02WcCS2SR1pUelgL5QhZ9lH4C3TS0dCe3eP4q76DynFyyQE54vZPq8b7zBzhbTQYnTaSKqdx+Pq+qNxIPTWwXh4tmGWUbV5ibas3tdt9o0u72FB
 j/MTw/EN
 EqmCC/s7LEL/6cbpQU4z7j56tZ43MHO+HsKI43i88fX6Cg+WsL4HfR2ZNeIQSqiDYoAcYSZ2TprPnFD45f4yYBCzOMZCETCwkM6bWrgWRuqEvpBsvi4jEslNDIRbApodUNTzxytqt+XyIGV7YhRd8iod786JsITZCArrakmy8Mu+wXJll30KDxoMvS11YUG/+4uy6zDvqIr0+Km9xOZ2FJg/eLxF2HQFpi8JpE+vHvVZ3Lxdn3akjDKjp6l9WzVvSYr79ZLPPS/a5lwWkheBIf++n0DMEwJ5GIwWzIdyKZkTAkijk62Q1Y6ncOttIE8b9JEPQZwITe4qaoaCHbglPqsVdPmCujYYbMqHw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Record maintainership and mailing list routing for the root namespace
subsystem across its uAPI headers, core implementation, documentation,
and selftests.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e7753a54125..1019266bc077 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24534,6 +24534,17 @@ F:	include/linux/mfd/rohm-bd96802.h
 F:	include/linux/mfd/rohm-generic.h
 F:	include/linux/mfd/rohm-shared.h
 
+ROOT NAMESPACE
+M:	David Howells <dhowells@redhat.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	Documentation/userspace-api/rootns.rst
+F:	include/linux/rootns.h
+F:	include/uapi/linux/rootns.h
+F:	kernel/rootns.c
+F:	tools/testing/selftests/rootns/
+
 ROTATION DRIVER FOR ALLWINNER A83T
 M:	Jernej Skrabec <jernej.skrabec@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
2.47.3


