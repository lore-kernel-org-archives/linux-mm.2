Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56851C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6526D6B0148; Mon, 13 Jul 2026 12:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602F76B0149; Mon, 13 Jul 2026 12:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB826B014A; Mon, 13 Jul 2026 12:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC8246B0148
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:38:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA1A4C103D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:19:29 +0000 (UTC)
X-FDA: 84984112458.01.32CD5B3
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 02E5B100005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:19:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TaI6FAQb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783955968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+ujhi7qr+5PDvfWnrugr3cptYcf6a5ot8pqDt3RfQQ=;
	b=16SNAFa4LZ7rnwl5LyjGCCZi6ij1x4siheCRZNsAT5ZGRg6N3xLzJN9N0Eh+nws3EwWiLq
	gF4M9ZH5By8Bt8hcU2NkhyF073dzDv+Krc16yf9pRYazwlqshi0LrqsjptrlWe/acowJMK
	t5yHj8pGPDnhwaSjB7ulXALXR1pEheE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TaI6FAQb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783955968;
	b=dnS6ij4G30KdLtlkuRepfiGP41hDKsFU2W0/tKL6O9U6JqNykvigWj+eY76mM6f5iUN+U2
	UQcQQyeKdWnLuF58Gq9sG2fxP7W3cii03wK82/ncd31moLTDimF+dHbD5gi+gtoPkU8YO9
	LDzqxOIehDsjZ99HGl/W9sg3QI8nQP4=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9c26a5fb98so1988273a12.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783955967; x=1784560767; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Y+ujhi7qr+5PDvfWnrugr3cptYcf6a5ot8pqDt3RfQQ=;
        b=TaI6FAQb1cRFezwTztpgFZ7CrmumyJVWkqs925nlGPfEjcch54lT49cPIDtR14CGaD
         FJOyB4Wlao8Bx1HSmkPYzToIM6/G5HGo0nCisspOvQXftivpObbGHubOOJUZSANhm4JO
         qrIuYaNNGVF23U62gc6wRwiJqxlEx18DWS8/uNrQTA+gfarnYYJGCA6jpGAf1GBXmcLu
         89FK5nc/nebpLZwMX9QFArFPmo3rhR44nfKdg5sV0y+iIbMzd0hFZkXG0Ef9vDhuPg91
         aGQ9lO4T1Oc0bMiT+gK/SLW+wcGuu16xBt5c2nmVG3SiwVY0O2VgqCoT1I5TYvg/LxEG
         3LVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783955967; x=1784560767;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y+ujhi7qr+5PDvfWnrugr3cptYcf6a5ot8pqDt3RfQQ=;
        b=LTUUKIOvMRQI+BJ6/W6VXTwGr3kUvSh4L8XRW6XiRFhlFSIm48S9m04uAhNt2DS51O
         FTkaa+fhBA/uFHbJVUF4geW0jKueboqsV9ABAmSZh+eD2Cr3wSUXIkeZdRyT7NMurohG
         V++jD3cLPZZ7u43/A4oA56R/8a0TqRFwuZqUNcbYXJYPlOd+LvfbBaNylbyDDUQoMAmd
         dE3t3qE9t0Q34kQMI0Iu1Stbn+fOKJCHpGqstDkzV6UUsHe2W6NRujciJDgzm7y2fwmk
         jWw/1ODZqZlufXqHfNEX+WVP3xbGuhzqycgX/OAxUxShD1zhpOzXr/4QP9w6R2h9/xTe
         oZ1A==
X-Forwarded-Encrypted: i=1; AHgh+RouIUARxu6Q7MytdOK+87kGdQ5Qjo2PO3brmGmOU4Llw/9F4/Vl5oQRasALsP5TBX95WtPf+bgaIw==@kvack.org
X-Gm-Message-State: AOJu0YwxsSdwphyFxlDn6zfq/fsS2HVb+AfcC0fk0upEMtUk8pI15C62
	UDdILmd2cd4UOvYFzWJbMAC5sSZybr//PGRI0EzeX2CIZ3ZEB9B7xCLR
