Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4C060A2601
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aE7K5lkT
Received: by kanga.kvack.org (Postfix)
	id 01E526B05B5; Fri, 20 Nov 2026 08:42:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38E56B05B6; Fri, 20 Nov 2026 08:42:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75366B05B7; Fri, 20 Nov 2026 08:42:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6A9A6B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:42:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF743160988
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:32 +0000 (UTC)
X-FDA: 85455612144.14.8D6ED79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 04D64160005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aE7K5lkT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182151;
	b=4MG1fh7uHYbihGp8kGjgaYsRJWewPCxqDBXPR6x4Ug/nFYJKwxD8b1+tcLJJDSy0ra2RBh
	8hOgDY3Ur7i35vEOx+9ttOCosuxBqukhskITCQA3EvPd9xGYg2u59vke3RdILwj2ZtIHwg
	eo7R4gskoYguLdImLvTDTC2CrEAfCE8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PxknjzXyKlIZbBI8K2Iy/IF94QOe7DF6NOjeL9QzLkc=;
	b=ex1Nl/8AMIPfIhsJkTWGUueWSyT46Qb/TEUHJhBexJpookyt6dwtMAogkaJfeXSd+efqcW
	pFZoYD8TOjZ+4X6nCJ6GGarsTBMViy4eSJiuQIHyTIjLBNlWsAKysrwsw5XrBrJ2V+Ei/+
	i0HOun8KPyk+SS8KZQm8N/Nlr9jalJc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aE7K5lkT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42F2260F89;
	Fri, 20 Nov 2026 13:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6545C1F000C0;
	Fri, 20 Nov 2026 13:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182149;
	bh=PxknjzXyKlIZbBI8K2Iy/IF94QOe7DF6NOjeL9QzLkc=;
	h=From:Subject:Date:To:Cc;
	b=aE7K5lkTR4egrzTaxc5ukEBMPXht8pKpIjSsNFY4eWV3ZaAzQHqS9nFg5eau1aT4S
	 HTF5bcFYvtEhabzME3ixN1AUu3F3rJR6cFOsM6qIONmCH2z43SZB9/iWVFu6Yc1uNL
	 9ucX6qweiQzi2NyXbEir3ti801+p/gnpyS7ekr/AtCKD25FStr0KjeHMfCM5imLwM4
	 cuYPXlSGvSMUPu/e+Te1QwMZirfJbPQqmEQlYcVD5Sgsy6F4MYLpoAF5AQzET8EFTl
	 SmeVLdGPa5o0sImRMPoEUygkADzh0Es3ZPWlMRegTSBhhH39/LtsvxUqhoEb3Nqi/v
	 TMJRSzvjdrfMQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/3] pidfd: use one helper for pid namespace visibility
 checks
Date: Fri, 20 Nov 2026 14:42:08 +0100
Message-Id: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMUQrCMBBEr1L22y1NjLZ4FRFpko1dlbRktQqld
 zepPwNvmHkLCCUmgVO1QKKZhceYQe0qcEMfb4TsM4Nu9FEp3eBnTA+c2AdfMsq1fOyTUHXOGBX
 0vu0M5PuUKPB3U58vf5a3vZN7FV9Z2F4IbeqjG0o1B8G2PtSbHNb1B17xI1icAAAA
X-Change-ID: 20261120-work-pidfd-pidns_visible-18c441f23784
To: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jiwoo Kim <arpe1618@gmail.com>, Chen Linxuan <me@black-desk.cn>, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=1564; i=brauner@kernel.org;
 h=from:subject:message-id; bh=avi2yEAxjJ5v1EMR55Cx9mpcbWIvVTDxij2cio+1u1k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQz+Nm8vD1f553U9adnDUXYOatWae9mYMvcm2DvrZl56
 Pr+iz+tOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZScYzhf3DB3/Ljf700GXu3
 MMQ9sZDQ9Zt05Jro/bD2iVIZRjd+aTL8j3vAEsQ72+rF2S1qBYYND2V/xLYyFzpekd8zgaU+erU
 4IwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9ouxgrehbtqw9pme449nq73wfenuo6c7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04D64160005
