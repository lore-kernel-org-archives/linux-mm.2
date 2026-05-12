Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8869CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 04:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390256B008C; Tue, 12 May 2026 00:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A0E6B0092; Tue, 12 May 2026 00:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2946B0093; Tue, 12 May 2026 00:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 069276B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:14:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E537120340
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:14:11 +0000 (UTC)
X-FDA: 84757450302.06.7D794AE
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 85F9B10000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:14:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YXtbrxBW;
	spf=pass (imf05.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778559249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tu10g5eHmkKrLoI4P71MtDv+E+8bkFikypgVZ68bMRo=;
	b=zs28hew2O7sjoGfOEXIYVfn6SSZSjQab2vVNOn5j9vwPt32Fpo86lElum42dPCR71ddOz0
	TCm0Q3Es4HiebyNKpKxEKzpfv6Uau5avAe0NKfer97a+JChCNP3yoOrYNgDjhmudOs/9JY
	XWYRJAJnG6saPhnUnUCfBg9CPZajDr8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YXtbrxBW;
	spf=pass (imf05.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778559249; a=rsa-sha256;
	cv=pass;
	b=cO+F8oGdBFY/Qgx6xmY0Cs708hSlFRMjdyHGNtCN9nBg6a+h0+qgxlg2FdALnlv95MiWBW
	O4wZGDBK2Y2U6xK59q++HUA6P4t0XhJBe2+aHOM0C104pzaLUb9p8i0xvxJy+6DlOLZ3L1
	of1uifhhAXxGgHqnDosPYuNyYnhsJ2w=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5751b7d147aso1697211e0c.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 21:14:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778559248; cv=none;
        d=google.com; s=arc-20240605;
        b=jZ3q6ETS0Sog53TOlpI58PjkLqFKh9rtyxH1whUt84WNQLRVa/xb7Y+XMaxLEns385
         YhbchcrXCB8hjHT4XvAARn0cru7Klk/m/wXClIZaLzczVP7VkYefQ2FKZpcizLSbvRnZ
         GDB0kgCyNjPbnj1NFvwFbZ1dZZIImyU9ahUZ4MhSvnp/qrAYJeHd5YXCcJX+pfssrL4I
         UfpR5GJib3BinJFCM7oC2am4X1Fnzy+ZUN37QFjR/rYhR70Fk2OrkoHOFfXNHDLaEvmB
         PgZFrw6/b+n85nil63bsYwh20iv31hNXZh1v/6/S53NhAD1t4T9U5fTT1mvx4O53gtV0
         8bKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tu10g5eHmkKrLoI4P71MtDv+E+8bkFikypgVZ68bMRo=;
        fh=SaTqHHBmRvmDzhwXc2PNPa33P9kKG9YJuFC4NKeavVo=;
        b=TMyiQXAYRTVbNIGhxnjKPy2/cnPl9IdgomtmkhGmnxuaMmWKD2dn3tq+SfkZbH/1EA
         sl77R8rxqSOK8esQbilMdimGkrN6suJBhrohy26Sc9xThucH8O62z1Ue6E9OzrLxBv+B
         981H3vUxLcw9KNsCaCAn821nDChUNXt+Re1opQNpm7kelR0SnQt4euQOxfWkCxK04Wmw
         +yatOObL+fq7t9hceSEMbPnmRAaC/PwSKiJlLzEygVU/HqJEx3bx1c/1ROYDVU8EbgsQ
         YeBa31gvcHeqFpwifBZG8DoUUqMgLbPdstj5jGqao0jyeGaEsO4mnMrKXTfJemx94M7r
         7uHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778559248; x=1779164048; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tu10g5eHmkKrLoI4P71MtDv+E+8bkFikypgVZ68bMRo=;
        b=YXtbrxBWQ9VT/c8oAAPwLK1aXvKvJqZ6ImUb/+A1KI8ytC/Nz8pjpsY/VNq89H9CLe
         fnWadWfGIDxDQIL4rKpxQ9Z3rmAgKNyjO8bkYln/pmy0/SDKnk4/eb7+/9eP09BpPBbh
         w4yhQtOtZ7O8quhqn+XCQTj/3Zu42ytV5wjUm4RCqlSeeEtKNzTmHib6Wq+sB2zAXId7
         VtjUce6zbfCDqUXmdFLoBy5JRMDi+5GD+Wv7RgIrIO55FD9N6gi/l1NZ82KwxWWGGuPT
         /E/R8FSjFmOiJr1x7j2mmYYMKocFE9nqCjxe1L/IiqBnwzwjIHOxNEfSarF+9VcFLDyi
         fXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778559248; x=1779164048;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tu10g5eHmkKrLoI4P71MtDv+E+8bkFikypgVZ68bMRo=;
        b=DBaek6mOVO4xa1y95KPHINDKPnwriUmKWRzPXla88R9okPu1BoPy+5dVg3cNilth9e
         AIoF/B2AXWAd2LLHnVwG6t6KWkh3ldeyXFmzZLIKEpyKV+AyqrzHWUZwe0BpxRAvMEY6
         HK+eN8yJqq4jN3h36GOvTo+j1TIvlH5PyWuyXm7HNhi+PdyLoA2eWxipJicELWSTRek0
         9R32nKr7ZA0sbPjsG/tscq/Mgrh8bU1DT2THuzIKoCYswo7IQtz7N0jT8alLP7CgOpXN
         8IN4xBy17apWE06JHJWFwo+gACzHuHbXrJILRbWdMAl3u2BShJXD5YFfktYrLo1zBEjP
         dM7Q==
X-Forwarded-Encrypted: i=1; AFNElJ/1TM/pJ9nnd4eNwKNCQm8FpQa2ntfEENpW0ltMHxf1xq4c/tCaBaOHqu7gBKO1/PRqErQMgIdTfQ==@kvack.org
X-Gm-Message-State: AOJu0YxL/gXTo5rrnXoYTqgS49QvBF++covPZQtwLHGQGSiJUJ6tv2kq
	YxMDU6mqEss6SLcTGtWZDiGyf318bz6FYIg6PfC8+4ATPj3u6KIfBnD8tQFBBDtEWaOATXJEiMT
	uYvzVe6RJr0stGaiDfR2sFoQP5u0hABQ=
X-Gm-Gg: Acq92OEq3GUIyH/ODAMcavs1qgN2CSpkCuo+lB34DAIv1eEatdY6JGT4vNt+hq3UAP5
	9k8PrCa4JyHpiyFpUZ4SBQRTREKEaE+Ucv3a9pwUkTaVbM+mTMTQp7re0YSDWFnRkt5ge7p8Dff
	LDgRIdHaNhT8AblmO8Nss3htZHmZYRWVxiojaFUcGZ3XObO5nG9LB3IsTFtxyOp9Gzw39pD8bUY
	RZ2VzQShx5xQJBKmQK3Sg5AwGe2LwJowF61G4xwNex2myvDSG/Wqu6b2JbMIaarjYzoChFHqLep
	FY3nL8lGj2zh60Y3Y5JLyvT2Axjxh000DhxHsFAGx6Fm6JdqHcLL
X-Received: by 2002:a05:6102:4189:b0:633:75d3:3545 with SMTP id
 ada2fe7eead31-636180cc5b1mr486160137.30.1778559248419; Mon, 11 May 2026
 21:14:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260511191218.98881-1-agarwal.vineet2006@gmail.com> <20260512004538.1005-1-sj@kernel.org>
In-Reply-To: <20260512004538.1005-1-sj@kernel.org>
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Date: Tue, 12 May 2026 09:43:55 +0530
X-Gm-Features: AVHnY4In1qtzJhnSZdkYrlxsnxzaMvOEtF7wNb9Upl08GATJvYaIjvt2r28am7E
Message-ID: <CA+rjy8efhNJvaDYmp+f8XVzCMNJYQj1Qo9dpeKjbWaFLSVmyvQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/damon/sysfs-schemes: fix double increment of nr_regions
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000036d16d0651971823"
X-Rspam-User: 
X-Rspamd-Queue-Id: 85F9B10000A
X-Rspamd-Server: rspam06
X-Stat-Signature: pydtc9kbucuwzxb713s14omywadces9f
X-HE-Tag: 1778559249-298053
X-HE-Meta: U2FsdGVkX1/1pEn4vFsaeR7zpKw/VvrqtA9GyQCoOVF1gPxeD1K0YMnBY1mrNPgnbz+XtgBzvbg4dCIGVeAwqalfcYRdt4hMWzjNLfeIHBhOb6WAJsGCAL+VH0ONIadZb3JPxkYAN6moAML58XaCpw64PhgNygo5+I/VbiFV0AgDvEgdLBVChiyvgsyV2MPKhJqYb4mII0xOm6rv3MhRKUWjr6g9cCODPfWYZ425wAXokWO47gpjbZ+RFdYobNnHKgjx8YvNhBbNLquQCcxjoDgLUTjvG9Vxa0D+bj9Ehoemni5pO3LzxbFvmQUW3u03Wfl2RZ9HeA3nUYGe7JgFatIP8gVYa21anjmga9gr82Q9VcNtAwVHrjnm5B53QmAEZDG4L1vMxSBrd6g1uSb45Kn/fNtVwm7CozoTObMUHkwKC9LMxfWprDUfwBb0sqJyMZD58Nqus62IyO/YfVUGVAxLn8i1GLnoodKsMsjiBNP7xNZ837ial5YQD+6S+/ssHHXitW6+8yj+/e2QfqVOldUMmOcdMwAxanCB8uMz/eG/lJ/uoh/e3kgXsscbOI+J3LYhgnVsrgJZy1H5rsDwFpY7+ElCnd/ICA6Ij5QJqTCL8/MjdxJqpQEeHXNAUvL+ilR6QSarCECYr6FOifUp5RQaC3VtRfxFlKqiP0tBw+JsUrDMOIb0O7SCgiv+CSQh08him7w60U8AH07gjubrHhsdEykZQjSIuP4Y0tgy6Q42dqgBYUHlfZUawhJrV/CiWZ/avaSQJMI2Naw15eyS9NWJ9h1zy4OoSKSgANgGo0BTNEpF03Hzsj1NoxmY6YIOQUshJxP3PbnRwW4QQlILk/3hE8WO6q/g9Zqik4x7BHsotdqz+6tKF0J80P14md9QC4WDPi23PNVSV9D4YKQliSME/YzUig3Owo8ke4cIueDAhaa19vKZz1Sbi0Y8cdqO6Y3JEuzbDAZdVzhyzVS
 2xQTX2WM
 NkFeQgp/U2RZMgTM3waxw1LJ2jzdJ22HmW7z++34+e65oQPgVj+sNOFKZzTeMHf0OBZoU8Qb0pdmMPjoOB4CSjnlh+YICJHH4RsB1uwTub1LPGNn3u6UKkafXV7kkcVTjT3jMmWSj36G6L+Yg+BJbUOBcruz//XXtcpoY3sIXtDmUn8UA+qjQ79kqa3C6L+K54ZHRFcfm/ksbpVl3Zpue8P4pgDxXyMSo7DbqRaYRZGyqYxWc4VBZKbtlUfXRZfMI9b6WAmat1cXrIWWEUoXdUiV3GY2tyHcHE53chn3Q/ygxgwx/FCgqxbtxcwvjklr1f1vOOtASiC6iIfSaz13GFUSQt2LG6YU4xlqaRy03kBL/JNTKkfQQmYMrfCDvlIyyjxtjrTK1SM1R8gFbXf5kVMOYDqdTy8OhWijYV3N3rh6nfSPRi3fFXktQY7rmGHntrp1+vV0wnGPOC8h6H+iO1rziwNJ4KiqS1lxoqWWJHh1QoQQ9fC/REVBvKWPtbo2rawP+jz77UXz6S3h81KGNpZRncZwz01k7D0QeZTxz5AyWH0onyPKcJXW8jJir0iRn2dG9KQfOEsdBy9NA6Or97ehlm0WGqFwH6x/5554aO7IqtSnbt1jNv64h6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000036d16d0651971823
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi SJ,

Thanks for the detailed review and explanation.

I also couldn't find any path where nr_regions affects allocation sizing or
other important behavior, so this does seem limited to the incorrect count
and skipped numbering.

Nothing else to sort out on my end =E2=80=94 I've resent the patch without =
the RFC
tag and with a Fixes tag for the commit that introduced the behavior.

Thanks again for taking a look.

Vineet


On Tue, 12 May 2026 at 06:15, SeongJae Park <sj@kernel.org> wrote:

> On Tue, 12 May 2026 00:42:15 +0530 Vineet Agarwal <
> agarwal.vineet2006@gmail.com> wrote:
>
> > damos_sysfs_populate_region_dir() increments
> > sysfs_regions->nr_regions twice when adding a new region:
> > once explicitly before kobject_init_and_add(), and once
> > again through the post-increment used for the kobject name.
>
> Nice catch!
>
> >
> > As a result, nr_regions no longer matches the actual
> > number of live regions,
>
> Nonetheless, this is not causing real issues.  The the nr_regions is not
> exposed to the user space.  Similar data structures in the file use array=
s
> for
> managing sub-directories and use the number field as the size of the
> array.  If
> that's the case for these region directory data, the code might allocatin=
g
> more-than-needed memory or having some problems.  But luckily region
> directories are managed using linked list.  I find no real problems here.
>
> > and region directory names skip
> > numbers (1, 3, 5, ...).
>
> This is also not causing any real issue.  This could arguably make users
> confused.  But still user space could work with this in a reasonable way,
> by
> sorting the regions based on the index and/or the address of regions.
> Actually
> DAMON user-space tool is handling this.  That's why I didn't realize this
> issue
> by myself.  We recommend human beings to use tools rather than directly
> interacting with the sysfs interface.
>
> The admin usage document is also not giving wrong assumptions about the
> names.
> It only says the names will be integers starting from 0.  The real names
> start
> from 1, but arguably that doesn't break something, becuase the document
> doesn't
> say there will be directory of name '0'...?
>
> >
> > Use the already incremented value for naming instead of
> > incrementing nr_regions a second time.
>
> So, there is no real problems.  Please let me know if I'm missing
> something.
>
> But it is also super clear that this is not an intended behavior but a bu=
g.
> That needs to be fixed unless it causes unnecessary overhead.  Meanwhile,
> this
> fix is simple and nice.
>
> So, nice finding and fix!  Thank you for sharing, Vineet!
>
> >
> > Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
>
> Seems the current behavior has started since commit 66178e4ec30a
> ("mm/damon/sysfs: use damos_walk() for
> update_schemes_tried_{bytes,regions}").
> I think it might deserve 'Fixes:' tag if someone claims, but Cc: stable@
> may
> not really needed because this is not causing any real user issue, as I
> mentioned above.
>
> So, this looks good to me.  Vineet, is there anything that you want to
> sort out
> before dropping the RFC tag?  If not, please feel free to post this again
> without the RFC tag.
>
>
> Thanks,
> SJ
>
> [...]
>

--00000000000036d16d0651971823
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p class=3D"gmail-font-claude-response-body gmail-break-wo=
rds gmail-whitespace-normal gmail-leading-[1.7]">Hi SJ,</p>
<p class=3D"gmail-font-claude-response-body gmail-break-words gmail-whitesp=
ace-normal gmail-leading-[1.7]">Thanks for the detailed review and explanat=
ion.</p>
<p class=3D"gmail-font-claude-response-body gmail-break-words gmail-whitesp=
ace-normal gmail-leading-[1.7]">I also couldn&#39;t find any path where nr_=
regions affects allocation sizing or other important behavior, so this does=
 seem limited to the incorrect count and skipped numbering.</p>
<p class=3D"gmail-font-claude-response-body gmail-break-words gmail-whitesp=
ace-normal gmail-leading-[1.7]">Nothing else to sort out on my end =E2=80=
=94 I&#39;ve resent the patch without the RFC tag and with a Fixes tag for =
the commit that introduced the behavior.</p>
<p class=3D"gmail-font-claude-response-body gmail-break-words gmail-whitesp=
ace-normal gmail-leading-[1.7]">Thanks again for taking a look.</p>
<p class=3D"gmail-font-claude-response-body gmail-break-words gmail-whitesp=
ace-normal gmail-leading-[1.7]">Vineet</p><br></div><br><div class=3D"gmail=
_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue,=
 12 May 2026 at 06:15, SeongJae Park &lt;<a href=3D"mailto:sj@kernel.org">s=
j@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddin=
g-left:1ex">On Tue, 12 May 2026 00:42:15 +0530 Vineet Agarwal &lt;<a href=
=3D"mailto:agarwal.vineet2006@gmail.com" target=3D"_blank">agarwal.vineet20=
06@gmail.com</a>&gt; wrote:<br>
<br>
&gt; damos_sysfs_populate_region_dir() increments<br>
&gt; sysfs_regions-&gt;nr_regions twice when adding a new region:<br>
&gt; once explicitly before kobject_init_and_add(), and once<br>
&gt; again through the post-increment used for the kobject name.<br>
<br>
Nice catch!<br>
<br>
&gt; <br>
&gt; As a result, nr_regions no longer matches the actual<br>
&gt; number of live regions,<br>
<br>
Nonetheless, this is not causing real issues.=C2=A0 The the nr_regions is n=
ot<br>
exposed to the user space.=C2=A0 Similar data structures in the file use ar=
rays for<br>
managing sub-directories and use the number field as the size of the array.=
=C2=A0 If<br>
that&#39;s the case for these region directory data, the code might allocat=
ing<br>
more-than-needed memory or having some problems.=C2=A0 But luckily region<b=
r>
directories are managed using linked list.=C2=A0 I find no real problems he=
re.<br>
<br>
&gt; and region directory names skip<br>
&gt; numbers (1, 3, 5, ...).<br>
<br>
This is also not causing any real issue.=C2=A0 This could arguably make use=
rs<br>
confused.=C2=A0 But still user space could work with this in a reasonable w=
ay, by<br>
sorting the regions based on the index and/or the address of regions.=C2=A0=
 Actually<br>
DAMON user-space tool is handling this.=C2=A0 That&#39;s why I didn&#39;t r=
ealize this issue<br>
by myself.=C2=A0 We recommend human beings to use tools rather than directl=
y<br>
interacting with the sysfs interface.<br>
<br>
The admin usage document is also not giving wrong assumptions about the nam=
es.<br>
It only says the names will be integers starting from 0.=C2=A0 The real nam=
es start<br>
from 1, but arguably that doesn&#39;t break something, becuase the document=
 doesn&#39;t<br>
say there will be directory of name &#39;0&#39;...?=C2=A0 <br>
<br>
&gt; <br>
&gt; Use the already incremented value for naming instead of<br>
&gt; incrementing nr_regions a second time.<br>
<br>
So, there is no real problems.=C2=A0 Please let me know if I&#39;m missing =
something.<br>
<br>
But it is also super clear that this is not an intended behavior but a bug.=
<br>
That needs to be fixed unless it causes unnecessary overhead.=C2=A0 Meanwhi=
le, this<br>
fix is simple and nice.<br>
<br>
So, nice finding and fix!=C2=A0 Thank you for sharing, Vineet!<br>
<br>
&gt; <br>
&gt; Signed-off-by: Vineet Agarwal &lt;<a href=3D"mailto:agarwal.vineet2006=
@gmail.com" target=3D"_blank">agarwal.vineet2006@gmail.com</a>&gt;<br>
<br>
Seems the current behavior has started since commit 66178e4ec30a<br>
(&quot;mm/damon/sysfs: use damos_walk() for update_schemes_tried_{bytes,reg=
ions}&quot;).<br>
I think it might deserve &#39;Fixes:&#39; tag if someone claims, but Cc: st=
able@ may<br>
not really needed because this is not causing any real user issue, as I<br>
mentioned above.<br>
<br>
So, this looks good to me.=C2=A0 Vineet, is there anything that you want to=
 sort out<br>
before dropping the RFC tag?=C2=A0 If not, please feel free to post this ag=
ain<br>
without the RFC tag.<br>
<br>
<br>
Thanks,<br>
SJ<br>
<br>
[...]<br>
</blockquote></div>

--00000000000036d16d0651971823--

