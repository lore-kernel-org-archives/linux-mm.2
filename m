Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9371EFCC9A4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 00:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B586B0005; Mon,  9 Mar 2026 20:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529B26B0089; Mon,  9 Mar 2026 20:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435106B008A; Mon,  9 Mar 2026 20:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2FCD46B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:04:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 986A58B7A2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 00:04:18 +0000 (UTC)
X-FDA: 84528206196.05.AC5F433
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id D4EC21A0010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 00:04:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IVb/wMMZ";
	spf=pass (imf19.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773101056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUfLC0f2AWQrj2JXMtmVBU5gG8MnUPc2ruYf8Fml+U8=;
	b=RkkSRngMbs9B3HJLty2llRcwYky+UqK+TGsFD1KtjVb/kK2UNp3WPDFoq2tMAKbRI/dm0G
	JxqPTCY4ZzXTOEeXlrQqn/h7VWSAp0pJWcgtX7tZ8U3YXJnRf18ZZ+WgQIappsATGp/H4Q
	zdrbLgBWruam2rB8/2XscLDlbzvZzuQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IVb/wMMZ";
	spf=pass (imf19.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773101056; a=rsa-sha256;
	cv=none;
	b=zo68aObIKmDWs/+ugiEjcZvIgoqtCzUdBeVQ4RVlN5g/xpdBF0rS9NV35f0brshwWrTBe5
	LUM1Av6YAL3XEpTsYcE7II4Udfh2pBDUrdvhjCeEiQGvu5NSpk7hJa+rwvlHWiyXqNEO6r
	SKhGjg1cVzPwFve1M2Y5L1oASWHGoTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773101054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CUfLC0f2AWQrj2JXMtmVBU5gG8MnUPc2ruYf8Fml+U8=;
	b=IVb/wMMZrbuf9lsb3GnsZFeL2O7pxhRgIbRFh1jrqZ2165ZaKFjOTDu6bli0v48MZeTSWX
	UmK9OiyDt4Zf1xQ7OSXUswD9zGfK/eVBJaLTpF/qbTd7YaeJ7SKwH0MWxmbCiGBLDeXuAM
	jkdOg3DXn1tnae1b6cUEQVE+uq+QO48=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-vCKMX45vN-W9t60to1Wwhw-1; Mon,
 09 Mar 2026 20:04:10 -0400
X-MC-Unique: vCKMX45vN-W9t60to1Wwhw-1
X-Mimecast-MFC-AGG-ID: vCKMX45vN-W9t60to1Wwhw_1773101049
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 704C11956060;
	Tue, 10 Mar 2026 00:04:08 +0000 (UTC)
Received: from [10.22.81.138] (unknown [10.22.81.138])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D67EE1800361;
	Tue, 10 Mar 2026 00:04:05 +0000 (UTC)
Message-ID: <38c7a9a2-a8f1-4ae2-9070-73d0ebb42f53@redhat.com>
Date: Mon, 9 Mar 2026 20:04:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftest: memcg: Skp memcg_sock test if address family
 not supported
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260309160205.651754-1-longman@redhat.com>
 <4ddd3jascnb6nt7quhyjfmsgsmtfmjofwmnrgjktz57cfbfymj@6ejbdgbg4lz2>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <4ddd3jascnb6nt7quhyjfmsgsmtfmjofwmnrgjktz57cfbfymj@6ejbdgbg4lz2>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: AiV8sfC4SxXOslMNxOmSR3eBWxLP66XlAquWQ0GzB6U_1773101049
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4EC21A0010
X-Stat-Signature: 4gf4zwb65bo6bqt3bbszarphr7rdhupj
X-Rspam-User: 
X-HE-Tag: 1773101054-223664
X-HE-Meta: U2FsdGVkX1+abOqs11Uz/YuUpLu2C/zQ2RgUkAGNVQD5F0wxxcUvILhkIav8CcwaEuCDGE9KxRz1XRGbf+tHgoFKlRXc0UJBW7XFC1G734a1m/lUoqM/9B7NhqB4tcDaZ5pD9bwn364i8cNQZLi3b2iNxmwYsTEXva0e1aWMwzuIz3s9sG4J++XLGifm6mQpfA6fbh/4gJaSPtCQP8nlXR7gzLx3Dsg76kHM1mHwk6R3cCrA4p9hbbgtkioxnmZQrE02HoNeCWpbEs5DAe6uENUNf7lAJUxMPZWHjmEiWRGSrkVjbj8N4NzxJiDCgX4qTCN4I9fQF7I3SwYc6PcRbfmq+kKv9hFNT+SvQCn4Nyxu5FRs5wtLU3gC3tZ3gT9xLrTmVvybOexFBvAAjKhWHu2057SMUIGBzit0VHwxft9eFyEYTVp1v/RFsA/fD5n6482sr6eQDC48ld+8js3HsW+C3B4XO1pYVbdbDJ7JtCbFvX9b33R5n0r1ColoXIo1uL+hP47HbSIpBWs/4Vp/YdSC4CXyvltp4UtB75ZXQL2tn6yhSYrO1nV7419MsjbvAzwbUl+BcXFJcWO8uXkFW31Is31Q0I1l4rawroyJDyQ7M/EciaZHLp4R8XpRMLOWm3kFsutRm80Ik+Pra13p+EDxyT0N7Z93ymwlVpqwTkXSGQgMFUH6o4JkO4OyQECc/CFDhpIaTgqdu9iUCCU6Qan6BdpMWPiwDpqOQoOSlYSjvRpzOYak6KuSCdZIRPEWDbGbeDg3LkQTPJqzXC77QvlmyVK3Uep4OnzkMQrP79kRVrNMNzOOSDhfJ1eMTW5/VWStnBOy/V8LgG1dKKyKBUsmM7Mfj1f87VLtIYaU3nEjN0g9rKGqYM9k7CY5gUg0FdO0eym1vM3YinPNSNESN/YFshwws+5DFhOWS6KBJVQwr6SC6yybvi/aLB+gbcYJQjy9oSa+2u2lPjHjNdd
 p94sz9s5
 FCJkIKmu3Dkg9A3IpapqJ2WnBleRGqQ5PtQLCR8X8tsbQHwaYUhrA8OeXUcGEqYpd5d6R4eSbVev1Eqy36b0zMab9u/7fNLTLlk02Ffu7VQ1VcDVveS1ALwZ3FD8/PBPr0xU5Lak4fLh/YGhNli8xSSNj4qRvyTZc3kYE7cWk+W527nLv/kj8GXl6dPuy1MJ19jK40G6llyjLrTL3ln34cCZXlceCkQ3d11bvZzd1fPEb2ku37qkzeRX3+hGIt+LqzFbyujKvFYcIv+UsIm99caMcC3PmtDC3NSGrpzQDPyYkhps9n0ELRd9AvdvbC67VTMH8GMSBO7OZj2gtBkfre5bLdXeN+GpUd3TjJkraF2xpMARxrGwfIHrvhIy8kENMqttvMxW93lDYMlu6ZxtkRIBsJqShpOAEFRY8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 2:07 PM, Michal Koutný wrote:
> On Mon, Mar 09, 2026 at 12:02:05PM -0400, Waiman Long <longman@redhat.com> wrote:
>> On systems where IPv6 isn't enabled or not configured to support
>> SOCK_STREAM, the test_memcg_sock test always fails.
> I think IPv6 is not substantial for the check...
I mentioned it because the current code is using AF_INET6 family.
>
>> The purpose of the test_memcg_sock test is to verify that
>> memory.stat.sock and memory.current values are close.
> ... so this should work with IPv4 too.
Probably, I will try that out.
>
>> If the socket() call fails, there is no way we can test that. I
>> believe it is better to just skip the test in this case instead of
>> reporting a test failure hinting that there may be something wrong
>> with the memcg code.
> Yes, the skip on (any) socket creation is also (independently) good.
>
>> @@ -1460,6 +1466,9 @@ static int test_memcg_sock(const char *root)
>>   	free(memcg);
>>   
>>   	return ret;
>> +skip:
>> +	ret = KSFT_SKIP;
>> +	goto cleanup;
> Maybe make this analogous with other cases where there is no specific skip-label but
>
> 	if (err == EAFNOSUPPORT) {
> 		ret = KSFT_SKIP;
> 		goto cleanup;
> 	}

Yes, that will work too. Will make the update in the next version.

Cheers,
Longman


