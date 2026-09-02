Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4423C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 01:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B35E46B0092; Tue,  1 Sep 2026 21:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6E16B0095; Tue,  1 Sep 2026 21:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC546B0096; Tue,  1 Sep 2026 21:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D05B6B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:15:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E58691A0601
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:15:01 +0000 (UTC)
X-FDA: 85167053202.22.7F98119
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 62129100008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:15:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ab1Cvvp5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788311700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWD6z9u9UnNJ/yqZUYiAG+61P0xgSe+8m+TyxTenT4s=;
	b=xk12GodsSETc6ZfggNwgeHZCRQ8bafo1M9+32rDygKWPxNva5kEQYJhxLlRI3v39FKLOF1
	oiOhPyQIef94rq78I8hwv1txpi8wk7ZubLNckSweUSZNWRB7cI+4MSGPNEcqzysViT4kW2
	nEXuP0wNP8wsEWh3N2VYKNWG53CjDLw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ab1Cvvp5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788311700;
	b=T7kNcsWo3piQfCsbTAhLjEtwJuE9VVwmMhzRpaKbujOEZK5d85tWhha8dNJe3g1oOchNvX
	QgBwxm/ScVvo2Hpd3bAyuAzEohR6CjwqOF9BGeS+Bhnhkm2rMs/Y1YZBXYRo87D7y0ZCvI
	0EoMW7VqBvgjnbekvfs4U2Va0BhOtBo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC568600C8;
	Wed,  2 Sep 2026 01:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7A61F000E9;
	Wed,  2 Sep 2026 01:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788311699;
	bh=LWD6z9u9UnNJ/yqZUYiAG+61P0xgSe+8m+TyxTenT4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ab1Cvvp5MF4/ezK285KCgyRKwOFbw7GLHbssjuC85Dql3pcnlpJulqyflGciaKKpK
	 WdHhNvkd3BkE7WTon0fTl9xO573xJghgsVsnwjW7/fKVpUtgpcF0KJ3rH2NK/wS3ta
	 zVdibKigyuPtTVRbQXMNBj5UCIISCEnWXiq85OiiGH3zFmYY3JdOXMQQeP5pQcwwOv
	 2jsz4UfgpmzsVIOwMwMZKQK6y29/XEEzLTNd5fgvBnm6J4hfRIUKi4PwcmpSuu2OCf
	 kgaUeOyNtEKRaupOxHSFZae5GntiV69+ukzZh5RoXg72Zcpe+Fbe+YzOfsE2uNmu4F
	 eryo72PTIIqeQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
Date: Tue,  1 Sep 2026 18:14:51 -0700
Message-ID: <20260902011452.110186-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902002725.108635-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62129100008
X-Stat-Signature: dhom6crczxypj86bptzypo7rwknik8ud
X-Rspam-User: 
X-HE-Tag: 1788311700-201088
X-HE-Meta: U2FsdGVkX1/ly9Q47TbCt54/0Q5X74sVIoNQX5Z3oSK3nnMD2OUOzQ0fg8tUmHZULO2M5/K6Mqr4MK1MUGsxU0wnYxzti+naMFP3sm74eJLX9yoKw677DROyrr+yo8CE+W9SYXOKv/8PmQWI8mX1LGKTiw8wbsu91yTWs2+pBD5vgBEBwNTVvT1Gk34YLRU3C7EZzhq5Ngi+s4Cya435kEnsLR2NDnnqRr9soeoLF3leD4MaEMaDdk8R6ESJcB3vXrn5rEHxPccoVYvooN91eko5gd83yNEHrtpuKiVIWdiaS/PR1Swsdzhi2gWlDj0wSz8DMmetaLdcmSBmVOAAlBAvU/jt6SCBZbVK8r3+MSVwuyPZnJ04j4uKePB8MsygdC0LJnUkaeF0naYXlbz2n26fszYNktNjCXQYlE6LA3yrRnb4IdCpsv7L0rgrCHB5hv5w0QLPvCmMhnOPIZW/5O37sO+VkLIoKzYH9v94tNFycPEuB5KKXVFJJ3nc6OBSnFhX61IbrXqtGr0uBN6vrnydfKGGnmuS9Ti76mj7cAwicPmlNbX+3zCTfolNvQ1IN5VYbWQ8+dnWt+Y6ytVh8SddZl2C6YihKVPM37DIu2YTwEU8HcnP+JetFSUj4KcaNaoi3TPhidfbaVyZ+zZzzVTKgBHcQfsz7SQGOH988vdIGF75CEKHGiL5R797YpMhfQ4UpU5kwWzrOOG8qU5QM9XMdLpBo++6Q9zzO4I0g2TmA0lxPU1+joMZlpwLOuwZWE/HFGyuwYY8z8FxcTHA3N9NRkGGd7X0BpMvCveYEPCo20+v4d3sprCij6WGyXRC1R/H9HVgDTBehzPWPgUe7Zb7Lh8qpmyC3GrjGcdWdXioL9kLBA+ntNpgt+8gG8GyBsFVj1m8M1HfZFKadlB1eogEGvBCP12Ek7fXDENzEgUtrYNZ+BXxwiqDNgAdB7cjsV+Q4GCVPFxH0jWZjjp
 2LF77qnr
 bCHiDg7oSQRyp4/8BavprAtEdIt3Or/r2MRFdf0LfnLGg2sttK1d1aZ728M51TvL1WoGaGD3Ms1vuguUu54fYFR74bsScyFKaVJN6qfIq10Rd6e8vR64knTkcoBzbUKEvsQ5cFrboeAUheHEf9tbfdYviwIglngZzhKNwJXn1O4wdKmtfx9G+Jf/tlS0w52xPof18I4y1hMXLiGBWYP3hGb8M48zz4/dBp3DTvTDe2iMQszneu8Bs/REsDwiBTsgic5H/KLQdptXCKwE/p89LE5TTsAit2LMJiSG2kpooEcpGcMtf5RrL3dgRP2RYqaQcGyhMVcWEezgxX7lV8rMA1jll+e3S7J9zkVND
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 17:27:22 -0700 SJ Park <sj@kernel.org> wrote:

> damos_commit_quota_goal_union() is not updating the ->nid union field
> when the goal metric is DAMOS_QUITA_NODE_ELIGIBLE_MEM_BP.  Hence, if a

Sashiko found the above typo.  It needs 's/QUITA/QUOTA/'.  Andrew, could you
please do that when you pick this patch?  Please feel free to let me know if
you prefer repositing.


Thanks,
SJ

[...]

