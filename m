Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DD1C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 07:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223076B0088; Fri,  1 Aug 2025 03:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FAAD6B00A9; Fri,  1 Aug 2025 03:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110B66B00AA; Fri,  1 Aug 2025 03:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F216D6B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 03:15:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 725835ED87
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:15:07 +0000 (UTC)
X-FDA: 83727327054.08.FEC30F5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id E2F9640005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:15:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JxaNs6ww;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754032505; a=rsa-sha256;
	cv=none;
	b=1Tg4H2Vb/WOB1VZREN044Qqa90hGQymUFE0AUX0UDM5dXNZbIQLlX/Tjj96qfmh6GwZC4u
	0uFM+JoW87wRKqrWnL5jy1AwhgJnoS6OJEzQuU0hD0TjS7p/YgnjbbriFCyAtkdkIZTeSU
	fgEIK7aSws5DinW0UhakkMql1vDlsus=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JxaNs6ww;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754032505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zsP++KTNUaPodvSH4cDflu0en1lPWroDDUWAbpWBvg=;
	b=3y97GJWt8zroJIt0W/EOrsy43BFSDMDDOrzKLEKvue5qInmQiRNKmuBUOLx/ZYHl0TLGrm
	4OHlB+4uY6YBXarQfZrkmWBx+W18335aSegNisxQNO9u6k1E7lxbnEYvNBuSBU3fl3ftCH
	9ci8kgrdoJHThHkntHq66CdCJZNwHco=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754032504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8zsP++KTNUaPodvSH4cDflu0en1lPWroDDUWAbpWBvg=;
	b=JxaNs6ww4KWFXdZTg2CZ72v3ZTbUh3acBQ5ctywpe0GPgzXBjVthnXojDG/PcjVe8getcR
	dGJGGm8d1eNZpfIqwZCSDHpx7xdmZskDuKFV7UOcwCi9Ix2kuimWBcB+WyPHlkyWb+RYwE
	4DAWqwLLXcfZg5fz8O6JGUGdzDRMi08=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-doUrBP4mNUmbxvCC1WVBng-1; Fri, 01 Aug 2025 03:15:03 -0400
X-MC-Unique: doUrBP4mNUmbxvCC1WVBng-1
X-Mimecast-MFC-AGG-ID: doUrBP4mNUmbxvCC1WVBng_1754032502
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-455e918d690so13243145e9.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 00:15:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754032502; x=1754637302;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8zsP++KTNUaPodvSH4cDflu0en1lPWroDDUWAbpWBvg=;
        b=LebBbqlDoMmLEt6mrXfja/5zBuzo1VmGHhtpFmrYtdBzmSOEEYuHXVSiON6NdKPbaY
         yZv3sTMm6qrCK86662PYx8rQcxNLkbHPY2+twpuEPb8cYAD7h20xS5ccYrQdGADiRKD9
         cXfjiCj8VtwWCPbd67jwow1kmgquk2nAK5XwEiPU5lyzoN+FXk10Sjqr7l1/hzniXmFy
         Fwd4cisZSCglj6wGygBEJ0BtoRcx6q4+IzaHuyeZV87Yqn4/QA57I383WpKkFzuMFEfl
         /4u48u+zNhNpONTpMoqCMDOarbThzY8v8+L+soGk88BkpTCE5IwVmnfv/FAffhw4o3KL
         IeBA==
X-Forwarded-Encrypted: i=1; AJvYcCXqmOs1LcAZWeLeMuRmfQtpzNH+NSl2yXnOkFr7iqG2zgSi0kmpL+Ph6wXlxMo8sPnGVVP88BvDoQ==@kvack.org
X-Gm-Message-State: AOJu0Yzk/ovouZJ5SpCp1eY7XFAjMAh+deRpKND+BLwkylL2lfOBf7sD
	E37QfbfeAcgBE68AAxhLkpViWnKk1eNIQfii7V97YVKXO3WVOLvlHnog8hexKCQUW55xyTX5iyG
	dveWs1gWIRkHbDDAM+PtH2g6o6UQB79cgQ9EsodTztM2sOfQBc2Af
