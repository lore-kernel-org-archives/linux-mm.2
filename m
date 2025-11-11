Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAAC9CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330628E001B; Tue, 11 Nov 2025 14:01:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0988E0015; Tue, 11 Nov 2025 14:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFEA8E001B; Tue, 11 Nov 2025 14:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 072F28E0015
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:01:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D05651601A0
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:01:46 +0000 (UTC)
X-FDA: 84099245412.01.C2EFD30
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 88D4B140023
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:01:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YlNDCUwc;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762887704; a=rsa-sha256;
	cv=none;
	b=ngejWLFpY40xu3uaw8rjtwyQDa/gZa6tZrRVejHAguzvyiW3hVBG3BkQbpxVcDn2+HxiOl
	UohQrt6BPJrfgHmdU3tkstWdzkUa7nfSuJyqa62Z0OECJbpQEei8kUCpneIZNuJP5pOU42
	+ITbq6PPZrCnDKRnLaAe4rSFWO16BP4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YlNDCUwc;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762887704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnaiHd4DDY2ICTnxeCXWQ5hasVJ7ETSPBgIDK8OAdfA=;
	b=Y2x2xA68OAO+khUPEXW9xS9rXLA+FdXbgC+AVc6IqMmdPCGzfj65ITwaa3Bx5b9heAi/iD
	6uoji3jMDVPLgw8wlyJEl4rW1vwy/Eg2DOJOQmfm3WF2s5RWovMQ1gL7DhQgtIcVEtZ/7m
	HYPrGL2Dji0xIlYAcpnFF0v8UU06NXw=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so537301a12.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762887703; x=1763492503; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JnaiHd4DDY2ICTnxeCXWQ5hasVJ7ETSPBgIDK8OAdfA=;
        b=YlNDCUwcKR42BYCdGcw+S9fhEfB0Y7zuorfYjNnPh4Zuf146tc+zJkC1pHJRyA8xnI
         Tv+aXBKfcJkm0bfJnZIVL6uU0Y5tlKkwYUAbzVys+soTGoEuKGWtqnNU7GMmW9sQzfzj
         gn55SEjyWSYwFUKKwJm0CDbgRILOWMxgogzpXWwr9zPY37m0fq8fRfOzrqvOlldlC2om
         iCljKkP+4xQDbxS+TNXzSA397/13qd0LLZZX4hkoIV7Mv98SQUOzETAfLrxwNbvki390
         7XIkD7RQIKYau/I7vPtMFooTnAmA4gJJpXB84w755vdEKLVnJ8L+hwZsVUtaDvAuJbyZ
         UbAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762887703; x=1763492503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JnaiHd4DDY2ICTnxeCXWQ5hasVJ7ETSPBgIDK8OAdfA=;
        b=APZWbqQ2ddauxaIPx3Gkv1VkFw7thjzlk8gcAsmYMZ+4RMVixO1aA4kZjlFYKdZLx1
         FUlLubyHnWeLMHvF8vD/iHqYQnCeuZnvQFV1dw99h5vbhlguN9+/rKZ/zgFIGErGG96U
         T+1zhaxRWS3dhBPaHQH/46FBln8WadJPuX+k8bx+ysqabkq4qcQUL4gK0i8TKdDC/dVG
         ej3k7V6NOAch4fXRNlua6WmXYWGrCzX7Zo6bXvXIMWFpgLu/iLVGPDH+mgy8SQwg0ZQ2
         oGsDPuaDciEBL6pktR9yPb7E585flzJqF+hBFO3bvS97C5gW73e6N5zIGo6LILohy/pQ
         CUFA==
X-Forwarded-Encrypted: i=1; AJvYcCWeaW4zJBdle76BWa9uT1hj4vKct6JiEP9pcgNEJBqUsIAo8La2rJszIdnJKe80ceXdSATtHDlVnA==@kvack.org
X-Gm-Message-State: AOJu0YxKiXaVL816XL/TAl+/AZkR+UF6pXIl8aJDDnjJ6/jHCsxbjKa5
	Coy1HTuO2wkYALf4VLvOW3sGjg0OJZp2WVEsSo5XU1O7bPeM+NqjKFxgJkej776iwkHN7Co1zpU
	J1pafBOCYFAz72cbd4HWtg2rWWEdwcpu5o7506JWd2Q==
