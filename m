Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348A6606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=xGVKbNkK
Received: by kanga.kvack.org (Postfix)
	id 573836B05B5; Wed, 11 Nov 2026 02:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523446B05B6; Wed, 11 Nov 2026 02:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412176B05B8; Wed, 11 Nov 2026 02:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8916B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:09:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 956121A0227
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:09:37 +0000 (UTC)
X-FDA: 85421962794.06.9B369B5
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id A6DE51A0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:09:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=xGVKbNkK;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794380975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pfnkpC25liOJ53c0mQZ6/TSQvyf0Bspw+v/pqKKkn6s=;
	b=UVJSbzerrVbbTHf0huTpE3+vOhzZiy2CYn6DVqMQuGbhROl5btwWMtLKGMcdiI/5d1IUgk
	ZM/QSEptBoYu+4iyzGYy7VrlK/coibkQ3A0TCywh7hf2jp7zUJVVjrpPHbNY5jY1ivpVzp
	0fkQyq5LT3Pud4GOVSSfb6/346NCKgQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=xGVKbNkK;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794380975;
	b=KpDMIGvfMbkuTqyapqbWZOjQ6jAWfeT9J5czPoI1PgHzs+KnDTEdBehNVLA9Vp4Wcn7SSf
	4T2d/Oa/em5HMCtF8OUEdHr0qk9Fv7nFGOeoJnqvtStje6NNmSdRcyNxlyMPiYxIFcQ0F4
	EjC7ujy1LIq8cuflxP4Pv6hQoApY5rc=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso2027008a12.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794380974; x=1794985774; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pfnkpC25liOJ53c0mQZ6/TSQvyf0Bspw+v/pqKKkn6s=;
        b=xGVKbNkKBWt3S/EE9shRBJ0gQ5zTPt7ASjLu9ZKMwALcBbdzeIUOLtcKZMmPw6e3q1
         EzlPdqk/vZluiYtV+eo5Dhg36kbxFDjpUghoJhCMGX2eFUgvwamEl+DTagXJDUJtoB9G
         LXzfXGlPzhDyM4KtLzruFUN8AFOqD+xQWM5iU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794380974; x=1794985774;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pfnkpC25liOJ53c0mQZ6/TSQvyf0Bspw+v/pqKKkn6s=;
        b=HqmLISkcyv398Mv2+X/Y0kc3sJlkL2MGK8Z0OP/e5fYBfX9e8TETrsgnm4Q258nzem
         LldJ3SKBBKH9WeCoPFkcS5E2PZerIW/HDpWFPcAi624wZe+gREk3/IfLsPIlKQyupL94
         COx+yfljrsSFIaFya7jiiS1K195fe87Yd0feCLfG2lf99/93yp6bLp8m07FO8tA92jL+
         55lgeiq884akKG6A0oWM+NUrl9pIrX9cy4CdpSQH8zDGRFjP7M8g/178OLFS6wM3JWRg
         +3a18zunVATADjwxRFsO77r4r5lZv5ZJ7muNoWgWJdUdilX0uuROh/ifHZUa5vNLVEph
         nWrw==
X-Forwarded-Encrypted: i=1; AL+hErHmcC+yEJfGgN7uO8pKUPznnL9eN4bm21DUpBh/dH0WgEkWO76GcYgBDQPNHEvHLRyR6uGe9Dul3w==@kvack.org
X-Gm-Message-State: APuU4Z/J7Je51TuGdB39POSzoqmlLAFdVbWTuiXHuJEQmz86jqZ6hK5E
	7UK82/Ec4eSwTp7s9IGCGnDeMvP53LCh8naFpc6lgyq1FA4YIElQU2sEgwwAXKW8J5s=
