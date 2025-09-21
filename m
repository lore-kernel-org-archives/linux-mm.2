Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A02CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 05:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02FAA8E000A; Sun, 21 Sep 2025 01:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20BD8E0001; Sun, 21 Sep 2025 01:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36E68E000A; Sun, 21 Sep 2025 01:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1EEE8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 01:54:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B9BFB7FA0
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:54:37 +0000 (UTC)
X-FDA: 83912192994.29.B78709A
Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8140F40004
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:54:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of ej@inai.de designates 144.76.212.145 as permitted sender) smtp.mailfrom=ej@inai.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758434076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQOMjv/XWFU6ZeX6ZY4a3Y6cru0sQECLaJUnw5UqKBI=;
	b=GkILpTsmLGlnO5qw2Am+SOEaysMaZyaeFZvNY0uNrGoXYi7e+w74bI2KQDRYqq3Tqm5QMH
	EyUA9n9R5JiSXyFDE/vYzHW8yFmIeWkthPnya6h5fWPru8+jQVB0nw9ffjNNfscUJS1kNS
	fdZWoyr4NsDkPEtaNbv+EOXfEIeKCPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758434076; a=rsa-sha256;
	cv=none;
	b=xlQBmRNHPz+OtmXYzqAKUvBX/d4Jte8sQTzLehIjYukN5A8a4J/Z7B0+XbWQxVtKZxfHlr
	bOvpsd6XN4bKo5heMGgP88LNl14cbLZyo24e1Q3w2hW6NV+YZTr92jfM0wjPk+4mvYnKKY
	iG40PwpIcwWy+lBCAzvf50J5CZIeg+s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ej@inai.de designates 144.76.212.145 as permitted sender) smtp.mailfrom=ej@inai.de;
	dmarc=none
Received: by a3.inai.de (Postfix, from userid 25121)
	id AF8151003C5102; Sun, 21 Sep 2025 07:54:31 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id ADE391100A8ED8;
	Sun, 21 Sep 2025 07:54:31 +0200 (CEST)
Date: Sun, 21 Sep 2025 07:54:31 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
    Cong Wang <cwang@multikernel.io>, 
    Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
    Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
    Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, 
    linux-mm@kvack.org
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
Message-ID: <3ns36rp5-rp37-1nns-9q43-op05or6s26nq@vanv.qr>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: dbh68s8tn96opd48apwbucffqoo3ugcs
X-Rspamd-Queue-Id: 8140F40004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758434075-828061
X-HE-Meta: U2FsdGVkX18aUO3XgL3XqTLbgSkosXzq0X0960E1E/pOS/pZH1a555ExnL6tRRgUqJ0TpXHK2WzyLwNKiprNZC9USkvIdZdgpSwgLlmzdLMWXFisnoMRdH6TkQck9Q4NEbtpNc5TXUeGJWDRUWAR9xscvH8iF+VfZMcG2VU9ZjmcuyDeO4hqaPXoPnCNeXYNGpbgHrn7ftwfAjOCht1q9giaSSHTalNlAvUzP2k9EOWL1dTq9evfG/z0GJzHckrgwADANkwv6eUCdCEHZNq2j5xGw6O80dq8L7Rn/t8uuB8SnTJvcl9hU0b+3N4nYJIc58pkpJasNBX0/YUJpo/iZKANer2xxqo+s/9Y1Rdr4HN82iBduVX3PvkyR3umBmPdQoVCrKaidUCxbJk3MgAqpHKgNWWhIC+WJ3mB1Ed5PF8tw1NiewcFe1TNjiwF2SCJ4Xhv6/e/QhYVUEyoF+ox79bd65fJDUB1Ve102cuYBhhyJ40bzSZIzb3xqccIUrwaof+haZG78NVKn1zvg5W996S4ohcjWRk9uPptxJspMBI9LnAtarQFQ/Fyp4Lz1fGb2b2HOs1qQhgvxhrXe1DZkkfaLaJLobfqf+HZ5fn6eaB/gDZdnikRWKx9Lo7Rort3WR3aIwbvHVTIe4Cg4QMvUPHBK/vSlSbtw2DVX+6imW/RmoRw2GBaXnDOztdlKZtrhfX13IwRGI5Nv7qsy/ehtucEG+I8D06zFl5WvP4cfKfMz960OpKLesE26tM0YJjRRmkvq9rgm9HSn7zvej3rxcF1bkecRYMm86Nj96no5LpSFDb7rR7dCgGazekFzlyXcYX004O4CNJEXqaXdwZTWxj1anmHv1XZbJkV1PdP9M2zorBbhrEO4yAfhDix+yOo4IzHGc5ImiBooJkpw6ZmXIoFZovbPitus9OdHwZ9BNyI4gxmPrCvkl65XxaLt8W5RNxc9QH0arpL0fbduTY
 GMSzPcjV
 /oLTOnYfMNz5gkmpwckF4Evfs+UzeJ6HOfMWfaTtKSzcEcaohyZtNjhsnw2q7PCLEMxlpFgaEAE3gzSUBjeg5hRLWoRRWoU+zdPOMb4aYIe/dWzD3BJjueELB+8FbZx/P8A8e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Friday 2025-09-19 00:25, Cong Wang wrote:

>This patch series introduces multikernel architecture support, enabling
>multiple independent kernel instances to coexist and communicate on a
>single physical machine.
>
>Each kernel instance can run on dedicated CPU
>cores while sharing the underlying hardware resources.

I initially read it in such a way that that kernels run without
supervisor, and thus necessarily cooperatively, on a system.

But then I looked at
<https://multikernel.io/assets/images/comparison-architecture-diagrams.svg>,
saw that there is a kernel on top of a kernel, to which my reactive
thought was: "well, that has been done before", e.g. User Mode Linux.
While UML does not technically talk to hardware directly, continuing
the thought "what's stopping a willing developer from giving /dev/mem
to the subordinate kernel".

On second thought, a hypervisor is just some kind of "miniature
kernel" too (if generalizing very hard).

