Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C2EBCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 06:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE6B8E0006; Thu,  2 Oct 2025 02:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF568E0002; Thu,  2 Oct 2025 02:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4D38E0006; Thu,  2 Oct 2025 02:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2358E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:04:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E590EC0364
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 06:04:22 +0000 (UTC)
X-FDA: 83952134364.17.721EC14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DAADD1C0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 06:04:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g3WOkiMF;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759385061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FjDtJjFnHe2sKO7HnP41TDIcn8oYW9XNelIhbwZ0hk=;
	b=CyzejogjhMzARyjpqLJarAJCVXjAbu31RhBpw+/+WFdzi3CHS2nd/AYru9LOQzT3OYuugZ
	ZBcuOFG7c3Kcty9dNkEW2MZZS5qethhFIB3l231yziuR+7oFP6k+7DaIB5lhkBFEhBbTJF
	HqjUCfLPoLXaNfcY2Zsj3otqYlR8N4A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g3WOkiMF;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759385061; a=rsa-sha256;
	cv=none;
	b=tM0P3b3vmkUotgurCgbvrTtBLUngFRXbASVX3RZr1SyQgPMZrNeML9Ko+aKZjX+ltuQ4bS
	GGb+0MuoJr8voauiR23b0aS/qYN3VU5aieC99tcCczz3GaJhTuUD01UX/QJrrqnjatJraZ
	zvqTb+PZMdfq6FYXqmgl89BY2wTru5s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 918EA449F3
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 06:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4ABC4CEF9
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 06:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759385059;
	bh=RFTTVyh3kUP81qOt4dxxTZw3WYZjPzq+l2W5DZN7oJw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=g3WOkiMFtEgu+tdrWr8H1WesNXS+Tk9eLDuAtnzfThKZZ9NXdAXPg5gJsjkjbPa9m
	 B+Yz3GRDhaCU7ELp1JiJwJpVxSLeJ4H179/gelW4+SEZ3iZ9Lk+nR4TRqeCqGUhmyR
	 5hz/T/wgBbZCKi6z4GPAqypje631OCsQ+Tfym1kjDs8v+h7ba+d7w0yAZK4MiUMXCk
	 2AZcuY7hFJDMySh3Q08oiPh0RGHO2xfX5MSC/DGyJ9kz8VVd0xk5jaSMzNEXLr7RRb
	 ORedev+uiYxn0V3FYlf8qVppbI3NUuPYTchSOwYhkJtqjTwhP4qhbk+u8wCwpKKzdu
	 TRY+aiJojDCZQ==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-74435335177so34164347b3.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 23:04:19 -0700 (PDT)
X-Gm-Message-State: AOJu0YxCFX7r/GDdhsRsnBCv0FTPsYRIkaUbt595H+pq3MhhPghPdly+
	oiA12Xz6/mDjSVj6MO02ToHBdf+gquGh4O9U7JKbkJGWKkNiyKVo1TJKwERbJhcZFiX4lxRaJTM
	wgA/PwQSgGeKuirjTLvMzUTK7FStHd7KXcOk+9lcahA==
X-Google-Smtp-Source: AGHT+IHjwDDGmgCdTueLBLU/rfZbRkTwcaAE3UH9nD2IMvYg0UMlFcb3GwSe1d5a2SjTn6axfHVfUxEJ7LpYOFDHubs=
X-Received: by 2002:a05:690e:1cb:b0:637:cde3:c6f6 with SMTP id
 956f58d0204a3-63b83aa5722mr2125970d50.10.1759385058686; Wed, 01 Oct 2025
 23:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <20251001043436.41338-1-bhe@redhat.com>
