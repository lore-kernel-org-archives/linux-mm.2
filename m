Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2856CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 13:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9FAE8E0022; Mon, 25 Aug 2025 09:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E779B8E0001; Mon, 25 Aug 2025 09:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66C58E0022; Mon, 25 Aug 2025 09:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C65228E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:20:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5245458EB0
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:20:21 +0000 (UTC)
X-FDA: 83815338642.09.C95D318
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id F09B1100018
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:20:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DGlD45vg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756128019; a=rsa-sha256;
	cv=none;
	b=avvGMxbn7SxIKS1x0uVr57xb9Z6PAhoYdPgHeG6x1J5v9hYyDvD4RQDxgyvww8qJ+dllBf
	LgxXWg1f+4AEVoQ+ljfq/Yt8C+CZjAlI0Ost9dW1z3TYTwkZXLBlNXJU7HOFr0hVLqleRH
	fEAFSm1FSQ6+n2dBcQ7d4myzzVGYTnc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DGlD45vg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756128019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xanPEdPEE3D5dOZlqK4VGPHY2abbjAoznKTXD9A7MGY=;
	b=Aydm3GnCqFkE816Sza+Xa2jTIqoBVX8dI2gUlutNQssyY+wz00bvZHFWabsh6u3mOJuJbL
	ITyCX29tT2jaxcSmM3KO9E308CL2mqtqv9PIiFwyZWV84VdD6iPYqbX5UR2DvKyll+dxgQ
	DXXvpVT4T1spwm0kcXsqrF4XOsm3Lxc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756128018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xanPEdPEE3D5dOZlqK4VGPHY2abbjAoznKTXD9A7MGY=;
	b=DGlD45vgogFOnmNirGnK6pe2kjVEFm0sjvqpAQNxEbhNEWv3HAE5aRTg+FotMdfU3H9/53
	jtaoel+eL/RL08LvNLp0mZtYBVlQXWrRNjQuIT7jhmOZmSKrPvYwaWRlTWPT5IxFc4qMym
	Bq4i5Ec78h34ie72D8KB3VqR70gnviw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-OJkLyoGVPYiPt_kw7mrsew-1; Mon, 25 Aug 2025 09:20:17 -0400
X-MC-Unique: OJkLyoGVPYiPt_kw7mrsew-1
X-Mimecast-MFC-AGG-ID: OJkLyoGVPYiPt_kw7mrsew_1756128016
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0cb0aaso33553035e9.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 06:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756128016; x=1756732816;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xanPEdPEE3D5dOZlqK4VGPHY2abbjAoznKTXD9A7MGY=;
        b=q6xHkXYz4Et8STrWQYrVN1vVXv0ZlTmxsT2vowS2AAs+3VF9aqE7Crn+06HEJKqX11
         kCkD/SZTtnuXqEXkeYD26T2mPosK4/VF0QTllGThKqBohUY3b8hRMafqeLKtq7vggR7N
         2q34ym5n/8dCxGBdz3Dtdv8fncVZ4VPqvZpU7ZDXsBpATnw47Z/JwmXJ4Dt164frRzyU
         yeQFPIWuEJt8DW5xUetldkENLSkx1IGvJET3FQ5UdhvZ9/QPV9kR2u6o/LPF3xctTyfL
         +zE/HEMuV+LefygF2n1W17uXrDSFFuPsLGUo553wmhvQTscWLy7vlNbdK0z6t41brdYe
         DoeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4kMUUcCJY97MVzdXwfgk2/8GIjhtWm88KZzf56TRP/ZCo2a8NHZFGOaTpHZFdr+vAj300K9EvPg==@kvack.org
X-Gm-Message-State: AOJu0YzSh6/3frhv8qPeFmAd85mx7CqgGZ2fJoMR1k+acuw97ijZingQ
	aawap2PvGsiaSmJVrDUuhXb4E7cPt3B37NBumzkH1EJ2d9OOynFuyjY1f40aXIVQFnd9ZEhA1WX
	eHBX4lLtbYfpytoutSAz8ymznu4pxoVqd0QknM8DzQY7WsrtW1tzb
