Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2178CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE428E0010; Mon,  1 Sep 2025 16:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5DEC8E0009; Mon,  1 Sep 2025 16:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25F48E0010; Mon,  1 Sep 2025 16:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD78F8E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 840A41DF1CB
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:48 +0000 (UTC)
X-FDA: 83841875376.30.710203C
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id A6CF6100006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZQSjrEvE;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nlX/RfH4bxrhjLqRHCaPu5Q9689qctY9+oII9+YwlY=;
	b=JtjCX3ys4nxDPM1xWRse1jai/KrzliWmdMtZVCDGKU2QDQmxU4Lfn1a+hHs+rswBrw95Tu
	eR/S2k5uRjSfDn56jqfHbEat8wwvNXQzmfbeMGV/60MaRmJYL/8E2wX2nbxY24WR0RteM8
	/EK1VeYI40Bm2VtrrOCh+TyCVDZgSYA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZQSjrEvE;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759846; a=rsa-sha256;
	cv=none;
	b=KOiAdsaNjLKxBuYPUvFMeTnUHy2o+wPC0VMS7Zte8KtfTCkfuEXBgU2Nd/pKtjxbY6mkfe
	++X9ZausUkCvo35yxqhKhQKIWYrNXH0znq4qDOZEV5Wtn46sgpVCBp3Gc5fObXJIRT0J6j
	woD6lgigoh4j3ZIAs1uWSAwwCm/HEPI=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-61cf429f4c2so8001925a12.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759845; x=1757364645; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3nlX/RfH4bxrhjLqRHCaPu5Q9689qctY9+oII9+YwlY=;
        b=ZQSjrEvEkXB+kNy/hP1BeSqwvVkThUuzR6A39EETTBjVWlfvqovrXTZ0u3hjSpil6H
         1pGeYrsAnB1W6E9zSdi3P9aTFtohL/89z477b1yaPPRJDK1nqKdU/nUa5A09Z/uh8CbW
         IXZ+3L583qACYue+vp/ADuRVmRr++0C2K8lyx5tk2SMc7YL4kqoLgMoSW5vXss6M0rWc
         XNdmMMFAyS7pgublGVoBKzni080S0c005iwYq9gm3nZD/evnp/BJ1+DUPjhrdPOevKPX
         8AEUiflCc7nYJEAx+zPZRMCdDtw1qOulWmLaVelprM0+u0cUPM+s6R28f/5+KaDwzMcP
         sLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759845; x=1757364645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3nlX/RfH4bxrhjLqRHCaPu5Q9689qctY9+oII9+YwlY=;
        b=C7CVbZnReSnhNmJlwmv7cvvcYci5eef4gYH8XLEqd+iUtstGAKGXMDT51sIM0VqJ3k
         l5zLANUFH72kildero9kfxPsr9QG3FWTt67oPRtTcSgHovx7yWA9GsIOBQrE0GdVVewS
         nDRzeN5DOraXqZ2WMVvOkTf5FpZrIh4FzR2SiCGg+VKP33Nvn3OBPaVvFAEmZt9GY6nw
         Bj1jwkmXMUVewp5l55EB15kMukECbeZEaN/C2dvqfaLxv6llspH9Q6q/hJGKymhY794e
         H9kxRp2A7ZesRIiflblj77XNX3/rylwLEng/Tmkv8uULooH8NFvquUQ2x5zC0bugWYp/
         zUQQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9CdprZJJc/kQ/gINETG5zOSikPFVuMJqRcRKwjd0aWThlQG8D9/4v8LLikREqJ2WH3xd6MVW91w==@kvack.org
X-Gm-Message-State: AOJu0YzvwSzHKIUbk6+UWyS6fAsRy0LRIwgZVJCU6Y3y5ZxxpnCx/Dd5
	CE4/tzC/1qKO43lIalJNDdMbTVPhgP3ef95aRiqlO65OsSAFyF7zZGDRkf47SLFVwA0=
X-Gm-Gg: ASbGncv5JJBT+OmyEj5bdA9/HTOnFGqwMfhHlA/OE8qeWHT9IMAgC9pVYislFs6CAkB
	SWH8zeAgrguq2/QpCkU4Yp7wGrrrN+G/vW9xzpiSfmykyp8TUbHqDCyS6prLnihvmYoJlhcP6aP
	Uv5WcCQQDbDHNXW5PiiOmixaIJgOXAzIDE1MN9kUkp8mbbTgC8rU/hGA51FOZR1sMVuU23TG4jr
	X1WUVHBeuQh9SYTx4VMWxoaqk7z6u4qIPpgvGONIqE100M382KbuugW1APRkZp22QCCEtDAPIn5
	f+8UWuLDR+06dE/r0aDwLTD6u64EgO8gr6SekGEzUzeUXM6SiZTosdTjTsrxl6Knbr202eXk44p
	3a9DLQZByG0vtZ4CTgiYCNZLIRwVHst39bEnfBmx0MshpBpq3aWTGthINjJ3ro/aYBYEN1Q9hGy
	GJGGUKLOpiyZ4uN1PE+7pcGg==
