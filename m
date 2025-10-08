Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C88CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E888E0018; Wed,  8 Oct 2025 05:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816428E0002; Wed,  8 Oct 2025 05:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C198E0018; Wed,  8 Oct 2025 05:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60AE38E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:13:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B6241A03DD
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:13:06 +0000 (UTC)
X-FDA: 83974382772.16.6F6E06A
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 191E31C0005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:13:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FI8obfom;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759914784; a=rsa-sha256;
	cv=none;
	b=0M++HMcvxGEMSKIqEJgYAFHLcFC8+e7bq51ovMCYf8UHj9KPbfRutgaaSHmAO3hBXSKJ1Z
	gdfVMZJvCFH7v4NxCK9nxnlQ4K+k3HCSBV2iOXcoCrZqa1hPe+pqEFOAx2rcGaBt6tql5Z
	lsniH1Cs1TczwP5oAYFX+Nw+ksNc7nk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FI8obfom;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759914784;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gVjaZkrAvpxyXMOw0boP7tFHEu7LFHSqmY811HF5eQ=;
	b=S1K2Gay33E8gzdwtcRaDfkXec+JdFoQj/Q5aLHjIncZo4xIBc9TfJ80Msh/tZz6IMc1u4m
	JhnTCxIqqZvPutTAVVIaxMQ+dl7q4MOLwu2tlQUqWDcCHSLXkpAWJrzi8BYpQgXi9zGsDE
	quX/PT/t0EEfRT1e6s4If6GXlhx1kRQ=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62fca01f0d9so1812523a12.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759914782; x=1760519582; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gVjaZkrAvpxyXMOw0boP7tFHEu7LFHSqmY811HF5eQ=;
        b=FI8obfomkzmBJqoWFrhlK8vpuyqwx1o1firfBOU5MNwr2H8oM0AG7TFGgapNUP2o8l
         NoOR4vGsf16KGRQxTUBrKgkaqSksDuc6GirodRy8r1A5tZsMNSQ5W6uovYBQlWgF2uBm
         Hy4ZaIlWgDadT1TheUl9z7pTWlivsqnvMgHshtzctmhGK7ZrMLYhzN+lbxO5Eq+HgNSn
         DoXJa7Xg7LpUjti706VS51qbRZ3bK5gfPLq5eWz/baWrxRUOxzH3iorh/xmdMWhZGwnZ
         LMCTn6khttzZ2wcwZyyyeYwT/+Yu3mrYpR+ibgi5svUtSPB5omrcPPinwYQ9Ybt8m491
         3sLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759914782; x=1760519582;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2gVjaZkrAvpxyXMOw0boP7tFHEu7LFHSqmY811HF5eQ=;
        b=DYTv8wCe8NoZSG73AgCaVYVFcN9nbF9zYuwwa52Mhb+BDrvaV0y5rePgJBduLAESqt
         mr/P3Q6IU1mHVX3pqbG/vm75SFzGqkro6LOobM/IsViDlqVbqKA3hgazPr/ScdWfqMyI
         QgT3nbTdvSJ4tLdRjSf5pg6mccVaSk10p70lfCzmCVaLO/P42XObWwgyhs9U91D3Sw/W
         o4GwkO01oIe8yuewUyv+oMjVRqjxFaqA3m2+ef3eOnqo59zkSOCiBoFo3NYu7MYDbUqq
         uJMPFJ1NzLkzZc7l4nHXouqlqDiVDGbeQdEKrG1MuPi9AU3lW49WiQkKySNMiopYu3QK
         95LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtDPlItiaIt6PjsSFyBbPSxMmZVqfT3U8XTI1HPZYJpZ59ypxIYWgDNvPaaeSGfrTQxHH87BVqHw==@kvack.org
X-Gm-Message-State: AOJu0Yyf7mhFDHz6XKqFx6xQ/WYLvVebgqD69jpT+quDqa1Hr/T+HTGr
	q1DnGvmf1YLjPSp+ywP7gicbVfDzPGTkFZdSFUHxbC4/kAiK18oRGPkz
