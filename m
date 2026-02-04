Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 912D0EA794B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 22:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30946B008A; Wed,  4 Feb 2026 17:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD6F6B0092; Wed,  4 Feb 2026 17:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2736B0093; Wed,  4 Feb 2026 17:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74D576B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:50:28 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7BBE140317
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:50:27 +0000 (UTC)
X-FDA: 84408269694.08.AFC936C
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8AC5C40005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:50:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fPo+O9lu;
	spf=pass (imf01.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770245425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+bms48v8RwK0UzjUUFGQsku+HUzf2QKNrbq90FwhBs=;
	b=Aw1vn9mmH8lLKCl0LwNG2QJmiQymI9DGLQR0c+x5SP0IMWW0FQSt7gJHw4gKF8EIMiW2wr
	RRKZy/z7KUsuTO9DYFvR4ej8/eU7Es20ONaeCT6pvyiYXAadLK57mkIiLnJ8EFD2l7TgYh
	mO+xi1PywPmffTZAnhdtyfrrYXnm+KE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fPo+O9lu;
	spf=pass (imf01.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770245425; a=rsa-sha256;
	cv=pass;
	b=Z/HvjCp/4exYPiGDb0hUsx0uX7gqEqazUYTZTirrS0dFBqWiZXF92orQj/2l1r4M2iPRob
	M73c9YPfJfJHsZxexe5K/G9cl7md52vx8qwZWtxdYAt9cL2rhQL8vmf2qsiIQj9H0nRqWW
	sMSkj+vo4mv/buEgk1RjzNDK7XcQzOc=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59dd490be5fso328685e87.2
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 14:50:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770245424; cv=none;
        d=google.com; s=arc-20240605;
        b=WUQQdKSytDNsP0SImNzKw+YBjp163BuHLetrdTVsPxTVl+yJS/LL82fWLyAU48of1Y
         DvV3BfK5XwVXJneqa3yjfcL1jB1FWFyBBdmwSX0e1lIct6nwS+NW8I7zpXdVvYIuh994
         90PalJMJ8oDRxaKsE4G8AC50MCGhzGp4DmhfCUkYEd0oOV/ot05eUwa6CcxG425UNf9x
         6AzvAYHDjTCci81dWwWseROaPD+NH0bivSAFmH58h/A9Oo9hepI0cq/ExQ2hfo/bMwom
         aWC8+/4eBdDUGWY6UVVe7f+d6apsEP6BdSZr+qmsxysHy5r/MeZyjQSNQ4MXNepUuLNY
         WDgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=p+bms48v8RwK0UzjUUFGQsku+HUzf2QKNrbq90FwhBs=;
        fh=Tj8Yv+68Tat6f33mkdvmlxqXOlmx6a5imWfRenmQQUo=;
        b=bDcMZBWRQ/9dqZrvjZNfgykSyL1DOmTjCI6gH9ltVFaxtI1gJas1Tmttwt+IThXw6T
         f1sZpYZGaZ+Ykw0gjC/NDfDAx5xRrXDXCwat7Op7uvcRD8Y7wFw9aM7ysKaWcxWbPy5I
         AViktvgQhMh9vv9Ubo+JjiftIufDN2xLAKJgwgd9hoz3CLfdRmiFlnAXwaTj1JfNDzL5
         k7Pz9Rs+rPvpwojkczZcc/8WfPUpLIYf/O5RH8LlsNCztvt4+n8LcfG9DytJ1Hobljr/
         0sPiIFOL2mnFifBoS26m7+yqczAxWRgeW4HoDXlkvMYGwTWwnj0s5IzXAS8Cx7rlCBrL
         wcpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770245424; x=1770850224; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p+bms48v8RwK0UzjUUFGQsku+HUzf2QKNrbq90FwhBs=;
        b=fPo+O9luUd2lc0UNo+9HYpvcQIGXIYMLSU6RzVk2b+pxm3kOimMoTRU+20xUmRbVcs
         hvrSgAMDmZlMgYzr/093CEyTnV9ukCmqpqCccM3DRUhIh3g2asiwmjLDrC/LbCi9wr46
         +Sf+AN5NQgGEJa1FuJnQizN4AKuFK5IveLYyiRBOMYjtY2dWIjEDaK2uOJOLV788BNme
         u2a3fzS67/2nwouhRk5jPRIS/C0wtnAOSY5uoNR2s6MFwjOLVA1d48Y9F4/dLUQw/wcN
         KZMrJyPYyUotVs4MT7Z87g+Zl9FaE80TZtR+bMTeCXYSHucmzrHkeXBO/fc4L/Pv73BP
         jOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770245424; x=1770850224;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+bms48v8RwK0UzjUUFGQsku+HUzf2QKNrbq90FwhBs=;
        b=HxCsE7CFcjGdqf/jkJyztAT3HYFC0sHjsxlURLYwgUEBmAZPAemuWl4pHfTlEm/5+L
         UJpO0777Y7M6W70VyV5GBH+s7VtVYpkuOdb6rqCbIGRRQwX5BBrDxXoxHihIuSgsDN4i
         S2hpgBWecwaf+U2EQU4t622F9qrurpsHYrmpPAUYKTlFRt+Ll+myvz2UkMAs0qmdvgJZ
         nm8Rn93187gk9bywrI8rr9+TnKXlfK0QrCW3e8NzhDLEJFO1e5WWNaudO2NR8NqjHq+U
         a9A0qvR30IjfdUnPL0q0YRH3I2+/fsGrTk1whJsNNTsGP19fzlu+pvaYiDPhO5xKdvFR
         5PcA==
X-Gm-Message-State: AOJu0YzN3mapUisQFDWQj+rUns8BLF9ghXNeDaDEfL+UWoeXtX6RsC+X
	U75dtuA2j0X5OCHsy3h9/tahK29VDT0solfeOTWhu+FkjzlC4h0UOTM6PWEKHsM9TDmW/7itXFJ
	274iHtoh7jJ7yUmIvGYBqPaBz0+0gG2c=
X-Gm-Gg: AZuq6aJuCcXS1JqZLk9tnRbH0YBTUU3Dj6eCIG820H3g45YKaNKvgU8bHdYkZisygix
	m7UvgYwbeDsrM09ePhqypcTHcn2sp/Soq3tSwgmbKOvwfoiAdooAn22Q6mkVpmxAmh2wcEzZhk5
	/OJR5zjX0cU5TDiN3U5Y+6aankHsxVJtNc7987qcjTo3YMMJGHb5duhRVcbBEw2Pz+dDEQjxppD
	yNfCH8m92jZAh/WzWfp7YaQod7zogqRXF8/XJCTor+pUU3ngjwA5yypS2gB64eIB+UeFYz51Ar4
	8yQpO7Rs+l9vDMgRVy3MVCK1cKkB31YCnne5juEPHK5KLz0oUcL3bYOf13oDlc40bBKnp5yPJ54
	jGTNAPE0h0tQRqg==
X-Received: by 2002:a05:6512:31c6:b0:598:efb0:b81b with SMTP id
 2adb3069b0e04-59e38c11368mr1709192e87.14.1770245423558; Wed, 04 Feb 2026
 14:50:23 -0800 (PST)
MIME-Version: 1.0
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org> <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
In-Reply-To: <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Wed, 4 Feb 2026 23:50:12 +0100
X-Gm-Features: AZwV_Qg4MSTLBf-WevHwuqU0L2m4dSQ_oA-t_fejGtzSWlTyUE9xgzusZMVFWQM
Message-ID: <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de
Content-Type: multipart/alternative; boundary="000000000000a2f280064a076102"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AC5C40005
X-Stat-Signature: sg3uyxquipdr9x76ssdfyoe4wa8i8ppj
X-Rspam-User: 
X-HE-Tag: 1770245425-818685
X-HE-Meta: U2FsdGVkX1/L6pfF+eqRrUs0LfAjb/DZx47n3lNM7U6YqE9gIM0rLYiP/bd8VIGWQ593yjhJ/47jl7jr14GDmhyDgJrkzMqZUfYk7oqHdWPcXmt8wdOiQFEjygvIyjVwrcn3mOUyv8bOQklVmEACOYoXtkR1Yykdsur5mVJAPgjURvAZhJlLfatsm3q5ozEchZWFzyZyYXLCb9+F5ppLz9zAvzrYSvIbvWgDe3FkOdDJPtJ4zdYohA+V8A0AKajPRv6pDSdrSi8o1Wd8JbjaLcIcNkdKo6WJcQxe87NlZqQQKOxtMi6RbkqrQZF1jktBB9jfHCLP1TfUmGM8aTwzM9p3vt3ZDB5S6ToOiKcFOkYPTkbMVKuGVkj/ia7zJYYk7uqpSoFBx4f02583XHiuTlNNEhOEBT6tT1NuNPdgCK+OvU9uxaZSV+yMq7IqITSGQMMawwdJSXxf+Uqk3Rea5enCSA+g4TVxQfYRM2e270k/OP/f1+lXKX+6dz41ifOcERhKHBYVzLihj/AqfbuWvOdF2hvw/wVCL4aPJwkzPa6gjNEAwpFQZHA7skIeTFcJNDSEM3LcpDvCfrZ2/BiG/Eq0zAGXeW3CSkxlZsfePD2lByRcF5yhHsRq+iXBYhbtzl8XzmWXzlZEMMebfdShIGVe3RwJKWXfjzEi3KQSVgJVp1D9L24BNYuI4QyqyrhodcaUHAyZzRI84BE9wnP2eqJ3zR0i+j2wPXnhO+TKnC1E+k7eq4AAm7Q6EReZl698LFI4oBD5e4TH2g+JWraeZTxUrYhzUG/htL2HDmI4EGV30mtO3JGs8/ochUJTgGkz4vcX9Ic1WBpW4NUgd4+aX28P/u0tmzQOiRJLOZOb7B7peFu+wRQrc64zpF/prLqo/qzU44zlVWQVmIwhnWtm06ivi4Hn4x1aNmMjIxf5pGKlMRq9lo2Aot5RQAuk27zyWhOUfyfkxQRysq2T0iM
 i2htAWwF
 DIyJshw5ygYhFrEpCQ4obhRJn0WvBGGiUaAvIxrC1h6Va1GH8CPi26S0tci/2zxxoCoUDrwDZoTo0tGnHdbws2z/mrIR5jJ9Y93Vhz/rJ94/GvPdQCUQjjx0LHtYQ1d7ToTS8vQqMfeoRgRYfO/Tw2JyZPAPKlyZZ15y3uN0+ECMX9KGcEpCs7U3qKM7/4NjpXtP9MRbyRM1SAuGcPWBQqhPOhXlMpix2jFFzBBuihdMMXRHNnQibv/jbEwGxRdu2D9vwqJknf6e/RzCX+WqzABNUWdu993Sa4iY+ct3bXP03hZ0gMQqU8uoww759ctrfzKPb1DoIDVYEabFvy5gW87t92k4MJaSoIbdTYAbGDDPweBWZvyY2wOQC3c+b8eEu15TObeImumCTI1Nrkjd5VLdumEideuPM4PKpA9e9v1GLHmMobGCu8x1phTt0bzCCRI+x//x6vI7t/gmGi7TQwp1hdkIf0jxy9Ty1+X26qsdUtrgZSpxbVxESHyCrrOB+B2VjILkmTgntzojaSvivae7z1qqlCyHsYYYflnQP3vATtvcrQPZVtNhoA5RV+4aqeAMSRNFIr7BGfVDfikXk9xg3KQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000a2f280064a076102
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Just had another crash and it is still happening in 6.18.8 . Here is claude
output this time as i am lazy :)
Let me know what steps should i do next.


Claude:

  Summary (English)

  Crash Type: Kernel Oops - NULL pointer dereference / page fault

  Timeline: February 4, 2026 at 21:42:16

  Environment:
  - Host: pve12 (Proxmox VE)
  - Hardware: AMD EPYC Turin (TURIN2D24G-2L+/500W)
  - Kernel: 6.18.8-pbk (custom build)
  - CPU affected: Core 125 (of 128+ cores)

  Root Cause:
  The kernel encountered a page fault while the qm process (Proxmox QEMU VM
manager, PID 783442) was reading /proc/<pid>/smaps_rollup. The fault
occurred in the walk_pgd_range() function at address ff164aee00000000,
which is an
  invalid/not-present page.

  Call Stack:
  walk_pgd_range() =E2=86=92 __walk_page_range() =E2=86=92 walk_page_vma() =
=E2=86=92
  smap_gather_stats() =E2=86=92 show_smaps_rollup() =E2=86=92 seq_read() =
=E2=86=92 vfs_read()

  Analysis:
  This is a race condition or memory corruption bug in the kernel's page
table walking code. The qm tool was attempting to gather memory statistics
from a VM process when the kernel dereferenced a stale or corrupted page
table entry
   (PTE). The address ff164aee00000000 in R12 suggests a corrupted pointer
that should have pointed to a valid page table structure.

  Potential Causes:
  1. Race condition between VM memory operations and /proc/smaps_rollup
reads
  2. Bug in kernel 6.18.8 page table handling with KVM/VFIO passthrough
  3. Custom kernel patches (-pbk) introducing instability (this is clean
ubuntu config)
  4. Possible memory corruption from VFIO PCI passthrough (mlx5, vfio-pci
modules loaded)

  Recommendations:
  1. Check upstream kernel 6.18.x changelogs for related fixes
  2. Test with vanilla kernel (without -pbk patches) (it happens on
other kernels too)
  3. Monitor for recurrence and check if specific VMs trigger the issue
(no, multiple ones)
  4. Consider enabling kernel debugging (CONFIG_DEBUG_VM) to catch similar
issues earlier




Bash(ssh root@10.10.42.12 "journalctl -b -1 -k --no-pager | grep -A 100
'BUG: unable to handle page fault'")
  =E2=8E=BF  Feb 04 21:42:16 pve12 kernel: BUG: unable to handle page fault=
 for
address: ff164aee00000000
     Feb 04 21:42:16 pve12 kernel: #PF: supervisor read access in kernel
mode
     Feb 04 21:42:16 pve12 kernel: #PF: error_code(0x0000) - not-present
page
     =E2=80=A6 +106 lines (ctrl+o to expand)

=E2=8F=BA Crash Logs

  Feb 04 21:42:16 pve12 kernel: BUG: unable to handle page fault for
address: ff164aee00000000
  Feb 04 21:42:16 pve12 kernel: #PF: supervisor read access in kernel mode
  Feb 04 21:42:16 pve12 kernel: #PF: error_code(0x0000) - not-present page
  Feb 04 21:42:16 pve12 kernel: PGD 4602067 P4D 0
  Feb 04 21:42:16 pve12 kernel: Oops: Oops: 0000 [#1] SMP NOPTI
  Feb 04 21:42:16 pve12 kernel: CPU: 125 UID: 0 PID: 783442 Comm: qm Not
tainted 6.18.8-pbk #1 PREEMPT(voluntary)
  Feb 04 21:42:16 pve12 kernel: Hardware name:
 TURIN2D24G-2L+/500W/TURIN2D24G-2L+/500W, BIOS 10.12 11/14/2024
  Feb 04 21:42:16 pve12 kernel: RIP: 0010:walk_pgd_range+0x6ff/0xbb0
  Feb 04 21:42:16 pve12 kernel: Code: 08 49 39 dd 0f 84 8c 01 00 00 49 89
de 49 8d 9e 00 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff 48 39
f0 49 0f 43 dd <49> f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b 45 c0 41
c7 47 20
  Feb 04 21:42:16 pve12 kernel: RSP: 0018:ff643a4c403439a8 EFLAGS: 00010287
  Feb 04 21:42:16 pve12 kernel: RAX: 000071afc01fffff RBX: 000071afc0200000
RCX: 0000000000000000
  Feb 04 21:42:16 pve12 kernel: RDX: 0000000000000000 RSI: 000071afffffffff
RDI: 80002fd0000002b7
  Feb 04 21:42:16 pve12 kernel: RBP: ff643a4c40343a88 R08: 0000000000000080
R09: 0000000000000000
  Feb 04 21:42:16 pve12 kernel: R10: ffffffffb84588c0 R11: 0000000000000000
R12: ff164aee00000000
  Feb 04 21:42:16 pve12 kernel: R13: 000071b000000000 R14: 000071afc0000000
R15: ff643a4c40343b08
  Feb 04 21:42:16 pve12 kernel: FS:  0000767454f93b80(0000)
GS:ff161c21bdefe000(0000) knlGS:0000000000000000
  Feb 04 21:42:16 pve12 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
  Feb 04 21:42:16 pve12 kernel: CR2: ff164aee00000000 CR3: 00000080dff18005
CR4: 0000000000f71ef0
  Feb 04 21:42:16 pve12 kernel: PKRU: 55555554
  Feb 04 21:42:16 pve12 kernel: Call Trace:
  Feb 04 21:42:16 pve12 kernel:  <TASK>
  Feb 04 21:42:16 pve12 kernel:  __walk_page_range+0x8e/0x220
  Feb 04 21:42:16 pve12 kernel:  walk_page_vma+0x92/0xe0
  Feb 04 21:42:16 pve12 kernel:  smap_gather_stats.part.0+0x8c/0xd0
  Feb 04 21:42:16 pve12 kernel:  show_smaps_rollup+0x258/0x420
  Feb 04 21:42:16 pve12 kernel:  seq_read_iter+0x137/0x4c0
  Feb 04 21:42:16 pve12 kernel:  seq_read+0xf5/0x140
  Feb 04 21:42:16 pve12 kernel:  vfs_read+0xbb/0x350
  Feb 04 21:42:16 pve12 kernel:  ksys_read+0x69/0xf0
  Feb 04 21:42:16 pve12 kernel:  __x64_sys_read+0x19/0x30
  Feb 04 21:42:16 pve12 kernel:  x64_sys_call+0x2180/0x25a0
  Feb 04 21:42:16 pve12 kernel:  do_syscall_64+0x80/0xce0
  Feb 04 21:42:16 pve12 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  Feb 04 21:42:16 pve12 kernel:  </TASK>
  Feb 04 21:42:16 pve12 kernel: Modules linked in: sctp ip6_udp_tunnel
udp_tunnel nf_tables bridge stp llc sunrpc softdog bonding binfmt_misc
nfnetlink_log nls_iso8859_1 intel_rapl_msr amd_atl intel_rapl_common
amd64_edac
  edac_mce_amd snd_pcm snd_timer kvm_amd snd ipmi_ssif soundcore kvm
polyval_clmulni dax_hmem ghash_clmulni_intel cxl_acpi aesni_intel cxl_port
rapl cxl_core pcspkr einj ast acpi_ipmi spd5118 ipmi_si k10temp
ipmi_devintf ccp
  ipmi_msghandler input_leds joydev mac_hid sch_fq_codel msr vhost_net
vhost vhost_iotlb tap vfio_pci vfio_pci_core irqbypass vfio_iommu_type1
vfio iommufd efi_pstore nfnetlink dmi_sysfs autofs4 btrfs blake2b_generic
xor raid6_pq
  mlx5_ib ib_uverbs macsec ib_core cdc_ether mlx5_core usbnet usbkbd mii
mlxfw nvme nvme_core psample igb nvme_keyring i2c_algo_bit nvme_auth dca
tls hkdf i2c_piix4 ahci libahci i2c_smbus hid_generic usbmouse usbhid hid
  Feb 04 21:42:16 pve12 kernel: CR2: ff164aee00000000
  Feb 04 21:42:16 pve12 kernel: ---[ end trace 0000000000000000 ]---
  Feb 04 21:42:16 pve12 kernel: RIP: 0010:walk_pgd_range+0x6ff/0xbb0
  Feb 04 21:42:16 pve12 kernel: note: qm[783442] exited with irqs disabled


--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


=C5=9Br., 4 lut 2026 o 23:24 Tytus Rogalewski <tytanick@gmail.com> napisa=
=C5=82(a):

> Hi,
>
> hugepages is qemu term probably.
>
> Yeah 4k is default and booting is hard with that much memory aspecially i=
f
> you boot , stop and few times.
> But this issue might be strictly related to vfio passthrough mix.
> I did not tested 2mb pages actually because why to use it if i have 1GB ?
> Do you think it could be more stable than 1GB or should it be the same
> logic as 2MB ?
>
> Well. i started to use 1GB ones recently as i had to get through all this
> iommu cpu labirynth with binding proper gpu to proper memory and proper c=
pu
> affinity in kvm. And proxmox ve does not have such logic.
>
> If you tell me what to collect, i can collect it.
>
> I have other symptom actually. Hmm maybe its related or maybe not.
> Still i had this second symptom from the beginning and i did nit had such
> crashes on 4k.
> I am using distributed network storage moosefs and mounting it via fuse.
> Then using qcow2 vm images.
> I am having freezes sometimes in VMs but that might be related to that
> fuse as i mount one fuse share and starting even 8 vms from that one moun=
t.
> And from time to time some vms stop responding or freeze.
> I will soon rewrite it to use NBD istead and that should be fixed if that
> was caused by fuse.
> Still i am not sure actually if thise are separate issues or related and
> which triggers which.
> If there is blocked fuse process by vm A is it possible that vm B might
> throw this walk page bug or it should not be related even if disk slows
> down ?
>
> --
>
> tel. 790 202 300
>
> *Tytus Rogalewski*
>
> Dolina Krzemowa 6A
>
> 83-010 Jagatowo
>
> NIP: 9570976234
>
>
> W dniu =C5=9Br., 4 lut 2026 o 22:52 David Hildenbrand (arm) <david@kernel=
.org>
> napisa=C5=82(a):
>
>> On 1/28/26 15:14, Tytus Rogalewski wrote:
>> > Hello guys,
>> >
>>
>> Hi!
>>
>> > Recently i have reported slab memory leak and it was fixed.
>> >
>> > I am having yet another issue and wondering where to write with it.
>> > Would you be able to tell me if this is the right place or should i
>> send
>> > it to someone else ?
>> > The issue seems also like memory leak.
>> >
>> > It happens on multiple servers (less on 6.18.6, more on 6.19-rc4+).
>> > All servers are doing KVM with vfio GPU PCIE passthrough and it happen=
s
>> > when i am using HUGEPAGE 1GB + qemu
>>
>> Okay, so we'll longterm-pin all guest memory into the iommu.
>>
>> > Basically i am allocating 970GB into hugepages, leaving 37GB to kvm.
>> > In normal operation i have about 20GB free space but when this issue
>> > occurs, all RAM is taken and even when i have added 100GB swap, it was
>> > also consumed.
>>
>> When you say hugepage you mean 1 GiB hugetlb, correct?
>>
>> > It can work for days or week without issue and
>> >
>> > I did not seen that issue when i had hugepages disabled (on normal 2KB
>> > pages allocation in kvm).
>>
>> I assume you meant 4k pages. What about 2 MiB hugetlb?
>>
>> > And i am using hugepages as it is impossible to boot VM with >200GB ra=
m.
>>
>> Oh, really? That's odd.
>>
>> > When that issue happens, process ps hangs and only top shows
>> > something but machine needs to be rebooted due to many zombiee
>> processes.
>> >
>> > *Hardware: *
>> > Motherboard: ASRockRack GENOA2D24G-2L
>> > CPU: 2x AMD EPYC 9654 96-Core Processor
>> > System ram: 1024 GB
>> > GPUs: 8x RTX5090 vfio passthrough
>> >
>> > root@pve14:~# uname -a
>> > *Linux pve14 6.18.6-pbk* #1 SMP PREEMPT_DYNAMIC Mon Jan 19 20:59:46 UT=
C
>> > 2026 x86_64 GNU/Linux
>> >
>> > [171053.341288] *BUG: unable to handle page fault for address*:
>> > ff469ae640000000
>> > [171053.341310] #PF: supervisor read access in kernel mode
>> > [171053.341319] #PF: error_code(0x0000) - not-present page
>> > [171053.341328] PGD 4602067 P4D 0
>> > [171053.341337] *Oops*: Oops: 0000 [#1] SMP NOPTI
>> > [171053.341348] CPU: 16 UID: 0 PID: 3250869 Comm: qm Not tainted
>> 6.18.6-
>> > pbk #1 PREEMPT(voluntary)
>> > [171053.341362] Hardware name:
>>  TURIN2D24G-2L+/500W/TURIN2D24G-2L+/500W,
>> > BIOS 10.20 05/05/2025
>> > [171053.341373] RIP: 0010:*walk_pgd_range*+0x6ff/0xbb0
>> > [171053.341386] Code: 08 49 39 dd 0f 84 8c 01 00 00 49 89 de 49 8d 9e
>> 00
>> > 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff 48 39 f0 49 0f 4=
3
>> > dd <49> f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b 45 c0 41 c7 47 20
>> > [171053.341406] RSP: 0018:ff59d95d70e6b748 EFLAGS: 00010287
>> > [171053.341416] RAX: 00007a22401fffff RBX: 00007a2240200000 RCX:
>> > 0000000000000000
>> > [171053.341425] RDX: 0000000000000000 RSI: 00007a227fffffff RDI:
>> > 800008dfc00002b7
>> > [171053.341435] RBP: ff59d95d70e6b828 R08: 0000000000000080 R09:
>> > 0000000000000000
>> > [171053.341444] R10: ffffffff8de588c0 R11: 0000000000000000 R12:
>> > ff469ae640000000
>> > [171053.341454] R13: 00007a2280000000 R14: 00007a2240000000 R15:
>> > ff59d95d70e6b8a8
>> > [171053.341464] FS:  00007d4e8ec94b80(0000) GS:ff4692876ae7e000(0000)
>> > knlGS:0000000000000000
>> > [171053.341476] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > [171053.341485] CR2: ff469ae640000000 CR3: 0000008241eed006 CR4:
>> > 0000000000f71ef0
>> > [171053.341495] PKRU: 55555554
>> > [171053.341501] Call Trace:
>> > [171053.341508]  <TASK>
>> > [171053.341518]  __walk_page_range+0x8e/0x220
>> > [171053.341529]  ? sysvec_apic_timer_interrupt+0x57/0xc0
>> > [171053.341541]  walk_page_vma+0x92/0xe0
>> > [171053.341551]  smap_gather_stats.part.0+0x8c/0xd0
>> > [171053.341563]  show_smaps_rollup+0x258/0x420
>>
>> Hm, so someone is reading /proc/$PID/smaps_rollup and we stumble
>> somewhere into something unexpected while doing a page table walk.
>>
>> [171053.341288] BUG: unable to handle page fault for address:
>> ff469ae640000000
>> [171053.341310] #PF: supervisor read access in kernel mode
>> [171053.341319] #PF: error_code(0x0000) - not-present page
>> [171053.341328] PGD 4602067 P4D 0
>>
>> There is not a lot of information there :(
>>
>> Did you have other splats/symptoms or was it always that?
>>
>> --
>> Cheers,
>>
>> David
>>
>

--000000000000a2f280064a076102
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Just had another crash and it is still happening in 6=
.18.8=C2=A0. Here is claude output this time as i am lazy :)</div><div>Let =
me know what steps should=C2=A0i do next.</div><div><br></div><div><br></di=
v><div>Claude:<br><br>=C2=A0 Summary (English)<br><br>=C2=A0 Crash Type: Ke=
rnel Oops - NULL pointer dereference / page fault<br><br>=C2=A0 Timeline: F=
ebruary 4, 2026 at 21:42:16<br><br>=C2=A0 Environment:<br>=C2=A0 - Host: pv=
e12 (Proxmox VE)<br>=C2=A0 - Hardware: AMD EPYC Turin (TURIN2D24G-2L+/500W)=
<br>=C2=A0 - Kernel: 6.18.8-pbk (custom build)<br>=C2=A0 - CPU affected: Co=
re 125 (of 128+ cores)<br><br>=C2=A0 Root Cause:<br>=C2=A0 The kernel encou=
ntered a page fault while the qm process (Proxmox QEMU VM manager, PID 7834=
42) was reading /proc/&lt;pid&gt;/smaps_rollup. The fault occurred in the w=
alk_pgd_range() function at address ff164aee00000000, which is an<br>=C2=A0=
 invalid/not-present page.<br><br>=C2=A0 Call Stack:<br>=C2=A0 walk_pgd_ran=
ge() =E2=86=92 __walk_page_range() =E2=86=92 walk_page_vma() =E2=86=92<br>=
=C2=A0 smap_gather_stats() =E2=86=92 show_smaps_rollup() =E2=86=92 seq_read=
() =E2=86=92 vfs_read()<br><br>=C2=A0 Analysis:<br>=C2=A0 This is a race co=
ndition or memory corruption bug in the kernel&#39;s page table walking cod=
e. The qm tool was attempting to gather memory statistics from a VM process=
 when the kernel dereferenced a stale or corrupted page table entry<br>=C2=
=A0 =C2=A0(PTE). The address ff164aee00000000 in R12 suggests a corrupted p=
ointer that should have pointed to a valid page table structure.<br><br>=C2=
=A0 Potential Causes:<br>=C2=A0 1. Race condition between VM memory operati=
ons and /proc/smaps_rollup reads<br>=C2=A0 2. Bug in kernel 6.18.8 page tab=
le handling with KVM/VFIO passthrough<br>=C2=A0 3. Custom kernel patches (-=
pbk) introducing instability (this is clean ubuntu config)<br>=C2=A0 4. Pos=
sible memory corruption from VFIO PCI passthrough (mlx5, vfio-pci modules l=
oaded)<br><br>=C2=A0 Recommendations:<br>=C2=A0 1. Check upstream kernel 6.=
18.x changelogs for related fixes<br>=C2=A0 2. Test with vanilla kernel (wi=
thout -pbk patches) (it happens on other=C2=A0kernels too)<br>=C2=A0 3. Mon=
itor for recurrence and check if specific VMs trigger the issue (no, multip=
le ones)<br>=C2=A0 4. Consider enabling kernel debugging (CONFIG_DEBUG_VM) =
to catch similar issues earlier<br><br><br><br><br>Bash(ssh <a href=3D"mail=
to:root@10.10.42.12">root@10.10.42.12</a> &quot;journalctl -b -1 -k --no-pa=
ger | grep -A 100 &#39;BUG: unable to handle page fault&#39;&quot;)<br>=C2=
=A0 =E2=8E=BF =C2=A0Feb 04 21:42:16 pve12 kernel: BUG: unable to handle pag=
e fault for address: ff164aee00000000<br>=C2=A0 =C2=A0 =C2=A0Feb 04 21:42:1=
6 pve12 kernel: #PF: supervisor read access in kernel mode<br>=C2=A0 =C2=A0=
 =C2=A0Feb 04 21:42:16 pve12 kernel: #PF: error_code(0x0000) - not-present =
page<br>=C2=A0 =C2=A0 =C2=A0=E2=80=A6 +106 lines (ctrl+o to expand)<br><br>=
=E2=8F=BA=C2=A0Crash Logs<br><br>=C2=A0 Feb 04 21:42:16 pve12 kernel: BUG: =
unable to handle page fault for address: ff164aee00000000<br>=C2=A0 Feb 04 =
21:42:16 pve12 kernel: #PF: supervisor read access in kernel mode<br>=C2=A0=
 Feb 04 21:42:16 pve12 kernel: #PF: error_code(0x0000) - not-present page<b=
r>=C2=A0 Feb 04 21:42:16 pve12 kernel: PGD 4602067 P4D 0<br>=C2=A0 Feb 04 2=
1:42:16 pve12 kernel: Oops: Oops: 0000 [#1] SMP NOPTI<br>=C2=A0 Feb 04 21:4=
2:16 pve12 kernel: CPU: 125 UID: 0 PID: 783442 Comm: qm Not tainted 6.18.8-=
pbk #1 PREEMPT(voluntary)<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: Hardware =
name: =C2=A0TURIN2D24G-2L+/500W/TURIN2D24G-2L+/500W, BIOS 10.12 11/14/2024<=
br>=C2=A0 Feb 04 21:42:16 pve12 kernel: RIP: 0010:walk_pgd_range+0x6ff/0xbb=
0<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: Code: 08 49 39 dd 0f 84 8c 01 00 =
00 49 89 de 49 8d 9e 00 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 =
ff 48 39 f0 49 0f 43 dd &lt;49&gt; f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 4=
8 8b 45 c0 41 c7 47 20<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: RSP: 0018:ff=
643a4c403439a8 EFLAGS: 00010287<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: RAX=
: 000071afc01fffff RBX: 000071afc0200000 RCX: 0000000000000000<br>=C2=A0 Fe=
b 04 21:42:16 pve12 kernel: RDX: 0000000000000000 RSI: 000071afffffffff RDI=
: 80002fd0000002b7<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: RBP: ff643a4c403=
43a88 R08: 0000000000000080 R09: 0000000000000000<br>=C2=A0 Feb 04 21:42:16=
 pve12 kernel: R10: ffffffffb84588c0 R11: 0000000000000000 R12: ff164aee000=
00000<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: R13: 000071b000000000 R14: 00=
0071afc0000000 R15: ff643a4c40343b08<br>=C2=A0 Feb 04 21:42:16 pve12 kernel=
: FS: =C2=A00000767454f93b80(0000) GS:ff161c21bdefe000(0000) knlGS:00000000=
00000000<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: CS: =C2=A00010 DS: 0000 ES=
: 0000 CR0: 0000000080050033<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: CR2: f=
f164aee00000000 CR3: 00000080dff18005 CR4: 0000000000f71ef0<br>=C2=A0 Feb 0=
4 21:42:16 pve12 kernel: PKRU: 55555554<br>=C2=A0 Feb 04 21:42:16 pve12 ker=
nel: Call Trace:<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0&lt;TASK&gt;=
<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0__walk_page_range+0x8e/0x220=
<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0walk_page_vma+0x92/0xe0<br>=
=C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0smap_gather_stats.part.0+0x8c/0x=
d0<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0show_smaps_rollup+0x258/0x=
420<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0seq_read_iter+0x137/0x4c0=
<br>=C2=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0seq_read+0xf5/0x140<br>=C2=
=A0 Feb 04 21:42:16 pve12 kernel: =C2=A0vfs_read+0xbb/0x350<br>=C2=A0 Feb 0=
4 21:42:16 pve12 kernel: =C2=A0ksys_read+0x69/0xf0<br>=C2=A0 Feb 04 21:42:1=
6 pve12 kernel: =C2=A0__x64_sys_read+0x19/0x30<br>=C2=A0 Feb 04 21:42:16 pv=
e12 kernel: =C2=A0x64_sys_call+0x2180/0x25a0<br>=C2=A0 Feb 04 21:42:16 pve1=
2 kernel: =C2=A0do_syscall_64+0x80/0xce0<br>=C2=A0 Feb 04 21:42:16 pve12 ke=
rnel: =C2=A0entry_SYSCALL_64_after_hwframe+0x76/0x7e<br>=C2=A0 Feb 04 21:42=
:16 pve12 kernel: =C2=A0&lt;/TASK&gt;<br>=C2=A0 Feb 04 21:42:16 pve12 kerne=
l: Modules linked in: sctp ip6_udp_tunnel udp_tunnel nf_tables bridge stp l=
lc sunrpc softdog bonding binfmt_misc nfnetlink_log nls_iso8859_1 intel_rap=
l_msr amd_atl intel_rapl_common amd64_edac<br>=C2=A0 edac_mce_amd snd_pcm s=
nd_timer kvm_amd snd ipmi_ssif soundcore kvm polyval_clmulni dax_hmem ghash=
_clmulni_intel cxl_acpi aesni_intel cxl_port rapl cxl_core pcspkr einj ast =
acpi_ipmi spd5118 ipmi_si k10temp ipmi_devintf ccp<br>=C2=A0 ipmi_msghandle=
r input_leds joydev mac_hid sch_fq_codel msr vhost_net vhost vhost_iotlb ta=
p vfio_pci vfio_pci_core irqbypass vfio_iommu_type1 vfio iommufd efi_pstore=
 nfnetlink dmi_sysfs autofs4 btrfs blake2b_generic xor raid6_pq<br>=C2=A0 m=
lx5_ib ib_uverbs macsec ib_core cdc_ether mlx5_core usbnet usbkbd mii mlxfw=
 nvme nvme_core psample igb nvme_keyring i2c_algo_bit nvme_auth dca tls hkd=
f i2c_piix4 ahci libahci i2c_smbus hid_generic usbmouse usbhid hid<br>=C2=
=A0 Feb 04 21:42:16 pve12 kernel: CR2: ff164aee00000000<br>=C2=A0 Feb 04 21=
:42:16 pve12 kernel: ---[ end trace 0000000000000000 ]---<br>=C2=A0 Feb 04 =
21:42:16 pve12 kernel: RIP: 0010:walk_pgd_range+0x6ff/0xbb0<br>=C2=A0 Feb 0=
4 21:42:16 pve12 kernel: note: qm[783442] exited with irqs disabled<br><br>=
<br clear=3D"all"></div><div><div dir=3D"ltr" class=3D"gmail_signature" dat=
a-smartmail=3D"gmail_signature"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=
=3D"ltr"><div dir=3D"ltr">







<p style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-fami=
ly:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">--</font></p><p =
style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">tel. 790 202 300</f=
ont></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal;f=
ont-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"color:rgb(68,=
68,68);font-size:x-small">Tytus Rogalewski</b><br></p><p style=3D"font-stre=
tch:normal;font-size:12px;line-height:normal;font-family:&quot;Helvetica Ne=
ue&quot;;margin:0px"><font size=3D"1" color=3D"#999999">Dolina Krzemowa 6A<=
/font></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal=
;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" color=
=3D"#999999">83-010 Jagatowo</font></p><p style=3D"font-stretch:normal;font=
-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot;;margin=
:0px"><font size=3D"1" color=3D"#999999">NIP: 9570976234</font></p></div></=
div></div></div></div></div><br></div><br><div class=3D"gmail_quote gmail_q=
uote_container"><div dir=3D"ltr" class=3D"gmail_attr">=C5=9Br., 4 lut 2026 =
o 23:24=C2=A0Tytus Rogalewski &lt;<a href=3D"mailto:tytanick@gmail.com">tyt=
anick@gmail.com</a>&gt; napisa=C5=82(a):<br></div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,20=
4,204);padding-left:1ex"><div dir=3D"auto">Hi,</div><div dir=3D"auto"><br><=
/div><div dir=3D"auto">hugepages is qemu term probably.</div><div dir=3D"au=
to"><br></div><div dir=3D"auto">Yeah 4k is default and booting is hard with=
 that much memory aspecially if you boot , stop and few times.</div><div di=
r=3D"auto">But this issue might be strictly related to vfio passthrough mix=
.</div><div dir=3D"auto">I did not tested 2mb pages actually because why to=
 use it if i have 1GB ?</div><div dir=3D"auto">Do you think it could be mor=
e stable than 1GB or should it be the same logic as 2MB ?</div><div dir=3D"=
auto"><br></div><div dir=3D"auto">Well. i started to use 1GB ones recently =
as i had to get through all this iommu cpu labirynth with binding proper gp=
u to proper memory and proper cpu affinity in kvm. And proxmox ve does not =
have such logic.</div><div dir=3D"auto"><br></div><div dir=3D"auto">If you =
tell me what to collect, i can collect it.</div><div dir=3D"auto"><br></div=
><div dir=3D"auto">I have other symptom actually. Hmm maybe its related or =
maybe not.</div><div dir=3D"auto">Still i had this second symptom from the =
beginning and i did nit had such crashes on 4k.</div><div dir=3D"auto">I am=
 using distributed network storage moosefs and mounting it via fuse. Then u=
sing qcow2 vm images.</div><div dir=3D"auto">I am having freezes sometimes =
in VMs but that might be related to that fuse as i mount one fuse share and=
 starting even 8 vms from that one mount.</div><div dir=3D"auto">And from t=
ime to time some vms stop responding or freeze.</div><div dir=3D"auto">I wi=
ll soon rewrite it to use NBD istead and that should be fixed if that was c=
aused by fuse.</div><div dir=3D"auto">Still i am not sure actually if thise=
 are separate issues or related and which triggers which.</div><div dir=3D"=
auto">If there is blocked fuse process by vm A is it possible that vm B mig=
ht throw this walk page bug or it should not be related even if disk slows =
down ?</div><div dir=3D"auto"><br clear=3D"all"><div dir=3D"auto"><div dir=
=3D"ltr" class=3D"gmail_signature"><div dir=3D"ltr"><div dir=3D"ltr"><div d=
ir=3D"ltr"><div dir=3D"ltr">







<p style=3D"font-size:12px;line-height:normal;font-family:&quot;Helvetica N=
eue&quot;;margin:0px"><font size=3D"1" style=3D"font-family:&quot;Helvetica=
 Neue&quot;;color:rgb(0,0,0)">--</font></p><p style=3D"font-size:12px;line-=
height:normal;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=
=3D"1" style=3D"font-family:&quot;Helvetica Neue&quot;;color:rgb(0,0,0)">te=
l. 790 202 300</font></p><p style=3D"font-size:12px;line-height:normal;font=
-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"font-size:x-smal=
l;font-family:&quot;Helvetica Neue&quot;;color:rgb(68,68,68)">Tytus Rogalew=
ski</b><br></p><p style=3D"font-size:12px;line-height:normal;font-family:&q=
uot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" style=3D"font-family:=
&quot;Helvetica Neue&quot;;color:rgb(153,153,153)">Dolina Krzemowa 6A</font=
></p><p style=3D"font-size:12px;line-height:normal;font-family:&quot;Helvet=
ica Neue&quot;;margin:0px"><font size=3D"1" style=3D"font-family:&quot;Helv=
etica Neue&quot;;color:rgb(153,153,153)">83-010 Jagatowo</font></p><p style=
=3D"font-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot=
;;margin:0px"><font size=3D"1" style=3D"font-family:&quot;Helvetica Neue&qu=
ot;;color:rgb(153,153,153)">NIP: 9570976234</font></p></div></div></div></d=
iv></div></div></div><div><br></div><div><br><div class=3D"gmail_quote"><di=
v dir=3D"ltr" class=3D"gmail_attr">W dniu =C5=9Br., 4 lut 2026 o 22:52 Davi=
d Hildenbrand (arm) &lt;<a href=3D"mailto:david@kernel.org" target=3D"_blan=
k">david@kernel.org</a>&gt; napisa=C5=82(a):<br></div><blockquote class=3D"=
gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(20=
4,204,204);padding-left:1ex">On 1/28/26 15:14, Tytus Rogalewski wrote:<br>
&gt; Hello guys,<br>
&gt; <br>
<br>
Hi!<br>
<br>
&gt; Recently i have reported slab memory leak and it was fixed.<br>
&gt; <br>
&gt; I am having yet another issue and wondering where to write with it.<br=
>
&gt; Would you be able to tell me if this is the right place or should i se=
nd <br>
&gt; it to someone else ?<br>
&gt; The issue seems also like memory leak.<br>
&gt; <br>
&gt; It happens on multiple servers (less on 6.18.6, more on 6.19-rc4+).<br=
>
&gt; All servers are doing KVM with vfio GPU PCIE passthrough and it happen=
s <br>
&gt; when i am using HUGEPAGE 1GB=C2=A0+ qemu<br>
<br>
Okay, so we&#39;ll longterm-pin all guest memory into the iommu.<br>
<br>
&gt; Basically i am=C2=A0allocating 970GB into hugepages, leaving 37GB to k=
vm.<br>
&gt; In normal operation i have about 20GB free space but when this issue <=
br>
&gt; occurs, all RAM is taken and even when i have added 100GB swap, it was=
 <br>
&gt; also consumed.<br>
<br>
When you say hugepage you mean 1 GiB hugetlb, correct?<br>
<br>
&gt; It can work for days or week without issue and<br>
&gt; <br>
&gt; I did not seen that issue when i had hugepages disabled (on normal 2KB=
 <br>
&gt; pages allocation in kvm).<br>
<br>
I assume you meant 4k pages. What about 2 MiB hugetlb?<br>
<br>
&gt; And i am using hugepages as it is impossible to boot VM with &gt;200GB=
 ram.<br>
<br>
Oh, really? That&#39;s odd.<br>
<br>
&gt; When that issue happens, process ps hangs and only top shows <br>
&gt; something=C2=A0but machine needs to be rebooted due to many zombiee pr=
ocesses.<br>
&gt; <br>
&gt; *Hardware: *<br>
&gt; Motherboard: ASRockRack GENOA2D24G-2L<br>
&gt; CPU: 2x AMD EPYC 9654 96-Core Processor<br>
&gt; System ram: 1024 GB<br>
&gt; GPUs: 8x RTX5090 vfio passthrough<br>
&gt; <br>
&gt; root@pve14:~# uname -a<br>
&gt; *Linux pve14 6.18.6-pbk* #1 SMP PREEMPT_DYNAMIC Mon Jan 19 20:59:46 UT=
C <br>
&gt; 2026 x86_64 GNU/Linux<br>
&gt; <br>
&gt; [171053.341288] *BUG: unable to handle page fault for address*: <br>
&gt; ff469ae640000000<br>
&gt; [171053.341310] #PF: supervisor read access in kernel mode<br>
&gt; [171053.341319] #PF: error_code(0x0000) - not-present page<br>
&gt; [171053.341328] PGD 4602067 P4D 0<br>
&gt; [171053.341337] *Oops*: Oops: 0000 [#1] SMP NOPTI<br>
&gt; [171053.341348] CPU: 16 UID: 0 PID: 3250869 Comm: qm Not tainted 6.18.=
6- <br>
&gt; pbk #1 PREEMPT(voluntary)<br>
&gt; [171053.341362] Hardware name: =C2=A0TURIN2D24G-2L+/500W/TURIN2D24G-2L=
+/500W, <br>
&gt; BIOS 10.20 05/05/2025<br>
&gt; [171053.341373] RIP: 0010:*walk_pgd_range*+0x6ff/0xbb0<br>
&gt; [171053.341386] Code: 08 49 39 dd 0f 84 8c 01 00 00 49 89 de 49 8d 9e =
00 <br>
&gt; 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff 48 39 f0 49 0f 4=
3 <br>
&gt; dd &lt;49&gt; f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b 45 c0 41 c7=
 47 20<br>
&gt; [171053.341406] RSP: 0018:ff59d95d70e6b748 EFLAGS: 00010287<br>
&gt; [171053.341416] RAX: 00007a22401fffff RBX: 00007a2240200000 RCX: <br>
&gt; 0000000000000000<br>
&gt; [171053.341425] RDX: 0000000000000000 RSI: 00007a227fffffff RDI: <br>
&gt; 800008dfc00002b7<br>
&gt; [171053.341435] RBP: ff59d95d70e6b828 R08: 0000000000000080 R09: <br>
&gt; 0000000000000000<br>
&gt; [171053.341444] R10: ffffffff8de588c0 R11: 0000000000000000 R12: <br>
&gt; ff469ae640000000<br>
&gt; [171053.341454] R13: 00007a2280000000 R14: 00007a2240000000 R15: <br>
&gt; ff59d95d70e6b8a8<br>
&gt; [171053.341464] FS: =C2=A000007d4e8ec94b80(0000) GS:ff4692876ae7e000(0=
000) <br>
&gt; knlGS:0000000000000000<br>
&gt; [171053.341476] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 0000000080050033=
<br>
&gt; [171053.341485] CR2: ff469ae640000000 CR3: 0000008241eed006 CR4: <br>
&gt; 0000000000f71ef0<br>
&gt; [171053.341495] PKRU: 55555554<br>
&gt; [171053.341501] Call Trace:<br>
&gt; [171053.341508] =C2=A0&lt;TASK&gt;<br>
&gt; [171053.341518] =C2=A0__walk_page_range+0x8e/0x220<br>
&gt; [171053.341529] =C2=A0? sysvec_apic_timer_interrupt+0x57/0xc0<br>
&gt; [171053.341541] =C2=A0walk_page_vma+0x92/0xe0<br>
&gt; [171053.341551] =C2=A0smap_gather_stats.part.0+0x8c/0xd0<br>
&gt; [171053.341563] =C2=A0show_smaps_rollup+0x258/0x420<br>
<br>
Hm, so someone is reading /proc/$PID/smaps_rollup and we stumble <br>
somewhere into something unexpected while doing a page table walk.<br>
<br>
[171053.341288] BUG: unable to handle page fault for address: <br>
ff469ae640000000<br>
[171053.341310] #PF: supervisor read access in kernel mode<br>
[171053.341319] #PF: error_code(0x0000) - not-present page<br>
[171053.341328] PGD 4602067 P4D 0<br>
<br>
There is not a lot of information there :(<br>
<br>
Did you have other splats/symptoms or was it always that?<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div></div>
</blockquote></div>

--000000000000a2f280064a076102--

