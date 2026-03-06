Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6854DFCC06C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAAB76B0005; Fri,  6 Mar 2026 15:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E276B0088; Fri,  6 Mar 2026 15:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02FC6B0089; Fri,  6 Mar 2026 15:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9DF6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:08:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3656ABA7F5
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:08:25 +0000 (UTC)
X-FDA: 84516725370.29.72180CA
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67BCAA000C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:08:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kZVu5YlJ;
	spf=pass (imf25.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772827703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LWkvdurancvUwExlX3UI7CQYr2n3SptyMlvPTt9mkS4=;
	b=LZ1Xx09qJepKJK1yDVsITRvgu3GQr2BxxhDITaDJokShGJFFxR9qyrKxt5wKXyQTMN422N
	NpG8pr517ov/Dpl8UNEQR5bTmaZua5J/mpEcYwrrOq0yvc050e/JUPEZcIrrwkkTdnYZg/
	+CRnix+SXLNbpbp1xFdUoLtSGBnt+JU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kZVu5YlJ;
	spf=pass (imf25.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772827703; a=rsa-sha256;
	cv=none;
	b=AA69FU3Y83cc8/PcCEUr5A+n87gx6aJhyQOlHPxQcczeboxNtcAKGpbT+//GUEwEMdd7tL
	qLToDB1tGqUGrBa56LSrjy3dzoBGOA2g+9ktQFxN3prpIQva620g2i/KvHS+EHO4gueABN
	AqiGlXLNgUh2eQ9h2MpPXnpyXcGn2ps=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-506a6cf8242so69042321cf.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 12:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772827702; x=1773432502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LWkvdurancvUwExlX3UI7CQYr2n3SptyMlvPTt9mkS4=;
        b=kZVu5YlJ0XfovnkSGe0h1JzjLSTgzAOSTisiB8cB509sKURGzcb+0L7RBa2A85quVy
         XUfAQexo7LtfJvuvxo9jsAAAL/kOSN8FaJ3c2mJ0BnZQhx+SLT13RtAgnPMZA/NgEMDA
         LCRFTbDtBrMJkh6/GCnZ0eZVWm5ePGeXR6GrZtU3TCoDU2cXgeBEwuBg5xImH3b+tcL6
         GbXYWxm6RgTpoWnoFYMehcAaMPsNvKS4f/TAaf+3Oi+YNDteabS4IDI+/53g1w9LirfQ
         tJRyFj7G6129I7OOuS+eteN4L6BQnmHG52CNS3fC7JD1as6KniKdE/FcNXJ2TpIqjWpD
         JhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772827702; x=1773432502;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWkvdurancvUwExlX3UI7CQYr2n3SptyMlvPTt9mkS4=;
        b=pfbwVL5VV3/8O0GequsoiOhZXyqmjPMCTHIs+5yIOzZD1635vN3M84hMD0JmoXU85P
         gzHL+ldjC3woQLo3PApE894FW7fhNli62l0dxFwkOLL8lj3KoE2L7rfRiYxyw8Pqe35Y
         yiEz/Yx1RSUo8RB8fPa4koXpx0+PRFT9HyZsKGAdQMvpBwBPOsgqR5uWKXtlE4zA5BIo
         l0zgjhqJ6M/ktm7VEArL/nlgockCl+7ePVkRsw1iGZmgCfSJ7EBb2hE7tIjhz21OBoA1
         iYlV8/2T0RFjF6a71ukfkN6kHCNIfhF7S+C90hadPACx04fksAWfoCIHh+qDfsa0+AMa
         6rYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCkDyZmEaJWqcb1e3LSoTkEdy+9q4HxwT7LO/ms2puwakPYAKV48abW+KSK8F4O2GxT+Ij9wwcdw==@kvack.org
X-Gm-Message-State: AOJu0YyFOqQd8HmnJqooaXMVuAMjqBYjLIO5lL2uOqROx1IGMK42oO/I
	QjvuH17BAaDb3fFWPv6e9u2k3oZYmlRBCWNt65KlbU7JvTU4XI/Fxknu
X-Gm-Gg: ATEYQzzUXa1ySKL5ESOhi+a6Ma7ffA21g3Imn5BOuLS/lYtvU8SLsnFJLvoAT0x+QPH
	r4KeeqbMWnYPWDWhMc7WQu0qlu6qjbFQ292I44dEaCpQYbsK4Z/5ffJEGyRTpTHjfYn8wrsKlAF
	oKGhSrbDLIFhzuiIO6XJT0jRW+kVcRktlZLTsjDILs6T3QcQCL1AaffSKpdhWrXWOKOWc8QWqcR
	waLW1RGN1Wrk/IDZqO019htoy41XCSYt/KXwUaXpw6VDGB/eB+ldZCyo3PLHWDg8zUUiMI3ItDc
	f6BadqsbNB0w4wFGLGMRJMdvGAa3r3tZtO99AkdL03Hmt6iUZvD/eI45rIdEyMVjNaHTOTrzYA+
	jQtrwi4XJQ3ZK9F0X2vDxv6Hq8XzyXL/WJeAaEhRuXJVcT36jUJKDDrtzaa/IhL9PRJpnZitkSz
	gqwlEUOhgKF2/dN+8aInmpSe2sIcWbBWiZn+2dTMhXqpe9kRh5tYplsXJK84mZaygE8FEnGUy4g
	7Sz
X-Received: by 2002:a05:622a:1481:b0:506:bdd1:794 with SMTP id d75a77b69052e-508f496e7bcmr41506581cf.76.1772827702423;
        Fri, 06 Mar 2026 12:08:22 -0800 (PST)
Received: from instance-20260207-1316.vcn12250046.oraclevcn.com ([150.136.248.187])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-508fcd9e5c8sm9414961cf.26.2026.03.06.12.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 12:08:21 -0800 (PST)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org
Cc: aliceryhl@google.com,
	andrewjballance@gmail.com,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] lib/maple_tree: fix swapped arguments in mas_safe_pivot() call
Date: Fri,  6 Mar 2026 20:08:20 +0000
Message-ID: <20260306200820.2819999-1-objecting@objecting.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 67BCAA000C
X-Stat-Signature: y3q8xhx4knxgsczmyppb6mg83t8yebw9
X-Rspam-User: 
X-HE-Tag: 1772827703-701768
X-HE-Meta: U2FsdGVkX1+kwMgNavUC3ybHr3GL3pegHznO50uDaqJIlTpvcW0iMOCf4ZVYLyOWQLsrQmAM9MfQwGSOPLjyt7xjd+kRx9gcwT3C3Htd2deWyjvsGKS4yoh6uI0pkNhllfLf03bkZEfYcgH92VOjvSZQfNQp4V2IrhQ/g566govI35SH26esfTdk8z1KQEyIKUS9kdc7RA/ki+X3s93LQfI9SIIqg2Ov54xE3vLjGK4x55xPbCgJE2gLU2EusRpwXDwbK7xgmh3B+9jDmhwQ/bvJRPX8YxWUJh3Xng4l0U4wR26PolQwXgIx67FVEaCcMkMDZyD/7lUIveS6agLS3SKBmHbUipAFDZW+9tGn53jQcUvh29hNQcAvJWA6NFhA1OVSB2Lx2qp775T0aa5b75kxb2KNldJGxbWVe39g9Eh19XTMDnFO84914ettuKiNFayNLMbFiDHfLk0+JYjyeROam7axaXPu+/64MGGob/Q7V8TAL4BxixG44R5nF20W8COlzSes/P7qVqHTZednzN8h2m4j6hxFfCZUiWqRlJoPDqaX52TuALD2RadWr/M1Olm9RCni3af8U3JqNTfW3G3wcSYk28AQtfObLhbd3AI4lkJxiFH98mRWhAZFLlL2VBBq45inMBiDy2NbbajMkadl/uFcVMOTQCKRman0oMFIuGNBuYeVca+ZefGi9JZUebC9k0xj1GLVdKOhBSiBOSS7ei6n4ZaKtLYxnXf+sDYHiI9ROf7WX8sDtqohTm1Bnj/ej7ZemLvmNLIxjf2gXC/OV0RdbHWTSVys2fWO/zpf5vl05dXvQtgRGXkkAPRxfJRGeEkDyOJOnkiaN0cuD60XUEgyt3s5wbe1iqMmQ7TtiX7KMVuNoT3acgTq+8j9tbu465zPnnsmCkyNalPoYBV0y5u+K6saFq1/tMM4ZWVY67rSFVxqw+qnAto++MUY4vd41t5C97sVhnSgDMA
 rZDJ7Vk+
 3qTS/xhWb1BxYFqSXIwtSC7m/t7VisS5cGda0SfPwrX3nM+y608qwGZQmBm4MSdDiW2ju/yxwIGqJNcTtpUDIcXI32HmLsHHv9jqaE4AyrEKVYEMXIwU3cZJ7k7UbEWjXgNVahDor7re2hyn6dpYG3SAHAULehB6fx7ox2b6yJDsfuD7ykY1Y393R73eIe5EfKMzZ+DwQKDgjAPVIMkXb88PWTAZLJXjYHG4A5av2XKOauqAPsVXy2mvrJAuTgprRzLEG2MP2TvYMv4jjlS83tjxYU7v4W2tr2fCbGqRF8Slb4UmtClroWb0LxjqAgnElbtv6IZCsWueObPLQ8DKRqCEYT+ym+le7WlaG/GIxARuipgyI0XjXY91EDa50Z/bBI5e7QHFe9s2NOEh8y1pFiMm54uXenr3smhEZ8gUGW6o4L+VVsyA/lFHDBb/M8yL5Zw8TD+kNfjHI7/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Law <objecting@objecting.org>

The call to mas_safe_pivot() in mas_wr_extend_null() has the pivot index
and maple type arguments swapped. The function signature expects
(mas, pivots, piv, type) but the call passes (mas, pivots, type, piv).

This causes the pivot index to be interpreted as a maple node type and
vice versa, leading to incorrect pivot lookups. In practice, this means
a null-extending store into a maple tree node can read the wrong pivot
value, potentially corrupting the range tracked by the maple state. For
a VMA maple tree, this could cause an incorrect vm_area_struct range to
be returned during operations like mmap or munmap, leading to silent
memory mapping corruption.

Every other mas_safe_pivot() call site in the file passes the arguments
in the correct (piv, type) order; this is the only one with them
reversed.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5aa4c9500018..f82000821293 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3279,7 +3279,7 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 	    (r_mas->last < r_mas->max) &&
 	    !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->offset + 1)) {
 		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
-					     r_wr_mas->type, r_mas->offset + 1);
+					     r_mas->offset + 1, r_wr_mas->type);
 		r_mas->offset++;
 	}
 }
-- 
2.43.0


