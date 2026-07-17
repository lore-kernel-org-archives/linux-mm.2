Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B5BC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753056B00C1; Fri, 17 Jul 2026 13:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72AC06B00C7; Fri, 17 Jul 2026 13:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667916B00C8; Fri, 17 Jul 2026 13:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6F06B00C1
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:27:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A496B801EF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:33 +0000 (UTC)
X-FDA: 84998950386.29.2FFB86F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C4822140013
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jCAnQTOr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0O48kuedeadPtyYVMr3HodljE4FFFuatXpDbwuYN/VM=;
	b=Brei05gWmqTvTW1IH4R2BZ77UsKEO2Ow87o1Q6DeXk4tR1boPbdzuv2hgDDmKGYQvMaEXM
	N5d51a+ubPbt7wShUBxMdjl0k2nXnDI/I9PPYDB6bz/+Yk6++QHJM9Og0skUtPbuV9hG+7
	ajyPAbK4UOZOHueyGaK7jGZ7GeIfZfU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jCAnQTOr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309251;
	b=uRmwIaWjvftxMCOrySKim2r646wS/TcSAHLOwtHtkLEWv6jnYcNiHyXWh6FHCXOsBFv7QT
	eBD4MQlht67RZwmGONHbvuO430VlZsLVqrvWlG0IvnmHSkHbOdIKLHdV5hGmWMNqIhUBPj
	nvuXyBbbmP9YOnSIZZ9HLcnI5xfwqYQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 102A241735;
	Fri, 17 Jul 2026 17:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BAF1F000E9;
	Fri, 17 Jul 2026 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309250;
	bh=0O48kuedeadPtyYVMr3HodljE4FFFuatXpDbwuYN/VM=;
	h=From:Subject:Date:To:Cc;
	b=jCAnQTOrXc2yVCktE2fgCOUK5EpwHMMV6r+iIgfurcC4h/YjtIDoVFGYgNfEzmcqI
	 5zuiF3d3pzNYXfUsMvPmxTE6FqFAfyjUiAJF623VdMsQCkvvXRRUHnbjEMC+r4pXYS
	 LnbIS/orwSxTC//nhjeWaUo8M+cQKtQLbRVVPRGUKFmkB5e7rMwOAo35uQPeQI/p9L
	 h5Cgy86sO5+1OfgSXLRZltyq5plxJHt+nMOuQ47jXFSOK1WTdPx6181/edxK2ejElu
	 RVzrT+NNzKLZBN2WkwBchnBlNN7vTeuBXjGNb+Mbv6s1T0cVlJKIax/5L0BGwvkq5t
	 jK103XFozxIYw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 0/3] mm/mseal: further cleanups
Date: Fri, 17 Jul 2026 18:27:08 +0100
Message-Id: <20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOxlWmoC/3WNyw6CMBREf4XctTV9GExd+R+ERQsXqCIlvUA0p
 P9ui2uXJzNzZgfC4JDgVuwQcHPk/JRAngpoBjP1yFybGCSXJb+Kkr0Izcg6915nYkIJ03KtdIs
 S0mQOmJJDV9U/ptU+sFmyIzcGR4sPn+NvE7n3R70JxpkyuuTadvwi7P2JYcLx7EMPdYzxC562i
 Jq7AAAA
X-Change-ID: 20260716-mseal-fixups-131ad0939de2
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2058; i=ljs@kernel.org;
 h=from:subject:message-id; bh=5qOAkI5geB9c2QJT+ZJuYGTf9tB6cnyrWqqOZSHtdhY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiUj+EWEUlbP0+1Vg9PzH18/bFZY+WbXnNxBkhb6f58
 DO79xeVjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzEL5Hhf42d+QeFPzfXNzwX
 OCbzav4XhxmzD+ycWPsqN/9ejqfpH0VGhkYvs2ZpxW13aw3bdETFBUOjKhYtZJx8Xd5uo1aE97K
 nzAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: C4822140013
