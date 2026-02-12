Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E279EE36AE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A1A6B0088; Thu, 12 Feb 2026 12:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC78F6B0089; Thu, 12 Feb 2026 12:44:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C2A6B008A; Thu, 12 Feb 2026 12:44:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B5E836B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:44:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C666C0CC7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:44:25 +0000 (UTC)
X-FDA: 84436528890.27.9B77527
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 75704A0008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:44:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aIRyB3/n";
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770918263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFFjrxG71DJpPae2K/LJY4449yAyo95qp5kuW3/y324=;
	b=8TKDQurKON5Qmrj666Lb/4ONNVYO7OYO5aUPVI3PdnI1MAtLXbZSn2G1ZQdVdCnG5+ex/w
	njKIB7vJ79DFGmCdt/t+0J3XFFXoWgaVoV35Ngd2FajmOSn5kK8hOVKUGxq/FiktB47OcY
	AjiSs6GvQlxon7daJmXwoTMO0zk10O0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aIRyB3/n";
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770918263; a=rsa-sha256;
	cv=pass;
	b=zjrB/Ehe93pP1W3qqbTQ5/KBc9hmE5tUYeSIvajH5Rgn30dAWXJSyrtyH2BYeliVC6Ycgx
	o8USEaEGtCfmIoBrSBKVWx2TX7Q0PuYfFB60b0qUuXeITElfgFy3D6UG+vMiU/t+qSGeFf
	6DH3bRprToJqBUrUxI8i3We+ASTmV+A=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4833115090dso817875e9.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:44:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770918262; cv=none;
        d=google.com; s=arc-20240605;
        b=LFPsEhDcuN9lgMI14yaiyKg2hocB4xjZOQOAv2SHASBBiod8gOPwGUoHcpUxMk8g1Z
         Uop18HMantct6rUCnxD+uIXMFww4chFuxuZ9HshpNvUp4ZJTqMa5ox4nXpR61Mbt25oP
         LIcAOHurEIroI+TxyIgMzL5bgoCkUZsCy8lbMV1mf4Q9IzPMNo6jnPlaHoH2CLMYR8j/
         O0Ql3+lKslpkOW0j8FBW8qbR0eP0MTY4AnFuc3pA6cWe+2BZB4lYQEwD+sHcNOiz+i+4
         3OGOa5YJbNfnxzX8QqE7/J7LwS1M2WIStbl1HjTNanYyhKeS4qGnotVPisdujnNYhvFI
         UI/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QFFjrxG71DJpPae2K/LJY4449yAyo95qp5kuW3/y324=;
        fh=P3Vx2bti2jD0J7+H1vjz8+o4GjLeE4S77lOaFaCZUkk=;
        b=im25TZ6Fr3whz3z7+QlCVnEY6L2WEQD0EKy+nDyEPvzvQz/+e6auIjVHMSk/N9eKYc
         FtUz7Rf/VAoVKCuRES/2dqepZGUVtAu1ZTHlJ9l0gHeka0HXED+R9vJ4Nm3AM7X0Ezav
         oLCRgwbZp9kQMhuge5VN1VXP16fkIAEg57KPLtzQiELOEtTT7HVwV5oruu0UjqISPzuO
         iMN2fDwIKptUuDNLHzsRQMoE3WLCMUSCVivnXaoqvF3jvTJxkhr+jXyrJMpFmND+UPlt
         Wu2+EnYq6JAwibv5m/+8Bnyp0tvd+U6twGg0y097yw2sm5hxcOOqMxGuT/6KOh0DQmk+
         pf3A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770918262; x=1771523062; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QFFjrxG71DJpPae2K/LJY4449yAyo95qp5kuW3/y324=;
        b=aIRyB3/nGPZWc4bfxWJR5U1n7f7H8Hd1HImZE6jOWJOg1dLIo4ACsQ0FWuvWLiokEM
         ZTEU9mIAQYZ4bcKdxGu/NSB6pfBXej2ZVsRBDtf6Mmt0gndrwjPTwsL3hZNGN+xkk/M0
         HnFkCPswmIyj2zECESd3o+oL3zFaPjn0gAKPa3Doom/ZsIdq/c9By66Z86GeAkGPkV1l
         59w2xf/o4cLxa3/rtybWQrj7voD25ONzwgkxY4P87dswyhJr2uI5/iqNAbzaptftYAFD
         +3Ui0DSISfIeYY9y5k83fkPu2Ln21Z7+3BiVE4I0zZFzDvBY+xzcS+/tT6ArZGKyWYW6
         Z+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770918262; x=1771523062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QFFjrxG71DJpPae2K/LJY4449yAyo95qp5kuW3/y324=;
        b=Pff2nKIxN8R7i+gIPvbvQlviHfjzL9QHr7yvtsjZMFPYgO5UAZLsneVny1NRbJ70K4
         9QfMi0fiHcdp40PK8e8LdD9Gj4suS821SnVioC9aEWNr7M7peyn9NjX6zLSNf6BgyLnK
         if64xhyNVRVpuIPYS8CRDKERtbe8ykHvrmsuh2Trb1hnc6bTfUFlM5zWWNwEuutVTWrz
         /Kccrdso9SJxEyJNIBl5U6rSW3b/FMjQDj0FuWq6dEV/lDkBrAjY5gF7Qfhj1la92krp
         DE6bV9ZLX03WarbUIePtQYdQXkpGhjny1wTQp9jCL40JaEuLxJZcbquI7FhCXT6oUOqy
         JlYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVACkd06EqHHr8lz+PW9WOiD/NI+cQp8OEtbZ78JWgu/oMey1sZbKLok/LESE6VqLvfzPWZ2fShMg==@kvack.org
