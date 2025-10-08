Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96614CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 04:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC58C8E0006; Wed,  8 Oct 2025 00:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A760B8E0002; Wed,  8 Oct 2025 00:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964628E0006; Wed,  8 Oct 2025 00:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 814DC8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:10:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EC1D119D8B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:10:40 +0000 (UTC)
X-FDA: 83973620640.30.A49BF9F
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E36B140006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:10:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YIcj93Pe;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759896638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k4kMP+g5RiEZcnhoRkeve+Z9tYSilH0RKGWoeHvR8Vo=;
	b=yQO8Dw47YC5lMxckESCyfYIgSen4NBn/gnJqNIkmL1YYVb8pMNjXcQtJ58GWX61kSrclgw
	EkHOGpwji7K2KZvpZW5fs4zV6EgzfbDhW71RqLWW/7XEGcT0ggDhmfNVLPY/zybSwoRafj
	ylHwaOSpZ+rWkvNDIAy4pEYA+kGg0n8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YIcj93Pe;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759896638; a=rsa-sha256;
	cv=none;
	b=in0UXfZcKMYYG5ywJTtZOnOSdMT/3Bm414PAWB0AIK71uCXkzd6JSIsQM3ppBo/s9ubKWX
	gjgvRf62n9aG2S+qL3lbFmMFgw2+tygHE0rzkZd0Db3oBmfSiJWOpahlCBa98lY+q1BFeU
	rWta5ZNdNd2aGEkcpqmRdJ+RDtZRGJc=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3f42b54d1b9so1732075f8f.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 21:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759896637; x=1760501437; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4kMP+g5RiEZcnhoRkeve+Z9tYSilH0RKGWoeHvR8Vo=;
        b=YIcj93PeIb2kxl+6XjPbrt92Kj8VcPOAjM+faLYngN1Z20642a6IOF6qhwWHKzh/67
         ASRZcK2fEKDlWUj+ZVdm0MNzl+bIs9vOTyBus2/+tHnNtnMwSdb5Y3wZgyqvHlvoD8XU
         OVOpL3YeGD8YvsJpHEfWfv0bvh+tBP1JvJSDA8WiHtgrb0lI3JAfPpLaecmDeSzrUURQ
         JYMgT4sRd0j1pEsWFsgDHyKX7FqJfe7yqgP2lpKHEpgn7HCzWzJpNTIKqz2RyzSfZuRN
         vxp1g3Q2nSZvLTFFFLKjnAM+LOPNuu6LcqsljqdpNK2y/bEWO/vZ7sGK43vtsbE/5YUY
         eBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759896637; x=1760501437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k4kMP+g5RiEZcnhoRkeve+Z9tYSilH0RKGWoeHvR8Vo=;
        b=nxQ6HOPgpmHJndBAhOhovtvqkS8Rkx13jfGy8Ga0+VuXWWt/h5ECuf7gyWAW2Cnmi2
         yqn3lVr1lRP+QX7KoUTi/HgI0SD3MSFVLwnn9Uiy3AylxzaLmSqcYBkzq3xvXdz8hQZw
         BS+E9gnZeE6r6s/BTViEktK0h76dgL2H/ch+fFM0b9hNlr2XgxB/W526EJqd1NwHhIW4
         ibM/+JGwG9aRxg7AoQ+8u7E7BWgVB3OZgED3YrUa0T2ZMurR12wu+ZD8WOT+QuA2Qfs5
         dYkXCd76LQuJzQkI6sa+ZGUE90PtKvvFpZDwn7G9DgS25P+KLTPpDcqRn0sZgnrSOioi
         W4Bw==
X-Forwarded-Encrypted: i=1; AJvYcCUBcQDt5KH76llLiCfdzmDldreqFQSTEB6ni5VqALhN4wb9XH2fqQY00Pvfr5ny72CNUXIgKS0/YA==@kvack.org
X-Gm-Message-State: AOJu0Yy0ikoYbI2L+lMQ42jOxtTExvdhCXaa+33031BLHjLHpcak2aqp
	AV9swF7z+bWt8Bzt8nzObV36f6znpdMBhhVXG+tys5ymIs+kcnSalzoixlszn88a/+HeSfZNIp3
	hpsjWSXKTpPoB9jRL58PzjB7tmR6VND8=
X-Gm-Gg: ASbGncs8t20uQZfM0pwydNM3qkMRUk+pdV9rfM4lfS6DC4LNNCUxIvMCHLfM7ctR16U
	22Yyujhg2YgmlLEawCwGQtsT4ucZFuWgMJkQ5SST6rXUbdE76hl5ZzCd4MyyIAQ9zpv+DLF3GRr
	TdGcZBvCgSJqteBsu3ONlQpL37ovS/WbwjDTMJImO74y6eBdJrJBUSgPyKkpDIDQhcAdKEikrUF
	O8V/S2rgjqEBHS9inhXvqNBfncw2dg4WmenbimtM4JpVjKLqtDf3dSX93W+8GzndQpQBEDQT6g=
X-Google-Smtp-Source: AGHT+IEbTF1Padja2a5VYTPxu9e01sfQgU7xUDhedDQcSi45ZcqbFc2By50SOlGmeATDd+z0rHt0ZHSn8owfVsEk02s=
X-Received: by 2002:a5d:588b:0:b0:425:7f10:ada7 with SMTP id
 ffacd0b85a97d-42667458124mr907732f8f.20.1759896636654; Tue, 07 Oct 2025
 21:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <CALOAHbATDURsi265PGQ7022vC9QsKUxxyiDUL9wLKGgVpaxJUw@mail.gmail.com>
 <CAADnVQ+S590wKn0rdaDAHk=txQenXn6KyfhSZ3ks6vJA3nKrNg@mail.gmail.com> <CALOAHbBcU1m=2siwZn10MWYyNt15Y=3HwSGi7+t-YPWf0n=VRg@mail.gmail.com>
