Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA6C7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00456B00A9; Tue, 30 Jun 2026 18:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D74F6B00AB; Tue, 30 Jun 2026 18:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF016B00AC; Tue, 30 Jun 2026 18:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2E66B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:55:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF2A0A011C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:55:41 +0000 (UTC)
X-FDA: 84938087682.23.A26F424
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 07FFC40007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:55:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TDmZAnb6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782860140;
	b=ueP9JG6i+TiWMT0DAZrcPLVr66oSRvbHqwL8SjtVDvJYQwERBmkFePIEXYsrZt4mLI2e8Y
	M5BMF8qCD2DoIrHFG4YRs/GXlmLOosfC/BDCYuNCWU36STs6LAiCQi1fiPcqM1nC/Q0PTf
	7253wZLO1TKbKL43vxOWyDCxpoJSnrY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782860140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ufRs7jbz+7zNErx/AfaA1flmtddekdRBnIktmT56h4=;
	b=EwN3D2Kvh8QXQvRGdpTiy3FvDNdLX68ckejhBJmWxrcpE/DjQRsNagghIKzVq01OXpRBLn
	lNuxH6bmn0UWgmb4KnnraAmwaVIMvuxMBueOjVaruERbmoLaeWk8Yz0GlFlAYJZC5k65im
	w2ZTEPcVWvfPr43neLfesy3RlNtvCUo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TDmZAnb6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-13b2d7dc8d1so6394c88.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:55:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782860139; cv=none;
        d=google.com; s=arc-20260327;
        b=mSANbnWpoPvRLlS1v9/mfq6fd188XBc691Ljf2uYAJSscSmzQWvtvqoIW6k1cr4405
         FgbWcu0w+fZrN+VyvK0HKaCx+1GXrS+T5qdqeeEZbzc9ulNE1rJGO4PXW+gkeopNYj1V
         yTn3Iy5OF5G3vU+19CADclvtdu3mrKh64nbai+zeuB5aEQM3h8wgnmNtkzsDH3/+Qpj5
         zqL1iGWBTUkBdylt1w+vKKgOV7gamQtzEufzAZHYacFyn6R+2VchVgJ92K7+myseWZLo
         BW8g8qFL8cMIpSg5N/YbIvHKkX8Ywu9nJ/rwbR84SW6prIg1CdHb0uujd/U1bNu9fmYY
         MCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0ufRs7jbz+7zNErx/AfaA1flmtddekdRBnIktmT56h4=;
        fh=XVU2F5Ayyl7jula6E6E0GpL/+ytbD5PyZvthvcUROZU=;
        b=LmqvuU+UVhRNtUXQadAFTlXarUFyoYDzig/Z6FeLuPQotgxKygjC0X4EO9hG3CKKrA
         D0VjXEHS/nkD4PpNmlX4lll6OKuO4sodKBwKyDT+cg6yZlirBboQsh8j0idHI6NURaeY
         Snx892h0/npphNbKcyZLJeJzKgjhb9MohV9IPSuu3ugl5r7m2RCdkbUWYwJVTkqrSiPq
         7tOLpXNIpCdAVRrUbiqvzdwil/171U7DrqqYfPYd67tOfcFAUNNc+0cxDciIOCo1DlYO
         PyCEmmT4xitHUar22G92JP1ACso3OBZkfmVlje5TQblLKkNWojzFRvY8tWw60xY/ptfe
         0a/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782860139; x=1783464939; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ufRs7jbz+7zNErx/AfaA1flmtddekdRBnIktmT56h4=;
        b=TDmZAnb6Tl5EgjRIMXKcoijNpdHeBKecZlg2oDG++5vTPDv+AJ9iB45HBPedwysUf8
         OR9D7uE410OdqA8MQJ01aj56Yw/48YRu/jmVrLMCsRpXeZtrblWMIw88Hny5RJStz1Xt
         qK0Gbtcpco0BpTLc67P6nJcAzZJg8B3r1qCCGVzbW2BwIXIeCDYJwlzoaIFe4xCsf26Q
         +BR79CueWgQVWoMsHIUaUX9X8fG71RoRASc84h3cSQ9HYiXw7fmnRsc94+cV0bs+QfDj
         IBUecTu5IVuS/782KB1RqznLbi+YWssS8TmDdXf1FWVlwHstoz/Dle5xJws9aMOl6FUl
         KzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782860139; x=1783464939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0ufRs7jbz+7zNErx/AfaA1flmtddekdRBnIktmT56h4=;
        b=ZeVtf2TSmlNTbO95D1TnE0yIsxCX9nD2BPUr97CvIwBbLxwITh2VPYIrNNVADXIOh6
         di5UjftEV3bxvUAJe3IS0quFX47PYMRuqgYAGCePXO/UcIJ62PuidB/SmMwV7ertvzWa
         Aw0rXXc3ZSIiXu0xU2msey6wEZCx/itH/Irg1Sbsh5dhv17JdKHpHHE2w+6GHjk0mfk2
         Mxg0ifmBbDkEix22VNiYfD9c1+UMaFCFzks2G6Bp+Qf3Kadd+tCdF6uSOx65LHUWVuuL
         r9RiJht7BW3KHPl5rxBTFHZn0ScCONapAsf4joLUgr3aeNE8B02BmwmFQedrqIK24skq
         WkMw==
