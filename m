Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E798B606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=L5Sjfmtg
Received: by kanga.kvack.org (Postfix)
	id 0D5B56B019E; Wed, 21 Oct 2026 02:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD696B01F7; Wed, 21 Oct 2026 02:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04CA6B01FA; Wed, 21 Oct 2026 02:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C64D86B019E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:30:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E3031C0C4F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:30:58 +0000 (UTC)
X-FDA: 85345660596.21.3CC4857
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA4B540002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:30:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L5Sjfmtg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792564256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRPKYkaZWE3FxBj2IxPUzKLdAP5rCGDFaBUV6kgkyzE=;
	b=wZ2pxeOcxclarFbo1bYRBOvWiuYabdyeovEER4/3BmPWMAtCHq2O9O2VLKwfKCT6A6agyA
	sIBeOmHAjri92t/JEX9gsGpjgkHauOgz7CMywB1pMTTod4vZxfEi64voqOmikUUsGkkrY5
	1pSaogu4PUNwy/g6OuNecQQVUyJAVpg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L5Sjfmtg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792564256;
	b=JukvLMuAvXEB9yQ98bq8o8lTcmdc1bokCwek8lsBX48BE2l2EhJt0JrEhO6VwPDMqAQMER
	3B8jWTbdhtI157T1RLE5Mir1yDVIrM8amzMxOy3zSiWdpN0rEJGRPs1/8Y2MV/mdCiVeS+
	4nqe4trxI9iwMQyg31dtUi9tv6Pbl28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792564255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tRPKYkaZWE3FxBj2IxPUzKLdAP5rCGDFaBUV6kgkyzE=;
	b=L5Sjfmtgf4e4hDNvE+6p5yJQnBqiwM9GzT6V5fI+tSqjRLt2GYrAQr6vIVmTj9jdJ+KH0O
	Dp3Opg3BzIlJ/8HYE6QaVWDvPuXLZ0tG6uSjSZo0AViDhTSINxiAbpQlWGYv0IE1Ouu89E
	GmWF9bM1CxxNBfyoVt9gYJtWn3LoKvs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-fJaSi8TkN7yhADY-Yg2Olg-1; Wed, 21 Oct 2026 06:30:54 +0000
X-MC-Unique: fJaSi8TkN7yhADY-Yg2Olg-1
X-Mimecast-MFC-AGG-ID: fJaSi8TkN7yhADY-Yg2Olg_1792564253
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48c46582442so176663f8f.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792564253; x=1793169053;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tRPKYkaZWE3FxBj2IxPUzKLdAP5rCGDFaBUV6kgkyzE=;
        b=0hsE6WF7Aa0m9W8/kedsz0Rop4yCj6LeezTvEIZH6ugs6G7/OnPe25e3Ts5BmUBVTT
         +7nTETakEksHqYzG6hILI9HJ/XTJ17LiQX/Bb9Kjr1IejtQxSXQ7BSyZx4DHH7aQPRdR
         K5a7na8sISifq4lGJMtUIrJQLyloTjgRbOVUpJgJJUCFOYqSSZbe8cOMc2ULTFaoyVIt
         GCMKSSpDP5EyRu6OukYrWYkzJLi18wfKIA6Gux+RJSsQ1M66HvNFCFkEJri5th4Pyx1O
         14mh4k89LiMlN1M6OZZil/Q6PV9p1WOmE7CWbRdmozz9cMVzeOKGceTwb91+Azc+cpey
         9vdw==
X-Forwarded-Encrypted: i=1; AKwUvByC+G/g06OA8nRDnrLQM7guhcO4F7LMaLvwWRqaeaj+WxUYJF9cg7n5JmnLyiqRlkBYrmmi8/ksGw==@kvack.org
X-Gm-Message-State: AFq9FYI9l6S7KLDw4wRTV5u0/0yB6IUdGeMiAvHnadCjccNU6Kxn/KE/
	/12KPQkXFsrRbWr1htQnI+qdr/L56nnAKzl1MH63fqscSFt8tBlgn1vfjxN4L5Qb48EYZZxhniZ
	tRNPoceB8bDVpsvZkCDl3onpq3egNq12a95fXPgniEQKmf5iHkj8=
X-Gm-Gg: AYBFou0iN4HD4RTY5n9IVVsmFcJFVMG6t+gdb6BrtAw6y3ZsbLNRUI4nT7BzYOoQJ47
	HvBItT8OwRvtncbZf2jgjcDuWsN9KINEH6JmeO+H4N1IS9xRn5w5GHrZKg1gDpowomCoKmvvVbp
	UNdBKEzN1GRFEJZviGeOktqwV8keJ7dJcfygPLzcZZj+lyE2pLYL4r9ShgK5n5FBF141ZplAQB1
	vCmJaNSbOmYAEeT9IrgqQ6wO3sam5AGuQHeGgsw5QLqpB2pJLHR3sqXPQRbDO/ybZeelb4JOw8G
	0aTD9/aSB1wgxGbCfkVc9NlKe04DhZnoE+cTcdUzoyAvZFXVbCkHauhloGZQDF1GeGjxjpaL7X3
	ZLOJ0/83LZA4ekCFdthcHljYdSiSrse4=
X-Received: by 2002:a05:6000:40db:b0:488:8ab9:f74c with SMTP id ffacd0b85a97d-48e2644ef10mr2173403f8f.3.1792564252696;
        Tue, 20 Oct 2026 23:30:52 -0700 (PDT)
X-Received: by 2002:a05:6000:40db:b0:488:8ab9:f74c with SMTP id ffacd0b85a97d-48e2644ef10mr2173368f8f.3.1792564252246;
        Tue, 20 Oct 2026 23:30:52 -0700 (PDT)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828e72sm3174366f8f.26.2026.10.20.23.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 23:30:51 -0700 (PDT)
