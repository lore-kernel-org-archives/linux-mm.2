Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C637410AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 21:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBBB6B0005; Thu, 26 Mar 2026 17:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC896B0089; Thu, 26 Mar 2026 17:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2746B008A; Thu, 26 Mar 2026 17:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F19A26B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:52:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DC77140DC1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:52:25 +0000 (UTC)
X-FDA: 84589563450.03.B8A1A2F
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD79B20009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:52:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WwpDBL/s";
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774561943; a=rsa-sha256;
	cv=none;
	b=T7sOX1f/+D9vdy4mMFQYW6fFjwYEak6fqAjQUpShOS2QSeVf1tE+U5oggTVM4pXyg97j8O
	LghL2MoAEgUt1ASxno3bhuAtK/IcwtmVnnYGt6FbWzxtuHKqSkFGEQIicnyIfw3QDXy1Jt
	2cE/cJwBRVhQY21dDomx1WVhomJe2QU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774561943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V4oyKzz4b3EA663wVmmHFHX4Wwoa7eaLceNghywXPWg=;
	b=jLUFOQJ/1Sq7FExYuPno3mM0zTIfe3lvQbxq8ae/Nkp63/QXgCZ9JqNO1lVphZfqmjZLFC
	ZZ3p4mYU5ojycVFkPf2vVWkhtTPvSSTggqJndghaZCO+YgZyPDn/DiUe2B0B9N56mUQFKe
	d4+hCaOp8f5aU9iRBfB1IzYz4YzHWA0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WwpDBL/s";
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35c1a131946so1022235a91.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774561943; x=1775166743; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V4oyKzz4b3EA663wVmmHFHX4Wwoa7eaLceNghywXPWg=;
        b=WwpDBL/s+JtUk3O0T9T4Ey0SdJc3mGPg9Sk3X041LmZX7qbdeFZLO8nVx8s86/a61n
         nM1VFC/A7543wRB8A/8MTZSMMgoDrDB74peLwwTRGLy4p4r3JKAt5Ze5GU5cd26jmkmv
         awT2zF49IVA8Qg5xd4WZWCbqhMqtrsQhIrxWhZhVz0fEdYmwanzbj9eKMq64e8slYI5t
         W82jgrdXoIyqvV9r5TDzmbh1oSzoq33EZuMNpXMBHcvtJTtY5utkCXt4ijROsC109cbM
         Ma0zMX6GoBElkemsAoooysVfQ28+tq4v0AHivFVQmGLfbB+OXolq9GzvdW1Xk9mnWOYs
         0WPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774561943; x=1775166743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4oyKzz4b3EA663wVmmHFHX4Wwoa7eaLceNghywXPWg=;
        b=tUyE5ReFAUe8qs4KlA8W4WfaAbJqv0Rz/qN3RQ0OdZSP+J2zRYiZUHNi4kKgSKRvyS
         +ssQNaXgkCig7zP+HNL/mSRTw5YxgeEKM13HlfKLuwlsdpWga5Q+VeeOB65DyU5gGToB
         WtZauJW7QjPnv9JoaDrAKnUaErVyt/WZ1xZX7j/3mBTJCACqiEuBXUGBy+Otv1Ud0A5Y
         qaPOhxamy9IqUqIWdXt9z17sJr5qbrJz+lS0uqQXaOMPLglD9FTVKyHJCAjftB6xb8Mg
         8JOcA49VRBrOOAe4MsrFlTZ1HE8BCSFZrZTPIgDehxkxKJG6MFb3RZroan5HKm8d6qDB
         tXOg==
X-Forwarded-Encrypted: i=1; AJvYcCWSHgAQ4pBr0RrpKXEyANlpNz0Gi0dXOjeoG6KOzgcJllSNt7Cddv3+9aOREKyFuIlE37a//J/3uQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0JAvS7qEXK6kBPtoXuSTCM7Rts8TibOWGhASWnhHNLi0ZND+R
	EORelV17v1uy5RVcBOs+bUwkzWLRNOX29RwhGHYw3owrTYR6iT6RVDYO
X-Gm-Gg: ATEYQzzIujGMVd9n/sgBOUi14PMpmIDMriTggyPKqn0l58b85kARlZHZpb2cwUepsQC
	suDp2GDXjmIfqoWlYher4YM4TT7cFErpkOJkoyaPh65nzn97iSIPwoxX7wrG4Pu/dAtyArP7F/N
	Our5wyh7XJfrnH6wPHf4tiKMouJx97gB329YvYzG+2xW9Ux5yX3Fzhw4pczW6gVN2lzNN0syiiA
	liKLDbQTqYpXwHXz2bpJIINGF29ZU1bMh5NbfnTO6ltrqM/AM7FeVVZMSI0vAAlFm3ZKGGjm9SD
	pVv8ZnjEHJ9bFvRcCesaFXUnH4QSgOBJmghHuQv79aZ0Hx/HrY6lhD/aVYQJDkiYZ6aT0qi2YOP
	iFSoLVFkzKz55/KdxhleK9IYbnQnpSx5NT7tNsPPs8DdoeZIcZjQxwjADMvcINXTdjBLVkgfOYI
	4fnsaezYjBMqcBOrsjEvtqrFEDaFnx
