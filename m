Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA70E606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UI7RZ7UG
Received: by kanga.kvack.org (Postfix)
	id CBACB6B05EF; Fri, 20 Nov 2026 03:52:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BE96B05F1; Fri, 20 Nov 2026 03:52:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B811A6B05F2; Fri, 20 Nov 2026 03:52:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9666A6B05EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:52:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 263F0A8DC5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:52:15 +0000 (UTC)
X-FDA: 85454880630.19.79A6245
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7793D40004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UI7RZ7UG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795164733;
	b=600P+yHGTXllV91eKF+Y+cjJ0zGC5G6MEUcu0TT3eDgsGIGvQmyWDvxFFavKX5cgwwdkUn
	LjIundtV6lMsQJuYat5YQVR4Itpe3sGx14mPlK/8qcQVmE9fkfHKwt+z+ZClul5cZm5YwM
	1erjDtXG3VlnUle1ZNHk/96mh2G7Mp4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795164733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9BupMtjidZ6QpobbhfwIfHs0MvSJr7PSNCGLjThNjE=;
	b=16z4cbJ3yJ8+tNaDQvKL+JE6eWqhXR9+ndZ445BO+7geT9EIedIn4zu26c/j6WH0mS+mzF
	G/92FLPyuDHBvezu7njC1aAWU1iitVllQMXVI0VBJaVF3+obMgYAnzN/F3vI8I4CmjUQJE
	yVyDZVJjbfpntYSuBoy+3oTGqbiDXpw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UI7RZ7UG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3F15467A3;
	Fri, 20 Nov 2026 08:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC441F000CA;
	Fri, 20 Nov 2026 08:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795164732;
	bh=A9BupMtjidZ6QpobbhfwIfHs0MvSJr7PSNCGLjThNjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UI7RZ7UG4ulO+8lDySyolGDohe7qVwBRm7JU4jcE1PzwxsuPIW4enjpXJ9hsRxlwA
	 GRfeYk3l8bnxjuvd8SRFpRzbhXWUeuu4O9DMa+/XYZxEMrPWt8vHZLCFJMRuXj71Av
	 0DnRmE153jsvcLlDVr7/T9O3PK+k5DFgFchuwKhFw7RDyTmZBvCymZcSWx9hzZxpew
	 dO/8tAnz/RUNZPCobsNfix4h9APM0Si1UkEBYDXvKJy+BOlncANRePBbTWC596NoYV
	 tpFuegArNVwixEy/6ldDxBRwXWh8fJpOM0sUyZGI+uB97L5vP/WhjK2YYHWvdy1RXI
	 /8BjfbVmtIAQQ==
Date: Fri, 20 Nov 2026 09:52:04 +0100
From: Christian Brauner <brauner@kernel.org>
To: ackerleytng@google.com, Alexey Kardashevskiy <aik@amd.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, David Hildenbrand <david@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Fred Griffoul <fgriffo@amazon.co.uk>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
	John Starks <John.Starks@microsoft.com>, Michael Roth <michael.roth@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Sean Christopherson <seanjc@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH RFC v3 03/88] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
