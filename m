Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDD7CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 00:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827898E0081; Fri, 31 Oct 2025 20:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D79A8E0068; Fri, 31 Oct 2025 20:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6948E0081; Fri, 31 Oct 2025 20:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5822D8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:29:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 158F7160638
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:29:44 +0000 (UTC)
X-FDA: 84060155088.17.D13813F
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6025C18000F
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:29:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yao7fQHw;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761956982; a=rsa-sha256;
	cv=none;
	b=n2hZ6FLfYWv/MsuU/lv8HWdCm2tt4zw+dQOkSZhffsxb29OaroSdkmA7ipuEg1DVj+Vkkw
	rcYyxfDlh6g2OzYqNRp3W1sIr8ZDv7mmZOe1CnyqgJk41RWteVO/CE9y2vowwyQlwjpsc/
	aFFZWNlkQ+dTVAacUozh8OaKDRIVXO8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yao7fQHw;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761956982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=NxxXSWetunOxQeQoUoGFCH62WYnEWyIugpjMuOjNeI8=;
	b=BZSBdyFSGuxzEjxuuPE9jrprVJ71XIy3VASFUrkj0QsGR88Kf3/1VgBke/HCAAqKcnWybp
	2aD5lIqrwLoHo3u1Aw/qDCkTUSBgUShqb3Hpuj9+7O3QS9Q9LQfJAiZMTFEuagovU+x9b/
	Tq0uG6G/oY0aX+63U8cklYtU9gmrx2E=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b704db3686cso609654266b.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761956981; x=1762561781; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NxxXSWetunOxQeQoUoGFCH62WYnEWyIugpjMuOjNeI8=;
        b=Yao7fQHwuTyYC0VgAfllmZ0wlZL7jWSBrrmBEoV3YVll9kETfoD1Qzjn37UBDf3FLk
         0O5iI2eyblVCnGOWK7181O7Cc1ORrgqtcixfhym37a+OhKvwSSpk5kAOfScMHyHIXYCb
         HX383zrSP4O7wCuRykKGeu7SK9J/r9e/bMii1Wm4A4WoVpXLkaxAZ3cKAmoo1f7Do0qW
         NJPNhAwZTcF4LFDx1sNCHyjvEau0unU/xNgg7zcbESC/7cL3VV6SjL+zBx1Uft7mMfo9
         kPy5SGLc1MO0kK+7CAqCxN9HSwDYdhWbSjnpZb6riqtkec18KiQDfIBftXKWutYg2n0E
         MsiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761956981; x=1762561781;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NxxXSWetunOxQeQoUoGFCH62WYnEWyIugpjMuOjNeI8=;
        b=BKTT6ITOS1IyhJ/86T3vQl9zPqvJLfoFksuZzFcYtrZbcrcUIkcbWjZHLmEtko69PV
         Kgt/eERb19xYQ/zD/9tFv/UpbVTiQOjpstegS3lldGmKgeAMNLgVIb85u/CvDVi1PLNr
         8IhPh+H0AhMDor6/pGmk/jeYY2Y1/tsXE7WoJ1Gn6rxrpxRJY3Zt8pATa5BtSc62yYSw
         CEUms3ZbrBT7r5AfS0bUNzO38q/kEOTM97M7CVCcESCS535s4jVg+dliJ74lJwPJoGWr
         iECs51khI4wZUBIj2sRMkgcLREm+1wD3qLo/nyPYH8yBrrN7/HmWyhaZ4OVmDRk2Kuts
         tSng==
X-Gm-Message-State: AOJu0YwMTxiEn/YO8m9IB7b/iiNokF5zl6vYt06vp7n7eXgtb+xKnwM7
	At3KYsFxPA+XasbTKV4EJuc69znuDJoKRRzjyNsYG3cO1JKlSwamMLzY
X-Gm-Gg: ASbGncvW6VP9bTxH5PKRGJIaQqOSCXXZTHQ4HJWL2+3Vz3dyYmYpLXSpMS/LT/A+ptn
	+SexupJi6rECzZoiHMrWgsa34UhX8bCAUdW9M8op7bP+oq78lG0jmIYQ4RCpc1gVJFJDg7+tjEJ
	DcAvRmprSI116S3Bzc+ILTToSFz+xMeg5C346J7d8EEJPvPemgAx74EhPhllmQE+W+oz2gHyegJ
	sm3zNW5j4PIXejHjpFYfWJDzZmhCKymDin1VU6YUIQo7/e07q+F56gewFc9ik2p86diHbpJdNKB
	ULJEqf7A/yjbSdJ9Dpg+SKZvtWlRD0EqnIB9B2rDOsX3yYe9QORrUIMFT+VaHZSH7OXDiBTdoO1
	LNFIAOxYc5uLUHE4ThFLquPlZY0eX2BQdv40BvyzHXVsGteE0FGIMhhgC/wuUd8bqi5ntQbaXLm
	XUWhS2cfsu1Q==
