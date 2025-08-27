Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98C7CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F9C8E0115; Tue, 26 Aug 2025 22:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F3F8E0105; Tue, 26 Aug 2025 22:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254FE8E0115; Tue, 26 Aug 2025 22:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D84A8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:15:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA5671A040D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:15:27 +0000 (UTC)
X-FDA: 83820920694.12.4832ABD
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF4711C000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:15:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmwTZe4d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756260926; a=rsa-sha256;
	cv=none;
	b=5SMCEvjjcmE8wJjpxMVV4ff0kCJzqojmGffBGGqOC240Q9PExxt36s32x7XI30FzCoB9Dn
	FVGweKmOveOksjlysCPkNZV04SZa3/zBUaSOmNjzkXwwTpOSEGxx5m05+T9vnldXVZqmVK
	oHbfvnKOKm8Bk5uj/z7SGxNtvC31004=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmwTZe4d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756260926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=+RIsayCu3rK+NdzsO4WB51xN7NqrlWVIkSdkGYhjINo=;
	b=t/S0o2n564RyAlWj62i3QC/mkWgSzSiCY3LXYpYDugyi1BkPulhGBMMe6BGuLSIrHSzLaM
	KeYMwJzqUk6YIYSzpyy61wjrrhO0m0/eqsKBgcTTep91P5z+PgS3t/A1obyo8xq1FH+dmK
	+Vc6JZQZ+1Nu17m6314zRE68IGGrlhQ=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7ae31caso1151665366b.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756260924; x=1756865724; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+RIsayCu3rK+NdzsO4WB51xN7NqrlWVIkSdkGYhjINo=;
        b=kmwTZe4diIwyrUd6lQxGf8lgR4PRAP+kUWuE6SeEDTBTDstVxyHTHSXr+RO9HFWSFE
         4oQ3+d99tOFp1GW0RPwyntAglPK5c1OzS/M0r1UbURhialFbTdogTHGMIDjS6ZdITyce
         SBcjGEVVkm3E1OAyFdRFvBXlsTKwJpChg5tnMDYQ4snXXZX8XQt7CsMsQqQgo0Q+Xrap
         AHV7+Lyki/PEmWQgciASsaAKwrjFwlWliTrLMYcZrZt+O88sEoG6+iT3nhWn/SEPr3Vb
         GfA9JbgO54c0c60P0A6CNrUl+U4XmiOnHyL5JmDCiMHfD6Wa29Ia2Dz9kJqny6aQKx2k
         kOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756260924; x=1756865724;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+RIsayCu3rK+NdzsO4WB51xN7NqrlWVIkSdkGYhjINo=;
        b=VfYwnt370aWLUii1hIMVTIT6kxnXSfyCwwTwVyI+kwdh5sFDe/jvKr81l+vJknXP5q
         DfxkVnUPCDBz3RSUihFeTrl4G/brPtnhfPAtWNd6enArzQKbKnQrRB4rBSbR+PQf4/3R
         93Bei5RQcJkElhZTbbkSyo8aBcsdYBcJmWPOridpkdLak7j9xbR/r+0Ei20qlExrjaJb
         6kfMvUdSEK0mR1D891IhCf5CawPcgAL7drHmOX6rgnodWRMpeosnQWL6dZHEGwJs0B+E
         J5pqP6+riUXe1bg03X/SfYb5LO9EFFshoMRxiAedNdt9JTzbyBu6iag1A+W3ZVNXeIyJ
         FIjg==
X-Gm-Message-State: AOJu0Yz1fBmY83XjPh1E7JY0LG5ImxYAr7gEawTqhBXm1ttxpcgLOp0c
	Om1PkB+mvLimAuIczm9GSA/zIxiP+rBEHQtU/hjPzrWtejueYMEy8ds8
X-Gm-Gg: ASbGncvETmQAPTM+40PO9Ch8Ia/dV9AfQXSZ/+LZneQQfeyabTh1EwV72rjco5+weeB
	Nv59rtv9/oOg/E/zsTjrDmrvgQv20zc8gtgz5AaAAgqIwDogv0ehUERcd07vz6ZvF/Kor/IH1n6
	v7LA+JrxZjpOHpp6tsBHhlV/2cPflK7XMgr4zW9fDh08kxuHsUiUoVh6NEDWZvlgce5UfrM+kcv
	jGffAdxpoZsZRpIq+Dr8Qp6Q3OqUSeMtpTezO3yF49wpoU1GNxv/qg4/+c2VkzRu7wEpc1/Tq16
	g8+LKS6lMdkb/JmlaFGftA/WSSSW0283w3FJU7TNnalbo60RVw6ioxhBTTkukpqSqCw9vonMRsR
	tOriLRT9NNhy7X759oci7AqwG1srsHGgdc7YW
