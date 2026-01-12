Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37046C9EC78
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 11:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3536B0088; Mon, 12 Jan 2026 06:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9713D6B0089; Mon, 12 Jan 2026 06:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870076B008A; Mon, 12 Jan 2026 06:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 716C86B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:27:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D6CF5C136
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:27:56 +0000 (UTC)
X-FDA: 84323087352.25.DCBAA86
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	by imf04.hostedemail.com (Postfix) with ESMTP id 78B694000E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:27:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NhdmXJWd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768217274; a=rsa-sha256;
	cv=none;
	b=nPFwgKoHr5UFMwwxso98g+kKhBWhXKBlUQotl4vQwWwsdjkk72ETaJT5t0W+LPCXNa/mdp
	OM7GWvGzT0fs4dnIgZuKzkC3qx+a6izGL/yYqFYZ75rUQP7vK10hQ5UKANtmHNjJ2+FMSL
	JrWCSipOCNEPK/3HidNSSHPrnwxhZ2I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NhdmXJWd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768217274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtgH+qe/hSVmcXtkIN2o+DfrHM5ZcfxVL0WRG4iZlzo=;
	b=w3FftiH+snhSsFdslULLvyxWStOygIFLZQdmYzy3DAzEomzj8SMn3g2CCLUk2kLA6rk7zB
	JxrFIZCkvFymqH7kN3rUE5ba9RV/paxg9xldnJq6JTXRQFSrGVSiG0Ir5BfVbictNPlDLp
	IIMUyjGOxNQMdjWmm6tQf5+iEZVRIso=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768217266; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=XtgH+qe/hSVmcXtkIN2o+DfrHM5ZcfxVL0WRG4iZlzo=;
 b=NhdmXJWdd/eVnPNwFHXAGZBzTRM5SJywqFlqbUAuGyjvajcDdQc39p0DCnyOSz1k8gGWKa
 hWDD2aDPlad96OZLx7Vx1M0lT+xKUAwibPBpZHYfvB3j4qEarH19papJ1ane0dQCPDFsso
 czPZKxybsQZc/S59RsYTIhLi+jBjx6AQZD6Yg2ZNrcXbu/pCaq8BdLibuYDJ1Vnv9fLgeJ
 Z3RAJayrZ6CIAXHUv2+13p/fwNw5+kSCXYsQK78WE0IQTgX4wdLecrlkxIGZCK97YGtizP
 zPfIBOIhe1GoouPlcDnugaq/kqC5WfqIJ7cAwnGKnhBDdS0pJ7yfnDcCPACYSw==
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <fvdl@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <osalvador@suse.de>, <mjguzik@gmail.com>, 
	<mhocko@suse.com>, <joao.m.martins@oracle.com>, 
	<ankur.a.arora@oracle.com>, <raghavendra.kt@amd.com>
Message-Id: <20260112112728.94590-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26964dab0+48868e+kvack.org+lizhe.67@bytedance.com>
References: <1981A332-0585-49AB-9ADE-99FA2FB32DD4@linux.dev>
To: <muchun.song@linux.dev>
Date: Mon, 12 Jan 2026 19:27:26 +0800
Content-Transfer-Encoding: quoted-printable
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <1981A332-0585-49AB-9ADE-99FA2FB32DD4@linux.dev>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 78B694000E
X-Stat-Signature: xhcdk1m7anpa8rggxwq148x4iniumowt
X-Rspam-User: 
X-HE-Tag: 1768217273-618146
X-HE-Meta: U2FsdGVkX19KdFLzE1K7PN7V3mOVEkzARJ2jPEQI6WaykKC59C5JUIR9aVd02ZnYHGwybrRbM/qQj6fQAroPnueDtjCvBSdwNPD9pQ6IonpOJ4NDt62g2AmwGV39zt2TsldEr9MPmc3JNuFWpam5HWmVKXjwniUFJtY1UJsEmbdKQLW4Gk7CCm+94FCahTAUDACTXWl3WLEEr6t9c2VDcz3+xKJDtbr3rqHArU6EgiaooSxheFEwhf2455ySJ/68lMyXPm5Dwh6PSVULK0JULAmRoUJjDrbe0wEVqdiOAN9JckJJg2CKKIlnFw4n26Us+0XVM9T6vT3jHI9eDCDrcC2LerbLr1F4DFzvouF3BryZhU6zaGpLNDQoirY80xdMhe0NdeS0JIsiEcVCaAS4vqlgOusSmxvDjLCnRC/QjKZ+WtW0Jh1Z6TVzqPJ4OKbuTAwGe6Dd5MdEq0w2LjqDuZs9YBZEK098VdjBj0lF8h7CskRltRWKaTAlilWZpPzRzPsSBcVavqnGeRiudwbwhW2hJn5VD7bmDCS/Rwv22NKJkYApk4O/yJt4ITZWYIBX3xFzgjMgqR+/YxmMpZxCo0d8mc42eCBsqsSVV80HM+e8ymsQl1fiqu8eBYrtBd+XnOuB3jKD89FzhuV0CwRK/ALrj37MPZk6iAV68I3IW3D4mPskloEwF+9K+4b6jP82iyzApZvNA/bQfHHK85pbwwqLuGpNbCqIgOnbeUdMThIvMJatwbfOpr5PW++/4IatZLMC8wNO4GL56t2bc8PyLyNOITTuAAOPFnPJvEgc49RTDR5NYhJ/CfV5oSRkTHKTNOEzQ2w9TKMzPY7kj30oA+Hij5eqpLdPSdDJDgF6y4Lnm7RUBNKxm8/6z17g7pS30k5ea09BwVyGKpnhyxANxZmsYMwxzvDX882+VJT/TTKt7OiLBOrU3NzPD6l/q2LoS8WvFjjrkR8zFdGH8ak
 hYlmEGiU
 t+hznF6EemnKozD+x1GvdIGK+dU/Dcro5qvrgXE5xMr1R2aPw6WZT4esFDHE/2Jt2gLhFoOQ5Gj2utYFgsaE82ePl2mRUp0upnhL4cRNGweKTXO7a2WbTm1M0Im7oWv+SXfEhCSn+LJPw1iqIxvzWJA+rhfGiO32B8XWtZh05fUut8SVoytP8NPwtoD8Uu+30HOljPtXU8sB5AevyGCJ+n4zrEUqn0pY2Xt7JEflzrjvTB71lu1adZBNBSoQR3F0V9zXa9F72uilnOv3gOCyw7I27rFKC3kl9uIj7h77QbBtS1WknVagAiah5HV2ESphfo2S8g9O/kPtsfmE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Jan 2026 14:05:01 +0800, muchun.song@linux.dev wrote:

> > On Jan 7, 2026, at 19:31, Li Zhe <lizhe.67@bytedance.com> wrote:
> >=20
> > This patchset is based on this commit[1]("mm/hugetlb: optionally
> > pre-zero hugetlb pages").
>=20
> I=E2=80=99d like you to add a brief summary here that roughly explains
> what concerns the previous attempts raised and whether the
> current proposal has already addressed those concerns, so more
> people can quickly grasp the context.

In my opinion, the main concerns raised in the preceding discussion[1]
may be summarized as follows:

(1): The CPU cost of background zeroing is not attributable to the
task that consumes the pages, breaking fairness and cgroup accounting.

(2) Policy (when, how many threads) is hard-coded in the kernel. User
space lacks adequate means of control.

(3) Comparable functionality is already available in user space. (QEMU
support parallel preallocation)

(4) Faster zeroing method is provied in kernel[2].

In my view, these concerns have already been addressed by this patchset.

It merely supplies the tools and leaves all policy decisions to user
space; the kernel just performs the zeroing on behalf of the user,
thereby resolving concerns (1) and (2).

Regarding concern (3), I am aware that QEMU has implemented a parallel
page-touch mechanism, which does reduce VM creation time; nevertheless,
in our measurements it still consumes a non-trivial amount of time.
(According to feedback from QEMU colleagues, bringing up a 2 TB VM
still requires more than 40 seconds for zeroing)

> > Fresh hugetlb pages are zeroed out when they are faulted in,
> > just like with all other page types. This can take up a good
> > amount of time for larger page sizes (e.g. around 250
> > milliseconds for a 1G page on a Skylake machine).
> >=20
> > This normally isn't a problem, since hugetlb pages are typically
> > mapped by the application for a long time, and the initial
> > delay when touching them isn't much of an issue.
> >=20
> > However, there are some use cases where a large number of hugetlb
> > pages are touched when an application starts (such as a VM backed
> > by these pages), rendering the launch noticeably slow.
> >=20
> > On an Skylake platform running v6.19-rc2, faulting in 64 =C3=97 1 GB hu=
ge
> > pages takes about 16 seconds, roughly 250 ms per page. Even with
> > Ankur=E2=80=99s optimizations[2], the time drops only to ~13 seconds,
> > ~200 ms per page, still a noticeable delay.

As for concern (4), I believe it is orthogonal to this patchset, and
the cover letter already contains a performance comparison that
demonstrates the additional benefit.

> I did see some comments in [1] about QEMU supporting user-mode
> parallel zero-page operations; I=E2=80=99m just not sure what the current
> state of that support looks like, or what the corresponding benchmark
> numbers are.

As noted above, QEMU already employs a parallel page-touch mechanism,
yet the elapsed time remains noticeable. I am not deeply familiar with
QEMU; please correct me if I am mistaken.

> > To accelerate the above scenario, this patchset exports a per-node,
> > read-write "zeroable_hugepages" sysfs interface for every hugepage size=
.
> > This interface reports how many hugepages on that node can currently
> > be pre-zeroed and allows user space to request that any integer number
> > in the range [0, max] be zeroed in a single operation.
> >=20
> > This mechanism offers the following advantages:
> >=20
> > (1) User space gains full control over when zeroing is triggered,
> > enabling it to minimize the impact on both CPU and cache utilization.
> >=20
> > (2) Applications can spawn as many zeroing processes as they need,
> > enabling concurrent background zeroing.
> >=20
> > (3) By binding the process to specific CPUs, users can confine zeroing
> > threads to cores that do not run latency-critical tasks, eliminating
> > interference.
> >=20
> > (4) A zeroing process can be interrupted at any time through standard
> > signal mechanisms, allowing immediate cancellation.
> >=20
> > (5) The CPU consumption incurred by zeroing can be throttled and contai=
ned
> > with cgroups, ensuring that the cost is not borne system-wide.
> >=20
> > Tested on the same Skylake platform as above, when the 64 GiB of memory
> > was pre-zeroed in advance by the pre-zeroing mechanism, the faulting
> > latency test completed in negligible time.

[1]: https://lore.kernel.org/linux-mm/202412030519.W14yll4e-lkp@intel.com/T=
/#t
[2]: https://lore.kernel.org/all/20251215204922.475324-1-ankur.a.arora@orac=
le.com/T/#u

Thanks,
Zhe

