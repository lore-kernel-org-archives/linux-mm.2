Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8978E606A32E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 17:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=l1oZrxn+
Received: by kanga.kvack.org (Postfix)
	id 785E56B05B5; Tue,  3 Nov 2026 12:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736FC6B05B6; Tue,  3 Nov 2026 12:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BD26B05B7; Tue,  3 Nov 2026 12:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30C306B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:49:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94DF2160287
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:49:24 +0000 (UTC)
X-FDA: 85394544648.19.6FA45FD
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id A3BB040003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:49:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=l1oZrxn+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793728162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qBJJGwcOkwORFVl1Xm6qSC9szXJOakEhGG/ugZS/vI=;
	b=iyEFWHmIzPz9XwoK8PM/Icemc/l70Tq1UIvAMJe5K0nFBamwDRl7w+Ps8qhWjseEcXiEWv
	w26QFVdZeZIddQL7lOQASixkNqW4QcMntyWKHjhGWIcHiEG149s0tH+gr3as4dSoBuOIOl
	7aeSkbxKeJAhL3N/ZhO4r22VpwmAoZM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=l1oZrxn+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793728162;
	b=L3n/OMwBPAi472yA3dh2SYpgJwiTYkwqN+5y6zNKdmWwSUNZJTwJ101BjraQ+b1gQGmrdf
	zwLADlr5SKq8YniKYJbfOsb0s29RWdDxbWbTcxF8TN5Uh2OXs2FAzWdMZbrQGFxJBMXf7o
	BbDcJ/FQbrqc2wm9bwGerDqL19mR79E=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5383c97c8cfso307691cf.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 09:49:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793728162; cv=none;
        d=google.com; s=arc-20260327;
        b=OGVupZByMenska8PpuQPz/N9VZInwLl33zdp26Eg/uemgeSGlib9Z1Cq6MVFP9gGRR
         D7cR/UBvikckKsTnxCvZ+7z6ZBTRqNGF0BpZuq2cGTRsgdSyh7Yszt3/s3zQNeRkKwmk
         732I81FkUgbhLkk4I786Jnief9+d2tvJ6v/CHsqzbEo2VUgxy4Uy2vs/vvBqIGj31kL6
         7XQCih48DDSYptgfqpV26z0qKruJgv5Jd2JhQE/mIgIAj2SORM8Go1wNthIcl5B+oS3r
         JMJEkyfciVRgyBfz8HEfiSPYD3qOOFpvxKJvfLwqSczsi8ZqjHspFIBG6jdPKqRHtngB
         81LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8qBJJGwcOkwORFVl1Xm6qSC9szXJOakEhGG/ugZS/vI=;
        fh=f65mifOUByZQGWD5QMUNSvRHQ64iuNvvg6fy/l/qAdk=;
        b=V6myaMSiMT79id6bHTlJan43yxG43L6DqH1+0xgzL6G3E8972JFcpnfxV0Bw6n2YjQ
         3kznZKH7AFsLLP8VY1fjYn6Jty8/T1kpYGsGFK9WJTc/SRKbA95UOP+8V4iJFLhnHbcf
         fDf/ZLRX63phxu4/IFUCweuUo9J3ONI2e9h5YjdEEFk2eI7tOA80cOdIHDk2ZHys3piQ
         /WQcxWeyKAzMocQo0pXulIxR3C84JtCUoqHVGeQyFKLEG09AYJOto181NGZXMkIXT1Ni
         Lazgdp46Vft9uomFr8C+2eY8Lvibwb8bqoGgQYR/PPX2PokoPB/Mh4LagbCLfy/Xqoxx
         TFVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793728162; x=1794332962; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8qBJJGwcOkwORFVl1Xm6qSC9szXJOakEhGG/ugZS/vI=;
        b=l1oZrxn+9K0s6CLz/2FsFsunMdH4HfQ47gDyCiaJNboFEn3VJ0u4mprwzCNCTZ6pXU
         clFtZqcvqdqNcOeswl9w6LpHB3hdNXCfXSbInyNoJypLtGyt7RWuhQ+j698KwzyRr8Hl
         p0KDx8wRgJxGQZl33uY/7VwaRz9eXK9V6TDZUyjvqK2QJVzwYYAKB7qtq5765CEdnf5Q
         AJVwBGhJ4UZSTkkgeIv01prvEEql64Hkjfl1GzVdKFF6Uti5kGSWfuYhhZE6Rl8Cx8ZI
         L9gMQHuUhmkIojf0kWdq/ClcugsFcUe4ihvUq/w2unBpIP0/VSwZ2LcZ13E2m6rP4CuY
         Ppjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793728162; x=1794332962;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8qBJJGwcOkwORFVl1Xm6qSC9szXJOakEhGG/ugZS/vI=;
        b=qWwmgL0O+N/CKN42+/yRbvVhvoqrQfxxmsQg7kEs1g/z5FXsUOL/QI3s6ZiDkv1CxK
         BmTaPYsiouUYCYOLtCaxaK6acsCcwkCknHerpxH3uOgLwLOk7+aaoLzTbzC/v2n5nyJq
         USdd+m+9jxdnJCaD6+0cM0zQ1lWRHPrDJ4I276PWJPlHk6akeFAQDfJodYH5XmAz8sdK
         QsWeB1B5SJZwdj9MRMMncDV2uYEjMmIn7vfjPpj/zZSlE8Zi6xX/MmccPhTGHG+i1i7I
         reUpvLQica5hwECCm7QuQAge+pS+UaearlOKKUchFn8cwF3Ypk0oK39vUMhs0FzfhTeH
         B6Kw==
