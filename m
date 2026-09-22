Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AB3C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B386B0092; Tue, 22 Sep 2026 10:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2F56B0093; Tue, 22 Sep 2026 10:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBACE6B009B; Tue, 22 Sep 2026 10:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3B456B0092
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:59:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2908C80518
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:59:01 +0000 (UTC)
X-FDA: 85241705682.02.E394FE3
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 479F41A0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:58:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fldmqn//";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of groeck7@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790089139;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBsYZYC2tty9xsMubEGxI75zG2Y/0N6IAo5rsTEyC18=;
	b=OMtzF2BJucK/El7vNKuZf3FRnFDldOV6I4y+fngxFgPKdwfpqlHyII1d27G9avzHnUjBvI
	m7QHl/ZtB3FG/FjO92Q1X0kl7rJlKVP2XWagk2mRAMbix4p2lnQiV5H7vYwbP7jWYYDMGO
	ajDNjVZG6vKMw28fBhi0Xk+U4FYWtlA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fldmqn//";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of groeck7@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790089139;
	b=qSFnfJWAPb+MKTwdH2993k9CXvyP+alKnr+5CiWcOK0KwlVGtG0yEJUCivUHn9tfffWkJO
	6DQURaQC3DUCANvM/hcfUmbuwbTDw1+KgHZzGT/cUdw4TaHQ0+6LQ/qWfusz5/P57Erz+L
	TyAdVPy7kv89QdwfxYIn5nO4jba0Nf8=
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85a4329731cso3399186b3a.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790089138; x=1790693938; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GBsYZYC2tty9xsMubEGxI75zG2Y/0N6IAo5rsTEyC18=;
        b=fldmqn//NkTCGa3OuunkKk7ZsNDFIjbDegzJ+Hqk/dlkxlJ+w3LF+YvEjW0svPZ6Va
         EWd2FuDvQBU6WF59ngUtrIomF2uBUN8g4eVwlrTGDW/mzlCZzMAaeLBVw/wWXj75n6MH
         rkOJ7qH7qRjaYC3GB17Xij6Th0cEFulZhgMlzVjPlPsU5l/1Nzkjtb58tlVIyehHK1UY
         n/yoK6ChRrvFXxMdniBuwNoRymvsLs1si0gj78aljNDI+V/AcM/03A7RUmhnJEAEzYqR
         e2m+GZkpprYm1EO9xcJczrNCUC++T3IM0IBkeFgvO8R3Wtweo/vTCB7p3wQHz6yuQVv4
         Z5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790089138; x=1790693938;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GBsYZYC2tty9xsMubEGxI75zG2Y/0N6IAo5rsTEyC18=;
        b=1NyF44LNFUZbKD/ei/lcwn9zvWv7Wz8syfucCkbKZJ7E+/3V64fcWtdFFCemlzT6XD
         OPHdqWoGQ/IdSez5GDUvxrxaDt+n5y/xvpbrvyv5e8v4y4YmkwY51rj77Ew9dQwIlPIy
         eakZ94aZ0fpNoLeeP6A7O6Bc0aASyoBoJ+N8zZOUXTezO4M/w4+f8uh9U9B93MT9zxQS
         I+Zp3JPWlRBTiRNx22T5U44Rw55RXBlvn4IAevFK4Ui6lZKJumIPRyfs4w+VTFYGOmf6
         0TEwnKZnUIaIXAh71nW137JoYD/BnHhgYGt9mtSepD63q5qMDnkAZzH47yGLl7PPqQb/
         I+FA==
X-Forwarded-Encrypted: i=1; AKwUvBw+Zg3d3KN1zKRouyVMMjC5FXTbASZPZ7BJEOJqHzAlbzjJa7VER2hhwd35diQcARpAEK3ErfBoyQ==@kvack.org
X-Gm-Message-State: AFuF++mUd6JG3WiNNpChQzGrmXBC3buBdJGBg3zbBp1bb9H4XGdgkeu5
	lJnTkUNbLRdZWxJxgc41d8DvsrYQTAWPzKv3nZUypShTTrbNktjD5lPZ
