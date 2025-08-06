Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D40C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14766B009B; Wed,  6 Aug 2025 04:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBD16B00CC; Wed,  6 Aug 2025 04:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C8C6B00CD; Wed,  6 Aug 2025 04:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B91EC6B009B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:51:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61B61160486
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:51:44 +0000 (UTC)
X-FDA: 83745714528.27.B2FBE02
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 044B2100005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:51:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CcLPAqSF;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754470302; a=rsa-sha256;
	cv=none;
	b=lprxX+KRk0QZaWqojvYwQ1jaUexDpAPfW3KPVssSH3llJcbC6+fXTQp3ZDEKnWe1bexqqj
	9nKE9krLfb3gCNBLZ5cdFWR9fY0PteReGbs9ANuIjzem0wAR2qDJXYBQ1Xsqy0fnG7N36V
	THfnhl6MbzKFcADrnoWzh1jPRRUP69s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CcLPAqSF;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754470302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IwNT9i/JwzyfF0WXSmv6SUio7A4Qs+8y1jGBSlhhlE=;
	b=FGILm+ArOJkC6bG4yyTiseivdlbOyu30NeIKKpipRlUiYYB/W6AznNFa73jUg2BXTO15fr
	DzmnMecZxxmsiAiqH+mZo4mE6PqYt1NLzZ/tlzw+Q9JJ8qSpJ5pIy2KrJeSLh4SbdBwreM
	3Bte1Kwj5COhMTYXSQgjiHBFZlSreQU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754470301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4IwNT9i/JwzyfF0WXSmv6SUio7A4Qs+8y1jGBSlhhlE=;
	b=CcLPAqSF7iEIOlz8OVW41Ae7xqfqT4++tR+F+Q7FdYEHqKwRBT4PlrvXt/uGqHmhr6NbOb
	UC4+01somXkWfPGSxwyt4CLlLx4oElYelkS2NBoMUkXtZZdbpO/rhvExGsVzvXa1IX898y
	L9jcCKado2Wc/aE+wBmrijb7GLksGdo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-CC3saqqvOeWuSn4ZOkwXvw-1; Wed, 06 Aug 2025 04:51:40 -0400
X-MC-Unique: CC3saqqvOeWuSn4ZOkwXvw-1
X-Mimecast-MFC-AGG-ID: CC3saqqvOeWuSn4ZOkwXvw_1754470299
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b836f17b50so2789147f8f.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 01:51:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754470299; x=1755075099;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4IwNT9i/JwzyfF0WXSmv6SUio7A4Qs+8y1jGBSlhhlE=;
        b=ZGk+a9ZPgQ5VoI++MowqMyB7k4+UL/nMZ5rb4I6cl4pwo8tem5lnwyUXOTYxP7/SSI
         qkG/aks3bVZGom+9DTCXWURhi9j4T5obQCuglakRyig45unczhB2qaOiobZCdWiz2L5f
         R6zBzvECcDpGA4vvjsu0881LkUTVhII4KyqDsXLJX5NAKRAVMH4E59KKzlHREvZYmV5D
         62ws25ySD/gZDk14D+5iA0Cr4OtoWPpBCXXhrzj+qlTFKVczV7zqUgT4PFJirsLYc9xt
         Lxxo9ylW1rStIwXlPLiM908SbrNWBgkEqS1V9nmOBLzZ8/FfrYWWYEKYIL9N9NinpE4E
         NB6g==
X-Gm-Message-State: AOJu0YwieAsyFVzKxPrzl+DYb6vryKLY3InZZyRJIvRMKk9IWfqCGfdd
	As+pgjRKnIRF63Z4LbUnFIYFMOB+EVgXI81o4TB47hLiAJqaxFtDKqixZyql6W+baqm70G59nRr
	sjDQKET3eeXoRQlXx3/NEtK7Lg8F22P2/Yu5NWxN4pMY7Szub18yb
X-Gm-Gg: ASbGncv7iE4bWVCuixWzJhogYG78oKvVNWsWltrXDIanz+K2AJ8QTSlPcwYWMnisluG
	Sbe1i4wdrnF4dVpdlqnw7hyZ+25PC2I+mnpR0HRfyVwBzxxn3D0ic4lovAPSL0nWZ8J0rjbvK0j
	2NxsXaSO/97fJdmYlU0gbJ7Rd14Dt8A/Ud/9hNirpJUOYFpaK/VLo1Kx7WyI1UABtPUXDM6l4tp
	mKX56kMOa8rG4sKKNkOjKACRhN6r01ee0ZxdUZ6SFdttJkaefJRQo/NyV9XL/2eh9CA5Sr5Xx30
	Pq/rq44xq0uU/NzTAvKSvm3N0iSkczePq7B7c9kT4/O7tdpHT1DgzUMv1HMxVwHs3zx/03daQ2e
	fyRdeo292NMlyUCk38oFLJBU/W8m/h+Hkg/XQ2GCleUbecu0Uhcxgym6P2TwhrgBxWYQ=
X-Received: by 2002:a05:6000:3107:b0:3b8:eb7d:f82a with SMTP id ffacd0b85a97d-3b8f415f242mr1693298f8f.3.1754470299002;
        Wed, 06 Aug 2025 01:51:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHs0sLPv6yMKhOQrjuK82i6lu18QLMsncnzFBpwyUyzNv9fFv8kUEdIpX9vcp/OMB7hxfeeNQ==
X-Received: by 2002:a05:6000:3107:b0:3b8:eb7d:f82a with SMTP id ffacd0b85a97d-3b8f415f242mr1693267f8f.3.1754470298533;
        Wed, 06 Aug 2025 01:51:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953eaeeesm305390535e9.25.2025.08.06.01.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 01:51:37 -0700 (PDT)
