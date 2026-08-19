Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A901C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A656B0092; Wed, 19 Aug 2026 06:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB446B0093; Wed, 19 Aug 2026 06:38:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9116B0095; Wed, 19 Aug 2026 06:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04F3A6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:38:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2043804FA
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:38:08 +0000 (UTC)
X-FDA: 85117669056.19.6B56CBE
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id C1B22A0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:38:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WhC6KDyr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787135886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uGMAeF78x6SQDnW8np9tL2cp3RlbjSltpHkb8/9kJI=;
	b=xMkVuMjIPt/N2cz4KxNjLx9SHRbIFbCrAnvnXK5OWPsZhKUVRcsxuwnmwsCxXtbPeZ7gWZ
	cOCj2wyV1TqIl3MrD9aEz4GBoxjBrQqxrdCs/Im7pD5GgvEYLae2n5WDJUHtNtaJf03b4v
	TctojvVvqx8HlpZvckkZWGu8n0Y+R9o=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WhC6KDyr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787135886;
	b=2zukVn2tk999w0VXXkz98Z98rnCD5ZZBXpO7K4drW2oScj3UfJMjtxo42g0Z7tBcR5vNKE
	GMwbEO9Idr/cjN6dqtMqYrZVZZvWWizPHsgcZZeOKyzr+r+K9KjiiYAE2q/Z83LeL/mEQM
	dDtFRI8y2Td+Lzi87HW8SeYRhetJIag=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3810c5d691bso639549a91.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:38:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787135885; cv=none;
        d=google.com; s=arc-20260327;
        b=ONY6+jXWAT5Q36ctYF7k2Cyrij4X3P4aGIZPX+QIEw1Qr6/Bo2R5gynlyZOydhWLnW
         AwzkdpAkaZYzIWaxz91IrRqCAsOts8hfwv8GKNxuzZugpnAlS9fmqausvAOMWKmbEkk8
         fMs+QX4vAJlCIOi7FGXyAyneFicQYOJwGe/fy7iR18/eh+tG0fUUJlOuPOBpbt5BIW4I
         c3zetrY0ORdGEE2788PKc5P3nr+PbzRvmcvD1otLEz0ss1nRBo8SyUmQNYvQDCgInpqs
         XhUdKAN4qM/YyDUsC5tIwhMw25L43RD2RM+Owv9faY2+qR9wQKIL+xbLD2DmOXuaG+ly
         lYTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4uGMAeF78x6SQDnW8np9tL2cp3RlbjSltpHkb8/9kJI=;
        fh=NcGfxy7Eh1m0McDhAzO1IiIQTnZKa1o9LNzjf3ueTBE=;
        b=EitS8SOK5GygFGWatinGZmIsN/Wy/5dc6Oc0JURXpfyW+fyuSlDbDgb6lTzncAyQPA
         /+aFJuvrwx4Pr16si/3PAfyjna9urSt7uZzT9uNlLwH7IqudwsXYi18fVVD2ah8lfNUp
         oO1HuuQtDH8AAwWpmuNbbFPyMTRfze5y41ujUXraLFqKXhjBi21e/ipD10253uIxN061
         bMb+1VkPAVbWpQwI14LDZuOaQ4knt1xl4/i1Q5RFT0Lh3G1Odqa6ToHqiqTcbdqMgD2V
         m+864Q4qo57y/7Z1Nmr+M0q4LAl4t6HtdwgCY3/wm+bu18DjSIKd1LNRVVieNW6eUGg0
         6R9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787135885; x=1787740685; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4uGMAeF78x6SQDnW8np9tL2cp3RlbjSltpHkb8/9kJI=;
        b=WhC6KDyr35pt2tKzoZel9Zrk9UsnG0FdYX0wWNuDlM/NsK//vrUlZ/gTt2Mfw80wc4
         VpybRHZGMa902dVDi0MFEoDMK7TlKKtXCx4S5RrHN1Z6VPDXy3cCKgkOe/0gbTFyctyv
         EVjogZpxPyF9lRVlko4SxuSCOrKqfiGUxvqXoSjfTTaG3EBmanRZV2ST6hQi54JdVwNN
         GjaOojQfIgcb+5d8F0a4L5zr/y8+yimiMsL4rdLMguBf7o9eubwVmbIdzi1ShsuFfuKP
         X40pAVjEIPRbG7eEkeLY+4TeOwuUWq5mRTRaXEmAz8DY1SZ+2oKtynEZ68gkBAuCcVw5
         v19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787135885; x=1787740685;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4uGMAeF78x6SQDnW8np9tL2cp3RlbjSltpHkb8/9kJI=;
        b=kl60ikDcu7peR7AIDaE7PcDmcmBBXwSGM9qzS/F8HAeY3MdYh08xwz61N8jt+XcyVK
         6HBFMM5QpmmBWvw4LCGyCLTfJD+dNt7PaLr6JUFbE4KmYehLoIqqTBhIUp4o3iwjYqKA
         cFHBFlPUwYcxWI6ClDr3QxcRw7lK5theaTb+1X7TfB4jvRXdgFnH3zrIdJ4o4qVtscEU
         QKfIVUmKadSvInBvgU76Ps2YyqwcdJYehT+KF3umqkiN02sZsX5p+KYfWgvFzHhGn2Gl
         7KBZWoi6j1YFPr6KHvcSYwrTsJLbxSXT6vDEKkKKYYtnO/QXsmqve4NN3SvMO3Y+ZauQ
         W5kQ==
