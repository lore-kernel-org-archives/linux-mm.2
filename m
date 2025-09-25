Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD480CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044BD8E0007; Thu, 25 Sep 2025 05:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37C18E0001; Thu, 25 Sep 2025 05:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27048E0007; Thu, 25 Sep 2025 05:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD2788E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:19:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F51586D68
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:19:43 +0000 (UTC)
X-FDA: 83927225046.05.388AAEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E521914000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:19:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0RZZ1Rb;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758791981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vGy4r9I5hgyJ4PvKF1ULDLS+M/a8IQIyyw5mwU4gZA=;
	b=ZP4mHVZupb1PiZfUL79UfCwX6G879qDa8MX3qU7ZM2oGm8Tr+GuRDeQ6AdUDO2jpvtBeNg
	8w3sFqJOkA9QlasaZTwi3ZbkN0UbOsDjLEnBL3RKLrMhqqaM6lE/ctUwmqxAqSLMHluI7U
	CgFtDk3jExdgyyR+zzRbtVNF+g7wz9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758791982; a=rsa-sha256;
	cv=none;
	b=aKvwgcCbAMtIJkFo+0kLOLbBAAwTbA8gYaVSPvZZzFk8A6IpKk3WiMVzSDVFbvnD0swBZy
	Lbv+xduKW9qq3Hz0HmWpe2VAJ1RZ82T/UFr5j3gc9edi8U9TwWoiMFttTm20fHBahcJvXu
	4FjLkIwhYc2APbEOc57oYIRyecjk7Ug=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0RZZ1Rb;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EB4C6013C;
	Thu, 25 Sep 2025 09:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96BDC4CEF0;
	Thu, 25 Sep 2025 09:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758791980;
	bh=AQqMJQUBDrq9kxPLr/qGEjxf9utS86NJR0MoZy6d1v4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k0RZZ1RbKWAAkwlLtYKHcY7S4z/MVWCM50D//MM7NbnU4x0VQ104OQW68HBeAYRYE
	 Gk60I4tro2JMqe3Qjc8LwqFxAq2mJlq+lKwYDTQWUkX3AkNoBii2ZDZfEvqZN3rEM3
	 A3jYcewOMAlaG7c+WSx11wDrWKMqV5Bcp+7l8t8kM9isRSp+OuRBU+FwhwS9ueFh46
	 0/QAkKl2M040I2KBKOwHwNMlJg2blEiveia9uQcZQJmWSKPe2WfUhlSKJLGTLszk2K
	 Fb5QnhvksFC9LTB8hhqUzWg6e7ye1m3pyxoM4nRn+bZFFpXmDoPpHtCOVBTNV3MagN
	 yOB/K5Ig541Lg==
Date: Thu, 25 Sep 2025 12:19:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joel Granados <joel.granados@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Petr Mladek <pmladek@suse.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v1 0/4] Make KHO Stateless
Message-ID: <aNUJIsElr5L5uxNv@kernel.org>
References: <20250917025019.1585041-1-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917025019.1585041-1-jasonmiu@google.com>
X-Stat-Signature: ic43bifj5ojw11tyrafqa4a4jtihdfd5
X-Rspamd-Queue-Id: E521914000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758791981-555017
X-HE-Meta: U2FsdGVkX1+cZOnt/xlIHNAayxZTpMFrIM0sId+RbRVG3O5KX/MFY+WzYbKTe4XmAWJS3XXsYMc71+70W35glt/tNYUOoSDURmTP9bbmONdUeUAhgGFg/tgXiUfaDDS6O0Gj3i0glxF0QYoq0/TjG+BHJZHa8Vi8eHhZS08Nys+SxlA3JU4Jh0WfyIilCKl9kABb2hF0ZrZsAhAN/Zkx6y/ElWWe3RktTukyriMVGz6rVugRAgxdsYp8QrJ/XqIL8bCB0YjQySpJpX+RO8+KBj1stwRmVWfTUanl66FSjkCHzXeG5TuhNR1ziDMLCCmJjS8f6Z7Y2XBY0iUf0pIajwVNOFB6FWWTQ1CCzqmcZ9/veU9kcq8AAi78aGTbEUihoVbkUwVLRN4vtu5lcFP29oGSF3AX2XZkNEwEj8b4Kt8WMCKc/1dpZwMMl5uDdsjhuMuePiXeb7AnMp8BD3LAnqICGfChR1fISXJU5fzQovQXfoYgQK/qJhFNv8FKUxK5QXVU4gQu7wd2E+sMrC2pCeD2JZeO5mEwRz8Fu/gysxeILLdJMlH5uZmtccdYS+MBoKqd4v0ctLuKjebvc0m3FvoUgjNHam8/Wb7a8ECAhj2FYMYeTZ9r8JHf9e3LMJ+jqPD0LGkPYy5XgPVQvSSXFKlKG7A9O84Pav+gqx3ETCehKl0NOPPpbr/8yQptV/DA4m6cCfUGdVaj6R/drREw13SJyE1oR6CspFgFkNRUb3mJPgr90YacCa8IaSVXUVOtARvFoMVOh/c4MQbF+SDqSE+t+PW4B56wDLOa7VKba3OVfKHTHc/dpKGz016/MPKp/rw6upHG3iSHPtP9yaCxoaTI8KboA2pkaTMVkH6NnQjclOpJ2rKYu+YBfFTIiuJ1Vo5t3yAp2/ctURCm6vuNyNBu9Hb6tu3b3fY0VQFIKouZuO0CXopAmv5szDF9Yk0ikGbk09C35LoJY/yOOUl
 OA4QOiLX
 UcoDBpxY+MhIRzoHHRikSYh8H3ZAwQQZpWHW8wDkH19xPojPYzzoWdDZ2eu9iGDofI+tiX1NJaqDTKJC07DyLxCYFgn3v5RcIavImYb4/B4FXq4uFcU93wNXiBQP6kWzc5skESnEhymvqUmuVhxqRCFapMByzwaUwXEEFt7MOB9aEyum3ao9Fgo+HJ5/6jqXXv4Y5nyu55uroRJ1DIqYrLgckmouvIJrcVCjRHpiVNjawp6DKLwbQGCJGx5I8cL+lCdi6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Tue, Sep 16, 2025 at 07:50:15PM -0700, Jason Miu wrote:
> This series transitions KHO from an xarray-based metadata tracking
> system with serialization to using page table like data structures
> that can be passed directly to the next kernel.
> 
> The key motivations for this change are to:
> - Eliminate the need for data serialization before kexec.
> - Remove the former KHO state machine by deprecating the finalize
>   and abort states.
> - Pass preservation metadata more directly to the next kernel via the FDT.

If we pass the preservation metadata directly between the kernels, it means
that any change to that data structure will break compatibility between the
new and old kernels. With serialization this is less severe because a more
recent kernel can relatively easy have backward compatible deserialization.

I'm all for removing KHO state machine, but that does not necessarily mean
we must remove the serialization of memory persistence metadata?

For example, we can do the serialization at kernel_kexec() time and if we
want to avoid memory allocations there we might preallocate pages for
khoser_mem_chunk's as amount of bitmaps grow.

It also would be interesting to see how much time is saved if we remove the
serialization.

-- 
Sincerely yours,
Mike.

