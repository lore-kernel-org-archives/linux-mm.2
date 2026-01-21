Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 351E8C44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848636B00CA; Wed, 21 Jan 2026 12:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8204B6B00CC; Wed, 21 Jan 2026 12:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BFF6B00CD; Wed, 21 Jan 2026 12:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 635AA6B00CA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:58:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E67B8C315D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:58:03 +0000 (UTC)
X-FDA: 84356729646.29.B8BAC25
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 900D8180030
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:58:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oaCHSpse;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769018281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2e/dfKIPzPxfuYZfQWM3FRBJx3bq+IVKEQQ8IC7MPec=;
	b=oQXAReanL8WEDtbmT+FdPA2A6CZ6KZAepxzhp4pD1QcuXhDow191+MXIDnpjvl8RT7roRi
	36yqHKTrOTe/BFf9vf5WqrRmDimiGmNu9Ctmg6lyz0Crjd3ESilzAVE3WuJNdcUtNe7f4R
	qGTcTLR6vVYoVSzzIO6sFoE+F0JB5ao=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oaCHSpse;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769018281; a=rsa-sha256;
	cv=pass;
	b=6lh2I19Bbf4OA9xRwLPCC+w7hN3GKB5reYkwfa+KHptnIFbr6H8mrrx+3WiOUa9ATRNaSs
	EOlYnIZ2Q+Qyjn99IPjekl1uF9rTMXrwox3JRMOzmHesozPNKPkoWt21AdM9e0H5b3gTY+
	VP3HWIZTUXeAGxJmGH6V4c5YL8RO6HA=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5014acad6f2so9861cf.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:58:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769018281; cv=none;
        d=google.com; s=arc-20240605;
        b=Fu/41mNuPSVnAW/6ohOOIeBfXWZX4XprfYeWsAjrGlj8p/olXyomjDzTUkJpF49yyg
         ToP7v42/1AfryG+kXQfsiub8PcOpnzq2u3AW2OiiLapn4+0g2xPJed/5H7rYivaGMB4x
         e5+aPyoEhgvptkQkBRJRuOn0HFf6QT738n13CZoy0Ociu1FuuHUWl84NtM0/APAo5itC
         kCEulGiCKXGMskGwOOn9BasTbhK8cHizbkhulkUt4v9XAm0LcwbGhQYnsr3cQT35A1gT
         9aUtpoZHHEXQa9JkUhp3tK+uf+mXxG5rx4bSHLsEwg8fEKWAzzIqnM+X9TMZmeAnqWNk
         6kXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2e/dfKIPzPxfuYZfQWM3FRBJx3bq+IVKEQQ8IC7MPec=;
        fh=aAOCaKNmWlSkdXjIGoVu5XWypEPLBhAPnOFr+cP869E=;
        b=P3qY505c/wYmeQgJVhN0uFPICZ2HtC5/tC86xyt33VZV7A0m1QDCh+Td/8ut0xxR6q
         lqw27FJf+CLJ2YdUqKdCU/i7jxGP9ng2mVpzJxTbJHglbjrGAYuzhL52eGSO9Eve1GM3
         u7h+C58hJpE26qCfhMl9G0HkiYZedTACnbygXKwc8jqfS83JNKcWrrFSQEbqVjTXrtO5
         cQHvaj/8Pa3J+Wr5dXrNBHl9KoCH3LqRz58wZ7tQA1OcSrbIc8CP7+tRJO9HVaCLyJ6Z
         0mD+QdqeDddpD5TDUMQr7d+pzhyHHPni+l3am/cJ2C0olUNu+Fb4lgqDyJJ5tbgJtlds
         sHYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769018281; x=1769623081; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2e/dfKIPzPxfuYZfQWM3FRBJx3bq+IVKEQQ8IC7MPec=;
        b=oaCHSpseLUDKDgObwM7w2OQPqFjToIOpqC23bzZo2M3rn6XJUCA5j4Pi7cxGIazZW/
         22TF4mf5sfpZECw3fSus/xcqXur+fWwmwXARdYW1Y9oxzNgi3Je8Yi+Dv6lnEtQEXkw1
         RwTyt8GNUGuEhOt1J6f+FcYcKsyL4rgwUJ0k3zOv5bqnRcfmbHRFCS++5EEtuTMlfqAC
         hyAVOctJWaMCWdeI+zXIYzYkYL1feDYgif1BPrZqrniZUmVkyJUf2hpHOxKf4IXsVnWQ
         o1zQnJjkk6/wJAh8OczVP/kOknMP/1vm8UTis7kdhHLrwsWux2kPpT2nOG7mH/6PoubE
         kAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769018281; x=1769623081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2e/dfKIPzPxfuYZfQWM3FRBJx3bq+IVKEQQ8IC7MPec=;
        b=RNkYHRxEk/tLfFq5I+C0g+NrY8Ibma4uvMdL4ZkGlJSaZLoTcWEVuhmdK5vhEhsUuT
         Xe+1U8M2fXMj/1YdZMfzT+L6CJC5xf73LdAGjWQb8DYAITs5zm/jex2CZQn4tiBaCs0X
         M2umaIsacuvtER4jyhtdShrEE8sxKC+M1sfYg71UYb2uCEO0tIUOt/avXEXyaUZor+Bt
         tZ+iTzqe04md8qul5+HkRAs8bMmojndp2ch990ez5WOlcmTikK00mUT5x7udm6Ny1hZ6
         1cBmzJ4TladKYBZ/D63l9WWZt/wKepe3E7W2RjJrPMeHX2QMDwZnwRELtWyN1XO+QVag
         OY2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWg5nGPOxNJam1KYYRwYjDty0LXwLh8RMAYaNDpO+yDs6iS2L46J4/QhkxRGTKdqNtPvXaoIn2Nyw==@kvack.org
