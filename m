Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC90EE0AEC
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC866B008A; Sat,  7 Feb 2026 17:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A3B6B0092; Sat,  7 Feb 2026 17:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C320A6B0093; Sat,  7 Feb 2026 17:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFFA66B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:08:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45B2F16042F
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:08:14 +0000 (UTC)
X-FDA: 84419049708.04.4D3A688
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 66AE1100008
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:08:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dZqduA64;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770502092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZ72lTGJy8plPIgt58KFdjEDPgYKok9oKnsbW9UXE+w=;
	b=er4P3xNL0ughm3lQeXv3juHgaSANpZp6WfFLpGDbYnd7Flda7gWxW4Qivu1E8MMd9H3/eQ
	0/zCFNE5SC4GReKcUBATM0OCvIBH0FV3gIz5M5MyHgRsoEqJmP7HXqOzMAwixTxeNF77fC
	Uf4VEanxRd1vX8ztTp7vQYWdInoggKY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dZqduA64;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770502092; a=rsa-sha256;
	cv=none;
	b=vCsBzoZ5vSbV7Z4w4HXaSRqjCDA2/ZZL/ps82itE6adcFURCQNn/AzNxwWPdqFTU1+fbEv
	iFAJHduAolcyx8pIu23s2ZUkbdn27vKN5Ij/H1OhJPu62elfRWl4EAPS8823O/IEnZnJKJ
	T7NB+//efKXiXHzfhyiZdakZ9uJYmfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76C9742A6D;
	Sat,  7 Feb 2026 22:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE79AC116D0;
	Sat,  7 Feb 2026 22:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770502091;
	bh=9IGgdZ3kY5iF+ftK2skFddHwkTgkMi6/QPrnTtu/PUY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=dZqduA64+4APuYSKcyM4Q6f15K8xx2OrHRQrnc3prPGwKo/QKZ2ofY1bleRUurssr
	 UYWIaQmvf6YIkG8pXCALoxNg7xRBsn+Vrdnv341prK8bpJHr89hIX4IpXjNn0ixBAJ
	 aeyiPqVDkhl+sapMmXiNxFv+ETfUFpSair5o5e2lHSBLaMAGNRey0lR6GofQBo8ogs
	 O7yqD7UTMqgJDi0QHfvMDWDK216oTTwnZy7A+aNcy9Ys+UwBbJEhVc2c+I9MiNzwgr
	 KtMFXrm1fcJ7Gs1sXiSVc/vMEOIrxDOQHrSScnTaBuikIZz+oegiTJBJuhB2exQsMI
	 ayPe6H96YTFcA==
Message-ID: <51f96b31-fb59-4cda-9d33-e3cebc45686b@kernel.org>
Date: Sat, 7 Feb 2026 23:08:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 npiggin@gmail.com, linux-kernel@vger.kernel.org, kasong@tencent.com,
 hughd@google.com, chrisl@kernel.org, ryncsn@gmail.com,
 stable@vger.kernel.org, willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h8z65xinphpyhknuwymzi7ukwogiq3sf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 66AE1100008
X-HE-Tag: 1770502092-147418
X-HE-Meta: U2FsdGVkX1+uF4g2BxCaAIcrNkBltSexJidDdUFdDR2AliTXTyTiWX2ahq7NVLQYntNQK4sqLPmntYOUMI0Td22JFaKYGm6O8ziSXOXBieZCcTjM22WWRoOfZ7Oj7L1PSc9qwOs5OujgvtzjnblzvCe+AzvxKFPRj5Bg4ou0znkXrMzn7WycCYQF08AEmAPfRj4VZFYJpr5oPUnuC+RPX78XipPtx3gOGd+74BmlMWuJEykbrSI2FUZHWn+AxDTsytHJWYsTPGwh6++clpuG2D6gYwt83jbd0Ds0yR8tehnV+4i/VDGpsQms6O9b4M7WLw2/gLZ/HTvLUgTt96qAGH1E73fRN6HtkewBhTRHwaUqRzKsKdVv6BGZ59v7pwnSRHVJK5TPQjyY37TUgmyDc92B3cJd4VKeJrTZTYWXNgIQsws+uiGxEQhkzr/3D2Zfxu3tZCG1++Iq2mDLylcJgSU6LW6g6oZTFPbK5H7OSOo5Uprbg49tEIfKceHYPh5Mj2Dp1i1/s1U3oT8RY3LzaBd8xm5H1Rilp1fbSAFsrUkUEFktffUS8KWzI9f1bbHlXpR9NPXukk/sjj8/wJkG13Tu9Urf+FKY1gqW0ZDW567KwmTqXggv6dK//PmaZ38RfIXoibvTkzcakvj8QJ5kOB27f+RsUnOuospzUye7SSltMwCtMzcO0nnjr9hsebSRSobwXNylyhehQsxkVtnAcj9X7nwjtTVsk99OHr3R7/55q/9JoZq4VRREhm6nH12BnmTb4pxlh3iE6C/9KeyfNNC95U839BagBdNNygfQTPR371i/hYGcNOXps2+8y3qzhV2ra2lncFB20h7lqVqcLIavf+mj6TKjlBy07W1kMnFMIr32gDyofwfPfjwH1xGWdIlC5Uf+J4pg8aVEWLKhaQlvccaU3THCMLHPednBEYFQoMmuY+6VjmS6Wrj0jnoMV5Q2odPZ+xTi+wQAH9P
 1uv7FHhf
 s/oF4UkMwEXUYPLxefmFD+CLTYaOKTmj3SkE9RVBXF87zRGTDtqQzb5XJYJ2VxucglgmpOtcQh5/S/ppk5FdG33Ra8Wi6S/HNeiAvnM3sRMBcd14bSkuovGkad9YMQdHqafjxFunHuZen7Fr3RS72stx0UcNRNDOoGH0vWqKbl28AaFhTJoQR3SBCMoboKdhy5dnKbTdaWx8pHQhlJMjVw8VQHSu4KWOI5baEfQ7Nh5k05rAfq88u6ExH2PmK60PM6BsYvD5/RRpDVkdt1n2PSU/RYXO8+K/Yv52o3hmZhrZPhi9Iqo8V1iPeb+U8SH2Q3f53is6FTCf+p7qRNF4F/dFGAP8Kduem4XNnLBuIn3tvt9JXtHvdNaTghYk4RQSKq+tu3bPcXPyiX7XWTZ4Hx0TYAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> -               /*
> -                * page->private should not be set in tail pages. Fix up 
> and warn once
> -                * if private is unexpectedly set.
> -                */
> -               if (unlikely(new_folio->private)) {
> -                       VM_WARN_ON_ONCE_PAGE(true, new_head);
> -                       new_folio->private = NULL;
> -               }

BTW, I wonder whether we should bring that check back for non-device folios.

-- 
Cheers,

David

