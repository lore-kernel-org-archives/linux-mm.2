Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E098F3C992
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC7E6B0088; Tue, 24 Feb 2026 10:04:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AA56B0089; Tue, 24 Feb 2026 10:04:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787A16B008A; Tue, 24 Feb 2026 10:04:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 673806B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:04:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21B035681D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:04:08 +0000 (UTC)
X-FDA: 84479670576.06.F555ADC
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf09.hostedemail.com (Postfix) with ESMTP id 26C2D14000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:04:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771945446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rHrmNE5AzCCEkSniXcjezQpjWSwnPdtIbJD2QVxFsAw=;
	b=21cTn9h3nGSc3zscZDK23f4EvQ78FBUtSH28FijbQP9AAe8DcKfBF1tor2PT9Ysd0O5Y7+
	xTWGJUxkXS8oXy4tlV9CqxDqsAcT2HrZdCnxF5CregEAXsBVOC84v3ObdNOQh6tGKF8F+H
	n2rEpMS7EAw7W67DUwdg1fWi4u5adp8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771945446; a=rsa-sha256;
	cv=none;
	b=N5Dn6DSqWCE+ZEJNFhgHOxXY2WW6zDWAszlHQOxsoISI55aljoNKfteStdLHGhmtY5+Ou0
	WAo1gkLA641Yyn4yMEyqN6Fndr1z3+QrYNwW1RyfM6igm73iEjmiPv8KCdYBkveeRKV7Qc
	YKCvBOqX0J5tryHKA4RDb+VOeAPE8YQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9F58568AFE; Tue, 24 Feb 2026 16:04:01 +0100 (CET)
Date: Tue, 24 Feb 2026 16:04:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com,
	jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260224150401.GA14612@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy> <20260220151050.GA14064@lst.de> <rn5qoix7rattqns5ut7q6wmasjm4x3usfbh5x4e7yg22fzpiqt@744cbmehelmt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rn5qoix7rattqns5ut7q6wmasjm4x3usfbh5x4e7yg22fzpiqt@744cbmehelmt>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: 26C2D14000C
X-Rspamd-Server: rspam02
X-Stat-Signature: q6sj4hddxtj859n8fzsb8x7dyhojy8yq
X-HE-Tag: 1771945445-350653
X-HE-Meta: U2FsdGVkX19Hk4HlgG0t8FOP4QTAfbu7jNjZEi/7PwA8ilEnYdNs8waqng7c6SUjXNG85AEB1iIiHw0fTdrsj3aKOkuCZoNFa4cN7bbl0jAIoq0MYtaMUhSDzTQl8gQh4bh/FALeIUPNM93jOmMXAG/mWAr8uSark77/tcJv3Z8fcS0UMTxf5eEv2R/8QFfhqDwJZigGNT9zI4xFYNqjMS9Np8o3pO+6NLyfp44xPPqCWvRk1Jvla0DJNBDjEropf2lfDRaFhNZJ6a1bkKSrhzr729ZGcCtxi0uumpvul0cC/o/+xCkvd+39E4uUmE8SV/QHjIN+aF2IRw+1Idc0abOsHZlS/hvwKIi4vfv66FrFeyKD4j/fX+8xyiBM2K407Iyy5vTe9Yav47PCBype2MeagDaLlEyYwImF+xAjLxm+P0+2hmGhBTjPwDJPQSX75luTSNAa2jjDOOjuM0HGpt7Nkb1uH40FXiVqirwAEwQyJyKY3miSJlzy0kBkZQqL0yAC8d0dMMOv59RVG0Qm5RYQGFtmmD4FZDEZ6iBUfRgt5nTkb65mharq/1Trs58BxItEKsi8p0dD1km2yLx4oL0d+Xkg3nx3uQoFDSGnLhhzq7RE+WgXlG1AKBUrYrlPDtRs0Q2/jbewfQXBj/i09NOes9OLLCVoAoYCc4hUgg31wvsixpLjn5FwB2amMbUq/XIBE9dMo0ox5WOcJrcY+4efdfIv2gzAOZo6geupnV9hPeFtMAaMnajVpLKYxivXSggDz+zFh9+hhRyymWQgRqSvmlGB3nPccTcKHmkoNOG3L8FKNsvsttQWKfiqrTSr9blafwKhV6g3BqC1FZcPPJF1LQRA84mtPP7NzlhT36z1DGiM5SNmK4J0XP4/Hmh4FpqrGZzX+e6zyPij953l3dQ74Pbx3P5d+gxvegqPuzvPUYQzC/NTRGe4X9ogZ79F5pplDrDxwUDRsF4YDQd
 3whJk4mc
 VIy57Y3UP5zyvd9da6RzgiW6PwV1JwhqvFMxLejbDgPvsiOGaIGVAh8nMkYsqko3h9ZoreM3kR0qLs85Ns3VaRIooy6Mc3vHEdrki9IuISkrQhowlLhclz9870AET9DOflVNtf4RxwdMBk1J+LJLwDnlY6EB1K0oY2OVxfayOaYuOxe4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 01:09:58PM +0000, Pankaj Raghav (Samsung) wrote:
> As you replied, either direct IO or writethrough semantics might be the way
> forward. That is why I mentioned the first step is to do a prototype of
> writethrough and see if adding atomic support on top will make sense for
> the buffered IO path.

Yes.  And even without addin explicit writethrough semantics, this
is almost guaranteed to be a win for O_(D)SYNC.


