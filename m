Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0AB3C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA9E6B0095; Mon, 24 Aug 2026 09:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1DA6B0099; Mon, 24 Aug 2026 09:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7A96B009B; Mon, 24 Aug 2026 09:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8F8E6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:34:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 353351C0141
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:34:21 +0000 (UTC)
X-FDA: 85136257122.15.A8291D4
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 385DDA0002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:34:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="owAO5yO/";
	spf=pass (imf25.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787578459;
	b=NAOBXtYpe3bTTf1d4uX279T51F9Gfk02U8F0rBUbQWaMzBNZZ6NtXuuLniYqHnJdnNFRW/
	FDLnKtnIR8w3Q7struSZaGZEqhFVlKRl4WCy0uEKjJahno/ej5lDMUB/rFWCQ1ofHP9c7v
	9NwrFheYE3mdGkuF0j7Z0Q1oios+1IA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="owAO5yO/";
	spf=pass (imf25.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787578459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBacaBnshuCPlzxPKwpr0zEJzedqj8NVhoTRiE9AZZQ=;
	b=pFbjhtnh5zSkjIuIrCtt2x6ijrbKBG/ys359uwpX5gykDAsos6RyO3jnKj7aDSVLJaHkHc
	URJRq9908DJ7SaIaPti7wq3f89dN5NtO8RCk/Ylpp00ThsUe5XpeMbDCqTs6IXL/jEPVcD
	5uoe3+Z0mZTiWZUIydIh64mygk3OIuo=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aec6360133so2962260e87.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:34:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787578457; cv=none;
        d=google.com; s=arc-20260327;
        b=E8+9b3nVIwhWoxFmwqljfW2+6caX0K3PSlQCk+sZt+qLR4ZpFPhQGZ2p3L2zBj3qX0
         D7Mr4uENzrFHfEfEZUzr3IEhyfyvJbAFbvDsykv0f79cskXt9U7Z2ymcm5cvNoYgBkY/
         lLm34LQCwakVc7llcrFz51gYtjVj2vEIqmH3iG3HtZnfvi2pd05ZarxsKVuFrDkKu5S3
         ngGclrvniMDj7rUtTXH1pimU/Xar6GUTQnis8CZxHd93chME7kryxEaQIPwuXs4sasCq
         mRcJGQNxo6Q4fVFzcJj3kSGV6DC/HRFOOqQCD/nYcpmQ/h/XVlgll3ZVQBOldbGeUcN9
         8YQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QBacaBnshuCPlzxPKwpr0zEJzedqj8NVhoTRiE9AZZQ=;
        fh=1GMTiCHx9BDpuU7SUrBvsBdw0yrBQJnoGo1UYi6cHPI=;
        b=Wv75587aycse8vXG5RTbrjXHLza0abXHM08ngnanHJBeou6tTOTFLfq1H1YUGhxbgp
         wO9Du6SIwXHHq7Ic29NLQ2gVmTK1EM4RYAOYbd3N+dPWQjDvv+uFq2lREEsLicnSAd4D
         puZtl+paocyN2Oa3sEpjqURC024RQOWbepjN2RMuUWBcflDEq/AtND8IHgpks9qse63U
         aEKIfgLFT8VFqGoV8I1msVA88gJiVgBBtIoTzwM999PJElQKOwyrSvZMFzVXbxqCEk6g
         VaGzVf3lVAJsUIhfRGLZLn+uslOi09twuBJ42KFCZ5gm1Fiz5VS2mUuBdLDZ7vit0ytK
         h+fA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787578457; x=1788183257; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QBacaBnshuCPlzxPKwpr0zEJzedqj8NVhoTRiE9AZZQ=;
        b=owAO5yO/k2u/XdX1AeX9neDAvJkbRdL8SsuMjPNm9tgGz4j3NKobU95QHB5uyPI2Ci
         ervsjTuvsBNsFllekFYjEDVCb2dMO01zdi0/RLjK17pdmTbGo21pFYCx+GilhuKdxStd
         zDkEpe/oxyqt1gMXJch58wnf8z6WeoWR0uM4/V3yWgScjvX+m+VreohQCfNUlJ1uMkVH
         OblivMlM/qnW//sm+wfqg/wMK+Kuj9y9ePQLelgXgKoZGCv0MrrB0D2E6XNnjcWMqs4Q
         KXOVUBjjjhOKCZCwEaWxfFTFIclopvfoGRRSGTAeZv6q172Hc03cNAnxJq/VcgSnf5SW
         bLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787578457; x=1788183257;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QBacaBnshuCPlzxPKwpr0zEJzedqj8NVhoTRiE9AZZQ=;
        b=TUmT31ZXcRjfYGwCvv+iq4ytv12wh9fnT9v3KnEF/9HmjZ9sMgmoc4HPRMJJj+NTfe
         HViO7n9wbwcdjLmvqw/UYpsdmi5E1hA8VLkkezh25iAg8TdBu8yU1HRWGUwBkYeJWtt+
         Jf8W/XPoNh68u17G4SmuSOwzSmpa/CjMr5xHXRUCI6c6WGcPUJ3J+ndhSq2wiDNrMy7k
         wsvbtQJUjwrURpRiVvVFGgPfn/FD2ZGRnPrMW4G/sqf87gQnXPZFw9gmzs/lTJ5UMn1U
         rls5eUDB8yooQiCrCsH9CE2NzLuVV4zu7T7HUlykngYDpnCzivB8cBzNyGqNhB1+a1TM
         VW/A==
X-Forwarded-Encrypted: i=1; AHgh+RrTK1OcaMHqCE4Moe0aCLbExqyVD0WLCyBaKmwNTaKp7paM6JYfy+CgtLCwdmxEC4CDTfpA28//EA==@kvack.org
X-Gm-Message-State: AFuF++mMKjgiVkWQMm4jGmRMuMSlmvLKvcGNgtVuqxYX/nqlwwD/+CJI
	775yza0p1ukuTAIxPsXZOsSesqojaRJaCKB/n3Q66e1xhgC1HDmNLKUS3lRwQmLelJpO9MGLiGG
	72+fs668FJaGYAxw8GLycORSncQAXTIM=
X-Gm-Gg: AR+sD12b8XFDaQz/EyVqQGoBeEmB/PLEPAJl9zmVW7dIUDE51I77O51yB6naIRC7fwV
	zXZCllV+OvhTbnY4FUczhHZNFjijKROJme2oCfwdAgZnPq5yTQ81HGh2AGbyOjFXhYx8q/91PuA
	UwxV/NOl3yt2AmVNIR7mO69/nO8lW7cdOpBC5PojVU98B64Bls5EDPJ43RGWqJCQBNky+p4JTSZ
	UAWK5jz76AMM49YjTv7Kc8+DDttZAscI/UDj+mYcSS0/ZWOJe41BOtCtuDVWeGLDtlPKdX5jLz5
	CIlOMxQAACW7xTakqm0JNTpjVe5nftABHlxgRczbTGsSzg==
X-Received: by 2002:a05:6512:3c8d:b0:5b1:121e:56ae with SMTP id
 2adb3069b0e04-5b484207013mr9172063e87.11.1787578457000; Mon, 24 Aug 2026
 06:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <aocQcaMMU7-rfn3e@casper.infradead.org>
 <CAGFpFsRarmDScAQxHpCtSZxK5H4WCg4Y=y0hXQLjGT804ZoWkw@mail.gmail.com> <aofGOQB4TViwQQQ7@casper.infradead.org>
In-Reply-To: <aofGOQB4TViwQQQ7@casper.infradead.org>
From: Wenjie Qi <qwjhust@gmail.com>
Date: Mon, 24 Aug 2026 21:34:05 +0800
X-Gm-Features: AcwNN1UaVcaeyubnRP3fsC3CJZmuoOgGKa4w0B0il0q9I0mk8QLj8AnssfwDVCk
Message-ID: <CAGFpFsTUBCiGEUyKzYNaT7Xe3O_7dVg6T==v3ssZ-9HGQiafLw@mail.gmail.com>
Subject: Re: [PATCH] mm: filemap: tighten dropbehind completion context check
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org, 
	Wenjie Qi <qiwenjie@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 385DDA0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3pe8mqjr78ig61t97mkiu4n1b6thdpgh
X-HE-Tag: 1787578459-561963
X-HE-Meta: U2FsdGVkX1/irRFdClNLms326kv+JpHmOcz2VILxscxBALydpcEtXhpuePwQwjvDr8RkDjdSmB3Nh17n4Ljnqjsxi44V3cY0x7Nv0Xyn3W0C+DrbWVdq/SY5sq2cy15iVyCzZwFiWJanew+liRJPTdu/JODHO49BrEYt62h6TlASgzI3Wa3jpKH3hBI4zXzeftyje9QQ6g6pU4wOig3uyGzPYBmwxOvRMoNzfww5LEbQ6zVte+L9qVAZfLKQSZYeb91H8u60NyzpKruajFkN5KVQLsHUXnnuXYBnArA7mZClEJADGci09Imu4NtRahfJqNH7Fvnx1L+RMoXxHgUTlE5N8DvFyYj+Hrt4vk/zSuA+6H6tu2GI/FqWoJtN/qgKE90fExIAnpoEPg5KHLNi1WX6Db/iY9FbiK3Z9XCneaE57Upkq9wo0JCfOAGMs2rUhl4RvRI9fZwlC6G41PnnXvPwSIeHpbcJJ5mgmJ+OgBh8/HOWFhPvv2nDZqvp9bwVkv1oqHUmPd6kZA0pnZt/BOJvexx1Mfg9uKRy/PJwkDOBGerjMsa1KX7GzBRvFZgRFibhkU1o6jyl6pQs/OhcQk2ceciJvos3dzLSVi9x/kwETxCOVWAFk56Bi+eL/QwA4+qcKSwPAuUCAkk9Cuei/ItmfxUmwDzXLdYsdZhYu448peCFviRriSBZvFtnoeJ73q50ZLDN7LGlOxzNyv3KJQWYPw0tXqD4Agpg20Rssl5mt1OAUsCoxUR+HMjmuQ12DzVf+USGvYjBP4QEyv0PQifVIl3keCj8e8eehQTBteVKWGQ2w2Nyo3gwt6laW3KVhLuRGzgLTFP2hgBKwHGKy9ca0F5SjFlcAAGEAS1BMPkCkL0VGOZ1bJ065A0bC8alWx9RZ0WFcViz9VDq1Tz7DbOSg8W//TfCdY/LOlEBwj3JjmEms0kWi5ZiHEJLmU6TuYLcICUsoxs4HbrYkKD
 vusmQtf1
 pyW40krcpSrmDiFiQ90QGspUJISTLUgO7sWF1WZzzJ7zwyG4k3liVMIkxQiGNVIC4K+1Y5iZ2q8gQzcT+6DDvvmY/OEKZdxPZoLIJfSgCbkN7OMfosbrUZpllZ4VMKNUHdq5bvksBn9DQOak3AGEjwPgbFo4kK1o+NJelaIL786WHY0jXRTyZrYs8SJnLHgPy0A/NjHg6WNckQA61n6MMtCV2prH6vKOuf0QR+eHz/nxq3TbwP4tr0syQ63VVC2PDncYP8F/x5PQJHGLsXVzXZFupQkoYzgIKTAn7cRkLIETIV9rNNbOJPFvqjt2alB3Ies1qOsn2SYPBNH1G0FBxb3QrxcZ6MWokWPo6Zou52VlqkNwxszeaF3zWzMMztbXaUMojPUP3kc8zT7m9xZmsErDZ3K2L/N5OxBef6nRltWX1mod14Kl1o7MaUK5cD092hkTSabfQNyYDLJAMg/cPuowQ04YM1/xSX7jARDmXnY49aio3b4V1pgUxYwgti+HOwwvv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  I think fault-around provides such a path.

  do_read_fault() calls do_fault_around() before ->fault.  For generic file
  mappings this reaches filemap_map_pages(), which walks mapping->i_pages
  directly and maps ready folios without going through
  __filemap_get_folio_mpol().  It does not clear dropbehind or exclude dirt=
y
  or writeback folios.

  If the mapped PTE range covers vmf->address, filemap_map_pages() returns
  VM_FAULT_NOPAGE, so do_read_fault() does not fall back to filemap_fault()=
.
  Both the faulting folio and speculative neighboring folios can therefore =
be
  mapped while retaining dropbehind.

  A fault-around PTE does not necessarily mean that every mapped folio was
  accessed, since neighboring folios are mapped speculatively.  So I do not
  think folio_mapped() alone is sufficient to cancel dropbehind.  Clearing =
it
  for the folio covering vmf->address may be more precise, but that would b=
e a
  separate semantic change.

  If this distinction makes sense, I can send an RFC to clear dropbehind fo=
r
  the faulting folio in filemap_map_pages().

On Fri, Aug 21, 2026 at 11:30=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Fri, Aug 21, 2026 at 09:23:12AM +0800, Wenjie Qi wrote:
> > This is based on code examination; I have not reproduced it in
> >   folio_end_dropbehind().
> >   There is an analogous EROFS report where bio completion ran under an =
RCU
> >   read-side critical section and hit a sleeping-function warning even t=
hough
> >   in_atomic() and preempt_count were both zero:
> >
> >   https://lore.kernel.org/r/20230621220848.3379029-1-dhavale@google.com
> >
> >   That is not a reproducer for this path, but it shows why task context=
 alone
> >   does not establish that sleeping is safe. Here, folio_unmap_invalidat=
e() can
> >   reach unmap_mapping_folio(), which takes mapping->i_mmap_rwsem throug=
h
> >   i_mmap_lock_read(). I noticed the mismatch while comparing this path =
with
> >   the stricter bio_in_atomic() check used by the block dropbehind work.
>
> So your analysis is right as far as it goes.  But if a folio has
> been marked as dropbehind, but was then mmaped, we clearly shouldn't
> be discarding it!  I believe that we'll clear the dropbehind flag in
> __filemap_get_folio_mpol(), called from filemap_get_folio() called from
> filemap_fault().
>
> If you can find a way to get a folio with both dropbehind & mapped set,
> I'm interested in hearing how.
>
> > On Thu, Aug 20, 2026 at 10:34=E2=80=AFPM Matthew Wilcox <willy@infradea=
d.org> wrote:
> > >
> > > On Thu, Aug 20, 2026 at 10:29:56PM +0800, Wenjie Qi wrote:
> > > > folio_end_dropbehind() uses in_task() to keep folio invalidation ou=
t of
> > > > interrupt context. Task context alone is not sufficient: preemption=
 can
> > > > still be disabled, or the task can be in a preemptible RCU read-sid=
e
> > > > critical section, while filemap_end_dropbehind() may reach
> > > > folio_unmap_invalidate() and sleep.
> > > >
> > > > Use the established conservative three-part atomic-context test: re=
ject
> > > > preemptible RCU read-side sections, reject configurations without
> > > > PREEMPT_COUNT, and otherwise require a preemptible context. Unsafe
> > > > completions retain the existing best-effort behavior and skip inval=
idation.
> > >
> > > Have you seen this happen in practice, or is this based on code
> > > examination?

