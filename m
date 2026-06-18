Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 847E9CD98F5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FEA6B0098; Thu, 18 Jun 2026 12:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F5D6B0099; Thu, 18 Jun 2026 12:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230F96B009B; Thu, 18 Jun 2026 12:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7A126B0098
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:04:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 274B68BCCB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:04:01 +0000 (UTC)
X-FDA: 84893504682.19.652B719
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F079180007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:03:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mGj5tlr6;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781798639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxajIuFFPzIDIlNu/ZZSYfy3SGLhW6O+Tar5hg7rAW0=;
	b=QJSNuUmoUVfrRUY3bKpKLwe4zGxA6tfWjaSXq2B+wnmsYfkLDzVLH6ReZHtg7jlHUzVOuV
	p/sIdgWJkqmriWkF40sHYeZb0vwkRVZRf9XzDZ8DZaqHpWE12oWUNoXcPIkXktLI5KXDg2
	2vhOyyOsSC++3gO9B/voxxIH3TkfLII=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781798639;
	b=VPDkOUO0GRrwYLcmJBisJezPb3ZG9gA4UYNVFVEukIsDtln297P8fvs3RNsg0TPtRVwoBo
	bD+I6DR3Dfdd7h1MZ+kxm3ZOTQryOozPECLKHbgYOlMykEJSII5UsQINKBRNeJXL0Ba9Vo
	EzDsDWki7yovwrT7L/mXwPHVbjQgLh4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mGj5tlr6;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-695469b574eso11919a12.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:03:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781798637; cv=none;
        d=google.com; s=arc-20260327;
        b=mJxlFx/KyCOukoGLiJOofHqWoPYj7JPXcC7zx3kEXsmUnzTlWMgRaoWIwYAmJa9ue+
         Pjy4SNCCRM0GstjwiuureuYNgr0za4hFM6d04ucfapgIfAKM420x2nwfhrDFfRlfF5fk
         Yx98mLFwUd204i/G60vjUsLgx3FRlX+DTn6nKvk2mZoYiZZ1u+OWv3plHjOgbz8S1EPS
         t0ngNVEVWVD+oRZkCc1+pWqzjC9axuR/SrZPp7dHVAI2Wg5QDhIErO71D5yNCj9C1GY8
         QYYyBrXtPZNxmQBJTQ3C3VDhtfuJ9cjNG+LbURfldOKTP6n8lrm4iijlIUasmmYR/g9U
         O2iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JxajIuFFPzIDIlNu/ZZSYfy3SGLhW6O+Tar5hg7rAW0=;
        fh=7T0aNNLTP78wGZGRYuzliGdv5sup9atWbKPmXZdPmqE=;
        b=KV0KKKQGEdHR9WFYU+BmA3RKkd/ZCgqWAxo34qneXIjuN76LywmJz/z1PaV6dgFm8B
         EwFQZwdA2aAHu6J03wslnMeSvbVmuz4g2O0q6vfOmELxtVimcod4aERGxs7LxkUl6TKT
         0JqWmNiD0C4aNsIHF4nfXL+gWUzBNNm1bY+q9Z411SSFt9v57ZymGY1Va/2ujt4QsakX
         gBLRTP31AQ8DsJUf03v5L3p9eYtOcFJXxuT3G2dLTK/8wT29IwCvLD6rI5tdU/jNDYfe
         FKfFYVYgOlTJECzHNLK2Xy0GRETw2JRlXSWsWyHKXw/ubX5+3m41JEDMb6zqK8vGKzYl
         OgjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781798637; x=1782403437; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JxajIuFFPzIDIlNu/ZZSYfy3SGLhW6O+Tar5hg7rAW0=;
        b=mGj5tlr64qUMlly1G+WpT7D7cGA1Mr1V8p1FP1kGYgjBKdTnuPXuEJoP0IFk7U9KES
         6+cchv9rRe+YYl56imii54QqUcNu+8d8ninTbj0ZF1shVPhUyDHabrp9+cXQdpslPh0x
         gjkSVPmtU3wHiVuJLp9YDHGgFpwXFb6t+kBedap3IS1eoCrOJFFG7PW9MR/PaF6B5b8C
         1CcHErU8DHCDPCLgHTIhgxsWDQjjSQNUskSwIO7nGfMv1enB9YEG2sXYPoCQVbx+LnzH
         zfXkbWMUQ6dJKp3axnHjxcXWGH2cL5HvLjVnufuaNcsVk3KYkGsMcFP3o+lG1RWN3LKI
         N6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781798637; x=1782403437;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JxajIuFFPzIDIlNu/ZZSYfy3SGLhW6O+Tar5hg7rAW0=;
        b=VSITR6U3M85SGykEIPPeoycIQ92n5UIzAQ5ICH45Fc2NU8dTySIfRCIP/1qCchgnTt
         zeY4JS+uQe4clk/fZ29e89skW9r0iVpfeC7CZbmXixPaaf1D9dNiAR4oxe/0O+yJfva7
         XAfVOxHcQBkyIMW/IbfOV7t5v92twFlFVXCzCGXigpcMjiuzZJaMTbNCJSgVvfVl3Vlw
         wuitylT5/XSSL6fJtW9it8hDVlg3v1cMFnnCIp0Rf5M7dpALKqvVoP39ggU9znOT/Mmt
         skb0JxMA8ylTr6k3I/roM9z+g6KeL+Tsqv9Zh6lHioh8imh1n8IzN5LetQ+NcSjiCFJ9
         yMJA==
