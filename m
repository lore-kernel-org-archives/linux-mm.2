Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6F97CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 18:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A0F8E001E; Thu, 21 Aug 2025 14:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351D48E0001; Thu, 21 Aug 2025 14:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267FE8E001E; Thu, 21 Aug 2025 14:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 10B1B8E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:13:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA615B9B1F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:13:17 +0000 (UTC)
X-FDA: 83801561634.05.DC137FF
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8910F40005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:13:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cfBQG014;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755799995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGw2gz83VnqWh3iPZPi/VoJGrAOor0mQelqsKrCx7Fw=;
	b=oBdblTrwDGB2bAI8dumoxPkbmISdKtp/kntSxHHESsf0GWME4JHrMBKNLD6o+Fjrr36hV/
	opf5RS8nSOSUU9ER7OcAEXSN+RO3jlczt4ihyQaOTOG2kMqy7nMYta5u8xR1rGbdINCbeG
	rBlAGH9emvuO6PzDMGON6clRbXVFUGc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cfBQG014;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755799995; a=rsa-sha256;
	cv=none;
	b=oxxcQXL+DcAHMWdyT5hF5AXsVJeEpbDXTnM9xq6bpx6LjPvI2LNB6VadRRpjNL5erzQyt5
	qQfOZP0Eha3JESpNNmRlLxuzuW8b5Xw75npqwFMqGcsKul9nrW09qtBcRKY6Kuxk7G9wGP
	Cm2ImOmKR06qQPSFuCFgu0imMWdipds=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a1b05a59fso9850875e9.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755799994; x=1756404794; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BGw2gz83VnqWh3iPZPi/VoJGrAOor0mQelqsKrCx7Fw=;
        b=cfBQG014gO4q8zjL+lGzflGLkXRP255tlsAVh3De0DoEDz0MqPtSRXn+Oes6iV4q6V
         ZRHBOWrQodcUijikO/z0NNui45mounOu812gN7hwWirvSSIZIwr0BIGy4ZG7y9oAnCqL
         j1uSIIzxn8in/XuRlwJn75PkzZr4PkEW7hDuySsmOXXSKHeRZrDVkT5xVEOTuNy5XqKB
         oqbsD1N/E4zVaM6WCtN7gRNnwu908Q74oDUWR/BvYMvocFp/r9OMcw9FRcSw84gVtkSE
         MAFxrMgz5V3TwdzZKzuLaeUwJMcAHoCo5J3MLTFBnGfoQ2e6yxSQArzzEpLanJ+64e2i
         TSjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755799994; x=1756404794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGw2gz83VnqWh3iPZPi/VoJGrAOor0mQelqsKrCx7Fw=;
        b=TMGDEXRWO6kLfkI1kXHPkiM14zZXrZwQocjW4rjAj+IK1us0vTK/1zeCje4pmlRm55
         y/bEH4NDfqhh3SF5RCza0nsDwO+VtkemB48/6opZYq0urKGQ92Y1p6MfVMmLEfzOv/RI
         e3xHkLO3CfrojSugCoHnlBe2pMT8MjNG4hB48MNuA4oDZsD741m6bUeHJ8yJ4QBeh1AU
         TH6+YDVI/I+6r+gOt8XWmfu3/WvgVCB9eSKFPU6/APjcJ5Y/A7lTOZXZb+UrOzmZ7h+1
         VbYuYAY+QzVn0Ny4FYVSSqNnxvygyiysbu9y1kSJv144sASS3mhHu3HBArhxXL1tx+NG
         ggBw==
X-Forwarded-Encrypted: i=1; AJvYcCXK2xFnGHAww5HtCmnnnKR66Mm47ZwAh25AX53fwJh4NkLfOM0/pPN2NXOqppF/HNmkI+azAUqBhg==@kvack.org
X-Gm-Message-State: AOJu0Yw3nrTc7APOGlZ7ox8WruY4Taum2WpASM2JWUT6PRABB/3WzmF7
	xLhc+bGpkSfmOhJoZEDvQJ2y1DktobDOTxsndmQvQ6brfPROhv0OLaybqKX+c0S1OEg=
