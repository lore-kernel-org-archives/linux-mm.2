Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19409C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1347B6B0095; Tue, 22 Sep 2026 13:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4E96B0096; Tue, 22 Sep 2026 13:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0BC6B0098; Tue, 22 Sep 2026 13:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE9856B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:54:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4085080599
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:54:54 +0000 (UTC)
X-FDA: 85242148908.06.58560BF
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4D116160004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:54:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UG3RsSaM;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790099692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCKS13b9L1ieft7U9s9r3sFPnYyRl2ROpAv1bNkHIlg=;
	b=VK7Oz5Pg26wZB2E5CDiNThoiMZofXkDAzY5C3Gka7cAOzhURnlRM1JJjndE/6YHeNHtSdJ
	cUCbJoc7U65AdWEISC746ly1zogvmaROGaAVrIjZVI0yGFzG68Z/MsM1MYTFypDrirITF2
	qUIEdLgd5MYrFNZOFZxwsAmdf/Wb4MA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UG3RsSaM;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790099692;
	b=lX9vx2jnWUHC1IWOEw4lyBpi+r+TEFipGcDgTIxWO2Ebmw5hC/gYFzLPYY6ySLaS/JDaPX
	JYjA9D7kaJ5kJlEKGz3aJFFRfCqkVbZbDdemj/rSN3KecEZTYtBQGjZnFpHTXZ9lmy0L82
	qz/LTovaBIW/c1eOJ/biSaSry2w9/xs=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-484366874b0so133612f8f.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:54:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790099691; cv=none;
        d=google.com; s=arc-20260327;
        b=X/N6oPFQ01UUJU1s7O2HWI9eXY/JY37/OQ8GjFz9rIOCqrnKaLyIgGEflcAzarljTW
         bM2jxUT4jHmC62mihHTkECBlcnhRg83Oi/h1p/IwBjvXL8lSck2MuxCLa/LdD6FPSNEh
         noqar9wrL8bbZGXcp6cVjU32hKFLLi4nXOBhKR+r+gUNGgOHocrfjkUOc1lDkd5AZcND
         nOVXUaDqafVOzr+9UiAeX3IT25kYYYq6SrcCnRPKHxUuTpVuFPdwLLuxntGQtIiwo2nB
         XPWubzRSDM3hEYNIK5bSLqFW5M3nmnVM2+9kzvUD97dmOIjzH/ngx2IN/8HPcXQFmbqA
         Og2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vCKS13b9L1ieft7U9s9r3sFPnYyRl2ROpAv1bNkHIlg=;
        fh=zLXeermId/cQH9KSftDc7uTHFQDqZ6y6+CP7EQeIscM=;
        b=CXQt7bDCMfMUbCjh9mkfHO6U0yLTyIV+Mvv19y7xxoSPf7MnjVBBZppO6zTmjS1Eq8
         1KVOo9FhRD75RDNTk97yuK6M0E0X0rnauG9Pa/51w/qyziyGlgNQVyvnEJemvgvglCcQ
         2kzYtk5XF8uJgNFcrCugb0OQBN91BQCVmIVuMaHyiyQgWsMgyTkb3E74Ijp1L6FMkCM7
         tJW4Drz1nomnG/LsgHIl9Ld6RK93eJ8yUw7gF19w5qTdsqS1I1cLCGu1aKUOr1Ak2oKk
         QmQfpTNg35fAAtIFWApPH94M2BU/Lz5ei9pLQLwJAfPcbcxkKSHSaayUVG045H68ELoC
         hg0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790099691; x=1790704491; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vCKS13b9L1ieft7U9s9r3sFPnYyRl2ROpAv1bNkHIlg=;
        b=UG3RsSaMP1BGZn3wTVJjlc3CBk11ZfUZKb85skshrtDo28b6VDLpG0rnd7HIcqEApN
         36BUqedrByfo/mmd/WgOqC3IhHEgkiFNMkNo6gl288Um1eHlYdENPljlwE/RyUH17fcM
         lCE1fh0GkY/9ADgeAmqSccuXZuCRP/2dNMdzr7/nIHMYJJ9z/dC73iG1Hz+N7Ku+ii8x
         P1eAqtPxVkpRPwpP8n+29YSzeZfhMUUYXbjs0Kk+lMFiRVRjelTGdzkXPQFFlzFDhq31
         JbQSKw+ekw9sbzJOMy9rIgki00ZVjaHrDtiHFluN8NH+bNhRNLlO5H0gPGOBYxuRYJVd
         a5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790099691; x=1790704491;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vCKS13b9L1ieft7U9s9r3sFPnYyRl2ROpAv1bNkHIlg=;
        b=PWBkWc4o6FOHByTme/P6AdDDY0fXNkyVGcRnBMc5Cu4YgumAP2C+Nhc2lCJq2JL5rj
         aqtZk3nBFFqYnEWswDn3qm55JSbayC6WpiuDQbvC5FjFWm4ibziLYUtjNhpVNYxq6rF+
         Obg3LoATwBnzYKS9XXmCmK7iqvDT7/8+ZS1+YiWWzSP/nxnhnVuNWhxEH7FmwOLRaPu4
         0JnggyqyZBrZ7D3yPH3gnviZmbJ9tfigURcXOVJsRTvBWuXoTQUFzb259KXdN8MpCcLc
         OVfDuV8e01PAjeIRliv/uhbGEPAy9KQ/hr60kWNX1vIq3Bh/nStEyAuDaD76P9lr32sg
         q5ug==
