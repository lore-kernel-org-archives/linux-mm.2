Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189DBCA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 03:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882188E0032; Sat, 16 Aug 2025 23:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833CC8E000A; Sat, 16 Aug 2025 23:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770188E0032; Sat, 16 Aug 2025 23:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 667DD8E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 23:41:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C09DB83912
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:41:01 +0000 (UTC)
X-FDA: 83784848322.16.908E2DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id C78DA1C0002
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:40:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bqGCi7HM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755402060; a=rsa-sha256;
	cv=none;
	b=T96DDSOs3LlisxKnv4PjBI0VhE1qxYgmh4MhZpat6H28jjRIvSaVS1wFsuJiTeisKVQZB4
	VGi1nkhftz38h3IwYMuHXC9g5tUy675wsoODpcgEILvXrpwJcvCfqJjplPkZ376Y677tvI
	yUzLyzRgdghMVAmNl+CengG+o97y05U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bqGCi7HM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755402060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Y0oXgvbJlVAXUapKet03fj1MIE/RRaWOW5OiNzH2oU=;
	b=BaFU36jTESgoTtCdT58JXHriNl6SL3/DtfcxywhCqABZFjFe7veqSu0RzqUn1yNHuVKEWU
	f/WM7hEoZwgv5zKE8+3b6w/9ZBmED5/oQxWLfiHjB9N30kPXYp0mWPkj56+Z0OzKKmdpSg
	Bd6zjzz0oI5dxe0WsxuNf8ommsFtYMs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755402059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Y0oXgvbJlVAXUapKet03fj1MIE/RRaWOW5OiNzH2oU=;
	b=bqGCi7HMHwUIpZfRR0NB4O3GcNfFZ5RpdRpK0CGGv2FrdZTeT1tG6/wCmtO0YeuUSHbLXp
	Apt773qQbJXOd2C3ElM0IPsvgqq++W0SdKzULU+xzVk052Obtw8gsWBG8yZJupq4TvrXZD
	VnRZimggtjHIqaSfthlBDnmLtRnOYWc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-PkT_4EHSPaqREfWT33cFVQ-1; Sat,
 16 Aug 2025 23:40:55 -0400
X-MC-Unique: PkT_4EHSPaqREfWT33cFVQ-1
X-Mimecast-MFC-AGG-ID: PkT_4EHSPaqREfWT33cFVQ_1755402053
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 544231800340;
	Sun, 17 Aug 2025 03:40:53 +0000 (UTC)
Received: from localhost (unknown [10.72.112.34])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5A23180044F;
	Sun, 17 Aug 2025 03:40:50 +0000 (UTC)
Date: Sun, 17 Aug 2025 11:40:46 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	sj@kernel.org, lorenzo.stoakes@oracle.com, elver@google.com,
	snovitoll@gmail.com
Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aKFPPi2sti7+3JZ9@MiWiFi-R3L-srv>
References: <20250812124941.69508-1-bhe@redhat.com>
 <CA+fCnZcAa62uXqnUwxFmDYh1xPqKBOQqOT55kU8iY_pgQg2+NA@mail.gmail.com>
 <CA+fCnZdKy-AQr+L3w=gfaw9EnFvKd0Gz4LtAZciYDP_SiWrL2A@mail.gmail.com>
 <aJxzehJYKez5Q1v2@MiWiFi-R3L-srv>
 <CA+fCnZfv9sbHuRVy8G9QdbKaaeO-Vguf7b2Atc5WXEs+uJx0YQ@mail.gmail.com>
 <aJ2kpEVB4Anyyo/K@MiWiFi-R3L-srv>
 <CA+fCnZcdSDEZvRSxEnogBMCFg1f-PK7PKx0KB_1SA0saY6-21g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZcdSDEZvRSxEnogBMCFg1f-PK7PKx0KB_1SA0saY6-21g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C78DA1C0002
