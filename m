Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE587C5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DD16B0098; Tue, 11 Aug 2026 21:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108366B0099; Tue, 11 Aug 2026 21:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F381A6B009B; Tue, 11 Aug 2026 21:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB3946B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:11:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35B7E1C0BB1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:17 +0000 (UTC)
X-FDA: 85090838994.13.A953C61
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5F1A6180009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gsRfVYoN;
	spf=pass (imf24.hostedemail.com: domain of 3Mch7agYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3Mch7agYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786497075;
	b=5KOyEr74LaRLUCVKWgMhT0fb+jkcEVOjYbMm117bvxySF6vrmwcKB+YwKxcI4AgugthjNR
	jnyB5Ld23kWFrvCR4tH29UirbNapEBuV7eeXLYJdyuEqTNe8W21ZaWI/WhZqd/Xt2O4iMA
	ZRk0HuLCcqBiCT9nqHorxdyvPGC1oXI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gsRfVYoN;
	spf=pass (imf24.hostedemail.com: domain of 3Mch7agYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3Mch7agYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786497075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3M2OkRAFnIlxQQMdn0Hyw7w0AIFN/vFNTKvAHQz2U0I=;
	b=BvHxRYOuhYBS6xsHZTK5ofVI036q+oM/45GEHCVMS3R2roMuCf/mNCyNOWnxw47RZ70qgh
	4xMD67CJGbt5JyEcop7ImT+jv87jq+sfLJADJl5qe06Sq0OO3LIL8dixD3A0vl1yJ5vCYG
	2JTK7U474W60vy0icYWiSI+sWHwY9ys=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38fcaa5f82cso453533a91.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786497074; x=1787101874; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3M2OkRAFnIlxQQMdn0Hyw7w0AIFN/vFNTKvAHQz2U0I=;
        b=gsRfVYoNnkNGEBSvW7CaURrcZBQofcd0f0HZFtenCQ9gkED+rInjkH27lHbydVsLx+
         09X189KcFYIDjj45nRHzggpOsHcBIVHaKML3yb6/E6V4GqgQc/N1kpgAz9yW7A+jwAl2
         jmMPCYLHU4SHJcMjKD88RU0AIBzpJpxnUOEgE3Lc4Thyqzkqt010tjF1+UPFdZfoNnID
         1obwUCtwK+nHLx7uW8yFpqbcQB7dUSDQLY65TyTY+EkV9jSEpEYyuBiB28IWNPnTVKI1
         U1iz9MqKta82Z5C92neKKGt2cw90txaDoLKFVtSZ/YE96mB1NFKznrujALNtpFuqcMjN
         PXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786497074; x=1787101874;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3M2OkRAFnIlxQQMdn0Hyw7w0AIFN/vFNTKvAHQz2U0I=;
        b=eYvC2zyb2+VzrvMZWiJ6yBHwWmvxR4qs/fdMfVLb2lR98CbIaIBMoUotzkCKNhBNmE
         5Wd05GzkwIreR+bxMI0mNxfze5QIYKjaRCJj1E5gmqMQCy35LSPzxQEpqI/O30wiZcki
         cXJWvzJT/EPD5fGiIxSmMMSyvHgAodTvckhW2R64HCHfwSZPzy7bxSFA0Tln2PX1Ijt0
         /2tDofwWFM4ZemwAQFFOjGkq8y/bTx6hCQXizb+y8xoeeeO5TCl95L/sumoVS7gddoNG
         pUuAyL6j08pV7hVpkklB1ve/rqt1pMukeZig2bNwYsifvYEr7qcIiJxIEp4B/bukkidv
         d87w==
X-Forwarded-Encrypted: i=1; AHgh+Rp8s4vk0MrI0+wNPPuIl70oufF1dzSHf1HMXiGAexYvr3lGbQJ91Xkibf4eYlhBYHNSf0imPxTUAA==@kvack.org
X-Gm-Message-State: AOJu0YzwcshYwkg800pjVotuBYsesNnvZm0diF4Hqc/Pm91SQ90xbVKj
	hcUg+H2UC/QTInJyoO8x6teN8u5mqK8EcL2fXr6perH3Q7yQjpKab3VUzuk9u0hUkOxT6533tJi
	jtcQ6vA==
X-Received: from dloo28-n2.prod.google.com ([2002:a05:7023:a5c:20b0:139:d9c7:3cf4])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:580e:b0:38f:18f9:785
 with SMTP id 98e67ed59e1d1-393012380femr1349300a91.8.1786497073970; Tue, 11
 Aug 2026 18:11:13 -0700 (PDT)
Date: Tue, 11 Aug 2026 18:10:55 -0700
In-Reply-To: <20260812011056.902771-1-surenb@google.com>
Mime-Version: 1.0
References: <20260812011056.902771-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260812011056.902771-6-surenb@google.com>
Subject: [PATCH v5 5/5] tcp: Remove mmap_lock fallback path
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
X-Rspamd-Queue-Id: 5F1A6180009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gbz1im4cnaxsfrkpen4tee4a11pdyqoc
X-HE-Tag: 1786497075-823575
X-HE-Meta: U2FsdGVkX19aG0Mxz/hgcMK1OIYjEJKGHUKBQNZh2ZAHtmx4QCXPuTZAlKlAVn6O/AtBzN91ldbBJfEMNEoMcxczyvPDARqsTI+5SfAUX1tzEVVPMDe/Kt8QbAy2yjHcfHPLsTiAw+ZHIywU2rR171ylKy5lhU8ERnpOFQVdVfP7kLmOIHmiOuzxwH30mu9IMNBgTZe+UuR5WQMXgvSciwARe4zb8jgTxoBBTVjnLurtQl6lPqAKLCaYiOozUF1XnJs8lX1B/ryJYKZtgNAF6CRqGnw1OLsvH8aDBW9BkUn/2DNkzD68AcEUZkO1lMlpjOTcxlgIDOH7ko1XnjS3OnBuFPNqLIVonUuycZOcqes/dPdZriaX9TWq7wObUAAW3FauhUEPldqSCKxnVD+HjY7j1mgKJFsFFIm1AzE5MV9lk069MxTnGX/eTEV0c/ZQx60xUM60Brli42qGEpNniHSoDH+XkC/xhvnmE172KPReyvoqmyrSJZHFVA5lLAEg84sHUK3V8eBVIaOpEH/iMYSXR+7ts5OOQ9yohqv/AlDEnpjLCriJ1Jlvdep4EFENqZnleJNUv9wfBwtpBaisj9MPOAQNysNBgvc3RGJI9tQnxR8gajnskYG0q1L8sAY4XGWcD2z7FlMLFPUZWU2Zz/8f0HXF3Y+EpMaqtjwfD6Em0hd3IfA8b5IMu/2u0PmCeM/+AcYsEcMPzyChNtQw/xiTkrxZYYNgmo0wXiBclAdg4GsRf0HYL4IwBzgFXSivDJ5B36b2JLH0+LgCPb9/U0neQ/Q8fTbxRlztY4IybOrPedfLH+ZWzDIfU0NdU7/Na71j0ytWg2A6aixK74ZbZDDZflkQ5lVTMsX57CdG/3OVtFuLOHQ656SYNpVeCEQfdjTLaJSS2pR5oUnmhfWko3ccrvwWy1enzo29uN9seCOOcwm2+buij8MBWwLlMYguLbI6RFr5TRY/ZNHmbj4
 UDux4eRl
 OuEM1ZVF8zWbkLFel81IjlGCB8iewdBhGr6H5oL6ldh5zGi8EGcZiVZS3W5ORyC7g19RBBm7jg54rPlLM96R9uWP6ND3FqoAfIsmUsA7Aj2zo/Diqov6SGD3rhHZQQgH0F+9n3sXcnWylrMQvHs0+f64AAurPnVKtQsHNZBkE4C1D97/si0gDTWnk3glNNdjEGRi2HD/8ygi88Kogwz/+NQHo/4QS/kUhOS6ZIjHCq/W7EDZdJyD8t3yoDxmYC/k3lXjLDcxVO6116AfZSlUgcD05CM1ksQqhE2HTLLBZ0DVYxzqa8I7Q7G7r77ttcL19bCq/pfvYRiYviWSvIMz0ypz0cc/wG50d7NCnnurgIZJTmaSdbljNN9Yrq3c0cXi2AKaJosLJyc9MI7KONUq5UAsOeCcg5A00XWkKocyya2BrGHMIT/meLgurIeZeNBQPuWGv9GYAGeZUzCIZZm/2/8xk/hgdGijX0wlGCD+YKGMgBAS1PPtG3Cr7Pa7L3+twbo1u7VcXmRLoTdyMsRJY+qZU0SZ4dyvtgKWQvMbByOl4jxFnmMEpTNVZVkKIhvRyCe+Vqg58OjdL0ECkt+hS3Pw6t1/1r+6cpvSantt0ROPQ5emfhmp8++u1FLji+gnohCQzXAMCi45aa+DHmGen0nuq2dVlshJRzr+riFrlXhBE1S430tzqnNWzFD6bbaihMn8oM7Y4EQ7D0AJN28zz0I96D14NHBho9hR+yR7W5Iin6xMfUg/U1HX5Jo0KNGPSB6HyoQ9G2Qtl4hMdnJFRd5e+kHd7G2v+Dj+hftsuHXzjWk7zjd9AoLf5Bh7YaYEB4oOvAa6WGrtuP51hV6RY5ujn2aXJ0ahtKrgVkiTJB2cTPZYPYIN+6wDJl2fGXyPcP3er3ph0E6cHoYR50LsO6VlBtH3otHmIvy2pD0s+q1OpBhT9VeMKRIcoLB3bX3ntteLeaHeRh2QnCWe9bMOU761iZ9ZC
 Diz6c5QB
 +NMLqUAFtCnI6I5fI2SEOPmM7Xdq9hNu81RDhf9gx8W107Obh+6C1IUBxHcph2dLkNZG2UoJA1o=
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


