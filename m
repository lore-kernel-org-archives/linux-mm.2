Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 671F1C2A088
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 10:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B251F6B0123; Mon,  5 Jan 2026 05:47:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2526B0125; Mon,  5 Jan 2026 05:47:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3216B0126; Mon,  5 Jan 2026 05:47:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87E606B0123
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:47:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C8E9C3034
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:47:45 +0000 (UTC)
X-FDA: 84297584490.20.7D0E21B
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5B978A000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:47:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767610063; a=rsa-sha256;
	cv=none;
	b=q7mhPrbLIuwOKvn9sF0fU8BQHuCsJHMG8VQV9ha+b/xNhwAZJvzoRrmGD0FEir1rlLvUgR
	idiUGv6H/Gv9qPMB8NUnlkEPuHP48ripTp4kZtiCSQtI4wL9zBH9kqlxveRevyw71Vxj8z
	Eg4wi+bqHqrV0Jdlkrg5LBgE4TLdlvM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767610063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AEsrfFSGpZi9ASLRdkHNghNCtZ2WVv91pfY2tmYJY2c=;
	b=Cteq1/H8esN22p65+RbZ5W1VoCZRpQJpa/s/oq0w6nnuuyextE/pYNytG9RcP1RRYziPBb
	V+/5F4+XiiKMMsnnY8MemjxOxMFotOscuitptbssFj2ZNdxdpBIqJosJ8NPMCTbR1NkqQ5
	UNv7T1wmlLpl323oOKq3OBrTrE1Lczo=
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-45391956bfcso11012153b6e.3
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 02:47:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767610062; x=1768214862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AEsrfFSGpZi9ASLRdkHNghNCtZ2WVv91pfY2tmYJY2c=;
        b=Y9tddHxIJCSML0BKioShPmAnNDYjfrZuY7RpAWu8Qk+dI7uPGv+jWbhU9rPQaCORMv
         jfjQBqGbmcio56NIdYTlouCXY/D/ZEcCCes9Yp+SsdYeSgstStx6hhZKZSAzhs+8dThO
         U64cVQIE82aSeftHYFp7/R9QphPFLGPnOUeFdMZgtBM5/WnQw9e2U4QtRLWQXZaMBMtF
         u1ylxy1ydNOkbZQSak78qPVp5LbiJ5I3b4Ofr6+TSDHDLkWx39gs2+IMdY9kQBgtu7iV
         5sPOf3Nh7LdiqgykIRwIWjYaBzsy5h6OUskFsvIETQwlcofkxwAu9Lx4cbjpQyG6DxNt
         zLiw==
X-Forwarded-Encrypted: i=1; AJvYcCUMKzi8Kgug7HNK8JNJi3SqNbUZl2SAR3cwfwzvJMAKEcm+fixpdof1OK5U1W1mu5oAW40OrMhKhg==@kvack.org
X-Gm-Message-State: AOJu0YxmizixJfpaH7lEL6Q8JwX/DVNc0Bb0qDcAlhV83Pt2TvIqQSmi
	wCTaeD+x55zrudEDllHeoUaTBf6EFmREr9v6+6Fi5O8fA4yZHLeQsv6h
X-Gm-Gg: AY/fxX46Idtl+jjhzQORqyLhAZpTIgdK8AFRnUTFVzy0H699sRbcAiR0706avEfGcw+
	c+nj4KvnX1YJfWaPJNgsqVBv47kXdnInFP2sF13/0/sgGEvkzyLPcaXh1dL5WZBMOKLefKyulcF
	HYgwqoGPzI9dcWdWpRIxnQX1zuqbs0Q21VUh2ugrXxwizFQgnix44ChC+wjsMsHDJNqjIxLdU0V
	/1mT36o0VPgfKoL9f6pjkpbZNgCC8aIj3Yf2ULxrs1THs/tat2PxIKe54UZEBwSv5+VmO8RZCpZ
	VtoZ2nQXGNH2ZUAp3viNX/dldNfCKF+ZikJbcbVF73BFa1jJgpxbt0pN95RzjTj4bBTnkI4p+jT
	s3uCJ3QInf4ML8fw7/Wo22q3xrrW3U39BIwozWqSYsXctjW0r765Z58NKIsJpiIYgPCVBsQ/m9i
	Kl8j6GzeobBbh4Xof90Vm/+lQ4
X-Google-Smtp-Source: AGHT+IEwXxwWocz3VK/aAh4+7MTdg42Q1LzhGoYzyLvRU3S8MGGvIvy4zzBvdu4VmS5Kx6cPAUk+Qg==
X-Received: by 2002:a05:6808:1882:b0:450:c776:876f with SMTP id 5614622812f47-457b22410ccmr21114894b6e.54.1767610062321;
        Mon, 05 Jan 2026 02:47:42 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-457b3f1761csm23007975b6e.22.2026.01.05.02.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 02:47:41 -0800 (PST)
Date: Mon, 5 Jan 2026 02:47:39 -0800
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] kexec: history: track previous kernel version
Message-ID: <josgeh3zd55a5sjmclidj53v7hoekzvb63ah45aocvgwh6ajxk@rnzjabyqkojz>
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
 <20260102-kho-v2-1-1747b1a3a1d6@debian.org>
 <86secn7ors.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86secn7ors.fsf@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B978A000B
