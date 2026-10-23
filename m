Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C582606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Oh8RRaS4
Received: by kanga.kvack.org (Postfix)
	id 52C816B0AF2; Fri, 23 Oct 2026 02:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504586B0AF4; Fri, 23 Oct 2026 02:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441076B0AF5; Fri, 23 Oct 2026 02:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15B3F6B0AF2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:34:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93839140218
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:34:58 +0000 (UTC)
X-FDA: 85352928276.14.939B9FE
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93009140005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:34:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Oh8RRaS4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6F9SSG+/FeDA6bw52vBp7L6cM7wcJHblW41owDWPkN0=;
	b=SvTbOeA9b8KmDyX2L1NBJf4GaBnl+4CWstenPmsaraCjVb8kaDSh3nI3bxh3gndbYYo1dt
	mIqPZJA9nfiCdzOmUnn49QWPF13gHNwK26jLTj/Ukn4pSmAIpzzf81MHtYEQqi7VhVKwqc
	7IKZTYnjiNuUm19JkGX2i4RI96hqpDw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Oh8RRaS4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737296;
	b=CnIpGhXjSIC+oIzlzslPsmki1KKCg3AxOqtCy1iuV3wwUeRRzAglHnXYbo/027zZ+J1wnm
	aYSqx70hY8Vn2kekxPMT1qCWsPrtv00pCV3SjZihrvysLb50iwhXBhL8WuvmIXwJzJMtSP
	rVtaWRvfEMbY6JHD3o3GqEdh3F9+GnM=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so448164a91.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792737295; x=1793342095; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6F9SSG+/FeDA6bw52vBp7L6cM7wcJHblW41owDWPkN0=;
        b=Oh8RRaS4uZ2NTj/erS0NjH69hguioVDAFzP34EzMNP6avBh6oeTmrUBIDeYhZNd0Kh
         LQy0yX9aurIojrCGm/SSSgkeYzhRgU9QCuhCb+RKvmlslpG5xn/b2+m3EVLjxakET7Mi
         k9oNOIn8nhmR0tIhP1yAbQIT8BnCxx81WzJ67wao1wh4G65OD36AUtFeAYmjlmrYGUjQ
         jX9DoFlkpYVoVTTHUAV+IlwCJARr6SXFF2xzRR/G81QecyJtKXv+o8zmP24iRKLx/NLD
         qCwzbsd80mj/O5JmK1eTwZ9AWms6A17DMW+E9WitxJRcfuc6lfEIVDaVzH78OSquAlHz
         TEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792737295; x=1793342095;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6F9SSG+/FeDA6bw52vBp7L6cM7wcJHblW41owDWPkN0=;
        b=HpW/I8+eGHcJzLsQm83DFXy6twgYx0ejrbvXKtdXRcVPu/sAnrICpDmkdNpH1W7FWd
         bC772/zdNGsg3EzT5kZtKHVHnHo9XoRQye2MwY4MndrqyA4CTStE+xuFgplgNrdz1ApL
         UIpjHQs+phFNgCN4VuUfU/PiPv4BlNxKzfbyUID+EC7nxDtCemMoTTCnUz8Hf5KVWWfP
         /50MWOoVTxssXHODfrB+5k+pwXs8OtIowOXjh9tZRGroNjd7wPjpfQ8ruwT0iqBSjVc1
         c7Eb37gQZnSTwflbnBHK0LRMGhhlJLxoXTSRfLClyZbv2Q8NqdZOcHeJVQTB42Kme14I
         QVNg==
X-Forwarded-Encrypted: i=1; AKwUvBz53jRQfUM99N/adZuAuSlVt0sBNIYLLVveHkxn/H0wR2nxENog9qYuYacpI4NiYuoVrWA4IcpxXg==@kvack.org
X-Gm-Message-State: AFq9FYIOdeh4fxkpaBuQg+1LD09q0w8QBHJHFKtGpu4eu5PNj/ohFBYn
	KBEhK6XEdvCDEsB7m1alEZGVE3y3gKHtY5nXhg44ipsY7IP6msONLaAs968A5D1NWkY=
X-Gm-Gg: AYBFou2WCtYXW9pw3TAkinkExGypfXrl4Fuw+O1TfjU4fCE/2pKoRWttYue4bpKYTGt
	St8csLvWIrSCyqPNQ3xN9Y+1V36zp+j6ME5DUPtmB89w+A1wP0X0a7kFE6yXECeq2t1T+z9JTLL
	rJuvusOmWj7XPZBtLFFaNr4vbrTD9Qj8kqB9xb+7sjdQ3Q+GLtlJcgO4SmpxsDGhnTZ6gPAr+uh
	7Vrv5SkmV0mERyhRfldFwMLgTBON+63T/JBZws+tdt5Yoy30WBDocj3hWe7uBz6/xIc/pWrCcof
	V18xnDO8FmyQftuzZjyP/7u8oKO85BfCcIAw6fEFIsP9Zbas5uSo+ZcwSyMu89LBdp8UMvZBmFt
	g6C5iXGZ04Mxpfb2k8i0WAu9JNUi2mYAeeG032cOW3yv+DYtwPJgUikGQhUEvqNvK+/3Ttd9IvK
	Y7v4n8mMy/5y8kNJWffWEgUE/WUAGwol+71SEyosqhur9yozhhuIA7vE33uBUxGkvrVMlXyH87U
	l6BL5XSB4IQNp1cozllhU1jEJXPw1FvdHSUk5dwqxlmKcm60DwtJD6nz0YyRPZIWxPRdTjZHsDL
	UA==
