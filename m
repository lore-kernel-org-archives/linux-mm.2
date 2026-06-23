Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C13CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 15:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9506B008A; Tue, 23 Jun 2026 11:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D890D6B008C; Tue, 23 Jun 2026 11:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29E96B0092; Tue, 23 Jun 2026 11:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3D66B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:35:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D01A0120559
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:35:02 +0000 (UTC)
X-FDA: 84911575644.21.2F445C9
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD1E04000D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:35:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Q6ibPA/s";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782228900;
	b=WxNPsNvNbMuvzz8Otls5ygkdkcNONvzlGhfSaN182eQGeRUlP5Cuq+bIrtz+KnqHBbT2PB
	1g1Jw0Gr7Wv3UEZ7uV1pMtb9nwjiqnNthod3iTGreALWJYcYtb5fT+AhghtyboYmXf1TH+
	fPJySAiret2vQgCkT39KmwDKycV7Up8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782228900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGc5O48HR7pepVvOkH86p+d+WQn7/E2BGrsqzSwA0sE=;
	b=kBxUiwMT9itU/4aHLFsndNA+33okgztsO03AxmLMY5nRvE0WLiMPfY0PCZCYrdboYmvrLM
	icKSmuXV90UJWBid1VxSlcC3GwwKrrHq/jshWkwX8j8PJKD1Mlc+vsGBzF9POBoYjrpYXK
	RVtvtKP5keKJfJxxNQxhC8uX8643HvE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Q6ibPA/s";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-695f6438518so8182772a12.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782228899; cv=none;
        d=google.com; s=arc-20240605;
        b=arPDQ8It4VLw9maYIuu5vgRd5GKsmUod4/qOPj+UvxHOsHqUMDOKvxFdOLfKogFYVD
         CmQ+qBB7RDhEPVXuB3T8ykBMVWMPrbBeZG3+CoEEXoCVMLxqaYaIt5pCo4kMYjAULdTW
         P+9XJlbTa+M2HsMOAKLay2Wr1aOOfcBjK/xadrKGRKhG1mKHAIQImOV75Vt69HcPmHY1
         l4kL7rSam5YtwQwJKUJCP1IluLHcbK5E7sAr+ljBY8o9XCRa+EBMFcCjPruej9++m2N4
         J+5T0+ixxo9694GXzMnGfZ7FzKNaOlv/ZA3PqiBfEenUXYzbwTmEDkaqJ7MF7EAt6Qbd
         AB4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jGc5O48HR7pepVvOkH86p+d+WQn7/E2BGrsqzSwA0sE=;
        fh=OYI1iIioknJMxQYo/+MAD1QVti7nU4ACovStSyvIkD4=;
        b=eG7SUhKjCPhIGlWXSlZXrHm96ZT3PQepvztmRZhEE+JW8TXE5RwuBuaby429jVnmMl
         Vl/ZxLEHxlD5pF47KHuoY9dThMjtMq9QmWxzJsBPc/0oY2oJWZKDg3tQsf3RrgL3cpYX
         7YPDxTbs3kEFLs14LmebYRzGotQVDXNc81ITdqwPmatnpIHhFCZgriIGKOYtI2J+t1fY
         e/WzXeRbJoB+TnIa09/cCiUU43Z0j3hs0H+gqAh/h37H3ILSboQmNCAkFPvy5Pa8UhxG
         jGGxvO+zHPOcOBoEsBUQzt4HQclcOQUKASKPp5BR/FcZlNUWDedrndkhjc9Fv5DrbgPg
         5KcQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782228899; x=1782833699; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jGc5O48HR7pepVvOkH86p+d+WQn7/E2BGrsqzSwA0sE=;
        b=Q6ibPA/s/W6Y2AeEzhHI1yeqzjDjtRub6OinB0tYrODnpYB26CRvSD0nQ21XHxTplo
         cZIby9boa5Imh6lcBDi5+UA4Yxe36PxAFrQlafpRvXlqqDVPZ3Ya0Lhb9gWUnxXGJMTG
         nm/+jKfkbSSvHJkygOi2QF+Hm16k7xF/uUnXf/3l+5lGvu8owdsZ5XDOHg54tLTB97Ma
         akGO3Vm7fU9IuiS/fTKtbRDCyLFmjKmtypH68zAtjhXy7iG63Ts/VhU5KIciXkPocZeS
         +WbzIGbWbbJQjEBfw4ZnqOn6sYonf2NbNH2oXBi4GtHXXJbeCLc6liUvuxcafSU1UVc+
         kZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782228899; x=1782833699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jGc5O48HR7pepVvOkH86p+d+WQn7/E2BGrsqzSwA0sE=;
        b=qHC8UKjB1ik7VHU03De+y8ZzMj1SJlYaVLUkUy+rIavHvuPOWUHO5KuEyZas9kGkJ8
         BDX5WJokA+Xm4NZyT6e1BwXtE6T5Kyk3BZhXzi8+3XCa4rMZKpLXaXo9QJ9qSU+xQ+f4
         03Jzjq/JlzNd+zv/k6nxjR6pM21huLydPB4UDIIEgjTOink1wTR6pXk+PTFQ4Obv8woE
         zQdzPUrJrmqPWA3CrN/qfNBNO7xfaft3hKfBJpulYeKIAUwqAb/yC4OyP/TbgvIBsMeJ
         n1i1GL9hC665un/E7NNkBevTJ2iPMPS2Lsn0nSvFlnIWeLlRnzIo/guaq94Ndi5Snrqg
         zAWw==
