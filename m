Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EB3606A334
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RUzFwGJ+
Received: by kanga.kvack.org (Postfix)
	id 573F06B05B6; Fri,  6 Nov 2026 08:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A806B05B7; Fri,  6 Nov 2026 08:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451F76B05B8; Fri,  6 Nov 2026 08:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 180206B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:52:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 976151A0DF0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:52:52 +0000 (UTC)
X-FDA: 85404834984.14.A310F6B
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC55F40006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:52:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RUzFwGJ+;
	spf=pass (imf11.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973170;
	b=KK23VibSsVXWU2nCTNTZ1Fqrze0XnQjbCZbRDt+Cw8kANtA0/xeqK+MMmDfHpy3IG5lfoY
	Zv1LP6fRega4d/spAQpzanf9JvD3j7ZJywd5NmTyM71a8AC+dIk7Ob9Ejp0b7y3JoZG0qC
	cy2CU9bbFy6hLwWJKGsTzKyPVYArmG0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RUzFwGJ+;
	spf=pass (imf11.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcC4IPdf1ihtWsu+EfJlFBQAiBAyUnEQfCqCotWg6Gc=;
	b=2Bu6OmmlKjAEVCJvBfESi5YAaiuV9YtpjvCEcjf8M9SPmdA8LH1/8Tri0EZ6YaTeyjD5ph
	mUaP2UPyC4dn55RtF6fEbJrZrsLQdgi1Ki1rxbWHnlUZ+sm0hS1DQGJXejgaH+VTxZg84W
	q/tOipFVKgnWzOkRIvRwpjQAKx8YzsA=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-492f6b7f70dso388096f8f.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 05:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793973169; x=1794577969; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PcC4IPdf1ihtWsu+EfJlFBQAiBAyUnEQfCqCotWg6Gc=;
        b=RUzFwGJ+m/3C7RfheWbYuhNecjmGKW1Orx7SIjxW0T2H0OhMijc++cG5vl85lpXDUs
         UEuvIrGFtpbVKrf53adG8H4Ai3MzD+vlpfTXTtWnwqUuyGcN83hFSLi78eNmIUBc8Dp0
         Q/oPOgbNP5JSPKxKlqmuHSnlIMC4BNxFxreku6z70IpXS7dboU5sgP5JpFhIlRlyyQ1P
         N4rP0w3TMbF50mGlFAkPv/xeNaZPH/rbNGZY8GmROsLXGVhH6ZymSEPgjAuHJemP7aNe
         ksQ0gAWOvAWn1wJ3L+eGoAW8CYB26XbnpIs7z8eWJjVuDJhITUVtd2jtWlUNzsBFVGTS
         DLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793973169; x=1794577969;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PcC4IPdf1ihtWsu+EfJlFBQAiBAyUnEQfCqCotWg6Gc=;
        b=whAuMN9NnPcrKsnhQjVC7ylzhhBlj0A8otid4bm/cLKoVUgfVQgaLh2uyglX//H8t9
         b/mYclqiGhT3uW8q6n6vjpmFawc/bdYTPZn4J0CCvb3IroWLUBsVzgrcGwKQ7dqJvbH3
         apJvdmTdlAw8JrOA6hFWhBHrVa7RHy0ZQNp5eDXpug9QRWdggZ9OYdAZOFlaRYTj2oKh
         fiHUM25YRhZWmBliKNuQxI1VUS8ezZ6UbkXQ1+NukDMhRoXLnvcyx8B0PIpL1JdhTPHm
         qpzkHzW+cA3a8XESDEMSh2mE1bIPe+L5PS/uhg+D0e3XouyfHF9Y6C80WOClf2XoJ5KD
         P7Bg==
X-Forwarded-Encrypted: i=1; AL+hErH1xLAhH8Dc7Z1o9dX+RWJaQ5GAp0PnXcLbWFRfzugQcPfFUBC9MnSjtdRsKhLNQIU7x924U3BBbQ==@kvack.org
X-Gm-Message-State: APuU4Z/HSLXSe9zELxqnrnxWN4Blo2Yi7VPtUEzyxvwqh91QcL62R0ic
	2YVKl6FqMpwI3wSH/1erN9+RKns+7IBqoDVbioh7YeQ+S0aeGGRoHeJi
X-Gm-Gg: AYBFou1nzs1Xvk/1eVEFB4BpYvQc8dzhvrc+q+GqKjbKpMT6UyaXPulsMC+QQ/yw6ae
	t7QJ4b0jLuCjOCuxNMGDKi3xOXwWJDzDDsyBJ/2kaVbCsmDoZlcChjimKvM4T5+9Im6boaqe82P
	LYrzq8UxBfv+BSJuig4iS4NxBS7/X4BhVcxMrtUf50yrN5GKSoUBdqHY0u/IdqZIzzvvo3busp0
	NqHm1wfVmSi0Uyh09A6LzP7lcxLcmLUB5OU3kvSCULLdCF4K0j3Ch8LpGqVnb5Nw5IlLGdvojNq
	MSNnrIUSr0kdkXZP9GNYNtCZR2v31wyD/1Hz3b/01teeYDJqzzzqJGiJdvEwn2Dw8IWmo4i3MD+
	IiVPRJ6tLmjqQVuMhJTjoW0FbT9UdZAUfcpNZRffPNfGxI4DsXarz3IzVGApa+luo/g+sPdmjcc
	ZmlGYKqb4h2NfNSL6fFyc55bbwPIu1t/2fK8pVW9UvjZdrnpy7JCdLJ+WRfv13mJ0lBdnDoBmRB
	iFluvTtX+JX8TkjQbiu89F1kSM/Wtjogct1O3J77lcO65uZFoNTHNVbkB6z3XGqUZueA5coxPnF
	ucnLNk6rIs8rXGc=
X-Received: by 2002:a5d:5c84:0:b0:48c:7386:af18 with SMTP id ffacd0b85a97d-4927b092b8bmr5141147f8f.8.1793973168740;
        Fri, 06 Nov 2026 05:52:48 -0800 (PST)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d7701bfasm3877363f8f.40.2026.11.06.05.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:52:48 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 6 Nov 2026 14:52:46 +0100
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: Re: [PATCHv3 bpf-next 1/8] bpf: Honor const on generic kfunc memory
 arguments
Message-ID: <au3brpNZG2nANnha@krava>
References: <20261105102343.311331-1-jolsa@kernel.org>
 <20261105102343.311331-2-jolsa@kernel.org>
 <CAEf4BzbdBLb1cBeF0an386k=CmMYKdz=Or5mSjzy_F5SFOwsxg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbdBLb1cBeF0an386k=CmMYKdz=Or5mSjzy_F5SFOwsxg@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BC55F40006
X-Stat-Signature: waci4kuz3o8m4esf56fjewji9bg7oji5
X-Rspam-User: 
X-HE-Tag: 1793973170-404169
X-HE-Meta: U2FsdGVkX18FTsZ5q2OkRScIrYnc+PkxFkba8NNNKyP/Xm2h9qUvSJNNUJJYoqtgePQF+XpqYlQsr01g8epe+hBsFij9iXauGBfFrowm29hffQ58lmq7TtCLhk8/OnKGnu9MLu56WbnD5hHQs9whoGG/hy33RGXTbbMLtp2vGZNgXwdUCH7pc4rN7zH0szAlloGRahpPQwK135f3vpPRJ+yck5P/XYCTbalDqZPIE0eySK8TODoxndH7cg2HU2/VtWbiHSkv89jXSAihfvvNiMGoSGrYBW85DSpa7qZ9t2NHkMiuw2iXbxd8Vhd6CjmAy7v8ktJBWw6Vg3qMn69vvwk3JZ0T6LU75E7Ka+HmCCJTR9ZLZrjcd+iq+rmZBUNirxylzicTG/StVgixaOSDjhK2dMKMygd8JsX9U4FdWnAZyfFLaw/L6zylAts/HWnS8r/ja6PwuNVwCPUiLVWPbH+9kSOQbt/B9yQE1jud11zlNF+C25Ml7QnT2q43oJpCmHpjP4Zzuh65Y7cBEGw0+5z1oAZplEeiFvu15m3gvA6lK8kpjeBmXWVtMKF9+US3QD63wu21+5lhSjZNfj+sXFYWZxLsHwFG5AYGeiSf3aOzMADo8FWAi7MFIqyuzvxCZ27tsPuAxIVsujN5/VUCAzO/X/JjquqpFMYOzgDJtApsDnCiMZDn0/XhhWbWBbHvKDYshzE7T8xSGF+Ar7iKydpDi0PTrs91ZZykukDctjuRK//jj8uuvuNNSV+TZuih4Xqh3PMtQ90wVkpWBge8Nj+PMMNCT6b3ouoRA2ambtJ+daWqf5V5dEIst3eEEBWranGVny/DAR0jLRIA35C8/9/lN5pkOBOSNV67u0YaNVCPnbtq2Kge5v6FptqwInzCnj54pLqKFjC6foth2mW5L5pU8Kj2FAnBCsyeOxdmZvm1R0FZnp1rV1OHYY9w47JzIbIXt5BJON5LqG/D7XY
 h9I+bpVr
 a4+K30c0DRyMJRdbZUiv1HHRArhZu2jJdee/gdOIxFr6DDoiaMJG9IyaPh1tQ5gwjSYpeaT6Ry2x+4qE6oD3Ux//a6cPRHhzxfoguopZZ2s2A+GHxz1yc+7ju05V/a8jpca9wSvlVBrQjV3Iqkc2PPM0n1JBsQR9n4fdAHM/COQ2O6rGoSYUjgkZisNqPMvA4wBg+YT5UatnIjRSvLnKvzMgg1g0Lie4tY53f00gPttdDPyTJUn8wbyWb9U1Vfp8RvEcuecZkPfAMi6tZ9wfAZS2Av0MHulcDGjRvLYYZLCmCaPzj0/6K2QbrYVhIzTEcNY9eohjoYUAwQe582d86lVeaL0H3HUztqipL7PC4lQjkIdj5qhLsSHJ26t1YDZBEMQwlZjWXqgPSEIJ6LG98q4FfN0lNrIE+KKoA1eCtbQETNkxV+fyYg85jhvvt66kGgWqHr1j/8aVy+wHmYrMF8CZbadO08luqY4pdlP4er/p0Mqm7xR0yzq0WuzHsRWo6Tm1Fp6HV/98ep5AOGKP3zP4mChGM5S7hRWR1YY7OYUy3PoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 04:34:44PM -0800, Andrii Nakryiko wrote:

SNIP

> > +/* A kfunc only reads through 'const T *arg'. The compiler enforces it. */
> > +static enum bpf_type_flag kfunc_arg_mem_flag(const struct btf *btf,
> > +                                            const struct btf_param *arg)
> > +{
> > +       const struct btf_type *t = btf_type_skip_modifiers(btf, arg->type, NULL);
> > +       u32 id, ref_id;
> > +
> > +       btf_type_skip_modifiers(btf, t->type, &ref_id);
> > +       for (id = t->type; id != ref_id; id = t->type) {
> > +               t = btf_type_by_id(btf, id);
> > +               if (btf_kind(t) == BTF_KIND_CONST)
> > +                       return MEM_RDONLY;
> > +       }
> 
> quite weird implementation, skip modifier, and then re-walk
> modifiers... while not have a loop from t->type while
> btf_type_is_modifier() and if you find btf_kind(t) == BTF_KIND_CONST
> -> return true?

the intention was not to introduce another helper with modifier
classification, the tradeoff is 2 loops [1]

jirka


[1] https://lore.kernel.org/bpf/DMLRV3E28SC8.3FJZXLBLZI4DD@gmail.com/

> 
> 
> > +       return MEM_WRITE;
> > +}
> > +
> >  static bool is_kfunc_arg_constant(const struct btf *btf, const struct btf_param *arg)
> >  {
> >         return btf_param_match_suffix(btf, arg, "__k");
> > @@ -13618,7 +13634,8 @@ static int resolve_func_arg_type(struct bpf_verifier_env *env,
> >                         PTR_ERR(resolve_ret));
> >                 return -EINVAL;
> >         }
> > -       *arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
> > +       *arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
> > +                   kfunc_arg_mem_flag(meta->btf, &args[arg]) |
> >                     (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
> >
> >         return 0;
> > @@ -14170,7 +14187,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
> >                                 reg_arg_name(env, argno), btf_type_str(ref_t), ref_tname);
> >                         return -EINVAL;
> >                 }
> > -               arg_type = ARG_PTR_TO_MEM | MEM_WRITE;
> > +               arg_type = ARG_PTR_TO_MEM | kfunc_arg_mem_flag(meta->btf, &args[arg]);
> >         } else if (btf_type_is_struct(ref_t))
> >                 /* A pointer to a struct without a size argument is classified as ARG_PTR_TO_BTF_ID */
> >                 arg_type = ARG_PTR_TO_BTF_ID;
> > @@ -14195,7 +14212,8 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
> >                         return -EINVAL;
> >                 }
> >                 proto->arg_size[arg] = type_size;
> > -               arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
> > +               arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
> > +                          kfunc_arg_mem_flag(meta->btf, &args[arg]);
> >         }
> >
> >         if (is_kfunc_arg_uninit(meta->btf, &args[arg]))
> > --
> > 2.43.0
> >

