Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31534606D80D
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qp1V0F7a
Received: by kanga.kvack.org (Postfix)
	id 880CE6B05BD; Sat,  7 Nov 2026 19:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831636B05BE; Sat,  7 Nov 2026 19:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7476D6B05BF; Sat,  7 Nov 2026 19:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE836B05BD
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C501EC0306
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:09 +0000 (UTC)
X-FDA: 85410105018.26.5196369
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4917920002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qp1V0F7a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098648;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHiPeRDdKt6uysazh6qBj284sMmxoFfzZ0xM2cwi2rc=;
	b=fY//UtF6k1mQ+KbrqJtDSrHM1BAidBJ8YwzVyVnxpKu8ROBSgQTLBJlZzyM1mzoSZga6ep
	CWw+K1g0Y6Me9uoZs/aFG1gw+B/deZh3Bt6oUB+rdpReAXPuCMrjJ6vT4w4nN0CjChW/Vm
	u0T9rZJXikAO3g/JLM4BFK+N4pa+XY8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098648;
	b=axVG5xC9pUxq00wTviUDwIPchRK5voAFpnI/f8ao1aO8BGvOp7ckCoatIexpFFJ11gBGmW
	TNQqTG4tMcHZx0BNFyF01DKyDqB/2F3aGL8hP0lmGEXpXe7BGz+wVhKvvgghGY7m3PQuc0
	ohwy2+zhzd+DL9oM0jgaIy1GDm2oF6I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qp1V0F7a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8C26612A4;
	Sun,  8 Nov 2026 00:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B03C1F008A3;
	Sun,  8 Nov 2026 00:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098647;
	bh=hHiPeRDdKt6uysazh6qBj284sMmxoFfzZ0xM2cwi2rc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qp1V0F7afVq1QoTkzV65bnjQNfYbetwQuWDUtONFcWyMolB5oPENj2nXQ8jYxS0fj
	 eKcXYdNpspLK95vHqJMCUvrE988phEJnFlal0Y0zBXN0zzYkkpYMDjCqYNKy+1rqWE
	 /LnWaEUKDd6alrhTycbampppz9c+hndQVB0V2AmMhRB1IMWCjKQr+Z5Kv281sIJ2Ku
	 /CQwN0y0DQjfVrmLEMoqud+V8d7zCDQH3KNiXjcQ0It35C9vSuOz22pK6WmS5CM7OC
	 03ODBs0XxBwLASO9uNAqmZTD51DbufvRieXpdvVtoYb+VBDvCr8D1MT0u1vFqPn53+
	 r7lyGIcnpwxaw==
