Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC85CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 16:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066848E0005; Tue,  7 Oct 2025 12:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017068E0003; Tue,  7 Oct 2025 12:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E215E8E0005; Tue,  7 Oct 2025 12:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFA0D8E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:03:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F951C01DA
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:03:00 +0000 (UTC)
X-FDA: 83971786920.27.C22EE8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id DB75E1A000E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:02:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KPQt1lZy;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759852978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D02vIogCWcywjjMvcCY1S+8ke4T1mD4/y69uYsSn6EI=;
	b=gcKo3D7+by0ziGlrApL9n6c5zdK17woX7qIpKR1YmduWIlzOxFuS7+f3ZlMSpmNMR+s0O+
	v8IJ1dfpNVIGdPoR7yCLGutDCF6cvCYddcVtOyjNbvYrILKCnJTRQXifA7E0YJvudDbHx0
	EROj1d57rxIy8IX9ON0SGMOewhPuzUc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KPQt1lZy;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759852978; a=rsa-sha256;
	cv=none;
	b=U1WKTudlnLUpIaJHrHwEnYcUna0E1v9EATsQdzonK6ZMtclI3Pbq3rtCFApCKtGfosuqr5
	xk/qHbc49zKxIHRI5Sa5bhn4Bir5gFup1slMKRzwta0+QLcKxN+rPDggIw5L1Qfyrp188V
	chYZVwSA83bcGfOPE3oNNfg6wlrNsMU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759852977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D02vIogCWcywjjMvcCY1S+8ke4T1mD4/y69uYsSn6EI=;
	b=KPQt1lZyW80dtu4QglrOcW14iPpjXpiYxiP0wi/XVMM/Na0vXKbMxHJvAN9KBuXrmRv7uH
	MK5e7fFNdN+dR7V720wL6H7Be60HQV3RBRBseqz+8XbKbnTXYjvUawt56kT1AK1gmg4ey0
	ZlREZWAWRoj7X3deqwYwF9Lq51XkJw4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-odGYZ0gCOx6Eq_6WT5ZwmQ-1; Tue, 07 Oct 2025 12:02:55 -0400
X-MC-Unique: odGYZ0gCOx6Eq_6WT5ZwmQ-1
X-Mimecast-MFC-AGG-ID: odGYZ0gCOx6Eq_6WT5ZwmQ_1759852974
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e36f9c651so33432515e9.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 09:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759852974; x=1760457774;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D02vIogCWcywjjMvcCY1S+8ke4T1mD4/y69uYsSn6EI=;
        b=IOvYyRbAFrc8ObZGzVOeOIXsWNfrpVGu7ZYst9785t677Mewi91Djdz1yHCqTIYA5F
         0+ShrR3xy9oCiYQcYlKNa2Bzm13qohNpNNnWv6Gkh1hsKJRRJ3FbieYO3OM6CwJW26Aa
         l59b5sa71G+jtvrnN47Ow9o2zmq0kpImzvQotGq7CmtO5ZYUHWOM/4fKwF0CJoxEnLso
         I2KHGwY8ThUXLFn/I1NxQvwqK6C7pEo9yk/anLYU+fKlgISEygwmIsvs36tjKVrPeOln
         yPBM88gniamhEH+OHJQCGYJ3Nuh1oZG+nMFweqJ6eNzwLpQDPFFy4Nd7Ku2QFOt4pNXd
         bV9g==
X-Forwarded-Encrypted: i=1; AJvYcCVEdSlv480Xuq4RVu3WenHYpy96d3/doNXdJ445sAnBYf8DUFYBm44uz1bQMJ8Z4YiPQ9nyEMkV9g==@kvack.org
X-Gm-Message-State: AOJu0YyuYeDdW+9V2+9Xm4q6utUSHEAQiPKy8lkDD3yGYGdq+RBtwbyE
	DG8HDmqidbfycLdLDJGcgWhpz1yzMAJNAHvWMBP2BOrdTXYvGceU/POIbJkxW/bt2HXyAg5YKT+
	WXkFhLfV4wnhEBD8G/nguFUovKxtC/AHmi7YekOX1s3e7OqIUkt7L
