Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C824606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0zcAFfgA
Received: by kanga.kvack.org (Postfix)
	id 76C556B05B5; Tue, 17 Nov 2026 17:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D316B05B6; Tue, 17 Nov 2026 17:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7E36B05B7; Tue, 17 Nov 2026 17:57:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30A2B6B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:57:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACBDDA81CE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:57:43 +0000 (UTC)
X-FDA: 85446124806.29.653B78E
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3D85C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:57:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0zcAFfgA;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794956261;
	b=ns4w+a+uvA1eRyp3+7xUU0RImcLs44ogvXv/Gej8YbGL6uPNi7Rz9VUFItN98Kq8zE6dT5
	sj3Hzz2bt4uGiFHckJXsbujLewaIonRfYRaDJodt571HiPYlWjGD/MDuAHpL7zl4Jbk7Qx
	CBvPQO4PEx9h9uieg8wLGjck/52Up+w=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794956261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FsqJbwkV/uU/DSRZoNtapIdLtn+SA2yH6t5SZIf1Yv4=;
	b=DIjq3yakos770foQxm3zow70LMnuQzjshO49WLezURwnBFqjemav31n9zCMbmgoU9hSLuq
	IPbONLzOqxwLzr7+ohScC9FUiulH8iTrEYdMeIqFgIs6S1JgAFChzhnk4cmlCb3s1KOsUD
	zRB96eWDBHti2Me+UVpxQZsRLB3adkI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0zcAFfgA;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-49a92144733so127101f8f.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:57:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794956260; cv=none;
        d=google.com; s=arc-20260327;
        b=Zziz/l379cRnsWqQ6NC5wilbJL2vaVxQ2ZX/+9ctMOLSrv16sZdZuap28c88pyApaZ
         e76YmuyMHeeruOltM/qfF2aXA40bXKCPskJDF5dlDB2a+f740fi2+oX/5uB9yP5efzdp
         AsboENT1hUwiDnY+STXzSVbdz6yuj26Hrk9VQZTu7n9WqsCqw0MhdKBwP+jSZx1ep3G8
         HO5heu2bAW3Pk4MZGVt16QNLWDYN8Bfcw+PbxEJDMdZSquNld7Y93P8AZW5L6obXDLtH
         wSg+iTadHZjgepLhttiifAEFvS+h1u5kMl/4hGFi7Ze28snfZYQssylasDaEx6Jmrg1o
         eTAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FsqJbwkV/uU/DSRZoNtapIdLtn+SA2yH6t5SZIf1Yv4=;
        fh=l9UWqLnnpFNE8J7zv+bmA3OPAUvY4olRaU3vwmy6P3U=;
        b=P1WRnD9XQE0N+CZLQjHW7hg0iAifq1tkKK0E2Y+UaK0w6e4ebXi8wAuyuGcaaF0Qtp
         EL+OWmdUTK5D0QXGz1vpA30PWe7aDkYeq8FvtecQryY9H7FML+Ga5zpYTe9osUJAVA3x
         zYsEpPkazC34zCkRpJx4JioRjB3FFIoxONhdPsPDYgtUTnhcn5leNm1giy7p5nNxxs78
         urFB5MO/3JztKiqEKPARtdBx8X42nCdg9M8ue++qf7ghPVwDsP0bLca/j+/BzVbiMhna
         9ETn+FFbMd6mQUjDFkz9HSUdIYqxFtvr6ltW9IVajnUwB5hUQhUzrCbMqn3srTchqVrS
         g3kw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794956260; x=1795561060; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FsqJbwkV/uU/DSRZoNtapIdLtn+SA2yH6t5SZIf1Yv4=;
        b=0zcAFfgAs9kyxV4v+BGG4MUxbsrzV2tB9or2vXnNCeSNyiDMrxxJdrlA1sP3XWgGMj
         EEaJ0CtzUkTAE6dlpFcTJW+p6JYEfpIr+i6UBOHnKRE6nEQF1mvQVCZ1+abZmZkiKMCU
         7B17EhYFxviVrXp9bH86cNixyPpGPk+2yXDmsXTPkhCXLGN8SUcPMbrY5ov5A2XWS62y
         o/mXy6ZdpiO9eTVU2NnE79OIFX9MiAO9AnfFx802aIglUxu2R4YofofOIS0H9DcCtE9w
         hBjd0JdfVPg9dMIHGM3Na2UtWWCAH4yLRfm3nfkWJOh1A1YPBvGDLrSstIwqtTjAMA5f
         9Z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794956260; x=1795561060;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FsqJbwkV/uU/DSRZoNtapIdLtn+SA2yH6t5SZIf1Yv4=;
        b=lZjccU+9myWLRQGVoIsFyUWPfm3JAWroqb9mPg9XSAHUh7muiK4OrMHQfEW85+MD+F
         rHEFx3iSFSEg1ZP+luW0yrLDMRZmRdya/3S2lQR3QgSA2OR3X+nJqWWSgKXzOJqHXzIv
         tXrwLknl4Jcz801KZWF/P2Y4FlgdX8OzQ9lJTC756znWH4BPvH4mYh27IptW1FdH+0Lu
         ECWoI6kUEHJaxh6ptKMWQT2rx/g5me0wpyqUR8jAN7C4C6/95cWK3cI0JV5AXNaiK+NV
         DC3XNQCBp9K3rHERAyx1DtShquX3CxtzWYpwag+s+ip+2zr7XCD7EzQHfY3wrGfF1OJx
         zsow==
