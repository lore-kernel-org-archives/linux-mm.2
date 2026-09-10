Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803A0C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5F86B008A; Thu, 10 Sep 2026 12:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BCFF6B0093; Thu, 10 Sep 2026 12:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3916B0095; Thu, 10 Sep 2026 12:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 125056B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:33:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E0A0140594
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:33:44 +0000 (UTC)
X-FDA: 85198398768.16.C238EC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C0767C0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:33:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3KrAh+S;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789058022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLAvnLId1IFvVl34sAhRkO9rI7sSxaoJDUdywkLIsA4=;
	b=55uddNpcSsDQSDcpRK4/NbWcha7nK4FrtMtKPexJppmkZIABj5YXEMb4q37YP9JtPtjcVZ
	PqKYlQF56hV++kf2uf73wOtTKd6n7uJXp5OSaGxccu0aTvfTX8eNdGR9SV0H/d0upc7Iyx
	TbofOksixs8jr+Aiux1Ut904RsqFg5Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3KrAh+S;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789058022;
	b=mqdvQs5mRlFQuVs4uZHxafCK3qXttAsAyF47lqQeGywJARTRgEE1yhJgzstPFKtaSdyuLT
	Yp+CTqaK3Y2d2mVY+2YDGX8sb1MJr0AMWhmrHNbEGVIL0XOvJmpI+EvxG8IqclGO4E2r45
	PdwansYeM9reQlzhVrE6vM5EfRdo5Ro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62F60600E2;
	Thu, 10 Sep 2026 16:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848AC1F000FF;
	Thu, 10 Sep 2026 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789058021;
	bh=gLAvnLId1IFvVl34sAhRkO9rI7sSxaoJDUdywkLIsA4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b3KrAh+S4xix/P0OpUiDqxgv3R47YNcOEZz/k4cQkYQ4EJtUO8w14vdccfMNVcYk5
	 yfrK/KLkr+J+3yBr5hxx9V0e/C/Fnpsk41HzNtQ2U2//XYUdvfkjhIDXsmQvhzfaNU
	 v0Od5xVlijR5jmqZLquXkfeOatn/ai/EUJthUfRJupc/xquyIeAb6/uSYBzXqDXBQQ
	 zyZca/C9m33zpTds+yN+BgX8QSGZ+PUIeRDvgFpEyGLXqBfo0NFXtPOWGW9yoWD1Es
	 +LG14kxEAUZD6AMm/ZXzzu4lGhSehqwleXNloyb0N9AjTSIsePhNjIwSwsxoQGI7sN
	 JB764K9dh89Ww==
Message-ID: <dd134a0a-8fe8-4990-85f2-7b524754b451@kernel.org>
Date: Thu, 10 Sep 2026 18:33:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, willy@infradead.org, jannh@google.com,
 paulmck@kernel.org, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org>
 <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org>
 <CAJuCfpEYdj=u0wczKRrsB8uDkbSzPy+hrsCo9TW9-3J3r3p0xQ@mail.gmail.com>
 <2336140f-c993-467a-b2eb-e99dc9427a59@kernel.org>
 <CAJuCfpEL40p+vk6-km6_BBuE3+YY0WqkpbvQnQGFEo_73MAomQ@mail.gmail.com>
 <9e48cf7b-1700-4a85-af83-8883789ba87b@kernel.org>
 <CAJuCfpE9_1VYqHp6bctUEihSW35TaTw_LZuOGP2UAnF7SA_UAw@mail.gmail.com>
 <CAJuCfpGvi10sibu_=cE76h2O14WA4KNOd1vARu0r1CYmAiCMEA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpGvi10sibu_=cE76h2O14WA4KNOd1vARu0r1CYmAiCMEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0767C0004
