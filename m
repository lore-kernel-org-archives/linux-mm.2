Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BF59C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8251A6B00A6; Thu,  6 Aug 2026 16:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF8C6B00A7; Thu,  6 Aug 2026 16:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C50C6B00A9; Thu,  6 Aug 2026 16:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4845B6B00A6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:06:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B95AAC021F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:06:05 +0000 (UTC)
X-FDA: 85071925890.06.E28D622
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id E15CD80010
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:06:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XHIazbHv;
	spf=pass (imf30.hostedemail.com: domain of 3Kul0agYKCCsZbYLUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3Kul0agYKCCsZbYLUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786046763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBBPYUiw+wGnA3pW6euCqNL/2cPXXNetrkceEEdDJ4M=;
	b=JDe5J7ka/+T7UrGqgqZctX5SrXLdaVoeFSvphkbJwp3DSpAYTBiaqwkB3jFBQ42ixS3zE6
	Rc5tD/7ww+g9aNbqMoKnmoR/lI6kY0vzGhqO89W80DvdEC9aMtQ2+bVj+8bwHi/BZmcpoE
	uquTbee63U7ySHGGC9eNHyUAw+Rvf/I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786046763;
	b=0xifo0GV40spj1emEUnld7E36p/Kkzc04BBZKzsXb52w01hQ3Lx06eS+RTjt+OmPVoCoy6
	8iEb/91U4V6oZ5ah49yHB+GmztqRLeeHlpdqzZylGhtMKCatnraAFS9dLtqIiyWWkgh0Zf
	Dt9NHR4pKC2nyHFkFK8i8IwptrBxUXM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XHIazbHv;
	spf=pass (imf30.hostedemail.com: domain of 3Kul0agYKCCsZbYLUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3Kul0agYKCCsZbYLUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb6ef846b33so1045524a12.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 13:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786046763; x=1786651563; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FBBPYUiw+wGnA3pW6euCqNL/2cPXXNetrkceEEdDJ4M=;
        b=XHIazbHvmqHas8xJRLwZOYA8KlWoz+K9yQCjkTarSFAkrBHOlmv7CoogyPaFcYmT8b
         ruNV+kuDjnSoN4i9r/Ah3+90/seucXkMf4yxNf6DzTDaYzkbNrg5kWv/xtC29FHsKqQg
         up7VADJpttz17uM5A2i9cZhB5L9FqyzP+nt+yNhzvAUERp+zbu51czKwDlgKLRVbSsDG
         75kaOFG29m9UabuVmh3lKrjt0+Hj1CievCqXEZBcmPB7AjkLQO5tuiiJOXRcmrtXG/a6
         i60MOJmaDd163DlCCtiNJyN8PdKyJvQeVqIWVzymgFGPcxEnTna/YRrhaAdGEEhvAryg
         SbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786046763; x=1786651563;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBBPYUiw+wGnA3pW6euCqNL/2cPXXNetrkceEEdDJ4M=;
        b=NS93smt0EuI3vbjksm6CD/c/lvss52SmQ7LOsbaAHGvsmKzVrFEJv3vEXyPkPmNYa0
         ENZ5WOF6Qu2dpzwcq0RC9VHOFwUYiJZ1ZsEgmFHjc+/fIUQ7Sm4aasredJITWyHmalRQ
         txWzjWwTScbvt/VSzo28kLEY4fJWh29uDLJnEUyrbNJxN/lRmb02XV8GLozR9MzjPquc
         4ODP4z3wAYazCf2Ux9B7Bip9hGu4f3eC2XNffLqblOHNma5SKKjg8BZ+Wv/x8IW3Saav
         xOhVnKsWiOX4ElTdW6+XZYdQ/b3pu5QL+YVzCZaIEKwspcwlF1QJMB+r+bYam2D4xdUE
         JdPg==
X-Forwarded-Encrypted: i=1; AHgh+Rpj5Ruef/wiG99STKukj3CgPWU61Q8+BO4HK1sLLEsGTXu9j07A6t+ae/hJQrOvKy/86TJERlpe2Q==@kvack.org
X-Gm-Message-State: AOJu0YzzvmLW/ZZkJMDKBYTVyhty/MtuLHfnMllMf+u6138H6MwTraMX
	EqYNtlxIrez7eje6PA3z2ux/2hgckjz9r4br+0fFXPM4mnxGzszH3AxnTfqDZvt9BFN0M07X4mi
	ZAubI9A==
X-Received: from dlea14-n1.prod.google.com ([2002:a05:701b:420e:10b0:13d:31db:8d94])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:914f:b0:3b3:a66e:3911
 with SMTP id adf61e73a8af0-3cb9c2c4782mr8716046637.19.1786046762261; Thu, 06
 Aug 2026 13:06:02 -0700 (PDT)
Date: Thu,  6 Aug 2026 13:05:48 -0700
In-Reply-To: <20260806200548.3124802-1-surenb@google.com>
Mime-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260806200548.3124802-6-surenb@google.com>
Subject: [PATCH v4 5/5] tcp: Remove mmap_lock fallback path
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@kernel.org, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com, syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E15CD80010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3mjumdeo3gizway8scnom5o44cqs6jn9
X-HE-Tag: 1786046763-872876
X-HE-Meta: U2FsdGVkX18s78wzs+jSRP4U1fFtHlyyiUkW1Y2EIjgV/L0KNxVHbwCUqLggedCfTtZqrvknuClZ1h4qREPBq5eBPAuveqcvHN3ec1H+DMTA7RGG9fjPBHhawB2s+YAsHMmXMVQPJCKRBsH7MNUjJ84Xr56BVCYvrXct9TOep2nUFbYXzrmDpeBYdKgbi+G6Xv7wMNEhAkzkc1fx3mYTzGYmcBX97vAKVmqyS/2ejILAewScXctrpfrp4hxQCeRiHaNA00DcMPQhlyuj+QRpmmtaUEsbb1cXC9LVv36tXqcwJNJ1ddtf/yvV/FfHoRNOsUOavbOodxyKWsVgnGpWVN8DT+YdiZF9ueMS+X3zaS0+KoEPWrKNwxO78OGEhkeWYM+NPFovc1nJcpOc232g5z971E6Mx2bEaRPdhNOAN+cqN8CEnL7SmboEQ1t1cERq7xs+OcPEnIWeB0nZjKvNHAjAYI4lGyKDNuzYC0lt19LhkiwVE71BZkev3bVWHbdYti2gKCa+1WfiKqe+cVkJ2NpfN/3K6+yHGs8PAw3sYQoTN2CvUCrCyz6N6wNrHBfEmhFLIOO1uI8qR7GDePuEXKjyEPNGpZPLw4NIFRsJ5sGzEM5fLv7QorveMtmdF+JGlLsQrf5uKMn+nALZmwuiFFE4kyTATA+DZXaGRKfo8xwcJh+MiDt72KZY4SZ5OUfsoq7ud//7ukvYnF5rN79iyPxOcpQ4gVokrVUIQszo4y+Z9MjGn0KhZveqw/X1/FCPh6RMdOa+jMQbHnMrczF+T5EkCDdfzAQA0bMhDyDLYAk+NYgSBxYZVKsUrIGHbMb1dSqTxUJD1aiHncbm16S0GK7wM4DGfcSM7jewtZxhzRPhoPNA+OXba1ABYxJB2UBbhTSL1rMuRRSdocg+zG+019vvJX+F+Bn/3HEnmzeSSloOgAjkOtUj+ACB1tYMyBkYSkPOnfIOuiJly6uC+pO
 biOvE2Vo
 6lRULAvYmp3tY1SANKKG7rtDzF+wDhFiI4IqNaoK8zETWo605h15tGk6JwskHyQtE97IX/Virim699eU1tdiMuy1Lz9sa4WdDFK+NG0AaDvid841WLHZqT6BSRy+wAc8HgsOKtRgOLCyKaO7m4rRH8dwCES4zsYsroPeqBCARYWzc+TVgGSWzNw15Q1f1023J5UygTkay1KrxzBd/V6n9I1g5ydJzweVZkDgAXaTjA/6TRnSCJHhE5zYy/w0fMboJ2k57LDEhqOUegg5hvrvrNBeXbbRrtFS/jS+ypphe9tRwEyst0tlNSnpjhjgTVJ9WjJUyVuzaaNCef0P2NMS8QRf3JhKX73bqvLIQkZFMAGU8xcstntwmcasyBOIozubszTLnPvklU8UDWFYcZ2b7hhOlhf0K4bbiCH5jN3gROwOSA04JwdDlbNq1+2BPgSf4F2BBntbl1//bsB+QyHon9ehkbJQnihATJMGgXzdfihbmUfC7GHIf55zAhaQgtQc2A2rs7zq/WqpWskF5jyXw+b6I6vWmdxG7kzt1fzDlNWfB4Cmw/iollRp4qNpTEIOxjI4a8C3K6kiL+yB63WdmgcyHR8KJD8liCabCTYUhcKGUsEdes//e2n8BQDE0tHhlUXgiCbXeCDyEn5Oe3Py/8YI7DsYWrqt8k3lHDVx0PMacWdZz70iBzaBZlg4E7H+ClZjUyonIEyvYCNHCOOeM5NKgJt4u8WNxi1pQgHIvKuEoIH9X7kuLe8qJYNHeyzP6XegnOqpWkiPTqJBOrlXWziXlmZz5twVR5/6URxktpTq5yJcxzG01WP0KmIk+vISJVB0TH4chhfFk8eL7y5WUfHO45eguxAoYNCwuaDOZSgURNZfR7N15b0AtCCi/IO73EYYFjpFmv3SXDm3/YrG3XNIOa6lrlue2nHz/tp7q1WD0lzIPMAlVzmdvO2F+srn7X5uctYmOlCFW6ZCMqUK7x2vgaPNC
 js3+EWOV
 +ujw/WkO88zczk1zXFWrekuAQN44C2K0UYDsN6GR4CAEAgWjPRtTxDstIPf2mB6Y6qpEFPT0dPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

Previously, the per-VMA locking could fail in the face of writers
which necessitates a fallback to mmap_lock. The new
lock_vma_under_rcu_wait() will wait for writers instead of failing.

Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
The fallback removal does not affect NOMMU case because TCP_ZEROCOPY
is gated on CONFIG_MMU.

This really is a nice cleanup. It removes the need to pass the lock
state back and forth to find_tcp_vma().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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
2.55.0.654.g21b8a5bc05-goog