X-Stat-Signature: 581ssr49rrhbmi5j3hs7iojr8hbq7q8n
X-HE-Tag: 1755402059-286853
X-HE-Meta: U2FsdGVkX18zWkzebCLRrNRmTpmeFa2NKruF7YHqp3wRinjVu7c9qot4/BqWgEkT4IVuXYHsDjrBERUt5zeWyGUCyPYLb+0xyyOCNBXw6uFFRvtMfqVu7Hl28k8BFoTtLg/ue4ZEs3YieRaoQiS3X9kHhV5PuzfmY5jLKoN99EIYneoX+t9fZHXpQyQM5kTUr8J1YrOM7fi9V542UivTc2j3hPtdRObu9yNqPAnfJ8YWsWEMD5gNz/PFjil6jZTHYhxQ/6g8yS5LxxrYSGHsRvuxzBKR8tiYvZqyoEoljAwRmFqmAlf8i7MJ4cmO5EEOlTVorWhsc2LTiQ5PJ+W5/j1MYJneqWRODODGzjVXFbhHHrkxbUt5polnDqqzNlTl6YX5Z7CaM6+GQCMxZEK5qWIgCFLeCwg1WkhC6OS7Rksehc4DQ5CWHloKdCMDID65FhAacxiC18NfPeztieCU1bZMYzP3ItCDqS25obMRv8jbe2j0rDwAGhLR0GqZbKJQ4QkiP8RMEqfKffxAkLGYK3qXhtbMUQIbblYJvFVbcidalOtEDPQebJ3iH3fBoUCbeUk+qpTkNSN4BvvEvOPhXJzfeMD72c8H687kmppX5YBIMQrHpkoTulXXZhyZe5/ba/dzYdngfcWNRoF0ApGH9Sg5b450Yqk/btTyDU3OX1j8nmRlrRel/6m+OQZzyo0iIBom91NkoqxOHn5nmbbIHqUfVdU+/JuIMb4wJ4rraH8ZAUW0WMqe9Rv1G0xisMsQgzoQmqF71GZHV8un4WAMew1JFjuonSjgSyV3x+UclzbEMbRHnc4+eCy+G5zXdzYrNwx5BEer9NmlJosY+4w6d39be0kQjUe3p98fzX8pI68kNXeROGy1E3dFq6TBoJ30BkmDyoIedRiJybMduBZL+38b1ZoXodG4AvRKUZFtiqnQfVOkVg/Ddzl5ThlEoqXastD3YmStEPQLHG42uMF
 F0khTVIx
 utwZEDuzzlh1vl9wNqthBYOU5pk8IJXrCfFaHkMIFVGf3cKr1RmKXukYia3JVA/pBIWGDc81PvC+AqK2VyNRrBK1tVd4Lw+9nI1voqUslXqBIknW1ZvLvR1PWZCcbM6yQoDW/upPTe7KDS5DeRhw88EssgS8vZ1XEaxoi1b2rh8+mbfq37vAU3azhBqshSJHZr1aVIX/jSVvhA52QWK6HuGOd/ylEZ4oqA/jcNdY/gHO5+THPUbgJSnH174v5Tlrid9eMq3X702RRFQHIMa3QDPznrNuF3UBHcc6GZNznQSUGsWLncf6KJ9h+/BFnnVChi5AGCI1F1mN0CCAwtXsZbPBsNKNipZkrb/qs6fiwv540eI9ApAFI6vfSswNO1DDiMa2x9Ys5iyoT+OGyGQ5wvIkgOf8w3qmy3osx/LjkK9oLrRSTicI4QMKvsYQ762Hm0lxSNcjRMNk7w0MLFQMo9iVr1038J1S9zpA8UCaXHfnlXAh6wkM36dev7Lxnt6OdpK555WoltTuwZdo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/16/25 at 06:50am, Andrey Konovalov wrote:
> On Thu, Aug 14, 2025 at 10:56 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > Ah, I got what you mean. We probably are saying different things.
> >
> > In order to record memory content of a corrupted kernel, we need reserve
> > a memory region during bootup of a normal kernel (usually called 1st
> > kernel) via kernel parameter crashkernel=nMB in advance. Then load
> > kernel into the crashkernel memory region, that means the region is not
> > usable for 1st kernel. When 1st kernel collapsed, we stop the 1st kernel
> > cpu/irq and warmly switch to the loaded kernel in the crashkernel memory
> > region (usually called kdump kernel). In kdump kernel, it boots up and
> > enable necessary features to read out the 1st kernel's memory content,
> > we usually use user space tool like makeudmpfile to filter out unwanted
> > memory content.
> >
> > So this patchset intends to disable KASAN to decrease the crashkernel
> > meomry value because crashkernel is not usable for 1st kernel. As for
> > shadow memory of 1st kernel, we need recognize it and filter it away
> > in makedumpfile.
> 
> Ah, I see, thank you for the explanation!
> 
> So kdump kernel runs with the amount of RAM specified by crashkernel=.
> And KASAN's shadow memory increases RAM usage, which means
> crashkernel= needs to be set to a higher value for KASAN kernels. Is
> my understanding of the problem correct?

Yeah, you are quite right.

When I tested it, on x86_64 and arm64, usually I set crashkernel=256M
and it's sufficient. However, when KASAN is enabled and generic mode is
taken, I need set crashkernel=768M to make vmcore dumping succeed. In
kdump kernel, read_vmcore() uses ioremap to map the old memory of
collapsed kernel for reading out, those vmalloc-ed areas are lazily
freed and cause more shadow memory than what we usually think shadow
memory only costs 1/8 of physical RAM.


