Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B5BCCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D87B6B00BC; Mon, 19 Oct 2026 02:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0366B00C1; Mon, 19 Oct 2026 02:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5F66B00C9; Mon, 19 Oct 2026 02:56:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61BFD6B00BC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:56:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6F50A7E4C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:56:10 +0000 (UTC)
X-FDA: 85338466500.24.C048834
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id DFE51180007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:56:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kkS2joCA;
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792392968;
	b=UQRMR4gnNKd2TwhnFCXLBGQimSZ/ziEmROnLKuEgoEjxKOf2IhDvvOip9KumRYTkCw/zON
	sVoVpgV9a1b1p/0tta7yZ/pIVSxnq4YfErO9k6UZkp97gDz7xRcLzrqXmJHRpyOq9LqQMw
	mmwInk+5NTzQy8NSLGoz7Aq3OUFLA2w=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kkS2joCA;
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792392968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaaaBizOm7JbDRKbdirZXLgkf0levtE0Ftrfaqs1NqU=;
	b=UM3ufMcAPDAfJrHFHNANGeAp5CTjs5TvmCCPX4fQDmQq6GvAq27AEmkYP/VupiXe6mBr6V
	Fmctrkgb77x5MVDvCQ2/+n/YL8yf0oiGlYwrEiINy3rxqzkmDyRBaTza2WYOxkvHXJDUFg
	fPrPKih+A6gLe0utYVQFqdaEmupnkEo=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6798d4ab549so1551630d50.0
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792392968; cv=none;
        d=google.com; s=arc-20260327;
        b=o3uCxGXwlCZ0ovJbNTWuEDtOVE7m6qiNubET0Y6oKz8DaExdyoBfbD1gWZFWXPviGM
         A+6SJiHm8mKMvINZ8UvwreJPeWqwDO3xfL4m+oi1ZXbDf3fH+Lpbpajp6XbV24Oje+am
         q6IpwLNIcl1Z6n5uPc/Yxsa+NJody8ebdcyxtOVp3Cc1XYRM9uILZ7FkgXBQsK7wlkcz
         nhi/X9zw3Jt3++XBm3mjIKPdAo7ZXMqFMZookQL+UHbsfx4n4bIMNjbzV2IQyH5uxas8
         /hZT/bu1sbPBk5O4rCz1pQYVtR6eVXoxMn8ClDBdUjRoINn/lMEkTZgp4c3pbr6fKMoD
         j6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vaaaBizOm7JbDRKbdirZXLgkf0levtE0Ftrfaqs1NqU=;
        fh=RAZSBHzTD7OC8fUE/EE7ZuLhHmWkE+DMNlfXUVdHwSc=;
        b=M39eHRZBGZeav+AzKtkRMm/bQWEhMQGnUPIo6UIPof4CHg5c/nZbDCDBbqfjwDjq1/
         O0Pho2Qf+sFtk+NS3txeqQMmPbAqVxQpwjPcAz3NP6oYjCiDA3fI4ez7wtBXU3xjLCjZ
         feevvxv2NofoVc6Y74Sw1PfPnmSuZ/HOPM4Tjab87mNbg0Kqyeb7kEihO4bJvdLVmOK3
         znE8bvdmnFJnVtOFa6iu76IjYUGt+7HdRyy2m7Po2U2bwZVi7z+CaWXuiObkzCrNRZb+
         CaA0Beju7T9SD1fGjG45BmGQjTOVaKQjl6E14mk/rlEMDj8yx/N7xRdwOJpisTJKAul1
         ugBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792392968; x=1792997768; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vaaaBizOm7JbDRKbdirZXLgkf0levtE0Ftrfaqs1NqU=;
        b=kkS2joCADwqt3lqea+VnEoI3S/6WIKGmkkXqYhpAaFbBIrbtp4DBPNaWPLdOI5C+bq
         SaLERf061xlZp8Bo6wrXaMEGs9fMCShdsdHaDPXUGxKkc0c7eP7SsGJ1p/8Kd9uxNz4d
         sZSjsg4a6bQe7Vf+lNxnp1wJWEFGququoAeFoRR9W96FtCnHZ/7fPTYmXRv7L8CY3pTI
         f5HcVtDJNNkyVYdivFJgTE6OdRUIuH1R0OO9UlmPiaCTihYnduHFgu0E3Y8/Q6PVGUxm
         D3LnWDnZCToBGOj5A9jRdJRcCFulp/SBYsFJrqAmZ0vafAaVAnDjb7mjAnTNMWVGHQB+
         WEJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392968; x=1792997768;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vaaaBizOm7JbDRKbdirZXLgkf0levtE0Ftrfaqs1NqU=;
        b=IaFCuLrdKBsJzz1Se5gkrk7Dm309JaEknd+Ir/Qfpwoeyha5zXaBIhy0F99K09egDi
         xmgroT3T3Lt0GI6+f2Rc01FWRYjGXSf6cp7EyV0BcK0iIJOS+41mPqP7U0WGaIxttb6Y
         CDfBEiumVgehhBwGrLikWkUeWWMbV9URCHfh2JWTUY+BGY39wUHQe95mOX2EhoJeAjGW
         QpRZIBwTEirMvAPeKrtUL6Xti5cCq4pXhzXKsjob5+//oVptD5XJtbGIMJ56oaR2bdz7
         GAPloe73O+GpENcku+XRfxYxDvCpgMSjQRQMYDh3VBMtuCTkpGaI43ncXt7CeBEeshh9
         gbVg==
