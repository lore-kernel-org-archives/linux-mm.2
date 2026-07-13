Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69479C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 03:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D7B6B0005; Sun, 12 Jul 2026 23:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EEFD6B0088; Sun, 12 Jul 2026 23:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7F36B008A; Sun, 12 Jul 2026 23:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 233A56B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 23:29:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58D50120A7C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:29:33 +0000 (UTC)
X-FDA: 84982323426.23.AC7FE0C
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 80892180004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:29:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HqmrTNL/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783913371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5LwUqjbpPHissd18BCl9UcC6YRNwOX+ZmfwwTb7nug=;
	b=ImTKqvehVxqMuug1HA83KiUsM7x/N3aXP0k3wnu8BSQEE81r2jK7IqkhqDPDrtsjRhI31X
	S0CNKuqMaZC3GzwvBMSv6y/Ge4N6IdgZ3U+t3Kr1h8+4S12j8XAh0u9fIAVFgEBFtVWo3A
	a91esBrJt0kRrS43U8O+UW1CrfbQcYY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HqmrTNL/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783913371;
	b=OsPnG00ulfw+YL4v9s/ic16fMgrlv1I+OO2Z8dD5UsHBiGTLD2vN9WIvHwpcygxqLlPMEZ
	kGZJg7nochMawHs5RSxkzpHgiNxVspwnNjsawnbmt1+z+hIvEU1OFp+2ra87ZEno0oUlxB
	unBE3bogqjyOZ+9pHOWZx9D2RosvI58=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cca0c5799eso26856515ad.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 20:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783913370; x=1784518170; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=N5LwUqjbpPHissd18BCl9UcC6YRNwOX+ZmfwwTb7nug=;
        b=HqmrTNL/TjXE02k3ra6c//9gqq7ZSyQuD7/z4fJLQAkZMUdPMLGPwzRNuusoc4HMQ1
         fbrV2rlNAIe4qsHSGlvIVy3e8jd/pHQCnQwosHHLKY3O94m8almeeuDqLKOyzhMI+fZa
         3QQO1QxuhB/axJQOh4KN6AEh7hv7LA4tXJG2AaweSz4ZvbiaOOesdpzZRAeYTTW8Mwqs
         ygl2E7LyNmNofhUrFXl3cpJbwfsPpTI9GjYLYkwYpPXJ7/cpP1KAQnckbwHmxLpOLI4Q
         HRgOu/psVnNZL+oWB90sGVR9m3T/cb27uXX6taIYBEgQXKeHX5gECOKyZ3qV4SoovU7S
         L4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783913370; x=1784518170;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N5LwUqjbpPHissd18BCl9UcC6YRNwOX+ZmfwwTb7nug=;
        b=GnPiSezhninmut6XDO2pfjnOpkTu6EULOkGO+vGfkKzhfW8NaVqExgg1023tVA0Gt1
         c47UH/Qhons544pw4Fu0xX07i6819OSNUL1YYQdI6CLVR1Wlbe1C29iTGAK22K5vV857
         JDtsriUsjf761FAiua0pzYc4s1X/HbQv8kloutPAedtPSv9n16FdgzBeUtVm1KUX4mjI
         ziGR/HjtLQLuyJenReQCygOlzTaHUrzd92uLPhQQ7FKXLMyFZTw2YAU/8m5JHZEvXqgD
         xDFsg8X7i1hcWFC+T0Qv1EMEKUExPQRbK0PR77CJgkiLFa0QctGyjq28yQv2j7ZSwfpg
         CcdQ==
X-Forwarded-Encrypted: i=1; AHgh+RpnONGyyT6j9mwu2qG0KIky5QogFrVvUIGEffsq/TPVjXwjuCSBoliGZbLAEfyC+Y5HzK1Qj1KJuQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9ywu/z3GFWmiwYHYa8XFKPq4BGcVQiZgJQ8uGOx819HQXnz9K
	gikmVcxvQo5UgCHgN1aoHnpcducf8+nDFVzLOo0PtTwXr4+NsJnBNCsH
