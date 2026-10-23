Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA999606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 22:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NE8bBDT2
Received: by kanga.kvack.org (Postfix)
	id B57DB6B0092; Fri, 23 Oct 2026 18:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F996B0095; Fri, 23 Oct 2026 18:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44C96B0096; Fri, 23 Oct 2026 18:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72E1F6B0092
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:39:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2932A02D7
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:39:03 +0000 (UTC)
X-FDA: 85355357766.16.39A452F
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0FE5340002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:39:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NE8bBDT2;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792795142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQb9soIuy2IWf1LrfZEp4aNcssN1ddSrfFmGCMehWsg=;
	b=rS6Ufphl8XoZKhKr0s87vxSXCdujnpLpkbc/UCly9cbC3o2MuxcOP7yl+tg5iJN39TgjkA
	Ff7e0BNmw6iv+gZ1oD4Bv2ubq76ZOE6YTQKlxaiyu9Hqr90CLG+Uk+n0TO/fQIp/VkNOfS
	guNnChWMB2xuq9TuwmpFPk/EAN51jaY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NE8bBDT2;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792795142;
	b=WFWcIir8TeCo/mi0REMqVFnaXTgODFdlmAJMNV7wBcY/nonyu95o9RicTmH1c3uecGGmkS
	X0pwOFxOGYBXOuMWKTKz8BjzHv9xdwDLOX/doUg6+cvcdTESjIVkgrm4db0d38JG9/r4wa
	UXZzACypZUSmG5uQoIFbFBm3bKQkoVI=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so1109185f8f.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:39:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792795140; cv=none;
        d=google.com; s=arc-20260327;
        b=PlrRLo2ahAqjNjo7X5qtAsOXUVBwjtIHAFzZKZ9hEBTCCWYhPyXG1ssWR7aHq8RG9K
         Rq0fpmta2cv4cEUgOYCEI5mZZm0yTEtuw6lss5mPWYGQ/thx02T8UKBQF6gEPYNI7RVf
         f2HZecBJC6FuPdSTA3+gQBmhug38PACDj/+LV+oATJ85aqsefIkWJDCx2+P9XgRotqLd
         Ek09Uiz46fL/vLtyyTqo/97UMOWQjYv+wgBS+64XSFAWJI3jiRKvkL+h9ngoXb3wOuDO
         sKGEwYxXht4zoOzv0DVN5sxhdmaPVhYU0TmFH3Ve98OrWphJthtw0bDFDn/H6f4vk6sq
         xU2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DQb9soIuy2IWf1LrfZEp4aNcssN1ddSrfFmGCMehWsg=;
        fh=L3asg67wosfNF6gxuzL3P2Lk+4g3ObxCbtfo7wwihAU=;
        b=RyCLsagyRGuw2WHgo4h2J76+YigMj71lLyb81I1+nCLI8xrSCBKuk4wRcPBTkSmZ+A
         YmmPsyLEVYmlPIOnZ3JSbt07BKhNj6wjjpzBe/kjiDrYDfmHmk0DPa8xxoaBu1P3rxNn
         nLSAm7FTW9/tWkcLSR99wSXY9xMfxPd0VTKM74M8WxN2oOfIv8xz8mt0kteRo/5EFvxF
         iyRbw7OiBr3TlSwsBAOHAfZH0/FPdq3Eia7R0pdzUQ1hJ8aLat/g4wkWsrr4rLjPc+h6
         jpKbM0AUbeCVoiHbh7vuFX0chSI0vac99SEca3se9MWWhO7t2dvU3iGBvKCNHt4KAjCW
         xunw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792795140; x=1793399940; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DQb9soIuy2IWf1LrfZEp4aNcssN1ddSrfFmGCMehWsg=;
        b=NE8bBDT2uPCC3O1Uq6LqqMzuLv9oQU0ZDXhrCo6vxOlwPfZz+QvdBvh6FTSLai8R4l
         sN2IuJUFylXBMlVFH7cf+dzXco/XAGEuObhnpRycDIBa6hq1HPjUMjUFlV0RvkejNehg
         oIhzeM/knga6ki/4rHH3KMJjjQTU25Tu3RnNfAW8hGIWcQ2cW0Ky7NZQt2l2QEEPpX00
         ++uvy1ZQF4wfpyGuOS3G2yNUoEy8ke0wDj1SIXtnR28cWwOEtyymaGyBN+itmErnMLcJ
         bDXoCB1OJFeFqshvVCuFm7owrIfXMvzLqXtw+ypa7V8x5StN6S/DoYAqpVqCa8ZfjyZb
         FWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792795140; x=1793399940;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DQb9soIuy2IWf1LrfZEp4aNcssN1ddSrfFmGCMehWsg=;
        b=AVvw2xFl5poh9Jr/QRrsHXdlVXoWW0B/IlmuiAGBeeHilXcuul3XDaYOpKsrX0n7wB
         vHYDbN14qEYBEIrG0MQ3muqaPQPfBKEgPzLVh9rkN9PjgRy7jrng8pwK7K7jFWYOpyH8
         jtvHtkox3llQq3ktX9WV9fpgakaYZ6ziLYceTpv7JI0XEREcQcNRoA6d/gND/k5kYL4T
         /DRSmoSgCd18DPYzb3C9XpLcQ/32cJlCi/C0IaYo/Am8dW4D6xRceeYlAf7WvNCEdjkb
         LuoaGRDuzkR+rBl8ekk724M6DlIkyBHGVgFd+NcM1Y4uS/8XK65d20MnXqh+dj3hjbq/
         TOEg==
