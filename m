Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485B9606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 02:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D7JQ8kG3
Received: by kanga.kvack.org (Postfix)
	id 340936B05B2; Sat,  7 Nov 2026 21:41:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318146B05B3; Sat,  7 Nov 2026 21:41:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207576B05B4; Sat,  7 Nov 2026 21:41:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E63D26B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:41:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E87CA7ED3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:37 +0000 (UTC)
X-FDA: 85410401034.23.08C2AC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D721A180002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D7JQ8kG3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794105696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3bQGxK0eIsD8Is5s6TbrJM+F/ftHRub1Y+D2W3BrRg=;
	b=k+9ZfVpUsP1LzTM89GAKQ6VYCfxnyBerwz+msaapKmNNzaGhm3ET2yUgBgVFq3zgasKwDq
	Yf+bzgrji0SFvVV2kkYXkMyh23uqsA2NVwqK1pQcZYwTXwepjSrt/lA7GoAYR9Y9rXDpwp
	kVWzM9N5/gVoIwTmxVfoKTyX7r3VqqQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794105696;
	b=PSwRqAFCT5cqcNFlJeOGl64e8t83DLOZ3pAW7/vQEM/tU32tYEbsCDzfnSbvrMoWDxim11
	sWOmvJH/hZS834XdSqyOqmq8AzUG+524/q0DkQ0U1QpeN9JDmMAZ/bbJiDdSucV3VHtqRW
	BqRBXY7IBJKfjlE5Ayujh4XdnhD31L0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D7JQ8kG3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F279F60A52;
	Sun,  8 Nov 2026 02:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C870B1F0089F;
	Sun,  8 Nov 2026 02:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794105694;
	bh=k3bQGxK0eIsD8Is5s6TbrJM+F/ftHRub1Y+D2W3BrRg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D7JQ8kG3YP1UfqZ8etYw4/3vP8myk+1N1XxGj4gPOZGo1NkB56TLcJlp+n8URTp6Q
	 srFETKEq4vA8UUC/Ob6bxwPITLIYv8wLa53xsdIBU1WurHwLgAb1wymFK5fNLfUypf
	 xLL3A/llQhvSK/HLzf+44j/Ot+K46MR+oaj4JFLvb4lk17erLPsSd0Z6+zz0QAtZQZ
	 y5o20a9Pl8u83Mb+TKcCG/gPWVYQPpxvtnUyS51XpsVJODKjDNSeii7sVisnZLZkEK
	 Qx1xbfd9xvWEc+6BwEbc7Ok4eITLW4qhCa4lKRR+LZyd+R5Au0+kq3yXNHGpxYHEYX
	 Ty6hjrDzrM3jA==
Message-ID: <sashiko-outbox-203522@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 1/8] riscv: Introduce support for hardware
 break/watchpoints
Reply-To: sashiko-reviews@lists.linux.dev
To: "Himanshu Chauhan" <himanshu.chauhan@oss.qualcomm.com>, "Paul Walmsley" <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>
Cc: "Alexandre Ghiti" <alex@ghiti.fr>, "Jesse Taube" <jtaubepe@redhat.com>, "Oleg
 Nesterov" <oleg@redhat.com>, "Kees Cook" <kees@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Arnaldo Carvalho de Melo" <acme@kernel.org>, "Namhyung
 Kim" <namhyung@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri Olsa" <jolsa@kernel.org>, "Ian
 Rogers" <irogers@google.com>, "Adrian Hunter" <adrian.hunter@intel.com>, "James
 Clark" <james.clark@linaro.org>, "Shuah Khan" <shuah@kernel.org>, linux-mm@kvack.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20261107023917.40606-2-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
 <20261107023917.40606-2-himanshu.chauhan@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 02:41:33 +0000
