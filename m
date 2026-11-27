Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1909606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KSpajq2D
Received: by kanga.kvack.org (Postfix)
	id B7A4A6B05C0; Fri, 27 Nov 2026 15:13:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B076B05C1; Fri, 27 Nov 2026 15:13:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBAE6B05C2; Fri, 27 Nov 2026 15:13:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 739576B05C0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:13:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F07761604B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:44 +0000 (UTC)
X-FDA: 85481999568.07.52A6D2E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 06DB5180013
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KSpajq2D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810423;
	b=d9RJmFERa9oqSzwk+2R1jEzsEqaw8Owv/hC5+pcAo4j86/0AsvmEoxb3d16hSRE+fdzEqu
	zhVrv252+lue2jb3ktmc7rKcuVwqkTVOHK0gFcoHByjJ0LnWRaCDYojcEDx5/2lu7/cHUu
	N7dUxZLytuIxJLDJjGEJZEtDqZqGK28=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ktd0gbm0hisA+eBjXiYYrjMkzRDJAOVOab1/LXcsi3k=;
	b=r4L6xJL4OzpGRqMpz5eEGj6vYQK4yY72vg/rr2MK3IrgRI1Dt/uTAFMp16T6u0mn6HVgt3
	rQ7B/vQEjotg6eOtaELiCa1Fvfd7yqQeOeqzDP2j1B6dYKzpKueT54LisGXc5tK82Ita7Q
	MOyoCm+aQgrEFxB+wYxdNXPiph0yuDw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KSpajq2D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795810422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ktd0gbm0hisA+eBjXiYYrjMkzRDJAOVOab1/LXcsi3k=;
	b=KSpajq2DifWIU2c3r0IJqWWOBC9nY5xB4JoNXl8Oo4FkQTFC5bGGY8f+x/zxksMK9PS/sO
	VgefwSoBU/cfV+KD25kc+fEtk3CZLseIISsl/FcHBCpphALVMlAw5hLR8YcXAnwA8mzdh/
	BkclXCWjaj4YFGrHOqaLP00qEM1ucTo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-S12Ety3YNuauQIOXG0TxVA-1; Fri,
 27 Nov 2026 20:13:37 +0000
