Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBCABCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 11:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD3D8E0003; Mon,  6 Oct 2025 07:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D9C8E0002; Mon,  6 Oct 2025 07:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45598E0003; Mon,  6 Oct 2025 07:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB2898E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:36:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63B1216054D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 11:36:50 +0000 (UTC)
X-FDA: 83967487380.01.1C2B534
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id E27EA40009
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 11:36:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W/N4t3TY";
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759750608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHN3zB+N3cficB6+biNHEOHdUuG5loOtVKEpUTZFgh4=;
	b=em40bpMTXdS85MjC25PATgi3Vn/ZWEZ3M2KqnqGU221KCkI5yoHYAXSWuuQl8oMowVOzRB
	cc590aavGMtHtEBPNrUZo/atZxKVzSlnxEvMCdO++41m+3ycaoxemEbuO/0A0HWFMfuqnS
	uHQCRJmblay02MKRbJg7HE4p+9WO/Os=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W/N4t3TY";
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759750608; a=rsa-sha256;
	cv=none;
	b=IvVhs3MD/FTRGD+W9bOr7dRISUlIjMs/mSdqJ6lvGFCvf0F+MwMQnbEV7nbyD0nXEd31+H
	cgTWGJWOV/FKO79aC6e9JIsYljDqSeCC8TY9Vna5R0HAXROg92yV2N39xVDdSe4C1+Oxb2
	dSIN08pWMfSfp0DzPBZsWwHvdf/ywAw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759750607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vHN3zB+N3cficB6+biNHEOHdUuG5loOtVKEpUTZFgh4=;
	b=W/N4t3TYM1sQnpfbFupWkmFCDGhM9XywiZMIdKTqZyxVaZ1pDe8Gq6e3nBb1aEPxm0W9dS
	WSkQPvpkP5XlY4wwZiSqf3rcHRWg87Tu1lzXpRhKSqsFgDfbPHZQSDbIO9DuZbF9mFcLHg
	4u3k35p/H2ZSFb9XDDiYPg36NYWtCjQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-X80ue7DAM-CBLZLJSJEP3A-1; Mon, 06 Oct 2025 07:36:44 -0400
X-MC-Unique: X80ue7DAM-CBLZLJSJEP3A-1
X-Mimecast-MFC-AGG-ID: X80ue7DAM-CBLZLJSJEP3A_1759750603
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f3787688b0so2627783f8f.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 04:36:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759750603; x=1760355403;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vHN3zB+N3cficB6+biNHEOHdUuG5loOtVKEpUTZFgh4=;
        b=nkRUeWOBfL3UWyns9pbKND7KzntMOcg0/I77TKz2MLfSfyGTVvzfjkJ7BMjxowKzQb
         MPAbr8ietJYMoNPAvJ2UMwiu1O00ZGy5soskdxRieG/YCPYywVewUh1rT3dZIzAjLBPX
         jbN1/KP1RJv/18EpLCngg2Ctc0MUlW3OW435azcOkiB5AO7EjR82m2nTqn0VIfzBoFU7
         /jRpjzLvYmIyaJS9NAk/lu7/77tSW5xgwhKi8f+XIVAFOmJwT8GjhcEC4EBhuJHsLVZ9
         u4FARrJW5gxB5mznf9DNVDOg6x+vnDkwrz1NIi8CY+ui7cAgwnYBvzsgy+28nspZMSzg
         xOeA==
X-Gm-Message-State: AOJu0YyohRJJeQkQbmBBnapA9tJV2Q8nPM/nZusBJzMWK6EGuM98Xviv
	SxuSmN70Pg/nbEB96J+k0BhHG46iMAgglXdniZkYFlRSB7OcrQQLCvPxpCJ+swgwJz2UxX4GoSy
	iKAdDqfBYp9/2hV5y9bx+ITuxvOhk7ZoaBD9tct9Xp2+ttTynfAH9
X-Gm-Gg: ASbGnctwjUZam7Nhy+NCrLwU1KtZh3uSScny2reNtAt/IgwXbMx68o6wnnbzamBEgEl
	TYtDZTMkDHRbnZWgOE+TL16hyN+GvZA6wJmHftsPNMzQHAHDZ39MD/7zhPRyV5uhnHGRN5gBffk
	M9a3MPVTV51b0M9+tjKE3TMBwDj2HQ9R8AmzQu98wLLnegs/TrIfie+sRwug55ZBnvad2VU1HSr
	nRlEwmQskpI4dZflm1RfIkfU+SUJe2GgbLWsK1HFnFWo5lbEzxq5ApJKP7+8zeq+tB62YOwpzqN
	h+CHVrFC4ojltIdycoitZA4JmeNjPTlhTwix1R2NrQ+G8XlD5U9DOZMnKWnVFJPQJw8AZOkrn/g
	NP/IrxrUe
X-Received: by 2002:a5d:584b:0:b0:3ea:f4a1:f063 with SMTP id ffacd0b85a97d-425671c15f9mr7577060f8f.55.1759750602864;
        Mon, 06 Oct 2025 04:36:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4fa1egcyF8r1G1AFUJgPykSWMK+76QilbNO7Gb4q43iQveNh0omx+isa8IIngfIMXEURqYw==