Message-ID: <9ec621c0-ab26-442e-a07d-06905699fbc6@redhat.com>
Date: Wed, 6 Aug 2025 10:51:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Default value of CMA_SYSFS
To: Jean Delvare <jdelvare@suse.de>, Minchan Kim <minchan@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Frank van der Linden <fvdl@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>
References: <20250806100748.21620372@endymion>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250806100748.21620372@endymion>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3qqciB9m1T4in5sWcCAPEJI5nTDQxj3lkLPQA8w-RyY_1754470299
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 044B2100005
X-Stat-Signature: mhfr3z3m1cehs9yqh9b4hgcg54xbzscf
X-HE-Tag: 1754470301-133883
X-HE-Meta: U2FsdGVkX1/TblvGF1bhrEHpKj+aWp7j3M3KfVE4B3Hfg/huDV2j5DZtM5z+bchpM94AFBeYIG+yGBe9tINMhKnrKY1y9P1ZUbrKBl9vF6xqBvXBXd4aAD5kPV3znBeEUnuArC9NZQz8uwUVZx8Tk8hV76okdnoC6PFloWfrMxo8INnT8ytG/tTsAMkS2//ILo4PKZj5tbtzXyDdjggcVvmFv3qfvdpghvwSYBPgddmdiNA4b6xtGDqGxa/4yczEfGmAPNq0s4RqOKs459bISaI2dM07KF82D1HK7+7zJ4tviDdpSR/Vzt49CWmwxQMOGDWTf5pzu29Px06JQbwB8PKt3aCKFAe3vBmMgW5iqCjTyirLrVUYxlIp5jJWX8U9V+XiZBl2Dsw47po+muO/UB/PNOxnP0U8E2tQAPXu2G9cZPBGtqzE13Er9vps6wHYb2Y7FCJHT6h53UyhmBu7eobTeBL5rFlsV0hFQDa68Lm5/c4znXJpbB90WL0okn1oxAeP4ufXTzRf+McrAGBb9yCnrY3O2fVsF9djK5H5j9tXpLieLhZoF1pXDD1WZJ3UCP/UrXxOoijreDMKv2Xz3FUSTXsElg/BDMOF4GcIEwCrJH4jeF3vV9ZBwQtHpkTWD3e8K2+lqj09ncpOPDZT80u7p6i9RRg+16WsXLKaELl3tsH2k/3aRq5xipcxRCQtF1ua6twgTd0y/mrKg+1Ctd3767vVBNxO7Oi3bCfDE1hz1GsoWZxr9bLpoV463jVPs5hmwROkkdAFOf3ymMr8twYlI3JVwxZD3f5HviAWK2cK+bg3IUhhg5YPi69Npcy16aRIXRDP4wC6FkrVEj43+xKbrjgXbi5EEUHe6rIzt0FVXYSQ5ANJKD4shcQHjSGuTfu2ttXSemOHplIRekiCArOWAXnf1jM43y/EHA3jOefUdz+N7OreFULkyv7NTzYQ2Z7GFT16abQyyQbXabF
 78Lvd2vI
 nPg7e5Sm/d07WVvw4hs62EyWg1+YPfNrB3J9Wexy2jlxvjTBspeQgBt18O2QdC3p+5qUeN2mIV1/qSaMpZrR258UiGABwOdJTNVINKfi8t+atEh1kk0zhGVzJeha8V4EaItdBPNKf7Z0O8b1p+zwhG4vhFQV5zTxnece/RrGJOBl0PGN0m7Q8If5L3/zXa2JksmldXbGHDYqDvgDx8QkJeTtbuPtcDMf9T0gCb0H9ApFvdxIVf41OWmHd0HR8unRvZ1sDVZIlkYF0PDPbpPolmqeGbHmA+vrb/KAnZB6JfR36Z+G9H6aKOu47mEOSglY5gVUn5qqJX4rrGJBZjyu5E7RBvogHHoQ5tDXqmZkiUjfH9voXISJgXPRhJdLxEt/rXejTUAEBXYil44n1eEN2Ox0wipodUV748l2OFUl6leQy2tdWpEZGvjsY+20dEVjTFijzQ52vIr++nuzsEvVP0U2U6kKzDZoeHNyioCHWOk78yq/unj2t1vaoLu6YkrXtg/cnNb+dPifJIPSDu4oAG1YhPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 10:07, Jean Delvare wrote:
> Hi all,

Hi!

> 
> CMA_SYSFS looks like a generally useful and low footprint option. Is
> there any reason why it isn't enabled by default when its dependencies
> are met?

Looking at the introducing commit

commit 43ca106fa8ec7d684776fbe561214d3b2b7cb9cb
Author: Minchan Kim <minchan@kernel.org>
Date:   Tue May 4 18:37:28 2021 -0700

     mm: cma: support sysfs
     
     Since CMA is getting used more widely, it's more important to keep
     monitoring CMA statistics for system health since it's directly related to
     user experience.
     
     This patch introduces sysfs statistics for CMA, in order to provide some
     basic monitoring of the CMA allocator.
     
      * the number of CMA page successful allocations
      * the number of CMA page allocation failures
     
     These two values allow the user to calcuate the allocation
     failure rate for each CMA area.

I cannot really tell why we made this configurable.

> 
> I was wondering if it would make sense to add "default y" to this
> option. What do you think?

I'm wondering if we should remove the option completely -- or turn it into an
internal option only such that it's no longer user-selectable.

CCing Minchan Kim

-- 
Cheers,

David / dhildenb


