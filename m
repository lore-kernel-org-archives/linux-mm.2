Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5CDCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584B46B0096; Mon, 18 May 2026 02:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536126B0098; Mon, 18 May 2026 02:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BCB6B009E; Mon, 18 May 2026 02:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 330216B0096
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:53:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E53B54082B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:53:39 +0000 (UTC)
X-FDA: 84779624958.24.AE61C5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4BBB41C0003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:53:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eMTkfE1M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779087218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kg3IV/604eMO+1io56BG3ruzylx6bw9hZ5Fy0yyL00=;
	b=sekXqfm2B/M0F1XlVwheuf1KjNEsLrJhJDSNDIlZ0Vp2GxUIJkWuaC2UqdDjSqorwORWB/
	rW1H9fChhp6ovY8qPuvkLO3onr0Fya5KvC4dpEj9IobsVziIzqAuteGmlyO/KKONXbKTJp
	Noo9K9vqpWJpO2dTdOWWBzAS9/GEL08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779087218; a=rsa-sha256;
	cv=none;
	b=Eds6CiowulRXop3c07hiB5r9pUVK0Ev5pnmF7MVx/JS7PyGLANnlCE882zEYsukt5E3Wg5
	28n9t18tPOAXhFksFX8qOMjJFFeXqDd7jF8VJ4IT1VIBr3hD6zZKKcQ7ggjNzXVh4sp2HW
	5dLBvIUPSjTKQT9CKJYACkL+6klfYS4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eMTkfE1M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB11060125;
	Mon, 18 May 2026 06:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AA8C2BCB7;
	Mon, 18 May 2026 06:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779087217;
	bh=vWli/vR+RIARR6s+n9Haw5NKOwfocRPOqFQJCpL72dE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eMTkfE1MlEPQxdXxoYeJtR4dpNq3HqTgyugbnYucJrot6ZLZXlUEmAqVWU+2Pihu7
	 ZP4ydv2htTfvk12ZnivO1P4nyoq7E/pHBDet3srToax3bfT+kH2id3hY6zw8djR7Fx
	 SjvfI3VroRrYuh7BH9fewaNJHKBmX3/BTMuvbQxqqKPVB1gA8V2+g6ODThXw6DJGKu
	 U2Fmhiks9AId7/rgSk9Z3NndhyEOxoen41rRH5XGD/3s1cnGgG6G4lwckfXhHrlzPT
	 lKhkxly1tVH8itrsoyBKe74A66Rawl1f9vgv+7Gd1z8EbX45JsXIqJ9RVuH0IgdUY+
	 EivoaUjI84XQQ==
Message-ID: <e4e6a1ac-e6cd-4d10-a0a8-20b875cb85c1@kernel.org>
Date: Mon, 18 May 2026 15:53:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 6/8] mm/slab: allow changing sheaf_capacity at runtime
Content-Language: en-US
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
 <20260516-sheaves-tuning-v1-6-221aa3e1d829@kernel.org>
 <agl8p8WkngbBdyZH@e129823.arm.com>
