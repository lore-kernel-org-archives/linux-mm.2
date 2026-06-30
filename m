Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5668FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE586B00B8; Tue, 30 Jun 2026 09:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5836B00B9; Tue, 30 Jun 2026 09:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA1A6B00BA; Tue, 30 Jun 2026 09:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E76C56B00B8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:29:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 610861A04C0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:29:27 +0000 (UTC)
X-FDA: 84936660774.22.3C80EA0
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf29.hostedemail.com (Postfix) with ESMTP id 38F24120006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:29:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=gDOn6Ibq;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="U 2Sz2qW";
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.145 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782826165;
	b=yXzmZmfcVUBNbuiy+hwlWMlbjG7ng+ObRaWAMUeCAIH15kpxG0oblgTMNKzdGTAuQz5NtQ
	nkRCDIVoxdzi8vcpyg3rwTbopbKAP0Z4wdtkQpWdUsEzHaM6r5UDuZJcXXb0f7nP/FIt0S
	xAq6B2jb1c/sz1YBO07YB4Zd7e5Bu3k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782826165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmrQNTItky/UiuZPOpMv0EVeheRMp8r3GydTi1+jvvU=;
	b=cThG4cnpbZB8CvQW/Kzg6e/Q2qfJVjDoot4RRynyugcEYKtpXW2MZw7vsLK8Fzq8Rjlwz8
	C7IxvO0PNvcz2Dwdg3rWkA2hxrbG2EUJ6Aa6wOwsXFw7uxNIyBEuS7Dxd09Vcx1jx3Xdso
	9sIoTUSDH3tvojV48em1oTa+nh9X4kE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=gDOn6Ibq;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="U 2Sz2qW";
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.145 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 928AEEC00A1;
	Tue, 30 Jun 2026 09:29:24 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Tue, 30 Jun 2026 09:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1782826164;
	 x=1782912564; bh=DmrQNTItky/UiuZPOpMv0EVeheRMp8r3GydTi1+jvvU=; b=
	gDOn6IbqlLF+rTLJJVd2GPPiUPxU+sRFV4HoMABp87+3SwXvfitPGVvrw4g6qQcH
	k2cnZShyeoYlQjukVowJBUY3VMkWGA2T2VbS71TqIJxmCbS5vzGwBI6Fpic831Dm
	JJXmNBwr1dLNr7xeItG5jXbTcQpkEGbpnMw9Ul94W5OVwINpsx1nsoZwpFrZmt2j
	yyh5yFJtuECsdWonXEnb0ClcQzdMWdIbk8c6EOU9IEPTIZe9zzywdDc0sXAsY1Gr
	Qhpku+vp7H3gtTwo5TxnDXCyMpTIjiRcjmFg5uPGEjHhNFMWZ8/8QvsUQZBabEpZ
	D26MJV4qb+IG2ESMoLxXtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782826164; x=
	1782912564; bh=DmrQNTItky/UiuZPOpMv0EVeheRMp8r3GydTi1+jvvU=; b=U
	2Sz2qW1gSOPgMObKuVV2YI42GKrQhdzQzAgPWxK3W11CX5zc04Bu2KiJHyqTv3Cs
	5f/i03fSvGFvwBIFNwWqKaiUHNxn1/YGIX7xjRmTXp+EEmZY9H0B1dcUXY69bIfs
	O9YJZ8/jgQ01aMUqnJxH5OH80Msr0n6LnCQfH/SgQvn8KSyI7WemMZVPXgOjIkzG
	iafhPik9MjtUPywDw+jiDJVlc6vhl3AYR9w+EMdZUYB5FbKxbTLJ8rs4zap1Ksn+
	eq2tAsgc3jU1GeeQGPa0vjLIVZzAUFaPtVLGMnKUeZFthBWOZuzLoaCQhDuiwZiX
	LCc7xVzPhgSSa2oxZy3hw==
