Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC821FC617E
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 10:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA31A6B0005; Sat,  3 Jan 2026 05:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26456B0089; Sat,  3 Jan 2026 05:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9324C6B008A; Sat,  3 Jan 2026 05:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB956B0005
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 05:56:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AF30139DE7
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 10:56:56 +0000 (UTC)
X-FDA: 84290350032.11.67FC58F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 02FA04000E
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 10:56:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C8FdLi6b;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767437814; a=rsa-sha256;
	cv=none;
	b=UidwLjkpbT3jaVDiNB/YNc3V4dWduoipbcYRFSCKizVnGCdvtm40arDcwbVX51V+/nSC74
	r7ixYroLlbejN5p3ba6BSD5zp4yT6cNVhyiYb6TN3kEe/r6EJjdOMjsqf1k/EdVKysWPed
	09LslZqwIGbU5mHsCix0r1qpsYa4suU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C8FdLi6b;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767437814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGpUw0Ox/Jp3kMXH8XGSAcDFluSymyYJIP4RuNh5bqs=;
	b=hsv5gHAOo7CyceFMapU2XYOU6W5BaZoPZW3D/nGI1WaeZkGvBDgfcV7XAr6F0RBLOC29fe
	NGrSIzBPO0SxKLD3Aob8dljjI3Q0QggcSXOpfjaW7bi+IH/ZgRMno4EOd2TM7xI4sQTtNI
	b3fmVGMUhI5g6Rl82DypWECAUuYpJlU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767437813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yGpUw0Ox/Jp3kMXH8XGSAcDFluSymyYJIP4RuNh5bqs=;
	b=C8FdLi6bG5kjDMERqeu/vaWF/LQIV991ClweIQvc3YIGVvgEZfPDALlA+fkmUNMG2YrNwQ
	dGts6vWt7cyvxaqI+7Uor+eARYnb2Qg1bkeNwCVOuNVt5QCOS6tbTksAMMf3Z4wLIVayL7
	HQWtb7+EhnrrK/y3UMahqZfvEelAYUk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-zNokpBgqPf6VSRWU69Yn0Q-1; Sat,
 03 Jan 2026 05:56:49 -0500
X-MC-Unique: zNokpBgqPf6VSRWU69Yn0Q-1
X-Mimecast-MFC-AGG-ID: zNokpBgqPf6VSRWU69Yn0Q_1767437807
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0451619560A5;
	Sat,  3 Jan 2026 10:56:45 +0000 (UTC)
