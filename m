Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59FE3CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86796B0022; Tue,  9 Sep 2025 10:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36BE6B0023; Tue,  9 Sep 2025 10:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A255B8E0003; Tue,  9 Sep 2025 10:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A51D6B0022
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:58:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B5F613B055
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:58:48 +0000 (UTC)
X-FDA: 83870018736.26.64D68AB
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 530BA140011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:58:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gBF2lRsM;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6m8UfLRkwYkCoRG9q4AW4F/X1zLc8k+fkHHKjv2oYWI=;
	b=D59Pal2lOPPeT44CRAPHgM8ZrwA4uy+609+paz8SK0gaf3WG2az4QiDkm59Emky//WQK16
	72b4wAFShVBHsc6MPLQ19N0vizjv1bThjINDPPy/tX94Q8Th1NuVv4MiSetHAVaj2SFbce
	OEBcQK6Bz27BnCLnNtBm7jJ4nZyNqVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429926; a=rsa-sha256;
	cv=none;
	b=1U+hG/tAETyAM9kgUwc1YAMQyqEfrpZ4Q87lkiAU6k9UrP0KT5uD7pg76zRsLFCXe9keoR
	rxWnYaRG6o8uDzPrMJl8W9GVuY7zu2mEIAGp8G0tuo6nFbbocbe82JMElKAP9nE5BwjLor
	ORBCa+zecFM2AZSi6oFGUhixE982OwM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gBF2lRsM;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b045d56e181so856619066b.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 07:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757429925; x=1758034725; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6m8UfLRkwYkCoRG9q4AW4F/X1zLc8k+fkHHKjv2oYWI=;
        b=gBF2lRsMpbbvtYRdknD6gcs8MOZPTLqzvtnzhtKDFg3o651hUDiKrsBDCtomhOO8nV
         Mrn669gLxU29ua/1udv7/0i1PJC3RTCrAFRmVJgYogLqYkdp+r+uHvtWByTavGxDweK5
         6S7ZLua1eLen5jclDfEnldo19rCj7wDWu96wq8GDZ1hqsX6awI5ngDr3f0tSvFJIRwAn
         tW0eG90WuS/8OaO5a3iTOilvxRLejI5V6F1oMGJo7dF0kOw+9DEgw8G5GKFt67KFtmtc
         y9OG5d4PdW2L8g5rPet7yp0c6hAJR27fkP69MJbNzsbHxvMQYNHI5NgqDZPamUxSBxS4
         YJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757429925; x=1758034725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6m8UfLRkwYkCoRG9q4AW4F/X1zLc8k+fkHHKjv2oYWI=;
        b=D10gwOEZNP7IotXZzuX/KHEbl+kJZav0hSo1/umQdJSBELPl7yShFDiRTmdoPYIhmz
         3mhKd0sYtri/GD8K3izeU077KMmrm1BVG/CkjcTCJcXa1HQ8BlB9GAfh47gdoip4xpzm
         WrljznaB3Avxdn57KJf6OT33H162aQl4jWfRLAnKikqjlhqCnxv7Dp0Gu45Qw1BKHVU7
         xotqLygV2+7VFLK64QO24/2sAS453aLVZBV9DqrX/wmtVpu6R3vSUFTnLe5oB3kU3dOn
         mDdKPsBtg9aUhD70C+biIhYF/TdB2ZFcMb1cz8bfm1C942cNqO//up7qH2yL1hrZkMge
         rKNQ==
X-Gm-Message-State: AOJu0YwWPGiGexudsIop1FQu5bt7Thuvs/tB1yALKxZs8HDSIFEp1ny0
	KqSSeSq0dTpgtC/YqiwjcRyQkNc0J0a3dtsCRHsSQrju91nvp58Nr2NtaLswAgZYcN4KW0TMSxW
	R5eII2VZ1gpfG9aMiqClxINVMJvlXpF8=
X-Gm-Gg: ASbGncv6gCg+hOplGvYG0paMjboenpL3szvbyvTdjHvCfhasj/uw0NAC5rWCJ1E3yeq
	qSll1BVUEVxC5ikQsDQ3q9EmqJbyfrDr58nWDfLFTwwZ/CsRNSyKSdgeIUevuHMHKfwb6Hz3/il
	+bJIQXXAAp+DYGj4Crezl0fWs0n03mwpMMF73TJN6ZoQ50gx5EeunXcSLiw2C7TmQmF34J1uQ9w
	1k4cUONmuqcWkVWtKqw3A==
X-Google-Smtp-Source: AGHT+IFWy3IZpvbKMW0rMWL9k3GfHz9yi8+0YGLSFX8InBG0mqrVOBpoQPrpe/jA576SWjVAzPg+gM9DAa/5Tc1gW4U=
X-Received: by 2002:a17:907:d2a:b0:ae1:a6a0:f2fe with SMTP id
 a640c23a62f3a-b04b1542faemr1056559566b.36.1757429924635; Tue, 09 Sep 2025
 07:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-6-ryncsn@gmail.com>
 <0bbda135-068a-45bd-afd6-3f5cdf4e570d@redhat.com>
