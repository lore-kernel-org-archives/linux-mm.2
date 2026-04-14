Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63AB6F9D0E2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 16:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D59D6B0088; Tue, 14 Apr 2026 12:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685EC6B0089; Tue, 14 Apr 2026 12:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C956B0092; Tue, 14 Apr 2026 12:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 491D56B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:18:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC74F1A013F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:18:37 +0000 (UTC)
X-FDA: 84657669474.23.3503A73
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf01.hostedemail.com (Postfix) with ESMTP id EB96D4000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:18:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776183516; a=rsa-sha256;
	cv=none;
	b=HlsS2don8zixiLovVKZMEaVCMQjA4Mpfh+snICFpTH6opaBVFxACXR2eGwsYQxJhB/Umjp
	BS1gP+9g2x3YsPHJKXTC8kSp7mWkeh/UZYKJvksNYfnJ82gjc9AfDuMMG/TUrN5QNn+gab
	H3+PySLeQHFVyX6hp0Hq4djrjSJSrrg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776183516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gs8Cc3nh8hsYbUOOkw1g5KV8i/zPS2ncWdssY75tBXk=;
	b=ICkDoCPgmVoRIUOC2BlHwIvuRvnphSTTZD7xD5oSDs7piahMGdYfZfmV/oKR6pawYRpEEF
	1EpvP9iZdPHCi6n0IUvA+UL3wWlnta80nO2G70eqZGoJjHA91wCNVJLxPZxGtpb/MoTUQ3
	fZqMe9fsBZb015Q/U+FtNx/DiL6Rpqk=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 15 Apr 2026 01:18:31 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 15 Apr 2026 01:18:31 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] PM: hibernate: preserve uswsusp swap pin across
 SNAPSHOT_SET_SWAP_AREA re-set failures
Message-ID: <ad5o1z1hSzLtUxMo@yjaykim-PowerEdge-T330>
References: <20260414143200.1267932-1-charsyam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414143200.1267932-1-charsyam@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB96D4000A
X-Stat-Signature: digzibn5wzo6etw53itnpyq86i4kn5zy
X-HE-Tag: 1776183514-973639
X-HE-Meta: U2FsdGVkX18nquq2FZFiu6X4vCthDAM4laipGSBfyeOvSMdlsIMjjQ7CcXSzlc2fuxwnTY4r8YdbIXce56XkJEkk5zKXoE/KIDNBAPqqlZZ+nYqq2+BwFdKmMjZzi1aIooINiQ/fAzQlJ0nPv0kCgktFDmrC8gEmNyxpkQ8mPUmFeDFehOGbYDjsOCp4TkQYJFgQZiQp4ctRfjc3oV61IT65SYqECEQDAjCP+l2EtjHRrZzHvzpdncGPQlT+Gz2kjpdEFnpsJJZznu+UGYmydRlENwTN1K/nUg4Nqo8aXIQsjOQP9WClI1KD/eNz6HMnWsfL50mbZO+u1Bar/+PbgIVjwTCX4T0nx5p6NJHPoDz4Ri6p2S905fzPocSmG21DcXMRr5ywAd4S/xWNdg59g3TfnoUxLnVVzuPnt5Qrz7c68X/KdtxNgmBn3J524dSv3HpZVIx8dVJwRQPdPHChI3AywWBKk9Qzbaqeh/mxRbamLuZXTOKv0arAXFPd0nffijdq9ovEbJ4ZweINjNxNcETCHl2mNTHJmMMvxKGeHRvkycbuBq41mWbj+4I4MZhra2Wck7v1joDHN9ohE1wMk12Cu9T/iC7voSFNgVfnXgG63EoL/+dmbwAIUVXa8M4MWZ4IuK7C27LsGv7SjpPN6CwwcTI4FIhDWmNuUnoeWrJMLWUDSLfYUwoU34G/t7mmv1o5g7WQMAAy39h573D5db+0ui4Jrv1hRBt6nAtMHg3+etTJnnAWdLvBz4B/kJc5oDieAYE9269H7d17okKpKUBI+kdt9G64ad034pwSM8fnOaBXVcLrunGBvTEsvEdnll++tsWlgyNRIHWBf1FX2Vz+THXx8jVt6WDt7ZFTN7P2qmeIG7U8fs8GZXbMyweWF+kpsD6TBwsGg0XPUv/nIXmMKxETZ3bQQQjtGHgHdDKcyH5cPPwtkcdE5J5OU3d9dII7b2iJTxMgL9zmPpP
 F5Dbc2cR
 u9hccI/H1HMe9Fvxm4UpLTd1kfFxB7hFlJ2vwRbXobtq9jWbJ/KUu4SU1hXsKCxHQSzBshJAMfvsiS/enhre3Sy7I0SgWjbUzhQzpE6TaQnL1obksWUrwFQnoBel/GY69RTHPn4srqKVcFFuk6mnzYUvVe/jrH/rZrwrBmhhM991xGGm6CKE44SdXsGDhuVhAKl/BHieX/Y9A7mSwmxXNsCctds9cb2Nn7pk0YSuTu/jLXVzYraeiFUeb0vzYDnefnZ8nBtrIfCrwIwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:32:00PM +0900, DaeMyung Kang wrote:

