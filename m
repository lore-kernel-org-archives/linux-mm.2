Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8930CA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 05:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236CC8E000D; Mon, 15 Sep 2025 01:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214478E0001; Mon, 15 Sep 2025 01:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124828E000D; Mon, 15 Sep 2025 01:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 003638E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:50:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C16E16034C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:50:14 +0000 (UTC)
X-FDA: 83890409148.19.330C597
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id B6BEC80002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:50:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HYRQO465;
	spf=pass (imf02.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757915412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BE19JpLrmvACIHpnlhSmlXoQ1nMV1D2QE8IKuRDPiLs=;
	b=iQ4iQ/oiAdTbdcxvy+Eai49OuzYBn+CiJ4yGmLZIMU2HeI8OkKImWf+VVIv5uhWvupcJZL
	oKRgmQAQt08VcIEMVFx64VJotOlrK6Vt+8fpUmLl1jbVoY6rg393+aGA2VN9XdrKr3hAxX
	rqHLY9X4kdQhJNJVQhY64WLl73URuFQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HYRQO465;
	spf=pass (imf02.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757915412; a=rsa-sha256;
	cv=none;
	b=0o740+XL7qj3j0SFBocxwbHsDSD9X9jQ3w43e31jahNhDZZp3ZJ1fIDv47gUF5vvJTkCX6
	pNV64peC0wt5XB1CCOySsW2/qpVdugKPOKurl08SoW1/B4wyDvvJJJAKfwOBVI4jX34k/a
	PmYSFx1MMKq50rOmTRAbZfZRE9E8IzQ=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45f2fbdacd2so383525e9.3
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 22:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757915411; x=1758520211; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BE19JpLrmvACIHpnlhSmlXoQ1nMV1D2QE8IKuRDPiLs=;
        b=HYRQO465Ximd2kvLsYqm3Yy4JqDXnwU/BrXE5Vx6XPMk2NgInKnGFoc9kPymULj6wJ
         RAU6bCsQUeDnReB6tgmbe4bugG8KDauDUTqZCyJKhSMCOa1yaNcPQWtpTiwF/mlJvcfL
         4vNfu95Y+y3cPbHuIUA0+EbsLfe98iwqESHzE6prtA8nviZ47HTrLCzbQ280601z4vmo
         feRbYgiZoQpNX0R1uv4Viv0SH0pUmVZiHhRuI9KBs+zqTTIna5fPqxxDhPB0esMDgUqQ
         /mKYxzNcGXyDfu2YoWP8vIdFLFuR1o+tCC6rm7dt98ihXiq96kJilfOWRI/zV6G1qNZT
         NKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757915411; x=1758520211;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BE19JpLrmvACIHpnlhSmlXoQ1nMV1D2QE8IKuRDPiLs=;
        b=pDWr8CDvbG1zROPsANV6nkflw8bUgSGrUcjsDR2qHJ7tG5KVxI4yilc59TTeEFjcfr
         IULIFZy9PrNih9mF6OQZH8dJYUl58OjCJcvu9hp5amamMtLfZEZI0OJa8YfEfEFm9tF6
         K1ehK1pHMwEsFb+H996rTZwWrBLpAO6dutlHHDUsS+MIq1iEl5vscSNjLXFGqjuR42lO
         hOli48tbIzJSjO+T/RzUtqDxUMkghAdEEVkI+pw6CYpJFyBek5tNGtnWDM84A5uvdDzs
         K0qfojcJW7v4/VcXbYz/n7AfnlIfq8kz4vo3Ocyx33TDgPORDtnpn+RhBzluYoZlQ71u
         9thg==
X-Gm-Message-State: AOJu0YwP0RpMmxe+ioXj9SjNXKClN3/wrAGZ1nltUXS24EbyWwu2q+7p
	Gz2mo7zpd8zOa4HQGeeDJEyHJl4GD8YvQ+cWL9cx1Sl13ieDJ7EAdF+JsB807pcrL41SMe3N3oM
	QTW9Q1Sqozw==
X-Gm-Gg: ASbGncv8k2DFa1FAUe+bxAPBQRiWwJGrjWfI+HtMtzpCsQ2LOJp326cad+UL1Q7f2ZK
	P0K7rWLCi/q7/ohg8mdzFJ38xkGPjbhWzoDnWVVDhTotdHNABLtR46T10Cr3486WuB+yureOpyo
	dd/du6Y+kaxF3IvH68HJWVxCiMJ+8N/ZPs6n2L81DMEznEmL4sCFslK0+rjKAIRCRaYX8Abw/wr
	DQ6c6oESJo4OzO96nZ1SM1e+cAXkTED6id/qjVCkKezGAC/Dc5IDMbLkkU/i9du/0zsqR94P8er
	aiFEXutlPa01B5RABZZIdwIF0dM7VDYUinvLEzhBxgBtemDTt/hYlonSNAVU7JvIjWOK9yktkgs
	nfqTm6yN0oUf3QRyFMHCZwk/c4SDkKKp2vUWh5w==
X-Google-Smtp-Source: AGHT+IG1q1BYpzTLkny8BgHOP48tkvzEStv90SFQvZ0U/Fl95HNCrWBOImUCwLMiHdUwiJFxfdQfIQ==
X-Received: by 2002:a05:600c:4fc7:b0:45f:27fb:800d with SMTP id 5b1f17b1804b1-45f28ea774bmr49158265e9.7.1757915410806;
        Sun, 14 Sep 2025 22:50:10 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45f2ff61f2bsm715115e9.12.2025.09.14.22.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 22:50:10 -0700 (PDT)
Date: Mon, 15 Sep 2025 08:50:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org
Subject: [bug report] lib/test_hmm: add zone device private THP test
 infrastructure
Message-ID: <aMepD1FRu-2DfBwo@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: B6BEC80002
X-Rspamd-Server: rspam05
X-Stat-Signature: 1c6sderd3rqhh851b5ikro1fm7gnkkq6
X-Rspam-User: 
X-HE-Tag: 1757915412-982027
X-HE-Meta: U2FsdGVkX1+UzrZurNr2PGr6unUNCeMQpDcPPEGlLbaHSf1gm/2olChB5zXfQtRH6IN1VhzOeUrSnJ8eGjhtt2C6nWz0ZjyYGu/Cr4BHcDNXC9vgh/rJ3HCJsFU6/8QX/4xjO8rTjs2z55FWJZhDI8i4SS7cEB8b1sCsRtnsekCWwWVtufAQ3LwJQC4ELCHt4xIW+wIrX7/l2GylyI4zIpktSbvZaWUxhZs+IE2YJejRy/EhZTh2GWf0IWEQ1pTTklCWw58GkmV6XDTbBHQS9Zg+JmdevFDpZPF1jHKo46q6fY3WsJKl8Bs4pDOo+OBv+9capWqRWJDrT8PL/efeX8WKJIx+dvukPlteowZWTMXvMB/i4L9oMAOXXhFDjppHcv8xJQ1uDoEQWYjCC9IkljH7Kuj610A6P36b6RQ7rZOqJX19gWyECDs8ArTpVBK1z1xQJrVVhbXia36JIGcx5EEcvneHF200jQjIwun2frsnKg8sPJ/+suMflUPWiCLjOgRATv6Zz5IeibfxLp3tIyGxsjN85X473USStCjIVYKQxwKBy7bCcgyE/+tdPQR+lNn8Gy+dVsuvVwghZZDVVEs4jvO4lSNpRiiRs6PhwB1QtnPJOweHNF0Og9rXjoCr5mQ3Rltq4aPOU/ovPNr1NIlNsg9BOHUJUfZaYOXUsjtn9Q/qKrXZPIfdV1kljE5h2bfpnE5RAohyWz64VZbVhzS9g0ZzkgkoMT2S8SnNza0O8qVPA7mZSuIAIeDnthBm3pmbZokanSacG92z40e5CqrJ97LMQwhPHUy+tqsTytflHTJkoE7ACUAKm+vM8i5ZgIW2n4rJW4EiXZBDRN3cA2JBlS7UFjpDzaVFBPho8ui6ulaJoWd7Do/BTaqk9SIiHAwEwhFsm6fceQBNPJ3zCJhLmZ3QC+t5064j2QR4z0IxwadX1eJdUqsrqxxIAlOhKUHUSqrq9X5dYgm3tTN
 wT4h4ZiZ
 KpvsIfPO+5P0Ba55po2lCPsycME6OZWSOe47OeNEAvm8I6wNvY+dURdFjf/wTFmb/Wb4tU/p3llpXwmVpW9F6ryGZKdELdaJqTHOgujYt57GvlViScsv/0UzCriONlpKt7bvc6AoigYxg7yn9uXNI0OgCrY7n4g8fjtWaHdkC/MuxZX+qUMBAVcmj6Rq15IF5r5wOUkTHeupm/ml0lvdgnMlgi9dy+mUlqjCZ3lnFGINXchZCGKWf2pic7d06W++vrw8i1w8by8Q0D5oRRzOhy32Q9KhQYajRaQ/LPQVZVtRFGjvRsF+kC+OUG+TPCkVLwFl8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Balbir Singh,

Commit 6098c878b175 ("lib/test_hmm: add zone device private THP test
infrastructure") from Sep 8, 2025 (linux-next), leads to the
following Smatch static checker warning:

	lib/test_hmm.c:721 dmirror_migrate_alloc_and_copy()
	error: we previously assumed 'spage' could be null (see line 718)

lib/test_hmm.c
    675 static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
    676                                            struct dmirror *dmirror)
    677 {
    678         const unsigned long *src = args->src;
    679         unsigned long *dst = args->dst;
    680         unsigned long addr;
    681 
    682         for (addr = args->start; addr < args->end; ) {
    683                 struct page *spage;
    684                 struct page *dpage;
    685                 struct page *rpage;
    686                 bool is_large = *src & MIGRATE_PFN_COMPOUND;
    687                 int write = (*src & MIGRATE_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
    688                 unsigned long nr = 1;
    689 
    690                 if (!(*src & MIGRATE_PFN_MIGRATE))
    691                         goto next;
    692 
    693                 /*
    694                  * Note that spage might be NULL which is OK since it is an
    695                  * unallocated pte_none() or read-only zero page.
    696                  */
    697                 spage = migrate_pfn_to_page(*src);
    698                 if (WARN(spage && is_zone_device_page(spage),
    699                      "page already in device spage pfn: 0x%lx\n",
    700                      page_to_pfn(spage)))
    701                         goto next;
    702 
    703                 if (dmirror->flags & HMM_DMIRROR_FLAG_FAIL_ALLOC) {
    704                         dmirror->flags &= ~HMM_DMIRROR_FLAG_FAIL_ALLOC;
    705                         dpage = NULL;
    706                 } else
    707                         dpage = dmirror_devmem_alloc_page(dmirror, is_large);
    708 
    709                 if (!dpage) {
    710                         struct folio *folio;
    711                         unsigned long i;
    712                         unsigned long spfn = *src >> MIGRATE_PFN_SHIFT;
    713                         struct page *src_page;
    714 
    715                         if (!is_large)
    716                                 goto next;
    717 
    718                         if (!spage && is_large) {
                                    ^^^^^^    ^^^^^^^^
If spage is NULL but is_large is false

    719                                 nr = HPAGE_PMD_NR;
    720                         } else {
--> 721                                 folio = page_folio(spage);
                                                           ^^^^^
the this will crash.

    722                                 nr = folio_nr_pages(folio);
    723                         }
    724 
    725                         for (i = 0; i < nr && addr < args->end; i++) {

regards,
dan carpenter

