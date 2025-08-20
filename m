Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC588CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 15:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0388E0062; Wed, 20 Aug 2025 11:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7C48E0003; Wed, 20 Aug 2025 11:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6D18E0062; Wed, 20 Aug 2025 11:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 282048E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:01:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 958CA59737
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:01:24 +0000 (UTC)
X-FDA: 83797449288.15.11CEF63
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2FE6816002C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:01:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I/jnYSHt";
	spf=pass (imf08.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755702082; a=rsa-sha256;
	cv=none;
	b=s7ptC87t7afKlAEwx+ZiK7wNvrm/Lc8uc222nMSVlMG+TI98rBE/myZYD3L92WP8l50IBM
	qz3HMFvCdBmkjGuZ3Td7gItKdVvlRJ87dQOm0Giv/3k3oJul5Tm+OmjdjtUW95+O9F860u
	VT0r9vNAfMZvtmdIFYX+nSyVnpauTDY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I/jnYSHt";
	spf=pass (imf08.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755702082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uwru5TX1hmNs5+ufZgj22qd45pHx0gD1JqlHAKNhi/Q=;
	b=M8orYwCqhy4uunB8uldnUx8dbJfCUreeuhh5t8UimrFnBtqLz+pp9JFQZw12jfBraF1/5G
	S7hv//8gSHc6KpH1hfaCv4pZj+6gD6CzzoE4hXWrdhqXoKR7o0v3Wnf8yYiMe17WlCraV7
	G11A2rFVIUP6IhLYmwhAthnN/npEpps=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755702081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uwru5TX1hmNs5+ufZgj22qd45pHx0gD1JqlHAKNhi/Q=;
	b=I/jnYSHtVVaLsA8SqVK3UMt56okTAIhauIYUvMjD8V7lgYuF5Tv0Cc9UCTaTJxQ9JXWfst
	ZGHBlVwzRh1EQXz0ARcbBW0cm3mELT8cBgXOvnYrcri6cB4Qznn1LuvvZOn/S4s171dzup
	RwYmQtKG/m7t6jfLHLoRa143NJuu/GE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-9uGetGi6PfuKaOTns4EboA-1; Wed, 20 Aug 2025 11:01:20 -0400
X-MC-Unique: 9uGetGi6PfuKaOTns4EboA-1
X-Mimecast-MFC-AGG-ID: 9uGetGi6PfuKaOTns4EboA_1755702080
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7e870623cdaso1687596985a.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755702080; x=1756306880;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uwru5TX1hmNs5+ufZgj22qd45pHx0gD1JqlHAKNhi/Q=;
        b=YTR3pSlD1DBOAidjszrTocTnZJ/FULgNvYad6Zhqa8E2vOluCp2Syt6M4xm58acaTA
         uDkms3nLXO4jpHeV3UAAwG0ju9774fIvK4yyVM4QgK6AxTJW/8v0KBN5iJwVdiukIu/L
         4hHjx4Y/jvVSXBTGXr0fjFDs4YlPy/pVU0a4LAgJHowTNePV7piFOW9Zhpqew5lre+lZ
         q1KHe+J1VOwg8MnES4W5bprnmdKojKdm2kRv0RTMZzWlEIPJsRiCRwWijLzI0thQe0u5
         deO5gO6U4NBxbkoFn5n8w3vTVT3hW4xqPY0WIcYO5Oc+ohAlxV9EZ3dgHE/z67/Ao7gr
         LXHA==
X-Forwarded-Encrypted: i=1; AJvYcCXDjwQlLDTEQgxpA+9bwLwHXdcmXAO+WjPcFPMe5GoL2gHLybq48L9fleYdvBpJdPJnoOw0oOponA==@kvack.org
X-Gm-Message-State: AOJu0Yw3e70Lh+V2HTdk1lNxV6Gwm5umM8RFgzZxHsc7tXeb/TQ4qUT8
	yY9qjW/8PK7TqYTK5IR47f/r3SmguLRDvM7nq3FDCIi/3Kb1ZKwsQlJXBRqtBSHhAVQQQmYDxfJ
	BvvQorlsEitjtHhASMAtgX3Zv1Jo5Qw/5gyrIQeZVXCme6UdNLRQR
X-Gm-Gg: ASbGnct9785ZC6WJCax6hA9NF/7T0aIuSEvwR8YYxBqsE1Yp6Xs2e5wRav+GUL9Bnus
	BTBko1kNiPhLGM7rZ2wIbXDM924khZlZpIdXya04buU8tVTIIs3vKihiETQWmJVVENqYTKSdUJR
	nZNc6piZnDLsoowK849y/A0j4go5fkIt2nsfPKAlTH41+uwnR0UkWyRfRuMmUA+U1LbbylR09Jx
	nvy7CM5V85NA14p5hQf3Wpk5yap6WC8LiwWJETydl13v4YPzSy3VNvhoua6UMkamgkcI6bGTmo6
	6zVJIfex91muBKkHvcfOo3NtVC/ptdq4QUbRwzRqzGtv/rAr5xfLIX0wHEMczCGSg7HQrwYCwQW
	Y3zkhrqSM9Q==
X-Received: by 2002:a05:620a:31a5:b0:7e9:f820:2b6d with SMTP id af79cd13be357-7e9fcbb49a1mr336170985a.67.1755702074385;
        Wed, 20 Aug 2025 08:01:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpAS/Pt2OG3esrr44EOu9shr1hzAACYm7jBC9DIaE1fQJhgngoOzDQG85RivoDlvbLssSO9A==
X-Received: by 2002:a05:620a:31a5:b0:7e9:f820:2b6d with SMTP id af79cd13be357-7e9fcbb49a1mr336045385a.67.1755702064230;
        Wed, 20 Aug 2025 08:01:04 -0700 (PDT)
Received: from ?IPV6:2601:188:c180:4250:ecbe:130d:668d:951d? ([2601:188:c180:4250:ecbe:130d:668d:951d])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e87e027290sm969604785a.5.2025.08.20.08.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 08:01:03 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <fed73718-8001-4db6-af36-86c60e85d224@redhat.com>
Date: Wed, 20 Aug 2025 11:01:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: Fix possible deadlock in kmemleak
To: Catalin Marinas <catalin.marinas@arm.com>, Waiman Long <llong@redhat.com>
Cc: Gu Bowen <gubowen5@huawei.com>, Andrew Morton
 <akpm@linux-foundation.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org, linux-mm@kvack.org,
 Breno Leitao <leitao@debian.org>, John Ogness <john.ogness@linutronix.de>,
 Lu Jialin <lujialin4@huawei.com>
References: <20250818090945.1003644-1-gubowen5@huawei.com>
 <113a8332-b35c-4d00-b8b1-21c07d133f1f@redhat.com> <aKWrSfLD5f1r5rg_@arm.com>
In-Reply-To: <aKWrSfLD5f1r5rg_@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LqUS9qwoNDZfEo5wlylFOzc-pvzskm4plv8igXYV8ic_1755702080
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FE6816002C
X-Stat-Signature: 4aiofapow6q6k71zi4x74nzxjsgpxss7
X-Rspam-User: 
X-HE-Tag: 1755702082-333603
X-HE-Meta: U2FsdGVkX18LVQA0cVtDtQmiNYsdo15MfoWA80ziZdJW6Vmk6d/LHvItcPFpze5KrSvBj6GaI5Ho0aCk0opJ5k1UopIHw4bhyjso7wwm+LpDrVzBnryHTrlU/3/E19bNfUizQK0tEAMOF17Zs45lsvNz8JAgw3OzZZs8Kweei/4Xta9FEDouLoCeGjbLMx/yFSue4WCbB6yTDXx/m2Id6pyt2KNBncLpRlLv4AswIs3RfEGHAuBpvhK3faFPwuraOtc5HForD849odFOXA/wheC9G7OnZ5HNldegURABq7ygZyE4js+KRdzyb2bqyjbAhsM1esQdcGhD1V2mWj8V3kcPMQIU0zdnP8861g0cYieOMPPFOY+N8pobbOh7DkcIbuw5WWT1ylhbbkqREGsJYYfMg5VGy3TyG2uT1rmgEo1l9VLUWLEKo54CObbCxDiA1i568Xz/bxJc6rawWev3yYttsfgSA7eDVaqrOG1d+Y+Nw+Sc0c+L4CrA2q6Xy2WKxHJ9TdS0c2pbKlYZzQPEJ3Y3+2nvkZayar8mZ42SRxZvY8xJbF/x4eYEsqWXnC1jpqo9JDYFMabnj2MpfFwydby1B2e6/W36PUKwwdOVBv94t/0JdTIepe1dOetwbqGnexN/DGlf6E38Za6ji5mb2W54G/McsCAZ8rqjxJ9QmIfN4Bb1PWrM5V3Sy0A5nVD6YYhKWux01CG+rUXh/bYGo7pD0ewJQwhjXew9m3+AsXp1bh1VZL9hghrJBIMViy4x/ViMNoeDVbub1uK+Ak1Fch33dklr9ioa7WmrQ9wvADwzzTsUeSPJ/7zbiEpIWazvzBFxKpTQXK7gnqJs/fUmWfVb8ciNpNume4xLm/9meSrrrJF7rH3OxTDgYbaLkkHR55/Fd5wE2EirGDSERSRKfnGu2sNkGO4KtswoB6kDCnWt2Re48keNYxMwdbsNZG2XnJZgio6Nn5GIEcE94p8
 Z3jsY5AH
 zoTzIL3sXCtkx+OVvtCizcjCpRCGHqWWm8Rbb2y8f6vpOoTnAXwt5aY++ss5dUTeOXgS8FWUWVpc3tCqU6r3/Mqua11za27UHw9HQikOS9xQsA9qp1Wk8WST2FlCxXn5NqaNKQNKYJMcW901MwcpkESS2s1D0fcIEbxSiqejo0XzgkWVAdxZ2xw4Z0MwGNpngd41gaRjMZTRHsCn1lfGeVrXFZrt6J8tjn1p0SA9dKBFR73r2+8FzAKbaZREP5wqbLFPK+6LSVYygS8UO81UMoSufGYcRh33ZsiCf1iTcHSZdI2JOQQNy7GZWYqOlQIKeNG+m806AeQk2U19JUpHaCE0QhpgcNGHC7nS10r8v1j5ViiGHwH7yrhnsDQdpupZwWWFcLcpQ++8F6vhzfgExSqQeR3EklGDizJ2EeD83s3AsTIOEBMqwlhAGwaKsIySnSfuQYudNq37vq+QivzQa36kjC8XLnDsS552o59+CGDxbRjRJWsDbn8lLSiz3ua9hewZI4oOohwPyoAAC5MKQOZ3gDznQ8XEBcYEK0+TWjr+aMeQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/20/25 7:02 AM, Catalin Marinas wrote:
> On Tue, Aug 19, 2025 at 11:27:23PM -0400, Waiman Long wrote:
>> On 8/18/25 5:09 AM, Gu Bowen wrote:
>>> @@ -858,8 +870,14 @@ static void delete_object_part(unsigned long ptr, size_t size,
>>>    	object = __find_and_remove_object(ptr, 1, objflags);
>>>    	if (!object) {
>>>    #ifdef DEBUG
>>> +		/*
>>> +		 * Printk deferring due to the kmemleak_lock held.
>>> +		 * This is done to avoid deadlock.
>>> +		 */
>>> +		printk_deferred_enter();
>>>    		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
>>>    			      ptr, size);
>>> +		printk_deferred_exit();
>>>    #endif
>> This particular warning message can be moved after unlock by adding a
>> warning flag. Locking is done outside of the other two helper functions
>> above, so it is easier to use printk_deferred_enter/exit() for those.
> I thought about this as well but the above is under an #ifdef DEBUG so
> we end up adding more lines on the unlock path (not sure which one looks
> better; I'd say the above, marginally).
>
> Another option would be to remove the #ifdef and try to identify the
> call sites that trigger the warning. Last time I checked (many years
> ago) they were fairly benign and decided to hide them before an #ifdef.

A bit more code change required the printing is moved.

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 84265983f239..eb4e0af5edba 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -856,13 +856,8 @@ static void delete_object_part(unsigned long ptr, 
size_t size,

         raw_spin_lock_irqsave(&kmemleak_lock, flags);
         object = __find_and_remove_object(ptr, 1, objflags);
-       if (!object) {
-#ifdef DEBUG
-               kmemleak_warn("Partially freeing unknown object at 
0x%08lx (size %zu)\n",
-                             ptr, size);
-#endif
+       if (!object)
                 goto unlock;
-       }

         /*
          * Create one or two objects that may result from the memory block
@@ -882,8 +877,14 @@ static void delete_object_part(unsigned long ptr, 
size_t size,

  unlock:
         raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
-       if (object)
+       if (object) {
                 __delete_object(object);
+       } else {
+#ifdef DEBUG
+               kmemleak_warn("Partially freeing unknown object at 
0x%08lx (size %zu)\n",
+                             ptr, size);
+#endif
+       }

Anyway, I am not against using printk_deferred_enter/exit here. It is 
just that they should be used as a last resort if there is no easy way 
to work around it.

Cheers,
Longman


