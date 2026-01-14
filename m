Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6425AD31A08
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 03:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2506B0089; Tue, 13 Jan 2026 22:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88C06B008C; Tue, 13 Jan 2026 22:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4E66B0092; Tue, 13 Jan 2026 22:31:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0766B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:31:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B1EEC18F4
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:31:26 +0000 (UTC)
X-FDA: 84329144172.05.B8EB615
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D6181C0002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:31:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HYSLAp0U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768361484; a=rsa-sha256;
	cv=none;
	b=jDpxFaJGM5Vf6sqKNzgKTJxWmlgYW6ol8aJHttOxQEgxWYXyBZadoy8fetyrfKtYdnoSUP
	mX4srQkt5Z3y41xP//kKurYppcKfI39wt+Mvp4ssSSM3pZI245MmJTxV9ae+Uagd11GSj5
	f4kEOexlH6u8cjfIkl78tpwYaIggXZw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HYSLAp0U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768361484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAwkswLSDvceXj/iX0pI2u7qJO+mp3M2B3KW95gBNSc=;
	b=M58F7DI0QBFO2j2NQ2l7m14rZ/Kxxh8e9HNavTiNOC/4r5UGqVbKi6enKn+sjUteJb//wR
	0VSAz2YwI6km6zMdExqPX7/JtiSDBCbvIYD+yd9vYBK4sXwMMclY79lNu/JvlQDZw5H0td
	nf/WxZrh3p7mFXYdo3sRgIuBoXXMOKI=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-430f57cd471so4139744f8f.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768361483; x=1768966283; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tAwkswLSDvceXj/iX0pI2u7qJO+mp3M2B3KW95gBNSc=;
        b=HYSLAp0UqWSSqV4Qh58lxrOPAIYflbpHwGc/BA+nUvj3QbCihf6+FhuVm9GFtzsHYt
         p/5mRioue4+NisDvXXPlJ0JhofDOX/B8vFWD47tob/YiAYFnFtu7YmxkA38xQRtmB6TT
         FSVzEZy1WjH+wwFQFUqnck4sPdMZlt+pc7YyVbnxrikACdHMRg2BhEWp/liPFxBXpFWU
         ayqb6caRErYRV27QjstmrwE1WiwZBxmMPClwELBQD4tlTuD7zq6mKxFNj4lWzO6liYJN
         kVMh8DbrDwRzQU6CbBNEP/4JObJV+2G+hIsj0YUV8XWYYslI6aQuQs5+mczMm9TN+ysY
         AZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768361483; x=1768966283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tAwkswLSDvceXj/iX0pI2u7qJO+mp3M2B3KW95gBNSc=;
        b=v+Ga0dUr4fULlSHwhnO+EYnmLBXCcUR/Jgca1zVBQDCVY6zQiR/XFvCghsRe7A+Wuf
         Oh/SNGSqN4dXoNclWK+pWEKOcwTW3YLjpttsNrrqaIgg8OZK944Fcl8fgGuM2f5bxmTM
         7xu9TPUW74cxdohUmW5OOaCkm+WjYCEedGXh1Ixq+MXIhDpV2/qIIJbzDcymJqEbsih2
         vtvWP2uWXOJg3xoQQHB3EZITT502ZQeNwilHqky2hJqJrk6eSaeLW9kWd4ngjV5/40QI
         N31QJArLdAh00haPXuqSTCV038sJ0V3Hby/67fl98HPBA93KTOSvwuyGhlfR9LF7GUty
         hw3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUKwLsImy3GcqPk3lhpKFxKo4OCA9/z7/EH5xZYI5rxpzVgfgbsjyb4Ayt+LJJnc6EJFOpRo9N0wA==@kvack.org
X-Gm-Message-State: AOJu0YzIhzZChKnYAteOm1SBhhsQjW94YnV2r7XigThuhd4cqiv5Qyw1
	Td+mND5uOEWV5W3lS1qQmKOeIetzA7Mw3/CYShHW0iFOwe4ewuwVDTXN5wtGMJQGmN5KNPmaskC
	dY1I1+2j+tMvXeMVhaMvPhhplp6C7NFM=
X-Gm-Gg: AY/fxX6lJKz4bXshvr/FSmjQ3ivG+M5D/MYOTjhZiQPEsCuB5PjkYC7POQtcYGDOG6+
	duYG/JX2KdlKhQH3zuSNMHw36LsOWXcx9zuJFf/ZC47VsIyHPKimDYZsfq6f8Ndf4SVuSKpnBvT
	vcZm1aE9TF1RSoUCiozNfS43Ro38qQGMVOqeygaDLmkiwMQMghF7Nwmb043zhlEZJK8gbiI2ppt
	Qpf19zBcbTXLWg7iGfzIkeWoiJTnbFr/SM3kW6I8FJBx/BgOccRerwiAAxwPj+MN5usEm9Def/i
	o58Q0HbixrGf2gB1mnNFQi8NldsQ
X-Received: by 2002:a05:6000:310c:b0:430:fc63:8c8 with SMTP id
 ffacd0b85a97d-4342c54759dmr1005118f8f.35.1768361482534; Tue, 13 Jan 2026
 19:31:22 -0800 (PST)
