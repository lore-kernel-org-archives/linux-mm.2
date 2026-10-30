Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B6360A263C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xQ/T4xw5
Received: by kanga.kvack.org (Postfix)
	id 07F1F6B05B2; Fri, 30 Oct 2026 06:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F996B05B4; Fri, 30 Oct 2026 06:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E611B6B05B5; Fri, 30 Oct 2026 06:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0C596B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:50:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1C89A0650
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:50:35 +0000 (UTC)
X-FDA: 85378974030.26.1B92C66
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id D09DFA0007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:50:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="xQ/T4xw5";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793357433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0au4KAwJy7gDntm9ACSIbu1AVWLccO3DOOW3yQIu4U=;
	b=5rB7ckz+7Jy95+2Ce+7zwH/qQPkKHUSIVEpWOr0IklQ+qtg+bXaumPw5+QLoDFAPUKl0z2
	FuNGDbhQ0eNcB3ClfNg1TTSxNSZ+PhRXm/7LWILjlcOTh638qUwdVGWcqXthgBPUUXBQim
	z3viLSuHPHsZVOfscMrP3I8rwN6zGmI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="xQ/T4xw5";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793357433;
	b=kQYB2/qz5KPq5r6xxWJovpeg+9vvHJuJIhifdeRT8JT8a99RBKbmSifcgdoifZngOM6pVB
	M5UN3YwaiLLDpZvWfbzEhfXTNh3y+RpbJCelIiCM6ZMD+lR+/duuHBIwm/YzNiCM26MQfa
	K+jbpAIyiebVdraOFg2xCg80xdf7+lc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a208d93758so5466995e9.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793357432; x=1793962232; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g0au4KAwJy7gDntm9ACSIbu1AVWLccO3DOOW3yQIu4U=;
        b=xQ/T4xw51AR6XXWlXYZpN7hsoLMGwJUr8phWC8wi/xZCEdOM2cpbY1YcDfagrRB6Lx
         LmBuo/mhbEMQQ72WN8W20zUpcEWDDCpMlIg/d8w6UelWYjLrkd8RSShXLUtChHwPVi9E
         sc+3Z8oCMVGGtuQUVHCcu+MWjEorB8DnPoDzKfiBpH8OxIihgF9CwjYjAuGWYwKzeKpg
         ga+YPObduTdHy2ysP5rmveuG9hvvr83u+DJkg7KbvQKGE6TW4eGhzH0KL/S7XBG3zU6V
         FZULqDAS64PacnUXt/GPirT2Cv592TRjc1NoU4kCM5pLfqc9Q84w31I5XJnt3KUDkWoc
         JKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793357432; x=1793962232;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=g0au4KAwJy7gDntm9ACSIbu1AVWLccO3DOOW3yQIu4U=;
        b=XxiQTmnJwHg2jZimFCHDakvq47O62vRLc+qCuEp+W4pUU09HspdzTsFktbF9efZCl2
         792c9ziShOS9GSfggelCOJKbjojGZRFVUxPRqZvYI+/VyD6RDJul1RbqTWna0Gq5J15N
         nL4gkP+AkGnbdN+iq/6ZA7W8Z8Tbf6QSLdqPhZvj8rf8VrXzotUwmXJxjkiY7o9nLetu
         RX+wd8NU5WRY0x4WBS5w7AjaGjYy58zSxCwGb8Las4CmeV7XJngIrkh7p/DrWeCkqyrI
         AjA8lWWCBP59KIm3Sy73Qg4n9RdWZP0lrliHJxSrzfJR3mgf3eKFz6dWg+7D9fz9TVnZ
         MGdg==
X-Forwarded-Encrypted: i=1; AKwUvBwnekS/LhSxn6ioBvA0Fc3gtPKKBpeMLFqLymmOfjgEp+/84+j9ntkUUFnK6z7hidkHAs8UNk8fYA==@kvack.org
X-Gm-Message-State: AFq9FYI/bU376SF+Ndn/qSZGQu//RhWbPcJI8IhsxUDnt/j1P2lnXTgM
	hkJh+BMOhN1baldoAJ4rAV5OiCVrs0ikxWuE+a3j0jhxMH6Ynm94nS7r