X-Gm-Gg: ASbGncuNvdqY9PyrAFBTCYWCmV00P02gpRC420lK2IuS7vBFtxDXaMiT34bXhnLXQQu
	L2/hNr+dvj3hXEixPLZyYR87DBILxQWOuMyO/vKJXaYecNqwBb5lZErijvf7VBlpn7SxC9wOgtl
	bH9S0ml9adH/4inTiCWfqPPL/lDD19CkI172AOu0wu5/FIW3jX+K+lONJUuo2fsZyzxCKqC3jg8
	gjg5l/9MLyhqTvLLYrKOkTOEpqvL7c7wdMAA4AiQD8MF0SuZyAnL/iy+djHsUcm7AzxlVxCggXR
	WYZRpuX8yoANnrQV5cON5dtEPl+XcJqS7QruoscXuOtbiTUPnw9XaZf/c3BoS/z9YM4AdlVkNo5
	BV9Qmc98y7ATTWe2T9lOTpH5KA7riEaK/SGw=
X-Google-Smtp-Source: AGHT+IHW94p0zXqbNrntrEKvEvPhwFJb/hMTXSneXVk+pvqJenqm2aWB58Y+dKNDOltzNdcF32bTxg==
X-Received: by 2002:a05:600c:3589:b0:458:a992:6f1e with SMTP id 5b1f17b1804b1-45b51799443mr734265e9.5.1755799993903;
        Thu, 21 Aug 2025 11:13:13 -0700 (PDT)
Received: from localhost (109-81-21-139.rct.o2.cz. [109.81.21.139])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a587sm6865795e9.18.2025.08.21.11.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 11:13:13 -0700 (PDT)
Date: Thu, 21 Aug 2025 20:13:12 +0200
From: Michal Hocko <mhocko@suse.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org,
	andrealmeid@igalia.com, dvhart@infradead.org, feng.han@honor.com,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liulu.liu@honor.com, mingo@redhat.com,
	npache@redhat.com, peterz@infradead.org, rientjes@google.com,
	shakeel.butt@linux.dev, tglx@linutronix.de
Subject: Re: [PATCH v4 2/3] mm/oom_kill: Only delay OOM reaper for processes
 using robust futexes
Message-ID: <aKdhuOMrwgdxE9It@tiehlicka>
References: <aKIvd4ZCdWUEpBT_@tiehlicka>
 <20250818120819.26709-1-zhongjinji@honor.com>
 <aKRWtjRhE_HgFlp2@tiehlicka>
 <20250820025308.rkqlvauh4dz42oic@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820025308.rkqlvauh4dz42oic@offworld>
