Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA192EE57C8
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 00:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83CB06B0088; Tue, 30 Dec 2025 19:27:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8144F6B0089; Tue, 30 Dec 2025 19:27:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6266B008A; Tue, 30 Dec 2025 19:27:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5CD6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:27:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E59B38B712
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 00:27:06 +0000 (UTC)
X-FDA: 84277876452.16.3F37A32
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB87920004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 00:27:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dehwUT05;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767140825; a=rsa-sha256;
	cv=pass;
	b=jzpQYCOUHPMhyZaHo8aG1OqKA9BfHMI+mdGD+mTdbKUYPjMwHhjqhWlHlI6FBVfNdEJk3t
	0uI63J0lNwtgXrjw6gIPkx0qPZ4GQ6ksWN267eeQ8BTODvJPs8x2GLU5uxKR3hA+L4iqPD
	MGL8AdSvyfAm0brSE+bjRW9/HLlC+2o=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dehwUT05;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767140824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CSqmODw5YvKzFAuPbz3PPTFSGEdLpIuLOFXaeDkiHk=;
	b=thcR958pIBm1s+7kwXPZrucTjXQyuYt9Ibryy5o7iwz92jIBdvpp8vcR3iP/0WmET/9NPj
	SvGyMn3pYyfFsgrjz4pBrQKIdq9Bw2iXInZVuKk1wviwNPw008e8A7eDYOSPZHTdhRdMs9
	d2mBqNTFZesrggFPy7/FkbGd57/aBgo=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so2592a12.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:27:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767140823; cv=none;
        d=google.com; s=arc-20240605;
        b=fQjSR2/2uriscxhJoD1XEMtB+F0m0TJWlV9NGjHdTDUCCwqOaKL8Q9FbSy55JCJhpy
         EhyBoslUCAvAI0qCev3jOhobyM7z2jwsTFgXrxROTDAKxxIun/P4Q98FBtlj2AHPUM2f
         7lVjJeKOpGlEj9eYUQCpdrfuE9tOilAiOpbfuLvipqhVDY9+5VxJ6vri8IosfzURAI5F
         YwUyyWN0k5e54sa/62TgeTfpKDMDqEWsMNbExIkcGsOp5ESGIusSFESn8UfiJDtHox+6
         eIUbCBRU6VxJ05AlE8fFpGjK/XA48lVy4yfiorMDovwki6lHAvgf7fGL/lIdkSNMkFXc
         XKbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0CSqmODw5YvKzFAuPbz3PPTFSGEdLpIuLOFXaeDkiHk=;
        fh=vo8Q4F0Umz7eKFejzZbEr4CyKUH4JeiSEyDB3YrvNoU=;
        b=aKzaVDEQmZ/ChDI7voWnShOyoDMwt42RfeAph0K3JDBqa9taMRiG8dTqoZrIpwgZW0
         anLvhkIZ0YZqRZR61v1D7/AqlsOGV176vcboZWyE6HDybb03NbO3ktK8yh74PXzV+o11
         aEBghsWEnpa68ZERmN50JxiChUzTTFmI3y3cdmTPokrUzUvJwcfIm5dQp7t/w1CDgGzd
         E47KieTmwT7DKHJM2BjERtrxzbrK+VU1DR+rU5nHPCBP4mS+7LmVnLRfwGa3sPOYokIx
         TDyfKW6xSVSSLyFCDjXw3u/MI3CmC/YbIkrgAUKh9UYE4aPAt0kKLSuY8lDm3R2wE8f6
         9DUQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767140823; x=1767745623; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CSqmODw5YvKzFAuPbz3PPTFSGEdLpIuLOFXaeDkiHk=;
        b=dehwUT05EZI6CpPNDD+glgxpiuKyxEVk6eYozzBUXQABU1PmnngKO/qeIJHKAizCfy
         cpOzSNjG7Unwp4qSp6b1HqyJGR6OTEQV+pGq3TyGqVNzXzgT6gK0pD1q5efIsIQp5223
         X3OMvQcQ6ThM82AXQbOVxU/rT35eUqnYASruOyzTKCbHbqjCgN6Um2nyoICJQyfudTVu
         /oodSfzJKoxSx4w64THzvbHeuhisg4DtKyk9vIZeCZelvz0316eIN3YF41Xzg/HG2FY9
         eyIcA+iwnAJkYDEX098Y0D6qNDZG8XGZXlPdNRXsc4XOX3eUQ/cvQ9jjbU26zRGirsZu
         nYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767140823; x=1767745623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0CSqmODw5YvKzFAuPbz3PPTFSGEdLpIuLOFXaeDkiHk=;
        b=qQyjoikc/wFCB6+6Nd4KW+WdbVkyu8778YKJC3QcmT9X+N4I/6t7LsHKUIgzVLysAz
         +Ofl541j3WraHaFPsKqn3CyfxePooLvZp5zRg7M6nZlko4Ps0sefgsPw4tfOR9Gzxbil
         bU/x9GhI56ka8dOCFZEMgkI8AxIUEPjlIx9F4kIgKkEVYbpu+hKnLdrWq/vmOw2zgYGk
         C1Yo79iBcXBdF2+A5t/dctcsyLFtKBlano2Eyn/OBak600+vj6y4IgI1w0sSJEBSAO2s
         WHDrFP6MjLKVRlletxiqXcKhbn/YsUo7YYgR5RYppkPXdfW5P8dYIln+aPXjoax9+KKy
         HRYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZE08fMk/RoukaDyEooBfi6g5KH1g3ptDY0GlJFMZb4ALdMl7IiMgx0WttFEV0Z8LbxfHTKTx0Yg==@kvack.org
