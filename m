Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FEBB606A6AC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 23:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CRxuqZhH
Received: by kanga.kvack.org (Postfix)
	id 603EF6B05B0; Fri, 20 Nov 2026 18:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4C86B05B1; Fri, 20 Nov 2026 18:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA716B05B2; Fri, 20 Nov 2026 18:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9516B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:02:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 895F6120215
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:02:06 +0000 (UTC)
X-FDA: 85457022252.15.30E76FE
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8A21B180003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:02:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CRxuqZhH;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795215724;
	b=sRGbnhYAqB0qPI9445ns6em+hzR6ejMiw7PDgb6R60rEfpMaOkl4CiLdl5JIq+thwoGO8n
	07GNoTLg04vceGlJ1SnBJebWHj27ffmTZyFPvzdTwT9UvuXbnxWi137wvadDAUXV02VW4F
	xdn2PB0b8WbuLpkhZ94ai10qIcCzuXA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795215724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sB5iWeLIdXSk/z2yiFdp6RKCyaPz4LeSJqW6ibv5E1o=;
	b=5gRVjjfOPH7CYJlY+w7gnaiqecTXoBhRN9INHnhRASDHmHK5pvUp6RM5ACPT9nP/s/8M63
	++rV3/f78cQ7h8OZXyJ2mfCgelDQaQsxb1FSv2JH70u9FN0/ccyGxQ1IrUpwVH3nlcprS6
	mUKmFdChvuFGPkUSbX+2/Fw+LzXBB8Q=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CRxuqZhH;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5c14470729eso1182657e87.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:02:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795215723; cv=none;
        d=google.com; s=arc-20260327;
        b=j6ZGykheiGmEG/wlenvxG5yvMUyU2tkU3qHQV2j67XKxtBEm6snSJjw5UB1Jx0Tj10
         GPCtrAM5/j+jL6xGp/WO2Q4QHpEDs1UKyr05ElYap3mciSM0U6CABUaSzHV3CuI8KfC6
         aIbq42mCTHr9kBvC+DU1o3SPsjj3Qg0KV2DWLPrp9hIhbbfIYGjMkwNN0QyH6K8oX6fY
         7Y19ujtRV25ec83oPzxKXFhEniYORp2bzQf8MXhQg+P4nspPDCZmrASCZ11ddFxAhaml
         vTo8F4xUpDLkN/XOYrNKeu2nPVQlrEzscH5MnzdFENQg+BI270Od0ibEE+8xBuF7BsqQ
         LrmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sB5iWeLIdXSk/z2yiFdp6RKCyaPz4LeSJqW6ibv5E1o=;
        fh=rnv+25mFINoHJVBOfCDFKOYbdn8F9V2D/zVrnqt7FYk=;
        b=L2H0X4TH7aWb+n0nN6tZTG8tnsFTsto+1Hl/FGXoJbNEWE0iX+BH4+TBMYaOxufWaW
         ThIk4sw8l1scbcRNoNbGQPMFRF7RqspK76lA7NUUlU5iOkBm569G156zanYaNYd4IOgf
         BXtl16wvAiy+GDhxJM3DJZc06Ww3Pm7lPcr0lY5Gx+jusVVEKZkuI2p1b13ob0AAxWV4
         QoivDAYktyV+NhpmoaJ61+zGeisZEnj8pTNwKo2vQ1v02XCfrchyHwXfMm5FTtfEjlaq
         1TC99QBsj3gcLxnrIEsNiZtxOINgw37n++aEQVu3b0++BvzQf3dFmhvol9QWodxuThir
         rVZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795215723; x=1795820523; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sB5iWeLIdXSk/z2yiFdp6RKCyaPz4LeSJqW6ibv5E1o=;
        b=CRxuqZhHl0zCG7KXyT8uM9Cscn6NNh6sqbFMYg2+NjnymJx1pL3NA4MFMABb/CHycx
         PpGh1So36kAxjQjX4vDV3+/rC+oL4Io3miHqcGUY6SxfJYF1anMcUyO/3MniOlMPbvFs
         3i8nTC+9bGGhlaB44o+NIA19x2iDdZpnqWX1YVWg+2iYcZZtANwsqSWFHdl1WCibACI9
         gzpniAcQ+Si3gF3XRgb6pjrA5sJN+EG7LpCbNwaQMx/U0Bo/XNjKvkbtbzFDsVqpbquw
         8SnKn1CS+O0+taWLc0/xPjwEXXlr2UZROdxb6M+cfFSa5amojNmYxh2+rJOwdCmO67jG
         8SoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795215723; x=1795820523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sB5iWeLIdXSk/z2yiFdp6RKCyaPz4LeSJqW6ibv5E1o=;
        b=Y3kuC2Yy0harrFRzisETE3ugathv5pwBN2aeCC5UdgJQjPtz6/Gs6ML/hROqlxljL/
         X9OIf5c1QWRtdvhCWwQh0l3bbLTl1XtTpIZkp/piAL5PQE7w/kstKclHRyKtqDsevOpl
         suls4TreBPuzAiQtxHbMxRy1Yk6LVpQ1AchN6LZHdwPI/O6ZN6vzuyAoH29v/9fKw1xp
         PLt34zmOjMLZvOkWVoO7vHAZd7Q4V4HZcNHIevpL+iuG/tjEZ/8Ofl+bM7IdNBoNzX9k
         i+YNEJFWNMMAXnfsnSthqM/sAoAa7jYQgMcI4LlBwgunDthPF904Cc36ow2l8+0LoDAH
         5P4Q==
