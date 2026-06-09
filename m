Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3EEBCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 20:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E77D6B008A; Tue,  9 Jun 2026 16:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598D06B0093; Tue,  9 Jun 2026 16:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4873A6B0098; Tue,  9 Jun 2026 16:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2326B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:47:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 705001C2FBF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:47:54 +0000 (UTC)
X-FDA: 84861560868.27.6739178
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 76220C0008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:47:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gke0zsYb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781038072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLifDYktAjdhZiUiPVsyyYLPRgElVQdMpzKrVQLAsNc=;
	b=7YM3375OaO/u2TM/4f/OEeF2jxGDB6aWmllryaBYQogW1gyG1WfkmlaBPfNBoC2ycjzTpe
	RKd9ej0ly6xjLVZL2x8u7qhDyK1lxnWWSAX2yZOtRswTaVZ2UsG06k0+NRJBx6IQ9SzROC
	21EXPgZrmAU2g7M5tXdfOE+p8T8BNhw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gke0zsYb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781038072;
	b=oGFLp/nf8Qc0lEMfmoR4GN1IDqkuzzRT+Jj4wGXYpoM4mLeNT/d57oTlkiLbPiZuCCidMh
	HDIA2FHjSMAaeVy4iPXAVivBBVdjF7eAjWYGqAIZkmb3J8O5YOxEPphGNCDbQ0DPmyApx/
	Sc2ubRZfSaNXYIiYk7lGSVsFRtKVo4s=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2c0b1a48855so4875ad.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 13:47:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781038071; cv=none;
        d=google.com; s=arc-20240605;
        b=hF90kqPtUlLcom4t2Y1NiQLW8U5adWHKb4q/Pv2+OTDXTDnC2TOLlt8cVUfxp51Cr9
         T61aMMXFw0am5OMkUCgXz5bpGMHjkAj4cTgO87Hiv/xPRislzV8T90WCUZOxdj9+OPA2
         h+Xdo6j//MQccmWAHWcpmSbFjILCN39sPijGQBvs5nvu8oMIQpYoj/EQPC0AVrAre9zj
         n7PQHoCgj6d+ac+pOJyPi0yf4Z/5BcxYRcaVACACKfNY2km0X9dQ2A6+II68v7ZmNpa4
         3Rm0sZR0yFHeqjkWBECd1BiCi0p0UOfbC9EG4Hk7ybsKPEiSWxYn++c36sPHQbG3ynSo
         6b7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DLifDYktAjdhZiUiPVsyyYLPRgElVQdMpzKrVQLAsNc=;
        fh=E8WgawtcGSIIljGpFIX2aIIQ9G7E5HsLvW/DsqlZaKw=;
        b=RY2cu+eBZPXmlc3iIdesdvmFhVapXFLX0eFjLa6BLZNNcoXCcpexMI8qIWawW2KD1H
         OrVeyxzer5WffAt1PnCMrV6TqrDwA/g2SblKPve6B8OmdN0nfrTVHLdyHq3sEpdqAtOv
         9Pik35RLTpS2sJfJS8DVUwr6GAnv60Yp/vV9QxFEon6sLEEXZrE5n8tBzTVtGa+zL5OS
         AYt6Mqzf0mAOPOWwBbWSUXP0U7BehWwnjVld0vMQsZGU8YyCUGzv5+m5OtLmrQEfI9G+
         6CbuvQ+/X8K1ZEvgkyMyTbDsG9sJw+vfpqfvHn6R6wm6cGsIXWUFjLKPNJKae3DIpPPi
         0JfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781038071; x=1781642871; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DLifDYktAjdhZiUiPVsyyYLPRgElVQdMpzKrVQLAsNc=;
        b=Gke0zsYblpdy+tJBenQDXqixJpNr0U4Jp2VlIvbsK8pr7/wjCNhKJIfY5lFGZf3KZC
         GVitT3rlOG5lTWYKAxa/5DJ0zkEhj3wPo3rqt3Jm7VGCVqtbtsasxj1nhUA1+dUNKcP0
         /bMJX6YNTFGfUztXj5V6KowRcTC2gxO0WiA5rugZQdPvECD4mQq7Bm1aneW9Yt662Deg
         mUQL8Urglzmo8PEiCHR8t4DDB4k/sUrIXjBrn+T6WORLWmhpmgnuTGDS52mtXdxNXeI3
         pw4uderRh5pV/vZK4a40+y66ZwMLyzUZ/rJ6vAlNCWWkKP5Cj4OWqbEMzoxvCo2dJtVU
         OQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781038071; x=1781642871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DLifDYktAjdhZiUiPVsyyYLPRgElVQdMpzKrVQLAsNc=;
        b=BTod3D1ph208Z2kY3Tmp6uCp6DK4n52KMKZHBbmY1h53gQb/B0Qhus1QQlgZ+bYaM9
         rlQgnkta79xgAHZkOAS4Qts7y3iMExS9471lpf4eAzztoXRvyvurRYnfMh6EYizCElQi
         G9CL3VxCn2J7REWdakKlpsjmjjiK67ycSL8JwGibGVwW9z8pHtjYF+aJPThCJK2Fx+/Y
         t/1xL+3X5sWfqaUwrvzL5uHk+Xi6MABUhF1+ipb0Yjle9U0ujb1YqSxCYxhIBXKKh/uW
         /1QNzQTU+kaNQyZsLlFgorNtCHD4Dew24ggI+7CcjyYWGMRg9NlGmf1v7jp7OYo50C1v
         xmfw==