X-Google-Smtp-Source: AGHT+IGEqm16/QRO7h4Ks2BupA4dS7KZLD8+hDU8WcUeMwGDW3sqRTgCa2c7dDbTNzzQXTrBZORE2w==
X-Received: by 2002:a17:907:3f1f:b0:b3f:f207:b754 with SMTP id a640c23a62f3a-b70704c59e8mr584034966b.30.1761956980714;
        Fri, 31 Oct 2025 17:29:40 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077d03206sm320129866b.67.2025.10.31.17.29.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Oct 2025 17:29:40 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 0/2] mm/huge_memory: Modularize and simplify folio splitting paths
Date: Sat,  1 Nov 2025 00:29:25 +0000
Message-Id: <20251101002927.2610-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Stat-Signature: dn5rwekn6z7mr6ra4b9ajf3oifcdubme
X-Rspamd-Queue-Id: 6025C18000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1761956982-902816
X-HE-Meta: U2FsdGVkX1/HvN8BUku0QTg0e9qFQsstAFML9V+diquZlX2zX6d77xnlaB4zgJjsc4aZTRyZRqehPO665DI0yXWZt1j91V+yn96h/fGXX60xrptjWd0xh46p3D5VWpSaG25b+Kdkk9XqxLq/SQgZBoi//58kAwjJL86/9Pl7krRCEJBiEHtYSk0nxZGTv0uk2GyzJcDGTxuQtcSNJmK7ERBpL0KvZBsyvdabhONqufnhHOaQTbaqLy4NoCwaM/9HVkpg586hAixHrVnsMTqAhvEIja11AELuBRdCkj7tLOlnnmeSoiClA1UlmBYshG2FtFmiiPFmoYLfByS0fHpNyjsOU1dhqRZLjXdvg7uXP7GIe0k2oNWkLrVw8bjm2nYuow0W25yJtewb+NMCe+rhV1L1gGPo+sum2t12kj8AeWMZs2yeXBgn7bt5nh5USk01OANYK2w0/UWvGfUx1Q1qUhZMiyRTaqdZnjwjxH4a+gIQ1ug+ulAM2AoPYvxQB7shgGwTrmmewAB3ejKlnlI5CIHtzZvHwRZLVfvUDpFt9fBjslqU2owjSR59YO1WqFy9NaELH8xOaIpiHmU/LMm2VGURLinbLNzOLVajARmTGVtixisefZXdxTBBbepn0rbGu4kple1n11ywWuEsSFm/et4g41d4tCGaAd3RMemmgLfI0lcKoNGE4Dmb12OXUfEjB+fcHS+KCMObNE5GBm7Aux+NySMSPVUL2XRke4ua7IdMnS0vnnQCd/IexHVymw357/ELp1gw9FXx0jqDeByd5graPg4InLkCoFpwlOIAlyeD3wPHH/eNunmhuTzH+PaMhZQN9JhqJ54Te3A8pUKBq26MGIr4ExF4G80hDdrrT2CdU/15R+W5bksONhnBsB8QX00QPN+Cv3/lP5QlUD7b01BFG5gsty5Iqhux8iLVdm1zA1bOw8cdmcBzDt0QRrecL9vXje5UPGusWYpBQgV
 8lGQOzSN
 MGWlWo1BiwEJse3fiPf05CYbaZfia0bwDDUVGpXGqWZWGlN3SK68Mc2aG7HPoT69qzmVFnqbrt1cg23bGejem89bS/+/ngEasRR+UcXJWXp1/h2NF2hcn0qmgXUr/3P1DiEQXwESmcQbbkPe2nJajQX76YKMny2+JbvmiQ9zhjjZAWDqSPYi3RpYB060EFvl2KJh500nmAFjiKYpYePpkWjMm3ly1IRc/WcowkaG/GeYrUE1nCzwdf9TiXOgP9wPkMakDzRajVl/Mo4e+7SoQL0+Wvd2iH1bHxxDl/LxavaiqhCfoJaDDBnvFiCAtz1DDN2AWF+cEGD5AHFHK7mwdE9oiBPWWGVGOjT+/c9XAeCh7slk0cnqoly1rM5fjPu9XOXx1vSLRf4sT0V3ucP1vH74eARkWfc7+VUIqS9ZG3rCtqvXGyR4XU5Eb/kgXU7e1wJEtijpkQ58mb98WEDqIx7NhR8F/XjFkwEtzNIPNk3oJFaYD2LSYYkMi14yk85M9GenJ2w26cFs+R08wZMWiwgosbW9MmvOEjGLTCxfUMzkE7AA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This two-patch series focuses on refactoring the core logic of folio
splitting to improve code structure, clarity, and maintainability.

The first patch introduces a new consolidated helper function that groups
all the required tasks involved in a folio split. The second patch then
leverages this new helper to clearly separate the different execution
paths for uniform and non-uniform splitting, which simplifies
__split_unmapped_folio().

This series sets a better foundation for future optimizations and
maintenance in the huge memory handling code.

Also selftests/split_huge_page_test pass.

Wei Yang (2):
  mm/huge_memory: introduce __split_folio_and_update_stats() to
    consolidate split task
  mm/huge_memory: separate uniform/non uniform split logic in
    __split_unmapped_folio()

 mm/huge_memory.c | 59 +++++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

-- 
2.34.1


