Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8263CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C0B8E00D9; Tue, 26 Aug 2025 09:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313486B00AA; Tue, 26 Aug 2025 09:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2296A8E00D9; Tue, 26 Aug 2025 09:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10EE26B00A9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:28:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0FFA1DE5E6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:28:18 +0000 (UTC)
X-FDA: 83818987476.14.114CE4D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4030BC000A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:28:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O12FwPzR;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756214896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w55BIEf4EYcmqQ5sHEPI6z94gZdWCSaYMX32qUl/46I=;
	b=3GPMuFte+J+GtJT6bwZ2XX6CNaU6Ocp8F+64u+dY89cbnUqQ0GbMtSugmUW022OHuXeQmp
	5MnwBRWuAquw0Z/G8g5IUj/yPEPK1+9wUoRqOGUk3WOOK6xzp6u+eSvr+YWQtA3/wO8TBd
	in6IgPwhm9L6XSXsIYKePFeGDXBd/aI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756214896; a=rsa-sha256;
	cv=none;
	b=fd9jNlNO1SM+HDVWybZ4LCHCXS3nP/Vw+zP01ObMhmDXzx34pP44aQHhcB2KTf8lG/3RVG
	9BA5FTpRY0XXDLl1wtmrq0cU5FFp52wjH1V/n2fVcCwq43yd9tC4PYxkWSHx43XaNcAWFR
	u6JPwV6oWn1iV2nVN/8ExLIcYpbBrXU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O12FwPzR;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756214895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w55BIEf4EYcmqQ5sHEPI6z94gZdWCSaYMX32qUl/46I=;
	b=O12FwPzRgKxyIhZmaRp3NRAr+qlCK6IeQ5PJVCewi8T3XJxpbXunlvTrwPvaG/zZ3Jcw7Y
	q0piXaU1/Lx3btOqgcUHEgRMGKEig3mqpmXbRPCwL/W01RLstDXUJe7/i50Wq9q0oWNS6R
	ZxP7M1F74iBc+mhSlckCn210FwuaQSU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-makFPz6VN2uLmaaJlOIgIQ-1; Tue, 26 Aug 2025 09:28:14 -0400
X-MC-Unique: makFPz6VN2uLmaaJlOIgIQ-1
X-Mimecast-MFC-AGG-ID: makFPz6VN2uLmaaJlOIgIQ_1756214893
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b645707f1so7593345e9.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756214893; x=1756819693;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w55BIEf4EYcmqQ5sHEPI6z94gZdWCSaYMX32qUl/46I=;
        b=WAeLt2rtd2rmO7v3zSiJqrXs1kehLfsxoQGXBT6fofewjUWVd7+koJELFsMgcyChlb
         d2seFBgRF7ILcosZIfFhtvqMUZx0wRBt/qh8ACgJOUtINWYJt+6a4sL4FxvYPhKFUCzl
         +k6eDrEbFyY0rL9DmIniCUG+pnJ6eNktINrH3J0/cudQah5PFxQz/EsZGUPZxqf9fHrO
         RceUIaSn4vXPNUKdUz23qxAuFV+ia3eYOFoMQ2Apzo/yUiuFumkJm9fyZxKcplMq1hlR
         vdfNp/SSCJoPWsjZZ3WXxEUOOllfuxlLpcvtY8oNXkDMIcODMv7EhNjASftPcODljMHv
         ukqA==
X-Gm-Message-State: AOJu0Yy7RnOfy3xwMruURXbWAtNFAknloHhCiQ5y5w10yRSSjq5888tS
	im8VHOKffUVRbzmQ/9Fkw1PxjWQTyj6LPjGyZ+FZTOfpqOu/VKxvR9ThodHObHV81b9nGGb7xCL
	wzbY8b9M2KlBftyQP6mrVsiRr18nfPXjsgE9Y2Jt0xWTRMuUq40tl
X-Gm-Gg: ASbGncuNXA1vYNyUhAPl/Hg3WVgcIo0GlxmjjJYy1zsHZn/1n4wm+iUS1c4VQS3SFBf
	he4simNWeEsJUHz04PoBTqViANH6A3Ht+mKI3iQahf+qKcl4cgd8obcYFlL6F7GMw6FwWznr+KL
	m1hDezxoTbu0RDRahPou+ZVGvDa5+m9bikRzBbnvQ3qljPDnrP0BcCjmfcrptSiQ/zw32udznd3
	/E+rAU3Zs8aZxodMZLZ7ECQ054bCuFc/CU0rkKo0siCe8O4TkO20wcf8VYTHeA/J20CPrKRCZRP
	ufzRdHkaHBKqM1KCjVGKAi08Sj7NUGhReOKjIFHPQy8aNdy2hwpQP097+QPeJVpUUoYAZWYCCg=
	=
X-Received: by 2002:a05:600c:1c0f:b0:45b:6365:7957 with SMTP id 5b1f17b1804b1-45b68bc7a0bmr14493885e9.33.1756214892823;
        Tue, 26 Aug 2025 06:28:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFl6rGgHsCY47n6iMTLj0F0dE4tbBYIyMb46MnaisOfsl44aZ1WFBH25I7XDrQIoji72S6mg==