X-Gm-Gg: ASbGncvJgpKFDG2B20nvJKBwKFob5tZHBazS8wmGHqqDsBZSA1PfkclExCpbkLkBaJE
	0xXNecdTNIX1Ccs8wksIEEbJbgb1EMRHayPJ5DP5ZiddFNRnIwHWXe4AeA7TghulaRkUHGCrby/
	v9aB5BofyqjK0nrauaWsrjG5MsCFRTUZDTwq1rb7DddzMhgPNVADTuB4/VXwFD4AR6B3Uq3UIhb
	vCpGT5s7rQv7YNyZiqifAnBbgR63ivTvLWU6NLnf3yPtppbaWRUxySQGniOcWC+92WIaF6zTTkX
	jWbJNxD8/Elas1xUPIXaqBtsuAAS9ow/HDJo4OzwmzGfhlbRzbjWzZgb309PclelAn34sGWIkOv
	zXr3MDK37vkYHX/Kyxu+MAZwnUIdQDvNJFsUZsjDh7MYuSgvm8A==
X-Google-Smtp-Source: AGHT+IEiM/vXXLfhm7jrTfhRJnsDCv+r3kicHORWIKz/feH1b5vMdfnVat3nsY9fXfq0gnhJg01KOg==
X-Received: by 2002:a05:6402:26c9:b0:639:dab5:d5e8 with SMTP id 4fb4d7f45d1cf-639dab5da69mr1799025a12.12.1759914782279;
        Wed, 08 Oct 2025 02:13:02 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-639773d4d8esm8523084a12.30.2025.10.08.02.13.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Oct 2025 02:13:01 -0700 (PDT)
Date: Wed, 8 Oct 2025 09:13:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, iamjoonsoo.kim@lge.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/2] mm/compaction: some fix for the range passed to
 pageblock_pfn_to_page()
Message-ID: <20251008091301.44xerz33fmrgnjyt@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251007182922.4a254daff78633b1452bdcc3@linux-foundation.org>
 <20251008023218.g53gm33vmrdt5nw7@master>
 <aOYYUwyt-v9ivU1g@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOYYUwyt-v9ivU1g@tiehlicka>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Stat-Signature: ft5n3abm138izfpcmgrykr3p8wcz39mi
