Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B84606A321
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 12:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wSDy2/53
Received: by kanga.kvack.org (Postfix)
	id 5ADD36B05B0; Sat, 28 Nov 2026 07:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EF66B05B1; Sat, 28 Nov 2026 07:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D6F6B05B2; Sat, 28 Nov 2026 07:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 141A46B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:47:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D860140644
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 12:47:31 +0000 (UTC)
X-FDA: 85484503902.23.A1D7AED
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 648F518000E
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 12:47:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="wSDy2/53";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795870049;
	b=VhvR1VsgIvsVI0tykwNxXGgjh3SLkJHlpYqRx9WIoT5CzxcfrJfqwP8KwX+lUWMCPg+mr2
	IP/Ho3EdGNCGxPA6gn2e9VrVwf5VFBlnEAa2DbvBIM9KGsRJulSAPFSkRML2AptNabuovz
	lRr6Zw/RAk54QCswwhODl1BnhGz+VUk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795870049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Neleil5nC8s9bt0MpU40WqwbR7w+O9HixUWBXPDe1yo=;
	b=1Ak3ySKOnEsb462yyDQtrrTAQc5+cEqOvCEuAIARQJSUyKMA75+pUMEpMXSqxaIDoc70dA
	OsvKfrf1H70gj+9oVhwmdHMCwGNoW82XZa+anJF+76kPLaUNqJEoqDXXJz3w+Ky02lbRMD
	Ns/IwWhsNPnYgNvUaxT/6SwrV+P1A9M=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="wSDy2/53";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb61185057so57065565e9.1
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:47:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795870048; cv=none;
        d=google.com; s=arc-20260327;
        b=M+0hpefAKhPFiF3fwtHx9MzcRksUQ4aEzvfCzqSUCVOtnyK1ErsNZILy7sx+76SNI3
         6cFl+blhpn6L5+HpWYVaQCRRxNnAFqMmFByY84zzuY6ccSJuo1KxLpiASfROH9Avud+i
         1gxpmkk6nnFu8zK9eu5mEG3iGNH3XiouQ0BFmGpxQUQzKfY8TH5JUr5qKLpRLc6YrAp8
         jxO5Wrx7Qab0CuHkr6/2Yi0JUtUbYuTae3Ue+6VXcbIH2gZ3Jlvyng+aiooV8qehJTIv
         nuJL2L6nt4xgkEv8DmbVhHV0yHIP5fXrlKCj4F/slPC23vdl7dEdwj4RTjPEMsBnQcMA
         YICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Neleil5nC8s9bt0MpU40WqwbR7w+O9HixUWBXPDe1yo=;
        fh=JwfP31j/cs400d38dIY1cuCOekMGY/v3WeGK4UAv6u8=;
        b=luLfG6FfymktHU88U4Rc1b4vsdNtNtDs/BEAQQFKVYicRWWKBc5RxJ5I/qZVkVA6Zg
         UxNf9I5Ync04Kb6pTvkMCQEDqfqIePTapF3uajTIotGdGB4hKM8pdf7y9/MQy3/DilAq
         qxSQ9bZyWuay+wzlD9DXXZWjRUQzeEXojO66qsEnSMhx2iKrKwxQvC8LIvVfmOwHY7QG
         lKLGcAsP+L7BNJPMIQun3qbDUiOqKxNdZyNAzrgS4jv0TZqRYdkzOGh12fRoDvQpbA1x
         4pAuX9O0YwB7trJAYZE9sat5gHZMPS8HHKqstSg6Ul+4lIUAPHrZjSrEFxG8KsPTBLZL
         myug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795870048; x=1796474848; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Neleil5nC8s9bt0MpU40WqwbR7w+O9HixUWBXPDe1yo=;
        b=wSDy2/534rPFvrsyo6Vq3gmn8iuE8IHU5CmxDZB+fnNaHZsS4w0YXH1327TUJ31JGt
         mrwS90chHFq/Rw2R9a9MTX4yPONsVq3Pq9+dO5axt5oGl+p2H2kdyFbrp95K24n+vaK1
         BCo3cJrdXxz7wFIXrPR5XCxrymHInVwbAS1MecIuHs0mf+K0pdsLB9DEeBwBSRieidbP
         7HKYREIg0MHvjPGx0hDaqMQq/dDtra3/eUIP6bdND3tU2udujc77jc5iAbiTwmBYvEqI
         kpPXFjbyWOLJVY2afbCz/kBMCIKjOqooTzMol5NS48A0QMw53oGCLWWQX75oHC8Erjii
         UnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795870048; x=1796474848;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Neleil5nC8s9bt0MpU40WqwbR7w+O9HixUWBXPDe1yo=;
        b=BOgKE5WdbmKJPiMoD60tN+eqpYJL7voTs0og/K6ErhWuIZIsginsKy+92GTOsZaQQV
         HVhzXVPtJMbOw+lznPeww7BQ1pjXaOTSA2hDHLCcnKGK9prvk28crwQOe2ZZ4lLexq1q
         G0jaxcA2hlJies80dqm1zkW4+662uF9QkE82TszNc/n3mL8ndN7hQg77tsd76dGdoyrn
         VvR+/3mbuOOFsw6ZWSkdso7+fkAqYhWeKs7GtaUND7vlB5EwEK7Odzb27lCWRqQX3iVw
         yp527zxm/uXkYV1pThhOKfHNaoXGGfxSPHbtcHKwhSUNAyDkP31RtLCbtW4iG6y6/PRo
         8ELw==