X-Gm-Message-State: AOJu0YxBiQzorSKKW0zwUYWEqv9yWZrfwfP4EsMl2+k0JGVrDQ6g6cxX
	BwSE2KVXoaacgz7ZXcTJUxCPHaFZEUUjy2CkH7Ae09RxZzTFcu3MNEypXMzhlE+eT32Z3706VP6
	fplvwAPgg71cU7Yb6vUdz44Ksc8FVQUw=
X-Gm-Gg: AZuq6aKs+tsxJcO9nbDNT/u4wHkMyBYlv4YYEs1HE4okidOzmbo3g0QxfO2VVbjwr2H
	xXl2LMFeC8QSTXWBSxf00zMIMTHrYo52RQwboC8ykZ5doatN/mFkDk33kQ8y+q1/6GVfUg2SJY5
	Z0OS/UoGFVKIb5X7Txx8UWdsQmqsEWNe9n8/tvALqUOuR4XYrdSABxPRiV7o80ICwZT4gp40m8X
	+MrIf6Dw4fDHDTsoFDXugd/oq9BD5IiNAuj90PWdhzlkjhN1G7GUYzLn7AFeZaz+H/8R+vP6m1p
	fM31ifRk8hpS8W9klj9w2VlqRU4qmjfJs5otOnPJjFzg2q6r9Fey7E20BXnl50kzaGLB4FQ/ngX
	X/m7s5lrYpZnceWyndhA=
X-Received: by 2002:a05:600c:3548:b0:477:7a53:f493 with SMTP id
 5b1f17b1804b1-48367159cc1mr42571855e9.23.1770918261616; Thu, 12 Feb 2026
 09:44:21 -0800 (PST)
MIME-Version: 1.0
References: <aY3+Raf8eZqipCd6@e129823.arm.com>
In-Reply-To: <aY3+Raf8eZqipCd6@e129823.arm.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 12 Feb 2026 09:44:09 -0800
X-Gm-Features: AZwV_QhQb3K_2kIegArK5OmwapFG8qQD-DB5OVXdcFX_fAH3CfXObNoqOzuPBt4
Message-ID: <CAADnVQ+D7v+sGFFyTfSxFSEEcnGV111NeSaVtASYHfP-mDnV4w@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-mm <linux-mm@kvack.org>, 
	bpf <bpf@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, david@kernel.org, 
	ryan.roberts@arm.com, kevin.brodsky@arm.com, sebastian.osterlund@intel.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: jcjwzgyopqiwkw9jzerfogorrkhrxypw
