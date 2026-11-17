Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D69F606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GxeI70sm
Received: by kanga.kvack.org (Postfix)
	id 7145C6B05B0; Tue, 17 Nov 2026 11:54:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC006B05B5; Tue, 17 Nov 2026 11:54:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601976B05B6; Tue, 17 Nov 2026 11:54:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1B96B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:54:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C32B21A0516
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:54:53 +0000 (UTC)
X-FDA: 85445210466.18.B948CE1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8932040011
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:54:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GxeI70sm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of jtaubepe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jtaubepe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794934491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGDRp2kvtb93Toj3Qe9cR7ofTSqhSOCGBjvMYhNFgBc=;
	b=F/WPJUP0eFkmRR+gioky9UE+9/NXeNfBMIB0RV8G2N6rTSqStQWNG7Bthp703ckEZaf5SY
	ZKAMCrXJP44XzfD08mOckoufCUvLx/ANaTrRGirZ0pMyOuhefhfeBTVpl9Sv6rsvkE88JW
	TNEFnRIHEC0l3X5R0UmYsqu/G9i+Z3k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GxeI70sm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of jtaubepe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jtaubepe@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794934491;
	b=3WC5IdTwzPtusn+0nCD4Esyrf6OenTniw/ljwRqMQkO7Kam5Gd/Zb7IEw3ORaseDwo2kaN
	eDhkJl1ItoH0uWPjgq0oqciyvh41b4fWDX+TriWEM0AAnH4nZFYFBDvx79ZrvHrvleJS/e
	W/0jopYxBnarfhf6ulkGjsmXKtq2qB8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794934490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DGDRp2kvtb93Toj3Qe9cR7ofTSqhSOCGBjvMYhNFgBc=;
	b=GxeI70smFuGGjiDIh7vO3yMcmHCzcKLwlyAKjWXLQGAlZKUTg/9IXHDaVgmvn7r4YPZkoK
	EVQSF5kGe05gAca2apmoJobYXt3W0T288IhMLPUnBcMqi/w6m8E73ArkjQ9R1w32XoaFbd
	gTBDjjeKadh7n58om+6V0W8fNCH3654=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-zAACHbYANia4_6WfE606TQ-1; Tue, 17 Nov 2026 11:54:49 -0500
X-MC-Unique: zAACHbYANia4_6WfE606TQ-1
X-Mimecast-MFC-AGG-ID: zAACHbYANia4_6WfE606TQ_1794934488
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4916bd6e3baso4032512f8f.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:54:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794934488; x=1795539288;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DGDRp2kvtb93Toj3Qe9cR7ofTSqhSOCGBjvMYhNFgBc=;
        b=P3VfJYtmBEdEPNQT7ixGtdVt4xEcW97kbXLLyia/Rd3hlj04VkVgbT7SmulzWKOspH
         IMdeizcA8jaST+FfhPBrlIDpvqL+2ZvL5kWq7WNUSvEWh8AdvsdmYJDx8xOoYfHbixeM
         zCJK6RAkygtTE1lQOvwJRl4i09qPglrvDziV2UbJysApL+uA4sdpYs/lSigb1EFVpwFg
         lb5GFVgRa5yIWCXWnmGTy6YXkgLRgG0BmTqsDTFwbZ/FPVrG1EWSfXdzZHpwI2LRFIF6
         1DnCjsxLHOYOs/h1AjqehXKuXEX5RcvzQnCSMBDUN634P8iPfen3lS+l7hXAZ2WzvOEh
         seWQ==
X-Forwarded-Encrypted: i=1; AL+hErHB+knrqXVFHD/mnopYm37bAfzDn/smpzvOEnqBdYgP4fyPIsDUC7CtwX8wzzEmU6Au31pDAH3vpw==@kvack.org
X-Gm-Message-State: APuU4Z/g4Xsk9OZt3EI6vsyDnFhFKXbtTXhRDTdiPQ1pQ0N4qo/Ebrg+
	XV2o+J5kiw+UCmu65ELrD/FtdScdAJ/H7vUgnA53jJeATVa2veWEZid7XM97E7jZ9NYw/Uprhn4
	KQmKt3MemJQxhQYUcBM0g7HL5xp82LzQpgg2LfqiY1outYT1hW1vbgcvbWak6oFcufCD5o3pAz6
	yXhPRtzLHoqpGTbNUv3KHp8eDowus=
