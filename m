Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74E53E6528B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 02:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0EA6B0005; Sun,  1 Feb 2026 21:31:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28ECE6B0089; Sun,  1 Feb 2026 21:31:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166A46B008A; Sun,  1 Feb 2026 21:31:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0628A6B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 21:31:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 916D9140A36
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:31:32 +0000 (UTC)
X-FDA: 84397940424.30.E296BA4
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58A74140002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:31:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AP0JSBHQ;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769999490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0R0s9vfE0bIBviBc0aSDI6a/pNvYjpmbLNEjNXyfVKo=;
	b=DK0greixj42BiLiv3lnj03NJ5LK+N0oET9kQIj3f7bZZVrMhELQIPryulkD//YYHzOv5nh
	ph0PwlofaMAsfL1IDsxEREdSegFqBu4C2F28TF+Jjm35NqZh5RVF3QNdhsxkUXaiutdZ6s
	YmUcNfpxEGriwdSvYfMCdgDmuAJoTC8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AP0JSBHQ;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769999490; a=rsa-sha256;
	cv=pass;
	b=58+fcS016Ft+3rRDy52wUKaobgWxj805YXS07DkaNAeH6i34Fk3lAXMm/2EdwPLj0LdvuH
	mwU/2MMHbVPNJA5iWZF+LcHk6OvEqV6F2Ckfa3A8CpJF1NhSqbLaKbIDiRWgUvHR5tIRVk
	AM69JCTCLUHWtRwnpw7iKWZfOCzRVj8=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so4875419a12.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 18:31:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769999488; cv=none;
        d=google.com; s=arc-20240605;
        b=kGI9Jc5smtXq+WS8/uYC/HJYj7OeJRFFf6X7bfsbnXfNcvELRuz+y+HFuCgTJBSpcE
         C46JLwCpQtedNYOSWi/3nBT9KhrF4f4yQ7Ew6CDwwPAZFhqxaiiT7PMbzEOkiECURC1H
         6eQ2onEFEMJym87lTCz3d85qO4F23BmIB+Uh79eoP6WPSk3/NMx54I/kizXVYui8QO2i
         FZJDm0otLXMoHhX7NdaVzLs3DUhkkmCx8llrvq6dh++Pe8XoN3bI3H3gGckJnN8Y1UQY
         YpUaYHK6W0A3Za3tzJLhkzNwOUEqKnBHlOZCzQnP7cizBNbQSGLs8bwR5EFWxI1HAAc8
         8I2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0R0s9vfE0bIBviBc0aSDI6a/pNvYjpmbLNEjNXyfVKo=;
        fh=/M6izUITbQHV51XpAlhPrY4uuarulwks39xuCYuWN1E=;
        b=Xg2BCRgPfDKPIk4HIu4/VBOhiR+vXkZsi74SunXLKcRPdj4wCZvDSTimVk5msEX7Aq
         1BvMeDHxkgyKJqll0oBuFTY8wPIpVA33hOfdSfgqJ9bMC5Et+j8u3N7tEYei9RC3LO6r
         0ixXaGKFSBJ0TWIm/7JH6z+eEYo0UiH0z4W7thaGj3dg8SE0tO0CLYOS8g9VzhR+XN7w
         pI5J0kuPX6uaHQvSSC1ngRpnAl644aBRwdNi+9Zv0AUeiufQJ9FLtW8DRW0Y5HntQpoA
         1+aI9o8hiciQ35ccG4mjn9qiXsnkushqjFK3m38Bv7jtfnfOONC38jIjvZia/33rQKGy
         +jhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769999488; x=1770604288; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0R0s9vfE0bIBviBc0aSDI6a/pNvYjpmbLNEjNXyfVKo=;
        b=AP0JSBHQ67NSy7/9ihEMYNul4XQeX/hjLe8cGTGSB8jVYcBaFed578ONeCwlCeQ9aE
         OsgcFrU/wWYyPjku4yWd3XxAFWbCYBXeJryZtDWiwtC3yNVGy2Hg6bCcW89RcPCNgPnL
         HoiIcL8kv8SdWM8+A4gWTtOOqFFmECFIMabVv1Juy97sObzL5mBVYggbocX5ekd2dDGs
         eU3BkjpwTyiIehFAntFROWFe+TbtRaOLwawGQNpv/sDFJjcaMmJxXo/XEa8WWJ4wJUNH
         gjdZEG7sEDbHnOslIqMPXuxzbvksbyxSKQsBnRkMIT8v4U9XLRHJi/QnDk7Z/IRrs2DK
         ZgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769999488; x=1770604288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0R0s9vfE0bIBviBc0aSDI6a/pNvYjpmbLNEjNXyfVKo=;
        b=WPah0PgUaLxYFR+LfNbHqATA8Jzi5sensVoIVtjdScdJwKhcNbu/XFgpog5Ywzy+QE
         4tm/eQv1ehucc2TEepWv3kd8KEokQ4yI9uaSyb68iXgVM/4g0CAj/YKO6mMraXhmsjCj
         mrX8bWuU761qqiS5VykwN/ZrIm0TMqfqH6ABPhC1AVH2I+EOvDTaNH9bqVXQ7yU3BVX+
         PNkdbaNtYSgjS/eA0NfJDj6ytK0P52N2EAl4FktrASOngoLXwMMYw9TMigMdiG3K2Y8D
         OWpB8YlzTLQAGR8ftNrAXP+iltQYcsCvBfeVVOVmHPJgI3afVpRYjA5nA3IPXNdCkZCo
         tV/w==
