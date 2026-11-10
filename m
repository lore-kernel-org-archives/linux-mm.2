Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F290F606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SecDpxdf
Received: by kanga.kvack.org (Postfix)
	id 571A66B05B0; Tue, 10 Nov 2026 15:59:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542AA6B05C3; Tue, 10 Nov 2026 15:59:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457F06B05C4; Tue, 10 Nov 2026 15:59:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1846B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:59:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AE1AA0101
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:59:45 +0000 (UTC)
X-FDA: 85420425930.22.81F1CCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2950C000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:59:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SecDpxdf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvDAtH/JwM3DeoG4H2x9y63kqFLwTXOfr8/w9opbDq4=;
	b=tuJJoOEmPgJ/tM34bZgE8SH/0os0/Ajm3KrWh7+iy+WoS/UtdlFdLtXj9zXoFAhr79xRNS
	UK5F8fa77H+E0JJyNtra3CrrWofD+aYIlEXgbC0EiFPqkBbONe44pbp8J3MgQMJt4N2wsz
	ImjrSpXbv7OaBpMsM2GwS+rtIpZ2nRA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344383;
	b=xc6D/9LaHtwbJZKdxpVrTjIxNH8LysJ439D+251CBMNgoBuuPRVFv5gkddeUZIVMYdSBHr
	UCjNK8NDHurlsE881LxOGd7WUNDjUw/Hd/MGtlRjDNMtTidttA6MaPFBOo7Gq85iEb0bBi
	JAJ6jBj69EgNQ5kEWcLNUTMWScAcvwQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SecDpxdf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0816D414E1;
	Tue, 10 Nov 2026 20:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1481F0089F;
	Tue, 10 Nov 2026 20:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344382;
	bh=SvDAtH/JwM3DeoG4H2x9y63kqFLwTXOfr8/w9opbDq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SecDpxdfGrKd1P4S8rrxkkKkOUJeS+n1jUr3POukRnrtIZdVaci3IYjVS/7GqNkWm
	 RPavbp5xKo4Sc/pYnqG3s82jL3RnDMh7Dw1LhMn+A25lMufTI3bD07iK/OMBOqDB8l
	 B/k4m+kBgYQhOA6y2LgmlVVmWuNn9QizHjkNFVm+nju0BBjYg6WIa5uxcUaUpw3eDV
	 sjZrfTwUse3BXlUfsYRhUEtZHMzr0Ldz+oOtiZh2/BC0+c0nI6GxP9KA+C3FHxWUb3
	 e85ifEIvSaByTatItprlXR3Lg+KGnuGHe36aqWHy6v4Gz0X+nXkeh11Ll9cjwYnU0q
	 uqLNqwuTf3u/g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	ranxiaokai627@163.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	linux-mm@kvack.org,
	Hamid Nassiby <hamid.nassiby@nokia.com>
Subject: Re: [PATCH 6.18.y] Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release()"
Date: Tue, 10 Nov 2026 15:59:05 -0500
Message-ID: <2026-11-10-1-daily-reply-0009-page-owner-revert-6.18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261109141527.2880867-1-hamid.nassiby@nokia.com>
References: <20261109141527.2880867-1-hamid.nassiby@nokia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jhgp1qudc8811og4ei1f4ckwbhpyo3i3
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2950C000A
X-HE-Tag: 1794344383-955245
X-HE-Meta: U2FsdGVkX19eQuOSrjaJP0I1pLRiq6owlPipwsjm5tKJvLVycaOEdN4eMPhmJmlRkVXE6qW9tDFP4Yd9fzAc/5SdhMrLQ08bZ07Hh+WBTvB2NB+SgO7PGPZx7CTE0xQwp0St7Jf32j4QZo8KP+kQM/Cnr/T9fWqVd/K84v47WBBPApLnM/BCYPWoFGy+SaINRxSaPfd8mLe/ILEy8NItx+SC9hVcKq++v75o8U9ehFJ2fvTlfSIVQ3VOMnjkS2L++JDQE7EfDIYmP3uPWo0W4AWkgZE7UwxSGMcYS306KZp511pztUkUv6LdJrIHZHNz3HmjkBGRkkS+bB4DqcCHmEcVPeZenxNgNMdJKhbFFNVQM8FwskefgsZNB7pnqPqHdSih1eyYFeNYnRFNL6Ntjsmjnn/hrkl9cNDrLtvqlyhMGMr5tzGyJmHBVgp/8A+yTHG8IVbaLZuAI2fkZL/ITM78SzZJVFez1bG5EHTPeinV0nW1ZhcwOi55UJ1FgAEdt3FW52nCJ0jvfAHi2wZf8HFhRZ7JWMO36MoRHToglPa69SA2rGYCPW5BXkM1byHsdLtiQGsxeBdwoFZQeei3A9BqEmYCt5eF3DWA/zuTz30p+7cF+VR+1JWDpx+GJdOAaG8+a/Dyi3jCHosj4mMSt6NTVZcs03tDJCeR46CFE6VriQr/1684YQgQyVr2i1QLJPzskAxZVPejYv9KzC8jAkit0nKrKCD6zd7tT0Qvon0eYxAHWH6+9fIaKI9HNJbJiYemvj3ooNBVa0agk1rTy3Za+aqlTQxc42P/WDKL0rJYLenNdeqCLKF5ubm8V+5PkIMdflpWjqhntfc7CUBoevRiIYiFvOuZEuxDiTP75/ZWD02xAwG+lpuVvffD3F1S3zqJJXmRg0CjWCjQ6VR38cnRd/FG4n6Av/2BFawhwaq7OWKv+brdMg1fiTk6b8V4WeZG6kRqMaOkyUvNg+h
 zBSvnEkX
 6K1rATsDRRiOuifV4dFm+P9UeKUutfRdlBLLcpuHIXvff/aEUqZFtrE9VmxfejK5frkGY1p3GeFkSWkb3Vk9FhbsFVKhJPXhZDyU1ubc7PGn365BoMO5r7pPx3eFf6rheP+0Bj/4UHQ6b6WNFAhRUuValxLqqQc0inMTutk+Kzacmum8oDBGDFu2WOrb9u3YiX0pF3Q5YWOpUMJ8Iq7ul+G9Pwloxda856oo5tViSuWd4n+XKZPXkyodXuLNUDTxAJHoS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release()"

Queued for 6.18, thanks.

-- 
Thanks,
Sasha

