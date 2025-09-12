Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF047CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E00A8E000B; Thu, 11 Sep 2025 23:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2908F8E0001; Thu, 11 Sep 2025 23:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1808C8E000B; Thu, 11 Sep 2025 23:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 005B88E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:50:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95387140655
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:50:53 +0000 (UTC)
X-FDA: 83879221986.15.818B131
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3F4F14000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:50:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VZefKq53;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757649051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxKDeouq1Jz+sW/FOChVWGc+16LkhNN1vYGkDkTz7ac=;
	b=Ho/tZJfnOF7wJ9jMYAyaTY0QujYE8WA/iZa49psxvFsUL/NvGinsbAT6/7Ea+1W0bznZT5
	3kvK2gIp8bH/afWBndDC5yY9Ubx8/6u5LBzDJLt+YhmtwSHK6a1b5z1EQLRgpqskEd8JyG
	O87EdpjWNrG3MkITQpGz8KnRenYIevs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VZefKq53;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757649051; a=rsa-sha256;
	cv=none;
	b=6upkB2cImq1RK8MLNURVSIIA2qZ5PTQuRSYT/yVqtLE8eCOvalsYxlX/FmE2z8DKltgcSk
	JYlepikJ35fBKyuGg1XSTgz5PYeQ5fyEjSGsY+G8DcboIRml9cEgM26Lx2TiEDE9PDG45r
	Cu9nWAZ1ZXU0gC5JTp8gY19YeED4cvA=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-729c10746edso12101396d6.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757649051; x=1758253851; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxKDeouq1Jz+sW/FOChVWGc+16LkhNN1vYGkDkTz7ac=;
        b=VZefKq53s/YS5Vo3/CPP71ljkGQyRoS3J1RBudKHnCLhLTonL7Zz1OweyXRbFCI/qj
         Cb4X+Ybiht4jMFRF1iTZfm2wcTUohEzq+KH9dq2cn66Nj0AbM0tjW57UxP5+S8TNmvgK
         L3H1/Eyw18trC0IiqBksPAMk3PeepiHRO/DJO7y9b5kBiC+PPYpgLD6N0pIC+OeuWEDi
         D69mN8VGoJR458z7xRYfWiQ/hBrekdrmLCsiAIxdqgsESG4RT2tG+tdGfzAvhNyrKvXA
         qpmtApKKsftjhCahKrdVsrfT0G7tIOsquRA/DyCrdT6vKto3OCQ+JNBszZH8BmsJq8sO
         Tydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757649051; x=1758253851;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxKDeouq1Jz+sW/FOChVWGc+16LkhNN1vYGkDkTz7ac=;
        b=CGz33ueGiH6XN1irVqyKMVc6SRYx+HX3jCmS48H1A/5zuBHk260h7jv4fhcQ6NhYv2
         wUdcHTZYZVIZEYVtQThzWoWlCb9xSe43qxka5vpDaqfkwFbmsq/VENj+PQP8Zp+zQuEW
         7fmDrwEFuBkxDYtJ3590z1z+8sQd0Mo9Q7EOEgZi3C+90NXnY9AhI89bq6SqsygCp1fm
         rU6XXcqxvXuv9wYxylX3g+WiG0UtZyGhuQ1m2oNxdw4s613xHPwMclXhiPPlINE0XsTk
         NH3UDlDyUoYf/LQ8FpXcBKQNx9w3BA4QXVVUPUhEnpd7Ncp2IIsyFM4wTHCaP8rArfSY
         RQag==
X-Forwarded-Encrypted: i=1; AJvYcCVaeAb/ChXJbz0LvWxxWElFpsJk3S3JHex2SXGH0QqUryP+pEt6+YTR+b4IJluKrQkYgqqVj5bRDQ==@kvack.org
X-Gm-Message-State: AOJu0Ywnx8Is3Irq6yHrEfpfP6A39S7Hyjb2meEHf8JZIdtLwsuFG6jN
	I9nvSSAF3lssvGVgIuIKP0ZA8Vk+hpMWH316ay8QN7/m8dlF19aiqkvg+tMXMCWSAQhc30DEoI/
	+TcaYeY6it/SbbqgK40I4lcCOCu1IrZI=
