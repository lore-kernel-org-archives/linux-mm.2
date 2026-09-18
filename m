Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A14C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6AC66B008C; Fri, 18 Sep 2026 12:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A2C6B0093; Fri, 18 Sep 2026 12:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D088E6B0095; Fri, 18 Sep 2026 12:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5C86B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:56:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 933DF160745
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:18 +0000 (UTC)
X-FDA: 85227486036.14.B3E2F38
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA89E40006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uiz4680w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789750576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vlZnDcCseMui9jUINJQcjoCRqZxi7W4Ng1w2zFUjkmM=;
	b=lymnoomuNWS0llWpXa283Gbt8pBbFo0tGDFjZ/5kNhISJvK6mz7yNLnQLInXY3nOo8k9rN
	RYyEzmTiTFoo7xQQ4aECGfVuYkR9zRdCaO4ZNIQWgWdESbgPLRFsVtPKWOPB2Gt03r44jX
	ClYTmYspcYrDf+UaFKQEEkD2vIjwV5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789750576;
	b=I0KSZR3xCs5+BGirgLrlHEQXAiDt0XTHkUCsIL9HPUYNszYsEy4ZKMg4CnvBq9eYBPwaNn
	wjku2oHZ8adnuT9HF6S54TX2WcLbF5BXmp+6oPC33RWWMPDbZ+KgRXkdz/GVyCaCmFqCmv
	vgF82XqgFqM5WvWLqzfUZUzRJLFx+As=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uiz4680w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ec6185so6616675ad.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789750575; x=1790355375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vlZnDcCseMui9jUINJQcjoCRqZxi7W4Ng1w2zFUjkmM=;
        b=Uiz4680wU0I3ueNpxsBKSkD7r754mNJt0E/I8KjnNk7GSiVhBcg1fOnGlN1SOwpWbx
         ErkEJo7NaQUBHduR5u65TTKj+tJIeQlzHbfoxIxhKI+S25IoU+qkZYv0Hcd3+byYaVoC
         9bZQUppMEZ/I5c/d0Ahr7QhLV6m0IfBPMSez/zOFa0cU8r7KJus1EKyEnhTQHlA7aBD0
         fXlMEVbvmHt4AsqMACqJuIIgYQDzUpMKw5YOvYrBNOO+/oBspisUY8dzVlFzWWB+5Ej7
         qEUSwaIoAtqyr7XDwB4z//2PBsOuv1ggRiEtoelyFbXmRgvFcj4QqsuiSWgbR0N8/Ag3
         isTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789750575; x=1790355375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vlZnDcCseMui9jUINJQcjoCRqZxi7W4Ng1w2zFUjkmM=;
        b=ZP4F2X5o6wHsNPYgEEFfFcdZ7XDOEmU9TLLBmvHY6n0yCTFSPjM3363wTIweDD1BnD
         4cbPOQAyIMxlsWwKjV9QRKGAL8ckwLJOSxu2YFcW28MrRDD9M0fNKi+lBvkmf/2u27ig
         QMnPmmg/qmdembLuAsYCK0p5lSVdrrz63ogkWCnMwXsXRyUHYayqrUNbJIgOXA9UsaOb
         jXvl5fKWfY9FP1HCiNUe5pmwxG55byYKuqRsY1rqiFGZrRwjQyazsYyhR14eoHBOTnZ1
         G5lNH4vqfnTgR7ZSyBOVGgKl4IBTVlbF3qC/ACMB1Jq3EEAIlTSd038Myi2Ly4ElFAa6
         XCdQ==
X-Forwarded-Encrypted: i=1; AKwUvBwsVOId+UqJ65XYwT6XEaBBDT4K9dhWjJdIXAHI6mZvy6y3vpUs6A8LGYsPQ3XkuUo/Spl8H3Zjxw==@kvack.org
X-Gm-Message-State: AFuF++l+7olgCSHdIBEZTkjORbQFn5Mx68Dw214PO+rS9/iE10fpeqVL
	1ILzzVG6lNRhx/0NT3TIL+RSwA/DcMfElENN3J8A/84aiuHjScqRwLbu
X-Gm-Gg: AYBFou0P7Vu6TFLR8cwaQ4fzO8g103/wN8b44H6KPBcp5Xp4LGdbhLfZKO1zMM1SE/O
	b5C9oTzFo4Pu2wABnCy2J48jgR/hlAzxJXRiASvCcQBTynkwe3umbvkLIzGz41BFxPa8ZhOMOeU
	mpc4PpMSMINdXqhTo4Mndsg8r7FWLimLT796oJTBcjbDcvzx7CQKhuSbErVSp+BOMcZCjb9yqLw
	64HnnoAHf6nBPwRkoHVfXKgQ/LlAjwAADM4uDH+zadKkxBakMhTskqaRK+lsDaasHCU0wRIfetC
	LBqSHhxYnUgCGjRK6WMHw9sy2TbBC2l6gdKDmtRj3q7sn3geOt2XDHgMXkZC9P4DKV2fyDb4Ubr
	fq0DIwxpuuR6GnOG1z1z5bL8cEDnNdVSmpVDMCHA8gf+wC5l2HJIUKQF21ZqHJIJsfOqSFMM7lm
	BKutjYLAHQvj8jHjGlw1oCIraxZj8VP10HtPibKe9rxQlLBOMZ41/34TYalmN86J99gQ==
