Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C1CE8FDA5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 08:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37EC66B0089; Fri, 26 Dec 2025 03:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30C1C6B008A; Fri, 26 Dec 2025 03:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F85B6B008C; Fri, 26 Dec 2025 03:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5566B0089
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:31:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE9D2BC4EC
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:31:26 +0000 (UTC)
X-FDA: 84260952972.01.87A724B
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id E224720005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:31:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XZ8/2ycj";
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766737884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ETCCHt7IoGydBghoCqkBEptevXP1DQGbUxzA0otMJg=;
	b=zHqN9IVl6p3E+77OlGBDft2xLybwsv7CM3nPYs7XMcPEy2ZalPCoxjI+B1Pkmbfrbta4yb
	XJHEK0Vxh3WJNzWie3DhZDPWrVXk0VV6PX4984K6sYfs3mtpqmu3N3WYmdErw7SLI2USW3
	edNzljVTdn2aG+T3NQ96B77fAfdx35E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XZ8/2ycj";
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766737884; a=rsa-sha256;
	cv=none;
	b=WIYYJdtC6nX1IE3FFvJ1vUxzyE3IAQoKRutjFvq/uN9O5y4ri5V+P2MPu9qThgkyTPeDCK
	Y4GYtYKoneGEQAKY39+Q/WnFm1XHATWdzfhZvDwmAC+HnBwIFZzLeJu3gg7wZLBTVBHaTY
	tEgKCJB9GfB7foS+ufkdqJFUR9zqe3M=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8887ac841e2so63607666d6.2
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 00:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766737884; x=1767342684; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ETCCHt7IoGydBghoCqkBEptevXP1DQGbUxzA0otMJg=;
        b=XZ8/2ycjCy1duhn0RbNQIs3yl1WIXCY/laYKe/hMKYxSJAz1SpCQJEXurA71Ht9LQC
         tVfqxIVUFHIZ4d59rQZYET5UbZwCxjcwa29Jt7YX1Zfw5Q4wfCuyC5PozRNnCjPr634G
         OQ8ovWLCvTzd/Sk2+uAZkoWVOpmeDOfp9uiyH618f9TTI6Me+fFGePHkIYwfN+oiHywx
         ARxA3lW73/rwpRaQ5tCC+26b1tg0HtBB8EDbLfPgibJNoQBg15uwPzpWhnMS3MMbwtik
         0TDYTiQ3PsKRQDFnkwz//3QLwJX88RBnrWNHie1IJaNVoqmABzF0A4Vks3YPDj9CyN3S
         kQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766737884; x=1767342684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3ETCCHt7IoGydBghoCqkBEptevXP1DQGbUxzA0otMJg=;
        b=C0bkGOvZFuFJeJyEQ1TNzLNzX0wmkvltZQqlmxPZBP1RyKBioxG6KfErDOrzeRcAGH
         KUlIvIQEGJ+4/tJvuMGWMYyS+JHIObJft58Qa4pHGftzBgKBHYlY/d+9odungvzJjjpY
         ZlRFKdAi63JoW46Z3nrWuBWBUCOK4MYlOC8kPYnIUv1qCc68OaJ85duYVaofkQA0u9wC
         oUcwFyQSyr0A7cuMglgNci0XwPuvVfQd/e/R+nkGdU6jfkVm3MVCtYKIrPjC28eWAiUg
         DHGx2Yq8HKUHhT4QSLCWGF6yJiuNkFwGSHl8dYttTfcVgQNBiSSNzi4rO9WZk6Ny0Rg+
         K/bQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCr3rkf6lWbIhSiMxI3S3vln7K1jlKHK0TKXiVGn/uLUjapi81c07A6Ex9PJhg1YpSiBWDiEpAxA==@kvack.org
X-Gm-Message-State: AOJu0Yw31FQQY+tbozSBXDaPs2QblHLDNcuH3b23NT83TPS6adgf763k
	PTzJqxT+6X3VGZTt82wF11V4S6DwhamBhedtln8a92K8LB7GFTQF7/BSIG8URHsEgoIsJjErHka
	D/ePAjCg4B9vN26DA0A+u0s7Iu7MnDITy2nsU
X-Gm-Gg: AY/fxX43i2C1MSLqBFtwcRDxfsJ0wcWIbgrg90gm02wutjAFvEGCYOM6WEp8iUBWhU6
	Dx+96K5vj4j2vplOHMkSWxICd+xQS/VXqwItD+xCHrZnQrZlcoEWFoscslW5U+n2UAIexRpNoV0
	/zm/5aHd8vg8dvaqxlN5VuWQIskLLVczL/S63ZH4wguiH6VZ69wPgEobpJQM2l3YtO+lD57+N3Y
	ZF8ZoNReyI/9B0oZoY0FSk6sJVeQn7KXgHGxfGC9alCE3TVRKrnHzNBQumbRl4B1nuhJF2sAS8l
	eWpV
X-Google-Smtp-Source: AGHT+IGlo+LNZk0/EWZpzgtTa+eewy9uUlgU2pu3xklivftu/e6+goucch5R3j67a8EiyZc4sKbd4+GSANbMdY5eOZw=
X-Received: by 2002:ad4:4dc6:0:b0:88a:31a9:ae4d with SMTP id
 6a1803df08f44-88d881bdc4cmr260654476d6.59.1766737883763; Fri, 26 Dec 2025
 00:31:23 -0800 (PST)
MIME-Version: 1.0
References: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
 <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com> <915dc88b-9131-4520-a2f2-facadc887bbd@linux.alibaba.com>
