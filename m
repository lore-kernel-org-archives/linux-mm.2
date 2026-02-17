Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85BFE9A04A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7556B0088; Tue, 17 Feb 2026 16:48:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895126B0089; Tue, 17 Feb 2026 16:48:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1516B008A; Tue, 17 Feb 2026 16:48:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 621256B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:48:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 063AD5723E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:48:15 +0000 (UTC)
X-FDA: 84455287392.05.F8C347C
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36E0018000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:48:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771364894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMgHvGV5x7RWE02jg44s42t6HLwvo0gSdPgeqX/4Jqw=;
	b=hcHJJgQRVYABvFbL9rLpTGMoQNpS1sJ4uQm3aCLEI4Ss9YWeeVoL6MUwew1tDGgW6oPxkS
	L7HYPHI+IO8LvpMtuOSG4YPOzL3Dg7Bocq1HS0s0/dfiKv6Y6ykuBsI7PQk+GTdcFMyDra
	7jJcM+1hET1UNaLvhQTnKTc/L195F5I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771364894; a=rsa-sha256;
	cv=none;
	b=XFURz32nHwSwX7OlBOjz6dxDIQzmXicb0nbbIJkOtjYIjAALZqC1S/ZV7V4FB/cE7znC+v
	29+jd4HxuyjnDL/Q7Q7yAr24MvAafjpfAQLpkondWDwkEqkTeOVGXxpoqD4A2a6trGxkGD
	oAT4QM5+vvcwRrlMXfmgA/7VqHm5Cbg=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61HLluWx464130;
	Tue, 17 Feb 2026 15:48:00 -0600
Message-ID: <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>
Date: Wed, 18 Feb 2026 08:47:56 +1100
In-Reply-To: <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 36E0018000D
X-Rspamd-Server: rspam02
X-Stat-Signature: miw678qk7wqy8azs1xhu4zzoyp465bpf
X-HE-Tag: 1771364892-712433
X-HE-Meta: U2FsdGVkX18iN5uY5c/ugJXPxx/9d2R4B546MJQnNL4UaQLykRRpc0Ro79XHD9whW5j4VuSCUNHsR+HDnOLkvqPVB7/dghf/H+TE0gT8FFt2mV9fQN+OOAmO1kNkT35sGCxj8UiGeiNc8yIpEIH3lFJ/LNURsycLgEXbNmewW+NwJituG+U1wlJpJRZbin04fix2uzzjErLaLYv0J7FDAxMDRdFvC01ViPOWQfbQfz1XZQlsuzEONckRSh88xo1YprSMkZ6IdIQD8qZAekExtVzg5iznCWECiG5CseoiIhT3hM4OQArjS7wzPOctPPUy0MAjmWJXwDkGFwxiDBzEiW6Yzt9B84wNov2pwOhRmV6zkkoGlUwmZWQjBXJob6Jp4DBGO5ibYG53YYIrK0ZkGn92f5MQzFG+cyK70tT0bvQvHrzVH+q2gPNLhydu5HneutivRcPy6OAD78nFahsnfGuy9ewFmqlXwarwAnw2janmhGbycnYMMpiWH3wPUfCcpDH6knsPgX69YxsPeohKeKPLPFd1HwTLz1s/dx+ma/2PE039/HW3eAZAhdgRJcL1dVOZJwt1Zt/9gTVutyr0byBzpnXSb4g1qwNTxYeGYlH8cRggQE1YnOaIPHRqUlv+YF4sLalMK0sflCchfyK8MKJAaZNOA9kv64DdEPPzcssW7ns/jL4hH+cVP6vgqXupla0622PGztoikuQI1oSq2BcQjUZQXjZ0i0v4ogfy5z9eodWSgAs9mcON4CHNpdbBXxi3r8iIKUl5vW50fxd6BlnFt6TSD1P6r43XWLAOUJtWofnDDjSA9GRGy9OmOB4p7MtrSKi3qU4XfieKR7DWPQkBkYlNpwW+MI9YAnWByzVjNoKNd0G21hh76zIDiZOUlRg2RoFDJdJU2nKbIE7QwCXrDdmOltN+OZJl430ecUJJK2+GdjnjWi4ECNHRKW9DQH4n1btu8YylbidSBpA
 ilF4tOWt
 sRQrAYHzG1YQF3Zht+P0NHcS25GNWJI52txJdGJ9+3Yv32dIvkF/Qq45F4/oIlEqgPsM/NEB7TCNlqYrxbDP8xeCmqLAumEV8VYMw21lcBVM8oAhyhGNflFjSj5sMrfFhKjQycgzVC5obV1JbIg2dPYHOwh1bzONFXZQLmQuiGQz7tLE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 2026-02-17 at 19:28 +1100, Benjamin Herrenschmidt wrote:
