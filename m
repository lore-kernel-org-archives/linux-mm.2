Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F86CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937068E000E; Wed,  8 Oct 2025 10:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE4E8E0002; Wed,  8 Oct 2025 10:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CDEE8E000E; Wed,  8 Oct 2025 10:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64A318E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:44:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EFD959716
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:44:31 +0000 (UTC)
X-FDA: 83975217942.03.3E28E59
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id BC73512000E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:44:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AQl07CPX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759934668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5D2ZBCJD8c3xdACE6ypAt6xt/+t9lS2ExG+K8u97CUY=;
	b=TeLtrIkjOjL3F1y81bXVYBMhd0HHPvWgyjjuz9Wz2y5PFBALqQgD41n7vgClTC+NB2uSx/
	Y9AsaMllclFFoxSOfO45xe1L55w5U/OPzV2X3SVibc00Px93T/JBsk9qTTpf7fLZ7sivPq
	o9OpFw8COVSKtA3mEo0N6TV7MkJlaQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759934668; a=rsa-sha256;
	cv=none;
	b=IzHG+mSHajuCW5tDJJFpzcLUXJXhV9BIf8u7/dmvvPnu+zMbArdehy5VeZik9RAmLKxMWO
	Zj5JhfeoWSpiyeimTecP4lTzZ7Wse52h9eR3lJSBvFFOfUaBqfF9yY0fHlfSi8lTZI2v4/
	x70utXDyLbRjP8uTpcQpRiwqEj7U7f0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AQl07CPX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759934668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5D2ZBCJD8c3xdACE6ypAt6xt/+t9lS2ExG+K8u97CUY=;
	b=AQl07CPXXSLAE+ex3QQEffkerjMHd1pxtmLD9niw3Y8Hyfc1gfuv4YReldeTVzYghXhmJA
	H6N5QoBCjQWTH8G1Ca5l/jCaryogb7WNu6icq9csx/cyVcDOV3I5H4Bp/zGxGA0N7M/j6T
	KM8Z+x/szwUsOffLcwbnhp0RkgBVDkg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-yRcHkIRJNxuPXgGqLGLTWg-1; Wed, 08 Oct 2025 10:44:27 -0400
X-MC-Unique: yRcHkIRJNxuPXgGqLGLTWg-1
X-Mimecast-MFC-AGG-ID: yRcHkIRJNxuPXgGqLGLTWg_1759934666
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f030846a41so4640599f8f.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 07:44:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759934665; x=1760539465;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5D2ZBCJD8c3xdACE6ypAt6xt/+t9lS2ExG+K8u97CUY=;
        b=KWpz9Iw1PyuXEaeBYKQ3oYIomj+w7u4cE9DfdQ1bmndh/NbmXlIkloaZxgYxl0m1IX
         od6Um8cBcE3mJ7gcwCGSddoQbgFS3woOZOTw2DuCJxs9eHHwv5/Bj5Mbxh1YCoEPrBi5
         qLbOHbWUtdfCHdANJC8ogEE+vuvVG8TukQ/Sz5I+9Ahzpn9e4N8IhmwJEU6it986BNCQ
         +ih4VO3maa/ZY/NG3OK+PtCCjQnDwYWjhvZLvwtGc6zHmaz7D44Zulpm6eylnDrZcafI
         3Aj2nXJOImBmoCv3TOHh0SBx+5XmL/J8QubzDxy2asP22L8w3O8ktJtdpZUXY53ayCvZ
         zZKA==
X-Gm-Message-State: AOJu0YxQx9HCLtLD0dDrS2LbBH8INLa3eExpQsSI8J+o1gF2HrkOh+pc
	IQB6VVwDuqFvGDqTGI/sAfotOUGBSfPF7pGGkfh5pySf1bXDIy5kB5HRQBUDLw+W0l27hqHJEb4
	84S5WuZyurnbJLBOfVb7on2hsEIreHfmDe45Paa1t9TSoWm3uWz29