X-Forwarded-Encrypted: i=1; AL+hErG1Q81X4xaGnEyMUg3/YduDffyZm8LmgjKqszEyN/4qZ6mY7gI5olzqZ6Z9D1p22FdK2/DJhQ4O7w==@kvack.org
X-Gm-Message-State: APuU4Z+9rXba9+1dRsVD/2GZFJU2s7XEzKmZls7dzW7+nqi6WCUbNehH
	lsGAYqQuCuuoSGvZbwIpkuVeDLfjixqIDC52CPMHH9G5cP5xyoFdem7Cf0b/HoIOsa/fNA5EV6j
	0u0n4S+GUKcl5xijhbLpQjUMQGuENw4g=
X-Gm-Gg: AZFdTZdP5eyMDrv4dqEmj4Z3oAoKsfFu3opWQqj+JMANKpz8XV4MDDsydhEOmxXj+iG
	fQ427qRZ0vm0CB1S2bxtUcm4zB9rH9FAyGtDhs7GGzHv7kOS+vmBxu6z+7NHlZJcerla6PCCaiy
	b4U+pjblOgTNw/MXWx5DGEFZKVA6rOPiO9XxNyvlbjQRcrACfjd2/v1UgrGG2OssqLpLAilU4Xw
	ZrcT811FLFGpleIs9UNHKkQA/2e/7cm8oTDele2arcFWcNPg2dIaqZRDFv4ieU4VgF321m0Ja9J
	9rgDvtsck9N4aPGfyGWQxTIipaz1XTMh/yoFSS35u/sjw11mPtRCjZwWnABikKD31KeBz9Nk6+m
	UCucM8DgMLegUDFvAC0huh1E71T/FwxYHsI7N
X-Received: by 2002:a05:6512:39c4:b0:5c1:4f00:7b77 with SMTP id
 2adb3069b0e04-5c1bc6804cemr1456732e87.1.1795215722461; Fri, 20 Nov 2026
 15:02:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-6-kanchanapsridhar2026@gmail.com> <CAKEwX=P7To+AV9X3cXLCcuw5yoigdB8w5Ns9c9mDxJf+u5k8xA@mail.gmail.com>
