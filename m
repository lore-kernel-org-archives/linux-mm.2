Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 684DDCC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 07:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CE1D6B0088; Tue, 13 Oct 2026 03:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E836B008A; Tue, 13 Oct 2026 03:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26DD36B008C; Tue, 13 Oct 2026 03:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 046686B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:20:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F2CB160A41
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:20:31 +0000 (UTC)
X-FDA: 85316755062.19.AEA17B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C188A1C0008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:20:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KovHLKRt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791876029;
	b=XeQR3+HqtdURZ2fWC8yGGs+K9KOaeR9y6MSl+8JmAukwtoWnoxqMu/JIpkWV3xLZQgswSB
	VFtURSkrS4U1bw43D1HeJx7XkGT/lM+Pd4yVWA1ukCODQKrFb1owB0p3L9fv44PTV3Tu5w
	V7FIJQo5nuyi5kVXlI42rUdOSvl6yhc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KovHLKRt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791876029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hvxJuw/onLf9QQABMCfiWLmeIlEWLIH+P2qNg54HLg=;
	b=DDsfBmABrFc+QQB/5RAHEfw1b2Y6dImLCFEe7gVKEzaJQpXALWWhldkuJ7Moo7A6s+3kWv
	S6NF2+j0i2dhAkt+UvVdkJa87ZED0BzndQZVJz2VpBpyc0A7JMa4A8rljXxHh11UedD8Gc
	UmU0j34N6jKX1uLw7Xq+nrJMgXR5O9s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECC07600D1;
	Tue, 13 Oct 2026 07:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980C81F000FF;
	Tue, 13 Oct 2026 07:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791876028;
	bh=+hvxJuw/onLf9QQABMCfiWLmeIlEWLIH+P2qNg54HLg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KovHLKRtTJ6UpNtOIIBsCRSvaLl1VdKjekjsbMjtbGI6WCJwm/NJM5CakteAbAb8h
	 ZQkxgU0YCZ7x6WOwxR8IbvXGI0RRfCV4fY1+lYPBmJHwnvZkawr8uw7kV82T4w3hZV
	 O1qnzbNsymNhR8/gM7sPuaW2JX3I6Z1wSbOYXAPYMSZauMs06sDgH5obl4rl44+bK8
	 7ZOfHyXE6epVK5252M6UU/wQtxfPF/uRkJNYGQF4SyceqJWA4V5VFsRvIvIGFOyIvg
	 rguRyCYHqhWasD9R7iTInraEPc4qInweredduAZ7T8zFu1DmwIAnrgxpZBnL1BvWg1
	 kDEsJMhtyJ3Jg==
Message-ID: <b101664e-5eff-4ee1-a917-826edb1058cf@kernel.org>
Date: Tue, 13 Oct 2026 09:20:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
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
 <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org> <ar-BkhuJINKdNpYC@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar-BkhuJINKdNpYC@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n7ej55akkr7q7ps4rmz1ckk8ftsa3jsu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C188A1C0008
