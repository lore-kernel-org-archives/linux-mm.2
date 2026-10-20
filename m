Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE337606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GzZuGTTk
Received: by kanga.kvack.org (Postfix)
	id 0B0346B010F; Mon, 19 Oct 2026 21:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F316B03C9; Mon, 19 Oct 2026 21:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90D06B03CA; Mon, 19 Oct 2026 21:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C864E6B010F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:02:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E6C612089D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:02:16 +0000 (UTC)
X-FDA: 85341203472.07.6BDFFC7
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 63AB2100010
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:02:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GzZuGTTk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792458134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/WVBOtkMP6M1xXLJUzfcGRzgTR4eIpAO+QQLGvxAdw=;
	b=AqtCgiQHvI2YtNXCRiHq3pwOIAMhBFXp5IXvPKxSkULvHb1U+iZA0gYsnAWqzOhDzoIsoh
	D3TDqvfmRWt/eEAO4HGCyv4lazPh8ZHhpoVoXY9lA39OTFUPBGvvM+4SAUN4zcqVvZGoiX
	8e77gGBDDzIvkQQ5XNpW5uHfgcs5VQ0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GzZuGTTk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792458134;
	b=jS3h0dem+yXEDS1iShbHR2iijUNYTUmePsQrKZ683YYqlnb9nUnH9DCceFk+odtfGgnLhK
	7+djhDrGhb5zwY5n8yzwFnM2ZFQF5Ftu+YoskMsygNeBf8y0eb4IKruNO/x9b9eYbTFKsW
	wZz6J7zR9VL+JHZewbTnJlRvXHyltoI=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b10ac6ab7bso11538057b3.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:02:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792458133; cv=none;
        d=google.com; s=arc-20260327;
        b=Tra6jYPdEtmZ4FkUB1Cb5q9GxKaPlWs6e1ZVy0HcdJN03QGS2kZ57o321GRBU5qd4K
         5YMyjSr88GucKG/9B/yiA57Wt2yHbW6TeXkk5wuOnhc3ihP10wSTYzViWWOHTV8fDNRP
         9Ig+r8GSBngxGZ16kZnpBnGQIObmYA+bN1h6fG2zpBE2a8nk0Ay/fAtt97Z0XI/yocKf
         2Q5azJCe2fJVIQCZdc5WEQhOzVKxqalqu3IUk4qHfeIHlyWBY/AkX7fCIgyEJctpPeq8
         fVBWw4hGUeavOFHm/KfDeh0fRqYbcLNrUvLZp9YzmnPYYHpPII77qVC3Hy8yfFR08FzM
         yoIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B/WVBOtkMP6M1xXLJUzfcGRzgTR4eIpAO+QQLGvxAdw=;
        fh=WzCCL+a4l0WOfiW5ALxfcyuSK9j7jNvs1L/TIA9SEks=;
        b=mNEy2/Zg4W8j38qnspP8507zff6UWum17x6+py6lzA7GeOsKXTxNjMjgc5qcKRuv8n
         IXEYnQof7VpAupMA5pW/F7gIjOU/WjIDc+u5cd5lE3XCW3tXGLD1JRerbH6iDbDuuu5e
         87epUOJUt76MujU2po5Rs6sUbF+wHZ5pWXfT9BvGKw7JbDbe13MAPC4Od20C1u0r77S0
         sxbkQHQFMWg43qZIrkI/0sG80o585uOLxQr6ajDOCY9OpcuJyRplgylqLYeYrzN6FSuD
         TnTo510qHKCktQgeQB637da9f2WxHbeZ1yVUXcadHOXIBnQIbPvMmNJdonC5hxnTJVQf
         ejRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792458133; x=1793062933; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B/WVBOtkMP6M1xXLJUzfcGRzgTR4eIpAO+QQLGvxAdw=;
        b=GzZuGTTk32zBQ4s4XTYXrAvdGJTsVd43pVEFG7dgjBvdtup3cGFsYFWyfng09hF5TG
         +2RAlB6wZUfCeyxejRbqX33hNpJ10ZtFHgyT0GRJ9zF7HZyV7OUB2gGl7oSTmPQqsWFx
         jonpkGiWnqmiVCQC6FdeuWyCRc9JPeNE3q8OHNMzAK2tmodYNbyE0g6DBG3k5LjCdzui
         Igi3lf6aGCRSYP6BBNXRrIo6A/4eM0yiwlzr+tMbyaJuOyhfkFPAHSrmduXgNsMpSd8w
         dKfQZXiYn84yZJzZzllj57F3DTrYYyVG6hE5TgrSMZlaE2SiovZIDtCTbjAYCWAWfDoJ
         pIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792458133; x=1793062933;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B/WVBOtkMP6M1xXLJUzfcGRzgTR4eIpAO+QQLGvxAdw=;
        b=I46BJ9mJzL5g994yfo5UCySHLNwbZI+yIlpzMThXv7v0a/bH6reFxSKvzwIxrc/v6M
         HV8loYTaf17pdBy+oRKNCAzXRSwfi19N8ADlICjVex9KNE7fzSxWK3ERRVWWvyvR+b2w
         MMQNdEsHcDSc3zMOZ/TCKaEaWbueVd5iHUAR5vg4FUHLAq4u20ya8+Uel4IqCHIJg+lC
         v5ZbP3NPpPWXfMccMVJNnP9L7WNllJHYV474vfYK7UHr5Z2WFrc/fplb0KVf1cgxtrIo
         2DQnt0NLnkLa3ZFmggOVJDf2CUjEQ1b0Vp63khjXzvrs3HSKqDeTcwsQm94uBaRWoaP1
         LJDg==
