Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FC9606A74C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fGj+M7N+
Received: by kanga.kvack.org (Postfix)
	id 539556B05CF; Wed, 28 Oct 2026 11:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511DE6B05D0; Wed, 28 Oct 2026 11:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A2D6B05D1; Wed, 28 Oct 2026 11:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 130C96B05CF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:48:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A612F16013A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:53 +0000 (UTC)
X-FDA: 85372468146.13.4194040
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id F1C604000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fGj+M7N+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202532;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmmD4yO6695dLKaZcbJ6IgK3b4ZwhEaIV1ijeiKAe5Q=;
	b=27GsupELvLsrCvEyVzHjC1oXAKZHLklYXHjXN2yy6yoxBTQXoTo/WF/XE1iT1uAfnfzGHY
	3+h44sWJRBgKwqgjs/O2YDCD2OR5fiFdj+E5gf97BF5xzDWAunqY4NEEzN8SkwvPf1bACJ
	sOdMNiLqPPRkWZHjWgfRMIUib8cp2l8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fGj+M7N+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202532;
	b=rMMILhbhd7jwoH3SBhyuboLn5HfqASN9CRNih5Q2CbXKFtpKr9BKVcHL2oXxcDiv1WgnH4
	vKcG7Wx/2d5yKSmGtc1qjFbn2RfAj8DN3ugQk48nGbe8/7YqaQ6uhjJmRxobh66Rlse44N
	jbRPTQ9Uq5fYoDUSICcufaaJen78gso=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D2F860210;
	Wed, 28 Oct 2026 15:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CE31F031E3;
	Wed, 28 Oct 2026 15:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202531;
	bh=NmmD4yO6695dLKaZcbJ6IgK3b4ZwhEaIV1ijeiKAe5Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fGj+M7N+Mld43wuC92F96RpQkeLJn+L+JZ9bHpfMSf3K6FODlEm93QiYzXkUaILJu
	 LzkCOBB8OEarUGzeMQC/Fb4HgLUzZ0kb7l1mfzgzhvrfqoZ23eK85/9tDnP3yUJ89Q
	 f2xxaJL5zq4UHyWnbRUvhTAmRJ6b0xFatMkdY3bex2301uZVjFXEZEEAdCjtY12Soc
	 HwQHPsAsYbVa57sva9YPdXnw7ktvn5dmGy6bgMVhl1Mc8RqdTme8J8QNj3qY2ddPR4
	 X2w9Dk+skhviVEBCajjeFxiK65jpjapgyzjZpxrzNShy6XUkUt62GVNtryPPUny7jg
	 cdW1T0zAjfKWw==
Message-ID: <sashiko-outbox-188095@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 13/14] samples/kvm: Back absent pages on demand in
 the sample provider
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fred Griffoul" <griffoul@gmail.com>, "Ackerley Tng" <ackerleytng@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Sean Christopherson" <seanjc@google.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Kevin Tian" <kevin.tian@intel.com>
Cc: "Alex Williamson" <alex@shazbot.org>, "Alexander Graf" <graf@amazon.de>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Alexey Kardashevskiy" <aik@amd.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, "Ashish
 Kalra" <ashish.kalra@amd.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Baolu
 Lu" <baolu.lu@linux.intel.com>, "Bill Wendling" <morbo@google.com>, "Borislav
 Petkov" <bp@alien8.de>, "Catalin Marinas" <catalin.marinas@arm.com>, "Christian
 Brauner" <brauner@kernel.org>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Connor
 Williamson" <connordw@amazon.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "David Woodhouse" <dwmw2@infradead.org>, "Erdem
 Aktas" <erdemaktas@google.com>, "Frank van der Linden" <fvdl@google.com>, "Gregory
 Price" <gourry@gourry.net>, "H . Peter Anvin" <hpa@zytor.com>, "Hugh
 Dickins" <hughd@google.com>, "Ingo Molnar" <mingo@redhat.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "James
 Houghton" <jthoughton@google.com>, "Jan Kara" <jack@suse.cz>, "Jianxiong
 Gao" <jxgao@google.com>, "Joerg Roedel" <joro@8bytes.org>, "Joey Gouly" <joey.gouly@arm.com>, "John
 Starks" <John.Starks@microsoft.com>, "Jonathan Corbet" <corbet@lwn.net>, "Justin
 Stitt" <justinstitt@google.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Michael Roth" <michael.roth@amd.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Nicolin Chen" <nicolinc@nvidia.com>, "Oliver
 Upton" <oupton@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Robin Murphy" <robin.murphy@arm.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <shuah@kernel.org>, "Steffen
 Eiden" <seiden@linux.ibm.com>, "Steven Price" <steven.price@arm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Tycho
 Andersen" <tycho@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Yan
 Zhao" <yan.y.zhao@intel.com>, "Zenghui Yu" <yuzenghui@huawei.com>, x86@kernel.org, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Fuad Tabba" <fuad.tabba@linux.dev>, kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261027154649.91571-14-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
 <20261027154649.91571-14-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:48:47 +0000
