Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CD7C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 19:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C676B0005; Thu,  9 Jul 2026 15:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6139A6B009F; Thu,  9 Jul 2026 15:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529A56B00A0; Thu,  9 Jul 2026 15:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1A86B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:05:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2C001C2437
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:05:06 +0000 (UTC)
X-FDA: 84970165812.19.011ADE5
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id B353D140003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:05:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hOvCjM6c;
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783623904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNRtJyB9QHVjAm5rxzEf0kABc3aKI1V0CftN11/9Smo=;
	b=k+k+ZcOc7bILEzHC4QMbSZjP3nziCOnIEMm7FFwYsB4NxJmHESo3TeZ/zSpboRUt67gJfH
	bYOqNyptqcIzirn3kJFh6RXBvKlfbaKy+CE4hblWPjGt+iIVo5bqoNeSpkEcc9h8oOGeT0
	lXnQRauV8HpN3KUx6HBMLB/uuhdsojQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783623904;
	b=oj3iwiqmhfuyzWji+WFHaqqh6wwVNVkgyzbExlmlBBgYDzntmQdwMDLq0or4Z/IbiHwn3R
	yWygplRzobWBM/Z5WJ2GIDX/e6B0vB+Vu/APhsfYvBMsl+Fr6gRMkRy6iRyJDYBcDMj0AE
	2W3/Ua5nOuN8juxiSy/P3z7npe9/dGU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hOvCjM6c;
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15fd3a299eso28362966b.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 12:05:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783623903; cv=none;
        d=google.com; s=arc-20260327;
        b=kx+Yec/YKhsUxK8JPSQ1fKXxgIF2ejPhvGr2MAhAUsevTzCoCjbBKvX0TbInYoTJ2O
         Z3tziX4I1bb1aYI2bcKaScOjXmd/AmtSKtIbqnUSx+isi0Y+8HZ7Nn1Td5Hfm9hgyXEA
         QvKHMQRYrcZkAl4LpzYnyzLTLY7twvEcu7Aut6CE2hqpOr7HOsSXY99f9YGTMSZEoXdQ
         vHr6Tvd7fuVn19iJQrLLOP1P5I+ZjjwCwF7OLqw+g01lcpqim5/bSK8STCeewweLfz6r
         41qRdpbCN/ndXvlmnp5sxWP4sxG3vWJTMS4vtOgbTtU4Hwe49hRh4LOV9VRuoaQcdxtE
         J31g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bNRtJyB9QHVjAm5rxzEf0kABc3aKI1V0CftN11/9Smo=;
        fh=cCcEWB4qQupYOuA7+gi2Hkel8Oce8216egrz313b07U=;
        b=N4EaY2ZkBe7sByutQ0xEvJ1odlVRQR+ZivV2XnGYUSlJ++u+RTjLi4KDWmDZFIe3Pj
         QJ05AoeDA/6Au/uEqw9WJ29G9wD9UEj2AG3ePayNFqhnFDHuGRnN41RCZtjKp8h6LnaB
         zX1AP3T5g7pI5ZSms80AFBJvmfqQ+BhUQ/cRhjZBvusYKpombDhryfvtBCMnlwWlm0Lt
         ZCb4XN795YlNVZROu8piRrJpd0QBZIwxAocBiz4ZXMiYLM0rcUmA3TdgasRS8XMoKxtA
         qv1bOj4nr7d7AJUYg1W7o+0Z7X7xARHXgSZM/crADs4GMPIRBCc3PpEnNGYPFo4WNkoz
         i+Ww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783623903; x=1784228703; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bNRtJyB9QHVjAm5rxzEf0kABc3aKI1V0CftN11/9Smo=;
        b=hOvCjM6cZbFOR+uBzJDUZsS20w8ECbXBrYAONKojOm08e+mWEbT6iRpX0BrUmaLLeN
         eK1XnIm1livh4BS+uHE5EYAvJexLevljsOg3NfCguABpyNUXzm4zWuwrrJpz/Mv3/DD4
         H1ghx2ir3KqjSidJ0sDl6FmYVZtVTMyQ6EkTPz78LQkhOhBT6FMs2VZdz/YRg78zZ5PN
         2njtuC2yHPZcfTnV4GjhgBGpfZIESBPMBLiDsJcWtYoSIXjJorN3TImcNJggCcqC/XEJ
         18feqtkfkSWCCvkp6G5QWn0TkXx9JyuW3Gw8MVf/syGu7gY66xRRcAsZPSwIgMbOYK1J
         arIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783623903; x=1784228703;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bNRtJyB9QHVjAm5rxzEf0kABc3aKI1V0CftN11/9Smo=;
        b=TCBHNIu3VL8d+2xe2Rwx6YXoIpBW9jJAMr2EfdO7Ke++KDpqaw+9tLRb6txfm7JnMt
         L1USWBFGSWEWST/NCBeqnmJcxwocxX7kvBSgvGq+moRqUgTEsrOX3LSHt7/5vFCJOSAZ
         JbySuPgfW6PNWW52eFrjmFgAGOc8h89qfpxi2O4aJ1BHMhPch2rYaEdvvtC8FTdyPDR5
         DSFd7YQ+PbFOQRnkQJ058PEABrTmEPitt3ewRWoUmQ1S991XJ3x4AOkZKf4iisKPnWZX
         V9xCKgnp77rOdszU0msyM6Wn8wtYv3qDO/1i8MuqFILEF3Mn2OKdPkWTGImyp/o5XKAX
         6noQ==
