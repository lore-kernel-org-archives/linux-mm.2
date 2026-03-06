Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F269DFCC06B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB86B6B0005; Fri,  6 Mar 2026 15:03:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FFD6B0088; Fri,  6 Mar 2026 15:03:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99156B0089; Fri,  6 Mar 2026 15:03:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B743F6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:03:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63AFE1A0717
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:03:23 +0000 (UTC)
X-FDA: 84516712686.05.3B1EE6E
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8C831140018
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:03:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N84WBoCs;
	spf=pass (imf09.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772827401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HPRNLOamDcFlQvC9N/qMCQZ3FcaEUEmoKUrW4q9GB28=;
	b=4+m9xThV2kcVTUrJB4xpwzNZveVZGWcrFz3/ydG2zJR009HqkG3jJ5I7vqzdeo3P7sx59h
	HeAkpLPzWX5WQQ+Jj6j7/tKmEY5rcfzP3A4lQzbbHi8r7KJOLFhojSXAL2Jf3DUrEwOAul
	O+HlVZpkA+6c3q28lCYvsnMxQoSLVPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772827401; a=rsa-sha256;
	cv=none;
	b=jlQQxHGAb02h3TevTAXIVqUmFW1FzOjc4KkzmKPGK7eHCrvQTAt5wFe0OQzM2NnHdr+yMK
	BLTkjwI+kWLD6kUrfzlGehscYehRNtSDrZ2YcqCXxQrAXJfeqJ9dKaiQIxD9BOMPjVFEaA
	JAjIfyhXfldYBtz49eRHuhxYc3g+GnI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N84WBoCs;
	spf=pass (imf09.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899fc9853b7so81341176d6.2
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 12:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772827400; x=1773432200; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HPRNLOamDcFlQvC9N/qMCQZ3FcaEUEmoKUrW4q9GB28=;
        b=N84WBoCsVpCndNJ4/yL42WTmCQ1dKJWWrEYVjXRCLldY56snVNSjRULJ3PUczRYBAl
         ScoGVi2TZKUFDwvwllH+g3ugc6u+xTEXpPxa9KNgym0D3i8cCuSMZ8hKJS09DZNJ4fbZ
         FALNErreHetL3wBalnSQagXBlP0fQl1Aj1RCpQpORlsEzdo4s760tBd858XfphV6n7E9
         w2wV8r1SEJ6DDKGorVjhjWtm8JVXZeGOtkZqljcRXkEC0dQXLrVz9lRK2lv3pUIoQ0Cq
         xtljs9ex/hvBmSdXrbWGYURdxJKiYA2ltTuA3eVY42a1qIp5kPFqL1Zv9htEfL9dsABD
         Q4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772827400; x=1773432200;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPRNLOamDcFlQvC9N/qMCQZ3FcaEUEmoKUrW4q9GB28=;
        b=XqYmt+wRG3mr5ui8Ryg+91NlClTvbCEMH5P0KJ0CtafXaWDrxZKBlSrazb0xrbOTOS
         m8MR1e1DLhV68kp+0PTVYf5evVZw0fkpZTWbwTaIu05fRk6/K/5ruJ+hjfdq2bktBYxt
         H5o+0xEgupg6v87kKaHnRdA9Y8f3bqkmsm0tsMnM7f7r+W2fGeo/tfZDLG9a0hs95+Oa
         SCb97tbYr44Eg3CRtaxN104i41DTkr7tbwKzzBA+Jr6Frk0hl/ZhAbSlbFuJG6MS8ks0
         x5UP8W8bVkZugjfmjOClskRyiKQq4Dw/i1Of0pFHxHbJ4VIXbjebTOule1p8iM9Lj9Kj
         d39Q==
X-Forwarded-Encrypted: i=1; AJvYcCXJLvTqwVoNNkZRgw6X91gErl7XH9yjlQhImHq0nTVR1PJ8xw4s6lzL0O+7Hx6xZnucaR4Yrucg5A==@kvack.org
X-Gm-Message-State: AOJu0Yz2vMMlQWPgmVbLtNxO37NYaGgRUeQloFjBjOnGVgq9D7KVMsxg
	ZwrmoxsxeBduM2QUDXfCAK4lHyRpH9/YfB9NxFCH362MyOmx2GpNEBR8dGg13cfX
X-Gm-Gg: ATEYQzxkcLda28+G00jkiUn0SSmADVGtwEyAXj+qN8m9wkenU671RO77b90DOZcIkhn
	q69502sBTN9wb0tT/p4A9JjSTSNgVCjwgi01lU6DOntRw3WckxS6wjVuwH5MqpCUx+qVhBQiQ2g
	y7qknNRqU4UBtBEQoVDNdlflWaaPsXlZwtxOSulSYlUQiSoT/7nOb0NCtLvARDldNaCek8sM5KT
	w9P7n1EJbIHlXTyO7Pzh9qCKAC5DT9LoWUuRnCREtjvRNMjn4Y0BB0nRua1qCt2hRinQvsyYwyD
	sWTIJ7XbaPZzY+pa5LQV6o2Lphj5JVeMIIzUco2a1RXeatiEX39ZhvnyACV1UBM0i2EU9hi1vly
	tkmz2ezFjOz7cmUEinWBRq9Hzes7qpCOqSyyHY05jMWgAwQwP01rJSaS10W6eLu5v2LY1VNB/8K
	FCAmsWaayy7NwyoC6RrU1GfrsldolP61gNgUhJmhtkDBHNXKMRf2e8z80HUzQN+Xebh9b+7RqUo
	MwD
X-Received: by 2002:a05:6214:e42:b0:899:f820:6414 with SMTP id 6a1803df08f44-89a30af509fmr43309316d6.48.1772827400370;
        Fri, 06 Mar 2026 12:03:20 -0800 (PST)
Received: from instance-20260207-1316.vcn12250046.oraclevcn.com ([150.136.248.187])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a3140da14sm23301266d6.9.2026.03.06.12.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 12:03:19 -0800 (PST)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: willy@infradead.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] lib/idr: fix ida_find_first_range() missing IDs across chunk boundaries
Date: Fri,  6 Mar 2026 20:03:19 +0000
Message-ID: <20260306200319.2819286-1-objecting@objecting.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6ghi9mzqjqy9ygq3u57d7dz6t413quma
X-Rspamd-Queue-Id: 8C831140018
X-Rspamd-Server: rspam03
X-HE-Tag: 1772827401-166988
X-HE-Meta: U2FsdGVkX1/qwW+VrPeRVZZmI/RB9WS4Zc/6Xm6i07SVjzOBLjoPiawBdgOZOVWZrnZKajEhR3nmnn0gJszJEsvjA75Ot4zgFmyRaDxYfYuiba6EZGMJVloh+zPNIc1SVUXIw9/aRk5lqHbpo2B+9Y9g2Y8F/EH4Ycl7MP/y1cmmq4/dyuviWaojr1T8Vc1TCdAP4YL0oixqZUX1BqzOMoYEembD6oBUAa5x8+3QXCnrfDCpTpXp3rR9ypGkhlfLVenHXi8DNOR3HHbRQPQODj2wfPNo85L4uoD4xf4gg2AUX2UHwpxVccVFZ8jaUVAlqmcma5vrHaaTX3GMZddeXZUL7/bjopdzSXePmjKrg1K4WBwdD3XUcqBmGNkvBgReGZ8KdXhtpwQN9jDqK7F3xw/WFLxZVstzzdegt7uRcveyCHAySVhRmtlOpNJT+3NRi8NovdvVBElU1clB9PxexZu5GWYQ1AreLEmCAFhaJHayF9LjQAcp69zJXPjmSU/YjAV9ZuhRaECe4DcosLhC87ns0N9/g1RDa+6iUEUFXQfKCYfN9EOr30kuTysBDCXgiAIRRX9JtjluH3DpemQ3xsM/+TOp7f0SWXS9x3ufy8AJ6DgPTlWOZ28wB3NYUcqob5/5hswXT7fWBYJ81Dt+h4Mu/L2TuBmK8KWEP4S+Nt43uH04a04dPnU2nC7hsjYlLzJqtZjSKgfOH/tQXYhRre0LfS80ku3HM7GlwiVCxgnqHwLts60of/Zn2LrGTU8dhruvKe2qg5EEZrvL+0JFKGC9jTOi5edZpZjfc8/RKJJOYGmhCwEVUS5InzbuynLF8c7B8vJTyQyPSgkraYDxUPXtRe930FHqCmTmo0eFdAmovSifZOS2PEaDjoz8cg47HyD4is1IwhxuXI3hU2RweRLMEtpCE9bzHTPVqUdmeO177buxw/vpye5ynrAKgQwWfd1xHmwdyZlD6X9iquw
 CLqgKUEU
 +4e58lOOaNjZX9Ih0GunrXPksKSnTPccUrZQ4QmHz6l8z4Cq93E7PB9A7blVgNLaqnvVtc3C/WBeFYfKJXjFFvwSAA4MSkCt3Z5SvrqgEXyaWR1QXmUa8amHyEiLHinzmD92ZrTIZM+7+k1+CVKvQ+elRGrX93e3boWJf8zeDx7eQV91tjA+Oi0cmsi7N91fJxKPzPvvIOVY/QGDSbaNAp2nL4h80GgD0eKubSDaznzheurXf1wnZ7ChFccL3Y+iFdOJs6F2rWNDzttswhkClf3sa3DD8m44lxzHnudi1fqI3XHUn5YBwRhoK6CCUOyvmcXqFfnshcVbLqRUQPTmRTVPfxZvhlr9ExOIuVyEtbhsg1dCtHfaXVRFGj7YOTRB97CFeuqhLfE235Pp7/ZAhqNnHz18BOYm2i9Dd/J3B1tGp2sNGt2cCksdjVbqPngy+l0SwAdlRhUtxQ64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Law <objecting@objecting.org>

ida_find_first_range() only examines the first XArray entry returned by
xa_find(). If that entry does not contain a set bit at or above the
requested offset, the function returns -ENOENT without searching
subsequent entries, even though later chunks may contain allocated IDs
within the requested range.

For example, a DRM driver using IDA to manage connector IDs may allocate
IDs across multiple 1024-bit IDA chunks. If early IDs are freed and the
driver calls ida_find_first_range() with a min that falls into a
sparsely populated first chunk, valid IDs in higher chunks are silently
missed. This can cause the driver to incorrectly conclude no connectors
exist in the queried range, leading to stale connector state or failed
hotplug detection.

Fix this by looping over xa_find()/xa_find_after() to continue searching
subsequent entries when the current one has no matching bit.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/idr.c | 55 ++++++++++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 69bee5369670..1649f41016e7 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -495,10 +495,9 @@ int ida_find_first_range(struct ida *ida, unsigned int min, unsigned int max)
 	unsigned long index = min / IDA_BITMAP_BITS;
 	unsigned int offset = min % IDA_BITMAP_BITS;
 	unsigned long *addr, size, bit;
-	unsigned long tmp = 0;
+	unsigned long tmp;
 	unsigned long flags;
 	void *entry;
-	int ret;
 
 	if ((int)min < 0)
 		return -EINVAL;
@@ -508,40 +507,34 @@ int ida_find_first_range(struct ida *ida, unsigned int min, unsigned int max)
 	xa_lock_irqsave(&ida->xa, flags);
 
 	entry = xa_find(&ida->xa, &index, max / IDA_BITMAP_BITS, XA_PRESENT);
-	if (!entry) {
-		ret = -ENOENT;
-		goto err_unlock;
-	}
-
-	if (index > min / IDA_BITMAP_BITS)
-		offset = 0;
-	if (index * IDA_BITMAP_BITS + offset > max) {
-		ret = -ENOENT;
-		goto err_unlock;
-	}
-
-	if (xa_is_value(entry)) {
-		tmp = xa_to_value(entry);
-		addr = &tmp;
-		size = BITS_PER_XA_VALUE;
-	} else {
-		addr = ((struct ida_bitmap *)entry)->bitmap;
-		size = IDA_BITMAP_BITS;
-	}
-
-	bit = find_next_bit(addr, size, offset);
+	while (entry) {
+		if (index > min / IDA_BITMAP_BITS)
+			offset = 0;
+		if (index * IDA_BITMAP_BITS + offset > max)
+			break;
 
-	xa_unlock_irqrestore(&ida->xa, flags);
+		if (xa_is_value(entry)) {
+			tmp = xa_to_value(entry);
+			addr = &tmp;
+			size = BITS_PER_XA_VALUE;
+		} else {
+			addr = ((struct ida_bitmap *)entry)->bitmap;
+			size = IDA_BITMAP_BITS;
+		}
 
-	if (bit == size ||
-	    index * IDA_BITMAP_BITS + bit > max)
-		return -ENOENT;
+		bit = find_next_bit(addr, size, offset);
+		if (bit < size &&
+		    index * IDA_BITMAP_BITS + bit <= max) {
+			xa_unlock_irqrestore(&ida->xa, flags);
+			return index * IDA_BITMAP_BITS + bit;
+		}
 
-	return index * IDA_BITMAP_BITS + bit;
+		entry = xa_find_after(&ida->xa, &index,
+				      max / IDA_BITMAP_BITS, XA_PRESENT);
+	}
 
-err_unlock:
 	xa_unlock_irqrestore(&ida->xa, flags);
-	return ret;
+	return -ENOENT;
 }
 EXPORT_SYMBOL(ida_find_first_range);
 
-- 
2.43.0