X-Forwarded-Encrypted: i=1; AKwUvBxLmLzjJKlQ0o0hBkTo4jjYEwr2Xa5OwLLns9ZYNvU3Z6M4PjCf3hHL6dbiyhVZ2Is3WdEFbB+pUg==@kvack.org
X-Gm-Message-State: AFq9FYK02uGHIQEceXgHlXM0MJRlPY642h5NB1wcAWytB8rC77Zd+63w
	xG5AMJhBO+3rsv+v2yrFYFz7zvEX6lCZ2weJHETjomk2yb1w4hk6Ym8dFtLkkMu5liDsD05XxfI
	SrSYsnNoesG/u3zViIkI1ZKTygbN5Dwg=
X-Gm-Gg: AYBFou3/IN1ry6p/pS7xdm8gCngFfcLzfxZgtC3CBi4RKgKoX/zHeS9DdX1TGLvjLKc
	dgU130OPwyb2jeLtFZxXDDOABqJJuIdnYulIV5WaukSgj4fyfa2oDy2cq1iz/1dT6JbiTJ5Hdh3
	jh8Pf6X/0naymPCzd51IITlLqU0K0A8hLsF05AXORT88wX3wevGHvhGUDuOxG99YVMK1gG4PHpL
	85qC5CwvDX0z5bLj20dWN7qo50eqb0/msO1OAFr0YgHmvBhe3JC9TSY0waGl2CAdiBv4MG7y2zz
	0AzeLevRVM9+g3aTI2SCqdeBiJ4IEcvcTfRytlzDPFgH2zQBX7pc7TMxBJXdO2JPEcXICgF6jxg
	RIo/d5Efv+vpSwHj8oAHC2ARhUj7j2Qe7+tSQOdMmF0OV6BXMLXsp63UDaui2Ea0M9dXl/HaTeJ
	iZWCSzdDLSeta+ba7hHXRvbE0vb80iFT2rMzGnlGeg3Nbo1kGXofy7
X-Received: by 2002:a05:6000:40cc:b0:48d:f069:570c with SMTP id
 ffacd0b85a97d-48e3eb93429mr575083f8f.41.1792795140106; Fri, 23 Oct 2026
 15:39:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com> <179279233116.3784731.9576593182600250610.b4-reply@b4>