X-Gm-Gg: AfdE7cn4nA4c6n93ERQiOPk/RMkOAu+hxccJeT4efRpESSq5nL55ihZpIKRjgJG9Zd9
	zLCW+wc+CFRK2OamkJGyvWUqZoBBC0WorefGuZcOjmDKUhZnQYolviCi2uSUUUSLm6diG6PTI8X
	hTPBxJgylrdNh1JGruQtc1voFJsNW5oZqwiDYy6h63x90ZO2nq2n0/tG5KjVHMi4Hf5gE4fPkSY
	fDWcUSVP6IlvQOJbVHLEmlF3oiuDx+XotI7ebY3IGCJGvnfIIme0HYWxPB5iiT2BDiTW2McWs1t
	/Ppd7KzT5pNTsSbJ/2FyO4rz+pZcEXgOt7nnw0/30jv+s+Jt8wtry9U45pXM5nDczhYJit4qu+c
	wFqY23SjkqZ8SJqaGV1532Ss4m3NjjnVWWHOgzcD8nnaWH91zx37P4OmSqr0icb5d6dBVzDX+YK
	IPd5vDPIrkpGxXbVdv098zfiSs
X-Received: by 2002:a05:6a21:4d8f:b0:3c0:9c1a:894f with SMTP id adf61e73a8af0-3c110b33403mr8114739637.71.1783913370254;
        Sun, 12 Jul 2026 20:29:30 -0700 (PDT)
Received: from localhost ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b84d6ce15sm26187778c88.5.2026.07.12.20.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 20:29:29 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 12 Jul 2026 20:29:27 -0700
Message-Id: <DJX4IFO55D9S.3IV3K5XICJAEV@gmail.com>
Cc: "Alexei Starovoitov" <ast@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Shuah
 Khan" <shuah@kernel.org>, "Andrii Nakryiko" <andrii@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan
 Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Jann Horn"
 <jannh@google.com>, "John Ericson" <mail@johnericson.me>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] binfmt_misc: bpf-backed binary type handlers
From: "Farid Zakaria" <farid.m.zakaria@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>, "Farid Zakaria"
 <farid.m.zakaria@gmail.com>
X-Mailer: aerc 0.21.0
References: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
 <20260712-abluft-brutkasten-aufladen-c8063a4a1a0a@brauner>
In-Reply-To: <20260712-abluft-brutkasten-aufladen-c8063a4a1a0a@brauner>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 80892180004
X-Stat-Signature: wmemtbwtws7u8f9qzsmegatxrfseahw5
X-HE-Tag: 1783913371-562963
X-HE-Meta: U2FsdGVkX1/mm44q7Nfdvq/BnMDpQ4vPDMJ3yoy+c9z68x0HfUT9/NkGn2d/jd7VLnyxFkhghL2cHMFIFTQo2QlVsmEea6MJ1XdVAgn3FNV2AXBIgBZzxqY4HTiumy016DVc6MV2qYmWfO2uVnfbSetpJAzsL+uZsG8Cg4VnbdAa+5b2EoQ7RP98mm+CXPzAJWpREZy4wMzBSV7ExkHyaWBy93jCj3qnYnGStnhpTEUm6Oj6mNf8TOehuu4foRKosqCI06q7fsWUDkEhnvMrcFDzuuKb6XJPqqflNpmR+vM/rMjSEaBsaEzi/TrJNABo5vEH6IoB+dRiiXdD6LexjbgLVvB/AN8Z+sAolE7ntJPBpnFrFbWB70haJLJjYf/x9fojZGajqpUXIgzCSI0y3hmO5v9NuU4DPrRP4t4rAILqJ3r6G+TT0bcM6dhEeBBLt4Pucda16LE2wrKBnKvE/qywcmQxi7N9KtR9RZC2DeHDeq4P9LDUjSPX7tITf+nd3jGw7eHRuZDC+GLOH6X+RZ7R44dI6xvuU0Vnm5UTdOGgMijQ+3lOXzX2fnbSUmvZR5qM0uNLzWx+z6XuY4yiOF0lraTqRlfGoCOoyl+tOOFwVb84Y8+bCDJwNfOFusnVr82W694ngwkhvScTFz4qaji/SpuPkHO9Kvc8HrEyLc+n+Oc4Mvtxa8tMWxJQMm+Z6kweJFX2wVIX+hm+o0c20+KWa0dWuj6Zn7kJcEb6F8HOgHV8WSVmXlqrLtOmgBIeO+O1h0LLJaRcoo5qAMB6CrpaMUyypXMCeaKcABk6maUNkMUzGJdg670sVD3Gc9A8FgWObXMq9DTTTetwOlsmkbqS05sNBK+dTDdYyS9l9z6aEp9sQoSHboMACPHN8Wsgw4Y8xM+bchYsV6Xgz4hAiR1YQf8Asu3tPCcM3z2bsp/3QXATywsE3/x71tfkswsMmG1UmOrv/MtLUV4ku7n
 Y1hSb1rR
 NVatczeIp5rd2RHdsb5111VydH0FyG6Ik7dD4Cdz/ipS8QXk2AJ7k6V0rembbjofEFHUoCpuA/eItDcMoe4dgUvA+aJNjfIW2xnBMKKg1P9iqgPNQFKUxxEb6OFhS645kSjIVCHQ3G3CKJBnZUaqm6mGJrlip/5FAghl5XLmPk3+lkW4OspKcmKpB9AQQ3zBUzHWYXxQFmsNjB4nldoyhBgp4DuGJgxv7hrkMenI33kv1UIL7hwEyz/IcYXjnrGyqZ/YLlM6ekM5JrHATE8IS3XeAujC/p5UiTwwlwiR4Ds5J5tHm/zbuOGPXEnc0jIpZHDdCh0Oj9gGAvLlMp9QB74ggNGKSogAK1587WnMSpORrzr1pQsyiwd5ai/Bj+v1CmFZsgVJMO8DAJgyaHTHuRxzuPKZKpkZyvQGZ8J75mhfxbYXDihBhkVBx+F3KfmBQ+qg0ZHmc+FfMlztP+thi7RlT878XmQ0OqiQ012y/lEXJDk2mcY+HQ4qocujJWihAr1wm/Xzk0GvNx+lSBVaY4SEX0yEhLzDbSNsvNG5pYC9+9e0wxSzrqnS4BsmQSGM1K9jLprWLks1JRx9Q/rkAPzxFQnZXl9X2guyc6JkYrosXapV/iumISKDf9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Jul 12, 2026 at 5:32 AM PDT, Christian Brauner wrote:
>> This is a continuation of Christian's bpf-backed binfmt_misc POC [1], wh=
ich he offered
>> to hand off to me. I am carrying it forward. The kernel design is his an=
d is
>> unchanged. This series rebases it onto his binfmt_misc locking/cleanup s=
eries [2]
>> and adds selftests (+ fixed from the one's shared), and therefore does
>> not apply to mainline alone.
>>=20
>> As for motivation for this whole change, Christian did a great VL;MR;
>> write-up [1].
>>=20
>> TL;DR: binfmt_misc can match a binary and hand it to a fixed interpreter=
,
>> but it can't match programmatically or compute the interpreter per binar=
y.
>> The Nix community would love to support relocatable binaries, where the
>> correct loader can only be found relative to the binary itself.
>> This adds a 'B' handler type: a binfmt_misc_ops struct_ops program that
>> inspects the binary and picks the interpreter with one new kfunc,
>> bpf_binprm_set_interp().
>>=20
>>   bpftool struct_ops register nix_origin.bpf.o /sys/fs/bpf
>>   echo ':nix-origin:B:nix_origin::::' > /proc/sys/fs/binfmt_misc/registe=
r
>
> Thanks! So I've spent some more time working on this because I had some
> future ideas that I needed to make sure could be accomodated by this
> (currently on vacation but hey...). So the version I have givex this a
> better design and has future extensibility in mind:
>

I also enjoy hacking over my vacation. I'm often told to take break but
some of the best ideas come when on vacation :)

> - The single sleepable load op is split into two ops:
>
>       struct binfmt_misc_ops {
>       	bool (*match)(struct linux_binprm *bprm);
>       	int (*load)(struct linux_binprm *bprm);
>       	char name[BINFMT_MISC_OPS_NAME_MAX];
>       };
>
>   The non-sleepable match program runs from the RCU entry lookup
>   walk itself, exactly like magic and extension matching: same
>   registration order, same first-match-wins semantics, and it can
>   only rely on the prefetched bprm->buf. It must be free of side
>   effects since the walk may be restarted.
>

Is relying on brpm->buf enough?
Right now that's only 256 bytes I think, which is not enough to read
segments we might care about. That worked fine when it was just a magic
number but the idea with the eBPF program is to make decisions based on
more data.

