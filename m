Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15454CCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296C28E01A8; Wed, 29 Oct 2025 20:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183468E0106; Wed, 29 Oct 2025 20:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BB28E01A8; Wed, 29 Oct 2025 20:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7D3B8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:52:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DE775BD53
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:52:02 +0000 (UTC)
X-FDA: 84052953684.20.E25766E
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8880A1A000E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:52:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RshgAeR7;
	spf=pass (imf19.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761785520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6xYVmnl8b+pLdde1+Tw/tk8i/p4aUKZYm7+ZE7iZXM=;
	b=I3o3hSQBHBu4gtXZ0MmuVQXOwb2Thbm9xQiRG/n+ZvYhtgqqSgDu7rYxNDjokHi8F1KWlr
	qzFeKVh1DH4eVdTUmRWt3QJ4KtxlWP9Z+irYixEAn2EjMhMTqQFvH8CGHZlS4RwMbohGqz
	cTr6nXcFAYWHGZoioqgP2sTtDDj8S6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761785520; a=rsa-sha256;
	cv=none;
	b=X9Dl/A3K+iLp+nV/RBUsCxCbloB0s6JOvXhyAplU3X/ZajypXwiejWS9HZIvx89LyDXjuf
	HACyVpymhkMDfpFuMY9Wo00WYZzwoFaRLK68tckEFSh7fALi+6xJPWAr/99sHZTdPBv2I+
	GNh9Rj7Jf+xESM2XlyJmIr0qnb/YbGU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RshgAeR7;
	spf=pass (imf19.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-591eb980286so477851e87.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761785519; x=1762390319; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6xYVmnl8b+pLdde1+Tw/tk8i/p4aUKZYm7+ZE7iZXM=;
        b=RshgAeR7OKrnjP5JxRN62LyCFxZGlHPXadlIvm8ppsnOJb+lnKznBOJft1H95tQU+n
         uNbYOcx8/JHvhuXXJUuOIYI9JqEMVy11TevT/7GosLSjwGdzlGNiMmDBvQ8erssDfK6m
         F3R/X0m7GZ15euI0nk/HfWNaTA4ClZ1u/8DSfDnhmB9YGp1Wn0syowYUkB6hrzN2hTuV
         I4NHHjU6c5JAvh4u0bWmTwjAyTs42vDG08ll89ez4WH+RFCmGO5I9w9WnLB3z2XgGMFL
         72ZQqnHNXy664gF+p3FdEDlBdWvcDM23XcBmw8aNwPdVH6sM3vsbC7II3iy2jgquz/bd
         SVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761785519; x=1762390319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6xYVmnl8b+pLdde1+Tw/tk8i/p4aUKZYm7+ZE7iZXM=;
        b=Ehro3sTFzxtyE2FVFwwHABOtpMNCPYBcuR+7p6dITrrbElhURWjQ1IiTxiJgSevdUM
         1yklgjUoOJRQVLI7piv+LOBI/Ff/12Zs2RFGpb1wc0XnmTSJni7matUAM9BaG8iYaV1C
         BEzr8IJlzan+ymjQ1lF4EuA5emGyZ2GzSCGYopb5gv92uDqJJfi8h87CTa9RxV45K0J2
         tmm2+dWJRYEUTsPWXpaNe197bunzwKvhG6A2I22IT1NU87i3hVkBzOna5izMfbQu711f
         V8xIxJTJmifR8xyhs+rGxJgk20PanaatOFkpIaacsNr+L28cOj2HI/X19wYvU1OCpUMC
         TxWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJuzR/ZwJsI7i97xmVdGH1PcmiBlQIUCH7RR2EWFXlK6v63hA9VRjR5MYaAin9iVPfGVJACLk8KQ==@kvack.org
X-Gm-Message-State: AOJu0YwMGxhkLXydCsJYqJe5tjkxJymyW6BzBleq5kJDMaxHPEoHDA6h
	xvRw/OE2Mbv9TQGLYPH+BLMgrpH4i376Mak5WogjmJNorqfAWsuvBQQSTfyAfRqQRWCi4bw4hqG
	J91uoeOfwE63hc64U2KH1Raw+bclf0EbhpHE/
X-Gm-Gg: ASbGncsgvMnx4X6ZjJoJVxdCMHw9emHjL5oeVoQu7et9om5+4pqqT11six8sgOd8ZN0
	RaEK1FXUfIXrkxI4umrrKmgoyaLTdJz6crjukvCELnFhMMC59tBD5VlyQCuMGd+mgki1VK26oOB
	8w/sa5zy+duVXQ2ZM9NqDfjYnX2KYfhtriXW63H65SIogwpAoih9MIYqVGQhzlbXNB1AM9cR7jg
	nPJtB5/ODSDB4+Ek204wqS6GGj55+qWHZsA/ddBqCdEPeogtwR8BcmDmPUBgccjXcjJnPBaiUcO
	6hJHMVtbFNY=
X-Google-Smtp-Source: AGHT+IFdZTj0Hn5lC/Vz33gkwcmYRndHSNkKnofFZ76z08Ze4hO5Vx8hhDcwQ0bao3VwybyT2E/0nhovnOfg+xF/7xA=
X-Received: by 2002:a05:6512:1326:b0:591:ec0d:3014 with SMTP id
 2adb3069b0e04-59416eec041mr325368e87.48.1761785518272; Wed, 29 Oct 2025
 17:51:58 -0700 (PDT)
MIME-Version: 1.0
References: <20251022135735.246203-1-akinobu.mita@gmail.com> <o3gxx5uipm53gccoccjjdvtvv6gkyx4r7qexzdkg3uqtqc7wsv@yd3rqfsy2bpz>
In-Reply-To: <o3gxx5uipm53gccoccjjdvtvv6gkyx4r7qexzdkg3uqtqc7wsv@yd3rqfsy2bpz>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 30 Oct 2025 09:51:46 +0900
X-Gm-Features: AWmQ_bnbvcpSgNqDHKvXq0v0UY_X1N9SKnYP2-HI_1FlJU2e4PFTlTI_Dvk-pEo
Message-ID: <CAC5umyiA+KkQNTv-mN=mA9BXHmqMH9Trr_07XYOh=QTLLm=zNg@mail.gmail.com>
Subject: Re: oom-killer not invoked on systems with multiple memory-tiers
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 7j3fhhgqob94ban9gtbhtqgt648h9f6s
X-Rspam-User: 
X-Rspamd-Queue-Id: 8880A1A000E
X-HE-Tag: 1761785520-798966
X-HE-Meta: U2FsdGVkX199yX/TB98t259IWCG4oo5OlZsYyL28HhUyWum3EVGBnGDFjWF3r2T2aCVO9cJWhztsuE5w69SZnfaFLTPeRvykEYwxcr+va7TkG/I8xAHPUj0s/gB5kuP5v0LFJIRUKaSN1MLM4sVSsQH4Ad8N3lIIm08IRdifFBayIaxtSE9ofowka6w2OZhP5jHNVYYlTjZi+/WRJV+Ic9ntSv5v5f9u34JsfcR9x41lwDof/ZT2l0yvM678vli2pyiU1olmAVC9VZbjCUIHWvbzA4vmFLwJ7E9mq3Wxwlsog+8EJaTBUfuEx9V8TAnJZX9G4FQh12iRCtbN2bpUrpjShD+zQE4rQsIQC5unvVRYIoa9pXIwPYF6deRW18/k9TSc1kJQouGldWA4168ZHfIZGa6rOjvZmm09xetNkdhaCc7T1GlZ9jn85Y7DiowOoayOtscrT0Q5R737uMvBZYMwFc6NemT3HnfMuDiJzVpyH7hbSGr+EkANidjvV6xkWyARll4ecjHdCOuixlK/BhPxHA1yowRxCGfBO+vcM62+C9dLdue1/ceE+KXUMaw/AjdCmyqTT8ybm6ZdeU7VMn8YorGc1Oc7HOIJ07okRE4NAdYqXvsWoKp32khMrs9SdySxa+2J7mIipYwMpj1fcZgTS31Cxs4SK61ZnsbGHuNrvDgyHw5AUGE0a/jyEC6FKUF1WE+v5o/Lo7RrZely5B0Y5LGeNF5wyIF3fJfosS9jzMs3x7wMHy923DGs+V4HDa9pdOYvlHUEDy8ib0cAFEpXHZEhAlQJuzxWcWp373qAvbrKaqUeyRkkylhy6ubjDJnuZzc5nkdZUWTVKhHJdkjJq2Eq9KpQaa+Qf6B8J70TaTwlcaEKbPBx1ew20OAHT7HEK9qb6t54gexSNzNWyToDc8TPZ/suat8wcavZBkACFTJikkPfUo2GVLSFMJ2Cs8VJT9DiDEH5b+gFSMB
 OWCrp8xt
 h3SHfmTRpX5AmoM49d3NoB99UtL7xP7yU11PGUfGbrTmcHs/v91fbhIzqmUN/IsxfGUIBatp7nxVLX9P2p0psTO67jUdHwHuUA4kW+LNqu/VHHpW0STMGajgPGeIL1Tj9TwN8tB0O9mqhOGTl0LTVLGIzWutaYAQNBozCJpqBJ/kRPTCCJ5OkUxhBS+8pnHU/FoowPzrTLV4hA2M3svpgd1z5qxN5Ms08LPHdOutRfi3vbC51c01epiPHD8gnPLg9AyX6x4lXPSBuLaB50RXcYmc6WcOeBHcMlTNjpibU/zQRTWiIgNaIeCoZO70+NBHUnKxnV93G6VKk6s+vY7UoW5Vzvu4ZdB9PygfGmWRzI8buHo2Pwqhp39MarTzPdTKjGmMt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B410=E6=9C=8829=E6=97=A5(=E6=B0=B4) 4:54 Shakeel Butt <shakeel.b=
utt@linux.dev>:
>
> Hi Akinobu,
>
> On Wed, Oct 22, 2025 at 10:57:35PM +0900, Akinobu Mita wrote:
> > On systems with multiple memory-tiers consisting of DRAM and CXL memory=
,
> > the OOM killer is not invoked properly.
> >
> > Here's the command to reproduce:
> >
> > $ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
> >     --memrate-rd-mbs 1 --memrate-wr-mbs 1
> >
> > The memory usage is the number of workers specified with the --memrate
> > option multiplied by the buffer size specified with the --memrate-bytes
> > option, so please adjust it so that it exceeds the total size of the
> > installed DRAM and CXL memory.
> >
> > If swap is disabled, you can usually expect the OOM killer to terminate
> > the stress-ng process when memory usage approaches the installed memory=
 size.
> >
> > However, if multiple memory-tiers exist (multiple
> > /sys/devices/virtual/memory_tiering/memory_tier<N> directories exist),
> > and /sys/kernel/mm/numa/demotion_enabled is true and
> > /sys/kernel/mm/lru_gen/min_ttl_ms is 0, the OOM killer will not be invo=
ked
> > and the system will become inoperable.
> >
> > If /sys/kernel/mm/numa/demotion_enabled is false, or if demotion_enable=
d
> > is true but /sys/kernel/mm/lru_gen/min_ttl_ms is set to a non-zero valu=
e
> > such as 1000, the OOM killer will be invoked properly.
> >
> > This issue can be reproduced using NUMA emulation even on systems with
> > only DRAM. However, to configure multiple memory-tiers using fake nodes=
,
> > you must apply the attached patch.
> >
> > You can create two-fake memory-tiers by booting a single-node system wi=
th
> > the following boot options:
> >
> > numa=3Dfake=3D2
> > numa_emulation.default_dram=3D1,0
> > numa_emulation.read_latency=3D100,1000
> > numa_emulation.write_latency=3D100,1000
> > numa_emulation.read_bandwidth=3D100000,10000
> > numa_emulation.write_bandwidth=3D100000,10000
> >
>
> Thanks for the report. Can you try to repro this with traditional LRU
> i.e. not MGLRU? I just want to see if this is MGLRU only issue or more
> general.

The problem was also reproduced with traditional LRU.
Here is a summary of the conditions for reproduction:

* Reproducible (The system becomes inoperable)
  * demotion_enabled=3Dtrue lru_gen/enabled=3D0x0007,min_ttl_ms=3D0
  * demotion_enabled=3Dtrue lru_gen/enabled=3D0x0000
* Unreproducible (OOM killer is invoked)
  * demotion_enabled=3Dfalse
  * demotion_enabled=3Dtrue lru_gen/enabled=3D0x0007,min_ttl_ms=3D1

