Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 267B9EFB7E1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2276B008A; Mon, 23 Feb 2026 21:28:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5659A6B008C; Mon, 23 Feb 2026 21:28:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4717B6B0092; Mon, 23 Feb 2026 21:28:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB8F6B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:28:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D32C31B6561
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:28:57 +0000 (UTC)
X-FDA: 84477767514.21.10AFD23
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf16.hostedemail.com (Postfix) with ESMTP id 136A4180003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:28:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="c Bf6SZH";
	spf=pass (imf16.hostedemail.com: domain of 00107082@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771900136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVBWa1LA5DH/6AseFGtAxnYgj5dMoow6qkZJMUk66t4=;
	b=eGWJofErT08TE0uQhmG+oSi/x0FLgNTgwqqa25a8CFOnnsrDDzbibznOfq61ZO72/kWHzK
	977XtiY65Sc6AfAk9jB6Rzh7q9QNeMp0XPpjey1gdpQji/oIJzMtIeOmWhHadIyr3nicTw
	7J9Rigl0vVS3okc5ngh5s3Fr8uzgXPY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="c Bf6SZH";
	spf=pass (imf16.hostedemail.com: domain of 00107082@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771900136; a=rsa-sha256;
	cv=none;
	b=X+gjfvQ32ZCGZYx3E9KsVA7FqXMk1uU6rRWPZCtodBDsWIiuktGmK8y1COMmaHGyTmfiHB
	scvNaNwS4+hjEc9dbl1FDkBqjn25NUbhBRFHhhCJjpclUemJlicpdRtCDybx8f+NkWb3os
	MGxK4/8qkdZLYWnMGQjQE6R1JOjy83Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=mVBWa1LA5DH/6AseFGtAxnYgj5dMoow6qkZJMUk66t4=; b=c
	Bf6SZHtPa5XACAJ3cLtfqmL7GOu+/56imyR66Bjs2LHHLIIGoouK4TYwg7JvC7w9
	3wPQdib88Zv+jtTGmjGPVxvDc2B+PKYB3wHJ98ryHEBxM13SoPDZWsDs5qFAv2hG
	0Pjqi2Xonysh2CqXi/yT5pySzNUMmkoNyxwhX6aZSk=
Received: from 00107082$163.com ( [111.35.188.114] ) by
 ajax-webmail-wmsvr-40-126 (Coremail) ; Tue, 24 Feb 2026 10:28:40 +0800
 (CST)
X-Originating-IP: [111.35.188.114]
Date: Tue, 24 Feb 2026 10:28:40 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Vlastimil Babka" <vbabka@suse.com>
Cc: surenb@google.com, vbabka@suse.cz, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, "Harry Yoo" <harry.yoo@oracle.com>
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set"
 during boot
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20251222(83accb85) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
References: <20260223155128.3849-1-00107082@163.com>
 <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
X-NTES-SC: AL_Qu2cA/Wbv0kp5iKaYekXn0oTju85XMCzuv8j3YJeN500lSTj3xE/cHJaB3n21c6rNT+ojzSHYSJM+9l2YIBKQYeY0557DXFPj4/j0/zT7mbO
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <37bbaa9.1831.19c8d7a2cac.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:figvCgDn77TZDJ1pjPNrAA--.33445W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbCxhn6pWmdDNmCeAAA3b
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 136A4180003
X-Stat-Signature: 1eb4prr94nc7c7gsmmaukpfm9sz8sjib
X-HE-Tag: 1771900134-615101
X-HE-Meta: U2FsdGVkX1861mThIyxzzjcXOd/Ih56TwbCuB2yLd7LR28JYgUkdNDyUrk/tA3SeTTR+/q4Yf4QTuvsGWvYev/6gfSHX7RIP+Za+juRnoUkqwEtIl5Xf2uec0rUp+/FmbmW4+fvJj4ikK4JD2W25RbhBIFOuF2NcSblhZfYFfvk+pTZs+F3wE61Al6UzffA6KGQVJQwqY8BjCBB3OVqL90uISzn0mBpnHuEYY0v7DyyiIqWqTjjfRlU7a67Mm/2i3pnUL1/bglbmrKTDhpnKmxYBmnPhAhz+F2wLH/gFit46AMnNigUa4d2Lin+JORysnszDJHyhNJ6YcSocb0kaL2lbFzocDS87R9kLJoZMG84prN7wHdv8ihnuRU0mjxV3UrwWIVeyp5eneTXUmjhEcvsP9XAORRjrFChU2YW7+HFH5QkZ6i1X2ycI/NJok3sOQyTODlzcVDlFeZOKZ8i+akCTaXCQ6UFVXZ+Yin7OJyOETiy1bazXpKZEj+RZErCIaIDtkXrvEbkgrhd9+g6lZFRLB0TkikNoJJM7sbUzrCeUvHTSui2cIodDQS2WWDagP322u/VAmON/UiArElJdbX3lxvjG1g+iJGvSW1whQMw1rrY1z0qir46HTmlw5OG22T9iYBjv8Seno67I01OSumfaDjeiaFe8bfAo1H7wmg4USJVuvS6ASBwavM2DqxBT/biPj1Fhxy6LHquiYU5qxR/+Fi/QqxtOYBhw80zEV86iuiTdqYwk3EUXoJx21lNtSM6Kndgao42AzHMixZyoqhe1wLURFw5ngIHuV6HrHvUTB/7B97zxxfhprGSO9YVC1iH4g8qS+0WiTvN4ZERZ1mx2sI/dYWLFFZpz1gEUSWoURogS+eKJk+dCvRKF54rTGGkfRUdQhpv2N5vSzpnMEIGJ0RQSfSd8khwS0Byvp8wNxLPsQ/ValOyWUHOGslh0GWjZ+PGNmyGdjP2dG4l
 fX37niCI
 OFVyMF2zqPP3mpssaM18b9mzw4LCvwOsH71Ju/wSmfhpRKmuwZg+SUTh9E98XVWT8lXvLBXZiTqkUJJxrcKyKzdfIT8oxgWI18XnSXTYA261YxZwxFVv+i3wF7NE2LCQ4PPvz209DRilH+ZUtY/wZMybKznMxJmNlCYZChdBH+o7AYjW0LD5DS/PzkWLvFiw/N6Jh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CkF0IDIwMjYtMDItMjQgMDE6MTg6MzIsICJWbGFzdGltaWwgQmFia2EiIDx2YmFia2FAc3VzZS5j
b20+IHdyb3RlOgo+T24gMi8yMy8yNiAxNjo1MSwgRGF2aWQgV2FuZyB3cm90ZToKPj4gSGksCj4+
IAo+PiBXaGVuIHVwZ3JhZGUgdG8gNy4wLjAtcmMxLCBjYXVnaHQgYSBrZXJuZWwgV0FSTiBkdXJp
bmcgYm9vdDoKPgo+V291bGQgdGhpcyBwb3NzaWJseSBoZWxwPyAoaXQgcHJvYmFibHkgc2hvdWxk
bid0IGJ1dCBsZXQncyBzZWUpCj5odHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjAyMjMw
NzU4MDkuMTkyNjUtMS1oYXJyeS55b29Ab3JhY2xlLmNvbS8KPgoKSGksIApJIHRyaWVkIHRoaXMg
cGF0Y2gsIGJ1dCBzYWRseSwgaXQgZG9lc24ndCBoZWxwIHdpdGggdGhlIHdhcm5pbmcgb24gbXkg
c3lzdGVtLi4uCgoKCg==

