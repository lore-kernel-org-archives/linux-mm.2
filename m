Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546CFC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD106B007B; Mon,  3 Aug 2026 20:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD556B0088; Mon,  3 Aug 2026 20:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E8F6B008A; Mon,  3 Aug 2026 20:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D02D06B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:30:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A90F9C086A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:30:14 +0000 (UTC)
X-FDA: 85061705148.24.15CF2B8
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id B166920011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:30:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tzoHR0mn;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785803412;
	b=a3Mn7AV4AmA6ALCWNQ/qCQLrIQf4jtuhKClDQtttaJNqqIV5fs5PnCvMbzvjE/ItavROOE
	rAb/TiJzjTYq1E9dl4e9IwH0LVRhUiZgPcoYbPVVPga/9yxNhjW1YYo4QfyV722KcGYlh0
	JDgVpdEIY9CtMBe3Y7wBojxPgpOh7Y4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tzoHR0mn;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785803412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRnJbvJF7b7ctthMpHHeJt6vmkfGn1MSaF5k0E7zTb0=;
	b=8OvVXhRH/RuJXxQau1Yw5kf4RO/Zb7smX3ZFUNFRKmzHUiIoe5topoosmm10BBJx9yRRFp
	zeYkw+LChA8Y+RBPJCZKBp+eAFZdQ904Xu4nCiDFE8eYHP6tKIjZXfx+aLfTG2Qx3ABHHs
	N7NX3dCY07ZsoMp+6fwRLB/28ijS5uc=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c01c79467so133551cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 17:30:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785803412; cv=none;
        d=google.com; s=arc-20260327;
        b=hSsQAhcFT7YY1rHhMMA2m2obwXXSJFzMUA+uVk49A36+ME+3bE/zslxHRAs6Rj18xY
         L9SKtxx0L3ftMrZxjBi/k53sW1qdsNTr0ajCOuA4ru4WZQGWTZHDJMfm0wPrdMLE0pgf
         4CfVsSMymmJWFG/cIM6CY7oUxqrcNnQ5byeFYxbs5hnlz2ebG6KIGBKbsEYt3ahchtzq
         tgPSeKtD8IiEKLDVfxRzhMaZej+ztx8/F/AL2hdqBXG4kiFU+zrhB/n0F6wZrr512QPK
         RIIC6yaoqYTCMD/s22u5vdwncWa0i8ESuLN+7S2UgtmISafVodLfEwwrVCHtbVN4eMbk
         F7aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aRnJbvJF7b7ctthMpHHeJt6vmkfGn1MSaF5k0E7zTb0=;
        fh=lcECzixYUxJrRXs42D0haeEuDEngN7GscKFGtYCIg2E=;
        b=EyHhFPcHEbOg4LNi+6ft6QJjed9awh8gKPJ0RbMbwPf77q7c4IUbVJNc+baIWrtBfA
         yTO8ZcTLDi3i0ddwp1LlQE0eC+p5JEt8/NgcwDufmZ7ClYs1RmlywG0fJcaGx3stdBE9
         dhJoMdT53Ndl5n+MiTkXLHLp3miC6y0seVq9ca66SSDfUa0UKwdo0rrEIBa4skWa767/
         iAvTxe7bq/bSjJYSHKoz/FK+aBDR7EPCtylwK6gZvJPmP3njcu5qFfSNY1yq+Iz7jJKP
         0p/rlHzrGr9zzIWi/8y4X5CjOzoki7coW1XhWWFUqNNnEQADy7bGToT7cb4H9tCSBke6
         8GKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785803412; x=1786408212; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aRnJbvJF7b7ctthMpHHeJt6vmkfGn1MSaF5k0E7zTb0=;
        b=tzoHR0mnbxchPJAqgLxY8GO2I8DqXEpnUIDZEoNP1fzsDDvFjfiAYbZDE7feR3Sc7P
         fmUuYXhewBSQau/ySCcavca1xWGtWFuWlXHV1kFMF0elYI5JotE1qelu+aCGSXUnYkfj
         gusJB9NTw/R3DTibyAaLxrtMNiCgKhkKMuxi3wlj+QpHv1gzQuQ5VUsEEIgCC8j7FK8g
         LbZBbIveg7HMsY3GLmoZa+d4qwIXdrrzgD3IfsHLNK8GqiSXs6ZvmxXb61Begayiu/bb
         gmz9x87GrjU/ztaF1SgfDlVDoZCBLH5Zrx6rgWxRvCXcWe+SZxoQLRdJqVwK0X2xF+Av
         ++eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785803412; x=1786408212;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aRnJbvJF7b7ctthMpHHeJt6vmkfGn1MSaF5k0E7zTb0=;
        b=TG/vooT5x0W2vS0NNklZ3SO7U9wEPRLzYwgwBmeuLH75S1vz4Uu36O5kUV+iYzGpmG
         3eP/aMB1qbliyipcZF4AshdWn/QdajgaFQTDkFp2CFBY3ZCoTgwjE7I6tz+PNl4U39wM
         FIpj9czhlsavyEKtQkJsaFID7YMkl+DoMegfxi1XQ54fdHnwOBaWdrFcv4Mtl2LZEppv
         QMkf2f/WmalcNUHXrzwU0QiSHUrn4qP09jk+lG0xjEuL5N3rLmLn33Fr+pyxXx/7Yj0C
         erVcwVxKPWCRSEfEheEzvOzFkmM3Tbf0i08WYhFUMXfmthk/7P7HCBJNtTdrojFFbYGW
         gRqg==
