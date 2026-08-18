Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B3CC5DF85
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 21:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871B26B008C; Tue, 18 Aug 2026 17:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8235C6B0093; Tue, 18 Aug 2026 17:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E566B008C; Tue, 18 Aug 2026 17:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31D806B008C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:34:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A75B080310
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:34:14 +0000 (UTC)
X-FDA: 85115693628.01.368E832
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7064A0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:34:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oys+SFS5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of utilityemal77@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=utilityemal77@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787088852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sDmUeEbcal2gxd06G7R/9k1xkDLSkoYHHtzuG733R4=;
	b=OPo1xCIJ+H5ktBq/nzGDGukZ68vNftjNaG8Wu3e7pzpbkC1nf/8vRBJwyek3HiYZ7XfBUM
	kqyy33kxSlJvynOfBJbgqtQf+oTkoFbyn5CMn1H8FdU4Y9BWEpi2K8stEa3x9yRLBmtGje
	t9fIwohepxzL+Tm+IZl8LMugV+gup4A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oys+SFS5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of utilityemal77@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=utilityemal77@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787088852;
	b=4J6VAI8at3baVMYFwPasNC04VgAA0LQtXSp1igPdMchYCm5mlF7kdKiXIfHOTqs13m/H4x
	h4tlYI35DorYvEKRevHrtA/T126Fo2IrhNlmgx0a/ozvv7lFQjiYWi76pGMktprJQnwl4P
	Yrgg/KnWmMow6kJUUcGDTJ898FnLHfk=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66bee06ff74so638999d50.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787088852; x=1787693652; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3sDmUeEbcal2gxd06G7R/9k1xkDLSkoYHHtzuG733R4=;
        b=Oys+SFS5ndo87ZDo1XOVdqe3kNs6MqIJyKyCrwT48f7zsRQrHT0S6LeAXqUYKjD3lD
         MgUVCXKIseNmjbDoyvciHGcILs57Q31IReaGa8AKpRdHuSESQp8t0cblsGCu5ssyYxnn
         agiczV5EC/LelLNBf4YJ8fQR0CXJwWnWBrcPEjY0H6i4fTsR2mvng0kQgf/4trxQi5QA
         kXz7RQ0VuU7H8+FN3fY+Bb10yHKV7C2JJYzkKwRZbcwwFJq77CemEe2jJVoRl+66Gw0Q
         +YsppAfxIZpn5+NjyTpOKE1O9NcYBiX1UdrQz0mxmJJjgkjhVIWjVDktheXERk6XItMW
         7Lnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787088852; x=1787693652;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3sDmUeEbcal2gxd06G7R/9k1xkDLSkoYHHtzuG733R4=;
        b=UV7YK0qZ1fKeyIoIBCih5DeZRIfOe5cjff96tGs3w1sQDJmS2veISKDBdn8whSEp3F
         VxlF2a+95FXCQ61MY68U6C8+9/jUzUmOb+m6CizNa/yTBfWlhFgegm6zq0ioyUrAiav1
         Tio77Qsh9cQXBmA1a4RRHpWOOWbrqeksxb2GgqYGar1c20NxkVPMEBkKPXiLWIqkYd4w
         MGfSgFBb+vWPtqkbRDbGXP9S7KolGMAzfGE+v2yVcWm4JubJrwSRQl0cqId4u4d8R5Qw
         4pglFVaksrcqCZgY1Ii6U6Ae1rM35FFOUQqdzJNUPiIUl9Ovt5AVwH2LwIYeg5MN5UkS
         62vg==
X-Forwarded-Encrypted: i=1; AHgh+RpOM3FLWY2k/hB8Nw79ile629rnBKR3X+UsRD6/x7+jYZwIQGyn1p0RvZVq2jt7ZUHRWjRb/HOj1g==@kvack.org
X-Gm-Message-State: AOJu0YyfCIPbsfaFMGcwrfmMC/chiN3WvDwqs5dLxP1tD8h9RU5nMvkp
	i4smLjDQ5/abvchuZmiDgW70hpjynVziFVX9XAXB3C6nygF4evDPwMlr
