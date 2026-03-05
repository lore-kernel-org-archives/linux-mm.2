Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A65BF47CC0
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 19:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66C16B0005; Thu,  5 Mar 2026 14:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9CE6B0089; Thu,  5 Mar 2026 14:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC346B008A; Thu,  5 Mar 2026 14:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9036B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:42:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AB50140251
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:42:49 +0000 (UTC)
X-FDA: 84513032058.30.E63D926
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1B0C11C000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:42:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xwDvWXv9;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772739767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFL2J/Icfk5z6sblaLG86L1o2xcdsDyOfso7V9JzEr4=;
	b=Su1+9+TlrRGCcaP6vxF6Gl7REOyRvMJp9ruaB8ubr1f3AK6Us2/kz4AK98JogljV+v8Frg
	ZFjfIgO3Sr3RDtZEetERa/F93EoDNPIM32d75ulpE3fS9IDYPmWaBfcNM8JzABCTXPto60
	pBocV46/FWttflx7u3/jvaPU8U6W334=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772739767; a=rsa-sha256;
	cv=pass;
	b=DaEGa1upcIB3ju+/w0HuLuKd2bdzPKkwz0f7ecicnmRXlPi2NKm5PiuLXNFbUvMUtoKjnj
	k/UXpGqK9uBxDT8Bbt92IV8JQmbMrqm74aLj6edBmjpqHxpQPoEQYLAY1dI+wHFrNJhNXH
	RVmrzIKaNfUWuo/pjV7Q1kCfKDDIJjI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xwDvWXv9;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a107b387a5so3420392e87.2
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 11:42:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772739765; cv=none;
        d=google.com; s=arc-20240605;
        b=OdRKYaniN8xffzzle14rZAibA6ZefPH23sJwO/GKjtZzlOi4G9iE0BQlauicz/3PIQ
         p33Rw4ARpBl6bXH0D62CxUKeoAhkAxSMxCCoYhYAOftML5cZr9VtFKYE6Df3qZ0D65XT
         rT8JDEkZiQfO4Emvecz6ovZ1EKRo2gnLwKVOWsONb4wToqH5VtPDURhp7icBt59mZWNh
         ZnT8gkL2n717D3V2EFd28Iuqw+VTwvmKzcAtWw40LGQe2JdozPtEPzfMcsyipJmCngQi
         Leqh8yfgr+O87cKMliUnEWv6inxzixcHPDHyc3yiWce8zWv9llsYp3yZ/cUB3ZuCEjxP
         ELmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BFL2J/Icfk5z6sblaLG86L1o2xcdsDyOfso7V9JzEr4=;
        fh=wJ681WoPFTPrDS5S2iIH8fxH4H1FhHjwIhrp00z9lpI=;
        b=NgSyArUS+nCK8zUtiMm/kTW7PvvztxDLqy+ZI//JQD2ToKEokpq0e5pN2Q/pKLIk4i
         GDbK1WUiVmAkp4u/Fk7MVbF1VGxFCReMgViPO2RdLIPpKyJqgIHqoGdR0aWiHIixWuW7
         2TspzzYa8tiu/IR8gdQrtJoy6WTeXbDsLtX2nMizj7V1QZJ+jQ6X10CaERGir49T6sV/
         K9I9hzFb+05nIF9SqK8froLRSGIbjvzCvA37O5n9JDobviCfjrz8BkndlFNedTFEOTdJ
         FsVIe54Fh3P8jNKmscxKb3gFW4XFdDub0mLVmE2Xhf+9B4sHheGb4QtVMNWvhpWjc47R
         yrkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772739765; x=1773344565; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BFL2J/Icfk5z6sblaLG86L1o2xcdsDyOfso7V9JzEr4=;
        b=xwDvWXv97zR2BjKPE6ZK8KsSmxRsBPA6dpi0NPQwbaCzuSOFc7QQwKV37cAGZx7wx3
         bb1KqntQLnndsmO7n9WmImAp/uQbQmEI4NfFj4BETwuwSvdkKlv2E+/MPzRpVOvwqKup
         hbkE1opneJgWaHFzeBVm1RZkvcU+ePUCnZFk5n9HV98IMEmWyytzI+grio6FMk79n+6Y
         1CpNx+fIp6fzLRaoT4rqb6VUyftDQD/NQU+/QT+3zQ/Msoeb/1jY01Hf1AqfiQiRQPx+
         aNB0S5p2aSViuZdlpCVT1HY5Arn2HueRDTtj7MpTz/0KVRAjOR2JwO2WtAA3t4QGcbmK
         nSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772739765; x=1773344565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BFL2J/Icfk5z6sblaLG86L1o2xcdsDyOfso7V9JzEr4=;
        b=iCi5yk2m8Lmn9gbe6U+W+67f96zaMQtvXH8/kINfm6TTsSvL3P2/ZmhS2FkZYMOuqK
         RJyPYHmmbXRL+I/VtppsUzH/OyAyJtZqV9ceLYwdD293qxotzKg4q8kA4jsmpv+Hq5G9
         z/fb3LZpEIeMIv3PvtORR8opB+qN9XM+SyeCuWVphWYr3qgeGxiRQ5eYeJwcbdb2swr7
         zepHZWWRibd+4WXeWZl2bYNVgEixyGcw7Oj4bnqH4g5RwbhfKpPtkmmg86IRmEmnJXTB
         14XYEfd4l/LDihG0z3a/Q1O/s244yeV8w7gmFJKyh6jVh8sa6DLJmyiZl0mrqi+z9e4X
         e9aQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLtV1ag7ijr9895aUsohJGcQR0YZN2Rvd2Us/FkIYtW5A2erP+2I2+W7iVE9JULbrx4FfeQJMLEg==@kvack.org
