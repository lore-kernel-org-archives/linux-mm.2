Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 397F0C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BA16B0121; Mon,  6 Jul 2026 04:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20CC56B0123; Mon,  6 Jul 2026 04:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC1F6B0124; Mon,  6 Jul 2026 04:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8C106B0121
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:53:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 635DBC1B86
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:53:44 +0000 (UTC)
X-FDA: 84957738768.30.1087599
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F4361A000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:53:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ddSG0rTD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of lin2530632123@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=lin2530632123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783328022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SMlqwe25h3RpyADH7goCEFp4DheUHmwSZ6Owz1SwkyM=;
	b=UN58r9QQ61j78OcuJ7BN6EavZf9Qk+e5voTKoyxgNRHGKuW0ZuMvjrt4hGNSPS78nh20Gc
	Er67i/Qbm3mxWWcdBZ4/Lxl30Kn8OPEL0esMPlFkZ9McHB+STd24BjcG7IaIUDq1t8upvo
	gVbSL3kytA82zrrXdxg9MVrFxoTTin4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ddSG0rTD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of lin2530632123@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=lin2530632123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783328022;
	b=CCfCP/4GLskrkb2S2wLRHbXaRvUIP7YV2zoO80HAnAsuJCHzFSRm0SgRcnMC3qKpMq+dHE
	nIZ5puMj2b9VOqTMuNiQMxM6o48DoSR5CARYRNPRdEjhCFlKOqSwscLCWyu7nw/Ip+iOub
	jiHPzry7oP6brgUmllz45OSBE4zdD4c=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aeb91c003eso2967015e87.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:53:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783328021; cv=none;
        d=google.com; s=arc-20260327;
        b=JZL30W0OMk7vEHHtKsxezH5Id7o6AtNrJcLbPGFbeQEFXhcrt6jrqAR67+gzYi0LC9
         YHhg+1NdQsuT1ShnsUfEMA0bJtJAPowmJ1YHirH1V38tssETCFa0v5NDLHEiyAsVqNRy
         tD9gGVxNzajt+0wMjh50UxadPfFWj21Lecfq1AjwP1h9f/9L/DqtCieMPTAB6zsH+VHY
         7mXacIYK02AV8l+prFHsqNrvIqTXgXUDxWqPwWuyzgL+qSjMr8EI4r5cqXbpQscPDu0p
         WsGxEGEyo6yApew3oUxn0n/gwY1c0ft7EVkvAIRsUoudh1tEN4UrRlOJR4tvw5MaXMLK
         GojA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=SMlqwe25h3RpyADH7goCEFp4DheUHmwSZ6Owz1SwkyM=;
        fh=I4sq773aZxxMlCvPjLS+BYZlV7H3C0ahdc83XaM9Q4E=;
        b=qNcbkLRrsn/E6TEBszzPFHiBHE1jbI0nTyNc6ZbnoIPdx+SYskMLRPRqIokwEZSx2x
         lwoDeD4SLMEI0hroOTZhxc6WIkFpm4ypGixawZoNj68DR1hdoxnG70HxgfOgBHSJj5kq
         Di5B0xSZ1leCrma1wMP0xWg6iLGY1tHFjnP+LpbANKPUVSzsLRuKRs9UnoMA35Iopkxy
         /jifNIsLPzIBxUxSa3Jhfo4ipwQNF0ObAVJVBmQH63bnB7lOJCO06yEasin8E0uVHrMy
         MOpNp9UexkisTuqM36zEQQ8wpX0czsxh/4dSGnc76alv5ui+/taVdg+KZN3Bkl6t3Xq0
         lt9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783328021; x=1783932821; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SMlqwe25h3RpyADH7goCEFp4DheUHmwSZ6Owz1SwkyM=;
        b=ddSG0rTDeVFZG/7Ov4fZ7vOpy8zwiWn8utLT+Bu0hI4Up9MpvKAZEgoNa2FN0YF3KK
         t2yshlAyqWrDOR+VLdNFlnfV42sL3RLaPjD+erkJiAVlzCQfETYPduIs8VXY12wfc9MY
         BJm6DjA6cCY3TFO+LnAvzdB0D/xqhVuCn5tToTsCK733DbPuTpX8gikDLm78V0lMNYsp
         13kQygbEhRtssgk/2v6GOMCJtCMCV1hK9ZhINYG72ex/ovOuiI49GWwdgdxJlvyZNJjo
         i7lmePg7vkspPvxWZkGBc8lhjSXyqMjwrqr/lDF/JoS0rMNBxS7imZ3dfBGTkQf2rfzV
         w3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783328021; x=1783932821;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SMlqwe25h3RpyADH7goCEFp4DheUHmwSZ6Owz1SwkyM=;
        b=hecHYGBEkMzax2gGMWUj3IhQunc/dd9wewJ+FPzODvYLg1XkYZ0m8w6h9xZGLDHmex
         Z2TRxRREWWqXhELQVF1g94wXRlCq2OD1PY/6voSuTOUe0lNAsLnwPQarN9o5mE/VLylJ
         H5S6So573YPOs41bJ6xWhuvy7mWCnqQXa+nw71AYsTSgKZeG9OOynoYCSDB94K5wdsVW
         3wEiX7Um+b3GaQvp2iAPZyc7otb+iLqn9mi72hovZZAA3IXw8mSOiuxOLBI6GvkSTwaO
         dfjnbPf4W6mPwS8Wqc72I4Yg+OrTCyt/7fQnlP4TDNDG4iEUmceN0vyBUFQI7L+UbyoL
         r6pg==
