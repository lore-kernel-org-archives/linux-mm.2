Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 640A1E7E373
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7145F6B008A; Fri,  3 Apr 2026 07:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB756B008C; Fri,  3 Apr 2026 07:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628AB6B0092; Fri,  3 Apr 2026 07:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 545186B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:28:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DADF41405B0
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:28:05 +0000 (UTC)
X-FDA: 84617020530.24.936706F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18259C0010
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:28:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uBvAbrlT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775215684; a=rsa-sha256;
	cv=none;
	b=BeT4Ve02hYScj6h47Uco5nJGKGEA/W6D6TYVk2RIcWnmRn6ikpACraDBj/g3INz1u7Bqih
	gJ6UBu+TzSCjgWR5E1hof+/UunhIdnBUAitm5ydQhgdfQRcLcOxX9gZlzbvHD+XNXRET3A
	ve9wCcN5QEI8KeeQfpejT1du6pH0Zjs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uBvAbrlT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775215684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YH1Zm0pdIauW53+MKVBdPUDWUtbtD9Skg5FcwhJhtQ0=;
	b=EEuN7i6mc4bDpGnMzX0y8dHZ17cHkP+9NXbQcWtUiVwR3O88by/i+cNmki7HqqO9g/mYhI
	rqAwBgaw/alB2G6jf4fm/egYo4FLEvrPbeIJu8lzRfy2ySvto/UJewstzS+HBBQU07NSUR
	ADI5nUbqnpbKbH2hJk/Cj/uuvswE8FA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A48CE44100;
	Fri,  3 Apr 2026 11:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA9EC4CEF7;
	Fri,  3 Apr 2026 11:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775215682;
	bh=MabZ8ZNxlfCbCNmRDlhcdrRriNXoWOt9AGIbHCeoMZo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uBvAbrlTeTRt2+30VJbA5n2wjqDEx6Y995UcLZKvOhxPUEqt9Ea/BEaDo7MYuOO/8
	 vEKvhY+w8cpNON5DPGwQsrTq9Uw0YWxNLCfXZUH+vLLwKGTpVsChEZSNF4sN4I56cC
	 ES0kSoQhuSWJt4anekYaIuTx2YLkGbKvhTRR+gQtItlkZZf4p89S1bdMdaO+/9moZB
	 vUXSW5X0CexGi0LLcIdzFf3PzgAL/zkFbJr9QyllIdBwUxg2CYoRMKrnzhU9LBQ+G6
	 6CDpwqeU9YncpUaRpYDJnG1EjWwqp185HKLkSNniPBj7PNu6Tst0FThD0l8Et1Ksse
	 Q97kGfkJHKfkg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usama.arif@linux.dev,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v9 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
In-Reply-To: <20260316-kho-v9-4-ed6dcd951988@debian.org> (Breno Leitao's
	message of "Mon, 16 Mar 2026 04:54:34 -0700")
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
	<20260316-kho-v9-4-ed6dcd951988@debian.org>
Date: Fri, 03 Apr 2026 11:27:58 +0000
Message-ID: <2vxzmrzkcmgx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 18259C0010
X-Stat-Signature: 3pkdrnd7kxkfi4tqagdtxdwuju6bia9c
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775215683-285396
X-HE-Meta: U2FsdGVkX19gEV2+styjp9CXtaUrSQwafzWdbbOIh/Lg2c6CMt4rFmZF4yiTiCTvS9/Fes3MkxuMFvQPdaafTsaALh2z7jMzuPtk2VW8gXAtDBZWNca6VsS6B6xLI174T3iU+TrgdCVBqABpAhjld/VOaeUrGfi2z5h+SjzgsLojfdu1yHsRpIxVqKEfGAOTXhgKzSrlxT0EWWJodG2OcR3WMHX+hC6wBNg3reBZBPzJVfZxkYM5LcMdt130OjVz9/hYkyz+kDzJ7lTjNDGyD1acJxPckxpNZcBv8ppuekb9bo5STBI0mvje2ZWF+2hgWMYR4lxg8RBkjDaQ0l6mFFSoAdry86Fm6xej32RC1Gpe2/dNy5yhGoBYFAsZmdpoy8T8vm1+YzFU9wuqk+VGqWGt7BxqRv9GcA/I4RZq3+MMaLXtw5GJt7RIbEC/I7B1DpB6VQ/yIEbRkYlSfYo0k+pg6Soa1WXmZZ9t/+JuP0ip5lotnealcbDSQ8g7rDXR3gj4jo2T1VVpjsPXthnixUl+Ui+O1PZIXVVwI2Xog3Xc1q425lVmvS2EqaYufp5bR8lJyGIEE2hjjHZLDZ+lOcp4lYV6g+ODiXj/TQwcPpcEGkDVkHrbxC5zVYRXMgXXcZgmjT2sgh/ZXbGaCRMAliWI4qKNqm0y015Iv0Cr9zH/mtOpAFXC1Tu+MqjfJeVStfotNbJkQHLijJRpFxxcwstK+jFYvle/eOdWUaBnoEVcdbErzsOOgtcKGWajmwqnvuWkhPe8BEGSwU4Ij3bZq16yG3fARviBOXthFkskffPM1/iYpdl/gV7gP4qSJD8JQ8F2V2Q52gAfy1GRIlmAuA/PpO5NDto5JxdTdDrQZWlPJ968XAwi+CGSoDhWwFpLPftyVHDUWPphpkqrWlvh8XLGs1jAeLFXnU9SjXMeYDhIakLGK2f45MBMO6nLc5iQwjn5MWNXQbr8EaqGl+0
 mpnj+Fq7
 v4KB3TWlZk4URmHlPULJfUmyWUIto6JidA/BwD6P4ookrN+tYUDAVnEcSprcli8Aer1r1n7P0szLPUbZwWyGLbAskZ3qjuVUh2sDBUjIr5SXd+7Ib1HqnmaDvVgJW5M3KffiOjUoLwdlv6a3Ibc5tYyPkcBFBadIcy4nC7IMDSQQ3hnAn6cbHX3h9Q7UjinZHXMQLWKpAIZW3AgykDdveSEhgs+9o+URBPYQOAbP985Mn+ttu+Mmi29VZvPsrKsFiCU50PE+jZ7qfHXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16 2026, Breno Leitao wrote:

> kho_in_debugfs_init() calls fdt_totalsize() to determine blob sizes,
> which assumes all blobs are FDTs. This breaks for non-FDT blobs like
> struct kho_kexec_metadata.
>
> Fix this by reading the "blob-size" property from the FDT (persisted
> by kho_add_subtree()) instead of calling fdt_totalsize(). Also rename
> local variables from fdt_phys/sub_fdt to blob_phys/blob for
> consistency with the non-FDT-specific naming.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

