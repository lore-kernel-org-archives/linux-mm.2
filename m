Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6284EFD8FE0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23036B00A7; Thu, 26 Feb 2026 12:13:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED8B6B0119; Thu, 26 Feb 2026 12:13:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF02B6B012E; Thu, 26 Feb 2026 12:13:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBE26B00A7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:13:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45F7313A619
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:13:51 +0000 (UTC)
X-FDA: 84487255062.30.AE1A36E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 770BF100003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:13:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7k4gjcp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772126029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euWQYI6VTPnWxe/R+ZB/rm5QUfnQgxdguDrbNCz0+DI=;
	b=qWKl+uGyoN5hgTGuCM6BARXSIfGyioBMnAFg9L25g+uPG8Mj3+TpmSeWQL1Yneji8oMehQ
	RXYEfzw7fYGzOYIf/3cmq+waDxF+98eyx8lz9jt1nSQC4mQ6rTKmqf04ho+aqfJoNTJ4GA
	adfpdYvhQ05U0us5SL1GMdMmLtGOvAs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772126029; a=rsa-sha256;
	cv=none;
	b=7lYZ9dxirXK3Hk7SKVR1Iu0thXOuURxucnmpuNMLljJh+Bo2cF0t93GaK8A5FQM99nFGnP
	3p6mu3XkFNVd4o/T2ybvFbKCwe2DsiNh+oat4IfOo1+zK0+webAAPsUqwHelPMnNU+Kzdd
	xqLDwxNBEV02X4M56YzTM0Mvt9rbqvE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7k4gjcp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB25B60141
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B6AC2BC86
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772126028;
	bh=euWQYI6VTPnWxe/R+ZB/rm5QUfnQgxdguDrbNCz0+DI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K7k4gjcpwjNwnZ2fgQsF8UVFuRsxg+wJOyVRtwctubPWHIeBA7MXw840pLoqjLJhp
	 fhHn+v2aMxmRZUnGCuxC5gvLvXyBIwK/0KoKFe6x3ncGF+Y4JFB/i56JIL7Kcd/v1d
	 D+FHEatHll/2g8R9O4jOwa3BLd6MFVCMCfjqAqHaxmHjv8wrhOIphpyWvpxKKz4+5B
	 heUAe5gkd7FiKsgGzg2WrpLAbrD+tmi9h518wBWlePniR7uDZINzZRKqa32ciL9C97
	 ZoGlVSgd3fAVz5EDaye23HFGUWRYwCOwsG1J+iGppF0FAWu9m6Y2XCTQGvfw4yidBV
	 gwLqBNZIlBnSQ==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-899a98c2421so19661166d6.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:13:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW5zKAIxmc/ZAsufxnvMxQbppE5/CYV0CsgIOBb5IxbXJFc6IB6FCKcxwbAgaXwZV3FjVY0g8M+wg==@kvack.org
X-Gm-Message-State: AOJu0YxTUlZxO81QYERx71pfuQZuLbd0zTQc6subtFpZxB4ici/c0bi1
	1BXTP8GDt+tWLyyf7JXnMvNoc0ayHkkIaG5NBN1GlIlZWF85boqUC+IFb5CgG0aAPQJOuAFhs1t
	NngysnUduKe1XtYGKIpGjE4zc6htQYF8=
X-Received: by 2002:a05:6214:627:b0:894:6f12:af5c with SMTP id
 6a1803df08f44-899c13dd9d0mr72291106d6.24.1772126027803; Thu, 26 Feb 2026
 09:13:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
 <aZ-R87JfacQ2gGq1@linux.dev> <CAO9r8zPmgytmGHAbueFKXcZWY5SJaEwD3Pqk99ws4XeO2_hnKw@mail.gmail.com>
 <aaB7yYSpAaC5uInq@linux.dev>
