Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D68CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088A46B0412; Mon,  1 Jun 2026 11:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0393D6B0414; Mon,  1 Jun 2026 11:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A3D6B0415; Mon,  1 Jun 2026 11:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEFB86B0412
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:12:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 949011C19CC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:12:05 +0000 (UTC)
X-FDA: 84831684210.02.06D800D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D8A831C0014
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:12:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzDbYQWz;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRoPZwyQICk/LDd1Td1WsJ3uMEx71Y/sQrykw2cENrI=;
	b=1i4Kbytkm7eqCKJlDUw4MYgjXlgtxScZOwCbEwZS79dI7IjwzAdWUWiChwS2sfr7kAyVGe
	O+V5HGDd1W7QOeAKD+x0ljZAbWkojRgFC7DNIDifn4+WhuAAhTHe7jttc0fG8AGS7HDyg6
	Pyk/t1uBTW8HVU1GHh1QLfbkCapTWkQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzDbYQWz;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326723;
	b=aqXYNRAuYA2iiqfLhwtnefqNuqujNvvQCtOrSo64FU61GsVPfItA6UkhpY0hUEhB/zkzgP
	QbqOPKbLUU8u4+7gRAcUKw0dLag/ExDXsuTmKK1/RWISdITxqCjwKqh7hyuKKDKGQCmkyp
	fB4SdH7twre3WTAclxwHBYyrlVrcEGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6441F601E2;
	Mon,  1 Jun 2026 15:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A3E1F00893;
	Mon,  1 Jun 2026 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780326723;
	bh=DRoPZwyQICk/LDd1Td1WsJ3uMEx71Y/sQrykw2cENrI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OzDbYQWzocNFjL9zUrxf1aln6K1zX4tUkMX/diKlSdNKSoiBv2KAuS0HxrTcHeHfD
	 fqOs/leANIX/SRSGHVXnLpia+QQyf+UvRsnXZqPj8A4WB+p6Fl4bAK7p9zhUm44QQo
	 gn/KKsQbH7iZW8MkQBcxFi2wKtCB7vWT4MwD+WRlSG/NmVrJEl79E5fpRR5SmuZEB1
	 8zauIWVPZgHWtmdPkkd4QV7ohtP8gqRA0unspxBaBTslTuwKwL7/kKsf8FasBs90mt
	 3jpkLBN1Vn1K36vIIp8L7ot/bEkV67lAifY4s0dUl3n7kzKRThG4YJKjk5GIZJJT7l
	 KRain784Sqk8w==
Message-ID: <470096e6-f1c7-4b42-a9a8-113f091c63dc@kernel.org>
Date: Mon, 1 Jun 2026 17:11:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: mm: clarify that user_reserve_kbytes has no effect
 when overcommit_memory is set to 0 or 1
To: Brian Masney <bmasney@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Matthew Storr <mstorr@redhat.com>
References: <20260528-mm-clarify-docs-v1-1-aa88e83b4bfd@redhat.com>
 <ahhK2nEo-HPgodNF@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ahhK2nEo-HPgodNF@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D8A831C0014
