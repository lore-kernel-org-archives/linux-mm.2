Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A770C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E366B0088; Wed, 26 Aug 2026 11:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEDE6B008A; Wed, 26 Aug 2026 11:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314CE6B008C; Wed, 26 Aug 2026 11:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE266B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:56:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8095280174
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:56:01 +0000 (UTC)
X-FDA: 85143871722.18.BE6D8C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF5E64000F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:55:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UB7f7OhW;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787759759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BwOwlrsMKFa+viIlDHPfEgFRdNQZleimxjv4DOddYv8=;
	b=c4mG5v8X+8ExFoUZhGk7ERcLjAOppOov4Dr8GPBXE2MRWO5tvRSjetdNDKWXFe04XHheA2
	R6P18FkrzX8YXRcLqu5SQiRecTLMpeBHdVwAfHrEWpfw9Qb1EoLyJ+nPbhtE0adCJAFIyb
	G6Iw/5e52Lo1Nmby4IKF2TQudwdAxsw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UB7f7OhW;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787759759;
	b=ROfC+xdihtIC5DoosVoXpT9VQONG/9pXIPb8DW8mHQxPmFIUXj+k87niFLay5/bCTWb2w0
	ekkY6pdGyEAz9aTWJhgKxHO4oLqxAKHEmW9FAOmTcVat0JiSvAw2qWVaYQfPRRHBTimh7M
	0mWho4cIOkC+77PAzzNX28qPbCbqINc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5600600C4;
	Wed, 26 Aug 2026 15:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD141F00A3E;
	Wed, 26 Aug 2026 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787759758;
	bh=BwOwlrsMKFa+viIlDHPfEgFRdNQZleimxjv4DOddYv8=;
	h=From:Subject:Date:To:Cc;
	b=UB7f7OhWq1DxpKTgfVroj21MHn7Asx3BUizcAKwgMLDZI89Ej0SK4pvtDO+QrYvBq
	 LUpuQp7ZGpyjzVXCp2OVa4TTmYXwP6+QGEBMkRdWcUT3UUviOFeQ++kU8MwDuj+MpU
	 xk4iMSPnBlscuNkNry6+AtEEAL/JBFT2ENYY7sk5LnTXPOSdCKMwBGZT4iqhscLdbw
	 qMcnDIXZpulbTFQIbJ9XMIp5nDa3BEvWTFh/NOoyR5Mf13Amwb0ymTEm/XQYAQeItP
	 3DeakQqDplWN6tcYhTP36A3jhIKTIcU2rhwSrs2lSPslf0aIiSHgh0Fec8e1aXhmDe
	 4s9bQvFqRFFwA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/3] binfmt_misc: only let punctuation delimit a register
 string
Date: Wed, 26 Aug 2026 17:55:45 +0200
Message-Id: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/03M0QrCMAyF4VcZuTal62AMX0VE2i51UddJs6kw9
 u6288bLP5x8KwglJoFjtUKiFwtPMUd9qMAPNl4Juc8NRptWd7XG95Tu6DiGcb6MLB57evCIXRN
 a450PZBrIz89EgT87fDr/WhZ3Iz8XrSycFUKXbPRDORVX/blqd1VZwbZ9AfjKkpGoAAAA
X-Change-ID: 20260810-work-binfmt_misc-delim-83f62cbcfe23
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1243; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Phb72AoqbVHIC31C23WEo20gDWkMp0/dpMPIljHQDwM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT183Qz3+6pPNDT/i0r7sXcF57JC4O2usbrec2s+HdOz
 8dlQt3CjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlYX2dkeOHV7qt0W9bnfazv
 rh2nMjKV76gViE2MzLH3cK+6+Uarn5Fh8caLLOWfL3MtXaPKqF/f/TL7zOnJO8WnL8v9wHniVuw
 EDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: n16xaduegoes87q3uowk7po7mraik9wo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF5E64000F
