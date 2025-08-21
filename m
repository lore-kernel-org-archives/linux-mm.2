Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5CCBCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0868E0045; Thu, 21 Aug 2025 16:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73AF78E0047; Thu, 21 Aug 2025 16:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565D48E0045; Thu, 21 Aug 2025 16:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6BD8E0047
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 090A650449
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:49 +0000 (UTC)
X-FDA: 83801852778.24.A576C58
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id 63F7920005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnKBChYNBt6k7pWFZ1VK2zlCQ3hhOdGhc0x5VCAB6rA=;
	b=RoonBiRS6WgfGe7QY7s0zngFRoEdpjQbfgZIwBUsqF8pZQI0SoizmgMIChAbunyM8Y+LNt
	49VPZPYWjkvCx1UluFlllKmvM2jmdbXCc4aeyrlqdEZUWAxO56PaYbrA/2lWHf9ChpAnkw
	Ljc6GyOwnYrgAxpNtCTtqEA4bFieMfw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755806926; a=rsa-sha256;
	cv=pass;
	b=ICaEOcmEH14Itx50yx3jUBJ6vYvtb6QG6vjEL4U0Az5ige+GFk6+BwsTcG6yaLZ7DMEGuX
	0NWn7gPQ1d/abKHopVSn80gf4rkvU3+zCjUO+y+pXWbNYoKOEBJQ2M2U6VHvIFYM+WLTLM
	yzQUTYvtxuqi5NmpG538tQFFHyHDykQ=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4280C056F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:45 +0000 (UTC)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B566A81F7B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:45 +0000 (UTC)
X-FDA: 83801852610.20.C08AE2F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8580F160008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806923; a=rsa-sha256;
	cv=none;
	b=b+YcVOq4LDa9AGDpwk2DigivUF6xAxhjvi3jj1lzmdWmZ40cCPcyE4mBr8oa2JWmc5QJtU
	8VKeQeo7hLzrLxSHst1zfia9W4E0gmQ+8aeVL0XqzzxRzh0mg1AyCkr44scCQGLEsmyNeE
	j0Ce10MQD94Q8nE1HxjtuNsYdIV1SOU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CzmGaUii;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnKBChYNBt6k7pWFZ1VK2zlCQ3hhOdGhc0x5VCAB6rA=;
	b=xc//GTXpvGX7fXBTi+gbp31cu0ZNkIsblaA31BakklId5DZP5G1Zm44SJ773SXO8wAHcIQ
	pdYAR6iuqagtAdRizro5EEVedLImI9b8O70uxbADmXrcJ8hiK92jrp85ydLKWn7yp2HBWx
	YkEcy73kccIIj0yvJEY5cEewoAdvAsk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnKBChYNBt6k7pWFZ1VK2zlCQ3hhOdGhc0x5VCAB6rA=;
	b=CzmGaUiiH135QgXQPa2GhxtkqHGW1H7LLKC59fxfjy/fCH7u3PG6m1Jw3xTI195snKEAwO
	MKwmOT8pxEhTVPupqSKUKXZDR8f6LOvZWaGzkF3qZDd/4qRO9CeWunW6QgOekDSW9NiJK9
	Ql3EEslQ0UceZ+uqpdIGpf4/iz2sLlg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-PT-Mvyt5NhGns0BxSZCRmw-1; Thu, 21 Aug 2025 16:08:41 -0400
X-MC-Unique: PT-Mvyt5NhGns0BxSZCRmw-1
X-Mimecast-MFC-AGG-ID: PT-Mvyt5NhGns0BxSZCRmw_1755806920
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9d41bd50aso996048f8f.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806920; x=1756411720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OnKBChYNBt6k7pWFZ1VK2zlCQ3hhOdGhc0x5VCAB6rA=;
        b=jVnWS0LsQjErcqG2qr+W+NXsqs58IhkJbEksZNt326ey8n4i3Xoy2H23DqGCKwXDzO
         FSy+VyE9YeO7zTDDvUNnM93RYVR4NXICa6zuDaSxOU2zC3xQ0ynYVWmRzFqwAkqnchhz
         dRv56PyGngQYKXFgH9a3SoIODLggh/A9Gn85gVEQy+MlzJoBl2IO3AqOaxf+AH6ClGZw
         ZpUBxUm/2nQ3ZVQ8kgIDB+L+POugsiRBqPRuj1DIblEBWQqrL9IQWb0KWPpwUHe9uoR5
         I6TfFqMZ7oyFzxsaNOCeqxm+pbbc9h8Nkyeg/sLFqigkBOUVykdEcezMsHXK4S89xIsB
         y56g==
