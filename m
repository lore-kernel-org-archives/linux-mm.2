Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D65CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485048E000A; Mon, 10 Nov 2025 22:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40EA48E0002; Mon, 10 Nov 2025 22:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6608E000A; Mon, 10 Nov 2025 22:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 192598E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:00:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0B315892B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:00:35 +0000 (UTC)
X-FDA: 84096823230.22.0E8760A
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id BC40C16000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:00:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=noQmNNpG;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762830034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ul2ZY2G57orZgmpduBInIrETuK3NAIisOONEv3fwlE=;
	b=1vFhaXdFaeJfqsIAblArf6h9b129BrZIyYnskySOs1NTjAweIN4FxtD3Bfx1e9y7mvpXB8
	DHa/d/k05UtMnhrWCb96bLXh/8kMR2lMgOab/xK5sMhOCCk/JcS3U1hFORmPe1fl++y7Sk
	iAMVe31jMv4qvLhtu7fzmtELyQL0Kmo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=noQmNNpG;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762830034; a=rsa-sha256;
	cv=none;
	b=cKU8C6qlSO8BRz60UHTmZq172VMS9edv/x0SwquD/Dw3y/HfyP61Ulf06N7pYK/1CC2Jt2
	EBgJbmsiCetxR9+hKEQmEJKLn1vjnDBIvrBl35c1qh2LP/CCzCqMO09ndtS48uOah+eDGW
	QY/g4mFsTHK43IVMXG2Ksq6dk8fskcM=
Date: Mon, 10 Nov 2025 19:00:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762830030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ul2ZY2G57orZgmpduBInIrETuK3NAIisOONEv3fwlE=;
	b=noQmNNpGXqeh55EPq5nX35rk2qS9h7N8CFJCxC2xW5/EEMWN4cxmYtu8eeQTlF2OVaBq4J
	aEiHGJ0In+usILEcVeIIEtQdJSVH5joV422aeigrCaAVnKZco27cq/idJjdw5XR9IOoC6+
	piVfwn4nRzlTsjOEEtTJ92jiQJQcTUM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
Message-ID: <hgf4uciz7rp2mpxalcuingafs5ktmsgvom2pefjv3yogel5dh3@7kkwtrnqotnc>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <aRKKfdN3B68wxFvN@hyeyoo>
 <24969292-7543-456f-8b80-09c4521507e2@linux.dev>
 <gsew67sciieqxbcczp5mzx4lj6pvvclfrxn6or3pzjqmj7eeic@7bxuwqgnqaum>
 <99429fb8-dcec-43e7-a23b-bee54b8ed6e6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <99429fb8-dcec-43e7-a23b-bee54b8ed6e6@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BC40C16000B
X-Stat-Signature: fxhi4hfojazu1t8dntiux7m96rnstd7r
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762830033-800437
X-HE-Meta: U2FsdGVkX189VImkMrut1jfYNlOnlCXm3JVmaAwx8CWfKCf4rwmfMe+KWwCrGj6vFnNjZ640sLm8kiWj94SD1GVY6wJz2KHSfSsWQ0UWpOgx6bScm7Z7PJfQ8aIjj0Kbt2vxQHG4IxbGvB8hRlb4MmreJ6tkTONHojyr9toHjtNvSUxh4IZMISTZQn+5knaJu/m5g5geT28dXGa3AYsDR2VMNyeovqVFpODmKrA2sTVSwMy9GJCUk/p8yr5UEpe0i2hgLzR0XbTCDx7DRhGiTAbOFvy46jsxVerMyGs7089inC6KutZqYJGX5w6nLFWcVDeBNkiz9lpGy3Yd39pvtqb2EOdV3QFid6CwP7+zCcP3syNx71GUHOVY6o1JNH8N6fpAlJ/Pn6hjS2iLalmbp351vmbRbFql0ZYCOlow4YWm4mSRrSj1ZuFKFdigYftb8hSnYBh3MV8Yz6qqezqJwI3Y/F0pfhUeUyGKmzfCtQLxwBaB4Xy3P5MQlhz6zbh0smJa9C0SYxPj/NPDaQEMCuUVlEuhC+zBi7fMNHcXzi5TGNT1k+nHG4sJO0IoC3UGO+CQAqpgPSEZv4yJZoxIT9OmGzl5m8TNmHKPIw8l0NQ8V5e76BNq2WOTiEU0LK4BeQVNMA7K4eX8Oe+UlJsqax8swAvY6860Tl2CH5iPjFGmdZD1EuDh8sQHX25WeW1jLazNjVOnTKAG/Xc7bayyDRkZYOrpeX0QpHJNf+sJLD6Y9vcdG+v8QtBoEO6Wu91kth/H4EpTGSBXdmpEyxqZyIpM59yXkMn91pPhOUVDIoKtRcIpkdwmvtt9JPphPB+JpBrR4s+TBB7CZwWZKdGZTPykX7b4wbUa8pVTwqOKgPKZorQo3AR5tjhRCjHHi+TF11CUaDYQOUSLd48qY7Cgjnvta2yfq1upUGIiuStCqUWr9f6jsNeyK6GgUwrqCgoNN97s0plC5Z0RKuBuQaP
 4MXeREpY
 5aMB0OoZOrgfDgfOVR52QBM51PeMu1VgD/+TPK7xBAoZ16dhE9UoEJSUJGh7Grw+qnS7IwvlvYMZ9ZIx3iZsU7kbtSijDmtd1Z+v+XuQ5IMuskQHEXHkGoOThQjgdqa4lrLDnwy/CEploK+9I6qpap0mrNhOTvbvUQcIQXmBLKasSNfhMCcrFeMSrSjkFk9V1QB31axGRA5GkmdoYgYkY/1UWDdQ3NUXSe+k3Xl/m3vzzvRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 10:48:18AM +0800, Qi Zheng wrote:
> Hi Shakeel,
> 
> On 11/11/25 10:39 AM, Shakeel Butt wrote:
> > On Tue, Nov 11, 2025 at 10:23:15AM +0800, Qi Zheng wrote:
> > > Hi,
> > > 
> > [...]
> > > > 
> > > > Are you or Qi planning a follow-up that converts spin_lock_irq() to
> > > > spin_lock() in places where they disabled IRQs was just to update vmstat?
> > > 
> > > Perhaps this change could be implemented together in [PATCH 1/4]?
> > > 
> > > Of course, it's also reasonable to make it a separate patch. If we
> > > choose this method, I’m fine with either me or Shakeel doing it.
> > > 
> > 
> > Let's do it separately as I wanted to keep the memcg related changes
> > self-contained.
> 
> OK.
> 
> > 
> > Qi, can you please take a stab at that?
> 
> Sure, I will do it.
> 
> > 
> > > > 
> > > > Qi's zombie memcg series will depends on that work I guess..
> > > 
> > > Yes, and there are other places that also need to be converted, such as
> > > __folio_migrate_mapping().
> > 
> > I see __mod_zone_page_state() usage in __folio_migrate_mapping() and
> > using the same reasoning we can convert it to use mod_zone_page_state().
> > Where else do you need to do these conversions (other than
> > __folio_migrate_mapping)?
> 
> I mean converting these places to use spin_lock() instead of
> spin_lock_irq().

For only stats, right?

