Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A8ACA0ECD
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52E48E0072; Mon, 11 Aug 2025 11:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A8C8E0060; Mon, 11 Aug 2025 11:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D677A8E0072; Mon, 11 Aug 2025 11:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C58648E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:29:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73AD21A021D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:29:00 +0000 (UTC)
X-FDA: 83764859640.04.656D289
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id F04BA1C0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:28:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=lZC6zGWj;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754926138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAb2hlkPZfqAZ5oWuzo7LQdnJ5lfu4VxJv8CxW4eSIk=;
	b=DRJpljjxUlIfTpdi94HPQxYrQU+A+WvgotL7uUJRW/GUMUzj/yf+qsXMrJFnACYyRKrNtk
	vPA097FpB25pQZZ9J6mgoYEmxQVSHapYEqbKSMqtGjvoPoG+EOOXdOcik39dGkCk9/BlA6
	Cix83Sop67rImziD+snFLnL68YfnPZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754926138; a=rsa-sha256;
	cv=none;
	b=lF1l6keq0I02D1C92sigGaPJbtRQ5veSzgYa2fiu8N6y/1YZw78cQrKPgG3gDkHaLOM3ET
	Kj1VGkoEBNxg2K0o2sawYNuhmFoHRh4ZkGoSjKVrmiZVg+08zes5UJS7DceAIlDXmu2TfO
	FrccLXJOchZgrOkQ5s4k5jp7EIysp6g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=lZC6zGWj;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1018140E0217;
	Mon, 11 Aug 2025 15:28:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id xeBqMQ4xZ56G; Mon, 11 Aug 2025 15:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1754926127; bh=lAb2hlkPZfqAZ5oWuzo7LQdnJ5lfu4VxJv8CxW4eSIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lZC6zGWjMEAOrzyuS+/HRWJJ1Y5enmj8JYL1MKqrjAIrKXnhRlg2pks3w1t1dsm8s
	 VgQX7hQzICo+PlFDtKKfkpeYervMPLDU1LhRUmdYbCvFGkaKprxvff3Mny9tP0tK2v
	 jFLzfDeVcj09bsLeiYZW3ydDPvhP0bOf0qjbjebHvZeEEdxpYt9w+BNODv0evjjCfd
	 qu2Gmm/t8q07TtzWK3Hcx8ljbaxBs6vOK6SnBsavBpWB46ACbgdiCECq9RKYMeT6Yu
	 Rv6X4mZl0SjClJac/fpdhQUjKJWTGsmK3wIQsEIhVRqgtjS+sXYS6s4h0cRPaZjzB2
	 pNr1bPmpciuI3xNvSgW/dh223zY92QujuDd0lBtF/D1tu0iCfgwLJVJDlGAEaZKUAy
	 qnJlAojA8dd2jiRnG3g52vs5QkI3tnJ5ImVf/utDnXdsOqcHcsdTwGsgmCpCL3w6kF
	 aYsQW7HTUQC+mNq/ySVjmhhEGcv9t0QWKVbSs97sbSzHcemNCpgivFTEyEWpPGoJZ3
	 PRsCJ7tZ27OiTfdgQHeKb5EUbHLX4AdEkqkM/5y/BpenmCMbmeZSbPbI5PJOKvtyB+
	 NDA8ZPylW9J5ncjOHY3xdti3LjniPgMVCo9TpAU5cT4tmQNkN2NImOEP0Ndd8yyN8r
	 bCYs0gIfNWAyVOOWrYpT03oQ=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 561AA40E023B;
	Mon, 11 Aug 2025 15:28:11 +0000 (UTC)
Date: Mon, 11 Aug 2025 17:28:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: shiju.jose@huawei.com
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org,
	jonathan.cameron@huawei.com, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v10 1/3] mm: Add node_to_range lookup facility to
 numa_memblks
Message-ID: <20250811152805.GQaJoMBecC4DSDtTAu@fat_crate.local>
References: <20250801172040.2175-1-shiju.jose@huawei.com>
 <20250801172040.2175-2-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250801172040.2175-2-shiju.jose@huawei.com>
