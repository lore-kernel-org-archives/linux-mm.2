Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1444CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 16:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D9A8E0013; Tue, 19 Aug 2025 12:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5818E0005; Tue, 19 Aug 2025 12:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B6B8E0013; Tue, 19 Aug 2025 12:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5AED08E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:11:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15111136DFD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:11:51 +0000 (UTC)
X-FDA: 83793998022.03.F219F86
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 335672000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:11:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cVtR1lwR;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755619909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/3a3Z3L0HEIC3vaPkLm4MfWk/+SLSX3X+v7+5Ljf+M=;
	b=dKdXVJYpSvp9pOUcrxKCsyZDN59IQJ2OKzPX1C4TuAnSFIWpwFtWZDdK669JmJH1h78VqX
	bQMokfhi/5NrOrXdehaHtQ4zbUzZvyiXeVijMDaMF+8TMc5C3tn5mc19lKqT3qn0NBugcR
	KSBqNLABVQICAMz2f8bFXHvOXupqF4Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cVtR1lwR;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755619909; a=rsa-sha256;
	cv=none;
	b=oeIFGcg604lluERUq2A2FIqhvmJzi6EcE34FwlnftIyO+kzL4X4K+wTkoKKdOl07ZaBV1r
	0+bXP9wxSuvQCVWpcaWi/Oq33fKKz79k66bJEfZ5lWJBFPJ+Bw0TIJs4I8kzCu0qdG5EC1
	7TWm44P66YqPMV0iNxbGugyOXvCtcHg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755619908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f/3a3Z3L0HEIC3vaPkLm4MfWk/+SLSX3X+v7+5Ljf+M=;
	b=cVtR1lwRH3eIV92qnDRh7IryrhxRUi+YO89S+m0+2XntOmJVjmadyxXZOpLt5tg4sUjSVs
	bp/pg82BDuw630MnXK0wFeVB/AuYgNtZUwjsIj5EnlmTKZtYPArRiOYKQGqjYpUjwCDgxY
	TdaGxmfSStY6jepjcTm9rtNyk6UWo4A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-tSTadv3EM7ahhzm854JzNA-1; Tue,
 19 Aug 2025 12:11:44 -0400
X-MC-Unique: tSTadv3EM7ahhzm854JzNA-1
X-Mimecast-MFC-AGG-ID: tSTadv3EM7ahhzm854JzNA_1755619902
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B112C19775B0;
	Tue, 19 Aug 2025 16:11:40 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.95])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D73F5180047F;
	Tue, 19 Aug 2025 16:11:33 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 19 Aug 2025 18:10:22 +0200 (CEST)
Date: Tue, 19 Aug 2025 18:10:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dominique Martinet <asmadeus@codewreck.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	syzbot <syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, dvyukov@google.com,
	elver@google.com, glider@google.com, jack@suse.cz,
	kasan-dev@googlegroups.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
	willy@infradead.org, v9fs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Subject: [PATCH] 9p/trans_fd: p9_fd_request: kick rx thread if EPOLLIN
