Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5D4606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FXgJyB2Q
Received: by kanga.kvack.org (Postfix)
	id 85C8F6B0AB7; Wed, 25 Nov 2026 14:47:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D0F6B0AB9; Wed, 25 Nov 2026 14:47:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722A56B0ABA; Wed, 25 Nov 2026 14:47:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45D7A6B0AB7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:47:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 478A8C017D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:46:59 +0000 (UTC)
X-FDA: 85474674558.02.2B8FA05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B9B812000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:46:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FXgJyB2Q;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795636017;
	b=79+pQcbK8YT1yzNYUeYPNOcGZb7kDaq1MDH504smCwpnVFCZ8Sd9ZpLoADENbqZ+9u3Idc
	EptHKuYO3Ath9RIZT0Asq2U9SzD3tnDcfO3L+yZzbxHvSJk2IaJffD5AjPZDQTgNfIWg1Y
	fpDjneYEGi94asKJt77Ya1xrJp/67ig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795636017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzmgNFA0iKS+jumrdmlwlbdpeFh47bs6LrqFms2QcyU=;
	b=L9wjCWkW+wHJ/Pe43uZdfwsWeXXuUWlLj7hJdSffqPhAu5nlLwdLm0S8Y/SoX36C+t/Kgm
	xFL9cmTqArrHvvnbweoZAnMIEPyBUONR5kMRvcZcaB08fCrhOANlmMEHmmGKXmMyEzTySc
	7Ahf7aqaQlIrjeYXccrC8D7HrRMnSj4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FXgJyB2Q;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77B3A4646E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D4E1F000F2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795636016;
	bh=wzmgNFA0iKS+jumrdmlwlbdpeFh47bs6LrqFms2QcyU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FXgJyB2QGn/jP/5E6lWvlFKjaAp1XvwnMfFvqmKtZxRet4mISpf7FgDqHtLB9ZjCw
	 DcmtrRUa3oATOZqs3ymhCZj5WyVVsHb10lcxw3GMMeFkW0YacScqds0G+O5rSlIqxS
	 +l/3WOx8hqueQQcY7zLd9ou1gqKdvCcb8i3DBnMTUMQ0jllpTxK7ugt8ADJt2khTKl
	 yaC/8IpxPDNbDt9kk6rhFjMGZu9WxuCDKxrED8f7EHBcB99847BEpQx1geRh3ckkhm
	 VJXXGVFZM4LrH1VJesDM5gCMmiGFk3iW9X+XBx8ymo8xf8vzdwtep99AL89Yr2ivna
	 SfknY88xQIWow==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c516a574bffso72857066b.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:46:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEajiA18VNDELdGk3QMvH20uURaA4nMcx7BxdMVE7npbtlb8HQ+KzFSssdod6IuKAo+1KKIkv85bw==@kvack.org
X-Gm-Message-State: APuU4Z+4Jp51YVLiLo9SGasSpGWHR0Pa8K5g1wmQAaFR7EZD/H/WFq0H
	Ewdh+Pf7rqa9DWi5JOJXCoGyPGTHUXRxYbeBfFq/IWf4X5gq0/k9Yii30bpej8r/Nj0KyoDLCpo
	OoDJa+KX6TZ0KL+Ti85WBiicrtdjya58=
X-Received: by 2002:a17:907:7f91:b0:c50:c04d:cbb4 with SMTP id
 a640c23a62f3a-c513ac9f641mr1641402066b.43.1795636014987; Wed, 25 Nov 2026
 11:46:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com> <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com> <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
 <awZt7P_p-GNZ3A2i@google.com> <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>
 <awcK9oNDbc1QFJr6@google.com> <CACpmpoenPZ_SqhxL70r8q09WBfrnqvPu3H+F8Tz3nVwO=rvUTw@mail.gmail.com>
