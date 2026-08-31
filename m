Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E54C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 20:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774786B009B; Mon, 31 Aug 2026 16:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE586B009D; Mon, 31 Aug 2026 16:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F846B009E; Mon, 31 Aug 2026 16:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23DE26B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:31:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62BB6C0215
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:17 +0000 (UTC)
X-FDA: 85162709394.05.62547F4
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf11.hostedemail.com (Postfix) with ESMTP id A63D740002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ia8ijAyG;
	spf=pass (imf11.hostedemail.com: domain of 3kuSVagYKCA8796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3kuSVagYKCA8796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788208275;
	b=tUVqtaF3nkyzn+mHaXOAtXmHWPZ812fwYmoqQdL/b8V171IKxfvWiiSMLmUxY3qMiCqepb
	yB9CMdQT903mcY7+4jusZ8b5fOZCPFlUTuwDCOzKJ1Uv7YJXRnyqMh5eysClz2KKxDDR7Y
	hIoW5tfaNld/pcsMjziDwPJnmcI7KVU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ia8ijAyG;
	spf=pass (imf11.hostedemail.com: domain of 3kuSVagYKCA8796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3kuSVagYKCA8796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788208275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELv/N+6IjeKMBTz6azi//X4BSCo29f+bI+vir4cQf2g=;
	b=mwxNdUlI1k4+ZSyHDJsni+m4gx2cvPoQP/3yk+vONh3lD894GdtGPz+xGu+P9ellhUmL/j
	fb4sSAPE9dodb56+7PBW+fy8FjEFUwus2e5NtNQDEk6G30g0sGhrY7wkb4G0qJDwi0hrvJ
	Bx6C5aJUwojlLcgJ3Gm48f5gXwUqokk=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbe77d6864dso279768a12.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788208274; x=1788813074; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ELv/N+6IjeKMBTz6azi//X4BSCo29f+bI+vir4cQf2g=;
        b=Ia8ijAyGOT+WtrrV9HVPhhHqAd2Ig8UUb/CjDwaqfJW7eWKAiiIb2m/sofZsrs6EtK
         YzLKuf+qktx8mG+JuDbI4ksptQ/96ZUMOIiP5wUkVNu81C9BxfhLebvKRoXuPV2T+kGe
         ekBFatLqxRrtvbEMP05pta9hoqV6ZlKDGv6of64LGaPrTyFrwyFu0b0fEZjtiVSd7wTE
         0YroxZuGPWYdHHWCzrTrj/eYTzK2b+70OVHTk1aThcGFFjJreWgHcZHLm8xB5+5g8bW5
         fgAJwJF31qFjNjoprUU/Uc17U5gpQewKGkRsLd/rU4y/9HCozP7rmoDHkkfPiscdYaCp
         3KSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788208274; x=1788813074;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ELv/N+6IjeKMBTz6azi//X4BSCo29f+bI+vir4cQf2g=;
        b=FEJV4tj7AsqX2g5Rhh3jnNmUxrlRQu3zsoiI38zrOmyGQdZbXPtgxlWMYRrnkc8cRF
         nwyhslcugZncBJNKEeMJNhmUQcSZDyhRg8Rk0xPlQTK0iirooG5plmxaNOu+AtNKHUmT
         Pz72SZDwt71zPvz07hbltkzuFj9tmQtzwR5pCDG0QgYQhAVepKvma9Wf8UyMc7eMSt4y
         zGexCV77HVtQUjE2mOZbbCo7MaN9sB8/CTtWKqdZ7OSRsIWGN0xHyd5rltmXzCT416+8
         Wvrh/FaNhucsB6or2oJj5RUwPL0kpn45hdBqM2H0ToYwgxqQTB6uiVnWx/EZaE7nD+az
         Yu9A==
X-Forwarded-Encrypted: i=1; AHgh+RrIwHsm7to2lgHf3b9IHFp2VIEjvKZnxY4Gf6HHMmk7g6aP9gvAShU7DWqT7hYNs2TDFcq2MIXnVg==@kvack.org
X-Gm-Message-State: AFuF++nogW+QlLn7sU4a86BIg0Vm1NAmhFrZ6rLI4gT9iQDYHC6YslDz
	hK4qbppK5zzJEAHB7hknvDJtqt6UWGtT2i1SE01kav7LsxRQg9MdHe8hrBXs4VijnuJkTyABxbE
	Xd64w3g==
X-Received: from dlbrl15.prod.google.com ([2002:a05:7022:f50f:b0:13e:5fe8:61ef])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a93:b0:3d1:e510:9052
 with SMTP id adf61e73a8af0-3d265e3f792mr48387570637.7.1788208274250; Mon, 31
 Aug 2026 13:31:14 -0700 (PDT)
Date: Mon, 31 Aug 2026 13:30:56 -0700
In-Reply-To: <20260831203056.838265-1-surenb@google.com>
Mime-Version: 1.0
References: <20260831203056.838265-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260831203056.838265-6-surenb@google.com>
Subject: [PATCH v7 5/5] tcp: Remove mmap_lock fallback path
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com, syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A63D740002
X-Stat-Signature: gjq4qpsb6otjdo5di7s4wros6sasq7cp
X-Rspam-User: 
X-HE-Tag: 1788208275-885344
X-HE-Meta: U2FsdGVkX19vgKdwSdzsSxllBEZH7llXvOY92PWFm47SEFZNlMLsJq1kMUxLr7XEzzEnPboh/0VUa0SnyQaiAQ+sPCvJ6iH5tkZl9RA4s0iHQX6fZdHvNfB1cY7RCAqmk5NkcjvtPhdBtEKW7QNar2DhQ15gVICmC4CgvHWceXOikLUzS94HVXlOae+eqPJWUQ5rPCcf9lEVkTmdUOE5YSkLZkYykYn1CPDzQAEVEU5GZXAjIUldr9hqUFgpmZ4UMhsjQy/DVzNQeq4gtLCoH7ULuDWlEhhKStTmOZxZ8JW+2RVg/xOG4Z9ubCxfNzaE7iEIlt85E/GytVNTamqGutevMv894/I1pT/QJfGfI8vWBYrZl7NX2HmrIZL4/1n0zaE5cbp5Gg3hvYCUPpubedsFb5HtVRJlm8Yx2ayPjIeaNAs08EB1HBwa7fVzFg0aDqCp7wMaC6vHV0IkRDvy+yAZSQNUH348dSOCw3pSc0/Fzg5Hnp/fDoYMNt/HoWeHPWof/X2Fe1tk5o3J5j+54zZkcW9wglJtVjdAjLgnZzcVS+lDJNVdPYgnPerenh4XXSQ40+pWo6NzO83UC//Rtt6kIOq4fr4NNQjitTcGtrD5TyU8m/sGoSRPkmSTnrHdDQOUT8wWJMVnYikxqZYq4HyrbBG3YwNAQDaRDKz3wsB4q6RHkz6lsrm8Yg+forPG86LPewDgKl4Licdf5P+zDTjSla2js1ut+5bnelFB5brBgQiUXqcZpOcB3QB73G1A0w3tERkGJrC7WW0Od1RZlQT1xr6PO6wVOq3+Sa2sTrKETTZNhiBbE7K9g8a5h/VBtO5OPMV14bX+5FPMGx8vAr6j+tM/gBLb5Xes782vp+KaKJmfgk7T45OuImFujXGPbB10HsQXCfP40dX9GpGXiK9Egh6sos6qIghBPnUSPz0A4v5Asrmft8+44yz1AfBM3qIRY0C9VKoDur6fgY1
 036B7OCh
 OZRgdmm90PLM4dgBIAZCuYc0dhhAZ2+CSbinvEGmH0PhQUZjzrQ/JxZYsQl5j0ECLsRYDpDmm5Rmy/VlRxtLAueCdMPMv5MetZlKq2AzYKsuOqU4OtkzCgrqQvACIHnGgeqMAFN4iK3fT5AEsLxbkiYX8ygttDVTRE0YT6pc1M4c0Qg1v15hmB9zIQL7PO8TibzeSGNhon9JGVuoH0Q5rgf1nPPTyzQPc5tndQt8ICe328NMKTEet2QnoeWymo5kuQhDhY2VZdwQiDBZsgqppaPy4KRR+/KurZ4VCSdozo7OB4+YnPummbr4p4dA9olWEP/mHE+PMRcZvI7z/39F8H6xzZtTkhbJdCP5Fts067BjkAh4hwnof7qAwHfvzmVbmUTmU6d/+pJZyCEzQ3aCQyJhqlOwVMjuaFBupNLP/9mWTOh7FYNlzB3+IHmQASeDSqcjO2DGhE8UMHbW3hKlGb0sejE98ZgZ7BE9lhJUKz7CRqeEyZC+/X+10NZhqtKCjTtvqoWGijfEMUF0+/SEUiXgNGyZZhHEoo3PCNN8DGl0iRZZzManpUDIP+EBNQ+IaGu6f54F3Nuw+yTz9APNB4McrA0kuIFDSV6RE7Cpj+px4pfG5YWP4U2lC2X+Xt69KmFpcYRcUib7levOckjxrW2UtvqNYD34TIGGhHumNnFdemOVqrLL4d69M5yi1XCgKrY7yX7IUPCkdgOIs0308JY1ueebDLaYH+DPDYyF3LXYjgWggiOT8qELx7O9YXVyRrXCUkEfC25lnGKWYFfruaMk7JmCjJLQr55qqUHMoDSgrYPp3yS2kW4JWxSyNvnDm87c5mM/50pqRtknbaTGUrDmpgdN2xbxT6jFVCwGRoKfN6N3eS95UoNZxsyliFUNaYcevJqSzV3JlzdQgW6o0l+nW0F75HGlq4qbTlik4BruJFAZKAss9edY4iy9boufpI6r8LZ1NCvDtZ6zNmX3USQz5LVlX
 KS9vneqX
 3t9o5fNX1lax5Qu7e6/Tw/FptIXE/1qmVhT9OViIU9ATsdZGtfMSq6zC9Pc2XxSzwSBquxsNZ0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

Previously, the per-VMA locking could fail in the face of writers
which necessitates a fallback to mmap_lock. The new
vma_start_read_unlocked() will wait for writers instead of failing.

Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
The fallback removal does not affect NOMMU case because TCP_ZEROCOPY
is gated on CONFIG_MMU.

This really is a nice cleanup. It removes the need to pass the lock
state back and forth to find_tcp_vma().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Tested-by: syzbot@syzkaller.appspotmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 net/ipv4/tcp.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 455441f1b694..62defe70f3ce 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2167,27 +2167,18 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *=
sk,
 }
=20
 static struct vm_area_struct *find_tcp_vma(struct mm_struct *mm,
-					   unsigned long address,
-					   bool *mmap_locked)
+					   unsigned long address)
 {
-	struct vm_area_struct *vma =3D lock_vma_under_rcu(mm, address);
+	struct vm_area_struct *vma =3D vma_start_read_unlocked(mm, address);
=20
-	if (vma) {
-		if (vma->vm_ops !=3D &tcp_vm_ops) {
-			vma_end_read(vma);
-			return NULL;
-		}
-		*mmap_locked =3D false;
-		return vma;
-	}
+	if (!vma)
+		return NULL;
=20
-	mmap_read_lock(mm);
-	vma =3D vma_lookup(mm, address);
-	if (!vma || vma->vm_ops !=3D &tcp_vm_ops) {
-		mmap_read_unlock(mm);
+	if (vma->vm_ops !=3D &tcp_vm_ops) {
+		vma_end_read(vma);
 		return NULL;
 	}
-	*mmap_locked =3D true;
+
 	return vma;
 }
=20
@@ -2208,7 +2199,6 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	u32 seq =3D tp->copied_seq;
 	u32 total_bytes_to_map;
 	int inq =3D tcp_inq(sk);
-	bool mmap_locked;
 	int ret;
=20
 	zc->copybuf_len =3D 0;
@@ -2233,7 +2223,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		return 0;
 	}
=20
-	vma =3D find_tcp_vma(current->mm, address, &mmap_locked);
+	vma =3D find_tcp_vma(current->mm, address);
 	if (!vma)
 		return -EINVAL;
=20
@@ -2315,10 +2305,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 						   zc, total_bytes_to_map);
 	}
 out:
-	if (mmap_locked)
-		mmap_read_unlock(current->mm);
-	else
-		vma_end_read(vma);
+	vma_end_read(vma);
 	/* Try to copy straggler data. */
 	if (!ret)
 		copylen =3D tcp_zc_handle_leftover(zc, sk, skb, &seq, copybuf_len, tss);
--=20
2.55.0.966.g6673acef38-goog


