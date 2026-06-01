Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F4CCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 01:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2736B01A5; Sun, 31 May 2026 21:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99E96B01A7; Sun, 31 May 2026 21:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988C86B01A8; Sun, 31 May 2026 21:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86BC66B01A5
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:47:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17363A0465
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:47:48 +0000 (UTC)
X-FDA: 84829657416.08.791D735
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id E4C22140009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:47:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=uqBDCFGb;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.46 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780278466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tB5EL8Rhi9qKT2QoOgXudFsNdbKOqjFRFUpfHfwDsc0=;
	b=6Nv4Hjgps4la6tHb0vdo7pE6j0FqfvIGwkEV99nUa3o9/6YjbZjjjd/pN7Q3OZr/HU2VtJ
	mnkVnO9vi6Oi1wahtHSZMw77iV5nedEnp5g/s9DAxvpWZy+s5wrZScihZZCOac34kUzdde
	J3txqWE0MTfAQK6DGXIQIVnqhDGyDVE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=uqBDCFGb;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.46 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780278466; a=rsa-sha256;
	cv=none;
	b=ZP2wPV5Oqv7ZUl97BFc2CQihlfNazaZxcWBs0JKGIfLUXXYnXlYZVB0Zom4w8rtdEqC9t2
	v0M1gfKAh1UtNFMpLoPIrZgNoI3UW8G2aD+45u9fXR8vpy8/ulDtz/52GDvlN7UAG0RYgG
	tspZxReIomGInXJP0U4qGM/l4UUpfII=
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-43bf5f4ee8dso2694827fac.3
        for <linux-mm@kvack.org>; Sun, 31 May 2026 18:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780278465; x=1780883265; darn=kvack.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tB5EL8Rhi9qKT2QoOgXudFsNdbKOqjFRFUpfHfwDsc0=;
        b=uqBDCFGbBfQhYzJ1B5dMpVl9/frn5ETjgBMGS3J9WgVHM1+a5Vbll230asfppxGc1j
         ykKvURQMx0y5WQP0EByHpOFoPsvJwX/nSa9Q/sqK8isRoHtSCUX0MuWh7BSDWSiOqw36
         SvPg+Ya13D82T11EDKRG0I0/oNSuFk4piXufd1NV/czMhvjezo2pBEGrrU7PqgP1MBWz
         wCHP5RpGGwAfHnfqySoq1j9bjY3+O1GhM701GLIeg03hvhdFwTXc1pPBp7gcehOyLpUx
         nPxqIeDamitmuV2E0Qm8ufEzz+Fv3Rka7yMDiB230dHZ9KOxIqRw4UyEin5p6LFnAX1z
         9DdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780278465; x=1780883265;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tB5EL8Rhi9qKT2QoOgXudFsNdbKOqjFRFUpfHfwDsc0=;
        b=p7Ls/iFM+lyg7DEsbXE1Y5Hy+FaWR8sA4jcemKOmR1SKmjzHr0DY57Y6muGCLzObXv
         6ds83CWHKQWRKyCxAzB0X5UhoCXtFkp95pCfljDRLvUJcWkOb3EIm6v3pzgaLcdnO55Q
         Oq6E71OIWsIBAfQPOPGvM8EvnCG13rA0iih5WnJbJRxk+32v9WmCjcIoPZp7WSwxAISj
         bVFIuEIYjuSYKxbhcSoR6lkGE2YSQWmaIcb8UV6RsFdge1ARS+N15umEYeFt1TZZxzYD
         lKomoAsMqTXWQAs+gveQhIYHakSQJ8DPMJfUgKp6WdAtvbRPcy9o0p571wULXrK0yQNJ
         hFlA==
X-Forwarded-Encrypted: i=1; AFNElJ/9bIinvTkP8DQaQLdq+mhkwB6n+uujRlMQ5dkj2/rmZiMPMia03HI8K+tGXkgubA47ZZbzJsrWLw==@kvack.org
X-Gm-Message-State: AOJu0YzeiI0bNl3jUs72M4tO4Rcot0sM3hOOPE1xr9jVsL0CsnbaOsin
	RAcfh0+YfHe2mjsLQCXL8F7vUvOHJqhrlElsBk4SSqXs8X9mvYjWbNPMYdzwm0VzeXg=
X-Gm-Gg: Acq92OEVmf5jgn3WO4v6S2yFIfReCbrGiZEuw53AybuG9zOgOpYxoK/h4DNGDmphspM
	y2OxySXmv7WLJTLBNhGVAVVtme2EfY2TmJ8h2oYjIeFNv+OI4AQ6S8SQx/kRfT08HfgIOMIav8O
	X7Q1nwH+F5ZmEA9T/EJgTrcX5rEzNKUCeJ3oyeLQpkFxC0NhUizT0raR3Zqlbkg1R2CtfPvtstD
	msZmm9e0DfVQhzHdWtIbCf4YdbzkIKjS/ejgNMQcQ57uDA5JY2hL4mQmAKEliOgO+IowZW3H8sQ
	KlQQQvPUcqTX2wYoaPZqd1P1mJLu/k8kVrEYyzgtptGH/Vz/L6EluM5jC7UWO/g0b8BI1JQ0hX4
	Y+dMSTuwnQQaXnVHSF/1cZKRq3ZbPOHpPqhMb1xxonF+ab3lmLlUbp7eLKkjZsDlDUn6Fp90UFB
	7fPZ1Zwjcm0bIJuWIhV6xzyonzyQ6fI78xNCRjrThWU4UvP0QwSsYX1X3g
