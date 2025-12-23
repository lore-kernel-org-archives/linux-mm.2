Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5715CE6FE28
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 20:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860346B009B; Tue, 23 Dec 2025 15:01:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837756B009D; Tue, 23 Dec 2025 15:01:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DC96B009E; Tue, 23 Dec 2025 15:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 624776B009B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:01:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 12C4760490
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:01:52 +0000 (UTC)
X-FDA: 84251806464.10.8E98F2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 67FE91C0013
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:01:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F3089+kK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766520110; a=rsa-sha256;
	cv=none;
	b=xNpE+lKZ7UXVJ3K2tKn8NecWFKMGquZ/OrSHOQB7mjhd3X5S2bGtqByYYVJXNgI9XG6UyE
	nq7ua0TDEdxE5LtseaI69h2NBLredHxIA7xfjc9LotjyRiIqD42/30WDS32bq96Kwzf85N
	ESx8ZH39brt8QM/T7CPla03WRyJ/fiI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F3089+kK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766520110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnZ6kO5BPuNTIYc6qt8pQoz4cYcx6rN0LMRPtbq/wlc=;
	b=U0XYyHSunHVaETWBDHXO677BunuVB56PM1BFsaVSuVt+9MN210oZOKlNmI59eI1g7DtR3q
	m4J9IU8kYnwRKtsSqpJ1YodofSmcJQR/0YpEo3MRlsvpIrjgx5L6RcsbxBLs5uRJ2VXCHh
	Di/ftC2+jogZb2W3qo2wynfEAPvXg8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3405C40688;
	Tue, 23 Dec 2025 20:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B991FC113D0;
	Tue, 23 Dec 2025 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766520109;
	bh=Qxn4jr84MKZwHdU2ArxP6nvb/lDyL5EfjYRKLN4rhAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F3089+kK8Gmj/7l9EkOE8wnmtsYvSgtuK8p8iS8qA835gQ18z/0qucubvrd4tXhBr
	 oXagjUJoJLWQbR/qejTyI7BWXZAWuojSEbFO22Zn9RKXvlpxBpzLbCkJmskTFzk0mc
	 2r66qg7waz1ZVpz7Ewy71POvdpxiG2ajz3ifdvGPWK4FSDpBrqvIZwuTOUwsHVFuKM
	 E4wJxZKR+q16GX0hMKcVUPV7SPWFLo7oJnqTJWrpXWao4fQ5tomdELt/1vEG30Uzr4
	 VSFjy5buTgefNg1H24xVeMHyYewGYImce/TLY4Wl6Z86RqbsW9brPUEA10+ycUa8WO
	 a+0vT9Ma0kXbg==
Date: Tue, 23 Dec 2025 22:01:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: baolu.lu@linux.intel.com, akpm@linux-foundation.org, david@redhat.com,
	linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] mm: fix huge page table not free after memory unplug
