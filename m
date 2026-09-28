Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF9DCA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C71E6B008C; Mon, 28 Sep 2026 11:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39EC36B0095; Mon, 28 Sep 2026 11:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DDB6B009E; Mon, 28 Sep 2026 11:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F29336B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:16:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98BC61A023A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:16:34 +0000 (UTC)
X-FDA: 85263522708.01.17F8F40
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id A31FD120017
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:16:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i+V4+AFk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqIv1Sn/rDlr9SusC1OyVWgmKaxOZca4hJRLhV2M9zg=;
	b=syuGbb7RUJ43Q7/CdqW0uFEhYuW+e+8hcKXcAGyBJww0gctdx3L/VUIqP6r8MgHMsNThAS
	3mAw4USCfBicKRiZlQmLPRnE4qnCMg+jwx85qVPn4YWid1gkop3EjJ0iYSodGz7/IUcgEk
	T+EqlhhVWPD4IPq7FJA6VFoMYZeB5AY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i+V4+AFk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790608592;
	b=wdTbnq/5dGCaUnAfBF5CuPFqRzXYegM8Y/awjiE/rNKv6OtPfvvj75HKLJAu1HrKslnJJE
	It8Z7IpONMXo3VGgJaeB5NfCqsx+uGhPOv6hi1J12vCd3fhIzHfisUtBj2K6hs8WUe/jPC
	Iw8MHqNeRHtJaclokVXvguL9EaVlLu4=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-53328262efbso387021cf.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:16:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790608592; cv=none;
        d=google.com; s=arc-20260327;
        b=cM+T81esnxoWjOJpCnz12lP3AEmtKfRcnV86Y8NXLP0AOqQjjtuQP4V2DN92a6mhWI
         kvA9RM1b5hk/t/rB3IzHPhUVHrpKyfCiO4uaVMUgzstjAGb+zNLhNmt9pNw+HaV5+Goa
         lqq+dFKlaYIMhp2rvHb9xKKaGy6AFi5nUS43sTqc+gjUWwFGEJwY66VbJBFhVRUc65pK
         rRCXMsUgwYx6wrIXhZ6E5jKniIB1QWV1K/+g1rfR8hdBi/phPxLjxOIQMOsbyaMyAaQA
         rvNH3mpUFxCA1kRUFYgPlffMXir84vFxEc1U3sWZ+gIt1sMI6H/xRNtCbZbq5mv1Ng64
         +fxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZqIv1Sn/rDlr9SusC1OyVWgmKaxOZca4hJRLhV2M9zg=;
        fh=dvBX5Y/HdXHHFai5ibjn5DYoPx+QA5BcU8vm3UoXI7A=;
        b=ZWQdgOLANF6H52A4eaNWcr7GK8y1IAmaTpsbANv/fwj1Gz0TTm8DSF+bnkaxJDllHy
         182HDAZdi/6uouW6sMYseVHfGr0Wm2g34YpnoN+ra5Qy1Mk5XuKFaBVLjDMjyMOqPXxZ
         c2W/jj3yORGIF4GRpdMzCGtKqY3WlLjKeJNpebCUQGpD6+9kFox2sQ265WCczZ8qJm84
         ptosumuCgJb+QJpcAWT+94hpCW5XSu/DvCzUk+PMQBqeeIcSUVwlLJPfNRpFuWDvFKSB
         d7lk2Ka9ihsbm1DGDGijUkzTtHxNt5t4jvh+wiI4/kkZT5gQFW86OElp0U6q+kf5LqUj
         Pfcw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790608592; x=1791213392; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZqIv1Sn/rDlr9SusC1OyVWgmKaxOZca4hJRLhV2M9zg=;
        b=i+V4+AFk2Z5cYnZ03VuTaNNybYQ5lj7mFyuSHsOXtFmzQnn1kPqAc4B38Q005KPCRh
         cnPN3vQsb154Vl7CuIet4pU7d6EQlX2jmkrdK7fwJ0qSrtYdIcOD9Erd08FFMOjaAaSm
         HZT+FB5SZts1RwAxVpDW6ePmQpMMtHXn7dEAil6QVnH7jGdbIJrS6rsj+9Xm8zATLezi
         x28JLZBO+s5shL/TeF6GHrdynggOfhzhprfJ04sDx1lfmbdEJSIFlxWR++jKRx92sN7S
         7mDC5Xc+L/HGaLo9EsNRTlqP7bM59Df3B52vm9XKP7gioQD91KsAQwSILDC/1nOnQabn
         Fj4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608592; x=1791213392;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZqIv1Sn/rDlr9SusC1OyVWgmKaxOZca4hJRLhV2M9zg=;
        b=QBjb4fe8BPZuOBKEq/zGV7HKkBq+9HQlJdfokB2Lwp31XwzZX9fmE4K+HlLgCuSJEI
         Tu3EQGvYSM8/Nuvs2zVhT3tu506oefqoGbusgeTJE6x2eWp1gqxjldcPYb/839CEA30s
         lOEJE0n5yRmrBvPxYNzD2CVuBqwu+BRZ/gEUsasx8Uqkxv+kKGrEtRH2dE5c+z5BYJTk
         wCQKaUYuzFdSlUnhDd8FAVl1BtYBeNNMlyrGyecVU1lXlPVia0pt9M1AG/QJphrsz131
         zHiLp8dZmcVYM6aenYZNGfBvLjWNXi9n/pil/wU3SyZc2GYPMpbSL9OqTjRtqpXAtQGt
         deOw==
