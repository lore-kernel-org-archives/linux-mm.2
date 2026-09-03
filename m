Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7A7C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951E16B00ED; Wed,  2 Sep 2026 22:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903556B00EE; Wed,  2 Sep 2026 22:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2506B00EF; Wed,  2 Sep 2026 22:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 533136B00ED
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:22:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC2F8C03EC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:22:23 +0000 (UTC)
X-FDA: 85170851766.19.3DC64FC
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id EB905A0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:22:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iJ9jV+uG;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788402141;
	b=Mmysgi8J48fI6tZe7oBhCVXApIvs2bAECv2ghHn86V0nG8jIx2nTxAzSN9tJ9bL/p9tULG
	KZBRPCgW2UOuFGpZa8iRwPs8Om5aBcqlorgGLb98dYHgzAtPeGO2hgr59XgSrVqSwv5T5C
	MBruHRsfsOuFwpXtH0Rv+wAuR6W+F1Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788402141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzF2akW8js1Qtl2W3U8D53PAMgePI3lJc85Uvk4KROs=;
	b=Nv0ITOjAdZNvwCsTDgsjh7yyUhLLoZ4xgQewZy8/WrifkE1SUfzPCGiwm3oHXlMOEDyK4z
	+0lLamkZSCOVhNS6QAc8GAdIyjB2YqrLgjqWykikjosASVGr+fAG1+CfTzMpGY2nkbsU6U
	kLTNrrHFWe1p6BLVFjQkK97vZ4OFWnQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iJ9jV+uG;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2531f453eeso251037766b.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 19:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788402140; cv=none;
        d=google.com; s=arc-20260327;
        b=sl326twfwxzT8+sy99VaXmxy3YW4g9mnEXDU1vZuHpoGhiM/mWiBrLeHY+bL/MNEow
         Pjdav/q5OyvqYp8OWT4pDq3fR0HJamKlG1SstDbFDyKG0M6Vij3+4PxWzG/ruQQdGK0d
         6gqNaQSAb4Lln3UnroC6rmo8cP68p6TYRXWQzWtge/tpiDiK7X/VK65SIt5KJNjV3SJD
         fZmBGY6LO+aah1qAeRHqtBUoT6GmcE2uAUN7OaiT8i2edrPHn2E6Uw9lfCRLJjctLMqo
         DkxuMoDB9LkRqi/fxDnZ79Z9WNvcH2CuBqRX6aWe40EMA+snENPMNkPbeDkD01LbTNrJ
         fi0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uzF2akW8js1Qtl2W3U8D53PAMgePI3lJc85Uvk4KROs=;
        fh=1EvPuTA9BZP0PmRamZs+Wmf0UhGlhdCpHrFw9s9D1QA=;
        b=WE+BS1ys2L/8xs9gtUYUa622Fy1NZWokHBJSkD+qLIruGgeU9nYRVe4Hu6AHaVRWov
         h9jo5V+LcQhY5n144+c5Pn9FhI9dAMAbfYAsUu3dom5PXkn3WEGSq7G7nBszXHIlcd05
         iZ858e3nn5hpru+kKZdC+9aVkjYJ32DURST4i0IW1rIrce2PMeUC116HHSRPgypeeXVq
         23hTd121Q/HCcP+/6iRR+oInMRuc61kD8m2QuFLldx34YAkUPbc+TLTatZxrRje/EvRx
         tPTntqDzYHsQW3uDxtb714JFiHf7D/22ks8YdJYANt81PPRyJNWmndwmVv4qr+pL8AAN
         b17w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788402140; x=1789006940; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uzF2akW8js1Qtl2W3U8D53PAMgePI3lJc85Uvk4KROs=;
        b=iJ9jV+uGeeTdMWbe4SECOTvyvuc2M9Qk+ScFCs+3LedTewzabnN2XdNv1aHxnUpU73
         JQinNIcCGSXVoWAZATciO0zi5ao8H4wdnewh83p8zkeBSN90fUnho/CmW3s8ldlYMWOJ
         ZCQRdpXq/wp2pHzzdE0nUE0+Qre8EYRTUlHXGANFGHOYg6+eqzVsXPUPp+fuBcqX9c/s
         +mkzYYzmyI+Bgp3kdWzHYs2r0YhIQv/XfHoGBw+nKlQuAMDomdks8yeURQm040HBI2dI
         BuGRuvZAAovzJ1wOPyRCNVzqm3GLmfZqqgDo1kvoLzjcWqAGcvNzaSMxhPGjbCjdwjhZ
         yi0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402140; x=1789006940;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uzF2akW8js1Qtl2W3U8D53PAMgePI3lJc85Uvk4KROs=;
        b=n4CMzYc3llY2Sy3Uc0O0tZKBLxhCT7gcjaa0EwpfbHFujCGohqYUnq7eqXQC/HQD/w
         G8fqpGVVGNwJmBnLbWoBMv6iS+Pe1a8bHW+gAnNrmP+g1t901TcvsIYVqOQmixU81qz6
         2vSvMRGxNn7LhWfy+ZsZNzqUnv8f0cCcQAT8glDmS384auVahMBd69ZSIqk+e8x4Q2Ix
         rKwprgDdpfxS8odA3ERkegDiDSWo5tpiofLnqYh7VIwqMafx3cYp6vajZcl7ECS1g/AV
         C8KDtyxjOnIeeK733jvHJwbFWgk5i71b4kbGokjCCk3gx8PETwzD3FJKlD3/jAG87E7x
         WuPA==
