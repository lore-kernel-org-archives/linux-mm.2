Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16306C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 21:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703AB6B0099; Sun,  2 Aug 2026 17:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C766B009B; Sun,  2 Aug 2026 17:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554DC6B009D; Sun,  2 Aug 2026 17:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29B686B0099
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 17:55:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B208BA030D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:17 +0000 (UTC)
X-FDA: 85057685874.05.CB36C8B
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf13.hostedemail.com (Postfix) with ESMTP id EEEB520005
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Uxn9yz6O;
	spf=pass (imf13.hostedemail.com: domain of 3wrxvagYKCFUFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3wrxvagYKCFUFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785707715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNzfa/Q2B0yr5cHe2iHTydpaM2L8dTGY4PL8h7AQ+vM=;
	b=qwmXf2FAckt2tBdH31nPvag1Air5QZ8mr8KWsPxltfRyKaLrC/n9M+sapRpj1+ObkSQgTH
	8cPeFx66TTjNNdLwUJRLEMHjS8yTA0ggUg6IkI8KXyQOesvRRtDJ7ZuYdNkplJ83DS/q5G
	mkDfXbyopjK9tL0wjySpBZy8pY+Aitw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785707715;
	b=6MLVQ6uIYRXqRn2Iqm0VdTdTsNgG20MgvsylEFP5U/HbqiG3A1s8W7aHIot0kBEvqQoiE7
	beGaAP6lQZlL3LhH5gRSJ+p89JVtOCS4gYteqLUm5a8Hz0LVDfFwK3VRILo/5R38/MmFU5
	bJzbqQe/oCHOYgyrWMyYAOIacquuVQc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Uxn9yz6O;
	spf=pass (imf13.hostedemail.com: domain of 3wrxvagYKCFUFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3wrxvagYKCFUFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-ca7c1e22995so4620774a12.3
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 14:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785707715; x=1786312515; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FNzfa/Q2B0yr5cHe2iHTydpaM2L8dTGY4PL8h7AQ+vM=;
        b=Uxn9yz6OLbt+AhvWe1Webr2nXTTwHMhiYYmrMjCOgsK32Q4GnL6dijkH3Btt7ZC/Ur
         XNPd2wqGLG2Er2pwPn4QlH75hXLeTA3ZJcbB+vHIbmzgA3M5QtM3SEHfxbrTX3C3YATJ
         aYoBQuodecrK2+GmGhcsS3TvTmrcgDfcSFCz9BkYrpiN+/Q1R1uVyj5MZEc6XOZ89GcV
         HSd5aKosJWEHPuUZVQeDg6A3RR9+puUlhMvxQ9KoUHrqVA34COep2usIFxGNTVtm19gW
         KFz/CHa/0Jx1c0mu4vCmIIhmavGH4i8iw97uzbchhBBgqCTPskrjFQknUFaV8YmoefrA
         IQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785707715; x=1786312515;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNzfa/Q2B0yr5cHe2iHTydpaM2L8dTGY4PL8h7AQ+vM=;
        b=fWuXSwh1Kf1wPYagTccz+LBM1syivPifV7+v3L/UV1pGUHqx83ydVzokLx21U0Tv9e
         a/6jsNiMRD9JS3glagEpIf6rryHu+hAglPSvsJw+1LESuvT1/HUYKVRH5uCefYJ53obm
         j3nzLS/9vXU7SS7B2GUPnCje9arLjVnvbIQ9Ao23qQClw+RTidnQ07dGbJkcqQ2PeDKb
         j8aarxyS136GxZc78dVLvLf5R4p/nf316xiICYng+MFWUuYmKMkLIV3NPF9tlsfV5knz
         EKLw72zSHmPEPL+16AANVObi+KGSnXRFFZFzsZVPI1Y3p6Gf+zTsFFFh7KpPcwfosSuf
         ilgg==
X-Forwarded-Encrypted: i=1; AHgh+RrD3HYLTA1zs4k8AGN7TmJ7mEulCJxV0uFGfZLA118Oa+2dg67BpOZf4x2iMfb8GXwZuRvr5YGbpg==@kvack.org
X-Gm-Message-State: AOJu0YwO9frC5sHc9Gb0xrmBc2ZfeZFVvM6b7dyPjUd0Zf69TYXnXFE9
	HjwNilQBsj9qaNqjMkLGoGrZmPo850gOI7o8Y8GDpbThZx6FvVd7ubNbH+dSPdF3R8K8zus78tl
	W0M8UhQ==
X-Received: from dlep14-n1.prod.google.com ([2002:a05:701b:458e:10b0:13d:2928:7996])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d80f:b0:3ba:cd5b:3dc8
 with SMTP id adf61e73a8af0-3c92a5f1c89mr7273098637.31.1785707714551; Sun, 02
 Aug 2026 14:55:14 -0700 (PDT)
Date: Sun,  2 Aug 2026 14:54:59 -0700
In-Reply-To: <20260802215459.2769283-1-surenb@google.com>
Mime-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260802215459.2769283-6-surenb@google.com>
Subject: [PATCH v3 5/5] tcp: Remove mmap_lock fallback path
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EEEB520005
X-Stat-Signature: ykr1pykieugf5ygu6pjh6tbtktdy5zux
X-Rspam-User: 
X-HE-Tag: 1785707715-788169
X-HE-Meta: U2FsdGVkX1++X7vs7zog/CtSbeXAej5A2L11F5vXfrIA0kerHex2JIamalyHQMdGoG8FgEbwgPOnvefkbnTNqkj6+L8edhKCHN7BIfwGqLzRqigpiERv/8nZRrq5XpDhdgSmodhLM6UPn7RxJggeKKY9S70w6uewQB9qqRv9Z8ck8i+ITGAtmplqk6YCJZ/PwtBlHTQUmMlAJgk9tdqkaDJqBS0lNRVW9pTHP2V3bnajAHRsQHHkOAaCH1m+GEAba99rG0cmodbyCK80tpvFAayFy0lYti/XCboi3u02nC3S25ouSXNuya8n8BB4IWgsXCRiY8JY8cUz7NP3VpF3IyF1wLXKTgjt5QGSpZhXVXOB1Oh5LaA9SwDQGtoO0Fic2fnhz203nSJMPFN3PDXh7pZbIcDEUp4WVZWPUv2Ero7HKBwnIfc4AIBKB/PN1j70fHTOx6T0O9Qgp+qfzG5u1GsfsZI5cXQmRkrC0AJ5yulosskbzjDoz7UaaGRD49MV5kxeGvnfPoiGWy4/vRU9G7QVjThxVpyxQqr/wh49M+qXRdSrkrT0tZPR2ewOujO0TBHgA5IoHB26c83mXpYEcLqIKi5qqbleH3LwN2d3P0NrmNGzDX9mb4Rp7VUfWEIN3ZogWkKiQSI+LqQZ2y1aFaGE86Be5nEoGW/KHVF3DiYWh481Lh74q0Tzvmq8YsUn0RabF1gJ4Uiom4+ucuv5k1NH7lc1RAkG65a28Dxgghhqrdb2YogSP6r2EuQDtV/iDyLs2fQolqL1UTRps97mmRr+fXNacOblXaymmjMH48AdoYmBTUGY/a6DHpuLeIqS3dEucibcjj8Swezcoq9yk9O+gcP4xs/rHD0XgG6PHE5b/rVTgyjjZPypYB47bQ99BntI2n5RmZ7ZEwimNsC4lLW+2Rv5P4+z5gUyv/n+/RhvtzcoDqDtamauF165koHpGoOD46SsEHQsJ8+lPK9
 4rBBAZ9W
 RQMHJ5mkjKLI52WKuQGWEgfhDrBNOZ2OeYhl8YKvZ2+t+fMteN8mUvHtvxBnBBPdUgSNdp9aAVYoSLDLk3pH3r15izOKIt3x82tNXkn9+/tnoe8cbzKUZM4OPqoib44nRfvFAcFyEfO8b01d2RA0pHWRJJVTfpALrZI8R/vQq5dnNTXLaEybTHDmHbnAbATat/xmPyvxyjieJ6neT/gj6earpQyLxjc1x9dUgpArdHdNzYXYgdydc8hsMMDyo7edogS86+8dDA9XswbEoT47PtT0w6xd/+opmwjTW2HbhXbJXcKDRCqK3NCPQHWWMRL0TnAf/ONzquZbOwheMu94dL3H+lmEkMlWpFG6IMffIj/Z+by9yC0SW1nBru3OFsBChFmtA3lBejYTdC+vCGz/VSzl5Ktg/FM5f0a0gkuyBYk0KaxzMynT+SZyJcmraHiW0m37b4mlTleSXekas3i7Sn6t4NqOWYb82xVOhMIZKURUmKvmGtV1zAW5HRDlJux+2lR7UujD9ftArQLIm7DLU2wj/41BPBd7XWveKgbCg1T5i4YKnMWTxYmw+3OoP/nqco1xgnsjJUURcdsXQ664NVrnkrs34AlLVcH+jLw8jkPJd/ZVjChjMP8faUqSW2796BUGb7/lTweK7eTq7W66Wa78jqOfyDaHDoymvlebxGW3YftD1bUOLf1uiUy2D3X6BD9BUeQAA7rY1LyeHIx1gNNXb2y25UzZ4U6vPfIFRe/nveAhuth9cUtWWIrgvJmOSGil4pCQUxwSkoINrwQGP0tRlhR6M6vKNLgTKgBXQW46PzcMkm+gVEVAPiw4eL9d1lb12qaVS9gu527qkN600boahcI95rEeDVJFz29trQdqH+nOS9S94OYHGXekvZP2Tnucxg6rYQ6XGM1RoYenCeyrR1DFhAdCx/vCnSKZEwIil8advvFo5vr2hFTZkbvIsoDakLDhz7cljKS4lcJzfzKfHOP9b
 lADJ/DPr
 2P+1T62+9ZJwDBhZBCmtcpYzirLaTtYIik85lKtQqIWUXPMURLdMc0xV4rONaMtxYu1CVO23dYg=
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
2.55.0.508.g3f0d502094-goog


