Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E77ECD6D3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 18:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51DE6B0089; Wed, 11 Feb 2026 13:24:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D3D6B008A; Wed, 11 Feb 2026 13:24:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12566B008C; Wed, 11 Feb 2026 13:24:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B29096B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:24:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58BF41404E4
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:24:58 +0000 (UTC)
X-FDA: 84433002276.18.C2CCDB9
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 46CAC40014
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:24:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZldtDfuv;
	spf=pass (imf27.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770834296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQMG4VAdv0ceQ5uFWIOJkMfGcq8K2Ty7k/bt2AkkDAc=;
	b=RZTx1tsM9TmfH/BhC5HUvqnDtUK4js2Jzs5sdvOQpKw3wCMKGIRyn1Hkduz8q3oL4B0Fnv
	dqYUKIKfS5jlK8oBvQG7CR8G0NeQpN21hDpQZR11zpgH8UZNy/U2mvJFZ+0s55B0WCjLT0
	wzl2NW9VnVPAPEDMDKBUH54nfVLWz7I=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZldtDfuv;
	spf=pass (imf27.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770834296; a=rsa-sha256;
	cv=pass;
	b=dK39dBL56dn6yeyKFSRYpsbDGEs7HEIs5H2gAyWe2dN3FINDxhAJ+VTlGwyvZOd9A6i/TP
	WYtON/4j9eNbqx++Pg1JJQbDGu9Gs3auKFtudReBskl9wFI+AJ2+niyxBp+iuayYrvzty8
	kRxm5Rn/5kFAdDy00NfyHTWBAR/xjDw=
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-382fd45a1feso13859291fa.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:24:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770834295; cv=none;
        d=google.com; s=arc-20240605;
        b=D3BTOH3GluGd0OpYWFawyKTl6p/qpmVgcn+npy7BCzOflClye8jposTfMrRmZ63J7p
         OYyXcQTHUss84XLWbg9eTa8JLEedFXHDguAGl6EdUywLy1w7m5krA4QyjJjqNJ9jTgcW
         jNnLekPRL5vuqbuXngsbtGm2oLE0Jb0SkFbbZL971JkYJ6kpCkVboWcV3q7VmXwyg3aQ
         HyH3o3yd1+X/C2oqYCb/vKBCyBxj/QG395mhuA++LpdjwjHTkvWuy0NoufwZYC1FmwKv
         8M/W1kuvj3Fba0E1ePMjNw5/cgzaN19S53B7TeFlX4EUS7Cqb+6/7reVcWOiCSbPIypc
         S05g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iQMG4VAdv0ceQ5uFWIOJkMfGcq8K2Ty7k/bt2AkkDAc=;
        fh=QXO74fbveDwg2d3mWSXfkcGATWGbcp1tL3wu5BUSelM=;
        b=aGhThJLGyXYmOtucKhEhBB6QKHWvStekzAyqsI0ffek8APzHG+zMtqtpxPZpcuKvjy
         5TouXLk0ZWjyDYE0GnlQbh0JlUPzVDCFTDalqzypr08ZqBCLo8zRj+AL9+oEYhndLMVp
         cFNyyBqlFehqLGTUoinYv/E685lqP9ed994GcFHYvBIFpBG5BHWIW9AUkDuGA5pNw9or
         d/sK+YxwlXWUJjomqkGzlxBfRd5JjXCUGTPzCFJJ7owNhxiBNv91A2VJEHp5mvizwASX
         cwEQFF7nfPSo3NhsbfcgKJyjHuHou0BtVnShJv01+j59j2vP7kr3grDYJMUf8YBVDmg3
         Jikg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770834295; x=1771439095; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQMG4VAdv0ceQ5uFWIOJkMfGcq8K2Ty7k/bt2AkkDAc=;
        b=ZldtDfuv5eAT9cVLMC6zP3enwZW+NjYVXcJgwlcBcCobKIo8c60vGiunn1gYRX+bIe
         Q5w8i6Z51nfRq7jkocQQFpbSP01HKv3WuF7D/l7pcu9/2LgiMhhfh93DRjFLr/b9oMUh
         74LccmxY2G2CvadNKIwk04SX2DJChVLIe9pUQlzECG4Ip0J6rloX0SQMzsK3qRv3hOx6
         q1XF6x9XOJOnNp7riEyNSGAicauJles0JTN68+KqWhoaPqKl+RP9F/CVf+3Y2lyx7gHd
         +iR1g4IdSvxHW5c6cbVawY/RN/fZZAu33clqN7tba1nfG5gyYcUbAdhlQGVQAjA7rZf3
         JOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770834295; x=1771439095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iQMG4VAdv0ceQ5uFWIOJkMfGcq8K2Ty7k/bt2AkkDAc=;
        b=ObHNeM8/IRjiQ0CGFckvNKXBvThIyh0dfzoftm3UrJHWH9UyuR1clko7mFwUSSVpCc
         c/8gy/MZn8Jj42acW8WeB0CH72s6wz2Ox0lpL3Tqp+mnQn8S4V/LUs+agftcRRS7MayB
         TtcR0Gpqca/xE2w8KiwIa+5iNxxKdDrSEaMjcKbY//WZryVB3L5IXysqMYRY0lYnDPC5
         YdRwzEUdxZ/qRTaWP413D9wT5kwn96QLx82droVSk4D80j6fLot/QAKOQzJAdbEFBVvb
         1TJPAD8WzxeTucQVNXR5aPwE1OgeCfoMWLq1NOpIZtPJK3ArnRLh1msK+SX9gJUgM4zv
         vkXg==
X-Forwarded-Encrypted: i=1; AJvYcCX/pZQ3x1x2l/xSBDDQxfWYeayz6sQ1ikk2VYm1fRtcQlDJDsDK8L/PXk7pMBTwERDHxF6/nzKluQ==@kvack.org
X-Gm-Message-State: AOJu0YzcPgdI1ejmZiL48SNmxKCeDS3NILe7w50sYidrE2kA48AJqVTA
	o1STJT79CBrEijSYr13XB3zMoSpuypKOiDlkaTpKnQkJpRiR8MVn5595vIMpYZkfUHXsQM+YZmN
	BGUMsu23ZgZqKpT64jgTYyfjMBVWF2yY=
X-Gm-Gg: AZuq6aIyuAZYLeSSm/cpltFPEP0wD4w+g2xYKDY9WdSUj1OiZRiPqbtCJMNFsullNra
	bV80IAcueBKtQGu/iRoMK2Q8zcmxWfdg16qXO5YX4M9AyEtUD+qGPZ04oZmxnMlyMpjNLjiplhQ
	bqnE+7+nX1b5xiixBKEh2SMiCntkD/X4R943unNo/ziHhPoiiT1PNGAgtz++bkOUhgTN/HpeZuc
	jAGYJySHczTTLPoJEvqgMOyHESb1ZGFJE8+s3nxXIcsJAfKqp+k8DsyXuMCeynJYh4ljYhJT2qr
	7xNrGL6bpGDpHtvxPet/HOutL6yiIu1kaP119MkZqA5tjUjQzudsU6Rrz/1lNhv2pD42ApazNmr
	I5CQ7WVgI1ahVz2px8rQKiZ3FElf+gfs=
X-Received: by 2002:a2e:9b46:0:b0:387:e03:147c with SMTP id
 38308e7fff4ca-3870e03171amr3123811fa.1.1770834294387; Wed, 11 Feb 2026
 10:24:54 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org> <CAJ-ks9mF5x5mAUcfN6dWN-NWoaE=j-8h0y_F5AM2Pnfn8RcV6g@mail.gmail.com>
 <87ikc3viqs.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87ikc3viqs.fsf@t14s.mail-host-address-is-not-set>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 11 Feb 2026 13:24:17 -0500
X-Gm-Features: AZwV_QhMUgkHsYBPhkqtwQcOlYdKuPSOxt9s5-PDmT2DNnRzhy6-9DZN-95P4wo
Message-ID: <CAJ-ks9nZuBJnw=AAr68Chhfa+QB=j4OQURKJrnAFJarqw4gZcw@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 46CAC40014
X-Stat-Signature: 7w3s46fxmi5d4ra9jz47bu1q9dxwd3s7
X-Rspam-User: 
X-HE-Tag: 1770834296-941530
X-HE-Meta: U2FsdGVkX1878pII1B5Z5CkWCB8nejGTKSyJT6dhtP15p9rO9DVvvRiz4uvbeBs7E9emHmu0eRuckmDxCMGe2ihfTP3xmNYoQSUequcnCWQ45pOvYxvU/Deb7eERTNXTTSERJPdsPaiUaCH1ORdxaQArDNFqc0cy48h9EuThAhimmchkczd9QWpryLkplmUvZzTjhFq/0EolF/UFbWXK25oXEI2QVEt920tQBGZEr/sUkCn9SSmEDu6zaHCu8RpqR8mNqSXJPQE+mIdNsoZ0GAtkP0oC+f3qfTQS9xIPr+vQINXcVjWceKwODiVxCPp3tAsIyoqiPx0dY70yJau84zu0p9oAvT4l0p5Q72nChuUJVvZHg0zTcGZuGCu7Cf2AU4GzEGeoKeA2G5d1XN8cM994cn9zIpAzn8FcQcqiwz/JjV3wmPHy4avoIYlZkVTBz30Ew4AbJ6b3fYCOwW2zFYHDrvC462Exg2YNwSwuZdNK7cyTzAl5r7SO/lANsN27K1/isKkQpNQCHGryUO0motpWrSh2qiy0u5XJiN59s6CC2eM3a6l02R1isP58/gBmFsu8iWptbYBZkHsLiaBsFZyCOmI/bVlYOskTgf2IXDt67/js8by0rvdkHEr4yneQ979JioZ8eFO+kPO2bY20La+gTYai/4vevTGltyDmFhjU3+JKUWF7WJ6kd/9/RhINDUuMMdGZfOwVWgvM9VuMzqpFzOOMNWcnPtUnV0FAoKxhV9Pxz092YhJr9b/pFhkUAHWSv1GacCC4uIOEhPb2mC2KAMJZV4tIdou4DdQL+oqZ5Aj4HIPcK8GQjQ9h9Q8fGO6a1CRieEhyD8h7a6q6vHxdtbKX/ycv2Fubif7bdgwTTZ+pyZOoriIcFNzUPODKjkBHx0Rp0M0KX8Urr2hwxsjoIF8kHdYFoXoV0ZnfQQJmCKS9Ro+Ho1aV8+YaxCNKlY2DnE7xFOsgbIM9QJb
 QiIn5U1A
 098mGeMHoDJrcsqPEB+lls/IZxwOMlHiVGsIJfAoiSRXPiEu9A1qIySwbCLIGN2pTrb8LdPR+P7gtbe+WOUvq4+r5qvuPb4uMG2cyxYdxijsOGxERJlKK4sBjwIVRKjwf9jFAKKMDJ+HP/pbXfRU6Ju4/KoS/oH+/8xts5E1tfdiPL7NByhNSD5G9k3QTBrVv4pc6NBXT1JpWDmOQT11WLntIXLvE7b01+BFEt21sVcqSUz6wVyQxNqNWysbom/NHriKv3q3HJNIXL8s/A3OEeOvWxgR8Mr4XTMzM2NiOHRo+HOFfG7BycbO/YAaO2KfLotZpB6vypenmF1sDdaPz94cnmLd/pbY9dq8ROpNYK2miIf1CNrNLNOLCi3/pQjs+jnPX6LUcFFR4YBVruIzWnQ6TSQm1dCAUhr5iCwcU0n7EIpyJqhzK4qIzI8ytJjoWhR5ez4zO9I1usL9RcL7VmCm79v5YknfhF30lwku33rEVh5r2rcN5p6adCLck+Q9TRmrGnKASpNY1OSjszQBH2tiAC/sPwT6Gbvries+mYCtBAll7OXxoqVp7jpCLwNWI5cADyaLkADyBA4wWKSkOGjs+uTp8TAjY6caAVkuCwRN/mOmkfnRsi3WMuzNAsJBOvf9s4F0uIFGFFQ9g1RIbCQ6yjpQBejkTN0OjN3sPuq98ZUSS0ln9t9SnnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 11:31=E2=80=AFPM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> Tamir Duberstein <tamird@gmail.com> writes:
>
> > On Mon, Feb 9, 2026 at 6:38=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
> >>
> >> Add a convenience method `contains_index` to check whether an element
> >> exists at a given index in the XArray. This method provides a more
> >> ergonomic API compared to calling `get` and checking for `Some`.
> >>
> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> >
> > As I said in v1 I'm -1 on this change. As gregkh would say: it's hard
> > to review a new API without seeing its user.
>
> I already gave you the user inline [1] and if you wish you can also see
> it in a downstream tree [2]. Gary already explained why this is required
> with the current implementation of the borrow checker [3].

Yeah, that's fine, and the poor ergonomics are IMO a feature - I
should see the ugly `is_some()` call in your code, because it's a
useful signal that something non-obvious is going. This function hides
that, which I think is not better.

>
> Best regards,
> Andreas Hindborg
>
> [1] https://lore.kernel.org/r/87344gh2pk.fsf@t14s.mail-host-address-is-no=
t-set
> [2] https://github.com/metaspace/linux/blob/aa43a6ecb68a785a90e167609aa57=
c5a0860d123/drivers/block/rnull/disk_storage.rs#L218
> [3] https://lore.kernel.org/r/DFK801ZCI1GD.34GWJ10JZBBBF@garyguo.net
>