In-Reply-To: <CACpmpoenPZ_SqhxL70r8q09WBfrnqvPu3H+F8Tz3nVwO=rvUTw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 25 Nov 2026 11:46:43 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP3Skc=X8+cxnV4V=CKaAqcndnAVniMvcfeOHVeSk4oAA@mail.gmail.com>
X-Gm-Features: Aa3M54qLwSXNnEFYYZN0F3oYiYtn-3ATn2o5XyuwKkol_nEWwwxfcBqUZ70NKoo
Message-ID: <CAO9r8zP3Skc=X8+cxnV4V=CKaAqcndnAVniMvcfeOHVeSk4oAA@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: 5B9B812000B
X-Stat-Signature: 91wxkrequ9cres51g8huagjmuga8xhxu
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795636017-468441
X-HE-Meta: U2FsdGVkX1+noHJIl3FC8IE88rI9TDEDERfpQHNmjIoK7H88gl7av39zE9ynhbvHycNLrnrVZeSRB0EzpCtnXn80lixIOaVJ2dYbrXCVATKTouUKKOT8Tcs29ip4LBairYt7q6rIRuvl0wDFb8JTX+MGLjvoB9Wj+Hwv9EXcYQFo2dMQdc2WOcIJ9rWKLWYUPtJXlLODI9h2RBncYjFo8piBcQ5no+yPw61azN7wgIK7AxZBhCnx9AN/6Rv/BlXOfuoSVfdlSAe9vUw04kV7Yp/vLr1gOZzDIUeB2KW93Qb0Vm+NDgXnaB/fy4TRwz4ZcFkGgZ/vcHZte7hH2egXxVU9pJcw0pSUW3JnXuNlZRQtig+5pr/cpW/QIEJOOR1YQit3wuWqscqdWWM/D/nfQYzciQSqczDPmVDhfCJFvUxMtCvybKcFlinqZ0lV6YGOY4DrhwW8AsEFT+w3J1G2PvsPNqeHM8AbEhqpNa85X9nbTfXiRSBuymtlGYur9HT1wLV28Iz7neH9XZkjLF71DUFLWXpCe67xZ2ZQB8EUYq6EO4fCMHAHHfFqBHbHAxVAGOSBC48q7gVtVKZb5LvdyogkPlDirzy6F4xkadmrmOqgreUudsVpuiesWwRPFwDu9JJyxiI/YRQ0ekHEMNyu/QgSMqCClia14iwk6FQAwtRo49A+C6wNSOUZK2tXajLC5smbvHTxmAgEcGN76SS7c2p5YcRSYCgTpX4bZFb3vd38tTvFLvdhEwhHSMZ1QaL20DUc+M+HaBjHnHDHffP8VvDu8ZAqHVcav+ojZtl54xKaK916JAolaWNmAwLtwy4vxxcsnFu6Kuck9hP9brs85748tG+CEqweXVBj1cnvUy5GZ3ps+LKRz4CXv5y/vT3pXrfLXIADN/uH2xspX3K7EeIZmFJhauIPMdNiDpiH+S5BTGSSs0A/fdli0qEBaTnrCm2BxauIPyZxsUtAURQ
 caCGjVWk
 tz5heUu7hKp22XG3qC7GIYHv70bMKYIF9Buu1LN5UkcMsTH4SDELx5os0TDD5wmn9VAV8HQpC6ATMxkmWLIQiIglNo+KwB1ybQNb5IdDbvYNuTzc8Esx+cGBa1vg1eQye4WX7Nl7h5Fs1ZIhv8OjrcR1pq5ErlrGZZQLJylqXEltckJJfuS4RA9vv4lIpCB/9WHrIfiE149dJ/g95m/Ia0nybjUiGB15IAg/sJBDdgzfdtqVh5/qwPxN5cWexKukT/4K/7kH4BT5cn2lst+o8UxzwgZfq1vLBZvuIbEmd9uKFZHvph+y0rvK57HDcPv5+ZxuZs8BdCcEC3hnnAPhu66xaMdqQupdwMjzuGI7fvuapAyFSBqkH3QRTkIax66VBsDVPedqX+qvvhQwWs+aVdai2garvgTGWI9DmwflO+WKI788FMloWhljF9XwmHvepXjF0X1a5+Cil85XD3t5uw6pHT94GeDjp93qG8R8hd1vXLam2J6DX4FqSRXkaTTtO6h4+NPNRBuvbqI5KgQfdTHUzNEj28Na0nGzsgtAitjLTQvMcvW4QeI6mGEMeiofCkLOv1GxgRMW8WAlRJ8DfxPM4TmNEg+XqKGtX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 10:06=E2=80=AFAM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Wed, Nov 25, 2026 at 8:31=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > [..]
> > > > write_s would be calculated averaging the time in the ".. bytes / .=
.
> > > > usecs" lines, and free_s by averaging the time from the ".. usecs t=
o free
> > > > memory" lines.
> > > >
> > > > In this run:
> > > > write_s =3D 37.31 s
> > > > free_s =3D 23.39 s
> > > >
> > > > With your patches, I got:
> > > > write_s =3D 37.03 s
> > > > free_s =3D 18.86 s
> > >
> > > I am not sure how useful it is to apply user-space gettimeofday()
> > > results that time many higher level C code API, as an indicator of
> > > zswap_store() performance.
> >
> > It is useful to see where the time is being spent, and it is consistent
> > with the perf profiles.
> >
> > [..]
> > > > You can see that the cycles spent on zswap_store() are almost the s=
ame,
> > > > and the cycle reduction happens in zswap_invalidate().
> > >
> > > The cycles spent in zswap_store() should be normalized to the # of
> > > zswpout events that these CPU cycles represent, for this to be a
> > > reliable measure of latency improvement. There could be an increase i=
n
> > > reclaimed folios for any number of reasons, all of which are not
> > > necessarily due to performance-improvement/degradation of
> > > zswap_store() itself. IOW, more work for less latency per unit of wor=
k
> > > is not always indicative of a performance degradation in this case.
> > >
> > > A realistic scenario would be that with zswap_store() becoming more
> > > efficient, the 30 allocating threads cause more memory.high breaches,
> > > that causes more zswpout..
> > > This would cause more CPU cycles in zswap_store(), but the fact
> > > remains that zswap_store() efficiency has improved due to batching.
> >
> > The zswpout number is almost identical: 45,796,107 vs 45,796,089.
>
> Can you also share these vmstat/zswap stats for this run (baseline and
> with patches):
>
>  pswpin
>  pswpout
>  thp_swpout
>  thp_swpout_fallback
>  zswpin
>  zswpout
>  zswpwb
>  pgmajfault
>  2048kB-alloc
>  2048kB-zswpout
>  2048kB-swpout
>  2048kB-swpout-fallback
>  zswap_pool_total_size
>  zswap_pool_limit_hit
>  zswap_written_back_pages

These are the ones I have. I only enable 2M mTHP so I think most
2048kB-* stats can be derived:

                               base          p1-8
      pswpin                      0             0
      pswpout                     0             0
      thp_swpout                  0             0
      thp_swpout_fallback         0             0
      zswpin                    265           247
      zswpout            45,796,107    45,796,089
      zswpwb                      0             0
      pgmajfault              2,811         4,231
      thp_fault_alloc       153,600       153,600

The increase in pgmajfault is unrelated, probably because I dropped
caches before runs and these are file page faults. The number of
swapins is ~the same. zswap_pool_limit_hit, zswap_written_back_pages,
and post-run zswap_pool_total_size are all 0 (consistent with
pswpout=3D0 and zswpwb=3D0).