X-Gm-Gg: AYBFou3eKAQBLtn+YiFEl9/cmnyW9MZCDwKXdSgkqfTc3x9B9Rh/bSw6xNK1rJZ3lj8
	sdDrm1xYvb4j29ID8ZI4nhv4F4dR+1t1LXmXi6J6GmsO7znTIz7FmEv9Ur7nX+C+fr4G9X/iie0
	/jMoJ52JAmPZZVHaERPCILJfMuMUfdPl9Q7qA/qZR6YTPk/Z7EpilMShlEx/u9l058bW6go4Ru4
	9RbVo/66j87qv8WTArgzkRz/xRKaihaUGKRyi+xOkNYtDVt7npRyO45wUJt/+DhdgyivUIbevcr
	GjYQpLkpxfPbCjE4Cbc3XUGssAAAa3V2puP2y58ZdQncPZRvDMmNUryveY5mpcBEfrgzTFZy+Cm
	+qFvnyOjcViUctc2TIEH8D88P7W2QFKU1+cURCdyX6XsgNjb3FZOGQZda/DZb/j09u/2J0IfOpL
	Ci8ZXgqbjoph3sNILxfrAOQPjXQq4v691ZLYCQJIs3FEMz2F+FNd1bSnfq7OppehDnMWSAvn+Ep
	iSb2LEG822V
X-Received: by 2002:a05:6a00:8085:b0:874:708d:b620 with SMTP id d2e1a72fcca58-87c8403d93amr1485976b3a.30.1790089137920;
        Tue, 22 Sep 2026 07:58:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87c31ee8fb4sm1046216b3a.12.2026.09.22.07.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 07:58:57 -0700 (PDT)
Date: Tue, 22 Sep 2026 07:58:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Bill Wendling <morbo@google.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
	Justin Stitt <justinstitt@google.com>,
	KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-hardening@vger.kernel.org, Nicolas Schier <nsc@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
	Alexander Potapenko <glider@google.com>,
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kasan-dev@googlegroups.com, llvm@lists.linux.dev,
	Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org
Subject: csky ICe (was: Re: [PATCH v4 2/3] slab: improve
 KMALLOC_PARTITION_RANDOM randomness)
Message-ID: <6106aefa-47c7-4bda-a51f-8a2fba3bf715@roeck-us.net>
References: <20260511200136.3201646-1-elver@google.com>
 <20260511200136.3201646-2-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511200136.3201646-2-elver@google.com>
X-Stat-Signature: k3dwke68698g1wiaf18ny98we5whhkwn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 479F41A0004
X-HE-Tag: 1790089139-854158
X-HE-Meta: U2FsdGVkX1+7emIz7lQJrVK4/PmuKV2bDU4KayWam9gEXRcFoUZ+32TAFpmh3lGrB+7+dSyOzCeCqWQ57QTJAugOgVEnDN8jiB7P4nRqEznW8fRWuGgdwklD+jyqty4qr9lw+m7b6vCJKxOKtmoh0T+IFaF7LL/qVyzEW+1QObrIt4WBaa2wTHq/z8wCGnX0NYb7Fv24QASn9Tdbeq6i1aljkgKKU22gafgcdWeEVi7n1yYF/XiS7qHDVHNGmrN/2TyGQK8pIzsF7W5/33B6T0qBAyVRIm5YYkS5s7dgMwhe0C30Y/W2KhJv5MVNjaWilAvM4RNCHsh/byHJjABVof/wEKlsaWchGfG4EN5jt8cQi/98rqRbI5gR0q5lWccn1Z25dklY62t7FAjczBXGRuzdVjoEQmeFdhzJIzmSn0QKsFWjTkd2tXKIOvCIMNyzz1bPbR5mYn/DqaszhafPl8dyb4z5H59BtTAEgUE4F9PsEMGMjqOKRztvdP7qqqyyf4FFL1VgWYuHvo8EGJqenmnvuadCQZh69TrL7nXe4zK04M8arAnqHVJ8yoDD5GwY1miNVHqj/QDeWwNquffArVY4bEuOOwVn86wAG+D0aHIaCRedNoUMayTUt3ATc8JKAquURWAFSoz4YCXzSKWcAtIq7ydLJL/v0ld1IB3EPZZEMNFixkNprC/7yPgwUX+eCrfk1ex7CRfurYkFynpK562mAsIUr1ibB7d/UGDSA2wdW5rs/N5VYRb1c8ef3dllUXhaFezU1FblnifVo3MGJJpq8H+EZ81820MJ+8N0RHFeW6Y172NkXFosrAbgf5X92WdsGq/YoboC34KoichFIiOkul5NfwCTxPP5QrH4fuH9V92oPxqHch+cldMXkvNzSL3WL8QqGBVvHH2VDPPveiB5scS2RbIuHtyiAd7d+NwSFcdv7DQmF96P3DgqaR1lISkpObfDXPZDzQUsAGv
 0IBJ3nZM
 greewrjbMZ4biRJPj+z9Ju32XPGwTxocdgNCWDoKY7q6tOBValv/ws+ih/ee1A9hD+7XpoMZbC7fI2ghkWAHZEszqn2e2HCW+Z9OpHELma+lXnh1mzDRHJ2LqfOb0rGRaHSJxFycd0hSKkt3wWXXaf8eFq7duIeSulySf5YLOv9iPPXUfCShSq+RSE3Bp2WqFUd4p3/Pr0cWmqHnDFGcIiv3AfGywlGbQo0cz2UKBlR5Iyrwc7nzKVOR+DhsUQCapXwJ6buS+4ZRvHLJQlcG2A6UzQ4TaaqZ02SZzUrurC+c3UqB44JWTmYPNYscA2SMSuWOTWqq4JH6GtVUVh5NhfTrYrRhe4NFDuFO9+XEFBnEO4ubFLuq7zLAqtDktgFs+DP9qTQyf3VXmEiG5w2YPYogJCs0PR7+zSLYqicEY7Skr6huTFOgWj+plcl0D7Oy0+RjfyTh7egeEj33JKkCA3Jy5CmUleevKeQ9iVjsREiOT//Sa/s5YFKJS9kvbWH0jNmlcdtscQvHUtGRkof393mO1xgPOA8vG2ckTwoY/jb87c3nLNoWnXVKONx1bQeR00ZgF2kmWGaH5z+l8wzpwyu9HB6rL7WOViYEM+EvhyCY/7qfD5WqaFuJpcLNZYWDNRfXdxLIhrs0yph1Wvwg6FgmE6DvLrKRHfKvOHlh1S26BGAl/YbExmibN8/pqqQNYjrQWMTXLmMWal6QQeK50L71UnzfMQW0Uxaq5uCN6wQfVNKxau43ianqEKMd8rDl+I+H0q472B6Uuf8vgLeTs+m+u00zGp5gRpg3/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, May 11, 2026 at 10:00:49PM +0200, Marco Elver wrote:
> When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> to identify the allocation site. _RET_IP_, however, evaluates to the
> caller's parent's instruction pointer rather than the actual allocation
> site; this would lead to collisions where a function performs multiple
> allocations.
> 
> With the generalization to kmalloc_token_t, we now generate the token at
> the outermost macro, and using _THIS_IP_ would fix this for all cases.
> 
> Unfortunately, the generic implementation of _THIS_IP_ relies on taking
> the address of a local label, which is considered broken by both GCC [1]
> and Clang [2] because label addresses are only expected to be used with
> computed gotos. While the generic version more or less works today, it
> is known to be brittle. For example, Clang -O2 always returns 1 when
> this function is inlined:
> 
>         static inline unsigned long get_ip(void)
>         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> 
> To provide a reliable unique identifier without breaking architectures
> relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
> to _THIS_IP_ where architectures provide a safe implementation, and
> falls back to a zero-cost static marker where _THIS_IP_ is broken.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
> Link: https://github.com/llvm/llvm-project/issues/138272 [2]
> Signed-off-by: Marco Elver <elver@google.com>

With this patch in the tree, I get ICE erors when trying to build
csky:allmodconfig.

Example:

Error log:
sound/core/oss/mixer_oss.c: In function 'snd_mixer_oss_proc_write':
sound/core/oss/mixer_oss.c:1202:1: error: could not split insn
 1202 | }
      | ^
(insn 183 400 184 (set (reg:SI 0 a0 [orig:307 _55 ] [307])
        (xor:SI (reg:SI 3 a3 [orig:308 random_kmalloc_seed ] [308])
            (const:SI (plus:SI (symbol_ref:SI ("*.LANCHOR0") [flags 0x182])
                    (const_int 132 [0x84]))))) "include/linux/slab.h":759:52 288 {cskyv2_xorsi3}
     (expr_list:REG_DEAD (reg:SI 3 a3 [orig:308 random_kmalloc_seed ] [308])
        (nil)))
during RTL pass: final
sound/core/oss/mixer_oss.c:1202:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
0x779b51e2a1c9 __libc_start_call_main
	../sysdeps/nptl/libc_start_call_main.h:58
0x779b51e2a28a __libc_start_main_impl
	../csu/libc-start.c:360

