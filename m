Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B53C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A368E0027; Wed, 23 Jul 2025 10:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B018E0002; Wed, 23 Jul 2025 10:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520C68E0027; Wed, 23 Jul 2025 10:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42F368E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:08:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B718EC0703
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:08:42 +0000 (UTC)
X-FDA: 83695710084.11.B197E02
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id D2EA080010
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:08:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=dm4YJesb;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753279720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYCQ+Y4SGloI9batOxe6eah89jgSfjrOwxOFu5iP0Ok=;
	b=4rwn9cHADjW1VEktKURbfxqX9OYnk+k/isRyP/Pqr8F2+NDlwZW6p+jFXoVCIdD8UDFTMu
	bU0ke/R+aA30sa3tc/QCULrJiqJm9WK1QRgnnS7QNmV11vEucCHmLAbcWPhNfWb4Aqp5iW
	scECZ/DSzGdcBN9pTG/l+sBujfixGD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753279720; a=rsa-sha256;
	cv=none;
	b=ytlAUu6oS8Zi+UWp+uiyP6L+B4hLXWxiM87uAZtaiFnEpwfdVQZTDf91/fyZ2hkubmlsAZ
	ztuppz7yhj5/WEy8xMDmt/M9cqXVnz3qfgIotKr9VY6QVrSUg/sk0O1XMj5hB8Dw8osBqB
	1SF1xmqmw/P7RxmWKGP7rKZP3SsaFp8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=dm4YJesb;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ab7082b3f7so85107171cf.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753279720; x=1753884520; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYCQ+Y4SGloI9batOxe6eah89jgSfjrOwxOFu5iP0Ok=;
        b=dm4YJesbwuFqMfT7TtztqEvh1lyZnM2EkvPDWDl72gndObUBEPik2M49pC2rJVOwgB
         +dsosbkEXIJidbA6g/y0hu5DtjX1epvhJthHa1bJaWo23dOV4qNPZGwPuU6XHLrnJw6c
         WQ+TOC0F+CXgn1ZoC6Fx7P4cBz+ZHcQ3Ts2T5kYu8JiL9TURO1aG95kdIVBnQEayCM9I
         S9+42Qb0awgTqz4050KH98ZfRWdzuC4UIjul/Dn0kaATq6rY9kiMN+oQxo9zC775GJLu
         Xe7xMR11bSysvy3GfPrpeh5Xv5IJfFuMD6ogJ0fd7mZYhYHPku0N8Ls/3kMEs7ABIiX/
         ODng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753279720; x=1753884520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYCQ+Y4SGloI9batOxe6eah89jgSfjrOwxOFu5iP0Ok=;
        b=XtatDo4R8VBzjMOa2dwc1oecUU+87UNXfY22sTI0Y5ojpp9vwdmIKh/0pOdtrZkPbW
         Fv6xdZBnNasJgd1fJm/8ABJUYemAge60J9E8P/L4Hnu8rN4IbfxWEsOJjJN2kucjz4WG
         U0/l0ffITRHm1+LtEKCeMnOP+gBPv5atmNZv/SEWLOaDxeS8vyGvRv2zSIitqAcoHrGn
         zQxbdP/euj88uXR/M8t6BGJ/yqL1I8mdvWWM8KJW4ZLTSa9R/CjngUmQ8D6858X3VWrI
         ekwrX7e5hODVAXzshLVTxhYel6jDxmh5PdNNPVI5fmO8h6c8ig4P5pccsSt4U3el8YkD
         p/Kg==
X-Forwarded-Encrypted: i=1; AJvYcCU0R3SmnhT6BpYsB3vrPyAix5rsfdGGy48jopE5EzcFa81QRCeqKNPDv9PjULCsh10XNcioNspY3Q==@kvack.org
X-Gm-Message-State: AOJu0Yzuu1adPQdQyQhGTDV2r+w0kp9u26F560f32nrXZdv7gnEvaFIf
	0QVO9uMYHhH/u8nSw+QU9F5DgfnUnHAOMCiS+D0KGIL70bl27x7K2nMbOdZBO93AAUehssFRmPw
	EbO+NSTawFikbprj57Rq1om0g0gPjoaqzm4vg3bNkNw==
X-Gm-Gg: ASbGncukQYft0kQ/J6TYhFXfquELmYgbI5oyeeVYIB0akkp4daq0Yfoyc9y+TRLLO76
	JxAqfiw6JGy6/+qr6Xp3WwelztQbLH9Ddeo+z/r7m2Y6gvQ1qZTTQDtfdD4XxP+iUXqrbk2Sj9y
	ceT+2LHZou7+glJARxQ4BVXgsx845d7/deg2Vms81ANAWd/nKzGF0XmWI6np9fca36542xkufpI
	nWI
X-Google-Smtp-Source: AGHT+IEZg9+tOdoBN5pipaSz8l0JIXA4kWu5teWmH4MdPQcTJ4hEm9+p/VjHT1EFMtU++w0i7sf5NEh4l/b4T/vp+IU=
X-Received: by 2002:a05:622a:299b:b0:4aa:d487:594b with SMTP id
 d75a77b69052e-4ae6df3479fmr44745741cf.35.1753279719903; Wed, 23 Jul 2025
 07:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250625231838.1897085-1-pasha.tatashin@soleen.com>
 <20250625231838.1897085-26-pasha.tatashin@soleen.com> <mafs01pr6u06u.fsf@kernel.org>