X-Forwarded-Encrypted: i=1; AHgh+RoOZ1A5A/AQi2XvFgB93k0S03/DNJKYyIHaC7qFUVQXx3LTX/z5Zh/HfdWLUsrL/TPvF3a7ppRsjQ==@kvack.org
X-Gm-Message-State: AOJu0Ywa10dIUn/4e46YHgObfBstF46A17NqlLI1Dl0FNNU3PTPRU4Vu
	SX8X1lcQ/9lrWnUft4odr7VHzNuBZ4el07NR5nzDi+5IA3sHTEp5BE/1OFwDt8QKYN8TKiLIzOW
	Q/AGCrqfHw/NgFQsydX7aX3j2NLNdyhYrX+KIIhva
X-Gm-Gg: AR+sD10QsexxfwXyRw3AgYF6wNmHug+tlK8eHq+axeRcYXamO/BSVllM+IwZ6NoqOz4
	Dt3ollRqQD5HbrAO8mr1/gwatH09vU4Se9yfUG2yojMb1JGfD5Z+e89Gs2BQ9L0jP+7fOwPdB6/
	guqqDL0Wy7nN6b3gV1egpXTpC/AWr6/3xh5aeFJ4b1/qJNoF9RMW9pNolGca0pm/MJCvTilTzTg
	A++YAVcFrSYHiExbO1ocHbgP3SjsDzCX+LcxPqiQwjGC4lUAHiCcEP0P4sfGj3v5ZlAydcCESgM
	Pe00n5Wqh0WDe+aEowA7KTllsIvWGOcfNy8ZNG9kjt8=
X-Received: by 2002:ac8:6f1b:0:b0:52c:d3a1:358a with SMTP id
 d75a77b69052e-52cd4fc8ac0mr6861461cf.14.1785803411052; Mon, 03 Aug 2026
 17:30:11 -0700 (PDT)
MIME-Version: 1.0
References: <d635115cfafcd35c8e3344b418acb1020aba1052.1785794035.git.abhishekbapat@google.com>
In-Reply-To: <d635115cfafcd35c8e3344b418acb1020aba1052.1785794035.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 17:30:00 -0700
X-Gm-Features: AUfX_mzJ7vIskMKOWg3ju80qsSVBzbe0PKGqEXcRxfX1OauzzIWTM3-ClPE7tI0
Message-ID: <CAJuCfpGA7F80yW1=bSXsZre4=Tx=peqNbkWvKF0up8xJdSvrgA@mail.gmail.com>
Subject: Re: [PATCH v3] alloc_tag: expose profiling and compression states
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Ge <hao.ge@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: kmmk9xmz5p96crph4e4asbjxynhnwntf
X-Rspamd-Queue-Id: B166920011
X-Rspamd-Server: rspam08
X-HE-Tag: 1785803412-340197
X-HE-Meta: U2FsdGVkX19Y5r3LgF+7gUP7maKUiRlWXZWKeacjIyPmdwagubVVT2E6mO+Cdl7MVRhYGj2oQHKQJcyj5p+ylQi4T4PQgJhqtkWJ7zVvd6Nm7kBrbJwN2mYXD4NmXgUGs3Rr0P3dEaxPiUNhctCWVbl8WuLEbzV6Gh7B20JeZKPgTlYr2TcLDyNVxBmZwYc9vb9qTLNcw9nNm2UQrst8aqVwrtVmjCiuv+6fHrKnvu93+u+hjmemOoU+7kG0cYlqwKR/6MqGCfN12f8q9Zag8CmBBxP0z6K7bcxIVhM/mMRBohRu1s/cvil0lrrgifnGh5SOMZmHrcaxcvxt0u1VxwFFMsTaBLbiyVpmqFD1ZL21MuZj4dA5xHnI6ArLvDnJFkCG8I3C1q/eF4wADCJDfjbBnkODrvTNkY0wLX9ZbcDAz7gmpGm4Y6BwkiNCLWJfvh3pcX1pUIKVD+Q9BQ44FiE8C9IuZElw6EP81lUZTQPN3TV9nQUWE/U9kUhDjJ+6HBPlOCf7Xm3ch4Oh7JoBKYhzmIUmNCBjFqN1AQqpEK0NeRACd5d9nkrDCPrsaB9INErPguBsfO5TrCqE4yvdrLsEJHGArmoeW1MgWaH1H0LmZROswcIXEQX/0ftcRW3hM1iFd4PSoq2s6LHT4Z36ZSHl6oNOv5Ncjd8CCuIWDOjhMieMwpu7h/ME61oKK8tsuVZjbCVCEhaemMEVQxoGF++k3S2pmrHg895b1YvYfC+icobnbrDaBq2CF89ovOODHMimnvlgphobaHKpMcerdkpwZbxEbIA5nvP38DkS3nN9Ba5Jfks5gDggu1kDPzMPA27HWJlDfN/NngeWJcWb25Gsf7VP+VgZVA2SNolIWW4xJ9yv8EZw60Mydai97pg9V572MKssQwEfWgYLVRfH01E+fgUxO+YQEvfHN8TJHFC+d6crU6ANiuP7GEZdTIpU/fNxZ9m3/94k1M8a1ST
 cDb7V3/0
 35ABuHwIAA5WIEgEMewdS62qnp/d3XTYwXZ5uZha5n+Pq1O9YImaXSiJGm39GqM82y8H4+Ah5sSIQlprJ6mjTwppIVdLRFr7hbI+C3K+7CFBkwTAcleobYlEx+b5go2o0c6eMv7/Zo0NR0sobr5I3vlYIrZWSh9FjkLx3jJfpYJ70IUhV3HrptCM1YEB/amKhVSq7Jy/SbJ4CJ47iL02UlfBOrSl9Y++QGLqfC/wg872TPumf6YJz0T5M+jz8g3YfNiuiIebwp14YkYYWdgzcaXD6jXpNPTQYFXnD5I1dR7RtWZW+1djFN4NblQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 2:54=E2=80=AFPM Abhishek Bapat <abhishekbapat@google=
