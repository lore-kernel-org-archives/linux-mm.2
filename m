Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02DC3EA719C
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 13:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256476B0307; Sun, 19 Apr 2026 09:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0556B0308; Sun, 19 Apr 2026 09:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080AF6B0309; Sun, 19 Apr 2026 09:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5F456B0307
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 09:14:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F9251B88C8
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 13:14:18 +0000 (UTC)
X-FDA: 84675348996.21.C8F7EEA
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7589116000C
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 13:14:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b=PySisiO6;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vineeth@bitbyteword.org designates 74.125.224.42 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776604456; a=rsa-sha256;
	cv=pass;
	b=HjP7J2ytpz1OtbGuc+qOfRkBQgH4TbqhviHloY1RGmNSmC2ybWZJTsU9hwFRk+/cUPz/xL
	VW0bM7o3/9xI/E/PEbJ9ENTUIDcd/moaXSAK0TulbtHMOVkPva3MMw3ROrTxPuZAivzrqV
	M4/xaTrMm+U2D5Nwd+BfV3Fqi5tOthg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b=PySisiO6;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vineeth@bitbyteword.org designates 74.125.224.42 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776604456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
	b=Hnw9udwghfFT+xcvJJAN15xiBFuay5XpZOa7C/jSaGfHA7dIvEVH8q8AMUlmMirwMHhrQY
	XePR9Vtno2Ee8yzAFBh39Ib9aYBR9oqTx3xHAfgxeYSJkXkVNiAa9dwC8LMLsTvKBHYApD
	JkCJdjOoPstsDrBdtiKHvSPG3EUmBpk=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-651b0eb2564so2193182d50.3
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 06:14:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776604455; cv=none;
        d=google.com; s=arc-20240605;
        b=YmIYvrCWteiiPv974dZKSjEhWDpUH9JRaW0OI7NtdBi50qiSUlknTDwOzNt3O8VzO4
         6hwwMu6Ll3P3W5KQRGSOKm1rmt4C7wVuUV7o6Jg11KtuRKWUK5AdmAweNVgAAfgAv/jx
         fz6BvyARD5IPBvm6ZXWo0M4Jpsdwwuuw8uaciqwgxn1vsuB4BEdzTLINaH01SO/mQwgQ
         zt1c7Gjm/Ab2j1mJGuLrQTd/LGp72tCmszgahzjn+rdSprhvlRdUennsYVJz7M1E1hFM
         2q/73m0vhFJrDfzMuCqNwH4RdRjIE4kr91PitSP+XCCMT/5WcGMlf2VtB4eidiEGcYP0
         Lerg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
        fh=xb4Pnxm8uKZ3QAyM+DvF9zrjUCwAGW1JAw5xOrKARIg=;
        b=inCkYX2627UxoOP4Yr1dWh0bmEfr1xOKhNfOhTSHXlZFodDFBUIafN1W1oaRfqoW4s
         Y4BjA34cukYh4vuSQudDPwyXzT/l6SY2PnmLFnQwznvPYcToZMQake8Zgsc65ADN2R7R
         B1x147iL0ZULJ7/HLdQINUqd52gF2FJBwBpfxKDcgrFtedgZ0WoPrGKHxE4hNW3yeKRg
         8DeE2Vgo+kUIzmBvp4uS6D9tSJg2CaR7zRdc+7IylCdN6+84PpiP3kid+oU4tgBngd88
         0/Y96Prq3uNvcuPhdzbnGj+Q1whZfbwwdclT68w+a5SZu4D/DiKSHyGR8Sg6tY7jLHH6
         lF3A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1776604455; x=1777209255; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
        b=PySisiO6JS8ypciwAh2P0Lpf6EmEXgnVRF9QZmC2WJMM+pafypru6z2qLjFRLV4mVB
         Ifv6OqciPC+obypG7AGHPYoRInOPl8twiS7sOZo4eA1wcmaPbSexl3BzH8lgnY1CeIyi
         jyPHtL820NieXF9Ojrf6Hhq2e+MfbUEpR4yB4yZroI0CX6EayyOhPoCNMKsfyff4SoLt
         /lpklbkffRo0aitTk5F42uoc3imTKLVh+qzufCpdYKIm2DNylidAD7qUEenhuc2bEY/X
         0v/bION90bcr6R2SPFLoqn6KUCwf+CY8QeeQoX0MxwAYtX6o/KaHB6sRiSPjREPg+wsw
         ybMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776604455; x=1777209255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
        b=VBQRcCQSKZssKk/gmqUPTDl1CshBOhRB/9b8b6ctZqnW/Nf9Uy7s1F/oB9DNinyf+z
         utEa2rOCBWkFEzW/p1MrE7ncz3RGAMAoVauR1xc8T4auzh7tf14R+gzPvEKwM10+zxiK
         VINgNZlbK6eZanhNagzZoxASAdGhKvcNhiZFOlOiTJj6DS1crpP5cvoInBHHVPpegsba
         ZUX2wTFmuufows/4Ie32rdsjOjVlujjUSJpdkxUzceWumm3gawxOxsKP+8dgn/mzVSiS
         sWPyBzXvJlzrNkyFMqk0lOF02jlHbepKXvJvIAFl2unQxky4Z/rApKsoSMkZzFzUqtoH
         uNJA==
