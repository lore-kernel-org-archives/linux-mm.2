Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79866606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fXwHx+qz
Received: by kanga.kvack.org (Postfix)
	id 95C6A6B0BB2; Fri, 23 Oct 2026 13:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C306B0BB4; Fri, 23 Oct 2026 13:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4A66B0BB5; Fri, 23 Oct 2026 13:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2956B0BB2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:29:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4109A6CA8
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:29:17 +0000 (UTC)
X-FDA: 85354577154.02.7A4EDA2
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 109AD40009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:29:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fXwHx+qz;
	spf=pass (imf17.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792776556;
	b=SQHFgkTyC9XEh02iAnjQQkHt0lmwVX83BB+zMcpRBsmDlutJyxX1Cv7PjKIFFlIIobiKuN
	h+I5DJgHkui1CjPXEE91EQdcVz7+GATJ8Y+I2nxmnCyxnIPPrpRqKeV3wP++ywzdL2TvvP
	XTgTyF3+Ad0D+RbHl8Rf6J3MzZAkqY4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fXwHx+qz;
	spf=pass (imf17.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792776556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Qj0y3/sB7EeSLYwSP8RPCK8AZrmLUoRtMMcxttoCbM=;
	b=ueCZLXaYM8sO7Wv7PwuAGDs6QZo2IK2FaIC6eQHSVO0G8idbxN+KOsmPDOF+pfxmZoe2V3
	nLfNhufm28pcLH5zgmug2YZ6ncpbNNkydjHlRY+RYaOYcGZRc4woi2zvS0ES/Ttafs4btq
	yroVOBSK+e8NxExKVRUvCNzi+8FljqE=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so698177f8f.3
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792776554; x=1793381354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Qj0y3/sB7EeSLYwSP8RPCK8AZrmLUoRtMMcxttoCbM=;
        b=fXwHx+qzqamEHlutBD/Yzdyranm/qM2aZiivGf8go/7d/jwAW6fSmpqQx+531kdT1N
         5MO6CqwYhONUA1rUgTvPn68rC8OvEW75O76CTVy7ni4WGbWR1OAGSXU4YTbvu6GiLCwd
         qt/GOHKJKM+9tIV06UmIJY7pw0dF6hnB08VIxQvJHa2sAouBo7M4U4v87KORy3x7YyeA
         TG6WItdDFO6sXPNGJYsPmgHpijJcPe46aThPkQQUYcHOm2D9Z/JZ7nDB63H42OF8v/uj
         oAM1S7Hwl69fkIz5RCVWzFvacY4HYLk4q7dcwyR/ohjL2sVj26V0Z9Fw4LnhwtKsrZrH
         OmCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792776554; x=1793381354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Qj0y3/sB7EeSLYwSP8RPCK8AZrmLUoRtMMcxttoCbM=;
        b=WrNpuZJjq/bFhqTZGyTU+4Oa8ic1JXOgtvhU0m95EKpMptTTq250mGIp8r+4HUQpn4
         0QycgJQrHjD2v/sTX83NPd/yM1gXEtXROnAw9UIWhZnXuFwwYowG2gxuhGYUqm4shF6t
         tHnQvvrgzXD12yaMFvj+bxRp/6K74C04dacodRwYMCJ1u/GKbdPHIeCbmStDsTqoR8j2
         LAIMdlYnCANQ1IdeQ/FPsqJd2APDaRwo1iC73dkinND8D5zgr+WM7AV7DwHmdQ8f3xLc
         5HYgozz4nDvX4GaknestsrdGRlwKgKtX3O4Uer0WgFCg66IeT8RNYPrPkolLOkG/eDQE
         kQ7A==
X-Forwarded-Encrypted: i=1; AKwUvByPabspnV1+VEj8+AxG52PMvrGoAg1jc/6+mt9toEeSRNjf5J23AdtW+kpWGlEBGB+ZeedbnRg0Cg==@kvack.org
X-Gm-Message-State: AFq9FYI8lweMt57+qgeA1dHXrVpQs3++ZH2ynXFx2+EFbGA5zanYC5oH
	XJl86KrRIAWVXiWEnfwEPGqu8men3PJWr2FDS/hMdNpNt9bWgbwO/Zzh
X-Gm-Gg: AYBFou1h/PXdXO85OqEQod+yY1EpQIj/+z8K5GOCMN3eTBdCwf0WUHydjca2ogSxkeg
	OcuMoKsnNuV5wg4BqBooMR/dD3ThwK5+NIrb+c80b1Wwgf1eTkw0MFK8a7DLesAGC2w050n0h6G
	O+dgdCfDZvYuN25XNDHf37ZxhyOTeJizABQ9/nY5fP8m1OekJiXOUjIU9zBdptPfqql2zolTwSd
	sCCDqi/ys5AH5IHakiqzgCsnXb5GtHpl1u/BK5dv74cTrAvGAEOFkOcFOOV8p+uAXQt0uAoGpsg
	WxSR4rXhPWvCI8wfwCqED8sNwjAniEiY7nUBY7uOTOx/Tqs94tcD35zQV9N+3E22G/mDfhe1Qvx
	5uLqvF5Z0SaGvm9PpCtLUkFETtKQwt+X92oVlGaA6V2Ab1D0phrn+I6mqnSHxvh9M2xDgRpnlAL
	E4SXJ19L7xNiqqORKZZSaKJMsLK6xtv/RZOwykgceB+SLLhLzTTFhobIxDQZER5/cz53db70LI7
	0OUtfoD5UEqLLMMHNPexaXDm7ydJ1OAQ7nPjLlDznAD7l4uOE+Neru+PmRrFSadp4qOayEbJk7g
	kZXLjMONA5xeSvs8FqaMDbY1M1xftSKBLEUlRkidRw1Yhm9+5vrHpqbXxFXv9q8bfvg2JBuo0VC
	0AjTHoXnZ7LrAr9kc
X-Received: by 2002:a05:6000:2004:b0:486:f9ea:796f with SMTP id ffacd0b85a97d-48e387d65ddmr4932292f8f.41.1792776554351;
        Fri, 23 Oct 2026 10:29:14 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3d4144f8sm1120262f8f.41.2026.10.23.10.29.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Oct 2026 10:29:13 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH RFC v2 34/50] KVM: guest_memfd: Skip checking outstanding references in PFN mode
Date: Fri, 23 Oct 2026 17:29:11 +0000
Message-ID: <20261023172911.17557-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022-gmem-alternative-providers-v2-34-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com> <20261022-gmem-alternative-providers-v2-34-5dd1dc6c660a@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 109AD40009
X-Stat-Signature: fa9cfs87uz9ak3w1b983kz3mhpaughmj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792776555-420373
X-HE-Meta: U2FsdGVkX18tb6TV1sW3U23iByQPH57aP1ah9xvwgcPwvu/MNzFdz6QlOcCv4gmNw04tWb1Fn+O81+3DCZ9T2LNp2foDstncVg2Tpus/Vd2aIPqztRc3hiFU53beIVjCiIfNtBDlWXJM6wqWn6rYkCK5Y1x+wtjq8TWzbV38C0Ixe+yzTXgvmq+UfoxkWFhBoIVwW05+wUy69LqHnPCavGfY7joFMWjlqXJU03FvMTXUq8ikPBD3y0FVIX+EV5Wo5wbw+PvuvTb+MGCzO8L0/45xQYWEhJKbNvRML+qHEYoK8Emc1UuCNgZH6+KY9KiC0hpcmpDjk4vFK1TprQ5ACpWRrnHidbrD8NuIoufpqyfBOciU5QgWjw33OGayHTe516t1XOv2PhWWAJhWkknieyk3DNAYK6LV+KwvtGvPfQpN55oxy3W+JUhPBmaNpBwyOoxLZX9Tkfhq9iTG+ilyPN651LjNkSGH3zmlr5a4XnuoX4jK2ABO4EEfF3T8d5dvzNZk/7VxwKFNMSfllGM0tTjIXvBiHCDSE1yJNZRCSz45jTnVIQlMf1HEdWO3I94q4yIj7W4sUiHXn/048xeEavIdJCZlrzFskTII3pKG75uwhGiLwVij8Ip1V4oJlObbR0Ic/piirKCV2qn5Ypahf2wCx4VxtY1KsZ9ryLOqRQK36vhE4DgsHbqXWehT6zK/zISp2/A83BFmH5ojEfW3ZxE2CKHwUMv6UC6AfWDfGNVjYCIvjQCgCad43RhhR6+g38u7bstVsVLs8K0VoZ/7fJZZIzLXYBfy1VQzz34YLtiVkaHkdFao4JHtYb5Y38NUhoH+IR8HfpSUJTLMdY6XzaMaqWvpzLANSEISmFfldWEDfzN/fhHp5cXEBuaCpNizrj1S1sNYZ4cWrFdIrQLDVsuqVQzlAwjfZLkmzeIRJ3mqqSBvBnB6hvmGvWusifCv5LPoRcT62+jTBueB8vL
 HhKoRC5G
 w+XdFpgKP+iLEZB1mWEgbCtwZtkW5IQGb3WKfzxelyvcKzli8r/oHFAfbOMS87GWB4YpalDOSILNOrxXvUwLbZhq9/6HEVKI7P1LoX6LYbkfeTIeFwIkbi1SYb/Cfe3u2jelLFy23gQQPRtHSJRZBy4b4JXg+kw0/B0O8GvtP6Ch+OJZ7Vv+XNrQi7AXc+smobptFx5ELd3qn7Z1PX8zChjfaNrSvsqfbPQuakQPOpgW+t0aIh4PE7155yHCOau363FEws3Dq8pstTOvGPiXw6hSW9Are6Gp0hp+RQ8ctbGqN8tD5gKY602Ronmm5acwEsTVj8P7Ta2GHWEKCOUt0gJNKk/8bdUXCX6D9xObvuZyC07IDJ32Xs0HCUbd/X76N04O/Fn2JJggSWDpsX7/sPz3le2kO/KtU9P6azgFZjWwOFClO/HNJYLqVZ/Xabh7Bk2qJ8I+BkbkmybzB16bLuU/c5MnwF2hQRbbL1m0W543oat010YU6H6DPCqh7C7cimpa8sg4cvpM3Aty/ttIZkys5PpojkuDV6R4dpzJ0YsqXOlsO9PEybgQ5m1veL9o/EO//0b0UuiHzuxcP8HJg3V/JHhUtrre6cx3PzC3+b+OFU3bpFfkO2sdbCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> +		if (!kvm_gmem_is_pfn_mode(gi) &&
> +		    kvm_gmem_has_outstanding_references(inode, start, nr_pages,
> 							err_index)) {

In folio mode this check is also what guarantees that a private page
belongs to the guest alone. In PFN mode there is nothing like it: if
the provider also exposes the frame somewhere else, say a ring shared
with a device, the VMM can still make it private.

And it is not only this guest that suffers then. Whoever else uses the
frame breaks: an RMP fault on SEV-SNP, a poisoned page or a machine
check on TDX, a granule protection fault on CCA, or, with
SW_PROTECTED, silent access to "private" memory.

Only the provider knows about such frames. With an attributes output
from get_pfn() (see my reply to 31/50), it could flag them as aliased,
and guest_memfd would keep them shared: refuse the conversion, treat a
private fault as a hole, and refuse populate.

Fred