Received: from fedora (unknown [10.45.224.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3114119560A7;
	Sat,  3 Jan 2026 10:56:36 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sat,  3 Jan 2026 11:56:44 +0100 (CET)
Date: Sat, 3 Jan 2026 11:56:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Keke Ming <ming.jvle@gmail.com>
Cc: mhiramat@kernel.org, peterz@infradead.org, linux@armlinux.org.uk,
	catalin.marinas@arm.com, will@kernel.org, tsbogend@alpha.franken.de,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH 0/5] uprobes: transition from kmap_atomic to
 kmap_local_page
Message-ID: <aVj146EunyaOQzxO@redhat.com>
References: <20260103084243.195125-1-ming.jvle@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260103084243.195125-1-ming.jvle@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 02FA04000E
X-Rspamd-Server: rspam03
X-Stat-Signature: t9scgna54m5k93t5i7p64aw5zqw5oce1
X-Rspam-User: 
X-HE-Tag: 1767437813-726544
X-HE-Meta: U2FsdGVkX18FYrc5OlEvbDrW+8VnfrKEzoW79y8PvEGrq0HxmggkiRv69tDvunWofouGuIxgXR2clbm05dPXawYJZ+UPNjp856M3DsZzr7PqEO2nQ1fQ3cfT4y4qv7EvZMKJKRDkg3tzylTPHh2/DfECGp0YkMunVQ1xyU2l3mfz7iccoE+z7VdJPaMcg9mommsk0SFIyWn8hYjVJSBjGGBZQBAGBK5m4Nx+5ZgFdg4R+8laHF24gJDk4XkrMZ7Ivv+nTcoix/DQnYuZQW0FKKvCkMsK7lgFY3j67DR6V9d9ysEIH0+L+r67yHwBKQjFDSpvVMOuP268s7lqS9rt0+/xbT1UKXdT8JQSnbxU+d7TjhsFy39SNhrjBWqgQ0q/l/FrgW1rUSsjsfl9J/eAxKXbVEASPtj4w4ovvyxREfvwaJnzqaJaiFckCKgXbkW5qSLObzadJJc46nJIuGH1gPX+JpznnBVfV6u9lbjIcRLXr27u9Ah2NZq5wF+hFOUyIOXOA2ok4h7krAC1jsB8A4aNAoYbpUYbLCcKlXCzQqI2kxoJfns1Wdpk5c0YeqbricsNc+hMfDnjwesgkPGPKKGhrIYgMpwVpQkupJugYtheudf4LqcFEe75tu3F2G4eNwKzllohcGvOwiaZpnLJ/9ecDA2yRohNN8qYQiQsxSiOnrW2o/lVU/H+TJ1rWyP4G6yIsIuFRcRF4PpBX9tkknr+0e8itR+ZNJpbiqx8jHq179vi2SYWPctkuDqlFBdVeYxtFW1ZUKlEgWfQ3YdahqjOyPyuWwcXqZGONTg2SDwhIZfpDNt/Tee/BMgOkLKs2xpyN4JsGghoQeWTYxv+ke+kSj8F4NrfyisPW/FECr4PkNcuJtcZYyYQ3Dn8XdG/H0BBILA81w3QJz9UaPq9+emuQzaSb8RTGi0e1vAglHmfhg41dr1VgbmXuysQnvMdjZNnHgJbudd+3leQdpL
 U4Fmzeul
 kzLVNsLWjUDSyXLEYJRwJXKFBcFYJyGWYNyxlTn7/I4zID0CPtTwQn5lCe1nyAyqHhjD9OQz3yx5y973FKsIQj8j/+VNopkI+m4+FkKDC1SLMbm0BvKndA93msQ7thEOwewAj4YGrZPlnYgDhi26MqttAT/DvnPJf68JCQWkPZIvqt9+tnb6YXIp3gKj5OxXsdivDq90BgY1aHbiLm+CLG+Wm9Q5F6arRF9zBhIiGq12mTev0KaWOTwXG5DsgJ9xlyyxxkyz1ky1WJ09jz5WkCvZH2tG4ZYrvdTQAS3jWo9QONMF0jYgFIUiuJWqXvCqd9RPa+7R6BZ8kIzu++y2sPxBBBPu1oXkmYlnJJ7pCMG0L9rpRjFaExUxhwwYJM7pesrib5DNtBxB14NPkC9PfPEwtigq1r3AleowdvPp7p1iZHCELkD9FEIYghl6JwE3YlhjFYF3W1GzFGCMkCgfzJ39Vp/8hBGq02krjipzgQqf1SKorUy/IIX/QEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/03, Keke Ming wrote:
>
> Keke Ming (5):
>   riscv/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
>   arm64/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
>   mips/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
>   arm/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
>   uprobes: use kmap_local_page() for temporary page mappings
>
>  arch/arm/probes/uprobes/core.c     |  4 ++--
>  arch/arm64/kernel/probes/uprobes.c |  4 ++--
>  arch/mips/kernel/uprobes.c         |  4 ++--
>  arch/riscv/kernel/probes/uprobes.c |  4 ++--
>  kernel/events/uprobes.c            | 12 ++++++------
>  5 files changed, 14 insertions(+), 14 deletions(-)

Thanks,

Acked-by: Oleg Nesterov <oleg@redhat.com>