X-Forwarded-Encrypted: i=1; AJvYcCULCGhUJ2VF1lFgqmO3DP/Yb2QBiSWwGl+JBgzcZhLbudDvvclPmPbEVzFzrptckIrvgXmaE+4TlA==@kvack.org
X-Gm-Message-State: AOJu0YxhKVk3HGVp+6zJu1nm5E/T5QiTg3Rf4aBZDjG+EKSodmaa4Ive
	E5f47bG0JgZtRGqB4wa8scjDz/1wO1qVNzxTRzLGIxpCySKan/H7gSSwFoN2nvqm6rKofnE7iA0
	niUXkk7WYNB59/M+bDhdoI2xLosiKK/E1SAV6N4uA5O49mWvWa3CH
X-Gm-Gg: ASbGncvLtw5IPRHtRImw5Wiy87w0YJ3wijO403IpaRFg7u9fyTIR5NOn9y5nmTKzSRv
	kKqQODeJ8+mo1piWrO9rBYDW5h57wMrKp71LS3KHIDKw7Ni7KmzmqyljfSXYBfIl8K5pXKuaZGd
	bAf74+GxTQZ8XLLop1rRaXUg+gX444iCUzg4j2lq5U1IIKqXcfPzusywCro4KDsG2MqlnmN7T9q
	eYGEym6Gor75g6tkYk85DHWFApdq57Klm8shUGWnUmM5bWRnTjx4LgU5GiYG93a3cKAzeXOHeuP
	nQ69BiUKVXokRfqBIxEpw1buDGGjX6LsTBA3Ws3Qic4y9l8RMzHhFb/6Sv4ZPTqRQJmBQuKI6IW
	ZFsvXhm37EE69QUMksNY1pw==
X-Received: by 2002:a05:6000:2405:b0:3a4:e841:b236 with SMTP id ffacd0b85a97d-3c5dc735246mr192360f8f.33.1755806920382;
        Thu, 21 Aug 2025 13:08:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrWn9aM0C/1GZBHvF1UL+fKz7WhllpDdsBGpm2GmVOIF4Yc/dULhABMcTdk4u9sLFplZdR3g==
X-Received: by 2002:a05:6000:2405:b0:3a4:e841:b236 with SMTP id ffacd0b85a97d-3c5dc735246mr192328f8f.33.1755806919917;
        Thu, 21 Aug 2025 13:08:39 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0771c166bsm12920369f8f.33.2025.08.21.13.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:39 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 33/35] kfence: drop nth_page() usage
