Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB74D606A326
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 19:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lI4aM+kX
Received: by kanga.kvack.org (Postfix)
	id 051C26B05B2; Fri, 30 Oct 2026 15:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D0D6B05B3; Fri, 30 Oct 2026 15:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04DE6B05B4; Fri, 30 Oct 2026 15:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B86466B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:53:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 509DF1C40F6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:53:03 +0000 (UTC)
X-FDA: 85380341046.01.E05ACD6
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3AC8940009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:53:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=lI4aM+kX;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of luto@amacapital.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793389981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+BdM9WeGKtKZaWhqQx0TQqxdfo0Oqgz9BExV/rtU8c=;
	b=b15fhxeyM5VHtj5DfQZg7tex2Oc/pyc7eq3Dap/dgs9dG0IVGSXN2nJI0T75qFk+koZ8j/
	0HOSGD93hJhEAHAq6dIQwKX0WiHWCjeVOlYyhGI98rtBWxqJDMBdqAVBHCMzH9lKQIfn3D
	tWkK7vXaH4LyeOWz7xolSj1cgd0DWpg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=lI4aM+kX;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of luto@amacapital.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793389981;
	b=h1a/xruFqeR0iW0EKiyWWB2OvdB+nea1YhuSrSg5jKYPUzaK1JA1Knh9YLZNpHRn/FoZri
	3+xqgO8xJxZMELOAdQoQ29y76LCF3IBK+9dujtFlp+rUd8futsP/avxLQaEdwKv4FyI41A
	4nipLVDEo4xk8FML2dCpNAVCjU6RSDk=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5363316fa0cso12754391cf.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:53:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793389980; cv=none;
        d=google.com; s=arc-20260327;
        b=NTL0tfWB2+VdESI2dBerAzU+pefSdYOF/CrAY3PG/eN/U1/P3WXR+RcABjWOAxGyvW
         IMZ4VC7IHa5euIS6xptlfDhcFgrYcfLmC1UPYyc5+M+vraKG7pazpgzotmZ8NDWjAYcd
         jssoTrJflgGv9ys+rQtKz+JE2hKNzi4h0DyIDrFKplBU1ceBrbXtXaOx2MU5hm7h9+mn
         OR0i677y1tQhV/03QEhGiYfAImYP1u3GoQFVxs+COAYrE/5UVHOvCFEt/00WpYtYOmCj
         50bpFleYfJdzF2q6X8BNKIuWuDwMskq2rtfyUOh22x4Cr++5Hy8rIpnD625f1HtLHY0W
         3hHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M+BdM9WeGKtKZaWhqQx0TQqxdfo0Oqgz9BExV/rtU8c=;
        fh=eq0h6/qjncdmIet6+ttX8O5o/SNoU2PPmIeJePyRFjw=;
        b=rcZLcVd8GRAS20BqxJsl2LpTr32m/5EKmw1M4BaL7+cFPB1wGrQ4S2XPBiatb+K77e
         //u97szPeFzZmra9WAtr09uh70f0vhMle/aVenyluRdOILS7UJ6mMx63WiMKwJlbUSX6
         mOkg8pD4q7b/PoyL+L0H4uygw/8HH+yLCXU0FQ8ozpHIyxdvkct4trMoLODOoHr5V7PN
         NEfYrWuaY7bBGT5rfa2EToHYFJOUAjyICIVi+GG3u0XfRwj2v9bQBQGR/zqjEPkOFSzD
         Mbr0smQAvlHBp7F6bj/mB6vp60V/G660wFd5Awt/8XPLff/fn638ZqCoGE8E1ssBh/+G
         5loQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793389980; x=1793994780; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M+BdM9WeGKtKZaWhqQx0TQqxdfo0Oqgz9BExV/rtU8c=;
        b=lI4aM+kXRB/hX2UI59EPNEgv7QW+lEA1dk0X3/+0PnFiMMwF38tRBSMHymDEvZ3OH4
         BYBX3/qZHO58Em47oGbNpxwZ6TxzL8TbXPGNmckNucm7r60cTStU2nJTy8Qt6qav9Uc/
         jOSvUps1AIp3mZbFRm5yDOGJNeL1FvcxA24/2NsV/jlOAM8G9Phwx5lb4x/be+LG8S6P
         gvi/wd35lC2qs8wROdDDpzSfzWV9R9rmbhv6bEZ85MllCKF39b5/+oBT5EuCM2UA2Uh/
         vklyAaj4rjMdweNFWDCBic/DrgUPeWzm+ZbdFXHKT+tTnioerDjXyg3w3BGxYULTZsAw
         D4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793389980; x=1793994780;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M+BdM9WeGKtKZaWhqQx0TQqxdfo0Oqgz9BExV/rtU8c=;
        b=2Cd2gLKtARunvlKMigeuKb+qQRa99oICYJlTotePByUVY4tbhfE8t0/Bn+2J2EbGBx
         GdrO0dAFHizAr8yZRlTH4078qNPRaSA+7bOeHM7dU6eb0EP/Yz6q522cEKxh3zbQIdpA
         N6mCRL1OazFeIaDPnXBiNyb5n1NqtZ+7vTiMhrjYkcYskskLDLHB3XJoPg7b8FzQkLv0
         DJkrDdf3Z7kWoAvewaAi3H3eB4BUzMhB9ytEoby1oKbCKYkJ9Ufgb7d+/+HW7lWe84n/
         87yD3qeRCK4KFV7fe1MYDIx1Revvs+uRaudNKjPOIfb6O5UGazhCcCfjGpD0Gql9ouSF
         /Qcw==
