Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091C7606A337
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=tl3E0Xsd
Received: by kanga.kvack.org (Postfix)
	id 19CD26B0847; Tue, 27 Oct 2026 12:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174336B0849; Tue, 27 Oct 2026 12:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0635F6B084A; Tue, 27 Oct 2026 12:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D33606B0847
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:40:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5670440A76
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:40:38 +0000 (UTC)
X-FDA: 85368969756.23.9A1691F
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6E523A000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:40:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=tl3E0Xsd;
	spf=pass (imf25.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.47 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793119236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vGOrY3CisGPc8VMRVO//aXg6OQh93vx7xg6bEqOVs4=;
	b=8E6hMn3iHayNlRIVp7hVFPdKpTfVK1wslwRYK/aT94jdd31zUyNVKHT8YKnkjjlcR+rU/t
	4+dLm3/EAjhnc6jOpqEtB5ep6p9LKhTK6OkTn9p8cOdVKac+Rwktj4BrssXl2GYZkUVHNY
	xoqUubhfb1K91WMnDijo9RhCyXYe7z8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=tl3E0Xsd;
	spf=pass (imf25.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.47 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793119236;
	b=0WzrzpIglA2f5Y+Er66TYdWweUID0N1bgYkq4FR8aP2rDK9kxjacENERxKw7gzjDYcfffO
	Nnc3NLbiQKpuapbWG/TMQeYQd217gtVNxJCxYkmaikg45RR5oh0ObhjVQbhIFHPKttvzDz
	txJocrt4sTfTG5emOT05P4VQpDNi+k8=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ab41538192so87258a91.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793119235; x=1793724035; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0vGOrY3CisGPc8VMRVO//aXg6OQh93vx7xg6bEqOVs4=;
        b=tl3E0Xsdyt5Wj+IaE+dSuTFcWiyGoJ0lxJiYZEp4O/nMleD+QAf6bD+LkV6s16rPYV
         YiHE4DOLi4Jo2E6Zhorn8pbhg/3xEsxZP9sJRZ1fAv8XRsVwiV5/RuYw5z95726/bxq6
         Rz29p6h9b57j1PKrLVLIvsqI7HwFjuoC6wjlk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119235; x=1793724035;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0vGOrY3CisGPc8VMRVO//aXg6OQh93vx7xg6bEqOVs4=;
        b=Wil/3GBYFFj0VaUqfMwf2/wdon5V0KF0TJz5/EgS10wqfuh8WcQIXNm6cTcTM0l9ov
         shnb7KmIFnYo3vPEraAymzwHcuqZotzfC+jnIe3WvYkBhe6K/xrmyF2lhlWiIJnaYafX
         aUUCoWS5cw4x7N4laM9jp3P5mpmhRUR2LEt6Sz5HgorudeuV9l/XlfCSGdB+S7MtbqDj
         27MY7VV0uYWlAA3BPah9RjQ9DgNmw2UqS1Uvh2lmh6Gsp9VZ20Etvj2pcOx9w8kZOp8m
         +Gof2lTC7LRoZI9BP47AIZOH7C2nMyrKka+1/g63yGm4m/njtMRLaSCJUv5ibSN8gTpY
         F4uA==
X-Forwarded-Encrypted: i=1; AKwUvBxm3i3/Efj7nn4b1M7BJ1lhubhMlRPEKPHtF2quks9JewktElcIy/KsBXm166l/VAIHP5MmMpwciw==@kvack.org
X-Gm-Message-State: AFq9FYJaMm5n+j98qAKwY43PpbcvCp6qBQNNkTnqHX6i2Ut2OUI/Ir4s
	adqwDdR1JK1QKgZjiWwCLEYs8hnTzvQMibSDqfYOfVrWtAO8KFXPpxPNfEfHWt0veg0=
X-Gm-Gg: AYBFou1uflaA/jEVsWJ3WjlfRyA9U9LukyE8Wpegsbvr97UoQUmlwOVfaZykyhWhDT/
	E+B/W9xjJfsORgOCMAMLZu+/9YwXffBgIN3MDEgWg2CL7c7i6vKWz9WWF2ODeqRtekpfNNBzvpy
	Hw/k0X9SxD/WX5yGM/WNTZ3ZXvPqLcE3LR4Rtxus65CwoFv3VWBG/pQug7Oxf/6XG1y2Typ60BT
	8gEweiCZZoa0JjKdA+TuW5mj+9JcCDd8n/JKfSvIpR35d92qxR/U/opsy/AX7iJtKiTLO19NNpW
	YudH9S2BoPwhSwtVQIYT1qLg/e8JZ/kxC253oQ52f01B64LLGu+W/f/AgngLu2DP8fnLuupFuul
	98vDeBRvPZW0bIffXAQmDwuYxHTda82W8Tvtyp5UlzZZxm5rBMxpTiMmj4kBT2uzwm2gvm6WANa
	pcaq1R3bzE/6V2m/AeCDMbunAUR2jveeW9CKFv4K6O0r/gBRpK87mmznFYV8fiwNakeV8rt/A9v
	UoMXcBB/rtU7oJMYltoLPIgo8g5PDQtRmj1FR1TSz/PjHRz99YAYP5hANS4gKxjbECwkHwpgYqm
	dhGDavPisIJwGqYUQd9mL8UcALEOh4we/jmakA+Dd5kp1KR5tyVIAll97tyz64ht3lKGJj2iznv
	7usns/vSrfLyAE9ikPcOKXl6I74an4trcZ12gG5p9CJuvmTmJ3a1D0Gj1WwunixkXvEZRrBr5aA
	==
X-Received: by 2002:a17:90b:528a:b0:3a4:b061:2765 with SMTP id 98e67ed59e1d1-3adead57da9mr8291010a91.15.1793119235223;
        Tue, 27 Oct 2026 09:40:35 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4066d631sm4569992a91.17.2026.10.27.09.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:40:34 -0700 (PDT)
Date: Wed, 28 Oct 2026 00:40:32 +0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>, Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 3/3] selftests/mseal_system_mappings: Test vdso unmap and
 remap
Message-ID: <auDUAN9xAQRQhnCo@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name>
 <621847973ba2ec49d0a58e0261da35a9f3a97eda.1793094611.git.chris@chrisdown.name>
 <auC7_5XYr31fimvL@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <auC7_5XYr31fimvL@gremlin>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E523A000C
X-Stat-Signature: hf35ur7tqgwcy7iwagx6nx31jo5po9tb
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793119236-769113
X-HE-Meta: U2FsdGVkX1+VYvFXq+bfrgae4OjJ4eSiQG6KsqZO9Yh0YEylBHqnJpHsc9trkEcADHrzm0TZlidn69Md6F7gGtnDWsEgodwjewccrzXKg7htEOUUn1VQEwL4Ypy93TdGQteqtnDPqr1dptcUOr7tdDHNk/XJHDvc9AdcK3ls+S2AmKGMhy8TxjzwqepMam/XHa1Q5zRHqdfe5cG1ZumGeLLB+GxcZoqMKVoT0/wCDytPbTUo17X2DKIl/2GQA+5Z0gQBxr7SRBIVCH6e8Z4wEuTW84gcOSxdyIWrmCv+6Leq0CrfCNPEhE2DvAWLQUDa9c/D1xcxnVinqdpVSB42b6B6BHn9YmgIzrgHcUf4+S27vR6zB0b8YFhR6k6bCId4bLB4g7tYcvds0+pIWwGN7anfb3CHzz9SECXrWh+xh71LoidHKzBG5AZligeroL37hKEgshFA46iaM4GvE9mPW2eGD34OaeFGwUk127aQ1Gon/i/JYJCb+2e7axv7ckaDMU0j7m4xEQ8WzgrWpeRvO3Lo6CTas3ZrTaH57OcmNbU2JjMVJPxi6oPFEMSScfaMjjkJhMz2o/6UeEZcHOxyF6O1RENRbHh2pIeqn/zS96Cnc0Z0nnKOqrOhaDqA0FYr8JIweutZpyg6m0gEFpalmYMrLUWix9x6BrwtWkpHrx2dyCHPYIJRXpinqFhllTbbsMy6xWBxvFa0FZfhG3JxQMH3uIhF87lzbrVMcM4VNbr/FF7s7NOkQqJhFBM7F1Q9K2OWegDqJgtXU9wuoyAFD8rEXI6TQuDa6JkKd0fNDPzUPBgyJ9a/Rm+kmwlp9FmE1Hcz7VKit/CodfRIFAHPQ21ov9tUa5mmXrJgl537ntFSJ317vWgwZFQS83RJQV9NBJDyK3KATfEzhDizz5UOtJ7GfjTfioHoVBABVVyKQTJrlolO1Th6IedEJQfAYDfhNnujlLkXjNviCW/AKv6
 SDyqHjcs
 BgSr86HGJ2sliiQ3qQbw86T+mBwHDtQASpuhOndYA3QdvWLRuCEb4w6gMNN+u68UH9W1NLAUB6vsKsW6RvhO4mE7BISTEHI615CPuhM3FpxDQxwmVMi99slNXss/8+1aHJXdInNZX986H8sy0MKb5Efdw8mKXHAIFlKiPoyx6I9z1zbMn6p/H4wq8P7AzQA3rNPshHoB2pEE13D6fAAKSeW12ZUn3XeVnWls54ZrLtvWOCiPEroAWR3cHBP5MhPBRO4lf1CCFvYAM2ZaTeqUFipeisstjeWjb4I0HTa9Xbkr0nn433qCYnf/23dTCLZ3lVGDeOXZxiH9Byoe8eCwlLS8Jk0t1eKgbZnisIqz2UIrIBdWz9T62Oxsj97JJ1d7LElgjwlT8z4Cn9N1XvvB3Zgqdn5GuoeTiF6xr5ep4ZrK+pud0vjMN700E7haWw6ZG28/qSj2fOxwN5IlqqTtrb9xywBIJ/kOQl/mBJl8uqrcel6LdyfImrR/47aBmn6Bq9cH6bzDyCA+kx+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Lorenzo Stoakes (ARM) writes:
>Sorry, in mm we require commit messages. Even for tests :)

