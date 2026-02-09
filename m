Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A4BE78D40
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D839A6B0005; Mon,  9 Feb 2026 04:02:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54D76B0088; Mon,  9 Feb 2026 04:02:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C579C6B0089; Mon,  9 Feb 2026 04:02:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B11466B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:02:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67A5BD637A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:02:19 +0000 (UTC)
X-FDA: 84424326798.14.1D87CCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id AA72E10000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:02:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aooR1E8O;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770627737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85a9YjU4OLYItq7leieNQbaQBkof4ldvpegJfdSNQeY=;
	b=bGJKRfzgG0d3iC3+NEtp2mMHHbzxFCfVq3ZEYS1uy0Iiepor5Z6YWju5rgr9x5FfIsL2c7
	Cy3Z+iNZGVyBJukiHaJAWQnItpf8O0twGdDgZSFp+ONe2UwmR2S29vUSYrtCRz4Y+ra5r4
	FUVCfJDPexo0NibeFDy28IQzZYwvCow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770627737; a=rsa-sha256;
	cv=none;
	b=5yL7bX0bUiNHqT3/Hu04M/GTbFbB3IcVPfIK3CJjp7Bqoo3x+b8Mfnoo8sueybRyfjnDbo
	5qttbLZsoGYkIhxdJUYOEqfRPu1YsmawMbL2LU1nf4pZGLsuAGbI+MUJOxFl5toc/6Ci36
	mBUjyGSqlb7iHfWfsqXNRb30IIMDoqw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aooR1E8O;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A72760008;
	Mon,  9 Feb 2026 09:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB3AC116C6;
	Mon,  9 Feb 2026 09:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770627736;
	bh=IqYPb7uxcVEDubM2iI6S4mJSVpipfr/6hbS4fQ/JjkE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aooR1E8OiLDayk26Vp9o+xj1QOeVlFq4+eqv4GON/kuQCyEirPFCRzlx6GzydAv8s
	 Q9wTXw3+NL01009BR2YHSjyM2kDujJlfqv4tuIxWIvE7hQorVqYUBAWVJe+Z04TqQf
	 8K/bLYb+w31fG6n407ps06RIqOa4p+bmfb96/cXXi8zNWjAnh8pPv+htpTB38QMlwO
	 3h5enCy67VvkAbAAHZlzdTymjIoZoj6+Ip4jdEGEZValrnXiaFPpu6QZB8C5bBdYdx
	 NPQ4T9SaDNx02ILS+ReVgOEC2QIhEX4cNtBw8/UiVWLTKLE1uNtmzX9wtYbY6OcSlh
	 U3ffR2p4NBEsg==
Message-ID: <424b2acc-68b2-49e0-921e-08451ce5a30d@kernel.org>
Date: Mon, 9 Feb 2026 10:02:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] arm64: mm: support batch clearing of the young
 flag for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <a5138065a70a7588904d0bcfc569a5d856dcc65e.1766631066.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a5138065a70a7588904d0bcfc569a5d856dcc65e.1766631066.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AA72E10000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: r8tg6byg6y4ctfsbk8fmwiffi1db1xkf
X-HE-Tag: 1770627737-874643
X-HE-Meta: U2FsdGVkX19MS6SlCRqvKhvh3Na3oy1CChV604kDvRSoa6/CgHtV/uT9JtWJX0as/NsaK7489du8YD458h1KDfE+MnVMEswlUxd7ah4AFKSwWuHzDIrTk88n4UwMKIKgXhwdhPkSwvZ39wr6JardNDT0XPO5padAbSeOPKNI4PdchH/wLAXLUCpqT/k9K5k4Dp0f22MJeLGoGoKp7RutPBsCaZOJm3/DtcwuFUy10/OQD61gjWKp2GLTJVQMBJyphqDXfzdPbiV2v2G3lE6KWgRBbmHoq9oH0OUCwFx7qCXnDyW/UCzqPjsMCpRjCuR8TZtJi4wT7Ar4w4ILO7Qx21Ht+0u2dX1HfFiyQj04kYsJp71T+Zs25A4WIsLFyPnf81Y00Pw11Y4wuYI+wta9iMyGJIsGsEX1M0SQjd//nSBhTNwsDJx7y63CmKP8NcQ0L5eH8aYlmdBmgKTxnU3co9DMyNO2qIWpetwMgkNNxVGM5rh7Pxx4RLDfnP58XvGUE+rH37MhVJBn60exL6H9aucjulArgqAHA4SlmN+24E54YqH9O+c5wS+ISWB7pnwwRztLcHHBgsrWbOrnVWkz2ksg0uE0va4+cuNXQDl6MzkfR9fU8WrKhtl2Jmg8PVQFelHrH1zgoZW1o8svYjEiaU5PkrmkHYofH4kOYlu+Tf24+4HMA3W3jO5Ji8Jqv3RS4aWWuEZ/XHA1zAE0H+H5Z3ej/mzySWkkiKmviIv3r9VikbDcEQ/nbhLPZYuCCydxiZxf5hkeHqe05kuqfm3Zbjy+KqP+HfhxIHF4FE2D3VYxQclPuiY56AB4237KGVzKi5armtpKBO+mIhzRmWCIIzN0LIARdJs1W8E/Vii91oloh7gEfrarl+Fq+HRqP0xt1yoJeBYPAf32RgpcbzAh7mJUXMk4lUm7mkBKYcXvoW2kxBgMXOtV5XfXa/Ixi6bkpn0VmpRjI61wXDZszju
 TXIBNQ5w
 T+kKlCl/NuDAk5OLYLJX8JLkSXjzqD/iO9Cuv5V0SOC1em+R1CUPsmBDBzcNaSaHtxrQWhf5dBl8sHasi/QFXPXu6ksZYvWgVtJsG5bgAXqTKAMbHQCT2SzbB6KUkAuXm0yZmNT2Z5WAPCxYJyw8njM/X6DDFVTPbGBRyxSx+YxP6YFPyiHH7tCjKUZcOQlDsxW4mjXLLL9SLr0p7rkMm2QvfmD9pCS0JZtYkqPbelSiV5Wb5WkfqX/V2k3nFbxvt7z4cQsk4g33ZSmJjeWG+y66x9o+SdhQ7KZGI/FaRIuY+6BBCi7qrAO0N3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/26/25 07:07, Baolin Wang wrote:
> Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
> only clear the young flag and flush TLBs for PTEs within the contiguous range.
> To support batch PTE operations for other sized large folios in the following
> patches, adding a new parameter to specify the number of PTEs that map consecutive
> pages of the same large folio in a single VMA and a single page table.
> 
> While we are at it, rename the functions to maintain consistency with other
> contpte_*() functions.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Nothing jumped at me :) Reusing contpte_align_addr_ptep() makes it a lot 
clearer.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

