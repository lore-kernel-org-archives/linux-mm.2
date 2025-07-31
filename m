Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A08C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 18:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2DF6B0092; Thu, 31 Jul 2025 14:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8746D6B0093; Thu, 31 Jul 2025 14:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78BBC6B0095; Thu, 31 Jul 2025 14:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 690336B0092
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:16:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 132D3160A09
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:16:37 +0000 (UTC)
X-FDA: 83725365234.06.F3177B1
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 861E240005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:16:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=FfMV7HvZ;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.217.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753985795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNycq62jXW8tjjm44f5hhjhcd4tsXOjyfLo6mreDnWc=;
	b=Yd1mO67k0MLXUW0WaBx6abTKhgeFw4AjtEdcM3unXAzNCf8xuyuPhDICX46a2x0gH/lJhO
	0ZC3fqmqhbH1u0gbVM8S9QNYpW6c7URubS/mTdFetJ9Mp3Kl/DxG0+MqHt+rySe+9ZfJNA
	N7724MiD09uXtCCAigIVHAZ7YL7tNgY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753985795; a=rsa-sha256;
	cv=none;
	b=7b+ujStlxoCTgmPYS4g85s6o9g/skYyDIrITmOXGWbRppruZ/Y9JjQYj5vhnFuiTnetY5q
	EguouBCDqYhikrBxujMrwnxguEkkC6MztDxVloiDp//sB9OWv+W0QKUwiUUb7yL0z1/km9
	HGEM1iawUy70uhM0Y3fWhFt+9uZocdU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=FfMV7HvZ;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.217.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4e9c8a2026bso187991137.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1753985792; x=1754590592; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zNycq62jXW8tjjm44f5hhjhcd4tsXOjyfLo6mreDnWc=;
        b=FfMV7HvZ2PUwTC/pk+oovoEnTIoaXfLZ+PgPTK/bbcFLvpLGJI5Lctn73n10qnvDoU
         u97pRpC4aUZEZZLNcSQjUfljSqSgVgYQWjjppb9hW/zcvyf4ZW2O6ZIsFEeWbFYiPTU3
         yJo/YVlQh6C41GuQbuX48MCm0U6ZpEjFVxV9cTzHd3uy0W+a0+837yY3Jhh1zSaCLwW5
         /tmev5+vODtmQSu/vBL2S0aqzhMIr/y0f+uMnnwYmtpC3nPh6yvtngHAvQHZBqWpVYfk
         FLYH6LzUwcPY79YB96lUbzgfnk4sGBNwpiSUHmGno9Krjui0sP4GF3uBUh2BqGVUlHQU
         rJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753985792; x=1754590592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNycq62jXW8tjjm44f5hhjhcd4tsXOjyfLo6mreDnWc=;
        b=vNOUp9v3cP1o0QlOd0UDizfGSV/AM2yMCYZlRmvXPeGYlJKRSmfN032bWgyJdJX8MW
         GmWYh3rft09ouZEN2rRqpMjwE7Cd71/ZbPFnXljOgSCWla7hisSgcUf43g60p+p7RhSa
         cLX8tRfOXR4BTfx+j9ri6AAxcHmHYzc6v1ViPJ9I9BMxLcQaAriEbqDdUISPtAvvkqYW
         UFQxjo/wje8j/KyOGFQaCkHmMydRa0gf79yWwEs/QxXtjClCbT8jX5DbmPpCvqFfiGnv
         iEVNR6GhOjZ95D9PQsw/5InFbv9TSdpUGuZNhtQl46hM3JXnPWnlpNty7+6SpwPGekUC
         9JPg==
X-Forwarded-Encrypted: i=1; AJvYcCU/BZ6TPYaEQQZtEdS5Ojgd07SoEqt4VTKkW2mEHHBddwqsfu7rkw8Ydx3kpRIgCu1aS+JGbRLQsg==@kvack.org
X-Gm-Message-State: AOJu0Yy0Ynd2Lds5UpH2bBLLJHiNVHKjW/QV69FBJEo44bL9CjWt8rbU
	v6R8I3sdeSGJeh7r+yX1Pk3SMJSt/40BlXLFkrCYtAGOp22jtQ0PEAdKPsgWZCP/1DU=
X-Gm-Gg: ASbGncs9jdEfzs7ddXNM1uZfbZ+PP0TcWzrMc1PMhuF4JN5h2V9lm2Ynp+MjmAGKtYs
	SQElTSF1M5x1rr+4CVQsg+3tsV7+V+gCxL/nh/CSCcibh4GO4OQ7HIHR0Q/XHH5nNQoLcvg+SBQ
	JxjNio5EZGTZ5T1+Vq/aOvU1M/+QjEtgnquLJ1SfEc9I/IVwyXObhts3Ip7MpY0aL/JbGKCOna+
	XB6hq7iD32jOE49Pv2jvJ/XshJyHyb6IH63D43oX1GyBERCnaDVMHFakW5NUVForJJ6RZL+Npii
	J9JEqSpklI0oUPVYX9JvoygiClE4FK+DXvAx4AqysjFEj3g/a1Y0Q3eDHVJqSoEfoS8rtkGyZxs
	Pbi5Z07PFEPkICs1Q7FW4FEto/SyP6vQ3
