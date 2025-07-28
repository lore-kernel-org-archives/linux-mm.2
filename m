Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3E5C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 11:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1145E6B0089; Mon, 28 Jul 2025 07:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ECFC6B008A; Mon, 28 Jul 2025 07:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D236B008C; Mon, 28 Jul 2025 07:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1AA56B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:00:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93AA41A01E0
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:00:08 +0000 (UTC)
X-FDA: 83713378896.08.AF2600E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 22150180011
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:00:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ng8IzceQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q7FUE0s0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ljtXYZsO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tTqAoqf3;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753700406; a=rsa-sha256;
	cv=none;
	b=xKOtWcKAEus2QPSiIqE3/CftvZX7t4RE2BqiwkxaPVXNixeTJr3LSz3Bi2BTUNUkz9b91B
	XkH/lt5eJnmek949iIgFceMMAjlRIGRDgrDIBrcU82xEGCARuPKVcCUU/5bG1MZ83wQlgu
	XW7gi3giegA/2vqztwqvM/nMk9jzrsQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ng8IzceQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q7FUE0s0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ljtXYZsO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tTqAoqf3;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753700406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmK2EGG/opQy2TemRI9zb7zj0UjzA9Rw7lDrKHGU0Gg=;
	b=hwmH8zfuEy9JgQgn4vYh/daZkRDFs6cLY46Dd6dKkQC1JGpmsBl6ny3hvzkc9GquDCmsAy
	kZz7e77JGzuL0tVdtlbWbXCAIVufN39npCfTAjj4IoYREg7xY1Ip5RI425LkHdoQ0jTmJI
	oIv0BYl2TizU9ZJt0CEZw6y+iKkCdA0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 330F21F86B;
	Mon, 28 Jul 2025 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753700404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hmK2EGG/opQy2TemRI9zb7zj0UjzA9Rw7lDrKHGU0Gg=;
	b=ng8IzceQ8c6MkxXNmgRx/woPnGMkWw779Zv97FB/r3HLEn+A02O6w2fUFmoA2Xkw2uTvsS
	lrfeul1TRVppe5ZAWxIK9C0iMBxpwGOAAb2VQqLyEKlwtRxngTZJYHGAPsXAa23bSnh5nP
	85u7rt9hX2d/Bd/szTc/orVy/mr3m1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753700404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hmK2EGG/opQy2TemRI9zb7zj0UjzA9Rw7lDrKHGU0Gg=;
	b=Q7FUE0s0KBOvejJURa4bv1Cdrv8TOV3an/Js88KXuYBA9FAlv0w1GRlpHCvvmnpDOMcsGL
	09TssHfhs5EhDaAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753700403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hmK2EGG/opQy2TemRI9zb7zj0UjzA9Rw7lDrKHGU0Gg=;
	b=ljtXYZsOeMP1MNQ+AzLaXj6UHtt7/jQhYLtXMcuePbf7bF+sqVpxDJlEVB+CN+BqrlqzsN
	+Ds1rjRXqo0km8z/BA/5xa0umDpjdiA7z08AiJ8PyuGeMZUx2NK+fDrr5PhEzMSkXEFGKm
	dHeI108seaM+H7rE+x/qrpDafg0Fyo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753700403;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hmK2EGG/opQy2TemRI9zb7zj0UjzA9Rw7lDrKHGU0Gg=;
	b=tTqAoqf3t0lAvauXnWOhvm2Fy5yrnW7NQIXnfPS2Z4zrXBYLxID5KPwl96QZT8DKxV9Nuw
	3/+6SjFFyopMK1Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 24138138A5;
	Mon, 28 Jul 2025 11:00:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pVh7CDNYh2h9TAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 28 Jul 2025 11:00:03 +0000
Message-ID: <b89b86a8-adf1-4669-a67f-da1377c220b0@suse.cz>
Date: Mon, 28 Jul 2025 13:00:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_mm=3A_limit_THP_alignment_=E2=80=93_per?=
 =?UTF-8?Q?formance_gain_observed_in_AI_inference_workloads?=
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, siddhartha@kenip.in
References: <d8ffe547-5516-43e5-9f33-56b2698a0b4f@arm.com>
 <ba2c89bd-88de-48f8-abd0-b62d8b1d50b3@lucifer.local>
 <5816677a-705e-4a8f-b598-d74ff6198a02@arm.com>
 <ee92d6a9-529a-4ac5-b3d0-0ff4e9085786@lucifer.local>
 <e7152150-2f3e-4ad7-a6c5-f4b77e5c0e05@arm.com>
 <f746d3aa-17e7-4b42-9e08-97cdb2cad89b@lucifer.local>
 <80b849d4-faf3-47a9-8b8c-e8053299cfb2@arm.com>
 <2e99712b-8dac-4762-9fc5-fe3ef569b65e@lucifer.local>
 <afe95bb0-185b-4c4a-ae41-e02457422cc3@arm.com>
 <787639a1e6a27c0f3b0e3ae658e1b8e7@kenip.in>
 <5c3d307f-d303-48c3-b730-99a83d4815ec@lucifer.local>
 <6eaaa2e4-9067-47bc-8dd4-d8ef56c26b3b@arm.com>
 <5D015E99-474A-4D98-8C43-488A46BEB2F5@nvidia.com>
 <fd6cc30b-cc8d-4003-ba01-fefd5d696ec6@suse.cz>
 <57c50dbbccf38a97e6e9cbb3f2f75f01@kenip.in>
