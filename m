Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4D6F8FA78
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12EF6B0089; Tue, 21 Apr 2026 10:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3C56B008A; Tue, 21 Apr 2026 10:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2716B008C; Tue, 21 Apr 2026 10:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 788706B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:15:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40AA713BF87
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:15:16 +0000 (UTC)
X-FDA: 84682760232.03.CB293CE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9BC4E180007
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:15:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fwqMbPWY;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776780913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBspbL/u+4h/YiAyL1HV/VPAyarYaOL540HM7IEPE4s=;
	b=ty/vrXivyVpiiJ0YMxX2tYBa7s0Q5K/z/lPRYCtFzKua9h1xgqlMrSv7cn3ivSTcP8ytHV
	T8t9Z49Fjt4kZg6tETGQj7QT3S9ZE4iQ/zdwpxRr8sTYvb89ecmpkK/O4Ow0fuK6K/6ij3
	qDKRYMvfWxAmTnGEk1mWKiaPjqnAeR8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776780913; a=rsa-sha256;
	cv=none;
	b=AT0Ptmk1cukAbO+xm80HzAJeWJmGEHw37o6VM4v1thhUQP8T2dIR9Iy1floqbLZyWNfeT5
	cVZoVnszwV9APPa3FlRsx4g9b7XhgPZvPyK/4k8hc6DoyVjCcWmVnRnexVGbnnyrQ2HcPL
	BEPzPy3P6xZ4aLPdbX4p0b/VnbjzoO0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fwqMbPWY;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776780913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sBspbL/u+4h/YiAyL1HV/VPAyarYaOL540HM7IEPE4s=;
	b=fwqMbPWYt0XXocvEMl1w6f2nwVLeXi8x4Vq3k7VbhE5Gfw+uJLKjmZaFa+TemG8/i3/40d
	hIUhT9/ZLPbFNgrXfRG6il/FXb6jh2ee7BfbtUp7GRFBySbw7fNVKilfBMEQWgbMrtL8km
	RuITDcAaZM5/F60H237YXIPivgIbOF0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-0r-oGSvPPM6lIMMWg1ArDQ-1; Tue, 21 Apr 2026 10:15:09 -0400
X-MC-Unique: 0r-oGSvPPM6lIMMWg1ArDQ-1
X-Mimecast-MFC-AGG-ID: 0r-oGSvPPM6lIMMWg1ArDQ_1776780908
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488c2cc0cbaso28618375e9.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776780908; x=1777385708;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sBspbL/u+4h/YiAyL1HV/VPAyarYaOL540HM7IEPE4s=;
        b=IHzhrRbXyBYogJLV2Yt67XNsoB7UmA2MqO/sXj3GjrB4intdPLcMzbqp28l7LMOQiI
         dxWf823PR1JN3Q/gvT4+NWfxgn2UpmFlpqqJaHHWut45mn5zzCY8ZftuVjRvVnq0akGC
         UtiyjhyrYrxOofrlKSsiTbBy72SUqNQISUYABVx1E4kQ8HWmEUpH961J8iBarz0QN1cs
         0o2HuCVQ3XafM00uyoZBD6Z6pLTO2+XGCS5oIbdj15feFCzzgifhXByKbgEYn5VNs+dB
         zNHnGvQVQoioSMN0hGzdQ4mkyRBaM4Z3ePtmt/tyTpRAGhtenI9+O4vld5glwblH2lUi
         gwDQ==
X-Forwarded-Encrypted: i=1; AFNElJ/8MXPJk22keUcKO1RRCdHVv8VZ6BoryklIyS2TmWG1kM+Kc7FBUSkklMu5X1+Q3MdgsGXQNEqYNQ==@kvack.org
X-Gm-Message-State: AOJu0YxQZht3JzX9NN+n1q3lGJionqOBzveoAVBahnhU/m23T3cqaX6F
	UA95KdJvEBUSMRWdntNZsMiLituCrl7plOFyd1dIwxUGLpsHUX2o4xRVXUSZwsaqZDlvGoAFS0J
	xNjc0chVvDZ1S9Gh6eWCYid66RwdoPOqhu/A8Iwj9Mus/AHEF4JQP
X-Gm-Gg: AeBDiet3K0+M4vG/6ag2OXWQ7U5rQYKZ2sGuW6xt5iGqBp1s64UaA64XhxL+9KihTII
	jiFh9OhIl1zP5aezpCz8DP4ceOfhK4T6q+kPJHLcsrcYveqaDZ3N1+ZuVoraJoZy5wHXkcLcW8W
	gJ7y87YAVODGyeJ9vR6JcIH2sVGiPRSl93SNuqIYnkbUxcvhLZv0ra9oiJxBwZS6hPgv8Xwh4X1
	EcOrD5j+JzYTgMhzxNLVRjZowMAb3U4r0f0TQW5MXAXERZEazf0MAgGBNZCkMUfol2iAAK7kUpu
	M7e/PgmfC1qGLBP9jIhzxMRcGwBkzziEugvLRMkNgrBgvUITWnTxdmqRSEeIPycwSvDA6zoxqRr
	Pl3aEZPwzE1NAUKh3gjAnkTtuNWiP7nSyL/t12wiBbiBGWpnI+1yzsg==
X-Received: by 2002:a05:600c:3b11:b0:48a:525b:e148 with SMTP id 5b1f17b1804b1-48a525be2f8mr82580075e9.4.1776780908057;
        Tue, 21 Apr 2026 07:15:08 -0700 (PDT)
