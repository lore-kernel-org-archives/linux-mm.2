Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10CB3CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 10:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21AED8E00E0; Thu, 18 Sep 2025 06:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CE58E0093; Thu, 18 Sep 2025 06:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BD08E00E0; Thu, 18 Sep 2025 06:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E60A58E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:12:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84B5B14085C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:12:52 +0000 (UTC)
X-FDA: 83901957384.23.06E8E55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6675180006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:12:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+jbxauw;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758190371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lBr/QAzBiWGNGqKC3WJ0+mxOh+6eQYMDMTmyp1Ahq8=;
	b=TYd+JvuWl8jShE2XChAo0DuPC4//0EPRu6maY3E6msvVqVPx7UXI0qKpVilsoG8Wp/A7Ti
	jsUW8floC9jziG34m5emzEmoRGbuXYHJpS1v2M+NA14+7eUoCrUAKP0QR3NNb3M4krsEwB
	9JQy3Sv+CmeZdCz8uIGZCUvjlgU1uuY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758190371; a=rsa-sha256;
	cv=none;
	b=gWZH/QlUh3ogCqmSWVU5LVxpiqQ0nG01M4qsMMzzxVgqGRs+wJB7EJyJzpZlqtRIY5msz8
	IDrXFJIYWxTAE9B30gfDcsnpUGwQXXRSDRED3jJ+GbDjLJkzNJKeLC66mFu/pvhMUvQAQc
	fdnooOfFQhxFzZlS2r3OfDpFNaVZ5Js=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+jbxauw;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CF4E44560;
	Thu, 18 Sep 2025 10:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BCBC4CEE7;
	Thu, 18 Sep 2025 10:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758190369;
	bh=o1Cwy5VJ6G9kyEavxaxVgKPCYtlXDCW5Fv2OCftslK0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Q+jbxauwtdR3DlNbHbBHKcz5hgE1MjHos4i+oNE1mJHqF5Qjt7KV/JZS934WuliS7
	 xuey86HpA+fq59AA7iPhj8V3tTwUVGBSBsGfH/6D11xsRXVnkN563o1RbkRkmj7Sb6
	 d22+zYFiTxbHSr9uYnoClv4geEe7jsUQwdPAce8XCrUFTHdVbzCvmRnc0T8rMvU+FE
	 9jqz6DonfGwvKKRwFGWPsEMHgySm1ktjfNWDzt5dn+XR2tUWXqTRhobZBotKDgvoyk
	 taR4TbkICqh+e6ofP4HSEotbrqSEGGvBdDbmcvrd9COPTJzDZMoGcVXjGm+MYsvddl
	 motQ1jDffkubA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,  Changyuan Lyu
 <changyuanl@google.com>,  Chris Li <chrisl@kernel.org>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] kho: check if kho is finalized in
 __kho_preserve_order()
In-Reply-To: <20250917174033.3810435-2-rppt@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
	<20250917174033.3810435-2-rppt@kernel.org>
Date: Thu, 18 Sep 2025 12:12:46 +0200
Message-ID: <mafs0a52sgjc1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 9utgk8skg1s7mf1riwprkyozppgmiabs
X-Rspamd-Queue-Id: D6675180006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758190370-576601
X-HE-Meta: U2FsdGVkX1/CjZ7LU7tNXuKfMPDu64jXT8RLKwdfvmfNcvATNSxTRVJm28qta3Cyj9wuSSJpB7ef5oKDM5Atb3DpC6C5i7FT0Q6aA23JITTlYhRr8dTCsy+Gr048a/E5lTbIQJ4u19iL3L10HWPgpZ4i/0l3DPE7DtjbTi1XbudabpibENWHM/UVTprXfbwEVlU2ODB1ScDYucyUlrHd8DoPnhzeU4zVe6otbmwRevcTtO1+qL9Yec7p+D2UgTxUiqtbN1IOomDfE3x1gIdjg6K/6pipjEv5MSEObhxvPjfRr1E048Szg9Ew3RpsfI2kZBvTEOqu1zLQ1hNooactema0RMY6jq6TsLHi9bdVMEr2Toz7JUSeHgLSOxm0mU8eYxwAt++bDddnduFetUFAOwXXQGCtCiDYpl4rfs16x+3gvQ52zt6y+BLJ5UIO6Q2OnYX0X7r+3f5WTzUtB/XVqjv/f40L//CNmNdszvr/jOWg3UH29kE21xNiaV8r067M4Hyyha5yGaMNNn/RkU3QPmuWJjvevWC77Kg0jparEAPLwO+nFkV8an+z7JQsUQlcHtsHj5yy3vFWakdGI+WMkHeMeSmZQdrlQCodB2pPlpktSnxS6CHKrEY9LBLOhYwte4ai6DibrDyWKCye06OWFMBpjqB9/2A054XLwuLHHMHFj4Pb+FDLRVVrN8y9zXpmbMz75OIp2VZMrNLEplF/F5qy/Zu+saPw83EqhBE9voBZC/Vklm7J3Omvkk/48Zx8mui8cXeLLkSJQ2shoCjm6/3Q4k+J5b9S4MHPlfvOOS+kRcI1FYYSEvFTDfCZIInCzG5CSSxA57/K8DKQD3k5qg/OpGUMTlxvy/mGPvmrXqUPvRAxs4IPEV3I2pYV3S6it6/yPL2L9ssQxm31H7J/WdYdaEKpG9K842OEJ45Jp1PpPkKFtSDr7LHepqRPvbuBqV+za4l1W+eD7Ov31op
 ZkbHfai3
 vFSKYpaXMaXOzUfUHcdBR3v6CAatB3mJBt4cY2o5jZnPxhGv7cpPApobmMteRJUXiIbCwgkH0GdEYRBgDPdj2uGzw4xAZiZMZM+s3Sjg7I2m2lwgm0ErvJl6zM3bBFCBdxIKewScqDDGQxvv5++IH3cFfPVNx4g8SvXVlhNunHlLxKkXn/EeejeH4nmzVRkB4URFQZQ82u+qnM7IffP1uCcebjz8Z5PFlDFATD/cVeGdpSCBKU/MdnajRR3oMU5F8h2VIBIMGZnEFroQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Instead of checking if kho is finalized in each caller of
> __kho_preserve_order(), do it in the core function itself.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

