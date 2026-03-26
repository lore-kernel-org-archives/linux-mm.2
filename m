Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1056B10AB827
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 20:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3423E6B0005; Thu, 26 Mar 2026 16:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3846B0089; Thu, 26 Mar 2026 16:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E22A6B008A; Thu, 26 Mar 2026 16:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 103516B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:44:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D2281B9523
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:44:01 +0000 (UTC)
X-FDA: 84589391082.19.5AC7C49
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 903C24000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:43:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O6An+aiW;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774557839; a=rsa-sha256;
	cv=pass;
	b=siFKtqrMdrnD8KJr1ECVWKBIDKBSbZpARjqekkZ1a8TO8n8oeggYdTeInOUsXDoKr1VSdY
	QrfT/d1s9HFbvU3E1REqHXsdaVA13G/l/6LMfJ1CUiJcn1X3JAPkcU64b974cAnLAlyhFi
	aPyKbn4n/Nv5eYv8SPDvAoxHxlvEnCg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O6An+aiW;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774557839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnD4wGwZvJQvR/a6rbd+FFqGbZMJuBdhvv8TVCrH3ik=;
	b=JZgewHTIpfyOs+AkcfNQQHaMxQMAVpurjbHJFn+TYRw7HAmOeASbnTB04lR/Ve3ATABhnE
	Uobf966G4riQYsSeAh2gvEot4vLwRjgIsWyasH3iGXHI/60dxIvdsBQikgQGkU2LVknuUC
	+hcqAWZ4x122u37rQ2+VmU9n8qLyApQ=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a27b5ad832so1569698e87.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:43:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774557838; cv=none;
        d=google.com; s=arc-20240605;
        b=b6MKt/ORXzKNjwqeyg79G+Mj58AilRudJ/mCv2FuEPt4L6Gnq5A6SYu7SKzfhU93Qn
         6Mt/VfmNqq1K7K9iupAiSb37ob2RWZqB1tAAmv2urAqGDecZ42m5RC6mxPWTmGoYZrDk
         i0FE5vICDsqeZcFnGhUn49zjoGX2wfg8A7huF25AFGWWAe1UgxyJmjadvc06XWF1se3q
         KmTDlKnTZik7IOxkh7K1ellCTiYxeqlUEyiMIeu8bO3dlddvPLwh8TVuK8+9JJHOx7t+
         dA/WRk45ROu8f1eQLDNt5pWIVkZI+V/XVGsbbVHKGDHNSb2EIJqVI4cHGl7CGuas0bqw
         uXwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CnD4wGwZvJQvR/a6rbd+FFqGbZMJuBdhvv8TVCrH3ik=;
        fh=Z2mpU4GgQe1+qc0mbPsQxRgm2lfoX6d3laspOVQs4ho=;
        b=KTXAxwskYYUKf3QGU8IWbpvMGUFXX8ZgNGCI23XqdKqAoIC3zWaen8RLxTatniUV1c
         /YU9Dzc0IYXS1qHCyVhtZQ7ewmqiJpEsR0GBBKnSp+TSkCU9VcB/pSWZ1asWN55K4H8M
         O+P/XUN8UVc9Ytw+R7N6wc8IU4SHl7aOnb9cISxb9nePgso7trjKzkbeF8mkC1sef8Re
         MFdiyWYhh7iuhLSkTqWVWf85nHNyY3jNxutI2JFFAZ7sg426Uzx2uobFFyaGYtLo+DJG
         O/kif/w7OqNKbMwM3eaA2rc2YgLLhcnJ1NOvBJ7lWodq5TJYDYtL0/K279fXoajxR1J4
         PC7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774557838; x=1775162638; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnD4wGwZvJQvR/a6rbd+FFqGbZMJuBdhvv8TVCrH3ik=;
        b=O6An+aiWIgNeTCQwdjOJj7O/vyuUQF3fJ9dlf9Cx94DCWoiArDYYmYyREdnmMkrKbT
         Ip087TkqESZUKGdowV1jMLXlLjiFg7PzI5Pbo1lKdjq+m8uitF+YAI2YhtCKnG6APKit
         tLRdcq3KtrhyxCnySx1cTZVCeBODXcRCuDForjAyOPLyUx+JFvB2bGHb2Wqhevss6dwt
         8sgLWPcms11I0gmwAJKNUJj5dGN5Ixw912LbkTtYl/d2lwW10uzGhcwiYMJSvQwrpC1P
         bz486V0PEcqcTN9zk5G/jYJhN2lSTGDakcLqJ/KIALR3bmXqqk8iVEQBGlRagWa0Afsv
         SaXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774557838; x=1775162638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CnD4wGwZvJQvR/a6rbd+FFqGbZMJuBdhvv8TVCrH3ik=;
        b=fqA3WruqdfPbTZbiVp5qhHvjr+1ImpGCdx1vGB2DGEYprzYqHoTBPC1WCKndUhjbGs
         Ghgig/OIk6fT250/NJ8aHGyjKZ6AttORfzNOBOuAb1hrE1afgtfhaw+Og14KBL7J8mmx
         PMEV3pau6UTHLSGVDUqqruahAnmdUq36T2azVbwDzNDpeH66/DYjobtcE3keWDVgXHnG
         yr43zD+8NiY3NludKiGnIHenI1oug5JXAKmDMyV64g6kgOwzmv1mrbFvnZ6MprnGWhZB
         wja2dW+MaEpks/yDbD5FXQHnDGMQW8bsTf/33eeTSyhcptB5hExbVbZBmWy1m1JQ5B/W
         rwWg==