X-Received: by 2002:a05:6808:1514:b0:467:70c:a7d1 with SMTP id 5614622812f47-485fb43370fmr4269971b6e.27.1780278464735;
        Sun, 31 May 2026 18:47:44 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.133.55])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48605f6a38esm3494847b6e.2.2026.05.31.18.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 18:47:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-mm@kvack.org, 
 Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20260528175905.1102280-1-willy@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
Subject: Re: [PATCH v2 0/2] Add bvec_folio and its kernel-doc
Message-Id: <178027845531.370486.4907470779948430731.b4-ty@b4>
Date: Sun, 31 May 2026 19:47:35 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4C22140009
X-Stat-Signature: aw11rbqbmrtj7aim1ddspwsrikrdfji4
X-Rspam-User: 
X-HE-Tag: 1780278465-49373
X-HE-Meta: U2FsdGVkX1+EFzRXS5gVBoGtnOW8/lrzlndJIvcP2P/XOmuRGI48T825wT43XKucMYBHgHz4RQ95uNY1Vrd3274k7i03EH26nYI3MeoEXq0FRHwx3/N5wmh8XntIEMVYLnTvfRoqRc5D8tpubTHwypQ70aqPXLv+us0c21JlNPMXo57G+K6E7+bk/NhGSPYWA+PTGdgTruxWu3OXtpvez5vVsDRU15+HXeFBvGFyfmeLC2KoARfnlYcP3sF5TS8Zjk/5cir0yCsFIXhfMawfNw21WhCZbNNj8NnlWHc0WSid6HeoD0DpxWAGArUxnyi+NhA6udde3ArJYyt/jyzDFq6N08BPm8hgzcBqD6wWyGnVEFqjwJ8R/Gz1T5yNHHkofsU2M6mjgfBDY4lKAqJXEEN7OcfLtUOW8ui+Ru75bOm6G4L4wBGxqq+9lh29ySBkQsfehhkJ6zQCkq+mhP1mHV7l6fZavibDJICtXOzvGGdQfKwfMN5zIFSzxf3u0rByXC6VX/+Y6wahS/lREjtciB3ZVHyqgs0TZPXGVi5MZr9W8D2GudP5OQPS6Tn5JBh1TogJQUWvIgG2QMXYFedNtY3fD3hiRHIJGxO/zygJvwelUUcM/YnDfRg42XmfhEV767hP2VG2fczNlOgZB1bHfq1t9sjc21qaaBA12RDbbMB7VGLlkMeJ+0mQzicHNGuKxBP5oi7hIrL3R0URm8XxqXqcI2fe6NMWcJehBz+ZkNZ3yhlT6ucCxVFpFCiwoYVsG9rYfsY2dmxRvqIo862is295Ybj0Lx+UMPU0QbmvKixQ9ny8tPfMvDWOI+TKMWe6RSvsdqdfl9Iw2rkVXnZAyEI3D+m/7vFhoJsduQw6dFFfmOxrqbHC2C7xSne2kwH7TqtfdENztlfQ9mVu0yahwW5l4zSLq97ysNKbMLw7fTC04qacNP2gPfjUeoTwk3ivAwOm8uN2vd9rHz5YwkZ
 sifmznl9
 liFZOGu//CyUwPcp18g0/Mplmc/FFcsrEjVNSwTHPyrWWaw3t9ewikGCJhvNfDvVtvuF6L9/zyifYP/+X3m5rL6frKj8Ma92Ri6LL1BUha7pf7dvpqEdDEwro9FhrJkyoQ4sTpOTzYRkm0eR0Tizf9O0HjWJYmBguarCgdLJVPzbeZbj5pbbqEkMPZ4DPOEDosN+frL0zPHvHQb300WnXCQY9rli95QncCq4sXZAnMgsqBklaaev7ilKfRWrTV8SLzna82moiDqUi7TjdzHCpndgrgiyMzktfKhAULGkbRmGPOeo2sl4OnmOVSixoZduJUMZJRWG4wo/fbPfMVQT9LfuusUtpMlKcQEkxkZ/T7zVcF8QZmTIeu4L0eaprokF1MBZW44MzWTuiD1BGl/shtmjdcdJI4AJtGkYFX5qHSpJKYmFE4OQJXhXQXcVCJvHT8gu3CPlG+kNt1s/gSJ6QgLgT1kjeSTxxVhd7Aldvf0HfvRQeObP56LAbJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, 28 May 2026 18:59:02 +0100, Matthew Wilcox (Oracle) wrote:
> Add the convenience helper bvec_folio() to avoid references to bv_page.
> Convert a few of the obvious users.
> 
> v2:
>  - Tweak the kernel-doc (Christoph)
>  - Add the bvec kerneldoc to the documentation build
> 
> [...]

Applied, thanks!

[1/2] block: Add bvec_folio()
      (no commit info)
[2/2] block: Include bvec.h kernel-doc in the htmldocs
      (no commit info)

Best regards,
-- 
Jens Axboe




