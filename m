Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 333BD606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mBCE2o2D
Received: by kanga.kvack.org (Postfix)
	id 12F306B0845; Wed, 21 Oct 2026 22:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106D96B0846; Wed, 21 Oct 2026 22:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F384E6B0847; Wed, 21 Oct 2026 22:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBEAD6B0845
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:22:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55F33405EB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:22:25 +0000 (UTC)
X-FDA: 85348663050.12.B030A14
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7CBED1C0005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:22:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mBCE2o2D;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792635743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxjX1g1mQUEUPhKLrpLxYSgZ8S+x7GSgwLX7BwyjX7g=;
	b=6fS/wgBM9rO6FtKpc/q4gbWViC/0V0J46GNK4VGqX/CaFv7BDZ19A+Oa89WpZ77z87ANAt
	C5MKRGtSVfM8iMX0k54L/L26AZGoE3rqOcXCUSZ9j7mniNLx+R+IYmTE68SmOiJQLwPOna
	UXTSj368WLzlKiUKa3VH+A4fBOBoxck=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792635743;
	b=bx99/YcdR7Ixi1SKJWqbcRUNf5bqbm/ny9WsSCCCyYy7b9yBAZzAn4h2kK9EdTO9nmCRiP
	tO+59h3KoEIbOLmqRJcZZHS2LNzew7219bbusfmdYYoHAqA5uPmD7QZnIPkYZ6IYJtsWxg
	TebEO1ZUgIbiSosLlbTsUCuYJ/yGlj0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mBCE2o2D;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8a070755c8cso673002b3a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792635742; x=1793240542; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XxjX1g1mQUEUPhKLrpLxYSgZ8S+x7GSgwLX7BwyjX7g=;
        b=mBCE2o2D+UobsYf17csf8iwH7HzpuY99Xn3x4Cfw3KmXKhlCa8/991+aLMyQdSwxl7
         YDtRIqzu1csOc7R8voaEF9zZ9v4udrlEmb+dC5kbFoBo8QDRAaRrEwScEjiJ1gdULdL4
         L8FllUnyXTn+xTxtc79/znmlkoZYwhcmkJAxj2daHlk2PW2DVGL/91v8e/GlC9dRl/XS
         mywyVUIWdu46e9xaRff6XKxabScbdXFT7t6mHb4NUy+mAVU7BTMrWbJjfIPrEKsX+Ly2
         amxl3vNNym+WN4M+vgzT6++0mzAFIEBtJBWkCjeMcxSdcp7M4vv1oc3ClS0WvknyP1YM
         d+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792635742; x=1793240542;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XxjX1g1mQUEUPhKLrpLxYSgZ8S+x7GSgwLX7BwyjX7g=;
        b=DcgPh/E4ZvQv7RuTIpW6jOw6uCQFCKZd9doa9oGjjCHe9Ftf68IofqpNwkHedayv0D
         3NQGYUnW2izrLD2kRnXh84es2dq07OdgSKzLoawuae7qJQ8wbXZkDOwsoa2PvMPEUyzI
         A6D6RDhtDzkUm2ApItOlel1dMdmwoKZKvk3GVPbEDwyizAjdiKVdQ/d/tPo5qy7jjOpA
         1c7VfaXyOYB98AAYgZp/Ai5gNGqZDDWkvVXrEfmubwBE2GEEwVeMjCQpbKLi55PSQWBc
         Cx1n04ifwDiwee4gqJQQgDNu+FA0PlLq9cbhJW/l84QYxcwOoC+KCiRdxxBw943S/s7R
         9u8Q==
X-Forwarded-Encrypted: i=1; AKwUvBxtLqj6/JkXH/Wo6cVd0QM3YXi2vwN0Ad7gtEnrvPEDika4P17M4To7AgVIsHPVOxNnOxddUYnAJQ==@kvack.org
X-Gm-Message-State: AFq9FYKY4pnKHTG2jpGOQnIQEXhEiTOIT4aBd7ANgR/zlBrl/0vTg4ck
	GjL3ivRv6BJWwutU5kOy0O7h/WyBkJFdXzhdrf57wGCWFkjNRv3aYuU6