X-Gm-Message-State: AOJu0YyrcZnolVPk0dXAgusKOObthEAZBORO0yvHvoNv/fG9eIj5vcS1
	+9bHwDl7yA4gXInSw9Dsb3r+1o59jGFzpR24LeZ0oi4SDxc0wYG9P9Cc/rxYtMTN1zAimnhT6Ng
	zDF3yeRI6BJ3ekyK2nQ3NVG60boPmA6qmX+jRv9kYC+EOd3EhUWtexGgdFrs=
X-Gm-Gg: AY/fxX5GypmwpUNm8VGkpeqAagaQUe140xH9qEGlF4IjFkh40diO6XkzWKE4zc9yY1j
	4ipYhFMchqA54BVOKBKlplqEKqqYZzkk9jpm7T5yT3SS6DMOwQTb9f71TK7U+ApH8PM0svb3k4I
	Md+rNle4xpeQyYDbzMT9Y4UDkK5Mb+/NwLAzF3neEiLH7hTxdA8o4j5CXojOyGm/s9Vgoc3nqeX
	cCudFdm+PkE9qbpUUiu9GBQ7w9RqAqEBZBq7OT++L5CvFHpjlAqhyQ3uj/DjT31fLr2pQVYSc7s
	aGiL6sh04mXT5JlRVFgfUH6+vQ==
X-Google-Smtp-Source: AGHT+IHWTMPoFlnHsjkFfNaiw05AP7xHldIbGGvsGmx0jxTL37jT2QKUhwjdaAeBPWHiQ6+q7y6e/GTIyenpA9VLlGU=
X-Received: by 2002:a7b:c8d7:0:b0:477:95a8:3805 with SMTP id
 5b1f17b1804b1-47d61ebb5edmr98055e9.15.1767140402405; Tue, 30 Dec 2025
 16:20:02 -0800 (PST)
MIME-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com> <20251219183346.3627510-3-jiaqiyan@google.com>
 <aUolGHkJQwKi0A8A@hyeyoo> <CACw3F52hZp+xC51bK=UfrfdAWdFEEqhsiJY2+0fzCLzB_3=XYg@mail.gmail.com>
 <aVHWOMa9n40_8Yu3@hyeyoo>
