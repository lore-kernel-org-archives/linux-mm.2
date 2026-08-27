Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7282CC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F346B0095; Thu, 27 Aug 2026 05:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BF426B0096; Thu, 27 Aug 2026 05:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AEB26B0098; Thu, 27 Aug 2026 05:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 254956B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:16:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8763416033F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:16:42 +0000 (UTC)
X-FDA: 85146494244.20.4597E4A
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id C6A3C16000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:16:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KLj2Y98M;
	spf=pass (imf08.hostedemail.com: domain of hughd@google.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787822200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wURAAqpmYnRm70wHLRDHhfOf5KYKWGXPLGAT3tMJ/w=;
	b=Jm1R2iYqVMdYRZ0v1B3SaDx91pW6Z76jjeXZ0fpk0HTbH+K7+UN3gPIC0h+aF5C3UxkXmC
	51mLr5/nGEOpOoYqZLRTWFt2zmIfgQWhpf1RBcV4cesHk+/uE44htqEW61ADjjJS3m89IL
	dPZQV1QL+C8y+fAQAVjdGpcZ6CB3BjE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787822200;
	b=eFlVWMSeTD56Cu7DOI7UXAFEsWVz1Gv3FUZ3J69zK6+AayaC61XGyP3xtB/uidb50VpkRE
	P/COBAI9mPDvDy6Mstnplgj/30ky5abMbiZdzispUAUgrrguhnE8/jqXfRthQnIFKN/gYU
	+t7+FGEmUs4/J/tHlN7rYN9HcOtrnKU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KLj2Y98M;
	spf=pass (imf08.hostedemail.com: domain of hughd@google.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66d2b3092c1so2273590d50.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787822200; x=1788427000; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/wURAAqpmYnRm70wHLRDHhfOf5KYKWGXPLGAT3tMJ/w=;
        b=KLj2Y98MvK2pHL0XkCgUiJDsQSkkhFAqDqsWq+3ZMP684Cikm/7nT3TyZqTTHiqwAy
         jU1D42pgNbUF0Bsl7tf5O30UtGGXrUNw5UAApuEnYI7Zbzm2KXZphfa/4SQyVU3EHhrp
         Gkm/ScaOSybr166oyVZzrp9m6+6hmpzaM7q6Nfe3gu5V+YLE/RAcgSrAdD84wIR9UGiF
         8RrjssAFlp2x5GGQg012LYsRA6sUIlIbB1v3HwWXi+CunhcJQfa13MqMCiG+DxZAwYYS
         a6ksgfxk3zgAJrnc/vT9Bq6vXxxd+zAgcSdyA5ZliCi/SB3VS5wj4zEw6NEQEEZl2gCT
         LasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787822200; x=1788427000;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/wURAAqpmYnRm70wHLRDHhfOf5KYKWGXPLGAT3tMJ/w=;
        b=hULQON186wjbZbyNkBz2E4O45cUXXXPhK0qTQc8By1ryv4qtVGoK3Vc2mS2TIJhTKI
         B81eFFmcu0s3jCU1s9GpxE5w7yd7a+NBxPcUZLkRFhdWGujiDcJhkoObdezyTKZifWCz
         z5yqfavDUx5REGiR+jm6POACfyyFX3uihIXsHS6uw4muiJAPN/O53ViFCJsANhcTGhhv
         ecI98Kukc2pLwX/zHTlYzLeaIhYpyAd+nwoetrD6XYdWe5wWWdKqVe0thNzarrc3kY+4
         WtL4niJ0SuFZCjsLXvN55290JTONwFOsVu23yLCgNvhbsQepHqA0pQoNkZEW1ntLPADz
         Epaw==
X-Forwarded-Encrypted: i=1; AHgh+Rob0TtFHAYNzIjM5mGWrLCkDfesGZQPvcFAdKz07h+bJ3W0PS9xvPXdKW+PE42cTK1CkhRZ8BlYcg==@kvack.org
X-Gm-Message-State: AFuF++lE5B9uR605k4SIeL5A26DPuhtki5lpuUrIaHUj3nSxOLyge1l5
	Lek0axf2d3RSO5I0qcJFDfRLzleANwAxz1sJoDS/t11ou/fXRH4zDj4pPEPybIxBUw==
X-Gm-Gg: AR+sD105np7tdTilKEDdF3cfDgyTrspynVHED5eRm1K1hGl9y/pBxyyVp6t/t3Y/QQ9
	aiUB7kYVuyMes6jiV1Ugi/SQ0l3eE2LndArVD/S7GliOrQaOa1kGUXfUTBMez7IAYdXRulOZBLO
	Cp7GePrN8mllkplRpejHFSVUsKM9HRfGmdJyZ30JDJ++NgqsWD3k+rpYjjIuMtbQZgUhowLVOIs
	UF40Q4t/Rk05Ovk0lZEEwSuFJcPa5nKIWKVCEloP6UlvFahTwS0aee/wW8ONcsNhax4jCv486mF
	7esfPAgZy5SseTbgL6ccOZCoZuc5A4De2pGqBQGsF6CIGZuQ4HYSh9msZJPGc3Sij17jrCpCVRI
	VCY8DWkOezpDrIxy8VcBDf4vCtQAh1kAOcV/cEOdi7m/LmrCnktnkhADSVdMUwxcxbJy541NULJ
	DVcu3Kp76cih1ilZI8fXUnGwmFC6WN/rBFMPp8OiE7UavGf9sTleR7Xi7ci0GvXXU76xq2Pxk3x
	vFTtxf9Vn9EzOvScjDg1AQc5qKGnGxA6qMaCDTpFpDxNDbk
X-Received: by 2002:a05:690e:150b:b0:668:568e:8618 with SMTP id 956f58d0204a3-66d256571a7mr4352551d50.1.1787822199153;
        Thu, 27 Aug 2026 02:16:39 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24721e47sm2631290d50.13.2026.08.27.02.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 02:16:38 -0700 (PDT)
Date: Thu, 27 Aug 2026 02:16:25 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH alt 13/25] mm/fbatch: no lru_add_drain() to
 collect_longterm_unpinnable_folios()
In-Reply-To: <5d42fbfa-1cc3-4161-8ba0-7318267576a1@kernel.org>
Message-ID: <e10bc806-f995-e48d-a24e-8872f0a71689@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <fbf3fa74-c646-8855-17e4-e8b35dfd9c14@google.com> <333bb765-a36d-e07e-d3c4-5ea2f1cadfcb@google.com> <5d42fbfa-1cc3-4161-8ba0-7318267576a1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6A3C16000E
X-Stat-Signature: pfet4hox7xwkeuhpgouqa6r67qzf4rye
X-HE-Tag: 1787822200-677096
X-HE-Meta: U2FsdGVkX18n4ks9BpQXZHnsQWnNLsHDPIY1Nu+03YibrpCp2F2aUGTcmH95m4jXtaWj72AyZtVFAM8Fcj1Xit0RkPKOPRqnlPkq3WVOIwUEMD9WJVnFiv79hr5Smh4eN4D7RMO0OHn8LaRay+xfySTC3GA3ZXRg6VOuNSMyNkcMoxWLaV7MzSXW7OjrlFHad9OKO3Pwlw/M0Hrxv1ufP/D+uV842xGm86Br7Ey4Q8+fDVXTCvAtrAWl6HKLu5JEcjm6MPgjXpjdLkBWf73B5WKmE99Jhm/ILsFt9fXKFZ1/r53pAnuHbXBGc+SEi4vaqF29dAB9EB8SBVBi0chc5iVTh5dfPtFbKf3Em82OPCqoJyxMCPZ0tiPJ1bVf0sOB5Fvz4ICBbBi5pNfiLn0eGoZBgKe7ST63PgQR/u4Blu0DRwYsTZQ8rs0I6azZcmSjnCg50Vr4/UmDl/K7gg2X6qqC1VrPzP0gIkYKZKATLKpkQVVaT+SnsKJFcy2xSxlwmlLKsvdZHDyOnTpnE/yoOMHIXUShNrZYBjpHxF6oVWijMtHK5e5F6xGy/TS6l6VpZs4HL72NWfxZUxNTLHLtQQLS8hhFphQnKn4oM67M0rTGzPwVB0MG2Jx4dmhMigGPOwAS5z6lbzBUpec+GQ//0Iavq/hw9L/YTwZ8VTsp3t7YMMUDQxhnGDjUgaUX5M9AVohAEJANe2FJgorysgpHmDzijLDJkKmWgB9HmnFgXQlnLVPnFMR3prjh52kZ6kN5X3fdCeu0dwYD1qYdvzXazgrpHBc7aWlSb/ydqBWsBN42+xn2UgMylyxf97AW7ciLBqzHh15NxNdviLxAogjC4bjLBq+lMSV8s1T9i+Bf1z8hZ/3PdVESKIDrPaHcozL/4wQw+bIspUErxrYAD5jQoF0CTW9ziXzV+dpJkQr/5bTI7L6WVTrstbx42BlJURkprNMTLmR98YBoYF8W5zL
 n/fxS9i9
 ElHw5da0cu54oxC89y75Gpz5jJAHV9oyfefveNb6B+3tjgI2Z/WBCNNpLfF/9Aavhh8eKI5LL8KZbHOMNtSuBMG+4s6lJ4NvwZZRxVhtY/dCi/2L20bHw8ReW5PjVnLpRKSSne/N5ZIiWGDZbM9sHf3n/A1c2e92E8t2RvyNBHcRxhHgF/Vgfl+akDMKShxeTXIZ563JnkUuqDajImdCN79+96K4x7fW1FnFqd3wR3Lo89guOR+Wqd0NisWIpgZtYBav6+pOKirZelxlbWh+VW9GcpgxovrN/Mj0jcRF8ijVVx4hhVet6WsfBy6OjwqgAqFckNhNiFiBqjUwhnHQvuY8e9obV5ORD2pJVOxEu7dn9P/fuwdrWk+ropDCd03p/iGXxZ5yPFWSIvZnUWxOk7HqGXC7xM3XIJcO4smlhsPATh2Op+FibOMlf8jDiGO+wNeunekFs15pIK0U8Rn5GY/VXEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026, David Hildenbrand (Arm) wrote:
> On 8/24/26 16:55, Hugh Dickins wrote:
> > collect_longterm_unpinnable_folios() has no use for lru_add_drain() nor
> > lru_add_drain_all(), now that the per-cpu fbatch references are gone.
> > So remove the recently added lru_cache_drain_for_folio().
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > ---
> > Alternate version for use once David Hildenbrand's two commits
> > here have been pulled from mm.git into linux.git for 7.3-rc1.
> 
> For 7.4 we expect another user of the helper in KVM guest_memfd code (the
> primary reason why we introduce the helper), so depending on when this series is
> ready it will just remove that user as well, or we'll need some coordination
> between trees.

Yes, I could supply an alternate alternate version, providing an empty
stub for lru_cache_drain_for_folio(), so Ackerley's and my series can
proceed (or not) independently. Later. But at present your patch or
patches seem to be in both mm.git and Ackerley's series (17/46),
but not yet in Linus's tree.

Hugh

