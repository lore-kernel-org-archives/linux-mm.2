Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B2EE6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 03:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A226B0088; Mon, 22 Dec 2025 22:09:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDA76B0089; Mon, 22 Dec 2025 22:09:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA786B008A; Mon, 22 Dec 2025 22:09:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7EF6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:09:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3350B98BF
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 03:09:26 +0000 (UTC)
X-FDA: 84249255132.29.E2D1D65
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf14.hostedemail.com (Postfix) with ESMTP id 413EF100007
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 03:09:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hhoQX0TE;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766459365; a=rsa-sha256;
	cv=none;
	b=UrojEcYRtO/Ta2x4wtSCNOXkCNQbnIDfrOa32QNZYX0uW74TS9+ZI/aOdX8fnpZh5RJJpZ
	XyKou58JkhB516t/9AAi0Y/mt80GDAaAMa9KVBA659hFZZ1f+OeNqKckOQrqAGcPtkvS+N
	ADxnBPYqaqEIBbqVbpkM7g/0av+G5Ao=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hhoQX0TE;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766459365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZcZnllijaalGMrElgL86g18d/eiz3nxCYnvfBLSc0k=;
	b=FjN3e57lvJbMI+mztmYgH4sni1DPiSw4VRe+pzJQGrYkT6ZneVfd0pqnvkkgQByDKpOhfZ
	OgbS4BlS2Wpqjsow7UdMxYXv9RPZoHOhcXv3U9mQqwB7Xu6YLk/HztoOjwkFTV9A2TxyYM
	WffqYnDGxVxO71X8o802W42GpbT/ELM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766459361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ZcZnllijaalGMrElgL86g18d/eiz3nxCYnvfBLSc0k=;
	b=hhoQX0TEXgJB7rWiNxT4i3slue/uWm/NO9pe5bG3CNmAc0ky5okhCeylMjNbsQsyrHoOKr
	RL1mtMMGm+s9eMaPcA5K3dip3fHNMrQBh2A/DzL36Vq+yPsR01qj3It9eLJKUWV16nIGyN
	cWsokGNXndUoPM7ovLn8DOZv5bGjaZA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf <bpf@vger.kernel.org>,  linux-mm <linux-mm@kvack.org>,  LKML
 <linux-kernel@vger.kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  Alexei Starovoitov <ast@kernel.org>,  Daniel Borkmann
 <daniel@iogearbox.net>,  Shakeel Butt <shakeel.butt@linux.dev>,  Michal
 Hocko <mhocko@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v3 4/6] mm: introduce BPF kfuncs to access
 memcg statistics and events
In-Reply-To: <CAADnVQJ_WLMRXYV5p4Lk2+nxdC01iAaKQhYecMjx4rXdBeXjNw@mail.gmail.com>
	(Alexei Starovoitov's message of "Mon, 22 Dec 2025 16:11:19 -1000")
References: <20251222221754.186191-1-roman.gushchin@linux.dev>
	<20251222221754.186191-5-roman.gushchin@linux.dev>
	<CAADnVQJ_WLMRXYV5p4Lk2+nxdC01iAaKQhYecMjx4rXdBeXjNw@mail.gmail.com>
Date: Mon, 22 Dec 2025 19:09:14 -0800
Message-ID: <87ms39c2sl.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 413EF100007
X-Rspamd-Server: rspam04
X-Stat-Signature: khr1jaqguzm9dw66cao3a9uruedkdeyx
X-HE-Tag: 1766459365-669031
X-HE-Meta: U2FsdGVkX19NrII/NY+iwpvhWhs3OaKUesllvIXAjYJLKx+G5tQfS2GAw9IQbH6e4uA7yCwAn0H+Qo0OCtwJjK4SpDBfT1aCwNpQBAJTuWFUoP+DHM5s+Q9NQTDsGzxxbdX6wlLboCageR91zCXdkBQtBwtSW2R/CorAlsxmeVK9siSXRwC2jBWGvlpEYe4vpFHGV14Rik4QjfPzP0VoLP2goy8/v6iL81VdE7AoDXpgsMNA48n2jF8jKLDYAome+hmSd1YllTO9LhqJGRDC3t1r3nvpFxe2AhDQSb/3VpzzLR3eoA2zZYRd60NQO/mUDVmVubgKtBVt++DA/fZABo5jCE07YLsz9POiFnh28aaJxWHFagCxEtK22biFP/nKdZpRpS/f46+zKmozUk4UICElUpiRkoNbLn8iwBCaNDBDlngDfhnE7IiaNaJwVkKzQHvIkbHXGhv5xwsDrSrBjQizVQoQEcJpMCWIONJSNrRfOjrV4u27kM89ydKuE4WKv0dDggCL7ZXWYGW700CwwHHLSfYDOA2z7L8S3soNiSAaI97bDeOyFnEVSqFNIAqG/EJ74NJnLv3eSw6GeiFUWeX65VxzWggC5vMzLtu12P7R5ZCAbLbhkezHkDs0bl7GvjnH45UU3bkUEjl4OrEFPMcRK9EuHxWF5rN+pylaszC1L7xzdNLUlpYm8m5c5JtRqmSgV14XMJxYBzBNyMRtxFFqh3Ho2njrpV+AuVn5dZEsNK1bfZzp5fY96yNWIUNnqZtp52QodySRxGhZUuuYfYgzFdfP0WEq3N6+owINhZKg04SvlXyD5Py+bdp/so3vmDG+C6eOJ/zP1RONwArw31+7M6eAZ6/T3UlthC0ifGhKWyC+66FTbuThYCNPvl58LRtOM20Xss2yia3pnnTJOOKebZHJmlwijGeLGn4xdPgaWLxyNmaccqScPojwuLXs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Dec 22, 2025 at 12:18=E2=80=AFPM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> +       if (idx < 0 || idx >=3D MEMCG_NR_STAT || !memcg_stat_item_valid(=
idx))
>> +               return (unsigned long)-1;
>
> memcg_stat_item_valid() and memcg_stat_item_valid()
> helpers introduced specifically to be used in these kfuncs,
> so I feel it's cleaner to do all idx checking within them
> instead of splitting the checks like this.
> Then it will be easier to see that
> memcg_stat_item_valid(idx) access is in bounds when idx < MEMCG_NR_STAT
>
> Also I'd do one check like (u32)idx >=3D MEMCG_NR_STAT
> and drop idx < 0 part. Compiler is probably smart enough to
> optimize this way itself, but I'd still do one check.

Sure, good point.
Thanks for reviews!

