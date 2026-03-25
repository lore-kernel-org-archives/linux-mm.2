Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90DD9103A99F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 02:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2A96B0005; Tue, 24 Mar 2026 22:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3A06B0089; Tue, 24 Mar 2026 22:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892556B008A; Tue, 24 Mar 2026 22:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 777716B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:35:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEF9B1A06B1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:35:44 +0000 (UTC)
X-FDA: 84583019808.12.9E78578
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 15708140008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:35:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OB6Zmb0o;
	spf=pass (imf23.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774406143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/WqiqBCLyiLY/v28qTyeW3QcaRTjQUhA8ri92uqPms=;
	b=Dd9xximhBCMHq0AVTTatMNLoyZII2rhM2dDOp7A+4Ts4Pgi4cNHFdCJj3AiaoybdyGXDz1
	K+w6j+piZOgj2tvQCJyiv1fU5nO9/WoVCHQuuY441Q0VA/JRu7B0UeapUAI+G5f1lAA+gn
	sCSyTkFzVE/vbDtPZ4/SlpbDRMFFsa4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774406143; a=rsa-sha256;
	cv=none;
	b=srs/ZIg7XsPF668DJHHnvmeMA6tebiBq9jVrYvWxUOsrqOjYQKMzLX2Hsnm7kxkMGb1Ong
	Xms39AZmlib8DA/VJxp5KJ+XfqWXPb4bJd5Is/Or35rCHHoGn8ZoqZTvGXZ2+LaEM4Vv+X
	eB4rJa/P0LAW3pE5yCPgBf1wUJj4FQA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OB6Zmb0o;
	spf=pass (imf23.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-486fb439299so50016795e9.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774406141; x=1775010941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/WqiqBCLyiLY/v28qTyeW3QcaRTjQUhA8ri92uqPms=;
        b=OB6Zmb0oh9u902P0zsCNL1S+MDxm87JmusDEl+6b2Tz/ZH/cJAJdvHAhks9mj+n5gt
         mpvF9B7Dnr50Wi9sysimpF8QXvgM7FvSQdvKsa87cSPhNuE842K6//q+Akt1AzVbZZLB
         +9XotW00uQPTvACiIPbcubLqP0xoqh7myqVeIgBaLLJNQmyd495ryIpljSn5eMBZlykv
         lpRhCwJaCJcdoD9yGHEcMwq0bNwWXagyIOvZL0YGURDRT5+ALo88KCTcePQZiUModWcU
         uz6UhYhc+uVIMIPclzFmG+y3rfbJf5rZEeluYUQDYiZy1aXeGHhBmq4dOOQnwBDzWOqX
         0IsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774406141; x=1775010941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e/WqiqBCLyiLY/v28qTyeW3QcaRTjQUhA8ri92uqPms=;
        b=GPOKU2T5MVuWbaZB6rj0IrrdwMKRZDDkBiKPJiwTsP3Om9a8XDgua8BwIuVdqZrpob
         C3BG1FsiBPhSddgG6GFSUo/Rq2zdLz+/TzKO105+aWzDOR/ktDIHv5qal1V+Z/QNTkI2
         P74g08Xgj9CSeUTUIbae69l16DB+aPDX8GyYPvd/3yaivicGB5cGRjEZQDoC1+NGPDoH
         dPXo1klUyNAuWAeEyCvRWlzjsefazuRLgH/17PACvXx17j5T2FDMKzACvTdTaDg45rhg
         XhOBN9pGFvah6qLACF+VoaqqGxxaF+ZI6wVEq3BJsgMRlNLozRTMupE/UfDCKlpIByZG
         0AJw==
X-Forwarded-Encrypted: i=1; AJvYcCVDZwWjZyIFjiemHQsrVvksveB7Yn9aSSsUxb61ezl3O/95LJgPEmWZvZ3liLfoEt7g6Eyny+7+tA==@kvack.org
X-Gm-Message-State: AOJu0Ywc4AOL8u4WwdYFMoAXoTCHt/bXRt2bEiwMnH2dxJw/ONp8OXUj
	rldza7aGzcVR9MQqBQ6Srg+H7QYtEGp0ZASZ0BLroG/EkNyc8/V2xvU7
X-Gm-Gg: ATEYQzxzkq+nuepp2niD70aF5vgxT6vnKW4c/bByR254M7avcrbguCNB4pxB6zNYTXv
	38DpNFrKn9MjmHhte126yUd7e78HNmZbgNiIDejToouN51OSmkjF1H7ftOa9SpammPKMjEZ0COS
	llDohsEr6Zkk+rzYmgm7HyyEyAjbohZde/Qjq3ip0j9DmAhSq9L9Vg98bcaWLKkN7nXEJzfSQNO
	f3SiOzF+1S9SyFsNFD2Cn0uDV5cVWn+DXvgI+X+FKmWD8kMqzTuEBTAjXfJ89a8itxszlLTbjbw
	490HwpoEO7+UKAkfnPWCqQtIrwbJC2SR1yVldFVxdmp14ia316LEC2juHCYI3C4ySw3KA26KvbG
	2WhkD9+uOrWP7yNH4caK8rfsDihoilVqlTa4tW83BnYaRb45aQ1hnp6V5nWEoK9e2hyeAsZkVQL
	ydEA65pI7hVzYcxJVgLXJ/fPIF0gDFfA==
X-Received: by 2002:a05:6000:18a8:b0:439:b440:b8a2 with SMTP id ffacd0b85a97d-43b88a0d156mr2181278f8f.28.1774406141184;
        Tue, 24 Mar 2026 19:35:41 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43b6470f902sm45426571f8f.28.2026.03.24.19.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 19:35:40 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: nphamcs@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	kasong@tencent.com,
	kernel-team@meta.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	riel@surriel.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Date: Wed, 25 Mar 2026 05:35:30 +0300
Message-ID: <20260325023530.222944-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKEwX=MgoPmiFdBQXK_4=XuR-8mVpGr+3Ku2MfjPmHCeuUdGJg@mail.gmail.com>
References: <CAKEwX=MgoPmiFdBQXK_4=XuR-8mVpGr+3Ku2MfjPmHCeuUdGJg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 15708140008
X-Stat-Signature: ne9buhzwxzeb6krq4zbg54kmnmb3xtit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774406142-921117
X-HE-Meta: U2FsdGVkX18AeCnskI8V8B5TtjK0kPgDJEmc0N1vUOrHPWpVo6euNY7lC32rh4ePK4u5OytNVJAjF06+4fJS6Ot5Ms2iaedrdj0hFTcot29DUVoxHVJDF56dpSAoLYdQpM/Xi3EzpGt5kToxMi0RinFtSOTpmUPyeLeDh0TyY6Sa7RZag6z/KWtSBkEUKit/gINI0ZMxKHjhfaF76PQGwLaunxOvnJRDhaMLtrGc/jyI+mcpnQyZotwixaYkhZDik2xlF7doBuKCy1/hYcPtOoZRk9yjeRDhxttNBFog30GNeJyH8mraOk6Imepll8OKeWcqsT58KDvLuG6baF8jKtopskhO+gpVmmSeXipuww7ckh+I1tZPQ4d9SH6p+eUtMP/p2DDykEoq+ERb62fHBy+3JNmOYlNfsb6oLmm2866kAsQOfZHI88pfcYuRrFvQdfwiCJD3kqQ7Jb3TIcOSsAQ6t2yWYpBCEIZoU2CH5yW3mo4xlIoc2MEpBmoMEe8nqFj7EzoKl9WuznwY+k27CMKTshYpGgu6C2zM0nwiB6h4cIH7UgAnUC2PS6nwlVpWwAteyorFSfR41r5al04RaZ/2KMoDrz4RJe4b8GovDhaHUmVuHRoXalTsjoASLIfP0nDvR3rfO2JzdCK1mtcVXmw/HIBhb+VrEhtW8VlKYKxy8jrK1oiCumfsPa4NiztGthRdH0rDKjkTFyjeyvKNmQzkqqeJW0nSCJfSKOw14YRQNPePZ/zbuGscuNBq9vaslHnIPt46JNxaLj9Dd77tAVXVpWTad01ZOcmvHTj05yqYJuy0LoRX7kiMP5b0Aff0/jbV5PER/l2RdR19Jb5lCt4jnu8OIIIn6p1Gadacxwr+LPha65TmpTC3oIeJGmZDsreI4AnnoUX5KbNyNCq9wtnSfJKG75uUUNHJ8GMaI0EP1DkDrrOSxkV4/bLfTdbrTp7hKSoNBfbkzYwc2zn
 AJqAIJug
 0c0+rfXek18ozyqacfgrZdtfdMGViru/aYhA+9s9CdijSVgdn3kgIwD/HRnwyttfVi9TmIBvM2hmIh+VuEETnoV7JszmGjzAhic43pY/1M7hLcN0RLj3ahOO9mnyuys8Pir+AC1Y0aGJAw+SdDlyD+KJ1Rnq6InEA6DRkv7DUIppMoDgxja9CSCM5LfHIU6m3U1jTxk9Tc7pApEVjfkKr871E7Kxl6gPShU1T65xVltzZesVR9xdr4mvNSWKCERceCbSWo6YEsMhMkJzR20Xsh7EAS8vIj4UPkg78T+n1fjtJ3NaSSy2YisEYmjUT0s6wNCAHsrpRxtQBhWVqmna2Mz4yqloABMS47dLXoQzP8sXwuz5mISM8kRV2PsVhs69onduemk+suWg1GZvTcZHh7634LoTjJCeOfc8j0fhO1o2ytAW9BIJ0dFAdgqkcO+NYUoXEW9AJtPzudzB78Ksee9fJrX7HQZH9tzAtKFdY6wVovmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nhat Pham <nphamcs@gmail.com>:
> I'm aware of that work. It's an improvement, but my understanding is:

Thank you for answer!

Also, is it possible to have checksummed swap?

I want to have checksummed swap to be protected from disk bit-rot
(I already have ECC memory, so RAM is protected).

And hibernation image should be protected, too.

I tried to put swap on top of dm-integrity, but this is
incompatible with hibernation in mainline kernel.

-- 
Askar Safin

