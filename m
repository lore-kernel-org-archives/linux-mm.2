Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39067CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A589001D4; Thu, 14 Aug 2025 16:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B1D900172; Thu, 14 Aug 2025 16:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC199001D4; Thu, 14 Aug 2025 16:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 907CC900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49FED1A0455
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:28 +0000 (UTC)
X-FDA: 83776452816.02.0001F28
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FEBB4000B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755202166; a=rsa-sha256;
	cv=pass;
	b=A4FJ/QZsAxttQ8hj7/c+iUvRYuVFRPPEnKWr3LTe1MnzoN5rG2wG++DKfKHZwev3tlB0Vx
	jF/uxa/YgTMUUp4iT7Z4A/IG0slxQf7UkjJGmJS+Bgr3cO59RHa5MlNZSYKO93qjEGvRGj
	zDiw1FpJKDW6Tal5hRHDyNa3756zCSQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLtDPiqLV2EwRjVXqP4rO8+jmE13TnvcBQt499JidQE=;
	b=JRdSh7RBUG86CW3bxbBXGDZkY0fCHo4ZyOEN7DBAHSUxVduSwsd1lITon+2imUfaKvgOi6
	V/tF2jj7ajMK8OneL9w0YWNSdGweD+H5TpWyZw3fIAr8Pf9qeuv7IQCH8DlJA/LrJUEEuJ
	ytmoRydgk9KeNeSA/KzplcQgqTkUwO8=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC488140769
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:25 +0000 (UTC)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CC171A07CD
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:25 +0000 (UTC)
X-FDA: 83776452690.24.1106732
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9CA73100003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:23 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLtDPiqLV2EwRjVXqP4rO8+jmE13TnvcBQt499JidQE=;
	b=vQ7lb2DETBihb3Xujtj/BmC1mVNxP5PBgLhWQC2DKF8/Ie+fZcUGVl9u1FGVmNYyyNKmqe
	T8oXx+HpObvJ3Elmqz9hy2AHdGhDa6drG8elRpky+OyElxHkPIKRd1GSvS+aDBm7v2rWK7
	yWCot/19oWKAOB6+XhP7ECWbzMwXKjE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LyQgQfsd;
	spf=pass (imf14.hostedemail.com: domain of 3ckKeaAYKCLslvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ckKeaAYKCLslvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202163; a=rsa-sha256;
	cv=none;
	b=6oIVxb5SxIkJU8madGY2PMMrV9JO/OALS2Vdm38Cfy9vOeQIBwW3ZEJNvAJxCWLEI/M7dJ
	1MKJdPXAcyguc8QHJEVQIVRDKVTHuYomFbyLUT+okAbVLuhUdw9rR2tOFBNupWdk57G19A
	c9Szu+m3nxOG5ELN/hGsLz9xh/Levjo=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326bed374so1283061a91.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202162; x=1755806962; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jLtDPiqLV2EwRjVXqP4rO8+jmE13TnvcBQt499JidQE=;
        b=LyQgQfsdFIS3p72WYjPrOEJJ+YqLMuTYMU04V1452dJqqMkgW55jIxdxlZbDmP6QJl
         WFlL3OLjMZwjgZoqxzB9ZZ0YW+WUEc0MoT+OWZwCeRFwk6vEtX2kk9pqKJHUelJ387mi
         w32Ob/sTlP0SLd9DsvN2dPGvNJ915bz+nWyIXw0PddiLOn+utC3pFn8fQecd8b0jl+qV
         XjcS64f4Ct2+vxb651CgMNw0i5p71zrz20YyBf6Vk62/W6xt7IQwNQ236SpsgqJg6lek
         XhLe1e2OEyt+lflv4RGxscWA2rOrXNWaU4G5rRdZIZJfqVZP8eSLU/OIGncsxHHi3ln6
         xoJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202162; x=1755806962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jLtDPiqLV2EwRjVXqP4rO8+jmE13TnvcBQt499JidQE=;
        b=VNtDxbfNmEVH4lvudcFN4lcnAyLBZ6sIKTgFRjPHWCxv4IVPNeXP1vwgqnw9uIr8cM
         V1nWAY+rVwnyFLV97TiemzVddDG0DLsZkZdhBOpCouh7DKYIB19Q+6jYS+MaumlUtVrI
         3CaOHnSkaXwTncX5YN1dEqNV18WPBY047WuxZs6nm3AU+xA9o+bAD/Gv7RP2049VpvA7
         6SpM3ueHf/PSvmIxPKKkbLcvrJuoHgv0sJxj9nrbR2eLKTpLm5Mx01lQulfC5GfycvrW
         MrIUJEZWdDcLHbp/VnGA4PtrHEM89K5Y0di2GSOdx0Hn8AFTnglAoAYz0KDtziMuvYWv
         rcqA==
X-Forwarded-Encrypted: i=1; AJvYcCX20VznYIfB6gzfPn5rZ7mD/WW68uDMGaQuBspzmB7Dp2+PV9peZF4yVPrJbE/zELKvEpgQfNznVQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1poS4bGEklR2XN8AAPHdg0yHFlswwUOetjMweWLz4vXcENjO4
	edwAlOgMEbKQVMm0tXb9/TfXVN7+Uh3VJpiPWdcDQ4yHBF+9YEoH7uh8P66h4GE456UF7C1GOAM
	DeccyRg==
X-Google-Smtp-Source: AGHT+IEnzVgsHouLcYJ3DbTYMYM7D5PJ04rrOa932tYqe/x5EOD8K/0yHeBrLPiiLhvGRF5AWh06+mbah1w=
X-Received: from pjzz12.prod.google.com ([2002:a17:90b:58ec:b0:321:ab51:e32a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5246:b0:31e:d4e3:4015
 with SMTP id 98e67ed59e1d1-323279a165cmr7184331a91.8.1755202162465; Thu, 14
 Aug 2025 13:09:22 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:37 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-6-kuniyu@google.com>
Subject: [PATCH v4 net-next 05/10] net: Clean up __sk_mem_raise_allocated().
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
X-HE-Meta: U2FsdGVkX18S9s969h3wpSyREkJzanHyCPz1Bjcp5RGNj/ylgFJUerdGvyfFLO+GoEV/OaQDkicSCl20GSf2qYmJ5gBmdZclRiCCRBquMpWyorFYhwD1K44MSIFelP8MExNlISQoJQ/eeDJTh246+38B62CmCSBVJy2JgDcru3BijJYFluS6cLiF/a3yT/wUHV99Ll9MW89rDJMQQIeVJPBNvSmR66arvxJk3GZN/eIdBRa268DkVNbF1d/AQFVAqIj75dJhul5VastwVgvall5Y2R+XFBWR/uC/yRicnw0kxRbdYQwpw7nlSUuubeKaKChDJHKcJrWHcHSVCkJR13XDpYKuzwFlyjHiydErt+r1k3LtvlJNPThy7ZsaNIeoTjF+35n3XWoK4j2oMFGDQXRR2pFzOFlftSgxxqL7a/2HDO0m31ZxvQVdyWq99xMFFCj2j3EhWjIKoj/3EjmsRWig9WqTJ9pKcrziK0FBtHU7X8aLZJG86q5MKlhS6TvYmBXW3K5CqO9oeS3aS7D6WE0ifxJbHo+OYTKSnphwY15V3DRv/55rHYiE//SEo5oeieAwkwoj9FKCzFdTTvl15m+ByjIGOvi4di+p/ki6ELdBkuXb567ys/D5VIFxN1a3dWNHH7mAeo6SulyK2BXOJphy6XhTSzikoQ5b3kLlVsCO/s4qNSE6JZNbNWmqZqXrMHbaRNK7ouN4g+T9kwv5Kwye3ZTMjL1LiRkBeJ7zkRqI2FL3KfwOxK6zpduK9Bd8tkawuBZw1SnSUBHXgf6IEImEdFT6jx5+1TAZG7HfOBYRc0p47JgwbGMRi3A311mi3yHLA/fQbLdjGC2rzX6pUcjFkDq2PcUUkarsY/PdRMtCzxYIipsDzTTq915AuvyM7qcsGjZDyXVXyO+l3tUt8n/jOfOogGzcsmWGY2sfOA4418QZkAiMacyMAPxcmQNnE4u1hrkSW3c8eeXtvHZ
 lheMeEPe
 pWhddtyaIV0ywIij52CYt5j5rICuxh+LY8VJ8/tQvznqUGOjby96STVkpwu1VhRTJC0Iq3AC16HGArLbX2fJ405/ENba2cD1Ji1HUsMKQALkQdzSh4/1uOceo5CXBAD8ukntHBRqGhAH4PQQVdyMvFcB8RpnnvnTEUSK/7WVoxUqbyGzE287LQUcUREQFYtvH7bKGME6wVO665QKYiAojZRAMhH/5LHoMZKAtnG537pwnOx6j/yq+O1qc2EYOvaNxCaaTYfjrWWhXv+2DMq2Pb+zWKAtXnY4F/fPjefndzvKyPdo7B81AloU5f6/l3myennlLkbVX8rXBfeNWIn7qa0ejBqY+GNjdSA1cdtA26cDIo/ymblRPH43KDrQFOOC9v43max3iCzD9cyGeJf8l/2kZK1ZPawxM/sCwQdJR/28R7QYqdPA8zkEizK6IR0Yh1ISzZfgocbTUGd/a2hgDawb+ckqkvzGpF/iXRmOajFnu2FtEZbMkhNM1r8lQU8Z69GYYTDR++30ebIeHrF08+Cl0Ly1AxBvmDjXcuIJZhqNy5Oq+u/Tbvo2L2f1i3Iwzw//FEVJTtlzdYgLuQbCtQQ6/lg==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FEBB4000B
X-Stat-Signature: 76ann4785wsoapd148ibyriwi9skehn9
X-HE-Tag-Orig: 1755202163-568330
X-Rspam-User: 
X-HE-Tag: 1755202166-142620
X-HE-Meta: U2FsdGVkX1/MdCtgVnBP+QKEKn2SPE2c0dshh4TKgPfdr8v4xOieUl1IVhdvNO+Hird3+2MimreWzIWekE8RgpiDWVTpKMCJD4n3OrmYcbHCNx6fBi7ID/8+NNj0xv3TgWBei+XcwxabgS05OQkTAtATSFmGtLG2bQs6vN6Vt2r7HPjsVaQj3DJHZRpuGwjPPAbZTslr7dAc59iiDvrf/AHz0YEhKs+/apGblwmzFfJN9oCGLdBlXIHW/ZPxcvILwEor3kFDJn2wb+pJJ1LbkJQFqjZXZISL4VPhLNbfLaa6D3uVqceF50UyvFTRNhRkTLOT3BKUt0ujR21ZrxU3b4VGMDctdEqh8RqayNA8HjBMaUxJoXOrV1MqJg72f4kRduRxiFqhkPf1Nd0JxsZN7tvJSHf7xZ/C1Ovo0++75tK4P/zLPtDWfa1GTWzmmn9Qj9jIz+rLGOJAIu4Ls2dnxD0pcAiVRR3N1f+3tlMChOmzzpe57Z/fdHZgik+dMXPwxGCQ2w6eCT7rBbWny87LMc+NoyljShuH/eTQyXLDpUkLVIMK6mtrBxaG/XWhQe3/yBRa6nLvg4CO9LOwWc495UyosC8NBy9E94roayROoOp+2o3BqAlOkFMDnHH3/lrfkwaEf/ggBu6+nil2z5hv+AEBLpIpX+EQk+kHKGAfMez8HbS20Hr4Z9r/KUTcBCkMlaocNHNOWkyT7SHOCzfIUeeUeJGGTdfQjXEI5Y9H2E78OSJN8TzsIsyZQlVf8BXAjMSZDZKA0LktyXSU8L/p209BS0ZoTdNjr2yS/yp0U8lu6LijvVu7DLgVVn5EWPo6NAx0rnvwDEf1k8xWWjN7cDnajpj8V/PKzAh/yEL67QoEJEriiIA2Fu0O/fqPJZUDq/pQPBg/D9qEwIITe1nrYBHO24BN0nNJBiuMkA30JFjgT8BmprIrF98Gt5yMgNkRR70BO5RlIgagr1/a5v7
 ejUABEe5
 UQRGyTAeK6Ncm7Txh/WRdj8UxsG4SS/ZWr0hCvZasBg6ylocjFpcb1uGwRIrY70hQktCdiMZ7OL60WDWCNszmfPvXl4QWBdnnsR+p126Spe1eQTPByOpJD6gAhUqy3qwzLvQt4sTlptyhSuxhBdOavqYE+7FW3aZxRNiIGn18UK/e87DOajDoPRchNOQNb/tAGb8JUA5pBkZZkRi0dBwgxJhQZTomJdezKK5xgVcuJaX3qg6OSxdEcpCtOcbBS9Us8Q09iedRH0GVKuPiFZxiaQcwXZj0SH5dnK6W7DRcmAlosLfyWd1wgvidDDeNXUTvjKvhEDaoLbldgBgF+YSQQaeVnqJ1wTmQpMziQaH1YGCdQhhqK3Y+Cd8ExzXC37IFQbRyj2yEwKBgPEXQpaQ3vYek19hnMFcpxkh2NivuVJXS7yhnGYbTzYz/uUqXtNuV6cuzacd9dTLyj9E62NNH95eWqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In __sk_mem_raise_allocated(), charged is initialised as true due
to the weird condition removed in the previous patch.

It makes the variable unreliable by itself, so we have to check
another variable, memcg, in advance.

Also, we will factorise the common check below for memcg later.

    if (mem_cgroup_sockets_enabled && sk->sk_memcg)

As a prep, let's initialise charged as false and memcg as NULL.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 380bc1aa6982..000940ecf360 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3263,15 +3263,16 @@ EXPORT_SYMBOL(sk_wait_data);
  */
 int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
-	struct mem_cgroup *memcg = mem_cgroup_sockets_enabled ? sk->sk_memcg : NULL;
 	struct proto *prot = sk->sk_prot;
-	bool charged = true;
+	struct mem_cgroup *memcg = NULL;
+	bool charged = false;
 	long allocated;
 
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
 
-	if (memcg) {
+	if (mem_cgroup_sockets_enabled && sk->sk_memcg) {
+		memcg = sk->sk_memcg;
 		charged = mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge());
 		if (!charged)
 			goto suppress_allocation;
@@ -3358,7 +3359,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	sk_memory_allocated_sub(sk, amt);
 
-	if (memcg && charged)
+	if (charged)
 		mem_cgroup_uncharge_skmem(memcg, amt);
 
 	return 0;
-- 
2.51.0.rc1.163.g2494970778-goog



