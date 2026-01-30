Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69DF8E6BF30
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 18:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2946B0088; Fri, 30 Jan 2026 13:56:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450E16B0089; Fri, 30 Jan 2026 13:56:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C6B6B008A; Fri, 30 Jan 2026 13:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 250886B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:56:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4EFC05A782
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:56:33 +0000 (UTC)
X-FDA: 84389536266.20.FB1AE8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DEA3B10000A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:56:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bIYUD9PM;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769799391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NyCo2BdFVMgaHS8snZiWppvLP+eBN5Pp1SkAwJTe0U=;
	b=dNrJIUwp6QXcpqBPxiLRsLjEbK0ldGbh0GrhaKkp3jQAMpgX8SSiddOj1ZfvCJMYPOJ8B9
	UKqoWHjJKEA3vIIA1kq3UyMBfVLI16jCJKYTG3LvOrk3Q2lU3m9bUfKI+iVheZ9TWknK0o
	dr24gKdSpEgzS8rUljnlrQI0P2xEtds=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bIYUD9PM;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769799391; a=rsa-sha256;
	cv=none;
	b=ss4t7bwgzSqU1p9/8I0Y5iVkl3RuPLf8XkGTQvxI747ScoMPWGkvf7n3mQdOrdghimpUX+
	PlJ9dIlgliodjN/NiyeIpNa9MzO5JNKSApqzMBIXfGpviT0J1//KU1JTrQQGmnOBLL00jA
	viy7NMK/n67EfweEAy2q+rGJMLtYRY4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3154360008;
	Fri, 30 Jan 2026 18:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A9BC4CEF7;
	Fri, 30 Jan 2026 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769799390;
	bh=sHgckGubDtoCbqMzmS2cfNdgZ8H+jjry4xZuPT2UdrM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bIYUD9PM2teLHx4VLL3zKEsY+b1LPIBR+NNf3PfkybehvNHziBZHHF9gTBavsWA//
	 SyxQwV+zcbb2iclPptFffFB3ztXJSO1xS+RCu4n3Xl+gpucPxKH4jpx5em3pXK6ZV8
	 7fZO9CTWGvmdBTyJu/hlyQcHNmfKcX5DHu5RffyDQ2VGdh/JSpevrBAPTuaLG3xAHm
	 Z9XRFgIg+5XurL+9N8XY4YbVtx3Tl4Q/jPWrFNXF1bd2O+CrcNBzJc25FkkoSX50OB
	 ORJz8nobqZFbnZJvETxXU2FnuKJOZbivb7xm0tdXN/T6mc226mKrjc1WnbThfwiIt9
	 g/5kwIjyvLuyw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 1/2] liveupdate: luo_file: do not clear serialized_data
 on unfreeze
In-Reply-To: <aXnwvkuTBL1NLt7f@kernel.org> (Mike Rapoport's message of "Wed,
	28 Jan 2026 13:19:26 +0200")
References: <20260126230302.2936817-1-pratyush@kernel.org>
	<20260126230302.2936817-2-pratyush@kernel.org>
	<aXnwvkuTBL1NLt7f@kernel.org>
Date: Fri, 30 Jan 2026 19:56:28 +0100
Message-ID: <2vxzv7gj7wv7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DEA3B10000A
X-Stat-Signature: 9d11owh47and5k6zg865h6sb6h4tg4rx
X-Rspam-User: 
X-HE-Tag: 1769799391-313596
X-HE-Meta: U2FsdGVkX1/B5H0MSqpeBUVYP9I+z0r11wvxsP5howSh8TQ+Yiihl0k8Zboxb3StBcQrD00MYLnsu4w87W4Rzp3rS180dVBiahf51twr61W9L6k0VY5q01o5rSKMMcxIT/5kxk0mH58FTBuKh1Bow2+/0FFE7LiRDMy9OMmNUk+VhC84C3hJjt/R7GzaLcyErHMyvufvOyLZmAcxpRDEElpjoRfY28NQM9O6UBdrfgkTMYFjtz1YeLKIOgsYnp0ZQJVNo+qiTJ0pn/p0/fIT12rFhuHT/6VI9WU4PEdl6KY70Zoy9pbpVHq3IK4JzdcB4KQUH2JNp9owPxVK2BO1BAPlpsUq5JKGnjbbdc//3KKjMvi7XKdraxf5eMtQV/X41Fq6iuenO8RyHK901KFzjUUskiZCVALMF6LIJHouhg6q3/YOgO+jpdsYKK9M2GUnuOikUCODqovFPzHMgcpF07QyO3RCA9dO8YDkbWukmCQLVzbGGyuFSKAQLbT1MQ2oRwiCNJifgw4K1wMCdxSPyu3a+qclVMpEx5i6figLvUYEnvsz+SZIa+utMkhYTg2A17GYyf1mMIyehTDg92UwQxuLPmSVKFCgn/jSqIV1gR2VwrJgUSFzA6XyXyFoNdSIl54mWhp+kZXOIlNzhTc5jFFoEA9OIJk06OFjiI+7HnHXc5NSX8/vhfrSo6zDkNLTQiGDaQTVL+P7ptm6uIwJOrgdcj++IfYI/qTgS9Dcnj4JUMQDUnvcRPrjUaAIGMfjgQaYiJlKo84DBipv7yLJvuYpCU/JJX7oWZMdCQHt39paEIYAnUP0im+fEV3pPRrl20VR04Nwr/cZdq57vaxu67P0u95cSesZKgM/pcQQNOYxLNfAiHaHkOGAQcAxHUSI02wLN4YWLTlV86HcgCyEe8xYr85WzYA5V9gxwqZmXuguO1BZifFUgxwccNlJx7Q3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28 2026, Mike Rapoport wrote:

> On Tue, Jan 27, 2026 at 12:02:52AM +0100, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> The unfreeze operation is supposed to undo the effects of the freeze
>> operation. serialized_data is not set by freeze, but by preserve.
>> Consequently, the unpreserve operation needs to access serialized_data
>> to undo the effects of the preserve operation. This includes freeing
>> the serialized data structures for example.
>> 
>> If a freeze callback fails, unfreeze is called for all frozen files.
>> This would clear serialized_data for them. Since live update has failed,
>> it can be expected that userspace aborts, releasing all sessions. When
>> the sessions are released, unpreserve will be called for all files. The
>> unfrozen files will see 0 in their serialized_data. This is not expected
>> by file handlers, and they might either fail, leaking data and state, or
>> might even crash or cause invalid memory access.
>> 
>> Do not clear serialized_data on unfreeze so it gets passed on to
>> unpreserve. There is no need to clear it on unpreserve since luo_file
>> will be freed immediately after.
>> 
>> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

Andrew, do you mind taking this patch in v6.19-rc8/v6.19 hotfixes? The
second patch needs a re-roll and I don't think I would be able to do it
this week.

This is an independent fix and I see no reason to block this waiting for
the other one.

[...]

-- 
Regards,
Pratyush Yadav

