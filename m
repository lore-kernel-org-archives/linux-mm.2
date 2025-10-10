Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD09CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74EF8E0037; Fri, 10 Oct 2025 11:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A257E8E002C; Fri, 10 Oct 2025 11:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9147E8E0037; Fri, 10 Oct 2025 11:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AECE8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:45:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4030B58876
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:45:57 +0000 (UTC)
X-FDA: 83982630354.12.ED57281
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 51C182000F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:45:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pg2zUujy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uA/joIxupKiXJwORpnKdW+bHmjp4JFkmsKHil6Ud81E=;
	b=iWQGquDL7SC4H48YXRjuLUHPk+cKUHsSaZ2jSEpruc7n+gbbCw5RmLH+payBsepwyCy97C
	AuSGZ+OenyoZTfiM+qaPCmmxscSQn+BQhAM3sWAV5YnJZ/ZQI2soEnNceLaWrdQv5beAzU
	hZDSypodPoC2cz0xTA22nEOMi6kK2BU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111155; a=rsa-sha256;
	cv=none;
	b=rAGCoPSR3GwMe32kwYkFhPZUvkgbg74qNdDcAXoAaE0vq7sJJEUWqacWFwyPdRoe9iqFSJ
	64budEnnbdhwGxdpbnd2AufRXLzNZdMhBMr/aDv5dGT5xRsNv65QCvcuT2nVpzWGy6vuSP
	RlKOJfSDnip1ESYiivlZbHCyFWPyBpw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pg2zUujy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uA/joIxupKiXJwORpnKdW+bHmjp4JFkmsKHil6Ud81E=;
	b=Pg2zUujyM+jqHLS4ku+ps6l0nDheucz6+SBf8mqPeu7wUgSEYCNxsyYXgZSX5e/15si3ZZ
	MPvHFxgx6WkOSKXlTxnvFUllVaoTCWb137sPS7AFlequtgwFFh1sh8EKrEBldIYoaRrZv3
	7XzeSXv6F2nc7IxGF8iNx1jFTElOPGk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-275-b-Sr8LpaOGShfFTrtDDmzw-1; Fri,
 10 Oct 2025 11:45:51 -0400
