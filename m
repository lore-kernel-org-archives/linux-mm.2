Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253A5C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B53B6B00A0; Thu, 10 Sep 2026 06:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CD56B00A1; Thu, 10 Sep 2026 06:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A516B00A2; Thu, 10 Sep 2026 06:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 096876B00A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:30:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14A8580461
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:30:37 +0000 (UTC)
X-FDA: 85197483714.08.795169B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 35D5080006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:30:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WG1UbW4I;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789036235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ueLnRd7dn5jgivlbHsHJ/fNkgLdQd6zLJZB5iL8K/sY=;
	b=VxJtGQdFA4EC5ePD/VT3uF7ZDg2YurBhKcfeTmILN9ONqZueLBNHnHDTlYOwGydeU06QBE
	HtZd0hvfJYGgxC1b9aI94Pf/Nvk3pQIawjEQWPvayrVFltv/u9cXysg09u7fnxcs5P2Ovu
	X3gbyWOCqKO40k1nnbLd0xO2eJB7iNM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789036235;
	b=2k/0/VFq2CvmYdMt4uszCKiZDXNtHWUSg20Twg1OZeN95rL+T5apAUE3OkHuFVoqmufFQm
	mpvxiFbC+WrZ0JhO0DXp06je8/9MrxOxSKv1pA4+/48v8+ryW6yFv4x1X0DMjICryynYX5
	+dvQ2iMxbidIzqxymDaRnNKWUbZMEEM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WG1UbW4I;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EBF541ABB;
	Thu, 10 Sep 2026 10:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6091F000FF;
	Thu, 10 Sep 2026 10:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036234;
	bh=ueLnRd7dn5jgivlbHsHJ/fNkgLdQd6zLJZB5iL8K/sY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WG1UbW4IiSItdXWcH1G2OyV4bRPZp2K4AyAgYX2uyfHBMMhXOWWQ1JldXcdR3yzwC
	 5PwS49PhOXxX7iW2UHsElf+kMUugF7QiHSqMAGcrZjBT5NixQcGj1ijSlpRa0UK2Kj
	 dZMY3LmGNfhaUNoIWK7Yws8TSNtnp+9kmPauBaqMo7a+dSRzDdHVoGysncMiTWjKa2
	 C7m7+csSSUvNmMkJVDCQgmyjG3kNw8WDEHgf8IqLsKOlJ7Wj8+IbN2i/9+DjAXwDmq
	 DP3nNGtFvIDdOdcEHkurRJi1L22x5ZHNSM/bmjYwphBJXN/OMpo1kjnaAtPusLvTdo
	 2qPWFvxTpiXmg==
Message-ID: <5cf58cd3-4b36-4f8b-82c0-c678b0226c60@kernel.org>
Date: Thu, 10 Sep 2026 12:30:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 1/2] selftests/mm: Reject invalid test
 selections before running tests
To: Tianyi Chen <diannaaav@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joel Savitz <jsavitz@redhat.com>
References: <CACGbirTvSoSeNSpMCBiifTdRKKDsKbgk7nfvh=09fHw2b0M4Ew@mail.gmail.com>
 <CACGbirSjNMD1mijDWRp4gLcw-6dJsErrF_jgjwr3nO-geBb1Sw@mail.gmail.com>
 <17f49997-2bca-4e1e-8d58-bc95e25b9a23@kernel.org>
 <CACGbirSm=AZtAVwJAZRZt0JAGGUGVOCUQVqu-EcEiiGC-=+vJA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CACGbirSm=AZtAVwJAZRZt0JAGGUGVOCUQVqu-EcEiiGC-=+vJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: cjg7izswgghgd9is1wzqxw4gy5kxew5f
X-Rspamd-Queue-Id: 35D5080006
X-HE-Tag: 1789036235-237857
X-HE-Meta: U2FsdGVkX1/Zvmeu6Ar+BjfKVLp77iaLTee5Nz1LwwCTqe0iQGCll9KvZB7bLiNKHEoqCoVIUeyRLdNBenAf2hek6El0KExhZyUB8vZD3XojP/DdfSyoQWcwI3zA0DlQ/037CbWUqFHHha3R8W7b/2PyQjA9KgJqPTWqWXJIiIZQKin3fOJJgNVEmXQrtL/e1memgOBDIE3ba0uG4dVUglbXJQ75a+OAMekm4AyV0a+OvE5ORQhjEouvRPta3RXdjyemobxBI8zzDrIl6jbGuhmw8SKE1TMzbNHun0zQXP1s0qfJ4sBpjN+PcL6vgd8UnslAqQontswP2YbJIbVIP+CItfPvpJpzvm7xHY9MKXpryrgc6J7tVnd52GO786cGurNXpXsi2LnTqnqOEDDyTREYzfkf8Qz3Ws2SK0Oypq3mdpHuJSvqkHamEVBbqqN/ZpIURKZER7W6vmzNF9L5dEf73gBRX7YM6zNXllyXOntqYLEjBlFbRjLev/r2ninA/dheGZ9bORZP2SiVoB/LxhKC1zqCzXAproBl0wckRIvecFY2ZP+c8n1gAak2i9oCk2/N9JLueSkkFVkfl03+K2qDaAQqdeilL+6vfxMVWzIo5Drb9IZUmGZS7mgLYyzwOkTon42wgdtq3AdEt9O6IAOcgVk/NnCbHlsiU9OdAfEd8cMOz96LW3FFz/5ffNDQU5V3gg35SDAti2ZS/vJajzrmbWd310UWkTSCo3xIaTchwk/nraqv5c62+Ely4s4N7HAB2op8FVSca2Q8KEW7HS3DfAnWM9tKbQFJBy15bCkiapnXecqrulE+s7tPwHhUti7M24Mww5mn3Qer2LqLhaBRIicsdXcK3t/cBWKzlbNnVZDVELpwvWLHqQ+97hcleM2lvoyYsTvRhwYdoWCyhbrYuK4/uLSers8wC8E1+vmRAInAVSYeVXNym1X64Larz/s/8MMISX1WINmUy0I
 kDC/8AHz
 q3Ki924Jp2zojKHNv2GeHfMjukqPwtoqtpbhaT1+6+yHYKosz8cqonQYDczrFxbJWXbx3JLVKRYmzpxbBCVOQUYu2FMofSvKQhxztLNzWGbCor5Qf0ATMRRCIUlS1Dg8dtIa5D0af5lsqa+rOWitHQYFV0DzB8A9ettafBw8n6mWvK6W3cSemK1DXYgFIRwPquH4Lz2CR0wFmSxs65owO9SmO2rrnxR2IJYeznyToFzlG7rWc/32cRhGnfYlCfQnekI7T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 12:25, Tianyi Chen wrote:
> Hi David,
> 
>> How did you send out the previous revision? Through b4 or git send-mail?
> 
> The v3 sent from hi@tychen.cc on September 8 used git send-email via
> SpaceMail SMTP. The inline Gmail resend on September 9 used Codex's
> Gmail connector. The patches were generated with git format-patch.
> 
> The Gmail Sent copy was intact, but the copy received outside Gmail
> had wrapped diff headers and altered whitespace. The attachments were
> a workaround for that sending path. I agree they are inconvenient for
> review.

Yeah, you have to find a way to fix that. I used to send patches through gmail's
smtp and it never resulted in something like this.

-- 
Cheers,

David

