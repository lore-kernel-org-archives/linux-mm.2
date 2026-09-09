Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCA5C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EDD76B0096; Wed,  9 Sep 2026 13:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC116B0098; Wed,  9 Sep 2026 13:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33416B0099; Wed,  9 Sep 2026 13:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B365C6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:04:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 163CF120283
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:04:16 +0000 (UTC)
X-FDA: 85194846912.08.8547FAE
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id EC040140002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:04:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D8vM5R88;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788973454;
	b=qbPWe4kWOq5jiBUBrIU+3dICDXik+bMQ1xga8jBgpngNNQ2TTHv2C95Lc4r0hHjp6WqZiB
	eRmi3VxuH0LD0wKmCuZCKtUdObRPgdnjWSj5UIH+l/8z0MTVGXTPY5v8h8tPXWYqtc3EHs
	seETETePdRh5kWX83/5m41douV86MN8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D8vM5R88;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788973454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/3n7+l6Hk+FAEPnBkeK4yLp6nphYfaKQMZLPlsMb2I=;
	b=Ds85XpLxQRJmrnEwksRgy7nHLcJ+brO4BWZLR23WEY7g+uvduq+u4Q42XcLeOST+NugjhX
	PqwVPeDA7gNatupoyr1Tiii+CqFLL5I6s/Wm5r3mI42eoqRP9wkqztxFGlyrRDQ5DL6Bza
	+j0U8wPa7DBlclI19w5m2/krQ+uWE1o=
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-46f53c8a5fbso1984598fac.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 10:04:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788973453; cv=none;
        d=google.com; s=arc-20260327;
        b=bbMuuHvYbZFUinF5d0ddFmfyE2Su4cfkkmVnISitq1QnG7Gm8ghWbvXSyVQir6Thd7
         ZGvraOX2/onPaBeGnm4J3Pq+9rZr+5dhj9VuFAZxSsMzP6BC0Tk/rP7y4FEW0Hkfdypp
         VQj0k1qbfiJOsBC9ojqtFkHgJ8f8dFsuoY7M+oXkR9hLwIaue35/sQNwWxK96/u+3JnX
         SkbYrbwAmVjwD0UFnbfzpvZIiRKC85G76m1UwmoTiGcI5L5vDUf85EQ/nemH9cx2w0Rr
         sllLDXTOXdoL8oHO9IzkLRMFgScPLZcQtlwRXGNnfcAGiuKpQ9X/pKK4TIDeIefLObZK
         4v2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=A/3n7+l6Hk+FAEPnBkeK4yLp6nphYfaKQMZLPlsMb2I=;
        fh=9VdaurY+BXZtRpex2JNZ51N0MirB+jG3/XM3ADWU5Dk=;
        b=HLGgKkrnlOZAFK4Qg+3bsMEr44vN0ewXdL1ktbIydml/HkpyfS7Ck6ZoeHXdyHBfej
         WCU88Ak/yNcJngXHRYnIpuDc7UmBMj0TbT+tN4ElzSk3G1HfNWE6o/K0rmKvRciFBjXU
         z8jAl9g+CuzB4rPaYiUQJ0HquqK1WuLcKnzH6EjpmgIwLOG9nXVMdsT35hqxibQQKQY3
         CD8jVeXlz1v1mlfb7N4jGsx3BNrLFOMUJShFGzQMNaolUFxtpAORT/UUBHNYsMifoR6u
         fjNwoMsIsIhcLWyYH/pSweAk5nWY7b6J091H+7UuOx7SmrwKEB6920crmbuGe59vXXrT
         7nbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788973453; x=1789578253; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A/3n7+l6Hk+FAEPnBkeK4yLp6nphYfaKQMZLPlsMb2I=;
        b=D8vM5R88ndjun+zCK3gY0NxTY03u9WoHBR6XPxKfVWRKiLOiY/bc3fS07SwHAR3bI7
         2+12N/nDkkYygIvul4r5uAkiBiYYrIejLaU/upRTOfAUID3aC/cn61McoZGElzCBtoVV
         NCvGfEJxliMaao+pDtnz8PBrZg2IxH9z5UY9PgiRc2kRtggKUYMUN48j3MSy8ifQOQQk
         Ub2uIr3YERFkNF0YRYmP6oCsFp722ZC+XSsFBXVC0VS2sOlNesi/kF/xd+9a6jhlYO/F
         q81BfIye33VvcN57Vyg8ngBER2LNH9TSYauCrG3HJaJNvQT21Tg3r6t5v1oUSTijyfo8
         Gs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788973453; x=1789578253;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A/3n7+l6Hk+FAEPnBkeK4yLp6nphYfaKQMZLPlsMb2I=;
        b=dEKBUhaRbLQ0JWxmvk2nVznIWNlqXzAqWjXA6fjOCvZZ6XQmrUB4Kd2tcx7uanSM3I
         0RJnrQbFZbypgxPhVtJOtXOB8Ci++m5kmq9sgIdxZNNCJeuslAMEfFio5NRUcv2WANJY
         q1Xci6ozoEoTfVYKTDvyhASHH1/yN/0uVn8XhaTr/GDj9INZUJC3IZ6lHYFfQMBeMG6f
         3y89qjDTfEU8wSjDVLLnicEP+/hFHM0WtaU4JBEEudEMIL+kE4GWvkQnvgQ6yAY44krY
         J+xLXb/pX8h3MVrMUugxD5Fwd3Qyy1cnopzLqddL7U8IymiZrTF98KX22WsDejQX1fFd
         Fpmg==