X-MC-Unique: b-Sr8LpaOGShfFTrtDDmzw-1
X-Mimecast-MFC-AGG-ID: b-Sr8LpaOGShfFTrtDDmzw_1760111141
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EA4319560BB;
	Fri, 10 Oct 2025 15:45:41 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84AAE180035E;
	Fri, 10 Oct 2025 15:45:26 +0000 (UTC)
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
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
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
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 19/29] KVM: VMX: Mark vmx_l1d_should flush and vmx_l1d_flush_cond keys as allowed in .noinstr
Date: Fri, 10 Oct 2025 17:38:29 +0200
Message-ID: <20251010153839.151763-20-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam01
X-Stat-Signature: dyuqfpwy16aonqz4fx6epb595sig3bx8
X-Rspam-User: 
X-Rspamd-Queue-Id: 51C182000F
X-HE-Tag: 1760111155-812822
X-HE-Meta: U2FsdGVkX1/adCzhlsq4Sl0n6RIG8Ij0KQpQi6OVmwHA+iILI0ehqWFRQcr4fRDUxw6WuaP5FU0WQTcxJS1VeBfNPiRrcDle0l5j07zsz7o7bvHIZLstYRXIuOGIpjsE9NaageNjw4JcozhSOOiGQrnF15KyO+ddpXJ2uZnXtWq6D9EnDLA+9AtkhX5nsKY/vDiiKyXQ3TbiddoVh8IVv1K3stj8WABp0HsRCzxzfWOTe1KCvSNUX4PXHZOkS3ZaGSBBVHSzJfyFRd7wLDYKpp2W6oMAsj7ebyeQn+NHcwDD+uscV14ewwuJiQULgirT8Ygx3eE3A4v3DKXDmvCCOfeMCVbwwJogRi2Et7/TbIzS6yiQ+u7IV6gbA6ZuZrjUXd54G7MBve/aYOaDBnKcNBy7E6Njc+3hKKtAFQINxgi4ZlyUCO4hVlI6CnGNoIqALlQZ3h1uzh79eKuyVuihawROfFibRu4eII9H3auArt3Jd3/sAk30wR34Dy08VCrRm6m3xnMlEfugy5AGykq1/123ByPqqbocfAbffy7Wx8VwO1LbNH3Dul68q+wbrLRo/ESzizUA7Ti1nK/KA/bcJsAmhhh5isNNd+K93XGSWhcY87QoICDWvwZQuMsb3kDQ+MRXNxgf3HMzNv33VT2V3PzjuMERr6QghQ5xVz4PHtRX83k+VNiDx+ASwcCa6Svo3O/i6YmvGmAy1ItvzT+MrhRISuFDrfH/5lXWf4KSj2vbyBllbzoaNuxld4Uny7bVhYRkNDRp+BWjLgdy1hzVsME3IjhJEDKGsnfjuL+iOBFjjeRAyu1Q2ACho7jNb1xm7QvBzTIkT/2LGeSJ2GZkYu6sceqWSsK4lDuYgXWWDnVyPUhOjM67LirknrcuDfk3DHZA7lFPBZRAWyHH5D6kzSJl7QjMFfj59G3dfvut4ZiEa5r7444HVkY9p5wXRWK2LnQUJ9xG40nMkeQXC2B
 w46hVWYe
 SFMGmEQR6W1Yf1FRCPYswT/2pJc3214XEhftnGhJUHme0aMrLh1MdReOEiBzYZyT5wO0rJyq5qGSvy7/6edKUUYkpZs0PGxHQj+obs1k+Ej2qGp4Ou8q1lTmmA/Z2012Xs5vW42nsJpMETIvHQQeQwZlvGRAAdTsu3BIDmJJvC+FeDpZvYcFOukOqjT+wfuw5ZRmlvFFGJKIgZ8pQFNX9Oj2WYwenFUAdzUJfyq/QDQTT9OM7mJyG9Y2XMCwZbYsisFUjgEZgrPh6bJMD2HnA9Dx5WtXWhpDkVmZ1gXZhj78js/Jmv1sqqsatWuhtA1beBAD5U5x1kZOFOi0hWwRIcNHXOZjXLxZFGLKiV64zuFQgXMcz5zygcCFAbM5Ka1vZefAXDAurO6Wh48qSmXliC5a7aAn9QIqd83w02W81kG4FVTldDoMLRsBNW6Ir6uxgdI09JlGgg7HS/4mRFhxzD5L0NDJesSIuk86Ao1X9kkUThOGrD4ua8UPRcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later commits will cause objtool to warn about static keys being used in
.noinstr sections in order to safely defer instruction patching IPIs
targeted at NOHZ_FULL CPUs.

These keys are used in .noinstr code, and can be modified at runtime
(/proc/kernel/vmx* write). However it is not expected that they will be
flipped during latency-sensitive operations, and thus shouldn't be a source
of interference wrt the text patching IPI.

Mark it to let objtool know not to warn about it.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa157fe5b7b31..dce2bd7375ec8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -204,8 +204,15 @@ module_param(pt_mode, int, S_IRUGO);
 
 struct x86_pmu_lbr __ro_after_init vmx_lbr_caps;
 
-static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
-static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
+/*
+ * Both of these static keys end up being used in .noinstr sections, however
+ * they are only modified:
+ * - at init
+ * - from a /proc/kernel/vmx* write
+ * thus during latency-sensitive operations they should remain stable.
+ */
+static DEFINE_STATIC_KEY_FALSE_NOINSTR(vmx_l1d_should_flush);
+static DEFINE_STATIC_KEY_FALSE_NOINSTR(vmx_l1d_flush_cond);
 static DEFINE_MUTEX(vmx_l1d_flush_mutex);
 
 /* Storage for pre module init parameter parsing */
-- 
2.51.0