From: "Harry Yoo (Oracle)" <harry@kernel.org>
In-Reply-To: <agl8p8WkngbBdyZH@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4BBB41C0003
X-Stat-Signature: n1imo51suzg6pmm9c34jey1kiw697owc
X-Rspam-User: 
X-HE-Tag: 1779087218-325125
X-HE-Meta: U2FsdGVkX1+eBSx7K2hY/x6NYttcWI4nkHERY/EQsg4y781DVPkYLlYPsXqhmsYd87f2bEhhnJdceMzsRbZYMyS7ePXlIGzaNAe/oDKrMtZI+BTf66B0QxiDwPY6XvQJ2dQDR6GCZrShEeeDmglUwpvE+9KfVeBzEZyMAniwTfw2oGuFTLIWgazAm3I2639AF/y+t+Jold5kdOMm6r12rQva28uJ3uPvHqBWQvvEE4+MNYqOl/qWNEIUveG1gV1tR7BW4Ztfwjt4bcu9SUyCgveV9OzC5XbcioZMMwFEyJkhZDqSK27Ved24lmXJgoORxdywKmLt9+8e5civHpcV0ZJ6RDJpr9TAgdgYxgAf1m8wb9Bya83DikWmW8vAHfpa3MX2xPdGS+AaWgkqVt4KgMFM8er6oRYNRRV8DvyBv+97d2Bp6Nh8qMqUakQSZf59ozOJPcNv/EYCxpRICA9u+DdxRCn6lbcUDw/Jvdxxd3VcuS7lvtp2Yh0Uy3BmGsxR2sl78re3jMv0qaZ+9Jk3zBiwWvSjwO9d7TwR5lysNONJrYNf9vwXU+BLIDcSxSZqMPiZ5FHm2F6j33F+pzRRkgB/WxoB8ngzzX0xn46Lp4vMbUp3sUtt7fQdoZoqSVuQO692MU2avEbcOm2r42UkuWcoUpW2+7eUmTVGNd7sIW2+a0gcZfx4wkIDzkwgQoIX7yPK6cWSuw6+7TtdUk85cm2AHprAktkEdpu4WdhLcN34yyta7HtP38IRM5qz9TzxcCNyxP48JGcJZOtHyON+BWICWGA+l5I7T0q9vW0OQKn4nM4wzK5DvCBiPOZk4vZKJY/P4oGlIzJKXFwUisNden83Gdqm1Wfmp/q/a9LIbwvEniRyPY4iAxP05HOppXR6rgIHboR8SfIj+YG1AlleW1SFqvuHng45XxtVFtMGs+X3H3eSiLxyDh4IVBwRWVKEFLYc5urhUWAO0E0Llyr
 jB6QNzI/
 xugFIqUZb3pbfCyC68oMNBz46/50aNw04GnbfGH73glIhCnWeC9fYYF+l3CoQmG8al5tqP/DnxErS8xMnoqFyrsVr6mP6r2hw+Vrz9hPPw4YkJX6+ivC6APBvPrG9ruwQ3IJm3m31JN2c1wJXLJh/qfvzDmf9LvzPoIq2p/5cJAeR/HvTkZXpiU/I2nLDFGUbnGjkzv8Fi87glwtExEv722xmxUkIUE6y2+1BtqlzmbwRpNyK23yu3Ue3xZ8pSmtQ8XGnSqYlgpRTaUYWXc93x+C4L7CumVWnpRVHz2GLqKktwNW1BMPBHWdtDmgX+rKFS32kyN+uyJiYbBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/17/26 5:30 PM, Yeoreum Yun wrote:
> Hi Harry,

Hi Yeoreum,

>> @@ -9111,7 +9309,39 @@ static ssize_t sheaf_capacity_show(struct kmem_cache *s, char *buf)
>>   {
>>   	return sysfs_emit(buf, "%hu\n", s->sheaf_capacity);
>>   }
>> -SLAB_ATTR_RO(sheaf_capacity);
>> +static ssize_t sheaf_capacity_store(struct kmem_cache *s,
>> +				    const char *buf, size_t length)
>> +{
>> +	unsigned short capacity;
>> +	int err;
>> +
>> +	err = kstrtou16(buf, 10, &capacity);
>> +	if (err)
>> +		return err;
>> +
>> +	if (!cache_supports_sheaves(s))
>> +		return -EOPNOTSUPP;
>> +
>> +	cpus_read_lock();
>> +	mutex_lock(&slab_mutex);
> 
> This patchset looks good to me.

Thanks :)

> However, I’m not sure why we need slab_mutex here, as using only
> flush_lock seems sufficient

The main reason why I used slab_mutex was because both disabling sheaves
and shrinking the cache acquires flush_lock.

> Some refactoring might be required, but it seems better to remove
> the acquisition of slab_mutex here.

With some refactoring, we could teach those functions that the caller
already acquired the lock and use flush_lock instead of slab_mutex.

However, it won't improve things much... both are global locks, and
I doubt that it would cause visible latency issues when creating new 
slab caches.

I want to focus on refining the capacity change part for now.

-- 
Cheers,
Harry / Hyeonggon


