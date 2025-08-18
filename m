Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D69CCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 14:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72E06B00CA; Mon, 18 Aug 2025 10:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A7F6B00CB; Mon, 18 Aug 2025 10:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FD56B00CD; Mon, 18 Aug 2025 10:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 91F9A6B00CA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:24:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CC36140945
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:24:22 +0000 (UTC)
X-FDA: 83790098364.07.878D1A2
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4D04020007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:24:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KHhwkPqA;
	spf=pass (imf13.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755527060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkI9YOv4r07AZaOuAgohpCftqKz/9ZS5s+LWNoe/iJ0=;
	b=LRqz8xVQBau/lnwXW9TbY/lz8WnThmWCZrnX/DCipwWnreAMptOTtbwe+PUvaUUfutUe+k
	DzoJjMWmD9wU4oLdiAzZPCpt8+veEckbLjWoDSBDGGBPpolC6et6Js3JJJVWwErzkW3l9V
	aEfldVEH6+X3j0YEpq1HF+QACevHZOU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KHhwkPqA;
	spf=pass (imf13.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755527060; a=rsa-sha256;
	cv=none;
	b=M2vUt4ulYOIMp0i3/ZLLPW2GOStFb9d9CHcAXSu+y92uqdFozqR85es8XcdpGIpk3zCVoc
	Lg5d6Ic44A/m49MtY2ckdXIooKSaugUMAOpilRIqyvUb94CpftfyC+AAiU5AxfHC85wPVY
	hirrPhuSvDjZk1tHgtb5jFATRbcjZSk=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45a1b0b6ac4so20423765e9.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755527059; x=1756131859; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nkI9YOv4r07AZaOuAgohpCftqKz/9ZS5s+LWNoe/iJ0=;
        b=KHhwkPqAROpY8J9A6E+hKJECsqfxT4f7YsHr/nrR7ul3NHr2izLvkbNQ6G8hsOhPFN
         RGj0y1QXCxbowQHigyHHH9yrYYP8Hce1BVMj/KaEEtLyhfHNgxa5wwL1ssDLKQGVelpJ
         jGPlmHZrcibZt2kHjtYL8PLY7vmpV1SQ3g+SubD4hpj0l/Ch06bk+Fo7SVFP1pfwLJg6
         E0LE0LvrUXjel6cU2VL/Fj8uhKiGYiO8HfgHp5FMunYgUlXpiAY1W0mXYkuzGHEcxXec
         NXnGAvpEO94dmmjupG0us8BPOL0wo/GKHKHcDZrkBs/JNs2lfvy5TuRGb+Bpv9vwOpsl
         sIRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755527059; x=1756131859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkI9YOv4r07AZaOuAgohpCftqKz/9ZS5s+LWNoe/iJ0=;
        b=ui2EoQGXhMCQLVbTvPGngJxSAjeJdLUEgve4gQ/hDR17GfftpsE5ZpOGxfD9ztlD2A
         wHgZuZht2BuqMoaClYZamKdKg5617Erge0yygvl8brfiKyAZ2efgPOtgGw9r9KAC1kQn
         fpns+0ht5lf20J2HvHQrPnJfrLB8YTCAbqa40DgdDKGFU1QW/IjyK6O2RXIeLEgPdRdP
         r7ydzsFxLzfLVdkcDP0HFJgozX56bi/rhuTIdpzXBE1BIpUiZEvE4928CI3McNj86OP7
         Fel1dXTOSr91lV0SjmdrExaUdfvC0gdZ2XEDHt8dXFWrFfJPbj2df3EKvaltrgPE4JJ3
         VoHg==
X-Forwarded-Encrypted: i=1; AJvYcCWw8g3otpFdIeN0GvyrtUqZLEZOCIx5TkLvL/2rCjYAWcOyb2HAw4+AC7u/mHuTJ3szZ0TnK6ME5Q==@kvack.org
X-Gm-Message-State: AOJu0YxkHw3kxwuG6bfU9bPfg4atCXMuEQ/R+iFlLmSId57RsKs+U4Ki
	FFLRe3uluOEq0m8fw+gPiuGSdVxrO50taN2jMje6Ccgge5kwd/WNbBSFODWth5U7bH/QKg==
X-Gm-Gg: ASbGncsdRB0qxFwAg9BrOi/K9uOoiY+rJBoh1yuc7cVeYVge5mrl7Le4NOP9Z6AR+LO
	ZQlgvHcxeHajZeUoHhRTf3Cxxm9HEFKKhkkGGrutbEWHRpBmb8V3K/HlffZtDS9JVq/hnk2tK07
	C8nWnYJN1qZGw47xIMRkO3AWICxIq4CyyyLrUdHdcuo9/cv9mENF4fulOPIYqdFKruXyQ8A7mTX
	Z1H9XJqaRc/OD1XaGDDz0SFZUq8L52J24tP/xlA/6JF9W79AXcs69WLHxXx+7NWcHLqSj/RWp4G
	fLYlsC0o5oAK0ZeVwqoB2XIYFl8buMgVNx5Bz+QPGy13AQml7BaSFnTPGmpISIgn7bOMu5g6Kt6
	I+CAgBNrjdqThrdQ4touZqw5RAEVnG8VjrkiijNk=
X-Google-Smtp-Source: AGHT+IGdTLWM4u44zpOwtBDpQ2Dp43kHDYOCOmgNgAx+WJjoOXFpU3DOTXSDTQF0R6/1ZBdaFGtTJg==
X-Received: by 2002:a05:6000:40db:b0:3b7:8154:aa36 with SMTP id ffacd0b85a97d-3bb6665cf99mr10003559f8f.7.1755527058385;
        Mon, 18 Aug 2025 07:24:18 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:44::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c971bsm12838159f8f.32.2025.08.18.07.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 07:24:17 -0700 (PDT)
Date: Mon, 18 Aug 2025 07:24:15 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC 1/1] Add memory allocation info for cgroup oom
Message-ID: <aKM3j3geY7JiPGQ8@devbig569.cln6.facebook.com>
References: <790da5ffebf18a5a1211ad8dbe4e5b4a19871408.1755190013.git.pyyjason@gmail.com>
 <20250814201114.1921580-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814201114.1921580-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4D04020007
X-Stat-Signature: wq6adiqxogezsgpojnjjezf6us1sqej4
X-Rspam-User: 
X-HE-Tag: 1755527060-99722
X-HE-Meta: U2FsdGVkX18UMAhnB/wp3sfuBc+qB0hbowIuwZ9iXfaFvt5W/NrWZPHDwjHQXe3mqwZXb8oW9IM79xdVbUvxwyUgvIVmjEguPI+X5PnA/A5lXA0lzB76qIpiMAzRJ8Ni88XOTOIeosOlLknU6VWuvyJb37zUypQJdKWu2bpN0sCWR1aDBvkwA1KKtF/BhxSVQpCQzitE0DevwSKQRAQ4yP2E1ryJzV1yo4KuwYJ7ZN6eSIp4/EjXS/J8l/mntZhWtBKW/71h5KVpgaGjkYeAyG/eVgzRJgTlwhgG9rYNZlI3s5Ik4lQfbHcV+BAj2XRqrx4T3A7HIqBBFNd8ThQ4qrxb0nnXNyuDqj+sk8xdP2IKedWduTUvpzIzf1D09b5DiWK/z/ESgmlDsC2VFLk6IoT9VbZSrU02sXHhWL0h6B4pHXHT9c70Qf+FOB9vPcbVFtfutZWcQ2ovKwpRSQHGDGj9Ck9mhaNjyToTqt1P6vCQgIwCIf2WEIW3ofxiQbl7+y5t0lICiG3NEfpJSs03C9gPcS8f1Q9EpMZi33+gdnP+GeyitbALV4bqCDPm5yBUoRAAb3RXmRWOksz37yJ85/Pg+Smdz+kmfTz3rn91/FPZhpBHqQuz/OHJvmy9uTj+zdRRTuAufJCqokR/Je6S7w1Yevbtc1dat/75swBNCSaxYCxT39HRI2GT33lnI/NPE/tNzAOP910MmqbCNNHXtZ2KrkHt/pX0RFW5xWJkCs2Q200At3mUL4a9pLZoMty7EZ0KmZAnS9hCdsK1aLY7/d/Wx0jLlmR3LOWgU+PCTpdvIXxK7DXyX9kreo/rnW+9RClIVvTBYxVKgCf00f8Usg6WcL2yaCZXpfEfk7krGXj/1ZFXiUE0MUeErgWtwfPeTKr2anjYZmMd83B0RvjVIxxruSj0MtiZunoaYChPSDOzzSi/5HI3ylsvIEGXX8iH3Xb7Maj/tawfSTYjH7q
 iGNkYUDy
 Pb2GUmp9aj49i7EnHjH7k5t3qMYMzf/qh8cTQs5euKOtZhmalFkxw+VDmqKBXUHCCwhiWpCiFct0LrO7Nt6vncMqd1QeVfeHiMCg1SxSIs4RqSvrbwo3Z86VGUxKt2XMQJPxELV7X9fVrd1NWw3WxfIYpQsovyTn3QpoxFola7v9nS5Y6XyDkVzIQKQbL1ft50LHWC0pK50NpP+JoX7zEyJPpd2eVzHzvdweewZOtNwyJYAtaBlycZ+PNWnJqX2GwfYGqtoBNlvhIlXxRjP9GVYHc3VnD0IG0vYwZswPh/6QfX9OZGaFnEMqG9VayTHivrHRhN9K9aJgruwmUtnFDRG+Pkyj51ESxF+myoWH67+AS6YGFQ4w3xCzhQwQoSarYgwC/czCn9Q48rhJLk3v8qvK9wQviMLNHldFJByBFPkKxBWod3LeNsmh7Caa/JltVD1qLva7giHXTa7lkvSouOVTVAwcc4nvF1Izm0iYzvBYSojSqW95oUQAf9kF7NDrqHD42ZfpoNORhOazOb2tduxd6D5uOuOqHlwCq2XjftWie2va5pQELsJ1/lZccGgfNpAOtZE6+0VpjZxQIFr+WpMa5P0iGkb5dPGlU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 01:11:08PM -0700, Joshua Hahn wrote:
> On Thu, 14 Aug 2025 10:11:57 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> 
> > Enable show_mem for the cgroup oom case. We will have memory allocation 
> > information in such case for the machine.
> 
> Hi Pan,
> 
> Thank you for your patch! This makes sense to me. As for your concerns from the
> cover letter on whether this is too much information: personally I don't think
> so, but perhaps other developers will have different opinions?
> 
> I just have a few comments / nits.

Thanks for your comment, Joshua.

> 
> > Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> > ---
> >  mm/oom_kill.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 17650f0b516e..3ca224028396 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -465,8 +465,10 @@ static void dump_header(struct oom_control *oc)
> >  		pr_warn("COMPACTION is disabled!!!\n");
> >  
> >  	dump_stack();
> > -	if (is_memcg_oom(oc))
> > +	if (is_memcg_oom(oc)) {
> >  		mem_cgroup_print_oom_meminfo(oc->memcg);
> > +		show_mem();
> 
> Below, there is a direct call to __show_mem, which limits node and zone
> filtering. I am wondering whether it would make sense to also call __show_mem
> with the same arguments? show_mem() is just a wrapper around __show_mem with
> default parameters (i.e. not filtering out nodes, not filtering out
> zones).

The reason why I call show_mem here directly is because cgroup is not bound to 
a specific zone or node (correctly me if I am wrong). Thus I simply invoke 
show_mem to show system-wide memory info.

> 
> If you think this makes sense, we can even take it out of the if-else statement
> and call it unconditionally. But this is just my opinion, please feel free to
> keep the unfiltered call if you believe that fits better in here.
> 
> > +	}
> 
> NIT: Should this closing brace be on the same line as the following else
> statement, as per the kernel style guide [1]

Sorry for this. I will run checkpatch for my formal patch definitely

> 
> >  	else {
> >  		__show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask, gfp_zone(oc->gfp_mask));
> >  		if (should_dump_unreclaim_slab())
> > -- 
> > 2.47.3
> 
> Thanks again Pan, I hope you have a great day!
> Joshua
> 
> [1] https://docs.kernel.org/process/coding-style.html
> 
> Sent using hkml (https://github.com/sjp38/hackermail)

Sorry that I forgot to cc some maintainers so I added them in this reply.
Pan

