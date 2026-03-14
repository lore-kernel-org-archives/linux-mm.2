Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE06107BCF2
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 02:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8286B0088; Fri, 13 Mar 2026 22:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95106B0089; Fri, 13 Mar 2026 22:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97D36B008A; Fri, 13 Mar 2026 22:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99C156B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:36:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 506778B672
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 02:36:09 +0000 (UTC)
X-FDA: 84543104058.20.635F81A
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6A1AC40010
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 02:36:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YUeaDf8E;
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773455767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cO20WwNIzRxyw30z6OHFbWFRxuc4T5ngZ3OGaMZkebE=;
	b=N3iVcSebQnHA0oiOcaNnxym/0SPIeyis9uE4pjFjbEylC2Quh0ddrWabbFqkw4xA9IvhGD
	gZi+oam51gdJ7csH4X0veMPQHrzLA+lh2aiZjqwC9CXIsomAzr7UI3eVxTO7lyu74On2PD
	THAVhvnPKfC2+xtumnLe/cCpejGGXEg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773455767; a=rsa-sha256;
	cv=pass;
	b=U2QwRIdTdt76Z5F8bN4WymQPbhcpHtefsnqPOrC77LOtHQS5z5j72U/E2KSvcbdI1D69OZ
	b+QpiMTO1XeFlLKttxoeb/EPtxcqKeMvLLyQhAnGK/0p5o4VaWOOZAboBqtkIL6jxM//PC
	74dUnb+5BPHd+ZfCiqoJqGMYYCkJgPU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YUeaDf8E;
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64ca9ec3ee7so3488389d50.3
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:36:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773455766; cv=none;
        d=google.com; s=arc-20240605;
        b=aJDUICAdZ+xYdNmrvsIYiqhtM6iLhRsm+CQe1W5zyC5THcLvN4WAsOmKai3U2P8ukA
         tvjLFP5lHtXLHpQ9HKp5HZnMy+kv4nRXwNgraVgkeU29VDmz5TV3KOdCitCwbw9M5P2F
         G2nb/CRWNLuznrbST2BEmQKWabEkoMti9ehMNSlHgnms1BlPoA1pxZo6/Mpmc/FuXNk/
         Fr2ajuPpKTnDSnZHimIQUcV4LK1DkK48ekDhVuBlwI2dp7hwKS8YAYjfmZXQi8hyvd1g
         ydFX/hsDR6Ehv6SQDQAbRO6mTu99rWvOEe8bvR/XsXGhQXC4w2CJqAXui2Ub8LDuLILL
         c5vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cO20WwNIzRxyw30z6OHFbWFRxuc4T5ngZ3OGaMZkebE=;
        fh=3n7fk7Nj04Yy2riL/dZO/LsBXcIKxllmt+7jbaiYBgc=;
        b=CvS9VjH1VUqf1yppAIWeZffnyXA61IeDKpgcpQjXm/yZ3qrdkJHYu+3UO2mutig7YR
         9m0Dg9NEUTNtHQf1BqLqfRzgEY3dfHg3JTYziYAjOlZRF1rD72cBnHvwz8OYwnE6krbu
         TzPuyuTbYbQ4Tc+T3WijU6I1LCiaOEncAsTHFqXcyuaLPOANo65IQReHmEhgvFCPXmvG
         c8yNez3TlGCXXC4PMJoNHtMJJEIC8TFriF/QiCT2k5sYiOMXfLPT+/zV89gCNzelnn0p
         ptYcWjWqDmLlrkX2If/YyDthfvWMXsUrszerUEJpXGGJcQ+/Hz+O1WO7t169o3p7Xo5R
         VHEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773455766; x=1774060566; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cO20WwNIzRxyw30z6OHFbWFRxuc4T5ngZ3OGaMZkebE=;
        b=YUeaDf8EEnnZD17l1XQb3Vs4DjyKeSmMtDhlZV8G7wKjeOlwCEcL1FRw0TIF+xyDNp
         0Cver/KnBrenBdojPddgnIkg1hwQHsUdDH7hdoxDxEp0zg/NZ/yZnY09XjJyvKxwj7cj
         NSqlncK7VLaG28Ttl+HnC1dr5x5cipZf1I3HnMWlKKrS1CbZZSkL6QRYJ/wbjvnbDfIA
         IaHaC6xRQMw9Or9YEztRD6K268H1zuk9GG5vAhzaFo2fNu+foBf2ZFj7/HWkkAbff8WP
         8so9FFkXixq6WrmjdUbSyTlYobOKM+EL2rjDlgF3yxKTrQU+4Vt10uhIlO8r7oSdxj/7
         Mu1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773455766; x=1774060566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cO20WwNIzRxyw30z6OHFbWFRxuc4T5ngZ3OGaMZkebE=;
        b=kBynAAUPE6sTqf9xzVEkAcNM4b8s9M0Cro4TD1eYjtVaCOcBpxi+XfDBTfLXBkQwzO
         KvtlxIqlY7q/H009bnHonZC6wvMoRDKfzd9FpdIS2WiDPIeqfto13RvlSvQuScj5izVN
         PL8CylJqsa8cRMBbvN4+Y72EnKaVzIwaMA9JlDCb/Rz81rGGnHqC1h+c4FEtWVGDP+kN
         HGLft11nOQBRRnA9vNkrNozzRUpLoRGvkt1NyhKkdDHXAf8+hg0oDsMmyFjU3CBYH/CO
         BksPoNY6z30F4BNi2bo2Qajx8NWLF8D2qLumAy/89PxPngjDewwDWNQfP7tJgymde2is
         QZ4w==
