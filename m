Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B06BDF3ED50
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 18:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB8D6B0089; Sat, 11 Apr 2026 14:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3776B008A; Sat, 11 Apr 2026 14:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0E96B0092; Sat, 11 Apr 2026 14:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F16346B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:51:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5917B8FA2
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:51:46 +0000 (UTC)
X-FDA: 84647169012.23.A6D007F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 22F4E1C0007
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:51:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AjbiR7UG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775933505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0lExf9A24oCPOx2VOBt0L1I2K+Yr4XKGb+93JcxGRU=;
	b=mrj8tsbQpHp3jjzhva4ZYFc5CycAixvo2TQXjhy9AYD/b0GlYxXjlniW3WGHfI4LGMhZ2T
	WRdxGcL/spl7rZrA1joZVaqqGZKFy/d67ElYayIB2K+hIqSvU+9oWJYyxpyTUgLvLKCcgS
	VwQYrnWkN+EqMhhnkFGGJOYSrXhogK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775933505; a=rsa-sha256;
	cv=none;
	b=KdSBc5qnQ2mrVP9/tW+563zPkSLzqjgVY1kLY5d2SgnUlLN2q4ww0kJaVhahwmpplVz13H
	RXpjo73Du9kYpbpplLCu8QjGlaknM2CzGQYo4JAsDAQtJlr4KypZgCPVomYoGfDjiPM6LZ
	AO3lZCWv1lsxSMmSZDQn4oj9ejputYI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AjbiR7UG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 782016015B;
	Sat, 11 Apr 2026 18:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EB8C2BCAF;
	Sat, 11 Apr 2026 18:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775933504;
	bh=7DTLn03lS5fHMMRHZwemH8MHnpoXTwRp/xjThTiacFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjbiR7UG+2oFW3xlBlmFGKjzR6oX1qGZUkBLQvDLpNRpd5rTI4k0QNQmCbO7hdgOh
	 hnTxa0ZcZBx4gnnirFuBDi0gVMWqFpMpCVPMHyoNUfOMVYXCMjhX1sU/x4bU22xw2A
	 9s9x/wX+TCrRrapOrZCoSdc4cQswo3T3D1VWORidDzjib81hUeN9OJ06oomTCtch2Z
	 X/30t1hebjgCO/vEOhJmRfhQnS/Dzo+KMRQawPw8TW9JG7KRuxr/igVo5f35HslsHy
	 QqKEZPArl2JsVTsegtCZAbJIg0GNkbwilaIwpzeRa1+dxa5I64q3NXJBhYc44WKLvk
	 xK/UnqrJXASnQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] Docs/mm/damon/maintainer-profile: add AI review usage guideline
Date: Sat, 11 Apr 2026 11:51:35 -0700
Message-ID: <20260411185136.82032-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411184802.81804-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 22F4E1C0007
X-Stat-Signature: h3o466zy65wyuf7egu34u6ndwwtuhjug
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775933504-580632
X-HE-Meta: U2FsdGVkX18gppxpCJJCo5iDclUc21ji+fqjOli4Ak+zHmm017Qp4TsVHftQUubvUmRRfsH7fFfdGPMGFMLGGFqcsglc6ph6jH6LqOLoOKWmWJRBEXmZ78OrWn0pxuy7kbnyo31p9JtiBfrJ8S/Gki3hk8nR++viKBdCFgRZvLq/+XXUzzwViyUzDwxCPDdT81p71SqtYd7O6PG4K3Me0pKgGdjdiyWqxf8w+6yaWcEGQa1ooA6YLAzb4o6150OK8i77xaFjnuHrmx6GFxw/AHDkynw9xLKry12B2APo5hN+6LC+5LqimF+cyRxNKWWZkuXxBaEouQSkZiwBTLVKRMh3uu535BYCB9BLGr0Fml0cwS3xZJfGEgSuF7A9+leRl19KFYojRCNKsbUWEPSFiWjMmevyrtqGOJJY01SasLpmSvv8/ZWev83FrqqBDSMnd5QjnNgyVAYetQDDDj920adZJVWXQl+fSXK6ujALH6CtRNlLH/ORYD0fnhcFd0bA4zPXJTt4CDysNYBcNmrtQLSSGMObE9UZFEfG1T7zCokoz9YVPv6q9KNBYfXNB4ORnSuOpKWN9adtG7PbSfIiIzphZVzUJyv+2GDAtkZ18fwTxqZmTSZIdaUYQ3m1xBY/VPgzfcLvYXSayHRE9/kZh3dMEuB6tmSo3UrsjPUJLcm3zkCGGJ1NrVGA01AkoSlCU95v++Fd8Ew4Co+tgP9kyCD1EaGrNPoMwnGgJYIEdIMpQbRmS5B+LpbewylOEUv1wzlySE5Mq34XZ+hbPooJoZ/IjgQ0ir2/K1oInKPnBsxYn/ZSF6fQlZueX3Fm9hnRIhs+YG4MQRlXy8UAJL+theBHDP9zY4J48JNJc++9PVDPqR/wA2UuFiZTHRGWepiDwp55noFLjYCq0LgFOb99E5lSuGxh6A3St5XBa8TxVVFC0zx6myYJE7bcQSMJlstRPVnOao8+OTJpMNiURDq
 zNWgiGM2
 E+Ch06ovpnYdoiwWl9DOA0yyGirKxPXLx1puyJNzDJlizFlDo/xw8PIY8k3KLzOwpTeFD2Kk60N1I51YvSpYpbtU1CpIO2tOsEXQq81dYTLKmf/xdKHGF5YGsp5tBg+uBweAN0798ci6Sa9IQhKay4MACejwB30ldZVCP0KV5ouDqZx4SO22ZnqOZS0sVE9gSClfHMfRpz5KQULJm822TbhjXsQlQw+OMe/y9LNieCfE9e5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Apr 2026 11:48:01 -0700 SeongJae Park <sj@kernel.org> wrote:

> # sashiko review suggestions
> #
> # 1. Consider reducing recipients.  Maybe the author,
> #    maintainers, reviewers, and mailing list of the
> #    direct subsystem and parent susystem mailing lists
> #    could be a starting point.
> # 2. Add short summary of your opinion at the beginning.
> #    For example:
> #
> #      TL;DR: sashiko found an issue.  I will respin.
> #      TL;DR: sashiko found no issue on this patch.
> #
> # Please DON'T FORGET removing this comment block before
> # sending this!

I forgot following my self guideline above.  Sorry for the noise.

TL; DR: sashiko found an issue that better to be fixed.  I will respin.


Thanks,
SJ

[...]

