Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2AC2EEB578
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CCB76B0005; Wed, 31 Dec 2025 20:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A2C6B0089; Wed, 31 Dec 2025 20:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C226B008A; Wed, 31 Dec 2025 20:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 565136B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:39:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8CE1CD371
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:39:06 +0000 (UTC)
X-FDA: 84281686692.03.DFE720E
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id EF4244000A
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:39:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=b22JnzHW;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.195 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767231545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NG0PO6/K2629k1zA11E9F2khms6wStcmY/9M8/NoJAA=;
	b=t2Pzzc75Lb0127IvkBeQmqwAaSjJ3XLv+3vSyz/bnE7+cbCLxHrmQRJXllq+9UqbLH/vtl
	ShPm/kVHFqsyDfbSKk9oCKTLxyuBTOGZKDxADkEg/KXbS+kZH5dDMT2WwbTTdnJyotJa20
	BUwJOgl3049j2Mb4BgHjsCjvYa2PLDw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=b22JnzHW;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.195 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767231545; a=rsa-sha256;
	cv=none;
	b=MR9P45eeRqYcCqUP6FkmMl6O46g6XcvbYauMqbZg2rERkcNDgEUHpc36wYJSjDviPOh6xm
	9h+Ubd2F+09cDCg2Ct3/VYb/GVxUCMkExIt4Fk7yP2w5ExjHDRIw2I0QrEFLPzxWEcQjbW
	ItWd2Rpyj5bbXBr7AtpgNft+robdVi0=
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-7d26a7e5639so12703611b3a.1
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767231544; x=1767836344; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NG0PO6/K2629k1zA11E9F2khms6wStcmY/9M8/NoJAA=;
        b=b22JnzHWf7+hgDjh5x5cjxQjShTG3XFqNcn9d+lDKVYR8iRNVplAVPTH1PSWAkpA00
         +R3yZ2a4SLfF0gZVGsR4CI5Y6hpWJvzJRqcv5ENyFfHbobx/XGjARH89mbSOxXy6UAnf
         SnS0eUrC6gPTFrbnQmHDaISLkqMMTp6RI5MU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767231544; x=1767836344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NG0PO6/K2629k1zA11E9F2khms6wStcmY/9M8/NoJAA=;
        b=NpeomuNTb8ON4DNg4TDqUT3+eWuhS5YLjj/cxxb1lnJDPPVYWZlYLLsYvIJfTbIva6
         4u727zOY6DxRSMbWCp+AWN4v4xS+mqIHfSpI7rEdyued+afk4OcBUkxXPRzhMxtmkfuR
         UXkvVDap+NjaEql7ujKDOpYmxLt7KfIk/H6A/a6JO3gVQG6u09IXUXtH+eH/pYtzyywR
         PiytFWQnVZfu/5BairW7t8JolI348MQ9f8Rrg90vg1v3M9skF+z+sI/nRmKFKS/zjanC
         vTZrcf7UOaPf44pDEbuHfk62xi3PhiEbSlhCyHcN0xMrUWancC2/7aQiImlc8T14pLHT
         6QEg==
X-Forwarded-Encrypted: i=1; AJvYcCVC9Y/JB5scYgQdQxUlyzHM7cUOTpLrIHj9LaQK2LXw6+Gcgn+XmUTKiqFFokyJhIMBiJvcGpy6FA==@kvack.org
X-Gm-Message-State: AOJu0Yw1pxwQI8U9YD6NEqfRfV2Jbg/21QaWTSTWrGQUXmxKYp0/TV1D
	jlptqTMNfdQEviQo+iYbvZgzQKHH4USF8qkayoBPpcGEuLKCEBpQEeZE2AdhJDwclQ==
X-Gm-Gg: AY/fxX674usmofuy8Cs+YpeGRNUWKMPrBqaYoUAwuat5e3j37N/X84/w6CK4nxW414w
	BQ5PLx6GMR3zviuZ/9KR70A9WNO0dJWhAZRZa9N6ggVNhn0gkmRHCiA8i5/BPE9ZrJEcv40PPnf
	dG8A6Sffh7JgDz26qeLANDIztOxWoxoC6wCyoVFnWzhu2EdmKLzgjYji4mi9f83Ckobi4pdrMBl
	HbDk435n/nIQLmi7I8Pgc42iUQKrj2b+yfX+XrwIy5brqW4TlM0O/riTxvsypGmpG0Qj6W+QroY
	Sm30dbAXbQxDJyx847ldgkSsgNUBhTopKWwrOyo7l7Rqs8WqxMOHQ4lF6Q4tBMCSlq8XyhUwV7S
	/YgHQs7hy3G1lKFgTnEpE8N0q4zvoHOhYjbDwYgv4607NAYZ8EZNBZ6JDEh3APgXXapNwLQoSGz
	t6s7l+2keLjTh+uEHFY0nKSpHLk9oiV5vRBEHpjRzc80ctnz737vzNeZpiyWYz30IYhtlxMDOBA
	A==