X-Stat-Signature: u5rbq3oswhpobknampwtbeteytqojqz4
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D721A180002
X-HE-Tag: 1794105695-182538
X-HE-Meta: U2FsdGVkX19t14qRuFJhgB8CUHx+6fz63eZwpabrHYf2QlufcaUKmxQ7kBX6wg1uccC87MVE0hbPjCxMEvbI20dxXStqOqngPckJLHJNtmWMOknmaNH/GQaYflJ/mvV8NrMlg6wqd9QhVnnnfKo8zHh59NLU/AWuYhUHjspKo8fGJrncbisDEbxHzugi76/C1R34MaiKDDeSl2aC+ly5VGAwFhR1BqwRIXE/6c3iFiSOoUXscquDJZ7vpzS4At3zvQp9y3O+5MfFo6IYFzreUOLSPhWWBLFvuuQMF52JQLuKua4X3Jfc85nwIu1uRbxFey9cvwsu2rm+gdOt+Od05+B13LhxjVevfw63xbjyBFZz1PyePyceWFsr8D+NYpOhjSY5RGNFLVg7YQs7a9h7TH2j2vRC5S3Lbg0SN4RAjTLJAaMlWcBGMboSzQkLgMI47uRh/WvBArayXBPlPXzheJHRkGB2TqX7UCJdwG5BUHUFPMQgUKKPwHQinwGkKCnBIThSNSL3GNbRqIFsP67ZrNk0TiOwgXTwVJjyt8YX7ev5coMz0Rri/+5BtjPBPu1a/galtgGM//glIOzKxWtYIjupaTO9AK0fAVr7TQ3D2xdoHoRRVa+TvWIg9kzAHes/Du0GzdxkRZyNi8Y6v/emmoNATFmbQ58tUgpzZozPhWEs8fCRylJC+jp285K8zzDRiw4yycCzyXjKAtx/9SaxiCjhwo8w2LUAZOcoXmKPPtRz59dw/Rtj+ECPEw7Og4ZBsrdjhrjXSzzmPvkR9B+XuKAEgaD2lBT2DmXV3eUTsimgeDKlzxe9o1LhaJ4ahLlLQtHlyFNbMk9bSw0yNhUQABW7NGB9uVZcsygbqzh4uI/UJTZfe7ub/SHAO/amZvFvPwC0k0woA3p+gpLWxJ+H2wchZI7ev1rnQRxC+I/JRhkWRDJRnbxzB2yw3tobueIacoMZ5yJBIJLuUdIKuU/
 vKsxmMU2
 txJcIvRt8R8ynGFCacuz+4ulb8s42qqyvEVpTl58JdgxogI489sIBATJL5jpMG21J1XhL0YAjWSkYov9GVierGCyegj0eL9lt+ShSWztPS5cs/rhNZQ+IUuqUCtuwbE9TBl+iW7w7M2B+ILJLuDXIcPWPSfDyAMZHCpn3I1xz0EBNjFExDh6a/Koa0oD0oRRXcGOJVPGCjtN4OEET9ny62U/xD5T0usD52BgNbQPUHvaZA92pE/GhLysR/UHSp/MkEV7aCJdb5LIBFH9wKyB09y6X4pV0jVdgGPofECjhxdP9i2XCHwnUkGoqks2EYPXJNnR6F7tv7kuq2Dp1gYRFrxakskleMVujTuMFTm7Nmz8VckdhjWYJHcqDoD5AhEOtQm0qojqFHvpg+j9NwFgKXJPzsO2pHs8xbFRgZGOg2BCbc9lrdl7apQumkud9moZxUIiFsG0i9uH1+ICfU7kqYmig2Glrxt9Ks5BtynId3V5bsLqtsVtZI8QBAHXw/xexzyflsADbGlLxoC0W3AAD2mea/lvt04arvjDs7oQoJjOpzb7gIvSqLudnXPRNty6plyFlOpgsn/BTIptTmFXzF//NP7cemfsZG7NORa/iqhnl2GEseuaGwDay3oK+OEC8Ra5k34tETAQo2ew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 11 potential
issues to consider:
- [High] riscv: hw_breakpoint: unconditional overlap match and early
  exit in handler
