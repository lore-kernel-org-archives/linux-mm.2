Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DCAC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5DB59000A0; Wed, 13 Aug 2025 10:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E26900088; Wed, 13 Aug 2025 10:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5DC9000A0; Wed, 13 Aug 2025 10:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B847B900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:58:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65A421403BE
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:58:01 +0000 (UTC)
X-FDA: 83772039162.13.3B88DAD
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 94854140006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:57:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vk6H1ef5;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755097079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1C6C68HSvqMhSJKPvSTlY3JwFucLAkfJ49Gr2TvVhM=;
	b=B0veCnSPGL585osDq7wK8uqeyASyJibAbO4Pr0CGER8nPYMXN/JBWnUHE5/7qwlpXbSJTz
	8RJMOpXEc73iNPjiB+KL1AITxvMLLQucTuI2C8pCIbSeb+vJoybd5HGNK0cBTAXu+Mk+2p
	/0iutSJpepuUJdp4RJdg1bCqSPS7BbQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vk6H1ef5;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755097079; a=rsa-sha256;
	cv=none;
	b=hcS0Kc9rPGsr32D88OnQ3MOGpL/uNvMq2jgr1i4Xi4h6yV4zN7DZ+M2RlfmoSeutBXWKI+
	GPzgdccp+hJYF2HNUTeHiiDXqTgIyaZzh/L70cypIBf1vh3saXZmZ7tCkMu/0S8COmOcVt
	u1m5yGBKXL79MUjP9OXQb+efIJqY5Zg=
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e54f4ca0dfso28652695ab.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755097078; x=1755701878; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C1C6C68HSvqMhSJKPvSTlY3JwFucLAkfJ49Gr2TvVhM=;
        b=Vk6H1ef59yPg7Rn7FUJfiYPK/wKDQLAD7/t7ZSiqBWkwoshjsiAB1lBQHz8F7tVUNK
         hbnUIp3rp2lGtbQNq/TLL4L9HM6Rgb8dk/3XW+BdTrDci+luyjn9ESkORALr3MsQf/2s
         5Wk/ddsjNtPN2ZUmQGYbnzNigWdAlIrG3anTkr8OGQEpsAR4+hS49DkXjcwgMfCGnvcw
         iZGC76FPOq97/FmJOaNjJojqN3hhNdOxGQp9D4w9PvR1MMGH473D6VeNIhc4pSchTiYj
         TWkr8ow+dVXyVsV2YrLCYCKyz+Pks1TJY0OWVs628yS/VBozhC9C0NXHLXrl326g1MoR
         iVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755097078; x=1755701878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C1C6C68HSvqMhSJKPvSTlY3JwFucLAkfJ49Gr2TvVhM=;
        b=S86HQwl8aVVIXWK0xQ/eAAwMRhvL6P+lemD8xv/dsifkymDM4wUxDPuI/S6bQo+upD
         s2s50HIQHc5oYoAmBZ+Nr+2tzZqD1zgvcbM3DYYrYuYsyaH5DlJeSebIpuVpUL+BUrTp
         Au2XoOy/pXbEtAywlz5wmndr4rkfvgAOTQoEh+75NVdN411TUGbC2GRuhTcJxJf1xgph
         /EPy5VsJlmndkyhEe+Deuiua6WsUe1K9cRhdD2xR1Mzh63wLXOhghsBAaonogm65JxO0
         H+RFdqw9qAKxuRSjv0ALE2gthlWM4Mzo4Xso51na1TGo7h9uqdlmmDHgScQcqIg3PcR/
         bLQA==
X-Forwarded-Encrypted: i=1; AJvYcCVDX9njFXe/Ov9sCyavFDxFQ6SIT7TFiCe+e/FE9ubkpooXO1Oa4QFkKY9A1ZtvnDhjsfYDHoyXEA==@kvack.org
X-Gm-Message-State: AOJu0YzEe0rM6lRgY7qN/1+BB0WMGZdnqjnHRTT+95d0YQRBOgsStB3W
	1y0Hh865JqPY0sR1QNlljz5YtX0omkBoAWsQk6DTHgdIubeG7utgytCbPIpdHkdQLWOY3G02b4r
	2JeQCQjWGRwJEKmW1hUdVtcn1pxFzxqk=
X-Gm-Gg: ASbGncvi+XSrTq84uwxbgdJ0DpC6I1hH1+fXN5xgYVarFxepn+0ow0s6R5H5QFLyPvL
	pfKNYmhBWSA+rl8v1Ok1OUqjyuGxl9sBqy4Fo9X7992l3WZur7MWfDvZp2ddRp3pDl0411f9ej1
	TclFJhmFPJfEcIurPSbl+aEpeLCqFKEr76gke6jukdHi4HSdHQuzfXQB/uKsHbdL4CB5F2zew+q
	Dg7
