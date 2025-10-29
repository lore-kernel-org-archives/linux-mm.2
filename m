Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 551D0CCF9F1
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EAF8E0092; Wed, 29 Oct 2025 11:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56A78E0045; Wed, 29 Oct 2025 11:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C638E0092; Wed, 29 Oct 2025 11:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9122C8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:58:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F42113BE79
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:58:48 +0000 (UTC)
X-FDA: 84051609936.19.848BB08
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id CBC47140009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:58:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fTCWRDKh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753526; a=rsa-sha256;
	cv=none;
	b=CAlwvfH+hOlyVb+ZNqQixeCjp1mEttNVeokU8Yj7yMnR8AZktiSvM7PgL9ms+HIgiXPdOm
	CZ4iFOqnePfg2CuogAQcVg3Xw5BXpEB8Ly7IkVGOG0+DP33IuUrFL0EBEeb2aGSQV/5GWq
	uCsj71Cw/7SrVyb8uMNjKhH+c5dzjM0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fTCWRDKh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MTuw2M4w+7icp1v9w2NHA+FuLFUpMlcJ3+bxm+0QA8=;
	b=xhfOiFiJ5xkiqxIdnz6LW9szQZxQWP/xiQFUHbk+Yxe476Z8r2Mq77urBBSdo1jH8yfcjD
	VI7VmnqP3rv0Iqvs/PlhJcTY7hpm0pISGcjElgDRuB3thObMTsHwP3HkDJf25PE6TPXCW/
	hps+cbvFuJS0Wy7RudIHVBr82IQrJgU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761753525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7MTuw2M4w+7icp1v9w2NHA+FuLFUpMlcJ3+bxm+0QA8=;
	b=fTCWRDKh88AgI7/JqOF5qTtYjrwyOxxZFlRUbLOc+o/Cel1r8f2AbbSqfpjoNvW0T18fjj
	yzbDusVW6knOsIBkQ+UmMkckleQA81vbZWgQDcP+7QIpWiS9fCOEwacvrFUL4euYqNVCrv
	pXlqm/LgpTB7LtLEaTzjYKngpC3AEoM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-mFb2GML9PN6dwd10A0vfvQ-1; Wed, 29 Oct 2025 11:58:41 -0400
X-MC-Unique: mFb2GML9PN6dwd10A0vfvQ-1
X-Mimecast-MFC-AGG-ID: mFb2GML9PN6dwd10A0vfvQ_1761753519
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-475e032d81bso35717775e9.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753519; x=1762358319;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7MTuw2M4w+7icp1v9w2NHA+FuLFUpMlcJ3+bxm+0QA8=;
        b=FghLocYb4iPlc5Wb31Se225p0jPZU+ZyN1uJpb8SDNtoqLqTItHxq6X2VrTZPBeoyk
         8Q9p0o71kW2Ol3IM8tComOqWc90bUybXLPHMfWbXiBXX4517Fz70BfextTsgMlZDwVXp
         0130exxobFoGAhqmuD9CQcajRZEW81ZIDJcfHiv+k3+grDJChHAVnNXMKaFMRxjKq7T1
         s6L9OG3o4XkRWHqiP/Io5JJF/l5mEMhnE6aJ6ezs9QwhP+Bbg62Ze+8ZStjgbity9iXF
         1pC1u0iNg/Hrc9Wht/GdHm07E/TetnjlLJwqYETsvYB2ADt0hvhMJK3bEt4RUmM0opGN
         FQmw==
X-Forwarded-Encrypted: i=1; AJvYcCX4SF2MWVPMYScd+QIX3ytw327jWlG699YulrVpHOs6sMs5BcukytsnCshws+4DmJ0+QHufNIsEYw==@kvack.org
X-Gm-Message-State: AOJu0YzOfySPcGqaaKcotbJUYf0CE3TiVqZalRiyXo59ybXjfh0OmgL9
	5wqxJSW65mx4OstX/cHWmqE/qI3kjej4cNbkjoIh1+x1Ct31lDC4DRFS7+gpTr8EJMhjjItQamD
	t7OPV9DwMhQaxhI91uKZxAj77Vgg4CU6T/mcP7wYRD0YdRifLvBA3
X-Gm-Gg: ASbGncuCzc3Lx/1SAKx1HlPa9W/ofKBV64fDJjvZmixq/AihMFqYPdIiCWLD2T2Co+9
	P7ex9RzqCOt03Z9MelPHnZoxq+5SyGXYQrwbAWNkzIWx+zatiBzJx/KWm3eXPxMGeS8c4ZBblvk
	2zVbqSK/OJdWxlhtWunzWIs8GWuR38iejcHuc1uniNUOHrGD35Ij6SvXCpsTRe6u0xBrOlmeEA3
	IIDkBMxONUi2iKKUrFYC7r+N6MS4FETPK5bCcFQJlpI8ziytmiPEiM+teLcWJyXjvxp0es6qYuw
	WFnI0odafXA0KL9IJNma3RO4MlbSFy5BKVRLOOsU8SiLvuKG7a3NDP4RBpAF21A8nyPBRFD60hH
	xFqe4omyXRaLLyjs+pLDrIg==
X-Received: by 2002:a05:600c:a087:b0:477:58:7cf4 with SMTP id 5b1f17b1804b1-4771e16e3a3mr32441765e9.4.1761753519400;
        Wed, 29 Oct 2025 08:58:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBUfbQXjSUBfZ5yGMdw13PwBGP5RPGg4Gjem7sfzzIH+QoMvfQEwhbQ98KDi2IbIS3+g/TEQ==
X-Received: by 2002:a05:600c:a087:b0:477:58:7cf4 with SMTP id 5b1f17b1804b1-4771e16e3a3mr32441575e9.4.1761753518936;
        Wed, 29 Oct 2025 08:58:38 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df682sm26817699f8f.43.2025.10.29.08.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 08:58:38 -0700 (PDT)
