Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA55C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AA06B007B; Fri, 25 Jul 2025 14:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA2A6B0089; Fri, 25 Jul 2025 14:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8CD6B008A; Fri, 25 Jul 2025 14:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC346B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:51:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F45CBBA95
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:51:12 +0000 (UTC)
X-FDA: 83703679584.19.58A425E
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F69B1A000E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:51:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pfFccoEk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753469470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZ6hAPUzBtzPSujGKOEvPiaHOeXzLH+v0q9XD3SFU4w=;
	b=LfbybEKE4+SfaitixxIYOpqmA53YdqCyjpcYc069BboXcVOQe7BsuHdyTL8Q055uU7zZmx
	B2Ggobr8uqF13kNLpo4jlo4PLRUEOrSOCZ66LEvGJiEgtoeWgeO1P8NqhAMEgGbzNcSEmU
	j0hgo6ZNP4Q6guOOkMGF+nQSytCftiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753469470; a=rsa-sha256;
	cv=none;
	b=tzLlgdJUl9JnUJ96k4f43yQIPobjfToNJ7AriyGg+NkMFS6BJTVimrwQRtTeqYH3sF71wN
	LYIMkmFlBzTIpDDfSSh63rCbGfdrAbyeGT3OpqTTUcEZPqFhtNzt35s9rtAiq4Uf4ee4qz
	uz0J6aXwdtr0jfDXEYig1xSWgJbGeHg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pfFccoEk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=kuniyu@google.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-31c4a546cc2so2035669a91.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753469469; x=1754074269; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZ6hAPUzBtzPSujGKOEvPiaHOeXzLH+v0q9XD3SFU4w=;
        b=pfFccoEkwZijTDB79h3lv+KV63wlirUs53313EMEbDgc/iZxBsiqpFWxZwgcD+yiLl
         B5wbGEoHTeyr/6TK2Zm+eYBy91kjvm6NQjEthEyAdHGmw5DC1RPX3nHxUhfr2JVyqHvc
         Xu15r99YkRD/RAAvyuzgXqpu9KkSXu3NwjZveeH01Mte6qwXYVjHpddvexyJygCtEIMP
         aj2owVUCf9dVi0LTQTlSYsTfzdshaOs0VcoUhg5JytzxE7XD6SQF5ihhgnfQ8jk+JDoZ
         5W+6zsvQ8drMc4F6j3ZZG5URFpo9laQCC2zcJ6E6Jjonwh2RT7vwIUghbzfjvIwRAAeD
         tY0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753469469; x=1754074269;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GZ6hAPUzBtzPSujGKOEvPiaHOeXzLH+v0q9XD3SFU4w=;
        b=jnOVyUl83usLjMfwZ3gSGBqOxHVTc5+3LXTGCjuYNTHXsNtE7FPaJUQgw2Msbmwzx6
         whE5ElDViqIk3HfpAR1hcmGJr5UcSP34jbSkbUNiRlob419GJyNI50GEnOu4IDtlZRwn
         QjTCgW3sLIpqRla7xQXomJqzV440qTKdOdOhKxrWRuU+4xfqiCsirt8fHJ2FC/5GIrt8
         0Gpx0oGvF1/Qq/zCgmOGN5KeRhQucCWZIuTX1Py0wNodLVmNwluthx3TZ0FwqQe/EHec
         vOorzBD7Yrq2Cv5lHsyDBReQwJRpqmukYQLhEMmB6IiAZ9Wu/EbrqFOi6jvekSBHzdWP
         3v2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUbLQk+RoLZ9LfETd3kms5VVR8ZuFu0aLfgS2CmEB/0+BtOdo5BagRPE9BaX2yccZoC1R08LlE4mA==@kvack.org
X-Gm-Message-State: AOJu0YyrcE8OY+bbhruPEgByQuxgnVSGqGkjwmLArksV8mlpcYFdGMWb
	mN2Pgyyavhcky5G/XMuOJ+nDuFiT2zKbPJ1CL7CUSTkKvlhUTJd2mQvu6HOtLlJoPQ0GcPG2IW6
	30nDgV54M4rjy9jzM0OtUgtt72cp3LAJBfaD8GNKg