X-Gm-Gg: ASbGncuBNJg24Bn/ldxEmZrjn76cWH9iJ3zufez8vsWquoGYE1zGtIg/xyRqd6jjuug
	Kd/3PH8/Yb/O2iYJPJB27adI7ORLhyt3AIUVdmvxFQ12+xmjix2eD/tqY0dL4OOfgf/dyICroec
	2gba9jBcTR+uoorEC3sVVh/4B16ysFj+at3oFW69vnIsVj4CMvPCBmLiUOXkK+93MqSQSnQZADh
	QgzrRiISTroRW7fU2PViFWdcUAaS6GCXoxRS1MyAbY9CrSAUZBaAMrwSzLHEK/Cxd02tcgI51Tn
	VJnzrMb1Q+UgeC3iy6uDBsJFLEa/Pr2+EAqaTd8Nvs9If43bJi4HNJzIybfkZcjbAKnmi8N9mv6
	xJOdLJBqscmNTDI7WXCKRZz15qGMqSUcRaPJ8ifMTCGfGwnSrFbKYfM/h68tsEpdsPc4=
X-Received: by 2002:a05:600c:4f03:b0:458:a7b5:9f6c with SMTP id 5b1f17b1804b1-45b5ec68358mr40532165e9.11.1756128015758;
        Mon, 25 Aug 2025 06:20:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvrXUbP05G5QAqAXL/0e5bs4AE6awYxmrv92zt0i3Fp8EOJw//DKRQZAygSokTsHc8FeRx2w==
X-Received: by 2002:a05:600c:4f03:b0:458:a7b5:9f6c with SMTP id 5b1f17b1804b1-45b5ec68358mr40531705e9.11.1756128015277;
        Mon, 25 Aug 2025 06:20:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b506bdd9csm92855095e9.3.2025.08.25.06.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 06:20:14 -0700 (PDT)
Message-ID: <f1f290fc-b2f0-483b-96d5-5995362e5a8b@redhat.com>
Date: Mon, 25 Aug 2025 15:20:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org,
 Christoph Hellwig <hch@infradead.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
 <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
 <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
 <77d17dbf-1609-41b1-9244-488d2ce75b33@redhat.com>
 <ecd33fa3-8362-48f0-b3c2-d1a11d8b02e3@linaro.org>
 <9f13df6f-3b76-4d02-aa74-40b913f37a8a@redhat.com>
 <64a93c4a-5619-4208-9e9f-83848206d42b@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <64a93c4a-5619-4208-9e9f-83848206d42b@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: edfPj-B09Iht805LrPSEfEoXEAltpigd8JKXuydgSEM_1756128016
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F09B1100018
X-Stat-Signature: 3dr9aydsuufg458hqf11c53uajbyrcwo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756128018-647609
X-HE-Meta: U2FsdGVkX1+sxdvu3OdNc3NRExZewn7YXdEyTO4U1zW3QGqitHf3hAfhL7Vcli5m3XmrSkrCmEHNApPEUoto2KNZDlSqnHDx/w++5wGPBIBozYPAkx+UEd35K+jWhDi1NyaMS1L2cbPAupWycLP4DGD9qkm0zVqYIT9/7bKEBc83PtAP7yt4egwI+zlgN4uArytfOyIiaPCO60GJEP2eKEu1OVCiI+uXV6HHBT1Tq1yaOGT62NijdlX30lqbbO0kZqs2YsUkuneZoSB1kirk4yW6Xec/x6V2dKMQN+wavN261ZP6RKn8zStjFJeLHBRZXopSiz1oq85sukbU+vyf7lMWZZqv6mPsyMZV7puzX29fizYR/P0vFNYujz2A99EA1U5xvhSBk7VFkh7piOkSRmuXeCea+ET4WM8pjtZuLq3LpXJ+PHXpL+acY5S53IGeUfuEmm1GkFE1RT9q4MrtjbbYVaD1JR3fnrG2mkPuZ999PHkqwqJ6rDeS1ug7F6OQJLChxTrnvlkjDut8vi0Kq8FMKCT6AiyCOgDRCcyQgFD/4PGfm31BdcCrVDAFbJk92qVPOJPmfr42R0oKr/q6TgY4YX2Qp+XBtdufwW7tYEh42lXEyl6Er38ykGvXy4h78VPO/6KfIWv4Y6fmBbVpsaSvPyWBfBSXk4MazfdwOqVc5qqTqSFdITtUA4rlfEE+INM7VSFA27Upkz5MtY9XW/SJuDTKmgHYzrPzL4rmBntttOi3EAti5y3UeFZaVz5dfaqGl4Rt79nHu6pX7va486zvbTYoEc0CSkV3ATaEoJM418MdKrFpAbV2hx4lSdQax1/+Kou6s/DkTY3KeHruKn67HNG8Wwto8OUBpWM/7ORtafFvozuIqpyB1Qy8gFAMWmsYPOV+BuegPN8U8Y9sUOmYXVUHANGiysCeHzMgSrGTj5GhtQhceUAtkM+fC1CYOHwha9UCU2w95jMisxe
 rcEWmrpZ
 TyBHCac4vmo2UN2Ns2BU/o0tbyImTwo2Ux9dpnp4nKImmSZvQMP8a9AUb+A4qzc2JBHXBEBrvbB23v79FQx97QpYRQO0jEbnil+TE3+BEzGNXAlh0m0R9aw0rkhGf209DBRcAsE3FHQLpKOXFCM7SI5HWLWs7W+ah7+uxdkesqlNlRobFDDCJbWUByN5xA3w+qse85M00/H4kpgybMF/nXuSew9nM7GTsULklLyCWh1gPThImC0NIjPiku2j6Ohoz/8jr6bLiiWB7I0PfVV5Rvpw8yVzJiy7GK+0Nk080+tby1QFgUCheWvW4cZGP/EJFfuMklCCklwaqIYgNQFsT6epM/kA8WXJH8z9ktqlV1EwxBFSyn1xLCEckzbn8xX/rCbQzLVgwlw46D1zEhODLjvHKuqks1628beWHTlqI3HtyRkwlPXKaXltXjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> IIRC, kernel/vmcore_info.c is never built as a module, as it also
