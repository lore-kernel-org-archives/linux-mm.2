Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D18606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 04:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Nvp8og8D
Received: by kanga.kvack.org (Postfix)
	id E63B36B00EF; Sat, 21 Nov 2026 23:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3B726B05B0; Sat, 21 Nov 2026 23:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51826B05B1; Sat, 21 Nov 2026 23:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB566B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 23:48:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 130E6A824E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:48:30 +0000 (UTC)
X-FDA: 85461523980.08.3107B40
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1AADFA0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:48:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Nvp8og8D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795322908;
	b=filYhXx/fqmwzz207fsAWOryksPQvrMeNmRkxY9GDmL4gINSLgh7thLlWer9lct30t8FOx
	WkAhtiTmhop5tq8cSaPguVJOJYJ332Ti6HUlS6iSTc2snJAu8V9hnRRiF1ae47fLIDfF1t
	rTlihLPkC6ZtHoIBswG5u0HcbhS9c7g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795322908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aivprEjWWyuTPpWR091yh3Xxco3ejGQmEcsBHTiq2so=;
	b=ObCjZ/AC/fpqKak4j6PtR9pLbL8elpTVIt9LJ29UyMvMa2ZOPGdr4BB0rvaQ+dWG2hW8NG
	RP8EYhK/5dheKNHp0TjnbUwG6F1loAIg+R8a2BnsSjK98DM8Iv6kQE74qgpsVJjIWrRsEN
	T8f5cH8sTDW+gAw2UBtYlZdYUch7VUE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Nvp8og8D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55be673e029so155741cf.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:48:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795322907; cv=none;
        d=google.com; s=arc-20260327;
        b=CUADozbnRhSO3REn+DGz1iYbEB5EwyzscScGQvJ5yPGBpkKm6FG6fxov3Oa+qFdhRi
         T9n/IV4KNVZiVIPg7TUzJDNdWoWWi9G9iYsp4v3CgZJ0/t3gWfTi5gZoArEZGt7bBPSK
         R1GOEUPJKYX1ZSaoFdoNF4sBCFRD6OlYTTB4PkDG71OP8zqMRbVO4pq1G2QK4/Xer7SB
         /uneJtR5TWW+flmy/y5848mrd9KMbbDr1/rfGrS/kFmea4y9zvZV96EQmH6XUoN5Owz9
         mQq7MpyiGnFtOXTgwkBBxv3/w6fuyyFQqfkCkZg02xQaHn82GFMSziGt0oQOvkHBY6cI
         mr5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aivprEjWWyuTPpWR091yh3Xxco3ejGQmEcsBHTiq2so=;
        fh=nizHHtW14QMZym8UzNBzH9cIw5b+wlUf/p5i2tYYCec=;
        b=D8pB85Lbt/EKIWZOSjIkLqqVk4dxDm5cvaG8LqUruQ3XqSOLc86ElGDF/1eR8ZH+kj
         dBx6zKkTAr07h+hZCzXZVMC7CrUUY8ql16k400UT14dpluRhX+UTYyonOysCETgfBLbQ
         IzjFciT97aJNo6RPERPNd8VlTHEh87ELvMNVnKs2GJLcsxA50D6JZkULyarQQN01mr6w
         xAt+rolKg9hqMotY5daTD3mQgdb0+dhreFp5dmmUXcePP+N4cFWuRcz2Z6g5wcBTJUZB
         fpmWSULxmCeM7P41b/6616YMq65lyliUvDwJqWQtTVPCL+4VovrtY1E5SLP1LDma1TZo
         eDtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795322907; x=1795927707; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aivprEjWWyuTPpWR091yh3Xxco3ejGQmEcsBHTiq2so=;
        b=Nvp8og8D4e64Szryi1pYejFz19pQSEt/71p2PFOwk7OvnOgCc8HL1/Id5+vueoIVEw
         w2Z9MuHq3QMzXyrm5tOSguKR3EiQiJ+kai0QgylV3fsFvX3pfSADMHavdeX49FVMWbV4
         /Pe5d+ovOoa3/fq1b4H1KWawt6GgYedCInit2nDTH/kTe6DK9Ka5UWG9fwjOjk3L1HNY
         KSr/P182Y80WcihKC2ibvumSfiDz8K0uK5aqonD/fbkD1bqp4PgyKyoUXUb+UGlso70F
         j8nmCmwITZ+EmR2LzcoZOpMU4L7ZJACQSBkxWp9SBn44FtAn7+sX2qNrgIC51s8jRBJW
         /+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795322907; x=1795927707;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aivprEjWWyuTPpWR091yh3Xxco3ejGQmEcsBHTiq2so=;
        b=2lsVBpai3kFJwWaCa+jAtKb7w9jIgZtfJ2FsMsMCOruIDfXZb3AJXMQOvJBc/2b7gq
         59Rt0qScfIn2WGKPGpLEU1HgkaiMYL9SkgAdJSz/w+U8c4LQOalwFAy3CSxn2kWegH9S
         kmZzXI2AhILzL5H+k6Uz4mbkOoR49enFLmv5A5JLuqlaJn1QbHhMzvJZeYPdCVuZd7TK
         C/vyOzrOLn9CltTRj9gEMTiMMvdk9QblUZK+FfaCRQXpwsvv7qK/lUYGMCc6NXlbsg6O
         WUqThgEXlShiQHc866AxGUXALXyWv+vhv2NM+ve1wo4zcrxuUf03BH6E2T1fsoY/CPsp
         dIVw==
