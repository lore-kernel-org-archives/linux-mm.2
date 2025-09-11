Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A7BCAC58F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1C38E0005; Thu, 11 Sep 2025 12:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9518E0001; Thu, 11 Sep 2025 12:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF208E0005; Thu, 11 Sep 2025 12:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1708E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:54:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA7BC1A052C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:54:53 +0000 (UTC)
X-FDA: 83877568866.21.3A481BD
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id B08FF4000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:54:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jHBCWvs1;
	spf=pass (imf07.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757609691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfboHB9qu5xk51JT6CFCORwu42mssq00krwKtD4BSs0=;
	b=ltmkupgasigARgDmPqsSQ3ZMLqxI/JGvGsNsZo+2GEjVx3exilOfxGxeMAx7RzfeiWxhCx
	IKFtzWGEfo5UZvHzk9GQg/JgZmdmaAWVlNjoe4x0jGQneUeJcOsB1wxog5Tv+vgjtkjciL
	LDXKXylnhEg1eW3BCFUEbA8XQKfMi20=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jHBCWvs1;
	spf=pass (imf07.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757609691; a=rsa-sha256;
	cv=none;
	b=GAyyXVhmdn7IycAPKPvC+bf+6fOHfsNZlcrIu0WBnUuqiBuawcw9S+fuTcSkmKvOh+0p2b
	yJLBrlUv2jEtGMfyDq7Pa3RGGynUWkRs67Qnnue1CwqQyWwj+ynVeRIPV2ynjIR77snNWC
	Oxndm7mmtsdqTicWgFuhZV7A1+r7Bg8=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-570088480f7so47958e87.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757609690; x=1758214490; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bfboHB9qu5xk51JT6CFCORwu42mssq00krwKtD4BSs0=;
        b=jHBCWvs1R8wRQnUHV6wSWgImFApNQkxcs4J8DUM7LVvotXchjVuTHpeomT5V7dXDuZ
         hSfYdVok5ddgZ/m7VRiSE+qxuF3aASgZ0MsPtvL15WUAVu58oRnlnwnu6kQ4GAyuMoAy
         gyOo991+4o6lHjN/hLo3n+1f4TB3MFena64jgKh7Cdx3j/Qu/+zTooPPgo1csA6TqE3Z
         5XmPHUIJSbFMDhYjP5Vq55ENo4hsOEEf+LvX7tx1UvzFwXOLBe1PAboP8czD/steaR4W
         VwQo5ngTqJf5XT28HvMTLg06n/yfG2TtPOGkgt4NkAUAi0ZVCOJ9Os3cHKZ/fBpbkgaK
         8Xhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757609690; x=1758214490;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bfboHB9qu5xk51JT6CFCORwu42mssq00krwKtD4BSs0=;
        b=t70Hoh7fuh4LSczso/kfN1HR8pRxDIFodDoiUqjrC4tDxUb4OOx7l1VThD4K55SLoQ
         TY2AX2WnmMDtutXXPf8J6qNaZ0rJB7jLEls+NBBFINrnMhJ1anPadUt8DeW5Vz3b7KV6
         aDIv/+1O197OrQI3goFWu9mfplrFg4+b6U76rOJulUmB+LCe6mpNI60/NWpDWRezED7w
         VcN05LWIMfKoQHDyGIPDS4J91elwpmLWz39MVHfg4tXy0oIB+MpyEFumT4wtMEwWckVG
         OW0mpSQmb+oMaAfpLWE55kf8QbeKuNPi2PeCLyrfB0WpU4VISeGbVKIpMzK/p+XJAqEC
         MuKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMo91I+bUAl+0iJowCL4In1+9QrGQjvSTl4elK4BRv3Ft4k/EeNbDX2kxRdBUPAARhUyXTYR5A1Q==@kvack.org
X-Gm-Message-State: AOJu0YwTAFeJRxe/j02PG6NbW/3Xq0hYXSHjjq0tkVZftr7YY3i8f9WW
	BUp7s1wClBJr1B8kVDYE3SV5rDSDc9uYcmwDVc8p8OibNom7RFipiYek
X-Gm-Gg: ASbGncsTD6nHkJ+hCAUHev+z8KzFGb7041FTrrixDiBFu39xsLkWmJgxwQpENrUwrTr
	MZtnitmf4IdxicfTVYLjQR4/LRu7yKCszL99U6g/QgGuLkgpursQhx/Ld/3xJ4axOnnMCJVduFd
	7h08X5JIRhAP/kZbsvf1jV0AYP6NoH/g6cuGQpSsId3FkJRvgQ2/qOoLhKffDPrV2/k7nw4qO9m
	9csP1nc9D8KyNYO2Jc4lGCxZi1i31St7kuJdU/lZNNjfFukLxU7P7hGvcrUeQrEP+SMHhwqw7zG
	tjrhgTuwuSBkc9EL/8CnIpuqLJq2wDJlmODAOaqg8kQVQty6Kn+1tEl4w2tyobSUlmznIPW4woU
	6pSvawzT9chn8Pch+VsV2UWXAWVrGSnhzpkh4wXmTpMGvuKOOTA==
X-Google-Smtp-Source: AGHT+IGXwBdnwsXC7werXS6c6WUS/jEPrEOGwp0IA8NfmoP+ydSr3eKuUztbpRmkqaooT6lTRRravA==
X-Received: by 2002:a05:651c:19a3:b0:336:527a:5b45 with SMTP id 38308e7fff4ca-33b52b71534mr29335971fa.5.1757609689465;
        Thu, 11 Sep 2025 09:54:49 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-34f1a8211d6sm3931581fa.43.2025.09.11.09.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 09:54:48 -0700 (PDT)
Message-ID: <6673f66b-e854-4502-bfb5-4b46b16fa457@gmail.com>
Date: Thu, 11 Sep 2025 18:54:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] kho: replace KHO FDT with kstate metadata
To: Rob Herring <robh@kernel.org>, Andrey Ryabinin <arbn@yandex-team.com>
Cc: linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
 Mike Rapoport <rppt@kernel.org>, James Gowans <jgowans@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Baoquan He
 <bhe@redhat.com>, kexec@lists.infradead.org,
 Pratyush Yadav <ptyadav@amazon.de>, Jason Gunthorpe <jgg@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 David Rientjes <rientjes@google.com>, Pratyush Yadav <pratyush@kernel.org>,
 Changyuan Lyu <changyuanl@google.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, Chris Li <chrisl@kernel.org>,
 Ashish.Kalra@amd.com, William Tu <witu@nvidia.com>,
 David Matlack <dmatlack@google.com>, Saravana Kannan <saravanak@google.com>,
 devicetree@vger.kernel.org
References: <20250909201446.13138-1-arbn@yandex-team.com>
 <20250909201446.13138-5-arbn@yandex-team.com>
 <20250910165010.GA223810-robh@kernel.org>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250910165010.GA223810-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B08FF4000A
X-Stat-Signature: 8dwpoz83yyyaxamnyue56zak7fgxkcx6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757609691-207106
X-HE-Meta: U2FsdGVkX1/u705xu68ekiAUVQO6xSk9lMUoREs/ajTGes8a8g9kGLv6xJx+84/8lKUBR78RxAEKtmZPKe2rpibl2toVsouwrRnhgyLJVfpdNl13afD/77ASVzb8aQBR57poBqQYIVnwSNp7nnQ9kt8fmtIXOx40+K1LsP0Fi5rQFhAvWPCMcMkYyXM2BjiGtofgTd6EFUaX62QDTd6RH/fSKV0edGJznroUtxIzVdzIBbNoRC4BSzE5FJnUa+AHMnPjDMJ0fme5QyBsvfQN/9JJHO/sOH/mhxkmx8CoDHBNnz+WnobhA3bvOd3Rj+0z/zvYZedqLEJVsI0wwx17jxZljcxPpfAsuHt4kUNWDQxnXrU0LAPjn7uHDc9YIDoBrI6tzFxPkrLPrB8c61sCZxa7jCs/gV4JSiF9Ys11rFP83sCEx2vpY4xuAHSEtpbBxaALvhig5zOlMu5U2ThPQS/aSULuBwVZuLJPK4Vx2bBieyee/EBQq0sa8Zx8eODXKvDPksqyQm39N54xMbASwPynML9wbjamoatnOipbimuhhXqlIoWaGIk+UAbm8u0d96VbPkiVDDskkxc/v6HapQX1IxBGSHS1hd1UdQQq4DdHkMA/e7VaCb/2hkHBY2Nlpym4bMOjL7jgpF/YojNkd6oWy2bfbMuqHZkvcuYglKZaS/Z5ctHKPh/pBOJdbxg0+aYFe7DC3EhR+DxECfD/NWAq4UKE2OLGWOYy0f5dKrCVWKfge9op06Fti3VScqNb/2Vz03l15e3hpWCZOI8A21Q3vIQHZIuUemNHj3XJZ2NQPNX16GaquP4YhpaVQ1K1xQUx0uePesdmiybUpRVd/rOtpZilsV+h8ldkmEp1KucWFsc4nNsIaLaNs0Od3KVIGlq3HuQCleZdLniNiyKDsx2QusydfD4+/FdRUp0j1Fal6DxzM1KLwdszYLjfLcGeb/I8IxVUIu5wgMMEkCK
 KflcObbB
 pB5gXT9pyCgnbAl/qE/LSrpoJTTMPWtvd7QukDmOuMMAS31pfBHtiFxTJRjwcva9PfTLZ0JQY5ThmXwx7blnUtUMfomlTvIvLokNWJg5Qb4LOff+TBcltMQadx1RzsHr1tzUF20sZ6Xfs77qR1LgzixPpNnD24MFr7urvtpRrQAEYzlmEaq7P2tFXOa41tVdPt8un6Xq2mGni67xPeB9Ddzol9vTSWzvSiR1wWxi0ykyW40SoDkhz3xeXnKf+PAX/tRA6zPBrlqsqXNilERRGZGE6BfitcvqrdIpv1yj0yxaD6RtIPMrdsNTHnHahm4Tdfzmi9HrYOrczHn01aJBD3/HDRCKfiENf5eSENBXuia3noFo3XcQr8PIQnMNvmE+UBhsnRbmw6arUAaNFb7NGIzsdkJuhpRiYpt8zOGP5ttIiv0LjSk6Un7RwsBFtaIAgZySQ0Xiu2Rs5YT0JZ/jIoBZIMUIG4iX4syN/7HtwrXOB4lZVJBYEjrir82wqIjKiJdzNUynDfVnJlXvPnLa/6RsZhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/25 6:50 PM, Rob Herring wrote:
> On Tue, Sep 09, 2025 at 10:14:39PM +0200, Andrey Ryabinin wrote:
>> Store KSTATE physical address & size instead of FDT in kho_data.
>> and initialize KSTATE from kho_populate().
>> To be able to use FDT in parallel with KSTATE place FDT
>> address&size into 'struct kho_fdt' and save/restore it using KSTATE.
>>
>> This finishes wiring KSTATE with KHO, making it fully functional.
>>
>> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
>> ---
>>  arch/x86/include/uapi/asm/setup_data.h |  4 +-
>>  arch/x86/kernel/kexec-bzimage64.c      |  6 +--
>>  arch/x86/kernel/setup.c                |  3 +-
>>  drivers/of/fdt.c                       |  6 +--
>>  include/linux/kexec.h                  |  2 +-
>>  include/linux/kstate.h                 |  1 +
>>  kernel/liveupdate/kexec_handover.c     | 60 +++++++++++++++++++++-----
>>  7 files changed, 61 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/setup_data.h b/arch/x86/include/uapi/asm/setup_data.h
>> index 2671c4e1b3a0..844f5b93473f 100644
>> --- a/arch/x86/include/uapi/asm/setup_data.h
>> +++ b/arch/x86/include/uapi/asm/setup_data.h
>> @@ -83,8 +83,8 @@ struct ima_setup_data {
>>   * Locations of kexec handover metadata
>>   */
>>  struct kho_data {
>> -	__u64 fdt_addr;
>> -	__u64 fdt_size;
>> +	__u64 kstate_addr;
>> +	__u64 kstate_size;
>>  	__u64 scratch_addr;
>>  	__u64 scratch_size;
>>  } __attribute__((packed));
> 
> Isn't this part of the ABI which you can't just change.
> 
> Rob

Yes, it is part of the ABI and layout of this struct can't be changed.
But this change only affects semantics of fields, layout stays the same,
so this should be ok.

If we kexec from an old kernel and kho_data contains FDT address,
the initialization of KSTATE will just fail and boot should continue as
if there was no kho_data at all. At current stage of KHO development,
without real users, change like this should be fine.


