Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05727606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mAW0sb8c
Received: by kanga.kvack.org (Postfix)
	id 1DCBC6B080B; Tue, 24 Nov 2026 12:38:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4736B080D; Tue, 24 Nov 2026 12:38:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAE76B080E; Tue, 24 Nov 2026 12:38:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA4026B080B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:38:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06FBD14055F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:38:06 +0000 (UTC)
X-FDA: 85470720972.02.82889D1
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E3F2120006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:38:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mAW0sb8c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795541884;
	b=OwHrf7BnyKLlmYOvCdt+9LQsowd8ZUlaOcMejnNwjqs+5D47UmM+XZDOe0OLeifUFEcCbB
	56jHMWto8TMDCQsUZnrJWFp4fqq39lNd/HT5vCtStt9UqSzmUB7e9E8x+bYqx0Of1XCy+y
	bpB8qzjluFRgla+CNyKQ/562oUWt348=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27zYXXgABty8CUqGukpLM4c2xVBftF9tF/4zdE571W4=;
	b=JQO+6s2yiIOX8DMg5gI/sv48DREjLhzJZOzp5S4EFOnpvbSmRYwLc5wdxChbT7THT/NXR6
	c5h7NR4XIE21v3iSaouHLzXE/t+LO//+ocEElCiI2lDdign1nKwW2BAar9rh5NXB5Q2qoG
	v8NJ5KQ0OJzImjGKCAIAuv8sCa0jlCU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mAW0sb8c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c50aaad19fbso534918466b.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:38:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795541883; cv=none;
        d=google.com; s=arc-20260327;
        b=EvBkCX846eQTxktfH4AZzH+h3SgPQWZuY94F3JHjfFI+vPx+hit6ZAuRtZzvWsIJ+F
         xPsoFBB/VDCS7R21ywDcPSFfEcta+DmBid8ggb1yeMWfUJSLgBcA3e5rTjzsdBxL4G7X
         vcy16aFJRk/d7FRoQxrhNmhvIRySH08z1wK/mBCy0zfLYlCreuGu0l1KIdy5DaNaWbec
         wAwhrYtldyGjBxeBng9XGmRCOQqaywgyc2vOA9CN/mHliOXzn404tpqPVxkr1ra0yueX
         i4XRGQNuJy+qp5buSjCBIOvBtndFi8R0G1YCtCDJOs4sw3vu1G+EJKXOkf+TmjX6oDor
         wexA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=27zYXXgABty8CUqGukpLM4c2xVBftF9tF/4zdE571W4=;
        fh=6fu7TTPnxVv6LUucP4M7Eg+4vY+LIeeHqmBxrMxap5Y=;
        b=XaWP/t4H4OSL2fbX49aU8AUQx6oizcSzz4QdBVPjpAzfVKKveCgdIZzA0HRAuXLuA5
         fyyPQIa9y7DbDvi2iZCxvU33kVAJ8jlKgSqhnpkF8+J6PYh04yg+9rps9CFP0U0BCM87
         47/bxKnQamT3sCW9GjL9YG5xPBgt75ATXXtWBMXAfW2MVpLhJSraOh2WqOkecyXYwMLS
         O9ab1oI2YNq3rtKsZDlxLQ2LYktWLDeMBeWDMfc3Qd/q9wXfzArAbfWYcE8ZhcGdCEEp
         u7kzxvWoKJOF3Pi6H1CjP2jx2hkQgUWkhtUHRrdGremPN/gF313vj8HZvKwQATJo7na8
         p6CQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541883; x=1796146683; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=27zYXXgABty8CUqGukpLM4c2xVBftF9tF/4zdE571W4=;
        b=mAW0sb8cTZypoTUt7YN7Bao6VcUpPN8EWcDaJFlyoK5n/LFXd8bo4D17J5iAqguhJY
         ANCaA8PbpGSCx5rMhotZqOQ/VfPFnqpBNyek2K+Moc88bhTSV1r7PEoemj2+IlkyftTr
         CCwKga5IagiMCHoeRSufr6NJDxml9Gtm2gwzuKqY48k16p9oSe/F54/muCJ4NfY3YWOG
         afwNhYor+5xUJaryiN8tkA6Nw0e3bQCJI3X2HKr2k38sg7BLLpU/VqZ9GooEMtPy0CcG
         miXAe8KydmDiPorb1wcCELtjN3j8Wuqd2LqTBKycS3W9F2JxhYvXFXjRmth6k1RER2VP
         dnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541883; x=1796146683;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=27zYXXgABty8CUqGukpLM4c2xVBftF9tF/4zdE571W4=;
        b=uMMlawfdO1Rjf8nIdgArIeXoTWktAaSoKi1mw2JWkiqtIb0snmQNk0JzuwKql66g+2
         IfmHRnkv9Lqq7dwM3tYn+TofpNmElyUHaZkvjOv52uQdqDaLHwDtOSTzK6EpabvBrN47
         pDC/G65My+uQoysLeISmwfSt8Te/+XNANrir+D843kh460dZsp75GnwidGfVCxmZoI1g
         icXM506648xcNRYmjbdgwLOBXY7KNsTLEM5J6CuHbzIug52bd4CeVZQ5aOOYbXOYU3KT
         c1f9Rlnd9ROtJGFsDOAldJoFgnJQIb1RfRBB/EyetIl0n+1s6NFXPXhLAUWM/EcZNRX7
         V7Tw==