X-Forwarded-Encrypted: i=1; AKwUvBwh451VZtCElqT1dg0dP+X2KO8wzNSwZDvuYFt8CprknT8+2qpxT1yk/RmjZQgrDAqbNpGU9j2VNA==@kvack.org
X-Gm-Message-State: AFq9FYLboaRRqRdRxTq47Cy50pSoMoloIpGm5Ye6b6Z8wutZUgnwAYZ7
	5kMoyYtIGW4pF8bLPhVQFPVe1p8tsp/BveggopkocOBgnfsogkRy15gnBMGui9KoSA7mCbR6Ypc
	xuAMkpVrtLMxNdGpYUX+xKsB3e/MsyoU=
X-Gm-Gg: AYBFou2IfZNhDDwB8DwfCMMrdkVBVByZ035diYHAcfRR0qAs8w+kbWY0c/P9UM/83c0
	nWKovD4cNXrJ1W/L3SixyGovoRtZX0XhKvWxyWPeDkaRRDjgvuYF27D13iYxHE4STHavN+WJv7B
	kzdST3edidUpzmjBSKf9npMZ6JWG5Xavcp1/qdD/WosxZncy/zrjI5q5ud3gyUgipJqalIaVbt3
	LiX0/KUs9oofFIcR9BBr6KMKu1Bv6THReoUCNHYj6CWGIlZcFwOXag7hjPNYtSWwybtHvk88wnD
	tVD8Ueit/NY/6AQCceg2zHClRtyfg+ZxakoaI8XBhS/H6Gdut867vj1caHNhvtaDhu0jwwVxasF
	NELwW8v9D8Mtt+QH1CHLDlexbumsU2HEk/xGcQXdPrxz4yu1EjHnuVGLj7gBFHn++356hi83sAl
	pXTgE5VASdL1olS5sj9+7dkUBhZL6/3opXyQ==
X-Received: by 2002:a05:690c:5687:b0:864:6f4d:ef7f with SMTP id
 00721157ae682-8b0f2072b1dmr27038117b3.7.1792458133104; Mon, 19 Oct 2026
 18:02:13 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
 <20261017050928.128582-2-sidchintamaneni@gmail.com> <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
 <CAE5sdEhGFtGF6LC4xNkMwGj3vTxLOW=GNBXnk3-JmsgjntXx0Q@mail.gmail.com>
 <CAGsJ_4wmvBvEn_vXu8-c6BRAnRewYmTs8iUd8T7KRx7_svZrwg@mail.gmail.com>
 <CAE5sdEiq3bY1kgMUQ6x7RRJCx0JH4sQ9Z_a9_YQSM5FKNwpk8A@mail.gmail.com> <CAGsJ_4yZ3rueVMaRJ_+25Nnab0WH5ZLQeLjporWAFj7xJnJFHA@mail.gmail.com>