In-Reply-To: <179279233116.3784731.9576593182600250610.b4-reply@b4>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 23 Oct 2026 15:38:48 -0700
X-Gm-Features: AclHuK_IYUAj5HLbnP3AeCgr3emPoTaAjXpZJxAWWXcpmGT_QzEhtpufA_J3jmE
Message-ID: <CAKEwX=Nf57X+Bb7C+0L1L6bkVDw2rjTMSfn=xuMRsXY_qrB_ZA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0FE5340002
X-Stat-Signature: fykj1n977qfc3dpe1y9tgd8u57dub31t
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792795141-951052
X-HE-Meta: U2FsdGVkX1+H6pB4UwxFERoV5Eie3oFth6wPs+pwptcuR/nvvhzS1uIAovmT8QbLuFmiE7NG76eC910HZp4AemM1kNeab1nduvABI92qrF8sOvN5d5Eub1/QCyFO5Q5xK6h4Toe+ZVYTTt9ok8+1XQ7iUKlhMy0J+uiOamXWoT2kYn1MxFD1qPrK2+6Oi80ZwMQ/mmK97BFUqDw+JRTzg9IlePnt/ZQHLPhxJAx/r36Q+YD5YGRtQoGQBnZsSbapvhUIaAHHikz4Mbh+wDSKy6r6K1Hs6r3qEYv6hs8J1ddwrg0NPRhctSo8GCSML/PzRlYG21P6TO4vFk3cO1WqVg4DGxXQ8cxd8RY65GUsUXcl8UvAYBCKrCdfas7Yq35DpG0au3II477Namn2SOR8lj+6ZbNYZ/shV0ep+euqBjG+q921qKO4TWA2Ou1HN6z/TfPBpKvL8KmHCjOOreyt2scPCMl40SR/4pgg1u/Uf5pHdRSogvBkdsY/iG9PiL/r8ziRwcry/bHZr36KokzDiOH+xbw8BeZUq+mCsx+zw832pQ3cNbzUXR52xeEL5njxDaAif93Qe1CSB5mgFDjI69FYO+VtZdDmSni60dfwZYYyIDgbo1hhjQ6+K/W3VinuXM5cSVJIMR8o0cSIl0bm57MO7vRJKqBu+Qzfn3rTbQuFpaLkf0FBAAUilwTKLr7a7AO5POfXkZd/2XjgYIuuRTj0Ov5V4vdifkY4tAt7UNPNHXVYr98+HPLFjJrJ4Y6HVVVFWnh5p/RO45sdCQMlPseVI2wFocn58K6ZFZC62twHbmE+uMkcv7hntLn+DPOhp75SW/a6qwyPEjfIinv5owR2Sq68Mi6WISyiWGATrfHxOKDLtQDGJSIp85N09/QNgNdv6a0VQjSYPH/3Pkxs3BZCLERKU5dN6ERO31g3ygTtHIwSPRRBqglpmS8V8m0dx7AcIGzeMNA+QHYGMSA
 jjvWSMNo
 SJ1X0GoacTUNx+2sa5MxdhkJM1y7ukL0Ej0Nx/aJaw5+1AhYMzeBKYuvaAWZkic8TNxQ6iLxP2UP9Qw4OWA7Zj7kCZrjp9YvXhxgbRSkB4m/HcXgPwXnz605HpxllIvzo/0lELrrL07slt25m2uTlQykfwc9Cl3CJiYwct4n5aPzj6TchKOqeDHirDSi51dPvk7/fnlyoDla/IC3OiF0VdJDm5tMXdyJV6Zt83unHHnABLaM1ergjPQgJ5YxMOIfNLZ0KCDDBlrzSE3O5fVFEQ2qVDj1Ay+89MOesagB67xAoBkwa6PmzAzBn/YTHHMMfmF6mZ45h2UYAzVMtMtIn2DRaogyBDidPmtYf59XGPirH/K4N2l+kK2+pkrv3n4d0G/bmou94abw+7iZZt+YiWMnSb4Do8EltKc2qm4LXtQ+xmcGEizXll5MNDj1VsjTTKopHSSli6a1w5FC3JrASlV5yYlDJZhN6vN06KSKZ3GL9lEZzTBgi3xXWL7whnm1wHXAWYaeGE40yUrIfG6LVFpiOgAFr5HFfkKMELVUGSo4sfgUO08l0H0s80OVIA18I1XnzZ/Gs1s7ZQH0aRuf2j4QkfElDI6rzpPSTDpHzXYNZWlCTP6mZ4ROYbUJ6ZYM6ut1EsbTAJ4WlLzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 2:52=E2=80=AFPM Gregory Price (Meta) <gourry@gourry=
.net> wrote:
>
> On 2026-10-23 13:25 -0700, Yosry Ahmed wrote:
> > On Fri, Oct 23, 2026 at 1:03=E2=80=AFPM Rik van Riel <riel@surriel.com>=
 wrote:
> > >
> > > +-------+     +------------+
> > > | vswap |-----| swap cache |
> > > +---+---+     +------------+
> > >     |
> > >     +----------+-----------+
> > >     |          |           |
> > > +---+---+  +---+---+   +---+---+
> > > | swap  |  | zswap |   | zram  |
> > > | file  |  |       |   |       |
> > > +-------+  +-------+   +-------+
> > >
> > > What exactly do people want to accomplish here?
> >
> > Today if you swapoff a swapfile, every is swapped in into the
> > swapcache, whether it's in zswap or on disk. With vswap, you have no
> > way to trigger swapin of compressed memory in zswap.
> >
>
> This seems like a missing interface in zswap, rather than something

Yeah, and I don't think implementing "draining" for zswap is terribly hard.

Zswap already has the reverse mapping (from zswap entry ->
virtual/physical swap slot). You can loop through zswap lrus, then for
each zswap entry, basically invoke the first half of
zswap_writeback_entry(), which loads the content into memory (i.e swap
cache).

But you're right - this is something that belongs to the backend
layer, not the virtual layer!

> vswap needs.  But you could just write this as
>
> vswap swapoff {
>   disable new backend writeback (swapcache fault-in only)
>
>   for each backend {
>     backend swapoff
>   }
> }
>
> so rather than vswap.swapoff() you'd actually just want a stop-bit that
> says to disable the swap subsystem writeback behavior to all backends.

Yeah if we can "swapoff"/"drain" each backend then that brings all the
content into memory!

>
> Otherwise the user can just disable each backend individually.
>
> --
> ~Gregory
>

