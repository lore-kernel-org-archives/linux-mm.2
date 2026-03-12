Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A98106ACC9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087FE6B0005; Thu, 12 Mar 2026 12:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0359A6B0089; Thu, 12 Mar 2026 12:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D1A6B008A; Thu, 12 Mar 2026 12:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D310A6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:44:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25CC213A7B1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:44:47 +0000 (UTC)
X-FDA: 84537985014.03.03C6201
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id F3A2A4000D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:44:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VaeWUJL7;
	spf=pass (imf01.hostedemail.com: domain of lenohou@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773333885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LOBFcwRr7cDkkzBy9+Mi4GSoztUT0vWTqsDc3ruGI7U=;
	b=RnVd48gFKT6t5mXcDQdyqvzC+QF73hQYrIOWINEIYD0JddLqX3XQzlg32iFzoihFAx1faG
	XqQBh8Gro5kt11o8bb65laJkjYf66Q0b41abZRTbBHr2iBh4EBIIm1yNK5Oq9O64fS4GCw
	OVfiJ+H6EwiI+/8TFOeh3fuJqZ5ekq4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773333885; a=rsa-sha256;
	cv=pass;
	b=8Bau7m4nLcm6P+gGiqnzgbXJujO0Rsaxzk/VHD5FyEaHNyzznACblPa0m2IrXmGG9XTvou
	Y5oOsVvF2Ys8GG7GsA/7XICzNUQlhLKvMdtkvBLKqxthdx7f6lKQMswW4jTLcvNjV4YpQX
	dtOfsve0OwK8NzSFLi9+PJ77SNx2PN4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VaeWUJL7;
	spf=pass (imf01.hostedemail.com: domain of lenohou@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-439b9b190easo935976f8f.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:44:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773333883; cv=none;
        d=google.com; s=arc-20240605;
        b=XSeKSRkuSn1TFO5eCossHidm0pgwf2sbP9o5xeSIERQjVnEAzMypkaft3grVuz6NAi
         CxLRPROml6YDijgd9Yb0w+rCFOPhczTgDSgVqe6XYi6sxY0Ifhmu53MKuP/lP52/UoNf
         fKm7lYWPACrNDnrmM23+fe9QO/iEJT2qrvCNC9vPzT+vm+EemHJyY92viMoeNyi71Pby
         v3cMPj/IWXANO+dh+1r1+kiV1swis0Qo+3zv3fo9wxXvn1nbXoIse2xlFMZGbCYOc2yk
         F1VM/DNirAbEwoxgwZpKA/AgJg6EaDq84RPD0tIyKdO9sSq6wTKTg6NQEkH1KeGMoc1T
         khUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LOBFcwRr7cDkkzBy9+Mi4GSoztUT0vWTqsDc3ruGI7U=;
        fh=eoudNMF4IyuNfSmxZ7Nmy95IiT/oUNivRGXm5Fn6Vy4=;
        b=g4DnL0YpG90CP981RaLUY3pwdIEy0F7r0dT7wOrP58wKeCbL32yjofXG2J4tCH9+eU
         2NasZ5wgWQFQvaP8cW7FjxtwC2zSTmPl8SOjCMyFbwV8EBBuCyS4NQEkrnOHSAOZtpCH
         3BssFj4mOPq6cH2zSVPg8TdWEbhq7YwkgSOas65vavtTs2lr7oZ4R6l1PUSo3EKSA4pr
         HN9yN98KnxBkE3EaOQi7/tCJHfFmk3iC1SCwpPQbmwj25gz7LBNqzQ6MVeFQ4dypd3hQ
         pAKbpdQFEJQlgBVgGxDDuqpcgMefbCU2iFVwEUP8oonFuMvfJgMMEkOQEU+gZVezN7f6
         Nlsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773333883; x=1773938683; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOBFcwRr7cDkkzBy9+Mi4GSoztUT0vWTqsDc3ruGI7U=;
        b=VaeWUJL7dbe9Eh+g1IaaOj+JqQ1+mAXv1/R1DDi/UCxlzKUMMoWApIFMHuWwIhwdOS
         hLPXHiOVJIbm20+hVsHEgYTuvhuY2m7u67lx8gtzzD6VzQgTD+mThHgk5oEdJ+lDzqdH
         JPE4uwBeGJaKC3NuZt8g6DlML1U/8046cGxy1oOLCBJfN2NM8y41izlPTbIfN3yGNCfh
         y3AwiFUKuSHZE/Az1ft+wZQq93Gin+O9aFb9po5w0e1TAGfKbUVnMdw8DVfaIrZPOs00
         NviNzTOvj+SeSSeoyoEBhghC4llK22JEKtKldTeI7jJEFVJbHCvNsfJRQPZvwLs7ra+E
         YaPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773333883; x=1773938683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LOBFcwRr7cDkkzBy9+Mi4GSoztUT0vWTqsDc3ruGI7U=;
        b=fVQsA8i+JkkY/w+am550+lFZzboC4lthEGOIV7tb35PP6YzuXulGGg7b93blzlv5Wo
         Ww57VxtyzmMyoPIbYzHoAglNg6+499TDtPtA+tLu4x5xEkV6FWPZJ/7G8qykKRcBWeAF
         tKhBwcxxIfKFsFxlEOCMvJ2Igccp6u6BlAUzeU0DLN6jNEDOsFuicqVOSk7nyT4glMZR
         vbgAoXP2sFYPjxgO6IqO9kZeGjY0wcwRO26PsBik6+Znj2QKXrUx9YWtxhnL5aYcX9HR
         V5tF7HIVR0rEwbakzt4eK5XNtj771E6eOSsSrzwvTXU2zz8nyUDbOB3uhSm+T9coQZo0
         c5bQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaIu6rQ79sKeDL4YcFQxxq1YiTwjoJpQmYd3UbRA8YVCpLB3qI3LMbq4FClaVpBsAKtbFOApHqbw==@kvack.org
X-Gm-Message-State: AOJu0Yz8fGJTozceKGacUaw2kpf94rp2Xu+xnLPVri+21D4Dh1n4hcJD
	EhuyU5tkoaPmDmmkzcSN5bezrM1uH4cIBHYN6XqbFi9uo4n9iKxsS0C0uPwVKtCNxG6ndGsPitH
	rM6qBx2YKk5Emrc41kMt2K10/OXd7XU4=
X-Gm-Gg: ATEYQzwNvSdrrcrrLMt9zTW82qgTdnPB11f1uh8SgWLgcBiCrUFkUvuCtfjl04GIgSQ
	hPk8oGsQG6qzULPmuvFQuiHgyT5UhTgMjQ1bGAqoc9XqQv926afxz7fzkVOCc74NtbSI52epcwc
	rWVTuXzDNAahq/qUXbsZv8TUiUQqW+rO4yHI2vi+OrnBqEWOOj7uws0BwJs/imGEra8NWcc/3E2
	ZKLIhdovIkqGFIRUDgzRDG4hIS2EYGlhL+Jd0kgdJj4yvepp+BCLWmW6H4MJiq6azLQHf6a7UN4
	1KuPJrNP6FU7aWMKqEigJoWZ1lP1DCde+gaI4ci7MU8dzsiDhvXHpfS/k+tttG12FoGN2KVQEg=
	=
X-Received: by 2002:a05:6000:2385:b0:439:cbf3:4a8f with SMTP id
 ffacd0b85a97d-43a04db3a06mr638968f8f.41.1773333882564; Thu, 12 Mar 2026
 09:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260311-b4-switch-mglru-v2-v2-0-080cb9321463@gmail.com>
 <20260311-b4-switch-mglru-v2-v2-1-080cb9321463@gmail.com> <CAGsJ_4xxXD68pHfsEf2=AygDDbp8+hEJm3KQL9WCPr6xfjtMng@mail.gmail.com>
In-Reply-To: <CAGsJ_4xxXD68pHfsEf2=AygDDbp8+hEJm3KQL9WCPr6xfjtMng@mail.gmail.com>
From: Leno Hou <lenohou@gmail.com>
Date: Fri, 13 Mar 2026 00:44:30 +0800
X-Gm-Features: AaiRm51OWQVd1MICJUwnJzVpIkE7z4oR8lVQgA8aHzVboqscH26eZ6AcJUVqPFM
Message-ID: <CAGQVrL9AmqOeGa4Ovv6v-0qdy_+4MeupEeU_HQ=-YWm5wRV_ag@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Barry Song <21cnbao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3A2A4000D
X-Stat-Signature: sdf54aaxbjng3hf3tq8d5de74tyyt9xc
X-HE-Tag: 1773333884-689554
X-HE-Meta: U2FsdGVkX1+kvf1uscSNkI81QNlA2vN8q93xxhn8whVL3oRQXwNLeATSjzMRIbwMjDiLCnp2nIIaCrV087e9S8yntzcbddj0ckJ/0RCNNNDUQAFKAzGLW1/5jFf5dLdh2yN3oiVjch3c43qEg4lgW9LKZi4jvYBL1Y8qYlpV4kDXq5MhW10FQaXAIvOiz23eOzIw5Yo0m949Z3HggdRpOg1deIelWk1AxF+lGlypLdItoVam2QLbcKE5ZE7E3j58Afv1tw5XTvWoGUE7bmHmd1cO2YGu6J10pQCftyJ+u+yeWFH58557PFZZ2k2OV/0vbErxaJtYl2RyYTUs0U5vG4iTtpiYJcSzrf80P8JCVTlkN5ZrDVSmdJaPCDXdW5A7Deu91xSof/DRIknfxEmSr1gLEyMwR/c1VOndzTKpbVhHzMDUelTTau0kB5ZN3CuldL8nh6/KcW45Sq8Mwq8AI23e9qrNtyHO73BendVnL1p1gFVpokcadfeYQjOjf21T7JVm/EWUrNK+Ae2qF/3+5UTJYRxIX67fdG/B6oNEw88AYYaesCOMWhB6SzzfQ9eHkjIojoQ4oircqhgDKLGMeKfT2Zd9wsSWgr5QhnkVSaNbz/dk+73S4NJPZpcrxcnI4ovxhTDIuyo59qBwIEhdjF3bCiopfQC5XfdX5xJchZzPuXnVYhE+HmSwzV7ZnLOnqTlkx5tcAWEkLvaP+RBy0C6IsH3f4iOLYzI5h/fXqP/l1o7R7Q8MU9JIE4YM/TSnwkXpnQfRzVyKvirCaQsFRxc/3t/Up2jR/bSc1B8DrkxWAcbLa0w2oIF9ompBAZ7lQE9bBSc/5uhLXYk0eCSmZD42rc1yHTRbbMVwj+MVblno8Kn3mWMaSQMcWbzCaqEZ1zYkt0KuljtL/pbfCXAjS4kSmL6XN5pM9n+olFGWcRhUR4IeKLwv0C2yMhsIHCh4QpF8NtOj8Nv9uTJIgbS
 iun0b6zx
 523zV20hjUTqvSD5evADkVNTJ2kPiym34bnE4RZk7qnb0tAo3yd2/5FFS9jjl120gbCUjkqUzDpfRUOiLzGcVmvZTG4bLKIzVXpIKFF4Q75X8ZDCID/zqTmVYmIQu9Ux187nGII9iAGYRKw2wgfaMn1EyWPtqILAKgJkk/VkYBhlnLi6GceRbAW7udmZffxMcWLSK7W5ZzDJ50YlqL6TPJ6lCZm1pI2ugVVf8+yj60RU09qBAiBW03Hwe/kTVWks2uWfWvCX4GGLUL6lOhRYmF/emWcutmPuScsLRvZ8/pSFMK1VKyztjcz8UjksdrXVRja5hb0zPgN0uZYBMF2cR61m0U7cD8fgTte+koAx7Abd2ei64Ot/WKet3M30dySh98lokYXSAC5eOf3T9Y09oXtluA2LxkIuc4RZ15zF6XP/rI/vtSupVg7Ux2VDsdK0+FNisKO2aw+k9QqcUi3yBqfi9CpZDhxpdcjuawQkiFlmXfYybOLcgWPZ4pnlU/c/Uxzqqdb8jgSmdakPkYypPF2BeyEUnKZ6s6ia7DRmQgRLwde/Km0IKCbvyh3NLHsv/Vx0/RX+4jLAMrWYrNRXD3xOMsplrna2s99nTqoS7R2K9VIDHjRMmRGI7/iHJrbZJ9bGZiJ24E8uu7RoFnwM+QoSaABnV8rguzzOPCcYf628OIHOabMB/rVUkJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 2:02 PM, Barry Song wrote:
[...]
>> This effectively eliminates the race window that previously triggered OO=
Ms
>> under high memory pressure.
>
> I don't think this eliminates the race window, but it does reduce it.
> There is nothing preventing the draining state from changing while
> you are shrinking.
>
Hi Barry=EF=BC=8C

You raise a valid point about the race window.

While the window exists, I believe the impact is effectively mitigated by
The reclaim retry mechanism: Even if the reclaimer makes a suboptimal path
 decision due to the race,  the kernel's reclaim loop (in do_try_to_free_pa=
ges)
provides multiple retries. If the first pass fails to reclaim  memory
due to the
race or an inconsistent state, the subsequent retry will observe the update=
d
draining state and correctly direct the scan to the appropriate LRU lists.

Anyway=EF=BC=8Cthanks correct me and i'll updating the commit message.

>>
>> The issue was consistently reproduced on v6.1.157 and v6.18.3 using
>> a high-pressure memory cgroup (v1) environment.
>>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> To: Axel Rasmussen <axelrasmussen@google.com>
>> To: Yuanchu Xie <yuanchu@google.com>
>> To: Wei Xu <weixugc@google.com>
>> To: Barry Song <21cnbao@gmail.com>
>> To: Jialing Wang <wjl.linux@gmail.com>
>> To: Yafang Shao <laoar.shao@gmail.com>
>> To: Yu Zhao <yuzhao@google.com>
>> To: Kairui Song <ryncsn@gmail.com>
>> To: Bingfang Guo <bfguo@icloud.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Leno Hou <lenohou@gmail.com>
>> ---
>>   include/linux/mm_inline.h |  5 +++++
>>   mm/rmap.c                 |  2 +-
>>   mm/swap.c                 | 14 ++++++++------
>>   mm/vmscan.c               | 49 ++++++++++++++++++++++++++++++++++++++-=
--------
>>   4 files changed, 54 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index fa2d6ba811b5..e6443e22bf67 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -321,6 +321,11 @@ static inline bool lru_gen_in_fault(void)
>>          return false;
>>   }
>>
>> +static inline int folio_lru_gen(const struct folio *folio)
>> +{
>> +       return -1;
>> +}
>> +
>>   static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct fol=
io *folio, bool reclaiming)
>>   {
>>          return false;
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 0f00570d1b9e..488bcdca65ed 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -958,7 +958,7 @@ static bool folio_referenced_one(struct folio *folio=
,
>>                          return false;
>>                  }
>>
>> -               if (lru_gen_enabled() && pvmw.pte) {
>> +               if ((folio_lru_gen(folio) !=3D -1) && pvmw.pte) {
>
> I am not quite sure if a folio's gen is set to -1 when it is isolated
> from MGLRU for reclamation. If so, I don't think this would work.
>

Thanks for your feedback. You are absolutely right=E2=80=94relying solely o=
n
folio_lru_gen(folio) !=3D -1 is insufficient because the generation tag
is cleared during isolation in lru_gen_del_folio().

In the current implementation, once a page is isolated, its generation
information is lost, causing the logic to fall back to the traditional LRU
path prematurely.

To address this, I am changing the logic to:
```c
@@ -966,7 +966,7 @@ static bool folio_referenced_one(struct folio *folio,
                        nr =3D folio_pte_batch(folio, pvmw.pte, pteval, max=
_nr);
                }

-               if (lru_gen_enabled() && pvmw.pte) {
+               if (lru_gen_enabled() && !lru_gen_draining() && pvmw.pte) {
                        if (lru_gen_look_around(&pvmw, nr))
                                referenced++;
                } else if (pvmw.pte) {
```
The rationale is that lru_gen_look_around() is an MGLRU-specific optimizati=
on
that promotes pages based on generation aging. During the draining
transition, we should strictly rely on traditional RMAP-based reference
auditing to ensure that pages are correctly migrated to traditional LRU
lists without being spuriously promoted by MGLRU logic. This avoids
mixing MGLRU's generation-based promotion with traditional LRU's 'active'
status, preventing potential reclaim state inconsistencies during the
transition period."


---
Thanks

Leno Hou