X-Forwarded-Encrypted: i=1; AFNElJ8wzasvEGOoKI9uCXl2lsf8P9p0lUW2BMMBjOeS2CLRW3bi2UtERDl9F3qpFU5AAJIVLZo2Q1F1lw==@kvack.org
X-Gm-Message-State: AOJu0YxCugA813NrpYXcy9D9/PFSXPc5P+P7IS0RQhe3oFo2dd9wh8OG
	w2q0vffZU6Kk6dNwWaExPfmZsO/NPSxJfPDI03uNOW4Rj1CV1Dz51QGLYq/VsxoUx10jGMblIzf
	luQatdwezi4tdO09E/Ngwoq2RDXZDBzAC0alIlDik
X-Gm-Gg: AfdE7ck7x/EQHZQV06H9xRvQk/BGbStrnJ0agicWVN3KSzYlaSEwjUlgw18E5LZo902
	f0hf9clhzskw48PikxoTeGt+KD0ks6oq1XqEm245FJOMHnksxciQKgCJgW3mS0nPXrXOz/6YOSZ
	5yadwhRhR3FIgYR2FqamXIwVyr7PiTYrEdbRnUu42rQoKRdTA4EoAL4looI6IRGsrlIh21fWwOK
	B0t+NdzAlQAVAo7ksxmkVS0cR3OF3xvKAJmBC3+nI4w9PEZ2g3TVKvB2W0ur4uhrrpsDXeTfcig
	5DUoDH/RzrclYcvjn+7QFi6s
X-Received: by 2002:a05:6402:a506:10b0:693:17e4:c6b0 with SMTP id
 4fb4d7f45d1cf-695d04870aamr34694a12.9.1781798636936; Thu, 18 Jun 2026
 09:03:56 -0700 (PDT)
MIME-Version: 1.0
References: <202606181547.617a6967-lkp@intel.com> <6z2rqmo7b6m2rdhqurspwya25ps4dj7lctdygnmq3rn4xt6h3i@57kiiy72epgd>
 <ajP_-zqVPtbzvc9j@lucifer>
In-Reply-To: <ajP_-zqVPtbzvc9j@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 18 Jun 2026 16:03:43 +0000
X-Gm-Features: AVVi8CfU26Kn6wJARZ7W52yMNTl8DSKc66QrvdqWWlF5NJUNYk-ssIW_WadDCkU
Message-ID: <CAJuCfpFed0GuMk+dE-Xn0w45Mn1Spds-pc2BE__FUoWm6+R7_w@mail.gmail.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5: pts.svt-av1.Preset13.Bosphorus4K.frames_per_second
 45.8% regression
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jan Kara <jack@suse.cz>, kernel test robot <oliver.sang@intel.com>, 
	Frederick Mayle <fmayle@google.com>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	Andrew Morton <akpm@linux-foundation.org>, Kalesh Singh <kaleshsingh@google.com>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1F079180007
