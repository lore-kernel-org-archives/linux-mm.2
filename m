Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09635FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A9E6B0088; Mon, 27 Apr 2026 12:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBB26B008C; Mon, 27 Apr 2026 12:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA7C6B0092; Mon, 27 Apr 2026 12:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDB866B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:55:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C473C1A01AB
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:55:51 +0000 (UTC)
X-FDA: 84704937702.20.25D58A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5F2E9140004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:55:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GTqse7kd;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777308949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eeIymKMmn5VMvSmJ/53HZ9lwroqGaVAwlhaCdG4C+3A=;
	b=HcdjIOMPIdGUUSWk0HjR4woDntH49Grhtq/Bxurzrg+xwnJUr0OuctTm8ath6wInU1l9Th
	S6DCwtxuCuyKFZ8Gx0xr9nfoJwUeomXES7qrdCrfh1xU93ufcQ9xFTm3PIQlmsTW6iAnU9
	Ad4EOCjueQ29TT+OlIR7h/xIDhNaTsc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GTqse7kd;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777308949; a=rsa-sha256;
	cv=none;
	b=Ba/9qhqX4/BD3phvYk6zU2G1I4bKc5iqqPaD1G5RNfrCq2ATAoJNtt/yTPBjx4rSp+KjJ1
	D1z6eDNbKyp7Qkd0M2IL4BDNEoJ++7ufGIz7E1jaBBIIs5b71Qx2DpDEVXBogS+5pe2Fc+
	yPB3Fnds6Rd8FEnNtWqYs3yH9kMWyzo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777308948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eeIymKMmn5VMvSmJ/53HZ9lwroqGaVAwlhaCdG4C+3A=;
	b=GTqse7kdhBNbY59iyBm4LkrDz6CtQSiX2TMtcjQvQLvs04M1FZtzTQbDGbrtIMQwh7+UMW
	Y4//Usah2Ru59miUhhipbBmtMGszORw//wF3YajKu5m0JXU3RkhXWwaA7SRPQrNXJzKqfG
	6gldvs69Px3euqURCsID8X+6ZRPgXKE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-2rJzpdyYM3CAG9xKaARLBw-1; Mon, 27 Apr 2026 12:55:47 -0400
X-MC-Unique: 2rJzpdyYM3CAG9xKaARLBw-1
X-Mimecast-MFC-AGG-ID: 2rJzpdyYM3CAG9xKaARLBw_1777308947
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8d5d03ae893so1825005485a.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777308947; x=1777913747;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eeIymKMmn5VMvSmJ/53HZ9lwroqGaVAwlhaCdG4C+3A=;
        b=aWMyFFobY/cuV4plfer8nK8czpcrY5bfK9Uk2ylwh3YYZ4U2ZCtrOjv6GXaqq66jfI
         UlzATkGQnqoEq+wW4s19hPw3F7D9446jYniuyvUkD2pZjztHryr6w5KzOebl5m8x14Ve
         S2NNX5wzi7dGvWvnv2cG4rny8jEeQVLcOMhFtQ3FKqT+7qqNvDAtDZk3yh+bGDx1sPj+
         1NXRQ9lZy/38rj2P2oXpWuB0yBJkjwFPIZBM6Vjk0jPV2gxGUKy1vo5ZpJMGlk3xD8Ak
         nJ31olM7LDdzoMBVF46kJdiQb/rvekfIepsPi2J/o1VfSpIF5jKu2gipEynQtiZNDACO
         IoCw==
X-Gm-Message-State: AOJu0YzOlvB/5cZXlCD+X2CA0julkIKgx3YeU4EHDVND0BJAVqbpuh1D
	Ut4xpbdhbtz7nlhak/0hu312dMdchq9YN/kRBlt6ZOFlh7ec2IJ+uu4bnL7pGzRRxlK1vExVVAB
	2H8rXXE7DXFvdyoCL8CUO+umgPZ5JzPKAgcW5DbkSEuQvP5wwfTSS