In-Reply-To: <CAKEwX=P7To+AV9X3cXLCcuw5yoigdB8w5Ns9c9mDxJf+u5k8xA@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 15:01:50 -0800
X-Gm-Features: Aa3M54reRvLfoPZ5kvwPE0ioyJYfTZ8WSgE2duE6U9TLy4oHWqSA0alj0n9Xqgc
Message-ID: <CACpmpodffHWFu_Zfzx8tb3ghO_PJAMu1+LyaRXtmwK5a5GmzSw@mail.gmail.com>
Subject: Re: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8A21B180003
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 51ww83xkgiujd3akstda8a8tatk4kepn
X-HE-Tag: 1795215724-334417
X-HE-Meta: U2FsdGVkX1+3zO6S3WKWX2RnH5W0zA0/uu/Y0w+r89in05arFSKxWAv604+Hn3YorpxbAqf/nCLefo+CpO/6ZKImLwGqYWnz/A0taVbrFTdcRr5UDT1VM7TwSbh3hbBMWFKYq9ugj8dWlFpsJ05YOj0+tBsgSwJ9I1GWQxwQx/WAZ1PWpEezjI5CX4JuDhK8t1zRt+P2LxUQWgA66L8PjZvs2FJbOGMxtDp3XWghSYIEI2sW/EFvmcQhfK9pQ+FchY8PmxRvWF52Mcb6xCZ+DcrBo5HgQ+jOYqwTdDI7XaR1FUjNhq+FqCeQgH/9Y0X0zyk6cxBCiBa4Sk/bEXKjS93oPAMZGQNZANyK2ibo12qh/Ls/S4P23SBkMkggQu0seCZfw+C/vvcuOzT+EW+N4Rum/6x6kHj6jlmIZFZVFShGOYr0D6BUurftGgdQKqOebPu1Mq4ekMKBoNWvM1N7Cs12ubPMMo3Hljk7LD/x816USQXgkAj/cpXq7IjJxldhNksIAMlmdiKyLeYLClIcEr1kCqcII48bgdhrS6B/9ZWHdI1wmM+nqhdRurea3vc1bHKSJOnZftepb1x5/H0/aT6KZOMjfG4AIHA/wjRn6b2idHN539jGdGtAU9Eyz5cmqbYyHbcPN6PCMWQIIUK0iEE3hP7mRjOD+VK4D9HSWr8ibmq6ksrW47M3keNBNTgpegq8JAWT5Q535D8kLAWtzOnqR3qjOlUoMFTIUCSaNM5hQKp5ZGS7AJAVSr88zevGt3Gf7thaWhtgi/YEZuEhZ7Mr3pBir1HLSl66V8HfQ2VGMF/pmMIz4PXwCeTOb8DfLhHIg2iRr0VrX51/mkhSHYHzW8nABT5ngidEtWs+D8yu58Z9db4X6x+Hf8aQUKf7Kd32BIzdYWpZn6B1OrHitY78OMTlwqH7DQMeXVWYTIPlyaczBvkIA2i84Nl19jkKgEJPD56Kb9zQSQdbkQp
 ioF/QLDM
 PEakxeHx1l2O67MmlFmWZvPHXHYT7w8OWSvHEJvCVHy1FshvvVWGLZ508kA5rEozDzUTGz4IgezaGXiHeEx2LLbE1FWtSlNdqttqmP7DM1544H52LZNFJIdbWpqTTrZflcMCC4xoKL9PRNMz3Sml/zdl+BQ5UrHsejT9Aama9ALc+PnISYy/mI5laObhKUgWOpgnd83uK1dq4WwP4X9PwwXqCw0Cm9cCzXulOULz62LUuyr7HJLDjSXNy6NG0/tsJblgSSltiYjs5SCj9oZn5aqsEgF3/xjGEkICbUSrbVwTKQSLFlpdDvTQpPWGxkmFfOFIzJvE+6v769FLoQ1y9BciIgEuCro7YNZ0QW6UDOEoz3EYskbTd2lwkYh8ZcS6cOhl9pFCabDDzFTNvf5UP0bkMF2DddAWtzIjzCXBo4tSrv9eoHEndJMWBK9Z3veVdKUFhodSBquolKWlJRsq1GCjVEPvFihsxwEBWaBeUPEup8uNrIm9dPKLQsfyHdW9ns7KNH1nAwuxolvAVEmb9TLyXVlXmyDF7NmcqWM3xRMCK+abZGlVdVwktVCzby00uFAIHDS2RReDIm+wYOtM3Cn1RlfZNGBEzo/ceO7+L8ebfxQmj4IBV5vwqx/Cq936XPrTX2qrhPCCxWhstRfmam4F9aBUT0s7KVf2DWhKLSNZfyKCygLoli1Q1UHsVWDG1VY5YxwkyeIwTBrSh8UqIJJiCLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 2:46=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > When storing a folio in zswap, save the folio's node id in the zswap
> > entry instead of relying on the zswap_entry being allocated on the same
> > node. This enables optimizations such as batch allocation of zswap
> > entries for large folios using kmem_cache_alloc_bulk() that does not
> > support specifying a node id.
> >
> > Accordingly, replace the SLUB allocation in zswap_entry_cache_alloc() t=
o
> > be node-agnostic.
> >
> > The size of the zswap_entry remains unchanged as 'referenced' is lumped
> > in with the 'length' (as it doesn't need a full unsigned int anyway).
> > A build time assertion checks for the zswap_entry's 'length' bitfield
> > being large enough to represent PAGE_SIZE, which can be 256KB on some
> > architectures.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> LGTM for the most part:
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>

Many thanks, Nhat :) !!

>
> > ---
> > + * nid - NUMA node id of the page for which this is the zswap entry.
>
> Maybe "NUMA node id of the original page of this zswap entry"?

Sure. Will make this change in my next rev/patchlet.

>
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> >   * lru - handle to the pool's lru used to evict pages.
> >   */
> >  struct zswap_entry {
> >         swp_entry_t swpentry;
> > -       unsigned int length;
> > -       bool referenced;
> > -       u8 pool_idx;
> > +       struct {
> > +               unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
>
> I could have sworn we agreed to just inline this macro.

True, however, per Yosry's earlier suggestion, I added a build time
assertion for whether ZSWAP_MAX_COMPR_LENGTH_SHIFT has enough bits to
represent the architecture's PAGE_SIZE, and could not determine a
sizeof/other API that returns a bitfield's size in bits. Hence I
resorted to the macro.

>
> (btw how many bits do we still have here? )

We now have 4 bits after "referenced":

struct zswap_entry {
        swp_entry_t                swpentry;             /*     0     8 */
        struct {
                unsigned int       length:19;            /*     8: 0  4 */

                /* Bitfield combined with next fields */

                bool               referenced:1;         /*    10: 3  1 */

                /* XXX 4 bits hole, try to pack */

                u8                 pool_idx;             /*    11     1 */
        };                                               /*     8     4 */
        int                        nid;                  /*    12     4 */
        struct zs_handle           handle;               /*    16     8 */
        struct obj_cgroup *        objcg;                /*    24     8 */
        struct list_head           lru;                  /*    32    16 */

        /* size: 48, cachelines: 1, members: 6 */
        /* last cacheline: 48 bytes */
};

