Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5DA7CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 10:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95856B00AA; Fri,  2 Oct 2026 06:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D1E6B00B5; Fri,  2 Oct 2026 06:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83A66B00B8; Fri,  2 Oct 2026 06:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B299D6B00AA
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:04:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 494F91A065D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:04:36 +0000 (UTC)
X-FDA: 85277251752.03.9119322
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 916EE180011
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:04:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVdO1SRO;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYncI7yMFVGEZt4HudN8D2fnyBtTKnCcRE5C8VrmBO4=;
	b=ieMvmHFCNEuWOExx80VsgN78BXq2MOwKlF7isA/LHAtcvQNCIhV5iInYT38c32HGtxJvi6
	UzuQueVRYalingp55U+GAIDtzCIxGSOpbELQRh1JakPsfRIUXNrKiPJNBmfLvchBbUdomE
	SYdNWCX7OnToVtSEWTrL2N2IB1Wjpzo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935474;
	b=HZ4m4vHVamKsUnPRAIP51G1xU0zjNyvoXlMu5vWbhLeBy3pecVWQRIUHqnamXrJB50W+2b
	6RMP/WPao3HbOahNVH+QExn9G7nc5K3OkGTQVlLm0k4XluEBiwppbb60z3Yq7GqE6ZemfK
	qDHM/RX+EU4olJzvxT1JNQ8q7d22Lms=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVdO1SRO;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84E3760A70;
	Fri,  2 Oct 2026 10:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDF21F000FF;
	Fri,  2 Oct 2026 10:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790935473;
	bh=OYncI7yMFVGEZt4HudN8D2fnyBtTKnCcRE5C8VrmBO4=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=mVdO1SRO4s2CqWoO+/E8Y60Ac/d7QlKMYCOyu0BWv03NeoVC13hlqDo72y+vp210w
	 CWrLh1Pw0WKNCXHk3o+3xRUbRwy7lZ4jOV7Jg+HNYxLpM0psfLfRd4ahLO5ugeSRho
	 fkdIJv9HTYOS0/yXLehuAQshDjTFBd6BMjnfrGmJjFpN+pxvUWtfc4zVQaT0ecczNg
	 uFDUFeg+I47s5zu2Gc9XTPNNpzmzP5xLQ+tEf5uVMT+lsLzmosSVdQLQF3TkJhJzmL
	 cpxzENdCJWGWtNl8bwd+PrhAwmFG48VftYC5/k1U0QJKM/nusEoqXnb+Pto2MaSNuI
	 wieX7kW2lzwSw==
Message-ID: <9d43234f-93cb-4c86-a2a6-a3cdebf48f3b@kernel.org>
Date: Fri, 2 Oct 2026 12:04:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
 akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
 <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
 <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org> <ar9omYD3HcTDBpGA@gremlin>
 <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 916EE180011
