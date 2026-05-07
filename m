Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 617CDCD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 12:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C266B008C; Thu,  7 May 2026 08:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CA16B0092; Thu,  7 May 2026 08:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC9D6B0093; Thu,  7 May 2026 08:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7C86B008C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:51:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C53B81C03DD
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:51:12 +0000 (UTC)
X-FDA: 84740609184.13.EB0793B
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id BC31BC0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:51:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sBm3hXvg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778158270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ds5Hpu/+KbdWRemu357hxe1/OrpLRLixtQ7C6d78k58=;
	b=mThucs8NIk2RHsBTE+WlyhGCvKpXbcGArWYPnT9KYHMI6K3nLH/jXOSleTyb71UPWBe2k+
	h7zm+sleXdRBVjMacx15X5eLe/d9F2NhQXyg6BPjFTP2WsAXrO/dC97pWXVYEcHE9hxlld
	qelx8O3b3yWWzYIf3kJdRI4/4DgglzA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778158270; a=rsa-sha256;
	cv=pass;
	b=KKRw4qBYCjg5rT/ufxLZxGvhCwGd9YgNVJe5i/6bHgJKhr6tMWI+f0DmAxprwdxuFpbrIy
	4E0xVvVlqYqDs7PazdsQsZQLP7XLkk4jg1tH3Vv1BFs8Qx+WR6rlTkUwU1llXA8eDvHCdD
	vR9+2vwazFAThl4aUeDj4yzGS49n/7Q=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sBm3hXvg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38e97e73234so7640631fa.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 05:51:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778158269; cv=none;
        d=google.com; s=arc-20240605;
        b=HL74/gqL1nLEll/P79mbb/A9PD76Wu1NZPE6UAdnOAXyrnSPkrIMwQocUNY/dpEaVU
         HQ5bGOqOQQ7OTjWlG8lbLeF4AoFtnXTJImuFoKOGmpxRZtd4bRbvHaKSYmXs3TlGZzEw
         fKKhx6NlJRZYRS74O4w5qe/gIjPHmZWn+n1nKWFQhdH86udG2oKogTI63NMDyrQ8IxO6
         eMqiAE0dPtiLe5VgqTHJdR1Sox3wsf9xUE39vgUwhnSmyTu/g03HcDMbDKCaLMCkGIT8
         QBGIdqX4PKkAP1HbQj+cDeli4qXeS/X6udEYlN15toDXiClj3zUVC0+7qzyACzHIiGLl
         2DMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ds5Hpu/+KbdWRemu357hxe1/OrpLRLixtQ7C6d78k58=;
        fh=5Z13KRCluIT95kZ0SVjCYVlA3ouTxKUaSEvBmXywtCs=;
        b=OFH7ArGdE6B8fo7txH0qh4vuW79bJUdZrIVfupArqSnIsHUcsIkMIxd/pBCj3Q9N27
         OPS1LM8t6+VLjeEkOTXQkRyLMmzVQgOXYf9QYVh0NrIMogUuI/jy7b4+NqOs0PU+Kn5V
         GY/Vpnk5rhxBxdNOrQBu69Q888CjSJ+qBCJ+h7lxvJ6q/qAZ3JsjHXqUE4/qsPdWh0o7
         RijON/FB5RXz+wscQXalTZH3GNtysHe9s/T5csN4VRF/SJh6Gsl2bxghhLf9eb9kaiVd
         XjiqvFpn0MSbkUyb4DUI/oNSLqBG4Muu35RTIJpS2zdz9ywmpaSjNm9FpoUlFdG9i9Kf
         hU/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778158269; x=1778763069; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ds5Hpu/+KbdWRemu357hxe1/OrpLRLixtQ7C6d78k58=;
        b=sBm3hXvgRTlZ+KaEKbu1IjySHmSqJoR4D/jpwm6e8BaTtixGZ6+2OnlKqleMxHh21+
         mrf0h14neK4WUMjyfY6ZNQASLELpPQRZFnuZCif2vnXbQSwY4br2NAsWlFG9ae538N6w
         pzbPupjP2HiPYWSTq9ECG4xvAGuEOt0/9xpDz9q2/5X170nrybmR5GQZYNrInRSkzDaW
         5onfhWM6VtQ62q5PFuoZk/EzNunIJf2MLSx1kUVLAHViKjxB/SGTOenbQDRhTXrlx3Nn
         v7/m0EvdI6WJ4yfCpjJV3HGhu1kSO3b03zpCjBcCn+euRb8Wi71EJg29np9LS6E3fO9I
         18/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778158269; x=1778763069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ds5Hpu/+KbdWRemu357hxe1/OrpLRLixtQ7C6d78k58=;
        b=G9b49VkDAizTwyt1bZT7YknedDvQvTFuXLXFhi0ChY1rp+i1kwFSzK2Eg+/ln85WGD
         UC6xpMm9FCChdx8s4N8EMgVAKSCz0An5TJm8dpngpu/VlJcx5eV+k7bewOfwS2ATLKRi
         iTqlDyyzl7EWZ3iwkMVGMrGcmJ/tMu/Z3ovKSzNpWBP2hsRsSrfb1kF0MAiT+WERddNo
         d4xmsYC2gE8Qgy8RV/GFDwaXGoGdFMSlag3PSB/9Xdtb4v4Aqc95IITkQoIl5FUTDu9A
         4GTti/i4PFX6hHurZlZaoS8xjmxON8JWNDXXnq8dPJipDpEgzkqH8ZUkrjAmWQkWuPCw
         7MQA==