X-Forwarded-Encrypted: i=1; AFNElJ+lcCeFURZEGB7wt5FIX+fVrmWKxqeaPpArJuAYRB5ZrmhbtIQW1RrC0dLz+6/7R0zGAGSaIBOhyg==@kvack.org
X-Gm-Message-State: AOJu0Ywvzdc9/dCIr/eQ66baK31ZpasJDazTf2ZbDApK8Z6RcJZclozD
	iGp0KeOwiftcxUdAJXl4/YGRxzg5oT2mwq8ZLm+VzjqlzrWIGKEZ4JTIYp1IqgENvJy57LtDij3
	sa4dRUeZoRD0pRWilE5j1pU+yjt7EHplNQGPQPeA1dw==
X-Gm-Gg: AeBDietZnokAwm4V3Rkoh+O6nu8qhBVd9j0EBeZYqwaNEI8lvagiInCPva4TVX/Zgbz
	Wbn6ZwCiVUCLgItgclIUp1WH/K7mxwG4wXCziYBYd+UFS/M52oAYnHsYhNdaRWmuSjWmLWVUuIe
	uN1F7Tbza4N77ms3P+73dnKTQHyk+tdQZnZR1htymoC6x/pvQh9rbtupkveywrhnrA2WtguzA5/
	q9xSEMAbpPYYnfmm1ov3lbMGo/qVI6ZJ6eXcOM1FIxj/Sw9+PfGwTrrsGRr1VkL4rzIPINFBtw7
	PIu8pInBrsMQl921m31IZOC/yB87
X-Received: by 2002:a05:690e:4811:b0:651:bcc9:50cd with SMTP id
 956f58d0204a3-653107ccddamr6102177d50.5.1776604455299; Sun, 19 Apr 2026
 06:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260323160052.17528-1-vineeth@bitbyteword.org> <20260418190456.631df6f3@fedora>
In-Reply-To: <20260418190456.631df6f3@fedora>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Sun, 19 Apr 2026 09:14:04 -0400
X-Gm-Features: AQROBzCejbUFLEO14GEr24qqxXnlBQ97NPzS668jjkdcYvI-3kvv1xuemSCQk44
Message-ID: <CAO7JXPh+__EWsW8fsKi4T+w0jdPxZEfCLQno_ukJk2=d2s0WKA@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] tracepoint: Avoid double static_branch
 evaluation at guarded call sites
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>, 
	Aaron Conole <aconole@redhat.com>, Eelco Chaudron <echaudro@redhat.com>, 
	Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	linux-sctp@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	dev@openvswitch.org, Jiri Pirko <jiri@resnulli.us>, Oded Gabbay <ogabbay@kernel.org>, 
	Koby Elbaz <koby.elbaz@intel.com>, dri-devel@lists.freedesktop.org, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Huang Rui <ray.huang@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Len Brown <lenb@kernel.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org, 
	MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, 
	Chanwoo Choi <cw00.choi@samsung.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org, 
	Eddie James <eajames@linux.ibm.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Joel Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Deucher <alexander.deucher@amd.com>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, 
	Mark Brown <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>, 
	=?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, 
	SeongJae Park <sj@kernel.org>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: 9nugsktqp98roputj18kjfyw49tmmbkg
