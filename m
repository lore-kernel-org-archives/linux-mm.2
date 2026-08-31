Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CEE7C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 12:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596CA6B0088; Mon, 31 Aug 2026 08:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521A56B008A; Mon, 31 Aug 2026 08:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB896B008C; Mon, 31 Aug 2026 08:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1365B6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:04:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89B081A04BB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:04:41 +0000 (UTC)
X-FDA: 85161432762.11.0CBF496
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id B3D9A4000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:04:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CaDQ8hxU;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788177879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Qqjdzv2bVxqqJ8KE8jthaL1miiMYy6+r7SugcWAN8g=;
	b=gsJYgkiu5eLX5T88Lhs74+8hR/hZbXfvYTd4LbKX4UO09kU/SJDtesCY9iBvS1AHa7+ZpK
	g/kSKfThD851Ppk+6SsQUWpNPdOLr8EmRkjuT2hUeK329lDnuusYk9tgK6gY/A+81Dx9E2
	Om0kXIkrzddmS8XqGDUHYcckZdYt4ls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788177879;
	b=akakQurvu8OB/FkdRcO5S8nI7NDMXAdwC3INI9NKSbLDWgB4IctP+TfaI8/i0ZnMZlhbii
	3dh92YL14U+Dr64nS39Zq6/3/evsP7soYLCzw6q81arRdabe3/MdIi6587W8gu1fdfKB/o
	Up1o33tCKUYZ6rwz3xo/VDckGF4BbKI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CaDQ8hxU;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d944747d41so3979435ad.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788177878; x=1788782678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Qqjdzv2bVxqqJ8KE8jthaL1miiMYy6+r7SugcWAN8g=;
        b=CaDQ8hxUAdfVyL0FtYwXJVVvPOM+UUoIBnRvlyPUz2A7KNvxXrXNJO4S1fxESYx54w
         eKM0qQMytE/l5/YnmaQnS3C1N/gEuIhK3KFprb/SI2n8kplYneppVhCq18+E0h7tQj4I
         DTNhvsWzWjfS/6RfhyfghdGxODM7vgC7+3hL3fkJ52ZLvLJP8ILkC0NEbJEXMFuA2eai
         gUiK8qFhTidJVYaj2tc2KsDJb3yMHjZ2z5x3qGE8TfovN90q45ykcuEaTj7YPDhZSPec
         9zdXv6yry9c1DZJXN48vpl73GaDRxQcIokWtPouFTSAVMzVDWcxfSACki5370Fd28Zj2
         11CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788177878; x=1788782678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Qqjdzv2bVxqqJ8KE8jthaL1miiMYy6+r7SugcWAN8g=;
        b=dAHCaE4Ps52hTWx5UWI8RLCplcBFWtYQ3QhDZUmmzLVLmqotZgyyudgjtZji+OKxe1
         z7/mu3v9tv6DiYBZG6LQ9tsiNhoP4hxURJ6XGafYdtKnqGYsn1A0j0cra5OqTXbJowFy
         /o9K1hI/m0dlzDNPxHpL2ZJe0uRNvKKr9YrPFdtGY/ANd+wkxv7Eiob9wPlAfi44yL+t
         36rD0gUdjZXHo5jWyu3hvcINpfjfum9Pe/1sjwPRmOGtIQhIY6dUU/tsRD7wq5ZKZ5Rx
         Ev4Gi8D4NRDlDsjA01KU0gL1QZjdbfe98lpk4Xz+1QxtLSiHzhE8BCiiHB9TwzxncwET
         4HKg==
X-Forwarded-Encrypted: i=1; AKwUvBwFSo+ebQHyCxY1Oe2d2RA8JD2L6msyD7fTraR1FmUT3K86eBilJJcdC+j0Ng2WEPP1MKrJ9AWsUA==@kvack.org
X-Gm-Message-State: AFuF++nw5M7UneKkgMhH5ioZAN7YfhgB+jXfW074bTN/ts5DOfi8YteM
	MFiE43BFoL6sLJMSVhUmlArkzsnR69xu9aibUbRxaX17CSj2bxdMfx1A
X-Gm-Gg: AYBFou3lDUcjp7F90tD7wjckfUSpFYTQtyrizmgvi/gRPa+F5qvqERHuF7FASEeyQJo
	rkYRTxEGk0ie5UAkJ2RpYpZe0ELMPAI4ZIccC0PYxpZnt6P5h6vSnCwpUlpaFBYMG77Zxm3uLhl
	pgRW9Bghv449aqD6LAvC6Uc2//M9QMY/1OwEe+PZbJ3lnrmrYxLo0LkL/khRrkTnoBUhqLMRjCC
	Ii3EqXSMW65MZ0DjzKLjhEOjNfV8iJ0xQ3x6FxZw9F/i2XCEQWzMJjCfljbrCsGeP9tE3lkwk/J
	x6TYUNyOQHpj3QXe9VphYxanxmqZlSQfmqfJVqIn0MXLf/IQqH+Dfs6mKpWj46YYpGlcE7ADlfi
	C7DOBGvdtxSIq+WGTwud7yy5VukeXKSwwpbXeEpAmxWiNqc2jspvCkAuAI25EzVUjuxyGTszJYT
	Vodcdfvhpf0A2cbipCx3SznnePC1w+YppTZgBTF1qu0AkxeUY1w48V1zQgdASgUd3wSDlqrCfed
	g4OI0uPENC8q4Mp9GX7tTAawHo0
