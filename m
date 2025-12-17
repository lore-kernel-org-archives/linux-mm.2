Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD6ED6554E
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63436B0005; Wed, 17 Dec 2025 06:37:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11236B0089; Wed, 17 Dec 2025 06:37:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2976B008A; Wed, 17 Dec 2025 06:37:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAF756B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:37:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D2E3C0A08
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:37:37 +0000 (UTC)
X-FDA: 84228762954.30.878B220
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D25F4000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:37:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B7m/Ty4B";
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765971455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9b4+cYr7cvDt9qvLnOnt2z2/Es7YZ5eQ7Z+DKxREQg=;
	b=mojlhD5HrHx3ydQgsUHmm9R92v08xh2VxrO4yEJXsl2pRpAl+Rl+J+dv6QE2tGj18w5EM+
	tVoYjiIJn6K6Tx/a7EaZnLMMulKseKXCklyWEqRMC2kh27LhX5uCsjtS3c4JrnOsp2DLjH
	vtDvtI5nujqbqNvMGk6xJULBWOFF8wg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765971455; a=rsa-sha256;
	cv=none;
	b=5B+PRx4Cgl2jWp1gb2Q8Nfuv15UuCNxwhhYyXwneuDujZA8sl3QTXHGmODlXmZ1Vuvp9ak
	gTNzAa5mInzh6Wc+DgoZfOTIIIBnOYQT/UMi1emydv9w25FsGiRYRrbTen0KLnDIVNx6iE
	G44Oo5OxexYxW+OtA1m8ECYneBnXGO8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B7m/Ty4B";
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-598f81d090cso6192340e87.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765971453; x=1766576253; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l9b4+cYr7cvDt9qvLnOnt2z2/Es7YZ5eQ7Z+DKxREQg=;
        b=B7m/Ty4BUkqEFSykCc0nvvgFKI+8/4OP3keEUcASzRdMP/lrSaKIaeeahvDV+gDD8U
         pbPVGzxCQnIqnCodWvPYO5bwG/ugpGFvQTAW4Ry/9yq395RI6J1IxaqbT0AvLwe4jhjA
         BQXo4O3HCY+Il/M93MZNVztlhw+54YtR+J9/41F19Daie1l9mm5daV3ZvqsOBbZi9jkK
         O+EULNPWFtTT5sAgVFu0sWXD0DebECdzElRMPLYptWDRUKrfpZFe/73vJ4DiWZr3CDRs
         q1ABeiDFJuR/JnZohzuNc5XlCqKBZVu64JCHcDe0um9t8/IlrCaoCIqeKV+JHcl5nBNX
         6hYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765971453; x=1766576253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9b4+cYr7cvDt9qvLnOnt2z2/Es7YZ5eQ7Z+DKxREQg=;
        b=G2qqIABGEP6Big68XWyTMLI0yYG+sV19zNTeW7gVewHZXVAlmmDFVjlASf2hqK2k6d
         b41NEsnblWor6M8VqfN2a/XlQi3IWUEoxQ1MgGlqJtPmxdAT6AenpyieU51BoT95gWRZ
         qXnPxed/g5fjIgx7e1Fx7iyql+hmLnS+ZTFrSauPcMZAPFjWCwyb7scB1Ku6W/8DAOQ+
         UUi5KNluSKH3VGu1eqlvK2r87d0wldlnjQaa8dR3zUWm78D6vW+VtFipmsjg/XZOKQd2
         2TzdF482383SsaE+Xp48XBsdMrfiyZFSfkbLQPaeaiw4S2DlK6CnYJ9bTMEA6xJOdub1
         sCqA==
X-Forwarded-Encrypted: i=1; AJvYcCXEr+eZP56cS83ZD1JA9oNPYudua6jNPDyf7APrKBVeiMBcmKVbiPmEUzYSdBuY6gGrNBSE5M0Ecw==@kvack.org
X-Gm-Message-State: AOJu0Yx3YzQWz3yyVr4S1eeKiUa8Atvkinupbg5A3EnfjYrMnI98+gea
	d5ifjz2qJZYByDXEqLez8iCDzlAlwRDQy0voQtZcYKymqIQb9KMz3vVR
X-Gm-Gg: AY/fxX75gDZG41V1REZ1ysIXKwgGcT0YPUqARcT4BVUDShtF+g2wUKcKIlBUdL8Ng5x
	v1Hh9eCx6UvX6M9K9ndVZ0UL5Or2kPdegzI3HxpiIvU+qMT5zKA7jN41TZopBI8FUgl+kV0Hngu
	SsYIbyC4WZCXbcK2XB0p1iWXk4f4sWb6yh6KJtcOHjGvb/RdKfeSrqWJjJX8NlXK76RSj6PXv/h
	Iu0uPDB6BqZvD2HBq6k+2SvXzqpqYAMYRX5/cxn8OnyG0elgoW0CDynjJiIV3VTJVDQGVMuAakS
	UZMxBqL5PzSF4EPDorZHl5pSl8+i/Xl8PK1NjS2OS1TlANgtlTsXpDUDiFc/YcarZ44RNCNaELl
	I10aFvUGcmBrWsOJZSLFeOCbnAp00nIA708ZlDd2FNYqJO1Hv69+U
