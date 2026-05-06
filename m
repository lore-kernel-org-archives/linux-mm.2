Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304E9CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 21:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6811E6B0088; Wed,  6 May 2026 17:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658746B008A; Wed,  6 May 2026 17:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F1A6B008C; Wed,  6 May 2026 17:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48D9D6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 17:14:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E27381A0308
	for <linux-mm@kvack.org>; Wed,  6 May 2026 21:14:04 +0000 (UTC)
X-FDA: 84738247608.14.3163E88
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 00FE2100003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 21:14:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pKssiszP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778102043; a=rsa-sha256;
	cv=none;
	b=JGqe2z0uS1GpqapiTIoKby2tvaIapa29uyJrAKTVSdJI0gCVBPaMBbFcuf7wZrXPErxRdD
	SvkDCAwa6hhbcwtrIOuz++yb/k8ZHfhnuhPV+oGULYXI8MUZdrYi+vADBojIBbkrAVA0mo
	10ifQjezr8A/7Bv4wFeqEs8G/A1bHo4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pKssiszP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778102043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X97wysjOr3lFu30H+gcrFHrWvOgZ1GUmxbYI7Sxyn5c=;
	b=3ebQ3MhIlIU23LDibKwD0hTe2GM+PrUcDu6O29lJ1Iv9CmWRcQ94djTCHM57SJEyDc1Xjq
	3EPURE0MfvW5vdRuWOjfP0ZdB0sqWurRfbC2oeVwP2cn9VKN6OCRm3rFa5LONeLnxlxwBz
	kLJEEVn4xZ0TQh+xyul29Z8frUy6J6c=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so1528645e9.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 14:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778102041; x=1778706841; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X97wysjOr3lFu30H+gcrFHrWvOgZ1GUmxbYI7Sxyn5c=;
        b=pKssiszP5eCbGrV6d1Dsk8gunSBmJOb3YD4AdBeZnT8z+i3+uUhyvqxX9NcLPERf0a
         y52nXT5i4NbogUIK6AprGSqqbsm1UzDA3OGkyZYaP/Y0Vi2Lff3Gb28+Eg3fXOD/IxGY
         9WQ+eMH0RJHjP6hukFOFPXJxgE5i/z3neVUcMVVnRM0IortDzyjvrBdgEp+gieFoa80O
         KzEIJmSZNkNAHjzaYUg+muvysDabHCzlbtwiUe5x94cXbExgzit+kIEAGXtK7dZTD7Gi
         aCV2t4Nxhv944y1sXew5jTHYG+l9HeCYUoR2GrSE+GSQalkNSr2UZ79LDxKImS3nHvOU
         cZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778102041; x=1778706841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X97wysjOr3lFu30H+gcrFHrWvOgZ1GUmxbYI7Sxyn5c=;
        b=WZIxbAlRW8auWwS/xdfs4ptNx1spe3IRL3Vug5MYBw8gvyiomQ/4SK3RzAr40n5eq6
         cpUIKXWTW0GfvIxFgD4uhroaSHMJIQCpkGnRxECc/mrZmWiZGUsAbPwp+HMPg5tbqsij
         z6JqjSTEbn0LbnFdRE7JM5I2oxYATtcIJ8rbA5QnFFCYf3OnUz4BHcBHH177Xwxcmkin
         YC0ZWoKJ1xr/7zBDU+PODDpdBCcwUMencJpBO6N2119JYTU+cIF3qQVHCZsdkrlAywvv
         7a93BcolmNMJIeaC6rgUYON28ldbPtYEk2z7XU4hLSJ0374nGhFYa1V2AzDw7BVZqgn+
         6HFg==
X-Forwarded-Encrypted: i=1; AFNElJ/7LBkMLm+dItYXdaZYW3xe3ZPS6XzCRLxMmo1n2ya3+Kk6Xg25DuP+F1B6oMXMQWKEC1wHLLOLoA==@kvack.org
X-Gm-Message-State: AOJu0YyXBQcbRqT8M8HKvyocE+qCMzbOaAiIAVn0c1Y9UPwup51jRf1o
	OAy3/RFs2wdMt1khTiuibLgOPXlOSLikh3iTaXUwIJR7EIxRBHsXCR0Y
