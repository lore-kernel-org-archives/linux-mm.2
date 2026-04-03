Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2336CE88D6D
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 21:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53986B0088; Fri,  3 Apr 2026 17:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B806B0089; Fri,  3 Apr 2026 17:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940ED6B008A; Fri,  3 Apr 2026 17:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8551F6B0088
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:58:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6DA38AFAE
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:58:45 +0000 (UTC)
X-FDA: 84618609810.06.2658B76
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id D8D3740006
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:58:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="nFJpN0/1";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775253524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n1x++2kh/JMrnSacQAY2WWd8oQD4emJiO8jgrYOFWkM=;
	b=7RZCGI/Ne0nxncywmMpHNMBxDoNb1IE9V7fik8/7g7R0cXFq92msA61BcBM5DN3Y5flT7c
	6Hl1E/ksXGm/9mbIq4XmBiQqc5lt+engDdyMJ6o7cCCLvBXE7uIDRiYATHFmWOjjnMLR/p
	FY2nCF7xsrLo3JVm5MI3Sxe8LQKhMkI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775253524; a=rsa-sha256;
	cv=pass;
	b=56EWR+Yc4C74VsllvpmKEf1yTbCSFytz2GzPWIwg39F0AQknMgA/AfWFdDoz6SNO3QH2/+
	DDIUNYQ0nMYb9lYCC5LcziAOLTZQ1Cm5Ru1nEKpUPYue8GGy7mlKRZ/HEZpi57FNLE2hgf
	iW2bHCX/gWsYyrDbFYODyCut00dePP0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="nFJpN0/1";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a2967e5de4so2928250e87.3
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 14:58:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775253522; cv=none;
        d=google.com; s=arc-20240605;
        b=Y4gUZFGoZDQo7GO2vwHfUxx3/gAs8upxNY/g0DLwtP4qsKavpPLYZYrQzuwNjVeWwJ
         O0bXmLeM5Kk4Gm5sDtPIogawBVNViadUzYH7OTsyrjsrfKFTAhHWrAekVdZH/TrujKnW
         tXVmBm2XduFTW+A448Xg8BuBYl6F3depOOvJrPez/D4pGJAGaCo0T7Y/l8SIylmhka4q
         BaB4ZPd4Qac6eJ+31dgz6w7B+ZfznZ+BOopBN2FtfxVTKtBNU7LEZDDIT7IgVTy1Ldog
         Rz4OzAxzTafmpZ+HZBZtHzQfz9sebsqmv7V0N1s4DyB91O6XYRNpIHlkhMKkII9tVljB
         0vlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n1x++2kh/JMrnSacQAY2WWd8oQD4emJiO8jgrYOFWkM=;
        fh=Rv8RCZDpZkNn9XfD6aI7m5D8co6qMJgFLdUmGavlYvI=;
        b=QtnxdHbnmf81kTwvKVrwfIgKAJKBO9mVJUtuShhyoo6M9xSHqJDBHstZZ+oWaWpcqc
         EIa8iT1aKvdnt2QU1gQerYV5dXMF3RRClXuExXgdkqVuwz67XoQ/1efdiraz6fyjTBcR
         5Ws72WfYibM5u1vPvU7wCuPc59juxNRM8N1Moer9fEqtp7opNHxA9jUtOsFpMFuWlsLj
         AXHgjjk16QoSCgrKibvT2ENP7fWM+C4YZ/tRyzjNhK8bBj86qtWMabZNrI7CAtRbtGi0
         fLbAfFPCJq84Kqo+Ddm8u3/CKBeMxGsOdX2hlBRCQkBo9biYxGC+kKdOtTO/9xWVLE2g
         L7Vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775253522; x=1775858322; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1x++2kh/JMrnSacQAY2WWd8oQD4emJiO8jgrYOFWkM=;
        b=nFJpN0/1GMW5bzmK8O1iMAVN+r8hzoZMm5L6z0mQbuM2M6cnFeEfIVyGBss/d8xSjU
         B16f8YWcX+RLaGVILy5If1UR9u434VxPznqYmOMQnfMJxhiDbLamazL9OXlzH+Hvvw51
         jd8V8WvfejCJCftemgg+IX1Sp7uPCXgnXaaaINhBc42kYteV8nZR3xneBVY3UdLkmkhm
         OxchT64kTrfzEUVSNz64wHNgpbED20vWDhJLajHf3atAOMzuSEw7wRyPbeNVeHAUoLvb
         ALv/2zpxtVV6SSDmx+GCY1CJ0+q4J0ZUQp5rZcPXjYeqq74+HhbGr8zN4aJ9mvSyK71Z
         Q2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775253522; x=1775858322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n1x++2kh/JMrnSacQAY2WWd8oQD4emJiO8jgrYOFWkM=;
        b=giX8sfa34lX2ddmTKPhTdNaGuaTAg3FXt1IxRKH8qPrqh5I1PrhbEfEV7y/m3WsMmH
         CtEErpP6Y3kqSnnqJbwE/g1p2NQI2+rB2e73i8Z528wH+KZ6ysL5trlZYp/RW2w1eBEf
         uWul59Ru8E1+bo2zf5u98909UUXGo1KVUBIZG/xLFjSmWwuHh19EwNstOCKEDQM6VSWK
         lOgMpFz6O4cx1+cCIslrpKDtuC0esrrCGjCXQDh4HT65trlNl/ztWtC8kbNxUIjE+jza
         LQjmyQii3g9IdklPCPBP4NjDTWlmvcmmHfe0yLx9RrCFMhdH1sTupyOAQOOirZKp89Ek
         4feA==