X-Gm-Message-State: APuU4Z8EKOx+zvTNlW78sKkY738YYHCZXs9L3uux7FzNaH9zADsT0Mni
	NIdfoKQJ563DcZFj0XknEyjj3uuQcnKFXslgkb3JMKZisY+tS8zLF2HOvhQkq2ASGdaSAOa2X3M
	KUY06n4NUKrPzlLnI0r10nHDUC0SiXSo=
X-Gm-Gg: AYBFou0ioouEyVM0OTZrIdQNQYv8IIfSXyGISp9E9o0n7ie2DoyYCY2hhs1PXFLIBSK
	nPI3n8koYN24ELOo750FTaFcw2kQby/BtDjnlmmuf+v57QHc9UxDdV97Z9anP065F0ghca6TB92
	XdkjXHIz2Zy1hG/ikjYm5spLhI55EhEZagS7B4C0lLPuPBAi15pTavpGerD2BHJEqegjJc6kgT8
	VGiDY7j8Fd+iwpvFcvxLZpwH6aOrn1AHOiwYc0gFgSt1xT/4Lkiu6ordS/fHMQJfK+PUtmiNtAu
	OHzmvxTL6hpJs5O+g0iMCA3FbVcrM28Si3GDHasvViv9LGxXIPU3Hs12kvYei5i05MQjX+Okrrz
	hGzSmjxr8bN4wyXo2VYNQJ7jvU6xgEpgJCYiWHtCaTxaTpgD4dXTkQGMujhk/KR+F3jAWO2st0l
	A10sHKFMJMd9SI2X7BR9oHGYWtv7Yzz2sk2xxnvJqm1brbGiMEl2eLSgMZQ+qseqCDx7KMxg==
X-Received: by 2002:a05:600c:1d06:b0:4bb:6a5a:783d with SMTP id
 5b1f17b1804b1-4bb7da25158mr12547015e9.18.1794956260090; Tue, 17 Nov 2026
 14:57:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=M64ZmMLBRiAQ6FiiP8f=jkA4m=HM8rgQo-cir2SENPnw@mail.gmail.com>
 <20261117161028.475891-1-nakixii@gmail.com>
