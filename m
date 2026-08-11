Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A22BCC5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A2E6B008C; Tue, 11 Aug 2026 07:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3FC6B0092; Tue, 11 Aug 2026 07:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D0B6B0093; Tue, 11 Aug 2026 07:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 649686B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:48:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF0B8403EA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:48:30 +0000 (UTC)
X-FDA: 85088815980.29.1DD0A84
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A857140007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:48:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gSXOVYp3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786448909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ss9z8frgXLbOyoae93z63ypP8jpNcSWpfGevNSq30Jc=;
	b=hivhwsmWrir4gDVCK6kTdEUxr6ZAgdnK+YO6KWhdpWKVOuZakE8UdRx/05F5q7gV3afY7M
	0oP5qsy2e5l0Snaukm5Z1OfjzFlfj41tJQEgyZG8V1wG3yKgq7fyfjw4jJumIEGgWnYHfh
	eM5i+zc9PMRgld9DomciZb8tIZYaVJw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gSXOVYp3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786448909;
	b=mFbwWjVFukHu03JIb9NYRWthpbMOfs5EhKCPIWBruxkyvN9bVNsKZCxbauKSLN+jy10uq1
	vEsQ54hXLH9k4v+NzRlrEe6dhUttOWZ95c4a5UKgosdMBBCm3WcJqgzackh/D4HzBe9WHT
	XO7SWSlc1I0mQN9Uc4Reu2r6ElN2zA4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so35879105ad.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786448908; x=1787053708; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ss9z8frgXLbOyoae93z63ypP8jpNcSWpfGevNSq30Jc=;
        b=gSXOVYp3xb9A/D18NPo5AtABZLsp8PJguIHQ0TXbtm7HpYpBTJ6cN2zKWM9KNNrRk4
         wy7QFYiV6OwiIUeOjRGXVNeut6k+UlDr6ADFUvpZDXcczqV5dCzA7iR1OxmEUc49gnol
         jhFU0dQScyFyb/BN6qV8lZJUdhqcwElvyVQlqrkwL5bKbF9G0rV/udXRFxOiaTM+9DoB
         gUNNozXaZ7jh5XIqNmv/+LTP40l7wy6RKwcuFRTPBUERhQfRp17kPfXN15eE1Xzut/5b
         xP/DTWv+COovqb2JIALLXfX86HBdU+X68cKEFB9jS0YI4eScorYgmMcO0InsRZvwlhbd
         84zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786448908; x=1787053708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ss9z8frgXLbOyoae93z63ypP8jpNcSWpfGevNSq30Jc=;
        b=QYrd4t/zl5joPVKLlv7XsYoYIaQBuGP+5BVfu8pVlXSL/IQKlTd7V3DGoOBCjh2KGg
         hT+UKqNZ2eoi25+mGVOcaGIpTJQ3YGwNcCWhoUvcrbMTPnq5RrtHW2q1XPFu0KvOn5eO
         drpLOvKCFRqD8KWoxAB187f95/DNOeRQzi7qbRU6mhfdl6zP+0E6kdssKxTQhF32ga7e
         TYUbUV5dss33kyLjThkTUY1s5OQZVTR8IPto5s1joRvv2YwQXEH0J8cd/BpNFhPa2ilJ
         cngeKyp3iFyn1celvqmqvTT3kFeWJovNc+poiaBfytsjS2xu4HN6XvR820/gCfBJTocL
         dr1g==
X-Forwarded-Encrypted: i=1; AHgh+Ro/S0B2n9sbmffMoYqeH5Wz70OnSgUMZ9lPmBYOcurH7iuipaPhXA0Z09wd0oXyLrkqjap4uNw0rA==@kvack.org
X-Gm-Message-State: AOJu0YzYsXmJyLowhtZJtXqBR9eREfrWKjQZV7hamD/RNqAgdkqQe1Oe
	I9d7omFIyX7AJsGYuWdnBGCLpYZ00Dl+yyFbwbuY4XNMre1LaP/qg99t
X-Gm-Gg: AR+sD13zEK0rbnsaymcCHex1kS0XOWVmFpeCJgMveE70SKA/nVuMpQiowXK6r7jrzku
	oYHgJ0Vhl6kciMdTmYH+S3ZYIe1DR7J5cKcak5lVwtM6aXpjdxf+lHssRaUfh3X+VHNcLofC+BT
	FT3CtUK6ikoRNBG+NgV7t2sqliFf7xPfDh2GlsmHcSSgdMCNtNaeXIFR2EG9wn2sD1Xn+fn8KC+
	U8qePT1Dgh4xKqVrdaF40nz0lgEoqssej9rdNLKF/h2oM4mGJy24bNeiYIgatFK6A7XeNXEMhE6
	M2V68n8mIASm5r0fMBy1FHppsg/zT0GbjLUo1Wunie5Dm6JQr/91GkFS6e7yypotvdgXoor3jyj
	K5xijtKQ0WHu5MtDlooTBgbcj5jWUQtMUN4heFY82wa1UtwlDZUkSThSNLrkSrAU/uywf6dVqu5
	wn+iZomQjpE0097dOrooXCNuXLMPO4nl5GbTdE7svUWtU0D65GEvmFD7UC+OZlSrRQzBuEzxlS4
	igfR8yIk0d+8DlvHE6XKjONxrTV
