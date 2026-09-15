Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50C8C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 18:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93CE76B0088; Tue, 15 Sep 2026 14:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE9E6B008C; Tue, 15 Sep 2026 14:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC246B0092; Tue, 15 Sep 2026 14:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 563886B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:23:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DC711404EF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:23:47 +0000 (UTC)
X-FDA: 85216820094.15.A5E4D22
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42E9D14000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:23:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WAflwDpE;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789496625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rssnQIdYryZ5dCEXCBYmfezXeqT2y3ieJZn8XMJig4=;
	b=CZ+ZR0pqSGFiFRDuUtcccaA1GiP5r+M9LP6ttd/YkBAwGOBVReibQP0wHSlPq7C3PzgG8s
	ATpj3a+DlyvzgrafVu1jELs6g/NLz3TAWpvuepZbwsZe9V2cbn9qfzmWibJh0izVhAwNj0
	ytnIfyJC0JpnVttlbrr1KXYEoRfZhhw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789496625;
	b=KWLJgy5RVyhHqiPAXLoOFp9N8YmWAJFIQtxHfKLTSBn5hTnpczwDmhTo8Raw4QP1XI+Idj
	eWCSIvCV4pC4LGnV6/7gpZ3PWxmO0pnbs4bKBGUJbqWVk6sr2HtVk+0dgpHi+BHvLPVE6r
	BYFQJsy2OH0+xRUlAhBWYWzHwo8aISs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WAflwDpE;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so38221cf.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:23:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789496624; cv=none;
        d=google.com; s=arc-20260327;
        b=LSHgZEJohIx24xQ3IjOJu3dQlcr1VAtfR0V6AHEUSG+ZJhiFy6nZvM2YqyMFZl8xza
         AaGiXAqIdQYL0unW1kiRPD2HQWJ+XPfW1PClnVLnbQQzdEocGWkFVzUTyp/QIlJQqJag
         VDZ+5wdAvqolP96EyOHKXSi6XUwYu/msTvte5ayQ6ntX+9x53Mcd5kmsERBEBkQwm1qC
         jq4vymrYSc4jA1YE9b73IhcqR1GwAamz4NVSEPCeEjolfElgjqlRU9HPJbSAZCYieqgQ
         jFPQnVY5jZ38ZopFpC4mduyqlwW2GMD33w7VdUEHLx2z40Fl8acxmnrggSTKkqH5cNuL
         F7tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2rssnQIdYryZ5dCEXCBYmfezXeqT2y3ieJZn8XMJig4=;
        fh=BEjiqcwtADhzUQoI7qA7s0zfxuKim57OImBI6FAjxJA=;
        b=PLsSDPeepRKNqQEUGrZ4ax1nNAjMBiIG0vrLqYHVGOaFRHU+v0YR+dWjyTgT1cfD47
         8GQMnvWdz20gUyLFofEHFyhFxVvUXQfw3r/bZ735eYXV4QIOld0EMvXyzyYOdzRn5B8T
         nerbY+xl7Z+suWofX7Ectzckzfmt44+A2I3AR9JScj2qGZfPNYESrJN+nZC9EOBAEs1q
         eOIn6MhgcDccoQfGzPbFcfuubV4QPDfnIwRqf0YvvEhHRLDTVSWHxOIeex2o2C5n/SCu
         eXpA+AFSuznQQw4Kj7BLRIbgviOHJCKGXCEOJeZHlGb1B/iAYEmzKQO8VmbXnCNnXzbm
         sgyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789496624; x=1790101424; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2rssnQIdYryZ5dCEXCBYmfezXeqT2y3ieJZn8XMJig4=;
        b=WAflwDpEh0G2ak7nblKfzqcYGbb7Umw7UHPQ3F9xqFQIJNHmcmeHzJApPbuiu4zAec
         uzsiyJYDKE8XrCNKch86gxzRzDp2yKLSpuCwWobCzdvJWL+HJhoLgM9Vadg09tUVUvU+
         kqWHXQ9LJGTWNayN/5ix2bQOqKhCEv5smOdx9HRtnZk9fOJcGcZs+xG2TeDtvZEyRcsJ
         JMldqA91NV8YrrrdahX9NFIEEIHt79PMHrL9o+MK5JVhAeMmwr7Cdyqso4ltAfI5If6Y
         Tmlav3mQ2UIdQtSY5c64YYQIiHrdUnSpNYRA3EiVwQf4DubFeViE68QiVn7iau4vUW0k
         nRsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789496624; x=1790101424;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2rssnQIdYryZ5dCEXCBYmfezXeqT2y3ieJZn8XMJig4=;
        b=f0c1FJc2nOevPDNd8h+71sBHL6LXaWimW30VADTmO3GMXahgr4Z7kGrwZo0/5h/fcy
         UzK8Qq/m4FjP1zQrfQgTjlaT1bsj18w8kEwgbcSgtcXm/3p7G2iunkM3SaHAC/FkaEdW
         iKrWyjADt1++hT5dZFY+oGmaAmuuU7bzu/jyph3WU6SexCBQjNH9drUg6J5ZvJR5mXPX
         lOUkCN+6szRGxmadQ+FoT6jGB1Z6zUmwshQKhyOn6+X8eEbtZZSFIY0IONSkvYmsfaxr
         MmHhZpEJ1ZcXLWUIpDCeLP66zphk1SP/afEB23CJg9T8v0HDHELSfvcHbeCvtNtiXkVy
         0G9Q==
