Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 481B9CA6011
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519276B0092; Thu,  8 Oct 2026 14:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CAFD6B0093; Thu,  8 Oct 2026 14:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B436B0095; Thu,  8 Oct 2026 14:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 113116B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:28:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 909F414036D
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:33 +0000 (UTC)
X-FDA: 85300294506.02.FF19281
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id B97F11A0009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MZpLOAY2;
	spf=pass (imf19.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791484111;
	b=NPiYA/scY+SN/if9/mMCug3Y/OAzVaiMeBJ4lp2HBKwczcWRWbluFZvHikDYj22C8DpSEg
	tItkhiojZP51Ypn7+7Ub4lcAddkv3V/UpzxBJl4EKYvs/9Vbdp1nPXQgpJ8p6La3Mwo2K2
	+5Y3DFox6Chp+z8Czul5CpFiZTK5XRA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MZpLOAY2;
	spf=pass (imf19.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791484111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHEkYAP4Kvw/D7tGM2EVPaorXMSyBP1fknjXL4EHP88=;
	b=56f+DpzLlQ/fqqu+IbTpPp1wenYvWZtDDJsqhkYTI2aorE7OOO5jvGwXKQEnEatTokm/gr
	HONGbx2gvVaGtrB4pjsCtPh39mFlLdb0rNOC0izjyaQrJMelZjbjNMfleBHT2EpkNMqSh6
	mJdbVpXLsL9YKTN53sT2c25Q+EwnNjc=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-154e9d2d979so3450306c88.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484110; x=1792088910; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KHEkYAP4Kvw/D7tGM2EVPaorXMSyBP1fknjXL4EHP88=;
        b=MZpLOAY2+WQzAKjv7EbPF2hWkVRZsKg5U5LKx6LdypywK/YY4wgkO2WjiGI/v5xjW6
         sGyAPu5Sl9JHHtJyBb6Q6BCvxUYIATg8cDUsYPbWfA7pBrhROvYRk/kGLCi3r9ALU2XE
         X+2qmZfm/lt2iolweTtk9OAB+vGZXZ4dDj+FWeeNwQUnksrUvtVwcIHFDQrO7L1rOE7A
         +du+w7XVB9qEM/0SOIbdwzWQH088xH8U1BJX5QLSOOrkIaLina4K9dTQpGhahYc7lu4V
         JqmU5Eu7u2Hll4HwWOOGFpGx3uSOMwKX1lfaJzFMJHccsclUe6QTz4TXBfqSuiSkymgO
         MM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484110; x=1792088910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KHEkYAP4Kvw/D7tGM2EVPaorXMSyBP1fknjXL4EHP88=;
        b=e2dyeffAKBNZ9zYEamT9e5Jua6YP6+jm/lVT+bggyAXwsvlqRlRf2IPY1ynSpZCORo
         MrC7+azX1GxYqhefMAT4Dxiww/7bsWxfU7WdQTc5A4oYGsC7BSwrgckyGywj31iiFzN7
         4fT6wWDNgN7C6o3lfO02/8p2f251x8vYYJvG5JsZlS8bGmBEB1LvxoVDNHg7MR+VIj1W
         3m7QHkvBw6MjYApW2bQ4HSfrXuP8hd+225NLO3Xq5idWuvcaH6gTj0XROcJpPuPIPxki
         5hyLJ3vG6b7+UiAUSc5iVpmGg0km/c2vheBkkipZkms8jFZuuNK5yO73TkudMG8zGp/y
         HSgQ==
X-Forwarded-Encrypted: i=1; AKwUvByQx+8t3xu8pIBvlrCTMl8sBbwvQUQgodMcCfSO+UDKd9gm8DhVGT2NsD+JyVlxdKrlpcf9IN9HNQ==@kvack.org
X-Gm-Message-State: AFuF++mKUOXh125wOuUI5TNEsl29g7T/8Q9/sIzx2wh2mk8/Vt1CFcez
	KJkl9BWV2Cm73eeBe2DgPmYrtnU0hlrNIDf8ZEZ2sYVRwvI8AZyE0EJC
X-Gm-Gg: AYBFou3o5nN8B7idN1hpkn5brqzwbLbKr+MciS/AsqDODc5MpA9AU6l3Sm4o4AJut1Y
	Yjfo3VP6ZK1jnSp+vMkbvg59OLB/Iz6WWW7Jzb4QvDBUNGvMrLyyGjU2abpsSihZMCyCEYR0ZQm
	T+0Wz8cuKbvGgf0n364bVnfkb1gEzW4q2vSL4/bE6WMasyCGSiTszDXn8GbjSfVpNnrxRPMguNz
	pdGMATM1g4AEx9hL4nv3pFfPyOTubpdjgK17TQ/CC7139XSo1Mu8Ge2mQzUnYVQx/S2FUjtigBg
	tfU3imKWg9+TFG3qtwI4ET0+gLSzH1iauLsNlzdKM8ZPqpI+DFEI5JmDh3g5rvSw9V15SGluEab
	U9V8urlj6t0SW5pl0sXIt35wHJEyBotsPiwLJJLVVqjlkwGyxa1T3JxTjAhjmrrDSgmwu6VAnCC
	dY2Dy9t6deLHyKUPe47E/D59OPq3azS9vLUc+DJNEmg4fyB3stiD/8xz9lYsEYVgSU1nDZWlTEs
	SzSECkZ8Yo=
X-Received: by 2002:a05:7022:5f04:b0:15c:20b8:7973 with SMTP id a92af1059eb24-165a3e83adfmr3350053c88.6.1791484110399;
        Thu, 08 Oct 2026 11:28:30 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:29 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v1 1/8] crypto: acomp - Define a unit_size in struct acomp_req to enable batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
Date: Thu,  8 Oct 2026 11:28:07 -0700
Message-Id: <20261008182814.27450-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B97F11A0009
X-Rspam-User: 
X-Stat-Signature: tfk7c1sed4ry79y7mbi754963s8gd5nt
X-HE-Tag: 1791484111-435114
X-HE-Meta: U2FsdGVkX198wNKtPgHErbTRkUQbxtUUqNf6VsPrw4q5e+kZz3/mjnqcFxNZD5RxdlvBDNWW7vTkGupv+0OQQPcSAu/Hpik5fM8vhdQvww9odOyeDlJFvHzaL8ocorJJdatpqlpl4Ir4xiuj+AlmVMBrnbyF0HEslxIX7oZDjBoRpy7N58FT3YLw8lZiq58l6gI0EMvl1pvU1/qmBgAfuj60HkwGbMD/Hm2oY0DQb2dA4+NVckTGQqhV21KA0B4c8JFVRtrUj6ep/xRd5MzSa0LaKHqzWodXcdqOzTbJR8cTZK5Kvgxuim+HU4gCD/AHuTXHSm1sVV4RC2JXD9XlrZZhKV1aEdMfXK9lkiv3vMz0vDXf8JfMjKaUgQmaUkfuU1jA0FW2dsamAkFxfyh1hQYYZUI4JCmY93qLvUzIoA+sMRB1US9FbwiafRzQjTnOdTQtU2UT140LsvJHAIb2Mkq0kpeizQod9M+XIoZiKoCobH5UhQhokhNv1dEF7JosZ84QLRNceILcEi7tNDJKzbJR3swebuMSF3SZjIGSlbXQ+s78qBG0pQjUIk3kPg6sLtgBoWzcD56hwVJVAELFy4qIt1zWAjsKCTdEGAZvG7TYx4YIcajUhYR1vwf1j3FY26GW72mZGwCSPZ12e/9WXUzqblFME76p/sGwy8QaDxSeNRBocZjW61cdfxLH07yppUF54aMzNUp2xdFLJscqiR8y6HN7u3kyx6O64ssJgC/1q/ioH8E+8pwydjSvCVqQlV3kbroUvrjUfKSOH2AzM51HN080DeU8cJImHBt+BLzdnD34qhZ0eTmBlkLZBhp18qcIBvSDuRYS8S4Hq9XHLFA+/682N6TXyTNmEwLP7QbSswv7IJ62i4/9K2KTTDa2RbYoz5JT4M6F2xAbY/7c1oHKOx1Ba13gNzRs1tb/lLiWMXIgdqNE6CQTp0wb1MiPwV+HaoYC9m3fgCPxysC
 wcsGt6WJ
 H/MYF8p9mY0JfA3fSOxW6d+qC180LRnQOLX+oB95jF8HztfDulqNa1BTKP2/jFDk8hPzrNCaRODkonxBMCYySD11Y7H/tn2xFa2lJRKDWBd/6zE9xd8uUk7VPRKjxx594959Uj/07N2z5u4cbGHA7HmDwVMxA4/0SYubDlCO8N6QyHY+8L/gz+/fcGcOSgoZnQedYcxsTdndpt1LNuGuc86BFt3VuN7qnxQG9aoPIFFog+DHHtz+CyQgMKQoAYQvN9XJmoxBIZNUpTbkMFRi4UdTEVEHAqUdNoaQTuDO7qPoB9ga70G7Os2DMdYSUl18yRy1XZt6VzB9aVIRFSDY9HTSg80gRYbiw1q81DnnoLhJiV2MSrm6o/CHhrijzCCvpFedT6WkPDI4ZIZX+WHhkO+/QLVY21xGXNymwGRQASj9TasELbkXhSqlZzfW9M7foiJ3OBNZH6CwojHEHTqqP9vvl5FBheqzl3VkIgtafP4YWDIWwAdWDcenhf+HHGkyjVyu2NGoaD7l6/qLuz4bz7GEN/9Td8lBBt4qP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We add a new @unit_size data member to struct acomp_req along with a
helper function acomp_request_set_unit_size() for kernel modules to set
the unit size to use while breaking down the request's src/dst
scatterlists.

An acomp_alg can implement batching by using the @req->unit_size to
break down the SG lists passed in via @req->dst and/or @req->src, to
submit individual @req->slen/@req->unit_size compress jobs or
@req->dlen/@req->unit_size decompress jobs, for batch compression and
batch decompression respectively.

In case of batch compression, the folio's pages for the batch can be
retrieved from the @req->src scatterlist by using a struct sg_page_iter
after determining the number of pages as @req->slen/@req->unit_size.

Please note that acomp_request_set_callback() sets the @req->unit_size
to 0.

In zswap_cpu_comp_prepare(), after the call to
acomp_request_set_callback(), we set the unit size for zswap to
PAGE_SIZE.

      acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/crypto/acompress.h | 49 ++++++++++++++++++++++++++++++++++++++
 mm/zswap.c                 |  6 +++++
 2 files changed, 55 insertions(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 5d5358dfab73..6462fc46f4ec 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -79,6 +79,7 @@ struct acomp_req_chain {
  * @dvirt:	Destination virtual address
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @unit_size:	Unit size for the request for use in batching
  * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
@@ -94,6 +95,7 @@ struct acomp_req {
 	};
 	unsigned int slen;
 	unsigned int dlen;
+	unsigned int unit_size;
 
 	struct acomp_req_chain chain;
 
@@ -329,9 +331,56 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 {
 	flgs &= ~CRYPTO_ACOMP_REQ_PRIVATE;
 	flgs |= req->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
+	req->unit_size = 0;
 	crypto_request_set_callback(&req->base, flgs, cmpl, data);
 }
 
+/**
+ * acomp_request_set_unit_size() -- Sets the unit size for the request.
+ *
+ * This is a helper function that enables batching for zswap, IPComp, etc.
+ * It allows multiple independent compression (or decompression) operations to
+ * be submitted in a single request's SG lists, where each SG list ("segment")
+ * is processed independently. The unit size helps derive segments from a
+ * single request. crypto_acomp does not expect the segments to be related in
+ * any way.
+ *
+ * Example usage model:
+ *
+ * A module such as zswap that's configured to use a batching compressor, can
+ * accomplish batch compression of "nr_pages" with crypto_acomp by creating an
+ * output SG table for the batch, initialized to contain "nr_pages" SG
+ * lists. Each scatterlist is mapped to the nth destination buffer for the
+ * batch. Depending on whether the @req is used for batch compress/decompress,
+ * zswap must set the @req's source/destination length to be
+ * "nr_pages * @req->unit_size" respectively.
+ *
+ * An acomp_alg can implement batch compression by using the @req->unit_size
+ * to break down the SG lists passed in via @req->dst to submit individual
+ * "@req->slen/@req->unit_size" compress jobs to be processed as a batch.
+ *
+ * Similarly, zswap can implement batch decompression by passing an
+ * SG table with "nr_pages" SG lists via @req->src to process
+ * "@req->dlen/@req->unit_size" decompress jobs as a batch.
+ *
+ * This API must be called after acomp_request_set_callback(),
+ * which sets @req->unit_size to 0. This makes it easy for users of
+ * crypto_acomp to rely on a default of not opting in to batching.
+ * Users such as zswap opt in to batching by defining @req->unit_size
+ * to a non-zero value for use by acomp_algs supporting batching.
+ *
+ * @du would be PAGE_SIZE for zswap, it could be the MTU for IPsec.
+ *
+ * @req:	asynchronous compress/decompress request
+ * @du:		data unit size of the input/output buffer scatterlist.
+ */
+static inline void acomp_request_set_unit_size(struct acomp_req *req,
+					       unsigned int du)
+{
+	req->unit_size = du;
+}
+
+
 /**
  * acomp_request_set_params() -- Sets request parameters
  *
diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced..ca513a9f89e3 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -845,6 +845,12 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
+	/*
+	 * This should be called after acomp_request_set_callback(),
+	 * which initializes req->unit_size to 0.
+	 */
+	acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);
+
 	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
-- 
2.39.5