X-Gm-Gg: ASbGnctdVsX/ywrgtYaKhYtbzwc6RSX09DTs7esc409bU4taaUY+uyaVg1oukNccuts
	lFszX9hPE650pwLE0h5YtLfVdTb1cqFv5P9y3nCy6j+9IktvgXtqC6R8G57/B82x2jijLl0n4Vc
	ohBWVW48VOD6eNduWHwk/TAv12UPINlk68oBASxmP7TibY66FRJaHZZ22n+S6F/69hYl0XO4BUK
	o7jaokmddB1S30/EqmthoU9PafFCRjWPprckSEz9mRMExPlsIM=
X-Google-Smtp-Source: AGHT+IE2lmMwOFsF54r8KI3I1gAGZdDCoc39UpVpNOR9hMYiRAaoAhl3WvDfRMHh4wich6Y8JpLErqu8L8REitpUGys=
X-Received: by 2002:a05:6214:1d2d:b0:731:19d0:8445 with SMTP id
 6a1803df08f44-767c6a4e845mr24554406d6.67.1757649050651; Thu, 11 Sep 2025
 20:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-7-laoar.shao@gmail.com>
 <mi5gf7wvm3hjnfm3gkrye5mpzcxlmfkzy55oqhaqdbsnnwxjfc@teia7omm3ujl>
In-Reply-To: <mi5gf7wvm3hjnfm3gkrye5mpzcxlmfkzy55oqhaqdbsnnwxjfc@teia7omm3ujl>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 12 Sep 2025 11:50:14 +0800
X-Gm-Features: AS18NWBGEeYXW5rJQyKJltmwf7rCjqkS8uOdNFWA0xUoCqDNbzrj8Y0YAHG5g_8
Message-ID: <CALOAHbDAOFjFD1Njojp=x9As-FSDwhZnFjioM5-uBoGfvPSANA@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 06/10] bpf: mark vma->vm_mm as __safe_trusted_or_null
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Yafang Shao <laoar.shao@gmail.com>, 
	akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C3F4F14000B