Date: Thu, 21 Aug 2025 22:06:59 +0200
Message-ID: <20250821200701.1329277-34-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ipYmNADk6jJ4ZNFwdM9hg4xsxEVXISvdUM0n80pA8cw_1755806920
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-HE-Meta: U2FsdGVkX1+CLQA8dD5I0KTDT0mBdnIL8DFUTSSIr8Qv93Bty9VBKmQhJtP4ustxIkPCluUNDpV3xNPGl8l3nLqR/mMu6K9OdhRjJhIchyKFNhiL4S3pgF4sSpcmCZo1b+tQtdz7+gUypYeLKqOLsn9/lXPBhZYpXTDP6HkL7na1/Yt/K+NcTCrldeebOCcrlcB2HSzNThnvUkUTCRkhVkVEVf5i8U0dFI0MXRjqEgmNduEfDIjelkfcWuwM15XvUQn2ta+RXbAcJC8s1V6er6O87i0D+7jhu3l0uljbAwtmYTSoqvyXC37OG6UvGyW1nqStH22ELyeVG3DvCkmI3WmIhHL2LzY+nRfN6TPTEhkBDw55mLRoTDDEQ9uIcmCf5mWQZU/l0zEYCUrcv3jn4OS6ROWQxypUle57p9iNGCEwOjolUQuIDmNKpSE0PNrnKv8IksjKaTSrgS0wkb/WbAwVpENPGWuag/701D4FrtXdy6yiz1F7jAQi1QYj6+WhpKcE/r4on2AnWh+SWz/iImvT2YqVTdM+vXJazP1HFFzVZuBFzsP3O9fr1VdcTZSEEQOCbEn3xfGhjIIiQkyPc1ojqG59MNDzAgppPctTR32q+RxT9/EaMr8F/qcXQDBHSZP6F9TE5BP6m3XvX+lwfbLbkkY5I2tm42XOAL9NNYoGIXy4fmUSMrTj4pdR9lgXz8YEvDypxeLpts58mGRbLONMY6drrfwuRzE3rKluX66zkCzcbW+3d/SDVivHrewpdBJ/AxKJw6VbafvvGnWSnT8kVWO8yMmIM3noCbxWBVOztY6Q5GM2vRUKN8LEjcA75KgyFdqZRMIFdqVLqjm6adNoQGmf+5sDse2sBuPsHtruy/b6q+xIxVdfBxYdinH1T5Xlw5MYzBmt9OWs1PSg8dosN403LYiQbsgYrj7jO7OdR8sd5amqXJEqJHuaT4nit7d7nqzzjoTJJeYq7/J
 9ItStirK
 1xeAy2J5X4BFF9ClDt+ywWPI64ECfQlZx1k6lOjcP5p1Uqwf0x2MDRf+wa8BXMHr136ZWk1QwRkwGO1jbj/hdPaXKWmE3awJ5QBz0Gh1EQS+LoD9EJBOHcxn55vyDYfOWIlowQ47T9ZgypBTR/8+DehVvq/Q0hJMp84wh55cnUBoRlkQYZlmrnQvCyxeQGPsLb6AiaZyWCmad9LQQzSr+QhWnxnWYncGx0wQuCtIQDvcCQwC7J4ARs7KfY/lzLd7Aoug/MACWK1ngsAdCAnG7JajKV3WmA4rgToiMnh6EG0xo1ShmFUM1NKpm2HItvrfU2JfUmvi3KktUDqZZZXpx0AuY0f6U8VoTrNG1DAK27gib+w8ieJlyTM1uT3dEB2sDuqo59kD48TU0MLdfaHyvTEONOf8Dbwd+nPieVtTs8BRoPHbPGh1Nalu0mmJs/OYN+Kq+6wBrrqd+pnVWVoBhEt6rc3PmM1iAZcxNfmXfG6sI8trPFmOBWVCH4gTr3+m5Sg4QI3HJezogbSn7FHPhZIeZYqAHEsO3vTbis28M+swJU45Tbe6oDlUfkYX9GnpU/URANh7mw3ZmkdqENXSCG+an7sARSxkmRbdl73lqsVn3FfiWgtlQdigTEw==
