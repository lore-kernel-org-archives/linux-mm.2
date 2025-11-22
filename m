Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B12CFD2F2
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 19:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFDC6B0022; Sat, 22 Nov 2025 14:53:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F366B0023; Sat, 22 Nov 2025 14:53:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36DF16B0024; Sat, 22 Nov 2025 14:53:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3506B0022
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:53:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0B3913BF2A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:53:56 +0000 (UTC)
X-FDA: 84139293672.24.D891B00
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9385A140004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:53:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=UQHbQ3YQ;
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763841234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8N0HudTgWpU/ayUVIeNFnWWwreLw332W8BlQTA6nQs=;
	b=regisRVAJuhVgCU9DXn1mZsFiVPiULdOCgtVBCu9ec+2l54+uuZRjxKuL82U+BRklqOzSt
	OpzyUhPO8YA64wU6hH1cV85HZMICXUSG/SgknMNFHiotOMouurgsavvX4BKnq6Zajiul4e
	gmsyB+ouPtsRcYjMNSEHG3JD34x/2Pk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763841234; a=rsa-sha256;
	cv=none;
	b=5FLJUmjr2j1NXMl+UGE6ypnmhaTqEcZCmMoNk50CuijrPuJBU5XFdwsDZge/DjSrBzlwLy
	GGjnuvqq5zjMvS77yb02vB2j9b81Yfy62NgcNTZ1FGmwTI5VPo5luKex6vrNOiX1C3V0ky
	aTExjAUjIDsTJd0ZYU994bp+cBJr7j4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=UQHbQ3YQ;
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7277324054so472758966b.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 11:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763841233; x=1764446033; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V8N0HudTgWpU/ayUVIeNFnWWwreLw332W8BlQTA6nQs=;
        b=UQHbQ3YQuET8otWVNKcC/ePaLBDkkE7xZh26SaTNndeU30mlJeYvMghRLJ00jKs2r7
         P0c/iJSN65Nns3Gibv6Z+hUBiAKLMcPEaeP6VjvBVCRabEwt7l4vTu/qHylLNGyi0OBB
         FLPVvP1uEMEnOIzTytifFecrN8mL3Ul4HPiEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763841233; x=1764446033;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8N0HudTgWpU/ayUVIeNFnWWwreLw332W8BlQTA6nQs=;
        b=VuyHm6BSdk1qco9JJooaE9LIhtZKVH49aGk/yAe6NVG8hGjElIRuX5YmgAkXLUDTIb
         46G1eTULf63qLjjJbpFIQ8uHDUryhJCyes8QTUiR4QoZFwisEJjAi4XCXcYry3d5R/qs
         HOaESN8hNIyF8O64tJMziAemJKciW0vu4JLbePK+t0yPNX/6AFJguo1IBivss1CsBLal
         imF2zOwou8kSFSMVbHoO86t5EM1lbY3wq71mtiNCDda/vFjI5sZ3NQKQ4z2XcS7dydjq
         n7MNDUdG1HpfgGTnDsEhwU307HduD0Rl9keAOcsl1ayjKL1Z1onuQU3VCab1Ec3pQ6Cd
         UF9g==
X-Forwarded-Encrypted: i=1; AJvYcCW09oRqmA4xDr+iNXSJ1lABKVnBmEPkuxkcioTzGa8iXqAGvgcD9Zcbq+5ULq/X3QhwXGHMxz1XeQ==@kvack.org
X-Gm-Message-State: AOJu0YyDcfkqQjl7nbWEgR3DJs2Zda+y/S2kUcLNI0ePabnmXUDF2sH1
	jfo92ydwEJacc84b65wSQbgHsY231QpHUycCDFrRr2I/6HzxnOHLEUOUgjJD3CWOCJtMGJjhP4y
	tUg5jfCY=
