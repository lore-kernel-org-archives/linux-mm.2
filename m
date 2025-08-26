Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C07CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE316B00B2; Tue, 26 Aug 2025 15:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69EDC6B00B4; Tue, 26 Aug 2025 15:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565FB6B00B6; Tue, 26 Aug 2025 15:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1436B00B2
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:52:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3964C02E8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:52:44 +0000 (UTC)
X-FDA: 83819956248.30.CD89A70
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2A97B8000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:52:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c3NLycmR;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756237963; a=rsa-sha256;
	cv=none;
	b=HNShu3nKyktcst84dCp6k63HacDK2wGCHWKKwoooUFI38eJSkgqsdbH2xtpUtaeU3eFFZ1
	79rCGpVGilvdvHGomisfAejOOeH2yNppZyl92DckPGiic8CPWHWXmu4GMgZlRI3lndOeRz
	krT1SqSo2BNPqrZkk6dCdKx8KDbOk1M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c3NLycmR;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756237963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xNfnVWa15IEo+y71/LS/lH1aYZQU8wdphHh7wA+oWY=;
	b=f/Wj7YH3zVYtvM8dloO7FRbUtzUPGcCieiZgYpq/fW0y2sOfhN03o/S2YFRXaaPkFDI/f2
	/Sve+R5e0tLwE6D8JC/eV2kCq6OPGPtyHuQY269+i7Gal/E50GkOQ6H2ZA+lzs3emfVA41
	6Q5dGNFHqo4xERrbNT0gxdW+g7GjvLQ=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3c79f0a606eso1934357f8f.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756237961; x=1756842761; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xNfnVWa15IEo+y71/LS/lH1aYZQU8wdphHh7wA+oWY=;
        b=c3NLycmR08ci01c/i9VD0GGIGrIfNVF54IUrHGeA0jjoH9YLBLnzpdo43RVJEDU5bB
         AGXvY+jfIIRJw1t8DyUmEW/ZrHEFP/NskcW7S3NXxhnKWJm88Zc2LP6WJ1JgFON+0Iqd
         7RgDdvGb4rpYTyWVNKUCKucoC1slNVXuju5EZlqnUuxITfynTw6LRsVxnoK2ion0yBDN
         5z104arypdq/F9EZAkmgCsgUEuz47lFe9SAhysL9hPXWnGL6/m7dXYL4Zvm2e4KfOwVb
         vwbg3H9UjhTIVyE8t0ZlmCusRDWcJIFC5ESFwEhsbWT+mA/APnDuKStUKByNIbMom8/O
         TFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756237961; x=1756842761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8xNfnVWa15IEo+y71/LS/lH1aYZQU8wdphHh7wA+oWY=;
        b=reDcTQNmpxFA9JHELRpGbwzjL2y/yu1Zjgughl9fHqSprsW9sYkY4TaL5+hSuY/gtX
         YBZ1681/03zTZrG3lve5G9EzATw6BzJdtZ1LtSh71vSzrve9M9HAqYoXl/rq3JyEGqSh
         XGIJ9vSqq2ZDAwcyu54Fkh/b1ejURTo8fFUEiu0pNwe2HTpnAupmx4KM+gWuBfF938N/
         vcASsTB1WB+95NbZhJm42FVWkud6EAaPIL5/7SHcoibK8vdMhVLuIstKiQ3p7MwABxqP
         v5fpaqMPQ9iNL7bPrkJ0f/Cl5obvYN8xU3QhDTj05xc8SeCGCJO3n2j3OJD29FSziuSU
         kWEA==
X-Forwarded-Encrypted: i=1; AJvYcCWP0hLlivGcwb/6IS6L+Wt2y17BcGLzH8MMIW3kz9w6nFvlywDZIIUF66axG6DNoInvIdGfsCABWA==@kvack.org
X-Gm-Message-State: AOJu0YxfNl/u8hiLXKu4QxglbirdXP9zrpzkRBKVtBAQdffjmzS0l9+v
	MPqgGwQgNQFhS5IK88fhiwBKLjROzn5KNBjh02tEw/FTF8Z0mYM0F2uSo+CfAM5kUGw/cnCXd58
	tKB+Crpnpe2T2EDHC6xeysn9k91oNH+o=
X-Gm-Gg: ASbGncuMUqox9ANwn/fL80yMbJkVXdPFcfIhxut8wr+9uq2EGlz6dtA0zhFapaCid6p
	pSh6acQRaC20KKCM0wxNp4NEiUEmxo/fqZ4KBbwjB6vOmcuWIl1NV7/LsJHOLuq4xeIKHt1FzVi
	esWcnxmHl6mvls46875K6muNI2Qj7dJ2zTykYEfPKpmbwqPN4UQVMqFIQMdKWS+U20Sqv2YjJEr
	q0Kc2Tga9GlqDWEAspURoQ=
X-Google-Smtp-Source: AGHT+IGmuSpAD3N3mNAU4uPd+DRtEmtzzaukKr+JC/PFH8Ep0Z9ZfoBB7e7a4HlGDhBtHWFlH347rRTlNmo/mHWiMs8=
X-Received: by 2002:a05:6000:2512:b0:3c9:3f46:70eb with SMTP id
 ffacd0b85a97d-3c93f467c6amr6314621f8f.52.1756237959412; Tue, 26 Aug 2025
 12:52:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev> <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev> <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
