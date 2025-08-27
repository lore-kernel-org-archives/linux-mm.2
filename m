Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89A6BCA0FF7
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832D36B0089; Wed, 27 Aug 2025 18:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A4E6B008A; Wed, 27 Aug 2025 18:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7209C6B008C; Wed, 27 Aug 2025 18:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1B86B0089
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:03:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D3338501E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:03:59 +0000 (UTC)
X-FDA: 83823915798.09.21F4687
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 59356140017
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:03:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MuhYbdMk;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0slYk4bfz75S649wa7kW6E6tBTFrSx9AC44N5jnD3cE=;
	b=p8xXf/StOsd06xaIIYpKwWeBCu/rQCUS/lk+jjahBNH0zVffW5A2SAJ7W3i7j8auh3tT4C
	TXeIzf4nHz8qudF5MUutdBcE1ArFIA9dsXpZz+U8XwuQTm/g+9GVv27/lGd12x1KhEYyGp
	vrJG/Jo857ZdBCiibxB4rlJyjc38040=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MuhYbdMk;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332237; a=rsa-sha256;
	cv=none;
	b=PEaJfhvio4TQtxNRIO1UwBoP81Dl1k7xIhPIaiN6bGKXVTUG+DfQGVunZMEybbbQaR8IWP
	WhS3zVibaHv8NMNBk06VcdFyk4QmKtvjkY5hifPCPK7q2MjPYqb2fYlzV+ixbjI74ZLvyW
	h9/DmxMD+6+8SJlSdmZZXdvzEvmmtEg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0slYk4bfz75S649wa7kW6E6tBTFrSx9AC44N5jnD3cE=;
	b=MuhYbdMkgEIDAsIfx+d+4PfkxjqEHCTdK4XDUDhRqnvN6rsNIps57h1afzof/dYY9vDi8H
	uu0G5nIINZ6n8IJ4G3bGR9IKWxsW6K3M9NZcnaGCFnmSxVmM3DGDXoabHPekwdKL/rtQjr
	thhPUU6/GkzNdrK48HoE85jF9hLqUJE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-Gig6YInBOwuPYECmvWEljg-1; Wed,
 27 Aug 2025 18:03:53 -0400
X-MC-Unique: Gig6YInBOwuPYECmvWEljg-1
X-Mimecast-MFC-AGG-ID: Gig6YInBOwuPYECmvWEljg_1756332228
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A462195608A;
	Wed, 27 Aug 2025 22:03:47 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 47BA430001A1;
	Wed, 27 Aug 2025 22:03:31 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Shuah Khan <shuah@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
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
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
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
Subject: [PATCH v1 05/36] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Date: Thu, 28 Aug 2025 00:01:09 +0200
Message-ID: <20250827220141.262669-6-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59356140017
X-Stat-Signature: 965mgn1izabm8qi3ssp6juef8syi9a5m
X-Rspam-User: 
X-HE-Tag: 1756332237-184349
X-HE-Meta: U2FsdGVkX1/F21Bqs0L3Q3X0BRIybYrFggHQe9ZEtrUGQk+smQAWiQ/TNe7cG497/LLiaoDs13ZxLee4cNGtZbDNhkjYA0Qp+syfXacRLgSrperSHdRozfsN/RPl1wwXY8KKiR6PwT41d+/FQh1IAgCfRIdQurXRuvSexwEQV8fe3HMUOPhpooaC0jrlcbFuJDVqCnAd39rc5n6XT1oE4SFZphHw4/vxFyIL9hqUMDuj0mYR9fKdTIvANIUA2Y+esrjiAfl27YXqc06sKpq3Rue7SlV4+xBqPds0QnWY0OqCXmkG1fVw+buKn7lwGVylQeyuWh3X7Tq3duK0z0sHx5Pg/sjUOkjg5RCmuqSAX13MZd0jBwKsKHbDCKIr8eaDzwhOJOZG2qhdZhQ1ge9vA1Rjg00jjskOG4ytFiQba77Z9IG+0qAC6X2jeE7zUU00Tlgyv5sMeCL7DQlelkG8RNQAECZbvZ/oq4Sl4+O7lwJcU/nIeqr7L7eILOothgX+1V0nBNDDDDF4tM08p2aE16rY/ci4TU2/OVwgN1pGGWlKVgLQeQ1ZFJTJmXJwP9CqMR/QmwlZFcZObRXFh6G2IzgKVs/3OyptZ8tQ2ymC/c6OHO5eat/RAz3UB0vDJUMlBSY4H1bn1iehGKCjfWlB/8OhvPBv2tB0aIim2CYtw46RKezJUEhYeHEHooVqi9yQ/dvEWHoRQXh8gYssF4/UuSPViIET5njDJ+N92fQ4OBIlMLZ1iQPBaLv0g774E581wmF0JMAodN9H4f+Alud1cNFL+vy4SI0bmPAtMc7y2h7zuqKmxuPy6lEtWEwjFXqFg8OEkQy6534FR+nJnoq5y060xVAQfUm/LRF5ND9P2VAPcqYDctnfTLg+opYDoQNEsMETBlZITKz0jiR/b5JcrbsNymTAx54vTRCGc2RYG+LjwTqgkaxAYWml+OhiFIa3DQrVxXtG/faXeyS3DSg
 VA94A65A
 /wM/bPMy+uMRziqFTAFjNKCdbt0LBOSF9T8Ceegu4GbQsOUrOFoMSoZj24NApm3fcyGTp4ddhqJ8J978mlE2mA5zsfbOopUAKB0mZXmmM4VLlJClmaas+xFBrk0bfroC1BiYZbTnaYWUloKvPpiwwIMMrZ13QJHYX8arIY2UpLW5SkLQuYDPPRVLLiF5j3GggoNiY3V/KRwmKw66PVljCM83RL8yKRX2RWHoa2+xROVCih4h9KB+QuK545OCfHOg8DjUwLJR++P8t9VPEo/OZv6OlybZU/5rQV0GZbUzrdeObgT4CQsogKTNrnCWRHaws5TmHxW65sMaLxeiGWW63pYQBkXvFFyW8NYohlB4YzYIp7fVqY4X8HLp5Aj2yssOYB3fedZ49SGr+9mi8+wCS88NbMhh8sfQkLKqYGbG38IvuQGQye4cypP0TnOeKlWlmtv8LpImFusIOHYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer user-selectable (and the default was already "y"), so
let's just drop it.

It was never really relevant to the wireguard selftests either way.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index 0a5381717e9f4..1149289f4b30f 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
 CONFIG_FUTEX=y
 CONFIG_SHMEM=y
 CONFIG_SLUB=y
-CONFIG_SPARSEMEM_VMEMMAP=y
 CONFIG_SMP=y
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
-- 
2.50.1


