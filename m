Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2FF2CA1009
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3AE28E0075; Mon,  1 Sep 2025 11:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13158E001F; Mon,  1 Sep 2025 11:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28E38E0075; Mon,  1 Sep 2025 11:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2788E001F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:06:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51EEA1DEF84
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:14 +0000 (UTC)
X-FDA: 83841007068.14.6107EA6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99BE4C0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JBkLjSBT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739172; a=rsa-sha256;
	cv=none;
	b=sZQLLC5GivJI0bDM5kv3vXin80TR9GtwBIjwxxsppyNli5CEl9ndjsZqk2XV6dwdD4opLa
	uREoxWB+yBYRJJPuo1f7EP6+iM8SsUuNxtABX8fmhXLngO+AVQDry2kmKI7Sdex03CfNz8
	K6MxA0x9yltNCFIfmCtDFDKW9/x2EQg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JBkLjSBT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLXaFnsvcEZ3Dj9TJuBmn3z/jlqr9HdUmmd8IA3Df2I=;
	b=YWKE/vMeBF1DtHEPXPoVL3qt8d49045fIq+FagqQ+PWHuMbY+FN6dNWeFcBnQdXMwDpL/9
	HpQvWEJXBLUbwO7tzR6FqqyEVhPVO8kHnoYopTVMcy1L/jYDuar1HmRWSTNWBG+8W5Gp17
	PUTUq2mFB7vqxnB6YbG52pykBbmmXgU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLXaFnsvcEZ3Dj9TJuBmn3z/jlqr9HdUmmd8IA3Df2I=;
	b=JBkLjSBTc1h5WN+4f0Ksx8spakiLCxwu4JlXe3XNmZMqj8tDe9ZtzYERgcliyovZPK0A/k
	kIKL4g0V7dSC0ZG3mAwpTJJ0OaCDds/kncqjT+V1CnpQNv9HJNQjN+80GUApPl6Fi6dCQb
	zg4QgWCL8pxzeIjV89X5rTk9gtuB13o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-vn9FlFaVPyW1oPG7gsT7bA-1; Mon,
 01 Sep 2025 11:06:06 -0400
X-MC-Unique: vn9FlFaVPyW1oPG7gsT7bA-1
X-Mimecast-MFC-AGG-ID: vn9FlFaVPyW1oPG7gsT7bA_1756739161
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9823C19560B2;
	Mon,  1 Sep 2025 15:06:01 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F13EE18003FC;
	Mon,  1 Sep 2025 15:05:45 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v2 05/37] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Date: Mon,  1 Sep 2025 17:03:26 +0200
Message-ID: <20250901150359.867252-6-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 99BE4C0008
X-Stat-Signature: qc6smph5wghj1m4t5hfoqmkdxai31dox
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756739172-512218
X-HE-Meta: U2FsdGVkX1/hWKj/OCTKYxdUYcdwKpO2RUQ0yDsF4ca0UxE513TbQWz9gMWbbNM7HVRcJdkow5jkf8RLvnFcbwGwxgCAvDL892XFAhTkgKb86CHC5H75FtGS3HqxNWK8j7Patg2vDow9d8lRzcKDzTV0geUyU+rFXmFjeDsPok+2EmzpSd3Gg63qAJLpG8GqCdqqUjavd22McefJvwZHbdJbehvItrwuEqC5TtD78QYafX6eLvBfpiNOE+GZGejGi9J9w9gR7ecDar9iI3Zx1sCHc5Fqa1BtZNEv83SBch6qab2c/NsclZuBTvdn9ZG//iDtlYSoQS1iKMEBZjOx42kAOz+ahHC1E4MlizWAwLsgz+G9rXwKVUkvW4U15Lgiup8xYI0oe1rSYzVNzCB6+/fvSKRrx7rAaTA2lWw7bjVbvOy4kKVCzSlPbo7j4x19puH5cXlrz0CDuOE2yqfu2qkS3AqQdHuesybRls8TU4rfS/PcXPKh0aG/UyQZEvqO4smk46qNivBVO5i6mlfIRdtGPDtQ1B+cyZiDuih3frZG7lAp2yguHUg5hb9iisfCV1DcQYILhLMi5IaB/wQq2d+LH4QwMdIYh4mKVOqvnc2WviJRI+iF8NSld8HU4j2kE5DdIE3fXX9K0Kv9wW4nvJUySU80W01xNK78omLCcikmDGqyRLrgE65bH/NAHHQ+wnAK88A70ySKmabvz7aJh7P4XK/GbQoydgOoEyqlSBI7gCYra1pF+s2ieTGV3ROtKp/vbGfp++kUevSB3JQt0I5CRs+Lxr6T9coj4U559RSET+xRt0czkN3Ar6rJwk+IBPOqumjyhmmmxqzCuWaGFBDR/JuFnkNMksb0bFnzOXqb0q/+9juj7rdjwy7b+k0J54pAQ2Z7PfRxFhL2kRIdIzA3n6TX3AaRp/CPyalVLHFzlbuQHD6fbg6048KzCtkn++FTg1weVjtY0QsvmQP
 qUS1czAD
 Eb02pdmOaFdD1rxdnyjEuq5/Oe7pZ8Qz+aqZpWAmiX/yN3HyV+KDReD6x+JwHHHpAmNJSJuGpUgyeN/oBYM9YVooV7G3n/WNR/3LrHUr3XyfavcDibFlXnH6MzW+5x86zHMLleZxtXuSy86M3rwUj0WTX5cX7fDvpw5oOhz6VmK9m7o+yBWSHb2Rh+CwC5QAdGXzcP7EgQXHLW92FCve/Giz3iiYeH8nqgJ75X2e60Eh+bo/CTrqeGt3SSvFanX1OFdGEZyNSSC+EjgWeSy1yXmGB1JffQVbgNuCTny3nVBcNq9wdlHogy6EclCv1uU2IVSUjgRnS3NgUQNB88RdCSCvqNReKrMh+i6m/hrV/AjXFxSerWIDNHVQ9GT9JUzvu+1mG5aZZotXZKWqhmS6G1clXAe+Ri4fOlUNt+eR4UQ6z9Jn39oBpI0y02mOeEzuVI76ZZkvWvsgb4znNYWPl3pxUTxLXxlzQynfkTjUzgj/x2VE=
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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


