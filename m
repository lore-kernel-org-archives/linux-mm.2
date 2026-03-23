Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E25FDEC01A6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598156B008A; Mon, 23 Mar 2026 05:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F446B008C; Mon, 23 Mar 2026 05:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485916B0092; Mon, 23 Mar 2026 05:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3828F6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:04:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D95841E895
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:04:35 +0000 (UTC)
X-FDA: 84576742110.05.6298DD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 020B640011
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:04:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AdEAGGud;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774256674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGQ/KzBChMlDHHVVvKgq4We5cSOohVDIOwX3ScaKvxE=;
	b=Kg5SEf8FurfH53WCw7Qun+/BvebKv12ZXcJCZB59KX4/4hI2b3DANSkdtC93EanMWshqpk
	gMVlk7rPly/EiNnhxwEhBP8qlRImy1Q25GCgvJFGFdtgyZdGRvXvuVyah3TB3KDzMkK5x2
	cAnKVY7amBUaSkccRq8lW0BlExt/9Ac=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AdEAGGud;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774256674; a=rsa-sha256;
	cv=none;
	b=GUUUkr2uc9L8D493OtNaLNw5+e+97os/M8o5TQ0+IqX9QjU34HXWyLCOVXZQVlw0PL2lZC
	OV2xZ45KTu6646MJ7YQYo3oTeQNj6N5TVJNYRmbCgRNdS4Rslp+7iEDerzNYdrnleQlZhi
	4PLkgNx4KqKl6j00tgXoR7d4tJ4n7Kc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F38F740241;
	Mon, 23 Mar 2026 09:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A32C4CEF7;
	Mon, 23 Mar 2026 09:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774256672;
	bh=lH41UorpiECIfRRgkM9qpmsoiLtI0g2zv3RHdffY8oQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AdEAGGudpedxPDpX+oarCiGN3BqyvgzLQrPUhOmkuQ/u3RyDe7xFvhWNa4t0J7CKJ
	 WPLF01mHtWWzAe8t6TmEhJ/D/LAxqJgNdVqxTD9+1t0ELVe7zgv4BSlgHDC+luKRXs
	 sAvPoaePO2Ntyiss2uDubWYm/y5IYVhnHJTrxcMDAuqd9Y6QnmK1GFlbfnmRvhGJSg
	 RasAy/rLmxFCPEL9Vu+sqR2hvicO3Nb3PaxMC3OOWKJA9P/2bOTl55wA8X3f2sKXqc
	 OfxCKTHAu+eNRhaUknkB6BKU+nDjVIYOyNjx2zioJ5cHMqu5MfpYJtHLGBQddqRcoM
	 9wOQQuVE67XWA==
Message-ID: <817bad82-ece2-4bef-9fee-308bd00ff7cc@kernel.org>
Date: Mon, 23 Mar 2026 10:04:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/4] mm: huge_memory: refactor enabled_store() with
 set_global_enabled_mode()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>
References: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
 <20260317-thp_logs-v7-3-31eb98fa5a8b@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260317-thp_logs-v7-3-31eb98fa5a8b@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 020B640011
X-Rspamd-Server: rspam07
X-Stat-Signature: esot87ddow4y8nznmie9b4hmbgxepew8
X-Rspam-User: 
X-HE-Tag: 1774256673-799647
X-HE-Meta: U2FsdGVkX1+Lpphl10W0QHiUyUydEGuIRh6vKbMiq2XSYpMXihaHozh72ORjswUM9ZA/W/Ijp8sZXVL3K6OkM7SyDIYCWIZ5Aij9lsS5E6JXkIWAQ8/xIMe1kKEe3IIOH/AnbNPf0tiJDNyEs3dQzxjjniSU6qwwd/h4Cv4TWLuU5kCLsvzB4G4q5ZZ49dAl/gRX6v9CfDd71juHNSgQlsO9SPn1aRk0/IJEXoTcvHasYXCf8/rJWBDG3bwpnjf38btxXBfhI3pcrpH16CITrMAGzCzaq+gFLkob+fYVWKb+jKkiECAgxMA4eK23mei1+qBW3gzs140kTGRcM1k3spuy7SQSTkAQP7UbixtQF6iNXV1UzQGgf3q325QSyj7Nn64UrEXOsp9WfFbPz84EKvgG3nZU/U+SJvR40OYYQqbB5DfYFpGo+G6G/i1Kudbxhl7c35bYTYqxkyvS/ntSYX/g/jPPcxrarwLu51t9znLOfcfCm5S+CfaPo+yRD6ty2njZZJ3z9TiZaFXLfHjGriD6CFxA7DgPbl0MsMnpCRDqrazHGTFFZjXAw8n7On+UNW1q106u+lMKSeqxE5jjTcrhWz+oscYIOk6JmogIEbbE2+niO1mtXd09rZzosj8y7zNJ5px+1Pki8wrUrchz42CW1HOye1ehf4fybMJ7znDsfzcNjlVDNujyVK36YwbQrOOwyu76dRGbBSPQDvfDZw4D0viOH4quTo23mJKjnBMat/yUO+yD+bmnGUr+zc3Vj2ljgK9sllMHIaKg3gmTzmTGg8ZlegTZw8FF0MkFf4spNH6AU0puNJKagj7iJlcLCS+J9p5P8FhCCWNJLzm2IwMrKWZ3Gwu+LRHFE3LjYS35S0E5RTIBylqlNeb83fiN/E/wcUALn9IQz3ITYK7EMrPdD1VJbqkGJVYvsFxh66o3hnhBY6oZ5gQZ4dtH1VCn0TTAtAw2iHmX1noro3j
 eOLe2Kzk
 cqBcBwhvzqUJEOQMfFMac3te9ho/iZWjMJYqQ5uJckZkAUx3feqLJmXlvnqja0Mt8/V3x4EfnzEIDzvYVrrUtviri+aCg3i5McHc0TI4micB47sy5LiQbJwZp/m+uu44vHasE/Z155EfKzM3QF3g9Ty7uzTT/rRrNhRAggje7OrHcKIuh9xLrR45eWIHzLGaBSbRxepM+pWqO+t6Yip5TVbsuHtn00w5XxKcxyf1wz3yDpvMYtQ762shNFg4rCpevdAJC32FRQUz91qtxt8Y1bdjIfeGtKCfPSVfArmmiodKxz4i8+Qw4nKqPnsvMJFeyObl9mSiT5UEAjhxnVOAjY5y3bSqRWgHSryrOsullcnFsKtbEeWrCJ/wTN8Kjbx1VqQPKmQd2CpDIs5q9CK1zLeNozi2buFj2TXHTgnHGb8uQrPOU9CmUY2q/IGy4/hb3nBrGfNebRoyEBKsFZgyuQiklM7JUvXAmBNnSjxpwuZp546sGTn7te7eHHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 16:33, Breno Leitao wrote:
> Refactor enabled_store() to use a new set_global_enabled_mode() helper.
> Introduce a separate enum global_enabled_mode and
> global_enabled_mode_strings[], mirroring the anon_enabled_mode
> pattern from the previous commit.
> 
> A separate enum is necessary because the global THP setting does
> not support "inherit", only "always", "madvise", and "never".
> Reusing anon_enabled_mode would leave a NULL gap in the string
> array, causing sysfs_match_string() to stop early and fail to
> match entries after the gap.
> 
> The helper uses the same loop pattern as set_anon_enabled_mode(),
> iterating over an array of flag bit positions and using
> test_and_set_bit()/test_and_clear_bit() to track whether the state
> actually changed.
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

