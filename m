Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8E1D29FF8
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984B96B00B2; Wed, 14 Jan 2026 07:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933086B00B6; Wed, 14 Jan 2026 07:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807916B00B8; Wed, 14 Jan 2026 07:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4B76B00B2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:14:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2043B13B188
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:14:24 +0000 (UTC)
X-FDA: 84330462048.07.008A49B
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5200040003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:14:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HgzlOpou;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768392862; a=rsa-sha256;
	cv=none;
	b=0706uHL5hfmG9jWZ9aAwyVCFi7kflSepA9Sq4KNzxTCf1kRZ1eeEpjRoXOPLumiwAV5VPx
	KHBeuaa1JnSOkITjVM4gUm+E14mTir02TIJicd5QOQblGlSdm8B6EBiLfda/gmjb6+G8B/
	K4ozYQtj1jEviYjuQWyw4X4CoR960Sc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HgzlOpou;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768392862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpgn9moKDBgyCKhNw842q28BORTy5OVetihmiI3/j9Q=;
	b=nNNd3MIvhCobXxwCXkcJT6J6q/6kv4FXaxPF+kBMGJxMBilU1mKcNXfmTLGE9IEo5GLMy0
	EMZMmy6zWhP7yexbUFMkyP8zNTbSP/yDD1FTdOECynpKGNJF9Nu/T1TDHVu2y0Gl5wxGRX
	flonUsf5kt2p7Q1k+Xt3rBuVUuDlxlk=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78fb9a67b06so69174007b3.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768392861; x=1768997661; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vpgn9moKDBgyCKhNw842q28BORTy5OVetihmiI3/j9Q=;
        b=HgzlOpouMyEHhZKwqfWZK6XWpiHPC/w0vGsH26hmgi8IO1UjNR/K6yKkx9z/JYr6Oj
         RQtY9vk6/qm3UhvqprvLHfN6xQ3nsML1A+CKgqDET+X/cL6gBp0xrUGgF3ZuYgeO25cu
         YoCIFHe5ELsCI/ApQiPHCGv8gVCy2DrTNoJI7B8+mm0XqFS22t6aIPbSn2LVHD6i5REw
         uxU7QRY9EhGL+VD4HuOzPwWDHA8SvdKJZR4/aS+pYTTN7Y5vbQF6nPynBIzFJ1h9Gl9t
         GVko3mUSXgoZ9C5wij/CmlLOqNUbJxc2nxe8Xh/w6TKbBa+JUeJ1BhLsLzpRuZkv7x/H
         T9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768392861; x=1768997661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vpgn9moKDBgyCKhNw842q28BORTy5OVetihmiI3/j9Q=;
        b=RMUbnSe3vsw21LIsasItTvgU8EoILRBkR3W7CO3MD2+YbBV04/pNp9JPhA9ef8PpMs
         ScXzltSp5pHD26LtCtNuV5UIl+iMs/q0Qt5ggoudpXQ6tDkMQ8m8LMqohSB/hiC6j4Bh
         TScEThugr+HGQfVC9QjNu5qJSbdBBM9bZUl197irj1FbOVhjGm0OHko87dDDVVq1Dbra
         ICx7fTyfPcNtEQIrHa438t2WBSQGS4j1oJyJ7qvxQuwmeHZNd1Aiiu2WagiLzzDnxw7N
         aui52x5oVh9WALqdjQ1a5qVCqlS06q27uJdPnlAHsX3lAgQDnvYWbLrqTNn7kwqt7yWb
         /LTw==
X-Forwarded-Encrypted: i=1; AJvYcCW21zpdlZp/wk1ZaXtGWU9pZFU5AN1Wa9u8kvb8LgfSOwWvRf+MJLxHsXIstMyJDHlFS3gaXzQWdw==@kvack.org
X-Gm-Message-State: AOJu0YwnPnj7ba54fdv/QG08wRgmvEp6gzTDcFXiGeEf0fMrOMyHEgGB
	Y8ZimlDBr3FgTCGWvEwUStclvNf0cxOD0+wbT7bJLw+M+9CIs/zuk9ebRJoUIBjIQlvvcBpJfHq
	VVXm7CySNzEGpCEy6krEF6qcLwVv/Ufs=