Message-ID: <7b534ff3-699a-4c38-b6d5-b044383d956e@redhat.com>
Date: Wed, 21 Oct 2026 09:30:49 +0300
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 09/12] mm: enable device page migration from HMM
 pagewalk
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-10-mpenttil@redhat.com>
 <7c8c663f-cf31-40ff-bce4-784726f42a0b@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <7c8c663f-cf31-40ff-bce4-784726f42a0b@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -3bfB1Whx5-yImeYORX4x2kO-_WS2iS2XXiGk6kYjnI_1792564253
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA4B540002
X-Stat-Signature: sinjtag7w5jg184ig5q3dmh8rx4y1rd3
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792564255-88034
X-HE-Meta: U2FsdGVkX19KjC/a5AvEzoJ+B2Qofdwl6N5rhZHqWg8VJV/STorSFFWbKwzwooq8X/oFXwQFWinu5kw027VoVUzvZl5Vod96I+egKyRLnHpYmkFmCqSoXAHZ4ZFBipiEXwjk2pYhXyf7ny2qynTSREg6x5lWywRzftG6QQp3HAlwDf+TnDsfiqOKmIHUW3kteoYeuTbBDuXA/4TJtKzk6qQdaAS1OTepMCm03UKJtnkKhp36ITvxGCaJF15JOeq7FVwDH9kwG+9oYduXd8ZYC2U4PormZ2n0ghMG93pR0jharb/FU/kJQFvNeJmZ8JUkBQBv7u5tXk612plEfSRGyJDx+r/HP3kHsq/8Spml/TJYdSO54Ku4uept2Y9EgZgHn/YKlG/efOlV8g2ZQ3R1cW+EBAzg/eJdcpkMZVzz5NZeILyS7nE9+knPzOg1m2/y3twFkDJFYYHznW3HglGXqscS9Y39rfNuuUWuL9g3MXrWhCSttKcQoG2EfMa4WuHBZ9l1BWYT1VqyTy0NX3zK7Mhz34uSl+emZU4ilYOQ2tJeCuZH9JHVWjbbCSUM4Ol7/cWMHSEA/y9waumcPhEEJeb/cSBIPqviIiJqujSBAu0s1he5QLpOCMDcGDGUks+5jFygXLrGK5CjxJZe0n4hiqvAvKSUpTIDRIEzRIREATXYNRyfXZBBOJWn/WtVjfU9SYepUGoxMf97RRkQYpZAGSM5/NuZ1tVpdARf5LGP3jXMNRA8YcG6zj15E4sYdsUDTbZeZ0RdGFX/gabl2MRSYeuGOlnkknOYQtN5EaqfCi7/Bu02/frLzM7NTX2igYvTNR3VuBe5GV16LgJpjUS+rrOmOZQdVPDU+Chywl0hjCHTWOFdZAoTWenS9p9GpIR4Rnu2pJJamipChFe30OxOgkjo/hOY/tlTp0z8rwlST4MWG6fWxyQ+kj9YO1IBMjzUMB6ZdiliRtYvpFRuJoD
 zL8ssIsC
 RmNxmYz0EqnWP7q+ukiq1bd3SuZzuiq9qmLByQ9OiAJWHMNgW3qNIcu9/Fl+aQJk1KGjE1PbZjcTEQs5VK2GEe5zuTSz10D1XGe6w6PlNLufkAD2XIlLcr0MQMsV9Y7bR5z8T7wTKXJDuXbjcNW07j+cTEJ5Nay3NCWFdl1CUHfnTh7nadFgdTwTJ5YkXYQjG1elcr/jJVs7y6lCKuKJZHbVDAM67+ngt/b1UJALwROXMD6bQJwcMe3WqP6fMVOVsqfot6gFq8hMs47BSz161q5Mt1XaNkeyOiO0lVvTwCQj70t6d2VBKDydPkp8DiG98iofrLU+n1pLolhQ7jMbBB4iAx8/+YoQfjboh1dUQe5zbKsQpAWiQdsGEnjnPOQC1MYuMQ4DkaOwmikbFH27yMJgQySG0BYnnBrYU4SfwUtsVZKTUctcnHULGA0mEg1MsMDea1OQvo5RuVq9Do0oFWQF1J5o9zgsZ73NrOywdLiUGaksT5IgJWCMDMtG83xPtyd9t6kjFJZXkyS/yApYQsmg2kfcCzPiTsV4JbDuDNyCAXo8pi49kkM1+6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/21/26 09:19, Balbir Singh wrote:

> On 10/21/26 5:05 PM, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> HMM pagewalk has now the machinery to do the first phase of
>> device page migration, collecting the pfns and installing
>> migration ptes.
>>
>> Enable migration in hmm_range_fault(), and change migrate_vma_setup()
>> to use HMM pagewalk path. Two new flags, MIGRATE_VMA_FAULT and
>> MIGRATE_VMA_WRITE are introduced for migrate_vma_setup(),
>> to request for faulting missing pages, and requesting write
>> access.
>>
>> Also, the migrate_vma_collect*() based paths are now unused,
>> so delete them.
>>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: Leon Romanovsky <leonro@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Suggested-by: Alistair Popple <apopple@nvidia.com>
>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>> ---
>>  include/linux/migrate.h |  10 +-
>>  mm/hmm.c                |  33 ++-
>>  mm/migrate_device.c     | 562 ++++------------------------------------
>>  3 files changed, 83 insertions(+), 522 deletions(-)
>>
> I got a conflict applying this patch on the latest mm-everything with
> mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup(), quite a simple fixup
>
> Balbir

Ah okay - yes this is on drm-tip

--Mika