X-Gm-Gg: AfdE7cnVF3Zt1dsekj1n2E9Ff6YucMbVdI5CwZplfCjGcEWETuYbMkW59s113JntxUp
	Y7GiqgBKCQfBHBldiqEq1mIiup6Rj2WPop/E1JURqL8aV+5sTkPS3DJinvs2v5Is5NlC3jt1ryT
	ZC8/7tuntYJ/rAN+P0gF6rjZQvY4BiX+EKXSvV4BRF3KOoAGwzc4twTWWaiGSsH7WpUlMrMXw7Y
	amOoHq+E6ekwlDVhz/3MrIMOucc2zhW/4Um/nrMPIQ/5X/JlKWqiFTziBQfQn8SiXkj1IRc6yzG
	zjK6tCusSYfYDeBPc3p9wwtMPWWew9pp+Y4jfTTdBpfQae5s7+rnTJld2/pxDQgoVD3WhezyG8N
	PgqWIDSiHjFPAFc/p41NVdv0+KYjXekydEHwXpndICdi7LU3pW6PLbarsW1CFV5loMot5ZvEKbp
	k6Vz5pXiLsU/Qcgg==
X-Received: by 2002:a05:6a20:244b:b0:3a0:c246:bb98 with SMTP id adf61e73a8af0-3c0f0b9158emr16049895637.29.1783955966577;
        Mon, 13 Jul 2026 08:19:26 -0700 (PDT)
Received: from localhost ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b924258a2sm54513605c88.1.2026.07.13.08.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 08:19:26 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 08:19:24 -0700
Message-Id: <DJXJM0838IJN.3AJ9MMQ89SUUR@gmail.com>
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
 <DJX4IFO55D9S.3IV3K5XICJAEV@gmail.com>
 <20260713-unerlaubt-luftkammer-kosmetik-46532d395f9b@brauner>
In-Reply-To: <20260713-unerlaubt-luftkammer-kosmetik-46532d395f9b@brauner>
X-Stat-Signature: s7grnmfwzw4bbr8ppryyrswufe4n5cq8
X-Rspamd-Queue-Id: 02E5B100005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783955967-868162
X-HE-Meta: U2FsdGVkX1+cMc7xMlPXAec8r+HGqBfVf/uYPbP5SUE3SLJau6JMIp68T8l1oNgNw42Dq+CbILE9cRTdbyCM2bQCSgz7zP465r0MkU4Rd4YhrLrWblwfB4cm8f1pfaHo/gPv4mgMYLTshWh2bsrxPCVzINusu/3pByZ2xT5+Q+tVqbohH0NNMbUVlEio1ZdNQjaNvYq9Q3h9UOgcaWAe6mE1z8oJl8aYd5rC0T79ZMfmij/QShDMAdH/n4O5msMvxa0CoNDoTctaOLiD3Nlnd+tGxPiZqd7f0bGTlgRzOWBB79Ox5KUPpxPfhl94T5HCrrDVrXv5uLj7MLxeaa6WnV33UmHp0q4p732lRgjszz7/BLfmsqkwNLZz7jvjGdr1PSp+CAv+GjRjo9yaCokoCC83MDwVk+rOzAve9xFMM+Z82QzVNPfnRTefRDiPZWX9lNpDbA7dvwN43lVOHzOmPxHkdGIXa6A+rnZB1PDGZ6aGl+DxQkzXUMx5j4wHsiszWWGS87o5jNJHOWXHaUthiZoEQbQN2Sv8vtzLn1hwp5gpN70mklSTrbmxjzdDYoYGDaKCrFMnX5H36aKHXz/xc4ZEzQlehYy3L9UzqgMhR3WVh0QpIQ/fjKnTVigWcIGd3dB+HErZZ7PKgvZp36yeH/k7f9QowpLoTA5+qPDluSQjIf9R+5gYeGgmO5ZP/xEPO3kgarrG2l3rUEhhTl15xSscmOjf3EEiqMJyphYYLJR7fqMvBSo9i7QwVzA6mEzkiDCv8/8ki5ZM4WQSqvN6uIiibH+p3dSH6YlmSGSqO8nAe9CQ7jDiAKISDxGeq9cku+rKECKDowFLZjZW1SMaqW7fIXSYhszYrsbf7IvK6DTTAu0H6oqT0ye5AbvWeXroXmFo2Ar7isGMYt5XGlUJz1r+ETIYUBR088xPpdzw1u+KytgcvONXzAPnKU18/omjqAce24XrhEp50pnhlzt
 mmlVD0jU
 Kk3uH6utOGzB1mJRI8htzEJd6kxk5nNdk7w4VmYLrTn7ICSpWwRCZPt+7CgifHBFZnoDytC4voL27LvlTF8xhiAI4KW7Wvv0L9rGOxfuITnYL7gFeMVelGx5iQT2DejfFB8F3CE03rqRvn8+/tzeUlcAhE/R2jYaFFGuazZDbg4Rb5TbDBTj46DyINMuq+OZ6WSDgr35gPaAbXWumYxRHt9iJyam+GkO2Hx7ikLgoA0PVc+eIMsp7rqZ/0ZQjkxVJQ46/c2hERKRkU/LrD6EgLjNXnWTM+3VY8BygmvLV58PB5joAnQvh0xZTpHvAyP9nD8fDtFf21gORsW1kKtSR0znt4J8/Pt8PO23jDKbrm+nfPDuCKAE9xZNC5uSCVYdAXgg57apojtq1EvUpZ21sZ06DMhoOix4KBK5ffkdf7rIQLryn80IDARM3Xci7Eva+uWgLCWsIO3o0mA07mcCZ0mM0HYrq7UvLnIQARp2WizkRzEUmHhaKj06qnOgPY/+2gSO24iK+Fo5cQrE4zi/hWMMH+fXrd6aInfYhKXCpljTXPgABVcwauKb6grQ34rWTPrlsq0OYIfZI0ACW2rTUnDsJU3k/iklUSdefmr6Vgg3kJVPks4Iu9GmXo+h4kpIlCKAVBPdHPXVu6M+doFaJLc3u9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 13, 2026 at 1:20 AM PDT, Christian Brauner wrote:
