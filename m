Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344D9CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 10:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78FDA8E002E; Mon, 13 Oct 2025 06:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FEF8E0007; Mon, 13 Oct 2025 06:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1468E002E; Mon, 13 Oct 2025 06:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4045D8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:18:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB368C0353
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:18:52 +0000 (UTC)
X-FDA: 83992692504.14.84684FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6257B2000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:18:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O05EoaX5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760350730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zLr9HRWBU4vFy2Jm9nw9zsWcFfSLePV2+VE2LgCs2c=;
	b=B3Qf7kdQw20xo1r5f8RihinTKQ9vNesITHO8MgMzalE4LvD18Pnf79itGyzkBx9lo2GOEv
	g5yqzBlfBBGuJDEAAvDIeiQf9jBuRyHKBUf+1yWPNAVPu/IKIHy89xcLx4V5fCgHJvyx+2
	zouo85nWbIH4tQmOM5cfa48WVh25q1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760350730; a=rsa-sha256;
	cv=none;
	b=YKkaxkpj52K6ALhwfMqu45s/swoBuO4E1BIq3deCHniNL/tu3pq8pQclmUK7oc5rZsH6pH
	5tLnon8YQZn7l21ysL20mPScSpVMUcsl5H1w7E2woINmTlHp9Qgh0fg62z5ak8ByVXT7+7
	V2yMjFrbtJ5yW1Dhs7hlVR+fztNfHwo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O05EoaX5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760350729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8zLr9HRWBU4vFy2Jm9nw9zsWcFfSLePV2+VE2LgCs2c=;
	b=O05EoaX5IKInejqK+tIRbG6C3eIGXqowBmbd6/Qbp7M7eLSMVByJekLCt78W3q2dA27Weh
	KThnXujXlM2UUT/vLb0Untecf7LocKw6mhavkxy1kepMk/pAS/3lnpYDggWpDH0Uuvt+B1
	dE4lSHjIzQKcMzZu5KGSCTPpumXK4wI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-1BzA5KoqPgWe9DdadqP7tQ-1; Mon, 13 Oct 2025 06:18:48 -0400
X-MC-Unique: 1BzA5KoqPgWe9DdadqP7tQ-1
X-Mimecast-MFC-AGG-ID: 1BzA5KoqPgWe9DdadqP7tQ_1760350727
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3fba0d9eb87so2633885f8f.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760350727; x=1760955527;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8zLr9HRWBU4vFy2Jm9nw9zsWcFfSLePV2+VE2LgCs2c=;
        b=NkbV+4CKAw391toiNvwXe5fN9OSUQvlJuZFVv54Mx5lCcjlJtWlsiRDgIiBucncvnQ
         QDgKHA73jNMxXvVZyCGxSJICDlFWvbfjN2fk2RqgudZLpiUh8o9hYpWRUVgUlNi9L2pA
         0U246VhYbFRtOYrnykYrEU2BFMAPWNwLPyQHjvKBJttK+77SiDYMEDIg6d50Rk/SOzVU
         kl4WElrZbOApu9YpltQ1PVRIen5pVu4ZpkL+9ovjvFBtjB2+1u5UOqm963qFopRpCYFZ
         cZpEsFd0QYq+1k2hmwn0sJTOHBdsXGZ16Om+w2UzWRpm78Yr8lhKoxDYJRoweV4FRMnF
         u/lg==
X-Gm-Message-State: AOJu0YwCBjOQtXDyH0LQuiFCZXTUHvZJylrynp6r47x6lLrgMUCAa6/e
	dYjZe7XuZaCSZDUwelMXL2aL45XTvhzBE8Ady1I1j/7oNG7WYHx/RbBXjUVsxwW/a7jNyz8YJzZ
	1rOXf6oZio51udM2FLLrH1yV2Nu4YtSqBKpNka6zbl7tzB1kLrTa9