Message-ID: <b13bf4ce-a6fb-491e-a8c7-ecce0d4d87d2@redhat.com>
Date: Wed, 29 Oct 2025 16:58:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/mm_init: Fix hash table order logging in
 alloc_large_system_hash()
To: Isaac Manjarres <isaacmanjarres@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, stable@vger.kernel.org,
 kernel-team@android.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251028191020.413002-1-isaacmanjarres@google.com>
 <dcceca48-bbdc-4318-8c07-94bb7c2f75ff@redhat.com>
 <aQI3z0x0gZ3T1fij@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aQI3z0x0gZ3T1fij@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BR7Z0MjcIfM7NpmIcuXCL_lAz8MlcdZgS_ITcZwlIN4_1761753519
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBC47140009
X-Stat-Signature: 4x5oqwnbhoj43e3uqjswynent8w6dwn5
X-HE-Tag: 1761753525-873162
X-HE-Meta: U2FsdGVkX1+zxaDTiHqQ9O7KKXPF8TCoEB/aX2wnxBz6a2Q8AH7GWC0IvtOnENEm8V8Z/rqm8/i0o4UxmoxSyfXusMgRhfhmnvADM8eXL6oP19IVlIlrQE3cz2k6B5Qp/mJXYXKzZyVczW3qGGVl5ErPNhsdQKlu6pNPffdkinAhkCqaVnzcnntBPG1lyvGVxKFboPQ9PvEKiKF0Kr0ipGS8MH1v97dCIJGa6s/BqTVPTvf1SonD75wxGPoXOFu7n8b5qX+neTc5t+afKynTGlxI/n4L7hg4wTBuDKyCnmJVoWpdVc8SrKGR0IZ91kJksIfkMHU+oEqYcPuoP07CZbV8hQwvF30FAI1u3MFY/1vhxyvzN1TY99tyUFxojf7NeXdAmfoiLklLNHapMLASe7O5ztobxOeE7U5J9+zoYPOWVjujmCw/GoFyT0QUir2PEVCoqhP5gByNkkYcBtwTZDeNQj6MFkggk05hRZjVx+hO7vw4xJJWZStCR2kxLgo/EL9fylRme4284XKhfsb1KAjLwHL6VtV6Z65zS99E8rY6PF/eJkRE85dg8B2hgP6E8vhTpOvBrNvrfaDNC0Lntj7qbQbVlboaWrweFZ/hv7AkWWFkXZzSXOi1Tp6gJ82MNLtBW76q0Ri5H1MEdnuibH7/awbDNp9U/yVYMmuDBvPYsmz2OIWUawR6CAcnZJoGyuCIL1MOzK5RhwgAp3wlSIxnxCGvRyTvtcnYPrvImw6z3x9B84kwHwWsbM2FkPnGsYQmo0QqeIUM+XZChErI6QjWnPbbv4PIzYyRe1sikcb8bbDyqwZBHPuURmM0ZS03PhxN+9nvoePqtmtv3cOQp+/hrUu+eMJKjupRtUbyi8uUdCxETP/GCv77h/MBIAbjzFvhybBTuxxXIoxle6HnU1CBBQBVPlkiU/eFvRZK96twLIzTWAh3Kg2+lhiQnh1vLH3GGTJT5Jb2ht8TyFD
 WXB5w8/F
 DxbG4aRDXu5ZP/JHPNEaoSP1oKfErr6jYcXQj+Ve7c4tBbx4+YgoUiVVto2VWfK7UJsg1rEQWVmw6El2UYFwGzj+X7R+VxKacDdUoIexsu3ZmkgKSBUynWMLPa040+8JMJArBT0qw0I4WN5jnN5BUcZ5rUCEK2lv5pkUXhW0+5bAIiIXky4ly+fxJqnhaXzKvlzD27hTtcYzSlYSXh7TdlhWEdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 16:50, Isaac Manjarres wrote:
> On Wed, Oct 29, 2025 at 11:03:18AM +0100, David Hildenbrand wrote:
>> On 28.10.25 20:10, Isaac J. Manjarres wrote:
>>> When emitting the order of the allocation for a hash table,
>>> alloc_large_system_hash() unconditionally subtracts PAGE_SHIFT from
>>> log base 2 of the allocation size. This is not correct if the
>>> allocation size is smaller than a page, and yields a negative value
>>> for the order as seen below:
>>>
>>> TCP established hash table entries: 32 (order: -4, 256 bytes, linear)
>>> TCP bind hash table entries: 32 (order: -2, 1024 bytes, linear)
>>>
>>> Use get_order() to compute the order when emitting the hash table
>>> information to correctly handle cases where the allocation size is
>>> smaller than a page:
>>>
>>> TCP established hash table entries: 32 (order: 0, 256 bytes, linear)
>>> TCP bind hash table entries: 32 (order: 0, 1024 bytes, linear)
>>>
>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>> Cc: stable@vger.kernel.org # v5.4+
>>
>> This is a pr_info(), why do you think this is stable material? Just curious,
>> intuitively I'd have said that it's not that critical.
>>
> 
> Hi David,
> 
> Thank you for taking the time to review this patch! I was just under the
> impression that any bug--even those for informational logging--should be
> sent to stable as well.

See https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

In particular:

"
It fixes a problem like an oops, a hang, data corruption, a real 
security issue, a hardware quirk, a build error (but not for things 
marked CONFIG_BROKEN), or some “oh, that’s not good” issue.

Serious issues as reported by a user of a distribution kernel may also 
be considered if they fix a notable performance or interactivity issue. ...
"

-- 
Cheers

David / dhildenb