X-Forwarded-Encrypted: i=1; AKwUvBxbWGCzxGItN2yarFd6yQqQWALgHrdLnohyPFNb604VlGTJpSLyFkTNK/7fLTYN6pUtaEhBH33LQw==@kvack.org
X-Gm-Message-State: AFuF++nMs+a6qa91ngpP+0hJH8GzQCAh52Y7AojbI0xJhrCy67koGq75
	/wJGac6ceBTHv671n+/0V7L4+gNRGDM5KmpUhc56HGEXY6iY2o+0NlRPkPhBY/iT8ylVcoWsZWz
	+MxSbuk3aPWXa/wRttAK/D5KKw/sjaS2oRrG0ub7F
X-Gm-Gg: AYBFou1TyQeMXqV83DuD7Tn4DZGTyge8I1s2hEiwmd0tAH/zyXNGxda3SrZI+HroJ4w
	cIUNHDLVuy9DT6A6NKocJjcNSFEbw1eYvBnztv31I7aW5cSVmUtnYau0TyUAsRFnL8zVPWdnWSY
	JdoyTOluXyduuO3KyAR49Q+yTI350CbcVCruz0t9dL7uiXoMqpFm0BhfHARHVzZvkHzpYagWjyw
	IIGVNviCAEu8V2ZshLxJG7Jf1LV6hYfGn3JaD/rD7hdEb8W7W2L11jpI1+enouPSL3KIzLWKmtJ
	J9tcnIntC00AliBEQUO2Bmt9jx+4pAlmMuLTnZVoy8CZ8RDaQR0JMd4=
X-Received: by 2002:a05:622a:1a8f:b0:532:c8ca:5ae9 with SMTP id
 d75a77b69052e-533226f9f89mr30441681cf.11.1790608590801; Mon, 28 Sep 2026
 08:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
 <60642a7f-2949-428a-8290-40d69c989a77@linux.dev> <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
 <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
 <1dff448c-9cbe-4276-bca1-d91283b0c7b4@linux.dev> <b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev>
 <arpK2bQrrUMvEvTP@milan> <arqDHnBFGKQZm7VU@milan>