X-Forwarded-Encrypted: i=1; AFNElJ+i/IJZChUpV/Vtv5eqDvF25s7U9sJCh1ELUNLX0FUBwfyMLQfpJE0vqKQTEVz8k13nfFP7fJq9vQ==@kvack.org
X-Gm-Message-State: AOJu0YxvEzXDE9hiFOSpJijlWg2z6BxlRfNgqWD9Y2Y265uNwegLUbnV
	8MVX2/KyQk+7vWqQ/T1OIwdh6SPoukLfYul9QFOYOR6FjCYFmZfKgTTN4kqBybmYvXMUDTnRIE8
	dE7z19/aHXdS+mGt7mu0MZQYizfMRfFdUUYLbvdrU
X-Gm-Gg: Acq92OFnKnFG0+kanEbf+mLQlWevBCPOlB6dj42P38jADeT4jf8HhSx6gNOhgesR5A7
	RvJOvcAfyZ1eOfDzzE1imM0cwwQDixQcDQBsiCPuCU6YK27O1AVEjumb7tpjIH3aWNVgeun3rd3
	NLWi79jAby08eucfoQ2YbcEXL2hmJDpvkvLkgfMu+Ykw7fLXC8y1M61WPLYSwv8LYqH53Ds3Ude
	Ez0vUCUKBo03lDAkYfjahZd6OsneyCY45K6L1CwB9xajnf8ARwS57Z9LoqvtUT+44KeittM0Rrs
	RhA8Mczw1cDRlzwBmZON7G2ng3G2IE9U+Ij7yQHV0GQ5Rbil
X-Received: by 2002:a17:902:ebca:b0:2bf:139c:dcf3 with SMTP id
 d9443c01a7336-2c1ebfcecdamr7682605ad.19.1781038070721; Tue, 09 Jun 2026
 13:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <20260605170858.9ee9ca2181a041bb9a4c3098@linux-foundation.org>
 <CAL41Mv6pZOVacLdUGta7UnxmFryumBbN6=Po50KfzgLzMs2PQg@mail.gmail.com> <CAJuCfpGr+K+fWK0zxVdMqGwKnr9Y26=Hn0HYFpnp-sUBcL8aKw@mail.gmail.com>
