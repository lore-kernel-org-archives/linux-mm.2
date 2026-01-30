Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925E3E6BF08
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 12:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E532D6B0005; Fri, 30 Jan 2026 07:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD736B0089; Fri, 30 Jan 2026 07:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD58D6B008A; Fri, 30 Jan 2026 07:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8FC46B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:21:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 612461B18DA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:21:00 +0000 (UTC)
X-FDA: 84388539480.29.66E47C5
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9ED1F40009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:20:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MvwZ8uJf;
	spf=pass (imf04.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769775658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47z33Oj/PlPITytQF5BZ//P3DDU1FR4d5O8MCvqsW8U=;
	b=3S8Jap8Cgr9RuXOvPD6mnc7defr1+7As9M2YtI2IMOOeJA4IrLShMn2K6eQaARu5FTg4Wj
	1mDvyDv5zqQeok2tfDYu1N1RBIeJkwlucl1NQF+woVd7W6T46DmcT3tDLQyAGjrb6bavHH
	1sMVP2Q9l0QOpr1aHN++7U6zc9rPS7k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MvwZ8uJf;
	spf=pass (imf04.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769775658; a=rsa-sha256;
	cv=none;
	b=hshZLfr8bbtuXPt3MxA4KeePMkrP+5oZdvzl647TUprqHHTE74C7ogE6PZ0grUr/QRHh3R
	YmvQab3YqucUpf3A8a2mLIcKYvUHDARx4tuBLaJOFnkE/cTGJl2dAiV64zwzuiwjRN40py
	s3xPFIfCnkT0L/coxvVK4XX+qSavbM0=
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40427db1300so1205043fac.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769775657; x=1770380457; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=47z33Oj/PlPITytQF5BZ//P3DDU1FR4d5O8MCvqsW8U=;
        b=MvwZ8uJfNCg8CyFiXkqCebkWHGS2rPd8juJJkOehsvX9vrGDyPR9S3OU3Q6zs7gzQt
         ghPwi529JQT7J4ysNmPPcEE+SMNFwsFf+e3/Gd+BUamTFpdbuuUSfusrOh9m5XcjhpL/
         KgsfcfS1mHk/1oMnf6S73YIJrUwqeE7m8snQ/doU/US7+ywZL04f/UzmV5hfeM7nW35M
         cgcocvG5Kj7LYa0ct+ZTeAhBJVkSRcuhE6OhbY29B0+6mBJ46Wdm08O5FHAM3Qj7oF+a
         +Uw829SwuYbeh8i8JfqNJbycs6kCdX1ohrYAiJEBi4WlyAn1ahlCz3wLD17LmbnFbGzB
         3gUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769775657; x=1770380457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=47z33Oj/PlPITytQF5BZ//P3DDU1FR4d5O8MCvqsW8U=;
        b=otYWPv0zSrLBapoAEXBZ0kgHQdJPxE4I5daK53oAx2CN33TpJ/AAYex0pKRedwKn5U
         chebhjoJp53VlCiNKj/WgTWdleMCB79MfDUUA+ODWoNDkjfPRU5pEzinDTGYW19jBrIY
         2GyH+J7NhAoomXfjfM0TaVyg/BX8Rva/7fiCwkOLFUJX9FpnyBzCay5zBF7loLDVM1DT
         4EZy7cVXkKHHYjgvBd+T5CYUuXGeJZLlrmWEkyE+KhYNs9xShKj8TkiikdisPJA29y6k
         3OVg6TQ5f6F49+r+Vk3fMTFcBz9H1TQZT3gbpJ80keJ0DBlwl8Pmc8lJGeuweoMmipuv
         Xa1A==
X-Forwarded-Encrypted: i=1; AJvYcCXJWQawr5YuoyZahHWvCj52/LlQqLtyhoYVWRWivqXmHrH2HVRh1qHwVKgrtEcxlvRY1uV5pivDbw==@kvack.org
X-Gm-Message-State: AOJu0YwBajEWdk4CsT9NsmssMSlg4+0E+sBgV35Uo+lOQ2RprVMmQOF0
	Gv7txqGyQfjd3F8RYUI/VRiQw/1/GF8mBSUPLpPeGjhV5bXtV29RJzBlHJGfkg==
X-Gm-Gg: AZuq6aKOoHXmHc0OMrLpkQcZtXPAlHls9Bv+FyJNAk630TJSGcvAELWVW9M8QOhOmuY
	/lyzq+xl+ic65n3bK9PpH0u8whsDy3e+pFeEy1pAnGkY8wWQPqw4h/tl4cf0j/bxVbcgZdjgQCA
	2WtGZ5m0KKW9xPSAChqB4W08sI8V9bIwEtdD+Qv6mvSUyfobKH/zW8RdfRFQSE9HIu++ilSRMrG
	FMnLtFfsbBVnvhzYWyyWIztLAArLnaZf/h46DGRCal81eeQE8S5XgS6vublHApoBoXTbi3+Fgio
	ywrJgWZlGGtyXgANo7Pw5GMrOeCTfqG3GV7ynu/d8H59EzH+s6gukYNPeF9HK/4qQrcTxdT2EwA
	s9ixJzOEWaE3Hv1dY64W8X9rmzEL3xhOKz+PdtxQ6WAC39Aw6DmsRi5dS3hADc3wfyNTTOcttDL
	ZNLjMV0gFshm288qsFTEcSHedAztatfymkx7gohw==
X-Received: by 2002:a17:90b:4b02:b0:343:6a79:6c75 with SMTP id 98e67ed59e1d1-3543b3a5b50mr2569583a91.29.1769769261142;
        Fri, 30 Jan 2026 02:34:21 -0800 (PST)
Received: from chandna.localdomain ([106.222.232.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-353f6103e25sm11900806a91.1.2026.01.30.02.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 02:34:20 -0800 (PST)
Date: Fri, 30 Jan 2026 16:04:10 +0530
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
	hannes@cmpxchg.org, shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com, Liam.Howlett@oracle.com,
	weixugc@google.com, axelrasmussen@google.com, yuanchu@google.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@kernel.org,
	Sahil Chandna <chandna.sahil@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH v4 1/3] mm: pagewalk: simplify hugepage boundary
Message-ID: <aXyJInpe7WmGaEmP@chandna.localdomain>
References: <62a2d7ba-e7c3-4153-b227-c08802ca9e1c@linux.alibaba.com>
 <20251224092332.53214-1-ioworker0@gmail.com>
 <20251224140829.2ec7bbae@pumpkin>
 <aUwruMji4MCNaOPi@casper.infradead.org>
 <b65297e0-0ea7-4ac4-88be-fa89d6749d7a@kernel.org>
 <20251225100106.53e03519@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251225100106.53e03519@pumpkin>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9ED1F40009
X-Stat-Signature: bgu18tgccdnrb4k83qp7z6ke3uxhy9gu
X-Rspam-User: 
X-HE-Tag: 1769775658-885440
X-HE-Meta: U2FsdGVkX1/MmglkZ/wkTmCtqDLhVj91J5g54H6oDCYZargxnrcrGsZXLCLQUj/PtJEmkOXTioYpLOIq6MKQpih2WJ3/HwZVT1GuVyeetW7yL/K44o/E9/zEWLzvOgeBbQUWZFdAnHiTixkfQRkLv2EE73waGuon+3z7q6V/ZygsiacCVDnVpFMMBUUh+hDLVGh3LV87+SsgJ1Rz5Ywi5w/TGwnxN1teVnZyHlnQXojnR/fICY0RvM/Dn39p8MAKtEFBsJU/GytHpWzwMSHi//8Pbi/9UaYzWWWuwJZHYi7QuA+CeiXZAPmS7hQ32ZIKb2aq0PlDfK9nAmBnvf9eCnqAWkzQFPrpU8xNE7DJSqcyuGQilrUSwD7I5BAR5BcyShrXYFVf6IKy5BsHcbrpOA8pmgPm+EMhhVhoINtQvzfJxv9IlMBmV+Ow00fdfuCIBISNG/V50sXM2vC807HjUHBQlo1QyxWRFKSCxU86bM4dUI6EEmkq3OoxUJRBXksShCwtZibBDxPbl+31pxAJcC2SRYaqveK7/JO2HjmGX6dYawMyM/VLCTrmKTA/PUym0L/sxcN/lmAMYOHQfkZEDQoUkf7uvjhNIsVnBSMpRqJInQG0OGdOwoZamBKEQQEHllzoJpzZ9zG+f+NtgqAMMrHAgXF2DVdl4hd2vHQgMftU5tUjp8baXViaVcGOFcg5CFLowsohaoa+ClMWfsVZwUfvZIp+xLD6i7sTRFENt7uMJM+P36zI2WG8r+fpZYy2mw4smxLMvvXSFeOWvw5PlloNj5p9QX9JsZ9rPcRESxdxJQk+nWNw1lRiQjAU2V/lQATr9+MTd9UcFC0eeUjSgEZHKAYBlLd2haWzTDzkwUOlTUZtvFZadMl0QdZXpt6ooA0vkIsdRcNZdXjYGsnbZeuPTGDH9mqOU8Rx/hkTsg3ilea7jh5VHtYSuhHXuw7Z25XoXLPVToqIs7KAUCc
 1hX5PSc5
 oYDxMBrv+gCEEsaMV9P4lnrvfjbqqTbpUsXVuLjEmnXhweghZyuOdP44p3jI/r0WufIIo61tREbm3qX0WPn3Ji4jx7hXKBpEofznx0f6nYzPNA6X38lvQv9rslybAXO3sISa5Y9hW29oK625d5KapWUXHxDqs8oDcc6poCQtnZhQEYNoBsvQ7OOf1XsfSApnT8zoC2F1HQyAXiFrAsbn43V3M8UDcV80n/wWqw7RfSrWgqswHzmXNfqCZIMa+UZGJ7/kagjPnSvVZo8ZDVA6vB9loqpQ5nzzZyInf/e6p9Ds0BQrYOiTwZ18dgw58w/H0/TUCa66IVjTao7qZ7sIOAKILwJPVDT3nHZyK35UDSrg9j+Ggq767jWxap6CcKe3FdvGy6BDJhlBasn0fSt3eh4ttwIBAJs4/UHdQ+q/r3ng3nsmq9h9f1b4DKjEF0a2flPug4OtJIuglrZcevn9NJ4psKu0ETbyRP3k6yIrAz4HflpGPVhSBC5yU9dy37KZ5NZoSeP1svHVclEzm14jkeVukTBkOf45LQxnSHRumiMdQohLm/rC+0B1xNROl0RGkq+n6uVFWok0wG11ek2J6Xe2iOoryBt440RoM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 10:01:06AM +0000, David Laight wrote:
>On Thu, 25 Dec 2025 10:32:46 +0100
>"David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
>
>> On 12/24/25 19:06, Matthew Wilcox wrote:
>> > On Wed, Dec 24, 2025 at 02:08:29PM +0000, David Laight wrote:
>> >>>>> +++ b/mm/pagewalk.c
>> >>>>> @@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
>> >>>>>    static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
>> >>>>>    				       unsigned long end)
>> >>>>>    {
>> >>>>> -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
>> >>>>> -	return boundary < end ? boundary : end;
>> >>>>> +	return min(ALIGN(addr, huge_page_size(h)), end);
>> >>>>>    }
>> >>>>
>> >>>> Please drop this patch from the mm-new branch, as it causes
>> >>>> 'run_vmtests.sh' to hang. Specifically, it leads to the system hanging
>> >>>> when executing hugepage-vmemmap test, because the program falls into an
>> >>>> infinite loop in walk_hugetlb_range() and cannot break out.
>> >>>
>> >>> Good catch! The problem is that ALIGN() returns addr itself when already
>> >>> aligned, causing the infinite loop ...
>> >>
>> >> Using ALIGN(addr + 1, huge_page_size(h)) would work.
>> >> Although it could be (addr + 1) & ~huge_page_mask(h) which is probably
>> >> the easiest to understand.
>> >> Some of the 'helper' macros don't really make the code easier to read.
>> >> (And that includes a lot of uses of min().)
>> >
>> > Or we could go back to my original suggestion.
>> >
>> > https://lore.kernel.org/linux-mm/aRyOWrARRlUCeEz6@casper.infradead.org/
>> >
>> > which was in v2:
>> >
>> > https://lore.kernel.org/linux-mm/f802959f58865371ba1b10081bced98e3784c5e4.1763796152.git.chandna.sahil@gmail.com/
>>
>> I'm starting to wonder whether we should just leave that code alone :)
>>
>
>Maybe 'we' should stop checkpatch (etc) suggesting min() in trivial
>cases. It doesn't really make the code better.
>
>	David

Thank you for feedback, I dropped this patch this has been resubmitted [1].
This next two patches in this series were also dropped due to error in this
patch. Requesting feedback, if I can re-submit the other 2 patches which use 
the "%pe" printk format specifier ?
Sharing reference to patches [2] and [3] below.
Thanks,
Sahil

[1] https://lore.kernel.org/all/39f4490a-d713-44a8-a1d7-3568b01b3dc2@kernel.org/
[2] https://lore.kernel.org/all/2c842a64fddeb0fe0cac087783aaedd97edc3191.1764312627.git.chandna.sahil@gmail.com/
[3] https://lore.kernel.org/all/6d729a60eb71baade3670e5bb609a068683af3eb.1764312627.git.chandna.sahil@gmail.com/

