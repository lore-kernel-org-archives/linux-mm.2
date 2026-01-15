Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C95D3CCA0
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE36A6B0088; Wed, 14 Jan 2026 22:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91B76B0089; Wed, 14 Jan 2026 22:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D336B008A; Wed, 14 Jan 2026 22:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 873F86B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:01:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 230441601BE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:01:55 +0000 (UTC)
X-FDA: 84332698590.01.22E68FD
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3DB9BC0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:01:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="n8XA/Dn2";
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768446113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0+ZcOVv4sxcyS2yzBUTaRcfAN/zT7QcdgRC28NNhvU=;
	b=MKfS1LioEO2YdIur+JeuSJnAwbbj94wJl2h19ly7QgetjSml2hH0ZqV4bXsu9nyZn0WgSb
	OYsJVbT+5o2OEX+HAUwUG+sbWXJsp+Z/P1tn04DGAxK5rTSnsc32NrPxa+g7j7sMpZuGJc
	qF6IbXpqas3mfgXWdhf/8AR0y8+dDNM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="n8XA/Dn2";
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768446113; a=rsa-sha256;
	cv=none;
	b=pdbkCwZUIbOPjXhxO0HQEuCz+5eThK0EuPRlFqmNMrqEfgejBdYzwpD3XzCMdEL667JpRm
	+kS7yvQA5tWDThNCcZI6n1Rzh6fZ5YdCN8TkyzTVGTjIfoze76CoS8aq5aK7rIlNkTk8TH
	tUGvAr2E/bNA3Hv1C0G8t82ztGsn5eA=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a0ac29fca1so3188645ad.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768446112; x=1769050912; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A0+ZcOVv4sxcyS2yzBUTaRcfAN/zT7QcdgRC28NNhvU=;
        b=n8XA/Dn2JExlDMz8UEUvFDp86Yam04/YhqcrLxDOGBFwaLcVXIVXW9AeHZ8vFq9BVW
         WaxsC4b+oinpAYwu/NF+LiNBAUH0+27NmA5ytQzyiAKLJpmmHxDJk6lq3FP78rFdXsGd
         QFEH100wukZogS9AJja1XCoJmWZx6UBzRqVIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768446112; x=1769050912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0+ZcOVv4sxcyS2yzBUTaRcfAN/zT7QcdgRC28NNhvU=;
        b=hvGd/3l1fAF2/NfMEDM9s8rYnwyjk7VN8MoAhta+6BV6sNpLL7pRJhpOT++uwrH7/y
         NiOTfy3NrdoQiyuUAHZdqDURxd08xRkN2A9QPUZFusAmH/PhOuNYD+ZJuESjBv8jKNQb
         hXyuV+IqYy45cK0S3MQRNAj7diI5XS+Mmv5aX22Frb+L3vwOTBbFCIlRcR9XWkfT7LCh
         KNyPMOdHOh5i4ZOTTpXMjpWhusSIN55Vf1efWdslEhHs2wvQI0EEfBf930wOG5eIWFAQ
         n5+hh5gILxWNmDFwtsml0/h3Nk5Edhj9TOHM+r6sE5Wg+aytQtgmQKk4sSNrUF8x7MyM
         WwMg==
X-Forwarded-Encrypted: i=1; AJvYcCVIQiz+RbUMZlH7jwp7TcvZjyiSTJhvNmpUjyzgIuANh0Jkpf20oJEN6ss/Y0odbdBPsE5KvSslYw==@kvack.org
X-Gm-Message-State: AOJu0YzVmrpSP80sxkd5qhlgTpnhaaN6qpbBfp0rhaxtE9AHmPIj/VE+
	6rs9rL6lL5w6GPzQmDWP8wn5SOOUD1kzf0gccmnj5ty+v8WizfZLE75u7jLtHFM5lA==
X-Gm-Gg: AY/fxX6Jtg1UWsC3oss2lF8dS1A8G73UCxgGolN8XmqRalXY/oehet3WnA0Fc014dXN
	/ZetLWeVeGuiH2T/ugBHa/6EJ7dfjlbg90vS3ElJ6O/FdSmTxzKflmNgmMqV5344h1GDJ5LLIYs
	ODLeGKoNaqPZ2MWIUEnKlOCY5c+jQrB+QXvCfTsf+d0cHVqMjoxXt5TXQjtMy/lQv7I7NTmameh
	0wTkwGeTSZBELI7yC/XUDHmOTHlo0zSvhQNLxlL50rLnsbo2IAb+qgu1bHJ+zhnzPtQIJ8vzdOK
	t9dSe25S5a11iV3S0KPrebTu/tE2bCJgDPSG+W6TNiNrZjpWa6S1PUNunNfw5UknWnzVAZAnNti
	gtKKjzEKRBJpeVQ8tKCq5ORZGQFayPAFjFfyd2oSDHne+yjnsSn8FNxh4RQYsg6lpptXgjrEv2B
	27y8C7TWTnZAUSXAveg3SynPvI/WYrqzjzl/4P3WcrnwM24x6Gojs=
