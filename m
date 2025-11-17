Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E5F1CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBC98E0023; Mon, 17 Nov 2025 12:29:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3A28E0002; Mon, 17 Nov 2025 12:29:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710E88E0023; Mon, 17 Nov 2025 12:29:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1608E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:29:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26AD1B720C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:29:21 +0000 (UTC)
X-FDA: 84120785322.08.7AE0A25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A68A10000F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:29:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NsOQHBae;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6n3K4+1BUZDPVTpeIuZ6iOOF1OCgcvOlKvp+iGsdPNI=;
	b=S3MdqtKKJUmM1XEQE4Rlyl+oXOm1n06aGeMdntrVLXIlpHab4x8le7NtLPX9RZGfzjBH9w
	H9Q5mbwliBio0bua0He+7iHdauCwqgVRw8onyfgNlcgQHkAQ9/bbXusoUYJKNPtGR7WDF6
	HG9iSpWmtnuTcX0LWn3wTfT/XlkFxys=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763400559; a=rsa-sha256;
	cv=none;
	b=5zRcfPOugAWrpAVYZv+kuPjpnYW8gj/l5fE2J+wGqkXRTzjnfJOvNgfKLu7pKY/pTgEBrP
	9CpEf6hLqiDASHI6lnbMJFS4D2Ip1VOck6QRGxT3Am1CkahOtUdIUDYTgLmlhgZjP1otGO
	gVhMaVapUST+vEEJl5RvNE/2y/s172I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NsOQHBae;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DB50437CF;
	Mon, 17 Nov 2025 17:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E81DC2BCB6;
	Mon, 17 Nov 2025 17:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763400557;
	bh=5fuyBRFToytUfwqSY0pJBUV2Wlqiqc30tdH/B+noNJs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NsOQHBae3rMp1MLAY8vLeYbKwV00SeV5i6DAnAAdZGRgUgQSiwy1q9sYmnKSj98dQ
	 0YZfUD3v/xM/PBStZVzJHCdGAG51Taql51iEbwHwgGJqjCp4RbonERpG0v/XMncoq3
	 IWT56uKkv69qInTOzNjLqYigcTrswI0heLMBZ0w+lAt8koFDCA+dWsUt0cHLWUv4Sv
	 desL1dMY+Mb1D3fuC9/spUjoBbLelj0F++zvbofaABTa3AcmCETtmPZnmljjFtOR5N
	 Uee3Id2OXsyCZ6vcpJpXuJ0+/1cdhhnAW108qZzyls0QWZU/qy6Tot846cslOrtbSj
	 jBegBz+Ti7AVA==
Message-ID: <85097134-4887-4aab-bad2-18084e3980c0@kernel.org>
Date: Mon, 17 Nov 2025 18:29:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 04/10] drivers: i915 selftest: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <297c6fa3dfc50c28c05c0974c86a205984d752ed.1762464515.git.luizcap@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <297c6fa3dfc50c28c05c0974c86a205984d752ed.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A68A10000F
X-Stat-Signature: gj4c56bhockcbn9indio6tz65egtyngh
X-HE-Tag: 1763400559-651058
X-HE-Meta: U2FsdGVkX18aNG0HLAOFUPvTLO2OzyzayrnFDFGYXdcAN+FLMEvbIanhSBqD251nOIWCIePmO1Z4+t8UHs7wov7ZiyBoFUZzgp/hgBQJ1xiuObCSGoGChnkRsG7yuFI01XbySccW5STgll8E125r0poFfTVlPSBW2qJLHEfT3zeMpd21Yfv+mBXRywqTWMqvSXu1DiKVdFUR6lXSWAVYWeX9mF064oNCxRR35EM8H2z4pVlmX4SMi2l22DJdAS3tHwuV78jLHSriCQf6yHbTi65+EPYBg7Rxi+Kywz9vEplsSo3R5s1omg8OBBnTmCnRRoPGvpjQMl65yJXUmKy8AhB8U0b3jR/yu/x3PuxMmymjIecUvIFBWKpGfW0hoDkD+vC4JgUPXicBORWo48pjwFTBwiCa7FhVL1M/vsZvJTV9CqnuttnAyjPEsRCi/pU4/H+Tg9+7P72oHzYu+Nb5hUODcwZrd0FPBI78/TgFV/UmVloV3ntNApjNYtiAfFKyZY2WubGDnCZ5sjLKDBop0xVV7b4BNjGQ25s7kMCkH8nSMKgK2Cw8C80oWON4Ygavk1frByn+lVZislXtoKrYhfIiz+dOwqIpaErxj9Spd0UYFrz+Xqf82+hgvhvIOmYZqIRqKVo4XjlvV1GCF9Efp6Lx8ZsEpoDvnjYesWyu6w+7hiI3FKdNxNrA1ehvVLfh03REB8UHuLJyG4iI23vfOklv822IT9K2csh2Ub+UY7e67thwrR+YBS9y3RHbEriRzZfc+Vz+UW8tcRf8JPve9LkdBYGpw7DS5+GO7BEpvRV2INdlRMfAS341HDSbeW41JpwCNNCYO55J2Q10764e1psH1u8xO8C57wmdZoSjS0KTMlSThv9IlGGUvJYO4PD+MNFIrNK0cJI1JvmEZfBmURvG/mLh3pn7IyrDFwRaBNvF/GyDZtOjJiNhPesslbeNNmaNCJPAShm1riUGaXi
 KW5PeG1H
 LDzD5F6u+Sb9Xn7aTggkiZFb9aYSEQVUC0c5y9a1Q/ISGc83yT+JO16z0VMBUfXJ+OBfdviO7AacmBxLsRyk/dQZG9NvvK//ePamXl27W75e41XYiT7J0XyFlvWKnp+Sj8MxqKV5nzKg+NaC5fZPzAUqx3csdxc7cEKeqeX6V0fipv9CoOHLXyfhjcSMsIcClPnNLjbYpk5SRPO7VaVr8muaXxvppkkN/Kf+87EspzvIsY6J8X9tPggCLBWmQB9Islkt4/Yfk6lRvSLryEpWxRMUHS+/iEv3p7ILTrJrFaaT+rR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 22:28, Luiz Capitulino wrote:
> igt_can_allocate_thp() uses has_transparente_hugepage() to check if
> PMD-sized pages are supported, use pgtable_has_pmd_leaves() instead.
> 

Right, I think we really only care about PMDs here for now.

-- 
Cheers

David

