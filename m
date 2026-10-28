Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D930606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pQOibE5W
Received: by kanga.kvack.org (Postfix)
	id F1F806B05B5; Wed, 28 Oct 2026 13:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0686B05B6; Wed, 28 Oct 2026 13:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF946B05B7; Wed, 28 Oct 2026 13:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA6A6B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:51:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C38A120197
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:51:54 +0000 (UTC)
X-FDA: 85372778148.24.0EA47FD
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7D3384000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:51:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pQOibE5W;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793209912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mF/L3R2/oy06ccOwt7FWjRMyAPem26+3IHOwef8ICXY=;
	b=70btPYBsEi2M+6HyvasDuh3ou1NTiC7KCbJ3R7IKYpShU9zk21KTXTzYb8BmJa9EDTuYY6
	PcIOrPJDKkrkR013d1OcdbWT/GJR4AVZ8u/KmQ5qvMxMZaFPHtW6mgbdxDcxI1JbWLFADp
	eEhqA+LOOEw1FCKi4A/WcRk8ChsGAMc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pQOibE5W;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793209912;
	b=mmqbaEthF+jeESBW9ifs4o49p5wMGkdXGg9S45wTLPiHPhaPGY80+j8kM2RvpRbbBCkq4k
	k5yJQZDDYGknYwMZs7cnhi2ah5zJim4DZK8qmqE2/R9DCTYopH2ucGWfc3IfWxV1AU2XkI
	xS6o0je11i/FBb4tQ4Pu/zx3zh2JegU=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b0a921ee46so12082207b3.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:51:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793209911; cv=none;
        d=google.com; s=arc-20260327;
        b=BgkIzj5kDEa4wiMarCEx9WE42E70fp7Ddrm8GQGPBAhd+Ix1H/6YjN2N+q/QcsKNIo
         +AdJ/qz4tY3eff1AhluuECZo1O/HuhioDO3BmXb82AdTN+U2g9APaARd8h4Y8DhHRR7Q
         ml0T35+25wBeRAIgBWqUHHJVlmG4VoF1EhqXwUcj7w5YgVWx3ofVaPoXGKlsA3vLJAjb
         0BbqpYCBr+n1mNZ0BMr8UQM7dbmMmwdj6XI/vUHogPg3yXgBVN8KQIAb3zSBkfNRsOa7
         dvZhdgb/0JVyccJNQiA40Q6RZjS8GE/oYAJ5puJAta1XLnblKH15v4Gp5Bzu0SqnnYiQ
         OofA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mF/L3R2/oy06ccOwt7FWjRMyAPem26+3IHOwef8ICXY=;
        fh=pLm9k78AlHrHiSj/tZmzv904gRVd2+3qU6iRxpCcAYg=;
        b=DJarpPOn0S7YZsdVz7FWybuL0ddGYdcLnSSXrrko0I3SrEipM/jqa7Yz6jh5B3O5Mv
         nruu0PpYGzWpdAhe5dDZL7a91CitZFCLtN9Yx+wyza+Uf926OcvG/vVzfkY+gvLws3ys
         +1RBZchi5YQC12AwexQJJnVPFXb7YPBcSt/Qgfw/oLq9bL2KZfDeMYI9tuv08zH+ZS8I
         yOlzuyV5i2GcE/4qBRfyI+cO3hIecX9PY+uBFrlndMnUpN/oaQtRZHjUKQ6Vkizpab+7
         jzKJJRdX/ArCji0BUSUrvjEM5orAhHRP0u0opjThiz7S7oAtUtU9u+CtswwbgVr2WYq7
         G1Zg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793209911; x=1793814711; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mF/L3R2/oy06ccOwt7FWjRMyAPem26+3IHOwef8ICXY=;
        b=pQOibE5W5sEy6R30e4DxpyK5HAytQNVo78ULWwEbFPpeW7ghRS1ViVpFdOkwcmh/dO
         24AYpFBMOI2PIb4MIIK8QeW4gtcd221qtC5wNbA4YF0hWht0pWgqBP5czmbgmra+dbE4
         RmbMBzx+IqTi6cW+egsqUNHc9emOAoKtTOBQjpgASYAPStV/U+IxuIwPEus0IxHvQyG9
         6oFHKxUsnaHP4uqdSAl55sO3FMozt9xrx4QdpQ6PsaMQsBKN/f32CHPTS02Eyo8zWqye
         R2ppTLSiCyATibwb4MKpjLa2aFbWDk/arWbw6MawCdtStK+/bUduZ6QRqd5E4Zna3QW6
         Wzww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793209911; x=1793814711;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mF/L3R2/oy06ccOwt7FWjRMyAPem26+3IHOwef8ICXY=;
        b=RE0OBohAQTobo+ysdY5iFGF+p7Nr68fDiH3JTB4jKIftWYN4ilDxWef39x4iX76AgW
         FsLFHCXYSFuuKY30RLxjuRu49/dNQlqhxWQDlzCiTUyCAWKGON+heWokOJah47NeSEc8
         jmltzFJC6z5uEKBbWPiJGWkRU1hRSFF/P7/+HaQZ06WD/g0uyFy/kTOf5H/sr72G5nY7
         vBoy2BxHTFICod21xpgBxcaBoVtel0m2T0P0WHs5qVG98z04RP8dE62P/r3f6+h9zan0
         1gcWuTKHvybR0/ff4NgOnDk+ue+COrMBGs4EgGMkZp77lp0vNljxP3v8P9r4GkrnGBCX
         /9Jw==
