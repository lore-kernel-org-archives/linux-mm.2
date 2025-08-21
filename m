Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F0CDCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 22:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E27D8E0068; Thu, 21 Aug 2025 18:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA688E0056; Thu, 21 Aug 2025 18:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8998E0068; Thu, 21 Aug 2025 18:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C28F8E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:13:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F367C1DCB4F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:13:13 +0000 (UTC)
X-FDA: 83802166266.02.61C2795
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf02.hostedemail.com (Postfix) with ESMTP id 436BE80009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:13:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h8Pefxhw;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755814392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1we+bJ6V2AfpLkp6IHq5DrAWOpBX+5HfYRZm0i8tWDg=;
	b=y7oHVj/qvSqmaGM4Eu+Dd4NkxteaYILZJ/0iAg0vkJM6AK2SSDfjg1OIA2x7XVGmZIJUzr
	7Xscqwl5H4+TcPHHnD0jfWYhCMoDdgU+HshY/F5mAj9PHHmUxAlxZNbm8P3I1HWBnFwR21
	DmLseyz4NZ2OebAYSAOPG70gg+sClOA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h8Pefxhw;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755814392; a=rsa-sha256;
	cv=none;
	b=iuclwBED9Ne3NBoLg78Qhxp3BqEYLPAj8kWzbUEVkyG3yClF/Ilxr9tA2WXn1xWJcsmT6e
	WNhAWJATZxB45zl4a0ONyX7AM1PPtlq+vyphdTDx+oyYBYkwXRND7Kij6FKXPEctpSlTl0
	PB6p0k29LchqSVHtYd65bdAH8QBSyuw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id C71F85C5996;
	Thu, 21 Aug 2025 22:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA09C4CEEB;
	Thu, 21 Aug 2025 22:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755814390;
	bh=OZVsV1pjh5cFcCuKO5I5KInQUt83XkwpyN8e5LAvhKs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h8PefxhwzUDkEVO/G7Udqk5ywBFaWt9v80jL/AxtOQi2x3HrajmGLKlp/Jzy3IK33
	 jRNdGw8nWXvygM/jJFn4eftYLX1BV7wHKc/GKOYZJypKp3M12AanRlfcEb8RG6EBDB
	 3AU+Ot/yjoAk7wmY5xRhet+2x2RivUMY3LZGC/Qg=
Date: Thu, 21 Aug 2025 15:13:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, kernel@collabora.com,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Vlastimil
 Babka <vbabka@suse.cz>, Albert Ou <aou@eecs.berkeley.edu>, Zi Yan
 <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>, Suren Baghdasaryan
 <surenb@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Palmer
 Dabbelt <palmer@dabbelt.com>, Ryan Roberts <ryan.roberts@arm.com>, Leon
 Romanovsky <leon@kernel.org>, Shuah Khan <shuah@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 linux-kselftest@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
 linux-mm@kvack.org, Nico Pache <npache@redhat.com>, John Hubbard
 <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 4/8] selftests/mm: Add -Wunused family of flags
Message-Id: <20250821151308.915362b14e82f5626f659481@linux-foundation.org>
In-Reply-To: <4abd97fe-412d-4e3e-9efc-cf3092d66e57@collabora.com>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
	<20250731160132.1795351-5-usama.anjum@collabora.com>
	<57c816d6-a9ba-47c9-8f40-3978580b7f67@arm.com>
	<8e9d7c59-46b4-4e1b-8a55-1898302f5080@collabora.com>
	<88ea592c-c6ff-4a19-a366-eadeca66b039@arm.com>
	<4abd97fe-412d-4e3e-9efc-cf3092d66e57@collabora.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 436BE80009
