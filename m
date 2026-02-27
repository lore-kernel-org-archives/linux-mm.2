Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED542FEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64BBF6B00ED; Fri, 27 Feb 2026 15:44:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613126B00EF; Fri, 27 Feb 2026 15:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515C86B00F0; Fri, 27 Feb 2026 15:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBEE6B00ED
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:44:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BEC0BC075
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:44:15 +0000 (UTC)
X-FDA: 84491414070.03.DD90C48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 24C8D2000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:44:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oOAuOjkU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VIkt358Etf37InD5BtNd6N3/4Hn7wIs0q2JfQVZj8Hs=;
	b=10TT/ySj7vThFoIf/cms7Dv13ilGHVlDr+IWR+q0YkhFM4OdHR/r3v1zKkk1gLvB3sU2mR
	50hBu3o6LDBNdDuvsj3K1pw+++UC/Zl5m8+InNbGRj7XJccypVOlP9XWIfu4ax1C/7CjU2
	4co0hYEExwRSoDGiF++T0wR01atO7B0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oOAuOjkU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225053; a=rsa-sha256;
	cv=none;
	b=V0SERH22DxvTVKmyPDrqrFF9rJ2iBJ5wtF6cy/EzXg6jlrn2Y4M/7oxhYoLT8HnVrCzopm
	jN54qoG/KyI6/dWjb7Lv9DTSEsaGWMDwYFS5oufSVX9ta74TmrhSwrTk1zNTky3zPpGG91
	6W8RCsX9Wi3zyc6oOMkG/vxK05l4kHM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FCF460126;
	Fri, 27 Feb 2026 20:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC9FC116C6;
	Fri, 27 Feb 2026 20:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772225052;
	bh=RlLz8Nf4AkH8nV2nxyW0Rxk/9bF52X89NSCa8ZhU4q8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oOAuOjkUW7IMZGQo1i21CTSIVY4JFqKbBBVzBQHEfOB6DW4g3pTxKqT0HrN3xBcST
	 I4yLuWrb/S+kyiwhNBguxN0eQmLjX3Z/9TNeSMmlOAe/9CT2SN+BGGPsFkpm78GRAW
	 wRVFvUOsebWDu+QoYzJqdD5JWZ+35Lix/699e/L9UhApjIJEeWpTbgRc07cXtoVUx2
	 hgH4I1XJ86b2WoKkXKQOLU203ANhQzMxQU9ktGQFvP0tVqpyPonzdfBMbQnZtsnVW3
	 G4B64tPdKNSB/D3YARx208WO6SfNSzQ4NWEpyFscgTKv/F5QL4mVmkqe1OTvWIaRih
	 f0rswjD7njamg==