X-Forwarded-Encrypted: i=1; AKwUvBxiWB+52eN+9mJHMgE/SkW5djmUV+1F7U1aR+pKl0W1/ajlR9C/MPKzfmYMDtTotR2HNPtBzfwITA==@kvack.org
X-Gm-Message-State: AFq9FYKT0jRqv5N9vbyv+ZFzEe1soXMAcoXyXhSahmUrRnS7om4CnWb2
	pQEwMx75BIjYgI6K259aHBDlSO1+4OP32vfb3k8f01LnffWWkv1aRxtOi8xfzJ7voPimhWNKNii
	l58/sDKI6MXflo54K5ab9P3W5ISUzDxiA3kzj76sI
X-Gm-Gg: AYBFou1wt5sL35XPVYO96j1q3RJn8G/+fIClshh/oSf8bJgr9kkuyDByRgSqdKy20+m
	1gJBHdakM4h+BD4WwAk38gNi8cIaW6xSdG1cbqluWrfQbsHhT7686qCqs+EQo+Lb2fhPEsXEQsb
	Ea3wIfXE6XRvjIYjwV8wbhM9cRcCE9gZFCE0nwpPfg9ugxaWi2Fr4zKJyYpBeQ1e5JLr/PF0MC0
	Fvx9szPsemiWlbTCHLhqTuOLyJuCUjRiyB9irJKBSBEs4nz5uUdWseckzNnldHbaelPqep9gm6C
	E/DWzzWB40ClH5xCx6ERY0TC9RhMp+k8dACEMLxD5a4x2Bai/Lm5KxlDqhzR3scTbmuGIP3HlQw
	oB2iLvNvH9JyaKduvrg+QexDjJLEIjY9/A4AqGNc0cg6lH0sbdr8Pp+Q=
X-Received: by 2002:a05:622a:34e:b0:536:43d6:2a94 with SMTP id
 d75a77b69052e-542b7145036mr51380891cf.34.1793389980143; Fri, 30 Oct 2026
 12:53:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com> <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com> <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
 <auPKfqh_YjRU9Ui3@google.com> <CALCETrUEyfvaEGxMHo=c0ia3CDgSxg-YW0_=Z7T31Ou+pvicuQ@mail.gmail.com>
 <CALCETrVpEP=HxVqdSP_AgA=U7ignwAgjz5Vi9+Z9dZsX5DXeLw@mail.gmail.com>
 <20261030121259.GC3889730@ziepe.ca> <CALCETrW6RUgTGFuqx+cxV0c+Oq4d-P5C8AQ2ja0ESMP_8JGpxg@mail.gmail.com>