X-Gm-Gg: AeBDiev0Vb41/TCARSWW9GJWQfgSMxQmLu3Z5avfB+eAkTPM2qavZyvo35X2ZhXwrFW
	VH+SH5lVHkB/HUwgEOIAE336CvNMkIi/pE4Z7GrS6C49V5KczN3ApPs9cziSXwsBI0bTeef4ZTr
	AE/fUcEqaRD8LGaTjRir6IB7BVQ+4chOouur+1QmJuuYUKlOqUuYJZAUAHCiHcWR+xnV542om4P
	5cLiofTrHiX7NplxI1OX+11lEifsE50pWPMqP2/rXHd2Bbk55iw+pXr0p+S2vNaoK5HmScqVz/+
	EgGajbdVQ1bVTr2ZLJ17rJtm5MtkSbM/LrZ1MhwJxZ6bUio7FHQFO9WsrcGfjilkD3AgCjl7fzx
	zoWGj536LA3KxeRL9Av3vZczk3TYRhWcNMbbi
X-Received: by 2002:a05:620a:4115:b0:8ee:630e:350a with SMTP id af79cd13be357-8ee630e46c3mr3942340985a.58.1777308946700;
        Mon, 27 Apr 2026 09:55:46 -0700 (PDT)
X-Received: by 2002:a05:620a:4115:b0:8ee:630e:350a with SMTP id af79cd13be357-8ee630e46c3mr3942337985a.58.1777308946266;
        Mon, 27 Apr 2026 09:55:46 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac429ffsm266093656d6.2.2026.04.27.09.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 09:55:45 -0700 (PDT)
Message-ID: <6e105a9f-e335-469d-92a0-9bd0aa806706@redhat.com>
Date: Mon, 27 Apr 2026 12:55:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: run_vmtests.sh: fix destructive tests
 invocation
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com>
 <20260427091250.61316471db20dfb0852141c1@linux-foundation.org>
 <ae-TlsIq_YkQcCUY@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <ae-TlsIq_YkQcCUY@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xcSbeBsNyT4NcwzDnl0UWe5VpbdxeneyRAPPU2nqea8_1777308947
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wfm8ngshw6qodme1gn8r5cfqwhaiifkt
X-Rspamd-Queue-Id: 5F2E9140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777308949-923401
X-HE-Meta: U2FsdGVkX1+a397be1g8woMYpHIiQwWTFlWlJ5imtOa6AFzlnBbuv5KtLUhHuOwvhPWSuCue/DVvkFzpRzgc5mFEhiJcFt4noqFL80a5j9tYa8Ha/aa62w8x59CAptBzY/RTSOrd6qZOLuQNo4d7MUidWkL4e1f3gtYgPnPM+2aoFaWiFG3oaMLz1R1Jx+170JcVLFdfcEWalyg7RWRf6OBdwDYPKgMRL/LZVuFeZQVicY8Jz6GFNwvr+7nKKCzBu8N79+TkGjUnvv8S2IRpPnJuBk5LjhNFOaDqqUL2Wuc8rrenZWCDyY9FrisPhKhr1693MabpQ7Xcpcdtnl+HnnMFWt/uINIaHCThKa1ed9pDMUCB1Xk5sYc5pt0sZXmLHLDTc+MPgz4/kbY/MU4MG+CU8KsQ7dgJaVJ8aT2e+D31/g/2WeNWjrb4kTyTV9bHi4T+h58id50biyiL9ppPvTi2QjrH31I1LsMsYBUgZDz5ed/qQ6GP90Oi1jAfnX53UDdRsNpF0ZgGNrncylyAJJ6RuC42ySqtknUxT5LX4BzwQf/86f6i5RZR8/EG2J5PIjnM/GFDkSE4QLjJyTwV2AISLJklxEHx8kIrROe+d2+fSeRpUo5Eg7d9EgZM56f40XjEigcqV81GGbehQnFz9iBZHqxrIUt5GXecy8X8Kg5vZVoTogHmhXMhLXzcYtdHOuaSupR+03L5RvtIFAaa6w//KYr4iQK4uSGMcrxLv9K0XAvSS/7S0gOl4tZeqvFgEH+SCpyyQlHMKQgwD1fnQYHqN+QG6+1+mhmJOll4HhKcUNNdUaNiA8fDvjeFI2O502Sor5ribJPBVjiiHp51yNa9u82qPv7EoNJufy0Tt0hAGMlyRPmgH1tnXQBXnRxiRc/Q/4yxinps6OttuIzBBnVMblR+QAXcxuddxsFMtY//LFYPowk8ka7gckbp4425N3dWPBdpm1zvEomCjty
 yCa3pnfn
 qvcj2mb3j8GtwX0qLvgtIvYfoOy8FL1i5vtTr0yI1NrnuM5HHe+1K0NiPpjRo17Eo9gXb0SfWk6K1LW8TL9pi4uKd9DVOqZJoiqIZhuLk2LEZ87V7XG5Twv1AQqihRsnWSYEaumjsNc4GAuPDZRXvgT4ByH3HfaQr2Cg3P8TLmQc+M2GbDIem9qMWMLiXGJJWq8AIdQ2TJq9WWJAWCMISO3A+QqeS5e52SriiJ6s39eApbrRiZi+Aw7qWlaaGtEUR5T8p87e39Qn06FAZdoNBmA1rEUSRIcPjGVqIjrNT3/0G0bNBKPbq0/EG7wfpHAH+43AAEVQNsTZhP0EEFwrGuOMr4XCFb9h215onUUuY/YbRpVYHHj2sXh8DFFSOoPhMfXt0sUWbE80/kOio7TYZgHtyzO6v3rAfR6cFPAcKqW2VIQKVQmLU406lauQZKUUtr5pdDgb0D90F/x2WCoNY6l7iaJzs/iQzD3zCTuYF5qLHom2QAKmQrxK0NzzEgcls16Mk20x+nQrY/1ko3c9cKzDyfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-27 12:49, Mike Rapoport wrote:
> On Mon, Apr 27, 2026 at 09:12:50AM -0700, Andrew Morton wrote:
>> On Mon, 27 Apr 2026 12:03:51 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:
>>
>>> Destructive tests should be invocated with -d command-line option, but
>>> this won't work today since 'd' is missing in getopts command-line. This
>>> commit fixes it.
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
>>> ---
>>> Mike,
>>>
>>> Maybe it's a good idea to add this patch to your series since the
>>> hugetlb-read-hwpoison selftest won't work without your fix.
>>
>> Or I can scoot it into mainline as a hotfix and Mike will pick it up
>> via Linus, soon?
> 
> I'm fine with this.

Then it works for me too.

>   
>> It'd be good to have a Fixes:.  It looks like a3c5cc5129ef5 or
>> 2bc4813622459?
> 
> It's rather f16ff3b692ad ;-)
> It added RUN_DESTRUCTIVE and a case for 'd' option, but missed it in
> getops.

Exactly, I just found out the same thing and came here to report it but
you beat me to it :)

Andrew, do you need a v2 or can you edit the patch description for me?

> 
>>>    tools/testing/selftests/mm/run_vmtests.sh | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>>> index d8468451b3a3..c17b133a81d2 100755
>>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>>> @@ -103,7 +103,7 @@ RUN_ALL=false
>>>    RUN_DESTRUCTIVE=false
>>>    TAP_PREFIX="# "
>>>    
>>> -while getopts "aht:n" OPT; do
>>> +while getopts "aht:nd" OPT; do
>>>    	case ${OPT} in
>>>    		"a") RUN_ALL=true ;;
>>>    		"h") usage ;;
>>> -- 
>>> 2.53.0
> 


