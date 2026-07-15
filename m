Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01604C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3AA6B00A1; Wed, 15 Jul 2026 09:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301866B00AC; Wed, 15 Jul 2026 09:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E7B6B00AD; Wed, 15 Jul 2026 09:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB5116B00A1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:27:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E5D51C002A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:02:24 +0000 (UTC)
X-FDA: 84990722208.18.456F931
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id E4CA11C0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:02:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LOZE2WkQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=k5q9WukS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YmFcTJzn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WeE0jk4o;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784113342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awWRLmdYvk3T0kyC5GXSDxyc9sU+56IS2/k4lm4UTqU=;
	b=yL0J9VZvY+pyHn4oPWuLz9u/I+amqzHrSu5qmeHgWNcg7fWxEJyrY8OotLOrn9wtcot9GO
	WrOPBrYwaCwFWPeswn9wDxP8tUs9A5otvpx+q1QqNG8JrPcvoTMqYhsfXe70q2R/ZeHJaz
	apRv3Xoc7O0GBJYO+rKIs+fuzgigJa4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LOZE2WkQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=k5q9WukS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YmFcTJzn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WeE0jk4o;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784113342;
	b=24f+KU+vDpGyuCUQc4QziBq8Q0urYJDOTxUhqSzQ96lhMGP9RRxCO55Ig8EUdqSuEC4P1E
	XK+HQ7uVUsi5t9QiJYy9EeddswwPqa0c2PSb6M6vk6PKA9tgVnay+ibLsRLCwwwVZl+rDT
	Tr/PwLGq6R4NRiFCdurmXIkHKtZBOfg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A58157836D;
	Wed, 15 Jul 2026 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awWRLmdYvk3T0kyC5GXSDxyc9sU+56IS2/k4lm4UTqU=;
	b=LOZE2WkQU8SqoT0Od6xtHGztXuLBTKeq0vwL2KC7tW/V8sN3dCsWU3CXgg1DHTwQO20lvP
	FaLL2sIIs9T9O/qtX2psKMPydmD59VbJNDZZBf5C8sVr6YH3P7USJSUWIFWOSOvPsmWL18
	RzM7BjBNYriIfaKB6d5WmuGAVDDPxHw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113336;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awWRLmdYvk3T0kyC5GXSDxyc9sU+56IS2/k4lm4UTqU=;
	b=k5q9WukS1rf+5uOqq7/uYAiIKCXIwczoydsPteGRpPPTBPq7OcFdth7xShqKi3Askoczon
	ftTpRD3BH8gR50Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awWRLmdYvk3T0kyC5GXSDxyc9sU+56IS2/k4lm4UTqU=;
	b=YmFcTJzn17KM6igiXi4SvOZ0A1DFg9t3GkYeYdvFELLE2wykcF3U2OhsS9G70qz9qbK7fF
	JQOemyqZyRZ7Z+5GuEYT575tpimBb6iySrn8TiXtF8/Rvf7GhO0BhvdKB0hrIDUs7akI5y
	aiKy9Pkh9Yt2lWOPDDK6tZ1Uk3PZGaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113331;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awWRLmdYvk3T0kyC5GXSDxyc9sU+56IS2/k4lm4UTqU=;
	b=WeE0jk4oqGf9L8A9LdtqB80/xlVuHiS+eAKy/fVum4WmeIOdBENw0Y8Gr7zGRetjvFN9M5
	X5wuhno4DiExQoCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0925A779AD;
	Wed, 15 Jul 2026 11:02:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O9RQOq1oV2oufAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 15 Jul 2026 11:02:05 +0000
Date: Wed, 15 Jul 2026 12:02:04 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Aaron Rainbolt <arraybolt3@gmail.com>
Cc: xen-devel@lists.xenproject.org, jgross@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, marmarek@invisiblethingslab.com, 
	adrelanos@whonix.org, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: Intermittent kernel WARN in mm.h get_page() when forcefully
 removing a xen_netfront interface from xenstore
