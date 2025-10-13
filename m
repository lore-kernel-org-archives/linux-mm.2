Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30CEECCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 22:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B09E8E00AE; Mon, 13 Oct 2025 18:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861B18E00A2; Mon, 13 Oct 2025 18:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74FC88E00AE; Mon, 13 Oct 2025 18:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6038E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:14:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 035A416065D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:14:47 +0000 (UTC)
X-FDA: 83994496656.06.8624CFA
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 070F5140018
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:14:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pSuZZaBc;
	spf=pass (imf26.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760393686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Md1A2uKl6kgU9IrfwYn2P5juXiKTWAuirZuzuxL1e5U=;
	b=s//Zt1YDxr1SPXJiERPIWaiCPWuBSAshjaMNvNG42rZMRHFbI93ktV6SXPGsTdJrj8x0Sz
	yKd+7+nh0BhPyyTcRdvnwhNCHHTbs6JoI4K9ZZc8JdmOwr5NKArn1e9YAfUylgUBNFRY7t
	1I8Hp74QZYWRyrd/idIPcU7ezHUoLbY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pSuZZaBc;
	spf=pass (imf26.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760393686; a=rsa-sha256;
	cv=none;
	b=igB6xCFZs4C0F2AlT0Ud4uVexCB9YKkIBTGwc2ho86cOV8kAAyse72CTn0D5L5LAHlXCMK
	Rrl44B1LgPdJWQMunKtWN1NJN0zJgLr817+0WgGKgkdOgfOCFRBJCsCzeuygmg8U8RRx5r
	4C3dMvR72duIHXNxMyxECX38yt2TNFg=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e3f213b59so139025e9.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760393684; x=1760998484; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Md1A2uKl6kgU9IrfwYn2P5juXiKTWAuirZuzuxL1e5U=;
        b=pSuZZaBcv92UWqL9qQMa9Rl3AWaCE+RuDQb5+/i1Xlw9pv2uahKPFGlZqy1K33R2R3
         P3IJCTwVbekyqE9sTDQOMVcFcQb4XasG916R1XDkDdg9Y0hDWi1edtpVv1hFVtW2+uBU
         pZiEhrZm3glf69UFLOu/kwBf80IUwDHUteWE/qySIuQX4q+m7zFmesvxnu2MKiJMifA+
         bhIXHgga1Cb/mERfi+JxqsQUzDi7TG1fpjPbGpw8F6B6b0JY78LsdEH9GACknP6X3Nxj
         bmESsdCptkitGY7kW4Zpspy0vTiiLyI4uCiNpVkwf7dipW4WcD3RLtAc0cHZKf/Fwlsv
         ve7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760393684; x=1760998484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Md1A2uKl6kgU9IrfwYn2P5juXiKTWAuirZuzuxL1e5U=;
        b=gL4b86333nf7HN4QOFShxjTmsfgLQnOkdM+fyaUbgquxn3vMBYKVwhf/3DaQi4pqg2
         pvyD3Xp2o/y1RewRJFsjFuhRJ05akThZldvIehLK022sj0TyEqb09cVUINwmTbSLyEfd
         4RtbR4FA6GnBf+eoXuIINq/TyALIeFJ2kvG9BTlKKQq19IilpAvRQROG+O/Z04KT4gsy
         CUpdGUCq8FjhtwkwGpMnvwJe+B0HWM13G7dYZWkX3eWnZg75wFM2JVu6JRvogkj6JakV
         zp/WmbPo9VYJbH9FSrh35SxiqlsmLd3hgCM2i6q1AkRx3DqM6I6wKS+9Jjf9/DBOwBCH
         1W6g==
X-Forwarded-Encrypted: i=1; AJvYcCVWo7/+CmtxuSXtp7xoZoyLV0dk674j2JUiGXrYyHIJo9qHPMWtCbE7bNv9CgDll7l0OFQEV9lhrQ==@kvack.org
X-Gm-Message-State: AOJu0YzmDtoljlaHJmaH7ve71Cpe41xO7S3UBHhET4XX8smRjpQ6lsq2
	BS64ijfgkwCBBZZVmvyyqmB0NEnvKx8VMeK6u1Alks7LUFPHlWPs4W+ri++KsURSemu2qJOdIfp
	DGyvLYjQQRo0qaozRjSXcvr1jLdvjLrl6iJlfzvZk
X-Gm-Gg: ASbGncsh3CADr9R7sUGQr8q6UK/tU5on1Ja4AAVzBr0J8M9NtfggNCb4FzFYVzqIYB6
	GNoPP5ohxIiyGu1hMTAlg7SSxhJDBds+qClGB6rN9804Ah0KPO6lj2+XzCtFFf0NFhylpEfXtU5
	LfH4tJ41yig6cTdOZnUzyVkEm7eUbz9c7nr4vrlbbX7q5c9x4M0GJgZFazIKzjqmXbsyDLZX+KA
	UoVVDHwgTDOuVwmHtZM8Z0KFjslvyLObyDF/Ohxo7Tx3OQADDU0HwWUbsApqA29DvsHSCbWNQ==
X-Google-Smtp-Source: AGHT+IFcJCh/82hxCUADD7PjVwqcXj1BKwAfYVrS6U33JU7OMnCpfeAPkBJ4TpIW4QhiLTbUSVarRug2eFkrw+QDiaM=
X-Received: by 2002:a05:600c:6008:b0:45a:2861:3625 with SMTP id
 5b1f17b1804b1-46fa9b29309mr9719185e9.4.1760393684151; Mon, 13 Oct 2025
 15:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250118231549.1652825-1-jiaqiyan@google.com> <20250919155832.1084091-1-william.roche@oracle.com>
In-Reply-To: <20250919155832.1084091-1-william.roche@oracle.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 13 Oct 2025 15:14:32 -0700
X-Gm-Features: AS18NWAiJumx-M_L3wK9sogLN4v8v1yPjy0HWjrQ6WoH4VxJm6dQG73LRuSoLVE
Message-ID: <CACw3F521fi5HWhCKi_KrkNLXkw668HO4h8+DjkP2+vBuK-=org@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/3] Userspace MFR Policy via memfd
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>, 
	Ackerley Tng <ackerleytng@google.com>
Cc: jgg@nvidia.com, akpm@linux-foundation.org, ankita@nvidia.com, 
	dave.hansen@linux.intel.com, david@redhat.com, duenwen@google.com, 
	jane.chu@oracle.com, jthoughton@google.com, linmiaohe@huawei.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, nao.horiguchi@gmail.com, 
	osalvador@suse.de, peterx@redhat.com, rientjes@google.com, 
	sidhartha.kumar@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, harry.yoo@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 070F5140018
X-Stat-Signature: abnutfapygtuxqaie6wxksxyoqkbrw6w
X-Rspam-User: 
X-HE-Tag: 1760393685-924289
X-HE-Meta: U2FsdGVkX1/X8ry3oB9R8dGyyQNcbz1Pd7aHLxZyoj17CYjkNKhLM6MHN8FqxYK69BIW9zmjdXvhIyXilvlVK/AgG/4RM8jMDsawltrsgfr8WVvlC71laZKMOoDEHu+C3Xad78NDMi3+z41nWY5fiNmOVSIqRy5DnGIkzo0mtxHIdsJJb/p3+obQZsS82xJ08suN2YecXf83syK9CdKWwQ64zJS+IIhRdP8dPMvvvcSxjzpmM7O3c0WkTyem/Y6GNXtBPDUWa57p/Yzl9h2sf2HYtjTTGMF1Bn8XeD7H6jdo6h5FQP+LP2Bcu06iovPRB4pybvGpi5by4GL2cvx+yQjG4iWu8lzo3PhPZ+VtxdlKZ/KKDZgth7BkzsEbtzs7+VhYAHCAYRaW2O4NJ7LtvKveICXVFlEc8oSXYpeA6JQfTLsWFPRtY8zUcKG0DT5VZ19ydmuAZs2mO1TQIqJEejIT1VrOUHzl1DZV3RB80zqcgK5zjY2cmXRoTaY7fm/C1VYHduJ84vAXYm6E5FtirztaAcbaBh9Gwcz9cuUNkeNtN7GN9rnBeSeasoHxTfVuPvqd3V8lYRihy1WltaU87cyVfRA6HhMv6ZawTKRr0Hp11NgNlAOi21rd+lpj+mbsr3z7iarqey8K1BTV9kUvb0wYK0w5dyJ9e8ictviecQpzqCqbia67Ac7G6HuWk1E4oh5QuNyjvKH5QxZwRZ7arZV0CG5Xe3m9WPOqmfjheqntPMbbzwhX/eu0vj97xikyZWtM504fkGgmTQRRdbctTe2julF9gClfjMfU3njcbQdBfcjQNf3E5t/4ru/TSmE7DX/iAqOHV3nErCm851TpRlcHVhN8iaskI7QrpAIiXAMZThBnggK/Pipu80E2I1CNFqp5LJ74ZxvaLbzAAfu6aB+1OR4XVCid1T3LBhAXYkwLEQyaTsbSzw1C6mCfS7jQ9KkkYocR9bxlX27Jrf/
 brU/Shr6
 3Vojb31gJnyDZSmVu7hX2kUh5sV1hwfUEtL4fh2czYd2NPKw24toMHpyiZjANxpt2FYePSHHwhnJHjnCDshiuZUBN2dBhkqvqdg2o6XprK4A1Epgj6OyJHarTL6K95P342Vs2nSGqhhLLvV/6FPyQRHvDfNCnsIoJvf327tAqp5wuCh3feoh4xbL2jXoQ49CNc9Mpz2+QTPZ/hEhM+VHybkwaAQ7HARNamp+/o1I13Y02kuSfH7hIuzTYUe4hv9TOYnWI7NsXRp5eqRFwLMLHq2ru8Mu5qvvdubSJWjGXmDglcq4nWTcIQ3hMwnncHDDTYLUm1XKFMDkrrJeHd2oIO/mHoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 8:58=E2=80=AFAM =E2=80=9CWilliam Roche <william.roc=
he@oracle.com> wrote:
>
> From: William Roche <william.roche@oracle.com>
>
> Hello,
>
> The possibility to keep a VM using large hugetlbfs pages running after a =
memory
> error is very important, and the possibility described here could be a go=
od
> candidate to address this issue.

Thanks for expressing interest, William, and sorry for getting back to
you so late.

>
> So I would like to provide my feedback after testing this code with the
> introduction of persistent errors in the address space: My tests used a V=
M
> running a kernel able to provide MFD_MF_KEEP_UE_MAPPED memfd segments to =
the
> test program provided with this project. But instead of injecting the err=
ors
> with madvise calls from this program, I get the guest physical address of=
 a
> location and inject the error from the hypervisor into the VM, so that an=
y
> subsequent access to the location is prevented directly from the hypervis=
or
> level.

This is exactly what VMM should do: when it owns or manages the VM
memory with MFD_MF_KEEP_UE_MAPPED, it is then VMM's responsibility to
isolate guest/VCPUs from poisoned memory pages, e.g. by intercepting
such memory accesses.

>
> Using this framework, I realized that the code provided here has a proble=
m:
> When the error impacts a large folio, the release of this folio doesn't i=
solate
> the sub-page(s) actually impacted by the poison. __rmqueue_pcplist() can =
return
> a known poisoned page to get_page_from_freelist().

Just curious, how exactly you can repro this leaking of a known poison
page? It may help me debug my patch.

>
> This revealed some mm limitations, as I would have expected that the
> check_new_pages() mechanism used by the __rmqueue functions would filter =
these
> pages out, but I noticed that this has been disabled by default in 2023 w=
ith:
> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz

Thanks for the reference. I did turned on CONFIG_DEBUG_VM=3Dy during dev
and testing but didn't notice any WARNING on "bad page"; It is very
likely I was just lucky.

>
>
> This problem seems to be avoided if we call take_page_off_buddy(page) in =
the
> filemap_offline_hwpoison_folio_hugetlb() function without testing if
> PageBuddy(page) is true first.

Oh, I think you are right, filemap_offline_hwpoison_folio_hugetlb
shouldn't call take_page_off_buddy(page) depend on PageBuddy(page) or
not. take_page_off_buddy will check PageBuddy or not, on the page_head
of different page orders. So maybe somehow a known poisoned page is
not taken off from buddy allocator due to this?

Let me try to fix it in v2, by the end of the week. If you could test
with your way of repro as well, that will be very helpful!

> But according to me it leaves a (small) race condition where a new page
> allocation could get a poisoned sub-page between the dissolve phase and t=
he
> attempt to remove it from the buddy allocator.
>
> I do have the impression that a correct behavior (isolating an impacted
> sub-page and remapping the valid memory content) using large pages is
> currently only achieved with Transparent Huge Pages.
> If performance requires using Hugetlb pages, than maybe we could accept t=
o
> loose a huge page after a memory impacted MFD_MF_KEEP_UE_MAPPED memfd seg=
ment
> is released ? If it can easily avoid some other corruption.
>
> I'm very interested in finding an appropriate way to deal with memory err=
ors on
> hugetlbfs pages, and willing to help to build a valid solution. This proj=
ect
> showed a real possibility to do so, even in cases where pinned memory is =
used -
> with VFIO for example.
>
> I would really be interested in knowing your feedback about this project,=
 and
> if another solution is considered more adapted to deal with errors on hug=
etlbfs
> pages, please let us know.

There is also another possible path if VMM can change to back VM
memory with *1G guest_memfd*, which wraps 1G hugetlbfs. In Ackerley's
work [1], guest_memfd can split the 1G page for conversions. If we
re-use the splitting for memory failure recovery, we can probably
achieve something generally similar to THP's memory failure recovery:
split 1G to 2M and 4k chunks, then unmap only 4k of poisoned page. We
still lose the 1G TLB size so VM may be subject to some performance
sacrifice.

[1] https://lore.kernel.org/linux-mm/2ae41e0d80339da2b57011622ac2288fed65cd=
01.1747264138.git.ackerleytng@google.com

>
> Thanks in advance for your answers.
> William.