- [High] riscv/hw_breakpoint: handle_break() runs DIE_DEBUG with IRQs
  enabled
- [High] riscv: hw_breakpoint: missing trigger step-over in
  hw_breakpoint_handler()
- [High] riscv: hw_breakpoint: invalid bp_len handling and watchpoint
  size programming
- [Medium] riscv: hw_breakpoint: NULL sbi_dbtr_shmem dereference on init
  alloc failure
- [Medium] riscv: hw_breakpoint: wrong cpuhp state ordering for SBI
  shared memory
- [Medium] riscv: hw_breakpoint: missing ecall_lock in
  arch_disable_hw_breakpoint()
- [Medium] riscv: hw_breakpoint: stale slot pointer in
  arch_uninstall_hw_breakpoint()
- [Low] riscv: Kconfig: unmet HAVE_HW_BREAKPOINT dependency for mixed
  breakpoints
- [Low] MAINTAINERS: overbroad drivers/perf/ path and missing S: tag in
  RISC-V entry
- [Low] riscv/hw_breakpoint: sparse endianness mismatch on sbi_dbtr
  shmem fields
--

commit dde98179a500199d237defeb10f1d800c10ddb91
Author: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>

riscv: Introduce support for hardware break/watchpoints

This commit introduces hardware breakpoint and watchpoint support on
RISC-V using the perf hardware breakpoint framework and the SBI debug
trigger extension (Sdtrig).

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 93abbb315065d..73b69e8dcba15 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24163,6 +24163,15 @@ F:	Documentation/devicetree/bindings/power/riscv=
,rpmi-device-power.yaml
>  F:	Documentation/devicetree/bindings/power/riscv,rpmi-mpxy-device-power.=
yaml
>  F:	drivers/pmdomain/riscv/
> =20
> +RISC-V DEBUGGING
> +M:	Himanshu Chauhan <himanshu@thechauhan.dev>
> +L:	linux-riscv@lists.infradead.org
> +F:	arch/riscv/include/asm/hw_breakpoint.h
> +F:	arch/riscv/include/asm/perf_event.h
> +F:	arch/riscv/kernel/hw_breakpoint.c
> +F:	arch/riscv/kernel/perf_*
> +F:	drivers/perf/

[Severity: Low]
Should this MAINTAINERS entry drop F: drivers/perf/ (which claims the
entire multi-architecture perf driver directory already covered for RISC-V
by RISC-V PMU DRIVERS), include the required S: status tag, and be placed
in alphabetical order before RISC-V RPMI DEVICE POWER DRIVER?

> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index e7891a2a89da6..2cfd9f3695346 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -173,6 +173,8 @@ config RISCV
>  	select HAVE_FUNCTION_ARG_ACCESS_API
>  	select HAVE_FUNCTION_ERROR_INJECTION
>  	select HAVE_GCC_PLUGINS
> +	select HAVE_HW_BREAKPOINT if PERF_EVENTS && RISCV_SBI
> +	select HAVE_MIXED_BREAKPOINTS_REGS if PERF_EVENTS

[Severity: Low]
Does selecting HAVE_MIXED_BREAKPOINTS_REGS without gating on RISCV_SBI
cause an unmet direct dependency warning when CONFIG_PERF_EVENTS=3Dy and
CONFIG_RISCV_SBI=3Dn (such as on M-mode builds)?  In arch/Kconfig,
HAVE_MIXED_BREAKPOINTS_REGS depends on HAVE_HW_BREAKPOINT.

> diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw_bre=
akpoint.c
> new file mode 100644
> index 0000000000000..421ecd8549d94
> --- /dev/null
> +++ b/arch/riscv/kernel/hw_breakpoint.c

[ ... ]

