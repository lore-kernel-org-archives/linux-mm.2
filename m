Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2548DC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217406B0092; Mon, 24 Aug 2026 11:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7DA6B0095; Mon, 24 Aug 2026 11:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5B06B0096; Mon, 24 Aug 2026 11:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D328B6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:09:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F2721A01AB
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:09:59 +0000 (UTC)
X-FDA: 85136498118.22.08D60E3
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7EDABC0006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:09:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="U3/V77SJ";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787584197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6j7WBdzhGUFGnvNUS2cIrQrd4SkMPF+Ufhv82BZDwo=;
	b=7k39JbPt6JDuRv+BvHzV3rnsT8WE17z0rN1nR4uEt41APGZ3sF9kLMPYYd6MMKb4MjGxDY
	xds/t6HjQmXCFFYCMt2xAjjNInqGe9tJ7SVODvgTUeo0Me+DzriAD4J1MaHtqcI/sdevmV
	nz7BWnyUiNE6rXb7b3M5UnMila7nnmE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="U3/V77SJ";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787584197;
	b=mudhpAeEl8JGwR/CAqSV3NjFaWwqb/eRxLKeEMdiR1Olwq2GMuNAEW2qr7cXPUL5psTy+F
	ygXnDOehAw4usoTIxU27704/B9wKS4bod0JMeBK2qYbzpcgGy5LflzQHayjO9npZfrrnRU
	nwfiXU0GgdVYcRTSTLHrJxjJvXDAuw4=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8efb708b1a0so21913006d6.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787584196; x=1788188996; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k6j7WBdzhGUFGnvNUS2cIrQrd4SkMPF+Ufhv82BZDwo=;
        b=U3/V77SJkbGl00EHdhZR3wJtHi4Ubz94lSR47yfU75kHBR3NjfaOYxqeDKRex5GtqN
         y5aW896jKXZvxJ8puXS61Tcy+Kix4cGRz4qqKFWa3ijkslMTVWfWsOpn33HgqGRhIVQw
         g+rInKOLJJ1ERo2FFaeScxidRB2GigyFSkQZzSTOSujiZ4TU50DQQjwnWjkhc9yW3Aqw
         6ekoqVAHyuEJ7wdHY2pIq7bwK9N8Y59kGAufpMS2TOTT/2lZxUq+LAPA3QFqOfn68km9
         /oz1ROkwoMwhp4Ny0bom9kMPLq+CbRTVcpidX0hzIbbxG/zElbaaL+QpGwXlKafd5BeJ
         rnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787584196; x=1788188996;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k6j7WBdzhGUFGnvNUS2cIrQrd4SkMPF+Ufhv82BZDwo=;
        b=A1vI3mq+BQGgrF6e0uGgot96YLXJ/yCY94HBQpUUKMSf6R/8m1xgRCw2uM7kDiq+p5
         rkwoSlSroRRm1nR3NEVrV7BCSHKouey44PkF0znOxynxbQvHapk69m8+Rze5qj2NsctI
         kcAgFEad/hH3HPKfJyIKzsWSPl6yAkl5p0b9N3TgPLYji6iJqoNBfrPt+shm10u8CHy1
         ZDttUTgE/O5l+L1eJGoz3WjxnCkD3LWO9rl8sPlLr0hc4LihlGHm/eKFtZxlvaDBcjp7
         b+/kdVEzido+YdOUeVGDEs3XbLBe4pe9CIQjcIT76wtVCeT9cYT4WYDsoPDbJwk73AXf
         M5Fg==
X-Gm-Message-State: AFuF++n3NrOgTnUOZ/1pmpCk6PzptTGTmBHVJFiJTttLOnDfK8f6MgTx
	lLvTGHbv/9NtNrZ3fRqkqKOk4Xfi5TB6cRIFkO6f7WiaeBK6mSsOr85B4FQbJPgDlAA=
X-Gm-Gg: AR+sD12lBJ02+2J8pjgDXX2U26OPYVaA8Kt1SEqwo0OngKsUy0rUj8wqL/g3oSAMpSe
	c06efSQhZSOAYzAnYjNF/s+qmwyAGNG69eAPsblTXtGMOw33Otsn0h+qairZ73NBXosQChjBOSz
	LewyVJV3P436tjooOgN4Qb5B6v85sl57fLZuOeiHD5jS8pBS467KEGMqUB1K1/zuGpoaZNcxei9
	pMI9or4/PqbDFcUTdJ2Odv2mfsjJR+It6FBgpnt2N017kqJA/ODo5p1hiEvyyCWtcy9/mrob6zS
	ww6vyDpz3lzachBJ70lpe5LLW3KhD++KyntVQRcftVjTDkgXZ3Cn6SKH4AMrnvnFzKbVyj5SpRd
	dB3BjopoMmSQtOVVT+/QY5fJ/1yyeLQGBCnuzPAwYJIVZctQBtvGv9+m3G43ZQsrjNPSHEWnmNy
	zqDWLZbGxjqbGgW9m8/qRNyImbSqv3BPbQ2yBws87bpaLlBlxg1cmil1iYnkw7+beDb9ydgq7dx
	JWJ5rVLJ4P8AI5P+ZStdEKIOnvKDqkyinjwQgIG4UV0