X-Google-Smtp-Source: AGHT+IFSyQSCjIRU289aflvDrJSZAESLecMFR2iJC+cYh1d6uTRKO2Bvs7pNYMXjYGDNUoF0LbSmHA==
X-Received: by 2002:a05:6512:3f26:b0:594:2db8:312b with SMTP id 2adb3069b0e04-598faa14773mr5892405e87.7.1765971452188;
        Wed, 17 Dec 2025 03:37:32 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5990da5dac1sm2340455e87.67.2025.12.17.03.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 03:37:31 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 17 Dec 2025 12:37:29 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Vishal Moola <vishal.moola@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Message-ID: <aUKV-RZE8QjHQ0PW@milan>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <20251216153604.0c00504223d3fad070f2e803@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216153604.0c00504223d3fad070f2e803@linux-foundation.org>
X-Stat-Signature: s49s8ryywon44j1t1tu74iwwbros7xsy
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D25F4000D
X-Rspam-User: 
X-HE-Tag: 1765971454-26645
X-HE-Meta: U2FsdGVkX1+dF96C7ARQoBPW6CKOVs9f5b9PGM05Afxce+vMJYif6LwVxvJe2jtRvSoBmd475Q873OSwCiTzl0KQ4uS6t9JSMcaaYYtPYxTqWb5f6VFWiJwweaAjTiV1I7EIf5iKqPZLnInE0IVSA9Ndk9srsjJPZ7AVMRjwJuLKTJ4mJSJKY6MsrR2q4uklM5pao5svFqq5v+UcfgBXRVvRqGo31Ge+/PErGCY/3s0WZel3VvJ286IKKhY1tJ8Xun5Ypzn5FJhjW1bqoFZUvEtOy+mc5nlUYryry42BvTP2i7ZBkfTyUGZIU5DLGP8/sz60lS7EPOzF5blAk7NQltCDf/2x2efAx5gBNIbbVwAgRM2gzMbgCv/fbEWPSGWUH0fpoEt+Jhw/Yp4osMVKKQjOal9hUhWuFSJVpJv+DT8jclheSfAF5WMbyaPtPrnrZO2AAUeByZvLNX4P9Hec8Bns9WOK4Rof3W/unYUIu8ZqgRDIvNfY6PT9fkEwvro/KXEf8/chGApD0ByguRitcl+/1lSSssG92hK5YsHS0DUSqitXkbWIq1OPPGTnra3hcCxb/KhAPE5ad/J0mYiz1JjNhmiL3jtSnbL/1KsiDHxiY26RMi4Po5twwYMN+K8+/VPsZzEfnEp6M3Lom6Y6iebuPs6kFkzYY75e+b6qDpgp7XrMG/cn13bKdgz9krBrqoV4l214ZU2hAauDUYnjKXiHuSRQ9ylGKsmaLm2ETV5dIf+d98LI5sxwW4Np5rL+MW1sgNRJWDPJny2v2D1B883W6mco0bjhE3BWuMzAj4ybTXhtnIjecDB7edZccA3oDhUpOkywRQiBwhGeoIUsM+JycfgHmbmHzmzT9uvnRFHDYWQVxqLoGkVnMe460yUt4yOqNkipzkpucBVwvg+Xb05iySESXmBeaFgNnDTpwjaelR0vlD6P9XeMHdfovSkJWj2PFaja5dJ6h40D661
 WgwnX34b
 9YliFYkCWsn6ZUvusf9WVC1oj8QfJqyLbs2lhK9FpkFQG40f14QYQgc35GxcQBH2XX2Bp0uhw9JsePP4upj1pbXw2MqvHqbI8w+L8px1ybhoFDXh3YYp8pTMFIGvDxdhABmZljKdiVzvVxcTg+7BPfMhNjWcMgs5YG4vZeSKVBwFRugC+6hlwnnG2qcQggIahWHoa3jzVAjF0tKolQBtVZKthaDoHbrTWSINzPqOnTG3gFdNKSsvOwsdwugiHRJHvOpX1xtY1GPyYbloLtfR6iAmiYJQfwOYpBnTmd3PtvobMGsH26J15uwUjxYbbw1R55xXPyUd41naakb4QFAEsLsiy575zv4OJ8BwOvhiGJBO9V9wivIVUHgCd+KNTplAX+brVtRRZGDuG50miKd6KL5f6g5kmhj8+RHYYfwJ5QnMoicDSZzJIsQ0wFT2LheWMumSIClCJlI25qLNM1Orc/ioYNK4Kpx4s4JC07IOLJuGOHIbpJTqUBpSSOZkXYGLzIuR45OoNf7mNeqi3iInNnkK93QPkPhXmOKVAc/S5COh72CWn0wND7PonOUhzVUGS/g3oeY8gBvxjz1Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 03:36:04PM -0800, Andrew Morton wrote:
> On Tue, 16 Dec 2025 22:19:21 +0100 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> 
> > Introduce a module parameter to enable or disable the large-order
> > allocation path in vmalloc. High-order allocations are disabled by
> > default so far, but users may explicitly enable them at runtime if
> > desired.
> > 
> > High-order pages allocated for vmalloc are immediately split into
> > order-0 pages and later freed as order-0, which means they do not
> > feed the per-CPU page caches. As a result, high-order attempts tend
> > to bypass the PCP fastpath and fall back to the buddy allocator that
> > can affect performance.
> > 
> > However, when the PCP caches are empty, high-order allocations may
> > show better performance characteristics especially for larger
> > allocation requests.
> > 
> > Since the best strategy is workload-dependent, this patch adds a
> > parameter letting users to choose whether vmalloc should try
> > high-order allocations or stay strictly on the order-0 fastpath.
> > 
> > ...
> >
> > +module_param(attempt_larger_order_alloc, int, 0644);
> 
> We should have user docs, please.  Probably in kernel-parameters.txt.
>
Thanks. I will add it.

--
Uladzislau Rezki

