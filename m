Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D40C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE4A6B008C; Mon, 31 Aug 2026 20:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3B26B0092; Mon, 31 Aug 2026 20:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA786B0095; Mon, 31 Aug 2026 20:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAAE6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:35:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD8F1C030B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:35:16 +0000 (UTC)
X-FDA: 85163324232.25.5D82D56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 20F6080002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:35:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tEEnlXgt;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788222915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TtgnC0qQbwgwZqX+/7An9hPq7Lj/TxBIjcu6YHD7uns=;
	b=gSE8JjlUPvdLrQVfr4G650UvxvOfEUrCST4XBdh2CrpAL0xGlpHx2bRsRzVfQq+Cq9UT8p
	R7i1dsvbRyxT8qrNtzOklxSZJm7BC0KJG2Dd4KeG3rSY5Tdjs98sUtafKjWY6UknPbKsln
	45PbqtXzWgCW/t/5n9HCQT+kB2nbc8A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tEEnlXgt;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788222915;
	b=3+WNswGWIb5zC+LXkvbsq9CZ7fSrpoPKN25hh/MHWP3tOxsnMjJIzT5P47qqwZmPmHAzU6
	qdGxw5htBHUh3n0tjQnwF1MdyFDcNd+smBCYjC7Zdj/+cVPgLDeBFf1MH5XAPTFsYowNpZ
	YNTlPJWbQJ02DM2oRBgPYpqqP0Cmu6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EF9140480;
	Tue,  1 Sep 2026 00:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E367C1F000E9;
	Tue,  1 Sep 2026 00:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788222914;
	bh=TtgnC0qQbwgwZqX+/7An9hPq7Lj/TxBIjcu6YHD7uns=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tEEnlXgtDQRrrkftouMH2JPPiUrbmkYxLIp2aqFb6fCxflQywXO2RqerlU5uKj9EI
	 Miwux2yRLUWC69s+9tPG8Gh3scHiXuoc+gp5ZTejr+N8lbCdZzfSWZ63s8yaLCu8t4
	 KSWX0p7SRQyLe4Dj7izBfdjC5ZHQx2CCa31Ts5rc=
Date: Mon, 31 Aug 2026 17:35:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com,
 vivek.kasireddy@intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memfd: don't unreserve hugetlb pages on -EEXIST in
 error path
Message-Id: <20260831173513.41184f1d27cd83f2c8f9b935@linux-foundation.org>
In-Reply-To: <20260831090631.29227-1-hongfu.li@linux.dev>
References: <20260831090631.29227-1-hongfu.li@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bgke5m4a8uh94tyitr8983rpye5ac1md
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20F6080002
X-Rspam-User: 
X-HE-Tag: 1788222915-998982
X-HE-Meta: U2FsdGVkX1/xeq1aDvq3ufqpUBei9lwAMkUlHTmQKNhv53F7WlBGfT4Kdw/6y/x9BsmWVEL2bf9u7MK6lBjxkN+gborSJzKlI3swpBQIUcJYVUJxd9/unpQQKe6BDHy/Kf+1hWBDxjqTEsXf46bdW0c88Y10BHf+W1nR4kPO6wji4jBzEAznH4V7bH52D1zu5jBT3w9Ov+hKmTov2PaiF9/qcNmwXlC6cKOUhIvZofyW/5rmcEUoJVi2oY7nZi4T+L1aCBbxjaF6eKbaA5/uME+S2nO88j/KtC4i/9ZNJiCKtjjyGpK2YH/T/elPgLZhSQSRiuAF6hzVoHX+H/YxA/3mBqT6v09v0fAkGvDVC6tX/MNySs6o7A53xJdYVD/abFB2cVcY5fMBeECnm08ACLs5AQ1ubLFY1cb4Zh7VJNXX/8CYJ0NYo4Cemr98me8YIDtoOkE1qW0IcM83qaaP2ckpqsGyFvG4C5pW2KapBhYiYEvcgaibnoVVddu1szl8OsbvVWtiykWI6JaRm39e2A6vbcX+QPXcmtg7A2nBj94mh7zV5kRfu/408RY8rcBCsF+kpsY+w7WvW6+Y8dfpr+jXlvd09QLECClq765zswKDCfqohlnC3w/qnTVNLdH4c0hRilK5B4BfQRTsYSGypoIghOFCQ8uFekiXWTOf5OeZy5PYprGajTVc3eIwjtQjkKMEq+rsgn/PQw49Zy88RTwREbz8GWAG9WsXL43nepgYyX9lZDdHawpfVRHpcMpjuRGSoLMJm3r6kOhEKtjbaYEzGv61svP+BvphxwUZ0F6MqxdOEY08Kf02VI2PtEce33NBhnXnLmZZREA1w4lkgqZ6/rHdFzmASfJ7S6Gg59ku02D01TghUUqfYY23BONLThvHvjxQcOV4I/tabWz6wShBY6XaN3Jwx3cbqnXtiBqr5dQNiJAZZer2a5z5nXxKh2s8IhMFvWhfSEa3DPu
 Hj0piTe+
 0ffSuVbmhDC9HvTpyNLTvR48/fqoGd3oODsLv1+bzujAUnEBAuXsvdrMyuFqNoKqlYCcHqoC0Eq94EA5/pQ8Drj2wxchyirpsYh6p1KAWkw/qTiF7XkuWspL6CONcWAWgFMNdbNuvACr9REfCZ2fYPtyeE7U/OV6urSeHh+Yd5F45JArJMoVn1I9ID9K0DyO/dREp+UPr6N/FauTNhgmIUB+LNqAXgT/FBHze3PSNOKzeD4xhiPftZB3Ydh9NkN9XEydIGe9u9nx9yjsSSVgHK+Rx46gpaiVkGvFlk2F7mWGd/jJSKsQ1s+4QPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 17:06:31 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> If hugetlb_add_to_page_cache() fails with -EEXIST, a concurrent fault has
> already instantiated the folio in the page cache, and the reservation now
> belongs to that folio. Calling hugetlb_unreserve_pages() in that case
> incorrectly removes the region backing the cached folio, and a later
> truncate or inode eviction passes a negative (chg - freed) into
> hugepage_subpool_put_pages(), corrupting subpool and resv_huge_pages
> accounting.
> 
> Skip the unreserve on -EEXIST; failures other than -EEXIST leave the
> reservation unconsumed and still unreserve it.

Thanks.

AI review might have found another bug and it suggests that your
proposal only partially fixes this bug:

	https://sashiko.dev/#/patchset/20260831090631.29227-1-hongfu.li@linux.dev


