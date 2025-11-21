Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E57CFA76B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2EA6B009E; Fri, 21 Nov 2025 05:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4935D6B00A0; Fri, 21 Nov 2025 05:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BC06B00A2; Fri, 21 Nov 2025 05:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC6D6B009E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:12:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1AB3140544
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:12:25 +0000 (UTC)
X-FDA: 84134199450.22.B74B99A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6B42340002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:12:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YOK+FY87;
	spf=pass (imf27.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZIk/6eiWFE7r0Pz8jIgtNeqgPIl4m+Z/Z67QWlEwbg=;
	b=wZNhiEyHjNYPKRYq7z90whdoEVAX/uHCZ7ducCpVrBaHZR6+kg8YXCOFhk3Cc5r20Ajuu1
	6hoRV0i4IqqhlnlC4X7Hq5ttgwcfUurbgQ8X+p1+0xhm59IkNYj4Nj7KGVpeg3CcpAbB1U
	Qq5xDhNoiQIgtPzGHrOtgiNe+22kySw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719943; a=rsa-sha256;
	cv=none;
	b=QSsx2gR0RfuGzSC6wiEtTI0GdNsyLQTI9C2C6p3gcQpH0egLllpWuyh1JOU6FlxnAQrTbH
	yOyRFBXVqV57VxchMBrvjwK08dG4nuVIl3kP45Rg4JVbzCtBrhcHgbgezzHL9mxVAc1B2s
	CeadSf5Vb90nSVs06+32dFkxc7nJ3m4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YOK+FY87;
	spf=pass (imf27.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763719942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OZIk/6eiWFE7r0Pz8jIgtNeqgPIl4m+Z/Z67QWlEwbg=;
	b=YOK+FY879Am7GnPXbNLmSgDD9+CwCE35ZTP111/C75w6L6OtMB75MILjDrXLsK9Yl7VOqd
	9vkqDFih2SuH6BKKfbDoa82R2hHE2K5NtORIUpXT2hp6wqOPmxxN81vmwMRCetrS29N8wq
	zHDfF3e3Mwkpx7biyfMKytTcPvPA2fs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-dzJbjdjmOEqT7G5EPcLwPA-1; Fri, 21 Nov 2025 05:12:20 -0500
X-MC-Unique: dzJbjdjmOEqT7G5EPcLwPA-1
X-Mimecast-MFC-AGG-ID: dzJbjdjmOEqT7G5EPcLwPA_1763719940
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-429c5c8ae3bso1624738f8f.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:12:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763719939; x=1764324739;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OZIk/6eiWFE7r0Pz8jIgtNeqgPIl4m+Z/Z67QWlEwbg=;
        b=MJPEvQcynO1/Tgp+bbK4ppkONVBpo5054aRadIJtlEte/XSeCUTJ234mMpt+TObhu5
         vg6CcbX6WKPv3XfsvVPapfjeU7gFWtghOGKCSUVFG3Bk7FlAeSS39dqtYVkDTLNGz6e1
         4ACWGHLKaWC8tQBEhcbH8A9LGgQFDbi9gWxGH5UuXNTopIN6LsYWCswPCTmb1Bg5FYyR
         i+HT8Du97CLroS9J/I+w0xCFce4FIhV2wjyew5EhAg7CQbOin6+lhsLE6+yoTg7Ykp7c
         TyGQIvFvMiqM7TCAkwCWWY/2fFh/2tTzupnHlj9S6kw/vLF33c+66XHsEBH3ZM2gopZK
         rbFg==
X-Forwarded-Encrypted: i=1; AJvYcCXHSX4xJCvZ4jkFBTQk31N/52J60GbSQmiAqKN8hEwwOVFrJwQu+tlT41yyENorJUQFrFyZb/ecvA==@kvack.org
X-Gm-Message-State: AOJu0Yw7UhSG/BymXU4nOm4If7J1rs62X3zoJRNXebz4Vhue1CxwPHbc
	o47hQKoorYZ1i6V8smeJece8eniD6uIwTMg5GAcfmCtTrdoWnH5ht3EQA8kQJFYhM2wFuv9Otxu
	d6T/2F+bh4iWxTKQHDnPoqZJqgHsKCPySFjA2dG77FVrNe3t9R8tj
X-Gm-Gg: ASbGncu7Et4MMPE6w6uczEtdxUGRFHKwaWtNY4/k8FFoMYVmey6havPw9cupQqyIEGX
	VtQJafbrf3lnCNTmb95/Jr2eWhRWEn6o/MH0lhz1dXa3kFi1dzlaF15Kwz8wjorgDzdaIrVLKei
	cKohLoZqWdOoXbKUGdwvXcG+yE0fE5vEPSywrwnkQ/GYFrRB9PZcpED/GGlIFGWn0yK/+eXgl1i
	IQMqUUQ29hubPIl9OwvNCI1qsMhAGkVGJCEeuypRS5IICMVdGOSE86W3Cq3lwzvgvJnOK4tv7JP
	C+qeBqPE6rPiBHgRXgI6hwqROmXSQ9q/wIXHHoRErV6oIadBgjDmHzGRVgpNM15K5psPjnf/kdE
	p/UJCJQ9uwUCSJaq6JObmsZZZasN4L5F5HAxFBsulvnV0/vLK7sT++wWsqwWg6Ub4lFTxtLU=
X-Received: by 2002:a05:6000:1888:b0:42b:3ace:63c6 with SMTP id ffacd0b85a97d-42cc1cbcdfcmr1795919f8f.16.1763719939502;
        Fri, 21 Nov 2025 02:12:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGQwvNnN1+6xkIr+bJK+olrvC0Z5OYdiF1L0OBTcrYbQMUdl7o+C2/hye3fKlSOf/cE5aQ8Qw==
X-Received: by 2002:a05:6000:1888:b0:42b:3ace:63c6 with SMTP id ffacd0b85a97d-42cc1cbcdfcmr1795834f8f.16.1763719938945;
        Fri, 21 Nov 2025 02:12:18 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e432sm9799426f8f.9.2025.11.21.02.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 02:12:18 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Andy Lutomirski <luto@kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, rcu@vger.kernel.org,
 the arch/x86 maintainers <x86@kernel.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
 <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Arnd
 Bergmann <arnd@arndb.de>, Frederic Weisbecker <frederic@kernel.org>, "Paul
 E. McKenney" <paulmck@kernel.org>, Jason Baron <jbaron@akamai.com>, Steven
 Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, Sami
 Tolvanen <samitolvanen@google.com>, "David S. Miller"
 <davem@davemloft.net>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel
 Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>,
 Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Mel Gorman
 <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Masahiro
 Yamada <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [RFC PATCH v7 29/31] x86/mm/pti: Implement a TLB flush
 immediately after a switch to kernel CR3
In-Reply-To: <91702ceb-afba-450e-819b-52d482d7bd11@app.fastmail.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <20251114151428.1064524-9-vschneid@redhat.com>
 <65ae9404-5d7d-42a3-969e-7e2ceb56c433@app.fastmail.com>
 <xhsmhecpukowa.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <91702ceb-afba-450e-819b-52d482d7bd11@app.fastmail.com>
Date: Fri, 21 Nov 2025 11:12:16 +0100
Message-ID: <xhsmh8qfzu22n.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fWAOr8oaFEAL8wvfWeVOD_ZC3w1VFCLN67uPki-xtHA_1763719940
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B42340002
X-Stat-Signature: bynujhojpzymy1qrrr4xhwe6mxs5hoi9
X-HE-Tag: 1763719943-648041
X-HE-Meta: U2FsdGVkX1+J0bpUj3hCLAhsvKDlJQPL4VlScwvtcsEQgDdwvtDLVxdRaUevrhy2a8ywO4/frME/ab3VR2crHrJ7ThQeEObfnhsZRI7Qq23PSm4lE9YpfTrIhlNzBFsaYjrEfQB96JxVAi7cHUi+m2bGn04sY34BRsuNsAV/zVTwVTAkZ5AMzdrzuE8UC5Xd+TEP3IzVDToBr8GhFtrCWWGWBhR6o7iU0O0E63QZLDa9dCEt5BgA7VFppQca/dtRfPjystcjFfhE9EIiLWQyHqxKL5bMRcI3Ubg/uDguEAzr2h2MJobJjMT//q/knBC8SrrWCv/+bU9BQHVis39DDtBij3FZDI91anIq3+x6W0sD3jKRuk39ufNcY7+i7RJ5T+2HMuSe1cDJZkXOgm4vE00EKDVHz50UlA31l9z6qivCBiEulkt+hAyAuOJJj9DQa2hxQjQ2oRb6sEoc6f2L7sk4RbR/RBSNYhz131vAh/EjY+9XIUziEAYkPacjSnF3QnqurMn+ki0BKsI8wzW+8Tv5+74BNOk1H+ur+YtRze/2If9+Kb80lzi4AYCE/W64fdG8DYamfwvCr8DRutnyGf/XDOspJem/X+oaEYu0TJr1HBeMX0t4l8yTQVYIvbbgLijbKjgADc+cnFFcrcyk1Tv7+ZT1TsWu4Z5ri2SOm8ZSHUHNADWtKzQA90VH19VuLdkQoxX6apXeKp0cU7e5Jn+e4mM5DEkN8jfmV8w7nCZWdxK086bVIflXNtUQXTFQ8ukrVOSvkOS1jacOzzpV0DjLoweQkRXtOx/PTCDruwstR7/U/lY6Ey6Gg+fPhIDaySnzhF/AxpvFZSrQ3PIOwXU7n5sutSMFKDM4lczTk1MTgGoeEG07dKOyCs3aZrAbWTdY1cGL4eHChrCQuTGPAhX6cfy9yKzJK9r5EJSm/cA6bDLNKq+kHDo2pWOYnT2xqgUJue+P3BFAoSZuMn7
 rZRuK7fG
 xK2ECc2Fv4DRYOYSEeMjq6JmK0E+YyiH16Ew5wss+UsL/BmTFp0tUvWTC7JAU8C4aNfn3/LOVZJ/UD1xKuttUlKXtUYTD2IVZgOdSEJGZJcXUSqDpB9XS4u4aPy1DrCjSxvVaPGRzGHjYfVYTNuMnxgPws3mn08O6yJHJqKNvN3xV7pR6d82UT0Pon3JXdYcxZ+QFJlehwjUZbMdZjiNF2wclYszQOl0LTnBO9XTAUmA7GmR5eGssPT0ATXlb5g2fOBjNwlv2cNbPPhKl00BHVhajMTkH7nc5v+iVzIeV3PQ4Q03gCT3QCT/+gSM5GQsJ72xiADBw4FjgUE4Fpgyg3t1lXGR5XkLPoiPdLy4paOJQy/3sncrLexfBBqGsSdJt0xFaYWsyX/XTDMlznXDQDyLhU2tHuMg2ZPTUZaHPyWcGEWYWDWYaD3xvb7szO58LbUqoEccNz6LpYpgnR/0b7zwuk8SId+2HKId+DIRTL4ZNSStcRdHZlH7VRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/11/25 09:31, Andy Lutomirski wrote:
> Let's consider what we're worried about:
>
> 1. Architectural access to a kernel virtual address that has been unmapped, in asm or early C.  If it hasn't been remapped, then we oops anyway.  If it has, then that means we're accessing a pointer where either the pointer has changed or the pointee has been remapped while we're in user mode, and that's a very strange thing to do for anything that the asm points to or that early C points to, unless RCU is involved.  But RCU is already disallowed in the entry paths that might be in extended quiescent states, so I think this is mostly a nonissue.
>
> 2. Non-speculative access via GDT access, etc.  We can't control this at all, but we're not avoid to move the GDT, IDT, LDT etc of a running task while that task is in user mode.  We do move the LDT, but that's quite thoroughly synchronized via IPI.  (Should probably be double checked.  I wrote that code, but that doesn't mean I remember it exactly.)
>
> 3. Speculative TLB fills.  We can't control this at all.  We have had actual machine checks, on AMD IIRC, due to messing this up.  This is why we can't defer a flush after freeing a page table.
>
> 4. Speculative or other nonarchitectural loads.  One would hope that these are not dangerous.  For example, an early version of TDX would machine check if we did a speculative load from TDX memory, but that was fixed.  I don't see why this would be materially different between actual userspace execution (without LASS, anyway), kernel asm, and kernel C.
>
> 5. Writes to page table dirty bits.  I don't think we use these.
>
> In any case, the current implementation in your series is really, really,
> utterly horrifically slow.

Quite so :-)