X-Gm-Message-State: AOJu0YyY50aZH/V5pZdYWbJql5mIe+Jy5qpiaH3kZbOqnWTx/XwynK5Q
	4vCAz0gMnZYBnvaxFDsEGQzukqM5hHRVc5UI7wW4praulRlWykIN8XG2OmDr177/AFrHCIBEO/G
	e7OiOMGWx7HGaopBsaxLpBhFm+5wZ46gGBPKxMWA4
X-Gm-Gg: ATEYQzz2ZtaqhXIVHOZei8iZR7ubqAyBB6SdUUIpUPYhtKrdKwjVQpk3vHJMTsvmbwp
	aeWaihl58vYqyE37Sj3smJEyM3PVttLxW2t2bSKvSgADucrHXpZ76fFUH/Y6ylXNu84TEKAw4Pm
	RS4ZL2d06H7+/PQ7tMHT0a12flZSSbh0qf9I3b45yckvcvvnmYnYt/f7jd88dApa8ndscX6caK8
	4LNXeF5sHk4j5p3UQ3iKC1oOfCuQHLQhtdKEG5tPjlBOCXTadda2HReZklyg0ZTpDGXoiQqsg9Y
	OZVc0akn
X-Received: by 2002:a05:651c:1587:b0:38a:6f5:4b54 with SMTP id
 38308e7fff4ca-38a3c815300mr2046311fa.4.1772739764639; Thu, 05 Mar 2026
 11:42:44 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-3-dmatlack@google.com> <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com> <20260227093233.45891424@shazbot.org>
 <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
 <20260227112501.465e2a86@shazbot.org> <20260301192924.GR5933@nvidia.com>
