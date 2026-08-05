Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E59C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B946B008A; Wed,  5 Aug 2026 10:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFADE6B0095; Wed,  5 Aug 2026 10:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C406B009F; Wed,  5 Aug 2026 10:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89E576B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:53:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09D6CC04DC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:53:08 +0000 (UTC)
X-FDA: 85067508456.11.B7B9C2A
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 15BF91C0011
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:53:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SIN6R6aX;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785941586;
	b=Qm4DGwk2D4GaI5uRQH2cp/1LBnKCkQ3YREqqohLSryDeRnZhA0hrFBjpTxI3BEIFokxAXV
	WLzmoFoZhN1UQdUyuBXh4J3DFC2c05hesPrCeC19ej0wKJbx7typYWR/cfpplY4rR2SzQ5
	IEn1/mWsdeY2ybRbvnSv9SQmqtOUKBA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SIN6R6aX;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785941586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhHfw8IKmQhSRm7kIO0Cdw4azwnv0DEyL0+zw+KJvLs=;
	b=EdV2FvXVeEKi8z8O80XIKFxecDiRQpzSSv8Y+9lTuWDyhQS1mZxVo3DUG51CtUK+FpK5Xs
	QJfB1fegYmaIv+WKvC7nRwktKihownr17SCCDTY5HM3hcmhF2r+3qpt3dSMwiWEG6Gwb3l
	9XLPAC1ET4pBX3lLMo0Wce6cVwj1MDY=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-498012a61f6so66255e9.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:53:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785941585; cv=none;
        d=google.com; s=arc-20260327;
        b=gLqN1xdYXHxY4zC/Uu8a2kk5r+SfkkGSnYtLnyyima1z1TT75Mp+aXZNoFJBiENW2X
         ZjB99hZ1W0hnGvogEIPgaE/3mzDKkN8eilsfcmgciGINW1xCul000QFMwpkBTBd6UWjO
         7WQVD4Pax9g4zQXmVRHQxu2Y4oleEimiRv3EEGgM+iOCUaaswhmGmzaVwpsXxl+IpsAG
         rrDtbm+/NYnb5FESAf/bbLhOoUgyXHyOpnoLqpjIJ+sovrEA58lsz51OFeUXQW/IakLc
         t8SJ6ChNjpAEonw6absMaCdA7mHeEYTILXrs1hfamzKhGGAkknZ0VZnYtcNMlQp+3bgI
         Uosw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dhHfw8IKmQhSRm7kIO0Cdw4azwnv0DEyL0+zw+KJvLs=;
        fh=gPS0YbVMbkAQhgidBGe1jtHwxRjBXD4V7R+xVUwKHaw=;
        b=MA9sPGbcr5cFI2qMGYsZPTkg3cb3Zn8nE66vOBqctOSLSImHUxKQdQZFk4w4mrjCSQ
         us4KvW9j797zasd5BmengR6Yb1FtgOvEOL/cJDBgMixPMWwas9YW83bkaeIs2bg5/tJv
         JdkDMXdmQGFq16Sfn5zikqB+uDpkaHyAokgTA7OZefSfLKxZZpygJveN+5BT5bWczfTJ
         UJACwFBNozdNI9iGS80Z5BkMEbx1O9pbdTyJgpbEZghKqLx854gUf/BTl1tM/NVeSZIB
         Y6XMVwW1+6r+93Iu6oGbRfsHLsdQ3VfIBkn2NT9yg5R9Dd0GrX1uQs50q+uHIXXv+hBJ
         yE1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785941585; x=1786546385; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dhHfw8IKmQhSRm7kIO0Cdw4azwnv0DEyL0+zw+KJvLs=;
        b=SIN6R6aXrxJJQNsCecuE31glJqQuW0enw4LoDCz3cu2CkynNhAST+Jx4ZwwUre8Vzc
         ZDkjj/snSPSFsBBAyc83SBVsWDJG4Yoip/x7Ehyiu5rFKR20zEPNUeZlS80KbxbCgB+J
         ZILIk+GTo71CZOM/ApygMj/Q2db4qBeu3WX9Tx3jrVYzcX/lhcOVI90FNR7AIJwOZxlo
         HAomIiAEBgST8iAOsjQ+NzzKshs1Y7R5iu/YjsML2TRDPASPXWlyoJ0n8Si+h1mYOLkm
         z4pvgv4b3FZoRneYxQjpYUdr7kLFCJRrTb9fBxaHMQsiwAVgGnIPvMHCckiLEaToPiMO
         gi6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785941585; x=1786546385;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dhHfw8IKmQhSRm7kIO0Cdw4azwnv0DEyL0+zw+KJvLs=;
        b=kpCDMJvP1mSosLyF8DZxxkkZbuTJZIcvtskBWJtbANgFc6Wb717G2xmSZ2xUJLJwWI
         wLC9IBQKkgHu3V44KaPSN7LHgA8Je0h7z6qeGLfhAZZZNhyek88NueN3s2kHFn/LTz7p
         6eMGFR7urRlPfmP6r4dOPtn3FBut6VEIww1dltA5s81Drvja1vRksrl4OijFHqVqAgqu
         XjuJ9p41W7mM/hQHZjsxktMfGdOv+ziPNQe081GT99IN08aBLfOwjgAKE2XULH2BJa5I
         RVKpmCx9J8k/XwVdcAC7b0+opmO9DlrtgAL9Sow9zRL8PmrJDZ00rguFOUHS88fwawh5
         rxvA==