Sure thing, I'll add one.

>On Tue, Oct 27, 2026 at 07:43:25PM +0800, Chris Down wrote:
>> Signed-off-by: Chris Down <chris@chrisdown.name>
>> ---
>>  .../mseal_system_mappings/sysmap_is_sealed.c  | 92 +++++++++++++++++++
>>  1 file changed, 92 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
>> index ea75ad537620..83b4fadfbfe7 100644
>> --- a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
>> +++ b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
>
>Why on earth does 'mseal_system_mappings' have its own directory...??
>
>Ugh I don't know how I let this stuff go on the original series :/
>
>Please, for the love of all that's sacred, move these tests over to
>tools/selftests/mm/. This is an mm feature, for our sins...
>
>You can do the move as a prerequisite patch in the series.

Will do, I'll make the move the first patch.

>(And, again, I really do insist on your change doing some cleanup here as
> well rather than extending this stuff.)

Yep, see my reply to 1/3.

>> @@ -10,6 +10,7 @@
>>  #include <unistd.h>
>>  #include <string.h>
>>  #include <stdbool.h>
>> +#include <sys/mman.h>
>>  #include <sys/utsname.h>
>>  #include <zlib.h>
>>
>> @@ -232,4 +233,95 @@ TEST_F(basic, check_sealed)
>>  	EXPECT_EQ(expected, sealed);
>>  };
>>
>> +static bool find_vdso(unsigned long *start, unsigned long *end)
>> +{
>> +	char line[MAX_LINE_LEN];
>> +	bool found = false;
>> +	FILE *maps;
>> +
>> +	maps = fopen("/proc/self/maps", "r");
>> +	if (!maps)
>> +		return false;
>> +
>> +	while (fgets(line, sizeof(line), maps)) {
>> +		if (strstr(line, "[vdso]") &&
>> +		    sscanf(line, "%lx-%lx", start, end) == 2) {
>> +			found = true;
>> +			break;
>> +		}
>> +	}
>> +
>> +	fclose(maps);
>> +	return found;
>> +}
>
>There's shared code for this kind of thing, please don't duplicate a
>/proc/self/maps thing if unnecessary. Also there's a nicer ioctl interface for
>all this.
>
>See vm_utils.[ch].

Oh thank you! I will use that.

>I mean arguably this is an mremap test that belongs with mremap? I guess
>debatable...

Hmm, I'd lean towards keeping it with the sysmap test, since it's really 
testing that the seal is enforced on these mappings rather than anything about 
mremap() itself, but I don't feel strongly if you insist, just let me know.

>This all just seems like work that should have been done in the past when this
>feature was proposed, and doesn't depend on your changes at all AFAICT? Maybe I
>missed it though.
>
>Valuable in itself, but probably worth sending separately as a result? Otherwise
>it's a little disconnected from the actual change you're making.

Yeah, it doesn't depend on it. I can send it separately on top of the move if 
you like, I just don't like touching things without tests where possible.

Thanks for the review!