In-Reply-To: <20260301192924.GR5933@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 5 Mar 2026 11:42:16 -0800
X-Gm-Features: AaiRm52QizUmbxb_ZZJRNIFYAvXcIrsVMR2oGVyxQJsUboHWoi4G3a03BNBWEM8
Message-ID: <CALzav=deyfyzGXzSGmEbjvLr8Nn9Rpeh9w9JVk0vmb9FcURYPw@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <helgaas@kernel.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B0C11C000A
X-Stat-Signature: th8bfa8rc9gfgn78k9f7idoqypkbe87c
X-HE-Tag: 1772739766-494069
X-HE-Meta: U2FsdGVkX1/En+xqVxDTHTRpTc+rKxwH/kmID661BcWxZ7dbmRbTqnVYyPmAE+zT1UysWsQTa52xNWdDS36IQVRmQUSlfOAymEoYT8h+1WD28nbnqCUsEeGhc6u76fdR38M/lQ+f3NtHJsq0XZO3RS2gPyoiP1Pfy9Xc3fOWp8JmJXaWmhXIxblw1+/eNYLjIXLEForz3SuGDh1fJnMol7ikOszdzJC8aZQM9fdjAxmW2Fq8wxvkYVUNsWa2/sSNey5nkJKvCzWPw5H4vD4ml7rykR25A1TWoG0BUs+ln0MH745lSv2GcRNMUmJunL4V96UPsWcOxB01sgMf/A+a7Bhx9tHbx0/6GmNSmdBMumKr/O7zK8QIp5KVbikS4ZnFzyICy+4tBbAr5AuSKAeCvHx5TVWqVUBS1QbWkixnX5CGsEFFW5uhP9byf2RsD+Hvz/ev16t/yOEGWCJIuRpulLYyTK68xDdUcrIEgZb3q6h09ltI2X/GpW8wG4WzADZbKDRpG9Pna6ZZYKK+6ENOPRgrnPFisBh4Ok+8AWHlrWWYlcK0GzCScRWzaasA1tMZolDhjXCxJsf/iM2+bFxTBXItkXbaIdXXX56zoim+VhZvJYf6dvnvhDhFxwjnuMUYmDRZrc0E7NdzDWnmNQwbI59DCjbNSM/jkBemCVFgoF8dT0OawR6EjabfO3OrNQLufZgcdgfwUNagdZxzpYQmXYppwgwXBfglG8ZoddekzE/a3Bro/DJZfWsFupBiPC0Q5kPR+V2JtUho14fbhcvRVYwhYf7baQb7IHp9TP5pCkcSfqq/+NljVAajKJ2N6SF40naGwmNAT/LDuFhtERm9+KTtqpDpu/XC7z4xak9JSR8FuTtUTciYfkuRX4WPtaMzfDoxnys1LH2rzUFBNXZmsE0nvfT7l/CefGZQDvumGfpcbPsjKhSEq7hOJdzXgb5Z7QXfrSon9GMUY48H0uB
 iTJmsf52
 3CZ0QsCFBawYG3IS0f5aXpsQgZZzBJAfTvrHkNiS8KofkikWddeK/mJxigaG3e7SBEBg5WwaxmjJtyqXtEPKTviLibhDNPflqnPXtwxfyYWUoLI/4AjHHPxN+fP5cs2hEh0MVHAQYn9ihK4t5RksswaHRfHj0rYPb/y/GuwHbjOmoAxfZd1wk5CD9agrf4hR2qbtKs+c8h9l+dXKbZ3Kvv8EUqySNPeE9wUSrc3VUY7Chus+s9xL2RHKwpZmXKk6bsABpZLO41FN9qkodblE/8pvWXa+8xK4TrkXhkk3/SAVYDr5J7IBfQMgxDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 1, 2026 at 11:29=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Fri, Feb 27, 2026 at 11:25:01AM -0700, Alex Williamson wrote:
>
> > There's obviously a knee jerk reaction that moving PF drivers into
> > userspace is a means to circumvent the GPL that was evident at LPC,
> > even if the real reason is "in-kernel is hard".
>
> Given we already have GPL licensed kernel drivers for the PFs it
> doesn't seem like a reasonable worry to me to fret about some cut down
> version of a kernel driver running in userspace.
>
> Further, let's be honest here, the people most interested in all of
> this are doing it to support their proprietary VMMs. I'm pushing that
> we must have at least a reference implementation in qemu before the
> kernel parts should be merged..

Yes, this is why we built VFIO selftests with the driver framework
[1]. We wanted to ensure Live Update support could be well tested
upstream independent of VMM adoption and without requiring complex
orchestration.

Google is also working on upstreaming Live Update support into Cloud
Hypervisor and the kernel pieces land.

[1] https://lore.kernel.org/kvm/20250523233018.1702151-1-dmatlack@google.co=
m/