X-Received: by 2002:a17:903:3205:b0:2d8:f965:7e48 with SMTP id d9443c01a7336-2ddb1ab3990mr72792395ad.1.1789750575418;
        Fri, 18 Sep 2026 09:56:15 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75bfe10sm11409685ad.64.2026.09.18.09.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:56:15 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 0/2] memcg: remove unused page-based helpers
Date: Sat, 19 Sep 2026 01:55:56 +0900
Message-ID: <20260918165601.1014666-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA89E40006
X-Stat-Signature: fmc5sb6xsuiz1iirfnspx9z5j6bcp3cn
X-HE-Tag: 1789750576-699208
X-HE-Meta: U2FsdGVkX1/OS48R5+xQDkS/8VzzwsgZcBU/BjxgIimX2lNRG1PoPbq6Xy+KUu9l8zHQWBdwzPpDMTjnlcGfw0aHPx0gFQckX5mvpK2cYau2w8t0hQm6iidWMBSr94ySN7ArHwjZ12jDz0TAbONTEsfDX+5/fkopOLAZLlT9/nhUrAhyQlXsryDWz6mm71J6jFABaZxbC95WqyzCi8I46qzdZQkPH65iRXwE0OW0dBFIlISVIKrU94haNrsiWkcskKruGt8ewXhiZA8AMCnAhrXCXIuVxjf5Ekoqn9QVCjsUCC+TeU5Kdq5AUjYFdE03Mh3KhDC6+R7OEqApFhggsWtz4w6jx6TD9e/179IdFHrPlOcWVhbQiAGUCjU3aiTUK48LY9jlFJljNByXr+p/Z47Xd0MkvZlcgr5uMhlvYsE6YVVhebeqO0GWRS6PX/iBDSmcSHcusIul2Yt3vSdQv4hs0LHZBoNWSmgaLBJJEnhQbjKTkwIjYQaykgW44MKl+6oI1c57ZBSpiEfgCQc2WMDwNVM6AOX5j3MPcqri+QKEM3OjKnste6xILtWZOVNP3wTh+O4nygzcXKCTsyCF0SGTvfotFrzlFq837PEZZc5iqGuWXNrrYbuwHvwWici3dIY/oNj/Q+33mbShBEQK1eD5YJ6UzPbeMnNekAMMbP1WloQMp4Vd4+qwVM8wdGtqx3HIQRvLzrBSatoU0GyAfw+Uqtll4OuiVdciCBukUa4Z43fPi06jpu8C4HbnJkY+PodFAE7gyIXBoENjNwNVvmJWduyiFwsc2oSO7bQhsM4+wV0jKlqMappAlpAu0JJwthlPOiL6dvOdthd/RMVSfG2vf0hHwRuRCBbNA/y0Tx0kw2GUwlpyIGoSlBcEIx8CaUnekL9wCR9PKoFPYU2TaRlC6cw+ATpUgiEt30PVo/b+b8MoHqJtIYPt6rDRfg0RifRLDGNkyzeiqRr3aPW
 OKos443O
 wim4nA8gUmzzedZhDgfMND1pzCUJQAy6Zbis+mWS1HZNhHDUm/oMPzm4P8bIm313fsA1+Q6w0Dyvx/CNqLOIGFYVvAE/FFkCfR4vA8VL+KPNuwqMJ/NG70VdSdXOtHOk5Wno/aUjlSzHEHgmSgfiBQ4T+T8JXrfc1g6kBbTEAG9eQv0/3jnGOiCbEa5MbliwwMkdkF+aEqEgx4cLSlA+ffCHvHcD6yhzvP7r7LToMF+vRQiVdLAFit9tjo+KXBoyimVUJcltOugmesNXXcQXLGC2QL7KLdtzyCBazoqgD0VUtj+RDBAjYpKwwlyxYK8iihcdcL/SakIABimsCnjVTctTwfr1ueRh4LfcJ0yVy4xh369+BRclI0CBQ8scH+ugoY7JE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

While reading memcontrol.h, I found two page-based helpers that have
no callers.

No functional change.

Sang-Heon Jeon (2):
  memcg: remove unused page_memcg_check()
  memcg: remove unused mod_memcg_page_state()

 include/linux/memcontrol.h | 32 --------------------------------
 1 file changed, 32 deletions(-)

-- 
2.43.0


