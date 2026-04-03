Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88351D730A9
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 06:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A023D6B0005; Fri,  3 Apr 2026 02:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4296B0089; Fri,  3 Apr 2026 02:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C90D6B008A; Fri,  3 Apr 2026 02:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5FA6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 02:47:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 072E2140547
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:47:10 +0000 (UTC)
X-FDA: 84616312620.20.26F393D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2F932100009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:47:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PfDHRC92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775198828; a=rsa-sha256;
	cv=none;
	b=wLZoTe4DhsAyih1azD3xBiYjTG9zsaMXmuvtJ7iL4ifGIBn1L21L6Ecveknuqf5P8UMFaZ
	reI2q5JrFRQI6f6RA4QxsZGTRFUVd9eRkgQaAbYV2shbssrub3eRuLZo+KSjDMnJk9Or0e
	DLF/qctPZNCnWDV65FtqNvrYeMwZ3Gk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PfDHRC92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775198828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZtMwrArwn1n0ggKbY3EGmrJCKXgy5o9N8O0vLfmj3c=;
	b=15f/+WUefMKyDrTOO9AFS/RJGdT8oy19rJ+TPASu6DHOjkwUvL5Oi0F7SduX6T3XvhdvQX
	qWWgdk4M5wpa/wyB7QgKeLU38zuRFcUAKMdUG7t7H85tiwZ1Cx3HKl+ELhgNnOnjeTxfjp
	ZW/ya8mzs7rXEhpM0yoAwx9mkrBjkDU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A2F0A60008
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5940FC4CEF7
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775198827;
	bh=kZtMwrArwn1n0ggKbY3EGmrJCKXgy5o9N8O0vLfmj3c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PfDHRC92G8mW4dvZC00A3FLhfSJkmkZ8HJwQPnC4SVGOTt+evwr9gK+zWOeAUOhHD
	 Abk7zg4R5YXWC5k5Olg3XYyMxpVmf9IH6JG+Rm+WKrY70m8s/u04WzEPQRethOTw5d
	 YiOa5Ofl3CJ4hB77J6d9ULs67U+meVmnshaguMWAv6Ve/Z3yxb/INGajm2/po6UPb4
	 Jg/gfzFrG026w68VlY+WbJ5xsaGMFuVBawfAgGJYWSkeq7Mi17wCDl/JeVtQyaEN3S
	 zKM/uHLJS7W70gjlwnjTuthZ4gZHMNX3xMgiTVrEq5GBPZgfxH0tDO+gdt82+n1iuR
	 6jqHixiFOME3A==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8a56ca653ceso16955496d6.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 23:47:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU7aQ2PBPbpIKMG0M/qLKjfFNzvpcmxKvwgRKNvDqTZKEu/CK8IoU8TljnHAVhpl+xMfpFaJ/yhxA==@kvack.org
X-Gm-Message-State: AOJu0Yz+06u6w64bQKrSNI1yn/yE3bPko0kRcszxGUGUNWgKSnMNfavg
	BSHU7x/6uXVmKdHfZqJrEEYiYCbcvyzl996Vo1LCRNhRQCHXkjLM0AEjrxnrLxL3MZwQzS44V+4
	CuoqpGgbYkojGq3vCi2L0oZpoS0sjUoA=
X-Received: by 2002:ad4:5c44:0:b0:89a:b0c:7268 with SMTP id
 6a1803df08f44-8a705782443mr33225426d6.54.1775198826723; Thu, 02 Apr 2026
 23:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org> <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