X-Forwarded-Encrypted: i=1; AJvYcCXewJnM/BPf3SPxthQDi1XqmQ9q6shfZdxhai5gnpIabtvvSBqTPRPsQrBuXuPgtBClhlWSmNiYHA==@kvack.org
X-Gm-Message-State: AOJu0YxjhyJlJf1zUpoEO38yTXOiZcDBdZYBfq2UcKAHcAwQm7YM3ZV8
	P1LlMgT7FDjXH2u9gaRNsBcThzdoKaCuEOavwjO9TjyEsBg1W0ZRIqnj1TyTae3R+FiNSPYSl2K
	4YMfdu5rJHYPFqrR8XRSB+FN7SLq68tiiuGzfUxZD
X-Gm-Gg: AeBDievevk5boCgcHhPMuHyut2RsjW+7gQ5MtYYyjfzXtlxmoFg+e3f1TwgdzgonXz2
	XNfZ+WS/tYqGdjP/wEHeZnBWGYfljUgRalxSMdUf7x2iV7kAzIKK1KYl/LVgRBNjsQdzY7t6RmT
	z/9hcnKzQycUnDXeqOdAEaxesbK69ihgwClAzI6PLXinQQBYOpY/OpBuQRILGg5t7yZLRXgY7WJ
	Cwr3/gyPGx4csGGV2XrxRySEhkdkn5it35vKPG3CUbFDVO3KjRtL6CrxnRCYHL3ImNfkEWG0b+S
	RtGicbSL
X-Received: by 2002:a05:6512:1310:b0:5a2:a5dc:6111 with SMTP id
 2adb3069b0e04-5a337563322mr1534908e87.18.1775253521414; Fri, 03 Apr 2026
 14:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com> <20260323235817.1960573-3-dmatlack@google.com>
 <e3fe7085-1297-47b8-bb17-a48196e8f37f@linux.dev>