X-Received: by 2002:a05:600c:3b11:b0:48a:525b:e148 with SMTP id 5b1f17b1804b1-48a525be2f8mr82579225e9.4.1776780907341;
        Tue, 21 Apr 2026 07:15:07 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb796ea2sm166370405e9.7.2026.04.21.07.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 07:15:06 -0700 (PDT)
Date: Tue, 21 Apr 2026 10:15:03 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
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
Message-ID: <20260421101409-mutt-send-email-mst@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
 <20260420192037-mutt-send-email-mst@kernel.org>
 <aebjG-qMLr0joG61@gourry-fedora-PF4VCD3F>
 <0bb2d565-4b3e-4b0b-8e81-57898d8a2a21@kernel.org>
MIME-Version: 1.0
In-Reply-To: <0bb2d565-4b3e-4b0b-8e81-57898d8a2a21@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -9tKFGzRwsaz0B08D3Y0nqUOBRJ4ZzlfBiAotEZfUi8_1776780908
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: uuprf4irxb6fuq6p4z7yzedfz58qbbee
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BC4E180007
X-Rspamd-Server: rspam05
X-HE-Tag: 1776780913-193581
X-HE-Meta: U2FsdGVkX1/bbpmkugj74JWo63GIYWFIIbWhYrZpz2D/8UTrV3g1DaDybIDaGqejsjNSFXWvqD7x5AlNgX8arxuDdLmeTQpDULt4GadaETURAHFUkNmSbhqwkkHzH5XOzCCOjiFhQi/RlZsyLaUZcoToujRrUnQvScK3RYMN3LKo8NNc40RM8SV0KC/8+p86Zl6GyvbWNJQmeWj13xNwRrhYlybW5/kXKX/jvzR1ZJYkXgG9BjI6dZIfjhIcOs0Nmgsi2lTU0w1Sso9G2+5B+J7jkbXE0f1NhaeeEbMFCdM3LsgkJw/9IZuM2njVgkrRwq4JBlWJBsuDXbTEqKxQbT8M5aGwwuvT8HeyE/jYegoa6bFgviLFUuJzHLecv82sM+2035HxNxMkdN/N37PMiW663iR8HcbxSKKEkNm5W4DqEwn5lB+6gKqhNwO4l90xmbr3/Q9h+fbbyUTwr8K10FfCmYISe379Jo63RDeZhWu4VbRYN5LKPTFxWchzWFh2GsU2aV3FK14eJ7qQIE0HMz8JB50y/5HwJ1I3IzAnfflZCesFaMz4IhXdj+pzP9o4HmTcnIVjmgrUsx652xsFrJO9eIWM8onpYGUqt/KjMqThz6/Foy8qWhjPs/ENQMMeVXCW5La4FK+D6sldHBHB+rQh/ZRudc/b+XRjXXXNBwp0QYmKnBEnkOcPd6Jz5VxItubNTk9YvL0eWWdmknftIpmwuZKa+puPABwZHdLoB8+dWn7gh9m8FSYdZohKzJwSkbMW/tUaLqbBj6obUlPN0wVpJS4JG9fBuBbxP6hcyDsTB1lKTZ1adoc1ZRJyvRfpXcgS/fKP76zmWsKlCl+VS4M2V40AD7iIT39zC03qYQQQcScDACzdFA8Sqe1ysz+JTspfWQx0xOwllHHp2MVktnfzt1mXfLAtZr/t1oVvCVInXssbSc2JUfosjYDlwdfIoCZfh/WP5o0s0FdpVgO
 TIuuRYWd
 L43IA7Kl4LAF3ffGAZzbpoeQKV894khphOYZFe2ACXgXIh4qP1xv+KUynsnlKcq6x8C2J0IrZ+6T+cSoGbAuLDhfFMwjAR7VtCzZD61pUEDku3AjRNpmhMjbjl8gpqkfXLeVvgu98saWScUdRAKwhuk7nZtdPoUiuM0fSvvWTrlpeTZNYWmctpjkxfDyfXQa3EoBX5Y3yRL5ZxO+Ark4A8nC9b3DAxz3Tv7DGRDdF1Miw3oeAstl72izPiHOp9P+gBepP/1CtAQb6awnvo5oJRhDxaIwq6m487BTt098mbd+0ctKgCKGG17nMK+WfsTiDEecFHDNwJqlqvx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 12:04:49PM +0200, David Hildenbrand (Arm) wrote:
> On 4/21/26 04:38, Gregory Price wrote:
> > On Mon, Apr 20, 2026 at 07:33:38PM -0400, Michael S. Tsirkin wrote:
> >> On Mon, Apr 20, 2026 at 08:20:57PM +0200, David Hildenbrand (Arm) wrote:
> >>
> >>>
> >>> Which would *already* be the case of you use folio_alloc(GFP_ZERO)
> >>> instead of magical vma_alloc_folio() + folio_zero_user().
> >>>
> >>> I don't really see how vma_alloc_folio_hints() -- that also consumes the
> >>> address -- is any better in that regard?
> >>
> >> By itself, it is not. But the issue is propagating the address from
> >> there all over mm. If we miss even one place - we get a subtle cache
> >> corruption on non x86.
> >>
> > 
> > Why does it need to propogate?
> > 
> > Can we leave folio_zero_user() callers the same, but add a PG_zeroed
> > check in folio_zero_user() that skips the zeroing (but not the cache
> > flush) and clear the PG_zeroed bit?
> 
> folio_zero_user() is just an abomination, really.

We can't completely replace it with GFP_ZERO though e.g. because hugetlbfs
has its own pool and needs to zero that.

> -- 
> Cheers,
> 
> David


