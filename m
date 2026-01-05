Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA46C79F9D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BDFF6B015C; Mon,  5 Jan 2026 10:23:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695736B015E; Mon,  5 Jan 2026 10:23:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594EE6B015F; Mon,  5 Jan 2026 10:23:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 446926B015C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:23:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D490E1601BD
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:23:38 +0000 (UTC)
X-FDA: 84298279716.14.975BC65
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf16.hostedemail.com (Postfix) with ESMTP id D57BE180009
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:23:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=MIM9w0VM;
	spf=pass (imf16.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.68 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767626617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=HaYTQ7BWPsiVNKxI7qR6p+hkO0uDJULloleKtGqvInE=;
	b=7AqVMfAjLew8TLOerz8oKzw0wz6nUGeOYbOI/lk257br+ANrrYBMycV9vfo1GBPmxBeUCG
	1TK7ZZ9v7lVS8hEmXEIP2QjmPKufRmeycw4CvhabymeO9YCXEWiam/+bMNgxsHSProJ0UH
	p3tpsxOffJF12ZZK7xXf1y323CTpG98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767626617; a=rsa-sha256;
	cv=none;
	b=wHBYPo5ZOgO3pyU7ZtgNgMeQ3JEj1iByb8PXIoQLSfz8MTt7bO+qRQVQ+v8v3V0/qV/qx2
	i+xjRxkBopY/TBP9tRgdqtfK+Ppko5i18+txwvw7VslIm2Ow2AHOI9aW22WoXLpVSxQpJQ
	RMIu2nU9nadkei004GDPDZ3vli580MI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=MIM9w0VM;
	spf=pass (imf16.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.68 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso117995e9.2
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 07:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767626615; x=1768231415; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HaYTQ7BWPsiVNKxI7qR6p+hkO0uDJULloleKtGqvInE=;
        b=MIM9w0VML3fjhTP6zxtUm2u9oUILnP270tzucpaXYVYrzYt2s8Gyu0ZHk554cHbYzA
         4mrlW4eO789FRCHZVdo4zHb7EXjSbRxI4rjJod/mU/tQ3QEpoSOjjAdqQT9d924kRAdk
         6qNXnFEysgRvV4ewjDpqt26E6pL+tEB++49YVlq0rjcioqJ0JgmNyjmV9sSMWBIndJVF
         kQ8DDXTfmYBh3G8/jvdhwYO1DsOt/DMD6DSRipbHTx/cF69ECHSjHqWIobaE2K8MQdkf
         AQOTUUc0Xi0EjOBbYFYcph8N18tSW0GN8pF0tz+cTYTLyTvRHRk2QJGGU3fHjoDKwVMP
         33jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767626615; x=1768231415;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HaYTQ7BWPsiVNKxI7qR6p+hkO0uDJULloleKtGqvInE=;
        b=xNaOE+aObCH+ypwH9wmdfouvDhEdSLC1P4XHEJewN5b5naxNp6wWUIUeU6mKQEyWwV
         0Uy0OAZ3W6SVTq+6mmZ5l0ld2TpITWcnMfMfOYMCEVgr0kGNn5KKfvEM92xHu+jajInS
         WJxEDqb14BfsZFUmjtT6Bfn5ujAFSg5fSQiRiSx0r4VtfUms2aKBzLchpfazpbGiVduZ
         zZT8YYg/SvTJXJ19PQzp9VmqIhuA+xvPQfgBujZQw6h5RYIp1SmL+t4Cr2mbENmFAdiE
         sVxlGsEvcBADHbP773JZTUilgnLBfeYwX8a4gNcMdqTjvBA/vfW43pHr837GuCVoyfZa
         gNqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWTy/k7su+Myj+vC+J6bwtnZXtjJ83mKdwBlB/MfQqUq0q4GvcSnXabG2j+GR6Nmd6sZTtNd5bkQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6WVNFrogojyEpMndttfnNZecl0XZAAuvBluJ2JIBBn8+rLznZ
	SJFnwrw7T9cBMXB8BOHDjrq6hfZZ60dMB0BCuzdchHDCrrXDffoNu+I6qOrlejugQL0=
X-Gm-Gg: AY/fxX5tLNPre+s4+yzQg3j+6rKeYKStiJk3LTkXtC4ummiOd1WU830Q6lyil3PH9fg
	IybuHIjykdHedeeToFS8L25uc2qFQ5HxHt9NJIJJtfaGS1h0fvNu7W/PUOY0zyNMeA6Cb+eU6Od
	nQNENmQX0T0RosxBCREZPS+1leHxsEFWXLRcVTKCpQJy7BvGZB5SD6LYkT3N2ZzGZNjtqYpL1MS
	5AzeEksNArBlynsn+k5Eiq7aUdJHV0ODoNkVuLpka3xSLxWYdZaOiF26UdFSMdngMYcEwKfcOl3
	EXIlOYcgreXILYqaaU+sDPS0AQ03T6nkfzd+mW8e2pIHb17a3NUAUJb17g/qa+umPo3EvGH5YsZ
	TNNBbezfLCirzAq/v3zwUCaD7E4w63BPEHLm9KbLj9yoGZZPrQlGyM5eNXr5fvA1J60HJh9dBP1
	kNsYpjig6SoCV/7SOT
X-Google-Smtp-Source: AGHT+IEbzAH4Mwt8s7uaZyKDja05IxXDpz9rS7YosY9x88I2jrHj3aj2heYz9G34c7JpuT0cp6DgjA==
X-Received: by 2002:a05:6000:40ce:b0:431:8f8:7f17 with SMTP id ffacd0b85a97d-432bca2c441mr136677f8f.10.1767626614828;
        Mon, 05 Jan 2026 07:23:34 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bc9dfaa2sm152913f8f.0.2026.01.05.07.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 07:23:34 -0800 (PST)
Date: Mon, 5 Jan 2026 18:23:31 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] tracing: Have tracer option be instance specific
Message-ID: <202511071533.domGENBS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105161935.545400234@kernel.org>
X-Stat-Signature: szdh8xp4wahtskdj139tqtj1krdyogxr
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D57BE180009
X-Rspam-User: 
X-HE-Tag: 1767626616-255916
X-HE-Meta: U2FsdGVkX1+mliVJpoy1i9m+fdJZwYMeVh7iZTH19G3r1kxfjP/g7StJG7150pNADjJ+E70TCB528PtseRZzFpUPiAeC/oSnH9QizANY+HzsfClUhxyl7rNPCTrHHc380RKrx9C4gTxbWSrQBl4I//7kjgnIH76sLMQXJtpYaalI/WXrBRxH1T7RqrGn5Yd/DqVNTPmQsO11O3OK+zL/92bgeXKltlqWIvD31n/t+ndb/OIHWgiOE6sKaxIk2fOJaUJ/aAKFSlVvGs/UcNDDztn7r/rMHFq1pOD/m86fcR7wo0K3jdjJpVgiUEe8aPYjFQWx7hNtiBzFomKBK8/0LJUEHX2J7k+0GpVF9QVHPMZEK7aaA9KoqPjJlKiYPUVLBHRJCX14v/Fu6h2/BYOEwbckDzBM6CGUYw1knZkhEvosDGBcGEpM431DbXfFvpWGiTegImYyKA7BE7rSWLqvNFfAPIgM8+juUUAv9xUycchcq+nqVlf4OIw8OT5VVuXY4tValX3iLI15Sbu7dd5ypl+bNCdJhq86D3mspTStG4pzX4gOWLHec3Cpx+94lNFdwsNgN9Kn/pDlG414m1jKd1YVP800cJLZGCzCHkOMlVzzz45tbwH4lBzYRpCI86VGd1+2+1Aq+KfcyeKHgyJ8jSxcmmXvmn36eBV5pQvUemIWm3QcI4rlZlG15L4B3pFo7btwBnFJV/M+og/wzVIHr6F8Y5qlpW9WbvC0DJpJcKyDppTvHaafzVQi7WU6Pz0OV9aHfAmgZ7XBLRTeaaEpnQp7GCKliK1Myf8YudMnTPyGEW3EO0pVg8OLFgnecNEuySvgQaDpFdV0hHVktwJ6R5qMnbHxi9DEB1n+Udgl6FZuseXIxrqFo6j6agtKAXlLiUbJjDMa2L19XF3wNM5tvnGdn56hIWK+bHPjP4If5U3QJ9dgSBCOSYEnNEjnFaB3UD1hyIPeSIx9QSK6I+e
 0Cw5Mwui
 jaxBqwFMjKhQy6DcBabyCzh04RvVf26fDN9lxZZoqKboWKgfzhSK5s99cTPYKu7EDRawV0H8Rl+BqVf5NGS3qewOyg0JZ/ZMhKIvQ69BHJB0QUA+rRrbQxdmIzsb93WtN8hqBG1pwYkimYQrPFbS9TcHZSh9SzK3eSIda2jMIYyeQ8WM5dyvS9S3hF6rnME78JmAyG6++4tCehBZYSccoBbCDeA5fEkimylJizIotn6aeau47B1d7SbWhu9huGE+lFbRayzTIJfjiA6e0y99cGHf1OC+I7/fxphv8lDhIJgJYVHC/G5SJE8V7+WIVY5cieF8ZgAB76/LXoDqbrXkpdIBjYKW7NCEHp2w7nguNmphbEdn9rQOfbdieir6kh9bwqJKCCqhTrFJ9EP1YFhyhpQ7QdWQL9L8dx2bwjSScxJYbo2pMzQpgcQRKbJZoqLVHsbDevO44ZyBEVt8uJJmb56Jq7TpEs3yznYznGJpHwzyQQLCYB6Es1Mk/4RBfzXclQLlud2igvsSDguYcvv7QCC9cv6ZBCtTvA+8TndwoUYw/OVUqAXkUh9GvccOL2TaDiOH6WaA9TUOnxAEA5CfcwlzAE7dvlD6AMIGT/xIv1zPeo6c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Remove-dummy-options-and-flags/20251106-010511
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20251105161935.545400234%40kernel.org
patch subject: [PATCH 3/5] tracing: Have tracer option be instance specific
config: i386-randconfig-r072-20251107 (https://download.01.org/0day-ci/archive/20251107/202511071533.domGENBS-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202511071533.domGENBS-lkp@intel.com/

smatch warnings:
kernel/trace/trace.c:6313 tracing_set_tracer() warn: iterator used outside loop: 't'

vim +/t +6313 kernel/trace/trace.c

9c5b9d3d65e4858 Masami Hiramatsu         2020-01-11  6285  int tracing_set_tracer(struct trace_array *tr, const char *buf)
09d23a1d8a82e81 Steven Rostedt (Red Hat  2015-02-03  6286) {
4699bbb369ba1d3 Steven Rostedt           2025-11-05  6287  	struct tracer *trace;
4699bbb369ba1d3 Steven Rostedt           2025-11-05  6288  	struct tracers *t;
12883efb670c28d Steven Rostedt (Red Hat  2013-03-05  6289) #ifdef CONFIG_TRACER_MAX_TRACE
34600f0e9c33c9c Steven Rostedt           2013-01-22  6290  	bool had_max_tr;
12883efb670c28d Steven Rostedt (Red Hat  2013-03-05  6291) #endif
d33b10c0c73adca Steven Rostedt           2024-12-24  6292  	int ret;
bc0c38d139ec7fc Steven Rostedt           2008-05-12  6293  
d33b10c0c73adca Steven Rostedt           2024-12-24  6294  	guard(mutex)(&trace_types_lock);
1027fcb206a0fb8 Steven Rostedt           2009-03-12  6295  
7a1d1e4b9639ff0 Steven Rostedt (Google   2024-06-12  6296) 	update_last_data(tr);
7a1d1e4b9639ff0 Steven Rostedt (Google   2024-06-12  6297) 
a1f157c7a3bb342 Zheng Yejian             2023-09-06  6298  	if (!tr->ring_buffer_expanded) {
2b6080f28c7cc3e Steven Rostedt           2012-05-11  6299  		ret = __tracing_resize_ring_buffer(tr, trace_buf_size,
438ced1720b5840 Vaibhav Nagarnaik        2012-02-02  6300  						RING_BUFFER_ALL_CPUS);
73c5162aa362a54 Steven Rostedt           2009-03-11  6301  		if (ret < 0)
d33b10c0c73adca Steven Rostedt           2024-12-24  6302  			return ret;
73c5162aa362a54 Steven Rostedt           2009-03-11  6303  		ret = 0;
73c5162aa362a54 Steven Rostedt           2009-03-11  6304  	}
73c5162aa362a54 Steven Rostedt           2009-03-11  6305  
4699bbb369ba1d3 Steven Rostedt           2025-11-05  6306  	list_for_each_entry(t, &tr->tracers, list) {
4699bbb369ba1d3 Steven Rostedt           2025-11-05  6307  		if (strcmp(t->tracer->name, buf) == 0)
bc0c38d139ec7fc Steven Rostedt           2008-05-12  6308  			break;
bc0c38d139ec7fc Steven Rostedt           2008-05-12  6309  	}
d33b10c0c73adca Steven Rostedt           2024-12-24  6310  	if (!t)

t can't be NULL here.  It needs to be if (list_entry_is_head()) return;

d33b10c0c73adca Steven Rostedt           2024-12-24  6311  		return -EINVAL;
d33b10c0c73adca Steven Rostedt           2024-12-24  6312  
4699bbb369ba1d3 Steven Rostedt           2025-11-05 @6313  	if (t->tracer == tr->current_trace)
d33b10c0c73adca Steven Rostedt           2024-12-24  6314  		return 0;
bc0c38d139ec7fc Steven Rostedt           2008-05-12  6315  
4699bbb369ba1d3 Steven Rostedt           2025-11-05  6316  	trace = t->tracer;
4699bbb369ba1d3 Steven Rostedt           2025-11-05  6317  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


