Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28F860A3812
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=QF5CBvc/
Received: by kanga.kvack.org (Postfix)
	id 335D96B05BC; Sat, 24 Oct 2026 22:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF546B05BE; Sat, 24 Oct 2026 22:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1878C6B05BD; Sat, 24 Oct 2026 22:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1D856B05BB
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B33B404F4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:04 +0000 (UTC)
X-FDA: 85359541008.29.839708B
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 89D7E20005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="QF5CBvc/";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEgwNj0hBr33FG112cIbL9zPffMBohhrmKqGY1PHao8=;
	b=1/wMcNnn7tbyLvhJODHcTcQ00esNbax+CA3B1jyLhQvW5n0FMnU8d7Iw4ZLIREzIinINi5
	Ib+OjMzttMVlzaazW6IP9+0TSZUS4Pc4rk+9jsJf9tlZzU9Q8nedKYR9J1qKfHZwJh7ZY6
	bSrllzoVHFfz0IuBwDJ0rJTwcHSQ71Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="QF5CBvc/";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894742;
	b=BRxnVma/EEJnhELpZ9Ip5y7Rkf7RAtiMiX0MKMDTphl8uoWUPkKIkNPpf+VNBnDkpwgSBK
	nv1VtXIYqo5kS23Fmn3lpKCIS+An5ucxFWzOWMa7YeBnHQH8WI9PnVX+hu1xX/nKZJBYjx
	loBYsCKxGU4778urTuGIH/idrQjyPOU=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1931ff67a29so4064010c88.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894741; x=1793499541; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KEgwNj0hBr33FG112cIbL9zPffMBohhrmKqGY1PHao8=;
        b=QF5CBvc/Udrn/cMV/NanIh/js6yICxHqjNPRy7hiRQ24pqY1rxLvbY0d39PoG4Csj2
         sLIhC71tQGaRYz4JDwxpLyXz48nKWwA5qxukkQnEtFXAqmvwKdSou0TDIUaEZtlBRT46
         bwgoLL/IZPIhVqQmADwbjeDWymfQtktx/kVhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894741; x=1793499541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KEgwNj0hBr33FG112cIbL9zPffMBohhrmKqGY1PHao8=;
        b=K1lyK13SWLDeGfj3M97OEyU9eFstLYwP48lrMTXF9cDrlyY4HTI76YNFl9e+k2iXZA
         rK8Tgd+yaP3hjcyEN97XgHXSFXqz2WansluUGoB8h9Ss5ZPnVNmvS/zTe5F/3wZyBFf1
         0JL3rgkhkrINYu76tA7+Y5ievRvHCUvqmaeV2oxOI4dMJbtkaxmXkaSvz5ccYDaGBMOb
         d0CDxBuC/4nrpRkcZ/JeP5Bt4CxxcH/EVqhmK6tNJP2nYg0SlRB83aneShLx2JdImw7u
         0XUF3V/snY7/VofLzfnnK5ErmaIoHFIJpE+nR9qclfBRUxJyjGZeGY0Do5Ab2fgkhhPN
         hNEQ==
X-Forwarded-Encrypted: i=1; AKwUvBy8IX+QBD1JiFUj+cEnxRgv/PtJu7B1/7vm8mcq2X6cahmKo0Gt7D7DKMidq490KsUstADDl9tnUA==@kvack.org
X-Gm-Message-State: AFq9FYJqSI2KD5H6rIJ5MgzSNwYW38MrkIO79caJht3zEsybOaympJy8
	goS8wTLbRGshwi1IobetPMTU4HPAQ6z0RblqD0NK5O7vk+aP1vgfBJ95Sv+5ZWLDPQ==
