Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B27109C05C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D266B0088; Wed, 25 Mar 2026 16:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E226B0089; Wed, 25 Mar 2026 16:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C9E6B008A; Wed, 25 Mar 2026 16:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD8796B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:16:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06F94C3401
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:16:22 +0000 (UTC)
X-FDA: 84585692604.23.A0FF122
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0452B40012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:16:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=miCe2Rm2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774469780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLI3kY4b01P6sC03dHAC8BFRn99to8RSGZWfbYZWhYw=;
	b=5GRevLuPvEirXoaKHfuAQ8+VF6wAwna08aBl2Mk8I5unaFQhI9eMyGuHSwBExLrroPFrcm
	ve82j1DwGBG3l+xmqBvztdo9isU8tepqIYJTUIacjDIw7b4bjz7vCFV1qOz90FPhB6IFB5
	LUEduHRlSCbKfWXOxKxBXaaKbRr1wJ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774469780; a=rsa-sha256;
	cv=none;
	b=P4kU05hVb2DB/0WYCeVIf/fQaudYR02Pwmk0xaF5R84mAdCtBcarj2YER+szYrkIXx0tlt
	o0ag7aQ7hk05dpn0+OQVBGVCp7Zzf4Hxteztrnq6ux1LMVZeWFV1DAlF2G5h5APun0swDY
	dVd22WP+1spz94EbE1fvWXrKCwSmnPo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=miCe2Rm2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D920444083;
	Wed, 25 Mar 2026 20:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF2AC4CEF7;
	Wed, 25 Mar 2026 20:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774469778;
	bh=rFAsBdkS38JaIUc3v8CGQGdbPq1K1LUFGRI0fnZPiUI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=miCe2Rm26YEoY+kPi0GFfzPBNNk8oSNkoMIB6ge7VR03DPTfWLAuAyFYW8X5itH7f
	 3EyqMblXp90cAvPuX5OSgget6WTJYXbiSo0VT/GssuK3Ysro2vGLsi4U4oVeXUDNjo
	 V/9sb/93ng0Rw016QSkgvrKyEkqeomVid9HGa5+5Y7Keyu+UIFaQfwULZfmbYlKIkx
	 dftK9hkXRurG/k6tOkdByotJsDmrX8tNGhO6a+BNHH/gRPRr8WUQiQrD6q/4z7i7JD
	 fExHmH2Qomgx1IZOHEephJOLqXFHItiCEkBE+DT2h2eJ1tBk3euUqIfbaAYol1dz5G
	 tvLzZGJo+1kmg==
Message-ID: <93f3be43-0883-4fde-86c2-a35f8a9c999c@kernel.org>
Date: Wed, 25 Mar 2026 21:16:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
 <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
 <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
 <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
 <20260325091735.bf440358cf83c5d0369e0674@linux-foundation.org>
 <06c83e1b-d7ee-48d5-a5c4-faad39db2f53@lucifer.local>
 <20260325113650.fc6997e07a0a4ad0e46278d5@linux-foundation.org>
 <bddac979-24d2-441e-9c5e-529ca2f58366@lucifer.local>
 <20260325121549.2b887a8a8c154d5bf8529ea9@linux-foundation.org>
 <9930979b-7bab-430b-ad29-fb35f36712b6@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9930979b-7bab-430b-ad29-fb35f36712b6@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0452B40012