X-Gm-Message-State: AOJu0YzCOTVYdWHIkEvOlHHQqJMlMDLYTRC4ONpvPGFNNsMWir67PMEn
	QAO0ytv53nMn708i6KiAl4HkviQOc1YsEdRVxwNJjCHwus6CqFSLDTS/Z0V66vsF2BaqVIX0OB6
	Rc9T00MoOUx1bfyUuhN4/qyO/Fy1STcRbiYKhKT++
X-Gm-Gg: AZuq6aJvT9YSqMKJebobOug/QLCp0Q7Wtol7Jji3XJzkFGwn9nasEbMU2qUy/uwtCM0
	WdQn/lTJjbr2Np6PEYuxQHm3CEOLt+LS8GHb68VpjEGUowIUodygF9wsXNwiAQUFWGHrj9xh8cC
	rna6c/MZnM+55Ln7yBdV+HfUqOLuE1tH0Po8gqBdUnWUbqSgQhF31hMFnRKV7RIPVgKJeLon0zs
	Fm74Pzp5NMxqzjIVJMoF8GUZ5psxu45WzjIJ382m0EPEJJiMui11oBrpWP2HzroIzlfcyMWDSXm
	QNYmpY/Mwb/d5utJJjFCc8s=
X-Received: by 2002:ac8:7e8c:0:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-502e0c62ce0mr15215251cf.14.1769018279867; Wed, 21 Jan 2026
 09:57:59 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-16-5595cb000772@suse.cz> <v6govsosryla4nzgzbfo3eeiziabn2tdprzhg3zcpoxkxq622f@2ra34j7326mn>
