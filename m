Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A26C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 19:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D4B96B007B; Mon, 27 Jul 2026 15:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD0D6B0088; Mon, 27 Jul 2026 15:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E416B008A; Mon, 27 Jul 2026 15:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D54FC6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:22:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 582511401B7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:22:48 +0000 (UTC)
X-FDA: 85035528816.04.D5EFE39
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6626012000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:22:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QVEexZrY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ndesaulniers@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ndesaulniers@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785180166;
	b=PcU+/xGVwn++GCO6/9GD80qdBNSB27KZVdRAeTrKtvCcDxsnctKL0AynAVM7EbLHi2Jxs/
	UVYz7gUHTFLV3DDqAI4T/pWfOdFoHqXG4Jurut+7sZQnKjdROqJpH6Ti9UJBJOKImbSR/F
	tzzktFyAjICKsLuXACtSPA8Deb8PNBM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QVEexZrY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ndesaulniers@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ndesaulniers@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785180166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzxsUu8EEz6aogAVQCyar7okPKydIEKaNYl3cOU+cbs=;
	b=joof1YDc0o/Hs5HFVkWIR+xuQGW61uHSHpXRvXIbvTmZEph11C9q8uwixIKZ948PoHRLzV
	rGdyU0rYgJFnF60hZt+EhQen5ZhBLwdL9ApxBFno0wqq9e+1cKA5w0RwbYP+tI+Y7k7Y2E
	33W7qHR75mAbvtDwEWPe83HR564UJF8=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1671ec8692so369896866b.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:22:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785180165; cv=none;
        d=google.com; s=arc-20260327;
        b=R/IzQux3b6TPMzS4f83BR44S7VV8b0XEH9K8KFpIRz1jf+dLVvi4lYdIrTDB/AAmbJ
         r8NOD/sSfW6YkHpvkutG4GwJCGOitVMsbppijUS3efPjwUZ/bivfiCCZ1bc2dsjtPxKl
         UwW2u/dMV8lTy7RA2Sa+XghaDe7bpZ7cJ/afYimbZK+z+1xLYvGMTk6/J5Oa9knPfT7t
         nluKoi3U7M4QyNxYXRRiHZEbAYjIeW2W9Ug2PGE2fUwS+6enXpLGDOq8auljc+0PZI1B
         zZfSl1GqHOd1ZHaInAvIxQFZNNJtw/iFNnmvo2HeEnUmWW4fCDZtTs5sAuJ/xgyyeRhx
         101w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PzxsUu8EEz6aogAVQCyar7okPKydIEKaNYl3cOU+cbs=;
        fh=39fSgkaEF6cdJwWf6m///C7AG2NW83lgh/JBO8so6Z8=;
        b=JjphY1GoJcWP9LzzCjDzunxxj48nNbxs9PGc4+9Y/KwhTc8e1Mq45OMx5umtYvUdUp
         aYus5AytEvpJi8aZ2p7z5FpU5RLmuH3W9vpbkLSdHQnNK1Qep1OsO/jAJff82wSgXgAT
         foR3EKWAQ5RTd8nCo1WnmyXQBlfD8EcJrrsVSC89WiAx8qmVd7vmchCWo+Im7f8imO04
         dNCxVSo72SCcrjFuw5ZIYZsQ0hOyfHPLBeCYsD6Vq2+ODTWrs/icAfnrYDVAtKdJ0oj7
         SViqCKXj5mCAwNb24DFxaxkGSZY3WCOzPEu+BqH8Ly+2FbW5FNOyfgMInYn/Tf454iGr
         NTqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785180165; x=1785784965; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PzxsUu8EEz6aogAVQCyar7okPKydIEKaNYl3cOU+cbs=;
        b=QVEexZrYwd2wTXlHzdwnVa1LFGJQ68yv8l109v1nd6z2S+aHuYH4MO9j1wgqbOzUpk
         TSkRrlw6b/Z0UL8z82RJdKImhxztTabeB0urke/jTFB6+nEHf1SIRX3Q4S8X58RpCdzt
         ku4RNVsiFVxdTrP89t7zdaydRi+5HIYo7Ficabb6ve/EBnlnnZLWxyduO7j7FIWo0b22
         YAzalmefxIeGpVBQIpY3YYE95TPHj4dST86z7v2syWxXHFRWiqxh1Jnpa+3zjY7BKxa7
         O3hcozimFY7ejoHEHY2VMT9LFgoPkMJ9f5JZLpjKxppbP67g4l5vN+I8yMg2Kq9EsZTB
         ZJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785180165; x=1785784965;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PzxsUu8EEz6aogAVQCyar7okPKydIEKaNYl3cOU+cbs=;
        b=OGVugTyhPuCaGgUdPgX62LW/o4atQeIgvyyVH0xZk5KVWzlOj/8VFpP10/qh/3+76q
         hJthHj3wNFPuX0+JPbLoMOrUXd/ujbMOhZk5f9FT13m0QFhSEUkA3q2S3iVVAS8tKsX/
         5bNn8GwS6m5F2yylL9AdX1gfK5zxh2GObyxjjgTi0nID0VzZ+AQ00G2ZEwLTOddlTmm/
         XRWfWDNfrpilxORH31COhLiopFvD3QmAs0poT5SbZofupZRwzq7ApwLJGlT5SlFvb5C/
         N7iOz1ZKStKb8+6VczdV+R+gfHI1LrIcD2VPuTNKYXs3tibiQSrB5dV17p3keOB4U2WG
         JKKA==
