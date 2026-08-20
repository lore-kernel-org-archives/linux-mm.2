Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E04C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03E76B008C; Thu, 20 Aug 2026 10:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB0A6B009F; Thu, 20 Aug 2026 10:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1E96B00A0; Thu, 20 Aug 2026 10:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B37086B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:32:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41807C01A4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:32:41 +0000 (UTC)
X-FDA: 85121888922.12.01B207B
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4685440011
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:32:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q6CRkq0z;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787236359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVFMjvn9SUD7pKojotlCKMZegYxIIGk7ZsgmUorjlPs=;
	b=clRad6dr42hUkxqB6IGBpbxTK1HgLyaJQpq70XbROdZvOcfH+mSuVtL3bK6sI0JSt9svXb
	KM3+4Blqic5qaKV0kjvdhUhpZWiNtCJnWAQeiREHCnK4dXHdDjgFVRE4+Ayt04S0yv0Bie
	p7dNOs5u73cPPRjaBKC/zZMQ09+2/F4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q6CRkq0z;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787236359;
	b=rsK8/uKBDoXwL/ktjqFZExPxpJJH2iql7fbJH8AU/DyHQh/tmM6tAKWlycaAANXE7f0VKS
	1p6Plx+AhdpFbOj5xIRRwtJYj7qiNNkHqCboR5r5v5vUv9ws8J1uD9uNseK9LDWar1uvPy
	+Aah1XXrB0Cg/PGhrz5QRo3fwoq+W/k=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cc891373e0so27757555ad.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:32:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787236358; cv=none;
        d=google.com; s=arc-20260327;
        b=DcLRBpXel4a1/UguCD5ZQTcVVXZBEsNP2DyBG9aGVdKpRNn2VWc0IC7q8XsVKm9qZY
         rhMIuVO25kHVNpgf9a1QjIaZJzmxkAt9YY3NeNPtgVNQNa04eh3jzw4bYV3dVdlVCKbN
         nOiWEnl83UzuEtMXxEhzbUQDlxiQLOmoD/ggmzI3qItFhnRX++MIiMCgocftXkBGuODN
         1Xlt6nlyN9xbOmJBmjDNZVHozPMtKzpzNWoB0Th811uOFdB3qWoq7DhfFOMuhobPT1e3
         qPjozrOOUkkEP/u7MLZdWlV/0IANJDXh0IcFBogaGZ7EPSoDRw0ExaX9lKRGIBFfoLH4
         oxAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iVFMjvn9SUD7pKojotlCKMZegYxIIGk7ZsgmUorjlPs=;
        fh=WMGK0RJr/yUmznt8i5o5DicgizG+lkSc978XhxJkqNU=;
        b=NKXuaFBONOww0uraE8gFzHAwxmHJNKfbdR7YU7jrTms3siJrWP9ukXDix+sofKU2Pa
         IZQ7DmSe94QYof8uIMdDCU4ms1nRgwv/H+3r0AgImccpeD5s0XGcqL7ihuSEpib6+ibo
         cw7lak/g5EIluf00nSHVs2O7R5pfiHD7hojbcNYk5tKY+hPH+vjSldI+d0dBpG/qnbWq
         yLfLWjdPjVvvOxooXYzRt6PIAD97uvbNJd9SIgVwbU/AynUdJm1Ljgjqody07GcVvzIy
         LysDtnP8WfXO/U64ubClfXYllbYJGe0sFVmEccwHnmZdyUj3AUuPJ6hTc6SBaWUowqwS
         v2kg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787236358; x=1787841158; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iVFMjvn9SUD7pKojotlCKMZegYxIIGk7ZsgmUorjlPs=;
        b=Q6CRkq0zCYQQKBOW1jFpPe+YsGcNhFRmZIbcW/taoTIKyhilEAvsjWexSUatiknPvI
         uwamg7MP3/rhEG9XNtFLQ6U5W3PigX4kNUAQ3Z5WFCBya44wSfFz6VipwYYK471DiHkx
         Lumt1C7NRkvF4Exo7wft0U+PhEehjk0AlwNZ9wjntS1HmZ30nQp+2BejZ4UFSmZ8MuyK
         Atk9AnCE+DTz19Vx6rs/IxejaOat3MHKjyhmsF6EPEfEGVk619qiVQUPyzimJOjH03YI
         Zy0i5xXvXfqqfbt3RcBUjcHdVFY1p9SWTetOaB2KvYSv3qvFPXmfqFYuEM3m/aWOaZnw
         yRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787236358; x=1787841158;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iVFMjvn9SUD7pKojotlCKMZegYxIIGk7ZsgmUorjlPs=;
        b=cCq0BqTQY7SRBEiJ0SdwlSzO8YTmlPxsF5hg4FdsgFIqDVCalz36shRXk9X0Q2BBSI
         ISJwAKozjWaASDj71ih8mz2vmAdAPKpzedKsm5tgRt/LeYkTBGFPnvCTo72zfSNhrTJj
         agG3cTfC2wNLaSgv9gaX/NQp4SAOhxSRdVC6qtaeHoWPPowvNWYgtV6945CHTzSULoLs
         MYmXr4IcNvB1DUM9baUg4rIvZYx3LnMnzDF/m0zQ3rMKdDQnqLAGdZu8xnwtctOBt4zG
         CXGIIW4w0gdwMflW5B0Ox75vT88emrRPxlxwJmc5rrABPERNYMTyf5a3z66lZFCMJlHI
         /Jsg==
