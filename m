Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2417BCCD19F
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 23:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367D98E0006; Mon, 20 Oct 2025 19:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FF68E0002; Mon, 20 Oct 2025 19:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255A98E0006; Mon, 20 Oct 2025 19:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 108CA8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:41:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A17D3586A6
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:41:18 +0000 (UTC)
X-FDA: 84020116236.24.E0622AA
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF054100004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:41:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fGwJhfWV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=shy828301@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761003676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVHGg12fLQlilE+T8MY9DYY29gRCesjGg0Rsi3pSnR8=;
	b=iTk+W5Qt0E3VkM2w/48wQkgahQN0o2hP3lBR0z/WaKa18lgCaPKMLu4iKXIMvh9+EBIKPb
	jpTOurXBpAbSXgmMR2apKgl8YsJN9ue90Uv+/KI/0H+cs82qYNDub6nFZHG7wCI0cFasqy
	HyzFl++WPsWUXRI3iQcGCVGZDl2GtUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761003676; a=rsa-sha256;
	cv=none;
	b=a8Tzb994SRoEvoXIOpuBM0lRN6/sQEdV6+UFeO+HX9ULfT33f6uvS/wPJUCw73xWpFjUOV
	QrSEzNbMF3KywIzFgHN0xPCuahL1SXk0ElYJ9ZIha8yi01MnDTf/RitlugZD1Nt/yNqv5u
	EAl3iL5JWyn0BYRcua01wLCFYFv84r0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fGwJhfWV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=shy828301@gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-63c11011e01so7926104a12.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761003675; x=1761608475; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NVHGg12fLQlilE+T8MY9DYY29gRCesjGg0Rsi3pSnR8=;
        b=fGwJhfWVHZOfhQZCEVLGCFyeE8FrEe/u1LtqAgR9YPJTRca+aeDDizKGeyn3ch70GB
         8B0VEzglGuQpL/nQzOyWVHAclfd0PszqyAj+BzJQtzqh2y6DT/1/UiQ4sHD61vWW+Y5b
         9xCbSpfd+U05dLtgV4z4dOfgTqO/mfuHJuA2Z7L8/2KHoiHsjTEu1yAB3b+PsQBtK53N
         J76f2VIOo8T/d8cknPHCl38eXDhFoyTmM7xdbWtgIYBJrirUNwwV7mH8K7jBVQgplB08
         WQpAYvU5ICqAlDzVnFZAJE8AYrNbN3M7QZlRPOUh5/QAhsgG1k90+v6xd+MFeIaclrUu
         hMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761003675; x=1761608475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NVHGg12fLQlilE+T8MY9DYY29gRCesjGg0Rsi3pSnR8=;
        b=Dl1qf1Q96KV2o9p9X8re13TQpWyjkSHjBpZh/ggMRS1wcu0dbfMn+4Pe20AtY3e2LA
         jcUpKjyY0P1wWPJw2ZYGbgq2xS3S3NEJCJ10I18mmwS/YW4ioA1DndklaMRaLb5ecKse
         j1o7nBrIxfXXx6SITk9NfkV7jJ6/9d6I9KC/Jcc3a2aR1SMdr/PmtpqCY3nYeQFWC7b1
         WuMlvqe6cOGrz0S9mEyC8EPPAA/IZGMPs5ufEzcIP4JODuTDiWt/Z9/jFhNiKzpS7g13
         7BtKYGfIdkmwcSJdQyM0x4xQ4M/j4SMVTxtwFjvLs/bm288SVrvX+jeSdKaL6bYRIAWy
         eyKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMM7iTg4iMsvY7kCdP0jrzfiB/o1d4t0gatxEHo2Ku+LiTBptH+HCxjHo7mFsbewb5ML5nIsfSxw==@kvack.org
X-Gm-Message-State: AOJu0Ywp5Zb767NWc7SIA020wkctwaoDjv7TMkpn5VQKNmWqeemMLGiZ
	nXDc0sX5dP9ALxF3Sx50htFB3iiatSviUNHbZLmWuBIg3f/Ph6ouQehWG3P0IA0MACErE7JzxZU
	s4Ldz8kWkkh3zrhAGuRupFjuBWMNdJUA=