X-Forwarded-Encrypted: i=1; AKwUvBxpcTVfvGzx7s2o/9WN+aylv8gYJyKvOJRGpjPg5Dx/13svUwCw29QRgBOE3WndzamgiJUxz/Ke+g==@kvack.org
X-Gm-Message-State: APuU4Z9n0g7SBSkoBpqHKH1FCIr24I4WF+UwmlC0f0beu9ciMck6niGo
	XXaZqGHOLwEAWryPyRFEqxYE3mBA9fG7F4MOU30q9jXIjoDSzR/96eL1QV48/sQjeXiSB18ayic
	AoQc0334xfIo7SZSy2l825QunMWm2eZ302t3SDf2e
X-Gm-Gg: AYBFou2Fc8YyITMZqp5aJ3d+XNhJKGVR2spkMVUHBZxnG036f2IDP3Qg7Fld09mqPtp
	xqoq8BNK+FogGYzb5dXCKlkeZxM7pmPWGgDmVp4IBjddGRY5TS4EJGUJknH5sa1C+tsQVwKTOSS
	TBobtKAxdoE2pAUGfnqmJDzJSOH+z0bVNlSXKHkSc30hTbCIHjFjqbIBjuYt0k8HjapIhqnZFfU
	liUek9BPbMT1Uyd6M0UMj12795rM1xUURdHA7nuz/FHBFp7U4wr1HHnVIat4cTJ4KTTRi+cRk3A
	psbKqlXPg5mMO4nHQnPY7ZcSKKg3caqFWxmbGjGUIVDNzF5EUIb0kQUhl/PLYHBxxVA8yXg0iyf
	VR6SuR0o4l+M7fFQ1Iu7/rZjUgS6Oo0Wn59ihG9su8wnPit/PGz8wBrs4Ynth28sK
X-Received: by 2002:a05:622a:1b21:b0:532:8423:1e78 with SMTP id
 d75a77b69052e-549e0408e65mr23185391cf.10.1793728160913; Tue, 03 Nov 2026
 09:49:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com> <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
 <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org> <8f787434-5326-4a8f-92d0-467e817a23b4@kernel.org>
 <8e48c288-2183-4d58-b69d-5f78344b5da5@kernel.org> <c5658175-8d1d-4aec-9a66-b07d53f75547@kernel.org>
 <352e1f42-2e89-4445-a20e-572ee35c7a0c@kernel.org>
