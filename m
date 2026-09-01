Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A1DC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847FA6B009F; Tue,  1 Sep 2026 12:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8A96B00A1; Tue,  1 Sep 2026 12:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673A16B00A2; Tue,  1 Sep 2026 12:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3236F6B009F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:53:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB4FF1C1F01
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:27 +0000 (UTC)
X-FDA: 85165789254.07.7B20393
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id E7E2840009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FzfR2KQG;
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281605;
	b=6nBHFVcqKZrB4MIFcAs/Hdbcdjyr5bv/LyBjMALOp05BSAMUHOudbYsOKIR7h2Pqv+W2+k
	WmFzSs52qYqNxv313Z5vS1MlQRZ2/vPYl1hQDAKCzVoX3JGbbDukSLmUmXrdbYBYtpfmJr
	GMTaNexCIIx96pxToKLnnKP/pyeIRt0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FzfR2KQG;
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c76z+PrPPREZ6S8eX0Uy0ClqkcdAnrOnB8Elz/LsQjk=;
	b=aynQ187T7jr0EhKDhi033eHlDyJ0XCtiTtShDIG8Ccb+tLknG45RjqFqhIDn1Q/Ol3+lf6
	LksRfzY5msnvGYWjU0aWhwk3mupfqt8aLOxmRZ0ojXdy5DYnBq5oCyoiIbGAorVyrrR4q+
	Ygiq1cqHOrvVzKWkB7rclOA7lWEVFfs=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d6fe26ef1cso53073005ad.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788281605; x=1788886405; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c76z+PrPPREZ6S8eX0Uy0ClqkcdAnrOnB8Elz/LsQjk=;
        b=FzfR2KQGUbVf9l1ljvZBqUVXawxQqIr4vU2coYnxHfyXex5QTQxbO3Yo4RNTCJcNUf
         secDRnCCbE2JmWiDN5DX1hoEhaBIroEaFD5k2AlRaTYPRjWLJw/W4W6F/y6/CdzVTWXS
         OCetBsVXuEDqz8yl+JTIBYQBELK76kHOcOPS0YvliKOwHmAxfKz6Ef/DJe9686o2gp/9
         nOxqaLFZzz6JI6GPs6t+60nkekMU4Jl2x1vjPB6SYifUvSHSar44OchNtFbpsgftUaCX
         nwbZXWfDVSuNiDrgBQb+xzeuKXxq7tuR5KusGvS4+GLgIduCRKhg97lxDMnT+Nb+ShQP
         rFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281605; x=1788886405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c76z+PrPPREZ6S8eX0Uy0ClqkcdAnrOnB8Elz/LsQjk=;
        b=qZ+CWavPY8SvaN68jz5yHVogU3De1SU5ZM658Yf46yAJ91fotFCHIxk9LR8TnK9UVR
         A5naG+RstyNh8WiLutExk7H7ojqaDSHKc75lPu6icivYavLR6VHEmxcWvBdWfJVe2q7m
         Esqo5hQezFOzcvlk+XJEMIzFDPhiV7l3sTIDIY8hYBxAj0Qc4gQ4uu+Skj0xa0UmjLyb
         EQdWDlTMR4k79XkS4h19AdsFTPcNJoftOzSTSwxjK35kxGyx4MTsHwJjVR9bnw8y06FN
         mVo3n4KtAQDYNcbTT9VUz7OPKJcZyYkEZPavUBVyB3WYc+mtfYPcy6dUUmXC5CEMc36a
         Zg2Q==
X-Forwarded-Encrypted: i=1; AKwUvBx+wUq0VDOTuLiApPIlyTxT1dICSoBuh85rxxI6rjJ2g8N/DhgHgfbeqMuRwIRI0ffuQmXfC56eaQ==@kvack.org
X-Gm-Message-State: AFuF++kpr5Sa+sWLCq7Boj2JgfAg1pg+byLdSZqs6FrbDyh6DWqEere+
	BrUQHfjKGiTOfnuyTT6RVwEzD23Uolw5SrDQPpAfw5h/3SYIx1vmDvy5
X-Gm-Gg: AYBFou2ehp699uVr0nsFwOPjx3rkGDniML4xEyaFX8dij3TzKflkX6n9lQzgHf4ZJ6e
	M+dYGqaKAAK1eBkHy3LbU4MMS/xXD1hmGK9TYZpRhwoDu4KAwvftElyqdwLkfVFU5P/WFVHxtPK
	M5kzisDacAbeRsxZTr9TqKXwFSjDS/WNLkYVjYLA413A8uB+9mX/CeTWk9kf6SOR6JJcO1WxSmB
	G9L1EVk801x4mZW5S4oAp/7NmpzKKDTUOM7kBduaYSH9gnMhGuazSiWlEfzOvuiPS51DC+kljGS
	rjCVOijEKAOHfyLDcci91G/qETlHdOzATCZDqMp/g0JMzkiyM1Xani2nBGC4DAUVfQHc+yPFK6E
	tRYcrfco6eWKy4XIjd1Felo+BGjMNutvq4pGCedPRTj1T/qo3s/bDDafYV0hUe/r+zPZD0YbAZQ
	gaB6mrkgGzmMbnXEjKFO+RcKUVAVHuAMmEzOT+avGND2dCGHo0jK2XIPU=
