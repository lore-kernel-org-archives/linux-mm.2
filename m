Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D036AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D826B0088; Thu,  9 Jul 2026 08:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54926B008A; Thu,  9 Jul 2026 08:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44BE6B008C; Thu,  9 Jul 2026 08:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 841076B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:25:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D314167892
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:25:33 +0000 (UTC)
X-FDA: 84969158946.12.58842A8
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C1A0180007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:25:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qy5e5eFF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783599931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjINX5M4wTaoTW4+GDvLh6TXbZ20xVVmAICykKIells=;
	b=lY/PoMUc5L+Jimtltbz+vJxk2gomWNw8+IJz/UjfEuHGuaGR5yt5DH7bdBavUDjXtuahy/
	MIKJwxB/kEnS/ZwButvaqyHtRGkUb2ennvJIktQVvdzGuimMqgNZ73uLulIA7NBN9Kn2lL
	s90axH60QHElXNIBC5X0dx26hGZqKbE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qy5e5eFF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783599931;
	b=DZpzly1B60ZbsQLkIzctjbQHONJR/Fz7BEDBvBpOshS2KKWpGLrNskDqz1abvtJR0utjBK
	BZKFQyXujCKEt3lAseaKMS+HF26V4TPpvN7iDZUSeg8cE3ShSNrjo6195ex5e7hsDWBOCN
	9cO6HkAHrONGzbolKMTS7UPeUVhvepI=
Received: by mail-pj2-f4.google.com with SMTP id d9443c01a7336-2cad1448ddcso15053665ad.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 05:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783599930; x=1784204730; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DjINX5M4wTaoTW4+GDvLh6TXbZ20xVVmAICykKIells=;
        b=Qy5e5eFFEQzhE5lKXMU5uBlT7Ftht1632bSjrvSE/Mmu0YDkZbMgObwMhAzYEPRqj7
         aa4Okka0PFA00Bd0KO+vkdXwJ5yd0ti5JmQpUtQvVoMg6NbTQJAWuXK9YrcQCX2B/8IL
         xmsZFBvtAHelH5t7zWrK48KLWBl7+WhH1tB8dI3bPyZg6pqxomnmDfinNWU+smQPgqDk
         x6zLO36pZcvGVZPEJ8wwU+UV01rptbjGwjv2uf8lKgQ+SmezrjWRx0QnuZpJLBMg+6mV
         3u+C3R3mjWAkVwKVEcyZL9z+uNvkU0F7sFiUS6RYia8fr4GOCWthTVCh9e+pdag+uSm2
         kGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783599930; x=1784204730;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DjINX5M4wTaoTW4+GDvLh6TXbZ20xVVmAICykKIells=;
        b=tMH8JU4eztirlh7GqvRHjB0rgttk3zv7+nm220F/TAJNjvYsQEd+mmeM/dpPhSPqdm
         EhuJLDfFLYlEmpCiRFgOpylri/g6/jincY5TwSoPLiWm6U4bv8sSyyh/cg/0SSpKbG8W
         qmTHKgFKLESZQbzTT52QxW32VN61AFQVyezAbEXKTLQquKRuNWycjp0Zll04+L1DuASx
         y45IGAa9iXeqW/yHPH/uB41IAXjldQFn97YxBXFavP7ft34Wc/ElsZuSygir81oMOmHw
         3gLM5WJku0oAiI08fwhUG5hYXz764/c5B3p/mdvmgbLm6y5kkYZnzeWEzXdOrSk5f23+
         di7Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp4VcBdQGreUZK2iNHdOj2F5IQNUhzvqW+U65rORDQSM63LLMKc300KtKbd7fOEpnSDBrQhqkGwkw==@kvack.org
X-Gm-Message-State: AOJu0Yz2DT2dkuR5U5MRRfjPg6J26iZ5SaCMxMmaXHwjWStRxduQPxjt
	ozMFqEOu+xEYbZw4T8wVF0RowjOJ7+tozLBJn+YOqenX9TChLiLcXdFZ
