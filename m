Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D31CA5FF5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 20:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3E56B0088; Mon,  5 Oct 2026 16:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E366B008C; Mon,  5 Oct 2026 16:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0245A6B0092; Mon,  5 Oct 2026 16:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4CA76B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 16:12:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62185C045E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:12:05 +0000 (UTC)
X-FDA: 85289669010.21.CC682C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6971D10000D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:12:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XrO7StUj;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791231123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07TxSlYygyGizwu2KJq+nLfuTWfbhdZOQVcdtdrnwls=;
	b=xIK5ybm0LKxzW/gILb0yROGNBjJJZ4sHrDMsdhriz7pXyPRsOE1Wh1mo0OzU7pOPXD8QTb
	gIehLlrmAKvgcRSRdYJdYB8VrwcWXi7h2wC4eJ8H1136l+npLF0l1JwWf5B4dCU5k2OrEB
	5I5ebNIo1kFVzvTWhsovH58VNIciHaI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XrO7StUj;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791231123;
	b=MOzbAMelT9U1rG9+wFHMHZIuClPocmsOWe2ymgwJ5Eq8Np2bd84g7YrwqfkXmyss2b9y/P
	adUh+DFAOobG/vg+MnMb3+dc9fjTVIoo+auDvvcytOIJ+WNqr6Q69/fwsZBKF1DQYSMjuj
	vCnweYfrpxU3noSdcwsw3Xm96hsQz4E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D776C412BC
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0011F0089C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791231121;
	bh=07TxSlYygyGizwu2KJq+nLfuTWfbhdZOQVcdtdrnwls=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XrO7StUjqMXCHQdCXLfRRZfvH+Uwk9EhguUvvRp4E+YQOv9St4XL8WHb2pEcl/6FX
	 0eliPvZ2bJA7A7ryQbWS3G4Gn3cclzegjntRSZm7Okk6K9ogM5yi1M21eTe11L6N9W
	 PW+7gzcI1VqH6N8862BkF65QY0HfzZVbP/P/OB89OVDEYFsHas4v/3seejctQnXEbY
	 mAJx8xctGw5R7LVCpsiVP4xH/WGehiHxcfs8oQsOSRgZh2Zwln5ADtHFGxIXkdIgEq
	 8PXFei+q8rwCMo1bfRr/FaxBTo4ffTLrhsAuH/Ft6sBUcLImd8bJqA962EIalqazcg
	 tvRlObOt5uOeQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2e69aa07c3so321604266b.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 13:12:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzjOjLRlC+iCzbbxdXkO8WZCNzkJ/SUx2VqpChIDWJJ5GnEoNkWUX5DUbETbSN3ge5IORfG9p3YtQ==@kvack.org
X-Gm-Message-State: AFuF++mpbS249he9NPXE32fwCMAa9ov1Yxe9MghIkVjVRvv0pWcS1gDT
	1YqHyk8NPmJjhjs9e130UuU/zKDbfPoPr/RChEPhLmkvEwb6BL+4sky6ZINPdzoL/BO9/aG0Xc3
	9bS7j/Cfv4MW2iucPoNHYiURvrAfDbqA=
X-Received: by 2002:a17:907:c011:b0:c29:d33e:9ba3 with SMTP id
 a640c23a62f3a-c2e6e9ca0e8mr731438166b.6.1791231120621; Mon, 05 Oct 2026
 13:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zNJ3mSRf5YyRQYYW-eM2eiFvQMXW4Rh0cT=31jsKZpuSQ@mail.gmail.com>
 <20260903072625.62694-2-itazur@amazon.com> <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
 <aqlpxa61SrzhWF1O@gourry-fedora-PF4VCD3F>
In-Reply-To: <aqlpxa61SrzhWF1O@gourry-fedora-PF4VCD3F>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 5 Oct 2026 13:11:48 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNjeUz1sjOo5VVKefRXkFHF_=H7rAyCghJ4zGSp8Mupsw@mail.gmail.com>
X-Gm-Features: AclHuK9_Dkkt3de2FR8OeLNm291y3_bXQtNm-SuLQJP9zgu2zzwzjIBMyyyGpc0
Message-ID: <CAO9r8zNjeUz1sjOo5VVKefRXkFHF_=H7rAyCghJ4zGSp8Mupsw@mail.gmail.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
To: Gregory Price <gourry@gourry.net>
Cc: Takahiro Itazuri <itazur@amazon.com>, Sean Christopherson <seanjc@google.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	Roy Patrick <patrick.roy@linux.dev>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>, 
	Takahiro Itazuri <zulinx86@gmail.com>, cc-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6971D10000D
