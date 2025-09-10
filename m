Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6BECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4C38E0014; Wed, 10 Sep 2025 12:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC318E0002; Wed, 10 Sep 2025 12:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8E18E0014; Wed, 10 Sep 2025 12:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B69C8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:50:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFCA5139107
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:50:14 +0000 (UTC)
X-FDA: 83873928348.07.4C5B4E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32D84140012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:50:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CPAOgAbm;
	spf=pass (imf23.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757523013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssFMi1sJkq3DwLXtFEHozIINPdAKzWOlmS2TKLbZ6EU=;
	b=XiDJ5lmMVMIsX+1l+t6zexW//6+JsPREuY6k45Qs4852htsLYb5C4q4NMMwXvmwXmvEbXA
	OtZ6aOIIPHIcomnchLgRCkyA7k3bT+cVEvJHEb2CUhbeShQ7oPtkVStm26lM43NK/2g4xF
	QJJYKv61CgAuVxaYDaK4kIQl2LDzM9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757523013; a=rsa-sha256;
	cv=none;
	b=jCGbGpypz1yMFYBoSN7vvemHaqEg9iNlx27RtETdTOwu/7y4matIT7vi+lfjVzHPvU6IU5
	K22kZlH9d4ZvsEmczuAu4ZJuWZ6Oz0R0qkNG46g/4qYkk9mQB6cufbhbrGNihnqojYtGyH
	ZrwLR/L2Y9+d+A89OtxPnVkVTJmU0Ww=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CPAOgAbm;
	spf=pass (imf23.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0C2843FCF;
	Wed, 10 Sep 2025 16:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB16C4CEEB;
	Wed, 10 Sep 2025 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757523011;
	bh=ug5CvfYVPJihh5Zy5QREZIKCevb4x/BKaIGi7u0wAkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CPAOgAbmybkyYUUePXHpTFbjK4/sSheXD5Cb30bErD6cxup1wf9xVxlmDMRNMwIRT
	 USv2axQrbQ9wY+QTzUewNNHgDwGIdgP0EjSPGNTVuC9d0QkPOrgMA92s+XiOFek6X1
	 PGMz9vUOXTxn0jSQ3m8DaC5UtBYLbIJXCJZ0NwZftg6ovmRECwNzzyDuBU0ehgCApW
	 EEOuiAPzHvdeIAFmWJxQp2PNt2U3wGDVHlH3skZ/ypc4gZkH9N44g0S0cm0zhGw28r
	 TpE4NPHIm94DswLhRiL/EjL0BtfMRvLWNDtU8OlRbNqE+QNkJW4kvmOlj4D7+u+QnS
	 LICDXPxSa2YPw==
Date: Wed, 10 Sep 2025 11:50:10 -0500
From: Rob Herring <robh@kernel.org>
To: Andrey Ryabinin <arbn@yandex-team.com>
Cc: linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>, James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org, Pratyush Yadav <ptyadav@amazon.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Chris Li <chrisl@kernel.org>, Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>, David Matlack <dmatlack@google.com>,
	Saravana Kannan <saravanak@google.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/7] kho: replace KHO FDT with kstate metadata
Message-ID: <20250910165010.GA223810-robh@kernel.org>
References: <20250909201446.13138-1-arbn@yandex-team.com>
 <20250909201446.13138-5-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909201446.13138-5-arbn@yandex-team.com>
X-Rspamd-Queue-Id: 32D84140012
X-Stat-Signature: 5h7r61pgxqub3qq3hcyiwriskeb4gas3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757523012-679380
X-HE-Meta: U2FsdGVkX1+Vv3pe1eWc6e+cefRz5Z5Yju+qB8a5l3yGNgUirARmEfVKgivotIiUs0b302vPQNsMI2oWkY0bi28p4o4dSK9fk8pjOPkJZswqHcZq4SqO6PFuwhAVURO53rzuJXycsbVtHJsf3LeIYnp8rd+IagGcRpPlpga7hHrU9M28+1f+zIrKGBukwIrfm6EaBVjs2e4IVsazdpXb6nxRpOpVdNnCb+j/+jCIA3bCCmi4JWyOamPfrtNkiOp1UBJOH9N7/wh/Xiy9ugH1fouiVtAMoxrC7wbFM2EifClORm61WRUJr9CzaI8fONzSB7BxqkZRJ0c0YyUmFWDtRQPop5MJDCLoBGAJLSK+6d8+kqjL5njJr3itjVhzSyLEeAoR9NBa07J3F4Z7Qsa07Dr31lUwilnU3GuAvZ0beR4P0zh9CrczsFfASq0gyIgJe8ok8BLIJrPjCGL9YfYWt7caMMSZfbYMOPUgiME5ZoE8d9O+rAOvQ1ZqEDF/DD0ShPv2kx/KwsRsPAhvta7pSr53HRhy1TxT28JeMcsIO3t7ZiVd7XbTm6uT2lmu8ln0e0VEX/Q+fqDN1xxeLxJKVVxghsUKNd/sLkhx7YahmJtOy5LIRTuQK9xwczVF1cmACp/BaLemXYgHBXnI/5GzEqMXHdJ4QpUeBvdJfITK5iiPrc9G/SCYot5c4k1YPIg3qNgJRG4YvxGWQWxrITK1KX3G0F9mf+BNXF+eWjbS6puMXfcObPWD+OyCTq7kbpXd3yXblvkBio2X/chaF3W0vMDfh98Xw/dy46y/UtYL3PecDap2jlOKFaEOnfs/Cpb+vpA2icsr4L5k3HgjHZ4mAJD1sRLBYFHlBmQ0tQx29rChflmguuW0EVxRDo8BEen5knjiZY79CriBojR/TevoLBYigg7eor+pc+uYGWTWa761mL8baZy0VDaVDO3oeTvFdfN/q/P8kP9NRmOARx8
 imVvD3Ai
 B9usf7zt/snGPlhuZcMfxChSGYLONX2wekAe70B1LPg4/3Y/28LYde72jh1bhNQhZ23rmy1/V/g6d3QnqM/TKsZXi0BcNsNS8dD+RWO4LkYnSvqizcnr3CmUGmMjFdSnt8UavTDDIOyGl23pUYRqn/sYV5SJ1xxcC4GVrbNCZeq6C7Pcwt9bWPnWm+S8pRpNIjP7dESMSgPIBJONnpkWsc31vxpxm3O71Yq7sUfVCkKePlRP3yybypQJOznSa6BqSoNBHpZCWwZpHcS+9/eGUKceDnT6B5XnK+Tp9wHiaPoX43dH6Oz/pxzotywQp6HvGitw85nn9RG+orbkfc1fatESREgCelSO8ey2w4NgeWPO40BMMf9vZ6jPfFXUanPwok+1o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 10:14:39PM +0200, Andrey Ryabinin wrote:
> Store KSTATE physical address & size instead of FDT in kho_data.
> and initialize KSTATE from kho_populate().
> To be able to use FDT in parallel with KSTATE place FDT
> address&size into 'struct kho_fdt' and save/restore it using KSTATE.
> 
> This finishes wiring KSTATE with KHO, making it fully functional.
> 
> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
> ---
>  arch/x86/include/uapi/asm/setup_data.h |  4 +-
>  arch/x86/kernel/kexec-bzimage64.c      |  6 +--
>  arch/x86/kernel/setup.c                |  3 +-
>  drivers/of/fdt.c                       |  6 +--
>  include/linux/kexec.h                  |  2 +-
>  include/linux/kstate.h                 |  1 +
>  kernel/liveupdate/kexec_handover.c     | 60 +++++++++++++++++++++-----
>  7 files changed, 61 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/setup_data.h b/arch/x86/include/uapi/asm/setup_data.h
> index 2671c4e1b3a0..844f5b93473f 100644
> --- a/arch/x86/include/uapi/asm/setup_data.h
> +++ b/arch/x86/include/uapi/asm/setup_data.h
> @@ -83,8 +83,8 @@ struct ima_setup_data {
>   * Locations of kexec handover metadata
>   */
>  struct kho_data {
> -	__u64 fdt_addr;
> -	__u64 fdt_size;
> +	__u64 kstate_addr;
> +	__u64 kstate_size;
>  	__u64 scratch_addr;
>  	__u64 scratch_size;
>  } __attribute__((packed));

Isn't this part of the ABI which you can't just change.

Rob