X-Received: by 2002:a17:903:1111:b0:2a0:afeb:fbb6 with SMTP id d9443c01a7336-2a599ded0cdmr38869975ad.8.1768446111985;
        Wed, 14 Jan 2026 19:01:51 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:36c2:991a:5236:1fe5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c48e8esm125169495ad.37.2026.01.14.19.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 19:01:51 -0800 (PST)
Date: Thu, 15 Jan 2026 12:01:46 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Chris Mason <clm@meta.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, David Stevens <stevensd@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/3] zram: rename internal slot API
Message-ID: <z6qsrmojsh5rcrlv2dggbjgyb5q5qmdgrafeq4zknpfwdrlaf6@zkcqyzrwpiro>
References: <775a0b1a0ace5caf1f05965d8bc637c1192820fa.1765775954.git.senozhatsky@chromium.org>
 <20260114123658.1231407-1-clm@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114123658.1231407-1-clm@meta.com>
X-Rspamd-Queue-Id: 3DB9BC0008
X-Stat-Signature: zj8fythfqr1t1xywzrmowc96dspwkezn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768446112-625302
X-HE-Meta: U2FsdGVkX1+nW9Kv9k/+MdXRRbNUkwzka/zoUExMwHt1YFfmK1pDyeyC1hacz3Maq55Amf5wTsO5GgxHBkBW/XxLWDGEM+u0zcnL4I7eM8aYhxXdQWAN0s+CPm0S/DqRxY4Tu93xnYH4fJa3gbT2g3a8Zgr+McaAx7rYZIfxHETePk6RLylRBvdhC8yCdHMIOpoJS9bmKQfv0x3ekIbYnuaovb57NwgUy5/dpTtd+yzUrLuQe3Hy7Lju82u8wg9uoMHzDFEM9MD+ZEiS90XDWI6P3ZXrA44pZvdRactFjutHBypvvnvTNuGeUWZiB0gtpGJi+QGLDPQi7neTkDL7buMgoQQMzSUTVkMV6DONemKvYN2CHDOFoCx5Vg0DLNC1/+uuqYsQ4n+qxbHRpFOxRI5CCRCPB9Pn4aQR18clu4xzWXjLCEolZ22qwNdGhRvi3hD0BQVLezGHfs6WU8k/RyMmiwPmM3zXLZ/Mp4dKXorgqVqgPqgwQ3o1erbu8vC9HdMWwmAvGTUA1YLh8iYY+ZY9GO9xBT8wrAIzm3GEakmjulS+XdrihttLuMtju8DlYmXTHespKkoUcz0kGgqmntdgJ6wud/QE8uRjWTNJGY6RTYtESd9ikPci0rhBQaOpyyupn2GlOx0feSV3fTwF0lYkgJwK77UVA8YMn+HdR7rncv9H0H4kT54ZooYAHlMfJs9bZuyS6mI1olFxT3zqthgGZwSuHhbjTbhR+cimUlZKzBiXB5cZ7EZXuKME3m/1RFEgWLnQTq58B9b8qHSQGSmSbDxSzSncKmWM5l6bnuWvXxq7anwLe7a2lVM88VU1B02BT/n2WEHPg7qG0HZDVChe9A+LIXEOepJTsp690AKqqj4DNpUdxmdPO13Yc5+Wv0rWoQo7oXrMNkIEU0kD+uRzWC25RZzaGhbncMt9nSJ+9UYjpKiOGuhHRXoO5GVQyqm5EHXRM+9ASoY11lA
 9FRj1FqL
 czTfsiJIy0zYzR+MxLL//m0M1SsfA8eIo/73YnC7adX8wNJhrIOs7VphfNXFFAbCNoC0JwAH88P99Qi6hwEoHm+BtO9na4RtGHpT3XNQMKGHN3Otd2zU3onP6V9EGU527NBVAZEil84Mpy4NB9tLoJKVh85Ene7jSi+yAHYmwRqzoiITN6njD5SmfwYiY79AQlIecMlvdfn/vWAh/tWfZs+XlNatEUbK15Q4+GjB9saHdY1aRPZtfkSP38e/zSXK9xe2ndKAzxfirJIbMMAJZ/7CLg/fq/8bOr7LDKO5C6gW7XqPbQQoNLk+gUiv+gYfjpNBWdZ6aTngkqrXXJgsUNqIDsXCUCeOXudaclTv1pv5iaNE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/14 04:36), Chris Mason wrote:
> > +static void mark_slot_accessed(struct zram *zram, u32 index)
> > +{
> > +	clear_slot_flag(zram, index, ZRAM_IDLE);
> > +	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
> > +#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> > +	zram->table[index].attr.ac_time = ktime_get_boottime();

Hmm, this should have not happened.  Thanks for catching this.
Let me take a look.