X-Stat-Signature: anxrsjaub6mag3y1ux6yntzgn99naoxw
X-HE-Tag: 1757649051-907461
X-HE-Meta: U2FsdGVkX1/03E97StCQJzgoKTWqoKuE80H+oNoTVETlwnzpmDIOl360dsjvWUVxrr+6sxO3rrRKiSh7kw43s7nYfVit1T1O9UU7pAO90cPUYA8GKgM6RFgZiHWbIk4u6oFuklupLli2v/O93wwSob9x4keckWGJx1YSDLLL3P1jULKSCcUA9+49MRSepV/HTFcT0YamL+BPfITnQrdUSqEgQoGF6Ee3eVFgIp71SNhUHdgtJCr48Beb1zlhWomG5FmjMKw7zvzKRLYUstLPPyVCulmtKQ0Uk3HISz7FrNoltwR5LzVh02bwkR5OF8DJiJOVDs/Se99nF9q6FvRxibpcSVHsxW9W6fXQJw/UhxOfNrFNYNJdL/hxG4zr1psSx28JrAjFqfHc5p3ZC77KuYhJ9IDe4Q9ugfS0V/nCkmogz0+SPm7xj66zDApF0UHEVSYvwkX5mdUExGi4egOie04F86rhS/CshqOe5ouh26H8ZvtkS4o6+mIVyOFSKuHsGS7+CwYOewkXxNZ7CfQK2gjqiU2nFuqJenGPRWEqUVvVygk+PRKgpJFd0IQW+6odRp7tIKb1jv6j3u6uWzOCDQvP8tiFlHp6WWSizXbI4tDzmebhYpSZbGlkwNLkoSPkTLBeoH7m90ekcX2kNXbKd97AO/73aWULRBmi/uS16gvPQQgw0HqVMFeotRK9zLyaDDdJw441j+kej84GJXAeSd9l7xszXrxDTmEpuZNw9kqzY8luOb73OMIkaviRry0BmIjyqi4ocD//oTzeBS0yp6sqXqsUQMMCD1eF3VpcO/Mucu3TDu7hTLlYzgopC+I7zb4BYgOwzwdtCw+IjwzhgXNOtXRxyDaLCSUBcEx6u+QNLKevKBIrKcjISY1CbIAvxMIntsZm1L5IQ60W3cPEqo1IZe7q8HMPfSnlPh68mcaIGCu5w5nnKZNa3ZTTZXtkI4fE23ZyDInQ5SFRo2F
 726gE+C6
 FbIuuDuAdQvrZZ6gpeHzR/zWxxnN7MX5eUSnp4tC0xIwXGD8oq8p0I1vqQ3lJ/tbincLyhVP3hRBxG1VotSCC29w8aXkoKz2jBZ7Nwmh56vKgkQ/og0bR1qj/F4xEPbYOI2+8QjgyV3AZ6ojOn86Yuv8nYzKuwAfZzpM3ScidoVkgsYYoxoccpNR+j8+N7B+wxecJrHjPx4dglnYr6mf2egcbQvLWjdeHjKhtttzEl0vmH1ZHmOI6iN1PLyaJDid2m+1C1fU9iOuyifzE2OakVKfub5i4Ji75O9WNz1yII7wit6j81eVy9GikjG4WQOdFmXozIn/ZPwKkE4axq2yUcGUfQpinmRrH6EXyc93PtKILLs8g/SqhRhJeJV1gQUFXJRIdAHVAXcVL3e9Lx2dP9z+gKSBwsyZ8zmP+RH93nDl0IXvRPyVV9LbN5G5/dpXVkcu84Vvirl9pVr7B6Zl3Sd/5EQixMnt41rGbJnhQ/1QG1RWFmT/mhCcmEmEz7p601ivZbi6JwK1SGWr3td7gs92qScm6fU7xzXlUAfzV+LQL49c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 1:31=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Yafang Shao <laoar.shao@gmail.com> [250909 22:46]:
> > The vma->vm_mm might be NULL and it can be accessed outside of RCU. Thu=
s,
> > we can mark it as trusted_or_null. With this change, BPF helpers can sa=
fely
> > access vma->vm_mm to retrieve the associated mm_struct from the VMA.
> > Then we can make policy decision from the VMA.
>
> I don't agree with any of that statement.
>
> How are you getting a vma outside an rcu lock safely?

The callers of this BPF hook guarantee that the provided
vm_area_struct pointer is safe to read. This means your BPF program
can safely access its members, though it cannot write to them.

You might question how code in lsm.c can access
vma->vm_mm->start_stack without an explicit NULL check. This is
because the BPF verifier has a safety feature: if vma->vm_mm is NULL,
it will substitute the value 0 instead of actually performing the
dereference, preventing a crash.

However, while this prevents a kernel panic, it doesn't guarantee
correct logic. If your program uses the value 0 for start_stack
without knowing it came from a NULL pointer, it might behave
incorrectly. Therefore, you must still explicitly check for NULL to
ensure your program's logic is sound.

The __safe_trusted_or_null marker enforces this requirement. It is a
restriction that ensures program correctness, not a loosening of the
rules.

Alex, Andrii, please correct me if my understanding is wrong.

>
> vmas are RCU type safe so I don't think you can make the statement of
> null or trusted.  You can get a vma that has moved to another mm if you
> are not careful.
>
> What am I missing?  Surely there is more context to add to this commit
> message.

According to the definition of struct vm_area_struct, the comment on
vm_mm states: "Unstable RCU readers are allowed to read this." This
confirms that we can safely read vm_mm without holding the RCU read
lock. If this were not the case, the comment would need to be
corrected.

  struct vm_area_struct {
         /*
         * The address space we belong to.
         * Unstable RCU readers are allowed to read this.
         */
         struct mm_struct *vm_mm;
  };

As a minor, unrelated note: Non-sleepable BPF programs always run
within an RCU read-side critical section. Therefore, you do not need
to explicitly acquire the RCU read lock in such programs.

--=20
Regards
Yafang

