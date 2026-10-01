Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE7BCA5FDD
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DC16B0092; Thu,  1 Oct 2026 09:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4FC6B0093; Thu,  1 Oct 2026 09:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E496B0095; Thu,  1 Oct 2026 09:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD9266B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:18:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4EC051403E0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:18:44 +0000 (UTC)
X-FDA: 85274112168.18.9C36F47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 884011C0009
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:18:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cME/sF3Y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790860722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4npuvMNR6UKbZDO4+dj4mKqktlQ5nKE7OUUQfyh8Zxo=;
	b=1HBVUCiGI7BaC/3mDeeG2kkG7WVemN7O9ZXmK1+GVxNF8uOBjZA0S+K7ZcUNAInje4tOKN
	Iga8DuSHNqipaEldijkfrEBxRT9jvO9s4z5AM8BC/BgmZf8nE4zlpBiGDiIXuxyVqx0/4Z
	9VyD92i52U2k1cuUh5+FIpVaN5YbWOk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cME/sF3Y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790860722;
	b=zybbk28H3wSDdDcKNtss1B7t+0SOSFxGABecuRZf9BK+fMCGxS1MuM1GGFziGCkGK7InFz
	NEP7hkxOvzTF19eGnlDBNwGsSUuOUfX7+XYibeR5yF2Jj5kmRm9LtjInUXWvnHKjQ3pMwa
	/pALRVHKrr35gAEDmJmsJZVGW/tEKX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E25F60A55;
	Thu,  1 Oct 2026 13:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7964A1F0089C;
	Thu,  1 Oct 2026 13:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790860721;
	bh=4npuvMNR6UKbZDO4+dj4mKqktlQ5nKE7OUUQfyh8Zxo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cME/sF3YDW7p5j3553ehhYXraApc+J3HZgdS/Or9hdcMRZlG19K+b+RXjysMR41Iq
	 OfCSporTa5zb0u48pa797TBjDgd2YC4SafJ53elaJBZZGo7rlf1AbIFiA4QE13lMh2
	 49RIE9mVVKv+zf7EXBVXY5rb0sDVoQDQnjg57Q5Y5Kd2MBK1CTDbjDwzuBzy/UF5yp
	 6EtfnmouCMD3o7JtB7E+i0eSZZHVaZEp/VwyPrjGAq3ZIHmC0AMuyCV2efrmv09dZX
	 wF9vYA9IB8F1cwGpJ1HzVUBUKIjTQ4+5Dq4wTN7WS6EeuE7jQJ0UQZjXItjjSBK5UJ
	 SpeYa5iYIftaQ==
Message-ID: <ad501ca8-f5a7-4a7e-af6e-44a38208ff84@kernel.org>
Date: Thu, 1 Oct 2026 15:18:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] MAINTAINERS: add include/linux/hugetlb_cgroup.h to
 HUGETLB SUBSYSTEM
To: Enze Li <lienze@kylinos.cn>, muchun.song@linux.dev, osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261001123747.634845-1-lienze@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261001123747.634845-1-lienze@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: zdnuhu9sj1aq65cm7xsjnh1cqcsroi79
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 884011C0009
X-HE-Tag: 1790860722-861746
X-HE-Meta: U2FsdGVkX18B581KVGS51UgPzjDGFyyzei2f60yxAW8MFdUuBOQzjHxeDgOr65TcKw6iVnksvlFZerPFICm7+9t/Qr7hCuJv2hnLJEGiwXVAz4T1AEOa8DpGaY0OwjndF/KfyPbdFlya0D8TzZMC1qLuGCffXts6e2ZCgRcdOJP+TRFrZFP7+2Yikysyh3hhAFnFsDSh7uQ+x0d6kdfcoFagF1C8NuuN8SsUgYgZ+3GoFa/bq2Z47PyBSh5IkvHvXUEFqcNMCCnA8eSY5KXCmjHc5UaXrj2Fs7XLIpuYcuVa71EXAqlptSmeIpp0ESEOQ6G/mwSevUTShs0qbxGp5o79noLmNVNey+/N/myHaIXyh4x8uIwghTNS0w2DAMsoPoBuFz2DnNBhbwsGLkP81qQtaq466rf4StAb9eidx9yAocbsdHbkD5qaplOTgPpjvRYg4tnme9FoKJi31F1Gt+OFSm5hu8PRgn0VFkwDdfJmYbp10B5TQaJcdFZDglzdyZmqz/MZuTf1Kxq7Le/ZJrTry02Z5DxFTf/jhE/rs8d3SJqsveHCgTl+3V5x2sYvYcuioVXI+9g12rzwrv20vPHKT9p1KdRSG86BgXi2PXU4d1LHJ8QJbZ/rXAcfLTKy8gERH65hVdQTx/3K/yjOpwL8mrERyi+YAbfhm/FckU1BDHNX4PfJeGsmdNYn4PHcoqoxoMObuVlj1zu2aTDCYDkysTJUbl3xYPQqcQfG8S5vjiA2wG03EihtydhcsRePto45DC9iVipSg/K+rpxALAXkfT3pfCKTnORgoMTDEXlRkYVP8BUjlwnFlCpL9MiCcs+JgLFein3ZD7cY1KkriGpa8KYfLv1UFVm8AxWXOoRfkGvCkbhsH7Jm8n2v5OryzkNRCB5NpL6xyc0WYOYXLFyq56oTZpf/+CZ3kXfFwb75QZDXM85y8RX5CeroiKV0ZNYHpN/qVwHF4F+criz
 eWrhvjln
 Bwuxa5HEgZZZe0cd0WRtWjUivdFCF6E7TI//Wtr4Q/IIlV0AE4vfh39Kkg2Q+6fZsCAqxjPSi/Q6I/e+tBkNLRXHt3nONrvCC8GVZGsaCTxQs57YKByqrYNag//bK/N5Vgxi/N4dtQAiLBoANqwl7PLcrEyBiQ3QD64+f6bXXNMlE403sCpQHycp6VKZgPTyCG0qSl44GbjTMyfpKT54sOAI2z1JZ3ileVvVgQawiAyO5rrt4UyiFnGE+inaM3NtqMDM5sXujR1xi1D7ZuUfNELGUjuoXU3L9S3VeUS2k6QyUxo7xEwvKeY5ci+EkQ0E21tQD0c8KdhxYllk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/26 14:37, Enze Li wrote:
> include/linux/hugetlb_cgroup.h is the header file paired with
> mm/hugetlb_cgroup.c, but it is not listed among the HUGETLB SUBSYSTEM
> F: entries.  As a result get_maintainer.pl does not attribute the header
> to the hugetlb maintainers explicitly.  Add the F: entry so the file is
> covered.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 596efa354ea2..6c210e90722f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12097,6 +12097,7 @@ F:	Documentation/mm/hugetlbfs_reserv.rst
>  F:	Documentation/mm/vmemmap_dedup.rst
>  F:	fs/hugetlbfs/
>  F:	include/linux/hugetlb.h
> +F:	include/linux/hugetlb_cgroup.h
>  F:	include/linux/vmemmap-optimization.h
>  F:	include/trace/events/hugetlbfs.h
>  F:	mm/hugetlb.c

Great, thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