X-HE-Tag: 1791876029-25990
X-HE-Meta: U2FsdGVkX1+AmxF6AoL3hYDlkd4HSYi4QTdyxsoevmYFtruYFVOJkiIBRzWuttumBEWMEpFoHzKZX+vTegnpKv4KLKSQPBBQntvR2imJQzwE6k6FHfRJwTRs8vHkQ4j7HL5ne//tBI9lP/OkFsMb6h3AQAG5jVOFiJZYU1CxVJUeVFKmKbfk2CNh7/9NitOvyBoabB+Sd2k/uEMxrDK6Xe39UItdvYvbhEvVgQGe/+8IxtSoCx1n/z0sPxruCOK4Z5Zvxh1XhPsRhlGPLkFnM6Y/s7J6ouf+yVI5D2sdbL8hnJRy7K0enJNU7S6+CeK6G8RLgnGt+nOmhA86y1lqY79vRfdHc1YUknmhQ7QBZQ466Y9fBdrAgnu3OKUmxpH83wDVJWWayecEH0XThbWyyvo3WFnWaD1/5QoiT36rKylEwSZaSvHWMw63D8VVGDNZHZzUc6Oe5ZD25FVSdMSDb0eB6ytl0YNFicFozDbVjK6B7cTX04gcVOZYMFmbpV1MoR88vAxOMkqp9bBUfbRYPFJjGT3gszKL8A6PUf7+ziu/m5BoxLb4K9dOPfGZxn0sc+pLBySrrCRXkpKrR+gIoUTfII8pYnfL2RRERKrhQBXrlkVpxjHAvYy6pBQ39wnRBQ5BaQ8vkx4iXf+CGN5TOdH1ZLEuanWo7vBledGzldKRv526exSABWEEW2oVVor534Rh19AufhBWDGS3AUFoofqXkIlr8Q6rxwGB/48c+IZWg3uflgR56/89pGklioNkK7e5iVfbehmWcXQ+zLCHxPxWLjGKxT00U8asbJJnqJewtzs13uGHqdAmV747KlSHrtP4kJ0jU+wQl8BUK6eaZIPhJMOB7fXVw20mMIdYP+QkoNrI/WjOKyHVLXM9XJ1wqJjkuF/RBhKl87qGTIC5jrxW3J0zlG3dGlYxseGJYDW1sBvaM14ZMSXvJKHNvBzaj7O57HWY+t/WtsCeAL6
 3kOlm1a7
 1ijRLChj/U/XvmU7qStu9mxYIGlcqYo8WHkpZONKpsy6y4tjOA3y/jWo67Q2cg3jgqI4MbxcZQVDBJDFKbTs2jYWAyuykzBDJYSSq/thjkXPg7/dA+dcR59hUWDKNeEy7/OcCTyUb4ZSCxGD7bpc9dBVq4qMcNLSUZeZqwiDo0uhS5kPdo8Bu6sqtAj1UndY/BlSVtWri391PvZ5vKyuIpsWyGaDoY9H8Jw10kC+/ti3gfYYpVNSQs95sKTRCjtBeh9gkIw3I7+qr+VCz9VZYX2rmA7vCR410yUT9oI7FGqZHg+lQBHxSoK3bYOb6+XguoEjX5xeS4UgMO8B/jqpiduaXIVrxJ4bK0Zej7gD8efvaVq41pXeH4NnsZ9K84sC7n44Zl1vN8uH6jrMbu5xubynhRXEv+Lu+8oHJ90+gGl6VBqjpXGzBMfFl8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 12:07, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 02, 2026 at 12:02:15PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/2/26 10:38, Lorenzo Stoakes (ARM) wrote:
> 
>>> So I'd say somebody from the core team should take over this if we want to
>>> come up with a patch.
>>
>> Yes, I'll take care of it.
> 
> Thanks!
> 
>>>
>>> This looks reasonable but I hate that we have 'special' CoW overrides like
>>> this :)
>>
>> After sending this yesterday, I concluded that we can do this cleaner: just have
>>
>> bool normal_page;
>>
>> (naming suggestions?)
>>
>> that express that this is something refcounted with a struct page, like
>> documented for vm_normal_page().
>>
>> Then we can just refuse all of these.
> 
> Yeah it's all a bit tricky.
> 
> Maybe is_vm_normal_page ?
> 
> Or do we want to default to referring to a folio... but then pfnmap not a
> folio... ugh.
> 
> is_normal?
> 
> With a comment explaining in sense of vm_normal_page/folio()?
> 
> 
>>>
>>> Hmm, if not defined before why would this need a new PUD handler? Do we
>>> even have PUD-leaf PFN mappings?
>>
>> Yes we do. In any case, good for consistency.
> 
> In that case then we should definitely have it!
> 
>>> Since a folio being 'anon' is vague, because we stupidly made 'anon' vague
>>> in general.
>>
>> For folios it's an established term :)
> 
> Yeah, fair enough, that is true.
> 
> And makes the anon folio -> tracked as such in my change consistent end-to-end.
> 
> I guess we have swapbacked for the shmem stuff as a clear delineation too.

The more I look into it, the more complicated it gets.

generic_access_phys() is only used on VM_PFNMAP, so far so good.

Handling CoW anonymous folios is easy, per previous discussion.

What's not so easy is handling when a driver allocates some pages and
remap_pfn_range's them in here. And apparently there are some HV thingies that
can end up in this.

We can try detecting pfn_valid() and refuse accessing them entirely. But that
might refuse some ranges that just happen to have a memmap.

I tried throwing in a page_is_ram() check but that also just has too many corner
cases.

I'll ponder some more about this ...

-- 
Cheers,

David