X-Gm-Message-State: AOJu0YxDLHniXtmIrMnAb8B0Ed6fB5RQpgfs8OggYsb3oYlVuot0ofwh
	hnzQ3PHxRvk9mDAd0TItusdweBR5CkLePnlb3GcPP5ncYdTqPIrQ4ZnIavHFbt6o09pz+5V/ChV
	wuGkSWuXSTKec0IjtdEAsYeq0cGizH9k=
X-Gm-Gg: ATEYQzxzJJBECfPF2D2myAVq2Wdah+i33liwXZ0s8zc+LbybgmeIe904Rwpa+EV0P4/
	+oykdHwdij7pgA/lO2sRMAFJq6nv0jhixTCn7dKD617PzOq2/YHpyqeCrDzMsrrOKbDMbe6cj8X
	GNeRg+ioDmPDlsgX/42scZiA5zDFdLYSyFICShLxTAR6O9t2z015qdwAplXteqMx7/EEga7HxoQ
	fyu4z5qQ5G2tpmYMJR1Nwetr8KH9sTEwFkzJXZ/i/gQRWcjAf7qsZfJX3VUbVy6RMcaQagdLy5g
	DOwhnR4zP2bXaW/ZpmphqQoMbbOdUI7U2NGMe94W
X-Received: by 2002:a53:eccf:0:b0:64a:d2bb:9072 with SMTP id
 956f58d0204a3-64e63073fe2mr4556761d50.53.1773455766429; Fri, 13 Mar 2026
 19:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260313110953.37465-1-aethernet65535@gmail.com> <20260314005131.80825-1-sj@kernel.org>
