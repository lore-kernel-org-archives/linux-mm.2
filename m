Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61410C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A7D6B008C; Thu, 24 Sep 2026 05:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4241F6B0092; Thu, 24 Sep 2026 05:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ECBC6B0093; Thu, 24 Sep 2026 05:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02B606B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:56:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 898BC1C2336
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:56:05 +0000 (UTC)
X-FDA: 85248199890.08.B1FB543
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9D215180005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:56:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vo6d4MlR;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of edumazet@google.com designates 74.125.230.235 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790243763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rM8Pnb3OaTJqlPgDl5Nu230H8PB3TRPyBVd+A2AcpH4=;
	b=vw0oEFVSCZs35WVwr0lASRUXqLkE/3+1yp4ADQ9yEMwWlZXt1cPEtqb7dekm3wEv1mxW+w
	qVdAd6F/MuTKBmybgC8zhUPABNDMOA93lCC11ycthLhQwwdPtDHzP20Hw0LbGLYMe1d10s
	QLPfE8iNFDuIqHZuYa7x84qauVKiNl8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vo6d4MlR;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of edumazet@google.com designates 74.125.230.235 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790243763;
	b=1WMsjJUOHCaFnEhIZCOtRx0CkWtg7xQHtlz/F/DgTpYVe4Tfa1E7nyUSbEsS8C6gI/LmfH
	QoQOjG4h/pbU5sn3MQCEEdJz1SD9hZLr/X12JSXZamifDtRj8zUxRRF4My6cFilVZ9jjzQ
	dPiR7eLFjOslPRd23FIBCH7JvEGnyZg=
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb769ca02so18538861cf.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:56:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790243763; cv=none;
        d=google.com; s=arc-20260327;
        b=aFluo5DK4bD9pOHZ/+dkpdb6HIq7axFaWwjQTBnMC730xyK9u94+e7CStjdH0a6BRP
         s0B9IdV9GqBmxYUs9iY3NkiealrQgLorrmV6NdgHwZRqjOPTZW/AgtVOmJep3JtzxNJw
         2DTT3H/E9DjS15saXKMZrszVjelRsgjDKUpfRIHoIBZIUb1qB6asp78DEDag0fUNuqRu
         6lr2UeIFgsAMM8Y0r/CyTdbmcqaqZnNw7Uj46OoQax1EOMgnxp6lAawEbzAsNno7NG7i
         aKrRF0tO7Eghkuqe2FbodWqgHrTS97FInsxCpk9W1xVIKb6FjRRQlgfQseT02KpBkCMw
         RBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rM8Pnb3OaTJqlPgDl5Nu230H8PB3TRPyBVd+A2AcpH4=;
        fh=dgoKKHfPy7aXN+1gnJ0j+vK4y8kI85MbE3+QfQDzQBc=;
        b=F9ALz1xFxjrItHs0+IbPWFVQMiuutBSnIC09qZkAHntAC2xxLX9juwbs7rGdxnyP7d
         pz+tS7mowOiHWMOsoSZuYW9CaA0xqh7U/WDrY01zgPCGspbYGhOKMMK/7oPkkANyLkqE
         8AAq9tpc92wz/nhaTfAkEAsx4yYsVR4ktjKun+HI/LrRobvby4hG7sisCOZpaRMcWdE2
         Ic9No9KUoUpZ1bUhGm8Lkfe3R9EYOQnlHycdvk4hvq4XLeCmh9hkjFkcArDSw9GpE70y
         GH6wHmZXvfU2NXPoEV+uIWubTfPZ7011Efd4prsoPLO/oP3NxEExN3h7DfDp/7aq5SsO
         f5kA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790243763; x=1790848563; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rM8Pnb3OaTJqlPgDl5Nu230H8PB3TRPyBVd+A2AcpH4=;
        b=Vo6d4MlRdWj5Fhzai5xBkT59O2bLe9jyDHhaQ8pIXOCosSdvH+SZ+DAjC75cj8euYx
         GysFJGNmkoC9a/EKWb23DCGEdY3G/N0lST61c1tWpWMgeRVnTolbMsGdg4QE+w+8VZ6k
         nxvXxwGFzEq71gKODqoEunoSsWeyS2AwA41+xGoGj4rY0uUgky8tT0pqCnf47JL5CGIb
         v9fmpnaT3LUOy/kkJlrlKy1KcfN9AUh9CLUAnBXJ76uPfQHU8rCMEimHK5fqW6/MG6hZ
         9XvtaUy835L172NYK53pnanRGTW/RJVLlqOXr8MP3XMbyyWL8gSMTDScMs+X9JeKGsz8
         twUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790243763; x=1790848563;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rM8Pnb3OaTJqlPgDl5Nu230H8PB3TRPyBVd+A2AcpH4=;
        b=VvZF8zhPVhpzilSI+EX22i7cluYlhnJT9OQSFGg9W5Lutxp+/U0TvA10g3rYyDTU0y
         VcQ5HGNXXbcA4YIpx6/yeKomtDYYUFwjbZhiNezVvAQyuA3Iil+OVt/MnzjmOqYXUwkW
         +C4Y0g4D1CtIV43h/qAr0jIIwhibkRxlMbw8FsLRq55tqBYo+svrhVag3VM+izTCzxsu
         uQiiXZGkuchSzaIyx0oFZ2vTlfgJNVNmGbdv0DQKr70T6OLLi+PFGYa4radGbeR/q6Pq
         RoYbxcO70RU/dkzZPVSWb8J73Xjxbu7NwJZNMw2GJ1Rre4lPvVCf8ryo56KG52MBvWZR
         5ofQ==
