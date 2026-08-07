Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47C3C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 08:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BA56B008A; Fri,  7 Aug 2026 04:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926496B0092; Fri,  7 Aug 2026 04:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8142F6B0093; Fri,  7 Aug 2026 04:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAE36B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:42:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C407AA030A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:42:34 +0000 (UTC)
X-FDA: 85073832228.24.65B919A
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id AB08540004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:42:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vjCnZPNk;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786092153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+S9uhnLei8sckIfJwmMomkCOBcS3Ge0tU7iysiifkA=;
	b=jjRt3TmuSBnOxWT/+t8lT+wRep0+Jyn93Xd/cUkEv34vz7BlFiQxR3hvzEi0O/z9QkgZPo
	4jml+rrdN9ftCg4CAlbV5u4Na3v+C1ocb7MMW34yejl9Yw3D+ALk9xzat8/zKtPlCppRWV
	j7eke7Zfa8QAAmZMyDGPOieyoMVFsXY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vjCnZPNk;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786092153;
	b=5FOeb6FWukH+Q7tzPkXb8cffdIzbdJiVlPHS/u39TllTQZVZOFQKpLM0icraUbj9D2CiqW
	F+/bNNpHeU+5QgZOhEF9RyEYLya9TZiuOBRFpHM/CqLPt8Wk4tGRCnlqSZur9INmrxyBQM
	8BuuDEmp44HQEvnuZqyL2+GJhOpnWzk=
Date: Fri, 7 Aug 2026 16:42:22 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786092149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w+S9uhnLei8sckIfJwmMomkCOBcS3Ge0tU7iysiifkA=;
	b=vjCnZPNk25axIWyhNnN8qu4Ejr0GgXjiheyWhBE47o5583DSw0Yoy7J+Tganu8JSwSjT+7
	FKKISIb5OX8A3PWNd/+sx/67GFt7Iva9vYO831lZls+OY9bGsXYU62gmLPmUTGGTfA+SP/
	R9MejnUY1HM70qjBHsI69mzD2XKLk10=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	her0gyugyu@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/swap: skip empty clusters in the swapoff scan
Message-ID: <anWabobwPyAXvRe5@MiWiFi-R3L-srv>
References: <20260806193228.458685-1-youngjun.park@lge.com>
 <20260806130655.420e16bf621b580cc5f08040@linux-foundation.org>
 <anV+EoxWGKdU9da0@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anV+EoxWGKdU9da0@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dc9upt8r6rsunq576c73d7hbtfwwxrr9