In-Reply-To: <20260314005131.80825-1-sj@kernel.org>
From: Liew Rui Yan <aethernet65535@gmail.com>
Date: Sat, 14 Mar 2026 10:35:55 +0800
X-Gm-Features: AaiRm50L5vc_CKwcot5sByL67vJTvKzPCCNWbVkzvFACfjuR90YpGehqhao9hbo
Message-ID: <CAPLv50pktuzn7s9zW8E+36Oinjj7HfGhD5YdOaC6hNE2+OBL=g@mail.gmail.com>
Subject: Re: [DAMON][Question] DAMON_STAT and DAMON_LRU_SORT module parameter conflict?
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A1AC40010
X-Stat-Signature: c5u14kssehdhzzborx1s99rifa9tyd8r
X-HE-Tag: 1773455767-201441
X-HE-Meta: U2FsdGVkX1+qe2MXrFrz8hAAuM+4s4KwAAG7gU6rLHWaVsl1tksi5MyXHIEJVYwQFPSlufdmDTGZrEK3GyBHBNCbn/O+fqIkx+n2CgDIkpE3oAS0XBnIdEbGObfnx2UZpuuLfGQjYSZoqcCUBbAJi+NVyi4auXiyID+WFQxwTSW6M4+WAfoVltt6G00lS/DfDWLssVhvRgWiUKnGKoxRYgTiG888f4/dGQwRLXjVyK3SCV4KUxvwdrwsyYN+0ir9TRCzPvR72n6B0cjyas51JSxEm7hMu/g4Ux7x2/Yz164MtDstHyCMVT1ln0vovX1giDyK0p07oQ4H7r8ZFiSif/PiiEPZfIz3XANbaJChQJMqaHc9YObnmGk7JJWJMJ39GIw/bBz8F2+d2jSoMYlIoP5vBfHYkYGMKTjTksyqBCQ4kcedpTyaXJUQBDTg9F9bCxRFEFFpHeEjEei5JxsUM6SrJRsmtO1HXhwIegXwJOXkzkRCK0u5Q60muYJqGt0AkGnE76ROh03e+0s95blfKuU62ZBEiFYchXsmy3vJQE8ZRxYN+b8jd/ropLkPLmKC96XusD7yEhdQnOMxpTGH9sH2LDj0uJHK/YmcGyCeoOyiJ12Hn4qgfjlG4BRZReGZocd+v/TX+1TrrMGTs4WLZ4TQJKFQ4KycmapbQbuQt4aqDzwFESb87y/CgVsRGPsQ6wNxOouMhCmkK2d1Q63rBxSygUDNPQqRNOqJwFwKoIbk0z6X9ECA1O0/HgMPzAL6yulxYsGDLf7QvkEQ5YxAm3eW1dEbv3JsakGxCsp5KdpMUVp9B21G6f1DVprcYGa+wD4u0eEOPT0URjuyNFOj2yNxCavsjNBO0hzpATNDpxvHylBF8F90iQ5KYsTvE80nHMJuFseJHVPfnRJAknG4EWBygawTZoUCI2QCQWNLzZFY94xIPrOIufMV+C9iL1v6lWUVYosxbfDwS76YHCU
 DwFvrlHG
 GQcdOXNkEhHj3PhRaaLrqL7XzxhXGvLtb6jfnH+A+LdRIbGWpyt2LJJTx673qfDDJGGT+2Fx/MYlNd1Ky29TWbMQS83Dv2gBzhfMdbfJ1qg07GC02DVoPz5NquhtGVanUZq3pXJhzSPdNT7VJ0/1xU6JK6NO9RAnFGfnvc91YVCO20Q28HwG5+2uMHoZ89MoANUA312qOI+02od3XMJ6lYusTuOjpPEWqbVV22oXNPSzpZIN8Fi5gSzq4S2OOO48bPAIqa/PSdpyl2fFhl2jmHwTuH//9aA+3lpqWR4kcI0t370UP748vubKjmwyls52KbcF6D3bB0eeHT9UMo/r0ljlrWnTGdaB+D6gMRtoJ31kg/MRU3EHYgTyxTtr3Uq8ymawQ4SLjSxa14TO23GWb7oBO9aFPmZgsd0J93XHi3K0onJJmTNKP/as/qv+lZ7gxwNBCPL8qv0O6AimWfztF+FHkPcCxkSDf7r2PBIsT8H8XKYKIUh6tcWWUeQjptYstbuAoPHDcShYn4qoG8oIa7aZpS1tqXfzSpUGWSwxp3KAnnrCkmdFoLHZtRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 8:51=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> Seems this is a duplicate of another similar question [1].  I believe our
> discussion on the thread answers this.
>

Hi SeongJae,

Thanks for pointing it out. You're right, this is a duplicate.

This was my first version, but I resent it because I realized I had the
wrong CC list (I typed damon@list.linux.dev, missing a 's') and it
didn't show up on lore.kernel.org immediately, which led me to believe
the first attempt had failed.

Sorry for the noise.

Best regards,
Liew Rui Yan