X-Gm-Gg: AY/fxX4fuuf62d6Y+0v+1SSSzJ/56tONSb9pVDo4Gem7Ji2VvHF/a+T7zBl0Xz/teC6
	w5fvEaOUoX8cWYZHknRpgeOL1/DeLQq5+D/MhbvLNUoQ6Un8s713tSZfz6c1yK17M4T0GL947x0
	A3XC+mBRUy8NlGd8MgPq5IRNGsvBA81nCEzniyfT37glowQpy+kHX0r6eIrMMaoOorLQnU71y0a
	Em3NMvmqlIe1vwE3cfWlRrB1qfmYhMIselD7eVtc/fDl7pjcnOsiMCDpiWs8yb2wf4lhIyg
X-Received: by 2002:a05:690e:11ce:b0:646:5019:f3ee with SMTP id
 956f58d0204a3-64901aaceaamr1895854d50.5.1768392861312; Wed, 14 Jan 2026
 04:14:21 -0800 (PST)
MIME-Version: 1.0
References: <20260113121238.11300-1-laoar.shao@gmail.com> <20260113121238.11300-3-laoar.shao@gmail.com>
 <cfyq2n7igavmwwf5jv5uamiyhprgsf4ez7au6ssv3rw54vjh4w@nc43vkqhz5yq>
In-Reply-To: <cfyq2n7igavmwwf5jv5uamiyhprgsf4ez7au6ssv3rw54vjh4w@nc43vkqhz5yq>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 14 Jan 2026 20:13:44 +0800
X-Gm-Features: AZwV_QhhO9LftRha77JGtQk2VGHz1UfT0zHqtdmTUKBENe25a-mZ75XFm7_6Qes
Message-ID: <CALOAHbB3Ruc+veQxPC8NgvxwBDrnX5XkmZN-vz1pu3U05MXnQg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa balancing
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, yu.c.chen@intel.com, zhao1.liu@intel.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5200040003
X-Stat-Signature: y3xgp6tn1tctqqryu63hycwzxx91g7ni
X-Rspam-User: 
X-HE-Tag: 1768392862-498941
X-HE-Meta: U2FsdGVkX1/1MKMyJcsv7IOMH8KSFxFC7I6e51fDtr+BcfvfVjJrjHCFSwyPWM6yhN2vJtQTspZt+IvRaML6/mhsILznMe9KKt2IiiYt4JRg25elOtorRwbamWNZjwTsg6xibD9Bmdvj1/1ug/KboIo4uyzruV9qIUFLfPXhbtuZaLnbhJTN0G4KBA7sSAs0i+xnInpuIsmwEaPJbC+pNqRgHaXymWF1/gYChbIEA9LBjgehfYIk5Pf5UsvmyMKWzwp6wgpx14FrZQpqVkoWvDH1M13ayUqbveWlgUDEFHoyzsBlY5ayor+tKoaiys9ZkbATX/2RptR6VTlTS3N6oObWNHLh5sQmR4aIxsSRWkHKe1p0eAKUHig/Tqr1Jbxs5YsnkO1P3FYaqlWtz+dScxGhUnJ3/yVmg18Jp9LsrtV4XjTBT10lj5j2NLgTzMpjVOrZPu0AgGH6MzU+BC01C1wmZqn0qDAl1D9RN2FOXp4al4GX+65vsRufR+SmdCMz5Erm2A7mc26Q7QI7GXV53enofU3LOw2XS+0I3NFeuk/Tg8qzx5TMHeovRyVe4YSjeRfdAVBZtgKNkrQjSCbUlMH/Uq4wB7yFso+iIpNEw6yzhuYP6wkjp8XfRZqXn3UrdZOFLhleKLgGd3S9wqHv0XQc69ISrdq7vCk8LA/yyh7oJRZVtRfGBW4mE4SrJ2PUyc0eNNkEqoAu0bcYU46B/wxY4ziw7lnBjQ4YqM/hF7TtE9tuApoTNY2P5gPcwu588HCYAIW2D0E6RbCQvNTnlfulRDU+UJbBTwJdDG6YwZXgbohi2g7BtcdRw2wteN1IFDKqBqvn+2f0So5WgFPNcdNwqPVDUZWtdmpunNo6DAMVKGws9n1GmicRZqE3iGZysMKpw7f4bNpaeCVWKmIoXTgfDkz+H1QF+DkSl2NSflGTZORV1meD38DRKOa3rTENZDM5sRdiK0Cl+FIrJNB
 Ogn2f3q5
 p7odyDJ1GtxrEtg6/0iLB1sY5Tz/KpGufMHIZolJ7XpLt4abDuovA5bB+bIfJfgYAITgfVOAlHof4mAA9VmIRGcKMbRtIUSutWnzccaXF3lyI4aED5j66AvaFPP9A1X7OiShKj8dr/BfqWmU8LpFZ9SB7ToZ/cL1362DcICn3DVlVEdh8cGEYnZmwTJh1n4wd+F9l85xNXknOobzv7CyBQBwZbW2VZHaQ7iR0a/gghkWUcL7oSLzDp1v44TUPLDaBr3WhWym26y3lZaYQ1+yE2PdwoFMSiNN/f2S6u8GinXK3r8dD0Iq4rdovqSIqme2JMZwH3HEchSHl07yav5tB6qqyrULUISRpA8Ul2cWQPbHC6uYP4eHDN1OuSVqHMyK2cRdXpcp0TtzM4ANvxDdhlfzgVEfsE4tciYBx/h7MYKifUCxhYy4lUo9mFh0ONhIqP6ur5PKA0XDeq9Ojn7Gfe1ebnUIerLFSzchzjSXQtP6uJ0DTEIb6QJzAlfPsLE2NfRhR9HH7/RPgsRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 5:56=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Tue, Jan 13, 2026 at 08:12:37PM +0800, Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > bpf_numab_ops enables NUMA balancing for tasks within a specific memcg,