In-Reply-To: <352e1f42-2e89-4445-a20e-572ee35c7a0c@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 3 Nov 2026 09:49:05 -0800
X-Gm-Features: AclHuK_aki5ll0OesKUci7EnpbmfOgQofcwncMlPLSbILVUDcly-CR0P80pjzq8
Message-ID: <CACw3F52YcKohXa69Gtr_us1D4R7AdTbwaHh1ro8YOXZ9UByQ3w@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, William Roche <william.roche@oracle.com>, linmiaohe@huawei.com, 
	ljs@kernel.org, ziy@nvidia.com, osalvador@kernel.org, harry.yoo@oracle.com, 
	willy@infradead.org, osalvador@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	muchun.song@linux.dev, liam@infradead.org, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, mhocko@suse.com, boudewijn@delta-utec.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3BB040003
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6jxaamu8gjzjczzwc5uoe95bakystz5q
X-HE-Tag: 1793728162-65661
X-HE-Meta: U2FsdGVkX1/0Oq1dND8cX+L1sYG79RcIToOnaCe9VpVW9db2FN2r6QJMEBF/kIWvxzUz/BtELibXZdcNKL1mjIZ6lOnXVDeft5dJmj34yGFdw4Wq1n39waOwIcnGYIFRz6jZ8HxTWVsIVn77c/vIWPnMpTuUkeFGIATJBvW/vCGmwq8AO/K0Z4E1VtXeVCz67LJSXeDLVJIAn/L9i2y7Fbzpw55HyFdRr/anYYKrnVsZtRxI6yKeb4I7KwZ9m3MEfsZuSdpK3MwbzInGuavBbgsTCvvWmimOr7KCTlbhsOVmZuV/FegvTQfgL229VlsfX5tL6oJMXEjqF5bx/uJOfJW2nDV2pPkqThh93ioys/2Nr7QheTFwmTbiLzfDSwTY1wsXAnQG4FN3QTqvkkg1tPy4+DmA8qXJFhYB6K/wg5xkAGg+o1wPp/UbNZBuuIi6yKWOIB1VIIsXgl60ojil3H2onOwfkmrPNhTMS+BeqBWB4qfUAiYLRevvYlqW+Hjg80LFAxKc/KT7abLzKrf5jz03V5K+sRRJWEz/RntqZgdYg29u9Sdw8w54AfRd+SHHsnCG+7FtpZic861/xXDRovD+Uce8KpnuCQwtTfbyqbljpghHA+rkRBeGbwrIABYJuLQKdnzK9rXxq2eIDxOY48y5/czRoqWGvnK73fUZhAp7z95KSeaBZyQNsRfzdtNKHgmkCycN7KCoRtRZhT+6vxnk8Ac7CCFmN9UUjK8YyrFSIxAaGLJo3e9ZTM5+cLTYTHtrPaB7UoCXNARoPhcBasViKjWFxnuJp/L25vP7uJFARQB/smJvETUnDfU2U0cqosW/CBjdMbguJrQw9W+iPgu+CvcMh46zJwbkbcaAKsMcHbhrhqoxFwUDZiPzDaULVOATdgZ5wHhknfzjob1cIpZdM1voEClY6UNKU2lacbLjKdIsGidoKBZOStuftqoB0LJOr5bPZtXxytVTr2g
 V1PCjyFF
 mTEmEbV2ix9E8B1yrP+XUSeoeef80/TXs8rnBOd2hnP3hCsDuvbYaB3ItF8KsWhHy3/2JcvOXtM+8Dtlo/y3Ytx/fro7t1S1byI8QP/xrr2d9OqjwTY+LcOuFRyZ2+yAR96pYEOqk+AwWrJy1jtMjk8JLXuYEjjf9S+4nfiw8wFAfkkT+QaiHzz2xSeLFw6MhgGVRhwTCn/SKQ7C3A4VCvookrpmk2DBu4Tbzf0/Mu19gYGwwLCW8MkZ3joeNusEFh2LsaeObd7fr/r3hqo3b1ztVZiuCav58a2Lj6EzyqwT+aMW+dV/ApoQ6bvspUBi2LDRb8as58oVuGG/KDjKLUFUCvtDqW3ttQ9ecjGIBxjT11G4LzDvTnBPA+CwHnnas3BJQU+aKqix+ewl6kvymBg555+qvuvQSteXF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Aug 5, 2026 at 2:10=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 8/5/26 10:58, Vlastimil Babka (SUSE) wrote:
> > On 8/4/26 21:51, David Hildenbrand (Arm) wrote:
> >> On 7/28/26 19:18, Vlastimil Babka (SUSE) wrote:
> >>>
> >>> We check all kinds of unexpected state, when that's enable. PageHWPoi=
son
> >>> could have been considered unexpected too, when the checks were made =
more
> >>> and more optional (first by Mel and then me).
> >>>
> >>> But indeed it seems the PageHWPoison check is supposed to be load-bea=
ring
> >>> (hi, Lorenzo!). It's intentionally handled before bad_page() (with a =
taint)
> >>> in check_new_page_bad(). Commits 2a7684a23e9c and f4c18e6f7b5b are al=
so a hint.
> >>>
> >>>
> >>> Yes, the PageHWPoison handling was made part of debugging sanity chec=
k and
> >>> then not recognized properly as load-bearing later.
> >>
> >> BTW, I'd assume we can check for PageHWPoison at free time fairly effi=
ciently, as we
> >> touch all page flags already.
> >>
> >> Something along the lines of:
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 520ebd2fa40b5..57f89f8684168 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -1321,6 +1321,7 @@ static __always_inline bool __free_pages_prepare=
(struct page *page,
> >>         bool init =3D want_init_on_free();
> >>         bool compound =3D PageCompound(page);
> >>         struct folio *folio =3D page_folio(page);
> >> +       unsigned int hwpoisoned =3D 0;
> >>
> >>         if (fpi_flags & FPI_PREPARED)
> >>                 return true;
> >> @@ -1347,21 +1348,6 @@ static __always_inline bool __free_pages_prepar=
e(struct page *page,
> >>                 count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
> >>         }
> >>
> >> -       if (unlikely(PageHWPoison(page)) && !order) {
> >> -               /* Do not let hwpoison pages hit pcplists/buddy */
> >> -               reset_page_owner(page, order);
> >> -               page_table_check_free(page, order);
> >> -               pgalloc_tag_sub(page, 1 << order);
> >> -
> >> -               /*
> >> -                * The page is isolated and accounted for.
> >> -                * Mark the codetag as empty to avoid accounting error
> >> -                * when the page is freed by unpoison_memory().
> >> -                */
> >> -               clear_page_tag_ref(page);
> >> -               return false;
> >> -       }
> >> -
> >>         VM_BUG_ON_PAGE(compound && compound_order(page) !=3D order, pa=
ge);
> >>
> >>         /*
> >> @@ -1395,8 +1381,26 @@ static __always_inline bool __free_pages_prepar=
e(struct page *page,
> >>                                 }
> >>                         }
> >>                         tail_page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_P=
REP;
> >> +                       hwpoisoned +=3D PageHWPoison(tail_page);
> >>                 }
> >>         }
> >> +       hwpoisoned +=3D PageHWPoison(page);
> >> +
> >> +       if (unlikely(hwpoisoned)) {
> >> +               /* Do not let hwpoison pages hit pcplists/buddy */
> >> +               reset_page_owner(page, order);
> >> +               page_table_check_free(page, order);
> >> +               pgalloc_tag_sub(page, 1 << order);
> >> +
> >> +               /*
> >> +                * The page is isolated and accounted for.
> >> +                * Mark the codetag as empty to avoid accounting error
> >> +                * when the page is freed by unpoison_memory().
> >> +                */
> >> +               clear_page_tag_ref(page);
> >> +               return false;
> >> +       }
> >> +
> >>         if (folio_test_anon(folio)) {
> >>                 mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
> >>                 folio->mapping =3D NULL;
> >> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selft=
ests/mm/Makefile
> >>
> >>
> >> Of course, we could also fallback for order>0 to do some smart splitti=
ng.
> >
> > I think the freeing part is relatively fine, as tackled by this series.
>
> I think we should really do something like the above to detect hwpoison, =
to then
> fallback to a slow path.
>
> >
> >> Checking on allocation efficiently is indeed a bit more tricky. For co=
mpound
> >> pages prep_compound_page() will already walk all pages.
> >
> > Yeah and non-compound high-order pages should just go away eventually, =
so I
> > wouldn't worry about making them slower now.
> > But it's tricky because prep_compound_page() happens later when we don'=
t
> > expect anything to fail anymore, so it would take some refactoring.
>
> Agreed.
>
> >
> >> Having hwpoison logic to just sync with the buddy when setting hwpoiso=
n flags
> >> would be nicer.
> >
> > I suggested that (soft-offline does it). There might be some downsides,=
 but
> > I can't judge how much they would manifest in practice:
> >
> > https://lore.kernel.org/all/CACw3F50nVECJ%2Bk4g%3DQVZ80yzi_awCOcUiCuB0C=
YcUfxND9-7Tw@mail.gmail.com/
>
> Agreed.

Coming back from a long vacation and catching up with this thread...

I agree David's approach to check for PageHWPoison in
https://lore.kernel.org/linux-mm/8e48c288-2183-4d58-b69d-5f78344b5da5@kerne=
l.org
is much better than relying on PG_has_hwpoison flag. I can update this
in v7.

As for "should we split and salvage healthy subpages", I think we
should do it unless caller is FPI_NOLOCK, i.e. when freeing pages in
NMI / lockless context. The only caveat to call out is, if we reject
the entire folio for FPI_NOLOCK, the healthy sibling pages in that
folio are permanently lost from MemFree. So should we count them in
HardwareCorrupted then, as loss cascading to the corrupted page(s)?


>
> --
> Cheers,
>
> David

