Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7AFE9A74B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C501C6B0095; Tue, 24 Mar 2026 05:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C276B6B0096; Tue, 24 Mar 2026 05:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D286B0098; Tue, 24 Mar 2026 05:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A33696B0095
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:50:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5924B1A194D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:50:04 +0000 (UTC)
X-FDA: 84580485528.02.D8C9053
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 38DDFA0008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:50:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmKcWw+M;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33jZYy+kVgo9I3jnxoYq18WEqNxEKHpsQgdAp+R82tQ=;
	b=1D3iT2Jzcy/1JTclc8Y9M8AoRnOS9hKfah4oord4b7mz8OE41SGKDb8J4quOfYD1rHIg33
	T66bNAHEFfNPghevRVXyCKl/EWlskhD1n/FrS1Vj/wBvqgfQXIJ7NFY26RgPYbcY/DWBhT
	TSLfKJDs81GYQoLA23qgo55KW+4kyWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345802; a=rsa-sha256;
	cv=none;
	b=ygqGUtS6Fbjf9BzlE01VRSbZbEKH9oPXt3zbbQKrWRU6BIYFzB8uPNYBJiOZ4LZ18PErvC
	yMO5pFjTlDwI2773gvUo9PoSktPEnvBwH8bBZcP/tTJbG41NEEhud03sNUHv5CxZ5Te/+k
	950o4aIg8H8PR/ZXkBCHIbGlncEewQs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmKcWw+M;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33jZYy+kVgo9I3jnxoYq18WEqNxEKHpsQgdAp+R82tQ=;
	b=JmKcWw+MYPDofH0EJmvNeYlPBxqDYhixkoLSSTsB9yKB0udcTgJwcgWx5F4UKaLtRxw4ej
	RcksCheNd/i9DKPm83I7PoPBlA6EGiGDY7b/qLOcEDjBPiGrOyO2phVxMSVz5XUamLJt22
	I0dZ8JQabpB0+uJHDPGJxZ5siswAtLQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-fmmzxXonPomwp4_ey5VEAg-1; Tue,
 24 Mar 2026 05:49:57 -0400
X-MC-Unique: fmmzxXonPomwp4_ey5VEAg-1
X-Mimecast-MFC-AGG-ID: fmmzxXonPomwp4_ey5VEAg_1774345793
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 191C418005B3;
	Tue, 24 Mar 2026 09:49:53 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA8B8300019F;
	Tue, 24 Mar 2026 09:49:39 +0000 (UTC)
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
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [RFC PATCH v8 05/10] sched/isolation: Mark housekeeping_overridden key as __ro_after_init
Date: Tue, 24 Mar 2026 10:47:56 +0100
Message-ID: <20260324094801.3092968-6-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: GGIbVpDku65V7sqG4oX-bbIOjUntlEAUea1tiiqlmbo_1774345793
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 38DDFA0008
X-Stat-Signature: 7xbbhhh3os1cjng3bxwicuiwzif5sdd8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774345802-168051
X-HE-Meta: U2FsdGVkX18DXVFYbo5Tw2hrBlGbPohGFAeE7ppGtxlSp386VoUGVNDv6qtfq+W+bT8ZI1niczbtobxv9iubSUwkm8pAC9SKitFXGs4A0NDxVpa1kXM1T4ZyhNQvUbhCaL4hKjFgBxw6PqRyQxbtU25AfwtsliEBOSHvUPproXspfz35bALqlDnXHhZs3AhPq9TIuxxXS2dr/ynzdgfW+Wws2AdKYPfhLTphsREhbI9E+efKRmy4mvu3uRzJDH1exeRdpn5HL4mTKYyTeSXsA80PcKvtdT8Dh9boEvNZ8+J29Yl914ott2kAE0sSc2ZA/rDFDwfVVffgRXckUJlA/igT0AZKX95kLLrftRy00D1N9dW2CmyfJpNSzyrtDbCjwxiA4rXh4/TKOl0/HdQ/V0yKkz/c9qLxzF/SsHByN2GgZzqbV9ZMi26xgfKiNsGqHSYnRK4T0XMnuOGbfU2Tsk/ByS5iLgkG2fw36NTuv8TUwGzBFQAok9xO9WTZCJXUNuKhM49C8iG5E2lFKbOzpTH52sPI79Iyl831cV94ZyLV7h4v1fAmcx9e5FZbKVcEn0S5Z6Z5hGJdbLMe36LRHk4G483TdRFSkPAHg0SE4IxS1Pf7FbMbT3N3KsevsJNnrTl9yOfe4FhNrGut02AUw2lNFMuCz0hGFZOuVt9ug3ZwBH+jvvc1JXeyvFMFw8zJJqB2dvJSYPMNKoAHZ01fBPpItUk6i9i7Fe41Hk2E2Wje6MabHN+NhejtcTWe5/CxH2iQfwlbLwd3TiDsczKzVatX++GepbL/yQFWBsSKuk0MxroLUOlhmIeg7VoVLZ4ek+ESafBN3e44khGiXyxY51CTDvLClDIq85naQt3V9Zx/2+I/1CVCBe/fh2JLimDh79zgRFN2jr/6lURct/SJdPQKria7Zk9uvkgvfx4rbkzutteUsj1MQJkrauxrkhKrHiviRXD+wqILnXSy+Dm
 lld+45AQ
 zMyrWRjKW4APcZJW7cFYeUKpHkIQjQD1n4FNDja+vQrX/S70mPlma0OMC87cvebHkipu1xXYHyZfpc3wyx5rAjRA8xoAfXrHXbK+CNqk1QyigFtIYFJ4bldThhlDhIirybEgLaDeC01T+9pm3Urxr42UEcORfqoc0hSasBF2J1HvTqmvXnV6OqL7R49FVF8jp+CZQrecFjbuhj/Hm8TrSO/AVcrP3fkVwjsoToOzk//48zqVM6A8gR9VUc1sikZoI7jSXfiyV1gKTeG1oD4KrKYfN3Yk2qNueOMx1nuZchXvCN8HK3Dfk5d270foDV2TA2GxEjYgEZOdmZYyHNyV0gMd48tZuYlxpwrSNilUnD1rEKEoZ3KfEMM+PoukgLRqfAvXja9uslG5OHLQRc5AAQnbufZLC/nAtMA85q7454Yc+eQR/Oik1vKmIQI13ZfDHawPGNAvSTh+iA/mHzujJz+6VfypqFVi5ct8JYMm3q/AzfA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

housekeeping_overridden is only ever enabled in the __init function
housekeeping_init(), and is never disabled. Mark it __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 kernel/sched/isolation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 3ad0d6df6a0a2..54d1d93cdeea5 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -16,7 +16,7 @@ enum hk_flags {
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
 };
 
-DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
+DEFINE_STATIC_KEY_FALSE_RO(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 
 struct housekeeping {
-- 
2.52.0


