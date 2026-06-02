Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419E3CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8578C6B0489; Tue,  2 Jun 2026 00:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82ED86B048B; Tue,  2 Jun 2026 00:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C026B0490; Tue,  2 Jun 2026 00:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 659796B0489
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:45:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F02A0C296D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:45:43 +0000 (UTC)
X-FDA: 84833734566.23.1DDB20F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 68ED2C0004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:45:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+z0zlI4;
	spf=pass (imf22.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780375542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RI1EMaQf2aC+jwKCogVgIAXfxFKnj7BpW+hiYAKrFZ8=;
	b=Ay3SIlXrXCpB2joM7nkXhxiDNldFrq72qfSsEdCjmmmpBVNeTgv+OAWtWmbQUTkrNC0wyI
	ep/VRjivv5ovZYaO/RsHaG8GD+TWdB21WNgpGyWRmgDF13glSxvmt+TFpPX/zXcOp7cEx8
	prJaWqofRfS20ntxdmK09bgZtghUBgg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+z0zlI4;
	spf=pass (imf22.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780375542;
	b=7LuYYmjfecnElC0eue/epUo2LzYsMp3iH1aQSGfYD9AJiij7hM7chm953b4OZlFbX9PW8V
	xQ03cIv7viwPJcI8ZjqDY44EYlkjhzAKdibs7PoqvrVzieyqTk3vbFLWSryYwZEGfBSv49
	ObanmXDMFF7A67YXXQxa9ZVkEhuIg74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC563600AA;
	Tue,  2 Jun 2026 04:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FB71F00893;
	Tue,  2 Jun 2026 04:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375541;
	bh=RI1EMaQf2aC+jwKCogVgIAXfxFKnj7BpW+hiYAKrFZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m+z0zlI4cyMGOnMErPfrIMqf0iWtdk7EX1MfOrHUoTqiO7tPcBlCZpccxp8Un4k54
	 d2qBnpIBm2HfPas5jkKo+5CiqJTc0hHlU6AGKeMoGVU1Q7onXg6zaSw4wfyk+8qynC
	 fOpFEFW8m8wmylq4C3Q2V2uuIW7bdmjx3cp2g6nLNRMD5/JGUisgSZxJcEUNv0i5ei
	 bBOxMYGMiY2f/W7BXDrfjO7bVl/eWwFhDqSgdpRZjbfGCWHOr6ep2sW/mNsYJZ+kRn
	 AAgXzr10EYrOk7kJVfNJWscoQxhNKbyolztYkQYSqJyOsapQn/9pfNt4IyVsGxoWUr
	 ABHGwIkedbhLg==
Date: Tue, 2 Jun 2026 06:45:32 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 4/5] loongarch/mm: drop vmemmap_check_pmd helper and
 use generic code
Message-ID: <ah5f7NlrmO0bw-pX@localhost.localdomain>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-5-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601084845.3792171-5-songmuchun@bytedance.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 68ED2C0004
X-Stat-Signature: jmqimg6p8ktip8m5w4dsh1bbo85rtz9s
X-Rspam-User: 
X-HE-Tag: 1780375542-500550
X-HE-Meta: U2FsdGVkX196Nuxr74pp0mP+4J0kGxDGF60567zZ2hbXKdha2arvfAXNyOpR/b1NZ66fAYxnkBpTRymgGh1GybThAsYXW2AksfUtTqGzqc0D8B4LGjl1RjSDWdC/+/5jW4neIXQXHNEfCKCGyv09s3jIL9RbXylPP3S8wmS85uu3pMkYDL+QC/fWuRQFAkPtf0VMjyLa+ZCUFpezg+VwUmtOZH8OKw19u+ZeRZPcOBesR5z/Y0es/fzkxjjjaHsYPYzpJzAUWurZr26kj4tepy8WXuSy3RexSeklJ4mEP4bv0A/dbTHmGkPE+G7gKyj5tT7tBQ7tds7jxaH6HTJXiaim+Q4cNRO5iqvW1tcKphXyzJifP/w8Wwj9LtVzr3fQp6R2b7CYTMFvTu0GsYMk+kKKxzIwYHdoH1drmkkbaLXdhJI7+6yMJ456yjpnvuxjwjdklgntky2UYVMCNsPujhoMaWKyTxeaLtSi3sZbsPp29Yt/k42iAiA/QKv1xZflL2PxTJDk7k0YFWi4nRx05X1Qj6RliRF1A9ydCF1OlLZzDAbQkS+qkqcgLQ4MvqJ6tNoHZPUvBvxEOsuc5VdlvZwLLeUwTaDkUqznHYezYQlsB/OBsgcX9arHfyx0YLDvwH1/q567NDnZBlpAw6FmpOXpiartlpyXKMK6aiyv2wtnAQHe6O+yKnzg1bWqu0EOO+yM/kedUdd5yls2swB0ZWP76smBtFIVMMrRxbSESLoiHH2BTKVwCYYxf7GOHcMQ/f513q9Dhluk3QIsuxlLv7SLqDkKwFK65xnBiDkQEJEdGkGQG22USZyQVNNcucK8m9Hmun6AalnXu69nl6Bw+vaqnIcZIx4V2/ydNJOwZwLiwOGLlCt1+HTR8ZOj2eIvngOhIBPkglDuYIWAlYSI6pSHE7IKccrmVRacWS6xWiptCcyQ2sJtoq6T41F3iEUrEdjp20FPHiE9B/zV7Ij
 AljcgD8a
 H6UG9sDGnByeGdelhpbblzlVPR3pf9PYxRmSWQ3OvFcZ4GwPfW2Hn8G7FSkql4WHBsWCj2/y5f92MqTL7mFm8KbyCP5LBhmqf6s917FLYkC0wbcIGAwXV3S6Vkm4m99XQaRbUGtmfnfKwPVJMiBNXWtoyrtuitCX6H1FSi2FIq7NZnm65o4tOBxXpN0GQtTcLqg/YRx8cOTNf9rBy3aSuOmWVoQwmeHJLi9E+HAL5Mdm/EADqznUjYEEZF/8ch3FzRawlLrSTiIdE8bprxJyi6Cag84lSvAe4eGTlOQ16tDoFn3lNRNwKPkpqJtO2m7eXvypDdBQQ3JZlsHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:48:43PM +0800, Muchun Song wrote:
> The generic implementations now suffice; remove the loongarch copies.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

