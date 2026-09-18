Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C3F8C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138266B0093; Fri, 18 Sep 2026 11:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E90F6B009B; Fri, 18 Sep 2026 11:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40946B00A0; Fri, 18 Sep 2026 11:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D054F6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:41:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EF5012070A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:41:23 +0000 (UTC)
X-FDA: 85227297246.25.E09E961
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf22.hostedemail.com (Postfix) with ESMTP id 41FB3C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:41:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uv0OBlgm;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789746081;
	b=tIbeUn/ZWu8E0Sax+qjGdGmj8y2i6igC+dGo3JamtXdQHFOsi9cNUPcqZWT3PfqJPIvHVt
	pb0/MSOctifKUaJCcArrJaoMptEZTFX2QJ4MbdqIbhSMCbnzI/LMzdp+K3jC2xXPhfYAeQ
	+2pgKoOL0MA1dk/Q7IEwpoRdnaKCOr4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uv0OBlgm;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789746081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTqpDCleJIN6xxRKbyrEn0918f3th1MJEGdTO5nWLlY=;
	b=2uRYRDSEFpYeZ9WWmxJPdGUNx27cLd/QLlpB5xa0nh/MWRIKno2MkXywAcZWqB46eWlHBE
	8uZtI+zSbLTYT+1zmUt/EBczihRpNvccY10zw4sy/9zqW/XURqW9fsgXRuoZQ2u5b9rAAe
	a6flKK5qPbXIFFQR5VvLNPWw1HPvpkc=
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9984f9adcso1541974a12.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789746080; x=1790350880; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NTqpDCleJIN6xxRKbyrEn0918f3th1MJEGdTO5nWLlY=;
        b=Uv0OBlgmXcxcnVuLMWGmvOgSJPQPiDm5n0IF8Q2OraxT2GwjqxgPvw4v5iBUTNcgL4
         BOPmKAU97g/vKXAIq3h+8dQCWT74ziiWJHMCd8QvsK5RQoIyzUBQ2h9wJzotLf+Zcdki
         GaH2iiZx6yLC6O1kWK9qMMj3bioLDBxGmhT7npSxP+ncyF2+HvZk/Vket2e7oO9jWUz5
         siyaoLSzN37+E6lgODvxgtdFbGNyqkj7SHWv21aXXcLqUyGvEhVKg6t5GAyTehqjFd/m
         vjoFrX+QPbHqg/GimV8R58aVOFQ2Hs6AEltF2J+NiZ+Abuv0dVm/9glu+3NYJvtpu8ig
         oyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789746080; x=1790350880;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NTqpDCleJIN6xxRKbyrEn0918f3th1MJEGdTO5nWLlY=;
        b=2LVisXhjI1IZLoAguAOUEEOvFE+Nz/mtcxHlX8QlRbLJOKhfd+maRFLahULSEt2gcW
         MlKZZRwuhr8d2txe9aJ0/5UDipNyYUzbCH8lHIATLvgfA68c+4eRzcXFpvrBjyLgtPV0
         ZmlcHuEeQAMpdVFBa942XjTbcFCpHbKP5lUDKJW3cT7QrTN6kjDy6qoWMyZLs3HSnYq4
         mgboD41Ax8gpoeRHEtywHEjaV3cLyyyOXh149Zt42EH5UtGa0tFigMHPPLbR7RLedhTa
         oa6M/1aNZJ3/qfUr6dTa1MuYBH9WDs0AfSSjwos06BAwFoGMl+V+ZMtUqJ8u7LcvSgKP
         jIgw==
X-Forwarded-Encrypted: i=1; AKwUvBzjdKN5GHZB0ZYLUqla7kVfDO8vQs3gCWRj5eghYQTu6mKhwWRIQbPdWs5eJSa1CfnVT9uLlA0YGQ==@kvack.org
X-Gm-Message-State: AFuF++kBOU5CqY83eLX4mcJhMlIGes8WKRJgvsEiiCjaiWC9Wg4dO/4I
	x8vyBG5r71QHNgfLVn/29EHucc+xxeikwBNXNoeRrYNmzedYKex736s+
