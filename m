Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F40BCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7620A6B0092; Thu, 11 Jun 2026 09:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECA36B0093; Thu, 11 Jun 2026 09:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D96B6B0095; Thu, 11 Jun 2026 09:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49F716B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:01:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F37BEA05FA
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:54 +0000 (UTC)
X-FDA: 84867644148.14.54C8283
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id B7F6140010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p3ZsXKS+;
	spf=pass (imf17.hostedemail.com: domain of 3vrEqagcKCCUBCBSOBTHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--abarnas.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3vrEqagcKCCUBCBSOBTHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--abarnas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iN7hrd6qn67T2t3j/i98eZyOA4V4M70JMbuUd8RCBF0=;
	b=cUWZJxFEnSqRB3pQSIkcEEychxrqhKS4T8bFcSnJZkXrZRTjjeDdo+gZcM4MHCeqj56OPX
	lvNVdWGloJEL+yIcQILgNrfT9YmXGYUL/azwZtEU5OZ8FdCubw7KH1kIusroSnviJT/i1w
	Pz6LzFHon6TXqh9qz9vIsA+8BDFgLbo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182912;
	b=dZySP6WP1qmfIWZRbbe4Geb9vQLrA++XeeXCR+d6bbz5f20OTGAgCbjBxqcBw5S/P8yHQD
	gBs0j+gkPmGXt1D+NhJ1TLO4IvClu1VeosKeFJXzBMc0Me5Jtbp5u5nSwDkJB06z+zEb2U
	DRV0cSWtxc3bNV8lJmgDpV2ReSD47lg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p3ZsXKS+;
	spf=pass (imf17.hostedemail.com: domain of 3vrEqagcKCCUBCBSOBTHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--abarnas.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3vrEqagcKCCUBCBSOBTHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--abarnas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45efb6e60e4so6764087f8f.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781182911; x=1781787711; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iN7hrd6qn67T2t3j/i98eZyOA4V4M70JMbuUd8RCBF0=;
        b=p3ZsXKS+RRFpkodFzinz3Dii1drFpqUvSTAC+oh4OEVmlg4QxQhMu2JChwhcPkRg73
         a8ah/R9lt/o8RDrBKLrGs4OVJV+IV34ovaBjPhyjfzTc0AxYPVo1eiH0schMZsuu3oKb
         C83j++tkoVovcptFiP1dfDrgOnt3419ntGj/Sn1d2bfrKb6X0RNZYkCzHgHW+ibFWsHU
         n2pXTwXI2mdxfP8SzqgKCxyckHSywtlwGEydUMzg6ZOiNsfnq3aSrXTvoYiFW/vXh6C3
         eeRnhyzkESRTERbSB8vU0iE/s+RHvm8+rJyaUn7h8hmKRqxlRp7CG29qIo+jM12ATRxr
         qEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781182911; x=1781787711;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iN7hrd6qn67T2t3j/i98eZyOA4V4M70JMbuUd8RCBF0=;
        b=Qrzpcw27BLhKKT+9jQlQwCubrMgPEf+OkLm+nan29PcyoIh9GHoSXKF9Nlpx0w9wc4
         8mhtMRWdr1aJ1BYhGwhHaYK5xWmkUskcAAaidW8qiMj9mxEdokCloKf9wPj0A6Qvj2p7
         RYkvZ5HDpsfW5tge5LdOegOGbHt3jG8fB5ZBTnQDA+Fjrh6dujiIzbQFmqxGEpFI1hpE
         mImoJFEIhezv0emnMrLfeUH5+8/DyrgvMu7LoPcex0qonxH8OJ2uoXukCdzGdU2jfD+2
         k9hWArq2jjZpX8ubdnnaEaUxVeSt3p143k8Et876QQ2ALaZmo4en/Jf6w0xNhs9YTB4G
         5c3g==
X-Gm-Message-State: AOJu0YxdAz5nZ2P8vny00888b6W33+iyy8Ertto3G3fbKjCJ3R7OaVEK
	iiFyhS7eMOR34RyyVKUptHhP87lAxjGfLtRwhLhpCSzJJXOQyU4V3KUfqNOP/1nj6Ey5DeKoGZi
	YarVAYB4AlQ==
X-Received: from wrqd14.prod.google.com ([2002:adf:f84e:0:b0:449:a1ea:d14f])
 (user=abarnas job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f83:0:b0:45e:f4f7:7cad
 with SMTP id ffacd0b85a97d-460677f3340mr4265866f8f.39.1781182910754; Thu, 11
 Jun 2026 06:01:50 -0700 (PDT)
Date: Thu, 11 Jun 2026 13:01:40 +0000
In-Reply-To: <20260611130144.1385343-1-abarnas@google.com>
Mime-Version: 1.0
References: <20260611130144.1385343-1-abarnas@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260611130144.1385343-3-abarnas@google.com>
Subject: [RFC PATCH 2/6] arm64: mm: allow huge vmap permission adjustments
 with bbml2_no_abort
From: "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B7F6140010
X-Stat-Signature: cof96eakfmnk31byjufnj5q6izcaogfn
X-HE-Tag: 1781182912-863028
X-HE-Meta: U2FsdGVkX193oOMMWoTC16nZBzRHsKSI8rWkFZXY5ZvKgAZsJkvKEago0BbuaXNTwRtQlCtWeHrj35XHGgOWo7mcoRDd5HWKdtYT8wKKASp+ZZcVi0vmHJx1+tCfTcvstIf2agOlcODNsey9NVUwtFxOfs70ZcnEi40cSK9ekI4+avSFJNh5bvbzR/0JLC2ZAJC7vmuwEoelWCQZIpBT4P21KyMivttt3UTC+8OKKSv96VkKMs5o5b1YelbI64p10YtR6zFLmmWqqc3NNRhVuri2ahLbZj7russHr8TowjUdafu7iWGgfcgrsjU6YAoSrKIqNfHSHxOYoyOE3TgBILO9re6ficFrb7KFMdRFoK1vvofJ+4Zp0oZbrFwAxyRB11rPLYTtYerG1FiiqtNBHLmAdm1oZTUrmrmO6GAqXeEA/TE01HNHJGo0A4VmPkgpLCcQhBUiwRDoIYbX3n4Z/1xasDbwQ4cMrHXuSh5cfdwlNhKFmDq1InKHboBToffN2iru3JnGff2wE9Skv/F/nyMTbT6thvCV7qBAIVY2Hu7QrqvTNlAvVdwFX8aZQC1DLYxoZSVkx3q1Vj6tyHBvcNp2/mZvyCDGoh+A7FFPXaGeQyawV1pJjDIcLkGpBXoxpSh4x1fpGN/eTpD176CtmkQxKsj3X9Dp39Tc9xhFuNrib1z0cdQQPVTfq+HhBDFq1KcqPVwmeD4SCX1Q3FAMK9XDDZQcNe/3E5tMn4J0ChtMAHgkpfAaW8EKgeoauh8cWDjI5ZFQlY11iy3j0h80LrKRef/UENIGJ4LXExnwXcO9DHao+rtv5/hfg47obX2sIi2Y60c06MLfagQr9FvowLATxiCmviSqZ8aFtpe4s2YowhQaOTzs0Gpy5TxawciFVHtBNNH21HeP/B3uyPos94n45GS9cB6zBm9cwYqHzTbb37xxTOe7DEngXetEvgZmYr2cqI0ISdLlA+HIF2n
 u1I2Xv8H
 sP5JywikKJQdUcypVE8kFLhciHIf4AX1AJrRqPHkkIYfHj8Pwk3EDSnWv2QLQgFl3SdyC00hcIMb+fOc+QBXssNi+PugGBZ5FaufM/aNWBSl+YT+CW5557WYuGeTIDRoDaBbujsa43J7g54QYfQtSaCAF3PNGJqPQ5kxMAkpbN4dA4NhoPqsD96nrOGPPHSlKpye/TqOvqHevRc/8aQUucw35+KbXCTvLwQXAzI+8L0ZhBE2uQ+kkP0th14BmOZ91ojM/4imR5cSIlgBLO3BOzAya8S/pyuIdBFHJxTXhzPAEScx7+xxoLXWa/Zijkp0SZfrPanTFa5QM3arpi+e81HdT0WhU7YnLN5kAKJPi4B8j4mRL5Nc45HVm7Wge8RN3aLa4ifjzXLRUp7M6VYp+9ygZytzNoWrWQ3DYlEKfELBjXLeMOJ0N9jNkMZvaCZX9GeHlVdt+GDdG1j4Fi6hkMQ9Yw/Z/75kjU54x9Yy8iTTP2SOeJ4ZlwSU6e401VOUEfHZdfKu/Q3yjhPI+doKrWcko+BkuR5CE4Bn83XDjgvnlFZRJ6qBUiFC6SHvp5zgQqTs5eoI9+5WSGRMeJWPKFayRMj75SCj22Ml4fJQb6VOYFWq/q1VIwHePXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the protection against huge vmap permission adjustments on
systems that support the bbml2_no_abort CPU feature.

Splitting live kernel VA section mappings into page mappings was
restricted because it could cause TLB Conflict Aborts. This forced
permission adjustments on memory allocated with VM_ALLOW_HUGE_VMAP to be
rejected, resulting in performance drops (e.g., when enforcing rodata=3Don
disables huge mappings).

The bbml2_no_abort feature (which mirrors the architectural guarantees of
FEAT_BBML3) ensures that changing between table and block sizes without
following a break-before-make sequence will not generate a TLB Conflict
Abort. This hardware guarantee makes it safe to allow dynamic permission
adjustments on huge vmap regions.

Signed-off-by: Adrian Barna=C5=9B <abarnas@google.com>
---
 arch/arm64/mm/pageattr.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 358d1dc9a576..88720bbba892 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -157,23 +157,29 @@ static int change_memory_common(unsigned long addr, i=
nt numpages,
 	}
=20
 	/*
-	 * Kernel VA mappings are always live, and splitting live section
-	 * mappings into page mappings may cause TLB conflicts. This means
-	 * we have to ensure that changing the permission bits of the range
-	 * we are operating on does not result in such splitting.
-	 *
 	 * Let's restrict ourselves to mappings created by vmalloc (or vmap).
-	 * Disallow VM_ALLOW_HUGE_VMAP mappings to guarantee that only page
-	 * mappings are updated and splitting is never needed.
 	 *
 	 * So check whether the [addr, addr + size) interval is entirely
 	 * covered by precisely one VM area that has the VM_ALLOC flag set.
 	 */
 	area =3D find_vm_area((void *)addr);
+
 	if (!area ||
 	    ((unsigned long)kasan_reset_tag((void *)end) >
 	     (unsigned long)kasan_reset_tag(area->addr) + area->size) ||
-	    ((area->flags & (VM_ALLOC | VM_ALLOW_HUGE_VMAP)) !=3D VM_ALLOC))
+	    !(area->flags & VM_ALLOC))
+		return -EINVAL;
+
+	/*
+	 * Kernel VA mappings are always live, and splitting live section
+	 * mappings into page mappings may cause TLB conflicts if bbml2_noabort
+	 * is not present.
+	 *
+	 * While bbml2_noabort is not present disallow VM_ALLOW_HUGE_VMAP mapping=
s
+	 * to guarantee that only page mappings are updated and splitting is not
+	 * needed.
+	 */
+	if (!system_supports_bbml2_noabort() && (area->flags & (VM_ALLOW_HUGE_VMA=
P)))
 		return -EINVAL;
=20
 	if (!numpages)
--=20
2.54.0.1136.gdb2ca164c4-goog


