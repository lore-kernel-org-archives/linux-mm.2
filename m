Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22565CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FDE66B00A4; Thu, 18 Jun 2026 11:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB8B6B00A5; Thu, 18 Jun 2026 11:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2DBD6B00A6; Thu, 18 Jun 2026 11:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2A246B00A4
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D058AC05CC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:42 +0000 (UTC)
X-FDA: 84893382924.23.5A7D196
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 15B8014001A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtBlK5Ul;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795741;
	b=ICZmYtnecVuYUiSxaCChBUFScQyVugZMD14SSep98MtS15v+epE1nN9gdVJpWjqG8msKBI
	49L50KY/dsiHrUmZGkLudwPETTNkvZDhxyEe024XhAon8/4UUwrYHDDZjBy+9YTln1pbW3
	jzdSp2skSBAPLdOW3nApthkLRlkzOeM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtBlK5Ul;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V69jCi4XbNmje4yP60Dxbb/L0C+xnieK6ht4H1cDOOM=;
	b=jAR/vb+SyWXwvAbqRGa0foZ5/Hx61t3qB3tPcLlRg20BNp/hM+j3boy26ZqDrIcpqObrF8
	7LISTpgdbMxUD71+MmJWUmKWkXTX/pBE2PDQQQiUVuobuexy358sZm+A6rSZu/oXoqJvOm
	XagcSUHBQLZgIZHjqTgkl86zJVNcoPY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 906F260018;
	Thu, 18 Jun 2026 15:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6721E1F00A3D;
	Thu, 18 Jun 2026 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795740;
	bh=V69jCi4XbNmje4yP60Dxbb/L0C+xnieK6ht4H1cDOOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtBlK5UlYM+SlpNN867/Monyhyen594lyXZabNRLbD4qIcEjkrmiDY9mj3P6IR8mi
	 Merybil4YFBr0m5oyTSItZ+DvBQj+nT5zlmbh+UdQd4o524niI44FZNG4gpfGV2m0u
	 zi4Lu8ScLC1Um1ir/ntVYPNcINLUNx9Z0lSQXLrWCvyCQxRwYNXKJahTvIG5YOU46z
	 tZm11K7AIxfWIqY2hWxHFsra/7aLoqWW9VYY7j5FA42Vys1vEZPtu8jWlveDC1+jNE
	 9SUPtPWpNuebO4M18SUcuBoXT2XTt8a3LQxu4LptORW4s6qNsAi30WdW9LMZXjWiio
	 w1MmmArWERyfA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 10/11] mm/damon/sysfs: kobject_del() probe dirs in probes_addd_dir error path
Date: Thu, 18 Jun 2026 08:15:14 -0700
Message-ID: <20260618151517.5366-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15B8014001A
X-Stat-Signature: uokociy5pahayq467a48j9z134h66fa8
X-HE-Tag: 1781795740-322519
X-HE-Meta: U2FsdGVkX1/DOEqVbfMLnMF/t5eXg8NQ3mH0A/jqvCnnCV9tKYYIcvKSZ1YLDvlU2Te95h4P68EQg45VM23zzj4M4wwT3Jr3VZ+twuvNFdpqZpXJ3hHtj5ZhMBcnEHzsLp86Iy6mvztWC1xUQapODTiYzCRiyTiKTYuvBGJA0bV3gNyITiZ6WkCFZ6c+y3KhnJGcSvC6man8/4chKYV1iBlRIDgF7GVn78BkbqrTAn1RHHJ5yO2O5Eip0FISqqzgdosA+qqrVG8KszNGSZABVVxK6Hj2hp2b5CGgg3EXgzVjtiylAVCWBzQMglJdJb/omDIuBJpRG17SFIg/lgW+8evnyNLRg0fFdN688GBwrSK+dPGjYcrXUVr9Kchn2b8Y69CUibnO3J2cP1Q7NY0xUdWCHtRuK0Gl+IQOJDvFP6ZNybosQ8Un5QivlnBOpM4ISeGqMqySEZkxsxrVMVUqz/i3gAZYeLf9w9AiezPJF56fuko0ZGB1yDWR4rFAbL4AElUkDh/pxofJBiomJMGe/SjkVU3IaAcKbyiJSeTd8LTF4LCD2OWRiJgUYP8OomheJtz+RsbAcGPljf/WN8CrGiAX7BiHwDh1MFYs4VQDY+VU2eodAGxw09EWqZxXI5WCWd4Jl/qYqoHoQ7+4rqx6KiQQMI6KrRrW0XbtVXC7Nw3SGkZ5gbUNOe0zeMZttlSBcFpRXIBZTzx7cGZ+Prn/v2ScpLOryqzbE1VLk9lgajxJ6qLKiom+/KsPb1Mn40awV8/v/AfgQ6kxVqhziW7lHO7BSKZL9qDpYFV8Ovt2a9gf9A+go+jDRMRInIBvkdet7XPIkp3kXSk8okUY/GD3aRgpHP3VG8+7Enqb1pORXBQf9if2M9gy9t60NhcRM+K59ExWNda7nsDrz4iKuNBGAiqQ1mat89wlKF6TPfQ46aAdWzqDh0il1h0F3nbYFwFUfOiO1fFsgcqUUp4ZTFc
 NYgEKd6K
 /X88PJV668oAjX0KzE0emLDPd+6YSOZedqddtYqGzJ+f2IoH+ZOBcguZUU8Hz908Hv9UV9BZJZDZu17/q5ggNToKKeP82emQme24KGw6+lPpshqwml+XsFBIGnHEcHQ9D11sqzro9CNGm/sNkQ065IWLb0E3P3RaBZ9nhQmrodEmhnQQLerl9FSzqira+Xmbv+/xHOvn7SMfa+qN+Qvms2ojX52uPOzTh9ka5pGb8+iZjNcavuxbSvAS5k7KvwnHOpN4P6/0KBXPVCKv8WlbAJ9yu2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.
Fix the issue for data attribute probe filter directories in the error
handling path of damon_sysfs_probes_add_dirs() by adding a kobject_del()
call.

Fixes: af7cb41af9a9 ("mm/damon/sysfs: implement filters directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 36a0e82601697..ffbc99411f53b 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1183,6 +1183,7 @@ static int damon_sysfs_probes_add_dirs(
 
 		err = damon_sysfs_probe_add_dirs(probe);
 		if (err) {
+			kobject_del(&probe->kobj);
 			kobject_put(&probe->kobj);
 			damon_sysfs_probes_rm_dirs(probes);
 			return err;
-- 
2.47.3