X-Gm-Gg: ASbGnctPTQKTXpLodBaS64PYDljmTnX8DRSjC8WNQgYDLmCOjtVc9GOMIWyVdKJuANY
	YqoSt5Z0pvAfmqLXO9vPL9YkZ6PwVg14Di2WC4OM6OvseHK9vDD+AJQQSlz+IuBsjV8u2CkWQUu
	w9OEEBFO5pJ87sx2kagwtvcP9+WdQ51A9/5hAs+4dDqSJx6QHz26kXBbvPVmVaezXVaBk3kw1O+
	1XT9O+ySkFjIam/KCoqPqdWvtCUS2oE9dD/cff5YWSBlXVgo2FLxToP7wucuB6DWSEL
X-Google-Smtp-Source: AGHT+IGCOWzuMocQkFvJE6yoxZ9KHVliFvFPtTKGmyQFHgSP/UIfCc27ftLwlu29m5483oFVeYxmHJnt2JFe5uDACnM=
X-Received: by 2002:a05:6402:5186:b0:640:9e7f:675c with SMTP id
 4fb4d7f45d1cf-6431a4b3bb6mr252981a12.10.1762887702747; Tue, 11 Nov 2025
 11:01:42 -0800 (PST)
MIME-Version: 1.0
References: <202511120222.vMZm9rD4-lkp@intel.com>
In-Reply-To: <202511120222.vMZm9rD4-lkp@intel.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 11 Nov 2025 14:01:05 -0500
X-Gm-Features: AWmQ_bkoQg7cvgViaXIp5X24hcN84LDYjKFKP5IT037YI5GxQ_pfvCjDN4fOrRE
Message-ID: <CA+CK2bA93HadQzDh4La2Qh_3CaMO_BnyET-PhkLsnvu7qrgK9A@mail.gmail.com>
Subject: Re: [linux-next:master 7210/7661] kernel/liveupdate/luo_file.c:571:3:
 error: call to undeclared function 'get_file'; ISO C99 and later do not
 support implicit function declarations
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88D4B140023
X-Stat-Signature: tei8i7z8jjyru4neoy4gwd4x6rkp365k
X-Rspam-User: 
X-HE-Tag: 1762887704-116848
X-HE-Meta: U2FsdGVkX1/NFONvf7UQ086lZHgwM4PN+nJQ4Ix33BJXJ1OJp2865MbxqLwkcWyEoRoGg/21OG6jO6RCqKlDhNq5Fgy5EkdsgkRcmC5Ijp8VbT3c5V2FgsdMS7/+td5RvN45EAQ/5ZqICQLvhExnA5mi7y3ogsZdKJvAIp/j7AqmPvmFUNIoLkYp5SlRwIByuymtAT9qRP3ARVC8VOp47f/Xkpb16bItGXQcegTqwPnW5bj+x/PTFy3lKN8f2j4Q4ibDPYvAFSTKlLA/zg4kIi1MPPBDFL+cPZk2uG4JDh9kvjKZmL+QnQJI3UbD6LZYuUGO4QyjwtMYguw+me3zHio8SQpNAv2IjGmfEdfSrnHWIK9vtGwU9YRXkALJvbTbsEknRvzKUpqPByyBMhzhR0V6L7tAijSXzusJ0Cv+8UojNnyR067UIcy0Xcvfqd7h4eklX9KkozjXTS1z0zoVDDXMJg8V1GzXG2HBzKdVDLw+NLYaFqp8k3uG1XFIE/EQqYjX5K7bZ5k+ozL+UMVijCmviZMc0w3BgqQgYZ9c5u3I0Rn8jslGN6mfFl/2/FPNYuDnCSoSxRxEwH6/6zen1KDQgSX+7WBt4j5F+H9f+/fHr5F9gV4fhmNlOsvD6kVlR4hz4IF9pA9bqQMI9BVBbha5ebdgv8sxUs/4TRlEyA5Ehrx82RhHUgZR5+OklVY0K2ii7h+uWZrcQiwZjLxgEgfImvXsDcGQjb9erfeGS4sR2SwilySbbMS8JTe+naQVt9G8HckGzQ0DxFYVnvdYPGMfEmsz2vh3rav7JQF/xQKOlbTW/du2DO3PI8aI8QElzTd1aAe/ZSIOPuFX3DAhAIpQEpkhNq2HNNmRaqBEwe23yzMmCM7HJ9NjfVdoVsoZYYnFTOY1zxnWVWb5I8rmHhN9g7AVb6VNekbZuEpiyZo1O7XAsNkZK0FKeDHRDUBlPChmB34JioWwZWfVwzV
 D/LWa15X
 XSKAQ3luLII1taJDEEMhdjiLtdFtGkgsBRm1kESgl8A0d3UzbehIqNx7oBHBhqdEbnxSRsMyv9BqAqoPRDSki+dP2yrCWdC0M9l0ANZ4yP2RwIZpH7xB1T7AWJrEGhbU4q+S/erjBwzKSvL4+CWj/aO8t+WPrC7v8gFhTprI3dvTf3V+eXNDq6EayDuYjFsISEfXUe1TEiOxKXrTbPcz3CgqT2GoTYBVtQE9Dnl6RKPsBWIjkGvOPkR97wAos/q8CVpLsvEfaOm9UZffCI8Io3rnMhiK3DbowJLFAbtv7kJFDO+kSVPUbV+dUcoOtL16j+G3tF5YAa02b9NQfDVRJtwgllbJgljCnr+SELVjtP8cb8Iyn2B9hSMuicqyKELkpBOLMHGL2kUYYc/4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 1:20=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.g=
