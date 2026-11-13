Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F8F606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEbwHmkR
Received: by kanga.kvack.org (Postfix)
	id 25C116B05C2; Fri, 13 Nov 2026 16:36:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E64B6B05D8; Fri, 13 Nov 2026 16:36:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE236B05D9; Fri, 13 Nov 2026 16:36:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7F226B05C2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:36:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E4C0160246
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:36:25 +0000 (UTC)
X-FDA: 85431404730.27.B327738
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A78E1C0008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:36:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lEbwHmkR;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794605783;
	b=GbVTyp2GHFn/VlFvsFKlfUsLiSb082RGQu5MpN4kDFr9Pa2BbC92dSmkrqWy6+ga+FVgIB
	uuZtY5cBBvegsLjymOtD0yWZ09QJVYn05CZVRK8PE6t5rPRmzeKeMVmyiC+a/AGtHk8ppm
	n84EB5oSA2zeDcza224g9l5lOd6VnTw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lEbwHmkR;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qoTt+MDRkeoVNwu26WSyXJZ+2Whw1KHsinqhf7xKN0w=;
	b=hhxSVp0B0Vl+OGGghcMWyMYxeYNX/2jAwONBDcRKHYwjRFxoU42OwVW1HolL56ImnLN3Dm
	1WDDzOd6b9Bhz8EaVr/FFg/aztELkVvgFaR7srX6V9wmD+7Zu2zfLr4nNllPJf/fwHzZOd
	oM/757h8tBZ2n/eU97ltVLSgubTtAM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C93E145619;
	Fri, 13 Nov 2026 21:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF551F000CB;
	Fri, 13 Nov 2026 21:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605782;
	bh=qoTt+MDRkeoVNwu26WSyXJZ+2Whw1KHsinqhf7xKN0w=;
	h=From:Subject:Date:To:Cc;
	b=lEbwHmkR7JeWSvaOgQa55K2iwpCMKNMvqhMle+H/PulltxLT70zxLeQJl7VoTOnaU
	 Zk2ydRTQh9FE6Bwev5F08wAb1FjrbryE3cnR4qIqzOMxgDULOgqLCI2R1lwibdgs9a
	 Wxpge7J77BbReVu4Mj8rixE2121QLGWe5iRD4NWVTeDow/YV0H2xKCnvQvV//6xj5Z
	 8eb07+dpLj1trGumYqUmMnJidRa/okjm/55n0WVz+/9iV0o+SrllijWL1ZwchgJCl7
	 u3R84o2Eu7TeOfi6t8jF78BRFe4hG6RzbujpsBifWVx8u5v9aNo+KF7pZFwzUiypv1
	 5kwH0u/SRWzJA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/2] mm/mempolicy: shared policy limits for
 tmpfs/shmem/guest_memfd
Date: Fri, 13 Nov 2026 22:36:11 +0100
Message-Id: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMuC92oC/yXM0QpAMBSA4VfRubbaEPIqktgOjgxtiJZ3N1x+F
 //vwKIhtFAEDgweZGmZPUQYgByauUdGyhsiHqVCiJhp1OsykbzqiTRtLO14EucZVzxpwVerwY7
 O71hWv+3ejii3dwP3/QAK0AcEcwAAAA==
X-Change-ID: 20261113-mempolicy_limit-6f043870d04b
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2020; i=david@kernel.org;
 h=from:subject:message-id; bh=swg4p31TendTFxqtz+LrPRXfqomDbwEqx/NII4CvOWU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+N53bqxhq8HeBCSfrhp89N01PaXx71f038bNWQ9Ecd
 svXq5xiOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIqgBGhqsiTx95aLYfy83/
 GvtYJ2iOzZSi/FM8V5Wf1Ka38Ce6PmX4K/Y38sa3108OF/w6ILcuKHn1zclTu556bv8pulA75Mi
 F4wwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8A78E1C0008