> It's probably fine for a task that genuinely sits in usermode forever,
> but I don't think it's likely to be something that we'd be willing to
> enable for normal kernels and normal tasks.  And it would be really nice
> for the don't-interrupt-user-code still to move toward being always
> available rather than further from it.
>

Well following Frederic's suggestion of using the "is NOHZ_FULL actually in
use" static key in the ASM bits, none of the ugly bits get involved unless
you do have 'nohz_full=' on the cmdline - not perfect, but it's something.

RHEL kernels ship with NO_HZ_FULL=y [1], so we do care about that not impacting
performance too much if it's just compiled-in and not actually used.

[1]: https://gitlab.com/redhat/centos-stream/src/kernel/centos-stream-10/-/blob/main/redhat/configs/common/generic/CONFIG_NO_HZ_FULL
>
> I admit that I'm kind of with dhansen: Zen 3+ can use INVLPGB and doesn't
> need any of this.  Some Intel CPUs support RAR and will eventually be
> able to use RAR, possibly even for sync_core().

Yeah that INVLPGB thing looks really nice, and AFAICT arm64 is similarly
covered with TLBI VMALLE1IS.

My goal here is to poke around and find out what's the minimal amount of
ugly we can get away with to suppress those IPIs on existing fleets, but
there's still too much ugly :/