X-Rspamd-Queue-Id: F1C604000D
X-Stat-Signature: krkiamghch74izmmpo9hsnn8pcazuw95
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793202531-655152
X-HE-Meta: U2FsdGVkX1/DaG+UaFmDXA5VEmgpD8mPUXImwS5rKhovSu0atckcn8RONHmjerE8wyLA6jy8UsXSlCU/smq1LN9fPtRLB7rdTZo8OZddon1oQy4gvHLmWucNU+426sw51NHtNKZVvbeaTBTiArYFf7o3U77Ui/BpTH29D3rth6G3u/EwEObj8jx52McWLXOSagbOtf7EVtn2KDbfX1kpTDjBDWRPgIkWguwIpLOQ8UEs/V8oFRwDCuhuoR+JuFgx4l6Ch0A/IQz6nqwzf4bXW4hD/UDyqjLgJ0yuCc0W7H0p9fmqnWdhW/JNToDxRnLIH9y39YBeM5mKEpA8baHyUiAFNjF2CBVDUUbhWsC88BM4jvbm+FiX6dIZTsBJNHKMHaOe1wovxk8BbQoPhzNc02rN293L9HAiXsPkr+B2CdLEU2KcPa00AmH7vdQ6w532QJ9qj6r4LydespMez3NGYTQx6beVyVYqrY/vi9kNXnMWAJonSmnt3JEiWJp58pIJC7jb+G58JPUCPaC5/jfrLX3NGd5X3zvzyUoOwcC/ESd6IVk/sUjxqzPth+FbVUdxgOBLJTZMyrVPJUlgaPDb4cJRJ8j+u9bsxoj7L8m7Allc8qR7OKvgNK9PptcTExeX84XP3JOFx6DSjQKl9RkTutavTFemLjTwNihqLxiMZrl77RoavvRt7PfJ8g4xX7rrlsgd1DsXP/iVym3VGZ4fagXb3S1uTykEaS5I83fOHw4M99zGNn43Ackm5WUchSudyXriOK3SrQvP/HDDJSl/An+zowgi6F1RYVOMVEs9gjxEUyQDms7i0nUZ/SfBMWeYzFOyMMVL6MFd61Dc4z/Hlt/rrGuSmmUWbAh/Mj7tnUVIkuZuJ5qr6pH2BZtxD5kSfArYdzk3GkWC50ZXYq8nNvC6OFzqvWJKB2sdm0KSIHFGIRboVPvCQfJVpH5Iq4taD09VQQ0bKHn22NmH/I/
 lPNa6wT4
 +ZuxivlGA9TY1wrzn37Stul3mTVCrUeV+aQCI/CtCfq0BgN9cIXG+5RLgfVDH2KzTYLuE/1O4xqT4IkaKG4iyNU1BAJQhUY+WGEwcK61v3InRj7hL+AbPgPoWySJVpP/AFYotPDICFpE11qe7N/gM2JkYrtLgK3DTEkdzaJU9kPm/5rF+31n0JLtmFYTv2b7rhn59Xxi51UdV7Q8MioVvP4grQBEzN1RkpglB9/KJfVutaNdTqk1tV84rePlAxCFz9Jia5wDaN8VE3Dl6XQPk1QbMsntDsFLa3GHgfNSLLP1SPWwVsvenia/WpwjcPUEgGcdOPwMT42Gn3in7dsW0FXLP8EE+HkpwVxCtTQstb6hFkBiyXmghEQJcMwh1h8xm+3Zna0RRoIMY9JqcWAptrRkm7hCjeVS+X3AkA3etwijauM/XkpneBqiplGRmHMKj2SGqvTciC/qNTTh9wfAxf+nK9qnX5IwsvFMqeSC0ZfvFfECp2QclrdcRbcytCnZjDibapzvBfdqpX3WcIy6xb664VdYUUJpL/OA0cdpJdHg26hKoRUjEQYP2Ah4oOvTlK9mJEoO8oT1FBNUU2/uUiY7vYXVaj3NwAqO1lSIRsxv6mSqEdXs+XHH/0ZEGVG5TmifETrmuPhNb84VOUx7h3/E0VtSHYmZ1lXnUGZEn0IDCS2DF42W8NaicWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] samples/kvm: lockless absent bitmap updates race in get_pfn() and =
