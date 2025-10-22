Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB048CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 04:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108F18E000B; Wed, 22 Oct 2025 00:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E11F8E0002; Wed, 22 Oct 2025 00:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01DBE8E000B; Wed, 22 Oct 2025 00:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E62108E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:25:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94D841406F5
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:25:52 +0000 (UTC)
X-FDA: 84024462144.16.89E12F6
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 722DC4000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:25:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ZvGyQ18e;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761107150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfKYMPlRA7Hil19lucydJ3Oagf4wOyjxoqA3QWKCuV8=;
	b=lyEB7J03/2/5zji5PcAmLF4AiSR8PjsN558bkFYk8GANNHXXexigvZOzaRfNPOmaMalFPg
	BQhzbYESpM0q2cYf+w+1GEKsH17lbU3hM6rspLzsWnd/IdQnJklPZ1/X2UEbLuzJfFdSZJ
	71O28Vi4gwL3QJAwdSPaMtjdUhC3JG8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ZvGyQ18e;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761107150; a=rsa-sha256;
	cv=none;
	b=JITJyUcjBWpJzCl49lCYShYcx242QUy/zxUu5yF25o333FAB9kM3Ss8J4k6xfT+QN4vfcq
	5hZ+JkgbFXcEh5wZLP8/hbRWCwL7QpDN141XJce6Dck4xzsb2n9P05ekA+MfH2S+gCJS1A
	FQx3fHI9p89C/6AoLm339WEMhAMExXM=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c4c346bd9so7913764a12.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761107148; x=1761711948; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UfKYMPlRA7Hil19lucydJ3Oagf4wOyjxoqA3QWKCuV8=;
        b=ZvGyQ18e9L4f6FaWFdno4DLNYno5S7rNC0MGBVmHA9ctPSynoFXUc/TWI/C8CFxeRC
         z/SrpL5v+MNdJxYjXJABKYIKZL6v9kZQ5wBhvlEZ2Lq/9Vgxk+xeMgeYYcgT7lXKr8N1
         jkF3xril/ghXhCb3VuU96SDk2Y2LZpw1aB2BA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761107148; x=1761711948;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfKYMPlRA7Hil19lucydJ3Oagf4wOyjxoqA3QWKCuV8=;
        b=Yua5S1iNp7s0XStHuAd1l1lnlic73Z+EA6wP9DsVfChjNpSirrWlNgaouEjrTY+Y11
         Y+R5pMGi9mPSTcgXJJxq+iHMZzafwctEm/R7a4gygwvaamMG1UiRQKmcezibihNxQ/Ji
         PGYhMJtMW+740Wazsc7Jy4Nhlyhr+LNbQf26sOQwCbKROJW939iSpIPXb1CgKWu2nlYS
         o4RnVC2JQvUywwMhYM2kcPez1xGxrXbi3nV/A2JSZgIzpC+u5Pb0a5GArDOuwytDiwx3
         qb/WGQpbwzwhzb1OobirbL1W9+Od10Xr/K2nH/Y6/JdfJhvwwzcbikRewNYz5QXdhz4w
         SZFA==
X-Forwarded-Encrypted: i=1; AJvYcCXWicBYC3tt4tlbO8BZcQxdRAZ3J0PKnlW4vDqhZAxgVMerT3U5qq0Tjx69cNbh6mNbAYZlorQk4A==@kvack.org
X-Gm-Message-State: AOJu0YyhX4s9qafSE0aPHWwZkpfqM/nchIv8BWh0YxKQKOw/f9CXfvgU
	gGS6/BZzfCtnezZcGtpX8xb5mQ8vpYeHHJ1m5VNTZUv6f09MVCmw6WFSH89+/yHfT8DOEQoVgPr
	YjT0ldFtM5w==
