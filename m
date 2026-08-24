Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E1EC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 23:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5136B0092; Mon, 24 Aug 2026 19:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D6C6B0095; Mon, 24 Aug 2026 19:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2B86B0096; Mon, 24 Aug 2026 19:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D159F6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:43:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 515121C1100
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 23:43:05 +0000 (UTC)
X-FDA: 85137791130.30.FA89797
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5CEC880005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 23:43:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J8zz2uq0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787614983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHnXZHT8WiiUeAdh+tKiJaengtnfesqTEZdJsUGA+8I=;
	b=iXI/q9AoX/vlSrlvpgJd8k0CDMpNHtMdnb5KU+Z8uC47PnaJkvQ0ccJQxA6nJgM9W56lfl
	o4cGRLVeul4OtLk3tLWNeQ8NeYUrlPkJYyn7+fx62w4A+UyDZ42bK5NiruNyZF41pLTjpW
	B+UxKOlAQJ+Zy97CsOE0Jsa+zikpWgM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J8zz2uq0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787614983;
	b=GyKRFrNUWBazY/jJhAug25hFU2buRzNBy5mHjm8PhXa4Yu0elNDLoOSr01zteXACo2CAQo
	yLOWJpUAh+d1X69UG/IqVIC9ysH1vAScELc0Hrk+pdNSveQNd3dPZSP4UHAHHIugVo1ZJd
	98EdqoR8lwyuc28B+rD5QyifV1jXio4=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-495590dde14so35467145e9.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787614982; cv=none;
        d=google.com; s=arc-20260327;
        b=WXYTvVtEH7fDLhSbp9n6/kyx1tB+WKu77uwy9WOTLqHv2l/I8O/YHRpGj8eHoRFjoz
         iimP+4UjImN6WstL16mUj9bSAIU+fluSnrACw4T9LeCpTZzFaEJO4QREfmHD3yF4VbX5
         HCRIHvBoCFo9XknwLaSVpThMrzv8LT3RJBiUHO2DJ6TzJ9LQYi/IXDy+yDNe1ONUPEcw
         JgTUEeZVtziVdba3FMxGwduAZg9cYsWaPvEBZ3sz4wanHP6AAh6O8iGXRJweErhTRn58
         Nd5HqbYA3dKSGc7JxK/5NVft+fUdsc5vKs+voyZO7YNP+zgXhy+IWBVIzQ/TAqBTRxpL
         oznQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sHnXZHT8WiiUeAdh+tKiJaengtnfesqTEZdJsUGA+8I=;
        fh=+6td3RMenRswC4/P8Th+ZVYq8kiPrRSaNSwfjHNaJho=;
        b=lEFax/MUd6McpWHyJS0Hfx0rCpmPy/O00x9F6h7IqF2m3pLEoNJBn0ZtJj+D1+Zr/v
         tMF4fd8bqRfUjqQSZ83BVq/xt7j3HK33w77v92JtrId7PR3Sk7TlAs4S/gNjnIuFKyzU
         L37w8ZdilpEKRynwtiosN9Lmag8ifodZPvKIOxVBzpfOpN4Tx9LEauEGD9BP23xNHTcy
         dcEFKC4j5Ee8iOTtNfVuc7sA0F8Cqh8vtq0oFd1G5w9fXRDOIjfuQS3aNGxnnGCYHQ/9
         DCWOQc3A+/QJJ4yDUdQjvy9LmHoG+iFj8s73uxHL+H8SWj/RnkggXHROtBSg03BnYpHa
         IfMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787614982; x=1788219782; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sHnXZHT8WiiUeAdh+tKiJaengtnfesqTEZdJsUGA+8I=;
        b=J8zz2uq0Umbqvp2tan+3laq4+yW1O+YyEfsdJhtOVZt84fULLOAmXBG3tJfLWBd7PN
         oAtMkKJ6WLWd0p9wMiLWxcRFZaegF96J/Te/CEmHvM6LRCarIXWJclrflJNVVdxtr+QQ
         Qz1BP1t9/IjhtDfEPjDkguThM7omF/GUaM7q1HrdD2WpYWzrI0EqYsETDeuA5LYqedo/
         fXvZnI+tlA2nntjkjqqEmbMF5p2Xech1XRCmLtc3zsYkBgkjIr/8kNboprjzHu/sq3Wa
         mWoJw/tiQTxnBE8J5GlOMAXlF+0ePyhMIrGsJO7OzihktRVbb+kiWaN9Rw3gsBcHRIIm
         NTVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787614982; x=1788219782;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sHnXZHT8WiiUeAdh+tKiJaengtnfesqTEZdJsUGA+8I=;
        b=o+ywvIowG0DAKy6Omir0N+sDKdEDMTueMhzGALXMG9shg1UbG/Y2bbLeCO2FiYlJRI
         R2BNdkckq+xyhkzjDmTpbLcCIWxjv+354OM+4c7MRS3j8alYSbxUx0qy7pNk9unk/BTP
         HDdl99uv6gTijEDZyiN5s+HXpO+9yFrMtRKiMaGJJ6JR8LtfAbrexNYakxdge5JvaC6l
         8fCTtgmF31oXLk1KHg2rnzTUvWI06fAeNFKnnieEQ8tqnQlb8Xh1UC3esEt4ochd1DIH
         B+XXSecebO0tcUD3USmKsBLsVXrmsnspjXubGAArudY5iUvaMvDqTFzh74eaEGlLBreg
         pzDw==