X-Stat-Signature: zfkth3auqrcpzzaxrkozsc9ahm8j6wex
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774469779-467659
X-HE-Meta: U2FsdGVkX1/wnRlYrB1O1KpuSWzNASvyHOiYxlic87KaH7xdeNB1D3vcd4ko/6oGUAdk1ORgmeJNdhFrv8V/snUYOTl0FVC+y7A2F+Kp+wjm3hRNBXuKnoHeMraJZxG/SBalgIc/8YiGiwLta559SCf3EojLls2Y6BfVD6jNtrJJp+8Drql/i1m70Wc3VUs6DMQ2snaVKGNZgbEexNSupbYgNfc4sv6zf7Mrkojrr7ylMx1McnpguEjFyUIAXmGHu11yv6OAnZ17wfURmqVXEq+lC4H8ln7+2rhxL/YbjBFjraxB5UwOlzWZpBKU8G7m9Idz+7OUdaVG0Ew+XjC2TS+ushQuU8j1aU4ZH4M1UD7aFuQjVOQD/MEW3VFKZIgF9JnCvIVbPHrmJOzj5C+hgKPhGnHQTyRs43Zbn2CluA/IyLsySuvOfS4Pqdy4ZmNI/N3mIygS3DcTUNU8Wjgq4yTCpFSv7aF1/YXlwAo7PN8yF2gS4LcOae/mHmpZb5gSIYUQj4JIFIEHHiC56CiYlurdNht1E4lxQDqBEHO/prLTFYhMoDAY18wAmyywJH7LtE51KPKO1oKKIbM28P8uTi3Blpy78F04/7s5m/mB2vDejK2Hf+Z7Wdd4l223dTla9UwU3X6jnO9ZBvYXBFdsGlsPxdEK8ck4wsmRW8//GsVswCrdKzQI88RNrWsETCbYpHYocuiJgUCU9BiFICLJovGy5Ig7f5l10/Bb3OZvHC18fv4CGWAdgHVMtn32pFAZGX06CY5UM3TP3JktQfSL1W9tN8ncSpAJTAC5xItAACRM+Qm/xDM8g1ygRFobQE77oGwYajGXD+ozkLfs+TBdEO360TQ8HENqC86TL6rx9BhXAVthVksFaW+dMvz7G8ZjrF28sdJChfdF4dBX2b+Y5hZSqOG9B3c9VBBYexj0XcYfG6HBsHWT5UantxfOHjnLwCezWQVnJ283KR33t8B
 vWpYndfA
 rEYqfnW8eUpd2S3XJAgwYZ2TEQL5uzDiRfU2lTVL4DB8zvyMS09wK9aOlviyv77Qw/pfc9M1d0mgvHIdVPXHiE7s9ikyQ1Gt1xy9Lg0LjydfuNpawTFt0/3WCnBkPgjjA1dmNOc6JsLS5lsmOnyFsG0vL8MbsEEjCIUAFVD70L/kKn2Ve3cpgTCi3iGQBbYnDC51IOMiGgMmQqLJVVd7nsP2UTehKTENvgF0DYlbgkmzUbUhA7SddTohDpoH7qPQc5OF5vEGyNaley5K0sRY50iOCeiBhu8kvnzagQ1nexYOUHfr2RHkeJZxJ8d98+44OfOKcjboeRHo4KCeu1ajnpGyXiIDWQ9apZDMy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 21:03, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 25, 2026 at 12:15:49PM -0700, Andrew Morton wrote:
>> On Wed, 25 Mar 2026 18:53:40 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>>
>>>
>>> I mean instead of having a separate commit for the fix, put that fix into the
>>> patch before it and denote it with a footer as you put above.
>>>
>>> I guess that translates to what you do when you rebase and fold the fixes into
>>> commits as you do now anyway.
>>>
>>> I don't see any reason not to do that right away, as really it's good to see the
>>> combined change in one go for all practical purposes (if I resend, I'll be
>>> combining work, if I can grab it from the tree and avoid a git rebase -i all the
>>> better).
>>
>> OK.  So what have we concluded here?
>>
>> Is it: if I get a -fix, I add that in the usual way, then temporarily
>> fold it into the base patch and mail the result out for fyi.  Then
>> after <period> I permanently fold the fix into the base and add the
>> footer?
>>
>> If so, what's <period>?
> 
> To me it feels like that should be 0, just squash it in right away, since the
> trees are being rebased constantly right?
> 
> And that means the tree contains exactly what it would if the series were
> re-sent.
> 
> David, what do you think?

How often was it helpful that a fixup patch would stay separate? I would
assume "not often". :)

-- 
Cheers,

David

