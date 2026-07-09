Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111FDC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9866B0005; Thu,  9 Jul 2026 18:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A8F6B0088; Thu,  9 Jul 2026 18:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B899F6B008A; Thu,  9 Jul 2026 18:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 924B86B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6B991A0294
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:18 +0000 (UTC)
X-FDA: 84970682916.28.54ECC29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 36D9C140009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kpqnw+ve;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0EyJr0/xAe7avOLcVrbyCwP6jqYeJsuARR8e8XI8AfY=;
	b=AueHVQzFlMJnBjE68QUakkdKp9NXDn1nEl5NZjKs98EUKs1C3PvHb8wpzCiK0qT8Wzqxsv
	Ii9ZV/BUVLEDRu9mxU9x7AyyNCLwH/OyYeID2MsAy38efEeJOW3UUUtm6su88fbSR+X7hX
	r3m01fMgvHXDBl8KvWMiWqRwadvYZnc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kpqnw+ve;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636217;
	b=urhFMY48BdKp8n1gAAgilAN+jVU9KKUAmnHIyqWHdCYhk3hoeiO0XdIOpCxTVPFPQi6c1m
	KPn3+FngZTH8+piltYFyaVjvyfYPROzigC9YDMRK53Lzw9XlDjhlVAGoWwIbhCaA8VZN2p
	ragmpy53bt+wBtTpi1fGoiUPr8BQRIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1A49600C3;
	Thu,  9 Jul 2026 22:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70DB1F000E9;
	Thu,  9 Jul 2026 22:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636216;
	bh=0EyJr0/xAe7avOLcVrbyCwP6jqYeJsuARR8e8XI8AfY=;
	h=From:Subject:Date:To:Cc;
	b=Kpqnw+ve3+9UW3cJQqw64p+5ga50Zy83nVzL36o2r88lhFRV4fRR3pjS5POG/Q58R
	 Ufj85CJr+d1t9rJzjw0kAZQmfzJvSpnfOcbbu0aX1gxi6opni3nYUxXhwRB3RoBWsC
	 YJ3xl0OfLEL3GoWGEgv6BVx9Rgtd7VccWJHZetVUvYTFaeyvfVTWaCkybDA0QaQJ/2
	 Ueb8SX8FaNy6q2UdG2h/V/w2QzpDXJAzTIf99ciQ5Ll5FPTMEMobwku4d2k+MsdG+e
	 99hNp6IzOyeDBP8GbiaU3BRfhHrEUzJ1/qzGiTsGaI9ZxLiSfg2kQwf3sIs+RqmNkZ
	 yeMiTIK4vu1KQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 00/23] binfmt_misc: write access fixes, RCU handler
 lookup and cleanups
Date: Fri, 10 Jul 2026 00:29:55 +0200
Message-Id: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOMgUGoC/42OXQ6CMBCEr2L67JK2iqhP3sMY058FVqQ1W0SN4
 e5SvYCP32Tmy7xFQiZMYr94C8aREsUwg14uhGtNaBDIzyy01BtZyS08IndgKdT9cO4pObhG11F
 oQJWrdeVrpdFtxTy/Mdb0/KqPpx+nu72gG7IvN6xJCJZNcG2OepMG5GKsCg3sVG60lIbIr++7U
 WXTH0dGBRKMlDvvS1tuvD10yAGvReRGnKZp+gBDWBS49QAAAA==
X-Change-ID: 20260708-work-binfmt_misc-locking-15347df12ec8
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=6831; i=brauner@kernel.org;
 h=from:subject:message-id; bh=O/cickC6NJoi8fvGwVtPbnnxQPKMcPn36PywjR+AOYA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHz9pMSr/Olnjlyr6Kb23+npDJr5K3Qi7HUtjI7rC
 Z8/28/fUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJETzgx/BY8xTQp6kxjHPeVF
 UAEr027PkiMaCxrXdZ9t3NElceBZJyPDjQMeV/wa3thtLw3zEXn2fYnXqmtsd9XmbYjtnHV0z1R
 tZgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 36D9C140009
