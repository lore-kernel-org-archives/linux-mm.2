Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660BFCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FE06B02D0; Fri, 15 Aug 2025 16:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C816B02D1; Fri, 15 Aug 2025 16:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7F06B02D2; Fri, 15 Aug 2025 16:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFF856B02D0
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8877F82A8E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:41 +0000 (UTC)
X-FDA: 83780102322.25.9EEC9AE
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3342C0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Fi/z+Mo5";
	spf=pass (imf22.hostedemail.com: domain of 34pWfaAYKCNcDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=34pWfaAYKCNcDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wKL4ZYGX/K8WXuwlgtNOGDh1yxD4Vkofr7n0sxP5Do=;
	b=hiQw4MHObzDnUjGZXlgcCcwA08PhFwH46m2YTxpih87M+G4M3Oc7D8hiXW3wbNlcM1wEeA
	8vyiYMzAPOh0tyRHJU6REGp3AC1hx29wiRYGbu4CaJK3WWdPQtSCL8yMKsEEoP0xc8S6K1
	RBcgqSH2Tn05msm29+NjL2mRYpkHWOA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Fi/z+Mo5";
	spf=pass (imf22.hostedemail.com: domain of 34pWfaAYKCNcDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=34pWfaAYKCNcDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289059; a=rsa-sha256;
	cv=none;
	b=AuEJJJveBgEqMtMJvxao3fK5RqMVGDFI4oaVx4agMJzc/WETNv2PcEx/Lbm0zFlpFaxOmQ
	Dgg4bWcIzsNF8yhESeueoTlkQlxxJVRhHZEnIK3BApSo6DVpbd/KmqjfnM/Sdm5x/8PXep
	Vy7sDOievcEfGm75T17sU7ixB3iknEI=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e8b4ab7so1883571b3a.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289059; x=1755893859; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1wKL4ZYGX/K8WXuwlgtNOGDh1yxD4Vkofr7n0sxP5Do=;
        b=Fi/z+Mo5VDwqm4uDwVREuKIK4DyerMZAkgJr6kD9o3qkkjLlmm4GUJxI/IZj3S8nOA
         HvcsOJZaD+DI2NzR65XukOQ25rh4r1t+2HHqjTFYFSBT5wD2jLiu8PqSe3M8Lwphgbq/
         fmKTj18FYoKiAa84pXaVdAqlYi23ZFGyirUnIGlJqmjskKRFU7GlLjhPpq+Q047lcsua
         DbYzUeDD2UgrSeVeTpsvnhEtuJ42h2dhHWRPIiGQk3Cv1JPLDocm/xTof9uWsE/jDfTM
         Wc2zjw8/+fB2tvD2H/eM/Hlkggel2qa/kGzSV4Dr7L4OWEot9MlmZ7o+c5Y9CgNnP1Yw
         ofZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289059; x=1755893859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1wKL4ZYGX/K8WXuwlgtNOGDh1yxD4Vkofr7n0sxP5Do=;
        b=HyHbGAdXDjGyBeinuHMxrsMKdnqzemqiR7Y1lyNsqOMVq3Oym6splqgCnJitHBow2t
         OmfqlaRWs3oX+s0R3p8f4B/oMOFjYFDCNn2XeM2EFDVwsd7hzOpsNk97dK+ZYOKWFEq1
         P7dgie6XWe5g4LZmWhcvZ3AiYjk9ue9uL1QtoBsoH+j0xZ0aYzYO5gvAL3usBz4VRB+E
         TGdpujkB8AjMvrOfNN5Yr7XeFvMCe0e1Xpy7MfOkysm659SbewsNZSS6wjT+tEl6O2gF
         GgHvpohYvTY82ls78GUX4zrb1tepivUe0oXBOU2vBryjctgkA4oT3ikAK+HQQkmGYnE+
         NfYw==
X-Forwarded-Encrypted: i=1; AJvYcCWJgqMYpiPrg6shWL0JJm6+rn+KkBDo3vRUORXHJCljzdS7Nl1J2m9CT+xEqUG7YHyc0/k8ZPZuhw==@kvack.org
X-Gm-Message-State: AOJu0YwQM3nGnaJseT/PmmrYCKRokQ96fVrj8Di261vyzRqtVM73vAub
	QmI4gY7vQGVlEjU6eCOwD1i0sPPIFJiXGA2jw1O8YdzmftFs+bC6p8CWU59gIGLl8VaHTUGIA9U
	6ivfBOw==
X-Google-Smtp-Source: AGHT+IGfFQhxVrC0MRMQ+CGQK5l5v2DySu8ZxAiDgHkcBvf9T0+txoiH03BQJJ5/iyzxBM/IkoVynChoTcY=
X-Received: from pgbdk2.prod.google.com ([2002:a05:6a02:c82:b0:b43:6adc:24d0])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a1:b0:240:1327:ab3e
 with SMTP id adf61e73a8af0-240e611783amr454188637.9.1755289058544; Fri, 15
 Aug 2025 13:17:38 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:11 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-4-kuniyu@google.com>
Subject: [PATCH v5 net-next 03/10] tcp: Simplify error path in inet_csk_accept().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: sutbgae1ux4gtj51t49r4t8jso3qjmyi
X-Rspam-User: 
X-Rspamd-Queue-Id: C3342C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1755289059-121589
X-HE-Meta: U2FsdGVkX191CXETGT9XUqr/7XfscNC2y0BOpx/sYF0TNRSua3p3NBSZoWQF8HEUeIHM4EcX+EGmjSzMwmJ5BbZoU4i6yZ1hLIzvazc7K7PTbPla8MzO4nZ8rWxQqjsA3pt6gTr53K8ES7RRcCFw8qvTLYoHSAFSvPcY7o5tRTEHg0cnQn42qTjgBqtRg4i0kBkKF1VgwdLsO6e8kJdq11SF3c77djbsbT3ViRnTS/65HslQiwd4Dgbl6ohvF/kseakHdQQ+hgne9ccKncTtPJIhtggxaytSWS7pruRa/naq4PhFeZVztzLG/eyjC9QCx9mwj1jP95Vnkcw/m1NSn5sunhydlMM3nq6zLEwTnGZ+nWZ2NnOFU/ObAHjC470eTPfJe7VORr5N94XG25IRoAL0vKaC2AE1arEhz1BR8aJmycQzskcjp+Szsoaae/d9tAMjyRU6GYRHgiuqy/JR3upP7xZxZaE5VgcqiG/jgb/fJOtM3ynqmWdPDS/Zhb++wy4x0Fp7dadmpbBDM28UydfmQ4RMyR7O10olFp4sBwi+trrBoT+meFXYW/+DaCBO8HaeuF8B8Fn4bRnIITAqpz7Ek/neNNmLKP0KXmqe9sV4NaCYm+TuRkcGuneRF02oSpJLV7A9dL/rELeSTYBbll2eN1Hg6eDBXQlZYWvLLpLFgSh8tBOd8YIPEkOH4YK60usujP3pQjF4cemuAHujBOBw8Eu3sJjgOvV25BEzRMEZ14wWegQ5Z7R+YfgEYrvGqPyXSD73t7HwJ1a1c+qty+Zl2G0QRK4FkVvb3DyhZ96Sb0rQGdK8sIeb0MaEC/1/+c5DCCxjKG9rXXWZ5sbV6BCfoE3T738CbAXLBr/3jyuYCOcAbq+4iyDlqnvh3dpYE1ypif0cgO+0pQfdjkgQtKmIe5Q+OX2FiY/0KTt4wgXv84Az7ubSe707CpOMWACGusWS9rVueGKZ/acziRj
 eYJZLdCy
 GmDezzAsXponpKV8d8zna4hOYRYiqwuBnJ6+kRlJ2qAcpdiXrQ/NGqe7GfY8STz+NmCMDQFmw515GUUFWbaKNAUZf8AjwIaxAxRM1BSGH7Sx2Oxn/RGonBPs2ZEtUjiPZTYXSABTeOpuonuscwtyo2sCMipVuWw2SpeXvUR5ZQNqMQ9tzQfxCNlcECVwcM+BafaHzYhpm5pcOtDw5uVDtUqJSYU0hBH52D+GYK/jzGN3NNnYhGM7EtelQ2fBI+C6ilFlbi2Qt1ezdoMfSm0tNqhpzHAIVRBpTdft6vzr1wfCq2Iq8vpSCqmSq9iLrxCIEk2h05b2L3tslTJUsddSG5+jnpNJ5ZCs+T87lgGkpDfv6fbgE0RxlrDqGiOqEvzxeaq53qLzaufUd3e1lw7Rktf9RehOUYBoqLvo/PYOH50xlNFuNHd1vCzpfakk6rzvW1Z8IIyicL0tuixAWk08qqWrroFwPY53Mv37G7grr0UsfXI1uCVrWEQ3/M+leZGN5r8IQu6nGn7bv6xmvrwnBKn8soXhlHThHP/ZG6J64BQU/xhfIiqDGiiOi6E5fGop6VdYZu1sIBw2eyahyLYy8CxJJ8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an error occurs in inet_csk_accept(), what we should do is
only call release_sock() and set the errno to arg->err.

But the path jumps to another label, which introduces unnecessary
initialisation and tests for newsk.

Let's simplify the error path and remove the redundant NULL
checks for newsk.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/inet_connection_sock.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1e2df51427fe..724bd9ed6cd4 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -706,9 +706,9 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 		spin_unlock_bh(&queue->fastopenq.lock);
 	}
 
-out:
 	release_sock(sk);
-	if (newsk && mem_cgroup_sockets_enabled) {
+
+	if (mem_cgroup_sockets_enabled) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOFAIL;
 		int amt = 0;
 
@@ -732,18 +732,17 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 
 		release_sock(newsk);
 	}
+
 	if (req)
 		reqsk_put(req);
 
-	if (newsk)
-		inet_init_csk_locks(newsk);
-
+	inet_init_csk_locks(newsk);
 	return newsk;
+
 out_err:
-	newsk = NULL;
-	req = NULL;
+	release_sock(sk);
 	arg->err = error;
-	goto out;
+	return NULL;
 }
 EXPORT_SYMBOL(inet_csk_accept);
 
-- 
2.51.0.rc1.163.g2494970778-goog