In-Reply-To: <v6govsosryla4nzgzbfo3eeiziabn2tdprzhg3zcpoxkxq622f@2ra34j7326mn>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 17:57:48 +0000
X-Gm-Features: AZwV_Qj7XuXMulWBwzFRyGRxqGQl3pWQ5GGLctP7N8bmgHrWL6WoILa1XS1waUQ
Message-ID: <CAJuCfpEPX-jjztYVRNX-MzQYdcf9fBrePf0zbhDJFKaEvpcp2w@mail.gmail.com>
Subject: Re: [PATCH v3 16/21] slab: remove unused PREEMPT_RT specific macros
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: yg37t9fnicn3z5gxn7rzpdiyap4qmhc1
X-Rspam-User: 
X-Rspamd-Queue-Id: 900D8180030
X-HE-Tag: 1769018281-160842
X-HE-Meta: U2FsdGVkX18cxPpauRv+r8yS73cWxMGhwA+/K6omPVDI88rtFcAV1Yl3YuDnxAQQ0t7qYNnL3YeQkDOGGWBft6gYvV6B7H2yqIuel37EZXQOg57I4eBVfuTZ1GUKx2sYylsEGkO+bHCju2Sm0HZb+vmOo4HO7Eq+THcr1dkf1/YKoNEX8GZZD4mlUaa7lcjLRQJ1LaM+ATVhnbouUPb054IXUBPn2KKwh9UWWnYlykfHPUpfi9Q9P+V4Y5PIgT137uvkid+EEBRiUNbqYStASXRxJ+3Oc+xvJPYl3dQIMBknY7QObX0eG4aI5JEE77ezdNL72hej0P2V9yFCsdDpjOSomarjKiflrlLJReTiLmGnJ36DM1so21AOzioLGS5M4NhBkQrpM4bFGOj1CInXqD7+Eh2nPoK1obMJP1ejTswQ4tbQNGEx8viS61OuFb+pW6dgASZvzZA77Im66omFOr1SyYOzIzkB91/++NrAvaX8gK2k+jrYoET9R8cMnlTX/JXhm56YiuZDZ8XN09zjJMWnj+33VINWATBTA2SsPeSiPQfRnSPJbQbOxEkPmf2e4eFi7uyg3IkUG4mH0j+YSgQuD5wTjd7ZY8ODc1bE/MHft3bTsUtBSkuBHvNg0HBvU2MPIrGupxvc4DJ1/ge7OLxZn0tnkc7+fZYujiI4EVFEa4IRoTeseYCowkN00Qm0iGm2yoPw9xx6OF8Ak/4xnuUAxGxO22HmAPN6G9BjiCALmrgXx+qeRLMx/CUnv6LCI+WsFhlEH1FMlpJcTjC5mZzzl4VSprgNlBXI1/5WtcJUr2A36tjZipamyXGv73u3elHwHcn2w5TMH7SBDCheLvo7sPPRXJkXLJLNRxbbJJ3CO3wkk3B4taRe62+CtJBD3yIm8JVwAXOg7sngrtpZ3mUHzYtkeNOqOpNc96pxhKlC+PntjiJx3PvHvvk08x5mnn40Z1os2ry4sw2wtRR
 vj7qo98K
 SwAApIowf6kV4ajUnUTrbzzYWEuaUHmQn0upuDKvn7jTb//C8FCQ6k3bH+kO0fxwfvQvZhizig0Ap7DzaKt96rtNRFzxIpkOf7c+l+q0xdrAfJGzHsnLGQ8PgRaPIhH+wt5Su/LDWXcsnTZv+6I2r3fhYjjF9iSp86hQ/xai36omMg+I9+6jeU94UbZLUs8KFoNqxmGyb5sTTn+t54alVy2LZwlQOJuiRgCgEvSgkYkvV6Gc8ixfHIxRrB8OEsCCbdk0U3XvS/Ne8POydfHQptaEZW8GwJnrAa1WCi10HkkiEwx7qfFVpT06GrsKKsoq272N9vJrf66XGxArQUTjsfug91A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 6:43=E2=80=AFAM Hao Li <hao.li@linux.dev> wrote:
>
> On Fri, Jan 16, 2026 at 03:40:36PM +0100, Vlastimil Babka wrote:
> > The macros slub_get_cpu_ptr()/slub_put_cpu_ptr() are now unused, remove
> > them. USE_LOCKLESS_FAST_PATH() has lost its true meaning with the code
> > being removed. The only remaining usage is in fact testing whether we
> > can assert irqs disabled, because spin_lock_irqsave() only does that on
> > !RT. Test for CONFIG_PREEMPT_RT instead.
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> >  mm/slub.c | 24 +-----------------------
> >  1 file changed, 1 insertion(+), 23 deletions(-)
> >
>
> Looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao
>

