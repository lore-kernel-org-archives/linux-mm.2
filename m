Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C78C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238E86B0088; Tue, 11 Aug 2026 11:36:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E99C6B008A; Tue, 11 Aug 2026 11:36:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069C46B0092; Tue, 11 Aug 2026 11:36:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D333D6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:36:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E6381604A3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:36:14 +0000 (UTC)
X-FDA: 85089389868.20.F651919
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7BCC6100013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:36:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kojnb5ql;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSbnyX+X/byoPpEOsc6XvB0JapembmgEXtZ5bd+IWFE=;
	b=jCZLXlNtM05laGuJ0LYBBOxyD4BkLRLnnx0CP7SqWI88jLLLModWfCcdqsTtQ/5g0No+QC
	lBYrN6c/rDLsUpjioJz0Qo2RFb1gPsO34zb110aDUCCcVG5nyKQhv6/arr4wFM3fLTa7a9
	M2URTaQJzb7aF+J4SBsdTUU7xko/Ihg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kojnb5ql;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786462572;
	b=XxRmkozgfWgRyXeKfacdCmQjCQoe5NB8Iq8SdG/Ghj2/05ZclT9DvWXrl6DGEMboCNw/RJ
	UNISXBTJgmRkWth/QSfobpyJffETZdpx8vdURzD7upeOwJ1YHPhr18veVK5j0b2BvGc/qC
	wJBo8RggMMhwo1sX83Wjn/gWT428RGs=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c10e86e52so285461cf.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:36:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786462572; cv=none;
        d=google.com; s=arc-20260327;
        b=bMwuE29Ns6O7yFBgrjnC4AsWQ75+kCltIVlIez13geWPE948yIndvX/JFpX0pgiBa8
         rxQU7w2tCWo03k6lGzuSgqDL8USyy3ZHztCLDYVfKnYk/yNPLR/hQYeBudRi1JiReVSF
         jX64fx5P+Way5NQvvWQ51SwCXY0kfmArWhdwxJEiw9enSHEQOAAv9JIVkCYRD/gje0W3
         F3Vg0RFMXBziUMbWZL7208R3wWCKNCuRleaxKN1IPyQBgMZSTzqGBriU+YT/gMfJ85H0
         3f1iMMQDlrx2+wAO9VgF78c/kilGjiyChPdR/ugQZ6PdFKMgO71noKeiq/cviZDZF4Cf
         0UxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QSbnyX+X/byoPpEOsc6XvB0JapembmgEXtZ5bd+IWFE=;
        fh=zTTn61fw4ehet2UK4PSJQaiACfQDPYHDFlEsm2FizkQ=;
        b=kORmHMZ5Dg8Cvgf3e9HHtB8SS1WxbESwqgB26upKyAZoAT93ni8O942QhLRSahxNK3
         7jijz65ji/zN9VjpP8TyB/UnfA5ctrL7WQalKK4mjoOMpVJixG+G/Lk1Qbja+jxnGbDb
         kGr3HVSDl+eqgDzgExUDWyhOFhwQbVTZCs00qKJamdmFdLx7tU9xJ8QTVrPj3cw/TbD/
         L15pMxtDIHAjjAy3YgQpDLeHPMGuV85NJcc3jIQFShCrRMYgUE0niOSeQyrVnvVyDVqs
         DV1b9GjqM+6DClgMv/KZ7lGR/HlKmqTd78otb3+DwfUFkJWwCW5VoAFj/mtISRsy5IpA
         oLAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786462572; x=1787067372; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QSbnyX+X/byoPpEOsc6XvB0JapembmgEXtZ5bd+IWFE=;
        b=kojnb5qlMfXqyTlceUu5E8w+jzf96hCfTTEkLWsa3s6B9a/qLDAPSD6csNx+CLlJPm
         YR43kEGu82JsJJzSnykzoRMAkExgJQxtTaByr0Hm5cP+teGn3jExoEpsahVuPQ1WarnL
         v5omuHZMMiWQgXytN4wwAJyhNF1Bo1mWromTF7fWGLEPfypxgO4MVpSnSftEzjVSIDNI
         QZ81IgE+CVQtZ+Q8q/pyk4Aq5eDgibn7XfJDEGc53TuFVPehY+Sb7GsVeg9pWbmoUmaX
         oSt6goWik+IfOBuzY/a2wN1ErfRQOoZSHKo63Xw1hcwjcjksQwuQPxFUWiQBSm4tzgia
         t0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786462572; x=1787067372;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QSbnyX+X/byoPpEOsc6XvB0JapembmgEXtZ5bd+IWFE=;
        b=aF4g+/+5p7pJ7YsfC6LMsRA7JisyyRphL3MySmx+wjX6Hdrn0r39NLSRmKcV6+bJc/
         QhfOrByeaOY3ISncF7jEgn6ZOz4GRRN08nS1QVcqiqYXnnflKByqtj+9NyDa8LHIbzJ6
         FbS2YUyYd1/CBcxYjEW8VMbJINOGJAKslZh3zfEqk6veQ4XQWwKGypDhcK0WxJT02/KA
         80568doB++AsAnRARwygOZFb5aXvCqxG/KjTzh+qyWEm+kqh8jnYVgPC5OApW68B3uMF
         nPk7QMtZYd0VbayuwMGP9tcBZZznCcm387TNO3D55KpN77Fqq8iEl1tHSrzWkCLCJgrd
         33Zg==