X-Gm-Gg: AYBFou2ezTQ0z1H+cH0ZACKyFQkAQSnBS/Vk5HVxGpToXENuFHdzcFH7hp6fG0RsfmE
	palWnTfNXs3oTldfcQ/E0q+Es0cWElERWxS3zPwp5DlbmJBTFuEowKoXaEMb7vzk/SP0FqBKiIg
	bCQ4a6kbj+4Ng4WaCQ2Y4QuSugigMX/0wCq8TAKkQwtG1+muICwzGV1foG6rienBBuupNiaDJpv
	/meW/wgeww5gRX8TsJi3GSIpD1OeiaLtAQyW6gCq4kdDgy/Ce/nQRvPUAKShJX4fp1RS0VPH5po
	uwUQtqYtGi6xkcjZ+1HH28CchGfF8oE+GXPsdFjwj/0cLrDhYKggbyF1YT+qCKJkyDTPAkzrKIy
	4hhbWh60Jwn0L7bM3NjSea4pFCoXqPIUmH3w1UIm/ca5bL43fiqOXsA83g42+2uWR+viztO9Cf+
	kCO1Qyyp8fY9dwweNB1E8q7BNz1ZIZNrsXZUho3zUS1uLEMvfbUgfJxtmGWRhjeNJvmb/vywXxb
	F5vvweojCTdM1U3Frq+0xpsbdnngvR6VeDgjVB7T7SDxZOcSxL/t7dWiLwQF9t5xzt2ApaFijTb
	u6s=
X-Received: by 2002:a05:600c:8708:b0:4a6:42cc:bf7b with SMTP id 5b1f17b1804b1-4ac150b2176mr43501375e9.3.1793357432164;
        Fri, 30 Oct 2026 03:50:32 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::25dc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81a896fesm143894065e9.10.2026.10.30.03.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 03:50:31 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 30 Oct 2026 11:50:29 +0100
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: Re: [PATCH bpf-next 1/8] bpf: Add __srcptr kfunc argument suffix
Message-ID: <auR2dWsi_K3ut-mK@krava>
References: <20261029212551.56964-1-jolsa@kernel.org>
 <20261029212551.56964-2-jolsa@kernel.org>
 <CAEf4BzbUQpQcdpCJ0o2g0YkaR_Lwe9EOXdj8Fth0UUpAs-LR6w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzbUQpQcdpCJ0o2g0YkaR_Lwe9EOXdj8Fth0UUpAs-LR6w@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D09DFA0007