X-Forwarded-Encrypted: i=1; AL+hErGSY9OYiDYn8sZ0MUncW8xg0QbfbO3xWa+tbTJutKGxREh9GPMNmG4CIIpVjaBTcH6kLYqP3Oms+Q==@kvack.org
X-Gm-Message-State: APuU4Z9b0GEmFLvmwRJQx/4mUfJBpCOfXcYWf5gGGYIdB/zZ5/3HKHu4
	PSAAcnlAo6REmvXIbX4vo/nwQ3y8TEpuUMonj5DsBeknb4YoiNQbsxzWhqAG2NCPLF2i3Z9ZSWR
	CcLS3p65Q8orqn/hoAK32rT4rGj1tXUY=
X-Gm-Gg: AZFdTZfIOatO/br7hin5PXvcVLP9HXeYvZFHLz82VIphyEoK489RN+64qkXubEOX7vS
	nSQq8/zU2u04fbpAUGnLezKwDVKGWV4aueq5fOpkIfMndHLTNpg01Opo9PdjPBbV9vADtKjxqzz
	j8XJszbcb4r/8iAWx6FZ4sK/xlZrVgy20t+4e2w6VYzWTyIjrVx2v/+FLt9Bkg503FBZ9KR1+kX
	AxpTCSok+ihS3YljgyT7xi9T+35gYlqFv4Gjo2IPw713w7qb6y1NInD5qg1Km/Ou39NlhS4KDQq
	l5NMK6ulxbg7p2gqnVaHKX4uXU5aO0Gvtv/CX1Z5Bb9aaysxgKhj/uV37jEpMQKYhZRe+6ZIa+1
	r8C6f+f18z/hnsGXtxVkBBwzVQJYNPZTK8dH9aq7VWzvUFBslKFKcPCw1O2q017SptMkJVZ87Xg
	9se6VpOFUl/1NW+hFZ36A8WtwJxfvu3s0QgDSjUkG7
X-Received: by 2002:a05:600c:45d4:b0:4bb:6994:abf0 with SMTP id
 5b1f17b1804b1-4bb88817d91mr585296145e9.23.1795870047116; Sat, 28 Nov 2026
 04:47:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com> <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
 <awa30hwg6x82REoo@KASONG-MC4> <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
 <CAMgjq7Ayu9H85wurRAUdmXEPWYi9BdLJW13BhK+LMYoBX_7fuw@mail.gmail.com>
 <CAMgjq7DwCNbke2G25Bxfj3bi5aRp3_qkGeYmCTGVGv+Y5XzKTw@mail.gmail.com>
 <60e890bf-d5c4-44db-9f90-ae7970b5de32@linux.dev> <CAMgjq7B9r17gQrOfxffRBiTSepitThjLAUbnraFFjze35t2P6w@mail.gmail.com>
In-Reply-To: <CAMgjq7B9r17gQrOfxffRBiTSepitThjLAUbnraFFjze35t2P6w@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Sat, 28 Nov 2026 20:47:14 +0800
X-Gm-Features: Aa3M54oCldtT2Qc6Xyokk6e6N_BkN7eNxmqD5B8ZoTIPwfqT_iCVOdBBMSKp3p8
Message-ID: <CAN_Opa-fUhr5cFDP8vr_47Zb3WOUnSX03LQyNo5c1uQtpyfBHw@mail.gmail.com>
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
	Tianyi Chen <hi@tychen.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 648F518000E