X-Stat-Signature: nxtrimk9a7ezxa76cispu63da8hdok58
X-Rspam-User: 
X-HE-Tag: 1789058022-584727
X-HE-Meta: U2FsdGVkX19ktrkacKxUX/zKMvN9C6gJjl335DD06hMOxOgaUMbMqyOF9KlCDOz1EHiNKTyaEblXzjuX2t76HVwxlRQUy8JjR3M3vqOqw2i/Lj5GB/cRVDCFT7f8qVIuxeDY6kClFfkzTYp81TbBlzNt8bWUXoVyxHZ8f5x29fow2d4ZpHO99V+gbeJcobiV1CJWl2z4Lk7uuRgYxG6heAiZPDa0h1q5bZ+4YMle4WvOP72LixJi7t3jxf6uorS1wh2UpbjYryrIGyNuVkTqdo1Y/6PRKBFmw5zS207sRe1rsH2LOC5O6Dt9vwam90M9ncKJ266Le1IoDG3pROQLshUTvilz/hx5pzT+CLN7GRDNnFUnlBbYWM0JbDOEpg2/jh9onuQ5Tbu3riMHrOUQt503E3OWMoqukMOGVP2pEzv9MLhacRGMp+0jv/LMQ5s2Eld3OvmaOikozIG1o4pAwGZsxj2BBk/nrsslNXiW2ptWPAO+aBSvSEq5KofnoOInQwdpDHfPIpNDePShItbvtDpnCxwGelXrv7FEVnXFtMCpH2MMWNzlYJFIfHxoigSR4FbWklreyOvZkxpuHcZyylJ0YSCluG+h8QxHwE4ZcSm8JG+EPiNWRV550WN86Pten/5ycw4ygZIqZrFXicz7LBeVJFbynhLbEWe/HuFWbT+RfmWdwqWYj+R8Eas09RJUp40OyK1KX9Zcy7JexXg13/sHfiBzwJzKWPzGBDPU22C8i70UTwZNR4DykeLJQlxXExI4C9QTpo99/yXFIK6PSwlHp1Msq+UpVnvGACnhMz40H/maqL/bP4mdyFw6mM+f5qgIESvBZMtOXw/+3RmUcRx5bx10xdmnjZ7A06laQygRwCYdfWYEsm9oArtihv9i8oehEPBEMHBKj0fOhstHJGKIH98ccZ9xqY7KtQOIAl2VljRtcQVQemnAerXWNn9jhC9fhKkUg5UOnOLw9JY
 tMy3AMs8
 BT+Ti75K8nb8reoL2zAA4iubORzRe05i+kQSWeyYeK0UDsjYgVuMnyqa8Ood5IHavjuRwlK7oBofzJ2Hba1ER5yrdDOeFwGWlifwVLTDTEjzcmgKjsh9PNfg+RUxcao2lvfD283FBG/p1jB2oYUoEKQwKlUCaAQGi+ngM01WHXHZpoGjZK/OXXRKcGd13eqeaubJNpIx/1HRUAmSCLuUOg8WYtFVGEJF22dsdZL9GMFY58lhBYvLuQPav+Jih3vWr6OvyldyZT4lP4G52MGZJ8evw14LDzFC8OHWqnMqj5KgRVR+b9gKXKcGurD/L4A7KfPUgxSvaWk9sO1tw4bnHAIFmFo+EwFH1oHY4/L5VGdbvpmSlnjsuWNwALZU5sIDI4QiE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 18:21, Suren Baghdasaryan wrote:
> On Thu, Sep 10, 2026 at 9:09 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> On Thu, Sep 10, 2026 at 9:01 AM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>>
>>> I meant as part of this series of course.
>>
>> I understand but this particular patch cleans up smap_gather_stats()
>> function, so if would be weird if I move the comment change in that
>> function into some other patch. Unless I completely misunderstood your
>> suggestion... Maybe you are suggesting to split this condition and
>> comment change into a separate patch and making this one a pure
>> special-casing elimination?
> 
> Ok, after re-reading I think that's what you meant. My first
> impression was that you wanted this part to be in one of the previous
> cleanup patches. I'll split this into a separate cleanup patch.

Just to clarify: I'd put all COW mapping changes (using the cow_mapping helper
and rewriting the comment) in one cleanup patch that can argue why it is a
correct cleanup and doesn't introduce a functional change.

-- 
Cheers,

David