X-Received: by 2002:a17:90b:5487:b0:3ac:d79f:8229 with SMTP id 98e67ed59e1d1-3adce1737eamr1157717a91.61.1792737295119;
        Thu, 22 Oct 2026 23:34:55 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3add246f308sm575202a91.0.2026.10.22.23.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:34:54 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 3/4] riscv/mm: fix missing destructor for hotplug PUD tables
Date: Fri, 23 Oct 2026 14:34:27 +0800
Message-ID: <20261023063428.3658761-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261023063428.3658761-1-songmuchun@bytedance.com>
References: <20261023063428.3658761-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 93009140005
X-Stat-Signature: dbmwueuqfpfr38qfy8qdjsutg6qiouyu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792737296-430871
X-HE-Meta: U2FsdGVkX19yTVasR+JvefMPnJHWmVCGRPKUiWcjnSn8Lnotac5YUjVOka2FUOR4bowlDX/HN8w5tKlmOYme65kKFAhCKyJMxidYnM6SX6BwG4WEnIPtgvMm/UhJCer6rx38ZgKhsAjdG/kOyAv7mpZ9IuF/l/eeDZB5JI/Emsx32uYxN5sNNVG5kzvH65IjzJ6XSGFhn/sJM9XCPQyihJdOwWtaLSBcOHa78yNb7rLpqhR2BfhllQrbd/fDdkgfv+a+25Yg8S277f5yNIi1H3AcIogyMAlcJwgjfhasBAr49dOAxhjLChpTcYaTQDLJekYc79+V7wSuXfsug6VfqTifGTU2VW0ixbp+LZ1dpFXB7d7uAGsdnithsO/J+F0Qatl8pRSgjvmr+knU6RIO+mKJsH5tnfz1iKkKj3g3JjMJ7X9BTf1bTjKboVRwyITcWeU4AbCIugKKc/eEDulCoRhYjvrSPaIv+uPxyOXSKqQ8szEHdcTxN9BE1ziWJbUNQpD489oQ182aTk0Svh+FIDeIjArFsTa3dNDOheCf3M8EFUP11iL7ZAckLPUzTbX9fBDYFVBDbscckvYIEZSTgE4BuhHgg85ZlUtHTpheocwkUsLM2ffObET+S6n8hOv/jEudL2ll/Pmpf9VYYEiYEwF+seiT+7QZbe/u6K0/Sdek1SQuhAZCDEMrsKNoGzSeTwfx1HWJDb5L/eTKyRPPJPbgzEJFJrZU9uwTOvgzE6IRYX949LAc1lxpw6snl+haFl0ldW6YBipO/CtN+l8MEHZYVfH/+8A2AtfysgRIuULOFNfV0lKZCyZqwbo2JkSo0vx2TavfTpymVj1jccDNecPmyPTozPfM/JlJP3Xk0Q7k1OQrknDM75Ie3CSSEVkMNgDO4QGF+XSz3Uohrh3+YKMngMg/q13Wj9gLLY8Sb+O7PiOyzrkhLGZT4+gex7I4nVUlRKveYRRFR2u0FOg
 Q5yv/RC0
 ZvliF+OODRs7POO2keyI13VHEnJ33Oz3V9F2rHYjurQFcZXQ0At17/KcyUzNAJO2571VtIlbiIoVXpL+6g6+rwROovAtjuqEvM3TDciScifhBeSARne4wyWL+df2be5z008v/5KcxC9JoarOsx+0lnmYyf/nX5+YCfvDpLTRBTCoAjxmPXzxWIYvjcuL2UWU6O12ev/pLLAwZhPfhT8O9RK9YksmOqA0HMeXarMqHwNALfRHSskzQIPG3yX1x3AmFyLZsNpu6WPTpwqwMiHL59HMh1mbh4blKfINCpnWFnfJCD7Cq59TgZ5oW5Xx9aB/d3T/eWdS3zHbBOw3uvuVk0BLNcG1NtY7zxdtsh/Y86hLpzhcWEHp8LK9rpcFihn1TrVWhr0E2kK0UkkjOUa9FqtcOK4+6fyIB4d8MTPIhn8RcLGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel
pgtable alloc") made alloc_pud_late() run the PUD page-table constructor.
However, free_pud_table() still frees non-reserved PUD tables directly
without decrementing NR_PAGETABLE.

Free PUD tables through the common free_pgtable_page() helper so that
constructor-backed tables run the matching destructor before being
freed.

Fixes: 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v3:
- Collect Reviewed-by from Björn Töpel and Kevin Brodsky

v2:
- Collect Acked-by from David Hildenbrand
---
 arch/riscv/mm/init.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index e111d25e18e1..f35fe4cda89c 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1537,10 +1537,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 			return;
 	}
 
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		__free_pages(page, 0);
+	free_pgtable_page(page);
 	p4d_clear(p4d);
 }
 
-- 
2.54.0