X-Forwarded-Encrypted: i=1; AHgh+Rro3l5eK6N6VpprrG2QeRqiLP7nL17Z8z+nEQM2bYtuk48gnE0whDCgqakcCjOMq8dtQwtQ1GCqkw==@kvack.org
X-Gm-Message-State: AOJu0YxnNp8R4wsyjwCH2x9QLOw1PDH5VLjh2THNYw4gTXEsd/L5awzj
	GQFWVEVU4zrpEK2aA11LQF07ldDfzZ1cFdNPm6sJCE/JBchNyXYgVnzvcJfosaMN+Mv7bz5bJDR
	Ar8cpA3E2BH+P5xg9Cp3Erczt60qKGOHMXd/Z2q3s
X-Gm-Gg: AfdE7clsvUZx//FWezXOICjn8IMLR42FVkRyVXtCDI8RaeiLqZaCIBYAOgKYYkqifk7
	Co+rc070D6HgZZmJvG86jEH+ZiHMqMRSw4qRjQvZjJYSHQirTdWqqBUyrUtnxFucb5GjdmA0rS7
	mlXJAi/FRWXNB+0aUBUx9QGFawzrM+ZZgaHDZgIhgBYMO5amwrV+V9sZUJL3kJnGMH/qdWcCZLn
	ZgU/D8MjkeuN59XQ39oJV0okn/oWSCSk4O/nTVTQt/4c2X09B34D2NZXI8Fx13RcesPxol2ShXZ
	s4YzG9j41YU4Yr4Ohe+0rhtERVAXxgs3sKt5HBPNdt2cLHPfr+mMHBLs3i8=
X-Received: by 2002:a17:907:e153:b0:c12:aaec:3436 with SMTP id
 a640c23a62f3a-c15cdfeac35mr299077466b.14.1783623902587; Thu, 09 Jul 2026
 12:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <FC9E78F0-8FF7-44AF-A848-8401B4702488@linux.dev> <CADrL8HVkrojXbBuEX-W=UHBmyyFzqxdGBvtAoPP53SyYa10uag@mail.gmail.com>
 <ABB70C2A-316E-4C19-A855-C9920BE105E1@linux.dev>