X-Gm-Gg: AR+sD13Yczm02t98QFb55WrVS9xQ19v0OVNvTPApJ2lpQDAOOBgyPXcsNKSIo9hnnv4
	OEFhn8papbk9ZpQo5i9CHqWO5SBICNv4LPmUZGuyUL0+8xikwwx6ThBfkELJDkYXR8NqYGvkjVh
	qcQhJk+BuK0CEeJVDqqugkBdNDL8Vh9gQzb7HE7niVtdJSQRIcmOigriMhO74YHp4bbRxbRolff
	ESLU5j5K8GDol+XBSsK7sf9SlBgvoMvBhdrzOQzXw5gthSvXXzXCzjlyaSydF9lErhjQCdxeQsI
	QLqZ/qbsvlJ8hVGl3UB8eEqnVXBKzzSf/Oioo8Blavr30JKXtLeU3F5ivji7GDuoJxelxQ1cIrf
	EhZnEAlvBd27ncMOQ39cqG80agpWbeM9L2A1oFddE9RLpRhShVvX/2155127ccr4lJExv4Z28ST
	muXFMouLuMAOl41fEG6r9MKo8FIUXfr4RvJ9oDOW2lPgDYsIsW2EMfcNWkmemCEyUeicnIvG4n8
	cpvUefzXZHYxq1WYCwo9vw=
X-Received: by 2002:a53:e911:0:b0:668:9b6a:653b with SMTP id 956f58d0204a3-66ccb537d3amr50318d50.3.1787088851823;
        Tue, 18 Aug 2026 14:34:11 -0700 (PDT)
Received: from zenbox ([2600:1700:18fb:6011:5ffe:d5c9:845d:50b5])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66ccb19e096sm52049d50.19.2026.08.18.14.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 14:34:11 -0700 (PDT)
Date: Tue, 18 Aug 2026 17:34:10 -0400
From: Justin Suess <utilityemal77@gmail.com>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org, 
	bpf@vger.kernel.org, brauner@kernel.org, daniel@iogearbox.net, david@kernel.org, 
	eddyz87@gmail.com, kpsingh@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matt@bobrowski.net, memxor@gmail.com, 
	song@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next 2/3] bpf: Add user memory access kfuncs for
 linux_binprm