X-Forwarded-Encrypted: i=1; AHgh+Rqy89lFZ7tJIBbH5/fvuqYauYjohu6a8z6pgyxTLwaQN85F+b/jhGPycLWd3hA3XBr98R4+ZnrHPA==@kvack.org
X-Gm-Message-State: AOJu0Yxp9HptAGpLH00pLv7qHq+Ya46bNJsIwJkxxAJWGO8enxH4+Qlk
	RCLqAY7g2uwqYq5zFX576/d6TPRmEPi+kS/VNq2u13ATTKrwLV8MMVPNl3WjI/iOTn2ps2+WJAM
	cybvO6L8/E3bjrJBLwuX9ZiHzMaS7588=
X-Gm-Gg: AfdE7clMPqNYo0hNn/skF3FZIbJ7SbRNVKt2xDc1cxugZKj3vTr8wq9FQanX30cfVnF
	8hg6QRBHbFZ6fe3vVz1cHOwlCWJ9wjiZ6Lk/gtASD8x3ozPgdqcMahmXiBb2chl+WtCIgxW4B4r
	TSz27uRcRR4uH4n6KmDBFzxxsWaMaYL6DjgXfmRC8WBm3dxLWShh/cAxROdawGI0UpRat47wcd6
	E4kE/VnY6HrExQd5G+AQcL+aVYN/panrsKCj7xIZLIFH2vwjJJOXSfZ/XCA2w96rWOYreuYfaFT
	CL46JxY=
X-Received: by 2002:a05:6512:3a93:b0:5ae:bce4:b696 with SMTP id
 2adb3069b0e04-5aed5096974mr1926455e87.15.1783328020196; Mon, 06 Jul 2026
 01:53:40 -0700 (PDT)
MIME-Version: 1.0
From: Chengfeng Lin <lin2530632123@gmail.com>
Date: Mon, 6 Jul 2026 16:53:28 +0800
X-Gm-Features: AVVi8Cc_OfaHslnZme8xzf47fmyoGRsBqHSwSB2ST9Aa0oZI50Fn18GQQCYwEb0
Message-ID: <CANGjgdm=gbQj=tmakUipHz9wR-mUvMVECfvJbTm=sEufxOe20g@mail.gmail.com>
Subject: [REGRESSION] tmpfs: flistxattr(fd) small-list slowdown after
 simple_xattrs rhashtable conversion
