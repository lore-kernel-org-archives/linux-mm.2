Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE87606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V5Ru+o+2
Received: by kanga.kvack.org (Postfix)
	id A06776B05B5; Fri,  6 Nov 2026 08:52:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE586B05B6; Fri,  6 Nov 2026 08:52:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0ED6B05B7; Fri,  6 Nov 2026 08:52:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 668846B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:52:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4BA3160D7B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:52:24 +0000 (UTC)
X-FDA: 85404833808.30.B6D6A3B
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 150C320006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:52:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V5Ru+o+2;
	spf=pass (imf13.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973143;
	b=yUwP3hP2TD8VBlg4uvMMrEEpclqRV/xDXMvAja5eV3WikWEl0t5C2QZRbFTHB+0ZaNJ4QZ
	LLivQSfDPc7JT/A9RibIi984LtHddLBdNMEUSVVMEp4b97jmokQ+kdgaHkFOL0HzPobvW/
	nNKig/CDHqDwq8/spqOgn12xaJIaa00=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V5Ru+o+2;
	spf=pass (imf13.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7qkgX7ESuYJEi65BD2oZdm27r2FwJ6aXncoGqVoKbE=;
	b=k/OwOlog6ScDuOo6ivlQQTKuOUePEnS9S3ko6AVK5X8vzzrkTMwTdbZRZQxQK4ZuzldniG
	Lf8w5BVNrKlDdIKyrHBJdWgUJEuziCiWbOyr2Nj+PiWVYQGXn1jlWHXItyUGnhnNHYkx8N
	ixiGxsaV0liYHVuqKGunppCa8D7GWCs=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so4361785e9.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 05:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793973141; x=1794577941; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f7qkgX7ESuYJEi65BD2oZdm27r2FwJ6aXncoGqVoKbE=;
        b=V5Ru+o+2dE+qwVJM2QxYeARR2sWSHaYWvLJFvv4u0NDw5qUg/4gECJ4JS3bFXui2XV
         PIYBS7a1KT5kQX+SO6lIjtVKF/hkgkadfdUKDMWF5w1SrmyAabOtc6Sx4u0ZtAbbMk7C
         yRRzm3IgYOHtoqqZHymJp8kho2g9gAkoUC3z/nhwxf+ECPWujVzBZ2QrheeLZUJX7CJX
         okAUIvRe5JmLjun17JXSaWyACygQ2jPgiisdxs90CQHcveoEjBmfZBhEkTWtCSPGdhsm
         JQq5uUoe9ZYcVlSesMBZ7p+CM01n6dYG7sWLNXLK25q5KtPxSEsn83ZZFgNzadPqpvJe
         40tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793973141; x=1794577941;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f7qkgX7ESuYJEi65BD2oZdm27r2FwJ6aXncoGqVoKbE=;
        b=G362rnT+cneLCh6tgNY35c3rqwjKordWRiM2zT2meXovSQMyDmSNeofNleHyvGr0uc
         3ib7J8xcWC5WijoVH5H82yO+IIMjCwaX2NMHyYV6WYKeNTLeKBpD0PmXoUHxCpY63qpT
         xg5H8TUqmdO/6VvRtWTJHYbaRrP0qjLS82sLrwVdXCYs1ijOUtEGKjXBNPpNeik2wlHh
         4AGFuhcU23loDxa4yUtX1NwRY+8f7jc10pyiWS5G/T7+yegKjTcUfyU/vwPbJ3sacdfa
         XrO/MiESNAvhr0BODyXQlRzQ+VZX2btSQuOHyT9TSZjscZKj1u+uO7k7P2IM9kvuzcWz
         xvoA==
X-Forwarded-Encrypted: i=1; AKwUvByARHMZQotVePuHk14g2ujKRZ9r8DizHo5nqy/ZjD2/PKZ0YQb3xZo1wDxZ0VHd43y19YYA9jcC1g==@kvack.org
X-Gm-Message-State: APuU4Z9hrXBv9V3TuynZIWzEio2jhwOmVpK7u+OAXhEzHxE9ANkkpQch
	tPAmHdw5vFV0DbeWoJRLSj2JfQB1DRnmmx0NH1h2Y9BnH6hcYn2vIu5E
X-Gm-Gg: AYBFou3dP4hk/ODyz546kx9wBya1CN1N9LzAH9rUD9/gq77kG5Cccy1a3Az4ecMulGp
	ysH1PImXiD/FRhFho7y0jy7MOD1+WPPy/yfqwd0p3gKh/O5TfHgo3kV8n/Mo5KqeNSJhS7sg8Yf
	s1mHbxhsRCsfEl8NM7G1UnRZv45o5lr2sfpM4xNqFHdj3HNXIVTESKf2CMvmuiZav/TZ8WZOvjE
	rkS+GsFELPYNpEIJYl/x5nmyuAAAcTq5CGM3qSgNZpUG1czi/IyPpJjp0xrU+W1F1PTEMgfvcdP
	s+Zjql8BypAMrhNcJTIHLhW4IBZuXghFo0zfgWeoYxGy3WC04yLn7tMlShVrqLO9HmGIF4PssOp
	G3U8eMXZ8//kA3yj+wZ1WX1Ed9PFHnCipoH3x2fVPvbHpRqcXJfqMpDGeUBzQ3q4yLWQ0o2iCMV
	GL46FW+PNshDhaphk8YFzMQnLna08ICtmN59aukGxnmTKxpuQ4rAN+MNZ5yyc8oeqmjVSIjX/dH
	NXbsymnnI6mhOMHczhPRIky8IZ8GDu/tHcROW32gHbDN06kJWQ7moxJrNjcUvUDDF3ldNNoS2Y3
	/pSzmfyzd2TUh6A=
X-Received: by 2002:a05:600c:811b:b0:49d:1fa8:b266 with SMTP id 5b1f17b1804b1-4b6deb5fe17mr43147355e9.26.1793973141312;
        Fri, 06 Nov 2026 05:52:21 -0800 (PST)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b6e24012c3sm56107585e9.13.2026.11.06.05.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:52:20 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 6 Nov 2026 14:52:18 +0100
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: Re: [PATCHv3 bpf-next 2/8] bpf: Add user memory kfuncs
Message-ID: <au3bkmPTBnpVU-9m@krava>
References: <20261105102343.311331-1-jolsa@kernel.org>
 <20261105102343.311331-3-jolsa@kernel.org>
 <CAEf4BzY+1a8v8AHcr1AfUBR24uMitU7gEe2_1Npwp-8_kagU3w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY+1a8v8AHcr1AfUBR24uMitU7gEe2_1Npwp-8_kagU3w@mail.gmail.com>
X-Stat-Signature: 9wmn3drxtpb6pziatzjmpkwierqyoqne
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 150C320006
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793973142-442115
X-HE-Meta: U2FsdGVkX18Gtqm9Gs9KKS3H3wPih9MFeDdgSCEp5WvGVrmZoID+7SiWOLncJCEyrZ+GvTwvcnDSY58wDluffY71Z5yv/IfhEhw8CLkwQt++XWuHoq+4xU/hNw8q3cWKSWG9kPd/LwD0n3FoPjLZ/phj487oUPowEH0OvEMjbLDgAIpsSUybTbhC08NWleWXm/It9ekwbUHEH0nQgsXUBC/BrlxJkhgNnIjTp1szTB7mqUsg3JXeIGR/yM+HVdPMzWhJshc1OfJbXZzZ2L4BivLieLZ7AWwLbuZCx3ZaEraTsVqb1Tz2O6TJ4awgR/bB9UyHBcO8tsj4aWWuzVICt4r+9cI+Xl2I0+zUp2PRGgB9l+imqRdRAFKsk+uv8F/9MzD5xzk2WykC224qKLOoY5czTmScbmiAKWOim5Mhks6dSkCk47VryYbAPwwEC/Ruf8JSfL8br2d7R1D66pfCciobeNRG2jdMxxIhpkdBzU8R9tmAdIGHGTYFhR+gKNsXBLQ6I0LYI/0fuRiBkDnyasJdBfgKJIYVidWvZ5jS05/fls6jj29ryS3KgsfPtJ1Cu/ay6KI+oO+/iOQB2iE+VrLfzaHG4d1yHGaHD0hz5I8JFxXr+JHWVBACjmlzkxt/2I10iwimHBZ0gExAAygNo1IqPOggcjA7m47Ftudon0XiBkD9uKQe41Rt8aG2jvvSboRcNL1DPsa0u/cA5rL698Ho/tnm9Lv9mRiDYj/3s/4Gi5TAY1NG+aX5A/Jnp0C2qOR/oaaBv/n6Qbvte2iMo5Ge+t0j9+ZwUB+mgcj607jeOo4cJro5FpbulwTmXA57edky66vgogO6kB8FJGJzC1U0NIIlOWvkSWf2Byl8jO6q55e1YFKr7cAK3Tf4ZyilDBldwtCiEudRUkWshly4zLpats8wFEN07o0qwC4G+yp7wWdhgv+Mi6qAeiaS+NTkseRTBBVFOoDEX22/Ukf
 ZtVdLvL8
 tx3oQT3jp3siBD3eP1G2VOJJfuzWDQG5evSZnNnQfTD7AlhYaBuuFkTI6rrpZRFVk3RrQgGadQeAVQ5OS+5b4v1ZjlMdALh8jiV4ZSMMIGF889UBI4VZ9+Ty7PlmA/po33O+G4flQ5s1a2d7uNnaJXOtjWL6uVOFU8D3sWoiPQETkXQi3lCR9Pg8A2Rrd/NlWxuaB3HFVib/ga/TY4BojH0YhcPO1HHLNGzG6fbksysqtvdDds+Ump9NkCp6RgWi7x//e07wubvxSBR0Cbut5udLqOVfo7QRwwZRU+leLt57MUcbhT9OG8EHo01p3N2f9mxmIk4NyFQKdwXO7BBTIvbXJ3hUbsM6Du49Qpx/ASFdYH9bwRAvtfoxr07OjPxC+Ia6gs467lxHGR69ssS8o8l0EVMSZamFG0Af5dEmEMTmr4qkXEWHOUmtK4ISVULsQFwCk+ZnD2XSpVQrXXMEffjoSI4SriQqT+CyhuyiouU5GlFp+npd3HHtOqPpjAlUxo/xp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 04:34:40PM -0800, Andrii Nakryiko wrote:

SNIP

> > +/**
> > + * bpf_copy_to_user() - Copy data to the current task's address space
> > + * @unsafe_ptr__ign: Destination address in the current task's address space
> > + * @src:     Source address, in kernel space
> > + * @src__sz: Number of bytes to copy
> > + * @flags:   Reserved for future use; must be zero
> > + *
> > + * Faults in the destination and writes the way ptrace(PTRACE_POKETEXT) does:
> > + * a private mapping doesn't have to be writable. A partial copy is not undone,
> > + * the bytes before the fault stay written.
> > + *
> > + * The caller must coordinate with other threads so they do not execute the
> > + * destination range while it is being modified, and ensure execution begins
> > + * only after the copy completes.
> > + *
> > + * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if the copy
> > + * fails or is partial.
> > + */
> > +__bpf_kfunc int bpf_copy_to_user(void __user *unsafe_ptr__ign, const void *src,
> > +                                u32 src__sz, u64 flags)
> 
> you'll eventually want bpf_copy_to_user_dynptr (we already have
> bpf_copy_from_user_dynptr), so might as well add it from the get go?

ok, might be useful will check.. will send as follow up

thanks,
jirka


> 
> > +{
> > +       int ret;
> > +
> > +       if (unlikely(flags))
> > +               return -EINVAL;
> > +       if (unlikely(src__sz > S32_MAX))
> > +               return -EINVAL;
> > +       if (unlikely(!src__sz))
> > +               return 0;
> > +       ret = access_process_vm(current, (unsigned long)unsafe_ptr__ign, (void *)src,
> > +                               src__sz, FOLL_FORCE | FOLL_WRITE);
> > +       return ret == src__sz ? 0 : -EFAULT;
> > +}
> > +
> 
> [...]