In-Reply-To: <CALCETrW6RUgTGFuqx+cxV0c+Oq4d-P5C8AQ2ja0ESMP_8JGpxg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 Oct 2026 12:52:45 -0700
X-Gm-Features: AclHuK9sB5PkTPxFH6Td3Meg7Fy9jFpGf4zpslN407GFn3D8So9__FrNUMzsHq0
Message-ID: <CALCETrUGa4zE3Zx+5Dw_UYEFgMmgDYQUeCxvPKv_-u56hQ1W7A@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3AC8940009
X-Stat-Signature: peijxr948z9ahoi1wuyin346ginkjw55
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793389981-377660
X-HE-Meta: U2FsdGVkX18s38eIkKRBONC15yrqu7117Lex4aY3P/6tpNWyq2KFR+KNEJLkvdJbGR6iLKfE8TBbDa5/3l4JJivFpEH+dcBD7fxwzW0U8boxRFj6vqxknh08qc5EczGMJv4pNN4fmAN4599Do+TNStVdzgZSeRo15ZBgRFVtP/JC5LUDBt7yZ4euxdk7h7BP6U8IbApywEeAA39rEaOwfPNeeicIVaiK7BlgxXbU/em4WP0zkl+VQtAq7dYrN2iNRxuwzvTa49J3/wUMFMDYBRDPji2oFah8VfoeiWVfRkh74nMtPeGFYT6+68EwfMJ7aR0EmkJrEXqWh2HJX0ua/9vIZ01w54IljLxShxV6o8DEOxzdJvuB2+xDPUVU88caH51xLLXQRimzaa5WSkzXpzwhPHgx7kEm/F3tDZ01npry4HTaxEoGb2YMDX7+liJvnakeexS/ZlpPkvrt5o3mNIv2mdBErfYcEtcH6SopYFL+OF7ELNmjY/1YfDsq0yG0GPhowEX1GNbii9rDZW6iGWg7DM3ez8SZRllLJ0QYQPzWGQrkU+IhRo/jDN61DFJ9FVqI+JSJf5GXW9RTq2Bm2E3XZPlVq2pvu2eKT62G+0atTYl+di/gnYCaJdnz2Rh+b2Kr//D3hXwDTcF+GsvckTBxJhiNVNLmUwBNMNblyIN3HZEmLmZqWWj2olMlLUDlRQq+PUiFpU2yPvPAFk+1vLaeSYGGx5UoQJwiXZ1WwguZbjBk1SwsJo76yYQwdSt7V5WfOJoRT/KEQ01EJG667GZkiQp+bEE01pmWvuWdMSc+zc3dm1nQeWcw5tIDwXiZYE84UunXqhjs+EAMCRsZWfDoVKnTeLJl6+RUuNNyue40dha4g2OG14XEBqLxifyqO96EtybAkwZfFeK9JhniPLakL2vqKqnhttClTQJrkeHJL3v4FDuAhyVdU8WDejGuu6FUPNxy6Ysik49j0o1
 Y4X9PIxi
 7TinQ2hsb4vpkkFLyx0vRm8RxrzyLfnFC5PP9pM3LDDQBRBot6wGlNzLlfsGsMBWUjABv+ASK/Cv0YUQKz/q4YPHH+i0M7wgMF1c0t6A6Mg06CtXZCHPr1b9znUMB+GFC+uMplw2ZkFeg7NCqYy1Tg+6FZVs9CUqoa3tExc5LyM/vq2JJ7mVwcd5vEDsyiyAr7Pqbv4GYMFk8nJuzIskj+hS4wDYKApYBMl0/a2SBhFWThsmCiijWSHMp73k90RQ2k3VIyeDOUWjTBoD/bRYu50LLVQFJBrS1f75KkzFZHfnj2LjWvy1Oilt1zhqj/ZadfAwRYOMGCqPnLqxrj90EcwGgBwG4lYlKBUKppRyJBH3EMSbfKUelSoRrbLYshOFda6ugVF+K8c14MWZobo65C11HmXtruKfPWmaNE8XtbgeuTULpxJfZ4eZ3TA0jWvt/9wXITIvr6Ys/ZG9E+aZ3A7MVDTkJV0foAhi4IsZAcomil+pgUppE38CD4g+97HIa3BBOljJ4ITu73UDqalcfNYDGA2dt8LmRDkw65/bJ/nsaWVZ1fuFdhAPl58WvyWFVOYQ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 7:54=E2=80=AFAM Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>