Hi Daemyung :)

> Commit 5b2b0c6e4577 ("mm/swap, PM: hibernate: fix swapoff
> race in uswsusp by pinning swap device") introduced
> SWP_HIBERNATION so that the swap device chosen via
> /dev/snapshot is held against swapoff for the entire uswsusp
> session. The intended invariant is: from the first successful
> SNAPSHOT_SET_SWAP_AREA until the /dev/snapshot fd is closed,
> exactly one swap device is pinned.
>
> snapshot_set_swap_area() breaks that invariant on the re-set
> path:
>
>       unpin_hibernation_swap_type(data->swap);
>       data->swap = pin_hibernation_swap_type(swdev, offset);
>       if (data->swap < 0)
>               return swdev ? -ENODEV : -EINVAL;
>
> The unpin happens unconditionally before the new pin is
> attempted. If the new pin fails (e.g. user space supplies an
> offset/device that is not an active swap area), the session
> continues with no swap device pinned, reopening exactly the
> swapoff race the original commit was meant to close. A
> subsequent swapoff on the previously selected device now
> succeeds where it would have been blocked with EBUSY.

Hmm.. This was actually intentional.  The API semantic
is that a second SNAPSHOT_SET_SWAP_AREA abandons the
previous pin.  If the new pin fails, the ioctl returns
an error and userspace is responsible for aborting the
session -- proceeding without a pinned device makes no
sense.

The only benefit of preserving the old pin on failure
would be protecting against userspace that ignores the
error.  But even in that case, the session has no valid
swap target, so the hibernation image write itself
would fail before swapoff becomes a concern.  I think
this is an edge case rather than a bug.

IOW, Looking at your test case, I think this part is
userspace's responsibility:

>       ret = snapshot_set_swap_area(fd, bogus_dev, 0);
>       if (!ret) {
>               fprintf(stderr,
>                       "step6: bogus SNAPSHOT_SET_SWAP_AREA unexpectedly succeeded\n");
>               close(fd);
>               return 2;
>       }

The ioctl has already returned an error here.  Userspace
should close /dev/snapshot and stop, not continue and
expect the old pin to still be in place.

(BTW, the tests are well written and easy to follow.
Thanks!)

For this patch to have real value, there should be
something that concretely breaks after the swapoff
succeeds.  But since the session has no valid swap
target at that point, is there any actual broken
behavior that follows?

>       if (!buggy) {
>               if (swapoff(swap_path_2) < 0) {
>                       fprintf(stderr,
>                               "step8: swapoff(%s) after close failed: %s\n",
>                               swap_path_2, strerror(errno));
>                       return 2;
>               }
>               printf("step8: swapoff succeeded after closing /dev/snapshot\n");
>       }

If you still see concrete value, I would be happy to
take this as an improvement (without Fixes: and
Cc: stable) -- see my suggestion below for a lighter
approach.

> Reordering pin/unpin in the caller cannot fix this
> cleanly. Each of pin_hibernation_swap_type() /
> unpin_hibernation_swap_type() acquires swap_lock
> independently, so any two-call sequence leaves a window
> in which swapoff can observe an inconsistent pin state.
> The same-area re-set case (type == old_type) also cannot
> be expressed with pin+unpin without either toggling the
> bit (racy) or returning EBUSY (a false error).
>
> Introduce repin_hibernation_swap_type(), which performs
> the transition atomically under a single swap_lock
> acquisition:

I understand the intent.  If you still see enough value
in preserving the pin on failure, I would suggest a
lighter approach -- see below.

> -     unpin_hibernation_swap_type(data->swap);
> -
> -     data->swap = pin_hibernation_swap_type(swdev, offset);
> -     if (data->swap < 0)
> +     swap = repin_hibernation_swap_type(data->swap, swdev,
> +                                        offset);
> +     if (swap < 0)
>               return swdev ? -ENODEV : -EINVAL;
> +     data->swap = swap;

Would it be simpler to use find_hibernation_swap_type()
to look up the new type first, and if it differs from
data->swap, call pin_hibernation_swap_type() on the new
one?  If pin succeeds, unpin the old one.  If it returns
-EBUSY, just keep the existing pin.

If swapoff sneaks in between find and pin, pin will
simply fail -- I don't think the kernel needs to
guarantee atomicity for that window.  This does acquire
swap_lock multiple times, but SNAPSHOT_SET_SWAP_AREA is
an extremely rare operation, so the extra lock
round-trips should be negligible.

Reusing the existing helpers seems preferable to adding
a new function with this much code for a single call
site.

How do you think?

Thanks again!
Youngjun Park

