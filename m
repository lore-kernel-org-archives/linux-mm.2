Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5810606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 19:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DPDT/lhL
Received: by kanga.kvack.org (Postfix)
	id 5C3916B05B3; Wed, 28 Oct 2026 15:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A926B05B4; Wed, 28 Oct 2026 15:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B08C6B05B5; Wed, 28 Oct 2026 15:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3BB6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:50:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84F7DC024C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:50:09 +0000 (UTC)
X-FDA: 85373076138.03.DA1BEE0
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 89C9B140006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:50:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="DPDT/lhL";
	spf=pass (imf09.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793217007;
	b=Z0AsIUk81e1/xyTErGKYp+3NO037iAj7v06yLsUm9kMqZR87xgv9ax55oesW9jU5laVxZZ
	0b4HXRkJ/2W0E1a8sX46FlUFLJW+0ZtFagC90Wv9YhOr5uAgSRRc5qSkDYrCg0H43J/t0L
	74OaqHkKfQvSQ8qNvVaRzrjQGRJnSU4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="DPDT/lhL";
	spf=pass (imf09.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793217007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6V0ut3kqKgQIto1YCEH+vR5sKEvkw9wBhgLEXh9NNo=;
	b=ByOVwFKPO52D103ivRMmWD/+NVLJ0IEWM4vHeNt357atyWYX3ee/dr4ppOmBst2zvITHjt
	4UuZy1jEYaikdi9g3pL+Y5OqwzRY7/xAGHxr2Tk+AZOIQgiVl3/8EmuN22oW6/E6QGS+i8
	gD03CwyW4qLLL1+lCkD7MIH23GU1Ja8=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b05bf699easo14732747b3.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:50:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793217006; cv=none;
        d=google.com; s=arc-20260327;
        b=GtaUZuubl7NSqevD+6IXiT+nbKU95ZBifY/6bRP/6+VgEzC44QpWnyqiIoF6SBlYz5
         k4cmGmXPyfz3cuewTW001SJFQr7BnhkwWN0a8JI2QYm6Xzu0qxWtttmIF31QcnvvSVjj
         UwwUF+n8YcJtZNedXw8b4PkxlpQMRaERVxXm+1GPhng4UuOJ5tUB8sYv4BU4mtXR4Asl
         ivp1rQwEnWmvqjKsGXdkKvtrDfyWwURjY5Len619YBhRflMLhnRy5hAL6i9whjX2NUc6
         0B1afkuPXvaAe0k1aREea+S8TIao6ZQEEmMb2D5srZ2BRK/3MJW+uqU+PMlSoqccddRy
         gOeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x6V0ut3kqKgQIto1YCEH+vR5sKEvkw9wBhgLEXh9NNo=;
        fh=pvTCYPVt5vs5AnVMFhdAfqHmWIQakawVB1UpnEBSphE=;
        b=OdsRfj/Q84CnT04IXzxZm4NP9xoKxeNy1JnfrhbEu2RKOprWodHOEQ7+BRXw3hAwEX
         EUkIdMfktesjxbub+ZMHRM9wDcD2eqrdUI+zhnBM9ARxHXLJLpgZNSzdQvFn7YpdJaIV
         dL35rz6442g9z2d22Q1ekXUOSH20+HynxJud3eXD9RqmyZPeBWOl6HQ8S7nowf6FPnEM
         bHQPj2J8qWvRGG7aaf8x0QydrChN1Gg3mdrKvxdIWYW8QCNR2H6la+DP2z9vxBdfSzYP
         rAEbLpoHDEaHFH94FWpib+iZn5ugTLNmf5it/VyQ5A+k1C5gS1F3AlYyiI0M2eCWp9CD
         E9Bw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793217006; x=1793821806; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x6V0ut3kqKgQIto1YCEH+vR5sKEvkw9wBhgLEXh9NNo=;
        b=DPDT/lhLLGj15It6ym8YQ8deqXndb/nxVA0vUJFjmQsleERpMUfRjUGpY1/yZxzVNI
         ryJZ47A204POMHI55I5UdY/zLYrcxLqF8MtIbIkO0BCY7w2MoszHZprstnbIjQyPnHg7
         7Sq418VYxDU7JfOHGjr2SUwknahCMnSN+Dck+gurjp474H/yM/ZYF1P6KJDYeMew9HjA
         WzJCJFV8/3biONrjTleZZhApaCG1/U599pfnS2fyE4EfEz0JXqZd96WJcRSiH6ASyPTR
         jn59Hy2zA4pd8NRkVmTr3gPD9bycztj9g+mjRxUh+EE+ZxJ6URUuiRX/RMZTergt6AKd
         WVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793217006; x=1793821806;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x6V0ut3kqKgQIto1YCEH+vR5sKEvkw9wBhgLEXh9NNo=;
        b=TfO0ew+zD5Xvlp7yeWwKmfrQjiTT4bDBgnLslNw3UPIt3hE/rlYiGiF8EaO0Hv9E5W
         wBBfXlnmcFqWMD8ad8h7F7nzQR3HwqM/WgD5p0WMlCvVbf9SrdHyl5EsFOl+aekDeHC9
         yKIJQtCReFQeVia1zjpu7mu8rXR8OOjXJEP1zdVQ+0SAH9vxiR9ILLiUDe4UTxodUL2C
         HZau4HTKcQkC/mFFN/PZZrv4QsGwf3LD2xigWCsYDP0to9IZgmDFhkVvds2FMIuPsWmT
         arDxOcZKSiXUGCfyWtP/QBalIZBqx/DEqdPtMAx86PdMKZHxEj0y95g40FpQ0QpoCZp9
         JYJA==
X-Forwarded-Encrypted: i=1; AKwUvBwCAkYXm/zF2Y8o2pbXPTivyran6A/TIgqdBxR/eEDNanu1p7UGIIB0Gn8uEPXVjJsMK6wQVl4b9Q==@kvack.org
X-Gm-Message-State: AFq9FYKS10NXx/jqZa+Q7TsQi5G28zE08kmh136ckVnA7zCSivJR9t+0
	vQ5zFV4a08CqjlOKWTeXMy26dGCYeBnB8PHse9zn9D487hMhpXD96jiNS2K1lxcu7xfPXAm3CFH
	RN+hcTzcxYGWovg5fNebOpLwfHy7/rc2MwWweOnDZ
X-Gm-Gg: AYBFou0I0wQmpt8A8Vdk7px/20p7pCNUqVk8AJ9Sf65Z4RPuOFLP+78L6HSaoAVru28
	aAdI1PVXgn1ARAHIpv4JlAsiL5a2HKJFEppASfjXD2veIAaoVv7WxzejIukhhOlS3zuedsXlseW
	Zj7M5C1bD9SQ8NNdDvHomGdCMM4WRf3j4vrj2U140qzems3isrreWFakfLY103uFQcz3IO4bdNS
	NHzWrgvuvibu4cflkpkpArY3uQI3KPe/aLM5JD2udl1yNGPq0mfnAcHlUvPPVhwDY6uQ3emAY4l
	zSYVAjjuqfqEIfMsE0nlMI0VLau3mvN6KgoSflkc7d7+dRYE4/JDtenBdL5olXi36LSv5VeBTP3
	tSDwX+kv8gxmf5DN2HTPVcofJq6OtFMzANvUe0ZBaU/IOHNMp8cL7nM+VV3/QSuHdOA==
X-Received: by 2002:a05:690c:498f:b0:8b1:a485:dee1 with SMTP id
 00721157ae682-8b1b5e870f8mr20662047b3.62.1793217005584; Wed, 28 Oct 2026
 12:50:05 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <279a92da-772c-422b-8047-ad37dbae211f@kernel.org> <CAGdbjmJ8qk7FCbGU85u9+db5_RtcrK2y_7TfNH+iuz+OJxebow@mail.gmail.com>
 <20261028145316-mutt-send-email-mst@kernel.org>
In-Reply-To: <20261028145316-mutt-send-email-mst@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 12:49:53 -0700
X-Gm-Features: AclHuK-xGxvCvL4otBtvefj81uI5MhPmhwclIN6rdpDM6CRLGOUQBZrCbVhrSfI
Message-ID: <CAGdbjm+4Jqx8Xv3uvhgaaiThYuVT0vF6UGx83XUku04Q_PN+OA@mail.gmail.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 89C9B140006
X-Stat-Signature: xandpyutoww5r9ajdzhq79dmwu7yhqhm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793217007-706684
X-HE-Meta: U2FsdGVkX1+FOO414HkJ8KP1d+oJ12NzRDdcPOvGohbRj54LKdwa2i84KMw83DTelOjGxcyZq8enD837iTZi0tszankb5Swr0nP6p69ooM7qH9r/QUbl3zvTRNCJjGN98GZ+HYo2tHVE09NlFO8M4Ib3rbt4HhjuUmi5e5MGL0Xdw4L8vA8aLzS2TxCENOmaxM0qkxIpY5tVz6yq8X6QQciH5PCfyJw56VB1uhrvVCJw0me8G6mlhneFV9GW6cJ5n6And8EtxYIm59FyJy+xD9U7vwkvfstacDSEGTDFGfmOlzHrQY8O8fKicdzbbBaK08OWbisfDVLSVgW4eP30nWfWMwCp2N2hzN0UOn6KPSj8EDLuiTE0BXnJIuaZvSTpJUpXD7hOh/fhHfUVgBEBZw8F1cSiIbYK6s1da1d/lWxD0vWRoUOS/16YiCbW473ACXd9LOJN7f5lu+O4CaQbwDwAl+gNwL+4Atg+AFsdAVw8meWJpwJOj0xUPRKMNyYwBNyewQmQS+XP1LTML7E8Nng3BwxSfyXgtpjeMPpTGjDL+ZeIMWZ8ot3NalBDFHQPN5XTX90qFmxUXESyoreONJsijPNq64I1xPeKVMZ4kUoHMcwfP2LoLhEAwSahr4tj5UBkAOepSSNUMqRQm0xsjxXsTQUpCL1HUKIZWFT2gOwDc7jvhKeINkuK2RawIaaTV94ZHXkd3FeciHcO82Qstd8Ukvzyy/FBHDYqjNEPhshKQ32/nssgX+3xJgxixU3rJbc+qPreL1h4qaI6EvNhBkkb3W8wEY5oJrXAE7aA/BiEnw4YcZXcpwKvj9H4EWP8frDTJem8P36TUqFSxUHfllDdv9kt1SNdlPrHdgE9D4lH2ui1725LNpHCJUexD2knBejL0PHfeQX642b4W+YzX2BKna/D0D3EXjND9N4MtfeM74KmKMzk5FGuxmFjZPhke/5C03mJd/710sx2rxg
 qAB7wjiC
 MTQ2PnCbzke4GUr7a43oYHjhNDJqeBvgMbPZbWO5nGPvqlK3kueBy6LISHX9wCmxLAzIkU47oBKchsk57o1EJEn+FIk5PZTaCKCR/gLUhpk3+kItc92Q3RM+7Bsm49aanhAMQ8eMqy/BPxqu1vZKS3SCiNKXIP0Yh5LRzDk6ZIEaijENWk4AhhP3Le3hEmCc8mX+DTMSYBo3+wD4MvaMk6zkR4AZnu0VTc6FmW4aVMN+J/CdweSBggOkxT7xysEX1ganjVwMTrL9/XoZQ63YLd71fyWYGxnN0DO9cqHxoY40B9KblHpq48PUz4lIVErk+gGtFiP2GDLADjkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:54=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Wed, Oct 28, 2026 at 11:12:47AM -0700, Kevin Loughlin wrote:
> > On Wed, Oct 28, 2026 at 2:01=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 10/27/26 03:56, Kevin Loughlin wrote:
> > > >
> > > [...]
> > >
> > > >  mm/page_alloc.c                               | 248 ++++++++++++--=
---
> > >
> > > This diff stat should give you a good indication why this series is n=
ot acceptable.
> >
> > Got it. I will keep that in mind going forward, especially if I end up
> > attempting a v2 that simplifies things.
> >
> > On that note, I believe the majority of the bloat in mm/page_alloc.c
> > comes from...
> > 1. supporting the legacy inflate/deflate option
> > 2. introducing support for various page sizes to be unaccepted
> >
> > (1) I can get rid of by dropping the inflate/deflate option, which I
> > think makes sense given free page reporting should be sufficient to
> > enable dynamic guest downsizing in cooperative scenarios.
> >
> > (2) becomes simpler in part just by doing (1). For further
> > simplification, we could potentially restrict free page reporting for
> > CoCo guests to the current 4 MB MAX_PAGE_ORDER instead of supporting
> > any order 2 MB and up. There's a trade-off here for reporting
> > effectiveness under fragmentation, but perhaps support for 4 MB only
> > (and its relative simplicity) could be acceptable? Especially since we
> > would then maintain the invariant that all pages on the unaccepted
> > list are MAX_PAGE_ORDER?
>
> I'm not sure what is meant here.
> But if a lot of memory is free and it gets merged beyond MAX_PAGE_ORDER
> and then it's not reported, that's counterintuitive.

Sorry for the confusing phrasing on my part ("2 MB and up" vs. "4 MB only")=
.

MAX_PAGE_ORDER (order 10, 4 MB on x86_64) is the maximum order in the
buddy allocator, so free pages never merge beyond MAX_PAGE_ORDER.
Today, page reporting logic scans from page_reporting_order up though
MAX_PAGE_ORDER.

Accordingly, what I meant is:
- Currently, upstream mm/page_alloc.c assumes every block on
zone->unaccepted_pages is MAX_PAGE_ORDER (4 MB on x86_64).
- In v1, I set page_reporting_order to unaccepted_memory_order()
(order 9, 2 MB on x86_64) for CoCo guests, such that free page
reporting processes orders 9 and 10 (2 MB and 4 MB). However,
supporting 2 MB blocks on zone->unaccepted_pages required generalizing
mm/page_alloc.c to track variable-order unaccepted blocks (Patch 7),
not just MAX_PAGE_ORDER.
- If we instead set the CoCo reporting order to MAX_PAGE_ORDER, all
MAX_PAGE_ORDER free blocks are still reported, and we keep the
existing mm/page_alloc.c invariant that every entry on
zone->unaccepted_pages is MAX_PAGE_ORDER. The trade-off for this
simplified logic is that a standalone 2 MB free block whose buddy is
in use wouldn't be reported until its buddy is also freed, such that
they merge into a 4 MB block.

