Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067BFCAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 03:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F21E8E0008; Wed,  1 Oct 2025 23:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A31B8E0002; Wed,  1 Oct 2025 23:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8A08E0008; Wed,  1 Oct 2025 23:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A69B8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:21:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA5D986716
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:21:14 +0000 (UTC)
X-FDA: 83951723268.14.E8A354B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id B2BE280009
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:21:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hzQKLkAQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759375272; a=rsa-sha256;
	cv=none;
	b=riKN9wNQZqYID0k+naRzPjugq7dfrHzCRZwmvRN5YZyHHuvAjJOyoEt9NUi9Kt8WEEHuen
	rT9nvr9tIJpzDaE/6KunofZBseA/wE+dbLTzpEEzohKHgbahXv/718cTsyF+fbVQ2xiKAp
	6YTgIZGWt0G0f1xV1qi1MYqUbHgKabw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hzQKLkAQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759375272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Td8ABz/BqugsSJwbbII/elS13qp7owFsKqt3p1yucvk=;
	b=m9VNDoj+e410qZjMfifZjuOmsaDoyDHoQelE3JR0IdHVLA9yz45tCQgZQKBuceHmbvfNxq
	H51TuYks2vklBLd2HeTqPn4gJf8OqbSjllKHCdM9AVwAI0eIx8FudbEcZSKugtEQxhmTBN
	Np+q5IFa9CF2bqVuQe2w4cww6ni+IIw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759375272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Td8ABz/BqugsSJwbbII/elS13qp7owFsKqt3p1yucvk=;
	b=hzQKLkAQp7Q4wiSwjWtlNZvQ8WGNzmN0mgVwphEuzWiNcpIKRfojb0N3bUNJpsTEu17Rus
	tsXO9G9QwzvzZ2G1wM6iT3Y44H36eUD/kpnfMKyzfIDr5WiXrL6nz4xEMHcJPTuL1ghkZV
	6T2D/8BZgtHjTmK/gp2NCjL04Y9cR30=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-cEUjK-oYNSqNLVYY9tCvdQ-1; Wed,
 01 Oct 2025 23:21:10 -0400
X-MC-Unique: cEUjK-oYNSqNLVYY9tCvdQ-1
X-Mimecast-MFC-AGG-ID: cEUjK-oYNSqNLVYY9tCvdQ_1759375268
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E7451800365;
	Thu,  2 Oct 2025 03:21:07 +0000 (UTC)
Received: from localhost (unknown [10.72.112.10])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC712195608E;
	Thu,  2 Oct 2025 03:21:05 +0000 (UTC)
Date: Thu, 2 Oct 2025 11:21:01 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org
Cc: kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com,
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v3 0/2] mm/swapfile.c: select the swap device with
 default priority round robin
Message-ID: <aN3vnTumKZTrJvNb@MiWiFi-R3L-srv>
References: <20250930063311.14126-1-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20250930063311.14126-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6tFcsAc-DX9L0HV39QD2I0LGBaAMm6fPsKTUX7FkzJg_1759375268
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2BE280009
X-Stat-Signature: y8j1w4cpm14rbqtwgw5a4r7tc9yodqc7
X-Rspam-User: 
X-HE-Tag: 1759375272-37439
X-HE-Meta: U2FsdGVkX18DThxZOdjHpPTKm0CqRfabEd7HeXATtj8WYZ/yRrBAzevXmfKuCnOcrGNNrUiTwR6xgDG8sv8Ty2hxQNfdoaG+NFdATP+pjcUuqIsifJWSnBeZMAAAdL3fzho6kdlcMsHGn8iGBcXsNPEMVBQNoy28++jQ/5o50bggTHJ8RzTAIdf2zmq1xEKIfzq2W+ZJzuK0NEL5zBWsXG2/HP4WidOijJJu6mX1gl90kQb71pCNmiwbGzbtLmhGkV1rp32QbJ7dNXENLwxjZ2+Ik/ivVHaVSuTfWZqyKSal3q85kqSKIIRdvQ0xYWyPLSnHZ+lBSm7CRvLTvFY4U0rT0NIZqiNTGyFxg1VVo+LBFXezw6aQfw+8Kr8P7CCNUsAxRIS2yvb03NUeiXlOA1lvP/hdbNFCHnS7MFLWwXkESv4UOg7uDAR+7FaNx9c/glLnRW4tvQRwybQhDwNN5TBVWRgz0t7tu/vmrSIclJF1Fm02C8dmSzNXjyemv+Zww60BS+uZHkoU2pzJRb2CGINPpCC9cy4cBY8WvWV8xfGSQijq3DNj8FJok+Y5a0fFGiC361EbfOG0BjFq/hhZ9Qmvg3bgt3hkyfQGI2qzDHEv8QJM/uf/xS1SGJmIJZ8hcTVn/JZSsBM6BbltI/wCdppJnVFRRoyg/7IzKXyDrHBRE9lj1s1I8wx4oJaJ2ae+8KTnNqKSVxF3t5JKcUsuxNA2D25WCDdERIv63kohjiL1qdEZ5yZn0lNwKBrs1WElQHuRQBgaUiQ64vxX3gjTgRJWTpuzEj1p/XWiXv48B2n2Xjkhx0fnC6hnC2mJSPEYgpAyZSeHfu6cBJAadLziARYYYsuDDV2P7ppUm8IZKfRjIjGqD8lLQ2L3I2/G5Fq9yTYM8uFCPI4kJYOkuPhHvr0bCPYtamEzzaVKLQ8R5jaZZTHrq3dz0KDneC1aL29dqOe68tT9xOJP3eKaKwF
 vPjjpszq
 3b7IaWMIfOsKYBaDIuE2Bod3fswhSrNQbCno79rGagZvKSHFMbiNkz3rFx/0FPxApMnkTz3p0UVTMOnxaFs3lmd5ezhubsNNXxm1HwSpjInHOmifCU10DV7liRNs5aNiTNZnmWsZshZdemw8B55rOIGyTSsds8UND6yqWXreTvGyAF36gH4OH7aqaqBm6VFL4sAPuz5yCXpRtIta6bb02ID/y9UTbQasUO+oyWyee5iTNeZLUiR48KNemqFfmNlxhKlCqdc9YbT5uA3qHS9d3pq9gx09ejhoDYosXaSj0cyB9IDvBUVRTXz0RwoK37o6C5Qo457IxAO7XzgjyuLtSo/BF8ynjeZWejfPxfS0hKTdxySYZ/97R5QYQhY4gHSDVH2k7NjlLb0dyyw9dN2Gq/9GRXnb/zHRq5m26hX1mRaqH5feG6yoVH5QY3uwXgFOeQupo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/30/25 at 02:33pm, Baoquan He wrote:
> Currently, on system with multiple swap devices, swap allocation will
> select one swap device according to priority. The swap device with the
> highest priority will be chosen to allocate firstly.

Oops, forgot adding Chris's Suggested-by in this v3 series. The
Suggested-by tag was added in v1, but I forgot adding it when
splitting v1 patch into two patches in v3.

I can add it if v4 is needed, or I may need ping Andrew to help add this
if v3 is OK for merging.

Thanks
Baoquan