X-Rspam-User:
X-Stat-Signature: h5k694i8x5mgrfjp3k4ft1f34srmbr1o
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795870049-231163
X-HE-Meta: U2FsdGVkX19EydcGDIvCwqsTHdl0WbI4HN7TkXlvLKuxYeGDgABOF88nD+CRQYUy9TJQKdogThYVJQ3qs4fPLpSUdvRHBiysy/Op/nkUfp3Cq0L0QW9vdE0zwl1fS0/9VYJilWZwDo2hhbBpT3g/rTOOA3TzpqhZSc/LUJfw40U2LIIIZO6Os01IKWgcLw3oZHetW3DW65fBMI1MLFjpWuEkSKasAXSZh2DOV0g1EhJwGV6ECYdl2DeHMzUYcZ6ibUGY3Uo7kFu3NwX/qyH5O8Or0Nj3VZo4BBspIZkwQgGMwmpbGp0Q24VRbewkc/NpRjKvW4e1TDsGX42us7EunC70gG/yYMmcogU8D1xPBmi1XSFlcQOI6NVMwedZN4lVM8GoHWm3ZVbDWpL1HzjPjt/1+f/cjIBjYFVdfJUkmh9Cw1A7nnSZZVgl1pQk/cYB0489n2eOBiUjvrc1W57yUr9kenKzY+zz1DqmZc1tCrGDO+kUA2hUMnFaeBtJelJzDt3vmX4YxUABaNIWJp4EzMgk5gPprk2TYd8tHPul86A+aHvCm73j8CvwAUdOqHLeGMZAVLc+NH12z6ZWwUfgbVYYMZvb6wF4HJBQ8BhSDh1eItsiQK0z+w+GMW2eSWEmmGHUE0mmXATJ9uMOk5r9xb5q+oUUKR+z5wwquI3wibwQ93hesRYCCymHdR4NZluseZxkGXgue/cvWBzvhyj7vOPNgSXGLmofX4ZwCjhRM2tZkOZrgtMOajluzbyh6ruB+3i4EIQg46o7/157Zf9h+/vxWy5ZiE7FAK4RxDdHq8S/7b6gpc3m1zE1BQg1JQSW2FXtGROyX7Z+9YgeyORglIiEq/azf8R94Tkfosb21PKVeGp+K0z3L7yXCFiocyB8gtSD3xteLsUptzVGKeIIdAo6ggW0bYvPHjFeyoyzEBd8w4AFRpZMWoXTDLRBm9Lx7mMTZCV/aqzG3taXw6V
 Ra9kq73L
 DoavNR4etG/hfRobs//hLJDsr3sISqdo9xNBblqFL2Nsn//CIkXbSwOzo3MIvlA1nt8RSLp3gp51DdIokS/qd8Xd2INcG4ydGnvFFVBDrND0OZjQduv9+gJHEImfKeiCD37ej7jVIC884WCfzKcRksST6+O7NgnzfKp6eW2g8E4Yj/+0zTw+7XOoW0i/l0K2d/uHl2wPzRefKApMEaeUblX1oBc3RwTpJbX/azCh55FvBGnSNj6cPSIaF/CHy7arSsR0eOLiLrgsY7HDPBPblalHy1rd9ePC/1Cv/C25o2xfvpyaU7TA3nexIAb6WQ0cKB7Xlm0oqVOPWS5dzR14qzHPnPirQMA7BR8IVadNOhLVOqH7gJvlv6JzJy1KNrRPAu/MYS0MfwccTF8A/eytTySd8twtG9XFuP8ddEp0NnsCdn4NAP14z14fjeqsioH2/HdjN2q1fitNbUAbDKdq7/KCoc54DGMNTa0HC+uacWcBMlL+L7tWwBu7quojwM5aVyHx9q6AApRPpZuQwkikWDkUxVdr1RzbU1NGYiTwlrRENvcAQLk3PhbB1lDrbfVDW/XXpn79ch2BOwtNf4VuNWWpAHRoT83+7+m6qDFaz3uK+PLxnfp1vc3mJ9VFuzsR8wYTYgdQB9gZhroG+yELwSqASHXZNUtyH7EEgI4NY9INi/sKyM6nLWE+nNJXAGpYp6ZaPbF49jub8ufZAI+FVCfuy2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 3:41=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Nov 27, 2026 at 11:33=E2=80=AFAM Ridong Chen <ridong.chen@linux.d=
ev> wrote:
> > Thinking about it more, the header move is not urgent, while this
> > series has been iterated for a long time and fixes real problems, e.g.
> > the swappiness 200 regression you mentioned. Making it depend on a
> > code shuffle would only delay it.
>
> I also prefer to land the FG series first. It's not just a feature &
> optimization, it covers several "bug"-level issues for MGLRU and fixes
> regressions, which are hard to solve without a rework like this.
>

I'd also like to see FG go in first, with the header split as a
follow-up.

Thanks,
Kunwu

> > So if David doesn't object, I would suggest landing MGLRU-FG first,
> > and doing the mm_inline.h split as a follow-up on top of it. That also
> > avoids rebasing this large series onto a moving header. I am happy to
> > work on the follow-up then, keeping the folio refs helpers in a public
> > header for the fs users as you said.
>
> Let's see how others think about this :)
>
> > David, would that work for you?
> >
> > --
> > Best regards
> > Ridong
> >