> We have two issues:

 .../...

So I ran this through our full regression suite and out of hundreds
(thousands ?) of runs, it hit this *once*:

230	[    0.036100] RETBleed: WARNING: Spectre v2 mitigation leaves CPU vuln=
erable to RETBleed attacks, data leaks possible!
231	[    0.045442] BUG: unable to handle page fault for address: fffff16880=
51dc08
232	[    0.045442] #PF: supervisor read access in kernel mode
233	[    0.045442] #PF: error_code(0x0000) - not-present page
234	[    0.045442] PGD 0 P4D 0=20
235	[    0.045442] Oops: Oops: 0000 [#1] PREEMPT SMP PTI
236	[    0.045442] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.68=
-92.123.amzn2023.x86_64 #1
237	[    0.045442] Hardware name: Amazon EC2 t3.nano/, BIOS 1.0 10/16/2017
238	[    0.045442] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
239	[    0.045442] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 48 b8 00 01 00=
 00 00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39 c1 74 45=
 <4c> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01 00 00 00
240	[    0.045442] RSP: 0000:ffffffffadc03cc0 EFLAGS: 00010002
241	[    0.045442] RAX: dead000000000122 RBX: fffff7c440651c80 RCX: fffff16=
88051dc08
242	[    0.045442] RDX: fffff1688063ca48 RSI: fffff7c440651c88 RDI: fffff7c=
440651c88
243	[    0.045442] RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000=
000000000
244	[    0.045442] R10: 000000000000003c R11: 0000000000000200 R12: ffff888=
31b8cbc80
245	[    0.045442] R13: 0000000000000000 R14: 0000000000019473 R15: fffff7c=
440651cc0
246	[    0.045442] FS:  0000000000000000(0000) GS:ffff88831aa00000(0000) kn=
lGS:0000000000000000
247	[    0.045442] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
248	[    0.045442] CR2: fffff1688051dc08 CR3: 000000000ec34001 CR4: 0000000=
0007706f0
249	[    0.045442] PKRU: 55555554
250	[    0.045442] Call Trace:
251	[    0.045442]  <TASK>
252	[    0.045442]  __free_one_page+0x170/0x520
253	[    0.045442]  free_pcppages_bulk+0x151/0x1e0
254	[    0.045442]  free_unref_page_commit+0x263/0x320
255	[    0.045442]  free_unref_page+0x2c8/0x5b0
256	[    0.045442]  free_reserved_page+0x1c/0x30
257	[    0.045442]  memblock_free_late+0xea/0x190
258	[    0.045442]  efi_free_boot_services+0x11f/0x2e0
259	[    0.045442]  __efi_enter_virtual_mode+0x181/0x210
260	[    0.045442]  efi_enter_virtual_mode+0xcd/0x110
261	[    0.045442]  start_kernel+0x393/0x500
262	[    0.045442]  x86_64_start_reservations+0x14/0x30
263	[    0.045442]  x86_64_start_kernel+0x77/0x80
264	[    0.045442]  common_startup_64+0x13e/0x141
265	[    0.045442]  </TASK>
266	[    0.045442] Modules linked in:
267	[    0.045442] CR2: fffff1688051dc08
268	[    0.045442] ---[ end trace 0000000000000000 ]---
269	[    0.045442] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
270	[    0.045442] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 48 b8 00 01 00=
 00 00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39 c1 74 45=
 <4c> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01 00 00 00
271	[    0.045442] RSP: 0000:ffffffffadc03cc0 EFLAGS: 00010002
272	[    0.045442] RAX: dead000000000122 RBX: fffff7c440651c80 RCX: fffff16=
88051dc08
273	[    0.045442] RDX: fffff1688063ca48 RSI: fffff7c440651c88 RDI: fffff7c=
440651c88
274	[    0.045442] RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000=
000000000
275	[    0.045442] R10: 000000000000003c R11: 0000000000000200 R12: ffff888=
31b8cbc80
276	[    0.045442] R13: 0000000000000000 R14: 0000000000019473 R15: fffff7c=
440651cc0
277	[    0.045442] FS:  0000000000000000(0000) GS:ffff88831aa00000(0000) kn=
lGS:0000000000000000
278	[    0.045442] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
279	[    0.045442] CR2: fffff1688051dc08 CR3: 000000000ec34001 CR4: 0000000=
0007706f0
280	[    0.045442] PKRU: 55555554
281	[    0.045442] Kernel panic - not syncing: Fatal exception
282	[    0.045442] ---[ end Kernel panic - not syncing: Fatal exception ]--=
-
283=09

Unfortunately, I don't have a more complete log (those machines boot
with "quiet").

