Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0DE7C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A566B009D; Fri, 17 Jul 2026 12:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01956B009F; Fri, 17 Jul 2026 12:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17276B00A0; Fri, 17 Jul 2026 12:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9349E6B009D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:50:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 218D3A01BD
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:50:50 +0000 (UTC)
X-FDA: 84998857860.28.1EC5D42
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2D9DE20007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:50:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hExGhjkr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784307048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Phdlpz/EWIhX9awcSf1NNfiYXxmPbOkBK8deLlKJkFA=;
	b=dcFwPw7mcs0KyDhlZUe+i6Q/BzD8rQILVvsdxzeAKo3SpUdDE+zQrV5ed2yngDp5XSo8z6
	Z+DJkf4U0W3bM74yBitMoM4xhgkKcjbnlG2fLG/grtPSClkjoq/uG1Bja0NMkqkD2AEWuB
	jjX+ca2krHAE+kZDluhH3KTI1jjjJgI=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hExGhjkr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784307048;
	b=vSAlqHrrm8yF2F+i55FuM1e/nbfA2cM0vOND+IYKXmZN8pY2Z1vb8gtiRToTz1ONO3+A9c
	nyTMHO/yAm45EeGHByF3uD1IR39DSPN8HWLZYJR2U4TF7mbu7akaPdNdAlSd/nnS33agfh
	wKsig9E/3o6lG+nGSVqAAMvZvfrXrpY=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-475417f010dso4380759f8f.2
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 09:50:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784307047; cv=none;
        d=google.com; s=arc-20260327;
        b=ROdHZ2yqMIfEL8BaQsDlAgalngl68ZgqOnFLXyUgjQ/8eO9eQlW5bwGxiGvNLEI1k1
         sml9GLLy807RuaoL7dWIZZoQjN1uiWInkYuKbqw7ip6EvbA8bhvlIRkqMcz6ZLHwtkO7
         jzSsbdiovtOcFHGDdQUv0+DWplGnNuSR7OJSoRQbllpElDkN/ZtAsEwSAQzoYRF2wfKs
         O9KpjuJNEMbGjoJpiCNUSPLz5FvVEPAVsjPll9DH14XMMZiwyx+kODs4exPGwDFkT7Cq
         1haxxwcxySZ64D+HI7R8PyW3k0LQ7Z3DEaVj2xNHk6Et6QdVRWcFFtKapgPXK71pMRWU
         2LSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Phdlpz/EWIhX9awcSf1NNfiYXxmPbOkBK8deLlKJkFA=;
        fh=IMJ+ug7hx7HVtMu8KnlCI8PMWqdymHaiQHY94LN4dEk=;
        b=QZEklfUD5CVMw5Ss+k3kz+P2tYM7YrfcnN3b625DHbnZis1H37Zao7EcAJmp1LeY7q
         epvifOZ5qqok1l1Wp5iAZlF2PQ6UdjRW1se7yxb445hnzAGk28RcNBrjkSdd01SEcX7c
         osIOlKa/RH7f4t9TpSQ4qTEqmyDflQwtnQpiMRVQP1afDBNTZ0meYuJEnxQ7X4qR6BP2
         /nziaWYK7YrUHyko7KT2DkTvy5lQ1r2r5CnZxqICZwn78rujDNZUs3qx+ueZsfT25t3e
         Y3lBKFp0al7XVzWfbKasggAcT0fb6ewvufFtTfawLao6Ap2zGFVj0fm8+qItcQpW6e4N
         bBdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784307047; x=1784911847; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Phdlpz/EWIhX9awcSf1NNfiYXxmPbOkBK8deLlKJkFA=;
        b=hExGhjkrjjBqFymqntRSedFqUZN7U887UIb1FQQ58ja89FLYf9SGifMXedX+5z4QpH
         xezLwAmYooN0EBDPGZEZnCCXQJBQDtEZsWSprfSLjdxtQOs/gcuXiKk+hAm+vB+Gn8ao
         p5Sv+1tGdxjJawzuvZUFZaVwh9yt1Jcd9ey7Mm7Tv8cCqe9C7Peo5tngwbBfw8GleqAc
         MrFSBZE66q67P1OKjlnML5F0Pk6qH+HwZuCcl+7Nh5kudDliW2tLVPrcEm3VB4Yl1qxG
         Tk2dViKN8BkapXhuHQReTJ1ct8+AR8AYaIwagw8ymn/9JkVXs3bBJ+5mwe4X4XrNtmLu
         Ds6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784307047; x=1784911847;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Phdlpz/EWIhX9awcSf1NNfiYXxmPbOkBK8deLlKJkFA=;
        b=GZH96HNLxP8B6pH/+7QnChM6HaynmoI3LVJ4LvPpeSiHUVqaT4Lj6hVdYSNzLDNdV9
         HpyTVuGlUK7nqOFMKqr+L+wNLB2pBNzNfXWLjIimp0rx30NfUUCxmSxM47ACzzMSP73X
         g85SZktOZM/PHyOfYSAwymIr7HuW+7EW/XtCZ7lx7Xc7eK8yLwiuOZus42bWon4uMJH2
         oF8jpigvny063kxCMbV4WiOu7ZUcTEam6c9zP4iSGcgkwY3xMJr7XENJsfsUCJivrpJ+
         j+bNN4dsTOfUbhu8ZN9m6hopnOVxp4444n19cnItJwTmwLBxhueo3ZpXRDm7f9g7BsPP
         jsZg==