X-Received: by 2002:a17:903:3d0f:b0:2d8:d4ce:7e3b with SMTP id d9443c01a7336-2d95d5fc28amr90581935ad.16.1788281604498;
        Tue, 01 Sep 2026 09:53:24 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd357efbsm1762325ad.4.2026.09.01.09.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:53:23 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] percpu: remove unnecessary initialization in pcpu_build_alloc_info()
Date: Wed,  2 Sep 2026 01:53:02 +0900
Message-ID: <20260901165307.1026248-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901165307.1026248-1-ekffu200098@gmail.com>
References: <20260901165307.1026248-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7E2840009
X-Stat-Signature: 589rfafow5jceydfaszdb5f3trfgfnzt
X-HE-Tag: 1788281605-776720
X-HE-Meta: U2FsdGVkX1+TwXldxEgZFE+T3e8K1ywuHMFfzG+QJA1nWIMCYPa+dglCkltsHZAknnTVf1mJ7OBINycO4EPltI29XBRkoKgm/OuPsvmu2eow/nCXyLDbBpiHbR8JM84tSVfV0gNeLUQxzDzesmGZt7XR9Qv8eiNxwivvDElXNKh3DfsynwvYzku8bqDkY0gJqFjgr5jUOqa0gvHUedS0IoIhLzP4k0usXwKyj8hw0ECjm6eWW8nC1BcmvFY9jUdcDuYHszRL3dXNsuLzeDO1+tQunUT7q4+rm56icy+WgpEY2joHqcHq4RJCCuljT1PTnNypnsLoYMvUYwPQvAHm9f4DuF1xHx185EAPuEIUJ0gPoaoNn+tiGaENDtuvfqPzA8dvoFmQaBbTu9OkUUsAUtxHuaoxKQOAeOL1AAA1QC7+jQiTEsLsaSP/aHDhQ99xqIelWbCtCV0rJf7s40DaUbDTt6isc1VRLv65AW8rcc10G/IMkcWkGaaOgIuPtzY28HOF8iiBDTAzXKeS7GTtu4DhwUp8xdbpv20klFVAaYOjBOImsQl+zEbUKF3A4MuKh3F9vANIC4h74+W04hf5qm3wf4s6WaanMn6J3CMdCFq5aiHKLAzdME1oe8sOprBaTxcN4x9GVna3xCqn+/VqwaRIssFEgLz5UoGjnAkQtpFMV85qPngNEyyj1Vw8dFl1v22VWBQGF6PkfHNYQwrv2Fc1EXOlxAMdRABsKOT+bbtzg0LIXfKHXlb6/jAahYflT/Yh/GJprt2MZXy4hqLIt2jvKdkzYEIMEpOjpuj7jqCI20ITtL27pNrUMeIGEADLgAaPOD3F5rwLd0raEvpFnSTAgL9ad6xrcgqtZ8ed+FKBoLMpWjUvAP4PGG4PyvI7ujU0AIgg8Fwg02CW8uPX8+BHb6MzxpvlU3xwMh34BMtg6C4IqrP7vO9WWKpvvZE5Uu4dtsPZDiY7JW6tbZS
 QL+7gymj
 ArOmRwjQ+tysz1rBwvodK6L218ft9vtIBRVaRIZFr3SOYZqaZVjX4VT4Uaw3VPZGADbm2tw9WqME7Ri/LQh34ULYzh1GZ+TTSy4S45tSB111ujyMYSlAMyTsrwTnx4WWsovEtY1+Dxo2HwEksl4JeAsJCgvR9mwvG1KRgFzZpqa+aImylpXcEq9cAUlF5TJ5w2F/Sv+tVpAaROHbjrVaJTP60ONZpnGMIYb1cuBRGVuRT6Wdbr5HzJnqrvhj9CZJZxRkSahr4PHJbLa9LznemPLRtlNI2sj5mCyLnrk+47JrwFaYE/rtTCw3olNnMs3azS/x+hCb9WlbsZqm41Wv7SBB3KNW/WezuNyI23Y993Ut264kNDEBZ9a0nvNULgJpQ5FM41SG4itvqXr9QWEUVNGSr2TNXdGsSmGk/gZkdoM5XPUN7BjBrzLBl4CRJ4EyPDDN4DLUGihTZm/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pcpu_build_alloc_info() initializes nr_groups to 1 and unconditionally
sets it to the number of groups. Nothing uses it in between, so the
initialization has no effect.

Remove unnecessary initialization.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 5700385fe6a4..f222b43cc90a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -2817,7 +2817,7 @@ static struct pcpu_alloc_info * __init __flatten pcpu_build_alloc_info(
 	static int group_cnt[NR_CPUS] __initdata;
 	static struct cpumask mask __initdata;
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	int nr_groups = 1, nr_units = 0;
+	int nr_groups, nr_units = 0;
 	size_t size_sum, min_unit_size, alloc_size;
 	int upa, max_upa, best_upa;	/* units_per_alloc */
 	int last_allocs, group, unit;
-- 
2.43.0