Message-ID: <aldj4Jwd5T9q1-sK@pedro-suse.lan>
References: <20260714234912.7a75536b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714234912.7a75536b@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E4CA11C0005
X-Stat-Signature: uyjeiykssu3hsdzgajy7buqs8q4nab1h
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784113341-776704
X-HE-Meta: U2FsdGVkX1/yvutepZsCpspPqMg9eiarv/3yGd81BOObZ2cYIGWMYTt4UaPyLh7X55Md0esGA/uCTMzL8wV3mNAreihVq214VsSGWiVaBAZnoK+kp74iRCiFprmkcSADYtbmmldn/ASq2Qhqsk1/jPdp84frgdPYEaGIjkDUJsW2zH5gVNdw2gl4FbAyId5Iz7YUkXkPSjY3blKL6m8PFC+/2DrlTW3e5KNFhyG8mBzds1/zoar8VfHPKrGx7I1fcTQI3DorRT+x6xK53hMO3qyLHavbayaTunRSIrEbUSzE5iHBhsLgEytNsaAenTKJZRPZpkuzUj9GU5t6eav68uNL1JmdWjj6NoXhKxav44Em8KqUTSO174ln2v2C5QFG0wupw/3syi+dSyL0cCqIKJzN6RSIF7d5Md8yQaxiuJoMPTBcenBuPsr3tuFczMKQd2HHHdUQFaZFrsukOvpxESSAp9+WP/LFc/wSVawFw1adf64IBX2YQb01Q6LpO86ura48kEQQgBenFJwupkUxFcw8/7DNsk3/VmVh7RW3Cs9nDAdUm+7nakztjeAJtgI/hvUpAez1CHGjMWOQHufCORIlusX1j/xVMrQHiR88sKl1wFdgxvCEllFTiVxVH0utyqqbnKbhGZM9g9ONUaWreZNJbfz4M1/rWZ6KctoSszRz9oL89Y57il+aS1Svcg403WtwDAV7BrcIpuoMUMATnqyOnoELlMOcrBErV/EtfzvMtopoBk61+7Zl2tmcQ/1Dv39A8dnj56L4WhakVRbZ3uRqK14Lk3t00i8WYwrpMkqW+i9av48cLwIunKb8/EtFCMlhPNVUo+uj12Y7E2dQ6Z956R+4xDA3jLCY/mcN0mXyLPeW/iotf3N8Jqe3SLjSOEjzvUtpzF+lqDSRFPMQaK4ISv3ByOtDk/hGMX0FbnrPm/fFOByXyPnhyRFQZdFJwMQHIhhQTDEyFrL8piG
 dtyJp5R6
 DGKk832ubP24hxe5KQvhDRlX7iE7yGxeZPc9oGqS+tkIW6n90JMTrXwqtke9R5fmXtBwNbF9utvQogImdGqbr3hOG4giFWl+clXiyzo08BpL/HkmEAIVi2PoUz8i9wNJWUQ1/EPQEffLeX+tLHt/J+cjK5FNIqcad+IhsS+8VwQI0N33FbSuTycOcVQV1GmAL2khGBpPA9FvWwjRRaNxYUyw2rW/yxhkRq3kNo3+sS4IPuaYbtb8OXlLhMYlnl8hkX2dFILqYIXQQip+X/LEYnuFPD5W1xp1QO8PbgRNSCN6tPIj0lthInzbr1SIj/+z+a/n/adC5a8sJ7tWD0g11k2KD4w0UyacjboA0I9QhTrBwWR4Gme26P3+xnkDfUpRBg91MgJIT2cEDaKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Willy, Vlastimil