X-Stat-Signature: 1cp4u7edar6em1sddyoic3k7mm43szyr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781798638-675659
X-HE-Meta: U2FsdGVkX18ouPS7lYPrKebMPwjhJG7qluvOAAQhMl9k+LKIE0dZod2u7GjwLHAgcwxfwzk7kAQ47dWJfHke2DP4jxS/qEBXZLSoTXGpdb14UwFhsHYoVwhm12O1peGCq7az0ato1ujeoaLiXmeaKwrmoz0wJOewebgL+WAjU2N/3HPrAEOHkAruc8Y1muKKwZ/v1XLasDofjzJqpoSBweHXjBjWRNnW+iqbqCTWtXit8tB7oWClOx2fQPtUXKKwR1M31gm2zOuULpnRKQK40EyRB7y42WT6We099Kz5kVMT7dglK6I9Q2dy/KxlKNWmQSVxf3gjaHT9ghPcaLt7t1A2pnUhaaoFZ0irKEwLOfsTctExACofUj/CK2+A6kAhuKfDKTumkF+bgN6RerKuTlMvebKc9ENkjc8aZz4kAv9+MtJ2OhW2M/uz6d+8s/yXaXi5GuBOSd1sYreVo/SXIfVzCyvSoFr0dLu4a/7KmI4rQADU5xp9KO0gVIH3N8o773gCOCPdQHv/6qvKgRys+DiZ4ejq34wbj0TrQ93x4hM/93SqCYsA6Dge9GEltsdV6X/jeh4KBfgT8wnbXceQRRQZiOEW+lNFKu2ZhW9zxUoUd7nm9i4rcaODhDpuUxkGvih4whuxYrUoZlOPpWKD6b/Ie6rKz19XDYTC16fBlQfGfBXHzw/nLayPYRhGSBfmNRuDYgURYKDa50ggTf0QPIIOjTdfL8oAepCuN100IqSDgE9BOwKT9o3TA20mpDZrvO9WD5aKgXmljMQdKLFTe061ce4n3+w/6sMYbxo/mXX4gynjC8HNybg9VGbQq7z6vrKTuNx5YG7S1dCwub/Bgcwg9mq82rM5e/xTsPNeU0gStUE6WMpGS5H/jvULHDj89f2Xf8D/eCUWqgwMCttEJy+5/HTkL9kEgr1BbJZLmk7nNyQdatSu+8vyD/nS4xn03G5VaGppeGvyd4zn8Sx
 r9Xj0ki/
 lPdynTsEP58cucWVqMGLMyu3B0pP8JYIXro4VTq2SGwArTw/o77AWjNh0G0+qBt57vFBMq3W7YKGLEoXp0WHO48Saqus6DPhBkOXEenDdQLmpOTtT1ZUvy72YkQIL5TLYO2QY1qPwz5+GRWv2MtdvxjjiWj4aLHKrkmb2aFG4NGWhrc7rTdYtowmyWN9udGye7ORlTaE95Qi7Hr80Kxr8PpKJgSjapqUQGyxJH0rGivUODy9J5uSHA4OnWTFFi0VlncYlFKiIt1P0B7zDJk51jPr4hWru1GQAuv7+djF5P1cGxuPmxKSOHyZUA3wzUQF0d7l9OIolC5JRh00dcOaTcan3OLaovUniq+Uo+DPhmm9AT0m7ayzJvxAaG57MDgi6SnAh8mNAkb75nZtPm5X3HRTHkPB4k6WniL4L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 2:30=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Thu, Jun 18, 2026 at 11:30:47AM +0200, Jan Kara wrote:
> > On Thu 18-06-26 16:00:42, kernel test robot wrote:
> > > Hello,
> > >
> > > kernel test robot noticed a 45.8% regression of pts.svt-av1.Preset13.=
Bosphorus4K.frames_per_second on:
> >
> > This one looks serious enough and real. It would be good to figure out =
what
> > happens in this benchmark that it benefits from the readahead across VM=
A
> > boundaries so much...
>
> I think a revert first no? This seems pretty huge for something that isn'=
t key
> to the kernel, then a new attempt can be tried with this issue addressed
> perhaps?

A quick search yields: "The
pts.svt-av1.Preset13.Bosphorus4K.frames_per_second is a benchmarking
metric from the Phoronix Test Suite that measures how many frames per
second a CPU can encode using the open-source SVT-AV1 video encoder."

If this is a video encoding benchmark I would expect it to explicitly
prefetch the data from the disk before measuring the encoding speed.
If limiting readahead caused this regression, I suspect the benchmark
doesn't explicitly prefetch the data...

>
> I seem to recall objecting to this in the past, had a look around and saw=
 [0]
> which has some discussion I think specifically on the VMA boundaries thin=
g.
>
> [0]:https://lore.kernel.org/linux-mm/CAC_TJvfG8GcwG_2w1o6GOTZS8tfEx2h9A91=
qsenYfYsX8Te=3DBg@mail.gmail.com/
>
> (Sorry to be naggy buuut :) - I see there wasn't maintainer [Matthew] sig=
noff on
> this, we should really be in the habit of _requiring_ that for merge).
>
> Thanks, Lorenzo

