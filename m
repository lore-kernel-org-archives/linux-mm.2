Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417C0C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0943A6B00EB; Wed,  2 Sep 2026 07:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B5F6B00EC; Wed,  2 Sep 2026 07:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B696B00ED; Wed,  2 Sep 2026 07:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C21206B00EB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:40:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F40B401C2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:40:28 +0000 (UTC)
X-FDA: 85168629336.14.9F335BB
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 621A1140008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:40:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N4vAT9Mp;
	spf=pass (imf23.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788349226;
	b=i/LbwNGajOD35RNTArwuTZnRHQ5ov4i8ysqisN39DSTUrOy/hnwJGXpAgGqXa1315jvKz5
	vgh7CEOqetW2h50tAIRhh+Id1QMD1YEDZzKijeT3tQ/FJrXCzJWDDiKuazwpg7AMJtr98k
	Bgk5Bu70mYdLx15A7Y8arTWw0lfPEco=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N4vAT9Mp;
	spf=pass (imf23.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788349226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVkVuPhoPxzk6Z94L3N0Zj2zqqxuaLOIcq/Bx7B8iNM=;
	b=y30pM3q4EabezgDfAbiKGQozTe3yLJqUTJwM8CYuacz4FXHhqykurx2gkjaYWdQM2q2fc2
	VLawVnDLkWHkuJUWNq0xdI/qW6Z344m3nQFJuQoKIQiUEgYFgfY8m9Il+i9L7dRpLm1Adq
	+wVPnhUAe0fgnERM+har/NLo+35rSAE=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69f7fa1c548so1609852a12.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 04:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788349225; x=1788954025; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wVkVuPhoPxzk6Z94L3N0Zj2zqqxuaLOIcq/Bx7B8iNM=;
        b=N4vAT9MpAw/qAMA+bbuBtMfLTeY8pQ70tQ330YhRzvirbPTmQiW1E6cNNI5BpE9fRr
         C/2qqNQQhTrkhJVwRBPGyu9D2PZdDzBbH9/qkE9JfRVgeCDZYen/C9G/TAyO3iBk8Wz3
         640xVcPrI5b5O5FASecd01tldKKB+Y2Uj37EdTva/ziPTufS+YLjRFwljqAwA+dmzxRt
         r+ivNDYIgXDFFxCsuSlM/rHA/ZXcr4W03Fq23cFfgH+qeLsXgPVLTgTR4AE8jxlyEbDG
         cK4lU3snnoAMm4JvuPLQGu89VLlvzvOwz9PBhl5QMu7a1j8D8hBgbVtUl49hHoXPPHNV
         /isg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788349225; x=1788954025;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wVkVuPhoPxzk6Z94L3N0Zj2zqqxuaLOIcq/Bx7B8iNM=;
        b=bPlTi8/nAVXms/9WvxWHVSOAv4PNAnQGnhtvWccqraR0DUHb9Tro9e8g7ZPtyVQDhw
         HZR+aXVr5h2KEhWuvKpL3G+4z62zuxikN4GkgFrv9Vvf84F5V9M15cDmEvNQPkUOvZVg
         eCUn5rEMZWXoMD7SPjePmd1nGtLe/SRjmkUEwGeuKON8XY9wunCM7q/asogya/tDiDZZ
         DiblqBnk+9ILjVGS7OisL7sZo8Zp1qAVetC+wRzQRIYaFD0CCBdGLxj3tBgn8Iy3WmF8
         c6VjloEWZVFv+tU2zqb/YWFkrLuy+MCBnrhOm6rCrqSPc05xMgoouv9kBYq/H9sDYJag
         G1Xw==
X-Forwarded-Encrypted: i=1; AKwUvBzkjVg6JZwtWf508FThHPwgGrR8jMnHvLdK2nymA5FX5H8m7JXvZmdMgeMNf3PBg1uRstOHcQtchg==@kvack.org
X-Gm-Message-State: AFuF++nGcoSZWMgW4gu/a24+MHHAWcivGvORn372+i9AntV33Dj6vMIx
	ecbr2ORO3UWv7ZlGn1VAYRXvz1A4XrzH6e2DUdiwHXbd+TC8QYXUaC0a
X-Gm-Gg: AYBFou19tHIPz6f/yQlqPBMJH4k90PbVRZbVGgi66MrvbUEtUg/Hb8q864dqxWgcxyI
	PaaYzFci0heVFZtzNQj8IrxQg4tBwdeQbDijUe1CZNfZrfjp0fVcwCYW9YKdKVCExVma5CFwDis
	bdKRLF1hG9loO56PofPuyCyvCyo/OFC44QXt23HddGKV4pLL81JwXxsha78yUmKDKRKe5lFXu65
	+7MHqwdhO6PhrdDba5eXkUTvlh4xGXkRS+7j63XfeEQMrdmkiSsxGlT0IL0qC4PZZo0eTKsRD+P
	EPlt8F8qO6KjK6m9Yvufr1Q1nDDyx20TiASTzXJmmg5/ni6ng3ik72a7MQ8ooLjXchx2uYTxgTD
	vej2KJeWPuQh5H/mkv4kpguDuScfyLdnTzq2YrsyGK+m2PC+FIEyW4Fi/2PgbQ7chWBegzjiNbE
	WlgsD3uMe/SftPOVqAmrD6+ibGBQDWM5KSIayI1szTnS86wIaY8WaY2VDRdoI9kbTaulST+4FtF
	vVv/wKEuxlFVNbfMyX+HFM=
X-Received: by 2002:a05:6402:218a:b0:6a6:584:d9e7 with SMTP id 4fb4d7f45d1cf-6a6832e4fa1mr3314668a12.15.1788349224695;
        Wed, 02 Sep 2026 04:40:24 -0700 (PDT)
Received: from [192.168.1.89] (c-85-228-45-68.bbcust.telenor.se. [85.228.45.68])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a67f8c7a0esm939877a12.13.2026.09.02.04.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 04:40:23 -0700 (PDT)
Message-ID: <2d7b127d-6079-40c0-2020-dc7767b2396b@outbound.gmail.com>
Date: Wed, 2 Sep 2026 13:40:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
To: Mike Rapoport <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <apVmYXlqsVr_p4Oc@kernel.org>
 <7adfefaa-91c5-4bf4-ff98-5dfbba0eac96@outbound.gmail.com>
 <apcKQBRCFeF-usK7@kernel.org>
Content-Language: en-US
In-Reply-To: <apcKQBRCFeF-usK7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tu5j8sikkitdqurqtfkq76sjmp6th78z
X-Rspamd-Queue-Id: 621A1140008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788349226-611640
X-HE-Meta: U2FsdGVkX1+WBSjVPqnbO9ADB/olZT8lCCkyJLezhRaeGg8S6L+thiVYkkW3ug8CBJ3C7hrlg/sNMkQhAptO4KlkUGrvcXVMALhX0Pk6YYIJZjDDqCU8EWfTxMfFV1f+4695yjtizsE2xr/0TbZ0d4l9KliuuqTrcL5+cSslbe0a+H9jwa90cgeK5w6lULJoLU6xl15T20PxoEFykBjXmAQBvHv+TY5+HvpBgqceBYUtqzeZr0vWZiidibUFzyUslYzWkGMuVTyGE8Mlp6We2AHuYM6JSsitNMUJjK2wqo3zv8meCLMZj83WRA2n8J1LJSDlW3z7AnxfA2bT0MZEnuu5KBHUIV5a9tPhFNTqeUb3QsoiTmIA1178eBuhLkqLKeh2i4Yc7MtG9vhMZdalYvr0/iLonJxVJRwRxi77+Yj6dGvhBj9uPjMC2VmRlkrfBrhsKdAdue8wIH2UUL23dp3YerxcD9Zx7JO01biE5J+G1g05BoqyJJ5laAvYXA38jAyUu4vClxExMKzOvJviNTPEfSRSP8zyQ+mO1o+q4ikmpVk4xw+eXLrFQLszBLCkJp0qufhDofZ5SNiz/HvH1ihXlkvDe7E3pw0tsDQHyoAq4mLM2CLX+jzeM4Um0qJB6crY1+Cuu7sKRhGHaQ7uC2g9XZLrNoFXjfhi/D5FQph3vvbJ+baTJvrit3Ztxw+ykzRZVgsXHEmHgc+d0Ila+aSOKW8UTeo+uxbYx59ZbQWM8lKHxACEBW7pcYZbkvTC09DN+3Kihvr5IDl7DRLawRul1xFTVrkLPEN6k2EbQsq8OkVK3HxcpOO9it31lCsF11SY+PO2k4EW68cvCjBtyApyQvD8WuGAzjiTFtsEtUoeOgliao61/nlugWzka8lCRHnQPqgPzL4ZPL9kaQxuGRsF2r0jOvjE8Pt+87LMOz4289Qp/rQQlMvvi8vozAZk6joE8lzXNOIDvdDXcm8
 edelBNPj
 elU6TVPcNbJnqAD7+CMZtkTak4Brh+XAaHZqni2nShVt0rBNc4qrD9oxjAN5jVnBWMCaGLtv8TzR2qLviBV+jDWde6ONTbff4fH+5AnW8kGQmzIUdXwsxuilm6ufIB/no6gniN2YIeUmEJi5LZ9tKsqxVvDw85eq9fMvk97XYP+H/CJxDAiyFogTnlCMPthl6MskhI1vLrlYOnmBpg6994Z/NRnxjBZn+XRbr8tyIkldkeAjvqrokl5Zfs5v6ZUtr8gaBX3zmng4qWAE1jT2FRhsfkin/9FXNRzWFqH8+mvLEhEgqwOAHiEERprMJksxpiDaPfY0dUZC6jYo8Pq5JjHZW+zeWfxady9IjSXRxFRtp4kC9hwBbaSVZMBLcSnQ5XXrCM5xhvFH6bnaKJOJ0PZ6lgSgV21/GP6stHD7t740uWjmH10ABj++TqryN/zML6bfJWWKXhiWBNgxQ3fcFDhugSFFkiqVk35r8ga7zInMTWC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/09/2026 19:24, Mike Rapoport wrote:
> On Tue, Sep 01, 2026 at 10:42:47AM +0200, Eli Billauer wrote:
>> On 31/08/2026 13:32, Mike Rapoport wrote:
>>> For large sizes kmalloc falls back to page allocator anyway.
>>>
>>> And the doc is out of date unfortunately.
>> I think it would be a good idea to update the doc first, and by doing so
>> officially change the API. After getting this change approved, it's indeed
>> safe to rely on kmalloc() even for larger memory allocations.
> The documentation always lags behind the code and "official" API is what
> include/linux/slab.h says :)

This is what I found in slab.h:

  *
  * kmalloc is the normal method of allocating memory
  * for objects smaller than page size in the kernel.
  *

Maybe this needs a clarification too?

Regards,
    Eli

