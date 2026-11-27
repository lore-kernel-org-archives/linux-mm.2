Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9640606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=f8Gzj0lN
Received: by kanga.kvack.org (Postfix)
	id BC7B96B05BC; Fri, 27 Nov 2026 15:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77846B05BD; Fri, 27 Nov 2026 15:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F5D6B05BE; Fri, 27 Nov 2026 15:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8A16B05BC
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:13:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CB1A1C3C87
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:24 +0000 (UTC)
X-FDA: 85481998728.05.C955550
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61525A0007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f8Gzj0lN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810402;
	b=A9n5yu4fzXZG1OzZnUUXq0DljCtA+vHcZgeC5LpHJrPcHD9OAUs5yB+rxcaycGx+wfnody
	O8xP9hkYTip0ezqFL1OL4MbhEKBav4i+Om0VQv8cWv0LZukWGHnpaj3To1DdNhZrvvq5UO
	5Q5se0GqZZF74E+G4/mOiU+1EWOwCZ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbLJwRpo4tVdePRmorBlbPTABtleKIaMIw6lipyS324=;
	b=SIx+/iDB/VawYysh6BqGAHPK5l+9amWUwKYjwTYnk2+A5p5mEN8zLGwkSVvNMGZW4pJ+qX
	QXB8pActgBH7zKkcmgDZh2PWAlQpn2qWQ7hnnjsod6LDybzammEhdL3S3UpGb3fQU7inyf
	2g2AkcDkQbEkwfvgrAB4usCJ3Nu9D6M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f8Gzj0lN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795810401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IbLJwRpo4tVdePRmorBlbPTABtleKIaMIw6lipyS324=;
	b=f8Gzj0lNO+hwOoCy2l6bNIXv4CzrxE8NlrNrzdiTxT+1R1HF4Ujy7/qnU+zNaElsr41ESo
	o4/uH3TXj6SDObo2r+jvvClkmreEUY6iJaFw+aN+cGRnp7b9FNpJmasoXpOXZ/f/OqY6+m
	GAHVXfO5IywPTJaDFNC0IXGilJCrSPI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-290-dCe7YsCHPKWZpfgzsI8yKg-1; Fri,
 27 Nov 2026 20:13:17 +0000
X-MC-Unique: dCe7YsCHPKWZpfgzsI8yKg-1
X-Mimecast-MFC-AGG-ID: dCe7YsCHPKWZpfgzsI8yKg_1795810393
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 788AB1944AAF;
	Fri, 27 Nov 2026 20:13:12 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CB5A436;
	Fri, 27 Nov 2026 20:13:01 +0000 (UTC)
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
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Dan Beimborn <Dan.Beimborn@qube-rt.com>,
	"Pak Hung Vincent Chiu" <pak-hung.chiu@qube-rt.com>