X-Gm-Gg: AeBDietnOtJyburghyjmoXu5yvK9k6UmZRqHdzlb0Z8QGPjJ1uqcJe/8h/GMGyAN00v
	x7PbIREB6GBlHoGHMzZVvFAMy8EyGbo9T4yEm3U3hKxfsKEf7Tv2yJgTesAVic59OeD59RNhqlY
	eGEqg54Gz7oz9OoJcyH9i/V7oSxNHvtaHi99oFBvLi587ny4e9mrWMPypn4R3s6KgVU95XxBiio
	JZEJFWr/8qf2sRHO+UaN2I3ngLVCTqPaDbxbkZB8YrnGjmw2hFvJVQmrWA5Qxgg3zAw2vAlxdzq
	LuHtTOaRUqVTh3FQf8i21rNClexogQbnKg7B88TA5dDcSHw+B0JpuLTnfkXauucwHGIud2Tw3rt
	t3Q6zhMIojJsQDum79JR3mIjvVZur1kpB/K4qmLkwNR80DUCnLb7d0SMsnPSneE6VMxYpHQgbQU
	zSZnMkgqzUmKpq2x+CL9cuhuLP/rR5dh3bOCYgXYoCYLb9nhUGpOz6Le6wS9HGeMKlyGUyy/w=
X-Received: by 2002:a05:600c:8b8b:b0:48a:97b6:7420 with SMTP id 5b1f17b1804b1-48e51f4143fmr85845735e9.24.1778102041063;
        Wed, 06 May 2026 14:14:01 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53826022sm78527045e9.0.2026.05.06.14.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 14:14:00 -0700 (PDT)
Date: Wed, 6 May 2026 22:13:58 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jens Remus <jremus@linux.ibm.com>
Cc: Steven Rostedt <rostedt@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org, bpf@vger.kernel.org,
 linux-mm@kvack.org, Namhyung Kim <namhyung@kernel.org>, Andrii Nakryiko
 <andrii@kernel.org>, "Jose E. Marchesi" <jemarch@gnu.org>, Beau Belgrave
 <beaub@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, "Carlos
 O'Donell" <codonell@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>, "Steven Rostedt
 (Google)" <rostedt@goodmis.org>, Indu Bhagat <ibhagatgnu@gmail.com>, Peter
 Zijlstra <peterz@infradead.org>, Dylan Hatch <dylanbhatch@google.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Subject: Re: [PATCH v14 04/19] x86/uaccess: Add unsafe_copy_from_user()
 implementation
Message-ID: <20260506221358.55ba5187@pumpkin>
In-Reply-To: <9f85f092-c376-4350-9a12-479d7b70399a@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
	<20260505121718.3572346-5-jremus@linux.ibm.com>
	<9f85f092-c376-4350-9a12-479d7b70399a@linux.ibm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ofu1ccqzq6wn9t6qa13mqczh9m6o64s6
