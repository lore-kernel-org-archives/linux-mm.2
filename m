Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0840F606A328
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q+dv8hpI
Received: by kanga.kvack.org (Postfix)
	id 25BD46B05B7; Tue,  3 Nov 2026 16:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233DA6B05B8; Tue,  3 Nov 2026 16:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1620C6B05B9; Tue,  3 Nov 2026 16:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D79A86B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:02:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6318F120564
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:02:16 +0000 (UTC)
X-FDA: 85395030672.04.4EA96C1
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 676E914000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:02:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q+dv8hpI;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793739734;
	b=0ARpsAA68CwRp+VRe2n32KlWBskEAHaIn50N5MYOZMrD3H4bAuYXWnHV/YBs0vEdHMFZ76
	xBrXyVYrhJwhzxOuNpcDc5uPzJGn9rhNIl/5AJiMYfjWSimXg59+ca8bDM0tNvxBZoUeA9
	ENGt0YwHy57TKd2Nhi7jcGDtJ8SPKjQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q+dv8hpI;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793739734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLnVO73afvgaERjHXGPf5E6SbhMPv9R55TpDCQCEqgQ=;
	b=PW8jIXP5UlsplAcstjVgsCibgcSqa19MvAtpkO+Ya8ROc3mSgxgKZVypDIezyiKk+4jTDC
	QeAF85zHe8z+vKIDWkIWYmXmJKXqfRtLlm+V1dni5InFIpc0eeDY2WFg+SlDAoMdYHgK9F
	2LqGiy6AANE70y7/Ig2TTVnSpd1oWcc=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso31284585e9.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:02:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793739733; cv=none;
        d=google.com; s=arc-20260327;
        b=F9YNHUKS8Ua4BnMu0pXHh+aO6VrrpN7u+6siZOGuXjVTLk6K7EtYtX6rpcow6v+exe
         zqF4j4N+1K6Dcp3wLulh9bCOsfbrAdvDwXpd0m9/1sO5TIuV52kZGmHEUlLr+KES6QDO
         ZhONRAgpxN0gghi8thQQ5UeLP6eCILK7WPCLUJAtEolGNuYXNOONsQ1+/NwViSzhvPug
         YgBnQq0tYAodXIgrVkJN7VE1GN09pM9eHcz8ZGJuCIyXYd3XatVSWHnRNRch11vfkvk1
         PSnlwudYzui2AtPAGqAZ4MB6XwRJ25s0fd+0aUOeH+m9AeKs247hUiTN4dKppSmgeG9c
         ai2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eLnVO73afvgaERjHXGPf5E6SbhMPv9R55TpDCQCEqgQ=;
        fh=5i3vk0+nDUDr3WXsy+7lhGdWzCh63HgwAOQ6fMOOnMs=;
        b=gVXJtQDQGwunGEX42rgWqBKWzFM7tWyfw4YmSFGZDf2JClNo+k0tiLP7i85+d2Fxcg
         dS9OL4N0jtlRuM4xv0q4gd+v+h4+VHF3gNrYbMvqVuMc3ofInOEaNxsvj/I2De9eVoGk
         o09w6rbdQjI4ameC4z1AOcgLPZVJn8TOsSlROe+CsZ92lhME762ndoQB0Rg1axlTyko/
         vg6oNbyoxoCA5Xomu1mhedFh3IhC6FmcFrv7nwux7CM5mdBb3+AwRCVHxF6+l4ou+H5X
         Q6teMaVYGNmIpB+wKdmHKdhL94dXXvPhhtJyl73kByLmRPww6Iy5FfcAWiGf0Z5obmJk
         LhJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793739733; x=1794344533; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eLnVO73afvgaERjHXGPf5E6SbhMPv9R55TpDCQCEqgQ=;
        b=q+dv8hpIpVSMS2VV7fck+auRC+KM+Ri1tE4eNAGRlRUMyAfNju3QfSg1Zzx74levlQ
         By+TyAzksmd6c46+UOS2wIg/lmnL0k1F9sefx8E3Q4D9HaijtpAFGWVQ24MaNdlmcjXi
         fKiboXVx5VAUSjH/8Pe0mMFTnsh2Rq3HFStcWypJKfNXrhCAFfaPz4E3N3aUxhbVoe80
         VAV94GUrAAgZg7UnIGjJVGWeUMy+sZmcY38vYkYDsLhhqYIW6oPWkEp/XRBKctUe7YQO
         0++nG8XtSYgtveaOoVgT44XuGGH88ud3N88ZVqYlqSJB04dK7lqv3fZcARjEo/sydetf
         9fGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793739733; x=1794344533;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eLnVO73afvgaERjHXGPf5E6SbhMPv9R55TpDCQCEqgQ=;
        b=xZsRSPsFz+Xj3mvATQHMG5J4s/eCC4KosrdPIwt15uHOvixBtnG2HmujRCYhKgRWyK
         q9irfQlJEwOLDEej7sq3EwAe/YT5vzjEjCSk6US/Z49i/++PnGc+0jg5rCYgrzmvV7Hj
         Q+YLdpykBkt7Xyqq+uO7U+hk9+U/uKZf0726RJ6HWfUI3CqkRN/avLoEjDiuSUviKjlS
         kFmldJBJ3lkOYFhjKJr6pCWHRN2Lt3JBjw82abJjUShIme94Qgdv1hYzB0XQg/NDju9h
         BnbnSgZfVlz/j3Q+V3ibV+OQK8h5NJbR4U0meyx61cYmMrNKtyFFL4ftyQWbqFM2zyEG
         GVOA==
