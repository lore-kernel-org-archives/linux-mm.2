Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14713CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 08:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41C2E8E000A; Mon, 17 Nov 2025 03:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCDC8E0002; Mon, 17 Nov 2025 03:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBFD8E000A; Mon, 17 Nov 2025 03:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13B178E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:05:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85F8112F68A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:05:08 +0000 (UTC)
X-FDA: 84119363496.05.5BCDE3B
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1ED15A0014
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:05:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="I9qqN/iK";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763366706; a=rsa-sha256;
	cv=none;
	b=aw8Swj2NQE8bQvEBOLILugaPLvVFKuUkpx+MsHvPcbnqtM9mDdkuqyoc/+f6iC8bmS+mQS
	O42ILqI7/eA4UwJNtWGyNP6JqUtgtctZEdV6eRxeygddrktwxrY1p80exl4OjoWnA8pGYJ
	5srC5Y8CAxA1d/Vsa5ooklYAMUhJfgQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="I9qqN/iK";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763366706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+givsy66KPU6dru5/NMMC51q+mf8RMP9RVy+1pSPm0=;
	b=1pe/gKnUH3LjwUHhx5dwF+L5aPW8AOa79HdtjfkgYrJczV0rwTVbtnYvTXovCsD0TiiQ5q
	3OmSFI0Av9KfY1ZIGmFgl01tgsOuw/zMZPReVgjmQALCWH+JIj6AQO1Dwz95QLxDUrCgTj
	UopcRp6G1308neuo8EhZ+4bpj0xqg4M=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763366699; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=E+givsy66KPU6dru5/NMMC51q+mf8RMP9RVy+1pSPm0=;
	b=I9qqN/iKSuzgzRn3KdrCz/APMbMKjHu8RypnaLhrCU75yaoBm1/r9evPPoenDnIOobH8gqyNYzj7WTqG/uFvSxUtuZ1elJKuFPYTGs+4ezH9QvmKzkec2sdfhYsuFZkAUyJD25LrPwLfOwYudgVoxMa9gn/9Sa9yP+I6n7n7hzM=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WsXKVor_1763366697 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 17 Nov 2025 16:04:58 +0800
Message-ID: <b40ccc9b-e71a-4522-bf34-75d9b2ab560a@linux.alibaba.com>
Date: Mon, 17 Nov 2025 16:04:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 1/3] mm/khugepaged: remove redundant clearing of struct
 collapse_control
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
 <20251114030028.7035-2-richard.weiyang@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251114030028.7035-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1ED15A0014
X-Stat-Signature: jkd63hr3de6yqpnrmgrppxz1hqcfojpu
X-Rspam-User: 
X-HE-Tag: 1763366703-194447
X-HE-Meta: U2FsdGVkX18j3z3A5b+I7B546Jj1d5zrabfvDSmCDZonyruhKotqhnddFfI6vlmaWldnGrYkn+GS1RAvBQBs02pj9KL/QqLqoYyoT5afOpMtpPVwhfNjGfPUYXBvr4URrPAPW4pZehiOjow7ivuRkF7pkB8rcaTQx7JUmbx6XrLs24vzHAh3tuJXo5EmvvNXLv2P5tcbmzNRfBmTUxNZdyhS+geDBuSQNxcNAhO0w5wW0Amw/1OZDip6qK2NQrmAba/6Lrtkds1kzwgFWsrgy3DTOcd+j1iBWYlaX7PpfBPPS4JleMVtRsgZMECiz6DwjJxAPxe6Vd2cLxCrqGn/z8hu3Hp9z35PQxM+qDeRsUc8LIF9w8XzIAYJV4B40ph5GZjaKvnlRLpg1Nw4EXZ+sfvg5/35lVV4QjqQPALdKb8HX0rKcyHzjPk2TSTkXMJ0ytnerEXZl3jb3mzlIS8TRSwCXNiQVb5qwDaMwcFQCYgd5CN06ESgJqFAizsJx9F+XYnE35M3DQCUs6uxaKtVpGSYR4lcVwZ61SCMR4/kSUnypyNQzvZZf+cHKJMYGyBt2W7Wb413QrkuFyF0+rNF2pHpglZySsAPHGzOiGmScaPX7ZF9h5Y0Tf+yc+u8pa2xKtIOhWx56sFgz2BORPkYnANwg+9PI1ph22I4v31JULNkJEdiHy3sYb34fHnf6CGlBf2QPanQjWNldFxzK4xu6TH8v7OmqdAGyGw6kKnVfLOQz5q+d011ou7/6VMnYjybeoxiRmljVsFW3fa2xqDIiA46B4kCmu6dsWLVKYZAF/lv5uPdIr8u3F0sWqLPTxu7VZxhwovdQ99aTqc+WZ8lV3Ll4ZcJh8EZgeEJC3ifn1Fw4jLAw15DwlldKhib/bonTynu+KiGWio1aD+Znboao/lMLOmZRiXQAkk0fpvIGMcBQlfKBVfAs0dhUA5TDHqloouWXTU0a68eCrj4QS7
 8jt5oRnD
 tLhS1Ta8S5dSdsCFYqXi5oFH3vrsi6mi/1oo/OQn/TjlpoUb/6rcVAVwV7XXJ0FYQwVk40aRwZU4TYZEn5tHwYgXznxNeEVbsTX8Vqo5/xXLj+JGONW4vkM81dd2zS5ZOsckRt8d6GiRXwbDkcymJGC21dfjRMfHyQq7fFCovL7mzT/6wjkUAlbMrHYPg9LQziuBxBR273xL3zCgsMIuOGmGaIwTdtOdoLDLSfWTRzQAuw2cxSpSFWQXPs8WzMj0CUQzagogGs9TgyUIYIqUr+LjgAp+Pxq3Vhm2EwrvV8Et3eBIylPaw1QvDYLzCI/jlS6thdrj1b5zYycQ0No+pqPw+NIavEfDbNcU1U6z/EA552EUVh+u8lhjZDHPmZd25QXFbDXVLbC72h7rSUYeFx3b4u9GG8q2QCNgquGeLH312GTMZFy/Y2L3vqsqLDVIaIugD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/14 11:00, Wei Yang wrote:
> The structure struct collapse_control is being unnecessarily cleared
> twice during the huge page collapse process.
> 
> Both hpage_collapse_scan_file() and hpage_collapse_scan_pmd() currently
> perform a clear operation on this structure.
> 
> Remove the redundant clear operation.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