On Tue, Jul 14, 2026 at 11:49:12PM -0400, Aaron Rainbolt wrote:
> A user in the Qubes OS issue tracker reported that they could cause
> kernel WARNs in some of their AppVMs when forcibly terminating a NetVM
> that those AppVMs were connected to. [1] Typically, a message such as
> `vif vif-0: xenbus: device forcefully removed from xenstore` appears,
> then a "WARNING" appears immediately thereafter indicating an issue in
> `xennet_disconnect_backend`, with the line of code throwing the warning
> being somewhere in `include/linux/mm.h`. Originally it was thought that
> the warning was simply normal behavior when a device is forcefully
> removed, but it seemed very weird that memory management code would be
> in charge of triggering that warning. Furthermore, I cannot reproduce
> the issue reliably; for some users, it happens immediately after
> shutting down the NetVM, whereas for me, I had to use multiple tricks
> including pausing and unpausing a VM to trigger it. After some
> fiddling, I was able to reproduce the issue using the latest stable
> 7.1.3 kernel:
> 
> 1. On a Whonix-Workstation 18 AppVM (such as anon-whonix), build kernel
>    7.1.3 using the steps from
>    https://kernel-team.pages.debian.net/kernel-handbook/ch-common-tasks.html#s-common-size,
>    ensuring that debug info is enabled. Use Debian's kernel config from
>    the linux-base-7.1.3+deb14-amd64_7.1.3-1_amd64.deb package as the
>    starting kernel config.
> 2. Install the new kernel into a cloned Whonix-Workstation 18 template.
> 3. Install pvgrub in dom0: `sudo qubes-dom0-update --action=install
>    grub2-xen-pvh`
> 4. Create a new AppVM named `anon-whonix-kerntest` based on this
>    template.
> 5. Set the kernel for `anon-whonix-kerntest` to `pvgrub2-pvh`.
> 6. Start `anon-whonix-kerntest`.
> 7. Run `uname -r` in `anon-whonix-kerntest`, ensure that the kernel
>    version displayed is 7.1.3.
> 8. Open a root QTerminal window in `anon-whonix-kerntest` by running
>    the following in dom0: `qvm-run -u root anon-whonix-kerntest
>    qterminal`.
> 9. In the root QTerminal window, run `sysctl kernel.warn_limit=5` to
>    prevent an immediate kernel panic when the kernel warn occurs.
> 10. Open Tor Browser in `anon-whonix-kerntest`, and attempt to navigate
>     to a fairly resource-intensive web page like Reddit's front page.
> 11. While the page is still loading, run `qvm-pause
>     anon-whonix-kerntest` in dom0 to freeze the AppVM.
> 12. In dom0, run `qvm-kill sys-whonix`.
> 13. Wait a few seconds, then run `qvm-unpause anon-whonix-kerntest` to
>     unfreeze the AppVM.
> 14. In the root QTerminal window of `anon-whonix-kerntest`, run `dmesg
>     -w` to watch for kernel messages.
> 15. Wait a few seconds, then start `sys-whonix`. Qubes OS will reattach
>     the network when this is done (there is the equivalent of `xl
>     network-attach` done by the Qubes code automatically). The following
>     messages should appear in dmesg:
> 
>     [  426.609004] vif vif-0: xenbus: device forcefully removed from xenstore
>     [  426.609242] ------------[ cut here ]------------
>     [  426.609254] WARNING: ./include/linux/mm.h:2097 at xennet_disconnect_backend+0x1c7/0x520 [xen_netfront], CPU#0: xenwatch/64
>     [  426.609269] Modules linked in: snd_seq_dummy(E) snd_hrtimer(E) snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) cfg80211(E) nls_ascii(E) nls_cp437(E) vfat(E) fat(E) rfkill(E) xenfs(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) nf_tables(E) binfmt_misc(E) intel_rapl_msr(E) intel_rapl_common(E) intel_uncore_frequency_common(E) intel_pmc_ssram_telemetry(E) intel_vsec(E) aesni_intel(E) gf128mul(E) xen_netfront(E) xen_privcmd(E) xen_gntdev(E) xen_gntalloc(E) xen_blkback(E) drm(E) xen_evtchn(E) jitterentropy_rng(E) libsha3(E) loop(E) configfs(E) efi_pstore(E) nfnetlink(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc16(E) mbcache(E) jbd2(E) dm_snapshot(E) dm_bufio(E) dm_mod(E) xen_blkfront(E)    
>     [  426.609334] CPU: 0 UID: 0 PID: 64 Comm: xenwatch Tainted: G            E       7.1.3 #5 PREEMPT(lazy)
>     [  426.609340] Tainted: [E]=UNSIGNED_MODULE
>     [  426.609343] RIP: 0010:xennet_disconnect_backend+0x1c7/0x520 [xen_netfront]
>     [  426.609349] Code: 94 dd a0 10 00 00 48 8b 4a 08 48 89 ce 83 e6 01 48 83 ee 01 48 09 f1 48 21 ca 0f b6 4a 33 81 f9 f5 00 00 00 0f 85 ea fe ff ff <0f> 0b 49 81 ff 00 01 00 00 0f 82 f8 fe ff ff 4c 89 fe 48 c7 c7 e0    
>     [  426.609352] RSP: 0018:ffffce3d810c3c98 EFLAGS: 00010246
>     [  426.609356] RAX: 0000000000000010 RBX: 0000000000000000 RCX: 00000000000000f5
>     [  426.609358] RDX: fffffb0d80ca9800 RSI: 0000000000000000 RDI: ffffffff88c8a8a0
>     [  426.609360] RBP: ffff8dec51df0000 R08: ffff8debf4dd5a80 R09: ffff8debf4dd5a80
>     [  426.609362] R10: 0000000000000020 R11: 00000000000000bf R12: 0000000000000000
>     [  426.609364] R13: ffff8dec8ef30b80 R14: ffff8dec197fcac0 R15: 0000000000000000
>     [  426.609366] FS:  0000000000000000(0000) GS:ffff8ded2d129000(0000) knlGS:0000000000000000
>     [  426.609369] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     [  426.609370] CR2: 00005faa1a7d3737 CR3: 00000000b420a003 CR4: 0000000000770ef0
>     [  426.609377] PKRU: 55555554
>     [  426.609379] Call Trace:

This is due (or looks like it...) to
static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
[...]
page = virt_to_page(skb->data); /* skb->data is a slab kmallocation */
/* ... */
	info.page = page;
	first_tx = xennet_make_first_txreq(&info, offset, len);
/* ... */
queue->grant_tx_page[i] = page;

and then later

static void xennet_disconnect_backend(struct netfront_info *info)
/* ... */
xennet_release_tx_bufs
get_page(queue->grant_tx_page[i]);
gnttab_end_foreign_access(queue->grant_tx_ref[i],
			  queue->grant_tx_page[i]);

which may trigger get_page() on a slab page:
static inline void get_page(struct page *page)
{
	struct folio *folio = page_folio(page);
	if (WARN_ON_ONCE(folio_test_slab(folio)))
		return;
	if (WARN_ON_ONCE(folio_test_large_kmalloc(folio)))
		return;
	folio_get(folio);
}

and there's your WARN. The code as-is is wrong. get_page() does not stabilize
slab allocations, and the skb is freed right after, which may very well free
the data. This _can_ make sense for other page frags, but I would simply defer
freeing the skb until either the full skb is xmitted, or you successfully
cancel the whole transfer (what I understand is the "foreign access" in this
code). The skb itself should pin the pages.

-- 
Pedro

