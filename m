Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68346606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auRCJl/E
Received: by kanga.kvack.org (Postfix)
	id 7BA6D6B05BA; Wed,  4 Nov 2026 01:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B146B05BC; Wed,  4 Nov 2026 01:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D1E6B05BA; Wed,  4 Nov 2026 01:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 381F36B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:18:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D89741C3DAF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:09 +0000 (UTC)
X-FDA: 85396431498.07.DBBFB0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4A9D61C0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="auRCJl/E";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773088;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/yfRhPcdasAXeCYxCK7Gbe/TNcSbSf4ZuUMV3o/rPg=;
	b=sOcqCTmLmrI2IXRtcSeliY+uwCK5OmET6ws2dbkNmoaILtPFco3RKpiF12JFcfXHneQccf
	id9vuOJdbhuTqjPDpdEvj5MqK31Hsy/4bToBp740Iz8Bq1RvOxdq5lJWMfqapwZS3z3gC5
	JqV6F8ECSBwzeIxXt0D3owpX3GSlut4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773088;
	b=AHz6d1abg1x18/cyXgME7xZYPfsQYnrp+9R916jArW1h72Dpo+cCiDdkSWnKi9jiOTC3HW
	klvTidcVnBvFNxFc4zkYJD88r/lk4g6zcO0t8mEdvdVMwIYSVLk74LdpocwUtfVYl7/bn1
	tZhJrJJeBctAqcVSug5XmuqpN44A6NM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="auRCJl/E";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D399860DA2;
	Wed,  4 Nov 2026 06:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03B11F000C1;
	Wed,  4 Nov 2026 06:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793773087;
	bh=6/yfRhPcdasAXeCYxCK7Gbe/TNcSbSf4ZuUMV3o/rPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=auRCJl/EnM4TT0CkabaLgVB0NAGS1Zk+qqHa3/FK1a/bXSO81tILeopu4IQiGN2r0
	 K4hho/CdVH+xbGItwPh3Q8iXgLo8uVTnZhRTyHeGCsX1a1HbobMY/Bb35VYOhldZkA
	 13JZbTQt9S2GbTzIzWGYjyUS/Wl51awE92o9+psSOSrXP+guO2MfQuk7EIjejFJ8Lx
	 T7vbHiMeOg5o6/YbQxORmDToRVwh2jaopt8deFA/NMcM0Lc5WQEsSUKtZiisfZxIzF
	 NKjDftpHMrUjd96+NPaBY0GNSQ89/7HCGzU9xOFIRzjrKKu1gmaji8G2gdaL17xm/j
	 N/ppVOmLDrdOA==
Message-ID: <sashiko-outbox-196749@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 11/12] Documentation/mm/hmm: document migration
 through hmm_range_fault()
Reply-To: sashiko-reviews@lists.linux.dev
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, "David
 Hildenbrand" <david@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Alistair Popple" <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Lyude Paul" <lyude@redhat.com>, "Danilo
 Krummrich" <dakr@kernel.org>