X-Forwarded-Encrypted: i=1; AHgh+RoA5TX07GcAZ/7pUFFWNAN0l0HrQ21DlgBCLpQFSBKqou/MRdbVG8PHjpXWmeNWmqflwaSrORzonQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5s22VNqo2sXb5jbvlH/v9MBlaaAnRu05lnFJYrsAeg0rFYk0j
	As4jJOVlUZJzX5B6Tg8nqzNm0rbKV8L49PBZTiW7Z8ka42OhbMGLXaMCbQVhSXWckxepQh/awh4
	iI17XRcoOSh7OvST9cypcjkBd2EUyIoriQO0FP5hs0pgS3/i8G7e9rdErXtk=
X-Gm-Gg: AR+sD12nRS6EQaIzaYK9qjkscgsBBwTMMcHP0iSEwkMzpvI6ToBNWwGqQlchV2gqDHG
	DcYO95drevuTeuvj9kXL7I8ykJ+nZySk0rUASbl30CMxBbk0FRRkzIWIeEDsvZWKQ5qFALI7qgE
	jrYBlRSfgRhMuV1tPRem7cjIn4Q72Fi2PuwFxTaHOlL7S0p2D8rf8yvtw+yWI/CMZttUJqpi05O
	HAeZHW+Q1QED+C1b+fC4EyLNWNbSg05V6vHSfxGcBOTI+XVMrlT2Z3xlWOA/23MmPmIH8xDoDOl
	YX4hX8RkarvxZ2FOCCacbZE27RTrqpi5rT2C/0XOyaeqip6cEXZLDmzGDrEHV6Ih7thXxlVeQ3A
	=
X-Received: by 2002:a05:6402:2057:b0:672:117e:55d4 with SMTP id
 4fb4d7f45d1cf-6a14fb41676mr74064a12.0.1785941197837; Wed, 05 Aug 2026
 07:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260804122038.190270-1-hao.ge@linux.dev> <CAJuCfpGit7zcNPGAB9D2A5+718NY-qdksxt7gUaN_eRcB_5+Ug@mail.gmail.com>
 <bd95f8c6-33e2-4fda-bd4b-ebc37ee7c0fb@linux.dev>