Subject: [PATCH v10 02/10] objtool: Flesh out warning related to pv_ops[] calls
Date: Fri, 27 Nov 2026 21:12:13 +0100
Message-ID: <20261127201221.434876-3-vschneid@redhat.com>
In-Reply-To: <20261127201221.434876-1-vschneid@redhat.com>
References: <20261127201221.434876-1-vschneid@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: lj_1aqbIAgdk8R9eS_KwVNlkfEady9UDwGpcnLVOiAo_1795810393
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 61525A0007
X-Stat-Signature: y1stxijt9yu6qm757sa4sekp5otkhm46
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795810402-834122
X-HE-Meta: U2FsdGVkX1+b1PIvv/ys3HEpqidtGFxIWfrT8Ve5hUjPsBMhNibaWTBX6JGxxFwCLFvm7gtskEKhcvi1Z3jpt9W6WdztjtcMhaINnGGFs50yuMJhz9HT8ED1zow3Qatj5Ua6ZjtV/6V0hvmPPuBpBlaHc31AssBsD3rrlwjWUna30WjyIYdMzQle2nbmq5HOhCJFzW1GD+6vLdscNYG4gqTKD0D+tV7T8gSdTcuonIyh3ZzFxPEKkRFJWR5cYqmH5ptNszZ1MwETQ/ozh/neer50kda9WC36NwNphh/i10OVD9g0OJrBB+ZF8AN6ebYW94r01pAmDJT8MPp/hmx4+8bnlDixfum/VLBCpPrd6YCq5vT1P2L7/8ukawXESCHSI7psOFk8sUONtB7QtbyI+z7FOADiLsmbcbCm61DGYnbAciN1sjUR+WDFRrwsZQdI30X6MdLrhUgv8W+T+l4MioCl9MuWvN5xXxlYa4A9LyFkkob6DZv7KNQ6N6M39tToHLUN3g217nyhYTbNCsQ4YLZZ43E0lOWSBzptRrN4h3ry3EDxc9qZyS67rZmUqP/Q2oAM7fD/59qRTnitfgOvczTB/1EtO6U0Ep/ggF+DXGwSo8Ii03MnPFt8fLSHDe44PAGDQ2PZ8UWcipvJ8XV8bp55YVC6w+d2jxisD2XHM3cQ5ZRjk/QhY0IbIwlykS7NwyWrHSUUMG60H4t9IKMEV0LSQ7wqlWFp/vDKX7+eneOvB0u/89PhTdrYXRM0hCWF8uvTCb3QLB6rQ0xEtxusRDfjFccAJ7aVZrigBDehnKccEJb6it1jyva0q0SG5mipBqt0UhISc9n1Y91bLfGEhO6T8kqde/wZMDrvNO2l5LZSCBwONuCuPAFE8fJgD7V7v8KtgAE8d43dHhYlbP46ZUs03KfoPJ/MqL2kGY0mL9G6W0a5MIu31bgwGM5zmF14lmByKItgtLKL0rPBsXU
 vnWaWros
 pTushNJiO6HgvMRazcEse8+a77ePwEc/ZxWgwo6h7x9IiM4y95mvULtcckBzFBCiFWRmn/Oxfi7ULdshHaLQbhOLVvJyeZo0bhzNcMbeJkVhjqQiV71TSBhUC2nhCcvjmjGkiEbOJfXpauagMkIvZk6oEF8MKqmZWhOKXK4zXT//LpYCDA8mr8rwqNzSbd+ytGPpwxkgluGZSCeod9QayOlrPBdlvEajwG+pO+q9FiAmThIdyWBDqKJ5yEuteoWMZATFnLAnS1CmKRNsr1/4zWAFa13bRQGaou8v680uL48YNCnR1istAhMkLlOYOlZ9gdu5seuYOmCDl1tcskXOnxobNTEyG+ZHpvee+Qh0efc2XDO6/pd7uqvy3mUHcdtTQu0JrfNf+a4ho5Ag/ZqqhaOo0hqp5QJU9z9KCNhtSOrbU/ObxrxUBcj5wCNaiOoA6joisJc/tJ3hLIAP4d77JT9NBQeAhXjIOGDQVLVHBCSPzrgYch1jBtaFsS3Vdmzzguv9mWseijORw56Xr5YXlynn8wSWuQJ2Zs/41fmI+ArhyMxwAgqpPW64JUcyJBvG3suAs+C7hGCZUuM4YcOYcF/xjRgFtyhZZ5srQB9T3M3KihlnH/l/gKqRFcB1+goKw0u6AsAbxrX5EsiplRrigXt1IpWtFJ2RoiWWEr0zqYjePgwTKFQN9zZjqzD6hI7ugtC3XLDbNkdbpETDme0HmTckbvclWBxb5+OZhn5FXn5EXXco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I had to look into objtool itself to understand what this warning was
about; make it more explicit.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 7d68f8df9a848..6b1d0e2af00c9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3461,7 +3461,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 
 	list_for_each_entry(target, &file->pv_ops[idx].targets, pv_target) {
 		if (!target->sec->noinstr) {
-			WARN("pv_ops[%d]: %s", idx, target->name);
+			WARN("pv_ops[%d]: indirect call to %s() leaves .noinstr.text section", idx, target->name);
 			file->pv_ops[idx].clean = false;
 		}
 	}
-- 
2.56.1