In-Reply-To: <CALOAHbBcU1m=2siwZn10MWYyNt15Y=3HwSGi7+t-YPWf0n=VRg@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 7 Oct 2025 21:10:25 -0700
X-Gm-Features: AS18NWAHpHX-o2MgG3uRPCIrdO8_WsGJ2z7_dnabrBdSIRdjp2sl6QIslommR8o
Message-ID: <CAADnVQKzW0wuN3NfgCSqQKVqAVRdKVEYMyJg+SpH0ENKH6fnMA@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3E36B140006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: uyqth6qdushu3ucdjf5uy681766f7mfi
X-HE-Tag: 1759896637-889598
X-HE-Meta: U2FsdGVkX18atnJqJuYvnpAV37b1IiG4KgpGyAPeON2ZauWPp0ApEMK91y9y4UBNwmcGJORoeAddzJ2pMcwHWvSrudz66p9mtAKAn4IlZy8k6zeJvPbI/84ETgl5uVx/sdyhurlBRpWO5Hzyb+daZjQPYQv0rlEC/9/iOP9P62UbSei0gQhFI+thKW0lnuuc25B8bOcSgNDVSa5nH8uoBC75+IQmyWsypLTZRLPjrCCzZXRKAFeQ7y2O9zfg6USx45d6Edb5J5C1YVVCkxn6OZ6pTz7f0Yn9w4xAKNUPk/CNtqWj21Sn6g30d1FB5FxEYBiEkesS6vc10KFJ4cWdsHs1AcFIZyi35eZGYU82bGeBv42Sesq7Ndb1ATMCzMFufpwAD6suUHLhXLRnQGWfncAqnzSqmFE9bGdnGO0mj66K8FgXDSM94ecVZ8ra3QxSfF13SVByoxFLUr8sUEf3my4vUbk5WnacCMuTCx7//vCeLGpLOibNVYyfTI1vFA2icHF+vOJ+kNnAWfyaLpA3uOjebmxpNMCG5Ys0erz8cMHxo6AwRUQKho6GbJjIGHd2oJbeZUJg+Dt97FVvY02WSFX6PF9cOaPjP44/3FbWOLVmrojxYlhS9C8Ci8nfO8IDuEKtlGplYG0H8iz53LkStBrH0z26K7uxhsJ2//TgE5eVRt+khSb8qImZfJARgtxCQ7fULvu0VfRiwjECqLPI52yBKV0E4VrJ4mEjoZIv+NRpUa59UlFUk+eLHU9Kf9e3MveS2biXGa7xQlhLECcZ0qAs+MqeumY1cXb1IKgMk6nvd0ch/lqHR25fEzk9/wPrMPX6kZchv9aVXYHbsHDNSZotscsyWb7eTGdIPX0KEFuNNeRkTzc5qxoubIvEzkldhaSO20r6WHniRHCe55r4AYnLB+Yxx0rO/FcaDWylpHLnc2CMFdpgaHxAsQRn7KBjNuxDju+pVVT4t3pv1px
 pUU8Qwg7
 NrvM+xtZFm5Q9PcDwg+tJmZ+MswdLZ/Jrh1jZlI960bSFMLBUvhIosqrDC3Dc67j9J2AdclHlodgAWFNiBKLMowFndMgg0R2pkZh54EL80YhCgIfz3YhfmkwsatXNIkbVTXpuN0J8WiONjBg2s3x+JLNhbNRaZFtH03pgY+7Pj4kTblKnGH5UrjKWdBnvyywVbmy/V3sKex2hB+T38947JGT4vsASNuw4T3iR/iHseN5nRsHaX8ADFa3/FxWxq3DH6FBtlduFQsv5w/esZIjS/JVnbka4Ji8ABGgEz767klItKGOVqRYcAT7KiLrCcClUlirKpDXDlD2FWLeSY/xDSSj8WJIUu2/oHSz3g/HbFGnlYZVZ1m9i7z1/faRTyij5AQkJkehvgSXBHo5TD3yMRZ0JY5bDEWWgUVTLFwwUNrWu4ipu7/MAJ5aofNTkxLj4m0b2uz008JDPiA6q8IEpFzPDgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 8:51=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Wed, Oct 8, 2025 at 11:25=E2=80=AFAM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Oct 7, 2025 at 1:47=E2=80=AFAM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > > has shown that multiple attachments often introduce conflicts. This i=
s
> > > precisely why system administrators prefer to manage BPF programs wit=
h
> > > a single manager=E2=80=94to avoid undefined behaviors from competing =
programs.
> >
> > I don't believe this a single bit.
>
> You should spend some time seeing how users are actually applying BPF
> in practice. Some information for you :
>
> https://github.com/bpfman/bpfman
> https://github.com/DataDog/ebpf-manager
> https://github.com/ccfos/huatuo

By seeing the above you learned the wrong lesson.
These orchestrators and many others were created because
we made mistakes in the kernel by not scoping the progs enough.
XDP is a prime example. It allows one program per netdev.
This was a massive mistake which we're still trying to fix.

> > hid-bpf initially went with fmod_ret approach, deleted the whole thing
> > and redesigned it with _scoped_ struct-ops.
>
> I see little value in embedding a bpf_thp_struct_ops into the
> task_struct. The benefits don't appear to justify the added
> complexity.

huh? where did I say that struct-ops should be embedded in task_struct ?

