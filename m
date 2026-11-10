Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767AC606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=APPGUM0V
Received: by kanga.kvack.org (Postfix)
	id A14C66B05BA; Tue, 10 Nov 2026 07:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ECF36B05BB; Tue, 10 Nov 2026 07:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB5E6B05BF; Tue, 10 Nov 2026 07:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F58B6B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:07:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2865A853B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:07:06 +0000 (UTC)
X-FDA: 85419083652.07.2C89A1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 490E240007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:07:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APPGUM0V;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuarVyFrf3apeKzpKie9MDgckTNqUn82BTmZSfLSgZw=;
	b=5ZE/9Ve1iQPksniMSofe/IwwLxExuLMVBHIgpa1u8/9FPN8OUY8CMZLipUQf+z35tfeMh6
	l9GpBj1L3f1s+B+SYEmi/xYRowtH9kS4n0HgJGKh6eD2BykRMONZuLT8dwpaFo1agJuiA3
	+rkuq72w7y3q5KOLxMcoqUPDd+DPfVA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312425;
	b=b5q3DmKzbkOl1yQbVLBLmO/9/0ndOLUaNBzosbw9MFwCEBBwpo2RpZgW2YWhPNNyTt1KFz
	LdFDtjLiNT7cEveOVcxdBmkE2xTuAzpHcHT1U4+6z7diqWVBo8GO2mIefinIzyejLCmbjc
	G7EZEOzKgIXy/90EktbADCltkiMl1zU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APPGUM0V;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D72CF611D6;
	Tue, 10 Nov 2026 12:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15741F008A2;
	Tue, 10 Nov 2026 12:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312424;
	bh=PuarVyFrf3apeKzpKie9MDgckTNqUn82BTmZSfLSgZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=APPGUM0VRVMP52EQNDXONl7QtQWq0CtfrgxucDXbHt/IPGP/j9XmbfbRNo/DU1S2q
	 g/aD5NWCkTTnpLxzt8BhdGOvCubU2Ga6cNg2dy49FRo0O4xvIQxKZVRRahyEq7MUeE
	 jCKCoy+ILpGGlrmRCfAVeg80i30lJcYzV0cmWvhh6wMtPSp2vO0r0/6lO7ulWPGcYB
	 EhiBzH/iDh+jK3cysaB39m46LUbem9MiSHiYQW0Qt7uLzdjqJMJoBy51EqYTfQolId
	 7XGebc3tEnrxp/NX1URUkTvfOQHcq3+wFI3LEKe6o3j/t2uKHfH2INNMP0fkL3DSbW
	 4u7dcDHbqO/Rg==
Message-ID: <e1b0d6b4-f7ec-44df-a9f0-0e3a3722a973@kernel.org>
Date: Tue, 10 Nov 2026 13:06:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: t1tne1ie6ajnfridwpsadrugmr5qx3it
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 490E240007
X-Rspam-User: 
X-HE-Tag: 1794312425-341153
X-HE-Meta: U2FsdGVkX19bH1mtSozodGqZOMw8wYQ7Ol2aJ3T2665FcbXRgQ7yNofhA8jwPpH1je3zezd+05gXh+YCg6z3lxjxvQRpBIBpbnJ1gr9gSTFBe+A/mSfTrQ6znUZAER79nCeqDjPAfOia90QznukZYLBs31nFqaHAmETDqpgztdAgxprTYO2cG6t8yCuGWqfEBHI2Ajm4tTF0OyIKOaqYxpaqnr7i6fMxmoN5Avoqh2Uk6CWdx1yI/uiqfTYGcdw+5tmqBAFlHxlzx2/Chm+KU7Nu4lrY9ga2b+vxUAr1MgdMqpcQGS/xk6L/jClSpKkp2PVMF4mWu80kwIXo0vTYQatqW6bzWYJ0LwTxAjrr0F3v67rSTvN5Z46exi6+s927ZiMS28RKU/eK1R4z8MPOXFC657iKcv4p9Nq2bUdNlbq4HsLeGMfdMqFNBe0tK0gVH7j1RU5R8AbFG+05BJxfD8PI6Uxg6swJdNbLh5nbnFn80LYgYzPr2m/grW52DExoGxhzA6CgPtIvKrfBYFF3JhjsWIhGEU3hDrIs3IqSd3p7Dx5qfn+qfRDUhmNDNu9mENlfdtaXKG5z9YenoVxTjhipbzeLhKzVHK+EkAc3QAA2Jbdz0w21CPD9J4N/7FmfwRoSk0AWEkj3N3vMh0+F7+7+11XMlB/Fa04UVZ+HvxAAjlwvQ+Ub3y9PGOIGnisxYHEUwixx/z/gZNp300uaE6jC22vSB3rwU4y/KWqODjJFwxW7wOF4owKV5r+GH6AEmmcLENiSU9DEBJ4ph1u1/cb/F/3xdsGhHHpaVDJk3LRVCe3QAVo64tdthGBhIQisAV4ZzjLvj+AErUp6l4fATh8OcC4G7RFHX82WVOTZJ+kooLhoI97ghgYItXoS2JH/6AsxuMKWT4bXeMN/ssJpADtEXf70eUODnd3VuX/rs7i3No7sSKnzVxsMRMCMdC368wiFYvZzraXcLXA4Ed4
 x8XRtmmv
 vhQantxtm9E2HuF202qSFT8wKsSc6qY53uES/RrIrozGfx1swjISC6t8cqB0ToqBsYRdkGhj5cWj+FEDqiLlNWJ1m3eTDi4PJPlcMrwQRTiMZ9N0kaMB242E6IPHPHawqpSwntCVUCI/ehE5V+quHvtB68xsp9rMP+/CCIJKdF7yoGw6j9I4+P0/Yhgx/jjqeRUGpX4ynaNVE9VSN6F+1TZ59a8Dr8LmptwPj1y2vW3cMbcMYFsigAeP1uoMgbkOfahRUKCJ3/+I5tKj22S2Pzulbjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 13:03, Lorenzo Stoakes (ARM) wrote:
> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.
> 
> I have separated the patches into areas maintained by David, Andrew, and
> Alice + Danilo, so each can take the patches relevant to the subsystems,
> for convenience.
> 
> Apologies for doing this, but given the current trends I'd like to do
> something to make my inbox a little more manageable :)

Yeah, it's crazy.

Thanks a lot man!

Andrew can just queue the whole series I guess.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

