Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 831D5C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A336B00A1; Tue,  7 Jul 2026 07:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54AFF6B00A2; Tue,  7 Jul 2026 07:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439DE6B00A3; Tue,  7 Jul 2026 07:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17A4C6B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:34:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85CF31A0421
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:34:41 +0000 (UTC)
X-FDA: 84961773162.11.3AC69AF
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf29.hostedemail.com (Postfix) with ESMTP id BD363120005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:34:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=S0HZYj6i;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783424079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQE3oIJ4htoW+wFqKdDDzBtKjMtLRHL9VUuCAay6Gu0=;
	b=rgxdEbXL2WqSDtYhUWFue0e0VhOudk66eZFFw2ku4aZh8x4CiwMdVwXED0KHw2c4xRE8iK
	b9ij7Ok/hU3mTAKDrYauBU4SwVKYueAeJXsY2qidBoKuMqurDe2xCL6p9T3s6OsjvqSCLN
	2nbRKgG6vTS9dO2rtLO1KrN7ckm+1Nk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=S0HZYj6i;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783424079;
	b=w3bm4zhb9Mf+I29d6H4ZfcrMRIaPoePAKCz3MgQpOYYl9Bwf6QJdPCXJuGQRUnSl7PUy5e
	bv+uvyAbNP1FHDjnLqRZ8oM9aGNky2xfYApo7pkWTnQzGpvz9JqMspzVRoeGNNS9Bsed4U
	1b1OzhbjGGWAc3X1vbKsMnok2CCmvLo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783424072; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=jQE3oIJ4htoW+wFqKdDDzBtKjMtLRHL9VUuCAay6Gu0=;
 b=S0HZYj6iA/8doMYhRv7PwCxyEjwG6yYdBTwX0CGw0zVs0c+gaQ3KMv3Nr30+Q8pkPvZkDP
 1elSkLWqTSqBgWJXGUnYbgDpBpgw6g0KhF4oQSKG5jyeOB8ZPUTNtGlrlNrrAUnFbfhqZh
 li8F2SESyx+3UqSjOq5nN9f/IaSmeDP67Twqg2Epvjj/vby8Qx11wNnCPNyNZumV4GQ3Dm
 QvyWKIoqfZb8KI1wGir5jyRIMKp5/jR7WxpFJZvnopRLNxd+48Neq3BC9R/UfcidI4xQ17
 mJ1fTN5Hlmq/IS5Ee9ZEkAa4RQNDI43MS89PNob21AY4hsCqojimrG/UOsP9sA==
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
In-Reply-To: <20260706171902.GCakvjhl5U89iJdaNP@fat_crate.local>
To: <bp@alien8.de>
Date: Tue,  7 Jul 2026 19:34:09 +0800
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a4ce446+79f3e7+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260706171902.GCakvjhl5U89iJdaNP@fat_crate.local>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260707113409.71996-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v5 7/8] x86/string: extend memcpy_flushcache() fixed-size fastpaths
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD363120005
X-Stat-Signature: f5punadia9npjf5konb99d9ang8n1tpt
X-HE-Tag: 1783424077-744661
X-HE-Meta: U2FsdGVkX18PN+J4RawAUXTih+NezMVcGwm1xXZ2vBATqQ06/4G7fL8ebk30w72SM1BkMO1mVY+cYgDsXJg8qUAhvH5nR9UsBotLLeSag2RzpxZ/Na4bpLSVVDOKyqEawjMfrZV7LB6fhPfxuUZm4h8T6NYKXpia3s7wwDVc32dEFTWRxZLsyrjbePwUslXMpYDLJEEodmAgjDuVP7O/bGW91jijD80WjsC3P0jCIo/nb97xZ/1vi4hew6AgPIk85jCzIA7zMbcqTnWfd5kajAVPrAAoOK9WIUbGJQTuzN7Ryjs77en3QOtPpy1pUHtp8pwWH2qiz+u8ojJzCUUKl/Tua8/38M1ZFicl6VuXxkuOwPfuTaF3cabpf47aOnLeG7OyLa76a2/OLBLtHI5XGck2jmlFdBrt1lFx6ve8VizuHQutdYTt6AZ0ZzIgzjaIzwkgow1uIFagzeOL/QpxN4Mrh/M8PhZh3mkOnwQCe5de7MpAu33gbotbjCGJcZnf7F4xRgYglisxbCUovB+zmHe6FMYH6KHmcIznDJHzDkajZHCMzY6gKwTkeTCYlbVXspHSzbHU6R42N3hQq8Tpj8N7s1HmPwM5fhPPkPNP9id0hkJa+hNZoe9iE/uM4iuWjJ3oeUMdyjKeyIivintTpIhvgAMe/xey76jB432Mgrtice4+4bM8JGcJJJshokVBkPDhIzJN4jkz5PmoFUVM7Sol0xLvo6hUyCD+QmhTycK77YedO8Nq1oOMwkG+QPaHCTuZxFkD808ElziRJa2H8g0xoOPmJFOxujg6Ox64UFEk9eTf/g4joXyiztRjPGgtpdx6m1oPyYXt35hWdt24BnjLBJ/jobe8ktJQFVUWg4IMaLDyADxmDK/5bknOS2uHQCQC9ba8Jbhd0IpyOiDhP0kPozJ82c3PILOPubLgLUcxrBjC2Kgt/pRrkrysmfr+F0u4aIS8cD++ya+sR1u
 9J4Jd0ae
 ynkBezqEwJTJjzqsQ3zzX0NFr/SkIS4/e90h6gMWD6h3TfHMBepmCQ7+8ZJ5dUpPgAEWsTfRbSUx60mpW30o8gdjHCc+W1vg3NlnQorJ1j/nCpSCaANz5fEKpGfZCSiYECLg4oQUHANse998rQul03lstiYwq8wq4tIB1g/x4UAQu5i/lyZyeega88LXY4r+l8XbmLwNC7WMS2v7LjAfIfBZjaZVbK0kMtAeEBN5N/8P6hCMFsxbGWgndc09z1OdfhyCofLeRRxfVnvS2B9y+odeiASn3Im6ovhE/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Jul 2026 10:19:02 -0700, bp@alien8.de wrote:

> On Mon, Jul 06, 2026 at 03:43:46PM +0800, Li Zhe wrote:
> > The extra IS_ALIGNED() check is meant as a conservative performance
> > choice, not because MOVNTI itself would be invalid on a misaligned
> > destination.
> 
> Dude, you can't just wait for me to pull every unobvious decision in the code
> out of you - you need to write it down in your commit messages! I'm not a mind
> reader, you know.
> 
> > As the Intel optimization reference manual notes, higher-throughput
> > data movement usually comes with alignment considerations, and can
> > be more efficient when the destination is naturally aligned.
> 
> This can't get any more vague.
> 
> > So for these larger fixed-size cases, I kept the inline path limited
> > to the aligned case. For misaligned destinations, falling back to
> > __memcpy_flushcache() is expected to be the better choice, since it
> > already handles the unaligned head first and only then enters its
> > MOVNTI loops.
> >
> > I will make that rationale explicit in the code comment and commit
> > message in v6.
> 
> No, you need to show whether the alignment brigns anything and then add it or
> remove it. We don't do things based on hearsay in the kernel - only on hard
> performance numbers.

Thanks. I measured the exact tradeoff on the physical x86_64 host with
an out-of-tree microbenchmark.

The question for this patch is whether misaligned 32/48/64/80/96-byte
copies should still stay in the fixed-size switch, or whether an extra
alignment check should redirect them to the generic
__memcpy_flushcache() path.

To isolate that choice, I benchmarked two memcpy_flushcache()-style
helpers which shared the same generic body. The only difference was
whether those fixed-size cases always stayed in the fixed-size MOVNTI
switch, or whether misaligned destinations were redirected to the
generic path:

variant A:
    switch (len) {
    case 32 ... 96:
        do fixed-size MOVNTI stores;
        return;
    default:
        generic __memcpy_flushcache()-style body;
    }

variant B:
    switch (len) {
    case 32 ... 96:
        if (!IS_ALIGNED(dst, 8))
            goto generic_path;
        do fixed-size MOVNTI stores;
        return;
    default:
    generic_path:
        generic __memcpy_flushcache()-style body;
    }

On the same CPU, with the same source buffer, destination layout,
stride, and iteration count, I measured the median time per memcpy.
The wmb() was used only to separate rounds and was not included in the
timed interval.

For offset 0, the two variants were essentially the same. For
misaligned destinations (offsets 1..7 averaged), keeping those sizes in
the fixed-size switch took about:

    32-byte memcpy: 0.410 us
    48-byte memcpy: 0.411 us
    64-byte memcpy: 0.426 us
    80-byte memcpy: 0.426 us
    96-byte memcpy: 0.428 us

Redirecting the same misaligned cases to the generic
__memcpy_flushcache() path took about:

    32-byte memcpy: 0.962 us
    48-byte memcpy: 0.956 us
    64-byte memcpy: 0.923 us
    80-byte memcpy: 0.998 us
    96-byte memcpy: 1.001 us

So based on these measurements, the extra alignment check is not buying
us anything here. It consistently makes the misaligned 32/48/64/80/96
cases slower by redirecting them to the generic path.

I will drop the separate alignment check and fold 32/48/64/80/96 into
the main fixed-size switch in the next version.

Thanks,
Zhe

