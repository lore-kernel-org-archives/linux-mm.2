Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42651606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KDXpE5ZH
Received: by kanga.kvack.org (Postfix)
	id 6706E6B05B3; Mon,  2 Nov 2026 06:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647A96B05B4; Mon,  2 Nov 2026 06:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D786B05B5; Mon,  2 Nov 2026 06:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4D26B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:12:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAEED160C35
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:12:16 +0000 (UTC)
X-FDA: 85389915072.04.79B9A51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 304E118000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:12:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KDXpE5ZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793617935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3QW/w/iY0YD/fqxj57gSpeQygMNXvAXA/WJlwwf7AY=;
	b=oFK8t+EvnS0x4n2YtSumgXwfNk/uVyUzffh7JPus0xZL7eIKOn3ieAOH6Z9MbXltNkcXOc
	KQ217CwToGgRd7r2eedpz9ifjfcQ1tKm/30UXeOuqrW/5HIWoDav5cby237tlC3Bpw4guk
	imah5U5IxhYmrFPP3xfmSh0UcHNafR4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KDXpE5ZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793617935;
	b=Ms+4p2rzRNL4RPt2sFtyrhFuRCtIOJMxUcH66/qLbEIX8Mi63DUZWGhFB/9tk9P6syC9/I
	yP/7y9Aqz1F1NMmXWYgN2qHjAdUG1gyOnQvqX28yDod4T+M//qWEx5lZzIVPenen8ajkU8
	Vg/WWKx7rxJRyNwNY31QcBC8UeOVEHE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A570660EF2;
	Mon,  2 Nov 2026 11:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A531D1F00A18;
	Mon,  2 Nov 2026 11:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793617934;
	bh=p3QW/w/iY0YD/fqxj57gSpeQygMNXvAXA/WJlwwf7AY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KDXpE5ZHAugBzRh7LbV3zOAVu3BfNLWIqbN74KktzmBSjq9HPggqNlTTtHPzs8ZyV
	 8A9nwc7c9ipCGjvlBYVOZAs36kcyoSkX/RroQquXlpQmAXJ2jfOu+BsmSxscRGo6pd
	 JY5ypURvzCSbsrqtqfiZqnmBMDWhF20DP+jadUb0fM9lwyrkY6Pe/fgwki/YgC62P3
	 ZBqmxMyitVHBe5wS9g5/C/CrsSQ2Mz2l/ojGbPstB7KJS2Lv5EjS8zb3VAnC7clLeg
	 D40LtjIH8e618txqVm10LPMDkZBIHm3/iNBPqEp+wxppfwmDIOirCGmrbcxnsbarXb
	 5D5BBbKCETxYg==
Date: Mon, 2 Nov 2026 11:12:10 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Julia Lawall <julia.lawall@inria.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Suren Baghdasaryan <surenb@google.com>, 
	linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: drivers/hwtracing/stm/core.c:509:8-24: WARNING: stm_fops:
 .write() has stream semantic; safe to change nonseekable_open ->
 stream_open. (fwd)
