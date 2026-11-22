Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C987C606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=egtv4N6Y
Received: by kanga.kvack.org (Postfix)
	id D9C406B00EF; Sat, 21 Nov 2026 22:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4CDF6B05B0; Sat, 21 Nov 2026 22:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B636B05B5; Sat, 21 Nov 2026 22:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 999D16B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:42:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A78F1605FF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:42:10 +0000 (UTC)
X-FDA: 85461356820.19.2E26196
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4481440004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:42:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=egtv4N6Y;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795318928;
	b=Ho6jYITyoAavuYlRF1uwC4jDgh6fgd4oGAmIlfUY6wyno35FTyuGNi8dxGk957NAWHKLLN
	qA+u5400TLuqcRAatMXtU/z30InEG7MF+a3giG06u3QWERrLSYllruaFrzW6uWft+7rdfs
	q5K+dCONJKmbR5B4oJ+lmpkpZ0kt7z0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795318928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c45EPQcbmQIFYPGkXIL0CwCOiwuT0HfkEVcRKYI+NUw=;
	b=Q1c541u5Ly7ZgKz5/NAjZlq606kMsZaNN7PBjmgnz+LX1RDXa+/s/hckefIKxu1AhtKBAp
	gBDiVjh6Q/D5GWRsTBr2pSk3WduI7J2y3s8i+afZFVFFXezuAX/3EtN9hLlnEeM17oQEE6
	c4POLX+AZOhh+KhOMy5aLB/Hr87GB4U=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=egtv4N6Y;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-54492d8a988so215531cf.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:42:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795318927; cv=none;
        d=google.com; s=arc-20260327;
        b=AQ4SAgygALJryGXgnFCfLlRTvHxEoYAQYN5OCcjzyD6DThz46MRhugPVqPtsLTupAi
         EacPdRgtS7V1qjvHydiIGp6dcqDsvdAQsneBLEaY2y4c09nXTyC2FKdnmG7wWJET7Jw3
         Fr7UQTMSL78d6JzDwQ70Y/+tSAC5uupxMwAJHInzrLMPLWCUrz9s6W9c/5USV4Rx+zup
         7yrEpQ8aCKcHmeu6ZH8zHcrkhXZYI2lkAQxguTLnZ/6udtTC0jP6OkZwV1+wC2AEIe33
         yaBpEs8rAeaU7aGS3IAAf1QLYvDJ5OyQaVgXcANgjes9p/DrO1hvQZYU/0YUMyRdQqz8
         o6nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c45EPQcbmQIFYPGkXIL0CwCOiwuT0HfkEVcRKYI+NUw=;
        fh=qPBtEwRXNs1YUEwBG+2k4+3P0cNIAczVsqHr+itZ748=;
        b=g35rC6DYzttZSupzNMWpYSde4SHWa20ZBpjI/1lzEzy5YJmvP8mwJ12etwZxG/UGn8
         m4uyolDjPzM5xKd0BmDDWPys5Szwcmw8DlbUDSFsFQp8rdHkUUZQd1OhmrtQyTXRSOp0
         ryu2BFOKhEUWvHvCyb8JJyC8xStu/GalVghj/Rtyw/8Oxdnp8e9RswUt4rF7DY1tfJNt
         sIvWAIW0/Sc3c81u5TYcYfEJH+6fNW3Q0/BKr4sEDnMz/X5H45F96kyy2UeJDqWf0RNE
         LQHl9G7r4mWX3f9hHNdVsOUHxoxDZwe8wTQb5jRdHf1HWOve2udHFfkLBZNskgbkAMlF
         /dvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795318927; x=1795923727; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c45EPQcbmQIFYPGkXIL0CwCOiwuT0HfkEVcRKYI+NUw=;
        b=egtv4N6YxIY7rgC60F7O2OJnVeWkhhBQm9y4ytvX90ebXGS1tEYn+d2fuOsMNP+4ZR
         Wj7o3fQfoKU/p7Q53WtzhKQ7aIepxWnly6hyOqr5DNtqAtLCNJzddyLND7yKG0AlUYhz
         VAsBo4hV6BQQ2otuG2cfYmEGSJAYzhVCw8/gj3jauanC6kyFcUnHkRFhcp2UUHuB/sP8
         g0gBpwgHPGjGanNKZTmgptuHhF2qdYz7+wSNWPc3At2ucHDwjfyWDy34XGn2oe4u/Ruk
         tf5rtiC53mCD5T9tN6LB6VMtM8dI4WCJO3pKghqtHJsxp/B2UQFcZOBpXrVy15UuxU69
         H5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795318927; x=1795923727;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c45EPQcbmQIFYPGkXIL0CwCOiwuT0HfkEVcRKYI+NUw=;
        b=hg3R5kSQ7P8Rwj6sxTxHddCjp6aEt/MIoIw3N/9urSwBx2hGzv3BnAHR7kdI21qwMp
         Oyc+xRxGXDw5EbispCkDhySK3uXfCt87zBA3kRlefTmIb2Z8QOiNPHS1EFAUAzgRjwj2
         TkhJOo15IptcDfgN48OFhPuETqMhdpptil/4zqeTij2VXbrssfd098dl4nQFkDNHBG8Q
         QMbeildetdHBL7stvdAraxxODaoa6F1WG6ZoIlmtq3ow0YSgxmqyZkzsTRcmmzuHhs/B
         HRHbtAQ4sYPn+3Y7IzOFlqWQPxCqWqBKHg47xvisIe2PrWYrr8PGitV3LhbMKRk3n5rZ
         cN2Q==
