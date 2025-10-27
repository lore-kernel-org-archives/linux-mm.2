Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D370CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706BC800BE; Mon, 27 Oct 2025 19:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6D48009B; Mon, 27 Oct 2025 19:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F425800BE; Mon, 27 Oct 2025 19:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 517C08009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:23:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2BB913A3DC
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:23:13 +0000 (UTC)
X-FDA: 84045472266.02.1E3EF20
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 40CC01C000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:23:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lkPPVpm+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2kGxV06HfpxcpPiUPTzmwiOkPAgJASkvhN4/4SyEC0=;
	b=gv2a3Hi1NIqUPoVe77hQcMsxdQRZQt8zOmSV6yHfXuktOTgl8pieNa/xGfkrOR3RSTz1Yw
	PR8cWHsGgDJvO74cAzj2r+uyaS81kChhzEcjh/VbaZbFwY30SXxJ664KF8YLPmfQH+zumM
	sjLvebFx8t2clcR8jOzcQ9pK2cKyg8Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607392; a=rsa-sha256;
	cv=none;
	b=4jAfsdQOwUKZBUjZ8arbB18VOZS3EeU3fu/Hr51Ezzo01AtbElb42J3VMeGOvbACIfQqYg
	LutO05KC8UX3nmR8UHmngnYRutu3do5VMTGK5lD2OQCcRD+0WP1Vk+g30XyZ5/vsAP6y7A
	X/zfj41XaE9yTodzcDlvREPPjxvLW4E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lkPPVpm+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a2kGxV06HfpxcpPiUPTzmwiOkPAgJASkvhN4/4SyEC0=;
	b=lkPPVpm+fnPC+unyLNVdYESh1AWhGBETU6J5rz5lYfNm22BM8j6bPfNZmg02w4elxICR0n
	S7H1oC2dJuR60zhzC0B9AEfHrBwhnVD0n10MQRTRVy7hXbK3vwU8LhRtK3YjmIdbu9Udvc
	NT6/mKoIvYG4SIBTftkywZcMHKcY83Q=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 22/23] bpf: selftests: add config for psi
Date: Mon, 27 Oct 2025 16:22:05 -0700
Message-ID: <20251027232206.473085-12-roman.gushchin@linux.dev>
In-Reply-To: <20251027232206.473085-1-roman.gushchin@linux.dev>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: 4gn11843skms4oswsor89zuij64hukc8
X-Rspam-User: 
X-Rspamd-Queue-Id: 40CC01C000A
X-HE-Tag: 1761607392-868054
X-HE-Meta: U2FsdGVkX193ylyNeyH6cgmh5XumHCmuxojz8IYmfbGRi3f6+gxblxvRtvq2J9HQc9MoZcotczlsZbFZdUhf7FGvJi9lGMfLxyimfW+mO7fTZX/zm+D7dXttrhaAjPPL1c5lWDzd8WPKHKhGuIDN7dIowjhC76lP7jnha2ONRZ7+x7K/1xRvrLuILp+AoWGkAPCERgsMRUDVrDRb3nTuvPEB5h+vLU0WC/C1P+NqVfXjp9+VKp0r7dhLVuHuEsl+acYarYqL5iLy4Ublb50APcb/8BUk6lBM1CLKVc9IvwYLa74Ihb0ju0mWnsgqCQGKitFN+1QAHxfKJgkYKnG/fB3iXrdCoyPf0DBe1cYnCKWfAsJ7v7nZUwx4OrFjQ55wNtDtFP8KsiQgVRo7BY9FptTsPYJimAbECXt9M71jppug7fvx51ValBuJCmUOGvYBaDUvV1qbtUsbTLg3adtWYpMgxjEfLpGK21JEkREI252+h6gBV4IQuK72zXMX/MRfn4flhuSiIOzEmVNmc58amUZ5mOth1OAyU3vnU3ZaPa73G4L8vDas7VjvECaYb2/mvNiIzaWWOkHc8EhYKr/IBYRmLiCM36vN/UKQmPJG/BtfC1Olve/efo7uZhFsKPTUomxB8lXwIhSB79zy30X5LGYwcsKy1XOTWOhfKBKTnpmyFR99tZe1I7PbFxfY6qVmFTdMLSf7/PAdxRvZkog1QAuGdRZl5q3hZnqflJb2Jed8lCtMS3ddgIwqPVD14RZOoXF93PYg06iP55LH64X07Bls4qn5iB4wXp/edeVAdQ9QgL1yGhXHmyD6DlLpTkvj+/Em1WOyxf+4D/Wz40mc5fn7Wmvvmm68kyBoxZocmDrqlVLSfvN5JFRAW2kKKqvsRkrX2csqLuhtycL8JV5cYjmJHmkNupJaHEdH/GloftMQm8t2ffbcLs7ukBVfLsz8Vmy/SJKvZZ1uU8d/vam
 kOA8f48n
 lLu2Y853GoUhpKvCv5YT80s/j1bRVb1BrBS/uX4ugF36CFbvdaQztnSvGCaf5+sMDAndeQkDY+CKf8t/g6RdWDJilGJ+55ENXD7T9PjToBLlGbQbKHS60eu0mVtV7g4rLv7Yy/3Ua8YHamXeYJOv0QGz5HVlnQs4a9htP6ttcdrOwsibIw8IaTTIQp9O9YLC2nJoPd0NapE8Q25XadFJzAiP09TEUlOP4L1RXyMPpfW5AlycAzAoNgDaFXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: JP Kobryn <inwardvessel@gmail.com>

Include CONFIG_PSI to allow dependent tests to build.

Suggested-by: Song Liu <song@kernel.org>
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 70b28c1e653e..178c840c844b 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -110,6 +110,7 @@ CONFIG_IP6_NF_IPTABLES=y
 CONFIG_IP6_NF_FILTER=y
 CONFIG_NF_NAT=y
 CONFIG_PACKET=y
+CONFIG_PSI=y
 CONFIG_RC_CORE=y
 CONFIG_SECURITY=y
 CONFIG_SECURITYFS=y
-- 
2.51.0


