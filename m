Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5697CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 11:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014C28E0067; Wed, 29 Oct 2025 07:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EDF8E0045; Wed, 29 Oct 2025 07:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44688E0067; Wed, 29 Oct 2025 07:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D28DB8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:45:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E5CA1A086C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:45:26 +0000 (UTC)
X-FDA: 84050971452.18.0B76192
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id DA72D20003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:45:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BaYKugDC;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761738324; a=rsa-sha256;
	cv=none;
	b=Er0z0hYqdqBmLdiqupxq6r+Ytbd4pT7VMmFraXE/n2ddun2iZYIabnAEa0zijCJI3CQmpt
	IxcKF6oD0dy4+/s6ZjabJQmDmqygtFxkdSX1UU0ZkqmLGzmyhIgxTmcpSVcd4WF47LOztR
	iQlEVu4NskccapAiaDwTB1jNLB+02Uc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BaYKugDC;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761738324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0k53qwPFdPti0+2A2F1KkKmg20Cm6ti1nkLzAVhALM=;
	b=JA1FPNLrcWsdZ2bhDosa8ZuiCdUlboY2yc17MoRlTA5h7v6iFU7BwB9ossWk3MDWgcYFc0
	XL83GcjAM6fr3L1684Xuh5sY5MWt8fmI0c8GrUThfdDNwu+c8GWNGMUB3kb2wc0Wp1suu1
	ndhTumTbMsteGoEEVshoGYtj3l4M/cs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18A416028E;
	Wed, 29 Oct 2025 11:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1E9C4CEF7;
	Wed, 29 Oct 2025 11:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761738323;
	bh=Z9gTj98F/1RwIRcwrL5w97Uu8Nv+KuJ0c2Vnes1C2TY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BaYKugDCgf2smiHPvIb28DXNPSUKpeXKaBRMo9BGt2C4HOcIUY2f3en5IjyInF2Wd
	 3re3T5G+7zMhmC+oUMgzwDtL+s1wxWJQlEZvGoUfmM0UrVfXSBEcVK2s3xOtXgIEVG
	 xDsvKcYGpk7qW37yMjYmRrv/D4r0MVMP3FOmCMsROWHiztJ8+g+wFWEN43JIyvfwey
	 QhSl616j9GnucJbsFczvsjaOofnaGGs6znn904EFWc4A8rdL4D2hdSIW134EuFYBgN
	 WAwZTpWyy2KFCyByQVVzCyMCQN3s/AFGb3+C2tsNi00PQTckVuNXNEydbIzEGBa0TJ
	 9I/GVQbsCm9BA==
Date: Wed, 29 Oct 2025 13:45:17 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	kernel-team@android.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/mm_init: Fix hash table order logging in
 alloc_large_system_hash()
Message-ID: <aQH-TewXFLUsK3nN@kernel.org>
References: <20251028191020.413002-1-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028191020.413002-1-isaacmanjarres@google.com>
X-Rspam-User: 
X-Stat-Signature: d3ac14w3usgiswpdcsucmmn536yfk3kf
X-Rspamd-Queue-Id: DA72D20003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761738324-766341
X-HE-Meta: U2FsdGVkX1/Xdf1N6lDpyq5qVB03YRAt/+rjqtUtV+wMTNnjwWh6uY600uYdaPRwSGec6+YdrtfffCGByV7NxSIEzr+U/piwSDxYLfIBfSgDJP2swKV2MpXZ2KWRkWaWNhn7HQC/TgHaLhTZ5k6EOupxhgOqRLOJvDmAMJAKVuaSILL3iEp3Gqlg5Ip3kubs9ZPW3GczftFrDyFYNTdxE55iB1PmZruxNFOzMqcAHrGcSISXQ5S7EzikzjWFHd0Pk4fal0u5EtN5cuLgR5gtmLeRwFzFBs/BjQJ/7uayCZCt6PovuR2kfFmcrxJvR19kfx2OX5Yzb5ZpYf1kjqoObf3zWcuYN6ftTtnGLVyW9sjPc87FJB7ToH0tpNejjB6upn8vq+zeWbZlZleeyjV2egT2gziLGh11QTsq3FaZtE20uLKAGwAnqq1YFFVYFgcly4Uu9BqRG/FL+JyuiydUU62iebQUS/cqYjBlj7kDwL/PAu0nUOgE1s9/3U2VNsCTtaQ63Fvc3mGS+LH67V9JwSGxicTEQG+rV+7QT6DyYMl1OEJ15glMJoANAfSOhrFgHuhydWOjbrHDEradr8zA/yhMTgifcE1nrJ8z0MlQg6nRaixUMl7HgSe379vLWeWom8mL4OPCss5gfx6nzbeFWkTkclLftLv+X4wdsqu6MKhJo3P8QtLEZJP3I/n12XlULGqrhuZVKDtRcL6sabyoeiIZRvWMc6+eAfrkogtzv4r5QM5FnZRMIYurRw25aM8BC3+mZqUw06f87MZfggdPPJtoGksBwEpoY4h5ZP/KQldiSGf6Hgblb1+n6xTssUtmwyEkEYII4Y0ybeRSwmCii2kZZ0FIGh88upGcExxJ/xGer3x2UixkE2y2B6P+X2vAK8HDbT04zQ2i0mc60fC0L+SWLtZXh8JFKy09EtAqnoBpLvHlX6EJHxiUHuTIbQuF0EW90W4De1cbjRWQV/9
 asVgdqfS
 WTTxbTCSfdQp7c8Ql25ic2Zbv3/uzOx8/Z2YPP5ORmOGUtjGxnfyegHyk3rITbKHR3IPUJM87/QIE3sDVqxh9A31Y6Je00GjZGRswgHDZ+RmB7TBagY2iUDeUofZ6DE8/TJYoMD43o6z9jCdtzNNiPxspUdKOS3RbVTRbMlYP3jWy2sScOkam7yQ1XlSO59z4JMwUpIPndZefkLFbKGKpglrP36/FTouTfbQJEh35xcBErpPciaxoec4lTGREV85jGTj2Ax3DrKY6P4wMXm/C9u8qwjbyoNhewv1cH0gVM5Mil9bP9mJ6J2t9vre9fZy5JhhfqGhf+HpdBarfch61bE9NeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 12:10:12PM -0700, Isaac J. Manjarres wrote:
> When emitting the order of the allocation for a hash table,
> alloc_large_system_hash() unconditionally subtracts PAGE_SHIFT from
> log base 2 of the allocation size. This is not correct if the
> allocation size is smaller than a page, and yields a negative value
> for the order as seen below:
> 
> TCP established hash table entries: 32 (order: -4, 256 bytes, linear)
> TCP bind hash table entries: 32 (order: -2, 1024 bytes, linear)
> 
> Use get_order() to compute the order when emitting the hash table
> information to correctly handle cases where the allocation size is
> smaller than a page:
> 
> TCP established hash table entries: 32 (order: 0, 256 bytes, linear)
> TCP bind hash table entries: 32 (order: 0, 1024 bytes, linear)
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 3db2dea7db4c..7712d887b696 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2469,7 +2469,7 @@ void *__init alloc_large_system_hash(const char *tablename,
>  		panic("Failed to allocate %s hash table\n", tablename);
>  
>  	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
> -		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
> +		tablename, 1UL << log2qty, get_order(size), size,
>  		virt ? (huge ? "vmalloc hugepage" : "vmalloc") : "linear");
>  
>  	if (_hash_shift)
> -- 
> 2.51.1.851.g4ebd6896fd-goog
> 

-- 
Sincerely yours,
Mike.

