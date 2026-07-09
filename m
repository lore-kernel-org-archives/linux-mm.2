Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048A1C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC05F6B0005; Thu,  9 Jul 2026 13:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98146B0088; Thu,  9 Jul 2026 13:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89116B008A; Thu,  9 Jul 2026 13:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B35516B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:32:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BFFF168BB0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:32:25 +0000 (UTC)
X-FDA: 84969932250.28.B409439
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8808A80007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:32:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tSEvYTYw;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iygNm+vh0afSLVE9tfBUkC6Dh/o/QFksTzffYOLwxY=;
	b=xjaSOWZTTiQeDpwcOOQqi2gsu22b4bNra26+98Dbuk/YXll72PAnsBhGoN1xV8728wLEBk
	fbPS8xZiVMaX/sX2XJ61aFWiKeb7YnMOhYaRhbcv3H7YsRfXeYbNbwk/OFiBhn3zSr3Nxy
	NQazgGIRIfYdG0QyjJq1q1d8rX+ufds=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tSEvYTYw;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618343;
	b=8EXZIEf7cKQXW0wsnAkx/MEypXYteBdjmWETn1B/BMuHAvV3xW/YdqkjQvyjIHMtQ3MFsG
	pENU3MpbCXnXm2Do2paqQodhiEjs1g3GjEB/vh4tWnEbLHb0Pom3+O/3PTAngn2XFBN0Af
	znO3Hzj2ZUOIpIn7mjtMauXwg+PZYr8=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e7c6ec9dbso1850585a.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 10:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783618342; x=1784223142; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+iygNm+vh0afSLVE9tfBUkC6Dh/o/QFksTzffYOLwxY=;
        b=tSEvYTYw9jSThXjaABAIM9/kjFjfQMqgLH9RUUTYAzi2v545O7moQlPWyH19LRbBuz
         BVV3prXxhKTotRj/L63z/Pup7pIWJ5ZrzM2yRBvf0rOm4492cJS7Uq9u7fTxTLvQFOiE
         v2nkDd+a513wT+u7WkekKIaknn17gjKRCNZEQ273XCTgVkNvjmQ+1cXcrev1ubk28ZcK
         kQP1MJk07TuUVlSx6FC4zZ6PNP0H/HskbsrHoWFOlsoR0m7CNaMIyEPEjRVt35xQQkex
         IR1EY0LE1LeFuOfsIFDBPjRtV70en8KEk03GwYPBIfULdaWnaDeIGiThi9u04iGlCDPA
         HG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783618342; x=1784223142;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+iygNm+vh0afSLVE9tfBUkC6Dh/o/QFksTzffYOLwxY=;
        b=WMJVOmPHcZ33rThOyOFnOk3fJS8I51W4edVnCdtdoZ8K9qvl1BFoxZp3ODfL5dn+AQ
         VDQikU7BlDX6rCII/vL5z3KROS5r1XZW5I/SZ/lPICAQ0HYg4hDAJYNDeObkNC7nUD/S
         h/3tZLygBc6oCP/NRk/EZdwoXcrICgm/W9J6hiDbOIkgG454Z4YNWifQmLDw3WFYYzcB
         zBbGsWq0dFFJgKmk9p6X7kyj1h26ixEGLsjeFz5sdH6jU5jyL4f28jS83uj7fNsqUpO+
         lXvLAayuoD/3VlJhqSLOm499tuoe8K5x9g6BniK+LgdUJL2fWcl0YswtAo2k3X1/l2X9
         1I6Q==
X-Gm-Message-State: AOJu0YwjJNB8kmuhlCbuwHeZDRko/wM3scVAO92moV7+CwsaoLUSqMDm
	lH2/VqsyV6rGrsaZVY5tKg4ahj5MC7nOsf8JsOAyeJyfZ8nMZ2oFfP8vl09THtLWUhI=
X-Gm-Gg: AfdE7ckOCjy7POkvhwCymXokPHA+Abnvllw17TNDR2bex5f622GOLp+4LTfFjaZPZGd
	eHg31lxTrYSVO0wAk1PkJAJSC2dTnGFeSwhxenvFdpDOszFV/S78G0+wMHjk3QtfhxT7WEYu6+6
	lhYgLbfzj52NZr4YmcxIB2kFd5tNq652/7VkQDOMa0nnocYEH4elTAzNcy3yUswOMSckQPszFbT
	3q8gSQ1mVyTyuyKCumTo4g8Y3RIFaCS7C/1PbM90DL7m/LrEEA8APHnxFL3DAWbdXVZvb1jIEe+
	P/89UI/1ltCYm/oMZ/FRHQNO0j9SpBybvVbiEZPr+OfnbhkYktc+s33L/rbeR3xX6uhRMUgtjLd
	AKTrNk3RviMT8g6zRpz87LZ8ZUCK4ZdmrVc7+k4n9D/rfQA5NN0j/Bq3a/CePJuITDQWQUjil2q
	OdchyaY6pYgKvE5Np6wwsnGt++ZKodhsblK4Or9yIqHCzwutG4uV5+eKkjjRkLhUzgJWej
X-Received: by 2002:a05:620a:890b:b0:92e:7c3e:26fe with SMTP id af79cd13be357-92ecf67b0f3mr805067985a.64.1783618342643;
        Thu, 09 Jul 2026 10:32:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90bb91adsm1705974285a.20.2026.07.09.10.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 10:32:22 -0700 (PDT)