X-Gm-Gg: AYBFou2X6QtuCDSEQQE2ffHgqMsrSVmVBn+oFmbiyHDKiWHULx4HYflnWRaRtJtimRY
	MfuvG1QxwxsJzoeCe8p7sb7b767OxjkIuZ+ac5H8D5u0q3wW9JsBMkL4NuyB7bCnYFtWhFKuPpy
	ivK5ij2ZBNIfOz2UwYjYUnQ42L42Xwvx4kkGu6CVjdJsg4WtyVTJ6ZuXb1UU5avvMnnYE1S7XrL
	BJ//GAaK/cFx73HOlWc5NbNrhr9bTIGme0zq1CclOrx5A9+ssKOMryMzpeZJhu+fRR5JtMpJdF7
	VYfXB7varoggwEpklilFvXP2keQvBSWPFY0LBxoVgABwmW742TQEmGYtUOhR3ZCm6MT0T1mcbkg
	02zj48+a+OPXey/TJODmaSRDkkIQFMmaQEIsdXonZWkCtA7utYaryGzjEOYJ46clnc+UA9Va8ut
	XWkwFhxNYDA2okN7dRk+OdyeEDMXl0LeHJ5JK8v7uzc5BUXgI38MsRsGv7/nfRarQFj4/AeR9LI
	6S32KSS3mCzgrGsIzWJxCUvgHxHofl69o63nrwv/bgPVAzNsxDndkeDJZesaKsySddKvBQxDvuP
	sVg4
X-Received: by 2002:a17:907:9703:b0:c26:219f:6f74 with SMTP id a640c23a62f3a-c2a15846232mr267272966b.5.1789746079628;
        Fri, 18 Sep 2026 08:41:19 -0700 (PDT)
Received: from localhost ([153.61.198.248])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a1bb08165sm80235266b.22.2026.09.18.08.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 08:41:18 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Fri, 18 Sep 2026 15:41:12 +0000
Message-Id: <DLIK17AFECZV.3U5UY0LYU5Y5O@gmail.com>
Cc: "Hui Zhu" <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v12 2/2] selftests/bpf: Add memcg async reclaim
 test
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Hui Zhu" <hui.zhu@linux.dev>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "JP Kobryn" <inwardvessel@gmail.com>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Ihor Solodrai" <ihor.solodrai@linux.dev>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Song Liu"
 <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa"
 <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>, "Shuah Khan"
 <shuah@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Barry Song"
 <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