Message-ID: <aUr1JvayxrqeJzZu@kernel.org>
References: <20251222041117.44865-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222041117.44865-1-yuan1.liu@intel.com>
X-Rspamd-Queue-Id: 67FE91C0013
X-Stat-Signature: 89g6fadgfjcssj9gf4r7dx8xxntzehby
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766520110-484101
X-HE-Meta: U2FsdGVkX1/jCBFWD5HOkr7cZ18kbie3rCMkeKv/+Lnrf6BgBfHmSXZ290tv/EBer/xIC4uyNDoweKIejZfTR8jZSxIF7VPHk4xzbll1sA0RLZFZTFFlsQhh6uY3vd7G7g5ATbLRSaim4cEXAkNJOPZTaUyoFYCcSHW8QhEoUKrbA8wRFgti81la1/f/8dunCH6vSKpswr3+HYQkMKn6W+pgEfb9EpyMvBmZrAj1vz8mdzVirguEzx1DLS+XR3rDYp2zrJb9tkN227t6RpokrpHotPsla1pqTFwDdvoJOUexvJPBMIW/46UOp9MYj3jtF5TfZcpXKL91tyM8PWJWj9lb0aBeTfDFxkZ4eB6Qm12TYUWM/8SKKZs71wCDX0YSXgtBNW1JZW5f/9ED1liSps5M9YsnKxZQSy1+7xIT9e2JsPUlbpWsEygu0e2pf8ciFpH3M2xPN/1D7J76Yjx2/0EHGReheDjkg1eWGruz1VciWrMS2/5uDLrKJ0ex50PbKL3WRsGhyIETwqKRRG/zCaBHfJe7H2kzeEJLKukC3qcqhjwTJOF5YqssBtz4Sqa7S+zCoanF+6oygHHgyOK0FY9BRWr9kB2rd6ToasVEzh5R7dVoOjmKiap3sJzC06KntMv+s/D/RHXE8WCPvWG62+pW7MlZdCRUQn7kYkmuVJFWp3kVNldRZoH3WbN9mCssnSUGsVR3eegK3estUcigYv2JFIOVQANPUpYy/zkTy8WK4r4sCrBUSKqbCRWLRQjIUsnIH3GXpEGC9tCOysIcIG/BHfLDI38+GC0ajRjaPHEs7HjUVAROFeAboLuRxKFL9qgDT22E82U01a/ZSZ3VUOQyzpSSWNu7sBc1hHJ9cmXz1XcqOSfyxVAFVU72wY8acT9nyOYT1pg7URuQ7tb/aPGhaqTaiPVt2x36A2fDG+smW/Hf5Ey7eWMocR5/0SkvXcCkG8nh14qPgzP2j3p
 pEA/ac3v
 rwjzTqmih9AC70IVUpuHw9aNR21vIHMvdJ/vjjq21F2xcFRLyuS7EcpCnMDChNTRv/9biCMcQ3DPNKrCrhOiXJCAFLGJIGs4iJWeDedzWzBtpOt2SNNGiH/qtpTxEaHtwkApjKPEgX++nA/IOYIlZaJ55ShCqNmDI4Bua7ypqcHfL4dsRsPbkhU+bXykkAuEvH3G+KuUe7xQu92wiIMc1In8dMvydAnSPbu5grxu1gj3pp+sk9lbINOUTFWWNzUUfv775XlIdGClI2219vN1nuoJlog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 11:11:17PM -0500, Yuan Liu wrote:
> newly plugged memory is marked as prot_sethuge via phys_pmd_init
> without setting PG_head. During memory unplug, free_hugepage_table
> frees the page table as 2M, but pagetable_free handles it as 4K.
> 
> The following test case of memory unplug for a VM [1], tested in
> the environment [2], show that results.
> 
> +-----------------------+------+------+
> |Check System Memory    |Plug  |Unplug|
> |via free -h            |256GB |256GB |
> +-----------------------+------+------+
> | Free 4K page table    |257GB |5.6GB |
> +-----------------------+------+------+
> | Free 2M page table    |257GB |1.7GB |
> +-----------------------+------+------+
> 
> [1] Qemu commands to unhotplug 256G memory for a VM:
>     object_add memory-backend-ram,id=hotmem0,size=256G,share=on
>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>     qom-set vmem1 requested-size 256G (Plug Memory)
>     qom-set vmem1 requested-size 0G (Unplug Memory)
> 
> [2] Hardware     : Intel Icelake server
>     Guest Kernel : v6.19-rc1
>     Qemu         : v9.0.0
> 
> Launch VM:
>     qemu-system-x86_64 -accel kvm -cpu host \
>     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>     -drive file=./seed.img,format=raw,if=virtio \
>     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>     -m 2G,slots=10,maxmem=2052472M \
>     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>     -nographic -machine q35 \
>     -nic user,hostfwd=tcp::3000-:22
> 
>    Guest kernel auto-onlines newly added memory blocks:
>    echo online > /sys/devices/system/memory/auto_online_blocks
> 
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---
>  arch/x86/mm/init_64.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 9983017ecbe0..1044aafd5d94 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1028,7 +1028,7 @@ static void __meminit free_pagetable(struct page *page, int order)
>  		free_reserved_pages(page, nr_pages);
>  #endif
>  	} else {
> -		pagetable_free(page_ptdesc(page));
> +		__free_pages(page, order);

The issue is that the page table page does not have proper compound_head
set, so the fix should address that rather partially revert the commit that
introduced pagetable_free() here.

>  	}
>  }
>  
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

