Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03463106F2F4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31DA76B0098; Thu, 26 Mar 2026 04:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6006B0099; Thu, 26 Mar 2026 04:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD2F6B009B; Thu, 26 Mar 2026 04:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05AD86B0098
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:08:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCE711A0C1B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:57 +0000 (UTC)
X-FDA: 84587488314.15.C3DF035
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id 079BB140010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e68fBDiB;
	spf=pass (imf23.hostedemail.com: domain of 3lunEaQYKCNEFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3lunEaQYKCNEFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NgLz5FVqf/NV7m9qbKXaNWE4w/1GDJf1IUGYhV4ad8=;
	b=tOp2hXFqm5sNK7X8VxmJfF8n6EPxzAzD4nKXltaHu490NQ8OtF0+sZQKMakdc+KLN0hlm+
	qLsYTHQkxXHoZnPt7OqBoCOpCOyTfiTDmusTwinzwHf3xYpPsOTAljfRnsmF2U6St/LE/y
	3B9U5GBOE0E+XF1PoF5/T2coJWznpu8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e68fBDiB;
	spf=pass (imf23.hostedemail.com: domain of 3lunEaQYKCNEFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3lunEaQYKCNEFHE1Ay3BB381.zB985AHK-997Ixz7.BE3@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512536; a=rsa-sha256;
	cv=none;
	b=eM5ajZFqiJgQFkZ5w5w73ucszLm44Y+5ZR/KfdtTkMd+P5u6/WSIgo88XiywAsF9Gc1P7D
	RvFBxseLJygHovoBDcFU+02qvEEwlVbdcOuSneIo2RHgVJGouvaMcEF32bM103oHox0DcR
	QL4Jenxnoh8V1kYsZ92fxwt8AJytEfw=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2c0ffce2570so4641823eec.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774512535; x=1775117335; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5NgLz5FVqf/NV7m9qbKXaNWE4w/1GDJf1IUGYhV4ad8=;
        b=e68fBDiBV4XgNq5p4qAoijXvZOn74KapLlz6usw/KuTUvIFN+j1MrYweJjpzJorkWr
         MWCSG8sLvfUKseDUvd4MSreqlgmLA2rIeHQOTmimdS8QRUQvxRIdGO4aDcHTzNf4J5Hd
         NxRh4/XnMtP7LRNTaRxyEvPPTOb7u+ZA+zfQRJ/XLU2gEYNrJwzKFkYIUQyLtZTqhBJU
         sGY8J0MgEMTnBzySmIf5oQBAIS8kJ3Z6hp3BCs0w6eGV+ENSGNg/4HQOKxDiRYg5ZYuT
         QdtfxklWGyijsY81kB/fmTDdLonOATvbKt1g6TY41p+i+cgj69mm46mq7KenesC818F8
         cDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774512535; x=1775117335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5NgLz5FVqf/NV7m9qbKXaNWE4w/1GDJf1IUGYhV4ad8=;
        b=QBIinsSo3/vjga6sEi660lmxVvnvhK7aySbH5+xdlVOByv+Co5fPAml2wHG0kcR45Q
         YeideVvbghL+Xy/zChuGMB9K7xiDiKULkMHwQUqi6h4H0OoQg5F4zMJsk0KtWVXeaQuH
         VfEv92CM4dSnOiYMlBfYzAvuE3nIjuP3Y0w+EG6SIfqR6veVygmXyMrVjsdkg07v4fI5
         4VTIHLNWG4QGibepEJjOh/L3BEsMHbETx3tGHr0qMWaRJ/m0KP9YqHowFjPJtfkYC3v7
         6gnM6WL1Fj+X4PzEokwBl4iZbKD8aBRAEHrnFPT0PjKYxIoSQWlF1zeLER7xSxqsTql8
         rBhA==
X-Forwarded-Encrypted: i=1; AJvYcCUAE6M5BGdBgqe7GcEnzN4xXuumV2J8FUIBBwcIDjND2+zgi+PUxE0wi9dJXjv2tMI0cs/dEi9WgQ==@kvack.org
X-Gm-Message-State: AOJu0YxXcwXd0J4GyeRcb5QdZrTWl6lnI56x2pRcjn6uGA+LKtacYI14
	A5ZZrmK0LPfpqivo5uXxGxCa2BEeTJze3t3iIc57PMVrGmSlmWFDrXC1q6gpv+Dco1UMhg+JUzH
	h5v6JOg==
X-Received: from dyt4.prod.google.com ([2002:a05:693c:8084:b0:2c1:63c5:aa2e])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:7304:b0:2c0:c96a:a4db
 with SMTP id 5a478bee46e88-2c15d2ba52bmr4025361eec.4.1774512534535; Thu, 26
 Mar 2026 01:08:54 -0700 (PDT)
Date: Thu, 26 Mar 2026 01:08:36 -0700
In-Reply-To: <20260326080836.695207-1-surenb@google.com>
Mime-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326080836.695207-7-surenb@google.com>
Subject: [PATCH v5 6/6] KVM: PPC: use vma_start_write_killable() in kvmppc_memslot_page_merge()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 079BB140010
X-Stat-Signature: odkaepa4yekxctyiixcw7z5ty9ezr3ao
X-Rspam-User: 
X-HE-Tag: 1774512535-338999
X-HE-Meta: U2FsdGVkX1/xLJlJr7ZmGekOBTPcAtN2ixDR7jjvMKcXRH1NA6H0S1ix1crwLdOgrySspV/s3wK+lKW1/k+VAdf1V9rtkYs8M8bbQLPjoSNErZrHJjU26z762XmgCgAhavMygnUApozjIYKAlzNHIGNRbN/I9r3i2EXsbRLCddt54ZCn5TsSskcMKRu5BUOIW5rYObqZ0aWng5kMuFZwGC3Ut8i7iOKuMze4fdZYZX/9CLkqZHT4JzAZYFSU7KmIMzLQJAM593dV83SaVPuYsjHpRTXTP79sMQkich8bYfSX9Qc2+E8uAJT4SwQzqOsYWGpPjMfPNhzz0tIz9LxQRkXBmxCSHX50hFsZP0rOKreVVbtBmlgJkqVCEzVcVRelpAkAaKd54FEBIjrJkoxSotRMV3J2iiIObkmlHolWOv8EJkZjnY2x6gzV2xxAM6Y4VjcrI0PnBrZ3sCfc6xx0U6CII9+GoWS3pQ5jsOdge/8IdNM/xbKvL3J6GPxiA+1ajJD2u7IgLb2zMArxdtD9RCFXJz5N2t18FQwI0fTDNw9PAT6VKr4/LjiNRBiIwpKAuhdaxsr9ajnYMDnw+FLeHIPrjRnoX3vBKO/S0u1xQB42b93yxFvjDYxFRB9hZnAy3InF0g1yAVL0QKp1SPQv3Rqr9TudCqHyAiS1nmJwpiuJzjAQ5ZID6V8ceMhcY7GHIXf60DqQoUmB9qzYHqMf1TgzyNQZn1Z/lG+aYpV7rmAVMrS/YA0Xy2JRR+uc5w3MJIC2dZKz8Jc831uoDimVKrnCeiPHfZbO5aPxrfqvOdOBV4uQEGjKAZ97OwmYdQXD+A/sX1/wWctKWpVnjVFiFTGOoe/ed6sRvy0v48YW3UCD3K3LD/IbLbbXo9fiNyqa98Ll/O6L69NtEWvVDAggp/9c78j3tvchOQP5+aTgoc62iVi666JyTHE7pkjXqSlJUI6z+3ScbTGxnuvFo+I
 q5nI153a
 kKbbYbhn7TL8msmOca9s3ZMfoUzkEqK95yBCAaqVRikp+sCxtSYldaws+WcFYKpz0JP/bNmOxfKCtvg9Y2Lcr26A8TspC7VzPrp5Hy4D+yH58YHqL4P3UanJOMM4RM8MqcqYvttKBuAk2u2aicML6WnsRu+Bf5iJEar+IrXwh3ndjNi5wXKVf1QZrLMINIZKfcbN4ah8ccaOwTmKp3JSK1ja4v0bSYSrVJhYd3AzZd/sD2037DXydsSBtKhsr60Gw0B6Dpy3RkGhHruneG/FGa4ynAWa7oJacAzQGDZ+p/fRCXQdCO4mqg4jzXCnifPzC3ReDdx564jHno6LfNNyVIlk9FsXdbntwsmzBn5MsvfPW41qwxnt4JnNuu71ZEHpKBL4Chzje1tipLj5LV6Tgo83K75gSVYpAPfL05OUHEDuBadlEo0wGzaLeAsulIREgRKClZMP9T+iTSxedu7+RTJkU/9zEZZFpWcYpheqHVIqmLHDukR0hXUmhqYw1meeA7KhOZ+74/tHl+kTLgO583vD3jRJP9plw4iYhjfjZ/e3Ea++nQPwvJPzycL9U28O6VCKNJw1wVio5TJ5Lg3DU6ZGCWjQdWZy1r24UDxLS8Uou5PjH9I136Mhlj98rzu4uv7V2Z3EvgM4wumbZ32NbPrtkkgK5FTw5MbwKML0aCDUYt/fssAe2sRgeg8fJ4U4w49ZV6FZ4BWzatatFkTh5ZRGXEoRargmErslCnKvDO9qfJ6niXEfzIwCIShwS8P6KZYVsnKXvNvNBCX/9/Kc+oO4lzwRHahGRZXXV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.
Replace vma_start_write() in kvmppc_memslot_page_merge().

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 5fbb95d90e99..0a28b48a46b8 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
 			ret = H_STATE;
 			break;
 		}
-		vma_start_write(vma);
+		if (vma_start_write_killable(vma)) {
+			ret = H_STATE;
+			break;
+		}
 		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
 		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-- 
2.53.0.1018.g2bb0e51243-goog