X-Gm-Gg: ASbGnctM0hH7kVUcCIT92QTzvP5xVInmxqisIMcThjAORdslmi3a1F8aK7qlISuYZf4
	oR3egb5PUcNCTgDr5bog78CDDGOhUjtGgbAlkz+brFXqx9GHiRLSH43h65peS5O2wga2K0oP+bL
	bewvzTiG2RYhIEQB3xdftTP2SYT5blcRakhfdcUHfZfPNCieSfJfRF+L4vz5EmxX0PKsP46dtFl
	k+NWV4eEeZ9MyMr/dup9PU+81stNmHhJNMxagnt1OGAUmiOAJ0of5wMx8EDWqs0nOCK/TZ5DC4P
	cBYu4XoOoaPuHpO1B9E/jUJ2OLi6EzrRu15/cyQpWFofwNKqh0Cto15fiZ/7IyFu9cQl2yNb1Me
	iNzsIVViLfqqF3xBXgWp5G1xaEHVZZF9lh3F7Jnzd4mifg+qi1eV7Czs7hhMW7G08qygXDpceLr
	UR1YatoqvUsMch+ZV//u3sJxC8mXBubkk0RSnDWgrBgrLinTXUMbu9fZSTQp/G
X-Google-Smtp-Source: AGHT+IGJMw9f5NP1tQ5uWfBskSZ7wRKKkKWeSym1GSH0ei48R2ds5vTKi3qnHSB6B0nwWu/etXK6bg==
X-Received: by 2002:a17:907:7287:b0:b73:8cea:62bb with SMTP id a640c23a62f3a-b767170cceamr741645266b.31.1763841232636;
        Sat, 22 Nov 2025 11:53:52 -0800 (PST)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b765502840csm791602866b.59.2025.11.22.11.53.49
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 11:53:51 -0800 (PST)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b7277324054so472754366b.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 11:53:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXvvL045tD4eQmV7A2DouC3qc9xuUcf0nuSUIjIu5kkxIpp3Zw0qg6UvsIPhR0Tn5uHOtZzTU/qdw==@kvack.org
X-Received: by 2002:a17:906:dc89:b0:b72:a899:168d with SMTP id
 a640c23a62f3a-b767159ef70mr722565666b.13.1763841229122; Sat, 22 Nov 2025
 11:53:49 -0800 (PST)
MIME-Version: 1.0
References: <20251122014258.do.018-kees@kernel.org> <20251122014304.3417954-2-kees@kernel.org>
In-Reply-To: <20251122014304.3417954-2-kees@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Nov 2025 11:53:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
X-Gm-Features: AWmQ_bmh5uuI5AnMmiOZjFdonQtxoafj9Bhk7ARyKlTTPm6tMsrXbFYBvPbdku8
Message-ID: <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org, 
	Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, 
	Tony Ambardar <tony.ambardar@gmail.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9385A140004
