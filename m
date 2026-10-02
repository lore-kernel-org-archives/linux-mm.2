Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52BB4CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F04B6B0088; Fri,  2 Oct 2026 14:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1C36B008A; Fri,  2 Oct 2026 14:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7FB6B008C; Fri,  2 Oct 2026 14:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 100656B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:35:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83F9F1C3980
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:35:43 +0000 (UTC)
X-FDA: 85278539766.05.4BB9734
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E6E6040007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:35:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kOeG2eVp;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790966142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/73x+EUPq2/HdZrJ6Lz27wuBjrhpYd0dV9SEtLAZus=;
	b=n33vr7UVIpjmjgA/Z74FeGPE4M2MaKGh7Xyfeq1KL/VBqwvyNjSetY0glF14qfoVXWnoRf
	nBcgiHo5a1aDLZXgnE3ES5OFo8K9QsK0B9CIFYxYmtRoKH0aYExIg32X1bObQhR6xm8iu1
	yqFKEqWkhmsr1qq76QoA2nzMDuH0CkE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kOeG2eVp;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790966142;
	b=Uhu4uNG2tmCbHsOIkUN4NfYI/BychfmAWpO3Rsj9KfTKlWe4nQEdfwvPymixNs13LTcDvZ
	5AJgfbGJpdzEs3ABPB/2cvTrPvGXeYRBenWgRjtesCJn9skcBMdfqVvjdhxwrqidE4uq71
	fg46SLCyc3bwBkQIUgLBwJKED3apV0c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C6B841A4D;
	Fri,  2 Oct 2026 18:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3CB1F000FF;
	Fri,  2 Oct 2026 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790966140;
	bh=y/73x+EUPq2/HdZrJ6Lz27wuBjrhpYd0dV9SEtLAZus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOeG2eVpBFHsUIv7KDpSzOE7nii7Mm5THSEB+kjNbQ3NYJTZNClUlivpuGxPZrqiL
	 GDTDhortd6U0AmP945zLP4kZ2awqwtpv0cDYTdju2ljnYtk8YJGYOMAp6Pu79TaCrw
	 RYnjXNlqjCv2YCCB6psPkz+YfPWJnKLcp2tXouHpwfB5BdaSarY7TZRm+VFVOE3bqS
	 kXDBgx7NCCBQAbLQjZ9m81sxktKE5GKNqgLjcnRuR7XUhREHSl3hhdEUWs+qz/6Dov
	 bIlGOAwwLWepRNsVoBqwpzV+nzDa9X3U8rVFsgeD3iARu2VzOagJwss1ax3gG1I3vU
	 kIdq2XcvuX3zQ==
From: SJ Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 1/3] mm/memory: remove unused vmf_insert_mixed_mkwrite()
Date: Fri,  2 Oct 2026 11:35:34 -0700
Message-ID: <20261002183535.40773-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261002160535.661399-2-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E6E6040007
X-Stat-Signature: ignrru5io3ac7jdf73775nzbh1d9kxai
X-HE-Tag: 1790966141-304196
X-HE-Meta: U2FsdGVkX19xwwPPbiUNYUGi/kZyRqVmsLsd36l7iZn4nCSStMU6dppK88dxjaxPJ1/IRnC/jkbWEnkxTJQ6iLc0FKE/lGILhDm1zzaGRJEfLuBOKUgMMEA0blHZ4L0y/5RG3moayKv1JfjfbQVOz6YfldaMXz7aSkX92EYgOcDH9Tk5S+EtQ24BClgxLLUR96Lmc+Af36da3O9rG+hOqamumPPHMXlncFrEz1imeGbAPvWGqikHhmz9ETJlb8YAsiuh4aQLCho/zPHlLhT3rYMQ8mK8h32SbmeFVA35po1vHf5qjcEJAgwJe3UdjjOMQnIyG/J0ai2YLETRh99ILUxh3VNIehDD43V0Xaga14xw98OxutcHmFMHBQCVvA1DfD3pV8qPv8jv/KDBgcWM+lROhzPMpz7y9ancrzXlMBf0LtS+5EDm9iEFJQ0aXR4I6PjoYrNAW4OMx28ECmb2qBKRi3kNkVUw+F/7fUuZ6/rHa97XzuV7ePU4Fg2WhrKkzg4N9+KPzSRpUO2mz+x4yT+Udpikw+JhLOqcIEwaqfrloM0sHAoD7fQkNX0DxkapqxPalmA4gv0v4h/EkEeP4H34HH2xHIo8s1Nmh8zrEkrg06CnVRyTwNqE03BALqg6k+ZfqFc2cskqNPONb0L+6WSXpLhn2oesF0IrUk7VBaDf72Wmx+6FvR3SWnkUNh5Tp9YMQlDDIREGfsGJ3EzUUlxTv69VvU6nDNoLv0+B0DxcT/sBSg8zROmWlPL0nWoBkXoJsLfsR/bZZr2CU/YRZq6N/qqwa8dN5DOGNeatFLl4oS+/y+ht4ev8MlbQ/WQz9/iT2TOzHr6q97ATScshZKGZzxP/WTlxjTEb3KfuBKCyPJzxQpJfIxlWkgHmsmIWcGr8xZyCvHkmCDqsUooyl0mz8ZdUIts9haKWx7wTpIwwONzHJCM3BUh/Ux/F4ohZtGHsapIsFZiCOoC+AFV
 H6k67S3y
 oN8BoxUMCI+44bknq+ASYAj1HYmWOmMRFGQlhl7cmQIfD5zs5epuGNKw9y936nqb4rsYJ4gnmCtl8NCsJ4bM4bbKEcnFlF14S7hIUm/HBmB2ewv5QIxEkkUSZDRjoAFMFRQ562XsvFL1jRlyDy+myaeaFCXbDA7A9jAAoCIhdDM1AHmv4W8IRIodARg7+dMOr7a6zrfcsGsYE5LvUEZbJCWvLqZ75XpwsRJaZ+ahTlpUGu07K6q8W4Zl2fkxELpdZMBkJgRSHGYqtwAc8+R71Zj++/8yXjc7HgA9ZxGWIIgcqkkD61SVEUNB04Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Oct 2026 01:05:32 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> vmf_insert_mixed_mkwrite() has no callers.
> 
> So remove the function and its declaration.
> 
> The comment above the function describes the -EBUSY handling in
> __vm_insert_mixed(). Move it above that check.
> 
> No functional change.

Looks good to me.

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