> On Fri, Oct 30, 2026 at 5:13=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wr=
ote:
> >
> > On Thu, Oct 29, 2026 at 07:11:25PM -0700, Andy Lutomirski wrote:
> >
> > > I can't shake the feeling that the problem here isn't so much that KH=
O
> > > + iommofd doesn't like this but that the behavior in question is
> > > nonsensical.
> >
> > It has been this way for ages, like David says if userspace shoot
> > itself in the foot it should not be surprised by this illogical
> > behavior..
> >
>
> I dunno, a couple weeks ago I tracked down a 20+-year-old bug, and now
> it's fixed :)
>
> > You can get the same nonsenscial thing with just mmap too, you don't
> > even need a memfd.
>
> I feel like there are multiple levels of footgun here.
>
> mmap anonymous (or MAP_PRIVATE), pin the pages, munmap: okay, mmap
> creates unnamed private memory, and munmapping is maybe like unlinking
> a file -- if someone else is still accessing it, it's still there.  In
> fact, you can mmap, fork, unmap, then mmap in the same location, and
> your child process still sees the original memory.  It's not clear to
> me that anything is wrong.
>
> mmap anonymous, pin, MADV_DONTNEED: okay, this one is starting to be a
> small footgun.  But at least it's pointed at *your own feet* (unless
> you've forked, which in which case maybe it's pointed at a related
> process' feet).  I would still argue that the kernel could notice that
> it's false that I "DON'T NEED" the memory and fail or ignore the
> request.  And the kernel's pages are still anonymous.
>
> mmap a named file or memfd, pin, truncate or punch hole: who says the
> footgun is even pointed at my own feet?  If I mmap a named file,
> SCM_RIGHTS it to you, and you mmap it too, and then I punch a hole,
> the rmap machinery had better invalidate your mapping along with mine
> (and get the TLB flush right!), and it would be an unambiguous and
> severe bug if this didn't happen correctly.  After all, what you have
> done is to assign a *logical range* within the file an address in your
> address space, and nothing I do should change that fact (except,
> sadly, truncate, which can give you a SIGBUS, but your vma still
> logically refers to the file).
>
> So why is the kernel exempt from keeping its own mappings coherent the
> way it keeps user mappings coherent?
>
> What if that memfd (or tmpfs file or whatever) is shared between
> multiple processes that don't trust each other?  One of them can cause
> it to become incoherent from the perspective of the other one's use of
> kernel APIs.
>
>

I'm contemplating what would be involved in fixing this for real.

First, there's a scary code path in shmem_replace_folio.  AFAICT
memfd_pin_folio() can race with swapout, so a pinned folio can be in
swap cache (obviously we won't *free* the folio if we do this).    If
we then decide to replace the folio when we swap it back in,
shmem_replace_folio() will not notice the pin and we become incoherent
and no one needs to hole-punch the file for this to happen.
Fortunately I haven't spotted a reason that shmem_should_replace_folio
would return true in a case where we care, but if someone does what
the comment suggests and makes it start respecting cpuset or NUMA
policy, this could easily change.

Other than that, I think that hole punch could be made to be fully
safe in one of a couple of not-horribly-invasive ways:

Choice A: Make hole punch work like migration.  Unmap from page
tables, do folio_ref_freeze(), and tolerate failure -- either just
abort the hole punch operation or zero the contents instead of
punching it out.  (And contemplate whether this could be made slightly
more permissive by tolerating a swap entry that still has a live folio
if the live folio has the expected number of references.)

Choice B: In addition to tracking references, mappings, and pins of a
folio, also track a new type of reference that keeps the folio from
dissociating with its mapping or changing its address within the
mapping.  Most code that pins a folio would be changed to take one of
these fancy new pins -- the main thing I'm thinking of that wouldn't
need to is writeback or perhaps non-long-term pins that are just
reading the contents.

Choice C: like B but instead of deciding per caller, treat exactly
paths that take long term pins as also pinning the folio into the
mapping.

For B and C, a big open question would be how this interacts with
truncate.  I think the idea behavior is that a mapping-pinned folio
that's past the end of a file would remain and if the file gets
extended then that folio would represent the portion of the file that
it covers again.

--=20
Andy Lutomirski
AMA Capital Management, LLC