X-Forwarded-Encrypted: i=1; AKwUvBzXX0zEa5zQsID1yojhQBUd/qPxbj1dHQqwvvJd4g1FMkTXll5ePHjRhYvJQtbRwAvHp4CQUaThTA==@kvack.org
X-Gm-Message-State: AFuF++mPqdG1DqMK9ZYjvWMAIP1o2HouNjLSpuAZupwIYzRpKIP+0blU
	V04H76FgZb/yxoHZPEtEEOzfrtx7FTiQPAnVKiJNCfsxf0ZlVjj/uTUPVcgt5SMhvE/r4MbSdo/
	73m0EmDqHVfLnBBCbmIaik5RN/+sG8go=
X-Gm-Gg: AYBFou0B2wXo19RnPC9+PyUk2jpfB4EEu2jk2QGJx5BzjiEC7txg5GOHlPyoaTG5siZ
	gXgTyPN06dRIUAP1BwOu0pJd/b0rkO04RjdTkjxv+ug4IDGT7ljZgtrG7aT1qErue6OC6Cezc0B
	qPoE+s59pVhaonHftO5wLNkZhTwJMMFwpdfwhVei2nA+hqSA/SP5Vshzko4SV0nHsX0O3SZ4+nb
	SZI5ijyB8AKieItORyuo5BBYtqkDMiB0/az5EYQPcjgPv4Y1jO/N9C2soqTrfhMdLC8txppyt7O
	cQmeL9VU/DSCiKHOrREPtkHW8an33wdRT50ri7upV4/OPRpUWcYkyCODw0VPRJmmqih/ehOqqbS
	R0xJCLnwHaZqGOLnkflndNw==
X-Received: by 2002:a5d:64e8:0:b0:487:40a:5ba8 with SMTP id
 ffacd0b85a97d-4886704c06dmr682814f8f.15.1790099690760; Tue, 22 Sep 2026
 10:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com> <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