X-Forwarded-Encrypted: i=1; AHgh+Ro6BhAdIkjnyQGBAIj86YV49W9Hed+pY0ov0dx1hQxIZPdRi6YVewdPQ+gV0uewNgn7O0a05DA2qA==@kvack.org
X-Gm-Message-State: AFuF++lcFZhKcJvDvFca7soHHcrMocQS/R5rfVltOXWg77oBtVSn2eor
	tEdSvJlh8jm2DMfakdPyoulHE4ucjrMEGNRPycrPzNeofLubNB25ueESLGBJqFtFX0K1NK/0FZK
	YiYj5iB/TFersDm9yqME88xjkCxLf7eQ=
X-Gm-Gg: AR+sD13qg4kE0EF1mmgFG/CMHtsrfUXcN0+KFRRIAUCEGOquPh7gHgMF5PelzjK3Wjj
	Pp5WBOQqZ76E+XHCfyv4Mg6HYTz23kFUIOR9egsuW0WVoSHnLuA69odZqYz1ewdlReKQAvFDu3h
	ZNyp1QTkFpViQbhkIC/c16O8YUt5NG8wCNjP1NGKRygFpxnFTioYJp8Hn5sPU9/lTBqVMFdFj4M
	N97KDlTPviSRiemGP1i6pPA1X/7YJfq8FIv/qpQ9J2PJvFSkQAJEatvhZHRo8BE7YNZJY8HV1OZ
	qSxuZyQGVQ6dipSLq6aFRZEK+zS7ZNOu6RYyEU+NaebnrgNwvjd/ITrROSQ4vt/8qKAV+buVQRk
	Kfg==
X-Received: by 2002:a17:902:e94c:b0:2d5:d9c2:bbe0 with SMTP id
 d9443c01a7336-2d5fd621427mr253857535ad.4.1787236357878; Thu, 20 Aug 2026
 07:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260819121426.49500-1-anshumantewari123@gmail.com> <20260820001356.87221-1-sj@kernel.org>
