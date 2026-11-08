Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF2A606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=cemmUpxI
Received: by kanga.kvack.org (Postfix)
	id 731856B05B5; Sun,  8 Nov 2026 03:27:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709AF6B05B6; Sun,  8 Nov 2026 03:27:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620986B05B7; Sun,  8 Nov 2026 03:27:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7736B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:27:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFCA8A02FC
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:27:57 +0000 (UTC)
X-FDA: 85411273794.02.66FC823
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B6381C0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:27:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cemmUpxI;
	spf=pass (imf20.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794126476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHJ/s2pok+cQGyJRZxhcYGZiYXJmh71TKyHNP9sAFZs=;
	b=0OL7lsEw5ztcLybE8g/Q5mBaAWX7bAsgytlX7SAJQwmVZzjWO+KrnPr9u9ORQ452NKRzHu
	pol3CJPwPt6JmMNonulbyyMRC0EDy0X0GfeHUY59R2KnX26xt+vGloc/3JBFOyXYAGbRJP
	MuqGQ2pw+U+/+i2ZVdiwYWsOWq5exDQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cemmUpxI;
	spf=pass (imf20.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794126476;
	b=jIvqzgjVRf5a/azMwImUO/ifq+QB3qctTzVAtN3lfYpHfrz5DNeRbmKxRp+mfjt2zDL7fG
	e87Qc7exjdO1aZTjN7eGAlmk49SV8oLObVrgKUp+9vODrgNsr6aRY/BVqY5LSg+IzRpiBo
	IxwgNsnnR3WYxTDwT3OtTT4E6rS1zUQ=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-823e4047037so119445a34.2
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 00:27:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794126473; cv=none;
        d=google.com; s=arc-20260327;
        b=r1Dlrn211m0OPLEV9donp0sIRdbWiA+TpoNXfZEmlwLZLp6xW4WIarkQCyN8jL3oZF
         nKVa0V1LG//EmUeIlnn0H2EDHh5mKB96qK2c4dizvYEK8ZXSQoz9o98Wk7u9TLkbVABf
         3aXGtHV3KCy+PXI+llt5mlcMae9k0/4/7lWlIIx6CPJS71VWGORSOvZLfSASG5ASAI6t
         qQEjQfZ82RBnOJf5N2vvMdZoPWKcJBe8Y1s+RbriYjUM4eKjMlF5Drf+OL4tIDiUmldD
         jrECM35i314OiY0+NalehOmGr4t62pehjY9SPfqLRqHuILBI31S6iIQzFB05UHJYA3WC
         zrhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LHJ/s2pok+cQGyJRZxhcYGZiYXJmh71TKyHNP9sAFZs=;
        fh=IgC72N1ni9sn09+/SZCJR/AbvktG9/JI2oESwBV8sps=;
        b=jgz6rxG0EjMQ7Z6Hgba3HNUP2PvxNO17EcL5pAUAx/eC2kEFdUAHscObWMTOfAVuJu
         nmSp0t4N31kPxlhgGmI7pPayDPeNkwZTPxKVFCxoLjrPHdrC9sHI350uEFSsGnoylArf
         WEoPIeYqIPitlARHZlEH+SU2NyWFufieV69w7hazThNmPDBxvzByscsMZTq/jVkwVpGl
         xkmIHUYwrZPWuNQbtbUyVm3h/IwsOWGo8jdhn/RO27CB0We+DqJImFwYc9BwgbTOYqok
         Hr4ISKB20Vjp+iFxYEGS6l57WKoYtr7/VFJmtjLbX4YuYlMNPyFrPvNZcDIUCxG9cAoC
         bgrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794126473; x=1794731273; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LHJ/s2pok+cQGyJRZxhcYGZiYXJmh71TKyHNP9sAFZs=;
        b=cemmUpxIPNS+hM2RT4+VWQ0tkwmxKqPQJ2Nmh6Lls9jtkj7ZGfYNwvhPhQv08jToNU
         rlrzE1cusXnX/x/blAy21vc1DAFY0aiBxHhELRyymSzpQsKGl8zSGTAe17b1HWT7wYEB
         muDflBJLTicvNSc9ctd7ncYl+ej727tJbHmGtvFJAKhecMDzqPnCPAYcB2X3a9K72EkK
         kcFPg5nHckMKFcJEVd2JxCf/tVTJBvjrUKkfD+pxyipaLQZaSEz0ujKdm+gpRmOTaUMf
         R2a9bIwE1miPSRpJw8S9TBTSPQlRMfVHpq56vF2Ozob76kYS7RE2dT6kC1PlnUpsQI/4
         oEKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794126473; x=1794731273;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LHJ/s2pok+cQGyJRZxhcYGZiYXJmh71TKyHNP9sAFZs=;
        b=EVErPyvArJhAqgujVhq+1rOy0MU6+wYiZYf/HZ5p+jje0B0fFISMYXgfT7GkQTgECB
         /zis/GmxwAu2bVYB9B0f8NdavH4M2rmIKfyNUXYFHIvq6Bma7+cXlRHyPtctuO3fGrb3
         7aMfwn4qtfRzszXwwB51NEnYWwaJCTPShcaRclGhyAXmopoLKzCC23ZwxZ0LOBjGJFMb
         pI6QU7xixlASFfnCmWiKUiuwBzACYQnHypV8okghbnjdQ1iKI5exPPCQwS83nXUST6Cl
         XWNCVWBzIqcQpj2F6H85Ytu+Eq/LOuD9nYMFDupEl3FCu7Y1VgiZRu0utPM15Dnxq6GY
         es1Q==
X-Forwarded-Encrypted: i=1; AKwUvBz9n+kE761WNUb8X2vId3uwZ4OdZT0efjm/zzqmdiZ6uofi41OGUI+wiSZck2CZ3DgO3rUkZMZLtw==@kvack.org
X-Gm-Message-State: APuU4Z8I34sVAqkWDbTQR4Q7DnA+EjlB0eY11AB26azavqY9Mtu/Jug4
	lKZx4IQ8+7koWxpo36v4h4+Kuh6bpXxVUhKvmih1tjDVTZxW0Yi8+UM0ddLKhPvGSAi52VZlgO+
	nkL33a35FRojyn+AFq7fRdxJVrOEaLXxJhSZsc9nz4g==
X-Gm-Gg: AYBFou38ykobjHXvGTiJku1A8pvlU8T54zHLfshORrmGANksr6NysiBfACOQNUlLT48
	Ks/GAmT/o2RFKC2eiWlqtsmY3aHaK6fXbkfAMm1r7aACmGbX8LT+qj4qSKm3vtp0bVMXUjkWdoV
	LzwekPwoxpn8TtzAtGpth7tCTVUpbaqgEjBtxDCo2XiNeWerKtBtZZYIzRI18ltAnvA8p25zrM6
	HUW5bUXYAO3c8k2MlAIKPPHeUpmjcKvr/iEPalQHsZt8A7mq/ZF2Rt6w57J4lZsQGl5gwZytdvA
	55uLzJ1qv+Rb/rXPhxvkbTow2QD2m/ekzsIKfknLEeZPaeN1fMGy12/HiGdLw77RPuXYA/RbkGw
	GIFj3g0mtBcQPGRDMuqeVim7wzQWPlZ1trivTV8QoT2pH
X-Received: by 2002:a05:6830:71a3:b0:80c:d34f:5f5a with SMTP id
 46e09a7af769-85f5075a36fmr645255a34.19.1794126472981; Sun, 08 Nov 2026
 00:27:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260703122832.15984-1-cuiyunhui@bytedance.com>
 <20260703122832.15984-4-cuiyunhui@bytedance.com> <87bjcnlrbv.ffs@fw13>
In-Reply-To: <87bjcnlrbv.ffs@fw13>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Sun, 8 Nov 2026 16:27:42 +0800
X-Gm-Features: AclHuK-No24RzFz5kz6KGOgepjfUU9hWv2-yH0FoZIN8FZ2Py9-_ynkukYR0a6s
Message-ID: <CAEEQ3w=B4p-_4pg3ffrkSA_AXuz86FCd-w4FSB50HoijcSL74w@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v8 3/3] riscv: store percpu offset into thread_info
To: Thomas Gleixner <tglx@kernel.org>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	dennis@kernel.org, tj@kernel.org, cl@gentwo.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org, yonghong.song@linux.dev, 
	jolsa@kernel.org, bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org, 
	thuth@redhat.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk, 
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com, 
	conor.dooley@microchip.com, debug@rivosinc.com, seanwascoding@gmail.com, 
	andybnac@gmail.com, menglong8.dong@gmail.com, cyrilbur@tenstorrent.com, 
	wangruikang@iscas.ac.cn, atishp@rivosinc.com, apatel@ventanamicro.com, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, bpf@vger.kernel.org, arnd@arndb.de, nathan@kernel.org, 
	nick.desaulniers+lkml@gmail.com, morbo@google.com, justinstitt@google.com, 
	qingfang.deng@siflower.com.cn, linux-arch@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f9xcottkcg8yefip63epksq857jm19y6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5B6381C0004
X-HE-Tag: 1794126474-119182
X-HE-Meta: U2FsdGVkX19oXARE2IEiNvKRERsx2v/8QV5OY1Zzpc3rW78Y/qkD9DGMWCXL75+x7Ig8qYME1JlA6be9CKfe9RD0QjFfHZF99YTp6JCo2mMpc9280oL9VRmuosK6GWSjP0/b3WNHUv2fisEXBLGFYWfUXrGFccagXOeSLrUaNtT89ZMLl7HX/4NgYOeAnne3FLeuKw+FnfOSPl7bxu/5jn3oGNUMtep8xJok0rzgmymyyYwDCLIHvL/gj+D5i5tCfqNxrcORDNzUHIQ0AkphIOiheHuTtVTbAuwByI2fSGz8+mHLT/qms8e1F74uMQEyf5Gu7SYws22hGUqzsGPYNw61wbgg0eQOKAHwUQLHn91j9pRW9LiLhBd6EKNBJEXCtgnOOywk28eAFc5bpMv4mSoJYt8JxuE0OsFfJOQNXXo8xZtONDyxjUJBeGAJPRZlJVNciB+ZCx5ZLgsjGGO3e5br1PjVEezezFkTibXNwrYXClaid2hbaR++//YosT6swbPoKcJa0itaU5UZNiKlLphHEZLKk1oZnZD1jY5tPGO1OTTYwVLaWK26Jcpj2qufQ3XPM/9znlbY2kMauuP5wB9gBzojQ4jj0hdJM/6FhFWb/W8rxE1FXrU8H2dLtJc4j9NlrwO9AyAHGWYyGvKU0JMuNEca8QcEP5VIADlaWhVIuDafMXDGjHDBJYe5Mt0bgInDPxTYC3LpJ0IvBXUEdfxJIZ3kyyDHPM7m/x2BrsjOHj/5JV7pZ6S8xKiF6O+pxYeWPWTchhMoRj0wFndC80uu9sjR4E4C5pxpAiBnBHJmLB+tmjkkMGUaPzUy1b0Rb8CXR3N3i7MhBPqsrx+g1DiPAiubu0NqYOJ/6N5QAwqiplBTOe3X/CXMKL7b+/hfIPypwkoN+AS4mZkmf3D/OZ09ILsHAahyXLm6NCGTsiIEIaJ2T3p6k+0Iiz8XqqxeS+ai9QmWmNZ1Gm3H6Cd
 33BRoTRo
 IPR9wfrSMa1tjxvcxzClt6DG7iQNJhMnG2JqmOkYJ+GjwblPjlMptpNRhyqtGj3FJwE3qBNP4N8p7e9ZgTbfu60kzYqUnkRseeTnQ04kbLaheTQzNf4SwiVzDJFC7ypCtZA0dp9wykrjvPMlPBQFHk0Xm75u3eAhw3KZvgzlC6RIZifqIqnbWphZNxs1oMpVYum3Y/mXyHHXuV94WGEMs/mqfPUZ0c01JC2gY+Cysmh9p55hoFkIQht4RrzA+a5g7J8uOlE0DAAgon2BehZiL99GSDNLpr28UfjuaNc+wCe2CQ9vVAFkUFXZU92HqniUXHYKVRDLm7VqZWy2yx87nUfLkagSL97YvNQ8SvgxS/vvwv9b3h40wcURxNK6Cpyy3Ub2RsPkPC7645TPZnuXFvBr8MzBxWQtFYliUG3lGCmnEsfiel2CPLWrFiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Thomas,

On Sat, Jul 4, 2026 at 5:02=E2=80=AFAM Thomas Gleixner <tglx@kernel.org> wr=
ote:
>
> On Fri, Jul 03 2026 at 20:28, Yunhui Cui wrote:
> > +
> >  extern struct task_struct *__switch_to(struct task_struct *,
> >                                      struct task_struct *);
> >
> > @@ -122,6 +129,7 @@ do {                                               =
       \
> >       if (switch_to_should_flush_icache(__next))      \
> >               local_flush_icache_all();               \
> >       __switch_to_envcfg(__next);                     \
> > +     __switch_to_pcpu_offset(__next);                \
>
> Why do you want to go through the indirection of current:
>
> > +static inline void __switch_to_pcpu_offset(struct task_struct *next)
> > +{
> > +#ifdef CONFIG_SMP
> > +     next->thread_info.pcpu_offset =3D __my_cpu_offset;
> > +#endif
> > +}
>
> instead of using __prev->.....offset, which is right there available?
>

Agreed. current is __prev at this point, and both forms compile to the
same load/store sequence. Passing __prev explicitly is clearer, so I will
copy its pcpu_offset directly to __next.

Thanks,
Yunhui

