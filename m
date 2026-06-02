Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB5DECD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C2B6B00AC; Tue,  2 Jun 2026 07:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE696B03D5; Tue,  2 Jun 2026 07:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F253C6B03D8; Tue,  2 Jun 2026 07:31:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E23066B00AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:31:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACA55162D6A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:31:41 +0000 (UTC)
X-FDA: 84834757602.16.DBE6814
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E38688000B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:31:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XbYyeHyr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780399899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNUNOsRsaL4MX9fmPVTaRRjY40XM1Xv/juHezdNL9dA=;
	b=FCkN8TxaqxGqULor7r7GyYWdIjhVMYC3Um2N2+VXCA+RHQ8apQ3IJgKjo/GR2qvIZhh1fH
	jIkKIcibmM7XFpXNkDQ0YX9ND4zsq3arnj8nADdjSK34kXrCKKdTDNbARhkQyxq98k7znK
	zR/Kvb55r4jeeooh3ud/JiOP605sFCs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XbYyeHyr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780399899;
	b=YHQgUr1jI6GfguJizOHRYPo1kAtXJ6D1L/tfW270Pdup2g+vnPO5Uw8EXXG1gajOOUuowf
	QdXNbGQ5ZtQsZk2BQYK/9mjyABnDMqx0ecEBgNhqAv0WdkIDvqc197ot8rAm5BXWb60Gf9
	8H9aZNHkE6KGFMSVx3t3ekz4rR51/w8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DC3B60123;
	Tue,  2 Jun 2026 11:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D2C1F00893;
	Tue,  2 Jun 2026 11:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780399899;
	bh=HNUNOsRsaL4MX9fmPVTaRRjY40XM1Xv/juHezdNL9dA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=XbYyeHyrCADWc2QJj7CfSsM93IQ9SgDVKuLEzy3CVu4SVVcUweAbiZUKzNdo62Ms4
	 vzrZlUtHaIWOQbncDY455ASVwvMOGpMJM1bcIBM6zJbyV0BtUfyN0necCg/w59yxmn
	 VWQsXZa0j04Lrqtimj8udIRNo0qNN7J6N2sgPuzkKufNwEvfW8PS4OvsEjhdEciP6j
	 D5+bu8UQwkUnpSoisJcTFE+JeZ35gh+fIbwt6PvBvbUvCzwNRvlJGa4MnTRk025RQa
	 BERZy8cEcAPdWeSGMkOgwnw3abmYgTzmQ7stxfOIM6qxkdBIvabOqfwcNPaHIDvjYL
	 pomYTpX/r90DA==
Message-ID: <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
Date: Tue, 2 Jun 2026 13:31:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org> <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org> <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E38688000B
X-Rspam-User: 
X-Stat-Signature: 31np4mabhgemihjhtssquqzhdqwkd4oq
X-Rspamd-Server: rspam09
X-HE-Tag: 1780399899-468156
X-HE-Meta: U2FsdGVkX19MOivdb+AsfXxhtAVH3xEy2X+1dQA2FyzGzi1I5DS5hLLQpjUQWpNi2d9841lgioNbfAhtbg60rxCLoMsqj7EVCd2skrq9CmKum1PTxftqDe4o4k4YhxmeRZDrhgt+8OswNFkmegEF8OKpoygxGAottHtb4vdhysIWXe2cqDZu1hM+BQ7ikJhP107vCk1nx/6hSv5nWZL8NsQFDHVNISliYcDYZtxC7kGxaxHqnPxRR3zqCkU0fCVsqCmvobiDXMxW/VLKT4w6oYB4ohFFV4qzgxblzGGJpDmrfghanj6sQlHm03OLoKEDz5cTjNyYEUA5wtouMqWq69PABXng1yycLXNGMBN6DvAx5jswRMXCDqMnNwi7pmYUXCYR8ch124KLzhcTpJTwMtN9l1C0Owf6GdL50ttPi1oyVWdUWCYvr52WWI2InO6xrqVWi9lRE8kjRgcmOF03lGsCz2wOptp/amXVYj4zBXfu91UnuoX2eER7zlaS8KKYDfcyuK++lbcbh+S04G+MuB0a8hqPYzf3JdZ2Of+Z9YiIAj89E1Pb4qfbrCCcERw/KbuL9kkTm9JdtTv0Mqup2pCSgNswZzjesLCdEA7TXTJXakclSOpfcknGkfh3wmZynvZlod3J+Ck6EaHN7RSTyommFLD8Bjvye1quAbshilvw/n99iJfD06SS54t64rFqjo7PoeJMO5SmuWYKmvb95AVHPTtNCGWp6Ne5MJ0fBKOJ16cUdpKHpuM2dKj78alI3hJG6uLX2s9WidJ7lpP1KM8tJx38WxbQm1r5q9AAiv2I/wWbqlZ07iQrQwYIPj7Ht9fHMelw2JhfQH7GWGckk244USd5QdaKOZZWUxMI8+s6TPr7UZmgURmBhArJlyV3LB2t+1BLHiOBOqrSwhxP2sI/KmT0a6HmaZLPcScu/8RA0976bUtIUUQmz26RUj7DPqv7zEVWwkhTnfXFbJ2
 TTN7ZH33
 sfXwzyd48gZi8K8tEyQhLVeIz4hYE5RtYAj1wnSopLIA/GpFp55GatKEho//ogvY91xDAmdVZLJV+wquQjMFTfyqmF1emXfSi110xkgTXbPH35hu0Wq2Ag4PDl1T7GbMymO+ZF8GFAB9J4FTXyhD+fLAzFVDbhotH/RFT7KkuBSIfI7UPJH2JhuYE9Mw7itM9wA3BeFieZpPTMYfxx1H4C9dIkEyGFlG11cJ1Tde339ncp+/CQxLreVMFoHSr55U+62126n573YagGymfCiocj6tz/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> learn from obviously) against how mm works in practice.
>>
>> High review load with many overlapping changes might favour a different approach
>> to a subsystem that looks different from that.
> Yeah, but as we said, we discussed, it's all rather complicated and we should
> move incrementally.
> 

Starting to read Documentation/process/maintainer-tip.rst, it's very interesting:

“The tip tree is both a direct development tree and and an aggregation tree for
several sub-maintainer trees.”

“In general, development against the head of the tip tree master branch is fine,
but for the subsystems which are maintained separately, have their own git tree
and are only aggregated into the tip tree, development should take place against
the relevant subsystem tree or branch.”

“Bug fixes which target mainline should always be applicable against the
mainline kernel tree. Potential conflicts against changes which are already
queued in the tip tree are handled by the maintainers.”


So, yeah, let me reach out to understand what works, what doesn't work, and how
it works :)

-- 
Cheers,

David