X-Stat-Signature: jkguirwgtwzearj35sfm4gt5w68fqu5w
X-HE-Tag: 1791231123-254182
X-HE-Meta: U2FsdGVkX199TPKvmdBLIIn8hs/KK7erpGP15nP6wKFt/fzKUIRMR4NCpyVI1N98Pn/Gq5pVaajhreyLnhGcxm2FQgukCtpk9K2Sy82O54feiUJgKL/FepsSvMjFX45iByO8QzVhAyDayBYMhlohUkm0N5BH2Q9XzK7NjivCI7KcZGY7/vkI7KSjgXl6ADhn0vRdR55CtWmCGwsWUxOCaIhr9th2jjegG0XzHVQg35UUoCw5mRWoWpmu5SbgtocD99IzVdE5WdSlY1EAYmcxHsL26qJhcjX00MbBY/6jvRe4fE0ELhXF5AhhUy17SFsQgetra8lZr/18aVYHPMtfAXtBUtIUKryd9jBGPE5Fx6aGApELvh+TxkTu3/gg7K0jpfwSQw7F88NzA6AtkN8XvrCwry5m5ubpNm5J62Z4/Dhgp+EUrlh+GjPlr9DOjsux2cqa/jsXgKLjX70rXK1xDDigVWGMEMFu8ufpTFGPL/aRBvOOW05q0yf3oGQZfl1/3Le50wC95+9q9Wleykq40+lQLAEFRqNVAP9NmAwE4YtBXLT/d/wEXxODTn+6dYLr28hwp0IWAHw9ItrPtLLoQhJ4ut3wLWvuQ+27p9cJjI5vywcrNKVb5WAN/4JNhjBkuXGa2Tmhf36wq+8iXrB82FqDavy5p7UD30SwmFRUsSmV/EbIQLXTKZ5wVDw7hEJ5d/2NlxIKZmtfhxuxVee5VkKZUKF8oZWrb0BtFTo1z7zN6YVsQcr6VpqDYWVZBvCPJuMlYoBqB7/uFGlv9QlyG4AFy/5d684FcZco5ZAhLJvZVUvY3KC0rZR9/fcfUGDMQryx7C0bMui1JT4D3Edd6KXssaiAE0Y6vmmwXKkpMWR6aUsnQ07GKentSU8Jn0pDKSILiDzoo4mnrWEMqyOr+qgrH0KMEyn7GThleXbQpJon4xVPpr2CWUr6rmBkTkmuFyErW2QMHzxHvKZ62c3
 VdLEnTsX
 yUgEXtqQAkmMRRw12ZQssJyZ5M5z3gQlCGRC8H3FsJ1pSJOvmcPDJHxRiU0zLjjS7QPiVSC21VpRA/tdw/tcGpu9WDSXkrLdvSPAXwVob4JqE/pEy1JoxorIE5l4vuxpIqHbFggAm3NYgkG9OG6cmXXReQPSH8AxWrHU5Q14x2GumuIaCVzbY8c1n/SlqIVwg62/rtDQKsTCVXNRuQBs7ftSOsShChAMVV4Jho+mpmPWx9xt1WkjdEKyALPuvOPKTATcorAUqUp/y3psKdCtQ4Q5CxEPHSo9MgtUAbQ87v2CSYCnXa6sHnNIbeD3Padc90XbprWn2305pSFhM6H1CL9gScd5Wxm38gGEx1FVnS2isJB6FKnk8EpRuuHw1OcQvS3iPK9dsSYFwc+kUQDo9vROailL7xx1aT3tx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 9:01=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Thu, Sep 03, 2026 at 07:06:02AM -0700, Yosry Ahmed wrote:
> > > As far as I know, Brendan is no longer at Google.  I do not know whet=
her
> > > he plans to continue the ALLOC_UNMAPPED / mermap work, or whether som=
eone
> > > else at Google has taken it over.
> >
> > I am currently working on a new version of the ALLOC_UNMAPPED series,
> > I am hoping to send something out soon.
> >
>
> Hi Yosry,
>
> I've been trying to pull just the alloc_flags extensions (bulk and folio
> allocator API extensions) out of this set and my private-node work.
>
> I was taking another browse to make sure I didn't miss anything.
> I just saw this, and noticed i should have probably been cc'ing you
> here instead of Brendan:
>
> https://lore.kernel.org/linux-mm/20260914155115.439742-1-gourry@gourry.ne=
t/
>
> Do you have any concerns with me trying to pull this plumbing out ahead?
> Trying my best not to cause annoying conflicts.

Not at all. I have been poking at ALLOC_UNMAPPED to post v4, but I
have run into several issues (which is why I haven't posted anything
yet). So please feel free to pull out whatever you want, do not block
on this :)

