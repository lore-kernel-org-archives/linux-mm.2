Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5D1C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 13:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A397C6B008A; Mon, 28 Jul 2025 09:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3826B008C; Mon, 28 Jul 2025 09:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B686B0092; Mon, 28 Jul 2025 09:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7926E6B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:03:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 463F51602A3
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:03:26 +0000 (UTC)
X-FDA: 83713689612.16.9140810
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B3405180013
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:03:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jFNmqLYo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753707803; a=rsa-sha256;
	cv=none;
	b=rBLHja4/aMeHzrd7c23yIRAnwuMqq7iRytSPym42l0ojuiRCujIj3NiOgX45jSfBEBdYtg
	2qYf1CUd72mR07nzqSvOjgKNuEMGqIF4u/+g/g3VUYsBFkZ8v/6l+cJaNNpSJm6OschVTS
	qXxsJ8r2q3WYrDzZCg+yoh9n2nDcQaY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jFNmqLYo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753707803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0PluGLIH2rBSQgAj0MdwoDFMgB7c8mn+PWxY/wnuMA=;
	b=HzIEvcd4Ks+WyrDGsNOxskHNCf9XBg/KXP+ksnOrByQ5jPVoKUvtK0wW3skod6ICQljeaJ
	n7H7wRFBZRzOVKVdNCa42rg8TqjO0MMnLh8wrs3VYsSJir7aYlNjbgcC9Kdo6Q1d0tikbb
	8tSJFDRVFsE2K3IREi1pu3ONT/ygtrE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753707803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J0PluGLIH2rBSQgAj0MdwoDFMgB7c8mn+PWxY/wnuMA=;
	b=jFNmqLYoo4oHxAv16pBid2IRDYkUChN/6fVs0csFlJua2G2n5Jf/DOl2R6rVa0Uqvypyv3
	wEgVqj0K5LYQvx6KmsRWtyJPFod12sv+jmGxiEWf2oV0CoG8A80j+hEBqACJB0x/JS1M1f
	TyUi5rqKqRPzKXQai5xu/vaTUN6TyUQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-CkeN4SfBPda7hJVEAi0kXA-1; Mon, 28 Jul 2025 09:03:21 -0400
X-MC-Unique: CkeN4SfBPda7hJVEAi0kXA-1
X-Mimecast-MFC-AGG-ID: CkeN4SfBPda7hJVEAi0kXA_1753707800
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7882c0992so680996f8f.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753707800; x=1754312600;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J0PluGLIH2rBSQgAj0MdwoDFMgB7c8mn+PWxY/wnuMA=;
        b=LEF1ApitHXUGClGzxhYfb+X97tjzIUSuUoRkkuMTFWTsukWcTd3HFBktUAp7k9y9x/
         YAskuF8jOJy1T+DkXYOekjAbthNk15ykAsD3XTCetP2oI5+tOUsKmrp4Kk5gs98OZMQK
         B5EVQltTu5vI/i3jJ7DR8ucprgnQfWdfB229q9cVLm1c3RlqVyhKp8/of8Ml6DhWCBiI
         DYYIbjdMqt0mgbdzc46GkB30ECqMAXzkV+UKhfEx9bbO453JidYNgDjjPcRng+mzCKP9
         FwrdIvIEbQeMPDykN61HSA/KWXdHmDMl33uv7jqI3FA7mxsz0iHR0tEzxtmrnnz/QXJQ
         FmMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcwk9Z1Do/lvmWM8QSETrURehiW24pLhGwKeS2svf1d3TPjF4QvhGnqJRxUv6ZhNBU43vw6BCxKQ==@kvack.org
X-Gm-Message-State: AOJu0YwMTHPIynXeQUzivbMbozdh1nsuEhhtJP2idoBq+2iZ+OW1idGx
	zI1uWXZkS1mcHG7XICy1vbSiAEKbuVynPoI9DDaPh4mHdrfCd/xvBCweX4YF8vCpJITrNN6KHNT
	zoGQWfSOxUCdjRrFO9fFL0WhdMGnolzVlyunOQ7CYpr+EQiu+1MJs
X-Gm-Gg: ASbGncsqXIj+rn1CGkAncMRXEtnJgm1TD5qGrV8+i7lgk31qZKretbhec+QuegBrrAs
	Uc4RmuH+L9YF3KlUQsuoz21t8l0HzR/GfDUCIhWeN6VYQzns/CwsRJDGyDkl/Uw4xchpG3mA8Q+
	XaozoVrJAOiCS+3yIO5hERGuk8fZa46i+KAZqYVrjxBQCVwCfjEKIdkEXlrySpQBwh6sKW+wlIo
	vwcxUMV40hZYAuK5AjJfRc0qpFYklitTGkWa8s81F1/B8FZ3w6dc3uWsyx77Y48SbjAD+Tq1b6D
	yRE60Xy1HBvvu0q2mUT/AjMiT2qu2RWxo+X+Hg3VVdeWZwm3EhYcbXowVlgzlUmZgd3uin6P73A
	6Gg2Zqa5PKLqfTpNkqStKtvGC9HMw9cgzF2H5ja551Q6CIw6sE9G/WVrhMdqNKCMqSE0=
X-Received: by 2002:a5d:64cb:0:b0:3b7:895c:1562 with SMTP id ffacd0b85a97d-3b7895c19c0mr2265638f8f.11.1753707799957;
        Mon, 28 Jul 2025 06:03:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9bM25HxST0JsiPjjgsMZ75OiHi2N6n8pmyQKntaVMlMKGwxmNe+fLVHGCDZaplr+sPD5Zog==