X-Forwarded-Encrypted: i=1; AFNElJ/P3MvlAnpBTlwimGwF40xVMdRsouQ6xAV/kYFeCwwhOkBduJsa7TN4MLgz3f8DxQuckRAJ6rGdCA==@kvack.org
X-Gm-Message-State: AOJu0YyBciE27n0/Hw/tH2iCh5MRUh1OG5r8PgMJqGNfopCaKbKWrCTz
	PDvSTwuABOQPYNdNwOoi/9ou6+dpH5nEq6CXuQXrP0UpHx0O8zskRTP+RUuQFAUJuD37xxveSRA
	9pbOk/yqKvR4RJ4Rpr1iy0l1HInHN1Uk=
X-Gm-Gg: AeBDiesfpFRbUz9+MPMm9MP8KaE1jqnoG3bfdHclJROA7eAN673Uk8lK9Jj1t4rQy5e
	cZdyEyv06RXDsHy/9UEOmGarx6ok0ebfjInXFF07ghC0BVJCagQQ4yi7zr0EDS5JyZhyMOdKshw
	tEFmMXND5/4GlmBe+Fvvp4XX+uAaQvT5bFPXC/PPGWXR58baeS/twVde6WxCxelqbeeSobYDTYB
	OIf8RGd9ezN8bOKCGDKbRpaM8w/ZXqGNLgK4T1WiEmjPrGU3qHc1Th4w1nhqLiYm5mJP3Xp9jQJ
	ygDqJUytfJJmVEs=
X-Received: by 2002:a05:651c:3247:20b0:393:9ee6:1b7b with SMTP id
 38308e7fff4ca-393c41e25d8mr22404801fa.22.1778158268499; Thu, 07 May 2026
 05:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-1-vernon2gm@gmail.com> <CALOAHbBx6GuZjj9_EdrAPCsiLJekAiqOVsWQ0muNJh18Nxaqtg@mail.gmail.com>
