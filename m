Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADB0D66B85
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 19:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5ED6B00A6; Wed, 17 Dec 2025 14:21:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9FFC6B00A7; Wed, 17 Dec 2025 14:21:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9846B00A8; Wed, 17 Dec 2025 14:21:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5CD6B00A6
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:21:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C4B55C7DB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:21:47 +0000 (UTC)
X-FDA: 84229932654.03.84751E7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id 91EBF10000E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:21:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765999305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MOu+h0mTrlQuRHcMIl9yvNkjNbQarUlWFdBIZWTg3Yc=;
	b=LzuEsIAJjHW0PSLaUo7/UyiEbHTZCOYiHba1ZcaMAUfMnq57gTDLrKe5uiDvzNoMivrInD
	ITiNrLfEwcODCIhXeZPkyKdAI7B9XRDZGjLG29d3R3zEVRyD93wcxpDhEzsuqjWkP3e6+U
	Pl8ee1di50sOkElspbUnU5QLYZBQp84=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765999305; a=rsa-sha256;
	cv=none;
	b=MlmYfgZO9lfC7JhXPCJXnUsNntIIAHT7hSR+I1K8jWOGrvY/WkJjX9cB1ttmkRb28heQ4Y
	d2PjnimmfebQoKwCxDMnoU5E267OQqCTXDr4wMlHvRhT8w7Wpp4AP8Aw32+SNylOj/zqoY
	b2Gxd3jS7eAyl2wAqh03EYb0XFJx6H4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
X-CSE-ConnectionGUID: yFDFe2tYTtS0gS8Nhf9LYw==
X-CSE-MsgGUID: qBjQ4KKvRlyPTDBejkhBVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="71803597"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="71803597"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 11:21:43 -0800
X-CSE-ConnectionGUID: AftCqTQZSxWjkdtEUSHIeQ==
X-CSE-MsgGUID: PArlMMQJTmezdPyx4IU0WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="202756683"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.54.38.190])
  by fmviesa005.fm.intel.com with ESMTP; 17 Dec 2025 11:21:42 -0800
Received: by tassilo.localdomain (Postfix, from userid 1000)
	id 3F82E302B3C; Wed, 17 Dec 2025 11:21:42 -0800 (PST)
From: Andi Kleen <ak@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Hugh Dickins
 <hughd@google.com>,  Jonathan Corbet <corbet@lwn.net>,  "Matthew Wilcox
 (Oracle)" <willy@infradead.org>,  David Hildenbrand <david@redhat.com>,
  Barry Song <baohua@kernel.org>,  Lance Yang <ioworker0@gmail.com>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,  Gavin Shan
 <gshan@redhat.com>,  Pankaj Raghav <kernel@pankajraghav.com>,  Daniel
 Gomez <da.gomez@samsung.com>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 0/4] Control folio sizes used for page cache memory
In-Reply-To: <20240717071257.4141363-1-ryan.roberts@arm.com> (Ryan Roberts's
	message of "Wed, 17 Jul 2024 08:12:52 +0100")
References: <20240717071257.4141363-1-ryan.roberts@arm.com>
Date: Wed, 17 Dec 2025 11:21:42 -0800
Message-ID: <873458zzg9.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: p73iwph9u7oss5fsnigf4gf5pw1ends6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91EBF10000E
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1765999304-750070
X-HE-Meta: U2FsdGVkX1+YieZ8W9prdpbDXYU77PnM4GtWvoeJ6jktn5vLPdQbwbhqxp5B57fr5uEDUOVa8Gf7dUL+AMlQ2SSgBrxqxsMj7F4xhN+LzZjgLB7UOIsZIdLioy4GTfeOCDtp/4yhiqfXIgqfadFW4t8cOaihIEMEVeDtmwa0/fezQBMZt5ouGGbLHqRSEd5ELV7c7dt3GnGhqODhMrblMplgOZt/yUFgytOpvzQoKXIvJ6rQWn1hWw8W1u4jvYlr+2Q5JldGyMdixjL4i1Og5DgVr8fJbXgNNMtQRejArNGetXGME3Uv9PLBUNa0BzwtA2icTRMbXIGyrpa66V+SrCzGO3HMU9Km2TNkL/+VT6LBkq0jgYmp62HEjYr2I36QHJx2oM5QOS3Bg0foB/1LUpqnDI7k/5FPx/af5Fhs+UJDIz8al5Ij0v6cLTaZUI6/NHgR8SCk3zeunqu2k1eL8sFsGJlPJNrOrJ/BuwWG7P/T+2ZCiXmQjH6DfEOcePYLkW1RQhkGTBiwtKJ1Nq2OMyA4Exi4equFLWfC+7d5tuHpVSu8G9QjBKnKADJxdX6vptWP6rAgI76s0tsh9RzTefoDYvfiD/7UUyU7MExw1OX8yLz9zxgbEWCl3PAzER0c7lLqL6zu8INVvnco+rBjQu83sa9RUMD2FGdiuUbv+IViZdzrGjXwRIbLKICq8d5B4jm+Ek+8TAGWYebldCLYGPFnJuRFQpLDhHfLwvSsAIDVSa8J1TxZ9nThN3xpvsYLK2QjBteo71ZbJf+tsM2SkdY0kNg7uNbGvB8RTHKJ+RbHWK3YGXZFoTs1Gf0RHpa3j30Mb4Z83E1SQU3JX27Gpg6AB6aKCQbxJTeC5uws5DCFg4AkIWzVB7wVWYmuDGrFbCwxY312oQVbNDSbZWHuDF8qyKBIIrbOR3SICT75XXpH0M7IIJiI0vk701VPpR51VF6nW3JyYXCoSoYzsS5
 JaWCf4h3
 PgvqKSurLa8KDyrQtjbEcWKnJRoM9U1cVOifSOvtrUIrcdIZaFaLDhfn7Az93vL6ywweGVu38EvlEbowOQUPTZUuNfoZfTAxzTtbbmUhj64wAeUmCBiuE/6on/IQp7WL2uJYLaxxrgb0lC0d/vh3XpuIx6+4WrysJkIvN5mEFVhOodqH1LIugktuzQH8cpEXOmL7sYCrSnSbgMXZft9g1zcINq6pT2aumPD/aB9YJgRVLJMI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ryan Roberts <ryan.roberts@arm.com> writes:

> Hi All,
>
> This series is an RFC that adds sysfs and kernel cmdline controls to configure
> the set of allowed large folio sizes that can be used when allocating
> file-memory for the page cache. As part of the control mechanism, it provides
> for a special-case "preferred folio size for executable mappings" marker.
>
> I'm trying to solve 2 separate problems with this series:
>

What happened to this patchkit? I was looking into how to efficiently
get larger pages for text transparently, and there doesn't seem
to be anything better than such a heuristic?

Thanks,
-Andi

