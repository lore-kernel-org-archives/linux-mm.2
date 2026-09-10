Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB3BC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 02:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8C56B0092; Wed,  9 Sep 2026 22:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B636B0093; Wed,  9 Sep 2026 22:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32D36B0096; Wed,  9 Sep 2026 22:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4886B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:44:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 009C81403BC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:44:13 +0000 (UTC)
X-FDA: 85196308428.01.0E40465
Received: from mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0BF64100002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:44:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vyD8CYfz;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789008252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8vUJVj2+NUfHU19zkXj0xWtQSHKC0dhf2hK+SXrGw8=;
	b=ePRMfunxupme8UJSNznU7bXME+keEBstrnjdEm4ZO2NXOB2TO7n/xHTAdnNDBFqz3jhBlQ
	WxlbZrn0DXa9SMN+Qb8KLIsC3gj5jJaE3XJWof2QG5ilO43zP5EDTy+z/rkIr6CxUWILy9
	Nbt6tvXhcUQl6FiGvtnGEA9G0oF5DIk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vyD8CYfz;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789008252;
	b=xtS3znBuD/pT6cmIsDKhy57KxWo/oR6l81cSXq/jJL0VlDrusFLeGinaPnJ1ZkpgabZDNp
	+XB8n5j2qXzAXF7k6lGaJJEKWAFoRztCqQ8DqQeisQAJCInUMFHkB03pdasstR+eF/Z+yL
	wsZzYMNcPfUtJnbCOpw+Cv/0Lo3qe4o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9ReJuQ8qJf1QIBHoKfjnnzjiS2jXjXxDOLZCMHAFsIw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789008248; v=1; x=1789613048;
 b=vyD8CYfzG8wK5W2WjQuRZHxGWe1HlMmo00dgKyWwRvBhHT3LNiz7olQWzSOiHmBRGI2/S+OD
 G4TVHzyUEkOiWSpPC17YJtjDqLGOKXgfzquzU9ETEuglE+XTyZj4e+CpHyb8EEAULbTig5w1853
 LPIywpgGdl8YSUDECMqcUJuk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id ed5823ffa1079156;
	Thu, 10 Sep 2026 02:43:58 +0000
X-Mizu-Trace-ID: ed5823ffa1079156
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 0bffe67ab8a72b3725cc31c4b525709bd3a3e223
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260909153653.9e19f1d1f61a080d5bd6d2e5@linux-foundation.org>
Date: Thu, 10 Sep 2026 10:43:41 +0800
Cc: kernel test robot <lkp@intel.com>,
 David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AA5FC896-AC1B-4112-BA14-E1F8865358BF@linux.dev>
References: <202609100517.0DrzxrW4-lkp@intel.com>
 <20260909153653.9e19f1d1f61a080d5bd6d2e5@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0BF64100002
X-Stat-Signature: trotit7uyn6nzebftk34jr5hpyswu48i
X-Rspam-User: 
X-HE-Tag: 1789008249-550584
X-HE-Meta: U2FsdGVkX1/Dt07EuLEQkaWwCgz/0GcYR9fTKSgcmifBiOWr7wd0ino34kFhucMLVUtfiAXm9leL2xsGotKNQDrWOpTqSqjqSjEpzrxHBxQ57I5iIlo2kiLIUUrhJuxGKxLRt/9jd0Yq9i2CvzYGV0eHoP/HYwEJgvW9hxB4IuZSumwRfDIYNT7HXgh/acestJz3YxoADvQR5PvDWr7V86TZmT91C/Fug+hRjFSnn++SQQtTDl0nhJ+I86E6bMOyfKvCbq0pjQlE+N2n6UKu0bsHpsGfXJ4yv4hBEMS2tgdmh3C1udFfWWVLuS8rIRVAiVaaKcI0hZVZtwErNjUi+dGfowmaMIGqCgCxLfsSHgfVF87ASPFnBNWUWcRXdNKwO06hrYcRevW5l5YE2bGf8INMp0Ur0eYB3RJsHB8VnvVm5oVivINe6uaiaPAErC9dN4furLiFGy7hFZV+14qQfkfrh6OWIk5hE7RuIe9MWHcyhrBJ0fJVqe1fqbH/3M4H7bh+rU6RzG0gkqbFy1bHvp95kwBmlXFuQDFe0wYokZpjwSym57YBlJIBt3NtqckxZ2d9VwcHof0+vsDAU+2eD18/snAmn2HmlJQ/9lRriVlwh+D308SHqOz0xE1jaLQXzWLgOhut7d4T3X338//xLl4+CY5Krdv6lyg9T0kZyEtMqjBlhMI298x1Yb2T7J5767YiibJL2hrrm4PunltOtqKKvmYs7KOzM3FhvKyIfrhiuHcabKt6oB3XavaKv5OVCKiK2e8+wqgo+tWnRQDcr7IJTDuoMBFCqPUhQxrtrDs32IwbXH3JNJYUEAfGcKcWoE8bnE6UK7OGHMHPPkpcxuX/fVTulqZ6Ib+yA8WxFhYdZOsS5iZOLiTy+CyJZL8gRnprZrSS/iOZYC8x51MWQgqjYHop9Y3LwA8LEo+WSHBxhG2AJrt96BXzIKYmVUVNPkF0TwsjfERVFqvgWtd
 ZGtO5gRV
 WJNpVlZerv6YFytJzg3/gJOq1dOHX3UbV/le5wRJ5+sn/UcgOWWHhQflfWKi90sTHLX2nUnFm6wakwiDCz4BdyiR5S5+W6MM0B/2WAQJiPJ+WH1RgxV0M5UZWgiua77zfIz0lbATWXbdJv+C9XtDjtfcw9IlFZrzfqqMEg+9ML8n1GmghO2Khdmi9jiH8oOXVhflBylEemS7SxY4o1dnQMgo0BJJQhZDVkkdkVOYxk/WlRis9zyRr9PZU8DAnNkxpc6tT1g2ZJeLESp6l+TiLnPgwVZTm9uDJFTFNge1Z9qtjX0wKETrws6dCPCQbjiYjgFhoO5otFNAc9vxxQNDUpFAxYXqA1GtCELoIWUkaSaIjI6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 10, 2026, at 06:36, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Thu, 10 Sep 2026 05:56:22 +0800 kernel test robot <lkp@intel.com> =
