Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8CDCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE878E001A; Wed, 15 Oct 2025 08:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F0E8E0002; Wed, 15 Oct 2025 08:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9570D8E001A; Wed, 15 Oct 2025 08:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE258E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:17:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D145140122
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:17:02 +0000 (UTC)
X-FDA: 84000247884.17.8854C36
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id EBEDB40006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:16:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lh8Y5SDd;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760530619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmdyKylOCiMWsvGvR0pe6Xd5Vwb++Tytv/QZyA45ONk=;
	b=nTfZ5tH5PwKI5Dp+RQRSI6owA4UxXx7T7xSOgZxTGLL5Nu1WbmKcShCbqPNxup7xAsz2Oe
	fq7tSAfyhx2m4EgweMflb7WffvZf1ZjmZtMsep7TsmsO4UIbdSjy59qk9YeLc+HD3xd/m+
	z25cN76I9IVMOoznMgO8JhkdAqOy4Qg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lh8Y5SDd;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760530619; a=rsa-sha256;
	cv=none;
	b=lEs88C57ULk2dVz8nfMqzy6fnXnH1J3GLyIWGiXtPJQF6J6eC7hC2to8ydr+5A8Ao7nBox
	lGYVLOXWGsh6fMcfz1z5N5/WMfI42LhZ+dF+zkYL3WKWhmYzi/jY5tQPpVu03IxaxeWGk7
	MJV/b5iE9/V8NPJubqWzEzRtpS2RAf0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760530618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SmdyKylOCiMWsvGvR0pe6Xd5Vwb++Tytv/QZyA45ONk=;
	b=Lh8Y5SDdIsDqzdZexGjtYCkhTk0+3cLT1orlvwmtTRgmtQLAwnXJ/RWtv/DZqt9H1airJL
	Ldn7R1COYkimIEP91vJDBRMuQwX3TtDhy2Z7Bk1X6NyfN985XMxSonRYJM2KlVCABKqLcG
	4unAbfvUNi25NMWvswP6T7p2qVd6Ors=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-dLmMOuHTMBCZPGBAvhrQHg-1; Wed, 15 Oct 2025 08:16:57 -0400
X-MC-Unique: dLmMOuHTMBCZPGBAvhrQHg-1
X-Mimecast-MFC-AGG-ID: dLmMOuHTMBCZPGBAvhrQHg_1760530616
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ece14b9231so5316694f8f.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760530616; x=1761135416;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmdyKylOCiMWsvGvR0pe6Xd5Vwb++Tytv/QZyA45ONk=;
        b=S2VBPWkjFRs8gIWhlDiZHRiEc0pZmQh3YgC1INkl0Zlmr0GVQeV+dA5aN8bI3tZ6V+
         efRlbgctnZjNoilsXweEQmCnpyLxl8RS3XtTlD1DtrCQeAdrDQTzlsOAoA10xLqY8I1H
         vpVbQzvS399+IuqdszaPBT47OoN3bsNmQ/IYIfKplnOKxf+aF7VeJpjXBBYUfx9aRsIa
         ZqCLxru38zNv9h6RtkEMMGDUwG1n3fiZb5Ea+4Ry/dqX5Aex37dTKGtImCn5OXmRgXtJ
         WiCryaloWlMMfc90kBPEZJglRibY+xjK8vZJM0FhXiVzIc+i876K8csl9Y3+YGXcNXWX
         PV9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWusNzpY+iq3YmHBSYXIzaC3OcE1GwqieVspKRJk0nAXhw7J76hI0F5zYPO4ZtmMOM/7LxC+cf9NQ==@kvack.org
X-Gm-Message-State: AOJu0Yyrb5/rVv3izxRnLsk9Waa15gariPlI/0LQITHONDoILDCqHVIj
	+WyFyot1/XbJmf6C7BNf6TEM7dNdXWz0l63qwCPD6GEeYYHhvIlnaQ35Bv2+plJtvGiE1WZV9EO
	TayV7bcVtusGdh7MpSz+OpxrFWhI94fxPSbuGvs7D/Q49U0pRuOAs
X-Gm-Gg: ASbGncsLi3ma/BqIQYHw9RYUSNAhXHZ/MfySxhd3ErZusRS3AZlwI8Fsq1tm1mbmhwl
	Qg/Jn4RLLgPpYwCYy9WncgvnUI9Z/Yq0ZxG4facnHVm/EMvEWXXrm8M5F9irbxnKW+C/bGsCstx
	l2sEEenP0VwhzUxBVYvllP9oPCPIIVHbB62S+VVMVl5h9XmVqLx4RizBXZkW0ZQCIdB/wpaQYY+
	YkkTmGPEX+H9YygIJXLvmaUCl69qCKVVPDN6UawMF9Zr5suf4smoebUcriPEhtq0z0jSpFGxQpx
	3QLDykeGQt4jK8qGAUrKXZ7IVMirRzyilwPdEkmXkKssyJnm/1ARv7MPUrfgENI=
X-Received: by 2002:a05:6000:3101:b0:3ff:d5c5:6b01 with SMTP id ffacd0b85a97d-4266e7bf0c2mr19302333f8f.19.1760530615702;
        Wed, 15 Oct 2025 05:16:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHq6JiR82m9bDrKg8Wop7vTO6rx81ModfpoM4Z+5IMKNQIQwLb7JjpU9QbP1EvGWm7Gd0fGdQ==