X-Forwarded-Encrypted: i=1; AHgh+RqoTLeHiq5iwCThoYKSTes/5g12dgdkKmuJzlmkcj9N2GU0CeehMDphl450FHsjf6NdkRIScKLtlw==@kvack.org
X-Gm-Message-State: AOJu0YwTVxoLTVg9PpAJOtmn53nzxIpZh3BEIRrdSWjHFLBY37nVX+ay
	CtNC5iz2ma3ELDfMy24E+J4JTehwocVg3Mfs0lxCYy7qwvENGR7m3chU9htOoeLBV/NjeB76328
	Ao/Df1mhINXxTicWAlU+QHqlInDQOW+gkEY/FPHnf
X-Gm-Gg: AR+sD114vcltd0CaSL2MKABk0PtSTaBaHrwAThctHCCpxAnvMC8gXcyIvFqfRaAal6c
	pyqPESLPncBelLTKv6ZCb6EENt8nN8SMP5aqwOr18NlO6eZPEmpk3HLypypUO3W8NaGl8Hq4/rc
	tZYJTzbNRDPnUnjRnInmi4vUqbrfHSMFOl4LEFjAIPrPkOYv4bEdui/TRXruiSMrsiW8LLZq4ks
	MbmEOn8X3bYBBasnmaFzOmJuf74BKVDYX3HOMjl1a5LE8gd123p7UTla97r+ZhD/tR1nu8+9TCE
	UA6n8Y5IMqCAVjOxgIXzk4iyBLOUYea9SXeqpeWx7Q77PYXH4hOsOoMGB5A/psxBKM818sv0Cg=
	=
X-Received: by 2002:a05:622a:190c:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-52d580d6162mr12122271cf.5.1786462570992; Tue, 11 Aug 2026
 08:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260810093955.153015-1-hao.ge@linux.dev> <20260810205251.3fce0ec86ee20925fd577c26@linux-foundation.org>
In-Reply-To: <20260810205251.3fce0ec86ee20925fd577c26@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 11 Aug 2026 08:35:59 -0700
X-Gm-Features: AUfX_mxmFUMMJNxASySaJAk1Wiidb9lbuMMRd31WwigRad3YmpinKxeeQ1tv5kQ
Message-ID: <CAJuCfpFRWcjB2MwVUS0j9=yFRDLWZdumovBoBi-xkwGW+y2Viw@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9fip9r88rtydaztikgqn1itb7yu5wged
X-Rspamd-Queue-Id: 7BCC6100013
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786462572-364273
X-HE-Meta: U2FsdGVkX1+NU3z3DOIwy3UW2mFuzbPuMFDUyQMQcTaamO7aYoQtl/jsrHwpn1Fvq4rjdL77qfEI7q9GC32jE2X27831u+1uUbOdfqHDKwO6rCDPSkyFaNcjvKpwamjM25jwcFZ8igE3yhyWVpqtw7cVWER4rMEY8qzgEYnPTnvBVOnR35/t662alWmkHtbYufnt4SGuUYPyO3sptLcqsGLBOmXGgrWsMDF4Y+2PbOM/a/z0getftftf8Fi6/lFSzqiEqUlCxIkd3tQzs+8Cq6f8vo+Ld75WeTULVbR7QyVZQ9D4agCzAuUvEdWWvMZGm1AfFfz40OqR3wCPvcSS3aAys5Oy2zit4MYjU3+R/MMHWMVRnJ1vcVXknBORtN8UnroNWCHFM7PUn+8C5Z+v/QdyD3N9RSfZbFWjRURzrCbXPfe8O1Pdqsx8wmobvHrU5Cqhwu2b6TWpgc6Qwj4F7yn0ZzkZFB3+Oznz1JK8ywd64HClfESaqqx/o6NMu6wyGBVaRKwRiuIG+pJpRoiO1U9rWgkHs6LSkRuJT810WaNRTmZFfUIVyWQbRVBK81aPbHSSIGk7Nkk+Bapz7VwvXSlK/yVbzWlmFRzdwT+81bdPiPhljENBX3S/3CYB5NquHbgZOR2BbJyfiV+EAYN4X9Er3JF7VPaKq/yUeiD25hEI0HdyCye1AAG18ntB5jT0tvv8If/bCHi4gt/xYKSpmCaUrQYbp3YZJw9VV3SYfUZKWaQzs0XeOVw3sl5Y3KVqoJ6fok8LQjL/P4q64mUzBC2cu/pkee/nTYLK8wXj4oJkW60lQmfA5B1Wh/eyl0x4r+Ijrj/DblVtKVmL9ha+OsJqrKha/l7DfLuTVAUk5ehli/jwd0QRsvJtXlb/7JTeGyutek+LCoE/uOi4fBCJ8uRaQ8yW87JxSvUfh/b9q5q8mZq393x3ANrjhY02Ze25wohuns6qFMsuyfK/vhA
 2zL82vTv
 HvO+Uho5FiprQF1rGO+G+6A9wVVa/vNY8X4SorKui3ZilnUqUdTBmtH2R2bxivLpkavwn3hxtfSw/vW/KtL/ZqyMhqelDvQ5vztrQBe+v3L8e9dt35CSyPQ5GNOSkUlbJ+jS+PPfR+VAx02K4772fZrb/kBq6OsxOfknjJAmDsWOnr7Lc9mQ7bz/2yoOxM2so+2N2+ffU3M7OpVerQ7YRigCRNa/C/BakPXPooWJ3KHBVtLlSGdofyNaph8yEeYPdaj4mpC7WG6H7J5daSEaFEG4cqzYbay38ekwDjqj5bKMjP7oAJ5w1xCPsZV0ahFWQgPZkePWHNnMda1oOsxyjsOV7jenNpllkx5maFb0HMBTn7YHxISzuWTZEuT6sSvNpcBZyZqpL9Mbx9PTb0ATzWB6ASnEV81BDYPaTlEi16OasSkq0wzPNtWeyDjCRGmubAabM3fK2b7lGDj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 8:52=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 10 Aug 2026 17:39:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>