MIME-Version: 1.0
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz> <20260112-sheaves-for-all-v2-13-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-13-98225cfb50cf@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 13 Jan 2026 19:31:11 -0800
X-Gm-Features: AZwV_QjU8IHt4ADtGwZuCMWdsEN668TGd1jbbhsvRKh-PS7J4GcDNvMn4EbhZYo
Message-ID: <CAADnVQKBt2xmqs+o0onUwd7G-0UDbE8LECnkJJUCVbywAr2tUg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 13/20] slab: simplify kmalloc_nolock()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D6181C0002
X-Stat-Signature: iwf3wtw8zd8h1w4bspfjzt39rjnduz3q
X-Rspam-User: 
X-HE-Tag: 1768361484-297144
X-HE-Meta: U2FsdGVkX18q5f93FIKd9yHEgxS91sa2wP0mbGqynQOorDOJUqHcK4AUBduopuj9502uDLKM/zKDqJ9OuCfVDzDJG8nXmXeqMlTEaFphLv+ZcX9lNeqPm8vMfwWmlWi6xzzmGgSoTmFXbgj6NQbvFvA2UF1IFnRgEi7t4rsApVG9iPq4iPTF5BuWdjyBvSToxtX52nGhz34lv1TaPh+sq0Ipy/yBTNWB6ogAukOPhuKmF929t5qdbYfKzJzaAJ8giIRpkKk7OfOHkiEmwuN+UQumGX96eoCzQOdURULs+veD/kczty/w3hdHWA7t+Suivv1OAJK92F3ToWMTnle1te3KyQeoeeXwebQWbaK5ci7m/cD2d33b91aP5wDNGSxxAr7j0wqasL/xT8VrniKqhDsIgf5zxm9L1wfLGlPiytT4JLBN3nr2O9M26RvlGpYSdrDHHN+NsgWTMpDCUG6gB8cZuf6MWeqMDCmyFM9tTRK0tSlSKQi2C+H3oAUwFjQsrBs/aVwHKWlPPn68jw1p8+wPogvE7PlEDCl+vXZE+dUb01df1I9kxgXfGQczOtxzpZxJyCl1REwwfbkXfmKU51FwZiZXo2fT3wWn44a2pjYXQ9ZwNo17C1EXWSj3LmB9iwP0azzTjCEroqhWCRJT7Dk0KrBFdsvIuBCeXzhMVbmmoq1GoEqOua8lvLgJZbTlUPrqQLMfysr8A8LlRa49v+SoZRlVegpnOZd0Pr38fFgHSqD0Ych1nnK4DlKPgciyZUK0GDifdsO5CUA3GwTE8pqtich/VyLd8LjSIRAZtLt1Ck6trVfwRmunJ8sIMO0eNfctkdPMG3OgT/Pb0bY78BV2GbvDNclUTYsAscUGkzJDdlohjWIW6VMlh/9/1nYwfhsio5itRT8FbQhmgA1stBj+S+5O3Qh6kXsxma0GzrwSKc5Phj038sNOCqW7KIA5quwLyB4Hiauh2I1OU/R
 dDYEjpOA
 fYm6sBbQI1mTWtaRamnrcniiD6AS16vbbDY5RRWzlqS4dwvQPOif6M4PhA96Zqxh6MWaMMoVka3bYjKMlvKscFE3+yXdoKZBn6ArijSyYjBbSfzyPp+R7U3cQEDmWnU57NyRB9X9gd6KXwEa8/gi2TtJ701MSXKq/c80LuWckZ3cjsrdoqyzaSGoIkucXpjhbt0+ODbmWVQWqJQtwyYXDklXk3cn1pUhhL9dUZUxFZAaZgA/6jXYdSRQusIaV2IzMzJntTxW0m885HHTbmXZKdN1B7LCU1rFS837othNB7JdtG+nA4Src61bG4AKOaJOLEENb0JQ/muIqD4fqrik7AXA9r8s72UV8Do3j1PXBqBUysBqsuXZbshTtePg6A9/XGRhTJcAUywnys55LHkgIVvHbyAnFezTtoUWJwf6JeQ9xzztlcng3Nxlcq+qWMMUTuACwVjpOnBuhP/8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 7:17=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> The kmalloc_nolock() implementation has several complications and
> restrictions due to SLUB's cpu slab locking, lockless fastpath and
> PREEMPT_RT differences. With cpu slab usage removed, we can simplify
> things:
>
> - the local_lock_cpu_slab() macros became unused, remove them
>
> - we no longer need to set up lockdep classes on PREEMPT_RT
>
> - we no longer need to annotate ___slab_alloc as NOKPROBE_SYMBOL
>   since there's no lockless cpu freelist manipulation anymore
>
> - __slab_alloc_node() can be called from kmalloc_nolock_noprof()
>   unconditionally. It can also no longer return EBUSY. But trylock
>   failures can still happen so retry with the larger bucket if the
>   allocation fails for any reason.
>
> Note that we still need __CMPXCHG_DOUBLE, because while it was removed
> we don't use cmpxchg16b on cpu freelist anymore, we still use it on
> slab freelist, and the alternative is slab_lock() which can be
> interrupted by a nmi. Clarify the comment to mention it specifically.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

sheaves and corresponding simplification of nolock() logic
in patches 11,12,13 look very promising to me.

Acked-by: Alexei Starovoitov <ast@kernel.org>