In-Reply-To: <20261117161028.475891-1-nakixii@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 17 Nov 2026 14:57:28 -0800
X-Gm-Features: Aa3M54rLZoi7B6oMnsab_DhD6F5mz6P2afScumNTEptyJQeY10XdZ8aO4kmMqJY
Message-ID: <CAKEwX=O3qkG0pt3qVsRTDDfP9sC2AuG2c-t3Xaudquw0xKwa4g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
To: nakixii <nakixii@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Yosry Ahmed <yosry@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C3D85C0008
X-Rspam-User:
X-Stat-Signature: uz8xa1njx3yshx8qybo7zmpgayaxbzd7
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794956261-291740
X-HE-Meta: U2FsdGVkX1+3RlxTSzZ9E8MqQrkC7VZ/C2NhZds/ziL8/J3znfyJ8861BkSyc9tXXiCm+X/z6C7KSlOrlaj07PjhH8mdyZsI7O0/NuDxjYPAGb1bnp8KyJPhfdcTQfBPWMMa4TqBHq3lgWhtPdeuyWRuDDf7ccLiXu2/YuqD9+72pZtPRNYzzEN0T+9BZdjqut/xs98pF5VhP6fstRzLUnCqgnkMWm3QCSdw+P1OYJZ4JFhHC4TS8f28q1xqJduCWz/iOa4RPBtiBvIYRyycJfegyL3yr7C01yFH/FnQ62KDKC96InYAlOT8m8o150xulBRq4v6WJR2s3HZIuqw6xF5o3iQ4HQDvh2VPKvaU5LVaHfyUTelDF1PYaB+SjBrahTDG8zElYLGz2YHCvU3kGUK1wMuWuGoyGPXxQn7Dfv93Rul54VCMX4p7WpqiUmKAkJ9vaPuX60iAX7MmLcVAowlRKVRrTfYPT/3qQcPuy5mFB95XIblcUdteZI1sfSZ4/f+77ExCdYYE6qlEj03+GGF1yAxWXsypkuerdwaXXQf2yZ/BEO53tPWjnZxlvyXp7hEh7/kEfTsc97Ci9OY37xo5KXVtxsjrix4kr3QNHpXH26hUIntFIMJeyVCUKt/UgwSfRWhdXpuKIEIiaDzqzq+ale3LqXYb8Lbp3eYxBPzzGJFlE2RzzceQLyflwoX/gbpg789P3Wh7KIygyDycmKj1V+1QSPVLGi/BHoGRChfXWLUoxxCv6xblAbV7HWKent39iJFe9PxVKgyc978sEfcnHjRlbitLkEHzd2myB4zTtoE7uJS1kICRL0U17xC5V6V5lVsX7Z0Mxx4dx0/w37Hnkgf6dyZSXKXk8hPWQ852vPp1Ok/wqA2/bt8h/pAnup95dZjLK9vS4QV+AxsW+ofvavwJdM/9VAOl2RzjDWv2+hYm7ymDUEfUuVWYRbIDXN0CpTEr+SnRpy17IMM
 IBpsxOJa
 DC5hD6SuU89+C6DWKVnEhkKKK++s7aDo+n9R3BYDoXAW4ldVQRMPcJzQ6Vi5vOLjFm1PRliS5MfuOTxSWOmRJ8aTZco0IFhiM0Lx+Q+MGwDjY91JwWb7RfNejG6R+dXRYDKLk6ankFJIk1mkH6TayVq+4h2g3YYhLdnX9dksrF6nnwUo3lA7+RYTunzxbhATRk/0KbKWoPZ+L1Fxtv1E5Y3QB3cqLTnsVLNSftAWLK4deJVwwwYOrj9a94lJT+LPoB+Qf7UxL/JIXujUxNNzqYG7XUhLE+OQClmICFkSRwkzn+IoP3b84hZ/efobELiwnjif8iYmiKvK9a0CJ2yy5CkvKjJd1TZUW/iOvJe1MnOJxXpBGHXBUixFgFpZydIYLOFTWbEZi+o5YY49EOexM4gv/Y4PPgZi9nEcMLeVXE3J+cWPcqoXnT+gV7ByfTcxHOyitipn5PvhSCTib85z+DSz9evFy/d7Irsec4HHoE1ICpEGOQYeOAdZIcL41mIx5C6slRDLmOhaEHT5pkqsywnsu30LsWFH8Xy4WBxgxHfKwe3AN0XW714Vk+Vr12FKGeAXr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 8:12=E2=80=AFAM nakixii <nakixii@gmail.com> wrote:
>
> On Mon, Nov 16, 2026 at 06:13:46AM -0800, Nhat Pham wrote:
> > What's the motivation of this line of work?
>
> It started as an attempt to get something like the Darwin memory
> compressor on Linux: keep reclaimed pages compressed in RAM, fault
> them back directly, and push cold data to disk only when needed.

Ohhh I see.

>
> Honestly, your virtual swap series already covers the core of that
> (zswap without a backing swapfile, no PTE walks when moving between
> backends), so I don't think a separate subsystem is justified.
>
> The parts I still think are worth looking at are restoring directly
> from the pool without going through the swap cache, and packing
> several compressed objects into one swap slot on writeback. Do you
> think the latter would fit as another backend type in vswap, or should
> it stay inside zswap writeback?

Ah interesting! In the future you should include the motivation in the
cover letter - either new use case your work will enable, or
performance improvements, or overhead reduction etc.

And yes, compressed writeback would be a good thing to explore! I was
thinking about compressed writeback sometimes ago, and I came up with
a slot-packing mechanism that is very similar to what you are
proposing here (IIUC). It gives you both LRU-ish ordering and good
storage density. Something along this line:

1. An in-memory staging area of "buffer(s)", where we pack slots to be
written-back (by LRU order).

2. Once the buffer is full, we can writeback the entire buffer.

3. Refault of any written-back buffer brings it back to the staging
area. We can use the same mechanism for defrag, compaction, etc.

(I'm not 100% sure how close this is to your idea - yours might be
vastly smarter. I'd need to spend time reading yours...)

But the challenge is the synchronization mechanism. Right now we rely
on the swap cache + folio lock as synchronization. We can't use that
here, as the whole point is we want to avoid decompression. We'd have
to add a backend lock *somewhere*.

Ideally I want this to be decoupled from zswap, i.e as a vswap
backend) We'd have to re-introduce a bit lock (almost similar to
SWAP_HAS_CACHE) - I don't know if it's ideal (Kairui, what do you
think?). Or maybe we can add a backend-specific lock, which pagefault
can block on at swap_read_folio() time...

The other option is we can re-use zsmalloc's internal synchronization.
We already move slots around for internal and external compaction. But
that would blow up zsmalloc - you'd have to implement the stuff above
inside of zsmalloc. And we might have to go for the pool_lock, which
is effectively a global lock...

>
> The numbers in the cover letter are from 6.12 and don't compare
> against vswap, so they don't say much about this yet. I'll redo them
> on a current tree first.

Yeah let's focus on compressed writeback. It's a concrete problem to solve =
:)

