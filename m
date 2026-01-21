Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 010C2D2629F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 01:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6599D6B0005; Tue, 20 Jan 2026 20:32:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6076F6B0088; Tue, 20 Jan 2026 20:32:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5065D6B0089; Tue, 20 Jan 2026 20:32:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBA46B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 20:32:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D49F21606A9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:32:35 +0000 (UTC)
X-FDA: 84354246270.14.0DC7399
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id E532220006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:32:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=CgUitnkg;
	spf=pass (imf03.hostedemail.com: domain of zong.li@sifive.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=zong.li@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768959154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phhznUg1me3aMCDh6RtpPgdrBfYLQTkKfqDDafoKBZI=;
	b=JoWqf1AAl/94wvoQlzh/2QrMMc4Pb4G/kG2exq4F8URgtBDvj4F32AI9qnrzS31b/63Pfi
	91Lr8ZA2kUUVKnNS+HhwNsjiepIh0wv22CiCi6Hbu/zo1zrjqwNP7lXCUnxYwDxGPZ7zYp
	OI6+RkaLPZA+PrDU9i7Ow8DOwvAqc6I=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=CgUitnkg;
	spf=pass (imf03.hostedemail.com: domain of zong.li@sifive.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=zong.li@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768959154; a=rsa-sha256;
	cv=pass;
	b=TbVXUcuxGWcPS2aYPV+oD8+MQSIOgyfJRhJQz1JVyCZk8ZjJn6D+PrpHrO37ts8PH2qimh
	TaPPYkF2mr9ewVNVSCCBz0sU1+UZpCIuN5G8mukBukGYHl4qC4QGL0Uz4ofX4PO/yVc0zN
	QGxtPubuLgg8qeqPUff+40iAXbW1n5Y=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b87cc82fd85so507104766b.2
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:32:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768959152; cv=none;
        d=google.com; s=arc-20240605;
        b=QuV57DWuI2FW+J8ngIAmFIhHLjw/ea5dLZR0hbvwGp7n7/RbfuMYVFv/9zMwaP0LvX
         CRCeil8GszR9CpYPF74Ba4ddk9LFfUiJkS0Lo1NKW5lBZpK6O6mmH10q73Cqf+xFGK+Z
         YXaLod47TlD6ljq4ox/4L2GkhsRaPmCwpX5NOlyvfkUuUbJbrBoVeJCkXuSsGhXmrUGu
         oz9wntYHe+2fjdyaUn5F1w6j4fOavoTPCMg7AvplAjwBujycL11QBnhGNgPWOgpzw7kt
         1tEyNNY6QLYCcvfRlfwgS66bxYl16/q5biUiOxMMuvk+YiTpwF7UKjMQBTHqWznTZNuK
         GJJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=phhznUg1me3aMCDh6RtpPgdrBfYLQTkKfqDDafoKBZI=;
        fh=kmRBX75lPcqk4MXU+FgsOdKU1kciMz2bHGYd7o+fMiQ=;
        b=I0KQF4AmM38hBZsJdk8nhScGJJvH8D0O0SBpO6c0HntfiCVXsFbJSdeBVZXq16hnot
         44onTaLY31JrO8i1l2faEq4+kP39E3fgq+fISQCkioE67oK3NdDo1n7nfD7pd+ZxNU9H
         ZT71iLL0IDABwhxVYD5mFLGE8AEN5MMU1B1DEMmgPqNIHVvnqyyOBsTa9vsE5iva7Rub
         mhSHTtBabr+kNFzlHMrwSlXdwWyS2AEeSCr2mpOMRgxhKr8BWTN7Ze7CJ2rpviPFYMmU
         4Dqzly3LFdtZ80lUeyAGkRQY2tpG30Br9t9Pnxg89EWWMBVX7A4bT4e1KAOyhL7IVdWC
         4UoQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1768959152; x=1769563952; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phhznUg1me3aMCDh6RtpPgdrBfYLQTkKfqDDafoKBZI=;
        b=CgUitnkgZMxU+MWPav116VdW5aAIjq69PABzdmQG831FawoPWCHV1kjwJwcbK6kGxg
         qxzLDikzYNUWYcPLLZQ3/uLl3V4LZ15Qw27+jx3Y0QoflBMUNb8iL19AKHxuVJpObCx3
         aOH1mG6lwpDAuzqSJ8OACsoeiVL6/HyoyMuqIYFX9E98sUDVM6Teao/HxsCVbSOj4qC6
         v/JdLx66XA0N3wugVzf4IWSosKCBuzFg2tJFJUD0eGP8SAnpBSju0akkxQIbQQw6ME6G
         yTPXt/Zgq+Id9vcddR0aRRusEozlgp24Z4wy24or2l3TOqXrw3uPxzNZ97367hJa4sUQ
         HNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768959152; x=1769563952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=phhznUg1me3aMCDh6RtpPgdrBfYLQTkKfqDDafoKBZI=;
        b=EtKIqNILdwLO4Wf5kdMNYyFV+uPhsBLSOHl7nlaEIK4ZHLh3qCCTecdM8Cd2I9PwUJ
         Ju3VWny4J9ToGM0+2e4ftEFWw3cCpjJfPO/wfDuyW4ezsvLLZ1m61f2qS4xs7JAZuMf8
         6lIw5nO6OTLZrob683MdDGD5VpXi5H74qI4FoLk8suvvJfDQ7twuJrw9r3fiFEgQ1Ni7
         owJcyJ6s5YonBRC+F9XQqfvsLRWLpZISDll+j/Qjqy96WT/F/TEtbBdSSMLi3autL6SM
         zM1dygjMNhGZnJ64oc/9O0JB03B+l4kNo6/tuqGjPPH5JZAPwrn1ob8qzMVraDS4OrG5
         zjvg==
X-Forwarded-Encrypted: i=1; AJvYcCXLuPDW2lelqGe6oYrbhN9eJEGEXzlE5fHidC9DY1bIR7q3QVGLeDELUu2SobbUqeb3m/acQ2goLw==@kvack.org
X-Gm-Message-State: AOJu0Yw5DOvFUw+BNqzPGI0sXg+qgziTeSq3h4S4FNnWtPy7DOufz5hh
	CqrM4/zax1gsa4IkmuE3B6XlxwqMGKD0TdkTmu4sWFmJavXomBGnsb4GXGNulSoa+8I2cCINQaQ
	VpgcKnviVn3nMm9QgWdBEr8cthwfmsb+BKvdtJfgh+w==
X-Gm-Gg: AZuq6aLhTR1iY+zuLrgZ3hsFp/WVcAm+E23TMe5MwedFSVU9TJ8FDG8DDnzULmX93Cq
	DpEfyqwThdm7Joaztupec5bEQ0LJxt/5EC3v5bdM01v+gI1XYFPRbv2vup0LNwEmX342+T50wuU
	llDHM1DN7UBH/bvJJgjIKCWFMk1phDowjLuifUzcqShnp+PAKpmztFRY66Y0fbBMb92ppWi45qJ
	vev/dsGJlxOKfK+2uqqgL5kqkMePLF7l6KpfBrsbyhtp/6EMzoHAU1JMEr6Qda/GsJhohdoOg==
X-Received: by 2002:a17:907:9488:b0:b87:7634:b20c with SMTP id
 a640c23a62f3a-b8796b215a4mr1301363166b.38.1768959152268; Tue, 20 Jan 2026
 17:32:32 -0800 (PST)
MIME-Version: 1.0
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
 <e052745b-6bf0-c2a3-21b2-5ecd8b04ec70@kernel.org> <aTxf7IGlkGLgHgI2@debug.ba.rivosinc.com>
 <CAKC1njQ-hS+kUJ0C_v0oqZW1EZw2zAXMp-SnnA-ZXh_H-SoVdQ@mail.gmail.com>
In-Reply-To: <CAKC1njQ-hS+kUJ0C_v0oqZW1EZw2zAXMp-SnnA-ZXh_H-SoVdQ@mail.gmail.com>
From: Zong Li <zong.li@sifive.com>
Date: Wed, 21 Jan 2026 09:32:20 +0800
X-Gm-Features: AZwV_QgpJ38WsQTA-JLh1W5jk7su1plcAErfmIKl7ceT3yMsB0wZBJHvBBZ5Ujw
Message-ID: <CANXhq0rpjSvOThACrB6_MMc8S34--xJsUYZ+HtMu1GUNyk8zOg@mail.gmail.com>
Subject: Re: [PATCH v26 00/28] riscv control-flow integrity for usermode
To: Deepak Gupta <debug@rivosinc.com>
Cc: Paul Walmsley <pjw@kernel.org>, x86@kernel.org, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, 
	Conor Dooley <conor+dt@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
	richard.henderson@linaro.org, jim.shu@sifive.com, 
	Andy Chiu <andybnac@gmail.com>, kito.cheng@sifive.com, charlie@rivosinc.com, 
	atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
	alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
	Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
	Valentin Haudiquet <valentin.haudiquet@canonical.com>, Charles Mirabile <cmirabil@redhat.com>, 
	Jesse Huang <jesse.huang@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E532220006
X-Stat-Signature: hwud516wadqtaj81fzx4ohg1suyoh19j
X-HE-Tag: 1768959153-342191
X-HE-Meta: U2FsdGVkX1+S2JjnfQnqNjzkNmSaZejyrZDx9075S/vB5Rf6HQmutSZfNBUCd9rrEwU9SmpwGCRgoNO57tJm6sIBtj+jHUO8PdSBZ9rlHVfTLS+Tev1+0FM79ZAwh352H3N4CMWGJzK++0JuEHDTUp3FtCGR6y19CECqd5RRPkQfw9TCCsf7YM7JlwR6bty3P3KoELRSMs+bDuUO6lHvecHMmUojuyBdu5TJ2hnT/V8092dmbg8DrKR71k/Z6I+KA0uvpmxZ1DkkYb31ouHMtyyGbpZ3jL6rm7jgvtUXCl47HQ1gkCHvhgIrBRF5ZXzuo9OxN9uA41hOjZuW9E2KDxcQTNbsMyPdF8hg6juE5IusMqnOHbdd3cOIgIfozIUMQ7aBYgBZ/Yzav0MhPDG22FfbIAoAN1Z/4wPz62aMn13IJ8fCO2n83i5rxzrY3D4EB3S+uudEROTPPT2s13aveS69y1M8YHLdTPxOo6oRQLweKWCEpUcOcRb618lvODamxu+nqP7HTWJLIRvv0ywPkFrXxQ8Fd940SfI8yPxH9K7WgDx3fseGG5QYpU4+JKfjW0bKoicRPwdeLjjka7M0d1+Vd6QAPet53yZ/GkhZ7i48sdBZCht7MkSA3RpJZvKZYa7AjETa+TgczkA4AEQs23ZI9uKv8iUp621knDs1zAxlFfeZ7CGq1oXiJ42D3Gb/pOvWfaHN9UHksiS1j3hf4ZHDLAsiciZh9oxvXwDOz7UD/oAKC/67sJhg032IdKJtNNlkx7tFTZJPS2pmU5MxZcj9QsNnWhOtGxYAEXHhmCVYPFSArj29H8OBMQKZnNlKFxp8R5yhw/md+YGKTfXv7/tII5XCIloAsUSIku1ruKIy7iKcbJFJ4wBqzVf74hHd/yvOX9wmx6Wu922M9TV3rhbGvf+udJM7T2wovSb20blZP26EW/d5uD5C+Weff0YAUkiJK9coV+KQH8zvdJD
 N2yTPXF7
 r9OmxBdJShv9qiXkgLp186p7PpbM2BK4PpiX4WwAg1OPWvNaD/5nMN14M4r2IUSiV1d3xyUfgFM9spdtm1d9cz9DNGURoHgg+F7natA8PiAIwAqrUupnX17qDuP0jHGtb1hfVXUJBFXzkyTc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 8, 2026 at 11:10=E2=80=AFPM Deepak Gupta <debug@rivosinc.com> w=
rote:
>
> Hi Paul,
>
> I have a bugfix for a bug reported by Jesse Huang (thanks Jesse) in riscv
> implementation of `map_shadow_stack`.
>
> Should I send a new series or only the bugfix-patch for implementation
> of `map_shadow_stack`
>

Hi Deepak,
Not sure if I missed the bugfix patch, I couldn't find it on the
mailing list. Could I know have you submitted it? If so, could you
please point me where the patch is?
Thanks

> Let me know. Thanks.
>
> -Deepak
>
> -Deepak
>
>
>
> On Fri, Dec 12, 2025 at 10:33=E2=80=AFAM Deepak Gupta <debug@rivosinc.com=
> wrote:
> >
> > On Fri, Dec 12, 2025 at 01:30:29AM -0700, Paul Walmsley wrote:
> > >On Thu, 11 Dec 2025, Deepak Gupta via B4 Relay wrote:
> > >
> > >> v26: CONFIG_RISCV_USER_CFI depends on CONFIG_MMU (dependency of shad=
ow stack
> > >> on MMU). Used b4 to pick tags, apparantly it messed up some tag pick=
s. Fixing it
> > >
> > >Deepak: I'm now (at least) the third person to tell you to stop resend=
ing
> > >this entire series over and over again.
> >
> > To be very honest I also feel very bad doing and DOSing the lists. Sorr=
y to you
> > and everyone else.
> >
> > But I have been sitting on this patch series for last 3-4 merge windows=
 with
> > patches being exactly same/similar. So I have been a little more than d=
esperate
> > to get it in.
> >
> > I really haven't had any meaningful feedback on patch series except sta=
lling
> > just before each merge window for reasons which really shouldn't stall =
its
> > merge. Sure that's the nature of open source development and it's maint=
ainer's
> > call at the end of the day. And I am new to this. I'll improve.
> >
> > >
> > >First, a modified version of the CFI v23 series was ALREADY SITTING IN
> > >LINUX-NEXT.  So there's no reason you should be resending the entire
> > >series, UNLESS your intention for me is to drop the entire existing se=
ries
> > >and wait for another merge window.
> > >
> > >Second: when someone asks you questions about an individual patch, and=
 you
> > >want to answer those questions, it's NOT GOOD for you to resend the en=
tire
> > >28 series as the response!  You are DDOSing a bunch of lists and E-mai=
l
> > >inboxes.  Just answer the question in a single E-mail.  If you want to
> > >update a single patch, just send that one patch.
> >
> > Noted. I wasn't sure about it. I'll explicitly ask next time if you wan=
t me to
> > send another one.
> >
> > >
> > >If you don't start paying attention to these rules then people are goi=
ng
> > >to start ignoring you -- at best! -- and it's going to give the entire
> > >community a bad reputation.
> >
> > Even before this, this patch series has been ignored largely. I don't k=
now
> > how to get attention. All I wanted was either feedback or get it in. An=
d as I
> > said I've been desparate to get it in. Also as I said, I'll improve.
> >
> > >
> > >Please acknowledge that you understand this,
> >
> > ACKed.
> >
> > >
> > >
> > >- Paul

