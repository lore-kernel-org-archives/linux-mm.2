Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35338CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC5D6B0088; Mon, 28 Sep 2026 21:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ADA96B0096; Mon, 28 Sep 2026 21:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C896B0098; Mon, 28 Sep 2026 21:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0506F6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:46:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C112403A2
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:46:48 +0000 (UTC)
X-FDA: 85265110896.22.56B61A1
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf26.hostedemail.com (Postfix) with ESMTP id BBD84140003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:46:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=sGKnxiV+;
	spf=pass (imf26.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790646406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lBeqk7ZMmYqADn0KlVVkmHsuUwcWw3h8t4K/mjrNiE=;
	b=bEwf3IgQtsIB3GJjVQHiXiIPn3/BvX83r8G7WcM0XsIz6Ik/Eauz9hnEnQkLUn5/BcJear
	xbT+UstrMMPZhbJPWlfbQVFzSvPN8JBxhCh37HLYEYR3jZ96miymh1vkf7PBncKF0W+O3/
	LhTZYQisdDeS3zkzLDmSgHrEiN1B80M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=sGKnxiV+;
	spf=pass (imf26.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790646406;
	b=AE9/qdgZg5nxCteK3dI4sn89AxucjFjtS3OFZ7XocguPaNVcxe4sOUpPfI12n9pbq2PzrG
	WjWCPB7amhHufagIL18HbA29Vuj4JKoYS2bKaus/LiD7xsLQmNkYp3nWkgvk87wxWuvK5A
	XzEdYcd8qW5BGABCimjNJnKpETwGK18=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1790646405;
	bh=6lBeqk7ZMmYqADn0KlVVkmHsuUwcWw3h8t4K/mjrNiE=;
	b=sGKnxiV+okdIXSvB4OVyd6pGI5U0olcLWwzMYSyWq4Dax/C+GYGqOy5xd8N/QsYXghC0
	DvKhPBwVwRvXTMzgIoDMnn4U4708DFo/VDTGWWk7IELDliFp/5Tji8LZcJASC8lcrux7ha
	GHiwcNY1Lddv06tXXuAipQEUuGipZs9AbGyCQGFVqzDMBQ9hepc3trP63V6zpX30idhrck
	rQgkphQnSTLcU+TvEnusPzk/yOw8nBWUsqvvSHascg5PS6ipE0y/4wrOq6V+pS0PEURU81
	ITdXOFPzeFiju0YQgaCmhx1ZTQN+nB+iUzXRua+pJECTK8mHHV6gWBCyqOTu/NZQ==
Received: by recvd-57cdcfbc54-tb8pr with SMTP id recvd-57cdcfbc54-tb8pr-1-6ABB1885-11
	2026-09-29 01:46:45.321909534 +0000 UTC m=+366573.172150114
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-17 (SG)
	with ESMTP
	id -xay3FoUR3mtoIteZJGP0A
	Tue, 29 Sep 2026 01:46:45.196 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v2] writeback: let foreign flushes reach dying cgwbs
Date: Tue, 29 Sep 2026 01:46:45 +0000 (UTC)
Message-ID: <20260929014644.1573035-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6d0542fc07639c8df7672b12f4ecd906@kernel.org>
References: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io> <6d0542fc07639c8df7672b12f4ecd906@kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmef9V6iSK9oEL?=
 =?us-ascii?Q?O5dVfUwdZ72bnTq17N=2FPD+RpYmsb=2F1PAS5DkU=2Fa?=
 =?us-ascii?Q?EPirahDBNlWLukVeitbIFb7+FF9QlAKGVgYrkbB?=
 =?us-ascii?Q?CuZjeJcWMTcrbKcEo2EGUDWCq7T5SCbYYQt3Lgb?=
 =?us-ascii?Q?tusLVq0P=2FPEce+rQOIbBXqgaOjVGnr1DgPi6k+J?= =?us-ascii?Q?JMzn?=
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christian Brauner
	<brauner@kernel.org>, Jan Kara <jack@suse.cz>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BBD84140003
X-Rspam-User: 
X-Stat-Signature: qketfmfttpk39srwbbpggtyreoofieoj
X-HE-Tag: 1790646406-364400
X-HE-Meta: U2FsdGVkX1+8dabJmtrdMuBe3Q3h8bAjBW+LxDSunCUsMCEpn07G4d3O1tLeBz0MApSrWMmL8KnhXTVXLjIr6hmJ7vIbZOK9O5p2w8sNpn+ZFPRsr8x4JAHucPst8MtOL3qQ7d+5lD9NLssct3mb/y0cWk0nYGkZ+DO2s6gACBFAmLlsJg9fHSS4RBJBt5+MJUsCNy3ICDp3W/Gb6acHOa71uqX82cWuTPY1lhka64XSBlo0zmbKOV62d6lxNSVPOUHnnaO1qkuq49ELe/vzDMLWK6wZz3BBp4th/JJ3+x7PzBqyj6gr+UABJAt63dlBL0qhPkApluVZfAlzlmC++p+FoI300TYW9YxjNf4abr+j5p1Q32Dph2dMJ7g8xqk3jUyXxYrn6+b5l5vLl+l4xevJ8KpEF/gs1qzwrWY9CJnLiPCYEXtJyfwO71s9M6p3XYZpNGs0Efq1+R6IL5VVdCjQ7Jxs1roQ88h3kI5P4EIGR/pfQbuemHkde3bkqP5IOQAjb6QoF00wgZDNPXjk3u8i/1rYeP6b94aAmU7Z8u1H1HdPRCfEkCgukZlsfo2zFwu2pv9q/DtifWOyfs8IKaqEOtoWojStTaRsmJicLn0SFaiEx0sdnsenzbAB9kkSukbtVGCLwu4CekUXXa4pidxz9nXV5zeTMs3zQ0P8TJWnK+0EK5cz/mm7t6FRjsX1czl1J7VWu0khquyVw2xjvgcUrj+IYkinveNHn22tC7cNDoRltqTWNFsP60ZjQ3WSP7ko3QLJ70oED1rxJsrQFeLz+TctXBpyj1+/c3nKH8BTpZqjqpu5KjGjDcBv6vva0Vj1b+JMMVUC/vlbirmX2jiNkle6DHihLJBUwkMghPSCJt1HBAUetkWnR4xmFiSkT1h62bCe5+bx8lY8j7GIyuWMxx1xJdLLcaTEWIl0SIeJCbTTbgTSlcYM3OUuxA8A6o1xqGiJuyoF319W/Y+
 RBdZY4lm
 SfWobz/iw1Kx/4RbqnNZIPvt7d7k5NGNs/nU/Mc84F2rMNDkr65VRxzCe2k8lJIxDlxZn++wa5qPMSWf1iGWczMdETb0wjFJ/C48+Tt24j+wamatscL7PupPFeHUVIMuGA6XA5R/7rVrCzCXJrE+0ykSg8nd60TGU1qHsvf8RIMN9HHHI9TMeSvbFlbqEeimo2B9WrQqQHNgOR2cgPXXJ14nHIjoppmSA6gobFQ0HY2+uF/iOuZbfsj47CEvGRL78uMcyOd4Q+qUDtbv1nJOpLfNa5ic5pUrPqYW9/BNjBRZV2n3B3ZeaQd/H6phpQmiEQRaTk5n/sMs+2H3LQej8oZ4n3iQAootk8ImDKVGm7orUo2r+ty3d0toBuEE3BEd+dUpknEvCxZ5m2teuJLz9wDG9vz1s7YDsxy8C37N6+Kc3UpjvTJrX/dN3FSmCZJDhFGttVLusNPLHigV0BiNF9RFEQg9/4RQPgqJXgQ6nVEQvYczKONgEaKHioBZCzAiRUEtuem+zG2rASbKcsj+aFU7JaZCiJOQoIZqp8Itn6jdaI0cCUvEZde46Nq/8OxK7rw9n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tejun,

Thank you for your patience with this. It's only my second upstream
contribution to the Linux kernel, and I needed the guidance on how you
handle shared data structures and locking and how you preferred to
resolve this issue.

All addressed in v3:
https://lore.kernel.org/all/20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io/

The writeback kick is patch 2. cgwb_create() can run with interrupts
disabled (folio_account_dirtied() -> inode_attach_wb()), so it kicks
the replaced wb after dropping cgwb_lock and makes wb_wakeup()
irq-safe. The cover letter has a test of that case and a question
about the part the kick doesn't cover.

Thanks,
Liz