Message-ID: <20261120-provokant-zyklisch-schutt-55d8eddf2ce4@brauner>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-3-8484dde66a7e@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261106-gmem-alternative-providers-v3-3-8484dde66a7e@google.com>
X-Rspamd-Queue-Id: 7793D40004
X-Stat-Signature: jqdp8hk89rpkjudbkquxi7tw86t434dz
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795164733-61557
X-HE-Meta: U2FsdGVkX18iOwG9atEpkDjKa+NWejlKui+dmxFi9y+Dlp09ldovth9lJ0igXR00OLas721XtoGy2FkOjtn7jer2SA0xjrDHUknXvmRFSZR4cybLU9vlSzcSUDWGG6PDw/spUx8P9ziNYTrkCaILghsxz4WC69z35Yw7wb7csvbCh2+ULtxiMH4xCVbmnINdwiz+l+iJZmmey9jzF5D/6pzpOjx9v2zDzJ0ceJv6oohY25Z+OQKGUeZ4adD4sstlcprqNWCqr1C07WIjqEuLnQ8340m6L5VCNXpDQMC1A49N5q6s+GkwUe4P9efAr/AX/MM2yuj+DgC1ur+useQJ4K2/cOFnbXan/K4/SgMHOwegAsZgDXUEkvm75ZV2qKlSGmaZRmWWHTvApA1GjlwT9ao94oKTwxwpsCWvB1mNHkIAvFfP0owRSZl8B3rQmr8zYCUoIiePzhHcyPg81hqRTNIvOffs5J6pd9+RGp4Cetcxl/Jcd2lZvzPALrhkGwWglACKh+/IVKG5rxKt/F69uWk/USiRzhovKAMZS1k6iLDYaA3tx9Ih6gkgQpLM7l3tXalG8uMjkrBzLSLA3uZEogLNO1eJ/fWFJWJagJ8oz3YjqyEH/0owRBGiWS2tdxcfNfWB+VFjL9tZ4ixKoGUsweGj1VeT8nFcPekRs6lhOj2jElksaL163TjuYT662cVgXdQIAknFpVjR5Q9xGCGoy/uA6bFNWiDF+E9oW0HDdQAWEWo2BVOultM46VtIjtPdwphiu8JbzSn/DKZTtgBAHnkUJPnkBT8q1/hwYMvH7sGQlRglHXCrrTiGdZ3fj27bNvtT6nAR+NE7A6g8wh5JE6RRlZ4kfd/DOP/laub/WF/eWqkCDLfOdEVQYVdDimb4UcCS/HfoTGL8GOikyw42Nr9TlZdsBUEJ/arL3T3dAcF/b+wJBaZOy10+JBpaI6Hd2QkChLL15Pw9ySj3u2M
 I6YD8pXf
 kBjuzBp8JEH9CvytQ7QVfDfTrpoQmwN0VBb+OlQKX2Km6HeYTfE4BjJdVJhu8oervORobj/+earUpKvVu7Ut9xotawTeAZ9j+8w+1cdN3ZvdRzMZfBgNcibIohdQtjXcnUERZvFaPuHM01Yhp7C61p3hU1Fu3I79bW7dok3OZlhIuVxt6mTtVATetHSETPT9PPnAoYaW7MssclKaTLRclOcfGEVwjQVIXIBmABIa8opt0VrKYkvFZxDEv7SPu4aAxeElOG/v53OD3bCPGjFHBl5/48RFpXVaqB/nz4jMW7FRtJctedJgxzMJjazOjH+57P2B5STKZUjkygzs3JzYYDk6xrQkjGgc0cd2ZeRFpZ7bYtxNe5pSM+Tiouz/z4bPcke38XxCJdJdpNPvg6d4bHQJnhdhuL4UAwFPVtPzcbrgAySpKJyTyLGUwyWjFspT4+J3x88+zlWO/Hyw0WVODlWBkL73OsY4a9X4sheBNyka5Al1jBD8iTSVF0OI35XVHn582SVINeZMwvq3btaPv6fgeWltoiur9aP1YpMRXcYBjXzxBh2EofjjEMtTe2muS8f7kIyctDvjwruE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 04:36:37PM -0800, Ackerley Tng via B4 Relay wrote:
> I put guest_memfd_provider_operations as a pointer in struct
> file_operations. Being in file_operations generalizes well to other kinds
> of providers, like devices, which don't have their own super_operations.

> @@ -1960,6 +1961,9 @@ struct file_operations {
>  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
>  				unsigned int poll_flags);
>  	int (*mmap_prepare)(struct vm_area_desc *);
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +	const struct guest_memfd_provider_operations *gmem_provider_ops;
> +#endif
>  } __randomize_layout;

Sorry, no! struct file_operations is not the place to hang KVM specific
callbacks off of. We didn't let KHO/LUO hang an ops table off of struct
file either and nobody else is getting one in file_operations.

LUO registers handlers that recognize their files by f_op instead,
memfd_luo just uses shmem_file(). And KVM already does the same for
VFIO: kvm_vfio_file_is_valid() -> vfio_file_is_valid(). Do the same for
providers and leave struct file_operations alone.

> Setting it in shmem_dir_operations allows directory file descriptors
> opened on a tmpfs mount to provide memory to guest_memfd.

That is weird. A directory fd is not an allocator handle. The folios
aren't backed by any inode in that tmpfs instance but they're charged
against its max_blocks. Which means statfs() shows space as used that no
file in the filesystem accounts for and that you can't get back by
removing files.

And also with CONFIG_KVM_GUEST_MEMFD every tmpfs directory on the system
gets its own file_operations just for this?

> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +		inode->i_fop = &shmem_dir_operations;
> +#else
>  		inode->i_fop = &simple_offset_dir_operations;
> +#endif

Afaict what you actually want from tmpfs is a mempolicyj a size limit
and noswap? guest_memfd already has a mempolicy. Teach guest_memfd the
rest instead of turning tmpfs mounts into a memory pool?

