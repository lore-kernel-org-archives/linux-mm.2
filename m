Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D7A5CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34658E0009; Tue,  2 Sep 2025 08:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C138E0001; Tue,  2 Sep 2025 08:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48AF8E0009; Tue,  2 Sep 2025 08:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B2F8F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:15:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67E6952538
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:15:57 +0000 (UTC)
X-FDA: 83844206754.22.5C38032
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf23.hostedemail.com (Postfix) with ESMTP id 52BB814000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:15:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=bJ7BFzoS;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf23.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756815355; a=rsa-sha256;
	cv=none;
	b=TusXCeJaoxQtqrGoSROKdu0IsbIguFPsXOy2VEuleZ/BbdfH7OuiUyyT3HSh1fxCcW48TF
	KPTy4D0SATx4q7peXYv3doovrq4Dns7/tdVCdEQjYZoggzBF0N3zo0Ib1JoXFrcv5dVbPp
	6NB3z4QYqWCB5fW18vAc1ppXyiXhREg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=bJ7BFzoS;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf23.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756815355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SseA8gH1Kt5WU32TGkwvv/o/YEcElQ+UmctNRMOZbf4=;
	b=SAs92obLwqnL3flwyaqMeITvu4bkCPiirXl7eC/Ebea0xX48tzwbsqN0IvDENhYZxZWwUc
	xcRBgiJe8UGue2KKYUxd2Tu1i4vaE1ohNhYPK4np6SF3wyxaUVU608prSZ8x1gl2asTYY2
	yDsLQWE7b3Kxwr7RmOYyip7BEOolmks=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4cGPpZ3Ht5z9t74;
	Tue,  2 Sep 2025 14:15:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1756815350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SseA8gH1Kt5WU32TGkwvv/o/YEcElQ+UmctNRMOZbf4=;
	b=bJ7BFzoSsug4kI4qguV4eSNmegRBgMhTFTaDePTehN1gBpxgKpl3Yqwh72c4wseMXxTsRv
	/cHuMiaNZVt20b7YlCLUUyWGX1DrBAlOLdDoWOwD+gXTLpvChtQWzzy03D5SpOBmYIVarb
	F/CTivV/oy2RlB8jndZ2JM9sDj4nWZ5hbonUl5mKFZ8pFgZpaqEg7b+VfNo+pjzcx7UhNK
	inW+W8vW0CbdzSDhPcfeAcmxDOzpfyPIpGDrs/Ezav5MmCAqbe/ET7yx4Nnll8pGeqO1zW
	VScd3ZCRmZFzOndRzdn4cMstxSp9Fj8mqJ7A8JD4wU/q/wfnHg2h9MZaJ2WuQg==
Message-ID: <90cd5be7-cbe6-42c5-b0eb-bf9613047097@pankajraghav.com>
Date: Tue, 2 Sep 2025 14:15:42 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions when
 THP is disabled
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, mcgrof@kernel.org,
 gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
 <qh7s3j26aac3hyzgnr2ee6byjenstxhjnlwn4qxbvz2l32ohqc@qbhdxvpnuhtp>
Content-Language: en-US
From: Pankaj Raghav <kernel@pankajraghav.com>
In-Reply-To: <qh7s3j26aac3hyzgnr2ee6byjenstxhjnlwn4qxbvz2l32ohqc@qbhdxvpnuhtp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 52BB814000C
X-Stat-Signature: an559rsdr5qoffym4j3m9pbr5s9m6u74
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756815355-116929
X-HE-Meta: U2FsdGVkX1+Yx0Us/zyqCM41VoVTe/tPIwykzwClGkd+wLkvD2jgOcZjBLYfViop1bbIFq4No3AiAhVmg8gNguqBd1RY6GLA46g3s9fInmafuz33IcvL0TrIIEBnstxHfcuwv8HS7p+E+e2bD6ViOpcgT0DHIBraeMZqfu4EjvmQqFm3gQeD8v8r8brZoxgApITlrxZsdWLiZhWG9qfNHYStMq/gN3yXMpn5dbc4JRNAycJ70F5iozFawerWRSY3EMxRqRhaw7bKn4tTVWFrx2fLzaptXWN0G76UpBu+Dyu8rYNA5mGnZf/3lwWUC5BEq3Tn1OBi6KOK1nXwN2vqTdDoaSgkmT2IieMSK+8GbVi3ZMXJo3asSpdM/ORqMdkX+phZSotdS6L9eHyB9OV1w2+hJWrKB301usQgFZ4CC1G6MlkCuVXBbI5CUVxI21Cg6wqMr+LGL8QVibuBeZTMAkp2+5Ak0vI//YarCgpZwuraLI+mmvXkClKHIztPlFHG9x/BhpUOSpmS96sMegv1tfV3qKJg8x/SqmJKw4jFchMgRbID1GWX2JFL/BNA/xlSZXm5mbLMkCNvvr1NvxzFM8/eotXHoVTSJt7H0kHniGpmUOA1VtSn7BZVK6qOSXSkutKhTGAaH68sPWESSF985uHMtcd6lDMFUl8W164fIiTdqKCjt97qRcKo08bpbDijy1NtQd2ehjx5zSRHqjM4+M0MJMKetO6x9+THlrEsjvpODxHDiVpLBMfaGrSQ/ZRD7qkMJvTXRiuupWqiJeqkIolcKFRh36eTEOpMf4UTo2R7zMa9pdeikGoQN4gCnXe+rI0EvbccMo+yPWLKQbJr4h+MsEma5sH74D4Rp0Z5ii1oD4IwnzlI8RFJqtNcn27Nx7jHZQ4BlYUTZduN+i0070RstQk13GyB60iGVX59vJeNmza97WGlt634HrL2ERPNyAgsAuARk/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/2/25 13:22, Kiryl Shutsemau wrote:
> On Tue, Sep 02, 2025 at 10:40:36AM +0200, Pankaj Raghav (Samsung) wrote:
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> split_huge_page_to_list_[to_order](), split_huge_page() and
>> try_folio_split() return 0 on success and error codes on failure.
>>
>> When THP is disabled, these functions return 0 indicating success even
>> though an error code should be returned as it is not possible to split a
>> folio when THP is disabled.
> 
> Other view is that the page is already split therefore nop.
> 
>> Make all these functions return -EINVAL to indicate failure instead of
>> 0.
>>
>> This issue was discovered while experimenting enabling large folios
>> without THP and found that returning 0 in these functions is resulting in
>> undefined behavior in truncate operations. This change fixes the issue.
> 
> Could you elaborate on the undefined behaviour? I don't see it.
> 
> If you argue that this code should not be reachable on !THP config, add
> WARN() there. But I don't see a value.

Little bit of context:

I started investigating what it takes to remove large folio dependency on THP[1][2]

I have some non-upstream changes which enables Large block size (therefore it uses large folios) on
systems with !CONFIG_THP.

I was hitting a weird stale content read error and finally ended up with this fix.

I thought this is a self-contained patch that can already be upstream. My argument is not that this
should not be reachable, but returning -EINVAL will do the right thing instead of returning 0, which
means success.

I hope it clarifies a bit. Let me know what you think.

[1] https://lore.kernel.org/linux-mm/731d8b44-1a45-40bc-a274-8f39a7ae0f7f@lucifer.local/
[2] https://lore.kernel.org/all/aGfNKGBz9lhuK1AF@casper.infradead.org/
--
Pankaj