X-Forwarded-Encrypted: i=1; AHgh+RoRdCF3LZs1gfTjbOSioCDVRqOs8PbSup5l0OFO3nPMLWCOvEQMLW1t3LrsWPSWoRIS5zYn3RyhzA==@kvack.org
X-Gm-Message-State: AOJu0YxXVOti0on3odY5JYjOukNaaj0DrvKQ74NbN+AWKAU6Le6rjNCn
	TImr6nWZMTpZa9kVjRHHR2c7guS6lDHoYWaknBFoAiwOHhmQdrHZYaa2vx+DuT9+VydDyqAZ+oA
	dpi3g2jnORamFXAB/yCDGHdgQajdCCvdf9iUhNGi3
X-Gm-Gg: AR+sD106uLfpNAiOXvqYrXJcjwft8gJFK1wlT19hQrNA40wTvfOU3asGlgo1Y4E6fA1
	PAqUStUyVwR4Mm0Eo6T6kPXPzV8+ioAq7uJlq1ldHIXNu5iXZiyNQeYAno/TIw0KdwpfQ73BdCu
	6OwjF0+I+zNET3p+yvHAs4xTIYlGOrFag4jM6u2g8563xhwWkiYXVsVWhHnjBHT2j/3gFw5nnnz
	I85rBxF2xgpIo6VyCd09+GqnzjgA0hL0724txbHstcZO0F3oPMtkC/UURGDdZFlA0+lqMCDZ3oU
	zaZYOh0B+MDmldmxeNh+qAAy/U5sDRZ5Rc+uyw4Tw+stoIigoJ2irJlNg9X+TkgFEGcKMUjuYA=
	=
X-Received: by 2002:a17:906:eec3:b0:c1c:62b4:1ebf with SMTP id
 a640c23a62f3a-c1f692f28c3mr17259666b.60.1785180164098; Mon, 27 Jul 2026
 12:22:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1785153469.git.hongyan.xia@transsion.com> <eb38b41ae1b3216ec69fb45555ef5df57efd7b8d.1785153469.git.hongyan.xia@transsion.com>
