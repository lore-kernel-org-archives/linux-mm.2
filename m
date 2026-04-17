Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 750C2F43680
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88AED6B00B4; Fri, 17 Apr 2026 05:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83BAC6B00B5; Fri, 17 Apr 2026 05:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729EC6B00B6; Fri, 17 Apr 2026 05:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 614A56B00B4
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:05:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11B691B9166
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:05:51 +0000 (UTC)
X-FDA: 84667465302.02.4A96377
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C2DB2000A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:05:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lAm/Is4y";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776416749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6h+hUT8JrfeVoyladjL7W9cfNjf2SDBTuYVEHwKaoo=;
	b=vuy1qtvYmQ0NwjPgyaqcFSjJzF/2fMaiwfsOhHO0s+GRGpCghwZnjV8mc3zF4TSbrn0DRS
	lsQ1OCQKtAYpzfI45NzmLn4GiTNbanrogJga+9vD8alqbonXID7AfgrrqDfzRgwBwKCi64
	Sp3N17M3G4vSfJ5t8QdurPYnVFn2Wos=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lAm/Is4y";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776416749; a=rsa-sha256;
	cv=pass;
	b=nZvSozwsQCp1HqJEJCfXqOJ5SHVEJFfyGE+8OrHLUVPDhpDidxaqkniCWd4Pzdn6FI0gHk
	3j7jooCDRtJoht1OseRnsHcBtczwMuq2bXwkF4VQWkSvfRv56DAcdwfSOTk4x98FpQW2dK
	uizyZzn6nSILb12StBkuWa1vCfFddcQ=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12c637089ccso1086473c88.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776416748; cv=none;
        d=google.com; s=arc-20240605;
        b=W2XKPnBFMXgZ/Ih2nnuNKNfoX8IewxtLN00BVdA0/i6p+AXHQN7GSel6V5t0EL3XQP
         FnhF2XsIL6DHX8wPt9809M+tebKTkLWfPjHidA2s+0fOR1FiRrBrKJ8D9YNnn04DaNCG
         NxkG5Ll6C5+6OggK5onTyGX/SiDIHmy/8D2/yRseyWPQVaMZopc/QCw82mC1VngcIn5I
         QmsFqcbJwJBS11cbfalopGyVAeDamLNjL1VQzsmPr7Lj5/9lEvudtVTWwu444Porwrto
         JKxp/TbuIC0wC53epbNem5Diz+vcZo8/OUXz9hXgL5GRtF5AG4hWuJh0hd2UAyBAfUAg
         vj8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=m6h+hUT8JrfeVoyladjL7W9cfNjf2SDBTuYVEHwKaoo=;
        fh=7rLTMS8wbmxdNMX5tx1kxOOdXP5cMyIZ8i8KzybgfgQ=;
        b=L/qyNBy1kSUUPoPyjehxO83OxWsDmuh/Yo7dHj5s0AQyAhxuBOie1LsLbZxjrMFssQ
         CcQFrTj6or/vWwdwEK1lC/FYWYHlb/ogwEcVABhaQG3H/lyrskYKZAxfOBtM3dWhhuC6
         YOnss1pMfLjdu4wmho70gpTyaxEl7ZwncYREkUd2El7+rQuF8OXyV/+/M6P3CpOnWqSt
         +2IFsE1gDa6mGJcZi7r2s2hCUM5u9Q+rks2H7beRhaIcP7l+E1hFWQCRs8s5sdE6wh2u
         /nDkMlmOQQ2C1iqm8CafVzZuQ9DKSsy815YTKlK3y4MEyu5EPSWzgriHQ8VuTkqc4lTp
         Uu8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776416748; x=1777021548; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m6h+hUT8JrfeVoyladjL7W9cfNjf2SDBTuYVEHwKaoo=;
        b=lAm/Is4yZ+YoJfoPeWnKYrD9ifWncFNsXPY/ahigh7I5nmlFngzj02almAqWJCK+l+
         I231uKI/Xn5CXxQcuDfeAZ1A/dyzjYmT6FFPjJKsvk4qWJUKPKEmha8kSKFnON6+uQ9B
         PBdd+pzmePutVpPZjbZVSyc8qFIEqN3vYB8SQ24L3YGqmamdGuv2IcGyHmoiu0H4LsaY
         KUGHNXU6pl82a2OKTuNDrtdR02Yn+4TloRdroNLb9aDcFMvGAweu/SpstP+37wVBZBq4
         /EESEex/RrSj9KNxd1l60RFJgmF0A3HkwNfwlWQs2MaRwzxtqKnD9dt9xY6XxQo5xrdG
         zrHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776416748; x=1777021548;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6h+hUT8JrfeVoyladjL7W9cfNjf2SDBTuYVEHwKaoo=;
        b=DI87peCFE2ydEsOpG+JF3scRQ+LrBUhuvCbHq092+oAZgvPcM5gHFarxnOtIyYpKq2
         7LhZxx++AufQl+ZRnDdibCR1nbPVHsa/rDyiSlDqAOObMam+spz41g4Wu/uMXdGDpGBW
         eVKGKsgGw/i6z9EYPB3knuMDxtaQnrsVkavF3/Yghav63zTr9OdDrvA+N45grR1+veK/
         QIaMJOn0LRmdYJ9jWfeS4pde2qgq/I8SvCGnYvtDMD2JHcKf3h14QMP7tPfPV8j92o/1
         LlfZq6/PGrfU37Iohd1Rm5XX14TEOZL7ZRfUDVTxdMuWmKRhRwG1LPHcABGw/OJMMbjI
         pnTw==