X-Gm-Gg: AYBFou2HYVdoKogSd8stZAhQOQEj2CkY82/P+5hbtSFDF5/LZhEHjV23XVDiOk8UDq4
	pezLRr0FaOonGCVqKFqKhBnPooxEWbOOCN7K88R6ZgOa/nkwN04/ukPVHDEFQSzqp4deZ3bnEFO
	maAQNS2Rx19b3JNbCmp11CAmEuhPDyGSo95g+OI1d3JA4Ign3aJsba+yENVaekM0MSR4EYfkOaU
	te7BbdYsTvWbtpS/C0sUjbT+bIznFKyaHpOq0mke+qxCHDlqaeElmvjkYHswufw8so1RS731qvD
	3lnfwlo5fvpw/NgSsdClt+422dzlEqv70ZxBR1iz4iHGOAAxFIv99HxQWajHq8L4U10G46GSujJ
	o8hXNVHiZht8e2vJ6hTr2juNB3W6S76gZdg3tFENPm+46m87nqr6gZOPVe5He95IJ5PH2v6IZHK
	/I6CPl8fMLx1d+j0wPYqk+VlNDWDQkhsBAY3eDWUZS6gigc9Bwpt4IHlAJ60kz8bVvQaFv2JNql
	a1eDgQRTMauYARARUnjf9tvOr5rTbM1waCrluij+Cet6qS/IWx6h/tocEsknuQFR/MOpf1Rg2V5
	lubG+s9yZMHD1m1lcqJG9yfW6TJuMdEHkbfqDLNzdyz7orGiIKyD6TacuOeydkK8/Ddxf8U/6h1
	ycrDa/7w+zitKuXrubgOPj1f6IPOw8mWw6w+inijUpxuiAsR15U2iKwCYky8m7bF1Hk888GqpuH
	ZhUZMVT8s/ik7sK+Eb9/GawdIVgHCq+5Q09g2Xp6HMXux1D1XhYi5/
X-Received: by 2002:a17:90b:17c8:b0:3ac:9f24:44be with SMTP id 98e67ed59e1d1-3b182edc482mr1816027a91.29.1794380974284;
        Tue, 10 Nov 2026 23:09:34 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17da51f80sm3175523a91.1.2026.11.10.23.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:09:33 -0800 (PST)
Date: Tue, 10 Nov 2026 23:09:30 -0800
From: Chris Down <chris@chrisdown.name>
To: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org
Cc: graf@amazon.com, kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH] kho: Prevent reuse of preserved pages after a reservation
 failure