X-Forwarded-Encrypted: i=1; AHgh+RotEFz38Mf9OlOH4ki6HM94NeZCER5Eacfd1I3WMklWn2UiAA4NMc9W2Sv/XisEsOi7gQjjO++Ofw==@kvack.org
X-Gm-Message-State: AFuF++k8PwyFPa0DVX9E0zSb1U9+jAH7wy1k4IgorwKTLXVf3oHpWFk3
	THktxafQtwqFsi6j9GAgH5ph0Os5xF74nwMJSe21MphcuTD5MaRLgNdv8mNfOUTywaLXvYiyRYS
	GH8uDvoX5LDGqeo6vkkhjiDW/KiWsSKo=
X-Gm-Gg: AR+sD13UrEutu/qviDFmziBaeRAZAcTiGYcndAaAJeoUbo14rRlpj9JBxSHcHLVnkOu
	3Vutg0xAyTPg5lIP2K2Wwva0N0sMmsZno3zMoK7AhOQe491blg8lfH+oHQSyOz6I6EFnjSyR7bM
	Jp7A8hwZthc72YnMnt2BXq7UUkGutGBgbGiWHcf9A5UYgb8NfHlq3b+STAZwdivMwztjv5vhkEf
	h+u4mccaYylWdJcsfolLfevJtbWWgQ5DwqvJgVEbH8CNP3JByHTT6HoPBNT/J4zPlWOJ0R1oFNl
	lgEZpmBVqd84Pt391JWMj+fpVERTRG0EImLcWPCyNOpRg35ia1FMvcBs3+qqnmMKE3wxhA/efNk
	riZzkMghl78nIhpetZbSnwUBlA1s=
X-Received: by 2002:a05:600c:5294:b0:499:7f38:d77 with SMTP id
 5b1f17b1804b1-499b830f690mr402396315e9.6.1787614981730; Mon, 24 Aug 2026
 16:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com> <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