.com> wrote:
>
> Currently, userspace has limited visibility into the exact active
> runtime state of memory allocation profiling and its page extension
> compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
>
> While reading the sysctl provides basic on/off status, it is currently
> impossible for userspace to natively determine whether page-tag
> compression was successfully enabled without scraping dmesg boot logs.
>
> Resolve this ambiguity by exposing the active compression state by
> adding a new read-only sysctl `vm.mem_profiling_compressed` to output the

"Resolve this ambiguity by exposing the active compression state by
adding a new read-only sysctl" sounds too elaborate. This also
conflicts with the documentation you added which states
"`mem_profiling_compressed` represents the state configured at boot
time", so your description of it representing "the active compression
state" is incorrect.
How about: "Add a new read-only sysctl representing how compression
was configured at boot time."?

> state.
>
> v3 change:
> - Added documentation about the behaviour details of the new sysctl.
>
> v2 change:
> - Moved from displaying the state in /proc/allocinfo to a new read-only
> sysctl.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>  Documentation/mm/allocation-profiling.rst | 13 +++++++++++++
>  mm/alloc_tag.c                            |  6 ++++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm=
/allocation-profiling.rst
> index c3a28467955f..3ad1e9aacb9a 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -43,6 +43,19 @@ sysctl:
>    warnings produced by allocations made while profiling is disabled and =
freed
>    when it's enabled.
>
> +  /proc/sys/vm/mem_profiling_compressed
> +
> +  1: Page extension compression is enabled.

We are not compressing page extensions but rather page allocation
tags, so "Page extension compression" is misleading. I think "Page
allocation tag compression is enabled." would be better.

> +
> +  0: Page extension compression is disabled.
> +
> +  This control is read-only and reflects the compression status initiali=
zed at boot.
> +  Note that, unlike `mem_profiling`, which represents the current state =
of profiling,
> +  `mem_profiling_compressed` represents the state configured at boot tim=
e. Turning off
> +  profiling at runtime will implicitly make this sysctl effectively dorm=
ant. However, if
> +  profiling is toggled off and then toggled on again, it will resume wit=
h compression
> +  still enabled as long as the value of `mem_profiling_compressed` is 1.
> +
>  Runtime info:
>    /proc/allocinfo
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 52aece27b00e..877068241f06 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_pr=
ofiling_sysctls[] =3D {
>                 .mode           =3D 0644,
>                 .proc_handler   =3D proc_mem_profiling_handler,
>         },
> +       {
> +               .procname       =3D "mem_profiling_compressed",
> +               .data           =3D &mem_profiling_compressed,
> +               .mode           =3D 0444,
> +               .proc_handler   =3D proc_do_static_key,
> +       },
>  };
>
>  static void __init sysctl_init(void)
>
> base-commit: 94f9b3980dd446b56acf1dfed649e9b32a9f3813
> --
> 2.55.0.508.g3f0d502094-goog
>

