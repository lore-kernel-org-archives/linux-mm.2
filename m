Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19134C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 12:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976376B0088; Fri,  1 Aug 2025 08:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9277B6B008A; Fri,  1 Aug 2025 08:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815F26B0092; Fri,  1 Aug 2025 08:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 75AF56B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:07:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 30E0D1A080E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:07:45 +0000 (UTC)
X-FDA: 83728064490.20.7BC2F12
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id E7C501A000E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:07:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QGUWevl9;
	spf=pass (imf19.hostedemail.com: domain of hkrzesin@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=hkrzesin@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754050063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcVkJvAFktjZzpTROsYrYOV6ej0May6QulP0eELUUGk=;
	b=Tfku4WROvwbmIdCNpv6A3AWBdoHmk6npuCD5LXpZYRnH11oQ5CsYy8SoGEOKv+3pFTFaqv
	DDbdUiRkN8BhbIviNmosRnY1i1JrYd4zhg3LnWcWCw7sk+RKUe01GooUQ98aEwniimzS4U
	vRiGNsPzN+FziW98+N1WcVQoXDVnrik=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QGUWevl9;
	spf=pass (imf19.hostedemail.com: domain of hkrzesin@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=hkrzesin@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754050063; a=rsa-sha256;
	cv=none;
	b=j+DT5O0PeIKcvqVV8BONEKwW3eszv2ZMdBpS+Yv44v2N8pyBL+PUnAgryAn9LysQFk22iE
	0hx5M2MINfyH75/xcat/zYleIVSs3u4fH7k31o7gBH7nOVRarJXsUKay3/qSa/wcEZ8t4s
	mqPfx8MUXR3Y9hU63cPFQbBSNKG+x1Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754050062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HcVkJvAFktjZzpTROsYrYOV6ej0May6QulP0eELUUGk=;
	b=QGUWevl9jJWaFYgjGIebmDOy6Z16IKNe2b3Nm2LKgouQGgW3UY+C9+epb+r+OEK37qQjTh
	j9yvUirJfz9/MNvoI+DE4tzq1RIPa+R8p0VvfufLkpbweKQydufZFfOo44oR3NMn8URs5Z
	183063T19umpEHj0jcL/SiftRWKZ28A=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-cHZ69OZuPJ-UmSOK9Bo6Sw-1; Fri, 01 Aug 2025 08:07:41 -0400
X-MC-Unique: cHZ69OZuPJ-UmSOK9Bo6Sw-1
X-Mimecast-MFC-AGG-ID: cHZ69OZuPJ-UmSOK9Bo6Sw_1754050060
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-33231dba44bso13774391fa.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 05:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754050059; x=1754654859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcVkJvAFktjZzpTROsYrYOV6ej0May6QulP0eELUUGk=;
        b=FsQ6WeH978lXCSstl42CJKooekSifgTMYu2XzouUyLwIJVm2PAk+ys2gq4brRqOgn+
         mOupfEluO5xz7HU9lAQV6yR8LFe5Vr90gRZ/PoPr8nnBywlMIau0rxx9fJRzmVE7phkJ
         25T8hZvkiSbEnMlwoVcgTm+Ae/Ct0KSoxBbWxkHk9pZlVIM/ny0M/V/HVQ/n2QviOjdl
         P/LBJUf7AXBuFlHwPYoRo6bpX5lTZ5Km7qKytJ5QHNIk5Kcfl/rS6BOUaOWFuLcKxkCU
         8X/FeYdWp02FFkB/EQfvw919FUjDGkQR1ZA9nkXDa5/F/VEIo9UBiUzDlXP7MccTJWJG
         IZ9Q==
X-Gm-Message-State: AOJu0Yxkgu9HUBrhtWnkeF8LFQ/u4eQhcDj+rsnCRKzNXRjFepMDleDL
	6N1T48UOd5f5VxQKzpknthy0FsEiN6qS+o7271M0dq/4Hjdi2IYzlGh07WnheE85XepU+ay3RRo
	+rnPzg5/fKakDqzIIFfDETBi1d0bpBUcbxZN4YXjzSpXTYcGElgSgOWhjOtEkwGPtZhCIymu3S4
	Z/1n6BYFJU8k44vNKBjhcUZmUTUXg=
X-Gm-Gg: ASbGncsEsDnncrP5tzw/xFujnLANddVCQIWDY2DduSHSx44zyIHAFzIi9IF48IcyY2K
	dRUEBYztwrFwZxiYhK942kv6Xyz/APQ8mxDGHLt5yiKKx+P4gQKEB5paR/pkXTPcoFhcbiM8gjg
	yc5e76wSP6gMi18PLoDv03cbJjZT2IvW3Y7y4JjW8TWwbXbBvso0Y73g==
X-Received: by 2002:a2e:a99f:0:b0:32b:2fe7:afd0 with SMTP id 38308e7fff4ca-33224b00238mr32838151fa.17.1754050059390;
        Fri, 01 Aug 2025 05:07:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErzCTJ0JPGgTZ810B7ZKHAzyLHojikjQluDbWBCj3g+zyJvBRB3nhTWnMnSoeIVFKv10zRnrn2EXPbKyqguwE=
X-Received: by 2002:a2e:a99f:0:b0:32b:2fe7:afd0 with SMTP id
 38308e7fff4ca-33224b00238mr32837991fa.17.1754050058787; Fri, 01 Aug 2025
 05:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250731214051.4115182-1-herton@redhat.com> <d1445c9c-6603-4ff2-9cac-2a60ed4efe4b@arm.com>
In-Reply-To: <d1445c9c-6603-4ff2-9cac-2a60ed4efe4b@arm.com>
From: Herton Krzesinski <hkrzesin@redhat.com>
Date: Fri, 1 Aug 2025 09:07:27 -0300
X-Gm-Features: Ac12FXzQbuG9oWdYcAUVTKImH2V2xdXvEOKO3v2EIfcXnrjlcY_54iviXNlugjQ
Message-ID: <CAJmZWFGgxaWU6UW_agPYBLcBPFu3Ji4yRDXRnVMHPLNgiW315A@mail.gmail.com>
Subject: Re: [PATCH] mm/debug_vm_pgtable: clear page table entries at destroy_args()
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 120O3_7AQJiSyDeXMWrilYXywBMQZyoP61s7nTqGhcc_1754050060
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: csz5yzodmdkmumcxp68dgeejtyxjyadq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E7C501A000E
X-Rspam-User: 
X-HE-Tag: 1754050062-390586
X-HE-Meta: U2FsdGVkX19j5Nop+OMUAeJh6p1UNNy0ifbyke6jPEon0xlTd+cPtJ+XidnlXQ4SNkl+ai93bx0BwRVs16y6lT6l45MwM5KMP2BLYhzkemlfJ2PtWr8NECxxvdoZ8owM/JBH2CLF1+trhcAHSy6WzFXSxUCPd4KalmUUdb3OFzZHfyesGV24KniJyPVJjTyKVuwkvuLMkxOFNPmv7gbmfk96tx3JYzF3WwVFazPDQfVypO/BAt93m6R/HkPcaqyfNK0Wm+xTmfAVvVg51+nyl62sbQL1/UmlPuujfw4MBQ+M+DLKU+uTwQFo4VNQoQp5bG+0XHCWtpnlb9mJkxohYMxeEyAEjwknN+6jwQ8jbo7OQVPV87Qe/7Q343drIBCjFMwVcwovwgFhpukpI/URv0Bc0yozWWokTTmucrB+3GTyCRU8z9QsJkrhI+HV625/+h7ujzZIxiatcRAU7zz0Td9rrhAlssDPcNIMU2vZurT7KSne/x6cydtddnYgJrS16U6ttmFcUH9MQ1yuSpu3vql0ObYVJINM9M2+MAIN2lFuiG1H6/JLTsSb8Qg/20YlbIOPMX6HRRIes4K4mLzP/rK5qVkjOOXBoiUtEIrkNk4LdzOLbqYYOIZKKGSCiUdPa0FZz9M2Oo2WsbFP2i9KopQ22csLLFJSdjfLKjkRiUzOOLkzf2grJuaK5DvVKQ9q3+wOb6mxS26IJjQLHiqTPlOiu5xCHduZE82bSroLYLKl2OdudurOCyqQQuJm8TcV9cilY56it5WITsFVVH+fpNid3gRwHBSBiIHljdwyp8Ncrd6hb6wmxIkkWKb0qTwqzIBxnn3Ux5wclcZc2yZEao9lpXbpry23mnqq3tY/94kp2pfrEBaMFM+mgaP5cUm2NUikYxTvWam6SzS19uLWOcs4NAFlTZ0G0ffs8A4Qd3+bDaGNH/FjC89eSeGNctfTSM9hAEgfj0AvaOvFxjQ
 FBIzbx42
 EyySSxaKDSbkoCNZldOECnJSCEwtqI2svztQu3NI7anDW05weANf1+LVV4iKknIojd5X0lxogHtw7nHuuDXfLvT8ZiQLIW6feJ2dlH5XtqwvwfSgU8DvZ5N8hEiUQAxlQuNkoaMmU0TIjJJTuq3V4sL6JafPoqtvplX2V6Eum6fxbo8qD8R3HeWSrVFXciMrJ+OigslRb2JOCnfSgNEYgSbcEBzHZTL1gmsgb/V+wWjsOwDklUaGeb3jjOEJwt+v52H8Zu+ZPH6GLKMh0O9T7z+ZQ6JomzvVg1txBDYnuyBA40CzKVO5rgDxW/WqUECpmnKFgSqXx2zDDxBc7cb7XJRBVgoaoBeZkIDm8DKHIhL7KeH3aX6jxrdUloOgYYMJmRzxC99xRwBmpI6atUXWE7gNGQDN9CVYczwuWxPv2QOFDQjTPyI4rJhfEPTlwmQc0ebkiB5b7L3YwM3syoXh0p2LnseGoHLLGywwu/2Wlqr6eVZ1BAVOrqAvE4phNNMcPZ974
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 11:41=E2=80=AFPM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> Hello Herton,
>
> On 01/08/25 3:10 AM, Herton R. Krzesinski wrote:
> > The mm/debug_vm_pagetable test allocates manually page table entries fo=
r the
> > tests it runs, using also its manually allocated mm_struct. That in its=
elf is
> > ok, but when it exits, at destroy_args() it fails to clear those entrie=
s with
> > the *_clear functions.
> >
> > The problem is that leaves stale entries. If another process allocates
> > an mm_struct with a pgd at the same address, it may end up running into
> > the stale entry. This is happening in practice on a debug kernel with
>
> Should not the allocators ensure that the allocated memory elements are
> all cleaned up before using them ?

I did not saw anything which cleaned them. all the pgd/pud etc. alloc
functions do not clean them, so I think that's the default behaviour
from what I understand. I also used crash utility on a live kernel
reading the pgd address from the mm_struct that was allocated from the
debug_vm_pgtable test and already freed and saw that it was populated
even after it was freed.

>
> > CONFIG_DEBUG_VM_PGTABLE=3Dy, for example this is the output with some
> > extra debugging I added (it prints a warning trace if pgtables_bytes go=
es
> > negative, in addition to the warning at check_mm() function):
> >
> > [    2.539353] debug_vm_pgtable: [get_random_vaddr         ]: random_va=
ddr is 0x7ea247140000
> > [    2.539366] kmem_cache info
> > [    2.539374] kmem_cachep 0x000000002ce82385 - freelist 0x000000000000=
0000 - offset 0x508
> > [    2.539447] debug_vm_pgtable: [init_args                ]: args->mm =
is 0x000000002267cc9e
> > (...)
> > [    2.552800] WARNING: CPU: 5 PID: 116 at include/linux/mm.h:2841 free=
_pud_range+0x8bc/0x8d0
> > [    2.552816] Modules linked in:
> > [    2.552843] CPU: 5 UID: 0 PID: 116 Comm: modprobe Not tainted 6.12.0=
-105.debug_vm2.el10.ppc64le+debug #1 VOLUNTARY
> > [    2.552859] Hardware name: IBM,9009-41A POWER9 (architected) 0x4e020=
2 0xf000005 of:IBM,FW910.00 (VL910_062) hv:phyp pSeries
> > [    2.552872] NIP:  c0000000007eef3c LR: c0000000007eef30 CTR: c000000=
0003d8c90
> > [    2.552885] REGS: c0000000622e73b0 TRAP: 0700   Not tainted  (6.12.0=
-105.debug_vm2.el10.ppc64le+debug)
> > [    2.552899] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>=
  CR: 24002822  XER: 0000000a
> > [    2.552954] CFAR: c0000000008f03f0 IRQMASK: 0
> > [    2.552954] GPR00: c0000000007eef30 c0000000622e7650 c000000002b1ac0=
0 0000000000000001
> > [    2.552954] GPR04: 0000000000000008 0000000000000000 c0000000007eef3=
0 ffffffffffffffff
> > [    2.552954] GPR08: 00000000ffff00f5 0000000000000001 000000000000004=
8 0000000000004000
> > [    2.552954] GPR12: 00000003fa440000 c000000017ffa300 c0000000051d9f8=
0 ffffffffffffffdb
> > [    2.552954] GPR16: 0000000000000000 0000000000000008 000000000000000=
a 60000000000000e0
> > [    2.552954] GPR20: 4080000000000000 c0000000113af038 00007fffcf13000=
0 0000700000000000
> > [    2.552954] GPR24: c000000062a6a000 0000000000000001 8000000062a6800=
0 0000000000000001
> > [    2.552954] GPR28: 000000000000000a c000000062ebc600 000000000000200=
0 c000000062ebc760
> > [    2.553170] NIP [c0000000007eef3c] free_pud_range+0x8bc/0x8d0
> > [    2.553185] LR [c0000000007eef30] free_pud_range+0x8b0/0x8d0
> > [    2.553199] Call Trace:
> > [    2.553207] [c0000000622e7650] [c0000000007eef30] free_pud_range+0x8=
b0/0x8d0 (unreliable)
> > [    2.553229] [c0000000622e7750] [c0000000007f40b4] free_pgd_range+0x2=
84/0x3b0
> > [    2.553248] [c0000000622e7800] [c0000000007f4630] free_pgtables+0x45=
0/0x570
> > [    2.553274] [c0000000622e78e0] [c0000000008161c0] exit_mmap+0x250/0x=
650
> > [    2.553292] [c0000000622e7a30] [c0000000001b95b8] __mmput+0x98/0x290
> > [    2.558344] [c0000000622e7a80] [c0000000001d1018] exit_mm+0x118/0x1b=
0
> > [    2.558361] [c0000000622e7ac0] [c0000000001d141c] do_exit+0x2ec/0x87=
0
> > [    2.558376] [c0000000622e7b60] [c0000000001d1ca8] do_group_exit+0x88=
/0x150
> > [    2.558391] [c0000000622e7bb0] [c0000000001d1db8] sys_exit_group+0x4=
8/0x50
> > [    2.558407] [c0000000622e7be0] [c00000000003d810] system_call_except=
ion+0x1e0/0x4c0
> > [    2.558423] [c0000000622e7e50] [c00000000000d05c] system_call_vector=
ed_common+0x15c/0x2ec
> > (...)
> > [    2.558892] ---[ end trace 0000000000000000 ]---
> > [    2.559022] BUG: Bad rss-counter state mm:000000002267cc9e type:MM_A=
NONPAGES val:1
> > [    2.559037] BUG: non-zero pgtables_bytes on freeing mm: -6144
> >
> > Here the modprobe process ended up with an allocated mm_struct from the
> > mm_struct slab that was used before by the debug_vm_pgtable test. That =
is not a
> > problem, since the mm_struct is initialized again etc., however, if it =
ends up
> > using the same pgd table, it bumps into the old stale entry when cleari=
ng/freeing
> > the page table entries, so it tries to free an entry already gone (that=
 one
> > which was allocated by the debug_vm_pgtable test), which also explains =
the
>
> How did you ensure that it was allocated from debug_vm_pgtable ? Trace pr=
ints during
> its execution and then matching up the addresses ? Just curious.

Usually the mm_struct address would match, but the problem is the pgd
address, the pgd address allocated for the mm_struct matched. Yes
trace prints and the problem happening with same mm_struct->pgd. Also
disabling CONFIG_DEBUG_VM_PGTABLE also made the problem go away. It
was "easy" to reproduce on a powerpc machine (with a reboot loop, in
my case sometimes on a 50 or 100 times, since the test executes only
on early boot), if another process after it got the same mm->pgd by
accident it would get the problem (from experience looking into the
issue, it would happen on boot with udev firing lots of modprobe and
one eventually got the mm_struct from the slab and same pgd that was
used before). What lead me investigating into this was that I saw some
reports of "BUG: non-zero pgtables_bytes on freeing mm" messages
reports, sometimes then followed by corruption/panic usually related
to page table entries, on that reboot loop test. Then I was able to
determine that CONFIG_DEBUG_VM_PGTABLE was to blame, and from there
find out that even disabling the tests manually, only allocing the
pgtable entries was enough to trigger the issue.

>
> > negative pgtables_bytes since it's accounting for not allocated entries=
 in the
> > current process. As far as I looked pgd_{alloc,free} etc. does not clea=
r entries,
> So should they clear entries or doing so would add to overall latency ?
>
> > and clearing of the entries is explicitly done in the free_pgtables->
> > free_pgd_range->free_p4d_range->free_pud_range->free_pmd_range->
> > free_pte_range path. However, the debug_vm_pgtable test does not call
> > free_pgtables, since it allocates mm_struct and entries manually for it=
s test
> > and eg. not goes through page faults. So it also should clear manually =
the
> > entries before exit at destroy_args().
>
> Makes sense.
>
> >
> > This problem was noticed on a reboot X number of times test being done
> > on a powerpc host, with a debug kernel with CONFIG_DEBUG_VM_PGTABLE
> > enabled. Depends on the system, but on a 100 times reboot loop the
> > problem could manifest once or twice, if a process ends up getting the
> > right mm->pgd entry with the stale entries used by mm/debug_vm_pagetabl=
e.
> > After using this patch, I couldn't reproduce/experience the problems
> > anymore. I was able to reproduce the problem as well on latest upstream
> > kernel (6.16).
>
> Seems like a very rare case i.e both to reproduce and also to confirm if =
this patch
> here has indeed solved the problem. Just wondering - did you try to repro=
duce this
> problem on any other platform than powerpc ?

I only tried and then reproduced on ppc, since all reports I saw was
reproducing on it, didn't saw reports on other architectures. I tested
the patch on ppc/x86/s390/arm64 with a bigger X times reboot loop test
(for the test, a 200 times reboot loop). From my understanding,
another process getting the same mm->pgd was the key, so if a process
got lucky enough it triggers the issue.

>
> >
> > I also modified destroy_args() to use mmput() instead of mmdrop(), ther=
e
> > is no reason to hold mm_users reference and not release the mm_struct
> > entirely, and in the output above with my debugging prints I already
> > had patched it to use mmput, it did not fix the problem, but helped
> > in the debugging as well.
>
> Makes sense.
>
> >
> > Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
> > ---
> >  mm/debug_vm_pgtable.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> > index 7731b238b534..0f5ddefd128a 100644
> > --- a/mm/debug_vm_pgtable.c
> > +++ b/mm/debug_vm_pgtable.c
> > @@ -1041,29 +1041,34 @@ static void __init destroy_args(struct pgtable_=
debug_args *args)
> >
> >       /* Free page table entries */
> >       if (args->start_ptep) {
> > +             pmd_clear(args->pmdp);
> >               pte_free(args->mm, args->start_ptep);
> >               mm_dec_nr_ptes(args->mm);
> >       }
> >
> >       if (args->start_pmdp) {
> > +             pud_clear(args->pudp);
> >               pmd_free(args->mm, args->start_pmdp);
> >               mm_dec_nr_pmds(args->mm);
> >       }
> >
> >       if (args->start_pudp) {
> > +             p4d_clear(args->p4dp);
> >               pud_free(args->mm, args->start_pudp);
> >               mm_dec_nr_puds(args->mm);
> >       }
> >
> > -     if (args->start_p4dp)
> > +     if (args->start_p4dp) {
> > +             pgd_clear(args->pgdp);
> >               p4d_free(args->mm, args->start_p4dp);
> > +     }
> >
> >       /* Free vma and mm struct */
> >       if (args->vma)
> >               vm_area_free(args->vma);
> >
> >       if (args->mm)
> > -             mmdrop(args->mm);
> > +             mmput(args->mm);
> >  }
> >
> >  static struct page * __init
> A quick test on arm64 platform looked fine. It might be better to get thi=
s
> enabled and tested on multiple platforms via linux-next.
>


