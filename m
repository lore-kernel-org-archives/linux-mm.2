Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE37BCD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F7B6B0093; Tue,  5 May 2026 04:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127216B0095; Tue,  5 May 2026 04:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D036B0096; Tue,  5 May 2026 04:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E477D6B0093
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:25:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F41E4044B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:25:23 +0000 (UTC)
X-FDA: 84732681726.01.8BEEFA3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8FFCA1C0010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:25:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fpy1Pldd;
	spf=pass (imf21.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwhdbOwE+91R3Hj2QTyKFPwCfTWDsOnb8m9xGhBSCCA=;
	b=JNM5aOEcFKfcoojmMy+WXkpSmt3illUul9uNUoQ0BK8g8ISzEnUcC9+wo6Y8m0xOnqta7R
	5caJsJtd1Mbv9TEXvSb7MgsLAjt8/dKEde7lUUGRmWz5rjXeSh1EylS7+P1qGgaKSAEh21
	Ey92+gb2soEPKj97uc6WCuWfXbJQkUc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fpy1Pldd;
	spf=pass (imf21.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969521; a=rsa-sha256;
	cv=none;
	b=MrQa7GEf6cOzh1Yxie4vZPTeq9GsAtWkEssoQ5EAgZ2Ga9izDtZqlHLW4DaE+W2pb0YTI2
	8xB4fQHEwA2nWeOOkWoMUb2dz6Nx32u01B87Vw4+kbJbkA00+TaA99743oIzuyrDdf3zaG
	aNMkO2ww2Z5ud1KW/jBHFUAZ31S0M3s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xwhdbOwE+91R3Hj2QTyKFPwCfTWDsOnb8m9xGhBSCCA=;
	b=fpy1Pldd9yDUUWfFUTm3CxT1S/7Zz5+YQQRHpFm5YEH3FycRY7ZXU4qIF85Jv4qJW0MG5G
	ZN9gx2j9XhZmRsPlRya7KE6PGl6U2ObVjzTksrcze4LpHVsqHw8jMzXvKRpqGrDnH86Gnj
	+T+soF2k335PlAiCeiGITN1ophnwzh8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-09GMVAQTMx6sebByWKXjIA-1; Tue,
 05 May 2026 04:25:16 -0400
X-MC-Unique: 09GMVAQTMx6sebByWKXjIA-1
X-Mimecast-MFC-AGG-ID: 09GMVAQTMx6sebByWKXjIA_1777969512
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19FC31956046;
	Tue,  5 May 2026 08:25:11 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C577330001BE;
	Tue,  5 May 2026 08:24:50 +0000 (UTC)
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
Subject: [PATCH v9 02/10] objtool: Flesh out warning related to pv_ops[] calls
Date: Tue,  5 May 2026 10:23:47 +0200
Message-ID: <20260505082355.1982003-3-vschneid@redhat.com>
In-Reply-To: <20260505082355.1982003-1-vschneid@redhat.com>
References: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: XnnQcfTE69YXsXne5PdxjLPSSUKjlf_I5piuR47NSLc_1777969512
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 9xugnhbp3dsrhcy5ehxfwap5yzdxc4gx
X-Rspamd-Queue-Id: 8FFCA1C0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777969521-306449
X-HE-Meta: U2FsdGVkX1/+V70xOE1vqIH3L+Cqw2l5bKzZcelpNWYgmlDuxfGJBaiPqaBuxkX8adWVW7bqZI2rPBglvOVbjQJdfvFaelUdxK96/wXeLNEJZ369IvO+v+p54aH0Kekew0X++qEizX94JtQdveszddVjupc7iE0AUCVlFQ/oIkSzl3yUD8LZrQgQqVQsh1nbEBcV5cyVSzL7G/reBMfcduUoekDfrb0S9RSQ6zgeswDECFkyBjCKSv5F+pr/dIHWpCK0zuy22ouKm9rcd4FHZozYEVPOfvy54gU/X3M6QcQwlfDvrG7RRM8MzvAu7/7ATVpx46ZKZoxDEbLMZHKCD305S/dAR+B/y0H2eOSvhXFupfeHqIvynGxO20ZSjS2iXK41iZyS0MF2uhMk7ITLP9EzwVxrQ4wTiXhHnqbwUUQ+SEhqF6aJm+gcUj5PdUawn5TcET7PIQQfSgpJOWY7QWwjoI1KbVz6lwsHLyPtPX38XXDtUKeX3iixxRVLP+UGQVZzVjCmWhdMZRyYiMY9ihmw9T3TfLwBpEoyCVMT0gmv+UUwr8CAE+tQ97K3zec4BGHHC+qv9YTdnXDkjdS8uH6cCw0GPFXhQMX7pzppka5te5GMsYpqv5m3snn29g55fsD5Gc8HyPh28lluqL148Zr8UgQqdWn2dpQt8sAuMFzg5MaaI0j0Vb+SXz3pxN4u82ZRCF6UciKT6RTLsQkFkZRVojSyttWmTGzRrMIZsdyo+MZd7rAL0unS8jDQeQucsbdg2LAeZ+Cy6gIAC0aYcwKiLNDsiVHwmaJ5k0M90Xhv26bnyGgeNrYPTbKR/Ft8yB8IWyGtxx3ynSxtSsRND0J6u9W0v8Gx9LfiYdh/1jrl1lQJOBZVgP91V6SYdUfPJL9xqzzeNJKTf7jSHgdrPhbNVJ7L+f46DMKa6I6LqaO6YPlaBGRz1bB9ChwCiLDEBxAVY7h+3U+rab/oKbc
 Qh1IB/6x
 7R6ZL8YcCHdwtZ5cy9Iu7RdLwTQfcspWdHgda8ilrOfiDB3TNv9WzBUQ/aGpvOiJf9jQMd+c5chkCsL6Wtleu5/ojX9Q03Tqo0Hr3kwY/Fs064gsTzxPaDCKteam2Nz9jaxt4C+yyJebT6Idsj1OGFQxVn4EIdbT81JpU2kU/5Bhtwdg7zcZsGJM6erQJPIjw2GVnxELnzy/SQT8BxkhdCePfnIMnqip6aPfq1vglaI7GcsjTG+onA5KvvUFfMczXLJ7rrBhCzAQ2PZfafPGS/K6euNpQcSzbb8cl5sU5bFE562PlQpe8vXSyg1Z4gK5lrDmjor2ydmTuxlWz9ETT+gHAl8WMLMuHhNTThellLnrO7Gc2aNm61Ut1cpfUs71EKZdNP8d07jybztKJVQESFGylCjGAf2jiilM6ZkocRHTtuSvBSd7D0MOYpex7UV3S0MMdiodZfJI1lwn6EhoBkMGvWSgAig6m5iBfeDsJhX9fEn5pFhw2aSoVTfF/DvUB9HwU
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
index dcc386e17c70a..ba943bbbc51db 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3480,7 +3480,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 
 	list_for_each_entry(target, &file->pv_ops[idx].targets, pv_target) {
 		if (!target->sec->noinstr) {
-			WARN("pv_ops[%d]: %s", idx, target->name);
+			WARN("pv_ops[%d]: indirect call to %s() leaves .noinstr.text section", idx, target->name);
 			file->pv_ops[idx].clean = false;
 		}
 	}
-- 
2.52.0


