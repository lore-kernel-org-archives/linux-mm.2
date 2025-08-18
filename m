Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87772CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD3A6B00B8; Mon, 18 Aug 2025 08:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FBE8E0043; Mon, 18 Aug 2025 08:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDFD48E000D; Mon, 18 Aug 2025 08:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0AC96B00B8
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:58:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4645F138F57
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:58:05 +0000 (UTC)
X-FDA: 83789880930.16.DE7C676
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 513DA80010
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:58:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gcy8JlzU;
	spf=pass (imf30.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755521883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyzL3GSkiAQfeG6g6YvIMRozhZr0+dfb72trcSazY0Y=;
	b=5ydgiE+7wPu7zkIvg+dztSFcHL0ExkbnskH5mKLqGF1P38HR7YtqizWC8kjNwV+7A3nr31
	0TLmZRUEUINfpdc7TyRRt9lqaTQ9MR03e2SrQhq2zf7jvtUeW2Huj2rgMGY25mihIf7r8Z
	W98smh67sBATqV6M4V/7UqpWg7XPZ2k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gcy8JlzU;
	spf=pass (imf30.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755521883; a=rsa-sha256;
	cv=none;
	b=dpsEMlWOZ7H4oW+vlZqAw1Ln5Zn97L2a6/WXsxpUbxh2TgVOd4UOzl/MCopYv1c8NenWyJ
	1Cml/ng+Zhl/O7dhsOmmUSchYd4NFbJRK0mxsy/YA4qVF0rHdsoSRmBlfy+XTSbybCS/TH
	N556TDezw5qZqqTPq1aeJrUS0e/fSOU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755521882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QyzL3GSkiAQfeG6g6YvIMRozhZr0+dfb72trcSazY0Y=;
	b=gcy8JlzUKImnzwjFGUEg6rKMy8YD8k2iFbh06Iryo8bnTU0qY2bO+fnyr8R3klpfT8t08q
	Gd0JyIR9ZNSvRoODbWl0aSeyzQy9pm6tmaxarLfOERPfCq9CSGOh5rySJW6j+Tq/CfYMkX
	GWEMXxMj7YdaZHqaVj+SkLFqAn7w5kE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-g_mIRCGpMROsggNnLgJ-Wg-1; Mon,
 18 Aug 2025 08:57:59 -0400
X-MC-Unique: g_mIRCGpMROsggNnLgJ-Wg-1
X-Mimecast-MFC-AGG-ID: g_mIRCGpMROsggNnLgJ-Wg_1755521876
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3B3018002C2;
	Mon, 18 Aug 2025 12:57:50 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.44.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 4136D1955F24;
	Mon, 18 Aug 2025 12:57:43 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 18 Aug 2025 14:56:33 +0200 (CEST)
Date: Mon, 18 Aug 2025 14:56:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: syzbot <syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com>,
	David Howells <dhowells@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, dvyukov@google.com,
	elver@google.com, glider@google.com, jack@suse.cz,
	kasan-dev@googlegroups.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [syzbot] [fs?] [mm?] INFO: task hung in v9fs_file_fsync
Message-ID: <20250818125625.GC18626@redhat.com>
References: <20250818114404.GA18626@redhat.com>
 <68a31e33.050a0220.e29e5.00a6.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a31e33.050a0220.e29e5.00a6.GAE@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 513DA80010
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: scrpoy118ntiiu8dniqkbyhonhjs1xfp
X-HE-Tag: 1755521883-692370
X-HE-Meta: U2FsdGVkX190Si8og+gCHvuRfOFqJgjGeT9HAmpOg67KludABRDX4lesdYpLjzzQcPPyJZk8f5R7mw5QNF5O/irXB2JbeJcuQ5Vjv/JC52VllPtTZqEWNj91Bejq2Mug2skMiZ89u9vCSFc0zef1/Uewpf9dyWv6hV+y5NFIrQSLdZrK1tJMabszegcqehD0kppJHSpoyKuNFY73vEXZK36wuZ3uvG9XE6TSY3dS3QX6t1HSK0bT/VAnxVSdCZilF5cY83u/v8pJ3Zcyvt18y2eBV5Uf8fJW8RWuPdglUR9tbeMcWl+1diO8yB/7U1h5xLEGO0htKZb+XgiuuTIXqpjehAB6yxE0dX+/iVCtjCSQ7F5erZciMMr654Mtij8XwnARE3EkGxGw7tzqOSdfTYhcPxk/xpa75sdA3M0hURQCGJL4oInOVRcF5J2ZAHx9Ie0+GAnI80LfoCqxTj/NuLUFB/f8s6OIujWXpHIJsc2/r6O8p3BjBzDGWy9j2pS5RJTSrwEx4fLHAcr8DNa03A3360IFoNirlynnkLbDSYwcD1mdm6XPFgPUfmIMJ7TJ6yTTNMP3qtyh+XqOTw1GflF9/N/9T8Y6fs+wbrdyF0iucaXLG7Uyom25YszCUu6e3qv/tIiQUh4CjfnXq9c7t+qpn16aqjr7PMUzAW8kEKiU4rbqHh0652x/wgXBLYlTMZt5JoFpUqbv0HSys4MCC7QC/hWeWcO6q6m23b6mBwt01dJoMMIMXVn/XED6E0TuVUPnU9lAyrZpG099GDf6gJjhcmyyJkv7t36iOV5RU/INsQex9tT+LtqwgJnVKGJMvYhfUhj5ckME8Lb21QQztA68CNiof2YKUV5qgDHmUYVo8pGFiT+Bmdq59fUfJeLWjds7oS8z9Cd5ki1iakMLbVspqN0yz0F9O/mJwkwvmgMIJ3JVNK18lscydpK1gy/4nE+1WJnECv0QqyqdrNW
 6qH2VWwM
 H/d42ICBCbQE7TIA+U4q+znFKrSH4ulonbaNx15MFZgmQaBYGHs8V8IFqLKfGRGgQxz9O8/9KLvXjfBPLybPPjINJ5fEjnErcTmUv/dnQI6hx2/fi5yhrPmIM8ZkvKahdUK1KDtxTizr6ahWwY+0iQK+6if8b3paGJikPPt8ml/CCPuYKs6n8ALA3G2QqVBXnLas0eBQiJrbE7X3OrfFxFHFisjMgD0rwsmCgSWf7rmL7uYfmaDwpOx7jZXGzIcWFUR0K3KEJLYrkwfjBWJUWyDVyvUk/FQexX+ZthJcLTlZNOMzTJD06V24JV8PvsL88Y1K8OjbeSRbypS0J8jrNTeBG6rrpeu/oMRDmG/Fgt6J2slSSzgkT062XLYpVU+vR0gCq1EdyYGG8029R5yAOKNxQ+vLX9RXki2iZInNQp6e3kWkwHl2l92l/xsLSjJSplUQO8J5yp+4uZjy0z1+Z9RrYbXxODwBs2eE5S3irrfjnSa8y7kCEJxfi6zgmbNAGKmLWINDDiThgE6wES/dySvFIBo4soPIEcAhhyNUv6aNILH1/04A3U90W+kj85+zsewU4NsSsN4uO/TsDwUA+Xy/CBTHMZS4KjqHYzPUA5WNrTeY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/18, syzbot wrote:
>
> Hello,
>
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>
> Reported-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
> Tested-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
>
> Tested on:
>
> commit:         038d61fd Linux 6.16

And trans_fd.c wasn't changed since 038d61fd...

Dominique, David,

Perhaps you can reconsider the fix that Prateek and I tried to propose
in this thread

	[syzbot] [netfs?] INFO: task hung in netfs_unbuffered_write_iter
	https://lore.kernel.org/all/67dedd2f.050a0220.31a16b.003f.GAE@google.com/

Oleg.
---

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 339ec4e54778..474fe67f72ac 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -666,7 +666,6 @@ static void p9_poll_mux(struct p9_conn *m)
 
 static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 {
-	__poll_t n;
 	int err;
 	struct p9_trans_fd *ts = client->trans;
 	struct p9_conn *m = &ts->conn;
@@ -686,13 +685,7 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 	list_add_tail(&req->req_list, &m->unsent_req_list);
 	spin_unlock(&m->req_lock);
 
-	if (test_and_clear_bit(Wpending, &m->wsched))
-		n = EPOLLOUT;
-	else
-		n = p9_fd_poll(m->client, NULL, NULL);
-
-	if (n & EPOLLOUT && !test_and_set_bit(Wworksched, &m->wsched))
-		schedule_work(&m->wq);
+	p9_poll_mux(m);
 
 	return 0;
 }


