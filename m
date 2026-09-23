Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB225C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0CA6B00A1; Tue, 22 Sep 2026 22:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78386B00A2; Tue, 22 Sep 2026 22:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E486B00A5; Tue, 22 Sep 2026 22:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 828B16B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:41:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A73A8068C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:41:54 +0000 (UTC)
X-FDA: 85243476948.19.D672566
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1DE9B1C0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:41:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UXpZoGKL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790131312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMdgikVEgbwQAqoDuHQqMGEpgmnZ1PYCVyMsDBPWuTQ=;
	b=bdImAz91JSmZ1eO+ehDfKgQ9bLp9qjJZtZAp5pTivcSfcpNYAXlgezx7B92ZgN5z+AyZpf
	U9CFaqXQQR+qYtLRMvRKJYh8E5YkEKKn34JwPW6G33oDuOU1ux+nY7JOaZS9PEKaZ239wt
	AFWW7JDTbBbFu3BtF6A61o+e9FZMLrw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UXpZoGKL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790131312;
	b=jYCV16Wf/us0VOWSCInpQ2AfAvBRmE8BM+Ml+dAKRqvDE/vkDzOTVYr35SDF38fxnTovcV
	KENrrkhNjNxUVKeuebcxFksLSoAjmW7Z3i3JQdMoDnhMAs/uJunBa84sN0vgvmVOMmgO3a
	ZQQ+MKvALiHJ3WjltZiDE/BIVlmpycU=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-530e8c6fb80so72911cf.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:41:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790131311; cv=none;
        d=google.com; s=arc-20260327;
        b=Nn45ZyX3MQ3GbFkpa7cw7k3k6OXLkMvNheDgfnTZ1t18urkJ+5eshsztgogrz/l0tS
         ilRBA6gVDyayTil5jDM9cNx6QfoLamIGvtyeIWZoEQAEhnCwpuPDbjhMWP9V7/5RLWSp
         y5F2jnYjiCLqjWLgm+qAPap8nne+a5CfHP74mcjkvFn19IDjeb+wRMQZULlH/hHz4F7H
         LENZ5Kh2E8Ha+suOq7ut0x2rpnCNFGOaTt+sHx5QwIdgnae7OATLakKwQ3CsenXYk+7M
         /LsgIFjgZw02BrdKYAfavrrN9hVhAEkjkgQtcsVpmglqHDnwEPDSz9PWMeV6fG8HFgjM
         TUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aMdgikVEgbwQAqoDuHQqMGEpgmnZ1PYCVyMsDBPWuTQ=;
        fh=zk0MFkdB8rEZcowmpxirxXXo2DRLEPNDUd08NvoDKbo=;
        b=rqk7UD6Jy9k1QvFeYo6fYI8w95nBfZeuWULBVPMI/E2++z1x71FE5JjJoyBl3RPHMM
         ZnB7aXYpFEXrDjA96Qom8t5rJcKmH2EMpXUtyg3P8IsbD/KSdtahmK3n06jgqsc/lktH
         jVHhhijqGiSK1IO7amJM4tsGQck5YdOJlH8CS1KkVWl+tpTlPJvjhr2x0Mew49bV5V+E
         S6kDuNhcZGn6MtgoYsILc1XQSsKUxJU5ybWBSXzReTdcXSveQJiovFJx4XKrbT68ec0l
         KwOE+jXMhfI4VwGJw1T3GYz3lzWTreBIOWeQdg4VjweZ1DgvWfzmf5+WV3q8I1tAQ68h
         BHgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790131311; x=1790736111; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aMdgikVEgbwQAqoDuHQqMGEpgmnZ1PYCVyMsDBPWuTQ=;
        b=UXpZoGKL1mNEhcTsNkqgLlIqUhwWgwhB1h/dxE/iVny2yv/GbK21NTJY1itwvwyI9L
         tX5oR6HnkQLSBT3Y2VsFC7wZ9MVa356Y7ASWqqNuRJFSWVw0c5G23G7y06o+/53MUwBZ
         ovl42Qswb+3Rpny2TU4NVHNgsaRjvacPV3IaBn8Z19KAjeLT/7nXsbFY4W6zYgWXpgIs
         rTslVvE9XiASFClJw4+tmLvDIELBe1wWRXAT+UCC1YxgB00R+zoYNPcUciP3wqxNvtsP
         SOQYVjHrpc2c0S0SY9/FgucjYUmQqCGW2NYGWCZ0Mi01qsefwRTKyOkSqeeXjrPdZpZ7
         UDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790131311; x=1790736111;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aMdgikVEgbwQAqoDuHQqMGEpgmnZ1PYCVyMsDBPWuTQ=;
        b=aMwpOkBnyf8sVOmVYO/XVdDv47qqOmF92vh9nDZEbXnCC63iQ2cBmYxU2EFAw9EeNx
         EzKMZ7mnLfE7qYAnvsiRty6D398LeUP+lZP1yW9D8eLtat3KZtuFmOkXX5v9BDdDBBnG
         +iHuLTDPSiTUSW/EOZwW8bnHazHzSj3XXhZR06vgguVYCv+KkgpMnBHG6oGSUn2Nq4RK
         s4tXx+TtchRk0UhAdA4vc8e4v+mOCEC95MdZvAZ8lLWG5XjXjibgoIa51emx29pb6w87
         EeHnRyl5UldQHM63SXVKt8HnO7lMYyGtYzHzLwAh5cpxSNv1tm9z5QgalIt+2sWA4MXo
         SOUw==
