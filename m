Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA24CCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 19:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD5F8E0005; Sun,  9 Nov 2025 14:48:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973628E0002; Sun,  9 Nov 2025 14:48:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85CEF8E0005; Sun,  9 Nov 2025 14:48:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 714818E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:48:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 044CD140A76
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:48:18 +0000 (UTC)
X-FDA: 84092105118.25.2F097BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3A1DE1A0005
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:48:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ogCcESOC;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKmNxuWv;
	spf=pass (imf19.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762717696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CNXDhEfUs2p7rqxHrG1BCgqb9DusTf8GED65ME2P2Z0=;
	b=oWB5QFAUoXTNrOZ8cDMMglzUylCPy4qV5o8O2xzjjMFRIj+jvq/k5aibC9dKLg21KFEVFx
	4ZDuCIF9heI+FNXDVawldReRArKNDZMYl4hfv3jJPrd1x7olrF0t5JHbSR/zBkYvsIHWCW
	AM5E/zN3Gjma/8cIDp8kl6I8fJ5vews=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762717696; a=rsa-sha256;
	cv=fail;
	b=jgKeLimIGT29bDLoHIby2THxMnbw5fdNeqRUU4H/iku5LDz1jBST9Johvl10JUGHJviwaj
	Y3gt+0XI55pPqZuW+ldLcY3wAqIX7Hjh7NT5CKcOeRkCorLHzdf+hL9uoA4/510nkbtD9h
	MbaqQiWaVagwx651NmOlcz6pXJn87VM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ogCcESOC;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKmNxuWv;
	spf=pass (imf19.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}")
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FC4F43487
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4070FC113D0;
	Sun,  9 Nov 2025 19:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717694;
	bh=2xVmGhP0PFx/hs6+oME8OSKXBynf/1IS5/aMFkAz6UI=;
	h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Subject:
	 References:In-Reply-To:From;
	b=ogCcESOCjEbKlpovqoBLwPD3lyWUupl8NLsJB7JwkkTKIThNgTysqv0mqc3aHUNJ9
	 CXM6jqoTUqviwjez0e96bCVoDrbo5vcTAz8BSiN2BQjWLaKDUTf2TZU0QjkcmBjktf
	 SOwqdP44fOp45/6zuS7raSP6v8ddenC65Tp7V2XUESeEeK4rliE5R+CF6bjjsAn+s8
	 o4O4YomG4u9oqgXJi+2zpLZrTnO0utMujwF/KyEMMLslib+PqfFr0VGrqRI4ddH7kO
	 8prBwsn29LN1GCCuHksxV9PPSFPfwTPjNnW6DPcZNk42buSn9wucKpQTAMSLL3nCoh
	 qwW46pOf+pdZg==
Received: from mp0.migadu.com ([2001:41d0:303:e224::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by ms17.migadu.com with LMTPS
	id kHFEHk/vEGmbfgAAqHPOHw:P1
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:19 +0100
Received: from aspmx1.migadu.com ([2001:41d0:303:e224::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by mp0.migadu.com with LMTPS
	id kHFEHk/vEGmbfgAAqHPOHw
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:19 +0100
X-Envelope-To: foss@alejandro-colomar.es
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=alejandro-colomar.es; s=key1; t=1762717519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNXDhEfUs2p7rqxHrG1BCgqb9DusTf8GED65ME2P2Z0=;
	b=cXczza5G+yiWra1Bd8u6zJY7gSq1EA8DTkYIi7Ow9Q1jMF2OUHZUGtlfBbcLhSxaqN5Mtm
	mvUViOHniv0WVOkl1WNnvRhLDc4Mjh0CDtU28cpCpl9XzxrZ0RS6pKbMPkwfSJHi9kD6T4
	0hfeV1yU1sjjdVTkbYIfxDZ41NriMtoSSMuOM5H7s2LN4NKfHZxr7DiS3AP7d0P7MdmTF7
	kp2qMmN3BIPB/vTp/f5YiWrdccJtgOwUgeyXs3Mf7AwR8XqAPKd7dlONsp0z5tq2898PNl
	b2pta82qdFp0HtAxBMf4dD8sLGX8FtA2ZTdFA6vO8WIfBp8R32Rjv80DHZHG5w==
ARC-Authentication-Results: i=1;
	aspmx1.migadu.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKmNxuWv;
	spf=pass (aspmx1.migadu.com: domain of alx@kernel.org designates 2600:3c0a:e001:78e:0:1991:8:25 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=key1; d=alejandro-colomar.es; t=1762717519; a=rsa-sha256;
	cv=none;
	b=QWB5bcsJF4o1lz/dQMUj3rMQy1/6CBCcvtMoKZ8K1lypkT9bFIDQSt9OAzK3HL8qM4tIKq
	Ts1aNE3UlZ+3tOjxyFY/4yPlyh0wb5Rrv/S9jjXiBr+95DU0qULHWpRA9YdaPLE1gu52DY
	6Jdcyr8fbxxMeSVpJqdMEiKqQoj9cNXEptuYVB4l8cbFA5xwcFerRS8/FsmQF/G0oO44Fv
	uUiBmiVxFO5kxjnEA45sggVCfjGATI68yfYmgLEJ5DoW6ifFBFRkzuberKeel9PlTjNBGU
	IxTLpp8qsto6yJorM2NckSydPtdf0hhRSk5p0OFm9r6LsJO9lS2al3PuL+dS+w==
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aspmx1.migadu.com (Postfix) with ESMTPS id 26403CF27C
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:19 +0100 (CET)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A1ED439FC
	for <foss@alejandro-colomar.es>; Sun,  9 Nov 2025 19:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 80D89C4AF09; Sun,  9 Nov 2025 19:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B71CC4CEFB;
	Sun,  9 Nov 2025 19:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717514;
	bh=2xVmGhP0PFx/hs6+oME8OSKXBynf/1IS5/aMFkAz6UI=;
	h=Date:From:Cc:Subject:References:In-Reply-To:From;
	b=oKmNxuWvf3uefHLZJ7tATBa0Bxw4do44LKQyPZeQJnvgPAtNUF5i/Erz1EfP8Vqbw
	 HfeOoXT6kWox/YmfnGRsin2G/8m/3u4qm/4IhXieh2EdfhYQS5Rxr8BcrQMF+lclSr
	 qa3FPhrF0GnAOB7/oNrstfo4XBQRdSjfGJZbGMaNPfhy4GK2t+vULJOS0GkeF6Cocy
	 FLHf1v2HUclu4yL8jR1vdJ3ANzJO2jLeii7Oa9Ux4mCkdGYFfkeeJ46Y7ZwSsNq4qW
	 aKvnCzXlJRVCKWKyUJUVYUvvmA6h78kzO5kYoui3Z7pkV1PsIs2dAfC9O5KVYhWVts
	 3J8enbum/k27g==
Date: Sun, 9 Nov 2025 20:45:09 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v4 1/4] array_size.h: Add ARRAY_END()
Message-ID: <9f87d6208a6c754ed0e322cc51a92e0ed6e59123.1762717358.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1762717358.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1758806023.git.alx@kernel.org>
X-Migadu-Flow: FLOW_IN
X-Migadu-Country: SG
X-Migadu-Scanner: mx12.migadu.com
X-Migadu-Spam-Score: -3.17
X-Migadu-Queue-Id: 26403CF27C
X-TUID: a3t4CK2y0IT4
X-Stat-Signature: 7n95i1mr5unf5jfn53rt4hm6m1fsqoqr
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A1DE1A0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1762717696-694450
X-HE-Meta: U2FsdGVkX19tTubyvkmEc0dwM5biTvuERfxNxvY3xOl/70ZNHDpdCAqtI1ziE9HqhNSrn4KI4ghOKwocSWxV3UsSJntM9gabS/2GHX5WKqhCiRMUMMG74Fzqaygkbx8a82eaOB6TFQzTGwpwBdIhiz9p7gJ9kVuWYaAjbJ0dDgOEISLd1eTi6UXM0dgDr13JFlZK97bWt4FzKBtAPUenELrp25x7SIeWW8Qhr3b0WfJxIS9FJ72vPdUv3jiXgbAn2/dThp9aL4SUaR3CfVuq9N8xJyxXTO3ams9VCU6/SgS/rk1lHLfVZ0xkI2ixsGbChdsRCMfGfCfyltbtvSGuk8vbZUGp/akzzLqJ6x9kUgVDg4syxgDg0i7NSHKaiYemXZDwgOeIgOq6isoHJ3hIdQ1gFkIvgutr614Qat7wlDrtNFEUy8L0+wLU4LHbdtyKtsP9ev4UprGM50f41zcI5V0afwXMVWaJaqDbGGVr0cJ28J/r9lq7kE/EhxMyLgZV+3j9r5e2fzwZzwEBTWhahWwf4Wp57gLlKI3DnoqH1KFey/HgWAYFkSPrWXF6ZcGMxua12gLGTgZDV3SXa4mazGPds4lULWYkaBjYEovgm4faRXyPe1o4Rof9W6L8vvHMZLP6JgE2owuNjig40/5dkKMUaS2oOe9MVSeV1EafvxrTUcvI31mDw32r7/wbWihzpnx1tdx4yXV3e8vRdybym3PCuOEKqZlw8DEH7ZE/+WmbxmduafdzqRbS70LX2SG+t4ZXlRpkh1q5Bi/2UG4PQAVtvq9x8lG53pru76DhaGWX3JaSVVR1jHod1GdztI5ITdjZ39xeuxJNjr93+CE2FJZIAS78w3t31SNoXuFssgtgbGdaqi1BBAJIQH/Rfa8WZ3VpustH2mmrF+VNV9c12HIh9sMtBuwzXWZOoNfCI58ydjtnsKz3ASo2eb+Npp/xXHs4gAi2hyIjO/4ux55
 QW7P70BE
 jpdWpsekDdDtz+1nx/B7NYttH1OZ/8r3QAr+Egg+VHz+IY08Lc8epiqAAtgOoiLD7rE5L+hrj30Fcy1qnprqW43h5VuORHi/FHm18Z07KP5Hso8VWiIkh0NP4Vm3H5J201Ey5fBbrsihIsGzbul2OER97nUz42/x0MYfKim+fa/gIzROn8HA9QClYNrftjLC/42MWnMh2w2JhLyNExEUouHIOrA0uTau7cCm9B/fdYQOHBTiUTou+iJDLsKpi9WvhxLCnA1JNQjmqDoD6VVLJfc7+oKj1vFUqWFD7iKo6EGQBl+v1Dig77VWEIIk/BVmWY1wTw3bb/ssxJLU5Pdy8Sn5umPDPQyajaB14m3eLJXo2QbUuXCNfRtgjXwpvtnR7IkwARhozG7rfbFO+t7p/48VOTwx2Rvd9yMUHE7ei2nvRy3Jddy5eD1NY5IIMgffmwz8o+xapgEr5nNvMzCWvOlySUJdO0Pglj4RO5b0r1G4Vt4oxQCBjY8oCyeoYqTDEjvPEIDz1qNF4KjN8oz0Y4JlpAGal2Zb7qJWqilTgW1dfNE2B7EyA4rcSs4sNTrnemT++UecTqg0aUxtDccf7TLD2sHSL9ftoBiSwUtPerORoZV9TAlytUhCKaWKfhjqAc4v8+DPE4hqgITADbaMx61b9YgWvjpAkrZ2Fo7gbFBQFmnh7zwvQyDnUJtT621BuIa6xYYzFVllqEr3b64xmW+3ot7v8TUfcRkGRsy9og4kw45BY5YRrEL9UtBtuDBg8ixuaMzPJg9pFP5g9h9YJUKprbvfDwdpa7DQ0C+XTx2s0WzSgYztn2upQeompQLGgs1ylNnwd9tg4FWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARRAY_END() returns a pointer one past the end of the last element in
the array argument.  This pointer is useful for iterating over the
elements of an array:

	for (T *p = a, p < ARRAY_END(a); p++)
		...

Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Message-ID: <37b1088dbd01a21d2f9d460aa510726119b3bcb0.1752193588.git.alx@kernel.org>
---
 drivers/block/floppy.c     | 2 --
 include/linux/array_size.h | 6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5336c3c5ca36..69661840397e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4802,8 +4802,6 @@ static void floppy_release_allocated_regions(int fdc, const struct io_region *p)
 	}
 }
 
-#define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
-
 static int floppy_request_regions(int fdc)
 {
 	const struct io_region *p;
diff --git a/include/linux/array_size.h b/include/linux/array_size.h
index 06d7d83196ca..0c4fec98822e 100644
--- a/include/linux/array_size.h
+++ b/include/linux/array_size.h
@@ -10,4 +10,10 @@
  */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+/**
+ * ARRAY_END - get a pointer to one past the last element in array @arr
+ * @arr: array
+ */
+#define ARRAY_END(arr)  (&(arr)[ARRAY_SIZE(arr)])
+
 #endif  /* _LINUX_ARRAY_SIZE_H */
-- 
2.51.0