X-Gm-Gg: ASbGncsDyAowcKCCjhustr2OrZCW8aBn5Fkg8Z4olh3kqVBRFjeAN8DSMs/DRb1tLbp
	nFolU/FyBlqBSA7nefmXVprPGkx+DhFpBUnfL/NhNtAtFWB+yPFvRW/bP5j4lzuW+skHTJwdhLu
	zEphW0TToITKCBr27nrYBkjaxJyudrWzlUKK3nBejUhyS7D9FVFGRp2mmgvzhcrNYC9LZCYd3P9
	sFf+3BocgKx72cvD9lnlnSJQ4JbGAZZzVGks6EX2wWdBhHvutyFF3eWmT8BBj2YvhoKOtDtvjIr
	1VbHtpBTw0Vp9Xx0SutP2+BZnHDy20xXAQVUwtQAY7vBZDtr70HO3/s4G2084LOWXNHcBR/FuQX
	F7pRZ8ezg
X-Received: by 2002:a05:600c:46cf:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-46fa9b02cebmr918015e9.27.1759852974072;
        Tue, 07 Oct 2025 09:02:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOCwhrXnFdPlPojqY5siU8KpIQ2/rmE8ldqFTs7bhEaF0DysabXEfVeEe2qCO04cRNTkizwg==
X-Received: by 2002:a05:600c:46cf:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-46fa9b02cebmr917695e9.27.1759852973646;
        Tue, 07 Oct 2025 09:02:53 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d869d50sm26841834f8f.0.2025.10.07.09.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 09:02:53 -0700 (PDT)
Message-ID: <0daf151e-d126-4e7b-adb6-5d6b745f4ad2@redhat.com>
Date: Tue, 7 Oct 2025 18:02:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Support dynamic (de)configuration of memory
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 linux-s390 <linux-s390@vger.kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <aOUj_RE8z9OiIIfN@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOUj_RE8z9OiIIfN@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xIs6vuWC3bue2lBpPr4zIkn3jfzXDRf6_5WKaCvt4P8_1759852974
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB75E1A000E
X-Stat-Signature: 15myub4jbaywx5nmoeh4tdonqmnwmac6
X-Rspam-User: 
X-HE-Tag: 1759852977-615520
X-HE-Meta: U2FsdGVkX1+G99p+w8s8JZ+CfNIfspkB+XAnZVmgqCXVMD6o/hNOAUA3NYHvZBArPUimLAyUB8CiaIsRSimgmrE3Clhf7Yd7ye2NCLQrUYWsIYj39QqNQ64nvgcvvzgT0K4R19qPKj5dUXM5lGh7e8zolvFNuEbNa+/6gNoACQYUMtTUTWub+z6vY1or4xY4tMxs8NRh1BGGOFyc4zDx3k9V3K9ScXpcatJmB0648sLQCOzJynpeRXKumIkdjmzmuoflMjJSb+bekiItVM/fKww1UMloj1/Yak7kg1m9PvvOtnrrNFg2UI6rUzJ/mDoyuIgQcLOwwmZKF93MMtKKJABUR8bTU4ahOvXAYeJAgQ+b69BrU4/jMCsGePiXudEZ20btOQhVNsMpPssIyUo3KdNqi91wiMpbZAQ8ZoDB88A/01CWORs0nQUZLCtKF9CpFrzCaOhKz4jHR9qKNngqiAitc2lwxrD+g34EuWejX4FcRCri6j+nFyStkSwiPSiFPcvKaPrSs9mCmW7u4ZNVJ/nTf73SCKG3UtliG0+9BCYOHJY9SCVd9NV9DP9ntYfLESYIIL8eRroGy38VFV5+xslZGD4gFvj4/hiQJJBRxkE4sjc+0zB+SoFzPApJcLx1BNr3SZuLhDCG96woZGOQNox28Fk9Jmo4qJYSXUWk5fzs6RtvaCAsgbDhmayw/ljtXmbPGTfNgPiB381mQTZlX0Xq8zbEHTuPbKLXZUvma43uGpNZFSS4ji/L8naYtY5ScA6RJMxdL7ScBlF1sODiI8Vvkl4clgFDBYcgt8XZa22qjwm7C79VqO6B05FdSjd3EuF5enLyJc3EJu7YUOGBShmCRTrtQT7EY7xAI0meieH2/q4ko6/b5holcQQZIKsCMQJaaeABcaDfn7tFT/iPlX+ktI0McDsLFIiEqqErd5mb3RHMsneHSX+rIZjQXJMm+r0SWEj7wqTdo6+gG6c
 eprPYglT
 L1wjxt/rRQDmlp2yBeKtOu920mL1yu/mMF32+PeSqSx5LnNrG3geluQco9iuY4O4WosxzSDpBixEA3QZjYHaeburcSdNT/Dm3cjU/OEWOzhM8k5M9EzuLUPXqGUlwYeuVu3fdjEeANW01mK7cpmeHEOIr/ba3x8jMp9XlsydnjU6BfDPf53kGGgtb53mdo/usmYmTmbRkDy+lHZym7QfKnC8FT73w+iRZ2M7KjPS3p+rkGSY4B6tbBA6/ass1rZCaVvyvzAX4LYtysa61gOu3T3ZpskNeEGJQzg+VUO9e4vrPm4u3C/slYzquDFrJBM3qIyw4APPqUJJCbdWR6qhDMPiW3XpFXvCjixde/PBGVlLw/OLwteJ3lMMxn1BjwvYNjulUVpjncZSxZg9b9Cxe6yyKzx/hcDkzFkQ3gHmnR9yoeDbEHlm3rby63Byt2SY05tCkQDGl1C6uQT0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.10.25 16:30, Sumanth Korikkar wrote:
> On Fri, Sep 26, 2025 at 03:15:23PM +0200, Sumanth Korikkar wrote:
>> Hi,
>>
>> Patchset provides a new interface for dynamic configuration and
>> deconfiguration of hotplug memory on s390, allowing with/without
>> memmap_on_memory support. It is a follow up on the discussion with David
>> when introducing memmap_on_memory support for s390 and support dynamic
>> (de)configuration of memory:
>> https://lore.kernel.org/all/ee492da8-74b4-4a97-8b24-73e07257f01d@redhat.com/
>> https://lore.kernel.org/all/20241202082732.3959803-1-sumanthk@linux.ibm.com/
>>
>> The original motivation for introducing memmap_on_memory on s390 was to
>> avoid using online memory to store struct pages metadata, particularly
>> for standby memory blocks. This became critical in cases where there was
>> an imbalance between standby and online memory, potentially leading to
>> boot failures due to insufficient memory for metadata allocation.
>>
>> To address this, memmap_on_memory was utilized on s390. However, in its
>> current form, it adds struct pages metadata at the start of each memory
>> block at the time of addition (only standby memory), and this
>> configuration is static. It cannot be changed at runtime  (When the user
>> needs continuous physical memory).
>>
>> Inorder to provide more flexibility to the user and overcome the above
>> limitation, add an option to dynamically configure and deconfigure
>> hotpluggable memory block with/without memmap_on_memory.
>>
>> With the new interface, s390 will not add all possible hotplug memory in
>> advance, like before, to make it visible in sysfs for online/offline
>> actions. Instead, before memory block can be set online, it has to be
>> configured via a new interface in /sys/firmware/memory/memoryX/config,
>> which makes s390 similar to others.  i.e. Adding of hotpluggable memory is
>> controlled by the user instead of adding it at boottime.
> 
> Hi David,
> 
> Looking forward to your feedback to proceed further.

Thanks for bumping it up in my inbox, will comment today :)

-- 
Cheers

David / dhildenb


