Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27047F5A8D7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A63F6B0088; Mon, 20 Apr 2026 22:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456DF6B0089; Mon, 20 Apr 2026 22:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36CE96B008A; Mon, 20 Apr 2026 22:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27A916B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:38:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B843B13C0F5
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:38:24 +0000 (UTC)
X-FDA: 84681004128.24.1721E62
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id D4C0C180002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:38:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="eEO45W/v";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776739102; a=rsa-sha256;
	cv=none;
	b=jR7Xe/M3OwDzvITYTlH315+Cf+MgDrQGrJzuJ6MTzbOKcZf6gQS/W0PKbeprn7/opmxNy3
	eVoaHAkJUeeiE79ZHUxf4D19jjLcet82yh+YbsnuwcQ7daZi0oyhcLlvTtd1nZwtAnSziz
	NR4+psG3jC4akkhzpGtx43vmdZgxjVU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="eEO45W/v";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776739102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFzhmNd1adFIkSfM46o3U59L62f2VQ0RrNdAOEaBXO0=;
	b=O7rGfMlRrpyBudOeFv4scGNBn+m9kR6rW0+fKgYhutRTDLwt3FBLm8Dl9S1rA2UP5xhR5B
	PDeMxObPRmIC9isxUhk6An+4pzfHdUb4nDekgwfCZaYiQqqPV103Clmd5EnryBJW5NlOoJ
	Pc0NrvOibo0n9shH/JNF2c6pd2+K2oc=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8dbbc6c16b2so476540985a.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776739102; x=1777343902; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DFzhmNd1adFIkSfM46o3U59L62f2VQ0RrNdAOEaBXO0=;
        b=eEO45W/vyADSnok58NA3VW8PNMBzAjOZ9mOS6ikMJQ+GJ604eseVnXFChDZBR6wReV
         WB7hGk/D6ix+Y2VE96e9P+B6M8fHkYCCU1px2gUnguA6cqP3M2Hf/tx1aig6mipQF3Gs
         yoLhANDdwBcW2UmU5u+12gfqMtnvyUNXd/VyDIB0dH6+3qmglPEBdi/6Ufp/JtqIM/NA
         +/jQXx7WicuIyA4z9QcnWpf3DmDw7x1fP+j4NFRxAA6yav+pW2sCx7WASxW5faEHhDoT
         9jg6o0y6vuxrt0qJZ8ZmRunWNiPOlGMd+EQ/Sbts2fCqPra/TJwrjthEBcWTwSddnUZZ
         xnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776739102; x=1777343902;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DFzhmNd1adFIkSfM46o3U59L62f2VQ0RrNdAOEaBXO0=;
        b=OhzArb7hGYeCyvCyEelBoct3xljOD3iPrCuA99X42cBDa8uiQq46Kp/tDwwB8eU6bQ
         K593WQE/Eu56ZsRWiC/poT53/xr9UmY/IVPRK1uyWh5tLl2/o+g06ODA3eAh5NE4fXJG
         KD9dC4t7oOO/mt2ZnC4dCWoXQko3bgrHKsvBp66t1m9ml3lg0GIcOyhNzjh4Ts7cOPXu
         sxI4DoT1EHK3plokowEjQ74fXW8RCWkv9OuF6a2fsSA/ashw1HLk3bTJkwN62rYCI4U+
         Nv7TibVKx5UwkxXmVx2IjB54tromi2hvLHdX35VNkYcoXnPFBx08BQvbhh1iWSAlnW7c
         59lA==
X-Forwarded-Encrypted: i=1; AFNElJ/hgRMAjsF5/zVx1gX+b8LPozK5uSKzujq5tYtT0bdZ5bcp/+SUCP1OgE3qO/+E8BscrB5ltPBptA==@kvack.org
X-Gm-Message-State: AOJu0Yy3Eh3nF+wOCAt1/xQL5iuLY6t0Xci+c70BtQELOeke2ie9AgXe
	1YKfub5f8dvLdadNj/5MwRkIq+zPBmQeoVcy0IqJ7Hs+Cte+5BwheKrKS3T1toT/8jg=
X-Gm-Gg: AeBDietRj5yZTZ48CTAxMhw+iJapVrnEeph0SROMeqlPJl2EbYaByuWTlnjO1wT6RdD
	Aqek687W4DJqiApNZZO259Ds16k5Mc2EAdKFHbNheP8vaEtDtfifNfFSYW3zRBZnAGsf6xqKIjN
	vsW4YIeGGxFdidcglDGcFf33qR7WMfiB8XhEInWDQtKBrp00KgFS0iqR3zTJ13feU3oK7C5mlV4
	s5GZN6PTtN2fWRrJ73ZM35vTc3+SZraMZMqLZJTj2PM6ZrFaCsRaH1ytux1kexktL3xj5AYcgq0
	h9mBWToLSI2S9MdcbquhmHFFAjMKELlrkDGBN0YSYXHbYY56uK2H563DoDRMSMMh4RQNi3K7PSF
	yqUPHeMiwVnIeYLZkn0EVyIPUHarRV4o6+dmAmZizC1iYGDO7vIuaAEPKKy0V58DicC5p9yZMuy
	Jvzz9oLww26b9wO7lYF+ZMzaZcV7zp+oupmH58wGZWKlzaNvtq2qPRSDovzg6FOlLa+ZJSBW92g
	9lVGJeH8vtXM6oO8niXvuR77pn+jLrO0w==
X-Received: by 2002:a05:620a:19a6:b0:8cd:88ea:fd21 with SMTP id af79cd13be357-8e78c5c1fe0mr2065685285a.21.1776739101852;
        Mon, 20 Apr 2026 19:38:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-108-51-163-112.washdc.fios.verizon.net. [108.51.163.112])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d5fe90afsm1079220085a.3.2026.04.20.19.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 19:38:21 -0700 (PDT)