X-Forwarded-Encrypted: i=1; AKwUvByWlzxY4+1jEJB8cV54fjARZUVA9hK76v2UjNQY/QIIThAWkHO8576mZsWM9/RecJuH6PP1VFWUdw==@kvack.org
X-Gm-Message-State: AFuF++mdawTinGS6ZWz8MZASx96gXkMUa2Sn4igTy9a/L7pw9SahKGmC
	5XgoitZHYbngL/JI1pS5t8bLPQqv/SOxi50wEmYFgxi7sz7kvu/65X0hZo/elF++7PLhaM9MBS7
	QmZggn4RMjXrvvVRgB2lF7dmFNThYyfw=
X-Gm-Gg: AYBFou2Sw1fNeUbPUGRENr0ltVdwnrrgPsMTruRsgvrtjszK/ldj0D8nF6+UbtMqGa1
	5CWibQpJzjn1442qagyXVZdHY27lM8XlV7IYDuPx9EYgS0luUOpYwVB1pZu1ExOr2oqJD7w6njF
	Y1PFmuDOKSX5HZryHDnArZUvTixg7QuxNgX8A4PDuTIX2qurKGOKq7rg86x9M2PrG+HJfEG0/wa
	Sj21kbpt53JakAMyR7Oid11HvqqPtp7riifWiVoaSt3QvgsRDcxqfe3nNuUQDn5jpR5POOUDi5K
	5XVrPYEVAVvlBPVoj1dbFERuEYzMHObEJ+Rivk2pwy3+tadbS+G5bZE9gw3z/hTiHN5uoODVPkt
	q
X-Received: by 2002:a17:907:940d:b0:c16:84dc:9607 with SMTP id
 a640c23a62f3a-c25d5509043mr579045666b.19.1788402140304; Wed, 02 Sep 2026
 19:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com> <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org>