In-Reply-To: <CAGsJ_4yZ3rueVMaRJ_+25Nnab0WH5ZLQeLjporWAFj7xJnJFHA@mail.gmail.com>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Mon, 19 Oct 2026 18:02:01 -0700
X-Gm-Features: AclHuK_oIVGKOtgd9hzF8OI86eJwFkNPW92AAHzmGdzCl9JR3GH39OUDY1L-Ci0
Message-ID: <CAE5sdEjFgVoQbWw12=+AKdCOB9cWm-akxzbX7hJzvyO3vpCtgw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 63AB2100010
X-Stat-Signature: rn4prjyi6usxe6h4mog7byfe3maoqzk4
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792458134-508390
X-HE-Meta: U2FsdGVkX19OVevBNClJpWvPO0IdXVRDHrGI+qlmt56IWDDTGUWIo5vbYIghYEjJXLWiGgPhL9uXRVkhnXd5SsTKjbfJS10EMKyDfe+Go7cUqFwejLau5bISaef7Ol5qRx/uDKvXnlVNZiueYDS3IKsagwi8v6qKz9tb54glLkgGNUtpY4vMkOCakEGsyHFlIAy1anAP7lvybsBVZrEdaAGTDjHlRsSejBbGLNxHjSLIj3MjTFSr9AIEs+2tUTexpeSZP2AclvYaQoLadsclEjSyaKh6i16vyynsSAYOYNpkuy44N+zTry27fZa5+ro5yeUnNItTng3BIcWlyKaB0qFDKmhTHGLXX5rWbLYgAkU6uosKpLj1NfM6oigY4kGEmSQyeKsNHGdbZPOLLgi3j/GMaTA4JGKOR56TwD7cIjMbxoApzAfQfSsfwYDugXLzmEjHsfkPKev+wZtw3UwSl0wraK8T17rjoBGg9QK69HyPI4Rx4ENisOFgdwzIkr7SKopBgPSb16yOJ3AL85kytrUymo/x1/hSqE/JaKYwcaPbqjLLVUtZZVRo+zd/yR6qCI9duYiXrDwLsFV4ENIt+GsyzT2WUJXCpwiwn4FHWjyo94eI06UXMC6DZmZLHnJi3Ol6twKUPIGLG8KqYr3amKqzSWlOmSwmCuWkWDdMWAMtTigMAD8QIZLYpCTFlPi+HWVCSnKfisRposTFYDHIEoScQzgMTX2OhiiJ6V12vmonrDIAVfus3by53rkelBd3QtmpFrme8b4qiTZAa222c1N4G/B8nFpNaScDw10fKuBVGCMw9HcOfOqO25Nicv/2lXzJQr9IYk8VhvzI032NsvVLB5GbJuoFzo4lSqC8v8Bco//MSQzn40hKlEuSdi+FcJBemMsqJN6BKeJa66YRausG3uf7R4blr3ghWTUKPXaiHiaYqKctMwjFknRSS9quGupkVkzu2ekwNpZGaS5
 b0uQEaX9
 s7GZCBaybpdCzrfaTbo7DsnE+hQlUfVeMWnK/r5dv0gKPahHenSNUzkujoHKVDmXrnlpfKlwQ37HV2lcNfCvLfm5hAij7VLE60JovvV5OiZPMcbRpuswTO77C6ZY3ebaXvlI9tUO3AvRej1wMzgd5dQ87CUwFKO8CsHDaAOXrD07FNLStFGfOj0hdiS/0tWNmR3GZMmVOVvxdXGcv63VYMBf5qpFN1llkV1CZAl8nTjp3BsVKF7TewUnVRWmTfBYimzccmM0nu3UcKeWy9yly+weWJxh9lO9ljm9FfRfh59b4lz2HGjBLwONJrXAxIuN9k3E7y4O0V4jr944h5ngN50/FjOHPlXsi1kn6WOd3gFnPtBUnXofg8WzqqQCC/CZxN5F24IN6BTKSRxZ9FPXJIZZMKccmV3Bl2oUHOyFlSUQO4UnNhx3VcYx513mufSAd2n7dYa3FUpqxIn9El2Zj8TF/mpZ9H2XTNyPdWas7zUsW8pnfiR0J3IYQrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 at 17:43, Barry Song <baohua@kernel.org> wrote:
>
> On Tue, Oct 20, 2026 at 8:16=E2=80=AFAM Siddharth Chintamaneni
> <sidchintamaneni@gmail.com> wrote:
> >
> > On Mon, 19 Oct 2026 at 16:36, Barry Song <baohua@kernel.org> wrote:
> > >
> > > On Tue, Oct 20, 2026 at 4:33=E2=80=AFAM Siddharth Chintamaneni
> > > <sidchintamaneni@gmail.com> wrote:
> > > >
> > > > On Sun, 18 Oct 2026 at 14:24, Barry Song <baohua@kernel.org> wrote:
> > > > >
> > > > > On Sat, Oct 17, 2026 at 1:09=E2=80=AFPM Siddharth Chintamaneni
> > > > > <sidchintamaneni@gmail.com> wrote:
> > > > > >
> > > > > > Andrew Morton reported that get_lruvec() has the same problem a=
s
> > > > > > lru_gen_shrink_node(): when memcg is disabled on the command li=
ne
> > > > > > (cgroup_disable=3Dmemory), it returns &pgdat->__lruvec directly=
 and so
