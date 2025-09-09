Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E23CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BDDB6B000C; Mon,  8 Sep 2025 22:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DFF6B000E; Mon,  8 Sep 2025 22:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084046B0023; Mon,  8 Sep 2025 22:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC6136B000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:30:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95D1A58941
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:30:43 +0000 (UTC)
X-FDA: 83868133566.16.A5F429D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E968920008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:30:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qIzlBMzQ;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757385041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVMrnfjPjhw5cPnx+0JLW7lU/NWv6cLPOhQYU4FTcuA=;
	b=XPVuLep/Nw1bymDhuzzRWMGij/42mavqmVxPwKupMWEdV4v6mg01GkB0F+i26Znjyi9sY2
	9Ys6ozn8XGRVsBfnoxRehC6i2BLIn6lDT7JQF0AOSYPUYqCMhEEVAoSZUI9zSaCOw2Iynh
	Eol83us+01l7qc8pe4T+31ZIBN/TSo0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757385041; a=rsa-sha256;
	cv=none;
	b=kZ4TYf7dYOaffd8zocI3OumuDTxtH4+hj9DKbwGsEdpHNYsHc4sAm0DwOcT37m42bPsRaj
	yhkuvH7ps0arF4LVRL9HP7HFJvmQXxpMrnTMWKT76PArayijP6MDQlnQ2DJv33W/d15xfu
	HV5pmdAQtRiZ8F4zrdPlyrt8wA6AFo0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qIzlBMzQ;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5434260140;
	Tue,  9 Sep 2025 02:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE8FC4CEF1;
	Tue,  9 Sep 2025 02:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757385041;
	bh=xnOLbYMGoywA58IwPQcrin2gfn9hbtMOOqyLDQfKno4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qIzlBMzQoreDfbkp+ywx7O5GwWyrc3X34JEXFnprc9N2wl/glmiwdDJlD87YXCgII
	 wXHRJ3VrRL7DlrE08tdkW2ygDGbyh4ZgJ9yHnzZWR7G/E5JcIRJZg+gM4KG4qQ0apj
	 64dslt4SZOjOXzlKQ5qqC3IPrfDXjFgmIXvmBbV4=
Date: Mon, 8 Sep 2025 19:30:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>, linux-mm@kvack.org,
 Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky
 <senozhatsky@chromium.org>
Subject: Re: [bug report] BUG zs_handle-zram0 (Tainted: G S ): Objects
 remaining on __kmem_cache_shutdown()
Message-Id: <20250908193040.935144f444ab0e14c2cdde60@linux-foundation.org>
In-Reply-To: <CAGVVp+WN0YvN182wCxTWVY19YQGmUJbDS8t3gOZ-=R8+rEfrhw@mail.gmail.com>
References: <CAGVVp+UtpGoW5WEdEU7uVTtsSCjPN=ksN6EcvyypAtFDOUf30A@mail.gmail.com>
	<CAGVVp+U7Sx+pf5ChXHhyWzT_WuyuOKsEtebo8_GjDkut5a0gXg@mail.gmail.com>
	<CAGVVp+WN0YvN182wCxTWVY19YQGmUJbDS8t3gOZ-=R8+rEfrhw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E968920008