X-Google-Smtp-Source: AGHT+IHN5k4Cs/l5U3CUcjIbuJ6dE+EGEtmtKZMTY9FRzNFewSXZKWDVXHWKBLY1vgzpOwC4GNHpKA==
X-Received: by 2002:a17:907:3fa5:b0:afe:c3d3:7a4a with SMTP id a640c23a62f3a-afec3d381e9mr50090966b.42.1756260923999;
        Tue, 26 Aug 2025 19:15:23 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe90c8f85fsm418389666b.8.2025.08.26.19.15.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 19:15:23 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 0/2] mm/pageblock: improve readability of some pageblock handling
Date: Wed, 27 Aug 2025 02:11:19 +0000
Message-Id: <20250827021121.13645-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DF4711C000B
X-Stat-Signature: k9s5mn7fstnnaf7ionxhhqo4eafjbpw9
X-HE-Tag: 1756260925-30519
X-HE-Meta: U2FsdGVkX1/cZy1Y7py+RXfKFjyIdp2H18BW/5efwqcZ8az+TJaw0DlQHL56X+n6P5sdz/ggEAE87rc0/oOWLPGKRXdInA5lNE5fUwg+iknBZJNLjWBhoXCfz8Kcy92pG1dGE8PR+5tQDr4i5Ja+N1Diurgc0jIkE8O9Jrh+2/Puap5KNAUZ2/ef/aMS0z4x9+eyHHTwNjQ4xpfTdruk5LxwA030TxTdMZkVPbZqnRfdQOmsPVAUZKJniOdJUS6Uj4JuttHf80b06THXC1VolvNJOyfrpaa2S5ZnJIl463ginowBsxg20hce0YG/K/RimfpbWkn5kUTClAkikEk+Vyre7t8j+XWS0f3EXCGNjV1eAvzreQq67HUilMIJh1fnKi9m4BaG0Q100aDvWDP5kFRDmzr/okSyzmjY+KSbr97IxgqK4IEqMFQiL0xiU23/issemW5Bi9zYn7Y83rUdKyhxbFDX1zyNzxtINt4otcVjKMJe8kW2GoJEb5fpDfbeN/SRQLd7/jJxBm+zmFdVQhI0KfZpCeupC5KhqspZgGaEEMooa/SP1ivSK0lbYpmHwPJXRYxCObbVjhif7kUYbh3ijtQ531JxVkw+J+xPQFIhiaaApPMyJgXiKWA45ePV2MhOUJIcP7EvgZHiTVtLZP6kYxrz0dc3ot4JlVLSrvC+2yDvUL7aCeS3PpBaYy6KwPWv27Q4asOl7MP9mBnU5XMsRTdiwRnCVF2o36Dc1f4Wlp20JdRyRiSiFlazQqMzteimS6z1F8+F0YBuS0HmjnYV7zoNDSw6dM6h4lPW4JXtatYktRRJME4HVKOyKema9ot/6vB8AEod1PunBAHFUyaT2olJwtD++W0+b8WfJKe8ZRcGNbaQ396fRN+NSJnMOkFwPDYzbGEiYUo43G5dTmHgmk6Rs8o5LE/D8NBTtmzdBVXEyFEUZFEyLyhLD3YdGRfPWhe9OsY/zonqp5w
 +rPwTo3r
 97g/KYoKJBjZ7DxPEUlZiZvxhpUzRR43drtxXuyeNzrBdJCSaOMbkRU1U4Bg373fHGM0T/Dv07Sz8OsYb/vzzmq3wZFC6JNW3Wc58MMdF+SdauhtiEAfjsFaoRhDtlijcnIs11tDqxss0bidFzXA261ZFs8ndJ8w+/OZr+GYWA/8qmJY7pjySwUx3Xooj+4nk8EnWsjMYtO9L6NYjFqjV5m3k5HulqaLODiFYvlyhASb4p36HQWRQeXUUO3E97u29//9LpD4UBxlFUo3yzouCQjHgWn7QwMr+MjQZvDfmMH20cyYAm7zx2TOZcb0balpNcW54DzD8GzL5B43nPi18MfyuUcDRD4mngxk0AK01Vy0+jX8wpzJWCHKYtmELJyeDkAAtDbtPl23uk20l7Ukkx+h3DKLRxsGCr/5OdrUHBtAeNeFkS2Skd7dtT+d6du4NewFoRbbHaEsYpskJ4/4WkKS2WDBgvQxWPrVinDgiGi1x0fjb1pJMvf/x9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During code reading, found two possible points to improve the readability of
pageblock handling.

Patch 1: isolate bit is standalone and there are dedicated helpers. Instead of
check the bit directly, we could use the helper to do it.

Patch 2: remove PB_migratetype_bits and PB_migrate_end to reduce magical
computation.

v1->v2:
    remove PB_migratetype_bits and PB_migrate_end

Wei Yang (2):
  mm/page_alloc: use xxx_pageblock_isolate() for better reading
  mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end

 include/linux/pageblock-flags.h | 12 +++++-------
 mm/page_alloc.c                 | 11 +++++------
 2 files changed, 10 insertions(+), 13 deletions(-)

-- 
2.34.1


