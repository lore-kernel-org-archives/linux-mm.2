Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE49CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7B56B0088; Wed, 20 May 2026 01:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758266B008A; Wed, 20 May 2026 01:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66EF46B008C; Wed, 20 May 2026 01:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56C826B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:21:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08E80C03FF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:21:04 +0000 (UTC)
X-FDA: 84786649290.19.ADD4566
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F8C8100010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:21:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUJ4xWWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779254463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ClVNQ/qL0BwmVZSTaZ5agutkbazJYSG1buLiSM5poM=;
	b=YcZvQqfmbD+Yh4rcA4DdFq6pyzAMZqIw7J1ZI3ELYLQVMFS0WEsvv+PY0cmZA14SvU0ZML
	FDIXJX99eoSCJNmcOEdkgGFgdW2sVwMPPxK65DtQh5tTf9WgISoXnUbiZ73mtRD64/gaGM
	rF3D39rtXgYaJRdrn7+7+x2+julVRio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779254463; a=rsa-sha256;
	cv=none;
	b=o0qHB3d1nbffGf60xjG3xiSfhQ73w4jq18q/b+538GKOj6uZOlVq6ZyKCiZIQasU4eFsmA
	wBn0jdueVu6tOK8naJ3OyWXWEHKJICZFqatql9dFU0vyzUUUt+jXF0VC3lrnq/zPGnPlPd
	GQLOh5qsHvSMjmlvmS48UfGdi3M8EIQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUJ4xWWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3D9260121;
	Wed, 20 May 2026 05:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965601F000E9;
	Wed, 20 May 2026 05:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779254462;
	bh=0ClVNQ/qL0BwmVZSTaZ5agutkbazJYSG1buLiSM5poM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JUJ4xWWDZC7ayjgLnNw3Zv1yTxlCTSdlCac/utWchwC+t8s2xegSJt2/2HSa91wKW
	 sOPxrrF+gZ2MjJpayu8Ois3BEWsu20rgV8zlw21fI2hh435yP6R028TsFTBsQUbdYh
	 X27wLIOCZe+h8GXzVyTI6k7eJoJwr6Tmd+tKUoZ/XP5I85HAcHLGDapdmNqhO3M/8v
	 0W1oJ38uMIBR/gNS3k+9/Mr5HeYJSHmoxwwuf3zD0aeQKkHSudhDmWbX60zIDrOFs8
	 eUo7UuZXg7WnsBVBv5ahAgIn6KcCBa9aFfcXSu+0n6woCVpfudv41xLOIC2qOMylSU
	 o3JaL2zIkNw1g==
Date: Wed, 20 May 2026 08:20:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-new] Documentation/admin-guide/mm: Fix typos in
 transhuge.rst
Message-ID: <ag1EtRBvuT9NUTOm@kernel.org>
References: <20260520051751.74396-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520051751.74396-1-leon.hwang@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5F8C8100010
X-Stat-Signature: 8arbnjoxzzcjajcg8tsxxa599em9rhnd
X-Rspam-User: 
X-HE-Tag: 1779254463-493809
X-HE-Meta: U2FsdGVkX18xSYTnA0x3yHrJjCqiOF3FrbopIXVQ5RUjGc0uKyhCQrLb/IYRqBHFM9QGNs/h9WRNYZo0IHUVAUCwHVxq/COkLieX6CUNvAnsJ5eEuqynquMRX66ESiuzy+YQ7Ztfg+ODvFRaPGWy+NuyHTUdb7PwPf8ySCmL5wxcvYjdQURE+6hJX3bojjUDO5ZcDKB6+IEnIUxu5Z5k8oyd3WA7bJof5fMt7RsS54URED/oVXaXgGdODpOTOG/WiWOvSm+qUZevXU7K4gwQNWtB+AjHvQ6l8OW3W40ZbaJ0Qx/W1S+Fl9NnFNUZSzNujEJxTWncmVXhQzsWLBGcnn4c4qfwnKF7WukLgUQwmtHhlo6tdYRkw7bPa1oF1rO3R3uGOtvHzC+SoEzX/BfXUjCuQmCrGfJAFYYtshsUzXua3D5592j/HZ3r4iC6I/0l8qUxjoczyDC0lD4GkG2YRX0sOX6xunt+nskNe8FEEhz3UuBRVduVe9akXHNQ7aispaXoxnbBIScGX7vQhgy5gS4oBHm7shl/LeSsN9wSnFyqthv7RTaFxXfDNgdp5x8JzR27dCz8UWrVJjh5UJ/QaqBA5TznRr///54Y42OZjELpWFQMxDx6jHu7Q+ScKxZD0TKxYIvFT6WYq0DY0dxfafJvYgCQHdw7NAfJ9n9QItW9MNT6FD9dhDLNF/evwQJipe3enH9/pg/mk3aoyZYiiUtS4vJ/yBZtOTaipX/yINBbYNDrILHTuPofUwjuxCZWQYoNfuej1gRaQKOH8GfKyKVNQ/Wpycqik1pWpMz7lFo5PUHG/FkleHi393UBep56oRerECZuF8yWQnPuw3OUAsNlf6F0lyjj4ssKxUJ5rgb3vYaMC5ZDzalcZN1iN7DT4ZEYSwUZ+F0igjl4cyzK3giIWE9ssECbMXYkCrQ12yp7ncgD/9ek20bA2olpNgje8VbokLgkJn8i2hJ1aMA
 YRxRRSc2
 lO+gefsNNbGHON7D3oy0qTvLTLHMF1FUbOEXYzp6Mj4kkL+TlwYL92VRnT90s9LcvItLb4u/cUpiQDYHnjn1sdFGl9jG5SlqzTQCtGokWXIo1tE0PV24WxclSR80/HyXX+jdV1WeLU8EhEs6HESJCqgx0E2UVnZMwtTszefyse69fxLLMn1UcbdSje9V5ZOouRYmU2MSEm8GtQ71m4SCz/eZ3Dl/pJ4f4L0BprOHCpIyvMd2EnSC4pNbXD/hQa60ETqNSVNOJSCOUg/9bGw8a2yHAlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 01:17:51PM +0800, Leon Hwang wrote:
> Fix these two typos:
> 
> 1. approporiately -> appropriately
> 2. presure -> pressure
> 
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  Documentation/admin-guide/mm/transhuge.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Sincerely yours,
Mike.