In-Reply-To: <CAJuCfpGr+K+fWK0zxVdMqGwKnr9Y26=Hn0HYFpnp-sUBcL8aKw@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 9 Jun 2026 13:47:39 -0700
X-Gm-Features: AVVi8CdixkisYnFamT2wFz0ODVTO7BS7PkTvbXD_AzmUS71KZgjlBwqLVuaNZIU
Message-ID: <CAL41Mv6wwDVBuZRqGyOcu-4VJusKOsDTD-J4YLAdvWgDoZ7z7w@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 76220C0008
X-Stat-Signature: 88uu86oiom47mc4yuzyngx1smtr8izm4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781038072-361224
X-HE-Meta: U2FsdGVkX1/2vs9SZyb9r+Bp1bsqzgQKBbd16PqxRiRzAvmNKWnCPTRiyfRZHE60DLWjPr0JA+ysZZGXxV3u5HOKR0LGvH64Zqx7uyT/ICWvlzaKcJ/cGfz4ACeBY/b1/ypi74Twatadg26FM/oknHiU3hNfv4gOpL3nVmpIHf+GKEjstoI4WAUunlcBiHAoxl++oIWeGCW6FYiaj+cibsJ8lSkgCKSFn2NFxRNNa6BABZ3YIIff5rsLejdieLKsS2jO1ZTMF9VYZaqBv74O/oOIx0mm3qVDPXjDt0rsDrU0DErd54g6sfazH6DN7v8lOgP/vFvf7OA0xV8V/x19FnHu00BAGuMg2ffv90kiJ+Jj5HgGe9AfFAjjcnyWYeo7UxsFz4PK4FbpEye6rSBpt/PlVByei5S/Qe62kvClfLx3ImJCuuLJCSUXtLyyYZItwCA3jjFmRkj55/SkylJXVUyNavp1jC7ptAHs0xcoW8tQaBNJJob3+iFPjYKXPnaJnBKKRiHkTm6RGPXdKbaj2iBJQO/LhFFA+R7CBjF1ByM5TmYvJPznKc0E7z0Oghu4iy17clK75OCa221yyJXYU8oZLdrzFc9DsoMegJ79SqEpSJtq/U/SbNKRyFcJOkkvCq7uxXAyn7VQMn+Xnp8+e4syRhsKekvcEbQ0ngyYJUZPlZAZwYD5HKD2t/ygGFnW8UXPHgbQw98oyHvRmfRUjI/6ZEBnWWc0NBiUgfgy8FX0fgMlbG83H76iHX28V8DU/CjKSuvAQDPMLi0NeCCM12mfENRBiIngKkNquYGBZIHjPZYOyV49ImRwv7kZxyb00c4aL5f/NpIwLozR2Owfg2lbvXK1rTlo60D/LIlid5lcz50X+bI8kiGAsUMhAO21eS21nz7Iyy+hq8X3zje55fv0I+3VcqyrNDRIok0C6MwmaexVtAohDMKBWyRRgrkGToF4asNz3i0k0JzwzNn
 6YqKY2Dc
 poIFbORKFEQ+DV5QMnp8PoNJAqZsgmwd0+N8zYoTHc4CdrX/Xho20Jj7R9YgfBjyAeZcgaui0LgX2hSZfFAffnBCt74bDVo1m8LvsATwYcUVIyFr8A2Ghimuz8JxL2OP1S4UivM9tww8dHmt9piz3qsWczcWiPa2CPPOo7Fa+/65zAwNK7Sj0hZeeN/BWf8WiAEF2D18iK0Ks70mDD2zA/4ii7Xyhq0sUpOjY6+YnAds8m1MrdZbNnOMuPxLTT0O7nECuV7qjBa1I9pKSotdT+6n1VT10SyfcVqcxEWTZXaKw5j2rD42E+BnccTXDgvWw22m7e1f768PaeKO2aS960AyZXSrLpbF0iEdMs2oi1c2Gx60+Eqk8rSSjCvMLBkJXNgCXLlQ8Yz0w9WL0hwgGc8AQT5rqJgOMObJCXKFXR2jT/RI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 5:29=E2=80=AFPM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Mon, Jun 8, 2026 at 5:02=E2=80=AFPM Abhishek Bapat <abhishekbapat@goog=
le.com> wrote:
> >
> > On Fri, Jun 5, 2026 at 5:09=E2=80=AFPM Andrew Morton <akpm@linux-founda=
tion.org> wrote:
> > >
> > > On Fri,  5 Jun 2026 23:36:45 +0000 Abhishek Bapat <abhishekbapat@goog=
le.com> wrote:
> > >
> > > > Currently, memory allocation profiling data is primarily exposed th=
rough
> > > > /proc/allocinfo. While useful for manual inspection, this text-base=
d
> > > > interface poses challenges for production monitoring and large-scal=
e
> > > > analysis:
> > > >
> > > > 1. Userspace must parse large amounts of text to extract specific
> > > > fields.
> > > > 2. To find specific tags, userspace must read the entire dataset,
> > > > requiring many context switches and high data copying.
> > > > 3. The kernel currently aggregates per-CPU counters for every alloc=
ation
> > > > size, even those the user intends to filter out immediately.
> > > >
> > > > This series introduces a new IOCTL-based binary interface for alloc=
info
> > > > that supports kernel-side filtering. By allowing the user to specif=
y a
> > > > filter mask, we significantly reduce the work performed in-kernel a=
nd
> > > > the amount of data transferred to userspace.
> > >
> > > Thanks.  AI review found several things - you'll want to address at
> > > least the first few.
> > >
> > >         https://sashiko.dev/#/patchset/cover.1780701922.git.abhishekb=
apat@google.com
> >
> > All, please note I missed attaching the reason for choosing the IOCTL
> > mechanism to this cover letter, but I will attach it to the v4
> > patchset cover letter along with other changes. Thanks!
>
> Can you please add it here now so that we can review that?

I intend to add this to the end of the cover-letter passages, right
before the version change descriptions:

The ioctl() mechanism was chosen for allocinfo to address the per-CPU
counter aggregation performance bottleneck. A traditional read()
operation must report the total allocation count and sizes for every
code tag in the system. Doing so requires iterating across all CPUs to
sum their per-CPU counters for thousands of tags, which introduces
substantial runtime overhead.
The ioctl() interface allows userspace to push selective filtering
criteria directly into the kernel before the per-CPU counter
aggregation. The kernel aggregates per-CPU counters only for a small
subset of tags that match the filter. This results in significant
performance improvement.
 Beyond fast filtered retrieval, the ioctl() foundation allows
introducing a context capture mechanism in the future to capture the
context for specific allocations.