In-Reply-To: <arqDHnBFGKQZm7VU@milan>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 28 Sep 2026 08:16:18 -0700
X-Gm-Features: AclHuK8H_rn91yL5MjXERW3wss1aaZb7EVDlHwDTppCbnSE6x5WvHEULyhM7Qvg
Message-ID: <CAJuCfpHuTzFBUm2uAbkFsKF85GxcqFATmKgT50AQgWkLjf7NMw@mail.gmail.com>
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Hao Ge <hao.ge@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 54s6atrpy3mna3nfzm9qu4trze3ip7bt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A31FD120017
X-HE-Tag: 1790608592-328544
X-HE-Meta: U2FsdGVkX1+X8XvuXPez6XNROWWQdbDpAloh8bBrylQbs3+EOEKA72mdi4dZiNoMex51szZ2+wxTgtLDD9Gdrk/jQa6CvUosbRKBnvUFbUIIboyVW01cLUXTr+qt1TUmORgKfIN2WHMDWa6YYlSebqyxEF2HWu31RLWDz7kwmof/bARH4CPOsEomiMqU2bKhNdkUBp8hUa2RyKgyKBSlOFA1mCw03vV8WE2IBG7mabH1P0rB8aHz28m6TqyTC0RG2PZ0pev4JYvAx1DLABLGYgujd8G44zpP3kAm8+BjkJIg7sgsgJfcZ0lOE5PR0vyrwcxqPXrPGEw7f+qA04oq5/DewCGnr5xpdWErrpPt4ez2QVZuaOxlDAZi9qjJ3VKNOR89qJw33pn6BQxZXqJW2WHOAa1vc8quhXA7AKHajQ+wTRDFOFREehcI7ab1mhAQlO6mG3VfLjRrj56f3gZDtfkHhXG9/DlR1VxD/qLyUfGznhSXg7v3Jn6juDNLbaXVi8vM0kFiyIuigj0od5pEOQDua51MS41Ia/t24JsZVQtFkdhmG9vrWeTEeQWzIdyV2WriRnpgJyevzgGTUNNRdr75ZyG7ymQ3vrMlN8YNgMdFfjz024oudSVLZmwBcgFb1njXlQerQuz2PHWJFYfUur1X3o6KmJ359MUpB5ZkDYRbvS3wpCncSZZXjKUmg3jwERIgXAaXfMOIajacLJ35O7zVphdVSlgItoJS/6Ovha0gVMeIBLoO188hvoUIbu5Y5J/cp6+TNaBGhm2bhCwf8chuh/FawObktXMXkiobkJHJVaNlB+WTbk5/vWeDntiVaEDPwBlPXTlP5wdTeGN0T8VbFMYj0wZEmZRR/K+CjNufGZJUttebtIjUHoCRD25c3LUlOcTMnqULw5wXQymbXH8yVbzje11uH+AeX25vudCULT3B4zPuvgoDWPJs1af6xbCMJlkou9df6X1tZz3
 3M4jlDMe
 5waDwQyxOjKXn4b4B7Fafg8/m0V/o9M84u0TDmFRR/BQy1JJFYvVPVf4oCztsqQ9tt7JAxr40TmqxFwpIAMGlHDNVZSF+pFzRQMkXPpxQsJr6ZOqxWhfdFyWtKzGNxwkijwowbbUivjmHhIt7OSbJwB1OkWov6zcTb5Qwj0q2pStHcIRc+3qTdRpHWsWCgoafu9u61uZdXI/KmoAIkB7VOLadnE0wWTxEspkWLT/vWnvpn7GIfMNkBrYnNej0pMrz4375G1nNnna6Myx/wQOiAquVdnYRpwRFQY16L23kYrfABBz055GiaJnmHlJypQR+MNLjGPoSEkSu83w00GHytrKzKrZqqdNWMURz8EXFOVZ9nA/t/P0LxenYFzhdc+8t0c6r0JP/YFM4AQdHTLYBBoXYutM6tdK4r8Xi6AJmSKTANN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 8:09=E2=80=AFAM Uladzislau Rezki <urezki@gmail.com>=
 wrote:
>
> On Mon, Sep 28, 2026 at 01:09:13PM +0200, Uladzislau Rezki wrote:
> > On Thu, Sep 17, 2026 at 10:32:48AM +0800, Hao Ge wrote:
> > > Hi Suren=E3=80=81David=E3=80=81Lorenzo
> > >
> > > On 2026/9/17 09:12, Hao Ge wrote:
> > > > Hi Suren
> > > >
> > > > On 2026/9/17 03:07, Suren Baghdasaryan wrote:
> > > >> On Wed, Sep 16, 2026 at 9:31=E2=80=AFAM Suren Baghdasaryan <surenb=
@google.com> wrote:
> > > >>>
> > > >>> On Tue, Sep 15, 2026 at 11:00=E2=80=AFPM Hao Ge <hao.ge@linux.dev=
> wrote:
> > > >>>>
> > > >>>> Hi Suren
> > > >>>>
> > > >>>> Thanks for you review.
> > > >>>>
> > > >>>> On 2026/9/16 05:09, Suren Baghdasaryan wrote:
> > > >>>>> On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.d=
ev> wrote:
> > > >>>>>>
> > > >>>>>> The reservation is already stored in the maple tree when
> > > >>>>>> vm_module_tags_populate() fails. A failed load never unloads t=
he
> > > >>>>>> module, so nothing releases the entry. Release it and roll
> > > >>>>>> module_tags.size back. Without the rollback a concurrent load =
that
> > > >>>>>> already passed needs_section_mem() can reuse the freed gap, sk=
ip
> > > >>>>>> vm_module_tags_populate() and write to unmapped memory.
> > > >>>>>>
> > > >>>>>> vmap_pages_range() may have installed some PTEs before failing=
. A
> > > >>>>>> retry to populate the same range would BUG on them, so undo th=
em,
> > > >>>>>> but only if vmap actually ran.
> > > >>>>>>
> > > >>>>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation t=
ag compression")
> > > >>>>>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module ta=
gs as needed")
> > > >>>>>
> > > >>>>> If a patch fixes two other patches, it likely needs to be split=
 so