> +	if (attr->bp_type =3D=3D HW_BREAKPOINT_X) {
> +		/*
> +		 * Userspace debuggers can request execute breakpoints with
> +		 * bp_len =3D=3D 2 for compressed/non-aligned instruction
> +		 * addresses. Program execute triggers with "match any size"
> +		 * to avoid missing valid instruction fetches.
> +		 */
> +		hw->len =3D 0;
> +	} else {
> +		switch (attr->bp_len) {
> +		case HW_BREAKPOINT_LEN_1:
> +			hw->len =3D 1;
> +			tdata1 |=3D dbtr_mcontrol_size(1, 0);
> +			break;
> +		case HW_BREAKPOINT_LEN_2:
> +			hw->len =3D 2;
> +			tdata1 |=3D dbtr_mcontrol_size(2, 0);
> +			break;
> +		case HW_BREAKPOINT_LEN_4:
> +			hw->len =3D 4;
> +			tdata1 |=3D dbtr_mcontrol_size(3, 0);
> +			break;
> +#if __riscv_xlen >=3D 64
> +		case HW_BREAKPOINT_LEN_8:
> +			hw->len =3D 8;
> +			tdata1 |=3D dbtr_mcontrol_size(1, 1);
> +			break;
> +#endif
> +		/* Set to match any size */
> +		default:
> +			hw->len =3D 0;
> +			break;
> +		}
> +	}

[Severity: High]
Does programming attr->bp_len into tdata1's size field with match =3D 0 cau=
se
watchpoints in rv_init_mcontrol_trigger() and rv_init_mcontrol6_trigger()
to miss valid memory accesses?

In Sdtrig mcontrol and mcontrol6, tdata1.size filters the access width of
the load or store instruction itself, while match =3D 0 matches only the
exact address in tdata2.  A watchpoint of length N will therefore ignore
accesses of any other width as well as accesses to non-zero byte offsets
within [bp_addr, bp_addr + bp_len) (for example, a 1-byte store to offset 1
of a 2-byte watchpoint).

Also, the default branch accepts arbitrary invalid attr->bp_len values by
setting hw->len =3D 0 instead of returning -EINVAL, which causes
arch_check_bp_in_kernelspace() to check only a 1-byte range against
TASK_SIZE.

[ ... ]

> +static void dbtr_encode_update(union sbi_dbtr_shmem_entry *shmem,
> +			       unsigned long idx, unsigned long tdata1,
> +			       unsigned long tdata2, unsigned long tdata3)
> +{
> +	struct sbi_dbtr_id_msg *id =3D &shmem->id;
> +	struct sbi_dbtr_data_msg *data =3D &shmem->data;
> +
> +	/*
> +	 * SBI_EXT_DBTR_TRIG_UPDATE takes the number of entries in a0.  The
> +	 * trigger index for each entry lives in the first shared-memory word;
> +	 * that word is named tstate only when the same union is used for
> +	 * TRIG_READ replies.
> +	 */
> +	id->idx =3D cpu_to_le(idx);
> +	data->tdata1 =3D cpu_to_le(tdata1);
> +	data->tdata2 =3D cpu_to_le(tdata2);
> +	data->tdata3 =3D cpu_to_le(tdata3);
> +}

[Severity: Low]
Does converting these shared-memory fields with cpu_to_le() and le_to_cpu()
trigger sparse endianness warnings?  In arch/riscv/include/asm/sbi.h,
struct sbi_dbtr_data_msg and struct sbi_dbtr_id_msg declare idx, tstate,
and tdata1..tdata3 as unsigned long rather than __le64 / __le32, so reading
and writing them with cpu_to_le() and le_to_cpu() here, in
mc_read_and_clear_hit(), mc6_read_and_clear_hit(), and
arch_install_hw_breakpoint() mismatches restricted bitwise types.

[ ... ]