X-Gm-Gg: AfdE7clHczrfnuV0cMBmzoUeJaX7OXexgO9smfp8fEQv1n2exQslYjJ/AN83rCMtiyA
	t5mMYfJTqkFPhE/6qO9UIYlCE4FA9vBDgnmGQNxHFV1SPH1OBxHqDjcOfHTI2f7BwNuAlBnAEdI
	n1PCzrha0Q9rqS68E+JHW3NmuFE6aCIXczPhCTAd9oGiM1g4TNT6SLM4wYTZWUiFfVDL9ISvmPv
	fao3ujgRnRj22l3EUKXIY9aa0qFdgzzdKn/O/8Vbbt7mbVSPvvaD9jNY90GzniKtEV0aIpgv8wX
	MWds0ziDbvsF9fBPwX6N1HjGYI0vBgcNJCxONPLDO6nYirlruYV/lC638h5wFwBBk9rAzCgmYk8
	jA0PSY5nNEhg3VPe3sexmsDSdJ1zC/BLxHGhn57qHAH5soPIw4pwjSQ26JNm274xVWMapJKnbcE
	XcmSVvwh3SfV2SziwvlWs68baXFQXcB3Y=
X-Received: by 2002:a17:903:1b0d:b0:2c9:97a7:3289 with SMTP id d9443c01a7336-2ccea47c30cmr71676685ad.43.1783599929924;
        Thu, 09 Jul 2026 05:25:29 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1e1aesm44089605ad.39.2026.07.09.05.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 05:25:28 -0700 (PDT)
Message-ID: <6f2e6fe2-c8c0-450c-bedb-8b4fd68839ab@gmail.com>
Date: Thu, 9 Jul 2026 20:25:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/mlock: migrate folios out of CMA when mlocking
 a range
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org,
 mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com,
 fvdl@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, riel@surriel.com,
 liam@infradead.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-5-chenwandun1@gmail.com> <ak0OZKzapUefmA3v@lucifer>
 <20260709091316.TFgtBZlE@linutronix.de>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <20260709091316.TFgtBZlE@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2C1A0180007