X-Received: by 2002:a05:6000:3101:b0:3ff:d5c5:6b01 with SMTP id ffacd0b85a97d-4266e7bf0c2mr19302294f8f.19.1760530615229;
        Wed, 15 Oct 2025 05:16:55 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cfe4esm27898783f8f.26.2025.10.15.05.16.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 05:16:54 -0700 (PDT)
Message-ID: <f807f3bf-a05d-4e0f-af4c-bb0167dde51c@redhat.com>
Date: Wed, 15 Oct 2025 14:16:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: call back alloc_pages_bulk_list since it is
 useful
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T . J . Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>,
 steve.kang@unisoc.com
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
 <20251014083230.1181072-2-zhaoyang.huang@unisoc.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014083230.1181072-2-zhaoyang.huang@unisoc.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ff9WLumm8cYXmUnjbKI_xdUxpdfexMz3xCDiEzHUTJg_1760530616
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fsi4umn9cxrmecdsqw5ukeu5uz7uwbz1
X-Rspamd-Queue-Id: EBEDB40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760530618-295848
X-HE-Meta: U2FsdGVkX18/6fewu3wrtHafupImD93MEW0Q8LZ3GVlApk5bhOFKILxwRnWioM5ktHQGZOaQlo0iCnEtGFsILSxJ6s5DL9T//+xfCG+8tNxv9r/wquOyiqbnhG70vi+q98BvqdyvrhycqCiQh8Ou+y8ytl/xCmoPsHV3MZKpY802ctarN6a9IbgVd19PL1O8mC/8t4TABQsOQJxXp3vVZ3jNlrtazdzL8j4NoIwV6aAKBfPi/tOolkjW+6Q0hnLIjfKCfakx6zMzLgitPS/u3ZX7jaUJ37sZzXqF2gti1xff4Q8QhOkE7a4V5uSi/c6S7MM/7VpyuPbYehj4m3RzZp2U+KbK/IW9WVUXpeQ/nQbPwKneBqeUK96WoGi3m9Csvwrxu0yG+Q3uui5mpYWQ1TT92bo/mO8U4S56ilCJf3+H7dwh9rw/gH9fFsbt9FKZtt75YudgZi6U7URQ+/VcgFsprckpos7ZyPPTge3GbsfPaYrpARLwL3bZ4NWZuZBMEaiX5DxVtUBoES/AMeJ/oCavYBAKn5vzzVUKqJOmj5crpR4ZnKWyWxyuMbETROFWaDX3MTtSRaAjaLh1o/QpxCUo9Q2OyeAheebu0VLYz3B5PiCiGVdbqqzNSN+YEWelyMzTnvLCPuVqSP5/aqsZ7fkLftMjmDAJj5vQSpUX6+nOnjyMT50CuovBsTM2NNhP6+GFehLxi5zitUm7Z4yOPBCpj3eLq79bp4u8752fcnENRx234Sjm3O6sBPAPnsG2KEvU39dc9lqnJEki+pSvRC6yLNH+mRGWS6lZ5WYFtjz1OV2tslF1lV4n/TJfP2Mw2Dqeq0KSeRCuJXZyuIZCzwHLpCibSrV8nrAnrMmjWLpj0QpLEQvyFZXTjwue5UwjwfcAMs3mMr/JfCUo9zoliJlVlb9hI8x3e94i9JOrzfU8c27Tf78El6Oxknpw4zajvLwcFjTQzuo93uYg0oc
 9hCmsm76
 DanfxElRpGFTnoXpIMu6bMZRhO2KhKvtNThBhKCLtu10Rvd9omBk7GnGFynKteGA6SJjO+Van0Lb8WemI1a8rNSa37lq3sZ16ad9zdz31H+NktP2DZ3xt6UxBehD9WHkmbAItprQCJGNzcZgGcl82Q6Qbjligzx3Mm4x3/iMdnPc3+BbvNeUptXgivQj+OnSIIe6rN0sjsoqNoY3/usTPeTQf7sryHph3gj3tuQk8BbL0GFoKcw7TiKPV9Zy4Kj8RwSyMsw/HIY9u0OBHy/q8cXELk0Qc6G4yIDkUPue0wYs/7YKVycwrZGut6AHt1Z18trncATGGyZi9NsmYUgqq2TRlZUXCmu+xgfAGHb/V8UUbZr9n9BU9wVJfWcQ9nMBgmgU5HXjGKK4nG+MAQ/lzuDr0qGFJTOqFIisJamOwsPddhgUFXBwe3/scug93K+cVzKiXgA2Ix4Wmq5D9YryX0YYjPnfDAfXFBgrGOmI5MIDfgt4/vrCHaTpdWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 10:32, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Probably the subject should be "mm: reintroduce alloc_pages_bulk_list()"

> 
> commit c8b979530f27 ("mm: alloc_pages_bulk_noprof: drop page_list
> argument") drops alloc_pages_bulk_list. This commit would like to call back
> it since it is proved to be helpful to the drivers which allocate a bulk of
> pages(see patch of 2 in this series ).

"Let's reintroduce it so we can us for bulk allocation in the context of 
XXX next."

> I do notice that Matthew's comment of the time cost of iterating a list.
> However, I also observed in our test that the extra page_array's allocation
> could be more expensive than cpu iteration when direct reclaiming happens
> when ram is low[1]. IMHO, could we leave the API here to have the users
> choose between the array or list according to their scenarios.

I'd prefer if we avoid reintroducing this interface.

How many pages are you intending to allocate? Wouldn't a smaller array 
on the stack be sufficient?


-- 
Cheers

David / dhildenb