X-Stat-Signature: qnxz3sb5zfizxpkkrwoqzrtnyuq9x6od
X-HE-Tag: 1783636217-171618
X-HE-Meta: U2FsdGVkX1/K7BdbDsTv2wDAHXR0xc+R6TfpVO7AdgHdVumvpGS24lrrbQHxr0YhUEUlKLs7fukseWlHpJoup5EOCfCdlpVIAbAyBzVGb3J+cFPWargq5Oabnd13LvLeXEZkWHtZCPYzBBdc0WuSlExOI4WYkcLQnFTz90c9krhGG9N4mcsNq2DHS+o7D0xfkw8Uqi8k3ss2ExdLxONvJbTzl7GQLBJW7fOBCvT5PaZWyQDm1g0VLpkbw7AOxZUe36q2G3ll3/XRfglmKq9bxzzTJrfUQkJmEVU7NVPq8hWOeLRaePIG7WEqI2hOu7Cw3gYYdCMJjp4AydRa9ckYjPcZyE94uUcWZfZ3ZcDFW/A5TInweJN5u7S2Uh2zojztPo0rJsEnPITrDC0P1a+L4arFufp7WEEcugRem1rw7mXUWz1P1ls6F5TToxYGZxENr1tWJSzh/rzLlDoJqDVA70yKAqxM+3ULiQ9Id1Wh+PKW6XnpEU6egkAY0qHkcIV+Uwm9wgK44tRftd7BUdRpFnvzT27m8IlS/7LzwXsoWnE1VA+jzxS+dBv9I5uyKC9f90Ik01TK6GcK243AaP3h398LemR565CV5RUS9NpV5Kv24xfFZfKhYECNqR+Jc7EOOkTDj+63SleMubTze7hLe+HBA9pC9GRvNpt3R7b6YdEyjM75gFeI9xvXQ59WwfCGQOyoPj275CYAEB1cukoB1FptF9tiCubwKTwb8/nOmOsYea6qIyaeoKPxM/5Z8WOiT9LK9DKEsMS/nqQf5R3o3SIgegtXDpwBJ3FNMQlCZSzTGsb+JstzQ1HCWvXbM4bd02WDouMdze3n03V89YJmCR6GMRzkDrTY55Cxb3x3sGQJ3QX+ux724GIyhpxYs3B32Z5SaCGxqfHbDfQMQ2mBCyfz7mW5jvjgOT2crfQBGodkW+TiHMSVb5WrnoWZy0TEH1X3gok5mxtQXju8Kha
 BoBte9LE
 sIcTn1RLBhVIINgkPd32HlNfZ5kiIUEFyO6DMdJi9/8ekWqAoZrJFHdxtEyPT0YbHi6jjs+J8TVcKlZI1t8YzQq42OgIQoH+4f0pn01ZOudemyUhq4pGwMi3tP7ApkEVLjMzvrQxTFI4kt4uXQEqQZQJuQMpDht4hRXNzF/4obWOuuFSNt8e9flaGXflPh3xo/IQ64VrrNHDY812p91ECNJNP7xQVnSQ8Uedmer/3ohOXPHpVML045HGqqU0hgpz6s4t80fr7QbbRbMoK4DXJqz9qUbBRKXDJP+FerFTlw4VdBRcbyV0ENrrTCsDtbCCoitdI9zMKQMvV6Ev1KTJkXpXZx+MANOetBM4TrlTGWxv6kMZ/f3xAX0R2XdKUQZTZ0RFEPdZXdPFhbMhZyTxj1NRRcqDCDV85Kgh/pDuHn8OnsZnEil9/i6YZr+BzzqfUbxLCvFBMvtqGUT+wLBk5kEF2Bdg4BQ96EYh1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first two patches fix two i_writecount imbalances on
MISC_FMT_OPEN_FILE interpreter files that turned up while auditing
the file for the rework below and are marked for stable: removing an
entry never restored the write access denied by open_exec() at
registration, leaving the interpreter unwritable until its inode gets
evicted, and the write denial taken on the interpreter clone during
exec is not paired with the FMODE_FSNOTIFY_HSM aware release the exec
machinery uses, so pre-content watches make execs leak write denials.

The rest reworks the locking and tidies the file up.

Once binfmt_misc is loaded load_misc_binary() runs for every execve()
on the system since binfmt_misc registers at the head of the formats
list. Every exec therefore performs read_lock() and read_unlock() on
the entries_lock of the relevant binfmt_misc instance, i.e., two
atomic read-modify-writes on a shared cacheline, in the common case
just to conclude that the binary matches no handler. User namespaces
without their own binfmt_misc mount fall back to an ancestor's
instance so on container-heavy systems every exec on the machine
typically ends up hammering the cacheline of init_binfmt_misc. On
PREEMPT_RT the rwlock additionally turns the handler lookup into a
sleeping lock on the exec fast path.

The lock protects very little. Entries are immutable after publication
except for the Enabled bit which is already toggled locklessly via
set_bit()/clear_bit() and entry lifetime is already handled by the
users refcount. The read lock's only remaining job is to make "the
entry is still linked" and "take a reference" atomic with respect to
the unlink sites.

