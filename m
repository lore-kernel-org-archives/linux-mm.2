Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA3610A88FD
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B5C6B0088; Thu, 26 Mar 2026 14:16:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BF46B0089; Thu, 26 Mar 2026 14:16:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B486B008A; Thu, 26 Mar 2026 14:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F26136B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:16:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A040AC3F18
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:16:17 +0000 (UTC)
X-FDA: 84589018794.12.3A2735F
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8263BA0019
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:16:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oxBD2ZZd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774548975; a=rsa-sha256;
	cv=none;
	b=48aPIZPxJBcvapgdOZxnYtISM8cA/g1sFMxWGweR5P+Cim6lx4ojiyagbNEdliTvzdJYOW
	QayMDKvCYqiTcm6zK2DZlMmpU/hrcnsEOeVcPVYW45U5p2tpDgsMVne7g+soCrzJ925tVj
	VIE1nhoiuAPLtNA7Z127rXuDPk7YJkc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oxBD2ZZd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774548975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSyPhh3HmO6if4yslTgb3vQtjUM5HB1Rw12+bAg9VZI=;
	b=NEe2Y47DjmrGYI4lgn0E4FAXP7SKXFfLbL71ajxhg3JcwCJyxWsMUrM6aULBLMHFTJtfe7
	LAdjrYGwU7C4l3GdjBULZk58WvP/ifEQ69Ghu79B6hRXNz53l3FHnNEVcjQsJX8M6bJQDw
	5RxPrWOsvyWJfYUeYSrrJ9bodS2f8Bw=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a2a5236811so632599e87.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774548974; x=1775153774; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TSyPhh3HmO6if4yslTgb3vQtjUM5HB1Rw12+bAg9VZI=;
        b=oxBD2ZZdYFjubBbqWvxkd6bF/lftety6hNtvYZvY8EGBT59zBmNgHdzpalnTlFdJsa
         bnyQ/HTG7zxs58SdlZkN4pov6soNcjWl5GwUNsbI9tcIqtasSkOhwvqqohZm8D72I/e8
         WraJcie/vOPDk7MUOkf3hZ6g5RM6RknNCEPFK4NbU/+Xv+W5nRB/fvEdMDtL+hI5A2gU
         Ouu8COpXKz0QEToa2MLcK2HYTM7EOs5KaRGY79p9yIdDBDKayEuGHrmul2r33h7FFfsc
         1Bbfs3Y3Wj5kJkUUbFMRnRT2xPPMU5PyzUnjf8kYKAl636DpsJHRb4m4ziH5TRJuK0kt
         ECnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774548974; x=1775153774;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TSyPhh3HmO6if4yslTgb3vQtjUM5HB1Rw12+bAg9VZI=;
        b=mhX0EWdCH51mqlcmdnKcPA2EUUdimW4siOLjhUqWZSUP8exIMqu7RoLLDVzcaDYORn
         k1PMZWyVHpM/ar+Pa/KccWDW2FhhhxwKcwoUwqyXQQQ4F44o76Psuti96TWnC9FfbUp7
         1jfuRAnRSsTam7L2GZ0jm5vwP1KeEgPoWD778+d2Ty8mUk6OpA+n393fh4VVBE6dg48s
         /Qp7bLTo1m9GgrDSh2xIauLb4D6ATSW4BJ/r/Ns+Kv6yLkN2X1I4YuCvNthmfKmT8tBP
         uuMyOi4nfNwxsR7K7SEwgt0y7C+QV4uA6VSb+otiFb7FCzkM6ZvkmO78s3SECxTopyzU
         pzgg==
X-Forwarded-Encrypted: i=1; AJvYcCU62yylHQm8t3C6cYrR5ZmYMzIvA5XxqMkyxOdTw9cPdfTa73HRmlmeppVLGfFrdQz7zSznO3lwCw==@kvack.org
X-Gm-Message-State: AOJu0Yzr9XD/CrK8PNsRwDtlKrp1dq5bEJ2A83hPrd2CoZukJtWDSPtp
	4pLDlwpl3JEOxWg47BzvXGsyvba7kHCu7NyBUy1VhUQGJASpha9KuimL