X-Forwarded-Encrypted: i=1; AKwUvByX+rj+cHXIOdpOumQriyglM6kZOmTEgcSRsegBuQxC2Fvlnf8kMGXwsetgMB+eDfkxYSk0IJ6Cyg==@kvack.org
X-Gm-Message-State: AFuF++mJ6XaKqjun15VCBjVAI3E/lWk5BCdwmkiilfGPvASrtwoUkyt0
	BUEAK/h0g1OVGgKI878kpSLOUWonVWhuHi6RoMx4IgXHdNPJ3Y3qd+DrPUZwDg+7r1Zf6QbhTjr
	fTATEokQ4cH8IOGUkwq5qU5EPGPhkr+5NKMRhH+WD
X-Gm-Gg: AYBFou0K+AC2xdyQNFQDHZWgSYqh7Xu3KhKbWoJWA7slzldQaMKt0/l4Vne/4H4ejvU
	P1fdKRjMCUVMT4y6UJQPYuI918Z2ewceJvLJ1QHNQBT/GgUlGdD5zhssAZicWN4isgAecePI1xu
	NKKNA0zxyH4/c/D/mvzfZ1AvItsqkKFcGPjl1pEeXyAqCLVc+MX1S7mAGCPD5X+nrGQ+974jjHT
	a/+f2FKvp9YZ7LxmqBW6009dLCEOkMRj33j5iUgsU9FwRit5tTRN1wDLb0eXF1gK/zmQz1H9YeV
	EOeW2KOFRJedUMqD+4+KiHo8ENHrw1eObi8lytwNf6LWrjrPeggO8qz+1jAPcSyO+LynHG7ohIv
	XYtZDqPK2Vw==
X-Received: by 2002:a05:622a:1e0a:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-53259a908fbmr904071cf.1.1789496623375; Tue, 15 Sep 2026
 11:23:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev>
