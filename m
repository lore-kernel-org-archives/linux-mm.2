Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DD0CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87AE46B0096; Fri,  2 Oct 2026 15:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82BF86B0098; Fri,  2 Oct 2026 15:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744D66B0099; Fri,  2 Oct 2026 15:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C01C6B0096
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:33:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC6B916082B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:33:06 +0000 (UTC)
X-FDA: 85278684372.27.464FEFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0B6C420005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:33:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lZgSpxke;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790969585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVKx84NxUYGGJKXGVVdE5LF3HRwqIL74lqlE5opoXUw=;
	b=NI0n9tMD/BpUobFxnUL2kHJFC4dGXXq+WsKa21TFsGOTHyRWWPH2GfSxNzXEPNYY1RH/jy
	vnIiZhVbKQx60MYTjjvlw5mJjNeoB6GX+E6uLlaPo6M0Xj3X79raQERZGNMmIJC7QH8jfb
	rUDlA88GnRAqF6x8H2hfuiMXBJzOg0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790969585;
	b=6EXry3rGf4S6M8Fg8AgW/unIekJxqGbztclOfwRNUoU+LNET6iQE2UM3O00vj6KpFAA2zK
	EMxFbFjjSouXOM97HzR9ZNRfnTeK/TdULodJELQ45SNf3YwP2ljv9jWzdeZ3/cO3xWQ8dX
	ig8jxO50NJV43NPl/3XPW2Su4+zfJE0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lZgSpxke;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7901660AAF;
	Fri,  2 Oct 2026 19:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D981F000FF;
	Fri,  2 Oct 2026 19:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790969584;
	bh=dVKx84NxUYGGJKXGVVdE5LF3HRwqIL74lqlE5opoXUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lZgSpxke0mvUdvDGWrJuZQLWen71vjq/nK+jJUHf6APW+GhSGLI7pFx5NWfcTsjIg
	 1FBL8w+e1gyB3dujAEbON2e0pPOscCKqRIEqJgpS1yq0S9H0XBKtxUTKjBZ6jM25qj
	 cztLOnR1xjdyGPZL4urYtaniCO+PNgEyLyAStr0GnGuAocclhFAVmNIsI0TRSufjC3
	 yeqjjfeXI1q43BgTcwyn9rW9FxKy2tX+PxebaFOnAZTAHL1STHXT6TG2O8gGiPcKVJ
	 OzWy7TWHqVeUG1zoUKlqnQmO5Ww3P76sSrBmzISGCIei6CuexWBlDFkoNDzd7XjtZ1
	 IAFPdbVDdP+PQ==
Message-ID: <45eaf367-331d-420c-b333-58c65c185a6f@kernel.org>
Date: Fri, 2 Oct 2026 21:32:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/14] mm: replace thp_disabled_by_hw() with
 pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <59028991ef703526a8e3be4c1f3875b042f328ae.1789695931.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <59028991ef703526a8e3be4c1f3875b042f328ae.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0B6C420005
X-Stat-Signature: 91u977r8pibowncjgxrwxj194ikmqqff
X-Rspam-User: 
X-HE-Tag: 1790969584-136662
X-HE-Meta: U2FsdGVkX1+J3PxdoAN4K4DY9+l4MMng9oIEsAU/d6eif4wwen0NphKYoaJfKVNlOZkSMjztmfZ0Y1oa7lLp/h2/dotJopl9Pcr6EXDFWynie+gJu2uRJVkryxgaPpGFsqRSmYxyiR6NOh0YQk1QHZ1qAC9Oj2m0Au44VPLCJd+Eb6KKCSyDuZism2IIsGGKvMzcf48KycJxWQNWhpFtt+RGMx8XvLPRF1BrctBV7JJxEPZq7VHxH+INzLwkw9YJJGpueJrIuKYGwL1EI6D92y2U2v83Z+D0ht/31EXd8H3Yz6HFtSWvdE22LFw1ckqKDKRNpT2X7qdDwfBclAnseYlQHI8YhL3/kymgk4iWPLBusNdmnrsG2Ba8vEqjw1fmr92wN/0Ly1vo+vQN0ABZTkkl5y9APmcmGE/EbSrQy91GcoPMUv18toDg4b7uDddMOKbc+mcQSJMxmn696Jd+UBF/dsuoDxu5kYWtnGEMIHunUTtn0Py8BMsbBpOmgOFrEclH/h7X2lxFVRXr8ns/wwcTDJ1qRldbSnefaIB3X3bH3/zhs6R0K8krRfpdxmfHjaxqtB7Vas2XfaUf6IlK+dw7qJzYQo37n2fqTCdVZiZouhu2UECbvVjKCEjhhNWqAsWLOL2t8vEIqq9t2c1nUX1aDhwG1G6nQ6iBUArsm/3Gej4bHJmW2vtPecXdaI2ZwXoFJ2nU892EmNK8WIHlZkA/lzLCYWSIWIhb6CjafPghQ0jBEPpz8Twh7qzaIvmP/Wu45FbsY3xtzaH8XdKPcCFFzwKan4GAl8nm2FyQbwsKUKqvG3F5nr7/pezUy3TwxhjiRIj4qSnS+Dc/CpwO3hKNaA/9+GGulkQtNbNKQvYD9dPiZ256c1qqtNWTCa7f1TYp/WTBxkjrjofQ3FV5ncfl1wDhFfDkEMDNGOlmjw8MWpKqjohsET1/1AcMhghd3TdHiQbLvqzDzqMKeCk
 /sUWBSiH
 zTMGA79oVCw19dour5M55b1HLQLIYXrcz8LFqmTyxCoOU4LHNisNJF2aWQyt1JhhWyvBTTsiVZ1JqOklOC/frtlIB58Ykt2T00ryKaTfXwcVnZQ0l/FZcY4DYhR2qKsT8OTlGoBbNHg85WxgDx6L6JEmw8rRuhF+YYBwsiJTkAIywdL4UVbAmNHyjX+wkFhe7tJC5Oo9AFB52gM4Pekrjz4E12F8Zk64PfRPT4LMTPqPa+auZ/hBkNL3SeB5CxPVLmvvi18KVT6uqTw6AVquHmFBquRYWv7j6FrELVTdQkh7gF7qB3nI+Zgxm0kwNaVIHrbrhaEYhSZ8Blboqw6TKN6na+fWnOLHnXgyDeQd9rW3skiclRKJ9y7FmBZaoMShQ/LV9F59vViMYv8GI5xJGsuenxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:45, Luiz Capitulino wrote:
> Despite its name, thp_disabled_by_hw() just checks whether the
> architecture supports PMD-sized pages. It returns true when
> TRANSPARENT_HUGEPAGE_UNSUPPORTED is set in transparent_hugepage_flags,
> this only occurs if the architecture implements arch_has_pmd_leaves()
> and that function returns false.
> 
> Since pgtable_has_pmd_leaves() provides the same semantics, use it
> instead.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Yes, that's a nice cleanup.

-- 
Cheers,

David