To: Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F4361A000B
X-Stat-Signature: yxiqja7mjdc5cxushkdyutxqnw71678a
X-HE-Tag: 1783328022-757867
X-HE-Meta: U2FsdGVkX19ssJc24b89pF71ZeX83whnxZeSXXck0CvoIhqDAaeigvzMMCh4p6T2uIpSeIH5C6032Kl41lbdPu7YfDJgVc9qsk0Qpbc3hymI+RfetD8v8OcIndse46db5Hc0MSZwCVjfB9uDTX9+kl4INsstYLqL/cuUXhA+mNNNUYzA/NbOQXT0D+EtteDzWX73Xd8wr4iSLHmPrO5bkL6C5436HPVPtTe5Y3pTJ3jkkHAlhKyCSvppuEgLPsojmRT1EKoOl/+5wTUAWzzSgV1Y+jmBLo9WN26t4u8atf+k0W6AuDps54F6wJEe7MeTIlKlYWa+JwRlPqYQUKq66RBulTclZiceQSzLkp3jD8JDu0hZCi8MvoHH8PYQ9HWAT4p+I9137SuIgVde0YTBUuEoKjzY5/lVzREV+IC0EX7ts2khtmIEn9GwXQK1/ZWGavAvfgs/A1Kyzi3f1ArX+y3gm7bU+8zXswv94AWpEcN28Q/vaPTK3MGc7PIQVO70fEZyw8TJLla25n3i71in74mQe8Cbm3e8GnTgkKcHpM3DqTHs86LschaGT0E4FdrZT6KH+3YQni9l0VSPo1j/wsPkgfv7SmBejU8qsXz8IT/ACTNuytJB3fOt9PMKCfTMgjMdc+JEZrUA3jOkyHAFXZFXwCiXTaa5ajcimowtl4CWnA0HcyNRPpEStjzYEdJN0t+p7QiZPj8JO27zm7UJBGSma5G935dOyRDgnxshJ1USgNR8SwcK+1KRmFlux0YHr7k9FSmb+g39nzoJj6p/mRaUZ/34DUP7STtkidmfR0DauS9XlsZI29gXJns8bG90Zn9gFCeDPbp+K8kXMck4eiGbPGf9wqVudYEX7OFtrwpk8k5Q6kIMSp8QuxkKcM7NK4DCNcbn7yY7wYZaYkv9zufKezQK3ybXKE//KXLsqfNWYuJdERz04168PGRrB3HKkH23FwsrtuPmSyTHhV/
 2oKv8+qu
 YMwLRiC5ifaWwSDNw5Z3MA8dJzV3I+kzrPFsFJjsZXUfbwwdwm0as2Oobz1vOpaFIad9EtqkLIZic+Zr+TkRawAvqPbYrth8BOFuA+JWSIyePAj0viKByf6iev18lySv76j2slUAYZa6wONv5rv4fP4Vmro5dkD8AgKOzXZcVDWZJdkJZgFt5ltS9PGCUnmhJP+taVfN7BEC1yYKpNEBsLeKJhmyDJjlfCj3c7Ik0396SGKqlL6m3av4CzaVwh7h3BcOkbTEF++UXCY96Yx2+GOmVu/S9JkKlyRuaCiww/PltuP9kgVlEEwEBsmhWnxHVAyv/LOHw7pU54CwI7lp+0PQMQKAmP+mS3FkjH3KNxIfAXHBec9RGDJeymeWNE/eHtS7mTvRjDKrh4okAbfvc5/BifyQpTeYYsGhNqNePKkagp7HhluDHJGyxu/bDxcnfvOPyBmHYtsb3FCny3ZUjlY3Aag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I found a small-list flistxattr(fd) slowdown on tmpfs while looking at FS
performance regressions.  This is a performance regression report.

The scope is intentionally narrow:

  tmpfs + user xattrs + flistxattr(fd) + small xattr lists

The cleanest reproducer creates a tmpfs file, sets one or more `user.*`
xattrs, and repeatedly measures:

  flistxattr(fd, list, list_size)

The single-xattr scenario checks that the returned list is non-empty; the
count-gradient scenario also checks the exact returned list length.

The bare-metal test machine is an x86-64 Intel Core i7-14700 system with 28
logical CPUs and 30 GiB RAM.  The benchmark was pinned to CPU 2, and the test
filesystem was tmpfs.

On bare metal, the parent/child A/B around:

  52b364fed6e1 shmem: adapt to rhashtable-based simple_xattrs with
lazy allocation

shows a clear jump.  The parent has the rhashtable infrastructure but tmpfs
still uses the old rbtree path.  The child switches tmpfs to the lazy
rhashtable-based simple_xattrs path.  I understand that the lazy allocation
part is meant to avoid per-inode rhashtable overhead for tmpfs inodes that do
not use xattrs; this report focuses on the small-list listxattr cost for tmpfs
inodes that already have user xattrs.