X-Gm-Gg: ASbGncvcd1BEBM85VRSDVmwTuhafehKPqFhu6WDEiim/TmmaS6n/OfrRnDcgQmL4PSY
	Tz2lniQRlAuCj4hNch44DD0PtuhjJJAwMpZSWdPq5PE/uwV7UKym+UD+SYe/H08UaiX6NyF2F+E
	2YgUQJ666YCPEY5gsLhNctY7quIwLuRxODM4oYbVc+5RlI93Drm21z5/Vz/C98CTccdxgaF7bQJ
	PI0XXsy6SDsvKdfmOJK3Foc0/pOtiIEZ2Gh15mqgTQdljCA6SXmfHfAWSYDYc3DBerx1ZttXsJh
	V+EAjuG/LauA1iy+VZTuVOkJ9sj8+IVRpNPH85AtPzPit3/Ug3fLo/Kf/N0mA158BEXJsA==
X-Received: by 2002:a05:600c:c093:b0:456:2257:3777 with SMTP id 5b1f17b1804b1-458a20032cfmr31372975e9.4.1754032501501;
        Fri, 01 Aug 2025 00:15:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqEgovPXS+bSOytnGo1/3qgezWi40htmY3CdWP2rI3GAwEe+kqxnaoSv2vjYTl7ueaCkadcA==