X-Gm-Gg: ASbGncuyDXYhfjPkmcb+k2LjSHR6D5ewV9Jy4g5h4UYmKtTOfUPL+V8GwM4rt5ZGrQO
	OyD2mzbPtD+r86ZZTp4oQ4L3gIxOZLlcgTFoop5lOqn3PTsuWw64klLHSpxPSS+tPVpoofroD/c
	OilyiCT+iP23avgWHn3eNAtOlXBjJN8l1qhWoAWZfDIIa9Pd7oLY8sBSwvEI9oz097Z+CgDvWF/
	1oVRf3Ue7EgAqzZtZZNOuQ2xDtkKn5tjBvqOU0koqUkFP2H0sUEL3a2nOji1wxzLvF64nyA/lk8
	yAkvga6q1UjJvqyIGnh4Hp7Aekqo7hu4BzEPubX5xFtXclyMyJtK8UN0DdkiUWvjQJxhA9FG9Y+
	MGfjlX1EMA9Xv0sUV6h/YEGt1DIMc1R6daqUGbPCBDTHesB9zDCw2ltLOfOc/Dhl1YVGMDH7iq6
	9eCzw1/uGSwcQINKkN0kwbeeyShi8+pk/dOvRVDEKZ+Pzr8B5Go8FYju/tTXK5
X-Google-Smtp-Source: AGHT+IG4rJmfj3yDbpHS3Wj128X33Rm0Q4FpCOwXAuYCvc1uqLJGblDt7WAoVZX26WNZshWi3GXiEA==
X-Received: by 2002:a05:6402:35d1:b0:637:e361:f44b with SMTP id 4fb4d7f45d1cf-63c1f633edfmr18221045a12.12.1761107148457;
        Tue, 21 Oct 2025 21:25:48 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c48acf60dsm10835174a12.18.2025.10.21.21.25.46
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 21:25:46 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63d6ee383bdso3725378a12.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:25:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVrPH6tJKl3zj8TkmfqJ2csvTOBCUwCHpQxFt+qUq3GtoPSYCcetMF96fdo8JImQLs+Ag2Be9snJw==@kvack.org
X-Received: by 2002:a05:6402:2113:b0:63b:f91e:60a2 with SMTP id
 4fb4d7f45d1cf-63c1f6c1fc8mr18494752a12.25.1761107146449; Tue, 21 Oct 2025
 21:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20251017141536.577466-1-kirill@shutemov.name> <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
 <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa> <aPgZthYaP7Flda0z@dread.disaster.area>
