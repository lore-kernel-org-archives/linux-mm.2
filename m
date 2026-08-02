Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4527FC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 22:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5016B6B0088; Sun,  2 Aug 2026 18:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2B76B008A; Sun,  2 Aug 2026 18:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C466B0092; Sun,  2 Aug 2026 18:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB0996B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:54:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5947B40592
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:54:20 +0000 (UTC)
X-FDA: 85057834680.14.81B1B61
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8255D180008
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:54:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iSFEEOd9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785711258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSFBKkmya71V99CcvaKtLUtW6MLEeCo92pqjKBtH7Xc=;
	b=FzlmIdI1imPGQj+/B0nlpt87pmls7OEbWSLxqLjwpxPylCZBBkM898kybS1sphWAmfSvF0
	wkPPQ03nUKyXKXmoPKY4VjTYj7xvCHXxKSmFL3YIGuMPN6zeMPrKMN7bsdzSyFV8aHyrcq
	vXAfAcqe7Aq9OjJL6wYKqkQrJ/KgZJg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iSFEEOd9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785711258;
	b=yiXKawlIpIisH1LRODfvSZVB3WVx65KRaWdeNGQBBWkIn8rIKELqEbGzDR7zRx/WHNlFNY
	sb9qYrK2cP3+4CTnrZ91znkHKpCius/7zNJfEzouZCE1a+bZLteRtiR2d1Toq7lWzLeglq
	HrlyWSzlM07mGZolzAFsYFMmD7cKYbo=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso2949934a91.2
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 15:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785711257; x=1786316057; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hSFBKkmya71V99CcvaKtLUtW6MLEeCo92pqjKBtH7Xc=;
        b=iSFEEOd9OT9UIKuZ8pMRkHW4WVQ9GH7cuiKMJu45KN39GJTWiK4aRdKmxpmbFBvHxF
         PaU5WNY+mPsAEqjp/NNHl1ECl2pm8J8r72O3jiN92ZiVsDJZvFYIlF5qcCKv9SjwBl01
         5C6fkryCf/yp6S9MkNIpUEJit1FHUC3dIajp86jOmNdegoVRZssywfIIEkzXg6hzOzhW
         VZsG0iJLzsBD1PLkSB56CXqX46SSQQC1jw7LzCDXbjmr4n+vZbw81073UaPc+Jb4G2eZ
         RE+204DOpTanTnAIijb8CKFZTWfGnMhxXUHEKrPSHRRhNkz9RNxCBd6u9ch1RbCWsu9x
         Bqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785711257; x=1786316057;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hSFBKkmya71V99CcvaKtLUtW6MLEeCo92pqjKBtH7Xc=;
        b=mlo3lJ3/dLjbX8EErSXe5gFXAf84efDQvlTaYtNZ9UBzpeumpqjziRmlQE3l1W2c1+
         n+Xn6mlvTjWocxGQAQ6Tncg78rPjHzggMebZ7Ys6laX6KOoDOfKowvTA+u6MfxEPSA8B
         s/GiEQLtXmDRfr3bSV5yAFtjnUF5/geq6fLCQanMXH23aqiJ71vFRrLWE65n2IvcR1PQ
         QkoSOHEYUJ1VoP66+aXLBPQabbrWQGfdWj+jcvGOagWHiSlN8q9NWVI7MBl4aAkm7rFq
         7cn7ZgFuYlMzXbCPNTDzkGKBANm5S39dkngVraz8cTadeFKdyXP/mASvrgpKudaYFqFK
         aZYA==
X-Forwarded-Encrypted: i=1; AHgh+RrW1RL4HZTxmzzbDZbfrX92wshZDYhz0pmrf+h2TGS0fBsfcYOhgO6gsT/fiKG3PqNOHSdA4KU3vw==@kvack.org
X-Gm-Message-State: AOJu0YxwPzk1XU6ePZQAZlODUJ+yRY3Biyj3eM3mmk7ktTsKX9PyMwLk
	hJqTsWXGJ/bN8Xr6LbzmVb+Pu+IiVZAaFucAhGL2l7Mxz8LIS8Sr+k63