X-Received: by 2002:a05:6214:21cb:b0:8f3:cf36:15ca with SMTP id 6a1803df08f44-90c8098e804mr271697776d6.9.1787584196428;
        Mon, 24 Aug 2026 08:09:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c9360b07csm64972756d6.17.2026.08.24.08.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 08:09:55 -0700 (PDT)
Date: Mon, 24 Aug 2026 11:09:54 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, edumazet@google.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/mempolicy: refcount the weighted interleave state
 instead of copying it
Message-ID: <aoxeJmrVAiqOVIE8@gourry-fedora-PF4VCD3F>
References: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
 <20260824024117.1755899-1-gourry@gourry.net>
 <aou1Gwxk2s8Qjdm9@casper.infradead.org>
 <aou9WUf2qU8UewL7@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aou9WUf2qU8UewL7@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 7EDABC0006
X-Stat-Signature: coxf1ik8fd9uicie18dz49ekhzkmf3hk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787584197-873613
X-HE-Meta: U2FsdGVkX1/Dfrqtzl5gJJ77lH1QVHeqHsykebSkT4vBLLxCY2XSYumdR76tbnCGcFmLcY+ZIkTCauTd6vR9xIL7KEJPQq9LWaf6bkxtokkHM9U8aunqEotUynt5Z7/I95ItdjBcOG6VYq6D4DtgUBR7Dx2NK5woy/5OO5qFA/wh6qyIG4LMTMjuh8sybLWM8mF9HF/QiyWtf08Bn3YO2gytkRtBU67fsk1UaZp5/7QNiaur4hkpwpgzWxRQt3NXPB3wh30R9Y9te1I963cZCN2wvUAQCD1OE7zextvOQCqyueYhhgj3/sf/G9xVqKxLtxCIxcT2atO1IIehvpwuMaonf3EdLy9kB9QxEHBqB9YwwjtrnhA8icGzclY2e9VYj8WmDlQPz8UZjj+3Vbmd8fSvi0/GDH1JYgZLvK7CEUKnfLnNv5xoVxfNTXY2EsAxC61HQEIP4K7Qp+uik4OfJiX9BCJKjNXTzPu0YO+sGtWOjUp76ufSY0JUDehVQPIODHNFbSqssyF2r4C6Uce39uyNsrEElvON7lyYiDfpTGlEGImdXQDmvENXiNDCRtAufKbDrBLiIR+/Lf0tDcPsqHYOhbsYvaS5JhJapr4hpm9UTqjFhfmzS8BzwEjlEmgRqcjl/UsoDe9AzpE+7O29tpH72/KtdBnjdjRJaE8ub14xLu8FTnNqX0JEV+iSbYasVhob1nQbWywY63fGfnAQKLYEY6nCanLw7Vj1NVFarJDhdr72Wuh2+L+9BRhpekrQUn2En+O8H/yZY87vQmyY6JPfBdrSSoCbpDOOFM47CbnrLyPP9NmwcoorNxl8i8L2JdTtLcb7mL6FPvWRL/sd2tmOK8XnN7jxb+l+mSK6RIqvetF6IanOc/Gk/CBoHpU9I029cs3c8r003CgGiKBqyBvR3If1VG+pVT8D4UYXShEiTVbn1ntGOkjxyESUuz1B6roy3e3OQ8IPjHVtWBT
 dRJlksM6
 MTR3ECLHOWHkQbaRIiR4ldCA2/6VzYgA/0R/PzAg7TgTJH/zMEkVVlvSV7QwGOnZs8fOQkb/rY7/WYbzx+r2A+gcFjSezvGaCDCLPufxJNGbwq/debuiFeMCst2zai4wQ2M0kKf2FGrrsrTcFc7Ya+r/zWjSGt7aJUwBp8EKCWznSraJWGIJJMa8twh41Hkse/nVnatezGKbOxw0gsUvWafog6lH0/UyRiOGhk5u+40AaqyHQP2d0M1gVuSutSFfLVMhrmO1NNQPtMdjPh2shaTwlh/pEs197KiBGiVSLlWRi+CZs6ZxZTsLgPDbaeM1LinB0JCrxNfJ6eo4REJtPcvUmiTAiO2E6rhU6pHVZn/2h8FXGY5dSZ3E6RQ/9oFSyzv1wFgBT8gz13ZsW4YincvDaurSJJHggcfPNwuRRAMfXkyoAsR9Gz3E651FLMSe4fQir80mVC9rgbJH7ePmREQP/uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 11:52:55PM -0400, Gregory Price wrote:
> On Mon, Aug 24, 2026 at 04:06:03AM +0100, Matthew Wilcox wrote:
> > On Sun, Aug 23, 2026 at 10:41:17PM -0400, Gregory Price wrote:
> > 
> > Bit of a shame to take/put a refcount on every memory allocation.  That
> > seems like it might hurt (even being on a different cacheline).  Would
> > it make more sense to use SRCU for this?
> 
> Bulk allocation - from some measurements it's about once per 100-pages
> on average.  Looking back at the data I was getting about 41 refs per
> 4096 pages (16MB chunks).
> 
> Have to imagine there's other cache fighting in that stack too. 
> 
> I'm less familiar with the rules around SRCU so i shied away from it,
> but I will take a look.
> 

I will update to the new fast srcu mechanism, but it'll prevent
backporting beyond 6.18.

Best to backport the gfp fix and update to srcu in normal cadence.

Will submit separately.

~Gregory

