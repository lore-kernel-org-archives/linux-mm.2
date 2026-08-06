Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB74C5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69ED96B0088; Thu,  6 Aug 2026 18:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F016B008A; Thu,  6 Aug 2026 18:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F436B0092; Thu,  6 Aug 2026 18:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C71F6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:45:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C56BA0622
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:45:39 +0000 (UTC)
X-FDA: 85072327998.25.8D2811B
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 68AD080002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:45:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jtwu2ws8;
	spf=pass (imf02.hostedemail.com: domain of linkl@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786056337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6JgVqkbmtz5NpnUIHvX9HoVnvdw6c/HMcKh98oiDnA=;
	b=lAi2rIiQ7B9bSOLifxA2kARJgsHcCcSoEIzm/U0sRkQwPxaZJur9Ehha8FYluPGnF8gj2T
	OUoc7r9/z9XFItC67r/cHVQVPgeSJZJP2J1TXcR3m6ReV0Uxz2/tE7G+ppAWx+c6NuGdvf
	JbqbBE0YKU1FFJP5gvPM2243776Gdic=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786056337;
	b=WMFgJEn/J25dwTx3tXRh2GllfV3UzFeIKTMyjJl4ZJENGC7j58W3+ys/UlyaQVecLL/Awy
	hlPsGgtrp7/xgW3msAvQXgCq6bN9O4oK6rrcE023UDbWKAtI1HiOyx9UtTcELiQgEuevbu
	rLFnpV2ETY96bWzcnhps8YhC9J8cxbA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jtwu2ws8;
	spf=pass (imf02.hostedemail.com: domain of linkl@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c01c79467so94001cf.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:45:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786056336; cv=none;
        d=google.com; s=arc-20260327;
        b=UkGZk9WtEM+gbH0gC4YVLHKRVpHTe6nyGEDy0+vXbDuxzoHZryv60+gc+iF171rJul
         CkZUfqhyfH3bl4ZRzX19CZzoVONvw0BIEQInyMnAF9H0riPWqk6EqPV1fp8ysY1Sduuw
         Ef1iqE5ojoC4Hu/+/hLFlNp3OUoE34P/OOB4HsykGMHj1CnYBefYRMVXVQ5mviy0Xvp3
         YnTZoSHrqBFM1W8eVJdqAtLqtgaCJuUNbxwpL6T/RCemF5O/k792AZ1VYg3imk5XoBDR
         hHYrl305hGFxOoIF4fWpHIsTkg5LYvcANAY0T9rOR9bTMphA6Ld3E5MD1qa0OF7j2ycl
         3XGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t6JgVqkbmtz5NpnUIHvX9HoVnvdw6c/HMcKh98oiDnA=;
        fh=tmvCigOTj7L4Cm3JbYGh5nfBe+wOU5fiREfYITww/V0=;
        b=AczXR9zkN/JyGlqKPJpLNxbFU0+Vgq2R6KoeoPbYKNX5FNnYUs0h8zduqLgPVGiQ8Z
         IruadKR2E6Y+MU4dkp87EgJDYLhj//Xch8yHmgZnLLp1FauYDdeCpMwdW/hxbcR+pK7t
         5UlxPdMor7K/KAABiJDO1hKBK+o6yH60Z6+uYksk+AVUCcw8Fndt1Mijr4RMVDx3Ludr
         BRKne6Yj6XASFGItBwLZUcMhCn6e75rVA+vaFBQu5Vc8mSim7jmsJAquMLdlcaeFHTE4
         QF3swjc/OYFvaJSwX5XG2lzX4jdujZSIYV4FD9Iel65e1qd7/9hlnzT9kYC4Ek0hGDKG
         EJcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786056336; x=1786661136; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t6JgVqkbmtz5NpnUIHvX9HoVnvdw6c/HMcKh98oiDnA=;
        b=Jtwu2ws8yPpt5fHN+3tdHCNraZsiNUgyOOjelvF50xZbW0J4IXQwvQyBzz9EaqiJ/c
         Bhq7rqKv2tiGCVQ4JmYqO0yvna3We07/jP4SwEQsgMzYQRkHXPqEDgzqqcxoITvy6tdt
         TyDwh4mqj+3DS13KmKdywEueiB485JWjSj/LljReGUMtuRvUacljgAOX1Zoj1FsxkTUd
         kUegX86ct0C6Ixpip5jGSXfgxaUEmaP74UiHtON0OsgGouxF1HCt3OEnsDH865ktyAvw
         OhXS0A6GhUBuTRfOoKAsu9V/pQ8QfLlvnxgtTyp3z+1jzR5w4njGPw63sWR48JO1Thzu
         6YGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786056336; x=1786661136;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t6JgVqkbmtz5NpnUIHvX9HoVnvdw6c/HMcKh98oiDnA=;
        b=KH3p2qh0e5Gn3JA2WJvdcfBBfTvORR1bT4BJT/tN6YjVKAYEdclpOTYx1LKNS18JPZ
         5Lg3y0T+aaxrqxcpGMDBJYLr7ZSBKuMlRuBR62BymrQ0PPa2YhYl4ymEpdFp8r43D4jC
         /lX9tXFerf7bZDVEecLTKCR2pXx0ZNCjNHUfCoS3XLHB7/YJH/jKWNJ0vKofBENGWHiQ
         OivRCm8WHUoFbPfJaIUiOoHjLQEMnzZv6z7vjVhB+NUwoE96SozFOzo3mShsDcsg5Akt
         0TGE1stWXzg174FV0irIRC0Llf9Wp04WUbXHiRRdxa0zwcuf4k60qf5RjIg38tHWbTtM
         7Rfw==
X-Forwarded-Encrypted: i=1; AHgh+RrTzQFijfzfAEguYOYaBtSpV4EejbMuIT3wTgolpCGXTSn1l1Sl3fwyMdmzjG61Z9A/KL4ArHZEgA==@kvack.org
X-Gm-Message-State: AOJu0YxYFwI9vEKlxUBD8uYEE2CdzCux7hx4NmUuqTTqsepr+O31wGjR
	EsmlHp0+L2zjuEiJ+m7/nLI0nXXBjuldxNYZZFylFfXD0rVAPyG/1ZYi7cEs5fz6nl247aEpxxz
	+CtASPj3T3/PtTLtgYnxRnA5LicN1YbWn8YyXq34L
X-Gm-Gg: AR+sD13ZnmjQg6rYCzGVq5QSLuUv8XfWWPQIkwEoMlzlFoQ0rLurkZVsI3U2BIDvQek
	tDxp085g57DeVfdJeESI48kQy6ZUhNLxy3k/IzN4AIglt3DzVTjQvKHxWf1Kc2Pg495a0Gij14W
	KobOmIQj5uLLDkGgjIKuc5xAt8keDWSsapB7dcvlM7xAir1W7NqwWBoUNWP56idi8GYDliNfHom
	gHju3caV8O8Q8lVzRavw1kwp/k1QdJ7kvgIPDl+/eQo7r7aG3bVNIreJnuBl+P3p4P7VqkI/61Y
	nTEFUod65RQmRoZc6LlIB9vUHpIJez3j23QjEF087oOn6xGCZpr9JXGMGFhTQWwZmj0U2Hz6xKo
	=
X-Received: by 2002:ac8:5893:0:b0:51c:104c:100c with SMTP id
 d75a77b69052e-52d106def12mr5018131cf.2.1786056335879; Thu, 06 Aug 2026
 15:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260724014605.3377283-1-linkl@google.com> <CALUx4KQfyRgG3ewQZMuU4+AMCyrh8+rH=-MOZLBv29PbPcnhYA@mail.gmail.com>
In-Reply-To: <CALUx4KQfyRgG3ewQZMuU4+AMCyrh8+rH=-MOZLBv29PbPcnhYA@mail.gmail.com>
From: Link Lin <linkl@google.com>
Date: Thu, 6 Aug 2026 15:45:25 -0700
X-Gm-Features: AUfX_myMFV1qJfbDkK0lr2_rAcEPde0PqT3TobQKcsNUoc9XJsFqir-koEVr8yU
Message-ID: <CALUx4KS-xRf7m3jPDN5BKfFrpbojp9+0czRp5-siFed-Jj1G1A@mail.gmail.com>
Subject: Re: [RFC PATCH] virtio_balloon: add VIRTIO_BALLOON_F_REPORTING_PM_SAFE
 feature bit
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org, Cory Maccarrone <maccarro@google.com>, 
	Taylor Scanlon <tayy@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68AD080002
X-Stat-Signature: 66h8wj9jpp94a4bbkh6g5mfntf5bkpf6
X-HE-Tag: 1786056337-946992
X-HE-Meta: U2FsdGVkX18FtG1YEbedBOH8mn9xUtRrPtKn9e2/4AWo7pGn1jNCnOUQOqcPm1txZ1IHTTF/MIV1ISDea7Z2/0OSy+rMGRatytVCZHTsKlA6WJsxh7Yh5XlEjXd9RWlHx04S8M0LBUpjChn1Ixap+oSqcb8SxGWDYjFHeoG+aSo9jreCerj6sJGSFgDThfckoqDkrfUlq1IkkzJfyhqs0hz0E8NdlvZXdOybJI34GSCmaAr8jZIIHH1HpzvTPXyh/86JYWxIQ2wJoMLpM2WHnok0x20cbxeUXDPRrWTKHs5JPCOLkMzV0WjlOTI/MbEwZis7T3nQ3UKXfkXf07bvK/7p0Q8s94hIVtDi2J+zgC/DIHHWdE76L5UKeGtyzGwAMs4jNm0EpVh8Me+IR8v7C5ZE/KsbLSVpBSJfXH8gUJR9rQVI4TIX5WSCd1tTSGTH9KbBMuEo6qaT506JrttpITaUc67XMaBpgtvQ+kETv3lcSisSfxN+R9kRabf7wATGMiv4nPxwgz3hc5VQTZz/cwaIFFlOTA/9av2cA8C9432BGf+QNJJF1BfKJlvxiGQm22MSkHX3byDm4RMKgGXVMFoSBT0Iu1db3EWsqzsm5LNBjKW40A0V2AYkDVTTWSPw7GijvVnqI9QQASq291CJW0ewzXmEb6dYn94DPYJL781HzBdxshJbqG7fFlZJ+NgQUR9cNaGJRzvTvDebVnGlnUbJQjtnBWKVumw+1WkaYee0M5ODNvxfKv+G82HXtRh5GO3k2l7snMOVY45iL/ylJP5BG0OHNfH4TaPY91qinuMEEGPxaFnIEp5lpy2UkeVOXGogUWU78xsmssEIT+yrmby1vtkpX7ADUPPr15stGWL1gyV/nH2JqcuclYddjY7MmdQMcnfGoQVRt5cJV0rX1td8L+rdqbSgOqRCAzkcUiJYP7gSprVEhGhMjjHSrHernq7R23jLid+D69RnA2p
 WijEi9uH
 j7MwHdVqBFdTY6Jk2YVTlkSEGNm2mNtPbo3Q8tdZklQ5HrQht567Rs4bp2OyX2sX9jPAeE4hM2DBzFJYx3ix8DjJAR+mIE0YZpsJ9OD513ARa7kK/BhiljC/FSIA+0GiQKWiR39QKKYJtLu7LGUtYHD+5uc27gLYSWCAqDgG7g0fMbXRVL1h+0EMoqOfxuk7m2dj0ByoXarV3qTFZ5+i/2QwGichvDyHpuSHOfpe3F7BXXM4r8kxReVlU8NxQSV5ScjeBPCb746ojJShUfl6BPyVLPPBVuQH46PdAwpxevms25PaSXZ5CylYHptWlbAt4YTPpGnw+wI49bW72nX+fY4HNr0DQuFmipdEhnFfoWw4oTE3v8btoyzP/8ROrKw+AgNjx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Following up on this RFC to see if anyone has had a chance to look it over.

We'd appreciate any high-level feedback on whether using a dedicated featur=
e
bit (or a similar protocol-level handshake) is a viable path forward for
safe hypervisor deployment, or if there is an alternative approach the
maintainers would prefer.

Thanks,
Link


On Wed, Jul 29, 2026 at 7:52=E2=80=AFPM Link Lin <linkl@google.com> wrote:
>
> Hi all,
>
> Friendly ping on this RFC.
>
> We'd love your feedback on whether using a new feature bit
> (VIRTIO_BALLOON_F_REPORTING_PM_SAFE) to negotiate PM suspend safety is
> acceptable, or if you have concerns about protocol-level handshakes for
> kernel PM fix states.
>
> If you prefer an alternative approach for safe fleet deployment, please l=
et
> us know. Thank you!
>
> Sincerely,
> Link

