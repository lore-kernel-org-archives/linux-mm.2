Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DEFC60A2631
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YXd1NmHD
Received: by kanga.kvack.org (Postfix)
	id BF84A6B05C2; Tue, 20 Oct 2026 22:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8A66B05C4; Tue, 20 Oct 2026 22:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A984D6B05C5; Tue, 20 Oct 2026 22:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 848B26B05C2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:42:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EA3B40445
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:58 +0000 (UTC)
X-FDA: 85345086036.02.589E3F7
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5C7F91C0003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YXd1NmHD;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSNm3PGjiMFoOsDzDjaZU4Z4GyR4rNUbLgx0Nkj+0wk=;
	b=TWCr/BmOmXyiKmMeSQN8rc32EHmHakoEmGHlHX0giWeag6+CpaokaG7rZsfdEEcoVFzhOp
	+RNxpJyUdfx/mIbK0lql7/QiUOrx7Fzc4yh92CVx4fKsAQj5Lp+LPcoc8+eW/MCbOZoiXu
	I1dRcEB3ZUDg23gsOBjNIhcxoRzAW6A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YXd1NmHD;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550576;
	b=SP5XkKVc94fddVpFO5YduLDkrMqTx7DFfyWBfoqrUPILfXq5WUlkLNt9MeiaZZ5Mgm+Cif
	Gktn1Vq8+joia6E5m5UNZARpezSq3fec2Zf32P9Tm4Ji94re5RGjfVf0edWVjDT/vIK51Z
	W16MuR7Zs70E9lPUUFtEYozwdzhHFEs=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-15dd124bbe7so461817c88.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550575; x=1793155375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NSNm3PGjiMFoOsDzDjaZU4Z4GyR4rNUbLgx0Nkj+0wk=;
        b=YXd1NmHD5HWOG7pLBXvSpTd6/yMjxQutCAwP+cDRpryNXpZOdGjUSriiYTsKAbm9qz
         8TTOJfOau0z8oIt0MP2iLIx3GOsQsrvCiUqdjXSFJ4mdX7fmuEt9DjJ/UiKcgauM53cT
         IH4Tmhzgsr1vWTNBnyFFsVCKbobP/eT4KW5bo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550575; x=1793155375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NSNm3PGjiMFoOsDzDjaZU4Z4GyR4rNUbLgx0Nkj+0wk=;
        b=CNY9lK+6d1gii2H4GmdGM01hWcJS+1hN6RttuT6Baz9f0v8AtdJ0F53NBUQzqDrGV5
         d4G0RfMETagAi8O6qwvyRAGPMENxv805RvursdR6qs8FK4OEjkrER23d39cXQ9lWXCrN
         m8BlIySSLGGtZeg/O5Z5SjpBAzA7efsOzOm/s8azMqWX4XPs6QN75JPeWoI2tFIs5LIp
         cv9zEL/gH5IphcGu+5Kn5IiVNDSS1z/Ax2d4BIc5chBIPmHUZSas6bjtI9HIzntQhFW0
         +H+4XmZLROouEgRHiqSbajWc1eGA7QWmCCEIgP9GDF+AAzIHyaenlXL3AuecusRyssbS
         SBcQ==
X-Forwarded-Encrypted: i=1; AKwUvByXNKZ92TMAWlq7q5nCqWFgzrZNNldtX+za+fAZcf1XP6d9rhYTbOkczzUkFvDUml2IoI/k/Rr/BQ==@kvack.org
X-Gm-Message-State: AFq9FYLjR7D6ugzIftZrraECYEf99QfeXUxHkvIbLd8dJZmCd3LV3CB3
	2PYkEaZ9cO0a+TL+IN4K6dbrHKq6pySGYNbkaWkHegmRAIZIld9V9maRyNE66dlJpA==
X-Gm-Gg: AYBFou0bBV3JBgJvC9L1ht11loX2qGd304BV2up3Qvjtm4hKSBv6u0NaEHvqtIX2HGS
	GBkO+1Ezax5b+i6A89p47av/lIvuoAxI4UVZT8Byx3pu4cqsze2JX6S6wA6aObsMw9DChTDET6n
	vig6QsD7eb/6+OVVpbVz69r9iAr5E4kVdbdNUTwp/8a3BUfhT10cmKc5FDHiQ5YRoJ9abcRxMtM
	FqkvakVv+UVFHWjEyfUiJW3NyhuWVs62gxpZuqn/7hwyCW0au2Y0a0XKpf6z0VkfdnmCLvAvsUG
	5S9a5lKFYelhkYrKUhfU2qg73wFfV7PFx+IeFlif6Xwd5Ai9df1nIbwVccGkaP03FWZNJ+sqfJ3
	oIMJXmG/qefLKJ5LmBQsoKbcD88QCR4She6hxaLalMrLFw9wT44snIy+n1/Re6t486PWRHL+YmF
	9cCpal3yvLcv92b7MWS/4QRLwvZp6PtwGlK4PC3LldpcNCBZDNo13HKxGguKNTdllGBpYvQXqsR
	LH965aUY9aa+ncZK/1cBbHiQnX/eXZvOqwyf29IrlW5eDYv67TQtYUNQq7socZWlo1lnqnWmwRf
	vDxxa8MkdXEHs+u850l+19pYivjk8bihQt10SP3arv3k