X-Google-Smtp-Source: AGHT+IECvEcJAuqVNJem8cC/P9L8/n38xX1d+UqWESMmOlqWmSGR4aIX3qh8ME36Q5WCmNIge5FX7QjVdwbrPlUpz8k=
X-Received: by 2002:a05:6e02:3e8e:b0:3e5:261c:bac0 with SMTP id
 e9e14a558f8ab-3e5674de9f9mr44704905ab.22.1755097078469; Wed, 13 Aug 2025
 07:57:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org> <20250812-swap-scan-list-v3-1-6d73504d267b@kernel.org>
In-Reply-To: <20250812-swap-scan-list-v3-1-6d73504d267b@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 13 Aug 2025 07:57:47 -0700
X-Gm-Features: Ac12FXxiCEZcTx71SB2-7N7mbjmYWUdvD_vXmcG4ydTw8c3TixlbKAnHTrnitkA
Message-ID: <CAKEwX=NLG_MBvwqMuoLwRmD_EBSJoc1w=-u7mj62YpG9BAFbig@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/swapfile.c: introduce function alloc_swap_scan_list()
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5s3xon1xuxpq9h1xpwwmx8si5y5r9gm6
X-Rspam-User: 
X-Rspamd-Queue-Id: 94854140006
X-Rspamd-Server: rspam05
X-HE-Tag: 1755097079-821391
X-HE-Meta: U2FsdGVkX1+HVBhD910WyG36+IXIDq+ap6nUEYsGXP8G6nTGJKdT5UPydeg01zLWiKKtTo1oKFVCM/qnWnX+C6oGbMn6s5QNvF44TSB4VBbQXUU7r/WjV7uKozH/Rbh8m4hJFguC5U9gil/dZOHDTRxLYO+MdY6U9EbpvcHh73AikQoZ0PGdo2tOVVYpxBRkMip+z/55tPkn4kbkyQq4nAoK5bzh91qSC3jD1iuy0AzU7pczFBy2w+WralzATRv7R9Em72diq5YkMT1Jwrgq4vmqET9OhFNEM62xjhhTZ9y7+XbjZEeW47/4LPfdRPW66raKFYsv3I8/YH94ij5x29PzkyZyePBdQNYjGV8Diwqs2l3xjudhx3pDd5/cLnKW5LPBjW2XC7iCyoekSCcG0ndf/WwvCmFU5niCYHc8eAY4e9lIsIn9UnA+PNv/C0vkXEqaBUztFdI6E2JKk6ztiOLlb+dMH5lZvE0ns4VYcptm+sef1hSERVayZWDPUH+a6c7A0y4e3Y1+CcbbqMRwwaVkOh1hULDGIb40ZIaW3J6NyWMb/zdsVbtIoxwICBNoSbgpBAWlqcT2as88FlZu0BBW8KFb6/YUuI36JUpX+TMxrzTePiSdwW5EuY5jurpgU48jw8xUalgKkKctQMWBgVYQVLdp5PqQ8mP0fohgyQlZgtz8zVkAQTB/16Ty4exvkmz4qkEh7TKk5VsmBpuweFcT754/a3w18QKA50Panw8MlIFSzAiTah9fRzShjgYK/1hzujc7eJBf4j6q8mChxE23+H0D+/aY7Tse2rTMTNbl0cayqkMiiJsRlUh3qe5r2L7Mjp3X4GMBkJMJq1hTa4JC4AaaV6C6mUG9Do5yoL3YBZe2ADmMUdkqiiVVqHY/JA49poP0bzkyt2nkFohon6U2bbpDMQ5Iu3lwdkdh+XXEu8FW+bEStA5j8bu+3udvNH+JLYS8+felHICr86C
 zFNtWhc2
 58uCBLFaoSOc/jD2Xw0xTOH54LfzQAMtP/l7O4j1hqaIzMNxphx+lynY1WSxaoocikVKvF7fyZdZJe4AO1nHbe9aNlMqN0N5O31XnmkxFc5P1uKHUNZHX5ZH3BM9JSx9g6l60ZP0F4K7pscrxkpsYTj+UCj9kUy9srQqsfbbIZSqrJ1xn2rdL74TDeMBgBfrPLe4PviXH+DtDPr9vxXzTsjAZlsXTKH6NSCMJSFmxFOrzVRtKupn0wAHuT24Xqem3VkEOsm25f1qlctHI9YE3LgUFSy80hbr9HT1NSJpdmHdUTCpcMtJ9xiT1ct1D0AI+7ZOBMSTZdQshCUWLqBDKfcwZ/hH1YIhU/00YTn5WmJJpH8j0O9Yxi8tQZU49dcdDpg/exR0nuy9DVX0i2E5JJY6HE+e3CTYFMAUnS7h9cQRATjW3kLgqZTr6BqdOt+By1XxCLyUSU13ihi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 12:10=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> alloc_swap_scan_list() will scan the whole list or the first cluster.
>
> This reduces the repeat patterns of isolating a cluster then scanning tha=
t
> cluster. As a result, cluster_alloc_swap_entry() is shorter and shallower=
.
>
> No functional change.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>

Code seems more readable now, IMO. Thanks, Chris!

Acked-by: Nhat Pham <nphamcs@gmail.com>