X-Stat-Signature: autmtjynmz4r5mc55195pa6y73zn6ebq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780326723-923245
X-HE-Meta: U2FsdGVkX19XsPTS2ZoZwuXiOAmalU2tqFtBmyWqOvB/WJ6uRe6oNu/Q/kPlE83ek8cEHh7yqKf0phyjXQjVilbkm2A0/PHqIeLgmFDukTGt5NU1wXJ1G25PFn7EMtLOfXfeN+hU5mZe3wfg97rIr6Raif02tiGKvSSUf0Kyr4PHhTRZpnxTkx3zVvX396+lukiuUm8JyjTIB/6XxLUszWaq0eeMRvQtPRdp2gZ3WZJxX/HpzJppo5D2z6OXzA1ho4Ix0dtuP99BqCTvoXlnkvrOaXOxNCLYPsaHBcEdR4tymMLf+Gwxv2yoSSzk0BwvM3vuGCB4N51yd1ovnUAFR+6Zr2xvzU0ClzkUrCcr+Ar067nT7BZ2BD0RYAjghX1+gYfMQvk62nHbtHstvUWsXs2Ui+elC2KZJt3CelDd/BfqSj1n2Pwg1UGCJ2E4jzXPd2oL5MacnT7fRdiwfPBt0Pq8CoP3J8tVE6xecvIaF15P8syniA+TSRoWl9QxaZjUpYZ7B3viSuyBnl9GtC6Tq1HEMzV098QlsrXQvr3BIT5lmtAz8ugzRbRNQ4zPismWWc/feYPNhfjbufUHilTErnbErtn43lI2EO/XMBx+5lrkwwmlaYhfAH83IaopM6aSErdNdxn6KWhy9ncSV5izzBjjfZ7k8RwKUWx+k9WRtKMJ4Tp2cPxaszvr2srVel91l55unEfEc7n1zSP9cOy+OYTPGNVYLPzKaYyrQ0Oe5JyFVtzUVqEyWUu+kbpctH8UmMjHknx+4+ec7Dr+dxhmStePLZdNH82qfxzejZgPXMV+wX0wmLP8G6xD/FDFA8bH7IFUATrrglXiMDwShjq6QW1Bu31fqevR6vT8z/ODvpyFH8mrS88Js9NvZbJLzpidC2eufRNvpZI0E+IZm90GRuO1Lk/SVAVtrvUIYAEaSBXbYJ5vZpcUOsG4rpRvl8HPFw0EU89sCkwWqyjf2vq
 DMjWs8rI
 D6tFD0aJLx6bHh2IEVFrvk7tODj2aSD5nFFLLXBcQQcTnhhZQb/vuT+cacT8OIUhkM4aBX01EsWcWjBvbvUUbHsxwfefsw29aamXSlLbObMc00gH126tNcom8NbhFjqT4/WunW3Bqic9wDFCb5N1JDPwJ3r3gKpXLWMAVY4hC8oGNbrkCfYkwLla+yfT1AYXjoYC+QOwaSXoP4XtDtcXMxv+YugKspM39QaCVwTsrKNEVJ4FtkGDRivZDjAnCqbDq6q76Dx7T2Xxf98WM2FFG4gr7+QktkZb6WSp/y1FX+DLYFKPqghK17Xf9B2F+bGZqW2Dsd2o/AQ7RVHb0h8/wvE17RsyTJhgmUQvcutKFPgzvNI8RcX+og3oYT3WXkyTjifMY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 16:02, Brian Masney wrote:
> On Thu, May 28, 2026 at 09:45:10AM -0400, Brian Masney wrote:
>> Looking at __vm_enough_memory() in mm/util.c, user_reserve_kbytes has no
>> effect when overcommit_memory is set to 0 or 1. The documentation for
>> overcommit_memory already references user_reserve_kbytes when the flag
>> is set to 2.
>>
>> Let's go ahead and add a clarification to user_reserve_kbytes in vm.rst
>> that it has no effect when overcommit_memory is set to 0 or 1.
>>
>> Signed-off-by: Brian Masney <bmasney@redhat.com>
>> ---
>>  Documentation/admin-guide/sysctl/vm.rst | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
>> index 97e12359775c..b9b0c218bfb4 100644
>> --- a/Documentation/admin-guide/sysctl/vm.rst
>> +++ b/Documentation/admin-guide/sysctl/vm.rst
>> @@ -1034,6 +1034,8 @@ min(3% of current process size, user_reserve_kbytes) of free memory.
>>  This is intended to prevent a user from starting a single memory hogging
>>  process, such that they cannot recover (kill the hog).
>>  
>> +This setting has no effect when overcommit_memory is set to 0 or 1.

Kind-of implied by "When overcommit_memory is set to 2," ... but this makes it
clearer.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