Message-ID: <sashiko-outbox-203450@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 39/88] KVM: guest_memfd: Support put_pfn_range
 provider op in PFN mode
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-39-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-39-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:06 +0000
X-Stat-Signature: n5pe1yhxbpk1xqzusoydmb1wzftrpujr
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4917920002
X-HE-Tag: 1794098648-993308
X-HE-Meta: U2FsdGVkX1+/GHgdluJbIkj9QphGw0EHyjkAdrkxhmp1jgw2EkBbpg+2Jk37bH+hnUhz1MCqEmlJ4ZiaGgLbm8yMfVozYT/WoVR+ZbWLMVC6ScTPUtX2Y0F8y3IQQfdOQO+De0lMK/W+2CEZtDrrZL7kCDAWTtHsivrp5+PNdQDWbAA3PKtaScOftfPUgn3U8wWX/X6OIzA9dTuXW7dXVNoXkVZwVyStIz8us2g4JS0EfhDn7FR5zf5yFfc5Lt7zQ318aJLChhgl/SCzV5KMsvaYjPyWtVWNCR/s8ZPBfXobMZM3Xac16zb33G8Ny0PPex9/ddKrXiRvmXP4NfCl0X3qeZEjgZVPTa2Iggt7ppFJbDwzS3BoNNpKgR99OZE3oaJUoTAwregQmz3hKYfRqMgsuTDASpxXnrXdw3q4vaOAjr9uUgg9KLBFZAkd66XtCMLkW882GnXc2PyMoPZaknjg3TrX4Wiy6/TRMO/rvovQbo0ebBS6dOC2bsYBY04Z/OB3FjYIKve0PaWIrPwi7ICrWEod3L2hni8pI1YMRHgaEMQocsnYUzYldJ78d5JklGJk/ZqTH+Dw7hfeED37vZgNcsRNOvYEhsAdiYyK69rCtRRqjLVF6k2ZCM6vKN206YDk6/C+RuoekfeppcWUyhkIcMqxpdrqZTt5IgAX8GfSYmO+uNhia8zqoMkTEwG2ow905ZS+XxDKNh5q0UscAOmItYCLYgTodGGltu8Tq60DQOoGXnxjcCuOCQAmyvlXgP1Hd5F+IdvlgaaWpiU7+pD0KuMFSD6PxUUwGXeoM0Gpqe6At6XdCZmFUso4D9mbvRpCq6UfEpeSdPcurIL7Y8B7Kwi8QYfuNZXQFiTEmcB65f9UaUzAQIqUPXr6y0OgstQCKmtW4ZjBX7Kbyn4hovgkYBVNUuyYyZlsZS8xnmcBBR1enbhFLlJtHkTL9Q4CBqwjhikT+nwe4cGVxlY
 D8vSpBx7
 7eg/3NDBdx3Wu12h0fuY7oZXgrTHK82Eht8JXcAkjVyK0DwkUrt3tt52+NgV6+YlyJjDQrX/aBewxLZtOAOriCdlfvJOVsmMdp/4iPryC8eOvHms21QMvbEENeeVrCaxnlBse7AWR3ZHw14+rttouiKlAGt8R6OLGAeyPNJTZQka9St9dhlr8r5Zg2w/vdAVoU2z04d3OS7VUwMoiKYr/bCd9cPA856+PEF/xK7AOEO8d+mlzUZxM4ljCuZjfWS7nfAJJPcN03ElbCcAzs55r71SnEIXEB5clJ0xySm9x6RTlXWGMvVooC6BGi8zNkQigMn9+yqVxKAX6s0AieZ5k2GIM8I89CUyBaO+8GVFBrDBdWQC8XxfWL/p2KaaAtivY+bihcVPF2Cp3pQ2NPBjX31yejFUCWIZBABpKA+lUfp8WDKCb0ian7em/K1FexKNHx0TvbgXymr5/sgkw3JqSkWsppB3YIkfrlHR4n6aH4/4bqQzvgySl9YdsYM3rQNE0jCXDfloNkq1jrZkCNM5z78EHv3MPYmttofd+wIXGe8wlQCCtZD/6tHKD7Fp7b4yjcMOD0drGtQVrQsM7Qcjx+kjVbZKtp/EvAnUPDgXTgVpTKoymiKYN0829r9wPSm3aoLZHbKalydNGr+qtX8k6p1ZAzk28CUv0gkluhqs7KLXyooh7C5jqqG000/Bzf/mmvBBKEWg7SF9TKcL1PWEYttS9EQ==
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
- [Medium] KVM: guest_memfd: missing invalidate_lock in
  kvm_gmem_destroy_inode()
--

commit caed7fc7e8fd2f7ee37985c5b86064cab5aac2e9
Author: Ackerley Tng <ackerleytng@google.com>

KVM: guest_memfd: Support put_pfn_range provider op in PFN mode

This commit introduces the .put_pfn_range callback in struct
guest_memfd_provider_operations and invokes it after kvm_gmem_pfn_reclaim()
during hole punching and inode destruction in PFN mode.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b46907b480138..501c3e250fc98 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> @@ -1730,8 +1738,12 @@ static void kvm_gmem_destroy_inode(struct inode *i=
node)
>  	 * Skip if the provider was not yet set up, as iput() can reach this on
>  	 * error paths before provider_ops is initialized.
>  	 */
> -	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi))
> -		kvm_gmem_pfn_reclaim(gi, 0, i_size_read(inode) >> PAGE_SHIFT);
> +	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi)) {
> +		pgoff_t nr_pages =3D i_size_read(inode) >> PAGE_SHIFT;
> +
> +		kvm_gmem_pfn_reclaim(gi, 0, nr_pages);
> +		gmem_provider_put_pfn_range(gi, 0, nr_pages);
> +	}
> =20
>  	gmem_provider_release(gi);

[Severity: Medium]
Should kvm_gmem_destroy_inode() hold filemap_invalidate_lock(inode->i_mappi=
ng)
across gmem_provider_put_pfn_range()?

The kernel-doc for struct guest_memfd_provider_operations documents that
.put_pfn_range() is called with the exclusive filemap invalidate lock held,
and kvm_gmem_destroy_inode() only takes filemap_invalidate_lock() later
around __mt_destroy(&gi->attributes):

virt/kvm/guest_memfd.c:kvm_gmem_destroy_inode() {
	...
	if (!mtree_empty(&gi->attributes)) {
		filemap_invalidate_lock(inode->i_mapping);
		__mt_destroy(&gi->attributes);
		filemap_invalidate_unlock(inode->i_mapping);
	}
}

Because the provider receives gmem_inode in .attach() and remains attached
until gmem_provider_release() runs after gmem_provider_put_pfn_range(), a
provider that asserts or relies on gmem_inode->i_mapping->invalidate_lock in
.put_pfn_range() will trigger a lockdep splat or race during inode teardown.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D39