X-Forwarded-Encrypted: i=1; AL+hErEWI82hwzVLwIUFBKdlUW30StYhlTScHZPQ5IXKfD2vLRhVnCkPh5A1cnwAvfNnDic9HLBRCmxeHQ==@kvack.org
X-Gm-Message-State: APuU4Z/NgIJsYQxv+ocnvM90qs+7HiNe5/fK1Do6aUVX8hhaUVcAVmnq
	F/58buq0BY0CzScKWy8IORs/Y5qpeUyF/XkiYivgFJJTB2jJVbsFVPOVfPF9hqu7DfU5rHNRVLE
	8tGxhZ5WqPR3oEo0Y4YC6Ab1AydPfR5O7jZqEVLox
X-Gm-Gg: AZFdTZfYwMiDPwrzzts2F276xjN3i1IB0+V08tftXkR9lUWFEQgod+qWmGzOdu5tJZx
	bp2UnmgA4fXC2rCBjkIKcqFj1SDN7VZCOIc8MoWLsf9aV0MXjog7EzqV4g2483KK1dTP3WliBaT
	4FEkOo99G2MTdRK57Clt0IkG9rDQaAbKZzwQ5++v4CHysz62FhJSy04KhTeQwDUvn+xWXZDH7iz
	uZFBsZhrQYZ0a4vcS6rutReygMKXJ7Hu5ovx759B6ksrQHzJz9mgvrJzlvOZOLAHfajpxV9A0Ee
	tbEw8sw9XHP67hUdPEIG9GC5mFXg6BXIkFpa+FIZ/8bM2ld7/+UQF6iL6yZlrJ3QFf/B4MWz8DW
	AsLk7/TrXpiqOhCzrAoqzUPmi97KfFOq3r4EwhVftPcutMSFhPi/wugDqtI6IC0gT9hR6LfM=
X-Received: by 2002:a05:622a:c15:b0:530:e335:4ef with SMTP id
 d75a77b69052e-55d88014944mr19193131cf.2.1795318926848; Sat, 21 Nov 2026
 19:42:06 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org> <20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 19:41:56 -0800