Message-ID: <aoTMu0_CNLyLGh45@zenbox>
References: <any3wCj66dWbwgwT@zenbox>
 <20260818082441.4091-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818082441.4091-1-tasos.papagiannnis@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 8s49bb9oj6zzd3r6iw8q7aw3mbs19adb
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7064A0009
X-HE-Tag: 1787088852-275766
X-HE-Meta: U2FsdGVkX1/OUC0wl5Mozu/aRA7hye8Q9x2mxGSIg9U0ow3chyt+YVTkdirKD3Gi0gRzohHf8ZhG5XtlcwIfVBKsVPzr072ltkYJZpYtXCH9Znsf3KEq/yCauncBdBz03Rb9LUjHY+KTWfzQimEJVywbQ0bF1OaChNQvrDbm8c3nDHL0LrPAebNpABLXm9chTXDBwL4Nefayu9/wURNRDCRAIt+41MIstYbIu0VXToLeiZ1EzBUnJ5FbKgszelVpnLMFh2f0WuxlmztfAkfzDQv6dOQrgGQCRoFm1PoMEcS4tZtnGgjYxBu25iIQMa9Nif17MtLi5ge3ssyM+VQIBWbCI0t8Fo2Zp+yrsX779pqNGOZnMHDu9MnCxJkNKJFURHyLtvQjgO8YoTUuFrx7FniJYD3HSmT2QaxLAQn2XsmuLneu9iNTuAoehtNcHEarFnq9PpuFQr9bcAXLS0tWzcfo9OKRg2XYc8f/XXE3FsMmJ+KVmYTu0mAYNUlaIpiJueFD+y46Ne1vXShWuOPJdSYRNRXrny66B07iX/lgln1S+QyW67OUvLFp3XfwKPRc4MeFzU1L9pQM7G+a4DfNoFNzZMVloOgaN4FQqX8+MhToI0Ree8wsM/fNUvJeoLpGCwatDIfMGJwgtBsWT4RY8rgOSgoNEdYWkB6KHB2SCIWxlNXuxhOjF8hs2yz3yAX/noBFZBtRKI5fUp1WxE+Y+bcABJ1XTjrSNSnOf+tsPpbDeKzIb+xeRJr+LCPQdDqgp3HLX9ZpsY99Rg0Pqnw9yKqvbInZwww/WRmnmzlOEkukn8wGiUW4ZuvvYep7SSCKRf5f07wjOnD+kCFVAmk0kjMH8yW/LI8S3ZghRtHPRql6JYIVVVr01L6mazNcfKDHTPYvAJ2ukr1BuTCxOCkZptD8mgP/MydSHdDbSEjAFQlWgQUJpydaHUEsutlx1mjN7jBkZwLzhhYi6rYaEhh
 cJJnTTrm
 VksLXOj5PgcnCAW34IGBQJyWXFLP+/yIVuwzrhW9d7wXOdz/XhTE8HMr9P439Joz6Y6CGE4dv0Pd7Taws68gAlN4ThK+cw2sVfksBjLC8UpI+oA5ESSuXIHUydF0X/0sGg96UmFo9qeKfWlQqdA8ue7uVNY4irKpdBwuAjT6yHv1l1lyrk02/4ZbnEs8igAMfGcOGozu/xU9E+sUvZalB9OBeSO9OtEfxvRWaVqkDfjt8xb2h+byPn6V8DWWGva2nRU7bObPzEMNM0mEUtQNplpiV3/koTSn13qeSxqpFZVlP960qcibmTQAJqvvhqG4tlrwdgshHqZFyz25qKsZRyMSCB0VKfENG8O+IcmwXTo3/4b8LTncg9gkvty1maIxPrvCBznuXUe5O6OS+SAt0gqaf+REf8Ea93HatkgKVLlmA632R3xX5jIY4j5HYmr8khyRda1Tgc+UxcSF64s28JQHxlDtkaDpQ+VyYZ5wtuzoowHvINQk0Me1NmX3j9Co4p2NusaZvt06UExk85CDKDBAcP9j1xhwivCmQpGivhUvB1FqD2i8XQA8qgWnie+XD6kW2SX08+xj6F88o81SAfWVgJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:24:41AM +0300, Anastasios Papagiannis wrote:
> Thanks for the review!
> 
> > Would it be better to handle that case transparently rather than
> > requiring introducing a new kfunc / leaving that gap open for NOMMU?
> 
> > Either return an error or perform the copy from bprm->page[].
> 
> > Unless there's some reason I'm not seeing.
> 
> My understanding is that there is currently no way to use these kfuncs
> on a NOMMU system. Although CONFIG_BPF_LSM does not directly depend on
> CONFIG_MMU, as far as I can tell, no current NOMMU architecture provides
> the required support to use them. For this reason even if I write that
> code, this cannot be tested.
> 
> > It would also be better for portability across NOMMU / CONFIG_MMU
> > systems (the exisiting kfunc is never registered, so a program using it
> > would be rejected rather than able to handle the error).
> 
> As you suggested, I would propose to register those kfuncs
> unconditionally, move the ifdefs inside those kfuncs, in the case
> of NOMMU return an error (e.g. -EOPNOTSUPP) and allow the programs to
> handle those.
> 
> Does this sound reasonable?
>
Yes that does. It's a small niche anyway (I don't think a lot of people
are using BPF and NOMMU anyway, and BPF_LSM && !MMU is unsatisfiable
unless RISC-V or some other architecture gets JIT support in nommu)

And when/if (big if) it does, they wouldn't even need this kfunc and could
bpf_probe_read_kernel() bprm->page[] directly.

So an error is best. 

Justin
> Thanks,
> Anastasios

