Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DB20CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7CF8E0008; Thu, 11 Sep 2025 13:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FFE8E0001; Thu, 11 Sep 2025 13:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596118E0008; Thu, 11 Sep 2025 13:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 488B98E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:00:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAE1716052D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:00:49 +0000 (UTC)
X-FDA: 83877583818.21.2E6CFF6
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id CAA44140026
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:00:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a5LMUx18;
	spf=pass (imf26.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69yPHnIsLNbjSOnGkb91deN9ujmIDIbQEy9l+ZyKWrc=;
	b=3FrEYCuEjxWnaYSBj06R+GoWkzRSQyUsiSQrT+eOT/XLFsNkI5mpU+YPb3XEckKrqN1UH8
	uPs+95y28ceDsSHL/QRbubUVhiqOpXEWdqaujKWaW7mvObzO+Te+ps7cpQpHkDOKQLC8WR
	tW/YuoJJ+uOb6VXzbX3DCkwM/MQlUJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610047; a=rsa-sha256;
	cv=none;
	b=tBoO9INY2/gBqP2YNEXDUAZI6EP6RRL5BhXxgQ44g9tThxFhdXW38N7WXm8WrFgrgybLeI
	MeMV7Ed9hstoycXGdNfNBayimJEd+ZPkmW9YZrgfPk3UIz9+XAF+Wtq08EwRNigI3+hkQw
	W3iJxzMzO7pVJtOVUULMX87sNLEEYXI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a5LMUx18;
	spf=pass (imf26.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5607f21c62dso106198e87.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757610046; x=1758214846; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=69yPHnIsLNbjSOnGkb91deN9ujmIDIbQEy9l+ZyKWrc=;
        b=a5LMUx18vK7dOiMDSo/6bj/K8bRX5KlFwpEBhVGlaEfta7BhxuY8LhsVNxcYKcvKNR
         Ixk631e0CkPntlxJhWnN7eXZtRVFrZQ0lRQP0gEjGWPY2dn8gf9KTSa/4rw+cO/ZZ7uD
         kQdvb4rm92rYIs5MMwLG7e3IKNeDMnk5D/xvMbi/q1jnenkF9JXtGb37Ld9Nw9K4725g
         NSyibAVE+MmM8pXN8HHWljlhvpxfQ8cVZPZ8wYXsovKbMr32FTO0p8luI5D/dPu+s6ZA
         vqABQOa3lb46LwIiZoK5ZVZX4nkUi194fw1OlIGs1jcbRzT9eLV8jt+90MfY2PT0WIO+
         MBww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757610046; x=1758214846;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=69yPHnIsLNbjSOnGkb91deN9ujmIDIbQEy9l+ZyKWrc=;
        b=cDBooPv3sXMuf2c53rYdWADogTEqIY64WqtCRVEPKHgiLCOfdZARtEaFdutQeg7pbH
         KTosxejCyDK/ROZWbeE2MrnHgVGlDzVnyuyqk3FZk1nH2EpgZUux4ipFqYLf9MMN/Y66
         cyryQAOnKM9iMwUsRsRf+3uHgXN901LDMdtZTB1xXCllNAToKndMbUWA3KzDRymNuCRA
         Ar4MYBRj64J6amgwv74wUgZFb2vE0Ohy2IkIWQvzDqFX6jlftkA8DfO1juetMOqPEQgu
         Z3aUapBN1b4UnP4jELwgCbkoLtGBA5alSbGaMaMP/5XGSh9ubNc63OBwwIIdNpNzFEDV
         oL6w==
X-Forwarded-Encrypted: i=1; AJvYcCWVDQG6NswStIRrjBXZjNBgBUmL6mxu3PGRqwuULl+oEWfC430+ZplmceQwwPos7qkRk9BtGcPesQ==@kvack.org
X-Gm-Message-State: AOJu0YyGDWv9zzkyIkusQaJRqTQXclEv/R9uQppmFnC913B2+L7rxQFU
	8dUXZs7NAxEvpemKgs+fztHlXSWTq68VgRMQOBsk/rAXYIY3UgH8Qztu
X-Gm-Gg: ASbGncvq5Uo07wHlGztKjs8U6R6Rz23h5zpJh1KuUS1c4OSLcxMx0zL2IfqEqDbogpV
	hER7UJ8UZM6jz1ZMuYyfmzpAttIrcdcepQaN4A2kFqlOGoAjPO5LbT3IL5aJUK0pvZZy4yDx0KC
	b3IT8WzGZIuHABD+8gT9ODj7pob1YsSvB2x6gs1kBHVVBhbqz9EQ07+AuAexSGWhLUKDE23KuEA
	hfjilCkGRFwitgGWZYwT1RuQWStePxhlfy7hVR+cD/lC2yrMRiwUXCiryokLjvB0YSYpEpEavvf
	MNc6vi6HzkgRnQrOWeMWPadRyN83q5nDSVGED1eaZhHtXvsxo0hupjEAArNQtsKmdvK5el6Y1qC
	xNcI8RGVbCCRjwZvLLFeGAYYlAPliKHe85IzSmZA=
X-Google-Smtp-Source: AGHT+IHnjKPKaFzoMDps2A1lwwHuk+aMxy5X6+2P1DS5X0ZAITIfcYgwM13XJrpIiuwwI6P6z7dSYA==
X-Received: by 2002:a05:6512:3da1:b0:553:252f:adf4 with SMTP id 2adb3069b0e04-57051f3c81cmr19486e87.10.1757610045703;
        Thu, 11 Sep 2025 10:00:45 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-56e6460dec4sm523403e87.103.2025.09.11.10.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 10:00:45 -0700 (PDT)
Message-ID: <9f548efd-babf-45f2-99bb-e013c810ef72@gmail.com>
Date: Thu, 11 Sep 2025 19:00:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] kstate, test: add test module for testing kstate
 subsystem.
To: Randy Dunlap <rdunlap@infradead.org>,
 Andrey Ryabinin <arbn@yandex-team.com>, linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
 James Gowans <jgowans@amazon.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
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
 David Matlack <dmatlack@google.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
 <20250909201446.13138-6-arbn@yandex-team.com>
 <1c79b3c7-5847-4960-9454-0c70d02a6441@infradead.org>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <1c79b3c7-5847-4960-9454-0c70d02a6441@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CAA44140026
X-Stat-Signature: w6kbmdj5i36ytb8k8iaprgxpqh17qtrs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757610047-996023
X-HE-Meta: U2FsdGVkX19i1S1AIdfk54xq/UOpmruhtX7aTSDNGObW/dfA4iuopwbpRwcIvh+WlO3ACQmbLI8bAXoNcLQXtEf20OaY2GXxHtlItOcF3t1Yu2I1vAybidja1In3qN+GJlQRvMVNihvgzwqyPRdMyUmq0DIxZEcfuy0A1V8dtTVYQWIosi5DQ+OjvQRHsouqd0TkfYKlCGi6KiLSJ6cbYv423qAGSWuulWTQVgapsjXcUb+Y06r97uVMK+9mR8C8QFGfojFzXdAbxv2e0sQoSWKQMimE/YAhdVgx0o3WxpF3Dd7ESvyfO729tQnfPA3QtSj96qfp7/pgut3BmN9TkdgfG89naJb/t6ZMaFwPV75HqneDgVdygkDzVhA9uJXSzI8sF3zf2mWG7XPHU4wP+AywdvwNix17R8TlUjhcD+MMRbzYawsAkvqj4h5fIoqs69p49XYUcvPPjjQEhHIAl25GeXmKMM3HsoTrtajV4KngVpMTWlu6RwVYrl/AzSAaNPb32y6asaE7HotEkGzzjHfS+fYZ+5pB+bn1qzBwWPhpRWJH6opvDJPcFavKikBe+AFXiL/LfvFY6IhYv5Cu9h7AaIasf5NH5OnBVGQ7+0qxCKrn0dr3vMIOzWwZ6F5ROH8h0zNp/yGAHfKgWOXv3c5LAmw0JVaXN4LV/jCHh8CXks+ABSbNxTrXTZYWtMukUVrGnAE5Gyk1glDcTQLtWgZZDNwTtDbMln+SFqicUrLEXh3OLy8cOJ9BqnAtpJpDB9i47+VV81ExYD7Ydo55vsnGrTV/dAxYTaaJHxVpFBGqxwv51fFSwFWABmQt8CIZ2oZqtpuWKuFQ3es/faDjgBqj7vCFB6SpOLWrWJncZt0Hzf4QKMoaxjOWRY1jzHcKu884JunJSrUKggt0Ur9DM9O2YmRI9BE0/S8yChHRgGAZjUynhalYOWXJzgIly3bLU70AWc+zJWFI/7bKoxP
 YQ96yOAM
 0ScJVYF3woKAmSrGs0RJF3KZvYSCC/m6UAwmeUlFuF0i5fpQJkbtzc/vBk30dgL+wh25TxBpxB+3i0AZLIZyITVVfgwCCwT+duWG+Ng8GnUYgUUpCdL3EaQlIPUR5ZS1wz2zdB8IaLXROewO1MScCt11QU+9hZgAXrzgevy44u7fjxIGhjThrGKCaWGKLY3qk67snxt5l2sO5aXSiWsZORYcR44sq2qr/u8QQDRtCeH17wSSG/JQXUc1zg1vzex8jWjXmLjRzKZhA6uIstozh4OiRr2CN7e9lUJL0qX1rQmkNRQdirilORkZzNWdI/fh9VJfmzTDt0rNUKDwV6xckyLrOVB4cehhrpR/V2vbfGoGd62tTUqEl8z20+gQz/FCu500E+TMIn7YO57EeVWhgENEclv2IRj7ZvzYD4XkNKxOhs1N9R02XFFafTWep6mqsw3S6mSEs3qye98awUeoOwW3KXSU7KsMgyi5d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/25 2:33 AM, Randy Dunlap wrote:
> 
> 
> On 9/9/25 1:14 PM, Andrey Ryabinin wrote:
>> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
>> index b6ea861006bf..af9a25bdcd6e 100644
>> --- a/kernel/liveupdate/Kconfig
>> +++ b/kernel/liveupdate/Kconfig
>> @@ -69,6 +69,14 @@ config KSTATE
>>  	  state, save it into the memory and restore the state after kexec
>>  	  in new kernel.
>>  
>> +config KSTATE_TEST
>> +	bool "KSTATE test code"
>> +	help
>> +	  Build a simple test/playground code that is useful for kstate
> 
> 	  Build simple
> 
>> +	  subsystem development. It contains some structure with different
> 
> 	                                          structures
> ?
> 
>> +	  kind of data which migrated across kexec to the new kernel
> 
> 	  kinds        which are migrated
> 
>> +	  using KSTATE.
>> +
> 

Thanks, Randy. I'll fix this up, and the documentation as well.