> > > > > > bypasses the initialization of lruvec->pgdat. The MGLRU debugfs
> > > > > > interface calls get_lruvec(), then dereferences the pgdat point=
er in
> > > > > > lru_gen_seq_show() and other paths, so these can hit the same N=
ULL
> > > > > > dereference.
> > > > >
> > > > > So userspace must have booted, since otherwise we couldn't read
> > > > > debugfs. The reachable case is therefore a memory node with no
> > > > > LRU folios when debugfs is read? So this could happen on a multi-=
node
> > > > > system where folios are landed on other nodes but not on this nod=
e?
> > > > >
> > > >
> > > > That is my high level understanding. I'll let Andrew to comment if =
I
> > > > am missing something,
> > > >
> > >
> > > I made a silly toy setup by running two numa nodes with one of them h=
as only 4KB
> > > memory, the other one has 1G-4K:
> > >
> > > qemu-system-aarch64 -M virt,gic-version=3D3,mte=3Doff -cpu cortex-a53=
 -nographic \
> > > -smp 4 \
> > > -m 1G \
> > > -object memory-backend-ram,id=3Dram0,size=3D1048572K \
> > > -object memory-backend-ram,id=3Dram1,size=3D4K \
> > > -numa node,nodeid=3D0,memdev=3Dram0,cpus=3D0-1 \
> > > -numa node,nodeid=3D1,memdev=3Dram1,cpus=3D2-3 \
> > >   -kernel arch/arm64/boot/Image \
> > >  -nographic -append "cgroup_disable=3Dmemory
> > > ...
> > >
> > > Then I got a machine where node1 is very difficult to have a page in =
lru.
> > >
> > > then i ran the debugfs for mglru:
> > >
> > > / # cat /sys/kernel/debug/lru_gen
> > > memcg 0
> > >  node     0
> > >           0      14972          0         953
> > >           1      14972          0           1
> > >           2      14972         18        3308
> > >           3      14972          0           0
> > >  node     1
> > >           0      14972          0           0
> > >           1      14972          0           0
> > >           2      14972          0           0
> > >           3      14972          0           0
> > >
> > > now you see node 1 has no page in lru but yet i didn't have any crash=
.
> > >
> > > i think i will need more time to figure out what is the problem and h=
ow to
> > > reproduce it.
> >
> > I've asked AI to repro the issue with the similar setup
> >
> > qemu-system-aarch64 -M virt,gic-version=3D3,mte=3Doff -cpu cortex-a53 -=
nographic \
> >   -smp 4 -m 1G \
> >   -object memory-backend-ram,id=3Dram0,size=3D1048512K \
> >   -object memory-backend-ram,id=3Dram1,size=3D64K \
> >   -numa node,nodeid=3D0,memdev=3Dram0,cpus=3D0-1 \
> >   -numa node,nodeid=3D1,memdev=3Dram1,cpus=3D2-3 \
> >   -kernel "$KERNEL" \
> >   -initrd "$INITRD" \
> >   -no-reboot \
> >   -append "console=3DttyAMA0 cgroup_disable=3Dmemory
> > initcall_blacklist=3Dkswapd_init panic=3D-1"
> >
> > and it was able to repo it. AI identified that kswapd is initializing
> > the pgdat during boot, so blacklisting kswap_init was able to repro
> > the crash when reading /sys/kernel/debug/lru_gen
>
> Thanks!
> I guess you mean the following:
>
> -module_init(kswapd_init)
> +//module_init(kswapd_init)
>
> Yes, I can reproduce it with the above as well.
>
> But kswapd_init() is definitely called before we enter userspace,
> so this doesn't seem to be an issue here?
>

Looking at the callee sites of get_lruvec, all of them happen after
boot. So it should be fine. Anyway code clean up will address the
issue.

> So I feel there is no bug here, but this cleanup is still welcome.

Are you ok with the patch as is, or would you recommend  changing the
callsite of get_lruvec to mem_cgroup_lruvec?

> Am I missing any other scenarios?
>
> Best Regards
> Barry