X-Forwarded-Encrypted: i=1; AKwUvBymOT0iXseZhRdA8lL2/mz8/LfPBsBe7Vv9HwAc3yXQKfLMsS1cSpeNRJ9jCB9R8WN+u2kFBgOnrQ==@kvack.org
X-Gm-Message-State: AFuF++nabnMj1ZUvTLnev28QY7O1g94mNVgbGF8N3B7R0MeDBIhmeJV4
	Z3cWDVEeFiRLbEHu1TmfaMgTqj5wWf1xGFkFr4tgJr2Zpb8gsFXuKSl2dZDmuWzxH/GtWWbPc3W
	/qBrDF5RBu0oS1sfFFs8n2Q2Cp3uPr9vLF5aRmynh
X-Gm-Gg: AYBFou0nBXtXNQ4pFwbH+t6EskTDt97sW8sW9osqzanIoHhZDjNnlb/qHr5ama7oxuD
	atDbF0P8GlXoQaWoKi87fbkJam2g0SpUGe8OWl611jg62+PQWg7+MqsziRhlLdBM+jynOtFsdp7
	v6eBbdq5mrMRpRZMKG+tkRQ6bsBbfvS2SPIigCrnkDXGVn5xNKsCy7n2764uT7D53X+W1wcTPY7
	/f75yvhPw/0vxTKYTHopwyCMMpS9COHEjhOly+pKQRSR5GQUsIqg7pg6mC8bExGG9LyhTEOawM0
	/XkpRV7ohLhVYKb5Yyo202M9ZyGhmALHW/zgSCUy16wsH+s1dGLfDQ==
X-Received: by 2002:a05:622a:8307:b0:532:c8ca:5ae9 with SMTP id
 d75a77b69052e-532ef021d41mr3289381cf.11.1790131310427; Tue, 22 Sep 2026
 19:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-7-hao.ge@linux.dev>
 <CAJuCfpGMQqjHsAvW=XUA1Q3AyaVJKM2bKYVja_fgn0wa1tk7DA@mail.gmail.com> <d7327cdd-43df-46f8-92d4-c25dda7ae684@linux.dev>
