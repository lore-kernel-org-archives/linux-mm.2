Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D74CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC018E000F; Wed, 17 Sep 2025 09:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C628E0003; Wed, 17 Sep 2025 09:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72498E000F; Wed, 17 Sep 2025 09:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7C2F8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:19:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81DCE1A0555
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:19:30 +0000 (UTC)
X-FDA: 83898798900.02.396AA1A
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 57E3D140005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:19:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y2I6/2WU";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758115168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9QswkncU+CGDiwp7p0zaOAY3Ki4lJbtpA5gKQhu94o=;
	b=A6sz+jymb37Fy097Oj88VEo+pQO+FruI+FtxMfORpHZdyErwiLrIrJS8408jX7BNO+cECL
	B/FHHV8GjpfhbYQY8tR6rh5RVl+Q4CEZ61QJ9QPz0AT75BxR/lmTgtBX06IUffgwEjUgK4
	5TrLRT5NjYdVHGQ5kjhGrujjBLlK0N4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758115168; a=rsa-sha256;
	cv=none;
	b=B/ZiqN6wz3fQFkS0y7BHe3wC8j0Lnr2WDXdJRLAbV5JzHTMLZknQR56ChJuBNcvp2oeoNC
	/wZcoLt1BZkq7TT3JGhQkeT0H4/pVU9Imsxm3reW1XkfxssUlqltWNhHsqhM1RA/0CiCFJ
	vPl/lNHMiLkWqjC1C3lbNg63P6/CxOY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y2I6/2WU";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <706bbb76-1204-4377-aeb8-0c1b21792014@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758115165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o9QswkncU+CGDiwp7p0zaOAY3Ki4lJbtpA5gKQhu94o=;
	b=Y2I6/2WUOg6vSZuxcq6xNpgVJeuCh5jNqZQztf2duQDilHBJJUBfxaxjjF9q0V4A06szXK
	PtBGicahkDSZx6Brz9jGacqzxiUTpQroNZk+CWLICfTZ61TpVrv+kY6kFbE6jiQcPDNcog
	FfkcNO35jnoys04OeK0UShmDLogYogE=
Date: Wed, 17 Sep 2025 21:19:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] selftests/mm: skip soft-dirty tests when
 CONFIG_MEM_SOFT_DIRTY is disabled
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: shuah@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <20250917122750.36608-1-lance.yang@linux.dev>
 <ada1b1f9-bd2b-4164-ae8c-80264d4f6dc0@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ada1b1f9-bd2b-4164-ae8c-80264d4f6dc0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7dy4epoonk6qq7zcxiu3m59g1bxto9zn
X-Rspam-User: 
X-Rspamd-Queue-Id: 57E3D140005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758115168-458117
X-HE-Meta: U2FsdGVkX1/NZb1l1SoqWTxUs110GHB2P4i7y9Ay9r6S1h1msx3VmEHyRExHAcfPmg0h71x2U+85AYL1899/t6dqu3fOo9sGrD4BsgOEmEJyFxLyAkin2ulW87zfsRzWA9F8avpvfUZxvym/PpOnCRd4JkrK+MQ8loasLxyP5KmB9MjbcjlJTwhRRcvW7o5p2d37yU/q4hVvzPzhJZLke53KzEbdSVzkJPllAyZOj4K0esx1o/fGt4XResYt2/Ng+gNFVU5gpwzIGjl4UFizymuuys7z/QwrmeZ+LKm+SkdeupmocYAjKLXZ1sIOf+xMTmuN7VyTDBBbxr6J8VGiT0zAvfBzrhSlKDNXZ+DIjFaqtiuVLEJcEkd6hFMMDPBCbeBfvv1c9SM3VDIOJYJ8WaUbnUAlBcz3S+9U265XIEzsTMR7y474PA8tY1kgEdblZ8nBI5ptKHnYoZD/F30s/kV6Dy8SSa6Kk3bZCLA0LV/dI81yUWdEglmAXJRm05XDw67WDBlg8cIXx/XQpXC6PKPiWX+2Sh5GQa2SmVDOYRx8mXmwzOjDjyOfOEvAVTgqYS4zpWd6EAH4S0uOA/3oSdNuBPFs4lRxKGO2qhrEJPAnvpOC4OSHLTS/Nv/2soTLW23ll8xJTHaBX+7zLnwzARp95pJeG7nPXUbPka3l3H8Jx2smYPKCN9ZL6O72glJyv8NZOscimjXe5Ynkrhd6gq8DroRB13BvOI+kDd9bqiJ0kc0h4xbx2w/w6htpnZH6F8jLUAK2nxmj0gtg5i6ctNpqNRs5Z6+ozHZYDgnfWwNtWT5n6F+swyE7nK+6GCJa343RCMMJ/Ww+L7xZqB+OpSI4JrMk6DIjQKGq95zBwP7dLfLHIhPL20JHd1tXkbx/7sqg1BpBTYUYkHFWnw6SiZ0dj9Lnc4SiBG/htYt7HgaBE7qP840YYgiG9XK7MPpisex55um6gW2n1c7ZQWG
 reSkXbYA
 l9Ky0+Kaznqj1lvEc0jkDbNYoL+E81fhSflbtTypdNAxIATv8PVwNExz27eE/9cKiFDGL3UvaeRWpEeikIJv+COBTOoL6ooEED4Yw3FjM4cJ6cspY5qaCfbTfU21oQgvOfQiq2eeyOzehe7m5cKYvLE6ecrHb/s0DWLhp5wDmxnucxZgCNlZWPFAvQqzVeHOZslpe9KRpb1S2PDjbprMzomofypDrkiNXx/vyHdHD5TsgWvoPH8bLW/BwsspqYaaxhANlfudGmSGe30H/QQyRSY9JTRbwr0KVS5NBwVpmBGVnRnlS6475Tzh4xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/17 21:08, David Hildenbrand wrote:
> On 17.09.25 14:27, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> The madv_populate and soft-dirty kselftests currently fail on systems 
>> where
>> CONFIG_MEM_SOFT_DIRTY is disabled.
>>
>> Introduce a new helper softdirty_supported() into vm_util.c/h to ensure
>> tests are properly skipped when the feature is not enabled.
>>

Oops, I missed "Suggested-by:" here ... will add in v3.

>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
> 
> [...]
> 
>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/ 
>> selftests/mm/vm_util.c
>> index 56e9bd541edd..ac41d10454a5 100644
>> --- a/tools/testing/selftests/mm/vm_util.c
>> +++ b/tools/testing/selftests/mm/vm_util.c
>> @@ -449,6 +449,25 @@ bool check_vmflag_pfnmap(void *addr)
>>       return check_vmflag(addr, "pf");
>>   }
>> +bool softdirty_supported(void)
>> +{
>> +    char *addr;
>> +    bool supported = false;
>> +    const size_t pagesize = getpagesize();
>> +
>> +    /* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
>> +    addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
>> +            MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
>> +    if (!addr)
>> +        ksft_exit_fail_msg("mmap failed\n");
>> +
>> +    if (check_vmflag(addr, "sd"))
>> +        supported = true;
> 
> Reading the code again, this could just be
> 
> supported = check_vmflag(addr, "sd");

Nice. Will do ;)

> 
> 
> LGTM
> 
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks,
Lance