This happens with lots of files, not just this one. It is seen with all
versions of gcc starting with at least v13.x. Reverting this patch fixes
the problem. Bisect log is attached for reference.

Any idea what I could do to avoid the problem other than stopping to build
csky:allmodconfig ?

Thanks,
Guenter

---
# bad: [93f51579e7df248780214094418f205253383cc5] Linux 7.3-rc4
# good: [7d0a66e4bb9081d75c82ec4957c50034cb0ea449] Linux 6.18
git bisect start 'HEAD' 'v6.18'
# good: [df8f6181ab57d65a99e61fcfc5be22a42df58642] Merge tag 'perf-tools-for-v7.1-2026-04-17' of git://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools
git bisect good df8f6181ab57d65a99e61fcfc5be22a42df58642
# bad: [093239070573637ad2b4cb56abc9c4c7ee109294] Merge tag 'v7.2-rc2' into togreg
git bisect bad 093239070573637ad2b4cb56abc9c4c7ee109294
# bad: [b85966adbf5de0668a815c6e3527f87e0c387fb4] Merge tag 'net-next-7.2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
git bisect bad b85966adbf5de0668a815c6e3527f87e0c387fb4
# good: [25447851777a53bd4b501e7f2cb418332ad584cc] Merge tag 'char-misc-7.1-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect good 25447851777a53bd4b501e7f2cb418332ad584cc
# good: [bd77e50c9a70f844d6073499f3d1a6fd193eae73] Merge tag 'fbdev-for-7.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/linux-fbdev
git bisect good bd77e50c9a70f844d6073499f3d1a6fd193eae73
# good: [972c4dd19cb92e03d75b66c426cfade07582a1ba] Merge tag 'wireless-next-2026-06-10' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
git bisect good 972c4dd19cb92e03d75b66c426cfade07582a1ba
# bad: [9b40ba14edcdf70240af8114092a76f75f070774] Merge tag 'for-7.2/io_uring-20260615' of git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux
git bisect bad 9b40ba14edcdf70240af8114092a76f75f070774
# bad: [0d8c1134936f1fb6678156ab4248ac740d274525] Merge tag 'v7.2-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect bad 0d8c1134936f1fb6678156ab4248ac740d274525
# good: [42a58f08b70a7a320c168a1ce15e3fcfc8568708] crypto: atmel-sha204a - Use named initializers for struct i2c_device_id
git bisect good 42a58f08b70a7a320c168a1ce15e3fcfc8568708
# good: [2c1ccd9a1d786503086e83fe83e5c3b3c953b70e] docs: changes.rst: restore pahole 1.26 minimum (regressed by sort)
git bisect good 2c1ccd9a1d786503086e83fe83e5c3b3c953b70e
# bad: [f8115f0e8a0585ef1c03d07a68b989023097d16c] Merge tag 'slab-for-7.2' of git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab
git bisect bad f8115f0e8a0585ef1c03d07a68b989023097d16c
# bad: [dfdfd58cce1c3f5df8733b64595448996c08e424] Merge branch 'slab/for-7.2/alloc_token' into slab/for-next
git bisect bad dfdfd58cce1c3f5df8733b64595448996c08e424
# good: [648927ceb84021a25a0fbd5673740956f318d534] mm/slab: do not limit zeroing to orig_size when only red zoning is enabled
git bisect good 648927ceb84021a25a0fbd5673740956f318d534
# good: [d196ea36a2f2118833ca648af53654553a4a1e7b] Merge branch 'slab/for-7.2/tools' into slab/for-next
git bisect good d196ea36a2f2118833ca648af53654553a4a1e7b
# bad: [e0f54249a491c62ef8196b9f13bd7d95dba47c6f] slab: fix kernel-docs for mm-api
git bisect bad e0f54249a491c62ef8196b9f13bd7d95dba47c6f
# bad: [0fc1bd38a19c108395d8338fb034f90c2d3fbe55] slab: improve KMALLOC_PARTITION_RANDOM randomness
git bisect bad 0fc1bd38a19c108395d8338fb034f90c2d3fbe55
# good: [feb662d9168b63e1d4c02671ec96005410c6f3ce] slab: support for compiler-assisted type-based slab cache partitioning
git bisect good feb662d9168b63e1d4c02671ec96005410c6f3ce
# first bad commit: [0fc1bd38a19c108395d8338fb034f90c2d3fbe55] slab: improve KMALLOC_PARTITION_RANDOM randomness

