Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CAA0CD98CE
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 02:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98B76B0005; Fri, 12 Jun 2026 22:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48E36B008A; Fri, 12 Jun 2026 22:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5EC86B008C; Fri, 12 Jun 2026 22:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95D706B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 22:11:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2355EC165A
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 02:11:12 +0000 (UTC)
X-FDA: 84873261984.20.455F94C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CE230C0003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 02:11:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rfX6vrHz;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781316670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/9t8fsXFPOklpJdOhD/xZDi2Gw/WymQ3bhv4WPhUKs=;
	b=N+3s4dFlzDl/TjNjqAgUDLiyuSCiE5RD64arBKaa2kFNgoQkxDJJv23M7FAMbs+0sTWIRL
	yIKrGMAe791MQH2XbeIYbkvCkeyJXfjGSc6KBF+YmXTdzTnSSqNFw3jTYCUZ2M95WC711R
	5+XlGDMBJDX5XJ6acV8Vlr4NynDGrTU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rfX6vrHz;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781316670;
	b=qg/iIEZcOQUbiKKqh+GToHg7yWuu3/LtSi9uYiL44f+RIUqwKoF/IBtl1IQqEeTq1rZwFj
	wYtaVa/Iq/heT9o60sEHMfUfTeNF0BcvA12j3k56uY+NQYEPReDpXOodoUzZJ5WpSPmc45
	g1LI7F+5UjFBLFgpkpcbKZmwcsotfiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A96D44326C;
	Sat, 13 Jun 2026 02:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D301F000E9;
	Sat, 13 Jun 2026 02:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781316668;
	bh=s/9t8fsXFPOklpJdOhD/xZDi2Gw/WymQ3bhv4WPhUKs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rfX6vrHzTv+YsNe1AIALPyBHd5pPdk8v0fyy27KjifVpM5sefNdRQQXk6f+Yya8B6
	 ytZ4RjGQgzbnxobh4J2/wpb2tO6CzeDbBPNUd338/izDwKzpVE3vPOQTI7AgVAwWb/
	 I0ArYHzZdO/m8dfYqP2XtVTSzs6I8I39OD6CoSfg=
Date: Fri, 12 Jun 2026 19:11:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
 <oe-kbuild-all@lists.linux.dev>, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [linux-next:master 12966/13336]
 ../../../lib/interval_tree_test.c:315:17: error: implicit declaration of
 function 'pr_warn'
