Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11692C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7B96B00AF; Mon, 21 Sep 2026 12:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0419C6B00C3; Mon, 21 Sep 2026 12:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72B26B00C7; Mon, 21 Sep 2026 12:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C51276B00AF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:31:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D64FC0227
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:31:20 +0000 (UTC)
X-FDA: 85238309520.23.49D9EBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 63C1C8000D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:31:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+S0GYnD;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790008278;
	b=FYNnwA7dFhUhuFOXI75FeIE9p2J5dgBdaVe8yhmbb5em4UFE03C4FOaVhvIpzL4lZ8Wzql
	tAugh3iUAWsYhQXtzgE9r9OuurzW1N7nM5P3ZKR25nE3cGK5b9WjBOmdIljfiMVKPjG90N
	nCDZuETg5VmGz2emvOymGpCKTHW2Mfo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+S0GYnD;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790008278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xr1vny0sOsGLPZymUSVuBvQ2lAD5e8F1Q1dBisDoZY=;
	b=6IJRGelwIS7W7fFhNtnzCytyuNmYtGP4Q1bFNQiN+rTUOeHBH/J9BhkVs6/tOTB5aOQkfs
	aohybNc3LIvQFhZbnlXaGp6UApkIHjCEdkuAN52yeHZIn5gw4FnRPWB5g0LE69gt+VjJug
	hXd9ZaYkiPZY/lvt8bjvN+fG5ZBvHUE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79E62444E9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3300E1F00922
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790008277;
	bh=3xr1vny0sOsGLPZymUSVuBvQ2lAD5e8F1Q1dBisDoZY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C+S0GYnDnxQf572qmFuv4S780mk/IXbOQ680vfrSXXVWznzFaC+vc/mENCtzeAoaO
	 TR96FPZfvE1ohsT9EC5mnhZJyTzjNSzDF3VD8CNFuHjmIFRacTTJDgLQR8McwmNbTT
	 gqoEobtoWSrsep5EpRHK4TSGnXKoI/RR1/rgyZf+gg+QpGmlqsiSPNzRzJph9tRPM2
	 rinJHGjVi/SfW3/UWawDlvoRecw/QjVrNAlXlnBwewf6IkOnu1nxl1uBrrIuQLxuZY
	 pXCJKrkmiOdcKBtEyfNJ5G1jxV3kzg6YwnVM/e08v2OCfRj2dzXt//6AQ7JLREu3XL
	 cWldJb3yySW7w==
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9104649a5dcso28915546d6.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:31:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwkEunv8Nk8SPxMwERZSt31RGDFriSU5G2pUOKYQvwM7L9ov6l+v4P7KCrzcKbEeJglm1xvIOCwZQ==@kvack.org
X-Gm-Message-State: AFuF++kxkzoYNfiI2X0afTyQ9OC3GgV+JixunaUTfOTvydpNIh0JvAOV
	GzNyZtcCwl7W0GL5m1BO96JnBN2BhJaVLrUj5CDdhZOQy8OHT9DB93QNdvSLM/ZAhc2AKw3BjdI
	h0WXeCaHdrqNyG/lA9wN+6jM50cHsCvfoUzgQevQKYg==
X-Received: by 2002:a05:6214:8009:b0:912:5a5c:780d with SMTP id
 6a1803df08f44-913fc89d07fmr11633656d6.5.1790008276295; Mon, 21 Sep 2026
 09:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