In-Reply-To: <d7327cdd-43df-46f8-92d4-c25dda7ae684@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 22 Sep 2026 19:41:38 -0700
X-Gm-Features: AclHuK8G_VNDItmD1FBLXjWgMC7CO-sPt9k4BV7Zop_hKhE8VPUN1FVpIu4Rkf8
Message-ID: <CAJuCfpHMdZzJNSRgysbS7vOBmTwEPSYfPYUvt_5+uZ-Ydvw+hw@mail.gmail.com>
Subject: Re: [PATCH v10 6/6] alloc_tag: Defer /proc/allocinfo removal to a workqueue
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1DE9B1C0004
X-Stat-Signature: bt1z7ti58fohccakd479hpgp1artaox8
X-Rspam-User: 
X-HE-Tag: 1790131311-894733
X-HE-Meta: U2FsdGVkX1+JvRZJbtxLw13QGNNd+na+h0RQEGAX/LIuwJeF212bOCziE6lIH8HH+O9yazKceYEa+YblO5bdnWOELs4mqCYaDhzxQee/ucLvomlkbI1ejnBzBNVqkQMUFyQHofawUEniXNTLANviyJIc7HiUW+VL2jVL1cIuNV+956EnmPkR3ZwqkyOerLTcxTDXHeGyDKD889sy3Veg9vHJ6Tvo02FYV/UzBG485cZIgQu7EkQqc9XvrRi7/TIlpO71vWPxKVR3PrgmK9ORDHRNAzh+TyOoi69En0f4W80tt5+xllLeeHY+3EmipTTz9D4kp1eKyGFbhT5/5npjuvL2kU+TBvFu5OQZiklfgHGtUBfs8Fx2D0/uMc2V03rirUOQGQGdYeQq9VoXzpSkEuW0nkTqxc1t6O770RCdj6kxwHehg5nNXW/iA5fLPMBBrXteiHln+TtWQKez7XMlzHF/LVAuBKZrHhwH3huydZtmmHW3radSiSHdBXyby0z+m3zXnkwsrJR8WDUmw2iAItS0Aci9qDvPL52S55W4G7n7lZIEWMfccEpC4Cw2i/xnA9Ox2P87CElg8nUlpmMYv4XyUk5E4SIY7j1rZZj8YER6GB2ndy7er+ACt0/Vav4JC8IaAgd2nv/Wfy7d6838I67l4YpZRX2UUElAEoR67ucvg/hr7CvcBDx/N0THUknd9Xd6SdUk1ww1y7T8M9d1V1Q1i/cZozT+G3F8W8pGxdzwYZz1R/TbOa4pBwcqXMSfOIoEvZpObLXO/qtvI8MWO5CcqNZ0kGYLjGL8GICCFNGo1cIYNHtvSvEOu3RtiWmjxkd6LadsO6ieXBLZnbQdxlal6IHgsiv7sq+mrXknOQWSg+5/LRekclBnfNhvyM9MNQLU/iz7N2AvpdpfpLV7KEFHlNfUhBMO+ffNorizZFi4u1OhSI+dJgGF8lQdEdzOntRYAMGZGUKUqoIOkyC
 8NkrH0W8
 8aF76CK4HauMR3tOhSlxDaacJAQe9Wio8R1ewfCRRVlPv+QOcvFW97MRNma19KP0CPjQqH5Vg4hSSBuVtMnoOCJZNEKLEp5gwDcYNc1k+0uhG58tXDVvqfM7FboDpgVMhWSf5Fw1D8e5/tavHhGrpaFXiGJgPb0sqbhcv0XHxZdgcFJPaSrwDFdcF1wzM1ltM6XQsY5Ntag9cbbL61chS/qmifqF1Ywr8pxliQXKjx/3J/Z4fMf9qj1YV9meis8eHu4FMJYcq6XDIQKfhWnQOzjocjEmdpm5f5AtyXLkszvqiM31L8205U90UPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 6:38=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