Message-Id: <20260612191107.c6cecc7003eece597f66a1b3@linux-foundation.org>
In-Reply-To: <aiyvdAugnSzVlm+6@rli9-mobl>
References: <aiyvdAugnSzVlm+6@rli9-mobl>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE230C0003
X-Stat-Signature: u87htrsmqf5jjdcj88zn6aoajib637t7
X-HE-Tag: 1781316669-661607
X-HE-Meta: U2FsdGVkX18SeDc0AEYLY7mf6FGLsenl3TNsA2hlkNt368JHSEgtlFCwqbRwH5sLBoUKjREUgJLJsldlT0tSEpQ/Hf60nL0csJwQ2h/HPC1HVIP3YhiNCju3c3Av9kvj7YI5dBhfwf6hWAdlsqWiYqOA9B5I9ERlcooGfwIhbTztopTtcou9ItUsN3Bcp0lqiM2HKUyGvYF9QVGhpsewDVnePcBDJa6Bsmb4iq2bh/nRZbFnMNDpq9D98Lz3Q0rFl+d5iTIvuOQsr/bdvbPfkXQpYMq0pi7KEyGx/JTo1MTKIkchMq1dTgH2NfxkbDjHV5hLIA3G0aVc2ncq6oWnoIsi0np3spBS2+1mRe56oX8n6IiqQlXhEDYvbwzyo7K2jrY76H7YebkaRi9e4Uoj835r6QXLPLJ5xso8xY/E/qW28HC94OzwNbuzS/MW2lq2/phz1ohwMPOkqocGJ4rkPZ5I0CWTMQzekyG1/yGB0wWJWgX6AmHpsgPF9V03ZCQN9TeOHkYebNbrEUdfkWBjMNb6Jts5ClXUa9DNVu7VZEf+PgP7RohYxZTU9MAuhzmmer4baBxS6pPUWTtH/H2U2t+itZ4jiItquAN7Tr0olIrEdRkWQRl0b0zEO2d0MYk+9ohjQ3H5SNae4OB2k402PqEX8fJ72bqdpI6g12dnO0/d+uofG6+movZApUnoO6H+qvn/YAeHkRA6XZtqszhQ3dG6dF7wTxPHTHu5Iopo03663Yiaxdt0zbkAsKUPLrBmU4UK5umMPe5aVVlkVPpYUFJsmBJNMVR3NFsA+y1X+PufP3OtMgt/qFqe2UwDUpmQkJv9KC0ikXzKJaagvpM93wP7B5ePK9EDO/2Qc4HUWsHLU26JqRy7fau9FKfHCtRK7P2fT4CER02nVFnXTsShl44WJ/yiVL0Mkb5ujBFWSzxGVSusXn5UiWu/QPGfhb2LbnrtJIFRAy0uifd8x9q
 AHpmUqXT
 rj/kqJMZYtJssKAmaJEl5cxV6lXZTmE/0CMbzknKn2BeIpBsjOjdoNz9ATCL3j7ZxvsncJm+qNbONTT2lYZVkV1EpCGrDjlkdVX9g8/bD1+hSIwidQGfNmfRoeMGsuEucVwS537/K+D2X/HlZJJIelLlYaUgfgFdB2Ixqtq+Zq6NJcj7OE0B4J1FBwYtv3U6quHlokvpBJCKb41BQ2h6yz+4kBdPLWOLzvcRTPpJaKLbopqurmMO2h6d6qjhKfj73cyhwnqNATpCihkB5A3PbgI8KPsM71JWAP4t+CCU0dsBrq2e47G2Vb+2yqj9I0H1CNCTOVekg8hz6Df6fqVtOHmWmFe3bYE8Xuc7HhX/ehE5qTKsPjPOJ+rME0xprI5GHRaxQI3tc0JhmJaYB9kuI8f/N6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Jun 2026 09:16:36 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   c425609d6ac4012c8bbf01ec2e10e801b1923a7b
> commit: da58d4edb02fe347b676a3be230fd16da68c4fc8 [12966/13336] lib: interval_tree_test: validate benchmark parameters
> :::::: branch date: 2 hours ago
> :::::: commit date: 2 days ago
> config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260612/202606122249.neYsYssG-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260612/202606122249.neYsYssG-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/r/202606122249.neYsYssG-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from interval_tree_test.c:11:
>    ../../../lib/interval_tree_test.c: In function 'interval_tree_test_init':
> >> ../../../lib/interval_tree_test.c:315:17: error: implicit declaration of function 'pr_warn' [-Wimplicit-function-declaration]
>      315 |                 pr_warn("nnodes must be positive\n");
>          |                 ^~~~~~~
>    ../../../lib/interval_tree_test.c:335:17: error: implicit declaration of function 'kmalloc_objs'; did you mean 'kzalloc_obj'? [-Wimplicit-function-declaration]
>      335 |         nodes = kmalloc_objs(struct interval_tree_node, nnodes);
>          |                 ^~~~~~~~~~~~
>          |                 kzalloc_obj
>    ../../../lib/interval_tree_test.c:335:30: error: expected expression before 'struct'
>      335 |         nodes = kmalloc_objs(struct interval_tree_node, nnodes);
>          |                              ^~~~~~

Thanks.  I can't reproduce this.

lib/interval_tree_test.c already includes slab.h.  I'll add a fix to
include printk.h.

