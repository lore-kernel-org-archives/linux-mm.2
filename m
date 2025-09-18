Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE53CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DB38E0132; Thu, 18 Sep 2025 10:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B498E0112; Thu, 18 Sep 2025 10:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A617E8E0132; Thu, 18 Sep 2025 10:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 928628E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 58B941A01BF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:27 +0000 (UTC)
X-FDA: 83902546014.12.FF092F1
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73E4780010
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xDb3yN7d;
	spf=pass (imf02.hostedemail.com: domain of 33xHMaAUKCIAipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=33xHMaAUKCIAipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oanwb4AvefPzztLhk08gBpEPn5bxbhzZnwvICntunHw=;
	b=cUd9c4Il3LTnKkFuC5U6b6H+KXCJOnxm66Yjan1gZmTgFUgNqegdBU5IACNAvuxJbEgjqV
	ho9xTyykJ4CcIXAlpfjMqCWPdtG/OnEbEhvLB8mmD0KXI0x2RdwHO1QsjoKB68JYaFYN1i
	g+1vvyhs73Moy3+EVspycQg077yLAzs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xDb3yN7d;
	spf=pass (imf02.hostedemail.com: domain of 33xHMaAUKCIAipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=33xHMaAUKCIAipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204385; a=rsa-sha256;
	cv=none;
	b=Y3TlCKxf4N9FbGhLk6mA6cQYgw3wdYbacFMhfyg4tEnVcOE9nDD89ecngB0zZHM7svSOYc
	n3cL5S/aCm+yrog5hDZEAllicte/qgc61jQJRaVEULCNHhUX3XHcBNA6e6+HADHUcPiTc+
	8vhQKcUgENKQlMn5hHLIoZ4akSR+zlE=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ece14b9231so561595f8f.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204384; x=1758809184; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oanwb4AvefPzztLhk08gBpEPn5bxbhzZnwvICntunHw=;
        b=xDb3yN7duW6NINdZaWuHuhkajRjjY702dE0xFe9/krJwDJAE7yXoYpfVHiDWr9eGUk
         N8mKjaJcMa+MSX9PUgedJJZW3mBS7VvGZ5zmeri1JjvUOKxe6w+5+/DWci33z1INHk6n
         t47Yh+vWmhqwdalEAWrqXD5wrTwPYYuKoHGANpkrpFc0/ygEqm5nvmXL8LQITv1QRz14
         QsHjymb4n/HWxZJszDnteFXzDyCetM/WrPQH5TrF+ZWbBpCL1cheQo/uJTyNrsTPuHmj
         rRDU1U7zSilDVC8soVZmnzRWQ73hiJL0ScDBlTnCk6551Mn7vgTaY3lv7InVggHXpbte
         vZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204384; x=1758809184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oanwb4AvefPzztLhk08gBpEPn5bxbhzZnwvICntunHw=;
        b=oWyfobnrqgEE6z60VFtOnt0H98z5wfIjtN80UjaRp7fIJ79l2pNwJnbFlQuKOTOAdM
         wE/nU78utCZFk3mH+Fo5Tq2t0vWTIrcIYw1RDsxkC6kk6HEoaeE/q+Hje5B3XYY9zOG6
         hedkWsDGaEOCQGIlj0nUngmUWueVGc3nIGHZlmIzc1B1976Vrtm5TJBBkjb+kPVUWorn
         xpCqepddH62zLM6Ajr+gk+aIVgQ6wC4HUCpkqwMulrsQCNJOK/8Tckhf7xceaNJTr2UE
         cTDJqmj3AsOGYDD07hW90Fel521OhJYMmQMOfjk/WbuLEzuFSJ0gHGQJ+bnjCe2MyiMU
         RnuA==
X-Forwarded-Encrypted: i=1; AJvYcCU3raL7gWhqUODnU1YHztOYBrU5HykefvA8MgNbDzJfCXNz25XWhxcEI9gcvpSX8Sa9zxAsoW8+zw==@kvack.org
X-Gm-Message-State: AOJu0YxTAPZs4TooFFmyWT2/9Ti9P82WbRYaNxB6i30ooQML7HNKrU9F
	my2fabw7jqgIp/9fhfh3wec0N77oHlPd+hhFS5EcCi1qcJlYQGS8Dd8DSw7K8oE38+JRIVDUwA5
	wYg==
X-Google-Smtp-Source: AGHT+IFkViOrkTd7Qf740HpWB1Y+zHZAT/ov2XdutlPI/XGCPUkCb5+91SEAW6LMPzEdlyQcI8JNeQaNOQ==
X-Received: from wrbcc13.prod.google.com ([2002:a5d:5c0d:0:b0:3ec:df7a:666])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:438a:b0:3ec:db18:aa37
 with SMTP id ffacd0b85a97d-3ecdfa4b7camr5826204f8f.60.1758204383884; Thu, 18
 Sep 2025 07:06:23 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:32 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-22-elver@google.com>
Subject: [PATCH v3 21/35] debugfs: Make debugfs_cancellation a capability struct
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 73E4780010
X-Stat-Signature: mieq5w619x3igsb3mu7k3e1kim3cw5mq
X-HE-Tag: 1758204385-193661
X-HE-Meta: U2FsdGVkX1+7GT/Llen7Fut6tSGu0Eb1qZZMcsGoeSOzs6PjDz8KuGI5uul+NwNoQubti65LbGLopxm8dovYLEqQNYctvoCNh5qJv9CTCSn5raDBrY5XPx6bEYGvdzDFBMlpv6vnj5HScz/6o0qup6laltOMzHoHgdV4Wkhg6+13Op+IHZPcAaXikG+knr5EHXi9AeMhqt6wasUlz53yuw64cIHU2KV8KpmFUewroni1UCJGW+vOEGfViXzay+dvgfhet2nKTFW+AvWwCfxrcTfyT7z2tgnMXF/GDa7DSyBIM8oENICMCigVKLO007uabDVGrdKRZG2F3v7hGkVvKhivUConYBjDZYIRl1hOT/wQVJANq/K+HeZsgMGw5CFRIsckM+WZU59Xz0SGg8mPnwiCIKVuLwQsXMzddTNW3AwXmFDNBYlBGIoBPeQllFibBzXNVmUvT7x2+Ozlg5Jrz8o0WhpxkP62yDwvqITp53dLHfIrcOrT5pIS/UIFBlZ1INs7Tz51m7kRrsLbQQNGUO6HFwzfQHktM4j9OWWNZAApvsaZeQMObORhbmh7uz/8DLnrqRR8++szeVUE78jEycyMrOaPSz84thXT3MRnr1YBmAb76Tzs4ctm/BJw0qj5KYx1020SxqvMHGB7Rm0sbRY/J799uffOl1WECfKSmVDTdzKjPYqWF4aV+oeSv4eLCjw4PkwZsMcNUbFSrkkEMVpxss1Zw96Fl3mIM/19ESEAI96WB1BJDeW8ANW1LlCbPAH0Joma99x1n49r/tPSobE5ZGCS6hzgi0xN5LW2F1P0kjv2vM9ankHJZlh7WczeZ19A9M80N5XhXLGTn8TV0XDr/BSHrZM7tU8WbVLCJ6PBLpMzdOgkjObyz2Ri1hyIFORotLq07rH/nF87WlVAecbPEgWmGsf+Q0xlavm3LyC+0YJZEUXww0rCt+Vwo8C2IKa8st/ljDqPH6KxQDq
 dM418VdY
 oqDXSXlLfwb/nmF0IUgtLC+tUS12PIYBmikcfJ7dYW3KYRdftkescgtlIW+/YhaYRfn9z/c2Fyqtdz3Gbt4IwTcRi+TJILP+cXv3PAyJjDKRPPD1eKlwjXWD3sXBAb94EuzLyU+NocWzesN1u2ZM6fYaPFsWYgUdTPlLrn8zbgCyQrSC3W7UgoDbOrF76A5Ilbfcdekwaj+0kAZ3wYN+MFxxRAm/3XRbZTrAjBB+eFO8MVXgNqSGJoXKzfbpAaZrBDC5+ABO2mKRIe2u6mMpQ7nviCMdY0n8L2je2jitYuYPql0iCCp44V1HZMAskHVXeIR9p4FvU8DCBsFldwMmM4S4ezM5UQgO/I2BpdVOTtK8MYdonQsjUZs+acXzY2Gc6nJrZPYicfnwJtp0gNGtlMst7QoMf+r/jyAvtSgxK+VzN9SKmoKNKJ0Tu9JZI8d4PLMrmiEkR6EGKDgnCC6D2M++z3TBF931l6rroe2BykFYTiG8aDzBbGneNX75A0QMVFsrrHOLVPE+y42KbC08QvLcxkAiaeBapAfnt8W22scR/Ajm4SAKFuDx9fdJHFhK3AlZYiyESi8bk/Ag8fgJ/g97kygVVXzm09Qa1PZw9JZVhgdQ1BaP6FFSuMglY3RKWuwb/HVb3vkEYsRJcIUc7DJGfiPwVi/oJQ6Ij1QdOB8rN0bFHUhvgduKFWFSzs+siBnTL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When compiling include/linux/debugfs.h with CAPABILITY_ANALYSIS enabled,
we can see this error:

./include/linux/debugfs.h:239:17: error: use of undeclared identifier 'cancellation'
  239 | void __acquires(cancellation)

Move the __acquires(..) attribute after the declaration, so that the
compiler can see the cancellation function argument, as well as making
struct debugfs_cancellation a real capability to benefit from Clang's
capability analysis.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/debugfs.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 7cecda29447e..4ee838cf4678 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -239,18 +239,16 @@ ssize_t debugfs_read_file_str(struct file *file, char __user *user_buf,
  * @cancel: callback to call
  * @cancel_data: extra data for the callback to call
  */
-struct debugfs_cancellation {
+struct_with_capability(debugfs_cancellation) {
 	struct list_head list;
 	void (*cancel)(struct dentry *, void *);
 	void *cancel_data;
 };
 
-void __acquires(cancellation)
-debugfs_enter_cancellation(struct file *file,
-			   struct debugfs_cancellation *cancellation);
-void __releases(cancellation)
-debugfs_leave_cancellation(struct file *file,
-			   struct debugfs_cancellation *cancellation);
+void debugfs_enter_cancellation(struct file *file,
+				struct debugfs_cancellation *cancellation) __acquires(cancellation);
+void debugfs_leave_cancellation(struct file *file,
+				struct debugfs_cancellation *cancellation) __releases(cancellation);
 
 #else
 
-- 
2.51.0.384.g4c02a37b29-goog