There is definitely something fishy going on, though I don't know what,
as the page is reserved so it should *not* be touched by the deferred
initialization... Could there be an issue by which we incorrectly go
look at the head page (which hasn't been initialized) of a *potential*
compound/huge page ?

Cheers,
Ben.


> - One is we don't check for pfn_valid(). If this is called for
> a page corresponding to a big enough memory hole that we don't have
> allocated a corresponding sparsemem section for it, it will crash.
>=20
> - Then, when using deferred struct page init, we can end up not
> freeing the pages at all. This happens routinely with some of the
> UEFI Boot Services memory, as soon as they fall above the threshold
> of pages whose initialization is deferred.
>=20
> We can very easily hit the !early_page_initialised() test in
> memblock_free_pages() since the deferred initializer hasn't even
> started yet. As a result we drop the pages on the floor.
>=20
> Now, memblock_free_late() should only ever be called for pages that
> are reserved, and thus for which the struct page has already been
> initialized by memmap_init_reserved_pages().... as long as we check
> for pfn_valid() as a big enough hole might cause entire sections of
> the mem_map to not be allocated at all.
>=20
> So it should be safe to just free them normally and ignore the
> deferred
> initializer, which will skip over them as it skips over anything
> still
> in the memblock reserved list.
>=20
> This helps recover something like 140MB of RAM on EC2 t3a.nano
> instances
> who only have 512MB to begin with (as to why UEFI uses that much,
> that's
> a question for another day).
>=20
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>=20
> v2. Reworked a bit to add the pfn_valid() check, remove the bogus
> memblock
> access in debug mode, and add a test of PageReserved() for sanity.
>=20
> We could separately do a patch forcing UEFI Boot Services into
> memblock.memory but so far I haven't hit a case where that is
> necessary.
>=20
> =C2=A0mm/memblock.c | 9 +++++++--
> =C2=A01 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 905d06b16348a..71eb25b68851e 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1770,9 +1770,14 @@ void __init memblock_free_late(phys_addr_t
> base, phys_addr_t size)
> =C2=A0	cursor =3D PFN_UP(base);
> =C2=A0	end =3D PFN_DOWN(base + size);
> =C2=A0
> +	/* Only free pages that were reserved */
> =C2=A0	for (; cursor < end; cursor++) {
> -		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
> -		totalram_pages_inc();
> +		struct page *p;
> +		if (!pfn_valid(cursor))
> +			continue;
> +		p =3D pfn_to_page(cursor);
> +		if (!WARN_ON(!PageReserved(p)))
> +			free_reserved_page(pfn_to_page(cursor));
> =C2=A0	}
> =C2=A0}
> =C2=A0