put_pfn()
- [Medium] samples/kvm: mps_gmem_get_pfn() fills 2 MiB when reporting small=
er max_order
--

commit 2aa66dad428fa6322f520c9983287b30bb49a21a
Author: Fred Griffoul <fgriffo@amazon.co.uk>

samples/kvm: Back absent pages on demand in the sample provider

This commit adds the MPS_NEW_FILE_FILL flag to the KVM sample memory
provider so that get_pfn() backs an absent page along with the surrounding
2 MiB block on demand, and put_pfn_range() marks released pages as absent
again.

> diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider=
_sample.c
> index 670e36207e596..41e0ce5b6bc6a 100644
> --- a/samples/kvm/mem_provider_sample.c
> +++ b/samples/kvm/mem_provider_sample.c
> @@ -41,6 +41,7 @@ struct mps_info {
> =20
>  	unsigned long *absent;		/* taken away by MPS_SET_PRESENT */
>  	unsigned long *readonly;	/* set by MPS_SET_READONLY */
> +	bool fill;			/* MPS_NEW_FILE_FILL */
> =20
>  	struct inode *gmem_inode;
>  };
> @@ -62,8 +63,15 @@ static void mps_gmem_put_pfn_range(void *provider, pgo=
ff_t index,
>  				   size_t nr_pages)
>  {
>  	struct file *resource_file =3D provider;
> +	struct mps_info *info =3D resource_file->private_data;
> +	size_t i;
> =20
> -	mps_zero_range(resource_file->private_data, index, nr_pages);
> +	mps_zero_range(info, index, nr_pages);
> +	if (!info->fill || index >=3D info->npages)
> +		return;
> +	/* Lockless, like get_pfn(): guest_memfd holds its invalidate lock. */
> +	for (i =3D index; i < min_t(size_t, index + nr_pages, info->npages); i+=
+)
> +		set_bit(i, info->absent);
>  }

[Severity: High]
Can updating info->absent without info->lock in mps_gmem_put_pfn_range() and
mps_gmem_get_pfn() race with mps_set_present() and concurrent faults?

In samples/kvm/mem_provider_sample.c, mps_set_present() modifies
info->absent under info->lock using non-atomic bitmap_clear() and
bitmap_set() without holding guest_memfd's filemap_invalidate_lock:

samples/kvm/mem_provider_sample.c:mps_set_present() {
	mutex_lock(&info->lock);
	if (present) {
		bitmap_clear(info->absent, start, end - start);
		if (info->gmem_inode)
			kvm_gmem_restore(info->gmem_inode, start, end - start);
	} else {
		bitmap_set(info->absent, start, end - start);
		if (info->gmem_inode) {
			unsigned long pfn =3D info->base_pfn + start;

			kvm_gmem_revoke(info->gmem_inode, start, end - start, &pfn);
			mps_zero_range(info, start, end - start);
		}
	}
	mutex_unlock(&info->lock);
}

First, if mps_set_present() runs concurrently with mps_gmem_put_pfn_range()
or mps_gmem_get_pfn() on indices within the same unsigned long word of
info->absent, the non-atomic read-modify-write in bitmap_set() or
bitmap_clear() can overwrite concurrent set_bit() or clear_bit() updates.

