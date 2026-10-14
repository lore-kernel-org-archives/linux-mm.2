Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB4BCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 10:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A806B0088; Wed, 14 Oct 2026 06:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5324B6B008A; Wed, 14 Oct 2026 06:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F126B0099; Wed, 14 Oct 2026 06:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2774F6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:01:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3D511202DE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:01:38 +0000 (UTC)
X-FDA: 85320789876.26.CF839B5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf04.hostedemail.com (Postfix) with ESMTP id 970D84000E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:01:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=juTtINBj;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791972096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gq9Me0DpRMB/8hAjXFH9qO/hxN6qlQORSNAboh1nE1Q=;
	b=1le66rN1miD0PiuwJV9jk1LLiV1+UQnZxZjX5EjbNEdqL0v1s12Z7GRHs69Woi9kapy4nu
	rU6/tFzmloufRGm3a2uYyX+9lSmgMzlOhyDHGX7UKu6kFOt6s7lNRcr8cl0UycDvzeO7wN
	1Jjlqm/9z1HjdwMn7Yj9dD6+W2Ys6gQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=juTtINBj;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791972096;
	b=OkAoxSTC19Y14PcW47b3D6aW2pA7GqDlycWERcTO1G7NEmLa3iXWx27QunxpSO/bFtEZ0+
	LYYXM9u8iZl4snb8sv3tk6G3VTrVVp+4mXB2L64RteK2A8dsI36lnvs0k3sR7zY8jbz9RS
	yIzl+5E3QNqdHXIHHc4FKjejUcrK4q8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=gq
	9Me0DpRMB/8hAjXFH9qO/hxN6qlQORSNAboh1nE1Q=; b=juTtINBjinqvFI6EKd
	dt8OA/a8imzLq1g9iBhTpkgSeXT3WQdpHGhAHRXxKEV7WpblCa+VlbvjmDFGmaRZ
	jAfrI6X1gBzSFB8y6IiNsQFvE4d4gW3o9oeqYRwo1XQ9lq2cWPDdw846sVHGvjDq
	Nj6NHM8sifcOHDfKcT0v4GSeM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3_y3vUs9q6psGEw--.34516S2;
	Wed, 14 Oct 2026 18:01:21 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm/memfd_luo: preserve the sealed exec-bit state; reject kernel-private shmem files
Date: Wed, 14 Oct 2026 18:01:11 +0800
Message-ID: <20261014100111.79353-1-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <2vxzmrsgipn2.fsf@kernel.org>
References: <2vxzmrsgipn2.fsf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_y3vUs9q6psGEw--.34516S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUO9N3UUUUU
X-Originating-IP: [2001:250:5828:4461:5d0:1f3:be4d:bdab]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC9RFfJ2rPUvEgDwAA31
X-Stat-Signature: tct65fzxh3ezq8nkaxcyjkhbtizsroeo
X-Rspam-User: 
X-Rspamd-Queue-Id: 970D84000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1791972095-537245
X-HE-Meta: U2FsdGVkX1+ZFJf8CTl5r1EHAepIeOQBKwAPDLuPr48fpxFogU5xaiBhMp9G5In8mIWoUlIFLOA2fL5b7/7ooiCcnHyjpMvKnVWs+kbkf96YoRn0/SbQeJpGiOzPpXR8DiGZer9P2ag6a8h6KQgr50lJAsfJ77pTDnjJ8fpooo+fqDG7qyXHdycZ4jCDm1Bpw6Q7S/Q/wvm1S+3kMjE5Nqkpm0jjuq8nIhtVhdk0OTz772dhWLzLfz5ZVBqamK23jdu6br+KjRjsl4R4LjII3K72rlkM2AzvRB0e884ezG+Po2+9nF35vdJ11G8sNPbn2D1bNo3ohwsC2Mp5EHvinE6Bn+i+UWu6siaGERU+9CaC27FtfySB4eIp7+kofBoyUspcdDJXNvpaUsh2AlctGawOISgUtP6KwglakOkK8ickxmcK54sJfbj32N/tlZ3H2X7FxXdATijIDVgLtFvx3WXTW+Futja6whNCkB77HGoH5b5elO5SLXh9qTQB92HrNWP2n9qyRctDu05L26MWsZh1SgeXZ9V6TeCqtfqplqiMYVeDT32an/2a8Tj10Urjk/TkqoGbwW5qbtfLtsUPYg/dj9o+AoJooYhbV4RbodRInyOWlg0rZS/8I5O/60p+2zuz3p/IP9UZl8AlB+3cYvTlGLPukEfU4EYOw5b9TY1pkecRneXbfy50X0R5s4iboyDlv8VUrTgIoPJYSIkZB1gzuFuXcUAHeyK7fFeBmukZPy3QibCbrpH8l9yJ++ncihtY2IFA5CdpBHcjKBfPdK8ZC3dmhkgQ6Ld9AsgQTAma65P8+jXZ5FuDqZdzG8/KdjQKcw++9Hz+s864YvFgHVlI/YV1c6LuOU/ULqTGz/LNXzamBxNxckXrgqIuW9+XbKJHViKn5nQcNYwVMAXKbtXOQlAWID4V0sbiQa9kXQKZTViI6LKMoRe9dyLI18bDU7uOoeyEhoh4AqunRvx
 ZefNWglP
 /B85rtFHBqMAy1TOfx/R87jRtq+ktKAlUXGXgaQDZmgcn27oWUjKkHj9j+HhXdhFKvuuM/pwhCp2BE8My0r+NmYCUlC/cl52AAazZhgRvUD1Trhub74kTf2eofhk35LYhPD9ayTQ3PqLPy6TCP37yoegfTQyP5h1vQ3QwlyfaY3u1k9MKC1ZKKxuO+k4DXhFgLrFUDKQ//N16AaI2LWHh+xCJ7Xdi8GIPkRCZCxdn87i+UEOfHDl9vrcmgTEQDr2+czDsqk9z5rSQmyfZU1wlLnDucVniUnKyFhEYRgwdwKF/E1Az6b3nMGLqe4QOjS3T5IqHVeME5s5VZYBpOnYirbNLPgCgGD/CVKzz27aSwqIc7w3DYm3I0PFquUTfKJQlrxuuWyPDvsRdKRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

Understood, and sorry for the noise.  The Assisted-by: trailers are
accurate: I used an AI assistant to draft these patches, and the quality
problem is mine -- I did not review the output carefully enough.  I am
withdrawing the series and will not post another revision until I can explain
every line myself and have a much smaller patch with a clear use case.
Please disregard v1-v3.

Thanks for taking the time to say it plainly.

Haolong Wang


