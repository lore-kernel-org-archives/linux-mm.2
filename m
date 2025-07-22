Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A800C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 10:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F8A8E0002; Tue, 22 Jul 2025 06:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F73B8E0001; Tue, 22 Jul 2025 06:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5988E0002; Tue, 22 Jul 2025 06:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B74D8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:52:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4238130575
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:52:07 +0000 (UTC)
X-FDA: 83691585894.04.C89B542
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id BA763180007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:52:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dNymhzp6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XeIuY95A;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=O6TVGhcx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wz3Y3KRF;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753181526; a=rsa-sha256;
	cv=none;
	b=jzpg5LNsLU8T8jDBmrwJBFSfMP92s1kKXMsd4xgMge9l1ezAeKrt3iSuQFi7PqdHfokrAX
	7QLPG7dwLVqq/bKHLea7K3SepHxnv0sKMZ5syH7zxjRVVXieq7EqhkTfm2lfxV0KE80fFW
	9InOwW094ZuAQuznJwYG93iq4hK+fZM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dNymhzp6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XeIuY95A;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=O6TVGhcx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wz3Y3KRF;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753181526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e62XESYifqL2is1sUYq5Um0kogZdD8p/qNEjpnfEW/A=;
	b=6O+XmAEkTK0AtyVN73571jU0opnXNzycEwjNNw8ZoRtAJf1fjxGfyCurmr68mY0o46S4Xi
	6ldNnIne2TzkEt0sewzmBDVEXnVb2FmbMcQp8MR9FNOo4jQtGmVSUFufEcyrB2YZ2b8K7N
	cEYd401w0kcXCWxQZMFohspEic8dY9k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CD8F621AB2;
	Tue, 22 Jul 2025 10:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753181524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e62XESYifqL2is1sUYq5Um0kogZdD8p/qNEjpnfEW/A=;
	b=dNymhzp6vxPQFlnYvEr13rcdtwXOXArPXd31JmRXzNjEJH7ODtp2Iz2Qj1WmyDs821jnzF
	Hqht8N4RqycBeC7rdwpmZuQ76SDO2y/4EC24CbSIL6lrAgP/btR7I9H2FU6xpAvRWJ0gVb
	qjKBkMrKte1WUS5G3zHValyMB+a0Exs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753181524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e62XESYifqL2is1sUYq5Um0kogZdD8p/qNEjpnfEW/A=;
	b=XeIuY95AUWjEHTnfiXFAklBsPowvzKh3LP+qW78SNa4BdQXxl/FzSTO2itNzxpfA/y5WFv
	f7kD5kvHMlR9RQCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753181523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e62XESYifqL2is1sUYq5Um0kogZdD8p/qNEjpnfEW/A=;
	b=O6TVGhcxC3C79i/66PeRXnV31RS3ft2Xi0kVb7UEOsUsXUYFjii4kMp4YaLNMs99bRu7co
	q2KWOlRc2AoALtFV8NKIgXpn8e2I25YItR9L9e17Q2FcKfYO0BVOGKix3mS4TOJ/HJx7op
	WYyIX1Q5wfwAXvPZKQBC1UPBR70q59U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753181523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e62XESYifqL2is1sUYq5Um0kogZdD8p/qNEjpnfEW/A=;
	b=wz3Y3KRFYkZ58dM80VQ8LP3H967n+pFJP3pjtxf583reZ0WbHHJVvdrEWNSSbc7KecCCww
	oJPYyrJjSNST1lAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 408DA132EA;
	Tue, 22 Jul 2025 10:52:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IYSPDFNtf2ieOgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 22 Jul 2025 10:52:03 +0000
Date: Tue, 22 Jul 2025 11:52:01 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: kernel test robot <oliver.sang@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, David Howells <dhowells@redhat.com>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm, slab]  5660ee54e7:
 BUG:KASAN:stack-out-of-bounds_in_copy_from_iter