> > even when global NUMA balancing is disabled. This allows selective NUMA
> > optimization for workloads that benefit from it, while avoiding potenti=
al
> > latency spikes for other workloads.
> >
> > The policy must be attached to a leaf memory cgroup.
>
> Why this restriction?

We have several potential design options to consider:

Option 1.   Stateless cgroup bpf prog
  Attach the BPF program to a specific cgroup and traverse upward
through the hierarchy within the hook, as demonstrated in Roman's
BPF-OOM series:

    https://lore.kernel.org/bpf/877bwcpisd.fsf@linux.dev/

    for (memcg =3D oc->memcg; memcg; memcg =3D parent_mem_cgroup(memcg)) {
        bpf_oom_ops =3D READ_ONCE(memcg->bpf_oom);
        if (!bpf_oom_ops)
            continue;

          ret =3D bpf_ops_handle_oom(bpf_oom_ops, memcg, oc);
    }

   - Benefit
     The design is relatively simple and does not require manual
lifecycle management of the BPF program, hence the "stateless"
designation.
   - Drawback
      It may introduce potential overhead in the performance-critical
hotpath due to the traversal.

Option 2:  Stateful cgroup bpf prog
  Attach the BPF program to all descendant cgroups, explicitly
handling cgroup fork/exit events. This approach is similar to the one
used in my BPF-THP series:

     https://lwn.net/ml/all/20251026100159.6103-4-laoar.shao@gmail.com/

  This requires the kernel to record every cgroup where the program is
attached =E2=80=94 for example, by maintaining a per-program list of cgroup=
s
(struct bpf_mm_ops with a bpf_thp_list). Because we must track this
attachment state, I refer to this as a "stateful" approach.

  - Benefit: Avoids the upward traversal overhead of Option 1.
  - Drawback: Introduces complexity for managing attachment state and
lifecycle (attach/detach, cgroup creation/destruction).

Option 3:  Restrict Attachment to Leaf Cgroups
  This is the approach taken in the current patchset. It simplifies
the kernel implementation by only allowing BPF programs to be attached
to leaf cgroups (those without children).
  This design is inspired by our production experience, where it has
worked well. It encourages users to attach programs directly to the
cgroup they intend to target, avoiding ambiguity in hierarchy
propagation.

Which of these options do you prefer? Do you have other suggestions?

> Do you envision how these extensions would apply hierarchically?

This feature can be applied hierarchically, though it adds complexity
to the kernel. However, I believe that by providing the core
functionality, we can empower users to manage their specific use cases
effectively. We do not need to implement every possible variation for
them.

> Regardless of that, being a "leaf memcg" is not a stationary condition
> (mkdirs, writes to `cgroup.subtree_control`) so it should also be
> prepared for that.

In the current implementation, the user has to attach the bpf prog to
the new cgroup as well ;)

>
> Also, I think (please correct me) that NUMA balancing doesn't need
> memory controller (in contrast with OOM),

Correct.

> so the attachment shouldn't be
> through struct mem_cgroup but plain struct cgroup::bpf. If you could
> consider this or add some details about this decision, it'd be great.

That's a good suggestion. By removing the dependency on memcg, we can
simplify the design.

--=20
Regards
Yafang