X-Stat-Signature: 7uuoqyww4454ctf83gosakr58d7sapqo
X-Rspam-User: 
X-HE-Tag: 1757385041-355650
X-HE-Meta: U2FsdGVkX19cirlzmvpzCsQ/8I6nY+PbH/1YN5XCcADA/wHO5FlaR5X9ypgj2BQP7QyhnWK6bzrcDbgUggt0lvdK+l9J1EUMBUXXw4wewB1bNM1z3BPBQCtux6TMX56NrduotaJ/49rS+0M/FbhN9sH8B9aCWj+JxYtF+oMP5RLO+W/E61paxQZI9oRKpKK+1ABeirxEOLhcEGqmpjosR8ejak7G98a/VUX6NCzeVuxSKXgncTg8Na10aKpARFADKroELEQ4WutAHPZS5c/6SQG9bTgmYyo1h6Mw+czPw4ZaRJmErhQ8pDtmsypPl71IRftsB6aTBugqa7C+uGci9pGAAV4p4Zkr5v9bgrU25EtD3upgJeVnE/haiKdFkt3Vrqh4ezcPQP7rd20aWLhLUqkb61qzo4lObCExNN+0T9+DKOVZd/9yBSYOZK2vjFyLpQEcBSeOCp15kQnoACgxYxJz5Y6iHjmS6Mh1SmcGqdgy/JgOvVLJ4qut5H0SBmimkhTCKlPLPM+5W5fSEtyb2loyG8RjpvClCbjVAYhDOAUu9UL+IcsvjQ0SACoHIwNiezDDVC3g1AqvLLUDXggJLvjxoVHENYnwloKjnkYF+Gzl3CRN6hAk69ARbJ3V/X58qkcim2/nnuIxCyJoLuJysQSdOkaKURNW5hqjU2Gb1+KwrCYVdEZLUumn3pWC8F8HEmTCa8oxzEy5TP9eQ4oE3S9ZVsr0akTqnPVNms6ebzsbaMP378vEZ/pNHDBvMeG14ASmrggsRvEJuWJWosqIk8QxSyFwbTj1vow0m+YJgcV4QpSz2/j5DHI0tSwENieeKn0VFKrrCGcjBMHTrMDnMX9OjMzxalvhDn/VWXukpdpLMvjcTKabAwinR4zheVvVSpQcWNtg/xQdyt6yBolnufqFevZoPbCtEH/8K4wdpMWN7QyEhF1qx7Ohsv/rs2CFypVqqGmNDFktVkIGFmH
 3t2HwFLT
 lbnCQtjC23TZqz2wsq3SheqRBYILWmOprLc2KOu7pdJGkwzqIMpd9VxkFxqRK8yLvu5t7LCGn2kV0aIYFyle/nXyQQxFGvfWRgNL9plz5llFJKzPDLvrR/1RU14jwEbYDLaa5rl8dxsYlMeHELXA0cJDmz7wDEXx8GbAo1wsvzWnjF7oWm2J1cEMy30LAWAqDfX/XhlVwfoaBaLOvQEc0+egyW9eWYZ4ZY4IhhnD9uLDXMtsd0z54YPu7ZRuynP6cgodoFxIXgaR5wM6KdQ+sSmHhlMjAZ6XyOYmr41nTa8ia8/pXJhnBFVcXXvvqdOMyhsfB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Sep 2025 10:17:17 +0800 Changhui Zhong <czhong@redhat.com> wrote:

> I still see this issue on v6.17.0-rc5, please take a look if you have a chance

Well it might be related to zram, although we haven't done much at all
with zram or zsmalloc in this cycle.