In-Reply-To: <20251001043436.41338-1-bhe@redhat.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 1 Oct 2025 23:04:06 -0700
X-Gmail-Original-Message-ID: <CACePvbXjLqcz+Smz+woQEKbGdCP3DwgPYvJfLRLPiuHsv7-q_A@mail.gmail.com>
X-Gm-Features: AS18NWCPL0L4zEwuWzH8jsVYp3Wd0Z0CG89SAUd9amzCLWtu7Bw0Rn5-QsPAuds
Message-ID: <CACePvbXjLqcz+Smz+woQEKbGdCP3DwgPYvJfLRLPiuHsv7-q_A@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/swap: remove plist swap_active_head
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6st4yjn14u3od6w45sfgityazsk37y31
X-Rspam-User: 
X-Rspamd-Queue-Id: DAADD1C0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1759385060-453903
X-HE-Meta: U2FsdGVkX18XHP2AIRzpoE/1+W7AI3GFOF74hA62U9at5J+FdWRlrodg77TjAk4aRzngAKud41t2SCgTu/3yYn5Ni2AhvBcW+DZu1oRdClpAM6fd5F512kc2RZKdsGcXwhtftBXDsmCnUDp44ny7n44K3LrtM0BG8fcafZ0APpcQAIxol7xVvknn9V6h/uBYtw31/QPTwNZ656DOhuvMyinMkHrI8hsdrmdNqPt6tALKz9/DZZkxGBOAfISUnJ0q2Mpkyk9HKRzeXD8zZM3L0Cxn7n2YahnmE6hXdRonHvUzo/yIPxCxeYS6+D3KNPI8BhWK7GhNQb8wpzPV+/w+TWkB4mADvlgIeIl+MZDaVr4VdrQ2WPCnUKFSwaoewnifBV5FYwt0pMouGUEkZeVtiMWKqAoUHHK/o2v2FBHDXrP5O1nO/ftZ37qMwOkDb2jwkEKnFEafSFWcpccf/NQsjyoiBFZRcByud2ikuYpyTBEDf24SjDyA0y2E7LeXO6pzT4yONiJgqz3NHfOTDSGkVoq1UABH0MMjepBypdaisuDF0icnr2IaxUW3g6Cuo03ydJXmxFNvuKwHye41++wWO08RA0FPYYiZMXA6fimp28jeIfCn+6i52RNQBsW3jcFsplTh0HFTgM+nETvm3DtVpAdx9wYUPw1JZqRJG/6VK5A3Sei/qOvuDpIsVzyRhKPxideqkKj43cyAdI9t2+84GFohcnr5/BKDVvOJ8Yi3zROpjHJgL/uR+cFxnEtI1pB4iP9EUo7B7BMNty2bxHyRbjVKsUM/0yfM5s4R1I4agdI3kyJBRlDttLmM7uJ0IykzHsaYb4/uCy2v0xOCKwcVWvGEPKPs+1uzRVUZnN2bEtipF9NgIZq03iAOLwFzvtLDJMV/2+On7fRWl9aKxgAdnGE9vIcf0+KwAHHHeq4YKOzKnWgmDf3+OPoxG1EFrRxmAVTGVcUcpgz39/qHYY0
 3Jsa+SfR
 N4T0l6PUGvv/PU/szYNm8itHQwhUKfFJT967+e/ayIugPNy7ygek4mObRKbuJbCfPwZs1rlU9fn3BUjGHNpOPbENhMRb+a6ZBCGwqjKAPGofvaHXzkhcZ7f4LKddkUAWznfTAPc7FImmfWbpBojnxLcfFnobbJquvKukR+dSM/BOPd+HK3uZim8QLkdFS23BuspbXeSMc5wMfNzDeDOqd1XLlf7b/Itdnn7lFk+KaVOUgpFb0Btn11J8qNhaHBrK/HbSwUYaI2Ic8W7kNoAVjM/eMmho2Oq2r1mQ3B+qliJYTVJsX0QxhbEooxGvZGGjrA3MIRxN9jK3b2Db3cZlfo4/3qbWdB/VKRFMBA/Mw7mLBH0fN4s26rHWZ8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 9:34=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>

Can you please confirm or deny this series is depend on the "[PATCH v3
0/2] mm/swapfile.c: select the swap device with default priority round
robin" series.

If it is depend on that series, you need to declare that in the
beginning, so Andrew will not try to apply it without the depended
series.

> In mm/swapfile.c, there are two plist variables, swap_active_head and
> swap_avail_head. swap_avail_head contains all available (active, not full=
)
> swap_info_structs orderred by priority. While swap_active_head contains

Nit: spelling : orderred -> ordered

> all active swap_info_structs (active, nor full and full) orderred by

Same here, ordered.

> priority. Earlier, it serves three purposes:
>
> 1) When swapoff one swap device in the middle, swap devices of priority
>    lower than the swapped off swap device will be promoted up value one,
>    e.g, I swapped off zram1 of priority '-3', then zram2 promoted to
>    have priority '-3', zram3 has priority '-4'. This is done via plist
>    swap_active_head.
>    - This code has been taken off in
>      - [PATCH v3 0/2] mm/swapfile.c: select the swap device with default =
priority round robin

See above, if there is patch dependency, declare it early.

> # swapon
> NAME       TYPE      SIZE USED PRIO
> /dev/zram0 partition  16G   0B   -2
> /dev/zram1 partition  16G   0B   -3
> /dev/zram2 partition  16G   0B   -4
> /dev/zram3 partition  16G   0B   -5

I am a bit confused. If the "[PATCH v3 0/2] mm/swapfile.c: select the
swap device with default priority round robin" series already change
the default priority to -1. How does it get the -2 -3 -4 -5? You seems
describe the behavior before that revert series. Can you please
clarify.

> # swapoff /dev/zram1
> # swapon
> NAME       TYPE      SIZE USED PRIO
> /dev/zram0 partition  16G   0B   -2
> /dev/zram2 partition  16G   0B   -3
> /dev/zram3 partition  16G   0B   -4

Is that the behavior before your reverting node id for swapfile series?
Assume it has patch dependency on the earlier series. Wouldn't better
you describe the behavior after the round robin series and how you can
do better?

> 2) Find a swap device in swap_active_head when swap off.
>    - This can be done through iterating swap_info[] instead. Change is
>      done in patch 2.

Can you please clarify what is the benefit of remove plist swap_active_head=
?
e.g. Does it simply the code or make swap code perform better.

> 3) Judge if there's any active swap device via __has_usable_swap().
>    - This can be done by checking total_swap_pages instead. Change is
>      done in patch 1.
>
> Among them, the purpose 1) is the most important, while it has been
> taken off in below patchset. So this patchset removing swap_active_head
> sits on top of it.
> - [PATCH v3 0/2] mm/swapfile.c: select the swap device with default prior=
ity round robin
>   - https://lore.kernel.org/all/20250930063311.14126-1-bhe@redhat.com/T/#=
u

It seems you mean to say this patch series is depend on that PATCH v3 serie=
s.

Chris

>
> Baoquan He (3):
>   mm/swapfile.c: remove __has_usable_swap()
>   mm/swapfile.c: use swap_info[] to find the swap device
>   mm/swap: remove unneeded swap_active_head
>
>  include/linux/swap.h |  1 -
>  mm/swapfile.c        | 31 ++++++++-----------------------
>  2 files changed, 8 insertions(+), 24 deletions(-)
>
> --
> 2.41.0
>