Message-ID: <dc86d6ea-ec74-4071-ae88-1fd8c3313ee8@kernel.org>
Date: Fri, 27 Feb 2026 21:44:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/4] Allow order zero pages in page reporting
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 akpm@linux-foundation.org
Cc: mst@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 24C8D2000E
X-Stat-Signature: ngphstxsr13t9ifyk144doe8b7ygxae5
X-Rspam-User: 
X-HE-Tag: 1772225052-264951
X-HE-Meta: U2FsdGVkX1859W7s5/Ns853UQ0iBd4SiDP8QDJvGK6Y1Ppp3330y/B1+rirEGzqlhuM3MxgsaO1zPMih+w5qnRnsy4UbozAyqwNBQ8WMkX8ru9tG3e59iY7SX0c2PKLNKub2c6dnk4n9tSDW/7K5iaoQrE/g2W6B2pQp3ULu+7IM/1U/E95crCGDIcgkTE5fskeFmdL52ti/PfMFtIVms0WZtWArWDj1Z6oCPnCagagJOLGB+NErOcOSyvVD0J0045vVs1SJhMy1MOezrkGN25NlpQzlAj6bNNP+0Mr5cGyXhZ6Qmxd/BZOgr6UaQLDsQsadeJwHXm7OxSXdFuQDd+BkZNV4ez8OBSRMWgDglpthzt9F0hsFYL+aPj8y9x9b40F7oNRyOvYJIL/OkSgSR7ietUIIM0Eixpgz4XsQ6Mb5Ei9FtAHXrXtCvtyUJLl/qNBCSgU9lzmK7GgqEwNsCyFCCIUJ4OnZXnceG2XfCAGCouFrjHGFxxtrS2KoriIlBJAsG4DHn+AtBG92kbSnhQ6h2gYWVI3I7eNvRnr07sb9wUqrcwyxN1N01MhTmX0HnyqnTD4dkNE2hcyEjVeMQsbNStEBZqfYhRN8rYpcu+XUZgEuKS56Zrz3dYNRQUj4B5EI1CnkOjUm48OoeWckFTqrmffoCzIJ2RJaNHH/JVNDpIAdzPok+/IIQbFqik6jSFqMGCiOUFDvJrmndDgrpKxdl5Bk/CN9cfIy5XwCgeGz4FnflpDNJfO4wiTatvJ4IWPF0h1gmOuHlx+svp8P8OhLG31G5Rd9+blcFdgeCjYtTunJqYI2VZLpzXuHSKmuDT2c8TtvcPh+eWeZ5Ac0C5n916kSYrUydjGimdXQxZofcvaVjMr62N4W+y/IhGujrZKLpH3fFvkGqI+p2ARvqg6D5wH4c2JryP0c95Fq4IXTDUjqzBg4oSEGKyy6gqsrAKfMZrXRDo3vKhbiCWh
 Wq1u48j7
 t8OONIAjTFnT3xrsEwGyI5qQPkpP046ezqetriSMTFIqNGcDgUxT9k5dqUMm0HhdqL14Bn2a47WM4Hsb5cbwGrh32XMyccMZaUTVFiOUrgY92RKwjmba7OrvRiQ6z4pv4K+N25Rt549Ggl8ucrI1/7/oQbYHJeUB8ZmuFxpZfphRwCxkBwjkQqbjwY2UoyCDx/oP7+SUw5LBZj6XaM+MFCs4RAd3LrNzVA0ICz6/Oak+sO5Qvxz2ZhZmVWAu91jKnEa6i+ptaDmxAB1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 15:06, Yuvraj Sakshith wrote:
> Today, page reporting sets page_reporting_order in two ways:
> 
> (1) page_reporting.page_reporting_order cmdline parameter
> (2) Driver can pass order while registering itself.
> 
> In both cases, order zero is ignored by free page reporting
> because it is used to set page_reporting_order to a default
> value, like MAX_PAGE_ORDER.
> 
> In some cases we might want page_reporting_order to be zero.
> 
> For instance, when virtio-balloon runs inside a guest with
> tiny memory (say, 16MB), it might not be able to find a order 1 page
> (or in the worst case order MAX_PAGE_ORDER page) after some uptime.
> Page reporting should be able to return order zero pages back for
> optimal memory relinquishment.
> 
> This patch changes the default fallback value from '0' to '-1' in
> all possible clients of free page reporting (hv_balloon and
> virtio-balloon) together with allowing '0' as a valid order in
> page_reporting_register().
> 
> Changes in v1:
> - Introduce PAGE_REPORTING_DEFAULT_ORDER macro (initially set to 0).
> - Make use of new macro in drivers (hv_balloon and virtio-balloon)
> 	working with page reporting.
> - Change PAGE_REPORTING_DEFAULT_ORDER to -1 as zero is a valid
> 	page order that can be requested.
> 
> Yuvraj Sakshith (3):
>   mm/page_reporting: Allow zero page_reporting_order
>   hv_balloon: Change default page reporting order
>   virtio_balloon: Set pr_dev.order to new default

These look like old stats :)

-- 
Cheers,

David

