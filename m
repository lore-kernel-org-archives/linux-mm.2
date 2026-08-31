Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C727AC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 22:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6C16B008C; Mon, 31 Aug 2026 18:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A878C6B0095; Mon, 31 Aug 2026 18:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9771A6B0096; Mon, 31 Aug 2026 18:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA986B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:19:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEA83120265
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:18:59 +0000 (UTC)
X-FDA: 85162980798.24.ADD98CE
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B614100008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:18:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pCtFHgM3;
	spf=pass (imf14.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788214738;
	b=f44CMPV7VLaWtXMxu+PjDCxvTeQtAlNQmKylaU+EASOIJ2qgo7QT4A/ORz6e80AT0JmQgB
	T+ITOMgCthds0ZjtwKoXM7ixqVYAPz1lnmWw00DHncTWsmu+W70ReIPAasc83oz3mEAj/h
	nk0Fr0KyteSBSP1Ibp1w9Kmq4Rnh+3g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pCtFHgM3;
	spf=pass (imf14.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788214738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnNt0hP8YJjLsvezbznRGz62Lklpiz7+58ZQDmGUihY=;
	b=dLO3UArAWUdlKHmiuI7J6k8wyUOZk3o4Ng8q1fF8DyaQEiwNSFNLTAe7yIolH7H0Mj+M03
	YJpiBdHTgD52WaaSEkIycpBIuCwDF08hoDN/52AMN4Iq3FE8E+y+l0N5qsKNrMTk2YQ153
	uUwxwMVDmkJyeU966kMFoLPt1ekqSJo=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-852c481415fso5042662b3a.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788214737; x=1788819537; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XnNt0hP8YJjLsvezbznRGz62Lklpiz7+58ZQDmGUihY=;
        b=pCtFHgM30WnoW6wxjCju557WdPftU6ovIS1ogk6+M/6ztcUBnwtHOimjCbvLgJbkr/
         7KnChj+1jv7bH06pBqK0c4CtoIkk4Qx+ZXrAkSqmNvJ8DQLHfPOGrDZRssBaExylipF9
         YcTCm6w86x6sXob8Ak48YfwmgZKF/qu9bhdw3QVqBkMbwfXPIoa5ONtZhIErjO7VTZ2t
         Qo2Py5sUD26SfMXfgM3iZw3WJlKAFBWuiGQtjfd+2Ww+jDZvOrp/0iRlAgHzUnzeg5Cr
         lpRsoXN8L7I5dRYcHM1/6VbE53YDvziEdLZstK/4P1cY/iHpbzDkfl43t4RCpAN4vmnU
         ciNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788214737; x=1788819537;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XnNt0hP8YJjLsvezbznRGz62Lklpiz7+58ZQDmGUihY=;
        b=Bbo1jiiyLONcxP228uBUcKAcLtWxGIhUXoQRnar3hU+Y6HstUiVqPeWDdPpkQy04h1
         BAWh0v/qtLjlywo7PI3ktqgorml3vnMSn6isdqziDGfS1j3BotxlDrNCe0WLwQ9eTw+g
         5LQELqwe2lpLauonHZ6kq4RGPxXdAECPERxgMjF8YeNhEWC5wWPQ8JklWTudlYDlZcvs
         UEPbeE1EdhhDOuQ1iV1CvhGLyOFL0uJ+WvobUaEDeQHMRGOSvWDMgpLMzhC5r2JM0rtO
         E/M4aNg2Qx70+4w6EpAoflj9QW8nD+CUI1UJWJrlxStHQxDvEZDkkf6RHNeZ7F4k5xru
         tGIA==
X-Forwarded-Encrypted: i=1; AHgh+RqRd4jBTjiTkrS4BM2e991Wsrah2JdqcfKSoat0XoAT238XUZAowVex7Bfz23I2C9jnaBgzO1KufA==@kvack.org
X-Gm-Message-State: AFuF++mS969VlKMT/27WbRaAnVBOlBMObYhT5QSfVltsqTEWdsWS8Uih
	FkDKdHontvNFMSTH0Nbgecygbp84Ya/L6ixl4HJIB5pQwnMA87KbTxvh
X-Gm-Gg: AR+sD115zMGpIP2fXOFJQ5uhbMWS3lFkx7kEA9w9P/NBVM8TW26/y8Xl6c+MvJgf8Bv
	OZdD6vsdDXniurP7CCfIfCWUDwe9DgrQ5uewfHJOTze8cPh7TMG/OJdetXq6ywTDeVIxF5mXeYw
	dlPWH9YLRUrFnv/QPFi7ufAzbDiYDli+l8LCjFV7GTr2mTA8XLtXoa3RtP60v0ztMvpcVSyxlPz
	QgcaxqxUij7a9BOA2AzyapjGrTHjF6jOSiQLjxT7Ijoujjv+BHAeo/2xupMhul3vC9cOhI9A8X4
	TPmMix4BmlnC7tkG7Hs/wxr0uqDiwwQddVhaZvayaaOWNCufHpTrFkSFFvqInfLEuVF8oaOfkgl
	fkEvL6UqN4m2VgV/y/zRflDTsFjut8cnOYD4MgAomejzg71q/6KjNSrF6/mUc8MjPb3PWN4tRd4
	E4xWT8/tMOKvGZYQH0554GgRz8s357ZW4tvfalSXBfP+XXg+1F3rQf/7yCW8+Qd/xOXMU99LSjC
	VGlJuac
X-Received: by 2002:a05:6a20:2586:b0:3d3:b02a:7252 with SMTP id adf61e73a8af0-3d3b02a76a6mr29131323637.28.1788214736859;
        Mon, 31 Aug 2026 15:18:56 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:44::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f7be607sm33073832eec.10.2026.08.31.15.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 15:18:56 -0700 (PDT)
Date: Mon, 31 Aug 2026 15:18:53 -0700
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Viktor Malik <vmalik@redhat.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>, kernel-team@meta.com,
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
	linux-input@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-mm@kvack.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] selftests: shared lib.bpf.mk for building BPF
 progs and skeletons
Message-ID: <apX9zb+3awc99Pfh@devvm16600.scu0.facebook.com>
References: <20260814075054.507089-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260814075054.507089-1-ziyang.meme@gmail.com>
X-Rspam-User: 
X-Stat-Signature: cuorrgqex1ht8kwwk83iuzupu8m7j3ah
X-Rspamd-Queue-Id: 2B614100008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788214737-7107
X-HE-Meta: U2FsdGVkX1+d8UTP2EmKxZ7nz2ZT5ntu4u/4T2rJxZd6yo+l2ERuy3ZIkN/DZbx93vSd9xzGGQ+pLN0yr32KY7RYrKAnvLDkOMHFdBU+hII/kFgxEJ99DPGZ2ssQrOiIhlaSfNk+1bgPo9mucfg9sXr0nhDU3uFgvoL12TtvvuF+kp1AyqkjsHNuiIGwzPoFQ76qOXh6CYc2xNuNJfG6dLcn81DseFQSinqwdA99aiUWTHOFdy7t9SbEnX5gi7zfKjO6G5S+675JhoX/7KIj1EsN+hnyEQYl/YUEPgTB4KglHlswbRAlk2FIWrjecOVvexhyGVxrcbjziXdBvLy2ePZbHhF2+SY2u13sQbRPYEggRotNqR34eEwUxd4rA2g7SxfyWdsvK1apvHRCC0qCYmXpYAFeZweTXQeiv0z1XF0dDcILMPfTeB7KrVU/ghBjm8LwwMeYxrfgWLltmc1qiy6rbnlX0Uft7WpIC30DO89CrQJduAiL+cNjk6YW5NpznwDiO2MSW7Yz4sf2Tz6v/iUHXWYbQc3xmPBatz+sPNt/kB2DplssSrwRTVpVovdg5lrI+KNIOTNTJVZnnFRkMnZhfHJ3qA4fw+3tX4P/4Ipl76x/G8Yy4rkg8GsV9OFvVR2U47kAzHzI6vwF6kapHXUip85lg9PCAptg8YQkgy/08aCpKzGsWkKXD2xOICCZhZI8kbrRuqZIkXBTjwdzUUGt4B4Qn74kV0xtWW+U96AKlazd7wF+PNvaaH1ZM+ciKVralf0JG9HZ5ip+4/lfBWBYIh9ye6nII4+2M8Unhp7qR4HJTke4SDFO7lqCZmmx5BON1EjqVyoQRBA6DY8PRlMm/74j8R0Xpdnu6/DkKcloaYh23c2dEiFHu6JKoHUd9+g1cdjTm46NnnS++8rOjDXlW8MZwysIpAsLkpOYv6usplkc/ZV8SW/JPnABvX3qh57rXYKma05Ac2oKQIc
 GClpr09o
 2sTCqzP+IFSQu/3oHzpYEy8Vg9zJ4TAxBUSItXQ/hiTTQSJXjEp3AIxFNOBpQaeHtXa4eUEUHw9XIjfNoUJWxOgyOtRqzJtJ+0fD4PAUW+B9q6k68cBGOsnWbTxoXprvAISgRmIsiBYYAl3N6UIi4C5SUchsgyi0OMsLXG4FTXcdEssP++J0tFb0yc8fIt78t2J78F9g9DDAY3Z8NMiX+vLAdQno+wPtTDat55XFAH4xvPw3MtCm6fvLHomBJ/M2kpFTJO3aB7206GUwRu4qx+m/rwrKVL9WELoQYIaBQZ81DXhFlnWSV59T0jbJgwIhrSeStDhd1vFfQtgCGk7711S6jzr5JKzG/bwYzk7otMcY/Xdk1ZhRjXLci6Ca1QPdzUqPqDXMtku+i76gieV1YnCadiCeRbcPKA9PGY9g2VKMoJ5GniCLfRWrydJSVNB+98cgCw5AJ092cdC6dVKZ1Iwn/VioGyIKb8wMVBrkAapvD+I624sKvyppWYOxV3tPXsnfddxWDExvZY58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Reviewers,

Just want to follow-up on this patch series. Please let me know the possible
issues and I will fix them.

Thanks very much!

Best,
Ziyang

On Fri, Aug 14, 2026 at 12:50:50AM -0700, Ziyang Men wrote:
>This series re-factors the bpf-related toolchain for selftests, which
>currently duplicated across selftests/{bpf,sched_ext,hid}/. Unify them
>into a single includable fragment, the tools/testing/selftests/lib.bpf.mk,
>and wires up three consumers. We believe this will simplify the work for
>configuring selftests with the bpf, for both the existing and future ones.
>
>Patch 1 adds lib.bpf.mk mentioned above.
>
>Patch 2 adds a new selftest, selftests/cgroup/test_memcg_stat_cross_cpu,
>which checks the cgroup flush happens correctly by comparing the bpf
>read value matches the file reading. Existing test
>bpf/cgroup_iter_memcg only ensures whether the number is non-zero, which
>is trivial in some cases.
>
>Patches 3 and 4 replace the duplicated parts in selftests/{hid,
>sched_ext} with the lib.bpf.mk
>
>===
>Changes since v2:
>For shared Makefile:
>- The lib.bpf.mk now use the USERCFLAGS (and USERLDFLAGS) to extend the
>  CFLAGS and LDFLAGS.
>- OPT_FLAGS/RELEASE and EXTRA_CFLAGS now reach the libbpf and bpftool
>  sub-makes as well.
>- One rule per BPF source instead of a vpath, which is global and also
>  applied to the caller's own %.c rules.
>- HOSTCC/HOSTLD come from lib.mk instead of including Makefile.include,
>  which also rewrote the caller's AR, LD and CFLAGS.
>- A missing vmlinux is reported by the recipe rather than at parse time,
>  so "make clean" still works without BTF.
>
>For cgroup selftest:
>- Only one cgroup tree is created, one flush is performed, follows by
>  bpf read and file read.
>- More common cgroup functions e.g., cg_read_key_long() and
>  value_close(), are used in the selftests.
>- Use cpu_set_t rather than manually allocated cpu lists.
>- Use test_memcontrol.c's anon allocator and moving it into cgroup_util.
>- Other suggestion from the review.
>
>Others:
>- Bot reviews are fixed.
>
>===
>Changes since v1:
>  - Generalized lib.bpf.mk (source layout/suffix, extra hdrs/cflags,
>    skeleton suffix, subskeletons, configurable output dirs) so it can
>    serve hid and sched_ext, not just cgroup.
>  - Added patch 3 (hid) and patch 4 (sched_ext), converting those folders
>    to the shared fragment.
>
>Ziyang Men (4):
>  selftests: add shared lib.bpf.mk to build BPF progs and skeletons
>  selftests/cgroup: add memcg_stat_cross_cpu correctness test for flush
>  selftests/hid: build the BPF program via the shared lib.bpf.mk
>  selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk
>
> tools/testing/selftests/cgroup/.gitignore     |   8 +
> tools/testing/selftests/cgroup/Makefile       |  52 ++
> tools/testing/selftests/cgroup/config         |   5 +
> .../selftests/cgroup/lib/cgroup_util.c        |  83 +++
> .../cgroup/lib/include/cgroup_util.h          |   3 +
> .../cgroup/memcg_stat_cross_cpu.bpf.c         |  86 +++
> .../selftests/cgroup/memcg_stat_cross_cpu.h   |  21 +
> .../cgroup/test_memcg_stat_cross_cpu.c        | 596 ++++++++++++++++++
> .../selftests/cgroup/test_memcontrol.c        |  29 +-
> tools/testing/selftests/hid/.gitignore        |   1 +
> tools/testing/selftests/hid/Makefile          | 180 +-----
> tools/testing/selftests/lib.bpf.mk            | 296 +++++++++
> tools/testing/selftests/sched_ext/Makefile    | 146 +----
> 13 files changed, 1204 insertions(+), 302 deletions(-)
> create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
> create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
> create mode 100644 tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
> create mode 100644 tools/testing/selftests/lib.bpf.mk
>
>-- 
>2.53.0-Meta
>

