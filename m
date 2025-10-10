Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE4ECCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172B88E0034; Fri, 10 Oct 2025 11:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1240B8E002C; Fri, 10 Oct 2025 11:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011F68E0034; Fri, 10 Oct 2025 11:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E350D8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:45:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6D36B8CBE
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:45:22 +0000 (UTC)
X-FDA: 83982628884.20.ECE06ED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 07FBE180006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:45:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=db1BVpx3;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Au5DdAV6tUN4ivYmpx7gvL4Yw9R7cu+pTuIQIzQAh6Y=;
	b=D+hxkfZ5vy7wG5/yacA94T/RlE0CHYDZihvucGxINr5raaFrtAChbo6O3NHG3jhsheDeOH
	2WBX6j1PPXi3T9b3DA2uhtR92WEQJj3qP6dzKcYl+kMSLhPV4cEJ+KVc/Tt6ze2I7roAdQ
	YtlHekKQbZXoJ/KTovIptSpHUZl5eR0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=db1BVpx3;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111121; a=rsa-sha256;
	cv=none;
	b=fq9YrsIri+UhCmuFS8f5b2HZQCPyUFtIF6sDZjqepvf9/pwmPVjLbraPZZPbIVqmXpta0q
	hF4JoohwdoCM/nH83N1sjvBtdkP8g+MCs0ldxvk1bQG0IoVqW2M4r66kO4EFZvSqfoFzZ8
	R3jaNveq0f/a6yFZeRz5I3ua8oMdHLE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Au5DdAV6tUN4ivYmpx7gvL4Yw9R7cu+pTuIQIzQAh6Y=;
	b=db1BVpx3kGngRsVbV5UeRSowo81+ieOVT6k8dKHW3Lm815sv/lxQ+hlcBhPb3TMVMO61d8
	N73tz5f5KuaHLrhOYvBXo9KHAdKp5z9DNV0B5B8zjzA4u6h/x4SO+FC56T/JA7izkO0Ngj
	Ui0ReMAijTfVCcwFKCs4yKolEaeGWWU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-301-55_B1TgXOS293WUuB8x3mw-1; Fri,
 10 Oct 2025 11:45:16 -0400
X-MC-Unique: 55_B1TgXOS293WUuB8x3mw-1
X-Mimecast-MFC-AGG-ID: 55_B1TgXOS293WUuB8x3mw_1760111110
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88B5819560BF;
	Fri, 10 Oct 2025 15:45:10 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C86011800576;
	Fri, 10 Oct 2025 15:44:55 +0000 (UTC)
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
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 17/29] x86/speculation/mds: Mark cpu_buf_idle_clear key as allowed in .noinstr
Date: Fri, 10 Oct 2025 17:38:27 +0200
Message-ID: <20251010153839.151763-18-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: puntb3dohs9n8frnrkgq988idi7g78i1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 07FBE180006
X-HE-Tag: 1760111120-371584
X-HE-Meta: U2FsdGVkX1+SqYxkuV8zRjfD7wcWxMkwmsK1sdFHoxspZ0HRz+M/dATUQ4Qfq9uz4ZUUVrTxdhohDFv/QaluNjfKyVIVC2s85EdYGwypvkgSv8QDeQmeCqNJw9M7ki41cfXp8gW34HJWiUutrl1CqODAgmy49wiRnYFCEJ42NqCYQca/u3uvddpUq8+N5rFxhx82ps+YrOhpvrbZ2CL38Q6Gz2Qd2/wYCT5Manjimd0gE0xsaoFPgmdqm8F+tCbb6shrToplu1Z1lvLSmWRSLdvy7TIRFhCXh5TE0FVK9MlW+HJUwI5GLdZb3A0pZEGF88Uy5yo7vGLsDYGtBnglPJO7cofz4KCQ4zjUp97T+kzBcuqZyKUfOuUTr+1p4NRyqP0s8L0QqLmmDEVxWCzU1Rv/hKQkeYUDig0XQG73dRTZOGqeDtEYJNleoSxstDj820hvsX5sz/ZbaYUDVmY52xdfzuPZfxfnhmO6R9aKWJUtLZp9KQhTUMnhabc5zucsSMDrRoNvUhWkPLBRcOu4QdwcgaG2jZLfZarP8l0tGWeRLgTTJEfuiwGSpHlc6f/VA/CA62pKjIQ59tLOv4lBq0DKKVgwLYid5JLC3jttGROiGGlEQKhfyddpK/c8xlA8uQGdTiCb99BkEUm5yDFd7JQZvg6Zcs1MRWrmB4FF7gF4AAF5gRzSHfnIXBJax/e3jjhrZV96ZyoRSP3iFU/Y4OhBDr9IeyDVKlzLsFMLb7po8iCBQqcRmrIoxYnG99KrE59uJvir/frJb9d0rxkecrUemv3nt5F+S25pcbqGXRokojTDgjut97N9b+Fmryp9mVJrVm04E3flSa17IraL33ckiWwA9hOA0GM7gEc/jxLhR9KxuF7NmR55voOYoOwZI+HaN7Ue5BZ+x9tSiSTcxB2mbOPrVYbOHueNy26GHiZs8mRsznRj7+L8PPlFS+SjytVJH3VeeJpm5xbhzIY
 +LqWzIS0
 93MQ5UilCPbD0Ibcmk7bXwWiRoFBeNOPf/wlD20Abhbf66o7rHH5cqCsqVSIbh5+c+m3pVSzfsTadqHSYzZQcyGFRGSxw0f0DwVLrNKkLmFPIT7d8fY0EX6LzjfVn0vuDNHl8smOz0mw0JiQH5EIhBVIWeYEDkYYsmKZmTYeRA5UuPOiXEcv1QRiJYLldXPrx9ZMtfYRsXfXYwN5xAJAFKGiQ6Vy14XnqFOPqQlKp8+No23JVbD4pjTEHjg4xttwSUABkakwF/GBFvuYkwSuWfeKc291YJInuBqRS6v/3/K98jDcSI+paf1qyXEFRh86MduOjITFbmQyIkXSLZOkhkrESc+YNsDVARnGHy+WWHHhXCjG7RPNeOMp8tWmsF0Uk206w7pp5D5IOAZWwZWwQZCjeUeKDpcldCf10hMls0ImtrjiTYe/IIbjl7PEDAkzVvSpC0yz8ukQinZn+gDwQdjc4ltUhm7tQIQ/1
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

cpu_buf_idle_clear is used in .noinstr code, and can be modified at
runtime (SMT hotplug). Suppressing the text_poke_sync() IPI has little
benefits for this key, as hotplug implies eventually going through
takedown_cpu() -> stop_machine_cpuslocked() which is going to cause
interference on all online CPUs anyway.

Mark it to let objtool know not to warn about it.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/cpu/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 36dcfc5105be9..3aca329a853b5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -182,7 +182,7 @@ DEFINE_STATIC_KEY_FALSE(switch_vcpu_ibpb);
 EXPORT_SYMBOL_GPL(switch_vcpu_ibpb);
 
 /* Control CPU buffer clear before idling (halt, mwait) */
-DEFINE_STATIC_KEY_FALSE(cpu_buf_idle_clear);
+DEFINE_STATIC_KEY_FALSE_NOINSTR(cpu_buf_idle_clear);
 EXPORT_SYMBOL_GPL(cpu_buf_idle_clear);
 
 /*
-- 
2.51.0


