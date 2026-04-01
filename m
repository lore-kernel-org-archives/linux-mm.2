Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A327D35162
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04F26B0005; Wed,  1 Apr 2026 07:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5E86B0089; Wed,  1 Apr 2026 07:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA43B6B008A; Wed,  1 Apr 2026 07:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7FF56B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:44:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71302C824C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:44:11 +0000 (UTC)
X-FDA: 84609803502.02.9B806D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id AFF461C0010
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:44:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZhhKWKGq;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775043849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KD83ixe/9jQudpl5TkruYmMF2VzbUhxEqjpMh8hd7vc=;
	b=PiLL/x5+D1PSMUbeVFy34ogcH9E/m2lF4mzeLM8LFw5Gzu/rpoKvtkkA/H54jxhx/+Xgff
	uL7Fg7Ve6xAe1boo6C+LSHCvd/QJl+6RCW1rfyjWLV7M7wuEIuX7kB64t2YYGoZwC/7Vir
	FEorEV14ri7Hnr3U6Xa0/2R/SQupQXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775043849; a=rsa-sha256;
	cv=none;
	b=FN46UQ9LawASjKsu6NdRRYrlxh+egVLWNqUW2Vu1n2mANva4MtNYDFzVk4XyF0twJc3io9
	A1txYwI5NKK6QsCgPc5Y3JzUrhmb7cCibkbTLYRSMl0qpHmoCC/g0reQvRazakqX+R5iC5
	ZxxQJbR2gFVgzOJSP17HzY6pozZO0R8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZhhKWKGq;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 159296015B;
	Wed,  1 Apr 2026 11:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48105C4CEF7;
	Wed,  1 Apr 2026 11:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775043848;
	bh=5GD34RXSFd+PQcsu6J2KYlj34idhG3YLrpo0SJh7nzk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZhhKWKGqWUtuOBDeH7oA0rfLDmGkgDsLv7fBxLxGXnNIbEcrifQSx8LETFGbJ5X0/
	 gf0kMkKiY04hLQEI2ucwl49W6Lf3mk7zDOTJLUQ+vK+AcDluDjCOLzJd5xtEpuRnaT
	 VOZ04g6jOiN+bL7Ntwov5C34FuHjIfM+7m5QVVGE/Euel9wEENfi/tZvBsKZ1iXhIt
	 328cSJBVrfv5ibVOg0u8dPiN0kUhW5nF+cBeIoDve4sjz8NWfpsgXxf806GZ3HhOpt
	 0Es/Qddg+c/HgbKACLeWH8X6k9M3hI86ZsAWMGgdokCarKannev+SXA+S+Xcle5dpd
	 TvsOC04bE4PjA==
Message-ID: <70576b00-6210-4eec-aeb8-69a74cca27d1@kernel.org>
Date: Wed, 1 Apr 2026 13:44:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
To: Lance Yang <lance.yang@linux.dev>
Cc: kartikey406@gmail.com, usama.arif@linux.dev, Liam.Howlett@oracle.com,
 ziy@nvidia.com, syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com
References: <38a347dc-8a1c-4d04-926d-7a6318e93ca2@kernel.org>
 <20260401113434.29369-1-lance.yang@linux.dev>
 <cc8a2d06-c774-48d4-af8a-905126dbd588@kernel.org>
 <7176f8a2-8830-4fe9-b00e-fae67e2ac81d@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7176f8a2-8830-4fe9-b00e-fae67e2ac81d@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: xrdaz48r75pba4deww3g95uwcy7u3qth
