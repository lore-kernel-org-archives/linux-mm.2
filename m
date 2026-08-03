Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74E9DC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 22:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE5846B007B; Mon,  3 Aug 2026 18:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96916B0088; Mon,  3 Aug 2026 18:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86116B008A; Mon,  3 Aug 2026 18:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D72F6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:17:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BC98A2266
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:17:38 +0000 (UTC)
X-FDA: 85061370996.20.A36B2D4
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf12.hostedemail.com (Postfix) with ESMTP id D095D4000A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:17:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o6HIk+oH;
	spf=pass (imf12.hostedemail.com: domain of 3fxNxagcKCMQz1k3wkvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--pratmal.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3fxNxagcKCMQz1k3wkvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785795456;
	b=x/TYViWMKJV7XkP+qr7ma4JBodCZ6uASzOT7vqF9NcGUp/e5y5e3hPMcOBPwHtQwLGZ/qn
	43vesSWJaGGSFYSkil1aX8OG4Ov2tHXEWu0znBbqzvL+79QsqDM3605TlduIXGQeuiOUEf
	oE/8amTJWS+fVx6afvWlA6YNlqbrTss=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o6HIk+oH;
	spf=pass (imf12.hostedemail.com: domain of 3fxNxagcKCMQz1k3wkvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--pratmal.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3fxNxagcKCMQz1k3wkvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785795456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wDkXq62PUaK1OEdpjdaABy4j3I9dWut5oFZmmgzetIU=;
	b=Y6pdHi89LXwdYy1nnyfi2BTdE4wOELY20/QlyiwlwFll2hLnEyy13JeZqVo53ZUoCIbu0H
	KPue2/k+XKqBM7V450rhvgx8p+acvQv30GP5M1/rgp/E4TxtTcWuXN0Y2gaOVZTOvsUNuG
	clcwEzaa3QsWAM77VVQFBcAjZ7cgF0U=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb835525b10so5210349a12.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 15:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785795455; x=1786400255; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wDkXq62PUaK1OEdpjdaABy4j3I9dWut5oFZmmgzetIU=;
        b=o6HIk+oHAfNhFaJvQOrLOpY73SKXv7bEKlq6n+1ZV9GwJgMNUu/eNj1E1Hrd9ut9kH
         pH7PgrbGH6LaF8UwkMoxaFJv9s70e8UgwwKdXY7vKzSF2AXMbIo7ZfHAO42lA8jJLmp4
         jTnbzMCWw+lXV8IVbz21aiHIFXApvLHbQac6CdOJF5qZ1H5b/7oaZmkJDDwQ+Fm9u3L4
         PMontdLtno/8nTD4MahT/ZTKEnVTtAD+2vIrXFNVrzN2T2vQXndbgoPL4mafXj/0ELv+
         5r5eQ5K9nwdX10a1YPYqsm5DnPSoMYTNRZhswDgGFHjgHyPzcUBexGBYk7bDO/9RP1uW
         Up0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785795455; x=1786400255;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wDkXq62PUaK1OEdpjdaABy4j3I9dWut5oFZmmgzetIU=;
        b=eP6+D3TWqC7d3okkvvz2TwCZfehBMZjnHrrPnlV3lVFYVnzlpbVFzf/Dsk2IPAfWrn
         ICLSt7ThABDm70+ykO2ifXb4Y642sYLu6zoF/AwwLIwVIjPTHeY4NsLdeM25YZR1T7kj
         QGNn/TYUsWbRPRsurEXq6EKoPpD20Xg89VLNNpWAkl9VgUs32UvcXW8eJl0EcVLGZCcS
         NGnmzEFj4l6Kw5Vs2gU1lVkmP4pQ8J+fshnL0DSBz7J9n0gAsuV0TET+1JBRAoD9t8vA
         rw6Q5RwXrQ/D/0pFU41cWN6f7EuyCZZLT43WKnBQJxCIorEGagD+Aq0TN+ZHjw0nuUw2
         UHFQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro5WkjZ8yFbdedhaEjgb7tpXUYVrY9p8aKHCLyVk0tA67bY6xbP7yoLVQQrMZiphgN7re57RZicKg==@kvack.org
X-Gm-Message-State: AOJu0YzjTQhBuSbHLBPg/7YoqZ632GQUwwW6ku842zy7M6iKIrDCKB7M
	0at+/WC9g8wu5umRrALHOCc75dEHz1FhCMt0109seRPG2u3/8RebJV7gw13WOsbkraO2Xlp1//h
	LqUuoAcDlYQ==
X-Received: from dycne3.prod.google.com ([2002:a05:7301:c83:b0:2f9:af7:504e])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa0:b0:3a2:d316:de53
 with SMTP id adf61e73a8af0-3c92a26b16emr11210688637.0.1785795455279; Mon, 03
 Aug 2026 15:17:35 -0700 (PDT)
Date: Mon,  3 Aug 2026 22:17:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260803221732.3651981-1-pratmal@google.com>
Subject: [PATCH v4 0/2] selftests/mm: use pattern matching in .gitignore
From: pratmal@google.com
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D095D4000A
X-Stat-Signature: sj9z9txda8krbi1swjamswstn9ns8zez
X-Rspam-User: 
X-HE-Tag: 1785795456-466027
X-HE-Meta: U2FsdGVkX18WULwl9SFxhrzajxz3UOTZIV1llnX0gZpzzElS2sh/Exu9wb470WTxORsTfF7w0UPYuQiSAaBtyxAS2+68yjjVfbga5bi2QJu30Vj7/PGoO1SCF4DlcOymR5cU+vZxiK8x7qsEFoiR93/Pu+vdu6OQle9Nl/8yp+IoB+RxN3RBqVd/SLxshrRuY2lAcKdCU2ISVXWaC0OeTP809vgnj9kQvT1RxXlp9boLvpVQ+EvFV9QQW3i+5PoCJ/mjyIXHv4rraMKBEJgguusL14L+TIwLIJg8EDjaf+4XbwARQPDimmeW8aPxspxGmrg/+MRmOJgR95D7+Jh2XQNwslQcaC5lgOWzMmR7HhDNMmEgx/eA1enwbbOb9jG4VH0DB6od81hqmByKcuDs97MyeXg7cE5uxkqADMM8pluuDrh4/3gDN9yzysttIu9CaXnlGwPHrNWXsWaWv+Wfcy7FzMEa4VMl8Z8uLBElvCR4ryHAzmOHZIDnRfDW6/RoAV6q1Y3urCifOUI5Zgf8Y9L/ZZgcBjrbuKg5GkVNBiIIDKJWc4H9sbwhIZQzRs/iR/vuICLGXc90NI5riGnhmOHeby4eIRPreBPQK9nIILd86OXOF3U0EojcLyZVeWzE8L57ZX4CpAUfWHA8yP+Ba3eTNkwdsLaY/3XvA1QwFUbF1iPB0FU1v3JoOJpkBTXcUvolWAInX91OIRvWSlD81mjnlbWC0/TwWjw90WGiSG+W6bNSu4oCDThRwP1moWt60nss5pHWHnH+sunb01QYW/EX59yiCF2Kfn7dLjCS1yfLamDbFK+4QT1KDT4GoefFgaabl5r6P2X4Pu/6HOWTL35dmANHeLYIJ/z+8olDcBh0ExV5cS4DwEeQARbGrA2Te3/h6ROIWdFr8psNedvH1Urhn6Sb6Mjsu411uTdK9jkYfJ8Q9f/i3Bgy3Ax7L7FfW+5pVlG0IJbcgQphqBP
 VGsm4564
 f64JGtfxJQwOPm01PSz8KZFZsiesBe1xCxzANEZm+oM3G4wZmjldSK41yV/1FNsj+DVuWgeBqTA99cidlL18vIgIBYlGYrJ4/TDAwEkZwdy8pWXPmQSpFsLZygeYxFDcbK0OG/D2cl2RFMt6V8962NPrZ7chZTHG6sfxMa/kRY7fRcLpajFAfdNJAu8IP18/nEh3y/sihIN6E5UuUo/wxcbt66Kr60mk7svC+HGpUmhMUG4qD6/WUJ0XatZhAr0B9LznwfNvxOvqOGUX8Q/s+RT1L/PCkRUFxLMcnW2J9TFjUJTZJeAsoeGAYruEcB23bv17imNhkIvMJQWJ2TyCGT8ybG0+l4DcAoOsm90S5EjkWiw5oQcGAfgICkVUyAb1bUSXpwiz3FkX0idBd0Fy7gSD7R8O9W2n/MplwcWiK0LRQJ+B2GibV5bRsKzQLkVg694FMtAudn5tLhU4lRlkspN1VwFAcMVJ2NDKiQX9HN4QERUh0qh1ZXdiqZ8tKqSLq6LsBz3Cw1xEzzqEIJRD4WonzlRZ7goxUsBoT/QybJvw1JYP/57IGYu1Ufs3+Gk9zkmurCYFx2odYEXgmHDdTVTJ5fQYJjqtIGl11xXJQf2rbA3Kpv7jqHKgfsiQl4KG4fhSmwX+AyKJOQc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

The current selftests/mm/.gitignore hardcodes each generated test binary
by name, which requires manual updates every time a new test is added.

This series switches to a pattern-matching approach (similar to KVM
selftests), ignoring everything by default and allowing specific source
extensions. To accommodate this without tracking generated headers,
local_config.h is renamed to local_config.h_gen.

Changelog since v3 [3]:
- Reordered the patches so that local_config.h is renamed before
  updating .gitignore, preventing local_config.h from temporarily
  showing up as an untracked file in git status (SeongJae Park).

Changelog since v2 [2]:
- Split the changes into two separate patches (header rename and
  .gitignore update).
- Added Suggested-by for David Hildenbrand for the header rename approach.
- Dropped David's and Yosry's Reviewed-by tags.
- Kept Lorenzo Stoakes's Reviewed-by and added Mike Rapoport's Acked-by.

Changelog since v1 (RFC) [1]:
- Renamed local_config.h to local_config.h_gen to avoid conflict with !*.h.
- Updated Makefile, check_config.sh, and affected .c files for the rename.
- Removed *.mod.c as it was unnecessary.

Links:
[1] RFC: https://lore.kernel.org/linux-mm/afnMAaz1jY94db2n@lucifer/
[2] v2: https://lore.kernel.org/linux-mm/b6717dee-486b-4c61-8ec8-0e4269959469@kernel.org/
[3] v3: https://lore.kernel.org/linux-mm/20260511173411.267628-1-pratmal@google.com/

Pratyush Mallick (2):
  selftests/mm: rename local_config.h to local_config.h_gen
  selftests/mm: use pattern matching in .gitignore

 tools/testing/selftests/mm/.gitignore      | 71 +++-------------------
 tools/testing/selftests/mm/Makefile        |  6 +-
 tools/testing/selftests/mm/check_config.sh |  2 +-
 tools/testing/selftests/mm/cow.c           |  2 +-
 tools/testing/selftests/mm/gup_longterm.c  |  2 +-
 5 files changed, 15 insertions(+), 68 deletions(-)

-- 
2.55.0.571.g244d577d93-goog

