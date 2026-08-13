Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC697C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ABC46B0510; Thu, 13 Aug 2026 10:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85CCC6B0511; Thu, 13 Aug 2026 10:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773B56B0512; Thu, 13 Aug 2026 10:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5852C6B0510
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:35:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE6AB1201AA
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:35:28 +0000 (UTC)
X-FDA: 85096494336.06.86631DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 505CC40006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:35:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMcp4G0s;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786631727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVMlbQ46Mo6FlSx62rCWVtV5s385RB38R7F2cq3RypM=;
	b=sfwYyQ5/3Tr5gVi4Xa9gwMOybzbtgF0HDXpRQVq3zbgWx3VIPSzqe8tEU8JnYwA3hHHgaj
	oYCzLQwDZaeHQ8RzFXvjn+JmCb0VZCfkLSEjW6S0GbXSA66/SlAtc08aVeUMVkVk+r0cmU
	POtI4IyXjNs7PmlUDJ0qgax0JPyChqc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMcp4G0s;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786631727;
	b=1lW64jBMKpnClAyByEPHNCzkCZyWxd+j8nLPP0bBaupWS6lk5Z8fyZhp5+bMaEFEPD57J/
	yr/dNgq8QPwOzQX4bBQp1WGVZqusCq7yZDgIHO6k0DcrY2BDXxjizKfVD+ZqXyfWPgHqEG
	mhkr2pC5vAftdM85BwhHxKGK3BzD58k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D913D61884;
	Thu, 13 Aug 2026 14:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28651F000E9;
	Thu, 13 Aug 2026 14:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786631726;
	bh=VVMlbQ46Mo6FlSx62rCWVtV5s385RB38R7F2cq3RypM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OMcp4G0sW+HYALPi/HZ738Z2R0vjWWsr/JWwHt5jEfM1kuE5g2IHtY2dS8XlgxKEg
	 JBTm7MCmp/6GPrCyOHqdEhT12m9Bauo3UtQW1wT7j6QEsqxCEHBX0eDSGmP2BRbMMy
	 0pJWQm9bnFK5EKNhf9QhW8FkalkosfgrLiAR+zPN3pXf+topeiZ4EoyvqGbN8UIhBc
	 /H+RlYm+hSdkRVAHVjT3+aKSnysHlzYCouW0VkDcLY9EduC0pu4mhEDk5ngVHwZKnt
	 N1pNS0NInpiPG/HYzihAqxEjQ0MaWpbnzVq2+mZKfclmhcyCiuiT47EFKYDEmWYUsW
	 7KF335klZnqGA==
Date: Thu, 13 Aug 2026 15:35:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	shr@devkernel.io, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH v2 0/2] docs/ksm: fix advisor documentation and comment
Message-ID: <an3VdkvUvLapWzmw@lucifer>
References: <20260813031722.569983-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813031722.569983-1-tujinjiang@huawei.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 505CC40006
X-Stat-Signature: mqotjpxjkebz3erxfngn847uhnkfi5uh
X-Rspam-User: 
X-HE-Tag: 1786631727-618150
X-HE-Meta: U2FsdGVkX19DoSD/l/k+n1frJbeIFwzHMDfkPpA+bDZPjUcDdDUgNkGqBFsOaugD5JnMTZxVvKmtdB/YHaSntuExAjVSbVagcO9qaU9So+Kv1zpDL4npCXqJTb2fNCnyPmHtKkiZLbql50WHxrXcMIRGNzOtfNrt/X6C0qMPqm0RruWJuVeRWqJ4r+C8Fo4OJkaN8j0GLlXx3oHEI3nGZfUEi4SJKqa8ALmfC4C5Qt8AUnRU7e8lZwAcz5ZVJntVKsfdA9t+jbiGvQ/+vUs8fQeOvC2CjY8CjXDCCQ23Wch0XjcZCVrGZ0pXWc/MmCPaHY0IKXYQku0U+MSO21p/oTCJXag08DU3LaT74DyACC8N7fVv77pwueWt2LqLWSW0a/Sv6gLg4eaqgKKv9bELdR4gfUoRwvbcqciErGTB+ibGGqNydaaf4+Z0LkvSxJQL+A0SOjP1wIX/tGRv3thhpSfexzyC6KKnqnZ36rYE9BILruW7Gwk4Rt+BHP4j5dBmohUaBrnqEd9Ya72B2U3XLaODzMQxyaW1+tuR8ocqE9waiknPy90SLGsuvi9o9RuakH1MK7+AysPqtOnTPVPiR7pYwPTxzc2M9RgzftIAGOajp80UR2TSw6od/v4VXikauD61skWPEZr8MnhSgGxajIAlnwMOl+L8qrQQeqWLxM24ikdoeijUEImbRaDQt5uWxU/dM+kV8eupGEhCihVXuq+b6dkj8JFEQzRtu3DBSUJtWaNEhBkFXyrfXRKOYszVQ+0LgCAZejlv5ZHhfIt/lsIBquhjzUEk6SChGwDDP9iRJvu5e56nhGBEmbnO8SsYkHHAvYvClB5V2J+JC07nlSL/DrJr2UH4wzXZGKDVqlbTPgfwzQ5OZ2U6hKvrx5RL7qkQTLSVycZdg9u88Ca4aNjcI0ZOnpPL0fuu+gvih7I03ptBv5rXPVnOLra+ps6KAdS/eHTA0EgRe3E5vyt
 JU5GpFAL
 ptF7aVXWCrhEBMEFwnOCDZyrds7Rfja28af6ZGn35A00sKBo6Ft48Ch90lq0cIbKy4ZaNUKACAcesuIG5wyY2KCm+D1aVHouGcsfmNBTLe9wVvyMzRGWiFSsfFtfJoN90HpXvp4RvQJus3x8UOtdtJ1kBKHUxaVqLCiCbU7cHbjPR6g9XRYV1qWEDinOigXMu8jE5eW1i1UNeZaga4vCvkTSW0zTBXkg15gXfY0vFIkGgraYxNGasZaIAKMzBhqKrmgGs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:17:20AM +0800, Jinjiang Tu wrote:
> Fix typos and misleading description of advisor_min_pages_to_scan.

This is a very bare cover letter...

>
> Changes since v1:
>  * remove fix tags for both patches
>  * update commit message and comment for patch2
>  * collect Acked-by for patch1
>
> Jinjiang Tu (2):
>   docs: ksm: fix typos in sysfs knob names
>   mm/ksm: fix advisor_min_pages_to_scan description
>
>  Documentation/admin-guide/mm/ksm.rst | 8 ++++----
>  mm/ksm.c                             | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