Message-ID: <avQUquBK6cO6tUUI@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A6DE51A0007
X-Stat-Signature: upxd4gd9s1ex5zkge18ubbs8bdcoxx5a
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794380975-977185
X-HE-Meta: U2FsdGVkX1+qSjHx3OCivArkKm27CSDsCDkvB6r3KO/wlpx/1mSpswcUPtNmbrsHrQqoLUc9hyCR1Y1b4l0g1XssrT2AcvmnT6uMMlPmMsXWJTixcoqbOY9Zz1jnQIsffxSetMY7E0rSrAKmcsCGAx1UHxWTLKfqWWmbfiarMJ8UMZ7DxvP7wYl7jum4p11LK+XMfGlJv51jjxGE8I71vHldrn66nochWKRX1wvcYQ95/0ai7EnMZO6PMe1A4LG5x8nl7FPvQhJxwmRCLHNbUr/c3D5GBTLK8C2uVAtRB7MOSibB3cnM5oddp0l6fWkZN/gB/WIlmjNbHkmMe44zKXR9uy8TvCKprLsNLsLOZLCoYkk/7M7cznx+uw4IoNn0ac+WF6hITWgR72hUoewrXFX1Q9uxL1sHijdQo7MNu9ELTam18ZOS6DILmFzG597aUrjzHmIa6Sj/QxJoBkr77zg3n0Vfu2rSCticeigW2Zgi4Kss/CFDR+Oqin7I7E2cG/gZJSzQ5qgWeZ0mfg/ph/a0oBGPNrZsC4gVXCJ2pl82GPGCcqZPAT1rR1QJNX55YoLgLS1v7dUqDy9mrlvOQA+F9lI+9vooHmslrydoiuKn37Ofe1ssS28KJzosR5R3Xr3Iq5uCzmfCww/1ogbBmDw/kk2cky6v7qwvIwFVDczwqZP7GxbiEN15SK1OllLsYIZwFEzRdbBStCHxU7iZrXqCRIh/ZqThs8SuQcxwP232KQhjELo0Xpde3XJZDDi2ZvTu/q5OXgJOCpmIOKPuxnTonqMPsMxZuR5GYfpvqo4HGZyDkDCB6PxN2nwv4lyFwdSHmeCrOwcUu97KSG99sSpoSwFSvVfuDB6yGtKxaXrAEE5Hr/EBNQzSdleRW6DYVDqGwcD+KfNk+ids8dC/KHo/kMVjZXehVj64QKhRQrqcKDqJfI1yZZXlW8+E+vt/J0KdF69xOHUnA+FmIbR
 57FromYI
 UhxpbbLD4bTXUdaYcku0LWQ3FKF1PAnoHxq9dbJle7fz8U3Y1RIZezB+gzWlslQHjT8Cs54u8MKbo4CYaUVn8TKhoQxMWEJYoNnVhz6A2eNA5xzXsme/agqNDSywDP7bVN60kmH59H5bsA+VXuvvSSzsgZYNfrrVl0Y6N/SyhWFaZnlLW2HyXIdQHNhACfWC50PKZfDx/xqT3g0f33IQ3UIMN5ezz6AHSHonhi/FaGsbOl6Jb6KjNt/Ulq4r1Aw5sQMUgvMZW2L5FM89WD3GsN6xuVhkuT3cImWtsrAHvNgajBeW9RVHinpLPPw5htVBuOBVsoZsxGNRxWiEXaf8FUJlwaBvYDpL/+DwqQWLPCO0MZhtONDi2VNBq1+2B3Re4uxPOFt4nzBTu/PTwHa6K+o+pnnRRm/aM1CO4k8ras6plR3LqY6AEEIQem54ZPxS6yMmkoNfGcju6MMVQp6gH+mLp5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kho_preserved_memory_reserve() reserves each range of preserved memory
in memblock and marks it noinit, but ignores both return values. Either
can fail when memblock has to grow its reserved array and can't find
room, which at this point in boot it may only take from KHO bootmem.
The boot then goes on as if the range were reserved, and two things
can follow:

- If the reservation failed, memblock_free_all() hands the range to the
  page allocator with the previous kernel's data still in it, while its
  KHO user still expects to restore it. A memfd preserved through LUO
  can then get back pages that belong to someone else. Oh dear!
- If only the noinit marking failed, the struct pages can be
  initialised later, wiping the KHO magic, so restoring the range fails.

Dropping the handover at this point isn't safe either. reserve_mem=
revives its regions from the handover before mm_core_init(), and
relies on this walk to reserve them.

Carrying on could hand out private data, so let's panic if either call
fails.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 kernel/liveupdate/kexec_handover.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index eeec298aa9d6..0faa21ebb0cf 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -629,9 +629,14 @@ static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
 	sz = 1UL << (order + PAGE_SHIFT);
 	page = kho_get_preserved_page(phys, order);
 
-	/* Reserve the memory preserved in KHO in memblock */
-	memblock_reserve(phys, sz);
-	memblock_reserved_mark_noinit(phys, sz);
+	/*
+	 * Reserve the memory preserved in KHO in memblock. It's too late to
+	 * drop the handover if that fails: reserve_mem may already have revived
+	 * regions from it.
+	 */
+	if (memblock_reserve(phys, sz) || memblock_reserved_mark_noinit(phys, sz))
+		panic("KHO: failed to reserve preserved memory %pa+%#llx\n",
+		      &phys, sz);
 	info.magic = KHO_PAGE_MAGIC;
 	info.order = order;
 	page->private = info.page_private;

base-commit: a0dc8eddbfdb6dd9c5c2b70eb66ab49cb1978425
-- 
2.54.0