In-Reply-To: <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 26 Aug 2025 12:52:26 -0700
X-Gm-Features: Ac12FXwmuWoZhQRGLxuvmxfQXSnKF0Y5ZCZIg16zEhIvZSweZikVlXHfRgk_L-0
Message-ID: <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A97B8000B
X-Stat-Signature: tqbcofp53jncgszg9seimd89knhwkuka
X-Rspam-User: 
X-HE-Tag: 1756237962-929440
X-HE-Meta: U2FsdGVkX19ZPcpyHAV7LzsTsfOnOlnsMIlqFbKlnh98QsiGlqTkT9/DU2bVIWcMBUlJT+RWQVzI58rdmXvV9Eh0GWrvrxjnlkfpuoL9crCC/Unf/4w7In0wR7M5bH/DeuyPl7PUMy4xkyKMRHDRpSiWhF4Auur6QZrKugA4vyOODd0HPxOBMliL+egRd2Gu7PQTWO7LLzvgWxjDWPS7ohNDl3WpyCffwWM5kRBkMUIFrBIY+AZbZLNUkinoT/MBCkhmNbvBjLukPwpTrUqfJZQoB8sYqIG2IFceiATRH+RLNfjE9A6+vucu3ugfRMKebPjxZB07QRNBrnb9XMYSR6Pbya40XTYyfWWxEHADuJYSqUSTmDfaWeUHrCOJFXZlohhpFZ6n1uPdjC+8yG/BXCitalhrMcIT54H3MwFHmuYQOyzCU/0U0ctOgQKYpieVg9kDWMIS+kGnIR/RSU2t5Us3hTb6YE0P2xq8mkwSvNKiNwcRqSTMWkZQG5uvZ75EUDC6YIQ5hRwyePjvEZ+sEfsqrM4nxzT7JEoxjrkrJP5FljM2AGf3bNKM3t8N9FLCKH6JG/AKg4jBH30RG+g5W2tCwsVtm+oWY+z3r9P45bvpJyb4IoWAqfAZsZ2JmVI3ggV2vksvgJRGFnn33JMAL3opY/GmzbR8j3fpB5xZPMjDwgwjBGrLKbrPzw+fkCtFaJKOvxojooAnMcf7Dn6M/h0b28z8nzHFeEv67CGyo+B3kiAAsRjSt+2wihvOafQ4lRq4Wm8gguTfl+nlQiArjS6Q4xHK/KtrV4ECi9XZU0fWFU9BtPgd/okX5EnK1E/lQ6J5SND60GA3stux68pw37knCLuocgyN/YyVPUH41OKIogOtCwqIIbDhLfp+PuGxgT5bZM3vBuPQGIRJ/UNtOfyEl8dcXfpnLDPmNnG9XNddQJyLTO/16stBx4vtUJ7btbWaWWvsDoKob5zhx6X
 S9f0wQ3B
 YhXrtzQ/Wws2tKCE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 11:01=E2=80=AFAM Martin KaFai Lau <martin.lau@linux=
.dev> wrote:
>
> On 8/25/25 10:00 AM, Roman Gushchin wrote:
> > Martin KaFai Lau <martin.lau@linux.dev> writes:
> >
> >> On 8/20/25 5:24 PM, Roman Gushchin wrote:
> >>>> How is it decided who gets to run before the other? Is it based on
> >>>> order of attachment (which can be non-deterministic)?
> >>> Yeah, now it's the order of attachment.
> >>>
> >>>> There was a lot of discussion on something similar for tc progs, and
> >>>> we went with specific flags that capture partial ordering constraint=
s
> >>>> (instead of priorities that may collide).
> >>>> https://lore.kernel.org/all/20230719140858.13224-2-daniel@iogearbox.=
net
> >>>> It would be nice if we can find a way of making this consistent.
> >>
> >> +1
> >>
> >> The cgroup bpf prog has recently added the mprog api support also. If
> >> the simple order of attachment is not enough and needs to have
> >> specific ordering, we should make the bpf struct_ops support the same
> >> mprog api instead of asking each subsystem creating its own.
> >>
> >> fyi, another need for struct_ops ordering is to upgrade the
> >> BPF_PROG_TYPE_SOCK_OPS api to struct_ops for easier extension in the
> >> future. Slide 13 in
> >> https://drive.google.com/file/d/1wjKZth6T0llLJ_ONPAL_6Q_jbxbAjByp/view
> >
> > Does it mean it's better now to keep it simple in the context of oom
> > patches with the plan to later reuse the generic struct_ops
> > infrastructure?
> >
> > Honestly, I believe that the simple order of attachment should be
> > good enough for quite a while, so I'd not over-complicate this,
> > unless it's not fixable later.
>
> I think the simple attachment ordering is fine. Presumably the current li=
nk list
> in patch 1 can be replaced by the mprog in the future. Other experts can =
chime
> in if I have missed things.

I don't think the proposed approach of:
list_for_each_entry_srcu(bpf_oom, &bpf_oom_handlers, node, false) {
is extensible without breaking things.
Sooner or later people will want bpf-oom handlers to be per
container, so we have to think upfront how to do it.
I would start with one bpf-oom prog per memcg and extend with mprog later.
Effectively placing 'struct bpf_oom_ops *' into oc->memcg,
and having one global bpf_oom_ops when oc->memcg =3D=3D NULL.
I'm sure other designs are possible, but lets make sure container scope
is designed from the beginning.
mprog-like multi prog behavior per container can be added later.