X-ME-Sender: <xms:s8RDanlQmxMBGZ2_V3c8hHeK2DamYOZAKm2MFxnvnrHjQXXcEl7liw>
    <xme:s8RDalrNiNzznp_KWVyn_dGzFoOfzt3hHKnKwcJdns3fYr0MmujBDyR-xnJ94KVZC
    1fgoMbAGZJUr-fMNhrQSmnCiDSNxjo6Pyy_YQMkQ-02icqDAPVOCw>
X-ME-Proxy-Cause: dmFkZTFOc8kySVJaarJn+yOM4lWnvgTo8fH8pNsiBSOy3Wlxie2uyHPLm8RU9hRXTPadfd
    VplZMh4dQE2IFFVv08Z/Mg7w7fkT9dvWYuzilA9wynMup1c5MnGCKUibzHtnIH2nk5Ezuq
    kkmM0tmoxSB2W2a5nI9lxCKY7xgQQCKbFnEUeH6wh4Uy4vR7BjSeCnQB94Cbb7iFr1L2j3
    WCsiK6SAuPxVElZ+Tn8QQm2DcbfiuPxXujVl7tC57fTWo7OE7M9HnpgVvznow7AxFXX8Rc
    //4a9WXCZmtP7MrNLuW2qWwdBwwKTUSqSqtoXW30l6qtyJOZ3ttdJ5RiOlUZYUr8YESfAj
    NjWpzaR+KfJeu3PvgOAKQ1RlrsbhFbS2S2dFNeSjtrPC+jQKE5e03zGI1HC/FPJn8XZ3Ur
    jhyhtvO3x12/TUQ4KIh16OGDaP717xQ17u9TKr5yxedFD8ChD8shLECyYMgtXFi26cA77K
    6fgkuPGjeoSd+zfJajKZvkV7/by5fAof+d7Wwu4uZ/Pyub+wplO0ecfJLwBAQrPeTz8lI/
    p6KZJcSqNLKxBz9cT1ywzMNrXo4tJjui2Vvcf1C/S9zmrM9cuTiudZgUBps2LyFDsJeIXp
    IPn0+oUPu0v5ma7acft1jGwqEA86HRXjSbmDTm5c+Vh2guohGDiYdVlXZ0iw
X-ME-Proxy: <xmx:s8RDar041n2dZ7qGLUpXpmPMmPtitS0dv6aSQGRJT8UK4e8RV0jRqg>
    <xmx:tMRDatzpMd3JIIWC1lq6rp9LQYDeNsyao8a0ougTnd9lqWhRbEOwDw>
    <xmx:tMRDakiIoyys-h98bM1FFUUnRSd7hwhTi0Iw2ATjkmFIlpGhxoFgLA>
    <xmx:tMRDaiP-8TAEkuAr6Y8KiF1O_9wlCdVRVzlofmLsMa5Fj6hkUiK2BQ>
    <xmx:tMRDaqGIMoKsG--JyKaWiJ7bODNDXUoeKFYnKM-4bhvKAaUfx8xcetEo>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DCBB7182007E; Tue, 30 Jun 2026 09:29:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AzfP_w-3vYjw
Date: Tue, 30 Jun 2026 15:29:03 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrew Morton" <akpm@linux-foundation.org>,
 "SeongJae Park" <sj@kernel.org>
Cc: "Arnd Bergmann" <arnd@kernel.org>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 "Ravi Jonnalagadda" <ravis.opensrc@gmail.com>,
 "Quanmin Yan" <yanquanmin1@huawei.com>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Message-Id: <0c57d639-259c-4498-9b7f-3ac46d669935@app.fastmail.com>
In-Reply-To: <20260627223405.3533412b4010b6ce658da01f@linux-foundation.org>
References: <20260611125704.3386176-1-arnd@kernel.org>
 <20260611135608.66888-1-sj@kernel.org>
 <20260627223405.3533412b4010b6ce658da01f@linux-foundation.org>