X-Forwarded-Encrypted: i=1; AKwUvBxhQVmPajA2phXo8nv9xmmwucP3UDNzQwedNLGko/YyEJQqHjyEoERBO7wF30rCz9uBUSA1qHP1vg==@kvack.org
X-Gm-Message-State: AFuF++mzx4WdFIZvTcCt/vtqLUOLRVhSFsIaOGsajloDIcTmIY1HgPIW
	L2CdMow2s0vimngdNPTiSrbw4oH/plmCHhXm2oiQw/nTaZhbaYnPixv7awDVD0ALGwqvaVzwjz/
	8IyPXl/Hxns8SX/726eC13wuZFddWT1yKfIn2Vo3a
X-Gm-Gg: AYBFou1U+PicbbjShlydxsLCfSzhyZ/9ti36cJX0x80ToRZTjLBX8mqtWMHVvbFwrsv
	km9YIJiFxO0qnUGjad8wO9Zty5bmzNFPxA9kK1Eg2H0vlV4Th3y9h2JkrtmeCQFvn7aetSZKUzA
	oJvhcAfUim7OXUV/IzTlGj5b1QPMNX4dJJx+gMbLkYEoxZTePaXfy0e72kuD1yut+kzKGw9zt3L
	M8AG1EEsvbfxdcY4Npp+4HPCTLvZJ5A4JYQx5ZzlteVe1e8oZIylWa/YBIuQSj4xu2MRRJY0ynu
	r4qLCjUa+KTSHdKcVYfqSKhqEpQTGPsjgY5pd2jtMTtYiF+l6PZS7vdk8g8PyJXDcrSuIjUBAXj
	PnKqh825za3Q=
X-Received: by 2002:a05:6820:1c82:b0:6b1:6c44:d3b1 with SMTP id
 006d021491bc7-6b6fa8dca94mr19436135eaf.2.1788973451595; Wed, 09 Sep 2026
 10:04:11 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 10:04:09 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 10:04:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260904171412.191180-1-joshua.hahnjy@gmail.com>
References: <20260904171412.191180-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 10:04:09 -0700
X-Gm-Features: AcwNN1V_OL5b4rKvClN1gT5AOJG1MUC1dn0rdqBCDNzmXm8Bb2nF-U4o4S_9uzM
Message-ID: <CAEvNRgFfSJzvhrO7gEs1DVYV9ES0xjBtGJgqruFo-hSKUSnNZA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: hugetlb: Return -ENOSPC on memcg charge failure
To: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Alex Shi <alexs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
	Hongxiang Lou <louhongxiang@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, jthoughton@google.com, fvdl@google.com, 
	rientjes@google.com, vannapurve@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC040140002
X-Stat-Signature: 4buqw7n4t8bgcgez1wzcrgdp8wpnohpe
X-HE-Tag: 1788973453-579408
X-HE-Meta: U2FsdGVkX1/roO9e62DzXdxjgRYLSoD+N/hKEi/fyUBTECbEZAJYRyyI7CbnaPGa3U72yCVVEKKxs9wWrBP6r1uetDBKKOYQ1OisX/DZ99bSBfmCqfzuNreQ6/f0QMgAb19ksNKuMc2vrzHiGFzkStnLwPg+j2BcM4ffHHbCf/DspUIjTLAHNdOtwwhOrFrHp1u6ekVvv2N2hFHz4k2mdfiJ8qHg83a5oOxM0rInRBJzHvMyc3pF+xsa0SptTVYH158S47YDjxqinVRxE15ZNdWRcpNvcNIZMhTZXmn9C6Z+GtUlS5718/PPtI23O53qX5YnVhjarsd5kvpJuycz5K21zHSLINTjphD9TGiWgiqjm2yYr/CHcanH2/CE0oWBi4YGOPO62dy2hJ02Xml8TbT7Qroq9ZMqSObGPvrsJLL5OP0d+zZxW4aJ4TJEeFMU0wyXxu1VvHP72VHjcDV+lPl17BiNMP1yGQxcR9UWQ0zc0QSQoAhWEhXDvLSWpK9Beax8aUciHjqlhIFE7mOZj1dIyVSKj6IFke5LG2Eoh5hhJKR6QZcn4kSjvzSHeDYODtuMWGLvnyJR0le50D/Spp7WrZaSKmrfA+dKkGDlQgRA4AL/FRBJ1mgKTn0uk+68NJLPB/RrS5sNlhHBT1gDqJ+dh4RdiktYz+Ip+VO41Zxw3nQWUvGuhk6kjJGaJ4qRWFXXz/De7km0eTDtcwDvO6qNP/tf2zRPik73FwMCYkzaBI4451wKP83ggkop3GOdANU39BCA/I5913jKbxzc7oVVzg3Cgr+GLUi38xYeHU00CWoHpH2FGf2r03idvAFijpttyKgMn4diWOc7ouoYqzI16HiMiEdlGxiWnIuWuYK3yP8jiuHsg5ul5JwgPzmN0F+yYsWDPGSoNofH9jr9q5OFcS3pMMbpOjA5dKavT3uHSSm/LAJUclOyEp9JegxfN7/lQ9Z5wsYeSAHL2EI
 udK1q7tg
 B/xtI1OTb28o5YQCK7iPGJviOqTLkbPp1SgeZqo7Q0WOVVY2uLfnaDZj/EPuyjgpyubp7Dz2caSZk8HJMOXSOOO+Z63QvBeG4j7mXpg3yYvt/2c8Vnq8vZnkNMefHNHzAyqsuMe418hx5bKHjRXsP40oKs0IHDPFfAZtQ2p958RVil3wQJ2V3YT/EDf1TKN3j7r8Y8tjkwT54yG/BtfChlRiz4vVDQ3lq5pGY3XSUOGx106EkXpabFhIAqOMAyyXAuSS7VqOrQLDco9Cu/eMp7I5CFW/HgZ4HmU29ehAIGkN9SVBpyQ1BsjX+nw5qQ/KEaTJP8s7SX6Mj6esUb4klXkEhCteAPbUPIIPScq4PTb8E+WT87xQIxVh1gWbmJo6mATOZskyXT2WOJ5Kh+0L8EAy4svpFR3XbtyWoDUkm0ZVSMCXsZj9WxqHssGhctJP/Jb/NXqp6wv7WCntaHE1u3xDtug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Wed, 02 Sep 2026 01:22:56 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