In the selftest I provided, the `PT_INTERP` segment is already at file
offset 0x318 (792). I was imaginging NixOS having to support
`PT_INTERP_NIX` in order for the produced binaries to be backwards
compatible with older kernels.

The other idea would be to make the `match()` broad and select
everything but then nearly all ELF64 binaries would match and then pay
the price to `load()` and ultimately `-ENOEXEC`. Seems like it would
make multiple BPF binfmt programs less useful.


>   The sleepable load program runs once the walk has committed to the
>   entry and does the file reading and the interpreter selection. Both
>   ops are mandatory, the struct_ops plumbing enforces the sleepability
>   of each, and since bpf_binprm_set_interp() is KF_SLEEPABLE a match
>   program cannot select an interpreter by construction.
>
> - A match is a commitment. A failing load program fails the exec instead
>   of falling through to later entries. -ENOEXEC keeps its usual meaning
>   and hands the binary to the remaining binary formats, for a handler
>   that discovers it cannot serve the binary after all.
>
>   This kills the part of v1 I disliked the most: the skip cursor and the
>   leave-and-rescan loop in load_misc_binary() are gone. The walk is
>   never left and re-entered, and 'B' entries need no special semantics
>   against concurrent (un)registration anymore.
>
>   Your v2 changelog note about keeping the bpf retry loop in the
>   __free() style is moot as a consequence. The loop no longer exists.
>
> - The load return convention flipped: 0 now means success after the
>   program called bpf_binprm_set_interp(). Returning 0 without having
>   selected an interpreter or returning a positive value is treated as
>   -ENOEXEC, other negative errnos fail the exec.
>
>   So the "return bpf_binprm_set_interp(...) ?: 1" idiom from the v1-era
>   programs becomes plain "return bpf_binprm_set_interp(...)".
>
> - The handler name moved from the offset field to the interpreter field
>   that field consistently names whoever supplies the interpreter, a path
>   for static entries, a handler for 'B' entries. Offset, magic, and mask
>   must be empty:
>
> 	echo ':nix-origin:B::::nix_origin:' > register
>
> - 'C' is allowed now, v1 rejected it. It behaves exactly as for a static
>    entry. The setuid transition stays gated by vfsuid_has_mapping() in
>    the caller's user namespace. Which makes 'B' handlers usable for a
>    per-binary loader over setuid binaries. 'F' stays rejected as there
>    is no fixed interpreter to pre-open (I have other ideas how we'll do
>    something like it later.).
>
> Nothing changed in the exec patch, the fs kfuncs patch, the kfunc
> itself, or the registry/namespacing model.
>
> I can send v3 in a bit if that's ok.

I don't mind at all you sending v3 and in fact I've been enjoying your
involvement. I didn't know what to expect when I offered this idea up to
the community.=20

I'm happy to keep co-developing this with you within a design you feel
acceptable with. Please let me know how I can remain engaged and
helpful.

One last thing I was thinking about is that we will also need to support
$ORIGIN in the shebang path, however I just tested it and this current broa=
d
BPF solution can largely handle it [1], with a small wrinkle.

  $ printf '#!$ORIGIN/interp\n' > /opt/app/greet
  $ cp ./interp /opt/app/interp     # any interpreter/loader
  $ chmod +x /opt/app/greet /opt/app/interp

  # stock kernel: binfmt_script opens the literal "$ORIGIN/interp"
  $ /opt/app/greet
  bash: /opt/app/greet: $ORIGIN/interp: bad interpreter: No such file or di=
rectory

  # with the handler registered, $ORIGIN resolves to the script's dir
  $ bpftool struct_ops register shebang_origin.bpf.o /sys/fs/bpf
  $ echo ':shebang-origin:B:shebang_origin::::' > /proc/sys/fs/binfmt_misc/=
register
  $ /opt/app/greet
  <runs /opt/app/interp, the loader found next to the script>

The wrinkle is that it can't express today is the single optional argument.
(i.e. `#!interp arg" -> argv[1]=3Darg`). We might ned a way to express
that in the load.

Anywyas, thanks again. All your ideas made sense modulo I'm unsure if
`bprm->buf` is enough to make a decision...

[1] https://gist.github.com/fzakaria/2e1e1c44fa488a951674f8761c672366