In-Reply-To: <eb38b41ae1b3216ec69fb45555ef5df57efd7b8d.1785153469.git.hongyan.xia@transsion.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 27 Jul 2026 12:22:32 -0700
X-Gm-Features: AUfX_myNeo2p_4eMOzizBRqY-lBcfNbJZ5LCrTo2tmMUomZNZli_Ze8j8wrUS8M
Message-ID: <CAKwvOd=HeG=z1j2qB-SX3NQ=62ERr=KpQNZyqqp2Qy4kZ54RLw@mail.gmail.com>
Subject: Re: [RFC PATCH 9/9] arm64/debug: Mark debug exception helpers __always_inline
To: Hongyan Xia <hongyan.xia@transsion.com>
Cc: Will Deacon <will@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>, Naveen N Rao <naveen@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Nathan Chancellor <nathan@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Jiazi Li <jiazi.li@transsion.com>, Pu Hu <hupu@transsion.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i7cjwwyn6a7dr39rbjoyspdw9ayn315y
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6626012000C
X-Rspam-User: 
X-HE-Tag: 1785180166-349607
X-HE-Meta: U2FsdGVkX1/YapWyhSTsq22j4p/MzWSZ6m3nXuFxeL6Dzjrq7P8Z4V2QgE8F5X1viTokNXIgwmupZgXHxYpd6T8D00t26rtwFd//x9uRGNo5g6SQH4tsIiObtpUWEbfQApenJ4ikZPGfnnJaoaYEF6e8dOgnM1Pt+Tbok6RufQL66mnF/ZaWkC9LQx4XG2opFmYkkv+Npmx5vaPZC6SyPPlHHM0+4oOzyyPKP4+k1VSzTkK4xtK4P633jk16sNIUlchexcdU39f2QSESf6BEcOAHcvVRpEkq/qqqaO13mIaZ1Nvw1sgNIK0WlCh8PwbH5EH0+IAlh2+7Zp35BAZrhR4y93JgsMj1GhROaU/PqK0f+1DNRLqz8rt4Gxdo4ndGGejVai4Me4B955t/7tD/DtPEIJMj3qek40EuqoA1/+80VU8KowOJZWMV3P+YwNOXcjDfB88EUX1hGqRUoYnaiVPXndM4eWeOk6njSJQusagak7qWjpxfRVOT+1t3gOdnLc38WPSONeoleK94aLajTcTLujTQid92Uu0STcS3uEwM2ywasM9H/+HLcT/j8O1U+2L3Hl4GQ+oPB2UF+gLu/0zzgIl6+w2W1akB8dPQ0ZraBBeiBS1tXCu4zBjxAVD55e/EgFFoNvYSUyvetqQX5G+bzvZF7jSUVWxEdBXdk2L5hj4qOmxr8kefxefUXOjwFZAE+4WLEDZAjW3Zcectv3yEH1Jdb8bbnVh13wB1es24ZGliEIXWU126vuGv+YXQR/UsWxjyDya1hoGEJn9k3CUIHMnkbpgsulovODqH192ojWwXeMO6HWhMY5E+gX5NSntMS9gclawOMvchjy4tUArR6BGWnCG/exooA2AUQfJnRzLAZlnB/ymrVC9Y2ftTKoFRljl3LCPV0fIVoZJ7eB+fJfzuo8GldcUZMHbM09o033ecvZC3TolVIyP5E4sydHOyIaRfq62LHQ9UhPi
 kl/XE0s3
 hdy5GKpyupXM8u6P5cq85Nigug3zQHV7JE0KhW1U/urFI33FZJZ5XALsXqiw8ivmtdtpHwn1Q5KH/ImcsJYAsA6lcssFKWHu9Y4XTIuzkzoOfMRAHvwnEqHMH/nI7yI+6JteHCki983ucGct/gpgL5q+Va+8cOhBYblGpOmBYfee7yUaRkJnEpHT0mF7mMcrr5jR74YkQmV6Km2LZwdMotss2ZGrl1jVDcuSxT/uAyTwJsI/QxXgAbLjiUHnFZHtpg7+TWIB+sXppDJaxQdkm/pIVvthkFzYpd5JNnHMrKzyPV7746X+axqyB3g97aJ0ELeafhHRfueMaVJUOR30JbXyTw/ma2bZ5y+SahfF3WvjL+RiMnlj/hywPF+qFE73oGq+4ndLW4/0ynac6eYoASsz4rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 5:25=E2=80=AFAM Hongyan Xia <hongyan.xia@transsion.=
com> wrote:
>
> From: Hongyan Xia <hongyan.xia@transsion.com>
>
> Static inline should be enough to actually inline functions for most
> compilers, but my Clang-19 somehow thinks it's better to outline them.
> These tiny helpers then live in normal .text sections instead of
> .noinstr sections, violating noinstr.

Anything special about your build or config?  For example, we've seen
a recent influx of bugs around AutoFDO not inlining functions (despite
constant propagating initdata constants into them) leading to modpost
errors.

Can you perhaps share your config so that someone else could repro and
take a look?

Happy to follow up in our issue tracker, too.
https://github.com/ClangBuiltLinux/linux/issues

>
> Mark them __always_inline so the compiler can never outline them.
>
> Signed-off-by: Hongyan Xia <hongyan.xia@transsion.com>
> ---
>  arch/arm64/include/asm/esr.h       | 2 +-
>  arch/arm64/include/asm/percpu.h    | 2 +-
>  arch/arm64/include/asm/preempt.h   | 4 ++--
>  arch/arm64/include/asm/ptrace.h    | 4 ++--
>  arch/arm64/kernel/debug-monitors.c | 2 +-
>  include/linux/kprobes.h            | 8 ++++----

It might not be appropriate for the changes to kprobes.h to go through
the arm64 tree, but maybe it is?

--=20
Thanks,
~Nick Desaulniers