X-Forwarded-Encrypted: i=1; AKwUvBymZ9t4RTVcZn1tZYZgEHO1jeKTU2s6mm/6mORVL27pikX9hv0oPHuXrQqOjv4597ULmgJt/CVaDw==@kvack.org
X-Gm-Message-State: AFuF++mu78lYPpH8RmOX2z3kLbsmXniw4Ge+Un2TBOAIzQKYZ6o5VyTv
	5oqGVsH39KI3tSH7SoaudsGiFVqklfpGHm4kTdLg4t75Fva80Epmqwdcg7d9TcSPcnY3ELSWTWY
	0s/xgYQv/8hpHR00qQBRMbpyWcNMBywwA42bBqgkR
X-Gm-Gg: AYBFou2cjMxk9HgEXtUWmxDwUb43Oys4FjVD6XcoE7LFb7P5tXR8D/yQeYn6rOgdBxb
	p3tvI/hH2KEOIW/czjrPKbtcJ53FHHh9HkiLeV6VIlGqsYtr6kvm1mwseEb0RTzNkHE35+1QXrp
	7ZUE7cDKTJRv5o/Ok7ruzvTNS1b0i3LAKk2rj+9+dKwva0ZpNS+wMerPqZxo6Wa4fP2Tc2du6JP
	fDo1R6Z151rG6Z399BLT06/ItpMeXGTqNZOTbuZV18W4uhootQl6yeClnRqd3AeLQP7tVcK7Qg2
	8klSrWOnguH0tf3s3+ikfvOTYzphzt39V4mroISCp8vHfw3u5PJpYOkA4WPano33LpQL64UwTV5
	LfwoPB9jjDZ/Nh6XZO3Zy9kcFMFSsZ1OBkdFm8xrQ+Ym5HD2YtW86wCqYdEB4/q8JZk55
X-Received: by 2002:a05:622a:5a0f:b0:532:8f15:2744 with SMTP id
 d75a77b69052e-532fea4d150mr14339051cf.20.1790243762050; Thu, 24 Sep 2026
 02:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
 <CANn89iJVGmYwQerOixGurH6vw-GtvSAQq6u6zSNZoyZrcEx6Jw@mail.gmail.com> <d8c12b4e-4ff2-4c62-a40d-d67bb4680a0d@huawei.com>