X-Received: by 2002:a5d:64cb:0:b0:3b7:895c:1562 with SMTP id ffacd0b85a97d-3b7895c19c0mr2265554f8f.11.1753707799177;
        Mon, 28 Jul 2025 06:03:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778f104ffsm8644052f8f.66.2025.07.28.06.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 06:03:18 -0700 (PDT)
Message-ID: <eabe40da-0136-4bf0-973d-28f39d3053de@redhat.com>
Date: Mon, 28 Jul 2025 15:03:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <aIdqVNCY-XMNICng@tiehlicka>
 <1f8d924d-3554-43a6-a75e-66a08d1ce7b9@redhat.com>
 <a06922c2-9dad-4449-991c-913fa7765bc2@redhat.com>
 <aId0UlyH9ErtGDl2@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aId0UlyH9ErtGDl2@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ipi8e9VbQDCY_GM1Jjwq5wc69Tdu4Iv1Y8UHCj7ttyw_1753707800
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B3405180013
X-Stat-Signature: 34rjtkxbrwwk698hou3qsadzwhsguc1s
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753707803-213146
X-HE-Meta: U2FsdGVkX18yn2KNf9fXkmVcUsSDQruYlZxDONRpSkelz1hgVb9K1vXJGOHyqYTw3EyB57CbUKC+8Bs5a7CoXts1xSFhtWcOjRSI1WaACcNlLynPc00huwpLBVEOCEZsqm4uS8RLr3MMkDSy7XPiOjQO0fO6sze+QJa29LPcjYFN6kjQsQfeoHib3KhEJsw22DKU55S1f4fnuTbs6LM2kFKRb5EfPaHKn11RACKQqTs4NuaWRKR/BoVIcDgZ1kr4pFhuQ0tlLYbWFL4WWteNMh+U/0pnFEMF37rsSsMZyoXgoWS8jFDF5t8b/4bL4CNewIp0jHFUDRRHlzDyzfT2qDnZmrXVTxOoGIyRtJBMQbAX+6MAXCPy5Red7Rw3hgBkxSdJ0Y4deF6R5tbI2RvjQBveJJhnKyzL+aBDbvNmKCImqjm2tSiAzvqEKTSKqyWyZ+IVNmFBIzcMJ5Cnkss6SWkItxQyxAIXUwOjhsaJYPbh4P4kXEPNZs8c2H8joblU4efSj+gdB2UrhHylQGw3uERJjYg0biFkZRNLtUE+LIb3b5Jw80GmslcQRe/JXnD6OwnctuZJTch9LOaHQlyBJR4tNZQVEG9ByxINJgrP3Va2XuIt8ATaulDUOYkHeb0V+GSbn25aufDQc2w5H5hWpRO6axB4CzZpYfe7iNbQohsJqYNagslhXW732CNzbKvT99IiilLTbiD/UIFZugeEH+MDZsFiXHYFiXuYZ7Mg+EulgITvp50VCs9ZHjWRvoVxM/OvYFHviEV1i1pIK5Rf96JSoMNebar99t9W1+e5rET4qESPonQZiLqLNdu1oc0YHFZC8nF711AqgBGBOTD197T0HesylcqKKiZcqKsJzJ44DmLze5qwsivpIlkG2AkNAe6cgBELU4e3XYg6Sa+am98Na0Y6rzoJDvbv2Ads24qf/iWg8471pZZKdKTvt9598Gq1JeJFqC4q30/psNz
 w3gZQID0
 USOLxAt8Rxm9sV+r4JEZaK9O62Jxr3vev7kjflB8iHjezkmaKHrZOFz7y8b0ImknsakJ8Fx8MJWFvyQs7aCKTziacMhLwikMgvCLmbQjlSll3lfWAzhKW+IFBm1TDgLmVMwfzBG1w1nz4lY8E0Djset76AFmULkbKsTQ9KxjoElR/nIn9hODfhRLOp4u0AhSdXO5EUzZrE+CAan1vxPgQTtJHm3ePLHkoo0q3V+Wqe6arQDToyfFS2fvYZuudrc1xeCcpo4YDRXzxGXnVOBHpE3AEmxQiKtaktUi6jlxHTVCHd+cQbx5N/vZaKhWLoXLpDnSg2gaLJ1TTu0diuQo5E76RCKdBeN+OqlN1BRTA8eQCQi+Dkz1mz3I3nIXmIB930lbwbh8267Lbn3cWa8bNXm7Fpm+QBWrodsz4X7dkCk3Zf9WluXY1Dy+jBs3gkQqN0MLDTg9Gvj2IFGlIiPI+JSDdzsCUq6L0mRKdkZxUFAvlpDMS4r1xGEJ4okreXkgSrlto6ckf2RJTUJRJb2dJcpAsqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 15:00, Michal Hocko wrote:
> On Mon 28-07-25 14:27:29, David Hildenbrand wrote:
> [...]
>>> I think the whole libdaxctl handling for onlining memory is based on that.
>>>
>>
>> Sorry, forgot to add a pointer:
>>
>> https://github.com/pmem/ndctl/blob/main/daxctl/lib/libdaxctl.c
> 
> Thanks for the pointer! I will have a look.

In particular daxctl_memory_op(), used to implement stuff like

daxctl online-memory
daxctl offline-memory
daxctl reconfigure-device (--no-online, --no-movable)


I am not sure if they also offline memory automatically before disabling 
a device.

But in essence, they want to to everything automatically as possible.

-- 
Cheers,

David / dhildenb