Message-ID: <20250819161013.GB11345@redhat.com>
References: <68a2de8f.050a0220.e29e5.0097.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a2de8f.050a0220.e29e5.0097.GAE@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 335672000D
X-Stat-Signature: 154qsqe454uij7jwuichcmsx8zfdeao1
X-Rspam-User: 
X-HE-Tag: 1755619909-897035
X-HE-Meta: U2FsdGVkX1/0vaMaB3S/NfvpuaImE6/jwQsa6Z9D1efPXYvHPBCw327B9bnyEhgL83WtVTUcagjKIt1droDZsb2Gky1HeUOYHfGU7dkoI+Q6HC2VkY7iMtw9wD4WQtlw4CV8qvxB4cANEp/lMh5dsdeEBlQIJiLHGWgmYsrMchYBBBUFwzIfytZQVPEGP0LrAjklx1sGMuu0Ysonb7nyUTwxeN3xyg31SVHptMMDt8x02QDF+73QzmxOFuhdyVrhwRpP7D/e4wV3P7eTFopDNIp31PyPJlI+LQZjBufL6feZUQADyC8O7U6L2ijxM7TS9noobCyLZa62HouaMNEud0gTBxJccMjcwtNwnrl1LWWKtaxcgtK4UUQgpADk0IObqtV5PcG/1GAQ2he9uo4g0XFLXYHuBBUGe204YmYZJou6sVGrb+IB740FgJ5f8q3yQO8J32F+ZtdNbcZgJDTrE/Z1u0B9cySOwBCx/U88gUqc9FqyYL0I/qZTvvYSHLa5sI6LQ0OBsd3iixDx7fDtLJ7+c65x8BSrJHgfcWMutk3xFZ4X4y5wbOWs6OoosdgbBL+bUIa4rb89Ps5kuvj48yVRNiel39qeNSNOVT+Xf35DZl9B/qdprTZUplhmomoi00WdAfYcy6z9BEkIoPAq//+RLh02XQ7dnuYv5AkMvOrqsXUaL9F3KT8pt7FMjDX02HThjv35QjlesBTJaPw5alYc4IIPrh4H7d1j8hYVfksOWmNT+1C7wms4yKAWXLgrZTnJVQsyve+m2eEktlJHtrSuEKrYmtJgcd7P5qegf+MVV3Vri7S6OBHCi84C1YH7DPvgyJ5ZO24b9FMhc+olFOzYfPNGWQIfk+99e2JPmlh3S0ZGmxvVUMe0HWM5PQzp013qqb0172ZalIv4FEXBx/6gYoy3KanUHu/0Pp+mlwi0qr+CURrMHe/T8NVE8wMK1p4UBXWzPJLxrUVYu+f
 njI3Ue1V
 g8bj0VsRV25iFHyrYg5hk8xQrgzz4X48P2Cma0AUMmXwlvkCXJVyMZYZ5tDjJ7ApN3uWLvhhHYmTIslKxe41s+HkW+Xa0OP30FLdphYtLG7kTUI0EERyzn3htOl6LVVFvlFEw6sGQMx0q94xvUAhZC3MVURrMR+80GQDEacTMd+tcHWbi48XSwnPi9+Zl0TJyWMfmlisrdOa0RkHRbxIDg21jUyWrpxbmxn+LrkDvV/ZQ9NpLHSmFnn30xMb8bGaq6JMfsyAWjPXJ4asgl3i/KSHxkmAIpeaQXcHQmAs9rTJqBYMaUpKzF40elefQfE1DsCUPvOyoGLqhP3ucPqLJp8J8t213qSpH+81Ac5vRDgowFAgXjMH4dxl19ov2m9AWiVzanxOsbzmIRPV8klUSx8I7BRWzrAnzSe3ddF+flezAHPse2W7Axs5IEx2FG5p5tOOic7ZfuRqAjHQ8NYMB3Lzt+OEsUiusgOLcxjZVUSJ+AZ3ctTImEqOVUHKY0WIiiwWL9Cl42eIKaIVCALRoTc9NglLGaUpYta7oa15QXulOf9REN9IkbyEWdCmXhgJ1tnQCX9/YeSyMZL2rzBIe3vJkp/uVjVS7JT9+7uXx0nnp8B4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

p9_read_work() doesn't set Rworksched and doesn't do schedule_work(m->rq)
if list_empty(&m->req_list).

However, if the pipe is full, we need to read more data and this used to
work prior to commit aaec5a95d59615 ("pipe_read: don't wake up the writer
if the pipe is still full").

p9_read_work() does p9_fd_read() -> ... -> anon_pipe_read() which (before
the commit above) triggered the unnecessary wakeup. This wakeup calls
p9_pollwake() which kicks p9_poll_workfn() -> p9_poll_mux(), p9_poll_mux()
will notice EPOLLIN and schedule_work(&m->rq).

This no longer happens after the optimization above, change p9_fd_request()
to use p9_poll_mux() instead of only checking for EPOLLOUT.

Reported-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
Tested-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68a2de8f.050a0220.e29e5.0097.GAE@google.com/
Link: https://lore.kernel.org/all/67dedd2f.050a0220.31a16b.003f.GAE@google.com/
Co-developed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 net/9p/trans_fd.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

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
-- 
2.25.1.362.g51ebf55



