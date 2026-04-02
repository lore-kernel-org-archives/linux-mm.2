Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FCD5CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A447D6B0088; Thu,  2 Apr 2026 00:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE816B0089; Thu,  2 Apr 2026 00:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896216B008C; Thu,  2 Apr 2026 00:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7474A6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:35:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23BB6E093E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:35:48 +0000 (UTC)
X-FDA: 84612352776.09.A900336
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 742BB100007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:35:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MsBLavZG;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775104546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex4olADDsDS+O0/vImpsTSMTpTa6qEYgLRsG4Oh7d2g=;
	b=Ke0P61uGNU3LRAo2j5fTavNyQnUynemxrpcSVES77H/J+HiWEqTlr4fMwZ0pgYDxWc20/l
	livbNMMbJXrYDtx9DA9OX2NTGc8k7BJYgOt0x5kNb29kfrOf7JENVgSGhra9inBVEwKirc
	d1ui740QMQVzizGRpNyVht2ywOT3cEI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MsBLavZG;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775104546; a=rsa-sha256;
	cv=none;
	b=3/JH8U+J4fCZJClHm4cc8pEkMYLX6k+PicmBCwlZnKIfOOZHwsW0ccaAY4Nj6sG57pBlQe
	CHhxZ5nHowQlf3b7vNAFRNYxKHZ8z2RHcYhvD4n/qCcDSCHIGYoWnP3Ae0gXv8Z26vVf+/
	O/B/8kpaLBkiMaa826BtCXW660BBUWc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC37B61855;
	Thu,  2 Apr 2026 04:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDF6C19423;
	Thu,  2 Apr 2026 04:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775104545;
	bh=dyZDLpwSsmiWGdb3XAQ9uOEMQCQcXcrQwT6RziiKjgY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MsBLavZGgHjshyBlG8mt6tKnxV58eRjuTojZ1d8BmLYcH1n3CvEag5AO02cMVTNiG
	 qrcmaaQURV3BbbqlFFOkv7nHrtoDI0hT2GX4WND/7w9xvKnHAqiXW7ISCywcrPMXHy
	 DzL2TZIUEBg/JDaTU3QbfSNO2UI7qhc3xxPLijIM=
Date: Wed, 1 Apr 2026 21:35:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andrei Vagin
 <avagin@google.com>, Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, James
 Houghton <jthoughton@google.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin
 <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 00/15] mm, kvm: allow uffd support in guest_memfd
Message-Id: <20260401213544.fe69a9a20e0ab052c8fa8b24@linux-foundation.org>
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 742BB100007
X-Stat-Signature: dyfu3dwm19y6fzdp4ja4bdggu46baoc7
X-Rspam-User: 
X-HE-Tag: 1775104546-725268
X-HE-Meta: U2FsdGVkX18lXZuIh8FMVfQvg3RhU2RlgWG/fAgvD+98CV6C3gKPs3HaM//J4LIMdu5S9eZ3LsvgZQEg4aFN0N5BZ1aPoLFXszIeJgqvZPbFuejb7Bu3xT8NJG0LkqmT0i2+tfS0y9lPv3fQPhYVyPHGIvFrNPkaafEwdQbDD4ExNENMX+BPhCYVp5WbBYO4sjL5mQBTcwZh13gYKiUNQE2Lmf5py2CAyAiiUEWMJFHVVZHJEnxsLZ66N9W0EnJe75hZfmTGXDH+98f1kTg0etqsVPrHAH+i/tSkyjYE/Y5uDi43/EqV8FfJY3kBdVzRrbQRHUxg9iloYNlTgy9Ky75w6JH1r25sdj0jKyWPBtpI1BRPtkJNbkTMs1SZDOeVK9gKe1fTLGMbmO0meVIKlWU1wG2Vxfr/BSQSS6St2N0W+bo91Z9I6e4GqeUUDxcMVn9MBH2y3E5t27jKUV/eep83RrZLNBcPpNDWOM1+ZL17Q+pwJH0kwen9iLeWba5V0wIuh7yfpNltYfYT4AZLVk9iYhNOyVERkuSla6l8tpY5Fa9ghkhEfi5GY65SMsn79rmBUpMgFWpbkH0sqEi3lNcOd5RMLXqGhxYKG6szZic1napsh+fcgGECEYKgWBLQ6lWDSxdxZXmmr/hQVclAhwu7YkUmdkK6tlLvFcwiUGQ7JeqY+jUZBYLcKq+CCEI/yp74yCBOe40jOiuVgbuXr5Umco10TZ/8mLAm8IMqxPWLZuIT645bLjP8qBExlluTmb+Kt3dORH3sHol5owsIdsTY1QNwx++Ny4o8Ifc3eAZodMEvjeKsu+VZSpuPGbMWeZr+DNHt5+5Fuhdaluyr21LIv5hIFD1fWWT3SZuy650HONH11x1pXcvTVlPu969oK+cnU02WtcRh4WWwZBkg1KzH4ym4oAyMUE1TpWW22Cva92PPeh2JbybpdyX3EawSIxWjbS+cM4Q1p4fBuvf
 BTDNCaP9
 KRnk9eWLGnvjH13p/qCWdeu3GMWoMlzqrQlzsAayYAc6u+ER7SKJaIFfhQ3LGhCmWvpuf0352B9poYJCKvT8Zck/Fis7dYddPPxGGcrrihDGfC/CWhh4CwnukngMmt0RVH86jrDLV05JI+I4CQK2OHLHGXRmApGY/Mtq2WJ3hUDJLvmWyuxXFD11MLw2LxTCLXgEuh4yzIEgvEIEy8javrDl6IsYksakQv8VaVuDhAC6eb/CAhThj6sCVlH+aWEBm91WW1ODaX7P/2WVaSwWEjU6klv4f3fFEHhD8f8JckJUXA2wED1+shkHnWlezT5fpVCDp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 07:11:41 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> These patches enable support for userfaultfd in guest_memfd.

Thanks, I updated mm.git to this version.

> v4 changes:
> * fix lock leak not only in patch 4, but also in patch 2, thanks Harry

And....  this resulted in no overall alteration to mm.git, which broke
my very surprised script!

iirc, this series was to fix a little bisection hole, so this is to be
expected?


