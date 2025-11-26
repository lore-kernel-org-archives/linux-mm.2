Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ADEFD1039D
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6AC06B0030; Wed, 26 Nov 2025 05:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40B56B0032; Wed, 26 Nov 2025 05:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7DF86B0062; Wed, 26 Nov 2025 05:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7A326B0030
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:25:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50B471313B7
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:25:35 +0000 (UTC)
X-FDA: 84152376630.09.A49FB30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A84271C000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:25:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TiYIuCSU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764152733; a=rsa-sha256;
	cv=none;
	b=jBqvhG0LhTaB0eSsFkI1HliD3Ad/27UYuFoBJ2QH602OlGjrHv/gR0sdX2XYLBAopFiO7i
	MtYw6lCgjnly2FpEFPX0EknKqzzBvD0GVmFLpSyX/LcMbKYOgTFkDGbJYqrhX4VhXE8wUA
	+o8KJgEBto7t+0RgdIaD34XGnA6CkEk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TiYIuCSU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764152733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hW/OEtBaLBibMkDeiCdPpW9Ckmbp4r8bTfP1ufFelyc=;
	b=gp4s7NIuLe/XhKqxRd25cK5dPQDdW5pWCsyW8W754KCo3zP+y6gRQF9YJYisVk63f72vZP
	/qr4EPkHdZMy4RSJTVIkFvk6CxPhfI9YzYl2EYiYqB0DgPgHGKbpAbbcA6M4p2kyeTeWck
	i7+j02yN1ZKjuF5RxIrbfop+dAzhWmw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A84D601D2;
	Wed, 26 Nov 2025 10:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D812DC113D0;
	Wed, 26 Nov 2025 10:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764152732;
	bh=ADT5O93kPzD5IUnxNtMCPvZ3ykq6P2gnQ8CL/G2R2Yg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TiYIuCSUq9QRRGD2topIHFwl1vopc3ZLruOXHs9PFa6hrCZl0gnj1E9KSrDUQJm07
	 Tv2dPgpe3TaU6zrGMJiYz/x1RjJiYCjoS0tWUnyMxE0aStEXScEdG2/MVbTeNhoIVw
	 EomHvzqTzMRIzPfLH7bujkmAqtrGEN0VnxmAs5RvxuGwlrrp+DmrBbQvImxbMcbW8D
	 SVGGQixWkF/Gh/TJQBL9VRoZsTyCFez7z9R8SR5ePpkEB7PWuFqg6ceVrItOwBEDvf
	 pXXPBuDQ4gTuQ1h+pmAsLjdmmzhrY/aPHEh4kchNz2BfsZf8keHL7/sCIG2gn2B0Wh
	 KCmcjSEepjGFA==
Message-ID: <3d5096cd-39b5-4280-95a1-78998a4e609e@kernel.org>
Date: Wed, 26 Nov 2025 11:25:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-5-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251125183840.2368510-5-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A84271C000C
X-Stat-Signature: 5kb8gbkcjasj4zrym3zfo8msw8ts1bog
X-Rspam-User: 
X-HE-Tag: 1764152733-8771
X-HE-Meta: U2FsdGVkX1/NEdnDw0mf/ekxajahBaXSgLYGIUEX09tih+KlIX0tBknwmbKCkDCrXFmJpdGkSmUMfjKZ+Gfz6JOLhlFQrDcOcns6y5Mcu6+czu/ZvPrsnWTefIJ7E/mj7K5tcklSvnfXlBiVYnKhZTIZQH5HeJZ8o8shtX++zuW53guJUC7vWUJI/daCMUMHHer6Y+Ajv14sYEK7HN4oI6adAExuLuIPqQBAlWATV1R8SkSqv5ggKFVfupeTuo3twDwl7dWio/HtDBhH04pOZP1N8GhXHW3PBk9faIkAsKR5ToywDiFv9ECj2QcZWPCiSMjn5a3Szxz22C0ZTm35/Sof5T57Genc1i/ym1OPw1zBTsz1huZhrIiUAl49OI19n+FhHbdUJQCxCbXznkMXS5Sq3xfVQV0gZMZTM1u7Km0+T2dQMh03LHX7+rW4cUIWsp6t+uusolz4Hzj6hIS2owJH3dfZaCYT1Y5+JV2RdfPD8uByeZAleqYMX4zxj+4wE01Iut9hDSPBPUts2ciz6qJygbTZl2s1KekkHqtKHjeIjLZVqxUztsJwT5s7n3L67C794qvwEk+5PlTTAMVGoDv4CheYnACYHVw+i/S9E25UPashwt8UDe5JPJvUNHLLEGh07NvRITsx4Gc26YF9xhtcyPFk0vqs/2DlAqqjjhVfJdGIyBxgOz9JzqJ29RP4AMj3fcAZdRnScizWgZupLAIK62W9GtoG0lq9VX3LorZ4ucTLigjro0pEZ4Zh431E7RQYgowMosMsbLxbWbWOn5L3U6MZbp9PVwPGgTQPDfuiEMZNAAflGZA1aKiw1LTTbPeSAn3tNV+FYtj/ZCYdZlx/qbWA+RY9o8SXm9LSrMkJW2eADEDU+vWp33Qwn7pKvEm8eTPkzQaj41YN1IE3PtN794nUYKrCeYTKRjs0w2Vo4Ct99UQHJ3RUtJ+mhqKx/GWKziR1EAnkWjI5u/5
 gpCLYf2c
 N14h9x+hVd355IwGJP44NOlnxKsV3FZ7ToMsjkUUZUr3eIQ3bjG0wEIuuEgxF5M2bkve1U6TdtgZAwBdkN8yciHMwRMcucYZXSL5prtvCw2zciXvck544fYRqDwBX2Clw+TovLdato2l8T9BEC70u77k5BG/g4anNjFWRABAkvekdjr438sZemHInDNh0v6QrbktPE9GUjVKET8JeSAjK8GzCQb3MR1WZJL7LRdpOlbd9zj64/ytFzbK+ol3vSUGnaAjXmm3cX/tLNzrNUS874QAk8xcvsHWD32ZAYQElqPczFVSf3m0oqX591eFOaHWLo5dZYdhGRvBE/sg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 19:38, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> userfaultfd notifications about minor page faults used for live migration
> and snapshotting of VMs with memory backed by shared hugetlbfs or tmpfs
> mappings as described in detail in commit 7677f7fd8be7 ("userfaultfd: add
> minor fault registration mode").
> 
> To use the same mechanism for VMs that use guest_memfd to map their memory,
> guest_memfd should support userfaultfd minor mode.
> 
> Extend ->fault() method of guest_memfd with ability to notify core page
> fault handler that a page fault requires handle_userfault(VM_UFFD_MINOR) to
> complete and add implementation of ->get_shared_folio() to guest_memfd
> vm_ops.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

No exports and still looks clean to me, nice. :)

-- 
Cheers

David