X-Rspamd-Queue-Id: 63F7920005
X-Stat-Signature: jf3axuurjkjx3a7pau3zrxpqeyqsfdg1
X-HE-Tag-Orig: 1755806923-932457
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-HE-Tag: 1755806926-633867
X-HE-Meta: U2FsdGVkX1/7hftaDgKKsF3YLGCQuRJLV3oe2+xO8T2qMczeMI6Vl2+GLWZE9t0XcGoygEtsx8RKQTpZ3Ew9XUS1yPl8b1pepTlq+UB4sxHc9ikoPDb2LjTHjr/vg+JEoJwWvy+IwWqC8SYHUSh3eOIWUdABG3R4tc5o/g1fWaBAUMhhPhal0gt/ZXyJLsqN7WJlBo1ku4Fh5ERggeL0FO+ibshm97/O5g/ZSMG6lbfOFe4lpe97scSWa7YjUlw65uEX7XjAiun+MtN7fseriYeU3DSBrxEUb+bXwOmpJpKp9OYXNnuZDwBB9Mkl2CHnCH6g9wvx2EO3bT5rz1ufz/o3Pq3RoUkeddUvmWOpzQvSmdbqNSV8h2KeHC7z+f5L8b/uXDPPOgPsDWeo6zm6T+EVFGo7gQsnStsDzt8bP0CLSxw5joK+q8AG4PvkRiRudDQ3zLg5mHnqlJv462ayw35ES1Q5wcn0UOz0SBVs7BnD/2y7EnxIp6ciGt99jJtexnC0OPQ6p6PBcXB6gqtLBiRH6NxZqyozqzUKjp8BMjzs57nTYsgdAymLhrrciv0lqesDjbJFxWSg48oEXllygcsvi0phwFogej5KX3P/gEe27+kaDKcQjxLxc6tp63uyuPn84iBKK6Q3HAoo+rZFdpswGtMz+z9+S6TVJLdDbF+6fPNiRVR2bgBv4NU6deX8rkpW/gKgtlolg4AkaXPn6mpzfOFt4b936eBY+74sJj8z/symOk4ubLv48iNB6iKNmWAvleoDXziSqVhtj91Mm3PsntN1ctyzIe0/XyONUaqbnK8klO1+elGrvnD6qdWiXIcBtJEWeLjENv8JGe1vtd8phj4Ig4WjUCulcsYcvjIbPNJU+uZ6H/8IXRw0JFwoABixESDCMr9L03qIdzqlPQW/iTQJgZa89i+8Sf0yRqu+uDtgJCmHXlbdZf9mxHXMbtl4mJMj2xYZR3D2d/7
 TbOEfnjE
 aT42Hxpe6Cv3fozyW7ksD5AGenVxhvFEkzbsdzROv/DZAUUbbxnhRO5bVfHhi0fs2RsZtiGKZGwDsJX9Xpo3ArZg1fxX8PLJEc+KpVvR3dnWO1Gspr+iafF09jm4JrLqa/K9c3r3O5Rrcnr/LA0Xi/xHL99TBYaexgSeUXmhVau/oELJGQdEVUB3AHLyvpv8uCrbMoRTXtSsQ65SMmbNgCvJSwVwCETOCSz21FJeFa7YTPox7MGmeHMio7SJ1/Z9nubSGAtuJ7GluOQMvyo2iJKkRRYqvs3jAnJvA8hRlH9QdakdM2+IEFMk0oM8AXTVK7gTr3eUP3s+KzHYubbZm5KXMqPLogysB/Mwqj7wh0Ud/yW+TYhWEh7dFtFL1WoID+iiUaxvzyfDCFOdUTeap5b4g4Qm8gDhrcxl14SfN2N3p9eJ1mI0lWXc3P96jsuEeoFbbUhqNZlWFT/uLOUV8Ne9JwtXbbDveNJ2K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to get rid of nth_page(), and kfence init code is the last user.

Unfortunately, we might actually walk a PFN range where the pages are
not contiguous, because we might be allocating an area from memblock
that could span memory sections in problematic kernel configs (SPARSEMEM
without SPARSEMEM_VMEMMAP).

We could check whether the page range is contiguous
using page_range_contiguous() and failing kfence init, or making kfence
incompatible these problemtic kernel configs.

Let's keep it simple and simply use pfn_to_page() by iterating PFNs.

Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/kfence/core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 0ed3be100963a..793507c77f9e8 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -594,15 +594,15 @@ static void rcu_guarded_free(struct rcu_head *h)
  */
 static unsigned long kfence_init_pool(void)
 {
-	unsigned long addr;
-	struct page *pages;
+	unsigned long addr, pfn, start_pfn, end_pfn;
 	int i;
 
 	if (!arch_kfence_init_pool())
 		return (unsigned long)__kfence_pool;
 
 	addr = (unsigned long)__kfence_pool;
-	pages = virt_to_page(__kfence_pool);
+	start_pfn = PHYS_PFN(virt_to_phys(__kfence_pool));
+	end_pfn = start_pfn + KFENCE_POOL_SIZE / PAGE_SIZE;
 
 	/*
 	 * Set up object pages: they must have PGTY_slab set to avoid freeing
@@ -612,12 +612,13 @@ static unsigned long kfence_init_pool(void)
 	 * fast-path in SLUB, and therefore need to ensure kfree() correctly
 	 * enters __slab_free() slow-path.
 	 */
-	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+	for (pfn = start_pfn; pfn != end_pfn; pfn++) {
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
 
+		slab = page_slab(pfn_to_page(pfn));
 		__folio_set_slab(slab_folio(slab));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
@@ -664,11 +665,13 @@ static unsigned long kfence_init_pool(void)
 	return 0;
 
 reset_slab:
-	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+	for (pfn = start_pfn; pfn != end_pfn; pfn++) {
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
+
+		slab = page_slab(pfn_to_page(pfn));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = 0;
 #endif
-- 
2.50.1



