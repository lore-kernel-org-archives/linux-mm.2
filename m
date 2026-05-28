Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8E8CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A836B009D; Thu, 28 May 2026 10:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3CE6B009E; Thu, 28 May 2026 10:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B106B009F; Thu, 28 May 2026 10:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 147116B009D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:06:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D09EC1A0858
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:06:49 +0000 (UTC)
X-FDA: 84817004538.11.8A55DA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4282FA0012
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:06:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pvb1CXpr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779977208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EslBfza86xJv9Gc7bf96swVB3Sut/phxGTZEKo61jTM=;
	b=dIKUzDA+NMIj3mNMwYZOqEfqwf3l7WZ9oSJazA35UMAZHlmVddQfidGesbhFl4oorapNub
	NWi909nMzmcdnrxLxomEhNssw5+o1kqKbN7I0IJMrEM+I1Ar6dLoyaBQ0JzOrbXI2ipQTh
	iPU1lg65Lc/asUmPVCacbJyGimsBZN8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pvb1CXpr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779977208; a=rsa-sha256;
	cv=none;
	b=NL5zuU128uo/Y60tvM6tKah8HH1lhEVw3L5GJc7M78F+w40gwCSBxQQifSnIaISrly2JPt
	3xjqcOvx7oUrs1F5vAVN8+A4d3krfP4mNi27xnw81GZs4hBuvI/mdRosmSs1u7t5VifUwd
	8HlG2v7BeGyh5tpy6rhL8Bufd7MXMWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 624C943709;
	Thu, 28 May 2026 14:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72BD1F00A3C;
	Thu, 28 May 2026 14:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779977207;
	bh=EslBfza86xJv9Gc7bf96swVB3Sut/phxGTZEKo61jTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pvb1CXpr/acSDEgJNqprj0XeEzYpf8q1fRcb7Me58XIdeNyB8q1xTvNkeR4E3JGit
	 CEiH32Gt7tVvh+fbS4u8UntcOtXo1d5XFADreJcDyMIt/i5dM/Q0AEwuZZMn2Zi7BY
	 6Hp0fnRN0ud5N6cVgxCEGFSNgE2I2T6p6l/ZVIPdZFjyZpK+AHs+KyDXaoXtCuMj+6
	 tNXMjNCJ160XzDKLw9nKKxXdojfL02mjM/jj2bHdBJ49TNoOprtZEU9+V1tlX4ZUZ4
	 LuYvxAXkEy7fdcIxYkw5bihvG9ayyDfyjJmI2n2jHuufuotGNCIWb+WtXfOBw0+Nh2
	 WiYHf0bucrkWQ==
Date: Thu, 28 May 2026 16:06:40 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Brian Masney <bmasney@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add vm.rst to memory management core
Message-ID: <ahhL8CaE9jFcNjWJ@localhost.localdomain>
References: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
X-Stat-Signature: ih95jrwiftnkjjg1cy66iuucgwor3p9o
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4282FA0012
X-Rspam-User: 
X-HE-Tag: 1779977208-592571
X-HE-Meta: U2FsdGVkX18jaTCE7cPmMA9+b/3bMGmySnfO+aSVjyTldyX+1wNnF3DPyf71PglRQGzxjqfuBo/0bv9CFLea/8QQjZM0xDLpRZPtgJzopqRztSZ8M/ZjAJFzl0Pbc5EOimMb9p7mfu+rCTR1pKLvEvf+4uzfeP4FVv1LleixzwKRChJHEXmVJpqNcgP9C9R+az5YtYJQx8vSQdali6XoKaiMDdKB5liLciMqgds10Z+9hpzE3B4AiOuR1PMD2Ohu6NcOhttU360XPEA8numVoGEzc/JfOZlBqEf/Lu2poXAQ2LX29RE9p9kAdpWRMnt/5K2EeYthwZ8yEr4WLyjnK5aNxnml11+2lY0PSgpaoGU6M3GkNR//ha9nZzOXhGzjk0mdtcVzQ0Jn11NeBJtcglPhZqt6eF+eKcLbwKrqBrjM/QfJzgqiGAhAslUgvWuRFcrAWqmOZvexdu6MzrH2tLPW+svE9ArHfoXr5ytB3rAxK2w4sywcohIoqWtWbsQIIOn5saN+oh6pNJsStYfxY6gKsJ4d0PmMleBKSRpKd6udX4hVfo1hGM13N/4QgNcgC1mr/yRygHCNeC2/Fgqxd6qgFgpAb7tJHpINU6O5Pa78Cg+6J7IVQld9URSgvyBK5v7ryMshDwj33plE41ndLy8o1eYqolzb+cm5xjtWqWZQYNuu+entpSVrSTqkwdAccbSybEtnCtMtn8dVPnoouEjNSLCG7eCAkvJKpiRmlX8qY4s34mEA0nLWPobzCx1h3APYgxn6uG5u+LoFxCnDHZr/li/hoykECV7M9GQkmaeZts0MxroBaoEcsze7T3I5yw+rIdWzXXbobzkId89vaUD+QppULqxtQduUOYvHC1anbkG3tdZNbAFmwwqlFPrxhjwTGk4lNhlFAwMS/Pex0+AZN0Qg40Ajauu+JTN6A22Tbay1wmtnhM2OQ5EkA6Ma1pDZMD+zjBTY6Y7Myif
 PJHVglsV
 Ad1e+hawzhj6vxvirMsexOgkarMBDHU8Is576XOqCVnsUoIF0o6QA0o+h4RR+KSghxF3aZS8s+2DXNN6LzHzDUu9GEUMzis+JV+EkH6h3gRyOu17GRM865WP8oVb7gzd4Atxo8ak+S+aI4GVo1Zl5dC//43uSvx8xc77lGIwFfHl3K6YTlMZ6YJWIeafLiDEzWrnLYiDHC0g3xZgs/mowdZoBpFWEXIBaRajs61fYcZMBS+Oefu2NwbP9mcM4LdMdx7eI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:56:14AM -0400, Brian Masney wrote:
> The vm.rst file is currently not listed in the MAINTAINERS file, so
> let's go ahead and add to the MM core subsystem so that the maintainers
> are CCed when changes to the documentation are proposed.
> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

