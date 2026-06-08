Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D2ECD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425D46B0088; Mon,  8 Jun 2026 12:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D68F6B008A; Mon,  8 Jun 2026 12:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C52A6B008C; Mon,  8 Jun 2026 12:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2316B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:23:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B148F1C0E37
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:23:27 +0000 (UTC)
X-FDA: 84857265654.26.7B1615D
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id A8E7DC0007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:23:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AXZLtk3L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780935805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPv+U/wIjO6pXhd0p8FcM6eyTjtkG314lWJDeM8Dul8=;
	b=GBtl5BT0TUxQ9Vsc+qopFl2FLrrssex56YgbKrk4pYFIS8zjba2h9G5/YUhxXiG0zbRLZ1
	zHFyH6dpsb2dEg1WcBAzkATrOkHqKKKmePVJj8UEbumzeLB/DrN6PRk+I9i4ZjktSbkFxM
	ty7ZAySsDo3Y/cLEUXZEaIUS1/6lKVE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AXZLtk3L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780935805;
	b=JSEhGAsFd7pnaLSkJOOJ8uEQaHg9muBPPYApHt3k9rKthW6axEfcKTMBAubD6JxUVVxO60
	gYqIOstakl3hfptmoH0PlQu8XqA2p+gZGuBjycsWmPbd4Tn6WuEyW44VzDk/gHop8oAWKD
	FjIscoNUwCTLmK56lttf5kZzoIcGK+M=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b4a8e28bso37693055e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 09:23:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780935804; cv=none;
        d=google.com; s=arc-20240605;
        b=L4hO/KZiA68PQBJoBx66jwEZs4BCoIMXKERr0NA8gF4qc5FfKf+uX1pfzZNtBD1FkB
         Mx8fcpUaxq0cWh0qLNKykFRwbHn4E/6g6xDgJ18R2ZDE6XoOH/Cc6ZbhK32FdUBozE0V
         EBEhVr1BxfgRn+19t2VAyAA8n2w1RX6EwbOmedI9V1yJSyS9wW3H/TvQRMaIlGYfkGmD
         +X25t+8A43Uvz6P43Ln7pYAYAIrMe+0xHy4YGXCTAtp7wtS9JwgXIhSRGJkeSHhJ7utL
         OpNvKG32sM72n3hrr7ucdE1rdRxYkF+B1ZB5mruhluzuLmhqw4HOKq2iQW+4PFq1FBOG
         gg1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jPv+U/wIjO6pXhd0p8FcM6eyTjtkG314lWJDeM8Dul8=;
        fh=xvJxAuLmzRN1C+GhKOeN64DlRKw5evvHP1Vh3ozXQYE=;
        b=SVCCLtOagf3wH5LIiGQmGSOM7swrpnLwmTn6y3M53hsL/Cxe6VYCwFtfdhJkKl2eiw
         txuO+PQ+wulkkXGsG3F9bzF/Y05H+WEkG15ZNvNNtrm8aswnb7SNMymWw/mMnnLOcrHK
         WQy1vPs5bno/hrRivlcf8W3NThzyuX9+oUI9B7FnYpeaOpithiRwLL0A+cUdYOZbS6JE
         QZ5jkZzNFEHyGeQnPHZDrvjy+aWw+5cd8nRNyPIuTanPPoQe5IxUC8sP+U2XTtniz63d
         GxeKPwn5hsmX63m660S+9+QIwrYxNhzmOu+IFBGFJLgLEwStUlsSybOcLuoPr3nfRWjv
         dC/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780935804; x=1781540604; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPv+U/wIjO6pXhd0p8FcM6eyTjtkG314lWJDeM8Dul8=;
        b=AXZLtk3L/olJeKc5X2lPZPme0/W3wNluKkq3Y9wmS7nhSM1AI5tz0uhfdZh5cWPad6
         LC+Gh4ZI7jzWYvfyoSHCaIvlrnkxEsTKGrtX8Te+KfRvvLVLx3ZF51964fkpg9XEyIg5
         xd17TFewKBHcVgFYjJuhbei3z5/nZ7vSxeGcwvs4Um+0sJpbrPSjmLwvv43s8V7E6+2D
         AuvaqC1x14jWrwZ5zQKDOizysfltQYadnfucHV7WTROa8jyK9C6WFjPaEii3Awu5y3NB
         ufo485QSldWybPjYTJkKqzvqE0tzS/oNoWC3DoUec7CgU+GeZIwrxVSECePcSsY9hAz3
         DMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780935804; x=1781540604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jPv+U/wIjO6pXhd0p8FcM6eyTjtkG314lWJDeM8Dul8=;
        b=HUsrIYQAl+3GcibMAW981JJY2mY7Dgfjtwt6Xh1uNd+Y5BirkZpmK0VCDq1aiSMyUm
         pu4waMaC2p8vgs/FyhKnDq14KgVQ2zQ44cHtP5nYpbI4iWfy1LmHplDuMfNYj3odz/Xz
         v192mnl3nkict5TnqO4sEvkPl3LZ9lkSUcQ0/sniIwC7GJG3381OEG/++9+K4naynKsS
         njWlqaCS1q5rKUae+6Klg1KcwCLadSC4rlGra7DMQXHS0n03Ds48uuncPZZeKVWKvYVU
         pdCud9sM4L1pwKK1UcmF2huxMYVamVykg5gmdaf6lYFjE55ORc+CaKjKWm4T8rsY4luz
         BzSQ==