> > v3 was a single patch. After discussion with Suren and Andrew we went
> > for a more graceful approach: rather than failing the module load on
> > overflow, let it load without profiling. Once profiling is disabled,
> > codetag_needs_module_section() returns false, so on retry the codetag
> > section is placed as regular module data.
> >
> > A new patch (1/2) is added to move release_module_tags() above
> > reserve_module_tags(), since the overflow path now has to call it and
> > the helper sits below it.
>
> Thing is, [2/2] has cc:stable but it requires [1/2] to be able to be
> compiled.  [1/2] doesn't have cc:stable so we're asking -stable folks
> to backport a patch which doesn't compile.
>
> Resolve this by using the same Fixes: and cc:stable in both patches.
>
> > release_module_tags() is what module unload calls to drop a module's
> > reservation from the maple tree. By the time reserve_module_tags()
> > detects the overflow it has already stored that reservation, and the
> > -EAGAIN return skips vm_module_tags_populate(), so the backing pages
> > never get mapped. If reserve_module_tags() returns without calling
> > release_module_tags(), the stale entry keeps pointing at that unmapped
> > range; when the module is later unloaded, release_module_tags() walks
> > it and panics.
>
> AI review had a lot to say about this patchset.  Some pre-existing, some
> not:
>         https://sashiko.dev/#/patchset/20260810093955.153015-1-hao.ge@lin=
ux.dev

Yeah, some of them are not related to this change but at least one does.
I need to address the unrelated ones. Will do that as a separate patchset.

>
>
>
> offtopic: alloc_tag isn't getting allmodconfig build coverage at this
> time because:
>
> 1: MEM_ALLOC_PROFILING depends on !DEBUG_FORCE_WEAK_PER_CPU (why?  I
>    can't figure that out)

DEBUG_FORCE_WEAK_PER_CPU forces weak percpu definitions everywhere,
even in the core kernel. This introduces the restriction of [1]:

2. Static percpu variables cannot be defined inside a function.

Memory allocation profiling relies on percpu variables inside a
function in DEFINE_ALLOC_TAG(). For
CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU we comporomise by accounting all
module allocations to a statically defined _shared_alloc_tag (see [2])
but we can't do that for all kernel allocations because profiling
becomes quite meaningless at that point (all allocations being
accounted in the same counter is not useful).

[1] https://elixir.bootlin.com/linux/v7.2-rc6/source/include/linux/percpu-d=
efs.h#L64
[2]  https://elixir.bootlin.com/linux/v7.2-rc6/source/include/linux/alloc_t=
ag.h#L91

>
> 2: x86_64 allmodconfig enables DEBUG_FORCE_WEAK_PER_CPU, despite it
>    being for s390 and alpha.  In fact it might be alpha-only.
>
> Adding
>
>         depends on ALPHA || S390
>
> in there fixes this.

