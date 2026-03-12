Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25CCA106ACCD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 17:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416DA6B0005; Thu, 12 Mar 2026 13:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE626B0088; Thu, 12 Mar 2026 13:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3243A6B0089; Thu, 12 Mar 2026 13:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9576B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:12:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD263160320
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:12:44 +0000 (UTC)
X-FDA: 84538055448.23.23E51AB
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id D17181C000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:12:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="h8/3IuZc";
	spf=pass (imf18.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773335562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Mg69a9vrgMcSAwKsm172J4h0Z4L6eK5f2x4mJHkOo+o=;
	b=DkNC334Ruhe14GiSAfPTOJETXk1WHVzBBGDtRWGjwGtRwo7HfXGYz/e9xLvSCZxAibFMPA
	mJ95ERvzzTAjET+ytVKoh4/cr5PumMyv/14ekg7cavzHAHIbj6+auxBNUi89/tu4Zyccs8
	5VGjeOXFQp/nwAzjMYMrsIWfBEvjTSo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="h8/3IuZc";
	spf=pass (imf18.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773335562; a=rsa-sha256;
	cv=none;
	b=qPl6dimeRBZaZYyjNCgKRitYL5SaeUsCAMQmkxnU4MqV4ffaNAhD/YQEpLuWUijj+iT6Y3
	ibBrc/i1luplBvQ4XuncVK+pfqcY610J7KP6SR5/GU2jkzV2EcPwJO5uwkgZ8+H2fV40/B
	KTM6c34wrnwFRrZJccppOi++yY9BI14=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-386b553c70eso12447891fa.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773335561; x=1773940361; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mg69a9vrgMcSAwKsm172J4h0Z4L6eK5f2x4mJHkOo+o=;
        b=h8/3IuZcdmKFUncBwmc5vZTpCfRGDfm8S1gAxngGzCY33BNBgI3h/vOp5HevXBq7WB
         7sAojSEbftBtY6hbmDd0nN94GRw4F3AriiXcPjvM68yrBRHigr3/J+P+YGKAsEzfbyeQ
         DZb2Tg3iMrBus09XNfxs4itwZZMEieCiKPzwn93JmfXoGjhWMxPMdpZ2gNGWrh5GGgsp
         c3VQCHwCL0kx8G3vOlhEajhbTgpW8pf89niPlxxwFa0XE9EQPURf6Lo+JcZc0e+0gSJp
         KpgSEzJJ1hZ/ypOvZedrby6j+IpVUeICnSxYOE/1mFezDLSF2Ow/xjL2kEWwLUZmbW5B
         ApDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773335561; x=1773940361;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mg69a9vrgMcSAwKsm172J4h0Z4L6eK5f2x4mJHkOo+o=;
        b=SHzEVGeupAyKmn9NTRxvpXMJkYs5gf3rpLBOtRKO3RltSoaoMWdXgtisro1q/zUiiz
         6xDb27B9F1k2ZhkUZfYpMTq0+u696KKRCvFN4UBt7v7nGebKh5bxHAeIbuWWynfMexFP
         JW7hJv5G4W/L6xnX4mBqAi0y9pUzjxAeTShRyb/4qv1E1ezY5CnZHTxOwjC0vyvhi0Ar
         FPkNhZCNwlrWwBKeGVHRV3O6vhWUb6WMbCJc1+uZRa0MVxyuFajdwYxGA0oWtLBYDfbC
         wUCxpIg5zRwZt59DlidS30goJ+sQoZDgSoyJNGaNoCQPiLmsJvvR8pDl0WMN4pnjuHJM
         r5cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrMe6r/3ypMYK8uEU2PlKEC9a85cLRZWsOPmXGmkThV0lYsMm1c2jcdg/ym+QSY+9xenv1evyKlQ==@kvack.org
X-Gm-Message-State: AOJu0YwalJFbJhAlgxzAcCJ6TqVM9dbQ9fOnl1l93wlx7eEeYWzCXI/9
	JTFEJ/0nslNNAALOPSqijxdYMiz0P+0gCixl7vBG4yRR8DrglZRRW19S
X-Gm-Gg: ATEYQzy03rA+rObm7GS9lXVEuccVMOhzg6BEi8QOvoZNxCe26hOYWCvx5LftR9vUy/l
	Ck45IuqRAxTbfDZfED3nLFe4P65cTnpaRKsDfD3rKbibg2UMlJrGIzHt4baEFkUaxvZIviLuPQC
	82NLJiII0qTKXSc+1JcFvWyQSoW/zg7kfPQPJJeSUQwDey1KnlK/zioeaBaVpN0Z99bvpDIj58Q
	GynK1f6SuxNIX1uHWhKcP6evZf4Omxjik1ETASRz1dcRYA0qPmkoOjgHGo68tgatK+6Jxj7yzdG
	yNiJ1l+jykVeVJW5Ujj03FkQ3c5qXrCvGM+GewlN1zRwbl7LSrq2lZYh4Oi+eCExo3km/JZcd3t
	u6ufvHEiXg7hKuP3Rotrkgz5JODxGFTK9jeKHdf9Y+n2bU2iKF9uG8/G1yC81ahw10UN2KBZrdL
	Qkv+QVd3mcN8kwEGIRhjVF8SP9Gz/WFSvaFuOhwbzaej53ftRuP+IFKaK8ARyZCKzxBxK5rumlN
	+FuWDXVcw==
X-Received: by 2002:a2e:bc92:0:b0:38a:437a:516c with SMTP id 38308e7fff4ca-38a896c3ebcmr233521fa.17.1773335560464;
        Thu, 12 Mar 2026 10:12:40 -0700 (PDT)
Received: from ubuntu.. (static.159.107.27.37.clients.your-server.de. [37.27.107.159])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38a67d6185csm10401921fa.3.2026.03.12.10.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 10:12:39 -0700 (PDT)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v2] lib/idr: fix infinite loop in idr_get_next()
Date: Thu, 12 Mar 2026 17:12:38 +0000
Message-Id: <20260312171238.7961-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 41kn31oyxxrcirzx1m95bm1prxj9um7y
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D17181C000B
X-HE-Tag: 1773335562-924415
X-HE-Meta: U2FsdGVkX19WO6HlHjf17df9M5A4gTcWWRmUVZA8WXkePYsjPvBmSw25dqfvMp7j29WZG+1auMGCj4pmkmAJbMiDsCjzeOFE/uRqBKuW4TuvtuQa08HCeyl8CVItirQ5uzl4O3RFbpQzjFomIl4q1UFZLDHizwC1V3+uRmSZKVishfe663pN1yEGc6neg66ifFL0uJQ9HyDtocbxHUv4VvzcnDD0SyxiCJi2c62GCDc5ZnbBbjm9By1NhMbcIFnlyWPhjAhJdANWreMGAS7FzSEh+C46+/FAZyzXkszgxg7Qm6HhlHmFM2eOCbZ2XlGnUc4ppwDvLwxVyKhEaLHM0ng+FYbXD90wls8HdA4HHaaFWjJGCPGleLrCQtGwpFegQFFRJKBGsV7Jr2o00lGCux9A8DbXThR7Aw1HjsxFRUapZ310vgkgBTTPFs/yiXv2kcUUF3D67oLGLwJxCEtfc9zufYODCKIpytht1yjbhyyiT9P0hG2qtKDJ6q5Z9tsPzsChkTb0sRWI1cA4HaF8Arm2Qa7a/IrlI+fxexY4xmUsLCiQ3r9iAG6eWZ/a/mck+dZMEVhRhnExP5dkkRbA5kfdxkr5r2Qxk+SBJlbv99pwhedTr8xY8k1Ae14GI/744J6NZC6kLcyN6lbv7EoHrEuIPkwoRndAOhd8aU03a/XWSnPCy56wFbs9r+qb7metcmn/PvZKbRzAPE2psTVM3FVPj+WwrGD+37nJzEWJLohzv8/dZ8mOnrIZL+qz+vCN7ZsqMaYmGjEcmwzUOvg4OKuWfI5pJD5jpylu0hOFjLa81i+V3xwhCdLU0oVm5gXrA0aq79GceeZzph/Lu0Odo2WjpVKOw62rcXLZwQCTXjZWIRrhT4aqSoU8vna3/UL3mfVq1pKaRKxrAqbYuyCCId4NMn/1T+rsM9qO/eUOPViwxioPs9wyZwn1eepkVaVUrMVrUcraeehnBrjAdui
 QVNhXbyl
 IDABDP4XQEzIDkZfBhcOnBjABp3PR120bKv42M3oaPcJ83IsKxH+RO+8KsMwMiS/zY2DAdGUh3xMrdc6aOO9xszv4Dkm4IbrndjJBR5VjlfnzU/PndTgWBfO4az1kff4zcOu9j9afimNPnb5lLlLhSLymuSAEAUhnQYK2TvOEhpGKi3B0Mb+J1bzTtSEaIeyi5L68cO0ALGGXSiYxJrqTKFlbiEP67SAHfiIaSx4QhWc79ljws0Awj6knPddGTFfBYbo6qQRBVMLuyaBPgp1grdnreSsdafcLJA/QEhv0Hqf5K40DcWyzANREqUmzhmEFh0NEVCRJg1LcF0DT7YfcTJGFlxFWf8CFdz9I6ouD0LrwbLiLM8v290OJ1DNw6t6XA6XqqdpXw6c+tImYo4w+h+p05fjFMjhS2d8+kNLZ9p3wOwU0OUFVV+xFiXVcCamGKtAhT35/DRehKC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Law <objecting@objecting.org>

In idr_get_next(), if the returned id from idr_get_next_ul() is greater
than INT_MAX, the function issues a warning and returns NULL without
updating the *nextid pointer. This causes a soft lockup for any caller
iterating over an IDR (e.g. via idr_for_each_entry) because they will
receive NULL, fail to advance their index, and repeatedly query the same
state forever.

Fix this by setting *nextid to INT_MAX when the bounds check fails,
ensuring the caller's iteration will terminate.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/idr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/idr.c b/lib/idr.c
index f25bd2b9e9a4..07098eb4ddc3 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -268,8 +268,10 @@ void *idr_get_next(struct idr *idr, int *nextid)
 	unsigned long id = *nextid;
 	void *entry = idr_get_next_ul(idr, &id);
 
-	if (WARN_ON_ONCE(id > INT_MAX))
+	if (WARN_ON_ONCE(id > INT_MAX)) {
+		*nextid = INT_MAX;
 		return NULL;
+	}
 	*nextid = id;
 	return entry;
 }
-- 
2.34.1


