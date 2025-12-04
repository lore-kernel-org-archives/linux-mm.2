Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4F4D2168B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D046B00BA; Thu,  4 Dec 2025 10:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D756B00C3; Thu,  4 Dec 2025 10:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FD4D6B00C4; Thu,  4 Dec 2025 10:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC986B00BA
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:13:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9F51139D66
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:13:31 +0000 (UTC)
X-FDA: 84182132622.22.293A97A
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF78E1C0010
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:13:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fansfN/K";
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764861209;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=984Ihpo1W0CqlWCA8Wm5WPWQwhBS6unw3a7F3fFjLYc=;
	b=rfob7eKTSaq64IwXWkTvjG3kbFEPUKhN3YLyCHCA2YazNr+ywMNbPRONsfipEwm4w/7Ois
	lbJF0qANASK0J2FzB1kei/Oih3POcs4KVyTBggAFQ5Y+GlPQF5lLN10k0XEok2OehtN0Fv
	t2CqAfB6A2uH+8YwgMt3QBs9EKYz0G4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764861209; a=rsa-sha256;
	cv=none;
	b=gagR2L8mZpa4zUtjD7NL9WKBZjsBUZyDqd0CzHG/EkF+iGIfnD16i54u253eLphn1hUVie
	sa2b/URWAxR2RqWNTXysu6BuLlAthrGAS0C4AM36qWfHAIA8SHf9mOYlMtB1ypVjtSk6ks
	6yKxA7LOstcMpVgoKFYryNnlILMB+Zo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fansfN/K";
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b735e278fa1so190432466b.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764861208; x=1765466008; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=984Ihpo1W0CqlWCA8Wm5WPWQwhBS6unw3a7F3fFjLYc=;
        b=fansfN/KQKfice/UPV/VnnSSS96tQJTV8sJ5FLuXwLZ++T8ALMXqT5ySpxzkYXPfp/
         fYJgF1MvUaahbViAWcQCBSEZP+lfDiy7vh14TBXHUbeuFguRiKUek6H+fnuB4SpnfdPm
         PzDW1AY1J/i9eCowhRkeMaI4lB3jvB/T8zVo+v2YwFnC0VM7bhJLBU/RGyNwjoOUTifq
         Pc15dkMLnf6qnef+JzvjVJhSZISPn1aUy1bHJlpZ3mFs0XiviYnBahsne2Dhrp4g7LF6
         wLPxskdeqzMzS8rVBW2G4+Jx43f5VoakyZkoEVWPrjAT/24axh+1Ydhfy7UrVCR8+MyZ
         o0oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861208; x=1765466008;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=984Ihpo1W0CqlWCA8Wm5WPWQwhBS6unw3a7F3fFjLYc=;
        b=ZczkgZNNpk4ip9TasUNEAqsW62oJzGxlgHfWYiUbDfvV079cPRDQuwGoiboJHE2g+h
         JKxX74dTBmjkeCeARguGcqTPcpMZ802DzMuKe7S6/xIF9LxrJufs5162iZzDiG+FnZso
         W3gpZdn8zBzWmGLzv8QZ1h9U5Cak/Pt1IxGXUeeZuLF6YVBH6b6a+Wb7f7fcU8PxnSDv
         sPWeJQNOS8Yjibq+F/wXZWROxX7lxus8h+n1QDwkL+4VqIfU3pfh0McQfaxKIkkn1IBD
         HgdzSI4uOqN0AVBJdbeR4f/04McK2eJ3NuQE50q+8xbqEsu5ojSmhnGNdK0AJ8Yc2W+2
         rhLg==
X-Forwarded-Encrypted: i=1; AJvYcCVdqm8uGGv6wNi9XUNJ3hkKxa6waLL1zvDdy3mtA849+CKeXzXMtCS3y0de3sS/WV++N+/VqNLkQQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7dQQj/+h3MRuJWV4gOv1V3KJli4OQVZfV0lKuf2Y5C7wPOsSB
	Ar4/SMBDltEzfvaZCfH8R5SsdXxW3VE15x09T2bnny7493YjlxAE0hOh
X-Gm-Gg: ASbGncslvrWQMjsF02VyGovEFltXQjrc9S55V4J1VI9pnK20KBoCRXwXDkvM9DlDth7
	ULPRayDitCp2aijFv4lhSZY+KPeRXJvj+7B4pR+Yg4qdS1OnbeIwO5LWCZccHnWozQFbyhOdjzB
	D4At+7PH1TCQuVhWgxUXib3IUO5Es5YrC+xJsRmkSDMhfGS+eZbXpscJ2VF0fcDTGudQC0zqhaa
	jI7iuSkNcmliY/Zd+IbY1IWbqiQKXcXGK828jgW8e6G5pVTiWarRDgh6HUlv2XbHGBoYlS8zBB9
	+MZN37SHOyCn/zLUQIFdq8SsGCZoD/Mti3qkASBU996YBdSjFnRZmYuXpXz+1us7D44j27S1NjN
	njHK7WTaEOFGxKTno2IAhBuK9wxe2eLNmprFsy9SWdxvVI5WsdOfs5q+me4rJdJhAcPcZfBGp/x
	czbbsiXSnzkQ==
X-Google-Smtp-Source: AGHT+IF4Ki2Iy7tePrIXhfaDw2LqZEVcYwE61ERa0Sy2WkINJH+QQ5f9M4Zh+9BccRgTWkgnfoannw==
X-Received: by 2002:a17:907:7b87:b0:b76:74b6:da78 with SMTP id a640c23a62f3a-b79ec6743f4mr347255466b.35.1764861207867;
        Thu, 04 Dec 2025 07:13:27 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f49a7951sm155535366b.49.2025.12.04.07.13.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Dec 2025 07:13:27 -0800 (PST)