X-Google-Smtp-Source: AGHT+IFcANB8/RcKkowYdOQH/ARcgHa8um9z86mmrwre3BImDNI7cpbMntnFRJto6276WFxuuld4Aw==
X-Received: by 2002:a17:906:6a27:b0:b04:302c:fe14 with SMTP id a640c23a62f3a-b04302d0545mr375148766b.21.1756759845048;
        Mon, 01 Sep 2025 13:50:45 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:44 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 09/12] mm: constify ptdesc_pmd_pts_count() and folio_get_private()
Date: Mon,  1 Sep 2025 22:50:18 +0200
Message-ID: <20250901205021.3573313-10-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pit1s71y1x1r5rsowkq4w4xe7whzihrj
X-Rspam-User: 
X-Rspamd-Queue-Id: A6CF6100006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756759846-23346
X-HE-Meta: U2FsdGVkX18kzjc3rnQSTbSscI6Ax2penE+NSUGOBycr6JivKsDCDTqc0TBAKrrbmDo42fxeBtEmxpi+GL7E5ZPl90m909iQOzpYfXCT8at1EmzaOpxhBqJniz4320sCH/zt1V2FP6rExv/i0y2GEqsTGPDeysLsODcD8ESx6ZLhHvD9VZ0N8Ct/94qaPgF779hfx+d2WEIv1Yoyv8UVleywluQ+oDA0/lspX3MnLY9pHdH7Zm9ic0CYXVh/a7MikuaITxKtkJVYPakvPd196WsBEqODFXw/+xiC1Kyb4t3relbNI1mledsmRxV9N2fKCJ+ftZvOdBQ3P5+gMFtSS1bBPOgm4pkUTvzmjQZL5Bwh1U/kLgokyhGOPhpq2xaGL+eoEsluXpiRcrVlc4choBDdTeblwvErT2YtjSzLxikZliFyJIgoahh15fFCxzZpACAfhWqdw4wAKOHh7DGH9Nts+rfpYYsjTTcEJy5U6pPs3jryeJ+MlFvU2JaU1Pko5rfeJldi77W57Sxpg22XeFT8a+PhPjktAMPxi2HCGkbyDbXyp4ZfRR48W0QfqIRmJe1lhJ3EkfEzDJn0ZKp7K19Faj57bf5gcnXW9gbWLyidvf1bLshc342tjZ8D/m5ZV7aJrIQ+HV7mTW2xN+BRy8nHY/0I6nX/KB59EY4D+WD1EeYIAVhzbpRZGF8J9Uq44F6MWJgxmreSaLrr61Wltzac5ocCOSh5mcYGI7DmV0QtKwKGNxbpvCtSTlZ+U4jovnis96g6biiKPcxX7YRAiNfdBw0Kra9tiYaff7LRdzPp5yrZRYCAchV8Xu/D2G16TWANtQGS9pIU3n5a7c4mK5+uHbhN+XNDZBsv2PRjJB9WMYQV6nwQYkLBPSHLlUl9P76guhtP2+4MF7D2rY2Jzr3XJcgUDEb1rx0DpsYMee+SxtaTMRIqXOF8p4KQXunh0ZwMUg+nL3f139uOjwK
 nl8XPcR2
 cdr3fzw1trOg0KC0M5DrE8c14FD/nhDJy4Cy80esCAr+Sr93d6eLWxQt0QWCc0/zQ1ljLqQbhH1/D6A7PqS/tllIINMXOCBpNZ2Z3lsTnEsZL18vUggnFZQAqE6kMPB5RQodf8jbPcxz/PDCu/f7gw8ccgIx3wyvMBiJk9TSN6+MWIGspztQWKlLt/smE29CYTOScXQ8fFksgJAqqHLkMTLEgz99AsmfJci11xcVMJnH3wlt7E8Zt25z3y63REcuSy7EacaY0lMJuEBETekJvfYyejunyeYfhGsSrRt3Q7j3Ve7nIVDXyRxFjM6ud+QhIOBXBj26OBRYVfwdj9RgPHEXHc9NlSvNRmdKYbLQWWwEyV9AX0FhLhowICpEd3rY390wAtoxEMpBauNGJ68gS68edssAbVySCVYeD0NEdG/yl55rOaEzqDw9qqCA0oCR252tQEXq++/YPWuH7NQ5VTo5qDc3oc4Tg0T5dHbzrfjbstU3/t8Y2MINP6ZDUVrSKOJFhYXgMy6g2n3edlg1advONp21IgF2JGV9wtn9f3buP5eg4HNAJklyjjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These functions from mm_types.h are trivial getters that should never
write to the given pointers.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d934a3a5b443..275e8060d918 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -632,7 +632,7 @@ static inline void ptdesc_pmd_pts_dec(struct ptdesc *ptdesc)
 	atomic_dec(&ptdesc->pt_share_count);
 }
 
-static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
+static inline int ptdesc_pmd_pts_count(const struct ptdesc *ptdesc)
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
@@ -660,7 +660,7 @@ static inline void set_page_private(struct page *page, unsigned long private)
 	page->private = private;
 }
 
-static inline void *folio_get_private(struct folio *folio)
+static inline void *folio_get_private(const struct folio *folio)
 {
 	return folio->private;
 }
-- 
2.47.2


