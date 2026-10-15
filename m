Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5F2CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4A26B0096; Thu, 15 Oct 2026 07:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B6A6B0098; Thu, 15 Oct 2026 07:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992896B0099; Thu, 15 Oct 2026 07:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75C026B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:24:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA5D1A09B9
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:23 +0000 (UTC)
X-FDA: 85324627206.20.E84BB1B
Received: from mail-oi2-f10.google.com (mail-oi2-f10.google.com [74.125.231.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1792B120004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gHIe8ZiP;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792063462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=toN6NfvRkfvzS3ZSAY9pfVPprxB1LDrTzbA57aszDio=;
	b=EkKvfd27Igexldj6br1AbMr9YzmRJ4jkawQiLDTt+fj4c80GV4RfuaBGCsM0dViB09Nq/S
	G8GCB5jNnhinQnGTi1XQN8jrvBXD+BmvZ+Wf0d6zTcQZ8r09tOVLH9Nfg1hrgVNf9f/YqJ
	4jROJn/Q90APtDtV1EKVovK16+DNOqY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792063462;
	b=blm1TF06NDHi3BdV9OpFBOlhNUs5DTxjM/UmcXy9h2/CzNmN7P7XkYJfCIK9kDM84fqk9m
	GshaOgtE+SY6wL2txJESofTR0MKrOny5i6vCWFcy8YXOFb+udlKlgGlW+xmJy+UXkyQ5tF
	h2gpNpFeUYYDdz3zPXHCYOneoaUsn6g=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gHIe8ZiP;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi2-f10.google.com with SMTP id 5614622812f47-4f6b95ba1f6so746428b6e.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:24:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792063461; cv=none;
        d=google.com; s=arc-20260327;
        b=Tc8I6oI4HSSJ4iJJvZEz7Sdx/DI2B+ichsKagJDqckkMPd8WwKMtZ135ITSSYwr7il
         yc+GC5DSqUG8AZTq0t8r3mm/IppraCk3f4RMD+QUv1wWZXfy07UxVxp3gGLKTOs1EmJE
         zEsaN5OZydmRlhykGTgX/1H0LucDzI49EWycvZKa9+R8otJDgdA8GNDtdUPdBkbZMV+a
         LP5UEon2kWnofLcT/HC9VdS4V3w6f31an7gDGYCl5dBEYKmGsUa2PdkM8ozW6pRrAnhK
         s4oMY0zm/Y3g28aRMlkf61QSwt1RqjvOohraM+oBGql21smJ9fjK2FFfPLZF1glOHehW
         TEsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=toN6NfvRkfvzS3ZSAY9pfVPprxB1LDrTzbA57aszDio=;
        fh=7qDjwvJcfbMixUpNxczyNYwiSSAYuCG+u2BfmCvjC60=;
        b=AEn1slA8tvFaLceO0LsDzJdRkQ3rHDwmKltF0qNxRWQt0Ql2GIBnBqQoKJQFunipDJ
         5sGwOlX7Zs9zdXkKhdTapaDVPFTUTWWfXP1MxtqnXrz9m6kw4khlQqWPkQbgJ4gt6I20
         2oydeBQx8IDcnKMBLFcBwcs7XDXi/MDbXYqeyzN0NzaJsKd1FBFZOBgKy9jD4uxk3aU3
         PAm+Gg1pQY/0MnRnt2zpxXfqzpqB1cuLRPOQiyNx+QjBCc1kRM1w9rsvpFwvxibxbAx5
         X3bzUGPVe6eLdxIQzHEJQdqPgiylgWXHI9bKL+5PsFgf6Qn5j4dqrLIz9ELTQJxWEh7a
         YKZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792063461; x=1792668261; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=toN6NfvRkfvzS3ZSAY9pfVPprxB1LDrTzbA57aszDio=;
        b=gHIe8ZiPGVJKCKKoEs+ot4P/Fi7QG6ndwPluBMVySHhWP7jAVL6AYJjeo1MKPQ69hZ
         vZBVKqOe67RR8+IjOdLlNU4/2xKodXuaKkatkzL7LyxPqZ8Z7R9udlYzkTyejmE9hu6/
         SdJvAPu22neYLKIVEevTPkm7Kej0wEzHHlLKnq5JvADl4oWbEHEu8oJRD/rIP6YN6CEh
         RegHK7C+VgSdTzNDnbjUhka0QAiKM61+n48Lap+5+FHxW6USURYxwmb6ax6Toq9qNcOR
         Ok25w/RoQxZFhLrfjGNfrAVtdIOgCWV34OYjtzaRQ+Cj9XgFjecP0XF6vt7IQCzc7Vpr
         wpWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792063461; x=1792668261;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=toN6NfvRkfvzS3ZSAY9pfVPprxB1LDrTzbA57aszDio=;
        b=lpcEO7QXprsHhHNLwurTY8I/PjocDFZrRGcITrVt5X5r7Xm+tm58xdvPZo+TCqss+/
         eO8LMXsDqx9B+5AicB6yT8cApSbPybXUMBLTZfQkm3kZ0gfKd8/b80YKWvFIb/NImHh1
         sh7WveTDz6xC5nDbFwIr2eipFCM23huuFpnItphsdpg/B3fhN4KddrPIiaL8Euv7nBvk
         n/rHJ2JTYIyNkS2Hv2KYeKSYodWasihiKsltgzem9XG2V0YEJJwKMkist/DK7qm0Kzc/
         HDsesFXrj+7WBPd4A24AyF8xftUnD2Q8MmDfj8mvHMTEqyPBo7HVUVciCnDleNJkR9SB
         ymbQ==
X-Forwarded-Encrypted: i=1; AKwUvBwhQ056xNOLWv39C9WnIaizddtYFGJ+sQrZnJYLuUdrkzT1f9Bah1WtixUGkswmlFi9EjqcgASODQ==@kvack.org
X-Gm-Message-State: AFq9FYKtSzPOo89WWM4XSQI9SGdp0pt0d1VNL7JoLabX23nH8qSvTh/a
	FqRDGBYyLpVw3LnOck7G3uXCfF7CydQuuP1FvGMR4vmyc2Fh3u3BqBS6xNX+SuKuaZXSIWEt1Yt
	tT6tfJYsUsmSSzsmbzxh4mdwpF/ywpJ4=
X-Gm-Gg: AYBFou09XHbfPwOl5eTXeA1ZrZ5sxDimOCgxmHXuNKN3ZqBbpLDgEQiYHmLB+mVZvAf
	iOWP1RdBVYjSB52CcFpa/MeANpNHI19AZ8AgthshNMvgL0ENC+0Z5Nbz98W0XjbwehuNBoGxg1z
	ue2wXi1ZZCHuwecO5x1IgI5y4tCR+WDJ4KJz+0Y70ztN9s1TwJhnbBYzTN4O05R048w6Wrjim5X
	LF9VVEfkoJXZ6F49Ff/6DyiCLfROqjWFy7TWQ/S1KfHaHZXTZaKnW/uhbY9NmqtJS2agPeLcccI
	Q0WKsszcTGBwXzhnyobHEa2rFS00WQdM7f4fUYR1Y3run7jXO0NaHJGfn4lMuNhnUHFfy1etzzt
	/zzo8JXjlgw==
X-Received: by 2002:a05:6808:4fde:b0:4fb:a7f3:420d with SMTP id
 5614622812f47-50c57696145mr17825753b6e.48.1792063461122; Thu, 15 Oct 2026
 04:24:21 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 04:24:19 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 06:06:51 -0500
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 15 Oct 2026 04:24:19 -0700
X-Gm-Features: AclHuK-608mCEKwpz-MUlsDmIU9QQ8jGf8QLRe02ypGSFraehbwNM8aN2ipTdn4
Message-ID: <CANOyQmFPJt=-=hJh9Gt-FPG6YiyeidyfUbnW0mF5bSmJ0m7P0w@mail.gmail.com>
Subject: [BUG] DAMON_STAT: 32-bit overflow reports wrong estimated bandwidth
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1792B120004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wx7p6iwzcyptofyg6e3p4dpcqq6z4sid
X-HE-Tag: 1792063461-846471
X-HE-Meta: U2FsdGVkX1/Rt8bA5+BMwAi2faVq5VPP8A4M06Keid06iimCx9gmLtHfTMERfvafHjy8kHC1XHpz+ezPKQXzeMeFTvnlX9Zd3WysYZlRRy2SmdXun6zn9LCnL2+VhZfvZWJQTLef9XZoC8SeTYkLELvy7H12/ZBw1EnTxB1g49rsPmcPwDhfVyAcDf4RJAa6kHa3oXPweMdVs4+sAFYV6RfXAHV3DVg2RLhG29+Kh+u4I+nP19l3hwLvZ21MfwieLHLcTHOSmX7cigbXysXuFqyOfMZFSnzt+aHsiFjsBxONGitVgQKr/ovc4iGL7TI4oP4M5rtx2tJwbphQVs7nKn+XoUsmOrsBoOlfNcx7LIUoeFku6YIzjSfuRLioRX5Vc1gE+zfe58b/vDbArmBjvRqgrFZtxnTPNgouAGwqkandR4gn+DzORichDPJEUs97++sK9gm5xLo/Ns64pheEsSd9XaJp3WeZhpFGIj/VcELwCNImFr0euZxw+Yn3v7TMh6xqDTj21HXE9JvI4PPhlG651bh+1JpAErfniFm8sj6PgdnOrMvBFQTOPeMDUIk5p988r5n/shuyEF1d3OIBwLX4cvbYOAF1+c0wWgJm7MzDm2JOUnRkis46CWTJihadVgPlL/OZT1jTL94ULvMyrnhq+EIVKiHTUef+GnxxnrYa83HnfhedddHs/TFEuZzWktY7zhWONYUB9djpJPnp1qEzGOmrioKGd87qvjwYc+fEdlAr7e+Kk5o2TC63zkRNcOM0e+w87B9aYxsX73ZsPIgulrm7Cp4jEMZxYrLOIxBqfMkwDR0fUN2m58plM4+2jJdR+dwuKMguU7uak6ithHb6h+gfmv5jW0T8hBk7Timrd1Sf39/tmeKJDIKbDayO5GX3Q1CgckgF4YSrdphcuotsxpe7SSbcCJS41HoL3IoeIdN6ARtIM/N48QY+Ol1pVry0JA/Qm76zIxCwdzF
 QMIbS2bh
 OnPAiV2m2ndOKtSwK4eJ/+lXjIrH/pQ37eyKgVbEI3iKjwjDVWBrGfE7qZh7oMwOxuuoKPyG61kk5lYPU3uSE+7wIBKiZ+ey9tR31+MZonl3onRBJBQM+3OPna1mwVHb5ueqKWqdTv6EIQkj7ZyDrW0oOwOjcucEcUzdTm3J85DWsbug70lAkHoI+wUvETFPqHzmfDf1v7PMLAV0x3LMj4kuULWl4Mty6FF5NFSFr73i/xrsBIXME+3fqKBxEXFLJ7BAuM60SDnFMubOwRGjuhh9ZJsT7XDK0sLf4501K8owkCZ4BCHaKATNEA1+93+ujmH8xgh8ZgAyHdMTXx5pFr4fF1scYtHlCa9pxGY7ZgbIIgZJsy85rQ0KZ1GkrFk+b5+vqwR+KQ+BZGa2e9rPOoa1GFCD9yUJbxEDXGT64vFTZmDWQMxvQDxoD/2bkgXhDdp4Gk91NgV7SiyXI+pnwfmaxFFx95zDTRV+peCQz5tGKCl+ujWp40Ve7f2M+ESjv7IvXmW4UOYybu7urnI/jf3RYaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On an unmodified i386 QEMU kernel at mm-new commit ad9f2d463666,
DAMON_STAT reported an incorrect estimated_memory_bandwidth value.
CONFIG_DAMON_STAT=y and CONFIG_DAMON_STAT_ENABLED_DEFAULT=y were set.
The guest continuously wrote one byte per page across a 32 MiB mapping.
I used QEMU's GDB stub and the matching vmlinux to stop just after
damon_stat_set_estimated_memory_bandwidth() stored its result.  At each
stop, I traversed the same target's regions separately and recomputed
access_bytes with full-width integers.

Three nonzero callbacks, all with aggr_interval=100000 us, showed:

  access_bytes   independent sum   stored B/s   full-width B/s
      33357824          33357824        31079        333578240
      65200128          65200128        25244        652001280
      41152512          41152512        24303        411525120

The final sysfs read was estimated_memory_bandwidth=24303, matching the
last stored value.  The independent region sum matched the kernel's
access_bytes in every callback, so the sum had not overflowed.  Each
full-width result fits a 32-bit unsigned long.

In mm/damon/stat.c, the expression multiplies the unsigned long
access_bytes by 1000000 before dividing by the aggregation interval.
On i386 the product wraps.  In the first row it becomes 3107979264;
dividing by 100000 gives the stored value, 31079.  Full-width arithmetic
gives 333578240 B/s from the same inputs.  The other two rows show the
same problem at the callback site.

The workload is synthetic; the test checks DAMON_STAT's arithmetic, not
the accuracy of its traffic estimate.  The i386 config, guest init,
disassembly, GDB probe, logs, and build/run steps are here:

  https://github.com/jm5905938/kernel-mail/tree/195d7017352a3d0f4a0475b98f3b03650f5c14ea/cases/2026/damon/2026-10-15-bug-reports/04-stat-bandwidth-32bit-overflow

Thanks,
Aveline Noir

