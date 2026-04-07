Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269AAFB519E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 07:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128A76B0088; Tue,  7 Apr 2026 03:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA1D6B0089; Tue,  7 Apr 2026 03:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31996B008A; Tue,  7 Apr 2026 03:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE7C36B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:08:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81DE1C24AB
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:08:13 +0000 (UTC)
X-FDA: 84630880866.21.6EA9EBE
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf30.hostedemail.com (Postfix) with ESMTP id A06418000A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:08:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Q+MM8lHS;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775545691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HY/zlCuL7i3/pdix1lf310z8fi6VjoWifT+fq5jE3pI=;
	b=8m+qXiXiKAg1PxSvB5b7AImHLH8hIgusxMfZvPtOhtpy2jb9hOVKpUfbfHoHKZ6oQOJ26t
	CdBRTme2ZkDfOKQfZfiJQ7TwZHqwSW+XbA3Btvp3s93V2baovD29BfZu9GbT/K2kd0N50a
	ZwGRjabCiSqK+0+TcDBmuadUvmIVlEY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Q+MM8lHS;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775545691; a=rsa-sha256;
	cv=none;
	b=Hq0H2H6hEmf+TCZMhuEI/cbGX/7HJqhpIPpfPosyetAmxztfTqO44igu0vAmKnj3J/cmFm
	MIb88bZfkKiO9iDfW03dd1Ae5OJbSOdZudP+EsYeim4AX+U2GqKF33p0HfhAzpiHCs2otq
	Rz/3zZEZCHcFt5auCMcPT3YK0Ggxe1k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775545686; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HY/zlCuL7i3/pdix1lf310z8fi6VjoWifT+fq5jE3pI=;
	b=Q+MM8lHS9yTByObrC+7/Bmbgz3l7GqqKAWXtLQQ7kB/Wa7ukc2RPPVQXg/UyytOOB70O7T7RPmToO1u7+enYP42i8OAbC9uNWMVhX6XyyZYtWr7yr4lNN/MLVr6bo/jl45eOoOSlgvo8oGDX1gMII0Zt8iTL4xtntw9YgGfyUNM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X0axiWU_1775545684;
Received: from 30.74.144.138(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0axiWU_1775545684 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 15:08:05 +0800
Message-ID: <d125dc23-6c9c-44e1-b570-3cedc4f035d0@linux.alibaba.com>
Date: Tue, 7 Apr 2026 15:08:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: don't set large-order range for internal
 anonymous shmem mapping
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org,
 ziy@nvidia.com, david@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cd5c563db32507c9c090a0ae8287e1851cb0a5d3.1775541661.git.baolin.wang@linux.alibaba.com>
 <20260407064903.69017-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260407064903.69017-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: he8rdnno71yike7w4gjmcoekfcb9n8ab
X-Rspamd-Queue-Id: A06418000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775545689-79316
X-HE-Meta: U2FsdGVkX1/fjDWFbVp35pD4E3+9SwmPZ/1U/KShAVufw41pUu4Mmakys6hI1DMdEjPRaCXPQ41eWx1DmsEy7hVvPe/m7Qi2IXHufE61mcWA81tolL+c5EH8NRzxqmvlJtAxiRTaUQcjMCZDikKumB6mJEkc1AhNe3gbMltPpS9erovvB3hu21btCHVr05Weu/QWq6Zhix1cqh5crMzaJBgjpkw25SifUuuVpJm0WvMgXRkFEk3Sqi1Cl98hRkgfUdrL3KzyZI5p1vtxUuGBrP4o+EdOab07MN6BVpKffnaGwluSrQ3LjrczSy3PVq2dnSe1iksC7it/2ekC9aIdy3bUxF3Wf033MY+bEtaZeLxZyYTucB7CJUYY1019eBwtZFdLo8Ck4CMQtgvPZ40k9EjEt40+GUAcOydzyxSZDY8eT6lSThOCUvuP6p3jMx3C17F02lxU2ek8bbuJ4d6uNeX8MZQhWKOAiXSLM5kwyQQbq+W+lKn5cd+hzg6Rx6BMN6aEFpwh75s1gcuZIPraAPiuAk0qXtB9839vsLgMFsLPtb0X0/Qe3ivUotu7IL3zOssZ39+Ek17O/9HsLKMb+wk0bKBoaKwyCOtbAHtC43PUTGuqkza8wXTxNRGHX2Amq0ZC6YbmVVzKC5J25s3qaItiRyTMMcjIPS6UKR7uRMbtDcOTaKH6y9zlkslocJuCXPozqYg6kYqUNRYuWNCwvqLEVFjlM9gIqOV1AdPEmRCvg/fxor+wbygL07eblwWU9iC5UOj3/FTjjW0au/tnieJQWItkJTvxQP2GQG7QyKe7U4go2yDGZdEVx52Lug4L/s6+1X/gDtY+YeBtt8oZiKBemrhn97V5YQ/KgHtLdzUnS+N4HqEuEt8h2yDR6fyaO0NGIF9fFdX3+p++qfhJazsGQIIjuFYO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/7/26 2:49 PM, Lance Yang wrote:
> 
> On Tue, Apr 07, 2026 at 02:07:27PM +0800, Baolin Wang wrote:
>> Anonymous shmem large order allocations are dynamically controlled via the
>> global THP sysfs knob (/sys/kernel/mm/transparent_hugepage/shmem_enabled)
>> and the per-size mTHP knobs (/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled).
>>
>> Therefore, anonymous shmem uses shmem_allowable_huge_orders() to check
>> which large orders are allowed, rather than relying on mapping_max_folio_order().
>> Moreover, mapping_max_folio_order() is intended to control large order
>> allocations only for tmpfs mounts. Clarify this by not setting a large-order
>> range for internal anonymous shmem mappings, to avoid confusion, as discussed
>> in the previous thread[1].
>>
>> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> mm/shmem.c | 13 +++++++++++--
>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 4ecefe02881d..a60fe067969c 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -3088,8 +3088,17 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>> 	if (sbinfo->noswap)
>> 		mapping_set_unevictable(inode->i_mapping);
>>
>> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
>> -	if (sbinfo->huge)
>> +	/*
>> +	 * Only set the large order range for tmpfs mounts. The large order
>> +	 * selection for the internal anonymous shmem mount is configured
>> +	 * dynamically via the 'shmem_enabled' interfaces, so there is no
>> +	 * need to set a large order range for the internal anonymous shmem
>> +	 * mapping.
>> +	 *
>> +	 * Note: Don't consider 'deny' for emergencies and 'force' for
>> +	 * testing.
>> +	 */
>> +	if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))
> 
> FWIW, SB_KERNMOUNT is broader than "internal anonymous shmem" and covers
> all shm_mnt users too.
> 
> So maybe "internal shmem mount" would be a better description of what
> this code is actually checking.

Right, good point. Will fix. Thanks.