X-Rspamd-Queue-Id: F04BA1C0003
X-Stat-Signature: 8wjkcj4x6wy95a6d6fsyzat8nokxt9n8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754926137-984396
X-HE-Meta: U2FsdGVkX1/UK2WkehAWFAopYVt7TLMy3lO9FMSG7hHMTsI5zPkx5maiNuI3RhL9BwEAIFmx/NlrdgIyDWiefUGi4IhJsXTjGS/r4HQtIaJaGRrUW1FLpMFx/gRt9UOv6lTC90kaKpp5z/Eh5ZmRW+1WNm08oZ7T1z3NBEyKRFlPmV3K1nN9FtVEJIQ6akNrWkWisk4ZmZqIyp5bvYviR/3QCmfxGLEtkB/y3vYW31ltGXFr3/ddHwlZQIGTeBlgesXkQl4RLrcoiH0JVk3yM3SRaE2xZAXU9wsIjm/QU+9mS3sW+eJ8VohzIWzm3zaTSD8fel745AsbtMUuxH9BcW7kUUK6BRhKwa4bFvKDXckURIAKhoyayOLW/AOYoUv64z1JZZc/O3qsl8Pj4uArb26evZ2kmXq803td3Bv6Jy0VZgC7EZkbF7g95My0XYD3D73+T2Ei+lDvUZhfD4keMDkk07824q0AT48D6McSn3+K2UbLogzvxbq1VLK+UTXCrWx2ML7/ZJcKN/4TKqispM1iY4xqqQtqX9sM8h2/1J365uF1vbgOw3UptR7fRfCFXnXWINQYwMPMpr4p6SC6KOlT6/XPDBN7WxXLMMXLAJWTfx1K9EdjgSg9eouSxCh5RYVVPgyARKB2RoeDH1whthiLFNNLxTTSsqGpvGque7emQYnpAS6VqdIpvu16Jpdvmati2RaPWYhlyJZtoQA4IGKsvUf0a2Wu8xxArji/rLaH9gLANhA7KQM7x56Eym3cMCwqg/QQKIbKIz1Jnuw/c7CJXl5RPv8AJ1abkcsw/KvGlGgaS6kUDnnT0LhqBdZy7I1gqciZMuPE9/h7Hh99dvdSA4UF7DJMz2zJJInM2ePu3eVNq733nu6TGtWmssBSVLcB7TBDaLq4udsJAluM/U6A1naI6fxAzacf3y9gSzkI/VB4YFCc74G/TUxZ2mw2agPbFGMCofRGTeIXStl
 lwdxc0Ft
 +flLjmUyCHCj/wTUOGTcxZpB31Y/nwKT/2sNDW/g7MzX2JlOqO+TaTLla7/SKu9YdLOvFjlqL4WmQ/kz3fW34FsCeAuS62zzgA3tJjytNBwYTnKuqS243peE7/8v4VohTDybcGA0PC2tJgr0BywyVlnWQdn4kKQ7xbVV9akBFMxgaxacX9i3eQfO4naj5Y5CuAmQaeI6O8pXyWvMJ7+IrxO21a0JyA+rq5JHbK/1KjVmsutEl41zm0ao94/BYEYa59DPLiGlRs+5CfEypua0f0Bv4UZauDsBZPzbimf8lTcimKfocKZnvIr+ohCRyXQ1SPz+x79bv0hsZ+psNyXAbo1ieB+Z2sTU7KvC8V5kpqTnQvw3GW1hfam+C0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 06:20:27PM +0100, shiju.jose@huawei.com wrote:
> From: Shiju Jose <shiju.jose@huawei.com>
> 
> Lookup facility to retrieve memory phys lowest continuous range for
			
A commit message is not code. Please write it for humans.

> a NUMA node is required in the numa_memblks for the ACPI RAS2 memory
> scrub use case.
> 
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
> ---
>  include/linux/numa.h         | 10 ++++++++++
>  include/linux/numa_memblks.h |  2 ++
>  mm/numa.c                    | 10 ++++++++++
>  mm/numa_memblks.c            | 23 +++++++++++++++++++++++
>  4 files changed, 45 insertions(+)

...

> +static int nid_to_meminfo(struct numa_meminfo *mi, int nid, u64 *start, u64 *end)

This function name sounds like it converts a node ID to meminfo. But it
doesn't do that.

> +{
> +	int i;
> +
> +	if (!numa_valid_node(nid))
> +		return -EINVAL;
> +
> +	for (i = 0; i < mi->nr_blks; i++) {
> +		if (mi->blk[i].nid == nid) {
> +			*start = mi->blk[i].start;
> +			*end = mi->blk[i].end;

It looks like it returns the start and end range of a node ID.

> +			return 0;
> +		}
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64 *end)
> +{
> +	return nid_to_meminfo(&numa_meminfo, nid, start, end);

Where is the "lowest" thing here?

And where is the "continuous" thing?

This thing simply hides the struct numa_meminfo from the exported interface.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

