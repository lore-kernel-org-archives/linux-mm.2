Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B28E8F36B9A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 00:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C3D6B0005; Thu,  9 Apr 2026 20:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D136B0089; Thu,  9 Apr 2026 20:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742946B008A; Thu,  9 Apr 2026 20:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6298C6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:47:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB9B01402B6
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:47:05 +0000 (UTC)
X-FDA: 84640806810.23.CF4590C
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8EB151A0004
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:47:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=ZWVfBDsB;
	spf=pass (imf19.hostedemail.com: domain of axboe@kernel.dk designates 74.125.82.49 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775782023; a=rsa-sha256;
	cv=none;
	b=tbAswxw31upqbfJxDpOeSjLecWQC28OnBmrsOWOEpPSmqqtSyQJ2bb+4cO4WvruE/TWyap
	pXy1Pra5a+LCBBvUqiKUPuEZvoqefnc58sXMXBDl+u+NtxUardIYJ7PnS+3o4fLsJs5iys
	eKandOt6Tc2IO20IUEKivNLbfnDw05w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775782023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dLqEnr+wCE0zIFZUjHqtBjKoRS3kf2QNeojFry0cDY=;
	b=l3Ud3CWV21047Pb5J/peytuBh25xIkjIrlxJ4aWQmDa9WJeLiqsWXN6fCM2OQsCW6Pz69G
	JWnPj2oZqYPB7bvODKVZ6nqUuX0689CCPoAFh1R45tnFkgi4kFRy2BJoWEo9by7BbMIZhD
	Fhq+xe6ISFSPAdnclCU4jnHYtxWG6Go=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=ZWVfBDsB;
	spf=pass (imf19.hostedemail.com: domain of axboe@kernel.dk designates 74.125.82.49 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-12732165d1eso10752885c88.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 17:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775782022; x=1776386822; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8dLqEnr+wCE0zIFZUjHqtBjKoRS3kf2QNeojFry0cDY=;
        b=ZWVfBDsBIfAhAsHGTY0o5a1/Erl6bprDf21MyGndcJoCHFLqMvz9uUp7g3WeeRfTFl
         0IGvZNNk4QStwOHcHVhmru5RXSqfUQVaB1XCixp8Vj/Edhid67gBLbavTkjXaLseQ30D
         M6kiT/jPXixYbglNIPOHRGvTS5aN0d/EdFmpUY/gbSscnJMYktzBlWzAQb0gwz744Hw7
         HJ5VCIOEdT8tCHTWvjBDHMzGDOLA+UZj/YdTizTomCYk2zhz+jtJzRE+G10SD+zO9FHy
         /DQh5MNbLD/fNwGdaa8y6BP0YFg2CcwiYvaGrp0069pOCxfSgFB/TKKaAXEi/+5zwkEE
         c9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775782022; x=1776386822;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8dLqEnr+wCE0zIFZUjHqtBjKoRS3kf2QNeojFry0cDY=;
        b=IWMWl0ZEdt+vw6iqBl6hEBmrTx48o7V+kY/ROEsAEBj5Djs/fraoAKt0QnxEyGnbkp
         Vc9MzrqtmN6kfI3pts1VRQ89Oh4Kn41JVoBqwSq6ek4HgBnJXUydGN4Ktcx4UmEPCm/5
         bjaKA4SyaEvAGdMWpp0KaoaIFB6Oby75rGkarlr8F/0fF8FWy2Baig0LVa6VVOcMhq+R
         Gzn3m/GjNsc3HJMaxqvO/bZ0978adljAYmFX1CDLH1qaT02JEIwiZuCHaZ+aF+EShetQ
         dORMN1cXFJBEIMmGKI/ILrzuo70c+3u+1JtJTKhasnsxEVpymuI2Cn4UuFmpB+p11wpV
         iZOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOwY0l2tyodOPTv0z9lqbd11WCxcGQjI7CV84D4k9enHkVgslq6T0xz7Ot5IQynk0TVDIR1ZW6rg==@kvack.org
X-Gm-Message-State: AOJu0Yz6fs/cAqqp1TlCz5phgGn07cE5gJIQJQnmqnbe9/jEBbTqkwJ0
	hXSBEZNXdNji6gWIS2WuhbeMwBbbHPSx6BkO3p3/xWSmrKAuV2jss1VcxivJGU6LCVo=
X-Gm-Gg: AeBDievWH3Gs8muytSUz0Dkc4+0rLalLEVWmHZUhk7M7LlyU3VShi/DdDBz6Q3sbI6w
	3kSkRIYOqxZeyZwZVEMc0RJzni26HB6HszfkKxGUPifCL35bTenSfvtdNl/SC4pc0OJ8GSXc3gM
	yNM3tT48fuogcKvAHyKAO6G/cbK6rsjWuOqN7HkpnbVadaW4Xu9Rw1YMxYigdTCHu8MBs5ZOoA2
	6seL3clAmsR+1z2SNHaO0aWM7nazOEnhqtrRBec32cilZnceg4KN3cFXNExbRFP+/1kBFb0nJER
	KsqhkCBiHk+dacg3IvUof1vtieuI+h0XocPog7sA3um3P0CcHLiK/gSA+mKaGwWXatPFNXe7vVq
	MghbAk/2nIi0MBoXhkSottWzhFi8amXqMjfRRXKYLSMbA4vV60o0L5akdGQSDt4sFGWlY/1AxJL
	FWJYlQQilIPIKRb27ChPK4BO+g3oW1XgcwxncgnjpdlnX2HglMowo7j8C4vLk0jW+xF1WXkiBcV
	WXLHLH23kMQkwjUbf90T1WtWcLpBxx37NGB461qcdJ6KG8gCKyXGKA=
X-Received: by 2002:a05:7022:e986:b0:127:15cd:9f52 with SMTP id a92af1059eb24-12c34e37b1fmr652018c88.5.1775782021786;
        Thu, 09 Apr 2026 17:47:01 -0700 (PDT)
Received: from ?IPV6:2600:380:873e:380f:e9e5:ea98:a905:9cbb? ([2600:380:873e:380f:e9e5:ea98:a905:9cbb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c34352490sm1530405c88.0.2026.04.09.17.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 17:47:01 -0700 (PDT)
Message-ID: <fb64ba71-7284-4768-979b-84919f2aa5f0@kernel.dk>
Date: Thu, 9 Apr 2026 18:46:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Tal Zussman <tz2294@columbia.edu>
Cc: Matthew Wilcox <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
 <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
 <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EB151A0004
X-Stat-Signature: eryc5qeyc9jt4hbuebecrdb1oj4ox1mk
X-HE-Tag: 1775782023-599801
X-HE-Meta: U2FsdGVkX1/BCjJI1UNkB69Yoge1Cfb9Ihru+t8aFNchk7G5BQfvB1x32gtI3wqZqWvQF4ahL3qU62YUOK9Jz/JMXVKpIqp8wXr46srtHMj+fpXb6KldRH2x6dtkmBnsEI1Onx1GoVUNwA0XdG4W4GwD3WDsYLpX+sgIH1dc/ixojh3zCY6RpFm/JdBQqNsH8Lb5ivH7fOXD/7H+6AhZ+FVI4sw343NXl8cexK3vXFQQ4jyzzK7o7prNe2NZ9ENg+p4gd+2e/VTUjGrOTc555fMQjw1gzlcYTyJJGyWoElShJUOdORxdjRhaMFjRVyi96AkCswt1fZCVjTNg1xdP0RY7qfsS+bBL77PkeWf8+CrLKyQ54f6DvDeJ0Sq597XscCDzUIz42n7WH52Sw4z4Iuw+iGSDFp+fbUTIt/7XYj55j0zqVVsVkebFN9B+22/CHaJX0QDJ9kbqE0Mpux5/T7RnNZ+XiXrklzDP8G69zJpIKofwgLSE4zkF7CVlT0p0FF90d1209vLl3rNFdnTug4l4JvgV/zJ5HJNP7DeHy3qCQSUmEh5OvvZLOgPfkDbYSM5A8C6mYBWl/WDJR4jY2Td/J1zmeyzLO35PmnpEPHbWspe+u0iD1ALFS2S1hySoFrj3h85+3bXNXvbdtKGMpwmzjiw3bzen9d2oyxph3UkmLx0bHCXUpHt4CR6aDp15fCAU9c5a2oJ9aUuvem746wnuBr4/rxtcQkZxHBjYY3P16jI3wFyH3zLY9tcBb6NlG3tvCbaUFkof4m3K++oDoRZVPm4W0txmZRpDucGcINzjHDbsDyZMWbMPkQesyD4CVq5xQCFrQSw4X3GlwdYvCL5+Z2eERxtexwzWf4UFv+nGeuPBgG5L1byO9DeassH/GkTRyiuQ9xAIaMvPA29kHZ39vdKD+0ie5iSdGSg2tEb18l9BGZ+c8L/aXYjBltP4V48mf18RK9NBQuouFq5
 enrHbvlo
 M78M9FxqOZZXX1IAsBaeS2boAlIu08wt7Xt12T/zlN+wOoxiMIJiKHKYnKZyUP6Pp0nArEpO+qt8zuqATpbthkQn4GWSTm+JkboIfpXJQq/54KR+ENqYSJ1KYIo96HiW5PL8E0pX8MCS9oMbuPH9tFCpy423kZ0GZphJJFX10/dQyj1b03QMhESLZUDgfRRulPRoGnPTwy/3aPHcKMsNkZjW5slbULQs7B6DvS2Dt2IePh2NjacDk7ljAoiDbwSaeHZ7RCoNwpD2DntGsf+XcOnyb+4tjDc+T8cI/ojbNwfsTxcVkxWPbZ9wEc25FKIukfNZGW2g5BsvSMwtHvimK5IGboXqLciYYkS31pusFHUUP1X5hQj7b4vFNrOw7k8SDdFQyS3DrcHAgULBXgzBTelmnkoSqf3lKhU9nJLO+1syYvUk9ObJoMeLGxupDaGIzoE4Ray1i18eZTxHOlTdYNTXahSv3W+Ief8SaEKJ0PNiBE9crBZIccHrVOuSu/K5iYFbc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 12:54 PM, Tal Zussman wrote:
> 
> 
> On 4/8/26 7:36 PM, Jens Axboe wrote:
>> On Apr 8, 2026, at 4:51?PM, Tal Zussman <tz2294@columbia.edu> wrote:
>>>> On 4/8/26 3:51 PM, Jens Axboe wrote:
>>>>> On 4/8/26 12:?48 PM, Tal Zussman wrote: > On 3/25/26 4:?14 PM, Jens Axboe wrote:
>>>>>
>>>>> Thanks! I'm going to give Dave's llist suggestion a shot on top of
>>>>> this as it seems like it'll simplify this nicely. Looks like that'll
>>>>> involve turning bio::bi_next into a union with a struct llist_node.
>>>>
>>>> Since these lists can get long, I'd keep an eye on llist reversal
>>>> overhead there...
>>>>
>>>
>>> Going to send v5 shortly -- tested with and without the llist reversal and
>>> it didn't seem to make much of a difference. This was on a single-disk VM
>>> though, so any stress testing you could do would be very helpful.
>>>
>>
>> With all due respect, a single test like that isn?t going to be that useful. I?d be wary of making that change willy nilly and just thinking ?it?s fine, worked fine on the one case I tested?.
> 
> Understood -- unfortunately that's what I have access to at the moment. I
> can requisition a machine with 2, maybe 3 disks, and test more thoroughly on
> that before sending the next version, but that'll take a few days. You had
> previously offered to test on your big box, so was hoping that was still on
> the table :)

I can do that, but I'm OOO for the next week, so won't be until I'm
back.

> (Although Christoph seems to have proposed moving away from llist again)

I think that's a good idea, not a fan of using llist for this, in case
that wasn't clear. These are per-cpu lists anyway, and having a constant
overhead is better than needing to reverse an llist. IMHO.

-- 
Jens Axboe

