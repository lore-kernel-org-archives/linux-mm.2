Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3B9CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE2D8E0205; Fri, 15 Aug 2025 13:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6368E0001; Fri, 15 Aug 2025 13:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3298E0205; Fri, 15 Aug 2025 13:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC7A08E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:52:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 530AB827D0
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:52:24 +0000 (UTC)
X-FDA: 83779736208.05.258BE8E
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6AF068000E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:52:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d97EzrvY;
	spf=pass (imf02.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755280342; a=rsa-sha256;
	cv=none;
	b=zZze8WSqGX1etdW1U+iKD26eAtMqSXhXl/Llhb0fNetARC0bEVWOxrTMj8WEXg+3sZM8vv
	ZTcujW5pZz3N2e4e4aDFdWjQ17ixttuKJFm4b/9+8OFH6KE5p4wFibbjVBm5z5xaof4jlD
	cY8VybLgChkv4itZjNf2TAf8LkvYFWk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d97EzrvY;
	spf=pass (imf02.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755280342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeLYydUqAB1Me78TC6b0b3W5GfLHgduOhSo10MdwF/E=;
	b=yfkzdQCQGp0Zfm/Zv2BMPumW6flLLkl4wWwmJN6ltLc96zvGLeKQS3lQ+fwDybqAA7zAik
	6A/e7O2M/nXOIBpOBIVQ7CcenMeCVfc2crSF018DwGW2lpF2CmOgSWerHY8f6VlxltBUDI
	Jd9F3R35FMflWVhtun+Z9W2/A11LwMM=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b9e4140f38so286079f8f.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755280341; x=1755885141; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PeLYydUqAB1Me78TC6b0b3W5GfLHgduOhSo10MdwF/E=;
        b=d97EzrvYxtDD73p4dl68zjL4mFrNxtNCcms5tCL6VD5hSPz6X9IVQu23kBtsyv1I8+
         fZF38ubmKP3cGMPY8Lc0sdieEaI6sP/qGSPm32KOhB4lnLw8AyESeTRTSWUHMBy7FuIE
         0wKPDFbFbvrVftkY7XeXbJu809LLfZoWeXRlhnlk95pv8BXo5MZHU5e+KpBCT8adllMQ
         oWDOz/6R3bqYEjHzWQGl31MEeAeSCHDLrcnd/R5Xn41ZBU0DcaJ/SmuFmcrsT/JkntHO
         fb1WQ+M3jj0qLcHstVQdLe5kbyoArKZIJhn5s75WnqFNvoWSm7SdO0A8rZuj56u7irBR
         Zwug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755280341; x=1755885141;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PeLYydUqAB1Me78TC6b0b3W5GfLHgduOhSo10MdwF/E=;
        b=E7jWVtCZ0COL93NTtmWIoJmt1CdFvMnZaIXeuZk4vgZsdwnr8yUaQQgjwvYqJMqVQ+
         OngwNitgy6V52iqVkGQuNZ2M3Ar+KMEUhJ9ZVeisu6RkiuFjia/NWrwoFkPMUzz6gtTG
         ZcPtGbQlsTT9ruAs9JWPFGrBMxWQbfmWz5KJ3M8pyctG5s/ur5UM8SnvNS72lbr/tFTV
         rrSPgrtA2lyAHVt+mlMr/VJ9ThpGPdI/DWDmwGXrT7V5IbyDLS/kA1roBLXTHHeai1yd
         d9xD3hwWPwGwCO8+jO4UNNXlNO9Vx5qRyDZKwP6Y7w8llPWByVzB0HaurlQOaoB8lK4X
         07/g==
X-Gm-Message-State: AOJu0Yxw7wviqoNV/x1PrMrEGFNmCCbxmRsLHqD34l5wCSxz0vQO7zeO
	TzPrRDrQ7Z4GlQD5BY5aUSsEYNM3PX+xjghyzX5ud2buTqDXcsvz/Zeh
X-Gm-Gg: ASbGncsZanMZYIEP1L7rRS28vBahEHGlKsH69YwLmgtAaBYqNCapbm0vXLrwB8caqhK
	XlF6g15xsRN+J6tpNlFxZoT4iPayub7vvrYCfzHC8Y5yNk9tNBPe/2uELJ2lv6zY3C+9++o65Q0
	MURKMpuzKW4Jc3Ey0r3s3g7ZFcdkoOQ0Bth08KO0ZLDh3Ma5AUMthezLgHPk3v503xg6dm+jEv0
	VuBQS+z37s/lLwj8vAmIYXQ1XFVpHVhPTKxPd3gXSW/n20j9ju5Vp3Lo0nqiULEYnGYIqCNYJNN
	r6HdECYVJg4+HdDKXh7t873X2QsCbqHzZjriqWmCOymUr/P8GhTs+PGy49z17o6iuaXWU8vYOm+
	rlxUIfCmG35v/otqbnpiehulux1ykXVIA3kPcyEs=
X-Google-Smtp-Source: AGHT+IECJvL9RufSKMUKdNbqP8v17F33iVgawXkYJVWEkpD/pxEdd+DWdD3tgrQRmirh+2t6ySZCNA==
X-Received: by 2002:a5d:5f42:0:b0:3b7:8b61:2bb9 with SMTP id ffacd0b85a97d-3bb68a167e8mr954103f8f.8.1755280340615;
        Fri, 15 Aug 2025 10:52:20 -0700 (PDT)
Received: from [127.0.0.1] ([185.70.53.184])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a233257b7sm13256305e9.3.2025.08.15.10.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 10:52:20 -0700 (PDT)
Date: Fri, 15 Aug 2025 21:52:17 +0400
From: gio <giorgitchankvetadze1997@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, zhongjinji@honor.com
CC: linux-mm@kvack.org, mhocko@suse.com, rientjes@google.com,
 shakeel.butt@linux.dev, npache@redhat.com, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
 dvhart@infradead.org, dave@stgolabs.net, andrealmeid@igalia.com,
 liam.howlett@oracle.com, liulu.liu@honor.com, feng.han@honor.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_3/3=5D_mm/oom=5Fk?=
 =?US-ASCII?Q?ill=3A_Have_the_OOM_reaper_and?=
 =?US-ASCII?Q?_exit=5Fmmap=28=29_traverse_the_m?=
 =?US-ASCII?Q?aple_tree_in_opposite_orders?=
User-Agent: Thunderbird for Android
In-Reply-To: <20250814160914.7a4622ae1370092dde11c5f2@linux-foundation.org>
References: <20250814135555.17493-1-zhongjinji@honor.com> <20250814135555.17493-4-zhongjinji@honor.com> <20250814160914.7a4622ae1370092dde11c5f2@linux-foundation.org>
Message-ID: <1CAF2012-C9A4-44E1-BEB1-A1ECE0BC0C3E@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary=----OI3O6D1L05KWJSKQ8QZ9Y4YXUI62DW
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6AF068000E
X-Stat-Signature: g3r9h4cfkd6fhe5d8biepnwopzjueys7
X-Rspam-User: 
X-HE-Tag: 1755280342-909518
X-HE-Meta: U2FsdGVkX1+YJRX/jazrRPQpnKjOHF9jjIe0JnXSRm6cR3mW+Ws22UIFy+ftM3gtJDCmAtuJeLfzQGgs3NQxCGmAziLdNxwKY8sBgDuuKPqy6WXS5RAALpjKGKaiTCcCRDMvDShwL8e/PVWiNFKx+IWFiWPCUnmepkVVsKjl1xgOaAWcbaFZG5BcU0RU9cSawFE5cAYubXniKhz6/09Z/2GdMiZ3mmMoZNJATfOQn1ndk1qV4qJsmN0v8fEJIglMkU2KN1Ves5hScn6g25lC6qB0lEPojDKqNpkndZ8JG1cKD66b75UrWrEaKhkxnzM1Oj9ut8qaDgEOnsnoJq8G973pvlvwHBQIybzCOhbAG37Rqmj90rpDGQ7FNQsEcmqshNAoJRtgdGRxrzMZjvYQ3gjoeJwABJdqIJq4h10S07ZPEEbZVcBY7mWEfDDqiZCnUb5C/IA3vBJxHCUyXoL/ShZohPNFjM0Ka1/mt9Y4faSIy+JuXZ4cVOaHqDGZRk3TrE2QiulhmgPUnrEd5iXQzetDdTAMyBuxmSpF6n6MPXC+zLn6D+lTEBr+wn9pRnWc+dA2nXozz6vbzdfJJ8938TxPCkw4JsEbZSADfioj5aEKYxw8zOPJk0MxnCBE+KGfgNIhkeev/3qEiELiiyhGEGg2TKpuC67t3IOqHaW5xYYf2a1eCIyZ25cXXzJkAGYKmIi0zfF/8eYHTMpZWzA1JqH7b3jh0mRMRnBiEZaAsTYs5R9KhetJTGpQCpxb9wchjo2x0bcfBgjaYoifJ5ljfu3d6TQYOUG2B3ZwKh/OQ/qWHVYR+kw6vys1rxlZkxQ+fDGd9WU50QG7x0wgz93s+dOpsUMFh0PPxTq3nwPT5/tX3PucWhjSEkYbGmz3gPUFPAWJifthM232al2b8BM+mj3HBT2DBQoQdXE6lT4hTCWiVoSpaoOlP7+ZqggIJQUtbk/PWeUHC2ogkiM+Zrh
 Ck+H+7/M
 x+Qe+tmjS4ToQrWol2Ytr8R4bZ4GVuB9gp807n+hIVAXM7oHMyrhIyIR2pjfu7KqAuKBzu9t9ZdywdAn5LDqnP27WpsyOMFZgeZfEO4u4bjbktUojJP8Fn2fSoSJog0ahIHdJxa7yw4lYP7o4iv8ARXp/c3UBh5dFOo2jlWPeqkgv1CT83czrzZFUq03rn44JI09gQK54gO2p93N3E5Qp2uU4vn5lDIb9Pb/hLH+j78MQRSNz1PCVItWgyoe+/L2HTv4a1CxIPbEOVdMcJ/44cU67ZL1DjesjRmh3Rw8tnzYD/ISBvupLUAwpKdA0p5FB/ORYA/0Xfa7Ed4aQ8ofh3EqxvG3EmwV9nfCQqItQSuKCatDZNu10x5Wvn5wkayxHXte275XUJUjqg5HGC/R6rGaJIGMm5zTEIQI4bxsRZppiAafsN+6oZmTs6FwukqD98c/vVe2Hii7vJxp567X9OgGzSWffczwR81BU2re3J/CfQdDfzWOxaIx588VeC6perz9lAjn+m9JVFvZ3F0lFdaB5EVF9dBQomZATHuUSJlMXG1XNTJaZ2YtkZxo6LTrWQc8dNeoa/FpdgLo1BdQfpN9sUwfLOgS6im4eLaKapH6E7qQ/gA+rYcYdNwUWOD5BJF/sXo2vJiVoYRL+3NSGAaIV4OfmesAVTbUVdW6rqTq/vkVkSXr6FUMiTad5zWZc0pPtNsDimhIiHsgvm5ZFJyhPvEa6zxUtxuuJuHBQWrGOZsjXtiP90nmUAf8gpUBylrkeu5nMLy7qy0CQVncBJxH2wOsHet/D9QhQ5+W0z/ysIORUZO8fovRODPI0i6cJxTzbIGrqK8hrPlqZ2NL15kw6XQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------OI3O6D1L05KWJSKQ8QZ9Y4YXUI62DW
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

I believe the patch should be accepted=2E While the race condition might be=
 rare in simple workloads, it can become significant in containerized syste=
ms or Android devices=2E The proposed solution is simple, low-risk, and dir=
ectly addresses the identified problem with minimal code changes=2E

On August 15, 2025 3:09:14 AM GMT+04:00, Andrew Morton <akpm@linux-foundat=
ion=2Eorg> wrote:
>On Thu, 14 Aug 2025 21:55:55 +0800 <zhongjinji@honor=2Ecom> wrote:
>
>> When a process is OOM killed, if the OOM reaper and the thread running
>> exit_mmap() execute at the same time, both will traverse the vma's mapl=
e
>> tree along the same path=2E They may easily unmap the same vma, causing=
 them
>> to compete for the pte spinlock=2E This increases unnecessary load, cau=
sing
>> the execution time of the OOM reaper and the thread running exit_mmap()=
 to
>> increase=2E
>
>Please tell me what I'm missing here=2E
>
>OOM kills are a rare event=2E  And this race sounds like it will rarely
>occur even if an oom-killing is happening=2E  And the delay will be
>relatively short=2E
>
>If I'm correct then we're addressing rare*rare*small, so why bother?
>
>> When a process exits, exit_mmap() traverses the vma's maple tree from l=
ow to high
>> address=2E To reduce the chance of unmapping the same vma simultaneousl=
y,
>> the OOM reaper should traverse vma's tree from high to low address=2E T=
his reduces
>> lock contention when unmapping the same vma=2E
>
>Sharing some before-and-after runtime measurements would be useful=2E  Or
>at least, detailed anecdotes=2E
>
>

------OI3O6D1L05KWJSKQ8QZ9Y4YXUI62DW
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div dir=3D"auto">I believe the patch should be ac=
cepted=2E While the race condition might be rare in simple workloads, it ca=
n become significant in containerized systems or Android devices=2E The pro=
posed solution is simple, low-risk, and directly addresses the identified p=
roblem with minimal code changes=2E</div><br><br><div class=3D"gmail_quote"=
><div dir=3D"auto">On August 15, 2025 3:09:14 AM GMT+04:00, Andrew Morton &=
lt;akpm@linux-foundation=2Eorg&gt; wrote:</div><blockquote class=3D"gmail_q=
uote" style=3D"margin: 0pt 0pt 0pt 0=2E8ex; border-left: 1px solid rgb(204,=
 204, 204); padding-left: 1ex;">
<pre class=3D"k9mail"><div dir=3D"auto">On Thu, 14 Aug 2025 21:55:55 +0800=
 &lt;zhongjinji@honor=2Ecom&gt; wrote:<br><br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #72=
9fcf; padding-left: 1ex;"><div dir=3D"auto">When a process is OOM killed, i=
f the OOM reaper and the thread running<br>exit_mmap() execute at the same =
time, both will traverse the vma's maple<br>tree along the same path=2E The=
y may easily unmap the same vma, causing them<br>to compete for the pte spi=
nlock=2E This increases unnecessary load, causing<br>the execution time of =
the OOM reaper and the thread running exit_mmap() to<br>increase=2E<br></di=
v></blockquote><div dir=3D"auto"><br>Please tell me what I'm missing here=
=2E<br><br>OOM kills are a rare event=2E  And this race sounds like it will=
 rarely<br>occur even if an oom-killing is happening=2E  And the delay will=
 be<br>relatively short=2E<br><br>If I'm correct then we're addressing rare=
*rare*small, so why bother?<br><br></div><blockquote class=3D"gmail_quote" =
style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #729fcf; paddi=
ng-left: 1ex;"><div dir=3D"auto">When a process exits, exit_mmap() traverse=
s the vma's maple tree from low to high<br>address=2E To reduce the chance =
of unmapping the same vma simultaneously,<br>the OOM reaper should traverse=
 vma's tree from high to low address=2E This reduces<br>lock contention whe=
n unmapping the same vma=2E<br></div></blockquote><div dir=3D"auto"><br>Sha=
ring some before-and-after runtime measurements would be useful=2E  Or<br>a=
t least, detailed anecdotes=2E<br><br><br></div></pre></blockquote></div></=
body></html>
------OI3O6D1L05KWJSKQ8QZ9Y4YXUI62DW--