>
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> When mem_cgroup_charge_hugetlb() fails with -ENOMEM, alloc_hugetlb_folio()
>> currently propagates this error. This results in the page fault handler
>> returning VM_FAULT_OOM.
>>
>> Because HugeTLB allocations are high-order and use __GFP_RETRY_MAYFAIL,
>> they bypass the OOM killer. Returning VM_FAULT_OOM to the #PF handler
>> without triggering the OOM killer (or having it make progress) leads to
>> an infinite loop of retrying the fault.
>>
>> Avoid this loop by returning -ENOSPC when charging fails, which maps to
>> VM_FAULT_SIGBUS, terminating the process cleanly.
>>
>> Make mem_cgroup_charge_hugetlb() fault handling use a common error handling
>> path, the same handling used for hugetlb_cgroup_uncharge_cgroup{,_rsvd}(),
>> which also don't trigger the OOM killer and hence opt to terminate the
>> process with a SIGBUS.
>
> Hi Ackerley,
>
> I hope you are doing well! IIRC, this is the same fix as the one in
> [1] (in spirit) right?
>

Yes, it's the same fix as [1] in spirit.

> I prefer this change since it is more obvious that we return
> -ENOSPC right there and then. Since this is a fix please feel free to
> add:
>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>
>> Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  mm/hugetlb.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 7857728457952..01b57f6d3b804 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -2823,7 +2823,6 @@ void wait_for_freed_hugetlb_folios(void)
>>   *
>>   * Return: A pointer to the allocated folio, or an ERR_PTR on failure.
>>   *         -ENOSPC if cgroup charging fails or no folio is available.
>> - *         -ENOMEM if mem cgroup charging fails.
>>   */
>>  struct folio *hugetlb_alloc_folio(struct hstate *h,
>>  		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
>> @@ -2896,7 +2895,18 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
>>  		 * were committed to the folio and freeing the folio
>>  		 * would have cleared those up.
>>  		 */
>> -		return ERR_PTR(ret);
>> +		/*
>> +		 * Return -ENOSPC when this function fails to allocate
>> +		 * or charge a huge page. If a standard (PAGE_SIZE)
>> +		 * page allocation fails, the OOM killer is given a
>> +		 * chance to run, which may resolve the failure on
>> +		 * retry. However, for HugeTLB allocations, the OOM
>> +		 * killer is not triggered.  Returning -ENOMEM (or
>> +		 * anything resulting in VM_FAULT_OOM) would leak to
>> +		 * the #PF handler, causing it to loop indefinitely
>> +		 * retrying the fault.
>> +		 */
>
> NIT: I do feel like this comment block is a bit verbose, though. We just
> want to explain why we return -ENOSPC rather than -ENOMEM, maybe we can
> just explain that OOM killer not triggered --> retrying is futile?
>
> The change itself looks good though : -) and I don't want to block the
> fix. We can change the comment later.
>

Got it, please see v2!

>> +		return ERR_PTR(-ENOSPC);
>>  	}
>>
>>  	return folio;
>>
>> --
>> 2.55.0.970.g62bdec98f9-goog
>
> [1] https://lore.kernel.org/linux-mm/20260720-hugetlb-alloc-failure-fixes-v3-2-7d2a169aa9ee@google.com/