X-Stat-Signature: xhy3g97ez4kfab77or9ucmpi85g73s4n
X-Rspam-User: 
X-HE-Tag: 1794605783-435677
X-HE-Meta: U2FsdGVkX1/cyPxau+hAtU8cv+LUnENotz5dx5kA1mVdmY6ekaY4bvNhOnDWhFBXk7N7vlx3OSYKrCyO6Ft1+BnRBgvoo207U9LD5SRib1PPvZXAMrjViH6WfMUzBa6r2g4OvRb+w8xE/yZlYaOaQ6oOFM/eySaILUDZKKARujt8EAaeYFFazxHjMTxpdxXGFRq7BFNg2n5IXfoOK0apAoP48xoCNoEjhd4JAr4Hvsuq4QljPSvq4r47FdpH0HIglUK2O/pzQk4KsppR4ZKVRluxCeysiE5psAoWp4V0Cj8njNL9Q1FBL1lk5j8fIQhIbDQ3ZB/JmAZ77sw6l62fL741QibAODfnPNOkSFin2tUX2k7Sn7TIEn/aXPWcrMiUuzykUcAnf5NPMkj929bnQvhHEURAKNDP3KNmo+5ZzK/EPXgvAagelKeKeuuRaFVe7tgADl1yUPQDyE4QR/BcOHQQgGLC22YVa12WsbFfYa7BLbZ2YWmHmmLXcNq1/yO/oesC2MqfCjFvGPFKuBYtGF2ltwbb4sqsXbUL6WPQV8+jSiZqAX5hz19s7QUQ2n2doz9xNxL3geyGKY9sOoFD+Umx5aDRwHgX/7kzx1MZPkXcZW4e4Q1u1E/GsokcPbanHkulYtsKYEAv97uRRIAUne+wKoz2AhhBtbVP+k3aTWSpPdeJWNl1NfzHqBJ/Nst1pPtBnUBBe1P4UmC9rPtbDqSQ6g6IVuhnmkBZfymQtsqaN9ycXg1Zhir0x9E12iT2WhNskaGl0fuCB2Xz7bDbvuXWJ7S43QVEzqP7Xg3amBvDRBHvouCfUCBwHhBVOWtC7bQ6Ns8ovoLigv8Hox/dVd59YJ4ywwfecLsiSs4ReOixx5AxYZlOtRYSHO3ab9lJ3QXTWOEKWdo1bslP0H2VOqIvTNy2RhRf0LUU0m3ZvHRFPMfQlzb3q89/kOg6HgM+9BvnjrBJYb0SXrFpakS
 Oewnt7EB
 6pdYtRbuVHqr21ulZW4gAqhwnuMSYcfQPgvbu/jBgpTVrx4L2uRzv83d41rRdmjZzEIw3gAELC/PQG6SAN24XQjD4yLY+2p/ObaopYnLa2KPwdZorN4xuGim4j1LVzhN2UDvHpLi1Lb13Tkw4ZG5m4VqyP0C8a01eJnhsorFP/kIHRJ/lzCX+sLMpXY8EzpkYUygDl7xtSBoqWJM4zzGQY25mHkYvrotqXrv1FRUYUQdQQRFvfXHn3bNEYhqcuZGiJy/q8gdCXd7dlLmF0EW64jwIxsfQEsUr5F2f2yd52vK/CRf6ShHFYKVDQEBsA7iq7s1HWZzF1yc7e5z9wTr3buqXF5vtJJ8pr/nlXMswWOf948vs1R6cCwIkKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For some reason we thought it would be a good idea to let users create
as many shared policy ranges for shmem/tmpfs as they want. And
guest_memfd inherited that handling.

Fortunately, at least for guest_memfd we know that we shouldn't really
have more than one shared policy right now in practice.

While we now at least charge these allocations to the memcg, users can
still allocate possibly many, and cause trouble, for example, by having
long list walks under spinlocks.

Instead of trying to improve things, let's just stop the user from doing
stupid things.

Essentially: limit the number of shared policy ranges per inode to 1024
as default. Let the admin increase that limit. 1024 is likely still
plenty: who maps a shmem/tmpfs/guest_memfd file and configures that many
mempolicies on it through separate VMAs?

Maybe we should set the limit even lower ... but 1024 feels at least like a
start where no user case should be impacted.

Patch #2 can be considered a fix, but I am not tagging it like that.
It's been that way forever ... should we? The impact is primarily just
wasting kernel memory and doing a lot of expensive operation under
locks.

Patch #1 prepares for that by merging adjacent policies if they are equal,
to reduce the number of policies further if some user space actually does
something questionable on sub-ranges.

This is not super urgent but something that should be addressed.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (2):
      mm/mempolicy: merge adjacent shared policy ranges
      mm/mempolicy: limit shared policy ranges per inode

 Documentation/admin-guide/sysctl/vm.rst | 18 ++++++++
 include/linux/mempolicy.h               |  1 +
 mm/mempolicy.c                          | 74 +++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

---

base-commit: c6e0cad6c9b4180bb229db06e5b062c5ce0723bd

change-id: 20261113-mempolicy_limit-6f043870d04b

--

Cheers,

David