In-Reply-To: <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 3 Sep 2026 10:21:43 +0800
X-Gm-Features: AcwNN1VaXdfXwDwuHgeUlK13sDpqUXHJ071CJYvST4lMD2Ml0BFv40TbHBDM9GM
Message-ID: <CAMgjq7BoNJMxZ0DSCyJHZ+KHTP0pwOp8C9298PTYZK1OBv7sFA@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] mm/mglru: clean up folio counters and flag usage
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB905A0003
X-Stat-Signature: 9onrp1w9tc9p85ifb19r48a3xfdcm5jq
X-HE-Tag: 1788402141-187977
X-HE-Meta: U2FsdGVkX1+H7/szYdxeeFSYLxFYieakxLINE+RkUeHuYEyp7bpOKHul7lVUo1uI3PTW/qg0SjtqWQ9EFaR6fpQnQfN7dzNwECjs+zL/cglLk+BGO2pZc9JHJrePioLRsSHBiDYsS1IXYtmzWou2hQWtN+2W+dKFCOytxCwPogikH9qL6NKS68JyhY6OdrnuJvpGT3eDJSikV7UWAE38oEJ39yQEV0W8MPBczeS/lS+4IvInvod9pFYwq2XRUFV+STy3L8aTh67wT7fJv6ClzUKerzt36emKBNwiCWC59AYQEIp1H/rueFQdugUQyp3kpdkT9+dALcTBag7kd3vqr3nUDwWRMhzwucRxuRimfmA3jrwEKKPLJAo278iD6Nbh9vEGj72UJEV4OF2by51htulXYx3nxZTIDCEQxa/1iTPCpXDxI/oSu+Vjk2Ch5g0Q5IEfhSe6vzfdCGMr0kLctKuWqj3paJWgdJpS+OoU2yctrBf84WPuFKTZe16IyCTyLMsHIh+p/mBGvSOureoVCjg4bNWLGwJY2+tykI9OPlTU8sgOEG+QHFAl0SecXSw4dc8cp1Woo7HPULA9ZTAS+A0YMYO4ybQ+GTvi98kAa3pdEpmN4W+zubREnhKzz62ZMhGWgYP6QR/xWyLY/zxmcS36kt8Qjp46X5hVIg++9sev0u0c6vd4YUAtcbtisFybKt5Odu21tVKNQdxXlzsrgh7Z7Ob9Xb4YMnpFmctpNxOg7xHQ+ryFwlWkt0uEAa8J0D6XhRsKqBkod/TADtOoRj6f+JZYRkSdi0uNitqeUvKsbDObTWmfrlMyppdJhLwf9vU0z6nI1sKN+Z7EqlypcDUKee/jlXsA63A4EGmN8mmpNJnWUUSE7Vcjl3yKMQlsMw20U4yp8nYLOr7aPePlGUasczXqnT9HLUHDlxppNj6Z72WYCkjooA/2+0x3oEHERCoedhFk2gZBOl1MEe+
 jByq8bgu
 bcTTeCHki+CnnK6wAnszKbAcwat4G44JuCr1Qu3dpcwFKe3ZS9WmSFNokIV6bXS8IYIDTK13cle/OpDLlW38ZJ6WkiD9MUnFl3rLQjZV4jOiK7NHTaljhYNrap3DybHlGjdpuBuJYrSACpRLH292nj+UPnE6e34wSSmGVYtp+jjX9OO3DXwyWm24ZWW/nN5SYgF/u7hhj+3O3VHgeZpNeQo+Q+YUe4XQX55rYGCk8eb85jdZqCJH0ND5uQbGlk/GHwoOkEJGjRM7Z4WX07IdQPLCdr04jTO2GOz3UjlnvQZP365sJBm7cqSOCg0riPil1Fd8QaZOKk0W+exNyqWj+/aoj1D/rLkkSTDuVWqYhnvgBYORtKlhYUGMq41uP6gpty5ZqC74GR+PPfxY5Rs18PCCRsH8qGERFiwlsI04fkTdDmf7YuIjcvpwFYr8tKUB9/wIGeNF4CMSP45PQ93jTqPfy10agzRRw2g+InrdCHTRNX6Z5NET5NJt2VxtE8XpFilg9jjKtz/8fTEGEESvP4N2YJzDZoZJ8m96lMqNgVMyd8J1F2SlpHkB9DkwEAxj1YnlHUSOFpcf4XW231X5X4VUJnlakllKL2cKwmTKIOwgXA1Ian98ucbcPczfmxu08cfrmT/+zfnMjuvMbjxV5tYrX1EEpQiaqCMSA1069r7C3xhmkFEJCa8Y4vwsroInpVMUSIM+ALoaU2lsB0vCvDAVcGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 5:11=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Wed, 02 Sep 2026 17:50:53 +0800 Kairui Song via B4 Relay <devnull+kaso=
ng.tencent.com@kernel.org> wrote:
>
> > This is a cleanup series separated out from the MGLRU-FG series [1]. As
> > that series is getting too long in following updates, seperate out the
> > clean up part for easier review and merge.
> >
> > No feature change is intended, except one bugfix. It mostly replaces
> > the open-coded bit operations scattered throughout the MGLRU code with
> > new helpers, with proper kdocs, sanity debug checks, and hardens a few
> > MGLRU functions.
> >
> > A subtle generation counter leak is also found during the refactoring
> > and the fix is included.
> >
> > Also collected review feedbacks on the cleanup part from the posted
> > series.
>
> Thanks.  I hit a non-trivial reject in [2/6] presumably thanks to
> mm.git (mm-new) race conditions (appended).
>
> The patchset comes nicely review by humans, but AI is less happy:
>         https://sashiko.dev/#/patchset/20260902-mglru-flags-cleanup-v5-0-=
9db761d779ef@tencent.com
>
> So please take a look at all that and retry in a few days?

Right, I checked both already, sashiko has beem compalining about the
same issue again and again since V2:
https://lore.kernel.org/all/CAMgjq7BheDgQZa0=3DKiRnxVwky9by5LA=3DiaexfPfT0W=
ftgfL=3DqQ@mail.gmail.com/

It's safe to ignore: not introduced by this series, and not a real
problem either.

The refs part is also fine, it barely has any real effect.

Should I just rebase on top of mm-new? I also saw Barry's rebased
version of Patch 2, that looks good to me.

