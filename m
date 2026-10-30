Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F06606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MduejGOR
Received: by kanga.kvack.org (Postfix)
	id CB2826B00EF; Fri, 30 Oct 2026 06:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63326B05B2; Fri, 30 Oct 2026 06:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78FA6B05B4; Fri, 30 Oct 2026 06:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 996CE6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:49:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A51FDA82E4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:49:41 +0000 (UTC)
X-FDA: 85378971762.07.369BAB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BB7E24000E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:49:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MduejGOR;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793357379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ge8hADgfac7MKFfaAfAW05gt3hYkAz9wTRvWiuoBv98=;
	b=cOTX4bMSN5xkMbvXyUNJqAdSBIXQCkSGlsue8tEuj7b1NEXX9Lhal9vTw+S6hWSXniSkLA
	VyjC8BRhEWvLcOQn+7Cb37wSIxeZie9ySiW1ewhu/7aIUeg82665t9fME2srhWcjLme8xk
	tghWY5/s0fKFAwGFzVyE5MyJWfgNfpU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MduejGOR;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793357379;
	b=BmA/6ghHuojUm2xBZgtAvyJbukJDwbhwzkX3if/ATKGagvRoW6BOLsbIVbl09HPs/3Eu9E
	GNcFL4mUb/oVD8Mf0B3me0AogHdw/gkyH6VLMyDNiS56Z5mXS7qhL2RgXj15Q938hGMlGy
	9YVVnl/TdNh/Agd3aka1Jq/Y4IavYgA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A61243939
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029491F00A1B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793357378;
	bh=Ge8hADgfac7MKFfaAfAW05gt3hYkAz9wTRvWiuoBv98=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MduejGOR49bV/g+WDvkkka5dwZR6dPDtapJ4D0FcpYj0cjsNyTmxIkBQXoxqYj3cL
	 c2bF4g7TyB/95HyAxCNAZK8coQ6VMrTERDOPIFa1y6G+gI/IWsQWN6Pc5eMAanxVN6
	 0fn6+Rpd/JHSln8pg4D54Q2x7ar3vbugqQULQLlJ/95VEnqF9T4s187xKSJbcD6ogA
	 EuhA5qaDz8UJfXtL79EywR7xdfkRHTbB2Bsc3Q10BVe2LPd/kEYh1MyJOGhD5knafj
	 vQ1sQGVmBn3w1o0af/EswCFiE80uqyuN6clERzHxJQnt992zCmHYDG8C4Z9iC4i4Uz
	 bdo2mXumBu4Fg==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93e63ee7b4cso53579985a.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:49:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzxN4GyMYa2rMP57iBAyPLMCiZVLW5A/FhZGCAJQL5RO5iycFXIPTe6/nm3x+ifrTw/5awal3lLkw==@kvack.org
X-Gm-Message-State: AFq9FYKkKSPxAVnAYq0vZeWO76d5kTUANLe/y+B1/kxP4LqBh1C3FSgK
	iTR3NQSTWsWyV4ZAtGwarRP5gfNvccHA+eo4pRMnMcAvs1ZgVSn2YZTfuEf0M/NzFPYdFxEUPVA
	b3f+sI7burGwtj2zt99VAQHqmWI+awZI=
X-Received: by 2002:a05:620a:370e:b0:93f:6c67:152d with SMTP id
 af79cd13be357-9442175069cmr320613985a.38.1793357377323; Fri, 30 Oct 2026
 03:49:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com>
 <0cbd219d-f69d-4f72-aec5-43e1f2d978de@linux.alibaba.com> <20261022102726.56682-1-baohua@kernel.org>
 <fc302ca3-6bf6-4bde-b3e8-8d2e93a4e4ac@linux.alibaba.com> <CAGsJ_4z9GZkpV+mpoGogma4oSX4cHy+2UDzyUQSjjOLOfekEPg@mail.gmail.com>
 <4e647816-0b8b-4a75-8777-8580a574d752@linux.alibaba.com> <CAGsJ_4xVR53NcKuN3bA6v+O=37PeQ2Vnj-8WHo6ScYH96N4seA@mail.gmail.com>
 <179307231985.76444.4463824301717648100.noio-rfc-v2-coordination@bytedance.com>