X-Stat-Signature: xqyp3m5tahqnq3jcj3ex4mxc89manwei
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783599931-40250
X-HE-Meta: U2FsdGVkX19dqLKCVlPzaHxjdeja4+LeFmSUeSUYjU6rbVEj+nJw+E9Jo6dGqPdsy4rvpNwpszxOM/GWfl3zLMbBcmYQ9y1qsG5gx2s8md8CgOsZhgzPt06z6982MilbusxkWAHyc0YBex4qXxFP+/7E5Dcqud7n/XnRCA+b1Hw34umzOXQvqmai8nhfVjrySP4W4xVreCKM3XSMruRivpgPzcfV1DwJVnCDLGAZbYTtB/S3jXlVPCtT0xULeK4VplZ5D6AQAOxxBqNMFWTlEt7ZrCYu1nbVx9MMmHVZ4XzwnAIZ37i4F1kbcG7GlORvN0JiB6rh7tCfhx8+DNB7VjPqjwsxu519NlhuP/u/Ju1emN+RKmYGZSB0quYOZUJrm85BODInuFDdZ9T5rJZrxI+EazXvs4Os3kNWoHWhZGTElTI1loFuiQfDvhtdl4ZHUMLgz8jkL9jAxr1Vk5BtetwLxhf5d+mplxBfZozAMMrcl5y3m+jzhMDGwgCUDnRRMQC7NW+kiNlUuI8uOVFYAFnScHSlEJooArnbbSIlkJ20gTD2vq6ePyw6DQAoRw62VzTd+EKmfPD7dy+6aEWC/R2VzFBFd0+R/C0JMVCJFgNfQkTJ9WTSoZrj8oTTsCdvrW6gHpGCkvBy++H7Mk1dU7HXxnDPqQh2qPxHjvy3eN0IpM/yrsZLrrW2b/aQl/Wv27eYU/g8QJKBQp3fT/+t/hfxPEEOZEKx9MQQyO8PqtBxMlTwIUQ1fAJ0xQ7KMYideWHD2ovcpSEoxqPUHgrAOir0ZgWjV5+b/JyCDd812MPlM3Zd1g5Isu5xQwQ2oDdZa2y9Laq9LTnBcPzgG8Rmy6n8PuYRRooWBRoun3uX3EQhJlh6ICdliaVVmIwoCMKKW8z1c9wSP2rvKwXf8jAIiGFklllxM+np9TzY75tKfpv0oljwq8Yk53zNRGOv7kuTj7XtIYkoMz6IoTC00nP
 IwUCEU7i
 WsaJajFxjBtRG0zxxQGYYCfJYO7DpVkiRJ6MiAhN37QuE5wkWNmhz/4aO+/zoNfIJrbgvPLCTdx0o0Rgi7e6kV+ha4reJ+8kN//KLPwKu5nkn2Zw/ocAOc/WNGIiWzoBQV1ny9BqI5xBGQJL4ME2QGZHFPT8qF1N7p+dz26nTIHWhZU3Z7jk1RH4bq9C69gEe1gnSxUIfdNBTqQ5J8oi8l2nRGSUqOao2avfkkMwhYym0yetwVwh3MDDDxybU13hUy54KU3S9PgVoijAu+dDZvfZswfupyXLSxFx9p7+61PB3CM+xBeGGc4MgNXfLWEylmMVXoXaAPqTC1QXlu1K/WkSTcedM7otVa1/CkChd+md1/IwNPE25ZQpbbWnwgAd9aBM5byXfSyfbHVeA5BpKcpj3JMQSuEWFpo3jP+HedZ8UDGcZ4SNwciBs5/JXVKy8TZ7rROH4dVFgBrTywtBipFGuy7pA9WTc0thfi9KpTV33XnhozkX8J5X724Mst4H6LMFH36xBvhcE8kS6neILM3biSEdzKu+fN2GhCqUyGVRDvHIrCtAW2robXQYciOMF90yD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/9/26 17:13, Sebastian Andrzej Siewior wrote:
> On 2026-07-07 15:54:57 [+0100], Lorenzo Stoakes wrote:
>> On Tue, Jul 07, 2026 at 08:59:25PM +0800, Wandun Chen wrote:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> The region covered by mlock[all] may contain CMA pages. cma_alloc installs
>>> migration entries in the page table, if a memory access occurs at this
>>> point, it must wait for the migration to complete, which may cause
>>> latency spikes on the RT kernels.
>>>
>>> Try to move the migration cost into the mlock[all] caller, which is
>>> typically a setup path. So reduce the chance of latency spikes on RT
>>> kernels by migrating the currently mapped CMA pages out of CMA region.
>>
>> 'reduce the chances of latency' so do you have any data to back this invasive
>> change or not?
> 
> The application gets pages assigned which belong a CMA area. If the
> pages are in need by the CMA then those pages are replaced with other
> pages during a migration phase. Since there is no guarantee how long
> this will take and is also subject to general scheduling in the system
> it will be measurable and painful once hit.
> 
>> And for RT, but nothing in here at all checks for RT? You're using this
>> compaction sysctl as an RT check somehow? That's gross.
> 
> The man-page for mlock says that it guarantees to stay in RAM and/ or
> preventing to be moved to swap area. I would however argue that
> replacing physical pages in the background should fall under this since
> the application can't access them and is blocked while trying. The notes
> section (in the man-page) lists "real-time applications" and
> "deterministic timing".  Therefore I think it makes sense to do this
> unconditionally for mlock areas regardless of the sysctl knob.
> Security related application probably only care that their memory does
> not hit the swap area and probably wouldn't mind 10ms delay.

Thanks for helping to explain, that helps a lot, Sebastian.
Wandun
> 
>> This doesn't feel like the right solution.
> 
> Sebastian


