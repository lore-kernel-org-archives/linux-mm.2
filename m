Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42594CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 02:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49056B0088; Thu,  1 Oct 2026 22:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF99D6B008A; Thu,  1 Oct 2026 22:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12656B008C; Thu,  1 Oct 2026 22:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACE806B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 22:54:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 396FA1C34BD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:54:46 +0000 (UTC)
X-FDA: 85276168572.30.36E4D0D
Received: from mta1.migadu.com (out-154.mta1.migadu.com [95.215.58.154])
	by imf24.hostedemail.com (Postfix) with ESMTP id 04028180002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:54:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=emUaZhWV;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790909684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slDZLd5dV87dPgM58kc9Ukbz1sFC3SuKrUAkqXYv7AA=;
	b=3WLEB+/b1rqQcRPpbLxfuZfLhfhckIHf2/x73soAbxhxb2mHoLYYR0IoadADeZzPqMACOQ
	yzco3+5HOnIvSw5uYoHA5dg93uNNVg7Aiit5YDZ+ObROAkLndEdKt9nWJ0A2br5VIiPPdG
	nMWT/6oAhcANWShjgouP76XUNmkRJ3s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=emUaZhWV;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790909684;
	b=hdsYsNw/TjP+egjuTok3VbPKiV0enTzobTk9vrirvRVtzx+/qsRD6YIdRHkYtea7zLacnj
	v9HQjP3t6rqBl0joNEsEysWsSC0V/PTFQwjmtl6sK8tVNoF2sEJ25TC7xyWwGbQCJiV+kW
	VmZWZLe3CiI3pP2PAG+tzDuwamXEF7I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HkIILgkGXX/WY6KPEW4mlVoPl1sT6CpQeXG2VxvxdDI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790909682; v=1; x=1791514482;
 b=emUaZhWVfbgMR/j6MNWzWvKo+SRbQigTqHwfiatQjSGs6K/18xOOCC8HjjY6pCgEFr4rRP5O
 vd/QDwPkcBA2+uryD7ajQclCsjax3T0NeZN7TaT0HQyGKWvyRWL9QM5VcfdFBCfGzc74m5ewgU/
 rtPYdrj4cXGAoMEXKDwtgCSI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4e27fddd3c8a9abe;
	Fri, 02 Oct 2026 02:54:42 +0000
X-Mizu-Trace-ID: 4e27fddd3c8a9abe
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 2/2] mm/hugetlb_cgroup: add trailing #endif comment for
 include guard
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261001123747.634845-2-lienze@kylinos.cn>
Date: Fri, 2 Oct 2026 10:54:25 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D26529B9-9331-4B60-B811-23E616308EE2@linux.dev>
References: <20261001123747.634845-1-lienze@kylinos.cn>
 <20261001123747.634845-2-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04028180002
X-Stat-Signature: eq1m661er5btdbxsdp48yqhczeegdcnw
X-Rspam-User: 
X-HE-Tag: 1790909683-318784
X-HE-Meta: U2FsdGVkX191ffCx3nyj801Srh+FKWE6xxKYhFjWe2N0yR7TESgAXvcPEA8Vkg6lwNZK4/mTKbFpo1GZnKLaOyinc7BWB1STLkkakfuRuKzdeMQAHM9GNBuD6RM0aBZwytH5LzBR5yjnUMKx29BBUWFrNY1RlFSLYRjAUwFrxfXzJ/wUmJxI2MTCYWugKdNm1fafTyfreV2wUR6PBoOim+Qs4zbTIkd9+HB/6s9uP1W2x9EkRLAWScmiVZMsEoIVgHxjxSbyCikeNfrrXRS7WwTdAO4VAua+UHXjlcxtGLwiVwT+sTNOBeEJSy+/msBBwhaYz90Or6EdpLt3hqOeEs4HM7Cz3fU6NJ8rcfz0GV8qB82TbCYh3si10BWDKgjIR6NM0UTqflmvMauXWOTvB0NYlwYQe8yLb336X0e5J+uODgel7v73HvFFTd1qdvadr3MHyQ6fWXjyaqq78eLYVdLd4QwrkkgIXAY0BFFsdHmTwbf1oB43XzlRO5BqcYa//G64UKImB+s6LZ2+ytKrBzcI3eGXQQLVTwbcgwu6xd7u7oPQkzx5VnADCJNLu/PuKo0e+SyMtFlUJKVMaM260sfrw+HTpFkk+HbuRsr4Q5CdNmA7HzLzlXZl7g2vv79kdzOtFSoyPqxgOyh6Atm0iqmBjlm8qL+2O8YYz9/+sz+Fe1L8NHEq1eqZ8qwzdchcXgNltxTCia7CfQ/GpCH8Zvchb23uH9upeA3CecoeL5frI71w+gDEnFQ20mGv8GdnA1uekmR/26tRI11ihIZfcAO8Sk5FSWgDCWJP0jEdjR6WJLj2mwkberfiemlipZR3E5cLG+dMVQKjSFL+CQYeypb1LAwSadAijWM1ofrXhdIkpRiWaSmWJJeRhPkWr1ja2MLglgXfnL9mtD3jRpWpOrxx4+LVTPZxJ0K6KMSLO6HVCPt5v+9d43PdBsZiExQTd77MHdS6Sf3TbfgIULO
 7M2Qo8vh
 oyoE+G4GLXIE5BzU5rEQuUIhGzhbW7d51UOwYDAb6dxc6vns0njLyjxdpPaQR5dYYFTkmuzVNucpjRUCEPqbvTvMKG4BijN5FXUkk7+65G6EJLwBfPVMJGxSDvizI9whmPMvnihholJ5uCk8+XBwkhMGOBNMEf+4D4I13FxVWKB8/PNpsVfftZqSezmhdOGLBnGvyRZ7kl+UE5sS1sjI/dAx6hHrG3VVtcLU1Rwov0LqzueG8KA8sbX0+ZE9LvJ9kG8WVV1GRwdM+YqPtep7I21fCnCcqZyNJFmvy+QwcpToVPUUYMDgP4tb/Mz/gQsvj9EoC+OXoh8uSMLM6RQUw6IkCUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 1, 2026, at 20:37, Enze Li <lienze@kylinos.cn> wrote:
> 
> The final #endif that closes the _LINUX_HUGETLB_CGROUP_H include guard
> is left without a comment.  Add the macro name to the comment for
> consistency and easier navigation.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>



