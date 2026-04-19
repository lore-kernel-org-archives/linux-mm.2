Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E18EA7197
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 17:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026106B032F; Sun, 19 Apr 2026 13:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19326B0330; Sun, 19 Apr 2026 13:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F586B0331; Sun, 19 Apr 2026 13:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4EFE6B032F
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 13:53:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7F341A078C
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 17:53:51 +0000 (UTC)
X-FDA: 84676053462.09.A2E9FD3
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id DBC3740006
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 17:53:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qiB+uK5U;
	spf=pass (imf12.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776621229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2d/obXVwsuJK8mebPGyct8m80fXGvJ/Dq8NoFS/JJ4=;
	b=yl9ryMFhZ1DH+fUZZJFZZa5eTm2s7XQeauLg4h/XyNzg1sqKecV7tHGTEb0XkU9n0Ffdhy
	DzcBSFtP14+xRpOyxpDzxFjGpADMvaoEaOTbt4eOxx7uwi4yUHvknNt/mBp292b5HqVrYD
	GR3+ORvlgp+eBwtlpkiaTJzPk9SxmLY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776621229; a=rsa-sha256;
	cv=none;
	b=u5iLgXVT9zxEPwMh7svql3WJNKWrH1SwIguSJayA+cD7VFhr8EOyFKPq5vL4zzYUy8DhIO
	LUm4lEGY9CHu0u+G8/bwVzfZwJnWNrKtIUeEEao0nE+LZM9mcy+4nkL3zxJXofI1X5sl8j
	LVoyfq75Lk/6b6IrZC+KymXm9PYeByc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qiB+uK5U;
	spf=pass (imf12.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82f8893bff3so1012987b3a.2
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 10:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776621229; x=1777226029; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2d/obXVwsuJK8mebPGyct8m80fXGvJ/Dq8NoFS/JJ4=;
        b=qiB+uK5UDiBaxBiDTQH63slkF5BSi3M9z/j3RhSmtlsTjieCh2BhUFtZrboCTYRBO3
         2VY0Pm+S6Bg1Asms5dSocMNgy+eTGTS0yruNa5JzMJnu/MO2zXyGk58yRZM1G2FuHuqr
         MEuG3UrBnac9j1LAKu7vuvuJ0lomao3VYW3LY3O7lDFZz5laq7wbdv1FnmsDMvG5BI4v
         QJOGEnnKQyNFIBgvq0fib4j95bIVeHWmuAmMNMEH0Kw51ud/KCKOMC58xbiccMYjUHeG
         lAyRF4zgzjUzA668LfYzcZLervYrP+NQJprJF10ALlHi4SQWnw2gq5KGumiTiya6R0Su
         BUMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776621229; x=1777226029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c2d/obXVwsuJK8mebPGyct8m80fXGvJ/Dq8NoFS/JJ4=;
        b=PJ4l79rb0/zyrHjAXNCmoPwq/K7t2LVnSoJM5Gxc+yrqn1cZswCL3oI3DIeo/ChqC8
         rC+RZ02EGwnZrlQTyjk0aUF7mXLHgLRG6jH1CRCPjyMyrWQwsu/GpxBe6hV4n/MU5Ce1
         oOLiJxmpI7LsM90hrJInpk1l1+x/B4Oz5a38MiUbuvFIj30+CeF77AiQqIheCy+et0Ah
         TNFLXdBjZ4hr9VMrJaUjgBzI4Rzg3jjn9dBRCFnzcHByDdinP1CoTiNRNkaBlIa4JdkN
         f/k/fm9Lnij4CXlvnElNZYlEFsRE0MhmaRwic5iBd6YkxMA3SjVwqJ50OaIdX2AE2yU9
         Rddw==
X-Forwarded-Encrypted: i=1; AFNElJ/IZ+4e2aNZCgCWMOR1ASCxvYkTCxFLnjze799lCIjQCPhW1p4Lki4nvD+GDWaVYQRNRIpTdDmDkQ==@kvack.org
X-Gm-Message-State: AOJu0YxhQLCi+GPKrBtzyiBOspGp9GTriKzwqgJhDAVN4U9Zq1reU3AR
	e+7W67ljIedr9vL2+R/KQl1qS1ukbC8yxVrTY4ACSlnZ4+vYfJsLbcxx
X-Gm-Gg: AeBDietD0C4V5lBCNpQqGuoN/5Cvy9PC0cHaWP4Cootw3xD4kJWdYXWMOlcKlJglGDI
	yjYznQ85MeF7h8HlUVwBScRV72KKtVa0l2THhCE4XaK5/g1NaLjBCHHh2wCg/sN4W7b22eJF+3C
	xsLlzCYND+ynyGECXgKOFCdej9EDhF90G5o5UJoOQ1bP0ZqFFDmNEOpgMj190YO4VuiyinwLekF
	BDvX72u4skBsd0JtOz4t0zpozE4/PeLPF2EN4gYVOA5oaTJfBa6Ru7ws26KClaiZ7cOrA4mhFZO
	IXGkA8DJXut1+VxR2Ki5euftLRJ4r6TnLPte2HwAhGt8WvQwaSV+kUgcYh+bhn8dV07eNdPv4VF
	oljLUIO4iCWmV70sDwd6H1SvZd/XePZuIyGStmuIqcQYeSt1ubXv5zfHUrr6DsoAZmicTElcqyh
	iygDubJu+PTkqdyClt01NVr38PXL7HKxn2xGByQGao6+hK1hmMxiEYvL5r
X-Received: by 2002:a05:6a00:4088:b0:81e:b2ba:5b3a with SMTP id d2e1a72fcca58-82f8c84db9bmr10516298b3a.8.1776621228746;
        Sun, 19 Apr 2026 10:53:48 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.16.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebbcfd7sm9582489b3a.32.2026.04.19.10.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 10:53:48 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	apopple@nvidia.com,
	byungchul@sk.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	nueralspacetech@gmail.com,
	rakie.kim@sk.com,
	sj@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Sun, 19 Apr 2026 23:23:40 +0530
Message-ID: <20260419175340.12241-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <c4355c68-4c23-404e-9368-7120f6467ad4@kernel.org>
References: <c4355c68-4c23-404e-9368-7120f6467ad4@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zd8eciw66gkod8imm6tyzywrcpct8ww9
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBC3740006
X-Rspam-User: 
X-HE-Tag: 1776621229-336573
X-HE-Meta: U2FsdGVkX1+yeUDg1GOF/ytOdED7nzECYTOp+S7+QmivHOIGV1e+m8Wmecf9XOV4uXjtt1uGVxg2/YVTNZORRK5ONfJ1tQQsjxEkQ7NwZ97cZZPxjQLKfv9Fv/uwgkWfZfoyu3IHWgoKwtlpifDOQuGIPPz30AoFB85UwbqMnTlj8EyT6DAJ8iQK6Zvzqe/QSYtI41SFYTDvQkW/l7v/AZXEQc9DrY/f7LVq25c7oW8T3F4rva5w+w1HnxXKQLjRQoX/Tv8hYqaHQPbYmpnfadsVNwcSDaG0Iui/GovCV+nxso/n9WZN2CwbIiDKvkRbrbM8MIAt8Q8OktgQENxNBUO/nJla2CtzBd+e2NB0fL64rmfIefwN7Vwfq6iiV5BEwWMFISLyqmk8kWfdKxig+HMLL8ojQktClypNgU7MBv+R/ElEtGao2PLhQuywurW1HMeNXVmS2lDej7MU3d/brQKkxwxHRnhEHFzxd2t/Sbfl0zy6xEDhWcLgaLnRfGQ61vCgolelAjSXiL7cVfiVKxraXvtKixuu9L9n8kPYxPposI53/SkkzQDzmEemrGyXNrupKeeJh3wuCdSm9n6AnB8YUtOFoVINZQpzfCET21CL8Ns6XNvhGPX5H/ch/pBvLdqxBnKLx2JY3u3NgbVF+KZ5pcTEzkM/rBp90idYbODUXiWscm9ib5bJcsmvzV4srQNcL1I1ujmI/4K7UltIZ5TM2J6KTcL+ghSIKmoK2k8mghK19c7brfAq9CDfkgzMiqZa0H6z3hS0iK4hb71mUbDKqxelhx6hgeEOd5E+iJRFB26AQMFLYC/qmHDQFEYEEUk/n8hOCWHPtRCbmZOMjeNwmFjvXrOmBWGGGht2LYx5DqPg0UT6hinPXiArumpfbOi3rS/gz+0ty/fNZdgwCW3V03VVRlLOrib/pxu7gj1RRMUEeYXYCWBsmZJ8tu1rV9ymSdEvhlZboIZfjLS
 92RSOIsQ
 PfOdu9+L9DpK3raIjKzg3a22hKozwfeegRDns3Xg8pU8zfyChS0WGph/KcKsrukG9VwiD3KBKkI3ZO3uGZyQjF8IKzmHZ8u6BPByyt5YfRQZjV/OmM/qzQ/t8WtPC97n3ZPB5wt1plLtw61DSlXFVBYm0V5B9b5OiLn7n7zyjzwaSdTQYrN1clfiR6fXVoVQK5UFSHrkswq4Zx+Tcu0tHhOXdJn9aVj50AruDCOaKkq2a7mg4PjiRwyOgugB3RsyJ5L1Kl/FTD/eFIQmwXo+DzV/xy9D3JNIB5fNV6VhIS1IBBk6qyFPE0YZMBYLH50qs03zok9I9IM7yXMV7Jfril+jXxcAe1KlWLkqhDC15cYntTT5boJ/LCcMNivm469BIi49Qj6NRIWYxo+nxDMzsNcuG/yKyXqdfv0ETfprVG948JECexStKy9jEScNW8SaGT0DN+v8cdqdU3EZXN5LRqhR8b1pc8HsOHryoaSLp5tOv7U4nOaibls4g6iqozTHX5WYQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

got it. thanks for the pointer. 
Sent the new version of this patch. please check on it.

Thanks,
Sunny Patel