X-Forwarded-Encrypted: i=1; AFNElJ83dpQsTUuTHvM3L1d5qEgMtYCPJFQmK/viiQ/miQeglOKAt8BvXxuqxX/8J8R+YDeKsZusLrn3NQ==@kvack.org
X-Gm-Message-State: AOJu0Yyrs6nHaj2bx+fS4YIDSqJnBW7Ta45jkjUd1PUfr2OcvR9GipxS
	/xpBCCEIG+lOb2dPbOn4ZpnlMMCmlLHf4C4yFfE5nlQs/T86EiL3ID83vVpSxnBIEw54eWVAlZJ
	QQVgVNSCGwfD9m6jiTng28sYZ/lb0ci8=
X-Gm-Gg: AfdE7clxvzKKHOltdpLruXGDoXtNw5Uk7aPDXsHbCXw+eIoL1x+Sk376qsVJYOBE6gc
	/7M/cUUdmVAQ5wOh6TZEoKwPt8uETht2PRObhM0Jb5mnqBVdskvPwn5/2xXPXqTlWrQiCktgl0h
	tE89CNcxJdi7G7QZQw7NMDwoPaB1wJ7UG4FBzD7QUvn4/dR/NlWXP7dvw7DnO2P9hCawWrDPQl7
	V35Y+zqScK3sA2+RZ+94n3MoRP3D5llPoOjx8dpbha5X7U6tbo6hjUZ/txbIi5U2sRiPXfnQM6F
	MnkQtXBQojjmp1GOQwDzhum7yW/LdU4=
X-Received: by 2002:a05:6402:3205:b0:687:7fa4:faa0 with SMTP id
 4fb4d7f45d1cf-69711e0602bmr1457590a12.23.1782228898944; Tue, 23 Jun 2026
 08:34:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com> <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com>
In-Reply-To: <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Jun 2026 17:34:47 +0200
X-Gm-Features: AVVi8Cecv2_TqQ_O8FYC-won9z3vUEfkkWOTSNMZJamaSksyTs_hA8rdhn2B_co
Message-ID: <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD1E04000D
X-Stat-Signature: 3bo6dh4rf7zop7prkujoxinmaeabsd1q
X-HE-Tag: 1782228900-243445
X-HE-Meta: U2FsdGVkX1/Ou8tgRVL+gMesosR7l0qakLiH+SV3TMmIgDTYbX85tTUVawhD4UwzXYaIlhCLzvr2xh6hH4JnGa5QQxDD1BWVRRV610Y1gTRKPXdBKk+31sX7IkAm42pDPHVbry3tSZjHdFrBLZIUMnMzQ72hbmMlxxHc+9xO9uyELSd7JDQDDDqaSGF1ExjRjVafSZXYamLqrKx4wQhCD+d3sysQ/thTUswXNo3g8qhnBjcQit7Q8kUVva0c+5kVf8n5hAnmSNpjeOMZvLRBeYcNAWi+AQYbldSmL2cN4q2N4BcDsVS1UU9pHT+bh4xa/ovGTcZN/86a3uLv0sw11B33uxmX4JRRWaVTohOTRqoFjjOUb6e0xfToP69hLj25rLSacRKZkBMS/Eil2sx28gbSR1uEmCHYmGYhe005/6e83epEVsgdd+qutyRuYFaLt0M7vevSO3te2PDWgrhcuQvTmXSggv8P8oziOrpRtVaVxqsQmmTa+3p4QwRl5YZJjH22D/owIK7Mg1dCtIT8ND7fvkklzszHb2FyVIHO5slKPp/07ETHz0M12GHxzRUGeRbh+NuXptpfwQB8o2rZMbCfNn+D1QB6LTfGfZowXW3wohNtjccyyVqF9GPFoTcz9e/p2VyboyLSrIpwijY9MGlWDW8bGje0W3BU3ouxYbtqR6A3jDsQ/Vu2wux2DpGTmvGGzKmTTPHyUbjH1BqZP+102dRLI2RnDflrCqEeO7/BQ9tvyo3rGtmUd32k/7buQHam1AHM/NFAU/Y+6Y1rzwIVM7nc0aDj6frNvEWV/Flgm5dzFO07pQnIQWCk79AWZ+8kUy06T+zdZ9gwnh2/UH/kEBi3Aq0V7QtFcHTP4y4gb5IpgtWwGTGoJp//D4kWt1EhUCeHN/fF4gnEqSPfujZcsmMkXk2QdVQ36KqhSWGuWnhra2L+PGs2xMFxHOWE5suLDN9c0E1Vqfv9FXy
 ZsJ0RSMN
 DrD7bIQJoSzCueF040N2pQ6FxUgJ+C8aYpqB9afBL+Uars39C8mpM7L7C+FsOlNTlNrHsXZfMwSYCceR0bQyZe1fyswns/J8fgncFA2cAZe7vtvMUKeLBzHxiys2v/QY6DnVo+Pg41dmiEsnhw2qYaMPbivXlepSPWFm7/cnr+I9NdPrdfEU5bQsxPY51B8fWeGdtHThwI78ogQArz17Zccg/lm4jiKpFZGh9kMgoM3HlH7CkvC7URE8rMJlavkk6zGAU2OOIBTXYgtE4zqrLyJpxOUbsf1d+n6ppEkUA8sE3qM57Bk7vHZGELslSozGlXYCe6BtmSTZCoUMBOCZYCIpXbXCw6YhrT2AYWrlp8f+IcABt7ZbsDZEi0ZOq5zQbHIIpxGPU/DBJOtS0tA8WCozhezTsJLKXEA9LCUNAHbWOd+v7U409TLpYHwLFNbbraxe5K2t093pxkaKelT5Nh4yJ4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 4:55=E2=80=AFPM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