X-Forwarded-Encrypted: i=1; AL+hErE+rltPIW5sPn0NPtv9rE8zn+js6cOJlIm+f3k56ffMbp0htCQgjz3hbFlMHAAMXx6xTPcvn/bbRg==@kvack.org
X-Gm-Message-State: APuU4Z+yV0jlKlBNJQ3/kPRsmVIbH2VczsIjLPgBa+xCx8eMjlCvhur3
	tJ4omqfW34f6ehqvTvlIGlAJoJOnw1NyQYb0JFmjf8S4Mo0l8WEovCRaTeQpfQhK1M6LybhX8F1
	eGCUjeEOPirL3WlaQ/jt6unPDTcX9yLgdkUy13rAb/Fq45DJgx5EUVvtN
X-Gm-Gg: AZFdTZfc1axYYN4dCNoMAbDhgSvtyIqBPOmhGK9IHIvCbIuoP9lRGdz6NN9XrwZUqXr
	AmQ0DGtXwyk/VxbtQWSJbwMtrdgcGFmo+2MkXyoTn3UBnU22A7kPkuqfwytP99TLBi9krfwgHF3
	5dG6dMRDx0eVD0kGUfsLSSm9ToBZin0z1cUJWmT9phzJ3b2xZDXplxoJ3NRDK+aow8VqoM6L9ff
	EpKlie4xOv+L4wr2bETUsvaTSMaGiAtbrXEGCAk0axrThzS3uuT9auJGjlcgI02aXZM7CUzWx8x
	3yjQaiEXfJ757cgOV/PSCMghm1qiQ/WAO0qKaYJzvsyZRN0IuAaT7I0PcKl5BvluiuPpwDJ5Y5W
	GED75ixtGZDLGkSYCi/yK9elNsBlSjBF1uCxnUTShhqTSryWP1vIgOGApuZQ9ax6+59/zRlgCEG
	xoo07YILwSFdF9Mz55
X-Received: by 2002:a05:622a:124a:b0:535:bb33:6351 with SMTP id
 d75a77b69052e-55d87fcff29mr19987351cf.1.1795322906822; Sat, 21 Nov 2026
 20:48:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261118132719.632451-2-ardb+git@google.com> <sashiko-outbox-223175@kernel.org>
 <b7521ecf-d30a-4b47-959e-43257baaf8a9@app.fastmail.com>
In-Reply-To: <b7521ecf-d30a-4b47-959e-43257baaf8a9@app.fastmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 20:48:15 -0800
X-Gm-Features: Aa3M54offAfg3834PgFby-yYoDkOuUmUfJ9HCVQYtK0CdYb7PRNW36LqxMd2aV0
Message-ID: <CAJuCfpFH05dc+K=NproS=T_piiJqx-xJ7zvXDdNe+g1_bXF2Ow@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: Use __ prefixed ELF section names
To: Ard Biesheuvel <ardb@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Ard Biesheuvel <ardb+git@google.com>, 
	linux-mm@kvack.org, Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1AADFA0007