X-Forwarded-Encrypted: i=1; AHgh+RoAKrfz+/I1MoWaysjOoAAfATory9+7+Y88vRFgyIcZ+B9TtR+ZX97MsSWmTY40ZrN5r78WrOUdKQ==@kvack.org
X-Gm-Message-State: AOJu0YxR7IqH0zRDPkZo/tSgvuzQoEhmIYXEAYuu8n6hJyi3weaoC781
	0IP4sBv80Ni4IinK6PLFAkVFZSCVxJ8auMwxVmtK35tVRedEtwFFRgbMg1cBmTPcuQiUrzeQbfa
	bkVxPW6TI/hdhYTsDTHG0/zONqMUbmFY=
X-Gm-Gg: AfdE7clNEz/1pctpjGqNmidCpUBeHtWf4E8BibJgeMbg3WaJptZDF3GMT1EKn/0V8n4
	wtJxCgceRtG1GgYB7lHxO29ZistXNgpyVv+l0MuUSyZVlEqgz0Nz+177Azv9OkQyruKwlSaNc9g
	hMgnDdA2UEp8bEnA8bPfFRtCEDf9PEDHQK/E5NvQOCCj+CjD3Y7AalDuSKJIQh7gzPJHWe08ZSt
	ZkeMZ+c6vx2p5Oy8D8QWTRBcrajJVrhC1dbyzIMws6+ifGjqEO5NGewEpCLBOMs+Pv0/uQI9mM6
	Awi1gRc33P4oocSgGsKbsTXGVG5HKGB2ww==
X-Received: by 2002:a05:6000:41e7:b0:465:81cb:bb20 with SMTP id
 ffacd0b85a97d-47f6230767dmr4664199f8f.9.1784307046735; Fri, 17 Jul 2026
 09:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-3-jiahao.kernel@gmail.com> <CAO9r8zNiT63LUHx8X5i_aboX1UWuGkcFf+p9ch-pekURUuDdXg@mail.gmail.com>
 <2bc8e4f6-46a0-5b74-6eaa-59e7aef9227e@gmail.com> <CAO9r8zOFg_mnNGbFFd_h8FAwRCbQ9vXk47EF5f1CLg1cDVGB5Q@mail.gmail.com>
 <b910e870-9583-a2f5-b681-e69edb9af290@gmail.com> <CAO9r8zMLGMpsQ+HbLA5SFSMEc_ctuZoScJMkybnXMp+_0MW-yQ@mail.gmail.com>
