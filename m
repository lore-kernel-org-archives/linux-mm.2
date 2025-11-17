Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65001CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF578E0020; Mon, 17 Nov 2025 12:47:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939EA8E0002; Mon, 17 Nov 2025 12:47:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828358E0020; Mon, 17 Nov 2025 12:47:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4308E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:47:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 022F65668F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:47:20 +0000 (UTC)
X-FDA: 84120830682.16.6D02F5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 378DA140005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:47:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fviSIzuJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401639; a=rsa-sha256;
	cv=none;
	b=iBMxaFaOhi/WlnoJ9qE2iq0Alr91sSFn8Uzfx9numoT5z9RbYizZbmmWTgnh5MV2GdDRcB
	KcBVLHW3POqmiRQ23LToi9RSNxzIil4owj8+SyGPvgPZvENNHampTztNDhWxHINqaitk1m
	Up6vZD2KemkCNO2ODAw2oLjuUVp+l7g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fviSIzuJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+0764ZtxeeXzMXMyJQmXtDI0MchZde3S2ZMXolpMs0=;
	b=YOCaCYbS6BTIK6lytcKQXZanU/5BnohC2pdWrBkAleRNQE+mqWHLjSdoW1swlpNfTIy5GZ
	f8jrap71ToTlRobpZaB6j0Z5/fwws8kkXchcmeeqfQO8R78iCROqewY1QdVpWFdG8+H0EH
	f5dixz0yLqqfjp2atDTug75b1w9gtOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36AAC4024F;
	Mon, 17 Nov 2025 17:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABF5C116B1;
	Mon, 17 Nov 2025 17:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763401637;
	bh=c7HjDFSK6LjsuzFlzgYUzOu7TuhUOCgicu1YzpNUjt4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fviSIzuJnpHP2yI+GQzdmjDTEUFRZy2J+Y9Z2X+WTfABUh4piSIttiLPInqvMnHjn
	 1qh6lCjYkOeYp7PtpOOY1iRnbt/tLBQRJYCiA7pZVs1C2gZgjv+11YURw3It6y9tpv
	 t2xBMTRn8IEteInxUlCZVY21UKmfjYCU9Xy58bwObeIOC8/HdHJfi1x2lGd01EZ1jU
	 +r+ffD0ScDQBv2n6mfs6/XONcgOvbj35my0QYLPsn7qBCokaP/J9hYBmJI47Hr9+F8
	 Q08iq71CUQWp4onZVdieACeHG0VJv4MbSasUjO6fs/3BKqf87kWjBUn0PuTIsc5fUe
	 QEVJS4eM5LaIA==
Message-ID: <dac20466-adac-4e47-8f50-87f4774fd57b@kernel.org>
Date: Mon, 17 Nov 2025 18:47:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 09/10] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <e9a6a123a03a122010cc10708391db901b11c7a7.1762464515.git.luizcap@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <e9a6a123a03a122010cc10708391db901b11c7a7.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 378DA140005
X-Rspamd-Server: rspam07
X-Stat-Signature: 3gmxq1keuogw8bi3rbsdajwpnr7m7msz
X-Rspam-User: 
X-HE-Tag: 1763401639-835361
X-HE-Meta: U2FsdGVkX18aSsB9nFVUx2ASp5NU2yxX4dYVTRihnDwjvACVCwI6kC1JOEe+8xIczTUtb/UN+UmdASmfug5zJ1OxoGtw4f4SJjoKbRcERbTvigKC5I53UTcQyQye4Fr//kqQDUUQyieV70JszgbUNgYbHpNJ5jDXt/RnbDrImKvkzE77+fqFPKcHaPIxRFMH+yyY0L+C9wMFVmY4xxw4VxCH//V3jT+H3x5omm9GpEr61Y9GupP8EWiXH2ntwW8b8ILga8CSdW6Tt0/W4uQEAPPCNTBp0gkE4NXsJuMvJtSV2oO1reXmmKpCmojutAIT+rPIRyGE7dmsynKYDuQvn2djAQBLSCMz+DsepmS11SB/QRccROJuMPgvaw8mmqHBe1s3giJF9rhbtMFAoxFROGzFfM0tN6tOKelgwDxgF8gBhOlRZPTU/ETtwNT7yg2KRr6jJmsApTgfohk1b9GZ2/XZcD9bWrdX3rDRPAgnU8RbpbEzvg6uFxAkhAOFk97rK2Btm4iEPJcJuyIA+DUoPzLoUyaFVREhMdGuv4tm2OUR3VPT8tVs8I3ulqvFX5eBxvmQRu7DJ5WR9LFNRZexT/RKPYUqKI7yvICiI5ue0BlPK/3lCjcMHO0hfIQOUmc688xaTJW+f4tW3sGrEFslr6IBf9/BIlOk3gtztzWlJba5QmmBLQV7SQKSzEZ6HiVOOvjeG6Yo0RlsK0AgXvIO+JOP+viR7JzkL/lJYyGLluTmQ+fonp47GfRUQcVp/+eAaQb4uK6B2JjaU3t0WKhVIertUa76WyOSoqLIEyL5aR+WIQtKymsS/74cyZE+wauYBPlFpgxA7am7akLVa84rKe9IQnNCUyecLL8H/WlTvImntF90gaPUEOibIl9B8xqwSrSLKZdNw3maPUNlho030MOUCJBPLHldHc7TkjRklLW+smvPy7rtsDZ7OCNb/RLFZU4jWRo4u3legvOL5Oy
 OzaSGS1T
 IZnVbbEO0sF/pEYGUXLDytAuxbtR7yWv05/hNN3UE+QrvmmwgPEEpGdPwrTUpu27SO5Ted5OMDuPmk0rGL4RvOs3u7V7sCem1oYQT3bQbgFQJuLIPmbkRDfp69r2RH5AI4eR5gn2DKMueUEmNBIoECe0TNTGWzs3ZYkL722v1CSDF0m4gNVGnCJTrEAyADhIyRMJmT2W9KTKoZ3QEC7zLgGRhMQZokhcfeBPqMqBmwzuRyYjqd7wNFL+9gNRpL2zVi8MHK+RsmfEhIPpv1UbAEeXJYfMZmAVs4I4qig/rlBH9KEs6g8gu3w/O+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 22:28, Luiz Capitulino wrote:
> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/huge_memory.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0f016ea7082d..4117833c53ef 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -115,6 +115,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	else
>   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>   
> +	if (!pgtable_has_pmd_leaves())
> +		supported_orders &= ~BIT(PMD_ORDER);
> +

Won't this leave PUD_ORDER set?

Ideally, later we'd also have a

if (!pgtable_has_pud_leaves())
	supported_orders &= ~BIT(PUD_ORDER);


For now you could simply clear PUD_ORDER for now as well.

No PMD leaves -> No PUD leaves, so clear them in all cases to not leave 
PUD_ORDER set.

-- 
Cheers

David

