Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B15DFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 16:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73366B0005; Wed, 29 Apr 2026 12:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFBFD6B0088; Wed, 29 Apr 2026 12:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14256B0092; Wed, 29 Apr 2026 12:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 926336B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:13:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 531A8402C1
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 16:13:10 +0000 (UTC)
X-FDA: 84712087740.09.63C85A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8416A14000F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 16:13:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jcA92KrT;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777479188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vFVN7Kin1nhN2r5SBUVavKKjBx5pzFJOmavyYzOZmY=;
	b=xF7bRZRerxxXH2WnqMOqBLmAG9/5Oyqu5pEQHzYCDJZRXjvx0aleRTI1BZMWOCEmjNu02R
	XHdE54npXGojukzn7//vJz6X1CGhuectrKhsmX1XvnMI3PhDjZ+98GMCTGTxWuM8An8nmD
	CRbG40lbCazLXNUC6eG4L7d4EfDPySk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777479188; a=rsa-sha256;
	cv=none;
	b=hiSUILBGH+BLVkIYwzxANWHPLW5NGN5cVj1083dsLs74p98DzGBgLkZAmJLw2jNRb3+ol+
	/D4vEyihYOLL5QPjSfex6JuQU//TU4lYo3kIrL3Zf80D1M0uhIjfVN99zrAsoVGrxfNJa4
	WlR/KG1zbuHDn4AJCqp2FOulC7kO3oc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jcA92KrT;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72703417E3;
	Wed, 29 Apr 2026 16:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDC9C2BCB8;
	Wed, 29 Apr 2026 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777479187;
	bh=+vFVN7Kin1nhN2r5SBUVavKKjBx5pzFJOmavyYzOZmY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jcA92KrTNs0OnsDplxqE80x6fHHXTL7QPJhx1p+U/TsX90ivdKhWaMnApqeWn5VnM
	 uywt8NYVjxKNJk0sbEz6e261uEkqKwumAVA1mP64nBSK2PczEqjvnA5Z4RMJgea8Mf
	 lmQxnXMi3PXiEOAxLXppMhDws0pje8NY59geYpow=
Date: Wed, 29 Apr 2026 09:13:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 00/14] Remove CONFIG_READ_ONLY_THP_FOR_FS and enable
 file THP for writable files
Message-Id: <20260429091305.fd5a1c8c986c111527c2b024@linux-foundation.org>
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8416A14000F
X-Stat-Signature: 67464r5bmw5onsy1rq4rpar9qhfqr3m1
X-Rspam-User: 
X-HE-Tag: 1777479188-424371
X-HE-Meta: U2FsdGVkX19wylsRsmAXKPwccfeBsi3VX9uaUnP4RmkEa1FGktwxA9cbVsTnynCaTv0tIRIap3GebGsMu5TkypVWYPp1y/f8rLCgQCszPiYdYePwENOCQs0dwIoGo4Yu8mb499Ggf8Z067xkbHuzIY3GlEUEyzIXvvatDq7PpAzRnPoFQ4xNOxTocEMToQMX2bwaEG+Lb1MU9MS1K57Wm0N/+DXvoRo7Q0j73V13WEPSGz70EIeIRXxGCa3ZjOyMnrbraQM1fAgkBabd6e1wruGyMN2tUJwcn0QZRJ6U2jdppsWJwX7jP1KGo9mc6JafGrXH4v6t6139GZG1g+tPZtGwsCJIt9PznsBBdyX9Qr+fGliWPeV5N8/uhIkm0JsLypc80IfUfKP1aLywDo2kLr33akc4y134q3gb6zGZxdxKXFqmvcgEjAORepqgS9tcdWVUQdcWFQOvicXv9aC16nzqLN1PA5vrVZWVCzcalPLN8+VNeiDudMebTz7eXoy8+IdurkF8X/DDVteixVK3fOUR+7ASVxRxlDNTH8dE85x8fmicPeP7RIrkf6OKRJ6eZgzzyYh6RK6i02vnXVDCA4juYuEyHIVityk18QwkOsVGBghAFuPDaE2l+Ud+uaEYbl0oCRRzozlfS3Ex2hzsrTBEXf9gDD2O7VT7l1lkOwfIW55xm9TdPEPhUVnvLccTyJwH7VEdpGNrWl1Zx/Y9XCTP+R7m83PA9v/BrAO8AgKnPqOWQX8Lf0TDTZgLN2Z+m1vxqGh31HcgfP51SSSSohXUU/IfEf/bGPABW0a0BjisPcdLIQkQRHQ57h/pwaYHhbPUmmq1oWgwNZgyt6wfE7/HzKs0fOYfArQZqEu7PiPRmylbyeusL/73i7L0KsRCaLNWSlFe7GADooG8UG61pA3WnL++l1SpV6cLiA5WWtdJUM5lbFesSs1dtvdXbisYuZMzGPqqYSCFzGPbQlT
 0vlynMWE
 L/kUGqe2XsNexXxs/g25aErpI1RzEVe0zfGMbZWxBlWCFGur3ulxtBs2fhREvgRXqQSMGtEIS/VVMIfVHgVjnp+zLajDbGSSHBrv1sXbZ/b6Or34oIICH2NgTRmmofQKRYIkfyoMYQXY5tQqkBVJ/WV4V+oxPui8tfdQ+8cNopPHh/h3Ll3AomKDksCpu5QWUaW0hiMdfBpNs6TJ640zmg3wcGzgSoMmObcxsieOp7OybsdF7pOmS55E0xabOD+hOdqmhLgYun7SacsmlZYhkmo0DRhmvV9RQQ7jYmnVzDYBBDpO2Cfsh7/F+JfOfg4tGfEEk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 11:29:10 -0400 Zi Yan <ziy@nvidia.com> wrote:

> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> file-backed THPs for FSes with large folio support (the supported orders
> need to include PMD_ORDER) by default, including for writable files.

Thanks, I queued this up.

