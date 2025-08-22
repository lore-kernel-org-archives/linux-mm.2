Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7E8CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 10:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F838E00A0; Fri, 22 Aug 2025 06:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6E48E009D; Fri, 22 Aug 2025 06:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D50F8E00A0; Fri, 22 Aug 2025 06:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 579EA8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:08:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F32181183C3
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:08:15 +0000 (UTC)
X-FDA: 83803968150.13.1EE994D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6A350140013
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:08:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PUdpOv7k;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755857293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUnkbTSabMcbQIfqW2wjwFOAR821LvcoUL/CideIRuc=;
	b=cp+juoYvQ2H8NIwzHDRb/iutEJOztbGb06HB9gU8Ne3fjAPl4639lIeNW0UUyK/6AXI5hM
	S07IMkIz3qVCOqhoYzEUvNfJaYfF3qHgLUihkq3VjHayzaSLSqyL03utytMrHW3UDNbOFP
	l54Hxlu5H5tQRDhPjzVz0zuFxl0ToFY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PUdpOv7k;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755857293; a=rsa-sha256;
	cv=none;
	b=iG4/Fvau0ApI640wEMB+doxYpTHktLIYZvG0cSUTVzbhdbgnNx9gUQs9+jDy7190V0k++2
	CGmuWt+RVaK6eqeYl7OUUXcmcTx2HyTAqJmrN94coymZo8Yj9ZsXLcb3zvRngkU1+Gqqr3
	aHqUHmo9HB5BS/vX9rIYeEPqqFfawRc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755857292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QUnkbTSabMcbQIfqW2wjwFOAR821LvcoUL/CideIRuc=;
	b=PUdpOv7k7EUuJssI2o/53gkKHGggb+1ddlnr4+zWdwQjQT99AYJfM/34zg7sTQQcj3NMT9
	PilUItTpunniHsW5e47PfYLk+nhyzGJxKYmQezKTWstvyevPGiedS+CSp3sbZ3cqbCFXE6
	Rk5ISgogU7rZ1Q7kCHcs4bzAlPcFeKE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-cUekG2shMvqV2khZPMfISg-1; Fri, 22 Aug 2025 06:08:09 -0400
X-MC-Unique: cUekG2shMvqV2khZPMfISg-1
X-Mimecast-MFC-AGG-ID: cUekG2shMvqV2khZPMfISg_1755857288
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0caae1so10165235e9.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 03:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755857288; x=1756462088;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QUnkbTSabMcbQIfqW2wjwFOAR821LvcoUL/CideIRuc=;
        b=j2f8bEWDFXXJQzArewdEZFVrdZlgP7DF5yum74c0AOB06amEOytzlhn8O4yZdqNMlo
         RaZD9hBriFvOVNcuJjgSipvYywLv5ECpNkZsnZqVQv2dF+4JDqM5Dk3p/mYFi9X9e7bX
         S04sPIM2lOEwu/Tdk0gChhiWOzgarJ8m3HGRR2QdG4yvDPVWBW5ee+do4aKhwnwyFmiK
         Sg4F3QBZojfbC1qa6VbR7B4+Lpxy6ZRVwnLgqN8ByzfsFEpm4FmDccFoRBXnAz7t3k2N
         wZMvCz0zncDYV6zyytD62u5/Bb1EZKD9tC1f1AjjvH+gKUG5Qk025ernBqueQsGwOwm7
         m0LA==
X-Gm-Message-State: AOJu0YwswhcOzvwX0FdC59W5o9bbnAJ9LjBzEs6pu46TquZlP8Hm5BwV
	Od2WvafhNKa+DJJ5nK4aA2fwqRaR/HZVgfCB+R6t7KywGQg1ZhM95fGIzNpNTBPgLNK09F0JRlX
	8+m0XWlXIDZFzLh4b8C0uDTWM1bzwoyqPKLQLapUDEjT/zrPwt8nM
X-Gm-Gg: ASbGncuzWrzfbhqGv97s/Coh7GUF+qYwFaBlStgLO7LU+ElsxFE56tNtKQvdzW7hf74
	KEBUMdBWj6hLZbRdZlA7MFFUcBj2SehFkQLf0g38v2R+dqiF7WR1KmKoBJdiHEUlLkcDr6fPf7d
	hAUBn/rLbfFEqX1cMt6L8rzQcIPvx5yLPGBK/zblcaxe06tfoAsSWos/rMSp19zF4ibeQGlRcr2
	Vvs1dyMFAbD8BYuySuTKQbAYvzexKNYUBfIfIS97KDt69sEjWoMwnJR3yHr/kny+IKMGm0IVTav
	Dw6Bevrn/idT6MIq71Ijuq8vOXhwXbksG1LydY2UXk5lC4ORiB41uT47skSoDgO+eI1ziwwRF1J
	uTPFzWtlX6KkedAuTT/Annq8N25my/zifyaLBB/kZ04nc8FDgV13goQ1/pXrt3u+DXOc=
