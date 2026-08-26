Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEDB8C61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F566B0095; Tue, 25 Aug 2026 21:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976F06B0096; Tue, 25 Aug 2026 21:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866386B0098; Tue, 25 Aug 2026 21:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5643F6B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:40:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9228280107
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:40:05 +0000 (UTC)
X-FDA: 85141714770.11.4DA9F3C
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id B31281A0008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:40:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=daSFR5wq;
	spf=pass (imf19.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=4ncienth@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787708403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9D0ya7fAGHD4mh1WhP+JBRzlt0nXa7uSYqgCddP+Sco=;
	b=BfdjkW9tzK4a6btsH5PERHlP/qxSzR767GTaWNEUiishi1gDgw7r9vMtSeYRCpeyMxAhny
	pPLOzvJTezdFY5vw7NcnZYn7vjBVE+4OOcYK0tcq4bmdumhIC/7iMAUiidadzB9f2CDM/l
	JGz3YMnAw8jxYUF+1GUBkHYA3lh3jTw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787708403;
	b=SrRbN+gVL7G8HEAw9YnGkNZzVI35imMm9owIrBQ3C/JeV220OqKx16ddIKSyo+lRbFSrRx
	v0BKcXxmdpVM8TFAFFV+tyI5s1WzJxn9IG3V/O/CWtAjn3RZxMONVAH6LbWC47JBnWdpqA
	1Y/pPz5FKfNiVligOQl9MZNVSrbFeqM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=daSFR5wq;
	spf=pass (imf19.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=4ncienth@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3965d3d9ab8so463224a91.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787708402; x=1788313202; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9D0ya7fAGHD4mh1WhP+JBRzlt0nXa7uSYqgCddP+Sco=;
        b=daSFR5wqsA4EG3hHLe6+jqNQ13g/JinDluXnc/U/g/e65+8bYTnJAsmB9rYawN1XO9
         iRsF6lSP3LUvL6sHiS3sqRuSYPZyvt23odWgyNkOkL460wnZBoYdVFGcXC0sg8zMy5IE
         1haT28cQvj1u1nuUiVLEpawyNtEoKHcBWaWYp63TKdguWXdkkqXju1rkBkKLoCzatYmK
         FKRfGMjrVxUruywXMvwpS0YvJGz3BVjsrKaJwTYd4GP5vTmdBP0R18sxoAsOt/1ROjdk
         joZf8VabkcANYnGuVhAcnUNuFJu+YHlCCH1DC701q+p2PJf1UvHi8UcN0IihgsbQs7D3
         dVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787708402; x=1788313202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9D0ya7fAGHD4mh1WhP+JBRzlt0nXa7uSYqgCddP+Sco=;
        b=m4BUpWKLgun8ZPBianjH0rbC0Rkbq8dzAcOK5OSUOw5i8XV61/pjNF0zRSM5EOpl49
         6AIQhxx+7AMIQndMAqwTbdwhxSlNyfvxrUulVwnOXzpN+pfry92uMkharAZLmzkOtcWm
         C5EWPeQ2H2YSQPxkeIU5oAyQmsQjMgzTEPEDCVJOZG6Sp00jRYZkh0tHnyEzvgwZt3TD
         GCHERJUN97S3PbW9reZKtw9kXhgR9mVFOiBaiyBzwZx0m/9FmhNGdzAUpjJ8w7Pq9NfI
         JQDtHhRDJRqRyW/zmn6VXy6dfRnI7nPgI63XNlhmjF+SbsC4TaF/m6wYCHDF5dpU8Qaq
         /nAQ==
X-Forwarded-Encrypted: i=1; AHgh+RpVyA44AeUlO8TybMDhRz9jPqMZQWmt1NzscYUPvCxivaHwDX4aUfzxbbl9Z9B/A8d/TxvsId6mRw==@kvack.org
X-Gm-Message-State: AFuF++li4Y1uSJJAoNhfkMaxxIRZX/LDSB2FFgNs+gmkXcJefj1NnObN
	NbfMPB9QeNz+ha5AdAN9QRzBwGWkVb7LPt6TzctuBBXr254lyiWXqvem
X-Gm-Gg: AR+sD11orhKV/kvLz5f+2H6ygAHmF//DWr/So+vYg02uAjcNBfkVA/dLeRgK07Gx6Uw
	Mm23yBBTlp/P055ZRnPpxSWPC9QZVQKxbL+hIHU0KOBkkteoZfh93NgeYnsPE2nogfCRJ3n0SZb
	ypPXeRCGN0bB1XEDhknGEZ0MYR78E72+/g1WXV7Au2TUa7jcXR88lKzd87NSHf5EDAX00WGTryq
	BahG8a2jQtfCMHaZSdmKdv2pAzXeaHl8w/5pkTxVU7TPvaFFnnF48j4ihesoT8hgKVR3z9mo/uo
	5177mtTTusrfxofTfIfOZ783+lOrHmqtOU8KjWxAWtMtyryWyO2xtH6OSQsdKojzwJfZatWokO2
	NGbI7MzooB5plOV/sGNeKff0svvlTnhQVeisYP9s3etHtZW+xeL8s7/6/cbY6qUVLMZTjrd7Faf
	ObHOFHFIXCFkCmd7pXuZBGQLvLAnxLids6P0jewZZyRZLmOqLuFTLN7MYWtyzlLWEN9jpwyAsI
X-Received: by 2002:a17:90b:3cc3:b0:38f:18f9:785 with SMTP id 98e67ed59e1d1-3966d20cde1mr7186084a91.8.1787708402417;
        Tue, 25 Aug 2026 18:40:02 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3965d119724sm3674887a91.2.2026.08.25.18.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 18:40:01 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Hagen Paul Pfeifer <hagen@jauu.net>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/secretmem: properly account locked pages
Date: Wed, 26 Aug 2026 10:39:48 +0900
Message-ID: <20260826013948.1325213-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260822-secretmem-accounting-v2-1-fe445a7c6eb1@kernel.org>
References: <20260822-secretmem-accounting-v2-1-fe445a7c6eb1@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ytorsus5455a8jqwd1rgok7tybor6tkp
X-Rspamd-Queue-Id: B31281A0008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787708403-670265
X-HE-Meta: U2FsdGVkX18jHQqag1Tlv6nFWiKSpzIqps3LRO3FcrVBTlhiFQQxQA2J9WhSB9OKss8nAzMby3639zVnS/Ob4vygjGBX7itrUNvxqG5lhi4TadaammOyNsBgKTd5qtrPdWXVDkye9ImtR47EsJuTVvm80wGO+auw0CVXm+AiTA3NsqGh9ZHZX6/bJsAzrZvpaCWp9Oo98NpypQfagoA/4FZzCFjYrI22e9PDjwoOg95c8qMcoFLpEgOdA+AIZ6UNO6ZOB8DiytGWt5JAQmxfhxnP095SODZts+wnwlvSA2DXJ+k75hRDOpY+cj1+2H1WNaUee9Wvbq2Wp9FHextTny0r7pxoHcRiC8rXX1FPYitBt/gaXImtT1ipb8tG7cmv0w/FIiyUUZmjEZnmDtJzFAijeeY9JKkEyVmALLKfpxvFVCaxwkFU0SqsQZQYV7EdmH2Wa8XLk1gZk4ByJNKcFt1EF0gbONM6t8A7XXgUNqZO1KWvPPxv+OsNRTB/AObqHMReT3DqQr5cAH5KYoLgI6hIhSnXAhtDvuZgardzTOioUcp7deB/sMFJeMQlE2ma7q6jnR/8hHxzQy8sfZsCTT7zCWxXgWAkIh+f4nJsncvaF1AdOPZqwDZOW7jqRwNrsQZGBdfp08ONglOAovN+2Vmi3Q5FnHi5i+yv55Q79140snMhVaUkIy5CpmxHj53oJjWO4AFanG00V3vPuJQLQP5xIRZAIEFs0Y5AftwyMxw3Llx1rllfu8wkYB5+DyRnYAjpfVGh7RYULz7PYvceP7rlEfDWV2KnB1pnu0a1Z4hlWtKdS/VTFxYN+XXydNLrabLgLsyJC+S27HFSa6WrYID2OVtNTWmoV6E8qBFqBKR5uc/F44CukPvw65rRhmFhXHevuYddTXN5Treyphx/tiAKaxhASM2eYEspuywfb4Dq4fRLFK1+scAVx9l5aA+kVNQDXQ9C4tQgPgZh0uA
 W53WxKUt
 TotNhI52wSIwT2XNdfbO1FoinWUBamRJfGyO5JxPH3gPx1AyKHtFKm//AfbZqnZQnfWig0xifo4GCXDE2/g99h8n0PGS3/A9ioOOJOcyHwggOKo9i1YLgStfNH01e6gDaGkRyYC8Q0iCTirKBOTAZ0fgPAhQT9lNNr1JgIAvkiAB38wwOqrWcp1KMeuVCcuzDzGH/HyeXzQG6HdDPVB6mKMlgfCE9FwYHRbc/BkbgJNE4K7+uZ85/G6X8NKlwvwTXSjzkAV+cf0lsOFcvXheScZxpVlERYYQJeRtcBn0DCJUlvB3D3T8BTAFT6OrOHVfd6JZg+1hvWVE+SJwjYy4KjmdJTQA0AlsC1sIH0HbxQjmIZ07u9CYkZ4FT0LefN0k5ZX0Kd42D8biebfSMGnFzgKYthW5Ocnrd2eIRxtvmBIrqBrKVCkKgXZH4dIBgh0f1NH1dSERmRnnWPr2+LejxnddwrzQl9JEbo8/h8UuXU4eg3Lk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

I tested the exact v2 from this Message-ID on its stated base with an x86_64
KASAN kernel. The supplied memfd_secret selftest passed 6/6 in three boots,
and my accounting-boundary suite also passed in three boots. I saw no
patch-attributable KASAN report, warning, Oops, or panic.

A v1/v2 differential also confirms that v2 fixes the CAP_IPC_LOCK creator
delegation issue Mike identified:

  v1: CAP_DELEGATION creator_cap_ipc_lock=1 receiver_uid=2001 receiver_pages=2
  v2: CAP_DELEGATION creator_cap_ipc_lock=1 receiver_uid=2001 receiver_pages=1

I have one policy question before adding Tested-by. With a one-page soft and
hard RLIMIT_MEMLOCK, a non-root task whose only effective and permitted
capability was CAP_IPC_LOCK produced this on v2:

  CAP_ONLY uid=2002 cap_ipc_lock=1 mlock_two_pages=1 faulted_pages=1 raise_hard_rc=-1 raise_hard_errno=1

Thus ordinary mlock() of two pages succeeded, while only one secretmem page
could be faulted. Raising the hard limit failed with EPERM because that
requires CAP_SYS_RESOURCE. Is this divergence from ordinary mlock() the
intended consequence of removing the CAP_IPC_LOCK exemption for secretmem?

I saw the planned selftest split and cleanup in the follow-up discussion. I
will retest the revised patch before adding Tested-by.

Thanks,
Daehyeon