>
> On 2026/9/18 09:09, Suren Baghdasaryan wrote:
> > On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrot=
e:
> >>
> >> shutdown_mem_profiling() calls remove_proc_entry() from
> >> reserve_module_tags(), which runs under mod_lock held for write.
> >> remove_proc_entry() waits for readers, and a reader takes mod_lock for
> >> read in allocinfo_start():
> >>
> >>   CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
> >>   ----------------                   ----------------------------
> >>   reserve_module_tags()
> >>     down_write(&mod_lock)  [held]
> >>                                      use_pde()            [in_use++]
> >>                                      allocinfo_start()
> >>                                        down_read(&mod_lock)  <- blocks
> >>     shutdown_mem_profiling()
> >>       remove_proc_entry()
> >>         wait for in_use =3D=3D 0         <- blocks
> >>
> >> Move remove_proc_entry() to a workqueue.
> >>
> >> The file creation is moved to the end of alloc_tag_init() as well.
> >> If alloc_tag_init() fails with alloc_tag_cttype still NULL or an
> >> error pointer, a concurrent reader of the leftover file would
> >> dereference it in allocinfo_start() and panic.
> >>
> >> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compr=
ession")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >> ---
> >>  mm/alloc_tag.c | 26 +++++++++++++++++---------
> >>  1 file changed, 17 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> >> index 1ca0409b492b..cfa0fc84b68f 100644
> >> --- a/mm/alloc_tag.c
> >> +++ b/mm/alloc_tag.c
> >> @@ -15,6 +15,7 @@
> >>  #include <linux/seq_file.h>
> >>  #include <linux/string_choices.h>
> >>  #include <linux/vmalloc.h>
> >> +#include <linux/workqueue.h>
> >>  #include <linux/kmemleak.h>
> >>  #include <uapi/linux/alloc_tag.h>
> >>
> >> @@ -591,6 +592,13 @@ void pgalloc_tag_swap(struct folio *new, struct f=
olio *old)
> >>         put_page_tag_ref(handle_new);
> >>  }
> >>
> >> +static void remove_allocinfo_file(struct work_struct *work)
> >> +{
> >> +       remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> >> +}
> >> +
> >> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
> >> +
> >>  static void shutdown_mem_profiling(bool remove_file)
> >>  {
> >>         if (mem_alloc_profiling_enabled())
> >> @@ -600,7 +608,7 @@ static void shutdown_mem_profiling(bool remove_fil=
e)
> >>                 return;
> >>
> >>         if (remove_file)
> >> -               remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> >> +               schedule_work(&remove_allocinfo_work);
> >>         mem_profiling_support =3D false;
> >>  }
> >>
> >> @@ -1358,16 +1366,10 @@ static int __init alloc_tag_init(void)
> >>                 return 0;
> >>         }
> >>
> >> -       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_p=
roc_ops)) {
> >> -               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NA=
ME);
> >> -               shutdown_mem_profiling(false);
> >> -               return -ENOMEM;
> >> -       }
> >> -
> >>         res =3D alloc_mod_tags_mem();
> >>         if (res) {
> >>                 pr_err("Failed to reserve address space for module tag=
s, errno =3D %d\n", res);
> >> -               shutdown_mem_profiling(true);
> >> +               shutdown_mem_profiling(false);
> >>                 return res;
> >>         }
> >>
> >> @@ -1375,10 +1377,16 @@ static int __init alloc_tag_init(void)
> >>         if (IS_ERR(alloc_tag_cttype)) {
> >>                 pr_err("Allocation tags registration failed, errno =3D=
 %pe\n", alloc_tag_cttype);
> >>                 free_mod_tags_mem();
> >> -               shutdown_mem_profiling(true);
> >> +               shutdown_mem_profiling(false);
> >>                 return PTR_ERR(alloc_tag_cttype);
> >>         }
> >>
> >> +       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_p=
roc_ops)) {
> >> +               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NA=
ME);
> >> +               shutdown_mem_profiling(false);
> >
> > You need free_mod_tags_mem() here.
> >
>
> Right. Another problem is exposed here: moving proc_create() to the end
> implies successful return from codetag_register_type(),
> so alloc_tag is already added into codetag_types.
> That looks a bit odd to me. Because all places inside codetag that access=
 this
> linked list will access this incompletely=E2=80=91initialized codetag_typ=
e.
> There is currently no matching unregister interface to tear it down.
> So I drafted one previously:
> void codetag_unregister_type(struct codetag_type *cttype)
> {
>         struct codetag_module *cmod;
>         unsigned long id, tmp;
>
>         mutex_lock(&codetag_lock);
>         list_del(&cttype->link);
>         mutex_unlock(&codetag_lock);
>
>         codetag_lock_module_list(cttype);
>         idr_for_each_entry_ul(&cttype->mod_idr, cmod, tmp, id)
>                 kfree(cmod);
>         idr_destroy(&cttype->mod_idr);
>         codetag_unlock_module_list(cttype);
>
>         kfree(cttype);
> }
>
> But looking back, do we really need to do this? I'm not so sure.

I think having codetag_unregister_type() would be a good idea. For now
it's used only in this failure case, so we can make it an __init
function and not waste any memory at all.

> I previously thought the issue reported by Sashiko was a false positive,
> and I laid out my thoughts back then:
> https://lore.kernel.org/all/afa606df-3d5b-47c2-9972-f3e0c2e13c12@linux.de=
v/
> and I thought the change would be straightforward, and defensive programm=
ing
> felt acceptable to me, but it turns out to be a little more complex than =
I expected.
>
> Suren, could you help me analyze this? Thank you very much for your valua=
ble feedback
>
> Thanks
> Best Regards
> Hao
>
> >> +               return -ENOMEM;
> >> +       }
> >> +
> >>         return 0;
> >>  }
> >>  module_init(alloc_tag_init);
> >> --
> >> 2.25.1
> >>