In-Reply-To: <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 22 Sep 2026 10:54:39 -0700
X-Gm-Features: AclHuK8GLbQTZvdEds8LwHBLJi1-Hgl2pSvGmQlVhhpHqGOi40_tcpI9Kqsywu0
Message-ID: <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: nmc6mnw4p1hxutwxaoixrk3gt61d6eoh
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D116160004
X-HE-Tag: 1790099692-160513
X-HE-Meta: U2FsdGVkX18jZE446bHyf1MijWCnV4/apuG0OCF7RsiOd82Ka501QMMyp528Wj//JyxAkt/3rAuQggXRRTXa0ojRpuS0IHQ5RLKlS+LpJJzf3B27oXEZAxIwnTd1bcxsSPN7GzYPi3fyDBFdYEReF7dqpzeKGv874OiphVu0EY/u0XZkMlaMZz2Kz1gNnFoxwpank1EiORsh0/prNbIHDaKismcNuNrtIM4T7dj1UzGB35Ozgrh6mc4MkSxptR/wfCTEnoRqgwxv2GPvCPT6Hfj7+fFUdfqJCpv3NPZVbPudWB40m4rWQWNJRczYOaDI9PizXFRfBrnMnt5PIkH79kaJcz0QFEzHhkxrdFucIgcPrd/jyfZxqdryQeJh3FD1L8a5eHKBndnmtphJWIJ6vRKdUBU4sk1v8OD/CFkASRHuVJmR0tZDp4+jMMTwdoR6QoQi0oEDyk1peJ74VeanHkPOD/GxiGJZG/isbQVM4zk6fsG7kkwTQiWTZn0x962NwkL7PhdnyxRledeJ2y8u/lMQOrW4jEg8i1uZupV51PGADvDo50WZbAzD4SerR11BijW/2lQYiTQp0UVWSkXGn72q9yFMu5aYg3w+Ugz5+xi4ub25mQpKLGv6GFyDYdNb++0DqXjndftiINmmKUgjDBqArukzbkNMFxuHUsVdx1zXnfzD5hqI72FOPO+T3bt3HJWJnPpM2TUlz2T4iv4B8ptvppQhvvmNw5f3l7mb4dFhLdZJQbzfBihqKfvsCVDN7p0fchpPNHzNpQGm+kOeCeJ8fKIo3hJV+Aat2nMHPKMbFYi7FzjPF4VNVGgKrVAYaMiOuoK3p7ndXTF3pZSrCesTGV0G++w5LKqFRHd5PxAWQrk2dyHqlo05KbhveNcPpaAPfSWVvpWuCk7dA3+2RqQlQOQQmdQSjC5Cvg7BltFHkfx3ekOjCXW+ZHsoA8cNWadO3B90w0MYcby1pPE
 L47B5Xio
 uHBWGAm1HLQOryARkuBlA4l7Xu1uZBag5640YWzNdnTKa+ygIgvLqDcFyVVV899xNpv8XWrWylc4m+8iJFoHYisG6yUw99PQYG0CASxD2jvIm//DeW5AaO3iAhQSPFeDfHTTFqdMswFPGTGBSSpBg9TBAV4Vy8Vc7UQCvOaiJt7Tsph1pKckNjWNzAp4Lu3aAU2PeepcV2g8dV3WjcR0Fq8AHpTmnre2ZR3w+uYoK4LgOgtIdidUz2+KyeIkCnBQfBov+lsEWW3f4CxQLz14zOzVkd6cDPcTbVlJ5xcE/5/UDu2+hjk2r+fc5Xl7vPt8AiOC3lLiAlLlm9C7CAmvlLmTertvv8mTXg8pGV4a7RZOPFiRW/h9oUoYhmJvRzXCyeKyqnPdtaGCUaHgGHmQWqc3/Aoo76rU+FESjxlmLQ/Yj75BmilDLlvKmOKqNNGFSPfHT0/oeWZW55tZXYMxzE+fpT5WFoxkG3JOA2RTvkVf0grlI3B+1K9Gkgiq7j+0LldvdmlFY6rQtRsZnKdyeJZWYg/Nd2lz4ZN8n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 5:13=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> That is not what I have in mind. The example I have in mind is that
> zswap is charged to swap counters. Changing that behavior will break
> our current deployment and that of many other. Kairui give some
> example as well. That behavior should not change.

We already have a knob to select vswap. Users can turn it off
initially, and/or update their software to handle the transition
based on this knob.

Otherwise, you'd never be able to introduce any behavior into the
kernel. Hugetlb accounting/charging is a new behavior, and there were
softwares written before that assumed hugetlb usage is not charged. If
it's not a good argument to block the implementation of hugetlb
accounting then, it's not a good argument now.

