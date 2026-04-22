Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA44CFA1FC7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8186B008A; Wed, 22 Apr 2026 11:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558746B008C; Wed, 22 Apr 2026 11:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421926B0092; Wed, 22 Apr 2026 11:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7E16B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:50:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F26C31A022A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:50:47 +0000 (UTC)
X-FDA: 84686629734.07.2507595
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4EC2CA0008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:50:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=enPaOMzz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776873046; a=rsa-sha256;
	cv=none;
	b=iZ0SgxeTSOv2y10xH41oXWM1Ka22dcWVRB7aQpUnQ8y8ZrWGRK0D9DYUMsUBEvBy1/RFTI
	+l0Fv79Ph78BOb9/IPE4USXCiRmeARY4Udo5unBLD2sciNDS2FDYy2lLS8mqu0HnDt/p2p
	LBV99NqLREE71rIafRu+gYxYE+B7Wro=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=enPaOMzz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776873046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFW0k7S8LcNOx9yjNfzcLsyTN3KSTSY1sVmamktPkkI=;
	b=CHdFzIlivZyalA/ZDvnfH0J4S1Cl9bofaWj1cR5c/F+TsQj51usm3cmlfJDPFwD7HlA2yP
	TSmJomsct4PrkgJXzFPRQnmH6j+sBqQaAq/tCuhV2X0DDFfIgpYmx7oNe4we5JudnR8K6z
	L2yas75CiACgmh4V4P5JgUhH1WJv6fQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 83E0560128;
	Wed, 22 Apr 2026 15:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CABC2BCB4;
	Wed, 22 Apr 2026 15:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776873045;
	bh=FpsxQZvjVjd9Akt2HBKxJZNBDYIwr4Pi2TKkjE5Tlz4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=enPaOMzziCmx6sr2LApjufNywy31WK/vha4S3YkkiF/0etI/sirJrRIEOLwClzd1H
	 O2v51rMmm402y+uRLj8NnGOHQP8WC8l4f4RC913duPj3OS6gbQOEN5OAeIY8LEHr2f
	 fUOx/MPLQdppyJqTQmNX2qLAfqJ6Kpb2sZQyYdi6/IvuUnuTeEM3pJp0XJSBRbfZTP
	 O9+03Xys4uAEOU3bs24NB63O+tX0bvzm4dty3AmY8tjUo1UywPR3ml77bSbN6kUQOa
	 11CtWaLhvKLrfAzVhEFwhfYCOeKgEK0Xg90Xr32wBioPtJTl56QUBDa/jlgLX98vFE
	 kr+BqycHO6Ehg==
Message-ID: <924eb446-10b3-4167-84ff-289efed03388@kernel.org>
Date: Wed, 22 Apr 2026 17:50:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] WARNING in workingset_activation triggered by KVM page
 fault path on Linux 7.0.0-08391-g1d51b370a0f8
To: Sean Christopherson <seanjc@google.com>
Cc: Zw Tang <shicenci@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <CAPHJ_VJGTsRDc7_Kv0oDObuDX2pJ0evcAvH-mnD_RYMX536+mw@mail.gmail.com>
 <e48748ff-0fcd-4561-9958-124dd853e70a@kernel.org>
 <PS1PPF7E1D7501FEA2B54606827E0DE1805AB2D2@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <CAPHJ_VKsVzyYzZ5ZnBkNbYLEMXDYL5x+7jfyUxhcwT1j4zPXOw@mail.gmail.com>
 <CAPHJ_V+L92DxzEB=4+Tj+C8MNBW7LM35xWYXAoLhHqU5p2nxfg@mail.gmail.com>
 <177d0a41-5267-41f3-bc77-415b756ea4bb@kernel.org>
 <aejGuMRQjeEEH-V3@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aejGuMRQjeEEH-V3@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4EC2CA0008