> +static int hw_breakpoint_handler(struct die_args *args)
> +{
> +	int i, bp_ret =3D NOTIFY_DONE;
> +	struct arch_hw_breakpoint *bp;
> +	struct perf_event *event;
> +
> +	for (i =3D 0; i < dbtr_total_num; i++) {
> +		event =3D this_cpu_read(pcpu_hw_bp_events[i]);
> +		if (!event)
> +			continue;
> +
> +		bp =3D counter_arch_bp(event);
> +
> +		switch (event->attr.bp_type) {
> +		/* Breakpoint */
> +		case HW_BREAKPOINT_X:
> +			{
> +				bool hit =3D bp->address =3D=3D args->regs->epc;
> +
> +				if (dbtr_type =3D=3D RISCV_DBTR_TRIG_MCONTROL)
> +					hit |=3D mc_read_and_clear_hit(i);
> +				else if (dbtr_type =3D=3D RISCV_DBTR_TRIG_MCONTROL6)
> +					hit |=3D mc6_read_and_clear_hit(i) !=3D
> +					       RISCV_DBTR_MC6_HIT_FALSE;
> +
> +				if (hit) {
> +					perf_bp_event(event, args->regs);
> +					bp_ret =3D NOTIFY_STOP;
> +					goto exit;
> +				}
> +			}
> +			break;
> +
> +		/* Watchpoint */
> +		case HW_BREAKPOINT_W:
> +		case HW_BREAKPOINT_R:
> +		case HW_BREAKPOINT_RW:
> +			{
> +				unsigned long stval =3D args->regs->badaddr;
> +				unsigned long bp_start =3D bp->address;
> +				unsigned long bp_len =3D bp->len ?: 1;
> +				bool hit =3D false;
> +
> +				/*
> +				 * Prefer tdata1.hit from SBI trigger readout whenever
> +				 * possible. Fall back to address-based matching if HIT
> +				 * isn't observed/supported.
> +				 */
> +				if (dbtr_type =3D=3D RISCV_DBTR_TRIG_MCONTROL)
> +					hit =3D mc_read_and_clear_hit(i);
> +				else if (dbtr_type =3D=3D RISCV_DBTR_TRIG_MCONTROL6)
> +					hit =3D mc6_read_and_clear_hit(i) !=3D
> +					      RISCV_DBTR_MC6_HIT_FALSE;
> +
> +				/*
> +				 * Sdtrig may report STVAL as the lowest accessed
> +				 * address while the watchpoint can match a higher byte
> +				 * in the same access.  Check for full range overlap
> +				 * rather than comparing only the two start addresses.
> +				 */
> +				hit |=3D ranges_overlap(bp_start, bp_len, stval,
> +						      sizeof(long));
> +				if (hit) {
> +					perf_bp_event(event, args->regs);
> +					bp_ret =3D NOTIFY_STOP;
> +					goto exit;
> +				}
> +			}
> +			break;

[Severity: High]
Does unconditionally ORing the hardware hit readout with software address
comparisons and jumping to exit on the first match misattribute events,
leave stale HIT bits set in higher slots, and swallow software EBREAK
traps?

When a trigger in slot j > i fires at an address within sizeof(long) bytes
of a watchpoint in slot i (or with a different access type), slot i's false
hardware hit readout is overridden by ranges_overlap(), attributing the
event to slot i.  Because the loop then jumps to exit,
mc_read_and_clear_hit(j) / mc6_read_and_clear_hit(j) never runs for slot j,
leaving its hardware HIT bit set for the next debug exception.

Furthermore, because handle_break() invokes DIE_DEBUG before checking for
kernel WARN_ON()/BUG() traps and hw_breakpoint_handler() does not check
that a hardware trigger fired or that user_mode(args->regs) matches the
trigger's privilege mode, a user watchpoint covering address 0..7 will
match stval =3D=3D 0 on a kernel WARN_ON() EBREAK and return NOTIFY_STOP
without advancing regs->epc, livelocking the CPU on the same EBREAK.

[Severity: High]
In addition, how does execution make forward progress after a breakpoint or
watchpoint hits?

Both rv_init_mcontrol_trigger() and rv_init_mcontrol6_trigger() configure
before-execution triggers (timing =3D 0), so the exception is taken before
the instruction at regs->epc retires.  Clearing the hit bit and returning
NOTIFY_STOP without stepping over the instruction or disabling the trigger
causes sret to return to the same instruction and re-trigger the exception
in an infinite loop.

Even with commit "riscv: Add software supported single stepping with mc/mc6
triggers" later in the series, when setup_singlestep() fails (such as for
CPU-wide breakpoints where event->hw.target is NULL),
disable_unhandled_singlestep() only queues asynchronous irq_work via
perf_event_disable_inatomic() without disabling or uninstalling the
hardware trigger before sret.

[ ... ]

> +	ret =3D dbtr_uninstall_trigger_locked(i);
> +
> +	if (ret.error) {
> +		pr_warn("Failed to uninstall trigger %d.\n", i);
> +		goto out;
> +	}
> +
> +	*slot =3D NULL;
> +
> + out:
> +	raw_spin_unlock_irqrestore(this_cpu_ptr(&ecall_lock), flags);
> +}

[Severity: Medium]
If dbtr_uninstall_trigger_locked() fails in arch_uninstall_hw_breakpoint(),
does jumping to out without clearing *slot leave a dangling perf_event
pointer in pcpu_hw_bp_events[i]?  Because arch_uninstall_hw_breakpoint()
returns void to hw_breakpoint_del(), the perf core still finishes tearing
down and freeing the perf_event, and later debug exceptions on that CPU
will dereference the freed event in hw_breakpoint_handler().

[ ... ]

> +void arch_disable_hw_breakpoint(struct perf_event *event)
> +{
> +	struct perf_event **slot;
> +	struct sbiret ret;
> +	int i;
> +
> +	for (i =3D 0; i < dbtr_total_num; i++) {
> +		slot =3D this_cpu_ptr(&pcpu_hw_bp_events[i]);
> +
> +		if (*slot =3D=3D event)
> +			break;
> +	}
> +
> +	if (i =3D=3D dbtr_total_num) {
> +		pr_warn("Breakpoint not installed.\n");
> +		return;
> +	}
> +
> +	ret =3D sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIG_DISABLE,
> +			i, 1, 0, 0, 0, 0);
> +
> +	if (ret.error) {
> +		pr_warn("Failed to uninstall trigger %d.\n", i);
> +		return;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(arch_disable_hw_breakpoint);

[Severity: Medium]
Should arch_disable_hw_breakpoint() acquire ecall_lock with
raw_spin_lock_irqsave() like arch_enable_hw_breakpoint() and
arch_uninstall_hw_breakpoint() do?  Without it, reading pcpu_hw_bp_events[]
and issuing the SBI_EXT_DBTR_TRIG_DISABLE ecall can migrate CPUs mid-call
or race with concurrent trigger operations on the same CPU.

Also, arch_enable_hw_breakpoint(), arch_update_hw_breakpoint(), and
arch_disable_hw_breakpoint() have no callers in the tree, and the error
messages in arch_enable_hw_breakpoint() and arch_disable_hw_breakpoint()
say "install" and "uninstall" instead of "enable" and "disable".

> +
> +void hw_breakpoint_pmu_read(struct perf_event *bp) { }
> +
> +void flush_ptrace_hw_breakpoint(struct task_struct *tsk) { }
> +
> +static int __init arch_hw_breakpoint_init(void)
> +{
> +	unsigned int cpu;
> +	int rc =3D 0;
> +
> +	for_each_possible_cpu(cpu)
> +		raw_spin_lock_init(&per_cpu(ecall_lock, cpu));
> +
> +	init_sbi_dbtr();
> +
> +	if (dbtr_total_num) {
> +		pr_info("Total number of type %d triggers: %u\n",
> +			dbtr_type, dbtr_total_num);
> +	} else {
> +		pr_info("No hardware triggers available\n");
> +		goto out;
> +	}
> +
> +	/* Allocate per-cpu shared memory */
> +	sbi_dbtr_shmem =3D __alloc_percpu(sizeof(*sbi_dbtr_shmem) * dbtr_total_=
num,
> +					PAGE_SIZE);
> +
> +	if (!sbi_dbtr_shmem) {
> +		pr_warn("Failed to allocate shared memory.\n");
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}

[Severity: Medium]
If __alloc_percpu() fails here, does leaving dbtr_total_num and dbtr_type
set allow later breakpoint registrations to dereference a NULL
sbi_dbtr_shmem via this_cpu_ptr(sbi_dbtr_shmem) in
arch_install_hw_breakpoint()?

hw_breakpoint_slots() already ran earlier during perf_event_init() and
cached the non-zero slot count, and the same NULL sbi_dbtr_shmem
dereference can occur if an in-kernel caller registers a breakpoint between
perf_event_init() and arch_hw_breakpoint_init().  In addition,
init_sbi_dbtr() discards the total trigger count returned by
SBI_EXT_DBTR_NUM_TRIGGERS(0) and bounds-checks recv->idx in
arch_install_hw_breakpoint() against only the type-specific trigger count
dbtr_total_num, which will reject valid trigger indices >=3D dbtr_total_num
if triggers of other types precede them on the hart.

> +
> +	/* Hotplug handler to register/unregister shared memory with SBI */
> +	rc =3D cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
> +			       "riscv/hw_breakpoint:prepare",
> +			       arch_smp_setup_sbi_shmem,
> +			       arch_smp_teardown_sbi_shmem);

[Severity: Medium]
Does registering the SBI shared-memory callbacks at CPUHP_AP_ONLINE_DYN
disable shared memory too early during CPU hotplug teardown and enable it
too late during bringup?

In enum cpuhp_state, CPUHP_AP_ONLINE_DYN runs after CPUHP_AP_PERF_ONLINE
and CPUHP_AP_SCHED_WAIT_EMPTY on bringup, and before them on teardown.
When a CPU goes offline, arch_smp_teardown_sbi_shmem() disables SBI shared
memory while per-CPU and per-task breakpoints are still active on that CPU,
causing trigger reads, updates, or installations before
CPUHP_AP_PERF_ONLINE and CPUHP_AP_SCHED_WAIT_EMPTY to fail with
SBI_ERR_NO_SHMEM.

> diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
> index f8292adda0999..1b9ccc0b6b8d8 100644
> --- a/arch/riscv/kernel/traps.c
> +++ b/arch/riscv/kernel/traps.c
> @@ -287,6 +287,12 @@ void handle_break(struct pt_regs *regs)
>  	if (probe_breakpoint_handler(regs))
>  		return;
> =20
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +	if (notify_die(DIE_DEBUG, "EBREAK", regs, 0, regs->cause, SIGTRAP)
> +	    =3D=3D NOTIFY_STOP)
> +		return;
> +#endif

[Severity: High]
Does calling notify_die(DIE_DEBUG, ...) from handle_break() invoke
hw_breakpoint_handler() and perf_bp_event() with local interrupts and
preemption enabled on user-mode traps?

do_trap_break() calls local_irq_enable() before handle_break(regs) when
user_mode(regs) is true:

arch/riscv/kernel/traps.c:do_trap_break() {
	if (user_mode(regs)) {
		irqentry_enter_from_user_mode(regs);
		local_irq_enable();

		handle_break(regs);

perf_bp_event() requires local interrupts and preemption to be disabled
(asserted via lockdep_assert_irqs_disabled() in kernel/events/core.c), and
hw_breakpoint_handler(), mc_read_and_clear_hit(), and
mc6_read_and_clear_hit() also call this_cpu_read() and this_cpu_ptr()
before acquiring ecall_lock.  Running with interrupts and preemption
enabled triggers lockdep and CONFIG_DEBUG_PREEMPT warnings and allows task
migration or cross-CPU perf IPIs to race with trigger readout and event
delivery.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107023917.4060=
6-1-himanshu.chauhan@oss.qualcomm.com?part=3D1