In-Reply-To: <bd95f8c6-33e2-4fda-bd4b-ebc37ee7c0fb@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 5 Aug 2026 07:46:22 -0700
X-Gm-Features: AUfX_mz50Be69N2L1uJmWHpgSowRNnB8Q9VYlBGvXf-rL5eJN_8IPVgC77iH3eo
Message-ID: <CAJuCfpE+-nS9=g4nG=ZZZ0vCnWBxvgcU9LQKj+wFdicreD3Bww@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 15BF91C0011
X-Stat-Signature: ofmitxi9yrbghr9zbsprfcc1x5ja6byg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785941585-222639
X-HE-Meta: U2FsdGVkX1/oy1vA6stOnSCvrpk9DQBFC27qR8OEbdvKmdCpQ0efWl/1pKebpxHnQnHOMdi4WIgxNdAPsho2lgBCa2Tn5ZPLyaOMbyzmWqSc7dxBiqROtflYfNzDKlpIFVHsSU9V6ADb0LvnwLvp2Nr05v1cA3vjok9N4dWboW5KdObPT8e9alYlpH+Zcc488a2khd0zYqaj+fG7pBddpx7jwjsZt0uEeCV01e9wMZxo34ePqUo16rU7cYgSHdQXiJvMzlCciNlao73M7UosdqRl0LrEKsWzO39JWk46gDETm7coKFJp95kvFGRDQjl5NoE1gCDonHtrkY6hD1OEkZSiWMh4VOKPz2CmiuRlcStGyE+pg+LwXtjj7+TTH3OlbBCX59eZS+0U1mUmsGEhapnHo6oexaa+HabEwLe1smfsg3hWMCZSgo7z32phKXXCzBBO1Ch+X3cXkt7s5heNpeBJnb6pU1lufggN7skGwhZbvEw5sUCNmn9aAnbLLcnaToof9To1j1TR9JAfA6abUuXAQrffle//XsIjFiWoVnfOJOHDZbhNG6mpZbRJ9RZQr/q37H9b3ub7gjtgi3x65BxaybBmAOviayawdKUO8BbdrSxK6U9qjaj8mZwNRpwHdgBlxCe4jXl3o6gGbU/qL5yBqXFhzDfvJ6Nnx6M4zxEIKBv0IrHnROPKs3yvsnHaJXtzN7znm/2L4Cs/vds91wv0sRXWBXK4Jo+Tl1syUgZ8C2tgBGWgUzzsJ5sKpaH9JFk2W5syx+pkR+5Cb0+Ca5SLXNGyRXTFuk2h9Sc8WNC6rMI4xJsQ/MkE9GCTcQWoiTrlmCcPFFlDfhxiUE8GgqUmS5TSIy955mWTJURK974L3wCWJm/waTfwLxn2t1+j9g4PvrEyOh0+GvIGvCBfzCHc9UmFw1ZCsfNlPkeIkvKWvxQpM0/xOL0CM9XBnZQiyrP5SpWuGj9nG2eejA6
 rEFrlGPF
 7QmtWhocfw4oIT0vm01xKXytq8jGnUJLacEHfbp8FyUzmUoktwtfRarxYZAbQdaQ1BPJxVM7G4tVQcUa4Zttk78xVAwXZ3XUOLdCk0yG+JOnvukuqkVMxSMLjzAv959Jiji4lDxF5UQ2oQNfppJz7PWsFkLnpcQKKQsBkWGZRvnwb6+q69UWOPPHGrEKz+GVpw4AiuK0R6zaXZ191mWSAllNBAI/moqqXXiiem1hEfKwyal0Ebd9qsa9vBUmGV4wAfz/QteFpqOioOsr0pXQuj5Su8nlfqFO2fOKr14+4UhSx+UGqXacTNU41fvx7O26ngHkKZB1La4H/tGbeJ5eU/4G9GnJeBq28mqNMUsxGh7+DBFeUC/MqZgLBlntRH1JmzvqL5ICzpMm7Lsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 7:26=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