X-Stat-Signature: 5yy5faeozpodax3ak3h897jetwa3fykb
X-Rspam-User: 
X-Rspamd-Queue-Id: 8910F40005
X-Rspamd-Server: rspam01
X-HE-Tag: 1755799995-554417
X-HE-Meta: U2FsdGVkX18ohjSaiSQF3pbgRRm1GGdo/N1dVFC3jstFrlH+x+4ZJTd2eDtWaD6kuT5Q8kQYV97wf/GVXpnW78wCkYhf5G3JUDtViCzQmcTCutACjZ46bfZk24VvzUEhY7OUlvaD5Uckny7++2Ez/xFyeLPW1gkevWre+iEuoOBBNAYtwXyHNDDtoN1YHI28CF+CxtTP0tbsT9T5Vpx06qulKXHSzdNEvXFHCASMWoKekoMkaRrCidi8P9S8JeFApqKkc8ZF62As2Q4Hcz472YO7G9v7XX4VOTqJ37Ojl07bzIH1uhNJVTAmwqTSlPSCo/hCi/JPNt2Xh1fyM0ICD3rskvkiM6F7w/RSTHc57qHWDRMo7OTy8tqtm/8c+fdkT0RBAkPYzhhEQEQPFGsb70tSV9apc7IkYg6AaabzUF0vMz659TiEHjGzI45gngSTC+HFSG7IyDDj9h8/ilsaeIePp1Q1bsl92nUKACkwP0xasD6QB76WN08Dl0OP9nGByUfZx4/7dBQ8z+CLCMGdTSezywPFV6JOIXvfdDDMg3H+MXFskBCSQqsTc05Vio9FYzMPdipPyRFn0TDQ9RH8EDt2E1ZwmA3K0C83sVEsd1z5DxtE3k87lj8xSebIKKvtDtreUTimUf62tiZTpm1A/v8X9Ok93rOPfXbXBfgsIlFE1Yozxo/S+UIWIikv8P5yhH4VNGPF9u/x6GoU4jUEXPdKfJx501qw9p1BaWVoYxxmIM7i8nfMnf0gK3wHYmww3Bbc+sSNxyX8ZQM56ZlTx1o11DjSPixxhUzwZOvhempl31aMD9yQPdTE1EaD1inIyGjLKnQmMUxxVp4UD7QH9oynogG9DWdSYC/W4+OcQBzHfxQTEIw8+g5lcZISdtMxqivcL/Zp2fmNMOrC617C1U9WSXSsc72MTYw1LTRYzEMCCmXJlsno+zOz68O7EjSKkQ+NdA6AbvzjKzl2NvT
 xVqBXELd
 BFIGjsvN5BVkEsDC+sGVansWGE/TCh4pyue4p8uKoX7JNlWiqUgNMP4Wso1G4Zse3YWbav3wWT4YQPgvrXKrk789VVBhRPTgbxlNVyo6wdAMx//hzaCsCE2NkpfKRu4NMJaSQEWq7uEPlHja9+04DiLE9FnyOJZrSzt/fAYY6AuaYNQzBo+2XxIAvOURddquNdPe4+QZjw8D95kcP+Y/wtQNjaOnxZaMCdBP5JX87R9mftTHq75lmclGLE27SDCKQFtH7PMs/sJks232O/dljp9t3nRTL5gF0PoXPeCd7c9hSTQHOAyoaIwKgtJXsZ3UxpEYfo7MkxDbQooHbp/ejm56o7odmafL15YawG4tCD9tOhvU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 19-08-25 19:53:08, Davidlohr Bueso wrote:
> On Tue, 19 Aug 2025, Michal Hocko wrote:
> 
> > On Mon 18-08-25 20:08:19, zhongjinji wrote:
> > > If a process holding robust futexes gets frozen, robust futexes might be reaped before
> > > futex_cleanup() runs when an OOM occurs. I am not sure if this will actually happen.
> > 
> > Yes, and 2s delay will never rule that out. Especially for frozen tasks
> > which could be frozen undefinitely. That is not the point I have tried
> > to make. I was suggesting not treating futex specially because no matter
> > what we do this will always be racy and a hack to reduce the risk. We
> > simply cannot deal with that case more gracefully without a major
> > surgery to the futex implementation which is not desirable for this
> > specific reason.
> 
> Yeah, relying on time as a fix is never a good idea. I was going to suggest
> skipping the reaping for tasks with a robust list, 

let me reiterate that the purpose of the oom reaper is not an oom
killing process optimization. It is crucial to guarantee a forward
progress on the OOM situation by a) async memory reclaim of the oom
victim and b) unblocking oom selection to a different process after a)
is done. That means that the victim cannot block the oom situation for
ever. Therefore we cannot really avoid tasks with robust futex or any
other user processes without achieving b) at the same time.

The current delay is something we can tune and still have b) in place.
Normal mode of operation is that the oom reaper has nothing really to do
and that is really a good thing.

-- 
Michal Hocko
SUSE Labs