In-Reply-To: <aVHWOMa9n40_8Yu3@hyeyoo>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 30 Dec 2025 16:19:50 -0800
X-Gm-Features: AQt7F2pPPo6bZeWK7E_-mYf6Z0-muPfrUVX5AWoCWy_ILbofsK9vqDo9PUlGXfE
Message-ID: <CACw3F53p9TyAZs2pn+aHo85=aZx0+unaoLjeFtEK8DJ8A5TD4A@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
To: Harry Yoo <harry.yoo@oracle.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, willy@infradead.org, nao.horiguchi@gmail.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BB87920004
X-Rspamd-Server: rspam03
X-Stat-Signature: eurtqj4s8cbx3iekn5569t9jm78ydyhs
X-Rspam-User: 
X-HE-Tag: 1767140824-46015
X-HE-Meta: U2FsdGVkX19x197ieZwvqbUdDv+oNtkScVHgeWzPlL4e9TWqrnGvkGUCq3RHiWXbg2HS/ZaleDe4cHIqWNbiRmYkFMU7dhJ7eVTNleVwCuLCkdJ6QH0yKPWXSAS1HgjFz0jNQokDeUE5EnvNH2ZdcOEWwwgURnQPVR3gcHDa9Jut10TmN6Pc1Bj0RkP4TjjnCwkb/bhRL6pfVi4HMfXVbg4XA/2XQfLKr05O0bdCHyNq2V251KSidg7GgVi5lFru6j5th1UV5dL1YIOG0ADDZ9e0MWwFWBLHWJYXC/vbEkKlAc4wLBm+yHnDIKGDIw20sRTx2/HGEi/72xRIcvW8mOt8Aa5cYSdvbS8RoBFVpzOcnAyLXXb0zTwNyzvSIRZNatwwvtVkhiEX5sX0YlOJZY4mtVcqDNoZVQG/fTr718Z2Jg7Qg6PbRGeVvLFo3drc7nYbRlABdhlrrYO5V7F640oOVnfSqkKkboxRuiXLq5UyZTcxibPXYefGW9IxLyY3rsajXmECXFvu/PbG98bKw8SZTfyJS4g0t7f2CgRS62/1XcEWhDqYV7hce8lMNk6uF959+X8djX5rksPXU1s/rDQPmEEZYOE5ZSeQNChVdJz/VJfw5+dKtuqlnuUnan6rvL/Dg6qV0KtpGmKFqcPdqhcS3Yy/xfjJwvLrbkUXuR8tOoYbNmuiAey+hRsqG8Iff+6vMBmKvofOZ/WI72XUOv/aooJRVt5wPHHGFq+kel3eP+ITFirJ4woOxbxe+Je+rJoPpmPmswzZhWTUgooa/6GqYTTr28a1NAH8W3Dv9Jlm+qo3mEBTxFNsVGCL/vvAnZ06xKLZTZxeU5KE+y1/C550XNvA9AAosvZqGDr4W7rXRTiWLAeFaedUAEiccfXxmob7DIs4247uZYaryi7WrSgp7CP3zQxOWQeyl4aGl8GBY1uoEUh/54WHK8ct8Gu+LTVy7UJO3ZU2qE75yWZ
 XbJy4b1C
 xw4tkUQNUj+QzvKua4ATotd1oxrYZz1YuD+ThWBGCl7tajFNzkq8OyyMuUuqtsS+Xu88qgg2rdCn070gijIy6cTJE1owa/tjM3C14uaKpRqwfIFJizSOagKzzhnraGVea5L0qwgd2tyYJ6JYxK58m+PxeRkia4cAjovu9QoRICXkibVMiogOqLmU1wrgKCGY0iKoORxvwHIvBwmiHxZjTvDAAXFQ5iyHS7WjDO82piZ35pfVZN610AUvRrlFugeQOBWfaL6NS4TMrgP7znOsQ75nwNHFry4aKl8YQwi2VJ7ZXei9WHZs3XZ+AYfmSSa0qTq3wVBhJ9QHWDm5skOSxvM3CSawB4XSDRGM9M0icmfBHijHerm/xvwAKqR6uG1PXRZ11CrXRlQvsqF4ViIdFwkgHRHAd26rX4VeRLCkaKs6GQ0rmMUZSX0vtztpERQbvAUVoN2WvJIqnrKXzhd1sVcKhb3sXDTlWdRhT1qo/S/CP39c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 28, 2025 at 5:15=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Fri, Dec 26, 2025 at 05:50:59PM -0800, Jiaqi Yan wrote:
> > On Mon, Dec 22, 2025 at 9:14=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > >
> > > On Fri, Dec 19, 2025 at 06:33:45PM +0000, Jiaqi Yan wrote:
> > > > At the end of dissolve_free_hugetlb_folio that a free HugeTLB
> > > > folio becomes non-HugeTLB, it is released to buddy allocator
> > > > as a high-order folio, e.g. a folio that contains 262144 pages
> > > > if the folio was a 1G HugeTLB hugepage.
> > > >
> > > > This is problematic if the HugeTLB hugepage contained HWPoison
> > > > subpages. In that case, since buddy allocator does not check
> > > > HWPoison for non-zero-order folio, the raw HWPoison page can
> > > > be given out with its buddy page and be re-used by either
> > > > kernel or userspace.
> > > >
> > > > Memory failure recovery (MFR) in kernel does attempt to take
> > > > raw HWPoison page off buddy allocator after
> > > > dissolve_free_hugetlb_folio. However, there is always a time
> > > > window between dissolve_free_hugetlb_folio frees a HWPoison
> > > > high-order folio to buddy allocator and MFR takes HWPoison
> > > > raw page off buddy allocator.
> > > >
> > > > One obvious way to avoid this problem is to add page sanity
> > > > checks in page allocate or free path. However, it is against
> > > > the past efforts to reduce sanity check overhead [1,2,3].
> > > >
> > > > Introduce free_has_hwpoison_pages to only free the healthy
> > > > pages and excludes the HWPoison ones in the high-order folio.
> > > > The idea is to iterate through the sub-pages of the folio to
> > > > identify contiguous ranges of healthy pages. Instead of freeing
> > > > pages one by one, decompose healthy ranges into the largest
> > > > possible blocks. Each block meets the requirements to be freed
> > > > to buddy allocator (__free_frozen_pages).
> > > >
> > > > free_has_hwpoison_pages has linear time complexity O(N) wrt the
> > > > number of pages in the folio. While the power-of-two decomposition
> > > > ensures that the number of calls to the buddy allocator is
> > > > logarithmic for each contiguous healthy range, the mandatory
> > > > linear scan of pages to identify PageHWPoison defines the
> > > > overall time complexity.
> > >
> > > Hi Jiaqi, thanks for the patch!
> >
> > Thanks for your review/comments!
> >
> > >
> > > Have you tried measuring the latency of free_has_hwpoison_pages() whe=
n
> > > a few pages in a 1GB folio are hwpoisoned?
> > >
> > > Just wanted to make sure we don't introduce a possible soft lockup...
> > > Or am I worrying too much?
> >
> > In my local tests, freeing a 1GB folio with 1 / 3 / 8 HWPoison pages,
> > I never run into a soft lockup. The 8-HWPoison-page case takes more
> > time than other cases, meaning that handling the additional HWPoison
> > page adds to the time cost.
> >
> > After adding some instrument code, 10 sample runs of
> > free_has_hwpoison_pages with 8 HWPoison pages:
> > - observed mean is 7.03 ms (5.97 ms when 3 HWPoison pages)
> > - observed standard deviation is 0.76 ms (0.18 ms when 3 HWPoison pages=
)
> >
> > In comparison, freeing a 1G folio without any HWPoison pages 10 times
> > (with same kernel config):
> > - observed mean is 3.39 ms
> > - observed standard deviation is 0.16ms
>
> Thanks for the measurement!
>
> > So it's around twice the baseline. It should be far from triggering a
> > soft lockup, and the cost seems fair for handling exceptional hardware
> > memory errors.
>
> Yeah it looks fine to me.
>
> > I can add these measurements in future revisions.
>
> That would be nice, thanks.
>
> > > > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-em=
ail-mgorman@techsingularity.net/
> > > > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-em=
ail-mgorman@techsingularity.net/
> > > > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.=
cz
> > > >
> > > > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > > > ---
> > > >  mm/page_alloc.c | 101 ++++++++++++++++++++++++++++++++++++++++++++=
++++
> > > >  1 file changed, 101 insertions(+)
> > > >
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index 822e05f1a9646..20c8862ce594e 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -2976,8 +2976,109 @@ static void __free_frozen_pages(struct page=
 *page, unsigned int order,
> > > >       }
> > > >  }
> > > >
> > > > +static void prepare_compound_page_to_free(struct page *new_head,
> > > > +                                       unsigned int order,
> > > > +                                       unsigned long flags)
> > > > +{
> > > > +     new_head->flags.f =3D flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> > > > +     new_head->mapping =3D NULL;
> > > > +     new_head->private =3D 0;
> > > > +
> > > > +     clear_compound_head(new_head);
> > > > +     if (order)
> > > > +             prep_compound_page(new_head, order);
> > > > +}
> > >
> > > Not sure why it's building compound pages, just to decompose them
> > > when freeing via __free_frozen_pages()?
> >
> > prepare_compound_page_to_free() borrowed the idea from
> > __split_folio_to_order(). Conceptually the original folio is split
> > into new compound pages with different orders;
>
> I see, and per the previous discussion we don't want to split it
> to 262,144 4K pages in the future, anyway...
>
> > here this is done on
> > the fly in free_contiguous_pages() when order is decided.
> >
> > > > +/*
> > > > + * Given a range of pages physically contiguous physical, efficien=
tly
> > > > + * free them in blocks that meet __free_frozen_pages's requirement=
s.
> > > > + */
> > > > +static void free_contiguous_pages(struct page *curr, struct page *=
next,
> > > > +                               unsigned long flags)
> > > > +{
> > > > +     unsigned int order;
> > > > +     unsigned int align_order;
> > > > +     unsigned int size_order;
> > > > +     unsigned long pfn;
> > > > +     unsigned long end_pfn =3D page_to_pfn(next);
> > > > +     unsigned long remaining;
> > > > +
> > > > +     /*
> > > > +      * This decomposition algorithm at every iteration chooses th=
e
> > > > +      * order to be the minimum of two constraints:
> > > > +      * - Alignment: the largest power-of-two that divides current=
 pfn.
> > > > +      * - Size: the largest power-of-two that fits in the
> > > > +      *   current remaining number of pages.
> > > > +      */
> > > > +     while (curr < next) {
> > > > +             pfn =3D page_to_pfn(curr);
> > > > +             remaining =3D end_pfn - pfn;
> > > > +
> > > > +             align_order =3D ffs(pfn) - 1;
> > > > +             size_order =3D fls_long(remaining) - 1;
> > > > +             order =3D min(align_order, size_order);
> > > > +
> > > > +             prepare_compound_page_to_free(curr, order, flags);
> > > > +             __free_frozen_pages(curr, order, FPI_NONE);
> > > > +             curr +=3D (1UL << order);
> > > > +     }
> > > > +
> > > > +     VM_WARN_ON(curr !=3D next);
> > > > +}
> > > > +
> > > > +/*
> > > > + * Given a high-order compound page containing certain number of H=
WPoison
> > > > + * pages, free only the healthy ones to buddy allocator.
> > > > + *
> > > > + * It calls __free_frozen_pages O(2^order) times and cause nontriv=
ial
> > > > + * overhead. So only use this when compound page really contains H=
WPoison.
> > > > + *
> > > > + * This implementation doesn't work in memdesc world.
> > > > + */
> > > > +static void free_has_hwpoison_pages(struct page *page, unsigned in=
t order)
> > > > +{
> > > > +     struct page *curr =3D page;
> > > > +     struct page *end =3D page + (1 << order);
> > > > +     struct page *next;
> > > > +     unsigned long flags =3D page->flags.f;
> > > > +     unsigned long nr_pages;
> > > > +     unsigned long total_freed =3D 0;
> > > > +     unsigned long total_hwp =3D 0;
> > > > +
> > > > +     VM_WARN_ON(flags & PAGE_FLAGS_CHECK_AT_FREE);
> > > > +
> > > > +     while (curr < end) {
> > > > +             next =3D curr;
> > > > +             nr_pages =3D 0;
> > > > +
> > > > +             while (next < end && !PageHWPoison(next)) {
> > > > +                     ++next;
> > > > +                     ++nr_pages;
> > > > +             }
> > > > +
> > > > +             if (PageHWPoison(next))
> > > > +                     ++total_hwp;
> > > > +
> > > > +             free_contiguous_pages(curr, next, flags);
> > >
> > > page_owner, memory profiling (anything else?) will be confused
> > > because it was allocated as a larger size, but we're freeing only
> > > some portion of it.
> >
> > I am not sure, but looking at __split_unmapped_folio, it calls
> > pgalloc_tag_split(folio, old_order, split_order) when splitting an
> > old_order-order folio into a new split_order.
> >
> > Maybe prepare_compound_page_to_free really should
> > update_page_tag_ref(), I need to take a closer look at this with
> > CONFIG_MEM_ALLOC_PROFILING (not something I usually enable).
> >
> > > Perhaps we need to run some portion of this code snippet
> > > (from free_pages_prepare()), before freeing portions of it:
> > >
> > >         page_cpupid_reset_last(page);
> > >         page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> > >         reset_page_owner(page, order);
> > >         page_table_check_free(page, order);
> > >         pgalloc_tag_sub(page, 1 << order);
> >
> > Since they come from free_pages_prepare, I believe these lines are
> > already executed via free_contiguous_pages()=3D> __free_frozen_pages()=
=3D>
> > free_pages_prepare(), right? Or am I missing something?
>
> But they're called with order that is smaller than the original order.
> That's could be problematic; for example, memory profiling stores metadat=
a
> only on the first page. If you pass anything other than the first page
> to free_pages_prepare(), it will not recognize that metadata was stored
> during allocation.
>

Right, with MEM_ALLOC_PROFILING enabled, I ran into the following
WARNING when freeing all blocks except the 1st one (which contains the
original head page):

[ 2101.713669] ------------[ cut here ]------------
[ 2101.713670] alloc_tag was not set
[ 2101.713671] WARNING: ./include/linux/alloc_tag.h:164 at
__pgalloc_tag_sub+0xdf/0x160, CPU#18: hugetlb-mfr-3pa/33675
[ 2101.713693] CPU: 18 UID: 0 PID: 33675 Comm: hugetlb-mfr-3pa
Tainted: G S W O 6.19.0-smp-DEV #2 NONE
[ 2101.713698] Tainted: [S]=3DCPU_OUT_OF_SPEC, [W]=3DWARN, [O]=3DOOT_MODULE
[ 2101.713702] RIP: 0010:__pgalloc_tag_sub+0xdf/0x160
...
[ 2101.713723] Call Trace:
[ 2101.713725] <TASK>
[ 2101.713727] free_has_hwpoison_pages+0xbc/0x370
[ 2101.713731] free_frozen_pages+0xb3/0x100
[ 2101.713733] __folio_put+0xd5/0x100
[ 2101.713739] dissolve_free_hugetlb_folio+0x17f/0x1a0
[ 2101.713743] filemap_offline_hwpoison_folio+0x193/0x4c0
[ 2101.713747] ? __pfx_workingset_update_node+0x10/0x10
[ 2101.713751] remove_inode_hugepages+0x209/0x690
[ 2101.713757] ? on_each_cpu_cond_mask+0x1a/0x20
[ 2101.713760] ? __cond_resched+0x23/0x60
[ 2101.713768] ? n_tty_write+0x4c7/0x500
[ 2101.713773] hugetlbfs_setattr+0x127/0x170
[ 2101.713776] notify_change+0x32e/0x390
[ 2101.713781] do_ftruncate+0x12c/0x1a0
[ 2101.713786] __x64_sys_ftruncate+0x3e/0x70
[ 2101.713789] do_syscall_64+0x6f/0x890
[ 2101.713792] entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 2101.713811] </TASK>
[ 2101.713812] ---[ end trace 0000000000000000 ]---

This is because in free_pages_prepare(), pgalloc_tag_sub() found there
is no alloc tag on the compound page being freeing.

> In general, I think they're not designed to handle cases where
> the allocation order and the free order differ (unless we split
> metadata like __split_unmapped_folio() does).

I believe the proper way to fix this is to do something similar to
pgalloc_tag_split(), used by __split_unmapped_folio(). When we split a
new block from the original folio, we create a compound page from the
block (just the way prep_compound_page_to_free does) and link the
alloc tag of the original head page to the head of the new compound
page. Something like copy_alloc_tag (to be added in v3) below to demo
my idea, assuming tag=3Dpgalloc_tag_get(original head page):

+/*
+ * Point page's alloc tag to an existing one.
+ */
+static void copy_alloc_tag(struct page *page, struct alloc_tag *tag)
+{
+       union pgtag_ref_handle handle;
+       union codetag_ref ref;
+       unsigned long pfn =3D page_to_pfn(page);
+
+       if (!mem_alloc_profiling_enabled())
+               return;
+
+       /* tag is NULL if HugeTLB page is allocated in boot process. */
+       if (!tag)
+               return;
+
+       if (!get_page_tag_ref(page, &ref, &handle))
+               return;
+
+       /* Avoid overriding existing alloc tag from page. */
+       if (!ref.ct || is_codetag_empty(&ref)) {
+               alloc_tag_ref_set(&ref, tag);
+               update_page_tag_ref(handle, &ref);
+       }
+       put_page_tag_ref(handle);
+}
+
+static void prep_compound_page_to_free(struct page *head, unsigned int ord=
er,
+                                      unsigned long flags, struct
alloc_tag *tag)
+{
+       head->flags.f =3D flags & (~PAGE_FLAGS_CHECK_AT_FREE);
+       head->mapping =3D NULL;
+       head->private =3D 0;
+
+       clear_compound_head(head);
+       if (order)
+               prep_compound_page(head, order);
+
+       copy_alloc_tag(head, tag);
+}

I tested now the WARNING from include/linux/alloc_tag.h:164 is gone
for both 2M and 1G pages. BTW we also need to copy_alloc_tag() for
HWPoison pages before pgalloc_tag_sub().

>
> > > > +             total_freed +=3D nr_pages;
> > > > +             curr =3D PageHWPoison(next) ? next + 1 : next;
> > > > +     }
> > > > +
> > > > +     pr_info("Excluded %lu hwpoison pages from folio\n", total_hwp=
);
> > > > +     pr_info("Freed %#lx pages from folio\n", total_freed);
> > > > +}
> > > > +
> > > >  void free_frozen_pages(struct page *page, unsigned int order)
> > > >  {
> > > > +     struct folio *folio =3D page_folio(page);
> > > > +
> > > > +     if (order > 0 && unlikely(folio_test_has_hwpoisoned(folio))) =
{
> > > > +             folio_clear_has_hwpoisoned(folio);
> > > > +             free_has_hwpoison_pages(page, order);
> > > > +             return;
> > > > +     }
> > > > +
> > >
> > > It feels like it's a bit random place to do has_hwpoisoned check.
> > > Can we move this to free_pages_prepare() where we have some
> > > sanity checks (and also order-0 hwpoison page handling)?
> >
> > While free_pages_prepare() seems to be a better place to do the
> > has_hwpoisoned check, it is not a good place to do
> > free_has_hwpoison_pages().
>
> Why is it not a good place for free_has_hwpoison_pages()?
>
> Callers of free_pages_prepare() are supposed to avoid freeing it back to
> the buddy or using the page when it returns false.

What I mean is, callers of free_pages_prepare() wouldn't know from the
single false return value whether 1) they should completely bail out
or 2) they should retry with free_has_hwpoison_pages. So for now I
think it'd better that free_frozen_pages does the check and act upon
the check result. Not sure if there is a better place, or worthy to
change free_pages_prepare()'s return type?

>
> ...except compaction_free(), which I don't have much idea what it's
> doing.
>
> > > >       __free_frozen_pages(page, order, FPI_NONE);
> > > >  }
>
> --
> Cheers,
> Harry / Hyeonggon