With one xattr, skipping the first round:

  kernel / state                         flistxattr_ns_per_op
  parent A, tmpfs old rbtree path         135.754
  child,  tmpfs lazy rhashtable path      229.663
  parent B, tmpfs old rbtree path         135.335

That is about +69.4% for the child vs the average of the two parent runs.
The two parent runs agree closely, and the skip-first-round ranges were:

  parent A: 134.451..140.153 ns/op
  child:   217.758..239.498 ns/op
  parent B: 134.273..138.098 ns/op

All of these runs reported `expected_match_ratio=100` and
`unexpected_results=0`.

This run used 15 rounds and 65536 iterations per target, pinned to one CPU.
The parent and child kernels were built with the same GCC 13.3 toolchain and
their `.config` files differ only in `CONFIG_LOCALVERSION`.
`CONFIG_TMPFS_XATTR` was enabled, `CONFIG_KASAN` was disabled, and the configs
had `CONFIG_DEBUG_KERNEL=y` / `CONFIG_SLUB_DEBUG=y`.

I also reran the same parent/child/parent A/B with `CONFIG_SLUB_DEBUG` and
`CONFIG_KASAN` disabled.  `CONFIG_DEBUG_KERNEL` remained enabled in this
config because it is selected by `CONFIG_EXPERT=y`, so I am not treating this
as a full `DEBUG_KERNEL=n` build.  In that matched production-like run,
skipping the first round:

  kernel / state                         flistxattr_ns_per_op
  parent A, tmpfs old rbtree path         148.536
  child,  tmpfs lazy rhashtable path      223.866
  parent B, tmpfs old rbtree path         149.178

So the child was still about +50.4% slower than the average of the two parent
runs (`223.866 ns/op` vs `148.857 ns/op`).  This is a smaller absolute delta
than the debug-config A/B, but it still shows the same direction after
removing the heavier SLUB/KASAN debug options.

I also ran a count gradient on the same parent/child pair:

  xattr_count   parent A ns/op   child ns/op   parent B ns/op   child vs avg
  1             156.102          242.886       156.872          +55.2%
  4             185.109          273.756       181.206          +49.5%
  16            312.894          378.211       315.962          +20.3%
  64            885.222          934.356       870.759          +6.4%

So this looks like a small-list fixed-cost regression rather than a claim that
rhashtable-based xattrs are slower for every workload or every list size.  As
the number of xattrs grows, the extra fixed cost is amortized by the list walk
itself.  These are tight-loop microbenchmark numbers, so the absolute per-op
cost is small; I am reporting it as a fixed-cost regression in this
enumeration path, not as measured impact on a specific application.  I am also
not claiming that setxattr/getxattr or non-tmpfs xattr workloads have the same
behavior.

Earlier attribution runs pointed in the same direction:

  - the signal narrowed to flistxattr(fd), not fsetxattr(fd) or fgetxattr(fd);
  - bpftrace layer timing did not point at security_inode_listxattr();
  - the growing part was around shmem_listxattr() / simple_xattr_list();
  - a diagnostic rbtree-backend probe recovered most of the old timing for this
    workload, although it changes the backend shape and is only attribution
    evidence.

I am not sending the diagnostic probe as a patch, because it is only
attribution evidence.  I wanted to ask whether this small-list tmpfs
flistxattr(fd) slowdown is expected/acceptable from the rhashtable conversion,
or whether a small-list fast path would be worth exploring without weakening
the original lazy-allocation goal.

Evidence bundle:

  https://github.com/lcf0399/linux-regression-evidence/tree/f0a07aa70b79219bd9f47f577357d673b3a06dae/tmpfs-flistxattr-small-list

Bare-metal summaries:

  https://github.com/lcf0399/linux-regression-evidence/tree/f0a07aa70b79219bd9f47f577357d673b3a06dae/tmpfs-flistxattr-small-list/bare-metal

Standalone reproducer:

  https://github.com/lcf0399/linux-regression-evidence/tree/f0a07aa70b79219bd9f47f577357d673b3a06dae/tmpfs-flistxattr-small-list/reproducer

Thanks,
Chengfeng

