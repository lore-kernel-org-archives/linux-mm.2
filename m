Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E118C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC616B008A; Wed, 22 Jul 2026 05:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A44E6B008C; Wed, 22 Jul 2026 05:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E03C6B0092; Wed, 22 Jul 2026 05:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8E996B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:56:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27F731203F1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:56:42 +0000 (UTC)
X-FDA: 85015958244.26.D618984
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B2BE100002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:56:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iTTuEnUK;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784714200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UKinxtwpUhNzmCHSNfCxB0o/RysIEhOfeODCNlOPoo=;
	b=6sTbtch4C0imD/8FsgxXfPrS8AhPjPQDAc6B/nbcmcdptyx9AdDYVz5yE2cmiTbkAw1VDA
	Wx+x5l2YHv98EfyQodeY7dZT+BMYYlJNrpask/T45Hu/qXnBkJhMKSUMFZHFpcZR0iTw0c
	uEvFOV4YypRYSKIjWzsZieTRsM3a9Uk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784714200;
	b=wJXwNmw5eBU5+rmQFbUMEVjq8uU7qZmuWUYC7ILSHt62WGpVW0snyGaC+ek3ShoTyaznVe
	hrv7KFP3fAqo+w5/plWE9MsDtTTK4KiHj6ZaDtPn6C01fmcz2j0bmMVVdnKWsATOc+Mi0p
	JcAw23c2IspJjVd3M2KSL5w/LcZdbqs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iTTuEnUK;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDFE060A78;
	Wed, 22 Jul 2026 09:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842D71F00A3D;
	Wed, 22 Jul 2026 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784714199;
	bh=2UKinxtwpUhNzmCHSNfCxB0o/RysIEhOfeODCNlOPoo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=iTTuEnUKQW7C4i55BdkYOSG2Awg+qdtvweW4/rglmXgra31Eu+PM6mPv/cht4UWFk
	 fLrjFvUrnn1wqgTk6wnnrN93sXSi3+UffEfcG3KILa8CLmML82j0oCAM/KHWuDt1bl
	 sYpXlT+DrNmidRHMyJDMpwaFQyr+DkigbsumgMPOAv+WQ26Fqe5qBmPMtzV7ihzoIJ
	 uXznuCuGQxaKAbAmgZFgLhYEUIMK3a7sMSzPALT0Sm74HXS0RvxY6QmJ92ju59MN17
	 unSXjen5rxZCe+xajZDk4GmGgueRR1Js5Wcer9bDa0Fl1luJCxMNLfTAa0O/2+yako
	 LSAUkAc4Vlg6w==
Content-Type: multipart/mixed; boundary="===============2757309040262801300=="
MIME-Version: 1.0
Message-Id: <1358b841fb4669aa04fcb84247b91c74dfc8f4749f665f5c2a058d6c2bb17640@mail.kernel.org>
In-Reply-To: <20260721174833.1232771-2-ziyang.meme@gmail.com>
References: <20260721174833.1232771-2-ziyang.meme@gmail.com>
Subject: Re: [PATCH v2 1/4] selftests: add shared lib.bpf.mk to build BPF progs and skeletons
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,kernel-team@meta.com,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ziyang.meme@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 22 Jul 2026 09:56:37 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9B2BE100002
X-Stat-Signature: ka6n9orh3sw449kdnbx4jmwfc6aahi6g
X-HE-Tag: 1784714200-155461
X-HE-Meta: U2FsdGVkX1/EeVOeOyY6koGvs8LPKyp3cf8Eo/2ubK5RQDIEZplmM3uB3qLp/5KLPlZd4loEVw4VHKyPnOQZT811CHAoZ+MuRWbLRgknJ3GE8T7tkMnMIylhUX/MFCfs7ITbmIoB1LlKr4Pc0vQgnrZTl9N933MzS02nTdPqQE0sJxgsaWYpaB9J3XcShpIFuUiyOHxeduaW7w3asdb5WigKbKWFxOsoUdq1SUTHg+6y8s4cGeWaDm1jYWawt5RFpzam+HbAItELzcBO4MG2tKrtEKSvMLowxg0CuA9881kx3fQv8O1XV7U2V+R7FF8fV/AYgNwRhzeLP1OzdoILa8JvBGe4OgXe91YgvQcO/APdP3hTUNhOtRvXsPs88uv8ti9yLeBu1mXgp1ko5LMzhlK8uXAcAUN4PR62aK6j9zoyaAESrp19rzzIJKNetxLv/kK/eAbP0KJmPKLH+sjLksY1AC8rKMU8BtTFaXq0A383MUXn0IpOzFY59r5quSX4EnJBtVuu+IZ+mxEUbpBRdVmR+xOqbDHTH8wzqJ2uIrf4ydAtYbTE3PLLWqMNu3iQD6blfOZcdRlKOgNq6N78UbQw/uQY+Fg+sgxtYZSvg+oqHwHhFIeScOTsff4evE+BchPTV9ClKkIuvCUR7CwncyRdGdK1evDRXnWKZrJwvT82Fvv2VCli00jpi7+DGcktdds+dfdzfAXweQ1VY/VGSKrraz3yg1O0XW22y1Thh/qzC2YzZUnyZufptqBsv5OiCwTZ/5AFDTGf3sPxYaskrwSQ8ny5KAgWBJMMBwnQA0ExHk0vkARxH+DjhfgH4Qjzf7C7YtCEBvaRDOST41EvJnIHpi5+luCR/pp0eAA4+SqboyM5QNSZ2q52W++ZwCh4jEiGl8a2t4EUHpFbcUX5aH6PYjuORnWewircv7EhhmrhtF/gihwsMWRpFDdrmJ0d9snMufUf+NTbODr6bHV
 VdarSK8P
 r8NgDC2AC8012EifDDAow8FeISMqCVAcDwF+gjvnW9EL9JmC/FKDpQQbvuNG6xEzP/teRVUQfcg2vBMPED5h76A44PS8ZBwtbn4oy2KkTdmN9BLjsteREjB/Jrwh6lwYPM2wp9yaT5vu8cXGCIbl1klSe44MZm+x4xqXNRAB4RhCiKGN54cCm+CvR+GFfOhFJJE7hiR7AGF/RPSYPAwDhFnXGWRbrgSce3bmrnXKM8kpCAjSrHyg6iSnW5hkNHH8g3yjbXNLNMWkj5GxjDaTxACEFqmiKxlSwiaNrnGSrsq0mZTBjVIXs3elBsYkLaL9W0ajTeF3FdVMjw4IqVaHQi4PLs6o8iXA+VMZcoVH2GDAohCeziHInFrH3SG5mbYCPbuOaLhyPT6IPgaSiU6vUYuga5AzQyKUMo3Swx50uH89FmgF6JBDDXqa9mJWisyvOl9X/p5DzIMJPwM9aKF9XbXlBkTWhoMrL+PQFfqw+ANwUQEO25Up+xD7rtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2757309040262801300==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/lib.bpf.mk b/tools/testing/selftests/lib.bpf.mk
