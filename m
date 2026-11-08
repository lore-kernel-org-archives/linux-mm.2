Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FFB606A336
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y7+mfPjM
Received: by kanga.kvack.org (Postfix)
	id 573A56B05C0; Sat,  7 Nov 2026 19:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B6A6B05C1; Sat,  7 Nov 2026 19:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439D56B05C2; Sat,  7 Nov 2026 19:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21F826B05C0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B51D9160442
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:12 +0000 (UTC)
X-FDA: 85410105144.09.A7EBE9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 27C87140007
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7+mfPjM;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098651;
	b=cy1ozpfPsXbPYD2dYSYddRAv9OTKpUJivE5caQ6lbE/JF7ODqvNekb9MDCjqV2Z7sv+Auv
	Th+ZAqJPL39ObGePHiX/iC19vPtTwmTzMB0Ma7ED1SHjyKFON/agNZoWMuiMQ9PRKXO8aG
	j+gNV+5G39wpsbcL0WENnqnFuErxIUk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7+mfPjM;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098651;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaIdnAxJjztQSfWl20YYnBy7sXlg6MoH5xzA2rv/cis=;
	b=KBYqSk6ewJCPx0M17NC6idNY2/Ooqy2hmRP6/saSqIfaRT3yjjtU7UWr2XlQYx/I1FZaIK
	94Y5qOrp4no8zRlF1+p6zcV69m1b9pmdFZQRx90FPJdWDzAeK0R/JfG5fQF/XrOsB/1kuh
	GIj/Fhn8BprjQPqxVi6nPk+W50nVxx4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7E976129B;
	Sun,  8 Nov 2026 00:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABC21F008A5;
	Sun,  8 Nov 2026 00:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098650;
	bh=jaIdnAxJjztQSfWl20YYnBy7sXlg6MoH5xzA2rv/cis=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y7+mfPjMkcD36IPKM5O3HKPi5KW5XJ5KGR4qHuQU/tNPhGlB7RlgiOf8xjbTaj5Is
	 IsyTy2gsgsPTMLOnAmNGq8aAx1dMtOIqhmsXndQiiENG4m/V3frzswiEUvtVYM7+Mg
	 giABBBpDigt8TxU02+aawn8lHlgRACbsNr16oP4OV5cUN0HXs+hw5H5b6JP6Fvy/0A
	 sBja4AaepR+r4xBId7g6Welp7faBTfEcWVJXS0IGtQE+hybYf6FbHV8h3+nlepz8dO
	 lqvWyQhYG4dDSOtbA0wX7AUChRP9ut7fOy+TBG3q/LBLrItyvya+3CX8lLOF3kBlGH
	 EfAWbXKY3O1aw==
Message-ID: <sashiko-outbox-203455@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 44/88] samples/kvm: Implement attach and release
 provider ops in sample provider
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-44-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-44-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:09 +0000
X-Stat-Signature: 3fg9piy3kq196bk5csxtp6ghxxnuu9sb
X-Rspamd-Queue-Id: 27C87140007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794098650-689216
X-HE-Meta: U2FsdGVkX1/HbgovBzJyGx2AoxII6PFW2VmUOeg+bBse/KmJmU/CoRXdclfNW0Aml4HD2BnS9IkEZO7eTPjAML+VS8rv1L1UB2/hiPRwJHjdqYcmdGu/I9YPj+2yuEiiKZwkQ9TJL0syskTnncQyMoT/fitg3N2VRPhesCpmKcUv5tmi7bcFgtx7WXcF8AlVSMZwK+whxmkfIpGq8yWxbrPPGN5WlAdL9qNXV+aRk/W1lKome2FuuAfgesnmixR2uugCyQ31CNSElf2cnjD8cStjG7y20sqCGThr2hDypUZEohfzVFh+GUztaP/Ua6g+YkSu5OxhCMhqK1Ky88Ohpaul4kz4a76RqyIW0OHGkIjvsBm+G3aSxvWHc0H25WoKxD4RhI7828/SBvTIfWxRvbsspweG4rn2A+8iyqi7gV6R3jSd7vQdcFWsFb305eWx4ZTSpMgwYqUR3om9Lp1GlgOXCs4hDP9G3cKJIpDFtbovKeXzM1bUHXA/IaU1g0Zn6Lwih/nkFfJHKU4fIMHM3CAGeKboggi1/cnniKaP4UYDfGFJGmAEJjAQfmGTZKx5p7375q5eJ/QEVNko/T0S2To55qGomk9EJxIU7xjqGSv8C24b/MW03+iL+S/i/HvkSrOpJY509yTUP+6OOelzaRWlm5lBf1+tMMsvPBZc4LEslMsZgd/WCSM3hVH4dAb3MIF65VGMwaqYCj7djwMxwc9n1OMWj5e6LKPgDEgUw+az/OiwbvSGYxzdoQzo5dLFfF6HWxULXk5N9uPM98VTiPgHyA79FjiM/T7/ARMp9Ov23ZAUTnOGf8syzyMNvxu6Hkp/Mg7Uj1uGV0oO85pcaOCDDIbXJE43lTnp4igsI30vCoOKGah0wspP6q+DwlYWXQRZ6j+33XFkSwJi10dJSBsiNhKF7gZytR+MkdiCEvkxJk9543BYrPSh/p8E23AfmviWzBzP7ayHDvlJ0sh
 nDzyJFSg
 6zxFCNitPYaJwH43+q+GFc+XAib1raZlKANI55B9KTmDDgAkCZjuiLgCFmqJSpaamIJ7HhMIksGxHBsTE3bRHzG3EDUZeRKcqe1WuVZnqFDbyBUIj0yxQLOkheXG3Wt6h95D5L0A/Hbkl0O6si8/U2NFN8OjpcWCpSSSdhHUohW50oH+Fu6isOFVx8SWDXvK7ZlFLjDb06xkU77Z7WzECR6GVAASmvW3N8i1KJz7oPYJW3Yqa/6QzQkPqVsg19aOhCm5Y8SP2L76IjZOhck10T/YjW5inGoQJbhHEgr8oEGJ8JpbWp/l9Q9Um0XsMGoLeqCfz5FY1bbZK/enBS++e4YFscPAnRV8sC3Ma9uo64jfpwg6vQHKufu4gkf11lHNzhXV7GAVMVzUH3NUqwGG74mbXqDL6UX/0hAT9HlrH95NTb939na1tSZoo6k2WcaquerU+bMRRvJhA0u+EB8Vud4m7mb56Q5I/bHZZ0k/eLA/Mo4vBSAlZZZ8ET0Di0olvAfcIipUybdBB9+vNIus1/KzYQErbvPgH9smYHeHXmxUNvxZEk8Wu3jctxVolgl+wq9GMXDUha9j4UEGf7g6DCp2ONr7VFdAIJoOLBvQUIyRY6ZxDxM+nCkk1cQ1pBXMyeWClWbFG+jvMIDu+IPOxaoFRPssv+qaa1cRF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] samples/kvm: build failure when CONFIG_KVM_GUEST_MEMFD is
  disabled
