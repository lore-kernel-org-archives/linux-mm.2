Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47DC606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ln5LGl5G
Received: by kanga.kvack.org (Postfix)
	id CA0596B008C; Sat, 24 Oct 2026 11:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50816B0092; Sat, 24 Oct 2026 11:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F9D6B0095; Sat, 24 Oct 2026 11:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 895E36B008C
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:50:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 083DE1A03AD
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:50:50 +0000 (UTC)
X-FDA: 85357957860.21.DEE4C08
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0872340002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:50:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ln5LGl5G;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792857048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFWGrkgth1iIJh7Anrwf3nuRUssZtgX5R4ZSgIf/0Qw=;
	b=uFYwEvJzVfq9h1XZnBWhcGf4pAKyZ/PqvzL1biSqO4HhqmoE9u36TeJVeCWM9qyl9FGglT
	9zXgr/8S0QexbtdgCH93kWqES/U7OFkLcYqeio6Iegb+LTscmjjz502Oe+NlLiEyuC3IsG
	mkeeFGIBI7X4bIuKtm+ZQbdd6sjPRpQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792857048;
	b=7tuiWsAQDOuyISYPJo2AeoFnqe0laXCv087p0rv5FQqOkWnlA/7n5DOphLEZeBLHLFlIDz
	jlmH7e6WFKH3vlQS9zKD7v99dJM+mD8gGQ6WGCBscKE6VglAkahHaD3+lt8SQ9bOmRQXyG
	0y81WfETSnRn6s/gSbAC3tZbvbqtf98=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ln5LGl5G;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c263415982eso214824166b.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 08:50:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792857046; cv=none;
        d=google.com; s=arc-20260327;
        b=fDi7riIeWyOdF83/g1FURo2h47UuhMlKiEzyX42/GeI2J3ursGjQ/+qJtCe2p+KCMt
         HwtxD3iPKRnn4lmo4TMLd4d76IGecz4G2oHnDPSX9kEX+UdoVq6xd6z50LjaMQxmCwS0
         ScPWk6KC7KiY3KaDGG3wFV9If4atxTD4aOiLKZXbsGmirYnAP+KXqP/XlUWz6ltMMyJj
         hIM0LgQI+Mv/fEgJFqff2p3fv+4rsFad3EkzLdEr7EsRu0oezDAIoT5+y8cOGeDnRADu
         TYg0XZUZHpvIrY29y2coBThxPdNa5sNIUiwhJD78SghyQZrWJjpFDPaMbm0QgL7abhAU
         mS6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oFWGrkgth1iIJh7Anrwf3nuRUssZtgX5R4ZSgIf/0Qw=;
        fh=ca+5BO7XQjgdInL88NOe128nl9vQ8QrZgTvL+o06lUc=;
        b=GMtokcUBHxdh6syFdCXwHbyF5Iv8QIEsCeb0fIPBAsNmBV0wDO5mOGDZbIGZiAjPXA
         OArq3NPZIJltPa4m6lNIcVoiQ92zqW9sWuLkbBgYeEL9dU77ztArKEB/xHBvemEh2uJK
         W2/rr9Fig0cvgsAyy7UXK5TQwGgiyq5UywU25O3S2wfWVgdXyV35SDGB4XZlxMLGeSDO
         gBGwTH7l/qsxGPezEP8jSPwSP+1ewPAgfowmXQPXP878zrv5dMeujQKkBUavuQzFm8il
         JclenlLgPIbpl0YbTOO4uVTniXzs+1m8uv0itk5tZX6QJC1of/MMgBwHsqeVh4o/sS0V
         2HDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792857046; x=1793461846; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oFWGrkgth1iIJh7Anrwf3nuRUssZtgX5R4ZSgIf/0Qw=;
        b=ln5LGl5GFRl+ewlMvfJ5MQuOOafg0aCsO7VrIiZWzrgZAbMaBq9jLrfjCAmVoo5tgA
         5CtgS2F7l2Q2bTUVdIwisEFLKz0qmAuq/3jJDjUapnI3aUYjSjKZgrmwvbIo4RLC7v6E
         thMSJtDvvf4v/Ko0qZC7ocL7u72xWArVDMGupeh07S/Y7Cr0zARmgsqL+5BZS7qEX9ZC
         rL932cOQKmxhbbvtHL+fbVrlEfD1W1Bm9N/8c6OFf9oZg8bXzNMe2iDdEMNCj675Jzrh
         LW+/+DdTEt9tS2UUlVzGVeINQSeR6EG/SLR0VwXj172JU5UodPrHwLsCslq1A8sUpDNE
         WIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792857046; x=1793461846;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oFWGrkgth1iIJh7Anrwf3nuRUssZtgX5R4ZSgIf/0Qw=;
        b=l22NnSyqWE+qDdfoAOa6dgeXTC93gdY1wDRk6WbAn9XNwWhsyspCAZzb2Nqw/z7/uR
         tppURXrkzE7p39maOrrsOvwfZrpe3fzN2fTbqETmlwebtD4Yyif7cTYt5RMzifOZuCyi
         KIrqrk3lm8pdBOxRTdgMqWwvPS2SAzbjpYR9Vca2bf0ltSHWY2jsz6g5T9FZm49JSe07
         TQsNIK2DeuP6v2rnWB709qS82viZV6I/ts5c3U4o7AYEDoNcAYO9O63teFINQ/t0VOG6
         huuAsoiYn95kCMO+N5WRxyIbAkShrzd8dE+0GyvFGmoSSZlrDDwYDKtRB5k4o3EZFzfs
         YhDw==