> new file mode 100644
> index 000000000000..6f175c6568e9
> --- /dev/null
> +++ b/tools/testing/selftests/lib.bpf.mk

[ ... ]

> +# ---- libbpf (target) ------------------------------------------------------
> +# Pass ARCH/CROSS_COMPILE/CC through: lib.mk's CC is file-origin and is not
> +# exported, so without this the libbpf sub-make would rebuild for the host under
> +# a pure-LLVM cross build (make LLVM=1 ARCH=<arch>).  -fPIC keeps the static
> +# libbpf linkable into position-independent (PIE) test binaries.
> +$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
> +	   $(APIDIR)/linux/bpf.h | $(BUILD_DIR)/libbpf
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
> +		    ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CC="$(CC)"     \
> +		    EXTRA_CFLAGS='-g -O0 -fPIC'				      \
> +		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers

This rule hardcodes EXTRA_CFLAGS='-g -O0 -fPIC' for the libbpf sub-make.
tools/testing/selftests/bpf/Makefile instead passes
EXTRA_CFLAGS='-g $(OPT_FLAGS) $(SAN_CFLAGS) $(EXTRA_CFLAGS)'.

With -O0 pinned here, is there a way for someone to build the selftests
(including libbpf) with -O2, or with sanitizer flags?  Could this at least
honor the EXTRA_CFLAGS or USERCFLAGS that lib.mk already defines?

The same hardcoding shows up in the host libbpf and host bpftool rules
below, so the same question applies to them:

> +# ---- libbpf (host) -- a distinct rule only when cross-compiling -----------
> +ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
> +$(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
> +		| $(HOST_BUILD_DIR)/libbpf
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) ARCH= CROSS_COMPILE=	      \
> +		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
> +		    EXTRA_CFLAGS='-g -O0'				      \
> +		    DESTDIR=$(HOST_SCRATCH_DIR) prefix= all install_headers
> +endif
> +
> +# ---- bpftool (host) -------------------------------------------------------
> +$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) \
> +		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOLDIR)		  \
> +		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
> +		    EXTRA_CFLAGS='-g -O0'			  \
> +		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/		  \
> +		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/	  \
> +		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/		  \
> +		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin

[ ... ]

On the commit message:

>     This saves much work for configuring selftests in other folder, such the cgroup.

This isn't a bug, but could this sentence be tightened?  "in other
folder" and "such the cgroup" read a little awkwardly, and the preceding
text already explains the deduplication rationale.  Perhaps something like
"This eases adding BPF-based selftests in other directories, such as
cgroup."


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/29908293077
--===============2757309040262801300==--