>> accesses non-exported symbols.
> 
> Hello David,
> 
> I am looking again into this, and there are some things which in my
> opinion would be difficult to achieve.
> For example I looked into my patch #11 , which adds the `runqueues` into
> kmemdump.
> 
> The runqueues is a variable of `struct rq` which is defined in
> kernel/sched/sched.h , which is not supposed to be included outside of
> sched.
> Now moving all the struct definition outside of sched.h into another
> public header would be rather painful and I don't think it's a really
> good option (The struct would be needed to compute the sizeof inside
> vmcoreinfo). Secondly, it would also imply moving all the nested struct
> definitions outside as well. I doubt this is something that we want for
> the sched subsys. How the subsys is designed, out of my understanding,
> is to keep these internal structs opaque outside of it.

All the kmemdump module needs is a start and a length, correct? So the 
only tricky part is getting the length.

One could just add a const variable that holds this information, or even 
better, a simple helper function to calculate that.

Maybe someone else reading along has a better idea.

Interestingly, runqueues is a percpu variable, which makes me wonder if 
what you had would work as intended (maybe it does, not sure).

> 
>  From my perspective it's much simpler and cleaner to just add the
> kmemdump annotation macro inside the sched/core.c as it's done in my
> patch. This macro translates to a noop if kmemdump is not selected.

I really don't like how we are spreading kmemdump all over the kernel, 
and adding complexity with __section when really, all we need is a place 
to obtain a start and a length.

So we should explore if there is anything easier possible.

>>
>>>
>>> So I am unsure whether just removing the static and adding them into
>>> header files would be more acceptable.
>>>
>>> Added in CC Cristoph Hellwig and Sergey Senozhatsky maybe they could
>>> tell us directly whether they like or dislike this approach, as kmemdump
>>> would be builtin and would not require exports.
>>>
>>> One other thing to mention is the fact that the printk code dynamically
>>> allocates memory that would need to be registered. There is no mechanism
>>> for kmemdump to know when this process has been completed (or even if it
>>> was at all, because it happens on demand in certain conditions).
>>
>> If we are talking about memblock allocations, they sure are finished at
>> the time ... the buddy is up.
>>
>> So it's just a matter of placing yourself late in the init stage where
>> the buddy is already up and running.
>>
>> I assume dumping any dynamically allocated stuff through the buddy is
>> out of the picture for now.
>>
> 
> The dumping mechanism needs to work for dynamically allocated stuff, and
> right now, it works for e.g. printk, if the buffer is dynamically
> allocated later on in the boot process.

You are talking about the memblock_alloc() result, correct? Like

new_log_buf = memblock_alloc(new_log_buf_len, LOG_ALIGN);

The current version is always stored in

static char *log_buf = __log_buf;


Once early boot is done and memblock gets torn down, you can just use 
log_buf and be sure that it will not change anymore.

> 
> To have this working outside of printk, it would be required to walk
> through all the printk structs/allocations and select the required info.
> Is this something that we want to do outside of printk ?

I don't follow, please elaborate.

How is e.g., log_buf_len_get() + log_buf_addr_get() not sufficient, 
given that you run your initialization after setup_log_buf() ?


-- 
Cheers

David / dhildenb