it master
> head:   2666975a8905776d306bee01c5d98a0395bda1c9
> commit: 74602408d6248999ca8a567c46ce0f78204d6e89 [7210/7661] liveupdate: =
luo_file: implement file systems callbacks
> config: x86_64-buildonly-randconfig-001-20251112 (https://download.01.org=
/0day-ci/archive/20251112/202511120222.vMZm9rD4-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0=
227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251112/202511120222.vMZm9rD4-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511120222.vMZm9rD4-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> kernel/liveupdate/luo_file.c:571:3: error: call to undeclared function=
 'get_file'; ISO C99 and later do not support implicit function declaration=
s [-Wimplicit-function-declaration]
>      571 |                 get_file(luo_file->file);
>          |                 ^
>    kernel/liveupdate/luo_file.c:584:3: error: call to undeclared function=
 'get_file'; ISO C99 and later do not support implicit function declaration=
s [-Wimplicit-function-declaration]
>      584 |                 get_file(luo_file->file);
>          |                 ^
>    2 errors generated.

Thanks, the fs.h header is missing from the luo_file.c:

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index d5197149b3b7..adc411dbfead 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -97,6 +97,7 @@
 #include <linux/cleanup.h>
 #include <linux/err.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/kexec_handover.h>
 #include <linux/liveupdate.h>
 #include <linux/liveupdate/abi/luo.h>


>
> Kconfig warnings: (for reference only)
>    WARNING: unmet direct dependencies detected for OF_GPIO
>    Depends on [n]: GPIOLIB [=3Dy] && OF [=3Dn] && HAS_IOMEM [=3Dy]
>    Selected by [y]:
>    - GPIO_TB10X [=3Dy] && GPIOLIB [=3Dy] && HAS_IOMEM [=3Dy] && (ARC_PLAT=
_TB10X || COMPILE_TEST [=3Dy])
>    WARNING: unmet direct dependencies detected for MFD_STMFX
>    Depends on [n]: HAS_IOMEM [=3Dy] && I2C [=3Dy] && OF [=3Dn]
>    Selected by [y]:
>    - PINCTRL_STMFX [=3Dy] && PINCTRL [=3Dy] && I2C [=3Dy] && OF_GPIO [=3D=
y] && HAS_IOMEM [=3Dy]
>    WARNING: unmet direct dependencies detected for GPIO_SYSCON
>    Depends on [n]: GPIOLIB [=3Dy] && HAS_IOMEM [=3Dy] && MFD_SYSCON [=3Dy=
] && OF [=3Dn]
>    Selected by [y]:
>    - GPIO_SAMA5D2_PIOBU [=3Dy] && GPIOLIB [=3Dy] && HAS_IOMEM [=3Dy] && M=
FD_SYSCON [=3Dy] && OF_GPIO [=3Dy] && (ARCH_AT91 || COMPILE_TEST [=3Dy])
>    WARNING: unmet direct dependencies detected for I2C_K1
>    Depends on [n]: I2C [=3Dy] && HAS_IOMEM [=3Dy] && (ARCH_SPACEMIT || CO=
MPILE_TEST [=3Dy]) && OF [=3Dn]
>    Selected by [y]:
>    - MFD_SPACEMIT_P1 [=3Dy] && HAS_IOMEM [=3Dy] && (ARCH_SPACEMIT || COMP=
ILE_TEST [=3Dy]) && I2C [=3Dy]
>
>
> vim +/get_file +571 kernel/liveupdate/luo_file.c
>
>    519
>    520  /**
>    521   * luo_retrieve_file - Restores a preserved file from a session b=
y its token.
>    522   * @session: The session from which to retrieve the file.
>    523   * @token:   The unique token identifying the file to be restored=
.
>    524   * @filep:   Output parameter; on success, this is populated with=
 a pointer
>    525   *           to the newly retrieved 'struct file'.
>    526   *
>    527   * This function is the primary mechanism for recreating a file i=
n the new
>    528   * kernel after a live update. It searches the session's list of =
deserialized
>    529   * files for an entry matching the provided @token.
>    530   *
>    531   * The operation is idempotent: if a file has already been succes=
sfully
>    532   * retrieved, this function will simply return a pointer to the e=
xisting
>    533   * 'struct file' and report success without re-executing the retr=
ieve
>    534   * operation. This is handled by checking the 'retrieved' flag un=
der a lock.
>    535   *
>    536   * File retrieval can happen in any order; it is not bound by the=
 order of
>    537   * preservation.
>    538   *
>    539   * Context: Can be called from an ioctl or other in-kernel code i=
n the new
>    540   *          kernel.
>    541   * Return: 0 on success. Returns a negative errno on failure:
>    542   *         -ENOENT if no file with the matching token is found.
>    543   *         Any error code returned by the handler's .retrieve() o=
p.
>    544   */
>    545  int luo_retrieve_file(struct luo_session *session, u64 token,
>    546                        struct file **filep)
>    547  {
>    548          struct liveupdate_file_op_args args =3D {0};
>    549          struct luo_file *luo_file;
>    550          int err;
>    551
>    552          lockdep_assert_held(&session->mutex);
>    553
>    554          if (list_empty(&session->files_list))
>    555                  return -ENOENT;
>    556
>    557          list_for_each_entry(luo_file, &session->files_list, list)=
 {
>    558                  if (luo_file->token =3D=3D token)
>    559                          break;
>    560          }
>    561
>    562          if (luo_file->token !=3D token)
>    563                  return -ENOENT;
>    564
>    565          guard(mutex)(&luo_file->mutex);
>    566          if (luo_file->retrieved) {
>    567                  /*
>    568                   * Someone is asking for this file again, so get =
a reference
>    569                   * for them.
>    570                   */
>  > 571                  get_file(luo_file->file);
>    572                  *filep =3D luo_file->file;
>    573                  return 0;
>    574          }
>    575
>    576          args.handler =3D luo_file->fh;
>    577          args.session =3D (struct liveupdate_session *)session;
>    578          args.serialized_data =3D luo_file->serialized_data;
>    579          err =3D luo_file->fh->ops->retrieve(&args);
>    580          if (!err) {
>    581                  luo_file->file =3D args.file;
>    582
>    583                  /* Get reference so we can keep this file in LUO =
until finish */
>    584                  get_file(luo_file->file);
>    585                  *filep =3D luo_file->file;
>    586                  luo_file->retrieved =3D true;
>    587          }
>    588
>    589          return err;
>    590  }
>    591
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