X-Gm-Gg: AYBFou2Jh5iXfWXSzEJaav1oW0JMt8tIUI8m42P1Z5cPj2dmiKqgF+aBLrVkUt2i21Y
	YIv6Lw8iTT5fI8xOqHpFgWaK6veGCd5R5FDGmy2c1j6ReFGyAIpZFEHs4eO8dqIKRO4/sbtUg0L
	QxOU3oF/tcJ5iaJWXVxmJzCuMbLJOjdIUWB9uD2hntUpefk/Lx6Itzh6FclJ/2hkgQe6095Ss6u
	WsOli+3bffXFsM++A==
X-Received: by 2002:a05:600c:6986:b0:4bb:6a2d:b438 with SMTP id 5b1f17b1804b1-4bb6a2db52fmr178231755e9.0.1794934488534;
        Tue, 17 Nov 2026 08:54:48 -0800 (PST)
X-Received: by 2002:a05:600c:6986:b0:4bb:6a2d:b438 with SMTP id
 5b1f17b1804b1-4bb6a2db52fmr178231035e9.0.1794934488110; Tue, 17 Nov 2026
 08:54:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com> <20261107023917.40606-9-himanshu.chauhan@oss.qualcomm.com>
In-Reply-To: <20261107023917.40606-9-himanshu.chauhan@oss.qualcomm.com>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Tue, 17 Nov 2026 11:54:35 -0500
X-Gm-Features: Aa3M54roB7QDb-4IN47SMi2aVS10SiwVpvGI_zdHUzKl8EZH9k7SzFLp96gzPDI
Message-ID: <CADRr4bc4v4Uaf2_1ZRFJXoru6a=g+PEYgKKK-vEzXgmV6bXqPQ@mail.gmail.com>
Subject: Re: [PATCH v8 8/8] perf tests: keep bp_signal memory accesses visible
To: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>, Ingo Molnar <mingo@redhat.com>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
	Alexandre Ghiti <alex@ghiti.fr>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZrLbxwsnvqTEvSwZpJsqjqDWngSIbr7nvIObkzZhrhk_1794934488
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8932040011
X-Rspam-User: 
X-Stat-Signature: 3uury1g6c59xrb5iibbryjgnzcikh3yo
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794934491-936256
X-HE-Meta: U2FsdGVkX19P6C5t46D8FbnFVFxh9lYzXzilGMmVSXH3D1uuCxj2Opk0ZW8hlJ3xCtPrKqwuf5/BH3CfOVp6Ymt8c7EzaF+/yR770pmJyPhsaxpYy90us6hqWQr4U6PtOrjIHdfxoHwxlrOxThy2GxOupuFgwnr+4uYY4oQC9YkrBQ9K1jBU7RroxsMsgepPss0PbGDflcz17n4wT5dW8LW5e68AmRCqyJWc7j+BLsyOSc4rnNRLC+9HEjGx1Q2V/XXA+qurTH8Hr4YFTyEy3cggP7ubWg38T4E1eyETg9pfWl6xitdGCLqfuCDvcc311QFyYuD9/InppmcrGhMUIij63jhGhc7fPS3oXkBKEddPswxld19Sr7XFSmMaxQuUEDJoNgpCc+cLtjtuGnv85hjuFn2IwilOeNxmvU80Jmsji+w/AAQ/TnKv0GthREuJnIGSsg4aj5U7q2JOh4kAl7kq2b83n/ZHOepOVyBgMLvUnlMxrDN23cZkcOeN0wNZ8FbBePfRR9AdMSkv3LJtfSHvKqbNJWxDost1dAVa8oNfmasfI2SAAMyZoUCW0SAjlM6FqlABidB3mACkngUTaMv3Xv0jVAa44lXMAvlI/KkRCkFPGGlsU2LbLjv/XJZld/0v39PLgj7+TrJInSoGUhwRKpXtoLns41vxJ4aZcJXtKeevFTyC0/Th7V9IHD7mRtF8BjDeyLxXbTB72YNz8+1X/oE2FenySHr2OVeqJbQ7GK/6hlVzHQDo5v0fToCm8IZJVyVM8xPzg9FARwDWKTyPk/Ygoo5c72bpeTC/zFEZvCbdCIe7akENHG8BMEopWHFOQGY57d+8bj9N7TM1Ry5rq2qWST8JUGldAgQHKrtOGolc+HaF08aiRo9FkKcVWrel1WZZce97o9KDNn/98hP7JFhP/1wgySa7+cDKcBdocTJg46lGA347NoMgB1Z1WTtWBJCEBm096O14F+t
 739Zd878
 KqOJ8OxqT2nszw7DXxhA6DSd6c2L/X2S36M00Lhg817rcFqGgEEAwLXDE+fBVAlvEcctuWxBie7lMKy0Q98WW2y9LlvSp6YkGMqzw3/wFSw50at6trJGV9nTcD7uXZLM56WsoPvxK0V0k7Bx/t0TET2IhL4nh4dPCj5qdVxehMtJ186wMHYEXc7foReG/HNNeBCmoL//GCRbK8DOH2yGF53aJ3ukryAfrsDXexTaqTd1yltY5dRGVteiVhQVvDbKwAFi5OZxaacHJwcVlhjEqfUNfd5W0x1Bgd9gTAlgRF3Okk9G1m5Lw7R5w/dnB2T8E4S7WguIHVcts7I0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 9:40=E2=80=AFPM Himanshu Chauhan
