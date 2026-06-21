Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35ED2CDB466
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 04:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFACB6B0005; Sun, 21 Jun 2026 00:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABA36B008A; Sun, 21 Jun 2026 00:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A8F6B008C; Sun, 21 Jun 2026 00:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A17EE6B0005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 00:47:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D515BA0320
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 04:46:58 +0000 (UTC)
X-FDA: 84902684916.24.51F634C
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4EC301A0009
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 04:46:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=b9262mLP;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782017215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qUZQSeFZV1MT17jpo0V2DqLNTTJ56sZV7wIDgYRw1A=;
	b=U/dW/uZz6liY1nyEa1NCYDNH4uYxS/JGd/leS+9RT49ezyjJWaWJ/Eq8Me/A76kpT9RPAe
	0c71jddjwtkrGv23umP5I2nMKyEh748XTP1cPP4qIQr2bT9v7xRHmKjapwPqdYbJ6Zr37W
	dXfcGxN8EMaVVyLUhgYROUYaJY63iXQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=b9262mLP;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782017215;
	b=d+cB04vXxE5gJqziNC+yGD4I/qEcfnpKdIS+b+3bdvhKKaAWgUQp8UFALjJuAz7jwx/qdQ
	IbY1Ljw1QH5wHRszWUlFNiybJvp043phNbhplTe9QWNpv3xbQia+0MYK8LiRdjXSV6tlP8
	IddZDX0iIA8kFZdKYeC0/BxV1rvrSMs=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c0115a3794bso621582566b.0
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 21:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1782017213; x=1782622013; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+qUZQSeFZV1MT17jpo0V2DqLNTTJ56sZV7wIDgYRw1A=;
        b=b9262mLPcRjaDEmKMqpFcl53dT7CaVp0ezKgP61Ikek5hjbSi0Zzzr+nc4FgnVdrqC
         6DFTQZO566onn5G0LRWFWRkVfhjIqIS6Qw3UVZ5SnMWBEdlfO2GXHrUC+m3jcF7kTUhO
         52pldf8uX1YblzSlhGY1JZvCBc7kM69SR0Q+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782017213; x=1782622013;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qUZQSeFZV1MT17jpo0V2DqLNTTJ56sZV7wIDgYRw1A=;
        b=dFMxZODeUlTwJlaLMX2QrUswyp7+doPKNMxXJXJrhI59vbHL192sTooP77DhcFnMWI
         doqD4dyAB1+KPXaVGNNutd9oAVoIOFVsZ+cOM1qThqbzLBgOCSFNFLaAnxJAlC/ErbJt
         0t80t5ck9Jv3O9fzh9iARjVa4OLZ5F34vG4OQUX4SyBH1soSKrjT/lQ8ZAnBdthCHBan
         Qa6fgcXosaRuA0bKI+0jgOyqgw5/aFYyd03TRa/6XN+xXTW9liEsWVg7h8BnIj0VOBs9
         1F+VCHMvgCwhejXaiL7b13BINvGhDsFSJrYqNRbCHpbV7eqbHYtA82Arpw77Lh7YQGoH
         O6LQ==
X-Forwarded-Encrypted: i=1; AFNElJ8RTMPT8Q6LK5vKJf+E6BNT/KJtPRosszDcftUtCNmoQN/xIKPVxQGIUoWbzXq8STipmsKxidQIAA==@kvack.org
X-Gm-Message-State: AOJu0Ywb5Rh4wnDG9Hp8eLTbw1Y1EnBh0mC2i9nYd/yScuG3hAnfUmMo
	+thH/xJC9kbG3rmvWKt9L/yKKcKaAF7mHcARdl4Cvmu9407ev1qlqDuDoDMVuQF+z6lnw2dtIHP
	a6fqYpX3A9A==
X-Gm-Gg: AfdE7cl93t56bHabeG/hbAgF2ufBNTnT6JOYaLX6upZAIpV4najidzhg8nJ8JvOI7kG
	QVf53y95ebrRxR3c568hg+RMYR3lr1YWoYRdUd7itBNmn+5Z3v5PMUcQ6II9KYLrBDS0c8Qpe8A
	d4QT0HbnkbcDjpAlASnarFELdPwEeYvy5vzLhfRPQlFqUnOLZ4hFnxw09IRICgYIjT64Uw+GRdl
	BBusuPUEoMnGiYpm1Zxzdt4zOSpvMQO2DgBq4hqXIxqRoMA4n7EM9UehxVHhgJ2tWGO1P/qOnvC
	U0uTznvq7hS+zAnyU6ebv+Bgb7hgFnksPOPiphfPz0F9o/rDp33xLig+dBMJbNmZP5bWaZMWSFc
	3aJoVCyJXRxncv+aDaZK44GmQTbi9xdbj+51xbdxWwmMiAW/PswIIUzMQgSJk7P/Xv4JjV8xwEg
	/l3vdRKoTPPg7QxWChipn0APFRZKylqAqWf9vMMBhV5aO2lP5uxkgkwtT4B+Uw
X-Received: by 2002:a17:906:9fcf:b0:bec:fa92:d36c with SMTP id a640c23a62f3a-c097c9cdaf1mr509306966b.38.1782017213179;
        Sat, 20 Jun 2026 21:46:53 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c610e4192sm170014266b.44.2026.06.20.21.46.53
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2026 21:46:53 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c0c2cd63abcso166357166b.2
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 21:46:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+qXgkb877zyZIA5ZMYv4Sn2ZmjZenSonRqiLIOTRvHnSFADJOKEd+jHgtI7W0ejbBKjoWcNH4wfA==@kvack.org
X-Received: by 2002:a17:906:f58e:b0:bec:228e:26ea with SMTP id
 a640c23a62f3a-c097af68e6amr443582766b.13.1782017212854; Sat, 20 Jun 2026
 21:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org> <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