X-Forwarded-Encrypted: i=1; AKwUvBwgWC/8YUFZr/L2oJyZU59rwswr0aKp+B5ug28MUwj9e7w7Q/BGPac6MzAuKxbwFQzaoeS3yrwBpw==@kvack.org
X-Gm-Message-State: APuU4Z8X4VWcam3t7lvd+Rl7lt+hOhPmJXeRzYf4A1T9nRjUB7U+IRMG
	3SkaYIsalxIFub7uvzYcnMK663s++4uqE7J+V+GbFoRu8o1UaAKxfa0uERiGSdo49zIa3Px0NHK
	kHyjndkgUnc2Ukx4G4Ux6D+iIy6cxFZk=
X-Gm-Gg: AYBFou3zjtg25/ti9YcbaWMmhFRt3RwOLrAgiPFeRB2N5TmdJRfOsPa0OUbe+NPKWBZ
	MRfo8lFLowJfLSXB9BQNsw2bsXM0SyvNTfJU3kRcxQrYX3BO2ex8/brmBXVbatbHPFyUIy8PYuf
	mqqMefxQqpwOxP9Ii854hYfF6IlZu8pE/gF8OcPnySjVku8x3FwND8BtlcvyZgxXBVpynmPHXle
	X0jb3VYOtyJAJjnjhujUkXtez8/QeeXjCxGj2AzKRpK1clifmp7nYJzrKAFxjxmvfAeBriFfqWa
	F/Uci+ZZ01gcAEzFllnyKEZdeRNDy21RYRBh6vtUmYw038NxZ7NYsw/JeiwD6fX2ztFbvTAKduK
	/KM7/FT1gnDr9bloZi2FRby3ESGax77Joqbbtm3xLVK7k8+nzN4HQ+vu68IqxiEWNm1pSPwttZI
	ryFo85VGoX3CYQSjHh1++ZzzZM9w0cJTx4oFApjhEY5icSoRBf+jWtXw==
X-Received: by 2002:a05:6000:2dc7:b0:48f:88ad:7b75 with SMTP id
 ffacd0b85a97d-48f88ad7ed9mr6170165f8f.15.1793739731970; Tue, 03 Nov 2026
 13:02:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103-swapin-large-unmapped-v2-1-87c70e597250@columbia.edu>