X-Forwarded-Encrypted: i=1; AKwUvByDs/fw4cOyQako1unNv+zL4EQykaYhX4h2lQ/UeBIo9D9F61AuW9XElYYIT6KXJUF/+RU5ZM83zQ==@kvack.org
X-Gm-Message-State: AFq9FYLMcN9KCMMiwLx6vwv8OGQQfR8zYxgMb29HtO6HRjWZF6HjrgEj
	WlCNW0s+RLknrSvWuwq4PmmZSaa64JofZV3jEbLg7qbN8HIf9gIaLbPHNPlmnNDLdZGdF5iirFG
	dhFtoLBOfILrAF28XpZxXSty+jst3g/o=
X-Gm-Gg: AYBFou1XzFhIM80s7YChdG9o60v10EsVZM/FVoMweQdfn8bXtrHwJ6Z4E3ujIL5BA6T
	5TOjRiFSX1TmAeXM1hNA7zL2bQJkdA4SC6vPGpj2Ftglcrp8BhlLrGDemOAjI8xgmgy3AX1gpHX
	rDkM8Z+EmfF4woOmZWuLylEWqSAWRs0+v1GxnZd3Ys34MAdLy3PZkNdArzo9l8++NyEVkD/Y8EE
	LGCxN73JmAfy07gSuUcpazRHUAF9Ha4cheSvvr+qbJ8rMpbNONRgUuYq4tqGtmauuYPlPmi2uRI
	Gv0eL4D3Q5hnIXdbfl/jF02kyP764n8GJbLJ0pdXajg6iNaPVFx3bAH5xghOic7/EX8bD7Cbv5p
	wOvPsbmBpxg==
X-Received: by 2002:a05:690e:484d:b0:675:5e46:36cc with SMTP id
 956f58d0204a3-679ca8a6938mr1328984d50.82.1792392967945; Sun, 18 Oct 2026
 23:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20261019064157.29885-1-laoar.shao@gmail.com> <20261019064157.29885-6-laoar.shao@gmail.com>
 <sashiko-outbox-176703@kernel.org>
In-Reply-To: <sashiko-outbox-176703@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 19 Oct 2026 14:55:30 +0800
X-Gm-Features: AclHuK-4hRkGnv4LQq98lJIVV6E1PZLgk66c_H-_i08if73Xzq6nap7W0MhfklY
Message-ID: <CALOAHbBHcswzurP5vRqOzsKiZP6N-6J7ACnB_M2tZ1avN2NsJg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 5/5] selftests/bpf: add tests for the
 numab kfuncs
To: sashiko-reviews@lists.linux.dev
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, 
	yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, 
	lizhe.67@bytedance.com, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFE51180007
