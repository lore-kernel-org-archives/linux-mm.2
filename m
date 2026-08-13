Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00509C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A766B05AE; Thu, 13 Aug 2026 15:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A7C6B05B1; Thu, 13 Aug 2026 15:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6949E6B05AE; Thu, 13 Aug 2026 15:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD7246B05AE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:34:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE37716012A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:54 +0000 (UTC)
X-FDA: 85097248908.15.992F59D
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3A70940005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m6fX5Brs;
	spf=pass (imf11.hostedemail.com: domain of 3Wxx-agYKCOYacZMVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3Wxx-agYKCOYacZMVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786649693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3M2OkRAFnIlxQQMdn0Hyw7w0AIFN/vFNTKvAHQz2U0I=;
	b=AZ0jm7nMgmHwAWaubyl+AjNzG9B+qz3QKDCg8R9B9gOGjde+qZbsQIaTlbO1JP+K07qly/
	nZMu0pekhlpK8xLn9Hc31i+H0ljd3+qr0CxMn+PxNRbKHHbJTQ+vUhu1YVL9YV3nkJghK2
	kUyjWbvg7Ir8n3ZmHByHeEYqpq2Qazc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m6fX5Brs;
	spf=pass (imf11.hostedemail.com: domain of 3Wxx-agYKCOYacZMVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3Wxx-agYKCOYacZMVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786649693;
	b=rRZ5oph9Bevi21+2L1lMCr3lw2sBCepO+uLl0jBoP/4QpPOFxkbxkVGms98J1BGknT9Z7J
	GW6xiZwdPWsF5AplMyW3fTD0OvlYOXCDfzmf6K/syMGq2guaC8pQz2M4pdEP3AAJ5jwPKN
	UgF6BGlO1BSJECn9AJUd3r66cAB3EVY=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-385d2703b64so1401327a91.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786649692; x=1787254492; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3M2OkRAFnIlxQQMdn0Hyw7w0AIFN/vFNTKvAHQz2U0I=;
        b=m6fX5BrshKkLxwWJEhPWFJnyhwYtwematnew2plI+74bnr/Z7+wjSj3Z0q+ovTjICM
         WwbvmeE9tD4RDVpe0C/YK+u+/xcPzMvIqnPtHRvHyk5GiGxTuGNhHxcZ6hx4c1zRurrH
         DceF7DSFfxCaDLvilEVvNX5vkxmHLf4smjh+EgQaWvzz+q9JtUh8JuTkc6D67LB4m2XD
         0gVHmdPXAQaRbRfVORdKZas1PWKh5K6Nc7T9U6jjDzcwdagPlBnsjfH1IYHLbZCsj8pA
         Otg3PFqxt9lIJ0CWQ0Hkxvc3t8pl0vDLDYtFiyxWBgpH7bpfaC+ydlyzcxkI0hn0kBig
         BrWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786649692; x=1787254492;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3M2OkRAFnIlxQQMdn0Hyw7w0AIFN/vFNTKvAHQz2U0I=;
        b=dSUp1Bbqo5bvB02dAROXHz/31apjItb97SVy1d9UB9BjIzk3PHo9fBAf66tuzXNf0y
         kh3CuoUCadUjfnvBaLcxxR7Fmtb2uDOo8BqNk0FvYZL1jFT6sLR/g+LXTFo8IZ7A/E4K
         h2V+9cxb8WKiDYTcPDv3Rh9FL+nY/bab4ARtzoYfFBrHP5S0YcFsu7lh59O9Whq6SCr/
         eOiprUpM5+ydKemmBinCAvzWWstl+vW/DfeBi0hkl5y4+FrOrsqsmlhSQmwaNvsf9ZeJ
         5BKjd8Bao0jR/WOgHogmICKBzJ2oBCzxUDwjsPd1DLkqOATVK9q2m/djmKGOrpMyBzLm
         7mEw==
X-Forwarded-Encrypted: i=1; AHgh+Rqm1HVFue6qeM3JatUgc2IYZcPaDgmEb1CwAsuBByJL34AdlzWCTslANUQPloWHUv8QrbPOzTLeog==@kvack.org
X-Gm-Message-State: AOJu0Yy12OBXG7RvB16wWc5SUxxDLQRWuef2/UiJXwuI7vkfQb1YzTT5
	H8vOo4VqrRkLCuSF24IMeLgJZfyMm8oP6m0QTbT0wrPo+80QCq162MesQ5gO8fWEKe2+x0/aVCr
	wXwGibg==
X-Received: from dly4-n1.prod.google.com ([2002:a05:701b:2044:10b0:13b:4811:2202])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54c3:b0:387:d9cc:7dc3
 with SMTP id 98e67ed59e1d1-3931f61cca5mr4683554a91.21.1786649691719; Thu, 13
 Aug 2026 12:34:51 -0700 (PDT)
Date: Thu, 13 Aug 2026 12:34:33 -0700
In-Reply-To: <20260813193433.3318288-1-surenb@google.com>
Mime-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260813193433.3318288-6-surenb@google.com>
Subject: [PATCH v6 5/5] tcp: Remove mmap_lock fallback path
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A70940005
X-Stat-Signature: ug3w7znfyj4hmrtnzd76i8j89w94uyny
X-Rspam-User: 
X-HE-Tag: 1786649693-837950
X-HE-Meta: U2FsdGVkX1/VSWpFVvM0ODfwnbqeBlD5k3kVdkcLaKQIoZljoem5cgkKDp/2HbUw6g87tQK/2SsTNqmgYpHZjPPucjNae7OLCf9R8PhAbcopb9RhhDdX2gzm1LpveQkJWyB0Z30hp43dwaFlbmvMnQCTVg1gCSC7xFij1j8iQ0WhMS/XoeDnxPO8mCqEy6a+/IY92uoZBRYExLYF1z/4Z9G4/lBg77Uz+HayKlFfoEbTLWc73stwWwaYrtWFae/r0Nc6l1PNpHnADSc4cojE63TtS4uI3QoEWoH8YmdBKbDjNkrHih93Y4H9Kkh2GCqW0DMnz+AcSD9T15NZ6tIMK/NBQpLUlxgRVvA5AOegJCj/2+ziTAbk6sXBXpAUcJuRXY7L8lDUe3mv51v/seQyxQruLbTdSx9osmm147mrf8ZFY/UpAHJYvUqqqrCCsrkwGkD3S1tKOz/naCYxlFayleYU7XL5q+/HMB6dY4dwcjViWYyB15faflHDJdep8bjMQN5bnb7//1JqFhJ9zUH4tQsC5aJMYLTcKWIMTW49J4u0eVhrV5zxA5vPWDJ3C5K8sYJgIlpxFvsXEgwMZAag9qDFoYG/o1YhLJUi7inprmTp5B16NCtqhtwX3RXhtl/bVIbgYBsIG50ugVt7n+lSW0qRAXHqBOi+e6uIVdw3R9y6nILtGNRf49EzDlphuhng482O081oltXvvt4u3lUHvfp3+CNDnOXF/HYxghkRarOCUFh6jB3idItpEY24Ryz7lzynMURqmpToHB55biuSLQphRh9ZDUJm3h2EoipE/gJKZDATD0eORhD4NBiM8ClRLgx/7KobLxwq+MdFyAbE4JJqdLajY7Ito3b6z8xQkr5+bA48sX/WZgxUjRwi2PimfF0faBu/meHJrKfeZvLdLepEfqKfQaAl245WHC7HnKqRc6wuPcmJHskZu3UWuiZfJmvoNH6tiKmQRzdr4LM
 LXQWyabD
 94uk6bGvuatcGsWP4ROD/wOZO6gOQ2f59kTxaswVygoZ7VR3vo8Slxeirbr1IT3Tytjc9gxREr9cz3Fdi1T7khKtsoISp2Og8LRgqjg7kPq0Ju9wWIuE/s5LwVju4hrlp0W+RIAj3P49gFnLMI5XkALQmvC9pIOI68drKhJOIRT5wVtOCpWm4GsE/C8TN5IooJA9DrlVNm91ieihCpW9czbpTxf7v2SIfyrsGPQftK5ZJzZcsQsFFMpskVUB9Aq9OwyN1WONL1GHidmAAeQhZYQahubmgE/W2vxvHvhLE7csaVEfSkQknYCATP+WuN0DsDmMjHxoYkM1phFP94TO3bgdfYN7K4B/RPihar2cqcBCqAOnGqDvzxpkPs+ETzL6NoGwFtN/M9w03YY6qxuqY7lwH6yM2QY2NsSRUzNYQCpl+9NpwHxeXvgJtvPR3dsnBl+6rUTeh+k2Gb7U68tUFNkML0ELUzknfPQlpPkWPXCoMNhB8grB0LOZe0kMo2zD4hHcdFUXaup2vSP0vfRUFKKaZgOIkXofJPOUOXMJdaN4kAgzjjHK8wfaY+bL5e81JGGtkxujD5Nk2JQIidRtduIBYYyyEwGt/bMTIMuWyIewLHWoVWGTALwe5egOjhsg2vNuu75MQAo+1lJRmsRobKBkHIzJjRHdubpdx4qPb/IIE0xmtZTJzmAIWnD5KCErfyUToQTCiIbyApSuvGDkm0l6s8WqwOgzRUn4Z+Hw0RHEFVUWWFpblE+RDXKQJphBQ/phnpQ6hPgES7tsHUmMhx2q2iRG/O35xeRSXcDJR+44aZr+0tgQmC3dhiKnJL4HCmNI/uxe6H3Bz7/jb5dq/zePbI6HhfDexk/nCNPwKdWA45hBMCjFzl87Hwx1RP6RJqiTW7T2Q9tS3PpWwADIam3RewKF8K+GOh5jtH8BPNu0veQTVPezlbBGFn33TpXv+6HRCsbKCDoz9qff9n7Gx0WpEpCEQ
 78aJaueh
 i9H/9bUHQmgHsPlN4kj/FGEGEWwiwrd9ucGowyzWNfz7twlxRAn5Tkvl4tTzn48zW9kPU/jBJis=
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
2.55.0.691.gc56d675ccc-goog