>> > - The single sleepable load op is split into two ops:
>> >
>> >       struct binfmt_misc_ops {
>> >       	bool (*match)(struct linux_binprm *bprm);
>> >       	int (*load)(struct linux_binprm *bprm);
>> >       	char name[BINFMT_MISC_OPS_NAME_MAX];
>> >       };
>> >
>> >   The non-sleepable match program runs from the RCU entry lookup
>> >   walk itself, exactly like magic and extension matching: same
>> >   registration order, same first-match-wins semantics, and it can
>> >   only rely on the prefetched bprm->buf. It must be free of side
>> >   effects since the walk may be restarted.
>> >
>>=20
>> Is relying on brpm->buf enough?
>> Right now that's only 256 bytes I think, which is not enough to read
>> segments we might care about. That worked fine when it was just a magic
>> number but the idea with the eBPF program is to make decisions based on
>> more data.
>>=20
>> In the selftest I provided, the `PT_INTERP` segment is already at file
>> offset 0x318 (792). I was imaginging NixOS having to support
>> `PT_INTERP_NIX` in order for the produced binaries to be backwards
>> compatible with older kernels.
>>=20
>> The other idea would be to make the `match()` broad and select
>> everything but then nearly all ELF64 binaries would match and then pay
>> the price to `load()` and ultimately `-ENOEXEC`. Seems like it would
>> make multiple BPF binfmt programs less useful.
>
> Ok, so your idea is to have multiple bpf programs that look for
> different interpreters. Yeah, then you have to be able to sleep because
> you need to be able to fault. It makes the code uglier but I can see how
> that's useful. I'll see how nice I can make that.
>

I mean... I thought that's the intent to binfmt_misc, to have multiple
handlers -- with the expressiveness of eBPF vs. the limited
magic/extension, it seems like a natural extension to support multiple.
Otherwise anyone on NixOS would be limited to our single handler for all
binaries which seems not ideal?

I'm not knowledgeable enough to comment on the sleep/faulting aspect so
I leave that to your expertise.

