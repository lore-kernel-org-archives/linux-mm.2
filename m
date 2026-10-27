Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0785B606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=YwabFMcl
Received: by kanga.kvack.org (Postfix)
	id 8E8D96B0841; Tue, 27 Oct 2026 12:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872426B0843; Tue, 27 Oct 2026 12:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECEF6B0844; Tue, 27 Oct 2026 12:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 471AF6B0841
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:37:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9ED2A86FE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:37:11 +0000 (UTC)
X-FDA: 85368961062.01.B3B13A3
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id B8CC94000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:37:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=YwabFMcl;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793119029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+X+xT+MsVt3lGpJbnEZ9ySkDtUCJMEXiKO19vcrDGU0=;
	b=O2VjLCtgHxVVvoBFGHsv4cf2JbeEAE5m319dzWoNEXf3ldwROLtURKKXajnlt/5cB4ik/N
	WSsP1UlyBOa50/u1Lsa2zPSkFTnqh2CgQ3BS6jCJ0m3DedB/DK5LvMf/OjgyiOVJFLh+sc
	3bDaQi2ihm4daNtU0VwJo26IGmYYSoE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=YwabFMcl;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793119029;
	b=ljfnz5BFL3BCxTqMlBxI+mCbOJnBHqRjd2Cmgno2VqZLOPRVbAXtBYYEXQKXWSD8M31/GQ
	lmMPTjcKWASAGKHhTYYFCR+Q3FP0asrx5vnrVJn6D8IGBGR51/KVtiquiaOWVuZwvwJj+0
	gbOXPGPIu75aaSGom7wbMa8BOTnHjiU=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc7e79c1eaaso74195a12.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793119029; x=1793723829; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+X+xT+MsVt3lGpJbnEZ9ySkDtUCJMEXiKO19vcrDGU0=;
        b=YwabFMclNxl9uDM6DVqZYfGLurkpQKL8nHkE8hw6lRMB6wCUvi08W8LSkSG0mo1O9p
         hrEj3ZALErfRhaM/QrJfzp4sDAacfrvRpNPejKZX4QaPi7vRxI1gQfGJGOKXEWV9fa15
         hphmFY/jQBK4W8PYmwrmnzBYAtnFsUx0MpcYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119029; x=1793723829;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+X+xT+MsVt3lGpJbnEZ9ySkDtUCJMEXiKO19vcrDGU0=;
        b=AYMOBEqcjk1anyhl6GcIp7JdO9TDSUiBnp46Uu4qTN4kQCpGk58r5r61TngQWHKDqs
         jhndft7k4LSpyBeFrGDzjin5/L5G2NoQjk25qeW+oakGXFLorLKaQD+DSM6+cx/RkhPE
         waUIwJQWKlV97v2ek/FfLNbr0vyfABD2q3+msI2BvAEfyHwkRcrK3ekLRXB7chN7mKJF
         9o8qJMudGa0n0SnCsck06g5fJsMVMpjRx5Ns7dZzpBdESPCM3t2mAGZ5hwH0MTZEglpG
         eUxwKfGK/MywgGZ0Q2+F2eXwS0fQ7N/Jd8Rur3PCGchtRvGhU2Aw9DWDWl59ZzJIYMnD
         6jVw==
X-Forwarded-Encrypted: i=1; AKwUvBzulzWA3SxyE/5zLU3vrL4PG5G2uDv0OSCX2fSQpyM+2ZvEoi1djTR1TlHvVM0r0c2UBOB6zXpF9Q==@kvack.org
X-Gm-Message-State: AFq9FYKSuiybvli3ISr4SOKKqt2YI3xFmiBrGZqVOhgXazlPUbkCzhsk
	zSJAweWJU5dZtM60rp4l88Ax7c5hukf2GWISLO6+OC5NfutKkbmDKCx+/PJ7jmWALRI=