X-Received: by 2002:a05:600c:1c0f:b0:45b:6365:7957 with SMTP id 5b1f17b1804b1-45b68bc7a0bmr14493595e9.33.1756214892384;
        Tue, 26 Aug 2025 06:28:12 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57492d32sm150786955e9.21.2025.08.26.06.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:28:11 -0700 (PDT)
Message-ID: <69c79743-080c-49d1-b262-6e91dfa0c090@redhat.com>
Date: Tue, 26 Aug 2025 15:28:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better
 reading
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>
References: <20250826093148.30190-1-richard.weiyang@gmail.com>
 <20250826093148.30190-2-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250826093148.30190-2-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fC7cd20S7Je9H9Fh3vIgRne_B24J9rudUBJ4aPpF0Rk_1756214893
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4030BC000A
X-Stat-Signature: tbs9etr53esb6e1jgrert4njabpkfy73
X-Rspam-User: 
X-HE-Tag: 1756214896-269990
X-HE-Meta: U2FsdGVkX1+gPIppoiPGpcU+G4Q53Z+t4EHodShOYZeb1eifmEnejUGGYUw/wNZZqg34xnPCyKMv0h2s3FtNEo0rU/TERID9V5CXPvYbD41X5R+3irgPV+Jwh+s7kQhrfDhcSPnBvkO1F+jDsWmj5/bIVzH/TcJhy+r0yZrsuXUOWw5Hz+FOzropMKiWHaVSsOF3XtIEMZJmJJLPKF/DwQzoDZF69gQPMOb0ID68F2l40wLUtF/TUsQfEQKAFJI4tPxx8JXuc8MbRe3kusWD7osrRZin8kAhkctOZjzl3G7m3jDthoh1ZhDjDT3wl2/2pyrY5UecVkmz3KxMuecs6lgyRGjpkp2h44aFaHkKQhnybJ1mZFGFOsArPAPpxVDHv6GZFx/ZrPRbvhmo2rgFSN81Yzg5s/3iC2qSWsTwlN+NGdhSZURTpU2axOcB7tDfmIyIwk28XB8nw2Xp8EZ+BIkYuk234Hr3UWqcLoOVLBJRt2X0y1vwQfFbfu4WN9aICMXGPZS5doS2cQFRZz0x6XUc1xaRf04yYVfmkFtzPMDcjT77NYTAriJDCfKL+sHcLr5YKqTdyhQn8AOeW6CJN5CJRjzF/QJt9x0t8hOzdvo4759zmN1O/Z8KonhtQHgF59GaT6OYSqxY2gCt66dgecvL8JVyD3hblzvZxbcrko/ynxpnvWx9jhMkHXFDx/33zPDOhU61yIlY0aO7KjM0jZd92P0/3aggwi3LEDD3iR9zLSsqiuRChQj88WZS5MYbJJlXFImZu6MRRCFRnG2eXLHokXgEIeJcmfE8rIYSZI5lHpXprp7dLzW5dM5kzyM0dfs8P5zljY+71sjsq5OvPjN886h/oPSC00HAT5JWdQN9N4kxKxrvvZqWFofnNtErsiUYFiQ7/snXX0YiGYsNY/IACsBKE2bWmmFebElY+ahCRx9/f04Y/lSzc3B9Y+WpPbqEQ0cLk43K6AnEhMe
 A3s/GmHA
 ftUgbc7TEdU3XSh6VTcDOamjtak4i/zHQevO9IZV7Q2qYBjkkQJYSrgBkomGzewxeGp0lGn6nuuDqU768Ph2jF6nMrpH0kwlDWMa1RzJKJIE+kG+yRLsTZl2nptzliiq8LuXotRCDe41mrOkIkTQv8g0V9Y/3uvG/V2Eyz255Jel+3IxwLPfQBfUqUmSgi+uH95xPTtPonCPVKCDdk2iOivNC3n/y5LQLXpjUxNapwNWsGp86pALuKRJPC8SZBhV1V+iAjtEmQ4u367Lk1ep7VY3fHMj75wkQiRiv86sKWTISlEm/TpQT0Sf83EGz5W8ptY5uQL8QzdEzWjkQ/soSKSVYowRPtvNOgGUKDV2rtxGZrBWZED1a78S2tWBTRpFn7nTUz7yWGopZvXx/cesOjbkLyzLRauTZNfNJ90Z2Mqqie82ZUom5y2R0eR0cnSPwLUv+m8qDtVPP5sBeGEAdqcnpPGBOie8piv+J4Dclse6AFP0FKdw8Zw6vTVsnVy9i+l6+SxEEHVpmEBqc/EHHdqXldHfZKu/m9t2/g9c4et0zWRo0YNAJjK/zmObG0PKZ8Q4trZjHeGoCrTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 11:31, Wei Yang wrote:
> Since commit e904bce2d9d4 ("mm/page_isolation: make page isolation a
> standalone bit"), it provides dedicated helper to handle isolation.
> 
> Change to use these helpers to be better reading.
> 
> No functional change intended.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


