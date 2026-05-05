Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DEB2CD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 07:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B84E6B008C; Tue,  5 May 2026 03:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8692D6B0092; Tue,  5 May 2026 03:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758226B0093; Tue,  5 May 2026 03:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 638636B008C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:47:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C729C403AD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:47:56 +0000 (UTC)
X-FDA: 84732587352.05.F6E7E91
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id C5CFD1C0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:47:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J3WUI6GP;
	spf=pass (imf21.hostedemail.com: domain of rosenp@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777967274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrEQHam8DGEcHyD+7jduqW+Fi+mFl53/8fjm+HcTlGY=;
	b=UcAKLHCbElGrUUcAoBaKLQ1Yzo78XwYDon5UnxK0de3biTCfJO/CAAk9b/7BPNV5r9lUm5
	SVqAFz+BGI1/5ridUolc5TlVdTYPJEjGkMfNBIEyz6P9LlWacfyFI3fnMiQiR68Ing9ZvB
	ut5JS/PRhw9hLru0LxPP6ffMrnfHKTU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J3WUI6GP;
	spf=pass (imf21.hostedemail.com: domain of rosenp@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777967274; a=rsa-sha256;
	cv=pass;
	b=3F+mG1mtW1S4sxLc+y3k2GBt/1ENMhWVAbBFbj1sVrykKNdgFUYxQYp3+3l+K9g4h8Q3J0
	5Y2ByPM2gg5tcNL7HHNqBkfgP5vIInqvFT60yN0trd/SUBVRgmA/LpCzXvw6YOqA+SiOVt
	+R99ttd1gFfNzY4z8+Z/tSkMV655FsI=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-67bc6098640so5078705a12.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 00:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777967273; cv=none;
        d=google.com; s=arc-20240605;
        b=beJjbrTJgNl82NkxQ3Bv91YhhvxWtb9r/QPGUrYDXPJxbsho5QzVN/JiEesGG1UxBg
         2M+ka9eu/2F19C+Wgl+hjBkZ7/ubFRuCN+Ffn5C5o5jB1UOAdfD/lxCu4XnEOoKqgxxU
         MsOuUBmBQYg7bpVSAzH8lVcNgZMl2vEGiVT4OwR7Cj4qItf9FuqiqHDSxF4MyRQYCmel
         VjvesBm4cKiXsbsXIYtaf8MqsSn2rhI/Mg/gb04pK0//8ftkYupgHqA7SYHdKDxXEjK1
         eNiOsmg+VPhDqUZQPsdoB1KkZS7AahrCHdxwuclk3egh1hM9mOE+W6Q7XgbY4qkvTaTD
         W7Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LrEQHam8DGEcHyD+7jduqW+Fi+mFl53/8fjm+HcTlGY=;
        fh=+7l5ZePh2uEOQeb0jUJlb70iGG82g54gV+LCEjmmdBU=;
        b=Bxh46D6zjt29GhMGHb2awC5nRZqZk60x5tkLMqweSemjvfscSS4vGF1L5+BDRC7OTl
         mM7fHqzjGIFB2hXQ3uAWrLDh827bfDbONbY0635JV7lHSb7AfdnDSOnrdKaEtVCUEX4z
         cIqCwdWp0hjHs+P26DJdEGzkspZ7ae6xgco/+iSVAzgA/ynu1MsRPTCVb0/nA02ndbT/
         /wtFC84jUhmP7abZClK6QtNkjEUw7Icj3KCc5naHudQ2J6qv5M66uafwzEuAsoGggYl1
         Eo9JFCtlEjwvdlq3eVzm13QbFKd0W04qE82dPud+2uKXql2KWWucE2Mq4n/vfb4ZoqWV
         BGvA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777967273; x=1778572073; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrEQHam8DGEcHyD+7jduqW+Fi+mFl53/8fjm+HcTlGY=;
        b=J3WUI6GPvk7jWron+VFnp/CCtBVzKkoYAjnrIUnSwwNYVAKwqOTp5hcTJ8hyPpldoX
         FwWWLlbP40rKbPWcrMts1o/HyliLeuiVN6npBn7AcqXD/0SSV2Mq7Xvwtw8LWKmYihRy
         HnrSCwGpr0skMODNA+y2OH+oq4CL+xrqR9/BPjjUDXG1VEjdETgRm8aH19C37g822NlW
         78zT94Sas4sc9HUqTpk/f1ctqChPMusXaDMeijCwmbzShzH+whnuBw7d1/kjixIJSAkP
         Z9xjlJ7KbPbsVhpRfY6yJi7BybjZF4WZE9bSOJmWnCmU9gh7OUMdNTaDcvPJMmpTVheO
         4rzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777967273; x=1778572073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LrEQHam8DGEcHyD+7jduqW+Fi+mFl53/8fjm+HcTlGY=;
        b=WNM3PMA5c/qTSnZUXAp82od43iKXUalyyXurJpjbkERF40OVdgUbZ14Jldl1QHg2tS
         +HsCDCzL2nCh0wnLg4/IAQcB3kGSaLX5b41KQXSTIs6ZFof2GbIpo/5pIwX93mAIK1fj
         8D7LWLAg5notmtX7vaIUyN7nZibWJDSjzJhkVWWMikAWwi6oE/S0U00JTikFmr9lvM0h
         lRUsHNElMIcSVgkok7lbX8e1vlQY4qfeXc9Uy03Vviz3tHs1mYgMyqSA3aDbS1pitJTF
         /IEt5YIw3G9iQTZGFGeCdYqXTouqxiG1NNs7oyFNiFtvp85Qzp3kXJVkyENfnzrCx5Ly
         vJbw==
X-Gm-Message-State: AOJu0YysHuo8XR+qo0X394xSRbjbq6XiF4gdg8QWJFJ/pSt/yCg4npti
	tof9Ru4kC4RVXF/xqD9j1n+eDorIUfUPjWhKEQibeah/X8KMZk0Cs3ahN6wox+YzRAJ2FQkokUg
	3IFNj4LdH0G97Wde3KqCzfVKP3ToFS6o=
X-Gm-Gg: AeBDietg/cLKYVrtheAqk3XYw1iUMH4648xXH6xaOY2Y2VznDntb3FiUBQp+XfHvXVO
	cp6kbEVFiKXZOxwvdof5Zi1BPRnSPM6wo4qTLRMcjCiS7CZ3ySRQKFMOXrSAOOh59qdwN/DP1CP
	n6QdZz3Z+hQcAW8LxzxVFcl7R0e2GofRLEc/WIEt+1Ft0GOdhO8/ZEdjpOMw7A/lJjco5OogO2Q
	SLmwFRV9CArxtSjfyjuVR/PO9eQ10M57SSHIJlWiC0gROVyGv6UWFA7q3azBq6msV2Iu2119IMv
	cC/z68KcQCtlsssmx1ejgeHaHumckny7ge42AkYeMZDsXjHrWZTsKDHK2Kf/dv+lWjN6nCsBGkm
	x8dhioHdnbj96c6TU6TQbPzUq1kn+UrWP5ddtKtt13JcFfUjdXg25FhFhtlh9uOWwfdDx4w/IJB
	dphNA=
X-Received: by 2002:a50:fc03:0:b0:66b:f527:c69d with SMTP id
 4fb4d7f45d1cf-67ccab1cc90mr656287a12.8.1777967273017; Tue, 05 May 2026
 00:47:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260505010112.645361-1-rosenp@gmail.com> <0f11390f-e8bd-4f8d-aea8-59ef545b2c32@app.fastmail.com>
In-Reply-To: <0f11390f-e8bd-4f8d-aea8-59ef545b2c32@app.fastmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 5 May 2026 00:47:41 -0700
X-Gm-Features: AVHnY4Ktv2gBjkmdWbGk1dG2dc4G9oZ10kiw93sWZlLBrxmklnYBHgXj4r1U3So
Message-ID: <CAKxU2N92s06-L0+e=KZ7EbtU50tCpaCk2MYJD2xTFEHEsAhXUg@mail.gmail.com>
Subject: Re: [PATCH] mm: move phys_mem_access_prot_allowed to header
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:CLANG/LLVM BUILD SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C5CFD1C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: 6u7sf3ifwjmmy7wpgwq8rmuo8cdkke49
X-HE-Tag: 1777967274-978337
X-HE-Meta: U2FsdGVkX1/IcWNXMgM/xIdg3VN6suKaJBzja+T8b215R1zJQ3aq09qJZLcz9InYZBkvjS16+G+JBJEjKqdYpvc+cvvDaAAjBl5y7/8wrnIXVTrEWQwNjPz5VwIYYvn5rxNsNDeuIEBzRNfLuASaMGzTug2IHNGf0M6L4Vt774ZVg7EEm5kfwC2VApu5zH59WYTsrgtok6iFMeATR2F7eEiKY1eK2GfXzS7dvFdbhuWT5fILfGP9L6TDWW8FmLwehuieg26JoXdZzxZgMd0bSnKzZF6Vz1EYw2HeFaJZ1zCZj3cQEhmITxIWfJ3UMrNhWlzi//XsaLcy6p9hs/+PcYc5uOPuTsufhE89v9J3fE7WpkL3Wdtkj5fsH24rUo0XCR6msHnyVkz4MkcsIECR8o3sQDIFbWIvihUU0MP3V6bOOHZDwZZ7YYlq3llDvZklinKTYc3W4Y9gax1EChbX6fSZnKSQN0FVWr9kEiJoobrRcn4Q6fuxTb7DAc0Sjsr4MP8ubO23OYcCeNjjsPoVx2DWZnsw0+rNDcsY8RRMDH+tPH7p13JJaX8GsYMTTkbuDRORl7k9+Q9zhdfbDR0YxTUkJ0XaRz2prFtRZTi+GJGQVlb8lWakRnvrdiqLko9cItTR6dF9Wen3WfG1sg/E/KW41tNI7Y0uilhXf9rYDKlZbL2OsDiglefN3JY6x6R/lyP0uBhfVo/uyWuZiCoon2Tl7Lb6MARe+sTrXdIrdwxpapZ8ExLk5aiVy5HHrKBvxkbLwDH7pmoNWw0YKijQTjmU735UBTFUc5pVMK2JBJJ+SY7hCiE0gfW0xgcsKUcB0ILvGvncA5Kwm0O5Ktd8k9065BfnNeb8Iv3hierw9Segtgzu/hUgmgdvs6M2U7qCuybpnZJAixOpMAgwZ5GFTmsoMU9ibs4fv2sDxqUdmcUWhlG/fBe+jVHx+KWITsf+fUnMZD9Svg2M9w6k+Ni
 rXEJKjJJ
 wvTTWScw+5u8iA8aiR4nOL4bTW8wf5i/S26QtZpEOspreI3gTA2Uy3ylJ+CjfrFvBceE0NIvtaENvv0BFNFXbhASvZsZ5emaQXG1zTN1xzM4rGt4P/n4mUY1dyfV0pxaZbwWekXRL6LBvelUfokVNWn3Ih7aPme5OP3nXKBUggfLIVAlYhK95iLO8hNlgoDGHrH7+2PM1J8tiDuLxQS4z+PWeLTGUlkRd1hyp0fXKvFPMoyVHaKj+kYMRRNhXsiICMG2BRQcnmGc5Pleccblc4Ty5XhwkALVYuEVxiPLgDE+7JMWkGjakqCdFEXi5cuCWudsp+Ybwmj9jrzVBElBfzWXrIbaaGFoVn0OBSkYaTmaJ3ne6mlSVRyWquGJXMzGFdehHmIJWFLBlNfaXFPcrXQBX38u9KpnRBLZTm3yXDR0n1TzAO44tgh+noRBS+LDjwSNbrIYDOzmePMRISgeiYTZ5ppplIyw5gTL39Vi3jPAHdQvvZI+a0TzTebiDvwdbqm8evI/Vryur/P6LMcRFH64T9ji8x26f4Cq3z6EW4NpDJ+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 10:54=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Tue, May 5, 2026, at 03:01, Rosen Penev wrote:
> > phys_mem_access_prot_allowed is only implemented for X86. For others, i=
t
> > returns 1. Move it to header to avoid using __weak.
> >
> > Fixes compilation with make LLVM=3D1 ARCH=3Dmips
>
> Can you describe what exactly goes wrong here on mips?
Cannot find symbol for section 4: .text.phys_mem_access_prot_allowed.
drivers/char/mem.o: failed

It's full of similar errors in drivers/pci/ as well. clang on MIPS
doesn't seem to like __weak.
>
> > @@ -239,12 +239,6 @@ static ssize_t write_mem(struct file *file, const
> > char __user *buf,
> >       return written;
> >  }
> >
> > -int __weak phys_mem_access_prot_allowed(struct file *file,
> > -     unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
> > -{
> > -     return 1;
> > -}
> > -
>
> Removing __weak functions is usually an improvement, but I think
> we can go further here, see the discussion from last year at
>
> https://lore.kernel.org/all/20250520152030.1499670-1-arnd@kernel.org/#t
I hold no opinion on that.
>
>      Arnd