X-Forwarded-Encrypted: i=1; AKwUvBznh6XKyhTcGsGBe2jbiz2TXUP7gG9Gwv07J8ehsp3txHCkd7VklZtsMhK6045jX+MNFfuxXwSI1w==@kvack.org
X-Gm-Message-State: AFq9FYJdXfB71QMmjZ5c8WD85P8vsL4QGTy1ykYR7kNcefcdByX+GZyB
	UBRkoJojBxraF9xQlG9eMg+fodnAwbqxIi3WqUJvZ6muyyRmTHGcv8mABIpFlmZ/Ihn/qzf+IkQ
	GLIscsdIwZuqr4NBNRxpQMTIUbsYO2/v+TvpAIJrM
X-Gm-Gg: AYBFou2nKy0robaE+BuZUPs/B3t3TpZS93+/DzD+yPkw+P/5RBNFSN5j83jU49pE79p
	ivhsIriNlAvdvuw/8vQA2KaOZ+M4X4PkjyRmi/Dfgvri483VUyHBr5Hig5QXjA9xF2bvZvgc5KR
	GBiHwT0xCck55AYszrV6ERPFrZA5fr60ssbVdmnuuBz6pEWpsIy7KSqOj6XRrE3RD6DZ7JZExKq
	a96p8uo+9WQf4RyGTSz8hcUWmAy0U0+lYb41Bv6vrAOTvYRgeVfX9tQsDgAdxjaysqZLaeYk17x
	TIYhaA0nYPe2lSY5p0TtLbamvU39zPo2o8grOO8tdyzLzTH5GmMI3X94bd25OhoQ40LV+KLFxFr
	vm3Uay36Tz6A3hXzKf8bcwfRIxTteQP+YAIiJfbeCHVN8N1cr9tNWDorY49pzOYGOTA==
X-Received: by 2002:a05:690c:c512:b0:89a:63da:fa8f with SMTP id
 00721157ae682-8b1b5d5b9a8mr19678387b3.74.1793209910194; Wed, 28 Oct 2026
 10:51:50 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027051245-mutt-send-email-mst@kernel.org> <20261027163814-mutt-send-email-mst@kernel.org>
