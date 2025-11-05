Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29883CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 06:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43CF78E000A; Wed,  5 Nov 2025 01:23:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED208E0002; Wed,  5 Nov 2025 01:23:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5098E000A; Wed,  5 Nov 2025 01:23:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15E128E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:23:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF9381A0124
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:23:16 +0000 (UTC)
X-FDA: 84075561192.16.CA45167
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5772680004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:23:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762323793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J/vV2MKf3JEy0RYzE026Ug26bPPEjVBw8iMSZTRpNi0=;
	b=WLO//Crz4Usn/KdIuEfvVd09fK5cepdmz9B9VCDUewUcrMCFS1ZL4yDmZvkcvnE/tnGUIt
	whb770CVPZrhamomvSAEkUkpKAfWzfJhmdlcPqTRpu5kEKHGkIfl2AMetyO07RM/Sq2IIL
	BPiFWmX/sEMfyVmahlTs/FojmCwtypE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762323793; a=rsa-sha256;
	cv=none;
	b=ZU6xe0Ivytcrf1XpGQvABhvfJ1wcDz49dtZ2wigsZ5n54U9G3ivatY9U3H1qN5r9WmtlrH
	GQUNbc+bB6sisIOMADLXU+mcADDAZ3IH1VWWct9oD8rOZ09DbwINIV3yRMDn7VZYOwQ8HO
	uKe+HT2NjwU8A2Of/4ci3BDn6vdOoyo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d1Zxh02nzzYQv8F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:22:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 45B501A1D6A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:23:04 +0800 (CST)
Received: from [10.174.178.254] (unknown [10.174.178.254])
	by APP2 (Coremail) with SMTP id Syh0CgCHK0RG7QppvccOCw--.55319S3;
	Wed, 05 Nov 2025 14:23:04 +0800 (CST)
Message-ID: <a11bcb10-a10e-478e-92b9-1c02528c270e@huaweicloud.com>
Date: Wed, 5 Nov 2025 14:23:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Content-Language: en-GB
To: Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 akpm@linux-foundation.org, surenb@google.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz, yi.zhang@huawei.com,
 yangerkun@huawei.com, libaokun1@huawei.com
References: <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org> <aQhf5LJJMlvT-rrE@tiehlicka>
 <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz> <aQh1EmVd8IPHK0Gh@tiehlicka>
 <aQnV73KorhS0AWH5@tiehlicka> <a0015508-e72b-4b1c-9993-7e66076a0a19@suse.cz>
 <aQn2fIcj9LduzsmI@tiehlicka> <188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz>
 <aQotQBjnDDeL_wHx@tiehlicka>
From: Baokun Li <libaokun@huaweicloud.com>
In-Reply-To: <aQotQBjnDDeL_wHx@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCHK0RG7QppvccOCw--.55319S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw45GFW7Aw4xWF4rWr4Uurg_yoW8Xr1kpF
	WkWas7ta1vyF93JrZ2yw4IvryrXrn3Kay7J34rWryUA3W5Casavry7tFW8AFyq9wsIk3Wq
	qr40qa1rJrnIvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgADBWkJ0jBbNAAAsp
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5772680004
X-Stat-Signature: 7xe7cjy6j6c8gfuwm19if937bfe9kyo4
X-Rspam-User: 
X-HE-Tag: 1762323788-854189
X-HE-Meta: U2FsdGVkX18eqA0v7eOHsE1ammt4F38PKlNclc8UDB6LITf066k/o0tCKV3065pQuX+L71NZJcjDvar1m/8p61ioteEsk8ZN+zh+7lb8LzKZngUvgJYsUv3rvtH3/MhQ+e47m6T/Br/NYJGY5GzfmS1itWYcO/r9IORW+eaB+MIHLC7AJTx6101SVUDI/WQRrBbRlowOd3ojoJiS4bvf/8H4XniHhSTARL+DqbYsvycp54XH6S+r+hIJfiDLxHZRIaFnwkH7sM3bv6V2zs2ks//h4rDtF6RvrZH35k7PYKIUSGdF6pCG661i0JSzWZpy+tkLQ6kFMaATg3zxsaZL1t1YwbkHJ9iNpxJFG6E07aUGhXtzu0g+jaQhcU6e2juUu5nbjvycMdTthY5iOTcOOPDAOB3YVgp1tIB6BpxqzPRBoqYtTtNH3wBJ3TzIJokv/agjsCDcjCLLXJRkqFBGDv6XgQdPvugurXu3duiKQKjjIUzyeKmC0Vodp0J6PGpkljODsL0o/xz8EatQELBVcTtFv5gUDVaz7mFpzgQ3urK1N25tZGbydk9gxvQ5OACC2F/V5bvikE+b99keMwjXuaod9wu4GPUKdmbq/dirUrC3Zya72IZXKMDsDcLbUeWfmBHbcmJzms4StmKJ/G/EDV6OYbAeitolOJyjXXlfDU6YJ/wLRgE4z+nViv/fhGbaPrJbR5W61jOV6P/A6AHABOoW2n9lx8ggMW8utC+TLdSbJWOLLKOBda+yDvaMM0NtNAqiSO4VJMA3mBIOevC4slfUX2YzGoDswmbF3it2O76pXqA9UhOLNFXQ/fAYfnZtzXMZyjEqKSyXPtpqFH6u2EM5VWBesSM5wzbH40Y8uoVE5rrO9vCqz24qt/qJlKqOeAa4hN3EdMrsO8RZFvryeAfMr6kYdeSdQ9jpF6VJXsQGRmjHGEGOHoGZYI1hIyR4PGyhiiuGO6XrB3IgPtd
 pwqkUoFt
 SIB0IU86ytJNn/fVhuR7xogLA+v12p+mHx+qJwYKGbYjGRCGr8wPYnXSzBQO9ExlPEbWI+cdWI+EAnw1mTGjkentpaweunH89ZaO53OcuG8t1YpuwocmVMWwEqgnyTX/o4USdVcASKxoeR5U2xAKzfyXLwEol1TGQSsfbIWLFReTDb1Pm8isC5u2dK8cCpKsVq8L6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-05 00:43, Michal Hocko wrote:
> On Tue 04-11-25 13:57:35, Vlastimil Babka wrote:
>> On 11/4/25 1:50 PM, Michal Hocko wrote:
>>> On Tue 04-11-25 13:32:52, Vlastimil Babka wrote:
>>>> OK, it might not create an order-3 page immediately. But I'd expect it
>>>> allows compaction to make progress thanks to making more free memory
>>>> available? We do retry reclaim/compaction after OOM killing one process,
>>>> and don't just kill until we succeed allocating, right?
>>> Yes we do go through the reclaim/compaction cycle. Do you think this
>>> warning is overzealous? Th idea is that a flood of OOMs could be easier
>> I think it's too odd to warn for a specific order and not that or higher
>> orders. We would risk someone would make the allocation order-4 instead
>> of order-3 just to avoid it.
> higher orders simply avoid OOM killer so it is effectivelly retry loop
> around the allocator. Order-3 is a bit odd and that is what the warning
> is trying to tell. But fair enough let's just drop the existing warning
> and see how it goes.
>
Okay, since most people agree that we should first remove the current
warning and then observe what happens before making further decisions,
I will send a patch that directly deletes the warning.

Afterwards, depending on the situation once the warning is removed,
we can consider adding some special handling in other places if needed.

Thanks to everyone for the discussion and suggestions! 


Cheers,
Baokun