Date: Thu, 9 Jul 2026 13:32:18 -0400
From: Gregory Price <gourry@gourry.net>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org,
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	apopple@nvidia.com, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/2] mm: don't apply task mempolicy to unmovable kernel
 allocations
Message-ID: <ak_bIlYWJsEWx1P1@gourry-fedora-PF4VCD3F>
References: <20260701222112.2820098-1-gourry@gourry.net>
 <87echco1w6.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87echco1w6.fsf@DESKTOP-5N7EMDA>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8808A80007
X-Stat-Signature: ktkphbasztgm3h6adgupkqp73bsbzksg
X-HE-Tag: 1783618343-371980
X-HE-Meta: U2FsdGVkX19+5RaCNXS+AcY4lIX0iZJGCTN9KJ332APS+GzAoC3z07EiHky4G7F1FxTknX/13YLqs8MYrgdx/Y6LhqPuMbYNWOy+anhjyJJR6qFYWU8enPUCymTCJu6hj4CYgo1ZHW/SxSsZZDVQDyMoaOr012ntEYpqSNdhoEBa/8BfBuHj0M/kjnx9T6IyjPRkRnqGvl6b4SLlL6ke4gDDiPExaHh3MbCFxQHkN3LPcmcrrWzVPiq4gSp4mGgrM9C3oDwP651JAlwB8GeQqAiqUpppgNGPpuoh9VE/1mTT4Ts7Jj5GWqkzASgX//35A/NnZdHkgkIItPYI4zjNn0rVIUwyzm0VUYgn95EX3zkM+O9GcbPy82cCv68GdpO7qEspIoh59yFfyQwTPtWvTyTNs5/CQgmXgmjScBvPiPksHP/8IEdPC5oXr+i2UfXOqR/FqU6o8Q2QLBNQtRkDt2xamniiFKDu7oztyes96f1zJC2dv4x8I2FU/6NL4ANRPoUsLJQMls8obTKHt02eXDXd48f5nO1gjSY6cPoo+7849TFkRdoFmcXK40G9JnruKzQyDmMD0ZeOewB8E5H3b3Vh0C4Nfw8zfWkrUkKru6VdzTlDbQ2Lcf5tY/bM4O9cmt8+Pb951dgGVh/HL7JJg8IcN4JTUyA6o3awKg6Z02x4llAYtmWZ8c3rdMCqzX7rYY7p3FoNTGl2m3dJ9ISrE/3kA54iY9bj5qL2Fere3JEnNuOE91J020aEtWeLTbh350YvTDKSMMHYmGbNiBjpJdekCBglQCv9OpYfUJf6ni0U+7deKbJfmhS6f1YfOiw7AtPPjjwPJTN83BHqaNxU++sJvJupoEdxU2z4Ug3GZX8P6+69nWQgzzT6pA6rxlL+hlFv2lE3QMxn6mHqR7/GerrPmsI8k8OW4h7AaI1CdgBkNcygHp4K1yZaJtK+WUll6g8MQCi5AGyqqQI/1lN
 nclltJBP
 02NomAguc6rKHTCow8el9Thu7DX8ASwMXidkojnjItdQhltAm+IOj22Pm3nScpNu2JdcxH4Q9+mUVPQORdVxuH4GQqDj+wVL4CjfhrvUFIV5nSspOjh9zLiLu/fJ4Ub4dDibbJlXql8P17mqRU/gZ5Im96thLn26dFupyQlJ+papyKcN0Nrn7UDFfQ/+n1xQ6IAqQarWVZEguICg9+9i61XCHSfEskg7WqVX543mI1Vz6sFM41GjLZhgGi76vpXRQWCef+L/CYQuf6HRMOM7WyLw4IEvzaEl8LqKqY2vaNKSm6SEfDdKpr5M7unFleGfPMzk6uuDVDfoz2CzMIqunBFury+sELgGmfURTT6yGmdc07fb/kvQ6owjcFlwNHKiqQx2jBMEVxiwS6NPicciDWpsqY4cuy6rgku4Z7c4OClNMhlvwDVcu9N9a7/y48fSWa+9AdnQePs++aGVX9Vt5KYv7Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 07:09:29PM +0800, Huang, Ying wrote:
> Gregory Price <gourry@gourry.net> writes:
> 
> > The unmovable unaccounted kernel allocations stop following the
> > task policy and place node-local. With no policy set, both place
> > node-local as before.
> 
> Personally, I think this should be the right thing to do theoretically.
> However, you may need to find some practical issues that this resolves.
> 

I don't entirely disagree, but there is at least one scenario where this
is an obvious improvement:

  BIOS-configured CXL memory brought up in ZONE_NORMAL. 

An task interleave policy on such a system will end up with unaccounted
kernel allocations landing on the remote node, which is just not
preferable at all (and uncorrectable).

It's not a complete fix (fallbacks can still occur under pressure), but
it's one piece of the puzzle.


Forward looking:  This patch makes private-node's with ZONE_NORMAL
reliably hot-un-pluggable.  But that improvement is obviously predicated
on work that isn't upstream (yet :] ).

I need to send a v2 of this with SLAB_ACCOUNT fixed up, and some numbers
to justify dropping the pagecache fix.  But I will probably sandbag this
a bit until i finally send out v5 of private nodes.

~Gregory

