Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F400CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668F16B0099; Fri, 16 Oct 2026 03:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2546B009B; Fri, 16 Oct 2026 03:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA9C6B009D; Fri, 16 Oct 2026 03:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 221506B0099
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:56:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25EA4160376
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:56:43 +0000 (UTC)
X-FDA: 85327732686.20.AF851A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 51ABC100004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:56:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAIzt0c2;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792137401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7jok6tijrYfAllmO1S219tub706HGJDWNQWrp1UMio=;
	b=QxW85bsLdqW5almfqVqJKjqiIIX5ESDKrAICp3dfmP6jM1QYJgN2TwF3mLh1teViVKuyp2
	wAQlvrkrz0VgEniyT3b4y5hN+UxTNOrYEeKqrTwXZ1bcgtNB1uU3dTRDTKv+CAgXysTpAd
	aUK53SRXd4mZXiIKaQ+oFF4HkPu0nW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792137401;
	b=d8m0vBYLNFNkfONxmI3IdmvZcxvgjjCAgrwFy3QMLoNF/nPAUCWrVXDBatBSscgO9g4UMu
	713irgtAofPMMK4BD5T20EHPjtcE3jM19xFsjsCOryzd0Y+KMT5+MZsvUoF6tuMmH7odax
	sDo5D527AuEXfDCnHUkWsGOjZBYHiRs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAIzt0c2;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8624C42E72;
	Fri, 16 Oct 2026 07:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8494C1F000C4;
	Fri, 16 Oct 2026 07:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792137400;
	bh=i7jok6tijrYfAllmO1S219tub706HGJDWNQWrp1UMio=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JAIzt0c2CokC4BOEofYJLCKElMuCDowD6Mbv5/Tg4KcV48VgzucVIUp7HesN6stpN
	 wQRrgoBbPnWLhDe8ehwZoY2DHb4nmLgGCt4/SZNDXPQuk9T4X/pEpnyKI8R1tSkMAI
	 CSuTgLfuBvREWuakZb1Vv/40Cj1qp0rVNtAerPnH+pgRvPg/PSh9YDh3dGYNpdg33N
	 w6N/LmYUUqR6LgiAzT6+AOw5vh8zy/A58HQOZ5+fMVFqwmuRfCJZrwmDijmDVFLn4W
	 MMI9Ya6V2kXgNMaGCQXIKaR72dhoot8i5tiI5KE5IRgRydw3fbQK2kM6GdE49WON6U
	 9Q3Yr02c9Q+LA==
Message-ID: <97dcba80-40bb-4b2c-a8bb-8a98b82e7d2a@kernel.org>
Date: Fri, 16 Oct 2026 09:56:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Sashiko change proposal
To: Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, ackerleytng@google.com,
 akpm@linux-foundation.org, chriscli@google.com, hannes@cmpxchg.org,
 harry@kernel.org, jack@suse.cz, liam@infradead.org, muchun.song@linux.dev,
 shakeelb@meta.com, ziy@nvidia.com, "Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, SeongJae Park <sj@kernel.org>
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
 <CAO9r8zM_TfD82vZ23zwsd_pPLMpe11_XQhPEp5NDyhoPKDizag@mail.gmail.com>
 <7ia4bj8ufqlw.fsf@castle.c.googlers.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7ia4bj8ufqlw.fsf@castle.c.googlers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51ABC100004
