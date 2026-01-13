Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D1BD29DC9
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 05:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0BAE6B0005; Tue, 13 Jan 2026 00:35:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB84B6B0089; Tue, 13 Jan 2026 00:35:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA1A6B008A; Tue, 13 Jan 2026 00:35:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD60D6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:35:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DAC61A015B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:35:31 +0000 (UTC)
X-FDA: 84325828062.15.0503DB9
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id C0627160003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:35:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xiE+gxLU;
	spf=pass (imf08.hostedemail.com: domain of 3oNllaQgKCD0iZrnmlhtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3oNllaQgKCD0iZrnmlhtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768282529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9CxZpP/TD91KuOGl9bFKk1rpeztgtL+/Anznpdt7LJs=;
	b=fCZUBhURhLOsEvW23K5JJEqCpdm0v2CO1ZhZ1PbvvQdBBkBSZ2wTPXlwqrRARzbi/P/Uif
	BDzi23FKkkRgWE4RkSlwvxCzqnMEvGUjLJhvxeh24fgCT2NpM64O8kbzbNo4rkr92zv7bz
	A5VHRn6YWNViA8d5qaDr+VdA79WRXTs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xiE+gxLU;
	spf=pass (imf08.hostedemail.com: domain of 3oNllaQgKCD0iZrnmlhtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3oNllaQgKCD0iZrnmlhtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768282529; a=rsa-sha256;
	cv=none;
	b=yeT9gxP3tKIh/j3LaVfDox1EjoFoTzVNOvUc2pa5d/BZVhkp7Okw3cTyCPRNGzskiJSrdt
	MwoqIqQiABhRFXd9ytSHPYaFqQ+12U3yCkBrJD3wa6Q7koDUvvrGeJTqPnLqtMe5aRg0Ux
	UftK+MUQno9zDCXz2uOlwDM+auD85Lg=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ae29a21e7eso4178404eec.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768282528; x=1768887328; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9CxZpP/TD91KuOGl9bFKk1rpeztgtL+/Anznpdt7LJs=;
        b=xiE+gxLUhQ2bXxw/X/VfY/RelAGmG998mj0FKRUS1nZ8O4KoBCjPbV8OjI1AvE2ETa
         t/SN+Lq4cRBs2l92N6jYS/lOCIRBFJNvg9BRRC4ASHp1bnPM37mrWKAs2QnLapDpQrk3
         m2YkpIpynGAIWEls9yB84u+It9PH2yp/or4vUixmM9PbcgNY58CsYUmrTLrwscZjfUei
         vjpuRozWfEICzaSSd39Iwn4aLdykq7ta3QuBHn2VKOAV5p4Oakvnvet2F8bfkBDW+WKQ
         rzI4W+BaA/dJMhhVtuQzNGOz16dT4MaQBuA1Vv8DOyqP/WtL5DQ9jMKZy0dg0VRhjuOC
         U1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768282528; x=1768887328;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9CxZpP/TD91KuOGl9bFKk1rpeztgtL+/Anznpdt7LJs=;
        b=bD0HMDO8d4AZDVxcIjZww/AWpg37YWFX0E0L9vCfwwYvO7SOO0RgvjL5bTf5xr74bQ
         Y9CCmXZirtf2xof7pEmWB2McfA4REme48Q5YinjpS0zExFMm9mBMWcQWBAzzA8wjwxqX
         VvmsBVdJV95bLPUxts/tH/pgfZLzCRRGD2Awoa5uLvYkRI+7sRFUZz8ebGI8Bwb290lC
         ZeWhnCwaC5NByD56m70BDosiApzjLpsUpTw9gEisEKTVQVq80F/dKMLXeKQsVkCfcFSd
         FGcPyPchf/2xEkBUI7WNedOnqC/a4oPWscNZjT0lGPzFCUDDJimOPcNNWie4O4dUpceo
         Ic4w==
X-Forwarded-Encrypted: i=1; AJvYcCX9Ptw1jpqHWT/doAKBfJwDPukvQ6nOab9WcfPsq60z2wI7Fh9IYkZShz0McqN6cq9kbejLvEkAnQ==@kvack.org
X-Gm-Message-State: AOJu0Yzfq5pZ4UrbMkArjdogE4y6FfpePCmSPpxFOLJpb7ACfkWam7qo
	wjPbqoydBBdfmu+hCc0Gzt3/sZL2+qCPvs19jGGbf+zctCVDhqvMGs2FY1gEpY577EKi6yRu8p6
	HjF2BKZDom3rU3Q==
X-Received: from dybdr38.prod.google.com ([2002:a05:7300:b2a6:b0:2a4:733c:4a27])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:a148:b0:2ae:5a2e:de70 with SMTP id 5a478bee46e88-2b44f21b4b9mr1940864eec.8.1768282528208;
 Mon, 12 Jan 2026 21:35:28 -0800 (PST)
Date: Mon, 12 Jan 2026 21:35:21 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113053524.84186-1-jasonmiu@google.com>
Subject: [PATCH v5 0/2] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C0627160003
X-Stat-Signature: d9q3yp8dezutw9fbkmpb8cq4gr31az1e
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768282529-637896
X-HE-Meta: U2FsdGVkX1/Jsf4bdabJsWvmbApSh+sjZoK8xx/Gz07jYbOrRPAzPgvt/iqPw79zLUM+hkGCA4ZWzkVr8NsnblJcm9yKWcIzH7NhdzemYCZTzr4HU+H+4+/H9WOUxQwlqeul9lroow8X4yLefto39KhTfE89are+q/EUXfl5mC0RuNYAtn7IWOd78DFtcx7uyPEqPrPOu/gKE9Kycn+VaoH94EzObhNMBRoavDXXA0kvHaL7P2HWOP/g+Mjmf+784x4vBxZReY34vkwqJDwnU9MDuLbai8XVAUNoQN424lYF3GUjjzeP01zVESTpy7NLNCdG8cFihPw/x+V+QgQVAcVdbVpoLUhekLfIEvCdkTnhXbHtdyZ2JVI1kH/3Q6xw0w55bZtADt8hH+0/KBVdJcFszDnuFAnJwBgRu5b/sN5mmBxl+fO803trgbesBU0w2M6DTxLpaiUqGuKLzI0LF0OGYNBkQwyuSITpealeKZM6hFMhLVj6cnrTrNQ5rScLCVSC+AekbYPosBvB0zgvxtGwA0MSPXrG6t105Fnwu0+PQerdlno7DE1B52lymfcqQ8a6yHGLk2nIkmpWdAMe4wtqpvEBOSuHujsLBdysr+rO8XbrJscTHHX8vEDrGmEKFpnSFXbmhNY3hOmE8eWMYQL8gtvNj507g7LAnwYmScuDZWjJSZBfWxXyJauHn65NlYSyGA42iTLnyt2zQeXsyyYCxrdd2ys5SPhKBc+XQsNOINERtroWCO8DY83Mm1/fpllJw3pIsKaagTqz7feIderaN2gf8n/MfxEb2oCoYIefUw8iSVxhxT7pz9HpX8RhoOnUN13oErLEv/grbC5yEFYolFBKI7pd40cd7L6txwIyMFab6HcezWB4TSQhY5tty2THAUIluVZee6yuqFC4ExKYLsQvY/qlV0wOnD9Cz0GSzeUlMBufImZCaoyN3r3WmC7A61fUGf46nfBvIBz
 44Qi5u/4
 UdL+MxeV+YslNAKiwyOj08HuldZg5yaKAFeRu2AFT6ACJiXh2kXZ25hvSKUbR6Q/TIPYtIipZ7JrUmqbmltsl8uWbTx+xj5YaigepRQ4D7s9oAiSEpq1pTxY839fWTY+8KHaIe4XA1mCWyy1JPJEMtTV/fA/nPW5qwKEucgxtMG80Q5nszg/TZRq4Y2Wb/gqaXBhbRmggfSrRWSiZJWScLdsK43Au64PHZe7UbuLV0ncG+VjwBj0BXYaTanDivcBRoNWfM63rc2aNU+8FWlcfsfhzqAQ/MSIMNmor9P//+5kRJRmXiN2Y+b2WBXrZVVc3UrVtFk3uG3n9PLNjInl9klvIdhHFlLoBDksyirnkefvKUBeWo7vNJhh4t7QaPF8UKFH6sn/k90Nd0qZxnB6Y5vwyiJDpihR9Pwpx6xOCX2l7KDxx+cdvvW2Gx9J6IYwh8zsqZ/DJ1YbmAFFGljmtggdns7uQwMVtdmr0oIYMSk+nITZFlchmT6iyPbWb9977KCMxPhpvmk/BffbgKo+593q16NKo0KVQM2NErXCWgTZpxfKTPbQhXBocFnVOMHmX0dN6xt5YmsWNYOI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to a radix tree data structure that can be passed
directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the KHO finalize state.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A page's
physical address and its order are encoded into a single value. The tree
is composed of multiple levels of page-sized tables, with leaf nodes
being bitmaps where each set bit represents a preserved page. The
physical address of the radix tree's root is passed in the FDT, allowing
the next kernel to reconstruct the preserved memory map.

This series is broken down into the following patches:

1.  kho: Adopt radix tree for preserved memory tracking:    
    Replaces the xarray-based tracker with the new radix tree
    implementation and increments the ABI version.

2.  kho: Remove finalize state and clients:
    Removes the now-obsolete kho_finalize() function and its usage
    from client code and debugfs.

---

Changelog since v4 [1]:
- Removed the 'level' and 'start' arguments from the KHO radix tree API
  kho_radix_walk_tree().
- Removed locking of the KHO radix tree root during module initialization,
  as it is the sole user of the tree at that stage.
- Renamed kho_radix_get_index() to kho_radix_get_table_index() and updated
  callers to invoke kho_radix_get_bitmap_index() explicitly for the bitmap
  (leaf) level.
- Updated documentation to clarify that "page offset" is now referred to as
  "shifted physical address".

[1] https://lore.kernel.org/lkml/20260109001127.2596222-1-jasonmiu@google.com/

---

Jason Miu (2):
  kho: Adopt radix tree for preserved memory tracking
  kho: Remove finalize state and clients

 Documentation/admin-guide/mm/kho.rst        |  53 +-
 Documentation/core-api/kho/abi.rst          |   6 +
 Documentation/core-api/kho/index.rst        |  18 +-
 include/linux/kho/abi/kexec_handover.h      | 141 +++-
 include/linux/kho_radix_tree.h              |  70 ++
 kernel/liveupdate/kexec_handover.c          | 682 ++++++++++----------
 kernel/liveupdate/kexec_handover_debugfs.c  |  23 -
 kernel/liveupdate/kexec_handover_internal.h |   3 -
 kernel/liveupdate/luo_core.c                |  12 +-
 kernel/liveupdate/luo_flb.c                 |   2 +-
 tools/testing/selftests/kho/init.c          |  20 -
 11 files changed, 557 insertions(+), 473 deletions(-)
 create mode 100644 include/linux/kho_radix_tree.h


base-commit: f417b7ffcbef7d76b0d8860518f50dae0e7e5eda
-- 
2.52.0.457.g6b5491de43-goog