X-Received: by 2002:a17:903:468b:b0:2d9:2688:8be6 with SMTP id d9443c01a7336-2d926888c80mr78196075ad.19.1788177873305;
        Mon, 31 Aug 2026 05:04:33 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7594fb1absm34371945ad.6.2026.08.31.05.04.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 05:04:32 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com
Subject: Re: [PATCH v2 1/2] mm/mglru: make type fallback logic explicit in isolate_folios()
Date: Mon, 31 Aug 2026 20:04:01 +0800
Message-ID: <20260831120416.32950-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829074204.45304-2-baohua@kernel.org>
References: <20260829074204.45304-1-baohua@kernel.org> <20260829074204.45304-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B3D9A4000B
X-Stat-Signature: z7fqydnp7zejf9z3ftms5f39ciahpe1a
X-HE-Tag: 1788177879-836128
X-HE-Meta: U2FsdGVkX1/wqPyR/hBi8/9CsT9p+qp/XlmloTmVLn575fjKO2T2JqULY1teKAuVuSWtjCAD2rdAew7ibJ0jFd1XsyIVhanQspUpAYD9QYSpo4aR1upVwOFVI4fHDEblYVHPdegNk1er+i/ueCsGtfykkupLxJ7+gFU/gAEh1RjkBxsembM0Cpql9BQ3QwUBaNUeIvd97kX9uED0nO2rtTDb+HCbLQE1qVya32chxl7MU1AkHxyjRWWbRCII+ykAm9ZSrYompHscBThQVxBcXOXH8MBGmrjVN+hbndp38Qs4DQCZWRAj1CeSTpVgTZo2j8AZVyUwzgLHYl+rIKUmiz2iN33l5VFDeTM+mjIDXQHZvMWGXSdToI2W80P7HPZl7gSPIrzJfq/h/hRMfJUztXcnNBSPk2LV67uQmqlhATnjliW595uxCVomyJ7r73jN9OhAxlU59QVShCAUaagvL+6hzV9NQ2wHJBbZWDBezapbv+PUiG3vQj52wODCcSH2bIZeDEH8Ci4Zdck+ZYphh5BNDEGtwM2VImPNt9gqtdYsp+KC2zP4sCyThd/CS3DbvHAeoRtcRZcDzur55DrZLbGm2qAyln9uVFyWKJ8YlusbeYeeDNbrTGK4/WIi0kCzfIt5NsnQ/WGpnMV4u/xguuB1ID+4sctXnfeGJgCgDs5l3Sj2i0L0NjBUhZDxQxRIqHyS3qr5zK2n4EkWp7fU+GQBkQR8hW226vY6Lp4Ne4RVUzzU0PRd9MMuLcKG8dzHF78LFO1Vup7x0EjET8p/EXt/9MosmJBbyadHRUWm19OPsWGLf8QLOKsuIFO6hRbGOqk9zlCWRg/AXoeTFi+S+8/AwSHdT7pPPDYLgStCL1/TG/LnAt1vNQnb2j0xbsQm54c7kju+URBJvWx6TffGnIWCez4sW9YbR1l8i9lirVV83vHtPnfMYpRb+bmFta8aB2v8nWxB4WS+Nh7QzDB
 fGPkdG2/
 p/Xhmy86OUdmd9QNH4VTgiae9OF/wP8bQ8HHkqlhIf7BWwJNiJEP1T/ElKGA6LI6NtcHgk7pGi3+r0R8s4Eil2MnGVDnfFUc96lsi0wTgWp4W9lDU2USFh+DGLwNGgjTbbe0TWoBoiDfT/kBcrGrQESPO8F6P4xIeO3pg7ptc0g4dffYAezM2MVBykTORv2d6d3+b4P6u3NBOCO6UHlXxyyi0MJpHVCuQFxv7gVoTxGvfRS8xshOMogYkfy7ivUxDaXEtAilNMMRUiPK8SF8Ch/7YKyuSLp2MVKDQF+CaeR/UP8f0530gHYJ0bAvjX2SNXVt5He6WgyU/puXAbbqFEo25TxFKvTUpA3Kc6flc/Yer7rCA+v/cCqBTfyFVwczYajMeYMi2ymd9XMz41Flkz0BinlRjS372NCZJPfgDDKfoQFxLFu8ZkhCdlCwe6ZIVGvpAVLhzTVOY17xOMPdfSRzI3QmzewvRc+FBNK81ZurFPG/k5cpqlK297C5RqGqqW0pz9r19rXsjqqehQ2p2oE79r5Hx38kLSr8NlUnVA4gDFpDFB8r4mqlOz5R/3ycuUW1XhoUnTXjcW4VfypxQE4CNbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Make the fallback behavior explicit in the code and remove the
> opaque for_each_evictable_type(i, swappiness).

Looks good to me.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

