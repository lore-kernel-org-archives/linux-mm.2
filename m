Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF08CE7B1B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC8F8E001A; Fri, 14 Nov 2025 10:03:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C40E8E0002; Fri, 14 Nov 2025 10:03:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA738E001A; Fri, 14 Nov 2025 10:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3868E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:03:33 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFED087E68
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:32 +0000 (UTC)
X-FDA: 84109531464.26.1DA537C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D24F140013
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ELclghTz;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0yyCaz4IBzCuynoK7eJFq8qb8jjHV9aZwpbdt5Xpuk=;
	b=dH9djfx7PRw6iBsiZs7adtPk8dNILVftooDNxu2Q7U6xexPj/sxgJS9/1xnaiiELe5MOpc
	fUO2vYMgsg+0k+AnNhohUYZW2a4TJ8faH4h38WnNGg6zMYoK6NhnnRKGarX47vTy0Fq25T
	e0h9ryRPiM+JISdmEj+z0ooHFGVFEUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132611; a=rsa-sha256;
	cv=none;
	b=OCSRwLJTYKSG3YCt/gxGaxpKIJD0rbScz7gaAdSvwzwaLnegf09oloRJKC9P48sVWJ1+uT
	mCdKIuhpFG9SnP1ePAHPxyQULgHTvlRifT+WdyyJcXs1Yf2wZJzHBw17uv9M/Zizjik9B7
	a0kEtFMBaDuQfq/ijD4R6/kPDVbLDlQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ELclghTz;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0yyCaz4IBzCuynoK7eJFq8qb8jjHV9aZwpbdt5Xpuk=;
	b=ELclghTzpwJWjR/UR+37efBuUNW3hHvHIUUhn9zdQ48DCauW/JKaepPcVxtipxLYdfPz1s
	TJlWlVYi3iWbOA+tzfvPwjIPhRqRVOdJu1ddQWwVZ12J5scAeXGp4aXLrUrSE5IQNdiYXs
	HS3Fnk+Wp5vdica94wXD+ZwjlDZ+yBI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-neiQKoMHNwSSwPFkEubsAQ-1; Fri,
 14 Nov 2025 10:03:27 -0500
X-MC-Unique: neiQKoMHNwSSwPFkEubsAQ-1
X-Mimecast-MFC-AGG-ID: neiQKoMHNwSSwPFkEubsAQ_1763132601
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 621861800107;
	Fri, 14 Nov 2025 15:03:20 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 848421956048;
	Fri, 14 Nov 2025 15:03:06 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 04/31] rcutorture: Make TREE04 use CONFIG_RCU_DYNTICKS_TORTURE
Date: Fri, 14 Nov 2025 16:01:06 +0100
Message-ID: <20251114150133.1056710-5-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: 9pk17k4dktybwg35r6q3wk71b1jzncjt
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D24F140013
X-Rspamd-Server: rspam01
X-HE-Tag: 1763132610-203566
X-HE-Meta: U2FsdGVkX1/ynJ9FZA4tdhJTfbhc4XlndmeDTc2OdhmeMM5HimK2cav6cC4XbqIEdAGXDW/Or7bzAyuTAjcGbqXmbWAnZ+rxqtQFdZrtMD78MLQI2tvmL/TmXztCxpN/NI7c7cpUgyaeC/XRBfiYapKYZVuDPysHB/ADa8KggBhlVg5VNGPNxkOeyPUPuVrVvL5LAh38yZOZ0T2nplB7G6S51ARevhrEbDeJJI65H3XoAPJwZaJMJk+9l1P/6PQKLOFJ7bBevNbHNAbpUKxET4NrQK+97W8qFxrMXJP2b36dewvy07Su/uGKJu5AN1M7UiVPVTKwKMfmM6T0qU9G8K3Oh4JAOgTMosx5tnjKU781yZHpDTofxKQMR6U6unRqYZHlBKhP+9kSSKf3JW6fWlokmAhMI+i68z9zuIeQAdpDwlz+c32mAIxNh9EgSGsnlpqDTfKF9cePHzWnTvHBINjxPCzf23OLrcbmeJenFk/+GyDD4jb6+WrOfbiMeGgMQLah11qBfGXjDVGOK6y2IwCoev21meHU3ccM4z7g78zXKuhHlUsaUSBXSOZgVwO788pqtM/5NMF06ZgeLu8LSZEC/aUArRg9esHfZbsNWttBIgR2Nf7RVyX+djiUQC5L1t1l25nkwPsvSbIvrUB02c9geVzhTu2C4DDYkN3A1XBgqxCViwFiOjPW6SqB5EAM0buBYBC1fprBqVQ4b4N2KW2P3cEYfCsO27jBrQ1JO4NfP3GA5kRufiKUFoB/AZ3k4MpeFGSdBrZvuCwVNDsLytLaTH11JcmJSTftyzJPQguC4CfPuhV/sWrP4v271+ApbbBUVwwy7982Cu9Mjo/ZVfVpO0f6ce2sROnVCBeQG3s9EThUuWoNlYxmB6K60tTvIYQWLDlHYh9Xt2oErZtF+qtVJVkjZBrrZpgXjwbkSCiBuxONNpaWHcSNoxzwc0usNHaeZNcXVoVYjfMgnIb
 rXnB50OM
 +KvJJ02GoIVT18Y+A0feUb1u1ZuRANZZO0s85z9BGrXZxfhTwMoZPLsnSHmxydcZYhtmaaxFtCdguihFWkiikF7gJ73Bbvbga4eMk59qU1cYIjYchDgRwPi4uDPaEB4PqXx5H3BcxiDUHah0V2eFqm0dSY2xBoiBOnwXaI1PzYLZmZmM/Qr4Rj9SF6a2FZ+pXBf5sjtKshTn5e31N0qBgkZx5nO94Kp7avteZmcHityESpMwpZoUSs+zG+RfwH8wCsvUrfc8i8j7LQukJNg4GMKrBDYMOdktTp0Z1LgTGaYDQfi6RojPdUXTHvqNMvtfN9HI9PwN3htMStdSKGf9bDBYjXFifpUEWG2e4rSqJCzzLdVigEWU0hEW7HYA9OcCzu2lPB1l8d8TVLGmZxMjIcQHzpebewJxC6kXLKTO8snRi2RBYyp9nj0ay2n7Bn9L/p01JRGuQXjoK845LTW6txwPJJcLDciC6Gy+ESvKzuQnkAVSCLGQwM7ufMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now have an RCU_EXPERT config for testing small-sized RCU dynticks
counter:  CONFIG_RCU_DYNTICKS_TORTURE.

Modify scenario TREE04 to exercise to use this config in order to test a
ridiculously small counter (2 bits).

Link: http://lore.kernel.org/r/4c2cb573-168f-4806-b1d9-164e8276e66a@paulmck-laptop
Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
---
 tools/testing/selftests/rcutorture/configs/rcu/TREE04 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE04 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
index dc4985064b3ad..67caf4276bb01 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE04
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
@@ -16,3 +16,4 @@ CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
 CONFIG_RCU_EXPERT=y
 CONFIG_RCU_EQS_DEBUG=y
 CONFIG_RCU_LAZY=y
+CONFIG_RCU_DYNTICKS_TORTURE=y
-- 
2.51.0