In-Reply-To: <20261027163814-mutt-send-email-mst@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 10:51:39 -0700
X-Gm-Features: AclHuK9-u99s7D6HT09CfAyO9Ftn7vr_iH3z9UIt21N8WRT_BYsbqycnLIpHOb4
Message-ID: <CAGdbjm+f+b8bMBFMdqXavXx79NSnXzDFeJRUxZdEox_+dKV6tw@mail.gmail.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>, virtualization@lists.linux.dev, 
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sidharth Telang <sidtelang@google.com>, 
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Jacky Li <jackyli@google.com>, 
	Steve Rutherford <srutherford@google.com>, David Skidmore <davidskidmore@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7D3384000A
X-Stat-Signature: 3be9u1agftek1qi5994r4fsrsx68rmu8
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793209912-942203
X-HE-Meta: U2FsdGVkX18A4D5kYXGD9ax61Sw6/sOOsdEVMLy5zU7GD9Hsv5T9KP3yQNNJy9XCUWPbFgGqUHBIp3siN0ilrjD340JXAHHzBXBrTUTmCli6Na1ZpDOFSGFNPqpZJYyy3mET6EwwEhqx8J4w0T5O/RKPKJB/KB28Dxg6wdgDLm/RphfxXwccXoV0LF1xEmzXo4qTFZ3bVBpAPGRkza4gFY991PRVyQ5GnBz0LJeEgaELmMbHc1Vj1OnvY1fS/HaT3KZD3nr3sGHS+ksme+4sBsL+CKqy2fd4XN39MeoimC+0glpQUm9ad62P5/PyiRLJd1esZbBqH+R2gc66llZ4qLRWr9xiNr+lZ0FRuFu0dL3RaD5ZwYFFnPNvmFRNrXQVWColXyCoMU4sNWP1njq4NV1P/P/4YgytQqLNkT5dYMY5krILaxkfb54kWgb94bT3QTBd6xBqP6dF0zpxRB5rHUqDOSc5VuympcYooRBrQM83EmAKwZ69+ALsiP3QQ+W+S+pvkWd+PtX6MXZToYIy/3ul+TLpqIz3mFMvgXjpBOP3dqodu4V7ab/7ZYn8eVdV1+/DRi1OdEpw43lLk5bVhzgQenpTxGdQhPbRACyeAbHumD5o4IGrQS6b0Fk6d88rQlXgPEdVYYTgqk6S85qE6z4FrkyhCPWvjSTMozl1nMy60wXzi91q8jJsVPkUJzgonjp73no4A+YSTU6adi73DdepoeN18RcWuedX9B+wHJOdw6cqESM5UdfqaMV6tCW+fGPguy35i/u/HhBv1Zz5vfXA8E1dA219tma4beSLnKUsOJ7wMuDmKcntthSzw0T+75DB68isKMlXKEDfopIzrl2YWh7Lp7jUBw6HSQbBO5OrkPBgjZrMqNz0y4lQ04Ayh59ne+lm1HKIY/8pONqMr9jP5zKvMwgCz7vhFjLXGthEkbsizif34D6alaZ/EZ6jaPHFddiU27uMLPLzcmw
 dbgC5OZF
 Voi8iHnu4vaDy+TdJJlmo9DcwY9jhq9gLixWuIejgCouhu3l8fa3Ay9seM4F8NQdyT3C+B9M0KKX/qLEfMwcqNjgQtu3JshXA49XakE4APQKW88EFWMPwrV0IJeeeu/G9R/rAoKWhVAWm8PFxbeI24Gn2LT4vvrFhg4Pcqf5n80549s1/zp4N/4aGjpXKOFOPWNV9uOwdjtLv+qYJtMgP64OSt700OVGibU7j4nA+HIL376TYjohdtTSDvegIyIpsRtzKQq0zjqarq37sZF4mlrnSj+hGoNvoGMzTKJ62/DauGCJpiRwlXUPE15YidbOPenFD69KJ0zSm3qg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 1:39=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Oct 27, 2026 at 06:29:35AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Oct 27, 2026 at 02:56:03AM +0000, Kevin Loughlin wrote:
> > > This series enables virtio-balloon free page reporting and memory bal=
loon
> > > inflation/deflation in Confidential Computing (CoCo) guests, starting
> > > with architectural hooks implemented for AMD SEV variants, in order t=
o
> > > support dynamic CoCo guest resizing.
> > >
> > > Today, memory ballooning and free page reporting are essentially unus=
able
> > > in CoCo guests due to three main roadblocks:
> >
> >
> > For me, the bigger question is not whether we can, but whether we
> > should. Considerations I would like to see addressed:

Thanks for raising these. I will address all of them in more detail if
I send a v2, but here are a few shorter thoughts that I'd love your
input on. For brevity, I will ignore the inflate/deflate case for
CoCo, since I'm planning to drop that, and just focus on free page
reporting...

> > Security, e.g.: does knowing which memory is free leak information from
> > the guest? If no, why not?
> > Consider CONFIG_SHUFFLE_PAGE_ALLOCATOR, RANDSTRUCT, etc.

I think the min order we'd support for CoCo free page reporting is 2
MB (and tbh we might do 4 MB only for reasons I will mention in my
reply to David's comments in a bit here). On that note, I 100% agree
there would be some new direct leakage of "which 2MB or 4 MB regions
are recently-freed or recently re-used inside the guest", which may
present some side channels to infer other information.

Some related channels are already open in CoCo and don't seem to be
signficantly worsened at first glance (ex: for
CONFIG_SHUTTLE_PAGE_ALLOCATOR, the hypervisor can already induce
faults on any GPA at 4 KB granularity). However, there is of course
strictly-more information leaked by adding CoCo free page reporting.
My hope is that the coarseness is a reasonable tradeoff for some
guests, but I will follow up in more detail.

Aside: now that I'm looking at it, I think some aspects of upstream
page shuffling logic might actually skip the unaccepted pages even
today, so perhaps we should change this regardless of this series. I
admittedly don't have as much context here right now.

> > correctness, e.g.:  Linux has init on free (and default on windows), if
> > initialized pages are dropped and host can not be trusted, they have to=
 be
> > re-initialized. Is this handled? I don't see it in code.
> >
> > Also, performance, e.g.: How much does this re-initialization cost?

I think the existing accept_page() logic (which would re-run if we
fault a reported page back in) is wired up to
free_pages_prepare_init(), so I didn't introduce anything new here.
However, I'll verify this and call it out either way if there's a v2
of this series.

> >
> > Management: it was simple with balloon off unconditionally.
> > Now we are in murkier waters with various features offering
> > various performance/security tradeoffs.
> > What if some guests want the tradeoffs but others don't?
> >
> > Documentation: for all of the above.

100% agreed. I lean towards an opt-in policy for CoCo free page
reporting (ex: via guest kernel command line, which could be attested
as part of guest boot as one way to verify the setting matches
expectations), but please let me know if you have other thoughts.

> And to give this a bit more perspective, I present:
>
> commit ab676b7d6fbf4b294bf198fb27ade5b0e865c7ce
> Author: Kiryl Shutsemau <kas@kernel.org>
> Date:   Mon Mar 9 23:11:12 2015 +0200
>
>     pagemap: do not leak physical addresses to non-privileged userspace
>
>     As pointed by recent post[1] on exploiting DRAM physical imperfection=
,
>     /proc/PID/pagemap exposes sensitive information which can be used to =
do
>     attacks.
 [...]
> Leaking phys addresses to unpriveleged entities might not be wise.

Yeah, while the host already controls GPA -> HPA mappings, the free
page reporting would indeed likely give finer-grained timing control
of what 2 MB or 4 MB GPA regions map to which HPAs. So yes, another
potential case for "let's only support this if CoCo guest opts-in."
WDYT?

Thank you for taking the time to review, Michael!