In-Reply-To: <179307231985.76444.4463824301717648100.noio-rfc-v2-coordination@bytedance.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 30 Oct 2026 18:49:25 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zvbOW3kGDZF0iXxZyWbv-LJo56W+uMM_Btk-sHRf5aMA@mail.gmail.com>
X-Gm-Features: AclHuK8XCpEGNqAtN3doj9652by5qHmAXJ7EjWFLqe_stHXIVl1CGsrIrXfddGY
Message-ID: <CAGsJ_4zvbOW3kGDZF0iXxZyWbv-LJo56W+uMM_Btk-sHRf5aMA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache in MGLRU
To: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Bo Zhang <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB7E24000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: crrgtr8hfkmorjzobyjq961et9eik6gw
X-HE-Tag: 1793357379-734832
X-HE-Meta: U2FsdGVkX18HWwMWR8nkaBwkTIUhO3nkM5N4GabBq8vRbXVHPe1+zkmlWNiCPlinAdhSUMq5w9z0fPiOg5RAAXc5VJ/hIYfh1BXx8Jb0JT7cjtvklI2E6sEKVO/FT8qK45R+JtzuV5dKyC2blRI5Da9h2EnNHuTKJT3Be8JrWHMgJPdCEbJv4YI7kwtp5XMjDtixcQ39llgy2zIf7VLNAXJ/DzvAkUoILcxcpDNqOAtG3BgFlardBo/5jlZjzK11JnP8NANRByXrgyh4e5kt0GkfNWx6UmPm4l9fCaWMRvM3jpPMVE7+zlFOIGvpwOyBU2Ct0Npao2NUA3cLJADqKsNiV7fcu3WmL3vVMER9dBhpz5Y8kU2QuaMSsz1IFPg/2CLJEm5BrNq8zWfHXIktXBG4efr5NiOHj+l9YZQ1ClIL9rJJx38QZz6Va84g8/WzZ1NMNR8O+VmfZstz8gEYVTMIR5P3HY16ZFdqPEtBpKWtmPYw1StYw6wS+YgnuqL9RWuPIcEHc1JCE0vRh+RkpU9ZLzVpIucwv1QVHHoU78YyP5hRSiouGUQPSdDP9gwUKu82UB2gtNCstLgW33TDXSNTB6XI3UFdDLRUd2Q8xLdcmY6sirsq/JxG3gMue7ip8k0kGhEQyW4TQIf2Tt9Y88O6d3GTbYu7uxvhgGzPBvFQSDF+15AU1OXEnMYdRpivPQDhS+YJWnsAILJz+ofOF3qol84tzLKjXTB2VuRaiiPRqXIK75r0dEF6qcam0YqTZjd+pyi3jQmFTZgH3VQfuKArcV3b8AX6NEtppLw8ii8L/pqgqtAS9zKJHKRn9IhqOOs7A0YRJPLtdU5DuJ2woMsHLgGfzznnrH8nSHdCtTZp+OY1qHfLHWFyQvudp4bEmaaFzQJlzvNCZBBluWzfvadVop7ti7q7V1Czpq9N4VRM7EAmytEUnpje4Od97RJMZ7uPu/1m6fqbVRefc3d
 LgGAtECJ
 E8Bo776Pul/MZwEvtaYFOlNfcW2Uoufr1nOV9VxZ8inzQupJJ9Hxi9Edgg176QcMa0JQu7PJAxD9AS5ooYJ2VN0pe30JleCb5kHDkrpSnPytvGDc2DchWf90Dw8O3D+zdArPCngQblXgjrTZLsre6YpILFofMPMJkAGdfJZVk14AVAj/beXzUhVGOhwhFVIQP9S283U/Giqw9LByOGpbVM/7TnurbxAtxa0j2W2MXWQlDk11L3HQ7NcJKApJ2UNmkg+MWd4z9GpG72yhgIEWzScV9mBHuFHz0xdqxw7qf2cLee4piQSbAqDSzDKpkoYX0ShESLQw/Hu4PHEiZKHOq+WHw5EDy8oZWvQWv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 1:15=E2=80=AFPM Xiang Liu <liuxiang.277@bytedance.c=
om> wrote:
>
> Hi Barry, Baolin,
>
> Thanks for the review and discussion.
>
> I've seen the RFC v5 "mm: mglru: fix swappiness behavior" series, where
> Bo's patch 14/14 addresses the same GFP_NOIO issue on top of the new
> scan-budget model.
>
> Baolin wrote on Oct 21:
> > IMO, 'swappiness' and 'scan_swappiness' are really confusing.
>
> For a standalone v3, I plan to rename scan_swappiness to
> evict_swappiness to make its role clearer, keeping the rest of the v2
> implementation unchanged. The split in v2 preserves the original policy
> for anon aging, including the page-table walk.
>
> Barry wrote on Oct 22:
> > IMHO, this is confusing but this is a possible way to fix it before we
> > land something [...]
>
> Before preparing a v3, would a standalone fix against the current MGLRU
> code still be useful as an interim fix before the scan-budget series
> lands?

Hi Xiang,

It's a difficult question to answer. In the long term, we
hope Bo's patch 14/14 will be the final solution, but we're
not sure when it can land.

Your approach is a bit ugly, but it looks like a quick fix. we use
0 for reclamation to make sure we only reclaim file, but we use
the original swappiess for aging -  where all files and anons can be
normally aged.

 I think the real problem is that reclaimable type and swappiness
are too tightly coupled in MGLRU. In fact, they should be
orthogonal, except for swappiness=3D0 and swappiness=3D201.

Actually, the current get_swappiness() implementation has some
bugs. For example, it returns 0 when swap is full or close
to the cgroup's swap limit. But this is only a temporary
state: swap usage can drop below the limit again after
unmapping or killing processes.

However, once get_swappiness() returns 0, anon pages may
suffer from cold/hot inversion.

That's why I think we should avoid hacking get_swappiness()
any further.


>
> Or would you prefer to handle this issue through the new series? In that
> case, I can use my GFP_NOIO workload to help test Bo's patch 14/14.
>

If possible, do you think you could extract the code from
patch 14/14, even without the scan-budget-based model?
This might give us a chance to land it earlier as a
standalone change?

Best,
Barry