X-Rspam-User: 
X-Stat-Signature: 4zuqaeg99rt8fmoqxg599eqjrmsu1g43
X-Rspamd-Server: rspam09
X-HE-Tag: 1755814392-270735
X-HE-Meta: U2FsdGVkX19O6ZCq+Y+GFnCkUBIN4FMdvDpMXLuNBdcs3GMHYvEzE9RQL8aTY92PjG9Esdc+VyUECn2ti0b5hFAZml29bLFj1spkw1kN2YWUKgzbgpNi3DkhToC6UG638CVUgrTDxDtXR9HGPyqo7hi0ytKmHXaLe/ee0luVTtIeDYeK4K2ACNAs8/iRlOX6Q/0U5+qJq7vIVAqP1Pkcgvqr8EYjvPplmM40orlvE4+iLCv23TAd99gP2hay2YWhvhvjmFfEuXWq4KtEFMAVDrcqp1TUDX6cdSCe6VAnzwHWGuG2MqYbQmZ5TQLbPPdjtiHEpn7h/RElwOmvwYou+iLp3uSUm9d4qOvVx05jsh4y5YKL8utojWsZCkJXK5AmmK+t+RyAIngQinoH3fJ5h5MbfcmNgfdU8jhDJLjYfmzPT+7UFO/6dDGOX7Yo2kRCx8OToYw3dTfWMcpOgi6YYnkRmKFGd7LUNMhFGQBI1o56eZEAO4BslR2+eAOW2mooOw76jPyhN1rNKbCYhCVb3bsc8uDcmwcyb+gzB5dyqCk7mkskfz8sjYBBKtBn1eb8H5b+H0Ah+nHx9FmHah+wS4QlC8awNtD3FuwGevseCfO8bXCBhz8qLNgXsF9uCgdmMVAuJsvDQ4nDoqApHWMUIHqhsD28pBWJdp4kOuHGpMd4BQ/Z2w6FZxLfQ8g5pWalpcUCUHTezKL/zH9TXmKLHuY889qazkz7ne3+bTrhONSYdByXWOXl7MstD9YCYI6i31yaS23qxwWiNN2ft63yS4MFu4qH1oyZZr12vDVjJ70xqhFkNrFfhpHFy+CwS1lydC4z3N/X32RYcieLZPPM1hNigLoaqPwDp+KSm4m1yyhPLz11cHNHgwVmjsVbQsCVH+WCWKMLTPW8+TO/+CSFlaxvPd8ZQQBF6Pzb6mXSJGNJ/R1lZUOSyJ6Mn6QfvlGKMrecxAc54AjBK3S17bZ
 RjP9rFYq
 q1cuYalkPFgJgGhnmdT4AylbqwNW5w3cVro4U2SlOHfqxCXtyW0iTOcxmCQjWyOQ6pBatO8SA9sEDUnVZ+7vlzu6YWHyLK16/RzjtHYhOiCH3OvvusWgVsdzTYTC2sKCGkcMTcbYMjKKeR9kqHoGs0oK4frrZ8X6bw9d5IPfdPSFX49Y0xybu/ClrO2mwlA3RnA56GBDjlNjQZapxNkf2Jjhkft5wPPVhH32U78gt5ViQZrdeN36qDn8HFdMMni7nn7g9JBAmFxCyTdr66aFq6TpPNvE6QCvy2sUARP8OQ6TdS/e3xZHbfP6zCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 17:31:21 +0500 Muhammad Usama Anjum <usama.anjum@collabora.com> wrote:

> > My
> > feeling is that unused parameters are expected to be allowed in the
> > kernel and it isn't helpful to go against that expectation in just a
> > small subset of kselftests.
> I thought kernel must be giving error for unused parameters as well (from
> my memory). But just checked and it doesn't seem like it. I'm okay with
> dropping -Wunused-parameters.
> 
> We need to drop patch 6/7 and in Patch 4 should have only:
> 
> -CFLAGS += -Wunused  -Wunused-parameter -Wunused-function -Wunused-label -Wunused-variable -Wunused-value
> +CFLAGS += -Wunused
> 
> @Andrew, Should I resend the entire series or would you can make the change?

I think a new series would be clearer, please.  It's unclear (to me)
whether Kevin's various comments have all been addressed.