Subject: Re: [PATCH] mm/damon/core: reduce kernel stack usage
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8wzh19fd4znzi514m5rsmrbfngrjcaxo
X-Rspam-User: 
X-Rspamd-Queue-Id: 38F24120006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782826165-937481
X-HE-Meta: U2FsdGVkX1/BWaIIAuVD7YQFpBIaDWUZv7OacviU134Uie0ORboMDk4/BTpZpEyLbMAQFSK01LCqGiMFm5DrRTAke7wS5QbIIms6WA930zjtHrr2gLZYfcb3zn/Z3vNUnN5aF8Q7S6NppF4j6NxVlDY/bNU65vXtpR+ko/wCqb5jVbq4gLuYR495zgjRQFXvH+RMqglZe7heq2qKu8lFkOQ24oTXWVns9ixE42dKGGfiUTNG/KanZ7HFhdin/y20NW1uJM4e5ZANykAIwXyYOddx0W52E1+36CYPwYHzRDC5vx2zRIwAicO6IyxJfJmVws8DfdVdm7m6sMbDpJ3lWkIKqKIcYDgT6NhgOKDD2O1lYDINFXviVCVvT42voeLx9HgLlpxkT9AuCeewcW0/VFB+FzC2Ih9/HBRYoPxi6njG6RnOriBqqY5dvFFaoVXtDoI+ZAuX9yZIdHaGRApr+r4pziNGag5gD2TcDgQc4h7husrUvtmcik6d/rabeIABGznGctyfdkPs7psGV21yUbLwFIQDa/RjHxW88AkHTBWdl+rckyC0LQKmix/E3ZfIwnucIwYEm6sPoT5zC+t/UHJcQ7R9mMqAlzZzbbcSN+70pX/3LIKPh+F2B+or4zgiW0P7gjYkywJyYqnK4qvhN2GZHTlh5RMepbqlXeYnqNeuk+V26qAnZXtaD6S/NTGteSZHOzga7ab8mGWuft+xvsMjk4e2HQLyXFTVCERrNEX4bUJ5P5+srBjc3cqjKk3VgdKLU+lS506DAx00Gy+fCP3y3qSHaZ+YhqXpiS4kadeuEHAPHGkeI/0E/gI9f85OdUJPechR5zcBTFGM4cnARQtuchUP1Klsp0Kqy2YBrm6n5mTDb4KoM9xhlaX9PtYHJHhtm4aJQjFfMPf7KT4juJOGwJSPSpen1+60rawbgVNgPvT36QQI78T8eUjbj6CKKqndiO7Sj+KVoCjV2Zj
 EYHeY5a7
 o+JiduulF3I2DdcDYSPzsWx+xjmfuWfOfO/LSantvJoXxJgN6lQ6GxcQWQaDOaaGhalPMefRIJMa1lb0+v2SRJvgSYkg4oq6pYp/k3oZoN/ZicyLtKzamTmeBfHpVs7Lrd0Q5ryiB4ZDVD3f31fjuqcROzIs9OsQMdKmfKXqsPDUu55gYNIYffuNvjPiQDbX8s8dNMRPK901bRnd/uAm5KJCB7QlaTTOTxLD8E3f7dVK7TezOixfoo+UZh5lcta3tNgG1XwuufdVTqGN/IdasqcgPB0QUiwY/OySjioEZj3oRktKt0SMZLeURBqOt0llklYI/4MhUZfoSPszRbhoATXDVTRxRqWMOHE8dGIXiZBCEuro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026, at 07:34, Andrew Morton wrote:
> On Thu, 11 Jun 2026 06:56:07 -0700 SeongJae Park <sj@kernel.org> wrote:
>
>> On Thu, 11 Jun 2026 14:56:57 +0200 Arnd Bergmann <arnd@kernel.org> wrote:
>> 
>> > From: Arnd Bergmann <arnd@arndb.de>
>> > 
>> > The main thread function has recently grown to the point of
>> > exceeding stack frame size warning limits in some configurations.
>> > This is what I hit on s390 with clang and CONFIG_KASAN:
>> > 
>> > mm/damon/core.c:3440:31: error: stack frame size (1352) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
>> >  3440 | static int kdamond_fn(struct damon_ctx *ctx)
>
> Well cheers to s390 for using a nice tight stack limit.