Message-ID: <auhvGNG1fJBFFM-q@gremlin>
References: <f887f7b3-b72c-99d2-8dbf-96cbd83774bf@inria.fr>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f887f7b3-b72c-99d2-8dbf-96cbd83774bf@inria.fr>
X-Rspamd-Queue-Id: 304E118000E
X-Rspam-User: 
X-Stat-Signature: 5n3htfpxhh7setw6fgrsz1d7jq1b1tma
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793617935-384988
X-HE-Meta: U2FsdGVkX19JB6WtAcYYWuv82nCTc73Vfs5iP+7TKXz+KrhrBSBKa07pPnslqKEbNcA+gg4tACbQ62diUq2xAnaaHbTOAkce0gyvf6eJjQzZptHIPbUwlMYRlw480Jc8ij8iuLL1kbamIwi/oBxjmAUkrixH+kZmLudhPgNj7TlwUZBH8dkJpZwfd6k4YOYgCv6hDA5qPlj5krPJTo03ngbuc8v7rgP140EMeB2vPCHf+sz+e2wATjxg0c4hWDxAo+CKaHeLMvTFthfBDVAEdpg4aPdUi2Zvg4iGSnqoI4sToDszRbeLtKbAfPyqtkKf/VvKR+B7/Spx8Byc4KhIwxZEPyzKLqPga6nrqLorp2VtaJlH/AlRurR5b/mV8579WsPpBFvy2cCDsiT83XyMO2GrT3JSHPXyr0nkfwCzslmiHZHJG1PFeM5j4DUCVws8f3zeFm43PJ+RYwR6ZdkQoTAxD2FYl6qzS+T/xL/uarpHA+60OT09/ek+OAaOYfWjOEtpmg0gxQpGSJpEGMMcm2vwI4rNcPvucFHuLnq9Ww8JJ/fMv3LVbSfXPvBkyWBJiCOmQ4bL1JiUi37igcrt5vIh+boGnwSagfaAcl0HILiLRVv9S/GFr74QpPH0HygT1IMs+NDAKMusU7JiJK5ytizIrVU4qx42ya3KZgiOKWMa/Z0st8DjBQJ+dhVDTGBrW6J12giVSmi/SqBQaU/te3E5XBrt4FITqLZZahtgSC6DYLJKQJUeOKEjwf88k5NST7n66RLQ2Uup3Twehk9oknoeEjK12kbiEGxYLLOK4UpgmfJaPtULutuyHRYxbbWvbAqXrcMfYBPUQKCshgS1QGVJP/nNlVhHTnmVond7boxMD7OaXViEVOuRE51C3BgaROoAY+87/Ic36NfgKOx37r4vUdBP7PJsUrAVJu88O68GZrB1kzFH+EHnzb1pB/biO62fNvOkaxZwT1mYZzt
 Vgj1pKbz
 jBneWPMmagkIvFy/0gzqdETBllvNgu3u7IPULuHhHUBrAOq4D4C+/g2xmlt+nq9bNkvwXltQ0m5g/TjELY6R+4idVF5t1zfYwhjLgADsqDd197XVU7iemQSQ68NVcQmY+e4HX0qiQbYXfIqDOvDyCz2/xXPg6qBOQPhh2PfG7yg57Eu8gmDa4sc5hEj0LWvSV7H30gam5H495dLil0EUStByRLpgpijKjOTekfUpGIzY+lsSGASt7FxUOotVLLDfzu2p10wIku3FZbNOF+7whLdTNyJwvmS8EIczIzy2HfoLLfJ5eqBWUAPwZOSDYoZ46tJIG0eYj+lXEmq0CQ7b/0ROHuQIdNajdCsJDn9U19lfoQd1YqJXu8fmAoUOI42HfDZoEj7CC4WrG1A8eHxTkWJSUOmg0ykSJpmrmzRuylsD88uBOXb74Dxmhgjco8GEpGdHYcnO4XovrHgZXsw51eWxoey8cLTgsCxw+L9FMWR2epl9JiQQvvPHJph5nmCt1dEOkBTE3o3VuV2CbAXFf94QGxrpbCobdBNMaefzX6cp1HvSP/LceigUNkkLWq/6QPtFntwBewKEOiPw1+WLLMyjs7315vhJ19Zs7wrJF7BAdf6h+1TTkQs5i3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+cc Alex

On Mon, Nov 02, 2026 at 12:54:31AM +0100, Julia Lawall wrote:
> just forwarding.  I don't know anything about this issue.
>
> julia

Thanks. This is unrelated to my change, looks like a cosmetic report that
predates it. Cc'd Alex, but not sure if any action is required.

Cheers, Lorenzo