In-Reply-To: <20261103061629.972669-12-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <20261103061629.972669-12-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:18:06 +0000
X-Stat-Signature: u3eoiy1b58zjkwxodnn1u7ex7bjbjydb
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4A9D61C0008
X-HE-Tag: 1793773088-489182
X-HE-Meta: U2FsdGVkX18PwnsblWksffy3P6JnYijzFmtQmOXjXWPgRyEdOh1BvYVhFW/6A32y/PL8x94TB2dnnIb9nN89a0HOLFCkyQ5tqHwTYLPCbwtdjWcrj2MIcrvqycnmePm8EWxrIG59P+MkSjLyDpugoUchoBI1u1mazfWI5ZdFFDMLc4Hdop85weRvvXLugaFMsXNIIVbXofHzREAGAQUm9/L/peBoXDR66STF+64c+KKoOv7k5bVpTsIxqYc+SGCWXbskOOJPOofvXqDa7Ov7qGURmLGL0QCs8RlPUB4hkBo89sb3rmsNPZcQk18k+vMJKAug8KRv2RvUBw9V06iA8yeERAClBOQStbw5jZ0OVKYA6EfZgjb2BWY9so2iln9yuE0gpczFN+R1D5qsWBy/8lVe0dbsdb34yA1LTuwS//boqDqChYs+H5fhf/whUFYdO8IYKjLRmdMqaiuSlFYP7sIk6lp4EGA9+XXlNHPaHL8IV4acmol3WZfB5MXU+BK1QDI5y1SC87Y0NI2suAhZp5X3b9Rv853Jyac3wrVJftIEEN9bYakEWlMz8widiMJpKtHyX3dpYmJ0IRHidN8XziFKL0cCg7vHGMX/ZlkMxm4EUCWNMp/kiwMRLMhl6yl8nVDJ+irxN0dd9Bz/Q+u2ui0lQ++PEClzGZCkfdzCFS5m7b22H1zS1+8i6m+G6M98nh+ePfRvykPGs2SNIurL1Z/IAGlca4r5iJuhzt8KeQvYKs51HMIdRdxTo71M/EByolLMtqU0N5Va2SG5uCjVOpLXQDHxP52J8Y/qPX9WvjqIDv4SHC2kloSM8rwjCzufVKWK7hqWZXC5GofAF2W12k5Oz4kMlfVw/EubY/7JH3t1gKqX3bXr1dDuEgjsX8PWK6bYDNhyQrsUMM1aA+Z7eksms4UtF1FLscTgGbBnF54h3PdcZEmJ7KrwaehjwmYk7Z/AAY30sLznXFrxkMS
 TVK/b5hv
 I4yOD7G0YqOs3Fx6AbSZ/MR0Rh9J9/iJMVbiQerUoaP+RMEvhwQ7w95PmSPajd8YpIld+699y4AyLLdoocX4zvmmC0LLLML+ToGkocA2h8GMeY2PLMU+CydgURAAhGcglD+vL7tHI+47tnmPLcga+ykRr+hrmOkj26WSIeWSgFUkO5qZ4LBkSi97rGoC2KxCGIbvXzzALl3cFRhw9k1b3uFVz4Lg7kJsX23nauFOYEenYzRrFmPD/b8nCmS0/9Tir3xv1tk7m9oNPxydgCiCkRMwcnC3Mabkz8IET75+/ykblsZmowSmdBOeIWwLbAstow0BoSND+uiatevQYG65H7rfQzhoJmDIVDcYNGuHhJk96pmNI5pSnmP0UrT9vBLdTpjKZq0oDobWvavQ4iOqO+xRZahgVt4VJ7lxmQCyjuxphBOZd6isn9gTNsFiBCwWLmiaL5ZO2hqKV4033HSOgNQ5KCAvmD89tvNJDy5mqUSZr7JJ+Xv+RqQ/eDc3EhXo18JYMGYSTd3NC1WSltTRmMcwxJbYu+7TvedU/bbeDWReRQ5NxPsR1Tb1t8aFaaGeUHZDKe5ZjRvx+6RRv6W7K0JdPExmlTKiSmSXi3KLV5Ag185lf3CxlhssMHwxbLTJDq+9y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] mm/hmm: incomplete error rollback steps for migrate_hmm_range_setup=
() in docs
--

commit 908a5d19d6ca6398929f82b830d122f054aa64a3
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

Documentation/mm/hmm: document migration through hmm_range_fault()

This commit documents the MIGRATE_VMA_FAULT and MIGRATE_VMA_WRITE flags for
migrate_vma_setup(), as well as driving the migration collection phase
directly from hmm_range_fault() via HMM_PFN_REQ_MIGRATE and
migrate_hmm_range_setup().

> diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
> index fc1b8dc198250..914ef6bfe8486 100644
> --- a/Documentation/mm/hmm.rst
> +++ b/Documentation/mm/hmm.rst

[ ... ]

> @@ -427,6 +434,44 @@ between device driver specific code and shared commo=
n code:
> =20
>     The lock can now be released.
> =20
> +Migration collection through hmm_range_fault()
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[ ... ]

> +After hmm_range_fault() returns, the driver calls::
> +
> +    void migrate_hmm_range_setup(struct hmm_range *range);
> +
> +to translate ``range->hmm_pfns`` into ``migrate->src[]`` (``migrate->dst=
[]`` is
> +zeroed) and initialize ``migrate->cpages`` and ``migrate->npages``. From=
 here on
> +the ``range->migrate`` struct is ready for the rest of the flow (steps 3
> +onwards), i.e. migrate_vma_pages() and migrate_vma_finalize(). This shou=
ld be
> +called even on error, since hmm_range_fault() may have collected part of=
 the
> +range before failing.

[Severity: Low]
Could this wording be clarified regarding what needs to be called when
hmm_range_fault() returns an error?

In mm/migrate_device.c, migrate_hmm_range_setup() only translates
range->hmm_pfns into migrate->src[], zeroes migrate->dst[], initializes
migrate->cpages and migrate->npages, and calls migrate_vma_unmap(). Calling
migrate_hmm_range_setup() alone on error would leave migration PTEs install=
ed
and leave collected folios isolated from the LRU, locked, and with elevated
reference counts.

On the other hand, if "This" is read as referring to the rest of the flow
(steps 3 onwards), step 3 in Documentation/mm/hmm.rst instructs the driver =
to
allocate destination pages, copy source pages, and populate migrate->dst[],
which would commit the partial migration rather than aborting it.

As described in the kernel-doc for hmm_range_fault() in mm/hmm.c:

 * On any other error, or when abandoning a retry, the caller must call
 * migrate_hmm_range_setup(), migrate_vma_pages() with no valid destination
 * entries, and migrate_vma_finalize() to abort the partial migration.

Should this paragraph explicitly state that on error the driver must call
migrate_hmm_range_setup(), skip step 3 so migrate->dst[] remains zeroed, and
still call migrate_vma_pages() and migrate_vma_finalize() to restore the
original PTEs and release the folio locks and references?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103061629.9726=
69-1-mpenttil@redhat.com?part=3D11