X-Rspam-User: 
X-Rspamd-Queue-Id: 7589116000C
X-HE-Tag: 1776604456-55630
X-HE-Meta: U2FsdGVkX198wmljkRNlN3mG3dvqy2t5zVdmCmZLSIekzueLMJlmwRQI9pqYWgVajxFFTxsJRZnm/JleQjKsrE+w5vBzWHsc0lWtI9TQWp6uFzOgH/NiMHjwWCLj9kJjl70QL/QE1rv4zELppWjZh9ja64UGEvUyEh9AHTFIKJWJCObB7nhVdQIHWbjoghqqMdcycy4k2HwvASvxCdvEil5IPoVDXPT7alWrxhWbfu6irBG8W+mMV4BPinqrbzcl2rl5rJ9N+DHh7qGn7o3DAe7SkKOPpXyLh2yax7Hi1oyO+BM23BcSDEXCqhMY7un8GUaXrC5f4MzK9mSOff4H7XatXVTj209FE7aslqFgavRLXabW8yVGj7qY9lzEXwThUvQjy/skB/W/lZ6DN8q8OQ2bd5koGRpuhCTFsbAg9hFqYfiRWh5gUvTmo/t3zRNxW+AlcBWnsiKqpfiBBmH1cMlunr/IuoEW4qEK4l8DVzaS5oP8F9zUp0Iz2OGnCcvkOhFXfVwA+ihCOBnOVzQ9aTy5ozu1p8RZufAXZ1IEKHsKNTG5PMZOwflQx1GF4YyLAdcd4DFaww6pTK5+Hoj8w2E9pzTBhQV6Ty2qPa0wmSUmlmwtMbRPgl6wuFk8+0nUUQEZ8ilFQchB5X9iD+QHSxFMyCReY0DQU+kVmbTIw0pHZvwOpJsul6LhTC2yQ08JwBr9qgNzYeicX2o7Arc84d1xc7wMnxFIXWBP6mqM2OQwolGh2dneXZmfK6e88Iiyvrdp+j5gx1/oCdNigJoV6RzzJmEKvk2APrYPe6qoq9yOMBNS7m8DL7FyJHloItCL+Mt87prPDWp/pwpoJSCGlXp4EOAIVABbuGJtueR771a6Mj5qTLaG0onxLfLBil59AxpHhgCkEdzZoipqhQnFKQbA3yyQPtBvaZe+jhEeNa/Vy5Rb1Djt0R7dGTJZYa68Vq8grjiQa5YZlrKARUz
 HWqDEbd8
 dl8tm05nGqwF1W3UsW1mT9yH2Pf6NyYp3f5/0M3LA40UlIIXitjbwzxcVNTkY3VFvaEskvPLrAP6weDuofWC5VWA7UHmU9DJxQsQpm1w8v8iUTnI4Iu8ocspK2RjmE5ZVQE2j95XLZnlFrmWrF2l2RpFaa6lgU4EoeR0YU8xBUXKP01AoyLJ39eysb14P4l4oQAimioGCTpdj+P2iGG5xZf+H6pwCyfgranPWf0msfvmSDvpqaxaBiat+adb+hhO+MBq1F3kZMOvkhpss5BvsUUHby2n59b17eHxGIkUvh+mj51bK8YHDsXDIG9p3Mt6vKHYFZvmXuj7DM1YOtvlHgIz9TrdFuX4XZaYe7YC5vDM0Bj24FzmUKdLPw7FPe94GvKWzA5q/8n4u6w9Tu1Z3wxNoLbLGTCdUjAPDdd1H2NzKfQ6zXLno5KN0WpOxAKuwZLWpt/yb2VkpsVdoUeUiM+btcLxiFmFPhZ69
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 7:05=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Mon, 23 Mar 2026 12:00:19 -0400
> "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:
>
> >   if (trace_foo_enabled() && cond)
> >       trace_call__foo(args);   /* calls __do_trace_foo() directly */
>
> Hi Vineeth,
>
> Could you rebase this series on top of 7.1-rc1 when it comes out?
> Several of these patches were accepted already. Obviously drop those.
> They were the patches that added the feature, and any where the
> maintainer acked the patch.
>
> Now that the feature has been accepted, if you post the patch series
> again after 7.1-rc1 with all the patches that haven't been accepted
> yet, then the maintainers can simply take them directly. As the feature
> is now accepted, there's no dependency on it, and they don't need to go
> through the tracing tree.
>
Sure, will do. Thanks for merging this feature.

Thanks,
Vineeth