X-Rspam-User: 
X-HE-Tag: 1787759759-818983
X-HE-Meta: U2FsdGVkX1+R8K/XhDGoN+wH+8SOg1urXUiCJO1YNHGo5BI19bKnaUPFxUGRqTl+Aml3kE4yQXVSXPXT6QI7CBGsxSgBTLFH+AyFsfysUrCzrdtM1ToiHZohDKnHgud/PbJTL+KG/65yWhflSMm9uPERraCet47hQm0Er9b+yH2dK2Cb/cp7hDPlmx6eTqaUeQBUBOMj6g7GUDkREAxiArQlhR8Mrf5+/SNulged0Kt86MqKsqbvosdla1cioKKJB+rFHiWrx/C53Z5UtX+ktHIAjNak017/ZRCQ96hvkFuQ74xtQVjTsyKyZysCesR8Bf8AjPhWkhlOEao95QQDWKUsNNUAb/+oe+f+WOQby12ufCbk77hn+bmzBqBZUU/bIV5ncdtZNq9k5NajUVqQBngyF491U6rn/J3VCOxGi7AMuZsmSQJgVtkUr5SDEeUEx31HBx98bkoleaicmAVFY680MWxOyCwFHFhdsQ6Fyb47z9yYVP2xDz9hMhQdVeWHlmfpk67sx4jTAaRbLZXhq7VLVTMgMmcl10bihgoIiDfmuwJLrkoEHIyZR1mMvYeuQMp1QKAHYUMuuUFdvCIYJajiPp3sWPkIP1qESrs5qzcsj3IoNiqiRgvz55HfJAVs5LJMykDHVeh6Pzw5KMf2I7dxnTeWqAOtAlwQJRU1wJPtiRYnQDcg8T529OdGJi2Dccoueh9LP3NbpfAirzQzZYHDdpAi8usyAFDi/EElhmwUmnrnwl83qh8V20YuIqOmo36JHNlrw5v+Awo3LM69YWwSD3TQPnygYfwBNYamE+jFvnTefPjcF/kqHK/LQpU0AmiP2coAF7Aew1b/x/S9PdQF1DvWmWDqgUE2b4NmYYbEWi7Cs0fKychsszygMxJyAWFuO8x4RaYSb4bNKMjw+wvDaC/4kGDpiVVu2GyjoGUmZHoXWYVAdcEwKxkLkwLTWI+gPp8JQqhl7s8l7YV
 2jqEarJN
 eD8bAlMJVpbMR7EYwaM3vrLeg8nBGhAsMcD6GtxwstMC18rGurmk/5Ceis2DK+UztXXI+3kTt0cO1TfK9g3FHM6Meic29MozyF1ygGAZZkfd1wbViURJ8a1pkmktP4DkyQebalEvtgw0SXPBETvragnGPsJoNnM5y424eAbhzEs7zuO8y9/K4M0vEuQQCtAzekYUQ3Oghhdg5rdyyKFa4iWkeyqWFiCN5AqfBdlODSoDokbs367SWnHLz/maUBIlJLDhpWiIpZ7b/f81WF/dYgqOBzI8SjhQiIaMZs+G2883CJBnIHap66la2I4qdmfiSEAxHsp5yhmSmnQHn+cQVaEPPXdp2AlA11NT8/GaPwLJZCMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we accept arbitrary delimiters which really makes no sense and
from looking around it's an unused feature. Everytime we add a flag the
number of possible delimiter shrinks and it makes extensions much more
hazardous than they need to be. Stop it and only accept punctional as
delimiters.

This extends commit 8e85d50ba111 ("binfmt_misc: reject a flag character
as the field delimiter").

Letters, digits, whitespace, control characters, bytes above 0x7f and
the backslash now get -EINVAL. Everything deployed uses ':' anyway.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (3):
      binfmt_misc: only let punctuation delimit a register string
      selftests/exec: test delimiter restrictions
      binfmt_misc: document the field delimiter

 Documentation/admin-guide/binfmt-misc.rst        |   3 +
 fs/binfmt_misc.c                                 |  12 ++-
 tools/testing/selftests/exec/Makefile            |   4 +
 tools/testing/selftests/exec/binfmt_misc_delim.c | 127 +++++++++++++++++++++++
 4 files changed, 143 insertions(+), 3 deletions(-)
---
base-commit: 66498c75b4f8017f62d720d9b59675bdf3abce91
change-id: 20260810-work-binfmt_misc-delim-83f62cbcfe23