X-Gm-Gg: ASbGncvwuAcqxVzjy8CZ8fZyRPwK7eyvl03r1aBqe6Pjtr46iwE2hWrods4E3Mq2feP
	KQLi0omBQCPODtJCaJsoCGcBYOPAI6dW39ucecOCRAVt+qy+GjZU/Xix3kVL0dGtJs5vBbZFAE2
	TYiiDDptfqM6BN2LsB8PLeJCFjGnJBgdqjuXbMKUIwSgidzw+5DTFPc7R7oUbS+eW1cW6HOvdeh
	kA6IQM6bJAPLjipYCk+ZzKXLQ5J4jnzvugFN7N8Bt8rQuqq/mM=
X-Google-Smtp-Source: AGHT+IFEO1MlBFe5fjVyy37Qgo8ReyTHSJ+VMkvacLifnhThyPfeUMVv64i2gb7SZvTFd27/Wgo6PmPyxhgCmiXTHZ4=
X-Received: by 2002:a17:90b:4ac5:b0:315:cc22:68d9 with SMTP id
 98e67ed59e1d1-31e77a4af86mr3944453a91.31.1753469468550; Fri, 25 Jul 2025
 11:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
 <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
 <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
 <p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
 <CAAVpQUAk4F__D7xdWpt0SEE4WEM_-6V1P7DUw9TGaV=pxZ+tgw@mail.gmail.com>
 <xjtbk6g2a3x26sqqrdxbm2vxgxmm3nfaryxlxwipwohsscg7qg@64ueif57zont>
 <CAAVpQUAL09OGKZmf3HkjqqkknaytQ59EXozAVqJuwOZZucLR0Q@mail.gmail.com>
 <jmbszz4m7xkw7fzolpusjesbreaczmr4i64kynbs3zcoehrkpj@lwso5soc4dh3>
 <CAAVpQUCv+CpKkX9Ryxa5ATG3CC0TGGE4EFeGt4Xnu+0kV7TMZg@mail.gmail.com>
 <e6qunyonbd4yxgf3g7gyc4435ueez6ledshde6lfdq7j5nslsh@xl7mcmaczfmk>
 <CAAVpQUDMj_1p6sVeo=bZ_u34HSX7V3WM6hYG3wHyyCACKrTKmQ@mail.gmail.com> <20250724184902.139eff3c@kernel.org>