So make the lookup an RCU walk that acquires a reference via
refcount_inc_not_zero() and free entries via kfree_rcu(). The removal
paths need to detect whether an entry has already been unlinked and
rely on list_del_init() reinitialization for that today, but
reinitializing the forward pointer of a removed entry would make a
concurrent lockless walker standing on it loop indefinitely. hlists
support exactly this pattern: hlist_del_init_rcu() keeps the forward
pointer of a removed entry intact for concurrent walkers and only
zeroes ->pprev with hlist_unhashed() serving as the linked test. Hence
the third patch converts the entry list to an hlist so the RCU
conversion in the fourth is a pure locking change.

Writers remain serialized by the inode lock of the root dentry with
one exception: bm_evict_inode() unlinks entries during umount without
holding it. A spinlock stays around the unlink sites to make that
exclusion explicit instead of relying on superblock lifetime rules to
provide it implicitly.

Handler removal semantics are unchanged. An exec that acquired a
reference just before its handler was unregistered already completes
with the removed handler today. The read lock never protected against
that, it only made the window smaller.

With this an exec that matches no binfmt_misc entry no longer writes
to any shared cacheline at all. The fifth patch annotates the
long-standing lockless ->enabled accesses for KCSAN and the three
patches after it make the entry flags proper enums and give struct
binfmt_misc_entry a name that isn't Node.

The remaining patches are a cleanup pass over the whole file: remove
the VERBOSE_STATUS and USE_DEBUG compile-time toggles, convert the
entry file to seq_file, factor out entry matching, entry removal and
the register string field parsing, make the entry/register string
allocation a flexible array member, give the parse_command() results
names, let cleanup.h unwind the entry registration and exec error paths
and prune the include list down to what is used. Aside from
seq_lseek() now bounding seeks on entry files and the ETXTBSY
propagation in the second patch the cleanups have no user-visible
effect.

The last patch adds what the comment in remove_binfmt_handler() had
been suggesting for years: entries can now be removed via unlink(2)
in addition to the -1 write. The status and register control files
refuse removal.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- Allow removing entries via unlink(2).
- Add two stable-marked fixes restoring i_writecount balance for
  MISC_FMT_OPEN_FILE interpreter files, first so they apply to
  mainline directly.
- Turn the entry bit numbers and behavior flags into proper enums and
  rename Node to struct binfmt_misc_entry.
- Add a cleanup pass over the whole file: remove the VERBOSE_STATUS
  and USE_DEBUG toggles, convert the entry file to seq_file, factor
  out entry matching, entry removal and register string parsing, use
  a flexible array member for the register string, name the
  parse_command() results, use cleanup.h for the entry error
  unwinding in registration and exec and prune the include list.
- Link to v1: https://patch.msgid.link/20260708-work-binfmt_misc-locking-v1-0-a009dd5b56db@kernel.org

---
Christian Brauner (23):
      binfmt_misc: restore write access when removing an entry
      binfmt_misc: use exe_file_deny_write_access() for the interpreter clone
      binfmt_misc: convert entry list to an hlist
      binfmt_misc: use RCU for the handler lookup
      binfmt_misc: annotate racy accesses to ->enabled
      binfmt_misc: turn the entry bit numbers into a proper enum
      binfmt_misc: turn the entry behavior flags into an enum
      binfmt_misc: rename Node to struct binfmt_misc_entry
      binfmt_misc: remove the VERBOSE_STATUS toggle
      binfmt_misc: use print_hex_dump_debug() for the register debug output
      binfmt_misc: convert the entry file to seq_file
      binfmt_misc: factor out the entry matching
      binfmt_misc: rename load_binfmt_misc() to current_binfmt_misc()
      binfmt_misc: return errors directly in load_misc_binary()
      binfmt_misc: give the parse_command() results names
      binfmt_misc: factor out the entry removal
      binfmt_misc: simplify check_special_flags()
      binfmt_misc: use a flexible array member for the register string
      binfmt_misc: split the field parsing out of create_entry()
      binfmt_misc: use __free(kfree) in bm_register_write()
      binfmt_misc: assorted small cleanups
      binfmt_misc: include what is used
      binfmt_misc: allow removing entries via unlink(2)

 Documentation/admin-guide/binfmt-misc.rst |   3 +-
 fs/binfmt_misc.c                          | 835 +++++++++++++++---------------
 include/linux/binfmts.h                   |   4 +-
 kernel/user.c                             |   4 +-
 4 files changed, 429 insertions(+), 417 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260708-work-binfmt_misc-locking-15347df12ec8