>> >   The sleepable load program runs once the walk has committed to the
>> >   entry and does the file reading and the interpreter selection. Both
>> >   ops are mandatory, the struct_ops plumbing enforces the sleepability
>> >   of each, and since bpf_binprm_set_interp() is KF_SLEEPABLE a match
>> >   program cannot select an interpreter by construction.
>> >
>> > - A match is a commitment. A failing load program fails the exec inste=
ad
>> >   of falling through to later entries. -ENOEXEC keeps its usual meanin=
g
>> >   and hands the binary to the remaining binary formats, for a handler
>> >   that discovers it cannot serve the binary after all.
>> >
>> >   This kills the part of v1 I disliked the most: the skip cursor and t=
he
>> >   leave-and-rescan loop in load_misc_binary() are gone. The walk is
>> >   never left and re-entered, and 'B' entries need no special semantics
>> >   against concurrent (un)registration anymore.
>> >
>> >   Your v2 changelog note about keeping the bpf retry loop in the
>> >   __free() style is moot as a consequence. The loop no longer exists.
>> >
>> > - The load return convention flipped: 0 now means success after the
>> >   program called bpf_binprm_set_interp(). Returning 0 without having
>> >   selected an interpreter or returning a positive value is treated as
>> >   -ENOEXEC, other negative errnos fail the exec.
>> >
>> >   So the "return bpf_binprm_set_interp(...) ?: 1" idiom from the v1-er=
a
>> >   programs becomes plain "return bpf_binprm_set_interp(...)".
>> >
>> > - The handler name moved from the offset field to the interpreter fiel=
d
>> >   that field consistently names whoever supplies the interpreter, a pa=
th
>> >   for static entries, a handler for 'B' entries. Offset, magic, and ma=
sk
>> >   must be empty:
>> >
>> > 	echo ':nix-origin:B::::nix_origin:' > register
>> >
>> > - 'C' is allowed now, v1 rejected it. It behaves exactly as for a stat=
ic
>> >    entry. The setuid transition stays gated by vfsuid_has_mapping() in
>> >    the caller's user namespace. Which makes 'B' handlers usable for a
>> >    per-binary loader over setuid binaries. 'F' stays rejected as there
>> >    is no fixed interpreter to pre-open (I have other ideas how we'll d=
o
>> >    something like it later.).
>> >
>> > Nothing changed in the exec patch, the fs kfuncs patch, the kfunc
>> > itself, or the registry/namespacing model.
>> >
>> > I can send v3 in a bit if that's ok.
>>=20
>> I don't mind at all you sending v3 and in fact I've been enjoying your
>> involvement. I didn't know what to expect when I offered this idea up to
>> the community.=20
>>=20
>> I'm happy to keep co-developing this with you within a design you feel
>> acceptable with. Please let me know how I can remain engaged and
>> helpful.
>>=20
>> One last thing I was thinking about is that we will also need to support
>> $ORIGIN in the shebang path, however I just tested it and this current b=
road
>> BPF solution can largely handle it [1], with a small wrinkle.
>>=20
>>   $ printf '#!$ORIGIN/interp\n' > /opt/app/greet
>>   $ cp ./interp /opt/app/interp     # any interpreter/loader
>>   $ chmod +x /opt/app/greet /opt/app/interp
>>=20
>>   # stock kernel: binfmt_script opens the literal "$ORIGIN/interp"
>>   $ /opt/app/greet
>>   bash: /opt/app/greet: $ORIGIN/interp: bad interpreter: No such file or=
 directory
>>=20
>>   # with the handler registered, $ORIGIN resolves to the script's dir
>>   $ bpftool struct_ops register shebang_origin.bpf.o /sys/fs/bpf
>>   $ echo ':shebang-origin:B:shebang_origin::::' > /proc/sys/fs/binfmt_mi=
sc/register
>>   $ /opt/app/greet
>>   <runs /opt/app/interp, the loader found next to the script>
>>=20
>> The wrinkle is that it can't express today is the single optional argume=
nt.
>> (i.e. `#!interp arg" -> argv[1]=3Darg`). We might ned a way to express
>> that in the load.
>
> Ah, fun. binfmt_misc wasn't able to express this at all. It's good to
> close that gap. This can just be done by adding
> bpf_binprm_set_interp_arg().

What is "cool" about this is now it's also a net-new feature for shebags
which the "old" binfmt_misc didn't support. Anyways, I was thining ahead
about what I would need to support $ORIGIN fully and this was
a remaining gap. We also explored this idea in a patch pre-BPF [1] but
now that we've settled on this solution it seems much more natural.


I was recently reached out by some Bazel people who are also interested
in this $ORIGIN support. Interestingly they let me know that
IllumOS/Solaris had support for it as well.

[1] https://github.com/alurm/relocatable-shebangs/blob/18db0da6cd69ce19bb02=
73f2548a2d96bdaa82b1/relocatable-shebangs.patch