X-Google-Smtp-Source: AGHT+IGiF90gF2ac/IfeIfowe0tuCQyzVITlmCw/gArMykn5Hp8a2pCzf2lGGHyC9wsGOMaX2cNeJg==
X-Received: by 2002:a05:6102:3c81:b0:4fb:dd65:b97f with SMTP id ada2fe7eead31-4fbe87dd1aamr6014065137.23.1753985792451;
        Thu, 31 Jul 2025 11:16:32 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-7077cd69b86sm10763916d6.42.2025.07.31.11.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 11:16:31 -0700 (PDT)
Date: Thu, 31 Jul 2025 14:16:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Takero Funaki <flintglass@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/zswap: store compression failed page as-is
Message-ID: <20250731181630.GB1055539@cmpxchg.org>
References: <20250731152701.GA1055539@cmpxchg.org>
 <20250731170922.15509-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731170922.15509-1-sj@kernel.org>
X-Rspamd-Queue-Id: 861E240005
X-Stat-Signature: u9me4odd6hphnchnhzquq8mk8qpsm4i5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753985793-150306
X-HE-Meta: U2FsdGVkX1/m7SX799CUI5q3kKYoJOT1hHjs+sWYpuCRCo+tt/jV0YXvCTzV/8Zfyh0p6hPacgizbb93BBTuzpq2guQnt8Me+3sc3q8AvsjeqMjtbyYkVim5JUGVjvU1SBOuWMT6tKhrRYU516QlkfKvyZ18nKdcs6YFEQyANR5aXd8R1iQIKbfU2a34NM4RNcLbLRy8KS7ObVYsixUTn1NuUmaJQppIMlCNPemluAddj4Gk+e5LvbOOFXdk9lZTKEJwOG/5gpRdOwxr8b9mIGMQGJJ43dJZCou11WlXqZQ7IbZWcO/44luICcVquE8V5iOeBeZTNUZMi9wUOqkx3txO1eW9rfnh6cjmM8n+DiOJSODq87L8I2z8dXqHNN8D4Hs+cQQlgkTKcY3UzDlR2fAVcV+irQNlAqfZG7wSNm8YSVhVwZ5+2e3VwkIn+5mU6esKY4DWOLS2vF68SVmEi2m1CNp0p7TJyJNyK14bmB6gG1R71u1zj0EHlT/CgTWogPbe6L5xixQ5aVpJsqn3l4Yy7cqv6qMf+o+Pvy431H7EV29kjUwGw/Yy20VcDAT9V0UVGanqffYtNlsXRIQtP+Dv/Rd+43SIxNZurqklM7oJCqkDcd5s0fPPO7b0RhTJblTBDPcbWTIF2xiCS1SEqOU2D3ZMJeutCpbr8HHL3B1/UENJEIl/xN4g0Ff3qcWakjxm1B03atxHPeO5hez/H866fQhba9PSJq9o6R7Z2e4CYpLCcuaCJIexx6MZ6+ULFmkeYfRC7FAf9zIwHuXZQJ8zP0KOfKd8m/fOAfMCLj2vEbdCgp5vFo4/3GwhL/8mqee3Vsgk8ln3ZzwPB7lU9N/iTuGYAlL1picnoKMfSMnrwkqNItCKxrHhUS3X3DGXiuE/zRAG7gV4ANE2HyyqVXszymfohRSHAuY2ylrrzIxlcK1W6tQ1NcRK4zdgGKalGQQeRDt7b3lj1fKH/ep
 UM9lRnVV
 RFZwhRu5BraLaHGjcw8XWpBNIa+7ri3NWCFnPDpxyYMOlcSFw+7j+dvBM8iFEtS7GC3M8hX0Ud/AMW3Zh+u9cRz7PlAm4st20qZdS8BS1PJkHnAfBLNJ1VmDKKDSj+CAX0I7ybnpTRTuzI6FcMjCDcH+2Y0QB4ncrNzakJKooRSPpwd5ueKcB+Dxinazd0tEOqdK98VHw8d2mj3pBxMUongmBbv6NGPSkiZMiD4XwhvB2+BAN4cjkMLqE8Y9sE+Z9SJ87Z+zc7uk6qgrncM7Pmp9cCOzGH9+9fXthr1pfDoKIBS4+0UUyNnh849IheRxKvdgZCs47L8chOi5LOF0QDLn2kDZ+hGKBbl6kJ+ThJ86xCh86un7MZpfxQXBophwMIHB1TB8BKCRMtzYpWXE/gw2JDWjuEBn3MuNtrT/HpbkEN9LYDh8huYCmtifPTxqoggdODjdogrHNAQrQD9qWPEhI8+9zyOz710gj7l2NKuoCWMqbDPGTnijS5346gQ9qL+KsRnTFBsMj7tg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 10:09:22AM -0700, SeongJae Park wrote:
> On Thu, 31 Jul 2025 11:27:01 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > So if compression fails, still do zpool_malloc(), but for PAGE_SIZE
> > and copy over the uncompressed page contents.
> > 
> > struct zswap_entry has a hole after bool referenced, so you can add a
> > flag to mark those uncompressed entries at no extra cost.
> > 
> > Then you can detect this case in zswap_decompress() and handle the
> > uncompressed copy into @folio accordingly.
> 
> I think we could still use 'zswap_entry->length == PAGE_SIZE' as the indicator,
> As long as we ensure that always means the content is incompressed, following
> Nhat's suggestion[1].
> 
> Please let me know if I'm missing something.

Ah, right. So if compression succeeds but the result is still
PAGE_SIZE you will treat it as failure and store it uncompressed. Then
PAGE_SIZE always means uncompressed for the readers.

Even better.