X-Gm-Gg: AYBFou1VYCNqqW0q4/GFMbcvs132chLKT/KHUyacOFOiURT1vO9KXEMGpntBOT/HhDn
	zwH7u/IBP1tkBtzpojOheYnIqwNRRmHb/HWm0iQ9PHiajEvDLYOrjHFY10DT8MlWJYsaxo2qo2f
	z2xFn86oIq6mL9fH5VcOlNKKcr2ysMwv+/lD8UlHf0sOLZXrAdXfC8VJ9tRr6m+91MfLhxdVIjj
	+zBcxNF6gSOPX+KY/PRRVyRvRlu3u7pson5ml4Rdi7XOdwwhuwg61BWZP1lG0iKd6M8QYfhSGsr
	HwOV1H3LBFrH/lAYqgjxam16s12PMH0/Jm7q687NEzZasBMioYEtpVI2Eap2VK14lzzYAMmsZ53
	nK6GL7VE8wqv1RYzhqzxfgDOnf2nVv07IpQOP+sZGjISbaDPp5d5W/2dQHqY/uExz+pXb0CHBIQ
	HfmY7kQCu35xWQQdf4eJU2hQYNV+saNz76fKC3CpSYiVR0gklyNPi3kvdnNuuOkUepn5h4k4abv
	TvLK7Qio8/sH/vEQsGrikqSD6iXInljYKYizN/Od+pwAm6O66Y03ClTltJGAjh9RCYCu/OUcr/k
	y9nInC6EQlpD9deAPkKjuDY88+6xYrNPndBGNi9t3crbC9WqBPGO0dvhClfv0iycqwWcxqmnnz7
	7BZ0RO7IqtueH7jqekbXv+AF4fnSpe5P/NX30FJ8=
X-Received: by 2002:a05:701b:458c:b0:192:3b7e:ddb9 with SMTP id a92af1059eb24-1993499dc7fmr4508047c88.13.1792894741245;
        Sat, 24 Oct 2026 19:19:01 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:19:00 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v7 07/15] zram: lz4hc: pre-initialize dictionary stream in setup_params
Date: Sun, 25 Oct 2026 11:18:23 +0900
Message-ID: <20261025021839.1542805-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 89D7E20005
X-Stat-Signature: 53fyscmuz9by9wcf3hrx5e5xnhzxyedo
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792894742-169504
X-HE-Meta: U2FsdGVkX19Te6ZaBFIFPkVdU5SIguUUDNU4+ALYLqGz0a3XaePsRjqk2YSaM4oR40HYw+18Q6gaG62WfkguDR635AhPXZtMeAak92V6NrMP6Mzwt2R5u4snsPFZMR/GdlAzJJWv4g0Ym06fE91pTT+9BfTPSb+k9YcGyaMCOs2UPiaHvFkfz5Dq02S7+3/AVBYybTbwPMWOdpHmoYj8w0tnNitjDVLtP2E4I3NshmboINIqe0I5GKlJ7Qt4tHtWaNn4tkjBLNrttTz+qwwqCRlYnY9cJ9h9GeBHooGI5PIjy5ZcWWVncU4UqE/vXehQNsDSPymbisMCGR2sNaSQciThmW+Kh8XRXnpHOWNA734ZmH1gWab63grwFzn1X6rzHOWphcIAxqiS/VHKrAJ7qwZuVKdb/HdMTZzX2Cz4Fttivphv5u2fEbcx/MS+7VapDu/C+EZ0+saSTrQr3YnJYQ+LWXJDa57mCl1HZUfv+613U5rqFVDVhjUFRNSrHI2EV44qCiy3T/Ks+haOtLeKEeVDcHPlSBUldcjjvbFCv1CuUkg0wNgIT7iLzeO5Q/ZXm4kHmpG4zklsSVaqz0uCbtAdzHYWoeiM7X1VdQ8WrFue/hJORJOpktLTbVvioZWZoh+vMBMhkXMbsDX1slmX/ZBwQG0NDgjcMEvu4tCy2NhP+lI/Fqg0nMLJmpxMsTdEj/PqNEMhjfWNL+A1l7OJcVPN2t+GVOZyNfWQTb/88/9Im0zHHaxYTetzA7NkJiyrk4wcOLrxR+25KGwvLKgucjRPy7lRh4dhshOnknACtFIE6G0mVGcfWEojhaA3rYEc/DNIcKiA8s9buvlicxP1KCkdroxvWCe19tEkPm+cZst3LpeI4P+7aL4d0kT5XV/dDc3jhQ2RYdmaTLLtxCGmbi4Z5NGe2X+juv4KgY1quqQznH6kUz7oFCuzEnNH/2s+f+ZYp1jF7w3wPVjtZGe
 RJ9Beeq0
 Jr+CvmPokAgvg8xLMlhNJdgjY3Pqe4xbejS8Fp1izZ7rfzOwlrckbQxbOortg7in8VlYCrW+Ui/16eu+QAVVJtSLdtDAOwW0v7FqUSxSmPWMLgXv6luO5OvD9nX5+M41gUrqKCEaQ0Ot3UYRXpNyiKnuQUXRJ7TWOWdAAJbS0i7Q44oJavOySIeCbwyZk9vNFL+WWreD/En5r9+hdhR8/LzkXUPXmoBaPOOEteKcLgK/7PbRYxmUQhnxymBdUGWejQYTtZAgzufK7GpsLSvbjqBf2wu78GsIphuVVMHYpvkh9bkx7CRsP/wsO/sWHk5sHe/Ti0UhzSjY+qoffU0UdhOC9kKsGJ1KSJc/O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pre-initialize the dictionary stream once in lz4hc_setup_params(), store
