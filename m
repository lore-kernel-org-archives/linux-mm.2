Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C5FC606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S3zYLpBo
Received: by kanga.kvack.org (Postfix)
	id 5257F6B05C8; Sat,  7 Nov 2026 19:44:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD226B05CA; Sat,  7 Nov 2026 19:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4414B6B05C8; Sat,  7 Nov 2026 19:44:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB276B05C8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15D19A03C8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:21 +0000 (UTC)
X-FDA: 85410105522.28.470275E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8809F1C0006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3zYLpBo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098659;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agLjLqsWN6ZOjVtvgq5sywvqL9zG1p8SARsUTKFu1wM=;
	b=kQuxGycOCUW5qSsiiJwQGOWVHydbQgsgYzep9e41BrOx2HwJdxLlm2BDu5bijNst68MBWA
	q8mbTttosNMGqwvw/XcfsBnTGsyhKk4Cp/I3LfQ+JnUCYklLTfCb5GNk5q94OuNHEuDBA6
	fuWLnZOuD/9XnZODZZPT8YTw0vg6En0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098659;
	b=k6qy1vl5wQWJ0Gdvt9agsgvG5ZamSEkZa3e+DbFChOG7WwryHV6cFJPF7EppgTytXbWc/5
	OCoHuyqhtM82+M1XkWE5U2h+K4taHVep8YAAmHtkN/413wgO7PeBWohTXwQUDVpnwH1nW0
	LmosGzAeA+GFqSL6+bdPSVajADZSk0Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3zYLpBo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F9A96129B;
	Sun,  8 Nov 2026 00:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F981F008A4;
	Sun,  8 Nov 2026 00:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098658;
	bh=agLjLqsWN6ZOjVtvgq5sywvqL9zG1p8SARsUTKFu1wM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S3zYLpBoPX2iShJUAATU/qD0rEvlW89Ntfn9fHPVRE/YZGi3wp1cYfz2pIg73ZmDY
	 C+CAq9K4qa+mfK2KBY4FxRRaffMtW6yancdnfW4FxuxjRJ4tCil6CAEmebZ7R1Jj3i
	 dS2uY3hUk7XN5PBQWTbtWrfZz2e0zs4VN5utDesl80eKYn2pBKy+L4NdRqbRMiTEAj
	 /8694E7n0tXGN4WDSGj9/MMzIzxasmRGlwrf4u8lh54NGcYRWrSeRG2zY8cYLxbMlb
	 vSCQ20J4uerXbCasc2ZniMOqbIP65N3hmVO89Ajqo0tUBqK9pm5/hMV5QTyaw9xlPA
	 3zsIUjCad7HMw==
Message-ID: <sashiko-outbox-203465@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 54/88] KVM: guest_memfd: Support read and write
 operations and provider callbacks
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-54-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-54-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:17 +0000
X-Stat-Signature: w7ahty4wzcryif8eiar6sm5p8oxfnc5g
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8809F1C0006
X-HE-Tag: 1794098659-819091
X-HE-Meta: U2FsdGVkX18x542RuF2bBy5Cj/bfhckTNoYPvTKlgjv99BnWQ5KGjmf+hl9gOCjPlvCwagPO5q85xeO6ogUBYyPc97Qr3WuZ2Yr+hZB1iXXpW+/Nya/YRPC3z32azaj9stHu2VUMd32q6hR1Rp8SDBFqveGP8fk/uBpQ5fNE2AB1dHcAXLuAuVjRBRewD9xwDIG/caOxy6QBY7v5IK+DizLXINFrb78mUjazNP80c7mXlqfOh8X1n5KguetEQeHGCyJz0z63Tnzl+hknxsew8rNq0hYT54IicBYI8rLFX9NbhaA1lH53mnExUCVDmmytWBQlqCDcHGVnZ7Jn6qseNW15ATBSDMgUAP8/tA5cXHRm8hz5kzq0PbTuiOZZtxRPVWeS0DPk2cEe9wCn+ZRJ7EwhsMVkkQth2rzs7rR4mUhKmizTJcKtjEJ1hXV5wE9gf/UJc0HX6wpH5UTMmLoYFnSJCz+5Q9TBNQuEpghxgs/thSJ/Zbs62Wmput+M+On1leQcbwHqMi3Id3Vb2V12RgKpZP2T58nJEbUFT32sv8OHgRQW6xmOOxUlWyrg+Typv0AalHDfh/M4S/4qeinjyz+1QyhKKnI7dYzETE5i7nNb8ChmCCJ5AUb0RoezPiOEWNMUWAkbmrMycKx61mN22e70rFzpOKTgNNvMBTn8XcC2MjP2CWARP+i0i0wUzp9Spl8h1KRAXtQgdxh1Wp65Px9Hf4GYDYxRAer4/SteK0nI/lK5CgARy7fN5EcjA3+fOV2IkVdyIeyG7UHlQy/cU8VkuMBOwpJyWeydyPI6W8YCKuj/67HnTO2Zepc8JgI2cumANB0P6J8uzocPxpPeFZLh/rGKqJ0wdMNpWbGU5VmNmSBrUb6y0rtMHEdVVAWepMwaRXU00WkJF77XIo/2IzpEN+KBPBEWXRrIA2wgEmRr2JRpn0v+iSoDkUXEGvXb9HgjwbZ8tH1KWPdOryF
 CKFPSDDs
 whzNWxh9RLg0ztsc+YxaRL7EAp+yj1b9fy2Ka7+SCw85REIL7mz+pA/KRcfBisPKZQvZ/ukkaNeuDrphcgeDBr3lxP1NRQz+vSywFFFJRHJmKKjVpEU3FZvsWtog8kwuIvrXA6X20syHfSSZruYzS2Y1z9RNel+sGZc6+1fo0oH1cT4vfg7C7O1mykLGRGWxj9H9FD0y44Rz6x2Chr6LsHPNI1C8gn5FBErPsVvkfY0S92GwMSp5zE+syu4vbAtf9vhTtlwvWUaGOdU1YwRZ0gUb1TUeJwLawxqymrC2i7SduqSU4bBGirvdkSRruas9LQvX6kmyBu+ClHXIKagTfQ4Kdc/IIr/aiF+J7hQnJAHmfXjtVX+rdLEOBqga8nweuEp1ufzXg6LFvQsf8M4JxboJh+r1XrkwdOgsmrlrMHzPqkiLnlF3y/JhVdhDaWDCb2fs6lS6dWY2Aa4Ox4tzgWptLRuCPEiBCSjIdAAVQe+c/YRMeq9ulFGuHMOZn5+TniWGw6/2YfJRxYeQBOKUuINyaglZ/ceVeJPgG0Db0tphna38BjsByUS3hG0ZqbIa89CIMD5pAk8T8yGBzIFArYD3luxEXsse1VEL203M8OfMMeFUpx4LRHW6DwG6bFr/slGdXgAPyA4m5ZOP0/c5pu1Hw3TGopFsP8+dU4Zzoo/2JN/p9queGZmX+AIx8+30QBFiL/npv0iH57W97u0FKUXFL9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] KVM: guest_memfd: corrupt *ppos on copy_to_user() fault in
  kvm_gmem_rw()
