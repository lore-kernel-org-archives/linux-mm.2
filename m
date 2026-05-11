Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A416CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22A06B014C; Mon, 11 May 2026 12:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9976B0151; Mon, 11 May 2026 12:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0FD26B0152; Mon, 11 May 2026 12:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0CAE6B014C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:44:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7878C1A01D7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:44:55 +0000 (UTC)
X-FDA: 84755713350.11.C958104
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6F460C0003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:44:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D50f4xt2;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hv3Z/T/rDKetsPnNf4uqDj2NLpcvDmI8p9/YXJ0ZLU8=;
	b=CoOupdeeObIPW77nhZEoTtpGmQ4yZzXHYVzb1AbmvHpTdRoQw6BZD1dokcERwuV16PkTal
	/f/cXLjZ/UOVL5/dce+NXmJa/7Yuk+9kilkLo6d5zD+FfSOtegoscV5vQm1zKpY7nWIx8e
	2ezLabTYtS2hJXHp3VPqsjSs7/LuzvY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778517893; a=rsa-sha256;
	cv=pass;
	b=QxFQmoSOQuB8y/B1gYhmyYCZexg1rUZOrEDmcCaY7IgM8mTKCjSxFg32ZJqBgpWa4xncLn
	j3pmNWw5Epju1+yToTN3pasm39CJaiWbOoQNjMW7zfcMDXFLDGC7UAUtbspiShlq7C9oXQ
	jLXx3wm1NhXUJSsDqlz41CnEDuIvL84=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D50f4xt2;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9382e59c0eso723820166b.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:44:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778517892; cv=none;
        d=google.com; s=arc-20240605;
        b=Zk5s8w6aPrEThclvDi/7SOi6gBKfivcsWNR52WA3RFwsctgj4LZbHJEeM7D9uOFH3d
         YnTqC4GDd3k9rWQyZGTI8YVN5pF3bY1FyD5IrSqxl6lyFMwEexZlCvdhaCRGwi2P98eV
         wvHv86kVog2xlLxOxyl7ezKsM2u71xulqHEyq5m8ieQNAPXki5A20p653O1YhspDO3di
         uSU8AQVSr/uulYGck4ODysdeP6fpVp45mSQUu9gssCzlgEGKc3Z0iv0cWefutE23h170
         UPKOxbIOJlY7eNjOE3aN1CJJXWmsy6L9A92cgg0p3EBr3t5zAqPQ1t/GgGjE1BbGo8NN
         MsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hv3Z/T/rDKetsPnNf4uqDj2NLpcvDmI8p9/YXJ0ZLU8=;
        fh=QYd1fgnD3n+EWkfd4ej8ahJ9COWwcwzAJr++rBQctEY=;
        b=YHzYi/uyC59RB4j4Mrs/zgALC+zyFUh9lq4nopgG97bs19kN/dv4zNpJrPr5cOEd9n
         ymOGXvNGontUhUYM7vucJ482/J7B/J7BWXA+S5DmBtBqaeOfYHSmVRgM1NBcds7aOYUZ
         iBlMKxUtpmPHSHlWrkG6UmTpGkRV8h3V7pcAuOKs66m1okgkhZKBv8Ctip6fj0zG6Lvi
         eujgUlauTNN1I5o7eZCUFgUiJ4eFpqOe5f2VYKgAZ64roRK2pTjN/RDG/DNRgRB3ddsg
         0z0Mz7H7kCWLbcicpcPUvfwzIV9+/TI4R7V8CembZXfsPwBk35EsRX1IXbVUXGfOmJG5
         irfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778517892; x=1779122692; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hv3Z/T/rDKetsPnNf4uqDj2NLpcvDmI8p9/YXJ0ZLU8=;
        b=D50f4xt2RK13zUbQktz0JbkLJ6Zv+oOB+7VBzY5VggrKwwVL8VocbZ6hx+ZhWvCbPU
         g1p5OakQR8A0+8eQ3uePcOf+EOp3P+PPkQAvIK2p3Xie4HSEcrkEzmA6SY7Hu5J5RkCT
         TwWj/vV6JrBido3lL4p0TthftFSecj3wy0AUrSPR/3V93UIQrUa5oXLOl9sLZwQs5AJ/
         HN091Py0724D8h5DBx6kofT3V3Kl0Tbo3YoXbIPkfF3zgBeyTlIKPoWfs/D9IXaMAQb8
         nchn5nOfaEaYTRcRx8eyYmzFd9B/MAcqkCqKZIysuQ2WFl/Byhl2ueg1LrFU6LnJDEf+
         QAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778517892; x=1779122692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hv3Z/T/rDKetsPnNf4uqDj2NLpcvDmI8p9/YXJ0ZLU8=;
        b=K7Nf6sgVf0sLGQReTFrqAFzwdNVKbDqZ4OttV/nCuPOyGivsPJHwm1f/SD4ztxYJUa
         5HhLKjFpGI0M6Cp4DPhljRgGd+78YDU4skvg+GqBbr9gv0lYJHXpybeTNQ5N23o6PjQK
         VDpljfMIRcmfbR3BICk1VkVXiwOGkc4IWMhdbjC6prhpP9TyzUkrIhZ5NYcqBHuwHgSk
         kGjJmu3LTO1X649h5YPs/r9A396vPu2B6LhMtzrU+gP1pO30oY8IwgJ9yr/xJjBW6h0u
         sc5yqLXjPd2VeraJfCRyazyKXSalwRvVtbHwPmSJAEomhkJwSudEu78A6eH5h52F70GG
         +mug==