In-Reply-To: <20261103-swapin-large-unmapped-v2-1-87c70e597250@columbia.edu>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 3 Nov 2026 14:02:00 -0700
X-Gm-Features: AclHuK-dU-jDbeAA-AyxlAsBt3J5xyfKTDwVAoojWWH0SE7Uz8Xv3jSOSRyptrE
Message-ID: <CAKEwX=Ow38Y9OK69Y+Eps7k_sdKdkLKuO=Lxn0xisVkuHVePLw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/swapfile: drop a large unmapped swap-in folio in unuse_pte()
To: mt4022@columbia.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 676E914000A
X-Stat-Signature: kzpsu71yc569kbbwmaxup64w73eyxus6
X-Rspam-User: 
X-HE-Tag: 1793739734-148889
X-HE-Meta: U2FsdGVkX1+Lfo/11MiPb76jXhFuCUmolYCk2MvX+Jm4MDAT7O7wJAu5BdJ2gqU7rsblb2tzJIztF7+ajc2Zas4OwGnkAy/Xe3QHqbl6nnjYWJs3IDKBJGh9ZtTZcBguv70QGLo/G18k3tKhqCgj/qUNfwzO0PgVwmIi4+pefeOGB5+xTeSnYB7EFWXVCabZ+LQcvBaJcni9InCIB/xM9y/Fc/nsxuGv36iHIaAVot8/4Cux/xjR3NSZZi7LTnYGsT/Q3o/6KIAU2MCfirn3LJH04b1fhVplRrhaJQjievAZh4iNqvs2krqpn0L19SwPqKJFkIE2THdo6V4odAzeswaNAFobyAO7ylAEXoxEFdu9HuSHNrYMi8ltjjD09nAtt3JpU7iXIXxpQF40E0xDALWeM30gZIBAmx1Cj38ekrNGCX1vGoUUlbh62CFzz4Wfhcc8Glt1JUqFFIDd2Qjw8NumCXKg5rB9PI6d1n0GlSv+F3gbpvqBBELbQrOAnX4XHIhcdcBdjY1/ecUqYxiJpfBKlwALIp7JIJMhkHIjXWr3awl1dOuV2YEg4n5rEdGxaMBOGYppoDoZUc0Lq6wI5CIOmE/fqo7RzP6jXhLWxDJbxBicu5Iz6OdvfQ3CxeCL3fBdkKj3rcpuM1M7FdS2MCiAQ/ac/AGxj92ewo+Arl7jR5ZmOQyIaeynWnNCdynUL5gIeVkqeE3Wc/qVB/aHxEBBHjTemlaQGHWDo11YILAlNPbV+SHYJv8h632ktlPX9RRfYUkQ6PYTj/VeUitX7mDE3E37paABqpuVwUxDWjTxlfEz+zVu4RTpU3Fmh3f307EVhMp+IyJLTtAmw48JYCplyB8nX9rjq4t+5tJ/pnqLJYzql79HZryp+MHs8JAAgeflLiFh2tt4BZeyis3+G7EEmPo4hDQEYdDsut6+rMlJrJFqeF84Jhvy5YHUtgiU5VdXzUsJSepppIbrSLo
 2KjH3Q7+
 9TNHFwuS8ifgO70xEr4c7LEhIYU4MxAusNXfIvTDYwFZ3DhbwRvvYZ3EW/T6nJTMvApsbp8TBtXcKHOlFSfvvNhTzpMwaCXc8t5ouiIjG8/kt+G5/PsiIB52Cj/yaQCtXNIHh/r4iHuBXHYjqGdPpZwajFhvEvCoj5K8SyAx46oC1aRJuoxveXoF1q/a3JX16N4frNPFD8BTR0OHzj0vUEfR/K3Hs152IUCrdprJb+TEyx6TH0Qr2gG7YACnkbNW/dmt0vffpfmvAxUFVVzK8fO2p8uSUz/4eb1FL0PgdjIjaD57c47rDvUYpfKLDzfSidM0pZqHOvnULsO7PGv17G32r1pE9B7k8Hx1rsCdbCQf1ZJJaaoo7nX8yg9Gkir+i04+FfqTVip3RWakbsgkpom8kVOPkS8wDt/CzHcLX/Fhs72hwdEDUdc2IWje32xODJEPZYXFGGDFPQFobp4/r6/6AWNcmTquEQ7z/miFgdCCiL9j59smBt5h3Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 1:12=E2=80=AFPM Mani Tofigh via B4 Relay
<devnull+mt4022.columbia.edu@kernel.org> wrote:
>
> From: Mani Tofigh <mt4022@columbia.edu>
>
> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into
> one large folio in the swap cache.  The folio only becomes anon once
> do_swap_page() maps all of it, so if the faulting PTE changes in the
> meantime the folio stays in the swap cache while not being mapped or
> anon:
>
>   Task A (fault)                       Task B
>   do_swap_page()
>     /* swaps in large folio F */
>                                        madvise(MADV_DONTNEED)
>                                          /* zaps the faulting PTE */
>     /* PTE changed (F not mapped) */
>
> swapoff then maps it, which marks all of its pages as mapped and
> exclusive, and the next fault on one of the other PTEs crashes in
> do_swap_page():
>
>   [    6.424485] kernel BUG at mm/memory.c:5195!
>   [    6.424503] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   [    6.427654] CPU: 0 UID: 0 PID: 67 Comm: swapmthp Tainted: G        W=
            7.3.0-17087-gd865f2677c44 #1 PREEMPT
>   [    6.432665] RIP: 0010:do_swap_page+0x24eb/0x2fa0
>   [    6.451035] Call Trace:
>   [    6.451567]  <TASK>
>   [    6.453841]  __handle_mm_fault+0x13b5/0x3b40
>   [    6.458525]  handle_mm_fault+0x16f/0x480
>   [    6.461143]  do_user_addr_fault+0x312/0xa30
>   [    6.462044]  exc_page_fault+0x66/0xc0
>   [    6.462846]  asm_exc_page_fault+0x26/0x30
>   [    6.476708]  </TASK>
>
> do_swap_page() already drops such a folio from the swap cache when it
> can't map all of it.  We move that check into a helper and use it in
> unuse_pte() too, so swapoff drops the folio and swaps the entries in
> again as small folios.
>
> Such a folio was never mapped, so it shouldn't be dirty.  If it is, the
> helper warns and the folio stays in the swap cache.  unuse_pte() then
> returns -EBUSY so swapoff fails instead of retrying forever.  With the
> fix, the next fault doesn't crash anymore.
>
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within about 1s.
>
> Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_=
SYNCHRONOUS_IO")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