X-Gm-Gg: ASbGncuPjUGv0jvDO3PCOn8d2ODozi5p99eO9THJSYgzcCyP9W9mjqW406Sx/jeujXE
	IVeku1r3EMRHiFHQCc6YrIQQD9YAwi6aqagL0l52vGGxS0I2Wsiw/NIKxo13DK7c37zysp3pUrt
	y0C3PRF6pcAdwUE5A2bWdi4zT8Eulstlbi3oVRWy3PLM/KMG3c7JIqnnpq23fLc/KiPqr8GgpUK
	OqaP3YQ6rHlacb80r2vpt5kT1yQ52VUCAbCJeNV2sM77gp0fltOdxs2x8Et+KwAO7235PazKw==
X-Google-Smtp-Source: AGHT+IGCVi7HkPALGAh50zQQO6fGSMOaI+jhXkh2/BsTg7hBG14q/tm4iEaZSqUMR+1QulKNUnpwT7IfU7bfzg9SJp0=
X-Received: by 2002:a05:6402:84d:b0:63c:4537:75c0 with SMTP id
 4fb4d7f45d1cf-63c45377875mr9609309a12.38.1761003674815; Mon, 20 Oct 2025
 16:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <20251016033452.125479-1-ziy@nvidia.com> <20251016033452.125479-3-ziy@nvidia.com>
 <CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com> <5EE26793-2CD4-4776-B13C-AA5984D53C04@nvidia.com>
In-Reply-To: <5EE26793-2CD4-4776-B13C-AA5984D53C04@nvidia.com>
From: Yang Shi <shy828301@gmail.com>
Date: Mon, 20 Oct 2025 16:41:02 -0700
X-Gm-Features: AS18NWDW-oprtmdqoGZJo4Z4YsO1liFomysWIh3Edtsp-B4vhH9CkUZKlFk_O8w
Message-ID: <CAHbLzkp8ob1_pxczeQnwinSL=DS=kByyL+yuTRFuQ0O=Eio0oA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/memory-failure: improve large block size folio handling.
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com, 
	kernel@pankajraghav.com, 
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org, mcgrof@kernel.org, 
	nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BF054100004