X-Forwarded-Encrypted: i=1; AHgh+RpBcyJZCtlkP3iFxBrCyk4Z4tDgTE2OrbU4lmQJpyTxAQK7th7kh+67v5R9Y2CArZIZRgV6YU6OkA==@kvack.org
X-Gm-Message-State: AFuF++lkUrufKwkT1wxluQI6X7HlxMWA8M0W5oR8Al+4MsBVQPu/32CZ
	dZpi2kq5D0PFTEMhulqoIYGWvJ/Ff2j5JoJlZBNSGvRni4Iy50c7d0vAgFYxvEjSSLwk/oG7ocq
	lT3wc08disTQ0jNJhRLD5MCMr1TqjKeg=
X-Gm-Gg: AR+sD10joAhSQV6eg+97YPu3eCNRs9Z57uF7yoJyNraSz0jIvKDi5aaIN9wEzIrk8ai
	B1W1INHKUbA+xIIoRKqnXwpHSw2C+o9XLQ5+NxWNH00txemusjWEdwWzemNdJkeJW98VPvuSeBy
	Zmh7y/98LvzySxxnub/7tkz5DeVsgP6mkPttxkBFkgaIXTv1Ro3NTh7QUIS0hI3NqzHWd/6X+nk
	wdMjsI2tpW9CmxTOlKDRXScgwoZtIORHO70ls6Ug2vDOqPM+L9zyMIogVcFRUE+YhqGASIPWe+3
	91PvvhkAQj5i/VX6nqzTxyzmM/5SHA38wg71/UyX8T/cFg==
X-Received: by 2002:a17:90b:1f8f:b0:38d:f5bb:e0f4 with SMTP id
 98e67ed59e1d1-39580840520mr7436125a91.1.1787135885419; Wed, 19 Aug 2026
 03:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260818133206.39503-1-anshumantewari123@gmail.com> <9efc3c26-61fd-4bf4-bc0a-cb3e4b6120cc@arm.com>