X-Forwarded-Encrypted: i=1; AKwUvBxj0OTrnzgCpDONP335/p9rpmnVOvaR9umtLhzXZrYROglKY0ZhY++0QVRyLY0pXRNR+Yq5UHMhzg==@kvack.org
X-Gm-Message-State: AFq9FYIpMK3frYZZNtMzry92A3Ki5hruwFpA9mzb8V3rh39Nw2xZfWyB
	YqV4b6Men/XE+U8YJH+JcTeNx/TjEn1Vvk5Sm5Njol34KaDsU0nAlr2+flQm2jBAH1ZuyJ50qtb
	+2L47ladzmOk/EwY1Fw4NJMPnHmIezII=
X-Gm-Gg: AYBFou2lHQ84/l/wODsn4e/vPIzHPOZiH1wpLKly3Dxef9aTPC8kkU3PowX/72Vyuqi
	qAdGD7jXSMo1EV7ePqNCVm48S7r2mX0ryxbja55Tb3RgzkK85MeMUFkCi2yC7YZ61g81I8Lz0ss
	pX1TzlbWWB5hEUvJOqtrNRKVDqcNxk9h8rQFbg6RVpfTsRNJnMV8kxmETBp07nyt+2bVPvdO7Yj
	VBJRjRLd2y/wtxs7dVayx0cKT8k6xvSYA+oFOnoiwZxwruv2JGHAhOo05NwnkHbSFIegsZSzWKK
	J/ZawRlOCSTl0ZW991DlI/Fm0+I24s48+qIu0KY8JrzXeLEVdP4QCkY3AZb3sHVOYSo0KzXBD73
	7aMqrbC52ky6esQ1YxL4BRALKgGaalhz3dik+SoAglRcxMq22GW9FRZAyowMYR4j37DBtlDGV2E
	SJVUe+E0krxOYxFcU=
X-Received: by 2002:a17:907:3f1e:b0:c41:26b8:c49c with SMTP id
 a640c23a62f3a-c46bdd97c19mr234177866b.10.1792857046023; Sat, 24 Oct 2026
 08:50:46 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com> <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