X-Received: by 2002:a17:903:943:b0:2b0:b258:2a57 with SMTP id d9443c01a7336-2b0c4945e09mr29417405ad.27.1774561942665;
        Thu, 26 Mar 2026 14:52:22 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:5d::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc8b5dcbsm38904565ad.57.2026.03.26.14.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 14:52:22 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: jack@suse.cz,
	hch@infradead.org,
	hannes@cmpxchg.org,
	willy@infradead.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/1] mm: reinstate unconditional writeback start in balance_dirty_pages()
Date: Thu, 26 Mar 2026 14:51:26 -0700
Message-ID: <20260326215127.3857682-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD79B20009
X-Stat-Signature: sewabh1468ggmmd8sjmcr497pax54ksr
X-HE-Tag: 1774561943-693253
X-HE-Meta: U2FsdGVkX18u/OKc6DgBXIvMwr9MZpG/E17dODsN7R2btMCIEjSphF4AlUNmZKoC+EV3jZYQfBszjZTw4vbxEWCb4gGZ4bMUCkhXHMybGUHbtJ70i/yjdLbn32yAAendvEn2mb0n+PEGdKILQSufp108yw7tccQx8dMqlsZSYaFCtZhT2jasTaTqxTYFWf/kuGt/hgi3wCd/5STYzlqjNix85u/h7Xv8/V84PQQNES9S/4mXSXB/x7ZohDEqKFxi9gIdo0JL6T5Vl+dm9EDoiZ8iWbj59hJuOqkC2YTAn2qjVIhEzz2gQIurK6gVBu7+nnwhF+t8G/WWa15lz4thK/93UURUyhvdyj8q4OcL5JzjY6Gea5eOI0XKXpr9xwzj7NsQX38bsGgBETj+A2Km3BpVBmqf2Tg5TXvXPRTskJubxwz0Or50JSaPLYQsHjbvalbDp9ixjaJaCy16MzxlM4WaIr7L29SSqa9L3IeUI+GHR0uyT6Poiq04HkRM7FRPfIDGg3CdZT/sRBqkafGIJNP4DiWAaoiMAbffjVkWCjSBPcTpRQfYDUGw38qXrLWQIqt8u7xXz6lxOOpahFpQINaPREdi0ubiUm73nZrUo5LvPy+W4aohWrs+Qk2C1UM20GPLYFZah3L1M8x0ukrG7veMgCR7tca8WXDVbW62x0Z2azu5aDML4wC0uJHd1dUOfw3ATj+97MslbUvMIvPb0zRnVZW75UGSZiS1iKf+bZ1IcS0qB4fa8ArnVPl3Pp0q9XPsaxJ7T8tppSh4aV7XhDtCRUcH+pSTMs/2HxfecgUozP4X47scBsVdmXougVeYnOAwYAo2UMCkv7hrISyX6Z293IvS3ec0uB7rImbNj4S2lEdZRQpWR/fznkwIHhgp5G6uGcI7XdvWAc++qwmVyZSDaf686e7bwd/Yd2XMjxcv061xfuU0xSJKy0w12Ks6K2w4GzmJaljDBcIhfCI
 tz13mDg/
 GpRK1X50XSCsxceXsj2ZFcVZuaQTEDhP68VLTorQeEjJnK9WbhlPmLsf+q0Evr/X7HQ+V2t4n2rPWrdYrCjwgA0JgOpm+H2sBJzQ//SutC97NwLzK8CUZ0QZe04LbbSyubB0eRdgUyDHDiSxM2ioxfo/GBc1U5aHbnvyFLMnjt1JOW4JMLkPoNWFqHu+hf1fHEhsay3q9PrLTdT0j/eK7AHqercQtNfhRlyFtByRB9d55b1Jh3doSikzQF5tmXC+LL0ewbfiK9Hj+uHMJ+boAg7fa5+TwqyzSo7GGvQUWT5c56GGy51gmXhfoZqC83DqzjJBmu2HQonMBpb+l+wa7v6oP3OWJdFni23kH2wk+4RNecBbWKOsOpEQ9EcwM3qs/nP4u8sPRBu3TPGNWYWjWiIjnW+V4I7zMpCVLrlCf5oM4HCKXj/5ulFhnm1gxc/cN8GMSzJOLfi6nBUc7MhxWKPgrUykr2427ErakLMtYWekcSZsT8VVfoXh0uXMRvwGo12yv8TNrYP8zSl4WB51G1UPmSWP7ceyv4ZQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog
--------
v1: https://lore.kernel.org/linux-fsdevel/20260326001337.828947-1-joannelkoong@gmail.com/
v1 -> v2:
* fix it by bringing back the removed logic instead of the strictlimit wb
  check (Jan and Christoph)

Joanne Koong (1):
  mm: reinstate unconditional writeback start in balance_dirty_pages()

 mm/page-writeback.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

-- 
2.52.0