> [ 6915.287305] BUG zs_handle-zram0 (Tainted: G S                 ):
> Objects remaining on __kmem_cache_shutdown()
> [ 6915.298379] -----------------------------------------------------------------------------
> [ 6915.298379]
> [ 6915.309166] Object 0x0000000023ce3ee6 @offset=960
> [ 6915.314421] Slab 0x00000000913eaa62 objects=128 used=1
> fp=0x0000000064bf6df4
> flags=0x17ffffc0000200(workingset|node=0|zone=2|lastcpupid=0x1fffff)
> [ 6915.329002] ------------[ cut here ]------------
> [ 6915.334159] WARNING: CPU: 2 PID: 7198 at mm/slub.c:1176
> __slab_err.part.0+0x19/0x20
> [ 6915.342713] Modules linked in: zram 842_decompress lz4hc_compress
> 842_compress lz4_compress zstd_compress tls rpcsec_gss_krb5
> auth_rpcgss nfsv4 dns_resolver nfs lockd grace nfs_localio netfs
> intel_rapl_msr intel_rapl_common intel_uncore_frequency
> intel_uncore_frequency_common i10nm_edac skx_edac_common nfit
> libnvdimm x86_pkg_temp_thermal intel_powerclamp rfkill coretemp
> kvm_intel kvm dax_hmem cxl_acpi cxl_port irqbypass cxl_core iTCO_wdt
> cdc_ether rapl iTCO_vendor_support usbnet intel_cstate mii
> intel_uncore mgag200 intel_th_gth isst_if_mbox_pci einj i2c_i801
> i2c_algo_bit isst_if_mmio pcspkr mei_me isst_if_common intel_th_pci
> ioatdma i2c_smbus mei intel_vsec acpi_power_meter ipmi_ssif
> intel_pch_thermal intel_th dca ipmi_si acpi_ipmi ipmi_devintf
> ipmi_msghandler acpi_pad sg fuse loop xfs sd_mod ghash_clmulni_intel
> ahci libahci tg3 libata wmi sunrpc dm_mirror dm_region_hash dm_log
> dm_multipath dm_mod nfnetlink [last unloaded: brd]
> [ 6915.434755] CPU: 2 UID: 0 PID: 7198 Comm: bash Kdump: loaded
> Tainted: G S  B               6.17.0-rc5 #1 PREEMPT(voluntary)
> [ 6915.447281] Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE
> [ 6915.453016] Hardware name: Lenovo ThinkSystem SR650 V2/7Z73CTO1WW,
> BIOS AFE118M-1.32 06/29/2022
> [ 6915.462728] RIP: 0010:__slab_err.part.0+0x19/0x20
> [ 6915.467981] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
> 90 0f 1f 44 00 00 e8 f6 fc ff ff be 01 00 00 00 bf 05 00 00 00 e8 77
> bf 29 00 <0f> 0b c3 cc cc cc cc 48 89 ee 48 c7 c7 eb a2 86 ab c6 05 10
> 13 c4
> [ 6915.488939] RSP: 0018:ffa0000002fcf918 EFLAGS: 00010046
> [ 6915.494773] RAX: 0000000000000000 RBX: ffd400000b6c3b80 RCX: ffffffffa80d3a9a
> [ 6915.502740] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffffadd3f180
> [ 6915.510706] RBP: ff11000149c51140 R08: 0000000000000001 R09: fffffbfff5ba7e30
> [ 6915.518672] R10: ffffffffadd3f187 R11: 0000000062616c53 R12: ff11000285ff0000
> [ 6915.526640] R13: ff11000285ff1000 R14: ff11000149c4f040 R15: ffd400000a17fc00
> [ 6915.534605] FS:  00007f9aa117a740(0000) GS:ff1100043db3d000(0000)
> knlGS:0000000000000000
> [ 6915.543637] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 6915.550051] CR2: 000056332051e698 CR3: 00000001485c1002 CR4: 0000000000773ef0
> [ 6915.558017] PKRU: 55555554
> [ 6915.561037] Call Trace:
> [ 6915.563766]  <TASK>
> [ 6915.566108]  __kmem_cache_shutdown.cold+0x1c/0x43
> [ 6915.571364]  kmem_cache_destroy+0x68/0x170
> [ 6915.575938]  zs_destroy_pool+0x18b/0x250
> [ 6915.580319]  zram_reset_device+0x233/0x600 [zram]
> [ 6915.585576]  reset_store+0x20b/0x300 [zram]
> [ 6915.590252]  ? __pfx_reset_store+0x10/0x10 [zram]
> [ 6915.595506]  ? sysfs_file_kobj+0xb3/0x1c0
> [ 6915.599982]  ? sysfs_file_kobj+0xbd/0x1c0
> [ 6915.604449]  ? __pfx_sysfs_kf_write+0x10/0x10
> [ 6915.609315]  kernfs_fop_write_iter+0x3a3/0x5a0
> [ 6915.614278]  vfs_write+0x522/0xfd0
> [ 6915.618078]  ? __pfx_vfs_write+0x10/0x10
> [ 6915.622459]  ? local_clock_noinstr+0xd/0xe0
> [ 6915.627130]  ? __lock_release.isra.0+0x1a4/0x2c0
> [ 6915.632287]  ksys_write+0xf9/0x1d0
> [ 6915.636086]  ? __pfx_ksys_write+0x10/0x10
> [ 6915.640561]  ? lockdep_hardirqs_on+0x78/0x100
> [ 6915.645426]  do_syscall_64+0x94/0x8d0
> [ 6915.649515]  ? ktime_get_coarse_real_ts64+0x121/0x180
> [ 6915.655155]  ? lockdep_hardirqs_on+0x78/0x100
> [ 6915.660022]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 6915.665855]  ? lockdep_hardirqs_on+0x78/0x100
> [ 6915.670719]  ? do_syscall_64+0x139/0x8d0
> [ 6915.675089]  ? __x64_sys_openat+0x108/0x1d0
> [ 6915.679762]  ? __pfx___x64_sys_openat+0x10/0x10
> [ 6915.684819]  ? lockdep_hardirqs_on+0x78/0x100
> [ 6915.689684]  ? syscall_trace_enter+0x13e/0x240
> [ 6915.694648]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 6915.700481]  ? lockdep_hardirqs_on+0x78/0x100
> [ 6915.705347]  ? do_syscall_64+0x139/0x8d0
> [ 6915.709726]  ? rcu_is_watching+0x15/0xb0
> [ 6915.714106]  ? clear_bhb_loop+0x50/0xa0
>
> ...
>
> > > reproducer:
> > > # modprobe zram
> > > # zramctl --find --size 4G --algorithm zstd
> > > # fio --name=test \
> > >         --filename=/dev/zram0 \
> > >         --rw=randrw \
> > >         --bs=4k \
> > >         --ioengine=libaio \
> > >         --iodepth=16 \
> > >         --numjobs=4 \
> > >         --runtime=60 \
> > >         --time_based \
> > >         --group_reporting \
> > >         --direct=1
> > > # echo 1 > /sys/block/zram0/reset
> > >
> > > dmesg log:
> > > [ 4861.143371] zsmalloc: Class-80 fullness group 1 is not empty
> > > [ 4861.149696] zsmalloc: Class-112 fullness group 1 is not empty
> > > [ 4861.156121] zsmalloc: Class-144 fullness group 1 is not empty
> > > [ 4861.162541] zsmalloc: Class-160 fullness group 1 is not empty
> > > [ 4861.168963] zsmalloc: Class-176 fullness group 1 is not empty
> > > [ 4861.175379] zsmalloc: Class-192 fullness group 1 is not empty
> > > [ 4861.181797] zsmalloc: Class-224 fullness group 1 is not empty

Minchan & Sergey, could you please give this a try?