X-Rspam-User: 
X-Stat-Signature: 3ixugqyxbxoqjborc5qeefskmb8x71hn
X-HE-Tag: 1792392968-385742
X-HE-Meta: U2FsdGVkX188zNu9EHv21MKwC2djJy/Y3HdPzmjFbUk0g6xMYl2dAaHqnGtwYai3QiFql/8RRswAF1XUGopGVljw3v/+e2vlAXTQI2rFcxYFz0/6rrg57RtabKrcRk/1wgY4UX+sVQofu8/UmM3cFtTjKuzVVBtteoO6VGDNwd+gzZHzjgE0WkIkmuLZneJ0gMuWcKMGDGMexzswVxjlIf4MwqWCBzfnOSi0k6rfjPnC4I9gm/fH6RWn3CojusmQp71P4SozVHW1vXIZ+maTEhAFlPCZx8hYnUUmaNef74m1fgM4xO1lp5SrAFxSsS9mxgxc0tnx53jBsyD3fa1FOvJzRfzVc1D8as3+T25T4eD1KwoGLxyAq//XkMKmrw2vF/GKgDlx90OuQs+BeBCMB1ZIEEyJdm6ryTgjBWKLMubCe5XQc1EHSnANjZR3ewoyvVA9uciONS9o3QJDZ/fPbY9YwkYK0/1fwJqfK14NXa506AsQ952O8CcTFCcFsyDb9wvfWY4+RA9D37GUcl5ufcAzvyqTjoT55KFsekjF2777A4fnBGOdrLkxjSD6c5fcEVLZjZf9n/5/YTReDONEy3Rwr+3cOnZc+0E/0NWQq/PBabZ/0N6CAR3bzBP2vHNKcHSv9Gk14MnN/qjAHvECiCangikQTypm/BIfQUuufwwjq7GA5nlZT48eIa78AY7nZ+SwbcGVFwJvmkNts3IQWwMEV3iybkpEdBferWTvdgh1V/UsywjAl64b9pvXz4eQhHpvirLc07oVUxUll47l1vgC7Ui3PZmlfSh532nKLtaK/bGxQjGStyFtYCcsPuAmwlA6glcUYkqrSsrzst+emEd3DuwlPiWe2FSDhEHHlzQTblF/RmudaUdAPMYAsEJAFHfiBXkyf8vEexWMWLHI/0m3EBEc9aY52A/z6StPTjdRHR83NI5GxYDO/fp1gNrqzfM3f5iuh3M+CK3clH+
 ugmEgJoC
 iRErK7ed5SRN29GiREk1vOrIl3i6dXU6Lf2EjecDGhuXVDv+i17IlaGf8stIN8KwRhYbjiV0r4ud7riADIFAMs+SXyhojfbmoYcKRvdDMNuzF6rNzqCVh8KX5/AjDz4UZBCcQRbvXJXmP+2wEBEAqiy+hyFVhf+0km3Tte0V9/w6eQez9VQN9Y1ZeiqxyQ3qqWzFYbdpidnCuHlfkDlviN5AWa2vq7KCX/M1GHdwYvLjbn023VEazFHk6iw4xrdHeCpkvbGe2dVeYHJrLp5/qXHGrKpXk8osRBTvjydLxNbezvQc9O+sLvONiCDKUgvqjLb//x7n+6ugXYGvUDZSzinXkQpMfcfWLIf4Uj2BBrsedELNJEgJk9CzN2pDcNCX5AmpX738DXM9G+RZuwZa8JFc0tYVeYDn1rcWln/ae2VcE5dq1xjI7Bf/QR5tBr2cW9VWZzZj/mJvAL7DvpKbbPjo2oFTl3OE7mE+kdnOn9BFewh/ovPRanVgWAb2/ZfvTkSEq9KXLR6e/dcqSG5xtIvatRQoh7FIY15F8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 2:51=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] selftests/bpf: missing kfunc BTF skip check in test_bpf_numab(=
)
> --
>
> commit 07e4c14213f29b11a7ce19b88e46e524dc48e78d
> Author: Yafang Shao <laoar.shao@gmail.com>
>
> selftests/bpf: add tests for the numab kfuncs
>
> This commit adds BPF selftests exercising the bpf_numab_set_mode() and
> bpf_numab_get_mode() kfuncs across set/get roundtrips, mode validation,
> invalid cgroup IDs, and cgroup hierarchy combinations.
>
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_numab.c b/tools=
/testing/selftests/bpf/prog_tests/bpf_numab.c
> > new file mode 100644
> > index 0000000000000..7ce4b8153c42f
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_numab.c
> > @@ -0,0 +1,227 @@
> [ ... ]
> > +static void test_set_get(void)
> > +{
> > +     struct bpf_numab *skel;
> > +     int cgroup_fd;
> > +     u64 cgid;
> > +
> > +     cgroup_fd =3D test__join_cgroup(CGROUP_PATH);
> > +     if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
> > +             return;
> > +
> > +     skel =3D bpf_numab__open_and_load();
> > +     if (!ASSERT_OK_PTR(skel, "open_and_load"))
> > +             goto cleanup;
> [ ... ]
> > +void test_bpf_numab(void)
> > +{
> > +     if (test__start_subtest("set_get"))
> > +             test_set_get();
> > +     if (test__start_subtest("invalid_mode"))
> > +             test_invalid_mode();
> > +     if (test__start_subtest("bad_cgid"))
> > +             test_bad_cgid();
> > +     if (test__start_subtest("hierarchy"))
> > +             test_hierarchy();
> > +}
>
> [Severity: Medium]
> What happens when test_bpf_numab() runs on a kernel built without
> CONFIG_BPF_NUMAB=3Dy (for example when CONFIG_NUMA_BALANCING is disabled =
or on
> non-x86_64 selftest configs where CONFIG_NUMA_BALANCING is not enabled)?

Nice catch.
will add the configs to tools/testing/selftests/bpf/config.

>
> Because tools/testing/selftests/bpf/progs/bpf_numab.c declares
> bpf_numab_set_mode and bpf_numab_get_mode as strong __ksym externs:
>
>     extern int bpf_numab_set_mode(u64 cgid, s64 mode) __ksym;
>     extern s64 bpf_numab_get_mode(u64 cgid) __ksym;
>
> calling test_bpf_numab() -> test_set_get() -> bpf_numab__open_and_load()
> (as well as test_invalid_mode(), test_bad_cgid(), and test_hierarchy())
> fails in bpf_object__resolve_ksym_func_btf_id() with -ESRCH and trips
> ASSERT_OK_PTR(skel, "open_and_load").
>
> Should test_bpf_numab() check vmlinux BTF for bpf_numab_set_mode and
> bpf_numab_get_mode via btf__find_by_name_kind(..., BTF_KIND_FUNC) and cal=
l
> test__skip() when the kfuncs are not present?
>
> > diff --git a/tools/testing/selftests/bpf/progs/bpf_numab.c b/tools/test=
ing/selftests/bpf/progs/bpf_numab.c
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019064157.29=
885-1-laoar.shao@gmail.com?part=3D5



--=20
Regards
Yafang