X-Gm-Message-State: AOJu0Yyhqqyi1Ks7CP1rERXD98icO1/5qxm3rgeegD54+BiCmeV9nEjP
	NIrsQInJ/M7QeYcfLz5FXqgw4C2qk7MciywbCCk8qoY3kLvih2lVEWBk3ZYUoDJRn+rRK4ITzGm
	kDRpKMyHsxoBIxpmoU5WeOZ6a7SsPuLk=
X-Gm-Gg: Acq92OEH8Xtwf6WgwhlHUI7ysSMzsjjS76whBKo+15zl1Qp72fT570hz1BOQ7HSerWM
	lEef59XnyfX8XiJpKJLwYnlh2pSYsQkQeD2gUsAJ33P+LuY4Yi8DLWGAWNotrE4xYU4W5i60tBg
	oktQBNEJg9Zo6Qkw1u+zXlYTGNzpDlTF6AQWY9CteKyudloswq5+39LltGVKjK93OuR6pVBfkDj
	Too1rPV+LGXdkgoK8r7fedWrEzgnH7ZltvdzgniJoiGNCWiVmKJuYzbZDJfDbsO77BICruu6nMO
	8V8oqTt3ADgTs/69A8aBla2whqz8ZgEh+/2wzviM1pIV1ZNxKgk=
X-Received: by 2002:a17:907:98c:b0:ba7:b198:7d35 with SMTP id
 a640c23a62f3a-bc56be38696mr1454458366b.19.1778517891489; Mon, 11 May 2026
 09:44:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-5-2f23759a76bc@tencent.com> <675e9027-9fb5-47b5-9a2d-c9a416a27d0d@kernel.org>
 <CAMgjq7DegMz2ZEHOhHkAqDEWDuCSZ7Ktsxw1ibDY8axFzRRGnQ@mail.gmail.com> <c72ead41-0bb3-4da0-856c-315dc552c722@kernel.org>