X-Forwarded-Encrypted: i=1; AFNElJ+pZFuKwDpqcK8VKy6CPcH+HVSSbx/n2NUGABKurpDaMnJ/Ta6EKV3kFbPY9pxWrWfezeTgNZq6gw==@kvack.org
X-Gm-Message-State: AOJu0Yw4rjed2Ur7NjXf8GWNRVwZ5gLuYeErgmbt7FD90Yne7lglSeW/
	ZdCR5VUoH0mXsks0sF2jUMy0ZbFHEYFNpUKWg3L4XNp5toEbXKqjMRofB7w5ypfCP+3CbQWttR4
	P0NICY9jW4CXtr1Lh5xnst5yvZ7K/4ZQ=
X-Gm-Gg: Acq92OHVBMIxhZX7RUkf7icfkl05LGdPidJ5Iu1PD98/SLLuBdiH7WAbp1iR4kwR/0b
	jm9j7w3aX5kAjCbe/XvZyhyldVFJVjnLVZbZbPF2TLtLqFW2Pjd9yhX+vz/X92D0ReXXOtop/yZ
	nUAecGp+giianaTqWHLPuptbucx5aqiCpFwHPpXlI7B/gktm54dl37ktTV20bD/K9RwS/ySxwBe
	Ehlzrt36h7DLLHGALc28uDXlqxYuL3SBRucL0teE56RA4LwJlgNeTiMr91LbInBW+t+GVBzwmJK
	I+KVwW2neJOa8UtcUckLIeDI277mo9H4GNqwHS32ZabNL1i3hs8hT2Yliqej
X-Received: by 2002:a05:600c:3f1b:b0:490:bcf6:46bf with SMTP id
 5b1f17b1804b1-490c2599fecmr275598275e9.9.1780935803894; Mon, 08 Jun 2026
 09:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com> <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com> <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com> <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com> <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com> <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com>