Date: Thu, 4 Dec 2025 15:13:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, willy@infradead.org,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
Message-ID: <20251204151326.63twqgfwzxbco362@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
 <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
 <20251114150310.eua55tcgxl4mgdnp@master>
 <64b43302-e8cc-4259-9fa1-e27721c0d193@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64b43302-e8cc-4259-9fa1-e27721c0d193@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF78E1C0010
X-Stat-Signature: c65xmxb5di51sszxut1ysunm6ckxftuw
X-Rspam-User: 
X-HE-Tag: 1764861209-469157
X-HE-Meta: U2FsdGVkX1+SM6aTpJf8Npgb/bVrMWevvwDl6Bx0v+r8tR2A+4Xzh5BN7KokgYQ8vEL4wyq/Ziy2RBJvZuVJr5j1UVd1URS/tCz+kUapDIM5FSg1LVhf5Lse40CWDEnCMCvxiFL7MGPT/yr+TVdQpVO+pl2f719c1LBAvJYD7dxUnGdtjKPraG2ni/L/zXbbYo+xym55Asgs1Xgu9rRwRggcu6icmDHz4cB/0PL6Ur3LnX+g2KvYqqgvFbP5Bj9iMCl7zCxlmCQ8ckhM/AifwHb7h3UvjBJnSzOFnJ0Gszt4inVbogYlZvhXdqHpGCeSkKEffjyPgbl+KwZeA4yxIdTVzWEQPfqMNoLdei0pgGpaRSgZAAyNJI/pTLhUS4ITCfWtjVb14dAUM07BxUaX+/rwhPJNeJLsF5my5M8REhUuAw1A9uspMF0n+lzWqC3/SX4KVWvbjBVtnA+WESJ9NQkCOrzNUQd/rYe7mOC9K1hvqiM7aa/Xzb5ce/pxRmTJ15ZHPOKDkG3+5FkRRXuzrdeiOM2MPz3QxjowJcykKcvvZeDdSc68YEcBfBVOuzsvdED4vDU/U/OCAftHNJL+xgk5m5tZ+I7RD1ynLFWpV6Qn6uwtgoqUEYtS3N5qE1zunAr77A43bJmvvJb2rOcNwkGDzEDuL4q4OaGNyr7QLyKMEaZJeBPzmhB8Pfu5YGT9soKkOIegPo0Mixjr2YWsXd64xqtLqG/8swbPd8PFxqy+wo+NU55QSVSgZ8UpsrEpwY19NMS7PBuiKLsXN+sZ/bMXnPslmVJTlOnkuNGxbd6WVc+RVDBjdMn4QjkFnOY86gfASVeNy19JeW5nmq9+DLz4mvXb4Jmzk937ujdu44nlMNEi0UUkDW/Wxw5WKkSA1fcnPjpY1eJhSZsRXd/F6yR8SWhqPqY3jjThbOkXrHeM02ZotL3mbLEkDlpxQlG9NiPx0wEgvCb5pYF1raL
 qHcHqYHj
 OFcXdAJ87FZ26dra1KXJMCLlpBpMu0gPjg6Y7Nc89zkSorzht5KloC8dxdANbDg1IVCI0GF3HujVz5dfnbvIZAFr+ZDCJhFLhA6TnuMAAUkVJxKQcU676e4yZYc3Ag+531153uNRUu/eutbbgVZb61d+odkiK7JWeb5iPSInb3DAf8j2OGKFdzkVzJ4IXBKxYSewfWpCFb8immIfbDnNV+/exZkCYHDS/oRKn0KJYAmaWvj5rilQNrhQx9ondcKd/6ABDmRlFAQPrX1huLkaWhrMoglr9DS9UlRTDtdrFsZ2YqIsDJCrREB3Im7Vs+z/CjgxH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 08:36:20PM +0100, David Hildenbrand (Red Hat) wrote:
>On 14.11.25 16:03, Wei Yang wrote:
>> On Fri, Nov 14, 2025 at 09:49:34AM +0100, David Hildenbrand (Red Hat) wrote:
>> > On 14.11.25 08:57, Wei Yang wrote:
>> > > The primary goal of the folio_split_supported() function is to validate
>> > > whether a folio is suitable for splitting and to bail out early if it is
>> > > not.
>> > > 
>> > > Currently, some order-related checks are scattered throughout the
>> > > calling code rather than being centralized in folio_split_supported().
>> > > 
>> > > This commit moves all remaining order-related validation logic into
>> > > folio_split_supported(). This consolidation ensures that the function
>> > > serves its intended purpose as a single point of failure and improves
>> > > the clarity and maintainability of the surrounding code.
>> > 
>> > Combining the EINVAL handling sounds reasonable.
>> > 
>> 
>> You mean:
>> 
>> This commit combines the EINVAL handling logic into folio_split_supported().
>> This consolidation ... ?
>
>It was not a suggestion to change, it was rather only a comment from my side
>:)
>
>[...]
>
>> > 
>> > The mapping_max_folio_order() check is new now. What is the default value of that? Is it always initialized properly?
>> > 
>> 
>> Not sure "is new now" means what?
>> 
>> Original check use mapping_large_folio_support() which calls
>> mapping_max_folio_order(). It looks not new to me.
>
>Right, but we did not actually care about the exact value.
>
>IOW, we didn't check for order <= mapping_max_folio_order() before.
>
>SO I'm just curious if that is universally fine.
>

Hi, David

I just happened to come across some code that might address your question
here.

Take a look at the function __filemap_get_folio(). It uses
mapping_max_folio_order() and mapping_min_folio_order() to determine the
appropriate folio order for page cache allocation.

Just want to share what I found.

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