In-Reply-To: <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 3 Apr 2026 14:46:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y2Fi5zMJDMDoC7ww2WKnX4d0q_k69xmfYhCMt_Q9Va2A@mail.gmail.com>
X-Gm-Features: AQROBzAo7HM7b6XT2k8XUnGxMjBQfY4yovqIYzLSSQt2YNvaiCeXaaJCZxCC9pA
Message-ID: <CAGsJ_4y2Fi5zMJDMDoC7ww2WKnX4d0q_k69xmfYhCMt_Q9Va2A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: huge_memory: use sysfs_match_string() in defrag_store()
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2F932100009
X-Stat-Signature: qo54f55cdpk5p5y1uqdi3gprnynakfaf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775198828-305431
X-HE-Meta: U2FsdGVkX1/bkgt7FzEWOIGzafaLTEMHpQ4XT6ynTxJ4+cBg/+USnk2tVNY/KbwW+mJHrBltnoSgYDwZdfH5KPSyovtrLLi9mFhISEiu69xXkso7bcHmVQ/Zfh99BSnS023g6igPiS7m8PL/z84O0efzveNoBda1iebr0mPq+vCVYCY5oikSaaW2VVn5PQ96r2w0AvEMv42vMlvWywNP8gjiflHumL02pkKLiArJpNo8OphELppyJep6aQt4Iqqj/2AmqELKdg00Hqa0nJOc+TphViWi20RB5IXjuHNhMBiPstF5c37DJIqv/UniqPQXLLhALz/rahPz745vDesr5aDKvZbdpxXvYNW2HFKlWcB6uObepY1NFD/2g1CRzADtS90y5Oc1DBQmBroRKKtyUw57aEscik+iuSaUqpALNXlaNbTQ7RlHBkbGIzUc1FoN2ug3V0TUJ3cliH917wagw/DsK8CIhdmRsaXeeqhHRRbxQLo03dUqg8g/M+84miwloQC5XzEK8ND2mZW5YR9BCC+P0GXk0mHqpxzTzUckS72ksrh9NWb9iGZ8PWg3xWQPFYo5/7jro/vffAefmq20mALSf6L6mMrxZEGw6Oxn4VFVsXChPQIivkkCaNBRw5DGLBBCjOHPqIxSpDucz0gugIV7CqPI7akQU9PB8hwaKo/KrtHPpx7L8IMu80VRNPsGFChoLOfapwWpTRTLuUwomRrpgjxBICUfwj/ae0jjAeFQcTVnBEIlGv8Q0p+A89zc28NcFZSAWJ1YPXfgTlY4d6kWv6KjqNVzF9LTVrg/OPH7PyE6TiTCiOe479bpG72SyzWvOnx743pJuhRck3ngtANGc9VoXBO87jCF/9ojMWbfBvyPFxXqI/c1Qp92zSzTH4m8KcYpdf5uTbGgXTzZvbzVhuTi7zYBtuiu3gkI7wTQ9RoGiSj+4uEbqB0t/Qy5L1p4VKu3AQ45VnEROgd
 /lNMMUxN
 thqCoVyMqABAZ+j4quZkvEGAymC9FUDtEoHQQuYo2eN+A4goNkFXpPaLev9dEN/FQVzdJT1topulrSNdIo9lrQaoaMoi0Vll+8RFSSdig+ksaRDTFLCIIJ5nM3xmvoPI7JUtSstZ3PWIXFfD4yDdsA3X5eKiQbJZzUMGnGBQOhDI53qqh7hS3D27DbTqUS/BMTfU2eiXI9zsdDQuT06vIptqH945GrgMSKe4UzJ2moqCw+znNoR9el22MXvchlor0s7nbOcqvqQ3li6+SAhaaWQ1a6hXvc/CSjhuVESI07rx37yZnoVHSWke9z3S4XU6V+uGp6NctX+mCAsSbB99wUBCJvtuk/HGI6gzddqch/uSD4ZBS21n8kWaKzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 12:06=E2=80=AFAM Breno Leitao <leitao@debian.org> w=
rote:
>
> Replace the if/else chain of sysfs_streq() calls in defrag_store()
> with sysfs_match_string() and a defrag_mode_strings[] table.
>
> Introduce enum defrag_mode and defrag_flags[] array mapping each mode
> to its corresponding transparent_hugepage_flag. The store function now
> loops over defrag_flags[], setting the bit for the selected mode and
> clearing the others. When mode is DEFRAG_NEVER (index 4), no index
> in the 4-element defrag_flags[] matches, so all flags are cleared.
>
> Note that the enum ordering (always, defer, defer+madvise, madvise,
> never) differs from the original if/else chain order in defrag_store()
> (always, defer+madvise, defer, madvise, never). This is intentional to
> match the display order used by defrag_show().
>
> This is a follow-up cleanup to commit 522dfb4ba71f ("mm: huge_memory:
> refactor anon_enabled_store() with change_anon_orders()") which applied
> the same sysfs_match_string() pattern to anon_enabled_store().
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

