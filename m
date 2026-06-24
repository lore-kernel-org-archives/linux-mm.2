Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F36CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356166B008C; Wed, 24 Jun 2026 10:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307966B0092; Wed, 24 Jun 2026 10:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7206B0093; Wed, 24 Jun 2026 10:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E71256B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:12:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60F921C0C7A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:12:00 +0000 (UTC)
X-FDA: 84914995200.16.D679B00
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 57F641C0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:11:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m9z3Fw1Z;
	spf=pass (imf21.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782310318;
	b=fYzmor1X6R++rSlvnkoOP2uo+ZIsQA3zW+nJrXz37ilv7S5bX76zXZyHTE5LMKYU5i52SD
	7nU/9/a0jJ9JbZrGqzbURViOPphYPDybQvaq1Agg610sC5tOSFipuNqroAkfiRrhI+9wmO
	tlmXS9NncCgkFGQVh2WryCMGFg50Zpg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LG+grWd6UceBYXX1nWiBnDgEaC9++nTof5X97YF4TKI=;
	b=SeOGghKaV10NR9tRX/VkTM0hKz14ofq3mqMkEUBpPDTMeCf0Ei/yfZp46npe2l8jb/9LAM
	YJh3jkgdX8Lyx5OQC7dxcmq3kLMuHfYT7BhbhX0R98SyuSaSUhGcKJnlC9klKOz0OLOLQW
	PA1f/6b4L2LsRN4W8KFdZ2EF26VZWNc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m9z3Fw1Z;
	spf=pass (imf21.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-697ce8cfe65so1811626a12.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:11:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782310317; cv=none;
        d=google.com; s=arc-20240605;
        b=GeVnK1B0Za2nZlALbwFMH8CrKtR9pfx4MafzI6ZYYinKbyzYg83vSeBZ9ABoEk0u+i
         fXYS/cny6VaNbOmlkUGsmLOPajpp79qoIs9gGppRBevYZGDiEbphnZ12WXCFVL9inJcS
         xRx7t33OTzl7rfgS6nQsnEiCUx8zhHvwJGylx1jKYs2porn+8uWWXFpSPAjrafH3fnN/
         FAaXpEK4kE2/duzsVniU8kU/KpES3rkqdEF+NflM3qhN7/uvPP4xJcrsLq6WMmKTHYgV
         6dB0R5DzVjN015zsm1zmOHoUUkMKRWys2u6hecLz4Xw2g25qZSpM1BwQ/Y7QWBL1F+TZ
         J6RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LG+grWd6UceBYXX1nWiBnDgEaC9++nTof5X97YF4TKI=;
        fh=iqbNv5LS6Z7z8sqqmm1YRGKZ3XVCllHaqSHXiToo5dQ=;
        b=CHIm2VKZHxs/J2oaegYFBhXfLoXCm/L0gp0SzQNK/Do8d7fE8pVYIq3Fs/gIlPRt5x
         Iddd9r/0iYtfOSYGxSni89OArGhoY5blpb9LXLTy06GNv7b3crj7YSmsju90Po1VbzGg
         Yf25qQGMCBg13RVTiQvUUTOYdyf5rzVQ1PavQnmugWXu7D+fgqOWbOWllz7/8Db+qrJg
         etoT7EUxElLhwS8lIURqvErqZszibC/m05nQxQuzwTl3q1ewKgjZGlRCUqCbCWAeQaxe
         AViSyPLd24Lu6iF/e7zI77BjJo4WifOGBNe4a908+fzBsAsdRTKH+zUttLF9xnHxssJ8
         IsQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782310317; x=1782915117; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LG+grWd6UceBYXX1nWiBnDgEaC9++nTof5X97YF4TKI=;
        b=m9z3Fw1ZXpPXo7n2rzY+/zP3WhOTFYRcEf/hC0gisb8sXIXg9PO/ddphwnHN5YodhG
         HVMk13DhM4aekaVbiioA7y1XQkbWyabZXfD93WeFpf0UHKvpAlmuIxrGnX9NjTi8kIhp
         sZNhOx3EsdA1EwC63eZz6Y/nvuad5C8a8Hqg+TTjWCmsOW6t+xzxu0Szxp1/DLzL+VAD
         BKjoUuNE9owrxicG+7IFupKp2i5oMUazPnInqUZXs7nTIZVbQ7l+fUyFBGB0CXq/vhml
         m4M2fWaANPmp8dICBAlLDpMcXBZUz7TAknPkbOfV+duoCZPEfGE/4y3GwxhsQp/zEGqE
         hmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782310317; x=1782915117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LG+grWd6UceBYXX1nWiBnDgEaC9++nTof5X97YF4TKI=;
        b=rh2+n2hsj+es2WQGTtnLC/GyCLaRDMtNLIDIIm+gBJAa7NwuEmz2i/lvywocb1WfqK
         zZAKSl0xSX8EMmpP2NfWtoXgu8PGk3IgcijURZs+mizxmCX14WOv+3kob8y9nNx8hjZH
         ROvmPQpolPN2AsAHCKpcbrM2POd3/hdPp2WaP/VLs73BEnnqtKoR1+8vAyyiHMhSWsvE
         q9bdeEfT84pKd8/MgiWiCNouLKa7rzcGaZaQSqcjDNM7k0bYuGkXy/qZ1hxVGl5qf0lx
         wrA7zTx/WcIT+92h0wTJ9hpHLCkGbUUR8RTly33dnatet4F6mwoo8lEojDSpQ7vy4aIe
         B8jQ==
X-Forwarded-Encrypted: i=1; AHgh+RoW6y73qkfYzEkSj2Qfckn30e3EVHetqhjUsjQcrMhcIol6d+P/aW7TdXH+VXqyLxZCJYKTAnXATw==@kvack.org
X-Gm-Message-State: AOJu0YynyP7ARrsgiZqeP7RRN/NX6C8DoJB4dfopm//RyrAzf8fuBapc
	JgKJg+EFsRTUW6s0cnHEs8F7isi3wjV8/Nz0VSk3m0MqphoswO5h2qqZ6BQesCTF2+cmIol8ip+
	8bjdScOYsC1g87eGd2GJw5dMBInGpAnI=
X-Gm-Gg: AfdE7clZdW4XZTWISnZhcSXM9U1fOYXGd9SkV8aIcDvBQ8LcrQ8fQTUg9ItNrWsMFNu
	s7CvH2ZZ2VAX5lBQIri43LRuJ0vRJ4zvswrmdGRcPUyJpSfTOmpHJxGJg580oHeXJjHflGB+C0h
	xsSbFEal5HehANAxB/qLQBn+P5D6hkLg2NXNksrhgFNa7yj0SEQPylR0V4o2l8THOH1FVsgKr53
	+B8OmKnBXmXnhDOgDY3qzOOL7umuIwNL4I0/13YbLEiVRMmsSMydy+VugnGrPCN1n8BDjM2t8fl
	KOplHTyo4YQGP3AsHuTDdr6NiTYnLU4=
X-Received: by 2002:a05:6402:4310:b0:68c:4424:a08d with SMTP id
 4fb4d7f45d1cf-697f37711abmr1918540a12.2.1782310316342; Wed, 24 Jun 2026
 07:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com> <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com> <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
 <5c7e8c24-0981-4677-aa42-9a74b67bac04@virtuozzo.com>
In-Reply-To: <5c7e8c24-0981-4677-aa42-9a74b67bac04@virtuozzo.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Jun 2026 16:11:45 +0200
X-Gm-Features: AVVi8CedTisCQc6-w-aWZxlaYwfyFEiId3iuvNUGWT5KiajuyJpqODeKptPkY48
Message-ID: <CAOQ4uxjoq7VGQ+XHi9TT-Hak-tqiudoG7nRJTsFenbNtZRmvcw@mail.gmail.com>
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
X-Stat-Signature: 15k6b6zjaozpord8ybsidwm9kjraapqc
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57F641C0005
X-HE-Tag: 1782310318-69454
X-HE-Meta: U2FsdGVkX19PoKXk/gbiQsIO69HpWFlC9R7dLsqqHQ4WRL9p4A2H270Vvtzt7MRrJ0gVKOcdF9ABtFBIXt1Gf43c5zOqKJhYIa4NZvvAB9A/I1iX1Rh3jqM5MEfyMMjxnrqXyAZIM+uh6eu0jL8uauCQf3+4NV2lQYqcT8suje7iv5AKYLiMfxTZfjjlvUJxUdhFn0GftPV3+DF8G2ofIMb7Z6rP9Hyv4t0yFQlMCw8MiNmcgqE/ZARRvXB9fS2rN3tM7C1rh5/4c0P86pc0EQRkHk5u9beSQHv8HFF4R6eP5oVRmeXfxFNDfk4crCXozC4aH171hGDLeUYRAl9Fu5zpbRB7ejOfpvIDxF+QXPpRAIYYcgH79SI/vwMOgsfsb5wSzdZjU49DzkXGHbEP29cauFDIsj5b0XZXXuYgUr1tPMtf4B+PbqXYKQVEEB7rPdN9qWPsbzztm5F5pxOC4N5lvwASaFXxIdoaza39h09BtVanlG1C6YwjjniGgLUQyKelBonGjsVCckXzCfkQW1XHCFUb91/YRgqty//oPdO1EvBtfTshIUe9RAN/sXm5lIyickmZQ0xv4CrehzdG11dxDbd4uvD0kT5bX3gPbHt+ehiVxn4Z0MGfAKWpinshDpa94afTbfYW3VVZiAP/VrKOFlz5L+F1dJyZ4gj9Nj51VYqs+grghtyxONhEGn/n/KIHJMlkvKD1hprN5alsj9UoSoF4hiIdgJUM86lEdE4+Xcy7ketcP9b5SaLcLsHYh0GDgPRimn/HlCUw2mZNesek2Xi8Iub+VoL9eGMuL36aUxWUiKdukGmhMK9vUkYY1WAMZ3WXoN3Ozs8PB/t7kV2Fut2Uxb1/awIobTyjtbrNMkCdiyNSDO4ENBZ0n3e3+1LgIABeX4C07Jxf0zz0L7d8sR8HqBRZLyUcMBe8VFDhvpFfhh4tcMi082fqZdRer5o7uIuQBwZqtjk4Js6
 Qb6o6cJO
 X0HBLlFIN+Yi5ppYZPmdqSBDGSe65Ww/soeVsCAK3xADXCJ6hXoJaI3q8dFQUK01Dw88AbN7XZHld/Qk9CXC+mcpP6I5Wzi6FcFLJztWQ11Sh/AEh8B1DzXQbVdr5AqR6K7KJabKWoQF3mVNm6fO8YDjmTBpEmdJ1plzd6hi7c/M58fCgeSG3zHWwrLAAc+xNZFKsPYh3DdN2zp3keWAbFO89koVe4EG9fTjBtoVXwTrDBUlHvR3b2fdQyf7Q38OZ8DKNGtH6+woKpbPoLND36TR3jd0F3vTdfmQaW5Zi998MMjhCGqbf/ep7YeeDA4hDWsKrEEe0PCu+W6lCSzAbwIp8B6L25lZNeQP4krPuE1SK+y965AUxYFr3fOdVRqpb0rkkfJ+mTgx9zQD01wlJwH9z/vatOmVpJ1/iwUpTNqXdAK7wNrI1IvppHkC0H7tkpQ/rqW6mngYIvnCdqPs4VVRQqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 1:59=E2=80=AFPM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
>
>
> On 6/23/26 17:34, Amir Goldstein wrote:
> > On Tue, Jun 23, 2026 at 4:55=E2=80=AFPM Pavel Tikhomirov
> > <ptikhomirov@virtuozzo.com> wrote:
> >>
> >>
> >>
> >> On 6/23/26 15:48, Johannes Weiner wrote:
> >>> On Tue, Jun 23, 2026 at 01:14:48PM +0200, Pavel Tikhomirov wrote:
> >>>> The cachestat() syscall reads page cache statistics straight from th=
e
> >>>> file's f_mapping. Stackable filesystems such as overlayfs keep the d=
ata
> >>>> pages in an underlying inode's mapping rather than in the overlay
> >>>> inode's, so cachestat() reports all zeroes for them.
> >>>>
> >>>> Add a ->cachestat() file operation and route the syscall through a n=
ew
> >>>> vfs_cachestat() helper that calls it when present, falling back to
> >>>> file's f_mapping otherwise. This lets stackable filesystems forward =
the
> >>>> query to the file that actually owns the page cache. No behaviour ch=
ange
> >>>> for regular files.
> >>>>
> >>>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> >>>> ---
> >>>> Note: Memset change might be a bit tricky, I moved it to no
> >>>> ->cachestat() path to avoid multiple memset on nested overlayfs, tha=
t
> >>>> means that ->cachestat() is expected to be able to handle unitialize=
d
> >>>> cs.
> >>>> ---
> >>>>  include/linux/fs.h | 10 ++++++++++
> >>>>  mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
> >>>>  2 files changed, 45 insertions(+), 8 deletions(-)
> >>>>
> >>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
> >>>> index 6da44573ce450..966b6564707e4 100644
> >>>> --- a/include/linux/fs.h
> >>>> +++ b/include/linux/fs.h
> >>>> @@ -53,6 +53,8 @@
> >>>>
> >>>>  struct bdi_writeback;
> >>>>  struct bio;
> >>>> +struct cachestat_range;
> >>>> +struct cachestat;
> >>>>  struct io_comp_batch;
> >>>>  struct fiemap_extent_info;
> >>>>  struct kiocb;
> >>>> @@ -1963,6 +1965,8 @@ struct file_operations {
> >>>>                                 struct file *file_out, loff_t pos_ou=
t,
> >>>>                                 loff_t len, unsigned int remap_flags=
);
> >>>>      int (*fadvise)(struct file *, loff_t, loff_t, int);
> >>>> +    int (*cachestat)(struct file *file, struct cachestat_range *csr=
,
> >>>> +                     struct cachestat *cs);
> >>>
> >>> I suppose you can't just have it return the real file because of the
> >>> with_ovl_creds() scope you need during access?
> >>
> >> Yes, AFAIU in overlay when we use realfile we should always use it
> >> with_ovl_creds(), even though I don't think there is anything cred rel=
ated
> >> in filemap_cachestat(), I still think we should follow the common patt=
ern
> >> other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).
> >>
> >> note: Actually some places get ovl_real_file() and use it without
> >> with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_read=
,
> >> ovl_splice_write. But those look more of an exception than the general
> >> rule. All other instances use with_ovl_creds().
> >
> > Use with_ovl_creds() is a good practice to keep the mental security mod=
el,
> > but it is useless if the security check (can_do_cachestat) is not in th=
e
> > vfs helper (vfs_cachestat), so please move it there.
>
> Totally, I feel stupid now that I missed it originally, will move it in v=
2.
>
> >
> > Also it kind of makes more sense to check (flags !=3D 0) in sys_cachest=
ats
> > before checking permissions.
> >
> >>
> >> Also there are simingly no other file_operations which return "realfil=
e"
> >> for further processing, mostly the operation from fsops simply replace=
s
> >> general operation with its own logic completely.
> >>
> >> Thanks for your review!
> >>
> >> ps: Hope overlay maintainers will correctly if I'm getting this wrong.
> >>
> >
> > I don't think this is wrong per-se, except for can_do_cachestat().
> >
> > Just be aware that the real file could change from one cachestat
> > call to the next (i.e. due to copy up).
>
> I guess the copy-up between two cachestat calls is an equivalent of cache=
 pages
> being dropped/reclaimed between the calls, right?

I guess so.

> (I assume old pages will not be used anymore and will be reclaimed in due=
 time.)

TBH as long as this overlayfs fd is kept open both real lower
and real upper (post copy up) files are kept open, but the lower
pages will not be accessed by overlayfs
expect for the case ofMAP_SHARED mmap
if this overlayfs file was mmaped before copy up, the
lower inode pages will remain mapped to process address space
and then cachestat will return stats which are disassociated from the
pages accessed by mmap.

This is documented in the `Non-standard behavior` section of overlayfs.rst
and not a specific issue to cachestat. Just wanted to be aware of this.

> So userspace should not be
> overly confused by such a cache usage change.
>

Agree.

Thanks,
Amir.