>
> ---------- Forwarded message ----------
> Date: Mon, 02 Nov 2026 00:48:49 +0100
> From: kernel test robot <lkp@intel.com>
> To: oe-kbuild@lists.linux.dev
> Cc: lkp@intel.com, Julia Lawall <julia.lawall@inria.fr>
> Subject: drivers/hwtracing/stm/core.c:509:8-24: WARNING: stm_fops: .write() has
>     stream semantic; safe to change nonseekable_open -> stream_open.
>
> BCC: lkp@intel.com
> CC: oe-kbuild-all@lists.linux.dev
> CC: linux-kernel@vger.kernel.org
> TO: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linux Memory Management List <linux-mm@kvack.org>
> CC: Suren Baghdasaryan <surenb@google.com>
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> commit: b0085cb94d2477787f4197a3000e33aabf3d48fc stm: replace deprecated mmap hook with mmap_prepare
> date:   7 months ago
> :::::: branch date: 2 hours ago
> :::::: commit date: 7 months ago
> config: mips-randconfig-r2106-20261101 (https://download.01.org/0day-ci/archive/20261102/202611020009.xkUfJUpm-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8f6b51ca8bab1d49006ddaa042bc7e4e7306975d)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Fixes: b0085cb94d24 ("stm: replace deprecated mmap hook with mmap_prepare")
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Julia Lawall <julia.lawall@inria.fr>
> | Closes: https://lore.kernel.org/r/202611020009.xkUfJUpm-lkp@intel.com/
>
> cocci warnings: (new ones prefixed by >>)
> >> drivers/hwtracing/stm/core.c:509:8-24: WARNING: stm_fops: .write() has stream semantic; safe to change nonseekable_open -> stream_open.
>
> vim +509 drivers/hwtracing/stm/core.c
>
> c7fd62bc69d022 Alexander Shishkin 2018-10-05  484
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  485  static int stm_char_open(struct inode *inode, struct file *file)
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  486  {
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  487  	struct stm_file *stmf;
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  488  	struct device *dev;
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  489  	unsigned int major = imajor(inode);
> a0ebf519b8a266 Johan Hovold       2016-11-18  490  	int err = -ENOMEM;
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  491
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  492  	dev = class_find_device(&stm_class, NULL, &major, major_match);
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  493  	if (!dev)
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  494  		return -ENODEV;
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  495
> bf4afc53b77aea Linus Torvalds     2026-02-21  496  	stmf = kzalloc_obj(*stmf);
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  497  	if (!stmf)
> a0ebf519b8a266 Johan Hovold       2016-11-18  498  		goto err_put_device;
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  499
> a0ebf519b8a266 Johan Hovold       2016-11-18  500  	err = -ENODEV;
> cde4ad8368840e Alexander Shishkin 2016-02-15  501  	stm_output_init(&stmf->output);
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  502  	stmf->stm = to_stm_device(dev);
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  503
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  504  	if (!try_module_get(stmf->stm->owner))
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  505  		goto err_free;
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  506
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  507  	file->private_data = stmf;
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  508
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22 @509  	return nonseekable_open(inode, file);
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  510
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  511  err_free:
> a0ebf519b8a266 Johan Hovold       2016-11-18  512  	kfree(stmf);
> a0ebf519b8a266 Johan Hovold       2016-11-18  513  err_put_device:
> f7c81c7176c72c Alexander Shishkin 2016-02-15  514  	/* matches class_find_device() above */
> f7c81c7176c72c Alexander Shishkin 2016-02-15  515  	put_device(dev);
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  516
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  517  	return err;
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  518  }
> 7bd1d4093c2fa3 Alexander Shishkin 2015-09-22  519
>
> :::::: The code at line 509 was first introduced by commit
> :::::: 7bd1d4093c2fa37d1ecab05da3c9d48ea2af2264 stm class: Introduce an abstraction for System Trace Module devices
>
> :::::: TO: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> :::::: CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

--
Cheers, Lorenzo