In-Reply-To: <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 8 Jun 2026 09:23:11 -0700
X-Gm-Features: AVVi8CcQa0JXhG_fDPPqHmrr3OFhGwIKj95CSTSdP9Q_mQuoQWpHKZOKlZLp87U
Message-ID: <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A8E7DC0007
X-Rspam-User: 
X-Stat-Signature: toxnz6rhjggamjemf87c5ca5di9kwkm4
X-Rspamd-Server: rspam09
X-HE-Tag: 1780935805-433922
X-HE-Meta: U2FsdGVkX1/nr/d0sqzCPAcd8cmsTxshpHQqiuDSEsBFfnti+An2Uo8/yXBTC/PdguUwDKwtlnHO0msPnd+Fht6mspSuSpXTMMGZJE+EdFDyXSJxI1UIi8mCbB3HzYZTngYIS7CASCVt9boF9DavwxpRewamxgjrXgEG4Q5sG9PIKitrAANE37QIN5D3E/1HMgr7YrJMX7qvvU63mSoEvbnsqcFmY0LXx7E4fGVzhTebRUp+nIsQIWnA0HSGAWKNnkI80x8F0foTdbxvImMKPNXqAzmUOcLc9kHT008pwxwXHxQZghkMP6RHoJlG38tYRz7EAmtflFmFofnVE3rDCaWm6myjnNBr62nx9Et6V1VcaUlfndHjUTIjjs5M4fSmbYKXZUbqOziAlEJtu2CZwNWjU4L4utIqL3xfi/TkFrLrDcW6HY5yMD8m8MVnooySO+ae8MsGnpw4Tp0YOUC/uL+VH0UEhb87BfNdmzI2AaUd5+O31I9SprdJKr6uFqKE5qFGqxIqj/DT+sRdaSBFPgAX4qXtZ4y7yJ9RxzZ0Wa9Rjl4tOtF+XfnK1LrDxlHip3x6zUk84/6/bgmR5c2vJjgq55FGi5G/a3NkIvu9glsZfbyiKyN05/Au18fkWQbcoUfLYF6YjWZCp0a4gPRTjEW/0Xik91zxGmfKdNO3VQCJFi7OnVHg45Ood1tDp7PbOFXXXq3Hu0tbuhhqBkxKkFRiEEdi+uopB+fdfnI+5GELsTPsQNrW/yjJBN6dhNkoG9yBIUCvwUESM6UKYe0Qc3jcHbKy1iKib9TGNRTU5Fwp2eG6Gi465lUjfvyrmGuQeqQ4k7WbwTe0iAi69WLZHI6Ee8OctanmrZQG3NomlVUkHOydbkeLjpd6vVy8sQ6y0N6ZKMlaXNbxbqhnmqm/qLpql3yHzz94gBSFc7SQ0Y+p2+WUvT31Ew+V+HuPo567TkWx0c6rc8qqpVWqUod
 ssuj/m9a
 eeJPHMg+cm5zccfRjikhri++oFKJUDfXnhLJ/95/Fd72pfRgy3gqAI2fRpT0WEijFg8KlAY2uJG7P1OL57PiSGSMkRCUBP0cfNzRMhiK+MeXOXNYTVlLUKgEUvhFNI42dqTRQ86XBwyI0OX3r9Y+L9zn1q8SBvdXRX94ztgfXxcrLSmcuiXhBAOmV01hzIe8wEKJW92rqM92JMibymksLDhBGB8tAijSAcgtp1grHWx1yE89Gs5NQl1qjrUPHodtgyLZF9R9Swh7ZWw+jHx5EYFPkW1BnTrmHJg2YaNl4QPwo/V8jKKZalpKR3CJGU1oxTtaWkYIFCS/UQ2na/Hrc41TgIjuCw0BrwJFw5ivV9/fACz9C4g4kpH10gv4iphCwVTHTzAVAPVztbx5nT/Sc+pvz1bRYHQCJHw8CXpi5IUVWJoNYcZGCbd+9CpGxU/K9Ncd8CSzUC1VXqzQtO2bF5DoKk5XE0zNizSdgzkFSh5GHC7cMaAgzpP/+OUqk/zB96Ylx1ZmkE9soN/dtXcrqKP+nB6FQcvtqJhrxXtKShHfkPDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 5:50=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> wr=