In-Reply-To: <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 24 Aug 2026 16:42:49 -0700
X-Gm-Features: AcwNN1Wa1AOcfS35Y1v_bgY_n2l1WDv-MkAP-PHL7EYAY7Mw9O0j_aJCxbHrZ54
Message-ID: <CAJnrk1ZU1UO35n46acq9My77G8=h3JUCLXchiamBCFbiDZXJzg@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: James Houghton <jthoughton@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5CEC880005
X-Stat-Signature: dxmwrrai6nm1pt8e3r6wq5xwffbasirc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787614983-323824
X-HE-Meta: U2FsdGVkX18VgDzyEB/Zrg7HcCdj8f2Ky6A3vlui/obWqXcpFATDxDCT+X/KEcCqkas8ZRHjQpbChcKiuKUyCJmHQuI+/+anoE1+suZxtjRZ1xPZPegAJjbfK3zihxjo+o67GX4/zABpIa1yxIF5pJ4wzFRQRGr9pmcpoAGL8aJd7DCwr1eek2mbOEOqyzTv3QW3xNVl488kkARrpuOcD53mmYnLze9syl4SqaxYqfuxgvLsKiyZmSqzzTjzWfDPg9FhWj39pmxOzbjd/+F5flxHyKKNBJmQEeWL5coGcSTiIt8j+75tu3OopcOD4sCCif3mdPH8yfm837qZrNCO1qEmXyQHgdzh6QRzh492mM4VP3JDnJJQRWQlk7alvJjJGQJd9qqtmRBm829QfNske+R7x2BbPX4upK49Ek2dlYDTXjtROP3NCPS4Fw4f+h6OT2+iSN5qqrBCSezeVymlwAukXh800ZM7hg2pj9Xl5zUf7cl42tKNyv1EM0A4h+zlag8xjO8vVViKnG5kaaxVrWhTrW0JvdJJuDff9chPIzLdf6I+aynPb6J2rDbnAWPiqCzfsbBVtKdfaw+1HixoRbb1hMYFpZm797ohyJQ/wIus4CJZpvzT6nC91JoDulFjAJiSheVaXBYZHiZlX8CwyLOjOygp4AU4DeNiE/hGz4QcBkRl3WAe2FdYzpgSdKWxPd73Gnlj1Y8QliwJ0yV+S5Hu/XSkdEtTNNzHX0bkWH7Q/Etdr4lkTNqpKPkcv+oTjNUS4VAiYDBeJ+NaLJIzoQk5Zm7T14EqmNgtZE8tBrLvuwNo7M+jZ1rCshTaxl+3nY4SletDFhi0zSCHiOmkpUSf5U9azbAXZISc7TlMUxgdpOEvjODP+RpC7DqzMF/lzz0Psq5Ke3w7iTyfz+ITgiG1mT/QLA724x6r/EW3cdde/B4sCF/sP/8Pe/j2W1SS/UTWol3iDUULf61qlIK
 nG6Wz18g
 077aGXl5KxkwCE0iif6NBIl5coP3LyRkraiWeorRwtY/KtnxoDObsnLxl9cQ6Bnj2JRZo1e+yOgLGvfwC5D79bW1uJ+uD/DpcyyDLP+w52adrZFtcpZcOP8OEAgOU+3nsQE3ZK1F94m1IYZSeuOzYj7eWWB7g6Y9WXBlyp9b8KtzuAd0miaq1D4fHZN4jz8ZRSXZzSZhalhToOLOuhdrutZkvKxODRyL3mZzsxaBVQc/9iz1X33CJghidSUF0ub8j3I/cJrzpscwESeixsDepcKlIIXmU/2ZqrDKcXfefjSlEg9oRC6IeeDaaJJdr8XYhQpJ4yVkAA8W2wr9kabOyxbCmnb4Ni1FNFqOLFyEUG/SaD8/HnFw5u78WYEHJ+8pUMpTLIDwAsx0mpIndUIEljhmXTvuLqrCGHfQb4sESlkn9EnKxSntxLlBzDDJ1C6S2erN3kjEKLtP2K7WdritmY1XkwluGuuBLz9Z/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 6:39=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Fri, Aug 21, 2026 at 12:41=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> >
> > On Thu, Aug 20, 2026 at 4:39=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > > Would you be able to share the test you're using? I've been trying to
> > > repro it locally without much luck.
> >
> > The exact test uses some internal testing libraries, we're looking
> > into whether we can translate it to a standalone C repro.
> >
> > From a high-level, the test:
> > - Creates a VM with 260 MB (256 MB for testing + 4 MB margin) in a
> > cgroup, backed by shmem THPs. The VM is not a fully fledged VM, just a
> > KVM VM running bare metal code (so 4 MB is enough margin).
> > - Enables zswap in the cgroup.
> > - Tells the VM to write to 256 MB of its memory.
> > - Checks the cgroup shmem usage and that no swap occurred (no limit).
> > - Sets the cgroup limit to half the VM memory.
> > - Checks the cgroup shmem usage and swap again, usage should be ~half
> > and so is swap.
> > - Tells the VM to read the 256 MB of memory again. This should cause a
> > lot of thrashing and reclaim, but no OOM kills as all guest memory is
> > reclaimable.
> >
> > With the ratelimited flushing, the test started flaking 5-10% of the
> > time due to OOM kills.
>
> Hi Joanne, Yosry,
>
> I've attached a reproducer for you (as a patch that should apply to
> Linus's tree).
>
> In tools/testing/selftests/kvm, `make` should build it. Instructions
> for running it (like setting up swap/etc.) are in the comment at the
> top of the file.
>
> As part of the patch, I've also included a sysctl to dynamically tune
> whether or not the memcg stats flush is rate-limited. You should find
> that when it is rate-limited, OOMs occur, and when it is not, OOMs do
> not occur.
>
> This reproducer behaves slightly differently than our internal
> version. This version, when run with `-b 512M` anyway, seems to OOM
> simply by setting memory.max, whereas our internal version would OOM
> upon re-accessing the memory. Not really a meaningful difference, but
> just wanted to point it out.
>
> Please let me know if you have any trouble running this test or if the
> test is wrong in some way.
>

Thank you so much, James! This is very helpful - I will run some
experiments with your repro this week.

Thanks,
Joanne

