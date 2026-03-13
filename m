Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8754A107BCE6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 21:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8746B0088; Fri, 13 Mar 2026 17:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965B36B0089; Fri, 13 Mar 2026 17:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871B36B008A; Fri, 13 Mar 2026 17:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7646A6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:36:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E530140373
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 21:36:46 +0000 (UTC)
X-FDA: 84542349612.07.D77A834
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 78A734000C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 21:36:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRo1BJRo;
	spf=pass (imf04.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773437804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6ysyqeJ9RIv/IRqMDKuPf5tYsTy4baR6Mw9oGMkUyA=;
	b=tGcHpDRHy+Ei4+DeuTSfybYj2iPwns2PiZhbOof5XOHVpgktr20QHzxkGck/MWZCYnhJM+
	K5Lw3b2YsmUeLzfgso3+n3RqvbDbyUXbaXMY3NFKR2LVwL8bB0W7aROwGmxOnWs2nyaTdc
	/ogA0S3Oo2ohAaUKGTGppoqaBMLFQEA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRo1BJRo;
	spf=pass (imf04.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773437804; a=rsa-sha256;
	cv=none;
	b=HXKf0f8ot7bQlDdZMpe2GtODY+yXnScFR96En8uCWCVs9TQkgqe2iAitLeAR3WsoAvZRMZ
	o5bhD3lS7prg36rcgJtDgOoWRT8FuLgWP6uhW3tMfHLnXXENJ3KDXmd4ijHi9kVvJAHDZK
	NB1q/7n/6RkeMmokKa2yLfgy6Rwyj9Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A163C60132;
	Fri, 13 Mar 2026 21:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE9CC19421;
	Fri, 13 Mar 2026 21:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773437803;
	bh=hU6Fe6XYGxziElGzs5uGk03JaLC6mdF7RLU66cbBXSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LRo1BJRoMYnJ8ZEhxjLCUF62+obEtmZFuayPRQThcdx4lHWmZYYix/fPOKngPqS6T
	 r5WRZOMSCluK4oWbgts2a6ni7A4AdRH6ngAnEAAQMJfwlER1V2lqPOngfTYKo5nP1Y
	 h098q59sqHQPYatJw9aKAQpaL4v4XGl4F644QuLAGDk962aGCL6w9oFn94C4VW+3oF
	 XSlrbDuqjJfTCHhEIB615Id5lgdGCOGO2ohevFhfgdWwA6Uc6svL9GvyOHLjTFXF3y
	 OuyCTaxq7+87HaSz/0sHOx6rCUInPffG0NUHc2TAfDUiMOIQ6ZM6F69onbJArRL6Ll
	 dIkCwzUe6rYwQ==
Date: Fri, 13 Mar 2026 14:36:38 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Mike Rapoport <rppt@kernel.org>
Cc: kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Mark Brown <broonie@kernel.org>, rust-for-linux@vger.kernel.org,
	Miguel Ojeda <ojeda@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [linux-next:master 5585/5731] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
Message-ID: <20260313213638.GA147391@ax162>
References: <202603121235.tpnRxFKO-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202603121235.tpnRxFKO-lkp@intel.com>
X-Rspamd-Queue-Id: 78A734000C
X-Stat-Signature: kf1nmyeaihssmbo63j8drfaxs6f4fntm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773437804-252779
X-HE-Meta: U2FsdGVkX18X7LjChAB2e1eGr525u8CG9siKkm6dXSW97Ak1sFUSZbH257xowH4UNt1vYaRm2y/90vMJWU8T5KBYxH5yBW+fzSWnQSFRqGHJfGjYNFp1GRiK9lVXWtvnNWbvNFxo7sy2yNc2EsVgMkZhdTamiPnZgKwgdlJZsycil4/iNwGmvmmwI57G4290l3p1HOmwbzodKgTT5JxC5SrHlpjOACjt6ULZS+RptQS8oM4lFoRKx2VPr5u9cAilQqbLO4YBJ1KzHeDOIXfr/S4VYljibtBc4vOe2WrwigzuGlZhYjA8SmGiIWSz7dBh1FZnDkTx4htM5RR116vgAVH9qoB92HS07D0RqqHvHRwMVantKJ16UVPq/ZLdHZ3nMGe7NV2vzjHY1KixgRHR8IYHA1YwkKfm/IPAlK47HFScVfTr1+DTrRVJV+pj3mG2GfL4NSPtSLVRAa4ZVFGNPVdKlB0pKixXC2xtWSc2irCApC23mDZW/gR/ZOTCiGDK/icRssJ40inZd80sQxgI0QFEvXX/R8TTCNThi6jnkkOruCDYHXj4hDcsyEN74C1pqLJNWXcRFhKEMDTWpgLbx0cVytiTj8heCkwsGZcWMS1n6aTKltylS4nN2zADbDj8tfE0mGPQrQUhgRvr7Lup4/9oygo1dmKF/CgeJvjh9qqYVV9lc2fQCMhgCvDlNXlMZ6Fpy9piHirx84/692TxsbASkdGjfF4/XacXD+/UY9DZLUHBzbvmMZFfGK+roxjRNyIS9YSnLAIrDvwfEGzpOWSzb+v22Lh+GPew0l74LSdaoJtzaKGudewcEhaMLIa7cNAPwRE0AntIVXOIeWxVZu1j0X4ZckQ3HlMSdeutL9wsHKhGiexS5TYaAjVr4iyfCXKivcNey7dtNXdsC017TsmXpbStvB9BFLFSwooTtVeC+AxcAMRB9MGUOa4L9DlspI+Fqx+/EJRjbaPvBZj
 5R64XfWG
 Ekef/OROAInhJfIPhuiuyXFxeP4L9734nDauc6qyQgEjak+f4wi1FA5qLk5HfRsfdHqdNTytMWZ4By1/vwLHyI5DO1FzWIDZ5qYuduHVSFg93coqrobTPKdGTfK7urjEyaTRIjV7V2GZ0c6BxVUX5bBJHbrCazp90i10NOhNMdmOqXCi1TDqTzwPvOlPL1VYO3wlZcyrxwCVQyFTfvcaMg89gj8N6v0HehNdz2TuQgrGqZivuUriuoL0KqNSLHnnYi/BJ6whp8gS2ut+yq7gSPvMMemq88fHPnKCHqrn51ODD+oeqsv3BKXrKb1d7nuCnT/Ek3SzTDXSQnMJLzN29ytyLrnRshIDis9/tEsGltJZNJ5VcUvrtRaUorg5gXJtx1cqAORpVaji60cGUiTd5lW2jr8v+bF2MZuBOXss8S5evj70OElYFo3xZvCVOMcc4byZk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ relevant parties

On Thu, Mar 12, 2026 at 12:21:07PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   f90aadf1c67c8b4969d1e5e6d4fd7227adb6e4d7
> commit: 9ef1985c003ea271369c900a93f8b834119fd150 [5585/5731] Merge branch 'mm-unstable' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> config: x86_64-randconfig-002-20260312 (https://download.01.org/0day-ci/archive/20260312/202603121235.tpnRxFKO-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260312/202603121235.tpnRxFKO-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603121235.tpnRxFKO-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
>    --> drivers/android/binder/page_range.rs:146:23
>    |
>    146   | static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
>    |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
>    |
>    = help: within `kernel::bindings::vm_operations_struct`, the trait `Sync` is not implemented for `*const kernel::bindings::vm_uffd_ops`
>    note: required because it appears within the type `kernel::bindings::vm_operations_struct`
>    --> rust/bindings/bindings_generated.rs:72795:12
>    |
>    72795 | pub struct vm_operations_struct {
>    |            ^^^^^^^^^^^^^^^^^^^^
>    = note: shared static variables must have a type that implements `Sync`

I see this in next-20260313 still.

  $ cat kernel/configs/repro.config
  CONFIG_RUST=y
  CONFIG_ANDROID_BINDER_IPC_RUST=y
  CONFIG_USERFAULTFD=y

  $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper defconfig repro.config drivers/android/binder/rust_binder_main.o
  error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
       --> drivers/android/binder/page_range.rs:146:23
        |
    146 | static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
        |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
        |
        = help: within `kernel::bindings::vm_operations_struct`, the trait `Sync` is not implemented for `*const kernel::bindings::vm_uffd_ops`
  note: required because it appears within the type `kernel::bindings::vm_operations_struct`
       --> rust/bindings/bindings_generated.rs:71347:12
        |
  71347 | pub struct vm_operations_struct {
        |            ^^^^^^^^^^^^^^^^^^^^
        = note: shared static variables must have a type that implements `Sync`

  error: aborting due to 1 previous error

  For more information about this error, try `rustc --explain E0277`.
  ...

It looks like this is a conflict between Alice's "rust_binder: check ownership
before using vma" [1] (currently in char-misc-linus [2]) and Mike's
"userfaultfd: introduce vm_uffd_ops" [3] (currently in mm-unstable [4]),
hence why it was bisected to the -next merge commit.

[1]: https://lore.kernel.org/20260218-binder-vma-check-v2-1-60f9d695a990@google.com/
[2]: https://git.kernel.org/gregkh/char-misc/c/8ef2c15aeae07647f530d30f6daaf79eb801bcd1
[3]: https://lore.kernel.org/20260306171815.3160826-8-rppt@kernel.org/
[4]: https://git.kernel.org/akpm/mm/c/52b7ee1715b88c61fe0696db31ac90181999ec2e

Cheers,
Nathan