In-Reply-To: <d8c12b4e-4ff2-4c62-a40d-d67bb4680a0d@huawei.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 24 Sep 2026 11:55:50 +0200
X-Gm-Features: AclHuK_LOWvzBhJczhAfbtW30YiVgV1gD1vN5_bi3qPOiAKB6UaaHqyDAfOb9kg
Message-ID: <CANn89iLA55e6evpx__7AUQF45uYAbUHxRtz4rVT=vsKpqBRWkA@mail.gmail.com>
Subject: Re: [PATCH RFC -next 0/5] net: charge socket memory budget to memcg upfront
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, kuniyu@google.com, 
	pabeni@redhat.com, willemb@google.com, davem@davemloft.net, kuba@kernel.org, 
	horms@kernel.org, ncardwell@google.com, matttbe@kernel.org, 
	martineau@kernel.org, geliang@kernel.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wxp57bnqy5hm9cg8xrhhqr8rnrepdnk8
X-Rspamd-Queue-Id: 9D215180005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790243763-932992
X-HE-Meta: U2FsdGVkX1+VGk7gRhKxqTKEUE7pkTMefCws4WMiUmemEIfyhA0BB0ZvXqYthcwLYJApirN0I0jmBNwy07SiQJ/0p/kx//4oBiVvYGWid4Y5S1M+a1V8M0TAQLbGl5MByC010tjoVkMeiXONElwF15D3/SWPY2+0PsyY4b8nKQzS+1vy4H9kioOCBzFYZzBpD0etUHN5NgnxJs1JPNSqcfCyPhPDaMDb4qGjZxC1RLk7DV+z7nCLV61NencOfQ+cy53JFYwysf9dVvcsLTOSm9Q7/OVh04r4/Tu5Ghj/t9SvOrfQ5kMKk04Sk+vCezvy1BkNHvm2THdSlBjKI6hArdWw8Vr/L76vXh5yFBNmq1OxzgyDH2Mg2LjnV3GIboQzVMXD8oScw2ISz9fadTu0UkQZUbv78Be0/+dNBnJDOnzzhCRKuqeWDqJ5GgYsKkq3kNtvvxPmo0JAEUQRtjlxGPt2eM83zv6Ncmc123Yol7aVEkS+oUeYYHsk9OeOmLurDv/mACjXw6PGH37hn6TJ/eeJ0Bxf5xQVE4LWFHDsokphnqpXtr0YqlYTPJT3pe8tu1XJ+XG7/ezC9+YUIxLKrct4G2qLRFX7CsQxA2t6ps2i3cv0PDpnIzULrAt1hfBIueLn7Louz4O90NDamDUlOjo/DjT1ulPMWw74PajOEnjGenPOU4hyRLqTvCVIK8qLMORevE1XSbjym2EUOvJsMYKvSkEa/LXW0m+549ZSV1LFKK86IFRWeJ+TkzSc0K0csrPqt4NlBaVfSveeZFnDj/IvFgkLBOZCDtBtdN/pVjdmdMnbC9xezJ2exQsbb15RiaryLACuPVd/9Qw2CtThn8rEojw0CdGNmCJKSvwtX8lOOkXfGQnYoQkRUUbwFmys/k4BYIcn9UkFz/+MirMrRWy6hJLtnex45KdmqZn8snGoJ7GSgRFAmyq/YtCYKuf+GFOoVwVu3D75HDBwnpb
 ZtxLnk+L
 E2sxeqEFjh2pOLt65e0pIZMKIXzNMw+ME9VQpfH8mZldikM6LXkdwWBNRhU8st73PCgCo0idmQBrU7cb4t3amKW0A6EUlT+zCdeSYIgVW3iNzD+NV4UAgL9q8S80w7d1xXSgVg9UqEYXcip2xAKOe9TdH7I+70R2z1gZgn1W/bH94VUp27HUzjQtVklRvw4MXXh4Pes+uXRiuSw9OyeOBGLXHnCUq4pqwdaxDD8NAb+h180yMUJ5gAuQ8Gn2sryv7m4Ie
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 11:25=E2=80=AFAM Cai Xinchen <caixinchen1@huawei.co=
m> wrote:
>
> Hi,
>
> Thank you for the review.
>
> We found that sk_forward_alloc is a plain int updated by a non-atomic
> RMW (sk_forward_alloc_add(), where even the read side is not
> READ_ONCE), and its writers span three unrelated lock domains:
>
>    - socket lock, process context: SO_RESERVE_MEM and TX grants
>       (__sk_mem_schedule(), sk_forced_mem_schedule());
>
>    - receive-queue lock, softirq: UDP RX charges and the
>       udp_rmem_release() fold;
>
>    - no lock at all: sk_mem_charge()/sk_mem_uncharge() from
>       skb_set_owner_r() and skb destructors, and the sk_mem_reclaim()
>       fold itself.
>
> Any cross-domain pair loses an update.  A lost charge is still
> returned in full by the matching skb free, so it resurfaces as a
> phantom surplus in sk_forward_alloc, and the next fold hands it back
> to the memcg via __sk_mem_reduce_allocated() ->
> mem_cgroup_sk_uncharge() - an uncharge with no matching charge.
>
> We first tried to fix it with locks, and hit three walls:
>
>    - the socket lock cannot be used: its holders free skbs (e.g.
>       tcp_recvmsg()), and the destructor's sk_mem_uncharge() would
>       need to re-acquire it - recursion.  That is why these helpers
>       are lockless in the first place;
>
>    - a new per-socket spinlock serializes the RMWs but not the bug:
>       __sk_mem_schedule() publishes the grant before the memcg charge,
>       and the charge may sleep (GFP_KERNEL, memcg reclaim/OOM), so no
>       spinlock can cover both steps; a fold in that window can still
>       refund pages whose charge afterwards fails;
>
>    - such a lock would also sit on the per-packet charge/uncharge
>       paths, exactly the hot path the cacheline layout around
>       sk_forward_alloc was tuned to keep cheap.
>
> Are there any good solutions to solve this problem?