X-Received: by 2002:a05:600c:4f8b:b0:459:e398:ed80 with SMTP id 5b1f17b1804b1-45b517e9de7mr17371935e9.32.1755857287906;
        Fri, 22 Aug 2025 03:08:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/I2g5Hwlv8A5Dsi6tWz98HgDHMBLctARhHYJlNSxF7aASwtTM7voaNtLhvwMa1MvPTFOctQ==
X-Received: by 2002:a05:600c:4f8b:b0:459:e398:ed80 with SMTP id 5b1f17b1804b1-45b517e9de7mr17371255e9.32.1755857287336;
        Fri, 22 Aug 2025 03:08:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2e:6100:d9da:ae87:764c:a77e? (p200300d82f2e6100d9daae87764ca77e.dip0.t-ipconnect.de. [2003:d8:2f2e:6100:d9da:ae87:764c:a77e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50dc023dsm32426085e9.5.2025.08.22.03.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 03:08:06 -0700 (PDT)
Message-ID: <f6ef7e0f-0b48-4028-ba79-4a5ec66e720d@redhat.com>
Date: Fri, 22 Aug 2025 12:08:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] copy_process: Handle architectures where
 sizeof(unsigned long) < sizeof(u64)
To: "schuster.simon@siemens-energy.com" <schuster.simon@siemens-energy.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dinh Nguyen <dinguyen@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>
References: <20250821-nios2-implement-clone3-v1-0-1bb24017376a@siemens-energy.com>
 <20250821-nios2-implement-clone3-v1-1-1bb24017376a@siemens-energy.com>
 <8c6239a9-8414-469c-9b94-a43735b4e882@redhat.com>
 <FR2P281MB15445D806CF865A0E1CD8FFCB53DA@FR2P281MB1544.DEUP281.PROD.OUTLOOK.COM>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <FR2P281MB15445D806CF865A0E1CD8FFCB53DA@FR2P281MB1544.DEUP281.PROD.OUTLOOK.COM>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E5keqRrEoLm1U4j5kFffuFq0fFcEwwiM7xz2keWqjFU_1755857288
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: or1bsr85nwsg5pkrooawwg5s87gjoj1e
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A350140013
X-Rspamd-Server: rspam05
X-HE-Tag: 1755857293-757121
X-HE-Meta: U2FsdGVkX18N29ubX/+WQqklMNF87Slw2cge6U6sejVfD8mX//Ul8DwEsb3xaL077lORJ58142T9WwwgkSigNu1BBl9UjhEgqt5tU8ETqNcgJPOmYYh/V9v+/zh1vGEyGk/y4YrkjC1onY9A1ZFzZssy3Td9D3Oz3pdYEgv940V9MLcyJw/d38Y/TCGKZqPhmyl6u62O45Qy72Ajop6utXsUY2w1vsRICAcvGJFLppo7fsxj0CVpIAeVjJPQLTzqOMkmmFQVKKaYIGSSjMO012A2uqjvS3uoMwlfoWhik6eNXzY5+gHE05MZMLhLR0zHFLsxabLuQNpxtXZM1+jvw9HVYMhafbhzN33LDbUTuPj34tq5yD6ZRZc2eKdHsPqA+W+0+DGi312QIz82+YBOwamSIz/2uumlAa1ZLaM3V6ZQA6HaPhTIVMyNlyE/puF4sZ1715a3WiJEV9bdAW0IfrCoT8LNLhX+YA9Iaxt28goaVf4szGQLFdPgOBnmsltvVEZxVoN+op1Ye/VAKEO7hCSgAU6GUmDBIdoKl/ZA/UCzN+kzoDCOWXvSeNbfUzphf06yK9WIwGPwzHpWZueUqd7XC8+IQRL2Y9tfjSKCrbn7VSc9/bE5TfvizsQKGK0HwrI2FRGGCN2Lp+Vqm5u+1rLecRjUb1P/HLmSc+UyiNTIsjoz782flAt6KhEwbT8CgQ+dfnm/lSbNexsCKfVhS50uPADPeMxVZH9kICn44CAb5yvF4oWeTXPo++7cPZCl91Qpgtv7iTUPZvu/js7nKEuBVmLfp4h4kYNy2v0djBwviUHO0e8UAvL1LGT+QVBF3Usf8x87cFJwcCS7ak0FcnG+KcMeWW56NV52IgjFNHY9mRb5gkTxcfQdkZzVKp+wqXkkXJwANHDYpLdvCY3xWF14uuythePs0nTukI1V+EMXFtKPipT9KFC0ke30fvXntesTrTh1XQ+e+Yrr7Pl
 8X6Ow74v
 A6x8lpnFoDNRGb/Dphnak7MSUxul1eIOXPT4BgmoVOo5fna5FTx7iSto+IZGcfdAS/qQFTMIMwWmE44o+jPCZdN7WdoRhTYx4pkxxOn8zriWHdI2/irPD2rqwQEqEympD+uPezhpfBAR645D05ERIwiF0NLxuztTXYSq1pa1wM+zxLgApG1h0j+kMCNyH9VNoclQBJGs2gDVPumtm/lHrzjcZpJH59QGi9C/3vBpKPsR8gUsSddokmh5+LO7U79OdNm/yEQ3kZYc9obAeu9khWu7y69faeQFZ2Ec2fQM2+4WkAckSv6NQbywfCvK3Pl0VxlkjJJYeIxdjjiTkNHucfoPxCSTvqmquv3XAIPgw69NA3KGNOazAED2g2qtbQLhMC21KVPaRppWK5Tvap96JXnDQaXT9IZEpvHKb1SMvhAQ0DMPwckxhhpK6ViUDUDKTmdcuz9frLXZUtex7qLPFqKRGaGhJ1jA1k1OeuQ0xpT2w3T+5bCZsO9Hz05bQ3gm3bPiLjqeoaobecidUolJ2UH+djtjGn7NkEjmBjVC6tZcPWL6BJqB9VPXLpSyfKkkoekda
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 10:52, schuster.simon@siemens-energy.com wrote:
> On Thu, Aug 21, 2025 at 11:14:00PM +0200, David Hildenbrand wrote:
>> Sounds reasonable.
>>
>> But is this actually something that is already exposed before patch#2
>> on other architectures?
> 
> I'm not sure, but I would assume so, as e.g., arch/arm seems to have
> support for clone3, but also seems to use 32bit unsigned longs as far as
> I can tell and, thus, should also be affected:
> 
> $ cat /tmp/printulsize.c
> #include <stdio.h>
> 
> int main(void) {
> 	printf("sizeof(unsigned long): %zu\n", sizeof(unsigned long));
> }
> $ arm-linux-gnueabi-gcc-12 /tmp/printulsize.c -o printulsize
> $ qemu-arm -L /usr/arm-linux-gnueabi ./printulsize
> sizeof(unsigned long): 4
> 
> Is the above test enough to warrant a "Fixes: ", or do we need a
> reproduced kselftest failure on some arch for that?

It would be good to describe that this would be an issue on nios2 and 
was reproduced there without this fix. Then you can mention that this 
should be an issue on 32bit archs with clone3 support as well, like arm.

Then we should add a Fixes:

> 
>> (I assume above output is with patch #2 but without patch #1)
> 
> Yes, sorry, that one is on me; I've naturally first implemented support
> for clone3 on nios2 and then investigated the test failures, but somehow
> deemed it wise for whatever reason to switch the commit order in the
> patch submission...

Right.

I'll note that copy_process() ends up calling other functions with 
clone_flags that accept an "unsigned long", like sched_fork(), which you 
don't handle here.

$ git grep "long clone_flags"

likely is a good indication what needs changing outside of kernel/fork.c.

It should be spelled out why you don't have to handle the others. And 
likely in the fix, we should really only fix the ones that are really 
required for now.

As a follow-up, we should likely better convert *all* users of 
clone_flags to use u64 (at least the one in core code), not just the 
ones in kernel/fork.c you tried to handle here.


For now, only the following require 64bit:

	CLONE_CLEAR_SIGHAND
	CLONE_INTO_CGROUP

CLONE_CLEAR_SIGHAND is only checked against extracted flags in:

* copy_process()->copy_sighand() and
  -> We don't use u64
* copy_process()->perf_event_init_task()->perf_event_init_context()->
   inherit_task_group()
  -> We do use u64 already

CLONE_INTO_CGROUP doesn't seem to be checked against extracted flags AFAIKS.


So I suggest making this fix CLONE_CLEAR_SIGHAND-specific and fixing 
only copy_sighand(). That one should carry Fixes:

Then, have a second patch where we convert all remaining "unsigned long 
clone_flags" in the core to use u64. That one would not be a fix.

Makes sense?

-- 
Cheers

David / dhildenb