X-Rspamd-Queue-Id: 191E31C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1759914783-754457
X-HE-Meta: U2FsdGVkX1+Ye1jiBAcBK0kCr6z/kG4VniDPDT/AN/KJtRZzhszx1z6ej8NdML6vyzchcPL40OHf/7yRsi5QjrE3Z03JBdNo6Br0f0jfiC9A5DzHNXrP2G/TNEfpfiOmGxA/UoUKpb5NJSyszGNL1cD8cFb2gOiaVPQbpSQTH3ReyXZ7r7y/QK3bzIo1lUoEAbmb9I908bD32dnpInvxf7jH2518VRV4DuHLkteiley+ImIFTBNbEdpuUDCvKG2lQeX6KKLF5R6tNQ0Lsdzb6Euk+T0fEolgvvgohg3Ua+AL3WXnr4undippA5qyTETnHlPEW960FJxJFOg2+XztFAMBeImNPif2cm1WshfmPrJShRmbbzTjdvASZZI7GyNRjBvoC+bqN1iDV0ZjAPKaDx12E9RGbpAB37GfZ188DgcR1ELA3wxLiqDYBL6jvGZh2IABe4YUgMC0J7MySHM9ZhPQZnqVUtOXmxyURkevzAAr5/VLsnB6sKY3EGCPk/Pb5/ZCo9zXWFWN90AM3EZYxlfY/h57Pvgr9fJpt7MpWkqV7jO3BNkcSdw19Uu/2wSFqQmL7/Wr22ZEiNHx/+oi/R2ykKrn7/YxoTdHrom05y9rAbSz/TFemMKSW3Ekw76fCjHw+XxF82grKm9F3xuybuVGsSZ3/EUddhu8z63Y41lwLGK1OtrVzjlRsTT+z6e6+4C6HHRqRAgjVUl4Ndmht18OazoLT3nSjME3u6vJAHnVc8MJSdr3LwOSOKM2Tsak7TVDS/o3nFgWqrXiaI4ouJXKr2WJ/EhRqwOtU3egrvi4JwkiKtoXuk3ImxdbZ1yfw8JAz7o9gx3DS07RCyH0tGDQbYRgiKfnfx66y1XhgZGtonF5rlChOzqqa0WImKfhZ8GkLGV74ysBpcvB5/PlTyxOlmOshuWklrgAoLcZtKvm3oK20BYjXqJQ061A7myH6X99B0r8yHFIHCB0oqM
 BXKP/J4E
 GluAgboO6j8npNT7451SW7NM8oIwW7tBcfH8l1td9uNsfnQqSV2YLrMff7kFUTGz2M8owAA5CkWoGU+Cm4uxJvf25iJfvk6LGQ2gOHtwlY1+l6JPpWFYjaSu0RlrGip/d8C8uOrWf89nHoLfklYerIAE+GYMnV415wFxvMeawo1ol5kj7gHowjJIL4/uZZw6ad0YsyM6xzvYjNVBndRkwRB8XdGtxadj5hw4XdoEzDd1617tKqvf4X9yjU1iBNudkNbEOHkNq9vj0APNYWm0tYD33towHof2M5Evtt8K1PeWGRkmeYIkMmdSTVhZUqKEG1Ffs1Cnq2jVAdCElQmUC9BlzDHiZq1C9v7KI6VJ16ccZEf+G+BBzcr0+G2HJ9qZZqGLEHVkYbQkPZAUkpqLjnpbhKWCl115FtCgvrAimBTUlBHd1H+0B3MHGni59TMTo/05iBIptHlPFV7sU5kcx5lrwB8L/kuosLCTDuuZ3iU9yK5DM61oPVUol5NaSvN8Cqif+XeuaN3ve7QyRnqdEZ4eu97wmsvJbGZG/VFH9C1h1BNaxxKHu/B4XA68FsJjLxhCDuo4isNrdWl6l6+lNb6YrYszo4DVhKbQae7xpI7OQpJfWlK8crvkJnPpZPuljQHTC3EHiqpnRqINi5VCjr0kiEVKqAYm4SVk6UhxLN6VyqwdSFMeWFZyi+txnBvUu1qVtbzRg5GXMEuZQNDc3YII4jnF6MXXo2xDCv8djGyoRWWCfH1ETRkhHB78qeUTeK/uaGtBVKerrd7vv8bvchnMBk6KXaAMXCMB0zHyDLTAMpnylAnpE+IJaWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 09:52:51AM +0200, Michal Hocko wrote:
>On Wed 08-10-25 02:32:18, Wei Yang wrote:
>> On Tue, Oct 07, 2025 at 06:29:22PM -0700, Andrew Morton wrote:
>> >On Thu,  2 Oct 2025 03:31:38 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>> >
>> >> During the code reading of isolate_migratepages_range(), first spot the range
>> >> passed to pageblock_pfn_to_page() is different from that to
>> >> isolate_migratepages_block().
>> >> 
>> >> This implies there is a chance that pageblock_pfn_to_page() thinks the range
>> >> is in the same zone, but isolate_migratepages_block() will isolate range in
>> >> two different zones. This is not what we expect.
>> >> 
>> >> Then I found pageblock_pfn_to_page() has an optimization if zone->contiguous,
>> >> this means even the range is across two different zones, it will think the
>> >> range is within the same zone.
>> >> 
>> >> So introduce two patches to fix it:
>> >
>> >What do you think might be the worst-case userspace-visible effects
>> >of the bug?
>> 
>> I don't see userspace-visible effect yet.
>> 
>> Since I lack the knowledge of the consequence of isolating cross zone range,
>> currently I can't tell the effect accurately.
>> 
>> The worst case in my mind is we put some page on a different zone's freelist.
>> But I don't totally understand the behavior now.
>
>Is there any actual problem to fix here then?

I don't see an actual problem in practice yet.

>-- 
>Michal Hocko
>SUSE Labs

-- 
Wei Yang
Help you, Help me

