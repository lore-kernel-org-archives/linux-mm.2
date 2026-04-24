Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D45FF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 22:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF026B0005; Fri, 24 Apr 2026 18:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6076B008A; Fri, 24 Apr 2026 18:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC5D6B008C; Fri, 24 Apr 2026 18:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA8B6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:26:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BECA214014D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:26:45 +0000 (UTC)
X-FDA: 84694885170.21.47E9B06
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id DFDFE40011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:26:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j35PN7vp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777069603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJzRY5bsd0JJCam6REjPs0q6dvg2byR9L1bxAyFIFhw=;
	b=urWvVwWKqbkeJcq0LFxUdUJE8WzSBfXnN/S3BeMRA8ZR9AJDylGhsJ1a+p8MZZQ124QNTq
	FOiT/MRYnA8NDQTWeEpf9RsK05LSZodczK8HZbsZ4yweWgSHiX9IdPPpMfHh3auUiw3I46
	TkYJqiyWGBpu/wlUHtP8JD3dscwAdHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777069603; a=rsa-sha256;
	cv=none;
	b=pphFSgblgq34c/tuUImK4iNkwB2Le+mx5uQnaYlSs0df+XZZ8/DPPI5UoCCwwEioFlkdHE
	MvPC3D19+3kUfiBNdd86iFHHzNTAV1LTSpe3LYeOmfyhIvEjcoS9UzBES6XAfYTrTTmaiu
	omTlsS7jB+2Xn65+RFPIhHbZG0R4Z54=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j35PN7vp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-56a9076813bso3434350e0c.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777069603; x=1777674403; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJzRY5bsd0JJCam6REjPs0q6dvg2byR9L1bxAyFIFhw=;
        b=j35PN7vp0WLYk1Ls40SD5CXBy97xZJ1Swa9X3q1WWPDotuf5ean3ay1DcCaQR5RCoq
         GiRNauKh5H0PYRqrnOKnfwN8GS+616djsw9WlXazMt1I8rUjaK8CZkL5GjbRwYqQ4gAY
         +34UQuySDioKBfR8+j+MPfGeH68TRJWlFa83dELeyjpC947+LOZ2y5YmWV0ithHEl+gC
         wnD8YiCrfQyUOyGFeiGsShEvmXhApye7HXl0WsKVKgpqQnlQ5J2mlg9XEOplplF78nLS
         lSDXcu2jeti3o/PDb1xoWiOghN7nmje5xU5Qt/yBBnItZpIxssJTJq1rERwNmiT2kSOI
         R7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777069603; x=1777674403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pJzRY5bsd0JJCam6REjPs0q6dvg2byR9L1bxAyFIFhw=;
        b=fB+mTw+tLAdc0y/imr2VVkewLYd8wkWPQPioH3LcRsbuB3GIcCCXqGIrzUK4q/DMF3
         ILp6oMes6j1dNcwQwPtutmfHDPa5S0xcP3ZgRjSiLf+uXCUGF6DQHNrVE5byWF6gccwB
         abXhCaGgeJy9eUkl+Djf4rPNDEFmWGhpXXQdW+oNms0Lu47cqXdk+gVUREgxb8eB4pC3
         MGt08FzcuzeFfhyxM50Pr8MD6jf3MLLZG1647wwDfQwukwLu+1LTOVNVb8zHaxgJHA/O
         +CzmLi3NbKgH6nW0LzE3LfbGHpcirS+DzA9VkqRy0dfmZ6mNqRTie8bAQq2J5Qvkxoxx
         h50w==
X-Forwarded-Encrypted: i=1; AFNElJ/kkep9jDG73lfEPt7eHLYc0YJA0tTDiPV6tM6R8VqhFQ0YGmVC3ddZrROyrF8LMnOk+R9HXqayNg==@kvack.org
X-Gm-Message-State: AOJu0Yw3CW9qsdtU2OslyE3P1QOvhXm95jvnWH/4/wIhxEFYqTQwTwl/
	EEnwFCPwqlnViS58CcIdG/EXlX8Ms5aPr8yehjqKpSMLect/GZYUMb3T