In-Reply-To: <9efc3c26-61fd-4bf4-bc0a-cb3e4b6120cc@arm.com>
From: Anshuman Tewari <anshumantewari123@gmail.com>
Date: Wed, 19 Aug 2026 16:07:53 +0530
X-Gm-Features: AcwNN1Wy0jWe1F80pKg1gxUdzA-UOcRCb9WNGiSKiSRcU4wjYml7Eqm2n0GT6pI
Message-ID: <CAJqi8kL8ttTA=_uuqSoegDpdJvXvn62vN5uv60i37ukS-0PFyQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: fix unchecked ftruncate return value in
 soft-dirty test
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000009da674065963ff31"
X-Stat-Signature: 7rnes3atf4gk1g4dc8qrb1rmypy4qg1g
X-Rspamd-Queue-Id: C1B22A0008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787135886-80812
X-HE-Meta: U2FsdGVkX18LJkfzaxJlA0L9eZVttR5BydzXDYlStsLnSnCY8gyepnJg3fQGsdsB0DcVSKZmrxaouDrbth8Xr6e6r2X5qs03IQTJLv6tSyGxJT3VZfA++ZkYBjVBGuwqlb/kP/74LhanD6noH+lVaFZz1am6FPpAAEgvDc6YufrqGD8jWVxVkcnR0JyUSvDjXCUrAyMOYTVRlUumZxBuzymHeMdztinfWN0CYnZB0i+aL4COVtCnp/nyZbQXeqGoEeJfFFGaIAoOYGrOkinK+Qdg0rsoP4TbZe1UuFuo0Q/chtEfrqRgL33GtE0D3ua22ltaqWOI1oXsV1e0F96vXe/l1lJr1Dm4H3tvffszuqqMUnRcgnKed249tSxTeQwHnb490Ab+El59nVO/LvwHO7bvn2P8RTdo0ceWzNkEKWoYaHzAmYwNpqtA6mkZA4LEa2SYfwcE3A2c3uDdxtXRL7Z19Hf9ZWPQzu5789doWxwzPrJma36n1QMv77jhhNhWLIEbmvlCcNy5xzlSUO6US9Ffb/a/iBm3Pm/ziZKktUccvQQ7iZsCg1KXqwhRROj8MEyEBN7Yg4ynBXlB2bYjqGKOReKbnspEvIpCKOjRH8dl5nPqjmeB9IjKD4h7dvx5LS8dVIgAbZQ9iosMXk6hbJTUwx/tWrO4yxXoggCyo59KBXdIlPwBQOv3qaQHnk87FckkjRVSJd7EiHLplbgcNgcogbAa9A1hLym4kd95gy7UBTOvJIJ+GCM0e7TZe7rSHwQpyRxVhhk/T7Dfy0RbJCoU5upvFwySiN5Vd2WIT3WbjBwGWbWPkMy15ZBuSDMpbYFSkN6gWUJj0uCC1vXsCKm8SIV4jp2OfSg6DcXuXebi6SQwB1udQomws2P5yXQRy5cw37dFHpd3h8gSDY8lK6yScZZJIBmsSqi8WqK9lPyxVuwHCto905G8+ANNoeqbesWCdIfnzoj20TYDhH4
 nLgavKe5
 BYJZk/2jc45SFjNipMi1WXez5pciRDbuvoYOjRn4T3yfgmsOijPL0bpVa2jmtEo8TU2fbMReGWqXHgo7AougRSPg0DYlzEFyQf5Cgbu0+vT8pbzchCNYHFvGlmOO6LfMFhbybkoiv7BVA/ndJoNdcL/lnCsa8ZrHpPv356EaHGcHHDcuCY+c+aS4rfjVo2Zqh4ZrjQ061svsrEPdcHpF1lQVtfFkxr/Y03JIn7kafJ5zJfpmsQIRIi9GCiT7uAkCVJNdZvoC4q6OY5Q5v+2JDF8McUEEXTkDm7B0ZmO6i9mpRJwH9ZY9RLMrJbBWDiXNot7Cbvf1dJzyR3D9YiRInHl34EBKwcImr3o4m+fyzq/oPVaQ7PIrlCGpVipd/85f3WsTWlmeW4K0qp+QDeFhiuxMcOTc3nQeFTwnlmnZxTtKTVQJKGjnRG10Z613SlS3T63r6Xh2y8cjE81D+X7vlbTG8V5Ryqnf8O5ktZxV0Q66L7X74M0JTOoes3u6P4dqjLwgACaglb3F0m8NJ0AuUqJA5WUwwNLzF2oH5ccxPDzTWwjvbjUf4Ml8tvgfmDU6N4Svy6WJYqWyVLYPXQwMkWNkYB5lwZVcGHWKQrGyMB4UELdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000009da674065963ff31
Content-Type: text/plain; charset="UTF-8"

Thanks for the review , Sarthak - I apologize for delayed reply . Good news
: Andrew picked it up into mm-unstable .

Anshuman

On Wed, 19 Aug 2026 at 09:35, Sarthak Sharma <sarthak.sharma@arm.com> wrote:

>
>
> On 8/18/26 7:02 PM, Anshuman wrote:
> > test_mprotect() calls ftruncate() to resize the backing file
> > before mmap()'ing it, but never checks the return value. If
> > ftruncate() fails, the file may remain shorter than the requested
> > mapping size. The subsequent mmap() with MAP_SHARED can still
> > succeed in this case, but the very next line writes directly into
> > the mapped memory (*map = 1), which can trigger SIGBUS if the
> > mapping extends beyond the actual file size.
> >
> > Check the return value and fail cleanly with ksft_exit_fail_msg() if
> > ftruncate() fails, matching the error-handling style already used
> > for the mmap() call immediately below it.
> >
> > Signed-off-by: Anshuman <anshumantewari123@gmail.com>
> > ---
>
> Looks good to me.
>
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
>
> >  tools/testing/selftests/mm/soft-dirty.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/mm/soft-dirty.c
> b/tools/testing/selftests/mm/soft-dirty.c
> > index fb1864a68..a52ef79dd 100644
> > --- a/tools/testing/selftests/mm/soft-dirty.c
> > +++ b/tools/testing/selftests/mm/soft-dirty.c
> > @@ -152,7 +152,8 @@ static void test_mprotect(int pagemap_fd, int
> pagesize, bool anon)
> >                       return;
> >               }
> >               unlink(fname);
> > -             ftruncate(test_fd, pagesize);
> > +             if (ftruncate(test_fd, pagesize) != 0)
> > +                     ksft_exit_fail_msg("ftruncate failed\n");
> >               map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
> >                          MAP_SHARED, test_fd, 0);
> >               if (map == MAP_FAILED)
>
>

--0000000000009da674065963ff31
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for the review , Sarthak - I apologize for delayed =
reply . Good news : Andrew picked it up into mm-unstable .<br><br>Anshuman<=
/div><br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" =
class=3D"gmail_attr">On Wed, 19 Aug 2026 at 09:35, Sarthak Sharma &lt;<a hr=
ef=3D"mailto:sarthak.sharma@arm.com">sarthak.sharma@arm.com</a>&gt; wrote:<=
br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex"><br>
<br>
On 8/18/26 7:02 PM, Anshuman wrote:<br>
&gt; test_mprotect() calls ftruncate() to resize the backing file<br>
&gt; before mmap()&#39;ing it, but never checks the return value. If<br>
&gt; ftruncate() fails, the file may remain shorter than the requested<br>
&gt; mapping size. The subsequent mmap() with MAP_SHARED can still<br>
&gt; succeed in this case, but the very next line writes directly into<br>
&gt; the mapped memory (*map =3D 1), which can trigger SIGBUS if the<br>
&gt; mapping extends beyond the actual file size.<br>
&gt; <br>
&gt; Check the return value and fail cleanly with ksft_exit_fail_msg() if<b=
r>
&gt; ftruncate() fails, matching the error-handling style already used<br>
&gt; for the mmap() call immediately below it.<br>
&gt; <br>
&gt; Signed-off-by: Anshuman &lt;<a href=3D"mailto:anshumantewari123@gmail.=
com" target=3D"_blank">anshumantewari123@gmail.com</a>&gt;<br>
&gt; ---<br>
<br>
Looks good to me.<br>
<br>
Reviewed-by: Sarthak Sharma &lt;<a href=3D"mailto:sarthak.sharma@arm.com" t=
arget=3D"_blank">sarthak.sharma@arm.com</a>&gt;<br>
<br>
&gt;=C2=A0 tools/testing/selftests/mm/soft-dirty.c | 3 ++-<br>
&gt;=C2=A0 1 file changed, 2 insertions(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/s=
elftests/mm/soft-dirty.c<br>
&gt; index fb1864a68..a52ef79dd 100644<br>
&gt; --- a/tools/testing/selftests/mm/soft-dirty.c<br>
&gt; +++ b/tools/testing/selftests/mm/soft-dirty.c<br>
&gt; @@ -152,7 +152,8 @@ static void test_mprotect(int pagemap_fd, int page=
size, bool anon)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unlink(fname);<b=
r>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ftruncate(test_fd, pa=
gesize);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ftruncate(test_fd=
, pagesize) !=3D 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ksft_exit_fail_msg(&quot;ftruncate failed\n&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0map =3D mmap(NUL=
L, pagesize, PROT_READ|PROT_WRITE,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 MAP_SHARED, test_fd, 0);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (map =3D=3D M=
AP_FAILED)<br>
<br>
</blockquote></div>

--0000000000009da674065963ff31--

