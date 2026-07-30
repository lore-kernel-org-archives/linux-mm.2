Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14544C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107486B008C; Thu, 30 Jul 2026 06:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0446B0099; Thu, 30 Jul 2026 06:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36326B009B; Thu, 30 Jul 2026 06:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB3F66B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:57:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CAA6160981
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:57:12 +0000 (UTC)
X-FDA: 85045141104.19.C96EC70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B5B07180004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:57:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKgIuY4R;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785409030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CB2CegvNadEV6Rt1ARiLVxua5opZ3OdqXnTBRWHTtEs=;
	b=zKgq1AIfT425jYtgvkpnBDq0uJGlB6nonjtCqscV5Nv52rfPHRu4tw6Qp3XM9i0MnwDXcV
	SGRWYJaha88EItzEav6s/K3yvkzkMyQ+eXElSIBwWmzeZfqKX/Jw+JnvuOH+U4AQfXMbdY
	bddKdct8AFTYxShWq/Z7F/8euaedjnQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKgIuY4R;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785409030;
	b=fsedFIvDhjXeP1Ne6+mSUoNFRq1AKjQRl+dS3pjg5j0zkaktFZ/mHqWEMjp6wKqTkmW7gS
	CCpmpvHPB2VTmqFRxHnteLSpbf3xRr1T7CU/1RfVeY66ZWWJUvwbCc+mlli4BEQGNfI85H
	UQbf7ssUiiNPKu5drrKy7T0Hd2JCVVk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29F96600B0;
	Thu, 30 Jul 2026 10:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B73A1F000E9;
	Thu, 30 Jul 2026 10:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785409029;
	bh=CB2CegvNadEV6Rt1ARiLVxua5opZ3OdqXnTBRWHTtEs=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=eKgIuY4RMPQnOYJ3+zJU/xBevWUwMfyNBTfjOJ6ESii17VYf9Uy+3tsP8eK1rPx6r
	 o4FZ2yUPOK/tbaGrvDWFAkJWOz5GV49UsoobkkAEihsZuW9JHBOVHZjXEWBASedoUE
	 Ry3dhgCOdoNrm46gDC4EHe5QMNRuYxMsPMUQ1EIRHdPC99f0x4owwVn+0W2q37+nxI
	 qrE70RlC1ejYgG6VqpEc3E0T/sIgO+mqry/N3TgfA0DtB7soNWJC3x3CK4AYWxdgTo
	 8LRaapT/BZR6GcA9ji+sTT7h8jz+eRZsmPB75pYIwc7qYn+Mf8GIR7lL/dJfffGIZH
	 hBmbkS3KH5FqA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 02/17] mm/sparse-vmemmap: rename HVO order macros
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260720093127.540540-3-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-3-songmuchun@bytedance.com>
Date: Thu, 30 Jul 2026 13:57:03 +0300
Message-Id: <178540902325.2154539.18074053116850060206.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5B07180004
X-Stat-Signature: c7q4zqjy9uybg88cww6oa13txu9pset1
X-HE-Tag: 1785409030-389312
X-HE-Meta: U2FsdGVkX18fQ7t8pV+BxxmHBJ/NznL7IGsQB0jMDwrILRYyvv5qUUvH5twzL9IcOpWmCnkBpfSeNgKQGi1KwJ/uc9uVqLMHaTALTBwnp0XtW0gyakSIOWzTO2X937HiYlVaeU8Efk0ZA3gG/53BhGF4IkpekkiYqydKL7WHEYt1c+RxVDhFJ5Gj9k7zgpuvtYoAzc0HexYy3wmDWkbnyzHXYUqEkSfc4Gs4EqhpICV5mbuX47nXeJfsvzdR6C6aYeAR0s0+uf4BxwjCtudedG3gGmHJiUOj6OwEzGUGsNJTiVt1hiL29b4KqP4Jygcqimb1Kdv12W23Q/B+4Y1pJAcKA4wn3wyRoD23uMFnmkXcicVRTCpMG4RYtTxT6buPKW1sVogzgC9FyGT7BlaHGbjP0bsHCl5LQvtDL91vAZG3rW0xF7b2HUXQDiU0DbCO0m/mG1VFUoSjYpFgylifLoFMEPq1VOfziAXOcg6MTSHqhZFJu0+la9bXI1y1JEQVnuuWFPMtq68lPVqjBwYClU0Mk6tZt8SDaLDwN7jHYk0/D8WqpnncpUxBobE/J5+IyIzicJXLgfGaiuOEFHY565oA/NHQXMXmjVKxH3O7mKdBbIkxk3AfZCHypa+Fo0MICZ7zHZgDZA3n02/AzE6AvCjahWX7vLehfsOss4LqcASltG5sRzxJj2/QZBE1/bE0GjhLR+PljdV11TMKyQHfXDUBhgquYuXEFWQiClktwKGCX6Up8HcAADAJ/8w5TiB0+sxoQHiRQZTAQXgqBE2BilfCaoXz+d+hADgWE2SMpow3sKB5F8JtCc/3R0EuwZWEy+woWimcbsFvSZ2tYvJVy529re8qImblpl3M8f+EzTsjpTH63SqV8EOw0EoNWu9c9ki5GxDOEo/GFmVGIfdk4dA9WYp1wLyiE+UIZQKNr872Br5AsddcCCF+ST1Iql9X0oRqAc6OMJmvq+GBGm6
 A5O+kum+
 AQruT+OTNV27hKiioc7z4loVu22MyCg3W2idKDmxh04FVYZ0z54pUtl2+5igI2PNwpjhC09YEjnF/c/Ml/bo4Z9Ow9Mls2SzX13EcBNq4GXLbfPdFPzGUEgqx2y02ZjDMOEwRbOxMgPJ1uJLwtvy/PiOOhnCW0gOtXbcQv3DwGTe3cVplUX7YPDZo8kKITM4CftQcwgw31RHeni0ZjV/ur5WB3MMb4Odr6YRzajKufBDBbIuv37poe9qyUhZUKDg311Mg8t7NJZuqEye61wToAD3p/EsLDjIhELhQO07R9VHP9Lyf/Ky4/Pnann/vNFVlco9+XIyDsfroilNRRT54itFsHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 17:31:12 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> The macros VMEMMAP_TAIL_MIN_ORDER and NR_VMEMMAP_TAILS describe the
> order range where HVO can be applied, but their names tie that range to
> the tail-page cache implementation.
> 
> Rename them with a VMEMMAP_OPTIMIZATION prefix and use the new names in
> the HVO paths. This makes the code describe the optimization requirements
> rather than the tail-page cache implementation detail.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