X-Rspamd-Queue-Id: AB08540004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786092152-857457
X-HE-Meta: U2FsdGVkX1/KKSAmmMeiovhFgi+6Na00uOzTCdsEjjhjOZsAwmVk+q7+1Zh5+dI0uSA/tg9EQ+Bvh0Pi/CH4OCiIoHEZadpXlvcKGKmD6IQtKwF4ZFD7vYL20vSZAXqzMln6a7lMd8HfPuaNWotw95sk22HstdhNPBYn4lO3vlQ+6E6Kpuu7ytA2d384z/8OhW21JdD6BXR+LHsWOqdrjnxAbr4gJVbJgmGOpV2UQNev0umDIpOXNCg2ySs21ppzsvWBEEuFxYadq3mkz++Q5fMhThz72q96eO/WwAA5llSth5mYoT5QK5LE46vHBpYE4VuMJ3NAHiBci2/JqebqOMQjKnATlcAR2clicg8eunN/ZljpkVuBQvjFspumxVOra4KlC5dL45ei21Jo9t3LEWCnXVM2ind27uHBZ31PgNOS140MAMjDbgsZLceX70n2Qk2Ti9GppXemxqFx3zvpii7WCp2vdXe+IvE0sppiWDM5Uf1AxOH9k+MCSqcL6VeQCKadGbHSJ9ZIitedsscElILBReOWyw87Rt0s7fPhz+pw2m18oxh03O98zIdtxXVtsVTwXjgZApXE1CHoPguBz60qh5ZZHLukhvru+GG2X1zwg5WGmyARLe9mXR+P9uk8asTCTt3dP/SH+8rBD1cdmVNA8lf/b6FGD38sDnpg3FEIGmf4momNWAN8r7TsJQSBKEW5Wg6oGiXhyFTpbJp1tL9UaugGvVm674wqdallFNYohQGjkKOuslF1/2ULvpZuu5Gg/lhNzO+LRfgeuMz7ln7fiCSEP8fFAg6935NLBrY5PMpWg0IMJwHX+fq4yu/UGnVZKc+xLlGUyccbEsrRmbCuNr0Two9wxubj0U8DEEvObK1E2P6SHWgu8tmD0f0U3bOU//fafnstmei/Pi3gYzAdLaCocACfCa8QJyeMdzl7n41RblhF7EIoMy4rwU4gydaSZ18b/4NHDb75Rzo
 hemOzBrA
 IYAMF8/gNn9JNxgGcGYrHCLBHonrP6kbMrwxGgTPrffORdOobi5eT8Av3r/enNlBOODIFWGkCjnZ0ucbS5eoZCLeSSZZ56r5ok91bVIKWTku4XkfX0hYjhMnzEjvSaCTfFpG/X0UHHNm/aqIBH5700XQTb4QoW5xorCzBDZbxp8RahLwD7WB0p0n1nt+yefiBZoWYFkxveVrIWU24WF/6ajTXodS9ZQL3HgG9hFZf7aCgyDuQoybdNw6t1rj6LgQl87ullixLTDShr34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/26 at 03:41pm, Youngjun Park wrote:
> On Thu, Aug 06, 2026 at 01:06:55PM -0700, Andrew Morton wrote:
> > On Fri,  7 Aug 2026 04:32:26 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> > 
> > > find_next_to_unuse() walks a swap device one offset at a time.  Slot
> > > state now lives in a per cluster swap table, so patch 2 dismisses an
> > > empty cluster with one counter read instead of SWAPFILE_CLUSTER table
> > > reads.
> > 
> > Thanks.
> > 
> > Can you help us understand how significant this change is for users? 
> > If "not very" then I'd prefer to defer consideraton of the series until
> > after 7.3-rc1.
> 
> Hello Andrew
> 
> "Not very" in the common case, though there is a case where the win is clear.
> No bug and no user report.
> 
> For now I would rather defer to after 7.3-rc1.
> 
> And for your reference, here is the details.
> 
> Every swapoff does a little less work now, because the scan steps over an
> unused area one cluster at a time.
> But IMHO most of the swapoff time goes to unuse_mm() and to reading the pages back in.
> 
> The gain shows on a large swap device that is almost empty, when the last
> pages still in use are near the end of it.  The scan has to walk up to
> them, and today it looks at every slot on the way.  Now the empty clusters
> in between are skipped in one step.
> 
> I have no measured times yet, since that case has to be set up on purpose.
> What I did is the arithmetic for the case that skips best,
> For example 1T of swap with 256M slots with SWAPFILE_CLUSTER = 512
> and everything free but the far end:
> 
>   - today:          256M table reads
>   - with the skip:  512K counter reads


Maybe just use time to measure swapoff time consuming, just like below
as I did on a kvm guest, I guess a bare metal machine with larger system
ram could be more obvious?

root@fedora:~# free -h
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       181Mi       3.6Gi       924Ki        72Mi       3.7Gi
Swap:          2.0Gi        18Mi       2.0Gi
root@fedora:~# time swapoff /dev/vdb

real	0m0.101s
user	0m0.001s
sys	0m0.017s
root@fedora:~# swapon /dev/vdb
root@fedora:~# time swapoff /dev/vdb

real	0m0.014s
user	0m0.003s
sys	0m0.001s

Not sure if Andrew is asking for this.


> 
> That should be around half a second of scan saved.

Yeah, a concrete number is shown.