X-Forwarded-Encrypted: i=1; AFNElJ89NdZRaTYb/UDAwyRUA6LOPQk/YbIbV90HI+8b1JBSU+LI+8EinvBv8pV6Imt4GK/cGpyqqnp1kQ==@kvack.org
X-Gm-Message-State: AOJu0YwgjWWaT/skwJPKFjcYBY+/kHVAgfpFHczLx9rZEObqjmX8jU/H
	AzajMhDLanvAoG4Yp3Mq1JDQfWIhnZPGeGUUfktBiLhgZdof5qqqugFDo9BStDUTtDSoGxQ+BRS
	sJxt/xHJ+l/G3zC8CukCxdQyroFaUFOLs06cR1759
X-Gm-Gg: AfdE7clskzGckjVpjp80UEnCLwnENcq/SJhD1jPwEWL4LISud/NOQulU7gVycmM9PFq
	VKKHt+ysZSPcaxyDNDvNz3zHv9RkBpTm/Jk4/FUq19VK0ypstp5R0zOBOw5wit8HfmvJZom1Wzw
	vrcu5T4FzbXYrc5R+iLGlcO+GZku2WsC7+2e21jrdgEPetTixHvzEDS/As5RVlKZbeag+ZaqymX
	lR7Kfb+8CYFgy7YrM3ZpHfXApTzwCWt82ctexc1ueW3pCIL+Eo/mmujwZm2o2dM205cSbXy
X-Received: by 2002:a05:7022:60a:b0:139:ed5d:1b5a with SMTP id
 a92af1059eb24-13b2a1c0f41mr3645093c88.40.1782860138109; Tue, 30 Jun 2026
 15:55:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260625054946.73445-1-duanchenghao@kylinos.cn>
 <20260625054946.73445-2-duanchenghao@kylinos.cn> <2vxzfr2bkn0j.fsf@kernel.org>
 <20260629100621.GA215869@chenghao-pc>
In-Reply-To: <20260629100621.GA215869@chenghao-pc>
From: David Matlack <dmatlack@google.com>
Date: Tue, 30 Jun 2026 15:55:11 -0700
X-Gm-Features: AVVi8CdC-YicerQYwyKKogj1zQs5YRNCTCvCtXWkU5DiVwwhFHMSMIyXZ1dV4nA
Message-ID: <CALzav=c+RzWpJTrpsdwnHUT=EZCGv=FGtmDq9ipDE7jNuWNX0g@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] eventfd: luo: luo support for preserving eventfd
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: Pratyush Yadav <pratyush@kernel.org>, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, pasha.tatashin@soleen.com, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, jianghaoran@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 07FFC40007
X-Stat-Signature: hbeqd5f1es4nrsqu3bq63n8mnxze456d
X-HE-Tag: 1782860139-456853
X-HE-Meta: U2FsdGVkX1+tO/D6/rA03i+WTM+kuDG7b3KU5fsDDKybAEF+C1Whezy4ikOUywPpy7Wbzm/SBE/SOX0PHlDbXd0VcOf2FqOLfaKvGyalBkilYRm9M2jKre9Q3FDTOgoLZSLGPPpnnln01t4kyaySsDrYVMNUl6aqe8Lzv02GGsYrX3gbjrUeK7rMlzxbCUiLBbQpT13NHfseAcOZ5AR0V6iGFt4bE158vUfZGyeWyEoW622OXCpbccr32k/RmJ3QaSXACN58yPUq7YKDlSgsk0XFVF5vP+XvjV0icwmeD7Tef5bxjHOM/d5nOX8JIsq1fanVoZcDtbIKGNkNxrl2Bd7CvaHx3QgraQYtm1wHcJyaNC3ZQuutIzggfZQ8agk2Jryy6H5ShDtWC+L4Po1fGeXJ6uOo8m6P2tn5OnoSFT1GAAxP8sb6/DJiHxwZ36vemK0ECeVwWYa12FOutI4TtBvaryQuHokk25n7s+S1MQInHHAZoOg1uUaPN0uR/u7EOcs2DPOfaZjUkYDustwJ+4eABquSN7UYNZkQiPDBB/Bnfm9jwP2Z5dNXyLhr/4VBWLpOnOkB9zA3OdDn9Spdz0e4LemT9JoUWgdfWTXvLZ8kVkFzCpM4PvSoR35kpD8n8jeDSMKo7LcYOkCKRj6HpZA63i+TzGG7MSsUSiw7LeEmRmzS6uq96b1mTU3Qvg6FqbUAYMsrMD1055vJZwN73VMjqCLB/AVVeyADQqj9xbjBXq3hBeWKWGyYphSjG1d5bkdpqlr7qmU+UB4FUqh2KL2eP0kiMo0rGmLt6XhX5zB21+Bt6DoTzGNEa9RweN31fX4Hw+g8h4AL52RFR0YCjDVCK92s2HFq5iyV6bJ6MbfgQX0qN6Zc3E81t/JZVT72uz7w4yO1AeFDpRC4cyRaGEMv8iYh3tJZOLkWc0MYMEG/RB5lx6M3GPjRmPL3R9UsxD6hfnu47Wa5hm2f0VD
 SOLzxNrS
 8dM86VIHi4lzlbb+blCT0tA2JRqEAoEnKJPDqFDihIPotLcN39X+5z4/V7eQ1dLsGWukQ8JgGgQlZM42oUslx1EEcBUSbQBF9uX1IVLagyMhmj3ac3CRWKWB9pZUMLAVAL57DdWixcI3aSKjqPsO392nNKGOe8DO2C7b0M6lRrL5S2dRaJvymboPNM0zcpSgg1FIilx1QpT3fwDw1lrjBRaJnSbQ1RV0GXPq8hfcd7ic9ySL7ZOllWo5R1MJaNR72LZYvtq1s5DSVjsA4bp2BVpcmXGq8VttMnu/H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 3:06=E2=80=AFAM Chenghao Duan <duanchenghao@kylinos=