ote:
> On 2026/6/5 01:23, Nhat Pham wrote:
> >
>
> Thanks for the suggestion!
>
> I ran some tests and found that neither the per-memcg cursor nor
> different batch sizes have a significant impact on proactive writeback
> performance. However, exactly as we suspected, without the per-memcg
> cursor, the writeback distribution among child memcgs is highly unfair.
>
> Test Setup:
>
>    zswap config: 18G capacity, LZ4 compression.
>    cgroup hierarchy: 1 parent test memcg with 10 child memcgs.
>    Allocation: Allocated 1600MB of anonymous pages in each child memcg.
> To ensure compressibility, the first half of each page was filled with
> random data and the second half with zeros.
>    Force to zswap: Ran echo "1600M" > memory.reclaim on each child memcg
> to squeeze all their memory into zswap.
>    Trigger writeback: Ran echo "<size> zswap_writeback_only" >
> memory.reclaim on the parent cgroup 200 times, with a 2-second interval
> between each run.
>    Metric: Monitored the zswpwb_proactive metric in memory.stat to
> observe the writeback volume.
>    **Note**: The size here refers to the uncompressed memory size. Also,
> since the second-chance algorithm would cause many writebacks to fall
> short of the target size, I **bypassed** it during these tests to avoid
> interference.
>
> Without cursor (size: 1M, batch: 32)
>    child        wb_pages        wb_MB     share%
>    child0           6368        24.88      12.50
>    child1           6368        24.88      12.50
>    child2           6368        24.88      12.50
>    child3           6368        24.88      12.50
>    child4           6368        24.88      12.50
>    child5           6368        24.88      12.50
>    child6           6368        24.88      12.50
>    child7           6368        24.88      12.50
>    child8              0         0.00       0.00
>    child9              0         0.00       0.00
> Without cursor (size: 1M, batch: 128)
>    child        wb_pages        wb_MB     share%
>    child0          25472        99.50      50.00
>    child1          25472        99.50      50.00
>    child2              0         0.00       0.00
>    child3              0         0.00       0.00
>    child4              0         0.00       0.00
>    child5              0         0.00       0.00
>    child6              0         0.00       0.00
>    child7              0         0.00       0.00
>    child8              0         0.00       0.00
>    child9              0         0.00       0.00
> Without cursor (size: 6M, batch: 128)
>    child        wb_pages        wb_MB     share%
>    child0          51200       200.00      16.67
>    child1          51200       200.00      16.67
>    child2          25600       100.00       8.33
>    child3          25600       100.00       8.33
>    child4          25600       100.00       8.33
>    child5          25600       100.00       8.33
>    child6          25600       100.00       8.33
>    child7          25600       100.00       8.33
>    child8          25600       100.00       8.33
>    child9          25600       100.00       8.33
>
>
> With cursor (size: 1M, batch: 32)
>    child        wb_pages        wb_MB     share%
>    child0           5120        20.00      10.00
>    child1           5120        20.00      10.00
>    child2           5120        20.00      10.00
>    child3           5120        20.00      10.00
>    child4           5120        20.00      10.00
>    child5           5120        20.00      10.00
>    child6           5120        20.00      10.00
>    child7           5120        20.00      10.00
>    child8           5120        20.00      10.00
>    child9           5120        20.00      10.00
> With cursor (size: 1M, batch: 128)
>    child        wb_pages        wb_MB     share%
>    child0           5120        20.00      10.00
>    child1           5120        20.00      10.00
>    child2           5120        20.00      10.00
>    child3           5120        20.00      10.00
>    child4           5120        20.00      10.00
>    child5           5120        20.00      10.00
>    child6           5120        20.00      10.00
>    child7           5120        20.00      10.00
>    child8           5120        20.00      10.00
>    child9           5120        20.00      10.00
>

Yeah OTOH, we don't really make fairness an API contract here. When
you set up a proactive reclaim scheme, if you decide to target a
cgroup (and not its children separately), everything underneath it is
fair game to the kernel in any split that we fancy. If you want true
fairness or a desired split, you have to treat them as independent
memory domains and set up proactive reclaim to hit each child cgroup
separately (i.e one "echo > memory.reclaim" for each of them). This is
necessary for example if each child represents a separate, isolated
service/container/tenant. And maybe this is actually what you really
want - hit the ancestor cgroup very lightly for the stuff it owns, but
then dedidcate most of the reclaim effort at the leaf cgroups
independently?

But OTOH, this does seem like a recipe for inefficient reclaim. We
might exhaust hotter memory of a cgroup while sparing colder memory of
another cgroup... But maybe if they're all cold anyway, then who
cares, and eventually you'll get to the cold stuff of other child?

Yosry, what's the concern here? Is it space overhead, or overall code
complexity?

