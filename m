Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B04BC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 920C36B00A0; Tue, 22 Sep 2026 13:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AAFD6B00A1; Tue, 22 Sep 2026 13:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772496B00A2; Tue, 22 Sep 2026 13:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 488606B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:31:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6D2A1A058C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:31:51 +0000 (UTC)
X-FDA: 85242090822.24.78BD5D4
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf19.hostedemail.com (Postfix) with ESMTP id AECD81A000F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:31:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="toIya/Og";
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.234 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gPRbBCQLJwNMl68mNAhEYv0OV90CxwDGmkvmCuCwGU=;
	b=595vKGQs7gc/kvTtgsMnnMBqJeJA+gqGGonSlFCgT0GLlIWuCxUBC4fIwYQSIuW2FSNGPq
	GQjNgqhwr72ISiHYPA82amcb+ySOYDS2r2oKsgzo7JdMfUwNDpmX9tzLTSEiHSnOlhl4kH
	qmRVfsQl7BuLAdRd4ksgg3Vf2dgrHJI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790098310;
	b=I0XInTFO4EUDWYhx8WovVVXhTUdsJlcHEvfwE1RoqckZb9zvoMDvCqKat4gbrtctQHKfBm
	yeCe9nYSvc3cxs5uAdkz2l2vmgXHOLaoOFlorGr/9W0dkG6lJTjTm3U3PubcVx0+vfdRL7
	309U0kkUX3A5QWVkFNyXWBPb8mJ5qU4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="toIya/Og";
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.234 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-52fb766bfd8so1199231cf.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790098309; x=1790703109; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/gPRbBCQLJwNMl68mNAhEYv0OV90CxwDGmkvmCuCwGU=;
        b=toIya/Ogix0U96GWJThU6UAWG8spykx1h8YEQD9xsKdQmBJ8ClVmZsIuh//p7z4Lng
         l/50G7FcAWU8aSRHT9S3mRZIn5wEu1fq5GTGP6pjfDRu6EX61Hf5b6JdYcnWxwiQC9Tn
         apVwa3I2NgNMCIC1+YRmioA2tP6z+gqoV31ak7TcVtI4bhkyPipdXX3S/sQJGhEZaO0R
         jBtMj9grPe+KKgyNujJWPu/ptXErWvxrSOWJ4qYCXfpLIdyg3QBPA31LVfNwbBfh0gCW
         22qyBL+RA4PoJHJSAi6BN7EioVPPvLsMIpAYTicpsAvnTPKXJeP7gG0yDU0fH5BR1Mye
         ewZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790098309; x=1790703109;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/gPRbBCQLJwNMl68mNAhEYv0OV90CxwDGmkvmCuCwGU=;
        b=hok7ptwoLP0mV4q9eM/BOLWHENXnaBnf+KNF7oNxIQH/h99nKGfjLx2Vk0QpoUTn3T
         bm271zHVmqRz/3Caic5wJ56LU7ZeTNzMrqa6KXHHoJeEDogXfZK9wugFpqHr5QEN4LP5
         2xGMOOhqQoOS9I9/BPKUTquRrk+d/aviK7hjQsrZb1irD3VR/BMqXocp+21EcIOW1EOO
         WpLju7KQezUPePyiUKa6RxTrFS9Dg4wlTQr/rg0mOu3q15fSXFtb8dvjmX4/GaqSX3zS
         pdnKduy5VqSkFJypmtlwZmuZwm5rMUBJsXkCwK9k9XB/eLkiL3SGmeaMGyHb35kgl+XQ
         oYsQ==
X-Forwarded-Encrypted: i=1; AKwUvBy8/yHonGZ4tgmKdPC4C7TcJMkvjh7k9g1Pr3hAxvi05i/ns0S78EGE/cxIxg86X8cmHAoFgpL+rg==@kvack.org
X-Gm-Message-State: AFuF++lEX2vY2sRQjeQK4Vvrc6qukDJEXBMogxuQGKO7d7erG/Iv7O+c
	O0oHuhclZ32Jboh4IWYaA2dn8OlsuDPIApp+YB1fIeEXmxXSQI8Azj13M2Xd2jR5neE=
X-Gm-Gg: AYBFou2ssfTw8ytEFe+WNYuWL5FRjN7qGOtBngTK9EjVmsxL3Wcb3n45x/krEwuGEj4
	Vynolq+gZEmQaKbeggl2uGgqcmYYsnvm7hUTPKjjCpk4T1rTeV6lXLD69EuGcn4TC1WS/ERREFj
	3xd0fGJATbb+PxqaCXY4gMAawiof3iRd3JfxtlwlXomTvJt/7RCTP968P30TyDHeWyofvo1QOri
	VG0xCl/13mM63QlUFqZVzhhuN6TIdCSA9Wgb2GyepGWhZVUykkJubdgJGDOayvyBkBexgFFMRMo
	2MPmFL31Z2EmaLoXzVT6MTg5w9FBBDZ2OezFVAkS8wepZGBI1nHYRNkGPgOBSu/hHyRu4ZsChAY
	I7CCLr4YjES/pYNwVSijfzxgEnsMy+F9Kd7mNNqAQHGRtc/cpf1yjA7tsY+4D3tvVabdlbzmhMK
	1rWftpLe+TDJTfLWbWS1yinK9kJGwDbo88b6X3HI480AqtOpsTO1bg5qyIfcPcUQRmFgry4g==
X-Received: by 2002:a05:622a:138a:b0:532:9e8c:ba4e with SMTP id d75a77b69052e-532eacf5339mr4180411cf.55.1790098308508;
        Tue, 22 Sep 2026 10:31:48 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb399581sm1409041cf.28.2026.09.22.10.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 10:31:47 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:31:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@surriel.com>