X-Gm-Gg: AR+sD101kvdJ1o6RtnVxdRtAMBNyQZ4rVFyAvHwi2yCxhFTd9l1aRlqSxj71nDN+aOG
	XsJwzqGinyBJjAzHwC9Z9H1BmtQ+Oay8lCHUmd/pLpbvj7XANsnOPCYJdmGmjYehBaga08ZNso4
	ALqN6Ntmy63TgP7nOpj/nJB0vmoDLCqSgVHfNffYcSl1yuaIjDP8XKjmsDkLk4xuMm03KrrOGBS
	861YjPU8F3QyMYTDmkls8BhFdSRRWvqChPgjfheoZMZRiDXVdMQKqZelnyLZ3VzeZCz4VtRpjpJ
	r1n6WVkMG2Kp1McU/b5xnA8B74BbhPj08dbwUrs0zVKeuxFncg6VzTs/Zea8+NqgEr1J3chi4ok
	qC2SoYNDzKunMswigN3YRm5UU0Jxh1i27Pw+2NnN4/C0JfrEmegkWk5SWu7IXq7YxFZk6t8ysrV
	A2MxQbXceoEsfUSBTnp4fKIeo6JdVaA0FrzuB8F8gYylMUL4cMjzcRnAwi4rIyxXo=
X-Received: by 2002:a05:6a20:b598:b0:3c0:e552:f2d with SMTP id adf61e73a8af0-3c92a761f35mr7446088637.34.1785711257265;
        Sun, 02 Aug 2026 15:54:17 -0700 (PDT)
Received: from localhost ([73.222.46.22])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e18e70esm50339576eec.29.2026.08.02.15.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 15:54:16 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 02 Aug 2026 15:54:15 -0700
Message-Id: <DKETT5RWDAG9.1AP6L1IJ3CL72@gmail.com>
Cc: "Farid Zakaria" <farid.m.zakaria@gmail.com>,
 <david.laight.linux@gmail.com>, <jack@suse.cz>, <jannh@google.com>,
 <kees@kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-mm@kvack.org>, <mail@johnericson.me>, <shuah@kernel.org>,
 <viro@zeniv.linux.org.uk>, "Gemini" <assistant@google.com>
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: "Farid Zakaria" <farid.m.zakaria@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>, "Alessandro Di Federico"
 <ale@rev.ng>
X-Mailer: aerc 0.21.0
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
 <20260722011217.45e79a08@spawn>
 <20260722-raser-leselust-konsolidieren-05f8e36a0782@brauner>
 <20260731004604.53c66732@spawn>
 <20260731-batterie-galant-zumachen-d4b91acf8af0@brauner>
In-Reply-To: <20260731-batterie-galant-zumachen-d4b91acf8af0@brauner>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8255D180008
X-Rspam-User: 
X-Stat-Signature: b3pgyiody9xaoiecsdrabpfih7t1k5sq
X-HE-Tag: 1785711258-359742
X-HE-Meta: U2FsdGVkX192Jxxyw2fX8Q7rNliPpaZFK8iTiOorBxpXwEOUH8TYa10bvuTENz7j1z00P1paL24WwScnO1sCgYDbt7n4CdVJeij1FIY7JOMhfoIRHSuyEWqMWNxivdiWQPTTztqkv6ya4iJpMtdZdpRcE/HAIFdfMuYTO/uG8I2UzgRrHAE7Hh/DiYYNYdVnWYh/0DMsXQ0FEM4WmNj5bIo6L7mkWTBvWbJmcwvJFEiqBInzdWRfsHMOXSRAGQEM7kvy5ySfWRgVPNfKii1atFvAPVLtGb+KClnOnJazPAPM76+wrSnoLPftVa5hT72f8FCeqOqFENfo261eBUfb1pNCdHu4SATOgBrOAKyMCzLjtCENrgrR4yrKGU36lDfnxM3RBl6WyTV40+KAFb9H/C2UalcD11mqiuwH0tLgxfuGWCwaUjnH7MXpvBFVjCQN10GmkmqIDn1IFBlVL2J6WyctjKUy0EiibBTiXQ01C6O9MN1l1IEksSTeZZnVs+BrXwzPvw3H+eJp8ZwYcT4W3nupFm5lXKDaMDoiF9KVvzo0Sj5lgK+76EBDfYahgBlDtWt7CKdb7yQO8H6iDJ5o0IJzv18w4b/jiCcCWWq63ITuDj5JClJKPv+f3aBZsz/w5RQicNRgJ5tHynuGPHNLF8E7XF4xZknI0aFi3WiRTuIqVK9IuzvYunBQxXAj6UpXaajWJMt6QJSZEtNEZQYbPoA0KzH8b3QVo3+hdompV3ksG251xN/RIepAEBSc/W82S0oU+oOjfh79hz3/lqbuFxYAPykxqmLpCAwXQtpUC6cdp219XTuFjTBjh4Kxsxpnl5VLCQqdxw5OfZ72iaBEBSp9mEIAoDqm0vwApWjObr+IhzUmw5f968oo6zyfrkRbODWCGVxOc8j1nQfJEjEU9tqkFpehfnyAgUL174X8DpMcrrqxbbSD54qeCmhKF9y2WJdlZOTLVlgidTjHOWT
 OA1g3xRM
 Zrxly+YF8olu58K24VqypnW6gvrJLq+yb87OK6Mhz/YEx6HJrpDIBzofz1lIcs1oPWYHU9O9jy9DtzBTWfO1Xc9kkK44/Luijx+QacKPum7XZL8bmFq59Si0LHSK3RGGbNZZbsDiNZZyUeH2J8+dZ5JYp9dzEYk/P9FXKUdf6keCv/6/pLHcB+eZUbSSrxWYHr3x3nd75l+anolgmL2fMDtHk/jPCqk2vt7DZcAHOgxh09Yz0PIVJ3RUm6XnvVRorIM+/RTFvg75Esc9RISf94DGMh/bo6s8D9rPYA7y2XCjRsolSVMykzAFCNZQ6C+5mAxE5XpQmCqU0gUOa9s8zsMZCvyg2/K43gDw2jUVDAdleL65knKl+bR1Zc2EfO94Z5fbrgmWorhc0LaKyLjk5Hh7rMnPHB5Z82an17X69qbo49ClYVzHfx+cfNlV1DcUOD9jGxQ3FpFzpVUCaHXc1iZl+qvDl2tUfk0oDkBqhQ6XaIYHPC95REn4vO/icVZPQMov1Ts0Htp7vTUvL2haiZTkiANhCIB5CRvldxH31COqA7Rkc0vjm+vRQ9Ze046oCsDR0Jd2oy7ijyh96E3gAw4aAbkC1Un7E/VlBWSj0zBMyEQ/hvPviuHyx5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 31, 2026 at 2:41 AM PDT, Christian Brauner wrote:
> On Fri, Jul 31, 2026 at 12:46:04AM +0200, Alessandro Di Federico wrote:
>> One could delegate the feature to user space, but that makes it much
>> harder to get adopted in a uniform way.
>>
>> Will systemd, Android [1] and OpenWrt implement this? In the same way?
>> If so, at that point it could have just been a feature of the Linux ELF
>> extension.
>
> Whether systemd, Android or OpenWrt adopt something isn't a decision the
> kernel gets to make and it isn't one it has to make. Merging code doesn't
> create adoption. It creates an obligation to keep the behavior working
> forever. That includes the machines whose owners never asked for it.
>
> It's also not how ELF conventions get established. PT_GNU_STACK and
> PT_GNU_PROPERTY are the two OS-range headers our loader acts on. And
> they came out of the toolchain and we implemented them afterwards.
>
> The one time we picked a program header type ourselves ahead of the ABI
> PT_ARM_MEMTAG_MTE in 761b9b366cec we collided with PT_AARCH64_UNWIND
> and had to change the name and the value three months later. We got away
> with it because it's a coredump segment that gdb reads, not the exec
> behavior of every binary on the system.
>
> If you want systemd, Android and OpenWrt to agree on one marker, the
> thing that produces that agreement is generic-abi with binutils and
> glibc/musl on board, and then we can implement it.
>
> So we don't actually disagree about there being an ELF feature. We
> disagree about what the header means. My position is that the header
> names the intent and userspace implements the resolution. Yours is that
> the kernel does both.
>
>> Of course the Android people could disable the feature even if it's
>> in the kernel, but if the convention is established by the kernel,
>> there's really no reason to deviate from it in the way it's implemented.
>
> The kernel can't establish this convention. It can only implement one.
> If binutils won't emit the header and no loader cooperates, we've shipped
> uapi that nothing uses and that we still can't remove.
>
>> The whole point of the portability thing is to reduce the assumptions
>> you make about the target system. Ideally, you just want to use
>> features widely available in kernels in the wild.
>
> Sure, but nothing merged today is widely available tomorrow. Both need a
> new kernel. Uniform-by-default doesn't arrive sooner because it went
> into core elf.
>
> And a new phdr doesn't degrade nicely. On any kernel that doesn't know
> it the binary has no PT_INTERP it loads as static. Dies horribly at an
> unrelocated _start.
>
> And keeping a literal $ORIGIN fallback in PT_INTERP instead and old
> kernels or gVisor open it cwd-relative, so an attacker who controls cwd
> plants ./$ORIGIN/ld.so.
>
>> But from what I understand from another thread, your intention is to
>> use userspace as testbench, correct?
>
> Not testbench as in "go away and come back later". The difference is
> where the semantics live once they turn out to be wrong. Get a corner
> case wrong in a bpf handler and the distro ships a fix in the next
> update. Get it wrong in load_elf_binary() and it's the exec behavior of
> arbitrary binaries... which we can't change afterwards.
>
>> > This is policy that the admin should decide
>>
>> Agreed, but the admin is probably satisfied with enabling/disabling,
>> not deciding whether the program header type is `PT_INTERP_WITH_ORIGIN`
>> or `PT_ORIGIN_ENABLED_INTERP`. Same for the distro maintainers.
>
> Nobody is asking an admin to name a program header type. The distro ships
> the handler and a file in /etc/binfmt.d and the admin never sees either.
>
> But note what you argued here... If it needs an enable/disable switch
> then it is policy. And the only question left is what the switch looks
> like. A global boot-time on/off is the worst available version of it.
> It's one bit, machine-wide and can't be scoped to a subtree, can't be
> delegated.
>
>> Then, from a security perspective, AFAIU, implementing this in
>> eBPF does not solve the problems that have been discussed.
>>
>> For instance, `selftests/exec: add binfmt_misc bpf-backed handler test`
>> does string manipulation (no `openat`).
>
> The handler doing nothing but string manipulation isn't a simplification
> in the example. It's the design. The program never opens anything. It
> computes a path and hands it back, and the kernel opens it with
> open_exec() under the credentials of whoever called execve(). There is
> no openat() to add. And fwiw, it also supports pre-opened binaries for
> really crazy use-cases where you want to pin a set of loaders once.
>
> The module RFC resolved $ORIGIN in kernel code opened the interpreter
> itself with file_open_root(..., O_RDONLY, 0).
> That skips everything open_exec() does and it achors path resolution at
> the binary's directory. .. clamps there and absolute symlinks resolve
> inside it. $ORIGIN/../lib/ld.so, which is the RPATH idiom everyone
> actually writes, silently means <bindir>/lib/ld.so.
>
> I'm not holding an RFC to final-code standards. The point is that this
> is fiddly.
>
>> Overall, I feel like the current proposal pushes back on having a new
>> ELF feature for security reasons, but then delegates to distro
>> maintainers who want to use the feature to take those risks.
>
> It doesn't delegate the risk. It binds it to whoever wants the feature.
>
> Whether resolving the loader relative to the binary is safe depends on
> invariants of the deployment. Is the tree immutable, who may write to it,
> which prefixes are trusted. The kernel doesn't know any of that.
> /nix/store is root-owned and immutable, so the policy is safe there. The
> same semantics pointed at a directory the user can write to is a hole.
> Only the deployment can tell those two apart.
>
> Userspace arrived at the same answer, incidentally. glibc expands $ORIGIN
> under __libc_enable_secure only when it is the first path component and
> the result is rooted in a trusted directory. That trusted-directory
> notion is exactly what an in-kernel implementation would have to invent.
> And it is deployment-specific.
>
>> But also, distro maintainers don't really need this feature because
>> they can just write /nix.
>
> Right, and that's the honest core of it. The people who need this are
> users on machines that someone else administers.
>
> But "default-enabled ELF feature" is a strange shape of fix for it.
> Because the machines you'd be enabling it on belong to the people who
> never asked. This proposals is to change what exec does for everyone
> else in order to serve some use-cases.
>
>> I'd be happy to try to work on the example eBPF program using openat,
>> address the various security concerns that have been mentioned until it
>> looks right and then it could be loaded by default, but with an option
>> to disable it. But I'm not sure whether there's such a thing as "default
>> loaded eBPF program".
>
> And there is such a thing. The distro ships the object plus a file in
> /etc/binfmt.d and systemd loads it at boot. That is a default-loaded
> program with an option to disable, it just lives in the distro image
> rather than in vmlinux. If one handler ends up being what everybody
> ships, that's the uniformity you're after, and nobody had to freeze
> resolution semantics to get it. Could even be upstream in systemd.
>
>> Alternatively, I could extend the ELF core as a parallel feature of
>> the eBPF-based mechanism, reviving some patches from previous
>> iterations.
>
> I'd rather not, for the reasons above.

Christian,

Could you help me please understand how the next branch makes
its way to the kernel?

I see NixOS Offers the latest as of 7.1.

The topic for binfmt is named on 7.3.binfmt in vfs so my assumption is
that it's slated for 7.3.

So that means when Linux pulls for 7.3.rc1 I could start to test it on
NixOS? Maybe 3 more weeks?





