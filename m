Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F271ACD4849
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 21:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E798E000E; Wed, 12 Nov 2025 16:25:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E366A8E0006; Wed, 12 Nov 2025 16:25:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4C9E8E000E; Wed, 12 Nov 2025 16:25:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BCC2C8E0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:25:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 590F91606E3
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:25:59 +0000 (UTC)
X-FDA: 84103237638.05.F50119C
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf19.hostedemail.com (Postfix) with ESMTP id B6F301A000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:25:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=l4sYpKrF;
	spf=pass (imf19.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762982757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8N8ijlsC6KhiWuu4QbjeYznaUps6aMGSWXMdwdxDAxw=;
	b=qpiH8geD2RXSAjviAapXdShNqrfzcGfcLoFHrWvVCZfz16g/ERob3kXDCLD7rIoXrCS6vZ
	fdZxqXj9lL+GbKomKGWm27LLalSlmaVVne5jSHFjMIu1Kfz0+9ShqWMJUZt1V+Ypjne1XQ
	L6ISa2oV/1upxpErEQk1P2X2Qtz3Cws=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=l4sYpKrF;
	spf=pass (imf19.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762982757; a=rsa-sha256;
	cv=none;
	b=O8q9GR9tm9MfdZNaHM+QH/LQRyQYggatRXob7dXWCwJfr4ouTWG3DasRRPx4usRCqGQHCN
	9N4QZPpD6PE1hqfeCaffxvDr0lUCvvLtFjDx+qQQU5LEoaGO+KeM+VUOMJmUDlfj5eLs+t
	2fH9MZttJxpreSgLagVc3FvXi9oWVNY=
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACLPBM51004081
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 12 Nov 2025 13:25:12 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACLPBM51004081
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762982714;
	bh=8N8ijlsC6KhiWuu4QbjeYznaUps6aMGSWXMdwdxDAxw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l4sYpKrFCrAsnPAUyghmeRvLc4mPQ58O8qoEOPAzhg8jBuxPwak/5xDhgQWN78fys
	 QSjKjYsvalXcxtnp9HzBoEO9qWXhDIdwf/mwzIQAdam4tfqTBiqVbrOwIPxfHQoLAw
	 b47MS7R2RlNPoDYTPCOFO35llNJHDLZ32JwpBzoo/VDXeoj8K6OPCRL4/0wrcjT7KN
	 MdFFSLf5wVH/PLLOFkI8gZtVJTzqi6kqtcDUYAveaXx2MXgCBoAwdEOCse1XChFlwr
	 q6x51Xhio24ZjGTMigtf82gbuTS5LTfHI4ZHCnNNQzanQco9yEzECdXehZ6JdLUc3a
	 knoLwc6mpTVhg==
Message-ID: <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com>
Date: Wed, 12 Nov 2025 13:25:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
To: Uros Bizjak <ubizjak@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
References: <20251112043730.992152-1-hpa@zytor.com>
 <20251112043730.992152-8-hpa@zytor.com>
 <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6F301A000B
X-Stat-Signature: 8yfkxgexkbsyxqh4tacz4hpo99i6k93i
X-Rspam-User: 
X-HE-Tag: 1762982756-325301
X-HE-Meta: U2FsdGVkX1+yZphk+u70JRscGUiiXSCQgasSsSMv+uMOR3KtZJg0Ye37XD6ZAqlyHzDtFSe5QI/9i7T8Pct/sTrega7gcv38z8koQiSrBGNSpbifhbZbqTprjWJw2Hr1UaYWU+QR3flVMINVhp67PqcW8mowBcl5j/hDFJ2lOpi8RoNEaEkq39ysjaeyfCs3b4ucHALjdp4rzJ9zN+5J1OVtuoBhhsUsq8kx0LsKyyy8hTUTEzMOB/avChvvfoSX4IHhOR0pfzqJ9mqWZ1P9IXJXOAxNd0B/2X+/QbsnEQ/9JQp36DNvyyQcB/Sr2qNTH7j1RuTwL098oLkZBohwJN65ni2R/7FVNae2qrmOpDQh5P6zKwLRbOszBqXTLn0ksvvNsMTO4BZByOeX+FVhVkvQtGlNFTBEkD0HqQsPFLIRdWzt5fRWZ5jV574fzJSfvhQqEgzBaRSvkmHoj/SLCbh4zov1ZKQpXBcLxCRMe3srcZOPFAfTmD5GC1Fp89d2x9GobYyG1u6cW0ro1FXyJ31HN75ZkevxuLy1jkSddJh1Kxg1/pjb2W8KEQo1orCBWJo1PFjlqpGa/Om8QJzV7BHz3LDx50yFPhEGW+KwZJe/sDZuPPgC2ylNJcZCyCgFd0J7MJ9DwATAaIpyn4+9a5SbYPvB9ZSDl17tXxjzAFQqNLtpYQmMpyHj5RcRMQIGjXZ6SBepPobow8JA6m4LHYLW1RDTsgHZp9dKAFS22wZ4Au5j1y4EFKr/Ftd9/3wlNhqaIkeMHr3h73E6zHELitxbdepv0dTR9K+OpVN2Sie3CHIps68hKIeMitbaHF3nFWzTCkQHuogL4SUA00lql4nrLHa4v43Jwul7w9hv2MU+0Uu0OZWz4JynPyhU1N+8j3Lwk4pC1a0lVjxu+yhPpHlTZec6hl3O+JbYo0xm/Ie6O/Yc9wWNtYpo1pCCRWdyDd64r6XJ75dzVSnZL7h
 AluHZg5Z
 NvNnGlwF1ECEaFyPHskcDmNKZGJ7HNVcOl1YGApfZy7RWnPfpHyr7hJBQbg1F2SWC0eB4N4vQpVzOEnki0Hfqoti0gZPjTAwpXkk7TXAdDc9bt1FiaC/iEYOXxyC87MCLajfBFkDfgNicmLotT6s9CQsebPs8qICqBWJ7Fjv/qZmvYT+KAl9Te7qoO0z/7goKEm8cOdWjiEVkg+I/QtKktEab5dLxw7p+e/QV61Aw7RhN+7EELWfFj3/wHb/hacrpSOWRCYRD3BA7iXdTbTQQ3daXEJBmvIbLqvOtCvqOyLDJeJRyDSkS3BibGIsDXFQ87YnBzrK1NrkplBI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-12 02:31, Uros Bizjak wrote:
> 
> Unfortunately, %ebp is still special with -fno-omit-frame-pointer, so
> using "ebp" as _sys_arg6 on 32-bit targets will result in:
> 
> error: bp cannot be used in ‘asm’ here
> 
> Please see how %ebp register is handled in
> arch/x86/include/asm/vmware.h, vmware_hypercall_hb_out() and
> vmware_hypercall_hb_in().
> 

#ifdef CONFIG_X86_64
#define VMW_BP_CONSTRAINT "r"
#else
#define VMW_BP_CONSTRAINT "m"
#endif

        asm_inline volatile (
                UNWIND_HINT_SAVE
                "push %%" _ASM_BP "\n\t"
                UNWIND_HINT_UNDEFINED
                "mov %[in6], %%" _ASM_BP "\n\t"
                "rep outsb\n\t"
                "pop %%" _ASM_BP "\n\t"
                UNWIND_HINT_RESTORE
                : "=a" (out0), "=b" (*out1)
                : "a" (VMWARE_HYPERVISOR_MAGIC),
                  "b" (cmd),
                  "c" (in2),
                  "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
                  "S" (in4),
                  "D" (in5),
                  [in6] VMW_BP_CONSTRAINT (in6)
                : "cc", "memory");
        return out0;

That code is actually incorrect, in at least two ways:


1. It should be conditioned on frame pointers enabled, not x86-64 vs i386.
2. The compiler is perfectly within its right to emit an %esp-relative
   reference for the "m"-constrained [in6]. This is particularly likely
   when *not* compiled with frame pointers, see #1.

A better sequence might be:

	pushl %[in6]
	push %ebp
	mov 4(%esp),%ebp
	<stuff>
	pop %ebp
	pop %[junk]

Then %[in6] can even safely be a "g" constraint (hence pushl).

	-hpa


