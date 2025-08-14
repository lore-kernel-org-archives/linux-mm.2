Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9CBCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 19:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6673F9001CC; Thu, 14 Aug 2025 15:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617EA900172; Thu, 14 Aug 2025 15:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF7F9001CC; Thu, 14 Aug 2025 15:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C09B900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:17:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC5865AC4D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:17:49 +0000 (UTC)
X-FDA: 83776322658.30.90D4F2F
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id EAD0E140013
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:17:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DoxHu5Bl;
	spf=pass (imf26.hostedemail.com: domain of 3WjaeaAYKCIsz92xD9v33v0t.r310x29C-11zAprz.36v@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3WjaeaAYKCIsz92xD9v33v0t.r310x29C-11zAprz.36v@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755199068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZza0Qr24kX4zeRfch0J1JO+Vr53b7hyjzL3yynCoQA=;
	b=tj8GCd3ZfWAnjGIUBXK0BydVL+myuQYx+pQ1YY/7Aq3Et8HzGRBFZuKwAJqtOFM2B4VoS+
	z6S3dsr8pD1TWVfXQsIWhW/wb9G9c9ZQ1rYFbNKXCN8zgZS1PLttClWTBBRpSoUajeY/5F
	jTOGaowge9xlHREhE0ir1Ov1Ff9cDlA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DoxHu5Bl;
	spf=pass (imf26.hostedemail.com: domain of 3WjaeaAYKCIsz92xD9v33v0t.r310x29C-11zAprz.36v@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3WjaeaAYKCIsz92xD9v33v0t.r310x29C-11zAprz.36v@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755199068; a=rsa-sha256;
	cv=none;
	b=m3IZMtFUUw7BWGGBitPuiZyxFJypMCSZKfHcVFz4wqUm5XQC7oNG8Y3MtfsxoWk1aQ5QiK
	xE/Txqe4hZs8bF7YRxrKFIrO+9WscmvWOayUwgx/WUL+36mZ6IeIW4WgLn8i36vf4/RraH
	LNzjayROcVmKn3SBDIoUcetlVy7ieas=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47174b2582so1841906a12.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755199067; x=1755803867; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EZza0Qr24kX4zeRfch0J1JO+Vr53b7hyjzL3yynCoQA=;
        b=DoxHu5Bl7CYBSo/6NNVWaUs9/w5zBQp797Tw8dnp0xeM0AvJDLI5S41vi6lJ549afL
         pSAx02GGqPcSKKo2l8w94eZDB1MhU0qmAQFGOeHyggySX/3bUYt0YCe74i9HxPF3ez1R
         dVW//sJWzwgnBLd6ajdOQ0bL0R6TRYHYgojMENy6crqC05pTixLTtIttddHY/3ycLQbP
         9zUX7heNoldgmYszuRrPWZbtnPJ8a42YI+Tecz/arT3XxeeBc9sbttiCNsZmI+Lb1RYD
         I27kFmuw4LooNF+EwB4PmZYutBEn5P1QAD3K1LV9WPu56MTraD6awIIuLhaRyMvf8ljV
         mOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755199067; x=1755803867;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EZza0Qr24kX4zeRfch0J1JO+Vr53b7hyjzL3yynCoQA=;
        b=SMG/HPUgb/8X03WuxK/MA1gVkbrg2PgOy0hncCo/qPzjHvg70AHnIsZJH9hf2aSjJE
         iRe40tM83+b5WgQ/+SUjKBJZcDpwRpAlfiOP1aRvLGUjyGix0O+FieROnfdV6Tizro8U
         9NV9n29O9UCuYAWJWHp9MSzA3lauVr7YwbN0vfS5hUAu+tvq5BbksZXXm4bHvx7eQ2oy
         zgsvgcPIQhGIwHtOQ3zeawmZVfqsKTIQBCCCWCO2xRNuxRrN9SELrCIyg43kfKML8yGi
         ZQ/4MwS9jxfYMRhlMdsTN7K/sSR/3iHlH/qZNxUeayWLFRd8XWD4jl720WmsB5O3NC1P
         7Lsg==
X-Forwarded-Encrypted: i=1; AJvYcCWjlA4YLHnxk17RzTnFyuOd9Dx6I4QbYVzF616l/eQmd/h9y1YVuUQ5uslGe1Tmv8X7y3t6fL2txA==@kvack.org
X-Gm-Message-State: AOJu0YyLoUmcl1WUbimlPz4NIbNT4cAI48wfFCEN4i2PKTn0SHpVaPm3
	Chd4lSg7RCBe6Hip9u7gANfNF5WaCS+6GI5aXMLbwQmsEnbKuq3/tV+XhJiANeOGp2HC/cZbmwl
	J4gOLug==
X-Google-Smtp-Source: AGHT+IF8M48EbLNDh3PUuZR9X+h4b9X+7Ma3XKAwBjlInmKrGPQbmdm3UVCpaMvvU/zhWWLLunWDR1msQ18=
X-Received: from pfbdf9.prod.google.com ([2002:a05:6a00:4709:b0:76e:26c9:b2a9])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a8:b0:23d:d9dd:8e4f
 with SMTP id adf61e73a8af0-240bd238d7dmr6038674637.28.1755199066655; Thu, 14
 Aug 2025 12:17:46 -0700 (PDT)
Date: Thu, 14 Aug 2025 19:17:41 +0000
In-Reply-To: <ukfrq6ybrbb2yds5duyj2ms6i7xgssjsywzgknxctfgkpzupor@tjxbuiil5ptt>
Mime-Version: 1.0
References: <ukfrq6ybrbb2yds5duyj2ms6i7xgssjsywzgknxctfgkpzupor@tjxbuiil5ptt>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814191745.853134-1-kuniyu@google.com>
Subject: Re: [PATCH v3 net-next 01/12] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: mkoutny@suse.com
Cc: akpm@linux-foundation.org, almasrymina@google.com, cgroups@vger.kernel.org, 
	davem@davemloft.net, edumazet@google.com, geliang@kernel.org, 
	hannes@cmpxchg.org, horms@kernel.org, kuba@kernel.org, kuni1840@gmail.com, 
	kuniyu@google.com, linux-mm@kvack.org, martineau@kernel.org, 
	matttbe@kernel.org, mhocko@kernel.org, mptcp@lists.linux.dev, 
	muchun.song@linux.dev, ncardwell@google.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	tj@kernel.org, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EAD0E140013
X-Rspam-User: 
X-Stat-Signature: kgbcrskq8bhoxwh78k7jphxwp15tp9by
X-Rspamd-Server: rspam09
X-HE-Tag: 1755199067-506394
X-HE-Meta: U2FsdGVkX18vm3EDO7h5Jc7EOwsub44zYHvYl+6iELLEW91X7LkKuynN3mS1iqt5lFz1FUK/QPYvUafJkks7ZKeiBLuL6NgykiWi9TDqJyzXis1d5HbzZDrUWTdiE/C5zaKCnHbjZlm8nx9eNoTayQHblw+jDetB+SHSvt+cx4QrQmfx+6bsaS0tXn7gIXBu/gLWDDnyRNas2qSBS/vt0PyuKZZ/JVzxxtIo4DSpI9bqENoF1hUuXsZ1waUwnGrvzAG43X0M2mDHqCERUJxyDnhUjfBUprTsNVIhql3KEx+uek2OWKJQCtWCPLXn9FhcWq85xIR36pmBzMvGT7Alc03uYTEz3ZJA1FcgJ2Py6hxisR2KAjyCC3m6lXJ+jlViNeQyL7iEfscSS9D6xaV6GIjC+akCRIOfLtIMSbh2GXFdSIvvD6/+ACtV4R5+on9WEwzs3RKzs0x9vCpKfMDRUoVQLs+p+g+vh+7TsQHp/KutjVMzVbiuB4Z920rjWRmm9iIpOAL0GnGHFJTKiiOrSF8kr5GcI1mTrU3Mdq8xGHt2dKztHvIg6Fc1c/K+oxEs4BBj0MuhpVPbTaXHwumZlEmzmAtWaa4yGl7ze4e6ks6xSRlzVfvEjPrrnpIewWHp3IUOne94dsl7Gc9Tb9fyjC1ndSu+svkNwqu8CAZ4CsXIjEoZOjX6A5Jm+VVtE0KmNauBupqY8P6QJCWiSjh3fEfmM0KsFI2RdrMA62y1Mc1T3SAoFvQH/38zxYdbBKabLW39XAzaToz/pW753NXJSpmiK5RNLPf4M8bWZPIwhEuXEVkC940e6VPDbm+7NxL5OGRCe2bFO4dVDPqJKwysCILzM5Q6WYWfp5HxYXR2W7sMkWoOQRam/Ft8IQLmYDQV4rQwBhFWimasDQzaJHY1CZII11DCuunx22c0m18maGFuPFBLAGDLEQEMWwVP84k5XzA8rrBOCfDCnswz9vJ
 5ot+uemQ
 J1+1gPmAA//lpfMSbsUZfqprIL9QwJmrYQu3eEvmZqMDbkUVyMMMR2ikvjvNg+tMuAyJQQ6XO1cPb9kCuXtpQiaMseOasr0kNHANgTqQu5xqsHvTFOGVk/RofQ+pe/THdBMk3Tc9LOJQ/VimALs0uynamezw1nFScqngLBtcRk+L78YcdzVsOOEsk6Qto78i1ODMiU+s5EsNaHZcW2vmU+qxm5jW5wpvrhjlqXG9pIvb4lClD0VxNFNo0NSJcWDXwj2uYrfz0K9003Hj5ezCH7THPLO+RWvo3526VczyE0li2k1Dy1OzulyORYdB2dlLqpRHRc1sXdsMee0m/X8N+7XO8F8ROEpt/AxMC9Cg8NYhdtFahUeOCRRfaOODW6NQARiHAQEMhkO65IYGQHRB7nrP9VsIFNa6+WA4/3Ht++uPpQCehmAhijVs93lapjfEBT8eKF3IG4yy8dx1NS6Sxu5FkFBUrpYmWX3t3z0vaE34TqF3gwVXAkXp5Q27gLFxZ5zNAOV01I1wu8kGEFZDV6IH7h+I5PyGdOm2H9KXR5w4SGHWnsgez/A3n0eV+KlhMYPhSny4ybt3UfLy9y0I8ks9nyzR7MAKZgovUB3EZQp0F00y/ksClCxEcU+w8bM7RCkHXmL2x5D41gSM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Michal Koutn=C3=BD" <mkoutny@suse.com>
Date: Thu, 14 Aug 2025 14:30:05 +0200
> Hello.
>=20
> On Tue, Aug 12, 2025 at 05:58:19PM +0000, Kuniyuki Iwashima <kuniyu@googl=
e.com> wrote:
> > When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> > sk->sk_memcg based on the current task.
> >=20
> > MPTCP subflow socket creation is triggered from userspace or
> > an in-kernel worker.
>=20
> I somewhat remembered
> d752a4986532c ("net: memcg: late association of sock to memcg")
>=20
> but IIUC this MPTCP codepath, the socket would never be visible to
> userspace nor manipulated from a proper process context, so there is no
> option to defer the association in similar fashion, correct?
>=20
> Then, I wonder whether this isn't a scenario for
> 	o =3D set_active_memcg(sk->sk_memcg);
> 	newsk =3D  sk_alloc();
> 	...
> 	set_active_memcg(o);
>=20
> i.e. utilize the existing remote charging infra instead of introducing
> specific mem_cgroup_sk_inherit() helper.

Sounds good to me.  sock_create_kern() is much larger than
other set_active_memcg() users, most of which just wrap simple
alloc() functions, but probably that's okay.

I'll use this in the next version.

Thanks!

---8<---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..450862e7fd7a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 	if (!in_task())
 		return;
=20
+	memcg =3D current->active_memcg;
+
 	rcu_read_lock();
-	memcg =3D mem_cgroup_from_task(current);
+	if (likely(!memcg))
+		memcg =3D mem_cgroup_from_task(current);
 	if (mem_cgroup_is_root(memcg))
 		goto out;
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem_active(me=
mcg))
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3f1b62a9fe88..a4809054ea6c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1717,14 +1717,6 @@ static void mptcp_attach_cgroup(struct sock *parent,=
 struct sock *child)
 	/* only the additional subflows created by kworkers have to be modified *=
/
 	if (cgroup_id(sock_cgroup_ptr(parent_skcd)) !=3D
 	    cgroup_id(sock_cgroup_ptr(child_skcd))) {
-#ifdef CONFIG_MEMCG
-		struct mem_cgroup *memcg =3D parent->sk_memcg;
-
-		mem_cgroup_sk_free(child);
-		if (memcg && css_tryget(&memcg->css))
-			child->sk_memcg =3D memcg;
-#endif /* CONFIG_MEMCG */
-
 		cgroup_sk_free(child_skcd);
 		*child_skcd =3D *parent_skcd;
 		cgroup_sk_clone(child_skcd);
@@ -1757,6 +1749,7 @@ int mptcp_subflow_create_socket(struct sock *sk, unsi=
gned short family,
 {
 	struct mptcp_subflow_context *subflow;
 	struct net *net =3D sock_net(sk);
+	struct mem_cgroup *memcg;
 	struct socket *sf;
 	int err;
=20
@@ -1766,7 +1759,9 @@ int mptcp_subflow_create_socket(struct sock *sk, unsi=
gned short family,
 	if (unlikely(!sk->sk_socket))
 		return -EINVAL;
=20
+	memcg =3D set_active_memcg(sk->sk_memcg);
 	err =3D sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP, &sf);
+	set_active_memcg(memcg);
 	if (err)
 		return err;
=20
---8<---

