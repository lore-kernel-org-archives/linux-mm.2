Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 443D9D49220
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 12:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912946B0005; Fri, 12 Dec 2025 07:25:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3C66B0006; Fri, 12 Dec 2025 07:25:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8586B0007; Fri, 12 Dec 2025 07:25:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA496B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:25:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15DCE16011C
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:25:16 +0000 (UTC)
X-FDA: 84210739032.12.AAB34B4
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3040A140005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:25:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=avJC2+DB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765542313; a=rsa-sha256;
	cv=none;
	b=FI3ImA09qa9J6xxHQ+mXGMoN34ZnwCljOxFpOSZLI3fPofjy1DBxhKNkSo8sh7r/pKq/21
	znjMUhG5UyWHTp/xISqUWCJSqfmLrIh1/WJ1QLIaSTiw8PnyrNgEEDAtkdcf3PP1sdq0Ri
	l1TSrRIy7xrL09oREIFHShiloRukUwo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=avJC2+DB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765542313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2B5KGSSgpqbVQsLfnIbvylo11sIFz83vA5vm8hf+AU=;
	b=SQdFvn+nkVzXR5/mUAeH0cwEcs47raK38hBUggXbEZtI8uLelXx4LQi+UoCET9XaY/X4oa
	y7tzPpgAQ8OkJBVTxdM3drVBDexmQ8JyTIh1bCR3R+gh7VgEDfUGhx+kncODHK5EMSUT+1
	00W1FwTuLDG9LoxiRMwN82aLWJcsYIc=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b73545723ebso210107866b.1
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765542311; x=1766147111; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o2B5KGSSgpqbVQsLfnIbvylo11sIFz83vA5vm8hf+AU=;
        b=avJC2+DBlGQnPJOhm/3MvhtmjUzSV5pmP3u1VKxAMusS/iO1iIh4TrwIaIWMsiK1e9
         Cyo8Uz0T8gdczUU+MbpN82RftnoSE3nYjwEfHQyDyQ788MqHRKTe+ag4KTgFK3v2IsLT
         h8+a6qS0A9DYWGM9TQqXdOQFck7pNUhVT2SiWKlBgzcs3DP5apC+UV2EBFpdOQDgj1DT
         yw+Li3ApoVmDVgBJqN03isFcFF+AV9a5J3IXIC0CaYteXCyw/lyfD/OD+5G1/+m+ul3L
         z7d0RmuJhCCStcFryZaI3dX9CG/Rtm5CcmDAfUWyLLcWshRMzm2RaeEiqUrn+1A8ueE1
         OAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765542311; x=1766147111;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2B5KGSSgpqbVQsLfnIbvylo11sIFz83vA5vm8hf+AU=;
        b=jbpKkKfnN4s63r5/AkQcQ9gaipFYmS+Ts9BEuAtZDz7pb+La6s7USdULkclBs05Wgv
         FNQPmK7PddIb5GISi3HG7IQPaKHT6gi9PdkTqfr6hDQdSNEtzJWK2hDNLs1ewGBqD6mb
         nDmefFiVeOSXyzlcVB+w67FM3RGQG8CHE9DzK+uRdMsN8fRYQ+iMn2if6F3RqCaSozQc
         7NqtCC96TalnWHejhIy5zrBFHsOa8hHtMSdSra40HYiCIkmwE/OIhvKzYLZlFEMwdCPw
         RqKE3GYyNuRBJGaAoKxK1lgGAks6kKd/S+R/SuXMQ4XkwRfrEwbys8gK4Ilh/qTWRlNw
         UfsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXr7TnCr6dJFjsV6I5dzCIfouryt+x8u0uaD1sefIjdM7WPae9N1vxgXsH8dLXk7LFwAuePXB4QOg==@kvack.org
X-Gm-Message-State: AOJu0YzRr6iZZk22AKZHYcWFtNjjYb1mlcNFecoqJGF68KAAdybNig2n
	M8QSU+5dBRshm9tKb3dChkf3bDgcMhZ2tlN0XHwkVUZnPuPnFXAfP7eahhtbf06rQfGYtJ8BZrO
	08Ye+iL5mX+759sLJ9p5m52BQ+Zn47+c=
X-Gm-Gg: AY/fxX7/ZY8NFHsmMC0SUtdkqEIo0JIrIWgDy5WlCEVk76ipdJqpStS1n9jmyK4mnc7
	0oX8d8tO9dq6qvMs15AKfCgy7JhFDTYdmzS7i6DX2cKOeiDzBuEG6bc+k6LoJ+/GYBR2hgiQz/G
	dM+9IR2emDld+qzMGMCuOT1eKrQ7oTjtsB6dc7r4svLwi02zr3eZ3pxN6MzChU5nDMwN2DvP7LN
	gEDb1rOrqzkwSj016Fr71hio4dmp2NUmGbKqbQgp/zVi7fR6O7+tQAHJcheLOnq/ewKg4H/ulko
	vpy4BBloAKYbie2kjxXyi3gYNss=
X-Google-Smtp-Source: AGHT+IHtPTPqM6dw5zzwfpVCrXHy6cLoGesd89E3gnCTycntB/Ga4Z8Q91hytn/mvnR6kQDjawu1VndVqXEOuM2AKLc=
X-Received: by 2002:a17:907:7fa9:b0:b73:737e:2a21 with SMTP id
 a640c23a62f3a-b7d23b1d62dmr194414566b.54.1765542311238; Fri, 12 Dec 2025
 04:25:11 -0800 (PST)