X-Rspamd-Server: rspam02
X-Stat-Signature: 59w6tbzetb9dkz4xyhzrufdoe9xq5i6n
X-HE-Tag: 1761003676-261747
X-HE-Meta: U2FsdGVkX1+gdafmgQ5963EMP11HCAYqkTioHgEAT1YHu2sB5XB7OifZ8MBJgmsaFOw5VDGEieoSSuom6p/dQ3maba1gsL+kfuukzlOkGeBsm/YccCVb0zv63kfsFmXo5QphShCVPmzbLdtbcVWVRwHcBGSQnB8JXw57NOgSzl/dRj1QWkNM7lOypZfe6GB5FtKRkJ12L9ckSclUp3+GJ2Y6tQddKTQrzn7yosS5PItCxgOBVmIopLpmPo9/uGuHntVHu1adzWK2bXWixtN0wi3ipj5b8FiUSh90QCst6MkWbun4T7cz6VFmYqIRa2wbxP2mEbS+SerNIDxhFHlUez1KIXSuZEqKhjBVjcWLlFcn8ZkvdTs8ziObWDwQZlivzJxk7NuuXWvwXFJh5GjvwNFF9i9BUeFLa9R3PT7IUtbUnnFylFX/rH6oD8B4mwEFIU89KueBQwZ4L+ZFNvWi9REnWuTEadjQ6Bg553afeIYe1WDZl2R7Y0VAk+ULryYbqJV93657CDEyjoJzJ7iNsWIIXji+ifebjFdyUgDs9fZljmLSK7+uNVgTdTnuYK2DvkTiIgmKbR+U2trmhhEtHG0p3+HMqfW8QeD/j94sHDgQxQ+/N+PjcD9EZjlB6LJgilKeoBi+IjJYYhiCUiyW8nH6MMqWKzpjfFxouG/Fm+4H6iBnCFDgYStZHjNSX6rFB+8xjJFdLjopp3+5z5FMaDMLaK2MkJA01L5jeFgm3YEzQB9sWg+v3VuPFrTHgI9v3uLitv/FgakaA4th9fk9I3xPA9j0iH/zBj5E85j0WzbBmmFi4bPtvGwtwU2yTwxUr9zkcp2IAIoWbx7eMsyc9e0gNuvtbUhYOohPizDjsrYH6DV6srkJ1ZeqWmLSVRcdJYG1n7TxtfCFAnAdbknagfaPATxXZA6nszOL3IPMo2g8qwxIh8dzu/CVwY0d4VptxHjjoUOGKWUzIUB1zCP
 oX1HkA6/
 ZCPfi4ricY2fhqY77F+l+YEbVh81bvvSViJfm5ug3ORS+x+TqF5j9NDp3s4Dnq0BAChHyBIoHe17m7y5Mh8bnXl0eaOg3jYOX8Kdpt5G/p92VSXmcNmOjBm7YNJ/oYSXMwkZZPbOFXz9eNEhiKuFScHMIxrFXheq2A4dXh+4Z4T8/27IGTHgWFeARQGHklTTqHkUKEUiL019UPBfs+js18q52pbPg6X4ZEv/nG3rznqB/mqdieQ15aLgMJJSoECGK1JIdLE+L896krotNEnJhuxyyYPY09aA2yluOcQe2nVRytIEL8aWPPVkQ2IekmJB720nFQSzuYdAz6etuzHfesGv+YauTx/tvLqy1FqLIFM9mvC4RLTXA/TMCaJGvFrZiP0t6INYYAGU/jGD2BSeMbvlYDUkORK1iNoZJJROrNxc2Cd6jX57/bPlSA4Wd+VTH6bTql6WXjVFRudMqRuUfLY6GEblX69dMKsZbEzlsrkIw2wXV/NljrukufyFrsFEq6IVYe3kvV3zxwbsG0JUMthf8ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 12:46=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 17 Oct 2025, at 15:11, Yang Shi wrote:
>
> > On Wed, Oct 15, 2025 at 8:38=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> Large block size (LBS) folios cannot be split to order-0 folios but
> >> min_order_for_folio(). Current split fails directly, but that is not
> >> optimal. Split the folio to min_order_for_folio(), so that, after spli=
t,
> >> only the folio containing the poisoned page becomes unusable instead.
> >>
> >> For soft offline, do not split the large folio if it cannot be split t=
o
> >> order-0. Since the folio is still accessible from userspace and premat=
ure
> >> split might lead to potential performance loss.
> >>
> >> Suggested-by: Jane Chu <jane.chu@oracle.com>
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> >> ---
> >>  mm/memory-failure.c | 25 +++++++++++++++++++++----
> >>  1 file changed, 21 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >> index f698df156bf8..443df9581c24 100644
> >> --- a/mm/memory-failure.c
> >> +++ b/mm/memory-failure.c
> >> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long p=
fn, struct page *p,
> >>   * there is still more to do, hence the page refcount we took earlier
> >>   * is still needed.
> >>   */
> >> -static int try_to_split_thp_page(struct page *page, bool release)
> >> +static int try_to_split_thp_page(struct page *page, unsigned int new_=
order,
> >> +               bool release)
> >>  {
> >>         int ret;
> >>
> >>         lock_page(page);
> >> -       ret =3D split_huge_page(page);
> >> +       ret =3D split_huge_page_to_list_to_order(page, NULL, new_order=
);
> >>         unlock_page(page);
> >>
> >>         if (ret && release)
> >> @@ -2280,6 +2281,7 @@ int memory_failure(unsigned long pfn, int flags)
> >>         folio_unlock(folio);
> >>
> >>         if (folio_test_large(folio)) {
> >> +               int new_order =3D min_order_for_split(folio);
> >>                 /*
> >>                  * The flag must be set after the refcount is bumped
> >>                  * otherwise it may race with THP split.
> >> @@ -2294,7 +2296,14 @@ int memory_failure(unsigned long pfn, int flags=
)
> >>                  * page is a valid handlable page.
> >>                  */
> >>                 folio_set_has_hwpoisoned(folio);
> >> -               if (try_to_split_thp_page(p, false) < 0) {
> >> +               /*
> >> +                * If the folio cannot be split to order-0, kill the p=
rocess,
> >> +                * but split the folio anyway to minimize the amount o=
f unusable
> >> +                * pages.
> >> +                */
> >> +               if (try_to_split_thp_page(p, new_order, false) || new_=
order) {
> >
> > folio split will clear PG_has_hwpoisoned flag. It is ok for splitting
> > to order-0 folios because the PG_hwpoisoned flag is set on the
> > poisoned page. But if you split the folio to some smaller order large
> > folios, it seems you need to keep PG_has_hwpoisoned flag on the
> > poisoned folio.
>
> OK, this means all pages in a folio with folio_test_has_hwpoisoned() shou=
ld be
> checked to be able to set after-split folio's flag properly. Current foli=
o
> split code does not do that. I am thinking about whether that causes any
> issue. Probably not, because:
>
> 1. before Patch 1 is applied, large after-split folios are already causin=
g
> a warning in memory_failure(). That kinda masks this issue.
> 2. after Patch 1 is applied, no large after-split folios will appear,
> since the split will fail.

I'm a little bit confused. Didn't this patch split large folio to
new-order-large-folio (new order is min order)? So this patch had
code:
if (try_to_split_thp_page(p, new_order, false) || new_order) {

Thanks,
Yang

>
> @Miaohe and @Jane, please let me know if my above reasoning makes sense o=
r not.
>
> To make this patch right, folio's has_hwpoisoned flag needs to be preserv=
ed
> like what Yang described above. My current plan is to move
> folio_clear_has_hwpoisoned(folio) into __split_folio_to_order() and
> scan every page in the folio if the folio's has_hwpoisoned is set.
> There will be redundant scans in non uniform split case, since a has_hwpo=
isoned
> folio can be split multiple times (leading to multiple page scans), unles=
s
> the scan result is stored.
>
> @Miaohe and @Jane, is it possible to have multiple HW poisoned pages in
> a folio? Is the memory failure process like 1) page access causing MCE,
> 2) memory_failure() is used to handle it and split the large folio contai=
ning
> it? Or multiple MCEs can be received and multiple pages in a folio are ma=
rked
> then a split would happen?
>
> >
> > Yang
> >
> >
> >> +                       /* get folio again in case the original one is=
 split */
> >> +                       folio =3D page_folio(p);
> >>                         res =3D -EHWPOISON;
> >>                         kill_procs_now(p, pfn, flags, folio);
> >>                         put_page(p);
> >> @@ -2621,7 +2630,15 @@ static int soft_offline_in_use_page(struct page=
 *page)
> >>         };
> >>
> >>         if (!huge && folio_test_large(folio)) {
> >> -               if (try_to_split_thp_page(page, true)) {
> >> +               int new_order =3D min_order_for_split(folio);
> >> +
> >> +               /*
> >> +                * If the folio cannot be split to order-0, do not spl=
it it at
> >> +                * all to retain the still accessible large folio.
> >> +                * NOTE: if getting free memory is perferred, split it=
 like it
> >> +                * is done in memory_failure().
> >> +                */
> >> +               if (new_order || try_to_split_thp_page(page, new_order=
, true)) {
> >>                         pr_info("%#lx: thp split failed\n", pfn);
> >>                         return -EBUSY;
> >>                 }
> >> --
> >> 2.51.0
> >>
> >>
>
>
> --
> Best Regards,
> Yan, Zi