In-Reply-To: <20260915070001.113559-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 15 Sep 2026 11:23:32 -0700
X-Gm-Features: AcwNN1VCvcBTjNHTTeUHVRptD9lm4JQ38a2UaA1WJQc0tRf_bIU32vhrmnbsOaQ
Message-ID: <CAJuCfpE3z69Dqn_HoBz_XX+_hQMXeuqA04o4t=xQLaWFHmwqPQ@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] alloc_tag and module codetag section fixes
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: h8cdsdrjjzfyymu8edoj5ufce5yetp9g
X-Rspamd-Queue-Id: 42E9D14000B
X-HE-Tag: 1789496625-854295
X-HE-Meta: U2FsdGVkX1+ZG9eTOwgw0LBtH/2uwXL9Ksf7bqQhdQ3sisLzeptSSvbBTuTV1Tt+OOqcijpdZFfbKyw204DpGFiDCMGeYKiHO+gcQ/azuNq9FUIKPKWnhHcykA7Ded6EWcEjhdTgnX+UwVSf0lkE3DsHudSnh1LhLSUiNphTzLFE0NTG/ZraDXu/bJHKeyaq4jkkscl4rTxUiDBecjLmLTpsWDHUziaXxQ1HLEU7YzPR1fImHlZQREcd0TT8j072yP09mOr1QdjrjskoWWR6Y3Wy0f+m51nfJ5QEijvdQogzYmqfvJhg5NlIxNIIuAJOAmq9qTKCS/ejn+yM53kRtIYS1eyzX5JdA1dGegR1pqJK4z9Og6uCPBwxD4BCFKhGcgwnvB1SXCadorxV2XJEzDBC4d0CGLwkuLIqXyJdO9KMzWYGqoPDPG6EmOcL0LsC86v5H+ISaBJQs0h45FFl0Qg+Ii8XRb7SVNYIKsN2AiMZe7X9WD+mnw3pxY3cUtrCDW3ojgriiR+9b2rNrG+6sAQLWFH4C270cSK/zFm7sjPkxW25jrUChH/67JpHUnzzA+MSsz+9cfBbnPyNNZ5ldcCerELpb5EQV7GEi+fmmK46vUp7/JDF+EMxxS2gHOFvhjcSinv4N0JPE+V9ZPx5xxOEATyHLGodLHbK4dGd1H31GeTOk8g3arzCVcro7FNV4HsUFKM59gyhZrHFibGo+wWdF9oPt1CoxrTJqEEgKH1IezyHUjNcasd+pjjFTVgGLndGzsbKdMUxE47wHIHMYUYhn/LhwaGxtGNaZRRQdhUcHQIHFTkaEZh2lW2lC92sZuqhN7qrBxch8GK/1A4monlActzXy7/HXx8k7mQ6pfiHJgu1oICjNmmSoSjevnQWjTyqAlJXwvFswO36ckwZ5PN5JKeqjUEz9O8E/5l2kWAW0et/+D7kyv9wmTvJ3HB1zUxVrw90e5xAg2iPSCK
 Te4LyIyw
 Ue97Jf8NKgleRbRm7I/LKozWf+x6EQd1vPW2XLyA9AzoeFpuVkWUyxmtU6grulGUpgxWOdBLBRnGbpTn3BljQ6FcCVuGLXAM/FIdTgv/y47/aGP238X56Gm5G7pRKsyQW5mbh6FE+FPkfWrDjDtGYh9v5T/Ep68At0nysFeGsK9Q8Xq3AsQUbaElbkxc1fo65oURLRNg2a4Pf3sRUi33YIqzfDjnc/QfoS0YyTCgHD5iu8qnMVwaxH9edIp1jXc0JhHLwkOeYlumxdAPEnxqYWXyHq+51aMpqmiNAXubt0AX1k0L+R7hE5lnWU/9/iaWp2r4z+AUnQtE3QwBmfFk071iOAhxDowDBhsu0HV+9MMu5kvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> With profiling toggled off, the overflow check in
