Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C27FBCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 19:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8F28E000A; Mon, 17 Nov 2025 14:39:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093358E0002; Mon, 17 Nov 2025 14:39:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D248E000A; Mon, 17 Nov 2025 14:39:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D43328E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:39:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 570C11DF0E9
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:39:12 +0000 (UTC)
X-FDA: 84121112544.21.42D3F8A
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 35A781A0008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:39:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E8AFLXXk;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763408350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9aPjw2LvCUZNOTxP5qpY7NgJ724vIXmAiSxxWNqFj0=;
	b=PNNbZRF1zwRG/daALlhmODJVadE0aStWlH1YYLEf1iODKYrXvzgbmAmktq7AcVEWMVo4BL
	j5qbz6uCFyVDeCZsxL+gVvVBiz60t+ClrU1YegntKeVFASBU4IjOo6hBvof49jtL24Jo0n
	wOVcLdqyjL6aheqcfh+Q5d9P++68u/c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E8AFLXXk;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763408350; a=rsa-sha256;
	cv=none;
	b=g2u0TSoH5n1V2stjb62JXVzHehltiwCfiLc2UfPy2HbVlBqSWIA7tkFG9vD5b1EFHs0B1Z
	CjahxsDxQEY115HZdF2r1OJjtoddyHNeb5tnIR6QW8mQq9TBk8R3nOHr1i4L/625wvcXjg
	7mnwAJThJwU+T+OSzH3TVRObusmR5V0=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-59582673e15so3751196e87.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763408348; x=1764013148; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b9aPjw2LvCUZNOTxP5qpY7NgJ724vIXmAiSxxWNqFj0=;
        b=E8AFLXXk10abgcn7SRJoQOwa8UKxOZr+7WMel9mkWrloIe/AA1Nju2Q7vb+lbjMlzq
         D9dsNyd8KE6AfrJ6yNGqt2AyzLdDT/ELbEOzpfUUYz0bd0qRZJJkd+hDW1b+N8F2QMQV
         tDqvPgdFEIAroAUyXR2jNOeiOGTKbBcsIrmUNNbho9I8RdrFeDc59o53FQbSOE9A/XlT
         /0tZq+Hkxmpu4VzyRMgucUzVdcHlGqoevlLx8vYsQqJQr9atDmP+rfZeCMcSSKyP+B1t
         nJCz5iyAFY3unX+w0OKHgyRNqR1YUo6kmVlGKphrU+/q9qAvrj7jde6EBEYhmMb633/E
         /H7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763408348; x=1764013148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b9aPjw2LvCUZNOTxP5qpY7NgJ724vIXmAiSxxWNqFj0=;
        b=Ouz5GK3eZ6Vras52tOzRdw/EASS3/10sFDTV97r6XSWkY98G6pHZ7V6dy1lfPUlu3C
         vf9or3sXx0h0mXi4yzHKUMS38UERsp++RvCmpx8d7hlqQFUh/u2fkJRSYe7J7Me3T6Q4
         nuKGicvpRhFXvo/kp5/GwYZJ4HEHnqenqT7oEijQoYZEgEDv/BLcPuOqbiZFVftODHYw
         qqSs+WAwSKr6xHnxNxwKe2XGfmsIyqR8Vdwppx2LstHcvFC5KhKZCRAZS2bzubBhjllD
         mOaPbLGGZF3B96a+VenCDLxWyUwdGA+xJGb3vBLfGWIEUuZ3opcg9stVwteq0504pBDp
         KNyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkPeEFKT4iVD2jYEgGi7pnwNSdLO8/oHGuulYR0kS4fK0hr9WBPzwQeZ+026VDm7XhE45zxzyHLw==@kvack.org
X-Gm-Message-State: AOJu0YzLRSpb+Zuvz5iz7BjRMFgQ//+NjEXHrmqPvyt7wq8OWlfqVL7o
	hKWq/eKUzR8CsXk/lmmR+3lmPZTC/OEeluefvJ+w4U35n4fAwwoZGCnOIv61H8PQmCDOcrR79UB
	Kc25WN+lxk/WqGQbOeeoMtJfFAzFg52E0LjyCnOsv
X-Gm-Gg: ASbGncvNSHrf59Oj9b0c7RH25wr1iN2z93in1Oe61ig9V3zcqV8zZhohGCqWK/qU5Lr
	d9lbJ4Mlx48KRGlw46a1+HBHbglOT9caYa59VAY8DH5i/G097bItgYHvywdRKGZ68IRB9Z4DBzL
	ewGzVbuMP8opXYUJ6dQAiMZWtz+tHyMiultVlqgD8pyLxaaf8Md8NMPavhKPMlVGLoO++sZsRGS
	cRLp757V3cTNVahlPx30WQ+n8BnwmHa8s9yZ9+KCaZY6NgD9dw9j517QXl6L+TfhaHJaa0=
