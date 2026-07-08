Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4F2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A946B0005; Wed,  8 Jul 2026 07:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB826B0088; Wed,  8 Jul 2026 07:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA376B008A; Wed,  8 Jul 2026 07:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 127DC6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:05:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98D2A1A071D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:05:55 +0000 (UTC)
X-FDA: 84965329470.16.ED0036B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6522100006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:05:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQHe4Hcf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783508753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36PUVMKlQi5R2pBqV+zxeeyjpccvot4gsKgxvKPyfGY=;
	b=PURyuosi+mLcCZzG2j0s6musWxMyGTotagYwuC+/E/+/qqu7pRiUspSm9C4fiD6AlVAOUH
	WVqjz63MX5kEc4FiX2JZZqNgzcXJuiNjrz4Upw7h5HDLMYlVvw0tHt+cjRjZ8Pqp2ybgPj
	lGgAJC6s/6wmGMqiqh6ADFXL5TPh3bw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQHe4Hcf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783508753;
	b=DGbDzIa6tJYMwcycLH0MQkulP/wtY/bceNvosE36FTWztVzEAtCLhvy9xztT0KG4FLxw9E
	huIAhbPvZYFAf9BPQNFL2jb95tmT4BEoqc4Ag2kqYTDU51D+1e5/fQjIrWLyPQPOgloVxw
	L1TuaQ7thqmX8w28VaASSnh6Q/VN0KA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AEA860008;
	Wed,  8 Jul 2026 11:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8F11F000E9;
	Wed,  8 Jul 2026 11:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783508753;
	bh=36PUVMKlQi5R2pBqV+zxeeyjpccvot4gsKgxvKPyfGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GQHe4HcfKJUDdAMobqY5xJcTEtGrq93tb1SV/DB7p6IMRA/jnuYgunf1/rdXkjhqa
	 BreJGqcsh9G+r+ZUCOuW2/hhV65EXNoymtpKLL8eXDIk9ik1GYkNhAZeYo04ACye9d
	 RzS5mNKf961GnjVnp+md+UDrD7Z8dq/NmF1wXOgHPoU5sBg0SosDGu++RAQxSAiW64
	 H7W0iNiWvYxf9rYvCxLxWwwLMGVVIoKJUOD2vCV2dSGp4O4PyOKTMl8SUp6mBtmGHU
	 y51RUAfNSvaG97z1YVXJrcIRdrBax+EfXBnC+FOnsD1jpK+uPsSctV6QSZ4O8asybZ
	 pLOadDCpoCFDQ==
Message-ID: <8f9a1401-c11b-4d13-9582-29d254c2a334@kernel.org>
Date: Wed, 8 Jul 2026 13:05:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
To: Hillf Danton <hdanton@sina.com>
Cc: tao <tao.wangtao@honor.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260707063308.29176-1-tao.wangtao@honor.com>
 <20260708043751.421-1-hdanton@sina.com>
 <20260708091600.440-1-hdanton@sina.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708091600.440-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D6522100006
X-Stat-Signature: yin8o4r3884o4ttdf5b4j7gkj4raobck
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783508753-986697
X-HE-Meta: U2FsdGVkX1891kvJACOj4Zk+gUjTEE1paHHW5g69TIw3W1fElcQuU9kdlVWex31mU8YxYkVATmGC0Ki8uoUeZ+FSAgTmwAhwN/2S0dfmunnTeozSrvpuKACPbqh+3YhHb9QwYJWlaC/1jagRQVi2m8kai04Gzc8eFTpFi9BwocBFrpBYtEmAkzTrPLs3or60YX4h9FB5HZrzzM7JQmJfK7f0kQBDiIrO3ot7MJy3IkRr693M+lXHeqF8HZakRjMLYaBddwTeT3UODOLrEmnJq3hX7QcLft+5qC/WB4h28Np8XEg7Rd5ZbcXKu8rnit/uWErydYyTuZf/2frDap+9vUf4nXnog8JHXCCe9F4JH/gc5OhOXuSLlWGSkOcYbSQ/npmOjYzakS2tVp93brFQXA68ZVfFGUM9xcsRGx8IdkolumL1ReX+J+RKAuFjrAO/Qgd/nY9UoFyeQ5APNU7h/yLamaTpBOwoJH7tAQoQvbVJ1kfrKNpRIjpUf1VA6dpYIAoZaUHlaf0fj4Fc4AI8rwV8vLquin5BkpQKLfOQ5AiunlBtNV5tfQTBdJ8cVLpLo5cGsfFSavB/XMPBA/3MNJ0YvqDFIqqBOqeXWHF73d4vPGBFn1wjprUwM8QHdTYzIdB78+7pLa471hqVqwE5vv4UD401n4uhHEQLuFOsK9YIJpA8EHqtsOZ0TkYNDzoSauQOglPK5S0H7D1bIm+z7CSTFKg/zqEifpfoU8YCyAwN++vqe48GSffRosvyD12lMr5FVHPAQx5RDgsdf+3ziwEmXIZoYJumbh0w7Zz2X4xIxlDIwS+k8B4e1hLMNwNCwnh7msVskFcIPyViC1OP35ZNI5E0T+5wjQIrZTd5781/NuKD4plEounacucJYBf+grWH1nzLMoVeQ0h30XSGXsmvJ42ppQ7CQC573jCvSC6m/Nnsvc3ZPYn82lIi3cwGh+5ekpHjec+JaxaFP1w
 zW4RvxIm
 gkSk5Ik4uU4lAAX6UCltgF0zjk7QhFPyDlkgmoTEsLyZObhrRCYtMjKQIWnI/3IctFG++a632a2vWDiTdr0Az1AzlFgM9DZgELt2Pu+IrtXMU34TJZK0d6typCBm1yOilYMVssEsR/OxMP+YjDCObVf8CaLdgAmS63eMt98fN7njjFXGg24Qys6HHrSf1yaDKrJNQtPn+1DVmmEOX/hMeIWCp21OqDDEqWFOBFzxU0pLvjq/CXvHDy7g72gCrX5i/UUTXwhP4AjblQ1SWDuF3sh06e7gtudyn7KQp3/Sfj0cD3cH2Ax2JNLp9+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 11:15, Hillf Danton wrote:
> On Wed, 8 Jul 2026 09:45:00 +0200 "David Hildenbrand (Arm)" wrote:
>> On 7/8/26 06:37, Hillf Danton wrote:
>>> Given that no numabalance could land upstream without horse racing [2], what
>>> prevents Lorenzo from becoming another (scarlet? raven black?) lipstick given mglru?
>>
>> Did you ever look at anon_vma, or are you just joining a discussion to say some
>> words nobody understands, really? :)
>>
> I know this is lore, not a dump land for you, and like thp and kswapd for instance,
> anon vma is a part of mm, nothing more. I just want to know if you are telling us
> anything true.
> 
> BTW are you one of the 3 (legendary knowall) figures (with two heads on their shoulders)?

Oh, stupid me, somehow you ended off my blocklist. Fixed, thanks for reminding me!

-- 
Cheers,

David

