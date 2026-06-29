Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E02C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1771B6B00E3; Mon, 29 Jun 2026 15:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14EAF6B00FC; Mon, 29 Jun 2026 15:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018086B00FF; Mon, 29 Jun 2026 15:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE0C26B00FC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:00:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48904C1605
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:00:38 +0000 (UTC)
X-FDA: 84933866556.05.42B8540
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6674940016
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:00:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kelfHCe6;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759636;
	b=6dHZ4iicP0YNQypdJHMfNilAPe2v7fS3LjUNNwVAPN1BhEKzRWXjnUWy5YrWoBDiEq+uKe
	nF0Our3RFEV8hS/iwKEN0CjE6cRtYVJolRvuGt4tur9tfAvmJLXRtc5/e3d8381hd2XQlQ
	/9ginLDgS2y5w95290MJB/G9sfCD/6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6Ws0acvrk5n2daUvvKItqmwd8qsKqJ9fJgCacpsFrQ=;
	b=zIuUpaocGjoiJq3odWjUnl+kiGTR0lal54YRzxhwVTBbDiKdHxKi36vxi6ciVGLoogLhH4
	SSj2MZPl0YRp1IzruOPUUYwiesm8XAyg/kY+YEbAFRWFXgRmfuQ0BXxnmClexW/ME1RZZ8
	itgh8BqZKGhwkAleauQLrWsp/jicY3k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kelfHCe6;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-922ff615c14so482728385a.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782759635; x=1783364435; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V6Ws0acvrk5n2daUvvKItqmwd8qsKqJ9fJgCacpsFrQ=;
        b=kelfHCe6L0TuAyVh4li0+gxmZ07CJAhWpSShS9UfJRK+zifl/dHGGD8bz0PeXrNkWF
         Lk7atWB8sOj149p95xSmA/7d1r6G7e57ieexfWC1xNDb0dpq9pUfxPlnMSkuLQl72zpr
         JDXryiQgWBflntN7YLZO3UEpolBEtDm4KaTaJ69WgQiLXaQPRQwbNuy92v08WnFs2WGU
         q5vCKpzmIc+U70YbMweWai+RtkMW0QLbycEkIrP+A/aAYyjiXMExnWKTSDzEUoZmwH/A
         ZVJp880QloCUrqyh9aw6LTTgTTMl+QWBd8+Uhi+lIDSO34i42MIK15tME3MsbF2If5gf
         baJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759635; x=1783364435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V6Ws0acvrk5n2daUvvKItqmwd8qsKqJ9fJgCacpsFrQ=;
        b=RwCpeRecGHLtKM8+OU4OMWOBWfdmLtjgbcFKqz6Z6fIydO1s4Kku7yjjHIaNnXfuDt
         a+iH/Y7Iu2L/ZvgYDwCu3bZVYhFz+s/b83QDtyQh4YWIfUqnVSSPFIOhgOZjC9xT4FB2
         OP6YT5YtSMqI2lMyuRpovuYBhnUvxGMmf9FbuEqH1cx8YbY7TNpZrUXMhLT+L8+/2Nty
         KCKrJZnzDgHpt5zUlsZVCpK0WMgUfzqOCeyuId15vdd4h8ubZdIFLS6N7tYOOQ8UOryV
         y0nJaxddNN1mIRhVP2KCUJ1tnv0uHy1qzHQ3LaqOrP1PvDoezLjowJon8ma0sxCnL92r
         kjDQ==
X-Forwarded-Encrypted: i=1; AFNElJ+6CusW1oqpOqF5Kmc8DBnxxdU9y9eF5RgmG/JzD29nTb1AqihzWcPstx9GJFlUN1bgFD3rG3KP2w==@kvack.org
X-Gm-Message-State: AOJu0YzqSFaf/KsdPunzH9uOiPuXYEbz3MT2AHcjP03Od1bDD5kzkD2M
	BDPDg2uLabm+LtULior13QsrpSZrROVB2AnM/1mJTfFYF6VuzHOLS0XSuUMeISbxM+4=
X-Gm-Gg: AfdE7clw3CcvOCZXNAeE6ur82OZnpOB+m/bRpdQdyT8fkiYj32GifrlH6xq2XtKTx7i
	ZojadDxj5Q1Ibnv2GXNjQfOBeJaWbRNx9q2ZyF5yVpXZrgPnRdr2BI8NM3S+0U6uLy5G7JQidwV
	8ntHPhkNk0sCKHaBqfyMG5fU29jG2VAxDopn2KESSo1Jw4hb2LfpUuHcU0tx94dlZU91eRi8ACb
	fmaMbAp5qPbR+1ZOxtYwBdINwLfswlX92ZvUhjdrX0WQw1hc3TkZP0g4A81mSVJdF9rAyiAfssj
	SM8psfAX5u8uIvVqavB9/1YFVgekg5U1uBtBeRLZbhKy61DdnBn3EcxclsdG3aN+YyDw7bAlo3T
	Sh9FgzxsH+KKThNbVrMdQHIHk48C8HXeQPRsvENCNCNqfCFSibtHR/QAYooNPyTXcsnuQOcEiCd
	fEolhy8MlMQDxeu2v0yzESsB+vt83/SyT18nkGZ5fpCc44SAuEV7vfnS5jeXIaqibwvarF
X-Received: by 2002:a05:620a:170f:b0:923:5e7:1664 with SMTP id af79cd13be357-92e6267b097mr132511085a.45.1782759635345;
        Mon, 29 Jun 2026 12:00:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6233a5acsm49235185a.35.2026.06.29.12.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 12:00:34 -0700 (PDT)