MIME-Version: 1.0
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin> <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin> <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
 <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local> <7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
 <ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote>
In-Reply-To: <ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 12 Dec 2025 13:24:57 +0100
X-Gm-Features: AQt7F2qEtJQL_ss5biK6_DWUiy7SS13hcWVeIFziTVpu9fwvSxanTRV5-vuBYE8
Message-ID: <CAGudoHHFeuEQ0kBYfrYuUPxNQdw4YHNG81JiHPFHq0evUcEczw@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Laight <david.laight.linux@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3040A140005
X-Stat-Signature: ag5qsoof58khcia4zeu8nq6cxh3g5iaa
X-Rspam-User: 
X-HE-Tag: 1765542312-589497
X-HE-Meta: U2FsdGVkX182GdAM7O3ua6yKpPHBvaS3RuYGZS+bRRExj9Aeqk7B0lXGnGcUZ/kg4XDfTOA3ESXaxwcq3/FZwPb0f4A5Gejb+IiSKIDlWM5j1hR7coQu7PCsodC9lmWEpYVgqTQihsFzTE3aIov+S4Cpf3f15xzL5+dP6sKHKCAB+gopcSiDIAb7zKBrm1qG0TxEW5h8Q+LNPjyjrkjWG0RlE3B/9zisL6RodkmUogjXMPT9aPrYO3E1ysLdonFvsunYdZfK1I4hjao4bHu1IEFi6qlWz0tSUsZNsHINfHzQps7OHL6EVnfhnAz+OKbiRFPrNHMZo9O+74u8DlodgOjwnVcmIhXeGFykBPf6hRLSKF9kZhMAJXXB4j3hgUodbvgFKv7X9pOtmbesuKoBtRczRIPmMmLAEfw1812FbS4EF+oLK4xz5khLvG8kCjmv6pIEwkjs4UZ6vO+vpNtMWQNCSquYsHyyY+i3vJ3gm6AuwFsBCK+50pqwTKJJx9pv+0fEbJE0e0+bSDQFUc6SwFyG2D+LgsQ2gU2/tNpuqJVWn3ZMUUvvoTinfEcpve9523Ap/1qnU1G3AQVUtVRdHpYtfodGCb0P6whqpH6t0dPVFOHw034fhHexxy+SjHTU84j5GcYIUOdDKs3KHnQd89j/iilcV8JX7wx8zuNhXOIggzoQ/8kWmU0CZSvwduC98liYQXPt5WL6chi4Ok4PX6zcHx+rggb5G8V2qTXb49FwULOs1/w0vTECJvQO89fgP4JyClJBu6bpHna1DXqpHmO0p9cigmScN37umizzLhAPW3EujqLOnc5tF3krEarLTl/c3Eqg+tSs9sZDz5449S2KJ/aS7MWWxPVECnEUC70MY++1O2UtP/G+YSIyMVTSsBEVIpUYYzFHd9Iv9v28djVqKWKe0At1Hl24WAuSZ7CIocaMRVtp2jk99nGIglCf5sTDRTyNRJQUTtRzFbB
 +V0EgJZs
 gDQif3YJlWBUeQs1eqwQWPWDUQkwRlm1TmRe6nHk6FPFB6WaOCenRrGBjMbucXvL9T7a0wGXOuwn4R5NuQkiquC7HBosDffT6MXAFQdpyITb+zcGKfg+sZ9C9Bvqfnm92xSavB3VDQL5iZcZ8T+ipRxVn2PBnIJzPBeInk83sIdwsspFykNOOwwfuyzMv5TwIC1HkMnZGA5qSWnfE0yJ/6nyvEE6S6XwWYOQU57JV7F/fQZcPa3+QHg2M+9Fz+3+c1KXpMaMsUmTm/5PLG0/1BUNM7tD8qlbm8yEizms5SJH/bFQLZ4krQapP3GF95tgKLdzWvQzlfLleBpEoOLArPM5O+5TwCKoSLQBTp/QLphvUk8q6ojXwQ67sJ7krS9tmQUUM/meic3yzxdRKhHW+gD7H3ABLf6PGQJW+4mYeVrapGLqkhR96yMo0SSueV1AA8A4T8gZi/LAtpyRAB4g33sa+5ReiJhIR0jqp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So I had a look where the timing difference is coming from and I think
I have the answer: init_ipc_ns does not have a guaranteed cacheline
placement and things get moved around with the patch.

On my kernels (nm vmlinux-newbits | sort -nk 1 | less)

before:
ffffffff839ffb60 T init_ipc_ns
ffffffff83a00020 t event_exit__msgrcv

after:
ffffffff839ffbc0 T init_ipc_ns
ffffffff83a00080 t event_exit__msgrcv

This is the pervasive problem of vars from all .o files placed
adjacent to each other, meaning changes in one .o file result in
offsets changing in other files and then you get performance
fluctuations as not-explicitly-padded variables share (or no longer
share) cachelines.

I brought this up a year ago elsewhere:
https://gcc.gnu.org/pipermail/gcc/2024-October/245004.html

maybe i should pick it up again and see it through

as for the thing at hand, someone(tm) will want to make sure the
namespace is cacheline aligned and possibly pad its own internals
afterwards. Personally I can't be bothered.

