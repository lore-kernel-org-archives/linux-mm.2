Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C785CC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 06:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164C66B0093; Wed, 12 Aug 2026 02:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C936B0095; Wed, 12 Aug 2026 02:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A846B0096; Wed, 12 Aug 2026 02:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC5876B0093
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:59:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42935A030D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:33 +0000 (UTC)
X-FDA: 85091716626.04.0431CF8
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F63040005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F81dBYoJ;
	spf=pass (imf11.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786517971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prmr/Jndi+BNbM07sqH6cB8cxDm8c7W6tjC6zXyacuQ=;
	b=75Gat9FgE3ZoRLqBZTBnjZcyUmphMjNDP8vrOJ7xpeYIPtod1M+boeqcNgJiXsuIkQtEDF
	EtXqEaV9bhP/B0CQsq1VNNj+QeeLf4sdQRHzEWXMxAy2TUpplLklaWkOkDUxxY+Z/T3c5k
	cCCmzEy9r/rVJX5HwVpg3pcxekiWUOw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786517971;
	b=r7QAf0ZntM+USZZOsgWEG2MTuMnyRWYA6RsZZ/+lOIecnpnG8hQpDAMwpDLHq7BLI5hyZ8
	QA8lW+sWAR371RnfNYkFcZ2F+TwYKmjh6UKaKkmJ6TJdldjIIvKs1I3DxGTivn5XkzN0aJ
	p96pK333M2a663A2AVajJ9sMW+h6ulE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F81dBYoJ;
	spf=pass (imf11.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f502ff678so64076f8f.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786517970; x=1787122770; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=prmr/Jndi+BNbM07sqH6cB8cxDm8c7W6tjC6zXyacuQ=;
        b=F81dBYoJ7So+l0+5Nj2J8nOboxboA8K9oNnCnyBPQsKMrPKfl6brroZgcXCFKmoqW1
         D7rzewotaiLmhr/aHDf+qmqkSt/u8gBixXNVNhlwk7pQHA0xQjdypt3NsS4aEHw12srS
         OqYkG/aw8QVpgVG6XuVbBqWi5gBRWcCOqeqHhYOLwatao/pM3nkmp+2b6KLZO0v9x6WT
         UEmFSRkUy4puB8FcMOFv969DHMyV2haw/F94dGY5nFg4DlZydj2lXKDkyG+ZXjh1kr8E
         YdVutAR8goaNKhx2+rZgoy6pa3jAJNr74+NG59iEMlOa9yiZBmFoNnBFKnJ9gf3VxjNF
         xJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786517970; x=1787122770;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=prmr/Jndi+BNbM07sqH6cB8cxDm8c7W6tjC6zXyacuQ=;
        b=etHfR7aaKUoFNLTWD8JKkeAyih7JWZq5eaQynRbJtq/mwilZ4VJN6jzfW9S9YtuBiz
         lKS+sn1coxmzsBinQ1XKvzb0cJg69LQ3UNexDCJwoYUpTrMzIkPEsB6Uo1ryg4kRMFWz
         wA0ku9EuRESkGt4kMiFFBm05V//O5ZZ8Qw3lcXS/JBWt1Vcf7C6OrqUrcqBG/vTsHh+I
         Pp5e6iBSO91wJU9GGKySRHk/f+T42IGnC4DQnvY72YM5afuaOCegqFjKPxDTjaN7Haqi
         59JdEF6y9lluovPAYHU+uWwWWgeyKTsPKuSLbDTb1euPB7MXqSaFpKGLB52EXrDYE/s+
         maVQ==
X-Forwarded-Encrypted: i=1; AHgh+RoF305sNhscaXer6chpFNlckDLayPiaLk8e77jvbj4rU6+0IpalpWR7EdDyY9CqInmuDUXviz4whA==@kvack.org
X-Gm-Message-State: AOJu0YzNQY/WedvDkDVRrI51b3wyleBfIRJcWgU2CD/dRTdeylDvP09S
	hw3WsCtjikrJ3pTwg1cuDcL1ZaYD9MsZtJhtVhuQD0sZ353t45RUrt9E
X-Gm-Gg: AR+sD12F4gq3ve7kNOHAUrnzcJ9MF4PIBunHmzx9H+X9MpP+F8o5tfwL9WMtbqs832m
	DNbJaqyC39EI/PADe/y0/+fF6/VI/OqsA1MKkS3wM0WCwwjIEKqrbcvN9aoZrjM5BDha1ccKGy4
	fuefTv4738pBVzGIOJRTZfMhG+DihYd002faLWhFJkFJX6lEznHqN61ty2DWuMBAIGVs+QAjzEb
	h31B+D25sp642quCjri3vIuGVpF4mFEbf+0ZBSk0rRCfhZ6E+gz8TQlhEy2AybF8kyvI0cL+jEa
	dB6wdJ36zSGw2IT3h9WY2+2e6jTIQLsNulF1goBoX4UHD4m21VdZx09TVUu79JEJ30R8sm4m2nM
	MQgqsaDBL81qvFvqUch2ysgxRjvEPSQliLjIcDxWowhXzOfLK7LJJsnnmo42YMYTMlTlkjr4dpo
	eekKMvdl2TvEImL+img5o6D2RchdQbQpogbYflsDyfKbcjsr5/nlOWX6mpdTBtMKKvM7ts/hTXB
	ojVYcWgmlLL9pM2VEqfnW0J0DmM2WMnhGltDm/fdQShlVhkPNZfWVUvac+36X8X23FEf3/VeMo7
	5o/gxSf8MZj8J6T3FqjqvdqeZWM7OqPN4ba+7yD62htgzw==
X-Received: by 2002:a05:600c:4688:b0:498:8e6:d463 with SMTP id 5b1f17b1804b1-4997c0ddd6amr14974525e9.1.1786517969708;
        Tue, 11 Aug 2026 23:59:29 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997b15b807sm73628005e9.7.2026.08.11.23.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 23:59:29 -0700 (PDT)
From: Doehyun Baek <doehyunbaek@gmail.com>
To: Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>
Cc: Doehyun Baek <doehyunbaek@gmail.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 3/7] docs/zh_CN: update DAMON index translation
Date: Wed, 12 Aug 2026 06:59:07 +0000
Message-ID: <20260812065914.3071433-4-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812065914.3071433-1-doehyunbaek@gmail.com>
References: <20260812065914.3071433-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rrypedgzfpjkrf5ta7t9jigt36zoheb3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F63040005
X-HE-Tag: 1786517971-816351
X-HE-Meta: U2FsdGVkX19IfhmJ9roSegTckU3w2we5j2p37oXr7xKlLVkEd0dsdK9ESce2XEXFICC/Hsl0Rce7hLZ8JyhLqG/uo6d1q2VzrBJz0Y9KpAlVNzLiREQOnvRfoW3grI9BjIgp5TMdejfaOyhOk35zgPEizfc4oDPPXkg14dVHrxftgf1kqxXc1BazIQnxvUPtazOEQ4X9vHT845AlByEcGhXqhr334+UCvSolBFbkH/A96kj/pGbfs5Yi0CXWVQ51dH9MAufm+oPKQHfAMxtQT7VTLGHQzOU3iv0LKpsY9yep1ZhBVdvcDq9YpnIxp1dAzHgCitMReMe77nHWAwTnHwnAMgVeVrTg+ICZiKKMydb041AIe9UC88VABTTLLhywumBfTKritv6f3EFvAW0KR8VcIYvqBqnDJIVzSS5PKVq1HVQ9B/uYrv2MFW/iq2/vjaquPZDT0c+QRkCXh/7LDowaSqYlQI26XeQqqkL+p1OgUs0wWtX7QdUtECcqmSLD7fvIqckfFouhbmx/KGQE4PHSEPRyflexR5C9v9Q/WsU7oZOoD86pgqE/dlfdKchR0tvHxk3cbLQv8W74GalElQs9/6D5d65I4CqEKS453p7ZKuiOJ51N7LTfaIJVKREj9ApaaUbglgBK6/ANlMLFuIpP0y6/RwaT4mhSyXsexoVW28bnVU2E2gAx54CSVKYhOVTXrPfcwnJ8VBbUrgA/1oOvywnQNMUCbA/ljkEWG2dh2gyfv2k2jnWldLbiT9HhGxwxI8meyQn20LjQi8m/xSuerKeY7Qv5SH3E637kTXYNnA6R1klbjogxQJYxtadNcC+vsQqlWiDcEo3wnZ8ByFhvuS4vb4q0bZvqJoVfQlGOqLpTxM09FJHa/D1ylsyK4cZQbNyDd+u31oU8/uzGl0WxCSRA4jmPkiG65M58g9D3H7NRozEvrDi2ZiGc1gKQSBZaf3SBUyqEnkfqRhu
 rZDdGkwN
 5MhKt2mqEgF8+Q5ronX+vIZURZ8hkr0E45ScdHTPeGGxNYIGHbMHTd6c4gJIveg6MGdubdslq4wu5pzn3dHYoBRXNEatHqoQvawqVS4k1N8mBlhCN/4jfo+woht4WbMoRthmLxaBAeu1S8R61cH62BD9nuK42EUJh2eITv5JS3xJL8CVPKWoSzVk/vvQrsHZXD1auUPjIYrMYS4kmNPgiES3qLwoiPI6MXqlO17m2eJf54cleGB9gKwPTbdgtM8HE5W7IxmXMVhDNmKFG5D+I3cu3g41FJZ4k9MW2juxsnQ88Xp77GtllgOKGyxebbDqKraY0UyJj6vGCiP1Riv0R56zSlqsDERmWuPCmmmstllakMIhpcCGMEFfOZ67oKZ5Gb3hC66hakb0NNF9HSZa4qlo3+VKRhoj1Y1oJGAHRXTotZxZrsJnqtoQ0g9uAlSZ5lw2B8h0sALL9ggoJEvSM9TuQnIboehMGYX3GP9C8I8cM3uCLIwi2hETaTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the Chinese translation of .../admin-guide/mm/damon/index.rst.

Update the translation through commit c9380cdd949d
("Docs/{admin-guide,mm}/damon: fix DAMON documentation details").

Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
---
 .../zh_CN/admin-guide/mm/damon/index.rst          | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst b/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst
index 6f8676a50b38..77bbfa7c25dc 100644
--- a/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst
+++ b/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst
@@ -9,12 +9,12 @@
 
 :校译:
 
-============
-监测数据访问
-============
+========================================
+DAMON：数据访问监测和访问感知系统操作
+========================================
 
-:doc:`DAMON </mm/damon/index>` 允许轻量级的数据访问监测。使用DAMON，
-用户可以分析他们系统的内存访问模式，并优化它们。
+:doc:`DAMON <../../../mm/damon/index>` 是一个 Linux 内核子系统，用于高效的
+数据访问监测和访问感知系统操作。
 
 .. toctree::
    :maxdepth: 2
@@ -23,7 +23,4 @@
    usage
    reclaim
    lru_sort
-
-
-
-
+   stat
-- 
2.43.0