Second, during revocation in mps_set_present(..., false), bitmap_set() runs
before kvm_gmem_revoke() takes filemap_invalidate_lock, and mps_zero_range()
runs after kvm_gmem_revoke() releases filemap_invalidate_lock. If
mps_gmem_get_pfn() runs in either window, it observes test_bit(index,
info->absent) as true and clears info->absent for the 2 MiB block, which
can either cause kvm_gmem_revoke() to see the pages as present and skip
revoking exports, or allow a fault to map the page before or during
mps_zero_range().

Third, callers of kvm_gmem_pfn_get() (such as kvm_gmem_get_pfn(),
kvm_gmem_fault_user_mapping(), and kvm_gmem_allocate()) hold
filemap_invalidate_lock_shared(). While one thread is clearing the 512 bits
of info->absent in mps_gmem_get_pfn(), a second thread faulting in the same
2 MiB block can observe test_bit(index, info->absent) already cleared for
its index while higher bits in the 2 MiB block are still set, causing it to
compute a smaller *max_order and return before the first thread finishes
clearing the block or updating exports.

[ ... ]

> @@ -241,8 +251,16 @@ static int mps_gmem_get_pfn(void *provider, pgoff_t =
index, unsigned long *pfn,
>  	if (index >=3D info->npages)
>  		return -EINVAL;
> =20
> -	if (test_bit(index, info->absent))
> -		return -EFAULT;
> +	if (test_bit(index, info->absent)) {
> +		unsigned long first =3D ALIGN_DOWN(index, PTRS_PER_PMD);
> +		unsigned long i;
> +
> +		if (!info->fill)
> +			return -EFAULT;
> +		/* Absent pages are zeroed already. */
> +		for (i =3D first; i < min(first + PTRS_PER_PMD, info->npages); i++)
> +			clear_bit(i, info->absent);
> +	}

[Severity: Medium]
What happens to guest_memfd export notifications when mps_gmem_get_pfn()
clears info->absent for the full 2 MiB range, but returns a *max_order
smaller than PMD_ORDER (or when max_order is NULL in
kvm_gmem_pfn_mkwrite())?

In samples/kvm/mem_provider_sample.c, mps_gmem_get_pfn() computes *max_order
after clearing info->absent:

	if (!max_order)
		return 0;
	for (order =3D PUD_ORDER; order; order--) {
		unsigned long first =3D ALIGN_DOWN(index, 1UL << order);
		unsigned long n =3D 1UL << order;

		if (first + n <=3D info->npages &&
		    mps_bits_are(info->absent, first, n, false) &&
		    mps_bits_are(info->readonly, first, n, ro))
			break;
	}
	*max_order =3D order;

And in virt/kvm/guest_memfd.c, kvm_gmem_pfn_get() updates exports only for
the (1UL << order) block reported by get_pfn():

virt/kvm/guest_memfd.c:kvm_gmem_pfn_get() {
	if (!list_empty(&gi->exports))
		hole =3D gi->provider_ops->lookup_pfn_range(gi->provider, index,
							  &raw, &nr) =3D=3D -ENOENT;

	r =3D gmem_provider_get_pfn(gi, index, pfn, &order, attrs);
	if (r)
		return r;

	if (hole) {
		first =3D round_down(index, 1UL << order);
		kvm_gmem_update_exports(inode, first,
					min(first + (1UL << order), npages));
	}
}

If any page in the 2 MiB range has a different readonly setting in
info->readonly (via MPS_SET_READONLY), or if the remaining pages at the end
of the file (info->npages - first) are fewer than PTRS_PER_PMD and not
covered by a single power-of-two block around index, *max_order will be
smaller than PMD_ORDER.

Because info->absent was already cleared across the entire 2 MiB range,
kvm_gmem_pfn_get() only calls kvm_gmem_update_exports() for the smaller
(1UL << order) sub-block, and subsequent calls to kvm_gmem_pfn_get() on the
other pages in that 2 MiB block will see lookup_pfn_range() return 0
(hole =3D=3D false) and never notify exports for them either.

Should the loop clearing info->absent only clear the range corresponding to
the order that mps_gmem_get_pfn() can actually report back to guest_memfd?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027154649.9157=
1-1-griffoul@gmail.com?part=3D13

