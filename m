Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0143E6BF3C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 00:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C80976B008C; Fri, 30 Jan 2026 19:15:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82C56B0092; Fri, 30 Jan 2026 19:15:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910716B0093; Fri, 30 Jan 2026 19:15:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8032E6B008C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:15:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C28B13B9DE
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:15:52 +0000 (UTC)
X-FDA: 84390340944.14.4C99ABE
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2ED1540005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:15:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yyR2HrUc;
	spf=pass (imf07.hostedemail.com: domain of 3tEl9aQsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3tEl9aQsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769818550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0zRl8ckmsYXJA9hzzqbqYRhq63sxmBlwiujRl/vITs=;
	b=h0Pbx9dRQ5rWNh6ZlxSk9pJsdEdqEJimuK0OHqYfKYko7R18zqY6T+4CwcFBl5MUn/6l4d
	iWHYwtuf/Cq/pYo7An/lPz6+39FFCohxodpcpXr5Mf3VT1qK8igsFZhhpKC8+B/XwTYFPV
	Tke9VjgnDiIeucHNAfECxEp6XZc71eg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yyR2HrUc;
	spf=pass (imf07.hostedemail.com: domain of 3tEl9aQsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3tEl9aQsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769818550; a=rsa-sha256;
	cv=none;
	b=KzgipECYfIVYjgnqGrAf0hu2UUFKCCOh+yZPuTQpRl7sE1qhh9ySxD9rvAWRb6UNSLWsUn
	TJCu87xawKMmuhASdJ6vVA7vle76TStIWujpUgqFdoJJGepUwbhizqOThqNwOlQaHNEZjN
	P53qCECJg1miI28WbbqaVhckPOK/g4s=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a351686c17so22514755ad.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769818549; x=1770423349; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V0zRl8ckmsYXJA9hzzqbqYRhq63sxmBlwiujRl/vITs=;
        b=yyR2HrUcBOK2SahMRGYp1Ntnq2uuz5QOa/3J/inyr307xUsxYSGuRkFQL/eX6Ku8hd
         9RckHoxCG80KaS/YNprXWm/XJ9ZOcNqoSanQ0crtXLGN833t5QAb53+ZHMgzHUDIZGrU
         9vF/2XKMkwrGDhdX5g9ED1o9kRq2W8+woF8jptrNNm6XSP4UFzK8LU5symMh8FHuNPo5
         lM0ULH1YSxCwvf408XQGzzEXdCUK78XSip/mOe35kL09Twov5JTWgoRfdUkW4hJDD8n2
         2VfnUSNEvm4YkgpzYry+TwCEB3T0+8/tv57x/obQT+7+WCiH28G9yCluTYHKYKTwXi2R
         deXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769818549; x=1770423349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0zRl8ckmsYXJA9hzzqbqYRhq63sxmBlwiujRl/vITs=;
        b=Ny8nUtIbA5UtgskdoeEldyoXUCDHATQOq4qHEo8PQon1AX8UcCfn1etcBgoNBDKhDg
         REPnWiRj0RJIj30O2tzjA1SIVf0G2JUVMkXxDtHvr1XonBLn1ySvWDT6DvG27nFOWUt5
         AIzK2zYHhaTIXWHuOl0asZ3hXJIpPsjNO1C6LO39dNNMiNOHu2lFJ6clalSUAf2G+I64
         O8IiXWaTbGMOiSofKbDCQMzN1+k558cprrEtN6fVxLnpLI/CHbKxZ+aTVuS9Ha2iViWY
         SA5dk2ynub+pvStNufXIRtCRQKP625q9iNxkGjC1eWyq7Qm98R1wJ0JeXUkd3bQh563K
         0+Lg==
X-Forwarded-Encrypted: i=1; AJvYcCXOwihhH7ZpAiyG9/2sW3W48Ry8Es5sRmMUzB4GXHX3JL/R+icHOm/Ldt7vcP2NsYjoOqB1znY/yQ==@kvack.org
X-Gm-Message-State: AOJu0YxX8WQ09OSUZ61V7G9JMRFrT8owq+FXdSqdltFQ8lE58M5mh2VG
	3tHM/UKM42zdpXMI5lAglTO8ofFAq61ZxlSnZioAo6RHjei8JeV9E54cbtnpjzZO5JFB7rJz6Hk
	9kkyoTvVS0G1og0XF7XtiR46WEg==
X-Received: from plsm24.prod.google.com ([2002:a17:902:bb98:b0:2a0:974c:2e6e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2442:b0:267:a95d:7164 with SMTP id d9443c01a7336-2a8d9a7e152mr44013535ad.60.1769818548948;
 Fri, 30 Jan 2026 16:15:48 -0800 (PST)
Date: Fri, 30 Jan 2026 16:15:38 -0800
In-Reply-To: <cover.1769818406.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1769818406.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <bed4d2436a0660cc406ef7f331e7ed5b7cce9896.1769818406.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 2/2] XArray tests: Verify xa_erase behavior in check_split
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2ED1540005
X-Stat-Signature: ksyqfrwu4zbewzi1etxkwh9xcr4f415k
X-Rspam-User: 
X-HE-Tag: 1769818549-295353
X-HE-Meta: U2FsdGVkX19tc8ZQLr/GRsxWX8UZSffYRtTo38tauyrm0gxHmYWqkwC4X8RpClyYVak5LwYkT09vQtP6cSd0vP7DM6WNpfHd9UWFAwpnuioLjW3T74CbBiU571Szv9rwSKQRAwYSWDB/4izc3pOKjgG9z7QXt68jQqegRARU3RPNIv83Iau3SHkQGfbg+wfBDsMXxDL8fCbQSiKWzGGjVNchRfojqQeOXF84yeSGrJeG1tHta+kZprT3XEerkakMF8TlqdJqgzQPHHA3//CHnSV+4P5ltT08+7j4h0EIw3CK8KzAMsKuuRommmLrsYcmNtsI21YwYLPc1B95v9IT+V8LB55CCAy+Dx9g4QtbnHHu9JTMLd9j4xeAWj0GTNmFKVXKPRySMpwXLgBMd2blc7aSlbP3P4an7oQ3ppAP7v+wT78jTWXQ+qlPromIzcFQhfHvryWPOutb2Kpm7+uSDndmzBCUTSyZ/T2lgQ+VaTptrnE206Hn8fTuKnT7XgsoAu5Ubb2NiTyAbec8WD0SlDnLboLJdTlT978EmZFJmeCf9F49Ep0DgyORSfnw/h6V36JQUMhVmc5QKnw6HkGf2ut12N3jiSNH05lkW1iowogg1WIsKsNKRd5ZUU9tPue/UNSnGJsRbv7a/CP5FFondcw8N4D8eFH7vb9e5U4cKQC78X3wf7rJNi/iumPZvJaNO4rWRuGurQMX9voE2vUgDcwNpNdTdkb2lPfTWQkLvhbkhwliCcRnqcY9dagavE+dNI8od8DC6/P2y1q9TtTF0xmXd5PQV7gvzlViMjI7PgwDHqpV4a8pj0RzcfEShNf5QZyX6g+dJYFo3L9AAQ71p72IIFidOXT5U1HEL5aYFliFmhY3B8b1qoiIIkGWSamcox7KkLshJ924Y5CZm609KxAEmY+PLkwzM0hLgaR6CF27I21jwG9X38qFaQ0+sE248oklc1aU/qgScqiMlLi
 FZqcWIt2
 I2nUz8CXOuPtTVQHZC4zEIPnSDqluEGM6eTkIvyANk+tt/nz2qHqdZnDo/6apG6uhlx9W/+X/+gsr+7+HNbJkIXWAQ619qHTb4udSwQa2RvAwuDPfF63P0U+vM6MGYoR7CUyq/41o/39eZaT8Fc+8XADQ5Fc4nPoLcOiQ15+BJscN+/oLlzQMOkV0ym/Zb9UJMxgbSv906/vgfpxsjMFc8m4jicixwcY4NIg06H7UKntKHYNv9mDLRHxyG2cNiWB41j7Y8dolwE+83z2K/lk7fAC/2IdSZomp1cYHZfidA6V+yPLv9229ac+uQu3vmCms2nMl5l3AXwc7Z/uimXU4J1Vj474MjnXu3seCnvlCN7fmH20P6AI2NUGWPHGqF6v3nuNkCinJB6Xe4lI6PKJYRC90Wodhzj0rDpCITtM9qSembyJnmj+rxbaVqw20RWaLmx4CX9jghdpWT7ved9zxFVU9ZT3BIV06PvLjSuu1ejEEpuuDMj2W1HtMzRpyct1GVPb4QiOEcqASe+zVdeby2uC5hjOdprfpmr3ONpxaR27yXHW/NRsHJv1wsMUAbxo4woAPHGFbf7Dc8BaFZT0C4Y/SfF4NoZKAvzA2A1E8ETtb1+i7VVRDrlntUutCVwCiDakV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both __xa_store() and xa_erase() use xas_store() under the hood, but when
the entry being stored is NULL (as in the case of xa_erase()),
xas->xa_sibs (and max) is only checked if the next entry is not a sibling,
hence allowing xas_store() to keep iterating, hence updating
node->nr_values correctly.

Add xa_erase() to check_split tests that verify functionality, with the
added intent to illustrate the usage differences between __xa_store(),
xas_store() and xa_erase() with regard to multi-index XArrays.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 lib/test_xarray.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index e71e8ff76900..bb9471a3df65 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1874,6 +1874,10 @@ static void check_split_1(struct xarray *xa, unsigned long index,
 	rcu_read_unlock();
 	XA_BUG_ON(xa, found != 1 << (order - new_order));
 
+	for (i = 0; i < (1 << order); i += (1 << new_order))
+		xa_erase(xa, index + i);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
 	xa_destroy(xa);
 }
 
@@ -1926,6 +1930,10 @@ static void check_split_2(struct xarray *xa, unsigned long index,
 	}
 	rcu_read_unlock();
 	XA_BUG_ON(xa, found != 1 << (order - new_order));
+
+	for (i = 0; i < (1 << order); i += (1 << new_order))
+		xa_erase(xa, index + i);
+	XA_BUG_ON(xa, !xa_empty(xa));
 out:
 	xas_destroy(&xas);
 	xa_destroy(xa);
-- 
2.53.0.rc1.225.gd81095ad13-goog


