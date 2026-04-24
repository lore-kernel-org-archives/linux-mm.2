Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B82FE51FD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 10:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234B56B0005; Fri, 24 Apr 2026 06:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4EB6B008A; Fri, 24 Apr 2026 06:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FAD46B008C; Fri, 24 Apr 2026 06:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF5126B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:05:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C89B12080B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:05:09 +0000 (UTC)
X-FDA: 84693016338.25.02F628F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B2CE81C0017
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:05:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cd14Qaa9;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777025107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4uXld3+xpwlxKZU4t8S+MXIQEikoQhpqpO+PZpbyIJg=;
	b=Ofr4BZXdtM7ibaQijj90umbtgOCTV9SwUdBwpdjMqVTh9tG9SSX4H98N2Okll10nGrc+Cr
	vMb0vtA8hpp3oja2PtMQfQ+LsdIDzzfPA0WyGdMPgfOkqTAqCyJ0ccVvthVIssUTIfdmlu
	5j0J/t3FzYT2et6PRDCP5HTwPuz9pkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777025107; a=rsa-sha256;
	cv=none;
	b=6ASkmrbE6czi4F29UFQuH9CO8t/jxXQl7D+9P49N4VXhIX1ixYU7uJQ75BX1pNFa3kxNFs
	zA1qp71Xo7kjc0hWWfgg66u/OSLHiu3MMfAPBhe18S+e8KPfnrLosqSLkIoawTdQqeRrPh
	GBO2/9rxxlHNjFIizUMV+BIiqjC2psg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cd14Qaa9;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D75243C39;
	Fri, 24 Apr 2026 10:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD69C19425;
	Fri, 24 Apr 2026 10:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777025106;
	bh=TqZB9kXYbfSmnAILwRwd78ABr9axtOH8jmUfPVQcbJM=;
	h=Date:From:Subject:To:Cc:From;
	b=cd14Qaa9Tkr3cQjUlHOnyDzB36KDDpHFUo+9l1UbzXSddtb/ZrjbLMBNLh4Zt1z82
	 bxaZ7tWR2t4GMfS5rq8eZV6kyD1n44ZwfmHupYJZvcPR1FkqzMsJKTDhKSkBZvypsQ
	 Ym4Wp/0vTHV0K89PcbqARkux194F4b1JOKvjcg1C0Tu6sHK6ei0twUoBqX/1y9LuAH
	 JwNSpUu1N6zfQbEFqKkVUCA06sdAH7H+dI1xQNYOkhuoah2aLS4zd8Z7YFsSzLDJ3v
	 qzyYsGH+X+86oVXfmU4kqDbhL/gweHLDGqxDlXr1IYkjWqqUgu9twxk5oh/Bd2WX8A
	 FVdbTNVqPNn3A==
Message-ID: <2123729b-578c-4f47-a33d-d1706dfd2712@kernel.org>
Date: Fri, 24 Apr 2026 12:05:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab hotfix for 7.1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8tfmttpgafxmpkkn3e999mykncfntij4
X-Rspam-User: 
X-Rspamd-Queue-Id: B2CE81C0017
X-Rspamd-Server: rspam05
X-HE-Tag: 1777025107-428797
X-HE-Meta: U2FsdGVkX1+ErivLBDqKRZzcxYrmd4sxg4myoqObAoM1yO6OEICJpPcm0BF8fK0hwZHmA1MrnZX2dCnjHSSt1o/pFUMe4T0o0X+qO3FMJBNgIcceMTJ7ngbLVWWBpQX4fhLq0FlzeuDmEV3c2h7ZJv4335ctysVsia+NZoSK2ZqjOTw2tCWqS6HY9tq0cvE7BeDXdi4bDqzbVPl7JMKBj6VfILc7MR6YrIaWBpNvaAwAfiCYSPkHzDvDE1WBKWIeeU/3Yb1hysCflE6ZqJbnpJvTpJb00iXFk6wN3nf4iHXZaLSuuF3AXOFZwDLzpN+aJ5trOg5cVIbpPaSHN0SVdvlw9zG5VLEFntFZDdmtaI10dGRSFS57qEjKwJ/jN2MoBFuYPLCikCw4he9+1CozIZQDfskXc6+lF97abdhvCfmNFcI1N6prfl2yNdu+D8dmWmjGRkYIWF1Un9Wk8ZCXJ1jNhSqZqjEjOmf1vVpn7vYkXPNgPodNT/DfmA9NzncXex7Fm8sz5+5ZHoLEYdQCAeNRvY123WcUXzYjqibOOeJiA0C5CZKK7MYGPDfRRRy52Pet/QFRs8MNMTZntrI6E6Ahv9Vf77xsbf0idJnWVTZbJKRGHQOzS11w+zVHvHIdsSWC80VxmX23yEg5Dod+k/7JunLcQxc/ktMJkyUW4Lxo+eOCUE2x/dC6tHr2DB1KRF/n6oOcZECExNTSA0NrbLOC294w0FD0yafr7mA7BmmmO96iy5aTVNZ9jcdBDPOg0S0kQjF4k52gI450ITI7TRERFpe6Y8DBu5w+VWrsW2xS4FH/zIYNl9YRR/uAZmaJoIgBHP7yHmr5WuLEKcsxWNn8PqTRhBpmW0TTou1oOwbUFokTpnG/zGiT/4ayp88r3LbZzmpyymuk+4AKxeeCJdIMfbagO2XeEczNZgIQ3/dsOO2iB09o+1oeTINntJ1PdVqk3JOvgFCYl6gP7H8
 loNgDIK6
 EdsA5YzeFEbjNoVhQEvnSoV0XwmHXQ7C/Je3GE0w8vvIYRJ3pJiCuLEtPkCQJwnhBaJ/dJHla2vBSL4Ddv9QL3b3Ar+jBWJCmbhYKmrQvbXxpCyinr+Dj7NmeNwaS27QiyA58T33/8uf/UIPVFPkeLbl/jzMJf2VqPY3uMPAGyPR4np+TSsiNpkgzPlJm5+Ns7YYHS35vccp7gTjDYvk+miz7W0nrAzXXXTlOaQk42ezq4HIDCMMJ+HcD2UF0NH1weP9sImMWKYuNjGWDr5vSu9NOOClaBtHL6BkSYNKguDvPPNd4dbKsojnzav+RqNTRqEyW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab hotfix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc3

Thanks,
Vlastimil

======================================

- A stable fix for k(v)ealloc() where reallocating on a different node
  or shrinking the object can result in either losing the original data
  or a buffer overflow. (Marco Elver)

----------------------------------------------------------------
The following changes since commit 43cfbdda5af60ffc6272a7b8c5c37d1d0a181ca9:

  Merge tag 'for-linus-iommufd' of git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd (2026-04-16 21:21:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-fix

for you to fetch changes up to 082a6d03a2d685a83a332666b500ad3966349588:

  slub: fix data loss and overflow in krealloc() (2026-04-17 11:07:48 +0200)

----------------------------------------------------------------
slab fix for 7.1

----------------------------------------------------------------
Marco Elver (1):
      slub: fix data loss and overflow in krealloc()

 mm/slub.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

