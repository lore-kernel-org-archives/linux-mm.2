Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ECA6CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 10:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB978E0014; Mon, 20 Oct 2025 06:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893578E0002; Mon, 20 Oct 2025 06:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CFC08E0014; Mon, 20 Oct 2025 06:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0148E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:03:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E75D01607A9
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:03:12 +0000 (UTC)
X-FDA: 84018054624.30.AB7CFDB
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3EC94140007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:03:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="v9m/FCtF";
	spf=pass (imf23.hostedemail.com: domain of 33gj2aAgKCBc6xFBA95H3BB381.zB985AHK-997Ixz7.BE3@flex--jasonmiu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=33gj2aAgKCBc6xFBA95H3BB381.zB985AHK-997Ixz7.BE3@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760954591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3zkkb3/hxx2ZrEmxAOPFPinoGf8SbvbCWVFeKCtPhzY=;
	b=Ej9TMxKrsJiNDgs3VqRqRKNb2RH9D/4QLCdrxG5lD/au087iwR5L2oYNLyNeZo30Qb3yV2
	vhxNTfKqVRetqZb0awfFa1/M/3PXHDzrMrqqZvgscsPmGJaxIY9adFlWktmmtc0lwNx2bH
	b3t5Pd3AlJk/RvigjbTNi8CxsnTm1hQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="v9m/FCtF";
	spf=pass (imf23.hostedemail.com: domain of 33gj2aAgKCBc6xFBA95H3BB381.zB985AHK-997Ixz7.BE3@flex--jasonmiu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=33gj2aAgKCBc6xFBA95H3BB381.zB985AHK-997Ixz7.BE3@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760954591; a=rsa-sha256;
	cv=none;
	b=utjZL+Ik0gsSxM2u1p3pb5ievSEeMTG+9ruQhAUOMIu3RND8sQQ/ipYL0vSeAhqvrZuXM4
	MYz6BIgCYRSpD+G0WGKeFyz1TG/kTYMBD3ccbe5wkgL/drpQqTaVSdo4oCiBKv0WWe6YA1
	NbpXcnHVdxJOImdRwLr1b9YjbB/zGQw=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33be4db19cfso6486422a91.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760954590; x=1761559390; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3zkkb3/hxx2ZrEmxAOPFPinoGf8SbvbCWVFeKCtPhzY=;
        b=v9m/FCtFr3oaQawkTgPZc4tHcA4iCLVsVH7rlxd66h6m+Ka/yAvct9VMj9uolehEqb
         rdnd+QOu/0ZzlHYIdv3llQC7kwY6kywLop/+ESGCrgVwxNjVnSBFTAMT6Ek2wWAUEQ3j
         BEUwS7YIa/ChBR+cy4mMtCMuNWxHt+3GJ4Ghh+KdG+eXmsOtxRN/GC9loCQ31Uy6TT/v
         IfWRtxjkNtmq8S9vY/Wudl0VFZ3fRZamA2YVfJzyH52UnOM++/lhkoq5uf+ocaZUKrsW
         KVVT48Dsxj+hj4q+TvVYQVSUtfUTyIssoZjSSUO0h7vQdzvT+Ied+t9WiWNj1q8AeTya
         zZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760954590; x=1761559390;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3zkkb3/hxx2ZrEmxAOPFPinoGf8SbvbCWVFeKCtPhzY=;
        b=l38EAmbeurrvUncjQMa4XZ06S1ICVdzg0rAzxZkmB1CdDRsSUKBTWLs11fvAnPM6E/
         B96tZrbY/KfXEE5h4ZEoNkjs4uQoTSIDD6RkS0exRZ4ReEl5m7dalefzRieRfhZVeLYd
         K2XHCsbg0o4WumNIEwCm8EKmh1pSZGUM5K3URSCaDqKpFfGfrgkTKgt5Jt6Pce7a3WeS
         198uvDWkdE0MdmGcDnYIp4vu1BW07j05GZicNsuH/PcLKBGjRfm+uh6zw4z1ugA6n/GS
         FKqYco3kjUnJ1bteclZak8kVmJD1cPbzENmHXPr9EBH6P4lrdIyPo3wksU7PPic7CocB
         zKFA==
X-Forwarded-Encrypted: i=1; AJvYcCVQqMNKcw3xSDZZ2Api42H+ZzzdTSduJkVubdjtUcZLh5EKhLwniNzgDgrN1LKV88vUHRFy0+2cuQ==@kvack.org
X-Gm-Message-State: AOJu0YxXLp+QCYjdMaap0OjMSlVfbr6C020jt7FZLdK6V/jLe5mnVg0U
	vMdMEFy7gh8FmQ6xrIWeXhXnKNbA4Xi1R2PxdoqqZ6x654AiqTF5ocQXOom9RJFRqHAERdlZmNh
	EXww689B8PFedtg==
X-Google-Smtp-Source: AGHT+IE39JYyDP7tyke6Ks7t0xTJvAaz4ioHAVUQMd14F2ylAQznE4GvniXnCX4D+Lio6mB0thI0FwjEvWtddA==
X-Received: from pjtk2.prod.google.com ([2002:a17:90a:c502:b0:327:7035:d848])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:270a:b0:33b:ae47:fe72 with SMTP id 98e67ed59e1d1-33bceb1cf3cmr15607754a91.0.1760954590010;
 Mon, 20 Oct 2025 03:03:10 -0700 (PDT)
Date: Mon, 20 Oct 2025 03:03:03 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251020100306.2709352-1-jasonmiu@google.com>
Subject: [PATCH v2 0/3] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ok3p7x9n9absn1bgrjqyoxat6aua9bjq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3EC94140007
X-HE-Tag: 1760954591-161278
X-HE-Meta: U2FsdGVkX1/yoCWT9wQotOOh5AMfBG2ryR6X/RXppSk97QR0PQB2FpzSpHrV/G5mjHWtKBNonUTS1E0gUYetmAyQMBxnPdRDy6pXgW+Q2dx9iUjnmO5XjTgUJbQLy+8wng/ALwM7cspaKXKsvKlmdeq01l81OnTqf2/YGA/XWgjKkd4+EqMmaWGtoZlhEN3PfsIFjNkDlaaxyQN3jOaHapXekxsfD0SnbgCitJAQY1gAoAiev1eR7uwKzl3UPic348QlyE+NPGTXxggYacc3L3O0JEG3+T4x+3Cw9SgsDzH2Xiek1YqHgl/OxtNLZoYvBuagJv4A+Cl8HpLiBCVvV7vExMQbiRjiMwrFQ44JNbJsBtv0gSDALHhk5aEwOjPY/l9KeAQtIQeWu+M+gUfYdooSW29KnPdqvPGJavo355hWdE7+hGEmTalWSGgmm87D+Sg2a7TtnTm92mf4lRY7Ewuvz6Yhr7KbguO6b76F9VE1Xt0bj2273hf/ZfKId9LA5NiN+Q9PpOHj8Yt4RZE9RiTLTEN9tT3vLdYJXG7o+gIu0hCES8H5OFESBAHVUNmWWVlDbL3R80W0V3QmND8edYvPkIBxgP8M0xRj8TN8T/9OBuGhpsm7SzFcIRhPEbeD+q9GMaOnYaROGdWRNFKSpeFOZdwFkyu1XL3ndhdzJmi6gLSJKKkAdpMyi+POQ7ezGiJ42ofy3hQXMLP6OPf53gWFURMwn0o1TuPaIIPByg3uT/6O/d99q3fiGpt82Rb/UViujKdO3LgXssZs+hAuhZGVolTVlTZfcpFRf9Kzr9OaFfku3Cr336atd8+G54MDEmwZuQPCwAoO2U8NYikFqTI49hMpFfOzGYInST4Q17ib7QNCqqJiYIt2f39OgObEF9o2lFFnK5AcStBz3v2bjRHcH9ywJP6yqXpRMc9CtLOirVfwl7jDjRGvK2Bz0wK35+KPoI9EFD2bRZmkY8R
 H1fInWSs
 T8xmw6hP4fPrjuhY9sRyQJ3x/SndZb/AXY1GqvJOv+qmOLhex0hKCMH/9ln92yVZ17CuXrDOaE01Hi/JtsOTV3a+vad8htX7Bn43QvgD4Y8+fvzDsSq5RBpByMfoEqqwO8+pxEsSlTFBcA8sbYebJNr1S+uFeul/97Z7D0y0OvmNOQnmYZlNvY241yi/G6835MJABsHAlBhON3hn7A26fOiFolOQt/nz8ciLM6Vxxs2vBuxJOciGoXXN5fbR+LARR3sxpUcRqA3o9HrjylxHO8j0lNrd6yBPaYzKY9kV0wk82NwtREx7kWxCEGkuTGEqFtENJl9TGv5zVAQcintF1bFuUIhoZ6p0FqMBWia6pjKwg+ER5vWnSBM0sAgZb79WJ3vTsd8EXXgKNUr4zcVuPyzBjxROioD3laktzWXtwX8lnQ3zcaVqrIQYYfwiFVqnJxSaIA1J/dkOzPjw+RBEYVrEhU7QZP1INI5Q5KjWPOPNwVe7bfkzzo6NBLTHA1efzD2AgLOTalsE49i3f5rneNzLqVzYZLzeA2ng6DzXoVijlS+WEGIDnctw6qobZUOK2CqB3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to using a radix tree data structure that can be
passed directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the former KHO state machine by deprecating the finalize
  and abort states.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A page's
physical address and its order are encoded into a single value. The tree
is composed of multiple levels of page-sized tables, with leaf nodes
being bitmap tables where each set bit represents a preserved page. The
physical address of the radix tree's root is passed in the FDT, allowing
the next kernel to reconstruct the preserved memory map.

The series includes the following changes:

1.  kho: Adopt KHO radix tree data structures: Replaces the xarray-based
    tracker with the new radix tree implementation and removes the
    serialization/finalization code, thereby eliminating the KHO finalize
    and abort states.
2.  memblock: Remove KHO notifier usage: Decouples the memblock subsystem
    from the KHO notifier system, switching it to use direct KHO API calls
    and adjusting KHO FDT completion timing. KHO selftest is also updated
    along with the APIs change.
3.  kho: Remove notifier system infrastructure: Removes the now-unused
    notifier infrastructure from the KHO core.

---
Changes in v2:
- The radix tree now uses 0-based level numbering (previously 1-based).
- Added a new public API: `kho_remove_subtree()` for clients to remove an FDT subtree.
- The output FDT is now protected by a mutex.
- FDT properties have been moved to a new header: `include/linux/live_update/abi/kexec_handover.h`.
- The KHO selftest has been updated.

---
Jason Miu (3):
  kho: Adopt KHO radix tree data structures
  memblock: kho: Remove KHO notifier usage
  kho: Remove notifier system infrastructure

 include/linux/kexec_handover.h                |  42 +-
 .../linux/live_update/abi/kexec_handover.h    |  10 +
 kernel/kexec_handover.c                       | 869 +++++++++---------
 lib/test_kho.c                                |  28 +-
 mm/memblock.c                                 |  45 +-
 tools/testing/selftests/kho/init.c            |  19 -
 6 files changed, 464 insertions(+), 549 deletions(-)
 create mode 100644 include/linux/live_update/abi/kexec_handover.h

-- 
2.51.0.858.gf9c4a03a3a-goog