> reserve_module_tags() did not run, a module could load with more
> tags than the page flags can address, and re-enabling profiling
> then silently corrupted /proc/allocinfo. On overflow the fix shuts
> profiling down, releases the reservation and returns -EAGAIN, and
> the codetag section lands as regular module data in the same load,
> so the module loads without profiling.
>
> Review of the earlier series by Sashiko turned up two more problems.
>
> One is a race. layout_sections() and move_module() both asked
> codetag_needs_module_section() where a codetag section goes, and
> mem_profiling_support can change between the two calls, for instance
> when another module load overflows the tag index and shuts profiling
> down. move_module() then copied the codetag section to offset 0 of
> its regular destination and clobbered the first section placed in
> that region.
>
> v7 reworks where codetag sections are allocated, on a prototype by
> Petr Pavlu [1]. The allocation runs before layout_sections() and the
> placement is decided in one step, so nothing re-asks the question
> and the race is gone. The retry is gone too, on -EAGAIN the section
> is laid out as regular module data right in the same load.
>
> [1] https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse=
.com/
>
> Following review feedback from Petr and Suren the series is now
> split into six patches. The two alloc_tag fixes from [2] are folded
> in as patches 5 and 6 and replace the versions currently in the mm
> tree. Sashiko keeps flagging the percpu counter leak [3], patch 5
> fixes it, and now the whole set goes through review again.
>
> [2] https://lore.kernel.org/all/20260817062726.106511-1-hao.ge@linux.dev/
> [3] https://lore.kernel.org/all/20260908094736.2B1A61F00A3A@smtp.kernel.o=
rg/
>
> Patch 1 moves release_module_tags() above reserve_module_tags(),
> since the failure paths now have to call it.
>
> Patch 2 cleans up the populate failure path: the reservation is
> released, module_tags.size rolled back and the PTEs a failed
> vmap_pages_range() left behind unmapped, so a later populate of the
> same range is safe. It carries both Fixes tags so it backports
> wherever patch 4 goes, which uses its prev_size.
>
> Patch 3 introduces SH_ENTSIZE_STANDALONE to mark sections with a
> separate allocation. The percpu section was previously excluded
> from the layout by clearing its SHF_ALLOC, which per the ELF spec
> says the section occupies memory during execution, and percpu does,
> only outside the regular module layout. The mark lives in sh_entsize
> now, find_sec(".data..percpu") gives stable results again and
> apply_relocations() goes back to testing only SHF_ALLOC. The
> section would show up under /sys/module/*/sections/, but it has one
> instance per CPU and no single address, and the entry never
> existed, so add_sect_attrs() and add_notes_attrs() skip it.
>
> Patch 4 moves the codetag allocation out of move_module() in front
> of layout_sections(), so the placement is decided in one step and
> the race is gone. On overflow profiling is shut down, the
> reservation released, module_tags.size rolled back and -EAGAIN
> returned, the section is laid out as regular module data and the
> module loads without profiling instead of failing. Any other error
> fails the load. The release and the fallback belong together,
> without the release rmmod hits the stale entry and panics.
>
> Patch 5 skips the percpu counter allocation when profiling is off.
> After the shutdown modules load their codetag section as regular
> data, load_module() still allocated counters for every tag and
> release_module_tags() cannot find them on unload, so they leaked
> (Suggested by Suren).
>
> Patch 6 defers the /proc/allocinfo removal to a workqueue.
> shutdown_mem_profiling() runs under mod_lock, and the synchronous
> remove_proc_entry() deadlocks with a reader taking mod_lock for
> read in allocinfo_start(). The file is also created at the end of
> alloc_tag_init(), a leftover file after a failed init would panic
> its readers (Found by Sashiko).
>
> Tested on an x86_64 virtual machine:
>
> Booted without sysctl.vm.mem_profiling=3D1,compressed:
> # cat /proc/allocinfo is fine
>
> Booted with sysctl.vm.mem_profiling=3D1,compressed:
> # cat /proc/allocinfo is fine
> # insmod overflow_tag.ko
> # dmesg
>   With module overflow_tag there are too many tags to fit in 13 page
>   flag bits. Memory allocation profiling is disabled!

Do you have your overflow_tag module posted anywhere in public (github perh=
aps?)

> # rmmod overflow_tag
> The module loads without profiling and unloads cleanly.
>
> Also ran continuous LTP stress for a few days, nothing abnormal
> so far.
>
> Changes in v10:
> - fold in the two alloc_tag fixes from [2] as patches 5 and 6, they
>   replace the versions in the mm tree and fix the percpu leak
>   Sashiko keeps flagging [3]
> - create /proc/allocinfo at the end of alloc_tag_init(), a
>   leftover file after a failed init would panic its readers
>   (Found by Sashiko)
> - count note sections with sect_visible() in add_notes_attrs() too,
>   the count has to match the fill loop
>
> Changes in v9:
> - do not export .data..percpu under /sys/module/*/sections/ (Petr
>   Pavlu).
> - move the populate failure cleanup in front of the rework, v8 patch
>   4 is patch 2 now. It declares prev_size itself, which the overflow
>   path of the rework also uses, so it carries both Fixes tags and the
>   two patches backport together
>
> Changes in v8:
> - roll back module_tags.size when the reservation is released, so a
>   concurrent load which already passed needs_section_mem() does not
>   skip populate for the freed gap (Sashiko)
> - unmap the PTEs a failed vmap_pages_range() installed, a retry to
>   populate the same range would BUG on them
> - zero the separately allocated codetag memory for an SHT_NOBITS
>   section, the tag area pages are not zeroed on allocation (Sashiko)
> - .data..percpu is exported under /sys/module/*/sections/ with the
>   boot CPU instance of the per-cpu area, and the interface is
>   documented in the ABI docs (Petr Pavlu)
> - keep a comment in apply_relocations() on how .data..percpu is
>   relocated (Petr Pavlu)
> - replace the "Based-on-a-patch-by:" tag with an in-body
>   attribution and a numbered Link: (Andrew Morton)
>
> Changes in v7:
> - split the rework following review feedback (Petr Pavlu, Suren
>   Baghdasaryan)
> - new patch 2 marks separately allocated sections with
>   SH_ENTSIZE_STANDALONE instead of clearing SHF_ALLOC
>   (suggested by Petr Pavlu)
> - split the populate failure release into its own patch (suggested
>   by Suren Baghdasaryan)
>
> Changes in v6:
> - rework on Petr's prototype and allocate codetag sections before
>   layout_sections(), the retry and its state resets are gone
> - fix the layout_sections()/move_module() race (Found by Sashiko)
> - release the reservation on populate failure as well (Found by
>   Sashiko)
> - only -EAGAIN keeps the fallback, other errors fail the load
>
> Changes in v5:
> - add Fixes: and Cc: stable to patch 1/2 as well, since 2/2 does not
>   compile without it (Andrew Morton)
> - restore frob-adjusted mem[type].size on retry instead of zeroing,
>   as s390 and parisc add GOT/PLT space there in
>   module_frob_arch_sections() (Reported by Sashiko)
> - drop the load_module() mem_profiling_support check; the percpu
>   counter leak is pre-existing and orthogonal to this fix
>
> Changes in v4:
> - add a new patch (1/2) to move release_module_tags() above
>   reserve_module_tags(); the overflow fix is 2/2
> - release the reservation on the -EAGAIN path
> - return -EAGAIN instead of -ENOMEM so the module can still load
>   without profiling (Suren)
> - reset sh_addr, mem[type].size and sym/str SHF_ALLOC before retry
> - skip percpu counters in load_module() when profiling is off
>
> Changes in v3:
> - use pr_warn_once() instead of pr_warn()
> - return -ENOMEM instead of -ENOSPC (Suren)
> - expand the commit message to describe the /proc/allocinfo impact
>   (Andrew)
>
> Changes in v2:
> - return an error after shutdown_mem_profiling() to skip
>   vm_module_tags_populate()
>
> v1: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@linux.dev/
> v2: https://lore.kernel.org/all/20260804122038.190270-1-hao.ge@linux.dev/
> v3: https://lore.kernel.org/all/20260805090633.141001-1-hao.ge@linux.dev/
> v4: https://lore.kernel.org/all/20260810093955.153015-1-hao.ge@linux.dev/
> v5: https://lore.kernel.org/all/20260812054105.102637-1-hao.ge@linux.dev/
> v6: https://lore.kernel.org/all/20260831072104.120197-1-hao.ge@linux.dev/
> v7: https://lore.kernel.org/all/20260902081802.146145-1-hao.ge@linux.dev/
> v8: https://lore.kernel.org/all/20260907062414.106873-1-hao.ge@linux.dev/
> v9: https://lore.kernel.org/all/20260908092412.115953-1-hao.ge@linux.dev/
>
> Hao Ge (6):
>   alloc_tag: move release_module_tags() above reserve_module_tags()
>   alloc_tag: clean up the populate failure path
>   module: introduce SH_ENTSIZE_STANDALONE for separately allocated
>     sections
>   module: allocate codetag sections before the regular module layout
>   alloc_tag: skip percpu counter allocation when profiling is disabled
>   alloc_tag: Defer /proc/allocinfo removal to a workqueue
>
>  include/linux/module.h   |   2 +
>  kernel/module/internal.h |   8 +++
>  kernel/module/kallsyms.c |  13 +---
>  kernel/module/main.c     | 133 +++++++++++++++++++-----------------
>  kernel/module/sysfs.c    |  17 +++--
>  lib/codetag.c            |  10 ++-
>  mm/alloc_tag.c           | 141 +++++++++++++++++++++++----------------
>  7 files changed, 188 insertions(+), 136 deletions(-)
>
> --
> 2.25.1
>