Date: Mon, 29 Jun 2026 15:00:29 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	muchun.song@linux.dev, osalvador@suse.de, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baoquan.he@linux.dev, youngjun.park@lge.com, peterx@redhat.com,
	usama.arif@linux.dev, willy@infradead.org, vbabka@kernel.org,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
Message-ID: <akLAzTTCs_5D0Nhk@gourry-fedora-PF4VCD3F>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
 <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
X-Stat-Signature: fwjowt1c64c6xhify5ddodx538t5swy8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6674940016
X-HE-Tag: 1782759636-380661
X-HE-Meta: U2FsdGVkX18Pe/1MfgqLYS9KcdJHx9zxvQ77retiq8CSC9CvEntMTNfEtWZuLQ/QXmLjiLrQO5BwfiJuoT1txK40q7zrPprHH2vUvr3eXhWCBlLfoZoNDuMyw8Jq/kNm17EjvZvIcW6pq59bFmf2uBFueutfdlrehJlfPd5glRtxqZ59vL8MEX39j4mMfJzbjPkcRUcRj3mhxhI/KRtn/7d+9QhHdjjOAXkorxMkCL4b83hVNcqVA2I6/brj04EzhVKNawhvjRmyotTJF6gjxUkOq2NRvXJM/DLY4LoLJSgNG0s6Enf+UgjFv7GOKPHz4YD8FV7GQ0HFCa0/pwwmphC8dxYaZmy5M/ZO95Uz6SX5iIQfvczQQItPRXfnxixvr/M5sYmLJnrjb7/v32JO5ZNXQCimtzarTKOWlWG0cYdK98uwyXY0vsPj1Q4GTROeNTaPykzH74kIF0O/uMDPO9SaP8f7Iq1kEEEs4T50Ga5iUCTh+MFCMaycpF1ulEsLnmzegwFmoxpelP8oc8I5tblTehG8tPeo7q4VJYG95eu+AjywQb+rNSQ4TAoWtRo+3zZp099bVsnx8pc+BuH12nuoFoJ9W6maAMPEsk5FswfZlMESg+W36oy7dstYX5qWdrrsgsrOS3vvMOeFk3ALU6zDtEcrqDpO4azz6aEa1ikRBWUQ7V1M3ufpF5yzBPGcC3bInSzIZytykI/ryXK63SgNqyb+LBEGlQxzc2YXjAYL2h00Py1ZVHfWN8tCVXRhhIws5iuPmteK9IWr4+IshFZ2J4D3cosawKq5EGOG1POVChQ5E5Tb5PYQU0zRqSC88WxNocEx5oa929iuuvfk4B6VdqKLh7qNDSMfF3nPjwN17c2A6SDJ2xItx7oxCQYLcKM9ubIoXaQHHTXsgmc5Cej3TGpLmd4zt8gHbrkwTUi4Gf8QU+OYwgPiePaI0AvPyqiKcIA/1XFV9mQBvRv
 /6gzNaMj
 CfEeOjSb5qbwejQrN7vRXd5Iir5le1s1EJvZqdoo6aiUEEtcRTZgJhmh5s/QXtKFgGvH6hs3JL0AW3J/zTt5y6KukWFyqQsJMYxf5STWYJ/rllJHnD+68G7Ki5c7CysS+eKYIqwk/r7R0bxnkM4faOVLbe0qUHJ/SvUOkRvwI2otQwN26K+mk7t9vs/t8P+8dmZyFXQBu6ffWgOxDb3Pwv7HBcUyg+5NnJeVawJULIYPWmKiX17Xfgz4uuC6pKPGabADYcfmjKhLei6BuljZQBwV33yS7CzMW8AQopbkg1ygOtES26fTjR9no3vCSaVd7ZMoUFs4Rk5W2EX5HvTWUtt8JOp9RevgK4axP698z6e2ywx2vtG5X18inNbOv9EqEmmkYByOeYxogj3owCE9KPBLf77+fCG8WaDyM/mPoQSnYb8z8JGYa95kk0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 02:20:28PM +0200, David Hildenbrand (Arm) wrote:
> On 6/27/26 09:21, Qi Zheng wrote:
> > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > 
> > Therefore, we are wondering if we can introduce "reserved THP", which is THP
> > that can be reserved. It can be consumed through methods like madvise(), while
> > normal memory allocation cannot consume it.
> 
> madvise(). Gah. No :)
> 

Without going into the nitty-gritty of the set here

  - Reserved   :  I care about whether this succeeeds.
  - Transparent:  I don't care. 

These things are mutually exclusive, so "Reserved THP" is confusing.

Maybe this makes more sense as mmap() MAP_ flags:
  - pre-allocates at the desired size
  - fails entirely if it fails

Since the intent is to *reserve* it anyway, it makes sense that this
would be a pre-populate directive regardless, so no lazy-faulting.

Then userland can ask for what it wants and if the kernel can't produce
it - allocation failed.

The underlying system can otherwise use whatever tricks it wants
(cma, reserved pages, etc) to get there from here, and all the swap
semantics otherwise live in normal interactions (mlock, madvise, etc).

Rik's work [0] is trying to move the allocator toward more reliable
hugepage allocation with the intent of making THPs more reliable in
general.  Maybe these things meet in the middle.

~Gregory

[0] https://lore.kernel.org/all/20260520150018.2491267-1-riel@surriel.com/

