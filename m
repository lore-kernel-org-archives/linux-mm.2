Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3414CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6A46B0005; Wed, 10 Jun 2026 19:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067316B0088; Wed, 10 Jun 2026 19:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E984E6B008C; Wed, 10 Jun 2026 19:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCAAC6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:40:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B18CA0117
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:40:50 +0000 (UTC)
X-FDA: 84865625460.24.49F2C88
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id 66B33C000E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:40:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GGxJfdpW;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781134848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UG5wcq4wGvKWHWnLLL0Eo5kBz5QOPgbI/QFWsbUleE=;
	b=dqFBL3B9qKkv4NkvGIDnaN8EaiVVb75e4q5F8kJtYnoKNzRgCOKbReb+5ImEjlNoYaCHOH
	iVC3mxXbYqjEvhr24K5Gznv7k2uL7ExBskz62pjW+famiKyGd9o9HOHQtAE/qJc4eWc2sp
	alIHBxx9Y1Qs5QX8GTcd4ODP3NZlKpY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GGxJfdpW;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781134848;
	b=pwvKRj2JeDjKUL+a3d7Rlnzw0zh0Yuxe5r2C5L3SyH2d9dtalJz75tZ8SiBI/ysSdrTZ4g
	NtEzW+mQqMo1sFdYwJbLm2regAOsT1hJ4R47dZKPI6yB7R3hBVobAFCJtOsd4VFuig/bch
	H8nZllDC4ZaaNOl51L3a/f8RCjFep5s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781134848; x=1812670848;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lQQ8KdopoOpPrsJ7rhAMPKyWe8FqtnwugRvEHRrHiuU=;
  b=GGxJfdpWZCnBwHLjbJ812Tej0y4/ailqI1C+pDyj9ICf2EHLRujlwlGL
   lmxVJYHleKrCK9GZSm7n1EBgBPnj0TbTwRW83HFNZJSgutB36hm2OO6dA
   QNAllskSBwxpXQqSS8VVBPOdTPQkp7XHVl8H9hXTSZ3aGTlb+a5CwYkxH
   cDHPWKnviQSExeqLWG4OBE7IFTqWW6LuCbcWX9xXg1dY9w49j4FSJsXs5
   SY/yc0jpb7jxJmUDqkrrtEPMX5mc9ixlws3cB5bOjC2bLmvyxqlygBLaB
   9QSaeoSS4Dn65XkPeD5JwfEYKLvnsGzps4/xjKTR6s/2jyD1sDIVUA4CE
   w==;
X-CSE-ConnectionGUID: QVI31LSHQBaJOlkfgLwK4A==
X-CSE-MsgGUID: K5sqWn6bRdGW+y/3qYAcbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="93050352"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="93050352"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:40:46 -0700
X-CSE-ConnectionGUID: 67A4E6m8Q0eVZ5U1Ujb38g==
X-CSE-MsgGUID: 9oaznthFSHqLORHQWWLQIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="242176498"
Received: from smithj1-mobl2.amr.corp.intel.com (HELO [10.125.110.59]) ([10.125.110.59])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:40:45 -0700
Message-ID: <58e36b2d-d036-471f-b9ad-87facad01fcc@intel.com>
Date: Wed, 10 Jun 2026 16:40:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm: Add RCU-based VMA lookup helper that waits for
 writers
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?=
 =?UTF-8?Q?g?= <arve@android.com>, Carlos Llamas <cmllamas@google.com>,
 Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Todd Kjos <tkjos@android.com>,
 Vlastimil Babka <vbabka@kernel.org>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230415.C0521C88@davehans-spike.ostc.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260610230415.C0521C88@davehans-spike.ostc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 66B33C000E
X-Stat-Signature: e4nmuqpx8yacdxfyfowb4xazfw165esu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781134847-261217
X-HE-Meta: U2FsdGVkX1/9sqGGSeb/ZQY4nIKvGrbTOpyQWT2LJHgf+vU6lJPcSpL8mPUZb5SkAAiJaKbplieTAp+GjA8N5FamVlVJV4N+sFfFyuQm73QBDocM9CrPMYeNwEHncUf3lpWBwqVvgLz9DEZEL491J1nuclOTUTJ4uNQr700feoDz4joUHODvyiy5bsnKuJSKnC6DOHz6lrQyRGlGliDCry5Obojwuh5qNp+9KRoJdJUtGeRSKUba4uhPmRu5E59ZqdpeoXns6bXgYoyiZgd1uwXCWS4YuLcwqlsi/qcRb7GITfaCaMarhQKKN4rYPrnOhjrwbjqGWOQss+IW5m8v8pcGfTlZXZSuwJCZG1P28Jj1nC3+xU9emsFPCLKTnKaWC7ggEQv8YrwaaR/4alzzm77LpgRiFWPdYDYga6rFXyEtQkqzfWWPw3eHZ3PWsCEoEpTI5hWo72vPI6C0y07EtyMnC0wekrIy73Q72FUZKjZtF5yBVOVVagYtAgOlpKSk0b5GSQUgd1xaBUMPUv526jHDNxvAA+rA3hhZmRCH8c9GfzKMbVOb/qYZPo4XmsgpVPud+gxUX45BWrOjQYM/KQtkgSs+BWMTJIiXBK/2HbOL207QEZKesybVZMqnwfWnJ7W7+uo/FAXH69xSxjg1HKiAu7RCF4DauFus8gA5DvnnSs12dxPT37ZhUzAcVelODLx7ohDAFuZzS0cnYrHtOeWL5Njc5GtSaAzhBnQZiTpHHY42Ph9aQRhxp52jZ82RXkfiQG+FyrG7ewWkAbzlFwtF6rxLlW3XJzSX8+fC8akCVsxDHgbzqNYU4aR/6GOIzBt0uTT44WIRJBnBKssiC0cr7bkVyBLXD6VyvVvavkLEoDQdzl6t45oS1xJsxEVGMCCpygb2KLad6vu6ryc9xIQzu7Nds6nhQ8VwJkI5WwC24GUaGA2zVmtejkTD6xEOdDbSxuVZmnXq2vSsnog
 RK4O10FK
 9gMl5YtknPWieGmVKxWtnQz40c1EDMg6CJYm5FUn6j544nm48BhrAcU64DU/CNPAKscb/gaxxy917c6rn43sMXG6kT3Z2O4NnYzyblFRhOPcWo78pc2ul86WdWBlYeypgB2s5jwMcKmetV06XnnIf/9qrvb7kezKfEXO4Cfq2Ju56+38ayfvf7nU91siAKZHnKQXqVLuiG4PhOu8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 16:04, Dave Hansen wrote:
> +	/* Slow path: preclude VMA writers by getting mmap read lock. */
> +	guard(rwsem_read)(&mm->mmap_lock);
> +	if (!vma_start_read_locked(vma))
> +		return NULL;

Welp, I actually ran and tested this, but it's got a big bug. The slow
path is broken. It needs:

	/* Slow path: preclude VMA writers by getting mmap read lock. */
	guard(rwsem_read)(&mm->mmap_lock);
+	vma = vma_lookup(mm, address);
	if (!vma_start_read_locked(vma))
		return NULL;

Because VMA is NULL in slow path otherwise. So it'll definitely need a
v3 or a fixup before it goes anywhere.