X-HE-Tag: 1795182150-920889
X-HE-Meta: U2FsdGVkX186NaIVxpFQ108VlaP2obx2XLO3NS0XrKGNZ4le9M85wiWE3FJIr5pr6kQPemTs3LRwYO/HbySYxM4cN6V8S3TwoEHlXfSI8DMj86/kHi4l18tlS6Tja+XwzA5130RnjNEKp/oys3ih4s33X/NLKvPAaiGKsGBOJngpZ0TKtTtJF/8Zyhz/3gh7Pb8f0W2Ih+MqIv7f7PKqC/WAXnlW60cXlqAyhz+/PtCEhm+z41+vfcvLHctc0p7FP/UbNidFBJiw8ZCxU3bvt3cF5M9CP7BumhBfU6pS/x1rOYcBFSeyFcBc0q4xA0trXm31qk1i8hgs9LhgyXH6RrH3lCosZtpNrstN4XySxmvXoXxqZ3b3e8q6gb/zmGsM0tYIqg9RRszOkQVHDooKH7Re9EnH2BcaHlIbwlKthphk5yPiBAt3wpWyt7nVMYh+K6yR0jTrKIxy3Q347pRF+NTH4xmbR5dPKWNo4UhBMrZ0NoUVVDNzKRoKuZ5a1HAbvTpA7BbMhidr/sxWuseTxtkm2Zo6ySPnKJOAo4VpJz7q1cPI11sjEmfMBf82SKtW8fnP/Jc7KM3Rc6f2rjDLnjkvQ78a4ATXDZC/hdeGWn7PZojEjRpHKRwy3lpx2U949C1UUG3AgSNIC3IIiiAVC79eYLY4Yf9E6xbgVAcNLHSD6f3TUo/wqYz+Fm61UC/x/RHPhlSaUnukMOgIFfLzW+4wGEQMOk+AtYaZPSemXLhRir4+ZTaJT7bIvoX/wnvInJeNdsakUANOXAtgZfzjLN/QZu+YpN9cR4+STs7xXVap8mNqqgFJakG5WHYsk/6GqQ/Mobl9oqVppprAL4kC4JtCziSh4VamFzVg27mP2IX49tNxRSquYJp+Ek3OVsNK5HPVYIWpYgIfkSYMPUIeuvueW1VmEr5u4UIgVo4qPUS6l11gii5hsq/hEt0d9be+H1nNLQOOYLGnYb6oZcP
 svcFjvBy
 jStjeyf8jk0JB1hZy16TNL+cJVB5Fy6hlr4L8pjaMwvzRw/Q6YIxMUC2wby2PFdxJU14M1qJClHQj96yiwkbd0TRb/NohW3xYQdTc0tWCgOySRuUcboZkLqUknvtvchZPYRUWZbCmHLnCN3Gw/POxepyhtZs2GH5m/tevbr/k0OY9BzOzwAvtD3T6pw1eakv07vZmELI8y+4GWaD/UTQ50Oc5PGdX/J0yMfQ7/EBv5z6c3A8qDWFE4b7hmUQV1tUx3pB/2QTM3mPqlRIGEREnLN3WUb7KvnptAthTIrarPgbvqd5b1RZL+oY1UUIvVpQfeaBwavFClgwl5OFV4culNE91fV/l2F4UDTssrDQqo9YbRf+6KCa8DeNaHVUhVm9ld7nlScqxlpHzV+5qjRZeRSk7Gz7kQYnO4Gtzb4TdkrmMM1viXC9yNjwpMLv5+n1/6wKBKWqNhFu9yRDGXzvod+2EFwn3+9LebSEiF/au6zV1p6OWmiCHDHVka88h8yz2ZktSFKgfwpV4+FwPZIArFBWRd8f2LlkrhxTQR34PH0mM1jkBrGaIuoqNN/97VwsT89Dd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The pidfd api checks in a bunch of places whether the target of a pidfd
is visible in the caller's pid namespace. pidfs has
pid_in_current_pidns() for PIDFD_GET_INFO and the namespace and task
path ioctls. The pidfs file handle lookup open-codes pid_vnr() and
pidfd_getfd() does the same since Jiwoo's fix [1]. pidfd_send_signal()
walks the pid namespace hierarchy in its own access_pidfd_pidns().
Yuck, unify it.

The rule is the one we settled on a while ago [2]: anything that hands
out resources of the target requires the target to be visible in the
caller's pid namespace. That doesn't turn pid namespaces into a security
boundary. It just means a pidfd doesn't get you more than you could get
by naming the process yourself.

[1]: https://patch.msgid.link/20261117152332.1221-1-arpe1618@gmail.com
[2]: https://lore.kernel.org/all/20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (3):
      pid: move pid_in_current_pidns() into kernel/pid.c
      pidfd: convert remaining visibility checks to pid_in_current_pidns()
      pidfd: restrict pidfd_get_task() to the caller's pid namespace

 fs/pidfs.c          | 12 +-----------
 include/linux/pid.h |  1 +
 kernel/pid.c        | 31 +++++++++++++++++++++++++++++--
 kernel/signal.c     | 23 +----------------------
 4 files changed, 32 insertions(+), 35 deletions(-)
---
base-commit: 0a5864ad213c9fb2cf627a2dcd6f448a1fb7e065
change-id: 20261120-work-pidfd-pidns_visible-18c441f23784