In-Reply-To: <CALOAHbBx6GuZjj9_EdrAPCsiLJekAiqOVsWQ0muNJh18Nxaqtg@mail.gmail.com>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Thu, 7 May 2026 20:50:56 +0800
X-Gm-Features: AVHnY4Jj1qd88WzmY0wwoWnVGCaZldc6eM9kX1Z-bW7EzXfkIO3E-JQPWwtzWk4
Message-ID: <CACZaFFPXo_f_2M7y4NfQ=sWddS4Kwo5guFTqZcLmm4Z8COWocQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] mm: introduce mthp_ext via cgroup-bpf to make mTHP
 more transparent
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	ast@kernel.org, daniel@iogearbox.net, surenb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	baohua@kernel.org, lance.yang@linux.dev, dev.jain@arm.com, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BC31BC0005
X-Rspamd-Server: rspam04
X-Stat-Signature: r4kzp3fw4b9u1p7z934hkb8ufnfwm458
X-HE-Tag: 1778158270-401948
X-HE-Meta: U2FsdGVkX19QETtc3nFb2s3XGZfe7b0JiWvf8sRaWEmR8noyf71NdmR38gefk6OWdQJbMccqN+llrMfp+6e2WXRvxQ0NnsURMB7s4YXTCZ5sCsZkTDw2eEbyCKz14/wJ9ZXFw+4s8vy2gkzW9pvzTTZMUg3Rb0v/oDRHtXgBu67tVbweg8xhIqPxtPU7Ev3t0l09/snEcnGBsMKvvV+7hhFodwmFzxdANOZKbKoIt8QJHLwpWeVSFYvIK5FjNfaAROGE0cn/PqmYQR/m2chPB6Z8HzbXZtfj+Y/bkq1P2ZDWPj1KDGVNgMu2MUHZW1qzYWb+ho5pxIBe1hPxd0LUWE/d5ZTlb9z1ZvoUWaobwyXRq2MO55qkixO04Znvzno6FfBwljW2gI/9KDsf75rU0t7GnjzCSsivJUcBVpaX4y/qEDyxk22Bg6Qlx1SYZMN8Pwkvjpa3Mtzi++zNzbgA1CyIoJoWFgSDQquOnpxWaZW2LL1x4yxOy6IBH++UzmKj901CYYscJs0NCYiW7LrBgGmLAnTXz+q1mGKYFlPhm6GFW4+e6dDPtrSCOzAinqMyigRAdbqy4FQozC7locNPbKqB7eg65EWfruzE6cJmP1doCDRJX8XomXP8LiDetNRy/fWmryMeXr246NqpPXFti0uJvs88pfiYYcgZZSSZgi6V7rMuO6hsYuwiRswkh/HW4EkaMB8rJO7yxJ8i7VwPSFekSffVZYp3BIRDesbRs2sN28d+VJJKI4EBoGIRREUq5fdJfF5mneKigyM4aM6Le6aceqq13s6ol6LPZr8jQdNnb16jQCJAc97YwXA8HCF8Vz2E4AdFrXrvb09Z8xcDgnw7HwWinfmYL3dkjD3+yjLg/BfNjedvMCaFzIwcYAPqF9Ioy70T6v8qQx6retHZ5jrU1gFCpO0cTNNBlVWqAKn0r5F0q07MMY5QKj8yOHyrvauck2rAHB3PHmC3Ht9
 MkdyhD0u
 vP+1Whtjh4WDpsMxJSAPMPRHwzTfKLkD6KkwezLNMQGuVwPGt1DEpnzAKYLNwCgkCe5jZcNTVW1sbUTeiMqizaN4/og5Ki4moHo2ZjLY8Sh/tWVQTZuFnqdQt9zsJ5yMR9b2BTjnoH6ug53qgkPK82T4DZOCQOLA36qyL+yTRR4O8SFJxuCShG/a9t9jW9Pelg5pyoIWkOJvXPCd/DtWQLMawU59qFlHmOqU04Hf2p8BKIbjUMuLLac95heXakiw9FdgibUDfBaT2jaiULNxcMJC0iGbWZzbJ93Xi1Ibf+k8+GT9rV25kvVYsJU+mGWAVtTRBP0NIQLpcMJ6WF337IhLmdoHzpntVHxzyEWK8KuQNmFO14L1AfGgNwRBOe1L7ZdpJ7lGySNt239lT8OSS/bUZf81MWAKSn4DpADV3UkvecJrOl2pmAwLZDpMbfIywnrzq86te90ABWJsCTwew3HZsNWAr5qX/PKt16gf+KIsbsQt1967zuglnjXJXOTjMB0o3xHwnVuUFmgb1GnS4xArlT1MXOhp4sQbS5KcalWuv/2QuEBq/0aLWd4omdoeWpGV/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 7, 2026 at 11:35=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Mon, May 4, 2026 at 12:52=E2=80=AFAM Vernon Yang <vernon2gm@gmail.com>=
 wrote:
> >
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > Hi all,
> >
> > Background
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > As is well known, a system can simultaneously run multiple different
> > scenarios. However, THP is not beneficial in every scenario =E2=80=94 i=
t is only
> > most suitable for memory-intensive applications that are not sensitive
> > to tail latency. For example, Redis, which is sensitive to tail latency=
,
> > is not suitable for THP. But in practice, due to Redis issues, the
> > entire THP functionality is often turned off, preventing other scenario=
s
> > from benefiting from it.
> >
> > There are also some embedded scenarios (e.g. Android) that directly use
> > 2MB THP, where the granularity is too large. Therefore, we introduced
> > mTHP in v6.8, which supports multiple-size THP. In practice, however, w=
e
> > still globally fix a single mTHP size and are unable to automatically
> > select different mTHP sizes based on different scenarios.
> >
> > After testing, it was found that
> >
> > - When the system has a lot of free memory, it is normal for Redis to
> >   use mTHP. performance degradation in Redis only occurs when the syste=
m
> >   is under high memory pressure.
> > - Additionally, when a large number of small-memory processes use mTHP,
> >   memory waste is prone to occur, and performance degradation may also
> >   happen during fast memory allocation/release.
> >
> > Previously, "Cgroup-based THP control"[1] was proposed, but it had the
> > following issues.
> >
> > - It breaks the cgroup hierarchy property.
> > - Add new THP knobs, making sysadmin's job more complex
> >
> > Previously, "mm, bpf: BPF-MM, BPF-THP"[2] was proposed, but it had the
> > following issues.
> >
> > - It didn't address the issue on the per-process mode.
> > - For global mode, the prctl(PR_SET_THP_DISABLE) has already achieved
> >   the same objective, there is no need to add two mechanisms for the
> >   same purpose.
> > - Attaching st_ops to mm_struct, the same issues that cgroup-bpf once
>
> Hello,
>
> The primary hurdles preventing BPF-THP from being upstreamed are:
>
> - Uncertainty regarding the stable API
>
>   It remains unclear whether the following API is sufficient for
>   BPF-THP requirements:

Thank you for pointing this out. I will add it to this issue list in
the next version.

At the same time, I also encourage everyone to actively provide
relevant real workload scenarios. I will conduct related analyses and
develop the mthp_ext to address them, so we can determine which ABI
can satisfy the BPF-THP requirements.

>   unsigned long
>   bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
>                                             unsigned long orders)
>   {
>       return orders;
>   }
>
> - Ongoing integration of cgroups and struct-ops
>
>   Work is still in progress to integrate cgroup support with
> struct_ops (see also
> https://lore.kernel.org/linux-mm/87cy439x8a.fsf@linux.dev/).
> We should wait for this infrastructure to land before introducing
> new cgroup-based struct_ops.

This work can be carried out in parallel with integrating cgroup
support with struct_ops. I will focus on addressing real workload
scenarios to further clear/stabilize the BPF-THP ABI.

> >   faced are likely to arise again, e.g. lifetime of cgroup vs bpf, dyin=
g
> >   cgroups, wq deadlock, etc. It is recommended to use cgroup-bpf for
> >   implementation.
> > - The test cases are too simplistic, lacking eBPF cases similar to real
> >   workloads such as sched_ext.
> >
> > If I miss some thing, please let me know. Thanks!
>
> BTW, it would be better to include the original authors in the CC
> list, especially since their work is cited in your commit message. ;)

OK, I will CC the relevant authors in the next version.

--
Cheers,
Vernon

