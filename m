Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFAE0CED24E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592DA6B002D; Tue, 18 Nov 2025 05:20:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A5E6B00B2; Tue, 18 Nov 2025 05:20:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459506B00B3; Tue, 18 Nov 2025 05:20:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33F1A6B002D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:20:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 108C04DB84
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:20:35 +0000 (UTC)
X-FDA: 84123333630.01.3235217
Received: from mout.web.de (mout.web.de [212.227.15.3])
	by imf23.hostedemail.com (Postfix) with ESMTP id B26CA140004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:20:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=k1ZqCwo8;
	spf=pass (imf23.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763461233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oj205pQzf8esrTlWJ/hsEoj4HtfQAeTImIFj0srX9i8=;
	b=XXV4O3dpJAsp9/ijiBpI48zkr99W1goFn90HXNYy/SmpTxMm9lJQ17loITn3B2nE8roMX2
	krtIchqbtij2sL2wxKQy4GMec/DZzUxP00uw+C8/7HNHlyfsBnj/a89ir+Yci0WGzWcQD6
	ht4JqfxGX+IVY1FsbleFN/BHym2/y1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763461233; a=rsa-sha256;
	cv=none;
	b=iaDw0bznArE+pS0CBFKQSheznvJKTJiQg8qBKiIQav0ldv4RXexDQGHx86asv7ghaCm7Qk
	VIjSZ2efaJeDgOPkWrJDlKRSFR0F0VNHvOFKKLYTTqlGkaBgRzrmo43ARWXbVcwiPIMNcq
	mu8CHNy2uxCW2cy9mD6RSSsnWS7vgkQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=k1ZqCwo8;
	spf=pass (imf23.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1763461202; x=1764066002; i=markus.elfring@web.de;
	bh=Oj205pQzf8esrTlWJ/hsEoj4HtfQAeTImIFj0srX9i8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=k1ZqCwo8LpS0I+uq36uGC6BLfwpdXVImfRmNYuqK4GGnyIGD1rWbngfQ8Y1sSHyU
	 c6DdLww1uzVllroF8jzHtuchULqpIw2YNuuq/ckcB7ePYnHbzpQf6Lio7Zywj6+Jx
	 NZED1fCuJ2a5TN9m5D6uCl20yxwkpm23q4xhYKQ/6xkq7zEDMGQUo2sil/cj/0wRa
	 eyCVWbKvqzjkbGCs0rrgOP71uUAie5mHJdjtSmMINvPM7v6Zn/dGdPzH4MxlULe7H
	 nok2bu8kcAACpgvSKrWY4qL1zRRlnSgE3JX7NSFo8O3BbLN2oj3RPyTry9gj6Umwg
	 Tv08xRv+q5aX/t+QUw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.234]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MyvB8-1w8Kzj3IqA-013l3d; Tue, 18
 Nov 2025 11:20:01 +0100
Message-ID: <ffd107b9-c1f8-4272-9691-6cd59c93beb3@web.de>
Date: Tue, 18 Nov 2025 11:19:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Sahil Chandna <chandna.sahil@gmail.com>, linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>
References: <ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com>
Subject: Re: [PATCH 1/3] mm/pagewalk: use min() macro instead of manual
 ternary
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FXj95D8QL5IdHSTO/NuOfkGMUkBvYZPvDrh2yJQXCD7cy17eQ11
 tZ9n73VpxiuLxtPa7rcjhhfyd6etbs8y6YNzgZt7SC/Rl2KtefDu4hMrAhtqowwoZvtNVPE
 VlJFmy1TWSXSMOrFA0LveUNcIKL/8SYflBrAnZ3g+8/jOQ37yUGM9hMXsnVK3miBwTpxYIb
 RWrPivsnZFvdFOHUnrsQQ==
UI-OutboundReport: notjunk:1;M01:P0:BezlHKIkhw0=;PBEW75GLeABuIdn9TpkTUv3FdfC
 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
 GS2lBDT+TlW3js3fzzdW20lZPZ3Y2q4bSoTGob
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B26CA140004
X-Stat-Signature: k7i5pc46azcxcji9aq8ab15qcj34zho9
X-HE-Tag: 1763461232-32911
X-HE-Meta: U2FsdGVkX1+txPMY+6eNwITCS69NRfEvpC3ZIk3gdP1UEC25mhMrtsneaF5FZnuXnX1TRvZTgujI5xOl5BRniHkVgAJv4jJsAiIpfXlg6gwDhXbpGaoOe5sFKMuAl/Prlkh54VaWZMOa1ZCAwOttShKd0XsISBVmRGvbVrs5+a4TS5mS4QYl57vP/WtKcr0OXVP7Rur90JFzcicWinTQTH+HA3U6G63Ej606Fjv4HkA5P12CkiEFaE4EqtU7m44fYViCeW4C6pN2axYsivJ0UueuiapQKp7ngWv+sdR0e1ImvXi1NZY43EDNj9X9rQBR+rOgYZFeWSnVxewF3/aqRe+4f6UjlwfweQS2QDDpSIPwr39tqG0cKQQG3w/OzLWulexP3LBSiM9+hf9Atdb2NdcQoFwWLqGvjDaK+SoQDsCKkemtfIxTSJKDAjn9kmvAU/WRoYfc53oboNGkmTcptavSpTzVlmKiR+1c9A853QybxVp/6wPe8hFguijL3wGOC+KJfkhm/df/qu2bh4OR4XRwwgIJm5T8OSYDe3ey3bpHu9rSZd6HMMGKfp4IR1qA69ivNCl74L7sHiGo8BrC5gb3qqlzaQ4gpln2dwVe8bYiSSgupmImep8ttxO5TUgD92clYcolhKk9BCRkTyALRTPcT+nOcvI5q4PB+462Y7N5do2sRxlieb7LCFP6h2zpS9yFmDNI/7ccmEQdzS8rYaza3zAKruoQSDJtyUBqFC2961Gi6odxvELg/TusmO+lRyvQnD8m32WShuTPaJq2NHqDBqxokXUEZm0FCUZM0d5QpuV65y8doVMfKu46w6JaA+rbX0wWf1NvQ51RHMBfYlKBiqFM2V84wut3r3hYDS302F2tpeMP6DyN3GWV+98dEqqklwHg3AEGrXmuSwpWxRCarYvyv5TsWYabMh5xcmNAg2hL4fz3TT7UTWyriIh/8bpN2Kj/kCgVgW4iAi2
 BZ7Ttrml
 mBSe3a2XtH4B7jwbDjqawf+X+1l0lsc0Bv11mitBK1y+aERFbxd2urTpkvIvSmNK8cfZMe7SN+WOlxCS3LIv8td/vr4mX3Att1l101LDd2Nc2LpUMCov+KQQn7d2MR9RkZTAlhBiCqWy714q7CnuRmV9G0PqoniYLA7Sou6565tAP25H9shSDCMEMVYt6qoUn6dFxWAPWeu2CyKAX7dDzbqS9MGUKW2zWmLjGjvi7mU2vBK/4w9r9b3Dice9y5D/QBxDPWuL+/5mmlwLkgXeFVfRJv73dRwOg7ZIxvKgmxFU2jtECzJ7i162drMTIvDHrk2eyhd85q82pIjBDcCUCBo/oi7aNeK3wjRsRTEotEFPmSVSKYL28LNTdlNkFak2g9FXugE/PTZCHzKdy54qkmVs1lTSaJ1IiQly52HaeeAst2GQp9SWPzQqJJeifH+/Cf6LnrLrCDEiwg9Vt7NHqGyp/dsAKLmSQXt0G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  mm: pagewalk: use min() macro instead of manual ternary expression

How do you think about to avoid the repetition of a patch subject
in the change description?


=E2=80=A6
> This was flagged by Coccinelle
> (misc/minmax.cocci) as an opportunity to use min().

Would an other word wrapping be a bit nicer?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.18-rc6#n658

Regards,
Markus