X-MC-Unique: S12Ety3YNuauQIOXG0TxVA-1
X-Mimecast-MFC-AGG-ID: S12Ety3YNuauQIOXG0TxVA_1795810412
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 567521956069;
	Fri, 27 Nov 2026 20:13:32 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBF50436;
	Fri, 27 Nov 2026 20:13:22 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
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
Subject: [PATCH v10 04/10] x86/retpoline: Make warn_thunk_thunk .noinstr
Date: Fri, 27 Nov 2026 21:12:15 +0100
Message-ID: <20261127201221.434876-5-vschneid@redhat.com>
In-Reply-To: <20261127201221.434876-1-vschneid@redhat.com>
References: <20261127201221.434876-1-vschneid@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: 0HmkzoHkn7YGiSI83q2xit5zMvTraFVF89_SZytRe3c_1795810412
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User:
X-Stat-Signature: j3rw1pnrpdghky5uechx8fixi5crzxxx
X-Rspamd-Queue-Id: 06DB5180013
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795810422-311985
X-HE-Meta: U2FsdGVkX18K5Dt1uqOpEp+B9FnpZVEtHCbefTmhiWB3W0GUgfctTk8pK5WbO7P/HoQTrEU7YD5S1KqoOvYf0bQHv0s4E+/w5lTL5GQ7epCvD4O25WwDjbWZvCPelZ6wQXn1JvVGtRODG2gU0r2uVeEGVK5EcT03az0pvagdZ3j4ixbo5k1Iu4I+eLA7gDoqImTfvI6mHLivMmK9f+D2QUCOWG2L9PPJxcDbk996CdZqBvq4gXrM1VP/vjCNoKS+XMRckrpSVymJ4pxcsp/mduldW6RjytmTBdc6Eea16FhnpHNb8uHMNm9qFtA1FeWL+zvVVnzD1qGAU9ztSyqUixPH911t92v+aKQZdLszuJ3o0uh4lDtGd/dPVp4lEOMhJbg5m2TnCWqqtlJE3XVwUdpiZ1Jw27BHlwEIktcRFBJe1pL80kIxt07JaTcUh0PRv41hkr3tnrBxMlnuEMRlkppBJ2sL4LsRDRJr5mjFz28xPd479FDD9Ej9M8Ck+zacoCfWwBpOBVDyPVBG3Ou/ikv5tWz+G8Mem82RK22Zb3WFFCVXMgevwDjckokqAUtgJ1PjY1jkPwnEuh3pMVyPFq4dsK9jvQ+K4VWYj2KrZqE8IXWvRfweyjK058K91vU5E9YxFWZasAd6A6Zoj0QFEGaG76fKkyB4Va7I5NMlcckFQnFmsX0/C2Dyo7JUr2h/6PObk79/BOd68j9loyoiTOM5QLy/6hAbRAu9hPKERM7wffBsEnkLcJI2i3+Oa4MCJTWCaIzwlP8zygfxOLTtDwlpx/wRiquTIZtUFXBt2FGqd2rfOlw3zHUIWg7Q9PHk2IYoy7CRiNvanemFqm5imjGe4ahXQqjDujd1urzhqBSHbUvL/51TS/iiNnVzt9h6Us+4+Zr/Rjr0ocLum0IjzWR0wJqiv3a/YsYONstIyxfH7ustmpcuDDd+Nm94BAR2LQ8PXzJvgDyMuzTHstB
 i189EG0p
 J3tb1LPuctcRl3vGXuPJmH7HRNKjjAe16Vr5hJts+4ulr0i+ypYkV7EsJeI9dbyyUgF0HxFSzKKuHwXIpnXB3GWpJiLSpe3v/wz0J8RcDSJxS2pIhQPTluR6dzuIhNDLvPip9uYDaihjEo6ANktQH0UnzgTiiEf1WbW+2GX+RwMoLkmyzGrmkTC6VRHZ9YSO2wz+p0sNhqlp/ARy8SvjVzPpLC0F6OGF8Uq5JOoc8pNKAN8ppOMFx4XbBYQWdCLS8kWRWSuWbOrfs+aUuA3J8/GN2fW953M2XbNAswAppQepeNVbbtuthDHoRy0TGTrfiWrPALQ3oh10mnY5A8lCFbmBqu+fSd/JPu6Q3PjJZp9Z80f06gtWz53YN5zmlLoLCoyXO9kJnQSBJ/bkhvTRw7yvokvkpmsQ3UX7r+0LfKIbOfhRSXQrDgNPrFikfrwo2ueHSJ01NhwI9YetT08vIg4uGvWgjVH7TBfyTgtndnhegh5eF3aQRDorj6xZVGKyF56RMsPOe5IAnP9nk7StS2aVFf9jK/jBcWLfKGVW3hvtk1TlgZZoY8Dh7UyL7kMTo7+4FpZMZcN8tbFLgoDqwIB9zRwZGg3wMoUryeEjbW2IfiDvKak0bLRqNYaZbCTtQ4vbLlf1zGHWIH+VfeBQVdeSmZi/bWfKs6g9pQ4rWB3zqwEq8R487cAxyB84AyTGtYu0+Cv6f05NibTwPDwMGoO8hig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Objtool now warns about it:

  vmlinux.o: warning: objtool: .altinstr_replacement+0x28e1: call to warn_thunk_thunk() leaves .noinstr.text section

Mark it noinstr.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/entry/entry.S     | 3 ++-
 arch/x86/kernel/cpu/bugs.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index 2bc217bb5475b..4f85cdb5011fc 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -40,6 +40,8 @@ SYM_FUNC_START(__WARN_trap)
 SYM_FUNC_END(__WARN_trap)
 EXPORT_SYMBOL(__WARN_trap)
 
+THUNK warn_thunk_thunk, __warn_thunk
+
 .popsection
 
 /*
@@ -60,7 +62,6 @@ EXPORT_SYMBOL_FOR_KVM(x86_verw_sel);
 
 .popsection
 
-THUNK warn_thunk_thunk, __warn_thunk
 
 /*
  * Clang's implementation of TLS stack cookies requires the variable in
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 56eac5611c318..caf8c3c76b544 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3771,7 +3771,7 @@ ssize_t cpu_show_vmscape(struct device *dev, struct device_attribute *attr, char
 }
 #endif
 
-void __warn_thunk(void)
+void noinstr __warn_thunk(void)
 {
 	WARN_ONCE(1, "Unpatched return thunk in use. This should not happen!\n");
 }
-- 
2.56.1