In-Reply-To: <ABB70C2A-316E-4C19-A855-C9920BE105E1@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Thu, 9 Jul 2026 12:04:25 -0700
X-Gm-Features: AVVi8CcfpMMaiNKWH9W77S2UuJGk4oIqw9AGhPYaowbYWta-f_S794HnODSYVjA
Message-ID: <CADrL8HUCqrzOQGXRDwnitintQHjHCw10n8wo6gChQ2tWvC2JBQ@mail.gmail.com>
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B353D140003
X-Stat-Signature: yamx8fkpqi65wzszak6qcx8hqpndywbb
X-HE-Tag: 1783623904-672507
X-HE-Meta: U2FsdGVkX1+jjkaH3qQksXVi/oRHjBMm65IY87IsKnn7FeeRRPvmNnaUW8n9BulX2UY+Yed0WMppoPVDRN0oyppcorUAYwGA4kwQUFeQSA1ARA4N7KIVGyN2LykK3LTkyEYPVw1jXMEQO1tC6zOArqmrKGvr3ZzXS1EuYRRmG0pxYLmOLU4u+tuHVr+sxuPF1xUiGbJpViAY6QMRj8p291bBaeKmO0eOKACUuginDHWm5v4wBnJM3nIGs+AskbqEsGGKVrkbKy4Heby8491+6f0PH265HAjsMdD3aUYrp4XrkR/RDZBn1vP6fxXMHQGFBukMB9K4TxUpC94Vm3Lwnma1DLwfAUhOsFbRxWNAA5fckropc1CLp0TtFNtBtKEaOSBnm+ymmwI7H3cEGV15H4ThAXpLpVcBXOzBua1CoFUL0ThL3AVdf+tg6QmFkRkavjRWUBQr84tDk3E3MBkc01vpPBiIV9OsA2dNkFypW4cTqm36s5m4XAxdlC9426STzUavVa2fhfTVY0mNpOd9zWLTgT8BvlITTIyxRcH1NQJJC+b7CrP/6TherMJZKCh7J3BRZPs/s0HWMMS5zwO22+XcksTbvp2QIZCmYmvTNRB3juVRSDv0gruRk8uKWRaENBzD3dTGl0a3w+pIs4bMITih6M8hf/XA4zIVONLl0FSWyYG2R9iAG3PlgDYpBzrgIzW9pqFrAcNk7JPu3s9BrsIw2uIOE2WcqqcaiPcYUULOmZmJnayzL6v2RJ0TOUzrWrHR+LXxQPDXBDw9/DYtZOCI0Wh920miJXz2PyyDuvQwAUxo5qgbLQ+JgND3VSXxADEGHYVPa3jOU8yrtanRbLy/0rJWr/HvfaqGQA3Vl1oHYl5XCGJMgd7lVVjn26UupWLpANoMh1I5DfjMnOs1/xZDqVVzjEkZdGxq46nSiv6dUi6vlHuj1TH/lKkKV05B+aOyVXaMTd3VpiZEsHk
 Ev2gi0rR
 Q2r6rN4iL5Tuxgwcwj591CfG4aKnRj6PJVL5r8VY/lWYmkSenRzIk+RYw7p6RH1PGRUWn9e2/dKto2PXHIKocOydsGsVYm78w7r+ZVn0JezMKza0OVhdVAP7EoyRgqjnJoKIqCGQvpFca5hTn+8xg5+ebgRSCWpXXLDY4TB60Mz5w1zs4o7Nwy57pXtRlsflQNgmI/tN8oSej5/GLRFo+oaRoMOKfu3sxC3OSH4pZvA/qjHCcNV9u/odP+Xo36pLjMLHmBB4q6zPwsKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 9, 2026 at 2:55=E2=80=AFAM Muchun Song <muchun.song@linux.dev> =
