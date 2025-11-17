Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B198CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7CC38E0017; Mon, 17 Nov 2025 12:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53ED8E0002; Mon, 17 Nov 2025 12:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90F78E0017; Mon, 17 Nov 2025 12:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 991318E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:28:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34F0DA777
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:28:34 +0000 (UTC)
X-FDA: 84120783348.27.9B73EA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8D8298000F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:28:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KoSL3wvr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8i8cOk5C7pcvpHvr7QaLsaap9Y1GviBf2utCR4/nKw=;
	b=bq3tCCofQfFeu2xQtqIl3T8bJssPB94CvA70fcUw57zlUM717HaVaIw7JBM1xAgpQNHqm5
	4h7tY4dcuJPy6nVNmF/Kk0lrotCKsDHP1KzTkwym4V6IJ9AOZwUdidp3FqYsT49gnEJo1k
	nNZPAMwduu0S1/xRYqlvImDtt8O01WI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763400512; a=rsa-sha256;
	cv=none;
	b=Th3dlaIqeuq/FMzCJoaUO3UQrRxwziuPVBqFuyKy0a4xkAQcmLTYQaqoRLMeVj5/h5Pq8K
	F//ue5Zb7/yWj52j5C7cMvef3oP/pT0080QNILIq0NAKWy5FNjcmOhvBx7JNH4vba84CNj
	I1bzbUrttWzBOjLYPyhdDj5YPSkny5U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KoSL3wvr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1D29601EA;
	Mon, 17 Nov 2025 17:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D15CC116B1;
	Mon, 17 Nov 2025 17:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763400511;
	bh=yTtk2iSEXD2ucllMMaxke8XcWJDG7kCgtIWljaWRpgE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KoSL3wvrCdkTnmL1+F0GOj+NIx7/jIgyXZK/PV+sB4FXEfLhWmR49GRyNJLj3O/NZ
	 +Rlaqr1DHz0VWxQG0xiYY3+WYX8JaeSLJb7bsrQf7lUrPUfH5FVNDs1D/rKyR+JMGK
	 vAm92O5TEuYF3ctNGmfu5THdi9lYWlsFJtLcTydu+wmfXwUFNZnVN7YY0EKCB8CZ9X
	 EG99vaxYXaVQROD1FluZbKMALV6wJvuKQUNdQ7o6xvqjfRsv6tHNVQdE/a+SRZGejQ
	 lVDdP1jenru0kHwv/8fTE08B3mvRlUVwRcaPjpGk8zQLXUEpkvWuktViLqEJsCLSWE
	 d3uyEQmkjiBLQ==
Message-ID: <9ce40155-2731-4dec-8c18-e27f13bf1872@kernel.org>
Date: Mon, 17 Nov 2025 18:28:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 03/10] drivers: dax: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <1456ba4c025e9ea01abcadb8c3714c7ef84e0198.1762464515.git.luizcap@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <1456ba4c025e9ea01abcadb8c3714c7ef84e0198.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z1zis8t4oecdfcz1fwghg6q1tkbzszb4
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D8298000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1763400512-328709
X-HE-Meta: U2FsdGVkX1/AursddmqzOuRJPkkehulyovvWs1ctIkxTKvj5loma+ZhKWic9rOEqIjOrv/9w7BtrEMukvM7+2IMDbfiDFRm7x2rsZvWmX57yGzCVEC11QHrTjeTp+2XWSh5Y+B+wO9X3pn/TxTr400j1NLILl3+/qA73AN1k2AEYF+89uIgWyVvQGKIUdfNiodFRzmGkNuRUJys3TeztaS/Xl+TppJo0e0duEOCim9JhDyoJiBXTrvwP+1DRmt+8M+B5ovf/I8WZYJpx9LKH7PuD1wT3F+t0P+Yt8tFahEMGwf6+YYdZryaL+1hDK9I/rU1U5DXk7YOjCOg4yHol1K2OFPMnSKikDBhMHAnHLCoJIATaEXHNeoHlEXgx5UDY4A9bUJ9Bpy4YoaTI1tgO1eVeTkHSIlTf7zgL5QlkgyNgttYWPrcVBNXuL4yRVmt8tKqNuw3/OaI77SDMRe6DXzbQqfEU7bHmt4PVFK8He0mjqRSPFw7DrzER4EBVn2fWlWKgGJ6I6jRZxcIloTvbR96aQv5/taCujEq3Mk2j1/aKn5Zg3+0QNFPTO+w9CHMxMTyNyWhDld4ELYOa/0eAQU0uiUNJ1R3K23xU3W01HkeyuDoKInHdS3Uqp4VABvkIPTTpeYgaurOXL3N/ac62FJw/z4/Wm2lFdiL16tOSAUXCbHESKCNCbu6PgeCjERPYeoJPfCRFErFiIPu5hpMzT9bdUzkdKU0GNXoa9rZJTwWTST1jQY/DRXGLR3IgGRg6ypiuII4mm40OyMCpUv6dKKJcdDU/5xMLsGkZebWb9paoVTGSwqencjhweBi1QJsRHHgSlfK6Xtxz/QKTdbeaed96FF4ncOg1t81/ZiqNyMAz2ixgFAp/hgrzuGHgt0lqgpe58fcGSkSmZYoIMRJiBEIU/+SQ3GmqNBoTe01/6nrMFN89jWHMdHTHH80Up/LXNudn8qYj8G2h+r3yKYb
 8HqsrplV
 +9jfhqFZmQ3H4HBus0bl+OqUHG+ajSus2w+VaO9lwvCp47Gb/8NRFswjrvekEzS/lsGiR8F2uCzCA+sZd0fS94GM4yi2CKHpm68wyl5H8d6BWJWJ3uiDNG3zihCybNMjxUswEBPEjGykBzzT3SWkcbZ04RBCBTeGP+8ewwRfvwgEFPkRR3qP5GjQgZ7YTwPru/GLeQWrlcCCnLegJ7lGiSX0VyY/y2aqKy4Gz+2CrcG20NiugllTNyoSxMzegXA1NSMVU6qXvmTwuFd0X7G/5tOD08y5KOKyqt1ZNV9SQKhEOAnVoRxYxIVPmTAWbvR3G/NkZD10iKGo+QOoieHXJuM2xjTzbrJg15eWn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 22:28, Luiz Capitulino wrote:
> dav_align_valid() uses has_transparent_hugepage() to check if PMD-sized
> pages are supported, use pgtable_has_pmd_leaves() instead.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   drivers/dax/dax-private.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 0867115aeef2..10aeaec9e789 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -117,7 +117,7 @@ static inline bool dax_align_valid(unsigned long align)
>   {
>   	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))

As discussed offlist, it would be great to later also have this be

if (align == PUD_SIZE && pgtable_has_pud_leaves()

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