X-Forwarded-Encrypted: i=1; AL+hErEX4nWbft3VK6BWo+nTzSGNxZRrimsWoRnPpdBcKSuMhpquHjjlcRBSOiJIv8cAjuW2QSKXhF0FWQ==@kvack.org
X-Gm-Message-State: APuU4Z8QD2eQlWMUvm/HGuM0ieSwGICgSnzTxzgVGs0/YRVv/eXPKnm9
	yaP7JF6CbNODtbwNaCSIK8sB557kMRh832GwlDFr1INNgzNSblEZio/0TIC7L/AxgHcpfuZhU+G
	FSjvTEqchZMistc7qB6UKM7MSmUKTnCLlLqsMrACe
X-Gm-Gg: AZFdTZcRYkZLep+WBPYynCYZM+C+Dm7wRzHeTQUg1e6ILii2cT6T2SyuoePB40k8q2U
	GKiXEnEYbgAg5vH1jtA2QyBhefol0GGrGif2Z6ulse+I3gbr6gw3U+c73nqDZEfd/E//cuLfJAe
	v6Q1YoIROCgWqe1hny4AjRlV91yFkWCv6ms+nKMIPnz79/seIegX9vYv9Z92J4H1kSIUzSv5thj
	emY9nfPfnX7OpnA0xKz0+h5Y3oHFqfAFcIb6D8l06aSAEZsoVgk+3RgfhXwAuJhLqgcpqy1BCkM
	kF6okc6h3EYOl+VjgC0F2dDgbSueUsXeTG0Js1I/yauqvyabXd+qK4sak4gnzv5Et6HQqBMSope
	pt19HA9ekE3+i2ti9+H2+3XMlHhzqFSsTcoXP6iWsUoSRy24mydn2DsWqlZrShfTDD37bEGktY3
	i8fTlyWf01FXu6D+6mQE9V+q/Yhb+dK1hl1yB/fvVH3BaFVOLiAd+YtOQ9pVp6CEeodbxsULxu
X-Received: by 2002:a17:906:1b45:b0:c4c:f85f:aa2b with SMTP id
 a640c23a62f3a-c513a817fc7mr933423266b.24.1795541882037; Tue, 24 Nov 2026
 09:38:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-15-jthoughton@google.com> <sashiko-outbox-228643@kernel.org>
In-Reply-To: <sashiko-outbox-228643@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 12:37:25 -0500
X-Gm-Features: Aa3M54pJqG_uJJ6nSsmIk2hsh8SZo2wXqFjyOnO5jM3lVaei5N6Moc8ra8UgiVo
Message-ID: <CADrL8HUHT5aSwXHg2z4hFqn7gaKNFavKOzKW974T84BapHXYUg@mail.gmail.com>
Subject: Re: [PATCH v3 14/19] selftests/mm: Add HugeTLB vmemmap optimization
 stress test