wrote:
> > On Jul 9, 2026, at 00:49, James Houghton <jthoughton@google.com> wrote:
> >
> > On Wed, Jul 8, 2026 at 1:41=E2=80=AFAM Muchun Song <muchun.song@linux.d=
ev> wrote:
> >> Do you mean that the support for AF might vary across different CPUs?
> >> I'm not that familiar with arm64, so it seems a bit strange to me that
> >> such basic hardware features can differ so much from one CPU to anothe=
r.
> >
> > Yes, hardware updates of the Access Flag is a per-CPU feature. It is
> > available for a CPU to use if TCR_EL1.HA is set. TCR_EL1 is a system
> > register; each CPU has its own. (Linux will always enable HW AF for a
> > CPU when it is onlined[1] if support is advertised, so we simply need
> > to check if support is advertised to know that it is in fact enabled.)
> >
> > These days it is not uncommon for a system to have two (or more?)
> > different core implementations, like with "fast" cores and "efficient"
> > cores.
> >
> > [1] See the CONFIG_ARM64_HW_AFDBM bits in arch/arm64/mm/proc.S
>
> Thanks for your detailed explanation. When enabling HVO via the cmdline,
> can we simply prevent CPUs that do not support AF from coming online?
> Would implementing it this way be much simpler? In practice, developers
> definitely know whether the current system is suitable for enabling HVO.
> If some CPUs do not support AF, they would just need to evaluate the
> trade-off between memory savings and having fewer online CPUs than expect=
ed.
>
> For scenarios where HVO is enabled via sysctl, we simply need to check
> if all CPUs support AF. If any do not, the system should return an error.
>
> Then, we can proceed with the Pre-HVO.

I don't think it makes sense to try to implement pre-HVO.

We cannot do HVO if any boot CPUs do not support HW AF, as HW AF will
be required to free the HugeTLB pages later, which we should continue
to support. Pre-HVO (today anyway) happens before all boot CPUs are
onlined. IMO it is not okay to prevent boot CPUs from onlining.

Let's say for a moment that HVO cannot be toggled at run-time, then
the best we can do is:
- If a user does not specify hugetlb_free_vmemmap=3D1, we can always
allow onlining of late CPUs
- If a user specifies hugetlb_free_vmemmap=3D1 but not all boot CPUs
support HW AF, we can always allow onlining of late CPUs.
- If a user specifies hugetlb_free_vmemmap=3D1 and all boot CPUs support
HW AF, we must not allow onlining incompatible late CPUs.

HVO compatibility has to be modeled as an Arm system feature. To
support conditional onlining of late CPUs based on whether or not "HVO
is being used", we still need the extra cpufeature.c logic.

So if HVO cannot be toggled at run-time, we can simplify the
definition of "is HVO being used?" (for the purposes of determining if
late CPUs can be onlined). We can simplify it from what it is now
("are there any optimized pages?") to
"vmemmap_optimize_enabled=3D=3Dtrue?". That allows us to drop patch 15
(which then needs a slight change to patch 17), but that's about it.
So this is a slight simplification, which is nice.

If you (or the Arm folks) feel strongly, I'm happy to write this simplifica=
tion.

> > I'm hoping you can look at patches 1-3 anyway. I think they're the
> > right thing to do, even without the arm64 changes.
>
> Yes, I've looked it over. I think that making modifications across
> several areas will be much simpler on top of my refactored codebase.
> For example:
>
>  - In patch 2: There is no longer a need to move vmemmap_get_tail().
>  - In patch 3: Handling partially-HVOed pages becomes straightforward
>                because vmemmap_restore_pte() no longer relies on
>                ->vmemmap_tail to detect whether a restoration is needed.
>  - In patch 4: I have updated the ->remap_pte callback to return an int
>                as well, making it easy to adapt your changes.
>
> Overall, the implementation is significantly cleaner, so I won't list
> every detail here.

Thanks! Good to know I can basically drop those patches. :)

Please CC me on these HVO simplifications when you send them out, thanks!