X-Gm-Message-State: AOJu0Yyq+coz+GXLJn0boifpbVKnosu/not6XtgRc7FQs97HBf/uxJ9Z
	8M6dnjY5jrZ+HTD0OcgHBaVHgFzcl10Q0h2vq+C2Kw9JNVqwKMS7mo98n4w9CXWQGT3NWT37Ywr
	6VZZv7zilkZ1mfjOMTOpsvmDimXQKXqs=
X-Gm-Gg: AZuq6aIfMR0u0cHlXRjf7XG/1W/8jQRnvvGECt6iXpVD34jsET2MVNqDdfvqdlSmtHd
	HRbvK0mOez9B5YpkEnCtkjJgs+SI5Y9Cn/JBsvIw7Wn/6By/xRnXit6xeG5FGRXSzd9osm07x9O
	IVwf+WWnujQ4AAwAaFeMXDI7hNNWAQy5JzMGjCmbHiTj/di+cgPGajioasbF5DxCtixZoxSYLUi
	ZUNPRFXsefosj6qRxWa+Y5uMqcdd/8gQXZjOFWMF1Sw1e/xwguN20n8PFs6x+OOUmWftqYcSr38
	Hp+BEYEqt48Ricxm6KTLPrjhaZlX
X-Received: by 2002:a05:6402:399c:b0:658:bc1d:a5cd with SMTP id
 4fb4d7f45d1cf-658de568630mr4904459a12.13.1769999488114; Sun, 01 Feb 2026
 18:31:28 -0800 (PST)
MIME-Version: 1.0
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
 <20260128-swap-table-p3-v2-6-fe0b67ef0215@tencent.com> <aXsMHy0rNreGmnLS@yjaykim-PowerEdge-T330>