.cn> wrote:
>
> On Thu, Jun 25, 2026 at 11:06:04AM +0200, Pratyush Yadav wrote:
> > On Thu, Jun 25 2026, Chenghao Duan wrote:
> >
> > > This patch adds support for preserving eventfd file descriptors acros=
s
> > > kexec live updates using the Live Update Orchestrator (LUO) framework=
.
> > > Userspace applications using eventfd for event notification can now
> > > maintain their state across kernel updates.
> > >
> > > Preserved State:
> > > The following properties of the eventfd are preserved across kexec:
> > > - Counter Value: The current 64-bit counter value, including any pend=
ing
> > >   events that have been signaled but not yet consumed by readers.
> > > - File Flags: The creation flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NON=
BLOCK)
> > >   are preserved.
> > >
> > > Non-Preserved State:
> > > - File Descriptor Number: The eventfd will be assigned a new fd numbe=
r
> > >   in the target process after restore.
> > > - Wait Queue State: Any processes blocked on read() operations will b=
e
> > >   woken up and need to re-establish their blocking state.
> > > - All other internal state is reset to default.
> > >
> > > Changes:
> > > - fs/eventfd.c: Add eventfd_luo_get_state() to safely read eventfd st=
ate
> > >   (count and flags), and eventfd_create() helper function.
> > > - fs/eventfd_luo.c: New file implementing LUO file operations:
> > >   preserve, freeze, unpreserve, retrieve, and finish callbacks.
> > > - include/linux/eventfd.h: Export new functions.
> > > - include/linux/kho/abi/eventfd.h: Define the ABI contract with
> > >   eventfd_luo_ser structure for serialization.
> >
> > Why do you need to preserve this? Why don't you create a fresh one afte=
r
> > kexec? You just preserve the counter, which looks pretty much useless.
> > You can just as well open a new eventfd after kexec and set the counter
> > value if you care about it.
>
> Thank you very much for your review and suggestions.
>
> My original plan was to integrate KVM with eventfd. Eventfd serves as a
> critical notification mechanism between guest and host, and it is widely
> adopted in various scenarios such as networking, file systems, and
> interrupt handling.
>
> At present, however, I have only implemented the preserve and retrieve
> logic for eventfd, and the integration with KVM has not yet been
> completed.
>
> I have a question and would greatly appreciate your help with it.
> I have been closely following upstream developments for the liveupdate
> feature. As I understand it, liveupdate is primarily targeted at cloud
> virtual machine scenarios. The upstream community has completed the
> core framework for liveupdate and memfd, and ongoing discussions are
> focused on state preservation and restoration for VFIO and IOMMU.

Yes that's correct, but that work is to solve some very specific
problems for virtual machine scenarios:

 1. memfd preservation allows preserving guest memory and userspace
(e.g. VMM) state in-place across Live Update.
 2. VFIO/IOMMU preservation allows PCIe devices assigned to virtual
machines to keep running uninterrupted across Live Update.

I think this series is missing a description of the problem solved by
preserving eventfds. We don't want to preserve all types of fds just
for the sake of it. That will bloat the ABI (which will make
maintaining version compaitibility harder) without any gain.

>
> I would like to clarify the following points regarding upstream=E2=80=99s
> overall roadmap for the liveupdate feature:
> 1. What is the complete upstream plan for liveupdate?
> 2. What will the final deliverables look like once fully implemented?
> 3. Will any new kernel internal interfaces or dedicated userspace tools
> be introduced?
> 4.  Does the upstream community maintain an official TODO list tracking
> outstanding work items for liveupdate?

I don't think we have anything comprehensive but there is a ton of
work to be done if you are looking to help.

A good first step would be to attend the bi-weekly Hypervisor Live
Update meeting. See
https://lore.kernel.org/kexec/aiWW6ZwwalqQmVcB@google.com/. The next
one is on July 13th.

