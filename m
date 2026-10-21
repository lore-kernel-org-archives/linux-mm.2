Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EA1606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 07:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC23C6B065A; Wed, 21 Oct 2026 03:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73F86B065C; Wed, 21 Oct 2026 03:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9895E6B065D; Wed, 21 Oct 2026 03:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7024C6B065A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:53:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9C981A048B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:53:41 +0000 (UTC)
X-FDA: 85345869042.18.2CA39FE
Received: from smtp153-165.sina.com.cn (smtp153-165.sina.com.cn [61.135.153.165])
	by imf23.hostedemail.com (Postfix) with ESMTP id D1C40140005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:53:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=aV8uqU9K;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf23.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792569220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhy0oyRetX168I3CYw/iHInrZZxLMV6KJR6cfcucIJA=;
	b=a4YrCKV9r/GZPbefnaMSdLqpooPKZi/43fx3V4FgsLdUFFpTg9LDksvZWfMHlfd4pnHL3G
	kvIojFEHfWHhTX7XF8burTOvR9mD3fC2iHBpnVVfcfFRCPVB4vYzZvXCZFYyKJ2g+/789I
	slY+CemYPBZ2Os/qnDYk5G7ecbm8heg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=aV8uqU9K;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf23.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792569220;
	b=TKYqVfWptwxIqJhFaDdagKk9S9UITUKHyLi88MtbFW770QQEj6S7W6axg0L6X57CKwAnUL
	jmLcYlsgNWUeIWjfQN1k0twfkQpN8HHmQ7ob4GtOvQsu1Nu6mRuu5qfBDIH0kgWT17BGwJ
	dr1pjEIV/BM6Z77ZJcb5Nbx/g1nlCqs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792569218;
	bh=bhy0oyRetX168I3CYw/iHInrZZxLMV6KJR6cfcucIJA=;
	h=From:Subject:Date:Message-ID;
	b=aV8uqU9Ko0owg2WYvOD+Myng8ppxQGjd6SQrAE6PxAQHJ1ysStyFJgOnqWNB5i26H
	 UqhmpSChGujNbw02V/3TmZR88vJUrDcAQZuiE3hajbbneS503/1fD1gTOwn645ejA3
	 bYt1rP2LOoJGdPYtymqQQ9ncXu2ZKcP2CvhBjCIQ=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.254.3.56])
	by sina.com (10.54.253.32) with ESMTP
	id 6AD86F7A00002678; Wed, 21 Oct 2026 15:53:33 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 5760734456874
X-SMAIL-UIID: A986B4A8D67249C0A2750D2D5F8A8120-20261021-155333-1
From: Hillf Danton <hdanton@sina.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Date: Wed, 21 Oct 2026 15:53:21 +0800
Message-ID: <20261021075322.923-1-hdanton@sina.com>
In-Reply-To: <athFf0kXopUKh2-V@google.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D1C40140005
X-Stat-Signature: cuf9sh13u44k76qkjre7w35nzypp65yp
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792569217-818324
X-HE-Meta: U2FsdGVkX1+9QxdUYiLtXY14U7PLi52jH49FeA2wcOa7YNZhD9Y9/knQme5RYohxSbdOeThoquqv/HsjcF531+3srcH/KBEM1i5X5OuEec2S/eAo0WNQxvmy8BeezxJcWIfmurEIbvCvBbK9prA0iuGtOe4aqoN/9TCQZnhpzybSNSvckr0GKQBaLkbdSNzsGyNc6D30J/FTVVdf5r4OqHi1eXEAJk5jmlyDVKKyMgbopiJf5/46kHQHzuT/YsfeDDjdP+/o8hNA76glrbvDQasN/PwbPmg2LI73VsLAMA+f+6r1SHksle7HmZHuJm1VrDTPKBJJG+izFXGk9n/eLVedML2zwiAozE6OJTUeQ3dXpdHnbCfbPxtNhWs1YXUOUFkgAWeTCoxanPbQ835ufrkimhf0AgH5nCjoYwZHYGteneSF9lqzZCXWE5g+YwBLGIgBGVxwh1mADGTGKdLGfK/nPkeJBe4LMKM46eJ+parOX+QFGSSeXcW+vM+K1GcPS3TTsAEiUqC4cmq3xK1SchtbJQ40qlA11PDPDaEbD//dSlrPQBtBy38ZV3yQYrPhoGiuRpUtg8Akkz3oO+EuA7BUQPaKUhRgM9frR9h8jp+BFwq/IYwCZvyEm8n9+QzQS66KrohqUdYAkZ0r4pXdygzn7Qy4UC1Gr1Xene1MB6xqnL0hEgzvF8mmqWhR5zVcQHVChGcdRlw0BgaxRNCHqhq2asgKSW8sjUXqTr5ObnAnYzezrXYs/pZl3GQS+TH5oNI/ZYkD43FvcJT5HcwwgNh9dZ5+pexq3Hzs3l9QUak1tb+qXV3XfGINgcUM6uTS3+18jHj8FTRIyYewUN9lJ4AVAXwPOPcU2O57rpOpb+Z3LqH6dqTX1WQ/I4UkDdpuLO7HYTGYslzeABMCeYp+RqWFuvbTLLuWG42IDW2ZhtcDaeVWiGfhcE8BW6Gc2kfCpJBKBp6XZixm3VHqpUG
 XEy/Ide+
 qS262PWU+qxZdTIct0cabKrsdWIpN1o2UO+cmpwe/37LjzLQU/NVESzc/MK4xK3kIfmnrZAp/Nwq7aYSHaMICx9zsJPOB03CH9mtElTXjeYZVBhHcWFToNWGI8m75sp2UFDyjyJS28k6pbQ2RZ9kpk50aDZvp3a/5Bm8wcjVpXJ023X5fYflezT7NIdsZMGIz5gwVAqtxGYrGJiM9ZNA8qrdbHazbWaBh/wKiqxKT4Dkve5bFQBV0zd5CLc3ZrpoAgFP/Hd70s1QchQYrlh1mfeHgcT8BbZLzLC+VNH0ry4qXTl7mgOK8ytEfLsiB+TstxrxkOnod9XFVzAVFgOEPkN97zIPRid9nL5zj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 13:56:17 +0900 Sergey Senozhatsky wrote:
>On (26/10/21 12:23), Hillf Danton wrote:
>> On Wed, 21 Oct 2026 11:42:19 +0900 Sergey Senozhatsky wrote:
>> > Split struct zcomp_strm into separate compression (Write zcomp_cstrm)
>> > and decompression (Read zcomp_dstrm) streams, and split zcomp_ops
>> > context creation/destruction into create_cctx/destroy_cctx and
>> > optional create_dctx/destroy_dctx callbacks.
>> > 
>> > This decouples Read (decompression) and Write (compression) paths so
>> > they no longer contend on the same per-CPU stream mutex (Writer vs
>> > Reader priority inversion).  Currently, a (low priority) Writer that
>> > holds the stream mutex can be preempted by a (higher priority) Reader
>> > on the same CPU, which then blocks on that mutex until the Writer gets
>> > to run again and releases it, which can take a long time when there
>> > are other runnable tasks on that CPU.
>> >
>> Given lock like mutex, priority inversion happens from Monday to Friday,
>> but I wonder if you are inventing some wheels in 2026 if proxy excution
>> works for you.
>
> Reader-Writer split is a foundation for further improvements (like
> singleton recompression stream and so on).
>
But that split is not needed at all if PE works, yes?