In-Reply-To: <aaB7yYSpAaC5uInq@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 26 Feb 2026 09:13:35 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOP-kB=8ADGAUZYnpY-rxG1TCGbQg3FxqyC7WrOu3NASg@mail.gmail.com>
X-Gm-Features: AaiRm52kMdcu5UAJBT1YFqYWZjlPJf22WLU_UA6yC-0U8iG5lX8r98zBJgwmLKM
Message-ID: <CAO9r8zOP-kB=8ADGAUZYnpY-rxG1TCGbQg3FxqyC7WrOu3NASg@mail.gmail.com>
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 770BF100003
X-Stat-Signature: 7zrqkc1ayjgx6p3c8gofkdhuz8nfaxme
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772126029-881947
X-HE-Meta: U2FsdGVkX19IGvtPI2JMCDpxVqeLX502ix73z21HWbAHd/TFbPwrtNY9GgrpTU90F9qYaV7cQubvbYOjhKt5VRb05UyiBA72YKOna9U6IoFatnihN43OTXaG9REf1ll0IZa1+7IgH+ZF1LEUAqlOzCVJ1j3aPffxlsUVUifFaWcumySuLGpXuof1KGIvbb8CyiJWcIVeJPZeOFBa3ie2V6MQojlTKLNu+Qk0VWJQqrLj4Mr/OW5SzfbWfPGiDTxifvU9taGLnt+4lxjxKGrqaGxSYe2954U72ZQmaDB4iaMNeRqTL/3PZWv1XqSvrwBFelM1Vt7NUGPZg8CtHuA0mS2rYNLi9XbLARAXOmCw4qeY6pJ1bhNeCVcyb8FcrpDOiFbw0HrX7ogGj6S+H5BC8iZx+M9Fd+WYUyncMRUhAI5uCPGyMHCT97TZA0ptgigybLVCF50icV56vXyXCryQiMp7LBjKKSLW30Djm0MIjY7SUga/LoaLr4MU8mjYFBPVLdanMTRUGQH766TFT17lkMs14bPzXZe9EgYK69ktzV1I9Ddb4PrWlpXD/ZlSuA0L0Ie79uIfux1p5lxVHNV6j+fnsa3JULlqgFa28dhFUuXciqe8MVmbymXF/6Cs2HfWe1DGMCIKPasjCjXb0nhcHdiXAf5MeXClg3XFYfQZehXgyGyjAl9MzQrTmTMb27zjV3CeVczBmQyrqI/gSZICZr7ykUNMutV1Vkjg2IAxW7jbZh/ze6gOkH+qWK4+Ta0cMi5E0xQqFdT+4S4LlkmJe+eCSl7Hv2Tuz3vYxWlMYKkpofzAuIZnyyCggYXD6/axcOLNHXaQaZfPY395almqS/L/HzJI/dSVSOgJEFj5740waHsUcZgu6uHXqU2F8/I2WclnmXwJgAHVrivIBsL8lUeLlfR7z33kW0o/6+PEIC+QLpY0w7wRMn1XJNj2LRm0ara75wcjw1j3DpLq6LM
 96hKN71R
 fTzRRPWWevXICF6dd+2pJX9mtVM6VNJCYUG3Sd7qpu8NrXRdW4AfIBypYIoaoE1l+ADmR0MT5PITN8TfDOS4q6Y9k3kEO3YU7RBhZ7oi2aK17CO+Yc/OOXBumxJcDymQKkP1zzlP/ZKxyYmk58hYs2aAuJyyNo3KPqX/kpzp0qcI3/i/aR+l3Z1olHzssrjD++Q16GtMeKPl/q0FcrRNoCBqeXqtepPOjDz2+FQsDinm5KcsL7iWoP7WDTG1SUhr2sjsiyov4cdQ5/dkKUmxP9/zreP5kVnN+/8Br+NiIWrzuWv1T23Xf27gTEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 9:03=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Feb 26, 2026 at 07:16:50AM -0800, Yosry Ahmed wrote:
> > > > Did you measure the impact of making state_local atomic on the flus=
h
> > > > path? It's a slow path but we've seen pain from it being too slow
> > > > before, because it extends the critical section of the rstat flush
> > > > lock.
> > >
> > > Qi, please measure the impact on flushing and if no impact then no ne=
ed to do
> > > anything as I don't want anymore churn in this series.
> > >
> > > >
> > > > Can we keep this non-atomic and use mod_memcg_lruvec_state() here? =
It
> > > > will update the stat on the local counter and it will be added to
> > > > state_local in the flush path when needed. We can even force anothe=
r
> > > > flush in reparent_state_local () after reparenting is completed, if=
 we
> > > > want to avoid leaving a potentially large stat update pending, as i=
t
> > > > can be missed by mem_cgroup_flush_stats_ratelimited().
> > > >
> > > > Same for reparent_memcg_state_local(), we can probably use mod_memc=
g_state()?
> > >
> > > Yosry, do you mind sending the patch you are thinking about over this=
 series?
> >
> > Honestly, I'd rather squash it into this patch if possible. It avoids
> > churn in the history (switch to atomics and back), and is arguably
> > simpler than checking for regressions in the flush path.
>
> Yup, let's squash it into the original patch. Please add your sign-off ta=
g.

Sure. Qi/Andrew, feel free to add these tags if you squash the diff below:

Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>

>
> >
> > What I have in mind is the diff below (build tested only). Qi, would
> > you be able to test this? It applies directly on this patch in mm-new:
>
> Qi, please squash this diff into the patch and test. You might need to ch=
ange
> the subsequent patches. Once you are done with testing, you can post the =
diffs
> for those in reply to those patches and we will ask Andrew to squash into
> orinigal ones.

FWIW, after applying this diff, the rest of the series applies
cleanly. So I think we won't need diffs for other patches.

> The diff looks good to me though.

Thanks for taking a look!