Perfect, you now gave us what we need.

UDP is broken, it should be easy to fix without breaking TCP.

I am surprised your LLM went to a completelly broken path.

sk_forward_alloc is never supposed to be updated locklessly across
multiple lock domains:

- For TCP, sk_forward_alloc is strictly serialized by the socket lock
  (lock_sock / bh_lock_sock). TCP does not use sock_rfree() as an skb
  destructor (sk_mem_uncharge() is called under the socket lock in
  tcp_eat_recv_skb() and sk_wmem_free_skb(), while TX destructors
  sock_wfree() / tcp_wfree() only touch sk_wmem_alloc).

- For UDP, sk_forward_alloc is serialized by sk->sk_receive_queue.lock
  (in __udp_enqueue_schedule_skb() and udp_rmem_release()).

Your reproducer and analysis point to two specific places that violate
these locking rules:

1. SO_RESERVE_MEM on UDP sockets:
   SO_RESERVE_MEM (commit 2bb2f5fb21b0, "net: add new socket option
   SO_RESERVE_MEM") was designed for TCP, where sk_forward_alloc is
   protected by lock_sock(sk) and sk_mem_reclaim() checks
   sk_unused_reserved_mem(sk).

   However, sock_reserve_memory() only checks sk_has_account(sk), which
   also matches UDP. UDP does not support SO_RESERVE_MEM:
   udp_rmem_release() does not check sk_unused_reserved_mem(sk) (so the
   first recv() reclaims the reserved pages from sk_forward_alloc), and
   setsockopt(SO_RESERVE_MEM) only holds lock_sock(sk) instead of
   sk->sk_receive_queue.lock, racing with __udp_enqueue_schedule_skb()
   and udp_rmem_release().

   We can fix this directly in sock_reserve_memory():
diff --git a/net/core/sock.c b/net/core/sock.c
index 1d5927cd49a1..763c2017d9ef 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1034,7 +1034,7 @@ static int sock_reserve_memory(struct sock *sk, int b=
ytes)
  bool charged;
  int pages;

- if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
+ if (!mem_cgroup_sk_enabled(sk) || !sk_is_tcp(sk))
  return -EOPNOTSUPP;

2. BPF sockmap (net/core/skmsg.c):
   As you noted in the reproducer comments, sk_psock_skb_ingress() and
   sk_psock_skb_ingress_self() call sk_rmem_schedule() and
   skb_set_owner_r() (which installs sock_rfree() as skb->destructor)
   from sk_psock_backlog() or after dropping sk_receive_queue.lock in
   udp_read_skb(). Calling skb_set_owner_r() / sock_rfree() without the
   socket lock (or sk_receive_queue.lock for UDP) on protocols with
   sk_has_account(sk) is a bug in net/core/skmsg.c and should be fixed
   there.

