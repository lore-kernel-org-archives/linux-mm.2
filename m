Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72062E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 08:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA576B0089; Sun, 21 Dec 2025 03:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81C16B0092; Sun, 21 Dec 2025 03:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C256B0093; Sun, 21 Dec 2025 03:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 946876B0089
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:49:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C70D12CB5
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:49:37 +0000 (UTC)
X-FDA: 84242854794.12.0925834
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6631640007
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:49:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lGbri52D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766306975; a=rsa-sha256;
	cv=none;
	b=DfsPgNPRGIqjJj/TWZWkOgkBa/aJaVaESawSlevT6f0uCX6mV363PfGIU6ONPXSNx2yx0w
	7JfcqPvFi8DqEQWXISVex6/3TO3zArx7+Lkn+Iw6Q+HcOyiWHYgE6TgkxevFCLLKYh2mym
	Q9agVLx1/tU8hY1MM7Nm2sFP6tWCEso=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lGbri52D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766306975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nn0AQBoHFUbNh1s+97CdXlJETk7Cdubi+xGDWLxXBB0=;
	b=dD8H0o8vTMLzCf6wMywcVBR1LjDdpmsaBbIzF/8FeaCfHBarySWVcMEjld9HXV6KyrzLik
	J9O4WkRbdsfe1LGwOHtMwofuHOYaVGtNUmg2dNyAUIQ1+3OYro+NjRor/KP0xUCSDjW0QK
	s+xc2srhIyq6QfEoG8tFmK6J2esixKg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B8314018C;
	Sun, 21 Dec 2025 08:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00A3C4CEFB;
	Sun, 21 Dec 2025 08:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766306974;
	bh=dTdOmrxX3GbIoyyhepzZvaLNQrFrNZvGnXmKqjQ1kRM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=lGbri52DpK790+FW93/VGnkQTq9SDWFYa+JzRn3mxKi/GVQX8MFhL7kV7qYz5/1KG
	 0k34oPK83TMAYySonVlotv3Fw4xvEYmdHFeACMo6lXhgOkyNRhGIDWBm6jqQgF+pnv
	 rhvTM5WAL+35FSECT79LEa5D4LRal2EewobmK8i0k0JAlanSNF/Q+95uGxR5BmiakB
	 viTTatlNijFz+yF6YZVLouiVramFw5XXRPiNydEHcpTrQzI+ZIfWA5oU0CMI9z4bQ5
	 XD7cJ/IuiMHs32exlF+RxfbBaOx/uOWWkLWm2ec0jgjvhZ+xDlxGhpYlxXpWYS+qSP
	 K+f9CpB2S31pQ==
Message-ID: <8b8dd99e-78b8-4786-a175-6131eb6b7c3e@kernel.org>
Date: Sun, 21 Dec 2025 09:49:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to accept
 hugetlb tail page pfn
To: Jane Chu <jane.chu@oracle.com>, muchun.song@linux.dev, osalvador@suse.de,
 linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com,
 rientjes@google.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251219062819.2499399-1-jane.chu@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251219062819.2499399-1-jane.chu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6631640007
X-Stat-Signature: 1ruspb1e6a3wkwwz3skfthgmmofacbec
X-Rspam-User: 
X-HE-Tag: 1766306975-590561
X-HE-Meta: U2FsdGVkX19URee8bYL8sncR8FHVbMbELvgxJKs7dQ8Jj06BmnXVrWm036IJIv2zsxPnEZrJpLm8CcUCHWDnnBkKfBzp1lMIQtmEBokTTcD8y3R2UxDI0fX4DZ5S39N4ZPzAPZH363OmPk3yQo35akbKe1PbMdBXvBwNSnRmeeb5JUaoiO4sOX3SJZ/6qK+IJ2HgcU29E0lMMCyRz0fL9VbLuFqtPJ+8Yi90G+CO5yn6kcx8BOoZazvVSwO+HqiuvkOuXtnLVtCdPY4Z+V0Mq/MIqIhKbIlWS3ylMtiCaLNmWBjVlyeHt8PnzkD7ow4MYil1md3fMjUERgJjjx8+lbO6Pzo3ixR3rFiJItw8YzBORjFZtuUDE/IPgy/zHfI4aT+njz0rdHqMYvDqHkgJjkXxJkRRe4YJCMZeDx6K1hF3tGu0GB19OcOhJJCkUTlKNaO8AeQ2zAzmDS7rB/tHCt6v62xH3W0b9UQgCGcNYkpeqoGANhHCvO1b6sN46nfXnakn1uD9qMd8TFK8hayhWqo27ab/KWzwv3IuBK7eqI917IhEZqK8CRk0vjd8Hp84iYJAAXOgvTAJh/DKjb5yfSpD+oa3jU8EFod5kws0uvgI8NsY1kZpm31pdzZ1rI1rr7fVzlpEoojdo91A2VB92gScfaYIKG+sWRp/5z5I6qPeGHg6kbXCtbSG6i2UivC30KDUg+rbBqNm/ACjWSUuxXKagxbBr1ClZzsaJGImKkBOxhaoArbGvvFEgtkFZdD0utqN0hzLh8VRfSXDrrj3N2x9nEdq/KNhWDIsOwNhWOq1dWkNwfNCtupr7GJBWpFXNjqW4NBDbUyBNEWBVY8Co/UDjCz37eaHGWMIT2hbXsxeOirsBflJjPHSwP22nL19YYjGSTpngUpVewZT+eaSd27tuQP3TGE8UxsSbONBrxgESkGW1EJxuG6ZIsF6uUUcf+CoSS1AmdiVQVOtxP2
 yvWbfVSK
 deG+X/p079mFfZ4/z052341u0NeVXQtJGCQdxSlR5eqaUpLIIrLYTDIyl25HIQrI7hhym3BjjZ7PV2AltEeiIQO9R92Hblkwnkl298DR0FFHZIr9keAgtg+Di3fe2HT/NXPcWX91U8c92gHr1MZ8bJbnSuD1v2dU3g/ws16rL88AuHHhFbSLpCfoiGSKyfOzX4baJi6G5fyDJEmGt0if1GEEFBJIkGtN/NFDeV2p/H5bnGwMG1X+eQfpCbkjf92SfBAPItZnjeUjwx9uaWPG95bFbuTZyJya8sbEmgVUBCc3V7RZoWyQSO82mBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 07:28, Jane Chu wrote:
> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
> passed head pfn to kill_accessing_process(), that is not right.
> The precise pfn of the poisoned page should be used in order to
> determine the precise vaddr as the SIGBUS payload.

I don't think so? IIRC, for hugetlb folios we always reported the head 
PFN. And user space must assume that the whole thing is poisoned and 
will go away.

I recall that older QEMU even depended on that behavior, for example.

-- 
Cheers

David

