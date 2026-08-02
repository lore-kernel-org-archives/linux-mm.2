Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B821C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 21:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA556B0096; Sun,  2 Aug 2026 17:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB8D6B0098; Sun,  2 Aug 2026 17:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0946B0099; Sun,  2 Aug 2026 17:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 637516B0096
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 17:55:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACB5AC0599
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:13 +0000 (UTC)
X-FDA: 85057685706.09.D626B72
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf20.hostedemail.com (Postfix) with ESMTP id F311A1C0007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EMd0+iZb;
	spf=pass (imf20.hostedemail.com: domain of 3vrxvagYKCFEBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3vrxvagYKCFEBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785707712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PbBMXqyTQfOdEQP+TBH4NONBT8Q85IiQo7bFMy00X9U=;
	b=5CpfOYEbMzLW3SujQ2I7V4zoJ74ne9poj5UMhTfri37YfOVSTDqlxGHbA0vsfQVjCDyNN0
	Xror9g6KDhuSFXqG7h9BsylQK7w0LpBy/tv0YChiQryVsIYd3AhUZ5PRb0ay2lJXnwmWjj
	pqVu1jR9Hbd5n9+q7mMIZjhcqjkdLSM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EMd0+iZb;
	spf=pass (imf20.hostedemail.com: domain of 3vrxvagYKCFEBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3vrxvagYKCFEBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785707712;
	b=m29c4IEeWnAiO08VU4LOMBXI9WvumtEtLMjTkdpCpBtxPjaicX1Tg8/2FSgX48U986SBRU
	qEoRx0vTTqA6f1McVByVzMNV8MSh0Y+4VKM8hHaznxiULxS3ah0WvEsfCyTwRPC42pfO9D
	gsoUSODFRL0WZuee1xZmrSm+MATVTbw=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so3767367a91.0
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 14:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785707711; x=1786312511; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PbBMXqyTQfOdEQP+TBH4NONBT8Q85IiQo7bFMy00X9U=;
        b=EMd0+iZblzO/TNavjKdxu0iew1z49Lyt8N0GP4JOKo72hZi3sQiOSwrcTzG8KlzL3C
         0FXtw6BEpYJQoHDePhO+iDCVijTRtx+AyN/1QcMmjwsYEm6Ohl0SMPZsbjBmF61WjMlv
         rcFBvFW5Jf/EQpHHQj2LNvvO4qu8LXVcrHdH+ItV0Hm+SRpFd6zMfDgpg5VDYp6Y5cPR
         QE1brlHBnS/gfKvbeuRgHi2YTAd6vixCiTOwClAPW96MfOQoaASJcq5ltkjhXD26HwLL
         aJFmif2hkMS2JCiGnJD2j4YkfhcApyW9EWwF7IyWaEDm72EsQZkTAwlIz8vZLaeFZItk
         SIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785707711; x=1786312511;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PbBMXqyTQfOdEQP+TBH4NONBT8Q85IiQo7bFMy00X9U=;
        b=ah2Lsdrt5tApyke3UNcil52XXJ5zqrqxtAg5rOI3VR0lqM+3l0ZU62rlh9DLl57lvo
         reCXuEVTHUDYjqbEd4/XduQkHY97FAwg6Bj/H/dNOxEx05Qxi7Z9PAOBb5Pn/OZAyHGG
         hDeRleHyoQo9dFmdrPksk8ILvLZoOJ3rKKFpKaZTooCJo4uJwQ1D+Gj2LRyANy3K6pat
         wYO+g9PHSFFYsttGptZD7kUahhKr2O2VBY24/VaslerG0nFxKPkM1O8BL0CjzBrzPe/v
         TvMhYeoLSA1V0GkJ8wz0WPWy69/Jfov+rYWeXhpAQb3cOU+NpH8H9pmnlycQhy1nnfmz
         6tzA==
X-Forwarded-Encrypted: i=1; AHgh+RoITIOvgFQQPijKt+nyPYJaWheg+M5ibdO1/bo3Siqjo9kR0LM2jLcRf7y0klqG+/6wzMoVqU9NBg==@kvack.org
X-Gm-Message-State: AOJu0Ywd4Veek4sH1THEFt2wHxFGVdwdKLazbV765KI1bkEujk2lTEuy
	LyHsWAXHSvtVOzJThTedKCP5xBqNpbTXriiBu0+UnMrKFkdYFfgg01nmCKRJzEgaXi0SrL5A6zX
	+vqaRUA==
X-Received: from dlbou23.prod.google.com ([2002:a05:7022:1117:b0:13e:6e68:2a1])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0c:b0:37f:c69d:ce69
 with SMTP id 98e67ed59e1d1-38fbc432bb3mr6817011a91.10.1785707710250; Sun, 02
 Aug 2026 14:55:10 -0700 (PDT)
Date: Sun,  2 Aug 2026 14:54:57 -0700
In-Reply-To: <20260802215459.2769283-1-surenb@google.com>
Mime-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260802215459.2769283-4-surenb@google.com>
Subject: [PATCH v3 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F311A1C0007
X-Rspam-User: 
X-Stat-Signature: yxxdp94mou5qyd3xhjya8pxk7j1hgfjt
X-Rspamd-Server: rspam04
X-HE-Tag: 1785707711-375583
X-HE-Meta: U2FsdGVkX18sHEl7cjmgfJGq/L2pDHkJ+Du+ikpDuRauxydCC5ZJi3Br4yGVMkdIMPaxFu3xS0ihVLOqJ+EiqKjJ393+gwVY5P85RhuzBLYw8p5rE94HLjZBWgkrv8uFAdLyjFwrws5aUoRRKOSj5GF0kSsLku00ou3JPxOwp8zocipgqzZaUVYFragySQmHVApt0g/l281U1XOezvpikkXlNs8MS3CJKHx0QaMZNl7MmAtBvGuDVSDtE12xVTpCTaGqYMe4+vvIvy7bTlORDMcKlu4MhuRKcHPcIyytNbi0Pav5jgGwADPtXwjdlvUa+Fp6EXHj25PcU0TjGQp7a2Py+iGtgqunppZXhMUR6D9V09RKbiMkqrm+fr1oP3R5KtyNwyeTgD0VClnS9wwKSxAQGbAUT0qvtUQdcFV4ONmdh479/hzZoQgjmO8Ywq7Yw8MWGHzyB+YUaaxTziuVaqv4fSs/k6GH+ZurWQRFNz8dcPUV0Iy6B+W85BDKYGiR1jfxksUcifeeycT0MspXCmg2Z1dRj4vXza38L9h5f0/Ubf/wtE+iNmydeiUT6jTrxoFAR9XLjI7diPt10pYg3dEIlERY2LJ0K3f3l/7DWT5uTB81x5+R8UNlr7nvDnR5UAY+OlTyw7qDySo7LNR1nOUrqJMF3dFY3EZyx1JMl175jtU0bjAHdJHZwQuHFBgGQIS3nEbIpd29NtjStRyGB4JMlYPBcZYHCUW92WtdHAprjQKEuqBfM48fghwuBwTwa8Sy736H2R0uK61tHYfLC4ODvkPc7Qn1cBiYq35U6fYsSTEpuZlJIEU4jNvQ9cnJIhaP9/1NwWYWu27bL0cA5xHI4YXLr1FWXjkPcVNBnYd+MuPelUyW/N9EI2OHfrQQ8cWln92aOIBuXn/yrErt4k+K3PzCnKNiSbmLyffTvrgRU2T1+lUx7j65Y7wR8aICVmJ/31m5bciG5Kxd1Fq
 cgmHoIx+
 3kaJr74wceTnzIKgzSVjDeAhcqcjr0aZ80FXhZtaqoDDlwzSvFlPpFS7RqPBu3M3TfDwTpdo6rKXQFR0uKlfSHhjuMjKyOBpStrrJsXBZX55621F7yVOSn9E80EShLtORVzCLUXzM5fApLZZ9Dyim86KKmEMxGTSIH6vPoz++SngynoCDWYnJar0nXEX0xxPJjqB/NgOwzBso8CqDUidw5jTuf2E2YFz9bDwzUS1DwDzsFCZbCtmilt5r8rfOud4/pa3RCi0vrfz/WIbGTHaAPAhxEDqvuPT4d7852fKMmd+DSA505ELUIJm6gps4SG5o0VlLwRD/KcGaBcPBmtMueM2oMo88p06P2V/i3Jsy1b76EM/5Zj0DbwuBE1YqqFJxrKO6kNMyNArxpMC/KyroBcg8zPRFBytTJC/wzVokO0j7cQmiKFQ/D460HVqhuGrcJf++S3yUGno8f25QxsFtvyci3dV3vrzvwFwADj1XN/ibcYmM3Kr4vxUzaI/WwtGgVQjI/dWKhVAbWTZOzDNGaMlTUqJ+V3Q5Togkl81iP9nkozRlvd4KnVnPw3eQWOGMN5iZry2WwqHr8HpPHPNAuGN74uJqVQEXzpx23yERF3uRy71ei4ntf+az2ae3ShUsnmkIx1l1qr2ZwbloADtQ7e3l1j+b5vN9p6D2eX1k2veaH5pcWjxmvbRW4xh1rMb68K60WS9uf29p/ymQB+e3RAufaCUTUIOkdM1NyMxcyN82S4S5JtE4LvW1L8gkxwj/EPxYXIhSN+3Lp9vFR5y8U2JMFiXTGLVreL4BA++PI4jFegvj1QMiVaHbQFCiBtr9G10aeobz/segSct0ReQOiOPC69amFwJcHXFhxKK+tsEe+lbeq7FYJogSI2DD75lfA5OmuElEAjTHwg3KgpHdBwEpEfCuTzOqEXLV1CcLOSwSTYaf/afZpQ5uRvlRWfRioQmi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

=3D=3D Background =3D=3D

There are basically two parallel ways to look up a VMA: the
traditional way, which is protected by mmap_read_lock, and the RCU-based
per-VMA lock way which is based on RCU and refcounts.

=3D=3D Problem =3D=3D

The mmap_lock one is more straightforward to use but it has a big
disadvantage in that it can not be mixed with page faults since those
can take mmap_lock for read, which can deadlock when mixed with nested
page faults and parallel writers.
For example:

	mmap_read_lock(mm);
	// Another thread does mmap_write_lock().
	// New mmap_lock readers are blocked.
	vma =3D vma_lookup(mm, address);
	// This deadlocks on mmap_read_lock() if it faults:
	copy_from_user(address);
	mmap_read_unlock(mm);

The per-VMA lock can be mixed with faults, but they can fail and need to
be able to fall back to the traditional way.

=3D=3D Solution =3D=3D

Add a variant of the RCU-based lookup that waits for writers. This is
basically the same as the existing RCU-based lookup, but on a failure to
lock it temporarily takes mmap_lock for read and waits for writers
to finish before locking the VMA, dropping the mmap_lock and returning
the locked VMA. This has some advantages:

 1. Callers do not need to have a fallback path for when they
    collide with writers.
 2. It can be used in contexts where page faults can happen because
    it can take the mmap_lock for read but never *holds* it.
 3. Its fast path does not require taking mmap_lock for read.

Basically, when applied correctly, this approach results in faster
*and* simpler code.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/linux/mmap_lock.h | 15 +++++++++++----
 mm/mmap_lock.c            | 29 +++++++++++++++++++++++++++++
 mm/userfaultfd.c          |  6 ++++--
 3 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index eb32b482434e..fdd8f5cf5722 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -228,10 +228,12 @@ static inline void vma_refcount_put(struct vm_area_st=
ruct *vma)
 }
=20
 /*
- * Use only while holding mmap read lock which guarantees that locking wil=
l not
- * fail (nobody can concurrently write-lock the vma). vma_start_read() sho=
uld
+ * Use only while holding mmap read lock which guarantees that vma lock is=
 not
+ * contended (nobody can concurrently write-lock the vma). vma_start_read(=
) should
  * not be used in such cases because it might fail due to mm_lock_seq over=
flow.
  * This functionality is used to obtain vma read lock and drop the mmap re=
ad lock.
+ * VMA can't be detached while we are holding mmap lock, therefore in prac=
tice this
+ * function can fail only when there are so many readers that vm_refcnt ov=
erflows.
  */
 static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma=
, int subclass)
 {
@@ -247,16 +249,21 @@ static inline bool vma_start_read_locked_nested(struc=
t vm_area_struct *vma, int
 }
=20
 /*
- * Use only while holding mmap read lock which guarantees that locking wil=
l not
- * fail (nobody can concurrently write-lock the vma). vma_start_read() sho=
uld
+ * Use only while holding mmap read lock which guarantees that vma lock is=
 not
+ * contended (nobody can concurrently write-lock the vma). vma_start_read(=
) should
  * not be used in such cases because it might fail due to mm_lock_seq over=
flow.
  * This functionality is used to obtain vma read lock and drop the mmap re=
ad lock.
+ * VMA can't be detached while we are holding mmap lock, therefore in prac=
tice this
+ * function can fail only when there are so many readers that vm_refcnt ov=
erflows.
  */
 static inline bool vma_start_read_locked(struct vm_area_struct *vma)
 {
 	return vma_start_read_locked_nested(vma, 0);
 }
=20
+struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
+					       unsigned long address);
+
 static inline void vma_end_read(struct vm_area_struct *vma)
 {
 	vma_refcount_put(vma);
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index e20d01e8d38f..6ff05e68e61b 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -338,6 +338,35 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_st=
ruct *mm,
 	return NULL;
 }
=20
+/*
+ * Find the VMA covering 'address' and lock it for reading. Waits for writ=
ers to
+ * finish if the VMA is being modified. Returns NULL if there is no VMA co=
vering
+ * 'address'.
+ *
+ * Use only in code paths where no mmap_lock and no VMA lock is held.
+ *
+ * The fast path does not take mmap_lock.
+ */
+struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
+					       unsigned long address)
+{
+	struct vm_area_struct *vma;
+
+	/* Fast path: return stable VMA covering 'address': */
+	vma =3D lock_vma_under_rcu(mm, address);
+	if (vma)
+		return vma;
+
+	/* Slow path: preclude VMA writers by temporarily getting mmap read lock.=
 */
+	mmap_read_lock(mm);
+	vma =3D vma_lookup(mm, address);
+	if (vma && !vma_start_read_locked(vma))
+		vma =3D NULL;
+	mmap_read_unlock(mm);
+
+	return vma;
+}
+
 static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_stru=
ct *mm,
 							    struct vma_iterator *vmi,
 							    unsigned long from_addr)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index edd90892f8cc..c3a0c38a3dc3 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_anon(struc=
t mm_struct *mm,
  *
  * Should be called without holding mmap_lock.
  *
- * Return: A locked vma containing @address, -ENOENT if no vma is found, o=
r
- * -ENOMEM if anon_vma couldn't be allocated.
+ * Return: A locked vma containing @address, -ENOENT if no vma is found,
+ * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcount
+ * overflow happened due to high number of readers and the caller should
+ * retry later.
  */
 static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
 				       unsigned long address)
--=20
2.55.0.508.g3f0d502094-goog