X-Stat-Signature: p8ngsrg897hftnzffuxniumbwojc6sit
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793357433-479414
X-HE-Meta: U2FsdGVkX1/WPFjEB3LyVAg2RTwLZL/XBfkwJAyCEfCFf413E3c7yVMCm9rfonE9kGNkTgcPcnrV1TxF+NOaAraK6538LaVypT7mzvZgXHdUrLCFGjbZaEJRmGhAaaLrCPl0y2psyu6vfmXRzzxIJMw+/hdL3AFZon2skC/+RW2ZM7OyUl9sabqdUK8uNqLsN5ZjCZkGPUz04QC1yOjBN0P1I3F1tdPAptRAsTeoNgmbb/4YyRv48cMWP6cV1Bd5LoKfVEUznPWc/+/0AZ67X/dby8BdxAx5fLhkPXr1OxjVXkVdUJbchVjbSISJMT2In7oKj2gux5xlAk1cTyYlYAY4Ne2brIl3k/rq0h28WLCb53PUQBGw2SNKeVhZTW4KPs8a6YZSB54hNFgSPvLlM0KDET31ryAFzhOYloRUKnkV2lwhTriD3RG7jQ0Bs7HFQYSJcp5kFOerVcSca4Huu81FmANwPGbq1Q7Avn9GT9W8aMH8e7FKeS8RA0X+pc8bAce7AXoZfzyLcoZyez5DYQb6gJIGDVZf4jWP1rVXpW/8z24q3SW4ibpiqFzquYUidrIwDCtHeUrL2r+yVIDtG/E8xKfhe1Z9xwMzv0xtXeGpvvc7TrAHkj5Oj0O3gyUioqiE1dzy0q6Z3f9gCPxSBUk94vSddrPIqi2U3RrSoYVgS5rdJKH+8KGQCXwcmYMm7YwmFGrGfqWMQHsdHPAmOVqaZJelX/l8+wBMIJS+k5wM9iq2CmyRgMfZDTxzhrCkyKMGFeuwIRpnMV8htC1tjtfYO54UUjVlXsDbqHNyUQHlaRoKpu5BaDZ2IlkE2diVT0PO4eC5ZEjAu1WbTlrPR/iaiYta/pEiHePF9codF350aX2026SDLffJZskYn7qGvlQYbSZlUFTmH6zHQNvm4vVq+4FMaLie9pyW9H5Up2gurv39eK57JmzwWau4raA3l90medyGWwaPvz8syyW
 5nmkTa1f
 pA27bc04E0aKSHqk6EL5ZTrimhbDiKrJpDHP84co5nj0rQxHtUsn6Q+jt1Y+ZAjWA/yQsp7F7/hKmLCPwX1KkZSzrv+T3mAxsZ5Rbx8Ak7wcPBTAP28KnFBAbqQJ1FLPcZtydzFNfnB3r4KRtnT0CqsfHR/w6YDIb5wB4TDDqiZGko30mOgkmMeS4h7Ug3o7kReTSsf5NnjzYk21Hb/QGpXFc/amy6G4PsLv6wqZeSDTSFEpLZNhEgytJarjkvCmStuN7ZrB141Wrv5uRo6CQ0HZVmA3xG3/iDeg7Mh7svXN63oaZMut8sCZUDDluxJnEiNtSIxzIgs4CEphZ7IAlyeEZaUKP31JLGGYVh49Ef+aZU6ZpnGvSo1zk/HimiodB+1dEHcigC8V9Uuv8+vAQkJVR2N4F2VFbG84hTvAJw8NQhPGB41cNxGS8PhGDYYXztV53YT8KtdRHhg9jk82NxKk3Ey0vqi1lIb7ghkQmeEzw4eb64vfb/E9v2UT/ooGF7h4H0SJj8vQ3AtTi9jsnyfuLInrboan0JSi7Jb5O3bYrb9kVlVRtAY3CmOd1EYmmiyGX9dsN5+jFPbZY8E0X7tosDiX8dNQcHqd+1fA9xlMM6T74tf4XRudp4L4N/fT5/4PqUb5gYPAtAp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:49:22PM -0700, Andrii Nakryiko wrote:
> On Thu, Oct 29, 2026 at 2:26 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Generic sized pointer arguments are treated as writable memory. This
> > prevents kfuncs that only read from a source buffer from accepting
> > read-only BPF memory, such as const data.
> >
> > Adding __srcptr to mark pointers the kfunc only reads.
> 
> why can't we infer read-only from constness of a pointer? what's the
> advantage of __srcptr (which, honestly, says absolutely nothing,
> "__readonly" or "__ro" would probably make more sense if we have to go
> with suffix)

the reason was that current pointer arguments are marked as MEM_WRITE,
so passing readonly pointer to bpf_copy_to_user caused verifier error

but I think we can use const, did not think of that.. will change

thanks,
jirka


> 
> >
> > The get_kfunc_arg_type change sets the initial memory access mode
> > and the resolve_func_arg_type preserves the suffix’s access mode
> > when it converts a BTF pointer classification into a memory argument.
> >
> > Assisted-by: Codex:GPT-6
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  Documentation/bpf/kfuncs.rst | 24 ++++++++++++++++++++++++
> >  kernel/bpf/verifier.c        | 20 +++++++++++++++++---
> >  2 files changed, 41 insertions(+), 3 deletions(-)
> >
> 
> [...]