In-Reply-To: <CAO9r8zMLGMpsQ+HbLA5SFSMEc_ctuZoScJMkybnXMp+_0MW-yQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 17 Jul 2026 09:50:33 -0700
X-Gm-Features: AUfX_mwfN7sZA8DWdA37gcvmiy0U6J390q-PiCo0povzean0soAfe8xUbAlBFJs
Message-ID: <CAKEwX=Patm4+gxtxwDYBFXFh+jfaOUSvtKtVZFvp=oQwNmdu1Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D9DE20007
X-Stat-Signature: 4a19z99guys8y3qw67ukese7jqugiq9k
X-HE-Tag: 1784307048-695308
X-HE-Meta: U2FsdGVkX1/LTI0xKYJewGSfrU7OO10q51Swem935nxje2i0H3u7Lia4Chtke/RYWst3do6uGtxecrIg74AUZWQwcf0DdV8ybscggMG2uCtAZhB1eYJ7P+/zAwgH1Br5Ozac952/0IrRldPDWigVf6arqjQo5naYr4G+MXcl2mHZxuY9IPOSrD3/Cjy39RFCEwjkrZwtYoubjwOgEt+1RxvzoZsu/JaMET+fdUoY8fdDIY0OGbZ5BqrGuDoLCanntGnbWeH4aOU842HvZkrYOZTRYVSNRsV4iqAQd+bQvevz7fawplCIwOmFlCtK1ifUqPjHDpfeNe1XHRY3qpunAYTBQAxFsnvFzOIG5xVc6qjuAQSo+jXv0rKbZF/9EGaIwJglCWO3Osfb5SrnCAWXKQTndnPtSld1ZyOgUkrehOXIku1TTd5K6QgpPbW7vqRH/Gip7otUiIsCIrcRxeF6O//9xOJ1UPY5xhF3uRo65dKZ4xrpTi11JUfi4SOPuW5ngAbxWn9WzH154EYxhmv2sIIKot0AWYK673pPVfixYEoIzKfFx/6q0OBvOindSCiI4XGBxsA49FEQBy6B6J1jh+OBH6RsJYC8Hv3SheDbfJZyiDeEjSbAYdSQRB6hxGgoTkSlkKtwTkwsqU2KmnZ5xv10Avi0lTkM4muAdoLf2Jp1Hl7ymOo/3DHupGPJFMCiYaDLEVN6CofktwlssrWNQW5blc1xLrFVo3EIZrzntKzdUqwz3+8tpMJQdAdHh+detuyQ2qn9EBcHVCsY+9aFtrjY4n4efnIVsnjHKTaPrLtSBC5M7Iw+GVn2JNQn5NHn/P5eacLe8v3QjtRJr9EeIIntiqI86qd+ir09vVlw9QO8/iChVhzJG9oyRnjVeUWIpT6j4d8R14yPqT9PwmY2dOe44Zd6W7kWEuzZAEWWCKhVi5krm5DEuQfv2MsNk65Uy9N9HuoSkKEAbWQeN0n
 Enq4/T4v
 Ek0SI1ProqGIH+dEd1GbEbT+U/bv8tV2dppMmKhaE3uXIVjzaklQR/i9Hn58wZxKA8t5lFaXQL7VJf6FXYeJvNzI5G0lRSgKKNzfcvyscfIkGazlZpSS6QtBBxTIUB/lBr7oZqqvk+BpdP08R2fzsfdXYOCZco0K4I/Sm4PSuBqzRLXPHgY3ybryChCw1KMZnpRLTmdrKrJT4xfL52zjJH3YQHvR3CS5K/WZRS781Hd3NqkcIgnKZdODjm2E9xuIFAGshnlWypnLsJcGu1Q/6Q8tA1PTWLpdGeh9NKs3B/zGmS1PU98z38ss0Gn0Y5fb9BnBiN2sZGi3NTbhEkvx4NPzUnkh8nQ4wJp3tPlx+uwMU83Z41XIb0hYsx+N0SEFIHib3mZjhAt9NZSZ4FDFNLpQBMTM1d5dT9Opm8R/0WckisD1lIQEumla1nFa8VZBWyyFISBdtLN3T2n204YsXkv6DUAIJWOff6bVW0+bPoiZfCJ+ETDievLCVviJEZyUw7y79UuCuDCNOxCFCosTgL2aNUgozoYiqzP5OIH7iM9dQMt+Ivt7cJbJUXObABfFK4mM9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 1:35=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
>
> It is a bit alarming that the store rejection rate is still 43% with
> batching, but we can worry about this later :)

Yeah I think it's unavoidable at the time the global shrinker is
awaken, unfortunately :( We need to kick off shrinking way ahead of
time if we want to avoid this, especially since the rate of zswap out
is going to be faster than the rate of writeback (CPU vs IO).

Sort of why we implement the proactive reclaimers :)