X-Gm-Gg: AYBFou1kdq/BVvJTBZWoFbsCvYUILulrzLaqWgBMkDPIW0r80uUpIlEKuHi3eaCbSPG
	27KNqRW9FZUTUSnyRSuUKI0A4H6cXqyG1iEsdaazrgPCjf/jo7NACBnK/32mG/sJ8lhUtDJ/ZHH
	nxn9Vi5ft78a6Vfijp12jnp63FvHF1pLGh5G1dndXjqb8fAQBIFzYrPSoEAy3yq+PUzfIbYZu8M
	f/BNUm6E5MQhD816Y5PxlMUD1O1AK0GUTuOMqIIj3ccfsHffljGJbBllFGdZ3DtA4D8m1gyDKpP
	J5JUaPV+/P+CSySvVu6qLx/E81/ofRluDT3d1+iQqLWvkKhpt/q80fRfbAjoz08e0EDJqKqf2Qa
	s3svJ2i6scYo4rrJE0TFQ21flVPfb3Qr4X+6hJGC95JU6IEmVMOu82NthDf6joef7K77m5xYJs2
	8VlqdW7ViG5rTW2azDrvmksiOjCHrabgQbN424W41Ox2GS5Dy3p2X91gEF2b0L3gAZSri/crbJR
	qfhdUBBcQ5vkRcOeXTt1c7yHn+UNViYnY9MsiyEUNq704IM+JTTwjx5hUtCaG7WEB5IxknJmUhM
	OTWikuNMi07GGVtkHEV6htyXjx/dwA0FI7PmVIdNJsmnRrxjePJ5Km4Jqgezs4/0A9APhSLTb0a
	4Wamxp4ZXjOmC1mQxLcJ2vrEgLJIJ06avjs3CNYgu364m0L86tuouiS73Wrti9re4C+qb1PLm
X-Received: by 2002:a17:90b:4a4f:b0:3ad:4a8b:c6fd with SMTP id 98e67ed59e1d1-3adeabe5366mr7820847a91.28.1793119028562;
        Tue, 27 Oct 2026 09:37:08 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae55d63b7csm11729a91.3.2026.10.27.09.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:37:07 -0700 (PDT)
Date: Wed, 28 Oct 2026 00:37:05 +0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>, Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/3] mseal sysmap: Add mseal_system_mappings= boot
 parameter
Message-ID: <auDTMb6WMFUpxeZy@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name>
 <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
 <auCxjbvY3qPv1sV6@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <auCxjbvY3qPv1sV6@gremlin>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8CC94000E