In-Reply-To: <0bbda135-068a-45bd-afd6-3f5cdf4e570d@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 9 Sep 2025 22:58:07 +0800
X-Gm-Features: AS18NWDGLlwdkrvwzMJL7zTY0JXDCsXG30VSD6e-dpjxVCyt6CGtodppdyFsSnU
Message-ID: <CAMgjq7CsKYWzAD0Ev7q0cocQO8kOYLmhgLD0wk6AX-HUzWFJZQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 530BA140011
X-Stat-Signature: wbpb35oa84gahcpoa5tduixgathtsyjf
X-Rspam-User: 
X-HE-Tag: 1757429926-307743
X-HE-Meta: U2FsdGVkX1+qulhojZo6Womg3vpgu9vEz4IMHI1qoEi/7cVd+ziqa7rfVn79cgVuBrYcYjYLdxM2M6FP8n/K473aqfsKY6xh/diQEkQfcYM7SSLmTo7WEpN71rhp11TdCdxf6agKcEzdg2XPr4DbGL2DW3GaoWvpEiiA5EPm2zV27CezJC3zLYXMqnvdpv9CXnj/aXiGz5mnSYDWh6syOV71caYWwNV0YjNh3so0W2j6Z8RrG0n6NAs7X3a1gcojlKh9Y8lhY0nlrj50Y1Jpt5s3p6LPk7Zrrftvh/gC6EIwuMSJQSAXWVVFOG7WnaoYjGtF1qnVD407RL4BKgjdfhJxBETUNdprWvT7HxouXgRz2mKPiR8vGLZN8C8UESvMyIPzXyzGUT8nxVRKo9ysKLKY16ieL81HqFoKg9NqfgLCjkLpRmR2cX5sWSkwK7em6oLQ/aYZzl9LG0iWtSxIpr7A21MWlRGN06HalCczZp2WEuKSsWVsVaScJPWBbhdVWaUQ1n1ci5b8PTaGvz8UKdLm9sHAQMTR7+RK09seu3I0v3bKbI4WCMlHsSGv1JkVyKt+2PcvyqY8BQH5Zb4xnsDl73zC0SMXX3e/e1KwTpBfnuNWgWs85Jxq3yrmv3mmaiEAJ2x0OInvTuJE9yKPCJkqRi0aK4Ir/yZ8jXp2YeS3aiHJimTsHf8hQ+27gdda2O8h5ni6bo3rXtq8QPX4dpERz5EgmDG9pcOx7cfYkkreVoWNpfSlLBv8K0KqmlgKNulDigHjHBKIwSMHFOQ+A7L8Jq13n1q4iEcpQIwUFdD/70UqrZYv8yAwBcgT5fEIpkP+YTTXOjOq5SHFObs/LBGWEmD48wj4/m+AagqUYci5IDHeSLb03WzdDAn8v/yYpHbD6zfpZY6wuIZpVRuo9coY5GR22ejN47w8q6qmWWche3CPUv2SyP87zDgjfdjYTj0oL6Ck/ZygIsx71kv
 paY2ZjmE
 Mz4wq4RxfNxr0YUG6+8aCK1t27Vkw/3DiUO2kWLC5+oULSsuN30MmMGoIVrsLoFCfezfMS4/nfDUX67Kvc+hBdygKYjX2DCBpEihPanJ0QmjDfLvf999i24ktF4/ZInS9ujPkTQJ24Npmo1hbloBIql7Vv58KDOvge76NDscGu4IQMH2n8sPbEW5qM5CCiEN5n9CoJ98/EJlCa/DmtakgTffDdacZtmPgeSq28439SaAVgnwsk7Ff8VRQVuT2/oJMZpflEdTi3cGkrDWNwMmemR9Pm10n5rYBUYJzpwWmR8SPUjQslagMto8R2cC5XJrPIr+Ok/EdbFQJlRKKOFelp0aEyxpkQSZwOFKFU/UwAFvez/PQUHC3styXqzUlCXt8sgItiG+ImmC+dDmn3SW9EN/tIHvxRNUT3pGLx+xWNwIqbsVMoCGWaYyGZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 10:08=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
>
> >
> >               folio_lock(folio);
> > +             if (!folio_matches_swap_entry(folio, entry)) {
> > +                     folio_unlock(folio);
> > +                     folio_put(folio);
> > +                     continue;
> > +             }
> > +
>
> I wonder if we should put that into unuse_pte() instead. It checks for
> other types of races (like the page table entry getting modified) already=
.

Doing this earlier here might help to avoid the folio_wait_writeback
below? And checking the folio right after locking seems to follow the
convention more strictly.

I'm fine either way though as there should be almost no difference.

> --
> Cheers
>
> David / dhildenb
>
>