In-Reply-To: <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sat, 20 Jun 2026 21:46:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
X-Gm-Features: AVVi8CdCHRILItLDLd0ucb-vi-tIB4iii4E09ObGHfdIuVV0CNsbh_gYFpS5lhk
Message-ID: <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: ilya.gladyshev@linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, ivgorbunov@me.com, Liam.Howlett@oracle.com, 
	apopple@nvidia.com, artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, 
	david@kernel.org, foxido@foxido.dev, harry.yoo@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, rppt@kernel.org, surenb@google.com, 
	vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com, 
	pfalcato@suse.de, kirill@shutemov.name
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4EC301A0009
X-Stat-Signature: u8maxykj58ndb5qkq6mz3kna5km7xxwm
X-Rspam-User: 
X-HE-Tag: 1782017215-63617
X-HE-Meta: U2FsdGVkX1+GnAE+SfAWL06JIxE3oN451WdCf5fKntE90lHG1VT7zikUGsa/mNcHpknnvAyxoaJPj9rpJvhP/M5VFDMbeHrHw6m/FM4zzr5REB008N/6i2PuGP2Uc+Z/rKOdQOhcSsTbVnCFH5iiq8t7Q8GNmIW3JDJEuxK/59vwWUYTmLGF1Ds9Yezu4AlhAar9kMcY1kVkyqvUhdjcoyCsh0rFqOjeYDD69F2BM+n6XoYCsTAL+jt126VQah7xcyeGgc1DX7xwIhgU2m8Qcg//OAoviYxLhCnQ72hP+UGjsPmvGGpYN6bvtaV7DTOkMAfNUoxlC5Qwte+06pljQjJ972wZx0yaL3OJDwstQx+c2M1508u21X9lACPcyx3+ElpRZvwp06Bp7HQKB7MlI/ohrfzPcmane8aLAwDzH+UHggr80H4qMImwgjm9/LHcPtQAcvcQTSUQ5cuqnD5L1B21eWVBHxo5RnrEZ/wI8+uJ6Jtry9onm7+e+0O+ocoK7stu5Rg7vaGNhJHLeFlc1AajQKLcQR2iLCsAppd4bIaIE+VVJeLlB+tip8sS91cSHD022wTyx/CD/jFDRi68CSl/6SUiKz/vUd5XXCp/rYsr6Hz7r9qbTRaoCoDHaML6qBS2skR0T7SgxKqFSR2OTm680/zbiSum8apDMWqh3qKcjvaARo8oQrgoRqcZ0bDm3DeCuyPWH2I4oeRUum6veApgIzReJxEy4/jJ8ynA9l+/j4jpf8B2o0Gd3+UCCd6n7loLhCQ64hd/MDwfeKjW7hrGCzNUdjTFO5T53bQ1NbnNzDIixMphJJjY3kMiWHHJmA8UMirmesBgRM3zpTlXbnF/qdJs4bIYNyxlbWEDrMT0lisIEFfFHaUsKKk+HFKj/3lckGgyF+BJmqjtImKfzNpB6Qvako/jU6YidcnBFIq23Fo92j8LUGo7B+yMu9E9tr5r39Y1CvldNsKtkiD
 RqSPFzp2
 pUmB/4TuA5DlWGDdUuXf1WFZfuvNucAUitF2oB3CZ5Vq019b2do+n+HV4o26KzPPVN1Z9n51DouNsqCXctvsvH8105Au6K9uLmCJ1V6/b+dLNxzhPHmbWSGevIDG8jhWcrBuEosgekjuGE/OVpkLdAj9KkY5g+kUnnauqyvG+jfigd22qTzBynzw0uzDKgRtU+KeBwvg5WXJerBZLtruzrmoHdTX6SDW9WiRML9qSpnOemvZxdOXKSHzLb1uvBYGM+uophnrGdA5B1v8TC9/KnKBKl/7LecNGGjtEWie7fRWJmU/SvqUt3J7q4f8pCGYFJs7mxigLyvfMNPa55dyfzM/eplaV1+igCmYhvMJqZEkv+/6X058c4MGdkHX2svbQdehnQpgBhZ54Mu69/XLmmbR8yQtAPmONyaO3NXmtvb/RjAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Jun 2026 at 11:19, <ilya.gladyshev@linux.dev> wrote:
>
> T2: optimistic get() [0 -> 1]
> T2: put page back [1 -> 0]
> T2: calls dtor for type X, returns into the allocator

Which optimistic getter does this?

I didn't go back and look at the series, but isn't the rule that the code does:

 - optimistic get

 - then check that the folio is still valid (*not* using the page
count, but by re-looking it up elsewhere, typically the address space
mapping)

 - put the page if it wasn't valid

 - if it goes to zero, there's no destructor inherent in that

 - everybody who sees it go to zero - optimistic or not - does the
"zero to frozen" cmpxchg

 - only *one* of those will succeed, and *THAT* triggers the destructor

IOW, the transition to zero is not special per se and has no
destructor. All it triggers is the "now we try to mark it frozen"
phase.

At least that was my mental picture.

Was I wrong? Am I just confused? Wouldn't be the first time.

             Linus