In-Reply-To: <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 06:31:03 -1000
X-Gmail-Original-Message-ID: <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
X-Gm-Features: AcwNN1WuDTsc28AMiNXH2l4X1GQXl6mvqO7A2s7z-INvZm2ismrDAvJON8rwpw8
Message-ID: <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 63C1C8000D
X-Rspam-User: 
X-Stat-Signature: p9s8mghfe1g79kwzsuatczuzpbjp7ykt
X-HE-Tag: 1790008278-116430
X-HE-Meta: U2FsdGVkX19qZ8v2GhYi0hO5jpNmzsk1t00HlsGCOv3FP+/aVZy7a6dU+xyAK5GCnJxigNYwBFB0cghsBATgdWBOpyCZ6+nv6bCKuxJ+Ccvlgrs9Tp81+S+zR2POAu3VR0pvD8L6o9y5aHlJnqrhT9YCy/7aQBlQRt1OgUFc1ng4BRLMFDhM2DOLnJPRzqVVyHw7wRj0+8E9H2k4xZQ/bxg5Ho6rU0YUpP/XkWXBZaBAfJSyM8SpttOrx3Rbi18P5dXxjvMOqPQ7LT2rDTOhgZEXresIjZ5TUnSoSO24u0lTR157mcKxTQYPbe4mitYfF9hAamIsO2Lj7Sd6gMvm56hM0OkHiKuPme5BWMBQziCjyY5uSj0Qz+FUHr6GO6TD0VaqdB3Yf2PFKqjK6oVpeB+TTu8tjPjZxCJX2ISp+5sfNMSdqA+ne5Lv6D1aLpZyHZ6boNI5INwxJCoGEhz8nKm+zzTX5/25TiKZnOhddlD7QtIduNgkMX9RPrwCWxIsUmgKttdlZZSfx/Yjp6Ur2mjpiLr0Oy4MuxyqUWgrrXasllH9wJcvz5JQW/5rdmxh+Wo+PwTzjqVzKmq9k1PXZKhwCzcLxonTDbYbKdjzQU/tYKjQJMW1LanX+Q331S/I2x+klBXdQzpAejnkDnTVfslbZLk0r+m35VIbAhKoz192tiA4PmZcb2utJ7fPCEEOHEJHFZogW8cI8cy7nw8ojeU+CPrAqX6O+dY/u1/ovLtQ0aZ4x2sB0ZYXoJ+gOac0kRulFdrs8D42BC6S132CGPKAYqpBQsa3dpybe0tdAz3UidUGp8mROm7Fk8YcBDAsY07AFETrKw9hYm6hczj7hubU0cKeZ8o2Qom0qnDQG3ONfu43VYFkwiE23AI2z9EXkYVoV6khvgASk5qmQaCXB/8a20OvYucry9pm76jMyy9oRdUR0y79UfdMyeuOXfpWZu0m/c4PJJRH3U6egZe
 0R9rvF8g
 /+jluRMaIMTV77VN1J0VezQ0KbS9ZWkLXDtMsaRNbtSXYSUrZ29EHvq+Qj1hV3zutyDT/3s9RyiiGL27YtxffZbkUKehtxQKxZGTJ3PLqkQWF611ZDFtwPrUwYcWmyqOzds2fDg/SUUQKP20mfzG3Qh+cHy0wDrinNpck0iJBV72yrIZtMLP7i7LiBeBkW2f/gNx5VrrKHNYhalc6cOr59VD04nQa3sca5//8RBCvyhMecebvYJ7iZbO9xDZSsgmoJUP1k4DkIJ2prddFPY+k1Xz0Xlp8pNSebfJTIPrZf5Kf9XYABoHYI0BWFowdP+8SZDf1uart9av6qLdR+rU74sEDwrL6iWPLBo0dsvguane2zdxVit2XCLOTfVRez+67Van8TCCYpiWaW9RJfNCXsbHyuj1Xqv97A4U7qKkqHMUV/BZjxpg0j7cU8l1n+m1fslmVFWj6tOGX0WT40nrVMZjEtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 5:16=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sun, 2026-09-20 at 23:43 -1000, Chris Li wrote:
> >
> > I am sorry, that is not actual user usage. You need to start from an
> > actual usage case: I have a workload X, only want to give limit Y for
> > the cgroup jobs but with Z SLO requirement. That kind of actual usage
> > requirement.
>
> Limiting how much anonymous memory can be zswapped
> does not guarantee an SLO, though.

Nothing can guarantee an SLO. It is a safeguard we used. Those are
existing use cases.

> We have seen plenty of examples in practice of
> workloads that have swap DISABLED, and are still
> thrashing, because part of the working set of
> that program is in the page cache, and that still
> gets evicted.

I can only imagine adding more zswap will make the workload worse, not bett=
er.

>
> The way you can guarantee the workload is not
> thrashing is to limit the total (anon + file
> cache) address space of the program to within
> some size.
>
> Anything else is not a guarantee.
>
> What is it you are actually asking for?

Give me some real-world examples of people hitting this kind of limit.
e.g. MAX(%)  > 100% and still have a usesable system. I suspect that
with 100% zswap usage, the system becomes unusable. Please show me a
real world case that proves me wrong.

All your use cases are hypothetical, or someone in a corner of the
world is going to have a problem. Give me one usage case I can repeat
and test validate.
You can't even do that, the burden is on you.

In the kernel, we don't break user space behavior for no good reason.

Chris