X-Forwarded-Encrypted: i=1; AFNElJ/ONqw+0zC+JAi4gzxQ+A6cC+oYnk3rNt7vFRprM24SPYNqqTpWlNrenGOg44ulZLUJcPRxD9oonw==@kvack.org
X-Gm-Message-State: AOJu0YwtIKU6BdLxodgN5c4kqGXMnownhVEMV5uleWtmBzdVP8NEAOtj
	A8mma/WgaKvdA8+pN9EGF68gA+zExfMgunCMqIGPsGcQBzHXT+q9ILQk5jX5yUrs6ow4Ofj/Jxe
	JpGBXd6Rce/lQ1X+tUmEO9+EyfuxkwVVXm9tOJdS5
X-Gm-Gg: AeBDietsSMyiKb+EZrcr91gPlMRxRIIlRF9YfQDX+7lnorLKOortGwkHRautvsaXc0k
	MnKz9OM3ihMc+hT74ud5r3I1Oo50eDrbJNPA8JgQp+Vm/5ESWKlGbaSCtg4XgoApLPB2nT40ySJ
	ut0oGkufcaGyrUCZhi9TKVXBzSQjGJqKERfpUlRygU144yymVaXZA6p6IYTOVr2hn36lniwslLS
	MbP9vadONsAf6GKvap4xKfYb2oVYYILUeHe07CEimTNcw0n5PLl7AWdEM6jm5m9R8swjp7iycTQ
	BGczHiU9zRGTn9LXJfBAxQwcWdHhZd+x4qNw8wDo+iBplAlk3kjWLCCv17NB3ne+d4dRWQ==
X-Received: by 2002:a05:7022:6085:b0:128:bac0:2edf with SMTP id
 a92af1059eb24-12c73fb6c49mr915659c88.34.1776416747190; Fri, 17 Apr 2026
 02:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260416132837.3787694-1-elver@google.com> <aeG6RG41sgZuerYa@hyeyoo>
In-Reply-To: <aeG6RG41sgZuerYa@hyeyoo>
From: Marco Elver <elver@google.com>
Date: Fri, 17 Apr 2026 11:05:09 +0200
X-Gm-Features: AQROBzBPHFPjIQbZYgiVCtPkYdTt_jdnGikf9TMYOKgcXpS_D48owm4g6Ox5x3k
Message-ID: <CANpmjNPMxDkzvVnD9pXy1YBTO4n-abQZ+if6XdDj-u4dnfks5A@mail.gmail.com>
Subject: Re: [PATCH] slub: fix data loss and overflow in krealloc()
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, stable@vger.kernel.org, 
	Vitaly Wool <vitaly.wool@konsulko.se>, Uladzislau Rezki <urezki@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1C2DB2000A
X-Stat-Signature: sobek6mei7ge88xpiu8wecdwxxd8f3f9
X-Rspam-User: 
X-HE-Tag: 1776416748-977400
X-HE-Meta: U2FsdGVkX19Fsti4vEetkg/Qm8WDaSwTeZrOXqlwYZzrgfS4CLj+uLH3MfivuCa34TWehk04FSDbiz15DCXhYeW6MVzafJ2QHfvecMwyf4ctP3Qc6Yl3OgdFLT5lHJOVeyt/VsZ8KdNV25jPcfCr62qDmVtzPdryo7BD4ndjpGPW1wAZBvofyxjsDzr//QfZiULoCog/cSBUbr+CrketqZm8Jn4ibNiWJb56cz1uk2VWNI9WbVWr3xYbARG8/znGWLSG3wDjFd0gkqN0JgOnt3ehv+9zFjeaBTzAZI4q/RjKZJbv0+Qm4XIsOUk5SWXSJw5jS2BX9N+d+mmyGnYDGQ+gXR9QyxO3kUdbqGS8qA3p4nIYXKkyaWaKlBTbOkmrYE0laahj87SCg5WN9IknY8AVUwzdX7Epe03Mzbvb2tbQw/812YzYBtrl+iKfppY9iJ5jpzQvkHYEkzhS1EqpnTICs1R9YcQFCHqduV4N5kIew3WGh3i96pgrjzG9HSfgBXZyIL314mhPE6gubb8uwVq0X2p3ni6HVbkyAM8u6sOWw/hgGFP4x+gk+rTmXsAnekA1OnUJ6PyyuHSiCjRzNFYOwaPQmiFlau/IZI6aBKS70zRKLSXPVnhggyYWzQ7fxK8lUPjm0r2BlRhVJWkQqEuL5BYUC7RI9RkHui2AT46RW266BCzt86x648nsIKGWcF+2EWTrJixDFmqXmU41+MmVh3qr83UavmbKWN2XfKFgR25UYYjSBV6Oqk2U7n31lzVaYpdM4DyTu4BbXALctz6cpAJ3FAfRCFqiC2Rp0KG0xjLtLvFp4noPMyY94vPjXfTrb4F1puEugYIMLu2j7J6RtOXb8giXsUBeauYZaxELtnXr6ORZhPnSilaMFWCGMf48WDfR4Q73fnx7RCtoqVsshh1yonXXzIYlubwcvk8IF7QHACo6up0qJHMtz6UJ0RnTA89x9xBQCk5J7QZ
 4N9PtPwS
 OQABcuN65FBmnORFBRAiNuRslW/mF4COIabPV4vVEPEI27N9v3wLu6G5OgRtLiGCLaCHXtmE4RF/4OVgUD9hOLwiqq/f2c+ED8X46PBd3We9M5z3ANxlp9jZ9TYePSmYFgp1jHXG5O1/Hfz4WFo56wvmDiNwj82nQuw4UM93Eye7KKkyjQPORrmaETyhJp9/FCtAct1KeYiiIMaXARppnB0hO/EClo7XTGdeUko5JbGV9kZsA8/F2s3y7YQSUy42gXYjRBNndXdzhUbWxcXPyW0IJZDlu8nf/D89Z50q+QzAb7ZlbiWXNzw5dkB6vPezMAXLX4ilVA93/bq8RcLczELuNrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Apr 2026 at 06:42, Harry Yoo (Oracle) <harry@kernel.org> wrote:
>
> [+Cc relevant folks]
>
> On Thu, Apr 16, 2026 at 03:25:07PM +0200, Marco Elver wrote:
> > Commit 2cd8231796b5 ("mm/slub: allow to set node and align in
> > k[v]realloc") introduced the ability to force a reallocation if the
> > original object does not satisfy new alignment or NUMA node, even when
> > the object is being shrunk.
> >
> > This introduced two bugs in the reallocation fallback path:
> >
> > 1. Data loss during NUMA migration: The jump to 'alloc_new' happens
> >    before 'ks' and 'orig_size' are initialized. As a result, the
> >    memcpy() in the 'alloc_new' block would copy 0 bytes into the new
> >    allocation.
>
> Ouch.
>
> > 2. Buffer overflow during shrinking: When shrinking an object while
> >    forcing a new alignment, 'new_size' is smaller than the old size.
> >    However, the memcpy() used the old size ('orig_size ?: ks'), leading
> >    to an out-of-bounds write.
>
> Right. before the commit we didn't reallocate when the size is smaller.
>
> > The same overflow bug exists in the kvrealloc() fallback path, where the
> > old bucket size ksize(p) is copied into the new buffer without being
> > bounded by the new size.
> >
> > A simple reproducer:
> >
> >       // e.g. add to lkdtm as KREALLOC_SHRINK_OVERFLOW
> >       while (1) {
> >               void *p = kmalloc(128, GFP_KERNEL);
> >               p = krealloc_node_align(p, 64, 256, GFP_KERNEL, NUMA_NO_NODE);
> >               kfree(p);
> >       }
> >
> > demonstrates the issue:
> >
> >   ==================================================================
> >   BUG: KFENCE: out-of-bounds write in memcpy_orig+0x68/0x130
> >
> >   Out-of-bounds write at 0xffff8883ad757038 (120B right of kfence-#47):
> >    memcpy_orig+0x68/0x130
> >    krealloc_node_align_noprof+0x1c8/0x340
> >    lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
> >    lkdtm_do_action+0x3a/0x60 [lkdtm]
> >    ...
> >
> >   kfence-#47: 0xffff8883ad756fc0-0xffff8883ad756fff, size=64, cache=kmalloc-64
> >
> >   allocated by task 316 on cpu 7 at 97.680481s (0.021813s ago):
> >    krealloc_node_align_noprof+0x19c/0x340
> >    lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
> >    lkdtm_do_action+0x3a/0x60 [lkdtm]
> >    ...
> >   ==================================================================
> >
> > Fix it by moving the old size calculation to the top of __do_krealloc()
> > and bounding all copy lengths by the new allocation size.
> >
> > Fixes: 2cd8231796b5 ("mm/slub: allow to set node and align in k[v]realloc")
> > Cc: <stable@vger.kernel.org>
> > Reported-by: https://sashiko.dev/#/patchset/20260415143735.2974230-1-elver%40google.com
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
>
> Looks good to me, but I think we still have a similar issue in
> vrealloc_node_align_noprof()? (goto need_realloc; due to NUMA mismatch
> but the new size is smaller)

Good find.
That's a separate patch, though, since it's in the vmalloc subsystem
(it's also not confidence-inspiring that vrealloc_node_align_noprof
has a bunch of TODOs sprinkled all over...).
Since you found that, do you want to claim it?

Also by the looks of it slub and vmalloc patches go through different
trees these days per MAINTAINERS.

Thanks,
-- Marco