X-Stat-Signature: 5wqhzmu76g35q4grwh698if6n3c9o4om
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784309251-397894
X-HE-Meta: U2FsdGVkX1/SDgvH/eBef5AcwNkSHodi7NfkW9Zl8+pqljDxpVItcWCquUTjaow/DJOotrT48rb61Dq5+/w9Cs+GZ7uLaYZJ+Y1qKToXBe6eSDZ/kHYuTohhhfRdnRZvOGtHXi+iwrHRXQKbRhN/tLMQx4LPFev/KK+3zgLcidT3cQ1596C00GSnzooCSrSE3OVQWhB/M29Wr+FPfcFujOE89PuCNnAr1jB2yXJ0haLXLf2N3d4gt1elT/0RyyYvpEx+REVf4CfLmXgjEfwjnNOfpAIkmXmXGwJzgg3Xdr7AsU7rpiKYSJ496c2g9P/q+fs3SoZ17wMPiO/xAG20B6aQqIws7Y4Ba95bvazqnXhKFQ32gfELxyTz14OqRSuIqdUf4or4HT6+Vo2NU2mU2h3X5NuQj+6QyA2EGaDamvd27nTf0iwn4JvZg/v3Y+nkSu318kMmAWNDE1UPTKeLY1phiYjpv8VdOKw4P2/Lc7cKiIxvEmlYWW9740TRwZWik7ZE6ZvQWxtLftqhLnii7OD2w4fw1Y4Z0qh+Fo4covf1QZ5e0+f+pJ/+betm5KCerPphlraI/QPxnnvt22D/LSeqaQyI1zNg6TF+CGp3QoFxN1Rr96O9UOgk4yXr289PgQyMRYqUgrNtCORqGrIJhWr6EqF+ahSUSoLMmx4/tzGv34YvjBqxf4cKxncTKOPVf3kCHIjflzEqU4+aEsFaK6wd5njGQKVtxQYUPXIEQxfvkRC+Wabgg/MY4/8fGZocMg+LUAK2ExZ7nIFyJ20uZzDBNJ2zTOtun5ZNvDcyQAqE7dpw1wfkc3LDNRYeC4OGNSOBt1l5U8O4j7CvTdnkzsdrJuIXG5Ax8/xHXXI21B0MRVSqEYsJJp6ZfTYZ2VgQY4pkgqQChNd2FYkja1qREluMHomSUsAt1oLW4FebbM93tjEmMQlBST5QN8H5QojrufsoGcHreEIUzN193T9
 Fktu4dQn
 Yj13HoJe5d7oWPlAAY/vqipiv+xPEoQ7MEaBeXByUIWNxW4IW41JxsM5lOCeN7nsfGwkGRcqrx9xfBh0lCKowGwca3ur3E1l2Sjj5KTh+VhKrjQm20aYj9O92dJIqH864z1ogiNTUQ77MlWKZtLdftmvz2V+Uw4u/fFE0kQjmaEe3iCpfQd/NHBxafMFPX2Oit2+9AISSULcgZLwR0JSx2YY6wDl11Pb6RDfnBXk3cTMLxInnn5TD/OusVdWnyCYCZFh5Pq4svssFmkOG9zLBtmeibTxbSgZK8BB/k3X0yVZ8zIa6snYJg5LGAXXZAEi9YB4fg/5+BUG+/oOkuZDKePsT0QGQiRgBPbsRpeXL2/7j1nfXDSj1089RsaoGQv9ITTtC/7SDKeIeme4DT90UqugfiFcFPxZzkSUuaru1IFdkXforr+q/ZQKG2HLpNumQtrfM2nko9yjcqQKy/fny/DWeh6jwX81dwLWaHkIJWhCu0EVN+lOUgWN7vVKevRrAi1LH7SkrPGCo1eC7QACJX3KiKR4iu1wqZ003Xr+bv6JyJS9AQBO9OQucPH3qE6PIRRt9OunrE1ApZBXaJlLwTtiy7v1x7oFJUaX6iXpoc/9nF+65TqV1PLoLQJp4s8SmAvmh2znYXjtVJSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mseal implementation is still rather confusing, so tighten things up a
little.

The only user of do_mseal() outside of the system call is the MMAP_PAGE_ZERO
process personality - retain better control over how mseal is utilised by
providing mseal_mmap_page_zero() for this instead.

The comments are overly long and confusion, so cut them down so they're a lot
clearer.

Remove confusing mm_struct params (mseal can not be used on remote mm's) and
wrap the actual system call logic into the system call declaration.

---
v2:
* Added tags (thanks everyone!)
* Abstracted mm as per David.
* Renamed [__]mseal() to [__]mseal_range() as per Pedro.
* Moved to reverse xmas tree declarations.
* Tweaked commit message for 2/3.

v1:
https://patch.msgid.link/20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Jann Horn <jannh@google.com>
To: Pedro Falcato <pfalcato@suse.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Kees Cook <kees@kernel.org>
To: David Hildenbrand <david@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
Cc: ljs@kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

---
Lorenzo Stoakes (ARM) (3):
      mm/mseal: remove superfluous comments, fix confusion around mm
      mm/mseal: limit scope of mseal address zero to address zero
      mm/mseal: remove further superfluous comments, do_mseal()

 fs/binfmt_elf.c    |   7 +--
 include/linux/mm.h |   8 +--
 mm/mseal.c         | 160 ++++++++++++++++++-----------------------------------
 3 files changed, 58 insertions(+), 117 deletions(-)
---
base-commit: 59c684a9908d2e6f7a791f7f033eae57ec2b3a61
change-id: 20260716-mseal-fixups-131ad0939de2

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