In-Reply-To: <aPgZthYaP7Flda0z@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Oct 2025 18:25:30 -1000
X-Gmail-Original-Message-ID: <CAHk-=wjaR_v5Gc_SUGkiz39_hiRHb-AEChknoAu9BUrQRSznAw@mail.gmail.com>
X-Gm-Features: AS18NWB9CwG0IBKbkuN6M06jeHmD1GxcMpSycRZvl1CF5oywYvt7kYLWS-f-Gn8
Message-ID: <CAHk-=wjaR_v5Gc_SUGkiz39_hiRHb-AEChknoAu9BUrQRSznAw@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Dave Chinner <david@fromorbit.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 722DC4000F
X-Rspamd-Server: rspam03
X-Stat-Signature: zw67gbyscrjspdu1op4q4wskz99zp95u
X-HE-Tag: 1761107150-465745
X-HE-Meta: U2FsdGVkX18fC19mdHqnerGOK52aZ49aIrDXWx75o9FwKzH6tj6TtmXfxz566g733phQlxKFeO55UfU9zinXPPIDgXz0h422KnAd2BaTYEneCHvkXXd5dHRjd6oadW5wto8ldIcxjoT4zVdgvEztdvZwwkzlz25NDXnwEDJsgwgY8CmxJCmVYzBaDYcTI+eewSMCIEkBsnoqqVIZKnyI0YDTYh7o9fSFAArWOyboMbe15o2nRAEK/BtV69mMZ0XduY2O/WAvAD8AiNQTYOvxuejf6+VqHJlW3Uxr2QWvBFwX8DtA9SzDvBSPSd7iOtJYgwwnLay5mUpWFM+VoIF6c07ZlJKAmyjEhS8RvFea7IAbKq4F6BDUP8DgQfS9l2dlKMvKjAA8L1e5qP2mPPHKqazdIw0qqAl2Xp5pqYloTSOCHPY1UDhNQ6JsT/ofnNa6xRNHA5crlKMVnn8cGqvPk/cwfDq05Qa9Dj3IkTKSZvRR/WfjP0Up6YgTXw4pTPQUM6aRD9AEKPoCi6kzlooDmI9RGExJA9MEOBRqh5lG9XcPx9JRjBKGSTwvag8THjTBtnpuJz9dsLUUU543C22O8pvXbua5x5HjAIwGq12riTDwyUf8Sey6xNL2q3pmr9PGJr8BKyqOOExREgmp0H/sQMYxXobmh4WSDMI1Veoo4zWf6bXshIrCTdP87etkWi4wKo/uxpfnUZdqeowt6aRsxsbfMCLLsU1WB4sl5lnuvxKqbbzPIKtqdHhuVfDzOj0YNxT5ZcF7IZEsF5jRjcfXp5ziZES1GGbsTsJio1zHSrMeBEzt0gkFhcjU4rHb7OQqwZhtkRTFBN7xNAZkFrH7W/m6C3CYRB/pzxy5vNpnuYXikj88C+vBEhWAQDgG5PGMaUQ/KR3+ffrZa78puij5oS4OCoOHct6FNI3sJrbU9wcXNBS9j7Mks+hiiVnexnwQ3eV4H/rJ9Oa5xNCldFT
 vC52cxxe
 Grv/bd9I6aUIhsZDUD9LEX5LI98zTqZ6g1xWucAAqaYfvQ+wz04A+6IehbR0oVMeZbvuAGOvXhz1ffrRHnv8GKAW5M6d9iERA9yDkAycwEax1cVgC7D7NfD8n5yboz/ifTtfDTZLExFRHCAxBUlvqPLnxPMmJ+ICj4FPXNQnRikLJnWrPzFGVfryQagFdQDmlmIco7GZ/D8oW6izR+CCGacT7d8GnFY0D1GocfLB62LsTKRpNKzgDunkHmpkaK2O5HzH5UTxSDUbKiqL97oZSa3Tk9V7+i9Gzdy4JzO+mefWfBsqn27CzzHWrHq+TEsW1ScPmwBstbgdJ9D2Vsl04Ryzozbw5rnK1SZTcIP4i+i6uUJk9e2qVV/AQX8CC95RovXe3hcGIyTxr2tsWCQyKgcDKSyTRbpT5LRcvccYir9k3WnNSa1JI84hBXiOeIyxwPgmK4OOvQtlqF7UE87EJ6tAMU4xXeT3wpsCo4gp2xSGao2y35sLRJtua0HwqhVXxbxyfJTuvSD4ntdvs2l4sI+yei93bc9wXRefI1O7byTXCb4wGc2rU1wLQMvd5iMdSSMRVTUY8rhdRaGQR90Lxznvyig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 at 13:39, Dave Chinner <david@fromorbit.com> wrote:
>
> > > >   1. Locate a folio in XArray.
> > > >   2. Obtain a reference on the folio using folio_try_get().
> > > >   3. If successful, verify that the folio still belongs to
> > > >      the mapping and has not been truncated or reclaimed.
>
> What about if it has been hole-punched?

The sequence number check should take care of anything like that. Do
you have any reason to believe it doesn't?

Yes, you can get the "before or after or between" behavior, but you
can get that with perfectly regular reads that take the refcount on
the page.

Reads have never taken the page lock, and have never been serialized that way.

So the fast case changes absolutely nothing in this respect that I can see.

               Linus