X-Forwarded-Encrypted: i=1; AJvYcCXGzjdJBbU1vySdtcmk+z0BRcbmMf3HioWGO/e2C0HLFULbfH3PuhWHQyH/ACcXd49qNfWMKyWg6g==@kvack.org
X-Gm-Message-State: AOJu0YyQ6n2ouTfb4O2EINnTH+IgR58Swy5BJIprQBfPjyW+J8gD/za4
	HeStPCTwlQEwQ39uWq7YcrUCG1pMDS5cEm2Dj4OybxUwfjOECh2uwt+sPeDVNhNb+4h1Xq1Pnlo
	eooXt8A7fUDb0+IuzRvhrJc/S4GyalvxfWUZDklsf
X-Gm-Gg: ATEYQzyiqxfVJXIra1nHW56HaJDpPYmPEDSqJfTNM/SKQhJxgCcjhO3/MBAZBcjCHD+
	uMNMmXpD5eyTlOsnKyUjxUOrks75EpaDuFL/V+zzEXp/yCkoZDlMDMlhnOhn5jJIb49ZnKNAQgy
	5VGdXDZHv3Hl+FUJKVYaz0JOiNCBNQO7sKAe7Ypow7Nc5mIYxQY9b+Hw6o62/Wa/cHRXi4FE5hy
	PNNCc9zQXORnC0eZV+uqW9mJXxfjlILJAAaJYQyqcQeIRwH3jBwFW0H+dT1MkPBe0+Zh4eNKoWG
	/OUgCkyU
X-Received: by 2002:a05:6512:10c6:b0:5a2:a5e0:2da2 with SMTP id
 2adb3069b0e04-5a2a5e02ec7mr1094413e87.8.1774557837156; Thu, 26 Mar 2026
 13:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 26 Mar 2026 13:43:29 -0700
X-Gm-Features: AQROBzDv95n65Jfr7km6DKOoUBuRrbrSOHrGu-gele9pXf1C5O1laHd_UCbivjU
Message-ID: <CALzav=f4--Kp5vXz5zrxZR3WVsa9T1GF4NFFtuf_Q5ESMHmWwQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] vfio/pci: Base Live Update support for VFIO
 device files
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@linux.alibaba.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Li RongQing <lirongqing@baidu.com>, 
	Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bm7jmoebxgyie3fbqzmgdyfqmxmjzb53
X-Rspamd-Queue-Id: 903C24000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774557839-850169
X-HE-Meta: U2FsdGVkX1/s47dd4bGZoDN7ywARtAeuXYpmTWxTXZIKCcGmGP6OMyv4TvE4/R94ecN56UFwvdMgp1E6hm8ulczb0zroc4UPerPkia2Xw3ulKEA0lZOAIjwBbohGgwnWIHYUhyiE2WV6olMfYKVxwjnCGXRaD8k5KtWs6t7bE82RtbSG5cFrPt/FZUBNw/05/Ss6ALyYRjBX8F2idsx3ix0EnmggyD4jCkuZ/yj7y5O4i5tWRqmzbmbDPVJGxRXgn6uXTH5pGMVMYgeVmGtlxlV1cr3vTxUEx1eltmrN61s5jb470lQgTCmxnBP3rR1cPnbyXtOAWpWDffcbJ98cSxU5yKJMrqO+vRFtc8jljxEDWXXHfDofeOyG8wC2Uk6r+ik3ZVwyp/dG0ATFxy3GTx+XKvkjLd5Nrj4pF6A620z213MLwgFvMDNcHKn0VUNAqMx/bhhJZtCICSokBF1fNw+lRddlWEzvR97P9WIA/NeG5rc9nPyEoMCn3IQ92V02uqC26kA0sFiOuqa0OYEaf4TzRgQhTXRfLQ0e30SLY31LUWDz0Js9uOH0ZVylbHIkGY1a1Nh/qrrru866VRY6xQz6P75i4qr8TOILFcAUMXD6Ry0rkF7avE5qdbTxwRPMEmAuLdCQn9+5jVrC6e7T63lzWGjZSPGQPbaqQj4ZRCFYNH9CeN73mMfuMkLl5d6gJ8SOcu6QOwVAz5p89SJxe52SqjW1yXNs7AvykC1iRhxT96bOkRhFtG2J0DGoFQnMR2XTq95Vn0qw635WaW37ovEwGPmC7gRrywyT09yx6cc1p6y6hMtYw7+L82H+vbp/vgzSc8o4SixywM1+iiu6M7dCQI//bisewYEVgr7XLEzAut0jLaBEpj+jKyNKHDC1E3gpE7TIlMCatR0SMdTTwFMqr8qmj2f9ogIFmyXo94n/lV5tvqlhKkUP7yQq9fW2DV7LCE2Wf5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 4:58=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> This series can be found on GitHub:
>
>   https://github.com/dmatlack/linux/tree/liveupdate/vfio/cdev/v3
>
> This series adds the base support to preserve a VFIO device file across
> a Live Update. "Base support" means that this allows userspace to
> safely preserve a VFIO device file with LIVEUPDATE_SESSION_PRESERVE_FD
> and retrieve it with  LIVEUPDATE_SESSION_RETRIEVE_FD, but the device
> itself is not preserved in a fully running state across Live Update.

Apologies for the large number of people who got added to the CC list
on this version of the patchset. The changes to
Documentation/admin-guide/kernel-parameters.txt in patch 4 caused
scripts/get_maintainer.pl to CC a number of additional people due to
--git-fallback. I'll fix that in the next version.

