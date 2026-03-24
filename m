Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E451E9A74B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96A296B0089; Tue, 24 Mar 2026 05:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940056B008A; Tue, 24 Mar 2026 05:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855496B008C; Tue, 24 Mar 2026 05:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 763486B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:49:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC7F89205D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:49:23 +0000 (UTC)
X-FDA: 84580483806.21.0CDDC2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A0F01C000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:49:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xfc+zlsm;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345762; a=rsa-sha256;
	cv=none;
	b=PyjEA81qXLqS5RWLTKbi5hrawK0/wPf/LdUXH+ILJ78puziyr0Njp7NtXhPybH83XqgaLK
	FZhb2R0Cls2FlGOPu6qSJStdGawvdgrH9DVJg8d/ZkE2wdGAlCLa2BKhlVDkpN61RU6Jhx
	tc6atRov40H7M1PKCibk9XsSP9nUtLo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTf6sg/Whunq8XuiYT0VZnNsDFxZypJnLbapPFQuudQ=;
	b=zwApGxPky1r3jQo+FaFrBUVwHHbMWwpgNA0lHHKJm0WqS/D6EKJL6GVtG68uuMqVK/hg8P
	W1TZXOzz31JZ/Q3gC9Glt9pZ9paTl9wIY7MHO2arq2XJXHHIbaJiWQnbVXK9yRwHsZlRRl
	u4A9YKhCw2kRwX9w4NiSe0fN5JoAi2U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xfc+zlsm;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTf6sg/Whunq8XuiYT0VZnNsDFxZypJnLbapPFQuudQ=;
	b=Xfc+zlsmsYV5bjJVgznWsyxwue6M47QXdXlVwbsBIlF4jgtfSmT3RCsh3+Ny0rzygu58hz
	wwqVuNHlZBbFWjtZG9UhYDeacfOo5eX0JyZRYohi5hJvHKflSD64pHS/EBFjtx3QVKRtI2
	bSS5bMRkNOb9PzlvZ2owPvwSguYG4Y4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-7QOl47OWNtCgy7nQumHfow-1; Tue,
 24 Mar 2026 05:49:16 -0400
X-MC-Unique: 7QOl47OWNtCgy7nQumHfow-1
X-Mimecast-MFC-AGG-ID: 7QOl47OWNtCgy7nQumHfow_1774345752
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22F0D18002C7;
	Tue, 24 Mar 2026 09:49:12 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D35E3000223;
	Tue, 24 Mar 2026 09:48:57 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
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
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [RFC PATCH v8 02/10] objtool: Flesh out warning related to pv_ops[] calls
Date: Tue, 24 Mar 2026 10:47:53 +0100
Message-ID: <20260324094801.3092968-3-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: JCUoUx8gQzGhRNOWRw0IV9eyq3DTCtjuaFwZflHn818_1774345752
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0A0F01C000C
X-Stat-Signature: npqaixm8ptix8qszgq95t7w8o86zf3zc
X-HE-Tag: 1774345761-464964
X-HE-Meta: U2FsdGVkX1/k3M49/1Xoblaiohr74njbBjLMvuAGkV41CI3QpYlIsB9i/i+nfZNqcWySXQ5tvCObAkNPrlT9vwyeOIi9N44lEg0n7a8OeMGqOmi8YK8mh8MmgPhKR7O+l8Vj027j5PT1cLm7UDUUBNaAumIA7IpYNja6CejJypRLgv5xBIX6hr5L5wd74sdjxWD4wjeiq95m0yyeDXLElM1JJElFkzCgrrmgRUR0lcshyIDGppZgQOF9q8ZfDzwA0YJLJExHXWDTB0qV5Un+WKE5T1ahrmxvWKUeTuzc9UlgFmk3HSUYnzhwssolgExmWgfqHZzYhriCHIeipC1YNL+okSFX0Kgwtt0lrKGKfEmKIv/LC+RflmVcHXMLLXoTmQSpGEQx3ytGjoK7vuiOUr4vsMcP5E9Z0rVZf6in9sa0D0b3fKl8zEkuJ0gB6uwUVHEVvCSiXcgvh4ycxrKHX3ijM4+HZfY4R1F8cZaTlvL3bavM0CLkFIlYhkAVFejTJUlwyIpe2p6jnVodhPVMD4iPofIbsbzeGB9ifpIUZ7inC+SZyQMzFwHGoi091KvXNpTAJQU84KgfiHrlmfV/MSoB9Izmo7ndr2Q8qwDEXV5dGaueaQiLGXCpST8jBM2eWfIEjUJ6ADN2+J/N7/XQRCgLTA2sMcq7ch42Gr1lwGHQgbnwjVW71KkdEUwctu13cG3+mX9M34bFITfKuHlbZ1LBShsLahlHmR1R+4Ra9/HTkSZvRpsVDG4QpqJS1JTZ4MSPBLPe7lbzBIBEUCl+1huUDI/L0flyJvI0lxTBTnhIUmmBkCFcGjGZC3ktK/tXnQV1yRq7z45layfDqpzf4NIBMZxP3O5emo5I97dh7r+iqghalIqh+BaSRd8+fiwbTWk9Wxg1Bo1Jzft5uwwo32PTUUqbzLpAW8X3Ix09o7C6/L1qJ8gVNhWGK7ViwV8oe79y/fgcHotNGw/WWui
 4knhTtxf
 jx1ngdP2xhI8ouiAGgBo28sITBax1TXvCrNMw/x7dklUX/VVBeAGnULiL6iv2BoeSaKWP8nPHyPqkwpvMLd5Gfh0nyrKrRQEdDdTq1s4C+reuDsKm872lmfeqn7iq1UA54Sxw/Dso07/r8hM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I had to look into objtool itself to understand what this warning was
about; make it more explicit.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 7c82934247484..418dce921e48d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3426,7 +3426,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 
 	list_for_each_entry(target, &file->pv_ops[idx].targets, pv_target) {
 		if (!target->sec->noinstr) {
-			WARN("pv_ops[%d]: %s", idx, target->name);
+			WARN("pv_ops[%d]: indirect call to %s() leaves .noinstr.text section", idx, target->name);
 			file->pv_ops[idx].clean = false;
 		}
 	}
-- 
2.52.0