Message-ID: <jehx7y7mwer77d2rrx323qixc456ffod3qrcssemkebjotstbh@fpklsa72lzky>
References: <202507220801.50a7210-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202507220801.50a7210-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA763180007
X-Stat-Signature: whgofn5hagni4883zzreozc5pujgfij3
X-HE-Tag: 1753181525-855591
X-HE-Meta: U2FsdGVkX19f2VxzyJN8hTIKnoYO9vGPAxxec/Ox9eBiSDzimG8pf2QIFSoU82XfRY0pYyykRwBn30R+Ci9EAg8ruxbad7sauexOaeMcLwiPDa2wscCzWhGOqAvnUWebM8IlYfjnWfnao88T8ywwQ1gFgWXjVv2WgyYYBknCEifa00kRWFxro16B3hbjIA6/yOmoxVl1mpqGpHgajA/bh4Dmd/umAnwQIBsI8PRzeEDmb+RDRWVFNUaHE1JR5pS2iHFw8/dQfy5GAJt8gY/Y4Uy1zXp0FKa7a0rhTFWqOVTG1tiaaLjrWYogNat20+7AjvTiEHi8symd3dVvKk81GyGYe893wwkqSdYtpgzMpaJ15D2XhCrIGXm0pADaN+DiulRU8mcPWFrDe8SqjT6ZcD8joduNDi/Vkq1jiPkvDvvtAANtQNUH96MQJjafx4WvEvOcIHmdNpaEy0HR06QGb/hcP0I7J+W6O9dyNe2mTe8x2Ibts3/4oIsk8mc26nJSNh2y9S1j5xlFnB3P3WtSkNU3KTBfcUZaTgXmU2Ap0YyzKF2TFXydIoqhnk2BM0KKy42mJ1jDIly0MkOkgRaJm719qmpZSMzF/IyzORSDnwl0tW6D88w/mbNHInG21nlqxGLFFIuQ2RDmlI3s1CQSmV7B58/SIfhHB3w0iMA8b7bK42I6kgItHVnvzUYFlO0n5SKaTG/yJMn40pao4wx+DQBo9ttFmelf6m8vKX3nU2408r5spveVhVeBuy6kxT0r2qJAK5IHg6fBONN0mEX2I6G6qma5DxrJjmMHexXVLNEAw/bk655+YIXze0yITxiZOMe0pEXB99k0y9drPl7Hu90Dn/JszijqtSPolmjzyCTjl1yaHE/wIleYJ05EzLLWzUiYWEZWyzHSUPr70svsyUQu7+WrTvGXHz1PVDv0uSJmjpuXHhgq6RXsLrnP2FVLO1GHJgVQIRFcfqvsuu5
 EJ5pEr4M
 ZRiq7r24BBPZdrzG4VAZcFcBfw9+X1PGIhsXUWYZHIX91XglYFTMBzQD4Rr+nVjwXAODg6RlAbHmZdVmGsGvOiC5nObr9jnmjytP0xr1jg34AOxShUr0AQ1uNn+dcz2UIVEUBM6ZozuhaodbpBctuqSYB//BBkyv+A0pRQTTUabQbP/+/z8b+uYc3c/bPoLuvMgQxNOttvEXqEmx3H0+aznfbK/K8YlwmlXqZPrNT1sYLS2837/a/QH4rzPp9p01sOzuOjVZhcz9mFUbIzXcLGdpPQuRHNJYIn+yEZSjRPlmeYXrZ353zs5k0NRVOfVtPNnPKVRfaskMlJmcCScdXKbwXxwTGxDwWepZX65dhjL9jwPwg96v0LV9c1YoVYj3uR621e1qWMDY3Oox4SJDuqViE0fcUXOJB6oIVe8QRdNpZpQMr6Nf8oLP068o0E0HpHOnFUzwHAJfotWM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc dhowells