X-Stat-Signature: ju9tpjis4sneaygess3z1pdsrxrgpk83
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795322908-2295
X-HE-Meta: U2FsdGVkX18m88yj/c4IpnF5ltIgXAVTBLD4NAm+K7xrJy1fEMgBx8BW9dsNGLZ30k674FPeoDTtvN8s+nUE+55Qc8IcmtFS/iPEQ89kHbpqx4C2NusjaROeR6tZULRBBLwTl8xFgk8cMntmHPvk7y38Wl1cmvug7Qjn06K0O5fJNs9/UHUWUQ4KpzN+Kq17ZNr+L/hWfHC/sQe2IF7SvCAikRMoOw53TrspQt9AkCnsR6RzbfTpf0Wxh14hnbn7a5CNXQoL+ZmcorUdVsdkKicf0pSbdqQ6GIJs8YuIuc4UWMRGymAqGtwMmPsMJ4V7DpQJjuqPRHtIeVRXAn65ACx+r1r+PvcvkZ6yodIQkPkmXABmE8kR8SSV2FCvdcsttxJDcu9VOs4qqbVamQsQY2ywfUNaa9xyMWfsVwWAiQ2ieH/bN8hRaEjgeinHdA05iBtEEEQjZ5+0uIGZI4iqCCk65xPDN+0q5dUpw89KGJDyk/dawpcvk4n7u2F8sAj/AFlBhW9u+YyY+dFCVGRz7XmBrQumGDIK96+e88WUOcF2E8DrNZo/bYnD3HOXYl3CfmeMZ8fc9W/9fDE3mCjVRznT+KmpjVKqB5Ht4HpJ77WXK8zbgpO1+M4pWk/26PXhFKIUfDUw92OT3iikoOThIQXon1mrRrEU5O4Pfulo6SZRhAUsCsQaXoZ4xqfnWpDv1bPj5g9jByJIIZsoA8lZ0ZtPqDGM1944UU8ziOFmTealIXY9AqJ++r4IRvVC8XJpBXOkmZtXk1tQQ/meYHNkXscfSMO4s+fWF7EqpyEIhmzus9oWQ34iXKttbI9P17oYfBPucjUyU36DFN3IWwxMx4MuAc8VcBpDTyRsHoyBELVj2fxeFCGC/sEaamYddSTkALc2KfXHtGBuWAsmC+7jTTi5QaMb1xu0Pq1xlYzpehq1XIDkqIzZxxql+3sgKaUtkKvdtqb0sbwBllyhEUr
 tafpO312
 Vg87xMgGE1cIrTErRKfdJHVweWupLkvoqIzFPXVdpn+pAxhgpfNPFieFIN0C8ZvS2+3weBBYfZPb6+qHbjXdCCiJ1CzEpG65VbX9rcBqeWSqOweMdihsxWK/npM1a+/tUy3ZRLZJhXoBE0VP9jNXpBSM16kyWgH+vEdnwJYV32dFJVVW+7/8Epi/67yju92IHney4sw7+gIfWfXQ7sJ71dDHcTn3bPOAgLQ5B9MqnenoJT49tMrXR8IAsE9iw3RTO8Lu7Hbai6DJZm9d8tOxtNiuNfN846STgZ0LUFFI1A9fuZEyAICJAKz6vAi/Gk29ecJJh7QvTE0FYcSOb0TaUzs1Zub2pO6IdgHnMezo3oQk9ubNp0/DUoePBGxbQEB4Ll5vU+kgBWqo9KFaaa+fl7sr7FykAdUMNVB/wPs2eZ7/8NQE0IjgaLvICrfPPrGTHHIETuvcOkpntOz+Fu35oNvh1WLI+dosOYSy/1pOqycWa1e1U+XUrtcjEMTaRlV0Mfp6iOAQyeRTc5nMPxNWhY9g+Vk/Xy/ZNgl5ImFHS82YceVH9GWvDPeOSRyVNx9G80oLJUtehVV87ixXZvE4odwFeddhGbnUmFoxE/WC1G4ycip1461V1nPlcxzV+dI9UH7aqEuqHecF9GgSY8lF4hFoe2HfD1xmBhAf/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 6:03=E2=80=AFAM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
>
>
> On Thu, 19 Nov 2026, at 14:27, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 2 potential
> > issues to consider:
> > - [High] alloc_tag: SECTION_START() and SECTION_STOP() fail to expand
> >   macro argument
> > - [Low] alloc_tag: missing Fixes: trailer for unprefixed alloc_tags
> >   section name
> > --
> >
> > commit 933587991e6a16ab600445b22347397f80335de9
> > Author: Ard Biesheuvel <ardb@kernel.org>
> >
> >> alloc_tag: Use __ prefixed ELF section names
> >>
> >> The compiler will emit static relocations related to a section .foo in=
to
> >> a separate section called .rela.foo, i.e., it just appends the section
> >> name to the string ".rela"
> >>
> >> When section names start with . or __, this results in relocation
> >> section names that are correctly matched by the various pattern rules =
in
> >> the various linker scripts across the tree.
> >>
> >> Without any such leading delimiter, it may lead to spurious warnings
> >> such as
> >>
> >>   >> ld: warning: orphan section `.relaalloc_tags' from `init/main.o' =
being placed in section `.rela.dyn'
> >>      ld: warning: dot moved backwards before `.rela.dyn'
> >>      ld: .tmp_vmlinux1: section `.rela.dyn' can't be allocated in segm=
ent 1
> >>
> >> Fix this by renaming the section to __alloc_tags. While at it, tweak t=
he
> >> headers so that the definition of the name appears only a single time.
> >>
> >> Cc: Suren Baghdasaryan <surenb@google.com>
> >> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> >> Cc: Hao Ge <hao.ge@linux.dev>
> >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >
> ...
> > Does #NAME in SECTION_START() and SECTION_STOP() stringify the macro na=
me
> > "ALLOC_TAG_SECTION_NAME" instead of expanding it to "__alloc_tags"?
> >
> > In alloc_tag_sec_init(), kallsyms_lookup_name() will look up
> > "__start_ALLOC_TAG_SECTION_NAME" and "__stop_ALLOC_TAG_SECTION_NAME"
> > instead of "__start___alloc_tags" and "__stop___alloc_tags", returning =
0
> > for both.  When compressed page allocation profiling is enabled
> > (sysctl.vm.mem_profiling=3D1,compressed), kernel_tags.count remains 0,
> > causing idx_to_ref() and ref_to_idx() to misclassify built-in kernel ta=
gs
> > as module tags and dereference an invalid module_tags.first_tag pointer=
 on
> > page allocation or free.
> >
> > Using __stringify(NAME) instead of #NAME would expand the argument firs=
t.
> >
>
> Ugh the token pasting stuff always confuses me - I'll fold this in for v2=
.

With that change, feel free to add:

Acked-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>