In-Reply-To: <44f7fcfafd5f33072dd2b9abc31aa9bf5eacd9bb.1789714023.git.zhuhui@kylinos.cn>
References: <cover.1789714023.git.zhuhui@kylinos.cn> <44f7fcfafd5f33072dd2b9abc31aa9bf5eacd9bb.1789714023.git.zhuhui@kylinos.cn>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41FB3C0003
X-Stat-Signature: ry58hrjm48zx5kzu9e8ryrpjot5768xx
X-HE-Tag: 1789746081-461545
X-HE-Meta: U2FsdGVkX18tGCRdDHvEE3CRgQYzaC2QyMRY0xwQSjeveQlbCifwxuBHhk9e2V1HxGNymirkETO+p7gbLqdgJO+J83E8drArcZ2T9iwvmaSaPUYNSFjH6ZplRdLEMXQKnV3FoYdWPZQv4ROgsGOy9YcroTDevG9ZiQZ8U57ODa4F9OheM/88mHYFt3v7f6BP0ZlxWMNrPJVlMnFU0ZkHQ3AHf/nrrYJcugfV8WeYJOK3wxHF0pWY3rp9JVT5iItzAn8vlRy1Lc2LuwTSwbZ6FOpxmlCBL8PlgJdSBLsG2plB4xdd0cc729UIKwVdJ9zZd39WM8XWNhzC4ppZqrseS7cOauiSzvn4ysDAkBxNALwxu0uTFDFiFTBz+DRxaYOu3s0YBug/58ML6St5ALx2uNjhTxuXZIWsAJHgAch3hdRXNHEu9L9hTg04iVRocDA94KyAYlH6VpjgZgdmEF1Wty0Yo+dmbpafhgBqhJ5JJf4LOh8+zwYC1CInIqUR/cNfzvu0iquOTH0B79oiquJH6i8Bsfpey3Z+mzngZh7Jt3Wmq3npi+DkEcqCKPn5EQKICm48AKV+DeNYP2VliF2f92moNcY/2jXoV4CSgfMpVAQ1aafWPVVLqQKZFN5E9x6gMs8LToQHcZA18Bvrm1PWYaJgbeOdg7NYxRn3LR1u3IHFfUu6QeX/75va5ldUWXKQNummk6eRo5HqLzd/Po5IjxZAqByfcDblMCvL5e5TQBBPYowHmlh0sy9h2chf5q1DSQ4G8pYxdjr347Domjr47WjZrJyxBFR1y/c9nxzC94xXyr3yopgDkaEcjWgZ8dY5PM0uigYO+U2KC7fPVbPn6aaxl5nkJ5yO+RfachwugCTqtdwVcPujdqH8ETImM77wYB8YB/jK7AeH05tKJ1CxjZZ9aF0GJXQj/ckz+ygx1JRzAU/2jou4UP/B1dGKYaLlWnZxZGg7FLv0Cui+BAe
 eNYG614Z
 qqWyNDZdGfvPrExTF5df9h0aFw5vO2soBzgJzXGbyU0sdhg05H4KfaZJcq44E7XDx7PVhYAbsiQgv8PuOt6ndORBVkjZ7eTKUfFUJgfxa4GUh17YjTAf/h+bWwLFyZUXGyjcIDzk/uTGh4DvcitEbEmJ1UcF4PPU0FMyK7OHxpwvkggDC6S1wvGT4rZtsyaDKXVMA7naG88i6hUJLBHTa+ZNIVO6XMkgpfnXJeZuwctZkhuXrgrd/6pDK9fjU0Lfc7HBx30NKsfTft7nRhGPdasCyv16nXTn5P3iUqbcWOC2bNP5sXyGfHtNNBuVd4TWrlsSgmdRZscLUSO00mmTJDY8ueFOwig4J7DtpbtYVLWoZDCS6HhW9Dn70RGS3GYeAegx9SnCdxibZUk5Zs668fyQH3v2Q8kBRIX2b09lI5WeOVzyOPStqmaIwPaleqIzHtejFOFM5h/c2X2lDK2qKa3eoMh6tzAkul3NZaX8mC/FKZs077xv9IUe52ZQ3GOpId+/ZaJ6ouezlyFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 02:58 PM Hui Zhu <hui.zhu@linux.dev> wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Exercise BPF-driven async proactive reclaim. A BPF program watches the
> refault stats of a memory-pressured cgroup and, once they grow, reclaims
> a second cgroup from a bpf_wq callback through bpf_proactive_reclaim().
> Pass/fail rests on the reclaim counters. The workload timings are a
> benchmark, not a criterion, so they are logged only under
> TEST_MEMCG_ASYNC_RECLAIM_BENCH=1, which also runs a baseline without the
> BPF program, recreating the cgroups in between so both runs start cold.

[...]

> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  tools/testing/selftests/bpf/config            |   1 +
>  .../bpf/prog_tests/memcg_async_reclaim.c      | 890 ++++++++++++++++++
>  .../selftests/bpf/progs/memcg_async_reclaim.c | 327 +++++++
>  3 files changed, 1218 insertions(+)

1200 lines of selftest for a 20 line kfunc ?
Sorry that's an overkill.


pw-
bot: cr