X-Google-Smtp-Source: AGHT+IFN4xOyb2ZHLHkpG4LWQorQPgUWti/L9wSnM39BaS2Jya2ibJD/Dhx+BTWb3SDVgOFhixbcdjfh2auRRViLmWg=
X-Received: by 2002:a05:6512:12c9:b0:594:3270:3b14 with SMTP id
 2adb3069b0e04-595841f96b2mr4673200e87.32.1763408347863; Mon, 17 Nov 2025
 11:39:07 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com> <20251115233409.768044-18-pasha.tatashin@soleen.com>
In-Reply-To: <20251115233409.768044-18-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 17 Nov 2025 11:38:40 -0800
X-Gm-Features: AWmQ_blJn1ck9PTGxHP2-KznbYK2P4A6YYPNkQIgUM3c99KDsjZHm2bxwWZBfno
Message-ID: <CALzav=eskApQk6kstsQWThwV=h4Qmd85kAw3CxZt=6hj=JS-Xw@mail.gmail.com>
Subject: Re: [PATCH v6 17/20] selftests/liveupdate: Add userspace API selftests
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 35A781A0008
X-Stat-Signature: egwzrpue1pp4g5fymgssh953oxifcou9
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763408349-675687
X-HE-Meta: U2FsdGVkX1+eAFrjnN9mdtoLv6AtNg0+qYbv4y6AfLZh9yzvjjQo2O8fEdAkkqKcJ+MjYRaYJNr7UHoAhcJk5bDGrbkYe0wo2ims4UZo+LC9TFlqrhJwJ9QoXGCwNBbXieUkPzSSWzXtxsHppbygg0qc2UzpWPt8BGb4TYaGcI5L/gfk8Zaj9vS3dEKl14VxT+Re8kC9sS2TtHCE/DQNIeqsJxxDzoWESe+mtD+pMp5ALh/X00T5S7AJO8yoGqED9xsx67DRM2oXTILL8sBognlG7yLpv6U9hzqs3deoTL3bZGIz7co5fXSUvt/9ggCZu5i/RjTNRTTiGGVO8Ao1A/k4kC4tM2ID7EIKezBrOKduux9WvvCnBVhS5g6S89VCvb/xGuuEvOC7/eLT+EBcwBEMzBB1LdmMqrdSF2tYjFFOdBAFgYFzayxEzzq9dNcKMIE0qTta1NbipLH5P9oJaapjM2wbskVx1D9OPyP3UxQCB+VisYqq24DI3/PPuZumzHiN+5klNjfPVsQlwdZalv2g/vrokgkbAG3kkGAHHaO9+eZ7dJggbm4Ctj69iy0xcuNyJt3nAMPkm2nTDSrcvnrHJelNsGlvUETE/SojbxxLwkuI6yI6mLrIkMC/alNBhx8/gwD4KBpUeTLm/FodcvWV5aChMTbibeVKM/9WY9VwnG5PZ9au6VWsH76bJ5uiwXXg1ZDhMtLSsNiZPMnTcrvQu9KwiwpRQ/UO/zQdBXf/kz4sZa9LybhpDbmVBQmCPTgOjpxnBUC2iK7rmrnaAsBqkm8vtcLuunQ4qTvVTFJWunatHc0QGlbJjaNIYUSFBZ4hsaN3ocNUNueSpRmUa9tRjxCWgGnQtSIC2B9aUH1D00hCEPB2RiBGlUuMtKjK3sEh3nahtpTgO8oRZOFVBa6NJRKCSpsQAzXBQXu55ooHiwSejiEM6OHOeNXx9qeYTVv1VGe43VceFZn7XZC
 aGRawCk0
 oDIWX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 3:34=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:

> diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testin=
g/selftests/liveupdate/.gitignore
> new file mode 100644
> index 000000000000..af6e773cf98f
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/.gitignore
> @@ -0,0 +1 @@
> +/liveupdate

I would recommend the following .gitignore so you don't have to keep
updating it every time there's a new executable or other build
artifact. This is what we use in the KVM and VFIO selftests.

# SPDX-License-Identifier: GPL-2.0-only
*
!/**/
!*.c
!*.h
!*.S
!*.sh
!*.mk
!.gitignore
!config
!Makefile