X-Stat-Signature: zh6dr7tk85o18b1hfg67wfrcmf8mm9x5
X-Rspam-User: 
X-HE-Tag: 1763841234-509446
X-HE-Meta: U2FsdGVkX188TxrmWJezzZwJs3qvUgC1Kg7MSZ/3+k4doUR0nDZeR6blPhSFrr37bWzJDTu7zWuCn6yu/wj0WUqukzsC0JBexFUXsL8A4pvFxAJZv5bC/DnU6CLymbt8fL5VYAkYv8e0tOHbrDqBDryyj/aqHIRk91afghCXjEYai/pZNcUMQOkY9pWVYCQLZdD//cpc3WG1Z2MBAt/7x7gTNcMmVl0UEbOeYuJ603Q0DUtrIBJ7rc/ktQEl3iuV0/1PJyudhm3gEJCC/LNwifDMcf/H/2E5t/6Pq18AjBNPJ2939oW6rglDahWfTqk189tsf4Y1iPU7BiS6hfUahN7KksStnoBzaPkQhXRtQSvPUyNMYjUKsLG2UKkh64RUzhAp2H1AoS0cO/SIwUQRS6veeFc3/fT1Gp3jf7hzanWtqWILVDF/d6OsuuoHk6r+7yzS3PfMfYbFVGSmJnkk3WOQDiBNz4EbJ6xoYdIV7zHxMrw7tkhbbtmpI3iAlxey+0uRtTLvUQdgbeF7ymoJLZmCrW8mLLtbWDh2FpMYHCOEqBuh6izmrn31astFIF8yBXIJSnUNXgolRN5TF/KQOd6RwKypPWbSVYhS7xPJLQ7NTTBRbnOo8B+EOkHRmkTE91cGFcH4MeDkrhOnNQ3bSNzihu4fQAxjyh6wKEikUKfcaJwvWRI47DPWdYLDQPqbLjuzS9CfL0w69uCaIkjhc8iOdfEX1oPCcJTKulV79oAp7UqFCzolmNpLiRk+NjLxoquZS2iZMrQmImcYsykkhxghyey8KJ6y73bTaCxtiYskln8i9Hdkra2kYAUxVQcMt9Y28tgJC1i24dofFufeqqxQ1iedMLbscnEroQPT7D6SfQkno60pkTduW7w6JN+UxthNLsBY7Y+yPI7FdyYQljOS3QeHqDMaFkWqkoJobzf/A1xw/KVaudcPhp12KB0jgwEJzleBb49/vuMexCc
 nqPpfKKP
 KsnfFiVe8hFJe43rP0sVFrHhqzJiSQkRoM7JYSy81IFU6HdGEW074zWpgtA2ayfPGswBoTMdelj35MhWU1oaVd9tW47igvHnENJ+OfPJvi68f7y0NqNSx0h838qzpLYZJ065dumMEf5FDSg4EB3V1Qc38rrG5hl9T1UuK2ubZ7ZlTG6AW8XZ2CNXZXMo8+7pJYrMEHsBT5EeEtVszrkPwevP1NlwKJg8OzN6rTEgOaR1qy+QF98UksopnVs2s1WJD//xplqhRmLfYyITqwhj9zz1Z1L8clJqIQ/SDZeloS4Cpy9t7cwUAu1WuTSHHVRlibHKEa6uoVtBL6ZnRPTvN5nUhkK4QENxAjX3xAwusaWP6s2ufnr62cEWwS5DXf3GGreoJGIVaYwJLkTvrhPeKs4nFfGqQE0TUtCNVx47tPIz4POk/M1HOUQbqyB9KqaEopAP7tHVvcswNlMiXmXlC8e7boAICXJoO2O5dd6+9VineJaUxEYiOXwutxaU+80NmQD/WK0Rn/0FBJiDFRTlZY7w/hjgbaZtDempVr8Qmm/zdn9+lHIlmaFolLM2SDYxmOcEuA6K8++SZqCZ20w2aI6gRL+nV9IvtK8VEUlGV6yjSBhpbr0IDlgiflbMBF+DzymnRDcr1IalD0w+Ds+OCB5bzlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Honestly, I hate this.

In particular, I intensely dislike that horrendous 'SIZE' parameter to
those helper macros, and this just needs to die.

The argument for that horror is also just silly:

On Fri, 21 Nov 2025 at 17:43, Kees Cook <kees@kernel.org> wrote:
>
> These each return the newly allocated pointer to the type (which may be
> NULL on failure). For cases where the total size of the allocation is
> needed, the kmalloc_obj_sz(), kmalloc_objs_sz(), and kmalloc_flex_sz()
> family of macros can be used. For example:
>
>         size = struct_size(ptr, flex_member, count);
>         ptr = kmalloc(size, gfp);
>
> becomes:
>
>         ptr = kmalloc_flex_sz(*ptr, flex_member, count, gfp, &size);

That thing is ACTIVELY WORSE than the code it replaces.

One of them makes sense and is legible toi a normal human.

The other does not.

The alleged advantage is apparently that you can do it on one line,
but when that one line is just horrible garbage, that is not an
advantyage at all.

And the impact of that crazy SIZE on the macro expansions makes the
whole thing entirely illegible.

I will not merge anything this broken.

The whole "limit to pre-defined size" argument is also just crazy,
because now the SIZE parameter suddenly gets a second meaning. EVEN
WORSE.

Finally, I think the parts of this that aren't wrong are too limited,
and do not go far enough.

Because once you give that "alloc_obj()" an actual type, it should
take the alignment of the type into account too.

I also think this part:

+       typeof(VAR) *__obj_ptr = NULL;                                  \
+       if (!WARN_ON_ONCE(!__can_set_flex_counter(__obj_ptr->FAM, __count)) && \

absolutely needs to die.  You just set __obj_ptr to NULL, and then you
use __obj_ptr->FAM. Now, it so happens that __can_set_flex_counter()
only cares about the *type*, but dammit, this kind of code sequence is
simply not acceptable, and it needs to make that *explicit* by using
sane syntax like perhaps just spelling that out, using VAR, not that
NULL value.

IOW. making it use something like "typeof(VAR.FAM)" might work. Not
that crazy garbage.

I never want to see this kind of horrendous patch again. Everything
about it just screamed "disgusting".

                        Linus