X-Received: by 2002:a05:701b:428e:20b0:18c:ad6d:b790 with SMTP id a92af1059eb24-190a81e3c24mr914391c88.45.1792550575181;
        Tue, 20 Oct 2026 19:42:55 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:42:54 -0700 (PDT)
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
Subject: [PATCH v6 04/13] zram: zstd: do not allocate empty C/D-dictionaries
Date: Wed, 21 Oct 2026 11:42:14 +0900
Message-ID: <20261021024236.1787884-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C7F91C0003
X-Stat-Signature: 7r18hmenj1uz9cz9irkbicg4uzmffbnj
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792550576-351224
X-HE-Meta: U2FsdGVkX1/9wARNdfrIT934lVwIA56lM9RTUlejUvsp9pjjM9JVLcjO6vV5BGS3Vb1tEvFxmlIbNpLsfsZI2jDywCXE8FLGr9X2bjkB6HQdTtBIpHaYe2w7aun1iofuLYVTyneLvE4Il7f5m6jWfqh6Qj1uv0qvZxjZmBVOPKaCJxRUwfei7hi2/JsuwM4UKgbzAnBbBjSg76yQd/uOuDcnvghV5cBY5yGd1nB5LGCXCp6g2b8mC2Bop9yXAeFn3/DFNWVygYNY0S+PvnIF6RN1YzxHSZ20Vy9y/z22UJ27Ex3bDv0PbiYge2P0rSpXoI1KvxoUfBu5c1pxfawccOcJTxSDO63h6TqZdw1054LKByLEG+PCxKmSDxywjjagOlm0ydnoYEivKG69Hh+aYJ9aJAvaW/DB8kCag8bp3h9Uo4EFsoaFV0qdYRNQxIbH4OaEIJiDFfP8fw9YGl5g75PqKc5BzDXc7RT7Ki2kYy7Bot/87IbxGJIzccw9H1YZYyI5v+mQz1ksKlcmoalESOSQmUsvxIIVkwQgP1lCHCpI0Hp6fPGUIcatyiGPWkhqtI1NVugP/XDcmB6L2bwMc5tAVJBy3xgCJd8fmaNeqdFamKNqHMIgoS1z4U2DV/gFKm/MVWwDnh2/5L6q/4WVWETEq/L1/cQX7odcEKKgz8RIdXY9Pb594wdcBYK1nCOtrbkgePQmQDNELA49qYhrgQHTnz9ErYRiC+2SmkZCRjaLpMW5y3nDYjOlTyNnRHo6voXVF8Lkg0K1u2grXupsM/kg+K3HbmUfXMrIjm9reCxTiPlp+u3USZWJ9us1R4gdj5G1KIPYieT4R09jWKl0kDSW2lrMFhQ0tGhI4PJZWuQwZPNlmdHZKPI5BIb0Bgb2WlJBKVQHWu4KwKgVPgkuvworEKUIoIbpnk0KefNFkBOv6ZTn1/xDh0ZsUhdgb4/AfdTqqAlaAAq8E+82K7X
 7PRbk+ph
 KzGO+2q7600Y6Vc1acauP6y06f3zBhudaf3OzqlfJXRhW2NTrKd0f2J/wjTAEnAFqZGxPfRrYrJQtrpl5PNFIH9mP8VaM1bBidaLlpHf9IAZQn/WVdLeZFcwJAXDq46M/oEke5N30iF0FvuGNioD33L+U33z9qCCgkuxBqgbidlaxHIYJR583NOvcVhaPLjYwj0cV0p5hSNEkj7MMYUDZyO1P/3uqVThWVu8nVEXLy8e8li/THtZS71J6jjq70CZ9tKLQAhOfILRRTtr18YMLRs62eJQMjK0QdXSQpXIKKaXtM3xm5+miovNkNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Do not zstd_create_cdict_byreference() / zstd_create_ddict_byreference()
C/D dictionaries when no dictionary was provided in the first place,
because zstd still allocates internal memory for such calls (~96 KB at
default level 3, and ~160 KB at levels 9+ on x86_64).

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index 127976b5455b..b367049f131d 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -76,6 +76,9 @@ static int zstd_setup_params(struct zcomp_params *params)
 	prm = zstd_get_cparams(params->level, PAGE_SIZE,
 			       params->dict_sz);
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
 	zp->cdict = zstd_create_cdict_byreference(params->dict,
 						  params->dict_sz,
 						  prm,
-- 
2.56.0.212.g129ede20d9-goog