In-Reply-To: <e3fe7085-1297-47b8-bb17-a48196e8f37f@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Fri, 3 Apr 2026 14:58:11 -0700
X-Gm-Features: AQROBzCufsJjSomX3fu7F7ptwK4HJAYNpi3kPBVsC_mFldZEseUJNvIFRhG6pcY
Message-ID: <CALzav=eyf4XRTi8MfE_GBNSm+tjmfX7=d0M8Aj5Hh0vJn7huew@mail.gmail.com>
Subject: Re: [PATCH v3 02/24] PCI: Add API to track PCI devices preserved
 across Live Update
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
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
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D8D3740006
X-Stat-Signature: 3zhdpkpgio9fahjczdiuzqd7zn9oh8wm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775253523-663344
X-HE-Meta: U2FsdGVkX18yKZ4fDIrYIxevYR7LSj4dG8qxLOgW1onGRj+XOnEn7TjgJ69loXqubPF4gK/bfBUKHtcxwsYJtI2ooqZgcfcFQCzIh2BoFvgnqm8DSPh+10T5TIrkEZecoPQst+gaST0pFbELW7kz/Mo3JeJGbJIbaexZ0QV1YlSXhG2w2c7Ev08cSAcnCDZb0drRYLFeynxAOI11lDxbHE+TPkHuI1FdjuTU9EZ9ym9byVai5bNESmIhpeSJXColM+GwTyWO4tC1yIqwm//+q2j1VJx1eR6ApKbR0uQwuWYWzzuivITDibdw/Pbd2U1LVIlLr2gObIQltlkEtJAIMkDHWBW8HQzK3U63ASArlcF5bB2H9kSEI7yS047Vf9NBhGGTVul5NdZzKnaV+0OCUVcmznA/S/zfUIwEEu9+oFNOZ6OnOtyf9kVOJNYO2a28VPdqlmnHn+kZQO34EFIrQKtNzv+PLuA3VUee61ztQayB4qmup7WKyBh+kEJzxp9c+xovunNky64/Y0/zPc6wIwCSu7qQTG2+ykHKgSqzif1AEGY7plOOV2kwWshqz2d2sDxEAAz1mHpl7MknHKYN5qXk/5QlcHNeFc1QrAu1r0fcy7jc+qcNzm/Y1rhSgujJim/Ag9ZRJAYZVSHwpKqYDCM9qZOW9quHCuwC3RfJhCKMN+J1lf1oGWRbf9YWyVIub7+2sMcOPY3f6Kp7ShVnZKxWNsVEndVJYVbqQuL+FXNmqVVFwvqe0uQLQuEeQaGURagXBJT6qZpm64pLLD9gAfpbjmmkwhHw3CtlOcSTky9kNny36Vi9fhJ3h6sQr3SlEZnnGRg29tqQZaRBrAy8bY0n7NbagAXgoQ+1JsD6Hm6ysaaYgGCsJ7Ym1u24FzuUkrS2A2XyRHADyS6VhyPPDlu4FLtb5nLzMugCgDpLZjk3/ousCLQQjEmhbsVn+Tl+gp/dRkYUmWUHGwL1ns8
 FoCkscEg
 yPAqJkhl+f0Y7eWXUzOrhjtqPlhbuKQ6w0SIoRJRED7EkQtykaG74aIA5vGTSDJE5zCxIwH13NXRyRrXbvgRLr7P/Nt/CMyokRhgg/2XQ7Nk4wxTOn2jy4lUcR1xZJjnYrUAxsTbRIZddsT2c2EDJgYs5Q+Mc4meMWADhg0lpQN9S9ZFntGrus0shLAenE8NvSVW9UzSnV5iJOwoP7o20GV5z/U5CoYE5m/nMLNfskixXDgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 2, 2026 at 2:29=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev> wr=
ote:
> On 3/23/26 4:57 PM, David Matlack wrote:

> > +config PCI_LIVEUPDATE
> > +     bool "PCI Live Update Support (EXPERIMENTAL)"
> > +     depends on PCI && LIVEUPDATE
> > +     help
> > +       Support for preserving PCI devices across a Live Update. This o=
ption
> > +       should only be enabled by developers working on implementing th=
is
> > +       support. Once enough support as landed in the kernel, this opti=
on
> > +       will no longer be marked EXPERIMENTAL.
> > +
> > +       If unsure, say N.
>
> Currently, it only supports 'n' or 'y'. Is it possible to add 'm'
> (modular support)?
>
> This would allow the feature to be built as a kernel module. For
> development
>
> purposes, modularization means we only need to recompile a single module
>
> for testing, rather than rebuilding the entire kernel. Compiling a
> module should
>
> be significantly faster than a full kernel build.

I don't think it is possible for CONFIG_PCI_LIVEUPDATE to support 'm'.
pci_setup_device() (which is under CONFIG_PCI) needs to call
pci_liveupdate_setup_device(), and CONFIG_PCI cannot be built as a
module. This call is necessary so the PCI core knows whether a device
being enumerated was preserved across a previous Live Update.

