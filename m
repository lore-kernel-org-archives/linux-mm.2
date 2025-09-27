Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4CACAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 20:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6468E0003; Sat, 27 Sep 2025 16:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C138E0001; Sat, 27 Sep 2025 16:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC718E0003; Sat, 27 Sep 2025 16:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D00318E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 16:27:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F2E813B97F
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:27:19 +0000 (UTC)
X-FDA: 83936164998.11.1289F74
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9590AA000B
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:27:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M+mJ3qiR;
	spf=pass (imf15.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759004837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9iKX971Yzh+vTHTZnyNwti+PFyVkjEP/KuLLQvtNxsU=;
	b=cz/f+Z78tL+PuXH6MAYq0rpTeQPF7qxLtpYUFhMcmH7g9JXkPameMZ+aifDBTVKnGzsKXu
	yccivbLN/c0SfdVORLnDcKc+ZyeMjT+vaOpNFsKBmxQFe1/PxcihBk4Awouxt9ykEBbz0D
	udF+RNoc6gRLS1tUvag06DoXfckiJMQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M+mJ3qiR;
	spf=pass (imf15.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759004837; a=rsa-sha256;
	cv=none;
	b=sUUbd2wG0Ui6iaf2yL1iF/fWwvvbgDWv2x/BeytgFt1dYh79Ij/DYY+zccNl6jtaD3zzqo
	DOLnFsB89eLUB/3vt+acZyG7+3mTdaIuxeYu/aMI3S/G9lrbx9DvPNAqOx2P9l7eU0/uuD
	/ZNFt42RltPL1t+3vpvsEpQRhyzXMXA=
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-54bc2d1feb2so1021483e0c.1
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 13:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759004836; x=1759609636; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9iKX971Yzh+vTHTZnyNwti+PFyVkjEP/KuLLQvtNxsU=;
        b=M+mJ3qiRTA8YwRUr4COTdTIN5bIeG5hiEIiRqM6iyJQGAo8J5VFoAISM94UapxbxVA
         sNjbixNHx80PK/lIZu4aD2y433/9RDlPtpfTBMydFGy/LaKOGMElju4YuCz6Usdq0XXM
         kW5VGHWtkgr0sXKsn2QON6y8UI0Wu8H7vr20y6XOqj+Y2e/lMzIxrVi4vgYo3/EZ0Mjq
         mr1fyLM7uihzAPY2KYXETYjm848ZoCjmPYqJTYrficBwNgxV0s5Wq7ptizdK0OvmOH9c
         Dwb0RXLfu873akUNluFwcYCftbjlCjHJgV8RDZubx4DbqEK9X44GY//EZNsYZdMbK2qt
         IhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759004836; x=1759609636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9iKX971Yzh+vTHTZnyNwti+PFyVkjEP/KuLLQvtNxsU=;
        b=HEM2JbLPOhB35hDUcXFB768588ttNFz2SQpcer4iLSqHCU5vPpB025LD5qwKs//7jW
         7TbQ1KD9xZ8FYsWFND8UoXtxARwQarcOBZnNqn3sRbsJBxSm6HtpBJzptA7eYHBPsKGf
         7i/thDqTe+w+OtvdIHsRu4fNEVS6z8SFTgsuuMDbFXSeua6ETcNg0PL0tAYxmeocKZja
         tCTB6Vsz34s/J5GkTLIqHUv9Bc6EZDzcONBlmJ2vtEMejK2GaabuOeRlXxOrcxwNMtse
         u0+KJF2PJRamtvuaZsS/bvjWYJcl/0E+oMjRpdylYVfd3Vkxsm9V/2U/nJmeAz+kD9KX
         0aTA==
X-Forwarded-Encrypted: i=1; AJvYcCV2gqGrh6bGWvvpd4kz0Gda+S5fIB8pTVDjll+WSfAyaHL5OazAdwaGKsGQVeEZ0bApnTDR+2Fq7w==@kvack.org
X-Gm-Message-State: AOJu0YyvD7o0ipA31yrmxf34Gok3IzkS+mvoYTmU4p0WU3csCJWyEsDT
	i8l9g9YFDYQvoOZT5E0J3gm7F5flEvZsuWr1QLWMWxeUjY5uF/yTOt3sllu/Z3UmQ8vY1krEqxV
	Db4c9tFmNaiGjB1s4Z35qjF7pva97Aws=
X-Gm-Gg: ASbGncsZ9cODK+KVrKdHUxLcoy0NeMMjJ4dMl3x9kWMZs11C2SFLs8xmEzL9pGWhMpn
	xHeNhAhQBo7W8rwoS8uxfytQEOgrgC/i0uH1hqIPtNvkUh2rhxYK4OCn/kt6OlgrW2iU+nzmNSi
	3hMHZ/kUXyKwizDEPxJCqK6PB0UQVEOVH0GMDekPRvgVuht49j8mBWnjFT+X74CYq8gBOi2ks1d
	smOMqcUUu5W4PlgTmWn2tdRBVr1Ppz8YTuaxQFi
X-Google-Smtp-Source: AGHT+IFl7dzGGOpBRgseA/NydkGTFZOWYjWGRoA+aFytHMvygeb0WWmRJxaS+K8TrsIzykl6wViA3ZMadBOP3gnRlPQ=
X-Received: by 2002:a05:6122:202a:b0:54a:a782:47c5 with SMTP id
 71dfb90a1353d-54bea37dc27mr4953333e0c.15.1759004836452; Sat, 27 Sep 2025
 13:27:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com> <aNZWTB_AbK1qtacy@kernel.org>
In-Reply-To: <aNZWTB_AbK1qtacy@kernel.org>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 27 Sep 2025 13:27:04 -0700
X-Gm-Features: AS18NWAh5kZoQgB4hGz8PTAEfvsQyei1Zk5nXGW3DAd6TlCiQepkU5cVpkemP2Q
Message-ID: <CAM_iQpWBHWscTbuUm54G3tvqf-EQhSYaFJqEJD4M73doeH=TKQ@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
	Cong Wang <cwang@multikernel.io>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9590AA000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: jdouwjz7h5q71igf9j1mj3wfejphoqxt
X-HE-Tag: 1759004837-917923
X-HE-Meta: U2FsdGVkX1/4ItaEW/FrW5cK9rJLxI38YR+xQJTGhjDMU/9Jx7z0VpPSlQUmYbFNZyx8kbJ0f+R2xKhm2QV8/mGMjtPikpgdkZgoB4/BikHAvMBsk1QOGoKWGnwzwB00Bhfus6htYGOUQAKUOtRHAiZ3yddkr71D0uIFDBnWThhZR7meQhMIzE0xvWANl/f9mCfW5dwejUQgDHjLIywQeft4RA3rxc3ZVrjywZaLR0WgsqVFbbe7PklioqpElQjvRqHhtRDnrL30xWr7N7JlqUK1CHOBYfLS0/f7+XXegRJRwMzAwl4mGjxsR/uj+Ibpf3VEAbmf1SLCQH1sESOcgy9kyyTBG8ubxw/v/cT0d3FFU7Ztxmsv4cnkooXxeraBCHNSbDrgtszDEhIWqLVMO9+5b3L4bJ81xUro+WTLdufZm3Tf2aEwDQPDe7RqW0uZDnF1yQyPsJ1bQgGrvfQ36jhCD8Lcbx63KFoWNpNN1I/p7/r/dLDK8ceHZanCnWDcLjaa0JCd0muygnJvsfV9UBW1MnheCEsIxIAt+zTxNNezXsR6XLygMGwcVfvqxiNnExY1a3Tuk4nPBIP7P1t5D0fVAB6EJT6HpwFO/+QsBTm1Ofaefpf1Kb24jf+35d+AssaDIbojmXqdbHl8vMzKC1JCbp8XEkJ8VmvMDbXNltFX1satrWKksvNom8qQu/4c7d0CBti6N0MVVX6lp6yVi5p+dkDdXtH3mq1yoyxc6+JaEXte5IA55SYrkO+YaEnmudcL5lZ0pTRcbTvjyskpmD3j2anj6k6Ep9gDF4k19YjZPHR/Oyq3Bf7hvH1dCcGKmGnVleuVauY2IMVeFqlBe1ys5CsS+kJY7TP8j1dd00St9tOyjg1emip6SwN3EixSSoopGx9ExZcAqyYRSWHZw8naeEAKMigIV1rFwhWLxtUA8tZscmjSdcQ0P7+eVrmoeu8x39Nlu6UCniX+sEa
 CQ1CnGry
 ei9Pw0YbqQiIzB64evqSOgdch5LCtpGfiyT4wCkjmwc6uldpGZkcxkDviW606mzcOvxpDnkhNY656IVQr46U6Q41gRQ7T91JFFq888mDw9NoaEbjiBLArbVfERKx3+6/JMcco0OFSAuo+KY+bXnIlCJJTYbQiQRimK5Ap+UGPNw/19wdb99QHiemesOKqwqqWWrjnmZD6iAW1gEVUBXnQr0Z0YeIGVACJTnhvP03OML/tLCS4Ssx5tvg9iG3o385evlL/d4Gx64KZXGuSxvL2Y3lgc3rJyas/vMuQNvYMafz2H7ZatnPV9u5/nRpFzGBpk2shAU+DWXtTGisVyI41LozfrLqVjGAYJxxLOr82/dJuDY15QPr0AMRqCmydjBfor3pIzmVaRQsHL/r6xSVgHyc8NTsUtBd5hY0N/HqLYBy9QhL/A2eRg5rSwuprhi0I/1ArabdMA3mt32/YJ6GMDftowVYTQsq/iFbZ+LFUzKCfjVuWtnN4kYzU45Dm2r0xyh6x3jrDaIzrEqRjbxACsAldl29alJQduB4igIdUgFa3S2RNtnu7N4vEXwv0q0mIs2c4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 2:01=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> > This patch series introduces multikernel architecture support, enabling
> > multiple independent kernel instances to coexist and communicate on a
> > single physical machine. Each kernel instance can run on dedicated CPU
> > cores while sharing the underlying hardware resources.
> >
> > The multikernel architecture provides several key benefits:
> > - Improved fault isolation between different workloads
> > - Enhanced security through kernel-level separation
> > - Better resource utilization than traditional VM (KVM, Xen etc.)
> > - Potential zero-down kernel update with KHO (Kernel Hand Over)
>
> This list is like asking AI to list benefits, or like the whole cover
> letter has that type of feel.

Sorry for giving you that feeling. Please let me know how I can
improve it for you.

>
> I'd probably work on benchmarks and other types of tests that can
> deliver comparative figures, and show data that addresses workloads
> with KVM, namespaces/cgroups and this, reflecting these qualities.

Sure, I think performance comes after usability, not vice versa.


>
> E.g. consider "Enhanced security through kernel-level separation".
> It's a pre-existing feature probably since dawn of time. Any new layer
> makes obviously more complex version "kernel-level separation". You'd
> had to prove that this even more complex version is more secure than
> pre-existing science.

Apologize for this. Do you mind explaining why this is more complex
than the KVM/Qemu/vhost/virtio/VDPA stack?

>
> kexec and its various corner cases and how this patch set addresses
> them is the part where I'm most lost.

Sorry for that. I will post Youtube videos to explain kexec in detail,
please follow our Youtube channel if you are interested. (I don't
want to post a link here in case people think I am promoting my
own interest, please email me privately.)

>
> If I look at one of multikernel distros (I don't know any other
> tbh) that I know it's really VT-d and that type of hardware
> enforcement that make Qubes shine:
>
> https://www.qubes-os.org/
>
> That said, I did not look how/if this is using CPU virtualization
> features as part of the solution, so correct me if I'm wrong.

Qubes OS is based on Xen:
https://en.wikipedia.org/wiki/Qubes_OS

>
> I'm not entirely sure whether this is aimed to be alternative to
> namespaces/cgroups or vms but more in the direction of Solaris Zones
> would be imho better alternative at least for containers because
> it saves the overhead of an extra kernel. There's also a patch set
> for this:
>
> https://lwn.net/Articles/780364/?ref=3Dalian.info

Solaris Zones also share a single kernel. Or maybe I guess
you meant Kernel Zones? Isn't it a justification for our multikernel
approach for Linux? :-)

BTW, it is less flexible since it completely isolates kernels
without inter-kernel communication. With our design, you can
still choose not to use inter-kernel IPI's, which turns dynamic
into static.

>
> VM barrier combined with IOMMU is pretty strong and hardware
> enforced, and with polished configuration it can be fairly
> performant (e.g. via page cache bypass and stuff like that)
> so really the overhead that this is fighting against is
> context switch overhead.
>
> In security I don't believe this has any realistic chances to
> win over VMs and IOMMU...

I appreciate you sharing your opinions. I hope my information
helps.

Regards,
Cong Wang

