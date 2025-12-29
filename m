Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6296BE8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 07:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA24C6B0089; Mon, 29 Dec 2025 02:48:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C692B6B008A; Mon, 29 Dec 2025 02:48:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95D86B008C; Mon, 29 Dec 2025 02:48:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A9BB76B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 02:48:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E150140C14
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:48:54 +0000 (UTC)
X-FDA: 84271732188.05.C1C5635
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 513C918000B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:48:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SA9vSxTu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766994532; a=rsa-sha256;
	cv=none;
	b=kEBJhyBi+eXOUbKX2futQie89a7z0uWmUFmNkeoJpmt8gmXzs16fSb7I2CCmfM4r1a5ro9
	GoV3F4szp714jxjcQRf98lcHpB6ntGBI6+vYhuC18QvVDBM8F1VxVxSXrmVaUYtym5jRzJ
	spHp7QPYp7ek3jP0AautAjnxVUeIuxw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SA9vSxTu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766994532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1R/ahL6rq4+3c38JNqI4dZ67fdzAfwCNTqIsx/+srY=;
	b=y4RKJUaLPVwJRJPhS3zy0vmsdmXYRefUHZP1j8HMwevPszAFo/E3Z7zkL48dQkxxTeIYPD
	FxyPCMqSCucDdI/L4jgqfYNMSv5fOiBijAKXOE5nhsSu8DZDrGF3DMck+XUNZ7vUFHiMCH
	/RBCtvVDWyEh76TiYm4fzNPhe/U7FXo=
Message-ID: <1264fd2b-e9bd-4a3b-86ad-eb919941f0a4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766994530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v1R/ahL6rq4+3c38JNqI4dZ67fdzAfwCNTqIsx/+srY=;
	b=SA9vSxTuD15GpKVc0SGajXBGdyPHOJccBB1B9R0ae6mEHD/IGMctJlYs2L7oHmIN2wryoN
	CELOsJJglhfZzoPhKFCEdl9cQfqll8AjpCzXy3ZnTsHCYTaefqmTAvOY7S6a+lusPV/kFO
	v+7XqFUuuIYvjyytWCNUxzsHpkTS/cI=
Date: Mon, 29 Dec 2025 15:48:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 513C918000B
X-Rspamd-Server: rspam03
X-Stat-Signature: 7c1pobecopfkn1cuwbciqbfbfp91151g
X-Rspam-User: 
X-HE-Tag: 1766994532-182338
X-HE-Meta: U2FsdGVkX1/pqUK73Jp1x1qgzN6nWsB7Q1//zS0jN0b3mlrY2pkTQYuwf8tZCUCP7rabz4GymCAuyeVOhZLJJAMQVToqmM99Z2oIKLDz17BKI8A9UiypGv3AWa6N9LBZvvMNWN9IsZ7LEta5T6H83eZrmJY11SUJIWIS2fK9JJDSfKnBENGu24Lj8EhG6lFhHcW2XO4Fa+iEoHVKtBndLozJWZcnUnQIzzk7HTTgQ5w4LE01p5zfl7r67dC462nfMevHu4UddA1BaKITtZfVug9whZ/fwScFgJX+4sV1Av2uz4/HYZKtdTKjAItHwIZv5pKuGJE1evDzdPOqDVkTRqj/PuCD73PdnR2hr6gcD6k8XCMM0ua39tEuPN3dEI29g2aRH7woTgqQ42M5LBWJwHz9Jj0tKZTL8geeA8MbitkjEOFbqZ9iYk9wGKb9JJPsjE6Gylgt+ATtN2W0k09djvWF9VRhxkXaC4Db2ylBLVcvCxwRJ9SOg1eqVJMOp9hgbT+fdeTmZhX3r0VW4OZDpZoe550wxJZhLGDJl+WXoOSIvh8ikS0SoxnUygflp0XVXiZeAP6l5Gn76W/LBXiJ1X6I4af2q4aRVSfREZLP54Nqfj1+MfvUGxtCqjJ0JrZ7gw1TpIVw6MQ1F3QiJYdDmHpSwR7s4qt2vijbgmz8ARwWOGtpKMatfmZ4iTiML/sXoFAzIUI7kDs/O9ZaDB5J9bWEpWMnNUUvHYBLmuCqWL8uPG0U98cYjUgGv9xUpVyPAt30jELg0Ktv6fVQn6VdjpsRchV82v0+juGux0uJ1T5Rw90cycgnq3Uil5GEbS+sc4OZm/qXSGBKBYKDlbd3eDhgZWnxVNiChaTLWDU9e4h996gF75HF3nnFGfLKQa7SObbZCyeV970w2Fa0B5vmGdt8OxKTNTLDRPHMN/T20gpmkfwxaizk12qqp0iK1U7zF4nV0MdY9FZHNTRMXuz
 jvQ6h+eh
 qwAwvaR8NL9ozDIZQejr9b1BKobXWpiubBQfwX29keDnq1BgHOCDHC68PggbNL9zmSk+rxcR0rAwS0d4mftsU00ijMWShxwcmE/LlNBXnSD/qxYhd38ugzuRdxPVDO2j0ElSIkuxRDR68/5PDP0IRSscArvYoPk1xTTcUZg4A6csNc3wY1V7JIdBCXvzRge9gUC3tSv6Q2fjInlfJiZgArftRdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/24/25 7:20 AM, Shakeel Butt wrote:
> On Tue, Dec 23, 2025 at 08:04:50PM +0000, Yosry Ahmed wrote:
> [...]
>>
>> I think there might be a problem with non-hierarchical stats on cgroup
>> v1, I brought it up previously [*]. I am not sure if this was addressed
>> but I couldn't immediately find anything.
> 
> Sigh, the curse of memcg-v1. Let's see what we can do to not break v1.

The memcg-v1 was originally planned to be removed, could we skip
supporting v1?

> 