X-Gm-Features: Aa3M54p22wLexZAqgWrgrNgpAaeLioT17WYmqt6szdyg8MKz9U8vecc7bPDpR1o
Message-ID: <CAJuCfpG2hkhYM7P3E1k=VhRPaa=WPe6XRfdDB+ZZjYteWogV7g@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm/mremap: respect guard gaps on in-place expansion
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ollie Wild <aaw@google.com>, 
	Adrian Bunk <bunk@stusta.de>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4481440004
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: bxu6g31cp13fy39huc13o5bcdwk79tnp
X-Rspam-User:
X-HE-Tag: 1795318928-508312
X-HE-Meta: U2FsdGVkX18I2dcyW0mAtkRVX4DQICCbX1bxiix+Z5cQN6dEdrlIIr8sxwnx4JntygF2dZRx+DGPrToxjRSWP/3Qorac+N1lGm6qx+eEOyuaExP987lnw1SVB39SHx36dgr9ddP1FSldX7sUrlUvq8ZccFFmJi5z39YbBp17RXFMMrhyJAulWxE2NEPiXNqlcrYtErE+UPPFFqfTJGWAi+YI5M922RBJ4BUzUEsyAJc6umrqXN/csuq8SN3jF/1EJdT1cPsk1u/BEzP+X+5T07V2yTpQ495QmjdGC/tmjOadPi/2zI6/XC4K6N2sh6b6Y+Ck6mV3nC619MQfmBQBIZ4T/aOfQpd3bURuhDbOI8c8356v9ukYxGLAHcCOC8IWMPzrVLTbSCGo6OXmj3Dj0pDOc6J7Waufh+j3j03U4qggqiu2KiEB4KYhe25jpJzHdmUF4CaDzn27DSudj23SZJ3DLhmcKlrPEcphvT8m9fI6UiLWcHgfi/Pe2rEHELyBODFvGidiZd3l2Lbz0hz5qzCoXRSuyRvf5oQgGnXpV+cxA+oWQ+aFPvTpVuabOqGx89zYd9rp2YqG3ScUdnsBzaqbtoc0/uBwkf7N6b6muCsRbzizKpoMsaw30aIeVW23wADughqtoyBYPm0AKcdv7iaLSvecQc6dp8MBVKlgO6TwBF7WhtPO6XOD+0ySsHU2cn72y1KwXt6eLpP1CpzeG6iL/wYXBKpaTamYyI+fW87cexo/yoYFSPf77JMgcNxIKxlmC1jhTjGPx+oqoiGiuBd2+s+PQQNGJ7vHcTF8LAKeMk/jugJ6vcJ99eBNPmTMJAWQ11/vBfJ0ayUyM+wiksmrfzfJfoIfMoux8H7CkM2cVG4+nuGXXSied5ppsFTGOK+9trmCkxpFHQfbKUq0EV2GPmpYrobsQ+qvYdyV64Yt+/7EmXczUl1c0dE+I6TDkaQB49e+GW+XB1RLdf6
 OUP2gaUj
 39cQsEZSgjJl3Lwg9NSlcTC4c8zq8CqVdtzv9j6RkgLKIMPK427xTUtoVTvunX5CnJkjPuSFDZHmZAmqNMLqlH7MoRmyjtuc9jLJhT/iuuOdZUvukS1nL+yM0+5Rc4P9xVSvl8SjL1qVJb64A5qtVFoLc3N4oHVo0/hKl88jA7UbpGFxm8+jgA2mQNtQquKrk+GxrWIaIIaTHpR+PhqlevvQJM/Gn/nwDapZj/ELS4DFi6eWcgKfia7Q01zHkMESGXow93g5adLPrDdrhmh6iVdhlckBZ/Km4fZPYdlgzdwfYtAN3o/7uhkZ3v9h7IPRBaOxdGsixiTj6XWmYdq98MWL27QfXB5okAjQo2nTlpq8AWau7/JrmDdzBmMLzl0rwhU8j+YnM3LhLtTENGMG8z9xV1ExQ8mBwLlD7ZS9OmKzgKo0k6+kqvY7o23PIRM0WCWa0khshFPnBWKkf4B1hZ6xtYDQfSSgU2h+NBlYIrjuBnraG5YV5cnDJO84GHUvy23Ed
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 8:03=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> From: Chris Mason <mason@kernel.org>
>
> Growing a mapping in place can let it use up the guard gap below a
> stack, so that the stack can't grow any further, or overflows into the
> mapping instead of faulting.
>
> A mapping has to stay out of the gap of the next VMA unless the caller
> fixed its address. But vma_expandable() only checks that the new range
> doesn't intersect the next VMA, and it passes MAP_FIXED to
> get_unmapped_area(), which skips the gap check there.
>
> Fix the issue by stopping in-place growth at the start of the gap.
>
> Growing a mapping into or within the gap of a stack or shadow stack now
> fails with ENOMEM without MREMAP_MAYMOVE, or if the mapping can't be
> moved.
>
> Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
> Signed-off-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/mremap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 8043c425b5df..2460f9421a13 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1552,10 +1552,12 @@ static unsigned long mremap_to(struct vma_remap_s=
truct *vrm)
>  static int vma_expandable(struct vm_area_struct *vma, unsigned long delt=
a)
>  {
>         unsigned long end =3D vma->vm_end + delta;
> +       struct vm_area_struct *next;
>
>         if (end < vma->vm_end) /* overflow */
>                 return 0;
> -       if (find_vma_intersection(vma->vm_mm, vma->vm_end, end))
> +       next =3D find_vma(vma->vm_mm, vma->vm_end);
> +       if (next && end > vm_start_gap(next)) /* intersection, or in its =
gap */
>                 return 0;
>         if (get_unmapped_area(NULL, vma->vm_start, end - vma->vm_start,
>                               0, MAP_FIXED) & ~PAGE_MASK)
>
> --
> 2.56.0
>