X-Stat-Signature: qb4yd5fz8chk6j8b6o1he4ofdxjufh19
X-Rspam-User: 
X-HE-Tag: 1790935474-367294
X-HE-Meta: U2FsdGVkX19f2b7JYr/iTP4RGhW8dTD4PqN5/cL/79+yraeEwgCbwZ9S9iRHe+T9erUW5jsWAFO/nLxWWazZ9WXxq1mkq1NDs3phHVfJO6h1KEiMdPtakXGfLQI0v2Cgapo3Dmn3kwc2RBnsFYBXbKNzTgFTsq4ZDSlG45A8QrI1zTfLiT7sgkArjW94tfOzBR6SG5yd968JnDFGbtk2qRB0feT4NPXxXd8+ckmuN4vzFpWXP/bxQ6UNC0J2wVtaeMbaC/Gi+F3PWDMo+aUebtlmlpUUK7Vt1WIupYh5f6qOlVIVS2Gz9zUCONQKXYx7e5P5gEBq99e/o2Dge2mWmQo7zikrOBLbJH+VsZYx89ZhCFjJx7RfeSI0O122AvTQ8ZrkieCTVSu/ff0EqKAA8v8gvU2vqDerCWvuZssfzzWP3/d6CRoJn+IYUv1X0OBCQnN3Br6qbRm8xLWk7rIuKLQC/NHpEpyPxIfL39zcLG0sIWLXaOFbjM3Jsfrf8uElAS38+n2aar8TkkV5KrH5IhM5+gIDBW5TH9zs+INBy4iMo/S+gnkdpURWz4EXiyuosU/srUDyk/MwsjFfbpVw3gc9XmAhVmF7ZDUlUeX4B4/kElxd7c4DDmR63dCp2gqWlNm661MbmusvqS2Yli4H1uNn2ZzG6B0u2eNquZoLpFPm5Qc7HylawytOUBwtXQjPMtG2B2vEtdafyJ/SnTX1VpEDmPf2UHXWAjJ1Z+vjfYicHrnfN86+n0ucZUE+hvTrZpG/0CllO98IUZBvKcdueWEqWQA3v4kG52IQpq3f2wjd6pwNnY1vTZ39tIuL3DvNO+x3BtE8/Zt9Qti6XgsPd9EP+FPx8F48GIIfQa558cN+HONaZEOcQ6aL5QKjJNMw6PY6lBKUlVOOOFEx7psSsxtdbbI8IpVvZR9UfgR9CEzAyJEBqKejD/kHeFtKmEP+2TYTOWlsLbgp4OixmFM
 XOWwjpRT
 NZMoQKTCrFOsnfPrbcfjluwIoTcMH1EjV65L0tcEUS6uo5XR9L7mmGo/59W/2WkOTw6JKrW9A0z43PoQMbUrD6mNYD/7VHjhM3DcP0ZEzRUhPnOElPvH7D5p3so15G40r57qQfHOouPx0C7icKSd023Fjvewfxbd0w1rIQVWjRYzRv1qQNmRIqhqVrpqpX9RrZxAiPIC3UWj7hKpAIw8K3G8Y/low6WxjUY3vPAq/OLxfNnjH5acwCVKm1hfy9nVm5mZN9XLvupyEJ2FjDM5i6XjffY1hkao3cQCVcrGwlpUognN02LdHFnJlrnZnG3CygChgeFYbWgKiy3mL3VhfS24ZdkL3/05lwt8hrVor/smBb89HdBqsgzcGtDI78gbLOzhZ6Z1yEk5xUYy6Bu5cgs/WLklJAy1jqtF4Vt7ZXEWT+U60YuJ2gR01dVn8jJEbnOkesWVwpTCsyfNxuRxU2Yx678jDvQiH7VXDwdEfCrTJq0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 12:02, David Hildenbrand (Arm) wrote:
> On 10/2/26 10:38, Lorenzo Stoakes (ARM) wrote:
>> On Thu, Oct 01, 2026 at 10:22:29PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>
>> Sorry to say this looks schlopped.
>>
>> This guy has sent 10 series across 6 subsystems over ~21 hrs:
>>
>> https://lore.kernel.org/all/?q=f%3Angocthang2710.1999%40gmail.com
>>
>> Nguyen - please do not flood the kernel with patches, and please use the
>> Assisted-by tag for generated content.
>>
>> The original code you submitted is really not great even if the issue may
>> be valid.
>>
>> So I'd say somebody from the core team should take over this if we want to
>> come up with a patch.
> 
> Yes, I'll take care of it.
> 
> [...]
>>>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> This looks reasonable but I hate that we have 'special' CoW overrides like
>> this :)
> 
> After sending this yesterday, I concluded that we can do this cleaner: just have
> 
> bool normal_page;
> 
> (naming suggestions?)
> 
> that express that this is something refcounted with a struct page, like
> documented for vm_normal_page().

Hmm, have to think about that once more, regarding VM_IO and if there are some
cases that would actually have to work in generic_access_phys().

-- 
Cheers,

David