X-Gm-Gg: AeBDies+SJTGRYCgcwShlw1JqjMQY9M6V4ZJ80WMhBMOquOM1postCJqwPlKm2jhnYh
	0BZ4M7Woi01kf19pTY04YcinrNlftiaYxY4fSnCosBFH2o8J+goVshleopoRYPyxSosLMcY9ATI
	ymMR2X7dwE2iJCfELj+TZmzFVCQoM7HBRlYi0cik++6b7KOhuKDxd6ys4VDsSMQDUE4P1EeeHPG
	RsWR5SYMmGUX/qAWdMwJsQ5kJMkVC39Ucp66A+7FdEYtLwMkK+PtuaEycR8dn64/NTUB/ZOm76x
	soQCUKijdnee09D2GgpZsbmnFiLSQPBpsYQcXZYLJcYiMl1SZea2zRJEkc7UpaixQYCdeTK7aLp
	trBXFu8vAxVjo7aFy8BgVol0noMb2LM4QeY40tCbz7MKp2ekiFj0UL45+DPZPWSS+Y2mtSk/xNt
	x3zFWDbgOyim9GbePsx0jX2zHSLvIgCnOZU2Jx5WZsA8YgzaWxWzPRhff95yY3E6iVRJHX4VCBo
	SaByJ/XbfVJlQ==
X-Received: by 2002:a05:6122:2104:b0:56b:5e7e:d3fb with SMTP id 71dfb90a1353d-56fa59f36aemr16647685e0c.12.1777069602870;
        Fri, 24 Apr 2026 15:26:42 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56fa91bfbffsm14233298e0c.2.2026.04.24.15.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 15:26:42 -0700 (PDT)
Date: Fri, 24 Apr 2026 23:26:37 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Dave Hansen <dave.hansen@intel.com>, David Stevens
 <stevensd@google.com>, Linus Walleij <linus.walleij@linaro.org>, Will
 Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li
 <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Message-ID: <20260424232637.054f15dd@pumpkin>
In-Reply-To: <aevhw9xqz1pWA2Ow@plex>
References: <20260424191456.2679717-1-stevensd@google.com>
	<da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
	<aevhw9xqz1pWA2Ow@plex>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFDFE40011