>
>
> On 6/23/26 15:48, Johannes Weiner wrote:
> > On Tue, Jun 23, 2026 at 01:14:48PM +0200, Pavel Tikhomirov wrote:
> >> The cachestat() syscall reads page cache statistics straight from the
> >> file's f_mapping. Stackable filesystems such as overlayfs keep the dat=
a
> >> pages in an underlying inode's mapping rather than in the overlay
> >> inode's, so cachestat() reports all zeroes for them.
> >>
> >> Add a ->cachestat() file operation and route the syscall through a new
> >> vfs_cachestat() helper that calls it when present, falling back to
> >> file's f_mapping otherwise. This lets stackable filesystems forward th=
e
> >> query to the file that actually owns the page cache. No behaviour chan=
ge
> >> for regular files.
> >>
> >> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> >> ---
> >> Note: Memset change might be a bit tricky, I moved it to no
> >> ->cachestat() path to avoid multiple memset on nested overlayfs, that
> >> means that ->cachestat() is expected to be able to handle unitialized
> >> cs.
> >> ---
> >>  include/linux/fs.h | 10 ++++++++++
> >>  mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
> >>  2 files changed, 45 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/include/linux/fs.h b/include/linux/fs.h
> >> index 6da44573ce450..966b6564707e4 100644
> >> --- a/include/linux/fs.h
> >> +++ b/include/linux/fs.h
> >> @@ -53,6 +53,8 @@
> >>
> >>  struct bdi_writeback;
> >>  struct bio;
> >> +struct cachestat_range;
> >> +struct cachestat;
> >>  struct io_comp_batch;
> >>  struct fiemap_extent_info;
> >>  struct kiocb;
> >> @@ -1963,6 +1965,8 @@ struct file_operations {
> >>                                 struct file *file_out, loff_t pos_out,
> >>                                 loff_t len, unsigned int remap_flags);
> >>      int (*fadvise)(struct file *, loff_t, loff_t, int);
> >> +    int (*cachestat)(struct file *file, struct cachestat_range *csr,
> >> +                     struct cachestat *cs);
> >
> > I suppose you can't just have it return the real file because of the
> > with_ovl_creds() scope you need during access?
>
> Yes, AFAIU in overlay when we use realfile we should always use it
> with_ovl_creds(), even though I don't think there is anything cred relate=
d
> in filemap_cachestat(), I still think we should follow the common pattern
> other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).
>
> note: Actually some places get ovl_real_file() and use it without
> with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_read,
> ovl_splice_write. But those look more of an exception than the general
> rule. All other instances use with_ovl_creds().

Use with_ovl_creds() is a good practice to keep the mental security model,
but it is useless if the security check (can_do_cachestat) is not in the
vfs helper (vfs_cachestat), so please move it there.

Also it kind of makes more sense to check (flags !=3D 0) in sys_cachestats
before checking permissions.

>
> Also there are simingly no other file_operations which return "realfile"
> for further processing, mostly the operation from fsops simply replaces
> general operation with its own logic completely.
>
> Thanks for your review!
>
> ps: Hope overlay maintainers will correctly if I'm getting this wrong.
>

I don't think this is wrong per-se, except for can_do_cachestat().

Just be aware that the real file could change from one cachestat
call to the next (i.e. due to copy up).

Thanks,
Amir.

