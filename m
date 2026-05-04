Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 072DFFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 10:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453E86B0095; Mon,  4 May 2026 06:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405856B0096; Mon,  4 May 2026 06:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BB16B0098; Mon,  4 May 2026 06:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6856B0095
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:06:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D78C16045C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:06:58 +0000 (UTC)
X-FDA: 84729308916.16.A78F716
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id DFC6A180009
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:06:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HR7emr79;
	spf=pass (imf06.hostedemail.com: domain of 3vm_4aQYKCNU7C945I7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--glider.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3vm_4aQYKCNU7C945I7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777889217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lwubHosmT6eACuiU+r3y06IH9ewB9J8y2tHcYLX3hoA=;
	b=XgAPPE6GxX6JmIKGa+sP1sDvZaSLXWDMvidE5xlv3/mREkrywzjYRP32V3ChI9uXKPNFre
	Dv/ZI+aK8GFX+9T4O/7Wq040K/ZHOlTvZHLde4kiXAr236ukxYPHDBAAkSn/Fgn3ihJWmF
	o+nFkDjqycIkREVZRLTDDlW/jlwBDbo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HR7emr79;
	spf=pass (imf06.hostedemail.com: domain of 3vm_4aQYKCNU7C945I7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--glider.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3vm_4aQYKCNU7C945I7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777889217; a=rsa-sha256;
	cv=none;
	b=JaKZkqG6GjdXUda/z57KuQHMVbQflGeW/Oqg3ukqMYUWjIZ+1lYJvJyI0HKqVsreBVDWvB
	Jmg2zqzUaEyUO17d1t1xMxjdOhTGfnQYT7c4jq5+BduaiA+9Bh3EqvyQqj9hmc6rk62xSq
	OuQuDVh3PYlJgLijcZNQ4aO455MSPPU=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d7730e9e3so2154141f8f.2
        for <linux-mm@kvack.org>; Mon, 04 May 2026 03:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777889215; x=1778494015; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lwubHosmT6eACuiU+r3y06IH9ewB9J8y2tHcYLX3hoA=;
        b=HR7emr7998JzfW7mdq/QI85zOJ3II/9TFtiOT33kj6vAUml430DXeRGs+DJGx5HeHH
         zl36IRmDiCgNUjn2JiiqXJ2OM+Fxur6WKUUgJksVl48iw22dUrsthoP2IyC6W8o7DK3q
         ivk/0WtnaekBg0XJawAkSHX8PmhGcNqqg1WLhq2I/9ohlru7N57VRiFmvuv/MCU5Te+V
         OzxrR+LcY4OW/U4fccl1a/qR2TFDdEXkYHsl/6Hu43ctsIs0RPomBjGnarm/wytkfzhw
         Isora+ejUt/ZUgsx1EKRmXs5GsujmUTYuqid1f4dtqUtI9RtXyOmSjJeepUU2oTeRNaS
         bYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777889215; x=1778494015;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwubHosmT6eACuiU+r3y06IH9ewB9J8y2tHcYLX3hoA=;
        b=k26cUfRje76Ytmhshep51jQvvVMAIz5Zdtsnl9fao3iToC8y3PujTxjJ5tpbHgVwzk
         j2kWAQBAdu6bi5eQGKGLu8+Htg6yNLpDjiWn1IlczXwq4pXluhE2aeOQHtScTVMe4Mpu
         OgWeZkiketQBpufD3SpCfdYRd1PtlYrggSjrhcY11FDWG+74ReYKOyNjySOLiMc/V657
         RsiTS3rhx1vY8MdDYG+EFbaqriWsQVRy6Khj25+2KSJOf4n5sSoTEq5CYIOvb2sXjBUg
         TKpmhspxNeVj29fK6va7zxXZi4Aq1Wam6NFAsDmOBxYnlGVwCcmMjJtgmvB+w73eWlhf
         nM6A==
X-Forwarded-Encrypted: i=1; AFNElJ8Jph+gA3G2AqMB6N+Z/8MALQMtm2JS8wlzMxL7+0C2yPyfFFl91oGdcuTSo8xUC+XugAVxe8lMHA==@kvack.org
X-Gm-Message-State: AOJu0YzJJkI9cK9JOPoy/0nUHPzijZr4vKKu/P3yi33cqrL61itE/Fp9
	SWUdYgELrMzI1jJ+2lN99AJDIx4iasHlqLCgw90fvRJNvJRS9Uv0ddXGtzwehWI0nz0Y6zMpnM/
	6+QW0Eg==
X-Received: from wrvh12.prod.google.com ([2002:a5d:548c:0:b0:43c:f3ef:f78])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:430a:b0:43d:1c7a:8b5b
 with SMTP id ffacd0b85a97d-44bb61110b2mr14460626f8f.40.1777889214894; Mon, 04
 May 2026 03:06:54 -0700 (PDT)
Date: Mon,  4 May 2026 12:06:37 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504100637.1535762-1-glider@google.com>
Subject: [PATCH v1] lib/test_meminit: use && for bools
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DFC6A180009
X-Rspam-User: 
X-Stat-Signature: 346mm8psj1cmnsopq4ju3cf61hdjuou1
X-HE-Tag: 1777889216-56427
X-HE-Meta: U2FsdGVkX1/T0dG9Ek7vC+Pe0IFr0kfJPjpnCoWeib4g3AzUuodctVbInY/ulfxOAuYL+7uppJKmJYqMgdnWqkC8+iaCWhKvdS+awTh4LQTFpIjk7jrzGG9xZEGKGm7/O7nnXQwNaVS3xj5uIsFN0kz++RWvzLTprWlNzk3iufqNMjMQgrPFPC5sBlA5r1yd/urCCGWjlACeNRHRJ5rzV7VlzGbuBEx5Q8E5QSfsjDpVUef2AIxEej59m8sgqLjSYZbXcEucX4+1MsdQfySgXJ9GUMozG79ycSllC05beJw/iggoMcuU/1ph4bFSCWlDOXNUVMPnjnYrZufg4xwWGIPysrVhY01ug8vLvg1UGLnAiv3piN9HemlM1iB/RsHeGItw+wmq9vcp0MVliemwI+Ziv9M99zIUb75QUyWkFo/AG5nzDbxYDLyrRleUJAYKdl8J598dZrtXcJWNOcuyhW0VKZlg4cvKvg2bO8zpE42cm3J3AylwY9228EEoRuuTqmnvbnXHdMumi66SYU+E29yZwsaqX+cDEHXYMxbvpBw7dUFpodIoxvW1rp5JWf/q3cefzM6vg8Qb3tzGG9w4e3ouk1q088O/nNrQhwgs3L7ReWUtvUTZY8C7PecJFLVua9Gik4XD84SsVfhX55PPONcBMsu2w46YoeYjmoD1Wvfsbp5tHemYyOsA75rlH+aVIBhznze44FJ/kCXEeN5WXSvAqzT+AgvMlbGDyrFMWMYwGSCdexj3glLH2ZsbkVUeM6nQCxB2aoqbBVec4W5ACMGcFt54C30Gks1tj3kuIPcAOCra+11PuLIc9hwMKMpTpyjXmPXv3ziGSzsrXNboyGjDyDtA9txIx8+ntkdzov5OXPV+i5TZwIL9nxOZx3TdFeOzcaTbynAbou31fF2p5NJcqXVlsgv6We0DaAFaOJWMUFS1R+irI8eRcIcXrVcJ8c8u2vd1QbeLQLks6wj
 Kn3j6Ux7
 JkO1W+7Yr8YpXHTrM14eSOlMcGBvUjnvIEK1eD7s5UKL8j8sWlmGVxxmhlh4Twrxrr+f5D7N17DavFs7jxenU5NUqEYUWzLrVpbPHWfBj9O+EAo3h9rj7OKLmKXzQsB8zX2bzb68e3++ZfWFRrdcFaFX3QX/TbJaS8CZCy3w1n/4lyzI+O2c6BUlx/xoeYoK1AsssHJOuzc42SOWfRPuYfTx1imwLxMlp7TplP74kZxqMJIytRdQIM6jOFchZs+Gjm4om42z2u6PqY0SG93yJx3Rqn3UXR8zEU5VB9tvSFcsML8R+1E4QQQKBDe6UfMayJcw+PjL96UrQZHXzZb7mKSZyzca+a30jIGH5ZiTXxiuy10Pfzvn5ihK4CE8UrO9DKxhYTGZY07wISp7SoRKYcimAy8LFCM/8uvH5RlKJpFDBHZVaho44Zs6G4Y1t7HKtxHbrB8cWKQNVEeVaJ2Cso+mFaa5IlcHnd8xHyHfx1Vu9KKImN3no7xs58VvqcG+OIiLMowpkwrl76HNbRg1/Ep8W9wyrYLMUdx3/upayVukqKAVCNdTFOnjXCGloBZaFDEypgl7mvL7vE4+NaOqHxt/8wV55HZY3jSt0l2LrquXv8/CP3Hm/V30yM8UmJwXKgVR6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As pointed out by Dan Carpenter, test_kmemcache() was using a bitwise AND
on two bools instead of a boolean AND.
Fix this for the sake of code cleanliness.

Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/kernel-janitors/afOcIan1ap9kD26M@stanley.mountain/
Fixes: 5015a300a522 ("lib: introduce test_meminit module")
Signed-off-by: Alexander Potapenko <glider@google.com>
---
 lib/test_meminit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_meminit.c b/lib/test_meminit.c
index 6298f66c964b..d028a6552cd6 100644
--- a/lib/test_meminit.c
+++ b/lib/test_meminit.c
@@ -387,7 +387,7 @@ static int __init test_kmemcache(int *total_failures)
 			ctor = flags & 1;
 			rcu = flags & 2;
 			zero = flags & 4;
-			if (ctor & zero)
+			if (ctor && zero)
 				continue;
 			num_tests += do_kmem_cache_size(size, ctor, rcu, zero,
 							&failures);
-- 
2.54.0.545.g6539524ca2-goog


