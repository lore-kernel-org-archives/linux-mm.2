Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 655EBCCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 02:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BEE8E00DF; Mon,  3 Nov 2025 21:49:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4098E00DC; Mon,  3 Nov 2025 21:49:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32F78E00DF; Mon,  3 Nov 2025 21:49:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A01378E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:49:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55BA31603A4
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:49:36 +0000 (UTC)
X-FDA: 84071393952.02.B65787E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C35E40002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:49:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E4bWQ1iW;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762224574; a=rsa-sha256;
	cv=none;
	b=seKtBpYBRYau53favhLsPfFwIVi6j3+VceH0ASKgwaZR5Cb3z0iG2lVyBw2junvelhPZkG
	dSp1hwzvetUB+58w0RNmM4rAURIOR9WI9RadTaLat0QR7QqhsKUdlMSfTpWH3xPgBdeI+e
	ZwWDE+ylHKs48tEwgG/njwGQZ+yDGzE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E4bWQ1iW;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762224574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqaQzZEvebc6TMHyunEVE+xERh4+XbyreXwVwGEjUhU=;
	b=wQah5OWgrP86zFCWuxjQPzXSJV+VCQW4rkkRwpW+8/fzrUTzyk81MMr6+R77N6aI7OchI6
	tqaZYGhjOAVlJSoscH0TBS8NthlLnJckqXoBxCt67ialbcDMwxFCw2n7b3MFnCu6asPw5a
	vm4Ps1R5g1IT3ytpMkhkZtVYun29rp4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4367C43F63;
	Tue,  4 Nov 2025 02:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C63C4CEFD;
	Tue,  4 Nov 2025 02:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762224573;
	bh=pmS6+6nbTBZg9Sai36VoJ0kR5C4vAImQr4aXsiuJMfg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E4bWQ1iWrF2MTS5TlMy71BcsCjBBiB4zv35Huf2oBjnnV4AKlELWYwFgF+4XHEHBQ
	 X9DB5Nh6+7hxZK3QvZ5cRZgZ2yYhrBac8xcfiuP58LFnzMZAigjWZxenfMdKdCjsaA
	 wh/U3UkzpxyO+7QcmVE1dT9KmfK3NR40orjT58io=
Date: Mon, 3 Nov 2025 18:49:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <ankita@nvidia.com>
Cc: <aniketa@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
 <mochs@nvidia.com>, <skolothumtho@nvidia.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <david@redhat.com>,
 <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
 <guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
 <kevin.tian@intel.com>, <alex@shazbot.org>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
 <Jonathan.Cameron@huawei.com>, <ira.weiny@intel.com>,
 <Smita.KoralahalliChannabasappa@amd.com>, <u.kleine-koenig@baylibre.com>,
 <peterz@infradead.org>, <linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] mm: handle poisoning of pfn without struct pages
Message-Id: <20251103184931.5a8e0be8f959ba2a0b6b814b@linux-foundation.org>
In-Reply-To: <20251102184434.2406-3-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
	<20251102184434.2406-3-ankita@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9C35E40002
X-Stat-Signature: uy3ikix6krffyqdiq3tg9xrejo1n9c7o
X-Rspam-User: 
X-HE-Tag: 1762224574-161790
X-HE-Meta: U2FsdGVkX19QoLik0nzN8In33G0Da36efi1hf16/8NVuytnT2SUEonvKL+gpyuVWaUVK6uRnEpw+9Blql7JH82eY0KORjHs1g+MGj4bP6GwFX+r+LjCpzpMSbvELPXKAMVwMVHLfMsw4NZW1cAtwGYYatn+BsSOm1jww3FFM2RV5vA5n+MwuaIou+9NEmHSShFAOoBnVzAqiWA4k8Rui04vY2noxOmHxZ4/ZHjZFVf4T7MIs0ddPsnRXuREqWbWTZVwsq8/HxoBqpL5UXm92NgNVYhGCzjf3N4pTVU9H4FGQv0s08obDQMpuXcYCwGQwlpcD2n7neVuMmrVRuggW3Z0q/3Jo0pSjoKb7PKWndfiFli++IFhwoIBwQi9hTATUTlY/hm8tmqdbG3d/q/9XkALuqJ/VrdtSuVkFJRKMudbknWom6mSQRAFTUhTiNarnkCN5pFcbUbzSB206m3fDxks301OW/LTxWiLcxmMfUKOO1osv6iJ2fq+ci3FaIcVVRM+E1zQ3yVjO7YJMZE8ro16ZZiNflyuoBRUDRJGoaaeQtZmXz5jH6LRYpjsVAInvrqnrYg9WUqxEsdNN0VOUj2fPLpNpKr8UZcvBp/QmhpG8rS70wV+TGfmjxTdYkWxzASGMsK6Rme55DmVfiF/xoNu2eETQG+2GvnkdodEBtj0OKiJp5dIGptaTrFzhlxlgYg1VeDTKgHoY+2W2mTzRUVzIxOe+0M9FZoxY4ftf9hKj+xP8JVdLUg/2EQCwgV+hSCHCH0HmMNWpt3Gn+gQeqE4egtxqaFLtFQpIF2vF+HeurS1qykBobPY/jOgKgR3cebLy65QJLEVLHI6iwMTmLhcA/WRLkIWH1zw5LpUVpqTj7SKgjI1EgDqrSAn+zuLzNKJGUDa1dCakNN5U/9LxVahLoCxt8cGInqxOn3e88rV43uXyLcqI1ljc/ldDBTFHl5S3G/ntMWyXUCSbfkC
 ylB7Zs3B
 zrFzSHQgjWPtp9MANRw6lxKPSv3SvSIduoRor1tUR9t+jlBNWzsaB68AGfBZsWCxfYt+Z6DbgpZKGxuNaiAhsfDnSxIlGd5kcWxjCLERc1Ofm5sM9o5v0NPAT9taEEgrQbCU+QfSaKoSiYWd+qsRMf3ZQWRXT08abHHzk+W7b6vCfqfL5HeRKVCw/PPLJg9P32Cp1nhcHuhqyPMccP0ICI58Ppd2pUEY742Jv/bHJsNkY1yZNH7BcKjC63QxtzbCDS8/9HOVdQKZdmXzePKyvv/xbAlaGns0sua0a/StclxKaabnajunfPQs0wJfUz8C96J2m84stDmb5xadi646LbQiGy6wW1WKRkZlxiigmUgSxz/i9qG+aR0xOqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2 Nov 2025 18:44:33 +0000 <ankita@nvidia.com> wrote:

> diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
> new file mode 100644

OK.  I assume there is a bunch of memory-failure material which can now
be moved into the new memory-failure.h.