X-Gm-Gg: AYBFou1yE4HDpv6J4AP6+R5akyMsHXXvYRvwnkWjQJKZSEJON/yKQ1RUfctRtVP3jWu
	f0rgm6WTNzU9C9xX8+Shgim9N/rDNjquTXIa4l9GHlJ6YLIJ5SNit/C2DDQtNi1u5vzM8qvlqDt
	HrqWluJ9ttG6HgYxXdn8c8624jwwUtX3vWjct6lRHVDOWfjFK73ZWU6u0bnEjKajH1ZHuO4ekXu
	EjT9ywemFLco+18+FzzeJFLAmmE2vlVv+3XlSQO4Px+IUWtgrrisf9gX99CJjUWWmccEFk1TwAF
	NSsDxUn6c1pO+VNxXWIteC4jtwjriN6eE6xuwNbWGwWLnbIIsgtclN+vt+qLyI0Xkx0PjPXIDNX
	S+0Bg49GLdtxJXRS3zQ3yqTPdToPMIyYEUO1YpWs+xzAXx3QIRTydwVqFH04spIH3fXH+Mp7qnG
	QdPdTnBNYZegQoHIK3DaJuNvmZ0MlQdyiV32m6Uv+cdoF0FgVu5z5CtVGQRJHeolgaNATQ0G90f
	qIZ7f2wyX4OhqM3EjcmXaxxZ0u4m+bNpEK20G0T0G0Zue1Gvem0NTbJQm3NLOxTtbnThU9lu1JT
	vxJnV8ukuJFl7QrLOxKKltpJ5/JayAAY7UwiDea8BhI3Er9CUO/n3WdsT12Z
X-Received: by 2002:a05:6a00:b49:b0:89f:37a0:b2cb with SMTP id d2e1a72fcca58-8a089eba62amr2905819b3a.49.1792635742236;
        Wed, 21 Oct 2026 19:22:22 -0700 (PDT)