X-Received: by 2002:a17:90b:4c4b:b0:38e:659b:f366 with SMTP id 98e67ed59e1d1-392ec0efc61mr2838777a91.0.1786448907678;
        Tue, 11 Aug 2026 04:48:27 -0700 (PDT)
Received: from bj-kjy-standalone-gaoxiang17.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392ee1e369esm1850103a91.2.2026.08.11.04.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:48:27 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
X-Google-Original-From: Xiang Gao <gaoxiang17@xiaomi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	gao xu <gaoxu2@honor.com>,
	yinchuang1@xiaomi.com,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: [RFC] tracing: aggregate ring-buffer usage statistics
Date: Tue, 11 Aug 2026 19:48:18 +0800
Message-Id: <20260811114818.1449933-1-gaoxiang17@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A857140007
X-Stat-Signature: t9o9ug5ifrgfstgj4q7o5ky7r4k3br8s
X-Rspam-User: 
X-HE-Tag: 1786448908-741351
X-HE-Meta: U2FsdGVkX18AWlUytedb6NJ7VPNtitFCaoxpaAZeVJZv9sSa/0i8JfNXjWaujUezGIe+Qf29DbrHg9aiVyPLOy0px+UD8unWHxlLAjyaVYygjQwfYzNTwu4hYFn7+xkWa00KzYbQ34IO6kDQv9twCh1j3LtgAoNPAS9svdsjp5jYqs/ApQd4jcnGf351cGJ/BJdVw4imWZQHfZjp0lrTUCM8sDjdHYlLZnLIE/CwTWpGuissr70gYfI3yIOovGiSegIm5vx1G+Nq4avkJNrf33ofZMylnfYco9IkINg9Y87oCVoePPnF5h3cxPCPWwoqT2iUeDbLV7eZpCFIL1sAs6urxSNbfVZ5uy3Rv6t5h1NYAdgafyI48KCrK/baJ4l7/IRWb3dk5j5caBYLMgHHLK2ECUR9hkCcz+dUFudjHh0t6CupZhou2ge1XWa+Dt7ln6BZ5KosdZRODcSUELR+4Ne6CShGPN0E6d5CqZZ2rq76LlbgAVEkO98YeG+2ttvsvcxgNQEbgFfKbVVPSrt7Y+nAKZe909mciUlqs9OKotmgOaxijUkH4uxpqAKSX8pVQIiso48lS4IALXD7Is1ND1FdoFsZKb5NSU+3j4ak7EjqzClwvvo1Grw/QlLFxAuI1UJ0fIeGb4G6D8mucM7/vz/t3FG7wCGi9KQ0nL+7RTZnpUQhokYRSZ19TVc8Pk3lg24+5U9usyG0qhz19JXyzbAOjJOThWC9iXEu1oxAFxtAYI6+DeJRoXBCnswhYqp71Sn7y4mF01Gtd7nzAZaVnDRgt8aJAHwo7JwISspCIgYQzrynKnr/FyZFpe45rlhPGn4SYb5SA8eFyDuh8sLeE8G76AKcZ1aLM3z4/7bIxy9Vt18bHS2ZGuEV5lS+zP6hHc6M1cqRaYaNQiXAYu4ebFTaKD9j1MzlEcRn/USQb7kAGrfIdJRcjrcRS/v6mLBLu+mZJovVdoFu/d2157y
 Z8WuZixM
 3c5e6gkS8Yvqqh8oNHRCFBZX6DtAO2ldHyVgwq/UoTnNs3bKF+3cg4nYLTkhYy6FUVqjhyfpvMX86vG7eyjSfqUk9dADT3mrn8hgInlvcnzdB8d/Q5epUBIysgmNs6wl+3LMuNs8oDMn1NOEhPf2ckl4XRC6aYq14/GI+q1+tB9m7qZyw0yclPK5onN5WCTqSsgDWevwePEj4SZjkBwVs/c1aQ258kM97/xgEXXnU7K3cnbLy7QTNRx6990N7/f3fFTezpT6Y4zhkdMVplavkkFAK/hwwnkYy6OeVm+8vHxZaKnSfR3a9SwdsSGCEaGDcBgN9nkFA3+7LzgW8y5Lmewr0kwo4vMn7ElJk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I would like to clarify the motivation for a tracing-specific memory
usage interface.

The original requirement comes from Android lost-RAM attribution.
Ftrace ring-buffer data pages are not represented as a separate memory
category, so userspace memory diagnostics may treat them as lost RAM.

The memory can be spread across the global trace array, dynamically
created tracing instances, and snapshot buffers. Userspace can read
buffer_total_size_kb for the global trace array and each instance, but
it has to discover and sum all instances, and snapshot buffer capacity
is not exposed through the same per-instance total.

On one Android device, the global buffer and 24 tracing instances
accounted for 395,664 kB of ring-buffer data capacity. This makes the
missing attribution significant for low-memory diagnostics.

The core requirement is a stable tracing-specific interface that allows
userspace to obtain the aggregate tracing buffer usage without walking
all instances. It does not need to be part of /proc/meminfo or
show_mem().

One possible interface would be under:

  /sys/kernel/tracing/trace_stats/

It could provide an aggregate buffer value together with a breakdown
for main and snapshot buffers. Per-CPU statistics could also be added
if useful.

Thanks,
Xiang