it in params->drv_data, and memcpy() it into the per-CPU stream before
LZ4_compress_HC_continue(), matching backend_lz4.  This avoids resetting
and hashing the dictionary on every page compression.

This also rejects dictionaries larger than 64 KB at device init time
(matching backend_lz4), instead of failing every page compression with
-EINVAL.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_lz4hc.c | 31 +++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index 5c009835a684..f3656c27af21 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -18,10 +18,20 @@ struct lz4hc_ctx {
 
 static void lz4hc_release_params(struct zcomp_params *params)
 {
+	LZ4_streamHC_t *dict_stream = params->drv_data;
+
+	params->drv_data = NULL;
+	if (!dict_stream)
+		return;
+
+	vfree(dict_stream);
 }
 
 static int lz4hc_setup_params(struct zcomp_params *params)
 {
+	LZ4_streamHC_t *dict_stream;
+	int ret;
+
 	if (params->level == ZCOMP_PARAM_NOT_SET) {
 		params->level = LZ4HC_DEFAULT_CLEVEL;
 	} else if (params->level < 1 || params->level > LZ4HC_MAX_CLEVEL) {
@@ -35,6 +45,21 @@ static int lz4hc_setup_params(struct zcomp_params *params)
 		return -EINVAL;
 	}
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
+	dict_stream = vzalloc(sizeof(*dict_stream));
+	if (!dict_stream)
+		return -ENOMEM;
+
+	LZ4_resetStreamHC(dict_stream, params->level);
+	ret = LZ4_loadDictHC(dict_stream, params->dict, params->dict_sz);
+	if (ret != params->dict_sz) {
+		vfree(dict_stream);
+		return -EINVAL;
+	}
+	params->drv_data = dict_stream;
+
 	return 0;
 }
 
@@ -93,11 +118,7 @@ static int lz4hc_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 				      zctx->mem);
 	} else {
 		/* Cstrm needs to be reset */
-		LZ4_resetStreamHC(zctx->cstrm, params->level);
-		ret = LZ4_loadDictHC(zctx->cstrm, params->dict,
-				     params->dict_sz);
-		if (ret != params->dict_sz)
-			return -EINVAL;
+		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
 		ret = LZ4_compress_HC_continue(zctx->cstrm, req->src, req->dst,
 					       req->src_len, req->dst_len);
 	}
-- 
2.56.0.257.gf7497c7d27-goog