X-Gm-Gg: ATEYQzwY/NYkxx9YtmmfzhyrlrrbbsjsFk8D6GTEmMhCe3cpSrO73aGMfMTFpvVxI8l
	PocNWKzJp08KMpAfHXPCdc+IoIKRTzEHtXbXuFY3s+SpnvavrSBsREjWUbWNsRIHJjk31bVtOuJ
	GulyyZw5bl7a5QYFnHPle1/Pzczvm44gISvCDgiJs66WwHReQpDGO5wX7ctY4oMxc2SdosWU7oV
	UIm9PMZY6O9baaWqHxyHoiFZYg6eEiNYmV5NUHkF2DNwaDhVgtgKommDV3e78Jh9SSZMHfmO6jq
	+Xrh1dQht7iwIhzkIoUG3RFyuuLkuur8OHjJZV+RhLVJ+0rAZ3flQYrL9RnbNV0m5U60X3swijQ
	Z+BsZzggahs+llfM9d5g163zLwsg91pjLPvBcYGxLMYcwWFuE/z+mR4WeYuHm88Yw
X-Received: by 2002:a05:6512:31d2:b0:5a2:874e:8a1e with SMTP id 2adb3069b0e04-5a29b98f370mr3614846e87.26.1774548973140;
        Thu, 26 Mar 2026 11:16:13 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2a068f8a3sm757853e87.63.2026.03.26.11.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 11:16:12 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 26 Mar 2026 19:16:10 +0100
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>
Cc: Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org, kasan-dev@googlegroups.com,
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>, ryan.roberts@arm.com
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
Message-ID: <acV36oPNFMgL4puz@milan>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <afe9ba0a-1924-42a8-a9c5-34eec709f883@arm.com>
 <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org>
X-Stat-Signature: spm5d8onj4u6g37u7tszx35g684eiazo
X-Rspamd-Queue-Id: 8263BA0019
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774548975-600240
X-HE-Meta: U2FsdGVkX1+XyMxo5gPGwhYpNrmKDffFuXxOQ1OYKkxUKLC9GiiNeWjRLRLt4DGPW/MXEBT0uALjgHixc4h4mX4+ucWf1Z1LTvRLvAtG24RULQH/3WGRK6BNKVdgX74yUPqTzjhTcRDigtKY2H0hN5Blv3qR8c2VcH6qcDPYRzE0gyp6u+5OHACPQeYkETJKg5YUA8ja+/Gj8ZP1kSJ+s0+vNGfUvZF9qz8/WzbhBBeuOGpsrcuxU+h9ri1vKOjToiNLG1vsskjGNFJaZE7UYfLzGuJWNlJnYPLcUU3YTClpU+u2w9U8L5K3TR1UhN8UKRwjHh2HyFcxSHJQdKFVFV4MPymtPjg8m7ltGa0RGS2wdnG5ur03HI+NKo1XoiU26motOEtpKkVVKtMQwmqI8SVToBdNLz6RiY7wRm5YHfR7W+aBo7dv5JBt3TSgYi72Jsnlx87HgSInXYxNqKNMm+EMDKAHXCbt07AHhZ8BKiy3BqpbJN6bc4X5Q3xJvmSbkqOfdeInpzZW77QMxW0NfcRvj6c8N3r1qoubn1r8Tq7RCwB46M7ccQcTdV3Pd4gJ8pxELlnlbqnrhsZ+Xb4tgxh4VVAEzqAvJ6iQL3c71drUHxcZD4YHBbnN/O5OoMXJyF67eZPNdo8UkKz3bwQF1Ifwpxi6k563uBLXlAARwGw9mmRUu5Hzmf3i0T/nqGaclukZeatfvQ8bMRf3w82QPdIQDyVkeliXQo2sjIvQb86HMz4DXPwS2GDQQKBpgBWQ3pMo4CJRkzEhGFFK5Q/prmGRLffty23Yg5/FfbX8cCQmO2+tfeSqjd5+HUgIcsWQmoqmSFKWFzJmxiIV2oSMrL82tk7I/Ic7blIDfqJ44+MmFFLPDlLTVgBssK5uVdVuzkK48faIWGXMf1dkLfrv6dRwNP2S2u5tnAj1hI4SzRADIkG5UlBgJmp5YQMzudzWnxbgyHbN+qnOmMibYBa
 FJWBepNr
 lsntRDn89P4l4Yd7fAUvdLgQrXfHOsgC9Uu7vOPp/3mNj5xzgpDRduJXpEIW4/Cvq9WJMFsvxHO2hmZXB7Eny+NebN5wX3BU3+1a3bXEzYmU2IUBQeFYL6HfS+GCGKutLTpEwJfvJKjyx0QGVWf+y7hWIVhmSqIAKfakRj9pBkJu7EAxG6ojNpIzueTdxmziakm+f1MnuyfOhWMIQKcaJkdaEwejWtp6O6UiDUqHr6BtPSXIyAmbKOqW4hxphcicsmg1CryO+4H6xoPV88sSvZkGCQk8e66cbeEMw+mqe0MH1nyw4ImG7LNyHlyNcTvxSjNEw1jKjyXeZaSAeNDE0WMvZz+mgC57RmaMw6oWV95oMn2nM9y2qpkeKFJfUt3jEjeGk8DUkfU2yxn224tieCtAIK2A7qkRosZATHRCXztrxGPVOVUWwDDa9MeLWVpDNE23dvcBz8cVbgJDWjDsO0+pAXbxWqaIedL2Nep2zfD3tIosvjks83Hnrqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:42:02PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/26/26 13:43, Aishwarya Rambhadran wrote:
> > Hi Vlastimil, Harry,
> 
> Hi!
> 
> > We have observed few kernel performance benchmark regressions,
> > mainly in perf & vmalloc workloads, when comparing v6.19 mainline
> > kernel results against later releases in the v7.0 cycle.
> > Independent bisections on different machines consistently point
> > to commits within the slab percpu sheaves series. However, towards
> > the end of the bisection, the signal becomes less clear, so it's
> > not yet certain which specific commit within the series is the
> > root cause.
> > 
> > The workloads were triggered on AWS Graviton3 (arm64) & AWS Intel
> > Sapphire Rapids (x86_64) systems in which the regressions are
> > reproducible across different kernel release candidates.
> > (R)/(I) mean statistically significant regression/improvement,
> > where "statistically significant" means the 95% confidence
> > intervals do not overlap”.
> > 
> > Below given are the performance benchmark results generated by
> > Fastpath Tool, for different kernel -rc versions relative to the
> > base version v6.19, executed on the mentioned SUTs. The perf/
> > syscall benchmarks (execve/fork) regress consistently by ~6–11% on
> > both arm64 and x86_64 across v7.0-rc1 to rc5, while vmalloc
> > workloads show smaller but stable regressions (~2–10%), particularly
> > in kvfree_rcu paths.
> > 
> > Regressions on AWS Intel Sapphire Rapids (x86_64) :
> 
> The table formatting is broken for me, can you resend it please? Maybe a
> .txt attachment would work better.
> 
> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> > | Benchmark       | Result Class            |   6-19-0 (base) |  
> >   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |  
> >   7-0-0-rc4 |   7-0-0-rc5 |
> > +=================+==========================================================+=================+=============+=============+===========================+=============+=============+=============+
> > | micromm/vmalloc | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 
> > (usec) |       262605.17 |      -4.94% |      -7.48% |             (R) 
> > -8.11% |      -4.51% |      -6.23% |      -3.47% |
> > |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 
> > (usec) |       253198.67 |      -7.56% | (R) -10.57% |            (R) 
> > -10.13% |  (R) -7.07% |      -6.37% |      -6.55% |
> > |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)           
> >   |       197904.67 |      -2.07% |      -3.38% |             -2.07% |  
> >      -2.97% |  (R) -4.30% |      -3.39% |
> > |                 | random_size_align_alloc_test: p:1, h:0, l:500000 
> > (usec)  |      1707089.83 |      -2.63% |  (R) -3.69% |               
> > (R) -3.25% |  (R) -2.87% |      -2.22% |  (R) -3.63% |
> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> > | perf/syscall    | execve (ops/sec)            |         1202.92 |  (R) 
> > -7.15% |  (R) -7.05% |         (R) -7.03% |  (R) -7.93% |  (R) -6.51% |  
> > (R) -7.36% |
> > |                 | fork (ops/sec)            |          996.00 |  (R) 
> > -9.00% | (R) -10.27% |         (R) -9.92% | (R) -11.19% | (R) -10.69% | 
> > (R) -10.28% |
> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> > 
> > Regressions on AWS Graviton3 (arm64) :
> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> > | Benchmark       | Result Class            |   6-19-0 (base) |  
> >   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |  
> >   7-0-0-rc4 |   7-0-0-rc5 |
> > +=================+==========================================================+=================+=============+=============+===========================+=============+=============+=============+
> > | micromm/vmalloc | fix_size_alloc_test: p:1, h:0, l:500000 (usec)      
> >       |       320101.50 |  (R) -4.72% |  (R) -3.81% |               (R) 
> > -5.05% |      -3.06% |      -3.16% |  (R) -3.91% |
> > |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)      
> >       |       522072.83 |  (R) -2.15% |      -1.25% |               (R) 
> > -2.16% |  (R) -2.13% |      -2.10% |      -1.82% |
> > |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)      
> >      |      1041640.33 |      -0.50% |  (R) -2.04% |                 
> > -1.43% |      -0.69% |      -1.78% |  (R) -2.03% |
> > |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)    
> >       |      2255794.00 |      -1.51% |  (R) -2.24% |             (R) 
> > -2.33% |      -1.14% |      -0.94% |      -1.60% |
> > |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 
> > (usec) |       343543.83 |  (R) -4.50% |  (R) -3.54% |             (R) 
> > -5.00% |  (R) -4.88% |  (R) -4.01% |  (R) -5.54% |
> > |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 
> > (usec) |       342290.33 |  (R) -5.15% |  (R) -3.24% |             (R) 
> > -3.76% |  (R) -5.37% |  (R) -3.74% |  (R) -5.51% |
> > |                 | random_size_align_alloc_test: p:1, h:0, l:500000 
> > (usec)  |      1209666.83 |      -2.43% |      -2.09% |                 
> >    -1.19% |  (R) -4.39% |      -1.81% |      -3.15% |
> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> > | perf/syscall    | execve (ops/sec)            |         1219.58 |      
> >         |  (R) -8.12% |         (R) -7.37% |  (R) -7.60% |  (R) -7.86% 
> > |  (R) -7.71% |
> > |                 | fork (ops/sec)            |          863.67 |        
> >       |  (R) -7.24% |         (R) -7.07% |  (R) -6.42% |  (R) -6.93% |  
> > (R) -6.55% |
> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> > 
> > 
> > The details of latest bisections that were carried out for the above
> > listed regressions, are given below :
> > -Graviton3 (arm64)
> >   good: v6.19 (05f7e89ab973)
> >   bad:  v7.0-rc2 (11439c4635ed)
> >   workload: perf/syscall (execve)
> >   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
> >   kmalloc_nolock()/kfree_nolock()”)
> > 
> > -Sapphire Rapids (x86_64)
> >   good: v6.19 (05f7e89ab973)
> >   bad:  v7.0-rc3 (1f318b96cc84)
> >   workload: perf/syscall (fork)
> >   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
> >   kmalloc_nolock()/kfree_nolock()”)
> > 
> > -Graviton3 (arm64)
> >   good: v6.19 (05f7e89ab973)
> >   bad:  v7.0-rc3 (1f318b96cc84)
> >   workload: perf/syscall (execve)
> >   bisected to: f3421f8d154c (“slab: introduce percpu sheaves bootstrap”)
> 
> Yeah none of these are likely to introduce the regression.
> We've seen other reports from e.g. lkp pointing to later commits that remove
> the cpu (partial) slabs. The theory is that on benchmarks that stress vma
> and maple node caches (fork and execve are likely those), the introduction
> of sheaves in 6.18 (for those caches only) resulted in ~doubled percpu
> caching capacity (and likely associated performance increase) - by sheaves
> backed by cpu (partial) slabs,. Removing the latter then looks like a
> regression in isolation in the 7.0 series.
> 
> A regression of vmalloc related to kvfree_rcu might be new. Although if it's
> kvfree_rcu() of vmalloc'd objects, it would be weird. More likely they are
> kvmalloc'd but small enough to be actually kmalloc'd? What are the details
> of that test?
> 
static int
kvfree_rcu_2_arg_vmalloc_test(void)
{
	struct test_kvfree_rcu *p;
	int i;

	for (i = 0; i < test_loop_count; i++) {
		p = vmalloc(1 * PAGE_SIZE);
		if (!p)
			return -1;

		p->array[0] = 'a';
		kvfree_rcu(p, rcu);
	}

	return 0;
}

static bool kfree_rcu_sheaf(void *obj)
{
	struct kmem_cache *s;
	struct slab *slab;

	if (is_vmalloc_addr(obj))
		return false;

	slab = virt_to_slab(obj);
	if (unlikely(!slab))
		return false;

	s = slab->slab_cache;
	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
		return __kfree_rcu_sheaf(s, obj);

	return false;
}

it does not go via sheaf since it is a vmalloc address.

--
Uladzislau Rezki