In-Reply-To: <c72ead41-0bb3-4da0-856c-315dc552c722@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 12 May 2026 00:44:14 +0800
X-Gm-Features: AVHnY4Lqb9-Qjp1gLoCD6Wj_xSwNStP-lbWfmLcjcAc8JKIbMJcoyw45UeE5es8
Message-ID: <CAMgjq7CK7DPfHEXUY+mDeKu33n=CBrh1RKmpem7Arjsas9rxYw@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] mm, swap: unify large folio allocation
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6F460C0003
X-Stat-Signature: 7tooodkh7p1tthehgowhbaqcmr788em3
X-Rspam-User: 
X-HE-Tag: 1778517893-870040
X-HE-Meta: U2FsdGVkX18xWFoukaZ/Aiu2xF2NZ66KrKXa6PV231lypy5bBcgA13jgTSP7+7iOhk/5SWDJwxR3FM6guLhaxmjECXJBt+GH3VTX2VfMDF+Ip3FFKDyCBF4DDFbC/yVSYxHz74xxgegY+cAEwl3n72L6u11tyP5yk8nyvjGGxWAd4H+gybCAGG5p9oAYlhttjTPCKuhQiOIovRI4lbPPfQauY1/RPJJld1sQ/0aqAeWrAuDnw6+v0Cf+edY7nHswBlMJ54w+yL8yXhL1hNgUW3UUKKHMwtci6O9Q/AiS+A6NblLSnErOCMNSjulehMnyb2uN/AmBNa7uNbWE2vigszPxkKXxWA1Wnr0OeGbB2WNWp5kmua8WfJKX0w9u30VCgpgRBrqVwpieIBnVMh8iqOMdM6i8v8zcliD90hnCmPcd/8arfP4PLxxN/hPL4jvKpMSvGzgHjjSWhleHJ49TJiBucoLe5WS6gEIcbSVybswD/8A5im+8e2kN5HBNXrt7IKuroQ0NThtgHHUxVb7xgnGQeAUUo1Bvo8C3ob55MI4YwL5PK1KXeX+xweQhf2VQv+s8jk1PmVad4uBgeB9bpChYT2g9Z3dWPS8nKMtVbRn1Ee7FQxk1zSERLCt0rAiB7dB0Rlzb5hVrAL/RBgUfZJprWQbQrCaW/lwLL6kOndfzdjNlt/0q1e/5gjh76jq/m1BPCH3g5P3DN6KlLmPDXFeEAgIYrbQL50t7XnVfnuF609wxIVUQckZVQlUlb+kbUk+WsDKJ3EGAJsbboJ8vQ5e5oQn8vKAvhZFWu7MuFp8xRb3MWGN2SpYEreTtbHUUl5BqlhKghTaTEr6RIk76K02dPHkcPiYQZvyHcHEZqiGkpUPru8mslQWRBmf2Z/5dNff9cav6DO2NvGfQEP+f0P7ZJwqtxNfQlS/gEYVlaO11sckywEPBtTq3ipQjESCRmR3M5kTHp40tJcauDzu
 0vvGL0+b
 zsTPQeOTHY1ehXW7jVC+5sU9VDcE/nQNxTjfBeiAWvlmVx4fvDIrSgmCSTGI4WOdvoHm1NcKsbTZxVq9J8lKeCNZlqk32l2M8JyuYWrwDon/RsWO1Z0asVlZqM61ek/yjatTPXYpjRXeTigotveYtuvdZuCOHX54sKlJRJIHcS31dolSgviRQOcWwTFcctREk8YGTzxLm3iRwQuWYtWU616ZJBSW27LscuGbq369KOEpvesf25B6fT8kSyNzlegEdCQPUhdVZ0RAxLLLkO2WCyISSuIyogqhfv/VYYCzbGfw+u/uSLJdtuTL6/otTeiucXqZwZnjf42I8ub6vwqOaEzAOYRijmGdjRFy2MKQw5RQaYS4wr06lWt54fl8rrPZuXFdDD7DyW76hi6M8hyQ1an5Iefgzh8w/muPg8sEpGtT4yero0Nf82bnU6HPfUm8EIpe1aB+t3jBy4QMKaBZXFY/cGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 11:15=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/11/26 16:37, Kairui Song wrote:
> >
> > Yes, the current status is a bit odd, about two years ago I also
> > wanted to name it `swapin_direct()`.
> > https://lore.kernel.org/linux-mm/20240326185032.72159-3-ryncsn@gmail.co=
m/
> >
> > But actually ZRAM or shmem would also benefit from supporting unified
> > readahead like this:
> > https://lore.kernel.org/linux-mm/20240102175338.62012-6-ryncsn@gmail.co=
m/
> >
> > So calling it `swapin_entry` seems more future-proof. At some point in
> > the future we might remove `swapin_readahead`. All swapin operations
> > could have a unified or at least a per-device readahead policy like
> > the one in the link above, instead of the current policy where the
> > caller must decide whether to perform readahead.
> >
> > But any suggestion on naming is welcome :)
>
> The other proposal
>
>         https://lore.kernel.org/all/tencent_CD11FE9B4A0B362E95E776C5F6795=
98FAA07@qq.com/
>
> calls it
>
>         swapin_synchronous_folio
>
> Maybe just swapin_sync_io()/swapin_sync() or sth like that?

Good idea, I can keep the swapin_sync name at this point. Sync io flag
still may remain for a longer time.

