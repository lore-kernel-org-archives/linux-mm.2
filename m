Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811D0606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 01:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ji1T0vik
Received: by kanga.kvack.org (Postfix)
	id 8FFE26B05B6; Mon, 26 Oct 2026 21:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8895C6B05B7; Mon, 26 Oct 2026 21:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753386B05B8; Mon, 26 Oct 2026 21:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5DD6B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:40:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7B7F1405E9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:40:39 +0000 (UTC)
X-FDA: 85366701798.17.3DA563F
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7DB101A0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:40:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ji1T0vik;
	spf=pass (imf19.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793065237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrPCgCR6mBUX3MhIsaxSBayJHSlp6Zq7G4BS5OHlkcw=;
	b=pNk9m4B4FPwRn+N4Tzp6xL6YzkgAfm69HX5IL+puYOYak/OTRWC+Y0XsJvTRLl3RfW30M+
	y9fkIxprijzgPzrtDA5MOvNH9xr3Ux2jhgWN+BbPehRit2Lx6WKyCpiuXjjRclmK863dU2
	5JfG7yveQAEOfcOjSKi3/QQYSumx+qw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ji1T0vik;
	spf=pass (imf19.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793065237;
	b=3YzlvLYPNqFGH1clZpAnNlywwHr/2kOlUPhKaRtWDWNsKd/d+9XtB4Qgj1HweTGPeTehuW
	eUK/3Tfw7lIup5X4x7GfxJdp7kUv2FeklFHwUcOzhUsTOZ6+7tmAVT2fKe3AMogg+a14IW
	uw8GnIygjMo6FP9jpdrSES/vEWmHHms=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793065232; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=NrPCgCR6mBUX3MhIsaxSBayJHSlp6Zq7G4BS5OHlkcw=;
	b=ji1T0vikzX2fjraQ3F9PRgxJT2WFQxzDUPbC/AUJ1VIx0/VxwiAPQmKZTZOUgJ0PvGDxGg64DpKs4bdAU6VbI4xtzLpg5QkmTPV+nohgQGMCBevemPwqO4vRzICl8Gv0f4JGJyvMM5UQ+XdZLF0TJUE7AeYAg7ErDHyLFf9bO28=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XDc33Cj_1793065231;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XDc33Cj_1793065231 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 09:40:31 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org,  david@kernel.org,  Kaitao Cheng
 <kaitao.cheng@linux.dev>,  vbabka@kernel.org,  ljs@kernel.org,
  liam@infradead.org,  rppt@kernel.org,  surenb@google.com,
  mhocko@suse.com,  linmiaohe@huawei.com,  nao.horiguchi@gmail.com,
  ziy@nvidia.com,  wangkefeng.wang@huawei.com,  tujinjiang@huawei.com,
  mgorman@techsingularity.net,  chengkaitao@kylinos.cn,
  muchun.song@linux.dev,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
In-Reply-To: <87pkww7lnl.fsf@DESKTOP-5N7EMDA> (Ying Huang's message of "Mon,
	26 Oct 2026 19:21:02 +0800")
References: <20261026025724.1430747-1-xiangzao@linux.alibaba.com>
	<87pkww7lnl.fsf@DESKTOP-5N7EMDA>
Date: Tue, 27 Oct 2026 09:40:30 +0800
Message-ID: <877bj37wfl.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DB101A0002
X-Stat-Signature: egmi6mtksk13pwwq7ozcfdrj1z9xg4iw
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793065236-793518
X-HE-Meta: U2FsdGVkX19IGXzjhKhs5VZ9ljaKYTmY9tzHgh72q1MR3U4fKhZjWHveumxv4WYAGvxvK2+3VFqRMxvh7rM1TTvx3IdedRCzQMWp358P7QceEVTGnp29say1ralOpDPpgQHcw35vpbFQZAhqkkdrThHCHrPU8VX84p+0qWvjVTnk3FY+lv2ewUO+f0Wwd6lpBj4LO3pknSWlTF3jmoqS7kgZyy6PVFWtMvdK9k749d3V1brMqtAguG+5T5OaaM7gJeOBDTYeAHbNyJhR/b7JCc/RwRBKCQdmno8OIJYqtYA/HNnZBgc9t+oM15C1RcUAqelYkldH5Y6k//3BtNajanwCeZMz1M536v8AoLZ3jYMGn1US+TqQanWba8QitcF+OAf9jFN5zpqX7ovYWH+n91796gHDCj48lxdKSefY2kEUpl6nlC0EPYC+N7QXIBp1o+nwWRngThY1iohV7/2Y/v+V13DryuSqWLUKbxUKraSMRLezl558jaZ1uXuijdeoJCY54niFOWz/vs0EwGlMz6DdmWqKFeq0qZsVb1HrJvlCkzvlGXck+JwHVWoU3ArLUH0bU0f8W4o0qGrU0cWft/zzFODxZIMFulGlbChH/5KA46ZT0a7F0rIEHE4on72UPd35a14wtkSWAFsVyeHiXFA1jeyONPz7RMTIl9DahiT97xr9/nJjRKa5kAqY3LSaNDBOKJC7ukJfpyx3seBqhR/uBy/vFtMghGosv1KL/4EIY/yyykTX+nB3B8BWYsja9Rpra9lweo83zUMEQbJfaZj3bbo7rANug+sCU13CKNutSYwGNecHynn3gYPTqW6tGNmJh1Lx5TGARaVQWrBBYGwEveg4AwxaF0R3P9ReDHpFZ+dguYwW+MvNbNdURq7DKm0c94lsydm7ZE2fjzDQMQMZZw1lOfgSpxeCjOvQ31aH2NfCLaHPgd72Ldntk0hXDBOnOIdGe5fBXhZMmp9
 t244hRJh
 eTxrm6KT63800tIZ8Izr2B2mx2YJircl34d2eCvmMRp0F1mBvqjpaLzTzK1V628xLspXtwHlp5YyeewyaYfqjz4Ub2xDeS5emKbY7izHRGTLxwa2cq3HLGSGGLDsAr7Z/SzPPxr4+C8yNmctGOWerz6ZpBFDo2Ff7uccy+7UHf2biO/SUgNMT8+EYTGEXFFykU1dDtVj26hFQgWqgqTAMp00wtQCZtUY0WDoBp0Hepo9BI6QitJH0+inXArpB/JSgRi0j+ECZl25L9PU3OkWr41H7kipxZ9voh+zD7GxGthj9fY+NCiIzhiCG9R0tL0C5tkH4nuVPhFF/B/5i4wexdZJPjEnILBFzYj/ORJYUgRK3EDTAD6fOSLyMkbsM5VsS+xSXCctnlaPdBUeG4SB6e7NNA+BPPrQsEw73pfvTnPWbKIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Huang, Ying" <ying.huang@linux.alibaba.com> writes:

> Yuanhe Shu <xiangzao@linux.alibaba.com> writes:
>
>> Where copy_mc_to_kernel is defined, copy_mc_user_highpage() and
>> copy_mc_highpage() stop at a hardware error during the copy, report
>> the not-copied bytes and queue the source page for memory_failure().
>> The !copy_mc fallbacks return 0 after a plain copy instead.  With
>> PG_hwpoison set while the data stays readable - software-injected
>> poison (MADV_HWPOISON, the debugfs corrupt-pfn injector) or a
>> transient hardware error - there is no fault to recover from: the
>> copy completes, the destination folio carries no poison marker, and
>> the poison is consumed silently, the same poison consumption
>> commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
>> THP") refused to risk on the split path.
>
> As far as I know, software-injected poison is used for debugging only ,
> so I don't think it's that important.  Hardware poison state in DDR is
> sticky; that is, even a transient hardware error will cause a permanent
> hardware poison state until a reset.
>
> Therefore, the primary value of this patch should be to reduce machine
> checks (and panics) during memory copies.  If so, we should place the
> check code before copying.
>

Another factor to consider is performance; the change shouldn't hurt
performance.  Please do some performance tests and share the results
too.

---
Best Regards,
Huang, Ying