To clarify, this is a stack limit that I use for my randconfig build
across architectures, the default limit on allmodconfig is still 2048
bytes, and s390 generally needs a little more stack than most
other architectures.

>
>> > The largest stack usage here is inside of the kdamond_tune_intervals(),
>> > so by marking that one as noinline_for_stack, the functions individually
>> > stay below the warning limit, though kdamond_fn() itself still uses
>> > hundreds of kilobytes for some reason.
>
> Wait what wut.  This cannot mean that kdamond_fn() uses x00,000 bytes of
> stack, so what does it mean?

bytes, not kilobytes, sorry for the typo!

>> Should we add Fixes: and Cc: stable@ too?  This function was introduced by
>> commit f04b0fedbe71 ("mm/damon/core: implement intervals auto-tuning") which
>> was merged into 6.15.
>
> I don't think so - kernel is full of these offenders and it will be a
> long and painstaking process to weed them out.

I'm mainly pushing back on regressions when they happen. In my test
tree, I have a patch that adds a few bytes for Kconfig options that
cause particularly large stack frames (CONFIG_KASAN_STACK,
CONFIG_KASAN, CONFIG_64BIT, CONFIG_UBSAN_ALIGNMENT) but otherwise
use the traditional 1024 byte limit, and I send patches when I
run into any function that uses more. I have never managed to
get my backlog small enough to actually send the patch that
changes the default limits.

Right now I have

5bd54760fba1 [SUBMITTED 20260622] drm/amd/display: kunit: move dc_link objects off stack
262678481abf [SUBMITTED 20260618] usb: ucsi: huawei_gaokun: move typec_altmode off stack
2cb955c0b224 [SUBMITTED 20260618] media: v4l2-tpg: reduce stack usage for kasan builds
dfdc80171d8d [SUBMITTED 20260612] mlx5: avoid frame overflow warning
e252ac86b090 [SUBMITTED 20260611] drm/amd/display: avoid large stack allocation in 
97582da9074d [SUBMITTED 20260611] [wireless-next] wifi: mac80211: allocate backup ieee80211_nan_sched_cfg off stack
2f707af98b86 [SUBMITTED 20260611] mm/damon/core: reduce kernel stack usage
9fe35d5f1de6 [SUBMITTED 20260526] zstd: reducing inlining for KASAN_STACK
82daa7698bbe [SUBMITTED 20260520] fat: avoid stack overflow warning
dd7d4b16c1d0 [SUBMITTED 20260515] bpf: test_run: reduce kernel stack usage
75b3f86afb91 [SUBMITTED 20260515] irqchip/ast2700-intc: reduce stack usage in kunit tests
c5d5e99dfe31 [SUBMITTED 20250620] perf/arm-cmn: reduce stack usage in arm_cmn_probe()
80587b5964a1 [SUBMITTED 20250620] coredump: reduce stack usage in vfs_coredump()
89e40670333d [SUBMITTED 20250620] lib/tests: split randstruct initializer tests
723381a3739f [SUBMITTED 20250620] binfmt_elf: reduce stackusage in kunit test
9f7e36aa0b81 [SUBMITTED 20250620] [RFC] net/mlx5: don't build with CONFIG_CPUMASK_OFFSTACK
7a5ea46be400 [SUBMITTED 20250620] coresight: fix building with CONFIG_CPUMASK_OFFSTACK
40398f198b2b [SUBMITTED 20250610] drm/radeon: reduce stack frame size for radeon_cs_ioctl
b52879e6b419 [SUBMITTED 20250221] ntb: reduce stack usage in idt_scan_mws

and some patches that I have never sent so far. This is clearly an
uphill battle, but kernel stack overflows are a real and build testing
with a reasonably small limit is only one line of defense against these.

     Arnd