X-Rspam-User: 
X-Stat-Signature: rm4fb9kyr33qyyjzihg1taj6ymdipu67
X-HE-Tag: 1792137401-309622
X-HE-Meta: U2FsdGVkX1/HCBzNQEEqUgX/VvkHNKotospzpQOnN2hN4dIiL6EJ6lsD3yiZ9dM2T3RAqflAagM4eRNMF2yhSTaf/aQq/0i0qCtVQ24ma0TmZBFjoTiz47Pek/CwqVukFM5fcfx+3VuwWNm8TboBvlmrvxLvyhPdFSUo9dvGXq0WQpTqjejUERTblhn5mQLp21yRHaxBOjmNNW29Up+cMsEcI6Ix7b8uVATZ2eeREDNpXxzLXSqdnjBjENmORrlJ0zXYIe6l1FTuxDf+cuPWV2jSP/ey90KeKuAip++5WZMADog644a8mlody8xwEbTFKEuqGT5WPcBV/AungjwEAMMXUVBQp70lSrbUSemF4/nvpYRMp9F1KLUXdXlhQTJYS4cIWDfS/6MCh2J/ctHj4YVX1dsLCEPf++LbqFJF//uwFZy3JcfYlU9mAC2O3wfFX3MdeS88dckKMnC0os9ssLcP3vgcBPfUCaOl8q3CCZ1KJzHWnKmwwTUMgJQLc/qvPzNxr54hrgr5YrvB2rvfjZnwEiiR2zN1lceOpfrV4K6pdjq9DjAZ4keF9IB6LcSLmFs98GuzhmzY4A/5ep/EmoL3keWlEdWZeWlrAa6PJKiZwlvDwkbpId6n9NUEv4of2HG1BdTSBR+BcG6iqf6hXNCo8t9e+vNLNCRw1+Y97OBnFE+nxabWYoy6Y/fKwlKjn5RElnLR+yYc91YpP39jSY+Jq8j7iN82mMnOR82hx1p3WKyiK/SNR2FV4KUqHibDXj94y7r6PK+iGs4g16JO/5EkVMjdJ6BpsbDy1h++EcWrwWatSSEN6OjujMmKsYU7M4a2DcsWILHA2ldka8wMVmgUgn4LCQmfQZDCNmclOzpTAsBh4hCD5Eowl7aFoYMFv6CyvnFq1GYPdjUsni5yTACSzKeaGlW2r2lS6qyAvYiryHQD7IzudXHkii2hB2zomsslbHCMP4vdnVdPuTO
 A4UePFYQ
 CKA0XA9B1bCcBZQCVtMDagO1rjyGm9WnP495R8YzNrUGSDYV06oiSDKahkok37YZsFkEtAaKpLAPDFQLwB1TXsf+Lt3We1ypfqdMmOpsE3XlMWdx48JSKABADS6kho3Yw6kDTksPNoAMfAPnqevSY/lsmkoQuxpeyt8sxgK37SaWwDp/VHSNYBGJeSSCfjKTjCTK3/4yMhNfKXCk24SNcroGq8mQlEd7jFD5GM1ft5iTjlGo1gtetduXd9xB1zwJ+Nr/9jnAISQMHMjZw84yUqDNn8dtWcLkEEUkV8+rTDJ7Atn0zfVS20r4icDif/bhbYmwqwXf1kWYItH9munJTcIFj/y2sndjdXElgVaupSkCcdB7ik2PRba0FM4vlsddIEWl3x6ugrbYhu0zT3T/itMS2dpD+s67gLuRYx2OiaDdrmCrZcgK9aNLxeOQmIArdfDW3TRWFLrlYgGC+03Tfk/Gs4Yd+Oxrhl6zy/ElNZXTs2jwU7owJTXMGVNz5O3VIv5xrgzNlfaw9/weHNHwFafRgUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 02:15, Roman Gushchin wrote:
> Yosry Ahmed <yosry@kernel.org> writes:
> 
>> On Thu, Oct 15, 2026 at 1:38 AM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>> (CCing all people attending the mm-next call)
>>>
>>> Hi,
>>>
>>> After talking to Roman at MS, he just informed me that sashiko now has a new
>>> feature combination:
>>> - "embargo_hours": hours before review is public + emails sent
>>> - Mechanism for signed-in maintainers to lift embargo immediately
>>>
>>> That solves the key issue I had with sashiko: people/agents re-spinning stuff
>>> too fast before a human at least had the chance to jump in first.
>>>
>>> I suggest the following sashiko change for linux-mm:
>>>
>>> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_lists.toml
>>> index a9198de..ba123da 100644
>>> --- a/projects/linux/mailing_lists.toml
>>> +++ b/projects/linux/mailing_lists.toml
>>> @@ -46,7 +46,6 @@ ignored_emails = ["patchwork@emeril.freedesktop.org"]
>>>  ["linux-integrity@vger.kernel.org"]
>>>  ["linux-kernel@vger.kernel.org"]
>>>  ["linux-kselftest@vger.kernel.org"]
>>> -["linux-mm@kvack.org"]
>>>  ["linux-nvme@lists.infradead.org"]
>>>  ["linux-omap@vger.kernel.org"]
>>>  ["linux-pm@vger.kernel.org"]
>>> @@ -315,3 +314,7 @@ reply_to = ["author", "list", "recipients"]
>>>
>>>  ["fsverity@lists.linux.dev"]
>>>  reply_to = ["author", "list", "recipients"]
>>> +
>>> +["linux-mm@kvack.org"]
>>> +reply_to = ["author", "list", "recipients"]
>>> +embargo_hours = 24
>>>
>>>
>>> Which means:
>>> - Embargo 24h
>>> - Mails sent to everybody (author, list, CC list)
>>> - No positive-review ("looks great") mails (default)
>>> - No other static email addresses that receive a copy (default)
>>> - No additional ignored author email addresses (default)
>>>
>>> I'd say we start with 24h and see how it goes.
>>>
>>> Thoughts?
>>
>> Thanks for doing this, it's much more convenient to notice and respond
>> to the review when Sashiko replies to the patches.
>>
>> FWIW, I prefer no 24hr embargo, seems to work well on the KVM side --
>> but I will take what I can get :P
>>
>> Reviewed-by: Yosry Ahmed <yosry@kernel.org>
> 
> Is it time for me to pick up the change? David, I'll let you decide when
> the discussion is done or just send me a PR, up to you.

I was under the assumption that I would have to open a PR on github, but if you
could just perform the change yourself, that would be great.

I don't think there is any pushback right now, and we can always adjust if we
realize this doesn't work the way we wanted to.

-- 
Cheers,

David