X-Gm-Gg: ASbGnctpGkB42HgPL1vbl4d7IQ6lVbfEtGYNVihu6jEk4j9P25aby/fsD4kRuTYogip
	s+piMraesaO5MFuSvoDvvHJ8I+xuXWEJV6UEefrpMCWkNvt6PP4bdjlqaIXEL2EnV81Fw17xJYe
	GwsDNnzkBb3Zp3iB3y+ZOC6iMds1cnqSCJc4AqQO+aMEcp0NNsI176U7WUdOum4rxHovyCxwkHb
	UpW53DXLuQCMu3NasYSMdag5YwNCxjFqhH5K9eCXcRu0oOblRt+bROhr4KqBW8TGNcC6B4NRzuH
	0CNaqSh/0a9CPGmdyZpX8GTJWndKnerGYuyFWsoJBFiELMsWVWF0lvpgMHemt3FZRa/a/l2Y3d+
	f3p8=
X-Received: by 2002:a05:6000:2485:b0:3ea:63d:44ca with SMTP id ffacd0b85a97d-4266e7d458bmr12984598f8f.32.1760350727198;
        Mon, 13 Oct 2025 03:18:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEM/T8CkEhXD5AffHwvYXnzkgYfTcIzt0LzKyvioPOCxT53MwhT1l9CdJPTaNnAknU5ZLI2Iw==
X-Received: by 2002:a05:6000:2485:b0:3ea:63d:44ca with SMTP id ffacd0b85a97d-4266e7d458bmr12984579f8f.32.1760350726810;
        Mon, 13 Oct 2025 03:18:46 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57d3b9sm17741952f8f.11.2025.10.13.03.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 03:18:46 -0700 (PDT)
Message-ID: <423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com>
Date: Mon, 13 Oct 2025 12:18:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regerssion] [KSM] KSM CPU overhead in 6.16+ kernel compared to
 <=6.15 versions ("folio_walk_start" kernel object overhead)
From: David Hildenbrand <david@redhat.com>
To: craftfever@murena.io, akpm@linux-foundation.org, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
References: <020cf8de6e773bb78ba7614ef250129f11a63781@murena.io>
 <8e458538-69dc-4c0f-a25b-0c85ce1e866e@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8e458538-69dc-4c0f-a25b-0c85ce1e866e@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VcyB5CTIy58Y23JcYekuf4yjMZdenGfex1OAZGGVk1Y_1760350727
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: bcirgrg637b7zbsn6ex5gqtp8rxzge7r
X-Rspam-User: 
X-Rspamd-Queue-Id: 6257B2000D
X-HE-Tag: 1760350730-344610
X-HE-Meta: U2FsdGVkX1/Kghk12aFyt42lF45m4sua0zKw9cWgabCpQclA5pQDmhDeSqBtJVVqBkqyRgUcIlpzLmP4oY0lzVdY7wMMj0oK0n0/4qltBq0ODNkH3Z9rOK9kZBK26Pn5F6MwhuaznocgpvYz5qgGva7wnubu1BJhKqcWptXuAt1hbyUgcy4YAs0BdzQUNZgSWq1yj9phyiwORPJn4fg8IQ+5eM05QZ3jBPPiRmfHPGaq1roC63dmvPM8JG2Jd+mwWxBNb7gN7w/v1xE7FGXCis6XLO8SiB27xPL6wt2q85PPP/UL/70OkUzLnhHJSYfpvTzaiCtV2Fd0TSwTmDf/RpGteR+s7KRiDRPgCjyqwvw2QS09QniK5BLh6Jd7TVHKEugPUdnPdatrec9ct9hfocgejFLT2FKJyHrKjj+FhAAA3V5xZxtzg41zecQrnSh/anD9bghIsLtrw2QyRQ1N2LK43E31evdk5mc18Vbdvtq8xPZ0qF9zTkgALkCMAi3552sd8fQscjbvpUo3/NhtlcXH7b3ItFj/KCR6JQSx13YkWxnEngmRTphnREyQ1b7PfePpvp4S1mFVXuFNKfUJui+NiBOWfGz0cGpV4APffVTlpndoP/IBLYCCRBWBDVe+2XT4t4wVQt48xuijE6tKUbiAxGMbKqVQ+Wfvbs7rpuBcSm5RL9hzrGog0tC8KkRS1Xp1WF+ItYQAbexYap3ykpdK1IMXle14vDlxwW6YI87KtP69MAXPhLOAVmNmaryOuWFrCYTVK8FvkywtXsoy14eASaNNS6LgGMMypygmy5AYwDbGoVjhhvmFhOfoUADfasiQ1xPCQc6jGJgT1/j+CloVO4ogc3eK0/VocQs0SkMpyijXScaW8eZ2tuT6FIzLx0twXZDEVzd4ocCUxe+mnVfHMl8x/kbjzbEs/c/YR5hqXQN1HJON2jVjg/KmWz0sSY1aSnLqZ4x4ArFVZDl
 vbz6x9GT
 NpT1hvWch/tDpZG8SCAcCRm/A1pHRwj2QXxfxdSmvmEMRsiT8jRwrD6rBSOUtifdW1vOgueS+gdG3K6sP5Bz1iv4qiy4nlXk91mQt1cCzoDbcNrY99Y5vLl1f6QRJqi5t6S0HaULqA+FU/gaUNyxyUNab06AQ/tKJqYhzDF12i2DIG10uzIpAWYEDiNqfwklVffvtPZTZtAsfkiSzVrfMiLK60jDy1Hx4MIyWfO5JJlBM+2F6BcV8hzGS27i5S5nsM+533qTl2kDR/xCIl1bpnI1PbjGWOdSvBhKWfeWQ7PCFx4KJeYx2kTkRJQEvXPUqQEdzlcFQ+KkZKO74XhNKz6tXgfcBZIYYo4qyH2L5gHL3y7PVYAX9xzSb/md3lnWDUlw1QvdTxga/G8uo/vQHTUmPVEXLqBGTWLzlhPN2EEh0mqEqv6YV1yEEGzAWiGGXlqhu6CPtqfNLDUUEwgtz+UpWJIATp+e4l8EF20VjlJxfivS7poK0CY2m6v4XGOXXs14EhfTtW72PbDFbkBnrEUJboQ3ub/nOkebKZ9kICVUHPsc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 11:52, David Hildenbrand wrote:
> On 13.10.25 11:22, craftfever@murena.io wrote:
> 
> Hi,
> 
>> I've posted about that problem already on bigzilla (#220599), but maintainers asked to post issues on maillist.
>> The problem with freezes during KSM page scanning with certain processes like Chromium with huge virtual memory size amount was fized in 6.17.1 compared to 6.16.x/6.17, but problem with huge CPU overhead is present there. Compared to Linux <=6.15, where the overhead is much lighter anad there no much CPU consuming during KSM scanning, there is "folio_walk_start" kernel object is present (which I reviewed with "perf top" command) that is not present in versions <=6.15 during KSM work and which is in work starting from Linux 6.16. This method very resource-consuming compared to algorithm used in <=6.15 versions. Is there a kernel parameter to disable it or it needs more optimization?
> 
> I doubt hat it has a lot to do with folio_walk_start(), that's just a
> simple page table walk replacing the previous walk based on follow_page().
> 
> So that's why you would suddenly spot it in perf top -- before commit
> b1d3e9bbccb4 ("mm/ksm: convert scan_get_next_rmap_item() from
> follow_page() to folio_walk") we would have used follow_page().
> 
> Do you see any kernel splats / soft-lockups?
> 
> I can see that in commit b1d3e9bbccb4 I removed a cond_resched(). maybe
> that's why it's a problem in you kernel config.

Looking again, no, that's not the case. We do a cond_resched() after 
every page we looked up.

Also, b1d3e9bbccb4 was introduced in v6.12 already. Regarding 
folio_walk_start(), also nothing major changed ever since v6.12.

Looking at scan_get_next_rmap_item(). I guess we might hold the mmap 
lock for quite a long time (if we're iterating large areas where there 
are no suitable pages mapped -- very large sparse areas).

That would explain why we end up calling folio_walk_start() that frequently.

But nothing really changed in that regard lately in KSM code.

What we probably should be doing, is give up the mmap lock after 
scanning a certain size. Or better, switch to per-VMA locks if possible.

Also, looking up each address is highly inefficient if we end up having
large empty areas. A range-walk function would be much better suited for 
that, so we can just jump over holes completely.

But anyhow, nothing seems to have changed ever since 6.15 AFAIKT, so I'm 
not really sure what's going on here. Likely it's unrelated to KSM changes.

-- 
Cheers

David / dhildenb