Date: Mon, 20 Apr 2026 22:38:19 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <aebjG-qMLr0joG61@gourry-fedora-PF4VCD3F>
References: <cover.1776689093.git.mst@redhat.com>
 <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
 <20260420192037-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420192037-mutt-send-email-mst@kernel.org>
X-Rspamd-Queue-Id: D4C0C180002
X-Rspamd-Server: rspam12
X-Stat-Signature: 31jb5e1bho9d6u3wttr8x8t8i6bjtrrn
X-Rspam-User: 
X-HE-Tag: 1776739102-344385
X-HE-Meta: U2FsdGVkX1+8C0Nuj6V0Dyz2/ToEgJvTUu1smWmP02VqcrdqR9FEU8DvjoPP5YduW/50X04n+OpiQ1tBtzia76CMVhnHbBJr/fCbWXshpwnTkX//Ryc1ndysD6Ai/KXDhUP7F0TRdfs5C+WPIILoir+Eq63AKOG040ijwrkHYsEgdI0uvWTW7PZLN+/coo+lsNi4YT0HnMcQk381o9y6xxb5zjrjNB2mKA6SUiGbbd7KnEF0Vn4QXX2rrengQ7eAWaoB8Ltyt/ESUVhhHZAhXT2Z3mEaJczkyzJ8+vvkRkAnJVil9TtwzOauEJ+6M4PZbdKMomcFcDH415JqW9lE+HassA+32pZr06hCkUyk5D6e+YRpj16lFwrugqBm0YorwmbZFAb/8L4sn5ieAORWVe8za3NZoXc9bLciHfJThUa5tkWt5BY5CtzKgIiQVRQ5GXwuohyG2KvBNCnUX3cb9z+hNbu+WEaHu7jdjGedCe6N8x3ON7U2ityRTz8kb+3xg7A+zKPmiNFO87wf4CYdBFVBoT/NYr1PaO2zBa2ZgATMc2En/7FsQmWQnPpXq6gq2mxvgWVopzXvIxT6+LPKgKM7JmHOJ8woXobCScBbR0JI3HhfVQHMvCmifMF98NAKYdyZOFmuwQFgw3/mo51zK/bNfezIRBtAG7Dv3r7AIhvKhAPb+ooXrSvACgjg37Xnr6cQHdPfOqQznlE0VVMiPh9Jyc/c/mXPc2+AdlM6mxsc9EvASahWSeBk1fOjJT2ZCr3hl9KlA7G0Tkvsx6jxKF5gZwEBDv5wIAC6jKH38L3ZBWUfknSHaIeHi04JLu3iyUE30gKj4h0h8duG0IUEdjYueKK28Y163yiCb076zjbX3Mje8NPso4uI4b0u+k7YISigAKxNXtRH/HNxIo+sY64h2v0gfePu4YQ/BXFIx2RS5wjuz9B/RX5hsInGHv5QxcxGcWgWBjSoLUlxIAM
 zhlx2YQb
 wIyBxySUBJY7f6ZO28csN2hn1islQ9FwJcri/7i3edPsM2FF9wrOD8vjjjLcHShQm9jwni7qNntFScYpmftp9QLdhRdh7Xmk6d0L2NA88ChqIj61VF2/rqovaJxmD8dZ9Ip+eD6y/i76KrLt3hm5g4u1l1dxmVbPLnBphgzhkRW0QpHgK8hTcl9U1Ov8jMMKuA1LSrZeUbzVbwTGHpP7Bn7HOMw2n6NCHGkacu9XFSKcKBy5P0PmU040vdlR/JvDILk44SXXXLd+/+vYFGvemO9zjnko0dD/ZCBd7/8pgeZ1Th3EtTwGNRH3rQyGarcDksoMXfBzmX35+Lvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 07:33:38PM -0400, Michael S. Tsirkin wrote:
> On Mon, Apr 20, 2026 at 08:20:57PM +0200, David Hildenbrand (Arm) wrote:
> > On 4/20/26 14:51, Michael S. Tsirkin wrote:
> 
> > > A lot of churn, and my concern is, if we miss even one
> > > place, silent, subtle data corruption will result and only
> > > on some arches (x86 will be fine).
> > 
> > Which would *already* be the case of you use folio_alloc(GFP_ZERO)
> > instead of magical vma_alloc_folio() + folio_zero_user().
> > 
> > I don't really see how vma_alloc_folio_hints() -- that also consumes the
> > address -- is any better in that regard?
> 
> By itself, it is not. But the issue is propagating the address from
> there all over mm. If we miss even one place - we get a subtle cache
> corruption on non x86.
> 

Why does it need to propogate?

Can we leave folio_zero_user() callers the same, but add a PG_zeroed
check in folio_zero_user() that skips the zeroing (but not the cache
flush) and clear the PG_zeroed bit?

Is this feasible?

You don't eliminate the folio_zero_user(), but maybe we shouldn't?

(a bit naive here - i haven't checked the PG_zeroed lifetime, i did
 see it overloads PG_private - so this might not be feasible)

> 
> I also note that we need a flag for free in order to implement
> balloon deflate as you asked. Here, I reused the hints.
> 

I'd sooner just implement this as

   ___put_folio(folio, gfp_t)

   __put_folio(folio) { ___put_folio(folio, NULL); }

And change the free path to take overloaded gfp flags.

Some of the existing ones might even be useful as-is.

It's essentially the same thing, but prevents a bunch of churn and
saves us a new concept.

optional gfp flags on free seem like genuinely useful interface for
certain callers (definitely not all).

~Gregory