X-Rspamd-Server: rspam12
X-Stat-Signature: ewyudqreyd1b6s546wkexn88gekufx14
X-Rspam-User: 
X-HE-Tag: 1776873046-737455
X-HE-Meta: U2FsdGVkX19jLU7pX/ug+uutjzqB5x4KbKFUVADNtRrh1VEYDlup8If2zoTlv+BDM2GEp3xzytHK5fER34ZFKFLvUrgNkAwMtbBAHo2om9vcZica6XgiUPJIzCZpzm5QHjZ6w9Q+PjtX/aEhZD6/MPtfvIrvGhJ1QZj4c1YwjZ50G6NJlMV3DO0taf8311WYX8Njh3v+T64D7uwARlSbX668zwC5NRTf4CxCSjy8swWZMrqzzdAPef3Rc1kxGBdF3l9QTkDardjKl+6wUpgVTgfVGFrhITCrSoaAROejzA30gKjGAAgiHkbdEYYg+RFZAsR0djpBToFwUSdODQKQs5mL+tWzA6fk2Kp91KYgVsAczm0sSyTytnUi6L50yYrILOaFe5Mf1NuYLbO036ZgV84h1gcZjuZAiGjgiqZYkQ7GdlSpsF56XQrwKu2aMvhfeg2LyTjZPpYomSWB/SSng7kOxlkbzDqKyisHhHKwXQOPusIkQ5MxhRP4fRRw4qG85EmuZxP/DDl1ry7VkTu/y0lH+Y0hTt56OIqsJsblBbeEXvmR9urQZFgTbNuyBfV5cgQeJIFbo6kXSkMELe2EzlTZHUqJ3W+w1zztRSw/V9sFTgKVAndqH6q+PqgCZ2RMpS9b5GgTjgkmPGVx38POQz76V0250FhE5TZaS1aZ35PMelNkddOOHOL/iFZMsukfdvPVoJBe7l8jKio77Knu18SDZkzvQALJ0Xe/H7A9BN6Q5jMsL/dwpnisVgPDpiAHhU4zejKM+1KvNuNyc2MnHANqSQHFpQMN2IGEOfDLTyP+xkO0vh+p4Qwr81x2l39ogKG4ICvYsiE+HOkia4GIpf6zFaSGa96CBt83wQozd2pwXEKKyRrLSp0orYx5uzLEfNtJBdbJ+Uajpk267DRUujCxGUp/Jt3Zf+3vJL/5HCEaAslcdhAgwVfKQSnYN6AVAnN/Qs3mDC3Pv5k22hH
 ylleWn/W
 apmk5rMMv0e9WB8P4hmMxWtTnIt4XyazdhqTlUkAHQwLSH9KzXp33mtqUXYEkahATYQVa5/dwrfzG7Ot8FWkeMjG8ZQDC/+vmgo+mKoKnvvTRCDBRVpcOa8Bg6PihXMs5yamAs5EkKsEqIjakrhD2Hncap4R+L41PxoBNYbyLqtes0GBNmisMiZPNf51VIDdT/jM+071Lyv45M5cqT6n5laz4WGEo/PUdpErPPOESFp5pE/rIWtoHRAkJzQDdfHyAxTcQWpExiD0iYLS5ElOu0rbroJ330CsyZ91Ll3B5xZ14uh2K1eTAs5gKayN579an0UT/DZWxNJ3VGbf3NckMch7ag4vt1cggNs4A9au2IGVajfU5gkKxV5Rbdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 15:01, Sean Christopherson wrote:
> On Wed, Apr 22, 2026, David Hildenbrand (Arm) wrote:
>> On 4/22/26 04:06, Zw Tang wrote:
>>> Hi David,
>>>
>>> Thanks for pointing this out.
>>>
>>> You are right. The commit id I sent was incorrect. I mistakenly used the
>>> git describe-style suffix g1d51b370a0f8, but the actual git commit is:
>>>
>>> 1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2
>>>
>>> The short commit id is:
>>>
>>> 1d51b370a0f8
>>>
>>> Sorry for the confusion.
>>>
>>> I am also re-checking whether the kernel image was built from a clean tree
>>> and whether there were any local modifications when the crash was reproduced,
>>> so that the reported source line numbers match the exact build.
>>
>> Okay, on that tree include/linux/memcontrol.h:381 points at
>>
>> 	lockdep_assert_once(rcu_read_lock_held() ||
>> 	lockdep_is_held(&cgroup_mutex));
>>
>> lockdep_is_held() would not trigger a warning like that IIRC, but
>>
>> lockdep_assert_once() does
>>
>> 	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
>>
>>
>> So likely we are calling obj_cgroup_memcg() without the RCU read lock held?
>>
>>
>> kvm_release_page_clean()->kvm_set_page_accessed()->mark_page_accessed()->folio_mark_accessed()->workingset_activation()
>>
>> ... grabs the RCU lock, though, before calling
>>
>> 	rcu_read_lock();
>> 	workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
>> 	rcu_read_unlock();
> 
> No?  Since commit 906c38ff52e9 ("memcg: workingset: remove folio_memcg_rcu usage"),
> I see:

Yeah, I used git show show
1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2:include/linux/memcontrol.h to look at
the file but then explored the other code without a checkout, ugh.

> 
> void workingset_activation(struct folio *folio)
> {
> 	/*
> 	 * Filter non-memcg pages here, e.g. unmap can call
> 	 * mark_page_accessed() on VDSO pages.
> 	 */
> 	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
> 		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
> }
> 
> But for the life of me, I can't figure out how obj_cgroup_memcg() is being reached,
> and I haven't been able to reproduce the splat to add instrumentation (though I
> haven't tried very hard).

folio_lruvec() does a folio_memcg(folio) that does a obj_cgroup_memcg() for
folio_memcg_kmem().

So the page was charged through __memcg_kmem_charge_page() by passing
__GFP_ACCOUNT to the kernel.

So this is likely not some ordinary folio?

-- 
Cheers,

David

