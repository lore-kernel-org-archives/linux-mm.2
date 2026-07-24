Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A69FC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51FDF6B008A; Fri, 24 Jul 2026 11:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F82D6B008C; Fri, 24 Jul 2026 11:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C22E6B0092; Fri, 24 Jul 2026 11:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05D9C6B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:16:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F562A1242
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:16:40 +0000 (UTC)
X-FDA: 85024022160.25.366A444
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id 961854000B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:16:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lPLXonrK;
	spf=pass (imf27.hostedemail.com: domain of 31YFjagYKCMAykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=31YFjagYKCMAykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784906198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZ8f+6ih5KROSa3iYv5xsmVxcdcq3+d3PqbnwpAR2WQ=;
	b=TWW283XtfNMIPInBkAscoz9MzA6TTRgOl+UWtdZArRFnN9D4NUIz/pdf2udI5bkSMv7A3M
	aIxVp7RRVk77htzsEP4W6+oNiqKuP13qf5K7BphkhuaCDn6fNfqay+TxL0xsOkUu48PSvo
	W80lexVzj7SzlQ1B2J7uSdFgszHC8as=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lPLXonrK;
	spf=pass (imf27.hostedemail.com: domain of 31YFjagYKCMAykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=31YFjagYKCMAykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784906198;
	b=8BkkcMdlzBCbf8e72/rduHZ0/pSbYf+5CEXbCyRcpjrnQfbpn9VMiy3oP1jkaJKvAk0b/x
	Gc4jm3kaZhgKZesgrA+ZUnz4hKSEvfoRx6wSvaHlDW6KPkhdM/YBzTwo23ZMserJLUhek7
	jc0NBrQLsMIZqsSjMbpstpgvdCs/Ves=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb4bd11ddf8so598466a12.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784906197; x=1785510997; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DZ8f+6ih5KROSa3iYv5xsmVxcdcq3+d3PqbnwpAR2WQ=;
        b=lPLXonrKtVbO/UhMuMU/NJ3v559AKJtWLreblG7k3k19qLCwdNHpZZNqcmpga287RT
         DjEhXKQDMI8oeh6S7w4VVw3F83N/G+UCXDB5CAuplg/i+W2TeFt6pj7XXKkFoBY8FYTq
         Kg0ZqM9eu6sB/8BGYAKgOg7pg4WBH+TFnzq7CgAiw8z7ZWCB4en1gJww/N2UisytLKOs
         EpGoH5iJ/P3U7tVn3yfYGxo25BdRpi2GECQiQu0ltoNmZwYnb3ckERxf8a+IB1xl3M1s
         HHDoHE4bVVn0y9Su29lsuen3WhSOMJD8uB8nn1uq7gsqm9Wu3wYkTmK2iN4wjXlMN6SJ
         Kn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784906197; x=1785510997;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DZ8f+6ih5KROSa3iYv5xsmVxcdcq3+d3PqbnwpAR2WQ=;
        b=i0nsX6JFBF91fGHovQz6rQDnGSDlVAL4jcHpf1m6JDcfG5QMHVGDQTpobWpInlF5Bm
         1N/q6L50SJb5pSaKkdXt37teWjGps1ivstk9Jw8U1JdRhyIzChow9aSpX82cKx5G94+5
         1dxvzJ7LwD2hKctMWO0ibf+TCAp7q7dF+/UKrezXq1A/6d7z8jxZn3NgizIjel0ddioC
         vydTLwspkSNmfdiJlD9v/BrQSBhRRUAFZVtt17W6QnTCGU0DnqMCEpMWxBvw+myGoz9g
         FqLKt8U+UXU9e0wkwBLqKfDu87EgyQs4BbPqLBrVVF2Knxaq6WpIl0scIWUlPdSvwQb9
         H0Wg==
X-Forwarded-Encrypted: i=1; AHgh+Rq3V+cuSiZGL4DcTLFDFkryuhvOtSJvJ6Q7ePGOq00ev8k3bAyJeGCLwWSWo0amammzhC/UonmMCg==@kvack.org
X-Gm-Message-State: AOJu0Yw3+btn786t+WEiIuRSO+kHNxxPA+XW3xOOvKa07KX9mHNgjv4Y
	HKiVw6CM3lq10l3nWNChxGBJZHH6ojXso5e7sdXHyvU/yAx768H7QPOSCRqRyiROq303koIUF1P
	rT3NnTw==
X-Received: from pgbdp1.prod.google.com ([2002:a05:6a02:f01:b0:c92:11a5:bbce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1d98:b0:3c3:a490:9674
 with SMTP id adf61e73a8af0-3c44b250f8dmr8630341637.64.1784906197213; Fri, 24
 Jul 2026 08:16:37 -0700 (PDT)
Date: Fri, 24 Jul 2026 08:16:36 -0700
In-Reply-To: <20260723143034.175661-6-willy@infradead.org>
Mime-Version: 1.0
References: <20260723143034.175661-1-willy@infradead.org> <20260723143034.175661-6-willy@infradead.org>
Message-ID: <amOB1ATJGo71QMkE@google.com>
Subject: Re: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
From: Sean Christopherson <seanjc@google.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: 961854000B
X-Rspamd-Server: rspam01
X-Stat-Signature: jt17uotd1gn7w1qh3wmh8ubg7bznz58i
X-HE-Tag: 1784906198-563846
X-HE-Meta: U2FsdGVkX18JWm4Iqvx6+wfm5lQJsdm6Noz08rB0yKAHmTAFOsXIsSbL7P8BPuKtF45u8CcMYt1i41azSgR6nLQH6RuxenWUlFICxw46gc8QSqdJWWOropiMLOxIXY0DzV08J46GjyhQ6YAfKQ90TM/NOetY1oPKmdeeok39uBvyMPp4FFTSFYQ7Wj4Oim+0p1UAFE2xA0zLn3ZCvXjvsOaxuSTsEgG8izURyfwQHNoJxXzgc3HYalPXZuCclBEx9Duf7xylrZFd0LX5tCkvjfEjpc7o+g00Vr1SPnPXo1rW4SSFG+vVA0H/S9AhjT3pUX0z5IgstMMUMUjyWmO9Xo1WV7ksxj3eylZ5xuVKOuGX51jDrUrkoP4EsSeZo0HJb5g8MxfBoetaYJMngmPkfW6c53wp2lclGcx/f9sNr40aj8IviEYwfhCFF6Ey9fwaKjDfpwkKN/T92pPyZGaUIt/Ua02Y/xiGHuQfkhiTZdhnTjLVQkVqiWKe0bhalgFkp2xDKlUZzFUZsvUXf/tLMzcCDnh0qZzrF7mXiXCj/9pPAMPKnni1AiADzyHPBh6R2VdS06dcmulB9fFNymKznPhp/wcuwzOIPkXlAHSSIu4hoX1mKyVuBfvhRjFNuUPjH0bhB16s9tBKgvizF0hCXlVrN3Kd4hEjhl1YTxBulI0AiA2JjjudbtVcvvEg2HvNSblufkne/dvUDvy9Yxw3o5JEsRgoRPHxrQ4UXvxIY3T7sNGFe/XNGJXVHKxXu+Tah8RRP9ZBExl+qe0RR8sXXhdiUiu8f0cpovULDFkBoLLuJCtLykPwjYE6G7aZui2iYHfCJdnoi3SI+/R7VZDQsWbqx60T37Vloct7y5KIelXAjM9KM/R9DOK+6kDj2i7kGjY9fkixXD5d+hDbbsEX7QrVfQ3P2HoMinyrlhzyjI0qFXIjBV+94qiV6Xh0Fvs7EcyON8r9uSlG++SlWgr
 oAXlhgF+
 R4O/0J3wRzNhdghJiOY616Zrst8yEXtQf/hsl3UK1JtCKv0tZRZ7OAqX80n6lncGcufdkTy6f9tySd/oKkjOHsUY7Qmlv/Nr4ZFdVocq7igmtD6ReaLcL/ztcdJ6kwGza3DQyzHlqic1OwJOwyY6viVlkYtJ8mCdYHzugFt2SWfqSWgt7lCIJ3i7Ovceg8KuIiBibqRbKa7CKKFVrgQ7XO7nWOmLwh0EUK+Op3B1ZGPa2pZJ8l282EdiuAR2d0T6GcuF6hdB/1CsUZ79BFWtlO1mQiZpyWF2sygeQmKeCv6bpPwtaoSvGLg2tOirQwO4GopgmY/GbDYECm/HEfjyXew4TsFKxftyoqarjePHAN2yghmFHjoOR/5zsy0yhQnPLD+yqjL/kkm1nALHnZ+n/YJsHth69iuY2B+PS1tRkHQZRLIXEjGx7+V64E06TW/bRtDg1EGOFdgKUPvDxbQA3Hj6qFM0jnEfJ4/vgCzj5Q1cTDECS174h7x2EHjmwGmG6+IDUQI4JCrdim8JFQeHoFg9lLG8cjSXZGE7Ui9iMLJGkdv0NUP9FQzualvDmFkD+5DcpXvQomK7rDnYZHFyEbpd4+JW91iUfSYxP+nmxw/NDgGPC4qmG6ifLNIj7ZBigMr9uUaNCSGyGxXXzYXF3Jpx6fIjRfH2Ujz5FwgsqFiMWW51PLEmMZ3xog/gvgrBPVEN1/46DY/ESdeQawjCX/hy68CRm2BquS84EzwaK8Rk+M87vAHPU9LkAw1JaNezrfj+g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026, Matthew Wilcox (Oracle) wrote:
> folio_test_hwpoison() only works on hugetlb folios today and will give
> the wrong answer for other large folios.  folio_has_hwpoisoned_page()
> works on both.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