X-Rspam-User: 
X-Rspamd-Queue-Id: 00FE2100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778102042-119707
X-HE-Meta: U2FsdGVkX19cIcY7rDnJuN8BxkMy5Of4U87Jzq55vWRr8osRj3anLuambHE1DAiUfeXgPRTEZbTEbwhN6Phf3z3soMgd2ucqbJzyUxruijbHqZLnbWvJjdIJXWsa7Q4VuAfV3E1e4qXwhOW/sHn4MNg4oqagdtLE6p9UnEGlCoPZznfq/8p3I1BopioeK93w4KHsr5taKy1KihFIgiBv3z1Lby0feHMYwhejxE1jALWouegJLGUga8sTmyeWY/u3OPfwe2wSwJTb0lefAzdZ6ZCJB0GdP0lP/aZURdu0Efli+ikQsNZN9GG9N88jnkWSLIW2yYPu/6ENnaMNfPuDxHF8Rf0XYDzT0sXIcNhfkG5bMOaA9pDNQpoZmbNqKCRVzDHlJ3xfFm5QcQrEyV7dOqkHeSEkYZjXumUPz40Hdh/xqQRBQx2rdqa2/8foSRBM6F23/jy3XQNt5xquMDpacjy6pBRGsw3gmcv8Rb/x/fQX8ztoly5PZpb8zVKtXsIXOS5lqxZODCY3kdbjKjP4hvJuMIyHfY2aR9DtHk3RsnM4J06Op+NdancfmXO5ecYDebEFHtUacgEEH2Npf5lSPTNMoG9YtP70Nqoog6obbCt6uBDxn0kGfbK694uoX0WNcp8qoPhM670w6yCGQuKtHe2rV1lQJ2UwkbLZgFvLVVVwZcq9XYGFRzMr+MaqdMUzX2S705xZnmnOXXoPiR/A5JlgCDNlcRQYbgdANZf0B/6F8yzJv32gj/Gr5NV5ZVCeT0idvte3DohqftSOQ42F7dCSEdy3qvnY8fAh87QLX1FfhYsisSknHo48jOrdoFg7pH4FxH+Kql3tQEc68hnNKAXgGbYgE5luI8DZnHBmyj3wcdMKWVnNjERA2He+DoWRYFu0yXFPxDRGXW1GqQq/f163B55pCnmySN/uyly0mMHwunkM5P5Uir9RlTdWqlzzhQeYJC8CmuiRVeyerFi
 bJftGlOC
 JXE9G1tLlLkgRzxJAQApCGLVYcfdwh2+0ZHJpvAUBS/n5+d+en/aMhFj79T6H2cI+cEtlBa9mbVLmi2Ru6MXzNEB5ZOCC7YK7xUktPOmEAbb+wsSO6Bnwtt3cbDD+8BNf+4EcJl5ynwlEpY7whEBls/E1bQNV91M98y58K60SRXk3p3kmTge5qXurFBVbeyowAD33sKQRX1Vl6IQVOkdVtk/XNN0O0ZC3J93O3RdsdBR7tbLzZVaIMBzWU12qGP96cFpRy6BJiWPLwNexkehuKjzcoAb+ma5JuuN9dt20dw7QHMB4ww35opNBoysQcpzhTHV6ExSAjD2h78UvxE3xL77El6BpBUf+pgBDme6oZsOCZSplKp0E2Zk7OFTy+L9baUAG5SrVKQLcKg+MwSDuw3UzTByUuUe9Qud54etHqoWziFwJbq/snd6RiCCFbrPgHTQYsb+zm7I55Hj9YCW4hJ4pkp8ItXXuyEgUP1oJlQhBeiSRLLdzDog+RYubXhHkpuJE0kkr8ZONKdj7XQAK+Fcwgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 6 May 2026 16:09:16 +0200
Jens Remus <jremus@linux.ibm.com> wrote:

> On 5/5/2026 2:17 PM, Jens Remus wrote:
> > From: Josh Poimboeuf <jpoimboe@kernel.org>
> > 
> > Add an x86 implementation of unsafe_copy_from_user() similar to the
> > existing unsafe_copy_to_user().  
> 
> > diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h  
> 
> > -#define unsafe_copy_to_user(_dst,_src,_len,label)			\
> > -do {									\
> > -	char __user *__ucu_dst = (_dst);				\
> > -	const char *__ucu_src = (_src);					\
> > -	size_t __ucu_len = (_len);					\
> > -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
> > -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
> > -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
> > -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
> > +#define unsafe_copy_to_user(_dst, _src, _len, label)				\
> > +do {										\
> > +	void __user *__dst = (_dst);						\
> > +	const void *__src = (_src);						\
> > +	size_t __len = (_len);							\
> > +	unsafe_copy_to_user_loop(__dst, __src, __len, u64, label);		\
> > +	unsafe_copy_to_user_loop(__dst, __src, __len, u32, label);		\
> > +	unsafe_copy_to_user_loop(__dst, __src, __len, u16, label);		\
> > +	unsafe_copy_to_user_loop(__dst, __src, __len, u8,  label);		\
> > +} while (0)
> > +
> > +#define unsafe_copy_from_user_loop(dst, src, len, type, label)			\
> > +	while (len >= sizeof(type)) {						\
> > +		unsafe_get_user(*(type *)(dst), (type __user *)(src), label);	\
> > +		dst += sizeof(type);						\
> > +		src += sizeof(type);						\
> > +		len -= sizeof(type);						\
> > +	}
> > +
> > +#define unsafe_copy_from_user(_dst, _src, _len, label)				\
> > +do {										\
> > +	void *__dst = (_dst);							\
> > +	void __user *__src = (_src);						\  
> 
> 	const void __user *__src = (_src);					\
> 
> This was suggested by Sashiko AI review.  Any objections?

Try compiling it :-)

-- David

> 
> > +	size_t __len = (_len);							\
> > +	unsafe_copy_from_user_loop(__dst, __src, __len, u64, label);		\
> > +	unsafe_copy_from_user_loop(__dst, __src, __len, u32, label);		\
> > +	unsafe_copy_from_user_loop(__dst, __src, __len, u16, label);		\
> > +	unsafe_copy_from_user_loop(__dst, __src, __len, u8,  label);		\
> >  } while (0)
> >  
> >  #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT  
> 
> Thanks and regards,
> Jens