On Tue, Jul 22, 2025 at 03:07:44PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG:KASAN:stack-out-of-bounds_in_copy_from_iter" on:
> 
> commit: 5660ee54e7982f9097ddc684e90f15bdcc7fef4b ("mm, slab: use frozen pages for large kmalloc")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master d086c886ceb9f59dea6c3a9dae7eb89e780a20c9]
> 
> in testcase: blktests
> version: blktests-x86_64-5d9ef47-1_20250709
> with following parameters:
> 
> 	disk: 1SSD
> 	test: nvme-group-00
> 	nvme_trtype: rdma
> 	use_siw: true
> 
> 
> 
> config: x86_64-rhel-9.4-func
> compiler: gcc-12
> test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 28G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202507220801.50a7210-lkp@intel.com
> 
> 
> [ 232.729908][ T3003] BUG: KASAN: stack-out-of-bounds in _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
> [  232.737608][ T3003] Read of size 4 at addr ffffc90002527694 by task siw_tx/2/3003
> [  232.745045][ T3003]
> [  232.747222][ T3003] CPU: 2 UID: 0 PID: 3003 Comm: siw_tx/2 Not tainted 6.16.0-rc2-00002-g5660ee54e798 #1 PREEMPT(voluntary)
> [  232.747226][ T3003] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.2.8 01/26/2016
> [  232.747228][ T3003] Call Trace:
> [  232.747230][ T3003]  <TASK>
> [ 232.747231][ T3003] dump_stack_lvl (lib/dump_stack.c:123 (discriminator 1)) 
> [ 232.747236][ T3003] print_address_description+0x2c/0x3b0 
> [ 232.747241][ T3003] ? _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
> [ 232.747244][ T3003] print_report (mm/kasan/report.c:522) 
> [ 232.747247][ T3003] ? kasan_addr_to_slab (mm/kasan/common.c:37) 
> [ 232.747250][ T3003] ? _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
> [ 232.747252][ T3003] kasan_report (mm/kasan/report.c:636) 
> [ 232.747255][ T3003] ? _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
> [ 232.747259][ T3003] _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
> [ 232.747263][ T3003] ? __pfx__copy_from_iter (lib/iov_iter.c:254) 
> [ 232.747266][ T3003] ? __pfx_tcp_current_mss (net/ipv4/tcp_output.c:1873) 
> [ 232.747270][ T3003] ? check_heap_object (arch/x86/include/asm/bitops.h:206 arch/x86/include/asm/bitops.h:238 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/page-flags.h:867 include/linux/page-flags.h:888 include/linux/mm.h:992 include/linux/mm.h:2050 mm/usercopy.c:199) 
> [  232.747274][ T3003]  ? 0xffffffff81000000
> [ 232.747276][ T3003] ? __check_object_size (mm/memremap.c:421) 
> [ 232.747280][ T3003] skb_do_copy_data_nocache (include/linux/uio.h:228 include/linux/uio.h:245 include/net/sock.h:2243) 
> [ 232.747284][ T3003] ? __pfx_skb_do_copy_data_nocache (include/net/sock.h:2234) 
> [ 232.747286][ T3003] ? __sk_mem_schedule (net/core/sock.c:3403) 
> [ 232.747291][ T3003] tcp_sendmsg_locked (include/net/sock.h:2271 net/ipv4/tcp.c:1254) 
> [ 232.747297][ T3003] ? sock_sendmsg (net/socket.c:712 net/socket.c:727 net/socket.c:750) 
> [ 232.747300][ T3003] ? __pfx_tcp_sendmsg_locked (net/ipv4/tcp.c:1061) 
> [ 232.747303][ T3003] ? __pfx_sock_sendmsg (net/socket.c:739) 
> [ 232.747306][ T3003] ? _raw_spin_lock_bh (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:127 kernel/locking/spinlock.c:178) 
> [ 232.747312][ T3003] siw_tcp_sendpages+0x1f1/0x4f0 siw 

It seems to me that the change introduced back in 6.4 by David was silently
borked (credit to Vlastimil for initially pointing it out to me). Namely:

https://lore.kernel.org/all/20230331160914.1608208-1-dhowells@redhat.com/
introduced three changes, where we're inlining tcp_sendpages:

c2ff29e99a76 ("siw: Inline do_tcp_sendpages()")
e117dcfd646e ("tls: Inline do_tcp_sendpages()")
7f8816ab4bae ("espintcp: Inline do_tcp_sendpages()")

(there's a separate ebf2e8860eea, but it looks okay)

Taking a closer look into siw (my comments):

static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
			     size_t size)
[...]
	/* Calculate the number of bytes we need to push, for this page
	 * specifically */
	size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
	/* If we can't splice it, then copy it in, as normal */
	if (!sendpage_ok(page[i]))
		msg.msg_flags &= ~MSG_SPLICE_PAGES;
	/* Set the bvec pointing to the page, with len $bytes */
	bvec_set_page(&bvec, page[i], bytes, offset);
	/* Set the iter to $size, aka the size of the whole sendpages (!!!) */
	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
try_page_again:
	lock_sock(sk);
	/* Sendmsg with $size size (!!!) */
	rv = tcp_sendmsg_locked(sk, &msg, size);


Now, (probably) why we didn't see this before: ever since Vlastimil introduced
5660ee54e798("mm, slab: use frozen pages for large kmalloc") into -next, sendpage_ok
fails for large kmalloc pages. This makes it so we don't take the MSG_SPLICE_PAGES paths,
which have a subtle difference deep into iov_iter paths:

(MSG_SPLICE_PAGES)
skb_splice_from_iter
  iov_iter_extract_pages
    iov_iter_extract_bvec_pages
      uses i->nr_segs to correctly stop in its tracks before OoB'ing everywhere
  skb_splice_from_iter gets a "short" read

(!MSG_SPLICE_PAGES)
skb_copy_to_page_nocache copy=iov_iter_count
 [...]
   copy_from_iter
   	/* this doesn't help */
     	if (unlikely(iter->count < len))
		len = iter->count;
	  iterate_bvec
	    ... and we run off the bvecs

Anyway, long-winded analysis just to say:

--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -332,11 +332,11 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
                if (!sendpage_ok(page[i]))
                        msg.msg_flags &= ~MSG_SPLICE_PAGES;
                bvec_set_page(&bvec, page[i], bytes, offset);
-               iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+               iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);

 try_page_again:
                lock_sock(sk);
-               rv = tcp_sendmsg_locked(sk, &msg, size);
+               rv = tcp_sendmsg_locked(sk, &msg, bytes);
                release_sock(sk);

                if (rv > 0) {

(I had a closer look at the tls, espintcp changes, and they seem correct)

-- 
Pedro