X-Rspamd-Queue-Id: 75704A0008
X-Rspam-User: 
X-HE-Tag: 1770918263-793333
X-HE-Meta: U2FsdGVkX18TR3Oly15Tt5qb1NlrorsYm0ApCTydw8t84FBw7xuQfHAia6B/89Eoif7t2cv2Ek8nKeR+nC5MSaZVgvnyvxgHqw0VuSDNV6+VTHpRL5jGmazvvDAmTJsD5IVRg9PO7A9AOZWhbFV6Rlw92eyQTebNdj9XItnDHuBbRu0MJNynH5X8kRdxbxwv0azBw0VESBIAm8dF6VtdaW2GtEWnREsqXBCp7TNGVGm6Ph/ahngRrUR+/JY1kj+HJXknOdNv9NV0iSK3yY5GfjFSE9aaHZN1o4SKW4fK5LzdJPRvmPLNIQJUrWya49Wej3tFFFGNPRVT3XS4HUWxwEtw1WTXSYS+bCm2Lq7H2OlEmDsbgXVzyXnc7L80v7JvkTWBh7yYd1qGnVef/E2l25edztYAn1n9iyznwMpmCq3nW9wBWP7DFP17XCGyDBG0kznujIbhnJNeMXe0xlOgnELyKUnkmGFqvVcgJk9/MsOv4RwO7MapwvYCHtXuDS/uam9mQzpHLltTEtf8cTPqmjTYCPLRUIDPuXN2rEQZe4iqCc2KIslB+NSTKYmvmLuffuZsCNdlp91pnOIdEgHnVsW5P1btkpRDZTDuNB9jyrL+fb1jQ/D53S7Ik0+NiXHLtZlCBj6q5nMZDFif6kK4T9YELUaA51cMO/Ex/sfEFJV3xvn8jDtrz7HrrDFQJGP/uIg/I6QcEGVQwvbEDfLQIfVfUdCDrZA4GhooCLoiSa3fnpGwYl/aAeUl1PSsiKkP/R+4sgCdskCdY12JKJJ0m5OeaHpNW9URtOyqKVO7S0tiuxDGK4qe6ym3EYZNyFPF/0CuvilJ18JyW5kNNofyD+6iR/XfBOplMZTI1MJoYJco/HFjQ7P9LOdol6SsMJ5AKpA9kbNbJg7PNrde/O7IbO4fZgVSPM3uPj3m8pPaaQhoIPQRQ3GEUNFjtzBFmbHBPbRLAuGPtUlw65baJTN
 nAYAnL0C
 JJyPqtPCUunCpx+LJpBo3JUdFMkqBovRSBE20CdbY/TTAzNsuhH9M3RCyAtSFm8Zp7pHo3i2z+XI9WSYew2cENfE4eA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 8:24=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> Hi all,
>
> I would like to propose the topic of eBPF isolation with pkeys at the
> upcoming LSF/MM/BPF summit.
>
>
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Today, eBPF programs provide powerful capabilities to extend kernel
> functionality without requiring modifications to the kernel itself.
> These capabilities are largely enabled by the eBPF verifier, which
> enforces memory safety and other constraints to protect the kernel.
>
> However, vulnerabilities in the verifier have repeatedly demonstrated tha=
t
> eBPF programs can also become a serious attack surface.  In several cases=
,
> flaws in verifier logic have allowed malicious eBPF programs to bypass
> safety guarantees and compromise kernel security.

eBPF was restricted to root for many years, so the above is simply not true=
.

> Representative CVEs include:
>
>      - CVE-2020-8835   [1]
>      - CVE-2021-3490   [2]
>      - CVE-2022-23222  [3]
>      - CVE-2023-2163   [4]

None of them are security issues. They're just bugs.
Like all those found by syzbot.

> An RFC series is planned for around Q2 2026, and the experimental
> implementations for eBPF isolation with pkey and pkey-aware memory
> allocators have already been completed internally.  Using these
> implementations, we verified that eBPF programs running under isolation
> successfully execute several sched_ext applications provided by
> tools/sched_ext, as well as some bpf kselftest cases.

The stated goal is wrong, hence not interested in patches
or discussion at lsfmm.

arm has a nice hw feature. Sure, but this is not a place to apply it.