To: sashiko-reviews@lists.linux.dev
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0E3F2120006
X-Stat-Signature: kz8mtfyk4pm17yej6acn3i71buieoqab
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795541883-202096
X-HE-Meta: U2FsdGVkX1/vDhhJejFQK85gqPO5yK3P8oYUzXe8+cofFm8F62OENqKLZf+TIPxEW/Zr9Ai5fYw6olzukGGfEcDFBvCNqjg86KorwEyfuuZU91dmOkrhHc3g+haN2AXCPcUvz9YI6fDwCz2NtQ/F11aTYlZo+qArckBIKZax2VtM09nqAh4sixTlNLZPik8SDHrpNB+N5FOJAgEDf/6naR9/e6zXWavmnc4RWRtXPO2/llwqbLtiwJCbQmKjdUSIku8jkIorz33FbUAbmVQnVLQD0p1NCXhNYBV0qRvPfszjJ+zvvrwd94rmUnaDWaptJm7fWqM8huQTMl7PHfcwSIPA1BJMnJhwlBOt7UwiWeuxCQ5bEmLbAvbSq10CVdhjuHt8pWMYx4n0iEDPQoUAILv1EPzV3lHL0pH/JfwwkRU/f7ZlDcpa+hd1WaTnYt7CSRJ7j6F9+Ezy9qjRQqWj/OPfgnrtOBFYw+VQohqAKcQesJDevtwG/rH0I9JfBBLrh+NvRJ3RbZAecPD/WaGPe7sHKXD3CBbeQdroUciH2dt3mfmuJ6fWlR3mFRwfXbRTrOtBgsxFVGVrNgWucnbssEYnEdwceJJunwpOJMlkEqhnwQBzJ56YIaPLK9b3WE9R9kkkQDknGqQZjFX/+lBMAKcbVTSkp1Nwm5kKKkTIq4HwpiJdPjg0ELY2doIp8JImT9ddGFnRj45Nnjp5R4D8sm8Pfc/02/Wt6qM4hXPTYjQpuZm1i+edwtLMZyEr79VR83aeClJTkrmm7UFaaXTnjC5vHj3Sgex6/OdHa4cAk7Dc5R0Sir8tWN9Pf9tKhVe3OZoQnIZyHFu1kIk9s25Av/eBYCSF3rL5gQ43cCbucTm0WmAqR4AnT86a1NR3iPAncnH8IMZgeqI1psxVGg8HNogFuov8QDMgFueetQl+RZysXKK04319vdeEifGqZu05t6BBiLGjx4SuOo4gJqh
 rk6Nr1iS
 bzG0eqEzrvwcNlmhLy8bvdMirZxpSP7W5oLfXfeU0DcSjTrQeQyBln0l0wKsFOnGMqeMe13WyFbkDfQCOxapBniobPbcodevu0opwjWNiaAdMrOd0Qf00nE+KzwFsH7SNRmoyYn5uIYdnp8Mtn68jWOAMhCfAmWbVi1lmuT3sDs76Ayq5c18r7yuZJOzA5qvtUGhV3h9gNK3HLFknACkqmTYg5LQhCp5tpFgvArHWAnHrWJyF19B3MRUkNSDvT8EWj9zYStBmgwdfP/fCL5e7oaZGvHFn9qRiEVjq84MapPzxN7xobIcHaaPter+xqugPHMIiYQTySQ3acymqLdpSb5l7hqNHHdYm2EPwOSZbTy/SRiinAOxP0rztRrbMjAdbAF6Ix0eysDN4yanCG8ndyiSyz6EaSmpK51dM7w7h0VPJibDAPcYhQe7aMZIV3TvfU/ZNVm3PVSSw+A3uh6nIFkRW4QGzyV65n653BAr77Sxac6nlXRh9FG53xBrwD/QFu3/XhqHYDeOwHPtKKiJpdUh7e3mtv3HEzxtaRkQolvPqe3Jk5WP9+ZvagkvqN+/GGg6n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] selftests/mm: offlined memory blocks not re-onlined in
>   stress_phase()
> - [Low] selftests/mm: unchecked mktemp failure in
>   hugetlb_vmemmap_stress.sh
> --
>
> commit 15090370906fbd4c082668bfc18a1ce3c873bcb2
> Author: James Houghton <jthoughton@google.com>
>
> selftests/mm: Add HugeTLB vmemmap optimization stress test
>
> This commit adds a kselftest script that stresses HugeTLB vmemmap
> optimization (HVO) across accounting, concurrent access, and fault-inject=
ion
> phases.
>
> > diff --git a/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh b/too=
ls/testing/selftests/mm/hugetlb_vmemmap_stress.sh
> > new file mode 100755
> > index 0000000000000..b64fdb3ed7614
> > --- /dev/null
> > +++ b/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
> [ ... ]
> > +orig_nr=3D$(cat "$hp_dir/nr_hugepages")
> > +target_nr=3D$(( orig_nr + nr ))
> > +marker=3D"hvo-stress-$$-$(date +%s)"
> > +tmpdir=3D$(mktemp -d)
> > +pids=3D()
>
> [Severity: Low]
> What happens if mktemp -d fails here?  Because only set -u is active,
> tmpdir becomes empty and hotplugger() appends to /hotplug in the root
> directory (which cleanup() does not remove).