<himanshu.chauhan@oss.qualcomm.com> wrote:
>
> In the breakpoint signal handler test, a breakpoint is set on
> __test_function. Keep that helper as a real call target so the breakpoint
> has a stable address.
>
> The test also relies on the watched variable being accessed as distinct
> memory operations. Use READ_ONCE() and WRITE_ONCE() for those accesses
> instead of making the object volatile, so the source marks the exact
> operations that must be preserved.
>
> Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Reviewed-by: Jesse Taube <jtaubepe@redhat.com>

I personally would send this separately so it's clear that it should
be applied to the perf tree.
Thanks,
Jesse Taube

> ---
>  tools/perf/tests/bp_signal.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
> index f580ba7486b1..2e4f7747d32f 100644
> --- a/tools/perf/tests/bp_signal.c
> +++ b/tools/perf/tests/bp_signal.c
> @@ -36,15 +36,14 @@ static int fd3;
>  static int overflows;
>  static int overflows_2;
>
> -static volatile long the_var;
> -
> +static long the_var;
>
>  /*
>   * Use ASM to ensure watchpoint and breakpoint can be triggered
>   * at one instruction.
>   */
>  #if defined (__x86_64__)
> -extern void __test_function(volatile long *ptr);
> +extern void __test_function(long *ptr);
>  asm (
>         ".pushsection .text;"
>         ".globl __test_function\n"
> @@ -54,16 +53,19 @@ asm (
>         "ret\n"
>         ".popsection\n");
>  #else
> -static void __test_function(volatile long *ptr)
> +static noinline void __test_function(long *ptr)
>  {
> -       *ptr =3D 0x1234;
> +       WRITE_ONCE(*ptr, 0x1234);
>  }
>  #endif
>
>  static noinline int test_function(void)
>  {
> +       long value;
> +
>         __test_function(&the_var);
> -       the_var++;
> +       value =3D READ_ONCE(the_var);
> +       WRITE_ONCE(the_var, value + 1);
>         return time(NULL);
>  }
>
> --
> 2.43.0
>


