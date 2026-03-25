Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C0A109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A004A6B0092; Wed, 25 Mar 2026 11:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0916B0099; Wed, 25 Mar 2026 11:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878396B009B; Wed, 25 Mar 2026 11:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77DDB6B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:17:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56643E0D65
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:17:30 +0000 (UTC)
X-FDA: 84584939460.28.78B57E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7090E180016
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:17:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JrViTMQJ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JrViTMQJ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774451848; a=rsa-sha256;
	cv=none;
	b=7oJdIYum5KBzEO1OS7XoDjJS7082H3ZkUH54IPFaIBd0oIYrtIBcNvc6tmmarWgs8IY1q0
	4X4J2iVsjqzf5Im7s/unic8Lk0TUkOtARDI6DfNh6jLkiYAKOvLrLyVvcHFXE5gno0l/Sg
	fwZyMNjaO9IlVSA9XHELbqrNLV1YDWI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQ5FI2Hmnnc5abNAJPx9JHZNlIM36zt5U6ixI/lDtO4=;
	b=MSlJqCvNWZnmlWtEk+IWSZHROV5xCEM6eKFHFuxd98RZjI7iI6u3fswtxkOa3X85xoACqP
	kQlDpiqOoFtPeXp7APvGs7ppUoG+8e49gvwqHOOisjgb8YxdVEGV2COCKyUUkI75pO++y2
	VHIK5tJLNQzicrPNXTUcB0dpB5EiYEM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B8AC436C1;
	Wed, 25 Mar 2026 15:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C27C4CEF7;
	Wed, 25 Mar 2026 15:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774451847;
	bh=ksUMt37J8BPZlt6VGxoJ1gDJt4iZE368GqGtTG1peQQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JrViTMQJWQ4XiUVYH096cYPmF10u5v97fWD1ge/RfAiD7NufBwAv5H4LZ3t3LmHna
	 BBFfUJrxaa7nYwiFtDRArkhuKyqau0FmIDMZI/pgurWCr7q62msJ/5VdT9wlyr92GI
	 BJQW/Ep4PG0/G9aKsO5fmRPlevp9EiNWRttaP6YpBUFrzJcI+BnkxSXjKhkb8af5F1
	 0uv9kqBWB/Iis2LFgomU7apAVYnYK5lQyKfRwl4R6WL6vROjU8Xbq4P7MsA6O/IZKo
	 MEJE8Szwdkflfr80v0VKYN0L1+tD4SPZC6IssXM4re5469jPTND/zIFG0STDu8wpAb
	 7cnWEBoF76ARQ==
Message-ID: <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
Date: Wed, 25 Mar 2026 16:17:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
To: Andrew Morton <akpm@linux-foundation.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-3-vernon2gm@gmail.com>
 <20260224035247.r6mxsfcpiev4wnce@master>
 <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
 <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
 <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
 <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
 <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7090E180016
X-Stat-Signature: o7khif6bx13d5wp81tu8yjnt7ysreumh
X-Rspam-User: 
X-HE-Tag: 1774451848-182917
X-HE-Meta: U2FsdGVkX1/09okNIvZ4lNc7u4eiKuAAZ5xUB2DMY6cS1viqn6QI3a14Du7xk5zqfAktgCoxOhaAveRTJl3ZRwJDDu8DjPpIWOWQ7nHrV81a+8U/64RVN6+OzjjT9njwNxKLFkxNfp3a40436klpxA6q/8JbGm8VDtZwkTHs0uD7MhozKD9/08PFhB4YPAUnGCTGd14VHeUSm66EF3+UEvCQGmGgUxKzMml7B+DXW0NWj8Sy1r4iVDt9PWWw0n7hcGz5ewm4L7nKuVDdMGPIjcib6A7W8FG1r0OJ8QDhqa5eAdU8XVQfVxu4+m0keyPVVC1lzdull0mW1p7NG+rHSBB1UiKIJNIxPqOHFJoRBbCbAgT2XBpmo3SUCPex07c71ZB/nwaI+9cuN3qBNAoVTEM9l/RmrE3YSSa/SyvSAIZyCgQLy3sRKcrNRlK01jgznl98IV1GfeZGzVMS+qmFXXHj6fCBGFQYm/FtwMurV0p9lNWRPhl4sf/fXHAIHvOl4Uc9vgZL7vHkb2nikKKZdhVR80mHGzT3db0sycgo69N5TVzszbeufTEIB4kkbEX1+cKxOuQme7Wgp3aU8Oapu1q9dVrX7TaE+eY71SEisM+m+sCq24dHbsfqB1OmLKnA5o6nmIBH/CmTGKkAoYrWet3Tnov7lw4xgaKs9YlDF8pPeM9XrpRKHe/+SiRyPDsV7z+bttcNq3TXDGDerBFta6zqQqs3PHHRkoVY/94WE8QGtW7vkMMhd8j7WjTs4U1QxE4IAgPQUFe1ugESrbedmfdslCdc4AkFiaQJWj9lG3sp7Hn8ryRlJkuydpY/vJyMK3ohg+NZ4fDfNy1mo0ZO693S74K4g/R8z19g2MlchgqPPdfOTeDJhwWo5cifEPI3Ri5JWU2P9AenfEfDP5f2W+7jFGHc6HDq5PLj2mOAYUO1q0y+LlrZkQTPUtVT+AbSG/+WKRr8subQdExqRXw
 UdQuCMpb
 DjYOLuh9YZiVu2DSH0hTkE5O2x/Vg0SnG7ps8RCmz1289JYxAB0PRfI2OWuTMBjHrh6tsjeVs36uwcu3FDlHaSFg/Lhn4RjEuc//JbMFBfQZxaZ3AAb91RM2TdAgcJDQakAi+pEuOYOcj50/s824ZrMCvZvWSp0HzHBmkbUAwH6sS/PVaQaUbFp+qZ90AV2DCvHu/Xv3H0zYy6D1PR1tGr7NnqV+CcIp73rUyMALzM+ip1h/cG9nLZZALhOcS9KA8aQwh5ks3Qq18lAviMJErKMELaqvuzi3aQ3cS/fg/OhGFf53VCo/YpBXAYUrvYQo8DtWM72sLuLn+UHRVUOV6Q5lp7NWMVD2FYxgW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 16:09, Andrew Morton wrote:
> On Wed, 25 Mar 2026 14:10:23 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> 
>>> No need to update the patch description.
>>
>> I will take a look at this (sorry for delay) but general point - while
>> fix-patches are convenient, they're incredibly anti-reviewer.

+1, I could have sworn we brought that up before. :)

>>
>> I hope at some point in the future we can move away from that so you can look at
>> a series on list and know that what's shown there is the actual patch.
> 
> Oh.  I've never really received that message, at least not at all
> clearly.
> 
> I've been hoping that the -fix patches are actually pro-reviewer, for
> those reviewers who have looked at the previous version.  A full resend
> of something you've already looked at is quite annoying!
> 
> I try to mitigate that by sending the
> heres-what-you-changed-since-last-time replies.  It's a little more
> work at this end, but that's not at all a problem.
> 
> I see a couple of options here
> 
> a) I can fold the -fix into the base patch then send out the
>    resulting diff as a reply-to-all.
> 
> b) We can just deprecate the -fix things and ask people for full
>    resends.
> 
> It depends on what people prefer.  How do we determine that?

I like "fix" for smaller "obvious" stuff where a resend is really just
noise.

But for bigger stuff I prefer a full resend (we can still have these
temporary fixups, but for reviewers a follow-up resend is better).

-- 
Cheers,

David

