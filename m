Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 469C8C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E91E6B0098; Fri, 28 Aug 2026 09:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499C06B0099; Fri, 28 Aug 2026 09:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0956B009B; Fri, 28 Aug 2026 09:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF626B0098
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:07:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B674F1C1CD3
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:07:33 +0000 (UTC)
X-FDA: 85150704786.18.0CCD1E0
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 98B8E18000B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:07:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IR6z+7w0;
	spf=pass (imf06.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787922451;
	b=Bfu3TUDzmnGGn6ebyCIzxPVnypRr5+HBCC+6VlhD1OSwD01FE9gqh4x4wl52bycnx6Xkd/
	kgWebQygVJ3MfymsweLDxIcVaVtShJHh52zn/Wd4qcy8W4EtpmvpaRcrBm9O1jeBKRr5i/
	EZunuLiFoseZp80t2bfIKUE/ivpfv7M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IR6z+7w0;
	spf=pass (imf06.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787922451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7aHFohDYwXcOP7zZuVMn7W5BMSpOSC48205QwYsUq4=;
	b=6yZXt1Us7NLWNgOmS2vndcKB8+VVXGyBUHZriAJhFwYppQ88miujZ8x75xN0Qpoc4wHjRn
	PsyJKLq/UWxrsMteYCw1SHNp69Z7jkr4e3d4TVnH/W88MfeZeY+cj3U426sdBGo3dr56hF
	+SsyRVrOFuXSl25bQkxfYYgS67oUq0Y=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495590dde14so9058945e9.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787922450; x=1788527250; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E7aHFohDYwXcOP7zZuVMn7W5BMSpOSC48205QwYsUq4=;
        b=IR6z+7w0K9lmsVhNhloWw/0ZqKtxhlVh7edT42QGjRf0TpEewjbkqn/EjZDzQcDth6
         PIZ5Jo2545h4daarc4TP/0fvdGbnGhzXh4Bg6iI78H8MpssM7VMQIJ1C0R7MUkbPCdG6
         K4vUVAF5bL5dDQYSzriFVr9Fn1rNh9F5vfRZYn9O62BrtQywQ7vLYAq6PsbJXXtzhY/s
         mRyN1WtcT9tNk3ec/UyFWfwMUD4meIsptsrN8pYpS8d5yWsdeNi+8So5RENeAGm3MfPq
         eWLMPcKt/GmNLp/e5vMGEEi2OWRTktp9nf8/NE/wA40+eb40uOewTl4L+NL9dxZBoO7N
         FlfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787922450; x=1788527250;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E7aHFohDYwXcOP7zZuVMn7W5BMSpOSC48205QwYsUq4=;
        b=Xlxa48X5IPhNlj5Mrgt1l5aBO9laPDGNh0tGhGLwRjbjcqqGMbYCjNFxxTwWuNI1ek
         UMC41PyCz1WdRBFz/eD1zxZTJB1/P478Fby3kzzt3P3+XMKA9Cc1vyJj/VF0/+mcZ/R5
         SndoyYSxS7u6RQN6bpLtIbBfGVcs6KQ0/BcViw1qv+LuhPVz94zo6gpkFoMVK/uQNAvF
         quZehBHxRQ0Y+diJabmQ21Av00iQFgCPILXnShcdYN9T+83RaqUSiz7ARcXKgmblzgq3
         PG4OSnKtzHJx1mpzZLD0qhBj8JZh5Ud9q35orIdR9ll8oCnNX7AVefd2fxngxqeQnz72
         MdeA==
X-Forwarded-Encrypted: i=1; AHgh+Rrh6zOqqMfxNImFI8uYSYgtU1c7ajrtsoFfitPCswnLt93LiQ371DqLNr8VC/rGiLJ3FXlr0/XKLg==@kvack.org
X-Gm-Message-State: AFuF++k+4lQrKzqhECwPtyNTFTrb46jWlBfIBbqWOZzXiuVqfoBeg3xA
	SyN7Cu5t88jzIWKDlXtt85m9sqKf89mcWFWvNmyvzjVkmnB5CymAiDxZMGsxHBcTtcU=
X-Gm-Gg: AR+sD11dGXKE8/gJGspwfgqwbucm92CZYY9zDgirFiMskj8gbHGdOC+vQP+CgAZ2QMy
	stj1qL+5SaX2dHQ3qu8FfbtEOAGiJGouxvcMGQXzpzsWOrCKjuaqBWbVwDDjHx/5AwX+kdHfXUL
	LZX1MvUbuno0cUNbipAKeUeH0W1AySaqrSpqTv8ZtepG9hPS3bkwb5/FYEbKv1P2VFRQNY0ljle
	gxQMYSI/UWlft9u6nPt1x+SvbDnT/aWK03i9tdLro2Z4/Cf7ugaamNg3CgSH/uZC++cuYvu5nni
	z3r6ux8Cs42dq0lJ/n+3U6U8TtwoRQfGQx2UB8daS5o4SN8wrBFy8MVMlZWGDkYFbWbRuekU2lY
	M/l5+9WIco89rBKtwgkD0v/NzyrXJesC4IjBcYJAkHalTZYHs5L8Wl5uMF93sTwWbbdkiZW205d
	Euq9XnwA+USMW+8aVpUnqMG2pyqXE++5ASS/lylO5x35vbTc5/JUFDqh9MRG6chCnpatnDLAXMl
	zPk8wJgyituqa7oNBa8Inbjrg==
X-Received: by 2002:a05:600c:8885:b0:49b:909e:922e with SMTP id 5b1f17b1804b1-49b91c4884amr87957605e9.10.1787922450172;
        Fri, 28 Aug 2026 06:07:30 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:fc6c:f9a2:4a0a:6354? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c80asm56272005e9.9.2026.08.28.06.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 06:07:29 -0700 (PDT)
Message-ID: <524b5817-c097-47cb-b301-4a9c0f1d2947@suse.com>
Date: Fri, 28 Aug 2026 15:07:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] arm64: Allocate .text and .init.text together
To: Ard Biesheuvel <ardb+git@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org
References: <20260822135323.795946-11-ardb+git@google.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98B8E18000B
X-Stat-Signature: 5bfs61xhw117c8oqqu3wfixymx6phrio
X-HE-Tag: 1787922451-909073
X-HE-Meta: U2FsdGVkX1932rMCj5KPyPEfOcBfxiFzaxmFgYasiJRNMC1kZLZpDiU71wUTRUdx2sLjYgBgMimkRlJ7Kq912HlcbJcazShosjEsQjsU4NsDi1ZG/M90EvfG7bz/ddnoofmHRuLwI1muQP3tqBydeabEcgMTGc1u8p1PfyrT+DZiZIyHVAKJlFOtLtnCuQewqcf6fi7P9cnNrRIaWreisarJ0g4eYZbrcn79rkaQeAgYGC0I/ICo5GEFsODAklroO38VWDxP+uDqVja7H8kkH4hchSxs1tQr6FO2OkXEioIr9LWoOVtjzqaHk3SZRi0kYBiTwUCKbISxExTmTCh63gnq2mvvvuXyJruBqjJJvrLW5HHhHy8SMwrnNwwg3srqQNwYelZ35RRTUkB6eEXbuD2ZTNIU57JHkqnr0bkADTyp3yDaOU9yuUjOA/aHYY7IB49BcJ8n2fRhGIMGZZwvt4cs1a+gYVhXTnGimBt6/qpdZ+fJuSczM263hROsDG50ilZAV9x7UEuqkU71eUkURFrz2SGgYEVMycpjERqPWyYuUHXAvHF1YQGnQMMnZ44Lf1lIe5oN1ihysncH5y38UcYn1FZYwiBhvWnaCj4ndzwpdeN7b/GOUD/O81/Lq//a4MJMw42M3FMQ0eSEB2OamDkr8j7bqAtE8YCarI+VCCh2m2KTUltLFyG9f/9DGHrcsAIIkCb3sCnQrYtfWgKWp7TOhE46dkzTe3NNNBDEseRFngCPiML5zZ3rv6Kd5Cj3Et5R3D4A+bpjHRDdlmSDcbBE1zMsiUYmfc00DsUVVI61NuNGObCBQ/X6g6ufrMGUN71lUMteKRQoH1GkBLz15bHwgpI99cV7THi+7XmLD+VpLD1HY8133Ki2ID/fY6IFa0drkAlFjGBN2gin6/fHRx26a4Px2KreYD0CDEE7aZmdZATERVaFzlTlUjSB/H0/0haKJkv5OvHJGvBIZm+
 OKJ9iZeS
 YXpK5XNkrAckmIBji3UAFieI5T0fdIV3DqhNGI/isl4eqscCFmNXydzDin+wodtiqAnwjbl+4cWDrlApk5DF1CCHvj3SRaFblF7qRajDYYlMVZuy4ZNL2nbLO20R4fCrLbhc80EZ91PJKKMozUl97kA64d/pFFyUxks+kt0shEXDEUkgAu8Pai38+x0Djl8I8AmECFuH5wWhu81TrClBoafugXLXsP1c01VKF0m8nN8CmB38M51Cd/NMbAVC62LKzMqZPsjB3My4lGXJ8+LhWftU6g9NIiGrv9KngU8zvFAkuzHzc4HOTj0OXUSlKIgBct9AHvZATrlfjcpQNhZEHD1NLfRlMCIjlAUYmiyr6VvJKROinwVeMmS6oPvspaBLqID9KNMzh+1MfIbhXvbP6BRQqxiy5sZZJ5Sebx0oK0URU3e43R7CTnE61aTzu1CJT7uuZ7u3NUrAWkZ+CiEMDtVyeuXA9PLpgjRR4nSMmo0e5dd0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/26 3:53 PM, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The arm64 module loader has to deal with a couple of corner cases that
> may occur when .init.text is placed out of direct branch range of .text:
> 
> - ordinary direct branches from .init.text into .text may require the
>   use of a PLT entry (i.e., a trampoline aka veneer), which means not
>   only that additional PLT entries need to be allocated for
>   cross-section calls, but also that .init.text needs its own PLT
>   reservation, as the one in .text will be out of range as well;
> 
> - dynamic patching of the ftrace handler into .init.text code needs its
>   own dedicated trampoline as the one in .text may be too far away.
> 
> - recent compilers may omit BTI veneers for static functions that never
>   have their address taken, and so additional veneers will need to be
>   added to .text in case cross-section direct branches from .init.text 
>   require a PLT entry (and therefore a landing pad at the target end).
> 
> This is unfortunate, because it is actually somewhat unusual for .text
> and .init.text to be so far away from each other: only when allocating
> either of them (but not both) exhausts the 'near' (PLT-less) module
> region, the other will be allocated from the spillover region, which is
> not in direct branching range, and therefore requires PLT entries for
> cross-section calls.
> 
> This series addresses this wart by allocating both of them as a single
> chunk, and freeing the .init.text part along with the other init
> sections at the appropriate time. This ensures that the two regions will
> never require veneers for cross-section calls, allowing the arm64 module
> loader to be simplified.

It looks like this should also be useful for ppc64, which currently
merges .init.text and .text because keeping them separate would require
stubs between the two, and consequently .init.text is never released in
modules on this architecture.

-- 
Thanks,
Petr