X-Stat-Signature: gndj5jhcucqmr3dpjfdx4xmnpk3ddrws
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793119029-28147
X-HE-Meta: U2FsdGVkX1/6QPs/AAxSFj3ZMNJkfDk6Y+2vE0n7CnmT9u8/EuFyRMhavA/s8WU9UWqhAxxuzDESb8B8g5j9tCt2l4pZTPE41AxGLCj1gocNp7NWJIYUwnWzvphnxtMtmQIfxhnbzlqD0fwyDQNQ/kz6Y5mlYwqoHJRcN2ptU45uPQAE4qrFBG9rqMJ4Nx3zHO4/e/NvdLHgm3Wfb+Wjgzl076Kh1mbvqXsESPEMpkBePor5HUPKzNmY34Z5vDExgyaHktAIS8Lm+vPz26qqSfQeh5CbIUzOxTvNsBcZJ10B4p0LmYqDVhCGzBGi/yM4sTj1vRr8KJByALQnMvllk5sYw5W63pXvjX8WA+jkrXs9kolvrx1/QNqJ/fW/U5o3qCemYVoNH/4tbMyNBt2nZVk1O54ABrVW3MzfJx8gekzM37Odwk01iyRKu4s59UN6zgZGcZSQiVObIZzq2AlVYPsM+zJy9uOIrlchQZs+599o05yxPoNxK3I3QlsjbQM45Vroyx9szOwrlU2PI3MuQlheQOijH35qHHBhJnfa3oi2V/0bWbb99Dbt+GTmv+Z457uwzsHQ2FxdqHti9rUDVB1jlUCJkYaMiNyzfSNbxEwuYIiIDsmqEhvtqHYBNP3UtFLYdfJb9/FJ84CBzA2t9rCL43JOzdfXJkTdH0kNQSTUgRXxWgOJobISRtGX5k1BiM9Nzste4LzI54h0eblE1GGCwEP+afMS1/QufLKcAHwoOyB9vgqwD2yCZCuWYYY19k4Kb2fBmpmcbtblrxgAh6jy6vS2iXdroVT0+Lwk3ehP1DDkm8KE5wog15RqKh6i2fFc+YLxtfODo53XCrJmLrkW5GmJLO085yLqgzU96cjg+Z2uoPpUoa4vcI77+WDWUG0zE1/7+rJthUairNPNLTh8fDpcL6z7//9mI6dYsc9+SPvK0SWLctjj5zjWJkmXKL97iTNKK+huu4kAeJy
 CViU/ZbH
 k01WB7MFEaIu+VdT7Od/MOBUzcGSW2I8A8efb24J8GQNZBsVxrhAD73RSP/N3o3lJtiZm2kU8Bn9TG0icnR/uA7vKZtfN8U9XNDuB4cO+QahtsLZEPSOhl7KNxlswrTN4/SyLQdZL2OlfVoCEMLEiGvDhtO5ViWeE8V/PdmHJzdkqetVZm+3rp5eU+HQadqMyxcnbpA7aIPUp0MJsqrJ7Yc0+L0t13iMLDdcHzE2qft5aLKNW9XukyIIgUDvZU2X4+qUhuZ1hwq0uILI+hMLjZ20PyVD91oKBLs8pWK+CMMrwvAZBvhzbhnKJd/YS7vKOYqOI//OiCLmlU6BASW7YApPvDIViyj8ybplbr3a2nrUawNAvHL9UxbBdMhM/WAFuWQdmq+8rr1Vc55i0/HLuc1FxZRP25Zl6OIMFgf9d2nlXXx8++qboDh9allRLVAN0gRaCyGtESbJ6eHH5FRVSuykFJMfiQck3kkKVoMFLo0Fn6fPRJskHd4hNUvK5mmSTNLbGVBNpqjKNiB+Mmq0UYELeqiP2kJ8dOjCSHu1GwVsLfIA/MWUqpHkO9njFbXrrahRyuoS9k95diIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Thanks for the quick and thorough review!

Lorenzo Stoakes (ARM) writes:
>The existing implementation is a bit of a mess, so any work that extends it
>has to put in the work to improve things first.
>
>I _hate_ VM_SEALED_SYSMAP. It's a hack. A tasteful way of doing this is
>really required for a series touching this to be taken, honestly.
>
>See below for implementation ideas.

That's fair, I'll do the cleanup first in v2.

>(Also it's the merge window, so no more revisions until -rc1, when you need
>to resend, thanks.)

Sure, I'll wait until after -rc1.

>Could we have some actual justification for the use of the feature please?
>So far I've seen arm-waving.

Sure. At Meta, we build sealing into the kernel for our VM hosts, and we'd like 
it on as much of the rest of the fleet as possible. The problem is that the 
rest of the fleet also runs things which it breaks. Just as one example among 
many, Reverie (which Hermit our deterministic execution tool is built on) 
patches the vDSO of the processes it traces by injecting an mprotect()[0].

So right now the hosts which want sealing need their own kernel image, and this 
option is one of the things which forces that. We're working towards hopefully 
running one kernel across the fleet, and with a boot parameter we can build it 
with CONFIG_MSEAL_SYSTEM_MAPPINGS=y, keep sealing on by default, and turn it 
off only on the hosts which run those tools.

Let me know if you'd like more information. I can also put that in the commit 
message for v2.

0: https://docs.rs/reverie-core/latest/reverie/vdso/index.html

>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index e75344f4e0cd..b1ec9a8a979e 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -4270,6 +4270,13 @@ Kernel parameters
>>  	MTD_Region=	[MTD] Format:
>>  			<name>,<region-number>[,<base>,<size>,<buswidth>,<altbuswidth>]
>>
>> +	mseal_system_mappings=
>> +			[KNL,EARLY] Under CONFIG_MSEAL_SYSTEM_MAPPINGS,
>> +			whether system mappings are sealed for this boot.
>> +			See Documentation/userspace-api/mseal.rst.
>> +			Format: <bool>
>> +			Default: 1 (enabled).
>
>You _have_ to duplicate the list of things this breaks here please.