X-Gm-Gg: ASbGnct3vfdo2EsNXheEW8SqGGRwGiI6Yn+o0d7eH+NTlFsw5X0mYP0Y3PAtOGnOfzK
	wqnG3JSEZsH07IZ+uR5PkSSwR1PqHe3H3AVvnysG8SJkh64QdPLygP1ao7tEwXIUT/Z+XxZWMvC
	kaq6Vyi6xsRveeKe0Y2gIVsfL9GG+CrpgVet+opafHzVjUCLWGGv2mwlSBPO68rx+1fn14WK9HH
	WnDIJcSeDkkPwGsN+3/tgJwVXz6o32X6xrbk4GOTfW7sfBJv2gwjLq/AKVO0jhmIZ8R6o+Z89qn
	VNYBFr6uWxVvY/I4jMxdQ/dRFMuVXhLH5TVBquE1Qzkj7PMomNiEpimjq41xRVgbE2h1iDMNUN/
	3HM2JNZ/P
X-Received: by 2002:a05:6000:230e:b0:3ee:1294:4780 with SMTP id ffacd0b85a97d-4266e7e00ccmr2235082f8f.30.1759934665546;
        Wed, 08 Oct 2025 07:44:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDdqP+nWR/r0XOQYHaQ5RL5v2xthoAhXKsv0Fsa8RBq0AE9+JjgtYjdggoihs5m7bBq+ToxA==
X-Received: by 2002:a05:6000:230e:b0:3ee:1294:4780 with SMTP id ffacd0b85a97d-4266e7e00ccmr2235064f8f.30.1759934665153;
        Wed, 08 Oct 2025 07:44:25 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8ab909sm29664745f8f.19.2025.10.08.07.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 07:44:24 -0700 (PDT)
Message-ID: <f4d0e176-b1d4-47f0-be76-4bff3dd7339a@redhat.com>
Date: Wed, 8 Oct 2025 16:44:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
 laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
 joel.granados@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
 Michal Hocko <mhocko@suse.com>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 David Rientjes <rientjes@google.com>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZyt-7sf5PFCdpb@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOZyt-7sf5PFCdpb@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q-l-dYNZ5O1wKJ4CeaweetdqTJi_nfQhs2PHiJWn9NE_1759934666
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BC73512000E
X-Rspamd-Server: rspam02
X-Stat-Signature: 5kqbtmkmu7kf7p7og5b589z7gp97h5fp
X-HE-Tag: 1759934668-804263
X-HE-Meta: U2FsdGVkX18QE4NRdx/F5S+JctmCxaJQamrocgAxUBjz5ZK1m1nt0dq8XFdORN4jdhQlbCtryVWVgChEUAc6VBgs54UiqE1udv5we+7MV0UKpWypeT1Zkw0k7t9N8CEn2N717a9a+UPVBCe8aUlQna/38HwzoiWEfRCLiGgCuykkG257mJE+seJ3ZY7rVliLfJC7VNQF5vAlE+j2MlVKVWsqPbw4sd4LE9MC8Eb3LA1isVTwJWX5txAG5vysKDuyxPYO4FSMApvnVLt/BqYgF4RcPd95uNfnJG1ciXtwwBUt9kSLc42l7x1n6PGf2jQ/sZHWzDjW0KkCczB6gJfZ9RHpKRLfxh+w7ieLKy/3SWLpIGsUwJr079VsJJrGcUs94xVu/5sJccSiqOxhKjiMPY1OsDu8D5AyIjii0O6V4A75hB68yk3KpS+ae6vNlNRgiNJjDxnnIMC9Ep1Co2Ks6Fybotg1Sq7981VM/1uJGR4lvjcKn0i+f+DjDzkjL73aIEIRIcEsyZ10zqzApSwScklHNv4N/TQ97pZqFyQEAzyao5dmfZ3cFYihjn9eE67tjQDvee1BRSQ5rt5bBszgeMRLrTuD33jYcarbJhU2Bpp+Pn6fnWCBH2dEGoOpx514X7imK9pIOgyzv81JLFyDhatd+mbK/UbFAPEDW4/v92kGYWRmfubadpLOi+Rl5wLrP1gP8Vu960zCuQ9mZW2MT35KsSCgs5QGXxEo6KoQpy4vJHN9TARZ67u5KXrjVArIh65iFIW2YX02AB32TqMobFqjYFC0CjIJ1bxRyEJE1QNxjm6Z3F+vCOcpctzh0aCKQUYo07/aYYJQcYsrdqbKb3Pv9YuLVraQgPhJT80AKL6ODl3dLYsayZUUzYr+yFZMdDwWy1d0ETezMODuHclWqFWcWpqKtHipvmyv1vQ74XQ7u76WL8yBA/VSbg8prspJH5mHsOlY9pQZap+Vtky
 XYNcvJHU
 M+w+a//16mwxeA5OBAxrQVP3oa+lMSexsZe9TRIFqYYD3roq1gVCfxeGV45LSkouriYeyY6C2J4MI7BV2x+WqOXGt+7hm1wpN9/IO8Bg50UX6qe9f85OV26ZpO2bKwspWkQjYgfG0p6mVuetfynlrX+2i0CO9Qd4ATaiUFdPagriqQuCDyLvjpRy44u4j0DpBZK74jC26v1XAm0dVEbS8qf4gXZQYPt9iRrUxOKdAWuCytiL5Ey0dTeXwK8T2tpztaSOmMaLOOY3h7THeg9U8GA7B+kAzwjzl9HHDhjPmogtCmJVZyH1zfGHnNQUpYNwpGq4s8qOj4tE39unKwKW5mCl6f+SdUTJdVE1kViEbCE5h61MqyXbOxPJwQE0+sjGK/Tp1cY6YVuxjKeq9EGJE+BsRj3I34iI0CS0JH5lt4qVp8MpIFjAYhdhYteAJXYfguWY8CEbU2DMsCkZ1+0wpwld1aY39B+dWoKDeUrm9aC4vsZ9keUrZibwlse1fsxWOwt0nZYFWsjzVB5jfp2k5XggFm/F3D4sVtzB5yqTjdio9qTpOD1drTA6utADWBGgZO2pyj+TjlTByZkz6YgiOl7JCPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 16:18, Gregory Price wrote:
> On Wed, Oct 08, 2025 at 10:58:23AM +0200, David Hildenbrand wrote:
>> On 07.10.25 23:44, Gregory Price wrote:
>> I mean, this is as ugly as it gets.
>>
>> Can't we just let that old approach RIP where it belongs? :)
>>
> 
> Definitely - just found this previously existed and wanted to probe for
> how offensive reintroducing it would be. Seems the answer is essentially
> "lets do it a little differently".
> 
>> Something I could sympathize is is treaing gigantic pages that are actually
>> migratable as movable.
>>
> ...
>> -       gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
>> +       gfp |= hugepage_migration_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
>>
>> Assume you want to offline part of the ZONE_MOVABLE there might still be sufficient
>> space to possibly allocate a 1 GiB area elsewhere and actually move the gigantic page.
>>
>> IIRC, we do the same for memory offlining already.
>>
> 
> This is generally true of other page sizes as well, though, isn't it?
> If the system is truly so pressured that it can't successfully move a
> 2MB page - offline may still fail.  So allowing 1GB pages is only a risk
> in the sense that they're harder to allocate new targets.

Right, but memory defragmentation works on pageblock level, so 2 MiB is 
much MUCH more reliable :)

> 
> It matters more if your system has 64GB than it does if it has 4TB.
> 
>> Now, maybe we want to make the configurable. But then, I would much rather tweak the
>> hstate_is_gigantic() check in hugepage_movable_supported(). And the parameter
>> would need a much better name than some "treat as movable".
>>
> 
> Makes sense - I think the change is logically equivalent.
> 
> So it would look like...
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 42f374e828a2..36b1eec58e6f 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -924,7 +924,7 @@ static inline bool hugepage_movable_supported(struct hstate *h)
>          if (!hugepage_migration_supported(h))
>                  return false;
> 
> -       if (hstate_is_gigantic(h))
> +       if (hstate_is_gigantic(h) && !movable_gigantic_pages)
>                  return false;
>          return true;
>   }
> 
> And adjust documentation accordingly.
> 
> I'm running some tests in QEMU atm, but it's taking a bit.  Will report
> back if I see issues with migration when this is turned on.
> 
> If that's acceptable, I'll hack this up.

That looks better to me indeed.

Maybe we can export this toggle only if the arch supports migration? 
Then there is also nothing odd to document.

-- 
Cheers

David / dhildenb