I will fail the test if mktemp -d fails, thanks!

> [ ... ]
>
> > +hotplugger() {
> > +     local blk state removable
> > +
> > +     while :; do
> > +             for blk in /sys/devices/system/memory/memory*; do
> > +                     state=3D$(cat "$blk/state" 2>/dev/null)
> > +                     removable=3D$(cat "$blk/removable" 2>/dev/null ||=
 echo 1)
> > +                     [ "$state" =3D online ] || continue
> > +                     [ "$removable" =3D 1 ] || continue
> > +                     echo "$blk" >> "$tmpdir/hotplug"
> > +                     # A signal aborts a pending offline_pages(). Use
> > +                     # --foreground so that the writer stays in the wo=
rker's
> > +                     # process group and is killed by stop_workers().
> > +                     timeout --foreground 10 \
> > +                             sh -c "echo offline > $blk/state" 2>/dev/=
null
> > +                     echo online > "$blk/state" 2>/dev/null
> > +                     sleep 1
> > +             done
> > +     done
> > +}
> [ ... ]
> > +cleanup() {
> > +     local blk t
> > +
> > +     stop_workers
> > +     for t in fail_hugetlb_vmemmap_pte; do
> > +             [ -d "$(fa_dir $t)" ] && fa_disable $t > /dev/null
> > +     done
> > +     if [ -f "$tmpdir/hotplug" ]; then
> > +             sort -u "$tmpdir/hotplug" | while read -r blk; do
> > +                     [ "$(cat "$blk/state")" =3D online ] ||
> > +                             echo online > "$blk/state" 2>/dev/null
> > +             done
> > +     fi
> > +     # drain() also frees free surplus pages left by failed restores.
> > +     drain > /dev/null
> > +     rm -rf "$tmpdir"
> > +}
> > +trap cleanup EXIT
> > +trap 'exit $KSFT_FAIL' INT TERM
> > +
> > +# Run a stress phase. $1: name, $2: fault attr to enable ("" for none)=
.
> > +stress_phase() {
> > +     local name=3D$1 fa=3D$2 base after injected
> > +
> > +     if [ -n "$fa" ] && [ ! -d "$(fa_dir "$fa")" ]; then
> > +             echo "SKIP: $name (no $(fa_dir "$fa"))"
> > +             return
> > +     fi
> > +
> > +     log "phase $name: ${duration}s"
> > +     base=3D$(memmap_total)
> > +     [ -n "$fa" ] && fa_enable "$fa"
> > +     start_workers
> > +     sleep "$duration"
> > +     stop_workers
> > +     if [ -n "$fa" ]; then
> > +             injected=3D$(fa_disable "$fa")
> > +             log "$name: injected $injected failures"
> > +             [ "$injected" -gt 0 ] ||
> > +                     log "WARNING: $name: no failures injected"
> > +     fi
> > +
> > +     drain || return
> > +     after=3D$(memmap_total)
> > +     if [ "$after" -ne "$base" ]; then
> > +             fail "$name: memmap pages $after after drain, expected $b=
ase"
> > +     else
> > +             pass "$name"
> > +     fi
> > +}
>
> [Severity: Medium]
> Should memory blocks recorded in $tmpdir/hotplug be re-onlined at the end
> of each stress_phase() (or in stop_workers()) rather than only in
> cleanup() on script exit?
>
> If SIGTERM from stop_workers() terminates hotplugger() after offlining a
> block and before "echo online > $blk/state" runs, that block stays offlin=
e
> during drain(), the post-phase memmap_total() check, and any subsequent
> phase.  When page_ext is active (such as with -o and -m together),
> offlining a block frees its section page_ext table and decrements
> nr_memmap_pages until the block is re-onlined:
>
> mm/page_ext.c:free_page_ext() {
>     ...
>         table_size =3D page_ext_size * PAGES_PER_SECTION;
>         memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
>     ...
> }
>
> As a result, stress_phase() reads a lower memmap_total() than base and
> reports a false accounting failure.

I will re-online the memory blocks after stop_workers() in each phase in v4=
.

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.26=
68189-1-jthoughton@google.com?part=3D14