>
> Thanks a lot for your review.
>
>
> On 2026/8/5 04:08, Suren Baghdasaryan wrote:
> > On Tue, Aug 4, 2026 at 5:21=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >> In reserve_module_tags(), the tag overflow check is gated on
> >> mem_alloc_profiling_enabled():
> >>
> >>      if (mem_alloc_profiling_enabled() && !tags_addressable())
> >>
> >> If profiling is toggled off at runtime and a module is loaded whose
> >> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> >> skipped. vm_module_tags_populate() still maps memory for the tags and
> >> the module loads successfully, but the total tag count now exceeds wha=
t
> >> NR_UNUSED_PAGEFLAG_BITS can address.
> >>
> >> Once profiling is re-enabled, ref_to_idx() computes each tag's index
> >> as its position in the alloc_tag array. update_page_tag_ref() masks
> >> it to alloc_tag_ref_mask before storing in page->flags. Indices
> >> beyond the mask are truncated and idx_to_ref() resolves them to wrong
> >> tags.
> >>
> >> mem_alloc_profiling_enabled() and mem_profiling_compressed are
> >> independent. Once compressed mode is established at boot, it stays
> >> active regardless of runtime toggles of mem_profiling.
> >>
> >> Remove the mem_alloc_profiling_enabled() guard. Also return an error
> >> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
> >> the mapped pages would never be reused - shutdown_mem_profiling() sets
> >> mem_profiling_support to false, so no future module load enters the
> >> codetag path.
> >>
> >> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compr=
ession")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > Thanks for the fix, Hao!
> >
> >> ---
> >> Changes in v2:
> >> - Return error after shutdown_mem_profiling() to skip unnecessary
> >>    vm_module_tags_populate()
> >>    v1 link: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge=
@linux.dev/
> >> ---
> >>   mm/alloc_tag.c | 3 ++-
> >>   1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> >> index 52aece27b00e..d8c36430f1c0 100644
> >> --- a/mm/alloc_tag.c
> >> +++ b/mm/alloc_tag.c
> >> @@ -904,10 +904,11 @@ static void *reserve_module_tags(struct module *=
mod, unsigned long size,
> >>                  int grow_res;
> >>
> >>                  module_tags.size =3D offset + size;
> >> -               if (mem_alloc_profiling_enabled() && !tags_addressable=
()) {
> > Makes sense but how about replacing mem_alloc_profiling_enabled() with
> > mem_profiling_support? Otherwise this warning will be issued multiple
> > times if we are loading multiple modules.
>
>
> That's a really good point, this duplicate warning issue will indeed happ=
en.
>
> When I thought over your point, I realized using mem_profiling_support
> creates a small race window.

Yeah, you are right.

>
>
> Thread A=EF=BC=88insmod A=EF=BC=89                      Thread B (insmod =
B)
>
> --------- ---------
>
> needs_section_mem() -> true
>
>      needs_section_mem() -> true
>
>      (profiling still supported)
>
> reserve_module_tags()
>
>      overflow -> shutdown
>
>      mem_profiling_support=3Dfalse
>
>      return -ENOSPC
>
>      reserve_module_tags()
>
>          mem_profiling_support=3D=3Dfalse
>
>          -> overflow check skipped
>
>          -> vm_module_tags_populate()
>
>              maps unused tag pages
>
> So I'd rather go with pr_warn_once here.

pr_warn_once() works. Thanks!

>
>
> >> +               if (!tags_addressable()) {
> >>                          shutdown_mem_profiling(true);
> >>                          pr_warn("With module %s there are too many ta=
gs to fit in %d page flag bits. Memory allocation profiling is disabled!\n"=
,
> >>                                  mod->name, NR_UNUSED_PAGEFLAG_BITS);
> >> +                       return ERR_PTR(-ENOSPC);
> > This ENOSPC error will be propagated all the way up to the init_module
> > syscall and it's not among the error codes currently expected (see:
> > https://man7.org/linux/man-pages/man2/init_module.2.html). I suggest
> > returning ENOMEM instead.
>
>
> Agree, will change
>
>
> Thanks
>
> Best Regards
>
> Hao
>
> >>                  }
> >>
> >>                  grow_res =3D vm_module_tags_populate();
> >> --
> >> 2.25.1
> >>