In-Reply-To: <aXsMHy0rNreGmnLS@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 2 Feb 2026 10:30:51 +0800
X-Gm-Features: AZwV_QiUDvJZ3Ov0Fyw1B-9Z0WMw8IDrK2KIT-1QRD_5rjs13jRowQVbYSaoAnQ
Message-ID: <CAMgjq7C3fTUfCAUYPQY5x_7gsM8TJ5Vw+rFSLgDZ7NOyTyyKOA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] mm, swap: implement helpers for reserving data
 in the swap table
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mabb8a555adogypymuwh815z3ubgqce8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 58A74140002
X-HE-Tag: 1769999489-929069
X-HE-Meta: U2FsdGVkX18ezKdIECXIsxLU8zVtSCO4v7ly6F6zV+fyn5PSdBvYRX7imgypxmr5cMFGLqMVgZRwkSxdZR3e+z8JUISVOJ5x+ESRySdUH+UcpLgXs170GMEKgwav/lWM3GcWnsk07brHk5bx9b3dHoF8D6cN9aZ+VdTMtfzznN/EOl59wlUJQcltG19ns5859UXGiBCr6lsaU+xRwuHsViBxtr7teGRG/gjWAb7/6Dap079vkF6yKPxcC7160/ktmC2/6OunX/r4Q9EeI9C005PD8NIXfW68Y+81Zl5Z3W6tb+iEaOe7uONfdymF2vTOqGQYK8Aw5zTFUNCf3+HG5AD+dHnpQU/JEF/aCwPnrVuhH3P+d2t709RU5ujwnYFoSFJeGK5VilBJ4FbZTSp4CaE+yzI3WdTvHx7ROQEljwJlpBGa0xT27bDAsemfxsffJKUnDYpIO+2bvH9H6l3FStH2btRt1fH+zXprhgKpxdsYQ4EYviBJAcPThD/iniIApsE96JmGbXj/hRCdI2GChU80COTc8MO88AQ+lsn80Qm6fw1ZoapuFm5qPa2xhKhN8fwBFybdmqVlc2vBdy6lejzPe61d+ZLpNm/WfAD4mrArr3NV239LPL384gekKdvc4zgFhidRa1aFGdLskLPbQV5+G/p+u2q6/caaCokmx3iiyiFDswdDJkjXYOMv00wZPxm2g0yB3OnbE1nTfXC/Dl7t4J7emhoAPg6ci/2bMPxpvifEhyD4LsS3vPjYSyaFRnaH7g4N7sm7eBe60XBqOWpcx1PLoA2435/6Xj7c99sCtP0e49IyE7eTJHpGOPdqogVKqLnzu7HHuHH4NNDxhm46BoXKF0jujBPDLdmZUR3dztoN2mQP02C+nkGuHAf+r6iOYPqIUk3UkcuYH0R1+KSaQZVpotQrNuO/RNlpRlm02q0rnh32bc1UvvEImtpZYBI27Cv1jMpcq+IyU78
 iOsdR7rc
 3Juuuk7FKwGDQpDm0i1At/JuF1zH8mvNNwVA70BV6IqzwcONIMsC2w7H0hCO7PMOmsSisER6TmkdlTf+pV3b8maFW78P2Hy/5V5rIwpoF9tmzXDqP2LyB/9gSSsut0UgghEtR9veN3q4CDFxCf52hAZO1T37DaKW4CqMKfU16AxeXrrRPDOkmY1ls8xl+8/cwe3tH/JEDsvsBhHBgd7/n4rNNZB3inHvAiSdzaJ5u2DSMOPFgEmiH/F4nWQYO74o+TE/yt9bFBz0QYjf+5WLpiGIdU1iOFLEAoMBs7QnjDRybYvFgJRbQwD4hy1erRwz0hRbnCtBkKam4gHdT2DytgAZ7cljOr0X6AkeALci6aZXmeByK9ZMp8C2BewLp/w0PSujJ2O6k4Dg3y68kvL8TisVKngzi63n7KPSK/3Ysfv+FX+v0AVEDF1hnAazM1Y+C6ntt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 3:28=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Wed, Jan 28, 2026 at 05:28:30PM +0800, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
>
> > +static inline bool swp_tb_is_countable(unsigned long swp_tb)
> > +{
> > +     return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
> > +             swp_tb_is_null(swp_tb));
> > +}

Hi YoungJun,

Thanks for the review.

>
> What do you think about simplifying swp_tb_is_countable by just checking
> !swp_tb_is_bad(swp_tb)?
>
> Since this function appears to be called frequently, reducing the number =
of
> comparisons would be beneficial for performance. If validation is
> necessary for debugging perhaps we could introduce a separate version for=
 debugging
> purposes.

There are already two variants for getting the count of a swap table
entry: swp_tb_get_count and __swp_tb_get_count. Ideally callers that
know the swap table entry is valid can just call __swp_tb_get_count
for lower overhead, swp_tb_is_countable is less frequently used.

>
> > +static inline int swp_tb_get_count(unsigned long swp_tb)
> > +{
> > +     if (swp_tb_is_countable(swp_tb))
> > +             return __swp_tb_get_count(swp_tb);
> > +     return -EINVAL;
> >  }
>
> Or, could we simply drop the check in swp_tb_get_count and call
> __swp_tb_get_count directly?
> If we define SWP_TB_BAD to have 0 in the count bits (MSB), it will
> naturally yield a count of 0.

One reason I used `countable` and not `bad` is because I'd introduce
other type of swap table entries soon, i.e. hibernation type for
hibernation only usage. Calling swp_tb_get_count on them returns
-EINVAL or other error code, which I think is looking good. I'm open
to suggestions on the naming and design.

