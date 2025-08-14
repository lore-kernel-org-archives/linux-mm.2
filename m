Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16C0CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55F99001D1; Thu, 14 Aug 2025 16:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07A2900172; Thu, 14 Aug 2025 16:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7989001D1; Thu, 14 Aug 2025 16:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B50F9900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92A7A1DD610
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:22 +0000 (UTC)
X-FDA: 83776452564.09.8F14CDD
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id C1B0BA000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RxHgt0DW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3b0KeaAYKCLgislgwsemmejc.amkjglsv-kkitYai.mpe@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3b0KeaAYKCLgislgwsemmejc.amkjglsv-kkitYai.mpe@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202160; a=rsa-sha256;
	cv=none;
	b=ivUs5AStytdW0g6Rvim6fBAlk2QSNRIdWE9gRRG3Gfhqmgs0zzK9QwBuMmPDacJ2NrWdUe
	+6OtSojFDN7441vkB8R5BZJotGzmlnGAyf3msRTfB3bc82Bfe2RFw5Q+klZT7lrY3MDDFZ
	v0/Qk16x/NtbBsTQoH16xGlV+/CExQM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RxHgt0DW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3b0KeaAYKCLgislgwsemmejc.amkjglsv-kkitYai.mpe@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3b0KeaAYKCLgislgwsemmejc.amkjglsv-kkitYai.mpe@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wKL4ZYGX/K8WXuwlgtNOGDh1yxD4Vkofr7n0sxP5Do=;
	b=xFX5kBwNrsokyecaHtOCOeCxsEB8wPE5PxTT9au9nDEcf+wjSBIuItsX3jIitdqkVauX0W
	sKiFoIYno2M2kP4TTOef9fOuj653NkS3z1xTbPoDgY7oqA1qiQXsirv7dHdHB4CCzTHFhl
	KMugBFLxCS4AkVs6D+DEGMUhu0ACqFI=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-323266b41f5so2682330a91.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202159; x=1755806959; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1wKL4ZYGX/K8WXuwlgtNOGDh1yxD4Vkofr7n0sxP5Do=;
        b=RxHgt0DWEKwPmpOOvaJ44X+xsnqNbFjRQwf7Jqy6BZGqLw9uIj8ld+7Nf2GqPutVsA
         U63sjSmV8uNoEAiGomi0YuvvObj6j2BVf5IPS2aZm3CC5Zqau229BDE0nKUChAMRMf8u
         EQzhpT/sFyMEEm4iXGwmdilCL/Jv3D80yC4BA9nAVaXwrkI4gDSeBFGIBQTBVhJlTWYc
         aBG1xYbg+0sZshiLMFtyxGu0CQEFl0f5KsmWFbUHNMddb6kXmC6lj9RTOxB9BK3Mk8di
         GR/UJuwIXdWmObhqHy5FZtfHotmLbkJiD6VsyOuwzszA3UfyGu4GSXssEhcKGoj2mJg/
         6ZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202159; x=1755806959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1wKL4ZYGX/K8WXuwlgtNOGDh1yxD4Vkofr7n0sxP5Do=;
        b=e4ORRA318RbjtWl5XHoXMrRbtEIE+TOP+TJIban8RarAASwLA9TqKBCfjuujZJ+Kt2
         Ugja0yoxsG2vu1yaAoBMsJfq9TRrl3jrcmW3XFIDikZaQnY1bo2YXrR3ZBPKyRXu+L+9
         +6xEG2p/fswWCwM+1rKuaInZaMeZqzDGe8EDNrErPMz4QeiWQRqPkr4o/juFRu7lzHs2
         JtPwrCgWRJ/0Pj26WDrNbG1A3uwhLeCpkzojIlM/v1WgjczOIhlLhnxMMLeIsRbM4+7/
         LrhPFbZWdmbKmZl5Io6WyH3wJohXsGVW1qK3zON5N91P3TDF4j8oY/O5ZGcc//jbtVnB
         bnNA==
X-Forwarded-Encrypted: i=1; AJvYcCW8znhdrQhJin7aK37GJLztfYlZq8TIcNlEPWbpPugWmehLwZmxh9vdoCTR/pI/bbJO/H5/IFfOhQ==@kvack.org
X-Gm-Message-State: AOJu0YzqOfhPfnYVEAKnYsi0e75Vkm4B0vnTK0ZUj6Mv6nWMVJLribY9
	EoXW4XwKpkUp33atIcInHSZwowqpVKH5YrEtuaHTiB6OZi4X6lfUNWsHNsQ6w8HsiyKEL/06kxd
	e1rIkig==
