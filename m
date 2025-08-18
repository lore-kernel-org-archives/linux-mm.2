Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F35BCA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 11:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD058E0030; Mon, 18 Aug 2025 07:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94508E0003; Mon, 18 Aug 2025 07:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1938E0030; Mon, 18 Aug 2025 07:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C64458E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:45:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 317A61408DA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:45:38 +0000 (UTC)
X-FDA: 83789698356.20.86834A6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 024DA180013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:45:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Clt/vjFH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755517536; a=rsa-sha256;
	cv=none;
	b=1xnHnOsRyOYIkC2AEdYfVDRcVjpId0plAa3Nx5LOAGiy/f52ZInn7wVk72+pMCtQ/qvbnD
	Hy0v1LwprCxXkE+JzU3lBIvUxaceJWS7s1H8ejXMWwQMzMu/eCSRvEW+pvEsy2gllo3Obu
	QhSIySyFFaafix/PPEbNK4f06RPJOWU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Clt/vjFH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755517536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fu4mWedunRpepQK4vPdF43r3Z2WEFaYWndiALSzs5Lw=;
	b=wrr6Mip1JgNLF0BOMpM51fFRkidXof7Ey7EiSzg05fb5HEPeYt48C6Q9AnhExaZoB8i5/l
	ZHq3ZVLcADTSAyRNdolTsbWTBKVR+bApTMPPiJGrL9ha1Bqb6zKDI9ogd84J2QUjwaNv+e
	WPR3tgzgfwOLQYYYhmFneXcZwDa46ck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755517534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fu4mWedunRpepQK4vPdF43r3Z2WEFaYWndiALSzs5Lw=;
	b=Clt/vjFHKw/NooW81DcAGvlp4S/VvxE62xU3W1riqSl7mIVpNZUCvBmU7UjdxKVtWCYEwd
	H7PXAQzb01kNBo0STcMzkggxod789LxH92Kv3qmwPVDYrl/ZN5CmLWLSour2oFHC29LfGE
	Y51a/g5Q9bf5g+tpaH2UIcrTSjXPLe8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-GUL-TeqQNc2gGJcAky-ovg-1; Mon,
 18 Aug 2025 07:45:31 -0400
X-MC-Unique: GUL-TeqQNc2gGJcAky-ovg-1
X-Mimecast-MFC-AGG-ID: GUL-TeqQNc2gGJcAky-ovg_1755517529
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9ADC3180044F;
	Mon, 18 Aug 2025 11:45:28 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.44.34.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 48FE7180028E;
	Mon, 18 Aug 2025 11:45:22 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 18 Aug 2025 13:44:11 +0200 (CEST)
Date: Mon, 18 Aug 2025 13:44:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: syzbot <syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, dvyukov@google.com,
	elver@google.com, glider@google.com, jack@suse.cz,
	kasan-dev@googlegroups.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [syzbot] [fs?] [mm?] INFO: task hung in v9fs_file_fsync
Message-ID: <20250818114404.GA18626@redhat.com>
References: <68a2de8f.050a0220.e29e5.0097.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a2de8f.050a0220.e29e5.0097.GAE@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 024DA180013
X-Stat-Signature: m915nmszko9deya58mrjzzxsznydmujh
X-HE-Tag: 1755517535-521351
X-HE-Meta: U2FsdGVkX1+X65KKOARo+n+vfvLvSb0Z8mw2VxS1/klXY40BuC0+Owwu6GF2qNwNtPPbxdnCjiOtEKTm0brqK3/73xtpozgmy5UYe/l2Ak12YVLtnclJA6PEjptW9wK+zRV0pYwz6P9Hkx38EPp6BgnBD/SDnVJQVq6AQX0Anwoz7JtK2VcQisOkv4aj2hrW8aHiuuviHk/k8+OFedALFVWbPp5VK+GdixqdhMMZ85CYtlNV6zpzYw3x1ffrDqIfaVu1fbrcwuGYQiDEoVFyGK9aUoXHda0wSzRDQizRsDo+AMBLSWnnPfOfH6aXMP0t3x8Q/8ok0U9mZ8I63MYEMLW5TXqBtKEJyXSEGDkoZJ5vFW52Wt6n/Fbz9hFoTSsWKzlVcPxH9z2wDb9kZuYaY0IY89U/rxih14wrbUb2XZndEKh7hFy54JHBLQRVA3TtgrLBESC5xEJ8H1anKoS8TQ7ALyCSVTPt+T2+RrCTtDhvOd/SjE/NCp0IM2L9GLx3NDZqEMUNQJsHfNa4sUZKgNINngK+nyV7pM04Vg3WNIERI9Tg+SiGnc9ptjFBisL3C4JiT7Slgxd1TlfT60TWxbWP6UXpP9zjhSF4uKk87pbluwMppRWAfnZkzEUF8+dXIIG3iUutgx0jCRT5f7pQ320fttQPafKsz7/M/swS97NebQNLTwRVzPKVf7lNJgcJAJEkfRhFlUEtkUnUdQUCcTQRfCHwZc9JrNhPg4TkMB/T6DC7Ls+XpaTUdzx3HBVBLrkz8cvNcoeesAQv28u0/GdF5q2mkUnmF13lYGkl1qo+j+bMRAQCXyjN7xttWneIwFzEDx0o0QEbIIMXdvoDffMi2vtAiqlK6psdQ2/kz2bwt8Qrk0BqPwuym2g6cnVtaP6p9R7nEJJ4ZpnvJArwtzI/X4ndGzo5d4F9WJqr4cfn4u0Pk7700nz/r07xE1YrTTZzg3t9Q9Ab/gK2jWR
 YLIp7CUF
 qbaW04ytuh4yHXdX+zdjWttYZ3l+vpXykqpPwZmu+nnQ6ejAaH7DhAcw7YZUZMlUYcs/ynfiV4wY9jn/ZAsNFo87W3K0YsxpcK7Th7mwOXgCe/GA3Mi8ChFAVWVRcgaGatY2vHg+ylEDH/K+3TOX8UmlSBTwyRnzC7GRmi//Q/ZLqD+7uLS1ZxFibZj6cK924FN3CwphycTDYajdY1RrlDqXoJb6Oe+HdEVtGYEnqIYq0vqluKRVi5X6K8V0ljM+kbQIoRwTrCIJ4kalglqgEaewNgZbo44U9EoKYc3hRB2Dr20N76QrMuJ3OO7sp0saSOHswBZasfVFqmLq93y94+YMKnOdGX5pVK92eCT7NgL/XNaqTR/L+0hKhlO5PuBIcAwmiq3m+OwGvqXyhoa5O5gcuBCA18HUfZcdfilAEDczZPL3SVZrxPAk6W7TtiMnlIxQ1DGJCN7ABH1kSTsJvU4NfU6iaQRQ7x/WdXlSAQzLRbpdkuqvGtRqRW9/oMzOwo3Zs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/18, syzbot wrote:
>
> HEAD commit:    038d61fd6422 Linux 6.16

#syz test: upstream 038d61fd6422

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