X-Google-Smtp-Source: AGHT+IEWIngAJ1cNKVOTV4KYhK8VAUI0UEvJWKavpyCuFX7fJ/moqAiu6PdiKBIbUOkmL1phY+Jb9Q==
X-Received: by 2002:a05:6a20:a11d:b0:366:1955:e965 with SMTP id adf61e73a8af0-376a7fe2ac7mr34935014637.5.1767231543619;
        Wed, 31 Dec 2025 17:39:03 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:8d7c:8fc4:6773:1d38])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7c14747csm30972091a12.27.2025.12.31.17.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 17:39:02 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [RFC PATCH 0/2] zsmalloc: size-classes chain-length tunings
Date: Thu,  1 Jan 2026 10:38:12 +0900
Message-ID: <20260101013814.2312147-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dyen7857hyd9w34puzfz4yboq3hmjgfq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EF4244000A
X-HE-Tag: 1767231544-436569
X-HE-Meta: U2FsdGVkX1+SZBL7XWpBWaYzu0OC9eeGAt58YmD6tPYjlkrZa9EwrlDMF4YfDdg5LunQXpAPhRNEQaLn3uE+O5eUe+P0Cf3LBVRdjAWT460M7vzQn7Bgkyi+0HkmVCAA5U4xLYjcL/BzWZJtdxM07fzSBMbPuove3eBkbn0mHuYmFCji9AzTqSD1+3kcNrsKTL6K68e2DUJ9utJXPUn84MVaCwT4hVfLry6+0Vbsle6NQ1ac3lW7UhTTvRXyheiA7gJL2VasNR3CJhHsOn4sDO5WcB/zjlcMvc3+h5CF/vxhepWCXxpmSJizZTBG+rznij+2DXdme4kV4z+Ft9auGEaHBFyVUZrs5urLz1kTSIGeITtw0F6TS1TKjhm9h8j7MNcxE5n91oa9t1l24qfqKGXl86nP5h/7SCAYWSQLUJoRXmMXR79PIlz4374ybXyIz4MiJ8xczKZiPZcQ8yPMxjvvVLTDSthYJw8l6y/Dz4erLRVt026f4RP8e94NclJE39b1rIFbcEZ0JbbOvR1ZFpPmlkleZrZd4bsaqerGfG0+l6F8SKZw4feqekXL6WcPUkJeByut0C8xlZ2H4XHrkpjoalIGJvqPz/Zli4nAm1eJdwr02LDDFVKqh1VHVZ9O/HX5Jf4XleFhiso8VIHqyPV8n1comsZWUjrivNakTi+F+WsApJi3YeUL7MNnJJlD2GyIq91MuJZd4SI6lCq2ipISPLHwLk4VB9iOoPJXKrq2/ZwU2AAS2mQ1D48TFUdk0cKTHFcaUcQzxeCZG0ke8MuhSmuPbFenGQh48Jl4w261K+TtxcTCw3/62VPF4kyQtQAY9Od0Q4aXhzCViSboOxMaPHPjvT/8GKssyoj43obTZrS6sH+O5ypimrBAdhnpCNfPDXxIOgHMfWE8lhTp3wJ6yNT0tXBDoNkD+gLxF+m6ayUpOVixbtGJEA+N8kE1V8lZpe/3hH6pDxQlNA/
 aZf8tHR5
 g86M3nw+D/Ogxf9tYEjKmgkTM7Z5DNxpo8oV8tDw7OCbqAAF85pYLCcl1JB8A/LUpz39Z5izvYTKmUXKpRl0Wa+8gqhVzbOFC8Zv5/wPo/zvtMMICzPUDfIiQ4FTaqEkpbvRBAGZlAPfV+6t/bealnLJVvAVnqH4FlvGk/cKnn1aaIgpkQG5uJ6JU0+wijM+Rf/Ei1+ornkgbzB8NDbR8fUlcjZcx3EelFrExwr2Ub222qLbhjCzQSt3NTgeucD6ZcT3CSeLO4SN691KfWTaPAdJ94msJmDqVE+hPFhO64zmf5JNgeSMg3TadTWDmIl+gDSUfzIuqxvThnDE+ryAeFiRfTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC series that follows up on the handling of 16K
PAGE_SIZE discussion [1].

[1] https://lore.kernel.org/linux-mm/fui4gqm6pealaxooz3xv3dnnqxscefyvhw5bhntedwh4tgjvdq@ootmbuoc3dpa

Sergey Senozhatsky (2):
  zsmalloc: drop hard limit on the number of size classes
  zsmalloc: chain-length configuration should consider other metrics

 mm/zsmalloc.c | 48 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

-- 
2.52.0.351.gbe84eed79e-goog