Cc: Chris Li <chrisl@kernel.org>, Gregory Price <gourry@gourry.net>,
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arK7gLYD0GJwzKFq@cmpxchg.org>
References: <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F>
 <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
 <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AECD81A000F
X-Stat-Signature: rpoyxhm61bjwpqmu396h7n7ztpe7jx97
X-HE-Tag: 1790098309-40331
X-HE-Meta: U2FsdGVkX19ZLGQn5GO7Aeqgh/SIJO/NYMegTgYqRjVxNMr5PPboycTv6ekLbdRZDbMjcaogtxH+gvDDMD40FXVS0KC/i55dk7qwrujKBEi+O7QbKiIe9lSqzn4pER/+90zpeWMNFpO1n4xzTV26aTdGjkQ7iXifAJXMWS76HONoNS/JbrasW3xm3T+8VHG06u6N8eZ44WC7SHwZSSa/K6xO+DuRRIx5o5eJ1mhQUldi01+2nd0+ordeHI718s0/YDey59C9w/iZYas0TVxr6qXdl2YXvXcNKpbQPREU8mWB6wvEV6xT0K4QeXY5gnPegDcMEulS+kHVrvsktQo73pF9Dwa7Ornrva1B/AbrOlCaORoVEIouq8RG3NhFX7XJplIv7DMScaJJdIGExm1Bpf3UOJyHTp9HeidnrgqQQLXOJuNeop+RuGPn7V8sSXUDRh7W0+fZnfp1qQ5zlospT7j80nK6eDv8VSHoMKJTnvecSb/bYs+a3gwl50kz/075JrM2f38GawpIf2yk5Ak9SHQT2NWHLuluUXCbDOVO+5j9QJ+s1qYp9gRQTSp39SyNiOMG2sHiXbOouZpSHhBVTTs21s5B4RYBVeOeog6aLLQ23XvikARZycAzvkcy/svcFogf87dbjneK04oE/7tt9SUfw6uoM6JtjWVh2utZ4EI7Ji4zvi0u6NSZQjCmu5QW6TzujeQOResnNlEWLvYFqx8pslMRGqLh5gcSg3hmIFMhiXmFqxGpwOvKUt6OCrFlBUiJGSEdULwZ+HVBsSOhsjBiFRTC56n+GfXJWMkkHhUD4gjqcb6T6cINX8X62R3ARJ3OIILoPdguWhnsEFwMIV6S7UqYhTLveIL3jSRhrfByVh8c012CPjyTwsZ8qNAe7/MZ81/pULbDzbN9EEY1iw1qNPTXZ8xNo98daj6SvzCvMsYijHLPslkrOW8jBDSLmfuybhxJ9B3h1xOGGfJ
 yBCBcIOF
 WK7nTPAr578qKHi8Ne7slERxmM48W9Yvof4pkb/cotvRVWlpVbDSgKzhRHHSP7K/B6uCHL2i/IZDZQ+p/4sGSdv6RS2WJjRaHsgugFWGuvCWtvjWchcVCcn7i+QBphDWcQQeMBv88sV/bANDaJEpmBl8JnksJEXMX2ONHMDxkGnGr2QRi5uUbKiFgPhe/6F46IZPHpAkKK/Q3NyOCCzg7TqxIalywHnC8VxgINxvQ2G1r+GS6P/7j7DkEzZFVfbYHx+QVtY7IUet7YRW0wd1jDVuf8rvFcAQzh95gObM+9pNf0zl9jxaY2xSgiD6hthjrj+S3yki2DojtI4s6RUaOXvorh46e2jA4//trD64VRn+jm02fb/vPbGINtScfLAe8q1HiadvMPtF5v/HpEaMl+y1MBKPyn2xf+8YNjV3KLiyKmbwNMTQIWDb1fNk8jUt1pnAvhTCxQESMut97Py5D9NxZtKMstOLIR/QBNKaIQL6uh2zHNQ4JlNv3GAdsZONxPxHHl2CyCcDXzKaWHtCLCpRTnDtpPfBa1tdpuJa7Y0FQzbCXvQULjxRvJWcNuR+Fn7UvjOA2t9SNhaxmHF7k5ceCA+3cCj0UV90i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 01:14:31PM -0400, Rik van Riel wrote:
> On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 2:53 AM Gregory Price <gourry@gourry.net>
> > > That should tell you that your model of reasoning about this issue
> > > is
> > > ill-suited to address the problem.
> > 
> > That is what I'm suspecting. Nobody in a sane mind would want to
> > zswap
> > 100% of the RAM and maintain reasonable SLO.
> > 
> It could make a lot of sense to have some default
> limit upstream, that says the zswap pool is not
> allowed to take more than half of memory, because
> at that point the compressed content will be
> crowding other things out of memory.
> 
> That seems like the kind of limit that is large
> enough that very few people will run into it, 
> while also being small enough to prevent actual
> corner case trouble.

Just to be sure we're all on the same page:

Zswap *backing memory*, the space needed for compressed data, is not
the problem. It actually has a limit that defaults to 20% of
memory. And there is memory.zswap.max for users to define everybody's
fair share of that limited backing storage.

The point of conflict is the pre-compressed side. How many swap
entries can vswap hand out. Hard limiting this is the point of
conflict. Any given swap entry can refer to several things: a page
full of zeroes that has no backing space; a compressed page in zswap
that consumes some amount of backing space; a page that was written
back from zswap and now consumes physical swapfile space.

All mapped by the same address space.

I don't see why you would limit this at all. I don't see how you would
pick a sane default. And if you limit it and workloads run into it,
there are no cgroup controls to manage fair access.

(Despite what has been said in this thread, memory.swap.max is for
those entries that compete over physical swapfile space. It must not
and can not control vswap space used for all sorts of backends.)