- [Low] KVM: guest_memfd: missing kernel-doc for provider read and write
  callbacks
--

commit e75034915fb7c05a994b62162e0f8d89c6caa18a
Author: Ackerley Tng <ackerleytng@google.com>

KVM: guest_memfd: Support read and write operations and provider callbacks

This commit adds read and write file operations for guest_memfd descriptors,
using a stack bounce buffer to forward shared memory reads and writes to
provider callbacks.

> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> index cd634576c9af8..c85594b58112a 100644
> --- a/include/linux/guest_memfd.h
> +++ b/include/linux/guest_memfd.h
> @@ -113,6 +113,10 @@ struct guest_memfd_provider_operations {
>  				unsigned long *pfn, size_t *nr_pages);
>  	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
>  	int (*mmap)(void *provider, struct vm_area_struct *vma);
> +	ssize_t (*read)(void *provider, void *buf, size_t count,
> +			loff_t *ppos);
> +	ssize_t (*write)(void *provider, const void *buf, size_t count,
> +			 loff_t *ppos);
>  	int (*check_set_attributes)(void *provider, pgoff_t index,
>  				    size_t nr_pages, u64 attributes);
>  };

[Severity: Low]
struct guest_memfd_provider_operations has a kernel-doc comment block above
it, so adding read and write without @read and @write descriptions triggers
scripts/kernel-doc warnings.

Could the kernel-doc comment also document that these callbacks run under
the shared filemap invalidate lock (so they must not take locks held across
kvm_gmem_revoke()) and are expected to advance *ppos by the number of bytes
transferred?

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 61a3ff7fcd84c..385b517b49ed5 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> @@ -1204,7 +1239,86 @@ static long kvm_gmem_ioctl(struct file *file, unsi=
gned int ioctl,
>  	}
>  }
> =20
> +static ssize_t kvm_gmem_rw(struct file *file, void __user *buf, size_t c=
ount,
> +			   loff_t *ppos, bool is_write)
> +{

[ ... ]

> +	while (count) {
> +		u8 bounce[256];
> +		size_t chunk =3D min_t(size_t, count, sizeof(bounce));
> +		pgoff_t start =3D *ppos >> PAGE_SHIFT;
> +		pgoff_t end =3D (*ppos + chunk - 1) >> PAGE_SHIFT;
> +		pgoff_t nr_pages =3D end - start + 1;
> +		ssize_t ret;
> +
> +		if (is_write) {
> +			if (copy_from_user(bounce, (const char __user *)buf + total_done, chu=
nk))
> +				return total_done ?: -EFAULT;
> +		}
> +
> +		filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +		if (!kvm_gmem_range_has_attributes(inode, start, nr_pages, 0)) {
> +			filemap_invalidate_unlock_shared(inode->i_mapping);
> +			return total_done ?: -EFAULT;
> +		}
> +
> +		if (is_write)
> +			ret =3D gmem_provider_write(gi, bounce, chunk, ppos);
> +		else
> +			ret =3D gmem_provider_read(gi, bounce, chunk, ppos);
> +
> +		filemap_invalidate_unlock_shared(inode->i_mapping);
> +
> +		if (ret < 0)
> +			return total_done ?: ret;
> +
> +		if (!ret)
> +			break;
> +
> +		if (!is_write) {
> +			if (copy_to_user((char __user *)buf + total_done, bounce, ret))
> +				return total_done ?: -EFAULT;
> +		}

[Severity: Medium]
Does a copy_to_user() fault here leave *ppos advanced past the unread
chunk?

gmem_provider_read() updates *ppos by ret before copy_to_user() runs.  If a
read spanning multiple 256-byte chunks faults in copy_to_user() after an
earlier chunk succeeded (total_done > 0), kvm_gmem_rw() returns total_done
while *ppos has already been incremented by total_done + ret, so ksys_read()
commits the over-advanced offset to file->f_pos and the next sequential read
silently skips ret bytes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D54

