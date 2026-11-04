Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2CDA606A33B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=llnd908P
Received: by kanga.kvack.org (Postfix)
	id 1E6286B05C4; Wed,  4 Nov 2026 04:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC2B6B05C5; Wed,  4 Nov 2026 04:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA396B05C6; Wed,  4 Nov 2026 04:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E128E6B05C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:21:15 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69E4C1C3F1B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:21:15 +0000 (UTC)
X-FDA: 85396892910.24.B04C73F
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7CA26C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:21:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=llnd908P;
	spf=pass (imf10.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GY0htM7LLybH60Zvhq77Fsv6T50kPeUsLh+oGL9owIY=;
	b=KwD6HqavzIYoRELHF3jkQWp2iNj3YeBFwSfBVAQd+sVlzlRdCZhA90sawb1hlNxsssJJWf
	q76rggLl1IbS2PbEWOypZrdpE7kZd2Z0vkFw1vyV3fqMMzBCKDbHwGcfV9nHOSO39/Mqne
	yrC4xWPrF/6xwbqwxhbjGqpuXYilylA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793784073;
	b=iX1jrWkJ6NExsIie34p142jhASf91yiALtcGWesGTJpMG5+tjRoyqWNCDqKWXUjW8LsQ9V
	rVo/gN0wfJyMbud88yjqNFPUXobv7ze3eZVtsQiqnUwBeJ7PNbHe3dy7bHa0T/6k1S2SMd
	+m5usTx4cYiaeZwEQf6+XZh34Cd7NLs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=llnd908P;
	spf=pass (imf10.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b10d24345dso4189007b3.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 01:21:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793784072; cv=none;
        d=google.com; s=arc-20260327;
        b=s5nLzKuL6brtRRh5YjWJmNBmTUSAMatxPkQcHuaLBxJ2GPE47ez3VfqRiqcb5YcnFr
         yzBbAydoiKiwIRSCBVi6CTcvw0sG97PM6QfcP9SG8+FuExrCsgV9LgHkXT3eeF+TdF2p
         so+eDKkXqgC8NPDo3r2B3rUWiWeuWqprgU7U4XFZMPR7mtsP1tMYa479OmSY3hwNvoAt
         3KzZiPwA71tYIYusGLG+ajVgFa2GsnHGAjkCuV37oeUd/aj6mWb8d32/CsddCn9VFsB8
         il2hNEsQMBAnPF1HeFbOu0OaW1zvp8fTphqVVgli4mT7AjhXlGC8SY+q+cktinvMw2R9
         DN0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GY0htM7LLybH60Zvhq77Fsv6T50kPeUsLh+oGL9owIY=;
        fh=h/WiinTeE571EFl7gEs8+UByQIiEHgiixqyTQKWF8+I=;
        b=dsxWgNa7MjYJKaE7NK9Y/OoVYQJYuhg/G0AFCewFyIUsYeOiAkjWypONBMdlGSFg3l
         rVtD/K1czx0zMyfqriq+7q3OqErKshlPNiNejwEqOJ7hf73pDFdofNcd8ssQ74NnzZKw
         G/igkGmdmofvjCY9UAZTUE8rh3EXVPzxLVDkR83C+tQv9Rl9PLoodCfTExsCqaYTYlLZ
         eDkBmbgVLMStPHKSoeMsz2nmWpMcwTrVw64YP1ztacvYS/CVGB1+wFbeP7kZQWaHoGCq
         Gc4P7a/xuErwDKFKZ6cpPhrDDELtrqFMcJ834NEqTfvIENYG92vfZs8OcB4lCgmd6Lzp
         ehdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793784072; x=1794388872; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GY0htM7LLybH60Zvhq77Fsv6T50kPeUsLh+oGL9owIY=;
        b=llnd908Ppxse2eltZrbzWLcuyvT+6u0E5TUpD/u6++STX6lNDHsA/iXPYInu304COM
         WxMPnfSHIMlgwtmG+2+8CzjqERjsX2WHjkR8jYDwwNPlj/r3GCbkMEZqBrWwtOscLhnK
         ESVUQZpMbYpRNoDMQdZnMg7fj0HsBUygZozgV2dknkJTWTNLnGHA9FH4E1+NkNMYQyP+
         f8jO433z24ZhbEFOCXV3JwYnF8HDBMozXLKzGGeql0fNyWwSoDL+Qn0YaHJHqctzgqlQ
         WN4WvIdVLxuMcfHxWIJB6PNW2autOs53/oDWrS8gjesAfbYjSUiXPCNrBf59jsHgeedl
         oEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793784072; x=1794388872;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GY0htM7LLybH60Zvhq77Fsv6T50kPeUsLh+oGL9owIY=;
        b=ajYim4tuGHZSUiwWfdrGlPdmJCzPVTeCfytZEH55KSRRyUwfkpPj9nIKW6w1OzfDGv
         wkhBpL7IgQul+sO0v3P15dyLGu8BwF92Gsd9BfOjhJbfMxl8OqkVb/HblobXUCZ4Eh0L
         ia4IFbs5wD58qPyDWMAV6g47LwTQ0kOVNwcvSV6xAmIhMsK97TrWbrdg7+W66F8liMBv
         qEe9A0JBXJPvE2NG3b2C+YmMB+4Mqs5I6lz2ITZFgfrI2uRFpKUYEAYU5moaH05+9tjf
         HMQczYEcruogXcbrVKS9sFMAspwDFdWt1WQ7ee7xJAuiOm9lCHh7DAIDJ42AHP/awPJY
         HRiw==
X-Forwarded-Encrypted: i=1; AKwUvBwAa1pD3ek0CGo4hdEomPcch4qVa3/QMwbv2tsR++ZXreR/JvO9fGZrXVhU62aGOd5LJnoIVxEaVQ==@kvack.org
X-Gm-Message-State: APuU4Z/LYSRLrpUPyOR+lmPzrTasvbaEyR9Au+jnCUfBI7nRqRXQDotM
	D2/q7nnGGZrEgOR+19xC20kTwHK6yuvfKqnYOxRb8hxiutV088DxHXBIJNA/gVyMBfLV1GJHNf2
	7hZLt8Lyj96y1fxFijaUhSTOIb9lpSfHNwA==
X-Gm-Gg: AYBFou1gyXQmwy9k/q2LS5b+jrT5wMNk86TPsaWHKieCo8YmrHRYLqFNlGIOh2baeyI
	vMhP19yS1JqbHXRgjFwenHYkbxgHDpY9FnDSp1CyN045AuU2zrJp9SofLAyGIn6NMlEr9VH2obB
	oPFEBYLW6BPbu+C7Vy0D38ej8JkPNslXuEN3ooIh8SrrVkJcvrbyksMJg36bxl0ptNvEKanYd49
	VgiYNe7RHVJuWmc89OHmAG+fYn0jA+u1l/iQjRwOCygFIkqynuKY1VsmrhL3wObSQrflyomkMyx
	XsDTFt3+9RQ1HDzTtbK6dOZoZE9iO5sS7Y+oFmNiGIeB8YUGlg1TSX3yX8vyXMTW8cR2tgor63h
	BKfAxLIm6RpEgkBXI44rtGMRn/hl5H2Lg76dSe1MyzzS4+qBZ9yp8kxnfz2kpKx4eg15+4BHw
X-Received: by 2002:a05:690c:d83:b0:8b2:fde5:d95e with SMTP id
 00721157ae682-8b2fde5e72dmr27025397b3.63.1793784072404; Wed, 04 Nov 2026
 01:21:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102103621.156928-1-umangpokhriyall@gmail.com>
 <20261102103621.156928-2-umangpokhriyall@gmail.com> <auot2ZVM5YjyFlZZ@kernel.org>
In-Reply-To: <auot2ZVM5YjyFlZZ@kernel.org>
From: Umang Pokhriyal <umangpokhriyall@gmail.com>
Date: Wed, 4 Nov 2026 14:51:00 +0530
X-Gm-Features: AclHuK9dbghBwN40s0Kd9a8eejM4zi0u6MKlqoBKgZ5z64zrzbWRBqHetF1dhp0
Message-ID: <CAOdFi6fb=d8RDk3EJSfGHSCKtsVjf=dmG5o2fq0dPxQoyBohzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] userfaultfd: validate the whole range before changing
 write protection
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wtki5a36f9b941eg54ozteyc7ifhxqaw
X-Rspamd-Queue-Id: 7CA26C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793784073-67669
X-HE-Meta: U2FsdGVkX1/pTZxI5KsiwdkPJjo39CCSE3ebWKG2kp9LZx1+fM33Zu85WFiaC8wmNvSoIomowGp0FgmvrWZZklVyiU5sWdFFD+AJtwacQQKLvrXMnnlEeippYAR2Ycvw79UOHYFAez/X92xJXmBBIPflDLLh43KHeRBSQgno6iDffIcT35b1R0O6Qc46QsBiVPPdgTGGcxL2kksT15oVIEHoOMeQwI3Y9g3YhsiJz47k/E+N2qlxEm0NyYj+YR+qyR2LiyhavyQLlvU2ytoPNAmoDFw/H93s9BmNg5APnQibLxkJ5i2jEWCYuTEO/uey62BZzWWe9w0WaIpDc4IeNWDZ5TvFU3Fg5OUQZZYjQtewPnVpPnxMLq6awS6PjQNGwjan56dXoZ7eh+N1H1Vp95ne5JnTCzuEjBbkqPYVuKVvZtu6MkRJH21uGPo9QgISM4CgjTFvtwgt08o31ZDW3VeafCApzcpzW9uu2e/Ox/UBFBHSPd1EkyUln36JCC2n2IVjZS/AG21prf+4+QRqcJ+MgsG8ejwt3VGvtzuSoYbK1ZKqcuO/6dWSRuX7jt812nd+jERfJrtuB+BQw/zE9lmkMjYtsIMOD/Xv9oRxwROpwgmSlOCbZi90eSCAL1I2BPbWVXhgwSZSqHrIBdeY+cDHb8IdeveGCqHyv94XXEGz3iO0wGbS3t11vShoCOoN2Cfxc52ehJrP4F11m5/T1AbxHzLliT5EC5JLXrA5WIFSBb1yM1n5/5D+H6452gW/iWmYdbj3MctpqQUAbF0DoQBWaackMeV0X6QkV+9ZquCcubIGd8zV4ZHtEtPACu3k6gHdwRsQ4RM+fn2pQUWH+m18+Uet98+D6zn3jHeE3uqRCUVJTcY4at19k3eAg5G2V8P65yP3LxIfUyzKHhON2Nw2GJc+gmL7c2fl8DDb1Fo7Ec122D4ik8LJcriqnSzbmQ3fSsscAxVWbtiZ7oI
 R6gTozkK
 yOTKAsmXJEZRDkA42wflK8pYy0TS5q3qsCEWDAIZtM7xXUS83KgwBeHlSevI7GdOjz9S5iYQSWzzygyzZRnJmzu2aq+6+LU487UbK8kK2wyxybqxGEaPqDeAWF1gu2Xv9crpaJKkpzcIUw9mrHA6x/DuNrSSeWDQFO/dLBtoMz+0AXkyFWeay1XbzUTT8M/juFBiNGoB8sc6PtH6DulG2+0eqfrcLI+7u5Wntt3N3h/uHPPYmg72ASfthPgLJPomPg91N8wsuAdkUrO0Prc7PCcPJU0h1MFMmDO3mDuZL6lZXPouUOG8S1JAgnYBsYaXc4Q8AvFrBpusk2A3YcBiIHvsEU2gRVo7Q1M5kIlNdR1/ORdLqPiSB+55RpxYX5CuTxIBpm9C/ncd3YH1iFuAUcy2m2sB7QG+APRkjJeXmFYZQFWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 12:24=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:

> If we a breaking on any error to out_unlock, why do we need err =3D 0 and
> this check?

We don't, thanks. v2 drops them and the -ENOENT inside the loop. I kept
the one before the loop, because for a range with no VMA both loops are
skipped, and without it the call would return the -EAGAIN left over from
the mmap_changing check instead of -ENOENT.

I'll also drop the selftest.

