Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30FF4C5DF94
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 01:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89756B0095; Fri, 21 Aug 2026 21:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A8F6B009B; Fri, 21 Aug 2026 21:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28EC6B009D; Fri, 21 Aug 2026 21:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B94C6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:42:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1055A402C3
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 01:42:23 +0000 (UTC)
X-FDA: 85127205366.07.C3957E4
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3D97A160003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 01:42:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qyyF9LKs;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787362941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjDQfpDGN2dUsxDWsVsp0pCHr6hky9fJx/+FB+sD/H4=;
	b=7QK3tk6VzyvlA9Cy2bUs74fgOK1isir3kAvRisRLodZvHYMITgIvARK8sa+vwlfyfZZJLR
	J+H7DQs3bwZDEHrsi3Z9fnQe6cHlVBggbf7w87hBazcQpaLoc2w0wXPH5zBqgjRF+I+xJV
	BLZKQp/8PbWEgEVpX5a9O9J/I9t9Ygo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qyyF9LKs;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787362941;
	b=g7bLuOvX7/vU4zepbqVvcdnZNFpS4UPUtYHt9y3fDc2Pog6u0YHlDNP+43+YdoPvIy+q10
	ONkwxCsuBXXxsJThYNMakViDDd5CdX19aQCzTilgJCkjbYcyasbiYgsYqj/5S87wfqTxLN
	qjScuWVXh8UiLYjZzIIC1FwFEQQMjoE=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so1964469a12.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787362940; x=1787967740; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bjDQfpDGN2dUsxDWsVsp0pCHr6hky9fJx/+FB+sD/H4=;
        b=qyyF9LKspBUJfH7IlUqmdb/z4+cpEnhBOaLOZrnz5jNHMgDrI7vpZYiz9RJaa2fxVs
         B+svqZvP84S6CSmnSNTQVadeRsKaHC/Tp/TZjiv4tlfZUktykkfREU4GkiUwrtNWC7Th
         x802mtISEfuPpc8YvS6HxdZ3l2Z5tUrJPX+Ykud6BDmWxNv8oFSq59KLfQk2H/LkUNt+
         8jkMvyO7OITFYIhEEh7XYP7iGjIgmQmtTYYIDxuu9glXzfc2mL6A/EfVlRtyxBLx39/O
         8HPcuX9S/y0osjyHKqSGujKJBTmjWhg7zFWvoCZlKIiz4X6VaTntHkM1UpsrBhzoR7Pe
         yB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787362940; x=1787967740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bjDQfpDGN2dUsxDWsVsp0pCHr6hky9fJx/+FB+sD/H4=;
        b=b4QkR+3IYNNQD1vzpMC5RvwNACvpP4iSUQOL4QaOzu9lFeBr1bEFFZJjomNB6hfe76
         9UJ/eXWRJ3fOt5/mkplF4UaAb+RgCKSOGcKlp5iNQyFellm3GZAmq6wa2WXBJlHVDaMk
         BaZIO8UOA4KJNwISSHooUtwT7t7CG6lWivSelwnnwPHLMDudEM8QinMHLIQ3Wgg8rGuM
         Q8OEpKSMCUXrMnJNduZ4cCwa7REDHxxMpFN5R3A6cxxBV0nuBrdplTtMC9cMk3Oi6tTo
         jYH1beYYO6EjLA0BPIoYk7KiC6ueavqMeiP1DskXFVuVv2IEK25Z5nHDQ3dxGbwpjm5A
         ZOOw==
X-Forwarded-Encrypted: i=1; AHgh+RofaiyPqI5ar6JRJB+70uhN+4H3jhxr9dIwuUnb8Qj4xdKtp2P7kPiNuEvZsek1gmds2pbdSDSCdA==@kvack.org
X-Gm-Message-State: AFuF++nXQ3BGxrMLCQHhcsMsaaW6pupqtq74oLjQEeuIcp7Tm3llvkba
	V5EODBcwIeeZzZ5nygtE5wrlCRsjr0PyHI2JuIxtBoOoEt6jhiVIbuMW
X-Gm-Gg: AR+sD13mygfGAkFHwkz/g/9dG8huMM/kSp/HrUp/I81gQKm7IMWFfCIN2r0Hu82uyTY
	FjbVEsdTUxtI3OrT91ciI5d4V3gbtvaBe1Mb5zzE865ai4Ah7z7OAgzCDY2MkXmBT5pkc0sldD7
	i7ai2K1PQyRvX++PciMSh+c7JIPXb1DXCFYXCUMkMZMZkOaUzyHKzpcVOldPyAdLgW+e6zXHLq/
	IYFkDFyG085u8m/uC+XxG8s4sQIkSmpfxwl1JaKIX07t6UqOwSkjTEadweTrhnIRLxcDadIdhOO
	fHr5/6/I245HfmXgdThaf7rLc5kVjCNL6hc2b0+FLMfhK9ryx1fl+Bz3lXpuXyRQJdeNJm57zSA
	jKUDZsPAwKyz8voF6wrZolzC+vwQKiZi56KDm0dus5jxRe+y8MvKhKgw3YXmBjSxPcUyuRizQYY
	IgZdSbw1/ROLIi4Ykp/MCojzNDC82WRbyaNSLJsffl5V938cUhGN39wV/Gw7Nxri5hGtGhxDkv2
	pmsmC1VWfEzpQ9jgMRtqxKpnA==