In-Reply-To: <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 24 Oct 2026 23:50:09 +0800
X-Gm-Features: AclHuK8EdrvPlNQOkv86BcPqxKsSvjXgFWnjUR3jEYoufbz3bHhkuKrZQsexIF0
Message-ID: <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0872340002
X-Stat-Signature: isi751epph889duwho4sgp7ys7k3r7hc
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792857047-555392
X-HE-Meta: U2FsdGVkX19TsJ1Jo57ox+v8x0nx49I6T+lvb2rnaFYaCv5VBA16CpyvTWoQ0hs/5uPFQJHvsAzDm2N7dswzsKKDVH2xsCWn+1u3ErtC2VzdOopCjAqGqxwKEk2BODK7EmqrcdRkQOwKIfnnxtuzxGjBNWtw+CccEzyHfTbGk/FdYl7bCGdXftlol5BqmDIMMGhLtgLU5vOGJw680femIzttXbDmpi4O+eXOuyAolZGAK7pzcHUusxGxxocgb4aEwsKRKcu6f0tbDQYnF42hECmgt58mbm9Ds3s6v4+dd2q61Rts+dpluduckl7pftd8mpE4QBJ3fAUTLgeGGyIo6S5Ym7wDcTM9Zgk8ufNd/hhTItJfxSLtnnWB2VemS+YzXd0oMnAcxNsd+CNoHxN7yK8qXISDxAlanEbaKEHiwrDAoVFShdaJ88PxKZVFbaxs5isFLBiw5pyS5q17TSZoo3wLKGDYVSgfjtF3noOdPH70KKUMr/F2e+AQa6+Yrpt/HPbwnVxA9e7x1VQCOkizdZiwAHZ0cJmcnD7Dn+Cs+GK4dcFflQ8OEDykXMQIkFK3uWrOkoUnLzQ3dAh6td1OCGWnUQYZTtbFftWQFR8WJPBoali/x7NvVBgGDVPc9EcWwkccrGxziCfgsnaF+mhTnVLt1z2vE2nBguGZdXtNl0JrVOxqhdWiOZep7OmUUjRF4gq0uzkTmojQ5PUrDrfrJuxqKtd3flRihnZgCY4EDoM7SbMY7fvpGRSsIbg8RUrn7n6qxKV6ZgFGHZ+4vV8h/93KLFLYunOf08sC3gnByjL8HyxCVlKxx4/aj+kvKSuth+IKCMw4f4GwbJVBigh44ML1PRZRR6XkVaMJpl+4JICPyDtsNUkvp+gJ7HwLn23FHd13tRx+pvKU3+SKcDX77eUQLfnOHtqy+awjWUTmGO3yhJcaZ6tzDAkDyA+6VLt8adrX6p272P4Sy1ozdIQ
 ih7H0cH6
 hHD8CIj1mmNVsfsh3Ae8F4a7oexIl2nJd9cNbUQZWmUGZjVEcvbkB5cG/V/V7caqIgfeQhMPxXC9MFE1kNiGdfQuMMc1AHvNr6hkHlni7wots38GTH3WBgEe1jtdWxRh3ibfxNLu2pXRy1AGhoCsBwNKKG4/qfHcQRdysQc8Gok4ZXUEbHbIUhRGPG/LP2j17N0Bw1S6zYkpE6/Tqp8IfJGxa+W+8R9s2O1/g6UB0poakY8kMy3ZAJePRJlYGEuEodU1rVj7xbkxQh7foPxdOldk/EAZgQmLWgDqO8KJaSuRUGZwY3NlRbfyMLWMyERfmDXU1YwpQgQdIs1uJ0rH7sCNzvgYvIzvebURNsagcSfd3AbcZUpfFQnBy0Q8wTiMl9p4+7mPfROVRAYC2RQSetQWqH+N/IT4FfFmNHWA1OvKmui1HZftBDfKOVcxCodTULvcgilAkZlc1m8CzzRiW4ih872R9alFl8+oDxbVExV4xmDflZYxqsU76Vxr3HZfMlCoZUgfkI9J7OniqmF+ab+hteOzhOyY2SRIv+77bdn91YpZJKmLHvcpaku2vEspn7JpS9vaghU5cFNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
> >
> > * Swapoff: this was brought up as a request, but we ran out of time
> > before we could discuss the motivations and use cases behind them.
> > Folks interested, could you explain as a follow-up?
>
> This is one that I really don't understand.
>
> In my mind, we have vswap sitting as kind
> of a swap VFS between the rest of the system
> and the swap devices:
>
> +-------+     +------------+
> | vswap |-----| swap cache |
> +---+---+     +------------+
>     |
>     +----------+-----------+
>     |          |           |
> +---+---+  +---+---+   +---+---+
> | swap  |  | zswap |   | zram  |
> | file  |  |       |   |       |
> +-------+  +-------+   +-------+
>
> When a page is unmapped from userspace by the
> reclaim code, it goes into the swap cache.
>
> The vswap layer then decides where to store it
> at eviction time. This is configurable by userspace.
>
> If the zswap pool is shrunk, the vswap layer knows
> where to put the data next. There is no need to
> change page table entries to indicate that the
> data was moved from zswap to a swap file.
>
> If we decide to disable one of the backing swap
> devices, the vswap layer can just move the data
> into the swap cache, and the page reclaim code
> can evict it into a different backing store, if
> needed.

And in this case we want to disable vswap itself.

> Using vswap as a swap VFS would also allow us to
> get rid of the page table and tmpfs scanning
> code we have in swapoff today.
>
> In that model, I really do not understand what
> "swapoff vswap" means.

...

> What exactly do people want to accomplish here?

One thing is, to prevent page fault (minor), not sure if everyone is
aware, but a page fault itself is sometimes slower than swap IO /
compression (especially for compressed swap backend).

There are suggestions to use MADV from userspace, which is not really
maintainable when you have thousands of different, opaque and dynamic
workload, and that is very common for cloud providers.

I also hope there is a way to release swap metadata completely too.
e.g. for fs, you at least have umount, and can rmmod the fs itself
afterwards. We also have many ways to bypass the page cache. In cases
where a virtual layer is just a burden, we want raw physical swap, and
the ability to swap off that too.