X-Received: by 2002:a05:600c:c093:b0:456:2257:3777 with SMTP id 5b1f17b1804b1-458a20032cfmr31372845e9.4.1754032500946;
        Fri, 01 Aug 2025 00:15:00 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fa24.dip0.t-ipconnect.de. [79.241.250.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589edfd983sm53298925e9.13.2025.08.01.00.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 00:15:00 -0700 (PDT)
Message-ID: <1f95e865-ee09-4ddd-b6db-f2092f0d4b10@redhat.com>
Date: Fri, 1 Aug 2025 09:14:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: pass filename as input param to VM_PFNMAP
 tests
To: Sudarsan Mahendran <sudarsanm@google.com>, linux-kselftest@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, trivial@kernel.org
References: <20250731201009.888945-1-sudarsanm@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250731201009.888945-1-sudarsanm@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bOvJqDxtMhEKdkak6pxQrzvZmH9jwno_sh-WHych6QA_1754032502
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E2F9640005
X-Stat-Signature: sefp8rkhhy5paycf5bsyu4ajktyym86k
X-HE-Tag: 1754032504-249128
X-HE-Meta: U2FsdGVkX19hIly9ahTt0CDoKkULIvJ5nJmf9Y55uLTiwKrItVKs/Uy1hVdlf9dRv9H0w7PptUiHCllwSvHePD8whbIptKRFHLxTU7Dgq9D4Gtt1odwyrdJJ0UtOwmsurMEofyXByIFniBcE3AJFahukqCgq9Uw85hzfXayCiFvxmtz7v7uMzCM3YulSy0edLZ9v3A/LkI0m5AGdikysCvMNgK36zWUnpiAIaKLaofO03DQdNRsZ2/gHkzbh6V2/VEDIK9lV4sG1RuRhk+dcJp8ruYKylbppQ75XRlTqaTIAarou1CZ+e3A1jIaWpND+5hYymVcjZK6G+bj9RnUq5H8tliMro02T3wdRVGp/KVx48ZlumsGDxhzPx4JqPho+hCKz6DHfGyd9WYgNNDkJIn2rVcTLgBKTEty1utSKKvLYMrx0V5nhVkqerp5h3wUI/olZWToRLBQeLuMn4c9UN/ego7HL39Qt4+d6KB80jtwhMKG9ktWnqw85o6U3HRr2LnOs6dvqIoVrdi9njEG5jtD/PrT+Vgit8aRRwrpuzuOnonvRj0jvtaneyhCmU25LNTnjfAT9CNuYSMfuoUc0fUyU9LUh1iaZ5rt/oBOHwQYH2+an3fT+KwspQx+xmqwWWj47EiHb3T+ZC/ZI9VtworXbN3jSckimR8s8wQ8eLcmGFGO/noDY7OPHMPaiXRuBRB5RspPrd19NmFODzpnP9TgQKBXi9wWEMrjfy6LtkIw07rovIHTQslr157p0WX78j1sD64z2UHrxhnd4Om3yTUm4ZsO2AC4zYe8ns2q6ct3jsHxEUBp5SWphBQflmzmFzdlFt6GKnkLwOGpSqzTdBiPIRM2im7EYUvHdDoEa/wmQUQN6z+B+7g5mp8KhtOg5DTE/YS9uuISWUlvCIt5Ras2YZbBd7Ms9taWIb11B1xkc8u/WlUDrhdpxHra0lWamNFynP5aq90RREAhTXkv
 07XXMrA+
 ltTfp5Fqlh3BktefI9+QyaiFuMtcGPUjzg8FC95V3biTZmUEjaa/LOrSPNs/etAAP0haq57KxCn90QagfeXoqCDWrYo/h/Qrq08OSXg4M7RM+eJub3N5w+FcVDgmch42ZLY7Z3U6N3WrvwlmNLXZ6qNLkmmVonrx/RwRy9sXERxVsUMjbuyAh0mhsOGiwBIjQZD8rxFrWC41yvHaHByxu5We3Xz2UU/IP/LsaKsVjmoUssbBv2nA73BuR4rJ/ikArx9bfiMj0myyK7WgbZkOFKT/OXOa7SEbi1o4k9pyPDAJUhO1Fj5VLSvDsJeuKidxus0G3k2Fzp0z6CbWhwCRsuc/+vnJCSmMM1Y0BU/cTNqi+vqJN1INGbwVgqbqRfcu0rwIFo6DvLTD7pUyqQJ7IEXHCfRVrIpOPD1gwZA0ME/LkqzMchvcIYv5S9YtB4c2W9Ee32CUo8sU3sC/DYQA1QiCwVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.07.25 22:10, Sudarsan Mahendran wrote:
> Enable these tests to be run on other pfnmap'ed memory like
> NVIDIA's EGM.
> 
> Add '--' as a separator to pass in file path. This allows
> passing of cmd line arguments to kselftest_harness.
> Use '/dev/mem' as default filename.
> 
> Existing test passes:
> 	pfnmap
> 	TAP version 13
> 	1..6
> 	# Starting 6 tests from 1 test cases.
> 	# PASSED: 6 / 6 tests passed.
> 	# Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Pass params to kselftest_harness:
> 	pfnmap -r pfnmap:mremap_fixed
> 	TAP version 13
> 	1..1
> 	# Starting 1 tests from 1 test cases.
> 	#  RUN           pfnmap.mremap_fixed ...
> 	#            OK  pfnmap.mremap_fixed
> 	ok 1 pfnmap.mremap_fixed
> 	# PASSED: 1 / 1 tests passed.
> 	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Pass random file name as input:
> 	pfnmap -- /dev/blah
> 	TAP version 13
> 	1..6
> 	# Starting 6 tests from 1 test cases.
> 	#  RUN           pfnmap.madvise_disallowed ...
> 	#      SKIP      Cannot open '/dev/blah'

Now, if you really just pass a random *actual file* that exists, the 
test case will not actually test what we want.

Unless you have a way to verify that you actually get a PFNMAP mapping, 
this extension is questionable. It will make the test report possibly 
wrong results when wrong files are provided.

I think we can test whether we get a PFNMAP mapping by looking at the 
flags in smaps output ("pf" in flags), so I would expect such a test to 
be done in pfnmap, and the test should FAIL if the file would not create 
a PFNMAP.


But more importantly, we rely on "/proc/iomem" to find a RAM target in 
/dev/mem. That doesn't make any sense with what you are doing here.

If we are not provided /dev/mem, you should probably try mapping offset 
0 of the file.

-- 
Cheers,

David / dhildenb