> > > >>>>> that each part fixes one patch only. But read on please. I'm no=
t sure
> > > >>>>> if one of the fixes is correct.
> > > >>>>>
> > > >>>>
> > > >>>> Kept them in one patch because they only make sense together.
> > > >>>>
> > > >>>> After a failed populate the reservation is released and the
> > > >>>> size rolled back, so the next load takes the same gap and calls
> > > >>>> vm_module_tags_populate() again, and that retry would trip over
> > > >>>> the PTEs the failed vmap left behind.
> > > >>>>
> > > >>>> Without the rollback a load that already passed needs_section_me=
m()
> > > >>>> just reuses the gap, skips populate and writes to unmapped memor=
y.
> > > >>>> So splitting them leaves each half broken.
> > > >>>
> > > >>> Yeah, that's why I think vmap_pages_range() cleanup should be a
> > > >>> completely separate patch with vmap_pages_range() doing cleanup
> > > >>> itself.
> > > >>>
> > > >
> > > > I think I get where you're coming from now.
> > > > Thanks for taking the time to explain.
> > > >
> > > >>>>
> > > >>>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
> > > >>>>>> Cc: stable@vger.kernel.org
> > > >>>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > > >>>>>> ---
> > > >>>>>>  mm/alloc_tag.c | 10 ++++++++++
> > > >>>>>>  1 file changed, 10 insertions(+)
> > > >>>>>>
> > > >>>>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > >>>>>> index 2070e682fe10..95ddf5b743d0 100644
> > > >>>>>> --- a/mm/alloc_tag.c
> > > >>>>>> +++ b/mm/alloc_tag.c
> > > >>>>>> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
> > > >>>>>>                                      next_page, PAGE_SHIFT) < =
0) {
> > > >>>>>>                         release_pages_arg arg =3D { .pages =3D=
 next_page };
> > > >>>>>>
> > > >>>>>> +                       /*
> > > >>>>>> +                        * vmap_pages_range() only runs once a=
ll pages were
> > > >>>>>> +                        * allocated, and it may have installe=
d some mappings
> > > >>>>>> +                        * before failing. Undo them.
> > > >>>>>
> > > >>>>> If vmap_pages_range() failed to map the range, why should we ne=
ed to
> > > >>>>> undo it? If it indeed leaves some partial mapping when failing =
then I
> > > >>>>> would argue that vmap_pages_range() should be undoing these par=
tial
> > > >>>>> mappings itself before returning the error.
> > > >>>>>
> > > >>>> Yeah it does - none of the paths under vmap_pages_range() undo t=
hemselves on error.
> > > >>>
> > > >>> Hmm. I wonder if this behavior is intentional or requires a fix. =
The
> > > >>> only possible reason I can think of is performance but I can't im=
agine
> > > >>> a failure to map is a performance-critical case.
> > > >>>
> > > >>> +David Hildenbrand (Red Hat), +Lorenzo Stoakes (Oracle) what do y=
ou
> > > >>
> > > >> Huh, my gmail thinks you are still at your previous companies :)
> > > >>
> > > >
> > > > I manually fixed it on the mailing list for this thread.
> > > >
> > > >>> guys think? Shouldn't vmap_pages_range() undo its possible partia=
l
> > > >>> mapping when it fails?
> > > >>>
> > > >>>
> > > >>>> pcpu_map_pages does perform cleanup on its own as well. There ma=
y be other similar sites.
> > > >>>> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#=
L255
> > > >>>> so I did the same here.
> > > >>>>
> > > >>>> If we really want vmap_pages_range() to handle this cleanup inte=
rnally, I believe that would
> > > >>>> be a relatively large change, and we would need to consider many=
 more cases. So I think we keep
> > > >>>> the current behaviour for now.
> > > >>>
> > > >>> Yeah, I understand it would require a deeper cut but if that's th=
e
> > > >>> right way to handle this we might as well do that. Let's see what=
 MM
> > > >>> folks think.
> > > >>>
> > > >
> > > > Sounds good to me. Let's wait and hear what the MM folks say.
> > > >
> > >
> > > I just looked into the call sites for __vmap_pages_range.
> > > And I found there's a bug in one vmalloc caller [1].
> > > When gfp_mask has __GFP_NOFAIL, the code keeps retrying
> > > __vmap_pages_range. If there are leftover PTE mappings,
> > > this can trigger a BUG(); [2]
> > > https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L3946 [=
1]
> > > https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L121  [=
2]
> > >
> > Indeed the below code is incomplete:
> >
> > <snip>
> >       /*
> >        * page tables allocations ignore external gfp mask, enforce it
> >        * by the scope API
> >        */
> >       flags =3D memalloc_apply_gfp_scope(gfp_mask);
> >       do {
> >               ret =3D __vmap_pages_range(addr, addr + size, prot, area-=
>pages,
> >                               page_shift, nested_gfp);
> >               if (nofail && (ret < 0))
> >                       schedule_timeout_uninterruptible(1);
> >       } while (nofail && (ret < 0));
> >       memalloc_restore_scope(flags);
> > <snip>
> >
> > and it should be fixed. As the __vmap_pages_range() can actually fail
> > and leave some installed mappings, we have to perform some cleanups
> > on failure or on repeat(if nofail is true).
> >
> > Below code:
> >
> > +                     /*
> > +                      * vmap_pages_range() only runs once all pages we=
re
> > +                      * allocated, and it may have installed some mapp=
ings
> > +                      * before failing. Undo them.
> > +                      */
> > +                     if (nr =3D=3D more_pages)
> > +                             vunmap_range(phys_end, phys_end + (nr << =
PAGE_SHIFT));
> >
> > we can use but we need to check if partially mapped space is not an
> > issue for the vunmap_range(). And it looks like it is not.
> >
> > <snip>
> > @@ -3953,8 +3990,15 @@ static void *__vmalloc_area_node(struct vm_struc=
t *area, gfp_t gfp_mask,
> >         do {
> >                 ret =3D __vmap_pages_range(addr, addr + size, prot, are=
a->pages,
> >                                 page_shift, nested_gfp);
> > -               if (nofail && (ret < 0))
> > -                       schedule_timeout_uninterruptible(1);
> > +               if (ret < 0) {
> > +                       /*
> > +                        * __vmap_pages_range() may have installed some=
 mappings
> > +                        * before failing. Undo them before returning o=
r retrying.
> > +                        */
> > +                       vunmap_range(addr, addr + size);
> > +                       if (nofail)
> > +                               schedule_timeout_uninterruptible(1);
> > +               }
> >         } while (nofail && (ret < 0));
> >         memalloc_restore_scope(flags);
> > <snip>
> >
> And looking further. If the __vmap_pages_range()/__vmap_pages_range_noflu=
sh()
> and friends fail, a proper cleanups should be done inside, IMO.

Sounds like we are in agreement.

>
> But i am checking callers and see that some do some not:
>
> <snip hooks.c>
>         __vunmap_range_noflush(
>                 vmalloc_shadow(start),
>                 vmalloc_shadow(start + clean * PAGE_SIZE));
>         __vunmap_range_noflush(
>                 vmalloc_origin(start),
>                 vmalloc_origin(start + clean * PAGE_SIZE));
> <snip hooks.c>
>
> kmsan_ioremap_page_range() it does clean ups;
> kmsan_vmap_pages_range_noflush() looks like does not care in shadow.c;
> __vmalloc_area_node() as noted, it is broken as there is a BUG() on next =
try if nofail;
> pcpu_map_pages() it does cleanups.
> ...
>
> and so on.

Yeah, the callers that do the cleanup should stop doing that once the
vmap functions handle it themselves. I expect an overall reduction in
code size.

>
> --
> Uladzislau Rezki