In-Reply-To: <20250724184902.139eff3c@kernel.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Fri, 25 Jul 2025 11:50:57 -0700
X-Gm-Features: Ac12FXzjvKxZZ0TfulEtz2NxOb7G3ZS4IGZwElHwLN2QtXZe6QR7perh8RBHOCY
Message-ID: <CAAVpQUD36Wq7xcmdpeqCb3qpTzR7ZUDa=U4rUrfy7+JiE47Rsg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
To: Jakub Kicinski <kuba@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Eric Dumazet <edumazet@google.com>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Neal Cardwell <ncardwell@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2F69B1A000E
X-Stat-Signature: pfbrqfg4kzfy18kkzashszznboy8hczh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753469470-440629
X-HE-Meta: U2FsdGVkX1/HcHyrknpJqSAXSsqAOZrFeXuosqE6uqT+k0HuF3faaspXyYi+/FTuqoDYuu9cgdgbMM7Cbw3YLKZsD5LaU+y6PUuKKCi501oz7I4V1ELHFQoKYMXnK+AOcX+7O8yKIMW0njiWTIA2TM2tRVBE33p7qQVN3ZNl6j1E8lB0p1z7R1ksJuIaWPP3pcQgN/DckK2vYMxzS5NQObPrnq6s9EuCUor4aK/aS+vEjWUJmlZ3As3Ee4X1/QUxyPxu/ijAwSJlIrv1O7ow0yTp3INlDX67SYkHLs0IuNZjiPAUGM8u8NXz/92tr1sgP3Lde09klFxveTV4KrON+IAJMqfFmg3piaAWRPePN+VImdzb1ngoEhdr3TEFQkULDgXrlUO4bSRgVJmiN9Len3EkmdxTURXg0h7v7DbGzZyqu/JW02fJxWxxSyKY0EuxxbVmHL0MYnRVlHcNcXXHBE3RJgnPseBC0r9neLBI5NS6H7D7Lp4ScFkjYaUrc/S4/7vQoTaYx+Q//HyXkyNWq0jXxj2Y4qV61IfqHOYmp8/43FgxeJWE0Vk0Yq/DBNpXhLoO1YQ6t24DOlY9fMTPkwGprh9WWKmAhXMR8xYXO3YHMQup2fv0lHY/VKPH6p9j3sCwivdEzwSyq3m09s7ia+NLuE1NI4qK7ZvkFm1OX7/960szY37MnwO9tlaoLooQLgwW4xaFvsVfCcy0V6AnXirori46hfnJRELDVm7W0B3EV3tQYHcTpuaHUqTTTXflz75zbBAtB/IR6WmRNcb6jNssdtW0KwMROxFQE5Q6xpywfpfBf7n+hiK35fO1FIVDKe6I0FBC2JC4/qD6A2BjHWygM8vsuh18smFFHX6SGziJTUTuM37OaSQWuD/5OrFO5JowTBagoJN+8c+Sp/wAnxsN84mOGWR+2KmmhirCdVI2wMbghJQD18CUrNxFI/RuKvpStRNLu6mkOfq+s9I
 e/TpfEHw
 4IWUCnruLfDFyvB8f2F9BPdTeEAqrSWw3jjvJWszIeifW83Wx8JzbePhuMNqXqb5d7i2PS6i+t7ZF40+cgnVGNdF6tOwA7O/JFbDCKQikllHKATCiLBYosAOk8uIR/P9OApSIzwA2NrwPhgg7IJsTgGsypolCPNt5HUzTzlnV4FDG0JDCqeecYuHf318qVFaD4Gp8R7twYYyVojoelzv4hYFZQLmDA1PDsbT2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 6:49=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 23 Jul 2025 11:06:14 -0700 Kuniyuki Iwashima wrote:
> > > 3. Will there ever be a reasonable use-case where there is non-isolat=
ed
> > >    sub-tree under an isolated ancestor?
> >
> > I think no, but again, we need to think about the scenario above,
> > otherwise, your ideal semantics is just broken.
> >
> > Also, "no reasonable scenario" does not always mean "we must
> > prevent the scenario".
> >
> > If there's nothing harmful, we can just let it be, especially if such
> > restriction gives nothing andrather hurts performance with no
> > good reason.
>
> Stating the obvious perhaps but it's probably too late in the release
> cycle to get enough agreement here to merge the series. So I'll mark
> it as Deferred.

Fair enough.

>
> While I'm typing, TBH I'm not sure I'm following the arguments about
> making the property hierarchical. Since the memory limit gets inherited
> I don't understand why the property of being isolated would not.
> Either I don't understand the memcg enough, or I don't understand your
> intended semantics. Anyway..

Inheriting a config is easy, but keeping the hierarchy complete isn't,
or maybe I'm thinking too hard :S

[root@fedora ~]# mkdir /sys/fs/cgroup/test1
[root@fedora ~]# mkdir /sys/fs/cgroup/test1/test2
[root@fedora ~]# echo +memory > /sys/fs/cgroup/test1/cgroup.subtree_control
[root@fedora ~]# echo 10000 > /sys/fs/cgroup/test1/test2/memory.max
[root@fedora ~]# echo 1000 > /sys/fs/cgroup/test1/memory.max
[  108.130895] bash invoked oom-killer: gfp_mask=3D0xcc0(GFP_KERNEL),
order=3D0, oom_score_adj=3D0
...
[  108.260164] Out of memory and no killable processes...
[root@fedora ~]# cat /sys/fs/cgroup/test1/test2/memory.max
8192
[root@fedora ~]# cat /sys/fs/cgroup/test1/memory.max
0

