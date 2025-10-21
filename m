Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D76ECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 10:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C428E001D; Tue, 21 Oct 2025 06:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC128E0002; Tue, 21 Oct 2025 06:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB388E001D; Tue, 21 Oct 2025 06:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9382D8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:06:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4196D140406
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:06:14 +0000 (UTC)
X-FDA: 84021691068.13.785810F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0050018000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:06:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YuUhwjs8;
	spf=pass (imf16.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761041172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5tRHSKB378wUj6DIWLwa+5I8dp/1qlo2CfW43riSIf8=;
	b=TnS06/YT8R/I0iJi8XjRT5q/9iEyTTgLsa3ruV7M3NKzwl/GAIB/vOiVCnrtgdpL0hN/nW
	DhtplTIZMbrd8cNMKhhXKAPvpCZ7AEl8bi5vOOOwKqhoiHyefogMh3s7/xZZNnj8xCKOD9
	nYZt4LUNqzgxTVwhyjFbrguNUfK4Xr8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YuUhwjs8;
	spf=pass (imf16.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761041172; a=rsa-sha256;
	cv=none;
	b=qGffJbYhrYAudAx0p+bzH5uPk1HgQcnWf2y1gO0hCya+1Afy0GBrbdjNiajxR4VERb/eMN
	OkL7QAohIPcK03mo+H8uaS7zx2TE2zinPb/58/BfqaXU6+I46AvxXW0RmiDJPW5av70L7P
	5ykGL/bBDQaI9RIznoI/NRLjxT3AtJ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761041171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5tRHSKB378wUj6DIWLwa+5I8dp/1qlo2CfW43riSIf8=;
	b=YuUhwjs8nSu+z2gDiGCDhTsjWgYc9BrMMgC30Ee9cSXvybSjV73748t4DpPvNT83Q7N41Q
	SMwlL3OD16BdNSFJfDo2nVKr4IZ6uAhZmjM87zMUady2s55VGXxat6A3BZCwzMsv+GORks
	KXqTH0+RmQNTYRavI5cP/Tvv6R2GLIA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-j3FJMzBqNR-IIchVnJAZBg-1; Tue, 21 Oct 2025 06:06:09 -0400
X-MC-Unique: j3FJMzBqNR-IIchVnJAZBg-1
X-Mimecast-MFC-AGG-ID: j3FJMzBqNR-IIchVnJAZBg_1761041169
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42851b6a659so157703f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761041168; x=1761645968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5tRHSKB378wUj6DIWLwa+5I8dp/1qlo2CfW43riSIf8=;
        b=ZAMltkvfVYJuqVHG4d+g7WInHeUgTt8UUhSDzPfuR0OVuIwqtHNoCi0dMtWA6aGoOw
         7Pk526xXv+xsYGnbGcEUcyoz1rqM+UKtLsm9HSZVO0sGu1Mj57gL0Md6dmuOgCIwszTD
         z2GbFaQm3pIdqTEKdZLtcCcwWrZPI2xpw1U5e13JVeLcxB+y1052chjYgJRuSyxJyJhZ
         F3jiTCe38LlHQ7+SGsR42doZefKg7D9ySwEVjTqk6EP1LKJojlhGaruixsq+k7FvDv0L
         1hZMvtrEC3e7ZSIFkwmIsiPj+33xNuouDmkbyVinoUQjnnYodF4bN85IesLMOayn3jMy
         eGMA==
X-Gm-Message-State: AOJu0Yz5B1see6rPyYZ31SQRmm/012xL4mrNliXba20GrrCU/Qw3+rQ0
	HelPDUXt22Mb3p0TVORrINRy0zPLfz/lbMgkh9GwP2ocLpeIZ5SjHHhQzDdUkYBjPTZf859L5w0
	YkZHLJptN5U7M4wKptf1Bob4Hrncftq0f8tV5hM2CjjF0SCHi+OmXHTNDPeG+
X-Gm-Gg: ASbGncvuGbMFsZf/qUZjxDk6YveGOyrDQVwXjN2CD53Pag99NRLiSpIFNcUO2kYj38b
	zAL7/MRX1Kzy2tgpU4j5CZMTTVCpiENQ0oKsBmR1JGhcOhg50I76nYtP2Q14BiXbCXVOw9MCjhl
	MkvApJd/aX43Rh5MyzRmrUtTytjtrwAe8FG4wJGnF1Qk4ycjone3RdS1hOjtbjPpHmX1PAZ264F
	OcSJYg9L8vWsqvBtkcaWWH9IzRIkQk2OAjX9xn6IZLJTsisWx15VO5RQergINMhsqitPaY2xEup
	Dho+chRZo2Ir2ze3qrNJfuiVHSmywZTgc60GYntXgsaY2OthXq4ZnHKiLv0sER/pF8Ucdcjen8/
	/em7e8cEmJVh/MABxYCSqMGhO/DX5vQUD5aPOC/OGT3fJNwEAXGa12IQx2Hpn
X-Received: by 2002:a05:6000:25ee:b0:427:697:c2db with SMTP id ffacd0b85a97d-4270697c302mr9342460f8f.20.1761041168520;
        Tue, 21 Oct 2025 03:06:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEInIXj3wBV2ru8CJ8e9i4dsSkU7c375jECkW1lOIjIo9JaHXcLWvinfDrHj+KGluxpyRnWdg==
X-Received: by 2002:a05:6000:25ee:b0:427:697:c2db with SMTP id ffacd0b85a97d-4270697c302mr9342440f8f.20.1761041168078;
        Tue, 21 Oct 2025 03:06:08 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-471144b5c91sm272072255e9.11.2025.10.21.03.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 03:06:07 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v1 0/2] powerpc/pseries/cmm: two smaller fixes
Date: Tue, 21 Oct 2025 12:06:04 +0200
Message-ID: <20251021100606.148294-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hy6JJm6HIbWyhqvmpw1Uc0nmprLt_zRCLh2IH2RtwMY_1761041169
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: r1rtn6rbq7x4bsd3mnnuy6eypjfm8ddf
X-Rspamd-Queue-Id: 0050018000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761041171-384716
X-HE-Meta: U2FsdGVkX18d94MzSYwdiGld/8QxHxsHKTiX7tkPBOnPiwH/2YBTGplF0MsuBvOYM1CaakqqoB4O3wj0/U/z9bZosNyBoc+xSHURmwGsauGLxR4xlHXJrhZ+mZQQSpeloJl3/2JPZxBnqRp3rHRocFDpzmGp9cw/v18y7LK2qbSkUKDe1UXs8mvwzixv7txzY1LNgrOwv36G5NpuczAfFJvp9a5FJQk9LTqr0E2k8F77fejvf1HGq4Gfanv7d9c9v8daqRJTmB61dFBvFUpF49tKz26pYIHRqz1bWa1z6fA7gMXAghOE/nZK5FfrfQbVfAXrAYD+Lx1Vo43XnWOOXGuTPSsmcazIM+HaIW309KpYoV5i9eX4eDbrbdrtXgR2VrG8RpqE7fj2+WLejDFr+cp1rZO/N199YSBLE42o19GKV8RWeoi2lGCJP1CJQfVBdB3LgtO/pZ7H0/weXZk3f3CbDQ6E9a45rSzfivbwElMH8GQNuecqojHftyQEjAD+YI8ClDLD28AQNbYDQ38cPz+UoWm59N8kLAVQ7BN0Vy8zZQpjr8zLxSCodm+wOR26Xe6j7sZWtTZ2SWqNye8GCaqEDNggGkAboz7fL9Emc5QX3Xkkctpif7ZRxVhSG+zPbs/7sXIhXybJDNYmt56yYb0QymzxGcTaCxSUYm7IH1hh0lLYclXoSQTbjAROUgUignFrc4LHy2c02p/QfaJy+3AyOXids7+/SpNx/TDekCFoPjFX3IrOE8ny2WEI6FUfNECoqQsq5Q/CDoZYxNPM9jZqsBMtJVStp/fP04twZMN6xWpVYcqjxdAfECRs4HYhkG6buQcvKU+91IFOhmjc/EbgOufPpXm8AdC7GWiqZCZZLIW3b5DVemcd7OqtK8ybqW47XlODMUa9BNnTMe+g8x0wxJwSkMitGU7S6yD/H5gzLR7Ihc5Ps6c8RuyWiI7YRuATWGsUbS8AnBMyFaY
 WGKkkxhe
 CZkMVgt1PZtvreMXXGgljY4M2NL1d/U7C4SPmcDX8BfyOMya9JGDQPFN1rqfVKTZAHyxoLsvjwZfUKlpqmh2LKdsI0oKUTEaO9+HYnJS8aU1KcwMz5TxgvETxroqZoPWZAJr/t5u3igkH/CUqtJ8eYbWGLsnYIQWr/ziUyCghqHhd+WEFnFnX6PVZQPntLZb+IteH+XZy/6S2jU2KLEt3CtL0PNPrLGEPLY1WumqXrR0WEK/4OrcOnNVQuG2BLIoiBgtw1W1Fm8ds6m8qVTgArSysd3Gf7nkI3wFXP6BfxuYrwhSyLAIsCraa46wUTkeERMQc+THMVmHr6yTVSI5wmNKeD41I7gEHzSCD47nqfN1dcI7XusfU2ZLV9M9zoI+2fdcllJPiN23f5BUtlhViuviDO/7Xk+A9fr2KbsSGBIobjnbz2sVk9mlUlVJX3wXrj5n+Q0U3Gg7KGDj/WspZjEO/4mOeyaWAi2knLmCTLvtcPIpeK/K/BV0QKh5Y4FQlNUY9OgbgRrIp/Oe7picSmbKu6ACvP4phPPj+zwYb8cyjKBYJKOMgcy5rwDPtvzdU+X1araUVdySn+PofJ4XGY6h7nzOxMeiS+p/k6yQZVqAJ9cm/cu6rQ3XEOBBLyZSZoaPyDgT7YvMTH9PO5doWq8W0EGxaJ0RJxHeBpjLiR+kdoK39wIi/3o6J+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two smaller fixes identified while doing a bigger rework.

Compile-tested only as I don't have an easy way to test right now.

I would prefer for these patches to go through the MM tree as I will
be sending out a bigger version soon that is based on this series --
I split of the fixes from the other stuff.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>

David Hildenbrand (2):
  powerpc/pseries/cmm: call balloon_devinfo_init() also without
    CONFIG_BALLOON_COMPACTION
  powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages

 arch/powerpc/platforms/pseries/cmm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


base-commit: 8841ba63f874d5dc05fc4beb47788406be96fd5c
-- 
2.51.0