X-Received: by 2002:a5d:584b:0:b0:3ea:f4a1:f063 with SMTP id ffacd0b85a97d-425671c15f9mr7577044f8f.55.1759750602454;
        Mon, 06 Oct 2025 04:36:42 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8ab8fdsm20309038f8f.15.2025.10.06.04.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 04:36:42 -0700 (PDT)
Message-ID: <edc832b4-5f4c-4f26-a306-954d65ec2e85@redhat.com>
Date: Mon, 6 Oct 2025 13:36:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
To: Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Amir Goldstein <amir73il@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251003155238.2147410-1-ryan.roberts@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IM0Nyh43dOIF-xbZhDjeeU_Z62K_8u67LW3vTI6Yad8_1759750603
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E27EA40009
X-Stat-Signature: 7g3m1whquuxyo3j9aj43e8bawouhtei4
X-HE-Tag: 1759750607-180441
X-HE-Meta: U2FsdGVkX18I5H40ZdPZ5SZCA27JdSC0mAQkMVF8nxN6P8n6H8mzquJi7wv8SF8atrtmBpjg9XGZzxUb9ENqirYFjDKOMaf33grZNV0GjpRRj3Y2CL2TvCzz8N3ENk97CNnKbm6ed96KTLo5eYcJzfBmjPbVU4XpvtF/7eDN6wevadoWtRgmSPC0pmyW7NCbnHFIAH52EckGhqABFfOTQlYxzq6T/eOui5ITFmvk+6OYtIINDbz/SRnHOnsl5v5bLj94NHnBJjMWuPRwIFQVukn4KJS+x1qW2+BPV1aMhEEofYoUN/+0RHlcNSPSQ8PosiM1NUvyiJmkqpz/OGXqqobbfDj0ZhaZ98XxiWXz4aa4nHP0EnJbn6670zRZzeA8GR45vtt2hCDcTQfOtTBv0pLVfTF4fLBqyi3LMSF5YlukswfSJHnBmtbiAGefP6kKFqs7cVYLngOnHKvHnzyg2ynbP0QV9FFVtX6PmkEsjhrY0lSE+lWeCH4FKeEBqdQdhyYiYXahad8UBmu+o7kU+DSkS1PO8ecGNpVt7PPVFd0HMU7RHrlp7F8spGHbpxxkhmr8l4P+07osqSWmEJGK1lBrKEfMtV2kkN6DkSWdgeSub8prCzP2Lv1pprtzIwzTLAKgoyksMuxJR5VBqMYiUCN/yjknWLxk7I6m9bvniS7czom4D4tqG43/J3mzlYH9jwzofFEuFLcNOZPjJzSXm9D/Tx+L26Bd96uUHjx/HWeRdcODdPkvVdp8sbsmQPtVsn79w/+rczcPJz3dxbi5jHTVlYmZjnInVQINOT0/cEPVMvYdKUTdt0GV2gCivRVkWMll/eerj2FwuztkvPDUlK0w6ekDT0jpLZ3yw1h47BKGc/18Yqa7J7T/g2opA1tHA5B7A3yRNnZ9bSUNeSJFpgPJDXpSg9VdYrLjlLS5LdmRSxlM5YpJW/yLGFuBCHolwsacqnW8K0tj22UjHi7
 /AtrQZGg
 aROjkDPgSvAaeH8mMFRLVwc+rfKffpmefbZnjIfwRAxdlfZefHUF5FhWMYQ103mpIyGipPJjDfkSwxi7S5IXHjO5zGcrmypwCkV3zH7SxfL/jR5Grpx925AmfOQxaO7DF+auPD3dTrOXBzDO3S9P1R0rUYyK+dQfOV/fHwSvNWRXijtIqNcxZGZH45mtSdAzAe0yxEUa6PFFxYvyicSkghW7bBjEa4BHAq4S9yg5MOMDZrw/UykYVlNKDZYkWfjdHDZ9YzQtI794ACYfs98rYeoSnU3ATx5YtkT3Po79w9UUXOZduLRGovSjzQyB2EUJYqq9Dp9EH9XCubPyMjmDinqQpBk2ldQuLMGvSht7BOOnbeXNVLKV3I1OkKnpzm8AAz5/azxbhbdVEvgQj0S0lJumHaAoAeHr9uyqwNiHxPJ2ZZ7wBGVr0ycwoijVyfOxIgTJX0GH83ZQ3gramwgdtg/F++14ocvBq7gJSVK/lzc4+09zE1wgMKVWDjZg+jUECbjtdpn/us4dGFA12BAZwP6Jyt1txweShbgV8yvSRZSeJ4ZRPpn8u8yEAdj/Q7j/LQxICw+yZyvEZV4PpAm2HY/67/9ch61yrvg/PLsVCjH81ZtPx1d049gxr8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.10.25 17:52, Ryan Roberts wrote:
> fsnotify_mmap_perm() requires a byte offset for the file about to be
> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
> Previously the conversion was done incorrectly so let's fix it, being
> careful not to overflow on 32-bit platforms.
> 
> Discovered during code review.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
> Applies against today's mm-unstable (aa05a436eca8).
>

Curious: is there some easy way to write a reproducer? Did you look into 
that?

LGTM, thanks

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


