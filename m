Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88212CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033C96B00D4; Mon, 18 Aug 2025 09:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26366B00D5; Mon, 18 Aug 2025 09:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15636B00D6; Mon, 18 Aug 2025 09:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE56D6B00D4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:06:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BAE25BB99
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:06:00 +0000 (UTC)
X-FDA: 83789900880.07.6ABD78E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D9D5140010
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:05:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=evxV2HZP;
	spf=pass (imf09.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755522358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyzL3GSkiAQfeG6g6YvIMRozhZr0+dfb72trcSazY0Y=;
	b=eeEb8qmTJyCXj928GsBeUaSkesd5ZVqAqzg1mDuEBUVsQKU2dGg3pcIhyKklZrYiC8ojY0
	WUaUqnjmY4kA1tUUWW6KHsLH8sBAXQ4ue4oZCibFaz4rPjDy8n4e4n+8ZztCKoJ7AgX13r
	UCbc6pwaMDcLnXbVhWFClHSKtGA71bo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=evxV2HZP;
	spf=pass (imf09.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755522358; a=rsa-sha256;
	cv=none;
	b=Hr9Fh+x9x8chLe5iyjn+Pi7a5sQ9Bdhaj0as8qrczYMSXGwVSTs2xDcBd3Gru0ziy6JdT1
	dkOfioxsnx+9sWjvTxW4FgHuWIGSuLjytEuPqEkT3XpS9Zp5LEzw2f++0hckegCtqxcVnQ
	0rHEf/3/X+2w9BncxKA+04S3UOKZTJM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755522358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QyzL3GSkiAQfeG6g6YvIMRozhZr0+dfb72trcSazY0Y=;
	b=evxV2HZPCsCVpZxhMpMMII3W+XuzbmPhX7kCYWCGxq21nQB7LRicZg9H4UELWpw5WvmRxC
	IXHPxMJOejfJ4fQIz4jb9qwM68ER/9Ca/OVZUy5C7cBeh0fa5PKwQh2lz/etYEauOVoDOU
	QdK79me15YaaM/Gxwk24TAl8WqHFs5A=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-284-XlWK2UtwMF-ScKJ_-M8afQ-1; Mon,
 18 Aug 2025 09:05:53 -0400
X-MC-Unique: XlWK2UtwMF-ScKJ_-M8afQ-1
X-Mimecast-MFC-AGG-ID: XlWK2UtwMF-ScKJ_-M8afQ_1755522351
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5711A19560AE;
	Mon, 18 Aug 2025 13:05:45 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.44.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5D9E6195419F;
	Mon, 18 Aug 2025 13:05:38 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 18 Aug 2025 15:04:28 +0200 (CEST)
Date: Mon, 18 Aug 2025 15:04:20 +0200
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
	willy@infradead.org, Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>, v9fs@lists.linux.dev
Subject: Re: [syzbot] [fs?] [mm?] INFO: task hung in v9fs_file_fsync
Message-ID: <20250818130419.GD18626@redhat.com>
References: <20250818114404.GA18626@redhat.com>
 <68a31e33.050a0220.e29e5.00a6.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a31e33.050a0220.e29e5.00a6.GAE@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D9D5140010
X-Stat-Signature: aor9com5dpohqwq9b6aq6ui4rtnj4j5m
X-Rspam-User: 
X-HE-Tag: 1755522358-122788
X-HE-Meta: U2FsdGVkX19Qzdr2sKfC5XwtATMk5P98hgMwi8UMZxNlxXd67jYO/1brC8T/QPZ+xAlAKJEZW/d87XBl8xvvJCxbUsfJ2ptCw0z8B9fzT/gD4YL8UUU6P+OmnKaoQp1v8nIEJWgj8uRR6rbUR2nS3vie59WUGmUijoO4tYxW8C/7g6ofvOBIGHMC6LGVbMh55mUiFDKCNf5cpTwunxqvlUqybsS/u9L69+ExSKcSE97Eje7Te5TySdPfJLu3jPTM5ioXEj4pqysqhUqA5O7uCfS4PepLwx5ibymKSB8UgheCElFKoQtwR0L8Anof86MY8c0WMdy8cgtoP2TRJ2TcqrxYhEOrNREKhK2tlQdkO7pW15K/8qsJOIG71L5qMwVYrpOmDz2kLW7D23L8vI5WOovyfanZp+wvFqyEvHKEBCa0WDgdhwd9caZRuJaf6tZOTHogO4Pa5YZS4FH/sAoOyjEbiVTha+PFl/fccaalPYWmxHigmIy2m0HTILo6SxGPL+6opYqhfGgbhJBx5NQEFC/FmpyymK0ObWCq9Lx2uRPu7NA3MspAWANqW+IflV0r+9/Ps/kGV4ZD6dwCgWRvnSAhbfSGoV0dkBJRuOzV34MtCDhu3RSrsybzSBKVwsJfEmK1WdsFZKAtn1WMUzvktC8v1XFWmZZllgy5ovGtysJKR0Dkt0l+bAlUy8EW9AssXdv2/cNQ4KrswNK+RfhC8Zf1BdWT1qy1ogOUCgvaaPPeW5315XUiHkTLlVRi1Os661lfAu1N6b/Va6Bz8H/Os7dkfEvqEyore2jRxaLgVZRQ+LtvgdjCs3OB+RNwwcd+Y4QAa/eROP+xOxLk8ssHseZT3cC7YWx046Wv+Sh0e8PUjntyNdrHbnC4CAwsxefuQnNVjhHEAy0SVKrXYD2DjouvnrTGA1fEBe2U00LZri5NVHyO+2XTcex3ac4jTL7aXNQjQTwknh3/GEkQnc8
 2mg432Kq
 rbqc+NYhQ4lrR6qUNgJQlgYXSHuxpvZYoN9m7h+kYBYRQCwKl8u90A8Bo3HxtUxXvpRl7CZyl8jmn6ffASx1TpRNe6fvz9JoyqGwz9wc7oMU2Zkps5vTxKYmZ+UwSjEG5kvWmoqSQjAwkckF/C7JbA9wqz0VH3f4F47aRGSr6nxdB/1DcnC+iRIE5DjwcLdmEn5XC8jTITahH4pnRjqDVmAWQ2A==
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