--

commit 5fdcfe92c76b1d01309d2b39a0b5cac375eca5a7
Author: Ackerley Tng <ackerleytng@google.com>

samples/kvm: Implement attach and release provider ops in sample provider

This commit implements the .attach and .release guest_memfd provider
operations in the sample memory provider module and registers them on
mp_file_fops.

> diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
> index 81ac94ae1a4e9..6f86e3e3262e3 100644
> --- a/samples/kvm/memory_provider.c
> +++ b/samples/kvm/memory_provider.c

[ ... ]

> @@ -161,11 +164,45 @@ static long mp_file_ioctl(struct file *file, unsign=
ed int cmd,
>  	}
>  }
> =20
> +static void *mp_gmem_attach(struct inode *gmem_inode,
> +			    struct file *resource_file)
> +{
> +	struct mp_info *info =3D resource_file->private_data;
> +
> +	mutex_lock(&info->lock);
> +	if (info->gmem_inode) {
> +		mutex_unlock(&info->lock);
> +		return ERR_PTR(-EBUSY);
> +	}
> +	info->gmem_inode =3D gmem_inode;
> +	mutex_unlock(&info->lock);
> +
> +	return get_file(resource_file);
> +}
> +
> +static void mp_gmem_release(void *provider)
> +{
> +	struct file *resource_file =3D provider;
> +	struct mp_info *info =3D resource_file->private_data;
> +
> +	mutex_lock(&info->lock);
> +	info->gmem_inode =3D NULL;
> +	mutex_unlock(&info->lock);
> +
> +	fput(resource_file);
> +}
> +
> +static const struct guest_memfd_provider_operations mp_gmem_provider_ops=
 =3D {
> +	.attach		=3D mp_gmem_attach,
> +	.release	=3D mp_gmem_release,
> +};
> +
>  static const struct file_operations mp_file_fops =3D {
>  	.owner		=3D THIS_MODULE,
>  	.release	=3D mp_file_release,
>  	.unlocked_ioctl	=3D mp_file_ioctl,
>  	.compat_ioctl	=3D compat_ptr_ioctl,
> +	.gmem_provider_ops =3D &mp_gmem_provider_ops,
>  };

[Severity: Low]
Does initializing .gmem_provider_ops on mp_file_fops break the build when
CONFIG_KVM_GUEST_MEMFD is disabled?

struct file_operations only defines gmem_provider_ops under
#ifdef CONFIG_KVM_GUEST_MEMFD, while SAMPLE_KVM_MEMORY_PROVIDER in
samples/Kconfig only depends on CONTIG_ALLOC && X86_64 && m at this point in
the series.  A later patch in the series, commit "samples/kvm: Support
dynamic revocation via kvm_gmem_revoke", adds the KVM_GUEST_MEMFD dependency
to SAMPLE_KVM_MEMORY_PROVIDER; moving that Kconfig dependency here avoids
breaking bisection when CONFIG_KVM_GUEST_MEMFD is not enabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D44

