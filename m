Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0CF9FF495D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 08:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183976B0092; Mon, 30 Mar 2026 04:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B016B0095; Mon, 30 Mar 2026 04:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071396B0096; Mon, 30 Mar 2026 04:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9F896B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:16:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB2B51A07CC
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:16:51 +0000 (UTC)
X-FDA: 84602023422.18.0DBCCD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E9DBD20003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:16:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OR55pv+O;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774858609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlIOewFKORQbzDUxTTuqroR2QlVol39g6NbTJDdrd4s=;
	b=YwGi2yqIX8XVLMKudHFXFRPkizMGXU1HCX3FVNR/kLvcHLqC2GtgjxBmQlVfrpErEPe5yV
	ww+2skeUJFPMW5jmSRrRntV1eLoOV1jog/+TF3HVPZlOmiiHnYiCMSlJHCSO40nL2b/4ax
	YVLaCDYp2yhZ+JUK24HBlp8icjMKxls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774858610; a=rsa-sha256;
	cv=none;
	b=6650O1dJltnQRNod0953UygAQ/gbgheA7D6pe2zs3z8wd/34Kv/YjSwR3QT8MsENl8NqcG
	rMIO4cbZGMFfn5J+j8aa5lI1JH+Y2zYsiAtVQ0y3m/wZxfjEgaqtGBgJFyXfuXZR/tKiBP
	YzfJpiFPl6caU4h0tH98qie7ef7+u9Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OR55pv+O;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27C9F60123;
	Mon, 30 Mar 2026 08:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6B0C2BC9E;
	Mon, 30 Mar 2026 08:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774858608;
	bh=vbZ20lI/lTnXmMVKHlmgZnjtM5fXA9hFVYAAl5EEFNY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OR55pv+OUASuBEwInMjNm7AP0epARnj4kNF/Qjsgy/zy0ZCkZN5HmDLitL37n6rmo
	 3tBH/iHaYi30DAsdWmV8onvnj1M0qNdfDpht/bXTE1RR+KSc9qvzKs8L42HFgqRxaG
	 1V2NPVxx0mpp8oax2dKYjqQaie3Iv+5ePEka3SEsgFEuAgvubJk8PyXDHK8i1bm/Zd
	 TTDUtpGlLeEp8/PeT5RveHrFuKhBrUj3IIh/z2HIvuH0F7ot8kt664S5eaEGzWbEf5
	 3Ac46uUdSZ/fYCwF3sKzreHDXHoTXVfXhNlhsl5peqxyBjPV89V9VTC/veSybHa9IN
	 wx8y+tu+XTmww==
Message-ID: <25688dbc-cd11-4137-bad4-a215198feee6@kernel.org>
Date: Mon, 30 Mar 2026 10:16:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
To: Krzysztof Kozlowski <krzk@kernel.org>, Josh Law
 <objecting@objecting.org>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Josh Law <hlcj1234567@gmail.com>, SeongJae Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
 <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
 <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
 <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
 <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
 <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
 <6deb290e-b168-4de2-95f8-fc784ed31c27@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6deb290e-b168-4de2-95f8-fc784ed31c27@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E9DBD20003
X-Stat-Signature: uoc5bgr8wkcjmwykkfzbseuubst8t98a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774858609-509391
X-HE-Meta: U2FsdGVkX18RWG5XK1KuizsD00DK7IS5XohmKjJ45K1EvrsmzuzvqL0id1exnUBZD1tyzXO8QnTPaWI/ZaQnZHwtj4laFY5CQIOs+PMNZnsj3xGLZxAAiJvFgBUpq9uDtV1deqt4+IO3mpWhjw7tvIAJOdi5RusLnXjSsJ5uVx/5Li3HJuzdctE7zbXm4AZpLdmJ1yTlAsZbL6ZxdQgfCOzXZx1+bdUO9p5lFzcx6hEZVDY6GyIR3iyI0IkdSUsXwTS5lb44IvDM1BiEUInezMJlE7l/fjys76TyD/SLiT11Wa/hlgja6L3gcoWn2ahs3qUDQPTof/JXidPFiR15trwS6dEuaPxw/npl4Q1ZSAPBBMdWJVc9GrE5avu5mNoBkX5qrvcFWwd37VN+5k7pM5hklu8ia9WCb+7V+r+IJjOYoiKydyezx1ruEx7zT/6UJRDDRm5Dg0M78ao0iC7U98wOTfUcFV56095WeIQLdZJkOjbVtKNYkQsVjGmjdJr5XIApfEh+D2/fl064qbn7GRNYtwkktwMbvadFqkPDE+ERxddPhKoMo4xXfeEr+9SQz7ZYZbkrmG21VgHIPTfuUhhXBMP0xFxqteIdB3cBxYMw2eI79GiK7SFVkU78uzkdNCnUwALMffswy5HNeuAah2CpJMR4F9MGW71tPOS3zf+txJTpFAq8QqLu7etfei/CG6B3nC6LkT/lJLN7EvGtMNidBKLrZnb47tL/36Xak1nF4lb7eDraaRS4+1SesGerzzfCvpZRMvOUIIueyQVYPqhnS2TEKqIzx0rbMGVDHiY4AYFLtcTTTiHq03WLJ9gtmhBKrNhNU0s3iae7Vb0tJhl397sbvYsZty6K1Cdbp1bRxp+sv1Vtj5nXnqRTIvLJKvzQ9jUYJjBq6F/wuzWQXQr6+YzWMbwHpQmaaZAwsncrVGoEKFVDd+gSe7ekTK2ZU4G3BcIgxa5KQofo7Ni
 Nio2qJeQ
 g6vyQuJwQX6e2OFDSK6+nnjYvNf7mwXkfMp1bfvbrMUAldWuwUGaDLPcPYUZtumWGrP/Ui8USI9JnWJwjdr/fiy/0yzjNLhxGKnImdNu0JRpAcHQ0keYovMhIGj8CHJnTsu3kT0wbrSEs106rkG7mguQvzZuQA2UrbhwSHN3lt0i7klpPr8ixrTjIuCidQev0hsS1vP+CtUUkqd88uxYxOXmJcIjoIkN+Uptfuba8Z7czkWSb4if6o6ItGIawNefcmWFa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 09:50, Krzysztof Kozlowski wrote:
> On 30/03/2026 08:27, David Hildenbrand (Arm) wrote:
>> On 3/27/26 16:22, Josh Law wrote:
>>>
>>>
>>>
>>>
>>> Hello david, thanks for being polite about this whole thing!
>>>
>>>
>>> so, you are talking to a real human, i promise you that now
>>
>> That's exactly, what I would say if I were a bot ;)
>>
>> As a first step, fix the line wrapping. The following document was
>> helpful to me in the past:
>>
>> 	Documentation/process/email-clients.rst
> 
> Yeah, good luck. Several people asked for that already, like 10 or 20
> times. Andrew asked that a few times.
> 
> And yesterday we got another sloppy posting, so that would be it for
> having some time off to learn things and take slowly. 3 days after this
> AI slop which does not even build.

Bot confirmed, I guess :)
-- 
Cheers,

David

