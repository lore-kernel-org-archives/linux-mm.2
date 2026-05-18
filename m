Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3666CD4F50
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061B66B009D; Mon, 18 May 2026 14:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012A86B009E; Mon, 18 May 2026 14:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A426B009F; Mon, 18 May 2026 14:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D55936B009D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:19:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A107F1A09A8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:19:54 +0000 (UTC)
X-FDA: 84781354308.08.E117063
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id ACB7F1A0004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:19:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pJ69/cTe";
	spf=pass (imf19.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fmv/Ht8Pb5ForKew/DCgFtt1pcAkrp0oUM4GYdjaDo=;
	b=uc4KQBIQHKrc2P2Cal/WVR6D+06ARJJY+J0EWC9od4mkCR6WZcV2PM5MZ1oJ90JGEcpcO/
	2oJydOZ58y6Gia4i4ijSFPQeUynecmtqf1oq89Qgmcw0Z5wni5b2ShKZpDIS9GHWOuvXtq
	wewgUbhgmC8oJU8wwj3MDVJVxNywb6M=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pJ69/cTe";
	spf=pass (imf19.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779128392; a=rsa-sha256;
	cv=pass;
	b=blegCiBnvIXCr7D5RPrwSMU3lPaJpmvwVcJAS3R8aMYh+9hPj6qyV7k4xyHk9ZQGBZRYPV
	slZQdW2CZiJ4DXb5/NuSKtlCFiAyEdUS1qhUyduQvDuATJ3HRRSD8Rttl5PtrTUgsoyKOO
	ycaAO4GldHZDiJ/Kzy2Nx7Bp3qaQsi8=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2bda3b4318dso196263eec.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 11:19:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779128391; cv=none;
        d=google.com; s=arc-20240605;
        b=PjjyczdELok0e0NdKObXUKZ3tTf1vz0DDn0J8x/E/a7zj6n2Hs1PaG496uOsY/GktL
         65+cDG8WsEik0aNyFxvZCHpxCJvcbLY4hPgSYrcQreWZp9SzWUAlJvTLSSCYDiqF7jqp
         D2loatfsgO00CcWgH2bxnt7cBuXPT6cBYsBlascFcn2HOEBcQFfaBpTnj5+kutFuBMIA
         g/TckUQeMMQwajLk6w+Z53NzN6/EKxJLoPgdXpPwte/VdU9Y43d8MVa+KmgiPmg+QXCo
         jndhwhPViXjOrvHMEBagXhFF5cgIoHGJA5S5+b0e8ubA8+5Nigkgm8TNTaGvt7/QDStI
         y5Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2fmv/Ht8Pb5ForKew/DCgFtt1pcAkrp0oUM4GYdjaDo=;
        fh=LOGRffxtuRtxVeMn4GR+mJp0XLzr86Z+pxmVhfca1ds=;
        b=fxxMD/Mbjo/QNrsHvutwhhPIdQuQdBVisseCWO7dsp+bt5Pcf+f7lsKxVPf2AUlGTn
         2Vc9+la3709+W2PAYpa2A8G76TZ21gt4iupYtGjyP2mMngCZQhaOQktpswTBkHAsrLyJ
         AFABBAQy4Q7+uBudL2EiSmGOyXmCP+5hpMa0jwy8DjS4hEA0fRxUvJ8Hxw26g23amUvB
         HrPhNuxmWbXZqM+mV5z97rgwQ9iBBaI+RR7ma0+2Mjvr3voaNnmmD4sJpS6re0zaEZhY
         USppjVFTZ8jmC6JeB1E2SmSKsfhKfUjIrBgp0FOZbgiOPLpH7fDQbuxnopxuC5lIgSCQ
         GBAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779128391; x=1779733191; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2fmv/Ht8Pb5ForKew/DCgFtt1pcAkrp0oUM4GYdjaDo=;
        b=pJ69/cTeYBJED9+Ioav0Rfd4SbjixQ7IGBjl3r/0r7tED5IBXPMWLSIWNhG+UtXXDJ
         VlLMql28MpjIr0eQd4Kkfw0EdXNE8ZsNe/08Bto8WPCa1QGjJRvWIq0YQIBJUhM/wCfj
         8thqQ6szV69wHF3gl4jh0zBbvUpLXckTxkDizPBCI58jyD85iLFOZ1uvNUZ0vlpsgg35
         +kFX5uxIgpepRlLanMvWGp4CbaIuoiIU6qGr1KU6MrejPit7005pJ9F0uZ3oKiz4PJqq
         y8MTjfH0LloaAhxMlc4hu81K1qC1ouPG0BvKFmtVjxK5SAEbmRnvkr0M7N9tYw/lE1WH
         z1hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779128391; x=1779733191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2fmv/Ht8Pb5ForKew/DCgFtt1pcAkrp0oUM4GYdjaDo=;
        b=WomDvZx3+CSp2geQ6PD4k51Gt6cDOvbyd3O92WQC79Su+TvgWHnbHPd3atzWkN2317
         VA6uNGP4imFZSreAodFgIKukNvy7s6t5X092hR9diBdrWx5WGobVTP+xC2FY6tg6sMt/
         oMVGwt3s2polHBMtvE7ccMe13efaQhYfxSgc2HL3c1pepQ0Yu7n3duSLKXlPsTaFhM8Y
         COYhD7ExkVfvDxwIEOwYuyG+hACRF78+dCxI4otY+7q2Oye0OTryJ6S5cvP2p6OyHgE2
         v5pZMDSYpNGBDvCRFD8GGz2IbVaArpP0YyCSM+y7qqxoIFG0ZwSipsmO1YTjP/1SiDIj
         pS8Q==
X-Forwarded-Encrypted: i=1; AFNElJ98a8t2V6ksKOlQnTHyGqnJqxsTDgkpJL9BlGTsZ7lCKRSJq2nIEwL+4hrBqcnM8Dx/Xt2OW0RhiA==@kvack.org
X-Gm-Message-State: AOJu0YwuZgq9An+nPz4hc184cmi9Q0wWDjBXpGhcFIayGJmWG/cBDWzD
	p7QQSeVlbhJoILTQJRtoHvoXOq6fQ5WnHdv63f97iw6CwzLPKF/2rge9Dgn3VpLAuMIwg7u5Yby
	TQAQn3SWUKXymxhgKn1YXizr7ld15xcE=
X-Gm-Gg: Acq92OE4KangRwGHVQlyuHXh/Q8b7hWsYkM4tpwBwazTEPgb2Yfsk+n06p7XGQ4/3E9
	KS7Nk1a9zdB1btGgWbIdemz1wxfc5BV0wJGtKU6b3O46B5GQ75U1ly8m0ocBYxKly4EapouK4mG
	rLQEFVncojlBSrESqmMOzfTkGRAnLo4McCAr12jltW4ATCMWhwW3AJczdDRJnFWrbJAF6Y3Xnk9
	WXZpuSRD+yzNHb0k/1QF6ilcW7vYh4TqBJUcIRix/Yyb6matH6bZbN7immnMiFSD6AeyjQHe8vi
	vMxYk+SlUfEg6JOU+ZGYH586iW/oUNCvA4bM42z2ETSkOfqHJ5B4cH/PGeblKtF2N+JveQEyS0g
	Dn3tENSPQbm+6rpfeyx96MpE=
X-Received: by 2002:a05:7301:290d:b0:2bd:d8e6:90a0 with SMTP id
 5a478bee46e88-303986d60f2mr3837379eec.3.1779128391385; Mon, 18 May 2026
 11:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1779116497.git.d@ilvokhin.com> <1854fc006c03647a3201a442743a1c22b13b404d.1779116497.git.d@ilvokhin.com>
In-Reply-To: <1854fc006c03647a3201a442743a1c22b13b404d.1779116497.git.d@ilvokhin.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 18 May 2026 20:19:35 +0200
X-Gm-Features: AVHnY4KjxRD-ATRdhbSHbi3LsNcRUTOOYVd1vfhW3urYgmIkyWa8d6ZcWVPY-W4
Message-ID: <CANiq72mG-EpBWbW_hZYPgtV_R1vyUBsn0ytaz2X2Zw9fr0keOA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] cleanup: Annotate guard constructors with __nonnull()
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco Elver <elver@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: ACB7F1A0004
X-Rspamd-Server: rspam06
X-Stat-Signature: 9sk4db197xq3g6wkc4h8knk578injqi8
X-HE-Tag: 1779128392-355271
X-HE-Meta: U2FsdGVkX1+x++sYTZmaYsGJqAd4ErGqp8MRLml6Vwi0kL5h6RHR80Xi6gienCyJ1533tNXJEPXqKLVC8ZqrPxOHYeSP5E7jaWLd9eBcqOBKJIrretKdPy3hrS9tT13LNefMhQY6XoGF6MN4ShquG5tIZ+VNaibBssnVuG4LIrE7kxzCIzgBrcM0iv/oMQHyWdhFh1IZ090qXzhjkIwrFSXP0G9S+uLZjBU87O1zg1kOV0gos1hV63VEh+RIpmWzO7A5mTr4+OA3d9c7ad7loQB3VgYmxeJ9BXk80GgRaMXHOX9uCRPWxKp1tOnJO8tqBoz7ZzCmMz6ACn7rUIxyA9SjwSFne5gQ438hRgQzYgb78VrGAoxqLODO+UPX3q7WWVX4pqRSLKz1mWTETw55o18H17pvQEm0BwY7b/VemWRt0KJRpCCKfyPtH2OjBWDNV5KANwMuyFRScdLvGIUCBNYZD9V1VRtgWrJr4kMEBuEpA4uEgrSiAVs47r59MJcuf3uSakes/d3z660xLtHbHQrC4hRV7ejUyUakkRqPaXwpLpWsjar3xn/LnOSHGnbfNUfqyA5wAanmIh5eKOCvs7yE+haBHRJ5GEIgU3zhIf/p/dYBKyYwk/gxWWdJAP+xVmOPMZ119J77PjKU2o/R7AapcUS/QUoNxpuGwKJuxZt9rXQKU8vCTVSHO8XSHOScG4E5+kLonlLgPdnAGrhoqp+AO5WI32Vt13TEVACTdZDVCJ1NuoldXgysZ+5DOBz4s06f95XMUU0d8UjP7CXv8b52Gc5LCj+17gfEhMP6vqPqjWNNFoGNDI5mhl1L+m2Ox8hq/1tOUaIN1UN7PcRzonk5ZdMzPSbDK3UvntBWdX4gwriQlU5U27t7Yx2wis4egxwjsOGMKzpsRhp74poCMoArTzmtWX5mWufWN6q+j7ZKCDNp/sJfslYgWH6e3JynLRbuc0fXYIhu+q7jJP2
 s31ylERr
 nOFOjcatZA1a6V17Pdp8wzIPKTrj/3ExWZuZrHm5W1HDoPwQFVPdXCbIaJnoU7gzwGSF/NmuCqZYsoUDRyLeS4E5eOKtWjRDl5m+SLJ+TbfIgYQtY9gWf4j/GIClqfZEEEh40qTyn2VXgTvct1S+AI5UCRRLTWsyKssf6cXF+3Q8SfQEKLdEme+mKntzaUj5QbxSLHnoJwf9ePT7Kq8KRVqS4/tXg2qB/0374KDpOG09wl/vsXpSjq59ZCppP+CsWD/zfM3r/WvqhizJoLCM6RJCbyMPFUhVsO7dC/JO6gmnuTfRlkxrPYQxRTwfUxBOBiAwHkCMSGNM5p+BLpIJstuowUMLwdOPWq6ExzqFsbeWXwejS198kNUgXhRYkvehh41+5P8WEkeFz6eCxNBB0oPTka4QWf6beUMjz2PduZzaCHdENxn8+XTB5JuI/tV6pvt2jdAhMRvEyENHw0wN9kVcVZiOC+J/vFiNA8u0icT32xK/LuMB+XY+l0dgsHBUR+cg2mj2MySN2PWUhY3YeceCM844KEdrZIhu1RLb/NyCTTXN1zQI7fWueBx8jGuhGCkPEmt5XIj7kAQyk7fJ3n3x58bWcTIKgkS2Kr7VGyQ7AdjgnoK4u+w9TWVZuBm2tgf1zjhy0smyNE3fw2QSVAXkbBAJkylCEyqUtWXPGrGyfTGXUU2J6uy1l2KphbZf3Fo1+amZ68jLFyN9UN3Lh1bCdH/mEXKl9tBrmE+nni46OiRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 5:22=E2=80=AFPM Dmitry Ilvokhin <d@ilvokhin.com> wr=
ote:
>
> Add __nonnull() to unconditional guard constructors so the compiler
> verifies at each call site that NULL is never passed:

> This provides automated, compiler-enforced verification that no
> unconditional guard constructor receives NULL.

I wouldn't say "verify", since the compiler does a best-effort here
with the information it has statically.

In other words, the attribute does not prevent NULL pointers to be passed.

> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.=
html#index-nonnull-function-attribute

Hmm... It appears GCC has changed the docs in commit 6e3c137f5dbb
("doc: Merge function, variable, type, and statement attribute
sections [PR88472]"), dropping the per-kind attribute pages.

So the right link would need to be now:

  https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull

I will need to send a patch to fix the other links.

> + * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull

I think this link goes to `_Nonnull` -- the GNU one is instead:

  https://clang.llvm.org/docs/AttributeReference.html#id10

(I don't love the numeric IDs, though, since they break, so I think it
is fine either way -- the `_Nonnull` is fairly close to the one we
want and I hope that one doesn't break)

> + */
> +#define __nonnull(x...)                        __attribute__((__nonnull_=
_(x)))

This is indeed available for a long time, and we already use it
elsewhere in the kernel tree (which would be nice to clean up
separately).

If you don't mind, please place it before `__nonstring__` (the file is
meant to be sorted by the actual attribute name -- there are a few
instances where this is not the case anymore, which I will eventually
clean up)

Thanks!

Cheers,
Miguel