X-Rspamd-Queue-Id: AFF461C0010
X-Rspam-User: 
X-HE-Tag: 1775043849-516618
X-HE-Meta: U2FsdGVkX1/032E/Qh6i6AcEB4oqnyxbC7zLxxKSzz4H9mcG6pdvGfA8SSdDR1wiMaaBsD4SnotjCSlNDfG6SDQsp3koswPdjl8z9udw0YZJ6Hg50KICQTVTliV4kHraLRI5tcjS1kn3yD63Gknd0AhI1OZhuhJ3KyY/HXdOeZk5t9V5XWU5g64HAGJBWLi7yp57RNKd+qK8bqtvQeT0DSrDgTP3/1TMSpVuK4kurQ1vGR3WbrLV3RMnGvQTllNjnDBpDYCv8kixq3VnqQxuir6gYbHshEsCdYWoI5t0JBFbfXxIP7+apmdJ9qbcszN4t2777BMHxYCfCuPFEmOBR6McD750WeNHHPexYOafDRuE0MFvSAGeMa4uTVxeCDI8640EkW6miMQSlJSsE5n9Op6OJBkhE6RdqfxfBUi5aCXGDlAgH/BesiFQ2LqLmvUlw/zC2sN696hR5B8t6RV+FBR77mB0yfP1v+MszBQspK4wxx+jxUDi2aUVJqdklJi3zjAQMBDQZkAAhhzn1qmjtKHdEDS8I7jkipp64ZhmCy8xsfAMkSxi7ae6AdyCt3+mGymPi+X9r+Zr4xCajRSn6nZWwZQjReMB8qmLYGV8nzlc3VA+HXPQdo9SCx8yojeACkhNH/xuCxrKkkCYnXetSni1APehhIPtorsmcZ2iX9UWIZLCx3gnKKqFcGGk80wbz11OFEEtwY9QzQ9eGhCRfdwcZPdKbfxPGIVjBBaKfGv/Mu5DzRLDVCB/OhNboMEpCrbGpgR2t1W4nYxaLpzHErPoM7eZeF4AgJOKdWY/tzwLnfb2Jv+1RXaWNWrUCSjGg3+HviYzmNe5IsJKRlCEOVZd5pg6esw12gauPFsHBrGTrh/idJmv52vLz4XIloMfhp6ixNbtBu1DPYVx5a9gSHreQfsojFAad6+d8giJtnjacZZ8lLflfER01MWSDeWEOjzylniiiBhKlvAPs44
 hXRwVYL5
 fYm4Um5eZuSmimeRlZAZuX8t2QvS8qIvG6nQ+muVAlmSIj3X+OuJeQLFFNLQJmDjJDuPRgU4S7eaYfvJbOHzpIA+xts5k2Gh6h4jAGvxzXz6jkLTy55aYz/1yotVLh786N7M6FWsURAbHZBb7r2KlPBTxei8+q0TJg0AhbBTrVbZFUqAuhmV3+fzU2rgUK4WTMjiqjg9Xq3vRaCV88xmXYcoXlZK7JnVybM6hGdDh6umZHXYa5NKCGSG1Je5NDsfiwM8y96sjR31sxLH1mvp2Y6NDXFNy8caLuYpOL+ALaFAq3ZD7bay2wQGIRKa/6iPem3krOEjADYvFTfccQcVGUVTBO9T+LbXmW9ZDoYDwRfm0qp/dhPf5ONmnMsA9zUkwJEmZlJ7H804Zd0fQy3oyE0s9SiGrO6TajMTshDQqWOXgZgp3u7VTuSZBNNpXiwUPDJbn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 13:41, Lance Yang wrote:
> 
> 
> On 2026/4/1 19:38, David Hildenbrand (Arm) wrote:
>> On 4/1/26 13:34, Lance Yang wrote:
>>>
>>>
>>> ACK.
>>>
>>>
>>> certainly, will do! But commit[1] ("mm: migrate: requeue destination
>>> folio on deferred split queue") is only in mm-stable now, not yet
>>> upstream/stable ...
>>
>> It's tricky. The original commit will be backported to stable kernels,
>> so we want also the fix to be backported to the same stable kernels.
>>
>> The commit id in mm-stable is "stable" now.
> 
> Emm... Not a big deal, I guess. We can always submit a stable backport
> once that fix gets merged into stable :D

What's the problem with tagging the commit right way as Cc: stable?

-- 
Cheers,

David