X-Stat-Signature: huqhi8t9o3nj8p8tgjaozwj1rtpkwppz
X-Rspam-User: 
X-HE-Tag: 1767610063-518031
X-HE-Meta: U2FsdGVkX19L2MPKwDLA8M5gHYJKZMhMpperNzA3+JsqjOSKn//ZR7FgAH9WOx/kMj9CnYbUT0z2u7zZxZGuw/KZEXOdnf01JjxPamCRFbvB2IFXlOXfGbsQb6rzW2ilBWf3Q1QqQpYem6v3Rp2jV991pRl88EfuGb5xRCq/Ur9tWjlqzHNzYb7mG55zvDWjTYjWIDj5rx+fsS3Kr804jKCQXknmDuv5SfIjfL8uQfGOFdcDzsTLUEE/3xxNgcfTvDBFbX5N9aS2CWkf6jwQd2lkclqPYVlxcDe4/qQ1dk9Z6J2WgkHtic5VCQIJZ/Q+eqrAI7MPINFQNrfzG9Z9HqhnMFdmv1f82x2Qxl664FfLGXu3skTWOx+ion8NouSQitOSwvcQ/onS6rnQrobP6mUp5tcgiqon0M6+EJi2Nwwe7mVQ+0idPiruYCnAwcx0nFVX6diiWO1hO8R5+jlWV7VYgXePaGpXc0SVpvXRilUdLaKqPpolUPWMxREcLnU2wgzFD5e+0K0/vmdXG1Q9UJ1KSOQrbtsjs1PdfW6YZBmbzUrlphbbPgFxymEG0S35oVP9JZc3WSKrHCMGddjFj0TB67+8SX4JFiHGDC63PUwxp+eQlkjsm4dzRnk5A1O7v8fHrVoQ8Fr+sV2DuiXGfikfycm/ZHA+0sSOV/Ow5YIx3sLFMioUb1V2tx4uwYLzrZG+/JjKDqVbwobfon8nXYVL1h6KWAEdeBmDY+xe8+HaAbDxdLnNFd5SQ4Nqje7JFRYvLEKxMA/BfDwMFZFUGvSILPNUmgMFNez9iuNxMxPoZd6JVmQN3LjAn51GKygmRovqDKnrO+MUYNyZ1aEeJDnzG6W50xWJF7hpGh3//hU8/wloLe7W3MlFLjc+L+aqCb9IMSkBKnKNeotScH6LeQpnUEwsClbbSz43gNdirDvvEO+6ruALLri4s26jxY6vWGyzq95D5n10hRGVRlq
 dA1iFXTi
 AP54x+69Kxace+qVyUQbLP9T7bZfEkeEe79TPUJli2g6bdK6iK37TeBrek9frG8aEpY+jAMbzzo92uDRc955mT3RDqqa1JmJlvh7TOSfPzsONUHM0hciTK3UgghvBt469t+TxiaSqpwRvYrcaHGgfLR1GSZNmtNtjuxDmU4NG+7N3C0Y5EBajn2WVuohc9xziWVdoH35fip0d5lUJFoNZjZAcOVk36axI82r1QWktxw9WF96L9Ci4SvXt/oWmuv8plk4hkArHeEKE5EXttoGAZLEkbGSA4Z2R41LlRcMzyi0K3X1uQwlbuEn7ZQl/Tybq+K8Ulhem0NkRLaIVz6QHJavPItbt52I23svtZOb6bmZ0h3eQwxDZaCTEFIjrer5LarGaDgeg2ikdCiM4VUm9uDx98sYoppHmSnis
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pratyush,

On Fri, Jan 02, 2026 at 09:17:27PM +0100, Pratyush Yadav wrote:
> > Subject: [PATCH v2 1/2] kexec: history: track previous kernel version
> 
> Nit: please use the prefix "kho: " for KHO patches.

ack.

> On Fri, Jan 02 2026, Breno Leitao wrote:
> > Add CONFIG_KEXEC_HISTORY to store and display the kernel version from
> > the previous kexec boot.
> >
> > When enabled, the current kernel's release string is saved to the
> > "previous-release" property in the KHO device tree before kexec. On
> > the next boot, if this property exists, the previous kernel version
> > is retrieved and printed during early boot.
> >
> > This helps diagnose bugs that only manifest when kexecing from
> > specific kernel versions, making it easier to correlate crashes with
> > the kernel that initiated the kexec.
> 
> Why can't you use journalctl to figure out which kernel was running
> previously?

This is a good question, this is why this doesn't work for me:

1) in some cases you cannot rely on systemd infrastructure.
   - This is very common when you have linux as the boot loader, which
     basically boot linux (UEFI -> Bootloader/linux -> kexec -> target linux)
   - In these cases, the bootloader doesn't have write access to the
     filesyste/journal
   - This is becoming more and more common. For instance, at Meta, Linux
     is the default bootloader.

2) in some of the bugs I've listed earlier, the machine doesn't even get
   to userspace before the crash. For instance, in the bug fixed by
   commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
   log to avoid corruption"), the kernel was not reach userspace/init,
   thus, it would not be possible to run journalctl.

Thanks for the review,
--breno