In-Reply-To: <915dc88b-9131-4520-a2f2-facadc887bbd@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 26 Dec 2025 21:31:12 +1300
X-Gm-Features: AQt7F2qQ6-b32qG0-PITUSPaNlNbQaGfg_aC_VktZpMRs77vq1i3irw977ou9Bw
Message-ID: <CAGsJ_4yQtFK8wtMuJ72ce8KFRT7mB4SZxqS1MKi6RA1WDNkm1Q@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all pagesizes
To: Weilin Tong <tongweilin@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	baolin.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t8nq3e63cw6kzxchdrrruf8qhkxthyob
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E224720005
X-HE-Tag: 1766737884-869471
X-HE-Meta: U2FsdGVkX19LUdGbb+rgHixlOdMhMi+1m0dyrs+x0K0W89412g8AdO0cw5wvmeq1BKtm0m+a80TiZ+E29ILxIZJeWHpG+hehTX7kipNRb82xBszjkxNWKG789HOTVzMhZGjlgnAb4ZSVCWMVEF3ZiUChxzF3XAJ438WrYRfB/Z/RwF8xIMeLtSSCeYRoZn8RL8As58/49Hae3ylR1h+DUfhnRUHZuclBIpl836sh00Z4zZyrU1vaRVxYjlytxctbWsnLuepaWX5vSwtMWJS8TUrScdCZ0tpCPxeLoOGXaoHZQJMmFd4t3UR27xZiYklx8kzvbYDwJujrpkCchIDUaZG3vGjhNiI5bhHowoh8DDav7RQ62Hl9A22W8xrb1egLStbIrH5C5uyoHNbwHaOtA5ymg2ROrLdru3O2Q+C8ynGbzd0kZbv/+Pyr8AYalY7llKxbam6/CYF2DlX/47V9nOqURNJ26i6HhtygR+NyQxzAW/da4DSAZkbaRj+pIezs3Kgh7epRV+ctQjf8KYvib2kuLEzobiZZdH9iU0au6cRw4kT3utilMTqgL3i/+YZI06I56cuzC2wosvXGDYzzhXqZjD4YR+s3llWCzpkTTyP68Hk3iWCQ2kCOzlCmmPWJMdk1P8qyWDuh8Cs4z/ZWU/Whj8mJ5TISWS4H+DTOaYmkkBMxFIyrUrt6hw/MfUSZ/cyZsaQERn14E7li5MOwl77XGTPOnBA3akw1xq5l+E/1ZmYWhL6ie6Oey3ztElGBgoSz3Bn+j5TUl9tZEUzKGj8k+WfxBBQfgqRsmD/b6ehqsfkQ0BCUJI5k4EwtsptErq73ngSWTbUGO2UnJLVowVaPe3v9zK+U7VMMRoJtS5BKRfiNxJZX2vojzydR0XNwQIu2emnJcGNf8JSSSAYPnMzR5OCJoFA9kzbKdBnj8iBNO7kjfyrzCApxX2zmNgIcS4tHUXMbJeOfbEVWIvw
 mPpJBo0/
 VS3N0K5YdqZ1u8Ea7/0ObOzXEAEEe5DAp77fSwx/mNp9AwGvtCgiSnKZST6oqVHdnJm/Y1OlqjkUn9cXKgwdKK6HBAPve6K0z7MPgu9FVSsC/UWscyLxA4RbOIWAMHep3TDwIDAElFEHvIrVhNARcTl6I71+uqPQryOupNbV6OMcbS++IHudDPKeZ+RXQzkdroSV/4cLupPMrB3rTzJuQUx0GIKlWszjtwE/gT6zVrL06KFfXM/HKAeNVK+H9Te14TEAvz0K63CR5QftUh9kTxLx3dm9LggfQTVhQszLEqjtuybTo+x30j4dcVfzKwHYGEcJQt4us2ScOktsIRbkibYjGzDAI2Q1IyenSmCtuhmfaMjoaQSluZvbUBpeEM2XyGgt8zRUWQEhSeyYyPCiwhScUKmoRJwOrmxCdFrMmle9z5aQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 9:18=E2=80=AFPM Weilin Tong
<tongweilin@linux.alibaba.com> wrote:
>
>
> =E5=9C=A8 2025/12/26 14:52, Barry Song =E5=86=99=E9=81=93:
>
> On Fri, Dec 26, 2025 at 7:39=E2=80=AFPM Weilin Tong
> <tongweilin@linux.alibaba.com> wrote:
>
> Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kernels,=
 but
> large folios requiring swapping also exist in other page size configurati=
ons
> (e.g. 64K). Without this config, large folios in these kernels cannot be =
swapped
> out.
>
> Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.
>
> I no longer recall why this was not enabled for sizes other than
> 4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
> it appears to be fine, and the swap cluster size should also be
> more friendly to PMD alignment.
>
>
> #ifdef CONFIG_THP_SWAP
> #define SWAPFILE_CLUSTER        HPAGE_PMD_NR
> #define swap_entry_order(order) (order)
> #else
> #define SWAPFILE_CLUSTER        256
> #define swap_entry_order(order) 0
> #endif
>
>
> Thank you very much for taking the time to review this patch during the h=
oliday. Wishing you a happy holiday as well!
>
> I appreciate you pointing out this optimization. We initially noticed the=
 issue because, on ARM64 kernels with 64K page size, if large folios are us=
ed in shmem, they cannot be swapped out as a whole during shmem_writeout() =
due to the config limitation,
> and are forced to split instead=E2=80=94which is something we wanted to a=
void.
>
> It seems that this change will help enable better swap operations for lar=
ge folios. Thank you again for your feedback!

Right, I believe this is the correct direction. Just double-check that
the MTE-related functionality works. Take a look at commit
f238b8c33c6738 ("arm64: mm: swap: support THP_SWAP on hardware with MTE").