Received: from localhost ([153.61.198.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0894b4206sm1450303b3a.18.2026.10.21.19.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 19:22:21 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Oct 2026 02:22:20 +0000
Message-Id: <DMB0C24NTIST.YQZ2Y3E0I1I1@gmail.com>
Subject: Re: [PATCH bpf-next 9/9] selftests/bpf: Test uprobes and fork()
 with busy mmap_lock
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: <sashiko-reviews@lists.linux.dev>, <bpf@vger.kernel.org>
Cc: <daniel@iogearbox.net>, <andrii@kernel.org>, <eddyz87@gmail.com>,
 <memxor@gmail.com>, <oleg@redhat.com>, <peterz@infradead.org>,
 <mhiramat@kernel.org>, <jolsa@kernel.org>, <akpm@linux-foundation.org>,
 <liam@infradead.org>, <ljs@kernel.org>, <surenb@google.com>,
 <david@kernel.org>, <vbabka@kernel.org>, <jannh@google.com>,
 <hughd@google.com>, <kees@kernel.org>, <mingo@redhat.com>,
 <tglx@kernel.org>, <x86@kernel.org>, <linux-trace-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-perf-users@vger.kernel.org>
In-Reply-To: <sashiko-outbox-180860@kernel.org>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com> <20261022015712.1297331-10-alexei.starovoitov@gmail.com> <sashiko-outbox-180860@kernel.org>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CBED1C0005
X-Stat-Signature: zwdx4ax7k3cu8x478kzteqzin5iktz7w
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792635743-907648
X-HE-Meta: U2FsdGVkX19m8KqRrnyUNAHKRerLcqJ+ckhZKSF591dVYGxOeeDu232xQhSKxVQheZVuBVt3+t+DiPhOhLEYJ8V2uM1EKXAj8t3DU5xw3wg92/pl16HWH7bLf3YQLCeF66+7cOSG4z3HMs7MeG12Dp1qfBuThKrR7t1wd72sznCEk5dWEXCbwpgVIXEymMGa29u9A7sLpzUijb/KpRghFx829KJ12LeWHoikY4qk1Dy78oqrFCSfp2ev+A6YyGLnGZCry22kOuRLxwOkLq9VgIgoUSMKc7UYnXoXOKnL7HkLebcv5ukla82qM5PmOAytHz5A6DXClprfq8WiCvD6FPL/+DdqimRYEG6RAZGGj9eoQ+ixoonV2Izqybqd8teBPrhdKdbUC62D+dt1XVwWEBA9BYMfx97exAGrvKgqGBAQdTIHjsgHsLYh6NEKxr0gHhnPp3mUNf22pK1MW8cp7RW1Bjii2TPjeYxwtX0StxzIUcnBArJkdq3Qu65k1sZRiTxoFSOtqG1X3LFrtv4EiOLGib6xNnCvMYqVutcPvVI7pyrOdyJHJnFwqtCi38pPavd3/Ts9QYRajaEMI3/PM4QHnxMc3Cg3UjT7Q5LeBd+ut8fyHMXk6pL7kWF/sTztFDfD9SX1hECru4Xyy97GBz7Qc2r5VTPZHfbE2fIb4eHhxUxxfcYnsW25A1IMz2BoEnVv6c9BVIlzgdSjGvjkW/3cFmWJHoCPk/1SQYafL3cfiuuWCmCjtHC3XH4ja/HSvY5N249RYmPd1crlEg4wGtKClS5fI7+MdC+4vRYflUdfIUoxS7/5DO2sVe8RUBn/IwmOfNVvVndNINH2+02Co4jV2ulowV/I3pcjkIVeaKihKxoSCwLqYY0ZzvUiobx+FI0dwtVd6U+398rj3d6aq6AGE2+RlESbs+CBGomVHulUBc+E6pDy++Lu5FswcmXy4UliLdm0SQHZ6/oK3sp
 GDaNV06s
 xyocgcC1kwGr64OaHh6yZgAAS6wsvG8OSK/koa5hOeMGKSd/Eopxaz76DgIFpsrS1vtpRzhFGbUM8Cv6JE+mh/KJ2t335ZpnU/hKYrQKrzb2YCS/QEOQdlAjI9Vh+YNaLmSSXsUB6pEAB/fIZCZO+mNSnYbZijeC6orqJNDTICtK16ZLZnYiIcFuSYRiEBBPdIJQRqm/SAG+0DcSy0QpIMIiwBb5RG5OWJW+uaOSIwqgsAAhEa4xRNiadmNL89rR0xIHMHKKRnEjsv4N5/+ywh0GEkBt2aOQRnsgOOrKHjWCmg+4oICuti+3005hzSSXPPaOzfB7/UPAkn6leXmZYCPCPF2rAkamLytG5WjZmQh25ekUldVEe5+5nLJS68EVsgn258KAKXWG8QBbbSYoK5ehOoS1wElL/3SdP6Zfhf1EgHZ7SS1Akq/2oRkpOYiJmodKWEhkWZxiw8zB8j7MxJyXkJ4XCpvDJ9FUf/oSp/9GfdNGTcNXhcAfJnPsnE1WJWkpYcVN6hghKGPm8UHhh0I6ERNf25owJnSOUBnVXrsWarSFJY9DXohh34jiIfmwpxzoIot2VPyfAl+dxlDN8DfsOEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 07:10 PM sashiko-bot@kernel.org <sashiko-bot@kernel.org> wrote:
>> +#define AREA_MAX	(64UL << 30)
>
> [ ... ]
>
>> +	area = mmap(NULL, AREA_MAX, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
>> +	if (area == MAP_FAILED)
>> +		goto err;
>
> [Severity: Medium]
> In tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c, does AREA_MAX
> overflow on 32-bit architectures when passed to mmap() in hold_mmap_lock()?
>
> Should AREA_MAX be sized appropriately for 32-bit architectures as well?

No. uprobe_multi link is 64-bit only.
bpf_uprobe_multi_link_attach() returns -EOPNOTSUPP on 32-bit and
three of four subtests attach with it.