In-Reply-To: <20260820001356.87221-1-sj@kernel.org>
From: Anshuman Tewari <anshumantewari123@gmail.com>
Date: Thu, 20 Aug 2026 20:02:25 +0530
X-Gm-Features: AcwNN1WuTIi0xtCCzqJlCIf1670T4KxEdT7yFZVw2e0Bj_JWwCiZ_JWo-NdU9zY
Message-ID: <CAJqi8kJ8w1HUwU4tR=KZUC+9GMXJjO1-YLqcD9+s_a6tSA9BYQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: check stat() return value in khugepaged get_finfo()
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rz9ci7rf6qo41cwomh7acdo3ds3hty4x
X-Rspamd-Queue-Id: 4685440011
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787236359-294756
X-HE-Meta: U2FsdGVkX19gBATMa2+Dy5/u4OZ8OV42ypAfsPdGWaKd4FQlSLWSXWoiR0rkIdIp8VpodQRuZsHbN3l8vxvOP0SnC1QXJI8nVurWlMZE65J1dM4qmF0iIP4EHrTpsDt2xVDn8115gI408reQzZIo9Nap3t6BNvpmKULbITDApYRLY4d9DWN6/rn1XM6w8aOCNn+kIQinHewPZeDdqKd0erPGrsVMaPBrsQxeU3JQZZZ2/lpyv39uJkn2hwDDvKhgGnB7WI+q8ak3ghdHAFmfJkH5ndbkBBP7HZYkuU0SS7X8k8pKNb/cehyL8iTd9FB5+SL0ZetgmNdspMIDf0757LsOeXhFoU0KSgfTUZzOAlJpdRs0jFke1rlRvOEKMmHLWloieWUUpi76sa/lIfDU6ZwvQuFz0PBofafGtXOGHyWZka1nuwS0ekJF5xawz2/i2TpJ/ITi2XWqJ4hJs5YXQ9f7LP7b9YPGTfCyxHWwMWB+V2kXSW8JM8IXlaguDAqANXubPM+4NP7eR6ztlIh9iQxCTSMyjhre9188QKemaM5JoEPKNAiYr//RFizj1wZGfBsgL8WAZPiRHzmcYkB1QB415PMTUz3lSkhyaWZveGaEGTKbSz94XKKObkFzKWQWsHDlpjyQ1zorPvaOPSFKLyarJVZM23ePhXJaXJfxS3YDN6O5j+qbil+pBrVaENFEMUjyL6ok+SmlT66LHEovWSvkgWG8bwIaqF9y0y4MOceYxRD+jE8fNMXYZgja0nU0ZLHi7alzHvTsK9DtDbe322hYVXsx7NdSZOjtGXCPfNhHDw0MU/8YEYSfx545ouxdRayujR/Ev8uLd2imxxmD0d8OwfHcPY2Y3k6hnZ1IAw1JffbpJep0rWtfVdLH3lXmXi2LQnQ0Pwq2kxZRRS0A+vyrAihJnXh4/YlSWCSaS+uB18GVaHr1RDrh7RU+Cfk9tjqkpnY84CYy5JpPMcn
 w0WUVCx4
 REvvJn5NFh/9kJrQtl/f7IUMDKGJo3ddL88a0FC1Guf6epo8XNTOEw5VF09cZM0jru7pXrNhnOPIMmBm7YkVrUJSc755HJw4NwyNV6et/Qa1N5IARGq628v8OZTmQS7nDaTClrbOFvsXT6Zg52Jj66tshr3XoxMtsCwYN2Kmt6Z3yKoDcnq0lI2gXc4sDMUDVF4qVN0SQH2cTr92cSfmFqQSEkNPDvUkCpInXW6ESl1ujdRz7yeIhFtNlMcQDCdjJaTLnVvOV5f2ypwMWV4kKfuJAXieEb96XOLhN9g/m4UJccDoc34vCx/xhcpmRxI+LwBUzZ2CejLub53iAt2YrqOb7N5xdtzLeCtYAa2ALOt8WSsOTCPFfgAuJEhQ/EAygGvpFKKl3aRQREo665lnuWmg3pWeX7UZ49p9PjL+rRcD6Q7w4GTpKnxpupr6V5zQaU+63BiLeiQuULbllpJBgQ28YejSwBFeo+06nGqpOcrRe2dQuY1l9DwTEIRxl5bGnfSSNPKQzRSLRXkrBLdwisXN5aqF91qwU9CEd00habitvkn+dmYWoQUAayTT5mCPd49Z+BdCtEgCztCd6ZsBPcZ2GvTvjdqq+3VyET7KSjHoP1y1uSricG3hyRtyQA2PBz6t/eW0G6Y+vw9jFiJvIMzISsmUKzPuSgvU6rytVaV+yWpqDVVIHvUBUiiQ9lSk6lctkpVoFnbVMljuCYIqDJSuzClxSYzGZS6AmmS6gqKoY+MIMhEjDgrflRltmAMJ5XlyqF2mPH2+phiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review, SJ =E2=80=94 and for the extra maintainer list from
--nogit-fallback, good to know for next time.

Anshuman


On Thu, 20 Aug 2026 at 05:44, SJ Park <sj@kernel.org> wrote:
>
> 'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipi=
ents.
> I added them.
>
> - Zi Yan <ziy@nvidia.com>
> - Baolin Wang <baolin.wang@linux.alibaba.com>
> - "Liam R. Howlett" <liam@infradead.org>
> - Nico Pache <nico.pache@linux.dev>
> - Ryan Roberts <ryan.roberts@arm.com>
> - Dev Jain <dev.jain@arm.com>
> - Barry Song <baohua@kernel.org>
> - Lance Yang <lance.yang@linux.dev>
> - Usama Arif <usama.arif@linux.dev>
> - Vlastimil Babka <vbabka@kernel.org>
> - Mike Rapoport <rppt@kernel.org>
> - Suren Baghdasaryan <surenb@google.com>
> - Michal Hocko <mhocko@suse.com>
>
> On Wed, 19 Aug 2026 17:44:26 +0530 Anshuman <anshumantewari123@gmail.com>=
 wrote:
>
> > get_finfo() calls stat() to get metadata about the target directory,
> > but never checks the return value. On failure, stat() returns -1 and
> > leaves path_stat unmodified, so path_stat.st_mode may contain
> > uninitialized stack data.
> >
> > The code then checks S_ISDIR(path_stat.st_mode) against this
> > potentially garbage value. This can produce a misleading "Not a
> > directory" error when the real problem is a nonexistent or
> > inaccessible path, or, in the worst case, the check could pass by
> > chance on garbage data and let the function continue using an
> > invalid path_stat for the rest of its logic.
> >
> > Check the return value and fail with a clear error message if
> > stat() fails, matching the error-handling style already used for
> > statfs() and read_file() later in the same function.
>
> Makes sense to me.
>
> >
> > Signed-off-by: Anshuman <anshumantewari123@gmail.com>
>
> Reviewed-by: SJ Park <sj@kernel.org>
>
>
> Thanks,
> SJ
>
> [...]