In-Reply-To: <mafs01pr6u06u.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 23 Jul 2025 14:08:02 +0000
X-Gm-Features: Ac12FXwWi_rhmMIkdkRxwkl_fKGePVCICDRFX_LJg-BXvjlQMX0IOJ0Ennnr9xw
Message-ID: <CA+CK2bCHFW35oudOUTykzV4zH6Hv4ChmUq=-BZAtDP_mtOwBjA@mail.gmail.com>
Subject: Re: [PATCH v1 25/32] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D2EA080010
X-Stat-Signature: iq8mx4pagb6styfy3b1hcgfbym5q97gd
X-Rspam-User: 
X-HE-Tag: 1753279720-708435
X-HE-Meta: U2FsdGVkX1+GyWfxtGTMTeHGqR/rz8rCrZvdBQOADarp4A6VMRIOg4xWS5gbqkcYnWTcqYwNj2Qwi6BupRAvl5GU3ffsB69JBMPUGpEJyE1daP6p/7oQ2oARf+zaOiUGJtB+vtOub56cmzF+Y0EF1Mc70h+OwtcV/vO/BfBWS4l0/OynAFOIqgy+7ComTSZPN5s7r9NuCq8XrIW3vZsI0RlKtAR3OWEcKs3bONBSn8YJ1dsgzPgW7ImjPuckgapkSoSZJoFHI5ON6EWJimvasPaI0rivknNVeCvX5ROod8Cw06GbMoS8aNI5kk2IeWS3Rl1RYTD82o55aP4422TRUPxT0MEBygV5DdAphx899URbAxAKHJLRFj4Mc0XPqzPt1U4fOyesABVK6kSL63cInGpdQ4s1XUe3iIGoHKa2IlR4TkiSxjcJYjIApuoMeGLe5S33V2QFDYZp9vnV08uG3Slc77E4sWO1ufB5t/okoHzSTH/J3nXsGj5x10kkT58qysLGgi0WYkW51qO8uqTC/hAy1eA7s1fVxyK2fS2/YMqeEuy4CFgYt9kX3ZKLcfsFcGsqnU9rPkfGnJ0qBMF3NXQ2XhpLIHMEtmKfpinCtB29argFtarcWCfkkirdWUi361GCX5U74/ZEpc/Ni2UdTkPlN+yI57dW0c2I04OR04cEGmFKsEMcsbERsP/teuCTJUF6vgC+yocDNYmPyU1xGBPCMAY0X2L4vFdGJufe8ceJDDGI7L6In+T6x6HFs5crDiwgMWiKiTrie4Z/7cNNd42eLQ7cg5PRlWDgCnGhGzcD7iOfnB+Ls+1QnJN2QLQCoku2vgdvHyuRh1Yr4YHhNhlPTfSW147/P0l+UU0Nc8IJYyy4LfOLcuW7xmRfcY55CrO6/BDlO/Wgk97kigFeF4iQVUfSYiGvUbK0nM+Hsxj2c1GbFyUGxgizim1+3TnPG6N76pgaXHgaLGPLtKu
 jb7NCt20
 vaSI5vnZwIvfjb8MlAytQFsDpS4iLKtMnzrlafBRfs63OgJ9AG6sj1JqUAdSbHxJ98SGnAczMlo6S10O5WHENFEiyEi3NZz6G93I5aNEwlq900xGKFN948tB/UvpXHKp/Z3IvTTtls2D1ID1PUAuEI8lxK/xAqbeYzevGV2BfyKP0aFc46tE6JkN1yLJ0I03ZYZFiNougvSrzs6H0Bj4Vxzan1mZAcavQPAbaYH81hmUz9gaL8Dg66lgJ3fq9E9PFMwkYLtcJCuUZ5oCkrMKu4SUMttA9JzwPnSnb9ikPbz2TSKP2UzmATTUxBYJv7KRrJqv4PRxp0FDgZgA7WxyzagQGwxweManxqJUUDMmNVBT6POW1/0zm0NlBmZuCdQnwXvuoC/CplwBzpeY+5tv6cozMhj6lnl0FOVY/06PyK70ekLW12Th8tISmvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 26, 2025 at 1:01=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi all,
>
> On Wed, Jun 25 2025, Pasha Tatashin wrote:
>
> > From: Pratyush Yadav <ptyadav@amazon.de>
> >
> > shmem_inode_info::flags can have the VM flags VM_NORESERVE and
> > VM_LOCKED. These are used to suppress pre-accounting or to lock the
> > pages in the inode respectively. Using the VM flags directly makes it
> > difficult to add shmem-specific flags that are unrelated to VM behavior
> > since one would need to find a VM flag not used by shmem and re-purpose
> > it.
> >
> > Introduce SHMEM_F_NORESERVE and SHMEM_F_LOCKED which represent the same
> > information, but their bits are independent of the VM flags. Callers ca=
n
> > still pass VM_NORESERVE to shmem_get_inode(), but it gets transformed t=
o
> > the shmem-specific flag internally.
> >
> > No functional changes intended.
>
> I was reading through this patch again and just realized that I missed a
> spot. __shmem_file_setup() passes VM flags to shmem_{un,}acct_size(),
> even though it now expects SHMEM_F flag. Below fixup patch should fix
> that.

Added for v2.

Pasha