From: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <57c50dbbccf38a97e6e9cbb3f2f75f01@kenip.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ozcyeq3weh4z3nzensunhtqh7gy1m5ic
X-Rspam-User: 
X-Rspamd-Queue-Id: 22150180011
X-Rspamd-Server: rspam02
X-HE-Tag: 1753700405-645615
X-HE-Meta: U2FsdGVkX193oJdsmr8HUeCYVifKOZcFFWWaorNuxoOUMV5N54jcjB3U7uBFSmfirB7LqxD+agovb992ZLzmXBDDtVB6EC2VNRWHjUxixypZ86vOsvrmO9lhr0wTgwpE0J3BxWBHJqm3jYZTs4xPX/WVUL23H1lVq2h59X0st2Plma26mcXwKsDpET8Qpmh2uVbKJG5pkQopifKrBKsJD5/NN/WqzMnDs1EJErCsP864Hujno1S+aJHNlWV3gXYXfUb0Gx5QK8MazHgpRF1oJB3H36v+7f2EbkGttSJHw2v9rj2+m6P4VxBkitFbAqfBKRdj+PWyRGHhWENHxBQRP9+rU4T3f9Kp+d3p3WVa9/9/EvlyiquOW9Ty4mm+9Bzc++2pxIkmb6ViFDAJFoejQSfg7lz6E95beltFtj14MZIDufSHpdIqmTX3vRyN6FMLOxN9GSjo4i1kGlN9KFCyi2ynUC7jltti3b2n4hE4Nu8vdgv3jTEl9QSeMghJuyurZERZBiLkjqBqaKnO4cAz1pvaPFoa8/HNErebb9pDCLcbaN8eibC64/XKZ6TEyUXi9bWO/3YLTzVJtMqqsbFGenuYIZWjmi7xdf+B4XOiVa5fCKUYu8qyrviVpyWUbhbjZoEqV1mXYwpw1qhE6ZVrwYG1eVN1l5pPY7rGS0tWEdJHNjvQkkvl/uQ4lDjgHPRGS7aVh3dQygsK3oPsVcZsQ5WgyEvKnAfmPdKST+QYr3c03uvFShG0ZtNx3LH/SkHJNhrU3BjMo0jPpkLZRI33PYFMb5DhLQ+sJ8xaWu8aHeu8N+WzXEMqOtRh5apRr/yeVDPwfap5BND0AuD1+HQgklRkpml5ph2G69CdLvbrNMttQoLH6Zex2DOiWtaJVq1/uTSXccTlTwW02xKf3LdfHN4s9OvbfIBybyKDyFGZxoLqKxm8MHecTLUPvAoBVk9WV72cySmLEzQFojEGXpV
 QjSdJm2g
 WP+Ry/+T55Tib4TFzC8juiOYQZitYIfdKFvfmZ5U0mQJxnXH6OZZryCsEG6zMSCcCqiLbCH9Z127b9oa3Gh5mBamKmZf/6hLmhpgWV3zSbcu8WC1+04t+BYWO28YyRbCdrn56xfxDYSCv5kjx1fppWrAV8PQsD3m5tRiFIKQ1Mrn0ImpFV+JLLru9NEF9730QOE500JU9RCKrPJ8s4dCfn4W9bsr0xFWL6dnRdZjrmAWTl7BOPU/BP/IgFckx2ZsddQ/Xh0qSrxXHrgZYzGoh+vkD1dqm6dfJJEN2R44o33PJdRAKTnRtSrVo1GAcybHUfVJCgxqZSVv6K3dquKf7QC+9pQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/25 07:41, siddhartha@kenip.in wrote:
> On 2025-07-07 14:26, Vlastimil Babka wrote:
> Hi Lorenzo, Dev, Mel,
> 
> I'm following up on this patch submission from earlier this month:
> "[PATCH] mm: limit THP alignment – performance gain observed in AI 
> inference workloads."

I'm confused. That wasn't a patch submission, but reporting performance
results for my patch from late 2024? (and thanks for those!)

The patch was also already merged in late 2024:

commit d4148aeab412432bf928f311eca8a2ba52bb05df
Author: Vlastimil Babka <vbabka@suse.cz>
Date:   Thu Oct 24 17:12:29 2024 +0200

    mm, mmap: limit THP alignment of anonymous mappings to PMD-aligned sizes


So there's nothing more to do here AFAIK.