X-Google-Smtp-Source: AGHT+IH+nzG+2OcnZiv+3/UMTbEq2fBzLGSyOMqRhyX99l+CDhgD+Ism6ZOY2XsIJISoEwSwcdBmJbzd56M=
X-Received: from pjj16.prod.google.com ([2002:a17:90b:5550:b0:320:e3e2:6877])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d82:b0:321:a1fc:a425
 with SMTP id 98e67ed59e1d1-32327a8b7c5mr6718040a91.26.1755202159430; Thu, 14
 Aug 2025 13:09:19 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:35 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-4-kuniyu@google.com>
Subject: [PATCH v4 net-next 03/10] tcp: Simplify error path in inet_csk_accept().
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
X-Rspamd-Queue-Id: C1B0BA000D
X-Stat-Signature: qa6tbqmoy1hkorn335xikwboy1dxnhoi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755202160-580170
X-HE-Meta: U2FsdGVkX1/j1w9u25RM65zZ/tJDiEKdGxCcKx/gZ7ns7ZoV3UbWcCpZBnZnVrO5xSBmeceFOm+VjAnooNJnNb4hUOmo/Tc/lPcVFkNuJA2rZ/bATQPTm8wGVXo7ewcFRQBhrZMTKYKSdDNeNOLJXUX1tBX12cELR524rxOVHsoxg3sWbG3rd981601p/gjPZbCQtf21NDlYsgSWo83OYCq+dhzc5toH6IxqITRa5rXKupQRhfyWAMLx8B6hF/LQ1bWXQamH8iNY/RPw7gEYMs9iKezG9RRmub0twgJ2mitasMH5PRUk/HKky72uhP5kTvI+dqHn5WlAjRNq5Q+6IQTCuOciuyKwmI7EmvrJyfJEDDeVodmbXbIQFMeKCK7geN31pGghxsTsrdk151LfITyVqgGRSGmHThU1C+0TsTzx+efRMXRbs7kGV3ZldA6lXqX1udnMr8fcN1cZ0gg5zB6OdGn7Kt/fVB5NaHFPCpvwSn/cVQO5mTMs9I0RJIoD+jS7XsUeSAG7BaqvA+bCoyeLpC0+mCuz5tZtMXAsgYIIGSyb1j9RjmEiJwD64az/agkqwPR/xdRdm6DUo3RWO21IVxyoOAaqGjWx39olSQtZnkcodWJ4EHmd7NpjucyXTrdZMlGxowJA5YI8EX54vaZK1k83FX2mR/WKUrnW5oVwqHtDF70Ft3/VQKID21uwWiKHzZXezIOjo551k3/hH6UeeZ5zUQcRfPMZP7ZHQaBs21ByfrvXsdz6S8Z8X9wxaf7Jfixce8/bthtMW1Zy+clQOpR5yQ+v67myCw9p+5Y/TUfn32CGxqEWa6o0VFQOC4ztj4prfA8nsLr0A0sLmKvlgsea54EGIt1MVUBCkx55NmaHIKbJzccQC3MPCg0JeU7IS3hJhkU4GvUGxEWr+sUbodCrFkoWStKG7IWkL5Oqn0Lv1dD0ud13eNfnmw2b9VMudDKdxCK6oGn1DaQ
 7zCWz08K
 qrsLrr3fFwma8AoC0+ir9oVh7HnI30XArSGudkQtgkpIEvaqAmaUm+YLa34aEIKn/OZAB2bH1JZ7qKSr0cT4ooAs3H1+n1E4HKlGwxrPF6jhLxfsMCIh9mq48odKy+iN3734K3opowfV3gSlZy2I1GjvlXqmLA1WG3x13xHSW6+x4E6O/pj1omVH38Wb0hvemeLuVfGgQ4P9j0+fu+cMZjkCzYMAGmCslgDNKgnP1t9iyU225p3VYnsKioVn8iO6Zn4yeEwl2oxPQLgop49HaA3mO6UPMNkWvo6Wzosf6SUaSexjCx6fz6dVf5VlCb//PCm649UXIKoNUlkNCEbH2ZYymWGOIR/wQ9qDuv4nj8gM2jhxz9xJp8vOBKyMQac0AmnZhKu9SNALkEZiM5BuNZixdTNJXzX0YYOFP3X5XTSyyC2CirUcm6Sw5XgKE9Xt1f1Zkymkb24rQGCcL/Ey+OZ4ujpkddrDC+vFDrE3VzXI1ngH8KSBxhBTMJGiHEx2akB/2OfWdYjzk6rZoSCEED7k4cvJbKyrumCq8wRxfXwDBHoXbqM5mXdu3utyIvdKVYDVI5bNyAmp/4IsgM5WF45pqtA==
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