X-Received: by 2002:a17:90b:37c5:b0:38e:6d55:b1a6 with SMTP id 98e67ed59e1d1-395c4c35ac3mr9445067a91.3.1787362939908;
        Fri, 21 Aug 2026 18:42:19 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:91ce:4100:89b0:4297:d4e0:bdb6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c8fae7b4sm1500926a91.1.2026.08.21.18.42.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 21 Aug 2026 18:42:19 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Lian Wang <lianux.mm@gmail.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [PATCH 1/6] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
Date: Sat, 22 Aug 2026 09:42:01 +0800
Message-ID: <20260822014208.36934-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821102538.22642-2-baohua@kernel.org>
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3D97A160003
X-Stat-Signature: n8mo5fsq5eoaoqwdwyu3e4f7ur1mbwrh
X-Rspam-User: 
X-HE-Tag: 1787362941-433459
X-HE-Meta: U2FsdGVkX18oJyeArh8AWBr/tmhN+nIWI2nUbhnMfNNO2DC0G27F0AT0BIXZnqdvS9SUk05BIlbTC3yiBWsHxqi6XzR+uXEZZBPDTQRykvVRNmPx7Buub3EZhNiEI7WhyI7odfu1bhzaQ0jCvbBM2ZySCx8E0Wx13n13vD1mvxvMFimxpPQg1HAeQ+mu+WVEyihVIgrPs6WCyzRmOfdr8ngI5uTkLR1zI4H+ZKb3L4yJEOElNf5+2X78xPx/+cab8q0cLr9GqJETf98pAS0sr1ljwqgncqecg+ggqmf2UuuLXixgIwbEucjnm4n7FbY1f2BOpVGbAlxi7T3rfPTXCCysR5w5f+3e2AFVGV8dlpIZM9yZNIueck7SaU+0flISGVr/rYXx0tPed26TgouudOzcdS3w89scF9Qjvg8dKbtAPRDvx4L6y7ZXHD+8yuszeySwjldOLUT4c17unEihEENn25cjfcmYvJAHPt9ie5MHC5u+g2hMYgSmQvhUFqXNaHBoh3RHaEVGZkO1Jm/sfT4wT3N77R0zVHPeuwoxiAHhX3Q2J/LHxRaaEbbHc/8SzKLsUgQe2j9HhDfjbc7pFfddXzWYFbhTgvIf/bW7TSz2s7F4nMwF57CXy5R1qz7ums1plsnw+gr40KvMApunZVGfUtoPq2pwP4wtSuCnHAsAkilBhW+FzZ4TKTEPmN24vUeIfHkx1uiDWEhy7OR90VFq40TaQRQcQc2NCPM5Or0w1vApRjyDKsnHBvhs3Qts5k0x7/AcIIvZ/A+FMiIdlioe7eidLU3ZHdCEMmShgFRhubcxm1KJYNW/iYbJzHvpEmUt3BqbT4FvcQsBtjFtyPGiVWxaouRAQPteDcoMLIS9zeTAaI3jje64Xy8XeuHOmlQyhk25XJwRCByrvh3hokVVs3EQkMYamoGQSzP8ZEVUC9KaM/8pGBAp41CHL5h+/AQbe7di+xgkuKMjpgh
 NR9UVokA
 Ttbh8+EwToAI4wkKo1CEo7NyXFHxWUTpqvl8YTQP9uvMDtc87LXj0AAYAJXaplKKD3vcPvx2sjk/RLUmAlu4Bv7Az0QRhFAkgVQuPaMGAi3cZpkd/ICrN+TmqCevuwDTpLKKEeyvN6ZQInHVB3XfFOXbK1Av1+kd9v53uX+WeEpf+l7au7Pg0eZmZnNXBW+BJMkt+tVSux/2necMFJWc4wErYipaAxv58/UQw6BAfyHFMg/DKYA3uoH98+JfsNAppNjLpjtUoA0CkPqUfqSLNTfaozYnQURbQH+zQxsU/kkf6ldSLEJq5aaxkBLGhRa9AaDqZhNue0HMeJthbwIr7wyzDQ4K2hfMFEmUyD94TjY0eCR0y5JYHQo3ji8SMjrVCoFF+GCRH1e08UN0XUPdH/TqEP1DoeONgkPbWU+yL2Eph1xUwmxhZMYfL4pwy84LX/l8OVc+bPO/Os5YxOj94IBvMINyeBjVviy8JnnNH/G6ffBIcboF/bUgPv+q/UBfwNNV+CIRoCL3RqCiCOFWHfjwlZImu4p3JN0s4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lian Wang <lianux.mm@gmail.com>

Hi Barry,

A small nit:

> +		unsigned long delta = 0;

lrugen->nr_pages is a signed long and is documented as being able to
transiently go negative while reset_batch_size() is pending. Could delta
remain a long as well, so this arithmetic stays signed?

In 2/6, where the declarations are combined, this could be:

	unsigned long protected[MAX_NR_TIERS] = {};
	long delta = 0;

Thanks,
Lian