wrote:
>=20
>> tree/branch: =
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
>> branch HEAD: 0bffe67ab8a72b3725cc31c4b525709bd3a3e223  mm/swap, PM: =
hibernate: atomically replace hibernation pin
>>=20
>> Error/Warning (recently discovered and may have been fixed):
>>=20
>>    =
https://lore.kernel.org/oe-kbuild-all/202609100351.ALNh2KwC-lkp@intel.com
>>=20
>>    include/linux/mmzone.h:1692:10: error: call to undeclared function =
'NODE_DATA'; ISO C99 and later do not support implicit function =
declarations [-Wimplicit-function-declaration]
>>    include/linux/mmzone.h:1692:26: error: member reference type 'int' =
is not a pointer
>>    include/linux/mmzone.h:1780:35: error: conflicting types for =
'NODE_DATA'
>>=20
>> Error/Warning ids grouped by kconfigs:
>=20
> Thanks.  That's Muchun's "mm/sparse-vmemmap: switch device DAX to
> shared tail vmemmap pages" not liking CONFIG_NUMA=3Dn.
>=20
> I'll try this nasty thing for now.  Muchun, please make it less nasty!


My bad.

device_zone() uses NODE_DATA() before it is defined when CONFIG_NUMA
is disabled. This causes non-NUMA builds with CONFIG_ZONE_DEVICE=3Dy to
fail.

Move device_zone() after the definition of NODE_DATA() so it is =
available
in non-NUMA builds.

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 03ed9232f186..df42fbf3962a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1686,21 +1686,11 @@ static inline bool zone_is_zone_device(const =
struct zone *zone)
 {
        return zone_idx(zone) =3D=3D ZONE_DEVICE;
 }
-
-static inline struct zone *device_zone(int nid)
-{
-       return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
-}
 #else
 static inline bool zone_is_zone_device(const struct zone *zone)
 {
        return false;
 }
-
-static inline struct zone *device_zone(int nid)
-{
-       return NULL;
-}
 #endif

 /*
@@ -2159,11 +2149,21 @@ static inline int online_device_section(const =
struct mem_section *section)

        return section && ((section->section_mem_map & flags) =3D=3D =
flags);
 }
+
+static inline struct zone *device_zone(int nid)
+{
+       return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
+}
 #else
 static inline int online_device_section(const struct mem_section =
*section)
 {
        return 0;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+       return NULL;
+}
 #endif

 static inline int online_section_nr(unsigned long nr)

>=20
> --- =
a/include/linux/mmzone.h~mm-sparse-vmemmap-switch-device-dax-to-shared-tai=
l-vmemmap-pages-fix
> +++ a/include/linux/mmzone.h
> @@ -1687,16 +1687,20 @@ static inline bool zone_is_zone_device(c
> return zone_idx(zone) =3D=3D ZONE_DEVICE;
> }
>=20
> +#ifdef CONFIG_NUMA
> static inline struct zone *device_zone(int nid)
> {
> 	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
> }
> +#endif
> #else
> static inline bool zone_is_zone_device(const struct zone *zone)
> {
> 	return false;
> }
> +#endif
>=20
> +#if !defined(CONFIG_ZONE_DEVICE) && !defined(CONFIG_NUMA)
> static inline struct zone *device_zone(int nid)
> {
> 	return NULL;
> _
>=20


