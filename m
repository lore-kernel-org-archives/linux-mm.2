Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E090CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA09D8E0088; Mon, 13 Oct 2025 16:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50BD8E0036; Mon, 13 Oct 2025 16:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C666E8E0088; Mon, 13 Oct 2025 16:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5B7F8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:35:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B1E61405D4
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:44 +0000 (UTC)
X-FDA: 83994247008.18.A962A8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D867420007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hwx+RCh+;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2RaB4lHHhlKa+8v8iZE0Fllt8dt+Sn1Sj5thp5J+H4=;
	b=YMoorRUWNGh6gWN9zoRFEe5GY80lpcBjAAIdKT3cJjJ52VB1raZbLuy8tyg40xPJHp4+uT
	GzdW0XVNFF39Zk4X6jSF4svx2XPEkjBwl++LgJNsWnusTKgqvpS1b5scJaDqMeX6wuTSF2
	DwCRYZ4DqmArKupKfem/g/iIlF2y0YQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hwx+RCh+;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387743; a=rsa-sha256;
	cv=none;
	b=eYZJd3E/zH4L8prA5ZSGtau9F1XCZCSL3whpD63ZEZNqWj9Nssr9tnn/+WkIyoMb81pJxc
	bm8CBH1GvMTLK+g33mE8P9ZlNr0xEpbLYxCOHDC6Ko5JkQqaGDgO5lUmx112kHlFNkKpKA
	cg/lV8paFzDKWhwUn33OFpaQKFF4hnw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5AE44374F;
	Mon, 13 Oct 2025 20:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858D8C4CEE7;
	Mon, 13 Oct 2025 20:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387741;
	bh=n52cAu7bEMYLK1x1CARbNE9gVHxK/1DrMBlj3TyiG6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hwx+RCh+ZncRTZW4J3H101zxwGK2eXC7I/AqUiWKIv2Duuwwy39jB7rQi4ZnPKStV
	 AbZRbdrU5REoIKByt/LVOaIEFYsTkgcDK/rQsCPMoITkhkdZg7ALJytPyN7MOI1vc+
	 RT2iSlPvYNcvFM6/vFKmR2bKzL+SNzPQURqdZYp7huxAcjMbS59DbwOQUz7/bpVVj0
	 HlKhsXGjIBcqreM/spUfVwgtUf7zzM7ao5qVaRVLlRlbKWfKCo1/4m/YIzCT1UeKOQ
	 h3AAzzYPrXCd+VjamYW07Z5gyLAAw3SuDh1Wkx20np8piV10n7YbOohjL426Rqpvuk
	 +nJqSOrG0UW6A==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 29/33] kthread: Comment on the purpose and placement of kthread_affine_node() call
Date: Mon, 13 Oct 2025 22:31:42 +0200
Message-ID: <20251013203146.10162-30-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D867420007
X-Stat-Signature: 33hm3e1h1kxwzgqm9jk5fnm61iohgt65
X-Rspam-User: 
X-HE-Tag: 1760387742-668283
X-HE-Meta: U2FsdGVkX1//YPN6Ofdqbr9VBPS40Ym0So5lgRDINSAy4G6O3h3P1275+W9WJqATpcKW/9X3CdcXzFl+5slt/16IvVcbnKuiMFzWkvxLmKjcT/SEAn/0P/xsQAWHZPkUBLzM26QZZHtv8ZFvpy8bmWwCxXyLwK4d54kVXGkYxrQT4y0juJc78w35cgZfhU60b6T528zv/RGUwC+JaMIkPmVOX3zfls9idvGAZS8m6PSMUOSk4NPZThn574ehMv5KgyGfhPyo54q6dNRtMDvkV0NmlaezcpIoz6ySzzEwlpb5yXtanR5UgBjlxXyzAcQenX4nCD+enTNo4aeSeyc6kfOuA8CwiKEQ7OKZCvJxIF4F+YprIXOSMt1lXS5zjd4QSepgysJ3DRuS17lMGQsz3kxC6OEySRjtAWM2lZqgKU4g0nKeJC3szE0Kicqk4xA6Z07YBxj/HrgYRFBsqOtvE1emoT2q/MYZLbDtDcTpcEcgz06lbfRkbEFAHGxaePiNK0fplPRLdpSz8wy59OxP3qoR4X/T5M0QleLrSuK6TQpIS8GdOm6po/UGQ5FsPBAYCZoihOntGPOU+MYX/k9Mgm1liZAVIVNGcvgFcXaIjy1S+MRszmfvlcBkAzoBeD7y+bh5MVBHLC0vxQq3dd2+4/cRi8jDHlId/BpnZ6g4+8k3mOCrEEmLcicDKVGJqoa8002UywmiSNy416azCEg+aHz1Ti3QZmeSAgPAGbEHJ3yATVfMKeFMnt+cJPf0THK1t/3tASFHMKXBgTRkc/fY74KlBA8mtL+Zs+9AwcVQ0HInmHP4ett379rFQxU+tCasBxEIwGppu9/eoo/SXCKgJMkZH0F51n7kndZg6XdELHF7tp9K0+ziv2AXSk6kDKlV0dkDOWO8+jxpUqB8HhwNjjvN3Iieeo9sXPrqY2ml4ChoCuEqfnd1VkVWjdne5vlhEzhxGgwWVI4ABm2QUeD
 DKwUWn3f
 uOtRioGf9VBB+p8rKH4fMrG08NCUS5tt1a8frE5E7kjyU1chuMC08SqKAQ5gV8kJhuBvAmDGs65nTxpJf2OKr2tLVQkUFcoLd8haj6OJkgO8Zq+VNows7590fUGyk85fYPedK4PoQKg9Hpu7WgjCFkWA06g8xykRyWTfVQssbJ7UwotLysjgSp8bebr8mFW1DjhMQYHRpOnaZd1dp0H7ySnYwbAk7R7IRzIejpxvHWZWTqDt+RO6TCIVfE75zM+H5NjsWSc8GILu8iKLvYe++bedW/5K7+9RpRM5s4kLwmWPJav7TqObbd+H01cLMUHtLEhkenmbA7BmImk7yeyei/+NOvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It may not appear obvious why kthread_affine_node() is not called before
the kthread creation completion instead of after the first wake-up.

The reason is that kthread_affine_node() applies a default affinity
behaviour that only takes place if no affinity preference have already
been passed by the kthread creation call site.

Add a comment to clarify that.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 4d3cc04e5e8b..d36bdfbd004e 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -453,6 +453,10 @@ static int kthread(void *_create)
 
 	self->started = 1;
 
+	/*
+	 * Apply default node affinity if no call to kthread_bind[_mask]() nor
+	 * kthread_affine_preferred() was issued before the first wake-up.
+	 */
 	if (!(current->flags & PF_NO_SETAFFINITY) && !self->preferred_affinity)
 		kthread_affine_node();
 
-- 
2.51.0


