Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F132CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A946B0088; Mon,  8 Jun 2026 11:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841DF6B008A; Mon,  8 Jun 2026 11:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758226B008C; Mon,  8 Jun 2026 11:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 662656B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:27:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13D811201B6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:27:48 +0000 (UTC)
X-FDA: 84857125416.23.BD3B313
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16FDC160012
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:27:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=icNVhayx;
	spf=pass (imf08.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780932466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UocT/uaqPPxlXiS0ZwSI1AWXKBm8Im9MW3m9ZqlaaCo=;
	b=BCO9zHqTKEAdcNG3BS+uFP6LjY15Q8yCuShuo767Lek5mlicQdX6RkefCmh1U+FjtMHGGW
	8TCvYSYbrsoyVWIoc9wQUqn+LOLZbMrVl0w9O083jEybmPzl7lRNBZ9UmB02wuZtUMhfY8
	WuEKRSTA64XVMwvrFQUZQxqp/jvenN0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780932466;
	b=gkYUCe4UIL85XO01kU2GyahKV3+R0rTpDhxxPYTCAVFCuR/EW/lm5Upyn+74bEyIPc7KCW
	SpW6LULAlC2zNahjhx2u8lwTHEKs5+wQ2qshbm7qxK7llHUOsPGkCJc0To5XRiJcpf3Hh3
	nc1WbTAM5iMueUIZyLe78kKqp6YkdHU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=icNVhayx;
	spf=pass (imf08.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8cceb2ecc03so38313606d6.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1780932465; x=1781537265; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UocT/uaqPPxlXiS0ZwSI1AWXKBm8Im9MW3m9ZqlaaCo=;
        b=icNVhayxqIRJwQIb8fOC7uplmjDt7a+h7tnZmf6OTpveiIsjThp0nsQASm9NHHSZ5h
         +OTIxnGXGxQfXLrPiWndReXJvjOB1G3bjfmAhFhDlmEKqSlt9BV5oPKH1/S21QLi3w5p
         7EJ16gVmmdEvdF1JwQT4VGN8jXcaaEuS9yEOhpodBPNcH2o6UxGw45PKW7XLG7ngNt+F
         38AjLhUnX6w7M82/+8r8/SnrFZ1k8FFwRTeBIqwJnOH+xrO+3cuvKl2NkBDJUXZqrJiN
         BUA+cvyrz6vjldec8tE8jbl+UOGLBXk0UXAohiNjtJ5md9sh6aYpvbcFdG4A+JyRg60t
         BO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780932465; x=1781537265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UocT/uaqPPxlXiS0ZwSI1AWXKBm8Im9MW3m9ZqlaaCo=;
        b=XQJOpJlqmUg57owynFMAVxe7bR3ZC/gb7Lx7oZbN1bw3vk6uFYo+lo7C1aj4RLqjfq
         09TthfUPrr79FvHH6CLE7HRp9aDl5h3lQBZgx4mhfGRbvDA9HM6PDSNSLq8P/M5H1Zic
         oUTJp+DjlFa1mAmKeDE5XqmXdSrJlW8+okjExu6v8o+ZfVifG2GOWr9/kckZbUWRBNzI
         Ee4AVcAHEHjKPJsHsn0iTED9UXlq+X7HjKGklHGxFtrVEYPflVqXb7zHyrKaJSYlQ463
         pR+XYQjg3ctr2LRPdTGkvkjluriFEkRDNlYNzTISMd5m3uGa4LfKSvnKQWrjinFKlWIR
         JdyA==
X-Forwarded-Encrypted: i=1; AFNElJ++xVD/DZ87TdqIKrSqMozKjVIH3TjtXoZxMqwrHUly8tGgNEi6UE4oN50KqW5Dw/56JbkNcDdpRw==@kvack.org
X-Gm-Message-State: AOJu0YwxDXyw24CR21ZSEGw4c/kc0CyKBgpZJpoo4ND9PPctnNVscwyn
	IHZFjPdxgL5vdrGsq4UcUPjIOjjAeqzSzjHh0YsFhVWRCfIVvCZrsEQiXeLs8HzrcrM=
X-Gm-Gg: Acq92OHE4mn48Sopj2Am5ZYVUr1KgyjM/XhYsKD8K1jrF2PP3dY3bm66gDLDDJH1hra
	6ztV0LvPYcouia9xFfwkoKBxbVOAvym91pEd1DEKCoN2J728rpq8KJ/LKSdRiXOl65cJT6Mppd/
	eARxg04gU6nB2c1vkGiKcN1blpiu+Jw/eGGVmxV8lkNZPdUOLmGKCUiNOLTaxy2us0XdUhykomM
	fVgT3ET7boG5fpXcSfCeGjv01yfhG7xBP1ctdvtDoXyk1dMVNapNdroPlJ+mnnX+mvWRfk35Yn7
	S2Pj64LJo83P9fVCijtn0qOxp/8a9VxoDBh7Vpq5+A147ZdWHs7kJPfV68oDYFqHf66tdA8BFwg
	etgM8IQPXQqeMHOJeRtpbjcxmtR1dV5T9fAw2fE6IglYcwNjn7qVB5yUKs49lIRVBEGWVxhaxem
	U+Ed1S8Tw/5w6JUyXPNVgUMAQeBQ1SwaD1ADQy4D9ZAo5JJJ6Q3bqm9W+ZXwv5Jhg0K//TQ2eBH
	iT0WONiVhAih85E
X-Received: by 2002:a05:6214:4e09:b0:8be:7779:d1b1 with SMTP id 6a1803df08f44-8cee6252853mr236200376d6.30.1780932464978;
        Mon, 08 Jun 2026 08:27:44 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccda0611sm170331636d6.1.2026.06.08.08.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 08:27:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wWbt9-0000000HQjH-3xEo;
	Mon, 08 Jun 2026 12:27:43 -0300
Date: Mon, 8 Jun 2026 12:27:43 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sumit Semwal <sumit.semwal@linaro.org>, Jiri Pirko <jiri@resnulli.us>
Cc: Maxime Ripard <mripard@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
	Christoph Hellwig <hch@infradead.org>,
	"T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, lkp@intel.com,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	Arnd Bergmann <arnd@linaro.org>
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
Message-ID: <20260608152743.GD2764304@ziepe.ca>
References: <20260522225853.878411-1-tjmercier@google.com>
 <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca>
 <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
 <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com>
 <20260604135712.GV2487554@ziepe.ca>
 <CAO_48GH3NP09U6TdB5drbKY0TpwvtBXwrf=Jajsr5ttNbC_u9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GH3NP09U6TdB5drbKY0TpwvtBXwrf=Jajsr5ttNbC_u9g@mail.gmail.com>
X-Rspamd-Queue-Id: 16FDC160012
X-Rspam-User: 
X-Stat-Signature: rxrxh3tdmb98gysx46pb8m8y78mcswtq
X-Rspamd-Server: rspam08
X-HE-Tag: 1780932465-348695
X-HE-Meta: U2FsdGVkX1+pcx+ELnT/0daFsJw7vGf1d2jEMj4+b985N8utpKZ/ArZCUM/t0zFB+0p5jKPuKKhJ34jCTtudLYM2r0+2GR8WdewB440ZKA+GVrpHAfUYToUAYiSs9D3EGccS/FOG/4I5VqCmv55owQhOhXuFi0FU8di7TeUgqWB8hzNPbdJ4W1tKVLctanUn+KRsP5hn/CLtv0fk5qcWjGQ4PqWJZ9l4sKJ+FrU9ua4z1vAz2M1Jrt6X9VCUQZZoUNhK5UwMWYPj3f1b5uZV8UW/gApdCF7EihNqGLWmFs/G3lDybQNM4Qa7JTOuRHEhzlvym5ldhc5CglxmjDJ7/23z0TJWjQ9OD7mk5apLUtJ4zatYPZSTxT04sZDlyzVgbf32cyjASTnk5+DVrgSc3dovkxgOPnvnyMjjjHcz9AnMj7H8sHSklhnKRa7MZFXX0U6ErALW0aa91E2SdzNPZ9guyn2J3CW1+uH+coa5Xyb7jGkjw/D03taBNQadH7NG6NA6WkXmTJ/BKbOgCxEcM4QcfFhBcC0O3PCNtbeA1t8Ta8tGd98mB1dGvmG3YTDJzhXGmAFC070t81f1vt9LfU+2C7nXJu6nLrW6zaybg4J2yJSOx05LDs5pzkraZq3geBT9qexh4usuKz02bXVXSIaaz8wuW7terpN6+3NzVpNRg6yTtF4ui4+ykz4IwE5DiQwub9Ck9WtwVCNp+rvIAUFKNPjZQjVnumLRMjfk7FnLmNoilSKWu/MpCt872jRqcbmcvWC8gAJw+fK0Ov7cfl63T6TVJxA1nncNnfLKCiDWI6jDoQ1Db6xHCl0vZ+g+dCMagsrqnMRRgott445GILVs7eppmiwnLIxWpHyhIZHxHOL8yHo9M7ld2VXtGCDKmH3LViYUr5D8Qb0IqY9dH+hxCDhb4dPYTvr0BdbnWaYTSf2imArNh78EfQvxBQ7yhmTlWXIWFHe34tZSFOu
 HqocCp6F
 ebmBpUPcw0APW82ANurP3cqw74fYwNoINfQX09mZnZpV7uLrwSyXomCJqmJmtlm07cBCh66LHS2P25TXHVaZDYESk7gvu+UGpVQa6N/0RaJKYw1DVBjXSLy46PBXiLwSWAJ4M6EGFMZnc6ePo3cO5K1gZ9xhuLO3JRL8xnhpibW1mnnp3TirFAglEwJ7HTfXpEbuwLA6waY/WymxZv8huZ5D2gv6YynD9SzBitUiIMSeX4FUiZbF1rYYchrHwWay3dUYjy1V4zTbiQzU0dMYQ8HbtFSgpZA2EjsDIxKcGCZsJJhBGnlhGgEOnwaxbrGpArNh64/1OgWDt+SF93FB1pSEUaBXuBT2KZPKk/39Fu0kK99T2T43rydXQlAKUWD4P192HkTuKw86geio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 08:47:15PM +0530, Sumit Semwal wrote:
> Hi Jason,
> 
> On Thu, 4 Jun 2026 at 19:27, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Thu, Jun 04, 2026 at 12:51:49PM +0530, Sumit Semwal wrote:
> >
> > > Given that Christoph's objection is not really about the modules part,
> > > but that the set_memory_{encrypted,decrypted} should not be used here,
> > > one option is to revert 78b30c50a7ac until that issue is sorted out?
> >
> > Please no, we have stuff already using this so it would be a
> > functional regression. Revert making heaps into a module since that
> > doesn't have a functional regression.
> 
> Thanks for your comments.
> 
> To me, it looks like while system and system_cc_shared heaps share a
> lot of code, their user bases have different needs. It's apparent that
> system_cc_heap users don't care about it being a module while system
> heap users would very much like so.
> 
> I also discussed this with Arnd, and he suggested we could rearrange
> the code so that system_heap_cc_shared_priv depends on a new Kconfig
> symbol like
> 
> config DMABUF_HEAPS_CC_SYSTEM
>         bool "DMA-BUF System Heap for memory encryption"
>         depends on ARCH_HAS_MEM_ENCRYPT && DMABUF_HEAPS_SYSTEM=y
> 
> This allows building both into the kernel or leave encryption choice
> up to the consumers of the system heap.
> 
> If this is agreeable to everyone, I can post Arnd's patch.

Yeah, that's fine for me for now

Jason