Will do.

>Let's negate things first. Make the boot flag 'no_mseal_sys_mappings'
>rather than confusingly implying mseal_system_mappings=1 could enable it
>even with a config option not provided.
>
>Then add something like:
>
>static inline bool mseal_system_mappings(void)
>{
>        return IS_ENABLED(CONFIG_MSEAL_SYSTEM_MAPPINGS) &&
>               !mseal_system_mappings_disabled;
>}
>
>And call that in _install_special_mapping().

Makes sense. I'll call it in __install_special_mapping(), since that's where we 
already have a vma_flags_t, so it can just set VMA_SEALED_BIT without going 
near the legacy flags at all, if that sounds good? Then VM_SEALED_SYSMAP and 
all of its users can hopefully go away.

>The LLM overlords tell me that only uprobe trampolines would see a delta
>from this given the ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS restriction.
>
>This would improve things a lot.

Yes, but there is a wrinkle. Since 07c308eb2bcf ("uprobes/x86: Do not leak 
trampoline vma mapping on optimization failure"), __arch_uprobe_optimize() 
unmaps a trampoline it has just created if swbp_optimize() fails, and with the 
trampoline sealed that would now fail with -EPERM. I can see two ways to deal 
with that:

One is to seal trampolines too, and just leave a sealed trampoline in place on 
that path. It's already a WARN_ON_ONCE(), and get_uprobe_trampoline() reuses 
any trampoline which is in reach, so nothing is really leaked.

Another way would be to keep trampolines unsealed, but that means bringing back 
some kind of per-mapping opt-in, which is exactly what we're trying to get rid 
of.

What do you think? Either way I'll Cc Jiri and Oleg on it.

>> +#define VM_SEALED_SYSMAP	(mseal_sysmap_enabled ? VM_SEALED : VM_NONE)
>
>No, you don't use the legacy VMA flags API for new work. Sorry.
>
>See above as to a pointer as to how this should look.

Sure thing.

>>  static bool range_contains_unmapped(unsigned long start, unsigned long end)
>>  {
>>  	VMA_ITERATOR(vmi, current->mm, start);
>> diff --git a/security/Kconfig b/security/Kconfig
>> index f7bf6cdc6229..d5e83af1bfc6 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -67,6 +67,8 @@ config MSEAL_SYSTEM_MAPPINGS
>>  	  of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
>>  	  this config can't be enabled universally.
>>
>> +	  Sealing can be turned off at boot with "mseal_system_mappings=0".
>> +
>
>'With this configuration option set, sealing can...' right now this reads a
>little like it's defaulted on.
>
>Also can we move this Kconfig option out of security and into mm please?
>This is explicitly an mm feature, and it should never have been added there
>(mm needs to know if somebody sets this default=y or something for
>instance).

Sure thing.

>Tests as separate commits please.

Happy to do so, but aren't you worried about bisect safety? Or would you 
suggest another way?

>This seems total overkill, you're checking whether a boot parameter works?

It was mostly there so that the existing test wouldn't fail when booted with 
mseal_system_mappings=0, which meant parsing a bool. With a negated flag it can 
be a lot simpler, but I'm not sure which of these you'd prefer:

One option is to skip if [vdso] isn't sealed, and otherwise expect all system 
mappings to be sealed. Then there's parsing at all, and it also stops failing 
on kernels built without CONFIG_MSEAL_SYSTEM_MAPPINGS, which matters more once 
it's in run_vmtests.sh. The downside is that it can't notice sealing being 
broken entirely.

Another is to check /proc/cmdline for no_mseal_sys_mappings and expect the 
mappings to be unsealed if it's there. That's only a few lines now, but the 
test still fails on kernels without the option, as it does today.

Do you have a preference between the two?

Thanks a lot for the review!

