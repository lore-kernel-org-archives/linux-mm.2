Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DD3F9D0F2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD8E6B0088; Tue, 14 Apr 2026 16:44:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF346B0089; Tue, 14 Apr 2026 16:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D8F6B0092; Tue, 14 Apr 2026 16:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB5E26B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:44:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 957BD57021
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:44:33 +0000 (UTC)
X-FDA: 84658339626.19.B4DFAB4
Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC194C0006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:44:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=tp0oFwTf;
	spf=pass (imf28.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776199471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8bWJr7FXUdlTXBxL69DdsJ20JowQnELYHkBWQ0j71o=;
	b=pIr/crKYaabJLtYUnW8NgDWC9vQU9I+rPiy/X0gMS/2tJcCAxkvjSU2CCwj5x2MdzcaE6J
	cy47/Y72yPHeVxPV+T95RKOB8kw1aDqfllZzKQ3zGVPOyLCWEhS7X6uBKV9/FtBEtOTMT/
	8J9rb1vj/cxNHbUg3ZRGZIqpZj7NTCU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=tp0oFwTf;
	spf=pass (imf28.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776199471; a=rsa-sha256;
	cv=none;
	b=lFpBTJVoOPpFnsqtlxNcmHd1Dys9au7ukXl5Mx01N+mRtuuPwf/WSocAFAAerI/Bni3bU5
	RGYGllMPqrLlXRez8cKJ4+Q7/h8wcu3czWGeYIg8zMBD/fyxcPoSUFHgLpBwNdJhZyLpFF
	7XeksAinkpzW1/BFSSr4QUNl1eiuyJ0=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 36C6FC5AAB7;
	Tue, 14 Apr 2026 20:45:05 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id CCCED60410;
	Tue, 14 Apr 2026 20:44:27 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4D13710450F98;
	Tue, 14 Apr 2026 22:44:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776199466; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=L8bWJr7FXUdlTXBxL69DdsJ20JowQnELYHkBWQ0j71o=;
	b=tp0oFwTf5VHzsnEQcoI6YFXubpXr48s6UWlXK4aDR8EDMSSF+/OjNf6hUwJE2BAbHAdgPz
	v2f4A8tTxVtK7dqJZfFAdjP+hWDl0Fam9eGGy91tNDrdqr1jGCVU5mlUKQsx7dKkw5Fj/o
	8xB9Inm9XOYYzG+OqKhmNW03MF+ALRZMBSynxDWIF5QBxopuN97KxRbIxhOyfKSB9o6wkS
	91454gD3J6J7wN/TaEOT0JgO64Dp+ztksnjtLIOwoMGIkVJ9RQPJZYo6iGmJA9iAtEHlyl
	YSu689PmkWekOvBlF+bpB2iuXK1nNSBHe1tFVeClAIGo4vy+Vjuo6lCfP898kw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Apr 2026 22:44:13 +0200
Message-Id: <DHT65O6DS001.14GNQMXFJZHTN@bootlin.com>
Cc: "Andrey Konovalov" <andreyknvl@gmail.com>, "Alexei Starovoitov"
 <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "John Fastabend"
 <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Ahern" <dsahern@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "X86 ML" <x86@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Shuah Khan" <shuah@kernel.org>, "Maxime Coquelin"
 <mcoquelin.stm32@gmail.com>, "Alexandre Torgue"
 <alexandre.torgue@foss.st.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>, "Dmitry Vyukov"
 <dvyukov@google.com>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, <ebpf@linuxfoundation.org>,
 "Bastien Curutchet" <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>, "bpf"
 <bpf@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, "Network
 Development" <netdev@vger.kernel.org>, "open list:KERNEL SELFTEST
 FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>, "linux-arm-kernel"
 <linux-arm-kernel@lists.infradead.org>, "kasan-dev"
 <kasan-dev@googlegroups.com>, "linux-mm" <linux-mm@kvack.org>
From: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
 =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
 <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com>
 <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
 <DHT3JV7GTOBL.29205LGGNEDSH@bootlin.com>
 <CAADnVQ+c9h_wuNwj8pjx885oNErGY7bxxCwKi+DiJ0XKSpyYfg@mail.gmail.com>
In-Reply-To: <CAADnVQ+c9h_wuNwj8pjx885oNErGY7bxxCwKi+DiJ0XKSpyYfg@mail.gmail.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Stat-Signature: tu6chioyyjmdsfokmmg97ogdkethqhd4
X-Rspamd-Queue-Id: DC194C0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776199470-777128
X-HE-Meta: U2FsdGVkX18e3T8E8PQCKolkMVk3U2m8OGf5Og72KXHqyKtUNET6ciSthXzWyh5hPc5dXUISI7/nWl73LUpsgfR6QhAnO7kjjSyUAFzOUj2E+R/pTu0IfLtNXl4B9Bh6vBBaDp07615gQbrk5NQYY/9NijA+qIC+7DpviCa1k13JTfnkNYmlxTx5NU7GFzQ59JPp8/oIJjmjww7ozqW2wio8LfPZdlfoZPma8q9rk0jMZMPYCsRp+u9BcMk3VAYHCanIGBf/J4y+m5TbOIzPNHVCcly/V7uv2k+h+L+e0jhtH4eJydJYGf37sxN3WtejADf1i+iDnk0J+AxqX5hPJLn7s40tTCBvbtVkNMYLzBt+t4eUAi6v1ykTjhRk8A1pcy5y6uiM36WkxAJi9BhDxld/wpu7+6y0RuRsdExkkZSY6D9rr6RHhmNTCCX92JjOOnEdoN0IoblzAkMfukOiJxcCkGnfMWpuruvN3Zmt/iPunbcCEZ1JheUCygoIGgmRNkrhOPUZW8dn4HGuKnGnRgQipYjKxHrAesIpCYSOOP15CWzc+6GkQLncVDa+HsgzOG9oQ6p5Mg9D9Q7pWRRgewao++asJdZAMjJ03N3IeyHyChLMayYZXKOlp6oY7hNYdCraFW54uxaTitFiDZ8IiXmc9kRkHVwSLVLTgsd4KgJr00FgiXUycIwBqEAYEsh3FKtJY3vc7qGARNTn728RbaZaiodeCQgv2KNx6anI0t0Q8QYUkyejAKlibg6g4Z2ugD0Ht5cGDvERAFqQgpW9gLEYp+Tu8B9JGLncpl/n8YyifC1N5m+E8gJPjfaL4PzKJUpKiPT0PfsAThZyzt56RvCQVFDrefdy6XJdkNo0hPRVL4epee7p/IJ+ZXFA0sleRG+9eZDcLKKluy1+60ZSJqdJKPgebU7OUyg1XLSi0n/658kkO0FqN3ckLQ9ndbiaQAQHNkizMrZRUm6YGXZ
 O4fCVxHG
 tkBWicidR9gJg/ngdGC0OHqwHOgy3L7XFR9+Vmi+fnip/MeqN7QIDWhl386y0924lOI4FUPU/1YHHtdrX/MRtAuDb6xcoFhKmzivvNvWAHFT06WoS2AGeHNCN7gO48JQHwE7Pxt41mljlkhODfUKuSpzxxJdJNnDTXt4wiXmGhyXZl94LvrbPbHth4UjaN7kXH7dmRoLkYysYp/v03dpTxhvBdJpjisa464MwmU239KJCY5L0BKp+QwYEpHV9oY3N3SblmIcVlT4+XYl/0aBqeEiroo88C3z/fIvp5hReIm7NASxGLr9duIgSueo9RgnMmDkQStt1WCIUjCNJS/pcVqMk77PvYdEKTcYOuVhdWbvQEq754rmqqv+J5QiTcy90le6JLbbVj26q/X0MOHrOG9U6oXsdjewHKEcfPMQ/5VHyrkEtTAfeNTQIo77ZJw1jJRid
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Apr 14, 2026 at 9:16 PM CEST, Alexei Starovoitov wrote:
> On Tue, Apr 14, 2026 at 11:41=E2=80=AFAM Alexis Lothor=C3=A9
> <alexis.lothore@bootlin.com> wrote:
>>
>> On Tue Apr 14, 2026 at 4:36 PM CEST, Alexei Starovoitov wrote:
>> > On Tue, Apr 14, 2026 at 6:13=E2=80=AFAM Alexis Lothor=C3=A9
>> > <alexis.lothore@bootlin.com> wrote:
>> >>
>> >> Hi Andrey, thanks for the prompt review !

[...]

>> > No. The performance penalty will be too high.
>>
>> Since we are mentioning it, I did not consider yet any performance
>> comparision/benchmarking (and I am not really familiar with usual bpf
>> performance validation practices for new bpf features). Is there any
>> existing test I should take a look at for this ? Maybe some specific
>> benches in tools/testing/selftests/bpf/bench ?
>
> So far everything in bpf/bench/ measures bpf infra like
> maps, kprobes, tracepoints, etc.
> We don't have benchmarks for bpf programs.
> So we don't know how well JITs are generating code
> and how much inlining done by the verifier, JITs actually helps.
>
> Puranjay is working on creating a SPECint like set of benchmarks.
>
> For this kasan work we should make the best decisions from
> performance point of view, like not wasting unnecessary call
> and not saving unnecessary registers. btw in the other patch
> I think you can skip saving of r10 and r11.

Noted, I'll do some checks and tests without those two.

> But we cannot quantify yet that avoiding extra call gives us N%.
>
> You can micro-benchmark, of course, but gotta be careful
> interpreting the results. It might be too easy to get into
> thinking that JIT must inline __asan_load() for the sake of performance.

Ok, interesting, thanks for those details

Alexis

--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