X-Stat-Signature: ordzwkgsuz1now1m8xmt7wr5hd1af6m4
X-Rspam-User: 
X-HE-Tag: 1777069603-39004
X-HE-Meta: U2FsdGVkX1/T121DfYdng0YHAfdc4HDiVHk+nXDFpbNMep+3qoJm19VUW3X1mgz1TJAMNjcReftLjJnomKzHFAK7opz9NmSIrJ/u6qJhee2iM+c2/bK33q0sqXEaANRVKL9aid0OKOFHhHwMghHxWhOJ5zeVr9gXr71GGY5nXYkY7n7Dr6jYojKTvfwPpmE8+wojc2hGsAvJi4VFPbh/L2LECRKhwxjqg3yrh+m5LtlqQgzbpkMN4ra16QzG49phdhSpE83vzSgz0nEQU7XkLdD05ycECKs+zkXB8VuNucCjvfFe3LhcwYG7cqsBNVDKb1AyiD3+2flqff2HTsvXzgpVQT2V3CKQQpGHDT20kde+kR6Qn27WNV2EggO7NQuLyqZYe6YX/VLFlZzBok1+NWee1uN+sMrcesY2HHGeYhjcH6ke2Psd3FoEWwBBmRWTeI8iZYYOCGstafZiZQceL37uHQThFf2DKC0gYRBkflElfmd48oEJQRDy+v1QCeVdWfHazQr9i82ntzj2ALcUIZpyzQuxeG95ZvbpBe2PMt13AXa9+gOfKl0QkiiZLUNxOpQ1I+rZI3zlKq3Hl8crBVspXHNmUe+/+fRMvi3aZG31ZYzHRil6eEgWlHMd8qSJRadwnBnAIeyeLl9fLUiX+e1ks8gKQa0d2h1fabDuOcCLsjWQ9WHdW4Cl+fdJq1BnRt1RLXY5uUVuTf2MZejDBQMKAd4oVWeWl+/sszSwJ8xMVYnanhF/uq1x+viilFDAhMt1Q7tJwpCzTLiRIGQU3QR30ReneThXMfeRsbSIp/ajrPVqARUC9bKoJo5DHF2LO/EAv0qabhbc3NbM9O36ncqBDsKw3L6KR6lrmVfhM/in1ojnQIt/ocSN1KtzOMvzNPEuaP3XmeTVL0HB3SpX6hVwbAvHR+bZPis6wgkHG1iML70fNSqQ+5Co85fNcIN7x5vLFFqxXhAXuTo4drG
 n6jCjbqM
 AlPIhFA8s9eCDETDNBo7qA8tOzwmfZsAFBPYhh+CrcvHKU+HAPLfYfsJVOzO4TovLoIQhKPbgmeFW6TUUR8pEATgGeHFdXWAjNi8Z1nJjYD9qEV47hTkdYq+odiHs7Xy2ZgCJFca2OVn//CWhwauS4ru8SWljqfbZIOOhJnSr0CSa0A+DXh2dR3NAQG8JWv/Atn7J8CzNvpHLUrKitxGPazb0B7scG+1+0y0ddDxfBsUlYr5C0uz4fI/r9m9SkrSMGlg5q6rsi5Cw9EM52eyRUU1KOCF3gxzHmjsGXKr9hB+F0NfnusRZ91mraagN9znb1OlQCNZODF9jcyhf4Kuat9vYya9cZOJGrCmlbz0XyMTvMlFhYlPIW6SJgLy2Uum+J6QIvB3qsxthb08QPY6M7ssFA59Y7LAbCNtPNs5RfaqWFbXVcJikJG8Q8Ij2N7Ze2gjmnbzFOPMmxJcmoJCYaZt7TEaPomkIr2zic2tBUsSusPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 21:35:20 +0000
Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> On 04-24 12:41, Dave Hansen wrote:
> > On 4/24/26 12:14, David Stevens wrote:  
> > > The question is then: is this approach something that is fundamentally
> > > untenable in the kernel  
> > 
> > Yes. Fundamentally untenable.
> > 
> > Not allowing stack faults has been a wonderful simplification. It's one
> > of those things that just plain makes the kernel easier to maintain.
> > Saving low single digits of system memory is not exactly making me eager
> > to go back to the harder-to-maintain days.
> > 
> > I seriously doubt that this 1% is the lowest hanging fruit for memory
> > bloat on these systems. ;)  
> 
> This true until, in a fleet of millions of machines, you encounter a 
> one-in-a-billion chance of a stack overflow. You are then forced to 
> double the statically allocated kernel stacks on every machine, paying a 
> memory tax even though 99.999..% of threads never exceed 4K. This 
> overhead accumulates to petabytes of wasted capacity.

And then you hit a stack fault in some path where you can't sleep and
there isn't any available kernel memory.

An alternative idea is to arrange for some system calls to sleep in
userspace, so when the thread is woken it re-executes the system call.
It then makes sense to assign the kernel stack to the process when
it enters the kernel.
That might mean that you don't need a kernel stack for all the threads
sleeping in futex() - it might even be possible to do the retry in
userspace saving the second kernel entry most of the time.
It is all 'hard and difficult' though.

The easier solution is to rewrite the system code so it doesn't have
1000s of threads :-)

	David



> 
> Pasha
> 


